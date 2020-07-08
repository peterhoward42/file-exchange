set ic
set wm=1
set ai
map ] :.w!/tmp/tmp.txt<CR>
map y :w !pbcopy<CR><CR>

map } :'a,.w!/tmp/tmp.txt<CR>

map [ :r /tmp/tmp.txt<CR>

set nobackup
set nowritebackup
set noswapfile
set noundofile
set tabstop=4
set shiftwidth=4
"set expandtab
set lines=50
set columns=82
set visualbell
set colorcolumn=80
set guifont=Andale\ Mono:h14

set term=xterm-256color
