#!/bin/bash

cargo build || exit 1

unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   dylib_ext='so'
elif [[ "$unamestr" == 'Darwin' ]]; then
   dylib_ext='dylib'
else
   echo "Unsupported os"
   exit 1
fi

RUSTC="rustc -Zcodegen-backend=$(pwd)/target/debug/librustc_codegen_cranelift.$dylib_ext -L crate=."

SHOULD_CODEGEN=1 $RUSTC examples/mini_core.rs --crate-name mini_core --crate-type lib &&
ar x libmini_core.rlib data.o &&
chmod +rw data.o &&
mv data.o mini_core.o &&

$RUSTC examples/example.rs --crate-type lib &&

SHOULD_RUN=1 $RUSTC examples/mini_core_hello_world.rs --crate-type bin &&
$RUSTC examples/mini_core_hello_world.rs --crate-type bin &&
ar x mini_core_hello_world data.o &&
chmod +rw data.o &&
mv data.o mini_core_hello_world.o &&
gcc mini_core.o mini_core_hello_world.o -o mini_core_hello_world &&

$RUSTC target/libcore/src/libcore/lib.rs --color=always --crate-type lib -Cincremental=target/libcore/incremental 2>&1 | (head -n 20; echo "===="; tail -n 1000)
cat target/log.txt | sort | uniq -c | grep -v "rval unsize move" | grep -v "rval len"
#rm *.rlib *.o target/log.txt
