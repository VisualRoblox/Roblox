-- // Services
local CoreGui = game:GetService('CoreGui')
local UserInputService = game:GetService('UserInputService')

-- // Imports
local Create = Import('UI/Functions/Create.lua')
local LoggingHandler = Import('Logging/LoggingHandler.lua')

-- // Variables
local UIHandler = {}

function UIHandler.LoadUI()
    print('LOADED')
    Create('ScreenGui', {
        Parent = CoreGui,
        --Name = Visual.Name
        Name = 'x'
    }, {
        Create('Frame', {
            Name = 'Base',
            Size = UDim2.new(0, 650, 0, 375),
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
            Create('Frame', {
                Name = 'Topbar',
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
        })
    })
end

return UIHandler