alias virerdossiersvides='find . -name .directory -print0 | xargs -0 /bin/rm -fv ; find . -name Thumbs.db -print0 | xargs -0 /bin/rm -fv ; find . -type d -empty -print0 | xargs -0 /bin/rmdir -pv --ignore-fail-on-non-empty'
alias clean="find -regextype posix-extended -regex '.*\.(orig|aux|nav|out|snm|toc|tmp|tns|pyg|vrb|fls|fdb_latexmk|blg|bbl|un~)' -delete"

alias civ5='env LD_PRELOAD=/usr/lib32/libopenal.so.1 steam steam://rungameid/8930'
alias civ6='env LD_PRELOAD=/usr/lib/libfreetype.so.6 steam steam://rungameid/289070'
