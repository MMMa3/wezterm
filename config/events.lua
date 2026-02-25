local wezterm = require("wezterm")
local utils = require("config.utils")
local tab_bar = require("config.tab_bar")

local M = {}

-- 右侧状态栏配置
local status_colors = {
    date_fg = "#3E7FB5",
    date_bg = "#0F2536",
    battery_fg = "#B52F90",
    battery_bg = "#0F2536",
    separator_fg = "#786D22",
    separator_bg = "#0F2536",
}

local separator_char = " ~ "

-- 添加状态栏单元格
local function push_status(cells, text, icon, fg, bg, separate)
    table.insert(cells, { Foreground = { Color = fg } })
    table.insert(cells, { Background = { Color = bg } })
    table.insert(cells, { Attribute = { Intensity = "Bold" } })
    table.insert(cells, { Text = icon .. " " .. text .. " " })

    if separate then
        table.insert(cells, { Foreground = { Color = status_colors.separator_fg } })
        table.insert(cells, { Background = { Color = status_colors.separator_bg } })
        table.insert(cells, { Text = separator_char })
    end

    table.insert(cells, "ResetAttributes")
end

-- 设置日期时间
local function set_date(cells)
    local date = wezterm.strftime(" %a %H:%M")
    push_status(cells, date, "", status_colors.date_fg, status_colors.date_bg, true)
end

-- 设置电池状态
local function set_battery(cells)
    local discharging_icons = { "󰂃", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹" }
    local charging_icons = { "󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅" }

    local charge = ""
    local icon = ""

    for _, b in ipairs(wezterm.battery_info()) do
        local idx = utils.clamp(utils.round(b.state_of_charge * 10), 1, 10)
        charge = string.format("%.0f%%", b.state_of_charge * 100)

        if b.state == "Charging" then
            icon = charging_icons[idx]
        else
            icon = discharging_icons[idx]
        end
    end

    push_status(cells, charge, icon, status_colors.battery_fg, status_colors.battery_bg, false)
end

function M.apply(_config)
    -- 格式化Tab标题（圆角样式）
    wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
        return tab_bar.format_tab_title(tab, tabs, panes, cfg, hover, max_width)
    end)

    -- 切换标签栏显示状态
    wezterm.on("toggle-tab-bar", function(window, _pane)
        local overrides = window:get_config_overrides() or {}
        overrides.enable_tab_bar = not (overrides.enable_tab_bar == nil and true or overrides.enable_tab_bar)
        window:set_config_overrides(overrides)
    end)

    -- 打开 URI 链接
    wezterm.on("open-uri", function(_window, _pane, uri)
        if uri:lower():match("^file://") then
            local normalized = uri
            if normalized:match("^file://[A-Za-z]:") then
                normalized = normalized:gsub("^file://", "file:///")
            end
            normalized = normalized:gsub("\\\\", "/")

            wezterm.open_with(normalized)
            return true
        end

        wezterm.open_with(uri)
        return true
    end)

    -- 更新右侧状态栏
    wezterm.on("update-right-status", function(window, _pane)
        local cells = {}
        set_date(cells)
        set_battery(cells)
        window:set_right_status(wezterm.format(cells))
    end)

    -- 新标签按钮点击事件
    wezterm.on("new-tab-button-click", function(window, pane, button, default_action)
        wezterm.log_info("new-tab", window, pane, button, default_action)
        if default_action and button == "Left" then
            window:perform_action(default_action, pane)
        end

        if default_action and button == "Right" then
            window:perform_action(
                wezterm.action.ShowLauncherArgs({
                    title = "󰈲 Select/Search:",
                    flags = "FUZZY|LAUNCH_MENU_ITEMS|DOMAINS",
                }),
                pane
            )
        end
        return false
    end)
end

return M
