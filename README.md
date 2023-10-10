# insights.nvim

Neovim integration of cppinsights.

This plugin allows for invoking and viewing the output of a local cppinsights instance directly from neovim, if it installed on your system.

If cppinsights is not installed on your system, you can use this plugin to make requests to cppinsights.io directly from within neovim too.

![Preview](https://i.imgur.com/nJRCS01.gif)

## Dependencies

- **Neovim**: Requires neovim verions > 0.7
- **plenary.nvim**: Enables asynchronous calls to insights, not required but is highly recommended to improve user experience.
- **telescope.nvim**: Enables interactive selection of files to show insights, not required but again is highly recommended for user experience.

Optional:
- **cppinsights**: If the `insights` binary is available on your `$PATH` by default it will be used in preference of the web interface at cppinsights.io.
  - If not installed on your system, the plugin will fallback to using HTTP by default. Please see the Configuration section below for more info.
  - More information on how to install and set it up can be found [here](https://cppinsights.io/).

## Configuration

Default configuration items:
```lua
local_only = false, -- only allow insights.nvim to invoke a local cppinsights binary
http_only = false,  -- only allow insights.nvim to make HTTP requests to cppinsights.io
                    -- If both of these are not set (i.e. the default), then insights.nvim
                    -- will use a local binary, if available, otherwise it will fallback to HTTP
                    -- WARNING: You should think carefully about sending source code over HTTP -
                    -- especially if you are working on a proprietary system.
async = true,
insights_bin = 'insights',
use_default_keymaps = true,
use_libc = true,
use_vsplit = true,
```

Plugin can be initialised with defaults as:
```lua
require('insights').setup()
```

Configuration can be overriden with:
```lua
require('insights').setup {
  async = false,  -- do not use plenary
  use_default_keymaps = false, -- disable default keymaps, to be user defined
  use_libc = false, -- do not use libc++ headers
}
```
etc

## Setup

Enable plugin using your preference of plugin manager, or add to nvim run-time path.

Using lazy.nvim:
```lua
require('lazy').setup({
  {
    'rossjaywill/insights.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
      'nvim-telescope/telescope.nvim',
    },
  },
})
```

## Usage

With the default keybinds, cppinsights can be run against the current buffer with:
```vim
<leader>ci
```

To open a telescope window to select a file to run insights against:
```vim
<leader>ct
```

## Contributions

All contributions and issues welcome, feel free to open a PR or raise issues :)
