if Library and Library.Unload then
    Library:Unload()
end
--
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats = game:GetService("Stats")
local GuiService = game:GetService("GuiService")
--
local Client = Players.LocalPlayer
local Camera = Workspace:FindFirstChildWhichIsA("Camera")
local Viewport = Camera.ViewportSize
--
do -- Folders
    if not isfolder("gamesense") then
        makefolder("CerusPremium")
    end
    --
    if not isfolder("gamesense/Configs") then
        makefolder("CerusPremium/Configs")
    end
end
--
do -- Library
    getgenv().Library = {
        Connections = {},
        Errors = {},
        Tweens = {},
        Objects = {},
        Sections = {},
        ThemeSections = {},
        Flags = {},
        UnnamedFlags = 0,
        Build = "Beta",
        UID = "1",
        UnsafeMode = false,
        InitTime = os.clock(),
        Folder = "CerusPremium",
        ConfigFolder = "CerusPremium/Configs",
        UI = {
            Name = "Cerus Premium",
            CloseBind = Enum.KeyCode.Insert,
            SectionResizeIncrements = 1,
            WatermarkRefreshRate = 1,
            MainUI = nil,
            Initialized = false,
            Faded = false,
            LastCopiedColor = nil,
            TabIndex = 0,
            Viewing = false,
            CurrentSelectedColorPicker = nil,
            CurrentSelectedColorPickerExtra = nil,
            CurrentSelectedKeybindMode = nil,
            TotalColorPickers = 0,
            TotalKeybindModes = 0,
            WatermarkPosition = "Top Right",
            SectionZIndex = 100,
            Resizing = false,
            DropdownZIndex = 1,
            OpenColorFrames = 0,
            ScreenGUI = nil,
            TweenSpeed = 0.15,
            NewFont = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            FontSize = 13,
            DraggingGui = nil,
            Notifications = {TopLeft = {}, Middle = {}},
            Keys = {
                [Enum.KeyCode.LeftShift] = "LSHF",
                [Enum.KeyCode.RightShift] = "RSHF",
                [Enum.KeyCode.LeftControl] = "LCTR",
                [Enum.KeyCode.RightControl] = "RCTR",
                [Enum.KeyCode.LeftAlt] = "LALT",
                [Enum.KeyCode.RightAlt] = "RALT",
                [Enum.KeyCode.CapsLock] = "CAPS",
                [Enum.KeyCode.Space] = "SPCE",
                [Enum.KeyCode.One] = "ONE",
                [Enum.KeyCode.Two] = "TWO",
                [Enum.KeyCode.Three] = "THREE",
                [Enum.KeyCode.Four] = "FOUR",
                [Enum.KeyCode.Five] = "FIVE",
                [Enum.KeyCode.Six] = "SIX",
                [Enum.KeyCode.Seven] = "SEVEN",
                [Enum.KeyCode.Eight] = "EIGHT",
                [Enum.KeyCode.Nine] = "NINE",
                [Enum.KeyCode.Zero] = "ZERO",
                [Enum.KeyCode.KeypadOne] = "NUM1",
                [Enum.KeyCode.KeypadTwo] = "NUM2",
                [Enum.KeyCode.KeypadThree] = "NUM3",
                [Enum.KeyCode.KeypadFour] = "NUM4",
                [Enum.KeyCode.KeypadFive] = "NUM5",
                [Enum.KeyCode.KeypadSix] = "NUM6",
                [Enum.KeyCode.KeypadSeven] = "NUM7",
                [Enum.KeyCode.KeypadEight] = "NUM8",
                [Enum.KeyCode.KeypadNine] = "NUM9",
                [Enum.KeyCode.KeypadZero] = "NUM0",
                [Enum.KeyCode.Insert] = "INS",
                [Enum.KeyCode.Minus] = "-",
                [Enum.KeyCode.Equals] = "=",
                [Enum.KeyCode.Tilde] = "~",
                [Enum.KeyCode.LeftBracket] = "[",
                [Enum.KeyCode.RightBracket] = "]",
                [Enum.KeyCode.RightParenthesis] = ")",
                [Enum.KeyCode.LeftParenthesis] = "(",
                [Enum.KeyCode.Semicolon] = ",",
                [Enum.KeyCode.Quote] = "'",
                [Enum.KeyCode.BackSlash] = "\\",
                [Enum.KeyCode.Comma] = ",",
                [Enum.KeyCode.Period] = ".",
                [Enum.KeyCode.Slash] = "/",
                [Enum.KeyCode.Asterisk] = "*",
                [Enum.KeyCode.Plus] = "+",
                [Enum.KeyCode.Period] = ".",
                [Enum.KeyCode.Backquote] = "`",
                [Enum.UserInputType.MouseButton1] = "M1",
                [Enum.UserInputType.MouseButton2] = "M2",
                [Enum.UserInputType.MouseButton3] = "M3"
            },
        },
        Theme = {
            Objects = {},
            Default = {
                Accent = Color3.fromRGB(153, 196, 39),
                SecondAccent = Color3.fromRGB(124, 158, 32),
                TextColor = Color3.fromRGB(205, 205, 205),
                Risky = Color3.fromRGB(165, 165, 120),
            }
        }
    }
    --
    function Library:Validate(Defaults, Options)
        for Index, Value in Defaults do
            if Options[Index] == nil then
                Options[Index] = Value
            end
        end
        --
        return Options
    end
    --
    function Library:Connection(Signal, Func, Name, Table)
        Name = Name or "Unknown"
        Table = Table or Library.Connections
        --
        local Connection; Connection = Signal:Connect(function(...)
            local Args = {...}
            --
            local Success, Message = pcall(function() coroutine.wrap(Func)(unpack(Args)) end)
            --
            if not Success and not Library.Errors[Message] then
                if Library.Notify then
                    Library:Notify({Message = ("[ERROR] | An error has occurred:\n%s\nName: %s"):format(Message, Name), Delay = math.huge})
                else
                    warn(("[ERROR] | An error has occurred:\n%s\nName: %s"):format(Message, Name))
                end
                --
                Library.Errors[Message] = Message
                --
                if Table[Connection] then
                    Table[Connection] = nil
                end
                --
                return Connection and Connection:Disconnect()
            end
        end)
        --
        if Connection and Table then
            table.insert(Table, Connection)
        end
        --
        return Connection
    end
    --
    function Library:TweenObject(Object, Info, Goal, Callback)
        if not Object then return end
        --
        local Tween = TweenService:Create(Object, Info, Goal)
        --
        Library:Connection(Tween.Completed, Callback or function() end)
        --
        Tween:Play()
        --
        Library.Tweens[#Library.Tweens + 1] = Tween
    end
    --
    function Library:NewFlag()
        Library.UnnamedFlags += 1
        --
        return ("UnknownFlag%s"):format(tostring(Library.UnnamedFlags))
    end
    --
    function Library:ClampString(String, MaxWidth)
        local Clamped = String
        --
        local TextLabel = Library:CreateObject("TextLabel", {
            FontFace = Library.UI.NewFont,
            TextStrokeTransparency = 0,
            Text = String,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            TextScaled = false,
            TextWrapped = false,
            Visible = false,
            TextSize = Library.UI.FontSize,
            Parent = Client.PlayerGui
        })
        --
        if TextLabel.TextBounds.X <= MaxWidth then
            TextLabel:Destroy()
            --
            return String
        end
        --
        while TextLabel.TextBounds.X > MaxWidth and #Clamped > 0 do
            Clamped = Clamped:sub(1, #Clamped - 1)
            --
            TextLabel.Text = Clamped .. "..."
            --
            task.wait()
        end
        --
        TextLabel:Destroy()
        --
        return Clamped .. "..."
    end
    --
    function Library:GetConfig()
        local Config = {}
        --
        for Index, Value in Library.Flags do
            if Value.Get and not string.find(Index, "_Status") then
                if typeof(Value:Get()) == "table" and Value:Get().Color and Value:Get().Transparency then
                    local Transparency = Value:Get().Transparency
                    local Hue, Saturation, Value = Value:Get().Color:ToHSV()
                    --
                    Config[Index] = {Hue, Saturation, Value, Transparency}
                else
                    Config[Index] = Value:Get()
                end
            end
        end
        --
        return HttpService:JSONEncode(Config)
    end
    --
    function Library:LoadConfig(Config)
        local Config = HttpService:JSONDecode(Config)
        --
        for Index, Value in Config do
            if Library.Flags[Index] and Library.Flags[Index].Set then
                Library.Flags[Index]:Set(Value)
            end
        end
    end
    --
    function Library:SectionDragging(Frame)
        local MousePosition = UserInputService:GetMouseLocation()
        local Position = Frame.AbsolutePosition
        local Size = Frame.AbsoluteSize
        --
        local InsideX = MousePosition.X >= Position.X and MousePosition.X <= Position.X + Size.X
        local InsideY = MousePosition.Y >= Position.Y and MousePosition.Y <= Position.Y + Size.Y
        --
        return InsideX and InsideY
    end
    --
    function Library:CreateObject(Type, Properties, Hidden)
        local Hidden = Hidden or false
        local Object = Instance.new(Type)
        --
        for Index, Value in Properties do
            if (not RunService:IsStudio()) and Index == "Name" and not string.match(Value, "%d") then
                Value = "\0"
            end
            --
            if Index == "TextStrokeTransparency" and Value == 0 then
                local Stroke = Instance.new("UIStroke")
                --
                Stroke.Parent = Object
                Stroke.LineJoinMode = Enum.LineJoinMode.Miter
                --
                Library.Objects[Stroke] = {Stroke, {Parent = Object, LineJoinMode = Enum.LineJoinMode.Miter}, Hidden}
            else
                Object[Index] = Value
            end
        end
        --
        Library.Objects[Object] = {Object, Properties, Hidden}
        --
        return Object
    end
    --
    function Library:AddTheme(Object, Properties)
        for Index, Value in Properties do
            Library.Theme.Objects[Object] = Library.Theme.Objects[Object] or {}
            Library.Theme.Objects[Object][Index] = Value
        end
    end
    --
    function Library:GetTableIndexes(Table, Custom)
        local Table2 = {}
        --
        for Index, Value in Table do
            Table2[Custom and Value[1] or #Table2 + 1] = Index 
        end
        --
        return Table2
    end
    --
    function Library:UpdateConfigList(List, Type)
        for _, File in listfiles("CerusPremium/Configs") do
            local FileName = File:gsub("\\", "/"):gsub("CerusPremium/Configs/", ""):gsub(".cfg", "")
            --
            if Type == "Remove" then
                List:RemoveValue(FileName)
            else
                List:AddValue(FileName)
            end
        end
    end
    --
    function Library:GetObjectsTable(MainUI, AddMain, Ignored)
        local AddMain = AddMain or false
        local Ignored = Ignored or {}
        local DescendantTable = {}
        local NewTable = {}
        --
        for _, Descendant in MainUI:GetDescendants() do
            if table.find(Ignored, Descendant) then continue end
            --
            DescendantTable[#DescendantTable + 1] = Descendant
        end
        --
        if AddMain then
            DescendantTable[#DescendantTable + 1] = MainUI
        end
        --
        for _, Descendant in DescendantTable do
            local Found = Library.Objects[Descendant]
            --
            if Found then
                local Properties = Found[2]
                local HiddenValue = Found[3]
                --
                NewTable[#NewTable + 1] = {Descendant, Properties, HiddenValue}
            end
        end
        --
        return NewTable
    end
    --
    function Library:SetTableVisible(Table, State, Ignored)
        local Ignored = Ignored or {}
        --
        for _, Object in Table do
            if table.find(Ignored, Object) then continue end
            --
            if typeof(Object) == "table" and Object.SetVisible then 
                Object:SetVisible(State)
            end
        end
    end
    --
    function Library:UpdateColor(ColorType, ColorValue)
        Library.Theme.Default[ColorType] = ColorValue
        --
        for Object, Properties in Library.Theme.Objects do
            for Property, ThemeKeys in Properties do
                if typeof(ThemeKeys) == "table" then
                    if Object:IsA("UIGradient") and Property == "Color" then
                        if Library.Theme.Default[ThemeKeys[1]] then
                            Object.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Library.Theme.Default[ThemeKeys[1]]), ColorSequenceKeypoint.new(1, Library.Theme.Default[ThemeKeys[2]])}
                        end
                    end
                else
                    if ThemeKeys == ColorType then
                        Object[Property] = Library.Theme.Default[ThemeKeys]
                    end
                end
            end
        end
    end
    --
    function Library:ViewPlayer(Player)
        if not Library.UI.Viewing then
            Camera.CameraSubject = Player.Character.Humanoid
        else
            Camera.CameraSubject = Client.Character.Humanoid
        end
        --
        Library.UI.Viewing = not Library.UI.Viewing
    end
    --
    function Library:GetTableLength(Table)
        local Length = 0
        --
        for Index, Value in pairs(Table) do
            Length += 1
        end
        --
        return Length
    end
    --
    function Library:ScrollingCheck(ScrollingFrame, Frame)
        if not ScrollingFrame:IsA("ScrollingFrame") then return true end
        --
        local VisibleTopLeft = ScrollingFrame.CanvasPosition
        local VisibleBottomRight = VisibleTopLeft + ScrollingFrame.AbsoluteWindowSize
        --
        local FrameTopLeft = Frame.AbsolutePosition - ScrollingFrame.AbsolutePosition + ScrollingFrame.CanvasPosition
        local FrameBottomRight = FrameTopLeft + Frame.AbsoluteSize
        --
        return FrameBottomRight.X > VisibleTopLeft.X and FrameTopLeft.X < VisibleBottomRight.X and FrameBottomRight.Y > VisibleTopLeft.Y and FrameTopLeft.Y < VisibleBottomRight.Y
    end
    --
    function Library:ClampPosition(Object, Position, Offset)
        local ClampedX = math.clamp(Position.X.Offset, Offset, Viewport.X - Object.AbsoluteSize.X - Offset)
        local ClampedY = math.clamp(Position.Y.Offset, Offset, Viewport.Y - Object.AbsoluteSize.Y - Offset)
        --
        return UDim2.new(Position.X.Scale, ClampedX, Position.Y.Scale, ClampedY)
    end
    --
    function Library:Fade(State, Table, MainUI, Speed)
        local IsMainUI = Table == Library.Objects
        --
        MainUI.Active = State
        --
        if State then
            MainUI.Visible = true
        end
        --
        if IsMainUI then
            Library.UI.Faded = not State
        end
        --  handle toggle transparency when fading out since im not using fade out for now as it causes fps issues
        if not State and IsMainUI then
            -- find all toggle elements and force them transparent immediately instead of waiting since some things may not leave instantly
            for _, obj in pairs(MainUI:GetDescendants()) do
                if obj.ClassName == "Frame" then
                    if obj.Name == "ToggleMain" then
                        obj.BackgroundTransparency = 1
                    end
                end
            end
        end
        --
        for _, Object in Table do
            if not Object[3] then
                if Object[1].ClassName == "Frame" and (Object[2]["BackgroundTransparency"] or 0) ~= 1 then
                    -- Library:TweenObject(Object[1], TweenInfo.new(Speed, Enum.EasingStyle.Linear, State and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {BackgroundTransparency = State and (Object[2]["BackgroundTransparency"] or 0) or 1})
                    Object[1].BackgroundTransparency = State and (Object[2]["BackgroundTransparency"] or 0) or 1
                elseif Object[1].ClassName == "ImageLabel" or Object[1].ClassName == "ImageButton" then
                    if (Object[2]["BackgroundTransparency"] or 0) ~= 1 then
                        -- Library:TweenObject(Object[1], TweenInfo.new(Speed, Enum.EasingStyle.Linear, State and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {BackgroundTransparency = State and (Object[2]["BackgroundTransparency"] or 0) or 1})
                        Object[1].BackgroundTransparency = State and (Object[2]["BackgroundTransparency"] or 0) or 1
                    end
                    --
                    if (Object[2]["ImageTransparency"] or 0) ~= 1 then
                        -- Library:TweenObject(Object[1], TweenInfo.new(Speed, Enum.EasingStyle.Linear, State and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {ImageTransparency = State and (Object[2]["ImageTransparency"] or 0) or 1})
                        Object[1].ImageTransparency = State and (Object[2]["ImageTransparency"] or 0) or 1
                    end
                elseif Object[1].ClassName == "TextLabel" or Object[1].ClassName == "TextButton" or Object[1].ClassName == "TextBox" then
                    if (Object[2]["BackgroundTransparency"] or 0) ~= 1 then
                        -- Library:TweenObject(Object[1], TweenInfo.new(Speed, Enum.EasingStyle.Linear, State and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {BackgroundTransparency = State and (Object[2]["BackgroundTransparency"] or 0) or 1})
                        Object[1].BackgroundTransparency = State and (Object[2]["BackgroundTransparency"] or 0) or 1
                    end
                    --
                    if (Object[2]["TextTransparency"] or 0) ~= 1 then
                        -- Library:TweenObject(Object[1], TweenInfo.new(Speed, Enum.EasingStyle.Linear, State and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {TextTransparency = State and (Object[2]["TextTransparency"] or 0) or 1})
                        Object[1].TextTransparency = State and (Object[2]["TextTransparency"] or 0) or 1
                    end
                elseif Object[1].ClassName == "ScrollingFrame" then
                    if (Object[2]["BackgroundTransparency"] or 0) ~= 1 then
                        -- Library:TweenObject(Object[1], TweenInfo.new(Speed, Enum.EasingStyle.Linear, State and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {BackgroundTransparency = State and (Object[2]["BackgroundTransparency"] or 0) or 1})
                        Object[1].BackgroundTransparency = State and (Object[2]["BackgroundTransparency"] or 0) or 1
                    end
                    --
                    if (Object[2]["ScrollBarImageTransparency"] or 0) ~= 1 then
                        -- Library:TweenObject(Object[1], TweenInfo.new(Speed, Enum.EasingStyle.Linear, State and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {ScrollBarImageTransparency = State and (Object[2]["ScrollBarImageTransparency"] or 0) or 1})
                        Object[1].ScrollBarImageTransparency = State and (Object[2]["ScrollBarImageTransparency"] or 0) or 1
                    end
                elseif Object[1].ClassName == "UIStroke" then
                    -- Library:TweenObject(Object[1], TweenInfo.new(Speed, Enum.EasingStyle.Linear, State and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {Transparency = State and (Object[2]["Transparency"] or 0) or 1})
                    Object[1].Transparency = State and (Object[2]["Transparency"] or 0) or 1
                end
            end
        end
        --
        if not State then
            task.delay(Speed, function()
                if not MainUI.Parent then return end
                MainUI.Visible = false
            end)
        end
    end
    --
    function Library:CheckFrameFirst(FrameA, FrameB)
        local Parent = FrameA.Parent
        local Frames = {}
        local IndexA, IndexB
        --
        for _, Child in Parent:GetChildren() do
            if Child:IsA("Frame") then
                table.insert(Frames, Child)
            end
        end
        --
        table.sort(Frames, function(a, b)
            if a.LayoutOrder == b.LayoutOrder then
                for _, Child in Parent:GetChildren() do
                    if Child == a then return true end
                    if Child == b then return false end
                end
            end
            --
            return a.LayoutOrder < b.LayoutOrder
        end)
        --
        for i, Frame in Frames do
            if Frame == FrameA then IndexA = i end
            if Frame == FrameB then IndexB = i end
        end
        --
        return IndexA and IndexB and IndexA < IndexB
    end
    --
    function Library:Resizable(Object, DragFrame, MinResize, MaxResize, Increments, UseIcon, UseParent, Delay)
        local StartingSize, ObjectSize, Dragging, MouseLocation, PerformanceDragUI, NewMouse, Hovering
        --
        local function UpdateSize()
            if not MouseLocation then return end
            --
            Library.UI.Resizing = true
            --
            local CurrentMousePosition = UserInputService:GetMouseLocation()
            local Delta = CurrentMousePosition - MouseLocation
            local NewSizeX = StartingSize.X.Offset + Delta.X
            local NewSizeY = StartingSize.Y.Offset + Delta.Y
            local Parent = Object.Parent
            local ParentSize = Parent.AbsoluteSize
            --
            if UseParent then
                local OccupiedSpaceY = 0
                local FrameCount = 0
                --
                for _, Child in Parent:GetChildren() do
                    if Child:IsA("Frame") and Child ~= Object then
                        FrameCount += 1
                        --
                        if Library:CheckFrameFirst(Object, Child) then
                            if Child.AbsoluteSize.Y >= (ParentSize.Y - Object.AbsoluteSize.Y) - 57 then
                                Child.Size = UDim2.new(Child.Size.X.Scale, Child.Size.X.Offset, 0, math.max(50, (ParentSize.Y - Object.AbsoluteSize.Y) - 57))
                            end
                        else
                            OccupiedSpaceY += Child.AbsoluteSize.Y + 19
                        end
                    end
                end
                --
                if OccupiedSpaceY == 0 then
                    MaxResize = UDim2.new(0, 0, 0, (ParentSize.Y - OccupiedSpaceY) - (FrameCount * (50 + 19)) - 38)
                else
                    MaxResize = UDim2.new(0, 0, 0, (ParentSize.Y - OccupiedSpaceY) - 38)
                end
            end
            --
            if Increments then
                NewSizeY = math.clamp(math.round(NewSizeY / Increments) * Increments, MinResize.Y.Offset, MaxResize.Y.Offset)
            else
                NewSizeY = math.clamp(NewSizeY, MinResize.Y.Offset, MaxResize.Y.Offset)
                NewSizeX = math.clamp(NewSizeX, MinResize.X.Offset, MaxResize.X.Offset)
            end
            --
            return UseParent and UDim2.new(1, 0, 0, NewSizeY) or UDim2.new(0, NewSizeX, 0, NewSizeY)
        end
        
        --
        Library:Connection(DragFrame.MouseEnter, function()
            Hovering = true
        end)
        --
        Library:Connection(DragFrame.MouseLeave, function()
            if NewMouse then NewMouse:Destroy() NewMouse = nil end
            --
            UserInputService.MouseIconEnabled = true
            Hovering = false
        end)
        --
        Library:Connection(DragFrame.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                MouseLocation = UserInputService:GetMouseLocation()
                StartingSize = Object.Size
            end
        end)
        --
        Library:Connection(RunService.PreRender, function()
            if (Hovering or Dragging) and UseIcon then
                local MousePosition = UserInputService:GetMouseLocation()
                --
                UserInputService.MouseIconEnabled = false
                --
                if not NewMouse then
                    NewMouse = Library:CreateObject("ImageLabel", {
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Image = "rbxassetid://87982048533100",
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Name = "Transparency",
                        Size = UDim2.new(0, 35, 0, 35),
                        ZIndex = 10000,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = Library.UI.ScreenGUI
                    }, true)
                end
                --
                NewMouse.Position = UDim2.new(0, MousePosition.X, 0, MousePosition.Y)
            end
            --
            if Dragging then
                if Delay then task.delay(Delay, function()
                        Object.Size = UpdateSize()
                    end)
                else
                    Object.Size = UpdateSize()
                end
            end
        end)
        --
        Library:Connection(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and Dragging then
                if NewMouse then NewMouse:Destroy() NewMouse = nil end
                --
                if UseParent then
                    for _, Child in Object.Parent:GetChildren() do
                        if Child:IsA("Frame") and Child ~= Object then
                            if Library:CheckFrameFirst(Object, Child) then
                                if Child.AbsoluteSize.Y >= (Object.Parent.AbsoluteSize.Y - Object.AbsoluteSize.Y) - 57 then
                                    Child.Size = UDim2.new(Child.Size.X.Scale, Child.Size.X.Offset, 0, math.max(50, (Object.Parent.AbsoluteSize.Y - Object.AbsoluteSize.Y) - 57))
                                end
                            end
                        end
                    end
                end
                --
                UserInputService.MouseIconEnabled = true
                Dragging = false
                Library.UI.Resizing = false
            end
        end)
    end
    --
    Library.__index = Library
    Library.Sections.__index = Library.Sections
    --
    local Sections = Library.Sections
    --
    function Library:ColorPicker(Options)
        Options = Library:Validate({
            Name = "Preview Color Picker",
            Default = Library.Theme.Default.Accent,
            Alpha = 0,
            AlphaBar = true,
            Parent = nil,
            MainUI = nil,
            TabUI = nil,
            Count = 1,
            Keybind = false,
            Flag = Library:NewFlag(),
            Callback = function() end,
        }, Options or {})
        --
        local Hue, Saturation, Value = Options.Default:ToHSV()
        --
        local ColorPicker = {
            Hover = false,
            Active = false,
            MouseDown = false,
            MainFrameHover = false,
            Color = Options.Default,
            SecondColor = Color3.fromRGB(math.max(math.floor(Options.Default.R * 255) - 14, 0), math.max(math.floor(Options.Default.G * 255) - 14, 0), math.max(math.floor(Options.Default.B * 255) - 14, 0)),
            Saturation = {Saturation, Value},
            Alpha = Options.Alpha,
            Hue = Hue,
            ActiveFrame = false,
            LastCopiedColor = {self.Color, self.Alpha},
            FrameOpened = false,
        }
        --
        Library.Flags[Options.Flag] = ColorPicker
        --
        Library.UI.TotalColorPickers += 1
        --
        if Options.Keybind then
            Options.Count += 1
        end
        --
        local ColorPickerOutline_1 = Library:CreateObject("Frame", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(1, 0),
            Name = "ColorPickerOutline" .. Library.UI.TotalColorPickers,
            Position = UDim2.new(1, 0 - (Options.Count - 1) * 22, 0, 0),
            Size = UDim2.new(0, 17, 0, 9),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = Options.Parent
        })
        --
        local ColorPickerChecker = Library:CreateObject("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 0, 1, 4),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 0, 0, 1),
            Visible = false,
            BorderSizePixel = 0,
            Parent = ColorPickerOutline_1
        })
        --
        local Button_9 = Library:CreateObject("TextButton", {
            FontFace = Library.UI.NewFont,
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Button_9",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            TextTransparency = 1,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = ColorPickerOutline_1
        })
        --
        local ColorPickerTransparency = Library:CreateObject("ImageLabel", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Image = "rbxassetid://18249241978",
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Name = "Transparency",
            Size = UDim2.new(1, -2, 1, -2),
            Position = UDim2.new(0, 1, 0, 1),
            BorderSizePixel = 0,
            ZIndex = 3,
            ScaleType = Enum.ScaleType.Tile,
            TileSize = UDim2.new(0, 6, 0, 6),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = ColorPickerOutline_1
        })
        --
        local ColorPickerInline_1 = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "ColorPickerInline_1",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = ColorPickerOutline_1
        })
        --
        local UIGradient_24 = Library:CreateObject("UIGradient", {
            Rotation = 90,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, ColorPicker.Color),
                ColorSequenceKeypoint.new(1, ColorPicker.SecondColor)
            },
            Parent = ColorPickerInline_1
        })
        --
        do -- Functions
            function ColorPicker:SetVisible(Bool)
                ColorPickerOutline_1.Visible = Bool
                --
                if Bool == false then
                    ColorPicker:RemoveFrame()
                end
            end
            --
            function ColorPicker:AddFrame()
                Library.UI.CurrentSelectedColorPicker = {ColorPicker = ColorPicker, ColorPickerOutline = ColorPickerOutline_1, Parent = Options.Parent}
                --
                Library.UI.OpenColorFrames += 1
                --
                local ColorPickerOutline = Library:CreateObject("Frame", {
                    Size = UDim2.new(0, 180, 0, 175),
                    Name = "ColorPickerFrame" .. Library.UI.TotalColorPickers,
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = Library.UI.ScreenGUI
                })
                --
                ColorPickerOutline.BackgroundTransparency = 1
                --
                local ColorPickerInline = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "ColorPickerInline",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                    Parent = ColorPickerOutline
                })
                --
                ColorPickerInline.BackgroundTransparency = 1
                --
                local ColorPickerMain = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "ColorPickerMain",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    Parent = ColorPickerInline
                })
                --
                ColorPickerMain.BackgroundTransparency = 1
                --
                local MainPicker = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -24, 1, -19),
                    Name = "MainPicker",
                    Position = UDim2.new(0, 2, 0, 2),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = ColorPickerMain
                })
                --
                MainPicker.BackgroundTransparency = 1
                --
                local Button_91 = Library:CreateObject("TextButton", {
                    FontFace = Library.UI.NewFont,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "Button_9",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextTransparency = 1,
                    ZIndex = 250,
                    TextSize = Library.UI.FontSize,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = MainPicker
                })
                --
                local MainPickerColor = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "MainPickerColor",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = MainPicker
                })
                --
                MainPickerColor.BackgroundTransparency = 1
                --
                local UIGradient_20 = Library:CreateObject("UIGradient", {
                    Rotation = 180,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 4)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
                    },
                    Parent = MainPickerColor
                })
                --
                local BackImage = Library:CreateObject("ImageLabel", {
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Image = "rbxassetid://13966897785",
                    BackgroundTransparency = 1,
                    Name = "BackImage",
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    Parent = MainPickerColor
                })
                --
                BackImage.ImageTransparency = 1
                --
                local DraggingMainOutline = Library:CreateObject("Frame", {
                    Size = UDim2.new(0, 4, 0, 4),
                    Name = "DraggingMainOutline",
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 251,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = MainPicker
                })
                --
                DraggingMainOutline.BackgroundTransparency = 1
                --
                local DraggingMain = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "DraggingMain",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 251,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = DraggingMainOutline
                })
                --
                DraggingMain.BackgroundTransparency = 1
                --
                local SaturationSlider = Library:CreateObject("Frame", {
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AnchorPoint = Vector2.new(0, 1),
                    Name = "SaturationSlider",
                    Position = UDim2.new(0, 2, 1, -2),
                    Size = UDim2.new(1, -24, 0, 12),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = ColorPickerMain
                })
                --
                SaturationSlider.BackgroundTransparency = 1
                --
                local Button_915241 = Library:CreateObject("TextButton", {
                    FontFace = Library.UI.NewFont,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "Button_9",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextTransparency = 1,
                    ZIndex = 250,
                    TextSize = Library.UI.FontSize,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = SaturationSlider
                })
                --
                local SaturationColor = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "SaturationColor",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 251,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = SaturationSlider
                })
                --
                SaturationColor.BackgroundTransparency = 1
                --
                local UIGradient_21 = Library:CreateObject("UIGradient", {
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 4)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
                    },
                    Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 0.10000000149011612),
                        NumberSequenceKeypoint.new(0.5, 0.800000011920929),
                        NumberSequenceKeypoint.new(1, 1)
                    },
                    Rotation = 180,
                    Parent = SaturationColor
                })
                --
                local BackImage_1 = Library:CreateObject("ImageLabel", {
                    ScaleType = Enum.ScaleType.Tile,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "BackImage_1",
                    TileSize = UDim2.new(0, 12, 0, 12),
                    Image = "rbxassetid://18249241978",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    Parent = SaturationSlider
                })
                --
                BackImage_1.ImageTransparency = 1
                --
                local DraggingSatOutline = Library:CreateObject("Frame", {
                    Size = UDim2.new(0, 4, 1, 0),
                    Name = "DraggingSatOutline",
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 251,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = SaturationSlider
                })
                --
                DraggingSatOutline.BackgroundTransparency = 1
                --
                local DraggingSatMain = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "DraggingSatMain",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 251,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = DraggingSatOutline
                })
                --
                DraggingSatMain.BackgroundTransparency = 1
                --
                local HueSlider = Library:CreateObject("Frame", {
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AnchorPoint = Vector2.new(1, 0),
                    Name = "HueSlider",
                    Position = UDim2.new(1, -2, 0, 2),
                    Size = UDim2.new(0, 17, 1, -19),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = ColorPickerMain
                })
                --
                HueSlider.BackgroundTransparency = 1
                --
                local Button_9141 = Library:CreateObject("TextButton", {
                    FontFace = Library.UI.NewFont,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "Button_9",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextTransparency = 1,
                    ZIndex = 250,
                    TextSize = Library.UI.FontSize,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = HueSlider
                })
                --
                local BackImage_2 = Library:CreateObject("ImageLabel", {
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "BackImage_2",
                    TileSize = UDim2.new(0, 12, 0, 12),
                    Image = "rbxassetid://8180989234",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    Parent = HueSlider
                })
                --
                BackImage_2.ImageTransparency = 1
                --
                local DraggingHueOutline = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, 0, 0, 4),
                    Name = "DraggingHueOutline",
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 251,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = HueSlider
                })
                --
                DraggingHueOutline.BackgroundTransparency = 1
                --
                local DraggingHueMain = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "DraggingHueMain",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 251,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = DraggingHueOutline
                })
                --
                DraggingHueMain.BackgroundTransparency = 1
                --
                do -- Functions
                    function ColorPicker:UpdateSize()
                        ColorPickerOutline.Position = UDim2.new(0, ColorPickerOutline_1.AbsolutePosition.X, 0, (ColorPickerOutline_1.AbsolutePosition.Y + ColorPickerOutline_1.AbsoluteSize.Y + GuiService:GetGuiInset().Y + 2))
                    end
                    --
                    ColorPicker:UpdateSize()
                    --
                    Library:Connection(Options.MainUI:GetPropertyChangedSignal("AbsolutePosition"), ColorPicker.UpdateSize)
                    --
                    local StartingY = ColorPickerOutline_1.AbsolutePosition.Y
                    local MainUIStartingY = Options.MainUI.AbsolutePosition.Y
                    local StartingCanvasPosition = Options.Parent.Parent.CanvasPosition
                    --
                    Library:Connection(ColorPickerOutline_1:GetPropertyChangedSignal("AbsolutePosition"), function()
                        local CurrentY = ColorPickerOutline_1.AbsolutePosition.Y
                        local MainUICurrentY = Options.MainUI.AbsolutePosition.Y
                        local CurrentCanvasPosition = Options.Parent.Parent.CanvasPosition
                        --
                        if MainUICurrentY ~= MainUIStartingY then
                            MainUIStartingY = MainUICurrentY
                            StartingY = CurrentY
                            --
                            return
                        end
                        --
                        if CurrentCanvasPosition ~= StartingCanvasPosition then
                            StartingCanvasPosition = CurrentCanvasPosition
                            StartingY = CurrentY
                            --
                            return
                        end
                        --
                        if Library.UI.Resizing then
                            return
                        end
                        --
                        if CurrentY ~= StartingY then
                            ColorPicker:RemoveFrame(true)
                        end
                        --
                        StartingY = CurrentY
                    end)
                    --
                    Library:Connection(Options.MainUI:GetPropertyChangedSignal("AbsoluteSize"), function()
                        if ColorPicker.Active then
                            ColorPickerOutline.Visible = Library:ScrollingCheck(Options.Parent.Parent, ColorPickerChecker)
                        end
                        --
                        ColorPicker:UpdateSize()
                    end)
                    --
                    if Options.Parent.Parent:IsA("ScrollingFrame") then
                        Library:Connection(Options.Parent.Parent:GetPropertyChangedSignal("CanvasPosition"), function()
                            ColorPicker:UpdateSize()
                            --
                            if ColorPicker.Active then
                                ColorPickerOutline.Visible = Library:ScrollingCheck(Options.Parent.Parent, ColorPickerChecker)
                            end
                        end)
                    end
                    --
                    Library:Connection(Options.MainUI:GetPropertyChangedSignal("Visible"), function()
                        if not Options.MainUI.Visible then
                            ColorPickerOutline.Visible = false
                        else
                            ColorPickerOutline.Visible = ColorPicker.Active
                        end
                    end)
                    --
                    Library:Connection(Options.Parent.Parent:GetPropertyChangedSignal("Visible"), function()
                        if not Options.Parent.Parent.Visible then
                            ColorPickerOutline.Visible = false
                        else
                            ColorPickerOutline.Visible = ColorPicker.Active
                        end
                    end)
                    --
                    function ColorPicker:Update()
                        ColorPicker.Color = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Saturation[1], ColorPicker.Saturation[2])
                        ColorPicker.SecondColor = Color3.fromRGB(math.max(math.floor(ColorPicker.Color.R * 255) - 23, 0), math.max(math.floor(ColorPicker.Color.G * 255) - 23, 0), math.max(math.floor(ColorPicker.Color.B * 255) - 23, 0))
                        --
                        UIGradient_24.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ColorPicker.Color), ColorSequenceKeypoint.new(1, ColorPicker.SecondColor)}
                        UIGradient_20.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ColorPicker.Color), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))}
                        UIGradient_21.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ColorPicker.Color), ColorSequenceKeypoint.new(1, ColorPicker.Color)}
                        UIGradient_20.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromHSV(ColorPicker.Hue, 1, 1)), ColorSequenceKeypoint.new(1.000, Color3.fromRGB(255, 255, 255))}
                        --
                        local MaxSaturationX = math.max(0, MainPickerColor.AbsoluteSize.X - DraggingMainOutline.AbsoluteSize.X) / MainPickerColor.AbsoluteSize.X
                        local MaxSaturationY = math.max(0, MainPickerColor.AbsoluteSize.Y - DraggingMainOutline.AbsoluteSize.Y) / MainPickerColor.AbsoluteSize.Y
                        local MaxAlpha = math.max(0, SaturationColor.AbsoluteSize.X - DraggingSatOutline.AbsoluteSize.X) / SaturationColor.AbsoluteSize.X
                        local MaxHue = math.max(0, BackImage_2.AbsoluteSize.Y - DraggingHueOutline.AbsoluteSize.Y) / BackImage_2.AbsoluteSize.Y
                        --
                        Library:TweenObject(DraggingMainOutline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.fromScale(math.clamp(ColorPicker.Saturation[1], 0, MaxSaturationX), math.clamp(1 - ColorPicker.Saturation[2], 0, MaxSaturationY))})
                        Library:TweenObject(DraggingSatOutline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(1 - ColorPicker.Alpha, 0, MaxAlpha), 0, 0, 0)})
                        Library:TweenObject(DraggingHueOutline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, math.clamp(ColorPicker.Hue, 0, MaxHue), 0)})
                        --
                        DraggingMain.BackgroundColor3 = ColorPicker.Color
                        DraggingSatMain.BackgroundColor3 = ColorPicker.Color
                        DraggingHueMain.BackgroundColor3 = ColorPicker.Color
                        ColorPickerInline_1.BackgroundTransparency = ColorPicker.Alpha
                        UIGradient_21.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0.304 + (0.604 - 0.304) * ColorPicker.Alpha), NumberSequenceKeypoint.new(0.5, 0.7), NumberSequenceKeypoint.new(1, 1)}
                        --
                        Options.Callback(ColorPicker.Color, ColorPicker.Alpha)
                        Library.Flags[Options.Flag] = ColorPicker
                    end
                    --
                    function ColorPicker:Set(Color, Transparency)
                        if typeof(Color) == "table" then
                            ColorPicker.Color = Color3.fromHSV(Color[1], Color[2], Color[3])
                            ColorPicker.Alpha = Color[4]
                            ColorPicker.Hue = Color[1]
                            ColorPicker.Saturation[1] = Color[2]
                            ColorPicker.Saturation[2] = Color[3]
                            ColorPicker:Update()
                            Options.Callback(ColorPicker.Color, ColorPicker.Alpha)
                        elseif typeof(Color) == "Color3" then
                            local h, s, v = Color:ToHSV()
                            --
                            ColorPicker.Color = Color3.fromHSV(h, s, v)
                            ColorPicker.Alpha = Transparency or 1
                            ColorPicker.Hue = h
                            ColorPicker.Saturation[1] = s
                            ColorPicker.Saturation[2] = v
                            ColorPicker:Update()
                            Options.Callback(ColorPicker.Color, ColorPicker.Alpha)
                        end
                    end
                    --
                    function ColorPicker:Get()
                        return {Color = ColorPicker.Color, Transparency = ColorPicker.Alpha}
                    end
                    --
                    function ColorPicker:UpdateHue(Percentage)
                        local Percentage = typeof(Percentage == "number") and math.clamp(Percentage, 0, 1) or 0
                        --
                        ColorPicker.Hue = Percentage
                        --
                        ColorPicker:Update()
                    end
                    --
                    function ColorPicker:UpdateAlpha(Percentage)
                        local Percentage = typeof(Percentage == "number") and math.clamp(Percentage, 0, 1) or 0
                        --
                        ColorPicker.Alpha = Percentage
                        --
                        ColorPicker:Update()
                    end
                    --
                    function ColorPicker:UpdateSaturation(PercentageX, PercentageY)
                        local PercentageX = typeof(PercentageX == "number") and math.clamp(PercentageX, 0, 1) or 0
                        local PercentageY = typeof(PercentageY == "number") and math.clamp(PercentageY, 0, 1) or 0
                        --
                        ColorPicker.Saturation[1] = PercentageX
                        ColorPicker.Saturation[2] = 1 - PercentageY
                        --
                        ColorPicker:Update()
                    end
                end
                --
                do -- Connections
                    Library:Connection(Button_91.InputBegan, function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Library.UI.DraggingGui = MainPickerColor
                            --
                            local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
                            local Percentage = (InputPosition - MainPickerColor.AbsolutePosition) / MainPickerColor.AbsoluteSize
                            --
                            ColorPicker:UpdateSaturation(Percentage.X, Percentage.Y)
                        end
                    end)
                    --
                    Library:Connection(Button_915241.InputBegan, function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Library.UI.DraggingGui = SaturationColor
                            --
                            local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
                            local GuiPosition = SaturationColor.AbsolutePosition.X
                            local GuiSize = SaturationColor.AbsoluteSize.X
                            local Percentage = ((GuiPosition + GuiSize - InputPosition.X) / GuiSize)
                            --
                            ColorPicker:UpdateAlpha(Percentage)
                        end
                    end)
                    --
                    Library:Connection(Button_9141.InputBegan, function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Library.UI.DraggingGui = BackImage_2
                            --
                            local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
                            local Percentage = (InputPosition - BackImage_2.AbsolutePosition) / BackImage_2.AbsoluteSize
                            --
                            ColorPicker:UpdateHue(Percentage.Y)
                        end
                    end)
                    --
                    Library:Connection(UserInputService.InputChanged, function(Input)
                        if (Library.UI.DraggingGui ~= SaturationColor and Library.UI.DraggingGui ~= MainPickerColor and Library.UI.DraggingGui ~= BackImage_2) then return end
                        --
                        if not (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) then
                            Library.UI.DraggingGui = nil
                            return
                        end
                        --
                        local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
                        --
                        if (Input.UserInputType == Enum.UserInputType.MouseMovement) then
                            if Library.UI.DraggingGui == MainPickerColor then
                                local Percentage = (InputPosition - MainPickerColor.AbsolutePosition) / MainPickerColor.AbsoluteSize
                                --
                                ColorPicker:UpdateSaturation(Percentage.X, Percentage.Y)
                            end
                            --
                            if Library.UI.DraggingGui == SaturationColor then
                                local GuiPosition = SaturationColor.AbsolutePosition.X
                                local GuiSize = SaturationColor.AbsoluteSize.X
                                local Percentage = ((GuiPosition + GuiSize - InputPosition.X) / GuiSize)
                                --
                                ColorPicker:UpdateAlpha(Percentage)
                            end
                            --
                            if Library.UI.DraggingGui == BackImage_2 then
                                local Percentage = (InputPosition - BackImage_2.AbsolutePosition) / BackImage_2.AbsoluteSize
                                --
                                ColorPicker:UpdateHue(Percentage.Y)
                            end
                        end
                    end)
                end
                --
                ColorPicker:Update()
                Library:Fade(true, Library:GetObjectsTable(ColorPickerOutline, true), ColorPickerOutline, 0.1)
            end
            --
            function ColorPicker:RemoveFrame(Fast)
                local Fast = Fast or false
                --
                for Index, Value in Library.UI.ScreenGUI:GetChildren() do
                    if Value:IsA("Frame") and Value.Name == "ColorPickerFrame" .. Library.UI.TotalColorPickers then
                        if Fast then
                            Value:Destroy()
                        else
                            Library:Fade(false, Library:GetObjectsTable(Value, true), Value, 0.1)
                            --
                            task.delay(Library.UI.TweenSpeed, function()
                                Value:Destroy()
                            end)
                        end
                    end
                end
            end
            --
            function ColorPicker:FindFrame()
                for Index, Value in Library.UI.ScreenGUI:GetChildren() do
                    if Value:IsA("Frame") and Value.Name == "ColorPickerFrame" .. Library.UI.TotalColorPickers then
                        return true
                    end
                end
                --
                return false
            end
            --
            function ColorPicker:Toggle()
                if Library.UI.CurrentSelectedColorPicker and Library.UI.CurrentSelectedColorPicker.ColorPickerOutline.Name ~= ColorPickerOutline_1.Name then
                    Library.UI.CurrentSelectedColorPicker.ColorPicker:RemoveFrame()
                end
                --
                if not ColorPicker:FindFrame() then
                    ColorPicker.Active = true
                    ColorPicker:AddFrame()
                else
                    ColorPicker.Active = false
                    ColorPicker:RemoveFrame()
                end
            end
            --
            function ColorPicker:AddOtherFrame()
                Library.UI.CurrentSelectedColorPickerExtra = {ColorPicker = ColorPicker, ColorPickerObject = ColorPickerOutline_1, Parent = Options.Parent}
                --
                local KeybindModePickerOutline = Library:CreateObject("Frame", {
                    Name = "ColorPickerOutline" .. Library.UI.TotalColorPickers,
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(0, 100, 0, 55),
                    BorderSizePixel = 0,
                    ZIndex = 25,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = Library.UI.ScreenGUI
                })
                --
                local KeybindModePickerMain = Library:CreateObject("Frame", {
                    Name = "KeybindModePickerMain",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    ZIndex = 25,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    Parent = KeybindModePickerOutline
                })
                --
                KeybindModePickerOutline.BackgroundTransparency = 1
                KeybindModePickerMain.BackgroundTransparency = 1
                --
                local UIListLayout_9 = Library:CreateObject("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = KeybindModePickerMain
                })
                --
                function ColorPicker:UpdateSize()
                    KeybindModePickerOutline.Position = UDim2.new(0, ColorPickerOutline_1.AbsolutePosition.X - 2, 0, ColorPickerOutline_1.AbsolutePosition.Y + ColorPickerOutline_1.AbsoluteSize.Y + KeybindModePickerOutline.AbsoluteSize.Y - 4)
                end
                --
                ColorPicker:UpdateSize()
                --
                Library:Connection(Options.MainUI:GetPropertyChangedSignal("AbsolutePosition"), ColorPicker.UpdateSize)
                --
                local StartingY = ColorPickerOutline_1.AbsolutePosition.Y
                local MainUIStartingY = Options.MainUI.AbsolutePosition.Y
                local StartingCanvasPosition = Options.Parent.Parent.CanvasPosition
                --
                Library:Connection(ColorPickerOutline_1:GetPropertyChangedSignal("AbsolutePosition"), function()
                    local CurrentY = ColorPickerOutline_1.AbsolutePosition.Y
                    local MainUICurrentY = Options.MainUI.AbsolutePosition.Y
                    local CurrentCanvasPosition = Options.Parent.Parent.CanvasPosition
                    --
                    if MainUICurrentY ~= MainUIStartingY then
                        MainUIStartingY = MainUICurrentY
                        StartingY = CurrentY
                        --
                        return
                    end
                    --
                    if CurrentCanvasPosition ~= StartingCanvasPosition then
                        StartingCanvasPosition = CurrentCanvasPosition
                        StartingY = CurrentY
                        --
                        return
                    end
                    --
                    if Library.UI.Resizing then
                        return
                    end
                    --
                    if CurrentY ~= StartingY then
                        ColorPicker:RemoveOtherFrame(true)
                    end
                    --
                    StartingY = CurrentY
                end)
                --
                Library:Connection(Options.MainUI:GetPropertyChangedSignal("AbsoluteSize"), function()
                    if ColorPicker.ActiveFrame then
                        KeybindModePickerOutline.Visible = Library:ScrollingCheck(Options.Parent.Parent, ColorPickerChecker)
                    end
                    --
                    ColorPicker:UpdateSize()
                end)
                --
                if Options.Parent.Parent:IsA("ScrollingFrame") then
                    Library:Connection(Options.Parent.Parent:GetPropertyChangedSignal("CanvasPosition"), function()
                        ColorPicker:UpdateSize()
                        --
                        if ColorPicker.ActiveFrame then
                            KeybindModePickerOutline.Visible = Library:ScrollingCheck(Options.Parent.Parent, ColorPickerChecker)
                        end
                    end)
                end
                --
                for Index, Value in {"Copy", "Paste", "Reset"} do
                    local ModeItem = {
                        Active = false,
                        Hovering = false,
                    }
                    --
                    local Inactive = Library:CreateObject("TextLabel", {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                        TextColor3 = Color3.fromRGB(208, 208, 208),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Name = Value,
                        Text = Value,
                        RichText = true,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Size = UDim2.new(1, 0, 0, 17),
                        BorderSizePixel = 0,
                        TextSize = Library.UI.FontSize,
                        ZIndex = 25,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = KeybindModePickerMain
                    })
                    --
                    local Button_4 = Library:CreateObject("TextButton", {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Name = "Button_4",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        TextTransparency = 1,
                        TextSize = Library.UI.FontSize,
                        ZIndex = 25,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = Inactive
                    })
                    --
                    local UIPadding_48 = Library:CreateObject("UIPadding", {
                        PaddingLeft = UDim.new(0, 8),
                        Parent = Inactive
                    })
                    --
                    Inactive.TextTransparency = 1
                    --
                    do -- Functions
                        function ModeItem:Activate()
                            if not ModeItem.Active then
                                ModeItem.Active = true
                                --
                                Inactive.Text = "<b>" .. Value .. "</b>"
                                Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.Default.Accent})
                                --
                                if Value == "Copy" then
                                    Library.UI.LastCopiedColor = {Color = ColorPicker.Color, Alpha = ColorPicker.Alpha}
                                elseif Value == "Paste" then
                                    if Library.UI.LastCopiedColor then
                                        ColorPicker:Set(Library.UI.LastCopiedColor.Color, Library.UI.LastCopiedColor.Alpha)
                                    end
                                elseif Value == "Reset" then
                                    ColorPicker:Set(Options.Default, Options.Alpha)
                                end
                                --
                                ColorPicker:RemoveOtherFrame()
                            end
                        end
                        --
                        function ModeItem:Deactivate()
                            if ModeItem.Active then
                                ModeItem.Active = false
                                ModeItem.Hovering = false
                                Inactive.Text = Value
                                Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(205, 205, 205)})
                            end
                        end
                    end
                    --
                    do -- Connections
                        Library:Connection(Button_4.MouseButton1Click, function()
                            ModeItem:Activate()
                        end)
                        --
                        Library:Connection(Inactive.MouseEnter, function()
                            Inactive.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                            --
                            if ModeItem.Active then return end
                            --
                            Inactive.Text = "<b>" .. Value .. "</b>"
                        end)
                        --
                        Library:Connection(Inactive.MouseLeave, function()
                            Inactive.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                            --
                            if ModeItem.Active then return end
                            --
                            Inactive.Text = Value
                            Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(205, 205, 205)})
                        end)
                    end
                end
                --
                Library:Fade(true, Library:GetObjectsTable(KeybindModePickerOutline, true), KeybindModePickerOutline, 0.1)
            end
            --
            function ColorPicker:RemoveOtherFrame(Fast)
                local Fast = Fast or false
                --
                for Index, Value in Library.UI.ScreenGUI:GetChildren() do
                    if Value:IsA("Frame") and Value.Name == "ColorPickerOutline" .. Library.UI.TotalColorPickers then
                        if Fast then
                            Value:Destroy()
                        else
                            Library:Fade(false, Library:GetObjectsTable(Value, true), Value, 0.1)
                            --
                            task.delay(Library.UI.TweenSpeed, function()
                                Value:Destroy()
                            end)
                        end
                    end
                end
            end
            --
            function ColorPicker:FindOtherFrame()
                for Index, Value in Library.UI.ScreenGUI:GetChildren() do
                    if Value:IsA("Frame") and Value.Name == "ColorPickerOutline" .. Library.UI.TotalColorPickers then
                        return true
                    end
                end
                --
                return false
            end
            --
            function ColorPicker:ToggleOtherFrame()
                if Library.UI.CurrentSelectedColorPickerExtra and Library.UI.CurrentSelectedColorPickerExtra.ColorPickerObject.Name ~= ColorPickerOutline_1.Name then
                    Library.UI.CurrentSelectedColorPickerExtra.ColorPicker:RemoveFrame()
                end
                --
                if not ColorPicker:FindOtherFrame() then
                    ColorPicker.ActiveFrame = true
                    ColorPicker:AddOtherFrame()
                else
                    ColorPicker.ActiveFrame = false
                    ColorPicker:RemoveOtherFrame()
                end
            end
        end
        --
        do -- Connections
            Library:Connection(Button_9.MouseButton2Click, function()
                ColorPicker:ToggleOtherFrame()
            end)
            --
            Library:Connection(Button_9.MouseButton1Click, function()
                ColorPicker:Toggle()
            end)
        end
        --
        ColorPicker:AddFrame()
        ColorPicker:Update()
        ColorPicker:RemoveFrame()
        --
        return ColorPicker
    end
    --
    function Library:Keybind(Options)
        Options = Library:Validate({
            Default = Enum.KeyCode.Backspace,
            Mode = "Toggle",
            UseMode = true,
            HideFromList = false,
            Blacklisted = {},
            Parent = nil,
            Toggle = nil,
            MainUI = nil,
            Hiding = false,
            ToggleState = false,
            Flag = Library.NewFlag(),
            Count = 1,
            ChangeToggle = false,
            Callback = function() end,
        }, Options or {})
        --
        if Options.Toggle == nil then return end
        --
        local Keybind = {
            Hover = false,
            ActiveFrame = false,
            Keybind = Options.Default,
            RegKeybind = nil,
            State = false,
            SelectingKeybind = false,
            Toggle = false,
            Connection = nil,
            Mode = Options.Mode,
            ConfigKeybind = nil,
            Current = {},
            CurrentMode = nil,
            Hiding = false,
        }
        --
        Library.Flags[Options.Flag] = Keybind
        Library.UI.TotalKeybindModes += 1
        --
        local KeybindObject = Library:CreateObject("TextLabel", {
            FontFace = Font.new("rbxassetid://12187371840", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(117, 117, 117),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = "[-]",
            Name = "KeybindOutline" .. Library.UI.TotalKeybindModes,
            AnchorPoint = Vector2.new(1, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 16, 0, 7),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, 0 - (Options.Count - 1) * 22, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 3,
            TextStrokeTransparency = 0,
            TextSize = 9,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Options.Parent
        })
        --
        local KeybindChecker = Library:CreateObject("Frame", {
            Position = UDim2.new(0, 0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 0, 0, 1),
            Visible = false,
            BorderSizePixel = 0,
            Parent = KeybindObject
        })
        --
        local Button_4 = Library:CreateObject("TextButton", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Button_4",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            TextTransparency = 1,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = KeybindObject
        })
        --
        local UserInputTypeBinds = {"MouseButton1", "MouseButton2", "MouseButton3"}
        --
        do -- Functions
            function Keybind:SetVisible(Bool)
                local OldValues = Library.Objects[KeybindObject]
                --
                Keybind.Hiding = not Bool
                --
                if Bool then
                    Library.Objects[KeybindObject] = {KeybindObject, OldValues[2], true}
                end
                --
                Library:Fade(Bool, Library:GetObjectsTable(KeybindObject), KeybindObject, 0.075)
                Library:TweenObject(KeybindObject, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Bool and UDim2.new(1, 0, 0, 8) or UDim2.new(1, 0, 0, -10)}, function()
                    if not Bool then
                        Library.Objects[KeybindObject] = {KeybindObject, OldValues[2], false}
                    end
                end)
            end
            --
            function Keybind:Set(Key)
                if Keybind.Hiding then return end
                if typeof(Key) == "boolean" then return end
                --
                if typeof(Key) == "EnumItem" then
                    Keybind.RegKeybind = Key
                elseif typeof(Key) == "string" then
                    if table.find(UserInputTypeBinds, Key) then
                        Keybind.RegKeybind = Enum.UserInputType[Key]
                        Key = Enum.UserInputType[Key]
                    else
                        Keybind.RegKeybind = Enum.KeyCode[Key]
                        Key = Enum.KeyCode[Key]
                    end
                end
                --
                if typeof(Key) == "string" then
                    if Key:find("KEY") then
                        Key = Enum.KeyCode[Key:gsub("KEY_", "")]
                    elseif Key:find("Input") then
                        Key = Enum.UserInputType[Key:gsub("Input_", "")]
                    end
                end
                --
                local ValidKey = false
                local KeyString = ""
                --
                if table.find(Options.Blacklisted, Key) then
                    Key = nil
                end
                --
                if Key then
                    if ((Key.EnumType == Enum.KeyCode and UserInputService:GetStringForKeyCode(Key) ~= "") or Library.UI.Keys[Key]) then
                        ValidKey = true
                        KeyString = Library.UI.Keys[Key] or UserInputService:GetStringForKeyCode(Key)
                    end
                end
                --
                if ValidKey then
                    Keybind.Keybind = KeyString
                    KeybindObject.Text = "[" .. KeyString:upper() .. "]"
                    --
                    Options.Callback(Key)
                    Library.Flags[Options.Flag] = Keybind
                else
                    Keybind.Keybind = "[-]"
                    KeybindObject.Text = Keybind.Keybind
                end
                --
                Library:TweenObject(KeybindObject, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(117, 117, 117)})
                KeybindObject.Size = UDim2.new(0, KeybindObject.TextBounds.X + 2, 0, 7)
            end
            --
            function Keybind:Toggle(Bool)
                if Keybind.Hiding then return end
                --
                if Bool == nil then
                    Keybind.State = not Keybind.State
                else
                    Keybind.State = Bool
                end
                --
                if not Options.HideFromList then
                    if Keybind.State then
                        --Library:AddKeybindFrame(Keybind.Mode, Options.Toggle:GetName(), Keybind.Keybind, Options.Toggle:GetSection())
                    else
                        --Library:RemoveKeybindFrame(Options.Toggle:GetName(), Options.Toggle:GetSection())
                    end
                end
                --
                if Options.Toggle.GetFlag then
                    Library.Flags[Options.Toggle:GetFlag()] = Keybind
                end
                --
                if Options.ChangeToggle then
                    -- viuslaly toggle the UI element and update its state
                    Options.Toggle:Set(Keybind.State)
                else
                    Options.Toggle:GetCallback(Keybind.State)
                end
            end
            --
            task.delay(1, function()
                Keybind:Set(Options.Default)
            end)
            --
            function Keybind:Get()
                local KeyString = Keybind.RegKeybind.EnumType == Enum.KeyCode and tostring(Keybind.RegKeybind):match("^Enum%.KeyCode%.(.+)$") or tostring(Keybind.RegKeybind):match("^Enum%.UserInputType%.(.+)$")
                --
                return KeyString
            end
            --
            function Keybind:Active()
                return (Keybind.Keybind:lower() == "[-]" and true or Keybind.State)
            end
            --
            if Options.Mode == "Always on" then
                Keybind:Toggle(true)
            end
            --
            function Keybind:SetMode(Mode)
                Keybind.Mode = Mode
                --
                if Mode == "Always on" then
                    if Mode == "Always on" then
                        Keybind:Toggle(true)
                    end
                    --
                    if not Keybind.State then
                        Keybind.State = true
                        --
                        --Library:AddKeybindFrame(Mode, Options.Toggle:GetName(), Keybind.Keybind, Options.Toggle:GetSection())
                    else
                        --Library:UpdateKeybindFrame(Mode, Options.Toggle:GetName(), Keybind.Keybind, Options.Toggle:GetSection())
                    end
                elseif Mode == "Toggle" then
                    if Keybind.State then
                        --Library:UpdateKeybindFrame(Mode, Options.Toggle:GetName(), Keybind.Keybind, Options.Toggle:GetSection())
                    end
                elseif Mode == "On hotkey" then
                    Keybind.State = false
                    --
                    --Library:RemoveKeybindFrame(Options.Toggle:GetName(), Options.Toggle:GetSection())
                end
            end
            --
            function Keybind:AddFrame()
                Library.UI.CurrentSelectedKeybindMode = {Keybind = Keybind, KeybindObject = KeybindObject, Parent = Options.Parent}
                --
                local KeybindModePickerOutline = Library:CreateObject("Frame", {
                    Name = "KeybindModePickerOutline" .. Library.UI.TotalKeybindModes,
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(0, 100, 0, 55),
                    BorderSizePixel = 0,
                    ZIndex = 25,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = Library.UI.ScreenGUI
                })
                --
                local KeybindModePickerMain = Library:CreateObject("Frame", {
                    Name = "KeybindModePickerMain",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    ZIndex = 25,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    Parent = KeybindModePickerOutline
                })
                --
                KeybindModePickerOutline.BackgroundTransparency = 1
                KeybindModePickerMain.BackgroundTransparency = 1
                --
                local UIListLayout_9 = Library:CreateObject("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = KeybindModePickerMain
                })
                --
                function Keybind:UpdateSize()
                    KeybindModePickerOutline.Position = UDim2.new(0, KeybindObject.AbsolutePosition.X , 0, KeybindObject.AbsolutePosition.Y + KeybindObject.AbsoluteSize.Y + KeybindModePickerOutline.AbsoluteSize.Y - 2)
                end
                --
                Keybind:UpdateSize()
                --
                Library:Connection(Options.MainUI:GetPropertyChangedSignal("AbsolutePosition"), Keybind.UpdateSize)
                --
                local StartingY = KeybindObject.AbsolutePosition.Y
                local MainUIStartingY = Options.MainUI.AbsolutePosition.Y
                local StartingCanvasPosition = Options.Parent.Parent.CanvasPosition
                --
                Library:Connection(KeybindObject:GetPropertyChangedSignal("AbsolutePosition"), function()
                    local CurrentY = KeybindObject.AbsolutePosition.Y
                    local MainUICurrentY = Options.MainUI.AbsolutePosition.Y
                    local CurrentCanvasPosition = Options.Parent.Parent.CanvasPosition
                    --
                    if MainUICurrentY ~= MainUIStartingY then
                        MainUIStartingY = MainUICurrentY
                        StartingY = CurrentY
                        --
                        return
                    end
                    --
                    if CurrentCanvasPosition ~= StartingCanvasPosition then
                        StartingCanvasPosition = CurrentCanvasPosition
                        StartingY = CurrentY
                        --
                        return
                    end
                    --
                    if Library.UI.Resizing then
                        return
                    end
                    --
                    if CurrentY ~= StartingY then
                        Keybind:RemoveFrame(true)
                    end
                    --
                    StartingY = CurrentY
                end)
                --
                Library:Connection(Options.MainUI:GetPropertyChangedSignal("AbsoluteSize"), function()
                    if Keybind.ActiveFrame then
                        KeybindModePickerOutline.Visible = Library:ScrollingCheck(Options.Parent.Parent, KeybindChecker)
                    end
                    --
                    Keybind:UpdateSize()
                end)
                --
                Library:Connection(KeybindObject:GetPropertyChangedSignal("AbsoluteSize"), function()
                    Keybind:UpdateSize()
                end)
                --
                if Options.Parent.Parent:IsA("ScrollingFrame") then
                    Library:Connection(Options.Parent.Parent:GetPropertyChangedSignal("CanvasPosition"), function()
                        Keybind:UpdateSize()
                        --
                        if Keybind.ActiveFrame then
                            KeybindModePickerOutline.Visible = Library:ScrollingCheck(Options.Parent.Parent, KeybindChecker)
                        end
                    end)
                end
                --
                for Index, Value in {"Always on", "On hotkey", "Toggle"} do
                    local ModeItem = {
                        Active = false,
                        Hovering = false,
                    }
                    --
                    local Inactive = Library:CreateObject("TextLabel", {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                        TextColor3 = Color3.fromRGB(208, 208, 208),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Name = Value,
                        Text = Value,
                        RichText = true,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Size = UDim2.new(1, 0, 0, 17),
                        BorderSizePixel = 0,
                        TextSize = Library.UI.FontSize,
                        ZIndex = 25,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = KeybindModePickerMain
                    })
                    --
                    local Button_4 = Library:CreateObject("TextButton", {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Name = "Button_4",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        TextTransparency = 1,
                        TextSize = Library.UI.FontSize,
                        ZIndex = 25,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = Inactive
                    })
                    --
                    local UIPadding_48 = Library:CreateObject("UIPadding", {
                        PaddingLeft = UDim.new(0, 8),
                        Parent = Inactive
                    })
                    --
                    Inactive.TextTransparency = 1
                    --
                    do -- Functions
                        function ModeItem:Activate()
                            if not ModeItem.Active then
                                if Keybind.CurrentMode ~= nil then
                                    Keybind.CurrentMode:Deactivate()
                                end
                                --
                                ModeItem.Active = true
                                --
                                Keybind.Mode = Value
                                Keybind.CurrentMode = ModeItem
                                --
                                Inactive.Text = "<b>" .. Value .. "</b>"
                                Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.Default.Accent})
                                --
                                if Value == "Always on" then
                                    if Keybind.Mode == "Always on" then
                                        Keybind:Toggle(true)
                                    end
                                    --
                                    if not Keybind.State then
                                        Keybind.State = true
                                        --
                                        --Library:AddKeybindFrame(Value, Options.Toggle:GetName(), Keybind.Keybind, Options.Toggle:GetSection())
                                    else
                                        --Library:UpdateKeybindFrame(Value, Options.Toggle:GetName(), Keybind.Keybind, Options.Toggle:GetSection())
                                    end
                                elseif Value == "Toggle" then
                                    if Keybind.State then
                                        --Library:UpdateKeybindFrame(Value, Options.Toggle:GetName(), Keybind.Keybind, Options.Toggle:GetSection())
                                    end
                                elseif Value == "On hotkey" then
                                    Keybind.State = false
                                    --
                                    --Library:RemoveKeybindFrame(Options.Toggle:GetName(), Options.Toggle:GetSection())
                                end
                            end
                        end
                        --
                        function ModeItem:Deactivate()
                            if ModeItem.Active then
                                ModeItem.Active = false
                                ModeItem.Hovering = false
                                Inactive.Text = Value
                                Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(205, 205, 205)})
                            end
                        end
                    end
                    --
                    do -- Connections
                        Library:Connection(Button_4.MouseButton1Click, function()
                            ModeItem:Activate()
                        end)
                        --
                        Library:Connection(Inactive.MouseEnter, function()
                            Inactive.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                            --
                            if ModeItem.Active then return end
                            --
                            Inactive.Text = "<b>" .. Value .. "</b>"
                        end)
                        --
                        Library:Connection(Inactive.MouseLeave, function()
                            Inactive.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                            --
                            if ModeItem.Active then return end
                            --
                            Inactive.Text = Value
                            Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(205, 205, 205)})
                        end)
                    end
                    --
                    if Value == Keybind.Mode then
                        ModeItem:Activate()
                    end
                end
                --
                Library:Fade(true, Library:GetObjectsTable(KeybindModePickerOutline, true), KeybindModePickerOutline, 0.1)
            end
            --
            function Keybind:RemoveFrame(Fast)
                local Fast = Fast or false
                --
                for Index, Value in Library.UI.ScreenGUI:GetChildren() do
                    if Value:IsA("Frame") and Value.Name == "KeybindModePickerOutline" .. Library.UI.TotalKeybindModes then
                        if Fast then
                            Value:Destroy()
                        else
                            Library:Fade(false, Library:GetObjectsTable(Value, true), Value, 0.1)
                            --
                            task.delay(Library.UI.TweenSpeed, function()
                                Value:Destroy()
                            end)
                        end
                    end
                end
            end
            --
            function Keybind:FindFrame()
                for Index, Value in Library.UI.ScreenGUI:GetChildren() do
                    if Value:IsA("Frame") and Value.Name == "KeybindModePickerOutline" .. Library.UI.TotalKeybindModes then
                        return true
                    end
                end
                --
                return false
            end
            --
            function Keybind:ToggleFrame()
                Library:TweenObject(KeybindObject, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(176, 176, 176)})
                --
                if Library.UI.CurrentSelectedKeybindMode and Library.UI.CurrentSelectedKeybindMode.KeybindObject.Name ~= KeybindObject.Name then
                    Library.UI.CurrentSelectedKeybindMode.Keybind:RemoveFrame()
                    --
                    Library:TweenObject(Library.UI.CurrentSelectedKeybindMode.KeybindObject, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(117, 117, 117)})
                end
                --
                if not Keybind:FindFrame() then
                    Keybind.ActiveFrame = true
                    Keybind:AddFrame()
                else
                    Keybind.ActiveFrame = false
                    Keybind:RemoveFrame()
                end
            end
        end
        --
        do -- Connections
            Library:Connection(KeybindObject.MouseEnter, function()
                if Keybind.SelectingKeybind then return end
                --
                Library:TweenObject(KeybindObject, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(176, 176, 176)})
            end)
            --
            Library:Connection(KeybindObject.MouseLeave, function()
                if Keybind.SelectingKeybind then return end
                --
                Library:TweenObject(KeybindObject, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(117, 117, 117)})
            end)
            --
            Library:Connection(Button_4.MouseButton2Click, function()
                if not Options.UseMode then return end
                --
                Keybind:ToggleFrame()
            end)
            --
            Library:Connection(Button_4.MouseButton1Click, function()
                if Keybind.Connection then
                    Keybind.Connection:Disconnect()
                end
                --
                Keybind.SelectingKeybind = true
                --
                Library:TweenObject(KeybindObject, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 0, 0)})
                --
                Keybind.Connection = Library:Connection(UserInputService.InputBegan, function(Input)
                    Keybind:Set(Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode or Input.UserInputType)
                    --
                    if Keybind.Connection then
                        Keybind.Connection:Disconnect()
                        --
                        task.delay(0.1, function()
                            Keybind.Connection = nil
                            Keybind.SelectingKeybind = false
                        end)
                    end
                end)
            end)
            --
            Library:Connection(UserInputService.InputBegan, function(Input, Proccessed)
                if Proccessed then return end
                --
                if (Input.UserInputType == Enum.UserInputType.Keyboard and Keybind.Keybind ~= "[-]" and Input.KeyCode == Keybind.RegKeybind) or (Input.UserInputType == Enum.UserInputType.MouseButton1 and Keybind.Keybind == "MB1") or (Input.UserInputType == Enum.UserInputType.MouseButton2 and Keybind.Keybind == "MB2") or (Input.UserInputType == Enum.UserInputType.MouseButton3 and Keybind.Keybind == "MMB") then
                    if Keybind.Mode == "Always on" then
                        Keybind:Toggle(true)
                    else
                        Keybind:Toggle()
                    end
                end
            end)
            --
            Library:Connection(UserInputService.InputEnded, function(Input, Proccessed)
                if Proccessed then return end
                --
                if Keybind.Mode == "On hotkey" then
                    if (Input.UserInputType == Enum.UserInputType.Keyboard and Keybind.Keybind ~= "[-]" and Input.KeyCode == Keybind.RegKeybind) or (Input.UserInputType == Enum.UserInputType.MouseButton1 and Keybind.Keybind == "MB1") or (Input.UserInputType == Enum.UserInputType.MouseButton2 and Keybind.Keybind == "MB2") or (Input.UserInputType == Enum.UserInputType.MouseButton3 and Keybind.Keybind == "MMB") then
                        Keybind:Toggle()
                    end
                end
            end)
        end
        --
        if Options.Hiding then
            Keybind:SetVisible(false)
        end
        --
        return Keybind
    end
    --
    function Library:MultiBox(Options)
        Options = Library:Validate({
            Default = "None",
            Name = "Preview MultiBox",
            Content = {},
            Parent = nil,
            MainUI = nil,
            Hiding = false,
            TabUI = nil,
            Risky = false,
            Flag = Library.NewFlag(),
            Callback = function() end
        }, Options or {})
        --
        local MultiBox = {
            Open = false,
            Hover = false,
            Items = Options.Content,
            Scrollable = false,
            Value = {},
            SelectedOrder = {},
            AllItems = {},
        }
        --
        Library.Flags[Options.Flag] = MultiBox
        Options.Callback(Options.Default)
        --
        local PreviewMultiBox_5 = Library:CreateObject("Frame", {
            Name = "PreviewMultiBox_5",
            BackgroundTransparency = 1,
            Size = Options.Name == "" and UDim2.new(1, 0, 0, 20) or UDim2.new(1, 0, 0, 31),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Options.Parent
        })
        --
        local MultiBoxOutline_5 = Library:CreateObject("Frame", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(0, 1),
            Name = "MultiBoxOutline_5",
            Position = UDim2.new(0, -1, 1, 0),
            Size = UDim2.new(1, -19, 0, 20),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = PreviewMultiBox_5
        })
        --
        local MultiBoxChecker = Library:CreateObject("Frame", {
            Name = "MultiBoxChecker",
            Position = UDim2.new(0, 0, 1, 0),
            Visible = false,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 0, 0, 1),
            BorderSizePixel = 0,
            Parent = MultiBoxOutline_5
        })
        --
        local MultiBoxBack_5 = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "MultiBoxBack_5",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(220, 220, 220),
            Parent = MultiBoxOutline_5
        })
        --
        local MultiBoxArrow = Library:CreateObject("ImageLabel", {
            ImageColor3 = Color3.fromRGB(151, 151, 151),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "MultiBoxArrow",
            Image = "rbxassetid://15556784588",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -11, 0, 6),
            Size = UDim2.new(0, 5, 0, 4),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = MultiBoxBack_5
        })
        --
        local UIGradient_34 = Library:CreateObject("UIGradient", {
            Rotation = -90,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(39, 39, 39)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
            },
            Parent = MultiBoxBack_5
        })
        --
        local MultiBoxValue_5 = Library:CreateObject("TextLabel", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(152, 152, 152),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = "None",
            Name = "MultiBoxValue_5",
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 3,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = MultiBoxBack_5
        })
        --
        local UIPadding_87 = Library:CreateObject("UIPadding", {
            PaddingLeft = UDim.new(0, 5),
            Parent = MultiBoxValue_5
        })
        --
        local Button_44 = Library:CreateObject("TextButton", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Button_44",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            TextTransparency = 1,
            TextSize = 14,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = MultiBoxOutline_5
        })
        --
        local MultiBoxName_5 = Library:CreateObject("TextLabel", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Library.Theme.Default.TextColor,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = Options.Name,
            Name = "MultiBoxName_5",
            ZIndex = 3,
            Size = UDim2.new(1, -19, 1, 0),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, -4),
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = PreviewMultiBox_5
        })
        --
        local UIPadding_88 = Library:CreateObject("UIPadding", {
            PaddingLeft = UDim.new(0, 20),
            Parent = PreviewMultiBox_5
        })
        --
        local MultiBoxMainOutline = Library:CreateObject("Frame", {
            Name = "MultiBoxMainOutline",
            Position = UDim2.new(0, 0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 10,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = Library.UI.ScreenGUI
        })
        --
        local MultiBoxMain = Library:CreateObject("Frame", {
            Name = "MultiBoxMain",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -2, 1, -2),
            BorderSizePixel = 0,
            ZIndex = 10,
            ClipsDescendants = true,
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            Parent = MultiBoxMainOutline
        })
        --
        MultiBoxMainOutline.BackgroundTransparency = 1
        MultiBoxMain.BackgroundTransparency = 1
        --
        local UIListLayout_9 = Library:CreateObject("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = MultiBoxMain
        })
        --
        do -- Functions
            function MultiBox:Set(Values)
                for Index, Item in MultiBox.AllItems do
                    if not table.find(Values, Index) then
                        MultiBox.Items[Index] = false
                    else
                        MultiBox.Items[Index] = true
                    end
                    --
                    Item:Toggle()
                end
            end
            --
            function MultiBox:Get()
                return MultiBox.Value
            end
            --
            function MultiBox:SetVisible(Bool)
                local OldValues = Library.Objects[PreviewMultiBox_5]
                --
                MultiBox.Hiding = not Bool
                --
                if Bool then
                    Library.Objects[PreviewMultiBox_5] = {PreviewMultiBox_5, OldValues[2], true}
                end
                --
                Library:Fade(Bool, Library:GetObjectsTable(PreviewMultiBox_5), PreviewMultiBox_5, 0.075)
                Library:TweenObject(PreviewMultiBox_5, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Bool and (Options.Name == "" and UDim2.new(1, 0, 0, 20) or UDim2.new(1, 0, 0, 31)) or UDim2.new(1, 0, 0, -10)}, function()
                    if not Bool then
                        Library.Objects[PreviewMultiBox_5] = {PreviewMultiBox_5, OldValues[2], false}
                    end
                end)
            end
            --
            function MultiBox:AddValue(Value)
                local Item = {
                    Active = false,
                    Hovering = false,
                }
                --
                MultiBox.Items[Value] = Item
                --
                local Inactive = Library:CreateObject("TextLabel", {
                    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    TextColor3 = Color3.fromRGB(208, 208, 208),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = Value,
                    Text = Value,
                    RichText = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = Library.UI.FontSize,
                    ZIndex = 10,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    Parent = MultiBoxMain
                })
                --
                local Button_4 = Library:CreateObject("TextButton", {
                    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "Button_4",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextTransparency = 1,
                    TextSize = Library.UI.FontSize,
                    ZIndex = 11,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = Inactive
                })
                --
                local UIPadding_48 = Library:CreateObject("UIPadding", {
                    PaddingLeft = UDim.new(0, 8),
                    Parent = Inactive
                })
                --
                Inactive.TextTransparency = 1
                --
                do -- Functions
                    function Item:GetSelectedItems()
                        local SelectedItems = {}
                        --
                        for _, Item in MultiBox.SelectedOrder do
                            if MultiBox.Items[Item] then
                                table.insert(SelectedItems, Item)
                            end
                        end
                        --
                        return SelectedItems
                    end
                    --
                    function MultiBox:UpdateValue()
                        MultiBox.Value = Item:GetSelectedItems()
                        --
                        MultiBoxValue_5.Text = Library:ClampString(table.concat(MultiBox.Value, ", "), MultiBoxMain.AbsoluteSize.X - MultiBoxArrow.AbsoluteSize.X - 4)
                    end
                    --
                    function Item:SelectItem(Item)
                        if not table.find(MultiBox.SelectedOrder, Item) then
                            table.insert(MultiBox.SelectedOrder, Item)
                        end
                        --
                        MultiBox:UpdateValue()
                    end

                    function Item:DeselectItem(Item)
                        for Index, Value in MultiBox.SelectedOrder do
                            if Value == Item then
                                table.remove(MultiBox.SelectedOrder, Index)
                                --
                                break
                            end
                        end
                        --
                        MultiBox:UpdateValue()
                    end
                    --
                    function Item:Activate()
                        if not Item.Active then
                            Item.Active = true
                            MultiBox.CurrentItem = Item
                            MultiBox.Items[Value] = true
                            Library.Flags[Options.Flag] = MultiBox
                            Item:SelectItem(Value)
                            Options.Callback(MultiBox.Value)
                            --
                            Inactive.Text = "<b>" .. Value .. "</b>"
                            Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.Default.Accent})
                            Library:AddTheme(Inactive, {
                                TextColor3 = "Accent",
                            })
                        end
                    end
                    --
                    function Item:Deactivate()
                        if Item.Active then
                            Item.Active = false
                            Item.Hovering = false
                            MultiBox.CurrentItem = nil
                            Library.Flags[Options.Flag] = MultiBox
                            MultiBox.Items[Value] = false
                            Item:DeselectItem(Value)
                            Options.Callback(MultiBox.Value)
                            --
                            Inactive.Text = Value
                            Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(205, 205, 205)})
                            Library:AddTheme(Inactive, {
                                TextColor3 = "TextColor",
                            })
                        end
                    end
                    --
                    function Item:Toggle()
                        MultiBox.Items[Value] = not MultiBox.Items[Value]
                        --
                        if MultiBox.Items[Value] then
                            Item:Activate()
                        else
                            Item:Deactivate()
                        end
                    end
                end
                --
                do -- Connections
                    Library:Connection(Button_4.MouseButton1Click, function()
                        if MultiBox.Hiding then return end
                        --
                        Item:Toggle()
                    end)
                    --
                    Library:Connection(Inactive.MouseEnter, function()
                        Inactive.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                        --
                        if Item.Active then return end
                        --
                        Inactive.Text = "<b>" .. Value .. "</b>"
                    end)
                    --
                    Library:Connection(Inactive.MouseLeave, function()
                        Inactive.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                        --
                        if Item.Active then return end
                        --
                        Inactive.Text = Value
                        Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(205, 205, 205)})
                    end)
                end
                --
                if typeof(Options.Default) == "table" and table.find(Options.Default, Value) then
                    Item:Activate()
                    Item:SelectItem(Value)
                else
                    MultiBox.Items[Value] = false
                end
            end
            --
            function MultiBox:Toggle(Fast)
                local Fast = Fast or false
                local OldValues = Library.Objects[MultiBoxMainOutline]
                --
                if MultiBox.Open then
                    if Fast then
                        Library:Fade(false, Library:GetObjectsTable(MultiBoxMainOutline, true), MultiBoxMainOutline, 0)
                        MultiBoxMainOutline.Size = UDim2.new(0, MultiBoxOutline_5.AbsoluteSize.X, 0, 0)
                        Library.Objects[MultiBoxMainOutline] = {MultiBoxMainOutline, OldValues[2], true}
                    else
                        Library:Fade(false, Library:GetObjectsTable(MultiBoxMainOutline, true), MultiBoxMainOutline, 0.1)
                        Library:TweenObject(MultiBoxMainOutline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, MultiBoxOutline_5.AbsoluteSize.X, 0, 0)}, function()
                            Library.Objects[MultiBoxMainOutline] = {MultiBoxMainOutline, OldValues[2], true}
                        end)
                    end
                else
                    Library.Objects[MultiBoxMainOutline] = {MultiBoxMainOutline, OldValues[2], false}
                    --
                    if Fast then
                        Library:Fade(true, Library:GetObjectsTable(MultiBoxMainOutline, true), MultiBoxMainOutline, 0)
                        MultiBoxMainOutline.Size = UDim2.new(0, MultiBoxOutline_5.AbsoluteSize.X, 0, (#Options.Content * 20) + 2)
                    else
                        Library:Fade(true, Library:GetObjectsTable(MultiBoxMainOutline, true), MultiBoxMainOutline, 0.1)
                        Library:TweenObject(MultiBoxMainOutline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, MultiBoxOutline_5.AbsoluteSize.X, 0, (#Options.Content * 20) + 2)})
                    end	
                end
                --
                MultiBox.Open = not MultiBox.Open
            end
            --
            function MultiBox:Update()
                MultiBoxMainOutline.Size = UDim2.new(0, MultiBoxOutline_5.AbsoluteSize.X, 0, MultiBoxMainOutline.AbsoluteSize.Y)
                MultiBoxMainOutline.Position = UDim2.new(0, MultiBoxOutline_5.AbsolutePosition.X, 0, ((MultiBoxOutline_5.AbsolutePosition.Y + MultiBoxOutline_5.AbsoluteSize.Y) + GuiService:GetGuiInset().Y + 2))
                --
                if MultiBox.Open then
                    MultiBoxMainOutline.Visible = Library:ScrollingCheck(Options.Parent, MultiBoxChecker)
                end
            end
            --
            MultiBox:Update()
            --
            Library:Connection(MultiBoxOutline_5:GetPropertyChangedSignal("AbsolutePosition"), MultiBox.Update)
            Library:Connection(MultiBoxOutline_5:GetPropertyChangedSignal("AbsoluteSize"), MultiBox.Update)
            --
            local StartingX = PreviewMultiBox_5.AbsolutePosition.X
            local StartingY = PreviewMultiBox_5.AbsolutePosition.Y
            local MainUIStartingX = Options.MainUI.AbsolutePosition.X
            local MainUIStartingY = Options.MainUI.AbsolutePosition.Y
            local StartingCanvasPosition = Options.Parent.CanvasPosition
            --
            Library:Connection(PreviewMultiBox_5:GetPropertyChangedSignal("AbsolutePosition"), function()
                if not MultiBox.Open then return end
                --
                local CurrentX = PreviewMultiBox_5.AbsolutePosition.X
                local CurrentY = PreviewMultiBox_5.AbsolutePosition.Y
                local MainUICurrentX = Options.MainUI.AbsolutePosition.X
                local MainUICurrentY = Options.MainUI.AbsolutePosition.Y
                local CurrentCanvasPosition = Options.Parent.CanvasPosition
                --
                if MainUICurrentX ~= MainUIStartingX or MainUICurrentY ~= MainUIStartingY then
                    MainUIStartingX = MainUICurrentX
                    MainUIStartingY = MainUICurrentY
                    StartingX = CurrentX
                    StartingY = CurrentY
                    --
                    return
                end
                --
                if CurrentCanvasPosition ~= StartingCanvasPosition then
                    StartingCanvasPosition = CurrentCanvasPosition
                    StartingX = CurrentX
                    StartingY = CurrentY
                    --
                    return
                end
                --
                if Library.UI.Resizing then
                    return
                end
                --
                if CurrentX ~= StartingX or CurrentY ~= StartingY then
                    MultiBox:Toggle(true)
                end
                --
                StartingX = CurrentX
                StartingY = CurrentY
            end)
            --
            if Options.Parent:IsA("ScrollingFrame") then
                Library:Connection(Options.Parent:GetPropertyChangedSignal("CanvasPosition"), function()
                    MultiBox:Update()
                end)
            end
        end
        --
        do -- Connections
            Library:Connection(Button_44.MouseButton1Click, function()
                if MultiBox.Hiding then return end
                --
                MultiBox:Toggle()
            end)
            --
            Library:Connection(MultiBoxOutline_5.MouseEnter, function()
                if Library.UI.Faded then return end
                --
                if not MultiBox.Open then
                    MultiBox.Hovering = true
                    Library:TweenObject(MultiBoxBack_5, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                end	
            end)
            --
            Library:Connection(MultiBoxOutline_5.MouseLeave, function()
                if Library.UI.Faded then return end
                --
                if not MultiBox.Open then
                    MultiBox.Hovering = false
                    Library:TweenObject(MultiBoxBack_5, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(220, 220, 220)})
                end	
            end)
        end
        --
        for Index, Value in Options.Content do
            if typeof(Value) == "boolean" or typeof(Value) == "table" then continue end
            --
            MultiBox:AddValue(Value)
        end
        --
        Library:Fade(false, Library:GetObjectsTable(MultiBoxMainOutline, true), MultiBoxMainOutline, 0.1)
        --
        if Options.Hiding then
            MultiBox:SetVisible(false)
        end
        --
        MultiBox:Toggle(true)
        --
        return MultiBox
    end
    --
    function Library:Dropdown(Options)
        Options = Library:Validate({
            Default = "None",
            Name = "Preview Dropdown",
            Content = {},
            Parent = nil,
            MainUI = nil,
            Hiding = false,
            TabUI = nil,
            Risky = false,
            Flag = Library.NewFlag(),
            Callback = function() end
        }, Options or {})
        --
        local Dropdown = {
            Open = false,
            Active = false,
            Hovering = false,
            CurrentItem = nil,
            Scrollable = false,
            Hiding = false,
            Items = {},
            Value = Options.Default,
        }
        --
        Library.Flags[Options.Flag] = Dropdown
        --
        local PreviewDropdown_5 = Library:CreateObject("Frame", {
            Name = "PreviewDropdown_5",
            BackgroundTransparency = 1,
            Size = Options.Name == "" and UDim2.new(1, 0, 0, 20) or UDim2.new(1, 0, 0, 31),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Options.Parent
        })
        --
        local DropdownOutline_5 = Library:CreateObject("Frame", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(0, 1),
            Name = "DropdownOutline_5",
            Position = UDim2.new(0, -1, 1, 0),
            Size = UDim2.new(1, -19, 0, 20),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = PreviewDropdown_5
        })
        --
        local DropdownChecker = Library:CreateObject("Frame", {
            Name = "DropdownChecker",
            Position = UDim2.new(0, 0, 1, 0),
            Visible = false,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 0, 0, 1),
            BorderSizePixel = 0,
            Parent = DropdownOutline_5
        })
        --
        local DropdownBack_5 = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "DropdownBack_5",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(220, 220, 220),
            Parent = DropdownOutline_5
        })
        --
        local DropdownArrow = Library:CreateObject("ImageLabel", {
            ImageColor3 = Color3.fromRGB(151, 151, 151),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "DropdownArrow",
            Image = "rbxassetid://15556784588",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -11, 0, 6),
            Size = UDim2.new(0, 5, 0, 4),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = DropdownBack_5
        })
        --
        local UIGradient_34 = Library:CreateObject("UIGradient", {
            Rotation = -90,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(39, 39, 39)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
            },
            Parent = DropdownBack_5
        })
        --
        local DropdownValue_5 = Library:CreateObject("TextLabel", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(152, 152, 152),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = Options.Default ~= "None" and table.find(Options.Content, Options.Default) and Options.Default or "None",
            Name = "DropdownValue_5",
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 3,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = DropdownBack_5
        })
        --
        local UIPadding_87 = Library:CreateObject("UIPadding", {
            PaddingLeft = UDim.new(0, 5),
            Parent = DropdownValue_5
        })
        --
        local Button_44 = Library:CreateObject("TextButton", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Button_44",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            TextTransparency = 1,
            TextSize = 14,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = DropdownOutline_5
        })
        --
        local DropdownName_5 = Library:CreateObject("TextLabel", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Library.Theme.Default.TextColor,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = Options.Name,
            Name = "DropdownName_5",
            ZIndex = 3,
            Position = UDim2.new(0, 0, 0, -4),
            Size = UDim2.new(1, -19, 1, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = PreviewDropdown_5
        })
        --
        local UIPadding_88 = Library:CreateObject("UIPadding", {
            PaddingLeft = UDim.new(0, 20),
            Parent = PreviewDropdown_5
        })
        --
        local DropdownMainOutline = Library:CreateObject("Frame", {
            Name = "DropdownMainOutline",
            Position = UDim2.new(0, 0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 10,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = Library.UI.ScreenGUI
        })
        --
        local DropdownMain = Library:CreateObject("Frame", {
            Name = "DropdownMain",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -2, 1, -2),
            BorderSizePixel = 0,
            ZIndex = 10,
            ClipsDescendants = true,
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            Parent = DropdownMainOutline
        })
        --
        DropdownMainOutline.BackgroundTransparency = 1
        DropdownMain.BackgroundTransparency = 1
        --
        local UIListLayout_9 = Library:CreateObject("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = DropdownMain
        })
        --
        do -- Functions
            function Dropdown:Set(State)
                for Index, Value in Dropdown.Items do
                    if Index == State then
                        Value:Activate()
                    else
                        Value:Deactivate()
                    end
                end
            end
            --
            function Dropdown:Get()
                return Dropdown.Value
            end
            --
            function Dropdown:SetVisible(Bool)
                local OldValues = Library.Objects[PreviewDropdown_5]
                --
                Dropdown.Hiding = not Bool
                --
                if Bool then
                    Library.Objects[PreviewDropdown_5] = {PreviewDropdown_5, OldValues[2], true}
                end
                --
                Library:Fade(Bool, Library:GetObjectsTable(PreviewDropdown_5), PreviewDropdown_5, 0.075)
                Library:TweenObject(PreviewDropdown_5, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Bool and (Options.Name == "" and UDim2.new(1, 0, 0, 20) or UDim2.new(1, 0, 0, 31)) or UDim2.new(1, 0, 0, -10)}, function()
                    if not Bool then
                        Library.Objects[PreviewDropdown_5] = {PreviewDropdown_5, OldValues[2], false}
                    end
                end)
            end
            --
            function Dropdown:AddValue(Value)
                local Item = {
                    Active = false,
                    Hovering = false,
                }
                --
                Dropdown.Items[Value] = Item
                --
                local Inactive = Library:CreateObject("TextLabel", {
                    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    TextColor3 = Color3.fromRGB(208, 208, 208),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = Value,
                    Text = Value,
                    RichText = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = Library.UI.FontSize,
                    ZIndex = 10,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    Parent = DropdownMain
                })
                --
                local Button_4 = Library:CreateObject("TextButton", {
                    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "Button_4",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextTransparency = 1,
                    TextSize = Library.UI.FontSize,
                    ZIndex = 10,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = Inactive
                })
                --
                local UIPadding_48 = Library:CreateObject("UIPadding", {
                    PaddingLeft = UDim.new(0, 8),
                    Parent = Inactive
                })
                --
                Inactive.TextTransparency = 1
                --
                do -- Functions
                    function Item:Activate()
                        if not Item.Active then
                            if Dropdown.CurrentItem ~= nil then
                                Dropdown.CurrentItem:Deactivate()
                            end
                            --
                            Item.Active = true
                            Dropdown.CurrentItem = Item
                            Dropdown.Value = Value
                            Library.Flags[Options.Flag] = Dropdown
                            Options.Callback(Value)
                            DropdownValue_5.Text = Value
                            --
                            Inactive.Text = "<b>" .. Value .. "</b>"
                            Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.Default.Accent})
                            Library:AddTheme(Inactive, {
                                TextColor3 = "Accent",
                            })
                        end
                    end
                    --
                    function Item:Deactivate()
                        if Item.Active then
                            Item.Active = false
                            Item.Hovering = false
                            Inactive.Text = Value
                            Inactive.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                            Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(205, 205, 205)})
                            Library:AddTheme(Inactive, {
                                TextColor3 = "TextColor",
                            })
                        end
                    end
                end
                --
                do -- Connections
                    Library:Connection(Button_4.MouseButton1Click, function()
                        if Dropdown.Hiding then return end
                        --
                        Item:Activate()
                        Dropdown:Toggle()
                    end)
                    --
                    Library:Connection(Inactive.MouseEnter, function()
                        Inactive.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                        --
                        if Item.Active then return end
                        --
                        Inactive.Text = "<b>" .. Value .. "</b>"
                    end)
                    --
                    Library:Connection(Inactive.MouseLeave, function()
                        Inactive.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                        --
                        if Item.Active then return end
                        --
                        Inactive.Text = Value
                        Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(205, 205, 205)})
                    end)
                end
                --
                if Value == Options.Default then
                    Item:Activate()
                end
            end
            --
            function Dropdown:Toggle(Fast)
                local Fast = Fast or false
                local OldValues = Library.Objects[DropdownMainOutline]
                --
                if Dropdown.Open then
                    if Fast then
                        Library:Fade(false, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0)
                        DropdownMainOutline.Size = UDim2.new(0, DropdownOutline_5.AbsoluteSize.X, 0, 0)
                        Library.Objects[DropdownMainOutline] = {DropdownMainOutline, OldValues[2], true}
                    else
                        Library:Fade(false, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0.1)
                        Library:TweenObject(DropdownMainOutline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, DropdownOutline_5.AbsoluteSize.X, 0, 0)}, function()
                            Library.Objects[DropdownMainOutline] = {DropdownMainOutline, OldValues[2], true}
                        end)
                    end
                else
                    Library.Objects[DropdownMainOutline] = {DropdownMainOutline, OldValues[2], false}
                    --
                    if Fast then
                        Library:Fade(true, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0)
                        DropdownMainOutline.Size = UDim2.new(0, DropdownOutline_5.AbsoluteSize.X, 0, (#Options.Content * 20) + 2)
                    else
                        Library:Fade(true, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0.1)
                        Library:TweenObject(DropdownMainOutline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, DropdownOutline_5.AbsoluteSize.X, 0, (#Options.Content * 20) + 2)})
                    end	
                end
                --
                Dropdown.Open = not Dropdown.Open
            end
            --
            function Dropdown:Update()
                DropdownMainOutline.Size = UDim2.new(0, DropdownOutline_5.AbsoluteSize.X, 0, DropdownMainOutline.AbsoluteSize.Y)
                DropdownMainOutline.Position = UDim2.new(0, DropdownOutline_5.AbsolutePosition.X, 0, ((DropdownOutline_5.AbsolutePosition.Y + DropdownOutline_5.AbsoluteSize.Y) + GuiService:GetGuiInset().Y + 2))
                --
                if Dropdown.Open then
                    DropdownMainOutline.Visible = Library:ScrollingCheck(Options.Parent, DropdownChecker)
                end
            end
            --
            Dropdown:Update()
            --
            Library:Connection(DropdownOutline_5:GetPropertyChangedSignal("AbsolutePosition"), Dropdown.Update)
            Library:Connection(DropdownOutline_5:GetPropertyChangedSignal("AbsoluteSize"), Dropdown.Update)
            --
            local StartingX = PreviewDropdown_5.AbsolutePosition.X
            local StartingY = PreviewDropdown_5.AbsolutePosition.Y
            local MainUIStartingX = Options.MainUI.AbsolutePosition.X
            local MainUIStartingY = Options.MainUI.AbsolutePosition.Y
            local StartingCanvasPosition = Options.Parent.CanvasPosition
            --
            Library:Connection(PreviewDropdown_5:GetPropertyChangedSignal("AbsolutePosition"), function()
                if not Dropdown.Open then return end
                --
                local CurrentX = PreviewDropdown_5.AbsolutePosition.X
                local CurrentY = PreviewDropdown_5.AbsolutePosition.Y
                local MainUICurrentX = Options.MainUI.AbsolutePosition.X
                local MainUICurrentY = Options.MainUI.AbsolutePosition.Y
                local CurrentCanvasPosition = Options.Parent.CanvasPosition
                --
                if MainUICurrentX ~= MainUIStartingX or MainUICurrentY ~= MainUIStartingY then
                    MainUIStartingX = MainUICurrentX
                    MainUIStartingY = MainUICurrentY
                    StartingX = CurrentX
                    StartingY = CurrentY
                    --
                    return
                end
                --
                if CurrentCanvasPosition ~= StartingCanvasPosition then
                    StartingCanvasPosition = CurrentCanvasPosition
                    StartingX = CurrentX
                    StartingY = CurrentY
                    --
                    return
                end
                --
                if Library.UI.Resizing then
                    return
                end
                --
                if CurrentX ~= StartingX or CurrentY ~= StartingY then
                    Dropdown:Toggle(true)
                end
                --
                StartingX = CurrentX
                StartingY = CurrentY
            end)
            --
            if Options.Parent:IsA("ScrollingFrame") then
                Library:Connection(Options.Parent:GetPropertyChangedSignal("CanvasPosition"), function()
                    Dropdown:Update()
                end)
            end
        end
        --
        do -- Connections
            Library:Connection(Button_44.MouseButton1Click, function()
                if Dropdown.Hiding then return end
                --
                Dropdown:Toggle()
            end)
            --
            Library:Connection(DropdownOutline_5.MouseEnter, function()
                if Library.UI.Faded then return end
                --
                if not Dropdown.Open then
                    Dropdown.Hovering = true
                    Library:TweenObject(DropdownBack_5, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                end	
            end)
            --
            Library:Connection(DropdownOutline_5.MouseLeave, function()
                if Library.UI.Faded then return end
                --
                if not Dropdown.Open then
                    Dropdown.Hovering = false
                    Library:TweenObject(DropdownBack_5, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(220, 220, 220)})
                end	
            end)
        end
        --
        for _, Value in Options.Content do
            Dropdown:AddValue(Value)
        end
        --
        Library:Fade(false, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0.1)
        --
        if Options.Hiding then
            Dropdown:SetVisible(false)
        end
        --
        Dropdown:Toggle(true)
        --
        return Dropdown
    end
    --
    function Library:Slider(Options)
        Options = Library:Validate({
            Name = "Preview Slider",
            Min = 0,
            Max = 100,
            Default = 1,
            Decimal = 1,
            UseIcons = true,
            Ending = "",
            Disable = {},
            Hidden = false,
            Risky = false,
            Parent = nil,
            OverrideLimit = false, -- new parameter to allow values beyond max
            Flag = Library.NewFlag(),
            Callback = function() end
        }, Options or {})
        --
        local Slider = {
            MouseDown = false,
            Hiding = false,
            Hovering = false,
            Connection = nil,
            CurrentValue = -9999,
            LeftControlDown = false,
        }
        --
        Library.Flags[Options.Flag] = Slider
        --
        local PreviewSlider = Library:CreateObject("Frame", {
            Name = "PreviewSlider",
            BackgroundTransparency = 1,
            Size = Options.Name == "" and UDim2.new(1, 0, 0, 7) or UDim2.new(1, 0, 0, 20),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Options.Parent
        })
        --
        local SliderOutline = Library:CreateObject("Frame", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(0, 1),
            Name = "SliderOutline",
            Position = UDim2.new(0, -1, 1, 0),
            Size = UDim2.new(1, -19, 0, 7),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = PreviewSlider
        })
        --
        local SliderBack = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "SliderBack",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(205, 205, 205),
            Parent = SliderOutline
        })
        --
        local UIGradient_2 = Library:CreateObject("UIGradient", {
            Rotation = -90,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(81, 81, 81)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(68, 68, 68))
            },
            Parent = SliderBack
        })
        --
        local SliderDrag = Library:CreateObject("Frame", {
            Name = "Slider",
            Size = UDim2.new(0.5, 0, 1, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = SliderBack
        })
        --
        local UIGradient_3 = Library:CreateObject("UIGradient", {
            Rotation = 90,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Library.Theme.Default.Accent),
                ColorSequenceKeypoint.new(1, Library.Theme.Default.SecondAccent)
            },
            Parent = SliderDrag
        })
        --
        Library:AddTheme(UIGradient_3, {
            Color = {"Accent", "SecondAccent"},
        })
        --
        local Button_4 = Library:CreateObject("TextButton", {
            FontFace = Library.UI.NewFont,
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Button_4",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            TextTransparency = 1,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = SliderOutline
        })
        --
        local SliderName = Library:CreateObject("TextLabel", {
            FontFace = Library.UI.NewFont,
            TextColor3 = Options.Risky and Library.Theme.Default.Risky or Library.Theme.Default.TextColor,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = Options.Name,
            Name = "SliderName",
            ZIndex = 3,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = PreviewSlider
        })
        --
        if Options.Risky then
            Library:AddTheme(SliderName, {
                TextColor3 = "Risky",
            })
        end
        --
        local UIPadding_3 = Library:CreateObject("UIPadding", {
            PaddingTop = UDim.new(0, -4),
            PaddingLeft = UDim.new(0, 20),
            Parent = PreviewSlider
        })
        --
        local SliderValue = Library:CreateObject("TextBox", {
            FontFace = Library.UI.NewFont,
            TextColor3 = Color3.fromRGB(198, 198, 198),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = Options.Default,
            Name = "SliderValue",
            ZIndex = 3,
            AnchorPoint = Vector2.new(1, 0),
            Size = UDim2.new(0, 10, 0, 10),
            Position = UDim2.new(0, 100, 0, 0),
            BackgroundTransparency = 1,
            RichText = true,
            BorderSizePixel = 0,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextSize = Library.UI.FontSize,
            TextStrokeTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = SliderDrag
        })
        --
        local AddButton = Library:CreateObject("Frame", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(1, 1),
            Name = "AddButton",
            Position = UDim2.new(1, -13, 1, -3),
            Size = UDim2.new(0, 3, 0, 1),
            ZIndex = 3,
            BorderSizePixel = 0,
            Visible = Options.UseIcons,
            BackgroundColor3 = Color3.fromRGB(100, 100, 100),
            Parent = PreviewSlider
        })
        --
        local AddButton2 = Library:CreateObject("Frame", {
            Size = UDim2.new(0, 1, 0, 3),
            Name = "AddButton2",
            Position = UDim2.new(0, 1, 0, -1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            Visible = Options.UseIcons,
            BackgroundColor3 = Color3.fromRGB(100, 100, 100),
            Parent = AddButton
        })
        --
        local AddActualButton = Library:CreateObject("TextButton", {
            FontFace = Library.UI.NewFont,
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "AddActualButton",
            TextTransparency = 1,
            AnchorPoint = Vector2.new(1, 1),
            Size = UDim2.new(0, 11, 0, 7),
            Visible = Options.UseIcons,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -9, 1, 1),
            BorderSizePixel = 0,
            ZIndex = 3,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = PreviewSlider
        })
        --
        local MinusActualButton = Library:CreateObject("TextButton", {
            FontFace = Library.UI.NewFont,
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "MinusActualButton",
            TextTransparency = 1,
            Visible = Options.UseIcons,
            AnchorPoint = Vector2.new(0, 1),
            Size = UDim2.new(0, 11, 0, 7),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, -12, 1, 0),
            BorderSizePixel = 0,
            ZIndex = 3,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = PreviewSlider
        })
        --
        local MinusButton = Library:CreateObject("Frame", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(0, 1),
            Name = "MinusButton",
            Visible = Options.UseIcons,
            Position = UDim2.new(0, -8, 1, -3),
            Size = UDim2.new(0, 3, 0, 1),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(100, 100, 100),
            Parent = PreviewSlider
        })
        --
        local function GetValue(Value)
            return typeof(Value) == "string" and Value or ("%.14g"):format(Value)
        end
        --
        local function SetValue(Value, IgnoreLimit)
            if (not Value) or Slider.Hiding then return end
            --
            local OriginalValue = Value
            -- check if we should allow values beyond the max
            if Options.OverrideLimit and IgnoreLimit then
                -- allow any value (still enforce min and decimal rounding)
                Value = Value and math.max(Options.Decimal * math.round(tonumber(Value) / Options.Decimal), Options.Min) or 0
            else
                -- default behavior: clamp between min and max
                Value = Value and math.clamp(Options.Decimal * math.round(tonumber(Value) / Options.Decimal), Options.Min, Options.Max) or 0
            end
            
            local ValueText = Options.Disable[1] and ((Value <= Options.Disable[2] or Value >= Options.Disable[3]) and Options.Disable[1]) or tostring(GetValue(Value)) .. Options.Ending
            --
            SliderValue.Text = "<b>" .. ValueText .. "</b>"
            --
            if Value ~= Slider.CurrentValue then
                Slider.CurrentValue = Value
                --
                -- always display the slider within bounds, even if the value is beyond max
                local DisplayValue = math.min(Value, Options.Max)
                Library:TweenObject(SliderDrag, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new((DisplayValue - Options.Min) / (Options.Max - Options.Min), 0, 1, 0)})
                --
                SliderValue.Size = UDim2.fromOffset(SliderValue.TextBounds.X, SliderValue.TextBounds.Y)
                SliderValue.Position = UDim2.new(1, SliderValue.TextBounds.X / 2, 0, -4)
            end
            --
            Library.Flags[Options.Flag] = Slider
            Options.Callback(tonumber(GetValue(Value)))
        end
        --
        SetValue(Options.Default)
        --
        function Slider:Get()
            return tonumber(GetValue(Slider.CurrentValue))
        end
        --
        function Slider:Max()
            return Options.Max
        end
        --
        function Slider:Min()
            return Options.Min
        end
        --
        function Slider:Set(Value)
            if not Value then return end
            --
            SetValue(Value, Options.OverrideLimit) -- allow overriding limits for api calls too
        end
        --
        function Slider:GetName()
            return Options.Name
        end
        --
        function Slider:SetVisible(Bool)
            local OldValues = Library.Objects[PreviewSlider]
            --
            Slider.Hiding = not Bool
            SliderValue.Visible = Bool
            --
            if Bool then
                Library.Objects[PreviewSlider] = {PreviewSlider, OldValues[2], true}
            end
            --
            Library:Fade(Bool, Library:GetObjectsTable(PreviewSlider), PreviewSlider, 0.075)
            Library:TweenObject(PreviewSlider, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Bool and (Options.Name == "" and UDim2.new(1, 0, 0, 7) or UDim2.new(1, 0, 0, 20)) or UDim2.new(1, 0, 0, -10)}, function()
                if not Bool then
                    Library.Objects[PreviewSlider] = {PreviewSlider, OldValues[2], false}
                end
            end)
        end
        --
        local function SlideBar(Input)
            local SizeX = (Input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X
            local Value = math.clamp((Options.Max - Options.Min) * SizeX + Options.Min, Options.Min, Options.Max)
            --
            SetValue(Value)
        end
        --
        do -- Connections
            Library:Connection(SliderOutline.MouseEnter, function()
                if Library.UI.Faded then return end
                --
                Library:TweenObject(SliderBack, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
            end)
            --
            Library:Connection(SliderOutline.MouseLeave, function()
                if Library.UI.Faded then return end
                --
                Library:TweenObject(SliderBack, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(205, 205, 205)})
            end)
            --
            Library:Connection(MinusActualButton.MouseButton1Click, function()
                if Library.UI.Faded then return end
                --
                Slider:Set(Slider.CurrentValue - Options.Decimal)
            end)
            --
            Library:Connection(AddActualButton.MouseButton1Click, function()
                if Library.UI.Faded then return end
                --
                Slider:Set(Slider.CurrentValue + Options.Decimal)
            end)
            --
            Library:Connection(Button_4.MouseButton1Down, function()
                if Library.UI.Faded then return end
                --
                Library.UI.DraggingGui = SliderDrag
                Slider.MouseDown = true
                SlideBar({Position = UserInputService:GetMouseLocation()})
            end)
            --
            Library:Connection(SliderValue.FocusLost, function()
                local NewValue = tonumber(SliderValue.Text)
                --
                if NewValue then
                    SetValue(NewValue, Options.OverrideLimit) -- pass true to allow exceeding max
                else
                    SetValue(Options.Min)
                end
            end)
            --
            Library:Connection(UserInputService.InputChanged, function(Input)
                if Library.UI.Faded then return end
                --
                if Library.UI.DraggingGui ~= SliderDrag and not (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) then
                    return
                end
                --
                if Slider.MouseDown and Input.UserInputType == Enum.UserInputType.MouseMovement then
                    SlideBar(Input)
                end
            end)
            --
            Library:Connection(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Slider.MouseDown = false
                end
            end)
        end
        --
        if Options.Hidden then
            Slider:SetVisible(false)
        end
        --
        return Slider
    end
    --
    function Library:Toggle(Options)
        Options = Library:Validate({
            Default = false,
            Name = "Preview Toggle",
            Risky = false,
            SectionName = nil,
            Parent = nil,
            Hidden = false,
            AnchorPoint = Vector2.new(0, 0),
            MainUI = nil,
            Size = UDim2.new(1, 0, 0, 8),
            Position = UDim2.new(0, 0, 0, 0),
            UseToggleOutline = false,
            ZIndex = 2,
            Flag = Library:NewFlag(),
            Callback = function() end
        }, Options or {})
        --
        local Toggle = {
            Active = false,
            Hovering = false,
            State = false,
            Hiding = false,
            MainUI = Options.MainUI,
            TabUI = Options.TabUI,
            ColorPickers = {},
            KeybindState = false,
        }
        --
        Library.Flags[Options.Flag] = Toggle
        --
        local PreviewToggle = Library:CreateObject("Frame", {
            Name = "PreviewToggle",
            BackgroundTransparency = 1,
            Size = Options.Size,
            Position = Options.Position,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Options.AnchorPoint,
            ZIndex = Options.ZIndex or 2,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Options.Parent
        })
        --
        local ToggleOutline = Library:CreateObject("Frame", {
            Name = "ToggleOutline",
            Size = UDim2.new(0, 8, 0, 8),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = Options.ZIndex or 2,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = PreviewToggle
        })
        --
        if Options.UseToggleOutline then
            ToggleOutline.AnchorPoint = Options.AnchorPoint
            ToggleOutline.Position = Options.Position
        end
        --
        local ToggleInline = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "ToggleInline",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = Options.ZIndex or 2,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(227, 227, 227),
            Parent = ToggleOutline
        })
        --
        local UIGradient_3 = Library:CreateObject("UIGradient", {
            Rotation = 90,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(84, 84, 84)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(74, 74, 74))
            },
            Parent = ToggleInline
        })
        --
        local ToggleMain = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "ToggleInline",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = Options.ZIndex or 2,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = ToggleOutline
        })
        --
        Library.Objects[ToggleMain] = {ToggleMain, {BackgroundTransparency = ToggleMain.BackgroundTransparency}, false}
        --
        local UIGradient_32 = Library:CreateObject("UIGradient", {
            Rotation = 90,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Library.Theme.Default.Accent),
                ColorSequenceKeypoint.new(1, Library.Theme.Default.SecondAccent)
            },
            Parent = ToggleMain
        })
        --
        Library:AddTheme(UIGradient_32, {
            Color = {"Accent", "SecondAccent"},
        })
        --
        local ToggleName = Library:CreateObject("TextLabel", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "ToggleName",
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = Options.ZIndex or 2,
            FontFace = Library.UI.NewFont,
            RichText = true,
            Text = Options.Name,
            TextColor3 = Options.Risky and Library.Theme.Default.Risky or Library.Theme.Default.TextColor,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = PreviewToggle
        })
        --
        if Options.Risky then
            Library:AddTheme(ToggleName, {
                TextColor3 = "Risky",
            })
        end
        --
        local UIPadding_7 = Library:CreateObject("UIPadding", {
            PaddingLeft = UDim.new(0, 20),
            Parent = ToggleName
        })
        --
        local Button_9 = Library:CreateObject("TextButton", {
            FontFace = Library.UI.NewFont,
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Button_9",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            TextTransparency = 1,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = PreviewToggle
        })
        --
        do -- Functions
            function Toggle:ToggleGUI(Bool)
                if Bool == nil then
                    Toggle.State = not Toggle.State
                else
                    Toggle.State = Bool
                end
                --
                Library:TweenObject(ToggleMain, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = Toggle.State and 0 or 1})
                
                -- update the stored transparency value in the objects table, this is for the temp fix for the toggle out and toggle in 
                -- since this uses instant out and instant in instead of the normal fade in and fade out
                if Library.Objects[ToggleMain] then
                    Library.Objects[ToggleMain][2].BackgroundTransparency = Toggle.State and 0 or 1
                end
                
                --
                Library.Flags[Options.Flag] = Toggle
                Options.Callback(Toggle.State)
            end
            --
            function Toggle:GetName()
                return Options.Name
            end
            --
            function Toggle:GetFlag()
                return Options.Flag
            end
            --
            function Toggle:GetSection()
                return Options.SectionName
            end
            --
            function Toggle:GetState()
                return Toggle.State
            end
            --
            function Toggle:GetCallback(b)
                Options.Callback(b)
            end
            --
            function Toggle:Set(Value)
                Toggle:ToggleGUI(Value)
            end
            --
            function Toggle:SetName(Name)
                Options.Name = Name
                ToggleName.Text = Name
            end
            --
            function Toggle:Get()
                return Toggle.State
            end
            --
            function Toggle:SetVisible(Bool)
                local OldValues = Library.Objects[PreviewToggle]
                --
                Toggle.Hiding = not Bool
                --
                if Bool then
                    Library.Objects[PreviewToggle] = {PreviewToggle, OldValues[2], true}
                end
                --
                Library:Fade(Bool, Library:GetObjectsTable(PreviewToggle), PreviewToggle, 0.075)
                Library:TweenObject(PreviewToggle, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Bool and UDim2.new(1, 0, 0, 8) or UDim2.new(1, 0, 0, -10)}, function()
                    if not Bool then
                        Library.Objects[PreviewToggle] = {PreviewToggle, OldValues[2], false}
                    end
                end)
            end
            --
            function Toggle:ColorPicker(Options)
                Options = Library:Validate({
                    Name = "Preview Color Picker",
                    Default = Library.Theme.Default.Accent,
                    Flag = Library.NewFlag(),
                    Alpha = 0,
                    AlphaBar = true,
                    Callback = function() end,
                }, Options or {})
                --
                local ColorPicker = {}
                --
                Toggle.ColorPickers[#Toggle.ColorPickers + 1] = ColorPicker
                --
                local ColorPickerFrame = Library:ColorPicker({
                    Name = Options.Name,
                    Default = Options.Default,
                    Flag = Options.Flag,
                    Alpha = Options.Alpha,
                    AlphaBar = Options.AlphaBar,
                    MainUI = Toggle.MainUI,
                    TabUI = Toggle.TabUI,
                    Callback = Options.Callback,
                    Parent = PreviewToggle,
                    Keybind = Toggle.KeybindState,
                    Count = #Toggle.ColorPickers,
                })
                --
                return ColorPickerFrame
            end
            --
            function Toggle:Keybind(Options)
                Options = Library:Validate({
                    Default = Enum.KeyCode.Backspace,
                    Mode = "Toggle",
                    UseMode = true,
                    HideFromList = false,
                    Blacklisted = {},
                    Hiding = false,
                    ChangeToggle = false,
                    Flag = Library.NewFlag(),
                    Callback = function() end,
                }, Options or {})
                --
                local Keybind = {}
                --
                Toggle.KeybindState = true
                --
                Library:Keybind({
                    Default = Options.Default,
                    Mode = Options.Mode,
                    HideFromList = Options.HideFromList,
                    Blacklisted = Options.Blacklisted,
                    Parent = PreviewToggle,
                    UseMode = Options.UseMode,
                    Toggle = Toggle,
                    MainUI = Toggle.MainUI,
                    TabUI = Toggle.TabUI,
                    Hiding = Options.Hiding,
                    ToggleState = Toggle.State,
                    ChangeToggle = Options.ChangeToggle,
                    Flag = Options.Flag,
                    Callback = Options.Callback,
                    Count = #Toggle.ColorPickers + 1,
                })
                --
                return Keybind
            end
        end
        --
        do -- Connections
            Library:Connection(PreviewToggle.MouseEnter, function()
                if Library.UI.Faded then return end
                --
                Library:TweenObject(ToggleInline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
            end)
            --
            Library:Connection(PreviewToggle.MouseLeave, function()
                if Library.UI.Faded then return end
                --
                Library:TweenObject(ToggleInline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(227, 227, 227)})
            end)
            --
            Library:Connection(Button_9.MouseButton1Click, function()
                if Library.UI.Faded then return end
                --
                if Toggle.Hiding then return end
                --
                Toggle:ToggleGUI()
            end)
        end
        --
        Toggle:ToggleGUI(Options.Default)
        --
        if Options.Hidden then
            Toggle:SetVisible(false)
        end
        --
        return Toggle
    end
    --
    function Library:Label(Options)
        Options = Library:Validate({
            Message = "Preview Label",
            Side = "Left",
            Risky = false,
            Parent = nil,
            MainUI = nil,
            SectionName = nil,
            Hidden = false,
            TabUI = nil,
            Callback = function() end
        }, Options or {})
        --
        local Label = {
            ColorPickers = {},
            KeybindState = false,
            Hiding = false,
            MainUI = Options.MainUI,
            TabUI = Options.TabUI,
            State = true,
        }
        --
        local PreviewLabel = Library:CreateObject("Frame", {
            Name = "PreviewLabel",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 7),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 2,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Options.Parent
        })
        --
        local LabelText = Library:CreateObject("TextLabel", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "ToggleName",
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment[Options.Side],
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, -1),
            ZIndex = 2,
            FontFace = Library.UI.NewFont,
            RichText = true,
            Text = Options.Message,
            TextColor3 = Color3.fromRGB(198, 198, 198),
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = PreviewLabel
        })
        --
        local UIPadding_7 = Library:CreateObject("UIPadding", {
            PaddingLeft = UDim.new(0, 20),
            Parent = LabelText
        })
        --
        do -- Functions
            function Label:GetName()
                return Options.Message
            end
            --
            function Label:GetState()
                return Label.State
            end
            --
            function Label:GetSection()
                return Options.SectionName
            end
            --
            function Label:GetCallback(Bool)
                Options.Callback(Bool)
            end
            --
            function Label:SetVisible(Bool)
                local OldValues = Library.Objects[PreviewLabel]
                --
                Label.Hiding = not Bool
                --
                if Bool then
                    Library.Objects[PreviewLabel] = {PreviewLabel, OldValues[2], true}
                end
                --
                Library:Fade(Bool, Library:GetObjectsTable(PreviewLabel), PreviewLabel, 0.075)
                Library:TweenObject(PreviewLabel, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Bool and UDim2.new(1, 0, 0, 8) or UDim2.new(1, 0, 0, -10)}, function()
                    if not Bool then
                        Library.Objects[PreviewLabel] = {PreviewLabel, OldValues[2], false}
                    end
                end)
            end
            --
            function Label:ColorPicker(Options)
                Options = Library:Validate({
                    Name = "Preview Color Picker",
                    Default = Library.Theme.Default.Accent,
                    Flag = Library.NewFlag(),
                    Alpha = 0,
                    AlphaBar = true,
                    MainUI = nil,
                    Callback = function() end,
                }, Options or {})
                --
                local ColorPicker = {}
                --
                Label.ColorPickers[#Label.ColorPickers + 1] = ColorPicker
                --
                local ColorPickerFrame = Library:ColorPicker({
                    Name = Options.Name,
                    Default = Options.Default,
                    Flag = Options.Flag,
                    Alpha = Options.Alpha,
                    AlphaBar = Options.AlphaBar,
                    MainUI = Label.MainUI,
                    TabUI = Label.TabUI,
                    Callback = Options.Callback,
                    Parent = PreviewLabel,
                    Keybind = Label.KeybindState,
                    Count = #Label.ColorPickers,
                })
                --
                return ColorPickerFrame
            end
            --
            function Label:Keybind(Options)
                Options = Library:Validate({
                    Default = Enum.KeyCode.Backspace,
                    Mode = "Toggle",
                    UseMode = true,
                    HideFromList = false,
                    Blacklisted = {},
                    Hiding = false,
                    Flag = Library.NewFlag(),
                    Callback = function() end,
                }, Options or {})
                --
                local Keybind = {}
                --
                Label.KeybindState = true
                --
                Library:Keybind({
                    Default = Options.Default,
                    Mode = Options.Mode,
                    HideFromList = Options.HideFromList,
                    Blacklisted = Options.Blacklisted,
                    Parent = PreviewLabel,
                    Toggle = Label,
                    UseMode = Options.UseMode,
                    MainUI = Label.MainUI,
                    TabUI = Label.TabUI,
                    Hiding = Options.Hiding,
                    ToggleState = Label.State,
                    Flag = Options.Flag,
                    Callback = Options.Callback,
                    Count = #Label.ColorPickers + 1,
                })
                --
                return Keybind
            end
            --
            --[[function Label:Update()
                LabelText.Size = UDim2.new(LabelText.Size.X.Scale, LabelText.Size.X.Offset, 0, math.huge)
                LabelText.Size = UDim2.new(LabelText.Size.X.Scale, LabelText.Size.X.Offset, 0, LabelText.TextBounds.Y)
                PreviewLabel.Size = UDim2.new(PreviewLabel.Size.X.Scale, PreviewLabel.Size.X.Offset, 0, LabelName.TextBounds.Y + 6)
            end]]
        end
        --
        --Label:Update()
        --
        if Options.Hidden then
            Label:SetVisible(false)
        end
        --
        return Label
    end
    --
    function Library:TextBox(Options)
        Options = Library:Validate({
            Default = "",
            Name = "Preview TextBox",
            Max = 32,
            Parent = nil,
            Size = UDim2.new(1, 0, 0, 19),
            Position = UDim2.new(0, 0, 0, 0),
            NumbersOnly = false,
            ClearOnFocus = false,
            Hidden = false,
            TypedCheck = false,
            CheckIfPressedEnter = false,
            Risky = false,
            Flag = Library.NewFlag(),
            Callback = function() end
        }, Options or {})
        --
        local TextBox = {
            Focused = false,
            Hovering = false,
            Hiding = false,
        }
        --
        Library.Flags[Options.Flag] = TextBox
        --
        local PreviewTextBox = Library:CreateObject("Frame", {
            Name = "PreviewTextBox",
            BackgroundTransparency = 1,
            Size = Options.Size,
            Position = Options.Position,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Options.Parent
        })
        --
        local TextBoxOutline = Library:CreateObject("Frame", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "TextBoxOutline",
            Position = UDim2.new(0, -1, 0, 0),
            Size = UDim2.new(1, -19, 0, 19),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = PreviewTextBox
        })
        --
        local TextBoxInline = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "TextBoxInline",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            Parent = TextBoxOutline
        })
        --
        local TextBoxMain = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "TextBoxMain",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(24, 24, 24),
            Parent = TextBoxInline
        })
        --
        local TextBoxObject = Library:CreateObject("TextBox", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Library.Theme.Default.TextColor,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = "",
            ZIndex = 3,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            SelectionStart = 1,
            ClearTextOnFocus = Options.ClearOnFocus,
            PlaceholderColor3 = Library.Theme.Default.TextColor,
            TextXAlignment = Enum.TextXAlignment.Left,
            PlaceholderText = "_",
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = TextBoxMain
        })
        --
        TextBox.Object = TextBoxObject
        --
        local UIPadding_6 = Library:CreateObject("UIPadding", {
            PaddingBottom = UDim.new(0, 2),
            PaddingLeft = UDim.new(0, 5),
            Parent = TextBoxObject
        })
        --
        local UIPadding_7 = Library:CreateObject("UIPadding", {
            PaddingLeft = UDim.new(0, 20),
            Parent = PreviewTextBox
        })
        --
        do -- Functions
            function TextBox:SetVisible(Bool)
                local OldValues = Library.Objects[PreviewTextBox]
                --
                TextBox.Hiding = not Bool
                TextBoxObject.Visible = Bool
                --
                if Bool then
                    Library.Objects[PreviewTextBox] = {PreviewTextBox, OldValues[2], true}
                end
                --
                Library:Fade(Bool, Library:GetObjectsTable(PreviewTextBox), PreviewTextBox, 0.075)
                Library:TweenObject(PreviewTextBox, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Bool and Options.Size or UDim2.new(1, 0, 0, -10)}, function()
                    if not Bool then
                        Library.Objects[PreviewTextBox] = {PreviewTextBox, OldValues[2], false}
                    end
                end)
            end
            --
            function TextBox:Get()
                return TextBoxObject.Text
            end
        end
        --
        do -- Connections
            Library:Connection(TextBoxObject:GetPropertyChangedSignal("Text"), function()
                TextBoxObject.Text = TextBoxObject.Text:sub(1, Options.Max)
                --
                if Options.NumbersOnly then
                    TextBoxObject.Text = TextBoxObject.Text:gsub('[^%d%.%-]+', '')
                end
                --
                if Options.TypedCheck then
                    Library.Flags[Options.Flag] = TextBox
                    Options.Callback(TextBoxObject.Text)
                end
                --
                TextBox.Focused = true
            end)
            --
            Library:Connection(TextBoxObject.Focused, function()
                if Library.UI.Faded then return end
                --
                if TextBox.Hiding then
                    TextBoxObject:ReleaseFocus()
                    --
                    return
                end
                --
                TextBox.Focused = true
                --
                TextBoxObject.TextColor3 = Library.Theme.Default.Accent
                --
                Library:AddTheme(TextBoxObject, {
                    TextColor3 = "Accent",
                })
                --
                TextBoxObject.PlaceholderText = ""
            end)
            --
            Library:Connection(TextBoxObject.FocusLost, function(EnterPressed)
                if Options.CheckIfPressedEnter and not EnterPressed then return end
                --
                TextBox.Focused = false
                TextBoxObject.PlaceholderText = "_"
                --
                TextBoxObject.TextColor3 = Library.Theme.Default.TextColor
                --
                Library:AddTheme(TextBoxObject, {
                    TextColor3 = "TextColor",
                })
                --
                Library.Flags[Options.Flag] = TextBox
                Options.Callback(TextBoxObject.Text)
            end)
        end
        --
        if Options.Hidden then
            TextBox:SetVisible(false)
        end
        --
        return TextBox
    end
    --
    function Library:List(Options)
        Options = Library:Validate({
            Size = 100,
            Hidden = false,
            Flag = Library.NewFlag(),
            Callback = function() end
        }, Options or {})
        --
        local List = {
            CurrentValue = nil,
            CurrentValueName = nil,
        }
        --
        Library.Flags[Options.Flag] = List
        --
        local PreviewList = Library:CreateObject("Frame", {
            Name = "PreviewList",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Options.Size),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Options.Parent
        })
        --
        local UIPadding_11 = Library:CreateObject("UIPadding", {
            PaddingLeft = UDim.new(0, 20),
            Parent = PreviewList
        })
        --
        local ListOutline = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -19, 1, -18),
            Name = "ListOutline",
            Position = UDim2.new(0, -1, 0, 18),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = PreviewList
        })
        --
        local ListMain = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "ListMain",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 4,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            Parent = ListOutline
        })
        --
        local DownArrow = Library:CreateObject("ImageButton", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "DownArrow",
            Image = "rbxassetid://15540867448",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -10, 1, -9),
            Size = UDim2.new(0, 5, 0, 4),
            ZIndex = 7,
            Visible = false,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = ListMain
        })
        --
        local UpArrow = Library:CreateObject("ImageButton", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "UpArrow",
            Image = "rbxassetid://15540851994",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -10, 0, 5),
            Size = UDim2.new(0, 5, 0, 4),
            ZIndex = 7,
            Visible = false,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = ListMain
        })
        --
        local ListScrolling = Library:CreateObject("ScrollingFrame", {
            ScrollBarImageColor3 = Color3.fromRGB(65, 65, 65),
            MidImage = "rbxassetid://158362264",
            Active = true,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ScrollBarThickness = 5,
            Name = "ListScrolling",
            ZIndex = 3,
            TopImage = "rbxassetid://158362264",
            Position = UDim2.new(0, 1, 0, 1),
            Size = UDim2.new(1, -2, 1, -2),
            BottomImage = "rbxassetid://158362264",
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            CanvasPosition = Vector2.new(0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            Parent = ListOutline
        })
        --
        local UIListLayout_2 = Library:CreateObject("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = ListScrolling
        })
        --
        local TextBox = Library:TextBox({Parent = PreviewList, TypedCheck = true, Size = UDim2.new(1, 20, 0, 19), Position = UDim2.new(0, -20, 0, 0), Callback = function(Text)
            List:UpdateSection()
            --
            for _, Frame in ListScrolling:GetChildren() do
                if Frame:IsA("Frame") then
                    Frame.Visible = string.find(Frame.Name:lower(), Text:lower()) and true or false
                end
            end
        end})
        --
        do -- Functions
            function List:Get()
                return List.CurrentValueName
            end
            --
            function List:SetVisible(Bool)
                local OldValues = Library.Objects[PreviewList]
                --
                TextBox.Object.Visible = Bool
                --
                if Bool then
                    Library.Objects[PreviewList] = {PreviewList, OldValues[2], true}
                end
                --
                Library:Fade(Bool, Library:GetObjectsTable(PreviewList, false), PreviewList, 0.075)
                Library:TweenObject(PreviewList, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Bool and UDim2.new(1, 0, 0, Options.Size) or UDim2.new(1, 0, 0, -10)}, function()
                    if not Bool then
                        Library.Objects[PreviewList] = {PreviewList, OldValues[2], false}
                    end
                end)
            end
            --
            function List:AddValue(Value, Icon)
                if ListScrolling:FindFirstChild(Value) then return end
                --
                local ListValue = {
                    Active = false,
                    Hovering = false,
                }
                --
                local InactiveValue = Library:CreateObject("Frame", {
                    Name = Value .. "1",
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 5,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    Parent = ListScrolling
                })
                --
                local Button_912 = Library:CreateObject("TextButton", {
                    FontFace = Library.UI.NewFont,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "Button_9",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextTransparency = 1,
                    TextSize = Library.UI.FontSize,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = InactiveValue
                })
                --
                local ValueName_1 = Library:CreateObject("TextLabel", {
                    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    TextColor3 = Color3.fromRGB(208, 208, 208),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "ValueName_1",
                    BorderSizePixel = 0,
                    Text = Value,
                    RichText = true,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 5,
                    TextSize = Library.UI.FontSize,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = InactiveValue
                })
                --
                if Icon then
                    local Color = Icon.Color or Color3.fromRGB(255, 255, 255)
                    --
                    local IconImage = Library:CreateObject("ImageLabel", {
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Image = Icon.Image,
                        AnchorPoint = Vector2.new(0, 0.5),
                        Position = Icon.Position or UDim2.new(0, 7, 0.5, 0),
                        BackgroundTransparency = 1,
                        Name = "BackImage",
                        Size = Icon.Size or UDim2.new(0, 13, 0, 13),
                        ZIndex = 5,
                        BorderSizePixel = 0,
                        ImageColor3 = Color,
                        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                        Parent = InactiveValue
                    })
                    --
                    local UIPadding_135 = Library:CreateObject("UIPadding", {
                        PaddingLeft = UDim.new(0, 10),
                        Parent = IconImage
                    })
                end
                --
                ValueName_1.Text = Library:ClampString(Value, ValueName_1.AbsoluteSize.X - 25)
                --
                local UIPadding_13 = Library:CreateObject("UIPadding", {
                    PaddingLeft = UDim.new(0, (Icon and 25 or 10)),
                    Parent = ValueName_1
                })
                --
                do -- Functions
                    function ListValue:Activate()
                        if not ListValue.Active then
                            --
                            if List.CurrentValue then
                                List.CurrentValue:Deactivate()
                            end
                            --
                            ListValue.Active = true
                            --
                            ValueName_1.TextColor3 = Library.Theme.Default.Accent
                            ValueName_1.Text = "<b>" .. Value .. "</b>"
                            --
                            Library:AddTheme(ValueName_1, {
                                TextColor3 = "Accent",
                            })
                            --
                            List.CurrentValue = ListValue
                            List.CurrentValueName = Value
                            Library.Flags[Options.Flag] = List
                            Options.Callback(Value)
                        end
                    end
                    --
                    function ListValue:Deactivate()
                        if ListValue.Active then
                            ListValue.Active = false
                            ListValue.Hovering = false
                            ValueName_1.TextColor3 = Library.Theme.Default.TextColor
                            --
                            Library:AddTheme(ValueName_1, {
                                TextColor3 = "TextColor",
                            })
                        end
                    end
                end
                --
                do -- Connections
                    local OldText = ValueName_1.Text
                    --
                    Library:Connection(PreviewList:GetPropertyChangedSignal("AbsoluteSize"), function()
                        ValueName_1.Text = Library:ClampString(Value, ValueName_1.AbsoluteSize.X - 25)
                    end)
                    --
                    Library:Connection(InactiveValue.MouseEnter, function()
                        if Library.UI.Faded then return end
                        --
                        InactiveValue.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                        OldText = ValueName_1.Text
                        --
                        if not ListValue.Active then
                            ValueName_1.Text = "<b>" .. OldText .. "</b>"
                        end
                    end)
                    --
                    Library:Connection(InactiveValue.MouseLeave, function()
                        if Library.UI.Faded then return end
                        --
                        InactiveValue.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                        --
                        if not ListValue.Active then
                            ValueName_1.Text = OldText
                        end
                    end)
                    --
                    Library:Connection(Button_912.MouseButton1Click, function()
                        if Library.UI.Faded then return end
                        --
                        ListValue:Activate()
                    end)
                end
            end
            --
            function List:RemoveValue(Value)
                for _, Object in ListScrolling:GetChildren() do
                    if Object.Name == Value .. "1" then
                        Object:Destroy()
                    end
                end
            end
            --
            function List:UpdateSection()
                local CanvasSize = ListScrolling.AbsoluteCanvasSize.Y
                local AbsoluteSize = ListMain.AbsoluteSize.Y
                --
                if CanvasSize > AbsoluteSize then
                    ListMain.Size = UDim2.new(1, -8, 1, -2)
                    UpArrow.Visible = not List:CheckArrows("Up")
                    DownArrow.Visible = not List:CheckArrows("Down")
                elseif CanvasSize == AbsoluteSize then
                    ListMain.Size = UDim2.new(1, -2, 1, -2)
                    UpArrow.Visible = false
                    DownArrow.Visible = false
                end
            end
            --
            function List:CheckArrows(Type)
                if Type == "Up" then
                    return ListScrolling.CanvasPosition == Vector2.new(0, 0)
                elseif Type == "Down" then
                    return ListScrolling.CanvasPosition == Vector2.new(0, ListScrolling.AbsoluteCanvasSize.Y - ListScrolling.AbsoluteSize.Y)
                else
                    return false
                end
            end
        end
        --
        List:UpdateSection()
        --
        do -- Connections
            Library:Connection(ListScrolling.ChildAdded, function()
                List:UpdateSection()
            end)
            --
            Library:Connection(ListScrolling.ChildRemoved, function()
                List:UpdateSection()
            end)
            --
            Library:Connection(ListOutline:GetPropertyChangedSignal("AbsoluteSize"), function()
                List:UpdateSection()
            end)
            --
            Library:Connection(ListScrolling:GetPropertyChangedSignal("AbsoluteSize"), function()
                List:UpdateSection()
            end)
            --
            Library:Connection(ListScrolling:GetPropertyChangedSignal("CanvasPosition"), function()
                List:UpdateSection()
            end)
            --
            Library:Connection(UpArrow.MouseButton1Click, function()
                if Library.UI.Faded then return end
                --
                if not UpArrow.Visible then return end
                --
                Library:TweenObject(ListScrolling, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(0, 0)})
            end)
            --
            Library:Connection(DownArrow.MouseButton1Click, function()
                if Library.UI.Faded then return end
                --
                if not DownArrow.Visible then return end
                --
                Library:TweenObject(ListScrolling, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(0, ListScrolling.AbsoluteCanvasSize.Y - ListScrolling.AbsoluteSize.Y)})
            end)
        end
        --
        if Options.Hidden then
            List:SetVisible(false)
        end
        --
        return List
    end
    --
    function Library:Button(Options)
        Options = Library:Validate({
            Name = "Preview Button",
            Confirmation = false,
            Parent = nil,
            Hidden = false,
            Size = UDim2.new(1, 0, 0, 25),
            Position = UDim2.new(0, 0, 0, 0),
            Risky = false,
            Callback = function() end
        }, Options or {})
        --
        local Button = {
            MouseDown = false,
            Hovering = false,
            WaitingForConfirm = false,
            Hiding = false,
            ConfirmationTime = 0,
            ConfirmationConnection = nil,
        }
        --
        local PreviewButton = Library:CreateObject("Frame", {
            Name = "PreviewButton",
            BackgroundTransparency = 1,
            Size = Options.Size,
            Position = Options.Position,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Options.Parent
        })
        --
        local ButtonOutline = Library:CreateObject("Frame", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "ButtonOutline",
            Position = UDim2.new(0, -1, 0, 0),
            Size = UDim2.new(1, -19, 0, 25),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = PreviewButton
        })
        --
        local ButtonInline = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "ButtonInline",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            Parent = ButtonOutline
        })
        --
        local ButtonMain_1 = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "ButtonMain_1",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(220, 220, 220),
            Parent = ButtonInline
        })
        --
        local UIGradient_4 = Library:CreateObject("UIGradient", {
            Rotation = 90,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(39, 39, 39)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
            },
            Parent = ButtonMain_1
        })
        --
        local Button_6 = Library:CreateObject("TextButton", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Options.Risky and Library.Theme.Default.Risky or Library.Theme.Default.TextColor,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Button_6",
            RichText = true,
            Text = "<b>" .. Options.Name .. "</b>",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 3,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = ButtonOutline
        })
        --
        if Options.Risky then
            Library:AddTheme(Button_6, {
                TextColor3 = "Risky",
            })
        end
        --
        local UIPadding_8 = Library:CreateObject("UIPadding", {
            PaddingLeft = UDim.new(0, 20),
            Parent = PreviewButton
        })
        --
        do -- Functions
            function Button:UpdateSize(Size)
                ButtonOutline.Size = Size
            end
            --
            function Button:UpdatePosition(Position)
                PreviewButton.Position = Position
            end
            --
            function Button:SetVisible(Bool)
                local OldValues = Library.Objects[PreviewButton]
                --
                Button.Hiding = not Bool
                --
                if Bool then
                    Library.Objects[PreviewButton] = {PreviewButton, OldValues[2], true}
                end
                --
                Library:Fade(Bool, Library:GetObjectsTable(PreviewButton), PreviewButton, 0.075)
                Library:TweenObject(PreviewButton, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Bool and Options.Size or UDim2.new(1, 0, 0, -10)}, function()
                    if not Bool then
                        Library.Objects[PreviewButton] = {PreviewButton, OldValues[2], false}
                    end
                end)
            end
            --
            function Button:ConfirmationStart()
                Button.MouseDown = true
                Button.WaitingForConfirm = true
                Button.ConfirmationTime = 3
                Button_6.Text = "<b>Are you sure?</b>"
                --
                if Button.ConfirmationConnection then
                    coroutine.close(Button.ConfirmationConnection)
                    Button.ConfirmationConnection = nil
                end
                --
                Button.ConfirmationConnection = coroutine.create(function()
                    for i = 1, 3 do 
                        task.wait(1)
                        --
                        Button.ConfirmationTime = Button.ConfirmationTime - 1
                        --
                        if Button.ConfirmationTime <= 0 then
                            Button_6.Text = "<b>" .. Options.Name .. "</b>"
                            --
                            if Button.MouseDown then
                                Library:TweenObject(Button_6, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.Default.TextColor})
                                --
                                Button.MouseDown = false
                                Button.WaitingForConfirm = false
                            end
                            --
                            break
                        end
                    end
                end)
                --
                coroutine.resume(Button.ConfirmationConnection)
            end
        end
        --
        do -- Connections
            Library:Connection(Button_6.MouseButton1Down, function()
                if Library.UI.Faded then return end
                --
                if Button.Hiding then return end
                --
                Library:TweenObject(ButtonMain_1, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(180, 180, 180)})
                --
                if Options.Confirmation then
                    if not Button.WaitingForConfirm then
                        Button:ConfirmationStart()
                    else
                        if Button.ConfirmationConnection then
                            coroutine.close(Button.ConfirmationConnection)
                            Button.ConfirmationConnection = nil
                        end
                        --
                        Options.Callback()
                        Button.MouseDown = true
                        Button.Hovering = false
                        Button.WaitingForConfirm = false
                        --
                        Library:TweenObject(ButtonMain_1, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(180, 180, 180)})
                        --
                        Button_6.Text = "<b>" .. Options.Name .. "</b>"
                    end
                else
                    Options.Callback()
                    Button.MouseDown = true
                end
            end)
            --
            Library:Connection(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 and Button.MouseDown and not Button.WaitingForConfirm then
                    Button.Hovering = false
                    Button.MouseDown = false
                end
                --
                Library:TweenObject(ButtonMain_1, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(220, 220, 220)})
            end)
            --
            Library:Connection(ButtonOutline.MouseEnter, function()
                if Library.UI.Faded then return end
                --
                if not Button.MouseDown then
                    Button.Hovering = true
                    Library:TweenObject(ButtonMain_1, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                end	
            end)
            --
            Library:Connection(ButtonOutline.MouseLeave, function()
                if Library.UI.Faded then return end
                --
                if not Button.MouseDown then
                    Button.Hovering = false
                    Library:TweenObject(ButtonMain_1, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(220, 220, 220)})
                end	
            end)
        end
        --
        if Options.Hidden then
            Button:SetVisible(false)
        end
        --
        return Button
    end
    --
    function Library:Window(Options)
        Options = Library:Validate({
            Name = "Cerus Premium",
            Size = UDim2.new(0, 450, 0, 550),
            MinResize = UDim2.new(0, 400, 0, 450),
            MaxResize = UDim2.new(0, 10000, 0, 10000),
            CloseBind = Enum.KeyCode.Insert,
        }, Options or {})
        --
        local Window = {
            Visible = true,
            CurrentTab = nil,
            Tabs = {},
        }
        --
        local MainUI = Library:CreateObject("ScreenGui", {
            ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
            DisplayOrder = 1000,
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            Name = "\0",
            Parent = gethui()
        })
        --
        Library.UI.ScreenGUI = MainUI
        --
        local Outline = Library:CreateObject("Frame", {
            Name = "Outline",
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = Options.Size,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = MainUI
        })
        --
        Outline:SetAttribute("g", Window.CurrentTab)
        Library.UI.MainUI = Outline
        --
        Outline.Position = UDim2.fromOffset((Viewport.X / 2) - (Outline.Size.X.Offset / 2), (Viewport.Y / 2) - (Outline.Size.Y.Offset / 2))
        Outline.Active = true
        Outline.Draggable = true
        --
        local Inline = Library:CreateObject("Frame", {
            Name = "Inline",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            Parent = Outline
        })
        --
        local Inner = Library:CreateObject("Frame", {
            Name = "Inner",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            Parent = Inline
        })
        --
        local Outline_1 = Library:CreateObject("Frame", {
            Name = "Outline_1",
            Position = UDim2.new(0, 3, 0, 3),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -6, 1, -6),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            Parent = Inner
        })
        --
        local PatternHolder = Library:CreateObject("Frame", {
            Name = "PatternHolder",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            Parent = Outline_1
        })
        --
        local Pattern = Library:CreateObject("ImageLabel", {
            ImageColor3 = Color3.fromRGB(12, 12, 12),
            ScaleType = Enum.ScaleType.Tile,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Image = "rbxassetid://8547666218",
            BackgroundTransparency = 1,
            Name = "Pattern",
            Size = UDim2.new(1, 0, 1, 0),
            TileSize = UDim2.new(0, 8, 0, 8),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = PatternHolder
        })
        --
        local TopBarGradientHolder = Library:CreateObject("Frame", {
            Name = "TopBarGradientHolder",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -2, 0, 4),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Outline_1
        })
        --
        local GradientBar = Library:CreateObject("ImageLabel", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Image = "rbxassetid://8508019876",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 1, 0, 1),
            Name = "GradientBar",
            Size = UDim2.new(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = TopBarGradientHolder
        })
        --
        local UIGradient = Library:CreateObject("UIGradient", {
            Rotation = 90,
            Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 0.550000011920929)
            },
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 12, 12)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
            },
            Parent = TopBarGradientHolder
        })
        --
        local SideBarMain = Library:CreateObject("Frame", {
            Name = "SideBarMain",
            Position = UDim2.new(0, 1, 0, 5),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(0, 75, 1, -6),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            ClipsDescendants = true,
            Parent = Outline_1
        })
        --
        local Outline_2 = Library:CreateObject("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            Name = "Outline_2",
            Position = UDim2.new(1, 0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(0, 1, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            Parent = SideBarMain
        })
        --
        local Holder = Library:CreateObject("Frame", {
            BackgroundTransparency = 1,
            Name = "Holder",
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = SideBarMain
        })
        --
        local UIListLayout = Library:CreateObject("UIListLayout", {
            Padding = UDim.new(0, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = Holder
        })
        --
        local UIPadding = Library:CreateObject("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            Parent = Holder
        })
        --
        local Inline_4 = Library:CreateObject("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            Name = "Inline_4",
            Position = UDim2.new(1, -1, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(0, 1, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Parent = SideBarMain
        })
        --
        local ResizeButton = Library:CreateObject("TextButton", {
            FontFace = Library.UI.NewFont,
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Button",
            AnchorPoint = Vector2.new(1, 1),
            Size = UDim2.new(0, 20, 0, 20),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            TextTransparency = 1,
            TextSize = Library.UI.FontSize,
            ZIndex = 5,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Outline
        })
        --
        do -- Functions
            function Window:SetTab(Number)
                for Index, Tab in Window.Tabs do
                    if Index == Number then
                        if Window.CurrentTab ~= nil then
                            Window.CurrentTab:Deactivate()
                        end
                        --
                        Tab:Activate()
                    end
                end
            end
        end
        --
        do -- Connections
            Library:Connection(UserInputService.InputBegan, function(Input)
                if Input.KeyCode == Library.UI.CloseBind then
                    Window.Visible = not Window.Visible
                    --
                    Library:Fade(Window.Visible, Library.Objects, Outline, 0.2)
                end
            end)
            --
            Library:Resizable(Outline, ResizeButton, Options.MinResize, Options.MaxResize)
        end
        --
        function Window:CreateTab(Options)
            Options = Library:Validate({
                Icon = "rbxassetid://8547236654",
            }, Options or {})
            --
            local Tab = {
                Hovering = false,
                Active = false,
                Index = Library.UI.TabIndex + 1,
                SubSectionEnabled = false,
                DropdownSectionEnabled = false,
                Position = "Bottom",
                Sides = {
                    Left = {
                        Sections = {},
                        Sizes = 0,
                    },
                    Right = {
                        Sections = {},
                        Sizes = 0,
                    }
                }
            }
            --
            Library.UI.TabIndex = Tab.Index
            --
            local TabActive = Library:CreateObject("Frame", {
                BackgroundTransparency = 1,
                Name = "TabActive",
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(1, -2, 0, 64),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = Holder
            })
            --
            local Outline_3 = Library:CreateObject("Frame", {
                Name = "Outline_3",
                Size = UDim2.new(1, 0, 1, 0),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Visible = false,
                Parent = TabActive
            })
            --
            local Inline_1 = Library:CreateObject("Frame", {
                Size = UDim2.new(1, 1, 1, -2),
                Name = "Inline_1",
                Position = UDim2.new(0, 0, 0, 1),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                Parent = Outline_3
            })
            --
            local Main = Library:CreateObject("Frame", {
                Size = UDim2.new(1, 1, 1, -2),
                Name = "Main",
                Position = UDim2.new(0, 0, 0, 1),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                Parent = Inline_1
            })
            --
            local Pattern_1 = Library:CreateObject("ImageLabel", {
                ImageColor3 = Color3.fromRGB(12, 12, 12),
                ScaleType = Enum.ScaleType.Tile,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Name = "Pattern_1",
                Image = "rbxassetid://8547666218",
                BackgroundTransparency = 1,
                TileSize = UDim2.new(0, 8, 0, 8),
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Parent = Main
            })
            --
            local Button = Library:CreateObject("TextButton", {
                FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Name = "Button",
                Text = Options.Icon,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                TextColor3 = Color3.fromRGB(90, 90, 90),
                BorderSizePixel = 0,
                TextTransparency = 1,
                TextSize = Library.UI.FontSize,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = TabActive
            })
            --
            local Icon = Library:CreateObject("ImageLabel", {
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Name = "Button",
                Image = Options.Icon,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                ImageColor3 = Color3.fromRGB(109, 109, 109),
                BorderSizePixel = 0,
                ZIndex = 3,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = TabActive
            })
            --
            local SectionsHolder = Library:CreateObject("Frame", {
                Name = "SectionsHolder",
                BackgroundTransparency = 1,
                Visible = true,
                Position = UDim2.new(0, 76, 0, 5),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(1, -78, 1, -6),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ClipsDescendants = true,
                Parent = Outline_1
            })
            --
            local Left = Library:CreateObject("Frame", {
                BackgroundTransparency = 1,
                Name = "Left",
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0, 1, 0, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ClipsDescendants = true,
                Parent = SectionsHolder
            })
            --
            local UIPadding_1 = Library:CreateObject("UIPadding", {
                PaddingTop = UDim.new(0, 19),
                PaddingBottom = UDim.new(0, 19),
                PaddingRight = UDim.new(0, 8),
                PaddingLeft = UDim.new(0, 21),
                Parent = Left
            })
            --
            local UIListLayout12 = Library:CreateObject("UIListLayout", {
                Padding = UDim.new(0, 19),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = Left
            })
            --
            local Right = Library:CreateObject("Frame", {
                Name = "Right",
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 1, 0, 0),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(0.5, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ClipsDescendants = true,
                Parent = SectionsHolder
            })
            --
            local UIPadding_2 = Library:CreateObject("UIPadding", {
                PaddingTop = UDim.new(0, 19),
                PaddingBottom = UDim.new(0, 19),
                PaddingRight = UDim.new(0, 19),
                PaddingLeft = UDim.new(0, 10),
                Parent = Right
            })
            --
            local UIListLayout52 = Library:CreateObject("UIListLayout", {
                Padding = UDim.new(0, 19),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = Right
            })
            --
            local SectionsHolder2 = Library:CreateObject("Frame", {
                Name = "SectionsHolder",
                BackgroundTransparency = 1,
                Visible = true,
                Position = UDim2.new(0, 76, 0, 5),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(1, -78, 1, -6),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ClipsDescendants = true,
                Parent = Outline_1
            })
            --
            local SubSectionHolder = Library:CreateObject("Frame", {
                Name = "SubSectionHolder",
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(1, -39, 0, 61),
                BorderSizePixel = 0,
                ZIndex = 1,
                Visible = false,
                BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                Parent = SectionsHolder2
            })
            --
            Left.Position = UDim2.new(0, 0, 0, Left.AbsoluteSize.Y)
            Right.Position = UDim2.new(0.5, 1, 0, Right.AbsoluteSize.Y)
            SubSectionHolder.Position = UDim2.new(0, 21, 0, SectionsHolder2.AbsoluteSize.Y + SubSectionHolder.AbsoluteSize.Y)
            --
            do -- Functions
                function Tab:MoveSides(State)
                    task.spawn(function()
                        if State then
                            if Tab.Position == "Bottom" then
                                Left.Position = UDim2.new(0, 0, 0, Left.AbsoluteSize.Y)
                                Right.Position = UDim2.new(0.5, 1, 0, Right.AbsoluteSize.Y)
                                SubSectionHolder.Position = UDim2.new(0, 21, 0, SectionsHolder2.AbsoluteSize.Y + SubSectionHolder.AbsoluteSize.Y)
                            else
                                Left.Position = UDim2.new(0, 0, 0, -Left.AbsoluteSize.Y)
                                Right.Position = UDim2.new(0.5, 1, 0, -Right.AbsoluteSize.Y)
                                SubSectionHolder.Position = UDim2.new(0, 21, 0, -(SectionsHolder2.AbsoluteSize.Y + SubSectionHolder.AbsoluteSize.Y))
                            end
                            --
                            Library:TweenObject(SubSectionHolder, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0, 21, 0, 19)})
                            Library:TweenObject(Left, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
                            Library:TweenObject(Right, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 1, 0, 0)})
                        else
                            task.wait(0.001)
                            --
                            local SubSectionPosition = Tab.Position == "Bottom" and SectionsHolder2.AbsoluteSize.Y + 10 or -SectionsHolder2.AbsoluteSize.Y
                            local LeftPosition = Tab.Position == "Bottom" and Left.AbsoluteSize.Y + 10 or -Left.AbsoluteSize.Y
                            local RightPosition = Tab.Position == "Bottom" and Right.AbsoluteSize.Y + 10 or -Right.AbsoluteSize.Y
                            --
                            Library:TweenObject(SubSectionHolder, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0, 21, 0, SubSectionPosition)})
                            Library:TweenObject(Left, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, LeftPosition)})
                            Library:TweenObject(Right, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 1, 0, RightPosition)})
                        end
                    end)
                end
                --
                function Tab:Activate()
                    if not Tab.Active then
                        --
                        if Window.CurrentTab ~= nil then
                            Window.CurrentTab:Deactivate()
                        end
                        --
                        Tab.Active = true
                        Tab:MoveSides(true)
                        --
                        Library:TweenObject(Icon, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(210, 210, 210)})
                        Outline_3.Visible = true
                        --
                        Window.CurrentTab = Tab
                        Outline:SetAttribute("g", table.find(Window.Tabs, Tab))
                    end
                end
                --
                function Tab:Deactivate()
                    if Tab.Active then
                        Tab.Active = false
                        Tab.Hovering = false
                        Outline_3.Visible = false
                        Library:TweenObject(Icon, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(90, 90, 90)})
                        --
                        Tab:MoveSides(false)
                    end
                end
            end
            --
            do -- Connections
                Library:Connection(Outline:GetAttributeChangedSignal("g"), function()
                    if Outline:GetAttribute("g") > Tab.Index then
                        Tab.Position = "Top"
                    elseif Outline:GetAttribute("g") < Tab.Index then
                        Tab.Position = "Bottom"
                    end
                end)
                --
                Library:Connection(Outline:GetPropertyChangedSignal("AbsoluteSize"), function()
                    if not Tab.Active then
                        SubSectionHolder.Position = UDim2.new(0, 21, 0, SectionsHolder2.AbsoluteSize.Y + SubSectionHolder.AbsoluteSize.Y)
                        Left.Position = UDim2.new(0, 0, 0, Left.AbsoluteSize.Y)
                        Right.Position = UDim2.new(0.5, 1, 0, Right.AbsoluteSize.Y)
                    else
                        Left.Position = UDim2.new(0, 0, 0, 0)
                        Right.Position = UDim2.new(0.5, 1, 0, 0)
                    end
                end)
                --
                Library:Connection(Button.MouseButton1Click, function()
                    Tab:Activate()
                end)
                --
                Library:Connection(TabActive.MouseEnter, function()
                    if not Tab.Active then
                        Tab.Hovering = true
                        Library:TweenObject(Icon, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(168, 168, 168)})
                    end
                end)
                --
                Library:Connection(TabActive.MouseLeave, function()
                    if not Tab.Active then
                        Tab.Hovering = false
                        Library:TweenObject(Icon, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(90, 90, 90)})
                    end
                end)
            end
            --
            Window.Tabs[#Window.Tabs + 1] = Tab
            --
            function Tab:Section(Options)
                Options = Library:Validate({
                    Name = "Preview Section",
                    Side = "Left",
                    Fill = false,
                    Size = UDim2.new(1, 0, 0, 40),
                    ParentOptions = {},
                    Icon = nil,
                    Parent = nil,
                }, Options or {})
                --
                local Section = {
                    Elements = {},
                    SizeButton = nil,
                    Hovering = false,
                    DragConnection = nil,
                    Left = {
                        Order = 1,
                    },
                    Right = {
                        Order = 1,
                    },
                }
                --
                local Parent = Options.Side == "Left" and Left or Right
                --
                local SectionOutline = Library:CreateObject("Frame", {
                    Name = "SectionOutline",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, Options.Size),
                    AutomaticSize = Options.Fill and Enum.AutomaticSize.None or Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    ZIndex = 1,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = Options.Parent or Parent
                })
                --
                table.insert(Tab.Sides[Options.Side].Sections, SectionOutline)
                --
                task.delay(0.01, function()
                    if Options.Fill == false then
                        Tab.Sides[Options.Side].Sizes += SectionOutline.AbsoluteSize.Y + 19
                    end
                    --
                    if Options.Fill then
                        SectionOutline.Size = UDim2.new(1, 0, 1, -(Tab.Sides[Options.Side].Sizes))
                    else
                        SectionOutline.Size = UDim2.new(1, 0, 0, Options.Size)
                    end
                end)
                --
                local SectionInline = Library:CreateObject("Frame", {
                    Name = "SectionInline",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    Parent = SectionOutline
                })
                --
                local SectionScrolling = Library:CreateObject("ScrollingFrame", {
                    ScrollBarImageColor3 = Color3.fromRGB(65, 65, 65),
                    MidImage = "rbxassetid://158362264",
                    Active = true,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ScrollBarThickness = 5,
                    Size = UDim2.new(1, -2, 1, -2),
                    TopImage = "rbxassetid://158362264",
                    Position = UDim2.new(0, 1, 0, 1),
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    CanvasPosition = Vector2.new(0, 0),
                    BottomImage = "rbxassetid://158362264",
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    Parent = SectionInline
                })
                --
                local UIListLayout_3 = Library:CreateObject("UIListLayout", {
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = SectionScrolling
                })
                --
                local UIPadding_8 = Library:CreateObject("UIPadding", {
                    PaddingTop = UDim.new(0, 19),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 18),
                    PaddingLeft = UDim.new(0, 18),
                    Parent = SectionScrolling
                })
                --
                local SectionMain = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "SectionMain_1",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 1,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(23, 23, 23),
                    Parent = SectionInline
                })
                --
                local SectionFader = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, 0, 0, 20),
                    AnchorPoint = Vector2.new(0, 1),
                    Name = "SectionFader",
                    Position = UDim2.new(0, 0, 1, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 3,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(23, 23, 23),
                    Parent = SectionMain
                })
                --
                local DownArrow = Library:CreateObject("ImageButton", {
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "DownArrow",
                    Image = "rbxassetid://15540867448",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -10, 1, -9),
                    Size = UDim2.new(0, 5, 0, 4),
                    ZIndex = 4,
                    BorderSizePixel = 0,
                    Visible = false,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = SectionMain
                })
                --
                local UpArrow = Library:CreateObject("ImageButton", {
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "UpArrow",
                    Image = "rbxassetid://15540851994",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -10, 0, 5),
                    Size = UDim2.new(0, 5, 0, 4),
                    ZIndex = 4,
                    BorderSizePixel = 0,
                    Visible = false,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = SectionMain
                })
                --
                local UIGradient = Library:CreateObject("UIGradient", {
                    Rotation = -90,
                    Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(1, 1)
                    },
                    Parent = SectionFader
                })
                --
                local SectionFader2 = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, 0, 0, 20),
                    Name = "SectionFader",
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 3,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(23, 23, 23),
                    Parent = SectionMain
                })
                --
                local UIGradient = Library:CreateObject("UIGradient", {
                    Rotation = 90,
                    Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(1, 1)
                    },
                    Parent = SectionFader2
                })
                --
                local TitleInline = Library:CreateObject("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "TitleInline",
                    BorderSizePixel = 0,
                    Parent = SectionOutline,
                    Position = UDim2.new(0, 9, 0, 0),
                    Size = UDim2.new(0, 0, 0, 2),
                    ZIndex = 5
                })
                --
                local UIGradient2 = Library:CreateObject("UIGradient", {
                    Rotation = 90,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(19, 19, 19)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 24, 24))
                    },
                    Parent = TitleInline
                })
                --
                local Title = Library:CreateObject("TextButton", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Parent = SectionOutline,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(1, -26, 0, 15),
                    ZIndex = 5,
                    FontFace = Library.UI.NewFont,
                    RichText = true,
                    Text = "<b>" .. Options.Name .. "</b>",
                    TextColor3 = Color3.fromRGB(198, 198, 198),
                    TextSize = Library.UI.FontSize,
                    TextStrokeTransparency = 1,
                    TextXAlignment = "Left"
                })
                --
                local ResizableButton_6 = Library:CreateObject("ImageButton", {
                    ImageColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AnchorPoint = Vector2.new(1, 1),
                    Image = "http://www.roblox.com/asset/?id=127012144286347",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -2, 1, -2),
                    Name = "ResizableButton_6",
                    Size = UDim2.new(0, 6, 0, 6),
                    BorderSizePixel = 0,
                    ZIndex = 5,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = SectionOutline
                })
                --
                Section.Elements = {
                    Name = Title,
                    ContentHolder = SectionScrolling,
                }
                --
                Title.Size = UDim2.fromOffset(Title.TextBounds.X, 15)
                TitleInline.Size = UDim2.new(0, Title.TextBounds.X + 6, 0, 2)
                --
                do -- Functions
                    function Section:UpdateSection()
                        local CanvasSizeFloored = math.floor(SectionScrolling.AbsoluteCanvasSize.Y)
                        local AbsoluteSizeFloored = math.floor(SectionMain.AbsoluteSize.Y)
                        --
                        if CanvasSizeFloored > AbsoluteSizeFloored then
                            SectionMain.Size = UDim2.new(1, -8, 1, -2)
                            UpArrow.Visible = not Section:CheckArrows("Up")
                            DownArrow.Visible = not Section:CheckArrows("Down")
                        elseif CanvasSizeFloored == AbsoluteSizeFloored then
                            SectionMain.Size = UDim2.new(1, -2, 1, -2)
                            UpArrow.Visible = false
                            DownArrow.Visible = false
                        end
                    end
                    --
                    function Section:CheckArrows(Type)
                        if Type == "Up" then
                            return SectionScrolling.CanvasPosition == Vector2.new(0, 0)
                        elseif Type == "Down" then
                            return SectionScrolling.CanvasPosition == Vector2.new(0, SectionScrolling.AbsoluteCanvasSize.Y - SectionScrolling.AbsoluteSize.Y)
                        else
                            return false
                        end
                    end
                    --
                    function Section:CalculateHeight(Section, Container)
                        local Padding = 10
                        local Height = 0
                        --
                        for _, Child in Container:GetChildren() do
                            if Child:IsA("GuiObject") and Child.Visible then
                                Height = Height + Child.AbsoluteSize.Y + Padding
                            end
                        end
                        --
                        Section.Size = UDim2.new(Section.Size.X.Scale, Section.Size.X.Offset, 0, math.clamp(Height + 31, 50, SectionOutline.Parent.AbsoluteSize.Y))
                    end
                    --
                    function Section:CalculateButton(Position)
                        if Section.SizeButton then return end
                        --
                        local ButtonOutline = Library:CreateObject("Frame", {
                            Name = "SectionOutline",
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            Size = UDim2.new(0, 30, 0, 25),
                            BorderSizePixel = 0,
                            Position = Position,
                            ZIndex = 5,
                            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                            Parent = Library.UI.ScreenGUI
                        })
                        --
                        local ButtonMain = Library:CreateObject("Frame", {
                            Size = UDim2.new(1, -2, 1, -2),
                            Name = "SectionMain_1",
                            Position = UDim2.new(0, 1, 0, 1),
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            ZIndex = 5,
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                            Parent = ButtonOutline
                        })
                        --
                        local ButtonText = Library:CreateObject("TextLabel", {
                            AnchorPoint = Vector2.new(0, 0.5),
                            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                            BackgroundTransparency = 1,
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            BorderSizePixel = 0,
                            Parent = ButtonOutline,
                            Position = UDim2.new(0, 0, 0.5, -1),
                            Size = UDim2.new(1, 0, 1, 0),
                            ZIndex = 5,
                            FontFace = Library.UI.NewFont,
                            RichText = true,
                            Text = "Calculate height",
                            TextColor3 = Color3.fromRGB(198, 198, 198),
                            TextSize = Library.UI.FontSize,
                            TextStrokeTransparency = 1,
                            TextXAlignment = "Left"
                        })
                        --
                        local UIPadding_82 = Library:CreateObject("UIPadding", {
                            PaddingLeft = UDim.new(0, 8),
                            Parent = ButtonText
                        })
                        --
                        local Button_945 = Library:CreateObject("TextButton", {
                            FontFace = Library.UI.NewFont,
                            TextColor3 = Color3.fromRGB(0, 0, 0),
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            Name = "Button_9",
                            BackgroundTransparency = 1,
                            ZIndex = 5,
                            Size = UDim2.new(1, 0, 1, 0),
                            BorderSizePixel = 0,
                            TextTransparency = 1,
                            TextSize = Library.UI.FontSize,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Parent = ButtonOutline
                        })
                        --
                        Section.SizeButton = ButtonOutline
                        ButtonOutline.Size = UDim2.fromOffset(ButtonText.TextBounds.X + 16, 25)
                        ButtonOutline.BackgroundTransparency = 1
                        ButtonMain.BackgroundTransparency = 1
                        ButtonText.TextTransparency = 1
                        Button_945.TextTransparency = 1
                        --
                        do -- Connections
                            Library:Connection(Button_945.MouseEnter, function()
                                Section.Hovering = true
                            end)
                            --
                            Library:Connection(Button_945.MouseLeave, function()
                                Section.Hovering = false
                            end)
                            --
                            Library:Connection(Button_945.MouseButton1Click, function()
                                Section:CalculateHeight(SectionOutline, SectionScrolling)
                                Library:Fade(false, Library:GetObjectsTable(ButtonOutline, true), ButtonOutline, 0.1)
                                --
                                task.delay(Library.UI.TweenSpeed, function()
                                    for _, Value in ButtonOutline:GetDescendants() do
                                        Value:Destroy()
                                    end
                                    --
                                    ButtonOutline:Destroy()
                                    Section.SizeButton = nil
                                end)
                            end)
                        end
                        --
                        Library:Fade(true, Library:GetObjectsTable(ButtonOutline, true), ButtonOutline, 0.1)
                    end
                end
                --
                do -- Connections
                    Library:Connection(SectionScrolling.ChildAdded, function()
                        Section:UpdateSection()
                    end)
                    --
                    Library:Connection(SectionScrolling.ChildRemoved, function()
                        Section:UpdateSection()
                    end)
                    --
                    Library:Connection(SectionOutline:GetPropertyChangedSignal("AbsoluteSize"), function()
                        Section:UpdateSection()
                    end)
                    --
                    Library:Connection(RunService.PreRender, function() -- fastest option
                        if SectionOutline.AbsoluteSize.Y >= ((SectionOutline.Parent.AbsoluteSize.Y - Tab.Sides[Options.Side].Sizes) - 38) then
                            if Tab.SubSectionEnabled then
                                if #Tab.Sides[Options.Side].Sections <= 3 then
                                    SectionOutline.Size = UDim2.new(1, 0, 1, -Tab.Sides[Options.Side].Sizes)
                                end
                            else
                                SectionOutline.Size = UDim2.new(1, 0, 1, -Tab.Sides[Options.Side].Sizes)
                            end
                        end
                        --
                        for _, Child in SectionOutline.Parent:GetChildren() do
                            if Child:IsA("Frame") and Child ~= SectionOutline then
                                if Library:CheckFrameFirst(SectionOutline, Child) then
                                    if Child.AbsoluteSize.Y >= ((Child.Parent.AbsoluteSize.Y - Tab.Sides[Options.Side].Sizes) - 38) then
                                        Child.Size = UDim2.new(Child.Size.X.Scale, Child.Size.X.Offset, 0, math.max(50, (SectionOutline.Parent.AbsoluteSize.Y - SectionOutline.AbsoluteSize.Y) - 57))
                                    end
                                    --
                                    if Child.AbsoluteSize.Y == 50 and (SectionOutline.AbsoluteSize.Y == SectionOutline.Parent.AbsoluteSize.Y - 107) then
                                        SectionOutline.Size = UDim2.new(SectionOutline.Size.X.Scale, SectionOutline.Size.X.Offset, 0, SectionOutline.Parent.AbsoluteSize.Y - 107)
                                    end
                                end
                            end
                        end
                    end)
                    --
                    Library:Connection(SectionScrolling:GetPropertyChangedSignal("AbsoluteCanvasSize"), function()
                        Section:UpdateSection()
                    end)
                    --
                    Library:Connection(SectionScrolling:GetPropertyChangedSignal("CanvasPosition"), function()
                        UpArrow.Visible = not Section:CheckArrows("Up")
                        DownArrow.Visible = not Section:CheckArrows("Down")
                    end)
                    --
                    Library:Connection(UpArrow.MouseButton1Click, function()
                        if not UpArrow.Visible then return end
                        --
                        Library:TweenObject(SectionScrolling, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(0, 0)})
                    end)
                    --
                    Library:Connection(DownArrow.MouseButton1Click, function()
                        if not DownArrow.Visible then return end
                        --
                        Library:TweenObject(SectionScrolling, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(0, SectionScrolling.AbsoluteCanvasSize.Y - SectionScrolling.AbsoluteSize.Y)})
                    end)
                    --
                    do -- Dragging
                        Library:Connection(Title.MouseButton1Down, function()
                            Title.TextColor3 = Library.Theme.Default.Accent
                            --
                            Section.DragConnection = Library:Connection(UserInputService.InputChanged, function(Input)
                                if Input.UserInputType == Enum.UserInputType.MouseMovement then
                                    local SelectedOptions = {["SubSection"] = Options.ParentOptions, ["Other"] = {Left, Right}}
                                    local Selected = Tab.SubSectionEnabled and "SubSection" or "Other"
                                    local NewLeft, NewRight = SelectedOptions[Selected][1], SelectedOptions[Selected][2]
                                    local Parent2 = Library:SectionDragging(NewLeft) and NewLeft or Library:SectionDragging(NewRight) and NewRight
                                    local ParentName = Parent2 == NewLeft and "Left" or "Right"
                                    local TopHalf = Parent2 and Input.Position.Y < Parent2.AbsoluteSize.Y / 2
                                    --
                                    if not Parent2 then return end
                                    --
                                    SectionOutline.Parent = Parent2
                                    --
                                    for _, SectionChild in Parent2:GetChildren() do
                                        if SectionChild:IsA("Frame") and SectionChild.Visible then
                                            if SectionChild == SectionOutline then
                                                if TopHalf then
                                                    SectionChild.LayoutOrder = (Tab.DropdownSectionEnabled and Parent2 == NewLeft and 2) or 1
                                                else
                                                    SectionChild.LayoutOrder = Section[ParentName].Order + 1
                                                end
                                            else
                                                if SectionChild.Name == "DropdownSection1" then
                                                    SectionChild.LayoutOrder = 1
                                                else
                                                    SectionChild.LayoutOrder = Section[ParentName].Order
                                                    Section[ParentName].Order = 3
                                                end
                                            end
                                        end
                                    end
                                end
                            end)
                        end)
                    end
                    --
                    do -- Resizing
                        Library:Connection(ResizableButton_6.MouseButton2Click, function()
                            Section:CalculateButton(UDim2.fromOffset(ResizableButton_6.AbsolutePosition.X + ResizableButton_6.AbsoluteSize.X + 4, ResizableButton_6.AbsolutePosition.Y + ResizableButton_6.AbsoluteSize.Y + GuiService:GetGuiInset().Y))
                        end)
                        --
                        Library:Connection(ResizableButton_6.MouseButton1Down, function()
                            ResizableButton_6.ImageColor3 = Library.Theme.Default.Accent
                            SectionInline.BackgroundColor3 = Library.Theme.Default.Accent
                            --
                            SectionOutline.Size = UDim2.new(SectionOutline.Size.X.Scale, SectionOutline.Size.X.Offset, 0, SectionOutline.AbsoluteSize.Y)
                        end)
                        --
                        Library:Connection(UserInputService.InputBegan, function(Input)
                            if Input.UserInputType == Enum.UserInputType.MouseButton1 and Section.SizeButton and not Section.Hovering then
                                Library:Fade(false, Library:GetObjectsTable(Section.SizeButton, true), Section.SizeButton, 0.1)
                                --
                                task.delay(Library.UI.TweenSpeed, function()
                                    for _, Value in Section.SizeButton:GetDescendants() do
                                        Value:Destroy()
                                    end
                                    --
                                    Section.SizeButton:Destroy()
                                    Section.SizeButton = nil
                                end)
                            end
                        end)
                        --
                        Library:Resizable(SectionOutline, ResizableButton_6, UDim2.fromOffset(200, 50), UDim2.fromOffset(SectionOutline.Parent.AbsoluteSize.X - 29, SectionOutline.Parent.AbsoluteSize.Y - 38), Library.UI.SectionResizeIncrements, false, true, 0.01)
                    end
                    --
                    Library:Connection(UserInputService.InputEnded, function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            if Section.DragConnection then Section.DragConnection:Disconnect() Section.DragConnection = nil end
                            Section.Left.Order = 1
                            Section.Right.Order = 1
                            Title.TextColor3 = Color3.fromRGB(198, 198, 198)
                            --
                            ResizableButton_6.ImageColor3 = Color3.fromRGB(40, 40, 40)
                            SectionInline.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        end
                    end)
                end
                --
                return setmetatable(Section, Library.Sections)
            end
            --
            function Tab:SubSection(Options)
                Options = Library:Validate({
                    Name = "Preview Sub Section",
                    Options = {},
                    Flag = Library:NewFlag(),
                    Callback = function() end
                }, Options or {})
                --
                local SubSection = {
                    CurrentSection = nil,
                    Sections = {},
                    List = {},
                    Elements = {},
                }
                --
                SubSectionHolder.Visible = true
                Tab.SubSectionEnabled = true
                Tab.Sides.Right.Sizes = 0
                Tab.Sides.Left.Sizes = 0
                --
                local SectionOutline = Library:CreateObject("Frame", {
                    Name = "SectionOutline",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    ZIndex = 1,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = SubSectionHolder
                })
                --
                SectionOutline:SetAttribute("g", 0)
                --
                local SectionInline = Library:CreateObject("Frame", {
                    Name = "SectionInline",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    Parent = SectionOutline
                })
                --
                local SectionMain = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "SectionMain_1",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(23, 23, 23),
                    Parent = SectionInline
                })
                --
                local UIPadding_81 = Library:CreateObject("UIPadding", {
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10),
                    Parent = SectionMain
                })
                --
                local UIListLayout52 = Library:CreateObject("UIListLayout", {
                    Padding = UDim.new(0, -0),
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    HorizontalAlignment = Enum.HorizontalAlignment.Left,
                    Parent = SectionMain
                })
                --
                local TitleInline = Library:CreateObject("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "TitleInline",
                    BorderSizePixel = 0,
                    Parent = SectionOutline,
                    Position = UDim2.new(0, 9, 0, 0),
                    Size = UDim2.new(0, 0, 0, 2),
                    ZIndex = 5
                })
                --
                local UIGradient2 = Library:CreateObject("UIGradient", {
                    Rotation = 90,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(19, 19, 19)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 24, 24))
                    },
                    Parent = TitleInline
                })
                --
                local Title = Library:CreateObject("TextLabel", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Parent = SectionOutline,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(1, -26, 0, 15),
                    ZIndex = 5,
                    FontFace = Library.UI.NewFont,
                    RichText = true,
                    Text = "<b>" .. Options.Name .. "</b>",
                    TextColor3 = Color3.fromRGB(198, 198, 198),
                    TextSize = Library.UI.FontSize,
                    TextStrokeTransparency = 1,
                    TextXAlignment = "Left"
                })
                --
                for Index, Value in Options.Options do
                    local SectionItem = {
                        Active = false,
                        Hovering = false,
                        Position = "Bottom",
                        Elements = {},
                    }
                    --
                    local SectionsHolder2 = Library:CreateObject("Frame", {
                        Name = "SectionsHolder",
                        BackgroundTransparency = 1,
                        Visible = false,
                        Position = UDim2.new(0, 97, 0, 33),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Size = UDim2.new(1, -112, 1, -34),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        ClipsDescendants = true,
                        Parent = Outline_1
                    })
                    --
                    local UIPadding_141 = Library:CreateObject("UIPadding", {
                        PaddingTop = UDim.new(0, 52),
                        Parent = SectionsHolder2
                    })
                    --
                    local Left2 = Library:CreateObject("Frame", {
                        BackgroundTransparency = 1,
                        Name = "Left2",
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Size = UDim2.new(0.5, 0, 1, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = SectionsHolder2
                    })
                    --
                    local UIPadding_11 = Library:CreateObject("UIPadding", {
                        PaddingTop = UDim.new(0, 19),
                        PaddingBottom = UDim.new(0, 19),
                        PaddingRight = UDim.new(0, 12),
                        Parent = Left2
                    })
                    --
                    local UIListLayout12 = Library:CreateObject("UIListLayout", {
                        Padding = UDim.new(0, 19),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Parent = Left2
                    })
                    --
                    local Right2 = Library:CreateObject("Frame", {
                        Name = "Right2",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0, 0),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Size = UDim2.new(0.5, 0, 1, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = SectionsHolder2
                    })
                    --
                    local UIPadding_21 = Library:CreateObject("UIPadding", {
                        PaddingTop = UDim.new(0, 19),
                        PaddingBottom = UDim.new(0, 19),
                        PaddingRight = UDim.new(0, 6),
                        PaddingLeft = UDim.new(0, 6),
                        Parent = Right2
                    })
                    --
                    local UIListLayout521 = Library:CreateObject("UIListLayout", {
                        Padding = UDim.new(0, 19),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Parent = Right2
                    })
                    --
                    local Icon = Library:CreateObject("ImageButton", {
                        ImageColor3 = Color3.fromRGB(100, 100, 100),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Name = "Icon",
                        Image = Value,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 75, 0, 57),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = SectionMain
                    })
                    --
                    Left2.Position = UDim2.new(0, -(Left2.AbsoluteSize.X * 2), 0, 0)
                    Right2.Position = UDim2.new(0.5, -(Right2.AbsoluteSize.X * 2), 0, 0)
                    --
                    do -- Functions
                        function SectionItem:MoveSides(State)
                            task.spawn(function()
                                if State then
                                    if SectionItem.Position == "Bottom" then
                                        Left2.Position = UDim2.new(0, (Left2.AbsoluteSize.X * 2), 0, 0)
                                        Right2.Position = UDim2.new(0.5, (Right2.AbsoluteSize.X * 2), 0, 0)
                                    else
                                        Left2.Position = UDim2.new(0, -(Left2.AbsoluteSize.X * 2), 0, 0)
                                        Right2.Position = UDim2.new(0.5, -(Right2.AbsoluteSize.X * 2), 0, 0)
                                    end
                                    --
                                    SectionsHolder2.Visible = Outline:GetAttribute("g") == table.find(Window.Tabs, Tab)
                                    Library:TweenObject(Left2, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0, 1, 0, 0)})
                                    Library:TweenObject(Right2, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 1, 0, 0)})
                                else
                                    task.wait(0.001)
                                    --
                                    local LeftPosition = SectionItem.Position == "Bottom" and (Left2.AbsoluteSize.X * 2) + 10 or -(Left2.AbsoluteSize.X * 2)
                                    local RightPosition = SectionItem.Position == "Bottom" and (Right2.AbsoluteSize.X * 2) + 10 or -(Right2.AbsoluteSize.X * 2)
                                    --
                                    Library:TweenObject(Left2, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0, LeftPosition, 0, 0)})
                                    Library:TweenObject(Right2, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, RightPosition, 0, 0)})
                                end
                            end)
                        end
                        --
                        function SectionItem:Activate()
                            if not SectionItem.Active then
                                if SubSection.CurrentSection ~= nil then
                                    SubSection.CurrentSection:Deactivate()
                                end
                                --
                                SectionItem.Active = true
                                --
                                SectionItem:MoveSides(true)
                                Icon.ImageColor3 = Color3.fromRGB(188, 188, 188)
                                --
                                SubSection.CurrentSection = SectionItem
                                SectionOutline:SetAttribute("g", Index)
                            end
                        end
                        --
                        function SectionItem:Deactivate()
                            if SectionItem.Active then
                                SectionItem.Active = false
                                SectionItem.Hovering = false
                                --
                                SectionItem:MoveSides(false)
                                Icon.ImageColor3 = Color3.fromRGB(93, 93, 93)
                            end
                        end
                        --
                        function SectionItem:Section(Options)
                            Options = Library:Validate({
                                Name = "Preview Section",
                                Side = "Left",
                                Size = 40,
                            }, Options or {})
                            --
                            local Section = Tab:Section({
                                Name = Options.Name,
                                Side = Options.Side,
                                Fill = Options.Fill,
                                Size = Options.Size,
                                Parent = Options.Side == "Left" and Left2 or Right2,
                                ParentOptions = {Left2, Right2},
                                Icon = Icon,
                            })
                            --
                            return Section
                        end
                    end
                    --
                    do -- Connections
                        Library:Connection(Outline:GetPropertyChangedSignal("AbsoluteSize"), function()
                            if not SectionItem.Active then
                                Left2.Position = UDim2.new(0, Left2.AbsoluteSize.X * 2, 0, 0)
                                Right2.Position = UDim2.new(0.5, Right2.AbsoluteSize.X * 2, 0, 0)
                            end
                        end)
                        --
                        Library:Connection(Outline:GetAttributeChangedSignal("g"), function()
                            if Outline:GetAttribute("g") == table.find(Window.Tabs, Tab) then
                                SectionsHolder2.Visible = true
                            end
                        end)
                        --
                        Library:Connection(SectionOutline:GetAttributeChangedSignal("g"), function()
                            if SectionOutline:GetAttribute("g") > Index then
                                SectionItem.Position = "Top"
                            elseif SectionOutline:GetAttribute("g") < Index then
                                SectionItem.Position = "Bottom"
                            end
                        end)
                        --
                        Library:Connection(Left:GetPropertyChangedSignal("AbsolutePosition"), function()
                            if SectionItem.Active then
                                Left2.Position = Left.Position
                            end
                        end)
                        --
                        Library:Connection(Right:GetPropertyChangedSignal("AbsolutePosition"), function()
                            if SectionItem.Active then
                                Right2.Position = Right.Position
                            end
                        end)
                        --
                        Library:Connection(Icon.MouseButton1Click, function()
                            SectionItem:Activate()
                        end)
                        --
                        Library:Connection(Icon.MouseEnter, function()
                            if not SectionItem.Active then
                                SectionItem.Hovering = true
                                Icon.ImageColor3 = Color3.fromRGB(124, 124, 124)
                            end
                        end)
                        --
                        Library:Connection(Icon.MouseLeave, function()
                            if not SectionItem.Active then
                                SectionItem.Hovering = false
                                Icon.ImageColor3 = Color3.fromRGB(93, 93, 93)
                            end
                        end)
                    end
                    --
                    if SubSection.CurrentSection == nil then
                        SectionItem:Activate()
                    end
                    --
                    SubSection.Sections[#SubSection.Sections + 1] = setmetatable(SectionItem, Library.Sections)
                end
                --
                SubSection.Elements = {
                    Name = Title,
                    ContentHolder = SectionMain,
                }
                --
                TitleInline.Size = UDim2.new(0, Title.TextBounds.X + 6, 0, 2)
                --
                return table.unpack(SubSection.Sections)
            end
            --
            function Tab:ImageDropdown(Options)
                Options = Library:Validate({
                    Name = "Weapon Type",
                    Options = {},
                    Default = nil,
                    Flag = Library:NewFlag(),
                    Callback = function() end
                }, Options or {})
                --
                local ImageDropdown = {
                    Open = false,
                    Active = false,
                    Hovering = false,
                    CurrentItem = nil,
                    Scrollable = false,
                    Hiding = false,
                    ContentLength = Library:GetTableLength(Options.Options),
                }
                --
                Tab.DropdownSectionEnabled = true
                Tab.Sides.Left.Sizes = 70
                --
                local DropdownImageOutline = Library:CreateObject("Frame", {
                    Name = "DropdownSection1",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 51),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = Left
                })
                --
                local DropdownChecker = Library:CreateObject("Frame", {
                    Name = "DropdownChecker",
                    Position = UDim2.new(0, 0, 1, 0),
                    Visible = false,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    Parent = DropdownImageOutline
                })
                --
                local DropdownImageInline = Library:CreateObject("Frame", {
                    Name = "DropdownImageInline",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    Parent = DropdownImageOutline
                })
                --
                local DropdownImageMain = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "DropdownImageMain",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(23, 23, 23),
                    Parent = DropdownImageInline
                })
                --
                local Button_92 = Library:CreateObject("TextButton", {
                    FontFace = Library.UI.NewFont,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "Button_9",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextTransparency = 1,
                    TextSize = Library.UI.FontSize,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = DropdownImageMain
                })
                --
                local DownArrow = Library:CreateObject("ImageLabel", {
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "DownArrow",
                    Size = UDim2.new(0, 5, 0, 4),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://15540867448",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -6, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    ImageColor3 = Color3.fromRGB(210, 210, 210),
                    Parent = DropdownImageMain
                })
                --
                local Icon = Library:CreateObject("ImageLabel", {
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "Icon",
                    Size = UDim2.new(0, 50, 1, -6),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://18657040454",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -14, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    ImageColor3 = Color3.fromRGB(210, 210, 210),
                    Parent = DropdownImageMain
                })
                --
                local ToggleHolder = Library:CreateObject("Frame", {
                    Name = "ToggleHolder",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 100, 1, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = DropdownImageMain
                })
                --
                local ActualToggleButton = Library:Toggle({
                    Default = false,
                    Name = "Global",
                    SectionName = "ToggleHolder",
                    Parent = ToggleHolder,
                    Risky = false,
                    MainUI = Outline,
                    ZIndex = 2,
                    TabUI = SideBarMain,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    UseToggleOutline = true,
                    Hidden = false,
                    Flag = Options.Flag .. "Extra",
                    Callback = function(State)
                        if ImageDropdown.CurrentItem then
                            ImageDropdown.CurrentItem:SetValue(State)
                            Library.Flags[Options.Flag] = ImageDropdown.CurrentItem
                            Options.Callback(ImageDropdown.CurrentItem.Name, ImageDropdown.CurrentItem.CurrentValue)
                        end
                    end,
                })
                --
                local UIPadding = Library:CreateObject("UIPadding", {
                    PaddingLeft = UDim.new(0, 18),
                    Parent = ToggleHolder
                })
                --
                local TitleInline = Library:CreateObject("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "TitleInline",
                    BorderSizePixel = 0,
                    Parent = DropdownImageOutline,
                    Position = UDim2.new(0, 9, 0, 0),
                    Size = UDim2.new(0, 0, 0, 2),
                    ZIndex = 5
                })
                --
                local UIGradient2 = Library:CreateObject("UIGradient", {
                    Rotation = 90,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(19, 19, 19)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 24, 24))
                    },
                    Parent = TitleInline
                })
                --
                local Title = Library:CreateObject("TextButton", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Parent = DropdownImageOutline,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(1, -26, 0, 15),
                    ZIndex = 5,
                    FontFace = Library.UI.NewFont,
                    RichText = true,
                    Text = "<b>" .. Options.Name .. "</b>",
                    TextColor3 = Color3.fromRGB(198, 198, 198),
                    TextSize = Library.UI.FontSize,
                    TextStrokeTransparency = 1,
                    TextXAlignment = "Left"
                })
                --
                local DropdownMainOutline = Library:CreateObject("Frame", {
                    Name = "DropdownMainOutline",
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 50,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = Library.UI.ScreenGUI
                })
                --
                local DropdownMain = Library:CreateObject("Frame", {
                    Name = "DropdownMain",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    ZIndex = 50,
                    ClipsDescendants = true,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    Parent = DropdownMainOutline
                })
                --
                DropdownMainOutline.BackgroundTransparency = 1
                DropdownMain.BackgroundTransparency = 1
                --
                local UIListLayout_9 = Library:CreateObject("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = DropdownMain
                })
                --
                Title.Size = UDim2.fromOffset(Title.TextBounds.X, 15)
                TitleInline.Size = UDim2.new(0, Title.TextBounds.X + 6, 0, 2)
                --
                for Index, Value in Options.Options do
                    local DropdownOption = {
                        Hovering = false,
                        Active = false,
                        CurrentValue = false,
                        Name = Index,
                    }
                    --
                    local ButtonMain = Library:CreateObject("Frame", {
                        Name = "DropdownMain",
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Size = UDim2.new(1, 0, 0, 30),
                        BorderSizePixel = 0,
                        ZIndex = 50,
                        ClipsDescendants = true,
                        LayoutOrder = Value.Order,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = DropdownMain
                    })
                    --
                    local Button_925 = Library:CreateObject("TextButton", {
                        FontFace = Library.UI.NewFont,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Name = "Button_9",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        ZIndex = 50,
                        TextTransparency = 1,
                        TextSize = Library.UI.FontSize,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = ButtonMain
                    })
                    --
                    ButtonMain.BackgroundTransparency = 1
                    --
                    local ToggleButton = Library:Toggle({
                        Default = false,
                        Name = Index,
                        SectionName = "ImageDropdown",
                        Parent = ButtonMain,
                        Risky = false,
                        MainUI = Outline,
                        ZIndex = 50,
                        TabUI = SideBarMain,
                        AnchorPoint = Vector2.new(0, 0.5),
                        Position = UDim2.new(0, 15, 0.5, 0),
                        Hidden = false,
                        Callback = function(State)

                        end,
                    })
                    --
                    local IconButton = Library:CreateObject("ImageLabel", {
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Name = "Icon",
                        Size = UDim2.new(0, 35, 1, 0),
                        AnchorPoint = Vector2.new(1, 0.5),
                        Image = Value.Icon,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, -10, 0.5, 0),
                        ZIndex = 50,
                        BorderSizePixel = 0,
                        ImageColor3 = Color3.fromRGB(124, 124, 124),
                        Parent = ButtonMain
                    })
                    --
                    do -- Functions
                        function DropdownOption:Activate()
                            if not DropdownOption.Active then
                                if ImageDropdown.CurrentItem ~= nil then
                                    ImageDropdown.CurrentItem:Deactivate()
                                end
                                --
                                DropdownOption.Active = true
                                ImageDropdown.CurrentItem = DropdownOption
                                --
                                IconButton.ImageColor3 = Color3.fromRGB(210, 210, 210)
                                Icon.Image = Value.Icon
                                ActualToggleButton:SetName(Index)
                            end
                        end
                        --
                        function DropdownOption:Deactivate()
                            if DropdownOption.Active then
                                DropdownOption.Active = false
                                DropdownOption.Hovering = false
                                ImageDropdown.CurrentItem = nil
                                --
                                ButtonMain.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                                IconButton.ImageColor3 = Color3.fromRGB(124, 124, 124)
                            end
                        end
                        --
                        function DropdownOption:SetValue(Value)
                            ToggleButton:Set(Value)
                            DropdownOption.CurrentValue = Value
                        end
                        --
                        function DropdownOption:Get()
                            return {Name = DropdownOption.Name, Value = DropdownOption.CurrentValue}
                        end
                    end
                    --
                    do -- Connections
                        Library:Connection(ButtonMain.MouseEnter, function()
                            ButtonMain.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                            IconButton.ImageColor3 = Color3.fromRGB(210, 210, 210)
                        end)
                        --
                        Library:Connection(ButtonMain.MouseLeave, function()
                            ButtonMain.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                            --
                            if DropdownOption.Active then return end
                            --
                            IconButton.ImageColor3 = Color3.fromRGB(124, 124, 124)
                        end)
                        --
                        Library:Connection(Button_925.MouseButton1Click, function()
                            DropdownOption:Activate()
                            ActualToggleButton:Set(DropdownOption.CurrentValue)
                        end)
                    end
                    --
                    if Options.Default == Index then
                        DropdownOption:Activate()
                    end
                    --
                    Library:Fade(false, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0.1)
                end
                --
                do -- Functions
                    function ImageDropdown:Toggle(Fast)
                        local Fast = Fast or false
                        local OldValues = Library.Objects[DropdownMainOutline]
                        --
                        if ImageDropdown.Open then
                            if Fast then
                                Library:Fade(false, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0)
                                DropdownMainOutline.Size = UDim2.new(0, DropdownImageOutline.AbsoluteSize.X, 0, 0)
                                Library.Objects[DropdownMainOutline] = {DropdownMainOutline, OldValues[2], true}
                            else
                                Library:Fade(false, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0.1)
                                Library:TweenObject(DropdownMainOutline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, DropdownImageOutline.AbsoluteSize.X, 0, 0)}, function()
                                    Library.Objects[DropdownMainOutline] = {DropdownMainOutline, OldValues[2], true}
                                end)
                            end
                        else
                            Library.Objects[DropdownMainOutline] = {DropdownMainOutline, OldValues[2], false}
                            --
                            if Fast then
                                Library:Fade(true, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0)
                                DropdownMainOutline.Size = UDim2.new(0, DropdownImageOutline.AbsoluteSize.X, 0, (ImageDropdown.ContentLength * 30) + 2)
                            else
                                Library:Fade(true, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0.1)
                                Library:TweenObject(DropdownMainOutline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, DropdownImageOutline.AbsoluteSize.X, 0, (ImageDropdown.ContentLength * 30) + 2)})
                            end	
                        end
                        --
                        ImageDropdown.Open = not ImageDropdown.Open
                    end
                    --
                    function ImageDropdown:Update()
                        DropdownMainOutline.Size = UDim2.new(0, DropdownImageOutline.AbsoluteSize.X, 0, DropdownMainOutline.AbsoluteSize.Y)
                        DropdownMainOutline.Position = UDim2.new(0, DropdownImageOutline.AbsolutePosition.X, 0, ((DropdownImageOutline.AbsolutePosition.Y + DropdownImageOutline.AbsoluteSize.Y) + GuiService:GetGuiInset().Y + 2))
                    end
                end
                --
                do -- Dropdown Connections
                    ImageDropdown:Update()
                    --
                    Library:Connection(DropdownImageOutline:GetPropertyChangedSignal("AbsolutePosition"), ImageDropdown.Update)
                    Library:Connection(DropdownImageOutline:GetPropertyChangedSignal("AbsoluteSize"), ImageDropdown.Update)
                    --
                    local StartingY = DropdownImageOutline.AbsolutePosition.Y
                    local MainUIStartingY = Outline.AbsolutePosition.Y
                    --
                    Library:Connection(DropdownImageOutline:GetPropertyChangedSignal("AbsolutePosition"), function()
                        if not ImageDropdown.Open then return end
                        --
                        local CurrentY = DropdownImageOutline.AbsolutePosition.Y
                        local MainUICurrentY = Outline.AbsolutePosition.Y
                        --
                        if MainUICurrentY ~= MainUIStartingY then
                            MainUIStartingY = MainUICurrentY
                            StartingY = CurrentY
                            --
                            return
                        end
                        --
                        if Library.UI.Resizing then
                            return
                        end
                        --
                        if CurrentY ~= StartingY then
                            ImageDropdown:Toggle(true)
                        end
                        --
                        StartingY = CurrentY
                    end)
                end
                --
                do -- Connections
                    Library:Connection(Button_92.MouseButton1Click, function()
                        ImageDropdown:Toggle()
                    end)
                end
            end
            --
            function Sections:Dropdown(Options)
                Options = Library:Validate({
                    Default = "None",
                    Name = "Preview Dropdown",
                    Content = {},
                    Hiding = false,
                    Risky = false,
                    Flag = Library.NewFlag(),
                    Callback = function() end
                }, Options or {})
                --
                local Dropdown = Library:Dropdown({
                    Default = Options.Default,
                    Name = Options.Name,
                    Content = Options.Content,
                    MainUI = Outline,
                    TabUI = SideBarMain,
                    Hiding = Options.Hiding,
                    Risky = Options.Risky,
                    Flag = Options.Flag,
                    Callback = Options.Callback,
                    Parent = self.Elements.ContentHolder
                })
                --
                return Dropdown
            end
            --
            function Sections:MultiBox(Options)
                Options = Library:Validate({
                    Default = {},
                    Name = "Preview MultiBox",
                    Content = {},
                    Hiding = false,
                    Risky = false,
                    Flag = Library.NewFlag(),
                    Callback = function() end
                }, Options or {})
                --
                local Dropdown = Library:MultiBox({
                    Default = Options.Default,
                    Name = Options.Name,
                    Content = Options.Content,
                    MainUI = Outline,
                    TabUI = SideBarMain,
                    Hiding = Options.Hiding,
                    Risky = Options.Risky,
                    Flag = Options.Flag,
                    Callback = Options.Callback,
                    Parent = self.Elements.ContentHolder
                })
                --
                return Dropdown
            end
            --
            function Sections:Toggle(Options)
                Options = Library:Validate({
                    Default = false,
                    Name = "Preview Toggle",
                    Risky = false,
                    Hidden = false,
                    Flag = Library:NewFlag(),
                    Callback = function() end
                }, Options or {})
                --
                local Toggle = Library:Toggle({
                    Default = Options.Default,
                    Name = Options.Name,
                    SectionName = self.Elements.Name,
                    Parent = self.Elements.ContentHolder,
                    Risky = Options.Risky,
                    MainUI = Outline,
                    TabUI = SideBarMain,
                    Hidden = Options.Hidden,
                    Flag = Options.Flag,
                    Callback = Options.Callback
                })
                --
                return Toggle
            end
            --
            function Sections:Slider(Options)
                Options = Library:Validate({
                    Name = "Preview Slider",
                    Min = 0,
                    Max = 100,
                    Default = 1,
                    Decimal = 1,
                    Ending = "",
                    Hidden = false,
                    UseIcons = true,
                    Disable = {},
                    Risky = false,
                    OverrideLimit = false, -- new parameter to allow values beyond max
                    Flag = Library.NewFlag(),
                    Callback = function() end
                }, Options or {})
                --
                local Slider = Library:Slider({
                    Name = Options.Name,
                    Min = Options.Min,
                    Max = Options.Max,
                    Default = Options.Default,
                    Decimal = Options.Decimal,
                    Ending = Options.Ending,
                    Hidden = Options.Hidden,
                    Parent = self.Elements.ContentHolder,
                    Risky = Options.Risky,
                    Disable = Options.Disable,
                    OverrideLimit = Options.OverrideLimit, -- pass the parameter
                    Flag = Options.Flag,
                    UseIcons = Options.UseIcons,
                    Callback = Options.Callback
                })
                --
                return Slider
            end
            --
            function Sections:Label(Options)
                Options = Library:Validate({
                    Message = "Preview Label",
                    Risky = false,
                    Side = "Left",
                    Hidden = false,
                }, Options or {})
                --
                local Label = Library:Label({
                    Message = Options.Message,
                    Side = Options.Side,
                    Risky = Options.Risky,
                    MainUI = Outline,
                    Hidden = Options.Hidden,
                    TabUI = SideBarMain,
                    SectionName = self.Elements.Name,
                    Callback = Options.Callback,
                    Parent = self.Elements.ContentHolder
                })
                --
                return Label
            end
            --
            function Sections:TextBox(Options)
                Options = Library:Validate({
                    Default = "",
                    Name = "Preview TextBox",
                    Max = 32,
                    NumbersOnly = false,
                    ClearOnFocus = false,
                    CheckIfPressedEnter = false,
                    Risky = false,
                    Hidden = false,
                    Flag = Library.NewFlag(),
                    Callback = function() end
                }, Options or {})
                --
                local TextBox = Library:TextBox({
                    Default = Options.Default,
                    Name = Options.Name,
                    Max = Options.Max,
                    NumbersOnly = Options.NumbersOnly,
                    ClearOnFocus = Options.ClearOnFocus,
                    CheckIfPressedEnter = Options.CheckIfPressedEnter,
                    Risky = Options.Risky,
                    Hidden = Options.Hidden,
                    Parent = self.Elements.ContentHolder,
                    Flag = Options.Flag,
                    Callback = Options.Callback
                })
                --
                return TextBox
            end
            --
            function Sections:List(Options)
                Options = Library:Validate({
                    Size = 100,
                    Hidden = false,
                    Flag = Library.NewFlag(),
                    Callback = function() end
                }, Options or {})
                --
                local TextBox = Library:List({
                    Size = Options.Size,
                    Hidden = Options.Hidden,
                    Parent = self.Elements.ContentHolder,
                    Flag = Options.Flag,
                    Callback = Options.Callback
                })
                --
                return TextBox
            end
            --
            function Sections:Button(Options)
                Options = Library:Validate({
                    Name = "Preview Button",
                    Confirmation = false,
                    Risky = false,
                    Hidden = false,
                    Callback = function() end
                }, Options or {})
                --
                local Button = Library:Button({
                    Name = Options.Name,
                    Confirmation = Options.Confirmation,
                    Risky = Options.Risky,
                    Hidden = Options.Hidden,
                    Parent = self.Elements.ContentHolder,
                    Callback = Options.Callback
                })
                --
                return Button
            end
            --
            return Tab
        end
        --
        function Library:CreateWatermark()
            local Watermark = {
                CanUse = true,
                Tick = tick(),
                RefreshTick = tick(),
            }
            --
            local MainWatermark = Library:CreateObject("Frame", {
                Name = "Watermark",
                Position = UDim2.new(0, 0, 0, 0),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(0, 400, 0, 20),
                BorderSizePixel = 0,
                ZIndex = 10000,
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Parent = Library.UI.ScreenGUI
            }, true)
            --
            local UIGradient = Library:CreateObject("UIGradient", {
                Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.25, 0.6119999885559082),
                    NumberSequenceKeypoint.new(0.5, 0.625),
                    NumberSequenceKeypoint.new(0.75, 0.625),
                    NumberSequenceKeypoint.new(1, 1)
                },
                Parent = MainWatermark
            }, true)
            --
            local UIStroke = Library:CreateObject("UIStroke", {
                Parent = MainWatermark
            }, true)
            --
            local UIGradient_1 = Library:CreateObject("UIGradient", {
                Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.232, 0.4000000059604645),
                    NumberSequenceKeypoint.new(0.5, 0.4000000059604645),
                    NumberSequenceKeypoint.new(0.75, 0.4000000059604645),
                    NumberSequenceKeypoint.new(1, 1)
                },
                Parent = UIStroke
            }, true)
            --
            local WatermarkText = Library:CreateObject("TextLabel", {
                FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                TextColor3 = Color3.fromRGB(208, 208, 208),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Text = "gamesense",
                Name = "Text",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 10000,
                RichText = true,
                TextSize = 14,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = MainWatermark
            }, true)
            --
            local Stroke = Library:CreateObject("UIStroke", {
                Parent = WatermarkText,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Color = Color3.fromRGB(50, 50, 50),
            }, true)
            --
            local UIPadding = Library:CreateObject("UIPadding", {
                PaddingRight = UDim.new(0, 22),
                PaddingLeft = UDim.new(0, 22),
                Parent = WatermarkText
            }, true)
            --
            do -- Functions
                function Library:ToggleWatermark(State)
                    Watermark.CanUse = State
                    MainWatermark.Visible = State
                end
                --
                function Library:UpdateWatermark(Text)
                    if Watermark.CanUse and not MainWatermark.Visible then MainWatermark.Visible = true end
                    --
                    WatermarkText.Text = tostring(Text)
                    MainWatermark.Size = UDim2.new(0, WatermarkText.TextBounds.X + 44, 0, MainWatermark.Size.Y.Offset)
                    MainWatermark.Position = UDim2.new(1, -(MainWatermark.Size.X.Offset) - 5, 0, 5)
                end
            end
            --
            local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
            --
            Library:UpdateWatermark(("Cerus <font color='rgb(%d, %d, %d)'>Premium</font>  <font color='rgb(%d, %d, %d)'>%s</font> <font size='10'>FPS</font>  %s"):format(R, G, B, R, G, B, "60", os.date("%X")))
            --
            Library:Notify({
                Message = ("You are using <font color='rgb(%d, %d, %d)'>Cerus Premium</font>. Join <font color='rgb(%d, %d, %d)'>@</font> discord.gg/3E82u6ecyW"):format(R, G, B, R, G, B),
                Position = "Top Left",
                Delay = 15
            })
            --
            do -- Connections
                Library:Connection(RunService.PostSimulation, function()
                    if Library.UI.Initialized and MainWatermark.Visible then
                        local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
                        local FPS = math.floor(1 / math.abs(Watermark.Tick - tick()))
                        --
                        Watermark.Tick = tick()
                        --
                        if (tick() - Watermark.RefreshTick) > Library.UI.WatermarkRefreshRate then
                            Library:UpdateWatermark(("Cerus <font color='rgb(%d, %d, %d)'>Premium</font>  <font color='rgb(%d, %d, %d)'>%s</font> <font size='10'>FPS</font>  %s"):format(R, G, B, R, G, B, FPS, os.date("%X")))
                            --
                            Watermark.RefreshTick = tick()
                        end
                    end
                end)
            end
        end
        --
        function Library:Notify(Options)
            Options = Library:Validate({
                Message = "Notification",
                Delay = 3,
                Position = "Top Left",
            }, Options or {})
            --
            local Notification = {}
            local Path = Options.Position == "Top Left" and Library.UI.Notifications.TopLeft or Library.UI.Notifications.Middle
            --
            local NotificationFrameObject = Library:CreateObject("Frame", {
                Name = "Watermark",
                Position = UDim2.new(0, 0, 0, 0),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(0, 400, 0, 20),
                BorderSizePixel = 0,
                ZIndex = 10000,
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Parent = Library.UI.ScreenGUI
            }, true)
            --
            NotificationFrameObject.BackgroundTransparency = 1
            --
            local UIGradient = Library:CreateObject("UIGradient", {
                Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.25, 0.6119999885559082),
                    NumberSequenceKeypoint.new(0.5, 0.625),
                    NumberSequenceKeypoint.new(0.75, 0.625),
                    NumberSequenceKeypoint.new(1, 1)
                },
                Parent = NotificationFrameObject
            }, true)
            --
            local UIStroke = Library:CreateObject("UIStroke", {
                Parent = NotificationFrameObject
            }, true)
            --
            UIStroke.Transparency = 1
            --
            local UIGradient_1 = Library:CreateObject("UIGradient", {
                Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.232, 0.4000000059604645),
                    NumberSequenceKeypoint.new(0.5, 0.4000000059604645),
                    NumberSequenceKeypoint.new(0.75, 0.4000000059604645),
                    NumberSequenceKeypoint.new(1, 1)
                },
                Parent = UIStroke
            }, true)
            --
            local NotificationText = Library:CreateObject("TextLabel", {
                FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                TextColor3 = Color3.fromRGB(208, 208, 208),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Text = Options.Message,
                Name = "Text",
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 10000,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                RichText = true,
                TextSize = 14,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = NotificationFrameObject
            }, true)
            --
            local Stroke = Library:CreateObject("UIStroke", {
                Parent = NotificationText,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Color = Color3.fromRGB(50, 50, 50),
            }, true)
            --
            Stroke.Transparency = 1
            --
            NotificationText.TextTransparency = 1
            --
            local UIPadding = Library:CreateObject("UIPadding", {
                PaddingRight = UDim.new(0, 22),
                PaddingLeft = UDim.new(0, 22),
                Parent = NotificationText
            }, true)
            --
            local NotificationFrame = {
                Class = "Notification",
                Object = NotificationFrameObject,
                Text = NotificationText,
            }
            --
            NotificationFrameObject.Position = Options.Position == "Top Left" and UDim2.new(0, -70, 0, 80 + (#Path * 24)) or UDim2.new(0, Viewport.X / 2 - (NotificationText.TextBounds.X + 4) / 2, 1, -150)
            --
            do -- Functions
                function Notification:UpdatePositions()
                    local TotalHeight = 80
                    local Padding = 6
                    --
                    for Index = #Path, 1, -1 do
                        local Value = Path[Index]
                        local NewPosition
                        --
                        if Options.Position == "Top Left" then
                            NewPosition = UDim2.new(0, 5, 0, TotalHeight)
                            TotalHeight = TotalHeight + Value.Object.AbsoluteSize.Y + Padding
                        else
                            NewPosition = UDim2.new(0, Viewport.X / 2 - (Value.Text.TextBounds.X + 4) / 2, 1, -150 - (Index * 24))
                        end
                        --
                        Library:TweenObject(Value.Object, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = NewPosition})
                    end
                end
                --
                function Notification:RemoveFrame()
                    Library:TweenObject(NotificationFrameObject, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
					Library:TweenObject(NotificationText, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 1})
					Library:TweenObject(UIStroke, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 1})
					Library:TweenObject(Stroke, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 1})
                    --
                    task.delay(0.25, function()
                        NotificationFrameObject:Destroy()

                        table.remove(Path, table.find(Path, NotificationFrame))

                        Notification:UpdatePositions()
                    end)
                end
                --
                function Notification:UpdateText(Text)
                    NotificationText.Text = Text
                    NotificationFrameObject.Size = UDim2.new(NotificationFrameObject.Size.X.Scale, NotificationText.TextBounds.X + 44, 0, NotificationText.TextBounds.Y + 4)
                end
                --
                function Notification:Update()
                    local TotalHeight = 50
                    local Padding = 6
                    --
					Library:TweenObject(NotificationFrameObject, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
					Library:TweenObject(NotificationText, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0})
					Library:TweenObject(UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0})
					Library:TweenObject(Stroke, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0})
                    NotificationFrameObject.Size = UDim2.new(NotificationFrameObject.Size.X.Scale, NotificationText.TextBounds.X + 44, 0, NotificationText.TextBounds.Y + 4)
                    --
                    for _, Value in Path do
                        TotalHeight = TotalHeight + Value.Object.AbsoluteSize.Y + Padding
                    end
                    --
                    local NewPosition = Options.Position == "Top Left" and UDim2.new(0, 5, 0, TotalHeight) or UDim2.new(0, Viewport.X / 2 - (NotificationText.TextBounds.X + 4) / 2, 1, -150)
                    --
                    Library:TweenObject(NotificationFrameObject, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = NewPosition}, function()
                        if Options.Delay ~= math.huge then
                            task.delay(Options.Delay, Notification.RemoveFrame)
                        end
                    end)
                end
            end
            --
            Notification:Update()
            --
            table.insert(Path, 1, NotificationFrame)
            --
            Notification:UpdatePositions()
            --
            return Notification
        end
        --
        function Library:Init()
            Library.UI.Initialized = true
            --
            Library:CreateWatermark()
            --
            Library:Connection(Camera:GetPropertyChangedSignal("ViewportSize"), function()
                Viewport = Camera.ViewportSize
                --
                Outline.Position = UDim2.fromOffset((Viewport.X / 2) - (Outline.Size.X.Offset / 2), (Viewport.Y / 2) - (Outline.Size.Y.Offset / 2))
            end)
        end
        --
        function Library:Unload()
            Camera.CameraSubject = Client.Character.Humanoid
            --
            for Index, Value in Library.Connections do
                Value:Disconnect()
            end
            --
            for _, Objects in Library.Objects do
                Objects[1]:Destroy()
            end
            --
            MainUI:Destroy()
        end
        --
        function Library:Disable()
            for Index, Value in Library.Flags do
                if Value.Set then
                    Value:Set(false)
                end
            end
        end
        --
        return setmetatable(Window, Library)
    end
end
--

--[[
  Cerus Premium | Linoria (GitHub live)
  - Toggle menu with RightShift
  - ESP v5 - esp-lib.lua external adapter
  - ESP Weapon Info Overlay (Bold)
  - Anti-Weapon (katana / shield block)
  - Silent FOV on Rivals gun model (muzzle / barrel / viewmodel)
  - Silent FOV: show/fill/gunpoint/target + full color controls
]]

local bit32 = bit32 or bit

local _frameCounter = 0
local function everyNFrames(n)
    _frameCounter = _frameCounter + 1
    return (_frameCounter % n) == 0
end

-- ============================================================================
-- Anti-Kick
-- ============================================================================
pcall(function()
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local CoreGui = game:GetService("CoreGui")
    local ScriptContext = game:GetService("ScriptContext")

    pcall(function()
        if LP and typeof(LP.Kick) == "function" then LP.Kick = function(...) end end
    end)

    pcall(function()
        if not hookmetamethod or not getnamecallmethod then return end
        local old
        old = hookmetamethod(game, "__namecall", newcclosure and newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" then return end
            return old(self, ...)
        end) or function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" then return end
            return old(self, ...)
        end)
    end)

    pcall(function()
        local function cloak(inst)
            if not inst then return end
            pcall(function() inst.Name = tostring(math.random(100000,999999)) end)
        end
        task.defer(function()
            task.wait(1)
            for _,n in ipairs({"CerusESP","CerusFOV","CerusIndicators","CustomCursorGui","Yokai.winCrosshair","CerusWeaponInfo"}) do
                local o = CoreGui:FindFirstChild(n)
                if o then cloak(o) end
                if LP and LP:FindFirstChild("PlayerGui") then
                    local o2 = LP.PlayerGui:FindFirstChild(n)
                    if o2 then cloak(o2) end
                end
            end
        end)
    end)

    pcall(function()
        if ScriptContext and ScriptContext.Error then ScriptContext.Error:Connect(function() end) end
    end)

    pcall(function()
        if setfflag then pcall(setfflag, "DebugRunServiceHumanoidCheck", "False") end
    end)

    pcall(function()
        local RunService = game:GetService("RunService")
        local last = 0
        RunService.Heartbeat:Connect(function()
            if tick() - last < 3 then return end
            last = tick()
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.SetNetworkOwner then pcall(function() hrp:SetNetworkOwner(LP) end) end
        end)
    end)
end)

-- ============================================================================
-- Config Manager
-- ============================================================================
nexlib = {accentclr = Color3.fromRGB(128, 213, 247), dropdownframes = {}, colorpickerframes = {}}

_cfgRegistry = {}
_G._nexlibCfg = {
    registry = _cfgRegistry,
    register = function(key, getter, setter) _cfgRegistry[key] = { get = getter, set = setter } end,
    collect = function()
        local out = {}
        for k, v in pairs(_cfgRegistry) do
            local ok, val = pcall(v.get)
            if ok then out[k] = val end
        end
        return out
    end,
    apply = function(data)
        for k, val in pairs(data) do
            local entry = _cfgRegistry[k]
            if entry then pcall(entry.set, val) end
        end
    end,
}

CONFIG_FOLDER = "CerusPremium_Configs"
CONFIG_DEFAULT_FILE = CONFIG_FOLDER .. "/_default.txt"
_isLoadingConfig = false
pcall(function() if makefolder then makefolder(CONFIG_FOLDER) end end)

-- ============================================================================
-- Draggable
-- ============================================================================
local function make_draggable(clickObject, dragObject)
    pcall(function()
        local dragging, inputChanged, startPos, startDragPos = false
        clickObject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
                dragging = true
                startPos = input.Position
                startDragPos = dragObject.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end 
                end)
            end 
        end)
        clickObject.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then inputChanged = input end 
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input == inputChanged and dragging then 
                local delta = input.Position - startPos
                dragObject.Position = UDim2.new(startDragPos.X.Scale, startDragPos.X.Offset + delta.X, startDragPos.Y.Scale, startDragPos.Y.Offset + delta.Y)
            end 
        end)
    end)
end

-- ============================================================================
-- UI Framework
-- ============================================================================
_guiMain = Instance.new("ScreenGui")
_guiMain.Name = "nexlib_disabled"
setthreadidentity = setthreadidentity or function() end
pcall(setthreadidentity, 8)
-- Yokai Sense is the only visible UI; keep nexlib tree unparented
_guiMain.Parent = nil
_guiMain.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

_guiCursor = Instance.new("ScreenGui")
_guiCursor.Name = "CustomCursorGui"
_guiCursor.ResetOnSpawn = false
_guiCursor.Parent = _guiMain

_cursorBox = Instance.new("Frame")
_cursorBox.Name = "CursorBox"
_cursorBox.Size = UDim2.new(0, 6, 0, 6)
_cursorBox.BackgroundColor3 = Color3.fromRGB(128, 213, 247)
_cursorBox.BorderSizePixel = 0
_cursorBox.Visible = false
_cursorBox.Parent = _guiCursor

_notifFolder = Instance.new("Folder")
_notifFolder.Name = "NotificationFolder"
_notifFolder.Parent = _guiMain

_notifList = {}
_notifHeight = 22
_notifGap = 6
_notifMax = 8
_notifDefaultDur = 3
_notifStartY = 40

local function refresh_notifications()
    local TweenService = game:GetService("TweenService")
    for i, n in ipairs(_notifList) do
        if n.bar and n.bar.Parent then
            local yPos = _notifStartY + (i - 1) * (_notifHeight + _notifGap)
            TweenService:Create(n.bar, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0, yPos)
            }):Play()
        end
    end
end

function nexlib:Notification(title, desc, duration)
    duration = duration or _notifDefaultDur
    local text = tostring(title or "")
    if desc and desc ~= "" then text = text .. "  -  " .. tostring(desc) end
    local TweenService = game:GetService("TweenService")

    while #_notifList >= _notifMax do
        local old = table.remove(_notifList)
        if old and old.bar and old.bar.Parent then
            TweenService:Create(old.label, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
            local bt = TweenService:Create(old.bar, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, _notifHeight), BackgroundTransparency = 1
            })
            bt:Play()
            bt.Completed:Connect(function()
                pcall(function() if old.bar then old.bar:Destroy() end end)
                refresh_notifications()
            end)
        end
    end

    local notifBar = Instance.new("Frame")
    notifBar.Name = "Notification"
    notifBar.Parent = _notifFolder
    notifBar.AnchorPoint = Vector2.new(0.5, 0)
    notifBar.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    notifBar.BorderSizePixel = 0
    notifBar.Position = UDim2.new(0.5, 0, 0, _notifStartY)
    notifBar.Size = UDim2.new(0, 0, 0, _notifHeight)
    notifBar.ClipsDescendants = true
    notifBar.BackgroundTransparency = 0.05
    notifBar.ZIndex = 100

    local stroke = Instance.new("UIStroke")
    stroke.Parent = notifBar
    stroke.Color = nexlib.accentclr
    stroke.Thickness = 1.5
    stroke.Transparency = 0.25

    local accentLine = Instance.new("Frame")
    accentLine.Parent = notifBar
    accentLine.BackgroundColor3 = nexlib.accentclr
    accentLine.BorderSizePixel = 0
    accentLine.Size = UDim2.new(0, 3, 1, 0)

    local label = Instance.new("TextLabel")
    label.Parent = notifBar
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(1, -28, 1, 0)
    label.Font = Enum.Font.Code
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextTransparency = 1

    local TextService = game:GetService("TextService")
    local textSize = TextService:GetTextSize(text, 13, Enum.Font.Code, Vector2.new(2000, _notifHeight))
    local notifWidth = math.clamp(textSize.X + 48, 200, 480)

    table.insert(_notifList, 1, { bar = notifBar, label = label, stroke = stroke })
    refresh_notifications()

    TweenService:Create(notifBar, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, notifWidth, 0, _notifHeight)
    }):Play()
    task.delay(0.08, function()
        TweenService:Create(label, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    end)
    task.delay(duration, function()
        for i, n in ipairs(_notifList) do if n.bar == notifBar then table.remove(_notifList, i) break end end
        if not notifBar or not notifBar.Parent then refresh_notifications() return end
        TweenService:Create(label, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
        local bt = TweenService:Create(notifBar, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, _notifHeight), BackgroundTransparency = 1
        })
        bt:Play()
        bt.Completed:Connect(function()
            pcall(function() notifBar:Destroy() end)
            refresh_notifications()
        end)
    end)
end

function nexlib:Window_DISABLED(windowTitle)
    local uiVisible = true
    local firstTab = false
    local allTabs = {}

    local mainFrame = Instance.new("Frame")
    local outline1 = Instance.new("ImageLabel")
    local outline2 = Instance.new("ImageLabel")
    local containerHolder = Instance.new("Frame")
    local tabHolder = Instance.new("ScrollingFrame")
    local tabLayout = Instance.new("UIListLayout")
    local tabPadding = Instance.new("UIPadding")
    local topBar = Instance.new("Frame")
    local topBarTitle = Instance.new("TextLabel")
    local topBarLine = Instance.new("Frame")

    mainFrame.Name = "MainFrame"
    mainFrame.Parent = _guiMain
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.Size = UDim2.new(0, 525, 0, 631)
    mainFrame.Visible = true
    mainFrame.ClipsDescendants = true

    outline1.Parent = mainFrame
    outline1.BackgroundTransparency = 1
    outline1.Position = UDim2.new(0, 1, 0, 1)
    outline1.Size = UDim2.new(1, -2, 1, -2)
    outline1.Image = "rbxassetid://2592362371"
    outline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
    outline1.ScaleType = Enum.ScaleType.Slice
    outline1.SliceCenter = Rect.new(2, 2, 62, 62)

    outline2.Parent = mainFrame
    outline2.BackgroundTransparency = 1
    outline2.Size = UDim2.new(1, 0, 1, 0)
    outline2.Image = "rbxassetid://2592362371"
    outline2.ImageColor3 = Color3.fromRGB(0, 0, 0)
    outline2.ScaleType = Enum.ScaleType.Slice
    outline2.SliceCenter = Rect.new(2, 2, 62, 62)

    containerHolder.Parent = mainFrame
    containerHolder.AnchorPoint = Vector2.new(0.5, 0)
    containerHolder.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    containerHolder.Position = UDim2.new(0.5, 0, 0.071, 10)
    containerHolder.Size = UDim2.new(1, -18, 1, -42)
    containerHolder.BackgroundTransparency = 1
    containerHolder.ClipsDescendants = true

    tabHolder.Parent = containerHolder
    tabHolder.BackgroundTransparency = 1
    tabHolder.Size = UDim2.new(1, 0, 0, 32)
    tabHolder.CanvasSize = UDim2.new(0, 700, 0, 0)
    tabHolder.ScrollBarThickness = 0

    tabLayout.Parent = tabHolder
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 4)
    tabPadding.Parent = tabHolder
    tabPadding.PaddingLeft = UDim.new(0, 5)

    topBar.Parent = mainFrame
    topBar.AnchorPoint = Vector2.new(0.5, 0)
    topBar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    topBar.BorderSizePixel = 0
    topBar.Position = UDim2.new(0.5, 0, 0, 2)
    topBar.Size = UDim2.new(1, -5, 0, 28)

    topBarTitle.Parent = topBar
    topBarTitle.BackgroundTransparency = 1
    topBarTitle.Position = UDim2.new(0, 7, 0, 5)
    topBarTitle.Size = UDim2.new(0, 0, 0, 16)
    topBarTitle.Font = Enum.Font.Code
    topBarTitle.Text = windowTitle
    topBarTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
    topBarTitle.TextSize = 16
    topBarTitle.TextXAlignment = Enum.TextXAlignment.Left

    topBarLine.Parent = topBar
    topBarLine.BackgroundColor3 = nexlib.accentclr
    topBarLine.BorderSizePixel = 0
    topBarLine.Position = UDim2.new(0, 0, 0, 27)
    topBarLine.Size = UDim2.new(1, 0, 0, 1)

    make_draggable(topBar, mainFrame)

    local lighting = game:GetService("Lighting")
    local uiBlur = lighting:FindFirstChild("ValkUIBlur") or Instance.new("BlurEffect")
    uiBlur.Name = "ValkUIBlur"
    uiBlur.Size = 0
    uiBlur.Parent = lighting

    local function toggleUI()
        mainFrame.Visible = uiVisible
        _cursorBox.Visible = uiVisible
        game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default
        local TweenService = game:GetService("TweenService")
        if uiVisible then
            TweenService:Create(uiBlur, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 18}):Play()
            mainFrame.BackgroundTransparency = 1
            TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.15}):Play()
        else
            TweenService:Create(uiBlur, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0}):Play()
        end
    end

    game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        if input.KeyCode == Enum.KeyCode.RightShift then
            uiVisible = not uiVisible
            toggleUI()
        end
    end)

    coroutine.wrap(function()
        while task.wait() do
            topBarLine.BackgroundColor3 = nexlib.accentclr
            _cursorBox.BackgroundColor3 = nexlib.accentclr
            if uiVisible then
                local mouse = game:GetService("UserInputService"):GetMouseLocation()
                _cursorBox.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
            end
        end
    end)()

    local api = {}

    function api:Tab(tabName)
        local baseZ = 50

        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabName .. "_TabBtn"
        tabBtn.Parent = tabHolder
        tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        tabBtn.BorderSizePixel = 0
        tabBtn.Font = Enum.Font.Code
        tabBtn.Text = tabName
        tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        tabBtn.TextSize = 14
        tabBtn.AutoButtonColor = false

        local TextService = game:GetService("TextService")
        local tabTextSize = TextService:GetTextSize(tabName, 14, Enum.Font.Code, Vector2.new(500, 500))
        tabBtn.Size = UDim2.new(0, tabTextSize.X + 28, 0, 26)

        local tabTopLine = Instance.new("Frame")
        tabTopLine.Parent = tabBtn
        tabTopLine.BackgroundColor3 = nexlib.accentclr
        tabTopLine.BorderSizePixel = 0
        tabTopLine.Size = UDim2.new(1, 0, 0, 2)
        tabTopLine.Visible = false

        local tabOutline = Instance.new("ImageLabel")
        tabOutline.Parent = tabBtn
        tabOutline.BackgroundTransparency = 1
        tabOutline.Size = UDim2.new(1, 0, 1, 0)
        tabOutline.Image = "rbxassetid://2592362371"
        tabOutline.ImageColor3 = Color3.fromRGB(45, 45, 45)
        tabOutline.ScaleType = Enum.ScaleType.Slice
        tabOutline.SliceCenter = Rect.new(2, 2, 62, 62)

        local holder1 = Instance.new("ScrollingFrame")
        local holder1Pad = Instance.new("UIPadding")
        local holder1Layout = Instance.new("UIListLayout")
        local holder2 = Instance.new("ScrollingFrame")
        local holder2Pad = Instance.new("UIPadding")
        local holder2Layout = Instance.new("UIListLayout")

        holder1.Name = tabName .. "_Holder1"
        holder1.Parent = containerHolder
        holder1.Active = true
        holder1.BackgroundTransparency = 1
        holder1.BorderSizePixel = 0
        holder1.Position = UDim2.new(0, 1, 0, 35)
        holder1.Size = UDim2.new(0, 245, 1, -40)
        holder1.Visible = false
        holder1.CanvasSize = UDim2.new(0, 0, 0, 0)
        holder1.ScrollBarThickness = 4
        holder1Pad.Parent = holder1
        holder1Pad.PaddingTop = UDim.new(0, 5)
        holder1Layout.Parent = holder1
        holder1Layout.SortOrder = Enum.SortOrder.LayoutOrder
        holder1Layout.Padding = UDim.new(0, 10)

        holder2.Name = tabName .. "_Holder2"
        holder2.Parent = containerHolder
        holder2.Active = true
        holder2.BackgroundTransparency = 1
        holder2.BorderSizePixel = 0
        holder2.Position = UDim2.new(0, 255, 0, 35)
        holder2.Size = UDim2.new(0, 245, 1, -40)
        holder2.Visible = false
        holder2.CanvasSize = UDim2.new(0, 0, 0, 0)
        holder2.ScrollBarThickness = 4
        holder2Pad.Parent = holder2
        holder2Pad.PaddingTop = UDim.new(0, 5)
        holder2Layout.Parent = holder2
        holder2Layout.SortOrder = Enum.SortOrder.LayoutOrder
        holder2Layout.Padding = UDim.new(0, 10)

        table.insert(allTabs, {btn = tabBtn, topLine = tabTopLine, outline = tabOutline, h1 = holder1, h2 = holder2})

        if firstTab == false then
            firstTab = true
            holder1.Visible = true
            holder2.Visible = true
            tabBtn.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
            tabBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
            tabTopLine.Visible = true
            tabOutline.ImageColor3 = Color3.fromRGB(65, 65, 65)
        end

        tabBtn.MouseButton1Click:Connect(function()
            local TweenService = game:GetService("TweenService")
            for _, t in ipairs(allTabs) do
                if t.btn == tabBtn then
                    TweenService:Create(t.btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(33, 33, 33), TextColor3 = Color3.fromRGB(230, 230, 230)}):Play()
                    t.topLine.Visible = true
                    t.outline.ImageColor3 = Color3.fromRGB(65, 65, 65)
                    t.h1.Visible = true
                    t.h2.Visible = true
                else
                    TweenService:Create(t.btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(22, 22, 22), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                    t.topLine.Visible = false
                    t.outline.ImageColor3 = Color3.fromRGB(45, 45, 45)
                    t.h1.Visible = false
                    t.h2.Visible = false
                end
            end
        end)

        coroutine.wrap(function()
            while task.wait() do
                if tabTopLine.Visible then tabTopLine.BackgroundColor3 = nexlib.accentclr end
            end
        end)()

        local tabApi = {}

        function tabApi:Section(sectionName, forceSide)
            baseZ = baseZ - 1
            local parentHolder
            if forceSide == 1 then parentHolder = holder1
            elseif forceSide == 2 then parentHolder = holder2
            else
                local c1, c2 = 0, 0
                for _, f in next, holder1:GetChildren() do if f.Name == "Section" or f.Name == "MultiSection" then c1 = c1 + 1 end end
                for _, f in next, holder2:GetChildren() do if f.Name == "Section" or f.Name == "MultiSection" then c2 = c2 + 1 end end
                if c1 == 0 and c2 == 0 then parentHolder = holder1
                elseif c1 == c2 then parentHolder = holder1
                else parentHolder = holder2 end
            end

            local section = Instance.new("Frame")
            local secOutline2 = Instance.new("ImageLabel")
            local secOutline1 = Instance.new("ImageLabel")
            local secTitleFrame = Instance.new("Frame")
            local secTitle = Instance.new("TextLabel")
            local secItemHolder = Instance.new("Frame")
            local secLayout = Instance.new("UIListLayout")

            section.Name = "Section"
            section.Parent = parentHolder
            section.AnchorPoint = Vector2.new(0.5, 0)
            section.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            section.BorderSizePixel = 0
            section.Size = UDim2.new(1, -2, 0, 24)
            section.ZIndex = baseZ

            secOutline2.Parent = section
            secOutline2.BackgroundTransparency = 1
            secOutline2.Size = UDim2.new(1, 0, 1, 0)
            secOutline2.Image = "rbxassetid://2592362371"
            secOutline2.ImageColor3 = Color3.fromRGB(0, 0, 0)
            secOutline2.ScaleType = Enum.ScaleType.Slice
            secOutline2.SliceCenter = Rect.new(2, 2, 62, 62)

            secOutline1.Parent = section
            secOutline1.BackgroundTransparency = 1
            secOutline1.Position = UDim2.new(0, 1, 0, 1)
            secOutline1.Size = UDim2.new(1, -2, 1, -2)
            secOutline1.Image = "rbxassetid://2592362371"
            secOutline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
            secOutline1.ScaleType = Enum.ScaleType.Slice
            secOutline1.SliceCenter = Rect.new(2, 2, 62, 62)

            secTitleFrame.Parent = section
            secTitleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            secTitleFrame.BorderSizePixel = 0
            secTitleFrame.Position = UDim2.new(0, 10, 0, 0)

            secTitle.Parent = secTitleFrame
            secTitle.BackgroundTransparency = 1
            secTitle.Position = UDim2.new(0, 0, 0, -3)
            secTitle.Size = UDim2.new(1, 0, 0, 7)
            secTitle.Font = Enum.Font.Code
            secTitle.Text = sectionName
            secTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
            secTitle.TextSize = 14

            secItemHolder.Parent = section
            secItemHolder.AnchorPoint = Vector2.new(0.5, 0)
            secItemHolder.BackgroundTransparency = 1
            secItemHolder.Position = UDim2.new(0.5, 0, 0, 15)
            secItemHolder.Size = UDim2.new(1, -16, 0, 0)

            secLayout.Parent = secItemHolder
            secLayout.SortOrder = Enum.SortOrder.LayoutOrder
            secLayout.Padding = UDim.new(0, 5)
            secTitleFrame.Size = UDim2.new(0, secTitle.TextBounds.X + 6, 0, 7)

            local function refreshSize()
                section.Size = UDim2.new(1, -2, 0, secLayout.AbsoluteContentSize.Y + 24)
                holder1.CanvasSize = UDim2.new(0, 0, 0, holder1Layout.AbsoluteContentSize.Y + 20)
                holder2.CanvasSize = UDim2.new(0, 0, 0, holder2Layout.AbsoluteContentSize.Y + 20)
            end

            local sectionApi = {}

            function sectionApi:Toggle(text, default, callback)
                local btn = Instance.new("TextButton")
                local out1 = Instance.new("ImageLabel")
                local out2 = Instance.new("ImageLabel")
                local box = Instance.new("Frame")
                local check = Instance.new("Frame")
                local lbl = Instance.new("TextLabel")

                btn.Parent = secItemHolder
                btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                btn.BorderSizePixel = 0
                btn.Size = UDim2.new(1, 0, 0, 22)
                btn.AutoButtonColor = false
                btn.Text = ""

                out1.Parent = btn
                out1.BackgroundTransparency = 1
                out1.Size = UDim2.new(1, 0, 1, 0)
                out1.Image = "rbxassetid://2592362371"
                out1.ImageColor3 = Color3.fromRGB(60, 60, 60)
                out1.ScaleType = Enum.ScaleType.Slice
                out1.SliceCenter = Rect.new(2, 2, 62, 62)

                out2.Parent = btn
                out2.BackgroundTransparency = 1
                out2.Position = UDim2.new(0, 1, 0, 1)
                out2.Size = UDim2.new(1, -2, 1, -2)
                out2.Image = "rbxassetid://2592362371"
                out2.ImageColor3 = Color3.fromRGB(0, 0, 0)
                out2.ScaleType = Enum.ScaleType.Slice
                out2.SliceCenter = Rect.new(2, 2, 62, 62)

                box.Parent = btn
                box.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                box.BorderSizePixel = 0
                box.Position = UDim2.new(0, 6, 0.5, -6)
                box.Size = UDim2.new(0, 12, 0, 12)

                check.Parent = box
                check.BackgroundColor3 = nexlib.accentclr
                check.BorderSizePixel = 0
                check.Position = UDim2.new(0, 2, 0, 2)
                check.Size = UDim2.new(0, 8, 0, 8)
                check.Visible = default or false

                lbl.Parent = btn
                lbl.BackgroundTransparency = 1
                lbl.Position = UDim2.new(0, 25, 0, 0)
                lbl.Size = UDim2.new(1, -25, 1, 0)
                lbl.Font = Enum.Font.Code
                lbl.Text = text
                lbl.TextColor3 = Color3.fromRGB(190, 190, 190)
                lbl.TextSize = 14
                lbl.TextXAlignment = Enum.TextXAlignment.Left

                local state = default or false
                btn.MouseButton1Click:Connect(function()
                    state = not state
                    check.Visible = state
                    pcall(callback, state)
                end)

                refreshSize()
                coroutine.wrap(function()
                    while task.wait() do check.BackgroundColor3 = nexlib.accentclr end
                end)()

                local obj = {}
                function obj:Set(v)
                    state = v
                    check.Visible = state
                    pcall(callback, state)
                end

                pcall(function()
                    _G._nexlibCfg.register(sectionName .. "/" .. text,
                        function() return state end,
                        function(v) obj:Set(v) end)
                end)

                return obj
            end

            function sectionApi:Button(text, callback)
                local btn = Instance.new("TextButton")
                local out1 = Instance.new("ImageLabel")
                local out2 = Instance.new("ImageLabel")

                btn.Parent = secItemHolder
                btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                btn.BorderColor3 = nexlib.accentclr
                btn.BorderSizePixel = 0
                btn.Size = UDim2.new(1, 0, 0, 20)
                btn.AutoButtonColor = false
                btn.Font = Enum.Font.Code
                btn.TextColor3 = Color3.fromRGB(230, 230, 230)
                btn.TextSize = 14
                btn.Text = text

                out1.Parent = btn
                out1.BackgroundTransparency = 1
                out1.Size = UDim2.new(1, 0, 1, 0)
                out1.Image = "rbxassetid://2592362371"
                out1.ImageColor3 = Color3.fromRGB(60, 60, 60)
                out1.ScaleType = Enum.ScaleType.Slice
                out1.SliceCenter = Rect.new(2, 2, 62, 62)

                out2.Parent = btn
                out2.BackgroundTransparency = 1
                out2.Position = UDim2.new(0, 1, 0, 1)
                out2.Size = UDim2.new(1, -2, 1, -2)
                out2.Image = "rbxassetid://2592362371"
                out2.ImageColor3 = Color3.fromRGB(0, 0, 0)
                out2.ScaleType = Enum.ScaleType.Slice
                out2.SliceCenter = Rect.new(2, 2, 62, 62)

                btn.MouseButton1Click:Connect(function() pcall(callback) end)
                btn.MouseEnter:Connect(function() btn.BorderSizePixel = 1 end)
                btn.MouseLeave:Connect(function() btn.BorderSizePixel = 0 end)

                refreshSize()
                coroutine.wrap(function()
                    while task.wait() do btn.BorderColor3 = nexlib.accentclr end
                end)()
            end

            function sectionApi:Slider(text, min, max, default, rounding, callback)
                local btn = Instance.new("TextButton")
                local fill = Instance.new("Frame")
                local title = Instance.new("TextLabel")
                local valueLbl = Instance.new("TextLabel")

                btn.Parent = secItemHolder
                btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                btn.BorderSizePixel = 0
                btn.Size = UDim2.new(1, 0, 0, 16)
                btn.Text = ""
                btn.AutoButtonColor = false

                local out1 = Instance.new("ImageLabel")
                out1.Parent = btn
                out1.BackgroundTransparency = 1
                out1.Size = UDim2.new(1, 0, 1, 0)
                out1.Image = "rbxassetid://2592362371"
                out1.ImageColor3 = Color3.fromRGB(60, 60, 60)
                out1.ScaleType = Enum.ScaleType.Slice
                out1.SliceCenter = Rect.new(2, 2, 62, 62)

                local out2 = Instance.new("ImageLabel")
                out2.Parent = btn
                out2.BackgroundTransparency = 1
                out2.Position = UDim2.new(0, 1, 0, 1)
                out2.Size = UDim2.new(1, -2, 1, -2)
                out2.Image = "rbxassetid://2592362371"
                out2.ImageColor3 = Color3.fromRGB(0, 0, 0)
                out2.ScaleType = Enum.ScaleType.Slice
                out2.SliceCenter = Rect.new(2, 2, 62, 62)

                fill.Parent = btn
                fill.BackgroundColor3 = nexlib.accentclr
                fill.BorderSizePixel = 0
                fill.BackgroundTransparency = 0.55
                fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)

                title.Parent = btn
                title.BackgroundTransparency = 1
                title.Position = UDim2.new(0, 6, 0, 0)
                title.Size = UDim2.new(0.7, 0, 1, 0)
                title.Font = Enum.Font.Code
                title.Text = text
                title.TextColor3 = Color3.fromRGB(190, 190, 190)
                title.TextSize = 13
                title.TextXAlignment = Enum.TextXAlignment.Left
                title.ZIndex = 2

                valueLbl.Parent = btn
                valueLbl.BackgroundTransparency = 1
                valueLbl.Position = UDim2.new(1, -75, 0, 0)
                valueLbl.Size = UDim2.new(0, 70, 1, 0)
                valueLbl.Font = Enum.Font.Code
                valueLbl.Text = tostring(default) .. "s"
                valueLbl.TextColor3 = Color3.fromRGB(240, 240, 240)
                valueLbl.TextSize = 13
                valueLbl.TextXAlignment = Enum.TextXAlignment.Right
                valueLbl.ZIndex = 5

                local dragging = false
                local function update(input)
                    local pct = math.clamp((input.Position.X - btn.AbsolutePosition.X) / btn.AbsoluteSize.X, 0, 1)
                    local val = min + (max - min) * pct
                    if rounding == 0 then val = math.floor(val + 0.5)
                    else val = tonumber(string.format("%." .. rounding .. "f", val)) end
                    fill.Size = UDim2.new(pct, 0, 1, 0)
                    valueLbl.Text = tostring(val) .. "s"
                    pcall(callback, val)
                end

                btn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        update(input)
                    end
                end)
                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
                end)
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        update(input)
                    end
                end)

                refreshSize()
                coroutine.wrap(function()
                    while task.wait() do fill.BackgroundColor3 = nexlib.accentclr end
                end)()

                pcall(function()
                    local function applyVal(v)
                        v = math.clamp(tonumber(v) or min, min, max)
                        if rounding == 0 then v = math.floor(v + 0.5) else v = tonumber(string.format("%." .. rounding .. "f", v)) end
                        local pct = (v - min) / (max - min)
                        fill.Size = UDim2.new(pct, 0, 1, 0)
                        valueLbl.Text = tostring(v) .. "s"
                        pcall(callback, v)
                    end
                    _G._nexlibCfg.register(sectionName .. "/" .. text,
                        function()
                            local s = valueLbl.Text:gsub("s$", "")
                            return tonumber(s)
                        end,
                        applyVal)
                end)
            end

            function sectionApi:Input(text, default, placeholder, callback)
                local frame = Instance.new("Frame")
                local title = Instance.new("TextLabel")
                local box = Instance.new("TextBox")

                frame.Parent = secItemHolder
                frame.BackgroundTransparency = 1
                frame.Size = UDim2.new(1, 0, 0, 38)

                title.Parent = frame
                title.BackgroundTransparency = 1
                title.Size = UDim2.new(1, 0, 0, 15)
                title.Font = Enum.Font.Code
                title.Text = text
                title.TextColor3 = Color3.fromRGB(190, 190, 190)
                title.TextSize = 14
                title.TextXAlignment = Enum.TextXAlignment.Left

                box.Parent = frame
                box.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                box.BorderSizePixel = 0
                box.Position = UDim2.new(0, 0, 0, 18)
                box.Size = UDim2.new(1, 0, 0, 20)
                box.Font = Enum.Font.Code
                box.PlaceholderText = placeholder or ""
                box.Text = default or ""
                box.TextColor3 = Color3.fromRGB(230, 230, 230)
                box.TextSize = 14
                box.TextXAlignment = Enum.TextXAlignment.Left

                box.FocusLost:Connect(function()
                    pcall(callback, box.Text)
                end)

                refreshSize()
            end

            function sectionApi:Dropdown(text, list, default, callback, skipRegister)
                if default == '' then default = nil end

                local frame = Instance.new("Frame")
                local title = Instance.new("TextLabel")
                local btn = Instance.new("TextButton")
                local out1 = Instance.new("ImageLabel")
                local out2 = Instance.new("ImageLabel")
                local btnText = Instance.new("TextLabel")
                local arrow = Instance.new("ImageLabel")

                frame.Parent = secItemHolder
                frame.BackgroundTransparency = 1
                frame.Size = UDim2.new(1, 0, 0, 37)

                title.Parent = frame
                title.BackgroundTransparency = 1
                title.Size = UDim2.new(0, 0, 0, 13)
                title.Font = Enum.Font.Code
                title.Text = text
                title.TextColor3 = Color3.fromRGB(230, 230, 230)
                title.TextSize = 14
                title.TextXAlignment = Enum.TextXAlignment.Left

                btn.Parent = frame
                btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                btn.BorderSizePixel = 0
                btn.Position = UDim2.new(0, 0, 1, -20)
                btn.Size = UDim2.new(1, 0, 0, 20)
                btn.Text = ""
                btn.AutoButtonColor = false

                out1.Parent = btn
                out1.BackgroundTransparency = 1
                out1.Size = UDim2.new(1, 0, 1, 0)
                out1.Image = "rbxassetid://2592362371"
                out1.ImageColor3 = Color3.fromRGB(60, 60, 60)
                out1.ScaleType = Enum.ScaleType.Slice
                out1.SliceCenter = Rect.new(2, 2, 62, 62)

                out2.Parent = btn
                out2.BackgroundTransparency = 1
                out2.Position = UDim2.new(0, 1, 0, 1)
                out2.Size = UDim2.new(1, -2, 1, -2)
                out2.Image = "rbxassetid://2592362371"
                out2.ImageColor3 = Color3.fromRGB(0, 0, 0)
                out2.ScaleType = Enum.ScaleType.Slice
                out2.SliceCenter = Rect.new(2, 2, 62, 62)

                btnText.Parent = btn
                btnText.BackgroundTransparency = 1
                btnText.Position = UDim2.new(0, 5, 0, 0)
                btnText.Size = UDim2.new(1, -5, 1, 0)
                btnText.Font = Enum.Font.Code
                btnText.Text = typeof(default) == "string" and default or "..."
                btnText.TextColor3 = Color3.fromRGB(180, 180, 180)
                btnText.TextSize = 14
                btnText.TextXAlignment = Enum.TextXAlignment.Left

                arrow.Parent = btn
                arrow.AnchorPoint = Vector2.new(0, 0.5)
                arrow.BackgroundTransparency = 1
                arrow.Position = UDim2.new(1, -22, 0.5, 0)
                arrow.Size = UDim2.new(0, 20, 0, 20)
                arrow.Image = "http://www.roblox.com/asset/?id=6031091004"
                arrow.ImageColor3 = Color3.fromRGB(180, 180, 180)

                refreshSize()

                local holderFrame = Instance.new("Frame")
                local holderOut1 = Instance.new("ImageLabel")
                local holderOut2 = Instance.new("ImageLabel")
                local scrollFrame = Instance.new("ScrollingFrame")
                local listLayout = Instance.new("UIListLayout")
                local listPad = Instance.new("UIPadding")

                holderFrame.Parent = section
                holderFrame.AnchorPoint = Vector2.new(0.5, 0)
                holderFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                holderFrame.BorderSizePixel = 0
                holderFrame.Position = UDim2.new(0.5, 0, 0, secLayout.AbsoluteContentSize.Y + 19)
                holderFrame.Size = UDim2.new(1, -16, 0, 0)
                holderFrame.Visible = false
                holderFrame.ZIndex = 10

                holderOut1.Parent = holderFrame
                holderOut1.BackgroundTransparency = 1
                holderOut1.Size = UDim2.new(1, 0, 1, 0)
                holderOut1.Image = "rbxassetid://2592362371"
                holderOut1.ImageColor3 = Color3.fromRGB(60, 60, 60)
                holderOut1.ScaleType = Enum.ScaleType.Slice
                holderOut1.SliceCenter = Rect.new(2, 2, 62, 62)

                holderOut2.Parent = holderFrame
                holderOut2.BackgroundTransparency = 1
                holderOut2.Position = UDim2.new(0, 1, 0, 1)
                holderOut2.Size = UDim2.new(1, -2, 1, -2)
                holderOut2.Image = "rbxassetid://2592362371"
                holderOut2.ImageColor3 = Color3.fromRGB(0, 0, 0)
                holderOut2.ScaleType = Enum.ScaleType.Slice
                holderOut2.SliceCenter = Rect.new(2, 2, 62, 62)

                scrollFrame.Parent = holderFrame
                scrollFrame.Active = true
                scrollFrame.BackgroundTransparency = 1
                scrollFrame.BorderSizePixel = 0
                scrollFrame.Size = UDim2.new(1, -4, 1, 0)
                scrollFrame.ScrollBarThickness = 2
                scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

                listLayout.Parent = scrollFrame
                listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                listLayout.Padding = UDim.new(0, 2)
                listPad.Parent = scrollFrame
                listPad.PaddingTop = UDim.new(0, 6)

                table.insert(nexlib.dropdownframes, holderFrame)
                table.insert(nexlib.dropdownframes, frame)

                local apiObj = {}

                btn.MouseButton1Click:Connect(function()
                    if holderFrame.Visible == false then
                        for _, f in next, nexlib.dropdownframes do
                            if f.Name == "DropdownHolderFrame" then f.Visible = false end
                        end
                        for _, f in next, nexlib.dropdownframes do
                            if f.Name == "Dropdown" then f.DropdownFrame.DropdownArrow.Rotation = 0 end
                        end
                        arrow.Rotation = 180
                        holderFrame.Visible = true
                    else
                        arrow.Rotation = 0
                        holderFrame.Visible = false
                    end
                end)

                local function buildItems()
                    for _, ch in ipairs(scrollFrame:GetChildren()) do
                        if ch:IsA("TextButton") and ch.Name == "Item" then ch:Destroy() end
                    end
                    for _, f in next, list do
                        local itemBtn = Instance.new("TextButton")
                        local itemTxt = Instance.new("TextLabel")

                        itemBtn.Name = "Item"
                        itemBtn.Parent = scrollFrame
                        itemBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                        itemBtn.Size = UDim2.new(1, -12, 0, 20)
                        itemBtn.AutoButtonColor = false
                        itemBtn.Font = Enum.Font.Code
                        itemBtn.Text = " " .. f
                        itemBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
                        itemBtn.TextSize = 14
                        itemBtn.TextXAlignment = Enum.TextXAlignment.Left

                        itemTxt.Parent = itemBtn
                        itemTxt.BackgroundTransparency = 1
                        itemTxt.Position = UDim2.new(0, 7, 0, 0)
                        itemTxt.Size = UDim2.new(1, -7, 1, 0)
                        itemTxt.Font = Enum.Font.Code
                        itemTxt.Text = f
                        itemTxt.TextColor3 = nexlib.accentclr
                        itemTxt.TextSize = 14
                        itemTxt.TextXAlignment = Enum.TextXAlignment.Left

                        itemBtn.MouseButton1Click:Connect(function()
                            holderFrame.Visible = false
                            btnText.Text = f
                            default = f
                            pcall(callback, f)
                        end)

                        coroutine.wrap(function()
                            while task.wait() do
                                local selected = (typeof(default) == "string" and default == f)
                                itemTxt.BackgroundTransparency = 1
                                itemTxt.TextTransparency = selected and 0 or 1
                                itemBtn.TextTransparency = selected and 1 or 0
                                itemBtn.BackgroundTransparency = selected and 0 or 1
                                itemBtn.BorderColor3 = nexlib.accentclr
                            end
                        end)()
                    end
                    holderFrame.Size = UDim2.new(1, -16, 0, math.clamp(listLayout.AbsoluteContentSize.Y + 12, 0, 150))
                    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
                end

                buildItems()

                coroutine.wrap(function()
                    while task.wait() do btn.BorderColor3 = nexlib.accentclr end
                end)()

                function apiObj:Set(value)
                    btnText.Text = tostring(value)
                    default = value
                    pcall(callback, value)
                end

                function apiObj:SetItems(newList)
                    list = newList
                    buildItems()
                end

                if not skipRegister then
                    pcall(function()
                        _G._nexlibCfg.register(sectionName .. "/" .. text,
                            function() return default end,
                            function(v)
                                default = v
                                btnText.Text = tostring(v)
                                pcall(callback, v)
                            end)
                    end)
                end

                return apiObj
            end

            function sectionApi:MultiDropdown(text, list, default, callback, skipRegister)
                if type(default) ~= "table" then default = {} end
                local selected = {}
                for _, v in ipairs(default) do selected[v] = true end

                local frame = Instance.new("Frame")
                local title = Instance.new("TextLabel")
                local btn = Instance.new("TextButton")
                local out1 = Instance.new("ImageLabel")
                local out2 = Instance.new("ImageLabel")
                local btnText = Instance.new("TextLabel")
                local arrow = Instance.new("ImageLabel")

                frame.Parent = secItemHolder
                frame.BackgroundTransparency = 1
                frame.Size = UDim2.new(1, 0, 0, 37)

                title.Parent = frame
                title.BackgroundTransparency = 1
                title.Size = UDim2.new(0, 0, 0, 13)
                title.Font = Enum.Font.Code
                title.Text = text
                title.TextColor3 = Color3.fromRGB(230, 230, 230)
                title.TextSize = 14
                title.TextXAlignment = Enum.TextXAlignment.Left

                btn.Parent = frame
                btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                btn.BorderSizePixel = 0
                btn.Position = UDim2.new(0, 0, 1, -20)
                btn.Size = UDim2.new(1, 0, 0, 20)
                btn.Text = ""
                btn.AutoButtonColor = false

                out1.Parent = btn
                out1.BackgroundTransparency = 1
                out1.Size = UDim2.new(1, 0, 1, 0)
                out1.Image = "rbxassetid://2592362371"
                out1.ImageColor3 = Color3.fromRGB(60, 60, 60)
                out1.ScaleType = Enum.ScaleType.Slice
                out1.SliceCenter = Rect.new(2, 2, 62, 62)

                out2.Parent = btn
                out2.BackgroundTransparency = 1
                out2.Position = UDim2.new(0, 1, 0, 1)
                out2.Size = UDim2.new(1, -2, 1, -2)
                out2.Image = "rbxassetid://2592362371"
                out2.ImageColor3 = Color3.fromRGB(0, 0, 0)
                out2.ScaleType = Enum.ScaleType.Slice
                out2.SliceCenter = Rect.new(2, 2, 62, 62)

                btnText.Parent = btn
                btnText.BackgroundTransparency = 1
                btnText.Position = UDim2.new(0, 5, 0, 0)
                btnText.Size = UDim2.new(1, -5, 1, 0)
                btnText.Font = Enum.Font.Code
                btnText.Text = "..."
                btnText.TextColor3 = Color3.fromRGB(180, 180, 180)
                btnText.TextSize = 14
                btnText.TextXAlignment = Enum.TextXAlignment.Left

                arrow.Parent = btn
                arrow.AnchorPoint = Vector2.new(0, 0.5)
                arrow.BackgroundTransparency = 1
                arrow.Position = UDim2.new(1, -22, 0.5, 0)
                arrow.Size = UDim2.new(0, 20, 0, 20)
                arrow.Image = "http://www.roblox.com/asset/?id=6031091004"
                arrow.ImageColor3 = Color3.fromRGB(180, 180, 180)

                refreshSize()

                local holderFrame = Instance.new("Frame")
                local holderOut1 = Instance.new("ImageLabel")
                local holderOut2 = Instance.new("ImageLabel")
                local scrollFrame = Instance.new("ScrollingFrame")
                local listLayout = Instance.new("UIListLayout")
                local listPad = Instance.new("UIPadding")

                holderFrame.Parent = section
                holderFrame.AnchorPoint = Vector2.new(0.5, 0)
                holderFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                holderFrame.BorderSizePixel = 0
                holderFrame.Position = UDim2.new(0.5, 0, 0, secLayout.AbsoluteContentSize.Y + 19)
                holderFrame.Size = UDim2.new(1, -16, 0, 0)
                holderFrame.Visible = false
                holderFrame.ZIndex = 10

                holderOut1.Parent = holderFrame
                holderOut1.BackgroundTransparency = 1
                holderOut1.Size = UDim2.new(1, 0, 1, 0)
                holderOut1.Image = "rbxassetid://2592362371"
                holderOut1.ImageColor3 = Color3.fromRGB(60, 60, 60)
                holderOut1.ScaleType = Enum.ScaleType.Slice
                holderOut1.SliceCenter = Rect.new(2, 2, 62, 62)

                holderOut2.Parent = holderFrame
                holderOut2.BackgroundTransparency = 1
                holderOut2.Position = UDim2.new(0, 1, 0, 1)
                holderOut2.Size = UDim2.new(1, -2, 1, -2)
                holderOut2.Image = "rbxassetid://2592362371"
                holderOut2.ImageColor3 = Color3.fromRGB(0, 0, 0)
                holderOut2.ScaleType = Enum.ScaleType.Slice
                holderOut2.SliceCenter = Rect.new(2, 2, 62, 62)

                scrollFrame.Parent = holderFrame
                scrollFrame.Active = true
                scrollFrame.BackgroundTransparency = 1
                scrollFrame.BorderSizePixel = 0
                scrollFrame.Size = UDim2.new(1, -4, 1, 0)
                scrollFrame.ScrollBarThickness = 2
                scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

                listLayout.Parent = scrollFrame
                listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                listLayout.Padding = UDim.new(0, 2)
                listPad.Parent = scrollFrame
                listPad.PaddingTop = UDim.new(0, 6)

                table.insert(nexlib.dropdownframes, holderFrame)
                table.insert(nexlib.dropdownframes, frame)

                local apiObj = {}
                local checks = {}

                btn.MouseButton1Click:Connect(function()
                    if holderFrame.Visible == false then
                        for _, f in next, nexlib.dropdownframes do
                            if f.Name == "DropdownHolderFrame" then f.Visible = false end
                        end
                        arrow.Rotation = 180
                        holderFrame.Visible = true
                    else
                        arrow.Rotation = 0
                        holderFrame.Visible = false
                    end
                end)

                local function getSelectedList()
                    local out = {}
                    for _, v in ipairs(list) do
                        if selected[v] then table.insert(out, v) end
                    end
                    return out
                end

                local function updateBtnText()
                    local sel = getSelectedList()
                    if #sel == 0 then btnText.Text = "(none)"
                    elseif #sel <= 2 then btnText.Text = table.concat(sel, ", ")
                    else btnText.Text = sel[1] .. " +" .. (#sel - 1) end
                end

                local function buildItems()
                    checks = {}
                    for _, ch in ipairs(scrollFrame:GetChildren()) do
                        if ch:IsA("TextButton") and ch.Name == "Item" then ch:Destroy() end
                    end
                    for _, f in next, list do
                        local itemBtn = Instance.new("TextButton")
                        local itemTxt = Instance.new("TextLabel")
                        local check = Instance.new("Frame")

                        itemBtn.Name = "Item"
                        itemBtn.Parent = scrollFrame
                        itemBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                        itemBtn.Size = UDim2.new(1, -12, 0, 20)
                        itemBtn.AutoButtonColor = false
                        itemBtn.Font = Enum.Font.Code
                        itemBtn.Text = ""
                        itemBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
                        itemBtn.TextSize = 14
                        itemBtn.TextXAlignment = Enum.TextXAlignment.Left
                        itemBtn.BackgroundTransparency = 1

                        itemTxt.Parent = itemBtn
                        itemTxt.BackgroundTransparency = 1
                        itemTxt.Position = UDim2.new(0, 7, 0, 0)
                        itemTxt.Size = UDim2.new(1, -30, 1, 0)
                        itemTxt.Font = Enum.Font.Code
                        itemTxt.Text = f
                        itemTxt.TextColor3 = Color3.fromRGB(230, 230, 230)
                        itemTxt.TextSize = 14
                        itemTxt.TextXAlignment = Enum.TextXAlignment.Left

                        check.Name = "Check"
                        check.Parent = itemBtn
                        check.AnchorPoint = Vector2.new(1, 0.5)
                        check.Position = UDim2.new(1, -8, 0.5, 0)
                        check.Size = UDim2.new(0, 10, 0, 10)
                        check.BackgroundColor3 = nexlib.accentclr
                        check.BorderSizePixel = 0
                        check.Visible = selected[f] == true

                        checks[f] = check

                        itemBtn.MouseButton1Click:Connect(function()
                            selected[f] = not selected[f] or nil
                            check.Visible = selected[f] == true
                            updateBtnText()
                            pcall(callback, getSelectedList())
                        end)
                    end
                    holderFrame.Size = UDim2.new(1, -16, 0, math.clamp(listLayout.AbsoluteContentSize.Y + 12, 0, 180))
                    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
                end

                buildItems()
                updateBtnText()

                coroutine.wrap(function()
                    while task.wait() do btn.BorderColor3 = nexlib.accentclr end
                end)()

                function apiObj:Set(value)
                    if type(value) ~= "table" then return end
                    selected = {}
                    for _, v in ipairs(value) do selected[v] = true end
                    for k, c in pairs(checks) do
                        if c and c.Parent then c.Visible = selected[k] == true end
                    end
                    updateBtnText()
                    pcall(callback, getSelectedList())
                end

                function apiObj:Get()
                    return getSelectedList()
                end

                if not skipRegister then
                    pcall(function()
                        _G._nexlibCfg.register(sectionName .. "/" .. text,
                            function() return getSelectedList() end,
                            function(v)
                                if type(v) ~= "table" then return end
                                selected = {}
                                for _, name in ipairs(v) do selected[name] = true end
                                for k, c in pairs(checks) do
                                    if c and c.Parent then c.Visible = selected[k] == true end
                                end
                                updateBtnText()
                                pcall(callback, getSelectedList())
                            end)
                    end)
                end

                return apiObj
            end

            function sectionApi:Label(text)
                local apiObj = {}
                local lbl = Instance.new("TextLabel")

                lbl.Parent = secItemHolder
                lbl.BackgroundTransparency = 1
                lbl.Size = UDim2.new(1, 0, 0, 18)
                lbl.Font = Enum.Font.Code
                lbl.Text = text
                lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
                lbl.TextSize = 14
                lbl.TextXAlignment = Enum.TextXAlignment.Left

                refreshSize()
                function apiObj:Change(newText) lbl.Text = newText end
                return apiObj
            end


            function sectionApi:ColorPicker(text, default, callback)
                local current = default or Color3.fromRGB(255, 255, 255)
                local frame = Instance.new("Frame")
                frame.Parent = secItemHolder
                frame.BackgroundTransparency = 1
                frame.Size = UDim2.new(1, 0, 0, 22)

                local title = Instance.new("TextLabel")
                title.Parent = frame
                title.BackgroundTransparency = 1
                title.Size = UDim2.new(1, -28, 1, 0)
                title.Font = Enum.Font.Code
                title.Text = text
                title.TextColor3 = Color3.fromRGB(230, 230, 230)
                title.TextSize = 14
                title.TextXAlignment = Enum.TextXAlignment.Left

                local swatch = Instance.new("TextButton")
                swatch.Parent = frame
                swatch.AnchorPoint = Vector2.new(1, 0.5)
                swatch.Position = UDim2.new(1, 0, 0.5, 0)
                swatch.Size = UDim2.new(0, 22, 0, 16)
                swatch.BackgroundColor3 = current
                swatch.BorderSizePixel = 0
                swatch.Text = ""
                swatch.AutoButtonColor = false
                local stroke = Instance.new("UIStroke")
                stroke.Parent = swatch
                stroke.Color = Color3.fromRGB(80, 80, 80)
                stroke.Thickness = 1

                -- simple preset cycle + expand RGB panel
                local presets = {
                    Color3.fromRGB(255, 80, 80),
                    Color3.fromRGB(255, 255, 255),
                    Color3.fromRGB(128, 213, 247),
                    Color3.fromRGB(0, 255, 170),
                    Color3.fromRGB(120, 81, 166),
                    Color3.fromRGB(255, 200, 50),
                    Color3.fromRGB(255, 50, 150),
                    Color3.fromRGB(50, 200, 255),
                    Color3.fromRGB(0, 0, 0),
                    Color3.fromRGB(255, 100, 0),
                }
                local idx = 1
                local panelOpen = false
                local panel = Instance.new("Frame")
                panel.Parent = secItemHolder
                panel.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                panel.BorderSizePixel = 0
                panel.Size = UDim2.new(1, 0, 0, 0)
                panel.Visible = false
                panel.ClipsDescendants = true

                local function makeSlider(label, channel)
                    local row = Instance.new("Frame")
                    row.Parent = panel
                    row.BackgroundTransparency = 1
                    row.Size = UDim2.new(1, 0, 0, 18)
                    local l = Instance.new("TextLabel")
                    l.Parent = row
                    l.BackgroundTransparency = 1
                    l.Size = UDim2.new(0, 14, 1, 0)
                    l.Font = Enum.Font.Code
                    l.Text = label
                    l.TextColor3 = Color3.fromRGB(200, 200, 200)
                    l.TextSize = 12
                    local bar = Instance.new("Frame")
                    bar.Parent = row
                    bar.Position = UDim2.new(0, 18, 0.5, -3)
                    bar.Size = UDim2.new(1, -18, 0, 6)
                    bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    bar.BorderSizePixel = 0
                    local fill = Instance.new("Frame")
                    fill.Parent = bar
                    fill.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
                    fill.BorderSizePixel = 0
                    fill.Size = UDim2.new(channel == "R" and current.R or channel == "G" and current.G or current.B, 0, 1, 0)
                    local btn = Instance.new("TextButton")
                    btn.Parent = bar
                    btn.BackgroundTransparency = 1
                    btn.Size = UDim2.new(1, 0, 1, 0)
                    btn.Text = ""
                    local dragging = false
                    local function setFromX(x)
                        local rel = math.clamp(x / math.max(bar.AbsoluteSize.X, 1), 0, 1)
                        fill.Size = UDim2.new(rel, 0, 1, 0)
                        local r, g, b = current.R, current.G, current.B
                        if channel == "R" then r = rel elseif channel == "G" then g = rel else b = rel end
                        current = Color3.new(r, g, b)
                        swatch.BackgroundColor3 = current
                        pcall(callback, current)
                    end
                    btn.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = true
                            setFromX(input.Position.X - bar.AbsolutePosition.X)
                        end
                    end)
                    game:GetService("UserInputService").InputChanged:Connect(function(input)
                        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            setFromX(input.Position.X - bar.AbsolutePosition.X)
                        end
                    end)
                    game:GetService("UserInputService").InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = false
                        end
                    end)
                    return row
                end

                local list = Instance.new("UIListLayout")
                list.Parent = panel
                list.Padding = UDim.new(0, 2)
                list.SortOrder = Enum.SortOrder.LayoutOrder
                local pad = Instance.new("UIPadding")
                pad.Parent = panel
                pad.PaddingLeft = UDim.new(0, 4)
                pad.PaddingRight = UDim.new(0, 4)
                pad.PaddingTop = UDim.new(0, 2)

                makeSlider("R", "R")
                makeSlider("G", "G")
                makeSlider("B", "B")

                swatch.MouseButton1Click:Connect(function()
                    panelOpen = not panelOpen
                    if panelOpen then
                        panel.Visible = true
                        panel.Size = UDim2.new(1, 0, 0, 64)
                    else
                        -- cycle preset on close click alternate: left = open panel
                        panel.Visible = false
                        panel.Size = UDim2.new(1, 0, 0, 0)
                    end
                    refreshSize()
                end)
                swatch.MouseButton2Click:Connect(function()
                    idx = (idx % #presets) + 1
                    current = presets[idx]
                    swatch.BackgroundColor3 = current
                    pcall(callback, current)
                end)

                pcall(function()
                    if _G._nexlibCfg and _G._nexlibCfg.register then
                        _G._nexlibCfg.register(text, function()
                            return {R = current.R, G = current.G, B = current.B}
                        end, function(v)
                            if type(v) == "table" and v.R then
                                current = Color3.new(v.R, v.G, v.B)
                                swatch.BackgroundColor3 = current
                                pcall(callback, current)
                            end
                        end)
                    end
                end)

                refreshSize()
                return { Set = function(_, c) current = c; swatch.BackgroundColor3 = c end }
            end

            return sectionApi
        end

        return tabApi
    end

    function api:Destroy()
        if lighting:FindFirstChild("ValkUIBlur") then lighting.ValkUIBlur:Destroy() end
        _guiMain:Destroy()
    end

    local function intro()
        local TweenService = game:GetService("TweenService")
        task.wait(0.7)

        local blur = lighting:FindFirstChild("ValkUIBlur") or Instance.new("BlurEffect")
        blur.Name = "ValkUIBlur"
        blur.Size = 0
        blur.Parent = lighting

        local introLabel = Instance.new("TextLabel")
        introLabel.Name = "IntroLEVK"
        introLabel.Parent = _guiMain
        introLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        introLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
        introLabel.Size = UDim2.new(0, 400, 0, 100)
        introLabel.BackgroundTransparency = 1
        introLabel.Font = Enum.Font.Code
        introLabel.Text = "LEVK"
        introLabel.TextColor3 = nexlib.accentclr
        introLabel.TextSize = 80
        introLabel.TextTransparency = 1

        local tin = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tout = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

        TweenService:Create(blur, tin, {Size = 24}):Play()
        TweenService:Create(introLabel, tin, {TextTransparency = 0}):Play()

        task.wait(2.2)

        local bt = TweenService:Create(blur, tout, {Size = 18})
        local lt = TweenService:Create(introLabel, tout, {TextTransparency = 1})
        bt:Play()
        lt:Play()

        bt.Completed:Connect(function()
            introLabel:Destroy()
            uiVisible = true
            toggleUI()
        end)
    end

    task.spawn(intro)

    return api
end

-- ============================================================================
-- Services
-- ============================================================================
Players = game:GetService("Players")
RunService = game:GetService("RunService")
UserInputService = game:GetService("UserInputService")
Workspace = game:GetService("Workspace")
HttpService = game:GetService("HttpService")
TweenService = game:GetService("TweenService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
LocalPlayer = Players.LocalPlayer
Camera = Workspace.CurrentCamera

-- ============================================================================
-- Helpers
-- ============================================================================
_0l1lOIIII0 = true

function is_teammate(player)
    if not _0l1lOIIII0 then return false end
    local a = LocalPlayer:GetAttribute("TeamID")
    local b = player:GetAttribute("TeamID")
    if a == nil or b == nil then return false end
    return a == b
end

function get_character(playerOrChar)
    local char = playerOrChar
    if typeof(playerOrChar) == "Instance" and playerOrChar:IsA("Player") then
        char = playerOrChar.Character
    end
    if not char then return true end
    if char:FindFirstChildOfClass("ForceField") then return true end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and hrp:FindFirstChild("Attachment") then return true end
    local immune = char:GetAttribute("Immune") or char:GetAttribute("Invincible") or char:GetAttribute("IsImmune")
    if immune == true then return true end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local hImm = hum:GetAttribute("Immune") or hum:GetAttribute("Invincible")
        if hImm == true then return true end
    end
    return false
end

function get_player_from_part(player)
    local char = player and player.Character
    if not char then return false end
    local attrs = {"Reflecting", "IsReflecting", "BulletReflect", "Reflect", "Deflecting", "Parrying"}
    for _, a in ipairs(attrs) do
        local v = char:GetAttribute(a)
        if v == true or v == 1 or v == "true" then return true end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local hv = hum:GetAttribute(a)
            if hv == true or hv == 1 then return true end
        end
    end
    local hasKatana = false
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and string.find(string.lower(tool.Name), "katana", 1, true) then hasKatana = true end
    for _, ch in ipairs(char:GetChildren()) do
        local n = string.lower(ch.Name)
        if string.find(n, "katana", 1, true) then hasKatana = true end
        if string.find(n, "reflect", 1, true) or string.find(n, "deflect", 1, true) then return true end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local ok, tracks = pcall(function() return hum:GetPlayingAnimationTracks() end)
        if ok and tracks then
            for _, t in ipairs(tracks) do
                local n = string.lower(tostring(t.Name or ""))
                local id = ""
                pcall(function() if t.Animation then id = tostring(t.Animation.AnimationId or "") end end)
                local full = n .. " " .. string.lower(id)
                if string.find(full, "reflect", 1, true) or string.find(full, "deflect", 1, true)
                    or string.find(full, "parry", 1, true) or string.find(full, "block", 1, true) then
                    if hasKatana or string.find(full, "katana", 1, true) then return true end
                    if string.find(full, "reflect", 1, true) or string.find(full, "deflect", 1, true) then return true end
                end
            end
        end
    end
    return false
end

-- ============================================================================
-- Anti-Weapon Module (katana / shield block)
-- ============================================================================
AntiWeapon = {}

function AntiWeapon:GetWeaponName(targetPlayer)
    if not targetPlayer then return "" end
    local viewModels = Workspace:FindFirstChild("ViewModels")
    if not viewModels then return "" end
    local pName = targetPlayer.Name
    for _, model in ipairs(viewModels:GetChildren()) do
        if model:IsA("Model") then
            local modelName = model.Name
            local separator = modelName:find(" - ", 1, true)
            if separator and modelName:sub(1, separator - 1) == pName then
                return modelName:sub(separator + 3):lower()
            end
        end
    end
    return ""
end

function AntiWeapon:IsKatana(targetPlayer)
    local weaponName = self:GetWeaponName(targetPlayer)
    return weaponName:find("katana", 1, true) ~= nil
end

function AntiWeapon:IsShield(targetPlayer)
    local weaponName = self:GetWeaponName(targetPlayer)
    return weaponName:find("riot", 1, true) ~= nil or weaponName:find("shield", 1, true) ~= nil
end

function AntiWeapon:ShouldAttack(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return false end
    local hum = targetPlayer.Character:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    if self:IsKatana(targetPlayer) or self:IsShield(targetPlayer) then
        return false
    end
    return true
end

getgenv().AntiWeapon = AntiWeapon

-- ============================================================================
-- State Variables
-- ============================================================================
_2631x704 = true
ragebotOrKillAura = false
flyEnabled = false
_8080x566 = 50000000
heightLockEnabled = false
lockHeight = 50
_0IO100O = false
_lII0ll = false
_4012x732 = 0.25
a85b57c99 = 0.1

aimbotEnabled = false
aimbotSmoothness = 5
aimbotFovRadius = 100
aimbotHitPart = "head"
showAimbotFov = false
aimbotWallCheck = false
aimbotRequireRMB = false
_aimTarget = nil
_aimTargetPart = nil
_aimTargetLastPos = nil
_aimTargetVelocity = nil
_aimPrevDeltaX = 0
_aimPrevDeltaY = 0

silentAimEnabled = false
silentAimHitParts = {"head"}
silentAimFovRadius = 300
showSilentAimFov = false
silentAimShowFill = false
silentAimFollowGunpoint = true
silentAimFollowTarget = false
silentAimFovFillTransparency = 0.65
silentAimFovThickness = 1.5
silentAimFovRotationSpeed = 60
silentAimFovColor = Color3.fromRGB(255, 80, 80)
silentAimFovColor2 = Color3.fromRGB(255, 255, 255)
silentAimFovFillColor = Color3.fromRGB(255, 80, 80)
silentAimFovFillColor2 = Color3.fromRGB(255, 255, 255)
silentAimFovOutlineTransparency = 0.1
silentWallCheck = false
silentAimTarget = nil
silentAimHookInstalled = false

-- Elisium-style triggerbot config
triggerbotTeamCheck = false
triggerbotReaction = 0.05
triggerbotShootDelay = 0.1
triggerbotMaxDistance = 500
triggerbotIsShooting = false

crosshairEnabled = false
yokaiCrosshairGui = nil
yokaiCrosshairConn = nil

triggerbotEnabled = false
L115_50 = false
a49b29c66 = false
a77b85c82 = false
v50691 = false
v34672 = false
a72b52c65 = false
a77b58c11 = false

shaderEnabled = false
_3323x151 = false
a41b78c88 = false

antiWeaponEnabled = true

espEnabled = false
espBoxEnabled = true
espNameEnabled = true
espHealthEnabled = true
espWeaponEnabled = true
espWeaponInfoEnabled = true
espShowDead = false
espSkeleton = false
espTracer = false
espThemeName = "Cyber Cyan"
espTextSize = 13
espBoxPadding = 108

v59439 = true
_0xebf4 = true
v18003 = false

a54b51c88 = false
_450_226 = false
_0x67db = 50
_Ol01llI10O = 50
_0x98ec = false
a93b76c35 = "all walls"

a13b53c88 = false
emoteHopEnabled = false
emoteSpeed = 40
__JBrJMqdvA = nil
L416_76 = nil

L859_75 = false
a16b37c97 = ""
a67b95c93 = false
_e7ca = "vr"

nameSpooferEnabled = false
yourSpoofedName = "Andy"
enemySpoofedName = "Johnny"

levelSpooferEnabled = false
levelSpooferValue = 325

winstreakSpooferEnabled = false
winstreakSpooferValue = 56

_spooferConnections = {}

_0x479f = {
    ["Dark Sky"] = {
        ["SkyboxUp"] = "rbxassetid://570555929", ["SkyboxRt"] = "rbxassetid://570555882",
        ["SkyboxDn"] = "rbxassetid://570555964", ["SkyboxFt"] = "rbxassetid://570555800",
        ["SkyboxLf"] = "rbxassetid://570555840", ["SkyboxBk"] = "rbxassetid://570555736"
    },
    ["Vaporwave"] = {
        ["SkyboxUp"] = "rbxassetid://1417494643", ["SkyboxRt"] = "rbxassetid://1417494499",
        ["SkyboxLf"] = "rbxassetid://1417494402", ["SkyboxFt"] = "rbxassetid://1417494253",
        ["SkyboxBk"] = "rbxassetid://1417494030", ["SkyboxDn"] = "rbxassetid://1417494146"
    },
    ["Lake Sky"] = {
        ["SkyboxRt"] = "rbxassetid://6823531746", ["SkyboxUp"] = "rbxassetid://6823528533",
        ["SunTextureId"] = "rbxassetid://5392574622", ["SkyboxDn"] = "rbxassetid://6823525702",
        ["SkyboxFt"] = "rbxassetid://6823482923", ["SkyboxLf"] = "rbxassetid://6823530023",
        ["SkyboxBk"] = "rbxassetid://6823523318"
    },
    ["Black Mesa"] = {
        ["SkyboxUp"] = "rbxassetid://9569598752", ["SkyboxRt"] = "rbxassetid://9569601267",
        ["SkyboxDn"] = "rbxassetid://9569613307", ["SkyboxFt"] = "rbxassetid://9569611418",
        ["SkyboxLf"] = "rbxassetid://9569608166", ["SkyboxBk"] = "rbxassetid://9569742122"
    }
}

_690_719 = false
a39b72c33 = nil
a73b35c96 = nil

_10O0lO = nil
v71190 = function(on) end
L555_61 = false
__lhiRNgvZ = 3

L389_46 = nil
L273_20 = nil
_670_782 = nil

_O1lI0IOl = false
__IdrXNjuaHQq = "rust hs"
L698_59 = 1.0
_6958x596 = 1.0

__WskCreglohw = false
_l11IOl10lO = 0
_0xd5a5 = RaycastParams.new()
_0xd5a5.FilterType = Enum.RaycastFilterType.Exclude

_785_562 = {}
a69b44c55 = false

-- ============================================================================
-- Auto weapon switch
-- ============================================================================
local AutoSwapConfig = {
    Enabled = true,
    SwapOnEmpty = true,
    SwapOnReload = false,
    SlotOrder = {1, 2, 3},
    SwapDelay = 0.05,
}

local as_lastSwapTime = 0
local as_currentSlot = 1

local function as_getFighterController()
    local ok, fc = pcall(function()
        return require(LocalPlayer.PlayerScripts.Controllers.FighterController)
    end)
    return ok and fc or nil
end
local function as_getLocalFighter()
    local fc = as_getFighterController()
    return fc and fc.LocalFighter or nil
end
local function as_getEquippedItem()
    local lf = as_getLocalFighter()
    return lf and lf.EquippedItem or nil
end
local function as_getItemInSlot(slotIdx)
    local lf = as_getLocalFighter()
    if not lf or not lf.Items then return nil end
    return lf.Items[slotIdx]
end
local function as_getCurrentAmmo()
    local item = as_getEquippedItem()
    if not item then return nil end
    local cur = item:Get("CurrentAmmo") or item:Get("Ammo") or item:Get("Bullets")
    return tonumber(cur)
end
local function as_isReloading()
    local item = as_getEquippedItem()
    if not item then return false end
    local r = item:Get("Reloading") or item:Get("IsReloading")
    return r == true or r == 1
end
local function as_getEquippedSlot()
    local lf = as_getLocalFighter()
    if not lf or not lf.EquippedItem or not lf.Items then return nil end
    local eid = lf.EquippedItem:Get("ObjectID")
    for i = 1, 3 do
        local it = lf.Items[i]
        if it and it:Get("ObjectID") == eid then return i end
    end
    return nil
end
local function as_switchToSlot(slotIdx)
    local now = tick()
    if now - as_lastSwapTime < AutoSwapConfig.SwapDelay then return end
    as_lastSwapTime = now
    local item = as_getItemInSlot(slotIdx)
    if not item then return end
    local oid = item:Get("ObjectID")
    if not oid then return end
    local ok, EnumLib = pcall(function() return require(ReplicatedStorage.Modules.EnumLibrary) end)
    if ok and EnumLib then
        pcall(function()
            ReplicatedStorage.Remotes.Replication.Fighter.UseItem:FireServer(oid, EnumLib:ToEnum("Equip"), nil, nil)
        end)
    end
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        local keyCodes = {Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three}
        local kc = keyCodes[slotIdx]
        if not kc then return end
        vim:SendKeyEvent(true, kc, false, game)
        task.wait(0.02)
        vim:SendKeyEvent(false, kc, false, game)
    end)
    as_currentSlot = slotIdx
end
local function as_getNextSlot()
    local equippedSlot = as_getEquippedSlot() or as_currentSlot
    local order = AutoSwapConfig.SlotOrder
    local startIdx = 1
    for i, slot in ipairs(order) do
        if slot == equippedSlot then startIdx = i + 1 break end
    end
    for i = 0, #order - 1 do
        local idx = ((startIdx - 1 + i) % #order) + 1
        local slot = order[idx]
        if slot ~= equippedSlot then
            local item = as_getItemInSlot(slot)
            if item then
                local ammo = item:Get("CurrentAmmo") or item:Get("Ammo") or 1
                if tonumber(ammo) and tonumber(ammo) > 0 then return slot end
            end
        end
    end
    return nil
end

local as_lastAmmo = nil
local as_swapCooldown = 0
RunService.Heartbeat:Connect(function(dt)
    if not AutoSwapConfig.Enabled then return end
    as_swapCooldown = as_swapCooldown - dt
    if as_swapCooldown > 0 then return end
    local ammo = as_getCurrentAmmo()
    if AutoSwapConfig.SwapOnEmpty and ammo ~= nil then
        if ammo <= 0 and (as_lastAmmo == nil or as_lastAmmo > 0) then
            local nextSlot = as_getNextSlot()
            if nextSlot then as_switchToSlot(nextSlot) as_swapCooldown = 0.3 end
        end
    end
    as_lastAmmo = ammo
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Q then
        if AutoSwapConfig.Enabled then
            local next = as_getNextSlot()
            if next then as_switchToSlot(next) end
        end
    end
end)

getgenv().AutoSwapConfig = AutoSwapConfig

-- ============================================================================
-- Silent Aim
-- ============================================================================
function getTargetPart(char, partName)
    if not char then return nil end
    if type(partName) == "table" then
        if #partName == 0 then partName = "head" end
        if type(partName) == "table" then
            partName = partName[math.random(1, #partName)]
        end
    end
    local n = string.lower(tostring(partName or "head"))
    if n == "head" then
        return char:FindFirstChild("Head") or char:FindFirstChild("HitboxHead") or char:FindFirstChild("HumanoidRootPart")
    elseif n == "hitboxhead" then
        return char:FindFirstChild("HitboxHead") or char:FindFirstChild("HitboxHeadSmall") or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    elseif n == "hitboxheadsmall" then
        return char:FindFirstChild("HitboxHeadSmall") or char:FindFirstChild("HitboxHead") or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    elseif n == "neck" then
        return char:FindFirstChild("Neck") or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    elseif n == "upper_torso" then
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    elseif n == "lower_torso" then
        return char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    elseif n == "torso" then
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    elseif n == "humanoidrootpart" then
        return char:FindFirstChild("HumanoidRootPart")
    elseif n == "left_arm" then
        return char:FindFirstChild("LeftArm") or char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("HumanoidRootPart")
    elseif n == "right_arm" then
        return char:FindFirstChild("RightArm") or char:FindFirstChild("RightUpperArm") or char:FindFirstChild("HumanoidRootPart")
    elseif n == "left_leg" then
        return char:FindFirstChild("LeftLeg") or char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("HumanoidRootPart")
    elseif n == "right_leg" then
        return char:FindFirstChild("RightLeg") or char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("HumanoidRootPart")
    elseif n == "random" then
        local parts = {"HitboxHead","HitboxHeadSmall","Head","UpperTorso","LowerTorso","Torso","HumanoidRootPart","LeftArm","RightArm","LeftLeg","RightLeg"}
        local valid = {}
        for _, p in ipairs(parts) do
            local part = char:FindFirstChild(p)
            if part then table.insert(valid, part) end
        end
        if #valid > 0 then return valid[math.random(1, #valid)] end
        return char:FindFirstChild("HumanoidRootPart")
    end
    return char:FindFirstChild("Head") or char:FindFirstChild("HitboxHead") or char:FindFirstChild("HumanoidRootPart")
end

function hasLOS(targetPart, myChar)
    local origin = Camera.CFrame.Position
    local dir = targetPart.Position - origin
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {myChar, Camera}
    params.IgnoreWater = true
    local result = workspace:Raycast(origin, dir, params)
    if not result then return true end
    local hitModel = result.Instance and result.Instance:FindFirstAncestorOfClass("Model")
    local targetModel = targetPart:FindFirstAncestorOfClass("Model")
    return hitModel ~= nil and targetModel ~= nil and hitModel == targetModel
end

RunService.RenderStepped:Connect(function()
    if not silentAimEnabled then silentAimTarget = nil return end
    local myChar = LocalPlayer.Character
    if not myChar then silentAimTarget = nil return end
    Camera = workspace.CurrentCamera or Camera
    local mousePos = UserInputService:GetMouseLocation()
    local camPos = Camera.CFrame.Position
    local camLook = Camera.CFrame.LookVector
    local best = nil
    local bestDist = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not is_teammate(player) then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and not char:FindFirstChildOfClass("ForceField") then
                    if not get_character(player) and not get_player_from_part(player)
                       and (not antiWeaponEnabled or AntiWeapon:ShouldAttack(player)) then
                        local part = getTargetPart(char, silentAimHitParts)
                        if part then
                            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                            if onScreen and screenPos.Z > 0 then
                                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                                if dist <= silentAimFovRadius and dist < bestDist then
                                    local rel = part.Position - camPos
                                    if rel.Magnitude > 0 and camLook:Dot(rel.Unit) > 0 then
                                        if (not silentWallCheck) or hasLOS(part, myChar) then
                                            bestDist = dist
                                            best = part
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    silentAimTarget = best
end)

-- drive Elisium-style silent FOV every frame
RunService.RenderStepped:Connect(function(dt)
    pcall(updateSilentFovAdvanced, dt)
end)

task.spawn(function()
    local Gun
    while true do
        local suc, res = pcall(require, LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
        if suc then Gun = res end
        if Gun and Gun.StartShooting then break end
        task.wait(0.5)
    end
    local Utility
    while true do
        local suc, res = pcall(require, ReplicatedStorage.Modules.Utility)
        if suc then Utility = res end
        if Utility and Utility.EncodeCFrame then break end
        task.wait(0.5)
    end
    local oldShoot = Gun.StartShooting
    Gun.StartShooting = function(self, ...)
        local result = { oldShoot(self, ...) }
        if not silentAimEnabled then return unpack(result) end
        if not silentAimTarget or not silentAimTarget.Parent then return unpack(result) end
        local cf = self.ClientFighter
        if not cf or not cf.IsLocalPlayer then return unpack(result) end
        local camData = result[3]
        if not camData or type(camData) ~= "table" then return unpack(result) end

        local targetPart = silentAimTarget
        local targetPos = silentAimTarget.Position
        local pn = string.lower(targetPart.Name)
        if string.find(pn, "head", 1, true) then
            targetPos = targetPos + Vector3.new(0, targetPart.Size.Y * 0.35, 0)
        end

        local camPos = Camera.CFrame.Position
        local dir = (targetPos - camPos)
        if dir.Magnitude < 0.01 then dir = Vector3.new(0, 0, -1) end
        local aimCF = CFrame.new(camPos, camPos + dir.Unit)
        camData[utf8.char(0)] = Utility:EncodeCFrame(aimCF)
        camData[utf8.char(1)] = Utility:EncodeCFrame(aimCF)
        camData[utf8.char(2)] = targetPart
        camData[utf8.char(3)] = Utility:EncodeCFrame(targetPart.CFrame:ToObjectSpace(CFrame.new(targetPos)))
        result[4] = true
        return unpack(result)
    end
    silentAimHookInstalled = true
end)

-- ============================================================================
-- Crosshair (Rivals gun / screen-center aim point)
-- ============================================================================
-- Centers on the gun aim point (viewport center) so it sits on Rivals firearms.
-- Falls back to mouse when cursor is free (menu / unlocked mouse).
crosshairCenterOnGun = true          -- true = stick to weapon aim center
crosshairOnlyWhenArmed = false       -- if true, only show while holding a Tool
crosshairGap = 4
crosshairLength = 10
crosshairThickness = 2
crosshairColor = Color3.fromRGB(255, 255, 255)

local function _crosshairParent()
    local hui
    pcall(function() if gethui then hui = gethui() end end)
    if hui then return hui end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local function _playerHoldingGun()
    local char = LocalPlayer.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then return true end
    -- Rivals sometimes keeps active item under ClientFighter without classic Tool
    local ok, has = pcall(function()
        local ps = LocalPlayer:FindFirstChild("PlayerScripts")
        if not ps then return false end
        local mods = ps:FindFirstChild("Modules")
        if not mods then return false end
        return char:FindFirstChildWhichIsA("Tool", true) ~= nil
    end)
    return ok and has or false
end

function buildCrosshair()
    if _G.YokaiCrosshair then pcall(function() _G.YokaiCrosshair:Destroy() end) end
    if _G.YokaiCrosshairConnection then pcall(function() _G.YokaiCrosshairConnection:Disconnect() end) end

    local gui = Instance.new("ScreenGui")
    gui.Name = "CerusCrosshair"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 99999
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() gui.Parent = _crosshairParent() end)
    if not gui.Parent then
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    _G.YokaiCrosshair = gui
    yokaiCrosshairGui = gui

    local container = Instance.new("Frame")
    container.Name = "CrosshairRoot"
    container.BackgroundTransparency = 1
    container.Size = UDim2.fromOffset(40, 40)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Position = UDim2.fromScale(0.5, 0.5)
    container.Parent = gui

    -- center dot (gun reticle)
    local dot = Instance.new("Frame")
    dot.Name = "Dot"
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Position = UDim2.fromScale(0.5, 0.5)
    dot.Size = UDim2.fromOffset(3, 3)
    dot.BackgroundColor3 = crosshairColor
    dot.BorderSizePixel = 0
    dot.ZIndex = 11
    dot.Parent = container
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot
    local dotStroke = Instance.new("UIStroke")
    dotStroke.Color = Color3.new(0, 0, 0)
    dotStroke.Thickness = 1
    dotStroke.Parent = dot

    local function makeLine(name)
        local line = Instance.new("Frame")
        line.Name = name
        line.BackgroundColor3 = crosshairColor
        line.BorderSizePixel = 0
        line.ZIndex = 10
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.Parent = container
        local st = Instance.new("UIStroke")
        st.Color = Color3.new(0, 0, 0)
        st.Thickness = 1
        st.Parent = line
        return line
    end

    local lineTop = makeLine("Top")
    local lineBottom = makeLine("Bottom")
    local lineLeft = makeLine("Left")
    local lineRight = makeLine("Right")

    local function layoutLines(gap, len, thick)
        -- positive sizes only (Roblox ignores negative Size offsets for Frame)
        lineTop.Size = UDim2.fromOffset(thick, len)
        lineTop.Position = UDim2.new(0.5, 0, 0.5, -(gap + len / 2))
        lineBottom.Size = UDim2.fromOffset(thick, len)
        lineBottom.Position = UDim2.new(0.5, 0, 0.5, (gap + len / 2))
        lineLeft.Size = UDim2.fromOffset(len, thick)
        lineLeft.Position = UDim2.new(0.5, -(gap + len / 2), 0.5, 0)
        lineRight.Size = UDim2.fromOffset(len, thick)
        lineRight.Position = UDim2.new(0.5, (gap + len / 2), 0.5, 0)
    end
    layoutLines(crosshairGap, crosshairLength, crosshairThickness)

    local animT = 0
    yokaiCrosshairConn = RunService.RenderStepped:Connect(function(dt)
        if not crosshairEnabled then
            gui.Enabled = false
            return
        end

        -- optional: only while holding a Rivals gun / Tool
        if crosshairOnlyWhenArmed and not _playerHoldingGun() then
            gui.Enabled = false
            return
        end

        gui.Enabled = true
        animT = animT + dt

        -- Aim point: screen center for Rivals guns (FPS), mouse when unlocked
        local cam = workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
        local aimX, aimY = vp.X * 0.5, vp.Y * 0.5

        if crosshairCenterOnGun then
            -- always pin to gun aim center (viewport middle) — matches Rivals crosshair
            aimX, aimY = vp.X * 0.5, vp.Y * 0.5
        else
            local mousePos = UserInputService:GetMouseLocation()
            aimX, aimY = mousePos.X, mousePos.Y
        end

        -- when mouse is locked (typical while aiming a gun), center is correct;
        -- if mouse free and center mode off, we already used mouse above
        local mouseBehavior = UserInputService.MouseBehavior
        if mouseBehavior == Enum.MouseBehavior.LockCenter or mouseBehavior == Enum.MouseBehavior.LockCurrentPosition then
            aimX, aimY = vp.X * 0.5, vp.Y * 0.5
        end

        container.Position = UDim2.fromOffset(aimX, aimY)

        -- subtle pulse on line length (keeps positive sizes)
        local pulse = 0.5 + 0.5 * math.sin(animT * 3.5)
        local len = crosshairLength + math.floor(3 * pulse)
        layoutLines(crosshairGap, len, crosshairThickness)

        local color = Color3.fromHSV((animT * 0.15) % 1, 0.85, 1)
        lineTop.BackgroundColor3 = color
        lineBottom.BackgroundColor3 = color
        lineLeft.BackgroundColor3 = color
        lineRight.BackgroundColor3 = color
        dot.BackgroundColor3 = color
    end)
    _G.YokaiCrosshairConnection = yokaiCrosshairConn
end

function updateCrosshairState()
    if crosshairEnabled then
        if not _G.YokaiCrosshair or not _G.YokaiCrosshair.Parent then
            buildCrosshair()
        else
            _G.YokaiCrosshair.Enabled = true
        end
        pcall(function() UserInputService.MouseIconEnabled = false end)
    else
        if _G.YokaiCrosshair then _G.YokaiCrosshair.Enabled = false end
        pcall(function() UserInputService.MouseIconEnabled = true end)
    end
end

-- ============================================================================
-- Void spam / Ragebot
-- ============================================================================
task.spawn(function()
    while true do
        if _lII0ll and L555_61 then
            _2631x704 = true
            local v = a85b57c99
            if typeof(v) ~= "number" or v < 0.01 then v = 0.01 end
            task.wait(v)
            if _lII0ll and L555_61 then
                _2631x704 = false
                local d = _4012x732
                if typeof(d) ~= "number" or d < 0.01 then d = 0.01 end
                task.wait(d)
            else _2631x704 = true end
        else
            _2631x704 = true
            task.wait(0.05)
        end
    end
end)

function get_root_part(name)
    local lighting = game:GetService("Lighting")
    local sky = lighting:FindFirstChild("CustomSkybox")
    if not L859_75 or not name or name == "" then
        if sky then sky:Destroy() end
        return
    end
    local data = _0x479f[name]
    if data then
        if not sky then
            sky = Instance.new("Sky")
            sky.Name = "CustomSkybox"
            sky.Parent = lighting
        end
        sky.SkyboxUp = "" sky.SkyboxRt = "" sky.SkyboxDn = ""
        sky.SkyboxFt = "" sky.SkyboxLf = "" sky.SkyboxBk = ""
        sky.SunTextureId = ""
        for prop, val in pairs(data) do sky[prop] = val end
    end
end

function get_character_root(char)
    if not char then return nil end
    return char:FindFirstChild("HitboxHead") or char:FindFirstChild("HitboxHeadSmall") or char:FindFirstChild("Head")
end

task.spawn(function()
    xpcall(function()
        local fc = LocalPlayer.PlayerScripts
        local fcOk, fighterCtrl = pcall(require, fc.Controllers.FighterController)
        local enumOk, enumLib = pcall(require, ReplicatedStorage.Modules.EnumLibrary)
        local useItemRemote = ReplicatedStorage.Remotes.Replication.Fighter.UseItem
        local startShooting
        pcall(function() startShooting = enumLib:ToEnum("StartShooting") end)
        local function getObjectId()
            if not (fcOk and fighterCtrl) then return nil end
            local lf = fighterCtrl.LocalFighter; if not lf then return nil end
            local item = lf.EquippedItem; if not item then return nil end
            local ok, id = pcall(function() return item:Get("ObjectID") end)
            if ok and id then return id end
            ok, id = pcall(function() return item.Data and item.Data.ObjectID end)
            return ok and id or nil
        end
        local function buildTeleport(originPos, target)
            local tp = target.Position
            local cf = CFrame.lookAt(originPos, tp)
            local rx, ry, rz = cf:ToOrientation()
            local posData = {
                [utf8.char(0)] = originPos.X, [utf8.char(1)] = originPos.Y, [utf8.char(2)] = originPos.Z,
                [utf8.char(3)] = rx, [utf8.char(4)] = ry, [utf8.char(5)] = rz,
            }
            local rel = target.CFrame:ToObjectSpace(CFrame.new(tp))
            local rrx, rry, rrz = rel:ToOrientation()
            return {[utf8.char(1)] = {
                [utf8.char(0)] = posData, [utf8.char(1)] = posData, [utf8.char(2)] = target,
                [utf8.char(3)] = {
                    [utf8.char(0)] = rel.X, [utf8.char(1)] = rel.Y, [utf8.char(2)] = rel.Z,
                    [utf8.char(3)] = rrx, [utf8.char(4)] = rry, [utf8.char(5)] = rrz,
                },
            }}
        end
        v71190 = function(on)
            if _10O0lO then _10O0lO:Disconnect(); _10O0lO = nil end
            if not on then return end
            local lastObjId = nil
            _10O0lO = RunService.Heartbeat:Connect(function()
                if not L555_61 or not _2631x704 then return end
                if not a73b35c96 or not a73b35c96.Parent then return end
                local model = a73b35c96:FindFirstAncestorOfClass("Model") or a73b35c96.Parent
                local plr = Players:GetPlayerFromCharacter(model)
                if not plr or plr == LocalPlayer then return end
                if is_teammate(plr) then return end
                if get_character(plr) then return end
                if get_player_from_part(plr) then return end
                if antiWeaponEnabled and not AntiWeapon:ShouldAttack(plr) then return end
                local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not myHrp then return end
                local objId = getObjectId()
                if objId then lastObjId = objId else objId = lastObjId end
                if not objId then return end
                local head = a73b35c96
                local originPos = head.Position + Vector3.new(0, 0.1, 0)
                local tp = buildTeleport(originPos, head)
                pcall(function() useItemRemote:FireServer(objId, startShooting, tp, nil) end)
            end)
        end
    end, function() end)
end)

function find_closest_target()
    local valid = true
    pcall(function()
        local ps = LocalPlayer.PlayerScripts
        local ok, ctrl = pcall(require, ps.Controllers.FighterController)
        if not ok or not ctrl or not ctrl.LocalFighter then return end
        local item = ctrl.LocalFighter.EquippedItem
        if not item then valid = false return end
        local function getProp(key)
            local o, v = pcall(function()
                if item.Get then return item:Get(key) end
                return item[key] or (item.Data and item.Data[key]) or (item.Info and item.Info[key])
            end)
            if o then return v end
            return nil
        end
        local ammo = getProp("CurrentAmmo") or getProp("Ammo") or getProp("Bullets") or getProp("MagazineAmmo")
        local reloading = getProp("Reloading") or getProp("IsReloading")
        if reloading == true then valid = false return end
        if typeof(ammo) == "number" and ammo <= 0 then valid = false return end
    end)
    return valid
end

function v26061()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not L389_46 then return end
    hrp.CFrame = L389_46
    if L273_20 then hrp.AssemblyLinearVelocity = L273_20 end
    L389_46 = nil
    L273_20 = nil
end
pcall(function() RunService:UnbindFromRenderStep("RestoreDesyncPerfect") end)
pcall(function() RunService:BindToRenderStep("RestoreDesyncPerfect", 0, v26061) end)
RunService.RenderStepped:Connect(v26061)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if L389_46 then v26061() end
        if L555_61 and _2631x704 and a73b35c96 and find_closest_target() then
            local model = a73b35c96:FindFirstAncestorOfClass("Model") or a73b35c96.Parent
            local plr = Players:GetPlayerFromCharacter(model)
            if plr and get_player_from_part(plr) then return end
            if plr and antiWeaponEnabled and not AntiWeapon:ShouldAttack(plr) then return end
            L389_46 = hrp.CFrame
            L273_20 = hrp.AssemblyLinearVelocity
            local target = a73b35c96.Position
            local newPos = target + Vector3.new(0, __lhiRNgvZ, 0)
            hrp.CFrame = CFrame.new(newPos, target)
            return
        end
        if flyEnabled then
            if not a39b72c33 then a39b72c33 = hrp.Position end
            L389_46 = hrp.CFrame
            L273_20 = hrp.AssemblyLinearVelocity
            local rand = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)).Unit
            local newPos = a39b72c33 + rand * _8080x566
            local rot = L389_46 - L389_46.Position
            hrp.CFrame = CFrame.new(newPos) * rot
        end
    end)
end)

task.spawn(function()
    while true do
        task.wait(0.01)
        if L555_61 and _2631x704 then
            local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.zero
            local closest = nil
            local minDist = math.huge
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and not is_teammate(player) then
                    if get_character(player) then continue end
                    if get_player_from_part(player) then continue end
                    if antiWeaponEnabled and not AntiWeapon:ShouldAttack(player) then continue end
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    local hum = player.Character:FindFirstChild("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local d = (Vector3.new(myPos.X, 0, myPos.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude
                        if d < minDist then minDist = d closest = player end
                    end
                end
            end
            if closest and closest.Character then
                a73b35c96 = get_character_root(closest.Character)
            else
                a73b35c96 = nil
            end
        else
            a73b35c96 = nil
        end
    end
end)

function set_toggle_state(on)
    if _670_782 then _670_782:Disconnect(); _670_782 = nil end
    if not on then return end
    task.spawn(function()
        xpcall(function()
            local ps = LocalPlayer.PlayerScripts
            local fcOk, fighterCtrl = pcall(require, ps.Controllers.FighterController)
            local enumOk, enumLib = pcall(require, ReplicatedStorage.Modules.EnumLibrary)
            local useItemRemote = ReplicatedStorage.Modules.Replication.Fighter.UseItem
            local startShooting
            pcall(function() startShooting = enumLib:ToEnum("StartShooting") end)
            local function getObjectId()
                if not (fcOk and fighterCtrl) then return nil end
                local lf = fighterCtrl.LocalFighter; if not lf then return nil end
                local item = lf.EquippedItem; if not item then return nil end
                local ok, id = pcall(function() return item:Get("ObjectID") end)
                if ok and id then return id end
                ok, id = pcall(function() return item.Data and item.Data.ObjectID end)
                return ok and id or nil
            end
            local function buildTeleport(originPos, target)
                local tp = target.Position
                local cf = CFrame.lookAt(originPos, tp)
                local rx, ry, rz = cf:ToOrientation()
                local posData = {
                    [utf8.char(0)] = originPos.X, [utf8.char(1)] = originPos.Y, [utf8.char(2)] = originPos.Z,
                    [utf8.char(3)] = rx, [utf8.char(4)] = ry, [utf8.char(5)] = rz,
                }
                local rel = target.CFrame:ToObjectSpace(CFrame.new(tp))
                local rrx, rry, rrz = rel:ToOrientation()
                return {[utf8.char(1)] = {
                    [utf8.char(0)] = posData, [utf8.char(1)] = posData, [utf8.char(2)] = target,
                    [utf8.char(3)] = {
                        [utf8.char(0)] = rel.X, [utf8.char(1)] = rel.Y, [utf8.char(2)] = rel.Z,
                        [utf8.char(3)] = rrx, [utf8.char(4)] = rry, [utf8.char(5)] = rrz,
                    },
                }}
            end
            local lastObjId = nil
            _670_782 = RunService.Heartbeat:Connect(function()
                if not _0IO100O or not _2631x704 then return end
                local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not myHrp then return end
                local objId = getObjectId()
                if objId then lastObjId = objId else objId = lastObjId end
                if not objId then return end
                for _, player in ipairs(Players:GetPlayers()) do
                    if player == LocalPlayer then continue end
                    if is_teammate(player) then continue end
                    if get_character(player) then continue end
                    if antiWeaponEnabled and not AntiWeapon:ShouldAttack(player) then continue end
                    local char = player.Character; if not char then continue end
                    local hum = char:FindFirstChildWhichIsA("Humanoid")
                    if not hum or hum.Health <= 0 then continue end
                    local head = char:FindFirstChild("Head"); if not head then continue end
                    local originPos = head.Position - Vector3.new(0, 5, 0)
                    local tp = buildTeleport(originPos, head)
                    pcall(function() useItemRemote:FireServer(objId, startShooting, tp, nil) end)
                end
            end)
        end, function() end)
    end)
end

-- ============================================================================
-- Spoofer system
-- ============================================================================
local function spoofPlayer(player)
    if not nameSpooferEnabled then return end
    if player == LocalPlayer then
        pcall(function()
            player.Name = yourSpoofedName
            player.DisplayName = yourSpoofedName
        end)
    else
        pcall(function()
            player.Name = enemySpoofedName
            player.DisplayName = enemySpoofedName
        end)
    end
end

local function findAllTitleLabels(instance, results)
    results = results or {}
    if not instance then return results end
    for _, child in ipairs(instance:GetChildren()) do
        if child:IsA("TextLabel") and child.Name == "Title" then
            table.insert(results, child)
        end
        findAllTitleLabels(child, results)
    end
    return results
end

local GUI_PATH = {
    "PlayerGui", "MainGui", "PlayerList", "Container",
    "Elements", "Container", "Middle", "List", "Container"
}

local function getListContainer()
    local node = LocalPlayer
    for _, name in ipairs(GUI_PATH) do
        if not node then return nil end
        node = node:FindFirstChild(name)
    end
    return node
end

local function spoofTitleLabelsInContainer(container)
    if not container then return end
    for _, playerFrame in ipairs(container:GetChildren()) do
        if playerFrame:IsA("Frame") then
            local spoofed = false
            local innerContainer = playerFrame:FindFirstChild("Container")
            if innerContainer and innerContainer:IsA("Frame") then
                for _, child in ipairs(innerContainer:GetChildren()) do
                    if child:IsA("Frame") then
                        local titleLabel = child:FindFirstChild("Title")
                        if titleLabel and titleLabel:IsA("TextLabel") then
                            local isLocal =
                                titleLabel.Text == LocalPlayer.Name or
                                titleLabel.Text == LocalPlayer.DisplayName
                            titleLabel.Text = isLocal
                                and yourSpoofedName
                                or enemySpoofedName
                            spoofed = true
                        end
                    end
                end
            end
            if not spoofed then
                local labels = findAllTitleLabels(playerFrame)
                for _, titleLabel in ipairs(labels) do
                    local isLocal =
                        titleLabel.Text == LocalPlayer.Name or
                        titleLabel.Text == LocalPlayer.DisplayName
                    titleLabel.Text = isLocal
                        and yourSpoofedName
                        or enemySpoofedName
                end
            end
        end
    end
end

local function watchContainerForNewFrames(container)
    if not container then return end
    local conn = container.ChildAdded:Connect(function(child)
        if child:IsA("Frame") then
            task.wait(0.1)
            pcall(spoofTitleLabelsInContainer, container)
        end
    end)
    table.insert(_spooferConnections, conn)
end

local function startGuiSpoofLoop()
    task.spawn(function()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui", 30)
        if not playerGui then return end
        local monitoredContainer = nil
        while task.wait(0.5) do
            if not nameSpooferEnabled then continue end
            local listContainer = getListContainer()
            if listContainer and listContainer ~= monitoredContainer then
                monitoredContainer = listContainer
                watchContainerForNewFrames(listContainer)
            end
            if listContainer then
                pcall(spoofTitleLabelsInContainer, listContainer)
            end
        end
    end)
end

local function spoofLeaderstats()
    local player = LocalPlayer
    if not player then return end
    local leaderstats = player:FindFirstChild("CustomLeaderstats")
    if not leaderstats then return end

    if levelSpooferEnabled then
        local levelVal = leaderstats:FindFirstChild("Level")
        if levelVal and levelVal:IsA("IntValue") then
            pcall(function() levelVal.Value = levelSpooferValue end)
        end
        pcall(function() player:SetAttribute("Level", levelSpooferValue) end)
    end

    if winstreakSpooferEnabled then
        local winStreakFolder = leaderstats:FindFirstChild("Win Streak")
        if winStreakFolder and winStreakFolder:IsA("Folder") then
            local streakVal = winStreakFolder:FindFirstChildWhichIsA("IntValue")
            if streakVal then
                pcall(function() streakVal.Value = winstreakSpooferValue end)
            end
        elseif winStreakFolder and winStreakFolder:IsA("IntValue") then
            pcall(function() winStreakFolder.Value = winstreakSpooferValue end)
        end
        pcall(function() player:SetAttribute("StatisticDuelsWinStreak", winstreakSpooferValue) end)
    end
end

local function watchLeaderstats()
    local player = LocalPlayer
    if not player then return end
    local conn
    conn = player.ChildAdded:Connect(function(child)
        if child.Name == "CustomLeaderstats" then
            task.wait(0.1)
            spoofLeaderstats()
            if conn then conn:Disconnect() end
        end
    end)
    table.insert(_spooferConnections, conn)
    spoofLeaderstats()
end

for _, player in ipairs(Players:GetPlayers()) do
    spoofPlayer(player)
    if player == LocalPlayer then
        watchLeaderstats()
    end
end

local _playerAddedConn = Players.PlayerAdded:Connect(function(player)
    spoofPlayer(player)
end)
table.insert(_spooferConnections, _playerAddedConn)

task.spawn(function()
    while task.wait(1) do
        if levelSpooferEnabled or winstreakSpooferEnabled then
            spoofLeaderstats()
        end
    end
end)

startGuiSpoofLoop()

-- ============================================================================
-- Unlock All
-- ============================================================================
ControllersFolder = LocalPlayer.PlayerScripts:WaitForChild("Controllers", 10)
EnumLibrary = require(ReplicatedStorage.Modules:WaitForChild("EnumLibrary", 10))
if EnumLibrary then EnumLibrary:WaitForEnumBuilder() end
CosmeticLibrary = require(ReplicatedStorage.Modules:WaitForChild("CosmeticLibrary", 10))
ItemLibrary = require(ReplicatedStorage.Modules:WaitForChild("ItemLibrary", 10))
DataController = require(ControllersFolder:WaitForChild("PlayerDataController", 10))

equipped = {}
favorites = {}
constructingWeapon = nil
viewingProfile = nil
lastUsedWeapon = nil

local function cloneCosmetic(name, cosmeticType, options)
    local base = CosmeticLibrary.Cosmetics[name]
    if not base then return nil end
    local data = {}
    for key, value in pairs(base) do data[key] = value end
    data.Name = name
    data.Type = data.Type or cosmeticType
    data.Seed = data.Seed or math.random(1, 1000000)
    if EnumLibrary then
        local success, enumId = pcall(EnumLibrary.ToEnum, EnumLibrary, name)
        if success and enumId then data.Enum, data.ObjectID = enumId, data.ObjectID or enumId end
    end
    if options then
        if options.inverted ~= nil then data.Inverted = options.inverted end
        if options.favoritesOnly ~= nil then data.OnlyUseFavorites = options.favoritesOnly end
    end
    return data
end

unlockSaveFile = "unlockall/config.json"
function saveUnlockConfig()
    if not writefile then return end
    pcall(function()
        local config = {equipped = {}, favorites = favorites}
        for weapon, cosmetics in pairs(equipped) do
            config.equipped[weapon] = {}
            for cosmeticType, cosmeticData in pairs(cosmetics) do
                if cosmeticData and cosmeticData.Name then
                    config.equipped[weapon][cosmeticType] = {
                        name = cosmeticData.Name, seed = cosmeticData.Seed, inverted = cosmeticData.Inverted
                    }
                end
            end
        end
        makefolder("unlockall")
        writefile(unlockSaveFile, HttpService:JSONEncode(config))
    end)
end
function loadUnlockConfig()
    if not readfile or not isfile or not isfile(unlockSaveFile) then return end
    pcall(function()
        local config = HttpService:JSONDecode(readfile(unlockSaveFile))
        if config.equipped then
            for weapon, cosmetics in pairs(config.equipped) do
                equipped[weapon] = {}
                for cosmeticType, cosmeticData in pairs(cosmetics) do
                    local cloned = cloneCosmetic(cosmeticData.name, cosmeticType, {inverted = cosmeticData.inverted})
                    if cloned then cloned.Seed = cosmeticData.seed equipped[weapon][cosmeticType] = cloned end
                end
            end
        end
        favorites = config.favorites or {}
    end)
end

local originalOwnsCosmetic = CosmeticLibrary.OwnsCosmetic
CosmeticLibrary.OwnsCosmetic = function(self, inventory, name, weapon)
    if name:find("MISSING_") then return originalOwnsCosmetic(self, inventory, name, weapon) end
    local cosmetic = CosmeticLibrary.Cosmetics[name]
    if cosmetic then
        local cType = cosmetic.Type
        if cType == "Skin" or cType == "Charm" or cType == "Dance" or cType == "Emote" or cType == "Wrap" or cType == "Wrapping" or name:lower():find("charm") or name:lower():find("dance") or name:lower():find("emote") or name:lower():find("wrap") then
            return true
        end
    end
    return originalOwnsCosmetic(self, inventory, name, weapon)
end
CosmeticLibrary.OwnsCosmeticNormally = function(self, inventory, name, weapon)
    local cosmetic = CosmeticLibrary.Cosmetics[name]
    if cosmetic and cosmetic.Type == "Skin" then return true end
    return false
end
CosmeticLibrary.OwnsCosmeticUniversally = function(self, inventory, name, weapon)
    local cosmetic = CosmeticLibrary.Cosmetics[name]
    if cosmetic and cosmetic.Type == "Skin" then return true end
    return false
end
CosmeticLibrary.OwnsCosmeticForWeapon = function(self, inventory, name, weapon)
    local cosmetic = CosmeticLibrary.Cosmetics[name]
    if cosmetic and cosmetic.Type == "Skin" then return true end
    return false
end

local originalGet = DataController.Get
DataController.Get = function(self, key)
    local data = originalGet(self, key)
    if key == "CosmeticInventory" then
        local proxy = {}
        if data then for k, v in pairs(data) do
            local cosmetic = CosmeticLibrary.Cosmetics[k]
            if cosmetic then proxy[k] = v end
        end end
        return setmetatable(proxy, {__index = function(t, k)
            local cosmetic = CosmeticLibrary.Cosmetics[k]
            if cosmetic then return true end
            return nil
        end})
    end
    if key == "FavoritedCosmetics" then
        local result = data and table.clone(data) or {}
        for weapon, favs in pairs(favorites) do
            result[weapon] = result[weapon] or {}
            for name, isFav in pairs(favs) do result[weapon][name] = isFav end
        end
        return result
    end
    return data
end

local originalGetWeaponData = DataController.GetWeaponData
DataController.GetWeaponData = function(self, weaponName)
    local data = originalGetWeaponData(self, weaponName)
    if not data then return nil end
    local merged = {}
    for key, value in pairs(data) do merged[key] = value end
    merged.Name = weaponName
    if equipped[weaponName] then
        for cosmeticType, cosmeticData in pairs(equipped[weaponName]) do
            merged[cosmeticType] = cosmeticData
        end
    end
    return merged
end

FighterController = nil
pcall(function() FighterController = require(ControllersFolder:WaitForChild("FighterController", 10)) end)

if hookmetamethod then
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local dataRemotes = remotes and remotes:FindFirstChild("Data")
    local equipRemote = dataRemotes and dataRemotes:FindFirstChild("EquipCosmetic")
    local favoriteRemote = dataRemotes and dataRemotes:FindFirstChild("FavoriteCosmetic")
    local replicationRemotes = remotes and remotes:FindFirstChild("Replication")
    local fighterRemotes = replicationRemotes and replicationRemotes:FindFirstChild("Fighter")
    local useItemRemote = fighterRemotes and fighterRemotes:FindFirstChild("UseItem")
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if getnamecallmethod() ~= "FireServer" then return oldNamecall(self, ...) end
        local args = {...}
        if useItemRemote and self == useItemRemote then
            local objectID = args[1]
            if FighterController then
                pcall(function()
                    local fighter = FighterController:GetFighter(LocalPlayer)
                    if fighter and fighter.Items then
                        for _, item in pairs(fighter.Items) do
                            if item:Get("ObjectID") == objectID then lastUsedWeapon = item.Name break end
                        end
                    end
                end)
            end
        end
        if self == equipRemote then
            local weaponName, cosmeticType, cosmeticName, options = args[1], args[2], args[3], args[4] or {}
            if cosmeticName and cosmeticName ~= "None" and cosmeticName ~= "" then
                local inventory = originalGet(DataController, "CosmeticInventory")
                if inventory and rawget(inventory, cosmeticName) then return oldNamecall(self, ...) end
            end
            if cosmeticType == "Dance" or cosmeticType == "Emote" or (cosmeticName and (cosmeticName:lower():find("dance") or cosmeticName:lower():find("emote"))) then
                equipped.Dances = equipped.Dances or {}
                if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                    equipped.Dances[cosmeticType] = nil
                else
                    local cloned = cloneCosmetic(cosmeticName, cosmeticType, {inverted = options.IsInverted, favoritesOnly = options.OnlyUseFavorites})
                    if cloned then equipped.Dances[cosmeticType] = cloned end
                end
                task.defer(function()
                    pcall(function() DataController.CurrentData:Replicate("CosmeticInventory") end)
                    task.wait(0.1) saveUnlockConfig()
                end)
                return
            end
            equipped[weaponName] = equipped[weaponName] or {}
            if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                equipped[weaponName][cosmeticType] = nil
                if not next(equipped[weaponName]) then equipped[weaponName] = nil end
            else
                local cloned = cloneCosmetic(cosmeticName, cosmeticType, {inverted = options.IsInverted, favoritesOnly = options.OnlyUseFavorites})
                if cloned then equipped[weaponName][cosmeticType] = cloned end
            end
            task.defer(function()
                pcall(function() DataController.CurrentData:Replicate("WeaponInventory") end)
                task.wait(0.1) saveUnlockConfig()
            end)
            return
        end
        if self == favoriteRemote then
            local wName, cName, isFav = args[1], args[2], args[3]
            local cosmetic = CosmeticLibrary.Cosmetics[cName]
            if cosmetic then
                favorites[wName] = favorites[wName] or {}
                favorites[wName][cName] = isFav or nil
                saveUnlockConfig()
                task.spawn(function() pcall(function() DataController.CurrentData:Replicate("FavoritedCosmetics") end) end)
            end
            return
        end
        return oldNamecall(self, ...)
    end)
end

ClientItem = nil
pcall(function() ClientItem = require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem) end)
if ClientItem and ClientItem._CreateViewModel then
    local originalCreateViewModel = ClientItem._CreateViewModel
    ClientItem._CreateViewModel = function(self, viewmodelRef)
        local weaponName = self.Name
        local weaponPlayer = self.ClientFighter and self.ClientFighter.Player
        constructingWeapon = (weaponPlayer == LocalPlayer) and weaponName or nil
        if weaponPlayer == LocalPlayer and equipped[weaponName] and viewmodelRef then
            local dataKey = self:ToEnum("Data")
            local targetTable = viewmodelRef[dataKey] or viewmodelRef.Data
            if targetTable then
                if equipped[weaponName].Skin then
                    targetTable[self:ToEnum("Skin") or "Skin"] = equipped[weaponName].Skin
                    targetTable[self:ToEnum("Name") or "Name"] = equipped[weaponName].Skin.Name
                end
                if equipped[weaponName].Charm then
                    targetTable[self:ToEnum("Charm") or "Charm"] = equipped[weaponName].Charm
                end
                if equipped[weaponName].Wrap then
                    targetTable[self:ToEnum("Wrap") or "Wrap"] = equipped[weaponName].Wrap
                end
            end
        end
        local result = originalCreateViewModel(self, viewmodelRef)
        constructingWeapon = nil
        return result
    end
end

local viewModelModule = LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
if viewModelModule then
    local ClientViewModel = require(viewModelModule)
    if ClientViewModel.GetCharm then
        local originalGetCharmFunc = ClientViewModel.GetCharm
        ClientViewModel.GetCharm = function(self)
            local weaponName = self.ClientItem and self.ClientItem.Name
            local weaponPlayer = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
            if weaponName and weaponPlayer == LocalPlayer and equipped[weaponName] and equipped[weaponName].Charm then
                return equipped[weaponName].Charm
            end
            return originalGetCharmFunc(self)
        end
    end
    if ClientViewModel.GetWrap then
        local originalGetWrapFunc = ClientViewModel.GetWrap
        ClientViewModel.GetWrap = function(self)
            local weaponName = self.ClientItem and self.ClientItem.Name
            local weaponPlayer = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
            if weaponName and weaponPlayer == LocalPlayer and equipped[weaponName] and equipped[weaponName].Wrap then
                return equipped[weaponName].Wrap
            end
            return originalGetWrapFunc(self)
        end
    end
    local originalNew = ClientViewModel.new
    ClientViewModel.new = function(replicatedData, clientItem)
        local weaponPlayer = clientItem.ClientFighter and clientItem.ClientFighter.Player
        local weaponName = constructingWeapon or clientItem.Name
        if weaponPlayer == LocalPlayer and equipped[weaponName] then
            local ReplicatedClass = require(ReplicatedStorage.Modules.ReplicatedClass)
            local dataKey = ReplicatedClass:ToEnum("Data")
            replicatedData[dataKey] = replicatedData[dataKey] or {}
            local cosmetics = equipped[weaponName]
            if cosmetics.Skin then replicatedData[dataKey][ReplicatedClass:ToEnum("Skin")] = cosmetics.Skin end
            if cosmetics.Charm then replicatedData[dataKey][ReplicatedClass:ToEnum("Charm")] = cosmetics.Charm end
            if cosmetics.Wrap then replicatedData[dataKey][ReplicatedClass:ToEnum("Wrap")] = cosmetics.Wrap end
        end
        local result = originalNew(replicatedData, clientItem)
        if weaponPlayer == LocalPlayer and equipped[weaponName] and equipped[weaponName].Wrap and result._UpdateWrap then
            result:_UpdateWrap()
            task.delay(0.1, function() if not result._destroyed then result:_UpdateWrap() end end)
        end
        return result
    end
end

ItemLibrary.GetViewModelImageFromWeaponData = function(self, weaponData, highRes)
    if not weaponData then return nil end
    local weaponName = weaponData.Name
    local shouldShowSkin = (weaponData.Skin and equipped[weaponName] and weaponData.Skin == equipped[weaponName].Skin) or (viewingProfile == LocalPlayer and equipped[weaponName] and equipped[weaponName].Skin)
    if shouldShowSkin and equipped[weaponName] and equipped[weaponName].Skin then
        local skinInfo = self.ViewModels[equipped[weaponName].Skin.Name]
        if skinInfo then return skinInfo[highRes and "ImageHighResolution" or "Image"] or skinInfo.Image end
    end
    return nil
end

pcall(function()
    local EmoteController = require(ControllersFolder:WaitForChild("EmoteController", 10))
    if EmoteController and EmoteController.GetEmotes then
        local originalGetEmotes = EmoteController.GetEmotes
        EmoteController.GetEmotes = function(self)
            local emotes = originalGetEmotes(self)
            for name, cosmetic in pairs(CosmeticLibrary.Cosmetics) do
                if cosmetic and (cosmetic.Type == "Dance" or cosmetic.Type == "Emote" or name:lower():find("dance") or name:lower():find("emote")) then
                    if not emotes[name] then
                        emotes[name] = { Name = name, Type = cosmetic.Type, ObjectID = cosmetic.ObjectID, Enum = cosmetic.Enum }
                    end
                end
            end
            return emotes
        end
    end
end)

pcall(function()
    local ViewProfile = require(LocalPlayer.PlayerScripts.Modules.Pages.ViewProfile)
    if ViewProfile and ViewProfile.Fetch then
        local originalFetch = ViewProfile.Fetch
        ViewProfile.Fetch = function(self, targetPlayer)
            viewingProfile = targetPlayer
            return originalFetch(self, targetPlayer)
        end
    end
end)

loadUnlockConfig()
print("[UnlockAll] Cosmetic hooks installed")

-- ============================================================================
-- Wrap auto save / load / apply
-- ============================================================================
task.defer(function()
    task.wait(2)
    local file = "unlockall/wraps.json"
    getgenv()._wrapEquipped = getgenv()._wrapEquipped or {}

    getgenv().SaveWraps = function()
        if not writefile then return end
        pcall(function()
            local out = {}
            for wname, data in pairs(getgenv()._wrapEquipped or {}) do
                if data.Wrap and data.Wrap.Name then
                    out[wname] = data.Wrap.Name
                end
            end
            makefolder("unlockall")
            writefile(file, HttpService:JSONEncode(out))
        end)
    end

    getgenv().LoadWraps = function()
        if not readfile or not isfile then return end
        if not isfile(file) then return end
        pcall(function()
            local data = HttpService:JSONDecode(readfile(file))
            getgenv()._wrapEquipped = getgenv()._wrapEquipped or {}
            for wname, rname in pairs(data) do
                local base = CosmeticLibrary.Cosmetics[rname]
                if base then
                    local d = {}
                    for k, v in pairs(base) do d[k] = v end
                    d.Name = rname
                    d.Type = d.Type or "Wrap"
                    d.Seed = math.random(1, 1000000)
                    pcall(function()
                        local e = EnumLibrary:ToEnum(rname)
                        if e then d.Enum = e; d.ObjectID = d.ObjectID or e end
                    end)
                    getgenv()._wrapEquipped[wname] = { Wrap = d }
                end
            end
            print("[WrapSave] loaded " .. tostring(#data) .. " entries")
        end)
    end

    getgenv().ApplyWrapsToServer = function()
        pcall(function()
            local eq = ReplicatedStorage.Remotes.Data.EquipCosmetic
            for wname, data in pairs(getgenv()._wrapEquipped or {}) do
                if data.Wrap and data.Wrap.Name then
                    eq:FireServer(wname, "Wrap", data.Wrap.Name, {})
                end
            end
        end)
    end

    getgenv().LoadWraps()

    task.delay(1.5, function()
        if getgenv().ApplyWrapsToServer then
            getgenv().ApplyWrapsToServer()
            print("[WrapSave] auto-apply complete")
        end
    end)

    task.spawn(function()
        local lastEquipped = nil
        while task.wait(1) do
            pcall(function()
                local FC = require(LocalPlayer.PlayerScripts.Controllers.FighterController)
                local fighter = FC:GetFighter(LocalPlayer)
                if not fighter or not fighter.EquippedItem then return end
                local currentName = fighter.EquippedItem.Name
                if currentName ~= lastEquipped then
                    lastEquipped = currentName
                    local eq = getgenv()._wrapEquipped[currentName]
                    if eq and eq.Wrap then
                        task.wait(0.3)
                        ReplicatedStorage.Remotes.Data.EquipCosmetic:FireServer(
                            currentName, "Wrap", eq.Wrap.Name, {}
                        )
                    end
                end
            end)
        end
    end)

    task.spawn(function()
        while task.wait(5) do
            getgenv().SaveWraps()
        end
    end)

    print("[WrapSave] auto save/load/apply enabled")
end)

-- ============================================================================
-- UI Setup
-- ============================================================================
-- GitHub live Linoria multi-repo fallback (mstudio45 / violin / ActualMasterOogway)
local LINORIA_REPOS = {
    "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/",
    "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/",
    "https://raw.githubusercontent.com/ActualMasterOogway/Linoria-Library/main/",
    "https://cdn.jsdelivr.net/gh/mstudio45/LinoriaLib@main/",
}
local LINORIA_ENABLED = true
local LinoriaLibrary = nil
local legacyWindowFactory = nexlib.Window
local legacyNotification = nexlib.Notification

local function _halmuHttpGet(url)
    local ok, res = pcall(function()
        if game and game.HttpGet then return game:HttpGet(url, true) end
    end)
    if ok and type(res) == "string" and #res > 500 then return res end
    ok, res = pcall(function()
        if game and game.HttpGetAsync then return game:HttpGetAsync(url) end
    end)
    if ok and type(res) == "string" and #res > 500 then return res end
    local req = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
    if req then
        ok, res = pcall(function() return req({ Url = url, Method = "GET" }) end)
        if ok and type(res) == "table" then
            local body = res.Body or res.body
            if type(body) == "string" and #body > 500 then return body end
        end
    end
    return nil
end

local linoriaLoadOk, linoriaLoadResult = false, "Linoria download did not start"
do
    if not LINORIA_ENABLED then
        linoriaLoadResult = "disabled; using the previous built-in UI"
    else
        local finished, expired = false, false
        task.spawn(function()
            local ok, result = pcall(function()
                assert(loadstring, "loadstring unavailable")
                local lastErr = "no repo"
                for _, repo in ipairs(LINORIA_REPOS) do
                    local source = _halmuHttpGet(repo .. "Library.lua")
                    if type(source) == "string" and #source > 1000 then
                        local chunk, compileError = loadstring(source)
                        if chunk then
                            local lib = chunk()
                            if type(lib) == "table" then
                                getgenv()._CerusLinoriaRepo = repo
                                return lib
                            end
                            lastErr = "library returned non-table from " .. repo
                        else
                            lastErr = tostring(compileError or "compile fail") .. " @ " .. repo
                        end
                    else
                        lastErr = "empty source @ " .. repo
                    end
                end
                error(lastErr)
            end)
            if not expired then
                linoriaLoadOk, linoriaLoadResult = ok, result
                finished = true
            end
        end)

        local deadline = os.clock() + 12
        while not finished and os.clock() < deadline do
            task.wait(0.05)
        end
        if not finished then
            expired = true
            linoriaLoadOk = false
            linoriaLoadResult = "Linoria download timed out after 12 seconds"
        end
    end
end

if linoriaLoadOk and type(linoriaLoadResult) == "table" then
    LinoriaLibrary = linoriaLoadResult
    getgenv().CerusLinoria = LinoriaLibrary

    LinoriaLibrary.AccentColor = nexlib.accentclr
    LinoriaLibrary.AccentColorDark = LinoriaLibrary:GetDarkerColor(nexlib.accentclr)
    LinoriaLibrary.MainColor = Color3.fromRGB(21, 24, 34)
    LinoriaLibrary.BackgroundColor = Color3.fromRGB(13, 16, 24)
    LinoriaLibrary.OutlineColor = Color3.fromRGB(56, 64, 86)
    LinoriaLibrary.FontColor = Color3.fromRGB(235, 240, 250)

    local controlSerial = 0
    local function next_control_id(tabName, sectionName, text)
        controlSerial = controlSerial + 1
        local raw = table.concat({tabName or "tab", sectionName or "section", text or "control"}, "_")
        return "halmu_" .. raw:gsub("[^%w_]", "_") .. "_" .. controlSerial
    end

    local function register_legacy_config(sectionName, text, getter, setter)
        pcall(function()
            _G._nexlibCfg.register(sectionName .. "/" .. text, getter, setter)
        end)
    end

    local function multi_to_array(value)
        local out = {}
        if type(value) == "table" then
            for key, enabled in pairs(value) do
                if enabled == true then table.insert(out, key) end
            end
        end
        table.sort(out)
        return out
    end

    local function array_to_multi(value)
        local out = {}
        if type(value) == "table" then
            for _, name in ipairs(value) do out[name] = true end
        end
        return out
    end

    function nexlib:Notification(title, desc, duration)
        local message = tostring(title or "")
        if desc and desc ~= "" then message = message .. "\n" .. tostring(desc) end
        local ok = pcall(function()
            LinoriaLibrary:Notify(message, duration or 3)
        end)
        if not ok and legacyNotification then
            pcall(legacyNotification, self, title, desc, duration)
        end
    end

    function nexlib:Window_DISABLED(windowTitle)
        local windowOk, window = pcall(function()
            return LinoriaLibrary:CreateWindow({
                Title = tostring(windowTitle or "Cerus Premium") .. "  |  Linoria",
                Center = true,
                AutoShow = true,
                TabPadding = 8,
                MenuFadeTime = 0.18,
            })
        end)

        if not windowOk or not window then
            warn("[CERUS/Linoria] window creation failed; restoring nexlib: " .. tostring(window))
            LinoriaLibrary = nil
            getgenv().CerusLinoria = nil
            if _guiMain then _guiMain.Enabled = true end
            nexlib.Window = legacyWindowFactory
            nexlib.Notification = legacyNotification
            return legacyWindowFactory(self, windowTitle)
        end

        if _guiMain then _guiMain.Enabled = false end
        getgenv().CerusLinoriaWindow = window

        pcall(function()
            LinoriaLibrary:SetWatermark("Cerus Premium  |  Linoria")
            LinoriaLibrary:SetWatermarkVisibility(true)
        end)

        local windowApi = {}

        function windowApi:Tab(tabName)
            local nativeTab = window:AddTab(tabName)
            local tabApi = {}

            function tabApi:Section(sectionName, forceSide)
                local group
                if forceSide == 2 then
                    group = nativeTab:AddRightGroupbox(sectionName)
                else
                    group = nativeTab:AddLeftGroupbox(sectionName)
                end

                local sectionApi = {}

                function sectionApi:Toggle(text, default, callback)
                    local id = next_control_id(tabName, sectionName, text)
                    local control = group:AddToggle(id, {
                        Text = text,
                        Default = default == true,
                        Callback = function(value) pcall(callback, value) end,
                    })
                    local obj = {}
                    function obj:Set(value) control:SetValue(value == true) end
                    register_legacy_config(sectionName, text,
                        function() return control.Value end,
                        function(value) obj:Set(value) end)
                    return obj
                end

                function sectionApi:Button(text, callback)
                    return group:AddButton({
                        Text = text,
                        Func = function() pcall(callback) end,
                        DoubleClick = false,
                    })
                end

                function sectionApi:Slider(text, min, max, default, rounding, callback)
                    local id = next_control_id(tabName, sectionName, text)
                    local safeDefault = math.clamp(tonumber(default) or min, min, max)
                    local control = group:AddSlider(id, {
                        Text = text,
                        Default = safeDefault,
                        Min = min,
                        Max = max,
                        Rounding = rounding or 0,
                        Compact = false,
                        Callback = function(value) pcall(callback, value) end,
                    })
                    register_legacy_config(sectionName, text,
                        function() return control.Value end,
                        function(value) control:SetValue(value) end)
                    return control
                end

                function sectionApi:Input(text, default, placeholder, callback)
                    local id = next_control_id(tabName, sectionName, text)
                    local control = group:AddInput(id, {
                        Text = text,
                        Default = default or "",
                        Placeholder = placeholder or "",
                        Numeric = false,
                        Finished = false,
                        Callback = function(value) pcall(callback, value) end,
                    })
                    register_legacy_config(sectionName, text,
                        function() return control.Value end,
                        function(value) control:SetValue(tostring(value or "")) end)
                    return control
                end

                function sectionApi:Dropdown(text, list, default, callback, skipRegister)
                    local id = next_control_id(tabName, sectionName, text)
                    local hasDefault = default ~= nil and default ~= "" and table.find(list, default) ~= nil
                    local control = group:AddDropdown(id, {
                        Text = text,
                        Values = list,
                        Default = hasDefault and default or nil,
                        AllowNull = not hasDefault,
                        Multi = false,
                        Callback = function(value) pcall(callback, value) end,
                    })
                    local obj = {}
                    function obj:Set(value) control:SetValue(value) end
                    function obj:SetItems(items)
                        control:SetValues(items or {})
                        if control.Value and not table.find(items or {}, control.Value) then
                            control:SetValue(nil)
                        end
                    end
                    if not skipRegister then
                        register_legacy_config(sectionName, text,
                            function() return control.Value end,
                            function(value) obj:Set(value) end)
                    end
                    return obj
                end

                function sectionApi:MultiDropdown(text, list, default, callback, skipRegister)
                    local id = next_control_id(tabName, sectionName, text)
                    local control = group:AddDropdown(id, {
                        Text = text,
                        Values = list,
                        Default = default or {},
                        AllowNull = true,
                        Multi = true,
                        Callback = function(value) pcall(callback, multi_to_array(value)) end,
                    })
                    local obj = {}
                    function obj:Set(value) control:SetValue(array_to_multi(value)) end
                    function obj:SetItems(items) control:SetValues(items or {}) end
                    if not skipRegister then
                        register_legacy_config(sectionName, text,
                            function() return multi_to_array(control.Value) end,
                            function(value) obj:Set(value) end)
                    end
                    return obj
                end

                function sectionApi:Label(text)
                    local label = group:AddLabel(text, true)
                    local obj = {}
                    function obj:Change(newText)
                        if label and label.SetText then label:SetText(tostring(newText)) end
                    end
                    return obj
                end

                function sectionApi:ColorPicker(text, default, callback)
                    local id = next_control_id(tabName, sectionName, text)
                    local control = group:AddLabel(text):AddColorPicker(id, {
                        Default = default or Color3.new(1, 1, 1),
                        Title = text,
                        Callback = function(value) pcall(callback, value) end,
                    })
                    register_legacy_config(sectionName, text,
                        function()
                            local color = control.Value
                            return {R = color.R, G = color.G, B = color.B}
                        end,
                        function(value)
                            if type(value) == "table" and value.R and value.G and value.B then
                                control:SetValueRGB(Color3.new(value.R, value.G, value.B))
                            end
                        end)
                    return control
                end

                return sectionApi
            end

            return tabApi
        end

        function windowApi:Destroy()
            LinoriaLibrary:Unload()
        end

        return windowApi
    end

    task.spawn(function()
        local lastAccent = nil
        while LinoriaLibrary and LinoriaLibrary.ScreenGui and LinoriaLibrary.ScreenGui.Parent do
            if lastAccent ~= nexlib.accentclr then
                lastAccent = nexlib.accentclr
                LinoriaLibrary.AccentColor = lastAccent
                LinoriaLibrary.AccentColorDark = LinoriaLibrary:GetDarkerColor(lastAccent)
                LinoriaLibrary:UpdateColorsUsingRegistry()
            end
            task.wait(0.2)
        end
    end)
else
    if LINORIA_ENABLED then
        warn("[Cerus UI] external UI load skipped; using built-in UI: " .. tostring(linoriaLoadResult))
    else
        print("[Cerus] UI ready (built-in)")
    end
end



-- ============================================================================
-- Yokai Sense UI + Cerus Premium full feature bridge
-- Main first, then Combat / Visuals / Misc / UI Settings
-- ============================================================================

local _YokaiWindow = Library:Window({
    Name = "Cerus Premium",
    Size = UDim2.new(0, 450, 0, 550),
    MinResize = UDim2.new(0, 400, 0, 450),
    CloseBind = Enum.KeyCode.Insert,
})

-- Create ordered tabs (Main first)
local _tabMain = _YokaiWindow:CreateTab({Name = "Main", Icon = "rbxassetid://18248771514"})
local _tabCombat = _YokaiWindow:CreateTab({Name = "Combat", Icon = "rbxassetid://15453335745"})
local _tabVisuals = _YokaiWindow:CreateTab({Name = "Visuals", Icon = "rbxassetid://15453344494"})
local _tabMisc = _YokaiWindow:CreateTab({Name = "Misc", Icon = "rbxassetid://15453354931"})
local _tabUI = _YokaiWindow:CreateTab({Name = "UI Settings", Icon = "rbxassetid://15453349637"})

local function _sideFromForce(forceSide)
    -- nexlib: 1 = left, 2 = right
    if forceSide == 2 or forceSide == "Right" then return "Right" end
    return "Left"
end

local function _wrapSection(ySec)
    local sec = {}
    function sec:Toggle(name, default, callback)
        local opts = { Name = tostring(name or "Toggle"), Default = default and true or false }
        if type(default) == "function" then
            -- nexlib sometimes: Toggle({Callback=...}) style not used; skip
            opts.Callback = default
        else
            opts.Callback = callback or function() end
        end
        if type(opts.Callback) ~= "function" then opts.Callback = function() end end
        local ok, t = pcall(function()
            return ySec:Toggle(opts)
        end)
        if not ok then
            -- fallback minimal
            pcall(function() ySec:Toggle({Name = opts.Name, Default = opts.Default, Callback = opts.Callback}) end)
        end
        -- chain helpers
        local chain = {
            ColorPicker = function(_, ...) return chain end,
            Keybind = function(_, ...) return chain end,
            SetVisible = function(_, ...) return chain end,
        }
        return setmetatable(chain, {__index = function() return function() return chain end end})
    end
    function sec:Slider(name, min, max, default, decimals, callback)
        -- signatures: (name, min, max, default, decimals, cb) OR table
        if type(name) == "table" then
            pcall(function() ySec:Slider(name) end)
            return sec
        end
        local cb = callback
        if type(decimals) == "function" then cb = decimals; decimals = 0 end
        pcall(function()
            ySec:Slider({
                Name = tostring(name or "Slider"),
                Min = tonumber(min) or 0,
                Max = tonumber(max) or 100,
                Default = tonumber(default) or 0,
                Decimal = tonumber(decimals) or 0,
                Callback = cb or function() end,
            })
        end)
        return sec
    end
    function sec:ColorPicker(name, default, callback)
        if type(name) == "table" then return sec end
        pcall(function()
            local lab = ySec:Label({Message = tostring(name or "Color")})
            if lab and lab.ColorPicker then
                lab:ColorPicker({Default = default or Color3.fromRGB(255,255,255), Callback = callback or function() end})
            end
        end)
        return sec
    end
    function sec:Button(name, callback)
        if type(name) == "table" then
            pcall(function() ySec:Button(name) end)
            return sec
        end
        pcall(function()
            ySec:Button({Name = tostring(name or "Button"), Callback = callback or function() end})
        end)
        return sec
    end
    function sec:Label(msg)
        if type(msg) == "table" then
            pcall(function() ySec:Label(msg) end)
            local chain = {}
            function chain:Keybind(...) return chain end
            function chain:ColorPicker(...) return chain end
            return chain
        end
        local lab
        pcall(function() lab = ySec:Label({Message = tostring(msg or "")}) end)
        local chain = lab or {}
        function chain:Keybind(opts)
            pcall(function()
                if lab and lab.Keybind then lab:Keybind(opts or {}) end
            end)
            return chain
        end
        function chain:ColorPicker(opts)
            pcall(function()
                if lab and lab.ColorPicker then lab:ColorPicker(opts or {}) end
            end)
            return chain
        end
        return chain
    end
    function sec:Dropdown(name, content, default, callback)
        if type(name) == "table" then
            pcall(function() ySec:Dropdown(name) end)
            return sec
        end
        -- nexlib: Dropdown("name", {opts}, default, cb) or Dropdown({Content=...})
        if type(name) == "string" and type(content) == "table" then
            pcall(function()
                ySec:Dropdown({
                    Name = name,
                    Content = content,
                    Default = default,
                    Callback = callback or function() end,
                })
            end)
        end
        return sec
    end
    function sec:MultiDropdown(name, content, default, callback)
        pcall(function()
            if ySec.MultiBox then
                ySec:MultiBox({
                    Name = tostring(name or "Multi"),
                    Content = content or {},
                    Default = default,
                    Callback = callback or function() end,
                })
            elseif ySec.Dropdown then
                ySec:Dropdown({
                    Name = tostring(name or "Multi"),
                    Content = content or {},
                    Default = type(default) == "table" and default[1] or default,
                    Callback = function(v)
                        if callback then callback(type(v)=="table" and v or {v}) end
                    end,
                })
            end
        end)
        return sec
    end
    function sec:Keybind(name, default, callback)
        pcall(function()
            local lab = ySec:Label({Message = tostring(name or "Key")})
            if lab and lab.Keybind then
                lab:Keybind({Default = default, Callback = callback or function() end})
            end
        end)
        return sec
    end
    function sec:TextBox(name, default, callback)
        pcall(function()
            if ySec.TextBox then
                ySec:TextBox({Name = tostring(name or ""), Default = default, Callback = callback or function() end})
            end
        end)
        return sec
    end
    function sec:List(opts)
        local listApi = { _vals = {} }
        function listApi:AddValue(n, extra) table.insert(listApi._vals, n) return listApi end
        function listApi:RemoveValue() return listApi end
        pcall(function()
            if ySec.List then ySec:List(opts or {}) end
        end)
        return listApi
    end
    -- catch-all
    setmetatable(sec, {__index = function(_, k)
        return function(_, ...) return sec end
    end})
    return sec
end

local function _wrapTab(yTab)
    local tab = {}
    local leftCount, rightCount = 0, 0
    function tab:Section(name, forceSide)
        local side = _sideFromForce(forceSide)
        local fill = true
        local ySec
        local ok, res = pcall(function()
            return yTab:Section({
                Name = tostring(name or "Section"),
                Side = side == "Right" and "Right" or nil,
                Fill = true,
            })
        end)
        if ok then ySec = res end
        if not ySec then
            -- try without Name
            ok, res = pcall(function() return yTab:Section({Fill = true, Side = side == "Right" and "Right" or nil}) end)
            ySec = res
        end
        return _wrapSection(ySec or {})
    end
    function tab:SubSection(...) return tab end
    function tab:ImageDropdown(...) return tab end
    setmetatable(tab, {__index = function() return function() return tab end end})
    return tab
end

-- nexlib-compatible mainWindow
mainWindow = {
    Tab = function(_, name)
        local n = tostring(name or "")
        if n == "Main" then return _wrapTab(_tabMain) end
        if n == "Combat" then return _wrapTab(_tabCombat) end
        if n == "Visuals" then return _wrapTab(_tabVisuals) end
        if n == "Misc" then return _wrapTab(_tabMisc) end
        if n == "UI Settings" or n == "UI" then return _wrapTab(_tabUI) end
        -- default map unknown to Main
        return _wrapTab(_tabMain)
    end,
}

-- Also provide nexlib stubs so leftover calls don't error
if not nexlib then nexlib = {} end
nexlib.accentclr = nexlib.accentclr or Color3.fromRGB(128, 213, 247)
function nexlib:Notification(title, desc, duration)
    pcall(function()
        Library:Notify({Message = tostring(title or "") .. (desc and (" - " .. tostring(desc)) or ""), Delay = duration or 3})
    end)
end
function nexlib:Window(title)
    return mainWindow
end

-- Main tab quick status
do
    local m = _wrapTab(_tabMain)
    local s = m:Section("main", 1)
    s:Label("Cerus Premium | Yokai Sense UI")
    s:Label("Insert = menu toggle")
    s:Label("All Cerus features bridged")
    local s2 = m:Section("status", 2)
    s2:Label("Combat / Visuals / Misc / UI")
    s2:Button("Test Notify", function()
        Library:Notify({Message = "Cerus Premium ready", Delay = 2})
    end)
end

-- Original Cerus UI wiring expects:
-- mainWindow = nexlib:Window("Cerus Premium")
-- We already set mainWindow; skip that line and keep the rest


-- mainWindow provided by Yokai bridge
tabs = {
    ["Combat"] = mainWindow:Tab("Combat"),
    ["Visuals"] = mainWindow:Tab("Visuals"),
    ["Misc"] = mainWindow:Tab("Misc"),
    ["UI Settings"] = mainWindow:Tab("UI Settings")
}

silentSec = tabs["Combat"]:Section("silent aim", 2)
aimbotSec = tabs["Combat"]:Section("aimbot", 1)

silentSec:Toggle("enabled", false, function(v) silentAimEnabled = v end)
silentSec:MultiDropdown("hit changer (multi)", {
    "head", "hitboxhead", "hitboxheadsmall", "neck",
    "upper_torso", "lower_torso", "torso",
    "humanoidrootpart", "left_arm", "right_arm", "left_leg", "right_leg",
    "random"
}, {"head"}, function(v) silentAimHitParts = v end)
silentSec:Slider("fov radius", 10, 500, 300, 0, function(v) silentAimFovRadius = v end)
silentSec:Toggle("show fov", false, function(v) showSilentAimFov = v end)
silentSec:Toggle("show fill", false, function(v) silentAimShowFill = v end)
silentSec:Toggle("follow gunpoint", true, function(v) silentAimFollowGunpoint = v end)
silentSec:Toggle("follow target", false, function(v) silentAimFollowTarget = v end)
silentSec:Slider("fill transparency", 0, 1, 0.65, 2, function(v) silentAimFovFillTransparency = v end)
silentSec:Slider("fov thickness", 1, 6, 1.5, 1, function(v) silentAimFovThickness = v end)
silentSec:Slider("rotation speed", 0, 360, 60, 0, function(v) silentAimFovRotationSpeed = v end)
silentSec:ColorPicker("fov color", Color3.fromRGB(255, 80, 80), function(c) silentAimFovColor = c end)
silentSec:ColorPicker("fov color 2", Color3.fromRGB(255, 255, 255), function(c) silentAimFovColor2 = c end)
silentSec:ColorPicker("fill color", Color3.fromRGB(255, 80, 80), function(c) silentAimFovFillColor = c end)
silentSec:ColorPicker("fill color 2", Color3.fromRGB(255, 255, 255), function(c) silentAimFovFillColor2 = c end)
silentSec:Toggle("wallcheck", false, function(v) silentWallCheck = v end)

aimbotSec:Toggle("aimbot enabled", false, function(v) aimbotEnabled = v end)
aimbotSec:Dropdown("hitbox", {"head", "humanoidrootpart", "torso", "neck"}, "head", function(v) aimbotHitPart = v end)
aimbotSec:Slider("smoothness", 1, 20, 5, 1, function(v) aimbotSmoothness = v end)
aimbotSec:Slider("fov radius", 10, 500, 100, 0, function(v) aimbotFovRadius = v end)
aimbotSec:Toggle("draw fov", false, function(v) showAimbotFov = v end)
aimbotSec:Toggle("wallcheck", false, function(v) aimbotWallCheck = v end)
aimbotSec:Toggle("scope look", false, function(v) aimbotRequireRMB = v end)
aimbotSec:Toggle("anti-katana/shield", true, function(v) antiWeaponEnabled = v end)

crossSec = tabs["Combat"]:Section("crosshair / fov", 1)
crossSec:Toggle("Gun Crosshair", false, function(v)
    crosshairEnabled = v
    updateCrosshairState()
end)
crossSec:Toggle("center on gun (Rivals)", true, function(v)
    crosshairCenterOnGun = v
end)
crossSec:Toggle("only when holding gun", false, function(v)
    crosshairOnlyWhenArmed = v
end)
crossSec:Slider("gap", 0, 20, 4, 0, function(v) crosshairGap = v end)
crossSec:Slider("length", 4, 30, 10, 0, function(v) crosshairLength = v end)
-- Elisium silent-aim FOV visuals (also under main crosshair section)
crossSec:Toggle("show fov", false, function(v) showSilentAimFov = v end)
crossSec:Toggle("show fill", false, function(v) silentAimShowFill = v end)
crossSec:Toggle("follow gunpoint", true, function(v) silentAimFollowGunpoint = v end)
crossSec:Toggle("follow target", false, function(v) silentAimFollowTarget = v end)
crossSec:Slider("fov radius", 10, 500, 300, 0, function(v) silentAimFovRadius = v end)
crossSec:Slider("fill transparency", 0, 1, 0.65, 2, function(v) silentAimFovFillTransparency = v end)
crossSec:ColorPicker("fov color", Color3.fromRGB(255, 80, 80), function(c) silentAimFovColor = c end)
crossSec:ColorPicker("fov color 2", Color3.fromRGB(255, 255, 255), function(c) silentAimFovColor2 = c end)
crossSec:ColorPicker("fill color", Color3.fromRGB(255, 80, 80), function(c) silentAimFovFillColor = c end)
crossSec:ColorPicker("fill color 2", Color3.fromRGB(255, 255, 255), function(c) silentAimFovFillColor2 = c end)

mobileSec = tabs["Combat"]:Section("mobile setting", 1)
mobileSec:Toggle("mobile on", false, function(v)
    local mf = _guiMain:FindFirstChild("MainFrame", true)
    if mf then
        mf.ClipsDescendants = true
        local ch = mf:FindFirstChild("ContainerHolderFrame")
        if ch then
            ch.ClipsDescendants = true
            ch.Size = UDim2.new(1, -18, 1, -42)
        end
        local TweenService = game:GetService("TweenService")
        local targetSize = v and UDim2.new(0, 525, 0, 300) or UDim2.new(0, 525, 0, 631)
        TweenService:Create(mf, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    end
end)

pullSec = tabs["Combat"]:Section("pull enabled", 1)
pullSec:Toggle("pull", false, function(v) ragebotOrKillAura = v end)

rageSec = tabs["Combat"]:Section("ragebot", 1)
rageSec:Toggle("enabled", false, function(v)
    L555_61 = v
    pcall(function() v71190(v) end)
end)
rageSec:Toggle("orbit", false, function(v)
    flyEnabled = v
    if v then _8080x566 = 5003 end
end)
rageSec:Toggle("voidspam", false, function(v)
    _lII0ll = v
    if not v then _2631x704 = true end
end)
rageSec:Slider("hide", 0.01, 1, 0.25, 2, function(v) _4012x732 = v end)
rageSec:Slider("attack", 0.01, 1, 0.1, 2, function(v) a85b57c99 = v end)

ffaSec = tabs["Combat"]:Section("ffamods", 2)
ffaSec:Toggle("team check", true, function(v) _0l1lOIIII0 = v end)
ffaSec:Toggle("baiting", false, function(v)
    _0IO100O = v
    heightLockEnabled = v
    pcall(function() set_toggle_state(v) end)
end)
ffaSec:Toggle("anti-katana/shield", true, function(v) antiWeaponEnabled = v end)

trigSec = tabs["Combat"]:Section("triggerbot", 2)
trigSec:Toggle("enabled", false, function(v) triggerbotEnabled = v end)
trigSec:Toggle("team check", false, function(v) triggerbotTeamCheck = v end)
trigSec:Slider("reaction time", 0, 0.5, 0.05, 2, function(v) triggerbotReaction = v end)
trigSec:Slider("shoot delay", 0, 0.5, 0.1, 2, function(v) triggerbotShootDelay = v end)
trigSec:Slider("max distance", 50, 2000, 500, 0, function(v) triggerbotMaxDistance = v end)

weapSec = tabs["Combat"]:Section("weapons", 2)
weapSec:Toggle("no spread", false, function(v) L115_50 = v end)
weapSec:Toggle("no muzzle flash", false, function(v) a49b29c66 = v end)
weapSec:Toggle("attack cooldown", false, function(v)
    a77b85c82 = v
    if not v then
        pcall(function() restore_gc_attribute("ShootCooldown") end)
        v50691 = false
    end
end)
weapSec:Toggle("projectile cooldown", false, function(v)
    v34672 = v
    if v then pcall(enable_instant_reload) else pcall(restore_reload) end
end)
weapSec:Toggle("auto switch weapon", true, function(v)
    AutoSwapConfig.Enabled = v
    nexlib:Notification("Auto Switch", v and "enabled" or "disabled", 1)
end)

orbSec = tabs["Combat"]:Section("orb,void", 2)
orbSec:Toggle("orbit", false, function(v) flyEnabled = v end)
orbSec:Slider("orbit studs", 5, 10000, 50000000, 0, function(v) _8080x566 = v end)
orbSec:Toggle("void spam", false, function(v) heightLockEnabled = v end)
orbSec:Slider("void spam studs", 50, 50000000, 50, 0, function(v) lockHeight = v end)

envSec = tabs["Visuals"]:Section("environment", 1)
envSec:Toggle("Fullbright", false, function(v)
    _690_719 = v
    local lighting = game:GetService("Lighting")
    if v then
        lighting.Brightness = 2
        lighting.ClockTime = 14
        lighting.FogEnd = 100000
        lighting.GlobalShadows = false
    else
        lighting.Brightness = 1
        lighting.ClockTime = 12
        lighting.GlobalShadows = true
    end
end)
envSec:Toggle("shader", false, function(v) shaderEnabled = v end)

skySec = tabs["Visuals"]:Section("skybox", 2)
skySec:Toggle("skyboxs", false, function(v)
    L859_75 = v
    get_root_part(a16b37c97)
end)
skySec:Dropdown("Select Skybox", {"Dark Sky", "Vaporwave", "Lake Sky", "Black Mesa"}, "", function(v)
    a16b37c97 = v
    if L859_75 then get_root_part(v) end
end)

espSec = tabs["Visuals"]:Section("visual esp", 1)
espSec:Toggle("ESP Active", false, function(v) espEnabled = v end)
espSec:Toggle("Box Display", true, function(v) espBoxEnabled = v end)
espSec:Toggle("Name Display", true, function(v) espNameEnabled = v end)
espSec:Toggle("Health Display", true, function(v) espHealthEnabled = v end)
espSec:Toggle("Distance Display", true, function(v) espWeaponEnabled = v end)
espSec:Toggle("Weapon Info", true, function(v) espWeaponInfoEnabled = v end)
espSec:Toggle("Corner Box", false, function(v) espSkeleton = v end)
espSec:Toggle("Tracer", false, function(v) espTracer = v end)
espSec:Dropdown("ESP Theme", {"Cyber Cyan", "Violet Pulse", "Toxic Lime", "Crimson", "Clean White"}, "Cyber Cyan", function(v)
    espThemeName = v
end)
espSec:Slider("ESP Text Size", 10, 20, 13, 0, function(v) espTextSize = v end)
espSec:Slider("ESP Box Padding", 95, 130, 108, 0, function(v) espBoxPadding = v end)

indSec = tabs["Visuals"]:Section("indicators", 1)
indSec:Toggle("ragebot", false, function(v) _3323x151 = v end)
indSec:Toggle("ammo", false, function(v) a41b78c88 = v end)

vmSec = tabs["Visuals"]:Section("viewmodel cosmetics", 1)
vmSec:Toggle("no recoil", false, function(v)
    a72b52c65 = v
    if not v then
        pcall(function() restore_gc_attribute("ShootRecoil") end)
        a77b58c11 = false
    end
end)
vmSec:Toggle("unlock all", false, function(v)
    pcall(function()
        if DataController and DataController.CurrentData then
            DataController.CurrentData:Replicate("CosmeticInventory")
            DataController.CurrentData:Replicate("WeaponInventory")
        end
    end)
    if v then
        nexlib:Notification("Unlock All", "all skins / cosmetics unlocked", 1.5)
    end
end)
vmSec:Button("Save Wraps Now", function()
    if getgenv().SaveWraps then getgenv().SaveWraps(); nexlib:Notification("Wrap", "Saved", 1) end
end)
vmSec:Button("Load Wraps", function()
    if getgenv().LoadWraps then getgenv().LoadWraps(); nexlib:Notification("Wrap", "Loaded", 1) end
end)
vmSec:Button("Apply Wraps to Server", function()
    if getgenv().ApplyWrapsToServer then getgenv().ApplyWrapsToServer(); nexlib:Notification("Wrap", "Applied", 1) end
end)

hitSoundMap = {
    ["rust hs"] = "rbxassetid://4764109000",
    ["neverlose"] = "rbxassetid://97643101798871",
    ["sparkle"] = "rbxassetid://110241936966089",
    ["minecraft hit"] = "rbxassetid://8766809464",
    ["bonk"] = "rbxassetid://5766898159",
    ["osu"] = "rbxassetid://7149255551",
    ["among us"] = "rbxassetid://5700183626",
    ["bruh"] = "rbxassetid://4578740568",
    ["vine"] = "rbxassetid://5332680810",
    ["gamesense"] = "rbxassetid://4817809188",
    ["jangchungdong bossam"] = "rbxassetid://85775332966635",
}
hitSoundList = {"rust hs", "neverlose", "sparkle", "minecraft hit", "bonk", "osu", "among us", "bruh", "vine", "gamesense", "jangchungdong bossam"}

hitSec = tabs["Visuals"]:Section("hit sounds", 2)
hitSec:Toggle("enable hit sound", false, function(v) _O1lI0IOl = v end)
hitSec:Dropdown("hit sound style", hitSoundList, "rust hs", function(v) __IdrXNjuaHQq = v end)
hitSec:Slider("volume", 0, 2, 1, 1, function(v) L698_59 = v end)
hitSec:Slider("pitch (speed)", 1, 20, 10, 1, function(v) _6958x596 = math.clamp(v / 10, 0.1, 2) end)

pcall(function()
    local vmPath = LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ClientViewModel
    vmPath.ChildAdded:Connect(function(child)
        if not _O1lI0IOl then return end
        if child:IsA("Sound") and child.SoundId ~= "rbxassetid://16537449730" then
            pcall(function()
                local soundId = hitSoundMap[__IdrXNjuaHQq] or hitSoundMap["rust hs"]
                child.SoundId = soundId
                child.Pitch = _6958x596
                child.Volume = 0
                local newSound = Instance.new("Sound")
                newSound.SoundId = soundId
                newSound.Pitch = _6958x596
                newSound.Volume = L698_59
                newSound.Parent = game:GetService("SoundService")
                newSound:Play()
                game:GetService("Debris"):AddItem(newSound, 4)
            end)
        end
    end)
end)


-- ============================================================================
-- X-PEX Viewmodel & Chams port (Cerus-compatible)
-- 6-DOF transform, material chams, and disable gun textures
-- ============================================================================
local VMX = {
    Enabled = false, X = 0, Y = 0, Z = 0,
    Pitch = 0, Yaw = 0, Roll = 0,
    Chams = false, Color = Color3.fromRGB(53, 215, 199),
    Material = "ForceField", Transparency = 0.5, DisableTextures = false,
    Saved = {}, LastModel = nil, LastBase = nil, Conn = nil
}
local VMXMaterials = {
    ForceField = Enum.Material.ForceField,
    Neon = Enum.Material.Neon,
    Glass = Enum.Material.Glass,
    SmoothPlastic = Enum.Material.SmoothPlastic
}
local function vmxRestore()
    for obj, state in pairs(VMX.Saved) do
        pcall(function()
            if obj.Parent then
                if state.Transparency ~= nil then obj.Transparency = state.Transparency end
                if state.Material ~= nil then obj.Material = state.Material end
                if state.Color ~= nil then obj.Color = state.Color end
            end
        end)
    end
    table.clear(VMX.Saved)
    VMX.LastModel, VMX.LastBase = nil, nil
end
local function vmxSave(obj)
    if VMX.Saved[obj] then return end
    local s = {}
    pcall(function()
        s.Transparency = obj.Transparency
        if obj:IsA("BasePart") then s.Material = obj.Material; s.Color = obj.Color end
    end)
    VMX.Saved[obj] = s
end
local function vmxFindModel()
    -- Use the same first-person ViewModel object used by Rivals/X-PEX,
    -- rather than guessing from workspace.CurrentCamera children.
    local ok, item = pcall(function()
        return as_getEquippedItem and as_getEquippedItem()
    end)
    if ok and item then
        local vm = item.ViewModel
        local model = vm and (vm.Model or vm._model)
        if model and model:IsA("Model") then
            return model
        end
    end
    return nil
end
local function vmxRefresh()
    local wanted = VMX.Enabled or VMX.Chams or VMX.DisableTextures
    if not wanted then
        if VMX.Conn then VMX.Conn:Disconnect(); VMX.Conn = nil end
        vmxRestore()
        return
    end
    if VMX.Conn then return end
    VMX.Conn = game:GetService("RunService").RenderStepped:Connect(function()
        local model = vmxFindModel()
        if not model then return end
        local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
        if VMX.LastModel ~= model then
            VMX.LastModel = model
            VMX.LastBase = nil
        end
        -- Keep chams/textures attached to the actual equipped weapon model.
        -- Offset controls are applied as a small camera-relative offset when enabled.
        if VMX.Enabled and primary then
            local cam = workspace.CurrentCamera
            if cam then
                local offset = CFrame.new(VMX.X, VMX.Y, VMX.Z)
                    * CFrame.Angles(math.rad(VMX.Pitch), math.rad(VMX.Yaw), math.rad(VMX.Roll))
                pcall(function()
                    primary.CFrame = cam.CFrame * offset
                end)
            end
        end
        for _, obj in ipairs(model:GetDescendants()) do
            if obj:IsA("BasePart") and VMX.Chams then
                vmxSave(obj)
                pcall(function()
                    obj.Material = VMXMaterials[VMX.Material] or Enum.Material.ForceField
                    obj.Color = VMX.Color
                    obj.Transparency = VMX.Transparency
                end)
            elseif (obj:IsA("Decal") or obj:IsA("Texture")) and VMX.DisableTextures then
                vmxSave(obj)
                pcall(function() obj.Transparency = 1 end)
            end
        end
    end)
end


vmxSec = tabs["Misc"]:Section("viewmodel & chams", 1)
vmxSec:Toggle("6-DOF transform", false, function(v)
    VMX.Enabled = v
    vmxRefresh()
end)
vmxSec:Slider("Position X", -5, 5, 0, 2, function(v) VMX.X = v end)
vmxSec:Slider("Position Y", -5, 5, 0, 2, function(v) VMX.Y = v end)
vmxSec:Slider("Position Z", -5, 5, 0, 2, function(v) VMX.Z = v end)
vmxSec:Slider("Pitch", -180, 180, 0, 0, function(v) VMX.Pitch = v end)
vmxSec:Slider("Yaw", -180, 180, 0, 0, function(v) VMX.Yaw = v end)
vmxSec:Slider("Roll", -180, 180, 0, 0, function(v) VMX.Roll = v end)
vmxSec:Toggle("Material chams", false, function(v)
    VMX.Chams = v
    vmxRefresh()
end)
vmxSec:ColorPicker("Cham Color", Color3.fromRGB(53, 215, 199), function(c) VMX.Color = c end)
vmxSec:Dropdown("Cham Material", {"ForceField", "Neon", "Glass", "SmoothPlastic"}, "ForceField", function(v)
    VMX.Material = v
end)
vmxSec:Slider("Cham Transparency", 0, 1, 0.5, 2, function(v) VMX.Transparency = v end)
vmxSec:Toggle("Disable gun textures", false, function(v)
    VMX.DisableTextures = v
    vmxRefresh()
end)

moveSec = tabs["Misc"]:Section("movement", 1)
moveSec:Toggle("Mobile Fly", false, function(v) a54b51c88 = v end)
moveSec:Slider("Mobile Fly Speed", 1, 3000, 50, 0, function(v) _0x67db = v end)
moveSec:Toggle("PC Fly", false, function(v) _450_226 = v end)
moveSec:Slider("PC Fly Speed", 1, 10000, 50, 0, function(v) _Ol01llI10O = v end)
moveSec:Toggle("Noclip Active", false, function(v) _0x98ec = v end)
moveSec:Dropdown("Noclip Mode", {"all walls", "phong"}, "all walls", function(v) a93b76c35 = v end)

emoteSec = tabs["Misc"]:Section("emote hop", 2)
emoteSec:Toggle("Emote Hop", false, function(v)
    emoteHopEnabled = v
    if v and LocalPlayer.Character then play_emote(LocalPlayer.Character) else stop_emote() end
end)
emoteSec:Slider("Emote Speed", 1, 40, 40, 0, function(v)
    emoteSpeed = v
    if __JBrJMqdvA and __JBrJMqdvA.IsPlaying then __JBrJMqdvA:AdjustSpeed(v) end
end)

nameSec = tabs["Misc"]:Section("name spoofer", 2)
nameSec:Toggle("enabled", false, function(v)
    nameSpooferEnabled = v
    if v then
        for _, p in ipairs(Players:GetPlayers()) do
            spoofPlayer(p)
        end
        local c = getListContainer()
        if c then pcall(spoofTitleLabelsInContainer, c) end
        nexlib:Notification("Name Spoofer", "name spoof enabled", 1.5)
    end
end)
nameSec:Input("your name", "Andy", "enter your name...", function(text)
    if text and text ~= "" then
        yourSpoofedName = text
        if nameSpooferEnabled then
            spoofPlayer(LocalPlayer)
            local c = getListContainer()
            if c then pcall(spoofTitleLabelsInContainer, c) end
        end
    end
end)
nameSec:Input("enemy name", "Johnny", "enter enemy name...", function(text)
    if text and text ~= "" then
        enemySpoofedName = text
        if nameSpooferEnabled then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then spoofPlayer(p) end
            end
            local c = getListContainer()
            if c then pcall(spoofTitleLabelsInContainer, c) end
        end
    end
end)
nameSec:Button("apply name", function()
    if nameSpooferEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            spoofPlayer(p)
        end
        local c = getListContainer()
        if c then pcall(spoofTitleLabelsInContainer, c) end
        nexlib:Notification("Name Spoofer", "name applied", 1)
    else
        nexlib:Notification("Name Spoofer", "enable first", 1.5)
    end
end)

levelSec = tabs["Misc"]:Section("level spoofer", 1)
levelSec:Toggle("enabled", false, function(v)
    levelSpooferEnabled = v
    if v then
        spoofLeaderstats()
        nexlib:Notification("Level Spoofer", "spoofed level " .. levelSpooferValue, 1.5)
    end
end)
levelSec:Slider("level (1~1000)", 1, 1000, 325, 0, function(v)
    levelSpooferValue = v
    if levelSpooferEnabled then spoofLeaderstats() end
end)
levelSec:Input("custom level", "", "enter number...", function(text)
    local n = tonumber(text)
    if n and n > 0 then
        levelSpooferValue = math.floor(n)
        spoofLeaderstats()
    end
end)
levelSec:Button("apply level", function()
    if levelSpooferEnabled then
        spoofLeaderstats()
        nexlib:Notification("Level Spoofer", "level " .. levelSpooferValue .. " applied", 1)
    else
        nexlib:Notification("Level Spoofer", "enable first", 1.5)
    end
end)

streakSec = tabs["Misc"]:Section("winstreak spoofer", 1)
streakSec:Toggle("enabled", false, function(v)
    winstreakSpooferEnabled = v
    if v then
        spoofLeaderstats()
        nexlib:Notification("Winstreak", "spoofed streak " .. winstreakSpooferValue, 1.5)
    end
end)
streakSec:Slider("winstreak (0~1000)", 0, 1000, 56, 0, function(v)
    winstreakSpooferValue = v
    if winstreakSpooferEnabled then spoofLeaderstats() end
end)
streakSec:Input("custom winstreak", "", "enter number...", function(text)
    local n = tonumber(text)
    if n and n >= 0 then
        winstreakSpooferValue = math.floor(n)
        spoofLeaderstats()
    end
end)
streakSec:Button("apply winstreak", function()
    if winstreakSpooferEnabled then
        spoofLeaderstats()
        nexlib:Notification("Winstreak", "streak " .. winstreakSpooferValue .. " applied", 1)
    else
        nexlib:Notification("Winstreak", "enable first", 1.5)
    end
end)

devSec = tabs["Misc"]:Section("device spoofer", 2)
devSec:Toggle("device spoofer", false, function(v) a67b95c93 = v end)
devSec:Dropdown("device selection", {"vr", "touch", "gamepad", "mousekeyboard"}, "vr", function(v) _e7ca = v end)

tpSec = tabs["Misc"]:Section("third person", 2)
tpSec:Toggle("enabled", false, function(v)
    a13b53c88 = v
    pcall(function()
        local p = cloneref(game:GetService("Players"))
        local cc = require(p.LocalPlayer.PlayerScripts.Controllers.CameraController)
        if v then
            cc.CameraState:_SetPOVState(cc.CameraState.States.ThirdPersonMirrored)
        else
            local states = cc.CameraState.States
            local first = states.FirstPerson or states.FirstPersonMirrored or states.Default
            if first then cc.CameraState:_SetPOVState(first) end
        end
    end)
end)

arcadeSec = tabs["Misc"]:Section("arcade servers", 2)
arcadeSec:Toggle("automatically grab drops", false, function(v) v18003 = v end)

menuSec = tabs["UI Settings"]:Section("menu settings", 1)
menuSec:Label("Press [RightShift] to Toggle UI")
if LinoriaLibrary and menuSec.ColorPicker then
    menuSec:ColorPicker("Theme Accent", nexlib.accentclr, function(color)
        nexlib.accentclr = color
    end)
else
    menuSec:Dropdown("Theme Color", {"Sky Blue", "Red", "Lime Green", "Purple", "Orange"}, "Sky Blue", function(colorName)
        if colorName == "Sky Blue" then nexlib.accentclr = Color3.fromRGB(128, 213, 247)
        elseif colorName == "Red" then nexlib.accentclr = Color3.fromRGB(255, 75, 75)
        elseif colorName == "Lime Green" then nexlib.accentclr = Color3.fromRGB(75, 255, 75)
        elseif colorName == "Purple" then nexlib.accentclr = Color3.fromRGB(180, 75, 255)
        elseif colorName == "Orange" then nexlib.accentclr = Color3.fromRGB(255, 140, 0)
        end
    end)
end
menuSec:Button("Unload UI", function()
    nexlib:Notification("Shutting Down", "Goodbye!", 1.5)
    task.wait(1.5)
    mainWindow:Destroy()
end)

cfgSec = tabs["UI Settings"]:Section("Configuration", 2)

function listConfigs()
    local out = {}
    if listfiles then
        local ok, files = pcall(listfiles, CONFIG_FOLDER)
        if ok and files then
            for _, f in ipairs(files) do
                local n = f:match("([^/\\]+)%.json$")
                if n and n ~= "_default" then table.insert(out, n) end
            end
        end
    end
    return out
end

function saveConfigByName(name)
    if not writefile then return false, "executor: writefile missing" end
    local data = _G._nexlibCfg.collect()
    local ok, err = pcall(function()
        writefile(CONFIG_FOLDER .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    end)
    return ok, err
end

function loadConfigByName(name)
    if _isLoadingConfig then return false, "already loading" end
    if not (readfile and isfile) then return false, "executor: readfile missing" end
    local path = CONFIG_FOLDER .. "/" .. name .. ".json"
    if not isfile(path) then return false, "file not found: " .. name end
    local ok, content = pcall(readfile, path)
    if not ok or not content then return false, "read failed" end
    local ok2, data = pcall(function() return HttpService:JSONDecode(content) end)
    if not ok2 or type(data) ~= "table" then return false, "JSON error" end
    _isLoadingConfig = true
    local appliedOk, appliedErr = pcall(function() _G._nexlibCfg.apply(data) end)
    _isLoadingConfig = false
    if not appliedOk then return false, "apply failed: " .. tostring(appliedErr) end
    return true
end

function deleteConfigByName(name)
    if not delfile then return false, "executor: delfile missing" end
    local path = CONFIG_FOLDER .. "/" .. name .. ".json"
    if isfile and not isfile(path) then return false, "file not found" end
    pcall(delfile, path)
    return true
end

function setDefaultConfig(name)
    if not writefile then return false, "executor: writefile missing" end
    return pcall(function() writefile(CONFIG_DEFAULT_FILE, name) end)
end

function getDefaultConfig()
    if not (readfile and isfile) then return nil end
    if not isfile(CONFIG_DEFAULT_FILE) then return nil end
    local ok, content = pcall(readfile, CONFIG_DEFAULT_FILE)
    if not ok or not content then return nil end
    local name = content:gsub("%s+$", "")
    if name == "" then return nil end
    return name
end

currentConfigName = ""
cfgSec:Input("Config Name", "", "Input here...", function(v) currentConfigName = v or "" end)

cfgDropdown = cfgSec:Dropdown("Config List", listConfigs(), "", function(name)
    if not name or name == "" then return end
    if _isLoadingConfig then return end
    currentConfigName = name
    local ok, err = loadConfigByName(name)
    if ok then
        nexlib:Notification("Config", "loaded: " .. name, 1.5)
    else
        nexlib:Notification("Error", "failed: " .. tostring(err), 2)
    end
end, true)

cfgSec:Button("Refresh List", function()
    cfgDropdown:SetItems(listConfigs())
    nexlib:Notification("Config", "list refreshed", 1)
end)

cfgSec:Button("Save / Create", function()
    if currentConfigName == "" then
        nexlib:Notification("Error", "enter a config name!", 1.5); return
    end
    local ok, err = saveConfigByName(currentConfigName)
    if ok then
        cfgDropdown:SetItems(listConfigs())
        nexlib:Notification("Config", "saved: " .. currentConfigName, 1.5)
    else
        nexlib:Notification("Error", "save failed: " .. tostring(err), 2.5)
    end
end)

cfgSec:Button("Load", function()
    if currentConfigName == "" then
        nexlib:Notification("Error", "enter a config name!", 1.5); return
    end
    local ok, err = loadConfigByName(currentConfigName)
    if ok then
        nexlib:Notification("Config", "loaded: " .. currentConfigName, 1.5)
    else
        nexlib:Notification("Error", "failed: " .. tostring(err), 2.5)
    end
end)

cfgSec:Button("Set as Default", function()
    if currentConfigName == "" then
        nexlib:Notification("Error", "enter a config name!", 1.5); return
    end
    if isfile and not isfile(CONFIG_FOLDER .. "/" .. currentConfigName .. ".json") then
        nexlib:Notification("Error", "save first: " .. currentConfigName, 2); return
    end
    local ok = setDefaultConfig(currentConfigName)
    if ok then
        nexlib:Notification("Config", "default config set: " .. currentConfigName, 2)
    else
        nexlib:Notification("Error", "set failed", 2)
    end
end)

cfgSec:Button("Delete", function()
    if currentConfigName == "" then
        nexlib:Notification("Error", "enter a config name!", 1.5); return
    end
    local ok, err = deleteConfigByName(currentConfigName)
    if ok then
        cfgDropdown:SetItems(listConfigs())
        nexlib:Notification("Config", "deleted: " .. currentConfigName, 1.5)
    else
        nexlib:Notification("Error", "failed: " .. tostring(err), 2.5)
    end
end)

task.defer(function()
    task.wait(0.5)
    local defaultName = getDefaultConfig()
    if defaultName then
        currentConfigName = defaultName
        local ok, err = loadConfigByName(defaultName)
        if ok then
            if cfgDropdown then cfgDropdown:Set(defaultName) end
            nexlib:Notification("Config", "auto-loaded: " .. defaultName, 2)
        else
            nexlib:Notification("Error", "auto-load failed: " .. tostring(err), 2)
        end
    end
end)

-- ============================================================================
-- Indicators
-- ============================================================================
indGui = Instance.new("ScreenGui")
indGui.Name = "CerusIndicators"
indGui.ResetOnSpawn = false
indGui.IgnoreGuiInset = true
indGui.DisplayOrder = 999
indGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() indGui.Parent = game:GetService("CoreGui") end)
if not indGui.Parent then indGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

rageInd = Instance.new("TextLabel")
rageInd.BackgroundTransparency = 1
rageInd.Size = UDim2.new(0, 420, 0, 22)
rageInd.AnchorPoint = Vector2.new(0.5, 0)
rageInd.Position = UDim2.new(0.5, 0, 0.5, 36)
rageInd.Font = Enum.Font.Code
rageInd.TextSize = 14
rageInd.TextColor3 = Color3.fromRGB(245, 245, 245)
rageInd.TextStrokeTransparency = 0
rageInd.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
rageInd.Text = ""
rageInd.Visible = false
rageInd.Parent = indGui

ammoInd = Instance.new("TextLabel")
ammoInd.BackgroundTransparency = 1
ammoInd.Size = UDim2.new(0, 420, 0, 18)
ammoInd.AnchorPoint = Vector2.new(0.5, 0)
ammoInd.Position = UDim2.new(0.5, 0, 0.5, 52)
ammoInd.Font = Enum.Font.Code
ammoInd.TextSize = 11
ammoInd.TextColor3 = Color3.fromRGB(245, 245, 245)
ammoInd.TextStrokeTransparency = 0
ammoInd.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
ammoInd.Text = ""
ammoInd.Visible = false
ammoInd.Parent = indGui

function getLocalAmmoStatus()
    local ammo, reserve, reloading = nil, nil, false
    pcall(function()
        local ps = LocalPlayer.PlayerScripts
        local ok, ctrl = pcall(require, ps.Controllers.FighterController)
        if not ok or not ctrl then return end
        local lf = ctrl.LocalFighter; if not lf then return end
        local item = lf.EquippedItem; if not item then return end
        local function gp(key)
            local o, v = pcall(function()
                if item.Get then return item:Get(key) end
                return item[key] or (item.Data and item.Data[key]) or (item.Info and item.Info[key])
            end)
            if o then return v end
            return nil
        end
        ammo = gp("CurrentAmmo") or gp("Ammo") or gp("Bullets") or gp("MagazineAmmo")
        reserve = gp("ReserveAmmo") or gp("StoredAmmo") or gp("Reserve") or gp("TotalAmmo") or gp("MaxAmmo") or gp("MaxBullets")
        local rl = gp("Reloading") or gp("IsReloading") or gp("Reload")
        reloading = rl == true
    end)
    return ammo, reserve, reloading
end

RunService.RenderStepped:Connect(function()
    if _3323x151 and L555_61 then
        local nm = "idk"
        if a73b35c96 and a73b35c96.Parent then
            local model = a73b35c96:FindFirstAncestorOfClass("Model") or a73b35c96.Parent
            local plr = Players:GetPlayerFromCharacter(model)
            if plr then nm = plr.DisplayName or plr.Name
            elseif typeof(model) == "Instance" then nm = model.Name end
        end
        rageInd.Text = "ragebot : " .. tostring(nm) .. "..."
        rageInd.Visible = true
    else
        rageInd.Visible = false
    end
    if a41b78c88 then
        local ammo, reserve, reloading = getLocalAmmoStatus()
        local text
        if reloading then text = "reloading"
        elseif typeof(ammo) == "number" and typeof(reserve) == "number" then text = string.format("%d/%d", reserve, ammo)
        elseif typeof(ammo) == "number" then text = tostring(ammo) end
        if text then
            ammoInd.Text = text
            ammoInd.Visible = true
        else
            ammoInd.Visible = false
        end
    else
        ammoInd.Visible = false
    end
end)

RunService.RenderStepped:Connect(function()
    if not v18003 then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChild("Humanoid")
    local needsHealth = hum and hum.Health < hum.MaxHealth
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name == "_drop" and obj:IsA("BasePart") then
            if (v59439 and obj:FindFirstChild("Health") and needsHealth) or (_0xebf4 and obj:FindFirstChild("Ammo")) then
                pcall(function()
                    firetouchinterest(hrp, obj, 0)
                    firetouchinterest(hrp, obj, 1)
                end)
            end
        end
    end
end)

-- ============================================================================
-- Weapon mods
-- ============================================================================
II0O0III = {
    ShootCooldown = setmetatable({}, { __mode = "k" }),
    ShootRecoil = setmetatable({}, { __mode = "k" }),
}

function override_gc_attribute(attr, value)
    local saved = II0O0III[attr]
    if not saved then return end
    for _, gcVal in pairs(getgc(true)) do
        if type(gcVal) == "table" then
            local v = rawget(gcVal, attr)
            if v ~= nil then
                if saved[gcVal] == nil then saved[gcVal] = v end
                gcVal[attr] = value
            end
        end
    end
end

function restore_gc_attribute(attr)
    local saved = II0O0III[attr]
    if not saved then return end
    for gcVal, original in pairs(saved) do
        if type(gcVal) == "table" then
            pcall(function() gcVal[attr] = original end)
        end
        saved[gcVal] = nil
    end
end

_361_510 = {}
_1OIOIOI0I = false

function enable_instant_reload()
    local lib = require(game:GetService("ReplicatedStorage").Modules.ItemLibrary)
    local Items = rawget(lib, "Items")
    if not Items then return end
    local targets = {"Bow", "Daggers", "Slingshot"}
    for _, Item in pairs(Items) do
        local Name = Item.Name
        if table.find(targets, Name) and Item["ReloadLength"] ~= nil then
            if _361_510[Name] == nil then _361_510[Name] = Item["ReloadLength"] end
            rawset(Item, "ReloadLength", (Name == "Daggers" and 0.09 or 0))
        end
    end
    _1OIOIOI0I = true
end

function restore_reload()
    local lib = require(game:GetService("ReplicatedStorage").Modules.ItemLibrary)
    local Items = rawget(lib, "Items")
    if not Items then return end
    local targets = {"Bow", "Daggers", "Slingshot"}
    for _, Item in pairs(Items) do
        local Name = Item.Name
        if table.find(targets, Name) and _361_510[Name] ~= nil then
            rawset(Item, "ReloadLength", _361_510[Name])
        end
    end
    _1OIOIOI0I = false
end

RunService.Heartbeat:Connect(function()
    if a77b85c82 then
        pcall(function() override_gc_attribute("ShootCooldown", 0) end)
        v50691 = true
    elseif v50691 then
        pcall(function() restore_gc_attribute("ShootCooldown") end)
        v50691 = false
    end
    if a72b52c65 then
        pcall(function() override_gc_attribute("ShootRecoil", 0) end)
        a77b58c11 = true
    elseif a77b58c11 then
        pcall(function() restore_gc_attribute("ShootRecoil") end)
        a77b58c11 = false
    end
    if v34672 then
        pcall(enable_instant_reload)
    elseif _1OIOIOI0I then
        pcall(restore_reload)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    if emoteHopEnabled then
        char:WaitForChild("Humanoid")
        task.wait(0.1)
        if play_emote then play_emote(char) end
    end
    if a13b53c88 then
        task.defer(function()
            pcall(function()
                local p = cloneref(game:GetService("Players"))
                local cc = require(p.LocalPlayer.PlayerScripts.Controllers.CameraController)
                cc.CameraState:_SetPOVState(cc.CameraState.States.ThirdPersonMirrored)
            end)
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if a67b95c93 then
            pcall(function()
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                local repl = remotes and remotes:FindFirstChild("Replication") or remotes
                local fighter = repl and repl:FindFirstChild("Fighter")
                local setControls = fighter and fighter:FindFirstChild("SetControls")
                if setControls and setControls:IsA("RemoteEvent") then
                    if _e7ca == "vr" then setControls:FireServer("VR")
                    elseif _e7ca == "touch" then setControls:FireServer("Touch")
                    elseif _e7ca == "gamepad" then setControls:FireServer("Gamepad")
                    elseif _e7ca == "mousekeyboard" then setControls:FireServer("MouseKeyboard") end
                end
            end)
        end
    end
end)

RunService.Stepped:Connect(function(dt)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp then return end
    if _0x98ec then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    if (a54b51c88 or _450_226) then
        if hum then hum.PlatformStand = true end
        local vel = Vector3.zero
        if a54b51c88 then
            if hum and hum.MoveDirection.Magnitude > 0 then vel = Camera.CFrame.LookVector * _0x67db end
        elseif _450_226 then
            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
            if dir.Magnitude > 0 then vel = dir.Unit * _Ol01llI10O end
        end
        hrp.AssemblyLinearVelocity = vel
        hrp.AssemblyAngularVelocity = Vector3.zero
    else
        if hum and hum.PlatformStand then
            hum.PlatformStand = false
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end
end)

function resolve_animation_asset(id)
    local ok, objs = pcall(function() return game:GetObjects(id) end)
    if ok and objs and #objs > 0 then
        for i = 1, #objs do
            if objs[i]:IsA("Animation") then return objs[i].AnimationId end
        end
    end
    return id
end

task.spawn(function()
    local id = "rbxassetid://92281817840531"
    id = resolve_animation_asset(id)
    L416_76 = Instance.new("Animation")
    L416_76.AnimationId = id
end)

function play_emote(char)
    if not emoteHopEnabled or not char or not L416_76 then return end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hum then return end
    if __JBrJMqdvA then __JBrJMqdvA:Stop() __JBrJMqdvA = nil end
    local animator = hum:FindFirstChildOfClass("Animator") or hum
    local ok, anim = pcall(function() return animator:LoadAnimation(L416_76) end)
    if ok and anim then
        __JBrJMqdvA = anim
        anim.Priority = Enum.AnimationPriority.Action4
        anim:Play()
        anim:AdjustSpeed(emoteSpeed)
        anim.Stopped:Connect(function()
            if emoteHopEnabled and LocalPlayer.Character == char then play_emote(char) end
        end)
    end
end

function stop_emote()
    if __JBrJMqdvA then __JBrJMqdvA:Stop() __JBrJMqdvA = nil end
end

task.spawn(function()
    while true do
        task.wait(0.05)
        if flyEnabled then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and not a39b72c33 then a39b72c33 = hrp.Position end
        else
            a39b72c33 = nil
        end
    end
end)

-- ============================================================================
-- FOV GUI
-- ============================================================================
fovGui = Instance.new("ScreenGui")
fovGui.Name = "CerusFOV"
fovGui.ResetOnSpawn = false
fovGui.IgnoreGuiInset = true
fovGui.DisplayOrder = 50
pcall(function() fovGui.Parent = game:GetService("CoreGui") end)
if not fovGui.Parent then fovGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Elisium-style FOV circle (show fill / follow gunpoint / follow target)
function GetMuzzlePos()
    -- Rivals gun FOV anchor: prefer real muzzle on viewmodel / equipped Tool
    local cam = workspace.CurrentCamera
    if not cam then return Vector2.new(0, 0) end
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local nameHints = {
        "_muzzle", "Muzzle", "muzzle", "Fire", "FirePoint", "Shoot", "Barrel",
        "Tip", "GunTip", "Flash", "MuzzleFlash", "Emitter", "BulletOrigin"
    }
    local function isMuzzleName(n)
        if not n then return false end
        for i = 1, #nameHints do
            if n == nameHints[i] then return true end
        end
        local lower = string.lower(n)
        return lower:find("muzzle", 1, true) or lower:find("barrel", 1, true)
            or lower:find("firepoint", 1, true) or lower:find("guntip", 1, true)
    end
    local function worldToScreen(worldPos)
        local pos, on = cam:WorldToViewportPoint(worldPos)
        if on and pos.Z > 0 then
            return Vector2.new(pos.X, pos.Y)
        end
        return nil
    end
    local function scan(root)
        if not root then return nil end
        -- attachments first
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("Attachment") and isMuzzleName(d.Name) then
                local s = worldToScreen(d.WorldPosition)
                if s then return s end
            end
        end
        -- parts / meshparts next
        for _, d in ipairs(root:GetDescendants()) do
            if (d:IsA("BasePart") or d:IsA("MeshPart")) and isMuzzleName(d.Name) then
                local s = worldToScreen(d.Position)
                if s then return s end
            end
        end
        return nil
    end

    -- 1) Camera viewmodel (first-person Rivals gun)
    local hit = scan(cam)
    if hit then return hit end

    -- 2) Equipped tool on character
    local char = LocalPlayer.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            hit = scan(tool)
            if hit then return hit end
        end
        hit = scan(char)
        if hit then return hit end
    end

    -- 3) Common viewmodel folders under PlayerGui / workspace
    pcall(function()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then
            for _, child in ipairs(pg:GetChildren()) do
                local n = string.lower(child.Name)
                if n:find("view", 1, true) or n:find("gun", 1, true) or n:find("weapon", 1, true) then
                    hit = scan(child)
                    if hit then return end
                end
            end
        end
    end)
    if hit then return hit end

    -- 4) fallback: screen center (ADS / locked mouse)
    return center
end

function makeFovCircle(name, color)
    local f = Instance.new("Frame")
    f.Name = name
    f.AnchorPoint = Vector2.new(0.5, 0.5)
    f.BackgroundColor3 = color
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.Visible = false
    f.Parent = fovGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = f
    local stroke = Instance.new("UIStroke")
    stroke.Name = "Outline"
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1.5
    stroke.Color = color
    stroke.Transparency = 0.15
    stroke.Parent = f
    local fillGrad = Instance.new("UIGradient")
    fillGrad.Name = "FillGrad"
    fillGrad.Enabled = false
    fillGrad.Parent = f
    local strokeGrad = Instance.new("UIGradient")
    strokeGrad.Name = "StrokeGrad"
    strokeGrad.Parent = stroke
    return f
end

aimbotFovCircle = makeFovCircle("AimbotFOV", Color3.fromRGB(255, 255, 255))
silentFovCircle = makeFovCircle("SilentAimFOV", Color3.fromRGB(255, 80, 80))

local _fovRotation = 0
local _sfovPos = Vector2.zero
local _sfovRadius = 300

function updateFovCircle(circle, mousePos, radius, visible)
    if not visible then circle.Visible = false return end
    local r = math.max(tonumber(radius) or 50, 10)
    circle.Size = UDim2.fromOffset(r * 2, r * 2)
    circle.Position = UDim2.fromOffset(mousePos.X, mousePos.Y)
    circle.Visible = true
end

-- Advanced silent FOV updater (Elisium parity: fill / gunpoint / target)
function updateSilentFovAdvanced(dt)
    local show = (silentAimEnabled == true) and (showSilentAimFov == true)
    if not show then
        silentFovCircle.Visible = false
        return
    end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local targetPos = center

    local followGP = silentAimFollowGunpoint == true
    local followT = silentAimFollowTarget == true

    if followGP and followT then
        -- midpoint between muzzle and target (Elisium behavior)
        local muzzle = GetMuzzlePos()
        local tpart = silentAimTarget
        if tpart and tpart.Parent then
            local sp, on = cam:WorldToViewportPoint(tpart.Position)
            if on and sp.Z > 0 then
                targetPos = Vector2.new((muzzle.X + sp.X) * 0.5, (muzzle.Y + sp.Y) * 0.5)
            else
                targetPos = muzzle
            end
        else
            targetPos = muzzle
        end
    elseif followT then
        local tpart = silentAimTarget
        if tpart and tpart.Parent then
            local sp, on = cam:WorldToViewportPoint(tpart.Position)
            if on and sp.Z > 0 then
                targetPos = Vector2.new(sp.X, sp.Y)
            end
        end
    elseif followGP then
        targetPos = GetMuzzlePos()
    else
        -- default for Rivals: stick FOV to gun model when armed, else mouse/center
        local armed = false
        pcall(function()
            local ch = LocalPlayer.Character
            if ch and ch:FindFirstChildOfClass("Tool") then armed = true end
        end)
        if armed then
            targetPos = GetMuzzlePos()
        else
            targetPos = UserInputService:GetMouseLocation()
            if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
                targetPos = center
            end
        end
    end

    dt = tonumber(dt) or 0.016
    _fovRotation = (_fovRotation + (silentAimFovRotationSpeed or 60) * dt) % 360
    local lerp = 0.35
    if _sfovPos.Magnitude < 1 then _sfovPos = targetPos end
    _sfovPos = _sfovPos:Lerp(targetPos, math.clamp(lerp, 0.05, 1))
    local desiredR = math.max(tonumber(silentAimFovRadius) or 100, 10)
    _sfovRadius = _sfovRadius + (desiredR - _sfovRadius) * lerp

    local c = silentFovCircle
    c.Visible = true
    c.Size = UDim2.fromOffset(_sfovRadius * 2, _sfovRadius * 2)
    c.Position = UDim2.fromOffset(_sfovPos.X, _sfovPos.Y)
    c.Rotation = _fovRotation
    c.BackgroundColor3 = silentAimFovFillColor or Color3.fromRGB(255, 80, 80)
    if silentAimShowFill then
        c.BackgroundTransparency = tonumber(silentAimFovFillTransparency) or 0.65
    else
        c.BackgroundTransparency = 1
    end
    local stroke = c:FindFirstChild("Outline")
    if stroke then
        stroke.Color = silentAimFovColor or Color3.fromRGB(255, 80, 80)
        stroke.Thickness = tonumber(silentAimFovThickness) or 1.5
        stroke.Transparency = 0.1
    end
    local fillGrad = c:FindFirstChild("FillGrad")
    if fillGrad then
        fillGrad.Enabled = silentAimShowFill == true
        fillGrad.Rotation = _fovRotation
        pcall(function()
            fillGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, silentAimFovFillColor or Color3.fromRGB(255, 80, 80)),
                ColorSequenceKeypoint.new(1, silentAimFovFillColor2 or Color3.fromRGB(255, 255, 255)),
            })
        end)
    end
    local strokeGrad = stroke and stroke:FindFirstChild("StrokeGrad")
    if strokeGrad then
        strokeGrad.Rotation = _fovRotation
        pcall(function()
            strokeGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, silentAimFovColor or Color3.fromRGB(255, 80, 80)),
                ColorSequenceKeypoint.new(1, silentAimFovColor2 or Color3.fromRGB(255, 255, 255)),
            })
        end)
    end
    if stroke then
        stroke.Transparency = tonumber(silentAimFovOutlineTransparency) or 0.1
    end
end

-- ============================================================================
-- Aimbot
-- ============================================================================
do
    local mouse = UserInputService

    local function pickPart(char)
        local n = string.lower(tostring(aimbotHitPart or "head"))
        if n == "humanoidrootpart" then
            return char:FindFirstChild("HumanoidRootPart")
        elseif n == "torso" then
            return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
        elseif n == "neck" then
            return char:FindFirstChild("Neck") or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        end
        return char:FindFirstChild("Head")
            or char:FindFirstChild("HitboxHead")
            or char:FindFirstChild("HumanoidRootPart")
    end

    local function inViewCone(worldPos)
        local camPos = Camera.CFrame.Position
        local look = Camera.CFrame.LookVector
        local toTarget = (worldPos - camPos)
        if toTarget.Magnitude < 0.001 then return true end
        return look:Dot(toTarget.Unit) > 0.45
    end

    local function estimateVelocity(part)
        local now = tick()
        local last = _aimTargetLastPos
        if not last or not last.part or last.part ~= part then
            return Vector3.zero
        end
        local dt = now - last.t
        if dt <= 0 then return Vector3.zero end
        return (part.Position - last.pos) / dt
    end

    RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        local mousePos = mouse:GetMouseLocation()
        Camera = workspace.CurrentCamera or Camera

        updateFovCircle(aimbotFovCircle, mousePos, aimbotFovRadius, showAimbotFov == true)
        updateSilentFovAdvanced(0.016) -- Elisium showfov/fill/gunpoint/target

        local doAimbot = aimbotEnabled and char and (
            (not aimbotRequireRMB) or mouse:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        )
        if not doAimbot then
            _aimTarget = nil
            _aimTargetPart = nil
            _aimTargetVelocity = Vector3.zero
            return
        end

        if _aimTargetPart then
            local hum = _aimTarget and _aimTarget:FindFirstChildOfClass("Humanoid")
            if not _aimTargetPart.Parent or not hum or hum.Health <= 0 or is_teammate(_aimTarget) then
                _aimTarget = nil
                _aimTargetPart = nil
            end
        end

        local best, bestPart, bestScore = nil, nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not is_teammate(player) then
                local pchar = player.Character
                if pchar then
                    local hum = pchar:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 and not pchar:FindFirstChildOfClass("ForceField") then
                        if not get_character(player) and not get_player_from_part(player)
                           and (not antiWeaponEnabled or AntiWeapon:ShouldAttack(player)) then
                            local part = pickPart(pchar)
                            if part then
                                local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                                if onScreen and sp.Z > 0 and inViewCone(part.Position) then
                                    local screenDist = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
                                    if screenDist <= aimbotFovRadius then
                                        local wallOK = true
                                        if aimbotWallCheck then
                                            wallOK = hasLOS(part, char)
                                        end
                                        if wallOK then
                                            local score = screenDist
                                            if _aimTarget == player then
                                                score = score * 0.35
                                            end
                                            if score < bestScore then
                                                bestScore = score
                                                best = player
                                                bestPart = part
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if not best or not bestPart then
            _aimTarget = nil
            _aimTargetPart = nil
            return
        end

        _aimTarget = best
        _aimTargetPart = bestPart

        local vel = estimateVelocity(bestPart)
        _aimTargetVelocity = vel
        _aimTargetLastPos = { part = bestPart, pos = bestPart.Position, t = tick() }

        local leadTime = 0.09
        local predicted = bestPart.Position + (vel * leadTime)

        local targetScreen = Camera:WorldToViewportPoint(predicted)
        if not targetScreen then return end

        local rawDX = targetScreen.X - mousePos.X
        local rawDY = targetScreen.Y - mousePos.Y

        local smooth = math.clamp(tonumber(aimbotSmoothness) or 5, 1, 20)
        local factor = 1 / (smooth * 0.35 + 1)

        local dx = rawDX * factor * 0.75 + _aimPrevDeltaX * 0.25
        local dy = rawDY * factor * 0.75 + _aimPrevDeltaY * 0.25

        _aimPrevDeltaX = dx
        _aimPrevDeltaY = dy

        if math.abs(dx) < 0.05 and math.abs(dy) < 0.05 then return end

        if mousemoverel then
            mousemoverel(dx, dy)
        end
    end)
end

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if not hrp or (hum and hum.Health <= 0) then return end
    if ragebotOrKillAura and everyNFrames(3) then
        local n = 0
        for _, player in pairs(Players:GetPlayers()) do
            n = n + 1
            if n > 8 then break end
            if player ~= LocalPlayer and player.Character then
                if antiWeaponEnabled and not AntiWeapon:ShouldAttack(player) then continue end
                local tHrp = player.Character:FindFirstChild("HumanoidRootPart")
                local tHum = player.Character:FindFirstChild("Humanoid")
                if tHrp and tHum and tHum.Health > 0 then
                    tHrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -3)
                    tHrp.AssemblyLinearVelocity = Vector3.zero
                end
            end
        end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
    end
    if flyEnabled then return end
    if heightLockEnabled then
        hrp.CFrame = CFrame.new(hrp.Position.X, lockHeight, hrp.Position.Z)
        return
    end
end)

-- ============================================================================
-- ESP v5 - external esp-lib.lua adapter (team excluded)
-- ============================================================================
local EXTERNAL_ESP_URL = "https://raw.githubusercontent.com/tulontop/esp-lib.lua/refs/heads/main/source.lua"
local externalESP = nil
local externalESPLoadError = nil

local ESP_THEMES = {
    ["Cyber Cyan"] = {
        box = Color3.fromRGB(45, 225, 255),
        name = Color3.fromRGB(225, 250, 255),
        distance = Color3.fromRGB(155, 190, 255),
        health = Color3.fromRGB(65, 255, 165),
        tracer = Color3.fromRGB(170, 95, 255),
        outline = Color3.fromRGB(5, 10, 18),
    },
    ["Violet Pulse"] = {
        box = Color3.fromRGB(185, 85, 255),
        name = Color3.fromRGB(245, 225, 255),
        distance = Color3.fromRGB(210, 150, 255),
        health = Color3.fromRGB(80, 235, 180),
        tracer = Color3.fromRGB(255, 85, 205),
        outline = Color3.fromRGB(12, 5, 20),
    },
    ["Toxic Lime"] = {
        box = Color3.fromRGB(145, 255, 55),
        name = Color3.fromRGB(235, 255, 215),
        distance = Color3.fromRGB(190, 235, 110),
        health = Color3.fromRGB(50, 255, 115),
        tracer = Color3.fromRGB(255, 225, 55),
        outline = Color3.fromRGB(7, 14, 5),
    },
    ["Crimson"] = {
        box = Color3.fromRGB(255, 55, 90),
        name = Color3.fromRGB(255, 225, 230),
        distance = Color3.fromRGB(255, 145, 165),
        health = Color3.fromRGB(255, 185, 55),
        tracer = Color3.fromRGB(255, 80, 40),
        outline = Color3.fromRGB(18, 5, 8),
    },
    ["Clean White"] = {
        box = Color3.fromRGB(240, 245, 255),
        name = Color3.fromRGB(255, 255, 255),
        distance = Color3.fromRGB(185, 195, 215),
        health = Color3.fromRGB(80, 255, 145),
        tracer = Color3.fromRGB(120, 185, 255),
        outline = Color3.fromRGB(0, 0, 0),
    },
}

local function apply_external_theme()
    if not externalESP then return end
    local theme = ESP_THEMES[espThemeName] or ESP_THEMES["Cyber Cyan"]
    externalESP.box.fill = theme.box
    externalESP.box.outline = theme.outline
    externalESP.healthbar.fill = theme.health
    externalESP.healthbar.outline = theme.outline
    externalESP.name.fill = theme.name
    externalESP.distance.fill = theme.distance
    externalESP.tracer.fill = theme.tracer
    externalESP.tracer.outline = theme.outline
end

local function load_external_esp()
    if externalESP then return true end
    if not (game.HttpGet and loadstring) then
        externalESPLoadError = "executor does not expose HttpGet/loadstring"
        return false
    end

    local ok, result = pcall(function()
        local source = game:HttpGet(EXTERNAL_ESP_URL, true)
        assert(type(source) == "string" and #source > 100, "empty ESP source")
        local chunk, compileError = loadstring(source)
        assert(chunk, compileError or "ESP compile failed")
        return chunk()
    end)

    if not ok or type(result) ~= "table" then
        externalESPLoadError = tostring(result)
        return false
    end

    local valid = type(result.box) == "table"
        and type(result.healthbar) == "table"
        and type(result.name) == "table"
        and type(result.distance) == "table"
        and type(result.tracer) == "table"
        and type(result.add_box) == "function"
        and type(result.add_healthbar) == "function"
        and type(result.add_name) == "function"
        and type(result.add_distance) == "function"
        and type(result.add_tracer) == "function"
    if not valid then
        externalESPLoadError = "unsupported esp-lib API"
        return false
    end

    externalESP = result
    return true
end

local function register_external_character(character)
    if not externalESP or not character or character == LocalPlayer.Character then return end

    local player = Players:GetPlayerFromCharacter(character)
    if player and player ~= LocalPlayer and is_teammate(player) then return end

    local root = character:FindFirstChild("HumanoidRootPart")
        or character:FindFirstChild("Torso")
        or character:FindFirstChildWhichIsA("BasePart")
    if not root then
        root = character:WaitForChild("HumanoidRootPart", 8)
    end
    if not root or not character.Parent then return end

    pcall(function() character.PrimaryPart = root end)
    pcall(externalESP.add_box, character)
    pcall(externalESP.add_healthbar, character)
    pcall(externalESP.add_name, character)
    pcall(externalESP.add_distance, character)
    pcall(externalESP.add_tracer, character)
end

local function register_external_player(player)
    if player == LocalPlayer then return end
    if is_teammate(player) then return end

    if player.Character then
        task.spawn(register_external_character, player.Character)
    end
    player.CharacterAdded:Connect(function(character)
        task.spawn(register_external_character, character)
    end)
end

if load_external_esp() then
    externalESP.box.type = "normal"
    externalESP.box.padding = espBoxPadding / 100
    externalESP.name.size = espTextSize
    externalESP.distance.size = math.max(10, espTextSize - 1)
    externalESP.tracer.from = "bottom"
    apply_external_theme()

    externalESP.box.enabled = false
    externalESP.healthbar.enabled = false
    externalESP.name.enabled = false
    externalESP.distance.enabled = false
    externalESP.tracer.enabled = false

    for _, player in ipairs(Players:GetPlayers()) do
        register_external_player(player)
    end
    Players.PlayerAdded:Connect(register_external_player)

    local lastState = {}
    RunService.RenderStepped:Connect(function()
        local boxState = espEnabled and espBoxEnabled
        local nameState = espEnabled and espNameEnabled
        local healthState = espEnabled and espHealthEnabled
        local distanceState = espEnabled and espWeaponEnabled
        local tracerState = espEnabled and espTracer
        local boxType = espSkeleton and "corner" or "normal"

        if lastState.box ~= boxState then externalESP.box.enabled = boxState; lastState.box = boxState end
        if lastState.name ~= nameState then externalESP.name.enabled = nameState; lastState.name = nameState end
        if lastState.health ~= healthState then externalESP.healthbar.enabled = healthState; lastState.health = healthState end
        if lastState.distance ~= distanceState then externalESP.distance.enabled = distanceState; lastState.distance = distanceState end
        if lastState.tracer ~= tracerState then externalESP.tracer.enabled = tracerState; lastState.tracer = tracerState end
        if lastState.boxType ~= boxType then externalESP.box.type = boxType; lastState.boxType = boxType end
        if lastState.theme ~= espThemeName then apply_external_theme(); lastState.theme = espThemeName end
        if lastState.textSize ~= espTextSize then
            externalESP.name.size = espTextSize
            externalESP.distance.size = math.max(10, espTextSize - 1)
            lastState.textSize = espTextSize
        end
        if lastState.padding ~= espBoxPadding then
            externalESP.box.padding = espBoxPadding / 100
            lastState.padding = espBoxPadding
        end
    end)

    nexlib:Notification("External ESP", "esp-lib.lua loaded", 2)
else
    warn("[Cerus ESP] external library load failed: " .. tostring(externalESPLoadError))
    nexlib:Notification("External ESP", "load failed - check executor HTTP", 4)
end

-- ============================================================================
-- ESP Weapon Info Overlay (Bold)
-- ============================================================================
weaponInfoGui = Instance.new("ScreenGui")
weaponInfoGui.Name = "CerusWeaponInfo"
weaponInfoGui.ResetOnSpawn = false
weaponInfoGui.IgnoreGuiInset = true
weaponInfoGui.DisplayOrder = 41
pcall(function() weaponInfoGui.Parent = game:GetService("CoreGui") end)
if not weaponInfoGui.Parent then weaponInfoGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local _weaponInfoEntries = {}
getgenv()._espWiCache = getgenv()._espWiCache or {}
getgenv()._espWiTime = getgenv()._espWiTime or {}

local function esp_get_weapon_text(player)
    local now = tick()
    local _wiCache = getgenv()._espWiCache
    local _wiTime = getgenv()._espWiTime
    local cooldown = 0.5
    if now - (_wiTime[player] or 0) < cooldown then return _wiCache[player] end
    _wiTime[player] = now
    local name, ammoText = nil, nil
    pcall(function()
        local ctrl = FighterController
        if not ctrl then
            local ok, res = pcall(require, LocalPlayer.PlayerScripts.Controllers.FighterController)
            if ok then ctrl = res; FighterController = res end
        end
        if not ctrl then return end
        local fighter
        if type(ctrl.GetFighter) == "function" then fighter = ctrl:GetFighter(player) end
        if not fighter and player == LocalPlayer then fighter = ctrl.LocalFighter end
        if not fighter then return end
        local item = fighter.EquippedItem
        if not item then
            local ch = player.Character
            local tool = ch and ch:FindFirstChildOfClass("Tool")
            if tool then name = tool.Name end
            return
        end
        local function gp(k)
            local o, v = pcall(function()
                if item.Get then return item:Get(k) end
                return item[k] or (item.Data and item.Data[k]) or (item.Info and item.Info[k])
            end)
            if o then return v end
            return nil
        end
        local ammo = gp("CurrentAmmo") or gp("Ammo") or gp("Bullets") or gp("MagazineAmmo")
        local reserve = gp("ReserveAmmo") or gp("StoredAmmo") or gp("Reserve") or gp("TotalAmmo")
        local reloading = gp("Reloading") or gp("IsReloading")
        name = (reloading == true) and "RELOADING" or tostring(item.Name or gp("Name") or "weapon")
        if typeof(ammo) == "number" and typeof(reserve) == "number" then
            ammoText = string.format("%d/%d", math.floor(ammo + 0.5), math.floor(reserve + 0.5))
        elseif typeof(ammo) == "number" then
            ammoText = tostring(math.floor(ammo + 0.5))
        end
    end)
    local result = nil
    if name then
        result = (ammoText and ammoText ~= "") and (name .. "  " .. ammoText) or name
    end
    _wiCache[player] = result
    return result
end

local function create_weapon_info_entry(plr)
    if _weaponInfoEntries[plr] then return end
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = math.max(11, (espTextSize or 13) - 1)
    lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    lbl.TextStrokeTransparency = 0
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.TextYAlignment = Enum.TextYAlignment.Center
    lbl.Size = UDim2.new(0, 240, 0, 16)
    lbl.Visible = false
    lbl.ZIndex = 6
    lbl.Parent = weaponInfoGui

 -- UIStroke ApplyStrokeMode.Border

    _weaponInfoEntries[plr] = lbl
end

local function destroy_weapon_info_entry(plr)
    if _weaponInfoEntries[plr] then
        pcall(function() _weaponInfoEntries[plr]:Destroy() end)
        _weaponInfoEntries[plr] = nil
    end
    if getgenv()._espWiCache then getgenv()._espWiCache[plr] = nil end
    if getgenv()._espWiTime then getgenv()._espWiTime[plr] = nil end
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer and not is_teammate(plr) then
        create_weapon_info_entry(plr)
    end
end
Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer and not is_teammate(plr) then
        create_weapon_info_entry(plr)
    end
end)
Players.PlayerRemoving:Connect(destroy_weapon_info_entry)

local _espLastTextSize = espTextSize
RunService.RenderStepped:Connect(function()
    Camera = workspace.CurrentCamera or Camera

    if _espLastTextSize ~= espTextSize then
        _espLastTextSize = espTextSize
        for _, lbl in pairs(_weaponInfoEntries) do
            lbl.TextSize = math.max(11, (espTextSize or 13) - 1)
        end
    end

    if not (espEnabled and espWeaponInfoEnabled) then
        for _, lbl in pairs(_weaponInfoEntries) do
            if lbl.Visible then lbl.Visible = false end
        end
        return
    end

    local theme = ESP_THEMES[espThemeName] or ESP_THEMES["Cyber Cyan"]

    for plr, lbl in pairs(_weaponInfoEntries) do
        if is_teammate(plr) then
            if lbl.Visible then lbl.Visible = false end
            continue
        end

        local pchar = plr.Character
        local hrp = pchar and pchar:FindFirstChild("HumanoidRootPart")
        local hum = pchar and pchar:FindFirstChildOfClass("Humanoid")
        local head = pchar and (pchar:FindFirstChild("HitboxHead")
            or pchar:FindFirstChild("HitboxHeadSmall")
            or pchar:FindFirstChild("Head"))
        if not (pchar and hrp and hum and head) then
            lbl.Visible = false
            continue
        end
        if hum.Health <= 0 and not espShowDead then
            lbl.Visible = false
            continue
        end

        local headPos = head.Position + Vector3.new(0, head.Size.Y * 0.5, 0)
        local feetPos = hrp.Position - Vector3.new(0, 3, 0)
        local headScreen, headOn = Camera:WorldToViewportPoint(headPos)
        local feetScreen, feetOn = Camera:WorldToViewportPoint(feetPos)

        if not ((headOn or feetOn) and headScreen.Z > 0) then
            lbl.Visible = false
            continue
        end

        local info = esp_get_weapon_text(plr)
        if info and info ~= "" then
            local isDead = hum.Health <= 0
            if isDead then
                lbl.TextColor3 = Color3.fromRGB(160, 160, 160)
            else
                local base = theme.name
                lbl.TextColor3 = Color3.new(
                    math.min(base.R * 1.15 + 0.1, 1),
                    math.min(base.G * 1.15 + 0.1, 1),
                    math.min(base.B * 1.15 + 0.1, 1)
                )
            end
            lbl.Text = info
            lbl.Position = UDim2.fromOffset(feetScreen.X - 120, feetScreen.Y + 3)
            lbl.Visible = true
        else
            lbl.Visible = false
        end
    end
end)

nexlib:Notification("Weapon Info", "ESP weapon info overlay ready (Bold)", 2)
nexlib:Notification("Anti-Weapon", "katana / shield block enabled", 2)

-- ============================================================================
-- Triggerbot
-- ============================================================================
triggerState = { lastFire = 0, fireRate = 0.03, isFiring = false }

local function is_crosshair_enemy()
    local char = LocalPlayer.Character
    if not char then return false end
    _0xd5a5.FilterDescendantsInstances = {char, Camera}
    local result = workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector * 500, _0xd5a5)
    if result and result.Instance then
        local model = result.Instance:FindFirstAncestorOfClass("Model")
        if model and model ~= char then
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local plr = Players:GetPlayerFromCharacter(model)
                if plr and is_teammate(plr) then return false end
                if char:GetAttribute("Immune") == true then return false end
                if plr and get_player_from_part(plr) then return false end
                if plr and get_character(plr) then return false end
                if plr and antiWeaponEnabled and not AntiWeapon:ShouldAttack(plr) then return false end
                return true, model
            end
        end
    end
    return false
end

local function fireWeapon()
    local char = LocalPlayer.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        pcall(function() tool:Activate() end)
        return true
    end
    if mouse1click then
        pcall(mouse1click)
        return true
    end
    if mouse1press and mouse1release then
        pcall(mouse1press)
        task.wait(0.01)
        pcall(mouse1release)
        return true
    end
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.01)
        vim:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end)
    return false
end

-- Elisium-style triggerbot (reaction_time / shoot_delay / team check / StartShooting)
local function _cerusGetLocalFighter()
    local ok, fighter = pcall(function()
        return require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter)
    end)
    if ok and fighter then return fighter end
    return nil
end

local function _cerusTriggerFire()
    -- Prefer Rivals ClientFighter:Input("StartShooting") like Elisium
    local fired = false
    pcall(function()
        local setid = setthreadidentity or setidentity
        if setid then pcall(setid, 2) end
        local modules = LocalPlayer:FindFirstChild("PlayerScripts")
            and LocalPlayer.PlayerScripts:FindFirstChild("Modules")
        if modules then
            local path = modules:FindFirstChild("ClientReplicatedClasses")
            path = path and path:FindFirstChild("ClientFighter")
            -- many builds expose controller via getgenv / cached
        end
        if getgenv()._CerusLocalFighter and getgenv()._CerusLocalFighter.Input then
            getgenv()._CerusLocalFighter:Input("StartShooting")
            fired = true
        end
        if setid then pcall(setid, 7) end
    end)
    if not fired then
        fireWeapon()
    end
end

task.spawn(function()
    while true do
        task.wait(0.03)
        if not triggerbotEnabled then
            triggerbotIsShooting = false
            if triggerState then triggerState.isFiring = false end
        else
            local gameActive = true
            if isrbxactive then pcall(function() gameActive = isrbxactive() end)
            elseif iswindowactive then pcall(function() gameActive = iswindowactive() end) end
            if gameActive and is_crosshair_enemy() then
                -- distance / team gate (Elisium)
                local okTarget = true
                local tpart = silentAimTarget
                if tpart and tpart.Parent then
                    local dist = (tpart.Position - (workspace.CurrentCamera and workspace.CurrentCamera.CFrame.Position or Vector3.zero)).Magnitude
                    if dist > (triggerbotMaxDistance or 500) then okTarget = false end
                    if triggerbotTeamCheck then
                        local model = tpart:FindFirstAncestorOfClass("Model")
                        local plr = model and Players:GetPlayerFromCharacter(model)
                        if plr and is_teammate and is_teammate(plr) then okTarget = false end
                    end
                end
                if okTarget then
                    if not triggerbotIsShooting then
                        task.wait(tonumber(triggerbotReaction) or 0.05)
                        triggerbotIsShooting = true
                    end
                    if triggerbotIsShooting then
                        _cerusTriggerFire()
                        if triggerState then
                            triggerState.isFiring = true
                            triggerState.lastFire = tick()
                        end
                        task.wait(tonumber(triggerbotShootDelay) or 0.1)
                    end
                else
                    triggerbotIsShooting = false
                    if triggerState then triggerState.isFiring = false end
                end
            else
                triggerbotIsShooting = false
                if triggerState then triggerState.isFiring = false end
            end
        end
    end
end)

-- Shader
shaderLighting = game:GetService("Lighting")
shaderBlur = Instance.new("BlurEffect")
shaderBlur.Name = "ShaderBlur"
shaderBlur.Size = 6
shaderColor = Instance.new("ColorCorrectionEffect")
shaderColor.Name = "ShaderColor"
shaderColor.Saturation = -0.35

enable_shader = function()
    _785_562 = {
        Ambient = shaderLighting.Ambient, Brightness = shaderLighting.Brightness,
        OutdoorAmbient = shaderLighting.OutdoorAmbient, ShadowSoftness = shaderLighting.ShadowSoftness,
        TimeOfDay = shaderLighting.TimeOfDay, ColorShift_Top = shaderLighting.ColorShift_Top,
        ColorShift_Bottom = shaderLighting.ColorShift_Bottom
    }
    shaderLighting.Ambient = Color3.fromRGB(94, 99, 188)
    shaderLighting.Brightness = 3.5
    shaderLighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
    shaderLighting.ShadowSoftness = 2.5
    shaderLighting.TimeOfDay = "00:30:00"
    shaderLighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    shaderLighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    shaderBlur.Parent = shaderLighting
    shaderColor.Parent = shaderLighting
end

disable_shader = function()
    if next(_785_562) then
        shaderLighting.Ambient = _785_562.Ambient
        shaderLighting.Brightness = _785_562.Brightness
        shaderLighting.OutdoorAmbient = _785_562.OutdoorAmbient
        shaderLighting.ShadowSoftness = _785_562.ShadowSoftness
        shaderLighting.TimeOfDay = _785_562.TimeOfDay
        shaderLighting.ColorShift_Top = _785_562.ColorShift_Top
        shaderLighting.ColorShift_Bottom = _785_562.ColorShift_Bottom
    end
    shaderBlur.Parent = nil
    shaderColor.Parent = nil
end

RunService.Heartbeat:Connect(function()
    if shaderEnabled ~= a69b44c55 then
        a69b44c55 = shaderEnabled
        if shaderEnabled then enable_shader() else disable_shader() end
    end
end)

-- ============================================================================
-- Wrap Picker UI
-- ============================================================================
task.defer(function()
    task.wait(1)
    local wraps = {}
    for name, cos in pairs(CosmeticLibrary.Cosmetics) do
        if not name:find("MISSING_") and
           (cos.Type == "Wrap" or cos.Type == "Wrapping" or name:lower():find("wrap", 1, true)) then
            table.insert(wraps, name)
        end
    end
    table.sort(wraps)

    local weapons = {}
    for name, _ in pairs(ItemLibrary.Items) do
        if type(name) == "string" and name ~= "" then
            table.insert(weapons, name)
        end
    end
    table.sort(weapons)

    if #wraps == 0 or #weapons == 0 then return end

    local wrapEquipped = getgenv()._wrapEquipped or {}
    getgenv()._wrapEquipped = wrapEquipped

    local function cloneWrap(name)
        local base = CosmeticLibrary.Cosmetics[name]
        if not base then return nil end
        local d = {}
        for k, v in pairs(base) do d[k] = v end
        d.Name = name
        d.Type = d.Type or "Wrap"
        d.Seed = math.random(1, 1000000)
        local ok, enumId = pcall(EnumLibrary.ToEnum, EnumLibrary, name)
        if ok and enumId then d.Enum = enumId; d.ObjectID = d.ObjectID or enumId end
        return d
    end

    local function patch()
        pcall(function()
            local ClientItem = LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem
            local vmModule = ClientItem:FindFirstChild("ClientViewModel")
            if not vmModule then return end
            local VM = require(vmModule)

            if VM.GetWrap and not VM._wrapUIHooked then
                local orig = VM.GetWrap
                VM.GetWrap = function(self)
                    local wname = self.ClientItem and self.ClientItem.Name
                    local wplayer = self.ClientItem and self.ClientItem.ClientFighter
                        and self.ClientItem.ClientFighter.Player
                    if wname and wplayer == LocalPlayer and wrapEquipped[wname] and wrapEquipped[wname].Wrap then
                        return wrapEquipped[wname].Wrap
                    end
                    return orig(self)
                end
                VM._wrapUIHooked = true
            end

            if VM.new and not VM._wrapUINewHooked then
                local origNew = VM.new
                VM.new = function(replicatedData, clientItem)
                    local wplayer = clientItem.ClientFighter and clientItem.ClientFighter.Player
                    local wname = clientItem.Name
                    if wplayer == LocalPlayer and wname and wrapEquipped[wname] and wrapEquipped[wname].Wrap then
                        pcall(function()
                            local RC = require(ReplicatedStorage.Modules.ReplicatedClass)
                            local dk = RC:ToEnum("Data")
                            local wk = RC:ToEnum("Wrap")
                            replicatedData[dk] = replicatedData[dk] or {}
                            replicatedData[dk][wk] = wrapEquipped[wname].Wrap
                        end)
                    end
                    local r = origNew(replicatedData, clientItem)
                    if wplayer == LocalPlayer and wname and wrapEquipped[wname] and wrapEquipped[wname].Wrap
                       and r and r._UpdateWrap then
                        pcall(function() r:_UpdateWrap() end)
                        task.delay(0.1, function()
                            if r and not r._destroyed and r._UpdateWrap then
                                pcall(function() r:_UpdateWrap() end)
                            end
                        end)
                    end
                    return r
                end
                VM._wrapUINewHooked = true
            end
        end)
    end

    local function refresh()
        pcall(function()
            if DataController.CurrentData then
                DataController.CurrentData:Replicate("WeaponInventory")
            end
        end)
    end

    patch()
    task.delay(2, patch)

    local gui = Instance.new("ScreenGui")
    gui.Name = "WrapPickerUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Enabled = false
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 420, 0, 620)
    main.Position = UDim2.new(0.5, -210, 0.5, -310)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Parent = gui

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(128, 213, 247)
    stroke.Thickness = 1.5
    stroke.Parent = main

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    title.BorderSizePixel = 0
    title.Font = Enum.Font.Code
    title.Text = "  Wrap Picker (" .. #wraps .. ")"
    title.TextColor3 = Color3.fromRGB(230, 230, 230)
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = main

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    closeBtn.BorderSizePixel = 0
    closeBtn.Font = Enum.Font.Code
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
    closeBtn.TextSize = 14
    closeBtn.Parent = main
    closeBtn.MouseButton1Click:Connect(function() gui.Enabled = false end)

    local wSearchBox = Instance.new("TextBox")
    wSearchBox.Size = UDim2.new(1, -20, 0, 24)
    wSearchBox.Position = UDim2.new(0, 10, 0, 36)
    wSearchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    wSearchBox.BorderSizePixel = 0
    wSearchBox.Font = Enum.Font.Code
    wSearchBox.PlaceholderText = "Search weapon..."
    wSearchBox.Text = ""
    wSearchBox.TextColor3 = Color3.fromRGB(220, 220, 220)
    wSearchBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
    wSearchBox.TextSize = 13
    wSearchBox.TextXAlignment = Enum.TextXAlignment.Left
    wSearchBox.ClearTextOnFocus = false
    wSearchBox.Parent = main

    local wScroll = Instance.new("ScrollingFrame")
    wScroll.Size = UDim2.new(1, -20, 0, 180)
    wScroll.Position = UDim2.new(0, 10, 0, 64)
    wScroll.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    wScroll.BorderSizePixel = 0
    wScroll.ScrollBarThickness = 4
    wScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    wScroll.Parent = main

    local wLayout = Instance.new("UIListLayout")
    wLayout.Padding = UDim.new(0, 2)
    wLayout.SortOrder = Enum.SortOrder.LayoutOrder
    wLayout.Parent = wScroll

    local wPad = Instance.new("UIPadding")
    wPad.PaddingTop = UDim.new(0, 4)
    wPad.PaddingLeft = UDim.new(0, 4)
    wPad.Parent = wScroll

    local rSearchBox = Instance.new("TextBox")
    rSearchBox.Size = UDim2.new(1, -20, 0, 24)
    rSearchBox.Position = UDim2.new(0, 10, 0, 254)
    rSearchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    rSearchBox.BorderSizePixel = 0
    rSearchBox.Font = Enum.Font.Code
    rSearchBox.PlaceholderText = "Search wrap..."
    rSearchBox.Text = ""
    rSearchBox.TextColor3 = Color3.fromRGB(220, 220, 220)
    rSearchBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
    rSearchBox.TextSize = 13
    rSearchBox.TextXAlignment = Enum.TextXAlignment.Left
    rSearchBox.ClearTextOnFocus = false
    rSearchBox.Parent = main

    local rScroll = Instance.new("ScrollingFrame")
    rScroll.Size = UDim2.new(1, -20, 0, 180)
    rScroll.Position = UDim2.new(0, 10, 0, 282)
    rScroll.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    rScroll.BorderSizePixel = 0
    rScroll.ScrollBarThickness = 4
    rScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    rScroll.Parent = main

    local rLayout = Instance.new("UIListLayout")
    rLayout.Padding = UDim.new(0, 2)
    rLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rLayout.Parent = rScroll

    local rPad = Instance.new("UIPadding")
    rPad.PaddingTop = UDim.new(0, 4)
    rPad.PaddingLeft = UDim.new(0, 4)
    rPad.Parent = rScroll

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -20, 0, 20)
    status.Position = UDim2.new(0, 10, 0, 468)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Code
    status.Text = "Select a weapon and wrap"
    status.TextColor3 = Color3.fromRGB(150, 200, 150)
    status.TextSize = 12
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = main

    local equipBtn = Instance.new("TextButton")
    equipBtn.Size = UDim2.new(1, -20, 0, 32)
    equipBtn.Position = UDim2.new(0, 10, 0, 490)
    equipBtn.BackgroundColor3 = Color3.fromRGB(45, 120, 60)
    equipBtn.BorderSizePixel = 0
    equipBtn.Font = Enum.Font.Code
    equipBtn.Text = "Equip"
    equipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    equipBtn.TextSize = 14
    equipBtn.Parent = main

    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(1, -20, 0, 28)
    clearBtn.Position = UDim2.new(0, 10, 0, 528)
    clearBtn.BackgroundColor3 = Color3.fromRGB(120, 45, 45)
    clearBtn.BorderSizePixel = 0
    clearBtn.Font = Enum.Font.Code
    clearBtn.Text = "Remove selected wrap"
    clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearBtn.TextSize = 13
    clearBtn.Parent = main

    local randomBtn = Instance.new("TextButton")
    randomBtn.Size = UDim2.new(1, -20, 0, 26)
    randomBtn.Position = UDim2.new(0, 10, 0, 562)
    randomBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    randomBtn.BorderSizePixel = 0
    randomBtn.Font = Enum.Font.Code
    randomBtn.Text = "Random wrap"
    randomBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    randomBtn.TextSize = 13
    randomBtn.Parent = main

    local selectedWeapon = nil
    local selectedWrap = nil
    local weaponBtns = {}
    local wrapBtns = {}

    local function updateVisual(btnList, selected)
        for btn, name in pairs(btnList) do
            if btn.Parent then
                if name == selected then
                    btn.BackgroundColor3 = Color3.fromRGB(60, 100, 140)
                else
                    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                end
            end
        end
    end

    local function rebuildWeapons(filterText)
        for _, ch in ipairs(wScroll:GetChildren()) do
            if ch:IsA("TextButton") then ch:Destroy() end
        end
        weaponBtns = {}
        local filter = (filterText or ""):lower()
        local count = 0
        for _, wname in ipairs(weapons) do
            if filter == "" or wname:lower():find(filter, 1, true) then
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(1, -8, 0, 22)
                b.BackgroundColor3 = (wname == selectedWeapon)
                    and Color3.fromRGB(60, 100, 140) or Color3.fromRGB(40, 40, 40)
                b.BorderSizePixel = 0
                b.Font = Enum.Font.Code
                b.Text = "  " .. wname
                b.TextColor3 = Color3.fromRGB(220, 220, 220)
                b.TextSize = 13
                b.TextXAlignment = Enum.TextXAlignment.Left
                b.Parent = wScroll
                weaponBtns[b] = wname
                count = count + 1
                b.MouseButton1Click:Connect(function()
                    selectedWeapon = wname
                    updateVisual(weaponBtns, selectedWeapon)
                    status.Text = "Weapon: " .. wname .. " / Wrap: " .. (selectedWrap or "?")
                end)
            end
        end
        wScroll.CanvasSize = UDim2.new(0, 0, 0, count * 24 + 8)
    end

    local function rebuildWraps(filterText)
        for _, ch in ipairs(rScroll:GetChildren()) do
            if ch:IsA("TextButton") then ch:Destroy() end
        end
        wrapBtns = {}
        local filter = (filterText or ""):lower()
        local count = 0
        for _, rname in ipairs(wraps) do
            if filter == "" or rname:lower():find(filter, 1, true) then
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(1, -8, 0, 22)
                b.BackgroundColor3 = (rname == selectedWrap)
                    and Color3.fromRGB(60, 100, 140) or Color3.fromRGB(40, 40, 40)
                b.BorderSizePixel = 0
                b.Font = Enum.Font.Code
                b.Text = "  " .. rname
                b.TextColor3 = Color3.fromRGB(220, 220, 220)
                b.TextSize = 13
                b.TextXAlignment = Enum.TextXAlignment.Left
                b.Parent = rScroll
                wrapBtns[b] = rname
                count = count + 1
                b.MouseButton1Click:Connect(function()
                    selectedWrap = rname
                    updateVisual(wrapBtns, selectedWrap)
                    status.Text = "Weapon: " .. (selectedWeapon or "?") .. " / Wrap: " .. rname
                end)
            end
        end
        rScroll.CanvasSize = UDim2.new(0, 0, 0, count * 24 + 8)
    end

    rebuildWeapons("")
    rebuildWraps("")

    wSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        rebuildWeapons(wSearchBox.Text)
    end)
    rSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        rebuildWraps(rSearchBox.Text)
    end)

    equipBtn.MouseButton1Click:Connect(function()
        if not selectedWeapon then
            status.Text = "Select weapon first"
            status.TextColor3 = Color3.fromRGB(220, 120, 120)
            return
        end
        if not selectedWrap then
            status.Text = "Select wrap first"
            status.TextColor3 = Color3.fromRGB(220, 120, 120)
            return
        end
        local cw = cloneWrap(selectedWrap)
        if not cw then
            status.Text = "Wrap clone failed"
            status.TextColor3 = Color3.fromRGB(220, 120, 120)
            return
        end
        wrapEquipped[selectedWeapon] = wrapEquipped[selectedWeapon] or {}
        wrapEquipped[selectedWeapon].Wrap = cw

        pcall(function()
            ReplicatedStorage.Remotes.Data.EquipCosmetic:FireServer(selectedWeapon, "Wrap", selectedWrap, {})
        end)
        task.wait(0.1)
        refresh()

        if getgenv().SaveWraps then getgenv().SaveWraps() end

        status.Text = "Equipped: " .. selectedWeapon .. " <- " .. selectedWrap
        status.TextColor3 = Color3.fromRGB(120, 220, 120)
    end)

    clearBtn.MouseButton1Click:Connect(function()
        if not selectedWeapon then
            status.Text = "Select weapon first"
            status.TextColor3 = Color3.fromRGB(220, 120, 120)
            return
        end
        wrapEquipped[selectedWeapon] = wrapEquipped[selectedWeapon] or {}
        wrapEquipped[selectedWeapon].Wrap = nil
        pcall(function()
            ReplicatedStorage.Remotes.Data.EquipCosmetic:FireServer(selectedWeapon, "Wrap", "None", {})
        end)
        task.wait(0.1)
        refresh()
        if getgenv().SaveWraps then getgenv().SaveWraps() end
        status.Text = "Removed from " .. selectedWeapon
        status.TextColor3 = Color3.fromRGB(220, 200, 120)
    end)

    randomBtn.MouseButton1Click:Connect(function()
        if #wraps == 0 then return end
        selectedWrap = wraps[math.random(1, #wraps)]
        rSearchBox.Text = ""
        rebuildWraps("")
        updateVisual(wrapBtns, selectedWrap)
        status.Text = "Random: " .. selectedWrap
        status.TextColor3 = Color3.fromRGB(180, 200, 220)
    end)

    getgenv().OpenWrapPicker = function()
        gui.Enabled = true
    end

    local vmSecWrap = tabs["Visuals"]:Section("wrap picker", 2)
    vmSecWrap:Button("Open Wrap Picker", function()
        gui.Enabled = true
    end)
    vmSecWrap:Button("Auto-Equip Random to ALL", function()
        if #wraps == 0 then return end
        for _, wname in ipairs(weapons) do
            local pick = wraps[math.random(1, #wraps)]
            local cw = cloneWrap(pick)
            if cw then
                wrapEquipped[wname] = wrapEquipped[wname] or {}
                wrapEquipped[wname].Wrap = cw
            end
        end
        refresh()
        if getgenv().SaveWraps then getgenv().SaveWraps() end
        nexlib:Notification("Wrap", #weapons .. " weapons wrapped", 2)
    end)

    print("[WrapUI] ready - getgenv().OpenWrapPicker()")
end)


pcall(function()
    _YokaiWindow:SetTab(1)
end)
pcall(function()
    Library:Init()
end)
Library:Notify({Message = "Cerus Premium | Yokai Sense — full features", Delay = 5})
print("[Cerus Premium] Yokai Sense UI bridge loaded — Main/Combat/Visuals/Misc/UI Settings")
