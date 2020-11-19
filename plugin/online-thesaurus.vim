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
    let s:script_name_FR = "\\thesaurus-lookup-FR.sh"
    let s:script_name_IT = "\\thesaurus-lookup-IT.sh"
    let s:script_name_IT_CA_trova = "\\thesaurus-lookup-IT_CA_trova.sh"
    let s:script_name_IT_CA_definisci = "\\thesaurus-lookup-IT_CA_definisci.sh"
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
    let s:script_name_FR = "/thesaurus-lookup-FR.sh"
    let s:script_name_IT = "/thesaurus-lookup-IT.sh"
    let s:script_name_IT_CA_trova = "/thesaurus-lookup-IT_CA_trova.sh"
    let s:script_name_IT_CA_definisci = "/thesaurus-lookup-IT_CA_definisci.sh"
    silent let s:sort = system('if command -v /bin/sort > /dev/null; then'
            \ . ' printf /bin/sort;'
            \ . ' else printf sort; fi')
endif

let s:path = shellescape(expand("<sfile>:p:h") . s:script_name)
let s:path_FR = shellescape(expand("<sfile>:p:h") . s:script_name_FR)
let s:path_IT = shellescape(expand("<sfile>:p:h") . s:script_name_IT)
let s:path_IT_CA_trova = shellescape(expand("<sfile>:p:h") . s:script_name_IT_CA_trova)
let s:path_IT_CA_definisci = shellescape(expand("<sfile>:p:h") . s:script_name_IT_CA_definisci)

function! s:Trim(input_string)
    let l:str = substitute(a:input_string, '[\r\n]', '', '')
    return substitute(l:str, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! s:Lookup(word, ...)
    let a:lang = get(a:, 1, 0)
    if a:lang == 'IT_CA_definisci'
        let l:word = getline('.')
    else
        let l:word = substitute(tolower(s:Trim(a:word)), '"', '', 'g')
    endif
    let l:word_fname = fnameescape(l:word)

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
    elseif a:lang == 'IT_CA_trova'
        exec ":silent 0r !" . s:path_IT_CA_trova . " " . shellescape(l:word)
    elseif a:lang == 'IT_CA_definisci'
        exec ":silent 0r !" . s:path_IT_CA_definisci . " " . shellescape(l:word)
    elseif a:lang == 'FR'
        exec ":silent 0r !" . s:path_FR . " " . shellescape(l:word)
    endif


    if has("win32")
        silent! %s/\r//g
        silent! normal! gg5dd
    endif
    exec 'resize ' . (line('$') - 1)
    setlocal nomodifiable filetype=thesaurus
    let win_height=10
    exec win_height."wincmd _ | norm gg"
    nnoremap <silent> <buffer> q :q<CR>
endfunction

if !exists('g:online_thesaurus_map_keys')
    nnoremap <unique> <LocalLeader>K :OnlineThesaurusCurrentWord<CR>
    vnoremap <unique> <LocalLeader>K y:Thesaurus <C-r>"<CR>
endif

command! OnlineThesaurusCurrentWord call <SID>Lookup(expand('<cword>'),'EN')
command! OnlineThesaurusCurrentWordFR call <SID>Lookup(expand('<cword>'),'FR')
command! OnlineThesaurusCurrentWordIT call <SID>Lookup(expand('<cword>'),'IT')
command! OnlineThesaurusCurrentWordITCA call <SID>Lookup(expand('<cword>'),'IT_CA_trova')
command! OnlineThesaurusCurrentWordITCAdef call <SID>Lookup(expand('<cword>'),'IT_CA_definisci')

command! OnlineThesaurusLookup call <SID>Lookup(expand('<cword>'),'EN')
command! OnlineThesaurusLookupFR call <SID>Lookup(expand('<cword>'),'FR')
command! OnlineThesaurusLookupIT call <SID>Lookup(expand('<cword>'),'IT')

command! -nargs=1 Thesaurus call <SID>Lookup(<q-args>, 'EN')
command! -nargs=1 ThesaurusFR call <SID>Lookup(<q-args>, 'FR')
command! -nargs=1 ThesaurusIT call <SID>Lookup(<q-args>, 'IT')
command! -nargs=1 ThesaurusITCAtrova call <SID>Lookup(<q-args>, 'IT_CA_trova')
command! -nargs=1 ThesaurusITCAdefinisci call <SID>Lookup(<q-args>, 'IT_CA_definisci')

let &cpo = s:save_cpo
let &shell = s:save_shell
