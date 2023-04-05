local root_pattern = require("lspconfig.util").root_pattern
local luasnip = require("luasnip")
local cmp = require("cmp")
local null_ls = require("null-ls")

require("nvim-lsp-installer").setup({
  automatic_installation = true,
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  if client.name == "denols" then
    null_ls.disable("prettier")
  end

  if root_pattern("deno.json", "deno.jsonc")(vim.fn.getcwd()) then
    if client.name == "tsserver" then
      client.stop()
      return
    end
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  -- vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)

  vim.keymap.set("n", "ge", vim.diagnostic.open_float, bufopts)
  vim.keymap.set("n", "gE", vim.diagnostic.setloclist, bufopts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, bufopts)

  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ timeout_ms = 5000 })
    end, bufopts)

    vim.api.nvim_clear_autocmds({ buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
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

  -- Highlight symbol on cursor hold
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", {
      clear = false,
    })
    vim.api.nvim_clear_autocmds({
      buffer = bufnr,
      group = "lsp_document_highlight",
    })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- Show diagnostics on cursor hold
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always",
        prefix = " ",
        scope = "cursor",
      }
      vim.diagnostic.open_float(nil, opts)
    end,
  })
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Call before lspconfig
require("neodev").setup({})

local lspconfig = require("lspconfig")

lspconfig.astro.setup({})

lspconfig.tsserver.setup({
  root_dir = root_pattern("tsconfig.json", "package.json"),
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
  root_dir = root_pattern("deno.json", "deno.jsonc", "mod.ts", "main.ts", "import_map.json", "lock.json"),
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

lspconfig.astro.setup({
  root_dir = root_pattern("astro.config.mjs"),
  capabilities = capabilities,
  on_attach = on_attach,
})

lspconfig.eslint.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
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
    { name = "luasnip" },
    { name = "emoji" },
    { name = "buffer " },
  },
  completion = {
    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
    col_offset = -3,
    side_padding = 0,
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

vim.diagnostic.config({
  virtual_text = {
    severety = vim.diagnostic.severity.ERROR,
    source = "if_many",
  },
  float = {
    source = "always",
    focusable = false,
  },
  update_in_insert = true,
  severity_sort = true,
})

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettier.with({
      prefer_local = "node_modules/.bin",
    }),
    null_ls.builtins.diagnostics.actionlint,
    null_ls.builtins.code_actions.eslint,
  },
  on_attach = on_attach,
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

require("nvim-treesitter.configs").setup({
  ensure_installed = { "javascript", "typescript", "css", "html", "go", "clojure", "bash", "sql", "vim", "lua" },
  highlight = { enabled = true },
  auto_install = true,
})

-- TODO https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
