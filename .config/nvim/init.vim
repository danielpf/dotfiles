filetype plugin on

"⌐˙⁄░⌉Ⅰ
set list listchars=tab:-->,multispace:░\ ,extends:↓,nbsp:+
",eol:∵

" Netrw settings
"let g:netrw_banner = 0
"let g:netrw_liststyle = 3
"let g:netrw_browse_split = 4
"let g:netrw_altv = 1
"let g:netrw_winsize = 10
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END

function! TrimWhiteSpace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction
augroup trimwhitespacegroup
  autocmd!
  auto BufWritePre * :call TrimWhiteSpace()

  " do other on-save actions here if you want


lua require("danielf");


