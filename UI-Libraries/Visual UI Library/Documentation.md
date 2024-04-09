# Visual UI Library Documentation
Gitbook Version: https://mk0-2.gitbook.io/visual-ui-library-documentation

## Getting Loadstring
```lua
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/VisualRoblox/Roblox/main/UI-Libraries/Visual%20UI%20Library/Source.lua'))()
```

## Creating Window
```lua
local Window = Library:CreateWindow('Hub Name', 'Game Name', 'Visual UI Library', 'rbxassetid://10618928818', false, 'VisualUIConfigs', 'Default')
```
```text
1.) <String> Name of the UI.
2.) <String> Name of the Game.
3.) <String> Text that shows in the intro screen.
4.) <String> URL of the icon that shows in the intro screen.
5.) <Bool> if true, themes will be disabled, if false, themes will be enabled (this setting is to increase performance)
6.) <String> the path that the config folder should be in your exploits workspace folder.
7.) <String or Table> The name of a pre-made theme or a table with your custom theme (Find more in Themes.md).
```

## Creating Tabs
```lua
local Tab = Window:CreateTab('Tab', true, 'rbxassetid://3926305904', Vector2.new(484, 44), Vector2.new(36, 36))
```
```text
1.) <String> Name of the tab.
2.) <Bool> Tab visibility.
3.) <String> Tab Image URL.
4.) <Vector2> Tab Image RectOffset.
5.) <Vector2> Tab Image RectSize.
```

## Creating Sections
```lua
local Section = Tab:CreateSection('Section')
```
```text
1.) <String> Name of the section.
```

## Creating Labels
```lua
local Label = Section:CreateLabel('Label')
```
```text
1.) <String> Label text.
```

## Updating Labels
```lua
Label:UpdateLabel('New Text')
```
```text
1.) <String> New label text.
```

## Creating Paragraphs
```lua
local Paragraph = Section:CreateParagraph('Paragraph', 'Content')
```
```text
1.) <String> Title of the paragraph.
2.) <String> Content of the paragraph.
```

## Updating Paragraphs
```lua
Paragraph:UpdateParagraph('New Title', 'New Text')
```
```text
1.) <String> New title of the paragraph.
2.) <String> New content of the paragraph.
```

## Creating Buttons
```lua
local Button = Section:CreateButton('Button', function()
    print('Button Pressed')
end)
```
```text
1.) <String> Name of the button.
2.) <Function> Function / Callback of the button.
```

## Creating Sliders
```lua
local Slider = Section:CreateSlider('Slider', 1, 100, 50, Color3.fromRGB(0, 125, 255), function(Value)
    print(Value)
end)
```
```text
1.) <String> Name of the slider.
2.) <Number> Minimum value of the slider.
3.) <Number> Maximum value of the slider.
4.) <Number> Default value of the slider.
5.) <Color3> Color of the slider.
6.) <Function> Function / Callback of the slider.
```

## Creating Textboxes
```lua
local Textbox = Section:CreateTextbox('Textbox', 'Input', function(Value)
    print(Value)
end)
```
```text
1.) <String> Name of the textbox.
2.) <String> placeholder of the textbox.
3.) <Function> Function / Callback of the textbox.
```

## Creating Keybinds
```lua
local Keybind = Section:CreateKeybind('Keybind', 'F', function()
    print('Key Pressed')
end)
```
```text
1.) <String> Name of the keybind.
2.) <String> Default KeyCode, find all KeyCodes here: https://developer.roblox.com/en-us/api-reference/enum/KeyCode
3.) <Function> Function / Callback of the keybind.
```

## Creating Toggles
```lua
local Toggle = Section:CreateToggle('Toggle', true, Color3.fromRGB(0, 125, 255), 0.25, function(Value)
    print(Value)
end)
```
```text
1.) <String> Name of the toggle.
2.) <Bool> Default value of the toggle.
3.) <Color3> Color of the toggle.
4.) <Number> Debounce of the toggle.
5.) <Function> Function / Callback of the toggle.
```

## Creating Dropdowns
```lua
local Dropdown = Section:CreateDropdown('Dropdown', {'1', '2', '3', '4', '5'}, '1', 0.25, function(Value)
    print(Value)
end)
```
```text
1.) <String> Name of the dropdown.
2.) <Table> Dropdown options.
3.) <Any> Default Option of the dropdown, put it as nil for none. if it is not nil, it should be the same type as the item in the table, for example, the dropdown table is: {'1'}, so the Default should be '1', both strings.
4.) <Number> Debounce of the dropdown opening and closing.
5.) <Function> Function / Callback of the dropdown.
```

## Updating Dropdowns
```lua
Dropdown:UpdateDropdown({'1', '2', '2'})
```
```text
1.) <Table> New list of dropdown options.
```

## Creating Colorpickers
```lua
local Colorpicker = Section:CreateColorpicker('Colorpicker', Color3.fromRGB(0, 125, 255), 0.25, function(Value)
    print(Value)
end)
```
```text
1.) <String> Name of the colorpicker.
2.) <Color3> Default color of the colorpicker.
3.) <Number> Debounce of the colorpicker opening and closing.
4.) <Function> Function / Callback of the colorpicker.
```

## Creating Images
```lua
local Image = Section:CreateImage('Name', 'rbxassetid://10618928818', UDim2.new(0, 200, 0, 200))
```
```text
Show an image.
1.) <String> Name of the Image.
2.) <String> Asset ID, Upload image at https://www.roblox.com/develop?View=13, Go in roblox studio, toolbox and go to my images and copy the asset id of the image you uploaded.
3.) <UDim2> The size that the image should be.
```

## Updating Images
```lua
Image:UpdateImage('rbxassetid://10580575081', UDim2.new(0, 200, 0, 200))
```
```text
1.) <String> New Asset ID, Upload image at https://www.roblox.com/develop?View=13, Go in roblox studio, toolbox and go to my images and copy the asset id of the image you uploaded.
2.) <UDim2> The size that the image should be.
```

## Creating Notifications
Creates a Notification on the side of the screen, with different types.
```lua
Library:CreateNotification('Notification Title', 'Notification Text', 5)
```
```text
1.) <String> Title of the notification.
2.) <String> The text of the notification.
3.) <Number> The time the notification is on-screen for.
```

## Creating Prompts
Creates a Notification on the inside of the UI, with different types.

# Just Text
```lua
Library:CreatePrompt('Text', 'Prompt Title', 'Prompt Text', 'Alright')
```
```text
1.) <String> The type of prompt, 'Text', for just text and no callbacks.
2.) <String> The title of the prompt.
3.) <String> The text of the prompt.
4.) <String> The name of the prompt button, button has no callback.
```

# One Button
```lua
Library:CreatePrompt('OneButton', 'Prompt Title', 'Prompt Text', {
    'Alright',
    function()
        print('Prompt Button Pressed')
    end
})
```
```text
1.) <String> The type of prompt, 'OneButton', for text and one button with a callback.
2.) <String> The title of the prompt.
3.) <String> The text of the prompt.
4.) <Table> {
    1.) <String> The name of the button.
    2.) <Function> The callback of the button.
}
```

# Two Buttons
```lua
local TwoButtonPromptButton = UIFunctions:CreateButton('Create Two Button Prompt', function()
    Library:CreatePrompt('TwoButton', 'Prompt Title', 'Prompt Text', {
        'Button 1',
        function()
            print('Button 1')
        end,
        'Button 2',
        function()
            print('Button 2')
        end
    })
end)
```
```text
1.) <String> The type of prompt, 'TwoButton', for text and two buttons with different callbacks.
2.) <String> The title of the prompt.
3.) <String> The text of the prompt.
4.) <Table> {
    1.) <String> The name of the first button.
    2.) <Function> The callback of the first button.
    3.) <String> The name of the second button.
    4.) <Function> The callback of the second button.
}
```

## Update UI Transparency
```lua
Library:SetTransparency(0.5, true)
```
```text
Updates the background transparency of all the Elements in the UI.
1.) <Number> The new background transparency of the UI.
2.) <Bool> If true, the background transparency of notifications will be changed, if false, the won't.
```

## Config System
For a full example, look in Example.lua

## Creating / Saving Configs
```lua
Library:SaveConfig('Config')
```
```text
1.) <String> The name of the config, if there is no config with the name, it will create one, if one with the name already exists, it will overwrite it.
```

## Getting All Configs
```lua
Library:GetConfigs()
```

## Deleting Configs
```lua
Library:DeleteConfig('Config')
```
```text
1.) <String> The name of the config to delete.
```

## Loading Configs
```lua
Library:LoadConfig('Config')
```
```text
1.) <String> The name of the config to load.
```

## Themes

## Changing Themes
```lua
Library:ChangeTheme('Default')
```
```text
1.) <String or Table> The name of the theme to change to or a custom theme.
```

## Getting All Themes
```lua
Library:GetThemes()
```

## Changing Theme Colors
If you want to make a custom theme from inside the UI, add this code in your UI in a section.
```lua
for Index, CurrentColor in next, Library:ReturnTheme() do
    ColorSection:CreateColorpicker(Index, CurrentColor, 0.25, function(Color)
        Library:ChangeColor(Index, Color)
    end, {true})
end
```
