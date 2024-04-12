# spank.nvim
A small neovim plugin to spawn and manage a swank server

This is meant to be used along with a plugin like [Conjure](https://github.com/Olical/conjure). It will start a Swank server inside of a nvim terminal emulator.

## Requirements
- a Common Lisp implementation ([sbcl](http://sbcl.org) is the default)
- [ASDF](http://asdf.common-lisp.dev/asdf.html) (this should be included in your Common Lisp implementation)
- [Swank](http://slime.common-lisp.dev/) ([quicklisp](http://www.quicklisp.org/beta/) is probably the easiest way to get this. Once quicklisp is installed run `(ql:quickload "swank")` in your CL repl)

## Installation
[lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
    return { 'spaghettijeff/spank.nvim' }
```

## Configuration
This plugin provides 3 functions `spawn()`, `show()`, and `quit()` to be bound.

You probably want to put the configuration into `ftplugin/lisp.lua` so that it only runs when a .lisp file is open.
### Keybinds
Example:
```lua
-- ~/.config/nvim/ftplugin/lisp.lua
local spank = require 'spank'

vim.keymap.set("n", "<leader>ss", spank.spawn)
vim.keymap.set("n", "<leader>sS", spank.show)
vim.keymap.set("n", "<leader>sq", spank.quit)
```

### Settings
The default command to launch the swank server is 
```lua
{ 
    'sbcl',
    '--eval', '(require "ASDF")',
    '--eval', '(asdf:load-system \'swank)',
    '--eval', '(swank:create-server :dont-close t)' 
}
```
This can be changed by setting `vim.g.spank_settings.swank_cmd`. For example:
```lua
-- ~/.config/nvim/ftplugin/lisp.lua
require 'spank'
-- settings ...

vim.g.spank_settings.swank_cmd = { 
    'sbcl',
    '--eval', '(ql:quickload "swank")',
    '--eval', '(swank:create-server :dont-close t)' 
}
```
