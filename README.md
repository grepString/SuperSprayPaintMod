# SuperSprayPaint Mod for Drive Beyond Horizons

This mod allows you to spawn paint cans with various colors and finishes.

<img src="screenshot.gif" alt="Screenshot" width="600">

## Features

- Spawn a single paint can with a keybind
- Cycle through 11 different colors
- Toggle between matte and metallic sheen
- Near infinite spray amount

## Usage

### Controls

- `F5` Spawn a paint can in front of the player
- `[` (Left Bracket): Cycle to the previous color
- `]` (Right Bracket): Cycle to the next color
- `\` (Backslash): Toggle between matte and metallic sheen

### Available Colors

Basic
- Blue
- Red
- Green
- Yellow
- Orange
- Purple
- Pink
- Black
- White
- Gold
- Silver

F1 Racing Teams
- Alfa Romeo Maroon
- Alpine Dark Blue
- Aston Martin Dark Green
- Aston Martin Tiffany Green
- Caterham Green
- Équipe Ligier Dark Blue
- Force India Orange
- Forti Corse Warm Gray
- Haas Red
- HRT Khaki
- Manor Racing Blue
- Red Bull Racing Silver
- Sauber Red
- Scuderia AlphaTauri Dark Blue
- Scuderia Ferrari Yellow
- Scuderia Toro Rosso Red
- Simtek Medium Slate Blue
- Team Lotus Peach Puff
- Team Lotus Orange
- Team Penske Red
- Toleman Blue
- Williams Racing Sky Blue



### Available Sheen Types

- Matte
- Metallic

## Tutorial Video

[![How to Install UE4SS + Mod | Drive Beyond Horizons](https://img.youtube.com/vi/pWbKwe9b0e0/0.jpg)](https://www.youtube.com/watch?v=pWbKwe9b0e0)

## Installation

Note: If you're installing an updated version of this mod, just overwrite the existing files.

1. Make sure you have the most recent `experimental-latest` version of UE4SS installed into your Drive Beyond Horizons directory. [Download](https://github.com/UE4SS-RE/RE-UE4SS/releases/tag/experimental-latest)
   
`Drive Beyond Horizons\DriveBeyondHorizons\Binaries\Win64`

2. Place the SuperSprayPaintMod folder in your game's mods directory:
   
`Drive Beyond Horizons\DriveBeyondHorizons\Binaries\Win64\ue4ss\Mods\`

3. By default this mod will be enabled via enabled.txt in the mods folder. You can drop the mod in and and launch the game.

   There are two ways to enable/disable the mod:
   - **Method 1 (default)**: Create an empty file named `enabled.txt` in the SuperSprayPaintMod folder
     - This bypasses the need to edit mods.txt/mods.json
     - To disable and use the next method, simply delete this file.
   - **Method 2**: Add the mod to your `mods.txt` and/or `mods.json` file in the UE4SS Mods directory:

   mods.txt:
     ```
     SuperSprayPaintMod : 1
     ```
   mods.json:
     ```json
     {
       "SuperSprayPaintMod": true
     }
     ```
4. Launch the game and load into a map
5. Press F5 in-game to spawn the paint cans

## Multiplayer

Note: This mod works best in single player.

- All players should have the mod installed
- Host-spawned cans have priority when applying paint
- Host can spawn cans of set colors for friends to use
- Friends of Host cannot change colors of host-spawned cans

## Known Issues

- Placing the spawned can into a hotbar slot overwrites the modded can. Just spawn a new one to get around this. It will store on the rack or in a vehicle just fine.
- The game saves normally, but if you try to exit via the in-game menu after spawning cans at least once, the game will crash. While it *is* annoying, it's relatively harmless.

## Troubleshooting

If you encounter issues:

1. Check the UE4SS console for error messages (requires zDEV-UE4SS install)
2. Make sure the mod is properly installed and enabled (either with enabled.txt or in mods.txt/mods.json)
3. If paint cans spawn in weird positions:
   - Make sure you're standing on relatively flat ground. Gas Stations and Repair Shops have the best flat ground.

## TODO

- Add more colors and finishes
- ~~Increase paint amount per can~~ Completed
- Add method to clear spawned cans in an area relative to the player

## Credits

Special thanks to the UE4SS and Drive Beyond Horizons team for making modding possible.
