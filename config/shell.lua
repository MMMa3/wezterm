local utils = require("config.utils")

local M = {}

function M.apply(config)
    if utils.is_windows() then
        config.default_prog = { "pwsh", "--NoLogo" }
    else
        -- Unix 系统：zsh
        config.default_prog = { "zsh", "-i" }
    end
end

return M
