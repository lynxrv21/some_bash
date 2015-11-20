" Update VIM after writing .vimrc
" autocmd! bufwritepost .vimrc source %
set nocompatible
set number
syntax on
" - Display cursor position
set ruler
" - Always display the status line, even if only one window is displayed
set laststatus=2
set mouse=a
filetype plugin indent on
syntax on
" Color scheme
set t_Co=16
set background=dark
" Cursor line
set cursorline
highlight CursorLine ctermbg=8 cterm=None
" Color column
if exists('+colorcolumn')
    set colorcolumn=80
    highlight ColorColumn ctermbg=8
else
    highlight ColorColumn ctermbg=11
    au BufWinEnter,InsertLeave python match ColorColumn '\%<81v.\%>80v'
endif
" Show whitespace
highlight ExtraWhitespace ctermbg=red
au InsertLeave * match ExtraWhitespace /\s\+$/

highlight Number ctermfg=3
highlight LineNr ctermfg=11
highlight String ctermfg=2
highlight Comment ctermfg=9
highlight Statement cterm=bold ctermfg=4
highlight PreProc cterm=bold ctermfg=5
highlight Function ctermfg=3
highlight Identifier ctermfg=3 cterm=bold
highlight ModeMsg ctermbg=9 ctermfg=3
highlight StatusLineNC ctermbg=8 ctermfg=12 cterm=bold
highlight StatusLine ctermfg=12
highlight Type ctermfg=4
highlight Todo cterm=reverse,bold
highlight Directory cterm=bold ctermfg=4
highlight VertSplit ctermfg=5
highlight Visual ctermbg=8 cterm=None
highlight SearchOn term=reverse ctermfg=0 ctermbg=11
highlight link IncSearch SearchOn
highlight link Search SearchOn
highlight Pmenu ctermbg=0 ctermfg=3
highlight PmenuSel ctermbg=4 ctermfg=3 cterm=none
highlight PmenuSbar ctermbg=8
highlight PmenuThumb ctermbg=3


" Cursor color for each mode """
if &term == 'rxvt'
    let &t_SI = "\<Esc>]12;red\x7" " insert mode
    let &t_EI = "\<Esc>]12;white\x7" " normal mode
endif

" Show line numbers and length
set number " show line numbers
" Menu
set wildmenu
set wildmode=longest:full,list:full
" Status line
set laststatus=2
set ruler
" Tabs & Indents
set tabstop=4
set expandtab
set shiftwidth=4
set softtabstop=4
set smarttab
set autoindent
" Search
set hlsearch
set incsearch
set noignorecase
" No backup and swap
set nobackup
set nowritebackup
set noswapfile
" No wrap
set nowrap
" Backspace
set backspace=indent,eol,start
" Completion option
set completeopt=menu,longest
set complete=.,w,b,u,U
" Paste mode
set pastetoggle=<leader>p
" Clipboard
set clipboard+=unnamedplus
" Don't jump to start of line
set nostartofline
" Time waited for a key to complete
set timeoutlen=500
" Higlihght by * without jump to the next word
nnoremap * *N
" Turn OFF hihlight
nnoremap <C-F8> :nohlsearch<CR>
" Turn OFF `REPLACE` mode - use <S-R>
inoremap <Ins> <Nop>
" Use Ctrl-Space for Omni completion
inoremap <Nul> <C-x><C-o>
" Remove trailing whitespaces
autocmd BufWritePre *.py,.vimrc :%s/\s\+$//e
" Easier moving of selected code blocks
vnoremap < <gv
vnoremap > >gv
" Better scrolling
noremap <PageUp> <C-U><C-U>
noremap <PageDown> <C-D><C-D>
inoremap <PageUp> <C-O><C-U><C-U>
inoremap <PageDown> <C-O><C-D><C-D>
vnoremap <PageUp> <C-U><C-U>
vnoremap <PageDown> <C-D><C-D>
" Quicksave command F2
noremap <F2> :update<CR>
vnoremap <F2> <C-C>:update<CR>
inoremap <F2> <C-O>:update<CR>
noremap <F2><F2> :update!<CR>
vnoremap <F2><F2> <C-C>:update!<CR>
inoremap <F2><F2> <C-O>:update!<CR>
" Clever Tab completion
fu! CleverTab(direction)
if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
        return "\<Tab>"
    elseif "backward" == a:direction
        return "\<C-P>"
    elseif "forward" == a:direction
        return "\<C-N>"
    endif
endfu
inoremap <Tab> <C-R>=CleverTab("backward")<CR>
inoremap <S-Tab> <C-R>=CleverTab("forward")<CR>

" *** PYTHON ***
autocmd FileType python set completefunc=pythoncomplete#Complete
autocmd FileType python set omnifunc=pythoncomplete#Complete
au FileType python call PYTHON_SETTINGS()
fu! PYTHON_SETTINGS()
" Folding
set foldmethod=indent
set foldnestmax=2
    let python_hightlight_all = 1
    " Execute python file in new console (urxvt) F9 |
    nnoremap <silent> <F9> :w<CR>:!urxvt -title % -e bash -c "python %;read;"&<CR><CR>
    vnoremap <silent> <F9> <esc>:w<CR>:!urxvt -title % -e sh -c "python %;read;"&<CR><CR>gv
    inoremap <silent> <F9> <esc>:w<CR>:!urxvt -title % -e sh -c "python %;read;"&<CR><CR>a
" VIRTUALENV for Python
" Add the virtualenv's site-packages to vim path
" http://sontek.net/blog/detail/turning-vim-into-a-modern-python-ide#virtualenv
if has("python")
python << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
endif
    " Generate ctags file in .vim directory
    noremap <F8> <Esc>:!ctags -R -f ~/.vim/tags --python-kinds=+cf --tag-relative=yes `pwd`<CR>
    set tags+=$HOME/.vim/tags
    " Smart HOME key
    noremap <expr> <silent> <Home> col('.') == match(getline('.'),'\S')+1 ? '0' : '^'
    inoremap <silent> <Home> <C-O><Home>
endfu

au FileType python noremap <F12> :call LocalFunctionsList()<CR>
au BufLeave * if &buftype == "quickfix" | lclose | endif | highlight link Search SearchOn
fu! LocalFunctionsList()
    let gp_s = &grepprg
    let &grepprg = 'grep -nHoE "(def\|class)\s.*\(.*\)"'
    silent! lgrep! %
    lopen | redraw! | highlight Search None
    setlocal filetype=python nonumber modifiable
    sort i /\(def\|class\)\s/
    setlocal nomodified nomodifiable

    let &grepprg = gp_s
endfu
" *** PYTHON ***






let g:netrw_list_hide = '.*\.swp\($\|\t\),.*\.py[co]\($\|\t\)'


" added 11.02.2014
"
fu! FunctionList()

    cclose

    let l:defs = {}

    let l:parent = {}

    let l:bufname = bufname('%')



    for l:line in range(line('$'))

        let l:str = matchstr(getline(l:line), '\(^def\|^class\|^\s\+def\)\s.*(.*)')

        if l:str != ''

            let l:indent = len(matchstr(l:str, '^\s*\(def\|class\)\@='))

            if l:indent == 0

                let l:defs[l:str] = {'lnum': l:line, 'filename': l:bufname, 'defs': {}}

                let l:parent[l:indent+4] = l:defs[l:str]

            elseif has_key(l:parent, l:indent) == 0

            else

                let l:parent[l:indent]['defs'][l:str] = {'lnum': l:line, 'filename': l:bufname, 'defs': {}}

                let l:parent[l:indent+4] = l:parent[l:indent]['defs'][l:str]

            endif

        endif

    endfor



    let l:qflist = []

    fu! Add_def(def, sub_defs, qflist)

        let l:def = substitute(a:def, '\s\{4\}', '....', 'g')

        call add(a:qflist, {'text': l:def, 'lnum': a:sub_defs['lnum'], 'filename': a:sub_defs['filename']})

        if empty(a:sub_defs['defs']) == 0

            for l:key in sort(keys(a:sub_defs['defs']))

                call Add_def(l:key, a:sub_defs['defs'][l:key], a:qflist)

            endfor

        endif

    endfu



    for l:key in sort(keys(l:defs))

        call Add_def(l:key, l:defs[l:key], l:qflist)

    endfor



    let l:ft = &ft

    call setqflist(l:qflist)

    copen

    exe 'setl ft='.l:ft



    hi Search None | hi link Search SearchOff

    au BufLeave <buffer> cclose | hi link Search SearchOn



    setl conceallevel=3 concealcursor=nc nonumber

    syntax match qfFileName1 /^.*|\s/ transparent conceal

endfu

noremap <silent><F5> :call FunctionList()<CR>
