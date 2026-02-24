" Sane defaults
set nocompatible
syntax on
filetype plugin indent on

" UI
"set hidden
set showcmd
set showmode
set wildmenu
set ruler
set laststatus=2
set number
set nolist
set mouse=a
set nowrap
set scrolloff=4
set smartindent
set splitright
set splitbelow
set fillchars+=eob:\ 
set fillchars+=vert:│
set listchars=tab:>-,space:·,trail:·,extends:>,precedes:<,nbsp:+



let g:is_wsl = has('unix') && (system('uname -r') =~? 'microsoft')
if g:is_wsl
  inoremap <C-v> <C-r>+
  vnoremap <C-Y> :silent w !clip.exe<CR>
  
endif

" Native system clipboard for non-WSL systems (macOS/Linux) when Vim has +clipboard
if has('clipboard') && !g:is_wsl
  try
    set clipboard=unnamed,unnamedplus
  catch /^Vim\%((\a\+)\)\=:E474/
    try
      set clipboard=unnamedplus
    catch /^Vim\%((\a\+)\)\=:E474/
      set clipboard=unnamed
    endtry
  endtry
endif

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch

" Indentation: spaces over tabs, 2-space tabs
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smartindent

" Leader key
let mapleader = ";"

" Local scripts
let s:vimrc_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:yaml_fold = s:vimrc_dir . '/vim/vim_yaml_fold.vim'
if filereadable(s:yaml_fold)
  execute 'source ' . fnameescape(s:yaml_fold)
endif
unlet s:vimrc_dir
unlet s:yaml_fold

" Toggles
nnoremap L :set list!<CR>
nnoremap <C-n> :set number!<CR>
nnoremap <C-l> :nohlsearch<CR>
nnoremap <leader><Space> :nohlsearch<CR>

" Replace selected text: visually select, then ;r
function! ReplaceVisualSelection() abort
  let l:save_reg = getreg('"')
  let l:save_regtype = getregtype('"')

  normal! gvy
  let l:selected = getreg('"')
  let l:replacement = input('Replace with: ')

  if l:selected !=# '' && l:replacement !=# ''
    let l:pattern = escape(l:selected, '\/.*$^~[]')
    let l:replacement_esc = escape(l:replacement, '\/&~')
    execute '%s/' . l:pattern . '/' . l:replacement_esc . '/g'
  endif

  call setreg('"', l:save_reg, l:save_regtype)
endfunction
xnoremap <leader>r :<C-u>call ReplaceVisualSelection()<CR>

" Strikethrough selected text using Unicode combining overlay
function! StrikeThroughSelection() abort
  let l:save_reg = getreg('"')
  let l:save_regtype = getregtype('"')

  normal! gvy
  let l:selected = getreg('"')
  let l:seltype = getregtype('"')
  let l:struck = substitute(l:selected, '[^\n]', '\=submatch(0) . nr2char(0x0336)', 'g')

  call setreg('"', l:struck, l:seltype)
  normal! gv""p

  " Combining characters can confuse redraw in some terminals/Vim builds.
  silent! syntax sync fromstart
  redraw!

  call setreg('"', l:save_reg, l:save_regtype)
endfunction
xnoremap <leader>s :<C-u>call StrikeThroughSelection()<CR>

" Splits and tabs
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>h :split<CR>
nnoremap <leader>o <C-w>w
nnoremap <leader>t :tabnew<CR>
nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>
nnoremap <S-Left> <C-w>h
nnoremap <S-Down> <C-w>j
nnoremap <S-Up> <C-w>k
nnoremap <S-Right> <C-w>l
inoremap <S-Left> <C-o><C-w>h
inoremap <S-Down> <C-o><C-w>j
inoremap <S-Up> <C-o><C-w>k
inoremap <S-Right> <C-o><C-w>l
nnoremap <leader>r :source ~/.vimrc<CR>


" Netrw sidebar defaults
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:netrw_keepdir = 0
let g:netrw_preview = 1
let g:netrw_sort_by = 'name'
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+,\~$,\.\(swp\|tmp\|DS_Store\)$'

" ;e opens/toggles a left netrw sidebar
nnoremap <leader>e :Lexplore<CR>

augroup VimrcNetrw
  autocmd!
  autocmd FileType netrw setlocal nonumber norelativenumber signcolumn=no winfixwidth statusline=\ 
augroup END

augroup VimrcYamlFolds
  autocmd!
  autocmd FileType yaml call QbcmpYamlFoldSetup()
augroup END

" Status bar colors: dark gray background, white foreground
highlight StatusLine cterm=NONE gui=NONE term=NONE ctermfg=255 ctermbg=235 guifg=#ffffff guibg=#262626
highlight StatusLineNC cterm=NONE gui=NONE term=NONE ctermfg=255 ctermbg=235 guifg=#ffffff guibg=#262626
highlight StatusLineBranch cterm=NONE gui=NONE term=NONE ctermfg=255 ctermbg=237 guifg=#ffffff guibg=#3a3a3a
highlight VertSplit cterm=NONE gui=NONE term=NONE ctermfg=8 ctermbg=NONE guifg=#555555 guibg=NONE
if hlexists('WinSeparator')
  highlight WinSeparator cterm=NONE gui=NONE term=NONE ctermfg=8 ctermbg=NONE guifg=#555555 guibg=NONE
endif

" Line numbers in gray
highlight LineNr ctermfg=8 guifg=#555555
highlight CursorLineNr ctermfg=8 guifg=#555555
highlight Normal ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE

" Whitespace/listchars in dark gray
highlight SpecialKey ctermfg=8 guifg=#555555
highlight NonText ctermfg=8 guifg=#555555
if hlexists('Whitespace')
  highlight Whitespace ctermfg=8 guifg=#555555
endif

" Statusline content: short path + cached git branch
function! UpdateGitBranch() abort
  let b:git_branch = ''
  if &buftype !=# '' || expand('%:p') ==# ''
    return
  endif
  let l:dir = expand('%:p:h')
  let l:branch = systemlist('git -C ' . shellescape(l:dir) . ' rev-parse --abbrev-ref HEAD 2>/dev/null')
  if v:shell_error == 0 && !empty(l:branch) && l:branch[0] !=# 'HEAD'
    let b:git_branch = ' ' . l:branch[0] . ' '
  endif
endfunction

augroup VimrcStatuslineGit
  autocmd!
  autocmd BufEnter,BufWritePost,DirChanged * call UpdateGitBranch()
augroup END

function! StatusPath() abort
  let l:file = expand('%:p')
  if l:file ==# ''
    return fnamemodify(getcwd(), ':~')
  endif
  return fnamemodify(l:file, ':~')
endfunction

set statusline=%<%{StatusPath()}%m%r%h%w%=%#StatusLine#\ %#StatusLineBranch#%{get(b:,'git_branch','')}%#StatusLine#
