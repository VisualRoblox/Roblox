local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/VisualRoblox/Roblox/main/UI-Libraries/Visual%20UI%20Library/Source.lua'))()

local Window = Library:CreateWindow('Hub Name', 'Game Name', 'Visual UI Library', 'rbxassetid://10618928818', false, 'VisualUIConfigs', 'Default')

local Tab = Window:CreateTab('Tab', true, 'rbxassetid://3926305904', Vector2.new(524, 44), Vector2.new(36, 36))

local Section = Tab:CreateSection('Section')

local Label = Section:CreateLabel('Label')

local Paragraph = Section:CreateParagraph('Paragraph', 'Content')

local Button = Section:CreateButton('Button', function()
    print('Button Pressed')
end)

local Slider = Section:CreateSlider('Slider', 1, 100, 50, Color3.fromRGB(0, 125, 255), function(Value)
    print(Value)
end)

local Textbox = Section:CreateTextbox('Textbox', 'Input', function(Value)
    print(Value)
end)

local Keybind = Section:CreateKeybind('Keybind', 'F', function()
    print('Key Pressed')
end)

local Toggle = Section:CreateToggle('Toggle', true, Color3.fromRGB(0, 125, 255), 0.25, function(Value)
    print(Value)
end)

local Dropdown = Section:CreateDropdown('Dropdown', {'1', '2', '3', '4', '5'}, '1', 0.25, function(Value)
    print(Value)
end)

local Colorpicker = Section:CreateColorpicker('Colorpicker', Color3.fromRGB(0, 125, 255), 0.25, function(Value)
    print(Value)
end)

local Image = Section:CreateImage('Image', 'rbxassetid://10618928818', UDim2.new(0, 200, 0, 200))
    
local UpdateSection = Tab:CreateSection('Update Functions')

local LabelBox = UpdateSection:CreateTextbox('Update Label', 'New Text', function(Value)
    Label:UpdateLabel(Value, true)
end)
    
local ParagraphBox = UpdateSection:CreateTextbox('Update Paragraph', 'New Text', function(Value)
    Paragraph:UpdateParagraph('Paragraph', Value)
end)
    
local UpdateDropdown1 = UpdateSection:CreateButton('Update Dropdown 1', function()
    Dropdown:UpdateDropdown({'1', '2', '3'})
end)
    
local UpdateDropdown2 = UpdateSection:CreateButton('Update Dropdown 2', function()
    Dropdown:UpdateDropdown({'1', '2', '3', '4', '5', '6'})
end)

local UpdateImage = UpdateSection:CreateButton('Update Image', function()
    Image:UpdateImage('rbxassetid://10580575081', UDim2.new(0, 200, 0, 200))
end)

local LibraryFunctions = Window:CreateTab('Library Functions', false, 'rbxassetid://3926305904', Vector2.new(524, 44), Vector2.new(36, 36))

local UIFunctions = LibraryFunctions:CreateSection('UI Functions')

local DestroyButton = UIFunctions:CreateButton('Destroy UI', function()
    Library:DestroyUI()
end)

local ToggleKeybind = UIFunctions:CreateKeybind('Toggle UI', 'E', function()
    Library:ToggleUI()
end)

local TextboxKeybind = UIFunctions:CreateTextbox('Notification', 'Text', function(Value)
    Library:CreateNotification('Notification', Value, 5)
end)

local TransparencySlider = UIFunctions:CreateSlider('Transparency', 0, 100, 0, Color3.fromRGB(0, 125, 255), function(Value)
    Library:SetTransparency(Value / 100, true)
end)

local TextPromptButton = UIFunctions:CreateButton('Create Text Prompt', function()
    Library:CreatePrompt('Text', 'Prompt Title', 'Prompt Text', 'Alright')
end)

local OneButtonPromptButton = UIFunctions:CreateButton('Create One Button Prompt', function()
    Library:CreatePrompt('OneButton', 'Prompt Title', 'Prompt Text', {
        'Alright',
        function()
            print('Prompt Button Pressed')
        end
    })
end)

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

local ConfigSection = LibraryFunctions:CreateSection('Config')

local ConfigNameString = ''
local ConfigName = ConfigSection:CreateTextbox('Config Name', 'Input', function(Value)
    ConfigNameString = Value
end)

local SaveConfigButton = ConfigSection:CreateButton('Save Config', function()
    Library:SaveConfig(ConfigNameString)
end)

local SelectedConfig = ''
local ConfigsDropdown = ConfigSection:CreateDropdown('Configs', Library:GetConfigs(), nil, 0.25, function(Value)
    SelectedConfig = Value
end)

local DeleteConfigButton = ConfigSection:CreateButton('Delete Config', function()
    Library:DeleteConfig(SelectedConfig)
end)

local LoadConfigButton = ConfigSection:CreateButton('Load Config', function()
    Library:LoadConfig(SelectedConfig)
end)

local RefreshConfigsButton = ConfigSection:CreateButton('Refresh', function()
    ConfigsDropdown:UpdateDropdown(Library:GetConfigs())
end)

local ThemesSection = LibraryFunctions:CreateSection('Themes')

local ThemesDropdown = ThemesSection:CreateDropdown('Themes', Library:GetThemes(), nil, 0.25, function(Value)
    Library:ChangeTheme(Value)
end)

local ColorSection = LibraryFunctions:CreateSection('Custom Colors')

for Index, CurrentColor in next, Library:ReturnTheme() do
    ColorSection:CreateColorpicker(Index, CurrentColor, 0.25, function(Color)
        Library:ChangeColor(Index, Color)
    end, {true})
end
