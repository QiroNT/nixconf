use proc_macro::TokenStream;
use quote::ToTokens;
use syn::{parse::Nothing, parse_macro_input};

use crate::ffi_impl::FfiImpl;

mod ffi_impl;

#[proc_macro_attribute]
pub fn ffi_impl(args: TokenStream, item: TokenStream) -> TokenStream {
    parse_macro_input!(args as Nothing);
    parse_macro_input!(item as FfiImpl)
        .into_token_stream()
        .into()
}
