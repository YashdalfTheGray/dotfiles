" Requires Neovim 0.11.3+ and vim-plug installed in Neovim's data directory.
" Do not also keep an init.lua in that directory.

" set a better leader
let mapleader = " "
let maplocalleader = "\\"

if !has('nvim-0.11.3')
  echoerr 'This configuration requires Neovim 0.11.3 or newer.'
  finish
endif

" Plugin installation is explicit: run :PlugInstall, then restart Neovim.
" Keep the original Vim plugin directory untouched.
call plug#begin(stdpath('data') . '/plugged')
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'heavenshell/vim-jsdoc', { 'do': 'make install' }
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'Raimondi/delimitMate'
Plug 'ap/vim-css-color'
Plug 'dense-analysis/ale'
Plug 'HiPhish/rainbow-delimiters.nvim'
Plug 'junegunn/fzf'
Plug 'ibhagwan/fzf-lua'
Plug 'rust-lang/rust.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'nlknguyen/papercolor-theme'
Plug 'joshdick/onedark.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'folke/which-key.nvim'
Plug 'folke/flash.nvim'
Plug 'folke/trouble.nvim'
Plug 'folke/todo-comments.nvim'
Plug 'echasnovski/mini.ai'
Plug 'saghen/blink.cmp', { 'tag': 'v1.*' }
Plug 'rafamadriz/friendly-snippets'
call plug#end()

" UI and editing. Neovim is always nocompatible.
syntax on
filetype plugin indent on
set hidden
set number
set relativenumber
set noshowmode
set backspace=indent,eol,start
set conceallevel=0
set updatetime=100
set laststatus=2
set autoindent
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2
set tabstop=2
set shiftwidth=2
set expandtab
set mouse=a
set signcolumn=yes
set cursorline
set scrolloff=4
set sidescrolloff=8
set ignorecase smartcase
set undofile
set splitright splitbelow
set clipboard=unnamedplus
set confirm
set inccommand=nosplit

" delimitmate
let delimitMate_expand_cr = 1

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
" Match iTerm2's Prism preset (background #0b1326)
highlight CursorLine   guibg=#121c33
highlight NormalFloat  guibg=NONE
highlight FloatBorder  guibg=NONE guifg=#5e6f90


" Keep the path-entry shortcuts, with escaping for directory names with spaces.
nnoremap ,e :edit <C-R>=fnameescape(expand('%:p:h')) . '/'<CR>
nnoremap ,t :tabedit <C-R>=fnameescape(expand('%:p:h')) . '/'<CR>
nnoremap ,s :split <C-R>=fnameescape(expand('%:p:h')) . '/'<CR>
nnoremap ,v :vsplit <C-R>=fnameescape(expand('%:p:h')) . '/'<CR>
inoremap <C-e> <Esc>A
inoremap <C-a> <Esc>I
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
\ 'javascript': ['prettier', 'eslint'],
\ 'javascriptreact': ['prettier', 'eslint'],
\ 'typescript': ['prettier', 'eslint'],
\ 'typescriptreact': ['prettier', 'eslint'],
\ 'vue': ['prettier', 'eslint'],
\ 'scss': ['prettier'],
\ 'html': ['prettier'],
\ 'json': ['prettier'],
\ }

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

  end,
})

-- Do not try to start servers that are not installed. Restart after installation.
local servers = {
  tsc = 'tsc',
  rust_analyzer = 'rust-analyzer',
  solargraph = 'solargraph',
}
for server, executable in pairs(servers) do
  local configs = vim.api.nvim_get_runtime_file('lsp/' .. server .. '.lua', false)
  if #configs > 0 and vim.fn.executable(executable) == 1 then
    vim.lsp.enable(server)
  end
end

require('nvim-treesitter').install({ 'javascript', 'typescript', 'tsx', 'json', 'jsdoc' })
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json' },
  callback = function() pcall(vim.treesitter.start) end,
})

require('gitsigns').setup({
  current_line_blame = true,
})

local fzf = require('fzf-lua')
fzf.setup({})
vim.keymap.set('n', '<C-p>', fzf.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>/', fzf.live_grep, { desc = 'Grep project' })
vim.keymap.set('n', '<leader>b', fzf.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>r', fzf.lsp_references, { desc = 'References' })
vim.keymap.set('n', '<leader>d', fzf.diagnostics_document, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>.', fzf.resume, { desc = 'Resume last picker' })

local deus = {
  normal  = { a = { fg = '#292c33', bg = '#98c379', gui = 'bold' }, b = { fg = '#abb2bf', bg = '#3e4452' }, c = { fg = '#abb2bf', bg = '#292c33' } },
  insert  = { a = { fg = '#292c33', bg = '#61afef', gui = 'bold' } },
  visual  = { a = { fg = '#292c33', bg = '#c678dd', gui = 'bold' } },
  replace = { a = { fg = '#292c33', bg = '#e06c75', gui = 'bold' } },
  inactive = { a = { fg = '#abb2bf', bg = '#3e4452' }, b = { fg = '#abb2bf', bg = '#3e4452' }, c = { fg = '#abb2bf', bg = '#292c33' } },
}

require('lualine').setup({
  options = { theme = deus },
  sections = {
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_x = { 'lsp_status', 'filetype' },
  },
})

require('blink.cmp').setup({
  keymap = {
    preset = 'default',                -- <C-y> accepts, <C-e> closes, <C-space> opens docs
    ['<Tab>']   = { 'select_next', 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    ['<CR>']    = { 'accept', 'fallback' },
  },
  completion = {
    list = { selection = { preselect = false } },
    menu = { border = 'rounded' },
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
  },
  signature = { enabled = true },      -- parameter hints while you type arguments
  sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
})

vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities() })

local function blink_colors()
  local hl = function(name, opts) vim.api.nvim_set_hl(0, name, opts) end
  -- panel: see-through, so the terminal's navy shows; the rounded border outlines it
  hl('BlinkCmpMenu',          { fg = '#d0d0d0', bg = 'NONE' })
  hl('BlinkCmpMenuBorder',    { fg = '#3e4452', bg = 'NONE' })
  hl('BlinkCmpMenuSelection', { bg = '#1e2c49', bold = true })   -- Prism's selection color
  hl('BlinkCmpLabelMatch',    { fg = '#61afef', bold = true })   -- the letters you typed
  hl('BlinkCmpLabelDetail',   { fg = '#808080' })
  hl('BlinkCmpLabelDescription', { fg = '#808080' })
  hl('BlinkCmpDoc',           { fg = '#d0d0d0', bg = 'NONE' })
  hl('BlinkCmpDocBorder',     { fg = '#3e4452', bg = 'NONE' })
  hl('BlinkCmpDocSeparator',  { fg = '#3e4452', bg = 'NONE' })
  hl('BlinkCmpSignatureHelp', { fg = '#d0d0d0', bg = 'NONE' })
  hl('BlinkCmpSignatureHelpBorder', { fg = '#3e4452', bg = 'NONE' })
  hl('BlinkCmpSignatureHelpActiveParameter', { fg = '#98c379', bold = true })
  hl('BlinkCmpScrollBarThumb', { bg = '#4f5258' })
  -- item icons: PaperColor's syntax colors
  local kinds = {
    ['#00afaf'] = { 'Function', 'Method', 'Constructor', 'Keyword', 'Operator' },
    ['#afd700'] = { 'Class', 'Interface', 'Struct', 'Enum', 'TypeParameter', 'Module' },
    ['#d7875f'] = { 'Variable', 'Field', 'Property', 'Reference' },
    ['#ff5faf'] = { 'Constant', 'EnumMember', 'Value', 'Unit' },
    ['#d7af5f'] = { 'Snippet' },
    ['#808080'] = { 'Text' },
    ['#d0d0d0'] = { 'File', 'Folder', 'Event', 'Color' },
  }
  for color, names in pairs(kinds) do
    for _, kind in ipairs(names) do hl('BlinkCmpKind' .. kind, { fg = color }) end
  end
  -- fix PaperColor's selection for the built-in menu too (e.g. : command completion)
  hl('PmenuSel', { bg = '#1e2c49', bold = true })
end
blink_colors()
vim.api.nvim_create_autocmd('ColorScheme', { group = group, callback = blink_colors })

require('which-key').setup({ preset = 'modern' })
require('which-key').add({
  { '<leader>x', group = 'diagnostics/lists' },
})

require('flash').setup({})
vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash jump' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end, { desc = 'Flash select node' })
vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Flash remote' })

require('trouble').setup({})
vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (project)' })
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Diagnostics (buffer)' })
vim.keymap.set('n', '<leader>xs', '<cmd>Trouble symbols toggle<cr>', { desc = 'Symbols' })
vim.keymap.set('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix list' })

require('todo-comments').setup({})
vim.keymap.set('n', ']t', function() require('todo-comments').jump_next() end, { desc = 'Next TODO' })
vim.keymap.set('n', '[t', function() require('todo-comments').jump_prev() end, { desc = 'Previous TODO' })
vim.keymap.set('n', '<leader>xt', '<cmd>Trouble todo toggle<cr>', { desc = 'TODOs' })

require('nvim-treesitter-textobjects').setup({ move = { set_jumps = true } })
local move = require('nvim-treesitter-textobjects.move')
for key, query in pairs({ f = '@function.outer', c = '@class.outer' }) do
  vim.keymap.set({ 'n', 'x', 'o' }, ']' .. key, function() move.goto_next_start(query, 'textobjects') end, { desc = 'Next ' .. query })
  vim.keymap.set({ 'n', 'x', 'o' }, '[' .. key, function() move.goto_previous_start(query, 'textobjects') end, { desc = 'Previous ' .. query })
end

local ai = require('mini.ai')
ai.setup({
  n_lines = 500,
  custom_textobjects = {
    f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),  -- daf / cif: function
    c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),        -- dac / cic: class
    u = ai.gen_spec.function_call(),                                               -- diu: inside a call's ( )
  },
})

EOF
