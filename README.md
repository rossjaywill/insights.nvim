# insights.nvim

Neovim integration of cppinsights.

![Preview](https://i.imgur.com/x0TVpYj.gif)

## Dependencies

- **Neovim**: Requires neovim verions > 0.7
- **cppinsights**: Requires the `cppinsights` binary available on your `$PATH`. More information on how to install and set it up can be found [here](https://cppinsights.io/).
- **plenary.nvim**: Enables asynchronous calls to insights, highly recommended to improve user experience.
- **telescope.nvim**: Enables interactive selection of files to show insights.

## Configuration

Default configuration items:
```lua
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
