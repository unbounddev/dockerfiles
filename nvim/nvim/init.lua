local vim = vim -- suppress lsp warnings
local o = vim.opt
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = true
o.wrap = false
o.autoread = true
-- o.list = true -- show hidden characters
-- look at listchars options
o.signcolumn = "yes"
o.backspace = "indent,eol,start"
o.shell = "/bin/bash"
o.colorcolumn = "100"
o.completeopt = { "menuone", "noselect", "popup" }
o.wildmode = { "noselect:lastused", "list:full" }
o.pumheight = 15
o.laststatus = 0 -- TODO: look into this
o.winborder = "rounded"
-- TODO: look at termguicolors
-- TODO: look at winblend
o.undofile = true
o.smartcase = true
o.swapfile = false
o.number = true
o.relativenumber = true
-- TODO: smartindent
o.foldmethod = "indent" -- TODO: look into this
o.foldlevelstart = 99 -- no folds closed
o.splitbelow = true
o.splitright = true
local g = vim.g
g.mapleader = " "
g.maplocalleader = " "

local opts = { silent = true }
local map = vim.keymap.set
map("t", "<Esc>", [[<C-\><C-n>]], opts)
map("n", "Q", "<nop>", opts)
map("n", "<C-k>", "<cmd>wincmd k<cr>", opts)
map("n", "<C-j>", "<cmd>wincmd j<cr>", opts)
map("n", "<C-h>", "<cmd>wincmd h<cr>", opts)
map("n", "<C-l>", "<cmd>wincmd l<cr>", opts)
-- map("n", "<leader>t", "<cmd>bd!<cr>", opts)
-- map("n", "<leader>f", "<cmd>term fish<cr>", opts)
map("n", "<leader>t", "<cmd>split term://bash<cr>", opts)
map("n", "<C-s>", "<cmd>w<cr>")
-- map({ "n", "v" }, "<leader>u", "<cmd>GitLink<cr>", opts)
-- map("n", "<leader>e", vim.diagnostic.open_float, opts)
-- map("n", "<leader>y", function() -- copy relative filepath to clipboard
--    vim.fn.setreg("+", vim.fn.expand("%"))
-- end)
-- map("n", "<leader>r", function() -- toggle lsp loclist
--   local loclist_win = vim.fn.getloclist(0, { winid = 0 }).winid
--   if loclist_win > 0 then
--     vim.cmd("lclose")
--   else
--     vim.diagnostic.setloclist({ open = true })
--   end
-- end, opts)
-- map("n", "<leader>q", function() -- toggle quickfix
-- 	for _, win in ipairs(vim.fn.getwininfo()) do
-- 		if win.quickfix == 1 then
-- 			vim.cmd("cclose")
-- 			return
-- 		end
-- 	end
-- 	vim.cmd("copen")
-- end)
-- map("n", "<leader>d", ":DiffviewOpen ")
-- map("n", "<leader>a", "<cmd>lua MiniFiles.open()<cr>")
-- map("n", "<leader>s", "<cmd>Pick files<cr>")
-- map("n", "<leader>g", "<cmd>Pick grep_live<cr>")
-- map("n", "<leader>b", "<cmd>Pick buffers<cr>")
local augroup = vim.api.nvim_create_augroup("my.cfg", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

local function setup_lsp()
  vim.lsp.enable({
    "lua_ls",
  })
end

vim.cmd("colorscheme desert")

-- setup_lsp()

-- NOTE: Look at https://erock-git-dotfiles.pgs.sh/tree/main/item/dot_config/nvim/init.lua.html
