local wezterm = require("wezterm")
local constants = require("config.constants")

local M = {}

function M.apply(config)
    -- 配色方案（默认）
    config.color_scheme = 'Tokyo Night'

    -- 渲染设置
    config.animation_fps = 120
    config.max_fps = 120
    config.front_end = "WebGpu"
    config.webgpu_power_preference = "HighPerformance"

    -- 窗口透明度
    config.window_background_opacity = 1.00

    -- 背景图片和渐变效果
    local image_num = math.random(1, 9) -- 可以根据需要修改背景图片序号
    config.window_background_image = constants.CONFIG_DIR .. "/images/0" .. image_num .. ".jpg"

    -- 背景渐变叠加
    config.window_background_gradient = {
        colors = { "#1D261B", "#261A25" },
        orientation = { Linear = { angle = -45.0 } },
    }

    -- 背景叠加层（增强视觉效果）
    config.background = {
        {
            source = { File = constants.CONFIG_DIR .. "/images/0" .. image_num .. ".jpg" },
        },
        {
            source = { Color = "#151414" },
            height = "100%",
            width = "100%",
            opacity = 0.95,
        },
    }

    -- 窗口边距
    config.window_padding = {
        left = 5,
        right = 10,
        top = 12,
        bottom = 7,
    }

    -- 滚动条设置
    config.enable_scroll_bar = true
    config.min_scroll_bar_height = "3cell"
    config.colors = config.colors or {}
    config.colors.scrollbar_thumb = "#34354D"

    -- 命令面板样式（磨砂深色）
    config.command_palette_bg_color = "rgba(12, 14, 20, 0.92)"
    config.command_palette_fg_color = "#e6e9ef"

    -- 窗口边框样式
    config.window_frame = {
        active_titlebar_bg = "#0F2536",
        inactive_titlebar_bg = "#0F2536",
    }

    -- 非活动窗格样式
    config.inactive_pane_hsb = {
        saturation = 1.0,
        brightness = 1.0
    }
end

return M
