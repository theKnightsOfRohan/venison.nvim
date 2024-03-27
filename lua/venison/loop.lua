local Utils = require("venison.utils")
local Logger = require("venison.logger")

---@class VenisonDraw
---@field _frame_rate number
---@field _looping boolean
---@field timer uv.uv_timer_t|uv_timer_t|nil
local Draw = {
    _frame_rate = 10,
    _looping = true,
    timer = vim.uv.new_timer(),
}

---@param method function
function Draw.draw(method)
    local pass = Logger:assert(Draw.timer, "draw.draw(): failed to create timer")
    if not pass then
        return
    end

    local interval = 1000 / Draw._frame_rate

    ---@diagnostic disable-next-line: need-check-nil
    Draw.timer:start(
        0,
        interval,
        vim.schedule_wrap(function()
            if Draw._looping then
                method()
            end
        end)
    )

    Logger:log("draw.draw(): game loop started")
end

---@param new_rate number
function Draw.frame_rate(new_rate)
    Logger:log(string.format("draw.frame_rate(): setting frame rate from %d to %d", Draw._frame_rate, new_rate))
    Draw._frame_rate = new_rate
end

function Draw.loop_stop()
    Logger:log("draw.loop_stop(): stopping game loop")
    Draw._looping = false
end

function Draw.loop_start()
    Logger:log("draw.loop_start(): starting game loop")
    Draw._looping = true
end

function Draw.loop_toggle()
    Logger:log(
        "draw.loop_toggle(): toggling game loop from %s to %s",
        Utils.bool_to_string(Draw._looping),
        Utils.bool_to_string(not Draw._looping)
    )
    Draw._looping = not Draw._looping
end

function Draw.is_looping()
    return Draw._looping
end

return Draw
