#!/usr/bin/fish

set -x DEVEL_DIR ~/devel/ba-systemes
set -x DEVEL_PREFIX $DEVEL_DIR/install
set -x PATH $DEVEL_PREFIX/sbin $DEVEL_PREFIX/bin $PATH
set -x PKG_CONFIG_PATH $DEVEL_PREFIX/lib/pkgconfig
set -x PYTHONPATH $DEVEL_PREFIX/lib/python2.7/site-packages
set -x LD_LIBRARY_PATH $DEVEL_PREFIX/lib
set -x ROS_PACKAGE_PATH $DEVEL_PREFIX/share

if test -f ~/.gpg-agent-info
    . ~/.gpg-agent-info
end
