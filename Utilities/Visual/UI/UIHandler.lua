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
        Name = Visual.Name
    }, {
        Create('Frame', {
            Name = 'Base',
            Size = UDim2.new(0.5, 0, 0.5, 0),
            Position = UDim2.new(0.25, 0, 0.25, 0)
        })
    })
end

return UIHandler