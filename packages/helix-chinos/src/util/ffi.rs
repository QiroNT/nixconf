use abi_stable::std_types::{
    RBoxError,
    RResult::{self, RErr},
};
use extension_traits::extension;
use steel::steel_vm::ffi::{FFIValue, IntoFFIVal};

#[extension(pub trait FFIResultExt)]
impl<T: IntoFFIVal> eyre::Result<T> {
    fn unwrap_rerr(self) -> RResult<FFIValue, RBoxError> {
        self.map_or_else(|err| RErr(err.into_rerr()), IntoFFIVal::into_ffi_val)
    }
}

#[extension(pub trait FFIFutureResultExt)]
impl<T: IntoFFIVal, F: Future<Output = eyre::Result<T>>> F {
    async fn unwrap_rerr(self) -> RResult<FFIValue, RBoxError> {
        self.await.unwrap_rerr()
    }
}

#[extension(pub trait FFIReportExt)]
impl eyre::Report {
    fn into_rerr(self) -> RBoxError {
        RBoxError::from_box(self.into())
    }
}
