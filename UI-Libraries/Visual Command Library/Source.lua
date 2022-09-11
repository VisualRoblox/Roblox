-- // Services
local CoreGui = game:GetService('CoreGui')
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local TextService = game:GetService('TextService')

-- // Variables
local Library = {}
local Utility = {}
local Config = {}
local ConfigUpdates = {}

-- // Utility Functions
do
    function Utility:Log(Type, Message)
        Type = Type:lower()
        if Type == 'error' then
            error('[ Visual ] Error: ' .. Message)
        elseif Type == 'log' then
            print('[ Visual ] ' .. Message)
        elseif Type == 'warn' then
            warn('[ Visual ] Warning: ' .. Message)
        end
    end

    function Utility:HasProperty(Instance, Property)
        local Success = pcall(function()
            return Instance[Property]
        end)
        
        return Success and not Instance:FindFirstChild(Property)
    end

    function Utility:Tween(Instance, Properties, Duration, ...)
        local TweenInfo = TweenInfo.new(Duration, ...)
        TweenService:Create(Instance, TweenInfo, Properties):Play()
    end

    function Utility:Create(InstanceName, Properties, Children)
        local Object = Instance.new(InstanceName)
        local Properties = Properties or {}
        local Children = Children or {}
        
        for Index, Property in next, Properties do
            Object[Index] = Property
        end
    
        for _, Child in next, Children do
            Child.Parent = Object
        end

        return Object
    end

    function Utility:Lighten(Color)
        local H, S, V = Color:ToHSV()

        V = math.clamp(V + 0.03, 0, 1)

        return Color3.fromHSV(H, S, V)
    end

    function Utility:GetProperty(Level, Name, Properties)
        local AllProperties = {
            Window = {
                Name = {
                    'Name',
                    'name'
                },
                IntroText = {
                    'IntroText',
                    'introText',
                    'introtext',
                    'Introtext'
                },
                IntroIcon = {
                    'IntroIcon',
                    'introIcon',
                    'introicon',
                    'Introicon'
                },
                ConfigFolder = {
                    'ConfigFolder',
                    'configFolder',
                    'configfolder',
                    'Configfolder'
                },
                Theme = {
                    'Theme',
                    'theme'
                },
                Position = {
                    'Position',
                    'position'
                },
                BlurWhenVisible = {
                    'blurwhenvisible',
                    'blurwhenVisible',
                    'blurWhenvisible',
                    'blurWhenVisible',
                    'Blurwhenvisible',
                    'BlurwhenVisible',
                    'BlurWhenvisible',
                    'BlurWhenVisible'
                },
                Draggable = {
                    'Draggable',
                    'draggable'
                },
                DefaultVisibility = {
                    'defaultvisibility',
                    'defaultVisibility',
                    'Defaultvisibility',
                    'DefaultVisibility'
                },
                ToggleKey = {
                    'ToggleKey',
                    'toggleKey',
                    'togglekey',
                    'Togglekey'
                },
                Prefix = {
                    'Prefix',
                    'prefix'
                }
            }
        }

        local PossibleNames = AllProperties[Level][Name]

        for _, Name in next, PossibleNames do
            if Properties[Name] then
                return Properties[Name]
            end
        end
    end

    function Utility:Toggle()
        -- // 
    end

    function Utility:Destroy()
        -- // 
    end
end

-- // Library Defaults
Library.Transparency = 0
Library.Themes = {}
Library.Toggled = false

-- // CreateWindow - Name, IntroText, IntroIcon, ConfigFolder, Theme, Position, BlurWhenVisible, Draggable, DefaultVisibility, ToggleKey, Prefix
function Library:CreateWindow(Properties)
    local Name = Utility:GetProperty('Window', 'Name', Properties) or 'Visual Command Library'
    local IntroText = Utility:GetProperty('Window', 'IntroText', Properties) or 'Visual Command Library'
    local IntroIcon = Utility:GetProperty('Window', 'IntroIcon', Properties) or 'rbxassetid://10618644218'
    local ConfigFolder = Utility:GetProperty('Window', 'ConfigFolder', Properties) or 'Visual Command Library Configs'
    local Theme = Utility:GetProperty('Window', 'Theme', Properties) or Library.Themes.Default
    local Position = string.lower(Utility:GetProperty('Window', 'Position', Properties)) or 'top'
    local BlurWhenVisible = Utility:GetProperty('Window', 'BlurWhenVisible', Properties) or true
    local Draggable = Utility:GetProperty('Window', 'Draggable', Properties) or false
    local DefaultVisibility = Utility:GetProperty('Window', 'DefaultVisibility', Properties) or false
    local ToggleKey = Utility:GetProperty('Window', 'ToggleKey', Properties) or 'RightCtrl'
    local Prefix = Utility:GetProperty('Window', 'Prefix', Properties) or '.'
end

Library:CreateWindow({Name = 'x'})