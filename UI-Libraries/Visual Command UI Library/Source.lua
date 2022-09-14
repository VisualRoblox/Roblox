-- // Services
local CoreGui = game:GetService('CoreGui')
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local TextService = game:GetService('TextService')
local Players = game:GetService('Players')

-- // Variables
local Library = {}
local Utility = {}
local Commands = {}
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
    local Prefix = Utility:GetProperty('Window', 'Prefix', Properties) or 'Period'

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
            })
        })

        Utility:Create('Frame', {
            Parent = Main,
            BackgroundColor3 = Theme.BackgroundColor,
            BorderSizePixel = 0,
            BackgroundTransparency = 0.5,
            Name = 'CommandsHolder',
            Position = UDim2.new(0, 0, 0, -305),
            Size = UDim2.new(0, 500, 0, 300)
        }, {
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

    -- // Animate Elements
    task.wait(0.25)

    local CommandInput = Main.CommandInput
    local CommandInputStroke = CommandInput.CommandInputStroke
    local CloseButton = Main.CloseButton
    local CommandsHolder = Main.CommandsHolder
    local CommandsHolderScrolling = CommandsHolder.CommandsHolderScrolling
    local CommandsHolderScrollingListLayout = CommandsHolderScrolling.CommandsHolderScrollingListLayout

    local IsInCommandsHolder = false

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
        local Count = #CommandsHolderScrolling:GetChildren() - 1
        local Size = Count * 30
        local Padding = 3 * Count

        Size += Padding - 3

        if Count < 9 then
            Utility:Tween(CommandsHolder, {Size = UDim2.new(0, 500, 0, Size + 10)}, 0.25)
            Utility:Tween(CommandsHolderScrolling, {Size = UDim2.new(0, 500, 0, Size)}, 0.25)
            Utility:Tween(CommandsHolderScrolling, {CanvasSize = UDim2.new(0, 500, 0, Size)}, 0.25)

            if string.find(Position, 'bottom') then
                Utility:Tween(CommandsHolder, {Position = UDim2.new(0, 0, 0, -Main.Position.Y.Offset - 7)}, 0.25)
            else
                Utility:Tween(CommandsHolder, {Position = UDim2.new(0, 0, 0, -Main.Position.Y.Offset - 3)}, 0.25)
            end
        else
            local SizeY = CommandsHolderScrolling.AbsoluteCanvasSize.Y

            Utility:Tween(CommandsHolder, {Size = UDim2.new(0, 500, 0, 270)}, 0.25)
            Utility:Tween(CommandsHolderScrolling, {Size = UDim2.new(0, 500, 0, 260)}, 0.25)
            Utility:Tween(CommandsHolderScrolling, {CanvasSize = UDim2.new(0, 500, 0, Size)}, 0.25)

            if string.find(Position, 'bottom') then
                Utility:Tween(CommandsHolder, {Position = UDim2.new(0, 0, 0, -Main.Position.Y.Offset - 7)}, 0.25)
            else
                Utility:Tween(CommandsHolder, {Position = UDim2.new(0, 0, 0, -Main.Position.Y.Offset - 3)}, 0.25)
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

    -- // CommandsHolder Hover
    CommandsHolder.MouseEnter:Connect(function()
        IsInCommandsHolder = true
    end)

    CommandsHolder.MouseLeave:Connect(function()
        IsInCommandsHolder = false
    end)

    -- // Main Hover
    local HoverDebounce = false

    Main.MouseEnter:Connect(function()
        if Main.Position.Y == UDim.new(1, 36) or Main.Position.Y == UDim.new(0, -71) then
            if string.find(Position, 'bottom') then
                Utility:Tween(Main, {Position = Main.Position + UDim2.new(0, 0, 0, -36)}, 0.25)

                task.wait(0.25)

                CommandsHolder.Visible = true

                Utility:Tween(CommandsHolder, {BackgroundTransparency = 0.25}, 0.25)

                task.wait(0.25)

                for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                    if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                        if Utility:HasProperty(Instance, 'BackgroundTransparency') then
                            Utility:Tween(Instance, {BackgroundTransparency = 0.25}, 0.25)
                        end

                        if Utility:HasProperty(Instance, 'TextTransparency') then
                            Utility:Tween(Instance, {TextTransparency = 0}, 0.25)
                        end
                    end
                end
            else
                Utility:Tween(Main, {Position = Main.Position + UDim2.new(0, 0, 0, 35)}, 0.25)    

                task.wait(0.25)

                CommandsHolder.Visible = true

                Utility:Tween(CommandsHolder, {BackgroundTransparency = 0.25}, 0.25)

                task.wait(0.25)

                for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                    if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                        if Utility:HasProperty(Instance, 'BackgroundTransparency') then
                            Utility:Tween(Instance, {BackgroundTransparency = 0.25}, 0.25)
                        end

                        if Utility:HasProperty(Instance, 'TextTransparency') then
                            Utility:Tween(Instance, {TextTransparency = 0}, 0.25)
                        end
                    end
                end
            end
        end
    end)

    Main.MouseLeave:Connect(function()
        task.wait(0.25)

        if not IsInCommandsHolder then
            if Main.Position.Y == UDim.new(1, 0) or Main.Position.Y == UDim.new(0, -36) then
                if string.find(Position, 'bottom') then
                    Utility:Tween(Main, {Position =  Main.Position + UDim2.new(0, 0, 0, 36)}, 0.25)

                    task.wait(0.25)

                    for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                        if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                            if Utility:HasProperty(Instance, 'BackgroundTransparency') then
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

                    task.wait(0.25)

                    for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                        if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                            if Utility:HasProperty(Instance, 'BackgroundTransparency') then
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

    -- // Prefix
    UserInputService.InputBegan:Connect(function(Input, GameProcessedEvent)
        if not GameProcessedEvent then
            if Input.KeyCode.Name == Prefix then
                if Main.Position.Y == UDim.new(1, 36) or Main.Position.Y == UDim.new(0, -71) then
                    if string.find(Position, 'bottom') then
                        Utility:Tween(Main, {Position = Main.Position + UDim2.new(0, 0, 0, -36)}, 0.25)
                        
                        task.wait(0.25)

                        CommandsHolder.Visible = true

                        Utility:Tween(CommandsHolder, {BackgroundTransparency = 0.25}, 0.25)

                        task.wait(0.25)

                        for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                            if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                                if Utility:HasProperty(Instance, 'BackgroundTransparency') then
                                    Utility:Tween(Instance, {BackgroundTransparency = 0.25}, 0.25)
                                end

                                if Utility:HasProperty(Instance, 'TextTransparency') then
                                    Utility:Tween(Instance, {TextTransparency = 0}, 0.25)
                                end
                            end
                        end
                    else
                        Utility:Tween(Main, {Position = Main.Position + UDim2.new(0, 0, 0, 35)}, 0.25)    
                        
                        task.wait(0.25)

                        CommandsHolder.Visible = true

                        Utility:Tween(CommandsHolder, {BackgroundTransparency = 0.25}, 0.25)

                        task.wait(0.25)

                        for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                            if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                                if Utility:HasProperty(Instance, 'BackgroundTransparency') then
                                    Utility:Tween(Instance, {BackgroundTransparency = 0.25}, 0.25)
                                end

                                if Utility:HasProperty(Instance, 'TextTransparency') then
                                    Utility:Tween(Instance, {TextTransparency = 0}, 0.25)
                                end
                            end
                        end
                    end
                end

                task.wait(0.25)

                CommandInput:CaptureFocus()
            end
        end
    end)

    -- // Execute Command
    local function Execute(String)
        local Split = String:split(' ')
        local Arguments = {}

        local Command = assert(Commands[Split[1]], '[Visual] Command Not Found: ' .. Split[1])
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

            Utility:Log('Error', 'Missing Arguments: ' .. Missing .. ' | Command: ' .. Split[1])
        else
            Command.Callback(Arguments, Players.LocalPlayer)
        end
    end

    -- // Command Entered
    CommandInput.FocusLost:Connect(function()
        if Main.Position.Y == UDim.new(1, 0) or Main.Position.Y == UDim.new(0, -36) then
            if string.find(Position, 'bottom') then
                Utility:Tween(Main, {Position =  Main.Position + UDim2.new(0, 0, 0, 36)}, 0.25)

                Execute(CommandInput.Text)

                CommandInput.Text = ''
                
                task.wait(0.25)

                for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                    if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                        if Utility:HasProperty(Instance, 'BackgroundTransparency') then
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

                Execute(CommandInput.Text)

                CommandInput.Text = ''
                
                task.wait(0.25)

                for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                    if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                        if Utility:HasProperty(Instance, 'BackgroundTransparency') then
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
    end)

    -- // Add Command
    local CommandFunctions = {}

    function CommandFunctions:AddCommand(Name, Arguments, Description, Callback)
        Commands[Name] = {
            Name = Name,
            Arguments = Arguments,
            Description = Description,
            Callback = Callback
        }

        local function Highlight(String, Color)
            return string.format('<font color = "rgb(%d, %d, %d)">%s</font>', Color.r * 255, Color.g * 255, Color.b * 255, String)
        end

        --local TextSize = TextService:GetTextSize(Paragraph, 14, Enum.Font.Gotham, Vector2.new(410, math.huge))
        local function ConstructString()
            local String = '' .. Highlight(Name, Theme.PrimaryTextColor) .. ' '

            for _, Argument in next, Arguments do
                String = String .. Highlight('{' .. Argument .. '}', Theme.SecondaryTextColor) .. ' '
            end

            String = String .. Highlight('| ', Theme.AccentColor) .. Highlight(Description, Theme.SecondaryTextColor)

            return String
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
                Text = ConstructString(),
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

        local CommandHolder = CommandsHolderScrolling[Name .. 'CommandHolder']
        local Button = CommandHolder[Name .. 'Button']

        Button.MouseButton1Down:Connect(function()
            Utility:Tween(CommandHolder, {BackgroundColor3 = Utility:Darken(Theme.BackgroundColor)}, 0.25)

            task.wait(0.25)

            Execute(Name)

            Utility:Tween(CommandHolder, {BackgroundColor3 = Theme.BackgroundColor}, 0.25)

            task.wait(0.25)

            if Main.Position.Y == UDim.new(1, 0) or Main.Position.Y == UDim.new(0, -36) then
                if string.find(Position, 'bottom') then
                    Utility:Tween(Main, {Position =  Main.Position + UDim2.new(0, 0, 0, 36)}, 0.25)
    
                    CommandInput.Text = ''
                    
                    task.wait(0.25)
    
                    for _, Instance in next, CommandsHolderScrolling:GetDescendants() do
                        if not Instance:IsA('UIListLayout') and not Instance:IsA('TextButton') then
                            if Utility:HasProperty(Instance, 'BackgroundTransparency') then
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
                            if Utility:HasProperty(Instance, 'BackgroundTransparency') then
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
        end)

        CommandHolder.MouseEnter:Connect(function()
            Utility:Tween(CommandHolder, {BackgroundColor3 = Utility:Darken(Theme.BackgroundColor)}, 0.25)
        end)

        CommandHolder.MouseLeave:Connect(function()
            Utility:Tween(CommandHolder, {BackgroundColor3 = Theme.BackgroundColor}, 0.25)
        end)
    end

    return CommandFunctions
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
    Prefix = 'Semicolon'
})

local Command = Window:AddCommand('print', {'string'}, 'print a string', function(Arguments, Speaker)
    print(Arguments[1])
end)
