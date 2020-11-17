" Vim plugin for looking up words in an online thesaurus
" Author:       Luigi Antelmi <https://github.com/ggbioing>
" Version:      0.3.3
" Original idea and code: Nick Coleman <http://www.nickcoleman.org/>

if exists("g:loaded_online_thesaurus")
    finish
endif
let g:loaded_online_thesaurus = 1

let s:save_cpo = &cpo
set cpo&vim
let s:save_shell = &shell
if has("win32")
    let cpu_arch      = system('echo %PROCESSOR_ARCHITECTURE%')
    let s:script_name = "\\thesaurus-lookup.sh"
    let s:script_name_IT = "\\thesaurus-lookup-IT.sh"
    if isdirectory('C:\\Program Files (x86)\\Git')
        let &shell        = 'C:\\Program Files (x86)\\Git\\bin\\bash.exe'
        let s:sort        = "C:\\Program Files (x86)\\Git\\bin\\sort.exe"
    elseif isdirectory('C:\\Program Files\\Git')
        let &shell        = 'C:\\Program Files\\Git\\bin\\bash.exe'
        let s:sort        = "C:\\Program Files\\Git\\bin\\sort.exe"
    else
        echoerr 'vim-thesaurus: Cannot find git installation.'
    endif
else
    let &shell        = '/bin/sh'
    let s:script_name = "/thesaurus-lookup.sh"
    let s:script_name_IT = "/thesaurus-lookup-IT.sh"
    silent let s:sort = system('if command -v /bin/sort > /dev/null; then'
            \ . ' printf /bin/sort;'
            \ . ' else printf sort; fi')
endif

let s:path = shellescape(expand("<sfile>:p:h") . s:script_name)
let s:path_IT = shellescape(expand("<sfile>:p:h") . s:script_name_IT)

function! s:Trim(input_string)
    let l:str = substitute(a:input_string, '[\r\n]', '', '')
    return substitute(l:str, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! s:Lookup(word, ...)
    let l:word = substitute(tolower(s:Trim(a:word)), '"', '', 'g')
    let l:word_fname = fnameescape(l:word)
    let a:lang = get(a:, 1, 0)

    silent! let l:thesaurus_window = bufwinnr('^thesaurus: ')
    if l:thesaurus_window > -1
        exec l:thesaurus_window . "wincmd w"
    else
        exec ":silent keepalt belowright split thesaurus:\\ " . l:word_fname
    endif
    exec ":silent file thesaurus:\\ " . l:word_fname

    setlocal noswapfile nobuflisted nospell wrap modifiable
    setlocal buftype=nofile bufhidden=hide
    1,$d
    echo "Requesting thesaurus.com to look up \"" . l:word . "\"..."
    if a:lang == 'EN'
        exec ":silent 0r !" . s:path . " " . shellescape(l:word)
    elseif a:lang == 'IT'
        exec ":silent 0r !" . s:path_IT . " " . shellescape(l:word)
    endif


    if has("win32")
        silent! %s/\r//g
        silent! normal! gg5dd
    endif
    exec 'resize ' . (line('$') - 1)
    setlocal nomodifiable filetype=thesaurus
    let win_height=5
    exec win_height."wincmd _ | norm gg"
    nnoremap <silent> <buffer> q :q<CR>
endfunction

if !exists('g:online_thesaurus_map_keys')
    nnoremap <unique> <LocalLeader>K :OnlineThesaurusCurrentWord<CR>
    vnoremap <unique> <LocalLeader>K y:Thesaurus <C-r>"<CR>
endif

command! OnlineThesaurusCurrentWord call <SID>Lookup(expand('<cword>'),'EN')
command! OnlineThesaurusCurrentWordIT call <SID>Lookup(expand('<cword>'),'IT')
command! OnlineThesaurusLookup call <SID>Lookup(expand('<cword>'),'EN')
command! OnlineThesaurusLookupIT call <SID>Lookup(expand('<cword>'),'IT')
command! -nargs=1 Thesaurus call <SID>Lookup(<q-args>, 'EN')
command! -nargs=1 ThesaurusIT call <SID>Lookup(<q-args>, 'IT')

let &cpo = s:save_cpo
let &shell = s:save_shell
