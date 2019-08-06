set -x ROBOTPKG_BASE /home/nim/local/robotpkg/install
set -x PKG_CONFIG_PATH $ROBOTPKG_BASE/lib/pkgconfig/
set -x PATH $ROBOTPKG_BASE/bin $PATH
set -x LD_LIBRARY_PATH $ROBOTPKG_BASE/lib
set -x ROS_PACKAGE_PATH $ROBOTPKG_BASE/share
