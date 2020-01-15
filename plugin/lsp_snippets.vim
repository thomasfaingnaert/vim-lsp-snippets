if exists('g:lsp_snippets_loaded')
    finish
endif
let g:lsp_snippets_loaded = 1

let g:lsp_get_supported_capabilities = [function('lsp_snippets#get_supported_capabilities')]

