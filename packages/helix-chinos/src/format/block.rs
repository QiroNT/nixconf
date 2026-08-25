use std::collections::VecDeque;

use crate::format::sink::{BlockSink, LineSink};

pub trait Block: Sized {
    fn format(
        lines: &mut VecDeque<String>,
        sink: &mut BlockSink<'_, impl LineSink, impl FnMut(&mut String)>,
    ) -> bool;
}

struct Fence;

impl Block for Fence {
    fn format(
        lines: &mut VecDeque<String>,
        sink: &mut BlockSink<'_, impl LineSink, impl FnMut(&mut String)>,
    ) -> bool {
        false
    }
}

struct List;

impl Block for List {
    fn format(
        lines: &mut VecDeque<String>,
        sink: &mut BlockSink<'_, impl LineSink, impl FnMut(&mut String)>,
    ) -> bool {
        false
    }
}

struct Comment;

impl Block for Comment {
    fn format(
        lines: &mut VecDeque<String>,
        sink: &mut BlockSink<'_, impl LineSink, impl FnMut(&mut String)>,
    ) -> bool {
        false
    }
}

struct Table;

impl Block for Table {
    fn format(
        lines: &mut VecDeque<String>,
        sink: &mut BlockSink<'_, impl LineSink, impl FnMut(&mut String)>,
    ) -> bool {
        false
    }
}

struct Align;

impl Block for Align {
    fn format(
        lines: &mut VecDeque<String>,
        sink: &mut BlockSink<'_, impl LineSink, impl FnMut(&mut String)>,
    ) -> bool {
        false
    }
}

pub struct Paragraph;

impl Block for Paragraph {
    fn format(
        lines: &mut VecDeque<String>,
        sink: &mut BlockSink<impl LineSink, impl FnMut(&mut String)>,
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
            macro_rules! try_format {
                ($i:ident) => {
                    $i::format(lines, sink)
                };
                ($i:ident, $($t:tt)*) => {
                    try_format!($i) || try_format!($($t)*)
                };
            }
            if try_format![Fence, List, Comment, Table, Align] {
                flush_par!();
                continue;
            }

            let Some(line) = lines.pop_front() else {
                flush_par!();
                break;
            };
            let (indent, line) = infer_indent(&line);
            if line.is_empty() {
                flush_par!();
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
