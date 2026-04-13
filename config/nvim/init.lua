-------- PLUGINS --------
vim.loader.enable()

-- Build hooks (must be defined before vim.pack.add)
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then return end

    if name == 'telescope-fzf-native.nvim' then
      if not ev.data.active then vim.cmd.packadd(name) end
      local paths = vim.api.nvim_get_runtime_file('Makefile', false)
      for _, p in ipairs(paths) do
        if p:find(name, 1, true) then
          vim.fn.system({ 'make', '-C', vim.fn.fnamemodify(p, ':h') })
          break
        end
      end
    end

    if name == 'LuaSnip' then
      if not ev.data.active then vim.cmd.packadd(name) end
      local paths = vim.api.nvim_get_runtime_file('Makefile', false)
      for _, p in ipairs(paths) do
        if p:find(name, 1, true) then
          vim.fn.system({ 'make', '-C', vim.fn.fnamemodify(p, ':h'), 'install_jsregexp' })
          break
        end
      end
    end

    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd(name) end
      vim.cmd('TSUpdate')
    end

    if name == 'markdown-preview.nvim' then
      if not ev.data.active then vim.cmd.packadd(name) end
      if vim.fn.executable('npx') == 1 then
        local paths = vim.api.nvim_get_runtime_file('app/package.json', false)
        for _, p in ipairs(paths) do
          if p:find(name, 1, true) then
            vim.fn.system('cd ' .. vim.fn.fnamemodify(p, ':h') .. ' && npx --yes yarn install')
            break
          end
        end
      end
    end
  end
})

vim.pack.add({
  -- Look
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/f-person/auto-dark-mode.nvim',

  -- Editing & Navigation
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/JoosepAlviste/nvim-ts-context-commentstring',
  'https://github.com/numToStr/Comment.nvim',
  'https://github.com/mbbill/undotree',
  'https://github.com/kylechui/nvim-surround',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  "https://github.com/nvimdev/indentmini.nvim",

  -- Integrations
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/mileszs/ack.vim',
  'https://github.com/tpope/vim-vinegar',
  'https://github.com/iamcco/markdown-preview.nvim',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/theHamsta/nvim-dap-virtual-text',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/akinsho/toggleterm.nvim',

  -- Syntax
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  'https://github.com/tpope/vim-jdaddy',
  'https://github.com/neoclide/jsonc.vim',
  'https://github.com/ziglang/zig.vim',
  'https://github.com/chrisgrieser/nvim-spider',
  'https://github.com/tpope/vim-sleuth',

  -- LSP
  'https://github.com/p00f/clangd_extensions.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  'https://github.com/b0o/schemastore.nvim',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-path',
  'https://github.com/saadparwaiz1/cmp_luasnip',
  'https://github.com/L3MON4D3/LuaSnip',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/hrsh7th/cmp-emoji',
  'https://github.com/onsails/lspkind.nvim',
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/nvimtools/none-ls.nvim',
  'https://github.com/ranjithshegde/ccls.nvim',
  'https://github.com/Civitasv/cmake-tools.nvim',
  'https://github.com/mfussenegger/nvim-jdtls',
})

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
vim.opt.modeline = false

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
vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo[0][0].foldmethod = 'expr'
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
vim.g.netrw_winsize = 30

-- rg
-- let g:ack_autoclose = 1
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

local function override_default_theme()
  -- Use default theme with overrides
  -- https://github.com/neovim/neovim/blob/master/src/nvim/highlight_group.c#L144
  -- https://github.com/nshern/neovim-default-colorscheme-extras?tab=readme-ov-file

  -- vim.api.nvim_set_hl(0, "Function", {})
  -- mute import/export, etc
  vim.api.nvim_set_hl(0, "Cursor", { bg = "NvimLightBlue", fg = "White" })
  -- vim.api.nvim_set_hl(0, "Special", { bold = true })
  -- vim.api.nvim_set_hl(0, "PreProc", { link = "Special" })
  if vim.o.background == "dark" then
    vim.api.nvim_set_hl(0, "Todo", { bg = "NvimLightYellow", fg = "NvimDarkGray1" })
    vim.api.nvim_set_hl(0, "Type", { bold = true })
    vim.api.nvim_set_hl(0, "IndentLine", { fg = "NvimDarkGray4" })
  else
    vim.api.nvim_set_hl(0, "Todo", { bg = "NvimLightYellow", fg = "NvimLightGray4" })
    vim.api.nvim_set_hl(0, "IndentLine", { fg = "NvimLightGray4" })
  end
end

override_default_theme()

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
-------- UI --------

-------- PLUGINS --------
require('auto-dark-mode').setup({
  set_dark_mode = function()
    vim.api.nvim_set_option_value("background", "dark", {})
    override_default_theme()
  end,
  set_light_mode = function()
    vim.api.nvim_set_option_value("background", "light", {})
    override_default_theme()
  end,
})

local cmake = require("cmake-tools")
require('lualine').setup({
  options = {
    component_separators = "",
  },
  sections = {
    lualine_c = {
      "filename",
      {
        function()
          local c_preset = cmake.get_configure_preset()
          return "CMake: [" .. (c_preset and c_preset or "X") .. "]"
        end,
        icon = "",
        cond = function()
          return cmake.is_cmake_project() and cmake.has_cmake_preset()
        end,
        on_click = function(n, mouse)
          if (n == 1) then
            if (mouse == "l") then
              vim.cmd("CMakeSelectConfigurePreset")
            end
          end
        end
      },
      {
        function()
          local type = cmake.get_build_type()
          return "CMake: [" .. (type and type or "") .. "]"
        end,
        icon = "",
        cond = function()
          return cmake.is_cmake_project() and not cmake.has_cmake_preset()
        end,
        on_click = function(n, mouse)
          if (n == 1) then
            if (mouse == "l") then
              vim.cmd("CMakeSelectBuildType")
            end
          end
        end
      },
      {
        function()
          local kit = cmake.get_kit()
          return "[" .. (kit and kit or "X") .. "]"
        end,
        icon = "",
        cond = function()
          return cmake.is_cmake_project() and not cmake.has_cmake_preset()
        end,
        on_click = function(n, mouse)
          if (n == 1) then
            if (mouse == "l") then
              vim.cmd("CMakeSelectKit")
            end
          end
        end
      },
      {
        function()
          return "Build"
        end,
        cond = cmake.is_cmake_project,
        icon = "󰣪",
        on_click = function(n, mouse)
          if (n == 1) then
            if (mouse == "l") then
              vim.cmd("CMakeBuild")
            end
          end
        end
      },
      {
        function()
          local b_preset = cmake.get_build_preset()
          return "[" .. (b_preset and b_preset or "X") .. "]"
        end,
        cond = function()
          return cmake.is_cmake_project() and cmake.has_cmake_preset()
        end,
        on_click = function(n, mouse)
          if (n == 1) then
            if (mouse == "l") then
              vim.cmd("CMakeSelectBuildPreset")
            end
          end
        end
      },
      {
        function()
          local b_target = cmake.get_build_target()
          return "[" .. (b_target and b_target or "X") .. "]"
        end,
        cond = cmake.is_cmake_project,
        on_click = function(n, mouse)
          if (n == 1) then
            if (mouse == "l") then
              vim.cmd("CMakeSelectBuildTarget")
            end
          end
        end
      },
      {
        function()
          return ""
        end,
        cond = cmake.is_cmake_project,
        on_click = function(n, mouse)
          if (n == 1) then
            if (mouse == "l") then
              vim.cmd("CMakeDebug")
            end
          end
        end
      },
      {
        function()
          return ""
        end,
        cond = cmake.is_cmake_project,
        on_click = function(n, mouse)
          if (n == 1) then
            if (mouse == "l") then
              vim.cmd("CMakeRun")
            end
          end
        end
      },
      {
        function()
          local l_target = cmake.get_launch_target()
          return "[" .. (l_target and l_target or "X") .. "]"
        end,
        cond = cmake.is_cmake_project,
        on_click = function(n, mouse)
          if (n == 1) then
            if (mouse == "l") then
              vim.cmd("CMakeSelectLaunchTarget")
            end
          end
        end
      }
    }
  }
})

require('gitsigns').setup()
require('nvim-autopairs').setup()
require('nvim-surround').setup()
require('clangd_extensions').setup()
require('nvim-dap-virtual-text').setup({ enabled = true })
require('lazydev').setup()
require("indentmini").setup({
  only_current = false,
  enabled = false,
  char = '▏',
  minlevel = 2,
  exclude = { 'markdown', 'help', 'text', 'rst' },
  exclude_nodetype = { 'string', 'comment' }
})

-- ack.vim
vim.g.ackprg = "rg --sort path --vimgrep --smart-case --no-heading"

-- markdown-preview
if vim.fn.executable('npx') then vim.g.mkdp_filetypes = { 'markdown' } end

-- nvim-spider keymaps
vim.keymap.set({ 'n', 'o', 'x' }, 'w', function() require('spider').motion('w') end)
vim.keymap.set({ 'n', 'o', 'x' }, 'e', function() require('spider').motion('e') end)
vim.keymap.set({ 'n', 'o', 'x' }, 'b', function() require('spider').motion('b') end)

local telescope = require('telescope')
local actions = require("telescope.actions")
telescope.setup({
  defaults = {
    layout_strategy = "vertical",
    layout_config = { height = 0.9, width = 0.9 },
    path_display = { shorten = 2 },
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
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")

-- toggleterm
require('toggleterm').setup({
  open_mapping = '`',
  shade_terminals = false
})

-- DAP
local dap = require("dap")
local dapui = require("dapui")
dapui.setup()

dap.set_log_level('TRACE')
vim.keymap.set('n', '<F5>', function() dap.continue() end)
vim.keymap.set('n', '<F9>', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<F10>', function() dap.step_over() end)
vim.keymap.set('n', '<F11>', function() dap.step_into() end)
vim.keymap.set('n', '<F12>', function() dap.step_out() end)
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
  -- command = "/usr/bin/lldb",
  command = "/Library/Developer/CommandLineTools/usr/bin/lldb-dap",
  name = "lldb",
}

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}

dap.configurations.c = dap.configurations.cpp

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

-- treesitter-textobjects
require('nvim-treesitter-textobjects').setup({
  select = { lookahead = true, },
  move = { set_jumps = true },
})
vim.keymap.set({ "x", "o" }, "af", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "as", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
end)

-- cmake-tools
require('cmake-tools').setup({
  cmake_runner = {
    name = 'toggleterm',
    default_opts = {
      toggleterm = {
        direction = "horizontal",
        -- close_on_exit = true,
        auto_scroll = true,
      },
    }
  }
})

local cmp = require("cmp")
local luasnip = require("luasnip")

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
    completion = cmp.config.window.bordered({}),
    documentation = cmp.config.window.bordered({}),
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      local lspkind_config = {
        mode = "symbol_text",
        maxwidth = 50,
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
-------- PLUGINS --------

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
  map_key("n", "K", function() vim.lsp.buf.hover { border = 'single', max_height = 25, max_width = 80 } end, "LSP Hover",
    bufnr)
  map_key("n", "gi", vim.lsp.buf.implementation, "LSP Implementation", bufnr)
  map_key("n", "<leader>r", vim.lsp.buf.rename, "LSP Rename", bufnr)
  map_key("n", "<leader>.", vim.lsp.buf.code_action, "LSP Code Action", bufnr)
  map_key("v", "<leader>.", vim.lsp.buf.code_action, "LSP Code Action", bufnr)
  map_key("n", "gr", vim.lsp.buf.references, "LSP Go to references", bufnr)

  map_key("n", "ge", vim.diagnostic.open_float, "LSP Diagnostics", bufnr)
  map_key("n", "gE", vim.diagnostic.setloclist, "LSP Diagnostics quickfix", bufnr)
  map_key("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, "LSP Go to next error", bufnr)
  map_key("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, "LSP Go to prev error", bufnr)

  map_key("n", "<leader>fs", function()
    require("telescope.builtin").lsp_document_symbols({ show_line = true, symbol_width = 50 })
  end, "LSP document symbols ", bufnr)
  map_key("n", "<leader>fS", function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols({ show_line = true, symbol_width = 50 })
  end, "LSP workspace symbols ", bufnr)

  map_key("n", "<leader>fS", require("telescope.builtin").lsp_workspace_symbols, "Telescope workspace LSP symbols", bufnr)

  -- if vim.fn.exists("&makeprg") == 1 then
  --   -- Bind <leader>m to :make<CR>
  --   vim.keymap.set("n", "<leader>m", ":make<CR>", bufopts)
  -- end

  if client.server_capabilities.documentFormattingProvider then
    map_key("n", "<leader>f", function()
      vim.lsp.buf.format({ timeout_ms = 5000 })
    end, "Format buffer", bufnr)

    local autoformat_langs = { "typescript", "javascript", "typescriptreact", "javascriptreact", "lua", "zig" }

    -- read languages from a list called autoformat_langs
    for _, lang in ipairs(autoformat_langs) do
      if vim.bo.filetype == lang then
        vim.api.nvim_clear_autocmds({ buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
          end,
        })
      end
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
  -- client.server_capabilities.semanticTokensProvider = false

  if client.server_capabilities.inlayHintProvider then
    map_key("n", "<leader>th", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, "[T]oggle inlay [h]ints", bufnr)
  end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local enabled_servers = {
  "ts_ls",
  "lua_ls",
  "denols",
  "jsonls",
  "zls",
  "clangd",
  "jdtls",
  "tailwindcss",
  "cssls",
  "dockerls",
  "rust_analyzer",
  "pylsp",
  "html",
  "ruff",
}

vim.lsp.enable(enabled_servers)

vim.lsp.config("*", {
  on_attach = on_attach,
  capabilities = capabilities,
})

require("lspconfig")

vim.lsp.config("denols", {
  root_dir = root_pattern("deno.json", "deno.jsonc", "mod.ts", "import_map.json", "lock.json"),
  capabilities = capabilities,
  on_attach = on_attach,
  -- filetypes = {
  --   "javascript",
  --   "javascriptreact",
  --   "javascript.jsx",
  --   "typescript",
  --   "typescriptreact",
  --   "typescript.tsx",
  -- },
})

vim.lsp.config("jsonls", {
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

vim.lsp.config("clangd", {
  cmake_build_options = { "-j12" },
  on_attach = function(client, buf)
    map_key("n", "<leader>aa", ":ClangdSwitchSourceHeader<CR>")
    map_key("n", "<leader>av", ":vsp<CR>:ClangdSwitchSourceHeader<CR>")
    map_key("n", "<leader>ax", ":sp<CR>:ClangdSwitchSourceHeader<CR>")
    map_key("n", "<leader>cr", ":CMakeRun<CR>")
    on_attach(client, buf)
  end,
  capabilities = capabilities,
  init_options = {
    fallbackFlags = { '--std=c23' },
  }
})

vim.lsp.config("lua_ls", {
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

vim.lsp.config("zls", {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    zls = {
      enable_build_on_save = true,
      semantic_tokens = "partial",
    }
  }
})

vim.lsp.config("marksman", {
  enabled = true,
  on_attach = on_attach,
  capabilities = capabilities,
})

require('nvim-treesitter').install({
  "javascript",
  "typescript",
  "tsx",
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
  "c",
  "cpp",
  "comment",
  "cmake"
})


require("treesitter-context").setup({
  enable = true,
  max_lines = 1,
})

require('ts_context_commentstring').setup {
  enable_autocmd = false,
}
require('Comment').setup {
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier.with({
      prefer_local = "node_modules/.bin",
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "css",
        "scss",
        "html",
        "json",
        "yaml",
        "graphql",
      },
    }),
    -- null_ls.builtins.diagnostics.actionlint,
    -- null_ls.builtins.diagnostics.eslint,
    -- null_ls.builtins.code_actions.eslint,
  },
  on_attach = on_attach,
})

vim.g.zig_fmt_autosave = 0

-------- LSP --------

-------- KEYS --------
local bufopts = { noremap = true, silent = true }
-- Leader maps
vim.keymap.set("n", "<leader>tl", function()
  require('indentmini').toggle()
  vim.opt.list = not vim.o.list
end, { desc = '[T]oggle hidden characters and indent [l]ines' })
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
vim.keymap.set("n", "<leader>dt", 'a<C-R>=strftime("%Y-%m-%d")<CR><Esc>') -- current datetime YYYY-MM-DD
vim.keymap.set("n", "<leader>dT", 'a<C-R>=strftime("%FT%T%z")<CR><Esc>')  -- current datetime ISO 8601
vim.keymap.set("n", "<leader>x", ":%!xxd<cr>")                            -- file -> HEX
vim.keymap.set("n", "<leader>X", ":%!xxd -r<cr>")                         -- HEX -> file
vim.keymap.set("n", "<leader>W", ":noa w<cr>")
vim.keymap.set("n", "<leader>tc", ":Tclear<cr>")
vim.keymap.set("n", "<S-Space>", "<Space>") -- don't send escape sequence with S-Space
vim.keymap.set("n", "J", "mzJ`z", bufopts)  -- Cursor don't jump when joining lines
vim.keymap.set("n", "*", "*``", bufopts)    -- Don't jump to first highlight
vim.keymap.set("n", "Y", "y$", bufopts)     -- Yank till end of the line
vim.keymap.set("n", "s", ":w<cr>", bufopts) -- Save  with single key
vim.keymap.set("n", "<leader>cc", ":cclose<cr>")
vim.cmd("map K <Nop>")                      -- Unmap K

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

local llm = require("llm")
vim.keymap.set({ "n", "v" }, "<leader>i", function()
  llm.invoke_llm_and_stream_into_editor({ replace = true, provider = "llamacpp" })
end, { desc = "LLM Completion" })

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

-- Plugins
vim.keymap.set("n", "<leader>lu", function() vim.pack.update() end, { desc = "Update plugins" })

-------- KEYS --------
