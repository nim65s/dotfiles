#set -x DEVEL_PREFIX ~/local/prefix
#set -x LD_LIBRARY_PATH $DEVEL_PREFIX/lib
#set -x PKG_CONFIG_PATH $DEVEL_PREFIX/lib/pkgconfig

set -x ROBOTPKG_BASE ~/local/robotpkg/install
set -x PKG_CONFIG_PATH $ROBOTPKG_BASE/lib/pkgconfig:$ROBOTPKG_BASE/share/pkgconfig:$PKG_CONFIG_PATH
set -x CMAKE_PREFIX_PATH $ROBOTPKG_BASE
test -d $ROBOTPKG_BASE/bin
and set -x PATH $ROBOTPKG_BASE/bin $PATH
test -d $ROBOTPKG_BASE/sbin
and set -x PATH $ROBOTPKG_BASE/sbin $PATH
test -d $ROBOTPKG_BASE/lib
and set -x LD_LIBRARY_PATH $ROBOTPKG_BASE/lib $LD_LIBRARY_PATH
test -d $ROBOTPKG_BASE/share
and set -x ROS_PACKAGE_PATH $ROBOTPKG_BASE/share $ROS_PACKAGE_PATH
