""" Settings

" Leader keys

let mapleader = " "
let maplocalleader = " "

" UI settings
set noshowmode
set cursorline
set signcolumn=yes
set winborder=rounded

" Line numbers
set number relativenumber
set numberwidth=6 " Log line numbers can be huge

" Tabs and indentation
let tab_width = 4
execute 'set tabstop=' . tab_width
execute 'set shiftwidth=' . tab_width
set expandtab
set autoindent

" Splits
set splitbelow
set splitright

" Editor behavior
set nowrap
set scrolloff=16

" Completion
set completeopt=menu,menuone,noselect
set shortmess+=c

" Visual-Block mode
set virtualedit=block

" Search & Replace
set hlsearch
if has('nvim')
    set inccommand=split
endif

" Search
set ignorecase
set smartcase

" Misc
set ttimeoutlen=50
set updatetime=300
set termguicolors

if !has('nvim')
    set guicursor=n-v-c:block,i-ci:hor20
    set background=dark
    colorscheme retrobox
endif

""" Keymaps
" Toggle relative line numbers
nnoremap <Tab> :set relativenumber!<CR>

" Paste last yanked
nmap ,p "0p
nmap ,P "0P

" Write if something changed - don't mess with metadata unnecessarily
noremap <leader>w :up<CR>

" Moving things around in Visual Mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Wrap next line to the end of current
nnoremap J mzJ`z

" Redraw without highlights
nnoremap <C-;> :nohls<CR><C-L>

" Quick search and replace - no need to type it all
" You will type <pattern>:<replace>, no need to hit arrow keys
noremap ;; :%s::g<Left><Left>
noremap ;' :%s::gc<Left><Left><Left>

" Keep cursor in the middle while scrolling
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Keep cursor in the middle while searching
nnoremap n nzzzv
nnoremap N Nzzzv

" Clipboard
xnoremap <leader>p "_dP

nnoremap <leader>d "_d
vnoremap <leader>d "_d

" System clipboard on <leader>
nnoremap <leader>p "+p
vnoremap <leader>p "+p
nnoremap <leader>P "+P

nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y

" Window movement
nmap <left>  <C-w><left>
nmap <down>  <C-w><down>
nmap <up>    <C-w><up>
nmap <right> <C-w><right>

" Quickfix lists
nnoremap <leader>j :cnext<CR>zz
nnoremap <leader>k :cprev<CR>zz
nnoremap <leader>J :lnext<CR>zz
nnoremap <leader>K :lprev<CR>zz
nnoremap <leader>q :copen<CR>
nnoremap <C-q> :cclose<CR>

" Find & Replace current word
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Disable 'Q' command
nnoremap Q <nop>

""" Overrides
" Don't press shift for command mode
" nnoremap ; :
" vnoremap ; :

