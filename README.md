# SuperSprayPaint Mod for Drive Beyond Horizons

A simple mod that allows you to spawn paint bombs with various colors and finishes. Press F5 to instantly spawn two of each color paint bomb (one matte, one metallic) in a neat grid layout in front of your character.

## Features

- Spawn paint bombs with various colors and sheen types
- Simple one-key operation (F5)
- Organized grid layout for easy selection
- Spawns both matte and metallic versions of each color
- Lightweight and non-intrusive

## Usage

### Controls

1. Face the direction where you want the paint bombs to appear
2. Press `F5` to instantly spawn all paint bombs in a grid in front of your character
3. Each color will have two variants:
   - Regular (matte) finish
   - Metallic finish (positioned slightly behind the matte version)
4. The paint bombs will be arranged in a neat grid for easy selection

### Available Colors

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

### Available Sheen Types

- Metallic - Shiny metallic finish
- Matte - Flat, non-reflective finish
- Glossy - Shiny, reflective finish
- Chrome - Mirror-like, highly reflective finish

## Installation

1. Make sure you have UE4SS installed for Drive Beyond Horizons
2. Place the SuperSprayPaintMod folder in your game's mods directory:
   `Drive Beyond Horizons\DriveBeyondHorizons\Binaries\Win64\ue4ss\Mods\`
3. Make sure the `enabled.txt` file is present in the mod folder
4. Add the mod to your `mods.txt` file in the UE4SS Mods directory:
   ```
   SuperSprayPaintMod : 1
   ```
5. Launch the game

## Troubleshooting

If you encounter issues:

1. Check the UE4SS console for error messages
2. Make sure the mod is properly installed and enabled in the mods.txt file
3. Try using different color and sheen combinations
4. If paint bombs don't spawn with the correct colors, check the UE4SS console for error messages
5. Make sure you have the latest version of UE4SS installed

## Technical Details

This mod uses UE4SS Lua scripting to:
1. Spawn paint bomb actors in the game world when F5 is pressed
2. Set custom colors and sheen properties on those actors
3. Arrange the paint bombs in an organized grid layout

The mod is designed to be lightweight and non-intrusive, only activating when you press the F5 key.

## Credits

Created for Drive Beyond Horizons using UE4SS Lua scripting
