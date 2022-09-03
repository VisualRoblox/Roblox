-- // Services
local CoreGui = game:GetService('CoreGui')
local UserInputService = game:GetService('UserInputService')

-- // Imports
local Create = Import('UI/Functions/Create.lua')
local Tween = Import('UI/Functions/Tween.lua')
local DestroyUI = Import('UI/Functions/DestroyUI.lua')
local LoggingHandler = Import('Logging/LoggingHandler.lua')

-- // Variables
local UIHandler = {}

function UIHandler.LoadUI()
    -- // Destroy Old UI
    DestroyUI()

    -- // Initilise UI
    LoggingHandler.Log('Initialising UI...')

    -- // Create Instances
    local Container = Create('ScreenGui', {
        Parent = CoreGui,
        Name = Visual.Name
    }, {
        Create('Frame', {
            Name = 'Base',
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, 5, 0.25, 0),
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
        }) 
    })

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
        })
    })
    
    -- // Variables
    local Base = Container['Base']

    LoggingHandler.Log('Finished Loading UI')
end

return UIHandler