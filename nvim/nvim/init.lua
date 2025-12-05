local vim = vim -- suppress lsp warnings
local o = vim.opt
local g = vim.g
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
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
o.laststatus = 3 
o.winborder = "rounded"
o.termguicolors = true
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
o.cmdheight = 0
o.splitright = true
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
map("n", "<leader>h", "<cmd>split term://bash<cr>", opts)
map("n", "<C-s>", "<cmd>w<cr>")
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", opts)
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<leader>ffh", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", opts)
map("n", "<leader>tl", "<cmd>TodoLocList<cr>", opts)
map("n", "<leader>tf", "<cmd>TodoQuickFix<cr>", opts)
map("n", "<leader>tt", "<cmd>TodoTelescope<cr>", opts)
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", opts)
map("n", "<leader>gdc", "<cmd>DiffviewClose<cr>", opts)
map("n", "<leader>ct", "<cmd>Themery<cr>", opts)
map("n", "<leader>ld", vim.diagnostic.open_float, opts)
map("n", "<leader>yp", function() -- copy relative filepath to clipboard
   vim.fn.setreg("+", vim.fn.expand("%"))
end)
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
local augroup = vim.api.nvim_create_augroup("my.cfg", { clear = true })
local termWinGroup = vim.api.nvim_create_augroup("TerminalWindow", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

autocmd("TermOpen", {
  group = termWinGroup, 
  callback = function()
    vim.cmd("resize 7")
  end
})



vim.cmd("colorscheme default")

local function check_parser(parser)
  if parser.source == "npm" then
    local result = vim.fn.systemlist(string.format("npm list -g --depth=0 | grep %s", parser.name))
    if #result > 0 then
      return true
    end
  end
  return false
end

local function install_parsers()
  local parsers = {
    { 
      active = true,
      configure = function()
        local command = {"npm", "list", "-g", "--depth=0" }
        local grep_command = { "grep", "typescript" } 
        local install_cmd = { "npm", "i", "-g", "typescript", "typescript-language-server" }
        pcall(vim.system, command, { text = true }, function(obj)
          pcall(vim.system, grep_command, { text = true, stdin = obj.stdout }, vim.schedule_wrap(function(piped_result)
            if piped_result.code == 0 then
              vim.lsp.enable("ts_ls")
              print("Enabled ts_ls lsp!")
            else
              print("Installing ts_ls lsp...")
              pcall(vim.system, install_cmd, { text = true}, vim.schedule_wrap(function(install_result)
                if install_result.code == 0 then
                  print("Installed ts_ls lsp!")
                  vim.lsp.enable("ts_ls")
                  print("Enabled ts_ls lsp!")
                else
                  print("ERROR: Could not install ts_ls lsp")
                end
              end))
            end
          end))
        end)
      end
    },
    {
      active = true,
      configure = function()
        local command = {"npm", "list", "-g", "--depth=0" }
        local grep_command = { "grep", "pyright" } 
        local install_cmd = { "npm", "i", "-g", "pyright" }
        pcall(vim.system, command, { text = true }, function(obj)
          pcall(vim.system, grep_command, { text = true, stdin = obj.stdout }, vim.schedule_wrap(function(piped_result)
            if piped_result.code == 0 then
              vim.lsp.enable("pyright")
              print("Enabled pyright lsp!")
            else
              print("Installing pyright lsp...")
              pcall(vim.system, install_cmd, { text = true}, vim.schedule_wrap(function(install_result)
                if install_result.code == 0 then
                  print("Installed pyright lsp!")
                  vim.lsp.enable("pyright")
                  print("Enabled pyright lsp!")
                else
                  print("ERROR: Could not install pyright lsp")
                end
              end))
            end
          end))
        end)
      end
    }
  }
  
  for index, parser in ipairs(parsers) do
    if parser.active then
      parser.configure()
    end
  end
end
local function setup_lsp()
  install_parsers()

	autocmd("LspAttach", {
		group = augroup,
		callback = function(ev)
      -- TODO: Research omnifunc
      -- Set omnifunc for LSP completion
      -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
			local bufopts = { noremap = true, silent = true, buffer = ev.buf }
			map("n", "lrd", vim.lsp.buf.definition, bufopts)
			map("i", "<C-k>", vim.lsp.completion.get, bufopts) -- open completion menu manually
			local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
			local methods = vim.lsp.protocol.Methods
			if client:supports_method(methods.textDocument_completion) then
				vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
			end
		end,
	})
end
setup_lsp()

require("nvim-tree").setup({
  filters = {
    dotfiles = true,
    git_ignored = true
  },
})

require("telescope").setup({
  pickers = {
    live_grep = {
      additional_args = function()
        return {"--hidden", "--no-ignore-vcs"}
      end
    }
  }
})

require("lualine").setup({})
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "vim", "lua", "vimdoc",
    "html", "css", "xml", "javascript",
    "jsdoc", "python", "json", "typescript",
    "csv"
  },
})

require("todo-comments").setup({})
require("themery").setup({
  themes = {
    "default", "catppuccin-latte", "catppuccin-frappe", 
    "catppuccin-macchiato", "catppuccin-mocha",
    "blue", "darkblue", 
    "delek", "desert", "elflord", 
    "evening", "habamax", "industry",
    "koehler", "lunaperche", "morning",
    "murphy", "lunaperche", "pablo",
    "peachpuff", "quiet", "retrobox",
    "ron", "shine", "slate",
    "sorbet", "torte", "unokai",
    "vim", "wildcharm", "zaibatsu",
    "zellner", 
  },
  livePreview = true
})

require("gitsigns").setup({})
-- TODO: Add nvim-cmp
-- NOTE: Think about adding which-key.nvim
-- NOTE: Look at https://erock-git-dotfiles.pgs.sh/tree/main/item/dot_config/nvim/init.lua.html
