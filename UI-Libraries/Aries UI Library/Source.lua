-- // Services
local Players = game:GetService('Players')
local UserInputService = game:GetService('UserInputService')
local Workspace = game:GetService('Workspace')

-- // Variables
local Color, Insert = Color3.fromRGB, table.insert 
local CurrentCamera = Workspace.CurrentCamera
local ViewportSize = CurrentCamera.ViewportSize
local Center = ViewportSize / 2
local Utility = {}
local UsedKeyCodes = {}
local Library = {
    DrawingObjects = {},
    Navigation = {
        ChangeSection = { Enum.KeyCode.Tab },
		Toggle = { Enum.KeyCode.RightShift },
		Activate = { Enum.KeyCode.Q, Enum.KeyCode.Space },
		Up = { Enum.KeyCode.W, Enum.KeyCode.Up, Enum.KeyCode.PageUp },
		Down = { Enum.KeyCode.S, Enum.KeyCode.Down, Enum.KeyCode.PageDown },
        Left = { Enum.KeyCode.A, Enum.KeyCode.Left },
		Right = { Enum.KeyCode.D, Enum.KeyCode.Right }
    },
    Themes = {
        Dark = {
			Font = Drawing.Fonts.UI,
			FontSize = 18,
            Transparency = 1,
            BackgroundColor = Color(30, 30, 30),
            SecondaryColor = Color(40, 40, 40),
            AccentColor = Color(0, 125, 255),
            PrimaryTextColor = Color(255, 255, 255),
            SecondaryTextColor = Color(125, 125, 125)
		}
    }
}

-- // KeyCodes Being Used
for _, KeyCodes in next, Library.Navigation do
	for Index = 1, #KeyCodes do
		Insert(UsedKeyCodes, KeyCodes[Index])
	end
end

-- // Utility Functions
do
    function Utility:Draw(Type, Properties)
        local Object = Drawing.new(Type)

        for Property, Value in next, Properties do
            Object[Property] = Value
        end

        table.insert(Library.DrawingObjects, Object)

        return Object
    end

    function Utility:Switch(Value, Callbacks)
        if Callbacks[Value] then
            pcall(Callbacks[Value])
        else
            return
        end
    end

    function Utility:Destroy()
        for _, Object in next, Library.DrawingObjects do
            Object:Remove()
        end
    end
end

-- // Library Main
function Library:CreateWindow(Name, Watermark, Theme)
    local WindowInternal = {
        Name = Name or 'Aries UI Library',
        Watermark = Watermark or false,
        Theme = Theme or Library.Themes.Dark,
        SelectedSection = nil,
        Visible = true
    }

    local Window = setmetatable(
		{}, 
        { 
            __newindex = function(...)
                return rawset(WindowInternal, select(2, ...))
            end,
            __index = function(...)
                return rawget(WindowInternal, select(2, ...))
            end 
        }
	)
    
    local Watermark = Utility:Draw(
		'Text', 
        {
			Text = Window.Name,
			Font = Window.Theme.Font,
			Size = Window.Theme.FontSize + 2,
			Visible = Window.Visible,
			Color = Window.Theme.PrimaryTextColor,
			Transparency = Window.Theme.Transparency,
			Position = ViewportSize
		}
	)

    Watermark.Position -= Watermark.TextBounds + Vector2.new(5, 5)

    if Window.Watermark then
        Watermark.Visible = true
    else
        Watermark.Visible = false
    end

end

-- // Example
local Window = Library:CreateWindow({
    Name = 'Aries UI Library'
})




task.wait(5)

Utility:Destroy()