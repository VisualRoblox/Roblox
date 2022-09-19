-- // Services
local CollectionService = game:GetService('CollectionService')

local Hook
Hook = hookfunction(CollectionService.HasTag, function(self, ...)
    local CallingScript = getcallingscript()
        print(self, ...)
    
    return Hook(self, ...)
end)
