-- // Services
local CoreGui = game:GetService('CoreGui')
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local TextService = game:GetService('TextService')
local Players = game:GetService('Players')
local Workspace = game:GetService('Workspace')
local Lighting = game:GetService('Lighting')

-- // Variables
local Color, Insert = Color3.fromRGB, table.insert 
local BreakAllLoops = true
local Utility = {}
local Library = {}

-- // Library Defaults
Library.Themes = {
    Dark = {
        BackgroundColor = Color(19, 18, 22), -- Background
        SecondaryColor = Color(18, 19, 23), -- Sidebar etc
        TertiaryColor = Color(13, 15, 18), -- Tabs etc
        AccentColor = Color(70, 70, 70), -- Stroke etc
        Color = Color(254, 51, 61), -- Main Colored etc
        PrimaryTextColor = Color(230, 230, 230), -- Toggled Tabs etc
        SecondaryTextColor = Color(105, 105, 105) -- Untoggled Tabs etc
    }
}

-- // Utility Functions
do
    function Utility:Create(_Instance, Properties, Children)
        local Object = Instance.new(_Instance)
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

    function Utility:Tween(Instance, Properties, Duration, ...)
        local TweenInfo = TweenInfo.new(Duration, ...)
        TweenService:Create(Instance, TweenInfo, Properties):Play()
    end

    function Utility:Switch(Value, Callbacks)
        if Callbacks[Value] then
            pcall(Callbacks[Value])
        else
            return
        end
    end

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

    function Utility:Destroy()
        BreakAllLoops = true

        for _, UI in next, CoreGui:GetChildren() do
            if UI.Name == 'Aries UI Library | .gg/puxxCphTnK' then
                for _, Item in next, UI.Main:GetChildren() do
                    Item:Destroy()
                end
    
                Utility:Tween(UI.Main, {Size = UDim2.new(0, 500, 0, 0)}, 0.25)

                task.wait(0.25)

                UI:Destroy()
            end
        end
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
end

-- // Library Main
function Library:CreateWindow(Properties)
    Name = Properties.Name or 'Aries UI Library'
    IntroText = Properties.IntroText or 'Aries UI Library'
    IntroIcon = Properties.IntroIcon or 'rbxassetid://10618644218'
    IntroBlur = Properties.IntroBlur or true
    IntroBlurIntensity = Properties.IntroBlurIntensity or 15
    Theme = Properties.Theme or Library.Themes.Dark

    -- // Set Library Properties
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
        Name = 'Aries UI Library | .gg/puxxCphTnK',
        ResetOnSpawn = false
    }, {
        Utility:Create('Frame', {
            Name = 'Main',
            BackgroundColor3 = Library.Theme.BackgroundColor,
            BorderSizePixel = 0,
            BackgroundTransparency = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 0, 0, 0)
        }, {
            Utility:Create('TextLabel', {
                Name = 'IntroText',
                BackgroundColor3 = Library.Theme.BackgroundColor,
                BackgroundTransparency = 1,
                TextTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, -30),
                BorderSizePixel = 0,
                Size = UDim2.new(0, 170, 0, 20),
                Font = Enum.Font.Gotham,
                Text = IntroText,
                TextColor3 = Library.Theme.PrimaryTextColor,
                TextSize = 18,
                ZIndex = 2,
                TextXAlignment = Enum.TextXAlignment.Center
            }),
            Utility:Create('ImageLabel', {
                Name = 'IntroImage',
                BackgroundColor3 = Library.Theme.BackgroundColor,
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
    
    -- // Dragging
    Utility:EnableDragging(Main)

    -- // Intro
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

    Utility:Tween(Main, {Size = UDim2.new(0, 700, 0, 500)}, 0.25)
    Utility:Tween(Main, {BackgroundTransparency = 0}, 0.25)

    task.wait(0.5)

    -- // Main Elements - Background
    Utility:Create('ImageLabel', {
        Name = 'MainBackground',
        BackgroundColor3 = Library.Theme.TertiaryColor,
        BackgroundTransparency = 1,
        ImageTransparency = 0.3,
        Parent = Main,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 700, 0, 500),
        Image = 'rbxassetid://10960421886',
        ImageColor3 = Library.Theme.Color
    })

    -- // Main Elements - Sidebar
    Utility:Create('Frame', {
        Name = 'Sidebar',
        BackgroundColor3 = Library.Theme.SecondaryColor,
        Parent = Main,
        BorderSizePixel = 0,
        BackgroundTransparency = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 181, 0, 500)
    }, {
        Utility:Create('Frame', {
            Name = 'SidebarLine1',
            BackgroundColor3 = Library.Theme.AccentColor,
            Parent = Main,
            BorderSizePixel = 0,
            BackgroundTransparency = 0,
            Position = UDim2.new(0, 180, 0, 0),
            Size = UDim2.new(0, 1, 0, 500)
        })
    })

    -- // Main Elements - Tab Holder
    Utility:Create('Frame', {
        Name = 'TabHolder',
        BackgroundColor3 = Library.Theme.TertiaryColor,
        Parent = Main,
        BorderSizePixel = 0,
        BackgroundTransparency = 0,
        Position = UDim2.new(0, 196, 0, 15),
        Size = UDim2.new(0, 489, 0, 470)
    }, {
        Utility:Create('UICorner', {
            Name = 'TabHolderCorner',
            CornerRadius = UDim.new(0, 8)
        })
    })
end

-- // Example
local Window = Library:CreateWindow({
    Name = 'Aries UI Library',
    IntroText = 'Aries UI Library',
    IntroIcon = 'rbxassetid://10618644218',
    IntroBlur = true,
    IntroBlurIntensity = 15,
    Theme = Library.Themes.dark
})

