local Utils = require("venison.utils")
local Logger = require("venison.logger")

---@class VenisonLoop
---@field _frame_rate number
---@field _looping boolean
---@field timer uv.uv_timer_t|uv_timer_t|nil
local Loop = {
    _frame_rate = 10,
    _looping = true,
    timer = vim.uv.new_timer(),
}

---@param draw_method function
function Loop.draw(draw_method)
    local pass = Logger:assert(Loop.timer, "loop.draw(): timer has not been initialized")
    if not pass then
        return
    end

    local interval = 1000 / Loop._frame_rate

    ---@diagnostic disable-next-line: need-check-nil
    Loop.timer:start(
        0,
        interval,
        vim.schedule_wrap(function()
            if Loop._looping then
                draw_method()
            end
        end)
    )

    Logger:log("loop.draw(): game loop started")
end

---@param new_rate number
function Loop.frame_rate(new_rate)
    Logger:log(string.format("loop.frame_rate(): setting frame rate from %d to %d", Loop._frame_rate, new_rate))
    Loop._frame_rate = new_rate
end

function Loop.loop_stop()
    Logger:log("loop.loop_stop(): stopping game loop")
    Loop._looping = false
end

function Loop.loop_start()
    Logger:log("loop.loop_start(): starting game loop")
    Loop._looping = true
end

function Loop.loop_toggle()
    Logger:log(
        "loop.loop_toggle(): toggling game loop from %s to %s",
        Utils.bool_to_string(Loop._looping),
        Utils.bool_to_string(not Loop._looping)
    )
    Loop._looping = not Loop._looping
end

function Loop.loop_reset()
    Logger:log("loop.loop_reset(): resetting game loop")
    local pass, err = Loop.timer:stop()

    if not pass then
        Logger:log("loop.loop_reset(): failed to stop timer")
        Logger:log(err)
    end
end

function Loop.is_looping()
    return Loop._looping
end

return Loop
