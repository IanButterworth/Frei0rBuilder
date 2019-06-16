# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder
name = "Frei0r"
version = v"1.6.1"
# Collection of sources required to build imagemagick

sources = [
    "https://files.dyne.org/frei0r/frei0r-plugins-1.6.1.tar.gz" =>
    "af00bb5a784e7c9e69f56823de4637c350643deedaf333d0fa86ecdba6fcb415",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd frei0r-plugins-1.6.1/
./configure --prefix=$prefix --host=$target
make -j${ncore}
make install
exit
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    # Windows
    Windows(:i686),
    Windows(:x86_64),

    # linux
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc),
    Linux(:powerpc64le, :glibc),

    # musl
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl),

    # The BSD's
    FreeBSD(:x86_64),
    MacOS(:x86_64),
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "addition", :addition),
]

# Dependencies that must be installed before this package can be built
dependencies = [

]


# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
