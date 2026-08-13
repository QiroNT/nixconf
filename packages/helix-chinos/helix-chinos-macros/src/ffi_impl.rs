use proc_macro2::TokenStream;
use quote::{ToTokens, quote};
use syn::{ImplItem, ItemImpl, Type, parse::Parse, parse_quote};

pub(crate) struct FfiImpl {
    item_impl: ItemImpl,
}

impl Parse for FfiImpl {
    fn parse(input: syn::parse::ParseStream) -> syn::Result<Self> {
        let mut item_impl = input.parse::<ItemImpl>()?;

        let type_name = get_type_name(&item_impl)?;

        let methods = item_impl
            .items
            .iter()
            .filter_map(|item| match item {
                ImplItem::Fn(method) => Some(method),
                _ => None,
            })
            .map(|method| {
                let ident = &method.sig.ident;
                let name = format!(
                    "{type_name}-{}",
                    ident
                        .to_string()
                        .trim_start_matches("r#")
                        .trim_start_matches("ffi_")
                        .replace("_", "-")
                );
                quote! {
                    module.register_fn(#name, Self::#ident);
                }
            })
            .collect::<Vec<_>>();

        item_impl.items.push(parse_quote! {
            pub fn ffi_register(module: &mut ::steel::steel_vm::ffi::FFIModule) {
                use ::steel::steel_vm::ffi::RegisterFFIFn;
                #(#methods)*
            }
        });

        Ok(Self { item_impl })
    }
}

fn get_type_name(item_impl: &ItemImpl) -> syn::Result<String> {
    let path = match item_impl.self_ty.as_ref() {
        Type::Path(path) if path.qself.is_none() => path,
        ty => {
            return Err(syn::Error::new_spanned(ty, "expected a named type"));
        }
    };

    let seg = path
        .path
        .segments
        .last()
        .ok_or_else(|| syn::Error::new_spanned(path, "expected a named type"))?;

    let ident = seg.ident.to_string().trim_start_matches("r#").to_string();

    Ok(ident)
}

impl ToTokens for FfiImpl {
    fn to_tokens(&self, tokens: &mut TokenStream) {
        self.item_impl.to_tokens(tokens);
    }
}
