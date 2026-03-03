# Aries UI Library Documentation

> Version 1.0.0 · Built for Roblox exploit environments

---

## Getting Started

### Load the Library

```lua
local Library = loadstring(game:HttpGet('YOUR_RAW_URL_HERE'))()
```

---

## Creating a Window

```lua
local Window = Library:CreateWindow({
    Name               = 'Hub Name',
    IntroText          = 'Hub Name',
    IntroIcon          = 'rbxassetid://10618644218',
    IntroBlur          = true,
    IntroBlurIntensity = 15,
    Theme              = Library.Themes.Dark
})
```

| Parameter | Type | Description |
|---|---|---|
| `Name` | string | Title shown in the top bar |
| `IntroText` | string | Text shown on the intro screen |
| `IntroIcon` | string | Asset ID of the intro icon |
| `IntroBlur` | bool | Whether to blur the background on intro |
| `IntroBlurIntensity` | number | Blur amount (1–24 recommended) |
| `Theme` | table / string | A built-in theme or custom theme table |

---

## Themes

### Built-in Themes

```lua
Library.Themes.Dark   -- Default dark theme
Library.Themes.Light  -- Light theme
Library.Themes.Ocean  -- Blue ocean theme
```

### Custom Theme

```lua
local Window = Library:CreateWindow({
    Theme = {
        BackgroundColor    = Color3.fromRGB(10, 10, 10),
        SecondaryColor     = Color3.fromRGB(15, 15, 15),
        TertiaryColor      = Color3.fromRGB(8, 8, 8),
        AccentColor        = Color3.fromRGB(60, 60, 60),
        Color              = Color3.fromRGB(0, 120, 255),   -- accent/highlight
        PrimaryTextColor   = Color3.fromRGB(240, 240, 240),
        SecondaryTextColor = Color3.fromRGB(120, 120, 120)
    }
})
```

### Change Theme at Runtime

```lua
Window:ChangeTheme('Ocean')  -- 'Dark' | 'Light' | 'Ocean'
```

---

## Creating Tabs

```lua
local Tab = Window:CreateTab('Tab Name', 'rbxassetid://ICON_ID')
```

| Parameter | Type | Description |
|---|---|---|
| `Tab Name` | string | Label shown in the sidebar |
| `Icon` | string | *(optional)* rbxassetid icon URL |

---

## Creating Sections

```lua
local Section = Tab:CreateSection('Section Name')
```

Sections group related elements visually inside a tab.

---

## Elements

### Label

A read-only text line.

```lua
local Label = Section:CreateLabel('Hello World')

-- Update text
Label:Set('New Text')
```

---

### Paragraph

A title + body text block.

```lua
local Para = Section:CreateParagraph('Title', 'Body content goes here.')

-- Update
Para:Set('New Title', 'New content.')
```

---

### Button

A clickable button.

```lua
local Button = Section:CreateButton('Click Me', function()
    print('Button pressed!')
end)

-- Update label
Button:SetText('New Label')
```

---

### Toggle

An on/off switch.

```lua
local Toggle = Section:CreateToggle('Feature', false, function(Value)
    print('Toggle:', Value)
end)

-- Set value
Toggle:Set(true)

-- Get value
print(Toggle:Get())
```

| Parameter | Type | Description |
|---|---|---|
| `Text` | string | Label |
| `Default` | bool | Default state |
| `Callback` | function | Called with `(bool)` on change |

---

### Slider

A numeric range slider.

```lua
local Slider = Section:CreateSlider('Speed', 0, 100, 50, function(Value)
    print('Slider:', Value)
end)

-- Set value
Slider:Set(75)

-- Get value
print(Slider:Get())
```

| Parameter | Type | Description |
|---|---|---|
| `Text` | string | Label |
| `Min` | number | Minimum value |
| `Max` | number | Maximum value |
| `Default` | number | Starting value |
| `Callback` | function | Called with `(number)` on change |

---

### Textbox

A text input field. Fires callback on Enter.

```lua
local Textbox = Section:CreateTextbox('Name', 'Enter name...', function(Value)
    print('Input:', Value)
end)

-- Set value
Textbox:Set('Hello')

-- Get value
print(Textbox:Get())
```

---

### Keybind

Listens for a keyboard key. Click the button to rebind.

```lua
local Keybind = Section:CreateKeybind('Toggle Fly', 'F', function()
    print('Key pressed!')
end)

-- Set key
Keybind:Set('G')

-- Get current key
print(Keybind:Get())  --> 'G'
```

---

### Dropdown

A selection list.

```lua
local Dropdown = Section:CreateDropdown('Aim Part', {
    'Head', 'Torso', 'HumanoidRootPart'
}, 'Head', function(Value)
    print('Selected:', Value)
end)

-- Set selected option
Dropdown:Set('Torso')

-- Replace options list
Dropdown:SetOptions({'Option1', 'Option2'})

-- Get current selection
print(Dropdown:Get())
```

| Parameter | Type | Description |
|---|---|---|
| `Text` | string | Label |
| `Options` | table | Array of string options |
| `Default` | string | Default selected option |
| `Callback` | function | Called with `(string)` on change |

---

### Colorpicker

An HSV color picker with hex input.

```lua
local CP = Section:CreateColorpicker('ESP Color', Color3.fromRGB(255, 0, 0), function(Color)
    print('Color:', Color)
end)

-- Set color
CP:Set(Color3.fromRGB(0, 255, 0))

-- Get color
print(CP:Get())
```

Click the colored preview box to open/close the picker panel. You can drag the saturation/value box, drag the hue bar, or type a hex code directly.

---

### Separator

A horizontal divider line.

```lua
Section:CreateSeparator()
```

---

## Window Functions

### Notifications

```lua
Window:Notify(Title, Message, Duration, Type)
```

| Parameter | Type | Description |
|---|---|---|
| `Title` | string | Bold notification title |
| `Message` | string | Body text |
| `Duration` | number | Seconds before auto-dismiss |
| `Type` | string | `'Info'` \| `'Success'` \| `'Warning'` \| `'Error'` |

**Examples:**

```lua
Window:Notify('Info',    'Library loaded.',        5, 'Info')
Window:Notify('Success', 'Config saved.',          4, 'Success')
Window:Notify('Warning', 'Be careful.',            4, 'Warning')
Window:Notify('Error',   'Something went wrong!',  5, 'Error')
```

---

### Toggle Visibility

```lua
Window:Toggle()   -- shows/hides the entire UI
```

Pair with a keybind:

```lua
Section:CreateKeybind('Toggle UI', 'RightControl', function()
    Window:Toggle()
end)
```

---

### Destroy

Completely removes all UI elements.

```lua
Library:Destroy()
```

---

## Full Example

```lua
local Library = loadstring(game:HttpGet('YOUR_URL'))()

local Window = Library:CreateWindow({
    Name  = 'My Hub',
    Theme = Library.Themes.Dark
})

local Tab = Window:CreateTab('Main')
local Section = Tab:CreateSection('Settings')

Section:CreateToggle('God Mode', false, function(v)
    -- your logic
end)

Section:CreateSlider('Speed', 16, 250, 16, function(v)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end)

Section:CreateButton('Notify Me', function()
    Window:Notify('Test', 'Button was pressed!', 4, 'Success')
end)

Window:Notify('Loaded', 'My Hub is ready!', 5, 'Info')
```

---

*Aries UI Library — made with ♥*
