local M = {}

function M.apply(config)
    config.launch_menu = {
        -- Shell
        { label = "Bash",           args = { "bash", "-l" } },
        { label = "Zsh",            args = { "zsh", "-l" } },
	
	-- Shell Programs
	{ label = "Claude Code",    args = { "claude" } },

        -- SSH 连接
        { label = "SSH: Hostdare0.mmm.com",  args = { "ssh", "root@212.103.62.177" } },
} 
end 

return M
