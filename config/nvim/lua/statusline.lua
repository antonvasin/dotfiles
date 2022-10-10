vim.cmd([[
function! MyModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunction

function! MyReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return "╳"
  else
    return ""
  endif
endfunction

function! MyFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

let g:lightline = {
  \   'colorscheme': 'gruvbox',
  \   'component_function': {
  \     'readonly': 'MyReadonly',
  \     'modified': 'MyModified',
  \     'filename': 'MyFilename',
  \     'git': 'FugitiveHead'
  \   },
  \   'active': {
  \     'left': [
	\       ['mode', 'paste'],
	\       ['filename']
	\			],
  \     'right': [
	\       ['git', 'currentfunction'],
	\       ['lineinfo']
	\     ]
  \   }
  \ }

]])
