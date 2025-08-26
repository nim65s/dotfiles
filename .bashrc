for d in /run/system-manager/sw/bin ~/.nix-profile/bin ~/.local/bin
do
  if [[ -d $d && ":$PATH:" != *":$d:"* ]]
  then
    export PATH="$d:$PATH"
  fi
done
command direnv > /dev/null && eval "$(direnv hook bash)"
