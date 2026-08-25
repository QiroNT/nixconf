use std::collections::VecDeque;

use crate::{
    entry::HelixChinosInner,
    format::{
        block::{Block, Paragraph},
        sink::BlockSink,
    },
};

mod block;
mod sink;
mod util;

impl HelixChinosInner {
    #[allow(clippy::unused_async, clippy::unused_async_trait_impl)]
    pub(crate) async fn format(&self, s: String, tab_width: usize) -> eyre::Result<String> {
        let rn = s.contains("\r\n");
        let s = s.replace("\r\n", "\n");

        let mut lines = s.lines().map(ToOwned::to_owned).collect::<VecDeque<_>>();

        let tailing_newline = s.ends_with('\n');

        let mut out = vec![];
        let mut sink = BlockSink::new(&mut out, |_: &mut String| {}, 75, tab_width);
        Paragraph::format(&mut lines, &mut sink);

        if tailing_newline {
            out.push(String::new());
        }

        Ok(out.join(if rn { "\r\n" } else { "\n" }))
    }
}
