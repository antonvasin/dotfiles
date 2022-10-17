vim.cmd([[
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l
  nnoremap <C-h> <C-w>h
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-l> <C-w>l

  nnoremap * *``

  nnoremap <Right> <C-W>>
  nnoremap <Left> <C-W><
  nnoremap <Up> <C-W>-
  nnoremap <Down> <C-W>+

  " Treat warped lines as regular lines
  nnoremap j gj
  nnoremap k gk
  nnoremap / /\v
  vnoremap / /\v
  nnoremap ; :
  " cmap cwd lcd %:p:h
  vnoremap < <gv
  vnoremap > >gv
  nnoremap <C-e> 3<C-e>
  nnoremap <C-y> 3<C-y>
  " Cursor don't jump when joining lines
  nnoremap J mzJ`z
  " Keep search matches in the middle of the window.
  nnoremap n nzzzv
  nnoremap N Nzzzv
  nnoremap Y y$
  map K <Nop>
  nnoremap <leader>o :FZF<CR>
  nnoremap <c-t> :FZF<CR>
  nnoremap <c-p> :FZF<CR>

  nnoremap s :w<cr>
]])

vim.cmd([[
  " Leader maps
  nnoremap <SPACE> <Nop>
  let mapleader = " "
  nnoremap <leader>l :set list!<cr> \| :IndentLinesToggle<cr>
  nnoremap <leader><space> :nohl<cr>
  noremap <leader>u :MundoToggle<cr>
  nnoremap <leader>lw :%s/^\s\+<cr>:nohl<cr>
  nnoremap <leader>bl :g/^$/d<cr>:nohl<cr>
  nnoremap <leader>ev :e $MYVIMRC<cr>
  " Yank whole text line without spaces
  nnoremap <leader>y ^y$
  nnoremap <leader>S :%s///<left>
  nnoremap <leader>a :Ack!<space>
  nnoremap <leader>qq :qa!<cr>
  nnoremap <leader>w <C-w>
  nnoremap <leader>md :Glow<cr>

  nmap <leader>ja :A<cr>
  nmap <leader>jA :AV<cr>

  nnoremap <leader>o :only<cr>
  nnoremap <leader>z :Goyo<cr>

  nnoremap <leader>x :%!xxd<cr>
  nnoremap <leader>X :%!xxd -r<cr>

  nnoremap <leader>W :ToggleWorkspace<CR>

  " Fugitive.vim
  nnoremap <leader>gw :Gw<cr>
  nnoremap <leader>gc :Git commit<cr>
  nnoremap <leader>ga :Git commit --amend<cr>
  nnoremap <leader>gA :Git commit --amend --reuse-message=HEAD<cr>
  nnoremap <leader>gs :Git status<cr>
  nnoremap <leader>gP :Git push --force<cr>

  " neoterm
  vnoremap <leader>tr :TREPLSendSelection<cr>
  nnoremap <leader>tr :TREPLSendLine<cr>

  nnoremap <leader>j :Ttoggle<cr>
  nnoremap ` :Ttoggle<cr>
  tnoremap <leader>j <C-\><C-n>:Ttoggle<cr>
  tnoremap ` <C-\><C-n>:Ttoggle<cr>

  nnoremap <leader>tc :Tclear<cr>
  let g:neoterm_default_mod='botright'
  let g:neoterm_autoinsert=1

  cabbr <expr> %% expand('%:p:h')

  " fzf
  nnoremap <leader>b :Buffers<cr>
]])

vim.cmd([[
  function! CloseWindowOrKillBuffer()
    let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

    " We should never bdelete a nerd tree
    if matchstr(expand("%"), 'NERD') == 'NERD'
      wincmd c
      return
    endif

    if number_of_windows_to_this_buffer > 1
      wincmd c
    else
      bdelete
    endif
  endfunction

  map Q <Nop>

  if (!exists('g:vscode'))
    nnoremap <silent> Q :call CloseWindowOrKillBuffer()<CR>
    nnoremap <silent> <D-w> :call CloseWindowOrKillBuffer()<CR>
  else
    map - <Nop>
  end

  if has('gui_running')
    nnoremap <D-p> :FZF<CR>
    set showtabline=0
    set guioptions=
  end

  command! W noa write

  " tab (window) nav
  map <C-Tab> gt
  map <C-S-Tab> gT
]])
