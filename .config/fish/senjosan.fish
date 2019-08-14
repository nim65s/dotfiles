function ii
    cd
    while true
        pass test
        and vdirsyncer sync
        and echo fini
        or echo fail
        date
        sleep 300
    end
end

function rosenv
    set -x FISH_ROS_ENV $PWD
    echo "set FISH_ROS_ENV to $FISH_ROS_ENV"
    bash
end

function y
    apt search $argv
end

set -x BROWSER firefox

alias td todoman
