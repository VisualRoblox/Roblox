local DraggingHandler = {}

function DraggingHandler.EnableDragging(Frame)
    local UserInputService = game:GetService('UserInputService')

    local Dragging, DraggingInput, MousePosition, FramePosition

    Frame.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            MousePosition = Input.Position
            FramePosition = Frame.Parent.Position
            
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
            local Delta = Input.Position - MousePosition
            Frame.Parent.Position  = UDim2.new(FramePosition.X.Scale, FramePosition.X.Offset + Delta.X, FramePosition.Y.Scale, FramePosition.Y.Offset + Delta.Y)
        end
    end)
end

return DraggingHandler.EnableDragging