nnoremap <leader>t :TSType<cr>
nnoremap <leader>w :T yarn test<cr>
nnoremap <buffer> <silent> <C-]> :TSDef<cr>
nnoremap <leader>f :TSRefs<cr>

let b:ale_fixers = ['prettier', 'tslint']
