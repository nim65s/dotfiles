set shell=/bin/sh

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

if empty($DOTFILES)
    let DOTFILES = "~/dotfiles/.vim"
else
    let DOTFILES = $DOTFILES .. "/.vim"
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup
else
  set backup
endif
set ruler
set showcmd
set incsearch

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " For all python files set 'textwidth' to 88 characters.
  autocmd FileType python setlocal textwidth=88
  autocmd FileType python setlocal colorcolumn=88

  " tex files
  autocmd FileType tex setlocal wrap
  autocmd FileType tex setlocal linebreak
  autocmd FileType tex setlocal nolist
  autocmd FileType tex setlocal textwidth=0

  " mails
  autocmd FileType mail setlocal fo-=l
  autocmd FileType mail setlocal spell
  autocmd FileType mail setlocal tw=80

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

" ADD by Nim
set autoindent
" set background=dark
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set t_Co=256
"let g:zenburn_italic_Comment=1
"let g:zenburn_transparent=1
"colors zenburn
hi Normal ctermbg=NONE
set scrolloff=3
set ai
set showcmd
set ruler
set hlsearch
set visualbell
set cursorline
highlight CursorLine cterm=bold ctermbg=NONE
"set novisualbell
filetype indent on

" http://items.sjbach.com/319/configuring-vim-right

let mapleader = ","
set wildmenu
set title
"set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>
runtime macros/matchit.vim
runtime macros/shellmenu.vim
set pastetoggle=<F5>


map <F10> :NERDTreeToggle<cr>
nmap <F4> :TlistToggle<cr>
set patchmode=.orig

set encoding=utf-8
set fileencoding=utf-8
set tw=119
set colorcolumn=+1

" Toggle option 'spell'

function! ToggleSpell()
  if &spell
    set nospell
  else
    set spell
  end
endfunction

noremap <F9> :call ToggleSpell()<cr>

set spelllang=fr,en

"set langmap=ba,éz,pe,or,èt,çy,vu,di,lo,fp,j^,z$,aq,us,id,ef,\,g,ch,tj,sk,nl,rm,mù,^*,ê<,àw,hx,yc,.v,kb,'n,q\,,g;;,x:,w!,BA,ÉZ,PE,OR,ÈT,ÇY,VU,DI,LO,FP,J¨,Z£,AQ,US,ID,EF,?G,CH,TJ,SK,NL,RM,M%,!*,Ê>,ÀW,HX,YC,:V,KB,\\;N,QG,G.,X/,W§,@œ,_&,"é,«",»',((,)-,+è,-_,*ç,/à,=),%=,$Œ,^°,µ+,#“,{´,}~,<#,>{,[[,]|,±`,¬\,×^,÷@,¯],%}

" {W} -> [É]
" ——————————
" On remappe W sur É :
noremap é w
noremap É W
" Corollaire, pour effacer/remplacer un mot quand on n’est pas au début (daé / laé).
" (attention, cela diminue la réactivité du {A}…)
noremap aé aw
noremap aÉ aW
" Pour faciliter les manipulations de fenêtres, on utilise {W} comme un Ctrl+W :
noremap w <C-w>
noremap W <C-w><C-w>
noremap wc <C-w>h
noremap wt <C-w>j
noremap ws <C-w>k
noremap wr <C-w>l

" [HJKL] -> {CTSR}
" ————————————————
" {cr} = « gauche / droite »
noremap c h
noremap r l
" {ts} = « haut / bas »
noremap t j
noremap s k
" {CR} = « haut / bas de l'écran »
noremap C H
noremap R L
" {TS} = « joindre / aide »
noremap T J
noremap S K
" Corollaire : repli suivant / précédent
noremap zs zj
noremap zt zk

" {HJKL} <- [CTSR]
" ————————————————
" {J} = « Jusqu'à »            (j = suivant, J = précédant)
noremap j t
noremap J T
" {L} = « Change »             (l = attend un mvt, L = jusqu'à la fin de ligne)
noremap l c
noremap L C
" {H} = « Remplace »           (h = un caractère slt, H = reste en « Remplace »)
noremap h r
noremap H R
" {K} = « Substitue »          (k = caractère, K = ligne)
noremap k s
noremap K S
" Corollaire : correction orthographique
noremap ]k ]s
noremap [k [s

" Désambiguation de {g}
" —————————————————————
" ligne écran précédente / suivante (à l'intérieur d'une phrase)
noremap gs gk
noremap gt gj
" onglet précédant / suivant
noremap gb gT
noremap gé gt
" optionnel : {gB} / {gÉ} pour aller au premier / dernier onglet
noremap gB :exe "silent! tabfirst"<CR>
noremap gÉ :exe "silent! tablast"<CR>
" optionnel : {g"} pour aller au début de la ligne écran
noremap g" g0

" <> en direct
" ————————————
noremap « <
noremap » >

" Tab fait un Esc, Maj+Tab fait un Tab
inoremap <Tab> <Esc>
inoremap &lt;S-Tab> <Tab>

" Même chose, mais en mode visuel
vnoremap <Tab> <Esc>
vnoremap &lt;S-Tab> <Tab>

noremap <BS> <C-U>
noremap <Space> <C-D>

noremap <Return> zz

"NERDTree section
let NERDTreeMapActivateNode='<space>'
let NERDTreeMapOpenInTab='d'
let NERDTreeMapOpenInTabSilent='D'
let NERDTreeMapOpenSplit='j'
let NERDTreeMapOpenVSplit='n'
let NERDTreeMapJumpFirstChild='S'
let NERDTreeMapJumpLastChild='T'

"Tlist section
let Tlist_Use_Right_Window=1

"Fin de l’espace insécable indésirable dans le code
set listchars=nbsp:¤,tab:▷·,trail:¤,extends:>,precedes:<
set list

"vim-latexsuite
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

"vim-airline
let g:airline_theme='wombat'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

set laststatus=2
set ttimeoutlen=50
set noro

"vim-go
autocmd FileType go setlocal listchars=nbsp:¤,tab:  ,trail:¤,extends:>,precedes:<
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

"*.md: markdown and not modula2
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd FileType markdown setlocal fo-=l

"*.urdf: xml
autocmd BufNewFile,BufRead *.urdf set filetype=xml
autocmd BufNewFile,BufRead *.srdf set filetype=xml
autocmd BufNewFile,BufRead *.sdf set filetype=xml

"patch-*: diff
autocmd BufNewFile,BufRead patch-* set filetype=diff

" c++ completion
autocmd BufNewFile,BufRead,BufEnter *.cpp,*.hpp set omnifunc=omni#cpp#complete#Main
set nocp
map <C-F12> :!ctags -R --c++-kinds=+pl --fields=+iaS --extra=+q .<CR>
set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/pinocchio

" BFYTW
command W w
command WW w
command Q q
command Wq x
command WQ x

" mutt
au BufRead /tmp/mutt-* set tw=72
au BufRead /tmp/mutt-* set shiftwidth=2
au BufRead /tmp/mutt-* set tabstop=2
au BufRead /tmp/mutt-* set noexpandtab

" Grammalecte-fr
let g:grammalecte_cli_py='/usr/share/grammalecte-fr/cli.py'

" Let clangd fully control code completion
let g:ycm_clangd_uses_ycmd_caching = 0
" Use installed clangd, not YCM-bundled clangd which doesn't get updates.
let g:ycm_clangd_binary_path = exepath("clangd")

" vim-plug
"call plug#begin(DOTFILES .. "/plugged")
"Plug 'dpelle/vim-Grammalecte'
"Plug 'editorconfig/editorconfig-vim'
"Plug 'mxw/vim-jsx', {'for': 'javascript.jsx'}
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clangd-completer', 'for': 'cpp' }
"Plug 'kchmck/vim-coffee-script', {'for': 'coffee'}
"Plug 'cespare/vim-toml', {'for': 'toml'}
"Plug 'posva/vim-vue'
"Plug 'chrisbra/Colorizer'
"Plug 'imsnif/kdl.vim'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"call plug#end()

let g:clang_format#command = 'clang-format-6.0'
let g:clang_format#auto_format = 1

let g:ale_python_flake8_options = 'E24,E123,E704,W503,E226,E126,W504,E121,E203'
let g:ale_rust_rustfmt_options = '--edition 2021'
let g:ale_fix_on_save = 1
let g:ale_rust_cargo_use_clippy = 1
let g:ale_linters = {
            \'python': ['flake8', 'ruff'],
            \}
let g:ale_fixers = {
            \'python': ['isort', 'black', 'ruff'],
            \'rust': ['rustfmt'],
            \'*': ['remove_trailing_lines', 'trim_whitespace'],
            \}

let g:markdown_fenced_languages = ['python', 'rust', 'cpp', 'bash']

nmap <leader>a v<Plug>(coc-codeaction-selected)
xmap <leader>a v<Plug>(coc-codeaction-selected)
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
