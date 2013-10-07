set(cflags "-mminimal-toc -fno-optimize-sibling-calls")
set(cxxflags "-mminimal-toc -fno-optimize-sibling-calls")

set(PYTHON_OPTIONS "")
list(APPEND PYTHON_OPTIONS "-DHAVE_LIBM:STRING=/bgsys/drivers/V1R2M0/ppc64/gnu-linux/powerpc64-bgq-linux/lib/libm.a")
#list(APPEND PYTHON_OPTIONS "-DCMAKE_C_FLAGS:STRING=-mminimal-toc -fno-optimize-sibling-calls")
#list(APPEND PYTHON_OPTIONS "-DCMAKE_CXX_FLAGS:STRING=-mminimal-toc -fno-optimize-sibling-calls")
