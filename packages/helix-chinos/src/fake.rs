use fake::Fake;

use crate::entry::HelixChinosInner;

impl HelixChinosInner {
    #[allow(clippy::unused_async, clippy::unused_async_trait_impl)]
    pub(crate) async fn lorem(&self, count: usize) -> eyre::Result<String> {
        Ok(fake::faker::lorem::en::Paragraph(count..count + 1).fake())
    }
}
