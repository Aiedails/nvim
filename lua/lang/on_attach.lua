local utils = {}

utils.setup_keymaps = function(_, bufnr)
  local bnmap = function(mappings)
    require("libs.keymap").buf_map(bufnr, "n", mappings)
  end

  local telescope = function(action, args)
    return function()
      local theme = require("telescope.themes").get_dropdown(args or {})
      local builtins = require("telescope.builtin")
      builtins[action](theme)
    end
  end

  vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

  bnmap({
    { "K", vim.lsp.buf.hover, desc = "[LSP] Open document" },
    { "R", vim.lsp.buf.rename, desc = "[LSP] Rename symbol" },

    { "gD", telescope("lsp_definitions"), desc = "[LSP] Search and goto `definitions`" },
    { "gR", telescope("lsp_references"), desc = "[LSP] Search and goto `references`" },
    { "gI", telescope("lsp_implementations"), desc = "[LSP] Search and goto `implementations`" },
    { "gT", telescope("lsp_type_definitions"), desc = "[LSP] Search and goto `type definition`" },

    -- <leader>cf: code format, define in conform.nvim module at lang/init.lua
    { "<leader>ca", vim.lsp.buf.code_action, desc = "[LSP] Open code actions" },
    { "<leader>cr", vim.lsp.codelens.run, desc = "[LSP] Run codelens at current line" },
    { "<leader>do", vim.diagnostic.open_float, desc = "[LSP] Open floating list" },
    { "<leader>dq", vim.diagnostic.setqflist, desc = "[LSP] Open quickfix list" },

    { "[[", vim.diagnostic.goto_prev, desc = "[LSP] Jump to previous error" },
    { "]]", vim.diagnostic.goto_next, desc = "[LSP] Jump to next error" },
  })
end

utils.setup_icons = function()
  local icons = {
    "",
    "",
    "",
    "",
  }

  -- Setup diagnostic icons and signs
  vim.diagnostic.config({
    virtual_text = {
      prefix = function(diag)
        return icons[diag.severity]
      end,
      spacing = 4,
    },
    float = {
      prefix = function(diag)
        return icons[diag.severity] .. " "
      end,
      border = "rounded",
    },
    signs = false,
    underline = true,
    -- update diagnostic in insert mode will be annoying when the output is too verbose
    update_in_insert = false,
  })
end

-- LSP's on_attach interface accept two arguments client and bufnr. But we don't use client for now, so it is okay to pass nil here.
utils.setup_all = function(client, bufnr)
  utils.setup_icons()
  utils.setup_keymaps(client, bufnr)

  if client.server_capabilities.inlayHintProvider then
    -- Display after attached
    vim.defer_fn(function()
      vim.lsp.inlay_hint.enable(true, { buffer = bufnr })
    end, 1000)
  end

  local gid = vim.api.nvim_create_augroup("MyLspAutocmdsSetup" .. bufnr, { clear = true })

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
      group = gid,
      buffer = bufnr,
      desc = "Document Highlight",
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = function()
        vim.lsp.buf.clear_references()
      end,
      group = gid,
      buffer = bufnr,
      desc = "Clear All the References",
    })
  end

  if client and client.server_capabilities and client.server_capabilities.codeLensProvider then
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      group = gid,
      buffer = bufnr,
      callback = function()
        vim.lsp.codelens.refresh({ bufnr = bufnr })
      end,
    })
  end

  -- Clean buffer from client when buffer is deleted
  vim.api.nvim_create_autocmd("BufDelete", {
    buffer = bufnr,
    group = gid,
    callback = function()
      vim.lsp.inlay_hint.enable(false, { buffer = bufnr })
      vim.lsp.buf_detach_client(bufnr, client.id)
      vim.api.nvim_clear_autocmds({ group = gid })
    end,
  })
end

return utils
