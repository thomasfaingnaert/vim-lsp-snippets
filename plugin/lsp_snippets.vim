if exists('g:lsp_snippets_loaded')
    finish
endif
let g:lsp_snippets_loaded = 1

let g:lsp_get_vim_completion_item = [function('lsp_snippets#get_vim_completion_item')]
let g:lsp_get_supported_capabilities = [function('lsp_snippets#get_supported_capabilities')]

let g:lsp_snippets_get_snippet = get(g:, 'lsp_snippets_get_snippet', [function('lsp_snippets#default_get_snippet')])
let g:lsp_snippets_get_new_text = get(g:, 'lsp_snippets_get_new_text', [function('lsp_snippets#default_get_new_text')])
let g:lsp_snippets_expand_snippet = get(g:, 'lsp_snippets_expand_snippet', [function('lsp_snippets#default_expand_snippet')])
