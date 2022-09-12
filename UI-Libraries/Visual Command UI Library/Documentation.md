# Visual Command UI Library Documentation

## Getting Loadstring
```lua
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/VisualRoblox/Roblox/main/UI-Libraries/Visual%20Command%20UI%20Library/Source.lua', true))()
```

## Creating Window
```lua
local Window = Library:CreateWindow({
    Name = 'Visual Command UI Library', -- // The name of the created window.
    IntroText = 'Visual Command UI Library', -- // The text that will show in the intro / loading screen.
    IntroIcon = 'rbxassetid://10618644218', -- // The AssetId of the icon that will show in the intro / loading screen.
    ConfigFolder = 'Visual Command UI Library Configs', -- // The folder that configs will save to.
    Theme = Library.Themes.Dark, -- // The theme the library should use (see more in Themes.md).
    Position = 'Top', -- // The position the Window can be in (Top, TopLeft, TopRight, Bottom, BottomLeft, BottomRight).
    Draggable = true, -- // If the window is draggable (Only only X-axis).
    Prefix = '.' -- // The prefix that will be used before typing a command (will make the UI popup as well).
})
```