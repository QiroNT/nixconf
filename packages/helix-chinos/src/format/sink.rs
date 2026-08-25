use itertools::Itertools;
use memchr::memchr;
use textwrap::{WordSeparator, WordSplitter, core::Word, wrap};
use unicode_width::UnicodeWidthChar;

pub trait LineSink {
    fn push_line(&mut self, s: String);
}

impl LineSink for Vec<String> {
    fn push_line(&mut self, s: String) {
        self.push(s);
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
    fn push_line(&mut self, mut s: String) {
        self.transform.transform(&mut s);
        self.parent.push_line(s);
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

    pub fn indented<F: FnOnce(&mut BlockSink<'_, Self, TransformIndent>)>(
        &mut self,
        indent: &str,
        f: F,
    ) {
        let width = indent
            .chars()
            .map(|c| match c {
                // hope you're not mixing spaces in tabs, that would be horrifying
                '\t' => self.tab_width,
                c => c.width_cjk().unwrap_or(0),
            })
            .sum::<usize>();
        f(&mut BlockSink::new(
            self,
            TransformIndent(indent),
            self.width - width,
            self.tab_width,
        ));
    }

    pub fn push_refill(&mut self, s: &str) {
        let s = s.split('\n').map(str::trim).join(" ");
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
            .is_some_and(|c| c == ' ' || c.is_ascii_punctuation())
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
    let mut offset = 0;
    while let Some(rel) = memchr(b'`', &bytes[offset..]) {
        let i = offset + rel;

        let slashes = bytes[..i]
            .iter()
            .rev()
            .position(|c| *c != b'\\')
            .unwrap_or(i);
        if slashes.is_multiple_of(2) {
            return Some(i);
        }

        offset = i + 1;
    }

    None
}
