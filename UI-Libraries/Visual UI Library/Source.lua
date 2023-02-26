-- // Services
local CoreGui = game:GetService('CoreGui')
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local TextService = game:GetService('TextService')
local Players = game:GetService('Players')
local HttpService = game:GetService('HttpService')

-- // Variables
getgenv().kms = false
local Ihatethisui = {}
local UIName = 'Visual UI Library | .gg/puxxCphTnK'
local Amount = 0
local ConfigF
local BreakAllLoops = false
local ChangeTheme = false
local NotificationTransparency = 0
local Utility = {}
local Library = {}
local Config = {}
local ConfigUpdates = {}
local Themes = {
    ['Default'] = {
        BackgroundColor = Color3.fromRGB(25, 25, 25),
        SidebarColor = Color3.fromRGB(30, 30, 30),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(135, 135, 135),
        UIStrokeColor = Color3.fromRGB(60, 60, 60),
        PrimaryElementColor = Color3.fromRGB(30, 30, 30),
        SecondaryElementColor = Color3.fromRGB(50, 50, 50),
        OtherElementColor = Color3.fromRGB(25, 25, 25),
        ScrollBarColor = Color3.fromRGB(125, 125, 125),
        PromptColor = Color3.fromRGB(40, 40, 40),
        NotificationColor = Color3.fromRGB(25, 25, 25),
        NotificationUIStrokeColor = Color3.fromRGB(125, 125, 125)
    },
    ['Lighter'] = {
        BackgroundColor = Color3.fromRGB(40, 40, 40),
        SidebarColor = Color3.fromRGB(45, 45, 45),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(135, 135, 135),
        UIStrokeColor = Color3.fromRGB(80, 80, 80),
        PrimaryElementColor = Color3.fromRGB(45, 45, 45),
        SecondaryElementColor = Color3.fromRGB(65, 65, 65),
        OtherElementColor = Color3.fromRGB(40, 40, 40),
        ScrollBarColor = Color3.fromRGB(125, 125, 125),
        PromptColor = Color3.fromRGB(60, 60, 60),
        NotificationColor = Color3.fromRGB(40, 40, 40),
        NotificationUIStrokeColor = Color3.fromRGB(125, 125, 125)
    },
    ['Light'] = {
        BackgroundColor = Color3.fromRGB(255, 255, 255),
        SidebarColor = Color3.fromRGB(200, 200, 200),
        PrimaryTextColor = Color3.fromRGB(0, 0, 0),
        SecondaryTextColor = Color3.fromRGB(75, 75, 75),
        UIStrokeColor = Color3.fromRGB(0, 0, 0),
        PrimaryElementColor = Color3.fromRGB(200, 200, 200),
        SecondaryElementColor = Color3.fromRGB(150, 150, 150),
        OtherElementColor = Color3.fromRGB(255, 255, 255),
        ScrollBarColor = Color3.fromRGB(125, 125, 125),
        PromptColor = Color3.fromRGB(200, 200, 200),
        NotificationColor = Color3.fromRGB(255, 255, 255),
        NotificationUIStrokeColor = Color3.fromRGB(0, 0, 0)
    },
    ['Light+'] = {
        BackgroundColor = Color3.fromRGB(255, 255, 255),
        SidebarColor = Color3.fromRGB(255, 255, 255),
        PrimaryTextColor = Color3.fromRGB(0, 0, 0),
        SecondaryTextColor = Color3.fromRGB(75, 75, 75),
        UIStrokeColor = Color3.fromRGB(0, 0, 0),
        PrimaryElementColor = Color3.fromRGB(255, 255, 255),
        SecondaryElementColor = Color3.fromRGB(200, 200, 200),
        OtherElementColor = Color3.fromRGB(255, 255, 255),
        ScrollBarColor = Color3.fromRGB(125, 125, 125),
        PromptColor = Color3.fromRGB(255, 255, 255),
        NotificationColor = Color3.fromRGB(255, 255, 255),
        NotificationUIStrokeColor = Color3.fromRGB(0, 0, 0)
    },
    ['Discord'] = {
        BackgroundColor = Color3.fromRGB(54, 57, 63),
        SidebarColor = Color3.fromRGB(44, 49, 54),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(110, 110, 115),
        UIStrokeColor = Color3.fromRGB(75, 75, 75),
        PrimaryElementColor = Color3.fromRGB(48, 52, 57),
        SecondaryElementColor = Color3.fromRGB(59, 65, 72),
        OtherElementColor = Color3.fromRGB(54, 57, 63),
        ScrollBarColor = Color3.fromRGB(125, 125, 125),
        PromptColor = Color3.fromRGB(74, 77, 83),
        NotificationColor = Color3.fromRGB(54, 57, 63),
        NotificationUIStrokeColor = Color3.fromRGB(75, 75, 75)
    },
    ['Red And Black'] = {
        BackgroundColor = Color3.fromRGB(0, 0, 0),
        SidebarColor = Color3.fromRGB(0, 0, 0),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(135, 135, 135),
        UIStrokeColor = Color3.fromRGB(255, 0, 0),
        PrimaryElementColor = Color3.fromRGB(34, 31, 31),
        SecondaryElementColor = Color3.fromRGB(50, 50, 50),
        OtherElementColor = Color3.fromRGB(25, 25, 25),
        ScrollBarColor = Color3.fromRGB(255, 0, 0),
        PromptColor = Color3.fromRGB(40, 40, 40),
        NotificationColor = Color3.fromRGB(255, 0, 0),
        NotificationUIStrokeColor = Color3.fromRGB(255, 0, 0)
    },
    ['Nordic Dark'] = {
        BackgroundColor = Color3.fromRGB(25, 30, 35),
        SidebarColor = Color3.fromRGB(20, 25, 30),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(135, 135, 135),
        UIStrokeColor = Color3.fromRGB(50, 60, 70),
        PrimaryElementColor = Color3.fromRGB(30, 35, 40),
        SecondaryElementColor = Color3.fromRGB(50, 55, 60),
        OtherElementColor = Color3.fromRGB(25, 30, 35),
        ScrollBarColor = Color3.fromRGB(100, 105, 110),
        PromptColor = Color3.fromRGB(45, 50, 55),
        NotificationColor = Color3.fromRGB(25, 30, 35),
        NotificationUIStrokeColor = Color3.fromRGB(50, 60, 70)
    },
    ['Nordic Light'] = {
        BackgroundColor = Color3.fromRGB(67, 75, 94),
        SidebarColor = Color3.fromRGB(62, 67, 86),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(135, 135, 135),
        UIStrokeColor = Color3.fromRGB(92, 97, 116),
        PrimaryElementColor = Color3.fromRGB(62, 67, 86),
        SecondaryElementColor = Color3.fromRGB(82, 87, 106),
        OtherElementColor = Color3.fromRGB(67, 75, 94),
        ScrollBarColor = Color3.fromRGB(100, 105, 110),
        PromptColor = Color3.fromRGB(62, 67, 86),
        NotificationColor = Color3.fromRGB(67, 75, 94),
        NotificationUIStrokeColor = Color3.fromRGB(67, 75, 94)
    },
    ['Purple'] = {
        BackgroundColor = Color3.fromRGB(30, 30, 45),
        SidebarColor = Color3.fromRGB(40, 40, 60),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(135, 135, 135),
        UIStrokeColor = Color3.fromRGB(60, 60, 80),
        PrimaryElementColor = Color3.fromRGB(40, 40, 60),
        SecondaryElementColor = Color3.fromRGB(60, 60, 80),
        OtherElementColor = Color3.fromRGB(30, 30, 45),
        ScrollBarColor = Color3.fromRGB(100, 105, 110),
        PromptColor = Color3.fromRGB(50, 50, 65),
        NotificationColor = Color3.fromRGB(30, 30, 45),
        NotificationUIStrokeColor = Color3.fromRGB(60, 60, 80)
    },
    ['Sentinel'] = {
        BackgroundColor = Color3.fromRGB(30, 30, 30),
        SidebarColor = Color3.fromRGB(25, 25, 25),
        PrimaryTextColor = Color3.fromRGB(130, 190, 130),
        SecondaryTextColor = Color3.fromRGB(230, 35, 70),
        UIStrokeColor = Color3.fromRGB(50, 50, 50),
        PrimaryElementColor = Color3.fromRGB(25, 25, 25),
        SecondaryElementColor = Color3.fromRGB(35, 35, 35),
        OtherElementColor = Color3.fromRGB(30, 30, 30),
        ScrollBarColor = Color3.fromRGB(70, 70, 70),
        PromptColor = Color3.fromRGB(50, 50, 50),
        NotificationColor = Color3.fromRGB(30, 30, 30),
        NotificationUIStrokeColor = Color3.fromRGB(50, 50, 50)
    },
    ['Synapse X'] = {
        BackgroundColor = Color3.fromRGB(50, 50, 50),
        SidebarColor = Color3.fromRGB(50, 50, 50),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(125, 125, 125),
        UIStrokeColor = Color3.fromRGB(70, 70, 70),
        PrimaryElementColor = Color3.fromRGB(60, 60, 60),
        SecondaryElementColor = Color3.fromRGB(80, 80, 80),
        OtherElementColor = Color3.fromRGB(50, 50, 50),
        ScrollBarColor = Color3.fromRGB(70, 70, 70),
        PromptColor = Color3.fromRGB(70, 70, 70),
        NotificationColor = Color3.fromRGB(50, 50, 50),
        NotificationUIStrokeColor = Color3.fromRGB(70, 70, 70)
    },
    ['Krnl'] = {
        BackgroundColor = Color3.fromRGB(40, 40, 40),
        SidebarColor = Color3.fromRGB(30, 30, 30),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(125, 125, 125),
        UIStrokeColor = Color3.fromRGB(60, 60, 60),
        PrimaryElementColor = Color3.fromRGB(30, 30, 30),
        SecondaryElementColor = Color3.fromRGB(40, 40, 40),
        OtherElementColor = Color3.fromRGB(40, 40, 40),
        ScrollBarColor = Color3.fromRGB(60, 60, 60),
        PromptColor = Color3.fromRGB(60, 60, 60),
        NotificationColor = Color3.fromRGB(40, 40, 40),
        NotificationUIStrokeColor = Color3.fromRGB(60, 60, 60)
    },
    ['Script-Ware'] = {
        BackgroundColor = Color3.fromRGB(30, 30, 30),
        SidebarColor = Color3.fromRGB(35, 35, 35),
        PrimaryTextColor = Color3.fromRGB(0, 125, 255),
        SecondaryTextColor = Color3.fromRGB(255, 255, 255),
        UIStrokeColor = Color3.fromRGB(50, 50, 50),
        PrimaryElementColor = Color3.fromRGB(35, 35, 35),
        SecondaryElementColor = Color3.fromRGB(45, 45, 45),
        OtherElementColor = Color3.fromRGB(30, 30, 30),
        ScrollBarColor = Color3.fromRGB(50, 50, 50),
        PromptColor = Color3.fromRGB(50, 50, 50),
        NotificationColor = Color3.fromRGB(30, 30, 30),
        NotificationUIStrokeColor = Color3.fromRGB(50, 50, 50)
    },
    ['Kiriot'] = {
        BackgroundColor = Color3.fromRGB(35, 35, 35),
        SidebarColor = Color3.fromRGB(30, 30, 30),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(135, 135, 135),
        UIStrokeColor = Color3.fromRGB(255, 170, 60),
        PrimaryElementColor = Color3.fromRGB(30, 30, 30),
        SecondaryElementColor = Color3.fromRGB(50, 50, 50),
        OtherElementColor = Color3.fromRGB(25, 25, 25),
        ScrollBarColor = Color3.fromRGB(125, 125, 125),
        PromptColor = Color3.fromRGB(40, 40, 40),
        NotificationColor = Color3.fromRGB(25, 25, 25),
        NotificationUIStrokeColor = Color3.fromRGB(255, 170, 60)
    }
}

-- // Utility Functions
do
    function Utility:Tween(Instance, Properties, Duration, ...)
        local TweenInfo = TweenInfo.new(Duration, ...)
        TweenService:Create(Instance, TweenInfo, Properties):Play()
    end

    function Utility:DestroyUI()
        ChangeTheme = true
        BreakAllLoops = true
        writefile('fml.txt', 'true')
        for Index, Value in next, Ihatethisui do
            print(Index, Value)
            Ihatethisui[Index]:Break()
        end
        if CoreGui:FindFirstChild(UIName) ~= nil then
            CoreGui:FindFirstChild(UIName):Destroy()
        end
    end

    function Utility:Darken(Color)
        local H, S, V = Color:ToHSV()

        V = math.clamp(V - 0.03, 0, 1)

        return Color3.fromHSV(H, S, V)
    end

    function Utility:Lighten(Color)
        local H, S, V = Color:ToHSV()

        V = math.clamp(V + 0.03, 0, 1)

        return Color3.fromHSV(H, S, V)
    end

    function Utility:SplitColor(Color)
        local R, G, B = math.floor(Color.R * 255), math.floor(Color.G * 255), math.floor(Color.B * 255)
        return {R, G, B}
    end

    function Utility:JoinColor(Table)
        local R, G, B = Table[1], Table[2], Table[3]
        return Color3.fromRGB(R, G, B)
    end

    function Utility:ToggleUI()
        if CoreGui:FindFirstChild(UIName) ~= nil then
            CoreGui:FindFirstChild(UIName).Enabled = not CoreGui:FindFirstChild(UIName).Enabled
        end
    end

    function Utility:EnableDragging(Frame)
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

    function Utility:Create(_Instance, Properties, Children)
        local Object = Instance.new(_Instance)
        local Properties = Properties or {}
        local Children = Children or {}
        
        for Index, Property in next, Properties do
            Object[Index] = Property
        end

        for _, Child in next, Children do
            Child.Parent = Object
        end

        return Object
    end

    function Library:CreateNotification(Title, Text, Duration)
        local Theme = {}
        local File = readfile('VisualUILibraryCurrentTheme.json')
        local Table = HttpService:JSONDecode(File)
        for Index, Value in next, Table do
            Theme[Index] = Utility:JoinColor(Value)
        end

        task.spawn(function()
            local Title = Title or 'Title'
            local Text = Text or 'Text'
            local Duration = Duration or 5

            if not CoreGui:FindFirstChild('Visual UI Library | .gg/puxxCphTnK | Notifications') then
                Utility:Create('ScreenGui', {
                    Name = 'Visual UI Library | .gg/puxxCphTnK | Notifications',
                    Parent = CoreGui
                })
            else
                Utility:Create('Frame', {
                    Parent = CoreGui:FindFirstChild('Visual UI Library | .gg/puxxCphTnK | Notifications'),
                    Name = 'Notification'..tostring(Amount + 1),
                    BackgroundColor3 = Theme.BackgroundColor,
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, 300, 1, -30),
                    Size = UDim2.new(0, 300, 0, 50),
                    BackgroundTransparency = NotificationTransparency,
                    AnchorPoint = Vector2.new(1, 1)
                }, {
                    Utility:Create('UICorner', {
                        CornerRadius = UDim.new(0, 5),
                        Name = 'NotificationCorner'
                    }),
                    Utility:Create('UIStroke', {
                        Name = 'NotificationStroke',
                        ApplyStrokeMode = 'Contextual',
                        Color = Theme.NotificationUIStrokeColor,
                        LineJoinMode = 'Round',
                        Thickness = 1
                    }),
                    Utility:Create('TextLabel', {
                        Name = 'NotificationTitle',
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, -1),
                        Size = UDim2.new(0, 300, 0, 30),
                        Font = Enum.Font.Gotham,
                        Text = Title,
                        TextColor3 = Theme.PrimaryTextColor,
                        TextSize = 16,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }, {
                        Utility:Create('UIPadding', {
                            Name = 'NotificationTitlePadding',
                            PaddingLeft = UDim.new(0, 7)
                        })
                    }),
                    Utility:Create('TextLabel', {
                        Name = 'NotificationText',
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, 25),
                        Size = UDim2.new(0, 300, 0, 30),
                        Font = Enum.Font.Gotham,
                        Text = Text,
                        TextWrapped = true,
                        TextColor3 = Theme.SecondaryTextColor,
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }, {
                        Utility:Create('UIPadding', {
                            Name = 'NotificationTextPadding',
                            PaddingLeft = UDim.new(0, 7)
                        })
                    })
                })

                Amount = Amount + 1
                local Holder = CoreGui:FindFirstChild('Visual UI Library | .gg/puxxCphTnK | Notifications')['Notification'..tostring(Amount)]
                local TitleObj = Holder['NotificationTitle']
                local TextObj = Holder['NotificationText']
                local TextSize = TextService:GetTextSize(Text, 14, Enum.Font.Gotham, Vector2.new(300, math.huge))
                Holder.Size = UDim2.new(0, 300, 0, TextSize.Y + 30)
                TextObj.Size = UDim2.new(0, 300, 0, TextSize.Y)
                if Amount > 1 then
                    local PreviousSizes = 0
                    for _, Notification in next, Holder.Parent:GetChildren() do
                        if Notification ~= Holder.Parent['Notification'..tostring(Amount)] then
                            local AbsoluteY = Notification.AbsoluteSize.Y + 5
                            PreviousSizes = PreviousSizes + AbsoluteY
                        end
                    end
                    Holder.Position = UDim2.new(1, 300, 1, -30 - PreviousSizes)
                    Utility:Tween(Holder, {Position = UDim2.new(1, -30, 1, -30 - PreviousSizes)}, 0.5)
                else
                    Utility:Tween(Holder, {Position = UDim2.new(1, -30, 1, -30)}, 0.5)
                end
                task.wait(Duration - 1)
                Utility:Tween(Holder, {BackgroundTransparency = 0.8}, 0.25)
                Utility:Tween(TitleObj, {TextTransparency = 0.5}, 0.25)
                Utility:Tween(TextObj, {TextTransparency = 0.5}, 0.25)
                task.wait(0.5)
                Utility:Tween(Holder, {Position = UDim2.new(1, 300, 1, Holder.Position.Y.Offset)}, 0.5)
                task.wait(0.5)
                Holder:Destroy()
                Amount = Amount - 1
            end
        end)
    end

    function Library:CreatePrompt(Type, Title, Text, ...)
        local Title = Title or 'Title'
        local Text = Text or 'Text'

        for _, Item in next, CoreGui:WaitForChild(UIName):WaitForChild('Main'):WaitForChild('PromptHolder'):GetChildren() do
            if Item:IsA('Frame') then
                Item:Destroy()
            end
        end

        local Theme = {}
        local File = readfile('VisualUILibraryCurrentTheme.json')
        local Table = HttpService:JSONDecode(File)
        for Index, Value in next, Table do
            Theme[Index] = Utility:JoinColor(Value)
        end

        if Type == 'Text' then
            local ButtonText = ...
            Utility:Create('Frame', {
                Name = Title..'PromptFrame',
                Parent = CoreGui:WaitForChild(UIName):WaitForChild('Main'):WaitForChild('PromptHolder'),
                BackgroundColor3 = Theme.PromptColor,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BorderSizePixel = 0,
                ZIndex = 101,
                BackgroundTransparency = NotificationTransparency,
                Size = UDim2.new(0, 0, 0, 0)
            }, {
                Utility:Create('UICorner', {
                    Name = Title..'PromptFrameCorner',
                    CornerRadius = UDim.new(0, 100)
                }),
                Utility:Create('UIStroke', {
                    Name = Title..'PromptFrameStroke',
                    ApplyStrokeMode = 'Contextual',
                    Color = Theme.UIStrokeColor,
                    LineJoinMode = 'Round',
                    Thickness = 1
                }),
                Utility:Create('TextLabel', {
                    Name = Title..'PromptTitle',
                    TextTransparency = 1,
                    BackgroundTransparency = 1,
                    TextWrapped = true,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 5),
                    Size = UDim2.new(0, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = Title,
                    TextColor3 = Theme.PrimaryTextColor,
                    TextSize = 20,
                    ZIndex = 102,
                    TextXAlignment = Enum.TextXAlignment.Center
                }),
                Utility:Create('TextLabel', {
                    Name = Title..'PromptText',
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                    TextWrapped = true,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 26),
                    Size = UDim2.new(0, 280, 0, 77),
                    Font = Enum.Font.Gotham,
                    Text = Text,
                    TextColor3 = Theme.SecondaryTextColor,
                    TextSize = 15,
                    ZIndex = 102,
                    TextXAlignment = Enum.TextXAlignment.Center
                }),
                Utility:Create('TextButton', {
                    Name = Title..'Button',
                    BackgroundColor3 = Theme.SecondaryElementColor,
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                    Text = ButtonText,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.SecondaryTextColor,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Position = UDim2.new(0, 10, 0, 110),
                    Size = UDim2.new(0, 280, 0, 30),
                    BorderSizePixel = 0,
                    TextSize = 15,
                    ZIndex = 103,
                    Visible = true,
                    AutoButtonColor = false
                }, {
                    Utility:Create('UIStroke', {
                        Name = Title..'ButtonStroke',
                        ApplyStrokeMode = 'Border',
                        Color = Theme.UIStrokeColor,
                        LineJoinMode = 'Round',
                        Thickness = 0
                    }),
                    Utility:Create('UICorner', {
                        Name = Title..'ButtonCorner',
                        CornerRadius = UDim.new(0, 5)
                    })
                })
            })

            local PromptHolder = CoreGui:WaitForChild(UIName):WaitForChild('Main'):WaitForChild('PromptHolder')
            local PromptFrame = PromptHolder[Title..'PromptFrame']
            local PromptFrameCorner = PromptFrame[Title..'PromptFrameCorner']
            local Button = PromptFrame[Title..'Button']
            local ButtonStroke = Button[Title..'ButtonStroke']
            local PromptText = PromptFrame[Title..'PromptText']
            local PromptTitle = PromptFrame[Title..'PromptTitle']

            local TitleTextSize = TextService:GetTextSize(Title, 20, Enum.Font.Gotham, Vector2.new(280, 0))
            
            Utility:Tween(PromptTitle, {Size = UDim2.new(0, TitleTextSize.X, 0, TitleTextSize.Y)}, 0.25)

            Utility:Tween(PromptHolder, {BackgroundTransparency = 0.1}, 0.25)
            task.wait(0.25)
            Utility:Tween(PromptFrame, {BackgroundTransparency = NotificationTransparency}, 0.25)
            Utility:Tween(PromptFrame, {Size = UDim2.new(0, 300, 0, 150)}, 0.25)
            Utility:Tween(PromptFrameCorner, {CornerRadius = UDim.new(0, 5)}, 0.25)
            task.wait(0.25)
            Utility:Tween(ButtonStroke, {Thickness = 1}, 0.25)
            task.wait(0.25)
            Utility:Tween(PromptText, {TextTransparency = 0}, 0.25)
            Utility:Tween(PromptTitle, {TextTransparency = 0}, 0.25)
            Utility:Tween(Button, {BackgroundTransparency = 0}, 0.25)
            Utility:Tween(Button, {TextTransparency = 0}, 0.25)

            Button.MouseEnter:Connect(function(Input)
                Utility:Tween(Button, {TextColor3 = Utility:Lighten(Theme.PrimaryTextColor)}, 0.25)
            end)

            Button.MouseLeave:Connect(function(Input)
                Utility:Tween(Button, {TextColor3 = Theme.SecondaryTextColor}, 0.25)
            end)
            
            Button.MouseButton1Down:Connect(function()
                Utility:Tween(Button, {BackgroundTransparency = 1}, 0.25)
                Utility:Tween(Button, {TextTransparency = 1}, 0.25)
                Utility:Tween(PromptText, {TextTransparency = 1}, 0.25)
                Utility:Tween(PromptTitle, {TextTransparency = 1}, 0.25)
                task.wait(0.25)
                Utility:Tween(ButtonStroke, {Thickness = 0}, 0.25)
                task.wait(0.25)
                Utility:Tween(PromptFrame, {BackgroundTransparency = 1}, 0.25)
                Utility:Tween(PromptFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25)
                Utility:Tween(PromptFrameCorner, {CornerRadius = UDim.new(0, 100)}, 0.25)
                task.wait(0.25)
                Utility:Tween(PromptHolder, {BackgroundTransparency = 1}, 0.25)
                task.wait()
                PromptFrame:Destroy()
            end)

        elseif Type == 'OneButton' then
            local Args = ...
            local ButtonText = Args[1]
            local ButtonCallback = Args[2]
            Utility:Create('Frame', {
                Name = Title..'PromptFrame',
                Parent = CoreGui:WaitForChild(UIName):WaitForChild('Main'):WaitForChild('PromptHolder'),
                BackgroundColor3 = Theme.PromptColor,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BorderSizePixel = 0,
                ZIndex = 101,
                BackgroundTransparency = NotificationTransparency,
                Size = UDim2.new(0, 0, 0, 0)
            }, {
                Utility:Create('UICorner', {
                    Name = Title..'PromptFrameCorner',
                    CornerRadius = UDim.new(0, 100)
                }),
                Utility:Create('UIStroke', {
                    Name = Title..'PromptFrameStroke',
                    ApplyStrokeMode = 'Contextual',
                    Color = Theme.UIStrokeColor,
                    LineJoinMode = 'Round',
                    Thickness = 1
                }),
                Utility:Create('TextLabel', {
                    Name = Title..'PromptTitle',
                    TextTransparency = 1,
                    BackgroundTransparency = 1,
                    TextWrapped = true,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 5),
                    Size = UDim2.new(0, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = Title,
                    TextColor3 = Theme.PrimaryTextColor,
                    TextSize = 20,
                    ZIndex = 102,
                    TextXAlignment = Enum.TextXAlignment.Center
                }),
                Utility:Create('TextLabel', {
                    Name = Title..'PromptText',
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                    TextWrapped = true,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 26),
                    Size = UDim2.new(0, 280, 0, 77),
                    Font = Enum.Font.Gotham,
                    Text = Text,
                    TextColor3 = Theme.SecondaryTextColor,
                    TextSize = 15,
                    ZIndex = 102,
                    TextXAlignment = Enum.TextXAlignment.Center
                }),
                Utility:Create('TextButton', {
                    Name = Title..'Button',
                    BackgroundColor3 = Theme.SecondaryElementColor,
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                    Text = ButtonText,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.SecondaryTextColor,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Position = UDim2.new(0, 10, 0, 110),
                    Size = UDim2.new(0, 280, 0, 30),
                    BorderSizePixel = 0,
                    TextSize = 15,
                    ZIndex = 103,
                    Visible = true,
                    AutoButtonColor = false
                }, {
                    Utility:Create('UIStroke', {
                        Name = Title..'ButtonStroke',
                        ApplyStrokeMode = 'Border',
                        Color = Theme.UIStrokeColor,
                        LineJoinMode = 'Round',
                        Thickness = 0
                    }),
                    Utility:Create('UICorner', {
                        Name = Title..'ButtonCorner',
                        CornerRadius = UDim.new(0, 5)
                    })
                })
            })

            local PromptHolder = CoreGui:WaitForChild(UIName):WaitForChild('Main'):WaitForChild('PromptHolder')
            local PromptFrame = PromptHolder[Title..'PromptFrame']
            local PromptFrameCorner = PromptFrame[Title..'PromptFrameCorner']
            local Button = PromptFrame[Title..'Button']
            local ButtonStroke = Button[Title..'ButtonStroke']
            local PromptText = PromptFrame[Title..'PromptText']
            local PromptTitle = PromptFrame[Title..'PromptTitle']

            local TitleTextSize = TextService:GetTextSize(Title, 20, Enum.Font.Gotham, Vector2.new(280, 0))
            
            Utility:Tween(PromptTitle, {Size = UDim2.new(0, TitleTextSize.X, 0, TitleTextSize.Y)}, 0.25)

            Utility:Tween(PromptHolder, {BackgroundTransparency = 0.1}, 0.25)
            task.wait(0.25)
            Utility:Tween(PromptFrame, {BackgroundTransparency = NotificationTransparency0}, 0.25)
            Utility:Tween(PromptFrame, {Size = UDim2.new(0, 300, 0, 150)}, 0.25)
            Utility:Tween(PromptFrameCorner, {CornerRadius = UDim.new(0, 5)}, 0.25)
            task.wait(0.25)
            Utility:Tween(ButtonStroke, {Thickness = 1}, 0.25)
            task.wait(0.25)
            Utility:Tween(PromptText, {TextTransparency = 0}, 0.25)
            Utility:Tween(PromptTitle, {TextTransparency = 0}, 0.25)
            Utility:Tween(Button, {BackgroundTransparency = 0}, 0.25)
            Utility:Tween(Button, {TextTransparency = 0}, 0.25)

            Button.MouseEnter:Connect(function(Input)
                Utility:Tween(Button, {TextColor3 = Utility:Lighten(Theme.PrimaryTextColor)}, 0.25)
            end)

            Button.MouseLeave:Connect(function(Input)
                Utility:Tween(Button, {TextColor3 = Theme.SecondaryTextColor}, 0.25)
            end)
            
            Button.MouseButton1Down:Connect(function()
                pcall(ButtonCallback)
                Utility:Tween(Button, {BackgroundTransparency = 1}, 0.25)
                Utility:Tween(Button, {TextTransparency = 1}, 0.25)
                Utility:Tween(PromptText, {TextTransparency = 1}, 0.25)
                Utility:Tween(PromptTitle, {TextTransparency = 1}, 0.25)
                task.wait(0.25)
                Utility:Tween(ButtonStroke, {Thickness = 0}, 0.25)
                task.wait(0.25)
                Utility:Tween(PromptFrame, {BackgroundTransparency = 1}, 0.25)
                Utility:Tween(PromptFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25)
                Utility:Tween(PromptFrameCorner, {CornerRadius = UDim.new(0, 100)}, 0.25)
                task.wait(0.25)
                Utility:Tween(PromptHolder, {BackgroundTransparency = 1}, 0.25)
                task.wait()
                PromptFrame:Destroy()
            end)
            
        elseif Type == 'TwoButton' then
            local Args = ...
            local Button1Text = Args[1]
            local Button1Callback = Args[2]
            local Button2Text = Args[3]
            local Button2Callback = Args[4]
            Utility:Create('Frame', {
                Name = Title..'PromptFrame',
                Parent = CoreGui:WaitForChild(UIName):WaitForChild('Main'):WaitForChild('PromptHolder'),
                BackgroundColor3 = Theme.PromptColor,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BorderSizePixel = 0,
                ZIndex = 101,
                BackgroundTransparency = NotificationTransparency,
                Size = UDim2.new(0, 0, 0, 0)
            }, {
                Utility:Create('UICorner', {
                    Name = Title..'PromptFrameCorner',
                    CornerRadius = UDim.new(0, 100)
                }),
                Utility:Create('UIStroke', {
                    Name = Title..'PromptFrameStroke',
                    ApplyStrokeMode = 'Contextual',
                    Color = Theme.UIStrokeColor,
                    LineJoinMode = 'Round',
                    Thickness = 1
                }),
                Utility:Create('TextLabel', {
                    Name = Title..'PromptTitle',
                    TextTransparency = 1,
                    BackgroundTransparency = 1,
                    TextWrapped = true,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 5),
                    Size = UDim2.new(0, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = Title,
                    TextColor3 = Theme.PrimaryTextColor,
                    TextSize = 20,
                    ZIndex = 102,
                    TextXAlignment = Enum.TextXAlignment.Center
                }),
                Utility:Create('TextLabel', {
                    Name = Title..'PromptText',
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                    TextWrapped = true,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 26),
                    Size = UDim2.new(0, 280, 0, 77),
                    Font = Enum.Font.Gotham,
                    Text = Text,
                    TextColor3 = Theme.SecondaryTextColor,
                    TextSize = 15,
                    ZIndex = 102,
                    TextXAlignment = Enum.TextXAlignment.Center
                }),
                Utility:Create('TextButton', {
                    Name = Title..'Button1',
                    BackgroundColor3 = Theme.SecondaryElementColor,
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                    Text = Button1Text,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.SecondaryTextColor,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Position = UDim2.new(0, 10, 0, 110),
                    Size = UDim2.new(0, 135, 0, 30),
                    BorderSizePixel = 0,
                    TextSize = 15,
                    ZIndex = 103,
                    Visible = true,
                    AutoButtonColor = false
                }, {
                    Utility:Create('UIStroke', {
                        Name = Title..'Button1Stroke',
                        ApplyStrokeMode = 'Border',
                        Color = Theme.UIStrokeColor,
                        LineJoinMode = 'Round',
                        Thickness = 0
                    }),
                    Utility:Create('UICorner', {
                        Name = Title..'Button1Corner',
                        CornerRadius = UDim.new(0, 5)
                    })
                }),
                Utility:Create('TextButton', {
                    Name = Title..'Button2',
                    BackgroundColor3 = Theme.SecondaryElementColor,
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                    Text = Button2Text,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.SecondaryTextColor,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Position = UDim2.new(0, 155, 0, 110),
                    Size = UDim2.new(0, 135, 0, 30),
                    BorderSizePixel = 0,
                    TextSize = 15,
                    ZIndex = 103,
                    Visible = true,
                    AutoButtonColor = false
                }, {
                    Utility:Create('UIStroke', {
                        Name = Title..'Button2Stroke',
                        ApplyStrokeMode = 'Border',
                        Color = Theme.UIStrokeColor,
                        LineJoinMode = 'Round',
                        Thickness = 0
                    }),
                    Utility:Create('UICorner', {
                        Name = Title..'Button2Corner',
                        CornerRadius = UDim.new(0, 5)
                    })
                })
            })

            local PromptHolder = CoreGui:WaitForChild(UIName):WaitForChild('Main'):WaitForChild('PromptHolder')
            local PromptFrame = PromptHolder[Title..'PromptFrame']
            local PromptFrameCorner = PromptFrame[Title..'PromptFrameCorner']
            local Button1 = PromptFrame[Title..'Button1']
            local Button2 = PromptFrame[Title..'Button2']
            local Button1Stroke = Button1[Title..'Button1Stroke']
            local Button2Stroke = Button2[Title..'Button2Stroke']
            local PromptText = PromptFrame[Title..'PromptText']
            local PromptTitle = PromptFrame[Title..'PromptTitle']

            local TitleTextSize = TextService:GetTextSize(Title, 20, Enum.Font.Gotham, Vector2.new(280, 0))
            
            Utility:Tween(PromptTitle, {Size = UDim2.new(0, TitleTextSize.X, 0, TitleTextSize.Y)}, 0.25)

            Utility:Tween(PromptHolder, {BackgroundTransparency = 0.1}, 0.25)
            task.wait(0.25)
            Utility:Tween(PromptFrame, {BackgroundTransparency = NotificationTransparency}, 0.25)
            Utility:Tween(PromptFrame, {Size = UDim2.new(0, 300, 0, 150)}, 0.25)
            Utility:Tween(PromptFrameCorner, {CornerRadius = UDim.new(0, 5)}, 0.25)
            task.wait(0.25)
            Utility:Tween(Button1Stroke, {Thickness = 1}, 0.25)
            Utility:Tween(Button2Stroke, {Thickness = 1}, 0.25)
            task.wait(0.25)
            Utility:Tween(PromptText, {TextTransparency = 0}, 0.25)
            Utility:Tween(PromptTitle, {TextTransparency = 0}, 0.25)
            Utility:Tween(Button1, {BackgroundTransparency = 0}, 0.25)
            Utility:Tween(Button1, {TextTransparency = 0}, 0.25)
            Utility:Tween(Button2, {BackgroundTransparency = 0}, 0.25)
            Utility:Tween(Button2, {TextTransparency = 0}, 0.25)

            Button1.MouseEnter:Connect(function(Input)
                Utility:Tween(Button1, {TextColor3 = Utility:Lighten(Theme.PrimaryTextColor)}, 0.25)
            end)

            Button1.MouseLeave:Connect(function(Input)
                Utility:Tween(Button1, {TextColor3 = Theme.SecondaryTextColor}, 0.25)
            end)
            
            Button1.MouseButton1Down:Connect(function()
                pcall(Button1Callback)
                Utility:Tween(Button1, {BackgroundTransparency = 1}, 0.25)
                Utility:Tween(Button1, {TextTransparency = 1}, 0.25)
                Utility:Tween(Button2, {BackgroundTransparency = 1}, 0.25)
                Utility:Tween(Button2, {TextTransparency = 1}, 0.25)
                Utility:Tween(PromptText, {TextTransparency = 1}, 0.25)
                Utility:Tween(PromptTitle, {TextTransparency = 1}, 0.25)
                task.wait(0.25)
                Utility:Tween(Button1Stroke, {Thickness = 0}, 0.25)
                Utility:Tween(Button2Stroke, {Thickness = 0}, 0.25)
                task.wait(0.25)
                Utility:Tween(PromptFrame, {BackgroundTransparency = 1}, 0.25)
                Utility:Tween(PromptFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25)
                Utility:Tween(PromptFrameCorner, {CornerRadius = UDim.new(0, 100)}, 0.25)
                task.wait(0.25)
                Utility:Tween(PromptHolder, {BackgroundTransparency = 1}, 0.25)
                task.wait()
                PromptFrame:Destroy()
            end)

            Button2.MouseEnter:Connect(function(Input)
                Utility:Tween(Button2, {TextColor3 = Utility:Lighten(Theme.PrimaryTextColor)}, 0.25)
            end)

            Button2.MouseLeave:Connect(function(Input)
                Utility:Tween(Button2, {TextColor3 = Theme.SecondaryTextColor}, 0.25)
            end)
            
            Button2.MouseButton1Down:Connect(function()
                pcall(Button2Callback)
                Utility:Tween(Button1, {BackgroundTransparency = 1}, 0.25)
                Utility:Tween(Button1, {TextTransparency = 1}, 0.25)
                Utility:Tween(Button2, {BackgroundTransparency = 1}, 0.25)
                Utility:Tween(Button2, {TextTransparency = 1}, 0.25)
                Utility:Tween(PromptText, {TextTransparency = 1}, 0.25)
                Utility:Tween(PromptTitle, {TextTransparency = 1}, 0.25)
                task.wait(0.25)
                Utility:Tween(Button1Stroke, {Thickness = 0}, 0.25)
                Utility:Tween(Button2Stroke, {Thickness = 0}, 0.25)
                task.wait(0.25)
                Utility:Tween(PromptFrame, {BackgroundTransparency = 1}, 0.25)
                Utility:Tween(PromptFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25)
                Utility:Tween(PromptFrameCorner, {CornerRadius = UDim.new(0, 100)}, 0.25)
                task.wait(0.25)
                Utility:Tween(PromptHolder, {BackgroundTransparency = 1}, 0.25)
                task.wait()
                PromptFrame:Destroy()
            end)
        end
    end
end

do 
    Utility:DestroyUI()
    BreakAllLoops = false
    task.spawn(function()
        while task.wait(1) do
            local x = readfile('fml.txt')
            if x == 'true' then
                for Index, Value in next, Ihatethisui do
                    print(Index, Value)
                    Ihatethisui[Index]:Break()
                end
                writefile('fml.txt', 'false')
            end
        end
    end)
end

-- // Library Functions
function Library:DestroyUI()
    Utility:DestroyUI()
end

function Library:ToggleUI()
    Utility:ToggleUI()
end

function Library:SetTransparency(Transparency, NotificationBool)
    local UI = CoreGui:WaitForChild('Visual UI Library | .gg/puxxCphTnK')
    local Blacklist = {
        'UIPadding',
        'UICorner',
        'UIStroke',
        'UIListLayout',
        'Folder'
    }

    for _, Item in next, UI:GetDescendants() do
        if not table.find(Blacklist, Item.ClassName) then
            if Item.BackgroundTransparency ~= 1 and Transparency < 0.95 then
                Utility:Tween(Item, {BackgroundTransparency = Transparency}, 0.25)
            end
        end
    end

    if NotificationBool then
        NotificationTransparency = Transparency
    end
end

function Library:SaveConfig(Name)
    if Name ~= '' then
        if isfolder(ConfigF) then
            if isfile(ConfigF..'/'..Name..'.json') then
                Library:CreatePrompt('TwoButton', 'Overwrite Config', 'A config already exists with this name, are you sure you want to overwrite it?', {
                    'Yes',
                    function()
                        local Json = HttpService:JSONEncode(Config)
                        local File = writefile(ConfigF..'/'..Name..'.json', Json)
                        Library:CreateNotification('Saved Config', 'Successfully saved your config with the name, \''..Name..'.json'..'\'.', 5)
                    end,
                    'No',
                    function()
                        Library:CreateNotification('Config Not Saved', 'Config was not saved.', 5)
                    end
                })
            else
                local Json = HttpService:JSONEncode(Config)
                local File = writefile(ConfigF..'/'..Name..'.json', Json)
                Library:CreateNotification('Saved Config', 'Successfully saved your config with the name, \''..Name..'.json'..'\'.', 5)
            end
        else
            makefolder(ConfigF)
            if isfile(ConfigF..'/'..Name..'.json') then
                Library:CreatePrompt('TwoButton', 'Overwrite Config', 'A config already exists with this name, are you sure you want to overwrite it?', {
                    'Yes',
                    function()
                        local Json = HttpService:JSONEncode(Config)
                        local File = writefile(ConfigF..'/'..Name..'.json', Json)
                        Library:CreateNotification('Saved Config', 'Successfully saved your config with the name, \''..Name..'.json'..'\'.', 5)
                    end,
                    'No',
                    function()
                        Library:CreateNotification('Config Not Saved', 'Config was not saved.', 5)
                    end
                })
            else
                local Json = HttpService:JSONEncode(Config)
                local File = writefile(ConfigF..'/'..Name..'.json', Json)
                Library:CreateNotification('Saved Config', 'Successfully saved your config with the name, \''..Name..'.json'..'\'.', 5)
            end
        end
    else
        Library:CreateNotification('Config Not Saved', 'Please enter a name for the config.', 5)
    end
end

function Library:LoadConfig(Name)
    if isfile(ConfigF..'/'..Name..'.json') then
        Library:CreatePrompt('TwoButton', 'Load Config', 'Are you sure you want to load this config?', {
            'Yes',
            function()
                local Config = readfile(ConfigF..'/'..Name..'.json')
                local Table = HttpService:JSONDecode(Config)
                for Index, Value in next, Table do
                    if Index == 'Theme_4z3s4QrUhfqt703FmiAe' then
                        local DecodedTheme = HttpService:JSONDecode(Value)
                        local UpdatedTable = {}
                        for NewIndex, NewValue in next, DecodedTheme do
                            UpdatedTable[NewIndex] = Color3.fromRGB(NewValue[1], NewValue[2], NewValue[3])
                        end
                        Library:ChangeTheme(UpdatedTable)
                    elseif type(Value) == 'table' then
                        local New = Color3.fromRGB(Value[1] * 255, Value[2] * 255, Value[3] * 255)
                        ConfigUpdates[Index]:Set(New)
                    else
                        ConfigUpdates[Index]:Set(Value)
                    end
                end
                Library:CreateNotification('Config Loaded', 'Successfully loaded your config with the name, \''..Name..'.json'..'\'.', 5)
            end,
            'No',
            function()
                Library:CreateNotification('Config Not Loaded', 'Config was not loaded.', 5)
            end
        })
    else
        Library:CreateNotification('Config Not Loaded', 'Config doesn\'t exist.', 5)
    end
end

function Library:DeleteConfig(Name)
    if isfile(ConfigF..'/'..Name..'.json') then
        Library:CreatePrompt('TwoButton', 'Delete Config', 'Are you sure that you want to delete this config?', {
            'Yes',
            function()
                local Json = HttpService:JSONEncode(Config)
                local File = delfile(ConfigF..'/'..Name..'.json')
                Library:CreateNotification('Deleted Config', 'Successfully deleted config with the name, \''..Name..'.json'..'\'.', 5)
            end,
            'No',
            function()
                Library:CreateNotification('Config Not Deleted', 'Config was not deleted.', 5)
            end
        })
    end
end

function Library:GetConfigs()
    if isfolder(ConfigF) then
        local Configs = listfiles(ConfigF)
        local Table = {}
        for Index, Value in next, Configs do
            local New = Value:gsub(ConfigF..'\\', ''):gsub('.json', '')
            table.insert(Table, tostring(New))
        end
        return Table
    end
end 

function Library:CreateWindow(HubName, GameName, IntroText, IntroIcon, ImprovePerformance, ConfigFolder, Theme)
    local ImprovePerformance = ImprovePerformance or false
    local HasCustom = false
    local HubName = HubName or 'UI Name'
    local GameName = GameName or 'Game Name'
    local Theme = Theme
    if not Theme then
        Theme = Themes.Default
    elseif type(Theme) == 'table' then
        Theme = Theme
        Themes['Custom'] = Theme
        HasCustom = true
    elseif type(Theme) == 'string' then
        Theme = Theme:lower()
        if Theme == 'default' then
            Theme = Themes['Default']
        elseif Theme == 'lighter' then
            Theme = Themes['Lighter']
        elseif Theme == 'light' then
            Theme = Themes['Light']
        elseif Theme == 'light+' then
            Theme = Themes['Light+']
        elseif Theme == 'discord' then
            Theme = Themes['Discord']
        elseif Theme == 'red and black' then
            Theme = Themes['Red And Black']
        elseif Theme == 'nordic dark' then
            Theme = Themes['Nordic Dark']
        elseif Theme == 'nordic light' then
            Theme = Themes['Nordic Light']
        elseif Theme == 'purple' then
            Theme = Themes['Purple']
        elseif Theme == 'sentinel' then
            Theme = Themes['Sentinel']
        elseif Theme == 'synapse x' then
            Theme = Themes['Synapse X']
        elseif Theme == 'krnl' then
            Theme = Themes['Krnl']
        elseif Theme == 'script-ware' then
            Theme = Themes['Script-Ware']
        elseif Theme == 'kiriot' then
            Theme = Themes['Kiriot']
        end
    end
    local NewTable = {}

    for Index, Value in next, Theme do
        NewTable[Index] = Utility:SplitColor(Value)
    end

    if isfile('VisualUILibraryCurrentTheme.json') then
        delfile('VisualUILibraryCurrentTheme.json')
    end

    ConfigF = ConfigFolder

    writefile('VisualUILibraryCurrentTheme.json', HttpService:JSONEncode(NewTable))

    Config['Theme_4z3s4QrUhfqt703FmiAe'] = HttpService:JSONEncode(NewTable)

    local Container = Utility:Create('ScreenGui', {
        Name = UIName,
        Parent = CoreGui
    }, {
        Utility:Create('Frame', {
            Name = 'Main',
            BackgroundColor3 = Theme.BackgroundColor,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 595, 0, 150),
            Size = UDim2.new(0, 0, 0, 0)
        }, {
            Utility:Create('UICorner', {
                CornerRadius = UDim.new(0, 5),
                Name = 'MainCorner'
            }),
            Utility:Create('TextLabel', {
                Name = 'IntroText',
                BackgroundColor3 = Theme.BackgroundColor,
                BackgroundTransparency = 1,
                TextTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, -40),
                BorderSizePixel = 0,
                Size = UDim2.new(0, 170, 0, 20),
                Font = Enum.Font.Gotham,
                Text = IntroText,
                TextColor3 = Theme.PrimaryTextColor,
                TextSize = 18,
                ZIndex = 2,
                TextXAlignment = Enum.TextXAlignment.Center
            }),
            Utility:Create('ImageLabel', {
                Name = 'IntroImage',
                BackgroundColor3 = Theme.PrimaryElementColor,
                BackgroundTransparency = 1,
                ImageTransparency = 1,
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 20),
                ZIndex = 3,
                Size = UDim2.new(0, 100, 0, 100),
                Image = IntroIcon,
                ScaleType = Enum.ScaleType.Fit
            })
        }),
    })

    local Main = Container.Main
    
    Utility:EnableDragging(Container.Main)

    Utility:Tween(Main, {BackgroundTransparency = 0}, 0.25)
    Utility:Tween(Main, {Size = UDim2.new(0, 600, 0, 0)}, 0.25)
    task.wait(0.5)
    Utility:Tween(Main, {Size = UDim2.new(0, 600, 0, 375)}, 0.25)
    task.wait(0.5)
    Utility:Tween(Main['IntroText'], {TextTransparency = 0}, 0.25)
    task.wait(0.5)
    Utility:Tween(Main['IntroImage'], {ImageTransparency = 0}, 0.25)
    task.wait(3)
    Utility:Tween(Main['IntroText'], {TextTransparency = 1}, 0.25)
    task.wait(0.5)
    Utility:Tween(Main['IntroImage'], {ImageTransparency = 1}, 0.25)
    task.wait(0.5)
    Main['IntroText']:Destroy()
    Main['IntroImage']:Destroy()
    
    Utility:Create('Frame', {
        Name = 'PromptHolder',
        Parent = Main,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Parent = Main,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 600, 0, 375),
        ZIndex = 100,
        Visible = true,
        BackgroundTransparency = 1,
        BackgroundColor3 = Theme.BackgroundColor
    }, {
        Utility:Create('UICorner', {
            CornerRadius = UDim.new(0, 5),
            Parent = Main,
            Name = 'PromptHolderCorner'
        })
    })
    Utility:Create('Frame', {
        Name = 'Filler1',
        Position = UDim2.new(0, 170, 0, 0),
        Parent = Main,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 429, 0, 9),
        ZIndex = 1,
        BackgroundColor3 = Theme.BackgroundColor
    }, {
        Utility:Create('UICorner', {
            CornerRadius = UDim.new(0, 5),
            Name = 'Filler1Corner'
        })
    })
    Utility:Create('Frame', {
        Name = 'Filler2',
        Parent = Main,
        Position = UDim2.new(0, 170, 0, 364),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 429, 0, 11),
        ZIndex = 1,
        BackgroundColor3 = Theme.BackgroundColor
    }, {
        Utility:Create('UICorner', {
            CornerRadius = UDim.new(0, 5),
            Name = 'Filler2Corner'
        })
    })
    Utility:Create('Frame', {
        Name = 'Sidebar',
        BackgroundColor3 = Theme.SidebarColor,
        Parent = Main,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 170, 0, 375)
    }, {
        Utility:Create('UICorner', {
            CornerRadius = UDim.new(0, 5),
            Name = 'SidebarCorner'
        }),
        Utility:Create('Frame', {
            Name = 'NamesBehind',
            Position = UDim2.new(0, 0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 169, 0, 55),
            ZIndex = 1,
            BackgroundColor3 = Theme.SidebarColor
        }, {
            Utility:Create('UICorner', {
                CornerRadius = UDim.new(0, 5),
                Name = 'NamesBehindCorner'
            })
        }),
        Utility:Create('Frame', {
            Name = 'Filler3',
            Position = UDim2.new(0, 0, 0, 368),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 170, 0, 7),
            ZIndex = 1,
            BackgroundColor3 = Theme.SidebarColor
        }, {
            Utility:Create('UICorner', {
                CornerRadius = UDim.new(0, 5),
                Name = 'Filler3Corner'
            })
        }),
        Utility:Create('TextLabel', {
            Name = 'HubNameText',
            BackgroundColor3 = Theme.SidebarColor,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 6),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 170, 0, 20),
            Font = Enum.Font.Gotham,
            Text = HubName,
            TextColor3 = Theme.PrimaryTextColor,
            TextSize = 18,
            ZIndex = 2,
            TextXAlignment = Enum.TextXAlignment.Left
        }, {
            Utility:Create('UIPadding', {
                Name = 'HubNameTextPadding',
                PaddingLeft = UDim.new(0, 7)
            })
        }), 
        Utility:Create('TextLabel', {
            Name = 'GameNameText',
            BackgroundColor3 = Theme.SidebarColor,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 24),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 170, 0, 20),
            Font = Enum.Font.Gotham,
            Text = GameName,
            TextColor3 = Theme.SecondaryTextColor,
            TextSize = 16,
            ZIndex = 2,
            TextXAlignment = Enum.TextXAlignment.Left
        }, {
            Utility:Create('UIPadding', {
                Name = 'GameNameTextPadding',
                PaddingLeft = UDim.new(0, 7)
            })
        }),
        Utility:Create('Frame', {
            Name = 'SidebarLine1',
            BackgroundColor3 = Theme.UIStrokeColor,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 170, 0, 0),
            Size = UDim2.new(0, 1, 0, 375)
        }),
        Utility:Create('Frame', {
            Name = 'SidebarLine2',
            BackgroundColor3 = Theme.UIStrokeColor,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 48),
            Size = UDim2.new(0, 170, 0, 1)
        }),
        Utility:Create('ScrollingFrame', {
            Name = 'TabButtonHolder',
            Active = true,
            BackgroundColor3 = Theme.SidebarColor,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 55),
            Size = UDim2.new(0, 170, 0, 313),
            ScrollBarThickness = 0
        }, {
            Utility:Create('UIListLayout', {
                Name = 'TabButtonHolderListLayout',
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 3)
            })
        })
    })
    Utility:Create('Frame', {
        Name = 'TabContainer',
        BackgroundColor3 = Theme.BackgroundColor,
        Parent = Main,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 171, 0, 9),
        Size = UDim2.new(0, 429, 0, 355)
    }, {
        Utility:Create('Folder', {
            Name = 'TabsFolder'
        })
    })

    local HubNameObj = Container.Main.Sidebar.HubNameText
    local GameNameObj = Container.Main.Sidebar.GameNameText
    local TabButtonHolder = Container.Main.Sidebar.TabButtonHolder
    local TabButtonHolderListLayout = TabButtonHolder['TabButtonHolderListLayout']
    local PromptHolder = Container.Main.PromptHolder

    local HubNameTextSize = TextService:GetTextSize(HubNameObj.Text, 18, Enum.Font.Gotham, Vector2.new(410, math.huge))
    local GameNameTextSize = TextService:GetTextSize(GameNameObj.Text, 16, Enum.Font.Gotham, Vector2.new(410, math.huge))

    if HubNameTextSize.X >= 165 then
        local NewText = HubNameObj.Text
        local X = 0
        repeat 
            NewText = NewText:sub(0, -2)
            local HubNameTextSize = TextService:GetTextSize(NewText, 18, Enum.Font.Gotham, Vector2.new(410, math.huge))
            X = HubNameTextSize.X
        until X < 165
        for _ = 1, 2 do
            NewText = NewText:sub(0, -2)
        end
        HubNameObj.Text = NewText..'...'
    end

    if GameNameTextSize.X >= 175 then
        local NewText = GameNameObj.Text
        local X = 0
        repeat 
            NewText = NewText:sub(0, -2)
            local GameNameTextSize = TextService:GetTextSize(NewText, 18, Enum.Font.Gotham, Vector2.new(410, math.huge))
            X = GameNameTextSize.X
        until X < 175
        for _ = 1, 2 do
            NewText = NewText:sub(0, -2)
        end
        GameNameObj.Text = NewText..'...'
    end

    HubNameObj.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Library:CreatePrompt('Text', 'Hub Name', HubName, 'Close')
        end
    end)

    GameNameObj.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Library:CreatePrompt('Text', 'Game Name', GameName, 'Close')
        end
    end)

    function UpdateTabButtonHolderSize()
        local ContentSize = TabButtonHolderListLayout.AbsoluteContentSize.Y

        TabButtonHolder.CanvasSize = UDim2.new(0, 170, 0, ContentSize)
    end
    
    TabButtonHolder.ChildAdded:Connect(UpdateTabButtonHolderSize)

    if not ImprovePerformance then
        task.spawn(function()
            while task.wait() do
                if ChangeTheme then
                    if not BreakAllLoops then
                        Utility:Tween(Container.Main, {BackgroundColor3 = Theme.BackgroundColor}, 0.25)
                        Utility:Tween(Container.Main.PromptHolder, {BackgroundColor3 = Theme.BackgroundColor}, 0.25)
                        Utility:Tween(Container.Main.Filler1, {BackgroundColor3 = Theme.BackgroundColor}, 0.25)
                        Utility:Tween(Container.Main.Filler2, {BackgroundColor3 = Theme.BackgroundColor}, 0.25)
                        Utility:Tween(Container.Main.Sidebar, {BackgroundColor3 = Theme.SidebarColor}, 0.25)
                        Utility:Tween(Container.Main.Sidebar.NamesBehind, {BackgroundColor3 = Theme.SidebarColor}, 0.25)
                        Utility:Tween(Container.Main.Sidebar.Filler3, {BackgroundColor3 = Theme.SidebarColor}, 0.25)
                        Utility:Tween(Container.Main.Sidebar.HubNameText, {BackgroundColor3 = Theme.SidebarColor}, 0.25)
                        Utility:Tween(Container.Main.Sidebar.HubNameText, {TextColor3 = Theme.PrimaryTextColor}, 0.25)
                        Utility:Tween(Container.Main.Sidebar.GameNameText, {BackgroundColor3 = Theme.SidebarColor}, 0.25)
                        Utility:Tween(Container.Main.Sidebar.GameNameText, {TextColor3 = Theme.SecondaryTextColor}, 0.25)
                        Utility:Tween(Container.Main.Sidebar.SidebarLine1, {BackgroundColor3 = Theme.UIStrokeColor}, 0.25)
                        Utility:Tween(Container.Main.Sidebar.SidebarLine2, {BackgroundColor3 = Theme.UIStrokeColor}, 0.25)
                        Utility:Tween(Container.Main.Sidebar.TabButtonHolder, {BackgroundColor3 = Theme.SidebarColor}, 0.25)
                        Utility:Tween(Container.Main.TabContainer, {BackgroundColor3 = Theme.BackgroundColor}, 0.25)
                    else 
                        break
                    end
                end
            end
        end)
    end

    function ChangeThemeValue()
        task.spawn(function()
            ChangeTheme = true
            task.wait()
            ChangeTheme = false
        end)
    end

    function Library:ChangeTheme(NewTheme)
        if not ImprovePerformance then
            if type(NewTheme) == 'table' then
                Theme = NewTheme
                local NewTable = {}
                for Index, Value in next, Theme do
                    NewTable[Index] = Utility:SplitColor(Value)
                end
                writefile('VisualUILibraryCurrentTheme.json', HttpService:JSONEncode(NewTable))
                Config['Theme_4z3s4QrUhfqt703FmiAe'] = HttpService:JSONEncode(NewTable)
                ChangeThemeValue()
            elseif type(NewTheme) == 'string' then
                NewTheme = NewTheme:lower()
                if NewTheme == 'custom' then
                    Theme = Themes['Custom']
                    local NewTable = {}
                    for Index, Value in next, Theme do
                        NewTable[Index] = Utility:SplitColor(Value)
                    end
                    writefile('VisualUILibraryCurrentTheme.json', HttpService:JSONEncode(NewTable))
                    Config['Theme_4z3s4QrUhfqt703FmiAe'] = HttpService:JSONEncode(NewTable)
                    ChangeThemeValue()
                elseif NewTheme == 'default' then
                    Theme = Themes['Default']
                    local NewTable = {}
                    for Index, Value in next, Theme do
                        NewTable[Index] = Utility:SplitColor(Value)
                    end
                    writefile('VisualUILibraryCurrentTheme.json', HttpService:JSONEncode(NewTable))
                    Config['Theme_4z3s4QrUhfqt703FmiAe'] = HttpService:JSONEncode(NewTable)
                    ChangeThemeValue()
                elseif NewTheme == 'lighter' then
                    Theme = Themes['Lighter']
                    local NewTable = {}
                    for Index, Value in next, Theme do
                        NewTable[Index] = Utility:SplitColor(Value)
                    end
                    writefile('VisualUILibraryCurrentTheme.json', HttpService:JSONEncode(NewTable))
                    Config['Theme_4z3s4QrUhfqt703FmiAe'] = HttpService:JSONEncode(NewTable)
                    ChangeThemeValue()
                elseif NewTheme == 'light' then
                    Theme = Themes['Light']
                    local NewTable = {}
                    for Index, Value in next, Theme do
                        NewTable[Index] = Utility:SplitColor(Value)
                    end
                    writefile('VisualUILibraryCurrentTheme.json', HttpService:JSONEncode(NewTable))
                    Config['Theme_4z3s4QrUhfqt703FmiAe'] = HttpService:JSONEncode(NewTable)
                    ChangeThemeValue()
                elseif NewTheme == 'light+' then
                    Theme = Themes['Light+']
                    local NewTable = {}
                    for Index, Value in next, Theme do
                        NewTable[Index] = Utility:SplitColor(Value)
                    end
                    writefile('VisualUILibraryCurrentTheme.json', HttpService:JSONEncode(NewTable))
                    Config['Theme_4z3s4QrUhfqt703FmiAe'] = HttpService:JSONEncode(NewTable)
                    ChangeThemeValue()
                elseif NewTheme == 'discord' then
                    Theme = Themes['Discord']
                    local NewTable = {}
                    for Index, Value in next, Theme do
                        NewTable[Index] = Utility:SplitColor(Value)
                    end
                    writefile('VisualUILibraryCurrentTheme.json', HttpService:JSONEncode(NewTable))
                    Config['Theme_4z3s4QrUhfqt703FmiAe'] = HttpService:JSONEncode(NewTable)
                    ChangeThemeValue()
                elseif NewTheme == 'red and black' then
                    Theme = Themes['Red And Black']
                    local NewTable = {}
                    for Index, Value in next, Theme do
                        NewTable[Index] = Utility:SplitColor(Value)
                    end
                    writefile('VisualUILibraryCurrentTheme.json', HttpService:JSONEncode(NewTable))
                    Config['Theme_4z3s4QrUhfqt703FmiAe'] = HttpService:JSONEncode(NewTable)
                    ChangeThemeValue()
                elseif NewTheme == 'nordic dark' then
                    Theme = Themes['Nordic Dark']
                    local NewTable = {}
                    for Index, Value in next, Theme do
                        NewTable[Index] = Utility:SplitColor(Value)
                    end
                    writefile('VisualUILibraryCurrentTheme.json', HttpService:JSONEncode(NewTable))
                    Config['Theme_4z3s4QrUhfqt703FmiAe'] = HttpService:JSONEncode(NewTable)
                    ChangeThemeValue()
                elseif NewTheme == 'nordic light' then
                    Theme = Themes['Nordic Light']
                    local NewTable = {}
                    for Index, Value in next, Theme do
                        NewTable[Index] = Utility:SplitColor(Value)
                    end
                    writefile('VisualUILibraryCurrentTheme.json', HttpService:JSONEncode(NewTable))
                    Config['Theme_4z3s4QrUhfqt703FmiAe'] = HttpService:JSONEncode(NewTable)
                    ChangeThemeValue()
                elseif NewTheme == 'purple' then
                    Theme = Themes['Purple']
                    local NewTable = {}
                    for Index, Value in next, Theme do
                        NewTable[Index] = Utility:SplitColor(Value)
                    end
                    writefile('VisualUILibraryCurrentTheme.json', HttpService:JSONEncode(NewTable))
                    Config['Theme_4z3s4QrUhfqt703FmiAe'] = HttpService:JSONEncode(NewTable)
                    ChangeThemeValue()
                elseif NewTheme == 'sentinel' then
                    Theme = Themes['Sentinel']
                    local NewTable = {}
                    for Index, Value in next, Theme do
                        NewTable[Index] = Utility:SplitColor(Value)
                    end
                    writefile('VisualUILibraryCurrentTheme.json', HttpService:JSONEncode(NewTable))
                    Config['Theme_4z3s4QrUhfqt703FmiAe'] = HttpService:JSONEncode(NewTable)
                    ChangeThemeValue()
                elseif NewTheme == 'synapse x' then
                    Theme = Themes['Synapse X']
                    local NewTable = {}
                    for Index, Value in next, Theme do
                        NewTable[Index] = Utility:SplitColor(Value)
                    end
                    writefile('VisualUILibraryCurrentTheme.json', HttpService:JSONEncode(NewTable))
                    Config['Theme_4z3s4QrUhfqt703FmiAe'] = HttpService:JSONEncode(NewTable)
                    ChangeThemeValue()
                elseif NewTheme == 'krnl' then
                    Theme = Themes['Krnl']
                    local NewTable = {}
                    for Index, Value in next, Theme do
                        NewTable[Index] = Utility:SplitColor(Value)
                    end
                    writefile('VisualUILibraryCurrentTheme.json', HttpService:JSONEncode(NewTable))
                    Config['Theme_4z3s4QrUhfqt703FmiAe'] = HttpService:JSONEncode(NewTable)
                    ChangeThemeValue()
                elseif NewTheme == 'script-ware' then
                    Theme = Themes['Script-Ware']
                    local NewTable = {}
                    for Index, Value in next, Theme do
                        NewTable[Index] = Utility:SplitColor(Value)
                    end
                    writefile('VisualUILibraryCurrentTheme.json', HttpService:JSONEncode(NewTable))
                    Config['Theme_4z3s4QrUhfqt703FmiAe'] = HttpService:JSONEncode(NewTable)
                    ChangeThemeValue()
                elseif NewTheme == 'kiriot' then
                    Theme = Themes['Kiriot']
                    local NewTable = {}
                    for Index, Value in next, Theme do
                        NewTable[Index] = Utility:SplitColor(Value)
                    end
                    writefile('VisualUILibraryCurrentTheme.json', HttpService:JSONEncode(NewTable))
                    Config['Theme_4z3s4QrUhfqt703FmiAe'] = HttpService:JSONEncode(NewTable)
                    ChangeThemeValue()
                end
            end
        end
    end

    function Library:ChangeColor(Index, Color)
        if not ImprovePerformance then
            Theme[Index] = Color
            local NewTable = {}
            for Index, Value in next, Theme do
                NewTable[Index] = Utility:SplitColor(Value)
            end
            writefile('VisualUILibraryCurrentTheme.json', HttpService:JSONEncode(NewTable))
            Config['Theme_4z3s4QrUhfqt703FmiAe'] = HttpService:JSONEncode(NewTable)
            ChangeThemeValue()
        end
    end

    function Library:ReturnTheme()
        return Theme
    end

    function Library:GetThemes()
        local Table = {}
        for Index, Value in next, Themes do
            table.insert(Table, Index)
        end
        return Table
    end

    local Tabs = {}

    function Tabs:CreateTab(TabName, DefaultVisibility, Icon, RectOffset, RectSize)
        local TabName = TabName or 'Tab'
        local RectOffset = RectOffset or Vector2.new(0, 0)
        local RectSize = RectSize or Vector2.new(0, 0)

        Utility:Create('ScrollingFrame', {
            Name = TabName,
            Parent = Container.Main.TabContainer.TabsFolder,
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Theme.BackgroundColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 428, 0, 365),
            BorderSizePixel = 0,
            ScrollBarImageColor3 = Theme.ScrollBarColor,
            ScrollBarThickness = 3
        }, {
            Utility:Create('UIListLayout', {
                Name = TabName..'ListLayout',
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 3)
            })
        })
        Utility:Create('Frame', {
            Name = TabName..'ButtonFrame',
            Parent = Container.Main.Sidebar.TabButtonHolder,
            BackgroundColor3 = Theme.SidebarColor,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 170, 0, 30)
        }, {
            Utility:Create('TextButton', {
                Name = TabName..'Button',
                BackgroundColor3 = Theme.SidebarColor,
                BackgroundTransparency = 1,
                Text = '',
                Size = UDim2.new(0, 170, 0, 30),
                BorderSizePixel = 0,
                ZIndex = 2
            }),
            Utility:Create('ImageLabel', {
                Name = TabName..'ButtonImage',
                BackgroundColor3 = Theme.SidebarColor,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 10, 0, 5),
                Size = UDim2.new(0, 20, 0, 20),
                Image = Icon,
                ImageRectOffset = RectOffset,
                ImageRectSize = RectSize
            }),
            Utility:Create('TextLabel', {
                Name = TabName..'ButtonText',
                BackgroundColor3 = Theme.SidebarColor,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 30, 0, 3),
                Size = UDim2.new(0, 140, 0, 24),
                Font = Enum.Font.Gotham,
                Text = TabName,
                TextColor3 = Theme.PrimaryTextColor,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left
            }, {
                Utility:Create('UIPadding', {
                    Name = TabName..'ButtonTextPadding',
                    PaddingLeft = UDim.new(0, 5)
                })
            })
        })
        
        local TabFolder = Container.Main.TabContainer.TabsFolder
        local Tab = TabFolder[TabName]
        local TabButtonHolder = Container.Main.Sidebar.TabButtonHolder
        local TabButton = TabButtonHolder[TabName..'ButtonFrame'][TabName..'Button']
        local TabListLayout = Tab[TabName..'ListLayout']

        if not ImprovePerformance then
            task.spawn(function()
                while task.wait() do
                    if ChangeTheme then
                        if not BreakAllLoops then
                            if Tab.Visible then
                                Utility:Tween(TabButtonHolder[TabName..'ButtonFrame'][TabName..'ButtonText'], {TextColor3 = Theme.PrimaryTextColor}, 0.25)
                                Utility:Tween(TabButtonHolder[TabName..'ButtonFrame'][TabName..'ButtonImage'], {ImageColor3 = Theme.PrimaryTextColor}, 0.25)
                            else
                                Utility:Tween(TabButtonHolder[TabName..'ButtonFrame'][TabName..'ButtonText'], {TextColor3 = Theme.SecondaryTextColor}, 0.25)
                                Utility:Tween(TabButtonHolder[TabName..'ButtonFrame'][TabName..'ButtonImage'], {ImageColor3 = Theme.SecondaryTextColor}, 0.25)
                            end
                            Utility:Tween(Tab, {BackgroundColor3 = Theme.BackgroundColor}, 0.25)
                            Utility:Tween(Tab, {ScrollBarImageColor3 = Theme.ScrollBarColor}, 0.25)
                            Utility:Tween(TabButtonHolder[TabName..'ButtonFrame'], {BackgroundColor3 = Theme.SidebarColor}, 0.25)
                            Utility:Tween(TabButton, {BackgroundColor3 = Theme.BackgroundColor}, 0.25)
                            Utility:Tween(TabButtonHolder[TabName..'ButtonFrame'][TabName..'ButtonImage'], {BackgroundColor3 = Theme.SidebarColor}, 0.25)
                            Utility:Tween(TabButtonHolder[TabName..'ButtonFrame'][TabName..'ButtonText'], {BackgroundColor3 = Theme.SidebarColor}, 0.25)
                        else
                            break
                        end
                    end
                end
            end)
        end
        
        if DefaultVisibility then
            TabButton.Parent[TabName..'ButtonText'].TextColor3 = Theme.PrimaryTextColor
            TabButton.Parent[TabName..'ButtonImage'].ImageColor3 = Theme.PrimaryTextColor
            Tab.Visible = true

            for _, ITab in next, TabFolder:GetChildren()do 
                if ITab:IsA('ScrollingFrame') and ITab ~= Tab then
                    ITab.Visible = false
                end
            end
        else
            Tab.Visible = false
            TabButton.Parent[TabName..'ButtonText'].TextColor3 = Theme.SecondaryTextColor
            TabButton.Parent[TabName..'ButtonImage'].ImageColor3 = Theme.SecondaryTextColor
        end

        TabButton.MouseButton1Down:Connect(function()
            for _, ITab in next, TabFolder:GetChildren() do
                ITab.Visible = false
            end

            Tab.Visible = true
                
            for _, Item in next, TabButtonHolder:GetDescendants() do
                if Item:IsA('TextLabel') then 
                    Utility:Tween(Item, {TextColor3 = Theme.SecondaryTextColor}, 0.25)
                elseif Item:IsA('ImageLabel') then
                    Utility:Tween(Item, {ImageColor3 = Theme.SecondaryTextColor}, 0.25)
                end
            end

            Utility:Tween(TabButton.Parent[TabName..'ButtonText'], {TextColor3 = Theme.PrimaryTextColor}, 0.25)
            Utility:Tween(TabButton.Parent[TabName..'ButtonImage'], {ImageColor3 = Theme.PrimaryTextColor}, 0.25)
        end) 

        local Sections = {}

        function Sections:CreateSection(Name)
            local Name = Name or 'Section'
            
            Utility:Create('Frame', {
                Name = Name..'Section',
                Parent = Tab,
                BackgroundColor3 = Theme.BackgroundColor,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 410, 0, 30),
            }, {
                Utility:Create('TextLabel', {
                    Name = Name..'SectionLabel',
                    BackgroundColor3 = Theme.BackgroundColor,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 410, 0, 30),
                    Font = Enum.Font.Gotham,
                    Text = Name,
                    TextColor3 = Theme.SecondaryTextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, {
                    Utility:Create('UIPadding', {
                        Name = Name..'SectionLabelPadding',
                        PaddingLeft = UDim.new(0, 3)
                    })
                }),
                Utility:Create('UICorner', {
                    Name = 'SectionCorner',
                    CornerRadius = UDim.new(0, 5)
                }),
                Utility:Create('UIListLayout', {
                    Name = Name..'ListLayout',
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 6)
                })
            })

            local Section = Tab[Name..'Section']

            if not ImprovePerformance then
                task.spawn(function()
                    while task.wait() do
                        if ChangeTheme then
                            if not BreakAllLoops then
                                Utility:Tween(Section, {BackgroundColor3 = Theme.BackgroundColor}, 0.25)
                                Utility:Tween(Section[Name..'SectionLabel'], {BackgroundColor3 = Theme.BackgroundColor}, 0.25)
                                Utility:Tween(Section[Name..'SectionLabel'], {TextColor3 = Theme.SecondaryTextColor}, 0.25)
                            else
                                break
                            end
                        end
                    end
                end)
            end
            
            function UpdateSectionSize()
                local ContentSize = Section[Name..'ListLayout'].AbsoluteContentSize

                Utility:Tween(Section, {Size = UDim2.new(0, ContentSize.X, 0, ContentSize.Y)}, 0.25)
            end

            for _, Item in next, Section:GetChildren() do
                RunService.RenderStepped:Connect(function()
                    if Item:IsA('Frame') then
                        Item.Changed:Connect(function(Property)
                            if Property == 'Size' then
                                UpdateSectionSize()
                            end
                        end)
                    end
                end)
            end

            UpdateSectionSize()
            Section.ChildAdded:Connect(UpdateSectionSize)
            Section.ChildRemoved:Connect(UpdateSectionSize)

            local Elements = {}
            
            function Elements:CreateLabel(LabelText)
                local LabelText = LabelText or 'Label'
                local LabelFunctions = {}

                Utility:Create('Frame', {
                    Name = LabelText..'LabelHolder',
                    Parent = Section,
                    BackgroundColor3 = Theme.OtherElementColor,
                    Size = UDim2.new(0, 410, 0, 30)
                }, {
                    Utility:Create('UICorner', {
                        CornerRadius = UDim.new(0, 5),
                        Name = LabelText..'LabelHolderCorner'
                    }),
                    Utility:Create('UIStroke', {
                        Name = LabelText..'LabelStroke',
                        ApplyStrokeMode = 'Contextual',
                        Color = Theme.UIStrokeColor,
                        LineJoinMode = 'Round',
                        Thickness = 1
                    }),
                    Utility:Create('TextLabel', {
                        Name = LabelText..'Label',
                        BackgroundColor3 = Theme.OtherElementColor,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 410, 0, 30),
                        Font = Enum.Font.Gotham,
                        TextColor3 = Theme.PrimaryTextColor,
                        TextSize = 16,
                        Text = LabelText,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }, {
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 5),
                            Name = LabelText..'LabelCorner'
                        }),
                        Utility:Create('UIPadding', {
                            Name = LabelText..'LabelPadding',
                            PaddingLeft = UDim.new(0, 7)
                        })
                    })
                })

                UpdateSectionSize()

                if not ImprovePerformance then
                    task.spawn(function()
                        while task.wait() do
                            if ChangeTheme then
                                if not BreakAllLoops then
                                    Utility:Tween(Section[LabelText..'LabelHolder'], {BackgroundColor3 = Theme.OtherElementColor}, 0.25)
                                    Utility:Tween(Section[LabelText..'LabelHolder'][LabelText..'LabelStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                    Utility:Tween(Section[LabelText..'LabelHolder'][LabelText..'Label'], {BackgroundColor3 = Theme.OtherElementColor}, 0.25)
                                    Utility:Tween(Section[LabelText..'LabelHolder'][LabelText..'Label'], {TextColor3 = Theme.PrimaryTextColor}, 0.25)
                                else
                                    break
                                end
                            end
                        end
                    end)
                end

                function LabelFunctions:UpdateLabel(NewText)
                    Section[LabelText..'LabelHolder'][LabelText..'Label'].Text = NewText
                end
                return LabelFunctions
            end

            function Elements:CreateParagraph(Title, Paragraph)
                local Title = Title or 'Title'
                local Paragraph = Paragraph or 'Text'
                local ParagraphFunctions = {}

                Utility:Create('Frame', {
                    Name = Title..'ParagraphHolder',
                    Parent = Section,
                    BackgroundColor3 = Theme.PrimaryElementColor,
                    Size = UDim2.new(0, 410, 0, 37)
                }, {
                    Utility:Create('UICorner', {
                        CornerRadius = UDim.new(0, 5),
                        Name = Title..'ParagraphHolderCorner'
                    }),
                    Utility:Create('UIStroke', {
                        Name = Title..'ParagraphStroke',
                        ApplyStrokeMode = 'Contextual',
                        Color = Theme.UIStrokeColor,
                        LineJoinMode = 'Round',
                        Thickness = 1
                    }),
                    Utility:Create('TextLabel', {
                        Name = Title..'ParagraphTitle',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, 0),
                        Size = UDim2.new(0, 410, 0, 20),
                        Font = Enum.Font.Gotham,
                        Text = Title,
                        TextColor3 = Theme.PrimaryTextColor,
                        TextSize = 16,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }, {
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 5),
                            Name = Title..'ParagraphTitleCorner'
                        }),
                        Utility:Create('UIPadding', {
                            Name = Title..'ParagraphTitlePadding',
                            PaddingLeft = UDim.new(0, 7)
                        })
                    }),
                    Utility:Create('TextLabel', {
                        Name = Title..'ParagraphContent',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, 20),
                        Size = UDim2.new(0, 410, 0, 20),
                        Font = Enum.Font.Gotham,
                        Text = Paragraph,
                        TextColor3 = Theme.SecondaryTextColor,
                        TextWrapped = true,
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }, {
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 5),
                            Name = Title..'ParagraphContentCorner'
                        }),
                        Utility:Create('UIPadding', {
                            Name = Title..'ParagraphContentPadding',
                            PaddingLeft = UDim.new(0, 7)
                        })
                    })
                })
                local Old

                local ParagraphHolder = Section[Title..'ParagraphHolder']
                local ParagraphContent = Section[Title..'ParagraphHolder'][Title..'ParagraphContent']
                local ParagraphTitle = Section[Title..'ParagraphHolder'][Title..'ParagraphTitle']

                local TextSizeOld = TextService:GetTextSize(Paragraph, 14, Enum.Font.Gotham, Vector2.new(410, math.huge))

                ParagraphHolder.Size = UDim2.new(0, 410, 0, TextSizeOld.Y + 25)
                ParagraphContent.Size = UDim2.new(0, 410, 0, TextSizeOld.Y)

                UpdateSectionSize()

                if not ImprovePerformance then
                    task.spawn(function()
                        while task.wait() do
                            if ChangeTheme then
                                if not BreakAllLoops then
                                    Utility:Tween(ParagraphHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(ParagraphHolder[Title..'ParagraphStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                    Utility:Tween(ParagraphTitle, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(ParagraphTitle, {TextColor3 = Theme.PrimaryTextColor}, 0.25)
                                    Utility:Tween(ParagraphContent, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(ParagraphContent, {TextColor3 = Theme.SecondaryTextColor}, 0.25)
                                else
                                    break
                                end
                            end
                        end
                    end)
                end

                function ParagraphFunctions:UpdateParagraph(NewTitle, NewParagraph)
                    Old = ParagraphContent.Text
                    ParagraphTitle.Text = NewTitle
                    ParagraphContent.Text = NewParagraph
                    local TextSizeNew = TextService:GetTextSize(ParagraphContent.Text, 14, Enum.Font.Gotham, Vector2.new(410, math.huge))
                    local TextSizeOld = TextService:GetTextSize(Old, 14, Enum.Font.Gotham, Vector2.new(410, math.huge))

                    if TextSizeNew.Y > 14 and TextSizeNew.Y > TextSizeOld.Y then
                        Tab.CanvasSize = Tab.CanvasSize - UDim2.new(0, 0, 0, TextSizeOld.Y + 5)
                        Section.Size = Section.Size - UDim2.new(0, 0, 0, TextSizeOld.Y + 5)
                        Tab.CanvasSize = Tab.CanvasSize + UDim2.new(0, 0, 0, TextSizeNew.Y + 5)
                        Section.Size = Section.Size + UDim2.new(0, 0, 0, TextSizeNew.Y + 5)
                        ParagraphHolder.Size = UDim2.new(0, 410, 0, TextSizeNew.Y + 20)
                        ParagraphContent.Size = UDim2.new(0, 410, 0, TextSizeNew.Y)
                    elseif TextSizeNew.Y < TextSizeOld.Y then
                        Tab.CanvasSize = Tab.CanvasSize - UDim2.new(0, 0, 0, TextSizeOld.Y + 5)
                        Section.Size = Section.Size - UDim2.new(0, 0, 0, TextSizeOld.Y + 5)
                        Tab.CanvasSize = Tab.CanvasSize + UDim2.new(0, 0, 0, TextSizeNew.Y + 5)
                        Section.Size = Section.Size + UDim2.new(0, 0, 0, TextSizeNew.Y + 5)
                        ParagraphHolder.Size = ParagraphHolder.Size - UDim2.new(0, 0, 0, TextSizeOld.Y)
                        ParagraphHolder.Size = UDim2.new(0, 410, 0, TextSizeNew.Y + 20)
                        ParagraphContent.Size = UDim2.new(0, 410, 0, TextSizeNew.Y)
                    end       
                end
                return ParagraphFunctions
            end

            function Elements:CreateButton(Name, Callback)
                local Name = Name or 'Button'
                local Callback = Callback or function() end
                local Hovering = false

                Utility:Create('Frame', {
                    Name = Name..'ButtonHolder',
                    Parent = Section,
                    BackgroundColor3 = Theme.PrimaryElementColor,
                    Size = UDim2.new(0, 410, 0, 30)
                }, {
                    Utility:Create('UICorner', {
                        CornerRadius = UDim.new(0, 5),
                        Name = Name..'ButtonHolderCorner'
                    }),
                    Utility:Create('UIStroke', {
                        Name = Name..'ButtonHolderStroke',
                        ApplyStrokeMode = 'Contextual',
                        Color = Theme.UIStrokeColor,
                        LineJoinMode = 'Round',
                        Thickness = 1
                    }),
                    Utility:Create('TextButton', {
                        Name = Name..'Button',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 410, 0, 30),
                        Font = Enum.Font.Gotham,
                        TextColor3 = Theme.PrimaryTextColor,
                        TextSize = 16,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Text = Name
                    }, {
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 5),
                            Name = 'ButtonCorner'
                        }),
                        Utility:Create('UIPadding', {
                            Name = 'ButtonPadding',
                            PaddingLeft = UDim.new(0, 7)
                        }),
                        Utility:Create('ImageLabel', {
                            Name = 'ButtonImage',
                            BackgroundColor3 = Theme.PrimaryElementColor,
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 374, 0, 3),
                            Size = UDim2.new(0, 25, 0, 25),
                            Image = 'rbxassetid://3926307971',
                            ImageColor3 = Theme.SecondaryTextColor,
                            ImageRectOffset = Vector2.new(564, 364),
                            ImageRectSize = Vector2.new(36, 36)
                        })
                    })
                })

                UpdateSectionSize()

                local ButtonHolder = Section[Name..'ButtonHolder']
                local Button = ButtonHolder[Name..'Button']

                if not ImprovePerformance then
                    task.spawn(function()
                        while task.wait() do
                            if ChangeTheme then
                                if not BreakAllLoops then
                                    if not Hovering then
                                        Utility:Tween(ButtonHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    end
                                    Utility:Tween(ButtonHolder[Name..'ButtonHolderStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                    Utility:Tween(Button, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(Button, {TextColor3 = Theme.PrimaryTextColor}, 0.25)
                                    Utility:Tween(Button['ButtonImage'], {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(Button['ButtonImage'], {ImageColor3 = Theme.SecondaryTextColor}, 0.25)
                                else
                                    break
                                end
                            end
                        end
                    end)
                end

                Button.MouseButton1Down:Connect(function()
                    Hovering = true
                    Utility:Tween(ButtonHolder, {BackgroundColor3 = Utility:Darken(Theme.PrimaryElementColor)}, 0.25)
                    task.spawn(function()
                        Callback()
                    end)
                    task.wait(0.25)
                    Utility:Tween(ButtonHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                    Hovering = false
                end)

                Button.MouseEnter:Connect(function()
                    Hovering = true
                    Utility:Tween(ButtonHolder, {BackgroundColor3 = Utility:Lighten(Theme.PrimaryElementColor)}, 0.25)
                end)

                Button.MouseLeave:Connect(function()
                    Utility:Tween(ButtonHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                    Hovering = false
                end)
            end

            function Elements:CreateSlider(Name, MinimumValue, MaximumValue, DefaultValue, SliderColor, Callback)
                local Name = Name or 'Slider'
                local MinimumValue = MinimumValue or 1
                local MaximumValue = MaximumValue or 100
                local SliderColor = SliderColor or Color3.fromRGB(0, 125, 255)
                local Callback = Callback or function() end
                local CurrentValue = DefaultValue
                local SliderFunctions = {}
                local Hovering = false

                Utility:Create('Frame', {
                    Name = Name..'SliderHolder',
                    Parent = Section,
                    BackgroundColor3 = Theme.PrimaryElementColor,
                    Size = UDim2.new(0, 410, 0, 50)
                }, {
                    Utility:Create('UICorner', {
                        CornerRadius = UDim.new(0, 5),
                        Name = Name..'SliderHolderCorner'
                    }),
                    Utility:Create('UIStroke', {
                        Name = Name..'SliderHolderStroke',
                        ApplyStrokeMode = 'Contextual',
                        Color = Theme.UIStrokeColor,
                        LineJoinMode = 'Round',
                        Thickness = 1
                    }),
                    Utility:Create('TextLabel', {
                        Name = 'SliderText',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 300, 0, 30),
                        Font = Enum.Font.Gotham,
                        Text = Name,
                        TextColor3 = Theme.PrimaryTextColor,
                        TextSize = 16,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }, {
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 5),
                            Name = Name..'SliderTextCorner'
                        }),
                        Utility:Create('UIPadding', {
                            Name = Name..'SliderTextPadding',
                            PaddingLeft = UDim.new(0, 7)
                        }),
                    }),
                    Utility:Create('TextButton', {
                        Name = Name..'SliderButton',
                        BackgroundColor3 = Theme.SecondaryElementColor,
                        Position = UDim2.new(0, 7, 0, 29),
                        Size = UDim2.new(0, 395, 0, 10),
                        Text = '',
                        BorderSizePixel = 0,
                        AutoButtonColor = false
                    }, {
                        Utility:Create('UIStroke', {
                            Name = Name..'SliderButtonStroke',
                            ApplyStrokeMode = 'Contextual',
                            Color = Theme.UIStrokeColor,
                            LineJoinMode = 'Round',
                            Thickness = 1
                        }),
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 5),
                            Name = Name..'SliderButtonCorner'
                        }),
                        Utility:Create('Frame', {
                            Name = Name..'SliderTrail',
                            BackgroundColor3 = SliderColor,
                            Size = UDim2.new(0, 0, 0, 10),
                            BorderSizePixel = 0
                        }, {
                            Utility:Create('UICorner', {
                                CornerRadius = UDim.new(0, 5),
                                Name = Name..'SliderTrailCorner'
                            })
                        })
                    }),
                    Utility:Create('TextLabel', {
                        Name = Name..'SliderNumberText',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 299, 0, 0),
                        Size = UDim2.new(0, 110, 0, 30),
                        Font = Enum.Font.Gotham,
                        Text = '0',
                        TextColor3 = Theme.SecondaryTextColor,
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Right
                    }, {
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 5),
                            Name = Name..'SliderNumberTextCorner'
                        }),
                        Utility:Create('UIPadding', {
                            Name = Name..'SliderNumberTextPadding',
                            PaddingRight = UDim.new(0, 7)
                        })
                    })
                })

                local Mouse = Players.LocalPlayer:GetMouse()
                local SliderHolder = Section[Name..'SliderHolder']
                local SliderButton = SliderHolder[Name..'SliderButton']
                local SliderNumber = SliderHolder[Name..'SliderNumberText']
                local SliderTrail = SliderButton[Name..'SliderTrail']

                UpdateSectionSize()

                Config[Name] = CurrentValue

                if not ImprovePerformance then
                    task.spawn(function()
                        while task.wait() do
                            if ChangeTheme then
                                if not BreakAllLoops then
                                    if not Hovering then
                                        Utility:Tween(SliderHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    end
                                    Utility:Tween(SliderHolder[Name..'SliderHolderStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                    Utility:Tween(SliderHolder['SliderText'], {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(SliderHolder['SliderText'], {TextColor3 = Theme.PrimaryTextColor}, 0.25)
                                    Utility:Tween(SliderButton, {BackgroundColor3 = Theme.SecondaryElementColor}, 0.25)
                                    Utility:Tween(SliderButton[Name..'SliderButtonStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                    Utility:Tween(SliderNumber, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(SliderNumber, {TextColor3 = Theme.SecondaryTextColor}, 0.25)
                                else
                                    break
                                end
                            end
                        end
                    end)
                end

                if DefaultValue ~= nil then
                    SliderNumber.Text = tostring(DefaultValue and math.floor((DefaultValue / MaximumValue) * (MaximumValue - MinimumValue) + MinimumValue))
                    Utility:Tween(SliderTrail, {Size = UDim2.new((DefaultValue) / MaximumValue, 0, 0, 10)}, 0.25)  
                    task.spawn(function()
                        Callback(CurrentValue)
                    end)
                end

                SliderButton.MouseButton1Down:Connect(function()
                    CurrentValue = (((tonumber(MaximumValue) - tonumber(MinimumValue)) / 395) * SliderTrail.AbsoluteSize.X) + tonumber(MinimumValue)
                    task.spawn(function()
                        Callback(CurrentValue)
                    end)
                    Utility:Tween(SliderTrail, {Size = UDim2.new(0, math.clamp(Mouse.X - SliderTrail.AbsolutePosition.X, 0, 395), 0, 10)}, 0.25)
                    MoveConnection = Mouse.Move:Connect(function()
                        SliderNumber.Text = CurrentValue
                        CurrentValue = math.floor((((tonumber(MaximumValue) - tonumber(MinimumValue)) / 395) * SliderTrail.AbsoluteSize.X) + tonumber(MinimumValue))
                        task.spawn(function()
                            Callback(CurrentValue)
                        end)
                        Config[Name] = CurrentValue
                        Utility:Tween(SliderNumber, {TextColor3 = Color3.new(255, 255, 255)}, 0.25)
                        Utility:Tween(SliderTrail, {Size = UDim2.new(0, math.clamp(Mouse.X - SliderTrail.AbsolutePosition.X, 0, 395), 0, 10)}, 0.25)
                    end)
                    ReleaseConnection = UserInputService.InputEnded:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            CurrentValue = math.floor((((tonumber(MaximumValue) - tonumber(MinimumValue)) / 395) * SliderTrail.AbsoluteSize.X) + tonumber(MinimumValue))
                            task.spawn(function()
                                Callback(CurrentValue)
                            end)
                            Config[Name] = CurrentValue
                            Utility:Tween(SliderTrail, {Size = UDim2.new(0, math.clamp(Mouse.X - SliderTrail.AbsolutePosition.X, 0, 395), 0, 10)}, 0.25)
                            MoveConnection:Disconnect()
                            ReleaseConnection:Disconnect()
                        end
                    end)
                end)

                SliderHolder.MouseEnter:Connect(function()
                    Hovering = true
                    Utility:Tween(SliderHolder, {BackgroundColor3 = Utility:Lighten(Theme.PrimaryElementColor)}, 0.25)
                end)

                SliderHolder.MouseLeave:Connect(function()
                    Utility:Tween(SliderHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                    Hovering = false
                end)

                function SliderFunctions:Set(Value)
                    SliderNumber.Text = tostring(Value and math.floor((Value / MaximumValue) * (MaximumValue - MinimumValue) + MinimumValue))
                    Utility:Tween(SliderTrail, {Size = UDim2.new((Value) / MaximumValue, 0, 0, 10)}, 0.25)  
                    Callback(Value)
                end
                ConfigUpdates[Name] = SliderFunctions
                return SliderFunctions
            end

            function Elements:CreateTextbox(Name, Placeholder, Callback)
                local Name = Name or 'Textbox'
                local Placeholder = Placeholder or 'Input'
                local Callback = Callback or function() end
                local Length = nil
                local Hovering = false

                Utility:Create('Frame', {
                    Name = Name..'TextboxHolder',
                    Parent = Section,
                    BackgroundColor3 = Theme.PrimaryElementColor,
                    Size = UDim2.new(0, 410, 0, 40)
                }, {
                    Utility:Create('UICorner', {
                        CornerRadius = UDim.new(0, 5),
                        Name = Name..'TextboxHolderCorner'
                    }),
                    Utility:Create('UIStroke', {
                        Name = Name..'TextboxHolderStroke',
                        ApplyStrokeMode = 'Contextual',
                        Color = Theme.UIStrokeColor,
                        LineJoinMode = 'Round',
                        Thickness = 1
                    }),
                    Utility:Create('TextLabel', {
                        Name = Name..'TextboxText',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, 5),
                        Size = UDim2.new(0, 299, 0, 30),
                        Font = Enum.Font.Gotham,
                        Text = Name,
                        TextColor3 = Theme.PrimaryTextColor,
                        TextSize = 16,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }, {
                        Utility:Create('UIPadding', {
                            Name = Name..'TextboxTextPadding',
                            PaddingLeft = UDim.new(0, 7)
                        })
                    }),
                    Utility:Create('TextBox', {
                        Name = Name..'Textbox',
                        BackgroundColor3 = Theme.SecondaryElementColor,
                        BorderSizePixel = 0,
                        AnchorPoint = Vector2.new(1, 0.5),
                        Position = UDim2.new(0, 400, 0, 20),
                        Size = UDim2.new(0, 50, 0, 25),
                        Font = Enum.Font.Gotham,
                        PlaceholderColor3 = Theme.SecondaryTextColor,
                        Text = Placeholder,
                        TextColor3 = Theme.SecondaryTextColor,
                        TextSize = 14,
                        ClearTextOnFocus = true
                    }, {
                        Utility:Create('UIStroke', {
                            Name = Name..'TextboxStroke',
                            ApplyStrokeMode = 'Border',
                            Color = Theme.UIStrokeColor,
                            LineJoinMode = 'Round',
                            Thickness = 1
                        }),
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 5),
                            Name = Name..'TextboxCorner'
                        })
                    })
                })

                local TextboxHolder = Section[Name..'TextboxHolder']
                local Textbox = TextboxHolder[Name..'Textbox']

                UpdateSectionSize()

                if not ImprovePerformance then
                    task.spawn(function()
                        while task.wait() do
                            if ChangeTheme then
                                if not BreakAllLoops then
                                    if not Hovering then
                                        Utility:Tween(TextboxHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    end
                                    Utility:Tween(TextboxHolder[Name..'TextboxHolderStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                    Utility:Tween(TextboxHolder[Name..'TextboxText'], {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(TextboxHolder[Name..'TextboxText'], {TextColor3 = Theme.PrimaryTextColor}, 0.25)
                                    Utility:Tween(Textbox, {BackgroundColor3 = Theme.SecondaryElementColor}, 0.25)
                                    Utility:Tween(Textbox, {PlaceholderColor3 = Theme.SecondaryTextColor}, 0.25)
                                    Utility:Tween(Textbox, {TextColor3 = Theme.SecondaryTextColor}, 0.25)
                                    Utility:Tween(Textbox[Name..'TextboxStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                else
                                    break
                                end
                            end
                        end
                    end)
                end

                local TextSize = TextService:GetTextSize(Placeholder, 14, Enum.Font.Gotham, Vector2.new(410, 40))

                if TextSize.X < 50 then 
                    Utility:Tween(Textbox, {Size = UDim2.new(0, 50, 0, 25)}, 0.25)
                else
                    Utility:Tween(Textbox, {Size = UDim2.new(0, TextSize.X + 10, 0, 25)}, 0.25)
                end

                Textbox.Focused:Connect(function()
                    Hovering = true
                    Utility:Tween(Textbox, {BackgroundColor3 = Utility:Lighten(Theme.SecondaryElementColor)}, 0.25)
                    Utility:Tween(TextboxHolder, {BackgroundColor3 = Utility:Lighten(Theme.PrimaryElementColor)}, 0.25)
                end)
                
                Textbox.FocusLost:Connect(function()
                    Utility:Tween(Textbox, {BackgroundColor3 = Theme.SecondaryElementColor}, 0.25)
                    Utility:Tween(TextboxHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                    task.spawn(function()
                        Callback(Textbox.Text)
                    end)
                    Hovering = false
                end)

                TextboxHolder.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Textbox:CaptureFocus()
                    end
                end)

                Textbox.Changed:Connect(function(Property)
                    if Property == 'Text' then
                        Utility:Tween(Textbox, {TextColor3 = Theme.PrimaryTextColor}, 0.25)

                        local TextSize = TextService:GetTextSize(Textbox.Text, 14, Enum.Font.Gotham, Vector2.new(410, 40))

                        if TextSize.X < 50 then 
                            Utility:Tween(Textbox, {Size = UDim2.new(0, 50, 0, 25)}, 0.25)
                        else
                            Utility:Tween(Textbox, {Size = UDim2.new(0, TextSize.X + 10, 0, 25)}, 0.25)
                        end
                    end
                end)

                TextboxHolder.MouseEnter:Connect(function()
                    Hovering = true
                    Utility:Tween(TextboxHolder, {BackgroundColor3 = Utility:Lighten(Theme.PrimaryElementColor)}, 0.25)
                end)

                TextboxHolder.MouseLeave:Connect(function()
                    Utility:Tween(TextboxHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                    Hovering = false
                end)
            end

            function Elements:CreateKeybind(Name, Key, Callback)
                local Name = Name or 'Keybind'
                local Key = Key or 'E'
                local Callback = Callback or function() end
                local Current = Key
                local KeybindFunctions = {}
                local Hovering = false

                Utility:Create('Frame', {
                    Name = Name..'KeybindHolder',
                    Parent = Section,
                    BackgroundColor3 = Theme.PrimaryElementColor,
                    Size = UDim2.new(0, 410, 0, 40)
                }, {
                    Utility:Create('UICorner', {
                        CornerRadius = UDim.new(0, 5),
                        Name = Name..'KeybindHolderCorner'
                    }),
                    Utility:Create('UIStroke', {
                        Name = Name..'KeybindHolderStroke',
                        ApplyStrokeMode = 'Contextual',
                        Color = Theme.UIStrokeColor,
                        LineJoinMode = 'Round',
                        Thickness = 1
                    }),
                    Utility:Create('TextLabel', {
                        Name = Name..'KeybindText',
                        Parent = KeybindHolder,
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, 5),
                        Size = UDim2.new(0, 352, 0, 30),
                        Font = Enum.Font.Gotham,
                        Text = Name,
                        TextColor3 = Theme.PrimaryTextColor,
                        TextSize = 16,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }, {
                        Utility:Create('UIPadding', {
                            Name = Name..'KeybindTextPadding',
                            PaddingLeft = UDim.new(0, 7)
                        })
                    }), 
                    Utility:Create('TextButton', {
                        Name = Name..'Keybind',
                        Parent = KeybindHolder,
                        BackgroundColor3 = Theme.SecondaryElementColor,
                        Position = UDim2.new(0, 376, 0, 8),
                        Size = UDim2.new(0, 25, 0, 25),
                        Font = Enum.Font.Gotham,
                        Text = Current,
                        AnchorPoint = Vector2.new(1, 0.5),
                        Position = UDim2.new(0, 400, 0, 20),
                        TextColor3 = Theme.SecondaryTextColor,
                        TextSize = 14,
                        AutoButtonColor = false
                    }, {
                        Utility:Create('UIStroke', {
                            Name = Name..'KeybindStroke',
                            ApplyStrokeMode = 'Border',
                            Color = Theme.UIStrokeColor,
                            LineJoinMode = 'Round',
                            Thickness = 1
                        }),
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 5),
                            Name = Name..'KeybindCorner'
                        })
                    })
                })
                
                local KeybindHolder = Section[Name..'KeybindHolder']
                local Keybind = KeybindHolder[Name..'Keybind']
                
                UpdateSectionSize()

                Config[Name] = Current

                if not ImprovePerformance then
                    task.spawn(function()
                        while task.wait() do
                            if ChangeTheme then
                                if not BreakAllLoops then
                                    if not Hovering then
                                        Utility:Tween(KeybindHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    end
                                    Utility:Tween(KeybindHolder[Name..'KeybindHolderStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                    Utility:Tween(KeybindHolder[Name..'KeybindText'], {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(KeybindHolder[Name..'KeybindText'], {TextColor3 = Theme.PrimaryTextColor}, 0.25)
                                    Utility:Tween(KeybindHolder[Name..'Keybind'], {BackgroundColor3 = Theme.SecondaryElementColor}, 0.25)
                                    Utility:Tween(KeybindHolder[Name..'Keybind'], {TextColor3 = Theme.SecondaryTextColor}, 0.25)
                                    Utility:Tween(KeybindHolder[Name..'Keybind'][Name..'KeybindStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                else
                                    break
                                end
                            end
                        end
                    end)
                end

                TextSize = TextService:GetTextSize(Current, 14, Enum.Font.Gotham, Vector2.new(410, 40))
                if TextSize.X < 25 then
                    Utility:Tween(Keybind, {Size = UDim2.new(0, 25, 0, 25)}, 0.25)
                else 
                    Utility:Tween(Keybind, {Size = UDim2.new(0, TextSize.X + 10, 0, 25)}, 0.25)
                end

                Keybind.MouseButton1Click:Connect(function()
                    Keybind.Text = '. . .'
                    Utility:Tween(KeybindHolder, {BackgroundColor3 = Utility:Lighten(Theme.PrimaryElementColor)}, 0.25)
                    local Input, _ = UserInputService.InputBegan:wait();

                    if Input.KeyCode.Name ~= 'Unknown' then
                        Keybind.Text = Input.KeyCode.Name
                        TextSize = TextService:GetTextSize(Input.KeyCode.Name, 14, Enum.Font.Gotham, Vector2.new(410, 40))
                        if TextSize.X < 25 then
                            Utility:Tween(Keybind, {Size = UDim2.new(0, 25, 0, 25)}, 0.25)
                        else 
                            Utility:Tween(Keybind, {Size = UDim2.new(0, TextSize.X + 10, 0, 25)}, 0.25)
                        end
                        Current = Input.KeyCode.Name;
                        Utility:Tween(KeybindHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                    end
                end)

                local Con = UserInputService.InputBegan:Connect(function(Input, GameProcessedEvent)
                    if not GameProcessedEvent then 
                        if Input.KeyCode.Name == Current then
                            task.spawn(function()
                                Callback()
                            end)
                        end
                    end
                end)

                function KeybindFunctions:Break()
                    Con:Disconnect()
                    print('x')
                end
                Ihatethisui[Name] = KeybindFunctions

                KeybindHolder.MouseEnter:Connect(function()
                    Hovering = true
                    Utility:Tween(KeybindHolder, {BackgroundColor3 = Utility:Lighten(Theme.PrimaryElementColor)}, 0.25)
                end)

                KeybindHolder.MouseLeave:Connect(function()
                    Utility:Tween(KeybindHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                    Hovering = false
                end)

                function KeybindFunctions:Set(Value)
                    Current = Value
                    Keybind.Text = Value
                end
                ConfigUpdates[Name] = KeybindFunctions
                return KeybindFunctions
            end

            function Elements:CreateToggle(Name, Default, ToggleColor, DebounceAmount, Callback)
                local Name = Name or 'Toggle'
                local Default = Default or false
                local Callback = Callback or function() end
                local Toggled = Default
                local ToggleColor = ToggleColor or Color3.fromRGB(0, 255, 100)
                local Debounce = false
                local DebounceAmount = DebounceAmount or 0.25
                local ToggleFunctions = {}
                local Hovering = false

                Utility:Create('Frame', {
                    Name = Name..'ToggleHolder',
                    Parent = Section,
                    BackgroundColor3 = Theme.PrimaryElementColor,
                    Size = UDim2.new(0, 410, 0, 40)
                }, {
                    Utility:Create('UICorner', {
                        CornerRadius = UDim.new(0, 5),
                        Name = Name..'ToggleHolderCorner'
                    }),
                    Utility:Create('UIStroke', {
                        Name = Name..'ToggleHolderStroke',
                        ApplyStrokeMode = 'Contextual',
                        Color = Theme.UIStrokeColor,
                        LineJoinMode = 'Round',
                        Thickness = 1
                    }),
                    Utility:Create('TextLabel', {
                        Name = Name..'ToggleText',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, 5),
                        Size = UDim2.new(0, 344, 0, 30),
                        Font = Enum.Font.Gotham,
                        Text = Name,
                        TextColor3 = Theme.PrimaryTextColor,
                        TextSize = 16,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }, {
                        Utility:Create('UIPadding', {
                            Name = Name..'ToggleTextPadding',
                            PaddingLeft = UDim.new(0, 7)
                        })
                    }),
                    Utility:Create('Frame', {
                        Name = Name..'Toggle',
                        BackgroundColor3 = Theme.SecondaryElementColor,
                        Position = UDim2.new(0, 352, 0, 8),
                        Size = UDim2.new(0, 50, 0, 25)        
                    }, {
                        Utility:Create('UIStroke', {
                            Name = Name..'ToggleStroke',
                            ApplyStrokeMode = 'Contextual',
                            Color = Theme.UIStrokeColor,
                            LineJoinMode = 'Round',
                            Thickness = 1
                        }),
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 25),
                            Name = Name..'ToggleCorner'
                        }),
                        Utility:Create('ImageLabel', {
                            Name = Name..'ToggleCircle',
                            BackgroundColor3 = Theme.PrimaryElementColor,
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 5, 0, 5),
                            Size = UDim2.new(0, 15, 0, 15),
                            Image = 'rbxassetid://3570695787',
                            ScaleType = Enum.ScaleType.Slice,
                            SliceCenter = Rect.new(100, 100, 100, 100),
                            SliceScale = 0.120,
                        })
                    }),
                    Utility:Create('TextButton', {
                        Name = Name..'ToggleButton',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 0, 0, 0),
                        Size = UDim2.new(0, 410, 0, 40),
                        Font = Enum.Font.SourceSans,
                        Text = '',
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        TextSize = 14
                    }, {
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 5),
                            Name = Name..'ToggleButtonCorner'
                        })
                    })
                })

                local ToggleHolder = Section[Name..'ToggleHolder']
                local ToggleButton = ToggleHolder[Name..'ToggleButton']
                local Toggle = ToggleHolder[Name..'Toggle']
                local Circle = Toggle[Name..'ToggleCircle']

                UpdateSectionSize()

                Config[Name] = Toggled

                if not ImprovePerformance then
                    task.spawn(function()
                        while task.wait() do
                            if ChangeTheme then
                                if not BreakAllLoops then
                                    if not Hovering then
                                        Utility:Tween(ToggleHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    end
                                    Utility:Tween(ToggleHolder[Name..'ToggleHolderStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                    Utility:Tween(ToggleHolder[Name..'ToggleText'], {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(ToggleHolder[Name..'ToggleText'], {TextColor3 = Theme.PrimaryTextColor}, 0.25)
                                    Utility:Tween(ToggleHolder[Name..'Toggle'][Name..'ToggleCircle'], {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(ToggleHolder[Name..'Toggle'][Name..'ToggleStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                    Utility:Tween(ToggleHolder[Name..'ToggleButton'], {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                else
                                    break
                                end
                            end
                        end
                    end)
                end

                if not ImprovePerformance then
                    task.spawn(function()
                        while task.wait() do
                            if ChangeTheme then
                                if not BreakAllLoops then
                                    if Toggled == true then
                                        Utility:Tween(Toggle, {BackgroundColor3 = ToggleColor}, 0.25)
                                    else
                                        Utility:Tween(ToggleHolder[Name..'Toggle'], {BackgroundColor3 = Theme.SecondaryElementColor}, 0.25)
                                    end
                                else
                                    break
                                end
                            end
                        end
                    end)
                end

                if Default then
                    task.spawn(function()                    
                        pcall(Callback, Default)
                    end)
                    Utility:Tween(Toggle, {BackgroundColor3 = ToggleColor}, 0.25)
                    Utility:Tween(Circle, {Position = UDim2.new(0, 30, 0, 5)}, 0.25)
                end

                ToggleButton.MouseButton1Down:Connect(function()
                    if not Debounce then
                        Toggled = not Toggled
                        task.spawn(function()                    
                            pcall(Callback, Toggled)
                        end)
                        Debounce = true
                        if Toggled then
                            Utility:Tween(Toggle, {BackgroundColor3 = ToggleColor}, 0.25)
                            Utility:Tween(Circle, {Position = UDim2.new(0, 30, 0, 5)}, 0.25)
                        else
                            Utility:Tween(Toggle, {BackgroundColor3 = Theme.SecondaryElementColor}, 0.25)
                            Utility:Tween(Circle, {Position = UDim2.new(0, 5, 0, 5)}, 0.25)
                        end
                        task.wait(DebounceAmount)
                        Debounce = false
                    end
                end)

                ToggleHolder.MouseEnter:Connect(function()
                    Hovering = true
                    Utility:Tween(ToggleHolder, {BackgroundColor3 = Utility:Lighten(Theme.PrimaryElementColor)}, 0.5)
                end)

                ToggleHolder.MouseLeave:Connect(function()
                    Utility:Tween(ToggleHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.5)
                    Hovering = false
                end)

                function ToggleFunctions:Set(Value)
                    Toggled = Value
                    task.spawn(function()
                        pcall(Callback, Toggled)
                    end)
                    if Toggled then
                        Utility:Tween(Toggle, {BackgroundColor3 = ToggleColor}, 0.25)
                        Utility:Tween(Circle, {Position = UDim2.new(0, 30, 0, 5)}, 0.25)
                    else
                        Utility:Tween(Toggle, {BackgroundColor3 = Theme.SecondaryElementColor}, 0.25)
                        Utility:Tween(Circle, {Position = UDim2.new(0, 5, 0, 5)}, 0.25)
                    end
                end
                ConfigUpdates[Name] = ToggleFunctions
                return ToggleFunctions
            end

            function Elements:CreateDropdown(Name, List, Default, DebounceAmount, Callback)
                local Name = Name or 'Dropdown'
                local List = List or {}
                local Callback = Callback or function() end
                local DebounceAmount = DebounceAmount or 0.25
                local Default = Default or nil
                local SelectedItem = 'None'
                local Opened = false
                local Debounce = false
                local DropdownFunctions = {}
                local Hovering = false

                Utility:Create('Frame', {
                    Name = Name..'DropdownHolder',
                    Parent = Section,
                    BackgroundColor3 = Theme.PrimaryElementColor,
                    Size = UDim2.new(0, 410, 0, 40)
                }, {
                    Utility:Create('UICorner', {
                        CornerRadius = UDim.new(0, 5),
                        Name = Name..'DropdownHolderCorner'
                    }),
                    Utility:Create('UIStroke', {
                        Name = Name..'DropdownHolderStroke',
                        ApplyStrokeMode = 'Contextual',
                        Color = Theme.UIStrokeColor,
                        LineJoinMode = 'Round',
                        Thickness = 1
                    }),
                    Utility:Create('TextLabel', {
                        Name = Name..'DropdownText',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, 5),
                        Size = UDim2.new(0, 200, 0, 30),
                        Font = Enum.Font.Gotham,
                        Text = Name,
                        TextColor3 = Theme.PrimaryTextColor,
                        TextSize = 16,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }, {
                        Utility:Create('UIPadding', {
                            Name = Name..'DropdownTextPadding',
                            PaddingLeft = UDim.new(0, 7)
                        })
                    }),
                    Utility:Create('ImageLabel', {
                        Name = Name..'DropdownIcon',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 377, 0, 8),
                        Rotation = 270,
                        Size = UDim2.new(0, 25, 0, 25),
                        Image = 'rbxassetid://3926305904',
                        ImageColor3 = Theme.SecondaryTextColor,
                        ImageRectOffset = Vector2.new(964, 284),
                        ImageRectSize = Vector2.new(36, 36)
                    }),
                    Utility:Create('TextLabel', {
                        Name = Name..'DropdownSelectedText',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 199, 0, 8),
                        Size = UDim2.new(0, 176, 0, 25),
                        Font = Enum.Font.Gotham,
                        Text = SelectedItem,
                        TextColor3 = Theme.SecondaryTextColor,
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Right
                    }, {
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 5),
                            Name = Name..'DropdownSelectedTextCorner'
                        }),
                        Utility:Create('UIPadding', {
                            Name = Name..'DropdownSelectedTextPadding',
                            PaddingRight = UDim.new(0, 7)
                        })
                    }),
                    Utility:Create('ScrollingFrame', {
                        Name = Name..'DropList',
                        Active = true,
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 0, 1, 0),
                        Size = UDim2.new(0, 410, 0, 30),
                        Visible = false,
                        ScrollBarImageColor3 = Theme.ScrollBarColor,
                        ScrollBarThickness = 3
                    }, {
                        Utility:Create('UIStroke', {
                            Name = Name..'DropListStroke',
                            ApplyStrokeMode = 'Contextual',
                            Color = Theme.UIStrokeColor,
                            LineJoinMode = 'Round',
                            Thickness = 1
                        }),
                        Utility:Create('UIListLayout', {
                            Name = Name..'DropListLayout',
                            SortOrder = Enum.SortOrder.LayoutOrder
                        }),
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 5),
                            Name = Name..'DropdownListCorner'
                        })
                    }),
                    Utility:Create('TextButton', {
                        Name = Name..'DropdownButton',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 0, 0, 0),
                        Size = UDim2.new(0, 410, 0, 40),
                        Font = Enum.Font.SourceSans,
                        Text = '',
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        TextSize = 14
                    }, {
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 5),
                            Name = Name..'DropdownButtonCorner'
                        })
                    })
                })
                Utility:Create('Frame', {
                    Name = Name..'DropdownFiller',
                    Parent = Section,
                    Visible = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 410, 0, 0)
                })

                local DropdownHolder = Section[Name..'DropdownHolder']
                local DropList = DropdownHolder[Name..'DropList']
                local DropdownButton = DropdownHolder[Name..'DropdownButton']
                local DropdownIcon = DropdownHolder[Name..'DropdownIcon']
                local DropdownSelectedText = DropdownHolder[Name..'DropdownSelectedText']
                local DropListLayout = DropList[Name..'DropListLayout']
                local DropdownFiller = Section[Name..'DropdownFiller']

                UpdateSectionSize()

                Config[Name] = Default

                if not ImprovePerformance then
                    task.spawn(function()
                        while task.wait() do
                            if ChangeTheme then
                                if not BreakAllLoops then
                                    if not Hovering then
                                        Utility:Tween(DropdownHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    end
                                    Utility:Tween(DropdownHolder[Name..'DropdownHolderStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                    Utility:Tween(DropdownHolder[Name..'DropdownText'], {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(DropdownHolder[Name..'DropdownText'], {TextColor3 = Theme.PrimaryTextColor}, 0.25)
                                    Utility:Tween(DropdownIcon, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(DropdownIcon, {ImageColor3 = Theme.SecondaryTextColor}, 0.25)
                                    Utility:Tween(DropdownSelectedText, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(DropdownSelectedText, {TextColor3 = Theme.SecondaryTextColor}, 0.25)
                                    Utility:Tween(DropList, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(DropList, {ScrollBarImageColor3 = Theme.ScrollBarColor}, 0.25)
                                    Utility:Tween(DropList[Name..'DropListStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                    Utility:Tween(DropdownButton, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                else
                                    break
                                end
                            end
                        end
                    end)
                end

                DropdownButton.MouseButton1Click:Connect(function()
                    task.wait(0.25)
                    if not Debounce then
                        if Opened then
                            Opened = false
                            Utility:Tween(DropdownFiller, {Size = UDim2.new(0, 410, 0, 0)}, 0.25)
                            Utility:Tween(DropList, {Size = UDim2.new(0, 410, 0, 0)}, 0.25)
                            Utility:Tween(DropdownIcon, {Rotation = 270}, 0.25)
                            if #List <= 5 then
                                Utility:Tween(Tab, {CanvasSize = Tab.CanvasSize - UDim2.new(0, 0, 0, DropListLayout.AbsoluteContentSize.Y)}, 0.25)
                                Utility:Tween(Section, {Size = Section.Size - UDim2.new(0, 0, 0, DropListLayout.AbsoluteContentSize.Y)}, 0.25)
                            else
                                Utility:Tween(Tab, {CanvasSize = Tab.CanvasSize - UDim2.new(0, 0, 0, 150)}, 0.25)
                                Utility:Tween(Section, {Size = Section.Size - UDim2.new(0, 0, 0, 150)}, 0.25)
                            end
                            Debounce = true
                            task.wait(DebounceAmount)
                            Debounce = false
                            DropList.Visible = false
                            DropdownFiller.Visible = false
                            
                        else
                            Opened = true
                            DropdownFiller.Visible = true
                            DropList.Visible = true
                            if #List <= 5 then
                                Utility:Tween(DropList, {Size = UDim2.new(0, 410, 0, DropListLayout.AbsoluteContentSize.Y)}, 0.25)
                                Utility:Tween(DropdownFiller, {Size = UDim2.new(0, 410, 0, DropListLayout.AbsoluteContentSize.Y - 6)}, 0.25)
                                Utility:Tween(DropList, {CanvasSize = UDim2.new(0, 400, 0, DropListLayout.AbsoluteContentSize.Y)}, 0.25)
                                Utility:Tween(Tab, {CanvasSize = Tab.CanvasSize + UDim2.new(0, 0, 0, DropListLayout.AbsoluteContentSize.Y)}, 0.25)
                                Utility:Tween(Section, {Size = Section.Size + UDim2.new(0, 0, 0, DropListLayout.AbsoluteContentSize.Y)}, 0.25)
                            else
                                Utility:Tween(DropList, {Size = UDim2.new(0, 410, 0, 150)}, 0.25)
                                Utility:Tween(DropList, {CanvasSize = UDim2.new(0, 400, 0, DropListLayout.AbsoluteContentSize.Y)}, 0.25)
                                Utility:Tween(DropdownFiller, {Size = UDim2.new(0, 410, 0, 144)}, 0.25)
                                Utility:Tween(Tab, {CanvasSize = Tab.CanvasSize + UDim2.new(0, 0, 0, 150)}, 0.25)
                                Utility:Tween(Section, {Size = Section.Size + UDim2.new(0, 0, 0, 150)}, 0.25)
                            end
                            Utility:Tween(DropdownIcon, {Rotation = 90}, 0.25)
                            Debounce = true
                            task.wait(DebounceAmount)
                            Debounce = false
                        end
                    end
                end)

                for _, Item in next, List do
                    Utility:Create('TextButton', {
                        Name = Item..'OptionButton',
                        Parent = DropList,
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BorderSizePixel = 0,
                        Size = UDim2.new(0, 410, 0, 30),
                        Font = Enum.Font.SourceSans,
                        TextColor3 = Theme.SecondaryTextColor,
                        TextSize = 16,
                        AutoButtonColor = false,
                        Text = Item,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }, {
                        Utility:Create('UIPadding', {
                            Name = Item..'OptionButtonPadding',
                            PaddingLeft = UDim.new(0, 7)
                        }),
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 5),
                            Name = Item..'OptionButtonCorner'
                        })
                    })

                    local OptionButton = DropList[Item..'OptionButton']

                    if not ImprovePerformance then
                        task.spawn(function()
                            while task.wait() do
                                if ChangeTheme then
                                    if not BreakAllLoops then
                                        if not Hovering then
                                            Utility:Tween(OptionButton, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                        end
                                        Utility:Tween(OptionButton, {TextColor3 = Theme.SecondaryTextColor}, 0.25)
                                    else
                                        break
                                    end
                                end
                            end
                        end)
                    end

                    OptionButton.MouseEnter:Connect(function()
                        Hovering = true
                        Utility:Tween(OptionButton, {BackgroundColor3 = Utility:Lighten(Theme.PrimaryElementColor)}, 0.5)
                    end)
    
                    OptionButton.MouseLeave:Connect(function()
                        Utility:Tween(OptionButton, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.5)
                        Hovering = false
                    end)

                    OptionButton.MouseButton1Click:Connect(function()
                        for _, Button in next, DropList:GetChildren() do
                            if Button:IsA('TextButton') then
                                Utility:Tween(Button, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                            end
                        end
                        Utility:Tween(OptionButton, {BackgroundColor3 = Utility:Lighten(Theme.PrimaryElementColor)}, 0.25)
                        DropdownSelectedText.Text = Item
                        Callback(Item)
                        Config[Name] = Item
                        Opened = false
                        if #List <= 5 then
                            Utility:Tween(Tab, {CanvasSize = Tab.CanvasSize - UDim2.new(0, 0, 0, DropListLayout.AbsoluteContentSize.Y)}, 0.25)
                            Utility:Tween(Section, {Size = Section.Size - UDim2.new(0, 0, 0, DropListLayout.AbsoluteContentSize.Y)}, 0.25)
                        else
                            Utility:Tween(Tab, {CanvasSize = Tab.CanvasSize - UDim2.new(0, 0, 0, 150)}, 0.25)
                            Utility:Tween(Section, {Size = Section.Size - UDim2.new(0, 0, 0, 150)}, 0.25)
                        end
                        Utility:Tween(DropdownFiller, {Size = UDim2.new(0, 410, 0, 0)}, 0.25)
                        Utility:Tween(DropList, {Size = UDim2.new(0, 410, 0, 0)}, 0.25)
                        Utility:Tween(DropdownIcon, {Rotation = 270}, 0.25)
                        task.wait(0.25)
                        DropList.Visible = false
                        DropdownFiller.Visible = false
                    end)
                end

                if Default ~= nil then
                    local Option = DropList[Default..'OptionButton']
                    Utility:Tween(Option, {BackgroundColor3 = Utility:Lighten(Theme.PrimaryElementColor)}, 0.25)
                    DropdownSelectedText.Text = Default
                    Callback(Default)
                end

                DropdownHolder.MouseEnter:Connect(function()
                    Hovering = true
                    Utility:Tween(DropdownHolder, {BackgroundColor3 = Utility:Lighten(Theme.PrimaryElementColor)}, 0.5)
                end)

                DropdownHolder.MouseLeave:Connect(function()
                    Utility:Tween(DropdownHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.5)
                    Hovering = false
                end)

                function DropdownFunctions:Set(Value)
                    SelectedItem = tostring(Value)
                    DropdownSelectedText = tostring(Value)
                    Callback(Value)
                end
                ConfigUpdates[Name] = DropdownFunctions

                function DropdownFunctions:UpdateDropdown(NewList)
                    task.wait(0.25)
                    local NewList = NewList or {}
                    if Opened then
                        Opened = false
                        Utility:Tween(DropdownFiller, {Size = UDim2.new(0, 410, 0, 0)}, 0.25)
                        Utility:Tween(DropList, {Size = UDim2.new(0, 410, 0, 0)}, 0.25)
                        Utility:Tween(DropdownIcon, {Rotation = 270}, 0.25)
                        if #List <= 5 then
                            Utility:Tween(Tab, {CanvasSize = Tab.CanvasSize - UDim2.new(0, 0, 0, DropListLayout.AbsoluteContentSize.Y)}, 0.25)
                            Utility:Tween(Section, {Size = Section.Size - UDim2.new(0, 0, 0, DropListLayout.AbsoluteContentSize.Y)}, 0.25)
                        else
                            Utility:Tween(Tab, {CanvasSize = Tab.CanvasSize - UDim2.new(0, 0, 0, 150)}, 0.25)
                            Utility:Tween(Section, {Size = Section.Size - UDim2.new(0, 0, 0, 150)}, 0.25)
                        end
                        DropList.Visible = false
                        DropdownFiller.Visible = false
                    end
                    task.wait(0.25)
                    for _, Item in next, DropList:GetChildren() do
                        if Item:IsA('TextButton') then
                            Item:Destroy()
                        end
                    end
                    List = NewList

                    if Opened then
                        Opened = false
                        Utility:Tween(DropdownFiller, {Size = UDim2.new(0, 410, 0, 0)}, 0.25)
                        Utility:Tween(DropList, {Size = UDim2.new(0, 410, 0, 0)}, 0.25)
                        Utility:Tween(DropdownIcon, {Rotation = 270}, 0.25)
                        if #List <= 5 then
                            Utility:Tween(Tab, {CanvasSize = Tab.CanvasSize - UDim2.new(0, 0, 0, DropListLayout.AbsoluteContentSize.Y + 150)}, 0.25)
                            Utility:Tween(Section, {Size = Section.Size - UDim2.new(0, 0, 0, DropListLayout.AbsoluteContentSize.Y + 150)}, 0.25)
                        else
                            Utility:Tween(Tab, {CanvasSize = Tab.CanvasSize - UDim2.new(0, 0, 0, 90)}, 0.25)
                            Utility:Tween(Section, {Size = Section.Size - UDim2.new(0, 0, 0, 90)}, 0.25)
                        end
                        Debounce = true
                        task.wait(DebounceAmount)
                        Debounce = false
                        DropList.Visible = false
                        DropdownFiller.Visible = false
                    end

                    for _, Item in next, NewList do
                        Utility:Create('TextButton', {
                            Name = Item..'OptionButton',
                            Parent = DropList,
                            BackgroundColor3 = Theme.PrimaryElementColor,
                            BorderSizePixel = 0,
                            Size = UDim2.new(0, 410, 0, 30),
                            Font = Enum.Font.SourceSans,
                            TextColor3 = Theme.SecondaryTextColor,
                            TextSize = 16,
                            AutoButtonColor = false,
                            Text = Item,
                            TextXAlignment = Enum.TextXAlignment.Left
                        }, {
                            Utility:Create('UIPadding', {
                                Name = Item..'OptionButtonPadding',
                                PaddingLeft = UDim.new(0, 7)
                            }),
                            Utility:Create('UICorner', {
                                CornerRadius = UDim.new(0, 5),
                                Name = Item..'OptionButtonCorner'
                            })
                        })

                        UpdateSectionSize()

                        if #List == 0 then
                            DropdownSelectedText.Text = 'None'
                            SelectedItem = 'None'
                        end
    
                        local OptionButton = DropList[Item..'OptionButton']

                        if not ImprovePerformance then
                            task.spawn(function()
                                while task.wait() do
                                    if ChangeTheme then
                                        if not BreakAllLoops then
                                            if not Hovering then
                                                Utility:Tween(OptionButton, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                            end
                                            Utility:Tween(OptionButton, {TextColor3 = Theme.SecondaryTextColor}, 0.25)
                                        else
                                            break
                                        end
                                    end
                                end
                            end)
                        end

                        OptionButton.MouseEnter:Connect(function()
                            Hovering = true
                            Utility:Tween(OptionButton, {BackgroundColor3 = Utility:Lighten(Theme.PrimaryElementColor)}, 0.5)
                        end)
        
                        OptionButton.MouseLeave:Connect(function()
                            Utility:Tween(OptionButton, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.5)
                            Hovering = false
                        end)
    
                        OptionButton.MouseButton1Click:Connect(function()
                            for _, Button in next, DropList:GetChildren() do
                                if Button:IsA('TextButton') then
                                    Utility:Tween(Button, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                end
                            end
                            Utility:Tween(OptionButton, {BackgroundColor3 = Utility:Lighten(Theme.PrimaryElementColor)}, 0.25)
                            DropdownSelectedText.Text = tostring(Item)
                            Callback(Item)
                            Config[Name] = Item
                            task.wait(0.5)
                            Opened = false
                            if #NewList <= 5 then
                                Utility:Tween(Tab, {CanvasSize = Tab.CanvasSize - UDim2.new(0, 0, 0, DropListLayout.AbsoluteContentSize.Y)}, 0.25)
                                Utility:Tween(Section, {Size = Section.Size - UDim2.new(0, 0, 0, DropListLayout.AbsoluteContentSize.Y)}, 0.25)
                            else
                                Utility:Tween(Tab, {CanvasSize = Tab.CanvasSize - UDim2.new(0, 0, 0, 150)}, 0.25)
                                Utility:Tween(Section, {Size = Section.Size - UDim2.new(0, 0, 0, 150)}, 0.25)
                            end
                            Utility:Tween(DropdownFiller, {Size = UDim2.new(0, 410, 0, 0)}, 0.25)
                            Utility:Tween(DropList, {Size = UDim2.new(0, 410, 0, 0)}, 0.25)
                            Utility:Tween(DropdownIcon, {Rotation = 270}, 0.25)
                            task.wait(0.25)
                            DropList.Visible = false
                            DropdownFiller.Visible = false
                        end)
                    end
                end
                return DropdownFunctions
            end

            function Elements:CreateColorpicker(Name, DefaultColor, DebounceAmount, Callback, ...)
                local Name = Name or 'Colorpicker'
                local xArgs = ...
                local Args = xArgs or {}
                local Callback = Callback or function() end
                local DebounceAmount = DebounceAmount or 0.25
                local DefaultColor = DefaultColor or Color3.fromRGB(0, 125, 255)
                local Debounce = false
                local Opened = false
                local H, S, V = Color3.toHSV(DefaultColor)
                local ColorpickerFunctions = {}
                local Hovering = false

                Utility:Create('Frame', {
                    Name = Name..'ColorpickerHolder',
                    Parent = Section,
                    BackgroundColor3 = Theme.PrimaryElementColor,
                    Size = UDim2.new(0, 410, 0, 40)
                }, {
                    Utility:Create('UICorner', {
                        CornerRadius = UDim.new(0, 5),
                        Name = Name..'ColorpickerHolderCorner'
                    }),
                    Utility:Create('UIStroke', {
                        Name = Name..'ColorpickerHolderStroke',
                        ApplyStrokeMode = 'Contextual',
                        Color = Theme.UIStrokeColor,
                        LineJoinMode = 'Round',
                        Thickness = 1
                    }),
                    Utility:Create('TextLabel', {
                        Name = Name..'ColorpickerText',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, 5),
                        Size = UDim2.new(0, 200, 0, 30),
                        Font = Enum.Font.Gotham,
                        Text = Name,
                        TextColor3 = Theme.PrimaryTextColor,
                        TextSize = 16,
                        TextXAlignment = Enum.TextXAlignment.Left,
                    }, {
                        Utility:Create('UIPadding', {
                            Name = Name..'ColorpickerTextPadding',
                            PaddingLeft = UDim.new(0, 7)
                        })
                    }),
                    Utility:Create('TextButton', {
                        Name = Name..'ColorpickerButton',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 410, 0, 40),
                        ZIndex = 2,
                        Font = Enum.Font.Gotham,
                        Text = '',
                        TextColor3 = Theme.SecondaryTextColor,
                        TextSize = 14
                    }, {
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 5),
                            Name = Name..'ColorpickerButtonCorner'
                        })
                    }),
                    Utility:Create('Frame', {
                        Name = Name..'ColorpickerDropdown',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 0, 0, 40),
                        Size = UDim2.new(0, 410, 0, 114),
                        Visible = false
                    }, {
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 5),
                            Name = Name..'ColorpickerDropdownCorner'
                        }),
                        Utility:Create('UIStroke', {
                            Name = Name..'ColorpickerDropdownStroke',
                            ApplyStrokeMode = 'Contextual',
                            Color = Theme.UIStrokeColor,
                            LineJoinMode = 'Round',
                            Thickness = 1
                        }),
                        Utility:Create('ImageButton', {
                            Name = Name..'RGBPicker',
                            BackgroundColor3 = Theme.PrimaryElementColor,
                            Position = UDim2.new(0, 38, 0, 7),
                            Size = UDim2.new(0, 300, 0, 100),
                            Image = 'rbxassetid://6523286724'
                        }, {
                            Utility:Create('UICorner', {
                                CornerRadius = UDim.new(0, 5),
                                Name = Name..'RGBPickerCorner'
                            }),
                            Utility:Create('ImageLabel', {
                                Name = Name..'RGBPickerCircle',
                                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                                BackgroundTransparency = 1,
                                Position = UDim2.new(0, 293, 0, -7),
                                Size = UDim2.new(0, 14, 0, 14),
                                Image = 'rbxassetid://3926309567',
                                ImageColor3 = Color3.fromRGB(0, 0, 0),
                                ImageRectOffset = Vector2.new(628, 420),
                                ImageRectSize = Vector2.new(48, 48)
                            }),
                            Utility:Create('UIStroke', {
                                Name = Name..'RGBPickerStroke',
                                ApplyStrokeMode = 'Contextual',
                                Color = Theme.UIStrokeColor,
                                LineJoinMode = 'Round',
                                Thickness = 1
                            }),
                        }),
                        Utility:Create('ImageButton', {
                            Name = Name..'DarknessPicker',
                            BackgroundColor3 = Theme.PrimaryElementColor,
                            Position = UDim2.new(0, 346, 0, 7),
                            Size = UDim2.new(0, 25, 0, 100),
                            Image = 'rbxassetid://6523291212'
                        }, {
                            Utility:Create('UICorner', {
                                CornerRadius = UDim.new(0, 5),
                                Name = Name..'DarknessPickerCorner'
                            }),
                            Utility:Create('ImageLabel', {
                                Name = Name..'DarknessPickerCircle',
                                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                                BackgroundTransparency = 1,
                                AnchorPoint = Vector2.new(0.5, 0),
                                Position = UDim2.new(0.5, 0, 0, -6),
                                Size = UDim2.new(0, 14, 0, 14),
                                Image = 'rbxassetid://3926309567',
                                ImageColor3 = Color3.fromRGB(0, 0, 0),
                                ImageRectOffset = Vector2.new(628, 420),
                                ImageRectSize = Vector2.new(48, 48)
                            }),
                            Utility:Create('UIStroke', {
                                Name = Name..'DarknessPickerStroke',
                                ApplyStrokeMode = 'Contextual',
                                Color = Theme.UIStrokeColor,
                                LineJoinMode = 'Round',
                                Thickness = 1
                            }),
                        })
                    }),
                    Utility:Create('Frame', {
                        Name = Name..'ColorpickerPreview',
                        Position = UDim2.new(0, 377, 0, 8),
                        Size = UDim2.new(0, 25, 0, 25)
                    }, {
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 5),
                            Name = Name..'ColorpickerPreviewCorner'
                        })
                    })
                })
                Utility:Create('Frame', {
                    Name = Name..'ColorpickerFiller',
                    Parent = Section,
                    Visible = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 410, 0, 0)
                })

                local ColorpickerHolder = Section[Name..'ColorpickerHolder']
                local ColorpickerButton = ColorpickerHolder[Name..'ColorpickerButton']
                local ColorpickerDropdown = ColorpickerHolder[Name..'ColorpickerDropdown']
                local RGBPicker = ColorpickerDropdown[Name..'RGBPicker']
                local RGBPickerCircle = RGBPicker[Name..'RGBPickerCircle']
                local DarknessPicker = ColorpickerDropdown[Name..'DarknessPicker']
                local DarknessPickerCircle = DarknessPicker[Name..'DarknessPickerCircle']
                local ColorpickerPreview = ColorpickerHolder[Name..'ColorpickerPreview']
                local ColorpickerFiller = Section[Name..'ColorpickerFiller']
                
                UpdateSectionSize()

                if not Args[1] == true then
                    Config[Name] = Utility:SplitColor(DefaultColor)
                end

                if not ImprovePerformance then
                    task.spawn(function()
                        while task.wait() do
                            if ChangeTheme then
                                if not BreakAllLoops then
                                    if not Hovering then
                                        Utility:Tween(ColorpickerHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    end
                                    Utility:Tween(ColorpickerHolder[Name..'ColorpickerHolderStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                    Utility:Tween(ColorpickerHolder[Name..'ColorpickerText'], {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(ColorpickerHolder[Name..'ColorpickerText'], {TextColor3 = Theme.PrimaryTextColor}, 0.25)
                                    Utility:Tween(ColorpickerButton, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(ColorpickerButton, {TextColor3 = Theme.SecondaryTextColor}, 0.25)
                                    Utility:Tween(ColorpickerDropdown, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(ColorpickerDropdown[Name..'ColorpickerDropdownStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                    Utility:Tween(RGBPicker, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(RGBPicker[Name..'RGBPickerStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                    Utility:Tween(DarknessPicker, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(DarknessPicker[Name..'DarknessPickerStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                else
                                    break
                                end
                            end
                        end
                    end)
                end

                if DefaultColor ~= nil then
                    Color = {H, S, V}
                    local FinalColor = Color3.fromHSV(Color[1], Color[2], Color[3])
                    ColorpickerPreview.BackgroundColor3 = FinalColor
                    Callback(FinalColor)
                end

                ColorpickerButton.MouseButton1Click:Connect(function()
                    if not Debounce then
                        if Opened then
                            Opened = false
                            Utility:Tween(ColorpickerFiller, {Size = UDim2.new(0, 410, 0, 0)}, 0.25)
                            Utility:Tween(RGBPicker, {Size = UDim2.new(0, 300, 0, 0)}, 0.25)
                            Utility:Tween(DarknessPicker, {Size = UDim2.new(0, 25, 0, 0)}, 0.25)
                            Utility:Tween(ColorpickerDropdown, {Size = UDim2.new(0, 410, 0, 0)}, 0.25)
                            Utility:Tween(Tab, {CanvasSize = Tab.CanvasSize - UDim2.new(0, 0, 0, 114)}, 0.25)
                            Utility:Tween(Section, {Size = Section.Size - UDim2.new(0, 0, 0, 114)}, 0.25)
                            UpdateSectionSize()
                            Debounce = true
                            task.wait(DebounceAmount)
                            Debounce = false
                            ColorpickerDropdown.Visible = false
                            ColorpickerFiller.Visible = false
                        else
                            Opened = true
                            ColorpickerFiller.Visible = true
                            ColorpickerDropdown.Visible = true
                            Utility:Tween(Tab, {CanvasSize = Tab.CanvasSize + UDim2.new(0, 0, 0, 114)}, 0.25)
                            Utility:Tween(Section, {Size = Section.Size + UDim2.new(0, 0, 0, 114)}, 0.25)
                            Utility:Tween(ColorpickerDropdown, {Size = UDim2.new(0, 410, 0, 114)}, 0.25)
                            Utility:Tween(RGBPicker, {Size = UDim2.new(0, 300, 0, 100)}, 0.25)
                            Utility:Tween(DarknessPicker, {Size = UDim2.new(0, 25, 0, 100)}, 0.25)
                            Utility:Tween(ColorpickerFiller, {Size = UDim2.new(0, 410, 0, 110)}, 0.25)
                            UpdateSectionSize()
                            Debounce = true
                            task.wait(DebounceAmount)
                            Debounce = false
                        end
                    end
                end)

                ColorpickerHolder.MouseEnter:Connect(function()
                    Hovering = true
                    Utility:Tween(ColorpickerHolder, {BackgroundColor3 = Utility:Lighten(Theme.PrimaryElementColor)}, 0.5)
                end)

                ColorpickerHolder.MouseLeave:Connect(function()
                    Utility:Tween(ColorpickerHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.5)
                    Hovering = false
                end)

                local Mouse = Players.LocalPlayer:GetMouse()
                local Color = {1, 1, 1}
                local RGBPicked = false
                local DarknessPicked = false

                -- // Based off xHeptc's functions | https://v3rmillion.net/member.php?action=profile&uid=1347047
                    
                Mouse.Move:Connect(function()
                    if RGBPicked then
                        local MouseXPosition = Mouse.X - RGBPicker.AbsolutePosition.X
                        local MouseYPosition = Mouse.Y - RGBPicker.AbsolutePosition.Y

                        local CircleXSize = RGBPickerCircle.AbsoluteSize.X / 2
                        local CircleYSize = RGBPickerCircle.AbsoluteSize.Y / 2

                        local MaximumXPosition = RGBPicker.AbsoluteSize.X
                        local MaximumYPosition = RGBPicker.AbsoluteSize.Y

                        if MouseXPosition < 0 then MouseXPosition = 0 end
                        if MouseYPosition < 0 then MouseYPosition = 0 end

                        if MouseXPosition > MaximumXPosition then MouseXPosition = MaximumXPosition end
                        if MouseYPosition > MaximumYPosition then MouseYPosition = MaximumYPosition end

                        MouseXPosition = MouseXPosition / MaximumXPosition
                        MouseYPosition = MouseYPosition / MaximumYPosition

                        RGBPickerCircle.Position = UDim2.new(MouseXPosition, -CircleXSize, MouseYPosition, -CircleYSize)

                        Color = {1 - MouseXPosition, 1 - tostring(MouseYPosition), Color[3]}

                        local HSVColor = Color3.fromHSV(Color[1], Color[2], Color[3])

                        ColorpickerPreview.BackgroundColor3 = HSVColor

                        Callback(HSVColor)

                        if not Args[1] == true then
                            Config[Name] = Utility:SplitColor(HSVColor)
                        end

                    elseif DarknessPicked then
                        local MouseYPosition = Mouse.Y - DarknessPicker.AbsolutePosition.Y

                        local CircleYSize = DarknessPickerCircle.AbsoluteSize.Y / 2

                        local MaximumYPosition = DarknessPicker.AbsoluteSize.Y

                        if MouseYPosition < 0 then MouseYPosition = 0 end
                        if MouseYPosition > MaximumYPosition then MouseYPosition = MaximumYPosition end

                        MouseYPosition = MouseYPosition / MaximumYPosition

                        DarknessPickerCircle.Position = UDim2.new(0.5, 0, MouseYPosition, -CircleYSize)

                        DarknessPickerCircle.ImageColor3 = Color3.fromHSV(0, 0, MouseYPosition)

                        Color = {Color[1], Color[2], 1 - MouseYPosition}

                        local HSVColor = Color3.fromHSV(Color[1], Color[2], Color[3])

                        ColorpickerPreview.BackgroundColor3 = HSVColor

                        Callback(HSVColor)

                        if not Args[1] == true then
                            Config[Name] = Utility:SplitColor(HSVColor)
                        end
                    end 
                end)

                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if DarknessPicked then 
                            DarknessPicked = false 
                        elseif RGBPicked then
                            RGBPicked = false
                        end
                    end
                end)
                -- // End

                RGBPicker.MouseButton1Down:Connect(function()
                    RGBPicked = true
                end)

                DarknessPicker.MouseButton1Down:Connect(function()
                    DarknessPicked = true
                end)
                
                function ColorpickerFunctions:Set(Value)
                    Color = Color3.fromRGB(Value.R, Value.G, Value.B)
                    ColorpickerPreview.BackgroundColor3 = Color
                    Callback(Color)
                end
                ConfigUpdates[Name] = ColorpickerFunctions
                return ColorpickerFunctions
            end

            function Elements:CreateImage(Name, URL, ImageSize)
                local Name = Name or 'Image'
                local URL = URL or 'rbxassetid://10579405264'
                local ImageSize = ImageSize or UDim2.new(0, 100, 0, 100)
                local ImageFunctions = {}
                local Debounce = false
                local DebounceAmount = 0.25
                local Opened = false
                local Debounce2 = false
                local Debounce2Amount = 0.5
                local Hovering = false

                Utility:Create('Frame', {
                    Name = Name..'ImageHolder',
                    Parent = Section,
                    BackgroundColor3 = Theme.PrimaryElementColor,
                    Size = UDim2.new(0, 410, 0, 40)
                }, {
                    Utility:Create('UICorner', {
                        CornerRadius = UDim.new(0, 5),
                        Name = Name..'ImageHolderCorner'
                    }),
                    Utility:Create('UIStroke', {
                        Name = Name..'ImageStroke',
                        ApplyStrokeMode = 'Contextual',
                        Color = Theme.UIStrokeColor,
                        LineJoinMode = 'Round',
                        Thickness = 1
                    }),
                    Utility:Create('TextLabel', {
                        Name = Name..'ImageText',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, 5),
                        Size = UDim2.new(0, 200, 0, 30),
                        Font = Enum.Font.Gotham,
                        Text = Name,
                        TextColor3 = Theme.PrimaryTextColor,
                        TextSize = 16,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }, {
                        Utility:Create('UIPadding', {
                            Name = Name..'ImageTextPadding',
                            PaddingLeft = UDim.new(0, 7)
                        })
                    }),
                    Utility:Create('ImageLabel', {
                        Name = Name..'ImageIcon',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 377, 0, 8),
                        Size = UDim2.new(0, 25, 0, 25),
                        Image = 'rbxassetid://3926305904',
                        ImageColor3 = Theme.SecondaryTextColor,
                        ImageRectOffset = Vector2.new(764, 124),
                        ImageRectSize = Vector2.new(36, 36)
                    }),
                    Utility:Create('ScrollingFrame', {
                        Name = Name..'ImageDropdown',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 0, 1, 0),
                        Size = UDim2.new(0, 410, 0, 30),
                        ClipsDescendants = true,
                        Visible = false,
                        ScrollBarImageColor3 = Theme.ScrollBarColor,
                        ScrollBarThickness = 3,
                        Active = true
                    }, {
                        Utility:Create('UIStroke', {
                            Name = Name..'ImageDropdownStroke',
                            ApplyStrokeMode = 'Contextual',
                            Color = Theme.UIStrokeColor,
                            LineJoinMode = 'Round',
                            Thickness = 1
                        }),
                        Utility:Create('UIListLayout', {
                            Name = Name..'ImageDropdownListLayout',
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            HorizontalAlignment = 'Center',
                            VerticalAlignment = 'Center'
                        }),
                        Utility:Create('ImageLabel', {
                            Name = Name..'Image',
                            BackgroundColor3 = Theme.PrimaryElementColor,
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            Image = URL,
                            ScaleType = 'Fit'
                        })
                    }),
                    Utility:Create('TextButton', {
                        Name = Name..'ImageButton',
                        BackgroundColor3 = Theme.PrimaryElementColor,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 0, 0, 0),
                        Size = UDim2.new(0, 410, 0, 40),
                        Font = Enum.Font.SourceSans,
                        Text = '',
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        TextSize = 14
                    }, {
                        Utility:Create('UICorner', {
                            CornerRadius = UDim.new(0, 5),
                            Name = Name..'ImageButtonCorner'
                        })
                    })
                })
                Utility:Create('Frame', {
                    Name = Name..'ImageFiller',
                    Parent = Section,
                    Visible = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 410, 0, 0)
                })


                local ImageHolder = Section[Name..'ImageHolder']
                local ImageIcon = ImageHolder[Name..'ImageIcon']
                local ImageDropdown = ImageHolder[Name..'ImageDropdown']
                local Image = ImageDropdown[Name..'Image']
                local Button = ImageHolder[Name..'ImageButton']
                local ImageFiller = Section[Name..'ImageFiller']
                local ImageDropdownListLayout = ImageDropdown[Name..'ImageDropdownListLayout']

                UpdateSectionSize()

                if not ImprovePerformance then
                    task.spawn(function()
                        while task.wait() do
                            if ChangeTheme then
                                if not BreakAllLoops then
                                    if not Hovering then
                                        Utility:Tween(ImageHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    end
                                    Utility:Tween(ImageHolder[Name..'ImageStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                    Utility:Tween(ImageHolder[Name..'ImageText'], {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(ImageHolder[Name..'ImageText'], {TextColor3 = Theme.PrimaryTextColor}, 0.25)
                                    Utility:Tween(ImageIcon, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(ImageIcon, {ImageColor3 = Theme.SecondaryTextColor}, 0.25)
                                    Utility:Tween(ImageDropdown, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(ImageDropdown, {ScrollBarImageColor3 = Theme.ScrollBarColor}, 0.25)
                                    Utility:Tween(ImageDropdown[Name..'ImageDropdownStroke'], {Color = Theme.UIStrokeColor}, 0.25)
                                    Utility:Tween(Image, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                    Utility:Tween(Button, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.25)
                                else
                                    break
                                end
                            end
                        end
                    end)
                end

                local function UpdateImageCanvas()
                    local ContentSize = ImageDropdownListLayout.AbsoluteContentSize

                    ImageDropdown.CanvasSize = UDim2.new(0, ContentSize.X, 0, ContentSize.Y)
                end

                UpdateImageCanvas()

                Button.MouseButton1Click:Connect(function()
                    if not Debounce then
                        if Opened then
                            Opened = false
                            Utility:Tween(ImageFiller, {Size = UDim2.new(0, 410, 0, 0)}, 0.25)
                            Utility:Tween(ImageDropdown, {Size = UDim2.new(0, 410, 0, 0)}, 0.25)
                            Utility:Tween(ImageIcon, {ImageColor3 = Theme.SecondaryTextColor}, 0.25)
                            Utility:Tween(Tab, {CanvasSize = Tab.CanvasSize - UDim2.new(0, 400, 0, ImageSize.Y.Offset + 10)}, 0.25)
                            Utility:Tween(Section, {Size = Section.Size - UDim2.new(0, 400, 0, ImageSize.Y.Offset + 10)}, 0.25)
                            Utility:Tween(Image, {Size = UDim2.new(0, 410, 0, 0)}, 0.25)
                            UpdateImageCanvas()
                            UpdateSectionSize()
                            Debounce = true
                            task.wait(DebounceAmount)
                            Debounce = false
                            ImageDropdown.Visible = false
                            ImageFiller.Visible = false
                        else
                            Opened = true
                            ImageFiller.Visible = true
                            ImageDropdown.Visible = true
                            Utility:Tween(ImageDropdown, {Size = UDim2.new(0, 410, 0, ImageSize.Y.Offset + 10)}, 0.25)
                            Utility:Tween(ImageFiller, {Size = UDim2.new(0, 410, 0, ImageSize.Y.Offset + 10 - 6)}, 0.25)
                            Utility:Tween(Tab, {CanvasSize = Tab.CanvasSize + UDim2.new(0, 0, 0, ImageSize.Y.Offset + 10)}, 0.25)
                            Utility:Tween(Section, {Size = Section.Size + UDim2.new(0, 0, 0, ImageSize.Y.Offset + 10)}, 0.25)
                            Utility:Tween(Image, {Size = ImageSize}, 0.25)
                            UpdateImageCanvas()
                            UpdateSectionSize()
                            Utility:Tween(ImageIcon, {ImageColor3 = Theme.PrimaryTextColor}, 0.25)
                            Debounce = true
                            task.wait(DebounceAmount)
                            Debounce = false
                        end
                    end
                end)

                Image.InputBegan:Connect(function(Input)
                    if not Debounce2 then
                        task.spawn(function()
                            Debounce2 = true
                            task.wait(Debounce2Amount)
                            Debounce2 = false
                        end)
                        UpdateImageCanvas()
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Utility:Tween(Image, {Size = UDim2.new(0, Image.Size.X.Offset * 2, 0, Image.Size.Y.Offset * 2)}, 0.25)
                            UpdateImageCanvas()
                        elseif Input.UserInputType == Enum.UserInputType.MouseButton2 and Image.Size ~= ImageSize then
                            Utility:Tween(Image, {Size = UDim2.new(0, Image.Size.X.Offset / 2, 0, Image.Size.Y.Offset / 2)}, 0.25)
                            UpdateImageCanvas()
                        end
                    end
                end)

                Image.Changed:Connect(function(Property)
                    if Property == 'Size' then
                        if Image.Size == ImageSize then
                            Utility:Tween(ImageDropdown, {CanvasSize = ImageSize}, 0.25)
                        end 
                    end
                end)

                ImageHolder.MouseEnter:Connect(function()
                    Hovering = true
                    Utility:Tween(ImageHolder, {BackgroundColor3 = Utility:Lighten(Theme.PrimaryElementColor)}, 0.5)
                end)

                ImageHolder.MouseLeave:Connect(function()
                    Hovering = false
                    Utility:Tween(ImageHolder, {BackgroundColor3 = Theme.PrimaryElementColor}, 0.5)
                    
                end)

                function ImageFunctions:UpdateImage(NewURL, NewSize)
                    ImageSize = NewSize
                    URL = NewUrl
                    Image.Image = NewURL
                    UpdateImageCanvas()
                end
                return ImageFunctions
            end
            return Elements
        end
        return Sections
    end
    return Tabs
end
return Library
