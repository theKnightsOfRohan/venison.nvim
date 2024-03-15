fmt:
	echo "===> Formatting"
	stylua lua/ --config-path=.stylua.toml

lint:
	echo "===> Linting"
	luacheck lua/ --globals vim

test:
	echo "===> Testing"
	nvim --headless --noplugin -u lua/venison/tests/minimal_init.lua -c "PlenaryBustedDirectory lua/venison/tests/ { minimal_init = 'lua/venison/tests/minimal_init.lua' }"

clean:
	echo "===> Cleaning testing dependencies"
	rm -rf /tmp/venison_test/plenary.nvim
	rm -rf /tmp/venison_test/nui.nvim

all:
	make fmt lint test clean
