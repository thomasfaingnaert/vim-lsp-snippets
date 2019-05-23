function! lsp_snippets#get_vim_completion_item(item, ...) abort
    let a:item['label'] = trim(a:item['label'])

    let l:completion = call(function('lsp#omni#default_get_vim_completion_item'), [a:item] + a:000)

    " Set trigger and snippet
    if has_key(a:item, 'insertTextFormat') && a:item['insertTextFormat'] == 2
        if has_key(a:item, 'insertText')
            let l:trigger = a:item['label']
            let l:snippet = call(g:lsp_snippets_get_snippet[0], [a:item['insertText']])

            let l:user_data = {'vim-lsp-snippets': { 'trigger': l:trigger, 'snippet': l:snippet } }
            let l:completion['user_data'] = json_encode(l:user_data)
        elseif has_key(a:item, 'textEdit')
            let l:user_data = json_decode(l:completion['user_data'])

            let l:trigger = a:item['label']
            let l:snippet = call(g:lsp_snippets_get_snippet[0], [l:user_data['vim-lsp/textEdit']['newText']])

            let l:user_data['vim-lsp/textEdit']['newText'] = call(g:lsp_snippets_get_new_text[0], [l:trigger])

            let l:user_data['vim-lsp-snippets'] = { 'trigger': l:trigger, 'snippet': l:snippet }
            let l:completion['user_data'] = json_encode(l:user_data)
        endif
    endif

    return l:completion
endfunction

function! lsp_snippets#get_supported_capabilities(server_info) abort
    let l:capabilities = lsp#default_get_supported_capabilities(a:server_info)

    if has_key(a:server_info, 'config') && has_key(a:server_info['config'], 'snippets') &&
                \ a:server_info['config']['snippets'] == 0
        return l:capabilities
    endif

    let l:capabilities['textDocument'] =
                \   {
                \       'completion': {
                \           'completionItem': {
                \               'snippetSupport': v:true
                \           }
                \       }
                \   }

    return l:capabilities
endfunction

function! s:timer_callback(timer) abort
    call call(g:lsp_snippets_expand_snippet[0], [s:trigger, s:snippet])
endfunction

function! s:handle_snippet(item) abort
    if !has_key(a:item, 'user_data')
        return
    endif

    try
        let l:user_data = json_decode(a:item['user_data'])
    catch
        return
    endtry

    if (type(l:user_data) != type({})) || (!has_key(l:user_data, 'vim-lsp-snippets'))
        return
    endif

    let s:trigger = l:user_data['vim-lsp-snippets']['trigger']
    let s:snippet = l:user_data['vim-lsp-snippets']['snippet']

    call timer_start(0, function('s:timer_callback'))
endfunction

augroup lsp_snippets
    autocmd!
    autocmd User lsp_complete_done call s:handle_snippet(v:completed_item)
augroup END

function! lsp_snippets#default_get_snippet(text) abort
    return a:text
endfunction

function! lsp_snippets#default_get_new_text(trigger) abort
    return a:trigger
endfunction

function! lsp_snippets#default_expand_snippet(trigger, snippet) abort
    " Do nothing.
endfunction
