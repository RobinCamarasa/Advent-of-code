" Import {{{
source ../../../lib/RobinCamarasa/vimscript/utils.vim
"}}}

" Parse Input {{{
function! Parse()
    call execute('g/^.*$/normal! _"ly$:let input = split(@l, ''\zs'')' . "\r")
    return input
endfunction
"}}}

" Utils {{{
function! HexToBinary(hexlist)
    let output = []
    for c in a:hexlist
        let decimal = index(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'], c)
        let bin = ''
        for i in range(4)
            let bin = bin . (decimal % 2)
            let decimal = decimal/2
        endfor
        let output = output + map(reverse(split(bin, '\zs')), {id, val -> 1 * val})
    endfor
    return output
endfunction

function! BinaryToDecimal(binar)
endfunction
"}}}

" Part One {{{
function! SolvePartOne()
    let input = Parse()
    echom HexToBinary(input)
    return "Solution 1"
endfunction
"}}}

" Part two {{{
function! SolvePartTwo()
    let input = Parse()
    return "Solution 2"
endfunction
"}}}
