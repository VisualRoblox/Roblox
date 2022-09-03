-- // Services
local TweenService = game:GetService('TweenService')

local TweenHandler = {}

function TweenHandler.Tween(Instance, Properties, Duration, ...)
    local TweenInfo = TweenInfo.new(Duration, ...)
    TweenService:Create(Instance, TweenInfo, Properties):Play()
end

return TweenHandler.Tween