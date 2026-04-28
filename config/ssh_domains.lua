local M = {}

function M.apply(config)
	config.ssh_domains = {
		{
			name = "---.com",
			remote_address = "---:---",
			username = "",
			-- 如果需要可以指定私钥路径
			-- ssh_option = { identityfile = "~/.ssh/id_ed25519" },
		},
	}
end

return M
