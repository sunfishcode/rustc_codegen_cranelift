# Work in progress cranelift codegen backend for rust

> ⚠⚠⚠ This doesn't do much useful yet ⚠⚠⚠

## Building

```bash
$ git clone https://github.com/bjorn3/rustc_codegen_cranelift.git
$ cd rustc_codegen_cranelift
$ rustup override set nightly
$ cargo install xargo
$ git submodule update --init
$ cargo build
```

## Usage

```bash
$ rustc -Zcodegen-backend=$(pwd)/target/debug/librustc_codegen_cranelift.so my_crate.rs --crate-type lib -Og
```

## Building libcore

```bash
$ rustup component add rust-src
$ ./prepare_libcore.sh
$ ./build.sh
```

## Not yet supported

* Checked binops
* Drop glue

* Other call abi's
* Sub slice

* Inline assembly
* Custom sections
