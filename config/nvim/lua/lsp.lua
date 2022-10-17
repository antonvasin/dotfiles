local lspconfig = require('lspconfig')
local util = require 'lspconfig.util'
local luasnip = require("luasnip")
local cmp = require 'cmp'
local lspkind = require('lspkind')
local null_ls = require("null-ls")

require("nvim-lsp-installer").setup {
  automatic_installation = true,
}

local opts = { noremap=true, silent=true }
vim.keymap.set('n', 'ge', vim.diagnostic.open_float, opts)
vim.keymap.set('n', 'gE', vim.diagnostic.setloclist, opts)
-- vim.keymap.set('n', 'd', vim.diagnostic.goto_prev, opts)
-- vim.keymap.set('n', 'd', vim.diagnostic.goto_next, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>.', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
end
-- nvim-cmp
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.astro.setup{}

lspconfig.tsserver.setup{
  root_dir = util.root_pattern("tsconfig.json", "package.json"),
  capabilities = capabilities,
  on_attach = on_attach,
}

local function deno_init_opts()
  opts = {
    unstable = true,
    lint = true,
  }

  if vim.fn.filereadable('./import_map.json') == 1 then
    opts.importMap = './import_map.json'
  end

  return opts
end

lspconfig.denols.setup{
  root_dir = util.root_pattern("deno.json", "mod.ts", "main.ts", "import_map.json", "lock.json");
  init_options = deno_init_opts(),
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "markdown" }
}

lspconfig.jsonls.setup{
  init_options = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    }
  },
  capabilities = capabilities,
  on_attach = on_attach,
}

local kind_icons = {
  Text = "abc",
  Method = ".()",
  Function = "ƒ",
  Constructor = "new",
  Field = ":",
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
  EnumMember = "E[]",
  Constant = "",
  Struct = "",
  Event = "Event",
  Operator = "or",
  TypeParameter = "<T>"
}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
     ['<Tab>'] = cmp.mapping(function(fallback)
       if cmp.visible() then
         cmp.select_next_item()
 --      elseif luasnip.expand_or_jumpable() then
 --        luasnip.expand_or_jump()
       else
         fallback()
       end
     end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
--       elseif luasnip.jumpable(-1) then
--         luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),

  completion = {
    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
    col_offset = -2,
    side_padding = 0,
  },

  window = {
    completion = {
      border = 'rounded',
    },
  },

  sources = {
    { name = 'nvim_lsp' },
--    { name = 'luasnip' },
  },

  formatting = {
    fields = { "kind", "abbr" },
    format = function(entry, vim_item)
      -- local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)

      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      local strings = vim.split(vim_item.kind, "%s", { trimempty = true })
      vim_item.kind = "" .. strings[1] .. " "
      vim_item.menu = "    (" .. strings[2] .. ")"
      return vim_item
    end,
  },

  experimental = {
    ghost_text = true,
  }
}

vim.diagnostic.config({
  float = {
    source = 'always',
    focusable = false,
  },
  update_in_insert = false, -- default to false
  severity_sort = true, -- default to false
})

null_ls.setup({
  sources = {
      null_ls.builtins.formatting.stylua,
      -- null_ls.builtins.formatting.prettier,
      null_ls.builtins.completion.spell
  },
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.cmd("nnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.format()<CR>")

      -- format on save
      vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.format()")
    end

    if client.server_capabilities.documentRangeFormattingProvider then
      vim.cmd("xnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.range_format({})<CR>")
    end
  end,
})

lspconfig.dockerls.setup {}
