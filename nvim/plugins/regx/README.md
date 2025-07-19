# `regx`

Micro plugin that allows you to define custom match patterns to be considered URLs.

```lua
local regx = require("regx")

regx:add({ name = "JIRA", match = "%d%d%d%d", url = "https://jira.com/browse/" })
```

...and open with `gx` in normal mode!
