#set -x CXX "ccache clang++"
#set -x CC "ccache clang"
set -x DEVEL_PREFIX ~/local/prefix
set -x LD_LIBRARY_PATH $DEVEL_PREFIX/lib
set -x PKG_CONFIG_PATH $DEVEL_PREFIX/lib/pkgconfig
