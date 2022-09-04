-- // Services
local UserInputService = game:GetService('UserInputService')

local DraggingHandler = {}

function DraggingHandler.EnableDragging(Frame)
    local Dragging, DraggingInput, DragStart, StartPosition
        
    local function Update(Input)
        local Delta = Input.Position - DragStart
        Frame.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
    end
    
    Frame.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = Input.Position
            StartPosition = Frame.Position
    
            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    
    Frame.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then
            DraggingInput = Input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if Input == DraggingInput and Dragging then
            Update(Input)
        end
    end)
end

return DraggingHandler.EnableDragging