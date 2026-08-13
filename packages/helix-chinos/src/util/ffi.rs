use abi_stable::std_types::{
    RBoxError,
    RResult::{self, RErr},
};
use steel::steel_vm::ffi::{FFIValue, IntoFFIVal};

use crate::prelude::*;

#[extension(pub trait FFIResultExt)]
impl<T: IntoFFIVal> eyre::Result<T> {
    fn unwrap_rerr(self) -> RResult<FFIValue, RBoxError> {
        self.map(|v| v.into_ffi_val())
            .unwrap_or_else(|err| RErr(RBoxError::from_box(err.into())))
    }
}

#[extension(pub trait FFIFutureResultExt)]
impl<T: IntoFFIVal, F: Future<Output = eyre::Result<T>>> F {
    async fn unwrap_rerr(self) -> RResult<FFIValue, RBoxError> {
        self.await.unwrap_rerr()
    }
}
