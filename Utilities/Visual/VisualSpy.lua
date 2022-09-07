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
    Name = 'VisualSpy'
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
    
                UIFunctions:Tween(UI.Base, {Size = UDim2.new(0, 0, 0, 0)}, 0.25)
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
            Base.Visible = false
        else
            local Base = CoreGui:FindFirstChild('VisualSpy').Base
            local OpenButton = CoreGui:FindFirstChild('VisualSpy').OpenButton
            UIFunctions:Tween(OpenButton, {BackgroundTransparency = 1}, 0.25)
            UIFunctions:Tween(OpenButton, {ImageTransparency = 1}, 0.25)
            OpenButton.OpenButtonBaseStroke.Thickness = 0
            Base.Visible = true
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
            end)

        elseif Type == 'OneButton' then
            local Args = ...
            local ButtonText = Args[1]
            local ButtonCallback = Args[2]
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
            end)
            
        elseif Type == 'TwoButton' then
            local Args = ...
            local Button1Text = Args[1]
            local Button1Callback = Args[2]
            local Button2Text = Args[3]
            local Button2Callback = Args[4]
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

-- // Animated Loading (#1)
UIFunctions:Tween(Container['Base'], {Size = UDim2.new(0, 650, 0, 375)}, 0.25)
task.wait(0.25)

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
    UIFunctions:Tween(CloseButton, {TextColor3 = Color3.fromRGB(125, 125, 125)}, 0.25)
    task.wait(0.25)
    UIFunctions:Tween(CloseButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.25)
    UIFunctions:Destroy()
end)

MinimiseButton.MouseEnter:Connect(function()
    UIFunctions:Tween(MinimiseButton, {TextColor3 = Color3.fromRGB(125, 125, 125)}, 0.25)
end)

MinimiseButton.MouseLeave:Connect(function()
    UIFunctions:Tween(MinimiseButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.25)
end)

MinimiseButton.MouseButton1Click:Connect(function()
    UIFunctions:Tween(MinimiseButton, {TextColor3 = Color3.fromRGB(125, 125, 125)}, 0.25)
    task.wait(0.25)
    UIFunctions:Tween(MinimiseButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.25)
    UIFunctions:Toggle()
end)

-- // Minimised Button
OpenButton.MouseEnter:Connect(function()
    UIFunctions:Tween(OpenButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.25)
end)

OpenButton.MouseLeave:Connect(function()
    UIFunctions:Tween(OpenButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.25)
end)

OpenButton.MouseButton1Click:Connect(function()
    UIFunctions:Tween(OpenButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.25)
    task.wait(0.25)
    UIFunctions:Tween(OpenButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.25)
    UIFunctions:Toggle()
end)

-- // Tab Functions
local DebounceAmount = 0.25
local Debounce = false
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
        local HasMethods = UtilityFunctions:HasMethods(Name)
        if HasMethods then
            if not Debounce then
                task.spawn(function()
                    Debounce = true
                    task.wait(DebounceAmount)
                    Debounce = false
                end)

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
            end
        else
            UIFunctions:CreatePrompt('Text', 'Warning', 'Your exploit is not supported.', 'Alright')
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
    Active = true,
    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 0, 0),
    ScrollBarImageColor3 = Color3.fromRGB(75, 75, 75),
    Size = UDim2.new(0, 268, 0, 348),
    ScrollBarThickness = 1
})

UIFunctions:Create('Frame', {
    Name = 'SettingsList',
    Parent = RemoteSpy,
    Position = UDim2.new(0, 434, 0, 0),
    Size = UDim2.new(0, 50, 0, 348),
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(32, 32, 32),
    ZIndex = 2
}, {
    UIFunctions:Create('UICorner', {
        Name = 'SettingsListCorner',
        CornerRadius = UDim.new(0, 5)
    }),
    UIFunctions:Create('UIStroke', {
        Name = 'SettingsListStroke',
        Color = Color3.fromRGB(75, 75, 75),
        Thickness = 1
    }),
    UIFunctions:Create('Frame', {
        Name = 'SettingsListFiller1',
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 5, 0, 5),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }),
    UIFunctions:Create('Frame', {
        Name = 'SettingsListFiller2',
        Position = UDim2.new(0, 0, 0, 343),
        Size = UDim2.new(0, 5, 0, 5),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }),
    UIFunctions:Create('Frame', {
        Name = 'SettingsListFiller3',
        Position = UDim2.new(0, 45, 0, 0),
        Size = UDim2.new(0, 5, 0, 5),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }),
    UIFunctions:Create('Frame', {
        Name = 'SettingsListLine1',
        Position = UDim2.new(0, -1, 0, 0),
        Size = UDim2.new(0, 1, 0, 10),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundColor3 = Color3.fromRGB(75, 75, 75)
    }),
    UIFunctions:Create('Frame', {
        Name = 'SettingsListLine2',
        Position = UDim2.new(0, -1, 0, 338),
        Size = UDim2.new(0, 1, 0, 10),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundColor3 = Color3.fromRGB(75, 75, 75)
    }),
})

local RemoteList = RemoteSpy['RemoteList']
local RemoteListLayout = RemoteList['RemoteListLayout']

RemoteList.ChildAdded:Connect(function()
    local CanvasSize = RemoteListLayout.AbsoluteContentSize

    RemoteList.CanvasSize = UDim2.new(0, CanvasSize.X, 0, CanvasSize.Y)
end)

local CanvasSize = RemoteListLayout.AbsoluteContentSize

RemoteList.CanvasSize = UDim2.new(0, CanvasSize.X, 0, CanvasSize.Y)



-- // HTTP Spy



UtilityFunctions:Log('Log', 'Finished Loading UI')