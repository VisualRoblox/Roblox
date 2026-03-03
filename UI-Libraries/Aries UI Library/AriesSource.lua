-- // Aries UI Library
-- // Version 1.0.0

-- // Services
local CoreGui = game:GetService('CoreGui')
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local TextService = game:GetService('TextService')
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local Lighting = game:GetService('Lighting')

-- // Variables
local Color, Insert = Color3.fromRGB, table.insert
local BreakAllLoops = false
local Utility = {}
local Library = {}
local Notifications = {}

-- // Library Defaults
Library.Themes = {
    Dark = {
        BackgroundColor    = Color(19, 18, 22),
        SecondaryColor     = Color(18, 19, 23),
        TertiaryColor      = Color(13, 15, 18),
        AccentColor        = Color(70, 70, 70),
        Color              = Color(254, 51, 61),
        PrimaryTextColor   = Color(230, 230, 230),
        SecondaryTextColor = Color(105, 105, 105)
    },
    Light = {
        BackgroundColor    = Color(240, 240, 245),
        SecondaryColor     = Color(225, 225, 232),
        TertiaryColor      = Color(210, 210, 218),
        AccentColor        = Color(180, 180, 190),
        Color              = Color(254, 51, 61),
        PrimaryTextColor   = Color(20, 20, 20),
        SecondaryTextColor = Color(100, 100, 110)
    },
    Ocean = {
        BackgroundColor    = Color(10, 25, 47),
        SecondaryColor     = Color(15, 32, 58),
        TertiaryColor      = Color(8, 20, 38),
        AccentColor        = Color(30, 80, 130),
        Color              = Color(0, 150, 255),
        PrimaryTextColor   = Color(220, 235, 255),
        SecondaryTextColor = Color(80, 130, 190)
    }
}

-- // Utility Functions
do
    function Utility:Create(_Instance, Properties, Children)
        local Object = Instance.new(_Instance)
        Properties = Properties or {}
        Children   = Children   or {}

        for Index, Property in next, Properties do
            Object[Index] = Property
        end
        for _, Child in next, Children do
            Child.Parent = Object
        end
        return Object
    end

    function Utility:Tween(Inst, Props, Duration, Style, Direction)
        Style     = Style     or Enum.EasingStyle.Quad
        Direction = Direction or Enum.EasingDirection.Out
        local Info = TweenInfo.new(Duration, Style, Direction)
        TweenService:Create(Inst, Info, Props):Play()
    end

    function Utility:Log(Type, Message)
        Type = Type:lower()
        if Type == 'error' then
            error('[ Aries ] Error: ' .. Message)
        elseif Type == 'log' then
            print('[ Aries ] ' .. Message)
        elseif Type == 'warn' then
            warn('[ Aries ] Warning: ' .. Message)
        end
    end

    function Utility:Destroy()
        BreakAllLoops = true
        for _, UI in next, CoreGui:GetChildren() do
            if UI.Name == 'AriesUILibrary' then
                UI:Destroy()
            end
        end
        -- destroy notification holder
        for _, UI in next, CoreGui:GetChildren() do
            if UI.Name == 'AriesNotifications' then
                UI:Destroy()
            end
        end
    end

    function Utility:EnableDragging(Frame)
        local Dragging, DraggingInput, DragStart, StartPosition

        local function Update(Input)
            local Delta = Input.Position - DragStart
            Frame.Position = UDim2.new(
                StartPosition.X.Scale, StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y
            )
        end

        Frame.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging      = true
                DragStart     = Input.Position
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

    function Utility:MakeScrolling(Frame, CanvasSize)
        local UIListLayout = Utility:Create('UIListLayout', {
            Parent          = Frame,
            SortOrder       = Enum.SortOrder.LayoutOrder,
            Padding         = UDim.new(0, 6)
        })
        Frame.CanvasSize = UDim2.new(0, 0, 0, 0)

        UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
            Frame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 12)
        end)

        return UIListLayout
    end
end

-- ///////////////////////////////////////////////////////////
-- // Library Main
-- ///////////////////////////////////////////////////////////
function Library:CreateWindow(Properties)
    local Name               = Properties.Name               or 'Aries UI Library'
    local IntroText          = Properties.IntroText          or 'Aries UI Library'
    local IntroIcon          = Properties.IntroIcon          or 'rbxassetid://10618644218'
    local IntroBlur          = Properties.IntroBlur          ~= nil and Properties.IntroBlur or true
    local IntroBlurIntensity = Properties.IntroBlurIntensity or 15
    local Theme              = Properties.Theme              or Library.Themes.Dark

    Library.Theme   = Theme
    Library.Visible = true
    BreakAllLoops   = false

    if type(Theme) == 'table' and not Library.Themes[tostring(Theme)] then
        Library.Themes['Custom'] = Theme
    end

    Utility:Destroy()
    BreakAllLoops = false

    -- // Notification ScreenGui
    local NotifGui = Utility:Create('ScreenGui', {
        Parent       = CoreGui,
        Name         = 'AriesNotifications',
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    -- // Notification holder (bottom-right stacking)
    local NotifHolder = Utility:Create('Frame', {
        Parent              = NotifGui,
        Name                = 'NotifHolder',
        BackgroundTransparency = 1,
        AnchorPoint         = Vector2.new(1, 1),
        Position            = UDim2.new(1, -16, 1, -16),
        Size                = UDim2.new(0, 280, 1, -32),
    }, {
        Utility:Create('UIListLayout', {
            SortOrder        = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding          = UDim.new(0, 8)
        })
    })

    -- // Main ScreenGui
    local Container = Utility:Create('ScreenGui', {
        Parent          = CoreGui,
        Name            = 'AriesUILibrary',
        ResetOnSpawn    = false,
        ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    })

    -- // Intro Frame
    local Main = Utility:Create('Frame', {
        Name                  = 'Main',
        Parent                = Container,
        BackgroundColor3      = Library.Theme.BackgroundColor,
        BorderSizePixel       = 0,
        BackgroundTransparency = 1,
        AnchorPoint           = Vector2.new(0.5, 0.5),
        Position              = UDim2.new(0.5, 0, 0.5, 0),
        Size                  = UDim2.new(0, 0, 0, 0)
    }, {
        Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
        Utility:Create('TextLabel', {
            Name                  = 'IntroText',
            BackgroundTransparency = 1,
            TextTransparency      = 1,
            AnchorPoint           = Vector2.new(0.5, 0.5),
            Position              = UDim2.new(0.5, 0, 0.5, -30),
            BorderSizePixel       = 0,
            Size                  = UDim2.new(0, 220, 0, 24),
            Font                  = Enum.Font.GothamBold,
            Text                  = IntroText,
            TextColor3            = Library.Theme.PrimaryTextColor,
            TextSize              = 20,
            ZIndex                = 2,
        }),
        Utility:Create('ImageLabel', {
            Name                  = 'IntroImage',
            BackgroundTransparency = 1,
            ImageTransparency     = 1,
            BorderSizePixel       = 0,
            AnchorPoint           = Vector2.new(0.5, 0.5),
            Position              = UDim2.new(0.5, 0, 0.5, 20),
            ZIndex                = 3,
            Size                  = UDim2.new(0, 80, 0, 80),
            Image                 = IntroIcon,
            ScaleType             = Enum.ScaleType.Fit
        })
    })

    -- Dragging
    Utility:EnableDragging(Main)

    -- Intro blur
    if IntroBlur then
        local Blur = Utility:Create('BlurEffect', {
            Name   = 'AriesIntroBlur',
            Parent = Lighting,
            Size   = 0
        })
        Utility:Tween(Blur, { Size = IntroBlurIntensity }, 1)
        task.wait(1)
    end

    Utility:Tween(Main, { BackgroundTransparency = 0 }, 0)
    Utility:Tween(Main, { Size = UDim2.new(0, 600, 0, 340) }, 0.3)
    task.wait(0.4)
    Utility:Tween(Main['IntroText'],  { TextTransparency = 0 }, 0.25)
    task.wait(0.4)
    Utility:Tween(Main['IntroImage'], { ImageTransparency = 0 }, 0.25)
    task.wait(3)
    Utility:Tween(Main['IntroText'],  { TextTransparency = 1 }, 0.25)
    task.wait(0.4)
    Utility:Tween(Main['IntroImage'], { ImageTransparency = 1 }, 0.25)
    task.wait(0.4)

    if IntroBlur then
        Utility:Tween(Lighting.AriesIntroBlur, { Size = 0 }, 1)
        task.wait(1)
        Lighting.AriesIntroBlur:Destroy()
    end

    Main['IntroText']:Destroy()
    Main['IntroImage']:Destroy()

    Utility:Tween(Main, { Size = UDim2.new(0, 700, 0, 500) }, 0.25)
    Utility:Tween(Main, { BackgroundTransparency = 0 }, 0.1)
    task.wait(0.35)

    -- ///////////////////////////////////////////////////////////
    -- // Build real UI
    -- ///////////////////////////////////////////////////////////

    -- Background texture
    Utility:Create('ImageLabel', {
        Name                  = 'BG',
        Parent                = Main,
        BackgroundTransparency = 1,
        Size                  = UDim2.new(1, 0, 1, 0),
        ZIndex                = 0,
        Image                 = 'rbxassetid://10960421886',
        ImageColor3           = Library.Theme.Color,
        ImageTransparency     = 0.92,
        ScaleType             = Enum.ScaleType.Tile,
        TileSize              = UDim2.new(0, 128, 0, 128)
    })

    -- Top bar
    local TopBar = Utility:Create('Frame', {
        Name             = 'TopBar',
        Parent           = Main,
        BackgroundColor3 = Library.Theme.TertiaryColor,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 36),
        ZIndex           = 3
    }, {
        Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
        Utility:Create('TextLabel', {
            Name                  = 'Title',
            BackgroundTransparency = 1,
            Position              = UDim2.new(0, 12, 0, 0),
            Size                  = UDim2.new(0.6, 0, 1, 0),
            Font                  = Enum.Font.GothamBold,
            Text                  = Name,
            TextColor3            = Library.Theme.PrimaryTextColor,
            TextSize              = 14,
            TextXAlignment        = Enum.TextXAlignment.Left,
            ZIndex                = 4
        }),
        -- Close button
        Utility:Create('TextButton', {
            Name                  = 'CloseBtn',
            BackgroundTransparency = 1,
            AnchorPoint           = Vector2.new(1, 0.5),
            Position              = UDim2.new(1, -8, 0.5, 0),
            Size                  = UDim2.new(0, 24, 0, 24),
            Font                  = Enum.Font.GothamBold,
            Text                  = '✕',
            TextColor3            = Library.Theme.SecondaryTextColor,
            TextSize              = 14,
            ZIndex                = 5
        }),
        -- Minimise button
        Utility:Create('TextButton', {
            Name                  = 'MinBtn',
            BackgroundTransparency = 1,
            AnchorPoint           = Vector2.new(1, 0.5),
            Position              = UDim2.new(1, -34, 0.5, 0),
            Size                  = UDim2.new(0, 24, 0, 24),
            Font                  = Enum.Font.GothamBold,
            Text                  = '–',
            TextColor3            = Library.Theme.SecondaryTextColor,
            TextSize              = 14,
            ZIndex                = 5
        })
    })

    -- Sidebar
    local Sidebar = Utility:Create('Frame', {
        Name             = 'Sidebar',
        Parent           = Main,
        BackgroundColor3 = Library.Theme.SecondaryColor,
        BorderSizePixel  = 0,
        Position         = UDim2.new(0, 0, 0, 36),
        Size             = UDim2.new(0, 160, 1, -36),
        ZIndex           = 2
    }, {
        Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
        -- Sidebar divider line
        Utility:Create('Frame', {
            Name             = 'Line',
            BackgroundColor3 = Library.Theme.AccentColor,
            BorderSizePixel  = 0,
            AnchorPoint      = Vector2.new(1, 0),
            Position         = UDim2.new(1, 0, 0, 0),
            Size             = UDim2.new(0, 1, 1, 0)
        }),
        -- Tab list
        Utility:Create('ScrollingFrame', {
            Name                  = 'TabList',
            BackgroundTransparency = 1,
            BorderSizePixel       = 0,
            Position              = UDim2.new(0, 0, 0, 8),
            Size                  = UDim2.new(1, -1, 1, -16),
            ScrollBarThickness    = 2,
            ScrollBarImageColor3  = Library.Theme.AccentColor,
            CanvasSize            = UDim2.new(0, 0, 0, 0)
        }, {
            Utility:Create('UIPadding', { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }),
            Utility:Create('UIListLayout', {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding   = UDim.new(0, 4)
            })
        })
    })

    -- Content area
    local ContentArea = Utility:Create('Frame', {
        Name                  = 'ContentArea',
        Parent                = Main,
        BackgroundTransparency = 1,
        BorderSizePixel       = 0,
        Position              = UDim2.new(0, 168, 0, 44),
        Size                  = UDim2.new(1, -176, 1, -52),
        ZIndex                = 2,
        ClipsDescendants      = true
    })

    -- Reference the tab list layout for canvas resizing
    local TabListLayout = Sidebar.TabList:FindFirstChildOfClass('UIListLayout')
    TabListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
        Sidebar.TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 16)
    end)

    -- Close / Minimise
    local minimised = false
    local originalSize = UDim2.new(0, 700, 0, 500)

    TopBar.CloseBtn.MouseButton1Click:Connect(function()
        Utility:Destroy()
    end)

    TopBar.MinBtn.MouseButton1Click:Connect(function()
        minimised = not minimised
        if minimised then
            Utility:Tween(Main, { Size = UDim2.new(0, 700, 0, 36) }, 0.25)
        else
            Utility:Tween(Main, { Size = originalSize }, 0.25)
        end
    end)

    -- Hover effects on close/min
    for _, Btn in next, { TopBar.CloseBtn, TopBar.MinBtn } do
        Btn.MouseEnter:Connect(function()
            Utility:Tween(Btn, { TextColor3 = Library.Theme.PrimaryTextColor }, 0.15)
        end)
        Btn.MouseLeave:Connect(function()
            Utility:Tween(Btn, { TextColor3 = Library.Theme.SecondaryTextColor }, 0.15)
        end)
    end

    local ActiveTab = nil
    local Window = {}

    -- ///////////////////////////////////////////////////////////
    -- // Notification
    -- ///////////////////////////////////////////////////////////
    function Window:Notify(Title, Message, Duration, NType)
        Duration = Duration or 5
        NType    = NType    or 'Info' -- 'Info' | 'Success' | 'Warning' | 'Error'

        local AccentCol = ({
            Info    = Library.Theme.Color,
            Success = Color(60, 200, 80),
            Warning = Color(255, 180, 0),
            Error   = Color(255, 60, 60)
        })[NType] or Library.Theme.Color

        local Notif = Utility:Create('Frame', {
            Parent           = NotifHolder,
            Name             = 'Notification',
            BackgroundColor3 = Library.Theme.SecondaryColor,
            BorderSizePixel  = 0,
            Size             = UDim2.new(1, 0, 0, 0),
            ClipsDescendants = true,
            ZIndex           = 10
        }, {
            Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
            -- Accent bar
            Utility:Create('Frame', {
                Name             = 'Accent',
                BackgroundColor3 = AccentCol,
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, 4, 1, 0),
                ZIndex           = 11
            }, {
                Utility:Create('UICorner', { CornerRadius = UDim.new(0, 4) })
            }),
            Utility:Create('TextLabel', {
                Name                  = 'Title',
                BackgroundTransparency = 1,
                Position              = UDim2.new(0, 12, 0, 8),
                Size                  = UDim2.new(1, -20, 0, 18),
                Font                  = Enum.Font.GothamBold,
                Text                  = Title,
                TextColor3            = Library.Theme.PrimaryTextColor,
                TextSize              = 13,
                TextXAlignment        = Enum.TextXAlignment.Left,
                ZIndex                = 11
            }),
            Utility:Create('TextLabel', {
                Name                  = 'Message',
                BackgroundTransparency = 1,
                Position              = UDim2.new(0, 12, 0, 28),
                Size                  = UDim2.new(1, -20, 0, 36),
                Font                  = Enum.Font.Gotham,
                Text                  = Message,
                TextColor3            = Library.Theme.SecondaryTextColor,
                TextSize              = 12,
                TextXAlignment        = Enum.TextXAlignment.Left,
                TextWrapped           = true,
                ZIndex                = 11
            }),
            -- Progress bar
            Utility:Create('Frame', {
                Name             = 'Progress',
                BackgroundColor3 = AccentCol,
                BorderSizePixel  = 0,
                Position         = UDim2.new(0, 4, 1, -3),
                Size             = UDim2.new(1, -4, 0, 3),
                ZIndex           = 11
            }, {
                Utility:Create('UICorner', { CornerRadius = UDim.new(0, 2) })
            })
        })

        Utility:Tween(Notif, { Size = UDim2.new(1, 0, 0, 76) }, 0.3)
        Utility:Tween(Notif.Progress, { Size = UDim2.new(0, 0, 0, 3) }, Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

        task.delay(Duration, function()
            Utility:Tween(Notif, { Size = UDim2.new(1, 0, 0, 0) }, 0.3)
            task.wait(0.35)
            Notif:Destroy()
        end)

        return Notif
    end

    -- ///////////////////////////////////////////////////////////
    -- // Toggle UI visibility
    -- ///////////////////////////////////////////////////////////
    function Window:Toggle()
        Library.Visible = not Library.Visible
        Main.Visible    = Library.Visible
    end

    -- ///////////////////////////////////////////////////////////
    -- // CreateTab
    -- ///////////////////////////////////////////////////////////
    function Window:CreateTab(TabName, Icon)
        local TabButton = Utility:Create('TextButton', {
            Parent           = Sidebar.TabList,
            Name             = TabName,
            BackgroundColor3 = Library.Theme.TertiaryColor,
            BackgroundTransparency = 1,
            BorderSizePixel  = 0,
            Size             = UDim2.new(1, 0, 0, 34),
            Font             = Enum.Font.Gotham,
            Text             = '',
            TextSize         = 13,
            AutoButtonColor  = false
        }, {
            Utility:Create('UICorner', { CornerRadius = UDim.new(0, 6) }),
            Utility:Create('TextLabel', {
                Name                  = 'Label',
                BackgroundTransparency = 1,
                Position              = Icon and UDim2.new(0, 30, 0, 0) or UDim2.new(0, 10, 0, 0),
                Size                  = UDim2.new(1, -40, 1, 0),
                Font                  = Enum.Font.Gotham,
                Text                  = TabName,
                TextColor3            = Library.Theme.SecondaryTextColor,
                TextSize              = 13,
                TextXAlignment        = Enum.TextXAlignment.Left
            })
        })

        if Icon then
            Utility:Create('ImageLabel', {
                Parent                = TabButton,
                Name                  = 'Icon',
                BackgroundTransparency = 1,
                AnchorPoint           = Vector2.new(0, 0.5),
                Position              = UDim2.new(0, 8, 0.5, 0),
                Size                  = UDim2.new(0, 18, 0, 18),
                Image                 = Icon
            })
        end

        -- Content page for this tab
        local Page = Utility:Create('ScrollingFrame', {
            Parent                = ContentArea,
            Name                  = TabName .. 'Page',
            BackgroundTransparency = 1,
            BorderSizePixel       = 0,
            Position              = UDim2.new(0, 0, 0, 0),
            Size                  = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness    = 3,
            ScrollBarImageColor3  = Library.Theme.AccentColor,
            CanvasSize            = UDim2.new(0, 0, 0, 0),
            Visible               = false
        })

        local PageLayout = Utility:Create('UIListLayout', {
            Parent    = Page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding   = UDim.new(0, 8)
        })

        Utility:Create('UIPadding', {
            Parent       = Page,
            PaddingTop   = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 4)
        })

        PageLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 18)
        end)

        local function SelectTab()
            if ActiveTab then
                Utility:Tween(ActiveTab.Button, { BackgroundTransparency = 1 }, 0.15)
                Utility:Tween(ActiveTab.Button.Label, { TextColor3 = Library.Theme.SecondaryTextColor }, 0.15)
                ActiveTab.Page.Visible = false
            end

            Utility:Tween(TabButton, { BackgroundTransparency = 0 }, 0.15)
            Utility:Tween(TabButton.Label, { TextColor3 = Library.Theme.PrimaryTextColor }, 0.15)
            Page.Visible = true

            ActiveTab = { Button = TabButton, Page = Page }
        end

        TabButton.MouseButton1Click:Connect(SelectTab)

        TabButton.MouseEnter:Connect(function()
            if ActiveTab and ActiveTab.Button == TabButton then return end
            Utility:Tween(TabButton, { BackgroundTransparency = 0.6 }, 0.15)
        end)
        TabButton.MouseLeave:Connect(function()
            if ActiveTab and ActiveTab.Button == TabButton then return end
            Utility:Tween(TabButton, { BackgroundTransparency = 1 }, 0.15)
        end)

        if not ActiveTab then
            SelectTab()
        end

        local Tab = {}

        -- ///////////////////////////////////////////////////////////
        -- // CreateSection
        -- ///////////////////////////////////////////////////////////
        function Tab:CreateSection(SectionName)
            local SectionFrame = Utility:Create('Frame', {
                Parent           = Page,
                Name             = SectionName,
                BackgroundColor3 = Library.Theme.SecondaryColor,
                BorderSizePixel  = 0,
                Size             = UDim2.new(1, -4, 0, 32),
                AutomaticSize    = Enum.AutomaticSize.Y
            }, {
                Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
                Utility:Create('UIPadding', {
                    PaddingTop    = UDim.new(0, 28),
                    PaddingLeft   = UDim.new(0, 8),
                    PaddingRight  = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 8)
                }),
                Utility:Create('TextLabel', {
                    Name                  = 'SectionTitle',
                    BackgroundTransparency = 1,
                    Position              = UDim2.new(0, 8, 0, 6),
                    Size                  = UDim2.new(1, -16, 0, 18),
                    Font                  = Enum.Font.GothamBold,
                    Text                  = SectionName,
                    TextColor3            = Library.Theme.PrimaryTextColor,
                    TextSize              = 13,
                    TextXAlignment        = Enum.TextXAlignment.Left,
                }),
                -- Divider under title
                Utility:Create('Frame', {
                    Name             = 'Divider',
                    BackgroundColor3 = Library.Theme.AccentColor,
                    BorderSizePixel  = 0,
                    Position         = UDim2.new(0, 0, 0, 24),
                    Size             = UDim2.new(1, 0, 0, 1)
                })
            })

            local SectionList = Utility:Create('UIListLayout', {
                Parent    = SectionFrame,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding   = UDim.new(0, 6)
            })

            SectionList:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                SectionFrame.Size = UDim2.new(1, -4, 0, SectionList.AbsoluteContentSize.Y + 36 + 8)
            end)

            local Section = {}

            -- // Helper: element row
            local function MakeRow(LabelText, Height)
                Height = Height or 30
                local Row = Utility:Create('Frame', {
                    Parent           = SectionFrame,
                    BackgroundTransparency = 1,
                    Size             = UDim2.new(1, 0, 0, Height),
                    Name             = LabelText
                })
                Utility:Create('TextLabel', {
                    Parent                = Row,
                    BackgroundTransparency = 1,
                    Position              = UDim2.new(0, 0, 0, 0),
                    Size                  = UDim2.new(0.55, 0, 1, 0),
                    Font                  = Enum.Font.Gotham,
                    Text                  = LabelText,
                    TextColor3            = Library.Theme.PrimaryTextColor,
                    TextSize              = 12,
                    TextXAlignment        = Enum.TextXAlignment.Left
                })
                return Row
            end

            -- ///////////////////////////////////////////////////////////
            -- // Label
            -- ///////////////////////////////////////////////////////////
            function Section:CreateLabel(Text)
                local LabelFrame = Utility:Create('Frame', {
                    Parent                = SectionFrame,
                    BackgroundTransparency = 1,
                    Size                  = UDim2.new(1, 0, 0, 22),
                    Name                  = 'Label_' .. Text
                })
                local LabelText = Utility:Create('TextLabel', {
                    Parent                = LabelFrame,
                    BackgroundTransparency = 1,
                    Size                  = UDim2.new(1, 0, 1, 0),
                    Font                  = Enum.Font.Gotham,
                    Text                  = Text,
                    TextColor3            = Library.Theme.SecondaryTextColor,
                    TextSize              = 12,
                    TextXAlignment        = Enum.TextXAlignment.Left,
                    TextWrapped           = true
                })

                local LabelObj = {}
                function LabelObj:Set(NewText)
                    LabelText.Text = NewText
                end
                return LabelObj
            end

            -- ///////////////////////////////////////////////////////////
            -- // Paragraph
            -- ///////////////////////////////////////////////////////////
            function Section:CreateParagraph(Title, Content)
                local Para = Utility:Create('Frame', {
                    Parent                = SectionFrame,
                    BackgroundTransparency = 1,
                    Size                  = UDim2.new(1, 0, 0, 44),
                    Name                  = 'Para_' .. Title,
                    AutomaticSize         = Enum.AutomaticSize.Y
                }, {
                    Utility:Create('TextLabel', {
                        Name                  = 'Title',
                        BackgroundTransparency = 1,
                        Size                  = UDim2.new(1, 0, 0, 18),
                        Font                  = Enum.Font.GothamBold,
                        Text                  = Title,
                        TextColor3            = Library.Theme.PrimaryTextColor,
                        TextSize              = 12,
                        TextXAlignment        = Enum.TextXAlignment.Left
                    }),
                    Utility:Create('TextLabel', {
                        Name                  = 'Content',
                        BackgroundTransparency = 1,
                        Position              = UDim2.new(0, 0, 0, 20),
                        Size                  = UDim2.new(1, 0, 0, 24),
                        Font                  = Enum.Font.Gotham,
                        Text                  = Content,
                        TextColor3            = Library.Theme.SecondaryTextColor,
                        TextSize              = 12,
                        TextXAlignment        = Enum.TextXAlignment.Left,
                        TextWrapped           = true,
                        AutomaticSize         = Enum.AutomaticSize.Y
                    })
                })

                local ParaObj = {}
                function ParaObj:Set(NewTitle, NewContent)
                    Para.Title.Text   = NewTitle   or Para.Title.Text
                    Para.Content.Text = NewContent or Para.Content.Text
                end
                return ParaObj
            end

            -- ///////////////////////////////////////////////////////////
            -- // Button
            -- ///////////////////////////////////////////////////////////
            function Section:CreateButton(Text, Callback)
                Callback = Callback or function() end
                local Btn = Utility:Create('TextButton', {
                    Parent           = SectionFrame,
                    BackgroundColor3 = Library.Theme.TertiaryColor,
                    BorderSizePixel  = 0,
                    Size             = UDim2.new(1, 0, 0, 30),
                    Font             = Enum.Font.Gotham,
                    Text             = Text,
                    TextColor3       = Library.Theme.PrimaryTextColor,
                    TextSize         = 12,
                    AutoButtonColor  = false,
                    Name             = 'Btn_' .. Text
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 6) }),
                    Utility:Create('UIStroke', {
                        Color     = Library.Theme.AccentColor,
                        Thickness = 1,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    })
                })

                Btn.MouseEnter:Connect(function()
                    Utility:Tween(Btn, { BackgroundColor3 = Library.Theme.AccentColor }, 0.15)
                end)
                Btn.MouseLeave:Connect(function()
                    Utility:Tween(Btn, { BackgroundColor3 = Library.Theme.TertiaryColor }, 0.15)
                end)
                Btn.MouseButton1Click:Connect(function()
                    Utility:Tween(Btn, { BackgroundColor3 = Library.Theme.Color }, 0.1)
                    task.wait(0.1)
                    Utility:Tween(Btn, { BackgroundColor3 = Library.Theme.TertiaryColor }, 0.1)
                    pcall(Callback)
                end)

                local BtnObj = {}
                function BtnObj:SetText(T) Btn.Text = T end
                return BtnObj
            end

            -- ///////////////////////////////////////////////////////////
            -- // Toggle
            -- ///////////////////////////////////////////////////////////
            function Section:CreateToggle(Text, Default, Callback)
                Default  = Default  ~= nil and Default or false
                Callback = Callback or function() end

                local State = Default

                local Row = Utility:Create('Frame', {
                    Parent                = SectionFrame,
                    BackgroundTransparency = 1,
                    Size                  = UDim2.new(1, 0, 0, 30),
                    Name                  = 'Toggle_' .. Text
                })

                Utility:Create('TextLabel', {
                    Parent                = Row,
                    BackgroundTransparency = 1,
                    Position              = UDim2.new(0, 0, 0, 0),
                    Size                  = UDim2.new(1, -54, 1, 0),
                    Font                  = Enum.Font.Gotham,
                    Text                  = Text,
                    TextColor3            = Library.Theme.PrimaryTextColor,
                    TextSize              = 12,
                    TextXAlignment        = Enum.TextXAlignment.Left
                })

                local TrackBG = Utility:Create('Frame', {
                    Parent           = Row,
                    Name             = 'Track',
                    BackgroundColor3 = State and Library.Theme.Color or Library.Theme.AccentColor,
                    BorderSizePixel  = 0,
                    AnchorPoint      = Vector2.new(1, 0.5),
                    Position         = UDim2.new(1, 0, 0.5, 0),
                    Size             = UDim2.new(0, 44, 0, 22)
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(1, 0) })
                })

                local Knob = Utility:Create('Frame', {
                    Parent           = TrackBG,
                    Name             = 'Knob',
                    BackgroundColor3 = Color(255, 255, 255),
                    BorderSizePixel  = 0,
                    AnchorPoint      = Vector2.new(0, 0.5),
                    Position         = State and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                    Size             = UDim2.new(0, 18, 0, 18)
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(1, 0) })
                })

                local ToggleBtn = Utility:Create('TextButton', {
                    Parent                = Row,
                    BackgroundTransparency = 1,
                    Size                  = UDim2.new(1, 0, 1, 0),
                    Text                  = '',
                    ZIndex                = 5
                })

                local function UpdateToggle()
                    if State then
                        Utility:Tween(TrackBG, { BackgroundColor3 = Library.Theme.Color }, 0.15)
                        Utility:Tween(Knob, { Position = UDim2.new(1, -20, 0.5, 0) }, 0.15)
                    else
                        Utility:Tween(TrackBG, { BackgroundColor3 = Library.Theme.AccentColor }, 0.15)
                        Utility:Tween(Knob, { Position = UDim2.new(0, 2, 0.5, 0) }, 0.15)
                    end
                    pcall(Callback, State)
                end

                ToggleBtn.MouseButton1Click:Connect(function()
                    State = not State
                    UpdateToggle()
                end)

                local ToggleObj = {}
                function ToggleObj:Set(Val)
                    State = Val
                    UpdateToggle()
                end
                function ToggleObj:Get() return State end
                return ToggleObj
            end

            -- ///////////////////////////////////////////////////////////
            -- // Slider
            -- ///////////////////////////////////////////////////////////
            function Section:CreateSlider(Text, Min, Max, Default, Callback)
                Min      = Min      or 0
                Max      = Max      or 100
                Default  = Default  or Min
                Callback = Callback or function() end

                local Value = math.clamp(Default, Min, Max)

                local Holder = Utility:Create('Frame', {
                    Parent                = SectionFrame,
                    BackgroundTransparency = 1,
                    Size                  = UDim2.new(1, 0, 0, 44),
                    Name                  = 'Slider_' .. Text
                })

                Utility:Create('TextLabel', {
                    Parent                = Holder,
                    BackgroundTransparency = 1,
                    Position              = UDim2.new(0, 0, 0, 0),
                    Size                  = UDim2.new(0.7, 0, 0, 20),
                    Font                  = Enum.Font.Gotham,
                    Text                  = Text,
                    TextColor3            = Library.Theme.PrimaryTextColor,
                    TextSize              = 12,
                    TextXAlignment        = Enum.TextXAlignment.Left
                })

                local ValueLabel = Utility:Create('TextLabel', {
                    Parent                = Holder,
                    BackgroundTransparency = 1,
                    AnchorPoint           = Vector2.new(1, 0),
                    Position              = UDim2.new(1, 0, 0, 0),
                    Size                  = UDim2.new(0.3, 0, 0, 20),
                    Font                  = Enum.Font.Gotham,
                    Text                  = tostring(Value),
                    TextColor3            = Library.Theme.SecondaryTextColor,
                    TextSize              = 12,
                    TextXAlignment        = Enum.TextXAlignment.Right
                })

                local Track = Utility:Create('Frame', {
                    Parent           = Holder,
                    BackgroundColor3 = Library.Theme.TertiaryColor,
                    BorderSizePixel  = 0,
                    Position         = UDim2.new(0, 0, 0, 28),
                    Size             = UDim2.new(1, 0, 0, 8)
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(1, 0) })
                })

                local Fill = Utility:Create('Frame', {
                    Parent           = Track,
                    BackgroundColor3 = Library.Theme.Color,
                    BorderSizePixel  = 0,
                    Size             = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(1, 0) })
                })

                local Knob = Utility:Create('Frame', {
                    Parent           = Track,
                    BackgroundColor3 = Color(255, 255, 255),
                    BorderSizePixel  = 0,
                    AnchorPoint      = Vector2.new(0.5, 0.5),
                    Position         = UDim2.new((Value - Min) / (Max - Min), 0, 0.5, 0),
                    Size             = UDim2.new(0, 14, 0, 14),
                    ZIndex           = 3
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(1, 0) })
                })

                local Sliding = false
                Track.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Sliding = true
                    end
                end)

                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Sliding = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(Input)
                    if Sliding and Input.UserInputType == Enum.UserInputType.MouseMovement then
                        local TrackAbs = Track.AbsolutePosition
                        local TrackSize = Track.AbsoluteSize
                        local Ratio = math.clamp((Input.Position.X - TrackAbs.X) / TrackSize.X, 0, 1)
                        Value = math.round(Min + (Max - Min) * Ratio)
                        Fill.Size = UDim2.new(Ratio, 0, 1, 0)
                        Knob.Position = UDim2.new(Ratio, 0, 0.5, 0)
                        ValueLabel.Text = tostring(Value)
                        pcall(Callback, Value)
                    end
                end)

                local SliderObj = {}
                function SliderObj:Set(Val)
                    Val   = math.clamp(Val, Min, Max)
                    Value = Val
                    local R = (Val - Min) / (Max - Min)
                    Fill.Size     = UDim2.new(R, 0, 1, 0)
                    Knob.Position = UDim2.new(R, 0, 0.5, 0)
                    ValueLabel.Text = tostring(Val)
                    pcall(Callback, Val)
                end
                function SliderObj:Get() return Value end
                return SliderObj
            end

            -- ///////////////////////////////////////////////////////////
            -- // Textbox
            -- ///////////////////////////////////////////////////////////
            function Section:CreateTextbox(Text, Placeholder, Callback)
                Callback    = Callback    or function() end
                Placeholder = Placeholder or ''

                local Row = Utility:Create('Frame', {
                    Parent                = SectionFrame,
                    BackgroundTransparency = 1,
                    Size                  = UDim2.new(1, 0, 0, 30),
                    Name                  = 'Textbox_' .. Text
                })

                Utility:Create('TextLabel', {
                    Parent                = Row,
                    BackgroundTransparency = 1,
                    Position              = UDim2.new(0, 0, 0, 0),
                    Size                  = UDim2.new(0.45, 0, 1, 0),
                    Font                  = Enum.Font.Gotham,
                    Text                  = Text,
                    TextColor3            = Library.Theme.PrimaryTextColor,
                    TextSize              = 12,
                    TextXAlignment        = Enum.TextXAlignment.Left
                })

                local BoxBG = Utility:Create('Frame', {
                    Parent           = Row,
                    BackgroundColor3 = Library.Theme.TertiaryColor,
                    BorderSizePixel  = 0,
                    AnchorPoint      = Vector2.new(1, 0.5),
                    Position         = UDim2.new(1, 0, 0.5, 0),
                    Size             = UDim2.new(0.52, 0, 0, 24)
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 6) }),
                    Utility:Create('UIStroke', {
                        Color     = Library.Theme.AccentColor,
                        Thickness = 1,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    })
                })

                local Box = Utility:Create('TextBox', {
                    Parent                = BoxBG,
                    BackgroundTransparency = 1,
                    ClearTextOnFocus      = false,
                    PlaceholderText       = Placeholder,
                    PlaceholderColor3     = Library.Theme.SecondaryTextColor,
                    Position              = UDim2.new(0, 6, 0, 0),
                    Size                  = UDim2.new(1, -12, 1, 0),
                    Font                  = Enum.Font.Gotham,
                    Text                  = '',
                    TextColor3            = Library.Theme.PrimaryTextColor,
                    TextSize              = 12,
                    TextXAlignment        = Enum.TextXAlignment.Left
                })

                Box.FocusLost:Connect(function(EnterPressed)
                    if EnterPressed then
                        pcall(Callback, Box.Text)
                    end
                end)

                Box.Focused:Connect(function()
                    Utility:Tween(BoxBG:FindFirstChildOfClass('UIStroke'), { Color = Library.Theme.Color }, 0.15)
                end)
                Box.FocusLost:Connect(function()
                    Utility:Tween(BoxBG:FindFirstChildOfClass('UIStroke'), { Color = Library.Theme.AccentColor }, 0.15)
                end)

                local TBObj = {}
                function TBObj:Set(Val) Box.Text = Val end
                function TBObj:Get() return Box.Text end
                return TBObj
            end

            -- ///////////////////////////////////////////////////////////
            -- // Keybind
            -- ///////////////////////////////////////////////////////////
            function Section:CreateKeybind(Text, Default, Callback)
                Default  = Default  or 'None'
                Callback = Callback or function() end

                local CurrentKey = Default
                local Listening  = false

                local Row = Utility:Create('Frame', {
                    Parent                = SectionFrame,
                    BackgroundTransparency = 1,
                    Size                  = UDim2.new(1, 0, 0, 30),
                    Name                  = 'Keybind_' .. Text
                })

                Utility:Create('TextLabel', {
                    Parent                = Row,
                    BackgroundTransparency = 1,
                    Position              = UDim2.new(0, 0, 0, 0),
                    Size                  = UDim2.new(0.6, 0, 1, 0),
                    Font                  = Enum.Font.Gotham,
                    Text                  = Text,
                    TextColor3            = Library.Theme.PrimaryTextColor,
                    TextSize              = 12,
                    TextXAlignment        = Enum.TextXAlignment.Left
                })

                local KeyBtn = Utility:Create('TextButton', {
                    Parent           = Row,
                    BackgroundColor3 = Library.Theme.TertiaryColor,
                    BorderSizePixel  = 0,
                    AnchorPoint      = Vector2.new(1, 0.5),
                    Position         = UDim2.new(1, 0, 0.5, 0),
                    Size             = UDim2.new(0, 68, 0, 24),
                    Font             = Enum.Font.Gotham,
                    Text             = CurrentKey,
                    TextColor3       = Library.Theme.PrimaryTextColor,
                    TextSize         = 11,
                    AutoButtonColor  = false
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 6) }),
                    Utility:Create('UIStroke', {
                        Color     = Library.Theme.AccentColor,
                        Thickness = 1,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    })
                })

                KeyBtn.MouseButton1Click:Connect(function()
                    Listening = true
                    KeyBtn.Text = '...'
                    Utility:Tween(KeyBtn:FindFirstChildOfClass('UIStroke'), { Color = Library.Theme.Color }, 0.15)
                end)

                UserInputService.InputBegan:Connect(function(Input, Processed)
                    if Listening and not Processed then
                        if Input.UserInputType == Enum.UserInputType.Keyboard then
                            CurrentKey = Input.KeyCode.Name
                            Listening  = false
                            KeyBtn.Text = CurrentKey
                            Utility:Tween(KeyBtn:FindFirstChildOfClass('UIStroke'), { Color = Library.Theme.AccentColor }, 0.15)
                        end
                    elseif not Listening and Input.UserInputType == Enum.UserInputType.Keyboard then
                        if Input.KeyCode.Name == CurrentKey then
                            pcall(Callback)
                        end
                    end
                end)

                local KBObj = {}
                function KBObj:Set(Key)
                    CurrentKey = Key
                    KeyBtn.Text = Key
                end
                function KBObj:Get() return CurrentKey end
                return KBObj
            end

            -- ///////////////////////////////////////////////////////////
            -- // Dropdown
            -- ///////////////////////////////////////////////////////////
            function Section:CreateDropdown(Text, Options, Default, Callback)
                Options  = Options  or {}
                Callback = Callback or function() end

                local Selected = Default or (Options[1] or 'None')
                local Open     = false

                local Holder = Utility:Create('Frame', {
                    Parent           = SectionFrame,
                    BackgroundTransparency = 1,
                    Size             = UDim2.new(1, 0, 0, 30),
                    Name             = 'Dropdown_' .. Text,
                    ClipsDescendants = false,
                    ZIndex           = 10
                })

                Utility:Create('TextLabel', {
                    Parent                = Holder,
                    BackgroundTransparency = 1,
                    Position              = UDim2.new(0, 0, 0, 0),
                    Size                  = UDim2.new(0.45, 0, 0, 30),
                    Font                  = Enum.Font.Gotham,
                    Text                  = Text,
                    TextColor3            = Library.Theme.PrimaryTextColor,
                    TextSize              = 12,
                    TextXAlignment        = Enum.TextXAlignment.Left,
                    ZIndex                = 10
                })

                local DropBtn = Utility:Create('TextButton', {
                    Parent           = Holder,
                    BackgroundColor3 = Library.Theme.TertiaryColor,
                    BorderSizePixel  = 0,
                    AnchorPoint      = Vector2.new(1, 0),
                    Position         = UDim2.new(1, 0, 0, 0),
                    Size             = UDim2.new(0.52, 0, 0, 28),
                    Font             = Enum.Font.Gotham,
                    Text             = Selected .. ' ▾',
                    TextColor3       = Library.Theme.PrimaryTextColor,
                    TextSize         = 11,
                    AutoButtonColor  = false,
                    ZIndex           = 10,
                    ClipsDescendants = false
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 6) }),
                    Utility:Create('UIStroke', {
                        Color     = Library.Theme.AccentColor,
                        Thickness = 1,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    })
                })

                local OptionList = Utility:Create('Frame', {
                    Parent           = DropBtn,
                    BackgroundColor3 = Library.Theme.SecondaryColor,
                    BorderSizePixel  = 0,
                    Position         = UDim2.new(0, 0, 1, 4),
                    Size             = UDim2.new(1, 0, 0, 0),
                    ClipsDescendants = true,
                    ZIndex           = 20,
                    Visible          = false
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 6) }),
                    Utility:Create('UIListLayout', {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding   = UDim.new(0, 2)
                    }),
                    Utility:Create('UIPadding', {
                        PaddingTop    = UDim.new(0, 4),
                        PaddingBottom = UDim.new(0, 4),
                        PaddingLeft   = UDim.new(0, 4),
                        PaddingRight  = UDim.new(0, 4)
                    })
                })

                local function RebuildOptions()
                    for _, Child in next, OptionList:GetChildren() do
                        if Child:IsA('TextButton') then Child:Destroy() end
                    end
                    for _, Opt in next, Options do
                        local OptBtn = Utility:Create('TextButton', {
                            Parent           = OptionList,
                            BackgroundColor3 = Library.Theme.TertiaryColor,
                            BackgroundTransparency = Opt == Selected and 0 or 1,
                            BorderSizePixel  = 0,
                            Size             = UDim2.new(1, 0, 0, 24),
                            Font             = Enum.Font.Gotham,
                            Text             = Opt,
                            TextColor3       = Opt == Selected and Library.Theme.PrimaryTextColor or Library.Theme.SecondaryTextColor,
                            TextSize         = 11,
                            AutoButtonColor  = false,
                            ZIndex           = 21
                        }, {
                            Utility:Create('UICorner', { CornerRadius = UDim.new(0, 4) })
                        })

                        OptBtn.MouseEnter:Connect(function()
                            if Opt ~= Selected then
                                Utility:Tween(OptBtn, { BackgroundTransparency = 0.5 }, 0.1)
                            end
                        end)
                        OptBtn.MouseLeave:Connect(function()
                            if Opt ~= Selected then
                                Utility:Tween(OptBtn, { BackgroundTransparency = 1 }, 0.1)
                            end
                        end)
                        OptBtn.MouseButton1Click:Connect(function()
                            Selected    = Opt
                            DropBtn.Text = Opt .. ' ▾'
                            Open        = false
                            Utility:Tween(OptionList, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
                            task.wait(0.2)
                            OptionList.Visible = false
                            RebuildOptions()
                            pcall(Callback, Selected)
                        end)
                    end

                    local Layout = OptionList:FindFirstChildOfClass('UIListLayout')
                    local H = Layout.AbsoluteContentSize.Y + 8
                    return H
                end

                RebuildOptions()

                DropBtn.MouseButton1Click:Connect(function()
                    Open = not Open
                    if Open then
                        OptionList.Visible = true
                        local H = RebuildOptions()
                        Utility:Tween(OptionList, { Size = UDim2.new(1, 0, 0, H) }, 0.2)
                    else
                        Utility:Tween(OptionList, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
                        task.wait(0.2)
                        OptionList.Visible = false
                    end
                end)

                local DDObj = {}
                function DDObj:Set(Val)
                    if table.find(Options, Val) then
                        Selected = Val
                        DropBtn.Text = Val .. ' ▾'
                        RebuildOptions()
                        pcall(Callback, Val)
                    end
                end
                function DDObj:SetOptions(NewOptions)
                    Options = NewOptions
                    RebuildOptions()
                end
                function DDObj:Get() return Selected end
                return DDObj
            end

            -- ///////////////////////////////////////////////////////////
            -- // Colorpicker
            -- ///////////////////////////////////////////////////////////
            function Section:CreateColorpicker(Text, Default, Callback)
                Default  = Default  or Color(255, 255, 255)
                Callback = Callback or function() end

                local CurrentColor = Default
                local Open         = false

                local H, S, V = Color3.toHSV(CurrentColor)

                local Holder = Utility:Create('Frame', {
                    Parent                = SectionFrame,
                    BackgroundTransparency = 1,
                    Size                  = UDim2.new(1, 0, 0, 30),
                    Name                  = 'CP_' .. Text,
                    ClipsDescendants      = false,
                    ZIndex                = 8
                })

                Utility:Create('TextLabel', {
                    Parent                = Holder,
                    BackgroundTransparency = 1,
                    Position              = UDim2.new(0, 0, 0, 0),
                    Size                  = UDim2.new(0.6, 0, 1, 0),
                    Font                  = Enum.Font.Gotham,
                    Text                  = Text,
                    TextColor3            = Library.Theme.PrimaryTextColor,
                    TextSize              = 12,
                    TextXAlignment        = Enum.TextXAlignment.Left,
                    ZIndex                = 8
                })

                local Preview = Utility:Create('TextButton', {
                    Parent           = Holder,
                    BackgroundColor3 = CurrentColor,
                    BorderSizePixel  = 0,
                    AnchorPoint      = Vector2.new(1, 0.5),
                    Position         = UDim2.new(1, 0, 0.5, 0),
                    Size             = UDim2.new(0, 40, 0, 22),
                    Text             = '',
                    AutoButtonColor  = false,
                    ZIndex           = 8
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 6) }),
                    Utility:Create('UIStroke', {
                        Color     = Library.Theme.AccentColor,
                        Thickness = 1,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    })
                })

                -- Picker panel
                local Panel = Utility:Create('Frame', {
                    Parent           = Holder,
                    BackgroundColor3 = Library.Theme.TertiaryColor,
                    BorderSizePixel  = 0,
                    AnchorPoint      = Vector2.new(1, 0),
                    Position         = UDim2.new(1, 0, 1, 6),
                    Size             = UDim2.new(0, 180, 0, 160),
                    Visible          = false,
                    ClipsDescendants = false,
                    ZIndex           = 15
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
                    Utility:Create('UIStroke', {
                        Color     = Library.Theme.AccentColor,
                        Thickness = 1,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    })
                })

                -- SV Gradient picker
                local SVBox = Utility:Create('ImageLabel', {
                    Parent           = Panel,
                    BackgroundColor3 = Color3.fromHSV(H, 1, 1),
                    BorderSizePixel  = 0,
                    Position         = UDim2.new(0, 8, 0, 8),
                    Size             = UDim2.new(1, -16, 0, 100),
                    Image            = 'rbxassetid://4155801252',
                    ZIndex           = 16
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 4) })
                })

                local SVKnob = Utility:Create('Frame', {
                    Parent           = SVBox,
                    BackgroundColor3 = Color(255, 255, 255),
                    BorderSizePixel  = 0,
                    AnchorPoint      = Vector2.new(0.5, 0.5),
                    Position         = UDim2.new(S, 0, 1 - V, 0),
                    Size             = UDim2.new(0, 10, 0, 10),
                    ZIndex           = 17
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(1, 0) }),
                    Utility:Create('UIStroke', { Color = Color(0,0,0), Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
                })

                -- Hue bar
                local HueBar = Utility:Create('ImageLabel', {
                    Parent           = Panel,
                    BackgroundColor3 = Color(255, 255, 255),
                    BorderSizePixel  = 0,
                    Position         = UDim2.new(0, 8, 0, 116),
                    Size             = UDim2.new(1, -16, 0, 14),
                    Image            = 'rbxassetid://4155804796',
                    ZIndex           = 16
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 4) })
                })

                local HueKnob = Utility:Create('Frame', {
                    Parent           = HueBar,
                    BackgroundColor3 = Color(255, 255, 255),
                    BorderSizePixel  = 0,
                    AnchorPoint      = Vector2.new(0.5, 0.5),
                    Position         = UDim2.new(H, 0, 0.5, 0),
                    Size             = UDim2.new(0, 10, 1, 4),
                    ZIndex           = 17
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 3) }),
                    Utility:Create('UIStroke', { Color = Color(0,0,0), Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
                })

                -- Hex input
                local HexBox = Utility:Create('TextBox', {
                    Parent                = Panel,
                    BackgroundColor3      = Library.Theme.SecondaryColor,
                    BorderSizePixel       = 0,
                    Position              = UDim2.new(0, 8, 0, 138),
                    Size                  = UDim2.new(1, -16, 0, 18),
                    Font                  = Enum.Font.Code,
                    Text                  = '',
                    PlaceholderText       = 'Hex #RRGGBB',
                    PlaceholderColor3     = Library.Theme.SecondaryTextColor,
                    TextColor3            = Library.Theme.PrimaryTextColor,
                    TextSize              = 11,
                    ZIndex                = 16
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 4) })
                })

                local function ColorToHex(c)
                    return string.format('#%02X%02X%02X',
                        math.round(c.R * 255),
                        math.round(c.G * 255),
                        math.round(c.B * 255)
                    )
                end

                local function UpdateColor()
                    CurrentColor     = Color3.fromHSV(H, S, V)
                    Preview.BackgroundColor3 = CurrentColor
                    SVBox.BackgroundColor3   = Color3.fromHSV(H, 1, 1)
                    SVKnob.Position          = UDim2.new(S, 0, 1 - V, 0)
                    HueKnob.Position         = UDim2.new(H, 0, 0.5, 0)
                    HexBox.Text              = ColorToHex(CurrentColor)
                    pcall(Callback, CurrentColor)
                end

                -- SV drag
                local SVDragging = false
                SVBox.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        SVDragging = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        SVDragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(Input)
                    if SVDragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                        local Abs = SVBox.AbsolutePosition
                        local Sz  = SVBox.AbsoluteSize
                        S = math.clamp((Input.Position.X - Abs.X) / Sz.X, 0, 1)
                        V = 1 - math.clamp((Input.Position.Y - Abs.Y) / Sz.Y, 0, 1)
                        UpdateColor()
                    end
                end)

                -- Hue drag
                local HueDragging = false
                HueBar.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        HueDragging = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        HueDragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(Input)
                    if HueDragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                        local Abs = HueBar.AbsolutePosition
                        local Sz  = HueBar.AbsoluteSize
                        H = math.clamp((Input.Position.X - Abs.X) / Sz.X, 0, 1)
                        UpdateColor()
                    end
                end)

                -- Hex input
                HexBox.FocusLost:Connect(function(Enter)
                    if Enter then
                        local Hex = HexBox.Text:gsub('#', '')
                        if #Hex == 6 then
                            local R = tonumber(Hex:sub(1,2), 16)
                            local G = tonumber(Hex:sub(3,4), 16)
                            local B = tonumber(Hex:sub(5,6), 16)
                            if R and G and B then
                                local NewColor = Color3.fromRGB(R, G, B)
                                H, S, V = Color3.toHSV(NewColor)
                                UpdateColor()
                            end
                        end
                    end
                end)

                Preview.MouseButton1Click:Connect(function()
                    Open = not Open
                    Panel.Visible = Open
                    if Open then UpdateColor() end
                end)

                -- Close panel when clicking elsewhere
                UserInputService.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if Open and not Panel.AbsolutePosition then return end
                        -- simple check: if panel is open and mouse not on panel, close
                        task.wait()
                        local MP = UserInputService:GetMouseLocation()
                        if Open then
                            local Abs = Panel.AbsolutePosition
                            local Sz  = Panel.AbsoluteSize
                            if MP.X < Abs.X or MP.X > Abs.X + Sz.X or MP.Y < Abs.Y or MP.Y > Abs.Y + Sz.Y then
                                if not (MP.X >= Preview.AbsolutePosition.X and MP.X <= Preview.AbsolutePosition.X + Preview.AbsoluteSize.X
                                    and MP.Y >= Preview.AbsolutePosition.Y and MP.Y <= Preview.AbsolutePosition.Y + Preview.AbsoluteSize.Y) then
                                    Open = false
                                    Panel.Visible = false
                                end
                            end
                        end
                    end
                end)

                UpdateColor()

                local CPObj = {}
                function CPObj:Set(NewColor)
                    H, S, V = Color3.toHSV(NewColor)
                    UpdateColor()
                end
                function CPObj:Get() return CurrentColor end
                return CPObj
            end

            -- ///////////////////////////////////////////////////////////
            -- // Separator
            -- ///////////////////////////////////////////////////////////
            function Section:CreateSeparator()
                Utility:Create('Frame', {
                    Parent           = SectionFrame,
                    BackgroundColor3 = Library.Theme.AccentColor,
                    BorderSizePixel  = 0,
                    Size             = UDim2.new(1, 0, 0, 1),
                    Name             = 'Separator'
                })
            end

            return Section
        end

        return Tab
    end

    -- ///////////////////////////////////////////////////////////
    -- // ChangeTheme
    -- ///////////////////////////////////////////////////////////
    function Window:ChangeTheme(ThemeName)
        local NewTheme = Library.Themes[ThemeName]
        if not NewTheme then return end
        Library.Theme = NewTheme
        -- Simplified: full re-render would be needed for complete theme swap
        -- This updates the most visible parts
        Main.BackgroundColor3 = NewTheme.BackgroundColor
        Sidebar.BackgroundColor3 = NewTheme.SecondaryColor
        TopBar.BackgroundColor3  = NewTheme.TertiaryColor
    end

    return Window
end

return Library
