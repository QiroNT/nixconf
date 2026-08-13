use std::sync::Arc;

use abi_stable::std_types::{RBoxError, RResult, RString};
use compio::dispatcher::Dispatcher;
use steel::{
    rvals::Custom,
    steel_vm::ffi::{FFIValue, FfiFuture, FfiFutureExt, IntoFFIVal},
};

use crate::{
    prelude::*,
    util::ffi::{FFIFutureResultExt, FFIResultExt},
};

pub(crate) struct HelixChinosInner {
    dispatcher: Dispatcher,
}

pub(crate) struct HelixChinos(Arc<HelixChinosInner>);

impl HelixChinos {
    fn new() -> eyre::Result<Self> {
        Ok(HelixChinos(Arc::new(HelixChinosInner {
            dispatcher: Dispatcher::new()?,
        })))
    }

    fn dispatch<T: IntoFFIVal>(
        &self,
        f: impl AsyncFnOnce(&HelixChinosInner) -> eyre::Result<T> + Send + 'static,
    ) -> FfiFuture<RResult<FFIValue, RBoxError>> {
        let inner = self.0.clone();

        let rx = self
            .0
            .dispatcher
            .dispatch(move || async move { f(inner.as_ref()).await.unwrap_rerr() });

        async {
            rx.map_err(|_| eyre!("failed to dispatch future"))?
                .await
                .map_err(|_| eyre!("join handle canceled"))
        }
        .unwrap_rerr()
        .into_ffi()
    }
}

#[ffi_impl]
impl HelixChinos {
    fn ffi_new() -> RResult<FFIValue, RBoxError> {
        Self::new().unwrap_rerr()
    }

    fn ffi_format(&self, s: String) -> FfiFuture<RResult<FFIValue, RBoxError>> {
        self.dispatch(async move |inner| inner.format(s).await)
    }

    fn ffi_lorem(&self, count: usize) -> FfiFuture<RResult<FFIValue, RBoxError>> {
        self.dispatch(async move |inner| inner.lorem(count).await)
    }
}

impl Custom for HelixChinos {
    fn fmt_ffi(&self) -> Option<RString> {
        Some("#<HelixChinos>".into())
    }
}
