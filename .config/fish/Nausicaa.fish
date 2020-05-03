#set -x DEVEL_PREFIX ~/local/prefix
#set -x LD_LIBRARY_PATH $DEVEL_PREFIX/lib
#set -x PKG_CONFIG_PATH $DEVEL_PREFIX/lib/pkgconfig

set -e IDF_PATH

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
test -d $ROBOTPKG_BASE/var/db/robotpkg
and set -x PKG_DBDIR $ROBOTPKG_BASE/var/db/robotpkg

test -d /home/nim/celeste/ESP/esp-idf
and set -x IDF_PATH /home/nim/celeste/ESP/esp-idf

test -d /home/nim/misc/ESP/esp-idf
and set -x IDF_PATH /home/nim/misc/ESP/esp-idf

set -x DOCKER_BUILDKIT 1
