-- // Services
local TweenService = game:GetService('TweenService')
local CoreGui = game:GetService('CoreGui')
local UserInputService = game:GetService('UserInputService')

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
    Size = UDim2.new(0, 150, 0, 348),
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
        Size = UDim2.new(0, 150, 0, 343),
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
            Padding = UDim.new(0, -3)
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
        Position = UDim2.new(0, 145, 0, 0),
        Size = UDim2.new(0, 5, 0, 5),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }),
    UIFunctions:Create('Frame', {
        Name = 'SidebarFiller3',
        Position = UDim2.new(0, 145, 0, 343),
        Size = UDim2.new(0, 5, 0, 5),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }),
    UIFunctions:Create('Frame', {
        Name = 'SidebarLine1',
        Position = UDim2.new(0, 150, 0, 0),
        Size = UDim2.new(0, 1, 0, 10),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundColor3 = Color3.fromRGB(75, 75, 75)
    }),
    UIFunctions:Create('Frame', {
        Name = 'SidebarLine2',
        Position = UDim2.new(0, 150, 0, 338),
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
    Position = UDim2.new(0, 151, 0, 27),
    Size = UDim2.new(0, 499, 0, 348),
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

    -- // Main
    UIFunctions:Create('Frame', {
        Name = Name .. 'Tab',
        Parent = TabHolderFolder,
        Size = UDim2.new(0, 499, 0, 348),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        Visible = IsVisible
    }, {
        UIFunctions:Create('UICorner', {
            Name = Name .. 'TabCorner',
            CornerRadius = UDim.new(0, 5)
        })
    })
    
    -- // Buttons
    UIFunctions:Create('TextButton', {
        Name = Name .. 'TabButton',
        Parent = SidebarScrolling,
        Size = UDim2.new(0, 135, 0, 25),
        TextColor3 = Color3.fromRGB(175, 175, 175),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Font = Enum.Font.Gotham,
        Text = Name,
        BorderSizePixel = 0,
        TextSize = 16,
        AutoButtonColor = false,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 2,
    }, {
        UIFunctions:Create('UIPadding', {
            Name = Name .. 'TabButtonTextPadding',
            PaddingLeft = UDim.new(0, 5)
        })
    })

    local Tab = TabHolderFolder[Name .. 'Tab']
    local TabButton = SidebarScrolling[Name .. 'TabButton']

    if IsVisible then
        UIFunctions:Tween(TabButton, {TextColor3 = Color3.fromRGB(0, 150, 255)}, 0.25)
    end
    
    TabButton.MouseEnter:Connect(function()
        if Tab.Visible then
            UIFunctions:Tween(TabButton, {TextColor3 = Color3.fromRGB(0, 150, 255)}, 0.25)
        else
            UIFunctions:Tween(TabButton, {TextColor3 = Color3.fromRGB(200, 200, 200)}, 0.25)
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if Tab.Visible then
            UIFunctions:Tween(TabButton, {TextColor3 = Color3.fromRGB(0, 150, 255)}, 0.25)
        else
            UIFunctions:Tween(TabButton, {TextColor3 = Color3.fromRGB(175, 175, 175)}, 0.25)
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

                for _, OtherTabButton in next, SidebarScrolling:GetChildren() do
                    if OtherTabButton:IsA('TextButton') then
                        UIFunctions:Tween(OtherTabButton, {TextColor3 = Color3.fromRGB(175, 175, 175)}, 0.25)
                    end
                end

                UIFunctions:Tween(TabButton, {TextColor3 = Color3.fromRGB(0, 150, 255)}, 0.25)
                Tab.Visible = true
            end
        else
            -- // PROMPT
            print(HasMethods)
        end
    end)

    return Tab
end

-- // Create Tabs
local RemoteSpy = CreateTab('Remote Spy', true)
local HTTPSpy = CreateTab('HTTP Spy', false)

UtilityFunctions:Log('Log', 'Finished Loading UI')