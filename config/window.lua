local M = {}

function M.apply(config)
    -- 窗口装饰样式（无标题栏按钮）
    config.window_decorations = "RESIZE"

    -- 初始窗口大小
    config.initial_cols = 150
    config.initial_rows = 40

    -- 窗口行为
    config.adjust_window_size_when_changing_font_size = false
    config.window_close_confirmation = "NeverPrompt"
end

return M
