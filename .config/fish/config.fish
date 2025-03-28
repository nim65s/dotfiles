set -q XDG_CONFIG_HOME || set -x XDG_CONFIG_HOME ~/.config
set -q DOTFILES || set -x DOTFILES ~/dotfiles

for d in ~/.nix-profile/share/fish/vendor_completions.d
    if test -d $d
        if echo $fish_complete_path | grep -vq $d
            set -pgx fish_complete_path $d
        end
    end
end

function fairytail
    tail -n 100 -F $argv | ccze -A
end

function df
    which dfc &>/dev/null
    and dfc -Tdsq name
    or /bin/df -h
end

function ii
    cd
    while true
        pass test
        and imapfilter
        and offlineimap
        and ~/scripts/nmnnn.sh
        and vdirsyncer sync
        #and ~/scripts/rtt.py -np ~/Nextcloud/rtt.json
        and echo fini
        or echo fail
        date
        sleep 1800
    end
end

function srihash
    switch $argv
        case '*://*'
            curl -s $argv | openssl dgst -sha384 -binary | openssl base64 -A
        case '*'
            openssl dgst -sha384 -binary $argv | openssl base64 -A
    end
end

. $DOTFILES/portable-aliases.sh

#set -x JAVA_HOME /opt/java
set -x _JAVA_OPTIONS '-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dawt.useSystemAAFontSettings=lcd'
#set -x TERM xterm-256color
set -x CTEST_PARALLEL_LEVEL (nproc)
#set -x ORBInitRef NameService=corbaname::localhost

set -q GOPATH || set -x GOPATH ~/go

#set -q LS_COLORS || set -x LS_COLORS 'rs=0:di=01;33:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'

set -x UID (id -u $USER)
#set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

set -x GIT_SSH_COMMAND 'ssh -o ControlMaster=no -o ForwardAgent=no'

set __fish_git_prompt_show_informative_status yes
set __fish_git_prompt_showcolorhints yes

if test -f ~/.config/fish/(hostname).fish
    . ~/.config/fish/(hostname).fish
end
if test -f ~/.fish.local
    . ~/.fish.local
end

function ros
    set ROS_DIR "/opt/ros/$argv[1]"
    set PYTHONPATH (fd '[site,dist]-packages' $ROS_DIR)
    echo "set -x ROS_DIR $ROS_DIR"
    echo "set -x PATH $ROS_DIR/bin \$PATH"
    echo "set -x PYTHONPATH $PYTHONPATH \$PYTHONPATH"
    echo "set -x LD_LIBRARY_PATH $ROS_DIR/lib \$LD_LIBRARY_PATH"
    echo "set -x CMAKE_PREFIX_PATH $ROS_DIR \$CMAKE_PREFIX_PATH"
    echo "set -x ROS_PACKAGE_PATH $ROS_DIR/share \$ROS_PACKAGE_PATH"
    echo ". $ROS_DIR/share/rosbash/rosfish"
end

function ``` --description 'no-op, to ease copy-paste from markdown'
    # ```
    return 0
end

function rptest
    set build (make show-var VARNAME=CONFIGURE_DIRS)
    pushd (make show-var VARNAME=WRKSRC)
    pushd $build
    make test
    popd
    popd
end

function rprelease
    make clean && make mdi && make && make install && make print-PLIST && sed -i /robotpkg_info/d PLIST.guess && vd PLIST.guess PLIST && make install confirm
end

function hg --wraps rg
    kitty +kitten hyperlinked_grep $argv
end
