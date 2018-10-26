#set -x CXX "ccache clang++"
#set -x CC "ccache clang"
set -x DEVEL_PREFIX ~/local/prefix
set -x LD_LIBRARY_PATH $DEVEL_PREFIX/lib
set -x PKG_CONFIG_PATH $DEVEL_PREFIX/lib/pkgconfig

set -x ROBOTPKG_BASE ~/local/robotpkg/install
set -x PKG_CONFIG_PATH $ROBOTPKG_BASE/lib/pkgconfig:$PKG_CONFIG_PATH
set -x CMAKE_PREFIX_PATH $ROBOTPKG_BASE
test -d $ROBOTPKG_BASE/bin
and set -x PATH $ROBOTPKG_BASE/bin $PATH
