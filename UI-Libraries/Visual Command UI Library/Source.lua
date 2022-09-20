-- // Services
local CoreGui = game:GetService('CoreGui')
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local TextService = game:GetService('TextService')
local Players = game:GetService('Players')
local Workspace = game:GetService('Workspace')
local RunService = game:GetService('RunService')
local Lighting = game:GetService('Lighting')

-- // Variables
local Library = {}
local Utility = {}
local Commands = {}
local Config = {}
local ConfigUpdates = {}
local Dragging = false
local BreakLoops = false
local ChangeTheme = false

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

    function Utility:Darken(Color)
        local H, S, V = Color:ToHSV()

        V = math.clamp(V - 0.35, 0, 1)

        return Color3.fromHSV(H, S, V)
    end

    function Utility:EnableDragging(Frame, Parent)
        local DraggingInput, StartPosition
        local DragStart = Vector3.new(0,0,0)
        
        local Main = CoreGui:FindFirstChild('Visual Command UI Library | .gg/puxxCphTnK').Main
        
        local function Update(Input)
            local Delta = Input.Position - DragStart
            local Camera = Workspace.CurrentCamera

            if StartPosition.X.Offset + Delta.X <= -750 and -Camera.ViewportSize.X <= StartPosition.X.Offset + Delta.X then
                local Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, Parent.Position.Y.Scale, Parent.Position.Y.Offset)
                Utility:Tween(Parent, {Position = Position}, 0.25)
            elseif StartPosition.X.Offset + Delta.X > -500 then
                local Position = UDim2.new(1, -250, Parent.Position.Y.Scale, Parent.Position.Y.Offset)
                Utility:Tween(Parent, {Position = Position}, 0.25)
            elseif -Camera.ViewportSize.X > StartPosition.X.Offset + Delta.X then
                local Position = UDim2.new(1, -Camera.ViewportSize.X, Parent.Position.Y.Scale, Parent.Position.Y.Offset)
                Utility:Tween(Parent, {Position = Position}, 0.25)
            end
        end
        
        Frame.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                DragStart = Input.Position
                StartPosition = Parent.Position
    
                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)

        Frame.InputChanged:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement then
                DraggingInput = Input
            end
        end)

        UserInputService.InputChanged:Connect(function(Input)
            if Input == DraggingInput and Dragging then
                Update(Input)
            end
        end)
    end

    function Utility:StringToKeyCode(String)
        local Byte = string.byte(String)

        for _, KeyCode in next, Enum.KeyCode:GetEnumItems() do
            if KeyCode.Value == Byte then
                return KeyCode
            end
        end
    end

    function Utility:KeyCodeToString(KeyCode)
        if KeyCode.Value < 127 and KeyCode.Value > 33 then
            return string.char(KeyCode.Value)
        else
            return KeyCode.Name
        end
    end

    function Utility:GetProperty(Level, Name, Properties)
        local AllProperties = {
            Window = {
                Name = {
                    'Name',
                    'NAME',
                    'name'
                },
                IntroText = {
                    'IntroText',
                    'INTROTEXT',
                    'introText',
                    'introtext',
                    'Introtext'
                },
                IntroIcon = {
                    'IntroIcon',
                    'INTROICON',
                    'introIcon',
                    'introicon',
                    'Introicon'
                },
                IntroBlur = {
                    'IntroBlur',
                    'Introblur',
                    'INTROBLUR',
                    'introBlur',
                    'introblur',
                },
                IntroBlurIntensity = {
                    'introblurintensity',
                    'Introblurintensity',
                    'INTROBLURINTENSITY',
                    'introBlurintensity',
                    'IntroBlurintensity',
                    'introblurIntensity',
                    'IntroblurIntensity',
                    'introBlurIntensity',
                    'IntroBlurIntensity'
                },
                Theme = {
                    'Theme',
                    'THEME',
                    'theme'
                },
                Position = {
                    'Position',
                    'position',
                    'POSITION'
                },
                Draggable = {
                    'Draggable',
                    'DRAGGABLE',
                    'draggable'
                },
                Prefix = {
                    'Prefix',
                    'PREFIX',
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

    function Utility:Destroy()
        BreakAllLoops = true

        for _, UI in next, CoreGui:GetChildren() do
            if UI.Name == 'Visual Command UI Library | .gg/puxxCphTnK' then
                for _, Item in next, UI.Main:GetChildren() do
                    if Item.Name ~= 'MainCorner' and Item.Name ~= 'MainStroke' then
                        Item:Destroy()
                    end
                end
    
                Utility:Tween(UI.Main, {Size = UDim2.new(0, 500, 0, 0)}, 0.25)
                Utility:Tween(UI.ToolTip, {BackgroundTransparency = 1}, 0.25)

                task.wait(0.25)

                UI:Destroy()
            end
        end
    end
end

-- // Library Defaults
Library.Transparency = 0
Library.Themes = {
    ['dark'] = {
        BackgroundColor = Color3.fromRGB(40, 40, 40),
        SecondaryColor = Color3.fromRGB(50, 50, 50),
        AccentColor = Color3.fromRGB(100, 100, 100),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(175, 175, 175)
    },
    ['light'] = {
        BackgroundColor = Color3.fromRGB(255, 255, 255),
        SecondaryColor = Color3.fromRGB(225, 225, 225),
        AccentColor = Color3.fromRGB(125, 125, 125),
        PrimaryTextColor = Color3.fromRGB(0, 0, 0),
        SecondaryTextColor = Color3.fromRGB(75, 75, 75)
    },
    ['discord'] = {
        BackgroundColor = Color3.fromRGB(54, 57, 63),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(110, 110, 115),
        AccentColor = Color3.fromRGB(75, 75, 75),
        SecondaryColor = Color3.fromRGB(59, 65, 72)
    },
    ['redandblack'] = {
        BackgroundColor = Color3.fromRGB(0, 0, 0),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(135, 135, 135),
        AccentColor = Color3.fromRGB(255, 0, 0),
        SecondaryColor = Color3.fromRGB(50, 50, 50)
    },
    ['nordicdark'] = {
        BackgroundColor = Color3.fromRGB(25, 30, 35),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(135, 135, 135),
        AccentColor = Color3.fromRGB(50, 60, 70),
        SecondaryColor = Color3.fromRGB(50, 55, 60)
    },
    ['nordiclight'] = {
        BackgroundColor = Color3.fromRGB(67, 75, 94),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(135, 135, 135),
        AccentColor = Color3.fromRGB(92, 97, 116),
        SecondaryColor = Color3.fromRGB(82, 87, 106)
    },
    ['purple'] = {
        BackgroundColor = Color3.fromRGB(30, 30, 45),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(135, 135, 135),
        AccentColor = Color3.fromRGB(60, 60, 80),
        SecondaryColor = Color3.fromRGB(60, 60, 80)
    },
    ['sentinel'] = {
        BackgroundColor = Color3.fromRGB(30, 30, 30),
        PrimaryTextColor = Color3.fromRGB(130, 190, 130),
        SecondaryTextColor = Color3.fromRGB(230, 35, 70),
        AccentColor = Color3.fromRGB(50, 50, 50),
        SecondaryColor = Color3.fromRGB(35, 35, 35)
    },
    ['synapsex'] = {
        BackgroundColor = Color3.fromRGB(50, 50, 50),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(125, 125, 125),
        AccentColor = Color3.fromRGB(70, 70, 70),
        SecondaryColor = Color3.fromRGB(65, 65, 65)
    },
    ['krnl'] = {
        BackgroundColor = Color3.fromRGB(40, 40, 40),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(125, 125, 125),
        AccentColor = Color3.fromRGB(60, 60, 60),
        SecondaryColor = Color3.fromRGB(40, 40, 40)
    },
    ['scriptware'] = {
        BackgroundColor = Color3.fromRGB(30, 30, 30),
        PrimaryTextColor = Color3.fromRGB(0, 125, 255),
        SecondaryTextColor = Color3.fromRGB(255, 255, 255),
        AccentColor = Color3.fromRGB(0, 125, 255),
        SecondaryColor = Color3.fromRGB(45, 45, 45)
    },
    ['kiriot'] = {
        BackgroundColor = Color3.fromRGB(35, 35, 35),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(135, 135, 135),
        AccentColor = Color3.fromRGB(255, 170, 60),
        SecondaryColor = Color3.fromRGB(50, 50, 50)
    }
}
Library.Prefix = Utility:StringToKeyCode(';')
Library.Theme = nil

-- // CreateWindow - Name, IntroText, IntroIcon, IntroBlur, IntroBlurIntensity, Theme, Position, Draggable, Prefix
function Library:CreateWindow(Properties)
    -- // Properties
    local Name = Utility:GetProperty('Window', 'Name', Properties) or 'Visual Command UI Library'
    local IntroText = Utility:GetProperty('Window', 'IntroText', Properties) or 'Visual Command UI Library'
    local IntroIcon = Utility:GetProperty('Window', 'IntroIcon', Properties) or 'rbxassetid://10618644218'
    local IntroBlur = Utility:GetProperty('Window', 'IntroBlur', Properties) or false
    local IntroBlurIntensity = Utility:GetProperty('Window', 'IntroBlurIntensity', Properties) or 15
    local Theme = Utility:GetProperty('Window', 'Theme', Properties) or Library.Themes.dark
    local Position = string.lower(Utility:GetProperty('Window', 'Position', Properties)) or 'top'
    local Draggable = Utility:GetProperty('Window', 'Draggable', Properties) or false
    local Prefix = Utility:StringToKeyCode(Utility:GetProperty('Window', 'Prefix', Properties)) or Utility:StringToKeyCode(';')

    -- // Set Library Properties
    Library.Prefix = Prefix
    Library.Theme = Theme

    -- // Custom Theme
    if type(Theme) == 'table' then
        Library.Themes['custom'] = Theme
    end

    -- // Destroy Old UI
    Utility:Destroy()

    -- // Create Elements
    local Container = Utility:Create('ScreenGui', {
        Parent = CoreGui,
        Name = 'Visual Command UI Library | .gg/puxxCphTnK',
        ResetOnSpawn = false
    }, {
        Utility:Create('Frame', {
            Name = 'Main',
            BackgroundColor3 = Theme.BackgroundColor,
            BorderSizePixel = 0,
            BackgroundTransparency = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 0, 0, 0)
        }, {
            Utility:Create('UIStroke', {
                Name = 'MainStroke',
                ApplyStrokeMode = 'Contextual',
                Color = Theme.AccentColor,
                LineJoinMode = 'Round',
                Thickness = 1
            }),
            Utility:Create('UICorner', {
                CornerRadius = UDim.new(0, 5),
                Name = 'MainCorner'
            }),
            Utility:Create('TextLabel', {
                Name = 'IntroText',
                BackgroundColor3 = Theme.BackgroundColor,
                BackgroundTransparency = 1,
                TextTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, -30),
                BorderSizePixel = 0,
                Size = UDim2.new(0, 170, 0, 20),
                Font = Enum.Font.Gotham,
                Text = IntroText,
                TextColor3 = Theme.PrimaryTextColor,
                TextSize = 18,
                ZIndex = 2,
                TextXAlignment = Enum.TextXAlignment.Center
            }),
            Utility:Create('ImageLabel', {
                Name = 'IntroImage',
                BackgroundColor3 = Theme.BackgroundColor,
                BackgroundTransparency = 1,
                ImageTransparency = 1,
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 20),
                ZIndex = 3,
                Size = UDim2.new(0, 80, 0, 80),
                Image = IntroIcon,
                ScaleType = Enum.ScaleType.Fit
            })
        }),
    })

    -- // Intro Blur

    -- // Variables
    local Main = Container.Main
    local MainStroke = Main.MainStroke
    
    -- // Dragging
    if Draggable then
        Utility:EnableDragging(Main, Main)
    end

    -- // Intro
    MainStroke.Thickness = 0
    
    if IntroBlur == true then
        Utility:Create('BlurEffect', {
            Name = 'VisualIntroBlur',
            Parent = Lighting,
            Size = 0
        })

        local Blur = Lighting.VisualIntroBlur

        Utility:Tween(Blur, {Size = IntroBlurIntensity}, 1)

        task.wait(1)
    end

    Utility:Tween(Main, {BackgroundTransparency = 1}, 0)

    Utility:Tween(Main, {Size = UDim2.new(0, 1000, 0, 500)}, 0.25)
    
    task.wait(0.5)

    Utility:Tween(Main['IntroText'], {TextTransparency = 0}, 0.25)

    task.wait(0.5)

    Utility:Tween(Main['IntroImage'], {ImageTransparency = 0}, 0.25)

    task.wait(3)

    Utility:Tween(Main['IntroText'], {TextTransparency = 1}, 0.25)

    task.wait(0.5)

    Utility:Tween(Main['IntroImage'], {ImageTransparency = 1}, 0.25)

    task.wait(0.5)

    if IntroBlur == true then
        Utility:Tween(Lighting.VisualIntroBlur, {Size = 0}, 1)

        task.wait(1)
    end

    Main['IntroText']:Destroy()
    Main['IntroImage']:Destroy()

    if IntroBlur == true then
        Lighting.VisualIntroBlur:Destroy()
    end

    Utility:Tween(Main, {Size = UDim2.new(0, 500, 0, 65)}, 0.25)
    Utility:Tween(Main, {BackgroundTransparency = 0}, 0.25)
    MainStroke.Thickness = 1

    task.wait(0.5)

    -- // Position
    if Position == 'top' then
        Main.AnchorPoint = Vector2.new(0.5, 0)
        Utility:Tween(Main, {Position = UDim2.new(0.5, 0, 0, -72)}, 0.25)
    elseif Position == 'topleft' then
        Main.AnchorPoint = Vector2.new(0, 0)
        Utility:Tween(Main, {Position = UDim2.new(0, 0, 0, -72)}, 0.25)
    elseif Position == 'topright' then
        Main.AnchorPoint = Vector2.new(1, 0)
        Utility:Tween(Main, {Position = UDim2.new(1, 0, 0, -72)}, 0.25)
    elseif Position == 'bottomleft' then
        Main.AnchorPoint = Vector2.new(0, 1)
        Utility:Tween(Main, {Position = UDim2.new(0, 0, 1, 36)}, 0.25)
    elseif Position == 'bottom' then
        Main.AnchorPoint = Vector2.new(0.5, 1)
        Utility:Tween(Main, {Position = UDim2.new(0.5, 0, 1, 36)}, 0.25)
    elseif Position == 'bottomright' then
        Main.AnchorPoint = Vector2.new(1, 1)
        Utility:Tween(Main, {Position = UDim2.new(1, 0, 1, 36)}, 0.25)
    end

    -- // Fillers And Lines
    if string.find(Position, 'top') then
        Utility:Create('Frame', {
            Parent = Main,
            BackgroundColor3 = Theme.BackgroundColor,
            BorderSizePixel = 0,
            Name = 'Filler1',
            BackgroundTransparency = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0, 5, 0, 5)
        })
        Utility:Create('Frame', {
            Parent = Main,
            BackgroundColor3 = Theme.BackgroundColor,
            BorderSizePixel = 0,
            Name = 'Filler2',
            BackgroundTransparency = 0,
            Position = UDim2.new(0, 495, 0, 0),
            Size = UDim2.new(0, 5, 0, 5)
        })
        Utility:Create('Frame', {
            Parent = Main,
            BackgroundColor3 = Theme.AccentColor,
            BorderSizePixel = 0,
            Name = 'Line1',
            BackgroundTransparency = 0,
            Position = UDim2.new(0, -1, 0, 0),
            Size = UDim2.new(0, 1, 0, 10)
        })
        Utility:Create('Frame', {
            Parent = Main,
            BackgroundColor3 = Theme.AccentColor,
            BorderSizePixel = 0,
            Name = 'Line2',
            BackgroundTransparency = 0,
            Position = UDim2.new(0, 500, 0, 0),
            Size = UDim2.new(0, 1, 0, 10)
        })
    else
        Utility:Create('Frame', {
            Parent = Main,
            BackgroundColor3 = Theme.BackgroundColor,
            BorderSizePixel = 0,
            BackgroundTransparency = 0,
            Name = 'Filler1',
            Position = UDim2.new(0, 0, 0, 60),
            Size = UDim2.new(0, 5, 0, 5)
        })
        Utility:Create('Frame', {
            Parent = Main,
            BackgroundColor3 = Theme.BackgroundColor,
            BorderSizePixel = 0,
            BackgroundTransparency = 0,
            Name = 'Filler2',
            Position = UDim2.new(0, 495, 0, 60),
            Size = UDim2.new(0, 5, 0, 5)
        })
        Utility:Create('Frame', {
            Parent = Main,
            BackgroundColor3 = Theme.AccentColor,
            BorderSizePixel = 0,
            BackgroundTransparency = 0,
            Name = 'Line1',
            Position = UDim2.new(0, -1, 0, 60),
            Size = UDim2.new(0, 1, 0, 10)
        })
        Utility:Create('Frame', {
            Parent = Main,
            BackgroundColor3 = Theme.AccentColor,
            BorderSizePixel = 0,
            BackgroundTransparency = 0,
            Name = 'Line2',
            Position = UDim2.new(0, 500, 0, 60),
            Size = UDim2.new(0, 1, 0, 10)
        })
    end

    -- // Main Elements
    if string.find(Position, 'bottom') then
        Utility:Create('TextBox', {
            Font = Enum.Font.Gotham,
            PlaceholderColor3 = Theme.SecondaryTextColor,
            PlaceholderText = 'Enter Command',
            Text = '',
            TextColor3 = Theme.PrimaryTextColor,
            TextSize = 14,
            ClearTextOnFocus = false,
            Parent = Main,
            BackgroundColor3 = Theme.SecondaryColor,
            BorderSizePixel = 0,
            TextTransparency = 0,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Visible = false,
            Name = 'CommandInput',
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -5),
            Size = UDim2.new(0, 490, 0, 30)
        }, {
            Utility:Create('UIStroke', {
                Name = 'CommandInputStroke',
                ApplyStrokeMode = 'Border',
                Color = Theme.AccentColor,
                LineJoinMode = 'Round',
                Thickness = 0
            }),
            Utility:Create('UICorner', {
                CornerRadius = UDim.new(0, 5),
                Name = 'CommandInputCorner'
            }),
            Utility:Create('UIPadding', {
                PaddingLeft = UDim.new(0, 5),
                Name = 'CommandInputPadding'
            }),
        })

        Utility:Create('TextLabel', {
            Name = 'Title',
            Parent = Main,
            BackgroundColor3 = Theme.BackgroundColor,
            BackgroundTransparency = 1,
            TextTransparency = 1,
            Position = UDim2.new(0, 0, 0, 4),
            Size = UDim2.new(0, 250, 0, 20),
            Font = Enum.Font.Gotham,
            BorderSizePixel = 0, 
            Text = Name,
            TextColor3 = Theme.PrimaryTextColor,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left
        }, {
            Utility:Create('UIPadding', {
                Name = 'TitlePadding',
                PaddingLeft = UDim.new(0, 7)
            })
        })

        Utility:Create('TextButton', {
            Name = 'CloseButton',
            Position = UDim2.new(0, 475, 0, 4),
            Size = UDim2.new(0, 20, 0, 20),
            BackgroundColor3 = Theme.BackgroundColor,
            TextColor3 = Theme.PrimaryTextColor,
            AutoButtonColor = false,
            Font = Enum.Font.Gotham,
            Parent = Main,
            TextYAlignment = Enum.TextYAlignment.Center,
            BorderSizePixel = 0,
            TextSize = 30,
            Text = '×'
        }, {
            Utility:Create('UICorner', {
                Name = 'CloseButtonCorner',
                CornerRadius = UDim.new(0, 5)
            })
        })

        Utility:Create('Frame', {
            Parent = Main,
            BackgroundColor3 = Theme.BackgroundColor,
            BorderSizePixel = 0,
            BackgroundTransparency = 0.5,
            Name = 'CommandsHolder',
            Visible = false,
            Position = UDim2.new(0, 0, 0, -305),
            Size = UDim2.new(0, 500, 0, 300)
        }, {
            Utility:Create('UIStroke', {
                Name = 'CommandsHolderStroke',
                ApplyStrokeMode = 'Contextual',
                Color = Theme.AccentColor,
                LineJoinMode = 'Round',
                Thickness = 1
            }),
            Utility:Create('UICorner', {
                CornerRadius = UDim.new(0, 5),
                Name = 'CommandsHolderCorner'
            }),
            Utility:Create('ScrollingFrame', {
                BackgroundColor3 = Theme.BackgroundColor,
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                ScrollBarThickness = 1,
                ScrollBarImageColor3 = Theme.AccentColor,
                Name = 'CommandsHolderScrolling',
                Position = UDim2.new(0, 0, 0, 5),
                Size = UDim2.new(0, 500, 0, 290)
            }, {
                Utility:Create('UIListLayout', {
                    Name = 'CommandsHolderScrollingListLayout',
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 3)
                })
            })
        })
    else
        Utility:Create('TextBox', {
            Font = Enum.Font.Gotham,
            PlaceholderColor3 = Theme.SecondaryTextColor,
            PlaceholderText = 'Enter Command',
            Text = '',
            TextColor3 = Theme.PrimaryTextColor,
            TextSize = 14,
            Parent = Main,
            BackgroundColor3 = Theme.SecondaryColor,
            BorderSizePixel = 0,
            TextTransparency = 0,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Visible = false,
            Name = 'CommandInput',
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 5),
            Size = UDim2.new(0, 490, 0, 30)
        }, {
            Utility:Create('UIStroke', {
                Name = 'CommandInputStroke',
                ApplyStrokeMode = 'Border',
                Color = Theme.AccentColor,
                LineJoinMode = 'Round',
                Thickness = 0
            }),
            Utility:Create('UICorner', {
                CornerRadius = UDim.new(0, 5),
                Name = 'CommandInputCorner'
            }),
            Utility:Create('UIPadding', {
                PaddingLeft = UDim.new(0, 5),
                Name = 'CommandInputPadding'
            }),
        })

        Utility:Create('TextLabel', {
            Name = 'Title',
            Parent = Main,
            BackgroundColor3 = Theme.BackgroundColor,
            BackgroundTransparency = 1,
            TextTransparency = 1,
            Position = UDim2.new(0, 0, 0, 40),
            Size = UDim2.new(0, 250, 0, 20),
            Font = Enum.Font.Gotham,
            BorderSizePixel = 0, 
            Text = Name,
            TextColor3 = Theme.PrimaryTextColor,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left
        }, {
            Utility:Create('UIPadding', {
                Name = 'TitlePadding',
                PaddingLeft = UDim.new(0, 7)
            })
        })

        Utility:Create('TextButton', {
            Name = 'CloseButton',
            Position = UDim2.new(0, 475, 0, 40),
            Size = UDim2.new(0, 20, 0, 20),
            BackgroundColor3 = Theme.BackgroundColor,
            TextColor3 = Theme.PrimaryTextColor,
            AutoButtonColor = false,
            Font = Enum.Font.Gotham,
            Parent = Main,
            TextYAlignment = Enum.TextYAlignment.Center,
            BorderSizePixel = 0,
            TextSize = 30,
            Text = '×'
        }, {
            Utility:Create('UICorner', {
                Name = 'CloseButtonCorner',
                CornerRadius = UDim.new(0, 5)
            }),
        })

        Utility:Create('Frame', {
            Parent = Main,
            BackgroundColor3 = Theme.BackgroundColor,
            BorderSizePixel = 0,
            Visible = false,
            BackgroundTransparency = 1,
            Name = 'CommandsHolder',
            Position = UDim2.new(0, 0, 0, 70),
            Size = UDim2.new(0, 500, 0, 300)
        }, {
            Utility:Create('UIStroke', {
                Name = 'CommandsHolderStroke',
                ApplyStrokeMode = 'Contextual',
                Color = Theme.AccentColor,
                LineJoinMode = 'Round',
                Thickness = 1
            }),
            Utility:Create('UICorner', {
                CornerRadius = UDim.new(0, 5),
                Name = 'CommandsHolderCorner'
            }),
            Utility:Create('ScrollingFrame', {
                BackgroundColor3 = Theme.BackgroundColor,
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                ScrollBarThickness = 1,
                ScrollBarImageColor3 = Theme.AccentColor,
                Name = 'CommandsHolderScrolling',
                Position = UDim2.new(0, 0, 0, 5),
                Size = UDim2.new(0, 500, 0, 290)
            }, {
                Utility:Create('UIListLayout', {
                    Name = 'CommandsHolderScrollingListLayout',
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 3)
                })
            })
        })
    end

    Utility:Create('TextLabel', {
        Name = 'ToolTip',
        Parent = Container,
        BackgroundColor3 = Theme.BackgroundColor,
        BackgroundTransparency = 0,
        TextTransparency = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        RichText = true,
        ZIndex = 100,
        Text = '',
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0, 
        TextColor3 = Theme.PrimaryTextColor,
        TextSize = 15
    }, {
        Utility:Create('UICorner', {
            Name = 'ToolTipCorner',
            CornerRadius = UDim.new(0, 5)
        }),
        Utility:Create('UIPadding', {
            Name = 'ToolTipPadding',
            PaddingLeft = UDim.new(0, 3),
            PaddingTop = UDim.new(0, 3)
        }),
        Utility:Create('UIStroke', {
            Name = 'ToolTipStroke',
            ApplyStrokeMode = 'Border',
            Color = Theme.AccentColor,
            LineJoinMode = 'Round',
            Thickness = 1
        })
    })
    
    -- // Theme Update
    task.spawn(function()
        while task.wait() do
            if ChangeTheme then
                if not BreakLoops then
                    Utility:Tween(Main, {BackgroundColor3 = Library.Theme.BackgroundColor}, 0.25)
                    Utility:Tween(Main.MainStroke, {Color = Library.Theme.AccentColor}, 0.25)   
                    Utility:Tween(Main.Filler1, {BackgroundColor3 = Library.Theme.BackgroundColor}, 0.25)
                    Utility:Tween(Main.Filler2, {BackgroundColor3 = Library.Theme.BackgroundColor}, 0.25)
                    Utility:Tween(Main.Line1, {BackgroundColor3 = Library.Theme.AccentColor}, 0.25)
                    Utility:Tween(Main.Line2, {BackgroundColor3 = Library.Theme.AccentColor}, 0.25)
                    Utility:Tween(Main.CommandInput, {BackgroundColor3 = Library.Theme.SecondaryColor}, 0.25)
                    Utility:Tween(Main.CommandInput, {TextColor3 = Library.Theme.PrimaryTextColor}, 0.25)
                    Utility:Tween(Main.CommandInput, {PlaceholderColor3 = Library.Theme.SecondaryTextColor}, 0.25)
                    Utility:Tween(Main.CommandInput.CommandInputStroke, {Color = Library.Theme.AccentColor}, 0.25)
                    Utility:Tween(Main.Title, {BackgroundColor3 = Library.Theme.BackgroundColor}, 0.25)
                    Utility:Tween(Main.Title, {TextColor3 = Library.Theme.PrimaryTextColor}, 0.25)
                    Utility:Tween(Main.CloseButton, {BackgroundColor3 = Library.Theme.BackgroundColor}, 0.25)
                    Utility:Tween(Main.CloseButton, {TextColor3 = Library.Theme.PrimaryTextColor}, 0.25)
                    Utility:Tween(Main.CommandsHolder, {BackgroundColor3 = Library.Theme.BackgroundColor}, 0.25)
                    Utility:Tween(Main.CommandsHolder.CommandsHolderScrolling, {BackgroundColor3 = Library.Theme.BackgroundColor}, 0.25)
                    Utility:Tween(Main.CommandsHolder.CommandsHolderScrolling, {ScrollBarImageColor3 = Library.Theme.AccentColor}, 0.25)
                    Utility:Tween(Main.CommandsHolder.CommandsHolderStroke, {Color = Theme.AccentColor}, 0.25)
                    Utility:Tween(Container.ToolTip, {BackgroundColor3 = Library.Theme.BackgroundColor}, 0.25)
                    Utility:Tween(Container.ToolTip, {TextColor3 = Library.Theme.PrimaryTextColor}, 0.25)
                    Utility:Tween(Container.ToolTip.ToolTipStroke, {Color = Theme.AccentColor}, 0.25)
                else
                    break
                end
            end
        end
    end)

    -- // Animate Elements
    task.wait(0.25)

    local CommandInput = Main.CommandInput
    local CommandInputStroke = CommandInput.CommandInputStroke
    local CloseButton = Main.CloseButton
    local CommandsHolder = Main.CommandsHolder
    local CommandsHolderScrolling = CommandsHolder.CommandsHolderScrolling
    local CommandsHolderScrollingListLayout = CommandsHolderScrolling.CommandsHolderScrollingListLayout

    for _, Element in next, Main:GetChildren() do
        if Element:IsA('TextBox') or Element:IsA('TextLabel') or Element:IsA('TextButton') or Element:IsA('ImageButton') then
            Element.Visible = true
            
            if Utility:HasProperty(Element, 'BackgroundTransparency') then
                Utility:Tween(Element, {BackgroundTransparency = 0}, 0.25)
            end

            if Utility:HasProperty(Element, 'TextTransparency') then
                Utility:Tween(Element, {TextTransparency = 0}, 0.25)
            end

            if Utility:HasProperty(Element, 'ImageTransparency') then
                Utility:Tween(Element, {ImageTransparency = 0}, 0.25)
            end
        end
    end

    CommandInputStroke.Thickness = 1

    CloseButton.MouseEnter:Connect(function()
        Utility:Tween(CloseButton, {TextColor3 = Utility:Darken(Theme.PrimaryTextColor)}, 0.25)
    end)

    CloseButton.MouseLeave:Connect(function()
        Utility:Tween(CloseButton, {TextColor3 = Theme.PrimaryTextColor}, 0.25)
    end)

    -- // Update Command Holder Sizes
    local function UpdateFrameSizes()
        local Count = 0

        for _, Instance in next, CommandsHolderScrolling:GetChildren() do
            if not Instance:IsA('UIListLayout') and Instance.Visible then
                Count += 1 
            end
        end

        local Size = Count * 30
        local Padding = 3 * Count

        Size += Padding - 3

        if Count == 0 then
            Utility:Tween(CommandsHolder, {Size = UDim2.new(0, 500, 0, 0)}, 0.25)
            Utility:Tween(CommandsHolderScrolling, {Size = UDim2.new(0, 500, 0, Size)}, 0.25)
            Utility:Tween(CommandsHolderScrolling, {CanvasSize = UDim2.new(0, 500, 0, Size)}, 0.25)

        elseif Count < 9 then
            Utility:Tween(CommandsHolder, {Size = UDim2.new(0, 500, 0, Size + 10)}, 0.25)
            Utility:Tween(CommandsHolderScrolling, {Size = UDim2.new(0, 500, 0, Size)}, 0.25)
            Utility:Tween(CommandsHolderScrolling, {CanvasSize = UDim2.new(0, 500, 0, Size)}, 0.25)

            if string.find(Position, 'bottom') then
                if Main.Position.Y == UDim.new(1, 1) or Main.Position.Y == UDim.new(1, 0) or Main.Position.Y == UDim.new(1, 2) or Main.Position.Y == UDim.new(0, -37) then
                    Utility:Tween(CommandsHolder, {Position = UDim2.new(0, 0, 0, -Main.Position.Y.Offset - Size - 13)}, 0.25)
                else
                    Utility:Tween(CommandsHolder, {Position = UDim2.new(0, 0, 0, -Main.Position.Y.Offset - Size + 22)}, 0.25)
                end
            else
                if Main.Position.Y == UDim.new(1, 36) or Main.Position.Y == UDim.new(0, -72) then
                    Utility:Tween(CommandsHolder, {Position = UDim2.new(0, 0, 0, -Main.Position.Y.Offset - 3)}, 0.25)
                else
                    Utility:Tween(CommandsHolder, {Position = UDim2.new(0, 0, 0, -Main.Position.Y.Offset + 33)}, 0.25)
                end
            end
        else
            Utility:Tween(CommandsHolder, {Size = UDim2.new(0, 500, 0, 270)}, 0.25)
            Utility:Tween(CommandsHolderScrolling, {Size = UDim2.new(0, 500, 0, 260)}, 0.25)
            Utility:Tween(CommandsHolderScrolling, {CanvasSize = UDim2.new(0, 500, 0, Size)}, 0.25)

            if string.find(Position, 'bottom') then
                if Main.Position.Y == UDim.new(1, 1) or Main.Position.Y == UDim.new(1, 0) or Main.Position.Y == UDim.new(1, 2) or Main.Position.Y == UDim.new(0, -37) then
                    Utility:Tween(CommandsHolder, {Position = UDim2.new(0, 0, 0, -Main.Position.Y.Offset - 273)}, 0.25)
                else
                    Utility:Tween(CommandsHolder, {Position = UDim2.new(0, 0, 0, -Main.Position.Y.Offset - 237)}, 0.25)
                end
            else
                if Main.Position.Y == UDim.new(1, 36) or Main.Position.Y == UDim.new(0, -72) then
                    Utility:Tween(CommandsHolder, {Position = UDim2.new(0, 0, 0, -Main.Position.Y.Offset - 3)}, 0.25)
                else
                    Utility:Tween(CommandsHolder, {Position = UDim2.new(0, 0, 0, -Main.Position.Y.Offset + 33)}, 0.25)
                end
            end
        end
    end

    CommandsHolderScrolling.ChildAdded:Connect(UpdateFrameSizes)
    CommandsHolderScrolling.ChildRemoved:Connect(UpdateFrameSizes)

    -- // Main Button Callbacks
    CloseButton.MouseButton1Down:Connect(function()
        Utility:Tween(CloseButton, {TextColor3 = Utility:Darken(Theme.PrimaryTextColor)}, 0.25)

        task.wait(0.25)

        Utility:Tween(CloseButton, {TextColor3 = Theme.PrimaryTextColor}, 0.25)

        task.wait(0.25)

        Utility:Destroy()
    end)

    -- // Prefix
    UserInputService.InputBegan:Connect(function(Input, GameProcessedEvent)
        if not GameProcessedEvent then
            if Input.KeyCode.Name == Library.Prefix.Name then
                if Main.Position.Y == UDim.new(1, 37) or Main.Position.Y == UDim.new(1, 36) or Main.Position.Y == UDim.new(0, -72) then
                    UpdateFrameSizes()
                    CommandInput:CaptureFocus()
                    if string.find(Position, 'bottom') then
                        Utility:Tween(Main, {Position = Main.Position + UDim2.new(0, 0, 0, -36)}, 0.25)
                        
                        task.wait(0.25)

                        CommandsHolder.Visible = true

                        Utility:Tween(CommandsHolder, {BackgroundTransparency = 0.25}, 0.25)

                        task.wait(0.25)

                        for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                            if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                                if Instance:IsA('Frame') then
                                    Utility:Tween(Instance, {BackgroundTransparency = 0.25}, 0.25)
                                end

                                if Utility:HasProperty(Instance, 'TextTransparency') then
                                    Utility:Tween(Instance, {TextTransparency = 0}, 0.25)
                                end
                            end
                        end
                    else
                        Utility:Tween(Main, {Position = Main.Position + UDim2.new(0, 0, 0, 36)}, 0.25)    
                        
                        task.wait(0.25)

                        CommandsHolder.Visible = true

                        Utility:Tween(CommandsHolder, {BackgroundTransparency = 0.25}, 0.25)

                        task.wait(0.25)

                        for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                            if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                                if Instance:IsA('Frame') then
                                    Utility:Tween(Instance, {BackgroundTransparency = 0.25}, 0.25)
                                end

                                if Utility:HasProperty(Instance, 'TextTransparency') then
                                    Utility:Tween(Instance, {TextTransparency = 0}, 0.25)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    -- // Execute Command
    local function Execute(String)
        local Split = String:split(' ')
        local Arguments = {}
        local First = Split[1]:lower():gsub(Utility:KeyCodeToString(Library.Prefix), '')

        CommandInput.Text = ''

        local Command = assert(Commands[First], '[Visual] Command Not Found: ' .. First)

        local NumberOfArguments = #Command.Arguments

        for Index, Argument in next, Split do
            if Index > 1 then
                table.insert(Arguments, Argument)
            end
        end

        if NumberOfArguments > #Arguments then
            local Missing = ''
            
            for Index = 1, NumberOfArguments do
                if not Arguments[Index] then
                    Missing = Missing .. tostring(Command.Arguments[Index])
                end
            end

            Utility:Log('Error', 'Missing Arguments: ' .. Missing .. ' | Command: ' .. First)

            if not HoverDebounce then
                if Main.Position.Y == UDim.new(1, 0) or Main.Position.Y == UDim.new(0, -36) then
                    CommandInput.Text = ''

                    task.spawn(function()
                        HoverDebounce = true
                        task.wait(0.5)
                        HoverDebounce = false 
                    end)

                    if string.find(Position, 'bottom') then
                        for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                            if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                                if Instance:IsA('Frame') then
                                    Utility:Tween(Instance, {BackgroundTransparency = 1}, 0.25)
                                end

                                if Utility:HasProperty(Instance, 'TextTransparency') then
                                    Utility:Tween(Instance, {TextTransparency = 1}, 0.25)
                                end
                            end
                        end

                        task.wait(0.25)

                        Utility:Tween(Main, {Position = Main.Position + UDim2.new(0, 0, 0, 36)}, 0.25)

                        task.wait(0.25)
                        
                        Utility:Tween(CommandsHolder, {BackgroundTransparency = 1}, 0.25)

                        task.wait(0.25)

                        CommandsHolder.Visible = false
                    else
                        for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                            if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                                if Instance:IsA('Frame') then
                                    Utility:Tween(Instance, {BackgroundTransparency = 1}, 0.25)
                                end

                                if Utility:HasProperty(Instance, 'TextTransparency') then
                                    Utility:Tween(Instance, {TextTransparency = 1}, 0.25)
                                end
                            end
                        end

                        task.wait(0.25)

                        Utility:Tween(CommandsHolder, {BackgroundTransparency = 1}, 0.25)

                        task.wait(0.25)

                        Utility:Tween(Main, {Position = Main.Position + UDim2.new(0, 0, 0, -36)}, 0.25)

                        task.wait(0.25)

                        CommandsHolder.Visible = false
                    end
                end
            end
        else
            task.spawn(Command.Callback, Arguments, Players.LocalPlayer)

            if Main.Position.Y == UDim.new(1, 0) or Main.Position.Y == UDim.new(0, -36) then
                CommandInput.Text = ''

                if not HoverDebounce then
                    task.spawn(function()
                        HoverDebounce = true
                        task.wait(0.5)
                        HoverDebounce = false 
                    end)

                    if string.find(Position, 'bottom') then
                        for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                            if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                                if Instance:IsA('Frame') then
                                    Utility:Tween(Instance, {BackgroundTransparency = 1}, 0.25)
                                end

                                if Utility:HasProperty(Instance, 'TextTransparency') then
                                    Utility:Tween(Instance, {TextTransparency = 1}, 0.25)
                                end
                            end
                        end

                        task.wait(0.25)

                        Utility:Tween(Main, {Position = Main.Position + UDim2.new(0, 0, 0, 36)}, 0.25)

                        task.wait(0.25)
                        
                        Utility:Tween(CommandsHolder, {BackgroundTransparency = 1}, 0.25)

                        task.wait(0.25)

                        CommandsHolder.Visible = false
                    else
                        for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                            if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                                if Instance:IsA('Frame') then
                                    Utility:Tween(Instance, {BackgroundTransparency = 1}, 0.25)
                                end

                                if Utility:HasProperty(Instance, 'TextTransparency') then
                                    Utility:Tween(Instance, {TextTransparency = 1}, 0.25)
                                end
                            end
                        end

                        task.wait(0.25)

                        Utility:Tween(CommandsHolder, {BackgroundTransparency = 1}, 0.25)

                        task.wait(0.25)

                        Utility:Tween(Main, {Position = Main.Position + UDim2.new(0, 0, 0, -36)}, 0.25)

                        task.wait(0.25)

                        CommandsHolder.Visible = false
                    end
                end
            end
        end
    end

    -- // Search Commands
    CommandInput:GetPropertyChangedSignal('Text'):Connect(function()
        if CommandInput.Text == '' then
            for _, Instance in next, CommandsHolderScrolling:GetChildren() do
                if not Instance:IsA('UIListLayout') then
                    Instance.Visible = true

                    UpdateFrameSizes()
                end
            end
        else
            local Split = CommandInput.Text:split()
            local Full = ''
            
            for Index, String in next, Split do
                if Index == 1 then
                    Full = Full .. Split[1]:gsub(Utility:KeyCodeToString(Library.Prefix), '')
                else
                    Full = Full .. Split[Index]
                end
            end

            CommandInput.Text = Full

            for _, Instance in next, CommandsHolderScrolling:GetChildren() do
                if not Instance:IsA('UIListLayout') then
                    if string.find(Instance.Name:gsub('CommandHolder', ''):lower(), CommandInput.Text:lower()) then
                        Instance.Visible = true

                        UpdateFrameSizes()
                    else

                        Instance.Visible = false

                        UpdateFrameSizes()
                    end
                end
            end
        end
    end)

    -- // Command Entered
    CommandInput.FocusLost:Connect(function()
        if not HoverDebounce then
            task.spawn(function()
                HoverDebounce = true
                task.wait(0.5)
                HoverDebounce = false 
            end)

            if not IsInCommandsHolder and not Dragging then
                if Main.Position.Y == UDim.new(1, 0) or Main.Position.Y == UDim.new(0, -36) then
                    task.spawn(function()
                        Execute(CommandInput.Text)
                        CommandInput.Text = ''
                    end)

                    if string.find(Position, 'bottom') then
                        for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                            if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                                if Instance:IsA('Frame') then
                                    Utility:Tween(Instance, {BackgroundTransparency = 1}, 0.25)
                                end

                                if Utility:HasProperty(Instance, 'TextTransparency') then
                                    Utility:Tween(Instance, {TextTransparency = 1}, 0.25)
                                end
                            end
                        end

                        task.wait(0.25)

                        Utility:Tween(Main, {Position = Main.Position + UDim2.new(0, 0, 0, 36)}, 0.25)

                        task.wait(0.25)
                        
                        Utility:Tween(CommandsHolder, {BackgroundTransparency = 1}, 0.25)

                        task.wait(0.25)

                        CommandsHolder.Visible = false
                    else
                        for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                            if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                                if Instance:IsA('Frame') then
                                    Utility:Tween(Instance, {BackgroundTransparency = 1}, 0.25)
                                end

                                if Utility:HasProperty(Instance, 'TextTransparency') then
                                    Utility:Tween(Instance, {TextTransparency = 1}, 0.25)
                                end
                            end
                        end

                        task.wait(0.25)

                        Utility:Tween(CommandsHolder, {BackgroundTransparency = 1}, 0.25)

                        task.wait(0.25)

                        Utility:Tween(Main, {Position = Main.Position + UDim2.new(0, 0, 0, -36)}, 0.25)

                        task.wait(0.25)

                        CommandsHolder.Visible = false
                    end
                end
            end
        end
    end)

    -- // Tool Tips
    function CreateToolTip(Text, Clone, Enabled)
        local ToolTip = Container.ToolTip
        
        if Enabled then
            local Size = TextService:GetTextSize(Clone, ToolTip.TextSize, ToolTip.Font, Vector2.new(300, math.huge))
            Utility:Tween(ToolTip, {Size = UDim2.new(0, Size.X + 5, 0, Size.Y + 5)}, 0.25)

            if ToolTip.Visible then
                RunService:UnbindFromRenderStep('ToolTip')

                ToolTip.Visible = false
            end

            RunService:BindToRenderStep('ToolTip', 1, function()
                local MouseLocation = UserInputService:GetMouseLocation()
                local ViewportSize = Workspace.CurrentCamera.ViewportSize

                local Offset = UDim2.new(0, 0, 0, 0)
                local NewPosition = UDim2.new(MouseLocation.X / ViewportSize.X, 0, MouseLocation.Y / ViewportSize.Y, 0) + Offset

                Utility:Tween(ToolTip, {Position = NewPosition}, 0.25)
            end)

            ToolTip.Text = Text
		    ToolTip.Visible = true

        else
            if ToolTip.Visible then
                ToolTip.Visible = false
                RunService:UnbindFromRenderStep('ToolTip')
            end
        end
        
    end

    local WindowFunctions = {}

    function WindowFunctions:ChangePrefix(Prefix)
        Library.Prefix = Utility:StringToKeyCode(Prefix)
    end

    function WindowFunctions:AddTheme(Name, Theme)
        if Library.Themes[Name] then
            Utility:Log('Error', 'A Theme Already Exists With The Name' .. Name)
        else
            Library.Themes[Name:lower()] = Theme
        end
    end

    function WindowFunctions:GetThemes(Names)
        if Names then
            local Table = {}

            for Index, Theme in next, Library.Themes do
                table.insert(Table, Index)
            end

            return Table
        else
            return Library.Themes
        end
    end

    function WindowFunctions:ChangeTheme(NewTheme)
        local function ChangeThemeActive()
            task.spawn(function()
                ChangeTheme = true
                
                task.wait()

                ChangeTheme = false
            end)
        end

        if type(NewTheme) == 'table' then
            Theme = NewTheme
            Library.Themes['custom'] = Theme
            ChangeThemeActive()
    
        elseif type(NewTheme) == 'string' then
            if Library.Themes[NewTheme] then
                Library.Theme = Library.Themes[NewTheme]
                Theme = Library.Theme
                ChangeThemeActive()
            else
                Utility:Log('Error', 'Theme Doesn\'t exist: ' .. NewTheme)
            end
        end
    end

    function WindowFunctions:CreateNotification(Title, Text, Duration)
        local function NotificationCount()
            local Amount = 0

            for _, Notification in next, Container:GetChildren() do
                if string.find(Notification.Name, 'Notification') then
                    Amount += 1
                end
            end 

            return Amount
        end

        task.wait(0.5)

        task.spawn(function()
            local Title = Title or 'Title'
            local Text = Text or 'Text'
            local Duration = Duration or 5

            Utility:Create('Frame', {
                Parent = Container,
                Name = 'Notification' .. tostring(NotificationCount() + 1),
                BackgroundColor3 = Library.Theme.BackgroundColor,
                BorderSizePixel = 0,
                Position = UDim2.new(1, 300, 1, -30),
                Size = UDim2.new(0, 300, 0, 50),
                BackgroundTransparency = 0,
                AnchorPoint = Vector2.new(1, 1)
            }, {
                Utility:Create('UICorner', {
                    CornerRadius = UDim.new(0, 5),
                    Name = 'NotificationCorner'
                }),
                Utility:Create('UIStroke', {
                    Name = 'NotificationStroke',
                    ApplyStrokeMode = 'Contextual',
                    Color = Library.Theme.AccentColor,
                    LineJoinMode = 'Round',
                    Thickness = 1
                }),
                Utility:Create('TextLabel', {
                    Name = 'NotificationTitle',
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, -1),
                    Size = UDim2.new(0, 300, 0, 30),
                    Font = Enum.Font.Gotham,
                    Text = Title,
                    TextColor3 = Library.Theme.PrimaryTextColor,
                    TextSize = 16,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, {
                    Utility:Create('UIPadding', {
                        Name = 'NotificationTitlePadding',
                        PaddingLeft = UDim.new(0, 7)
                    })
                }),
                Utility:Create('TextLabel', {
                    Name = 'NotificationText',
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(0, 300, 0, 30),
                    Font = Enum.Font.Gotham,
                    Text = Text,
                    TextWrapped = true,
                    TextColor3 = Library.Theme.SecondaryTextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, {
                    Utility:Create('UIPadding', {
                        Name = 'NotificationTextPadding',
                        PaddingLeft = UDim.new(0, 7)
                    })
                })
            })

            local Holder = Container['Notification' .. tostring(NotificationCount())]
            local TitleObj = Holder['NotificationTitle']
            local TextObj = Holder['NotificationText']
            local TextSize = TextService:GetTextSize(Text, 14, Enum.Font.Gotham, Vector2.new(300, math.huge))

            Holder.Size = UDim2.new(0, 300, 0, TextSize.Y + 30)
            TextObj.Size = UDim2.new(0, 300, 0, TextSize.Y)

            if NotificationCount() > 1 then
                local PreviousSizes = 0

                for _, Notification in next, Container:GetChildren() do
                    if string.find(Notification.Name, 'Notification') and Notification ~= Holder.Parent['Notification' .. tostring(NotificationCount())] and Notification.Position.X == UDim.new(1, -30) then
                        local AbsoluteY = Notification.AbsoluteSize.Y + 5

                        PreviousSizes = PreviousSizes + AbsoluteY
                    end
                end

                Holder.Position = UDim2.new(1, 300, 1, -30 - PreviousSizes)

                Utility:Tween(Holder, {Position = UDim2.new(1, -30, 1, -30 - PreviousSizes)}, 0.25)
            else
                Utility:Tween(Holder, {Position = UDim2.new(1, -30, 1, -30)}, 0.25)
            end

            task.wait(Duration - 0.5)

            Utility:Tween(Holder, {BackgroundTransparency = 0.8}, 0.25)
            Utility:Tween(TitleObj, {TextTransparency = 0.5}, 0.25)
            Utility:Tween(TextObj, {TextTransparency = 0.5}, 0.25)

            task.wait(0.25)

            Utility:Tween(Holder, {Position = UDim2.new(1, 300, 1, Holder.Position.Y.Offset)}, 0.25)

            task.wait(0.25)

            Holder:Destroy()
        end)
    end

    function WindowFunctions:AddCommand(Name, Arguments, Description, Callback)
        Commands[Name:lower()] = {
            Name = Name:lower(),
            Arguments = Arguments,
            Description = Description,
            Callback = Callback
        }

        local function Highlight(String, Color)
            return string.format('<font color = "rgb(%d, %d, %d)">%s</font>', Color.r * 255, Color.g * 255, Color.b * 255, String)
        end

        local function ConstructString(Highlighted)
            if Highlighted then
                local String = '' .. Highlight(Name, Library.Theme.PrimaryTextColor) .. ' '

                for _, Argument in next, Arguments do
                    String = String .. Highlight('{' .. Argument .. '}', Library.Theme.SecondaryTextColor) .. ' '
                end

                String = String .. Highlight('| ', Library.Theme.AccentColor) .. Highlight(Description, Library.Theme.SecondaryTextColor)

                return String
            else
                local String = Name .. ' '

                for _, Argument in next, Arguments do
                    String = String .. '{' .. Argument .. '}' .. ' '
                end

                String = String .. '| ' .. Description

                return String
            end
        end

        Utility:Create('Frame', {
            Parent = CommandsHolderScrolling,
            BackgroundColor3 = Theme.BackgroundColor,
            BorderSizePixel = 0,
            BackgroundTransparency = 0.25,
            Name = Name .. 'CommandHolder',
            Size = UDim2.new(0, 490, 0, 30)
        }, {
            Utility:Create('UICorner', {
                CornerRadius = UDim.new(0, 5),
                Name = Name .. 'CommandsHolderCorner'
            }),
            Utility:Create('TextLabel', {
                Name = Name .. 'Text',
                BackgroundColor3 = Theme.BackgroundColor,
                BackgroundTransparency = 1,
                TextTransparency = 0,
                BorderSizePixel = 0,
                RichText = true,
                Size = UDim2.new(0, 490, 0, 30),
                Font = Enum.Font.Gotham,
                Text = ConstructString(true),
                TextColor3 = Theme.PrimaryTextColor,
                TextSize = 15,
                ZIndex = 2,
                TextXAlignment = Enum.TextXAlignment.Left
            }, {
                Utility:Create('UIPadding', {
                    PaddingLeft = UDim.new(0, 5),
                    Name = Name .. 'Padding'
                })
            }),
            Utility:Create('TextButton', {
                Name = Name .. 'Button',
                Size = UDim2.new(0, 490, 0, 30),
                BackgroundTransparency = 1,
                AutoButtonColor = false,
                BorderSizePixel = 0,
                ZIndex = 100,
                Text = ''
            }, {
                Utility:Create('UICorner', {
                    CornerRadius = UDim.new(0, 5),
                    Name = Name .. 'ButtonCorner'
                })
            })
        })

        -- // Variables
        local CommandHolder = CommandsHolderScrolling[Name .. 'CommandHolder']
        local Button = CommandHolder[Name .. 'Button']

        -- // Theme Updates
        task.spawn(function()
            while task.wait() do
                if ChangeTheme then
                    if not BreakLoops then
                        Utility:Tween(CommandsHolderScrolling[Name .. 'CommandHolder'], {BackgroundColor3 = Library.Theme.BackgroundColor}, 0.25)
                        Utility:Tween(CommandsHolderScrolling[Name .. 'CommandHolder'][Name .. 'Text'], {BackgroundColor3 = Library.Theme.BackgroundColor}, 0.25)
                        Utility:Tween(CommandsHolderScrolling[Name .. 'CommandHolder'][Name .. 'Text'], {TextColor3 = Library.Theme.PrimaryTextColor}, 0.25)
                        CommandHolder[Name .. 'Text'].Text = ConstructString(true)
                    else
                        break
                    end
                end
            end
        end)

        -- // Events
        Button.MouseButton1Down:Connect(function()
            Utility:Tween(CommandHolder, {BackgroundColor3 = Utility:Lighten(Theme.BackgroundColor)}, 0.25)

            task.wait(0.25)

            pcall(Execute(Name))

            Utility:Tween(CommandHolder, {BackgroundColor3 = Theme.BackgroundColor}, 0.25)

            task.wait(0.25)

            if not HoverDebounce then
                task.spawn(function()
                    HoverDebounce = true
                    task.wait(0.5)
                    HoverDebounce = false 
                end)

                if Main.Position.Y == UDim.new(1, 1) or Main.Position.Y == UDim.new(0, -37) then
                    if string.find(Position, 'bottom') then
                        Utility:Tween(Main, {Position =  Main.Position + UDim2.new(0, 0, 0, 36)}, 0.25)
        
                        CommandInput.Text = ''
                        
                        task.wait(0.25)
        
                        for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                            if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                                if Instance:IsA('Frame') then
                                    Utility:Tween(Instance, {BackgroundTransparency = 1}, 0.25)
                                end
        
                                if Utility:HasProperty(Instance, 'TextTransparency') then
                                    Utility:Tween(Instance, {TextTransparency = 1}, 0.25)
                                end
                            end
                        end
        
                        task.wait(0.25)
                        
                        Utility:Tween(CommandsHolder, {BackgroundTransparency = 1}, 0.25)
        
                        task.wait(0.25)
        
                        CommandsHolder.Visible = false
                    else
                        Utility:Tween(Main, {Position = Main.Position + UDim2.new(0, 0, 0, -35)}, 0.25)
        
                        CommandInput.Text = ''
                        
                        task.wait(0.25)
        
                        for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                            if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                                if Instance:IsA('Frame') then
                                    Utility:Tween(Instance, {BackgroundTransparency = 1}, 0.25)
                                end
        
                                if Utility:HasProperty(Instance, 'TextTransparency') then
                                    Utility:Tween(Instance, {TextTransparency = 1}, 0.25)
                                end
                            end
                        end
        
                        task.wait(0.25)
                        
                        Utility:Tween(CommandsHolder, {BackgroundTransparency = 1}, 0.25)
        
                        task.wait(0.25)
        
                        CommandsHolder.Visible = false
                    end
                end
            end
        end)

        CommandHolder.MouseEnter:Connect(function()
            Utility:Tween(CommandHolder, {BackgroundColor3 = Utility:Lighten(Theme.BackgroundColor)}, 0.25)

            CreateToolTip(ConstructString(true), ConstructString(false), true)
        end)

        CommandHolder.MouseLeave:Connect(function()
            Utility:Tween(CommandHolder, {BackgroundColor3 = Theme.BackgroundColor}, 0.25)

            CreateToolTip(nil, nil, false)
        end)
    end

    return WindowFunctions
end
return Library