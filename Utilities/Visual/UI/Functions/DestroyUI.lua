-- // Services
local CoreGui = game:GetService('CoreGui')

-- // Imports
local Tween = Import('UI/Functions/Tween.lua')
local LoggingHandler = Import('Logging/LoggingHandler.lua')

local DestroyUIHandler = {}

function DestroyUIHandler.DestroyUI()
    LoggingHandler.Log('Destroy UI Called')

    local Name = Visual.Name

    if CoreGui:FindFirstChild(Name) then
        local UI = CoreGui:FindFirstChild(Name)

        for _, Item in next, UI.Base:GetChildren() do
            if Item.Name ~= 'BaseCorner' and Item.Name ~= 'BaseStroke' then
                Item:Destroy()
            end
        end

        Tween(UI.Base, {Size = UDim2.new(0, 0, 0, 0)}, 0.25)
        task.wait(0.25)

        UI.Base:Destroy()

        LoggingHandler.Log('UI Destroyed')
    end

    Visual.Loaded = false 
    LoggingHandler.Log('Unloaded Visual Analyser')
end

return DestroyUIHandler.DestroyUI