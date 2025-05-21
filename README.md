# SuperSprayPaintMod for Drive Beyond Horizons

This mod allows you to spawn paint cans with various colors and finishes.

<img src="screenshot.gif" alt="Screenshot" width="600">

## Features

- Spawn a single paint can with a keybind
- Cycle through all the different colors
- Toggle between matte and metallic sheen
- Near infinite usage

Now includes:
- Infinite Rust Brush
- Infinite Polish Sponge

## Usage

### Controls

- `F5` Spawn a paint can
- `F6` Spawn a rust brush
- `F7` Spawn a polish sponge
- `[` (Left Bracket): Cycle to the previous color
- `]` (Right Bracket): Cycle to the next color
- `\` (Backslash): Toggle between matte and metallic sheen

### Available Colors

View existing colors and cleaner instructions:

https://grepstring.github.io/SuperSprayPaintMod/

### Available Sheens

- Matte
- Metallic

## Tutorial Video

[![How to Install UE4SS + Mod | Drive Beyond Horizons](https://img.youtube.com/vi/pWbKwe9b0e0/0.jpg)](https://www.youtube.com/watch?v=pWbKwe9b0e0)

## Installation Guide

Note: If you're installing an updated version of this mod, just overwrite the existing files.

### 1. Install UE4SS
- Download the **experimental-latest** zDEV version of UE4SS from [GitHub](https://github.com/UE4SS-RE/RE-UE4SS/releases/tag/experimental-latest)
- Place the `ue4ss` folder and `dwmapi.dll` in:  
  `Drive Beyond Horizons\DriveBeyondHorizons\Binaries\Win64`

### 2. Install the Mod
- Download the mod from [GitHub](https://github.com/grepString/SuperSprayPaintMod/releases/latest)
- Place the `SuperSprayPaintMod` folder in:  
  `Drive Beyond Horizons\DriveBeyondHorizons\Binaries\Win64\ue4ss\Mods\`

### 3. Mod Configuration (Optional)
The mod comes pre-enabled with an `enabled.txt` file. No additional setup is required.

If you prefer to manage mods through configuration files, you can:
- Delete the `enabled.txt` file and add the mod to your configuration:
```
mods.txt:
SuperSprayPaintMod : 1

mods.json:
{
  "SuperSprayPaintMod": true
}
```


## Multiplayer

Note: This mod works best in single player.

- All players should have the mod installed
- Host-spawned cans have priority when applying paint
- Host can spawn cans of set colors for friends to use
- Friends of Host cannot change colors of host-spawned cans

## Known Issues

- Placing the spawned can into a hotbar slot overwrites the modded can. Just spawn a new one to get around this.
- The game saves normally, but if you try to exit via the in-game menu after spawning cans at least once, the game will crash. While it *is* annoying, it's relatively harmless.

## Troubleshooting

If you encounter issues:

1. Check the UE4SS console for error messages (requires zDEV-UE4SS install)
2. Make sure the mod is properly installed and enabled (either with enabled.txt or in mods.txt/mods.json)
3. If paint cans spawn in weird positions:
   - Make sure you're standing on relatively flat ground. Gas Stations and Repair Shops have the best flat ground.

## TODO

- ~~Add more colors~~ Completed
- ~~Increase paint amount per can~~ Completed
- ~~Add more useful tools~~ Completed

## Credits

Special thanks to the UE4SS and Drive Beyond Horizons team for making modding possible.

## License
[SuperSprayPaintMod](https://github.com/grepString/SuperSprayPaintMod) © 2025 by [grepString](https://github.com/grepString) is licensed under [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nd/4.0/)

