use std::collections::VecDeque;

use crate::format::{
    sink::{BlockSink, LineSink, LineTransform},
    util::find_unescaped_str,
};

pub trait Block: Sized {
    fn format(
        lines: &mut VecDeque<String>,
        sink: &mut BlockSink<'_, impl LineSink, impl LineTransform>,
    ) -> bool;
}

struct Fence;

impl Block for Fence {
    fn format(
        lines: &mut VecDeque<String>,
        sink: &mut BlockSink<'_, impl LineSink, impl LineTransform>,
    ) -> bool {
        let Some(first) = lines.pop_front() else {
            return false;
        };
        let Some((indent, fence, lang)) = parse_fence(&first) else {
            lines.push_front(first);
            return false;
        };

        let mut codes = VecDeque::new();
        while let Some(line) = lines.pop_front() {
            let line_str = strip_indent(&line, indent);

            if let Some(pos) = find_unescaped_str(line_str.as_bytes(), fence.as_bytes()) {
                let (line_str, rest) = line_str.split_at(pos);
                let line_str = line_str.trim_end();
                if !line_str.is_empty() {
                    codes.push_back(line_str.to_string());
                }

                codes.push_back(fence.to_string());

                let (_, rest) = rest.split_at(fence.len());
                let rest = rest.trim();
                if !rest.is_empty() {
                    lines.push_front(rest.to_string());
                }

                break;
            }

            codes.push_back(line_str.trim_end().to_string());
        }

        sink.indented(indent, |sink| {
            sink.push_empty();

            sink.push_line(format!("{}{}", fence, lang.trim()));
            loop {
                if Comment::format(&mut codes, sink) {
                    continue;
                }
                let Some(line) = codes.pop_front() else {
                    break;
                };
                sink.push_line(line);
            }

            sink.push_empty();
        });

        true
    }
}

fn parse_fence(line: &str) -> Option<(&str, &str, &str)> {
    let (indent, s) = infer_indent(line);
    s.split_at_checked(3)
        .filter(|&(fence, _)| matches!(fence, "```" | "~~~"))
        .map(|(fence, lang)| (indent, fence, lang))
}

fn strip_indent<'a>(s: &'a str, indent: &str) -> &'a str {
    let offset = s
        .chars()
        .zip(indent.chars())
        .take_while(|(a, b)| a == b)
        .map(|(c, _)| c.len_utf8())
        .sum::<usize>();
    &s[offset..]
}

struct Comment;

impl Block for Comment {
    fn format(
        lines: &mut VecDeque<String>,
        sink: &mut BlockSink<'_, impl LineSink, impl LineTransform>,
    ) -> bool {
        false
    }
}

struct List;

impl Block for List {
    fn format(
        lines: &mut VecDeque<String>,
        sink: &mut BlockSink<'_, impl LineSink, impl LineTransform>,
    ) -> bool {
        false
    }
}

struct Table;

impl Block for Table {
    fn format(
        lines: &mut VecDeque<String>,
        sink: &mut BlockSink<'_, impl LineSink, impl LineTransform>,
    ) -> bool {
        false
    }
}

struct Align;

impl Block for Align {
    fn format(
        lines: &mut VecDeque<String>,
        sink: &mut BlockSink<'_, impl LineSink, impl LineTransform>,
    ) -> bool {
        false
    }
}

pub struct Paragraph;

impl Block for Paragraph {
    fn format(
        lines: &mut VecDeque<String>,
        sink: &mut BlockSink<impl LineSink, impl LineTransform>,
    ) -> bool {
        let mut par: Option<(String, String)> = None;
        macro_rules! flush_par {
            () => {
                if let Some((indent, content)) = par.take() {
                    sink.indented(&indent, |sink| {
                        sink.push_refill(&content);
                    });
                }
            };
        }

        loop {
            let (res, flush) = sink.buffered(|sink| {
                macro_rules! try_format {
                    ($i:ident) => {
                        $i::format(lines, sink)
                    };
                    ($i:ident, $($t:tt)*) => {
                        try_format!($i) || try_format!($($t)*)
                    };
                }
                try_format![Fence, List, Comment, Table, Align]
            });
            if res {
                flush_par!();
                flush(sink);
                continue;
            }

            let Some(line) = lines.pop_front() else {
                flush_par!();
                break;
            };
            let (indent, line) = infer_indent(&line);
            if line.is_empty() {
                flush_par!();
                sink.push_empty();
                continue;
            }
            let (_, content) = par.get_or_insert_with(|| (indent.to_string(), String::new()));
            content.push_str(line.trim_end());
            content.push(' ');
        }

        true
    }
}

fn infer_indent(s: &str) -> (&str, &str) {
    let start = s
        .chars()
        .position(|c| !c.is_whitespace())
        .unwrap_or(s.len());
    s.split_at(start)
}
