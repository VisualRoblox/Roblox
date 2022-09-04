-- // Services
local CoreGui = game:GetService('CoreGui')
local UserInputService = game:GetService('UserInputService')

-- // Imports
local Create = Import('UI/Functions/Create.lua')
local Tween = Import('UI/Functions/Tween.lua')
local DestroyUI = Import('UI/Functions/DestroyUI.lua')
local ToggleUI = Import('UI/Functions/ToggleUI.lua')
local EnableDragging = Import('UI/Functions/Dragging.lua')
local LoggingHandler = Import('Logging/LoggingHandler.lua')

-- // Variables
local UIHandler = {}

function UIHandler.LoadUI()
    -- // Destroy Old UI
    DestroyUI()

    -- // Loaded
    Visual.Loaded = true

    -- // Initilise UI
    LoggingHandler.Log('Initialising UI...')

    -- // Create Instances
    local Container = Create('ScreenGui', {
        Parent = CoreGui,
        Name = 'VisualAnalyser'
    }, {
        Create('Frame', {
            Name = 'Base',
            Size = UDim2.new(0, 0, 0, 0),
            AnchorPoint = Vector2.new(0.25, 0.25),
            Position = UDim2.new(0.25, 0, 0.25, 0),
            BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        }, {
            Create('UICorner', {
                Name = 'BaseCorner',
                CornerRadius = UDim.new(0, 5)
            }),
            Create('UIStroke', {
                Name = 'BaseStroke',
                Color = Color3.fromRGB(75, 75, 75),
                Thickness = 1
            }),
        }),
        Create('ImageButton', {
            Name = 'OpenButton',
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 0),
            Size = UDim2.new(0, 40, 0, 40),
            AutoButtonColor = false,
            Image = 'rbxassetid://10618644218',
            ImageTransparency = 1,
        }, {
            Create('UICorner', {
                Name = 'OpenButtonCorner',
                CornerRadius = UDim.new(0, 100)
            }),
            Create('UIStroke', {
                Name = 'OpenButtonBaseStroke',
                Color = Color3.fromRGB(0, 150, 255),
                Thickness = 0
            }),
        })
    })

    -- // Enable Dragging
    EnableDragging(Container['Base'])

    -- // Animated Loading (#1)
    Tween(Container['Base'], {Size = UDim2.new(0, 650, 0, 375)}, 0.25)
    task.wait(0.25)
    
    -- // Create More Instances
    Create('Frame', {
        Name = 'Topbar',
        Parent = Container['Base'],
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 650, 0, 25),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }, {
        Create('UICorner', {
            Name = 'TopbarCorner',
            CornerRadius = UDim.new(0, 5)
        }),
        Create('Frame', {
            Name = 'TopbarLine',
            Position = UDim2.new(0, 0, 0, 26),
            Size = UDim2.new(0, 650, 0, 1),
            BackgroundColor3 = Color3.fromRGB(75, 75, 75),
            BorderSizePixel = 0
        }),
        Create('TextLabel', {
            Name = 'TitleSectionOne',
            Position = UDim2.new(0, 5, 0, 3),
            Size = UDim2.new(0, 50, 0, 20),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            TextColor3 = Color3.fromRGB(0, 150, 255),
            Font = Enum.Font.Gotham,
            BorderSizePixel = 0,
            TextSize = 18,
            Text = 'Visual'
        }),
        Create('TextLabel', {
            Name = 'TitleSectionTwo',
            Position = UDim2.new(0, 61, 0, 3),
            Size = UDim2.new(0, 65, 0, 20),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.Gotham,
            BorderSizePixel = 0,
            TextSize = 18,
            Text = 'Analyser'
        }),
        Create('TextButton', {
            Name = 'CloseButton',
            Position = UDim2.new(0, 625, 0, 0),
            Size = UDim2.new(0, 25, 0, 25),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            AutoButtonColor = false,
            Font = Enum.Font.Gotham,
            TextYAlignment = Enum.TextYAlignment.Center,
            BorderSizePixel = 0,
            TextSize = 30,
            Text = '×'
        }),
        Create('TextButton', {
            Name = 'MinimiseButton',
            Position = UDim2.new(0, 600, 0, 0),
            Size = UDim2.new(0, 25, 0, 25),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            AutoButtonColor = false,
            Font = Enum.Font.Gotham,
            TextYAlignment = Enum.TextYAlignment.Center,
            BorderSizePixel = 0,
            TextSize = 30,
            Text = '-'
        }),
    })
    
    -- // Variables
    local Base = Container['Base']
    local Topbar = Base['Topbar']
    local CloseButton = Topbar['CloseButton']
    local MinimiseButton = Topbar['MinimiseButton']
    local OpenButton = Container['OpenButton']

    -- // Topbar Buttons
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {TextColor3 = Color3.fromRGB(125, 125, 125)}, 0.25)
    end)

    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.25)
    end)

    CloseButton.MouseButton1Click:Connect(function()
        Tween(CloseButton, {TextColor3 = Color3.fromRGB(125, 125, 125)}, 0.25)
        task.wait(0.25)
        Tween(CloseButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.25)
        DestroyUI()
    end)

    MinimiseButton.MouseEnter:Connect(function()
        Tween(MinimiseButton, {TextColor3 = Color3.fromRGB(125, 125, 125)}, 0.25)
    end)

    MinimiseButton.MouseLeave:Connect(function()
        Tween(MinimiseButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.25)
    end)

    MinimiseButton.MouseButton1Click:Connect(function()
        Tween(MinimiseButton, {TextColor3 = Color3.fromRGB(125, 125, 125)}, 0.25)
        task.wait(0.25)
        Tween(MinimiseButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.25)
        ToggleUI()
    end)

    -- // Minimised Button
    OpenButton.MouseEnter:Connect(function()
        Tween(OpenButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.25)
    end)

    OpenButton.MouseLeave:Connect(function()
        Tween(OpenButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.25)
    end)

    OpenButton.MouseButton1Click:Connect(function()
        Tween(OpenButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.25)
        task.wait(0.25)
        Tween(OpenButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.25)
        ToggleUI()
    end)

    LoggingHandler.Log('Finished Loading UI')
end

UIHandler.LoadUI()

return UIHandler