# venison.nvim

~~I'm not sure if deer are classified as game animals, but let's pretend they are.~~

An experimental plugin framework for creating games in neovim, based on a simple event loop. Inspired by [ThePrimeagen/vim-with-me](https://github.com/ThePrimeagen/vim-with-me), but with a focus on a simpler, more intuitive API, and making use of some pre-built, much more powerful libraries. Also, you shouldn't need to use a separate language to code the game.

NOTE: STILL IN DEVELOPMENT, NOT YET READY FOR USE

## Roadmap
- [x] Open and close a window and register commands to that window
- [x] Save some window state between opening and closing
- [x] Basic logging to replace breaking asserts
- [x] Populate game window with characters and handle explicit content modifications
- [ ] Create a good api for handling key presses
- [ ] Make a non-blocking game event loop

## Known Bugs
- [ ] The window cannot correctly handle applying a text change to the buffer which starts from a negative column number

## Contributing
All contributions are welcome! Please feel free to open an issue or pull request. Note that I have the programming capabilities of a small rodent, as will be evident from the codebase, so please don't be afraid to suggest changes or improvements to the API.
