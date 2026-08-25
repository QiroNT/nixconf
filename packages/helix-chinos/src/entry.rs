use std::{panic::AssertUnwindSafe, sync::Arc};

use abi_stable::std_types::{RBoxError, RResult, RString};
use compio::dispatcher::Dispatcher;
use eyre::Context;
use eyre::eyre;
use futures::FutureExt;
use helix_chinos_macros::ffi_impl;
use steel::{
    rvals::Custom,
    steel_vm::ffi::{FFIValue, FfiFuture, FfiFutureExt, IntoFFIVal},
};

use crate::{
    panic::take_last_panic,
    util::ffi::{FFIFutureResultExt, FFIResultExt},
};

pub struct HelixChinosInner {
    dispatcher: Dispatcher,
}

pub struct HelixChinos(Arc<HelixChinosInner>);

#[ffi_impl]
impl HelixChinos {
    fn ffi_new() -> RResult<FFIValue, RBoxError> {
        Self::new().unwrap_rerr()
    }

    fn ffi_format(&self, s: String, tab_width: usize) -> FfiFuture<RResult<FFIValue, RBoxError>> {
        self.dispatch(async move |inner| inner.format(s, tab_width).await)
    }

    fn ffi_lorem(&self, count: usize) -> FfiFuture<RResult<FFIValue, RBoxError>> {
        self.dispatch(async move |inner| inner.lorem(count).await)
    }
}

impl HelixChinos {
    fn new() -> eyre::Result<Self> {
        Ok(Self(Arc::new(HelixChinosInner {
            dispatcher: Dispatcher::new()?,
        })))
    }

    fn dispatch<T: IntoFFIVal>(
        &self,
        f: impl AsyncFnOnce(&HelixChinosInner) -> eyre::Result<T> + Send + Sync + 'static,
    ) -> FfiFuture<RResult<FFIValue, RBoxError>> {
        let inner = self.0.clone();

        let rx = self.0.dispatcher.dispatch(move || async move {
            AssertUnwindSafe(f(inner.as_ref()))
                .catch_unwind()
                .await
                .map(FFIResultExt::unwrap_rerr)
                .map_err(|err| {
                    #[allow(clippy::option_if_let_else, reason = "callback hell")]
                    if let Some(s) = take_last_panic() {
                        eyre!(s)
                    } else if let Some(s) = err.downcast_ref::<String>() {
                        eyre!("panicked: {}", s)
                    } else if let Some(s) = err.downcast_ref::<&'static str>() {
                        eyre!("panicked: {}", s)
                    } else {
                        eyre!("panicked: Unknown")
                    }
                })
                .unwrap_rerr()
        });

        async {
            rx.wrap_err("failed to dispatch future")?
                .await
                .wrap_err("join handle canceled")
        }
        .unwrap_rerr()
        .into_ffi()
    }
}

impl Custom for HelixChinos {
    fn fmt_ffi(&self) -> Option<RString> {
        Some("#<HelixChinos>".into())
    }
}
