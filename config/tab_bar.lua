local wezterm = require("wezterm")

local M = {}

-- 半圆形字符用于创建圆角效果
local GLYPH_SEMI_CIRCLE_LEFT = "\u{E0B6}"
local GLYPH_SEMI_CIRCLE_RIGHT = "\u{E0B4}"
local GLYPH_CIRCLE = "\u{25CF}"

-- Tab 颜色配置
local tab_colors = {
    default = {
        bg = "#8C246F",
        fg = "#0F2536",
    },
    is_active = {
        bg = "#5f89b3",
        fg = "#0F2536",
    },
    hover = {
        bg = "#9C347F",
        fg = "#0F2536",
    },
}

M.cells = {}

-- 提取进程名称
local function set_process_name(s)
    local a = string.gsub(s, "(.*[/\\])(.*)", "%2")
    return a:gsub("%.exe$", "")
end

-- 设置标题：只显示进程名，如果有冒号则取冒号后的部分
local function set_title(process_name, active_title, max_width)
    local title

    -- 如果 active_title 包含冒号，取冒号后的部分
    if active_title and active_title:match(":") then
        local after_colon = active_title:match(":(.+)")
        if after_colon then
            title = after_colon
        else
            title = process_name
        end
    else
        -- 否则显示完整的进程名
        title = process_name
    end

    -- 截断过长的标题（健壮处理 max_width，避免向 truncate_right 传入负数或 nil）
    local mw = tonumber(max_width) or 0
    if mw > 8 then
        local target = mw - 8
        if target < 1 then
            target = 1
        end
        if title:len() > target then
            title = wezterm.truncate_right(title, target)
        end
    end

    return title
end

-- 添加格式化元素到cells
local function push(bg, fg, attribute, text)
    table.insert(M.cells, { Background = { Color = bg } })
    table.insert(M.cells, { Foreground = { Color = fg } })
    table.insert(M.cells, { Attribute = attribute })
    table.insert(M.cells, { Text = text })
end

-- 格式化Tab标题的函数
function M.format_tab_title(tab, tabs, panes, cfg, hover, max_width)
    M.cells = {}

    local bg
    local fg
    local process_name = set_process_name(tab.active_pane.foreground_process_name)
    local title = set_title(process_name, tab.active_pane.title, max_width)

    if tab.is_active then
        bg = tab_colors.is_active.bg
        fg = tab_colors.is_active.fg
    elseif hover then
        bg = tab_colors.hover.bg
        fg = tab_colors.hover.fg
    else
        bg = tab_colors.default.bg
        fg = tab_colors.default.fg
    end

    local has_unseen_output = false
    for _, pane in ipairs(tab.panes) do
        if pane.has_unseen_output then
            has_unseen_output = true
            break
        end
    end

    -- (debug logging removed)

    -- 尝试从传入的 config 中推断标签栏背景色，用于绘制半圆的背景
    local tab_bar_bg = (cfg and cfg.window_frame and (cfg.window_frame.active_titlebar_bg or cfg.window_frame.inactive_titlebar_bg))
        or (cfg and cfg.colors and (cfg.colors.background or cfg.colors.window_background))
        or "#0F2536"

    -- 左半圆（圆角开始）
    push(tab_bar_bg, bg, { Intensity = "Bold" }, GLYPH_SEMI_CIRCLE_LEFT)

    -- 标题内容
    push(bg, fg, { Intensity = "Bold" }, "  " .. title)

    -- 未查看输出警报
    if has_unseen_output then
        push(bg, "#FF3B8B", { Intensity = "Bold" }, " " .. GLYPH_CIRCLE)
    end

    -- 右边距
    push(bg, fg, { Intensity = "Bold" }, " ")

    -- 右半圆（圆角结束）
    push(tab_bar_bg, bg, { Intensity = "Bold" }, GLYPH_SEMI_CIRCLE_RIGHT)

    return M.cells
end

function M.apply(config)
    config.enable_tab_bar = true
    config.tab_bar_at_bottom = false
    config.show_new_tab_button_in_tab_bar = true
    config.show_tab_index_in_tab_bar = true
    config.show_tabs_in_tab_bar = true
    config.switch_to_last_active_tab_when_closing_tab = true
    -- 增大单个标签的最大宽度（你平时不常开很多 tab，可适当增大）
    config.tab_max_width = 80
    -- 使用 fancy tab bar 以获得圆角效果
    config.use_fancy_tab_bar = true
end

return M
