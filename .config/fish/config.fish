if status --is-login
    if not set -q LANG
        set -gx LANG fr_FR.UTF-8
    end
    if expr "$LANG" : ".*\.[Uu][Tt][Ff].*" >/dev/null
        if [ "$TERM" = linux ]
            if which unicode_start &> /dev/null
                unicode_start
            end
        end
    end
    gpgconf --launch gpg-agent
end

if status is-interactive
    if which atuin &> /dev/null
        atuin init fish --disable-up-arrow | source
    else
        echo "Atuin is not available"
    end
end

set paths ~/.cargo ~/.poetry ~/.local ~/go ~/.cabal-sandbox

if which ruby &> /dev/null
    set -x GEM_HOME (ruby -e 'puts Gem.user_dir')
    set paths $paths $GEM_HOME
end

for dir in $paths
    if test -d "$dir/bin" && echo $PATH | grep -vq $dir
        set -x PATH "$dir/bin" $PATH
    end
end

set -q XDG_CONFIG_HOME || set -x XDG_CONFIG_HOME ~/.config
if which starship &> /dev/null
    starship init fish | source
else
    . $XDG_CONFIG_HOME/fish/nim.fish  # fish_prompt, nim's theme
end

set -q DOTFILES || set -x DOTFILES ~/dotfiles

function fairytail
    tail -n 100 -F $argv | ccze -A
end

function fs
    printf '\33]50;%s%d%s\007' "xft:DejaVuSansMono-Oblique:pixelsize=" $1 ",xft:Code2000:antialias=false"
end

function wol
    for host in $argv
        if test -f $DOTFILES/wol/$host
            /usr/bin/wol (cat $DOTFILES/wol/$host)
        else
            /usr/bin/wol $argv
        end
    end
end

function df
    which dfc &> /dev/null
    and dfc -Tdsq name
    or /bin/df -h
end

if which lsd &> /dev/null
    alias ls='lsd -F --hyperlink=auto'
    alias sl='lsd -F --hyperlink=auto'
    alias lss='lsd -F --hyperlink=auto'
    alias lt='lsd -F --hyperlink=auto --tree'
    alias tree='lsd -F --hyperlink=auto --tree'
    alias ll='lsd --hyperlink=auto -lArthF'
    alias lll='lsd --hyperlink=auto -lArthF'
    alias llt='lsd --hyperlink=auto -lArthF --tree -I .git'
    alias ltl='lsd --hyperlink=auto -lArthF --tree -I .git'
    alias treel='lsd --hyperlink=auto -lArthF --tree -I .git'
else
    alias ls='ls -F --color=auto --hyperlink=auto'
    alias sl='ls -F --color=auto'
    alias lss='ls -F --color=auto'
    alias ll='ls -lArthF'
    alias lll='ls -lArthF'
    alias lt='tree -aC -I .git'
    alias tree='tree -aC -I .git'
    alias llt='tree -aphugDC -I .git'
    alias ltl='tree -aphugDC -I .git'
    alias treel='tree -aphugDC -I .git'
end

function dvd
    sudo mkdir -p /mnt/dvd
    sudo mount /dev/sr0 /mnt/dvd
    and cvlc -f dvd:///mnt/dvd/
    and sudo umount /dev/sr0
    and eject
end

function virus_show
    sed '/OK$/d;/^$/d;/Empty file$/d;/Symbolic link$/d" /donnees/nim/scan.log'
end

function bd
    cd (python $HOME/scripts/bd.py $argv)
end

function check_websites
    for server in tind jiro yuppa
        chromium (ssh $server "grep ServerName /etc/apache2/sites-enabled/*|cut -d: -f2|sort|uniq|sed 's/ServerName /http:\/\//'")
    end
end

function fuck
    thefuck $history[2] | source
end

function watchmakepdf
    while inotifywait $argv.tex
        sleep 0.5
        make $argv.pdf
        and cp $argv.pdf ok.pdf
    end
end

function pipup
    test -f requirements.in
    or return

    pip install -U pip
    git status --porcelain
    git pull --rebase
    pip-compile > /dev/null
    git diff requirements.txt | grep '^-\|^+'
    pip-sync

    test (git status --porcelain | wc -l) -gt 0
    or return

    git add requirements.txt
    git commit -m "pip-update"
    git push
end

function gepetto_commit
    git diff -w --no-color | git apply --cached --ignore-whitespace
    and git commit -m "$argv"
    and git checkout -- .
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

function pypiup
    set -x TWINE_PASSWORD (pass web/pypi)
    clean
    python setup.py sdist bdist_wheel
    and gpg --detach-sign -a dist/*.tar.gz
    and gpg --detach-sign -a dist/*.whl
    and twine upload -s dist/*
    rm -rf build *egg-info
    set -e TWINE_PASSWORD
end

function pypoup --description 'increment version in poetry, git & PyPI'
    clean
    poetry version $argv
    poetry build
    gpg --detach-sign -a dist/*.tar.gz
    gpg --detach-sign -a dist/*.whl
    set VERSION (poetry version | cut -d' ' -f2)
    git commit -a -m "v$VERSION"
    git tag -s "v$VERSION" -m "Release v$VERSION"
    git push
    git push --tags
    set TOKEN (pass web/pypi/token)
    poetry publish -u __token__ -p "$TOKEN"
    set -e TOKEN
    echo -n (grep github pyproject.toml | cut -d'"' -f2)"/releases/new"
end

# thx http://lewandowski.io/2016/10/fish-env/
#function posix-source -d "loads a POSIX environment file"
    #for i in (cat $argv)
        #set arr (string split -m1 = $i)
        #set -gx $arr[1] $arr[2]
    #end
#end

#function __check_env --on-variable PWD --description 'load .env'
    #test -f .env
    #and bass source .env
#end

. $DOTFILES/portable-aliases.sh

# exports

#if test -d "/usr/share/vim/vim80"
#    set -x VIMRUNTIME /usr/share/vim/vim80
#else if test -d "/usr/share/vim/vim74"
#    set -x VIMRUNTIME /usr/share/vim/vim74
#else if test -d "/usr/share/vim/vim73"
#    set -x VIMRUNTIME /usr/share/vim/vim73
#else
#    set -x VIMRUNTIME /usr/share/vim/vim72
#end

set -x EDITOR vim
set -x BROWSER firefox-developer-edition
#set -x JAVA_HOME /opt/java
set -x _JAVA_OPTIONS '-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dawt.useSystemAAFontSettings=lcd'
set -x PIP_USE_WHEEL true
set -x TERM xterm-256color
set -x MPD_HOST nimopidy
set -x CMAKE_BUILD_TYPE RelWithDebInfo
set -x CMAKE_C_COMPILER_LAUNCHER sccache
set -x CMAKE_CXX_COMPILER_LAUNCHER sccache
set -x CMAKE_COLOR_DIAGNOSTICS ON
set -x CMAKE_EXPORT_COMPILE_COMMANDS ON
set -x CMAKE_GENERATOR Ninja
set -x CMEEL_LOG_LEVEL DEBUG
set -x CTEST_OUTPUT_ON_FAILURE ON
set -x CTEST_PARALLEL_LEVEL (nproc)
set -x CTEST_PROGRESS_OUTPUT ON
set -x DOCKER_BUILDKIT 1
set -x COMPOSE_DOCKER_CLI_BUILD 1
set -x ORBInitRef NameService=corbaname::localhost
set -x CC gcc
set -x CXX g++
set -x CXXFLAGS -fdiagnostics-color=always  # GCC
set -x TWINE_USERNAME nim65s
set -x POETRY_VIRTUALENVS_IN_PROJECT true

function cl
    set -x CC clang
    set -x CXX clang++
    set -x CXXFLAGS -fcolor-diagnostics
end


set -x GOPATH ~/go

set -x LS_COLORS 'rs=0:di=01;33:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'

set -x UID (id -u $USER)
set -q SSH_AUTH_SOCK
or set -x SSH_AUTH_SOCK "/run/user/$UID/gnupg/S.gpg-agent.ssh"

set -x GIT_SSH_COMMAND 'ssh -o ControlMaster=no -o ForwardAgent=no'

set __fish_git_prompt_show_informative_status 'yes'
set __fish_git_prompt_showcolorhints 'yes'

__fish_complete_django django-admin.py
__fish_complete_django manage.py

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

function restash
    git stash
    and git rebase -i HEAD~$argv[1]
    and git stash pop
    and git commit -a --amend --no-edit
    and git rebase --continue
    and echo YEEEEAAAAAAAAHH
end

# https://github.com/fisherman/pipenv/blob/master/conf.d/pipenv.fish + --fancy
if command -s pipenv > /dev/null

    # complete --command pipenv --arguments "(env _PIPENV_COMPLETE=complete-fish COMMANDLINE=(commandline -cp) pipenv)" -f

    function __pipenv_shell_activate --on-variable PWD
        if status --is-command-substitution
            return
        end
        if not test -e "$PWD/Pipfile"

            if not string match -q "$__pipenv_fish_initial_pwd"/'*' "$PWD/"
                set -U __pipenv_fish_final_pwd "$PWD"
                exit
            end
            return
        end

        if not test -n "$PIPENV_ACTIVE"
          if pipenv --venv >/dev/null 2>&1
            set -x __pipenv_fish_initial_pwd "$PWD"
            pipenv shell --fancy
            set -e __pipenv_fish_initial_pwd
            if test -n "$__pipenv_fish_final_pwd"
                cd "$__pipenv_fish_final_pwd"
                set -e __pipenv_fish_final_pwd
            end
          end
        end
    end
else
    function pipenv -d "http://docs.pipenv.org/en/latest/"
        echo "Install http://docs.pipenv.org/en/latest/ to use this plugin." > /dev/stderr
        return 1
    end
end

# https://github.com/fisherman/pipenv/blob/master/conf.d/pipenv.fish %s/pipenv/poetry
#if command -s poetry > /dev/null
    #function __poetry_shell_activate --on-variable PWD
        #if status --is-command-substitution
            #return
        #end
       #if not test -e "$PWD/pyproject.toml"
            #if not string match -q "$__poetry_fish_initial_pwd"/'*' "$PWD/"
                #set -U __poetry_fish_final_pwd "$PWD"
                #exit
            #end
            #return
        #end
        #if not test -n "$POETRY_ACTIVE"
          #if test (poetry env list | wc -l) -gt 0
            #set -x __poetry_fish_initial_pwd "$PWD"
            #poetry shell -q
            #set -e __poetry_fish_initial_pwd
            #if test -n "$__poetry_fish_final_pwd"
                #cd "$__poetry_fish_final_pwd"
                #set -e __poetry_fish_final_pwd
            #end
          #end
        #end
    #end
#end


function fish_greeting
    #command -qs ponysay
    #and ponysay -o
end

function ``` --description 'no-op, to ease copy-paste from markdown'
    # ```
    return 0
end

function cxx_cov
    cmake \
        -DCMAKE_BUILD_TYPE=Debug \
        -DCMAKE_CXX_FLAGS="--coverage" \
        -DCMAKE_EXE_LINKER_FLAGS="--coverage" \
        -DCMAKE_MODULE_LINKER_FLAGS="--coverage" \
        ..
    and make -j8
    and make test
    and gcovr -r .. --html --html-details -o /tmp/cov/index.html
end

function geplint
    docker run --rm -v (pwd -P):/root/src -it gepetto/linters
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
    make clean && make mdi && make && make install && make print-PLIST && sed -i '/robotpkg_info/d' PLIST.guess && vd PLIST.guess PLIST && make install confirm
end

test -d /opt/esp-idf
and set -x IDF_PATH /opt/esp-idf

# vim: set filetype=fish:

#if test -d /local/users/gsaurel/miniconda3

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#if test -f /home/nim/miniconda3/bin/conda
    #eval /home/nim/miniconda3/bin/conda "shell.fish" "hook" $argv | source
#end
# <<< conda initialize <<<

#end

function hg --wraps rg; kitty +kitten hyperlinked_grep $argv; end

function gcoauth
    # thanks https://hynek.me/til/easier-crediting-contributors-github/
    set account $argv[1]

    set data (curl -s https://api.github.com/users/$account)
    set id  (echo $data | jq .id)
    set name (echo $data | jq --raw-output '.name // .login')

    printf "Co-authored-by: %s <%d+%s@users.noreply.github.com>\n" $name $id $account
end

if which sccache &> /dev/null
    set -x RUSTC_WRAPPER (which sccache)
end

if which rtx &> /dev/null
    rtx activate fish | source
end
