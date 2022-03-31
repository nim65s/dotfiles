set -x ROBOTPKG_BASE ~/local/robotpkg/install
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

set -x DOCKER_BUILDKIT 1
