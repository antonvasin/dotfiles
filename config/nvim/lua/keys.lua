local bufopts = { noremap = true, silent = true }

-- Windows

-- Pane movement with <C-h|j|k|l>
vim.keymap.set("n", "<C-h>", "<C-w>h", bufopts)
vim.keymap.set("n", "<C-j>", "<C-w>j", bufopts)
vim.keymap.set("n", "<C-k>", "<C-w>k", bufopts)
vim.keymap.set("n", "<C-l>", "<C-w>l", bufopts)
vim.keymap.set("t", "<C-h>", "<C-><C-n><C-w>h", bufopts)
vim.keymap.set("t", "<C-j>", "<C-><C-n><C-w>j", bufopts)
vim.keymap.set("t", "<C-k>", "<C-><C-n><C-w>k", bufopts)
vim.keymap.set("t", "<C-l>", "<C-><C-n><C-w>l", bufopts)

-- Resize
vim.keymap.set("n", "<Right>", "<C-w>>", bufopts)
vim.keymap.set("n", "<left>", "<C-w><", bufopts)
vim.keymap.set("n", "<Up>", "<C-w>-", bufopts)
vim.keymap.set("n", "<Down>", "<C-w>+", bufopts)

-- Movement

-- Treat warped lines as regular lines
vim.keymap.set("n", "j", "gj", bufopts)
vim.keymap.set("n", "k", "gk", bufopts)

-- Cursor don't jump when joining lines
vim.keymap.set("n", "J", "mzJ`z", bufopts)

-- Don't jump to first highlight
vim.keymap.set("n", "*", "*``", bufopts)

-- Keep search matches in the middle of the window.
vim.keymap.set("n", "n", "nzzzv", bufopts)
vim.keymap.set("n", "N", "Nzzzv", bufopts)

-- Scroll by 3 lines on <C-e|y>
vim.keymap.set("n", "<C-e>", "3<C-e>", bufopts)
vim.keymap.set("n", "<C-y>", "3<C-y>", bufopts)

-- Keep visual mode when indenting
vim.keymap.set("v", "<", "<gv", bufopts)
vim.keymap.set("v", ">", ">gv", bufopts)

-- Actions

-- Case-insensitive search
vim.keymap.set("n", "/", "/\\v", bufopts)
vim.keymap.set("v", "/", "/\\v", bufopts)

-- Easy commands with ;
-- lua version waits for the next key to enter command mode
-- vim.keymap.set("n", ";", ":", bufopts)
vim.cmd([[nnoremap ; :]])

-- Yank till end of the line
vim.keymap.set("n", "Y", "y$", bufopts)

-- Get full folder path in command mdoe
-- vim.keymap.set("c", "cwd", "lcd %:p:h-")

-- Save  with single key
vim.keymap.set("n", "s", ":w<cr>", bufopts)

-- Unmap K
vim.keymap.set("n", "K", "<Nop>", { silent = true })

-- FZF
vim.keymap.set("n", "<C-t>", ":FZF<cr>", bufopts)
vim.keymap.set("n", "<C-p>", ":FZF<cr>", bufopts)

-- Leader
vim.keymap.set("n", "<SPACE>", "<Nop>", bufopts)
vim.g.mapleader = " "

vim.cmd([[
  " Leader maps
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

  " Hex
  nnoremap <leader>x :%!xxd<cr>
  nnoremap <leader>X :%!xxd -r<cr>

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
