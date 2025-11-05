-- ================================================================
-- Color Clipboard x64 (Persistent, Named Palettes)
-- Drag this from the MaxScript Editor to a toolbar.
-- ================================================================

global ColorClipboard64_isOpen
if ColorClipboard64_isOpen == undefined do ColorClipboard64_isOpen = false

-- If already open, close and exit (toggle behavior)
if ColorClipboard64_isOpen and (isKindOf ColorClipboard64Rollout RolloutClass) do
(
    try(destroyDialog ColorClipboard64Rollout) catch()
    ColorClipboard64_isOpen = false
    return()
)

rollout ColorClipboard64Rollout "Color Clipboard x64" width:300
(
    ------------------------------------------------------------------
    -- Persistent storage / palette config
    ------------------------------------------------------------------
    local iniFile           = (getDir #userScripts) + "\\ColorClipboard64.ini"
    local defaultColor      = (color 128 128 128)

    local numPalettes       = 4
    local paletteNames      = #("General", "Environment", "Characters", "UI")
    local currentPaletteIdx = 1
    local metaSection       = "PaletteMeta"

    ------------------------------------------------------------------
    -- UI
    ------------------------------------------------------------------

    group "Palette"
    (
        dropdownlist ddPalette "Active Palette:" items:paletteNames selection:1 width:200 align:#left
        editText    etPaletteName "Name:" text:"General" width:200 align:#left
        button      btnRename "Apply Name" width:120 align:#left
    )

    colorPicker cpCurrent "Current Color" align:#left

    spinner spSlot "Slot:" range:[1,64,1] type:#integer width:60 align:#left
    button btnSave      "Save Current Slot" width:140 across:2 align:#left
    button btnLoad      "Load Slot Current" width:140 align:#left
    button btnClearSlot "Clear Slot"          width:140 across:2 align:#left
    button btnResetAll  "Reset All (Palette)" width:140 align:#left

    group "Swatches (64 per palette)"
    (
        -- 64 swatches in an 8x8 grid
        colorPicker s01 "" width:24 height:24 across:8 align:#left
        colorPicker s02 "" width:24 height:24 align:#left
        colorPicker s03 "" width:24 height:24 align:#left
        colorPicker s04 "" width:24 height:24 align:#left
        colorPicker s05 "" width:24 height:24 align:#left
        colorPicker s06 "" width:24 height:24 align:#left
        colorPicker s07 "" width:24 height:24 align:#left
        colorPicker s08 "" width:24 height:24 align:#left

        colorPicker s09 "" width:24 height:24 across:8 align:#left
        colorPicker s10 "" width:24 height:24 align:#left
        colorPicker s11 "" width:24 height:24 align:#left
        colorPicker s12 "" width:24 height:24 align:#left
        colorPicker s13 "" width:24 height:24 align:#left
        colorPicker s14 "" width:24 height:24 align:#left
        colorPicker s15 "" width:24 height:24 align:#left
        colorPicker s16 "" width:24 height:24 align:#left

        colorPicker s17 "" width:24 height:24 across:8 align:#left
        colorPicker s18 "" width:24 height:24 align:#left
        colorPicker s19 "" width:24 height:24 align:#left
        colorPicker s20 "" width:24 height:24 align:#left
        colorPicker s21 "" width:24 height:24 align:#left
        colorPicker s22 "" width:24 height:24 align:#left
        colorPicker s23 "" width:24 height:24 align:#left
        colorPicker s24 "" width:24 height:24 align:#left

        colorPicker s25 "" width:24 height:24 across:8 align:#left
        colorPicker s26 "" width:24 height:24 align:#left
        colorPicker s27 "" width:24 height:24 align:#left
        colorPicker s28 "" width:24 height:24 align:#left
        colorPicker s29 "" width:24 height:24 align:#left
        colorPicker s30 "" width:24 height:24 align:#left
        colorPicker s31 "" width:24 height:24 align:#left
        colorPicker s32 "" width:24 height:24 align:#left

        colorPicker s33 "" width:24 height:24 across:8 align:#left
        colorPicker s34 "" width:24 height:24 align:#left
        colorPicker s35 "" width:24 height:24 align:#left
        colorPicker s36 "" width:24 height:24 align:#left
        colorPicker s37 "" width:24 height:24 align:#left
        colorPicker s38 "" width:24 height:24 align:#left
        colorPicker s39 "" width:24 height:24 align:#left
        colorPicker s40 "" width:24 height:24 align:#left

        colorPicker s41 "" width:24 height:24 across:8 align:#left
        colorPicker s42 "" width:24 height:24 align:#left
        colorPicker s43 "" width:24 height:24 align:#left
        colorPicker s44 "" width:24 height:24 align:#left
        colorPicker s45 "" width:24 height:24 align:#left
        colorPicker s46 "" width:24 height:24 align:#left
        colorPicker s47 "" width:24 height:24 align:#left
        colorPicker s48 "" width:24 height:24 align:#left

        colorPicker s49 "" width:24 height:24 across:8 align:#left
        colorPicker s50 "" width:24 height:24 align:#left
        colorPicker s51 "" width:24 height:24 align:#left
        colorPicker s52 "" width:24 height:24 align:#left
        colorPicker s53 "" width:24 height:24 align:#left
        colorPicker s54 "" width:24 height:24 align:#left
        colorPicker s55 "" width:24 height:24 align:#left
        colorPicker s56 "" width:24 height:24 align:#left

        colorPicker s57 "" width:24 height:24 across:8 align:#left
        colorPicker s58 "" width:24 height:24 align:#left
        colorPicker s59 "" width:24 height:24 align:#left
        colorPicker s60 "" width:24 height:24 align:#left
        colorPicker s61 "" width:24 height:24 align:#left
        colorPicker s62 "" width:24 height:24 align:#left
        colorPicker s63 "" width:24 height:24 align:#left
        colorPicker s64 "" width:24 height:24 align:#left
    )

    button btnFromSel "Current ← Selection Wirecolor" width:260 align:#left
    button btnToSel   "Selection Wirecolor ← Current" width:260 align:#left

    ------------------------------------------------------------------
    -- Helpers
    ------------------------------------------------------------------

    fn getSwatchByIndex i =
    (
        case i of
        (
             1: s01;  2: s02;  3: s03;  4: s04;  5: s05;  6: s06;  7: s07;  8: s08;
             9: s09; 10: s10; 11: s11; 12: s12; 13: s13; 14: s14; 15: s15; 16: s16;
            17: s17; 18: s18; 19: s19; 20: s20; 21: s21; 22: s22; 23: s23; 24: s24;
            25: s25; 26: s26; 27: s27; 28: s28; 29: s29; 30: s30; 31: s31; 32: s32;
            33: s33; 34: s34; 35: s35; 36: s36; 37: s37; 38: s38; 39: s39; 40: s40;
            41: s41; 42: s42; 43: s43; 44: s44; 45: s45; 46: s46; 47: s47; 48: s48;
            49: s49; 50: s50; 51: s51; 52: s52; 53: s53; 54: s54; 55: s55; 56: s56;
            57: s57; 58: s58; 59: s59; 60: s60; 61: s61; 62: s62; 63: s63; 64: s64;
            default: undefined
        )
    )

    fn getPaletteSwatchSection idx =
    (
        "Swatches_" + idx as string
    )

    fn getPaletteGeneralSection idx =
    (
        "General_" + idx as string
    )

    fn colorToString c =
    (
        if c == undefined then "128,128,128"
        else ((c.r as integer) as string + "," +
              (c.g as integer) as string + "," +
              (c.b as integer) as string)
    )

    fn stringToColor s =
    (
        if s == undefined or s == "" then
            defaultColor
        else
        (
            local parts = filterString s ","
            if parts.count == 3 then
                (color (parts[1] as integer) (parts[2] as integer) (parts[3] as integer))
            else
                defaultColor
        )
    )

    fn loadPaletteNames =
    (
        for i = 1 to numPalettes do
        (
            local key = "Name" + (i as string)
            local stored = getIniSetting iniFile metaSection key
            if stored != undefined and stored != "" do
                paletteNames[i] = stored
        )
    )

    fn savePaletteNames =
    (
        for i = 1 to numPalettes do
        (
            local key = "Name" + (i as string)
            setIniSetting iniFile metaSection key paletteNames[i]
        )
    )

    fn savePalette idx =
    (
        local swSec  = getPaletteSwatchSection idx
        local genSec = getPaletteGeneralSection idx

        for i = 1 to 64 do
        (
            local sw = getSwatchByIndex i
            if sw != undefined do
            (
                local key = "Slot" + (i as string)
                setIniSetting iniFile swSec key (colorToString sw.color)
            )
        )

        setIniSetting iniFile genSec "CurrentColor" (colorToString cpCurrent.color)
        setIniSetting iniFile genSec "LastSlot"     (spSlot.value as string)
    )

    fn loadPalette idx =
    (
        local swSec  = getPaletteSwatchSection idx
        local genSec = getPaletteGeneralSection idx

        for i = 1 to 64 do
        (
            local key = "Slot" + (i as string)
            local s = getIniSetting iniFile swSec key
            local col = stringToColor s
            local sw = getSwatchByIndex i
            if sw != undefined do sw.color = col
        )

        local curStr = getIniSetting iniFile genSec "CurrentColor"
        cpCurrent.color = stringToColor curStr

        local lastSlotStr = getIniSetting iniFile genSec "LastSlot"
        if lastSlotStr != undefined and lastSlotStr != "" then
        (
            local v = try(lastSlotStr as integer) catch(1)
            if v < 1 or v > 64 do v = 1
            spSlot.value = v
        )
        else
        (
            spSlot.value = 1
        )
    )

    fn resetCurrentPalette =
    (
        for i = 1 to 64 do
        (
            local sw = getSwatchByIndex i
            if sw != undefined do sw.color = defaultColor
        )
        cpCurrent.color = defaultColor
        spSlot.value = 1
        savePalette currentPaletteIdx
    )

    ------------------------------------------------------------------
    -- Events
    ------------------------------------------------------------------

    on ColorClipboard64Rollout open do
    (
        loadPaletteNames()
        ddPalette.items = paletteNames
        if ddPalette.selection < 1 do ddPalette.selection = 1
        currentPaletteIdx = ddPalette.selection
        etPaletteName.text = paletteNames[currentPaletteIdx]
        loadPalette currentPaletteIdx
        ColorClipboard64_isOpen = true
    )

    on ColorClipboard64Rollout close do
    (
        savePalette currentPaletteIdx
        savePaletteNames()
        ColorClipboard64_isOpen = false
    )

    on ddPalette selected idx do
    (
        savePalette currentPaletteIdx
        currentPaletteIdx = idx
        etPaletteName.text = paletteNames[currentPaletteIdx]
        loadPalette currentPaletteIdx
    )

    on btnRename pressed do
    (
        paletteNames[currentPaletteIdx] = etPaletteName.text
        ddPalette.items = paletteNames
        ddPalette.selection = currentPaletteIdx
        savePaletteNames()
    )

    on btnSave pressed do
    (
        local sw = getSwatchByIndex spSlot.value
        if sw != undefined do
        (
            sw.color = cpCurrent.color
            savePalette currentPaletteIdx
        )
    )

    on btnLoad pressed do
    (
        local sw = getSwatchByIndex spSlot.value
        if sw != undefined do cpCurrent.color = sw.color
    )

    on btnClearSlot pressed do
    (
        local sw = getSwatchByIndex spSlot.value
        if sw != undefined do
        (
            sw.color = defaultColor
            savePalette currentPaletteIdx
        )
    )

    on btnResetAll pressed do
    (
        resetCurrentPalette()
    )

    on btnFromSel pressed do
    (
        if selection.count > 0 do
        (
            if isProperty selection[1] #wirecolor do
                cpCurrent.color = selection[1].wirecolor
        )
    )

    on btnToSel pressed do
    (
        if selection.count > 0 do
        (
            for obj in selection where isProperty obj #wirecolor do
                obj.wirecolor = cpCurrent.color
        )
    )
)

createDialog ColorClipboard64Rollout style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
ColorClipboard64_isOpen = true
