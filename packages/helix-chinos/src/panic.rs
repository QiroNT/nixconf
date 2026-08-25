use std::{cell::Cell, io, panic, sync::Arc};

thread_local! {
    static LAST_PANIC: Cell<Option<Vec<u8>>> =
        const { Cell::new(None) };
}

pub fn install_panic_capture() {
    panic::update_hook(|default_hook, info| {
        let previous_capture = io::set_output_capture(Some(Arc::default()));
        default_hook(info);
        let captured = io::set_output_capture(previous_capture);

        let bytes = match Arc::try_unwrap(captured.expect("we've just set one"))
            .expect("nobody should be holding it")
            .into_inner()
        {
            Ok(buf) => buf,
            Err(poisoned) => poisoned.into_inner(),
        };

        LAST_PANIC.with(|slot| {
            slot.set(Some(bytes));
        });
    });
}

pub fn take_last_panic() -> Option<String> {
    LAST_PANIC.with(|slot| {
        slot.take()
            .map(|bytes| String::from_utf8_lossy(&bytes).into_owned())
    })
}
