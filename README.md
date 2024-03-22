# venison.nvim

~~I'm not sure if deer are classified as game animals, but let's pretend they are.~~

An experimental plugin framework for creating basic games in neovim, based on a simple event loop.

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
