use itertools::Itertools;
use memchr::memchr_iter;
use textwrap::{WordSeparator, WordSplitter, core::Word, wrap};
use unicode_width::UnicodeWidthChar;

use crate::format::util::is_unescaped;

pub trait LineSink {
    fn push_line(&mut self, line: String);
    fn push_empty(&mut self) {
        self.push_line(String::new());
    }
}

impl LineSink for Vec<String> {
    fn push_line(&mut self, mut line: String) {
        line.truncate(line.trim_end().len());
        if !line.is_empty() || self.last().is_none_or(|s| !s.is_empty()) {
            self.push(line);
        }
    }
}

pub trait LineTransform {
    fn transform(&mut self, line: &mut String);
}

impl<F: FnMut(&mut String)> LineTransform for F {
    fn transform(&mut self, line: &mut String) {
        self(line);
    }
}

pub struct BlockSink<'a, P: LineSink, T: LineTransform> {
    parent: &'a mut P,
    transform: T,
    width: usize,
    tab_width: usize,
}

impl<P: LineSink, T: LineTransform> LineSink for BlockSink<'_, P, T> {
    fn push_line(&mut self, mut line: String) {
        self.transform.transform(&mut line);
        self.parent.push_line(line);
    }
}

impl<'a, P: LineSink, T: LineTransform> BlockSink<'a, P, T> {
    pub const fn new(parent: &'a mut P, transform: T, width: usize, tab_width: usize) -> Self {
        Self {
            parent,
            transform,
            width,
            tab_width,
        }
    }

    pub fn buffered<R>(
        &self,
        f: impl FnOnce(&mut BlockSink<'_, Vec<String>, TransformIdent>) -> R,
    ) -> (R, impl FnOnce(&mut Self) + 'static) {
        let mut buf = vec![];
        (
            f(&mut BlockSink::new(
                &mut buf,
                TransformIdent,
                self.width,
                self.tab_width,
            )),
            move |s| {
                for line in buf {
                    s.push_line(line);
                }
            },
        )
    }

    pub fn indented(
        &mut self,
        indent: &str,
        f: impl FnOnce(&mut BlockSink<'_, Self, TransformIndent>),
    ) {
        let indent_width = indent
            .chars()
            .map(|c| match c {
                // hope you're not mixing spaces in tabs, that would be horrifying
                '\t' => self.tab_width,
                c => c.width().unwrap_or(0),
            })
            .sum::<usize>();
        f(&mut BlockSink::new(
            self,
            TransformIndent(indent),
            self.width - indent_width,
            self.tab_width,
        ));
    }

    pub fn push_refill(&mut self, line: &str) {
        let s = line.split('\n').map(str::trim).join(" ");
        let opts = textwrap::Options::new(self.width)
            .word_separator(WordSeparator::Custom(split_words))
            .word_splitter(WordSplitter::Custom(|_| vec![]))
            .break_words(false);
        let s = wrap(&s, opts);
        for l in s {
            self.push_line(l.to_string());
        }
    }
}

pub struct TransformIdent;

impl LineTransform for TransformIdent {
    fn transform(&mut self, line: &mut String) {}
}

pub struct TransformIndent<'a>(&'a str);

impl LineTransform for TransformIndent<'_> {
    fn transform(&mut self, line: &mut String) {
        line.insert_str(0, self.0);
    }
}

fn split_words<'a>(mut s: &'a str) -> Box<dyn Iterator<Item = Word<'a>> + '_> {
    let mut words = vec![];
    loop {
        let Some(open) = find_unescaped_backtick(s.as_bytes()) else {
            words.extend(WordSeparator::AsciiSpace.find_words(s));
            break;
        };
        let unquoted;
        (unquoted, s) = s.split_at(open);
        words.extend(WordSeparator::AsciiSpace.find_words(unquoted));

        let Some(close_rel) = find_unescaped_backtick(&s.as_bytes()[1..]) else {
            words.push(Word::from(s));
            break;
        };
        let mut after_close = close_rel + 2;
        while s[after_close..]
            .chars()
            .next()
            .is_some_and(|c| c.is_whitespace() || c.is_ascii_punctuation())
        {
            after_close += 1;
        }

        let quoted;
        (quoted, s) = s.split_at(after_close);
        words.push(Word::from(quoted));
    }
    Box::new(words.into_iter())
}

fn find_unescaped_backtick(bytes: &[u8]) -> Option<usize> {
    memchr_iter(b'`', bytes).find(|pos| is_unescaped(&bytes[..*pos]))
}
