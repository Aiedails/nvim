require("dap-python").setup()
require("dap-python").resolve_python = function ()
  return '/usr/bin/python'
end
table.insert(require('dap').configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'python',
  program = '${file}',
  cwd = "${workspaceFolder}",
  -- ... more options, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
})

require("dapui").setup()
