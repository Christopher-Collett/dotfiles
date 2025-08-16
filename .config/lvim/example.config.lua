-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.transparent_window = true
vim.opt_global.textwidth = 100
vim.opt_global.colorcolumn = "+1"

vim.opt_global.tabstop = 4
vim.opt_global.shiftwidth = 4
vim.opt_global.expandtab = true

lvim.builtin.nvimtree.setup.view = {
    side = 'right',
    width = '25%',
}

-- find and replace (make a function for this sometime)
-- vimgrep /$pattern/g ./**/*.{c,h,cpp,tpp,hpp,build} -- or whatever other file endings you want (could be another parameter)
-- cdo s/$pattern/$replacement/

-- Auto save any file every time the text has changed.
vim.api.nvim_create_autocmd({"TextChanged", "InsertLeave"},
    {
        pattern = "*",
        callback = function (event)
            if event.buftype or event.file == '' then return end
            vim.api.nvim_buf_call(event.buf, function()
                vim.schedule(function() vim.cmd 'silent! update' end)
            end)
        end
    })

-- Variable assignments
lvim.keys.normal_mode["<leader>cc"] = "<cmd>:BufferKill<cr>"

-- Use tab and shift tab to cycle between tabs
lvim.keys.normal_mode["<Tab>"] = "<cmd>:bnext<cr>"
lvim.keys.normal_mode["<S-Tab>"] = "<cmd>:bprev<cr>"

-- Use <leader># to go to a specific tab
lvim.keys.normal_mode["<leader>1"] = "<cmd>:BufferLineGoToBuffer1<cr>"
lvim.keys.normal_mode["<leader>2"] = "<cmd>:BufferLineGoToBuffer2<cr>"
lvim.keys.normal_mode["<leader>3"] = "<cmd>:BufferLineGoToBuffer3<cr>"
lvim.keys.normal_mode["<leader>4"] = "<cmd>:BufferLineGoToBuffer4<cr>"
lvim.keys.normal_mode["<leader>5"] = "<cmd>:BufferLineGoToBuffer5<cr>"
lvim.keys.normal_mode["<leader>6"] = "<cmd>:BufferLineGoToBuffer6<cr>"
lvim.keys.normal_mode["<leader>7"] = "<cmd>:BufferLineGoToBuffer7<cr>"
lvim.keys.normal_mode["<leader>8"] = "<cmd>:BufferLineGoToBuffer8<cr>"
lvim.keys.normal_mode["<leader>9"] = "<cmd>:BufferLineGoToBuffer9<cr>"

-- Add doxygen highlighting
table.insert(lvim.plugins, {
  "Blackcyan30/nvim-doccomment-tags",
  ft = { "c", "cpp", "h", "hpp" },
  config = function()
    --optional configuration here
    require("nvim-doccomment-tags.doccomment-tags").setup({
      tags = {
        "@brief",
        "@copyright",
        "@file",
        "@param",
        "@tparam",
        "@ret",
        "@return",
        "@details",
      },
      hl_group = "Keyword",
    })
  end,
})

-- Show symbol tree
table.insert(lvim.plugins, {
    "hedyhli/outline.nvim",
    config = function()
        require("outline").setup()
        vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline"})
    end,
})

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "basedpyright" })
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
  return server ~= "pyright"
end, lvim.lsp.automatic_configuration.skipped_servers)

-- Add linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { name = "flake8" },
  {
    name = "shellcheck",
    args = { "--severity", "warning" },
  },
}

-- Add code actions
local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
  {
    name = "proselint",
  },
}

-- vim.cmd('!python3 -c "from powerline.vim import setup as powerline_setup; powerline_setup(); del powerline_setup"')
-- vim.cmd('!python3 powerline_setup()')
-- vim.cmd('!python3 del powerline_setup')

-----------------------------------------------------------------------------------------------
-- The following is obtained from https://github.com/LunarVim/starter.lvim/blob/c-ide/config.lua
-----------------------------------------------------------------------------------------------
lvim.format_on_save = false
vim.diagnostic.config({virtual_text = true})

lvim.builtin.treesitter.highlight.enable = true

-- auto install treesitter parsers
lvim.builtin.treesitter.ensure_installed = { "cpp", "c" }

-- Additional Plugins
table.insert(lvim.plugins, {
  "p00f/clangd_extensions.nvim",
})

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "clangd" })

-- some settings can only be passed as commandline flags, see `clangd --help`
local clangd_flags = {
  "--background-index",
  "--fallback-style=Google",
  "--all-scopes-completion",
  "--clang-tidy",
  "--log=error",
  "--suggest-missing-includes",
  "--cross-file-rename",
  "--completion-style=detailed",
  "--pch-storage=memory", -- could also be disk
  "--folding-ranges",
  "--enable-config", -- clangd 11+ supports reading from .clangd configuration file
  "--offset-encoding=utf-16", --temporary fix for null-ls
  -- "--limit-references=1000",
  -- "--limit-resutls=1000",
  -- "--malloc-trim",
  -- "--clang-tidy-checks=-*,llvm-*,clang-analyzer-*,modernize-*,-modernize-use-trailing-return-type",
  -- "--header-insertion=never",
  -- "--query-driver=<list-of-white-listed-complers>"
}

local provider = "clangd"

require'lspconfig'.clangd.setup{
    filetypes = {"c", "cpp", "tpp"}
}

local custom_on_attach = function(client, bufnr)
  require("lvim.lsp").common_on_attach(client, bufnr)

  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "<leader>t", "<cmd>ClangdSwitchSourceHeader<cr>", opts)
  vim.keymap.set("x", "<leader>lA", "<cmd>ClangdAST<cr>", opts)
  vim.keymap.set("n", "<leader>lH", "<cmd>ClangdTypeHierarchy<cr>", opts)
  vim.keymap.set("n", "<leader>lt", "<cmd>ClangdSymbolInfo<cr>", opts)
  vim.keymap.set("n", "<leader>lm", "<cmd>ClangdMemoryUsage<cr>", opts)

  require("clangd_extensions.inlay_hints").setup_autocmd()
  require("clangd_extensions.inlay_hints").set_inlay_hints()
end

local status_ok, project_config = pcall(require, "rhel.clangd_wrl")
if status_ok then
  clangd_flags = vim.tbl_deep_extend("keep", project_config, clangd_flags)
end

local custom_on_init = function(client, bufnr)
  require("lvim.lsp").common_on_init(client, bufnr)
  require("clangd_extensions.config").setup {}
  require("clangd_extensions.ast").init()
  vim.cmd [[
  command ClangdToggleInlayHints lua require('clangd_extensions.inlay_hints').toggle_inlay_hints()
  command -range ClangdAST lua require('clangd_extensions.ast').display_ast(<line1>, <line2>)
  command ClangdTypeHierarchy lua require('clangd_extensions.type_hierarchy').show_hierarchy()
  command ClangdSymbolInfo lua require('clangd_extensions.symbol_info').show_symbol_info()
  command -nargs=? -complete=customlist,s:memuse_compl ClangdMemoryUsage lua require('clangd_extensions.memory_usage').show_memory_usage('<args>' == 'expand_preamble')
  ]]
end

local opts = {
  cmd = { provider, unpack(clangd_flags) },
  on_attach = custom_on_attach,
  on_init = custom_on_init,
}

require("lvim.lsp.manager").setup("clangd", opts)

-- install codelldb with :MasonInstall codelldb
-- configure nvim-dap (codelldb)
lvim.builtin.dap.on_config_done = function(dap)
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      -- provide the absolute path for `codelldb` command if not using the one installed using `mason.nvim`
      command = "codelldb",
      args = { "--port", "${port}" },

      -- On windows you may have to uncomment this:
      -- detached = false,
    },
  }

  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        local path
        vim.ui.input({ prompt = "Path to executable: ", default = vim.loop.cwd() .. "/build/" }, function(input)
          path = input
        end)
        vim.cmd [[redraw]]
        return path
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
  }

  dap.configurations.c = dap.configurations.cpp
end

