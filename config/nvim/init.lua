-------- PLUGINS --------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Look
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({})
    end,
  },
  { "lewis6991/gitsigns.nvim", config = true },

  -- Editing & Navigation
  { "windwp/nvim-autopairs",   config = true },
  { "numToStr/Comment.nvim",   config = true },
  "mbbill/undotree",
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim"
    },
    branch = "0.1.x",
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          layout_strategy = "flex",
          mappings = {
            i = {
              ["<esc>"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--follow", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
        extenstions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          -- ["ui-select"] = {
          --   require('telescope.themes').get_dropdown {
          --
          --   }
          -- }
        },
      })

      require("telescope").load_extension("ui-select")
    end,
  },

  -- Integrations
  "tpope/vim-fugitive",
  "nvim-lua/plenary.nvim",
  {
    "mileszs/ack.vim",
    init = function()
      vim.g.ackprg = "rg --sort path --vimgrep --smart-case --no-heading"
    end,
  },
  -- nice things for netrw
  "tpope/vim-vinegar",
  "kassio/neoterm",
  {
    -- Install markdown preview, use npx if available.
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function(plugin)
      if vim.fn.executable "npx" then
        vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
      else
        vim.cmd [[Lazy load markdown-preview.nvim]]
        vim.fn["mkdp#util#install"]()
      end
    end,
    init = function()
      if vim.fn.executable "npx" then vim.g.mkdp_filetypes = { "markdown" } end
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui",            types = true, },
      "nvim-neotest/nvim-nio",
      { "theHamsta/nvim-dap-virtual-text", opts = { enabled = true, }, },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()

      dap.set_log_level('TRACE')
      vim.keymap.set('n', '<F5>', function() dap.continue() end)
      vim.keymap.set('n', '<F9>', function() dap.toggle_breakpoint() end)
      vim.keymap.set('n', '<F10>', function() dap.step_over() end)
      vim.keymap.set('n', '<F11>', function() dap.step_into() end)
      vim.keymap.set('n', '<F12>', function() dap.step_out() end)
      -- vim.keymap.set("n", '<leader>dk', function() require('dap').continue() end)
      -- vim.keymap.set("n", '<leader>dl', function() require('dap').run_last() end)
      vim.keymap.set("n", '<leader>b', function() dap.toggle_breakpoint() end)

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end

      -- close Dap UI with :DapCloseUI
      vim.api.nvim_create_user_command("DapCloseUI", function()
        require("dapui").close()
      end, {})

      dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/lldb",
        name = "lldb",
      }

      dap.configurations.zig = {
        {
          name = 'Launch',
          type = 'lldb',
          request = 'launch',
          program = '${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}',
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
        },
      }
    end,
  },

  -- Syntax
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  "nvim-treesitter/nvim-treesitter-context",
  "nvim-treesitter/nvim-treesitter-textobjects",
  "JoosepAlviste/nvim-ts-context-commentstring",
  { "tpope/vim-jdaddy",                         ft = "json" },
  { "neoclide/jsonc.vim",                       ft = "json" },
  { "ziglang/zig.vim",                          ft = "zig" },
  {
    "chrisgrieser/nvim-spider",
    keys = {
      {
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "o", "x" },
      },
    },
  },
  "tpope/vim-sleuth",

  -- LSP

  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "b0o/schemastore.nvim",
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"
      },
      "rafamadriz/friendly-snippets",
      "hrsh7th/cmp-emoji",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      -- require('luasnip.loaders.from_vscode').lazy_load()

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
            and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "lazydev" },
          { name = "emoji" },
        },
        completion = {
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
          col_offset = -3,
          side_padding = 0,
          autocomplete = false,
        },
        window = {
          completion = {
            border = "rounded",
          },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local lspkind_config = {
              mode = "symbol_text",
              maxwidth = 50,
              -- preset = "codicons",
            }
            local kind = require("lspkind").cmp_format(lspkind_config)(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            local item = entry:get_completion_item()
            kind.kind = " " .. (strings[1] or "") .. " "

            if item.detail then
              kind.menu = "    " .. item.detail
            else
              kind.menu = "    " .. (strings[2] or "")
            end

            -- vim.notify(vim.inspect(entry.completion_item))
            -- item.data.file -> filename

            return kind
          end,
        },
        experimental = {
          ghost_text = true,
        },
        view = {
          entries = { name = "custom", selection_order = "near_cursor" },
        },
      })
    end,
  },
  { "folke/lazydev.nvim",     ft = "lua" },
  "nvimtools/none-ls.nvim",
  "ranjithshegde/ccls.nvim",
  { "mfussenegger/nvim-jdtls" },
})
require("telescope").load_extension("fzf")
-------- PLUGINS --------

-------- SETTINGS --------
-- Enable mouse usage (all modes)
vim.opt.mouse = "a"

vim.opt.mousescroll = "ver:3,hor:0"

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.scrolloff = 8
vim.opt.showmode = false
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.wildmenu = true
vim.opt.ruler = true
vim.opt.smarttab = true

-- Do smart case matching
vim.opt.smartcase = true
-- Do case insensitive matching
vim.opt.ignorecase = true
-- Incremental search
vim.opt.hlsearch = true
vim.opt.wildmode = { "list", "longest", "full" }
vim.opt.backspace = { "indent", "eol", "start" }
-- Hide buffers when they are abandoned
vim.opt.hidden = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.laststatus = 2
vim.opt.textwidth = 79
-- Show (partial) command in status line.
-- vim.opt.showcmd
vim.opt.linespace = 0
-- Show matching brackets.
vim.opt.showmatch = true
vim.opt.wrap = true
vim.opt.completeopt = { "menu", "menuone", "preview", "noselect", "noinsert" }
vim.opt.shortmess = "atIc"
vim.opt.cmdheight = 1

-- folding
vim.opt.foldenable = true
vim.opt.foldmethod = "manual"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99

-- do not highlight lines longer than 800 char
vim.opt.synmaxcol = 800

vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.breakindent = true
vim.opt.breakindentopt = "sbr"
vim.opt.showbreak = "└  "
vim.opt.inccommand = "nosplit"
vim.opt.diffopt:append({ "vertical" })
vim.opt.viewoptions = { "folds", "cursor" }

-- Leader
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { silent = true, noremap = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--don't wait too long for next keystroke
vim.opt.timeoutlen = 500
vim.opt.updatetime = 50

vim.opt.iminsert = 0
vim.opt.imsearch = 0

vim.opt.formatoptions = "qrn1j"
vim.opt.wildignorecase = true
vim.opt.history = 500
vim.opt.complete = { ".", "b", "u", "]", "kspell" }
vim.opt.wildignore:append({ "**/node_modules" })
vim.opt.clipboard:append({ "unnamedplus" })

-- Backups
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.swapfile = false

vim.g.netrw_localrmdir = "rm -r"
vim.g.netrw_keepdir = 0
vim.g.netrw_winsize = 30

-- rg
-- let g:ack_autoclose = 1
vim.g.ackprg = "rg --vimgrep --smart-case"
vim.g.ack_use_cword_for_empty_search = 1

vim.g.markdown_fenced_languages = { "ts=typescript" }

-- Make sure Vim returns to the same line when you reopen a file.
vim.cmd([[
augroup line_return
  au!
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END
]])

-- Persist folds
vim.cmd([[
augroup PersistFolds
  autocmd!
  autocmd BufWinLeave,BufLeave,BufWritePost ?* nested silent! mkview!
  autocmd BufWinEnter ?* silent! loadview
augroup END
]])

-- Spelling
-- Don’t display urls as spelling errors
-- Don't count acronyms / abbreviations as spelling errors
-- (all upper-case letters, at least three characters)
-- Also will not count acronym with 's' at the end a spelling error
-- Also will not count numbers that are part of this
-- Recognizes the following as correct:
vim.opt.spelllang = { "en_gb" }
vim.cmd([[
autocmd FileType markdown,text,html setlocal spell
hi SpellBad cterm=underdotted
" hi clear SpellBad
" hi lCursor guifg=NONE guibg=Cyan
syn match AcronymNoSpell '\<\(\u\|\d\)\{3,}s\?\>' contains=@NoSpell
]])
vim.cmd("syn match UrlNoSpell 'w+://[^[:space:]]+' contains=@NoSpell")

vim.cmd([[
au TermOpen * setlocal nonumber norelativenumber

autocmd BufWritePre * :%s/\s\+$//e

" autocmd BufWritePost $MYVIMRC nested source $MYVIMRC

" filetypes
autocmd BufRead,BufNewFile tsconfig*.json set filetype=jsonc
autocmd BufRead,BufNewFile *.plist set filetype=xml

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

autocmd filetype qf wincmd J
]])

-------- SETTINGS --------

-------- UI --------
-- 24-bit colors
vim.opt.termguicolors = true
vim.opt.visualbell = true
vim.opt.cursorline = true
vim.opt.guicursor:append({ "n-v-c:blinkon0" })

-- Use default theme with overrides
-- https://github.com/neovim/neovim/blob/master/src/nvim/highlight_group.c#L144
-- https://github.com/nshern/neovim-default-colorscheme-extras?tab=readme-ov-file
-- vim.api.nvim_set_hl(0, "Function", {})
-- mute import/export, etc
vim.api.nvim_set_hl(0, "Special", { bold = true })
vim.api.nvim_set_hl(0, "PreProc", { link = "Special" })
vim.api.nvim_set_hl(0, "Cursor", { bg = "NvimLightBlue", fg = "White" })
if vim.o.background == "dark" then
  vim.api.nvim_set_hl(0, "Todo", { bg = "NvimLightYellow", fg = "NvimDarkGray1" })
  vim.api.nvim_set_hl(0, "Type", { bold = true })
else
  vim.api.nvim_set_hl(0, "Todo", { bg = "NvimLightYellow", fg = "NvimLightGray4" })
end



-- Tab symbols, etc
vim.opt.listchars = "tab:▸ ,eol:¬,extends:❯,precedes:❮,nbsp:␣"
vim.opt.fillchars = "vert:│"

-- Display only current cursorline
vim.cmd([[
  augroup CursorLine
    au!
    au VimEnter * setlocal cursorline
    au WinEnter * setlocal cursorline
    au BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
  augroup END
]])

vim.cmd("autocmd VimResized * wincmd =")

-- XXX: chars bleed into float windows
-- vim.opt.winblend = 25
-- vim.opt.pumblend = 25

vim.opt.signcolumn = "yes"

vim.opt.wildmode = "longest,list,full"
vim.opt.wildmenu = true
-------- UI --------

-------- LSP --------
local root_pattern = require("lspconfig.util").root_pattern
local null_ls = require("null-ls")


require("mason").setup()
require("mason-lspconfig").setup({
  automatic_installation = true,
})

local function map_key(mode, map, fn, desc, buffer)
  local bufopts = { noremap = true, silent = true }
  if buffer then
    bufopts.buffer = buffer
  end
  if desc then
    bufopts.desc = desc
  end
  vim.keymap.set(mode, map, fn, bufopts)
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  if root_pattern("deno.json", "deno.jsonc")(vim.fn.getcwd()) then
    null_ls.disable("prettier")
    if client.name == "ts_ls" then
      client.stop()
      return
    end
  end

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  map_key("n", "gd", vim.lsp.buf.definition, "LSP Go to definition", bufnr)
  map_key("n", "gD", vim.lsp.buf.type_definition, "LSP Go to type declaration", bufnr)
  map_key("n", "K", vim.lsp.buf.hover, "LSP Hover", bufnr)
  map_key("n", "gi", vim.lsp.buf.implementation, "LSP Implementation", bufnr)
  map_key("n", "<leader>r", vim.lsp.buf.rename, "LSP Rename", bufnr)
  map_key("n", "<leader>.", vim.lsp.buf.code_action, "LSP Code Action", bufnr)
  map_key("n", "gr", vim.lsp.buf.references, "LSP Go to references", bufnr)

  map_key("n", "ge", vim.diagnostic.open_float, "LSP Diagnostics", bufnr)
  map_key("n", "gE", vim.diagnostic.setloclist, "LSP Diagnostics quickfix", bufnr)
  map_key("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, "LSP Go to next error", bufnr)
  map_key("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, "LSP Go to prev error", bufnr)
  map_key("n", "<leader>fs", require("telescope.builtin").lsp_document_symbols, "Telescope LSP symbols ", bufnr)
  map_key(
    "n",
    "<leader>fS",
    require("telescope.builtin").lsp_workspace_symbols,
    "Telescope workspace LSP symbols",
    bufnr
  )

  -- if vim.fn.exists("&makeprg") == 1 then
  --   -- Bind <leader>m to :make<CR>
  --   vim.keymap.set("n", "<leader>m", ":make<CR>", bufopts)
  -- end

  if client.server_capabilities.documentFormattingProvider then
    map_key("n", "<leader>f", function()
      vim.lsp.buf.format({ timeout_ms = 5000 })
    end, "Format buffer", bufnr)

    if vim.bo.filetype == "typescript" or vim.bo.filetype == "javascript" or vim.bo.filetype == "lua" or vim.bo.filetype == "zig" then
      vim.api.nvim_clear_autocmds({ buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
        end,
      })
    end
  end

  if client.server_capabilities.documentRangeFormattingProvider then
    map_key("v", "<leader>f", function()
      vim.lsp.buf.format({ timeout_ms = 2000 })
    end, "Format selection", bufnr)
  end

  -- Highlight symbol on cursor hold
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- attempt to fix highlight conflicts with treesitter
  client.server_capabilities.semanticTokensProvider = nil
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lspconfig = require("lspconfig")

lspconfig.ts_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

local function deno_init_opts()
  local opts = {
    unstable = true,
    lint = true,
  }

  if vim.fn.filereadable("./import_map.json") == 1 then
    opts.importMap = "./import_map.json"
  end

  return opts
end

lspconfig.denols.setup({
  root_dir = root_pattern("deno.json", "deno.jsonc", "mod.ts", "import_map.json", "lock.json"),
  init_options = deno_init_opts(),
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
})

lspconfig.jsonls.setup({
  settings = {
    json = {
      schemas = require("schemastore").json.schemas({
        select = {
          ".eslintrc",
          "package.json",
          "tsconfig.json",
        },
      }),
      validate = { enable = true },
    },
  },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Disable autoformat from zig.vim since we're using LSP
vim.g.zig_fmt_autosave = 0
lspconfig.zls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

require("ccls").setup({ lsp = { use_defaults = true } })

lspconfig.ccls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    cache = {
      directory = "/Users/antonvasin/.ccls-cache",
    },
  },
})

lspconfig.jdtls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  -- settings = {
  --  java = {
  --    project = {
  --      sourcePaths = { "src/main/java" },
  --    },
  --  },
  -- },
})

vim.diagnostic.config({
  virtual_text = false,
  -- virtual_text = {
  --   severety = vim.diagnostic.severity.ERROR,
  --   source = "if_many",
  -- },
  float = {
    source = "if_many",
    focusable = false,
  },
  update_in_insert = true,
  severity_sort = true,
})

lspconfig.cssls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.dockerls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.lua_ls.setup({
  on_init = function(client)
    -- local path = client.workspace_folders[1].name
    --
    -- if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
    --   return
    -- end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        },
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      },
    })
  end,
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
    },
  },
})

lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.pylsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.html.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.ruff.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "javascript",
    "typescript",
    "css",
    "html",
    "bash",
    "sql",
    "vim",
    "vimdoc",
    "lua",
    "c",
    "python",
    "zig",
  },
  highlight = { enabled = true },
  auto_install = true,
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
    },
    swap = {
      enable = true,
      -- swap_next = {
      --   ["<leader>a"] = "@parameter.inner",
      -- },
      -- swap_previous = {
      --   ["<leader>A"] = "@parameter.inner",
      -- },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        --
        -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
        ["]o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
        ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
      -- Below will go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      -- Make it even more gradual by adding multiple queries and regex.
      goto_next = {
        ["]d"] = "@conditional.outer",
      },
      goto_previous = {
        ["[d"] = "@conditional.outer",
      },
    },
  },
})

require("treesitter-context").setup({
  enable = true,
  max_lines = 1,
})

require("ts_context_commentstring").setup({})
vim.g.skip_ts_context_commentstring_module = true

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier.with({
      prefer_local = "node_modules/.bin",
      filetypes = {
        "javascript",
        "typescript",
        "css",
        "scss",
        "html",
        "json",
        "yaml",
        "graphql",
      },
    }),
    null_ls.builtins.diagnostics.actionlint,
    -- null_ls.builtins.code_actions.eslint,
  },
  on_attach = on_attach,
})


-------- LSP --------

-------- KEYS --------
local bufopts = { noremap = true, silent = true }
-- Leader maps
vim.keymap.set("n", "<leader>l", ":set list!<cr> \\| :IndentLinesToggle<cr>")
vim.keymap.set("n", "<leader><space>", ":nohl<cr>")
vim.keymap.set("n", "<leader>lw", ":%s/^\\s\\+<cr>:nohl<cr>")
vim.keymap.set("n", "<leader>bl", ":g/^$/d<cr>:nohl<cr>", { desc = "Collapse all empty lines" })
vim.keymap.set("n", "<leader>ev", ":tabe $MYVIMRC<cr>:lcd %:p:h<cr>")
vim.keymap.set("n", "<leader>y", "^y$", { desc = "Yank whole text line without spaces" })
vim.keymap.set("n", "<leader>R", ":%s///<left>")
vim.keymap.set("n", "<leader>a", ":Ack!<space>")
vim.keymap.set("n", "<leader>qq", ":qa!<cr>")
vim.keymap.set("n", "<leader>w", "<C-w>")
vim.keymap.set("n", "<leader>o", ":only<cr>")
vim.keymap.set("n", "<leader>dt", 'a<C-R>=strftime("%Y-%m-%d")<CR><Esc>')
vim.keymap.set("n", "<leader>dT", 'a<C-R>=strftime("%FT%T%z")<CR><Esc>')
vim.keymap.set("n", "<leader>x", ":%!xxd<cr>")    -- file -> HEX
vim.keymap.set("n", "<leader>X", ":%!xxd -r<cr>") -- HEX -> file
vim.keymap.set("n", "<leader>W", ":noa w<cr>")
vim.keymap.set("n", "`", ":Ttoggle<cr>")
vim.keymap.set("t", "`", "<C-\\><C-n>:Ttoggle<cr>")
vim.keymap.set("n", "<leader>tc", ":Tclear<cr>")
vim.keymap.set("n", "<S-Space>", "<Space>") -- don't send escape sequence with S-Space
vim.keymap.set("n", "J", "mzJ`z", bufopts)  -- Cursor don't jump when joining lines
vim.keymap.set("n", "*", "*``", bufopts)    -- Don't jump to first highlight
vim.keymap.set("n", "Y", "y$", bufopts)     -- Yank till end of the line
vim.keymap.set("n", "s", ":w<cr>", bufopts) -- Save  with single key
vim.keymap.set("n", "<leader>cc", ":cclose<cr>")
vim.cmd("map K <Nop>")                      -- Unmap K

vim.g.neoterm_default_mod = "botright"
vim.g.neoterm_autoinsert = 1
vim.g.neoterm_size = 12
vim.g.neoterm_repl_python = "python3"

-- cabbr <expr> %% expand('%:p:h')

-- Pane movement with <C-h|j|k|l>
vim.keymap.set("n", "<C-h>", "<C-w>h", bufopts)
vim.keymap.set("n", "<C-j>", "<C-w>j", bufopts)
vim.keymap.set("n", "<C-k>", "<C-w>k", bufopts)
vim.keymap.set("n", "<C-l>", "<C-w>l", bufopts)
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", bufopts)
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", bufopts)
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", bufopts)
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", bufopts)

-- Move lines
vim.keymap.set("n", "[e", function()
  return require("moveline").move("up")
end, { expr = true })
vim.keymap.set("n", "]e", function()
  return require("moveline").move("down")
end, { expr = true })
vim.keymap.set("x", "[e", function()
  return require("moveline").move_selection("up")
end, { expr = true })
vim.keymap.set("x", "]e", function()
  return require("moveline").move_selection("down")
end, { expr = true })

-- Resize
vim.keymap.set("n", "<Right>", "<C-w>>", bufopts)
vim.keymap.set("n", "<left>", "<C-w><", bufopts)
vim.keymap.set("n", "<Up>", "<C-w>-", bufopts)
vim.keymap.set("n", "<Down>", "<C-w>+", bufopts)

-- Treat warped lines as regular lines
vim.keymap.set("n", "j", "gj", bufopts)
vim.keymap.set("n", "k", "gk", bufopts)

-- Keep search matches in the middle of the window.
vim.keymap.set("n", "n", "nzzzv", bufopts)
vim.keymap.set("n", "N", "Nzzzv", bufopts)

-- Scroll by 3 lines on <C-e|y>
-- vim.keymap.set("n", "<C-e>", "3<C-e>", bufopts)
-- vim.keymap.set("n", "<C-y>", "3<C-y>", bufopts)

-- Keep visual mode when indenting
vim.keymap.set("v", "<", "<gv", bufopts)
vim.keymap.set("v", ">", ">gv", bufopts)

-- Case-insensitive search
vim.keymap.set("n", "/", "/\\v", bufopts)
vim.keymap.set("v", "/", "/\\v", bufopts)

vim.cmd([[nnoremap ; :]]) -- Easy commands with ;
-- vim.keymap.set("n", ";", ":", bufopts) -- lua version waits for the next key to enter command mode

-- Get full folder path in command mdoe
vim.keymap.set("c", "cwd", "lcd %:p:h")
vim.keymap.set("n", "<leader>cd", ":lcd %:p:h<cr>", bufopts)

-- Undo History
vim.g.undotree_WindowLayout = 2
vim.g.undotree_SplitWidth = 34
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("n", "Q", "<Nop>")

local scratch = require("scratch")
scratch.setup()
vim.keymap.set("n", "<leader>S", scratch.open_scratch_float, bufopts)

vim.keymap.set({ "n", "v" }, "<leader>i", function()
  require("llm").invoke_llm_and_stream_into_editor({ replace = true, provider = "anthropic" })
end, { desc = "LLM Assitant OpenAI" })

-- C-d to S-Tab (inverse tab)
vim.keymap.set("i", "<S-Tab>", "<C-d>", bufopts)

--- Telescope
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", telescope.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fG", telescope.grep_string, { desc = "Telescope grep string" })
vim.keymap.set("n", "<leader>fb", telescope.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "Telescope help tags" })

vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "Telescope help tags" })

local function close_window_or_kill_buffer()
  local wins = vim.fn.winnr("$")
  local count = 0
  for i = 1, wins do
    if vim.fn.winbufnr(i) == vim.fn.bufnr("%") then
      count = count + 1
    end
  end

  -- Handle NERDTree specially
  if string.match(vim.fn.expand("%"), "NERD") then
    vim.cmd("wincmd c")
    return
  end

  if count > 1 then
    vim.cmd("wincmd c")
  else
    vim.cmd("bdelete")
  end
end

vim.keymap.set("n", "Q", close_window_or_kill_buffer, { silent = true })

-- Lazy
vim.keymap.set("n", "<leader>lu", ":Lazy update<cr>", { desc = "Update plugins" })
vim.keymap.set("n", "<leader>lc", ":Lazy clean<cr>", { desc = "Update plugins" })

-------- KEYS --------
