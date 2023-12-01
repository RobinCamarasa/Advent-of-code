" Import {{{
source ../../../lib/RobinCamarasa/vimscript/utils.vim
"}}}

" Parse Input {{{
function! Parse()
    let rules={}
    call execute('g/->/normal! _"ayiw$"byiw:let rules[@a]=@b' . "\r")
    call execute('g/^[A-Z]\+$/normal! _"ayiw$:let template=@a' . "\r")
    return {'rules': rules, 'template': template}
endfunction
"}}}

" Utils {{{
function! IntializeGroups(polymere, rules)
    let groups = copy(a:rules)
    for key in keys(a:rules)
        let groups[key] = 0
    endfor
    for i in range(len(a:polymere) - 1)
        let groups[a:polymere[i:i+1]] += 1
    endfor
    return groups
endfunction

function! CountGroups(groups, polymere)
    let g:count = {}
    let g:count[a:polymere[0]] = 1
    let g:count[a:polymere[len(a:polymere)-1]] = 1
    for key in keys(a:groups)
        for c in split(key, '\zs')
            if has_key(g:count, c)
                let g:count[c] += a:groups[key]
            else
                let g:count[c] = a:groups[key]
            endif
        endfor
    endfor
    for key in keys(g:count)
        let g:count[key] = g:count[key] / 2
    endfor
    return g:count
endfunction

function! UpdateGroups(groups, rules)
    let groups = copy(a:groups)
    for key in keys(a:rules)
        let groups[key] = 0
    endfor
    for key in keys(groups)
        let groups[key[0] . a:rules[key]] += a:groups[key]
        let groups[a:rules[key] . key[1] ] += a:groups[key]
    endfor
    return groups
endfunction

function! ComputeDifference(count)
    let min = a:count[keys(a:count)[0]]
    let max = a:count[keys(a:count)[0]]
    for value in values(a:count)
        if value < min
            let min = value
        elseif value > max
            let max = value
        endif
    endfor
    return max - min
endfunction

function! ComputeNSteps(n)
    let input = Parse()
    let groups = IntializeGroups(input['template'], input['rules'])
    for i in range(a:n)
        let groups = UpdateGroups(groups, input['rules'])
    endfor
    return ComputeDifference(CountGroups(groups, input['template']))
endfunction
"}}}

" Part One {{{
function! SolvePartOne()
    return "Solution 1: " . ComputeNSteps(10)
endfunction
"}}}

" Part two {{{
function! SolvePartTwo()
    return "Solution 2: " . ComputeNSteps(40)
endfunction
"}}}
