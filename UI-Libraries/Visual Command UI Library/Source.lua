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

    function Utility:Increment(Number, Delay, Callback)
        for Index = 1, Number do
            Callback(Index)
            task.wait(Delay)
        end
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

    function Utility:EnableDragging(Frame)
        local Dragging, DraggingInput, DragStart, StartPosition
        
        local function Update(Input)
            local Delta = Input.Position - DragStart
            Frame.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        end
        
        Frame.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                DragStart = Input.Position
                StartPosition = Frame.Position
        
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
                Draggable = {
                    'Draggable',
                    'draggable'
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

    function Utility:Destroy()
        for _, UI in next, CoreGui:GetChildren() do
            if UI.Name == 'Visual Command UI Library | .gg/puxxCphTnK' then
                for _, Item in next, UI.Main:GetChildren() do
                    if Item.Name ~= 'MainCorner' and Item.Name ~= 'MainStroke' then
                        Item:Destroy()
                    end
                end
    
                Utility:Tween(UI.Main, {Size = UDim2.new(0, 500, 0, 0)}, 0.25)

                if UI.SettingsTab.Visible then
                    local Tab = UI.SettingsTab

                    for _, Instance in next, Tab:GetDescendants() do
                        if not Instance:IsA('UICorner') and not Instance:IsA('UIPadding') then
                            local HasBackgroundTransparency = Utility:HasProperty(Instance, 'BackgroundTransparency')
                            local HasTextTransparency = Utility:HasProperty(Instance, 'TextTransparency')
                            local HasImageTransparency = Utility:HasProperty(Instance, 'ImageTransparency')
                            local HasThickness = Utility:HasProperty(Instance, 'Thickness')
            
                            if HasBackgroundTransparency then
                                Utility:Tween(Instance, {BackgroundTransparency = 1}, 0.25)
                            end
                            
                            if HasTextTransparency then
                                Utility:Tween(Instance, {TextTransparency = 1}, 0.25)
                            end
            
                            if HasImageTransparency then
                                Utility:Tween(Instance, {ImageTransparency = 1}, 0.25)
                            end
            
                            if HasThickness then
                                Instance.Thickness = 0
                            end
                        end
                    end
            
                    task.wait(0.5)
            
                    Utility:Tween(Tab, {Size = UDim2.new(0, 0, 0, 300)}, 0.25)
                end

                task.wait(0.25)

                UI:Destroy()
            end
        end
    end
end

-- // Library Defaults
Library.Transparency = 0
Library.Themes = {
    Dark = {
        BackgroundColor = Color3.fromRGB(40, 40, 40),
        SecondaryColor = Color3.fromRGB(50, 50, 50),
        AccentColor = Color3.fromRGB(100, 100, 100),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(175, 175, 175)
    }
}
Library.Toggled = false

-- // CreateWindow - Name, IntroText, IntroIcon, ConfigFolder, Theme, Position, Draggable, Prefix
function Library:CreateWindow(Properties)
    local Name = Utility:GetProperty('Window', 'Name', Properties) or 'Visual Command UI Library'
    local IntroText = Utility:GetProperty('Window', 'IntroText', Properties) or 'Visual Command UI Library'
    local IntroIcon = Utility:GetProperty('Window', 'IntroIcon', Properties) or 'rbxassetid://10618644218'
    local ConfigFolder = Utility:GetProperty('Window', 'ConfigFolder', Properties) or 'Visual Command UI Library Configs'
    local Theme = Utility:GetProperty('Window', 'Theme', Properties) or Library.Themes.Dark
    local Position = string.lower(Utility:GetProperty('Window', 'Position', Properties)) or 'top'
    local Draggable = Utility:GetProperty('Window', 'Draggable', Properties) or false
    local Prefix = Utility:GetProperty('Window', 'Prefix', Properties) or '.'

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

    -- // Variables
    local Main = Container.Main
    --local IntroText = Main.IntroText
    --local IntroIcon = Main.IntroIcon
    local MainStroke = Main.MainStroke
    
    -- // Dragging
    --if Draggable then
    --    Utility:EnableDragging(Main)
    --end

    -- // Intro
    MainStroke.Thickness = 0

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

    Main['IntroText']:Destroy()
    Main['IntroImage']:Destroy()

    Utility:Tween(Main, {Size = UDim2.new(0, 500, 0, 65)}, 0.25)
    Utility:Tween(Main, {BackgroundTransparency = 0}, 0.25)
    MainStroke.Thickness = 1

    task.wait(0.5)

    -- // Position
    if Position == 'top' then
        Main.AnchorPoint = Vector2.new(0.5, 0)
        Utility:Tween(Main, {Position = UDim2.new(0.5, 0, 0, -71)}, 0.25)
    elseif Position == 'topleft' then
        Main.AnchorPoint = Vector2.new(0, 0)
        Utility:Tween(Main, {Position = UDim2.new(0, 0, 0, -71)}, 0.25)
    elseif Position == 'topright' then
        Main.AnchorPoint = Vector2.new(1, 0)
        Utility:Tween(Main, {Position = UDim2.new(1, 0, 0, -71)}, 0.25)
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
            Name = 'Line2',
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
            }),
        })

        Utility:Create('ImageButton', {
            Name = 'SettingsButton',
            Position = UDim2.new(0, 455, 0, 4),
            Size = UDim2.new(0, 20, 0, 20),
            BackgroundColor3 = Theme.BackgroundColor,
            ImageColor3 = Theme.PrimaryTextColor,
            AutoButtonColor = false,
            Parent = Main,
            Image = 'rbxassetid://3926307971',
            ImageRectOffset = Vector2.new(324, 124),
            ImageRectSize = Vector2.new(36, 36),
            BorderSizePixel = 0
        }, {
            Utility:Create('UICorner', {
                Name = 'SettingsButtonCorner',
                CornerRadius = UDim.new(0, 5)
            }),
        })
    else
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

        Utility:Create('ImageButton', {
            Name = 'SettingsButton',
            Position = UDim2.new(0, 455, 0, 40),
            Size = UDim2.new(0, 20, 0, 20),
            BackgroundColor3 = Theme.BackgroundColor,
            ImageColor3 = Theme.PrimaryTextColor,
            AutoButtonColor = false,
            Parent = Main,
            Image = 'rbxassetid://3926307971',
            ImageRectOffset = Vector2.new(324, 124),
            ImageRectSize = Vector2.new(36, 36),
            BorderSizePixel = 0
        }, {
            Utility:Create('UICorner', {
                Name = 'SettingsButtonCorner',
                CornerRadius = UDim.new(0, 5)
            }),
        })
    end

    -- // Animate Elements
    task.wait(0.25)

    local CommandInput = Main.CommandInput
    local CommandInputStroke = CommandInput.CommandInputStroke
    local CloseButton = Main.CloseButton
    local SettingsButton = Main.SettingsButton

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

    SettingsButton.MouseEnter:Connect(function()
        Utility:Tween(SettingsButton, {ImageColor3 = Utility:Darken(Theme.PrimaryTextColor)}, 0.25)
    end)

    SettingsButton.MouseLeave:Connect(function()
        Utility:Tween(SettingsButton, {ImageColor3 = Theme.PrimaryTextColor}, 0.25)
    end)

    -- // Main Button Callbacks
    CloseButton.MouseButton1Down:Connect(function()
        Utility:Tween(CloseButton, {TextColor3 = Utility:Darken(Theme.PrimaryTextColor)}, 0.25)

        task.wait(0.25)

        Utility:Tween(CloseButton, {TextColor3 = Theme.PrimaryTextColor}, 0.25)

        task.wait(0.25)

        Utility:Destroy()
    end)

    local SettingsChildrenCreated = false
    SettingsButton.MouseButton1Down:Connect(function()
        if not SettingsChildrenCreated then
            -- // Create Elements
            Utility:Create('Frame', {
                Name = 'SettingsTab',
                Size = UDim2.new(0, 0, 0, 300),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundColor3 = Theme.BackgroundColor,
                BackgroundTransparency = 0,
                Parent = Container,
                ZIndex = 6,
                Visible = true,
            }, {
                Utility:Create('UICorner', {
                    Name = 'SettingsTabCorner',
                    CornerRadius = UDim.new(0, 5)
                }),
                Utility:Create('UIStroke', {
                    Name = 'SettingsTabStroke',
                    Color = Theme.AccentColor,
                    Thickness = 1
                }),
                Utility:Create('Frame', {
                    Name = 'Topbar',
                    Size = UDim2.new(0, 500, 0, 30),
                    BackgroundColor3 = Theme.BackgroundColor,
                    BackgroundTransparency = 1,
                    ZIndex = 7,
                    Visible = true,
                }, {
                    Utility:Create('UICorner', {
                        Name = 'TopbarCorner',
                        CornerRadius = UDim.new(0, 5)
                    }),
                    Utility:Create('UIStroke', {
                        Name = 'TopbarStroke',
                        Color = Theme.AccentColor,
                        Thickness = 1
                    }),
                    Utility:Create('Frame', {
                        Name = 'TopbarFiller1',
                        Position = UDim2.new(0, 0, 0, 25),
                        Size = UDim2.new(0, 5, 0, 5),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        ZIndex = 7,
                        BackgroundColor3 = Theme.BackgroundColor
                    }),
                    Utility:Create('Frame', {
                        Name = 'TopbarFiller2',
                        Position = UDim2.new(0, 495, 0, 25),
                        Size = UDim2.new(0, 5, 0, 5),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        ZIndex = 7,
                        BackgroundColor3 = Theme.BackgroundColor
                    }),
                    Utility:Create('Frame', {
                        Name = 'TopbarLine1',
                        Position = UDim2.new(0, 0, 0, 30),
                        Size = UDim2.new(0, 10, 0, 1),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        ZIndex = 7,
                        BackgroundColor3 = Theme.AccentColor
                    }),
                    Utility:Create('Frame', {
                        Name = 'TopbarLine2',
                        Position = UDim2.new(0, 495, 0, 30),
                        Size = UDim2.new(0, 5, 0, 1),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        ZIndex = 7,
                        BackgroundColor3 = Theme.AccentColor
                    }),
                    Utility:Create('ImageButton', {
                        Name = 'BackButton',
                        BackgroundColor3 = Theme.BackgroundColor,
                        Position = UDim2.new(0, 470, 0, 3),
                        BorderSizePixel = 0,
                        ImageColor3 = Theme.PrimaryTextColor,
                        Size = UDim2.new(0, 25, 0, 25),
                        BackgroundTransparency = 1,
                        ImageTransparency = 1,
                        Image = 'rbxassetid://3926307971',
                        AutoButtonColor = false,
                        ZIndex = 7,
                        ImageRectOffset = Vector2.new(884, 284),
                        ImageRectSize = Vector2.new(36, 36)
                    }),
                    Utility:Create('TextLabel', {
                        Name = 'SettingsTitle',
                        Position = UDim2.new(0, 5, 0, 0),
                        Size = UDim2.new(0, 135, 0, 30),
                        TextColor3 = Theme.PrimaryTextColor,
                        BackgroundColor3 = Theme.BackgroundColor,
                        Font = Enum.Font.Gotham,
                        BackgroundTransparency = 1,
                        TextTransparency = 1,
                        Text = 'Settings',
                        BorderSizePixel = 0,
                        TextSize = 16,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 7,
                    }, {
                        Utility:Create('UIPadding', {
                            Name = 'TabButtonTextPadding',
                            PaddingLeft = UDim.new(0, 0)
                        })
                    })
                })
            })
        end
    
        SettingsChildrenCreated = true
    
        local Tab = Container['SettingsTab']
        local Topbar = Tab['Topbar']
        local BackButton = Topbar['BackButton']

        -- // Dragging
        Utility:EnableDragging(Tab)
        
        -- // Animate Size
        Tab.Visible = true

        Utility:Tween(Tab, {Size = UDim2.new(0, 500, 0, 300)}, 0.25)

        -- // Animate Tab Children
        task.wait(0.5)
        for _, Instance in next, Tab:GetDescendants() do
            if not Instance:IsA('UICorner') and not Instance:IsA('UIPadding') then
                local HasBackgroundTransparency = Utility:HasProperty(Instance, 'BackgroundTransparency')
                local HasTextTransparency = Utility:HasProperty(Instance, 'TextTransparency')
                local HasImageTransparency = Utility:HasProperty(Instance, 'ImageTransparency')
                local HasThickness = Utility:HasProperty(Instance, 'Thickness')
    
                if HasBackgroundTransparency then
                    Utility:Tween(Instance, {BackgroundTransparency = 0}, 0.25)
                end
                
                if HasTextTransparency then
                    Utility:Tween(Instance, {TextTransparency = 0}, 0.25)
                end
    
                if HasImageTransparency then
                    Utility:Tween(Instance, {ImageTransparency = 0}, 0.25)
                end
    
                if HasThickness then
                    Instance.Thickness = 1
                end
            end
        end
    
        -- // Animate Back Button
        BackButton.MouseEnter:Connect(function()
            Utility:Tween(BackButton, {ImageColor3 = Utility:Darken(Theme.PrimaryTextColor)}, 0.25)
        end)
        
        BackButton.MouseLeave:Connect(function()
            Utility:Tween(BackButton, {ImageColor3 = Theme.PrimaryTextColor}, 0.25)
        end)
    
        BackButton.MouseButton1Click:Connect(function()
            Utility:Tween(BackButton, {ImageColor3 = Utility:Darken(Theme.PrimaryTextColor)}, 0.25)
    
            task.wait(0.25)
    
            for _, Instance in next, Tab:GetDescendants() do
                if not Instance:IsA('UICorner') and not Instance:IsA('UIPadding') then
                    local HasBackgroundTransparency = Utility:HasProperty(Instance, 'BackgroundTransparency')
                    local HasTextTransparency = Utility:HasProperty(Instance, 'TextTransparency')
                    local HasImageTransparency = Utility:HasProperty(Instance, 'ImageTransparency')
                    local HasThickness = Utility:HasProperty(Instance, 'Thickness')
    
                    if HasBackgroundTransparency then
                        Utility:Tween(Instance, {BackgroundTransparency = 1}, 0.25)
                    end
                    
                    if HasTextTransparency then
                        Utility:Tween(Instance, {TextTransparency = 1}, 0.25)
                    end
    
                    if HasImageTransparency then
                        Utility:Tween(Instance, {ImageTransparency = 1}, 0.25)
                    end
    
                    if HasThickness then
                        Instance.Thickness = 0
                    end
                end
            end
    
            task.wait(0.5)
    
            Utility:Tween(Tab, {Size = UDim2.new(0, 0, 0, 300)}, 0.25)
    
            task.wait(0.25)
    
            Tab.Visible = false
    
            Utility:Tween(BackButton, {ImageColor3 = Theme.PrimaryTextColor}, 0.25)
        end)
    end)

    -- // Main Hover
    local HoverDebounce = false

    Main.MouseEnter:Connect(function()
        if Main.Position.Y == UDim.new(1, 36) or Main.Position.Y == UDim.new(0, -71) then
            if string.find(Position, 'bottom') then
                Utility:Tween(Main, {Position = Main.Position + UDim2.new(0, 0, 0, -36)}, 0.25)
            else
                Utility:Tween(Main, {Position = Main.Position + UDim2.new(0, 0, 0, 35)}, 0.25)      
            end
        end
    end)

    Main.MouseLeave:Connect(function()
        if Main.Position.Y == UDim.new(1, 0) or Main.Position.Y == UDim.new(0, -36) then
            if string.find(Position, 'bottom') then
                Utility:Tween(Main, {Position =  Main.Position + UDim2.new(0, 0, 0, 36)}, 0.25)
            else
                Utility:Tween(Main, {Position = Main.Position + UDim2.new(0, 0, 0, -35)}, 0.25)
            end
        end
    end)
end




-- // Example
local Window = Library:CreateWindow({
    Name = 'Visual Command UI Library',
    IntroText = 'Visual Command UI Library',
    IntroIcon = 'rbxassetid://10618644218',
    ConfigFolder = 'Visual Command UI Library Configs',
    Theme = Library.Themes.Dark,
    Position = 'Top',
    Draggable = true,
    Prefix = '.'
})