# Kalisi Modern - Zero-Configuration Neovim Theme

A modern rewrite of the Kalisi color scheme with automatic dark mode switching and lazy-loaded plugin support.

## Features

- 🎨 **Zero Configuration** - Just works, no setup required
- 🌓 **Automatic Dark Mode** - Switches based on `vim.o.background`
- ⚡ **Lazy Loading** - Plugin integrations load only when needed
- 📦 **Modular Architecture** - Clean separation of concerns
- 💎 **Jewel-Tone Palette** - High contrast clarity with sophisticated colors

## Installation

### Using lazy.nvim
```lua
{
  "kalisi-modern",
  dir = "~/.config/nvim/lua/kalisi-modern",
  lazy = false,
  priority = 1000,
  config = function()
    require("kalisi-modern").setup()
  end
}
```

### Manual Installation
```lua
-- In your init.lua
require("kalisi-modern").setup()
```

## Usage

```lua
-- That's it! No configuration needed
require("kalisi-modern").setup()

-- Theme automatically switches when you change background
vim.o.background = "dark"  -- Switches to dark theme
vim.o.background = "light" -- Switches to light theme
```

## Architecture

```
kalisi-modern/
├── init.lua                # Main entry with auto-detection
├── palettes/
│   ├── light.lua          # Light color palette
│   └── dark.lua           # Dark color palette
├── core/
│   ├── editor.lua         # UI elements
│   └── syntax.lua         # Syntax highlighting
└── integrations/          # Auto-detected plugins
    ├── gitsigns.lua       # Git integration
    ├── telescope.lua      # Fuzzy finder
    ├── cmp.lua           # Completion
    ├── nvimtree.lua      # File explorer
    ├── treesitter.lua    # Enhanced syntax
    ├── snacks.lua        # Snacks.nvim
    └── misc.lua          # Various plugins
```

## Supported Plugins

Automatically detected and themed:

- **Git**: GitSigns
- **Fuzzy Finding**: Telescope
- **Completion**: nvim-cmp
- **File Explorer**: NvimTree, NeoTree, NERDTree
- **Syntax**: Treesitter, Rainbow Delimiters
- **UI**: WhichKey, Noice, Notify, Snacks.nvim
- **Motion**: Leap, Flash
- **Debug**: DAP
- **Mini.nvim**: Full suite support
- **And more**: CtrlP, Startify, Tagbar, etc.

## Philosophy

Kalisi Modern follows these principles:

1. **No Configuration Required** - Works perfectly out of the box
2. **Automatic Everything** - Detects plugins and background automatically
3. **Performance First** - Lazy loads only what's needed
4. **Clean Architecture** - Modular, maintainable, extensible
5. **Visual Excellence** - High contrast jewel tones for clarity

## Differences from Original Kalisi

- **Modular architecture** instead of monolithic files
- **Automatic plugin detection** with lazy loading
- **Comprehensive Treesitter support** with 100+ groups
- **Modern plugin integrations** for contemporary Neovim
- **Automatic dark mode switching** based on background
- **Zero configuration** - no setup options needed

## Color Philosophy

- **Light Theme**: Pure black on white with jewel-tone accents
- **Dark Theme**: Inverted with adjusted brightness for dark backgrounds
- **Consistent semantics** across both themes
- **Gallery-worthy aesthetics** with sophisticated color choices

## License

Same as original Kalisi theme

## Credits

- Original Kalisi theme for the color philosophy
- Catppuccin for architectural inspiration
- The Neovim community for plugin ecosystem