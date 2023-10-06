# insights.nvim

## Introduction

Neovim integration of cppinsights.

## Dependencies

- **Neovim**: Requires neovim verions > 0.7
- **cppinsights**: Requires the `cppinsights` binary available in your `$PATH`. More information on how to install and set it up can be found [here](https://cppinsights.io/).
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

Configuration can be overriden with:
```lua
require('insights.nvim').setup {
  async = false,
  use_default_keymaps = false,
  use_libc = false,
}
```
etc

## Setup

Enable plugin using your preference of window manager, or add to run-time path.

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

With the default keybinds, cppinsights can be run against the cuffer buffer with:
```vim
<leader>ci
```

To open a telescope window to select a file to run insights against:
```vim
<leader>ct
```

## Contributions

All contributions and issues are welcome, feel free to open a PR or raise issues :)