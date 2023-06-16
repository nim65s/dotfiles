if test -z "$NO_FISH"
then
    for fish in /home/gsaurel/.nix-profile/bin/fish /usr/bin/fish
    do
        test -x $fish && exec $fish
    done
fi
