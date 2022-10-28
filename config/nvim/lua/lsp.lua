local util = require("lspconfig.util")
local luasnip = require("luasnip")
local cmp = require("cmp")
local null_ls = require("null-ls")

require("nvim-lsp-installer").setup({
  automatic_installation = true,
})

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "ge", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "gE", vim.diagnostic.setloclist, opts)
-- vim.keymap.set('n', 'd', vim.diagnostic.goto_prev, opts)
-- vim.keymap.set('n', 'd', vim.diagnostic.goto_next, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<space>f", vim.lsp.buf.format, bufopts)

  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ timeout_ms = 2000 })
    end, bufopts)

    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
      end,
    })
  end

  if client.server_capabilities.documentRangeFormattingProvider then
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ timeout_ms = 2000 })
    end, bufopts)
  end
end

-- nvim-cmp
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities()

require("neodev").setup({})

local lspconfig = require("lspconfig")

lspconfig.astro.setup({})

lspconfig.tsserver.setup({
  root_dir = util.root_pattern("tsconfig.json", "package.json"),
  capabilities = capabilities,
  on_attach = on_attach,
})

local function deno_init_opts()
  opts = {
    unstable = true,
    lint = true,
  }

  if vim.fn.filereadable("./import_map.json") == 1 then
    opts.importMap = "./import_map.json"
  end

  return opts
end

lspconfig.denols.setup({
  root_dir = util.root_pattern("deno.json", "mod.ts", "main.ts", "import_map.json", "lock.json"),
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
    "markdown",
  },
})

lspconfig.jsonls.setup({
  init_options = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
  capabilities = capabilities,
  on_attach = on_attach,
})

local kind_icons = {
  Text = "Ｔ",
  Method = "()",
  Function = "ƒ",
  Constructor = "new",
  Field = ".",
  Variable = "var",
  Class = "C",
  Interface = "I",
  Module = "M",
  Property = ".",
  Unit = "U",
  Value = "V",
  Enum = "",
  Keyword = "",
  Snippet = "Snip",
  Color = "",
  File = "📄",
  Reference = "Ref",
  Folder = "📂",
  EnumMember = "[]",
  Constant = "const",
  Struct = "Struct",
  Event = "Event",
  Operator = "op",
  TypeParameter = "<T>",
}

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
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
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
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

  completion = {
    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
    col_offset = -2,
    side_padding = 0,
  },

  window = {
    completion = {
      border = "rounded",
    },
  },

  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "emoji" },
  },

  formatting = {
    fields = { "kind", "abbr" },
    format = function(entry, vim_item)
      -- This concatonates the icons with the name of the item kind
      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
      local strings = vim.split(vim_item.kind, "%s", { trimempty = true })
      vim_item.kind = "" .. strings[1] .. " "
      vim_item.menu = "    (" .. strings[2] .. ")"
      return vim_item
    end,
  },

  experimental = {
    ghost_text = true,
  },
})

vim.diagnostic.config({
  float = {
    source = "always",
    focusable = false,
  },
  update_in_insert = false, -- default to false
  severity_sort = true, -- default to false
})

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.formatting.prettier,
    -- null_ls.builtins.completion.spell,
    -- null_ls.builtins.diagnostics.luacheck,
    null_ls.builtins.diagnostics.actionlint,
  },
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_clear_autocmds({ buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
        end,
      })
    end
  end,
})

lspconfig.dockerls.setup({
  on_attach = on_attach,
})

-- lspconfig.sumneko_lua.setup({
--   on_attach = on_attach,
--   runtime = {
--     -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--     version = "LuaJIT",
--   },
--   diagnostics = {
--     -- Get the language server to recognize the `vim` global
--     globals = { "vim" },
--   },
--   workspace = {
--     -- Make the server aware of Neovim runtime files
--     library = vim.api.nvim_get_runtime_file("", true),
--   },
-- })

-- example to setup sumneko and enable call snippets
lspconfig.sumneko_lua.setup({
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
    },
  },
})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "javascript", "typescript", "css", "html", "go", "clojure", "bash", "sql", "vim", "lua" },
  highlight = { enabled = true },
  auto_install = true,
})
