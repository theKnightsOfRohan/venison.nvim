local Logger = require("venison.logger")

describe("Logger", function()
    before_each(function()
        Logger:clear()
    end)

    it("should remove newlines", function()
        Logger:log("hello\nworld")
        assert.are.same(Logger.lines, { "hello world" })
    end)

    it("should remove new lines within vim.inspect", function()
        Logger:log({ hello = "world", world = "hello" })
        assert.are.same({ '{ hello = "world", world = "hello" }' }, Logger.lines)
    end)

    it("should be restricted to max lines", function()
        Logger.max_lines = 1
        Logger:log("one")
        assert.are.same({ "one" }, Logger.lines)
        Logger:log("two")
        assert.are.same({ "two" }, Logger.lines)
    end)

    it("should correctly handle both correct and incorrect logged assertions", function()
        local success = Logger:assert(true, "This should pass")
        assert.are.same(Logger.lines, {})
        assert.is_true(success)

        success = Logger:assert(false, "This should fail")
        assert.are.same(Logger.lines, { "./lua/venison/logger.lua:75: ERROR: This should fail" })
        assert.is_false(success)
    end)
end)
