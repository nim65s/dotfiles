set -x MINIKUBE_WANTUPDATENOTIFICATION false
set -x MINIKUBE_WANTREPORTERRORPROMPT false
set -x MINIKUBE_HOME $HOME
set -x CHANGE_MINIKUBE_NONE_USER true
set -x KUBECONFIG $HOME/.kube/config

set -x ROBOTPKG_BASE /opt/openrobots
set -x PKG_CONFIG_PATH $ROBOTPKG_BASE/lib/pkgconfig/