-- // Aries UI Library - Example Script
-- // Load the library
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/YourGitHub/Aries/main/Source.lua'))()

-- // Create Window
local Window = Library:CreateWindow({
    Name               = 'My Hub',
    IntroText          = 'My Hub',
    IntroIcon          = 'rbxassetid://10618644218',
    IntroBlur          = true,
    IntroBlurIntensity = 15,
    Theme              = Library.Themes.Dark   -- Dark | Light | Ocean | custom table
})

-- ///////////////////////////////////////////////////////////
-- // TAB 1 - Main
-- ///////////////////////////////////////////////////////////
local MainTab = Window:CreateTab('Main', 'rbxassetid://3926305904')

local CombatSection = MainTab:CreateSection('Combat')

local SilentAimToggle = CombatSection:CreateToggle('Silent Aim', false, function(Value)
    print('Silent Aim:', Value)
end)

local FovSlider = CombatSection:CreateSlider('FOV', 0, 500, 120, function(Value)
    print('FOV:', Value)
end)

local TeamCheckToggle = CombatSection:CreateToggle('Team Check', true, function(Value)
    print('Team Check:', Value)
end)

local AimPartDropdown = CombatSection:CreateDropdown('Aim Part', {
    'Head', 'Torso', 'HumanoidRootPart', 'UpperTorso', 'LowerTorso'
}, 'Head', function(Value)
    print('Aim Part:', Value)
end)

local VisualsSection = MainTab:CreateSection('Visuals')

local ESPToggle = VisualsSection:CreateToggle('ESP', false, function(Value)
    print('ESP:', Value)
end)

local ChamsToggle = VisualsSection:CreateToggle('Chams', false, function(Value)
    print('Chams:', Value)
end)

local ESPColorPicker = VisualsSection:CreateColorpicker('ESP Color', Color3.fromRGB(255, 0, 0), function(Color)
    print('ESP Color:', Color)
end)

local TracerToggle = VisualsSection:CreateToggle('Tracers', false, function(Value)
    print('Tracers:', Value)
end)

-- ///////////////////////////////////////////////////////////
-- // TAB 2 - Player
-- ///////////////////////////////////////////////////////////
local PlayerTab = Window:CreateTab('Player', 'rbxassetid://3926307438')

local MovementSection = PlayerTab:CreateSection('Movement')

local SpeedSlider = MovementSection:CreateSlider('WalkSpeed', 16, 250, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)

local JumpSlider = MovementSection:CreateSlider('JumpPower', 50, 500, 50, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
end)

local FlyToggle = MovementSection:CreateToggle('Fly', false, function(Value)
    print('Fly:', Value)
end)

local FlyKeybind = MovementSection:CreateKeybind('Fly Keybind', 'F', function()
    print('Fly toggled via keybind!')
    FlyToggle:Set(not FlyToggle:Get())
end)

local AppearanceSection = PlayerTab:CreateSection('Appearance')

local BodyColorPicker = AppearanceSection:CreateColorpicker('Body Color', Color3.fromRGB(255, 200, 150), function(Color)
    print('Body Color:', Color)
end)

local NoclipToggle = AppearanceSection:CreateToggle('Noclip', false, function(Value)
    print('Noclip:', Value)
end)

-- ///////////////////////////////////////////////////////////
-- // TAB 3 - Misc
-- ///////////////////////////////////////////////////////////
local MiscTab = Window:CreateTab('Misc', 'rbxassetid://3926305904')

local UISection = MiscTab:CreateSection('UI Functions')

-- Notification button examples
UISection:CreateButton('Info Notification', function()
    Window:Notify('Info', 'This is an info notification!', 4, 'Info')
end)

UISection:CreateButton('Success Notification', function()
    Window:Notify('Success', 'Operation completed successfully.', 4, 'Success')
end)

UISection:CreateButton('Warning Notification', function()
    Window:Notify('Warning', 'Something might be wrong...', 4, 'Warning')
end)

UISection:CreateButton('Error Notification', function()
    Window:Notify('Error', 'An error has occurred!', 4, 'Error')
end)

UISection:CreateSeparator()

local ToggleKeybind = UISection:CreateKeybind('Toggle UI', 'RightControl', function()
    Window:Toggle()
end)

UISection:CreateButton('Destroy UI', function()
    Library:Destroy()
end)

-- Label / Paragraph
local InfoSection = MiscTab:CreateSection('Info')

local StatusLabel = InfoSection:CreateLabel('Status: Running')

InfoSection:CreateParagraph('About', 'This hub was built using the Aries UI Library. Visit GitHub for the latest source.')

local StatusTextbox = InfoSection:CreateTextbox('Set Status', 'Type status here...', function(Value)
    StatusLabel:Set('Status: ' .. Value)
end)

-- Theme section
local ThemeSection = MiscTab:CreateSection('Themes')

ThemeSection:CreateDropdown('Select Theme', {'Dark', 'Light', 'Ocean'}, 'Dark', function(Value)
    Window:ChangeTheme(Value)
end)

-- ///////////////////////////////////////////////////////////
-- // Startup notification
-- ///////////////////////////////////////////////////////////
Window:Notify('Aries UI Library', 'Hub loaded successfully!', 5, 'Success')
