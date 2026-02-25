local wezterm = require("wezterm")

local M = {}

--- 检查 Windows 下命令是否存在
---@param cmd string 命令名称
---@return boolean
function M.windows_command_exists(cmd)
    local success, stdout = wezterm.run_child_process({ "where", cmd })
    return success and stdout and stdout ~= ""
end

--- 检查 Unix 下命令是否存在
---@param cmd string 命令名称
---@return boolean
function M.unix_command_exists(cmd)
    local success, stdout = wezterm.run_child_process({ "sh", "-c", "command -v " .. cmd })
    return success and stdout and stdout ~= ""
end

--- 判断当前是否为 Windows 系统
---@return boolean
function M.is_windows()
    return wezterm.target_triple:find("windows") ~= nil
end

--- 限制数值在指定范围内
---@param x number 要限制的数值
---@param min number 最小值
---@param max number 最大值
---@return number
function M.clamp(x, min, max)
    return x < min and min or (x > max and max or x)
end

--- 四舍五入
---@param x number 要四舍五入的数值
---@param increment number|nil 可选的增量
---@return number
function M.round(x, increment)
    if increment then
        return M.round(x / increment) * increment
    end
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

return M
