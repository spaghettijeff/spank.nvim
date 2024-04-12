local M = {}

M.swank_connection = {}

M.spawn = function()
    local settings = vim.g.spank_settings or {}
    if not M.swank_connection.buffer then
        M.swank_connection.buffer = vim.api.nvim_create_buf(true, true)
    end
    if not M.swank_connection.job then
        vim.api.nvim_buf_call(M.swank_connection.buffer, function() 
            M.swank_connection.job = vim.fn.termopen(
            settings.swank_cmd or
            {
                'sbcl',
                '--eval', '(require "ASDF")',
                '--eval', '(asdf:load-system \'swank)',
                '--eval', '(swank:create-server :dont-close t)',
            },
            {
                on_exit = function(id, data, event)
                    vim.cmd{ cmd = "bdelete", args = { M.swank_connection.buffer }, bang = true }
                    M.swank_connection.job = nil
                    M.swank_connection.buffer = nil
                    vim.notify("Swank server exited", vim.log.levels.INFO)
                end,
            })
        end)
        vim.notify("Swank server started.", vim.log.levels.INFO)
        return
    end
        vim.notify("Swank server failed to start, one is already running", vim.log.levels.INFO)
end

M.show = function()
    local settings = vim.g.spank_settings or {}
    local buf = M.swank_connection.buffer
    if buf then
        vim.cmd.buffer(buf)
    else
        vim.notify("No swank server running", vim.log.levels.INFO)
    end
end

M.quit = function()
    local settings = vim.g.spank_settings or {}
    local job = M.swank_connection.job
    if job then
        vim.fn.jobstop(job)
    end
end

return M
