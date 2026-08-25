use memchr::memmem;

pub fn is_unescaped(bytes: &[u8]) -> bool {
    let slashes = bytes
        .iter()
        .rev()
        .position(|c| *c != b'\\')
        .unwrap_or(bytes.len());
    slashes.is_multiple_of(2)
}

pub fn find_unescaped_str(bytes: &[u8], needle: &[u8]) -> Option<usize> {
    memmem::find_iter(bytes, needle).find(|&pos| is_unescaped(&bytes[..pos]))
}
