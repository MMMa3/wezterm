local M = {}

function M.apply(config)
    config.ssh_domains = {
        {
            name = "Hostdare0.mmm.com",
            remote_address = "212.103.62.177:22",
            username = "root",
            -- 如果需要可以指定私钥路径
            -- ssh_option = { identityfile = "~/.ssh/id_rsa" },
        },
    }
end

return M
