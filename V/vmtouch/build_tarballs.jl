# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "vmtouch"
version = v"1.3.1"

# Collection of sources required to complete build
sources = [
    "https://github.com/hoytech/vmtouch/archive/v1.3.1.tar.gz" =>
    "d57b7b3ae1146c4516429ab7d6db6f2122401db814ddd9cdaad10980e9c8428c",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/vmtouch-*/
export PREFIX=$prefix
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    Linux(:i686, libc=:musl),
    Linux(:x86_64, libc=:musl),
    Linux(:aarch64, libc=:musl),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf),
    MacOS(:x86_64),
    FreeBSD(:x86_64)
]

# The products that we will ensure are always built
products = [
    ExecutableProduct("vmtouch", :vmtouch)
]

# Dependencies that must be installed before this package can be built
dependencies = [

]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
