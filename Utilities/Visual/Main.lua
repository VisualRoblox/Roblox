-- // Services
local HttpService = game:GetService('HttpService')

-- // Variables
local Cache = {}
local MissingFunctions = {}
local Methods = {
    debug.getconstant,
    debug.getconstants,
    debug.getinfo,
    debug.getproto,
    debug.getprotos,
    debug.getstack,
    debug.getupvalue,
    debug.getupvalues,
    debug.setconstant,
    debug.setstack,
    debug.setupvalue,
    getcallingscript,
    getconnections,
    getgc,
    getgenv,
    getloadedmodules,
    getnamecallmethod,
    getrawmetatable,
    getsenv,
    hookfunction,
    hookmetamethod,
    newcclosure,
    setclipboard,
    setreadonly,
    checkcaller
}
local Visual = {
    Loaded = true,
    Name = HttpService:GenerateGUID()
}

-- // Check Exploit Compatibility
local MethodsAmount = #Methods
local CheckedAmount = 0

for Index, _ in next, Methods do
    CheckedAmount += 1
end

if CheckedAmount < MethodsAmount then
    error('[Visual] Error: Your exploit is not supported.')
end

-- // Environment
local Environment = getgenv()
Environment.Visual = Visual

-- // Functions
function Environment.Import(URL)
    if Cache[URL] then
        return table.unpack(Cache[URL])
    end

    local BaseURL = 'https://raw.githubusercontent.com/VisualRoblox/Roblox/main/Utilities/Visual/'
    local Imported = { loadstring(game:HttpGet(BaseURL .. URL))() }
    Cache[URL] = Imported

    return table.unpack(Imported)
end

-- // Imports
local UIHandler = Import('UI/UIHandler.lua')
UIHandler.LoadUI()