-- // Services
local TweenService = game:GetService('TweenService')
local CoreGui = game:GetService('CoreGui')
local UserInputService = game:GetService('UserInputService')
local TextService = game:GetService('TextService')

-- // Variables
local UtilityFunctions = {}
local UIFunctions = {}
local Visual = {
    Loaded = true,
    Name = 'VisualSpy',
    ClickThrough = true
}

-- // Utility Functions
do
    function UtilityFunctions:Log(Type, Message)
        Type = Type:lower()
        if Type == 'error' then
            error('[ Visual ] Error: ' .. Message)
        elseif Type == 'log' then
            print('[ Visual ] ' .. Message)
        elseif Type == 'warn' then
            warn('[ Visual ] Warning: ' .. Message)
        end
    end

    function UtilityFunctions:HasProperty(Instance, Property)
        local Success = pcall(function()
            return Instance[Property]
        end)
        
        return Success and not Instance:FindFirstChild(Property)
    end

    function UtilityFunctions:HasMethods(Name)
        local CurrentIndex = 0
        local Methods = {
            ['Remote Spy'] = {
                getcallingscript,
                hookmetamethod,
                getnamecallmethod,
                newcclosure,
                setclipboard,
                function() end
            },
            ['HTTP Spy'] = {
                hookfunction,
                newcclosure,
                setclipboard,
                function() end
            }
        }

        local MethodsAmount = #Methods[Name]
        
        for Index, _ in next, Methods[Name] do
            CurrentIndex += 1
        end

        if CurrentIndex < MethodsAmount then
            return false
        else
            return true
        end
    end
end

-- // UI Functions
do 
    function UIFunctions:Tween(Instance, Properties, Duration, ...)
        local TweenInfo = TweenInfo.new(Duration, ...)
        TweenService:Create(Instance, TweenInfo, Properties):Play()
    end

    function UIFunctions:Destroy()
        UtilityFunctions:Log('Log', 'Destroy UI Called')
        for _, UI in next, CoreGui:GetChildren() do
            if UI.Name == 'VisualSpy' then
                for _, Item in next, UI.Base:GetChildren() do
                    if Item.Name ~= 'BaseCorner' and Item.Name ~= 'BaseStroke' then
                        Item:Destroy()
                    end
                end
    
                UIFunctions:Tween(UI.Base, {Size = UDim2.new(0, 650, 0, 0)}, 0.25)
                task.wait(0.25)
    
                UI:Destroy()
                UtilityFunctions:Log('Log', 'UI Destroyed')
    
                Visual.Loaded = false 
                UtilityFunctions:Log('Log', 'Unloaded Visual Analyser')
            end
        end
    end

    function UIFunctions:Create(InstanceName, Properties, Children)
        local Object = Instance.new(InstanceName)
        local Properties = Properties or {}
        local Children = Children or {}
        
        for Index, Property in next, Properties do
            Object[Index] = Property
        end
    
        for _, Child in next, Children do
            Child.Parent = Object
        end

        UtilityFunctions:Log('Log', string.format('Created Object: %s | %s', InstanceName, tostring(Object)))

        return Object
    end

    function UIFunctions:Toggle()
        UtilityFunctions:Log('Log', 'Toggle UI Called')
        if CoreGui:FindFirstChild('VisualSpy'):FindFirstChild('Base').Visible then
            local Base = CoreGui:FindFirstChild('VisualSpy').Base
            local OpenButton = CoreGui:FindFirstChild('VisualSpy').OpenButton
            OpenButton.Visible = true
            UIFunctions:Tween(OpenButton, {BackgroundTransparency = 0}, 0.25)
            UIFunctions:Tween(OpenButton, {ImageTransparency = 0}, 0.25)
            OpenButton.OpenButtonBaseStroke.Thickness = 1
            for _, Instance in next, Base:GetChildren() do
                if UtilityFunctions:HasProperty(Instance, 'Visible') then
                    Instance.Visible = false
                end
            end
            UIFunctions:Tween(Base, {Size = UDim2.new(0, 650, 0, 0)}, 0.25)
            task.wait(0.25)
            Base.Visible = false
        else
            local Base = CoreGui:FindFirstChild('VisualSpy').Base
            local OpenButton = CoreGui:FindFirstChild('VisualSpy').OpenButton
            UIFunctions:Tween(OpenButton, {BackgroundTransparency = 1}, 0.25)
            UIFunctions:Tween(OpenButton, {ImageTransparency = 1}, 0.25)
            OpenButton.OpenButtonBaseStroke.Thickness = 0
            Base.Visible = true
            UIFunctions:Tween(Base, {Size = UDim2.new(0, 650, 0, 375)}, 0.25)
            for _, Instance in next, Base:GetChildren() do
                if UtilityFunctions:HasProperty(Instance, 'Visible') then
                    Instance.Visible = true
                end
            end
            OpenButton.Visible = false
        end
    end

    function UIFunctions:Lighten(Color)
        local H, S, V = Color:ToHSV()

        V = math.clamp(V + 0.03, 0, 1)

        return Color3.fromHSV(H, S, V)
    end

    function UIFunctions:EnableDragging(Frame)
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

    function UIFunctions:CreatePrompt(Type, Title, Text, ...)
        local Title = Title or 'Title'
        local Text = Text or 'Text'

        for _, Item in next, CoreGui:WaitForChild(Visual.Name):WaitForChild('Base'):WaitForChild('PromptHolder'):GetChildren() do
            if Item:IsA('Frame') then
                Item:Destroy()
            end
        end

        if Type == 'Text' then
            local ButtonText = ...
            Visual.ClickThrough = false
            UIFunctions:Create('Frame', {
                Name = Title..'PromptFrame',
                Parent = CoreGui:WaitForChild(Visual.Name):WaitForChild('Base'):WaitForChild('PromptHolder'),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BorderSizePixel = 0,
                ZIndex = 101,
                BackgroundTransparency = 0,
                Size = UDim2.new(0, 0, 0, 0)
            }, {
                UIFunctions:Create('UICorner', {
                    Name = Title..'PromptFrameCorner',
                    CornerRadius = UDim.new(0, 100)
                }),
                UIFunctions:Create('UIStroke', {
                    Name = Title..'PromptFrameStroke',
                    ApplyStrokeMode = 'Contextual',
                    Color = Color3.fromRGB(75, 75, 75),
                    LineJoinMode = 'Round',
                    Thickness = 1
                }),
                UIFunctions:Create('TextLabel', {
                    Name = Title..'PromptTitle',
                    TextTransparency = 1,
                    BackgroundTransparency = 1,
                    TextWrapped = true,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 5),
                    Size = UDim2.new(0, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = Title,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 20,
                    ZIndex = 102,
                    TextXAlignment = Enum.TextXAlignment.Center
                }),
                UIFunctions:Create('TextLabel', {
                    Name = Title..'PromptText',
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                    TextWrapped = true,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 26),
                    Size = UDim2.new(0, 280, 0, 77),
                    Font = Enum.Font.Gotham,
                    Text = Text,
                    TextColor3 = Color3.fromRGB(175, 175, 175),
                    TextSize = 15,
                    ZIndex = 102,
                    TextXAlignment = Enum.TextXAlignment.Center
                }),
                UIFunctions:Create('TextButton', {
                    Name = Title..'Button',
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                    Text = ButtonText,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Color3.fromRGB(175, 175, 175),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Position = UDim2.new(0, 10, 0, 110),
                    Size = UDim2.new(0, 280, 0, 30),
                    BorderSizePixel = 0,
                    TextSize = 15,
                    ZIndex = 103,
                    Visible = true,
                    AutoButtonColor = false
                }, {
                    UIFunctions:Create('UIStroke', {
                        Name = Title..'ButtonStroke',
                        ApplyStrokeMode = 'Border',
                        Color = Color3.fromRGB(75, 75, 75),
                        LineJoinMode = 'Round',
                        Thickness = 0
                    }),
                    UIFunctions:Create('UICorner', {
                        Name = Title..'ButtonCorner',
                        CornerRadius = UDim.new(0, 5)
                    })
                })
            })

            local PromptHolder = CoreGui:WaitForChild(Visual.Name):WaitForChild('Base'):WaitForChild('PromptHolder')
            local PromptFrame = PromptHolder[Title..'PromptFrame']
            local PromptFrameCorner = PromptFrame[Title..'PromptFrameCorner']
            local Button = PromptFrame[Title..'Button']
            local ButtonStroke = Button[Title..'ButtonStroke']
            local PromptText = PromptFrame[Title..'PromptText']
            local PromptTitle = PromptFrame[Title..'PromptTitle']

            local TitleTextSize = TextService:GetTextSize(Title, 20, Enum.Font.Gotham, Vector2.new(280, 0))
            
            UIFunctions:Tween(PromptTitle, {Size = UDim2.new(0, TitleTextSize.X, 0, TitleTextSize.Y)}, 0.25)

            UIFunctions:Tween(PromptHolder, {BackgroundTransparency = 0.25}, 0.25)
            task.wait(0.25)
            UIFunctions:Tween(PromptFrame, {BackgroundTransparency = 0}, 0.25)
            UIFunctions:Tween(PromptFrame, {Size = UDim2.new(0, 300, 0, 150)}, 0.25)
            UIFunctions:Tween(PromptFrameCorner, {CornerRadius = UDim.new(0, 5)}, 0.25)
            task.wait(0.25)
            UIFunctions:Tween(ButtonStroke, {Thickness = 1}, 0.25)
            task.wait(0.25)
            UIFunctions:Tween(PromptText, {TextTransparency = 0}, 0.25)
            UIFunctions:Tween(PromptTitle, {TextTransparency = 0}, 0.25)
            UIFunctions:Tween(Button, {BackgroundTransparency = 0}, 0.25)
            UIFunctions:Tween(Button, {TextTransparency = 0}, 0.25)

            Button.MouseEnter:Connect(function(Input)
                UIFunctions:Tween(Button, {TextColor3 = UIFunctions:Lighten(Color3.fromRGB(255, 255, 255))}, 0.25)
            end)

            Button.MouseLeave:Connect(function(Input)
                UIFunctions:Tween(Button, {TextColor3 = Color3.fromRGB(175, 175, 175)}, 0.25)
            end)
            
            Button.MouseButton1Down:Connect(function()
                UIFunctions:Tween(Button, {BackgroundTransparency = 1}, 0.25)
                UIFunctions:Tween(Button, {TextTransparency = 1}, 0.25)
                UIFunctions:Tween(PromptText, {TextTransparency = 1}, 0.25)
                UIFunctions:Tween(PromptTitle, {TextTransparency = 1}, 0.25)
                task.wait(0.25)
                UIFunctions:Tween(ButtonStroke, {Thickness = 0}, 0.25)
                task.wait(0.25)
                UIFunctions:Tween(PromptFrame, {BackgroundTransparency = 1}, 0.25)
                UIFunctions:Tween(PromptFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25)
                UIFunctions:Tween(PromptFrameCorner, {CornerRadius = UDim.new(0, 100)}, 0.25)
                task.wait(0.25)
                UIFunctions:Tween(PromptHolder, {BackgroundTransparency = 1}, 0.25)
                task.wait()
                PromptFrame:Destroy()
                VisualClickThrough = true
            end)

        elseif Type == 'OneButton' then
            local Args = ...
            local ButtonText = Args[1]
            local ButtonCallback = Args[2]
            Visual.ClickThrough = false
            UIFunctions:Create('Frame', {
                Name = Title..'PromptFrame',
                Parent = CoreGui:WaitForChild(Visual.Name):WaitForChild('Base'):WaitForChild('PromptHolder'),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BorderSizePixel = 0,
                ZIndex = 101,
                BackgroundTransparency = 0,
                Size = UDim2.new(0, 0, 0, 0)
            }, {
                UIFunctions:Create('UICorner', {
                    Name = Title..'PromptFrameCorner',
                    CornerRadius = UDim.new(0, 100)
                }),
                UIFunctions:Create('UIStroke', {
                    Name = Title..'PromptFrameStroke',
                    ApplyStrokeMode = 'Contextual',
                    Color = Color3.fromRGB(75, 75, 75),
                    LineJoinMode = 'Round',
                    Thickness = 1
                }),
                UIFunctions:Create('TextLabel', {
                    Name = Title..'PromptTitle',
                    TextTransparency = 1,
                    BackgroundTransparency = 1,
                    TextWrapped = true,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 5),
                    Size = UDim2.new(0, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = Title,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 20,
                    ZIndex = 102,
                    TextXAlignment = Enum.TextXAlignment.Center
                }),
                UIFunctions:Create('TextLabel', {
                    Name = Title..'PromptText',
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                    TextWrapped = true,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 26),
                    Size = UDim2.new(0, 280, 0, 77),
                    Font = Enum.Font.Gotham,
                    Text = Text,
                    TextColor3 = Color3.fromRGB(175, 175, 175),
                    TextSize = 15,
                    ZIndex = 102,
                    TextXAlignment = Enum.TextXAlignment.Center
                }),
                UIFunctions:Create('TextButton', {
                    Name = Title..'Button',
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                    Text = ButtonText,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Color3.fromRGB(175, 175, 175),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Position = UDim2.new(0, 10, 0, 110),
                    Size = UDim2.new(0, 280, 0, 30),
                    BorderSizePixel = 0,
                    TextSize = 15,
                    ZIndex = 103,
                    Visible = true,
                    AutoButtonColor = false
                }, {
                    UIFunctions:Create('UIStroke', {
                        Name = Title..'ButtonStroke',
                        ApplyStrokeMode = 'Border',
                        Color = Color3.fromRGB(75, 75, 75),
                        LineJoinMode = 'Round',
                        Thickness = 0
                    }),
                    UIFunctions:Create('UICorner', {
                        Name = Title..'ButtonCorner',
                        CornerRadius = UDim.new(0, 5)
                    })
                })
            })

            local PromptHolder = CoreGui:WaitForChild(Visual.Name):WaitForChild('Base'):WaitForChild('PromptHolder')
            local PromptFrame = PromptHolder[Title..'PromptFrame']
            local PromptFrameCorner = PromptFrame[Title..'PromptFrameCorner']
            local Button = PromptFrame[Title..'Button']
            local ButtonStroke = Button[Title..'ButtonStroke']
            local PromptText = PromptFrame[Title..'PromptText']
            local PromptTitle = PromptFrame[Title..'PromptTitle']

            local TitleTextSize = TextService:GetTextSize(Title, 20, Enum.Font.Gotham, Vector2.new(280, 0))
            
            UIFunctions:Tween(PromptTitle, {Size = UDim2.new(0, TitleTextSize.X, 0, TitleTextSize.Y)}, 0.25)

            UIFunctions:Tween(PromptHolder, {BackgroundTransparency = 0.1}, 0.25)
            task.wait(0.25)
            UIFunctions:Tween(PromptFrame, {BackgroundTransparency = 0}, 0.25)
            UIFunctions:Tween(PromptFrame, {Size = UDim2.new(0, 300, 0, 150)}, 0.25)
            UIFunctions:Tween(PromptFrameCorner, {CornerRadius = UDim.new(0, 5)}, 0.25)
            task.wait(0.25)
            UIFunctions:Tween(ButtonStroke, {Thickness = 1}, 0.25)
            task.wait(0.25)
            UIFunctions:Tween(PromptText, {TextTransparency = 0}, 0.25)
            UIFunctions:Tween(PromptTitle, {TextTransparency = 0}, 0.25)
            UIFunctions:Tween(Button, {BackgroundTransparency = 0}, 0.25)
            UIFunctions:Tween(Button, {TextTransparency = 0}, 0.25)

            Button.MouseEnter:Connect(function(Input)
                UIFunctions:Tween(Button, {TextColor3 = UIFunctions:Lighten(Color3.fromRGB(255, 255, 255))}, 0.25)
            end)

            Button.MouseLeave:Connect(function(Input)
                UIFunctions:Tween(Button, {TextColor3 = Color3.fromRGB(175, 175, 175)}, 0.25)
            end)
            
            Button.MouseButton1Down:Connect(function()
                pcall(ButtonCallback)
                UIFunctions:Tween(Button, {BackgroundTransparency = 1}, 0.25)
                UIFunctions:Tween(Button, {TextTransparency = 1}, 0.25)
                UIFunctions:Tween(PromptText, {TextTransparency = 1}, 0.25)
                UIFunctions:Tween(PromptTitle, {TextTransparency = 1}, 0.25)
                task.wait(0.25)
                UIFunctions:Tween(ButtonStroke, {Thickness = 0}, 0.25)
                task.wait(0.25)
                UIFunctions:Tween(PromptFrame, {BackgroundTransparency = 1}, 0.25)
                UIFunctions:Tween(PromptFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25)
                UIFunctions:Tween(PromptFrameCorner, {CornerRadius = UDim.new(0, 100)}, 0.25)
                task.wait(0.25)
                UIFunctions:Tween(PromptHolder, {BackgroundTransparency = 1}, 0.25)
                task.wait()
                PromptFrame:Destroy()
                Visual.ClickThrough = true
            end)
            
        elseif Type == 'TwoButton' then
            local Args = ...
            local Button1Text = Args[1]
            local Button1Callback = Args[2]
            local Button2Text = Args[3]
            local Button2Callback = Args[4]
            Visual.ClickThrough = false
            UIFunctions:Create('Frame', {
                Name = Title..'PromptFrame',
                Parent = CoreGui:WaitForChild(Visual.Name):WaitForChild('Base'):WaitForChild('PromptHolder'),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BorderSizePixel = 0,
                ZIndex = 101,
                BackgroundTransparency = 0,
                Size = UDim2.new(0, 0, 0, 0)
            }, {
                UIFunctions:Create('UICorner', {
                    Name = Title..'PromptFrameCorner',
                    CornerRadius = UDim.new(0, 100)
                }),
                UIFunctions:Create('UIStroke', {
                    Name = Title..'PromptFrameStroke',
                    ApplyStrokeMode = 'Contextual',
                    Color = Color3.fromRGB(75, 75, 75),
                    LineJoinMode = 'Round',
                    Thickness = 1
                }),
                UIFunctions:Create('TextLabel', {
                    Name = Title..'PromptTitle',
                    TextTransparency = 1,
                    BackgroundTransparency = 1,
                    TextWrapped = true,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 5),
                    Size = UDim2.new(0, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = Title,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 20,
                    ZIndex = 102,
                    TextXAlignment = Enum.TextXAlignment.Center
                }),
                UIFunctions:Create('TextLabel', {
                    Name = Title..'PromptText',
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                    TextWrapped = true,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 26),
                    Size = UDim2.new(0, 280, 0, 77),
                    Font = Enum.Font.Gotham,
                    Text = Text,
                    TextColor3 = Color3.fromRGB(175, 175, 175),
                    TextSize = 15,
                    ZIndex = 102,
                    TextXAlignment = Enum.TextXAlignment.Center
                }),
                UIFunctions:Create('TextButton', {
                    Name = Title..'Button1',
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                    Text = Button1Text,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Color3.fromRGB(175, 175, 175),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Position = UDim2.new(0, 10, 0, 110),
                    Size = UDim2.new(0, 135, 0, 30),
                    BorderSizePixel = 0,
                    TextSize = 15,
                    ZIndex = 103,
                    Visible = true,
                    AutoButtonColor = false
                }, {
                    UIFunctions:Create('UIStroke', {
                        Name = Title..'Button1Stroke',
                        ApplyStrokeMode = 'Border',
                        Color = Color3.fromRGB(75, 75, 75),
                        LineJoinMode = 'Round',
                        Thickness = 0
                    }),
                    UIFunctions:Create('UICorner', {
                        Name = Title..'Button1Corner',
                        CornerRadius = UDim.new(0, 5)
                    })
                }),
                UIFunctions:Create('TextButton', {
                    Name = Title..'Button2',
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                    Text = Button2Text,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Color3.fromRGB(175, 175, 175),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Position = UDim2.new(0, 155, 0, 110),
                    Size = UDim2.new(0, 135, 0, 30),
                    BorderSizePixel = 0,
                    TextSize = 15,
                    ZIndex = 103,
                    Visible = true,
                    AutoButtonColor = false
                }, {
                    UIFunctions:Create('UIStroke', {
                        Name = Title..'Button2Stroke',
                        ApplyStrokeMode = 'Border',
                        Color = Color3.fromRGB(75, 75, 75),
                        LineJoinMode = 'Round',
                        Thickness = 0
                    }),
                    UIFunctions:Create('UICorner', {
                        Name = Title..'Button2Corner',
                        CornerRadius = UDim.new(0, 5)
                    })
                })
            })

            local PromptHolder = CoreGui:WaitForChild(Visual.Name):WaitForChild('Base'):WaitForChild('PromptHolder')
            local PromptFrame = PromptHolder[Title..'PromptFrame']
            local PromptFrameCorner = PromptFrame[Title..'PromptFrameCorner']
            local Button1 = PromptFrame[Title..'Button1']
            local Button2 = PromptFrame[Title..'Button2']
            local Button1Stroke = Button1[Title..'Button1Stroke']
            local Button2Stroke = Button2[Title..'Button2Stroke']
            local PromptText = PromptFrame[Title..'PromptText']
            local PromptTitle = PromptFrame[Title..'PromptTitle']

            local TitleTextSize = TextService:GetTextSize(Title, 20, Enum.Font.Gotham, Vector2.new(280, 0))
            
            UIFunctions:Tween(PromptTitle, {Size = UDim2.new(0, TitleTextSize.X, 0, TitleTextSize.Y)}, 0.25)

            UIFunctions:Tween(PromptHolder, {BackgroundTransparency = 0.1}, 0.25)
            task.wait(0.25)
            UIFunctions:Tween(PromptFrame, {BackgroundTransparency = 0}, 0.25)
            UIFunctions:Tween(PromptFrame, {Size = UDim2.new(0, 300, 0, 150)}, 0.25)
            UIFunctions:Tween(PromptFrameCorner, {CornerRadius = UDim.new(0, 5)}, 0.25)
            task.wait(0.25)
            UIFunctions:Tween(Button1Stroke, {Thickness = 1}, 0.25)
            UIFunctions:Tween(Button2Stroke, {Thickness = 1}, 0.25)
            task.wait(0.25)
            UIFunctions:Tween(PromptText, {TextTransparency = 0}, 0.25)
            UIFunctions:Tween(PromptTitle, {TextTransparency = 0}, 0.25)
            UIFunctions:Tween(Button1, {BackgroundTransparency = 0}, 0.25)
            UIFunctions:Tween(Button1, {TextTransparency = 0}, 0.25)
            UIFunctions:Tween(Button2, {BackgroundTransparency = 0}, 0.25)
            UIFunctions:Tween(Button2, {TextTransparency = 0}, 0.25)

            Button1.MouseEnter:Connect(function(Input)
                UIFunctions:Tween(Button1, {TextColor3 = UIFunctions:Lighten(Color3.fromRGB(255, 255, 255))}, 0.25)
            end)

            Button1.MouseLeave:Connect(function(Input)
                UIFunctions:Tween(Button1, {TextColor3 = Color3.fromRGB(175, 175, 175)}, 0.25)
            end)
            
            Button1.MouseButton1Down:Connect(function()
                pcall(Button1Callback)
                UIFunctions:Tween(Button1, {BackgroundTransparency = 1}, 0.25)
                UIFunctions:Tween(Button1, {TextTransparency = 1}, 0.25)
                UIFunctions:Tween(Button2, {BackgroundTransparency = 1}, 0.25)
                UIFunctions:Tween(Button2, {TextTransparency = 1}, 0.25)
                UIFunctions:Tween(PromptText, {TextTransparency = 1}, 0.25)
                UIFunctions:Tween(PromptTitle, {TextTransparency = 1}, 0.25)
                task.wait(0.25)
                UIFunctions:Tween(Button1Stroke, {Thickness = 0}, 0.25)
                UIFunctions:Tween(Button2Stroke, {Thickness = 0}, 0.25)
                task.wait(0.25)
                UIFunctions:Tween(PromptFrame, {BackgroundTransparency = 1}, 0.25)
                UIFunctions:Tween(PromptFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25)
                UIFunctions:Tween(PromptFrameCorner, {CornerRadius = UDim.new(0, 100)}, 0.25)
                task.wait(0.25)
                UIFunctions:Tween(PromptHolder, {BackgroundTransparency = 1}, 0.25)
                task.wait()
                PromptFrame:Destroy()
                Visual.ClickThrough = true
            end)

            Button2.MouseEnter:Connect(function(Input)
                UIFunctions:Tween(Button2, {TextColor3 = UIFunctions:Lighten(Color3.fromRGB(255, 255, 255))}, 0.25)
            end)

            Button2.MouseLeave:Connect(function(Input)
                UIFunctions:Tween(Button2, {TextColor3 = Color3.fromRGB(175, 175, 175)}, 0.25)
            end)
            
            Button2.MouseButton1Down:Connect(function()
                pcall(Button2Callback)
                UIFunctions:Tween(Button1, {BackgroundTransparency = 1}, 0.25)
                UIFunctions:Tween(Button1, {TextTransparency = 1}, 0.25)
                UIFunctions:Tween(Button2, {BackgroundTransparency = 1}, 0.25)
                UIFunctions:Tween(Button2, {TextTransparency = 1}, 0.25)
                UIFunctions:Tween(PromptText, {TextTransparency = 1}, 0.25)
                UIFunctions:Tween(PromptTitle, {TextTransparency = 1}, 0.25)
                task.wait(0.25)
                UIFunctions:Tween(Button1Stroke, {Thickness = 0}, 0.25)
                UIFunctions:Tween(Button2Stroke, {Thickness = 0}, 0.25)
                task.wait(0.25)
                UIFunctions:Tween(PromptFrame, {BackgroundTransparency = 1}, 0.25)
                UIFunctions:Tween(PromptFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25)
                UIFunctions:Tween(PromptFrameCorner, {CornerRadius = UDim.new(0, 100)}, 0.25)
                task.wait(0.25)
                UIFunctions:Tween(PromptHolder, {BackgroundTransparency = 1}, 0.25)
                task.wait()
                PromptFrame:Destroy()
                Visual.ClickThrough = true
            end)
        end
    end
end

-- // UI
-- // Destroy Old UI
UIFunctions:Destroy()

-- // Loaded
Visual.Loaded = true

-- // Initilise UI
UtilityFunctions:Log('Log', 'Initialising UI...')

-- // Create Instances
local Container = UIFunctions:Create('ScreenGui', {
    Parent = CoreGui,
    Name = 'VisualSpy'
}, {
    UIFunctions:Create('Frame', {
        Name = 'Base',
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.25, 0.25),
        Position = UDim2.new(0.25, 0, 0.25, 0),
        Visible = false,
        BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    }, {
        UIFunctions:Create('Frame', {
            Name = 'PromptHolder',
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 650, 0, 375),
            ZIndex = 5,
            BackgroundTransparency = 1,
            Visible = true,
            BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        }, {
            UIFunctions:Create('UICorner', {
                CornerRadius = UDim.new(0, 5),
                Name = 'PromptHolderCorner'
            })
        }),
        UIFunctions:Create('UICorner', {
            Name = 'BaseCorner',
            CornerRadius = UDim.new(0, 5)
        }),
        UIFunctions:Create('UIStroke', {
            Name = 'BaseStroke',
            Color = Color3.fromRGB(75, 75, 75),
            Thickness = 1
        }),
        UIFunctions:Create('Frame', {
            Name = 'SettingsTabHolder',
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 650, 0, 375),
            ZIndex = 6,
            Visible = true,
            BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        }, {
            UIFunctions:Create('UICorner', {
                CornerRadius = UDim.new(0, 5),
                Name = 'SettingsTabHolderCorner'
            })
        }),
    }),
    UIFunctions:Create('ImageButton', {
        Name = 'OpenButton',
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(0, 40, 0, 40),
        AutoButtonColor = false,
        Image = 'rbxassetid://10618644218',
        ImageTransparency = 1,
    }, {
        UIFunctions:Create('UICorner', {
            Name = 'OpenButtonCorner',
            CornerRadius = UDim.new(0, 100)
        }),
        UIFunctions:Create('UIStroke', {
            Name = 'OpenButtonBaseStroke',
            Color = Color3.fromRGB(0, 150, 255),
            Thickness = 0
        }),
    })
})


-- // Enable Dragging
UIFunctions:EnableDragging(Container['Base'])

-- // Animated Loading
Container['Base'].Visible = true
Container['Base'].Size = UDim2.new(0, 650, 0, 0)


UIFunctions:Tween(Container['Base'], {Size = UDim2.new(0, 650, 0, 375)}, 0.25)

task.wait(0.1)

-- // Topbar
UIFunctions:Create('Frame', {
    Name = 'Topbar',
    Parent = Container['Base'],
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(0, 650, 0, 25),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30)
}, {
    UIFunctions:Create('UICorner', {
        Name = 'TopbarCorner',
        CornerRadius = UDim.new(0, 5)
    }),
    UIFunctions:Create('Frame', {
        Name = 'TopbarLine',
        Position = UDim2.new(0, 0, 0, 26),
        Size = UDim2.new(0, 650, 0, 1),
        BackgroundColor3 = Color3.fromRGB(75, 75, 75),
        BorderSizePixel = 0
    }),
    UIFunctions:Create('TextLabel', {
        Name = 'TitleSectionOne',
        Position = UDim2.new(0, 5, 0, 4),
        Size = UDim2.new(0, 50, 0, 20),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        TextColor3 = Color3.fromRGB(0, 150, 255),
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0,
        TextSize = 18,
        Text = 'Visual'
    }),
    UIFunctions:Create('TextLabel', {
        Name = 'TitleSectionTwo',
        Position = UDim2.new(0, 57, 0, 4),
        Size = UDim2.new(0, 35, 0, 20),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0,
        TextSize = 18,
        Text = 'Spy'
    }),
    UIFunctions:Create('TextButton', {
        Name = 'CloseButton',
        Position = UDim2.new(0, 625, 0, 0),
        Size = UDim2.new(0, 25, 0, 25),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        AutoButtonColor = false,
        Font = Enum.Font.Gotham,
        TextYAlignment = Enum.TextYAlignment.Center,
        BorderSizePixel = 0,
        TextSize = 30,
        Text = '×'
    }, {
        UIFunctions:Create('UICorner', {
            Name = 'CloseButtonCorner',
            CornerRadius = UDim.new(0, 5)
        }),
    }),
    UIFunctions:Create('TextButton', {
        Name = 'MinimiseButton',
        Position = UDim2.new(0, 600, 0, 0),
        Size = UDim2.new(0, 25, 0, 25),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        AutoButtonColor = false,
        Font = Enum.Font.Gotham,
        TextYAlignment = Enum.TextYAlignment.Center,
        BorderSizePixel = 0,
        TextSize = 30,
        Text = '-'
    }, {
        UIFunctions:Create('UICorner', {
            Name = 'MinimiseButtonCorner',
            CornerRadius = UDim.new(0, 5)
        }),
    }),
})

-- // Sidebar
UIFunctions:Create('Frame', {
    Name = 'Sidebar',
    Parent = Container['Base'],
    Position = UDim2.new(0, 0, 0, 27),
    Size = UDim2.new(0, 165, 0, 348),
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    ZIndex = 2
}, {
    UIFunctions:Create('UIStroke', {
        Name = 'SidebarStroke',
        Color = Color3.fromRGB(75, 75, 75),
        Thickness = 1
    }),
    UIFunctions:Create('UICorner', {
        Name = 'SidebarCorner',
        CornerRadius = UDim.new(0, 5)
    }),
    UIFunctions:Create('ScrollingFrame', {
        Name = 'SidebarScrolling',
        Parent = Container['Base'],
        Position = UDim2.new(0, 0, 0, 2),
        Size = UDim2.new(0, 165, 0, 343),
        BorderSizePixel = 0,
        ScrollBarImageColor3 = Color3.fromRGB(75, 75, 75),
        ScrollBarThickness = 0,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        ZIndex = 2
    }, {
        UIFunctions:Create('UIListLayout', {
            Name = 'SidebarScrollingListLayout',
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, -1)
        })
    }),
    UIFunctions:Create('Frame', {
        Name = 'SidebarFiller1',
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 5, 0, 5),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }),
    UIFunctions:Create('Frame', {
        Name = 'SidebarFiller2',
        Position = UDim2.new(0, 160, 0, 0),
        Size = UDim2.new(0, 5, 0, 5),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }),
    UIFunctions:Create('Frame', {
        Name = 'SidebarFiller3',
        Position = UDim2.new(0, 160, 0, 343),
        Size = UDim2.new(0, 5, 0, 5),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }),
    UIFunctions:Create('Frame', {
        Name = 'SidebarLine1',
        Position = UDim2.new(0, 165, 0, 0),
        Size = UDim2.new(0, 1, 0, 10),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundColor3 = Color3.fromRGB(75, 75, 75)
    }),
    UIFunctions:Create('Frame', {
        Name = 'SidebarLine2',
        Position = UDim2.new(0, 165, 0, 338),
        Size = UDim2.new(0, 1, 0, 10),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundColor3 = Color3.fromRGB(75, 75, 75)
    })
})

-- // Tabs Holder
UIFunctions:Create('Frame', {
    Name = 'TabHolderFrame',
    Parent = Container['Base'],
    Position = UDim2.new(0, 166, 0, 27),
    Size = UDim2.new(0, 484, 0, 348),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30)
}, {
    UIFunctions:Create('UICorner', {
        Name = 'TabHolderFrameCorner',
        CornerRadius = UDim.new(0, 5)
    }),
    UIFunctions:Create('Folder', {
        Name = 'TabHolderFolder',
    })
})

-- // Variables
local Base = Container['Base']
local Topbar = Base['Topbar']
local CloseButton = Topbar['CloseButton']
local MinimiseButton = Topbar['MinimiseButton']
local OpenButton = Container['OpenButton']
local TabHolderFrame = Base['TabHolderFrame']
local TabHolderFolder = TabHolderFrame['TabHolderFolder']
local Sidebar = Base['Sidebar']
local SidebarScrolling = Sidebar['SidebarScrolling']
local SidebarScrollingListLayout = SidebarScrolling['SidebarScrollingListLayout']
local SettingsTabHolder = Base['SettingsTabHolder']

-- // Update Sidebar Canvas Size
SidebarScrolling.ChildAdded:Connect(function()
    local CanvasSize = SidebarScrollingListLayout.AbsoluteContentSize

    SidebarScrolling.CanvasSize = UDim2.new(0, CanvasSize.X, 0, CanvasSize.Y)
end)

local CanvasSize = SidebarScrollingListLayout.AbsoluteContentSize

SidebarScrolling.CanvasSize = UDim2.new(0, CanvasSize.X, 0, CanvasSize.Y)

-- // Topbar Buttons
CloseButton.MouseEnter:Connect(function()
    UIFunctions:Tween(CloseButton, {TextColor3 = Color3.fromRGB(125, 125, 125)}, 0.25)
end)

CloseButton.MouseLeave:Connect(function()
    UIFunctions:Tween(CloseButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.25)
end)

CloseButton.MouseButton1Click:Connect(function()
    if Visual.ClickThrough then
        UIFunctions:Tween(CloseButton, {TextColor3 = Color3.fromRGB(125, 125, 125)}, 0.25)
        task.wait(0.25)
        UIFunctions:Tween(CloseButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.25)
        UIFunctions:Destroy()
    end
end)

MinimiseButton.MouseEnter:Connect(function()
    UIFunctions:Tween(MinimiseButton, {TextColor3 = Color3.fromRGB(125, 125, 125)}, 0.25)
end)

MinimiseButton.MouseLeave:Connect(function()
    UIFunctions:Tween(MinimiseButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.25)
end)

MinimiseButton.MouseButton1Click:Connect(function()
    if Visual.ClickThrough then
        UIFunctions:Tween(MinimiseButton, {TextColor3 = Color3.fromRGB(125, 125, 125)}, 0.25)
        task.wait(0.25)
        UIFunctions:Tween(MinimiseButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.25)
        UIFunctions:Toggle()
    end
end)

-- // Minimised Button
OpenButton.MouseEnter:Connect(function()
    UIFunctions:Tween(OpenButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.25)
end)

OpenButton.MouseLeave:Connect(function()
    UIFunctions:Tween(OpenButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.25)
end)

OpenButton.MouseButton1Click:Connect(function()
    if Visual.ClickThrough then
        UIFunctions:Tween(OpenButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.25)
        task.wait(0.25)
        UIFunctions:Tween(OpenButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.25)
        UIFunctions:Toggle()
    end
end)

-- // Tab Functions
local function CreateTab(Name, IsVisible)
    local Name = Name or 'Tab'
    local IsVisible = IsVisible or false
    local Icon, RectOffset, RectSize

    if Name == 'Remote Spy' then
        Icon = 'rbxassetid://3926305904'
        RectOffset = Vector2.new(964, 324)
        RectSize = Vector2.new(36, 36)

    elseif Name == 'HTTP Spy' then
        Icon = 'rbxassetid://3926307971'
        RectOffset = Vector2.new(2, 282)
        RectSize = Vector2.new(40, 40)
    end

    -- // Main
    UIFunctions:Create('Frame', {
        Name = Name .. 'Tab',
        Parent = TabHolderFolder,
        Size = UDim2.new(0, 484, 0, 348),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        Visible = IsVisible
    }, {
        UIFunctions:Create('UICorner', {
            Name = Name .. 'TabCorner',
            CornerRadius = UDim.new(0, 5)
        })
    })
    
    -- // Buttons
    UIFunctions:Create('Frame', {
        Name = Name .. 'TabButtonFrame',
        Parent = SidebarScrolling,
        Size = UDim2.new(0, 165, 0, 30),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }, {
        UIFunctions:Create('ImageLabel', {
            Name = Name .. 'TabIcon',
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ImageColor3 = Color3.fromRGB(175, 175, 175),
            Position = UDim2.new(0, 3, 0, 3),
            Size = UDim2.new(0, 25, 0, 25),
            SliceCenter = Rect.new(0, 15, 0, 15),
            Image = Icon,
            ZIndex = 2,
            ImageRectOffset = RectOffset,
            ImageRectSize = RectSize
        }),
        UIFunctions:Create('TextButton', {
            Name = Name .. 'TabButton',
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0, 165, 0, 30),
            TextColor3 = Color3.fromRGB(175, 175, 175),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Font = Enum.Font.Gotham,
            AutoButtonColor = false,
            Text = '',
            BorderSizePixel = 0,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3,
        }),
        UIFunctions:Create('TextLabel', {
            Name = Name .. 'TabLabel',
            Parent = SidebarScrolling,
            Position = UDim2.new(0, 32, 0, 0),
            Size = UDim2.new(0, 135, 0, 30),
            TextColor3 = Color3.fromRGB(175, 175, 175),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Font = Enum.Font.Gotham,
            Text = Name,
            BorderSizePixel = 0,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2,
        }, {
            UIFunctions:Create('UIPadding', {
                Name = Name .. 'TabButtonTextPadding',
                PaddingLeft = UDim.new(0, 2)
            })
        })
    })

    local Tab = TabHolderFolder[Name .. 'Tab']
    local TabButtonFrame = SidebarScrolling[Name .. 'TabButtonFrame']
    local TabButton = TabButtonFrame[Name .. 'TabButton']
    local TabLabel = TabButtonFrame[Name .. 'TabLabel']
    local TabIcon = TabButtonFrame[Name .. 'TabIcon']

    if IsVisible then
        UIFunctions:Tween(TabLabel, {TextColor3 = Color3.fromRGB(0, 150, 255)}, 0.25)
        UIFunctions:Tween(TabIcon, {ImageColor3 = Color3.fromRGB(0, 150, 255)}, 0.25)
    end
    
    TabButton.MouseEnter:Connect(function()
        if Tab.Visible then
            UIFunctions:Tween(TabLabel, {TextColor3 = Color3.fromRGB(0, 150, 255)}, 0.25)
            UIFunctions:Tween(TabIcon, {ImageColor3 = Color3.fromRGB(0, 150, 255)}, 0.25)
        else
            UIFunctions:Tween(TabLabel, {TextColor3 = Color3.fromRGB(200, 200, 200)}, 0.25)
            UIFunctions:Tween(TabIcon, {ImageColor3 = Color3.fromRGB(200, 200, 200)}, 0.25)
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if Tab.Visible then
            UIFunctions:Tween(TabLabel, {TextColor3 = Color3.fromRGB(0, 150, 255)}, 0.25)
            UIFunctions:Tween(TabIcon, {ImageColor3 = Color3.fromRGB(0, 150, 255)}, 0.25)
        else
            UIFunctions:Tween(TabLabel, {TextColor3 = Color3.fromRGB(175, 175, 175)}, 0.25)
            UIFunctions:Tween(TabIcon, {ImageColor3 = Color3.fromRGB(175, 175, 175)}, 0.25)
        end
    end)

    TabButton.MouseButton1Click:Connect(function()
        if Visual.ClickThrough then
            local HasMethods = UtilityFunctions:HasMethods(Name)
            if HasMethods then
                for _, OtherTab in next, TabHolderFolder:GetChildren() do
                    OtherTab.Visible = false
                end

                for _, Item in next, SidebarScrolling:GetDescendants() do
                    if Item:IsA('TextLabel') then
                        UIFunctions:Tween(Item, {TextColor3 = Color3.fromRGB(175, 175, 175)}, 0.25)
                    elseif Item:IsA('ImageLabel') then
                        UIFunctions:Tween(Item, {ImageColor3 = Color3.fromRGB(175, 175, 175)}, 0.25)
                    end
                end

                UIFunctions:Tween(TabLabel, {TextColor3 = Color3.fromRGB(0, 150, 255)}, 0.25)
                UIFunctions:Tween(TabIcon, {ImageColor3 = Color3.fromRGB(0, 150, 255)}, 0.25)
                Tab.Visible = true
            else
                UIFunctions:CreatePrompt('Text', 'Warning', 'Your exploit is not supported.', 'Alright')
            end
        end
    end)

    return Tab
end

-- // Create Tabs
local RemoteSpy = CreateTab('Remote Spy', true)
local HTTPSpy = CreateTab('HTTP Spy', false)



-- // Remote Spy
UIFunctions:Create('ScrollingFrame', {
    Name = 'RemoteList',
    Parent = RemoteSpy,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(0, 135, 0, 348),
    BorderSizePixel = 0,
    ScrollBarImageColor3 = Color3.fromRGB(75, 75, 75),
    ScrollBarThickness = 1,
    BackgroundColor3 = Color3.fromRGB(32, 32, 32),
    ZIndex = 2
}, {
    UIFunctions:Create('UIListLayout', {
        Name = 'RemoteListLayout',
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    }),
    UIFunctions:Create('UIStroke', {
        Name = 'RemoteListStroke',
        Color = Color3.fromRGB(75, 75, 75),
        Thickness = 1
    })
})

UIFunctions:Create('ScrollingFrame', {
    Name = 'GeneratedScriptHolder',
    Parent = RemoteSpy,
    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 136, 0, 0),
    ScrollBarImageColor3 = Color3.fromRGB(75, 75, 75),
    Size = UDim2.new(0, 348, 0, 348),
    ZIndex = 5,
    ScrollBarThickness = 1
}, {
    UIFunctions:Create('Frame', {
        Name = 'LineAmount',
        Size = UDim2.new(0, 35, 0, 348),
        BackgroundColor3 = Color3.fromRGB(33, 33, 33),
        Position = UDim2.new(0, 0, 0, 0),
        ZIndex = 5,
        Visible = true,
        BackgroundTransparency = 0
    }, {
        UIFunctions:Create('TextLabel', {
            Name = 'LineText',
            Position = UDim2.new(0, 5, 0, 0),
            Size = UDim2.new(0, 27, 0, 30),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(175, 175, 175),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Font = Enum.Font.Gotham,
            Text = '1',
            BorderSizePixel = 0,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 5,
        }),
        UIFunctions:Create('UIStroke', {
            Name = 'LineAmountStroke',
            Color = Color3.fromRGB(75, 75, 75),
            Thickness = 1
        })
    })
})

UIFunctions:Create('Frame', {
    Name = 'SettingsSlideOutHolder',
    Size = UDim2.new(0, 30, 0, 60),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    Parent = RemoteSpy,
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 0),
    ZIndex = 5,
    Visible = true,
    BackgroundTransparency = 0
}, {
    UIFunctions:Create('UICorner', {
        Name = 'SettingsSlideOutHolderCorner',
        CornerRadius = UDim.new(0, 100)
    }),
    UIFunctions:Create('UIStroke', {
        Name = 'SettingsSlideOutHolderStroke',
        Color = Color3.fromRGB(75, 75, 75),
        Thickness = 1
    }),
    UIFunctions:Create('Frame', {
        Name = 'SettingsSlideOutHolderFiller1',
        Position = UDim2.new(0, 0, 0, 0),
        Parent = RemoteSpy,
        Size = UDim2.new(0, 12, 0, 12),
        BorderSizePixel = 0,
        ZIndex = 5,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }),
    UIFunctions:Create('Frame', {
        Name = 'SettingsSlideOutHolderFiller2',
        Position = UDim2.new(0, 18, 0, 0),
        Parent = RemoteSpy,
        Size = UDim2.new(0, 12, 0, 12),
        BorderSizePixel = 0,
        ZIndex = 5,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }),
    UIFunctions:Create('Frame', {
        Name = 'SettingsSlideOutHolderFiller3',
        Position = UDim2.new(0, 18, 0, 48),
        Parent = RemoteSpy,
        Size = UDim2.new(0, 12, 0, 12),
        BorderSizePixel = 0,
        ZIndex = 5,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }),
    UIFunctions:Create('Frame', {
        Name = 'SettingsSlideOutHolderLine1',
        Position = UDim2.new(0, -1, 0, 0),
        Parent = RemoteSpy,
        Size = UDim2.new(0, 1, 0, 12),
        BorderSizePixel = 0,
        ZIndex = 5,
        BackgroundColor3 = Color3.fromRGB(75, 75, 75)
    }),
    UIFunctions:Create('Frame', {
        Name = 'SettingsSlideOutHolderLine2',
        Position = UDim2.new(0, 18, 0, 60),
        Parent = RemoteSpy,
        Size = UDim2.new(0, 12, 0, 1),
        BorderSizePixel = 0,
        ZIndex = 5,
        BackgroundColor3 = Color3.fromRGB(75, 75, 75)
    }),
    UIFunctions:Create('Frame', {
        Name = 'SettingsSlideOutHolderLine1',
        Position = UDim2.new(0, 0, 0, 30),
        Parent = RemoteSpy,
        Size = UDim2.new(0, 30, 0, 1),
        BorderSizePixel = 0,
        ZIndex = 5,
        BackgroundColor3 = Color3.fromRGB(75, 75, 75)
    }),
    UIFunctions:Create('ImageButton', {
        Name = 'SlideOutButton',
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ImageColor3 = Color3.fromRGB(175, 175, 175),
        Size = UDim2.new(0, 25, 0, 25),
        Image = 'rbxassetid://3926305904',
        ZIndex = 5,
        AnchorPoint = Vector2.new(0.5, 0.5),
	    Position = UDim2.new(0.5, 1, 0.5, 15),
        ImageRectOffset = Vector2.new(124, 924),
        ImageRectSize = Vector2.new(36, 36)
    }),
    UIFunctions:Create('ImageButton', {
        Name = 'SettingsButton',
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ImageColor3 = Color3.fromRGB(175, 175, 175),
        Size = UDim2.new(0, 25, 0, 25),
        ZIndex = 5,
        AnchorPoint = Vector2.new(0.5, 0.5),
	    Position = UDim2.new(0.5, 1, 0.5, -15),
        Image = 'rbxassetid://3926307971',
        ImageRectOffset = Vector2.new(324, 124),
        ImageRectSize = Vector2.new(36, 36)
    })
})

local RemoteList = RemoteSpy['RemoteList']
local RemoteListLayout = RemoteList['RemoteListLayout']

local SettingsChildrenCreated = false

RemoteList.ChildAdded:Connect(function()
    local CanvasSize = RemoteListLayout.AbsoluteContentSize

    RemoteList.CanvasSize = UDim2.new(0, CanvasSize.X, 0, CanvasSize.Y)
end)

local CanvasSize = RemoteListLayout.AbsoluteContentSize

RemoteList.CanvasSize = UDim2.new(0, CanvasSize.X, 0, CanvasSize.Y)

-- // Remote Spy Functions
local RemoteSpyFunctions = {}

do
    function RemoteSpyFunctions:CreateSettingsTab(Name, CreateObjects)
        local Name = Name or 'Tab'
        local Icon, RectOffset, RectSize

        
        if Name == 'Settings' then
            Icon = 'rbxassetid://3926307971'
            RectOffset = Vector2.new(323, 124)
            RectSize = Vector2.new(36, 36)
        end

        UIFunctions:Create('Frame', {
            Name = Name .. 'Tab',
            Size = UDim2.new(0, 0, 0, 375),
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            Parent = SettingsTabHolder,
            AnchorPoint = Vector2.new(1, 0.5),
	        Position = UDim2.new(1, 0, 0.5, 0),
            ZIndex = 7,
            Visible = false,
            BackgroundTransparency = 0
        }, {
            UIFunctions:Create('UICorner', {
                Name = Name .. 'TabCorner',
                CornerRadius = UDim.new(0, 5)
            }),
            UIFunctions:Create('UIStroke', {
                Name = 'SettingsTabStroke',
                Color = Color3.fromRGB(75, 75, 75),
                Thickness = 1
            })
        })

        local SettingsSlideOutHolder = RemoteSpy['SettingsSlideOutHolder']
        local SettingsButton = SettingsSlideOutHolder['SettingsButton']
        local Tab = SettingsTabHolder[Name .. 'Tab']

        SettingsButton.MouseEnter:Connect(function()
            UIFunctions:Tween(SettingsButton, {ImageColor3 = Color3.fromRGB(200, 200, 200)}, 0.25)
        end)
        
        SettingsButton.MouseLeave:Connect(function()
            UIFunctions:Tween(SettingsButton, {ImageColor3 = Color3.fromRGB(175, 175, 175)}, 0.25)
        end)
    
        SettingsButton.MouseButton1Click:Connect(function()
            if Visual.ClickThrough then
                Visual.ClickThrough = false
                
                for _, Item in next, SettingsSlideOutHolder:GetDescendants() do
                    if Item:IsA('ImageButton') then
                        UIFunctions:Tween(SettingsButton, {ImageColor3 = Color3.fromRGB(175, 175, 175)}, 0.25)
                    end
                end

                Tab.Visible = true
                UIFunctions:Tween(SettingsButton, {ImageColor3 = Color3.fromRGB(0, 150, 255)}, 0.25)
                UIFunctions:Tween(Tab, {Size = UDim2.new(0, 650, 0, 375)}, 0.25)
                
                task.wait(0.25)

                CreateObjects()
            end
        end)
    
        return Tab
    end
end

local SettingsTab = RemoteSpyFunctions:CreateSettingsTab('Settings', function()
    if not SettingsChildrenCreated then
        UIFunctions:Create('Frame', {
            Name = 'Topbar',
            Size = UDim2.new(0, 650, 0, 30),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BackgroundTransparency = 1,
            Parent = SettingsTabHolder['SettingsTab'],
            ZIndex = 7,
            Visible = true,
        }, {
            UIFunctions:Create('Frame', {
                Name = 'TopbarFiller1',
                Position = UDim2.new(0, 0, 0, 25),
                Size = UDim2.new(0, 5, 0, 5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                ZIndex = 7,
                BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            }),
            UIFunctions:Create('Frame', {
                Name = 'TopbarFiller2',
                Position = UDim2.new(0, 645, 0, 25),
                Size = UDim2.new(0, 5, 0, 5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                ZIndex = 7,
                BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            }),
            UIFunctions:Create('Frame', {
                Name = 'TopbarLine1',
                Position = UDim2.new(0, 0, 0, 30),
                Size = UDim2.new(0, 10, 0, 1),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                ZIndex = 7,
                BackgroundColor3 = Color3.fromRGB(75, 75, 75)
            }),
            UIFunctions:Create('Frame', {
                Name = 'TopbarLine2',
                Position = UDim2.new(0, 640, 0, 30),
                Size = UDim2.new(0, 10, 0, 1),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                ZIndex = 7,
                BackgroundColor3 = Color3.fromRGB(75, 75, 75)
            }),
            UIFunctions:Create('UICorner', {
                Name = 'SettingsTabCorner',
                CornerRadius = UDim.new(0, 5)
            }),
            UIFunctions:Create('UIStroke', {
                Name = 'SettingsTabStroke',
                Color = Color3.fromRGB(75, 75, 75),
                Thickness = 1
            }),
            UIFunctions:Create('ImageButton', {
                Name = 'BackButton',
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                Position = UDim2.new(0, 620, 0, 3),
                BorderSizePixel = 0,
                ImageColor3 = Color3.fromRGB(175, 175, 175),
                Size = UDim2.new(0, 25, 0, 25),
                BackgroundTransparency = 1,
                ImageTransparency = 1,
                Image = 'rbxassetid://3926307971',
                AutoButtonColor = false,
                ZIndex = 7,
                ImageRectOffset = Vector2.new(884, 284),
                ImageRectSize = Vector2.new(36, 36)
            }),
            UIFunctions:Create('TextLabel', {
                Name = 'SettingsTitle',
                Position = UDim2.new(0, 5, 0, 0),
                Size = UDim2.new(0, 135, 0, 30),
                TextColor3 = Color3.fromRGB(175, 175, 175),
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                Font = Enum.Font.Gotham,
                BackgroundTransparency = 1,
                TextTransparency = 1,
                Text = 'Settings',
                BorderSizePixel = 0,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 7,
            }, {
                UIFunctions:Create('UIPadding', {
                    Name = 'TabButtonTextPadding',
                    PaddingLeft = UDim.new(0, 0)
                })
            })
        })
    end

    SettingsChildrenCreated = true

    local Tab = SettingsTabHolder['SettingsTab']
    local Topbar = Tab['Topbar']
    local BackButton = Topbar['BackButton']

    -- // Animate Tab Children
    task.wait(0.25)
    for _, Instance in next, Tab:GetDescendants() do
        if not Instance:IsA('UICorner') and not Instance:IsA('UIPadding') then
            local HasBackgroundTransparency = UtilityFunctions:HasProperty(Instance, 'BackgroundTransparency')
            local HasTextTransparency = UtilityFunctions:HasProperty(Instance, 'TextTransparency')
            local HasImageTransparency = UtilityFunctions:HasProperty(Instance, 'ImageTransparency')
            local HasThickness = UtilityFunctions:HasProperty(Instance, 'Thickness')

            if HasBackgroundTransparency then
                UIFunctions:Tween(Instance, {BackgroundTransparency = 0}, 0.25)
            end
            
            if HasTextTransparency then
                UIFunctions:Tween(Instance, {TextTransparency = 0}, 0.25)
            end

            if HasImageTransparency then
                UIFunctions:Tween(Instance, {ImageTransparency = 0}, 0.25)
            end

            if HasThickness then
                Instance.Thickness = 1
            end
        end
    end

    -- // Animate Back Button
    BackButton.MouseEnter:Connect(function()
        UIFunctions:Tween(BackButton, {ImageColor3 = Color3.fromRGB(200, 200, 200)}, 0.25)
    end)
    
    BackButton.MouseLeave:Connect(function()
        UIFunctions:Tween(BackButton, {ImageColor3 = Color3.fromRGB(175, 175, 175)}, 0.25)
    end)

    BackButton.MouseButton1Click:Connect(function()
        UIFunctions:Tween(BackButton, {ImageColor3 = Color3.fromRGB(200, 200, 200)}, 0.25)

        task.wait(0.25)

        for _, Instance in next, Tab:GetDescendants() do
            if not Instance:IsA('UICorner') and not Instance:IsA('UIPadding') then
                local HasBackgroundTransparency = UtilityFunctions:HasProperty(Instance, 'BackgroundTransparency')
                local HasTextTransparency = UtilityFunctions:HasProperty(Instance, 'TextTransparency')
                local HasImageTransparency = UtilityFunctions:HasProperty(Instance, 'ImageTransparency')
                local HasThickness = UtilityFunctions:HasProperty(Instance, 'Thickness')

                if HasBackgroundTransparency then
                    UIFunctions:Tween(Instance, {BackgroundTransparency = 1}, 0.25)
                end
                
                if HasTextTransparency then
                    UIFunctions:Tween(Instance, {TextTransparency = 1}, 0.25)
                end

                if HasImageTransparency then
                    UIFunctions:Tween(Instance, {ImageTransparency = 1}, 0.25)
                end

                if HasThickness then
                    Instance.Thickness = 0
                end
            end
        end

        task.wait(0.25)

        UIFunctions:Tween(Tab, {Size = UDim2.new(0, 0, 0, 375)}, 0.25)

        task.wait(0.25)

        Tab.Visible = false

        UIFunctions:Tween(BackButton, {ImageColor3 = Color3.fromRGB(175, 175, 175)}, 0.25)

        Visual.ClickThrough = true
    end)
end)

-- // Code Box
local GeneratedScriptHolder = RemoteSpy['GeneratedScriptHolder']
local LineAmount = GeneratedScriptHolder['LineAmount']
local LineText = LineAmount['LineText']

LineAmount.Size = UDim2.new(0, 35, 0, GeneratedScriptHolder.AbsoluteCanvasSize.Y)

GeneratedScriptHolder.Changed:Connect(function(Property)
    if Property == 'Size' then
        LineAmount.Size = UDim2.new(0, 35, 0, GeneratedScriptHolder.AbsoluteCanvasSize.Y)
    end
end)

-- // HTTP Spy

-- // Loaded UI
local Loaded = false
local Elements = {}

for _, Instance in next, Base:GetDescendants() do
    if not Instance:IsA('UICorner') and not Instance:IsA('UIPadding') and not Instance:IsA('UIStroke') then
        table.insert(Elements, Instance)
    end
end

repeat task.wait()
    local LoadedElements = {}

    for _, Instance in next, Base:GetDescendants() do
        if not Instance:IsA('UICorner') and not Instance:IsA('UIPadding') and not Instance:IsA('UIStroke') then
            if Instance then
                table.insert(LoadedElements, Instance)
            end
        end
    end 

    if #Elements == #LoadedElements then
        Loaded = true
    end
until Loaded == true

UtilityFunctions:Log('Log', 'Finished Loading UI')