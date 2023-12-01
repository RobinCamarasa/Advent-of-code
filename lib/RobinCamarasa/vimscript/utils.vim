" Set options {{{
set formatoptions-=cro
set foldmethod=marker
"}}}

" Set Shortcuts {{{
nnoremap <leader>c :w<cr>:source %<cr><c-w>w:call WriteSolutions("README.md")<cr>
nnoremap <leader>1 :w<cr>:source %<cr>:messages clear<cr><c-w>w:echom SolvePartOne()<cr><cr><c-w>w:messages<cr>
nnoremap <leader>2 :w<cr>:source %<cr>:messages clear<cr><c-w>w:echom SolvePartTwo()<cr><cr><c-w>w:messages<cr>
nnoremap <leader>p :w<cr>:source %<cr>:messages clear<cr><c-w>w:echom Parse()<cr><cr><c-w>w:messages<cr>
"}}}

" Write solutions {{{
function! WriteSolutions(filename)
    let g:solution_one = SolvePartOne()
    let g:solution_two = SolvePartTwo()
    call SolvePartTwo()
    silent call execute('!rm -f ' . a:filename)
    vsp 
    call execute('edit ' . a:filename)
    silent call execute("normal! gg_dGi# Solutions of the day\r\r- " .  g:solution_one . "\r- " . g:solution_two . "\r")
    write
    redraw!
endfunction
"}}}

" Parse Input {{{
function! Parse()
    return "TODO: implement"
endfunction
"}}}

" Part One {{{
function! SolvePartOne()
    return "TODO: implement"
endfunction
"}}}

" Part two {{{
function! SolvePartTwo()
    return "TODO: implement"
endfunction
"}}}
