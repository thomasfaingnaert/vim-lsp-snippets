function! s:dict_set(dict, keys, value) abort
    " Top-level key
    let l:key = a:keys[0]

    " Base case
    if len(a:keys) == 1
        let a:dict[l:key] = a:value
        return
    endif

    if !has_key(a:dict, l:key)
        let a:dict[l:key] = {}
    endif

    call s:dict_set(a:dict[l:key], a:keys[1:], a:value)
endfunction

function! lsp_snippets#get_supported_capabilities(server_info) abort
    let l:capabilities = lsp#default_get_supported_capabilities(a:server_info)

    if has_key(a:server_info, 'config') && has_key(a:server_info['config'], 'snippets') &&
                \ a:server_info['config']['snippets'] == 0
        return l:capabilities
    endif

    call s:dict_set(l:capabilities, ['textDocument', 'completion', 'completionItem', 'snippetSupport'], v:true)

    return l:capabilities
endfunction

