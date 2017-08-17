function ii
    cd
    while true
        pass test
        and vdirsyncer sync
        and rsync -avP --delete .vdir root@jiro.saurel.me:
        and echo fini
        or echo fail
        sleep 300
    end
end
