# Color Clipboard x64 for 3ds Max

A simple 3ds Max utility script that provides a persistent, multi-palette color clipboard:

<img width="302" height="562" alt="3ds_Max_Color_Tool" src="https://github.com/user-attachments/assets/3eebde25-4d61-48d3-bd2a-4c88319cf4fe" />

- 64 color slots per palette (8×8 grid)
- 4 independent palettes (e.g. General, Environment, Characters, UI)
- Palettes can be renamed (names are saved)
- Colors and palette names are saved between sessions (INI file in `userScripts`)
- Optional helpers to read/write selection wirecolor from the current color

This is intended as a more flexible riff on the built-in Color Clipboard.

---

## Requirements

- 3ds Max (tested with 3ds Max 2026, should work with most modern versions that support MaxScript rollouts and `setIniSetting`/`getIniSetting`).

---

## Installation

1. Save the script file somewhere convenient, for example:

   - `ColorClipboard64_NamedPalettes.ms`

2. Open **3ds Max**.

3. Go to **Scripting → New Script…**.

4. Open the `.ms` file in the MaxScript Editor (or paste the script contents into a new MaxScript editor tab).

5. **Select the entire script** in the editor.

6. **Middle-drag** the selected script from the MaxScript editor onto a toolbar.

   - This creates a new toolbar button backed by an auto-generated macro (usually under the `DragAndDrop` category).

7. Optionally, rename the button:

   - Go to **Customize → Customize User Interface…**
   - Category: **DragAndDrop**
   - Find the newly created macro (e.g. `DragAndDrop-MacroX`)
   - Change its **Button Text** to something like `Color Clipboard x64`.

---

## Usage

1. Click the `Color Clipboard x64` toolbar button.

   - The **Color Clipboard x64** floater opens.
   - Clicking the button again will close it (the script has built-in toggle behavior).

2. At the top, choose a palette:

   - `Active Palette` dropdown selects which palette is currently active.
   - The `Name` field shows the current palette name.
   - Type a new name and click **Apply Name** to rename the active palette.
   - Palette names are saved to `ColorClipboard64.ini` in your `userScripts` folder.

3. Use the **Current Color** picker:

   - `Current Color` is your working color.
   - You can use it to store into / load from any slot in the current palette.

4. Working with slots:

   - `Slot` spinner: choose a slot number from **1–64**.
   - **Save Current → Slot**: copies the current color into that slot.
   - **Load Slot → Current**: copies the slot color back into the current color picker.
   - **Clear Slot**: resets that single slot to the default neutral gray.
   - **Reset All (Palette)**: clears all 64 slots in the current palette and resets the current color.

5. Swatch grid:

   - The 8×8 grid shows the 64 colors for the current palette.
   - Changes you make via **Save Current → Slot** are reflected immediately.
   - Switching palettes updates the grid to show that palette’s colors.

6. Wirecolor helpers (optional):

   - **Current ← Selection Wirecolor**  
     If you have at least one object selected and it has a `wirecolor` property, this button sets `Current Color` to the selection’s wirecolor.
   - **Selection Wirecolor ← Current**  
     Sets all selected objects’ `wirecolor` to the current color.

---

## Persistence

All data is stored in an INI file:

- File path:  
  `getDir #userScripts + "\\ColorClipboard64.ini"`

The file contains:

- Per-palette color data for 64 slots.
- Per-palette current color and last-used slot.
- Palette names for each palette.

You can delete the INI file to completely reset all palettes and names.

---

## Notes

- To expand beyond 64 colors, you can:
  - Add more `colorPicker` controls to the rollout.
  - Update the slot range (`1–128`, etc.).
  - Update loops that iterate from `1 to 64` to use the new slot count.

- To add more palettes, increase `numPalettes` and extend the initial `paletteNames` array;
