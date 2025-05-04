# SuperSprayPaint Mod for Drive Beyond Horizons

A simple mod that allows you to spawn paint bombs with custom colors and finishes. This mod provides a clean, user-friendly interface for selecting paint colors and sheen types, then spawning paint bombs with those properties.

## Features

- Spawn paint bombs with various colors and sheen types
- Intuitive mouse-based UI with color circles for easy selection
- Two rows of color options - standard colors and metallic variants
- Easy to use point-and-click interface
- Single keybind (F5) to access all functionality

## Usage

### Controls

1. Press `F5` to open the Paint UI
2. Use your mouse to:
   - Click on a color to select it
   - Click on a sheen type to select it
   - Click "Spawn Paint Bomb" to create a paint bomb with your selected settings
   - Click "Close" to close the UI
3. The paint bomb will spawn in front of your character

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
1. Create a custom UI widget for color and sheen selection
2. Spawn paint bomb actors in the game world
3. Set custom properties on those actors

The mod is designed to be lightweight and non-intrusive, only activating when you press the F5 key.

## Credits

Created for Drive Beyond Horizons using UE4SS Lua scripting
