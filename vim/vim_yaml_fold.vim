if exists('g:loaded_qbcmp_vim_yaml_fold')
  finish
endif
let g:loaded_qbcmp_vim_yaml_fold = 1

function! s:YamlFoldUnit() abort
  return (&l:shiftwidth > 0 ? &l:shiftwidth : 2)
endfunction

function! s:IsBlankOrComment(lnum) abort
  let l:line = getline(a:lnum)
  return l:line =~# '^\s*$' || l:line =~# '^\s*#'
endfunction

function! s:PrevContentLnum(lnum) abort
  let l:n = a:lnum - 1
  while l:n >= 1
    if !s:IsBlankOrComment(l:n)
      return l:n
    endif
    let l:n -= 1
  endwhile
  return 0
endfunction

function! s:NextContentLnum(lnum) abort
  let l:n = a:lnum + 1
  let l:last = line('$')
  while l:n <= l:last
    if !s:IsBlankOrComment(l:n)
      return l:n
    endif
    let l:n += 1
  endwhile
  return 0
endfunction

function! QbcmpYamlFoldExpr() abort
  if s:IsBlankOrComment(v:lnum)
    return '='
  endif

  let l:unit = s:YamlFoldUnit()
  let l:curr_indent = indent(v:lnum)
  let l:curr_level = float2nr(l:curr_indent / l:unit) + 1

  let l:next_lnum = s:NextContentLnum(v:lnum)
  if l:next_lnum == 0
    return l:curr_level
  endif

  let l:next_level = float2nr(indent(l:next_lnum) / l:unit) + 1
  if l:next_level > l:curr_level
    return '>' . l:curr_level
  endif

  return l:curr_level
endfunction

function! QbcmpYamlFoldText() abort
  let l:line = getline(v:foldstart)
  let l:indent = matchstr(l:line, '^\s*')
  let l:text = substitute(l:line, '^\s*', '', '')

  " Keep the folded line visually aligned with the original indentation and
  " use an IDE-like disclosure triangle without Vim's default padding/count.
  if l:text ==# ''
    return l:indent . '▸'
  endif
  return l:indent . '▸ ' . l:text
endfunction

function! QbcmpYamlFoldSetup() abort
  setlocal foldmethod=expr
  setlocal foldexpr=QbcmpYamlFoldExpr()
  setlocal foldtext=QbcmpYamlFoldText()
  setlocal foldlevelstart=99
  setlocal foldminlines=1

  " No fold column gutter; the triangle is part of foldtext.
  setlocal foldcolumn=0
  setlocal fillchars+=fold:\ 

  " Open all folds on load; user can fold manually as needed.
  normal! zR

  " Make folded lines blend with the window background/foreground.
  if exists('+winhighlight')
    if &l:winhighlight ==# ''
      setlocal winhighlight=Folded:Normal,FoldColumn:Normal
    elseif &l:winhighlight !~# 'Folded:'
      let &l:winhighlight .= ',Folded:Normal,FoldColumn:Normal'
    endif
  else
    highlight Folded term=NONE cterm=NONE gui=NONE ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE
    highlight FoldColumn term=NONE cterm=NONE gui=NONE ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE
  endif
endfunction
