# AI-Slopped with Claude!

https://claude.ai/chat/fa228520-98b9-4103-84fa-e31fcbacb511

# Format Inline JSON

A simple Neovim plugin that formats JSON objects found within the current line.

## Features

- Detects JSON within curly braces `{...}` in the current line
- Formats the JSON with proper indentation and line breaks
- Preserves text before and after the JSON object
- Works with nested JSON objects

## Usage

### Commands

`:FormatInlineJSON` - Format JSON in the current line

### Keybindings

`<C-j>` - Format JSON in the current line (normal mode)

## Requirements

This plugin requires:

- Neovim 0.8.0 or later
- `jq` command-line tool for JSON formatting

## Installation with LazyVim

This plugin is designed to work with LazyVim and the Lazy package manager. The plugin is set up in development mode.

### Directory Structure

```
~/.config/nvim/
  └── lua/
      ├── plugins/
      │   └── format-inline-json.lua
      └── custom/
          └── format-inline-json/
              └── lua/
                  └── format-inline-json.lua
```

## Examples

Before:
```
2025-04-23T00:04:22+02:00 DEBUG controller/moebiusgpunode_controller.go:166 Reconcile! {"controller": "moebiusgpunode", "controllerGroup": "moebiusnodes.newcube.com", "MoebiusGpuNode": {"name":"test-resource","namespace":"default"}}
```

After:
```
2025-04-23T00:04:22+02:00 DEBUG controller/moebiusgpunode_controller.go:166 Reconcile! 
{
  "controller": "moebiusgpunode",
  "controllerGroup": "moebiusnodes.newcube.com",
  "MoebiusGpuNode": {
    "name": "test-resource",
    "namespace": "default"
  }
}
```
