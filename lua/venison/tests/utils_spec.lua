local Utils = require("venison.utils")

describe("Utils should", function()
    it("deepcopy", function()
        local orig = {
            a = 1,
            b = {
                c = 2,
                d = 3,
            },
        }
        local copy = Utils.deepcopy(orig)
        assert.are.same(orig, copy)
        assert.are_not.equal(orig, copy)
    end)

    it("trim", function()
        local str = "  hello world  "
        local trimmed = Utils.trim(str)
        assert.are.equal("hello world", trimmed)
    end)

    it("remove duplicate whitespace", function()
        local str = "hello  world"
        local trimmed = Utils.remove_duplicate_whitespace(str)
        assert.are.equal("hello world", trimmed)
    end)

    it("split", function()
        local str = "hello world"
        local split = Utils.split(str, " ")
        assert.are.same({ "hello", "world" }, split)
    end)

    it("intersect strings", function()
        local base = "potato"
        local intersect = "tomato"
        local result = Utils.intersect_string(base, intersect, 3)
        assert.are.equal("potoma", result)

        result = Utils.intersect_string(base, intersect, -3)
        assert.are.equal("matoto", result)
    end)
end)
