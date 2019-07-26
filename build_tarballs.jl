using BinaryBuilder

# Collection of sources required to build Xsum
sources = [
    "https://github.com/Cyan4973/xxHash" =>
    "810f9d209b65cc523c159ca96fddd614d890a5e2", # version 2019-03-15 "0.7"
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/xsum
mkdir -p ${prefix}/lib
if [[ $target == i686-* ]]; then
    xxhashfpmath="-mfpmath=sse"
fi
${CC} ${LDFLAGS} -shared -fPIC -O3 -std=c99 ${xxhashfpmath} -fno-inline-functions -o ${prefix}/lib/libxxhash.${dlext} xxhash.c xxhashsum.c
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms() # build on all supported platforms

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libxxhash", :libxxhas),
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "xxhash", v"0.7", sources, script, platforms, products, dependencies)

println("Contents of ", pwd(), " = ", readdir("."))
if isdir("products")
    println("PRODUCTS = ", readdir("products"))
else
    println("products/ directory not found")
end
