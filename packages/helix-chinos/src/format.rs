use textwrap::refill;

use crate::entry::HelixChinosInner;

impl HelixChinosInner {
    pub(crate) async fn format(&self, s: String) -> eyre::Result<String> {
        let refill = |s: &str| refill(s, textwrap::Options::new(75).break_words(false));
        Ok(refill(&s))
    }
}
