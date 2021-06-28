local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function switch_source_header()
  local params = { uri = vim.uri_from_bufnr(0) }

  vim.lsp.buf_request(bufnr, 'textDocument/switchSourceHeader', params, function(err, _, result)
    if err then error(tostring(err)) end
    if not result then print ("Corresponding file can’t be determined") return end

    vim.api.nvim_command('edit '..vim.uri_to_fname(result))
  end)
end

local root_pattern = util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")

local default_capabilities = vim.tbl_deep_extend(
  'force',
  util.default_config.capabilities or vim.lsp.protocol.make_client_capabilities(),
  {
    textDocument = {
      completion = {
        editsNearCursor = true
      }
    },
    offsetEncoding = {"utf-8", "utf-16"}
  });

configs.clangd = {
  default_config = {
    cmd = {"clangd", "--background-index"};
    filetypes = {"c", "cpp", "objc", "objcpp"};

    root_dir = function(fname)
      return root_pattern(fname) or util.path.dirname(fname)
    end;

    on_init = function(client, result)
      if result.offsetEncoding then
        client.offset_encoding = result.offsetEncoding
      end
    end;

    capabilities = default_capabilities;
  };

  commands = {
    ClangdSwitchSourceHeader = {
      switch_source_header;
      description = "Switch between source/header";
    };
  };
}
