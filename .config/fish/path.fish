for bin in /bin \
           /usr/bin \
           /usr/local/bin \
           /run/current-system/sw/bin \
           /nix/var/nix/profiles/default/bin \
           /etc/profiles/per-user/nim/bin \
           /opt/openrobots/bin \
           ~/.nix-profile/bin \
           ~/.cargo/bin \
           ~/.local/bin \
           /run/wrappers/bin
    if test -d $bin
        if echo $PATH | grep -vq $bin
            set -pgx PATH $bin
        end
    end
end


