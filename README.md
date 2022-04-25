# LEGO-Battles-Maps-to-Tiled
A little project to convert LEGO Battles .tbp and/or .map files (depending on how the information ends up being stored), to Tiled .tmx files and back, allowing for easy map creation. This should especially help given that the tilesets for this game are all a jumbled mess.

The current basic, nowhere near finished code is designed to take a decompressed .tbp file and make a tile map in the simplest way possible: by treating every byte pair as a tile. As you might imagine, it doesn't produce the best results.

Thanks to IAMOort of r/lua, whose manual decimal to hexadecimal conversion code (see https://old.reddit.com/r/lua/comments/qpg7zb/decimal_to_hex_lua_51_incorrect_results/) is used in this project. Hopefully they don't mind.
