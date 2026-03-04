-- // Aries UI Library
-- // Version 1.1.0 - Bugfix Release

-- // Services
local CoreGui          = game:GetService('CoreGui')
local TweenService     = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local Lighting         = game:GetService('Lighting')

-- // Variables
local Color = Color3.fromRGB
local Utility = {}
local Library = {}

-- // Library Defaults
Library.Themes = {
    Dark = {
        BackgroundColor    = Color(19, 18, 22),
        SecondaryColor     = Color(24, 24, 30),
        TertiaryColor      = Color(13, 15, 18),
        AccentColor        = Color(60, 60, 65),
        Color              = Color(254, 51, 61),
        PrimaryTextColor   = Color(230, 230, 230),
        SecondaryTextColor = Color(105, 105, 115)
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

-- ///////////////////////////////////////////////////////////
-- // Utility
-- ///////////////////////////////////////////////////////////
do
    function Utility:Create(_Instance, Properties, Children)
        local Object = Instance.new(_Instance)
        Properties = Properties or {}
        Children   = Children   or {}
        for k, v in next, Properties do Object[k] = v end
        for _, c in next, Children   do c.Parent = Object end
        return Object
    end

    function Utility:Tween(Inst, Props, Duration, Style, Direction)
        Style     = Style     or Enum.EasingStyle.Quad
        Direction = Direction or Enum.EasingDirection.Out
        TweenService:Create(Inst, TweenInfo.new(Duration, Style, Direction), Props):Play()
    end

    function Utility:Destroy()
        for _, UI in next, CoreGui:GetChildren() do
            if UI.Name == 'AriesUILibrary' or UI.Name == 'AriesNotifications' then
                UI:Destroy()
            end
        end
    end

    -- Drag only on the TopBar strip, not the whole Main frame,
    -- so sliders / other inputs can consume mouse without fighting dragging.
    function Utility:EnableDragging(DragHandle, MoveTarget)
        local Dragging, DragStart, StartPos

        DragHandle.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging  = true
                DragStart = Input.Position
                StartPos  = MoveTarget.Position
                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)

        -- ONLY move when DragHandle itself propagated the drag
        DragHandle.InputChanged:Connect(function(Input)
            if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                local Delta = Input.Position - DragStart
                MoveTarget.Position = UDim2.new(
                    StartPos.X.Scale, StartPos.X.Offset + Delta.X,
                    StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
                )
            end
        end)
    end
end

-- ///////////////////////////////////////////////////////////
-- // Library:CreateWindow
-- ///////////////////////////////////////////////////////////
function Library:CreateWindow(Properties)
    local Name               = Properties.Name               or 'Aries UI Library'
    local IntroText          = Properties.IntroText          or 'Aries UI Library'
    local IntroIcon          = Properties.IntroIcon          or 'rbxassetid://10618644218'
    local IntroBlur          = Properties.IntroBlur ~= nil and Properties.IntroBlur or true
    local IntroBlurIntensity = Properties.IntroBlurIntensity or 15
    local Theme              = Properties.Theme              or Library.Themes.Dark

    Library.Theme   = Theme
    Library.Visible = true

    if type(Theme) == 'table' then
        Library.Themes['Custom'] = Theme
    end

    Utility:Destroy()

    -- Theme registry: list of {Instance, Property, ThemeKey}
    -- Used by ChangeTheme to update everything at once
    local ThemeRegistry = {}
    local function TR(inst, prop, key)
        table.insert(ThemeRegistry, { inst, prop, key })
        inst[prop] = Library.Theme[key]
        return inst
    end

    -- ///////////////////////////////////////////////////////////
    -- // Notification ScreenGui (separate, always on top)
    -- ///////////////////////////////////////////////////////////
    local NotifGui = Utility:Create('ScreenGui', {
        Parent          = CoreGui,
        Name            = 'AriesNotifications',
        ResetOnSpawn    = false,
        ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
        DisplayOrder    = 100
    })

    local NotifHolder = Utility:Create('Frame', {
        Parent                = NotifGui,
        Name                  = 'NotifHolder',
        BackgroundTransparency = 1,
        AnchorPoint           = Vector2.new(1, 1),
        Position              = UDim2.new(1, -16, 1, -16),
        Size                  = UDim2.new(0, 280, 1, -32),
    }, {
        Utility:Create('UIListLayout', {
            SortOrder         = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding           = UDim.new(0, 8)
        })
    })

    -- ///////////////////////////////////////////////////////////
    -- // Main ScreenGui
    -- ///////////////////////////////////////////////////////////
    local Container = Utility:Create('ScreenGui', {
        Parent         = CoreGui,
        Name           = 'AriesUILibrary',
        ResetOnSpawn   = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder   = 10
    })

    -- Intro frame
    local Main = Utility:Create('Frame', {
        Name                   = 'Main',
        Parent                 = Container,
        BackgroundColor3       = Library.Theme.BackgroundColor,
        BorderSizePixel        = 0,
        BackgroundTransparency = 1,
        AnchorPoint            = Vector2.new(0.5, 0.5),
        Position               = UDim2.new(0.5, 0, 0.5, 0),
        Size                   = UDim2.new(0, 0, 0, 0),
        ClipsDescendants       = false
    }, {
        Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
        Utility:Create('TextLabel', {
            Name                   = 'IntroText',
            BackgroundTransparency = 1,
            TextTransparency       = 1,
            AnchorPoint            = Vector2.new(0.5, 0.5),
            Position               = UDim2.new(0.5, 0, 0.5, -30),
            BorderSizePixel        = 0,
            Size                   = UDim2.new(0, 220, 0, 24),
            Font                   = Enum.Font.GothamBold,
            Text                   = IntroText,
            TextColor3             = Library.Theme.PrimaryTextColor,
            TextSize               = 20,
            ZIndex                 = 2,
        }),
        Utility:Create('ImageLabel', {
            Name                   = 'IntroImage',
            BackgroundTransparency = 1,
            ImageTransparency      = 1,
            BorderSizePixel        = 0,
            AnchorPoint            = Vector2.new(0.5, 0.5),
            Position               = UDim2.new(0.5, 0, 0.5, 20),
            ZIndex                 = 3,
            Size                   = UDim2.new(0, 80, 0, 80),
            Image                  = IntroIcon,
            ScaleType              = Enum.ScaleType.Fit
        })
    })

    -- Intro sequence
    if IntroBlur then
        local Blur = Utility:Create('BlurEffect', { Name = 'AriesIntroBlur', Parent = Lighting, Size = 0 })
        Utility:Tween(Blur, { Size = IntroBlurIntensity }, 1)
        task.wait(1)
    end

    Utility:Tween(Main, { BackgroundTransparency = 0 }, 0)
    Utility:Tween(Main, { Size = UDim2.new(0, 600, 0, 340) }, 0.3)
    task.wait(0.4)
    Utility:Tween(Main.IntroText,  { TextTransparency = 0 }, 0.25)
    task.wait(0.4)
    Utility:Tween(Main.IntroImage, { ImageTransparency = 0 }, 0.25)
    task.wait(3)
    Utility:Tween(Main.IntroText,  { TextTransparency = 1 }, 0.25)
    task.wait(0.4)
    Utility:Tween(Main.IntroImage, { ImageTransparency = 1 }, 0.25)
    task.wait(0.4)

    if IntroBlur then
        local b = Lighting:FindFirstChild('AriesIntroBlur')
        if b then Utility:Tween(b, { Size = 0 }, 1) end
        task.wait(1)
        if b then b:Destroy() end
    end

    Main.IntroText:Destroy()
    Main.IntroImage:Destroy()

    Utility:Tween(Main, { Size = UDim2.new(0, 700, 0, 500) }, 0.25)
    task.wait(0.3)

    -- ///////////////////////////////////////////////////////////
    -- // Build real UI inside Main
    -- ///////////////////////////////////////////////////////////

    -- BG texture
    Utility:Create('ImageLabel', {
        Name                   = 'BG',
        Parent                 = Main,
        BackgroundTransparency = 1,
        Size                   = UDim2.new(1, 0, 1, 0),
        ZIndex                 = 0,
        Image                  = 'rbxassetid://10960421886',
        ImageColor3            = Library.Theme.Color,
        ImageTransparency      = 0.92,
        ScaleType              = Enum.ScaleType.Tile,
        TileSize               = UDim2.new(0, 128, 0, 128)
    })

    -- Top bar (drag handle)
    local TopBar = Utility:Create('Frame', {
        Name             = 'TopBar',
        Parent           = Main,
        BackgroundColor3 = Library.Theme.TertiaryColor,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 36),
        ZIndex           = 5
    }, {
        Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
        Utility:Create('TextLabel', {
            Name                   = 'Title',
            BackgroundTransparency = 1,
            Position               = UDim2.new(0, 12, 0, 0),
            Size                   = UDim2.new(0.7, 0, 1, 0),
            Font                   = Enum.Font.GothamBold,
            Text                   = Name,
            TextColor3             = Library.Theme.PrimaryTextColor,
            TextSize               = 14,
            TextXAlignment         = Enum.TextXAlignment.Left,
            ZIndex                 = 6
        }),
        Utility:Create('TextButton', {
            Name                   = 'CloseBtn',
            BackgroundTransparency = 1,
            AnchorPoint            = Vector2.new(1, 0.5),
            Position               = UDim2.new(1, -8, 0.5, 0),
            Size                   = UDim2.new(0, 24, 0, 24),
            Font                   = Enum.Font.GothamBold,
            Text                   = '✕',
            TextColor3             = Library.Theme.SecondaryTextColor,
            TextSize               = 14,
            ZIndex                 = 7
        }),
        Utility:Create('TextButton', {
            Name                   = 'MinBtn',
            BackgroundTransparency = 1,
            AnchorPoint            = Vector2.new(1, 0.5),
            Position               = UDim2.new(1, -36, 0.5, 0),
            Size                   = UDim2.new(0, 24, 0, 24),
            Font                   = Enum.Font.GothamBold,
            Text                   = '–',
            TextColor3             = Library.Theme.SecondaryTextColor,
            TextSize               = 14,
            ZIndex                 = 7
        })
    })
    TR(TopBar, 'BackgroundColor3', 'TertiaryColor')

    -- Drag only via TopBar so sliders don't fight it
    Utility:EnableDragging(TopBar, Main)

    -- Sidebar
    local Sidebar = Utility:Create('Frame', {
        Name             = 'Sidebar',
        Parent           = Main,
        BackgroundColor3 = Library.Theme.SecondaryColor,
        BorderSizePixel  = 0,
        Position         = UDim2.new(0, 0, 0, 36),
        Size             = UDim2.new(0, 160, 1, -36),
        ZIndex           = 2,
        ClipsDescendants = true
    }, {
        Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
        Utility:Create('Frame', {
            Name             = 'Line',
            BackgroundColor3 = Library.Theme.AccentColor,
            BorderSizePixel  = 0,
            AnchorPoint      = Vector2.new(1, 0),
            Position         = UDim2.new(1, 0, 0, 0),
            Size             = UDim2.new(0, 1, 1, 0)
        }),
        Utility:Create('ScrollingFrame', {
            Name                   = 'TabList',
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            Position               = UDim2.new(0, 0, 0, 8),
            Size                   = UDim2.new(1, -1, 1, -16),
            ScrollBarThickness     = 2,
            ScrollBarImageColor3   = Library.Theme.AccentColor,
            CanvasSize             = UDim2.new(0, 0, 0, 0)
        }, {
            Utility:Create('UIPadding', { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }),
            Utility:Create('UIListLayout', {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding   = UDim.new(0, 4)
            })
        })
    })
    TR(Sidebar, 'BackgroundColor3', 'SecondaryColor')

    -- Content area
    local ContentArea = Utility:Create('Frame', {
        Name                   = 'ContentArea',
        Parent                 = Main,
        BackgroundTransparency = 1,
        BorderSizePixel        = 0,
        Position               = UDim2.new(0, 168, 0, 44),
        Size                   = UDim2.new(1, -176, 1, -52),
        ZIndex                 = 2,
        ClipsDescendants       = true
    })

    -- Overlay layer for dropdowns & colorpickers (above everything, no clipping)
    local OverlayFrame = Utility:Create('Frame', {
        Name                   = 'OverlayFrame',
        Parent                 = Main,
        BackgroundTransparency = 1,
        BorderSizePixel        = 0,
        Size                   = UDim2.new(1, 0, 1, 0),
        ZIndex                 = 50,
        ClipsDescendants       = false
    })

    -- TabList auto canvas
    local TabListLayout = Sidebar.TabList:FindFirstChildOfClass('UIListLayout')
    TabListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
        Sidebar.TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 16)
    end)

    -- Close / Minimise
    local Minimised  = false
    local FullSize   = UDim2.new(0, 700, 0, 500)

    TopBar.CloseBtn.MouseButton1Click:Connect(function() Utility:Destroy() end)
    TopBar.MinBtn.MouseButton1Click:Connect(function()
        Minimised = not Minimised
        Utility:Tween(Main, { Size = Minimised and UDim2.new(0, 700, 0, 36) or FullSize }, 0.25)
    end)

    for _, Btn in next, { TopBar.CloseBtn, TopBar.MinBtn } do
        Btn.MouseEnter:Connect(function() Utility:Tween(Btn, { TextColor3 = Library.Theme.PrimaryTextColor }, 0.15) end)
        Btn.MouseLeave:Connect(function() Utility:Tween(Btn, { TextColor3 = Library.Theme.SecondaryTextColor }, 0.15) end)
    end

    local ActiveTab = nil
    local Window = {}

    -- ///////////////////////////////////////////////////////////
    -- // Notify
    -- ///////////////////////////////////////////////////////////
    function Window:Notify(Title, Message, Duration, NType)
        Duration = Duration or 5
        NType    = NType    or 'Info'

        local AccentCol = ({
            Info    = Library.Theme.Color,
            Success = Color(60, 200, 80),
            Warning = Color(255, 180, 0),
            Error   = Color(255, 60, 60)
        })[NType] or Library.Theme.Color

        -- Outer wrapper - NO ClipsDescendants so corners are clean
        local Notif = Utility:Create('Frame', {
            Parent           = NotifHolder,
            Name             = 'Notification',
            BackgroundColor3 = Library.Theme.SecondaryColor,
            BorderSizePixel  = 0,
            Size             = UDim2.new(1, 0, 0, 0),
            ZIndex           = 10,
            ClipsDescendants = false   -- FIX: was true, caused corner cut
        }, {
            Utility:Create('UICorner', { CornerRadius = UDim.new(0, 10) })
        })

        -- Left accent bar (separate, NO UICorner conflict)
        Utility:Create('Frame', {
            Parent           = Notif,
            Name             = 'AccentBar',
            BackgroundColor3 = AccentCol,
            BorderSizePixel  = 0,
            Position         = UDim2.new(0, 0, 0, 0),
            Size             = UDim2.new(0, 4, 1, 0),
            ZIndex           = 11,
            ClipsDescendants = false
        }, {
            Utility:Create('UICorner', { CornerRadius = UDim.new(0, 10) }),
            -- Right half cover so only left side is rounded
            Utility:Create('Frame', {
                BackgroundColor3 = AccentCol,
                BorderSizePixel  = 0,
                Position         = UDim2.new(0.5, 0, 0, 0),
                Size             = UDim2.new(0.5, 0, 1, 0),
                ZIndex           = 11
            })
        })

        Utility:Create('TextLabel', {
            Parent                 = Notif,
            Name                   = 'Title',
            BackgroundTransparency = 1,
            Position               = UDim2.new(0, 14, 0, 10),
            Size                   = UDim2.new(1, -24, 0, 18),
            Font                   = Enum.Font.GothamBold,
            Text                   = Title,
            TextColor3             = Library.Theme.PrimaryTextColor,
            TextSize               = 13,
            TextXAlignment         = Enum.TextXAlignment.Left,
            ZIndex                 = 12
        })

        Utility:Create('TextLabel', {
            Parent                 = Notif,
            Name                   = 'Message',
            BackgroundTransparency = 1,
            Position               = UDim2.new(0, 14, 0, 30),
            Size                   = UDim2.new(1, -24, 0, 30),
            Font                   = Enum.Font.Gotham,
            Text                   = Message,
            TextColor3             = Library.Theme.SecondaryTextColor,
            TextSize               = 12,
            TextXAlignment         = Enum.TextXAlignment.Left,
            TextWrapped            = true,
            ZIndex                 = 12
        })

        -- Progress bar container (dark background) — clipped separately
        local ProgBG = Utility:Create('Frame', {
            Parent           = Notif,
            Name             = 'ProgressBG',
            BackgroundColor3 = Library.Theme.TertiaryColor,  -- FIX: dark neutral, not accent
            BorderSizePixel  = 0,
            Position         = UDim2.new(0, 4, 1, -5),
            Size             = UDim2.new(1, -4, 0, 3),
            ZIndex           = 12,
            ClipsDescendants = true
        }, {
            Utility:Create('UICorner', { CornerRadius = UDim.new(0, 2) })
        })

        -- Actual progress fill (accent color)
        local ProgFill = Utility:Create('Frame', {
            Parent           = ProgBG,
            Name             = 'Fill',
            BackgroundColor3 = AccentCol,
            BorderSizePixel  = 0,
            Size             = UDim2.new(1, 0, 1, 0),
            ZIndex           = 13
        }, {
            Utility:Create('UICorner', { CornerRadius = UDim.new(0, 2) })
        })

        Utility:Tween(Notif, { Size = UDim2.new(1, 0, 0, 72) }, 0.3)
        task.wait(0.05)
        Utility:Tween(ProgFill, { Size = UDim2.new(0, 0, 1, 0) }, Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

        task.delay(Duration, function()
            Utility:Tween(Notif, { Size = UDim2.new(1, 0, 0, 0) }, 0.3)
            task.wait(0.35)
            if Notif and Notif.Parent then Notif:Destroy() end
        end)

        return Notif
    end

    -- ///////////////////////////////////////////////////////////
    -- // Toggle visibility
    -- ///////////////////////////////////////////////////////////
    function Window:Toggle()
        Library.Visible = not Library.Visible
        Main.Visible    = Library.Visible
    end

    -- ///////////////////////////////////////////////////////////
    -- // ChangeTheme  — updates EVERY registered element
    -- ///////////////////////////////////////////////////////////
    function Window:ChangeTheme(ThemeName)
        local T = Library.Themes[ThemeName]
        if not T then return end
        Library.Theme = T
        for _, entry in next, ThemeRegistry do
            local inst, prop, key = entry[1], entry[2], entry[3]
            if inst and inst.Parent then
                inst[prop] = T[key]
            end
        end
    end

    -- ///////////////////////////////////////////////////////////
    -- // CreateTab
    -- ///////////////////////////////////////////////////////////
    function Window:CreateTab(TabName, Icon)
        local TabButton = Utility:Create('TextButton', {
            Parent                 = Sidebar.TabList,
            Name                   = TabName,
            BackgroundColor3       = Library.Theme.TertiaryColor,
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            Size                   = UDim2.new(1, 0, 0, 34),
            Font                   = Enum.Font.Gotham,
            Text                   = '',
            TextSize               = 13,
            AutoButtonColor        = false
        }, {
            Utility:Create('UICorner', { CornerRadius = UDim.new(0, 6) }),
            Utility:Create('TextLabel', {
                Name                   = 'Label',
                BackgroundTransparency = 1,
                Position               = Icon and UDim2.new(0, 30, 0, 0) or UDim2.new(0, 10, 0, 0),
                Size                   = UDim2.new(1, -40, 1, 0),
                Font                   = Enum.Font.Gotham,
                Text                   = TabName,
                TextColor3             = Library.Theme.SecondaryTextColor,
                TextSize               = 13,
                TextXAlignment         = Enum.TextXAlignment.Left
            })
        })
        TR(TabButton, 'BackgroundColor3', 'TertiaryColor')
        TR(TabButton.Label, 'TextColor3', 'SecondaryTextColor')

        if Icon then
            Utility:Create('ImageLabel', {
                Parent                 = TabButton,
                BackgroundTransparency = 1,
                AnchorPoint            = Vector2.new(0, 0.5),
                Position               = UDim2.new(0, 8, 0.5, 0),
                Size                   = UDim2.new(0, 18, 0, 18),
                Image                  = Icon
            })
        end

        local Page = Utility:Create('ScrollingFrame', {
            Parent                 = ContentArea,
            Name                   = TabName .. 'Page',
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            Position               = UDim2.new(0, 0, 0, 0),
            Size                   = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness     = 3,
            ScrollBarImageColor3   = Library.Theme.AccentColor,
            CanvasSize             = UDim2.new(0, 0, 0, 0),
            Visible                = false,
            ClipsDescendants       = false   -- allow overlays to show through
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
                Utility:Tween(ActiveTab.Button,       { BackgroundTransparency = 1 }, 0.15)
                Utility:Tween(ActiveTab.Button.Label, { TextColor3 = Library.Theme.SecondaryTextColor }, 0.15)
                ActiveTab.Page.Visible = false
            end
            Utility:Tween(TabButton,       { BackgroundTransparency = 0 }, 0.15)
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

        if not ActiveTab then SelectTab() end

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
                AutomaticSize    = Enum.AutomaticSize.Y,
                ClipsDescendants = false
            }, {
                Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
                Utility:Create('UIPadding', {
                    PaddingTop    = UDim.new(0, 28),
                    PaddingLeft   = UDim.new(0, 8),
                    PaddingRight  = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 8)
                }),
                Utility:Create('TextLabel', {
                    Name                   = 'SectionTitle',
                    BackgroundTransparency = 1,
                    Position               = UDim2.new(0, 8, 0, 6),
                    Size                   = UDim2.new(1, -16, 0, 18),
                    Font                   = Enum.Font.GothamBold,
                    Text                   = SectionName,
                    TextColor3             = Library.Theme.PrimaryTextColor,
                    TextSize               = 13,
                    TextXAlignment         = Enum.TextXAlignment.Left,
                }),
                Utility:Create('Frame', {
                    Name             = 'Divider',
                    BackgroundColor3 = Library.Theme.AccentColor,
                    BorderSizePixel  = 0,
                    Position         = UDim2.new(0, 0, 0, 24),
                    Size             = UDim2.new(1, 0, 0, 1)
                })
            })
            TR(SectionFrame, 'BackgroundColor3', 'SecondaryColor')
            TR(SectionFrame.SectionTitle, 'TextColor3', 'PrimaryTextColor')
            TR(SectionFrame.Divider,      'BackgroundColor3', 'AccentColor')

            local SectionList = Utility:Create('UIListLayout', {
                Parent    = SectionFrame,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding   = UDim.new(0, 6)
            })
            SectionList:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                SectionFrame.Size = UDim2.new(1, -4, 0, SectionList.AbsoluteContentSize.Y + 36 + 8)
            end)

            local Section = {}

            -- ///////////////////////////////////////////////////////////
            -- // Label
            -- ///////////////////////////////////////////////////////////
            function Section:CreateLabel(Text)
                local LF = Utility:Create('Frame', {
                    Parent                 = SectionFrame,
                    BackgroundTransparency = 1,
                    Size                   = UDim2.new(1, 0, 0, 20),
                    Name                   = 'Label_' .. Text
                })
                local LT = Utility:Create('TextLabel', {
                    Parent                 = LF,
                    BackgroundTransparency = 1,
                    Size                   = UDim2.new(1, 0, 1, 0),
                    Font                   = Enum.Font.Gotham,
                    Text                   = Text,
                    TextColor3             = Library.Theme.SecondaryTextColor,
                    TextSize               = 12,
                    TextXAlignment         = Enum.TextXAlignment.Left,
                    TextWrapped            = true
                })
                TR(LT, 'TextColor3', 'SecondaryTextColor')
                local O = {}
                function O:Set(T) LT.Text = T end
                return O
            end

            -- ///////////////////////////////////////////////////////////
            -- // Paragraph
            -- ///////////////////////////////////////////////////////////
            function Section:CreateParagraph(Title, Content)
                local PF = Utility:Create('Frame', {
                    Parent                 = SectionFrame,
                    BackgroundTransparency = 1,
                    Size                   = UDim2.new(1, 0, 0, 44),
                    Name                   = 'Para_' .. Title,
                    AutomaticSize          = Enum.AutomaticSize.Y
                })
                local TL = Utility:Create('TextLabel', {
                    Parent                 = PF,
                    BackgroundTransparency = 1,
                    Size                   = UDim2.new(1, 0, 0, 18),
                    Font                   = Enum.Font.GothamBold,
                    Text                   = Title,
                    TextColor3             = Library.Theme.PrimaryTextColor,
                    TextSize               = 12,
                    TextXAlignment         = Enum.TextXAlignment.Left
                })
                local CL = Utility:Create('TextLabel', {
                    Parent                 = PF,
                    BackgroundTransparency = 1,
                    Position               = UDim2.new(0, 0, 0, 20),
                    Size                   = UDim2.new(1, 0, 0, 24),
                    Font                   = Enum.Font.Gotham,
                    Text                   = Content,
                    TextColor3             = Library.Theme.SecondaryTextColor,
                    TextSize               = 12,
                    TextXAlignment         = Enum.TextXAlignment.Left,
                    TextWrapped            = true,
                    AutomaticSize          = Enum.AutomaticSize.Y
                })
                TR(TL, 'TextColor3', 'PrimaryTextColor')
                TR(CL, 'TextColor3', 'SecondaryTextColor')
                local O = {}
                function O:Set(NT, NC)
                    TL.Text = NT or TL.Text
                    CL.Text = NC or CL.Text
                end
                return O
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
                        Color           = Library.Theme.AccentColor,
                        Thickness       = 1,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    })
                })
                TR(Btn, 'BackgroundColor3', 'TertiaryColor')
                TR(Btn, 'TextColor3',       'PrimaryTextColor')
                TR(Btn:FindFirstChildOfClass('UIStroke'), 'Color', 'AccentColor')

                Btn.MouseEnter:Connect(function()    Utility:Tween(Btn, { BackgroundColor3 = Library.Theme.AccentColor },   0.15) end)
                Btn.MouseLeave:Connect(function()    Utility:Tween(Btn, { BackgroundColor3 = Library.Theme.TertiaryColor }, 0.15) end)
                Btn.MouseButton1Click:Connect(function()
                    Utility:Tween(Btn, { BackgroundColor3 = Library.Theme.Color },       0.1)
                    task.wait(0.12)
                    Utility:Tween(Btn, { BackgroundColor3 = Library.Theme.TertiaryColor }, 0.1)
                    pcall(Callback)
                end)
                local O = {}
                function O:SetText(T) Btn.Text = T end
                return O
            end

            -- ///////////////////////////////////////////////////////////
            -- // Toggle
            -- ///////////////////////////////////////////////////////////
            function Section:CreateToggle(Text, Default, Callback)
                Default  = Default ~= nil and Default or false
                Callback = Callback or function() end
                local State = Default

                local Row = Utility:Create('Frame', {
                    Parent                 = SectionFrame,
                    BackgroundTransparency = 1,
                    Size                   = UDim2.new(1, 0, 0, 30),
                    Name                   = 'Toggle_' .. Text
                })
                local TL = Utility:Create('TextLabel', {
                    Parent                 = Row,
                    BackgroundTransparency = 1,
                    Position               = UDim2.new(0, 0, 0, 0),
                    Size                   = UDim2.new(1, -54, 1, 0),
                    Font                   = Enum.Font.Gotham,
                    Text                   = Text,
                    TextColor3             = Library.Theme.PrimaryTextColor,
                    TextSize               = 12,
                    TextXAlignment         = Enum.TextXAlignment.Left
                })
                TR(TL, 'TextColor3', 'PrimaryTextColor')

                local Track = Utility:Create('Frame', {
                    Parent           = Row,
                    BackgroundColor3 = State and Library.Theme.Color or Library.Theme.AccentColor,
                    BorderSizePixel  = 0,
                    AnchorPoint      = Vector2.new(1, 0.5),
                    Position         = UDim2.new(1, 0, 0.5, 0),
                    Size             = UDim2.new(0, 44, 0, 22)
                }, { Utility:Create('UICorner', { CornerRadius = UDim.new(1, 0) }) })

                local Knob = Utility:Create('Frame', {
                    Parent           = Track,
                    BackgroundColor3 = Color(255, 255, 255),
                    BorderSizePixel  = 0,
                    AnchorPoint      = Vector2.new(0, 0.5),
                    Position         = State and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                    Size             = UDim2.new(0, 18, 0, 18)
                }, { Utility:Create('UICorner', { CornerRadius = UDim.new(1, 0) }) })

                local HitBtn = Utility:Create('TextButton', {
                    Parent                 = Row,
                    BackgroundTransparency = 1,
                    Size                   = UDim2.new(1, 0, 1, 0),
                    Text                   = '',
                    ZIndex                 = 5
                })

                local function Refresh()
                    if State then
                        Utility:Tween(Track, { BackgroundColor3 = Library.Theme.Color },        0.15)
                        Utility:Tween(Knob,  { Position = UDim2.new(1, -20, 0.5, 0) }, 0.15)
                    else
                        Utility:Tween(Track, { BackgroundColor3 = Library.Theme.AccentColor }, 0.15)
                        Utility:Tween(Knob,  { Position = UDim2.new(0,  2, 0.5, 0) }, 0.15)
                    end
                    pcall(Callback, State)
                end

                HitBtn.MouseButton1Click:Connect(function() State = not State; Refresh() end)

                local O = {}
                function O:Set(V) State = V; Refresh() end
                function O:Get() return State end
                return O
            end

            -- ///////////////////////////////////////////////////////////
            -- // Slider — FIX: no global UserInputService.InputChanged for dragging
            -- ///////////////////////////////////////////////////////////
            function Section:CreateSlider(Text, Min, Max, Default, Callback)
                Min      = Min      or 0
                Max      = Max      or 100
                Default  = math.clamp(Default or Min, Min, Max)
                Callback = Callback or function() end
                local Value   = Default
                local Sliding = false

                local Holder = Utility:Create('Frame', {
                    Parent                 = SectionFrame,
                    BackgroundTransparency = 1,
                    Size                   = UDim2.new(1, 0, 0, 44),
                    Name                   = 'Slider_' .. Text
                })
                local NameL = Utility:Create('TextLabel', {
                    Parent                 = Holder,
                    BackgroundTransparency = 1,
                    Position               = UDim2.new(0, 0, 0, 0),
                    Size                   = UDim2.new(0.7, 0, 0, 20),
                    Font                   = Enum.Font.Gotham,
                    Text                   = Text,
                    TextColor3             = Library.Theme.PrimaryTextColor,
                    TextSize               = 12,
                    TextXAlignment         = Enum.TextXAlignment.Left
                })
                TR(NameL, 'TextColor3', 'PrimaryTextColor')

                local ValL = Utility:Create('TextLabel', {
                    Parent                 = Holder,
                    BackgroundTransparency = 1,
                    AnchorPoint            = Vector2.new(1, 0),
                    Position               = UDim2.new(1, 0, 0, 0),
                    Size                   = UDim2.new(0.3, 0, 0, 20),
                    Font                   = Enum.Font.Gotham,
                    Text                   = tostring(Value),
                    TextColor3             = Library.Theme.SecondaryTextColor,
                    TextSize               = 12,
                    TextXAlignment         = Enum.TextXAlignment.Right
                })
                TR(ValL, 'TextColor3', 'SecondaryTextColor')

                local Track = Utility:Create('Frame', {
                    Parent           = Holder,
                    BackgroundColor3 = Library.Theme.TertiaryColor,
                    BorderSizePixel  = 0,
                    Position         = UDim2.new(0, 0, 0, 28),
                    Size             = UDim2.new(1, 0, 0, 8)
                }, { Utility:Create('UICorner', { CornerRadius = UDim.new(1, 0) }) })
                TR(Track, 'BackgroundColor3', 'TertiaryColor')

                local Fill = Utility:Create('Frame', {
                    Parent           = Track,
                    BackgroundColor3 = Library.Theme.Color,
                    BorderSizePixel  = 0,
                    Size             = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
                }, { Utility:Create('UICorner', { CornerRadius = UDim.new(1, 0) }) })
                TR(Fill, 'BackgroundColor3', 'Color')

                local Knob = Utility:Create('Frame', {
                    Parent           = Track,
                    BackgroundColor3 = Color(255, 255, 255),
                    BorderSizePixel  = 0,
                    AnchorPoint      = Vector2.new(0.5, 0.5),
                    Position         = UDim2.new((Value - Min) / (Max - Min), 0, 0.5, 0),
                    Size             = UDim2.new(0, 14, 0, 14),
                    ZIndex           = 3
                }, { Utility:Create('UICorner', { CornerRadius = UDim.new(1, 0) }) })

                local function ApplyRatio(Ratio)
                    Ratio  = math.clamp(Ratio, 0, 1)
                    Value  = math.round(Min + (Max - Min) * Ratio)
                    Fill.Size     = UDim2.new(Ratio, 0, 1, 0)
                    Knob.Position = UDim2.new(Ratio, 0, 0.5, 0)
                    ValL.Text     = tostring(Value)
                    pcall(Callback, Value)
                end

                -- FIX: Use Track.InputBegan and Track.InputChanged (NOT global UIS.InputChanged)
                -- This way the slider never fights the top-bar dragger.
                Track.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Sliding = true
                        local Abs = Track.AbsolutePosition
                        local Sz  = Track.AbsoluteSize
                        ApplyRatio((Input.Position.X - Abs.X) / Sz.X)
                    end
                end)

                Track.InputChanged:Connect(function(Input)
                    if Sliding and Input.UserInputType == Enum.UserInputType.MouseMovement then
                        local Abs = Track.AbsolutePosition
                        local Sz  = Track.AbsoluteSize
                        ApplyRatio((Input.Position.X - Abs.X) / Sz.X)
                    end
                end)

                -- Also handle global mouse release to stop sliding
                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Sliding = false
                    end
                end)

                -- Global mouse move while sliding (when cursor leaves Track bounds)
                UserInputService.InputChanged:Connect(function(Input)
                    if Sliding and Input.UserInputType == Enum.UserInputType.MouseMovement then
                        local Abs = Track.AbsolutePosition
                        local Sz  = Track.AbsoluteSize
                        ApplyRatio((Input.Position.X - Abs.X) / Sz.X)
                    end
                end)

                local O = {}
                function O:Set(V)
                    ApplyRatio((math.clamp(V, Min, Max) - Min) / (Max - Min))
                end
                function O:Get() return Value end
                return O
            end

            -- ///////////////////////////////////////////////////////////
            -- // Textbox
            -- ///////////////////////////////////////////////////////////
            function Section:CreateTextbox(Text, Placeholder, Callback)
                Callback    = Callback    or function() end
                Placeholder = Placeholder or ''

                local Row = Utility:Create('Frame', {
                    Parent                 = SectionFrame,
                    BackgroundTransparency = 1,
                    Size                   = UDim2.new(1, 0, 0, 30),
                    Name                   = 'TB_' .. Text
                })
                local TL = Utility:Create('TextLabel', {
                    Parent                 = Row,
                    BackgroundTransparency = 1,
                    Position               = UDim2.new(0, 0, 0, 0),
                    Size                   = UDim2.new(0.45, 0, 1, 0),
                    Font                   = Enum.Font.Gotham,
                    Text                   = Text,
                    TextColor3             = Library.Theme.PrimaryTextColor,
                    TextSize               = 12,
                    TextXAlignment         = Enum.TextXAlignment.Left
                })
                TR(TL, 'TextColor3', 'PrimaryTextColor')

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
                        Color           = Library.Theme.AccentColor,
                        Thickness       = 1,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    })
                })
                TR(BoxBG, 'BackgroundColor3', 'TertiaryColor')
                TR(BoxBG:FindFirstChildOfClass('UIStroke'), 'Color', 'AccentColor')

                local Box = Utility:Create('TextBox', {
                    Parent                 = BoxBG,
                    BackgroundTransparency = 1,
                    ClearTextOnFocus       = false,
                    PlaceholderText        = Placeholder,
                    PlaceholderColor3      = Library.Theme.SecondaryTextColor,
                    Position               = UDim2.new(0, 6, 0, 0),
                    Size                   = UDim2.new(1, -12, 1, 0),
                    Font                   = Enum.Font.Gotham,
                    Text                   = '',
                    TextColor3             = Library.Theme.PrimaryTextColor,
                    TextSize               = 12,
                    TextXAlignment         = Enum.TextXAlignment.Left
                })
                TR(Box, 'TextColor3', 'PrimaryTextColor')
                TR(Box, 'PlaceholderColor3', 'SecondaryTextColor')

                Box.FocusLost:Connect(function(Enter)
                    if Enter then pcall(Callback, Box.Text) end
                    Utility:Tween(BoxBG:FindFirstChildOfClass('UIStroke'), { Color = Library.Theme.AccentColor }, 0.15)
                end)
                Box.Focused:Connect(function()
                    Utility:Tween(BoxBG:FindFirstChildOfClass('UIStroke'), { Color = Library.Theme.Color }, 0.15)
                end)

                local O = {}
                function O:Set(V) Box.Text = V end
                function O:Get() return Box.Text end
                return O
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
                    Parent                 = SectionFrame,
                    BackgroundTransparency = 1,
                    Size                   = UDim2.new(1, 0, 0, 30),
                    Name                   = 'KB_' .. Text
                })
                local TL = Utility:Create('TextLabel', {
                    Parent                 = Row,
                    BackgroundTransparency = 1,
                    Position               = UDim2.new(0, 0, 0, 0),
                    Size                   = UDim2.new(0.6, 0, 1, 0),
                    Font                   = Enum.Font.Gotham,
                    Text                   = Text,
                    TextColor3             = Library.Theme.PrimaryTextColor,
                    TextSize               = 12,
                    TextXAlignment         = Enum.TextXAlignment.Left
                })
                TR(TL, 'TextColor3', 'PrimaryTextColor')

                local KBtn = Utility:Create('TextButton', {
                    Parent           = Row,
                    BackgroundColor3 = Library.Theme.TertiaryColor,
                    BorderSizePixel  = 0,
                    AnchorPoint      = Vector2.new(1, 0.5),
                    Position         = UDim2.new(1, 0, 0.5, 0),
                    Size             = UDim2.new(0, 72, 0, 24),
                    Font             = Enum.Font.Gotham,
                    Text             = CurrentKey,
                    TextColor3       = Library.Theme.PrimaryTextColor,
                    TextSize         = 11,
                    AutoButtonColor  = false
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 6) }),
                    Utility:Create('UIStroke', {
                        Color           = Library.Theme.AccentColor,
                        Thickness       = 1,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    })
                })
                TR(KBtn, 'BackgroundColor3', 'TertiaryColor')
                TR(KBtn, 'TextColor3', 'PrimaryTextColor')
                TR(KBtn:FindFirstChildOfClass('UIStroke'), 'Color', 'AccentColor')

                KBtn.MouseButton1Click:Connect(function()
                    Listening = true
                    KBtn.Text = '...'
                    Utility:Tween(KBtn:FindFirstChildOfClass('UIStroke'), { Color = Library.Theme.Color }, 0.15)
                end)

                UserInputService.InputBegan:Connect(function(Input, Processed)
                    if Listening and not Processed and Input.UserInputType == Enum.UserInputType.Keyboard then
                        CurrentKey = Input.KeyCode.Name
                        Listening  = false
                        KBtn.Text  = CurrentKey
                        Utility:Tween(KBtn:FindFirstChildOfClass('UIStroke'), { Color = Library.Theme.AccentColor }, 0.15)
                    elseif not Listening and Input.UserInputType == Enum.UserInputType.Keyboard then
                        if Input.KeyCode.Name == CurrentKey then pcall(Callback) end
                    end
                end)

                local O = {}
                function O:Set(K) CurrentKey = K; KBtn.Text = K end
                function O:Get() return CurrentKey end
                return O
            end

            -- ///////////////////////////////////////////////////////////
            -- // Dropdown — FIX: list rendered in OverlayFrame (no clipping)
            -- ///////////////////////////////////////////////////////////
            function Section:CreateDropdown(Text, Options, Default, Callback)
                Options  = Options  or {}
                Callback = Callback or function() end
                local Selected = Default or Options[1] or 'None'
                local Open     = false

                local Row = Utility:Create('Frame', {
                    Parent                 = SectionFrame,
                    BackgroundTransparency = 1,
                    Size                   = UDim2.new(1, 0, 0, 30),
                    Name                   = 'DD_' .. Text
                })
                local TL = Utility:Create('TextLabel', {
                    Parent                 = Row,
                    BackgroundTransparency = 1,
                    Position               = UDim2.new(0, 0, 0, 0),
                    Size                   = UDim2.new(0.45, 0, 1, 0),
                    Font                   = Enum.Font.Gotham,
                    Text                   = Text,
                    TextColor3             = Library.Theme.PrimaryTextColor,
                    TextSize               = 12,
                    TextXAlignment         = Enum.TextXAlignment.Left,
                    ZIndex                 = 2
                })
                TR(TL, 'TextColor3', 'PrimaryTextColor')

                local DropBtn = Utility:Create('TextButton', {
                    Parent           = Row,
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
                    ZIndex           = 2
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 6) }),
                    Utility:Create('UIStroke', {
                        Color           = Library.Theme.AccentColor,
                        Thickness       = 1,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    })
                })
                TR(DropBtn, 'BackgroundColor3', 'TertiaryColor')
                TR(DropBtn, 'TextColor3',       'PrimaryTextColor')
                TR(DropBtn:FindFirstChildOfClass('UIStroke'), 'Color', 'AccentColor')

                -- FIX: option list lives in OverlayFrame, positioned absolutely
                -- so it never gets clipped by sections / content area
                local OptionList = Utility:Create('Frame', {
                    Parent           = OverlayFrame,
                    Name             = 'DDList_' .. Text,
                    BackgroundColor3 = Library.Theme.SecondaryColor,
                    BorderSizePixel  = 0,
                    Size             = UDim2.new(0, 0, 0, 0),
                    ClipsDescendants = true,
                    ZIndex           = 60,
                    Visible          = false
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
                    Utility:Create('UIStroke', {
                        Color           = Library.Theme.AccentColor,
                        Thickness       = 1,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }),
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
                TR(OptionList, 'BackgroundColor3', 'SecondaryColor')
                TR(OptionList:FindFirstChildOfClass('UIStroke'), 'Color', 'AccentColor')

                local function GetDropBtnAbsPos()
                    -- Convert DropBtn screen position to OverlayFrame local space
                    local SP = DropBtn.AbsolutePosition
                    local SZ = DropBtn.AbsoluteSize
                    local OP = OverlayFrame.AbsolutePosition
                    return Vector2.new(SP.X - OP.X, SP.Y - OP.Y + SZ.Y + 4), SZ.X
                end

                local function RebuildOptions()
                    for _, c in next, OptionList:GetChildren() do
                        if c:IsA('TextButton') then c:Destroy() end
                    end
                    for _, Opt in next, Options do
                        local isSelected = (Opt == Selected)
                        local OBtn = Utility:Create('TextButton', {
                            Parent                 = OptionList,
                            BackgroundColor3       = Library.Theme.TertiaryColor,
                            BackgroundTransparency = isSelected and 0 or 1,
                            BorderSizePixel        = 0,
                            Size                   = UDim2.new(1, 0, 0, 26),
                            Font                   = Enum.Font.Gotham,
                            Text                   = Opt,
                            TextColor3             = isSelected and Library.Theme.PrimaryTextColor or Library.Theme.SecondaryTextColor,
                            TextSize               = 11,
                            AutoButtonColor        = false,
                            ZIndex                 = 61
                        }, { Utility:Create('UICorner', { CornerRadius = UDim.new(0, 5) }) })

                        OBtn.MouseEnter:Connect(function()
                            if Opt ~= Selected then Utility:Tween(OBtn, { BackgroundTransparency = 0.5 }, 0.1) end
                        end)
                        OBtn.MouseLeave:Connect(function()
                            if Opt ~= Selected then Utility:Tween(OBtn, { BackgroundTransparency = 1 }, 0.1) end
                        end)
                        OBtn.MouseButton1Click:Connect(function()
                            Selected      = Opt
                            DropBtn.Text  = Opt .. ' ▾'
                            Open          = false
                            Utility:Tween(OptionList, { Size = UDim2.new(0, OptionList.Size.X.Offset, 0, 0) }, 0.18)
                            task.wait(0.2)
                            OptionList.Visible = false
                            RebuildOptions()
                            pcall(Callback, Selected)
                        end)
                    end
                    local Layout = OptionList:FindFirstChildOfClass('UIListLayout')
                    task.wait()  -- let layout compute
                    return Layout.AbsoluteContentSize.Y + 10
                end

                DropBtn.MouseButton1Click:Connect(function()
                    Open = not Open
                    if Open then
                        local pos, width = GetDropBtnAbsPos()
                        OptionList.Position = UDim2.new(0, pos.X, 0, pos.Y)
                        OptionList.Size     = UDim2.new(0, width, 0, 0)
                        OptionList.Visible  = true
                        local H = RebuildOptions()
                        Utility:Tween(OptionList, { Size = UDim2.new(0, width, 0, math.min(H, 160)) }, 0.2)
                    else
                        Utility:Tween(OptionList, { Size = UDim2.new(0, OptionList.Size.X.Offset, 0, 0) }, 0.18)
                        task.delay(0.2, function() OptionList.Visible = false end)
                    end
                end)

                -- Close on outside click
                UserInputService.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 and Open then
                        task.wait()
                        local MP  = UserInputService:GetMouseLocation()
                        local OAP = OptionList.AbsolutePosition
                        local OAS = OptionList.AbsoluteSize
                        local DAP = DropBtn.AbsolutePosition
                        local DAS = DropBtn.AbsoluteSize
                        local inList = MP.X >= OAP.X and MP.X <= OAP.X + OAS.X and MP.Y >= OAP.Y and MP.Y <= OAP.Y + OAS.Y
                        local inBtn  = MP.X >= DAP.X and MP.X <= DAP.X + DAS.X and MP.Y >= DAP.Y and MP.Y <= DAP.Y + DAS.Y
                        if not inList and not inBtn then
                            Open = false
                            Utility:Tween(OptionList, { Size = UDim2.new(0, OptionList.Size.X.Offset, 0, 0) }, 0.18)
                            task.delay(0.2, function() OptionList.Visible = false end)
                        end
                    end
                end)

                local O = {}
                function O:Set(V)
                    if table.find(Options, V) then
                        Selected = V; DropBtn.Text = V .. ' ▾'; RebuildOptions(); pcall(Callback, V)
                    end
                end
                function O:SetOptions(New) Options = New; RebuildOptions() end
                function O:Get() return Selected end
                return O
            end

            -- ///////////////////////////////////////////////////////////
            -- // Colorpicker
            -- ///////////////////////////////////////////////////////////
            function Section:CreateColorpicker(Text, Default, Callback)
                Default  = Default  or Color(255, 255, 255)
                Callback = Callback or function() end
                local CurrentColor = Default
                local Open = false
                local H, S, V = Color3.toHSV(CurrentColor)

                local Row = Utility:Create('Frame', {
                    Parent                 = SectionFrame,
                    BackgroundTransparency = 1,
                    Size                   = UDim2.new(1, 0, 0, 30),
                    Name                   = 'CP_' .. Text
                })
                local TL = Utility:Create('TextLabel', {
                    Parent                 = Row,
                    BackgroundTransparency = 1,
                    Position               = UDim2.new(0, 0, 0, 0),
                    Size                   = UDim2.new(0.6, 0, 1, 0),
                    Font                   = Enum.Font.Gotham,
                    Text                   = Text,
                    TextColor3             = Library.Theme.PrimaryTextColor,
                    TextSize               = 12,
                    TextXAlignment         = Enum.TextXAlignment.Left
                })
                TR(TL, 'TextColor3', 'PrimaryTextColor')

                local Preview = Utility:Create('TextButton', {
                    Parent           = Row,
                    BackgroundColor3 = CurrentColor,
                    BorderSizePixel  = 0,
                    AnchorPoint      = Vector2.new(1, 0.5),
                    Position         = UDim2.new(1, 0, 0.5, 0),
                    Size             = UDim2.new(0, 40, 0, 22),
                    Text             = '',
                    AutoButtonColor  = false
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 6) }),
                    Utility:Create('UIStroke', { Color = Library.Theme.AccentColor, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
                })

                -- Panel in overlay
                local Panel = Utility:Create('Frame', {
                    Parent           = OverlayFrame,
                    BackgroundColor3 = Library.Theme.TertiaryColor,
                    BorderSizePixel  = 0,
                    Size             = UDim2.new(0, 180, 0, 160),
                    Visible          = false,
                    ClipsDescendants = false,
                    ZIndex           = 60
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 8) }),
                    Utility:Create('UIStroke', { Color = Library.Theme.AccentColor, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
                })
                TR(Panel, 'BackgroundColor3', 'TertiaryColor')
                TR(Panel:FindFirstChildOfClass('UIStroke'), 'Color', 'AccentColor')

                local SVBox = Utility:Create('ImageLabel', {
                    Parent           = Panel,
                    BackgroundColor3 = Color3.fromHSV(H, 1, 1),
                    BorderSizePixel  = 0,
                    Position         = UDim2.new(0, 8, 0, 8),
                    Size             = UDim2.new(1, -16, 0, 100),
                    Image            = 'rbxassetid://4155801252',
                    ZIndex           = 61
                }, { Utility:Create('UICorner', { CornerRadius = UDim.new(0, 4) }) })

                local SVKnob = Utility:Create('Frame', {
                    Parent           = SVBox,
                    BackgroundColor3 = Color(255,255,255),
                    BorderSizePixel  = 0,
                    AnchorPoint      = Vector2.new(0.5, 0.5),
                    Position         = UDim2.new(S, 0, 1 - V, 0),
                    Size             = UDim2.new(0, 10, 0, 10),
                    ZIndex           = 62
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(1, 0) }),
                    Utility:Create('UIStroke', { Color = Color(0,0,0), Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
                })

                local HueBar = Utility:Create('ImageLabel', {
                    Parent           = Panel,
                    BackgroundColor3 = Color(255,255,255),
                    BorderSizePixel  = 0,
                    Position         = UDim2.new(0, 8, 0, 116),
                    Size             = UDim2.new(1, -16, 0, 14),
                    Image            = 'rbxassetid://4155804796',
                    ZIndex           = 61
                }, { Utility:Create('UICorner', { CornerRadius = UDim.new(0, 4) }) })

                local HueKnob = Utility:Create('Frame', {
                    Parent           = HueBar,
                    BackgroundColor3 = Color(255,255,255),
                    BorderSizePixel  = 0,
                    AnchorPoint      = Vector2.new(0.5, 0.5),
                    Position         = UDim2.new(H, 0, 0.5, 0),
                    Size             = UDim2.new(0, 10, 1, 4),
                    ZIndex           = 62
                }, {
                    Utility:Create('UICorner', { CornerRadius = UDim.new(0, 3) }),
                    Utility:Create('UIStroke', { Color = Color(0,0,0), Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
                })

                local HexBox = Utility:Create('TextBox', {
                    Parent                 = Panel,
                    BackgroundColor3       = Library.Theme.SecondaryColor,
                    BorderSizePixel        = 0,
                    Position               = UDim2.new(0, 8, 0, 136),
                    Size                   = UDim2.new(1, -16, 0, 18),
                    Font                   = Enum.Font.Code,
                    Text                   = '',
                    PlaceholderText        = '#RRGGBB',
                    PlaceholderColor3      = Library.Theme.SecondaryTextColor,
                    TextColor3             = Library.Theme.PrimaryTextColor,
                    TextSize               = 11,
                    ZIndex                 = 61
                }, { Utility:Create('UICorner', { CornerRadius = UDim.new(0, 4) }) })
                TR(HexBox, 'BackgroundColor3', 'SecondaryColor')

                local function ColorToHex(c)
                    return string.format('#%02X%02X%02X', math.round(c.R*255), math.round(c.G*255), math.round(c.B*255))
                end

                local function UpdateColor()
                    CurrentColor             = Color3.fromHSV(H, S, V)
                    Preview.BackgroundColor3 = CurrentColor
                    SVBox.BackgroundColor3   = Color3.fromHSV(H, 1, 1)
                    SVKnob.Position          = UDim2.new(S, 0, 1 - V, 0)
                    HueKnob.Position         = UDim2.new(H, 0, 0.5, 0)
                    HexBox.Text              = ColorToHex(CurrentColor)
                    pcall(Callback, CurrentColor)
                end

                local SVDrag, HueDrag = false, false
                SVBox.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then SVDrag = true end end)
                HueBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then HueDrag = true end end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then SVDrag = false; HueDrag = false end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
                    if SVDrag then
                        local A, Sz = SVBox.AbsolutePosition, SVBox.AbsoluteSize
                        S = math.clamp((i.Position.X - A.X) / Sz.X, 0, 1)
                        V = 1 - math.clamp((i.Position.Y - A.Y) / Sz.Y, 0, 1)
                        UpdateColor()
                    elseif HueDrag then
                        local A, Sz = HueBar.AbsolutePosition, HueBar.AbsoluteSize
                        H = math.clamp((i.Position.X - A.X) / Sz.X, 0, 1)
                        UpdateColor()
                    end
                end)

                HexBox.FocusLost:Connect(function(Enter)
                    if Enter then
                        local hex = HexBox.Text:gsub('#','')
                        if #hex == 6 then
                            local R = tonumber(hex:sub(1,2),16)
                            local G = tonumber(hex:sub(3,4),16)
                            local B = tonumber(hex:sub(5,6),16)
                            if R and G and B then
                                H, S, V = Color3.toHSV(Color3.fromRGB(R, G, B))
                                UpdateColor()
                            end
                        end
                    end
                end)

                Preview.MouseButton1Click:Connect(function()
                    Open = not Open
                    if Open then
                        local AP = Preview.AbsolutePosition
                        local AS = Preview.AbsoluteSize
                        local OP = OverlayFrame.AbsolutePosition
                        Panel.Position = UDim2.new(0, AP.X - OP.X - 140, 0, AP.Y - OP.Y + AS.Y + 4)
                        Panel.Visible  = true
                        UpdateColor()
                    else
                        Panel.Visible = false
                    end
                end)

                UserInputService.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 and Open then
                        task.wait()
                        local MP  = UserInputService:GetMouseLocation()
                        local PAP = Panel.AbsolutePosition
                        local PAS = Panel.AbsoluteSize
                        local PAP2 = Preview.AbsolutePosition
                        local PAS2 = Preview.AbsoluteSize
                        local inPanel   = MP.X >= PAP.X  and MP.X <= PAP.X  + PAS.X  and MP.Y >= PAP.Y  and MP.Y <= PAP.Y  + PAS.Y
                        local inPreview = MP.X >= PAP2.X and MP.X <= PAP2.X + PAS2.X and MP.Y >= PAP2.Y and MP.Y <= PAP2.Y + PAS2.Y
                        if not inPanel and not inPreview then
                            Open = false; Panel.Visible = false
                        end
                    end
                end)

                UpdateColor()

                local O = {}
                function O:Set(C) H, S, V = Color3.toHSV(C); UpdateColor() end
                function O:Get() return CurrentColor end
                return O
            end

            -- ///////////////////////////////////////////////////////////
            -- // Separator
            -- ///////////////////////////////////////////////////////////
            function Section:CreateSeparator()
                local Sep = Utility:Create('Frame', {
                    Parent           = SectionFrame,
                    BackgroundColor3 = Library.Theme.AccentColor,
                    BorderSizePixel  = 0,
                    Size             = UDim2.new(1, 0, 0, 1),
                    Name             = 'Separator'
                })
                TR(Sep, 'BackgroundColor3', 'AccentColor')
            end

            return Section
        end

        return Tab
    end

    return Window
end

function Library:Destroy()
    Utility:Destroy()
end

return Library
