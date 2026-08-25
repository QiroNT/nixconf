#![feature(internal_output_capture)]
#![feature(panic_update_hook)]

use steel::{declare_module, steel_vm::ffi::FFIModule};

use crate::entry::HelixChinos;

mod entry;
mod fake;
mod format;
mod panic;
mod util;

declare_module!(create_module);

pub(crate) fn create_module() -> FFIModule {
    panic::install_panic_capture();

    let mut module = FFIModule::new("helix-chinos");
    HelixChinos::ffi_register(&mut module);
    module
}
