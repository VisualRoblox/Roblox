# Visual Command UI Library Documentation
Gitbook Version: https://mapple7777.gitbook.io/visual-command-ui-library-documentation/visual-command-ui-library-documentation

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
    IntroBlur = true, -- // If there should be a blur during the intro.
    IntroBlurIntensity = 15, -- // The intensity of the blur.
    Theme = Library.Themes.dark, -- // The theme the library should use (see more in Themes.md).
    Position = 'bottom', -- // The position the Window can be in (Top, TopLeft, TopRight, Bottom, BottomLeft, BottomRight).
    Draggable = true, -- // If the window is draggable (Only only X-axis).
    Prefix = ';' -- // The prefix that will be used before typing a command (will make the UI popup as well).
})
```

## Adding Commands
```lua
Window:AddCommand('Print', {'String'}, 'Prints A String.', function(Arguments, Speaker)
    print(Arguments[1]) 
end)
```
```text
1. <String> The name of the command (No spaces).
2. <Table> The arguments of the command.
3. <String> A description of the command.
4. <Function> The callback of the command, Arguments will return any inputed arguments, speaker is the localplayer.
```

## Creating Notifications
```lua
Window:CreateNotification('Visual Command UI Library', 'Notification', 5)
```
```text
1. <String> The title of the notification.
2. <String> The text of the notification.
3. <Number> The amount of time the notification will be on screen for.
```

## Adding Themes
```lua
Window:AddTheme('test', {
    BackgroundColor = Color3.fromRGB(0, 255, 255),
    SecondaryColor = Color3.fromRGB(225, 225, 225),
    AccentColor = Color3.fromRGB(125, 125, 125),
    PrimaryTextColor = Color3.fromRGB(0, 0, 0),
    SecondaryTextColor = Color3.fromRGB(75, 75, 75)
})
```
```text
1. <String> The name of the new theme.
2. <Table> The colours of the theme. (see more in Themes.md)
```

## Changing Themes
```lua
Window:ChangeTheme('dark')
```
```text
1. <String> The name of the theme.
```

## Getting Themes
```lua
for _, Theme in next, Window:GetThemes(true) do
    print(Theme)
end

for Index, Theme in next, Window:GetThemes(false) do
    print(Index, Theme)
end
```
```text
1. <Bool> if true, only the names of themes will be returned, if false, all themes will be returned.
```