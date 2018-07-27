function ii
    cd
    while true
        pass test
        and vdirsyncer sync
        and echo fini
        or echo fail
        sleep 300
    end
end

set -x SSH_AUTH_SOCK /home/gsaurel/.gnupg/S.gpg-agent.ssh

function rosenv
    set -x FISH_ROS_ENV $PWD
    echo "set FISH_ROS_ENV to $FISH_ROS_ENV"
    bash
end

set -x BROWSER firefox
