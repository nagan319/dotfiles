-- STORE CWD --
local function get_initial_cwd()
  local args = vim.fn.argv()
  if #args > 0 then
    for _, arg in ipairs(args) do
      if vim.fn.filereadable(arg) or vim.fn.isdirectory(arg) then
        return vim.fn.fnamemodify(arg, ":p:h")
      end
    end
  end
  return vim.fn.getcwd()
end

-- ------------------------------
-- 1. LAZYVIM BOOTSTRAP AND LEADER KEYS
-- ------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.initial_cwd = get_initial_cwd()
vim.g.python3_host_prog = "/usr/bin/python3"


-- ------------------------------
-- 2. LAZY SETUP WITH INLINE PLUGINS (FIXED SYNTAX)
-- ------------------------------
require("lazy").setup({
  -- LUALINE
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup()
    end
  },
  
  -- TELESCOPE
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = {'nvim-lua/plenary.nvim'},
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set('n', '<leader>ff', function()
      builtin.find_files({ cwd = vim.g.initial_cwd })
    end, {
      desc = "Use Telescope to search for files"
    })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {
      desc = "Use Telescope to grep"
    })
    end
  },
  
  -- NEO-TREE
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    config = function()
      require("neo-tree").setup({
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        window = {
          mappings = {
          }
        }
      })
      vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", {
        desc = "Toggle Neo-tree file explorer"
      })
    end
  },
  
  -- TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = {
          "c",
          "lua",
          "python",
          "javascript",
          "typescript",
          "html",
          "css",
          "markdown",
          "json",
          "yaml",
          "java",
          "cpp",
          "bash"
        },
        sync_install = false,
        highlight = {enable = true},
        indent = {enable = true}
      })
    end
  },
  
  -- MASON
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  
  -- MASON LSPCONFIG
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "bashls",
        },
      })
    end,
  },
  
  -- NVIM-LSPCONFIG
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
      end

      require("lspconfig").lua_ls.setup({
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      require("lspconfig").bashls.setup({
        on_attach = on_attach,
      })

      vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Open diagnostics float" })
      vim.diagnostic.config({
        signs = false,
        underline = true,
        virtual_text = false,
      })
    end,
  },
  
  -- NVIM-CMP
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "luasnip" },
        }),
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
      })
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavor = "mocha", -- The darkest base flavor
      -- Set to true to inherit terminal background, but we'll use custom_highlights for full control
      transparent_background = false,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
      vim.cmd('syntax enable')
    end,
  },
})


-- ------------------------------
-- 3. EDITOR OPTIONS & KEYMAPS
-- ------------------------------
vim.opt.wrap = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.mouse = ""
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.updatetime = 300
vim.opt.conceallevel = 0 
vim.opt.spell = false 
vim.opt.swapfile = false
vim.cmd('syntax enable')

-- Unified Keymap Disabling
local no_map = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap
map('n', '<Up>', '<Nop>', no_map)
map('n', '<Down>', '<Nop>', no_map)
map('n', '<Left>', '<Nop>', no_map)
map('n', '<Right>', '<Nop>', no_map)
map('v', '<Up>', '<Nop>', no_map)
map('v', '<Down>', '<Nop>', no_map)
map('v', '<Left>', '<Nop>', no_map)
map('v', '<Right>', '<Nop>', no_map)
map('i', '<Up>', '<Nop>', no_map)
map('i', '<Down>', '<Nop>', no_map)
map('i', '<Left>', '<Nop>', no_map)
map('i', '<Right>', '<Nop>', no_map)


-- ------------------------------
-- 4. MACROS
-- ------------------------------
vim.keymap.set("n", "<leader>Y", function()
  local current_line = vim.fn.line(".")
  local current_col = vim.fn.col(".")
  vim.cmd('normal! ggVG"+y')
  vim.api.nvim_win_set_cursor(0, { current_line, current_col })
end, {
  desc = "Yank entire file to system clipboard and return to original position",
})

vim.keymap.set("v", "<leader>y", '"+y', {
  desc = "Yank selected text to system clipboard",
})
