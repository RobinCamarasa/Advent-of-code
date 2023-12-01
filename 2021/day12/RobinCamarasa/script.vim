" Import {{{
source ../../../lib/RobinCamarasa/vimscript/utils.vim
"}}}

" Parse Input {{{
function! Parse()
    let edges=[]
    normal! mm
    call execute('g/^.*$/normal! _"ayiw$"byiw:call add(edges, [@a, @b])' . "\r")
    normal! `m

    let graph = {}
    for edge in edges
        if has_key(graph, edge[0])
            call add(graph[edge[0]], edge[1])
        else
            let graph[edge[0]] = [edge[1]]
        endif
        if has_key(graph, edge[1])
            call add(graph[edge[1]], edge[0])
        else
            let graph[edge[1]] = [edge[0]]
        endif
    endfor
    return graph
endfunction
"}}}

" Utils {{{
function! GetCaveType(node)
    if a:node == 'start'
        return 0
    endif
    if a:node == 'end'
        return 1
    endif
    if a:node =~ '[A-Z]\+'
        return 2
    endif
    if a:node =~ '[a-z]\+'
        return 3
    endif
endfunction

function! GetNumberOfPaths(node, graph, acc)
    let cave_type = GetCaveType(a:node)
    if cave_type == 1
        return 1
    endif
    if (cave_type == 2) || ((cave_type == 3) && (index(a:acc, a:node) == -1)) || ((cave_type == 0) && (len(a:acc) == 0))
        let acc = copy(a:acc)
        let number_of_paths = 0
        call add(acc, a:node)
        for node in a:graph[a:node]
            let number_of_paths += GetNumberOfPaths(node, a:graph, acc)
        endfor
        return number_of_paths
    endif
    return 0
endfunction

function! GetNumberOfPathsWithTwiceSmall(node, graph, is_twice, acc)
    let cave_type = GetCaveType(a:node)
    if cave_type == 1
        return 1
    endif
    if (cave_type == 2) || ((cave_type == 3) && (index(a:acc, a:node) == -1)) || ((cave_type == 0) && (len(a:acc) == 0)) || ((cave_type == 3) && !a:is_twice)
        let acc = copy(a:acc)
        let is_twice = a:is_twice || (cave_type == 3 && (index(a:acc, a:node) != -1))
        let number_of_paths = 0
        call add(acc, a:node)
        for node in a:graph[a:node]
            let number_of_paths += GetNumberOfPathsWithTwiceSmall(node, a:graph, is_twice, acc)
        endfor
        return number_of_paths
    endif
    return 0
endfunction
"}}}

" Part One {{{
function! SolvePartOne()
    let graph = Parse()
    return "Solution 1: " . GetNumberOfPaths('start', graph, [])
endfunction
"}}}

" Part two {{{
function! SolvePartTwo()
    let graph = Parse()
    return "Solution 2: " . GetNumberOfPathsWithTwiceSmall('start', graph, 0, [])
endfunction
"}}}
