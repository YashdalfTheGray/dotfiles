" Requires Neovim 0.11.3+ and vim-plug installed in Neovim's data directory.
" Do not also keep an init.lua in that directory.

if !has('nvim-0.11.3')
  echoerr 'This configuration requires Neovim 0.11.3 or newer.'
  finish
endif

" Plugin installation is explicit: run :PlugInstall, then restart Neovim.
" Keep the original Vim plugin directory untouched.
call plug#begin(stdpath('data') . '/plugged')
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'heavenshell/vim-jsdoc', { 'do': 'make install' }
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'sheerun/vim-polyglot'
Plug 'Raimondi/delimitMate'
Plug 'ap/vim-css-color'
Plug 'leafgarland/typescript-vim'
Plug 'dense-analysis/ale'
Plug 'frazrepo/vim-rainbow'
" Use the fzf executable on PATH, without an Intel-specific Homebrew path.
Plug 'junegunn/fzf'
Plug 'rust-lang/rust.vim'
" Supplies server configurations; Neovim itself is the LSP client.
Plug 'neovim/nvim-lspconfig'

Plug 'nlknguyen/papercolor-theme'
Plug 'joshdick/onedark.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
call plug#end()

" UI and editing. Neovim is always nocompatible.
syntax on
filetype plugin indent on
set hidden
set number
set noshowmode
set backspace=indent,eol,start
set conceallevel=0
set updatetime=100
set laststatus=2

set autoindent
set smartindent
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2
set tabstop=2
set shiftwidth=2
set expandtab
set mouse=a

" Themeing shit
set termguicolors
set background=dark
colorscheme PaperColor

highlight Normal       guibg=NONE ctermbg=NONE
highlight NormalNC     guibg=NONE ctermbg=NONE
highlight SignColumn   guibg=NONE ctermbg=NONE
highlight LineNr       guibg=NONE ctermbg=NONE
highlight EndOfBuffer  guibg=NONE ctermbg=NONE
highlight StatusLine   cterm=NONE gui=NONE
highlight StatusLineNC cterm=NONE gui=NONE

let g:lightline = { 'colorscheme': 'deus', }

" Fallback completion; native LSP overrides this in attached buffers.
set omnifunc=syntaxcomplete#Complete
set completeopt=menu,menuone,noselect
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Keep the path-entry shortcuts, with escaping for directory names with spaces.
nnoremap ,e :edit <C-R>=fnameescape(expand('%:p:h')) . '/'<CR>
nnoremap ,t :tabedit <C-R>=fnameescape(expand('%:p:h')) . '/'<CR>
nnoremap ,s :split <C-R>=fnameescape(expand('%:p:h')) . '/'<CR>
nnoremap ,v :vsplit <C-R>=fnameescape(expand('%:p:h')) . '/'<CR>
inoremap <C-e> <Esc>A
inoremap <C-a> <Esc>I
nnoremap <silent> <C-p> <Cmd>FZF<CR>
nnoremap <silent> <C-t> <Cmd>NERDTreeToggle<CR>

" NERDTree: preserve automatic opening, but skip headless/plugin-install runs.
augroup UserNERDTree
  autocmd!
  autocmd StdinReadPre * let s:std_in = 1
  autocmd VimEnter * if argc() == 0 && !exists('s:std_in') && exists(':NERDTree') && !empty(nvim_list_uis()) | NERDTree | endif
  autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
augroup END

" ALE runs command-line linters/fixers only; native LSP handles language servers.
let g:ale_disable_lsp = 1
let g:ale_completion_enabled = 0
let g:ale_linters_explicit = 1
let g:ale_use_neovim_diagnostics_api = 1
let g:ale_linters = {
\ 'javascript': ['eslint'],
\ 'javascriptreact': ['eslint'],
\ 'typescript': ['eslint'],
\ 'typescriptreact': ['eslint'],
\ 'vue': ['eslint'],
\ }

" Preserve the original choice of fixer for each language.
" ALE is the only frontend fix-on-save owner (no separate vim-prettier plugin).
let g:ale_fixers = {
\ 'javascript': ['eslint'],
\ 'javascriptreact': ['eslint'],
\ 'typescript': ['prettier'],
\ 'typescriptreact': ['prettier'],
\ 'vue': ['eslint'],
\ 'scss': ['prettier'],
\ 'html': ['prettier'],
\ }
let g:ale_fix_on_save = 1

" Keep vim-go's commands, formatting, completion, and Go language-server client.
" Do not ALSO enable native gopls with this configuration.
" Disable vim-go's default navigation mappings so Ctrl-T remains NERDTreeToggle.
let g:go_def_mapping_enabled = 0
augroup UserGoMappings
  autocmd!
  autocmd FileType go nnoremap <buffer><silent> gd <Cmd>GoDef<CR>
  autocmd FileType go nnoremap <buffer><silent> K <Cmd>GoDoc<CR>
  autocmd FileType go nnoremap <buffer><silent> <F2> <Cmd>GoRename<CR>
augroup END

" Original NERDTree file colors, grouped so re-sourcing does not duplicate them.
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg) abort
  execute 'autocmd FileType nerdtree highlight ' . a:extension . ' ctermbg=' . a:bg . ' ctermfg=' . a:fg . ' guibg=' . a:guibg . ' guifg=' . a:guifg
  execute 'autocmd FileType nerdtree syntax match ' . a:extension . ' #^\s\+.*' . a:extension . '$#'
endfunction

augroup UserNERDTreeColors
  autocmd!
  call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
  call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
  call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
  call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
  call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
  call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
  call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
  call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
  call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
  call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
  call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
  call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
  call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')
augroup END

" Unicode escapes preserve the original status symbols.
let g:NERDTreeGitStatusIndicatorMapCustom = {
\ 'Modified': "\u2739",
\ 'Staged': "\u271a",
\ 'Untracked': "\u272d",
\ 'Renamed': "\u279c",
\ 'Unmerged': "\u2550",
\ 'Deleted': "\u2716",
\ 'Dirty': "\u2717",
\ 'Clean': "\u2714\ufe0e",
\ 'Ignored': "\u2612",
\ 'Unknown': '?',
\ }

let g:user_emmet_install_global = 0
augroup UserEmmet
  autocmd!
  autocmd FileType html,css if exists(':EmmetInstall') | EmmetInstall | endif
augroup END
let g:rainbow_active = 1

" EditorConfig is built into modern Neovim; no extra plugin is needed.

" Native LSP replaces deoplete, LanguageClient-neovim, and tsuquyomi.
lua << EOF
local group = vim.api.nvim_create_augroup('UserNativeLsp', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
  group = group,
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    local function map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, {
        buffer = ev.buf,
        silent = true,
        desc = desc,
      })
    end
    map('K', vim.lsp.buf.hover, 'LSP documentation')
    map('gd', vim.lsp.buf.definition, 'Go to definition')
    map('<F2>', vim.lsp.buf.rename, 'Rename symbol')

    if client:supports_method('textDocument/completion') then
      vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
      vim.lsp.completion.enable(true, client.id, ev.buf, {
        autotrigger = true,
      })
    end
  end,
})

-- Accept the older dotted JSX/TSX filetypes produced by some retained plugins.
vim.lsp.config('ts_ls', {
  filetypes = {
    'javascript', 'javascriptreact', 'javascript.jsx',
    'typescript', 'typescriptreact', 'typescript.tsx',
  },
  get_language_id = function(_, filetype)
    local aliases = {
      ['javascript.jsx'] = 'javascriptreact',
      ['typescript.tsx'] = 'typescriptreact',
    }
    return aliases[filetype] or filetype
  end,
})

-- Do not try to start servers that are not installed. Restart after installation.
local servers = {
  ts_ls = 'typescript-language-server',
  rust_analyzer = 'rust-analyzer',
  solargraph = 'solargraph',
}
for server, executable in pairs(servers) do
  local configs = vim.api.nvim_get_runtime_file('lsp/' .. server .. '.lua', false)
  if #configs > 0 and vim.fn.executable(executable) == 1 then
    vim.lsp.enable(server)
  end
end
EOF
