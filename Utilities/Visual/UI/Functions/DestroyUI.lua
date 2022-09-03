-- // Services
local CoreGui = game:GetService('CoreGui')

-- // Imports
local Tween = Import('UI/Functions/Tween.lua')
local LoggingHandler = Import('Logging/LoggingHandler.lua')

local DestroyUIHandler = {}

function DestroyUIHandler.DestroyUI()
    LoggingHandler.Log('Destroy UI Called')

    for _, UI in next, CoreGui:GetChildren() do
        if UI.Name == 'VisualAnalyser' then
            for _, Item in next, UI.Base:GetChildren() do
                if Item.Name ~= 'BaseCorner' and Item.Name ~= 'BaseStroke' then
                    Item:Destroy()
                end
            end

            Tween(UI.Base, {Size = UDim2.new(0, 0, 0, 0)}, 0.25)
            task.wait(0.25)

            UI:Destroy()
            LoggingHandler.Log('UI Destroyed')

            Visual.Loaded = false 
            LoggingHandler.Log('Unloaded Visual Analyser')
        end
    end
end

return DestroyUIHandler.DestroyUI