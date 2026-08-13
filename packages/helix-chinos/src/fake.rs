use fake::Fake;

use crate::entry::HelixChinosInner;

impl HelixChinosInner {
    pub(crate) async fn lorem(&self, count: usize) -> eyre::Result<String> {
        Ok(fake::faker::lorem::en::Paragraph(count..count + 1).fake())
    }
}
