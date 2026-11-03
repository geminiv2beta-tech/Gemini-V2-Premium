-- ----------------------------------------------------
-- V.Roy Hub - Semantic cleanup pass
-- Core UI wrapper and main functions renamed
-- Remaining inner locals kept for stability
-- ----------------------------------------------------
tick()
local function shouldSuppressNotify()
    if type(getgenv) == "function" then
        local v1, v2 = pcall(getgenv)
        if v1 and type(v2) == "table" and v2.VroySilent == false then
            return false
        end
    end
    return true
end
local Library = loadstring(
    game:HttpGet("https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/Library.lua"),
    "LinoriaLib"
)()
assert(type(Library) == "table", "[VroyLinoria] no cargo Linoria (revise red/executor)")
local safePcall = pcall
safePcall(
    function()
        Library.BackgroundColor = Color3.fromRGB(0, 0, 0)
        Library.MainColor = Color3.fromRGB(16, 16, 16)
        Library.AccentColor = Color3.fromRGB(255, 255, 255)
        Library.OutlineColor = Color3.fromRGB(128, 128, 128)
        Library.FontColor = Color3.fromRGB(255, 255, 255)
        if type(Library.GetDarkerColor) == "function" then
            Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor)
        end
    end
)
safePcall(
    function()
        Library.ShowCustomCursor = false
    end
)
local savedElements = {}
local num = 0
local function registerElement(arg1)
    num = num + 1
    arg1.Id = num
    savedElements[#savedElements + 1] = arg1
    return arg1
end
local flag = false
local VroyUI = {}
VroyUI.Notify = function(_, arg2)
    local v2 = arg2 or {}
    if shouldSuppressNotify() then
        return
    end
    pcall(
        function()
            Library:Notify(
                tostring(v2.Title or "V.Roy Hub") .. ": " .. tostring(v2.Text or v2.Content or "")
            )
        end
    )
end
VroyUI.Theme = function(_, _) end
VroyUI.Style = function(_, _) end
VroyUI.GetElements = function(_)
    return savedElements
end
local function normalizeName(arg1, _)
    if arg1.Name ~= nil and type(arg1.Name) ~= "string" then
        arg1.Name = "Item"
    end
end
local function makeControlWrapper(arg1)
    local tbl = {}
    local num = 0
    local function func()
        num = num + 1
        return num
    end
    tbl.AddToggle = function(_, arg2, arg3, arg4)
        local v1
        if type(arg2) == "table" then
            v1 = arg2
        elseif type(arg3) == "table" then
            v1 = arg3
            if v1.Name == nil then
                v1.Name = arg2
            end
        elseif type(arg3) == "function" then
            v1 = {Name = arg2, Callback = arg3}
        else
            v1 = {Name = arg2, Default = arg3, Callback = arg4}
        end
        normalizeName(v1, "AddToggle")
        local tbl = {value = v1.Default == true}
        local v2 = ("VRLT%d_%s"):format(func(), tostring(v1.Name or "t"):gsub("[^%w ]", "_"))
        local v3, v4 = pcall(
            function()
                return arg1:AddToggle(
                    v2,
                    {
                        Text = v1.Name or "Toggle", Default = tbl.value,
                        Callback = function(arg1)
                            tbl.value = arg1 == true
                            if not flag and type(v1.Callback) == "function" then
                                pcall(v1.Callback, tbl.value)
                            end
                        end,
                    }
                )
            end
        )
        if not v3 or type(v4) ~= "table" then
            return {
                Control = true,
                GetValue = function()
                    return tbl.value
                end,
                SetValue = function(_, arg2)
                    tbl.value = arg2 == true
                end, Callback = v1.Callback,
            }
        end
        local function func3(arg1)
            tbl.value = arg1 == true
            flag = true
            pcall(
                function()
                    v4:SetValue(tbl.value)
                end
            )
            flag = false
        end
        if not (v1.NoSave or v1.IgnoreConfig) then
            registerElement(
                {
                    GetValue = function()
                        return tbl.value
                    end, SetValue = func3, Callback = v1.Callback,
                }
            )
        end
        return {
            Control = true,
            GetValue = function()
                return tbl.value
            end,
            SetValue = function(_, arg2)
                func3(arg2)
            end, Callback = v1.Callback,
        }
    end
    tbl.AddSlider = function(_, arg2, arg3, arg4, arg5, arg6)
        local v1
        if type(arg2) == "table" then
            v1 = arg2
        elseif type(arg3) == "table" then
            v1 = arg3
            if v1.Name == nil then
                v1.Name = arg2
            end
        else
            v1 = {Name = arg2, Min = arg3, Max = arg4, Default = arg5, Callback = arg6}
        end
        local tbl = {value = tonumber(v1.Default) or tonumber(v1.Min) or 0}
        local v2 = tonumber(v1.Step) or 1
        local num = 0
        if v2 < 1 then
            if v2 < 0.01 then
                num = 3
            elseif v2 < 0.1 then
                num = 2
            else
                num = 1
            end
        end
        local v3 = ("VRLS%d_%s"):format(func(), tostring(v1.Name or "s"):gsub("[^%w ]", "_"))
        local v4, v5 = pcall(
            function()
                return arg1:AddSlider(
                    v3,
                    {
                        Text = v1.Name or "Slider", Default = tbl.value,
                        Min = tonumber(v1.Min) or 0, Max = tonumber(v1.Max) or 100, Rounding = num,
                        Suffix = v1.Suffix or "",
                        Callback = function(arg1)
                            tbl.value = tonumber(arg1) or tbl.value
                            if not flag and type(v1.Callback) == "function" then
                                pcall(v1.Callback, tbl.value)
                            end
                        end,
                    }
                )
            end
        )
        if not v4 or type(v5) ~= "table" then
            return {
                Control = true,
                GetValue = function()
                    return tbl.value
                end,
                SetValue = function(_, arg2)
                    tbl.value = tonumber(arg2) or tbl.value
                end,
            }
        end
        local function func2(arg1)
            tbl.value = tonumber(arg1) or tbl.value
            flag = true
            pcall(
                function()
                    v5:SetValue(tbl.value)
                end
            )
            flag = false
        end
        if not (v1.NoSave or v1.IgnoreConfig) then
            func1(
                {
                    GetValue = function()
                        return tbl.value
                    end, SetValue = func2, Callback = v1.Callback,
                }
            )
        end
        return {
            Control = true,
            GetValue = function()
                return tbl.value
            end,
            SetValue = function(_, arg2)
                func2(arg2)
            end,
        }
    end
    tbl.AddDropdown = function(_, arg2, arg3)
        local v1
        if type(arg2) == "table" then
            v1 = arg2
        else
            v1 = arg3 or {}
            if v1.Name == nil then
                v1.Name = arg2
            end
        end
        local v2 = v1.MultipleOptions == true
        local tbl = {}
        tbl.value = nil
        local Default = v1.Default
        if type(Default) == "table" then
            tbl.value = v2 and Default or Default[1]
        else
            tbl.value = Default
        end
        if tbl.value == nil and type(v1.Options) == "table" then
            tbl.value = v2 and {} or v1.Options[1]
        end
        local v3 = ("VRLD%d_%s"):format(func(), tostring(v1.Name or "d"):gsub("[^%w ]", "_"))
        local v4, v5 = pcall(
            function()
                return arg1:AddDropdown(
                    v3,
                    {
                        Text = v1.Name or "Dropdown", Values = v1.Options or {},
                        Default = tbl.value, Multi = v2,
                        Callback = function(arg1)
                            if v2 then
                                tbl.value = arg1
                            else
                                tbl.value = type(arg1) == "table" and arg1[1] or arg1
                            end
                            if not flag and type(v1.Callback) == "function" then
                                pcall(v1.Callback, tbl.value)
                            end
                        end,
                    }
                )
            end
        )
        if not v4 or type(v5) ~= "table" then
            return {
                Control = true,
                GetValue = function()
                    return tbl.value
                end,
                SetValue = function(_, arg2)
                    tbl.value = arg2
                end,
            }
        end
        local function func2(arg1)
            if v2 then
                tbl.value = arg1
            else
                tbl.value = type(arg1) == "table" and arg1[1] or arg1
            end
            flag = true
            pcall(
                function()
                    v5:SetValue(tbl.value)
                end
            )
            flag = false
        end
        if not (v1.NoSave or v1.IgnoreConfig) then
            func1(
                {
                    GetValue = function()
                        return tbl.value
                    end, SetValue = func2, Callback = v1.Callback,
                }
            )
        end
        return {
            Control = true,
            GetValue = function()
                return tbl.value
            end,
            SetValue = function(_, arg2)
                func2(arg2)
            end,
            SetOptions = function(_, arg2)
                if type(arg2) ~= "table" then
                    return
                end
                v1.Options = arg2
                pcall(
                    function()
                        if type(v5.SetValues) == "function" then
                            v5:SetValues(arg2)
                        end
                    end
                )
            end,
        }
    end
    tbl.AddButton = function(_, arg2, arg3)
        local v1
        if type(arg2) == "table" then
            v1 = arg2
        else
            v1 = {Name = arg2, Callback = arg3}
        end
        local tbl = {Control = true, _label = v1.Name or "Button"}
        tbl._sx = nil
        tbl.SetText = function(_, arg2)
            tbl._label = tostring(arg2)
            pcall(
                function()
                    if tbl._sx and type(tbl._sx.SetText) == "function" then
                        tbl._sx:SetText(tbl._label)
                    end
                end
            )
        end
        pcall(
            function()
                tbl._sx = arg1:AddButton(
                    {
                        Text = tbl._label,
                        Func = function()
                            if type(v1.Callback) == "function" then
                                pcall(v1.Callback, tbl)
                            end
                        end,
                    }
                )
            end
        )
        return tbl
    end
    tbl.AddLabel = function(_, arg2)
        local str = ""
        if type(arg2) == "table" then
            str = tostring(arg2.Text or arg2.Name or "")
        elseif type(arg2) == "string" then
            str = arg2
        end
        if str == "" then
            str = " "
        end
        local v1
        pcall(
            function()
                v1 = arg1:AddLabel(str)
            end
        )
        local tbl1 = {Control = true, _text = str, _sx = v1}
        tbl1.SetText = function(_, arg2)
            tbl1._text = tostring(arg2)
            pcall(
                function()
                    if v1 and type(v1.SetText) == "function" then
                        v1:SetText(tbl1._text)
                    end
                end
            )
        end
        setmetatable(tbl1, {__index = tbl})
        return tbl1
    end
    tbl.AddInput = function(_, arg2, arg3)
        local v1 = arg3 or {}
        if type(arg2) == "table" and (v1 == nil or type(v1) == "table" and next(v1) == nil) then
            v1 = arg2
            arg2 = v1.Name
        elseif type(arg2) == "string" and type(v1) == "table" and v1.Name == nil then
            v1.Name = arg2
        end
        local tbl = {value = tostring(v1.Default or v1.CurrentValue or "")}
        local v2 = ("VRLI%d_%s"):format(func(), tostring(arg2 or "i"):gsub("[^%w ]", "_"))
        pcall(
            function()
                arg1:AddInput(
                    v2,
                    {
                        Text = arg2 or (v1.Name or "Input"), Default = tbl.value,
                        Numeric = v1.Numeric,
                        Placeholder = v1.Placeholder or v1.PlaceholderText or "",
                        Callback = function(arg1)
                            tbl.value = tostring(arg1)
                            if type(v1.Callback) == "function" then
                                pcall(v1.Callback, tbl.value)
                            end
                        end,
                    }
                )
            end
        )
        if not (v1.NoSave or v1.IgnoreConfig) then
            func1(
                {
                    GetValue = function()
                        return tbl.value
                    end,
                    SetValue = function(arg1)
                        tbl.value = tostring(arg1)
                    end, Callback = v1.Callback,
                }
            )
        end
        return {
            Control = true,
            GetValue = function()
                return tbl.value
            end,
        }
    end
    tbl.AddKeybind = function(_, arg2)
        local v1 = arg2 or {}
        local v2 = v1.Name or "Keybind"
        local tbl = {
            key = (function(arg1)
                if type(arg1) == "string" then
                    return arg1
                end
                local v1, v2 = pcall(
                    function()
                        return arg1.Name
                    end
                )
                if v1 and type(v2) == "string" and v2 ~= "" then
                    return v2
                end
                return "Unknown"
            end)(v1.Key or v1.CurrentValue),
        }
        local v3 = ("VRLK%d_%s"):format(func(), tostring(v2):gsub("[^%w ]", "_"))
        local v4
        pcall(
            function()
                v4 = arg1:AddLabel(v2)
            end
        )
        if type(v4) == "table" then
            local key = tbl.key
            if key == "Unknown" then
                key = "Unknown"
            end
            pcall(
                function()
                    if type(v4.AddKeyPicker) == "function" then
                        v4:AddKeyPicker(
                            v3,
                            {
                                Default = key, Mode = "Toggle", Text = v2,
                                ChangedCallback = function(arg1)
                                    local v1, v2 = pcall(
                                        function()
                                            if type(arg1) == "string" then
                                                return arg1
                                            end
                                            return arg1.Name
                                        end
                                    )
                                    if v1 and type(v2) == "string" and v2 ~= "" then
                                        tbl.key = v2
                                    end
                                end,
                            }
                        )
                    end
                end
            )
        end
        return {
            Control = true,
            GetValue = function()
                local key = tbl.key
                if type(key) == "string" and Enum.KeyCode[key] then
                    return Enum.KeyCode[key]
                end
                return nil
            end,
        }
    end
    return tbl
end
VroyUI.CreateWindow = function(_, arg2)
    local v2 = Library:CreateWindow(
        {
            Title = (arg2 or {}).Title or "V.Roy Hub", Center = true, AutoShow = true,
            Resizable = true, ShowCustomCursor = false,
        }
    )
    pcall(
        function()
            if v2 and type(v2.SetBackgroundImage) == "function" and true then
                v2:SetBackgroundImage("115806621988945")
            end
        end
    )
    return {
        Resize = function(_, _, _) end,
        AddTab = function(_, arg2)
            local v1 = arg2
            if type(arg2) == "table" then
                v1 = arg2.Name
            end
            local v3 = v2:AddTab(v1 or "Tab")
            local tbl = {__side = 0}
            tbl._raw = v3
            tbl.AddSection = function(_, arg2)
                if type(arg2) == "table" then
                    arg2 = arg2.Name
                end
                tbl.__side = tbl.__side % 2 + 1
                local v1
                pcall(
                    function()
                        if tbl.__side == 1 then
                            v1 = v3:AddLeftGroupbox(arg2 or "Section")
                        else
                            v1 = v3:AddRightGroupbox(arg2 or "Section")
                        end
                    end
                )
                assert(
                    type(v1) == "table", "[VroyLinoria] Groupbox nil en '" .. tostring(arg2) .. "'"
                )
                task.wait()
                return (makeControlWrapper(v1))
            end
            local v5
            local function func()
                v5 = v5 or tbl:AddSection("General")
                return v5
            end
            for _, v4 in ipairs(
                {"AddToggle", "AddSlider", "AddDropdown", "AddButton", "AddLabel", "AddInput", "AddKeybind"}
            ) do
                tbl[v4] = function(_, ...)
                    local v1 = func()
                    return v1[v4](v1, ...)
                end
            end
            return tbl
        end,
    }
end
local Window = VroyUI:CreateWindow(
    {
        Title = "V.Roy Hub HvH", Subtitle = "", StatusText = "", RestoreButtonText = "V.Roy Hub",
        Keybind = Enum.KeyCode.RightControl,
    }
)
local genv = type(getgenv) == "function" and getgenv() or _G
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerTab = Window:AddTab("Player")
local ExploitsSection = PlayerTab:AddSection("Exploits")
genv.NoClipEnabled = false
genv.AutoFarmEnabled = false
local tbl2 = {esp = setmetatable({}, {__mode = "k"}), cam = setmetatable({}, {__mode = "k"})}
genv.TeleportToEnemy = false
local function getClosestEnemy(arg1)
    local Character = LocalPlayer.Character
    local v1 = Character and Character:FindFirstChild("HumanoidRootPart")
    if not v1 then
        return nil
    end
    local v3
    local huge = math.huge
    for _, v2 in ipairs(Players:GetPlayers()) do
        if v2 ~= LocalPlayer and v2.Character then
            local Humanoid = v2.Character:FindFirstChildOfClass("Humanoid")
            local HumanoidRootPart = v2.Character:FindFirstChild("HumanoidRootPart")
            if Humanoid and Humanoid.Health > 0 and HumanoidRootPart then
                local Magnitude = (HumanoidRootPart.Position - v1.Position).Magnitude
                if Magnitude < huge and (not arg1 or Magnitude <= arg1) then
                    huge = Magnitude
                    v3 = HumanoidRootPart
                end
            end
        end
    end
    return v3
end
local connection
local function toggleTeleportToEnemy(arg1)
    if arg1 and not connection then
        connection = RunService.Heartbeat:Connect(
            function()
                local v1 = getClosestEnemy(genv.TeleportRange or 500)
                if not v1 then
                    return
                end
                local Character = LocalPlayer.Character
                local v2 = Character and Character:FindFirstChild("HumanoidRootPart")
                if v2 then
                    v2.CFrame = CFrame.new(v2.Position, v1.Position)
                end
            end
        )
    elseif not arg1 and connection then
        connection:Disconnect()
        connection = nil
    end
end
ExploitsSection:AddSlider(
    {
        Name = "Teleport Range", Min = 50, Max = 5000, Step = 50, Default = 500, Suffix = "",
        Callback = function(arg1)
            genv.TeleportRange = arg1
        end,
    }
)
ExploitsSection:AddToggle(
    {
        Name = "Teleport to Enemy", Default = false,
        Callback = function(arg1)
            genv.TeleportToEnemy = arg1 == true
            toggleTeleportToEnemy(genv.TeleportToEnemy)
        end,
    }
)
RunService.Stepped:Connect(
    function()
        toggleTeleportToEnemy(genv.TeleportToEnemy == true)
        if not genv.NoClipEnabled then
            return
        end
        local Character = LocalPlayer.Character
        if not Character then
            return
        end
        local Descendants = Character:GetDescendants()
        for i = 1, #Descendants do
            local v1 = Descendants[i]
            if v1:IsA("BasePart") and v1.CanCollide then
                v1.CanCollide = false
            end
        end
    end
)
ExploitsSection:AddToggle(
    {
        Name = "No Clip", Default = false,
        Callback = function(arg1)
            genv.NoClipEnabled = arg1
        end,
    }
)
Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
RunService = game:GetService("RunService")
local LocalPlayer1 = Players.LocalPlayer
local tbl3 = {SlideKey = Enum.KeyCode.C, MinSpeed = 5, MaxSpeed = 120, Boost = 1.4, Nudge = 0.5}
local flag1 = false
local function func6()
    local Character = LocalPlayer1.Character
    return Character and Character:FindFirstChild("HumanoidRootPart")
end
local function func7()
    if not UserInputService:IsKeyDown(tbl3.SlideKey) then
        return false
    end
    local v1 = func6()
    if not v1 then
        return false
    end
    local AssemblyLinearVelocity = v1.AssemblyLinearVelocity
    return Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude >= tbl3.MinSpeed
end
ExploitsSection:AddToggle(
    "Inf Slide (Spam button)",
    function(arg1)
        flag1 = arg1 == true
    end
)
RunService.RenderStepped:Connect(
    function()
        if not flag1 or not func7() then
            return
        end
        local v1 = func6()
        if not v1 then
            return
        end
        local AssemblyLinearVelocity = v1.AssemblyLinearVelocity
        local vector3 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z)
        local Magnitude = vector3.Magnitude
        if Magnitude < tbl3.MinSpeed then
            return
        end
        local v2 = vector3 / Magnitude
        v1.AssemblyLinearVelocity = v2 * math.min(Magnitude * tbl3.Boost, tbl3.MaxSpeed) + Vector3.new(
            0, AssemblyLinearVelocity.Y, 0
        )
        if tbl3.Nudge > 0 then
            v1.CFrame = v1.CFrame + v2 * tbl3.Nudge
        end
    end
)
UserInputService = game:GetService("UserInputService")
Players = game:GetService("Players")
LocalPlayer1 = Players.LocalPlayer
local function func8()
    local Character = LocalPlayer1.Character
    return Character and Character:FindFirstChildWhichIsA("Humanoid")
end
local flag2 = false
ExploitsSection:AddToggle(
    "Infinite Jump",
    function(arg1)
        flag2 = arg1 == true
        return true
    end
)
UserInputService.JumpRequest:Connect(
    function()
        if flag2 then
            local v1 = func8()
            if v1 then
                v1:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
)
RunService = game:GetService("RunService")
local num1 = 0.1
local connection1
local function func9()
    if connection1 then
        return
    end
    connection1 = RunService.Stepped:Connect(
        function()
            local Character = LocalPlayer1.Character
            if not Character then
                return
            end
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            local Humanoid = Character:FindFirstChild("Humanoid")
            if HumanoidRootPart and Humanoid then
                local MoveDirection = Humanoid.MoveDirection
                if MoveDirection.Magnitude > 0 then
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + MoveDirection * num1
                end
            end
        end
    )
end
local function func10()
    if connection1 then
        connection1:Disconnect()
        connection1 = nil
    end
end
ExploitsSection:AddToggle(
    "CFrame Speed v2",
    function(arg1)
        if arg1 == true then
            func9()
        else
            func10()
        end
        return true
    end
)
ExploitsSection:AddSlider(
    "Multiplier", 0.1, 2, 0.1,
    function(arg1)
        num1 = arg1
    end
)
local v7 = v5:AddSection("Movement")
local flag3 = false
local num2 = 5
local v29
local v30
local flag4 = false
local flag5 = false
local function func11()
    if v29 then
        v29:Destroy()
        v29 = nil
    end
    if v30 then
        v30:Destroy()
        v30 = nil
    end
    local v1 = func8()
    if v1 then
        v1.PlatformStand = false
    end
end
local PlayerGui = LocalPlayer1:WaitForChild("PlayerGui")
local frame = Instance.new("Frame")
frame.Name = "FlyControls"
frame.Size = UDim2.fromOffset(106, 48)
frame.Position = UDim2.new(1, -120, 1, -70)
frame.BackgroundTransparency = 1
frame.Visible = false
frame.ZIndex = 100
frame.Parent = PlayerGui
local function func12(arg1, arg2)
    local textButton = Instance.new("TextButton")
    textButton.Size = UDim2.fromOffset(48, 48)
    textButton.Position = UDim2.fromOffset(arg2, 0)
    textButton.BackgroundColor3 = Color3.fromRGB(28, 39, 65)
    textButton.BackgroundTransparency = 0.18
    textButton.BorderSizePixel = 0
    textButton.Text = arg1
    textButton.TextColor3 = Color3.fromRGB(246, 248, 252)
    textButton.Font = Enum.Font.FredokaOne
    textButton.TextSize = 20
    textButton.AutoButtonColor = false
    textButton.ZIndex = 101
    textButton.Parent = frame
    Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 10)
    return textButton
end
local v8 = func12("▲", 0)
local v9 = func12("▼", 58)
v8.InputBegan:Connect(
    function(arg1)
        if arg1.UserInputType == Enum.UserInputType.Touch or arg1.UserInputType == Enum.UserInputType.MouseButton1 then
            flag4 = true
        end
    end
)
v8.InputEnded:Connect(
    function(arg1)
        if arg1.UserInputType == Enum.UserInputType.Touch or arg1.UserInputType == Enum.UserInputType.MouseButton1 then
            flag4 = false
        end
    end
)
v9.InputBegan:Connect(
    function(arg1)
        if arg1.UserInputType == Enum.UserInputType.Touch or arg1.UserInputType == Enum.UserInputType.MouseButton1 then
            flag5 = true
        end
    end
)
v9.InputEnded:Connect(
    function(arg1)
        if arg1.UserInputType == Enum.UserInputType.Touch or arg1.UserInputType == Enum.UserInputType.MouseButton1 then
            flag5 = false
        end
    end
)
local function func13(arg1)
    flag3 = arg1 == true
    frame.Visible = flag3 and UserInputService.TouchEnabled
    if not flag3 then
        func11()
    end
end
RunService.Heartbeat:Connect(
    function()
        if not flag3 then
            if v29 or v30 then
                func11()
            end
            return
        end
        local v1 = func8()
        local Character = LocalPlayer1.Character
        local v2 = Character and Character:FindFirstChild("HumanoidRootPart")
        local CurrentCamera = workspace.CurrentCamera
        if not (v1 and v2 and CurrentCamera) then
            func11()
            return
        end
        if not v29 or v29.Parent ~= v2 then
            func11()
            v29 = Instance.new("BodyGyro")
            local v3 = v29
            v3.Name = "FlyGyro"
            v3.P = 12000
            v3.MaxTorque = Vector3.new(9000000000, 9000000000, 9000000000)
            v3.Parent = v2
            v30 = Instance.new("BodyVelocity")
            local v4 = v30
            v4.Name = "FlyVelocity"
            v4.P = 15000
            v4.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
            v4.Parent = v2
        end
        local v5 = 160 + (math.clamp(num2, 1, 30) - 1) * 24
        local zero = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            zero = zero + CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            zero = zero - CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            zero = zero + CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            zero = zero - CurrentCamera.CFrame.RightVector
        end
        if zero.Magnitude < 0.05 and v1.MoveDirection.Magnitude > 0.05 then
            zero = v1.MoveDirection
        end
        if zero.Magnitude > 0 then
            zero = zero.Unit
        end
        local num = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or v1.Jump or flag4 then
            num = 1
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or flag5 then
            num = -1
        end
        v1.PlatformStand = true
        local v6 = v29
        v6.MaxTorque = Vector3.new(9000000000, 9000000000, 9000000000)
        v6.CFrame = CurrentCamera.CFrame
        v30.Velocity = zero * v5 + Vector3.new(0, num * v5, 0)
    end
)
v7:AddToggle(
    "Fly", false,
    function(arg1)
        func13(arg1)
        return true
    end
)
v7:AddSlider(
    "Fly Speed", 1, 30, num2,
    function(arg1)
        num2 = arg1
    end
)
local v10 = v3:AddTab("Combat")
local v11 = v10:AddSection("Best Silent Aim")
local flag6 = false
local tbl4 = {}
local v31
local tbl5 = {}
local v12
local function func14()
    if flag6 then
        return true
    end
    if game.GameId ~= 6035872082 then
        return false
    end
    if type(hookmetamethod) ~= "function" then
        return false
    end
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local v1, v2 = pcall(require, ReplicatedStorage.Modules.ItemLibrary)
    if not v1 or type(v2) ~= "table" or type(v2.Items) ~= "table" then
        return false
    end
    local Items = v2.Items
    local LocalPlayer = Players.LocalPlayer
    local CurrentCamera = Workspace.CurrentCamera
    local new = Vector2.new
    local WorldToViewportPoint = CurrentCamera.WorldToViewportPoint
    local byte = string.byte
    local v3 = checkcaller or function()
        return false
    end
    local v4 = newcclosure or function(arg1)
        return arg1
    end
    local v9
    local tbl = {Sniper = false, Crossbow = false, Bow = true, RPG = true}
    local tbl1 = {ShootCooldown = 0.05, ShootBurstCooldown = 0.05}
    local tbl2 = {ShootSpread = 0, ShootAccuracy = 0, ShootRecoil = 0}
    for k, v5 in pairs(Items) do
        if typeof(v5) == "table" and not tbl[k] then
            for k1, v6 in pairs(tbl2) do
                if v5[k1] then
                    table.insert(tbl5, {data = v5, key = k1, value = v5[k1]})
                    v5[k1] = v6
                end
            end
            for k2, v7 in pairs(tbl1) do
                if v5[k2] then
                    table.insert(tbl5, {data = v5, key = k2, value = v5[k2]})
                    v5[k2] = v7
                end
            end
        end
    end
    local function func(arg1)
        return byte(arg1 or "\0")
    end
    local function func1(_, _)
        return true
    end
    local function func2(arg1, arg2)
        local Character = arg1.Character
        if not Character then
            return false
        end
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local Head = Character:FindFirstChild("Head")
        if not (Humanoid and Head and Humanoid.Health > 0) then
            return false
        end
        if (Head.Position - arg2).Magnitude > 1000 then
            return false
        end
        local Attribute = LocalPlayer:GetAttribute("EnvironmentID")
        local Attribute1 = arg1:GetAttribute("EnvironmentID")
        if Attribute and Attribute1 and func(Attribute) ~= func(Attribute1) then
            return false
        end
        local Attribute2 = LocalPlayer:GetAttribute("TeamID")
        local Attribute3 = arg1:GetAttribute("TeamID")
        if Attribute2 and Attribute3 and func(Attribute2) == func(Attribute3) then
            return false
        end
        return (func1(Head, arg2))
    end
    table.insert(
        tbl4,
        RunService.Heartbeat:Connect(
            function()
                CurrentCamera = Workspace.CurrentCamera
                local Position = CurrentCamera.CFrame.Position
                local v5
                local huge = math.huge
                local v1 = CurrentCamera.ViewportSize / 2
                for _, v2 in Players:GetPlayers() do
                    if v2 ~= LocalPlayer and func2(v2, Position) then
                        local v3, v4 = WorldToViewportPoint(
                            CurrentCamera, v2.Character.Head.Position
                        )
                        if v4 then
                            local Magnitude = (new(v3.X, v3.Y) - v1).Magnitude
                            if Magnitude < huge then
                                huge = Magnitude
                                v5 = v2
                            end
                        end
                    end
                end
                v9 = v5 and v5.Character.Head.Position or nil
            end
        )
    )
    local v8
    v8 = hookmetamethod(
        game, "__index",
        v4(
            function(arg1, arg2, ...)
                if v9 and not v3() and arg2 == "ViewportSize" and arg1 == CurrentCamera then
                    local v1, v2 = WorldToViewportPoint(arg1, v9)
                    if v2 then
                        return new(v1.X * 2, v1.Y * 2)
                    end
                end
                return v8(arg1, arg2, ...)
            end
        )
    )
    v31 = v8
    flag6 = true
    return true
end
local function func15()
    for i = #tbl4, 1, -1 do
        tbl4[i]:Disconnect()
        tbl4[i] = nil
    end
    for i1 = #tbl5, 1, -1 do
        local v1 = tbl5[i1]
        v1.data[v1.key] = v1.value
        tbl5[i1] = nil
    end
    if v31 then
        pcall(hookmetamethod, game, "__index", v31)
        v31 = nil
    end
    flag6 = false
end
v12 = v11:AddToggle(
    "Silent Aim + Gun Mods",
    function(arg1)
        if not arg1 then
            func15()
            return
        end
        if not func14() and v12 then
            v12:SetValue(false)
        end
    end
)
local v13 = v10:AddSection("Camera Aim")
v13:AddLabel("Hold LEFT or RIGHT CLICK to aim.")
v4.CameraAimEnabled = false
v4.CameraAimSpeed = 35
v4.CameraIgnoreFOV = true
v4.CameraFOVRadius = 282
v4.CameraShowFOV = false
v4.CameraAimPart = "Auto"
v13:AddToggle(
    {
        Name = "Enable Camera Aim", Default = false,
        Callback = function(arg1)
            v4.CameraAimEnabled = arg1 == true
        end,
    }
)
v13:AddSlider(
    {
        Name = "Aim Speed", Min = 1, Max = 100, Default = 35, Step = 1, Suffix = "",
        Callback = function(arg1)
            v4.CameraAimSpeed = tonumber(arg1) or 35
        end,
    }
)
v13:AddToggle(
    {
        Name = "Ignore FOV", Default = false,
        Callback = function(arg1)
            v4.CameraIgnoreFOV = arg1 == true
        end,
    }
)
v13:AddSlider(
    {
        Name = "FOV Radius", Min = 25, Max = 500, Default = 282, Step = 1, Suffix = "",
        Callback = function(arg1)
            v4.CameraFOVRadius = tonumber(arg1) or 282
        end,
    }
)
v13:AddToggle(
    {
        Name = "Show FOV", Default = false,
        Callback = function(arg1)
            v4.CameraShowFOV = arg1 == true
        end,
    }
)
v13:AddDropdown(
    {
        Name = "Aim Part",
        Options = {
            "Auto", "Head", "Torso", "Humanrootpart", "Leftarm", "Rightarm", "Leftleg", "Rightleg",
            "Random"
        }, Default = "Auto",
        Callback = function(arg1)
            local v1 = arg1
            if type(arg1) == "table" then
                v1 = arg1[1]
            end
            v4.CameraAimPart = tostring(v1 or "Auto")
        end,
    }
)
local v14 = v13:AddLabel("Status: OFF")
local v32
local flag7 = false
local flag8 = false
local v33
local v34
local flag9 = false
pcall(
    function()
        flag9 = UserInputService.TouchEnabled
    end
)
local num3 = 0
local v35
local flag10 = false
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VroyCamAimFOV"
screenGui.DisplayOrder = 10
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(
    function()
        screenGui.Parent = type(gethui) == "function" and gethui() or game:GetService("CoreGui")
    end
)
if screenGui.Parent == nil and LocalPlayer then
    pcall(
        function()
            screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
    )
end
local frame1 = Instance.new("Frame")
frame1.Name = "Circle"
frame1.BackgroundTransparency = 1
frame1.BorderSizePixel = 0
frame1.Visible = false
frame1.Parent = screenGui
local uICorner = Instance.new("UICorner")
uICorner.CornerRadius = UDim.new(1, 0)
uICorner.Parent = frame1
local uIStroke = Instance.new("UIStroke")
uIStroke.Color = Color3.fromRGB(255, 70, 70)
uIStroke.Thickness = 1.5
uIStroke.Transparency = 0.28
uIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uIStroke.Parent = frame1
UserInputService.InputBegan:Connect(
    function(arg1, _)
        if arg1.UserInputType == Enum.UserInputType.MouseButton2 then
            flag7 = true
        elseif arg1.UserInputType == Enum.UserInputType.MouseButton1 then
            flag8 = true
        end
    end
)
UserInputService.InputEnded:Connect(
    function(arg1)
        if arg1.UserInputType == Enum.UserInputType.MouseButton2 then
            flag7 = false
        elseif arg1.UserInputType == Enum.UserInputType.MouseButton1 then
            flag8 = false
        end
    end
)
local function func16()
    if v32 then
        return v32
    end
    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
    local v1 = PlayerScripts and PlayerScripts:FindFirstChild("Controllers")
    local v2 = v1 and v1:FindFirstChild("CameraController")
    if not v2 then
        return nil
    end
    local v3, v4 = pcall(require, v2)
    if v3 and type(v4) == "table" then
        v32 = v4
        return v4
    end
    return nil
end
local function func17(arg1, arg2)
    if not arg1 then
        return nil
    end
    local v1 = tbl2.cam[arg1]
    if not v1 then
        local tbl = {}
        v1 = tbl
        tbl2.cam[arg1] = tbl
    end
    local v2 = v1[arg2]
    if v2 and v2.Parent then
        return v2
    end
    local v3 = arg1:FindFirstChild(arg2, true)
    if v3 then
        v1[arg2] = v3
    end
    return v3
end
local function func18(arg1)
    if not arg1 then
        return nil
    end
    local v1 = tbl2.cam[arg1]
    if not v1 then
        local tbl = {}
        v1 = tbl
        tbl2.cam[arg1] = tbl
    end
    local __hum = v1.__hum
    if __hum and __hum.Parent then
        return __hum
    end
    local Humanoid = arg1:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        v1.__hum = Humanoid
    end
    return Humanoid
end
local function func19(arg1, arg2)
    if not arg1 then
        return nil
    end
    local function func(...)
        local num = 1
        local v1 = select("#", ...)
        if not (1 <= v1) then
            return nil
        end
        local v2 = func17
        local v3 = arg1
        local v4 = select
        local num1 = 1
        local v5
        while true do
            v5 = v2(v3, v4(num1, ...))
            if v5 and v5:IsA("BasePart") then
                break
            end
            num = num + 1
            if not (num <= v1) then
                return nil
            end
            v2 = func17
            v3 = arg1
            v4 = select
            num1 = num
        end
        return v5
    end
    if arg2 == "Head" then
        return (func("Head", "HitboxHead"))
    end
    if arg2 == "Torso" then
        return (func("UpperTorso", "Torso"))
    end
    if arg2 == "Humanrootpart" then
        return (func("HumanoidRootPart"))
    end
    if arg2 == "Leftarm" then
        return (func("LeftUpperArm", "Left Arm"))
    end
    if arg2 == "Rightarm" then
        return (func("RightUpperArm", "Right Arm"))
    end
    if arg2 == "Leftleg" then
        return (func("LeftUpperLeg", "Left Leg"))
    end
    if arg2 == "Rightleg" then
        return (func("RightUpperLeg", "Right Leg"))
    end
    if arg2 == "Random" then
        local v1 = func("Head", "HitboxHead")
        local v2 = func("HumanoidRootPart")
        if v1 and v2 then
            return math.random(0, 1) == 0 and v1 or v2
        end
        return v1 or v2
    end
    return func("Head", "HitboxHead") or func("UpperTorso", "Torso") or func("HumanoidRootPart")
end
local function func20(arg1)
    if not arg1 or arg1 == LocalPlayer then
        return false
    end
    local Character = arg1.Character
    if not Character then
        return false
    end
    local v1 = func18(Character)
    if v1 and v1.Health <= 0 then
        return false
    end
    return true
end
local function func21(arg1)
    local v1, v2, v3 = pcall(
        function()
            return LocalPlayer:GetAttribute("TeamID"), arg1:GetAttribute("TeamID")
        end
    )
    if v1 and v2 ~= nil and v3 ~= nil and v2 == v3 then
        return true
    end
    local v4, v5, v6 = pcall(
        function()
            return LocalPlayer:GetAttribute("EnvironmentID"), arg1:GetAttribute("EnvironmentID")
        end
    )
    if v4 and v5 ~= nil and v6 ~= nil and v5 ~= v6 then
        return true
    end
    return false
end
local function func22(arg1, arg2, arg3)
    local CurrentCamera = workspace.CurrentCamera
    if not CurrentCamera or not arg1 or not arg2 then
        return false
    end
    local Character = LocalPlayer.Character
    if not Character then
        return false
    end
    local Position = CurrentCamera.CFrame.Position
    local v1 = arg1.Position - Position
    local Magnitude = v1.Magnitude
    if Magnitude <= 0.001 then
        return false
    end
    local tbl = {Character, arg2}
    local Debris = workspace:FindFirstChild("Debris")
    if Debris then
        tbl[#tbl + 1] = Debris
    end
    local ViewModels = workspace:FindFirstChild("ViewModels")
    if ViewModels then
        tbl[#tbl + 1] = ViewModels
    end
    if CurrentCamera then
        tbl[#tbl + 1] = CurrentCamera
    end
    arg3.FilterDescendantsInstances = tbl
    local v2 = workspace:Raycast(Position, v1.Unit * Magnitude, arg3)
    return v2 == nil or v2.Instance:IsDescendantOf(arg2)
end
local function func23()
    local CurrentCamera = workspace.CurrentCamera
    if not CurrentCamera then
        return nil
    end
    local v1 = v4.CameraIgnoreFOV == true
    local v2 = tonumber(v4.CameraFOVRadius) or 282
    local str = tostring(v4.CameraAimPart or "Auto")
    local MouseLocation = UserInputService:GetMouseLocation()
    local Position = CurrentCamera.CFrame.Position
    local LookVector = CurrentCamera.CFrame.LookVector
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true
    local tbl
    local huge = math.huge
    for _, v3 in ipairs(Players:GetPlayers()) do
        if func20(v3) and not func21(v3) then
            local Character = v3.Character
            local v5
            if str == "Random" then
                if v33 == v3 and v34 and v34.Parent then
                    v5 = v34
                else
                    local v6 = func19(Character, "Random")
                    v5 = v6
                    v33 = v3
                    v34 = v6
                end
            else
                v5 = func19(Character, str)
            end
            if v5 and func22(v5, Character, raycastParams) then
                if v1 then
                    local v7 = v5.Position - Position
                    local Magnitude = v7.Magnitude
                    if Magnitude > 0.001 then
                        local v8 = LookVector:Dot(v7.Unit)
                        if v8 > 0 then
                            local v9 = (1 - v8) * 1000 + Magnitude * 0.001
                            if v9 < huge then
                                huge = v9
                                tbl = {player = v3, part = v5, worldPosition = v5.Position}
                            end
                        end
                    end
                else
                    local v10, v11 = CurrentCamera:WorldToViewportPoint(v5.Position)
                    if v11 then
                        local Magnitude1 = (Vector2.new(v10.X, v10.Y) - MouseLocation).Magnitude
                        if Magnitude1 <= v2 and Magnitude1 < huge then
                            huge = Magnitude1
                            tbl = {player = v3, part = v5, worldPosition = v5.Position}
                        end
                    end
                end
            end
        end
    end
    if str ~= "Random" then
        v33 = nil
        v34 = nil
    end
    return tbl
end
local function func24()
    local CurrentCamera = workspace.CurrentCamera
    if not CurrentCamera then
        return {error = "no camera"}
    end
    local tbl = {players = 0, dead = 0, team = 0, nopart = 0, hidden = 0, behind = 0, ok = 0}
    local str = tostring(v4.CameraAimPart or "Auto")
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true
    for _, v1 in ipairs(Players:GetPlayers()) do
        if v1 ~= LocalPlayer then
            tbl.players = tbl.players + 1
            if not func20(v1) then
                tbl.dead = tbl.dead + 1
            elseif func21(v1) then
                tbl.team = tbl.team + 1
            else
                local v2 = func19(v1.Character, str)
                if not v2 then
                    tbl.nopart = tbl.nopart + 1
                elseif not func22(v2, v1.Character, raycastParams) then
                    tbl.hidden = tbl.hidden + 1
                elseif CurrentCamera.CFrame.LookVector:Dot(
                    (v2.Position - CurrentCamera.CFrame.Position).Unit
                ) <= 0 then
                    tbl.behind = tbl.behind + 1
                else
                    tbl.ok = tbl.ok + 1
                end
            end
        end
    end
    return tbl
end
local function func25(arg1, arg2)
    local CurrentCamera = workspace.CurrentCamera
    if not CurrentCamera or not arg1 then
        return false
    end
    local v1 = func16()
    if v1 and type(v1.SetRotation) == "function" then
        local v2 = rawget(v1, "Rotation")
        if typeof(v2) ~= "Vector2" then
            return false
        end
        local v3, v4, v5 = pcall(
            function()
                return CFrame.lookAt(CurrentCamera.CFrame.Position, arg1):ToOrientation()
            end
        )
        if not v3 then
            return false
        end
        return pcall(
            v1.SetRotation, v1,
            Vector2.new(
                v2.X + (v4 - v2.X) * arg2,
                v2.Y + ((v5 - v2.Y + math.pi) % (2 * math.pi) - math.pi) * arg2
            )
        )
    end
    return pcall(
        function()
            local CFrame1 = CurrentCamera.CFrame
            CurrentCamera.CFrame = CFrame1:Lerp(CFrame.new(CFrame1.Position, arg1), arg2)
        end
    )
end
RunService.RenderStepped:Connect(
    function(arg1)
        local v1 = v4.CameraAimEnabled == true
        local v2 = v4.CameraShowFOV == true
        local v3 = tonumber(v4.CameraFOVRadius) or 282
        if frame1 then
            frame1.Size = UDim2.fromOffset(v3 * 2, v3 * 2)
            local v5, v6 = pcall(UserInputService.GetMouseLocation, UserInputService)
            if v5 and v6 then
                frame1.Position = UDim2.fromOffset(v6.X - v3, v6.Y - v3)
            end
            frame1.Visible = v2
        end
        if not v1 then
            v33 = nil
            v34 = nil
            v35 = nil
            flag10 = false
            return
        end
        local Character = LocalPlayer.Character
        local v7 = Character and Character:FindFirstChildOfClass("Humanoid")
        if not Character or not v7 or v7.Health <= 0 then
            return
        end
        if not workspace.CurrentCamera then
            return
        end
        local v8 = flag8
        local v9 = flag7
        pcall(
            function()
                if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    v8 = true
                end
                if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                    v9 = true
                end
            end
        )
        local v10 = v8 or v9 or flag9
        num3 = num3 + 1
        local v11, v13
        if v10 or num3 % 2 == 0 then
            v11 = func23()
            local v12 = v11 and v11.part and v11.part.Parent
            v13 = v12
            v35 = v11
            flag10 = v12
        else
            v11 = v35
            v13 = flag10
            if v13 and (not v11 or not v11.part or not v11.part.Parent) then
                v13 = false
                v11 = nil
            end
        end
        if frame1 and v2 and uIStroke then
            uIStroke.Color = v13 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 70, 70)
        end
        if num3 % 30 == 0 and v14 then
            local str
            if not v1 then
                str = "Status: OFF"
            elseif v13 and v11 and v11.player then
                str = "Status: LOCK " .. tostring(v11.player.Name)
            else
                local v15 = func24()
                if v15.error then
                    str = "Status: scan error"
                else
                    str = string.format(
                        "Status: scanning (ok=%d hidden=%d team=%d)", v15.ok, v15.hidden, v15.team
                    )
                end
            end
            pcall(
                function()
                    v14:SetText(str)
                end
            )
        end
        if not v10 then
            return
        end
        if not v13 then
            return
        end
        local worldPosition = v11.worldPosition
        local v16 = math.clamp(type(arg1) == "number" and arg1 or 0.016666666666666666, 0, 0.1)
        local num = tonumber(v4.CameraAimSpeed)
        local v17 = math.clamp(1 - math.exp(-v16 * (2 + (num or 35) * 0.58)), 0, 1)
        func25(worldPosition, v17)
    end
);
(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local function func(arg1, arg2)
        local v1 = arg2 or Workspace.CurrentCamera
        if not v1 or not arg1 then
            return nil, false
        end
        local v2, v3, v4 = pcall(
            function()
                return v1:WorldToViewportPoint(arg1)
            end
        )
        if not v2 or not v4 or v3.Z <= 0 then
            return v3, false
        end
        return v3, true
    end
    local function func1(arg1)
        local v1 = arg1 or Workspace.CurrentCamera
        if not v1 then
            return nil
        end
        return v1.CFrame
    end
    local function func2()
        local ViewModels = Workspace:FindFirstChild("ViewModels")
        if not ViewModels then
            return nil
        end
        local FirstPerson = ViewModels:FindFirstChild("FirstPerson")
        if not FirstPerson then
            return nil
        end
        local Name = LocalPlayer.Name
        for _, v1 in pairs(FirstPerson:GetChildren()) do
            if v1:IsA("Model") and v1.Name:find("^" .. Name) then
                local ItemVisual = v1:FindFirstChild("ItemVisual")
                if ItemVisual then
                    local Body = ItemVisual:FindFirstChild("Body")
                    if Body then
                        local BodyPrimary = Body:FindFirstChild("BodyPrimary")
                        if BodyPrimary then
                            local _muzzle = BodyPrimary:FindFirstChild("_muzzle")
                            if _muzzle and _muzzle:IsA("Attachment") then
                                return _muzzle.WorldPosition
                            end
                        end
                    end
                end
            end
        end
        return nil
    end
    local tbl = {}
    local function func3(arg1, arg2)
        if not arg1 or not arg1.Parent then
            return false
        end
        local v1 = tbl[arg1]
        local v2 = tick()
        if v1 and v2 - v1.t < 0.12 then
            return v1.v
        end
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, arg1.Parent}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        local v3 = arg1.Position - arg2.Position
        local v4 = Workspace:Raycast(arg2.Position, v3.Unit * v3.Magnitude, raycastParams)
        local v5 = not v4 or v4.Instance and (v4.Instance:IsDescendantOf(arg1.Parent) or v4.Instance == arg1)
        tbl[arg1] = {t = v2, v = v5}
        return v5
    end
    task.spawn(
        function()
            while true do
                task.wait(0.5)
                local v1 = tick()
                for k, v2 in pairs(tbl) do
                    if not k.Parent or v1 - v2.t > 0.36 then
                        tbl[k] = nil
                    end
                end
            end
        end
    )
    local tbl1 = {
        enabled = false, masterEnabled = false, keyMode = "toggle", showFov = false,
        targetPart = "Head", fovRadius = 60, smoothness = 2, aimCurve = "Linear",
        followMuzzle = false,
    }
    tbl1.lockedTarget = nil
    tbl1.smoothCF = nil
    tbl1.visibleOnly = false
    local function getClosestEnemy()
        tbl1.lockedTarget = nil
        tbl1.smoothCF = nil
    end
    local v4
    local function toggleTeleportToEnemy()
        if v4 then
            return v4
        end
        local v1, v2 = pcall(
            function()
                local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
                local v1 = PlayerScripts and PlayerScripts:FindFirstChild("Controllers")
                local v2 = v1 and v1:FindFirstChild("CameraController")
                if not v2 then
                    return nil
                end
                return require(v2)
            end
        )
        if v1 and type(v2) == "table" then
            v4 = v2
            return v2
        end
        return nil
    end
    local function func6()
        if tbl1.followMuzzle then
            local v1 = func2()
            if v1 then
                local v2, v3 = func(v1, Workspace.CurrentCamera)
                if v3 and v2 then
                    return Vector2.new(v2.X, v2.Y)
                end
            end
        end
        local v4, v5 = pcall(UserInputService.GetMouseLocation, UserInputService)
        if v4 and v5 then
            return Vector2.new(v5.X, v5.Y)
        end
        local CurrentCamera = Workspace.CurrentCamera
        if CurrentCamera then
            return Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
        end
        return Vector2.zero
    end
    local function func7()
        local v7
        local fovRadius = tbl1.fovRadius
        local v1 = func6()
        if not v1 then
            return nil
        end
        local CurrentCamera = Workspace.CurrentCamera
        local Character = LocalPlayer.Character
        local v2 = Character and Character:FindFirstChild("HumanoidRootPart")
        for _, v3 in ipairs(Players:GetPlayers()) do
            if v3 ~= LocalPlayer and v3.Character then
                local v4 = v3.Character:FindFirstChild(tbl1.targetPart)
                if v4 and v4:IsDescendantOf(Workspace) then
                    local v5, v6 = func(v4.Position, CurrentCamera)
                    if v6 and v5 then
                        local Magnitude = (Vector2.new(v5.X, v5.Y) - v1).Magnitude
                        if Magnitude < fovRadius then
                            if tbl1.visibleOnly and v2 then
                                if func3(v4, v2) then
                                    fovRadius = Magnitude
                                    v7 = v4
                                end
                            else
                                fovRadius = Magnitude
                                v7 = v4
                            end
                        end
                    end
                end
            end
        end
        return v7
    end
    local function func8(arg1)
        local v1 = math.clamp(tonumber(tbl1.smoothness) or 2, 0.1, 10)
        local v2 = tbl1.aimCurve or "Linear"
        local v3 = 6 / v1
        if v2 == "Instant" then
            return 1
        end
        if v2 == "Expo" then
            return 1 - math.exp(-(4 / v1) * arg1)
        end
        if v2 == "EaseIn" then
            local v4 = math.clamp(v3 * arg1, 0, 1)
            return v4 * v4
        end
        if v2 == "EaseOut" then
            local v5 = math.clamp(v3 * arg1, 0, 1)
            return 1 - (1 - v5) * (1 - v5)
        end
        if v2 == "EaseInOut" then
            local v6 = math.clamp(v3 * arg1, 0, 1)
            if v6 < 0.5 then
                return 2 * v6 * v6
            end
            return 1 - (-2 * v6 + 2) ^ 2 / 2
        end
        if v2 == "Cubic" then
            local v7 = math.clamp(v3 * arg1, 0, 1)
            return v7 * v7 * v7
        end
        return math.clamp(v3 * arg1, 0, 1)
    end
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VroyAimbotFOV"
    screenGui.DisplayOrder = 10
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(
        function()
            screenGui.Parent = type(gethui) == "function" and gethui() or game:GetService("CoreGui")
        end
    )
    if screenGui.Parent == nil then
        pcall(
            function()
                screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
            end
        )
    end
    local tbl2 = {
        OutlineColor1 = Color3.fromRGB(255, 255, 255),
        OutlineColor2 = Color3.fromRGB(255, 255, 255), OutlineRotation = 0, OutlineThickness = 1.5,
        OutlineTransparency = 0, FilledEnabled = false,
        FilledColor1 = Color3.fromRGB(255, 255, 255), FilledColor2 = Color3.fromRGB(0, 0, 0),
        FilledRotation = 0, FilledTransparency = 0.7, FilledAnimated = false, FilledSpeed = 1,
        SpinOn = false, SpinSpd = 1,
    }
    local v2 = (function()
        local frame = Instance.new("Frame")
        frame.Name = "AimbotFOV"
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 0
        frame.Visible = false
        frame.Parent = screenGui
        local frame1 = Instance.new("Frame")
        frame1.Size = UDim2.new(1, 0, 1, 0)
        frame1.BackgroundColor3 = Color3.new(1, 1, 1)
        frame1.BackgroundTransparency = tbl2.FilledTransparency
        frame1.BorderSizePixel = 0
        frame1.Visible = false
        frame1.ZIndex = 1
        frame1.Parent = frame
        local uICorner = Instance.new("UICorner")
        uICorner.CornerRadius = UDim.new(1, 0)
        uICorner.Parent = frame1
        local uIGradient = Instance.new("UIGradient")
        uIGradient.Color = ColorSequence.new(
            {ColorSequenceKeypoint.new(0, tbl2.FilledColor1), ColorSequenceKeypoint.new(
                1, tbl2.FilledColor2
            )}
        )
        uIGradient.Rotation = tbl2.FilledRotation
        uIGradient.Parent = frame1
        local frame2 = Instance.new("Frame")
        frame2.Size = UDim2.new(1, 0, 1, 0)
        frame2.BackgroundTransparency = 1
        frame2.BorderSizePixel = 0
        frame2.ZIndex = 2
        frame2.Parent = frame
        local uICorner1 = Instance.new("UICorner")
        uICorner1.CornerRadius = UDim.new(1, 0)
        uICorner1.Parent = frame2
        local uIStroke = Instance.new("UIStroke")
        uIStroke.Color = Color3.new(1, 1, 1)
        uIStroke.Thickness = tbl2.OutlineThickness
        uIStroke.Transparency = tbl2.OutlineTransparency
        uIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uIStroke.Parent = frame2
        local uIGradient1 = Instance.new("UIGradient")
        uIGradient1.Color = ColorSequence.new(
            {ColorSequenceKeypoint.new(0, tbl2.OutlineColor1), ColorSequenceKeypoint.new(
                1, tbl2.OutlineColor2
            )}
        )
        uIGradient1.Rotation = tbl2.OutlineRotation
        uIGradient1.Parent = uIStroke
        return {
            container = frame, fill = frame1, fillgrad = uIGradient, stroke = uIStroke,
            strokegrad = uIGradient1,
        }
    end)()
    local container = v2.container
    local fill = v2.fill
    local fillgrad = v2.fillgrad
    local stroke = v2.stroke
    local strokegrad = v2.strokegrad
    local function func9()
        strokegrad.Color = ColorSequence.new(
            {ColorSequenceKeypoint.new(0, tbl2.OutlineColor1), ColorSequenceKeypoint.new(
                1, tbl2.OutlineColor2
            )}
        )
    end
    local function func10()
        fillgrad.Color = ColorSequence.new(
            {ColorSequenceKeypoint.new(0, tbl2.FilledColor1), ColorSequenceKeypoint.new(
                1, tbl2.FilledColor2
            )}
        )
    end
    RunService.RenderStepped:Connect(
        function()
            if not container.Visible then
                return
            end
            local v1 = func6()
            local v2 = tonumber(tbl1.fovRadius) or 60
            container.Size = UDim2.fromOffset(v2 * 2, v2 * 2)
            container.Position = UDim2.fromOffset(v1.X - v2, v1.Y - v2)
            if tbl2.FilledAnimated then
                local sin = math.sin
                local v3 = tick()
                fillgrad.Rotation = sin(v3 * tbl2.FilledSpeed) * 180 + tbl2.FilledRotation
            elseif tbl2.SpinOn then
                fillgrad.Rotation = tbl2.FilledRotation + tick() * tbl2.SpinSpd * 90 % 360
            end
            if tbl2.SpinOn then
                strokegrad.Rotation = tbl2.OutlineRotation + tick() * tbl2.SpinSpd * 90 % 360
            end
        end
    )
    local v5
    local flag = false
    local function func11(arg1)
        local v1 = arg1 or 0.004166666666666667
        if not tbl1.enabled then
            getClosestEnemy()
            return
        end
        local CurrentCamera = Workspace.CurrentCamera
        if not CurrentCamera then
            return
        end
        if not tbl1.lockedTarget then
            tbl1.lockedTarget = func7()
            tbl1.smoothCF = func1(CurrentCamera)
            if not tbl1.lockedTarget then
                return
            end
        end
        if not tbl1.lockedTarget.Parent or not tbl1.lockedTarget:IsDescendantOf(Workspace) then
            getClosestEnemy()
            return
        end
        local Character = LocalPlayer.Character
        if not Character then
            return
        end
        if not Character:FindFirstChild("Head") then
            getClosestEnemy()
            return
        end
        local v2 = toggleTeleportToEnemy()
        if not v2 then
            return
        end
        if not tbl1.smoothCF then
            tbl1.smoothCF = func1(CurrentCamera)
        end
        local v3 = CFrame.lookAt(CurrentCamera.CFrame.Position, tbl1.lockedTarget.Position)
        local v4 = func8(v1)
        tbl1.smoothCF = tbl1.smoothCF:Lerp(v3, v4)
        if v2.MimicRotation then
            pcall(
                function()
                    v2:MimicRotation(tbl1.smoothCF)
                end
            )
        end
    end
    local function func12()
        if v5 then
            v5:Disconnect()
            v5 = nil
        end
        if flag then
            pcall(
                function()
                    RunService:UnbindFromRenderStep("VroyAimbotUpdate")
                end
            )
            flag = false
        end
        container.Visible = tbl1.showFov
        if not tbl1.enabled then
            getClosestEnemy()
            return
        end
        if pcall(
            function()
                RunService:UnbindFromRenderStep("VroyAimbotUpdate")
                RunService:BindToRenderStep(
                    "VroyAimbotUpdate", Enum.RenderPriority.Camera.Value + 1, func11
                )
            end
        ) then
            flag = true
        else
            v5 = RunService.RenderStepped:Connect(func11)
        end
    end
    LocalPlayer.CharacterRemoving:Connect(
        function()
            getClosestEnemy()
        end
    )
    local v3 = v10._raw:AddLeftGroupbox("Aimbot")
    v3:AddToggle(
        "AimbotToggle",
        {
            Text = "Enable", Default = false,
            Callback = function(arg1)
                tbl1.masterEnabled = arg1
                if not arg1 then
                    tbl1.enabled = false
                    getClosestEnemy()
                    func12()
                else
                    local v2 = v1.Options and v1.Options.AimbotKey
                    if v2 and v2.Mode == "Toggle" then
                        tbl1.enabled = true
                    end
                    func12()
                end
            end,
        }
    ):AddKeyPicker(
        "AimbotKey",
        {
            Text = "Aimbot", Default = "None", Mode = "Toggle", NoUI = true,
            SyncToggleState = false, Modes = {"Toggle", "Hold"},
            Callback = function(arg1)
                local v2 = v1.Options and v1.Options.AimbotKey
                if not v2 or v2.Mode ~= "Toggle" or not tbl1.masterEnabled then
                    return
                end
                tbl1.enabled = arg1
                if not arg1 then
                    getClosestEnemy()
                end
                func12()
            end,
        }
    )
    RunService.RenderStepped:Connect(
        function()
            local v2 = v1.Options and v1.Options.AimbotKey
            if not v2 then
                return
            end
            local v3 = v2.Mode and string.lower(v2.Mode) or "toggle"
            if v3 ~= tbl1.keyMode then
                tbl1.keyMode = v3
                tbl1.enabled = false
                getClosestEnemy()
                func12()
            end
            if v3 ~= "hold" or not tbl1.masterEnabled then
                return
            end
            local State = v2:GetState()
            if State == tbl1.enabled then
                return
            end
            tbl1.enabled = State
            if not State then
                getClosestEnemy()
            end
            func12()
        end
    )
    v3:AddToggle(
        "AimbotVisibleOnly",
        {
            Text = "Visible Only", Default = false,
            Callback = function(arg1)
                tbl1.visibleOnly = arg1
            end,
        }
    )
    v3:AddSlider(
        "AimbotSmoothness",
        {
            Text = "Smoothness", Default = 2, Min = 0.1, Max = 10, Rounding = 2, Compact = true,
            Callback = function(arg1)
                tbl1.smoothness = math.clamp(arg1, 0.1, 10)
            end,
        }
    )
    v3:AddDropdown(
        "AimbotCurve",
        {
            Text = "Aim Curve", Default = "Linear",
            Values = {"Linear", "Expo", "EaseIn", "EaseOut", "EaseInOut", "Cubic", "Instant"},
            Callback = function(arg1)
                tbl1.aimCurve = arg1
            end,
        }
    )
    v3:AddDropdown(
        "AimbotHitPart",
        {
            Text = "hit part", Default = "Head",
            Values = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso"},
            Callback = function(arg1)
                tbl1.targetPart = arg1
            end,
        }
    )
    v3:AddToggle(
        "ShowAimbotFOV",
        {
            Text = "show fov", Default = false,
            Callback = function(arg1)
                tbl1.showFov = arg1
                container.Visible = arg1
            end,
        }
    ):AddColorPicker(
        "AimbotFOVOutlineColor1",
        {
            Default = Color3.fromRGB(255, 255, 255), Title = "outline color 1",
            Callback = function(arg1)
                tbl2.OutlineColor1 = arg1
                func9()
            end,
        }
    ):AddColorPicker(
        "AimbotFOVOutlineColor2",
        {
            Default = Color3.fromRGB(255, 255, 255), Title = "outline color 2",
            Callback = function(arg1)
                tbl2.OutlineColor2 = arg1
                func9()
            end,
        }
    )
    v3:AddToggle(
        "AimbotFOVFilled",
        {
            Text = "fov fill", Default = false,
            Callback = function(arg1)
                tbl2.FilledEnabled = arg1
                fill.Visible = arg1
            end,
        }
    ):AddColorPicker(
        "AimbotFOVFillColor1",
        {
            Default = Color3.fromRGB(255, 255, 255), Title = "fill color 1",
            Callback = function(arg1)
                tbl2.FilledColor1 = arg1
                func10()
            end,
        }
    ):AddColorPicker(
        "AimbotFOVFillColor2",
        {
            Default = Color3.fromRGB(0, 0, 0), Title = "fill color 2",
            Callback = function(arg1)
                tbl2.FilledColor2 = arg1
                func10()
            end,
        }
    )
    v3:AddSlider(
        "AimbotFOV",
        {
            Text = "fov radius", Default = 60, Min = 10, Max = 1000, Rounding = 0, Compact = true,
            Callback = function(arg1)
                tbl1.fovRadius = arg1
            end,
        }
    )
    v3:AddSlider(
        "AimbotFOVOutlineThickness",
        {
            Text = "outline thickness", Default = 1.5, Min = 0.5, Max = 5, Rounding = 1,
            Compact = true,
            Callback = function(arg1)
                tbl2.OutlineThickness = arg1
                stroke.Thickness = arg1
            end,
        }
    )
    func12()
end)()
local v15 = v10:AddSection("HVH Preset");
(function()
    local function func()
        local v1 = type(getgenv) == "function" and getgenv() or _G
        local v2 = type(v1) == "table" and v1.BazaRagebot or nil
        if type(v2) == "table" and type(v2.config) == "table" then
            return v2
        end
        return nil
    end
    local function func1()
        local v1 = type(getgenv) == "function" and getgenv() or _G
        local v2 = type(v1) == "table" and v1.BazaAntiSettings or nil
        if type(v2) == "table" then
            return v2
        end
        return nil
    end
    local function func2()
        local v1 = type(getgenv) == "function" and getgenv() or _G
        local v2 = type(v1) == "table" and v1.BazaDesync or nil
        if type(v2) == "table" then
            return v2
        end
        return nil
    end
    local function func3()
        local v1 = func()
        if not v1 then
            return
        end
        local config = v1.config
        local v2 = config.hvh and config.hvh._presetSaved
        if not v2 then
            pcall(
                function()
                    VroyUI:Notify(
                        {Title = "Unload Preset", Text = "No hay preset guardado.", Type = "warn"}
                    )
                end
            )
            return
        end
        config.target.enabled = v2.target.enabled
        config.target.auto = v2.target.auto
        config.target.hitpart = v2.target.hitpart
        config.target.shootAttempts = v2.target.shootAttempts
        config.prediction.enabled = v2.prediction.enabled
        config.prediction.multiplier = v2.prediction.multiplier
        config.voidspam.enabled = v2.voidspam.enabled
        config.voidspam.shoot_min = v2.voidspam.smin
        config.voidspam.shoot_max = v2.voidspam.smax
        config.voidspam.hide_min = v2.voidspam.hmin
        config.voidspam.hide_max = v2.voidspam.hmax
        config.voidspam.phase = nil
        if config.flick and v2.flick then
            config.flick.enabled = v2.flick.enabled
            config.flick.shots = v2.flick.shots
            config.flick.attack = v2.flick.attack
            config.flick.hide = v2.flick.hide
            config.flick.count = 0
        end
        config.hvh.resolver = v2.hvh.resolver
        config.hvh.voidChase = v2.hvh.voidChase
        config.hvh.exposureSnipe = v2.hvh.exposureSnipe
        config.hvh.serverLock = v2.hvh.serverLock
        config.hvh.originSpoof = v2.hvh.originSpoof
        config.hvh.strafe = v2.hvh.strafe
        config.hvh.strafeR = v2.hvh.strafeR
        config.hvh.strafeH = v2.hvh.strafeH
        config.hvh.exposureUntil = {}
        config.hvh.wasVoid = {}
        local v3 = func1()
        local v4 = func2()
        if v3 and v2.anti then
            v3.enabled = v2.anti.enabled
            v3.yawtype = v2.anti.yawtype
            v3.pitchtype = v2.anti.pitchtype
            v3.angletype = v2.anti.angletype
            v3.minspeed = v2.anti.minspeed
            v3.maxspeed = v2.anti.maxspeed
            v3.minangle = v2.anti.minangle
            v3.maxangle = v2.anti.maxangle
            v3.randomangle = v2.anti.randomangle
        end
        if v4 and v2.desync then
            v4.enabled = v2.desync.enabled
            v4.mode = v2.desync.mode
            v4.strength = v2.desync.strength
            v4.spinspeed = v2.desync.spinspeed
        end
        config.ragestatus.hideOnReload = v2.hideReload
        if v2.misc then
            local v5 = type(getgenv) == "function" and getgenv() or _G
            local v6 = type(v5) == "table" and v5.VroyMiscBridge or nil
            if type(v6) == "table" then
                if v2.misc.staff then
                    pcall(v6.setStaff, v2.misc.staff.enabled, v2.misc.staff.action)
                end
                if v2.misc.device then
                    pcall(v6.setDevice, v2.misc.device.enabled, v2.misc.device.stype)
                end
            end
        end
        config.hvh._presetSaved = nil
        local v7 = pcall
        v7(
            function()
                if v1.cleartarget and config.target.character then
                    v1.cleartarget()
                end
            end
        )
        v7(
            function()
                if v1.clrVoidSnap then
                    v1.clrVoidSnap()
                end
            end
        )
        v7(
            function()
                VroyUI:Notify(
                    {
                        Title = "Unload Preset",
                        Text = "Preset deshecho, volviste a tu combinacion anterior.",
                        Type = "success",
                    }
                )
            end
        )
    end
    v15:AddButton(
        "HVH Preset (1-click)",
        function()
            local v1 = func()
            if not v1 then
                return
            end
            local config = v1.config
            config.hvh = type(config.hvh) == "table" and config.hvh or {}
            config.target = config.target or {}
            config.prediction = config.prediction or {}
            config.voidspam = config.voidspam or {}
            config.ragestatus = config.ragestatus or {}
            local v2 = func1()
            local v3 = func2()
            local tbl
            local v4 = type(getgenv) == "function" and getgenv() or _G
            local v5 = type(v4) == "table" and v4.VroyMiscBridge or nil
            if type(v5) == "table" then
                local v6, v7 = pcall(v5.getStaff)
                local v8, v9 = pcall(v5.getDevice)
                tbl = {staff = v6 and v7 or nil, device = v8 and v9 or nil}
                local v10 = pcall
                v10(v5.setStaff, true, "Kick")
                v10(v5.setDevice, true, "VR")
            end
            config.hvh._presetSaved = {
                misc = tbl,
                target = {
                    enabled = config.target.enabled, auto = config.target.auto,
                    hitpart = config.target.hitpart, shootAttempts = config.target.shootAttempts,
                },
                prediction = {
                    enabled = config.prediction.enabled, multiplier = config.prediction.multiplier
                },
                voidspam = {
                    enabled = config.voidspam.enabled, smin = config.voidspam.shoot_min,
                    smax = config.voidspam.shoot_max, hmin = config.voidspam.hide_min,
                    hmax = config.voidspam.hide_max,
                },
                flick = config.flick and {
                    enabled = config.flick.enabled, shots = config.flick.shots,
                    attack = config.flick.attack, hide = config.flick.hide,
                } or nil,
                hvh = {
                    resolver = config.hvh.resolver, voidChase = config.hvh.voidChase,
                    exposureSnipe = config.hvh.exposureSnipe, serverLock = config.hvh.serverLock,
                    originSpoof = config.hvh.originSpoof, strafe = config.hvh.strafe,
                    strafeR = config.hvh.strafeR, strafeH = config.hvh.strafeH,
                },
                anti = v2 and {
                    enabled = v2.enabled, yawtype = v2.yawtype, pitchtype = v2.pitchtype,
                    angletype = v2.angletype, minspeed = v2.minspeed, maxspeed = v2.maxspeed,
                    minangle = v2.minangle, maxangle = v2.maxangle, randomangle = v2.randomangle,
                } or nil,
                desync = v3 and {
                    enabled = v3.enabled, mode = v3.mode, strength = v3.strength,
                    spinspeed = v3.spinspeed
                } or nil, hideReload = config.ragestatus.hideOnReload,
            }
            config.hvh.resolver = true
            config.hvh.voidChase = true
            config.hvh.exposureSnipe = true
            config.hvh.serverLock = true
            config.hvh.originSpoof = false
            config.hvh.strafe = true
            config.hvh.strafeR = 4
            config.hvh.strafeH = 2
            config.hvh.exposureUntil = {}
            config.hvh.wasVoid = {}
            config.target.enabled = true
            config.target.auto = true
            config.target.hitpart = "Head"
            config.target.shootAttempts = 3
            config.prediction.enabled = true
            config.prediction.multiplier = 1.2
            config.voidspam.enabled = true
            config.voidspam.shoot_min = 0.35
            config.voidspam.shoot_max = 0.35
            config.voidspam.hide_min = 0.7
            config.voidspam.hide_max = 0.7
            config.voidspam.phase = "shoot"
            config.voidspam.currentduration = 0.35
            config.voidspam.lastswitch = tick()
            if config.flick then
                config.flick.enabled = true
                config.flick.shots = 3
                config.flick.attack = 0.35
                config.flick.hide = 0.7
                config.flick.count = 0
            end
            config.ragestatus.hideOnReload = true
            if v2 then
                v2.enabled = true
                v2.yawtype = "spinbot"
                v2.pitchtype = "none"
                v2.angletype = "none"
                v2.minspeed = 10
                v2.maxspeed = 25
                v2.minangle = 30
                v2.maxangle = 60
                v2.randomangle = false
            end
            if v3 then
                v3.enabled = true
                v3.mode = "Spin"
                v3.strength = 8
                v3.spinspeed = 25
            end
            pcall(
                function()
                    VroyUI:Notify(
                        {
                            Title = "HVH Preset",
                            Text = "Auto-target + x3 mag-dump hasta vaciar + voidspam + spinbot.",
                            Type = "success",
                        }
                    )
                end
            )
        end
    )
    v15:AddButton("Unload Preset (deshacer)", func3)
end)();
(function()
    local _raw = v10._raw
    game:GetService("Players")
    game:GetService("UserInputService")
    local v2 = cloneref or function(arg1)
        return arg1
    end
    getgenv().InstanceConfigLoading = false
    getgenv().InstanceModuleCache = getgenv().InstanceModuleCache or {}
    local function func(arg1, arg2)
        local InstanceModuleCache = getgenv().InstanceModuleCache
        local v1 = typeof(arg1) == "Instance" and arg1:GetFullName() or tostring(arg1)
        if InstanceModuleCache[v1] ~= nil then
            return InstanceModuleCache[v1]
        end
        local v2 = arg2 and os.clock() + arg2 or math.huge
        local v5
        while os.clock() < v2 do
            if typeof(arg1) == "Instance" and not arg1.Parent then
                task.wait(0.1)
            else
                local v3, v4 = pcall(require, arg1)
                if v3 then
                    InstanceModuleCache[v1] = v4
                    return v4
                end
                v5 = v4
                task.wait(0.1)
            end
        end
        error("[Baza Hub] module load failed: " .. v1 .. " (" .. tostring(v5) .. ")")
    end
    getgenv().InstanceRequire = func
    local function func1()
        if not v1 or v1.Unloaded then
            return false
        end
        if Window and Window.Holder and Window.Holder.Parent then
            return Window.Holder.Visible
        end
        return false
    end
    local function func2()
        return (func1())
    end
    getgenv().InstanceIsMenuOpenFn = func1
    getgenv().InstanceShouldSuppressFn = func2
    game:GetService("UserInputService")
    func(game:GetService("ReplicatedStorage").Modules.Utility)
    func(game:GetService("ReplicatedStorage").Modules.EnumLibrary)
    game:GetService("Players")
    local v3 = _G
    v3.AspectRatioSettings = v3.AspectRatioSettings or {Enabled = false, X = 13, Y = 10}
    local function func3()
        local AspectRatioSettings = _G.AspectRatioSettings
        if AspectRatioSettings and AspectRatioSettings.Enabled then
            return AspectRatioSettings.X / AspectRatioSettings.Y
        end
        return 1
    end
    local function getClosestEnemy(arg1, arg2)
        local v1 = func3()
        if v1 == 1 then
            return arg1
        end
        local v2 = arg2 or workspace.CurrentCamera
        if not v2 then
            return arg1
        end
        local v3 = v2.ViewportSize.Y * 0.5
        return Vector3.new(arg1.X, v3 + (arg1.Y - v3) * v1, arg1.Z)
    end
    local function toggleTeleportToEnemy(arg1, arg2)
        local v1 = arg2 or workspace.CurrentCamera
        if not v1 or not arg1 then
            return nil, false
        end
        local v2, v3, v4 = pcall(
            function()
                return v1:WorldToViewportPoint(arg1)
            end
        )
        if not v2 or not v4 or v3.Z <= 0 then
            return v3, false
        end
        return getClosestEnemy(v3, v1), true
    end
    getgenv().InstanceGetAspectStretch = func3
    getgenv().InstanceWorldToScreen = func5
    getgenv().InstanceScreenAnchor = screenAnchor
    getgenv().InstanceScreenCenter = screenCenter
    getgenv().InstanceGetUnstretchedCameraCFrame = getUnstretchedCameraCFrame
    local v4 = _G
    v4.Features = v4.Features or {}
    _G.Features.CrossbowSoundId = "rbxassetid://165946246"
    getgenv().InstanceCombatLastShotAt = getgenv().InstanceCombatLastShotAt or 0
    getgenv().InstanceMarkCombatShot = function()
        getgenv().InstanceCombatLastShotAt = tick()
    end
    getgenv().InstanceWorldToScreenEsp = function(arg1, arg2)
        return toggleTeleportToEnemy(arg1, arg2)
    end
    getgenv().InstanceDrawingTextPool = getgenv().InstanceDrawingTextPool or {}
    getgenv().InstanceTrackDrawingText = getgenv().InstanceTrackDrawingText or function(arg1)
        pcall(
            function()
                table.insert(getgenv().InstanceDrawingTextPool, arg1)
            end
        )
        return arg1
    end
    local tbl = {}
    local v5 = v2(game:GetService("ReplicatedStorage"))
    local v6 = v2(game:GetService("Players"))
    local v7 = v2(game:GetService("RunService"))
    local v8 = v2(game:GetService("UserInputService"))
    local v9 = v2(game:GetService("Workspace"))
    local LocalPlayer = v6.LocalPlayer
    local CurrentCamera = v9.CurrentCamera
    local tbl1 = {
        enums = func(v5.Modules.EnumLibrary),
        fighter = func(LocalPlayer.PlayerScripts.Controllers.FighterController),
        camcontrol = func(LocalPlayer.PlayerScripts.Controllers.CameraController),
        utility = func(v5.Modules.Utility),
    }
    local tbl2 = {"MatchId", "DuelId", "RoundId", "GameId", "MatchUUID", "ArenaId", "InstanceId"}
    local tbl3 = {
        "InDuel", "InMatch", "InRound", "InGame", "InFight", "IsInMatch", "IsInDuel", "MatchActive",
        "Fighting",
    }
    local tbl4 = {
        "InSpawn", "InLobby", "IsSpectating", "InSafeZone", "InIntermission", "IsRespawning"
    }
    local function func6(arg1)
        if not arg1 then
            return false
        end
        local Live = v9:FindFirstChild("Live")
        if not Live then
            return false
        end
        if Live:FindFirstChild(arg1.Name) then
            return true
        end
        if Live:FindFirstChild(tostring(arg1.UserId)) then
            return true
        end
        for _, v1 in ipairs(Live:GetChildren()) do
            if v1.Name == arg1.Name or v1.Name == tostring(arg1.UserId) then
                return true
            end
        end
        local Character = arg1.Character
        if Character and (Character.Parent == Live or Character:IsDescendantOf(Live)) then
            return true
        end
        local fighter = tbl1.fighter
        if fighter and type(fighter.GetFighter) == "function" then
            local v2, v3 = pcall(fighter.GetFighter, fighter, arg1)
            if v2 and v3 and v3.Entity and v3.Entity.Parent then
                if v3.Entity.Parent == Live or v3.Entity:IsDescendantOf(Live) then
                    return true
                end
            end
        end
        return false
    end
    local function func7(arg1)
        if not arg1 then
            return nil
        end
        for _, v1 in ipairs(tbl2) do
            local Attribute = arg1:GetAttribute(v1)
            if Attribute ~= nil and Attribute ~= "" and Attribute ~= 0 and Attribute ~= false then
                return tostring(Attribute)
            end
        end
        local Character = arg1.Character
        if Character then
            for _, v2 in ipairs(tbl2) do
                local Attribute1 = Character:GetAttribute(v2)
                if Attribute1 ~= nil and Attribute1 ~= "" and Attribute1 ~= 0 and Attribute1 ~= false then
                    return tostring(Attribute1)
                end
            end
        end
        return nil
    end
    local function func8()
        if not LocalPlayer then
            return false
        end
        for _, v1 in ipairs(tbl4) do
            local Attribute = LocalPlayer:GetAttribute(v1)
            if Attribute == true or Attribute == 1 or Attribute == "true" then
                return false
            end
        end
        local Character = LocalPlayer.Character
        if not Character then
            return false
        end
        for _, v2 in ipairs(tbl4) do
            local Attribute1 = Character:GetAttribute(v2)
            if Attribute1 == true or Attribute1 == 1 or Attribute1 == "true" then
                return false
            end
        end
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        if not Humanoid or Humanoid.Health <= 0 or not HumanoidRootPart then
            return false
        end
        for _, v3 in ipairs(tbl3) do
            local Attribute2 = LocalPlayer:GetAttribute(v3)
            if Attribute2 == true or Attribute2 == 1 or Attribute2 == "true" then
                return true
            end
            local Attribute3 = Character:GetAttribute(v3)
            if Attribute3 == true or Attribute3 == 1 or Attribute3 == "true" then
                return true
            end
        end
        if func6(LocalPlayer) then
            return true
        end
        local fighter = tbl1.fighter
        if fighter and fighter.LocalFighter and fighter.LocalFighter.Entity and fighter.LocalFighter.Entity.Parent then
            return true
        end
        local v4 = func7(LocalPlayer)
        if v4 then
            for _, v5 in v6:GetPlayers() do
                if v5 ~= LocalPlayer and func7(v5) == v4 then
                    return true
                end
            end
        end
        if fighter then
            for _, v7 in ipairs({fighter.Fighters, fighter.AllFighters}) do
                if v7 then
                    for _, v8 in pairs(v7) do
                        if v8 and v8.Player and v8.Player ~= LocalPlayer and (v8.IsEnemy or v8.Enemy) then
                            local Character1 = v8.Player.Character
                            local v9 = Character1 and Character1:FindFirstChildOfClass("Humanoid")
                            if v9 and v9.Health > 0 then
                                return true
                            end
                        end
                    end
                end
            end
        end
        return false
    end
    local tbl5 = {t = 0, v = true}
    local function func9()
        local v1 = os.clock()
        if v1 - tbl5.t < 0.15 then
            return tbl5.v
        end
        tbl5.t = v1
        tbl5.v = not func8()
        return tbl5.v
    end
    getgenv().InstanceIsInActiveMatch = func8
    getgenv().InstanceIsInLobby = func9
    local tbl6 = {enabled = false}
    tbl6.character = nil
    tbl6.auto = false
    tbl6.autoshoot = true
    tbl6.shootAttempts = 3
    tbl6.hitpart = "Head"
    tbl6.lastchar = nil
    tbl6.lastplayer = nil
    tbl6.manualkey = false
    tbl6.immune = false
    tbl6.attackPosition = "default"
    tbl6.attackCustomEnabled = false
    tbl6.weaponPick = "any"
    tbl6.forceWeapon = true
    tbl6.rageMasterOn = false
    tbl6.meleeFeetDrop = 3.5
    tbl6.underOffset = 4
    tbl6.customHeight = 2
    tbl6.customFront = 0
    tbl6.customSide = 0
    tbl6.customVertical = 0
    tbl6.customRadius = 0
    local tbl7 = {
        enabled = false, multiplier = 1.2, velocity = Vector3.new(0, 0, 0),
        acceleration = Vector3.new(0, 0, 0),
    }
    tbl7.lastposition = nil
    tbl7.lasttime = 0
    tbl7.velbuffer = {}
    tbl7.posbuffer = {}
    tbl7.maxvelsamples = 15
    tbl7.maxpossamples = 5
    local tbl8 = {active = false, angle = 0}
    tbl8.serverpos = nil
    tbl8.connection = nil
    tbl8.speed = 9000
    tbl8.height = 1
    tbl8.radius = 0
    tbl8.originalpos = nil
    local tbl9 = {reloading = false, outofammo = false, csyncactive = false, reloadStartedAt = 0}
    local tbl10 = {enabled = true}
    tbl10.originalPosition = nil
    tbl10.active = false
    tbl10.connection = nil
    local tbl11 = {enabled = false, shoot_min = 1, shoot_max = 1, hide_min = 1, hide_max = 1}
    tbl11.phase = nil
    tbl11.lastswitch = 0
    tbl11.currentduration = 0
    local tbl12 = {
        target = tbl6, prediction = tbl7, orbit = tbl8, state = tbl9, voidhide = tbl10,
        voidspam = tbl11,
        flick = {enabled = false, shots = 3, attack = 0.35, hide = 0.7, count = 0},
        visualizer = {
            enabled = true,
            tracer = {
                color = Color3.fromRGB(0, 186, 255), thickness = 1, transparency = 1,
                start_point = "cursor", outline = true, outline_color = Color3.fromRGB(0, 0, 0),
                outline_thickness = 1,
            },
            indicator = {
                display_options = {"name", "position", "hit reg"},
                color = Color3.fromRGB(255, 255, 255), accent_color = Color3.fromRGB(0, 186, 255),
            },
        },
        hitNotifications = {
            enabled = true, color = Color3.fromRGB(235, 235, 235), textSize = 14, maxVisible = 8,
            duration = 3, stackGap = 6, position = "Top Left", offsetX = 12, offsetY = 12,
            inAnimation = "fade bounce", outAnimation = "fade", animInDuration = 0.52,
            animOutDuration = 0.38,
        },
        ragestatus = {
            enabled = false, mode = "static", color = Color3.fromRGB(235, 235, 235),
            staticOffsetX = 0, staticOffsetY = 40, showAmmo = true, hideOnReload = true,
            textSize = 15, lineGap = 15, fontName = "gotham",
        },
        hvh = {
            resolver = false, voidChase = true, exposureSnipe = true, serverLock = false,
            originSpoof = false, strafe = true, strafeR = 4, strafeH = 2, exposureUntil = {},
            lastGround = {}, wasVoid = {},
        },
    }
    local tbl13 = {
        lastAttackTick = 0, hitPartByPlayer = {}, lastHitAtByPlayer = {}, targetHudAt = 0,
        rageStatusAt = 0, restoreVisualAt = 0,
    }
    tbl13.killStartAt = nil
    tbl13.rageStatusCacheAt = 0
    tbl13.cachedRageStatusLine = ""
    tbl13.cachedRageStatusDetail = ""
    tbl13.lastRageStatusText = ""
    tbl13.lastRageDetailText = ""
    tbl13.lastRageAmmoText = ""
    tbl13.lastRageColor = nil
    local tbl14 = {active = false}
    tbl14.hrp = nil
    tbl14.mainConnection = nil
    tbl14.restoreConnection = nil
    tbl14.currentVoidPos = nil
    tbl14.lastTeleportTime = 0
    local LocalFighter = tbl1.fighter.LocalFighter
    local v20
    local drawing = Drawing.new("Circle")
    drawing.Thickness = 1.5
    drawing.NumSides = 36
    drawing.Filled = false
    drawing.Transparency = 1
    drawing.Visible = false
    drawing.Radius = 12
    drawing.Color = Color3.fromRGB(255, 50, 50)
    local drawing1 = Drawing.new("Circle")
    drawing1.Thickness = 4
    drawing1.NumSides = 36
    drawing1.Filled = false
    drawing1.Transparency = 1
    drawing1.Visible = false
    drawing1.Radius = 12
    drawing1.Color = Color3.fromRGB(0, 0, 0)
    local drawing2 = Drawing.new("Line")
    drawing2.Visible = false
    drawing2.Thickness = 2
    drawing2.Transparency = 1
    drawing2.Color = Color3.fromRGB(0, 186, 255)
    local drawing3 = Drawing.new("Line")
    drawing3.Visible = false
    drawing3.Thickness = 4
    drawing3.Transparency = 1
    drawing3.Color = Color3.fromRGB(0, 0, 0)
    local function func10()
        local ViewModels = v9:FindFirstChild("ViewModels")
        if not ViewModels then
            return nil
        end
        local FirstPerson = ViewModels:FindFirstChild("FirstPerson")
        if not FirstPerson then
            return nil
        end
        for _, v1 in ipairs(FirstPerson:GetChildren()) do
            local tbl = {}
            for k in v1.Name:gmatch("[^-]+") do
                table.insert(tbl, k:match("^%s*(.-)%s*$"))
            end
            if #tbl >= 2 then
                return tbl[2]
            end
        end
        return nil
    end
    local function func11()
        local ViewModels = v9:FindFirstChild("ViewModels")
        if not ViewModels then
            return nil
        end
        local FirstPerson = ViewModels:FindFirstChild("FirstPerson")
        if not FirstPerson then
            return nil
        end
        for _, v1 in pairs(FirstPerson:GetChildren()) do
            if v1.Name:find(LocalPlayer.Name) then
                local ItemVisual = v1:FindFirstChild("ItemVisual")
                if ItemVisual then
                    local Body = ItemVisual:FindFirstChild("Body")
                    if Body then
                        local BodyPrimary = Body:FindFirstChild("BodyPrimary")
                        if BodyPrimary then
                            local _muzzle = BodyPrimary:FindFirstChild("_muzzle")
                            if _muzzle then
                                return _muzzle.WorldPosition
                            end
                        end
                    end
                end
            end
        end
        return nil
    end
    local tbl15 = {primary = 1, secondary = 2, melee = 3}
    local tbl16 = {
        ["Battle Axe"] = true, Chainsaw = true, Daggers = true, Fists = true, Gunblade = true,
        Katana = true, Knife = true, Scythe = true, Trowel = true,
    }
    local tbl17 = {["Energy Rifle"] = true, ["Energy Pistols"] = true}
    local function func12()
        local v1 = func10()
        if not v1 then
            return false
        end
        return tbl17[v1] == true
    end
    local function func13(arg1)
        if type(arg1) ~= "string" or arg1 == "" then
            return false
        end
        if arg1:lower():find("melee", 1, true) then
            return true
        end
        return tbl16[arg1] == true
    end
    local function func14(arg1)
        if not arg1 then
            return false
        end
        local v1 = arg1:Get("Name")
        if func13(v1 or arg1.Name) then
            return true
        end
        local v2 = arg1:Get("ItemType") or arg1:Get("Type") or arg1:Get("Category")
        return type(v2) == "string" and v2:lower():find("melee", 1, true) ~= nil
    end
    local function func15(arg1)
        return arg1 and arg1:lower():find("slingshot", 1, true) ~= nil
    end
    local function func16()
        local v1 = tbl1.fighter and tbl1.fighter.LocalFighter
        if not v1 then
            return nil
        end
        return v1.Items
    end
    local function func17(arg1)
        local v1 = func16()
        if not v1 then
            return nil
        end
        if v1[arg1] then
            return v1[arg1]
        end
        if v1[tostring(arg1)] then
            return v1[tostring(arg1)]
        end
        for k, v2 in pairs(v1) do
            if v2 and typeof(v2) == "table" then
                if tonumber(v2:Get("Slot") or v2:Get("Index") or v2:Get("ItemSlot") or k) == arg1 then
                    return v2
                end
                local v3 = v2:Get("ItemType") or v2:Get("Type")
                if arg1 == 3 and (v3 == "Melee" or type(v3) == "string" and v3:lower():find(
                    "melee", 1, true
                )) then
                    return v2
                end
                if arg1 == 1 and (v3 == "Primary" or v3 == 1 or v3 == "1") then
                    return v2
                end
                if arg1 == 2 and (v3 == "Secondary" or v3 == 2 or v3 == "2") then
                    return v2
                end
            end
        end
        local tbl = {}
        for _, v4 in pairs(v1) do
            if v4 then
                tbl[#tbl + 1] = v4
            end
        end
        table.sort(
            tbl,
            function(arg1, arg2)
                return (tonumber(arg1:Get("Slot") or arg1:Get("Index")) or 99) < (tonumber(
                    arg2:Get("Slot") or arg2:Get("Index")
                ) or 99)
            end
        )
        return tbl[arg1]
    end
    local function func18(arg1)
        if not arg1 then
            return nil
        end
        local v1 = func16()
        local v2 = arg1:Get("ObjectID")
        if v1 and v2 then
            for i = 1, 3 do
                local v3 = v1[i] or v1[tostring(i)]
                if v3 and v3:Get("ObjectID") == v2 then
                    return 1
                end
            end
            for k, v4 in pairs(v1) do
                if v4 and v4:Get("ObjectID") == v2 then
                    local num = tonumber(k)
                    if num and num >= 1 and num <= 3 then
                        return num
                    end
                end
            end
        end
        if func14(arg1) then
            return 3
        end
        return nil
    end
    local function func19()
        if (tbl12.target.weaponPick or "any") == "any" then
            local v1, v2 = pcall(
                function()
                    local v1 = tbl1.fighter and tbl1.fighter.LocalFighter
                    local v2 = v1 and v1.EquippedItem
                    if not v2 then
                        return nil
                    end
                    local str = ""
                    local v3, v4 = pcall(
                        function()
                            return v2:Get("Name")
                        end
                    )
                    if v3 and v4 then
                        str = tostring(v4)
                    end
                    if str:lower():find("utility", 1, true) then
                        return 1
                    end
                    local v5 = func18(v2)
                    if v5 == 4 then
                        return 1
                    end
                    return v5
                end
            )
            if v1 then
                return v2
            end
            return nil
        end
        return tbl15[tbl12.target.weaponPick or "primary"] or 1
    end
    local function func20()
        return (tbl12.target.weaponPick or "primary") == "melee"
    end
    local function func21()
        if func12() then
            return nil, nil, false
        end
        local v1, v2 = pcall(
            function()
                return func(LocalPlayer.PlayerScripts.Controllers.FighterController)
            end
        )
        if v1 and v2 and v2.LocalFighter and v2.LocalFighter.EquippedItem then
            local EquippedItem = v2.LocalFighter.EquippedItem
            local flag = false
            pcall(
                function()
                    if func14(EquippedItem) then
                        flag = true
                    end
                end
            )
            if func20() then
                flag = true
            end
            local str = ""
            local num = 0
            local num1 = 0
            if not pcall(
                function()
                    str = tostring(EquippedItem:Get("Name") or EquippedItem.Name or "")
                    num = EquippedItem:Get("CurrentAmmo") or EquippedItem:Get("Ammo") or 0
                    num1 = EquippedItem:Get("MaxAmmo") or EquippedItem:Get("MaxBullets") or num
                    if type(str) == "string" and str:lower():find("melee", 1, true) then
                        flag = true
                    end
                    if tbl16[str] then
                        flag = true
                    end
                end
            ) then
                return 0, 0, flag
            end
            return tonumber(num) or 0, tonumber(num1) or 0, flag
        end
        return 0, 0, (func20())
    end
    local num = 0
    local function func22(arg1)
        if IS_MOBILE then
            return
        end
        pcall(
            function()
                local VirtualInputManager = game:GetService("VirtualInputManager")
                local v1 = Enum
                local v2 = ({v1.KeyCode.One, v1.KeyCode.Two, v1.KeyCode.Three})[arg1]
                if not v2 then
                    return
                end
                local v3 = game
                VirtualInputManager:SendKeyEvent(true, v2, false, v3)
                task.wait(0.02)
                VirtualInputManager:SendKeyEvent(false, v2, false, v3)
            end
        )
        if keypress then
            pcall(keypress, ({49, 50, 51})[arg1])
            task.wait(0.02)
            if keyrelease then
                pcall(keyrelease, ({49, 50, 51})[arg1])
            end
        end
    end
    local function func23()
        if v1.Toggles and v1.Toggles.TargetOn then
            return v1.Toggles.TargetOn.Value == true
        end
        return tbl12.target.rageMasterOn == true
    end
    local function func24()
        if not func23() then
            return
        end
        local v1 = func19()
        if v1 == nil then
            return
        end
        local v2 = tbl1.fighter and tbl1.fighter.LocalFighter
        if not v2 then
            return
        end
        local EquippedItem = v2.EquippedItem
        local v3, v4 = pcall(func18, EquippedItem)
        if EquippedItem and v3 and v4 == v1 then
            return
        end
        local v6 = tick()
        if v6 - num < 0.06 then
            return
        end
        num = v6
        local v9
        local v10
        pcall(
            function()
                v9 = func17(v1)
                v10 = v9 and v9:Get("ObjectID")
            end
        )
        if v10 then
            local UseItem
            pcall(
                function()
                    UseItem = v5.Remotes.Replication.Fighter.UseItem
                end
            )
            if UseItem then
                for _, v7 in ipairs({"Equip", "Switch", "Select", "EquipItem", "ChangeItem"}) do
                    pcall(
                        function()
                            local v1 = tbl1.enums:ToEnum(v7)
                            if v1 then
                                UseItem:FireServer(v10, v1, nil, nil)
                            end
                        end
                    )
                end
            end
        end
        local v8 = pcall
        v8(
            function()
                if v2.EquipItem then
                    v2:EquipItem(v1)
                end
                if v2.Equip then
                    v2:Equip(v1)
                end
                if v2.SwitchToSlot then
                    v2:SwitchToSlot(v1)
                end
            end
        )
        v8(
            function()
                local fighter = tbl1.fighter
                if fighter.EquipItem then
                    fighter:EquipItem(v1)
                end
                if fighter.SwitchItem then
                    fighter:SwitchItem(v1)
                end
            end
        )
        if not IS_MOBILE then
            func22(v1)
        end
    end
    local function func25()
        if func12() then
            return false
        end
        local v1 = tbl1.fighter and tbl1.fighter.LocalFighter
        if not v1 or not v1.EquippedItem then
            return false
        end
        local flag = false
        pcall(
            function()
                local EquippedItem = v1.EquippedItem
                for _, v2 in ipairs({"Reloading", "IsReloading", "IsReload"}) do
                    local v3 = EquippedItem:Get(v2)
                    if v3 == true or v3 == 1 or v3 == "true" then
                        flag = true
                        return
                    end
                end
            end
        )
        if flag then
            return true
        end
        local v2 = tbl12.state.reloadStartedAt or 0
        return v2 > 0 and tick() - v2 < 1.75
    end
    local function func26()
        if func12() then
            tbl12.state.outofammo = false
            tbl12.state.reloading = false
            tbl12.state.reloadStartedAt = 0
            return
        end
        local v1, _, v2 = func21()
        local outofammo = tbl12.state.outofammo
        if v2 then
            tbl12.state.outofammo = false
        else
            tbl12.state.outofammo = (tonumber(v1) or 0) <= 0
        end
        local v3 = func25()
        if v3 and not tbl12.state.reloading then
            tbl12.state.reloadStartedAt = tick()
        elseif not v3 then
            tbl12.state.reloadStartedAt = 0
        end
        tbl12.state.reloading = v3
        if tbl12.state.outofammo and not outofammo then
            if func15((func10())) then
                tbl12.voidspam.phase = "hide"
            end
        elseif not tbl12.state.outofammo and outofammo then
            if tbl12.voidspam.enabled then
                tbl12.voidspam.phase = "shoot"
                tbl12.voidspam.lastswitch = tick()
            else
                tbl12.voidspam.phase = nil
            end
        end
    end
    local function func27(arg1)
        if not (tbl12.state.reloading and tbl12.ragestatus.hideOnReload) then
            return false
        end
        local v1 = voidHrp()
        if v1 and not arg1 then
            snapVoid(v1)
            return true
        end
        local v2 = math.random(-10000, 10000)
        local v3 = math.random(-10000, 10000)
        tbl12.orbit.serverpos = Vector3.new(v2, -99999999999, v3)
        if arg1 and LocalFighter and LocalFighter.Entity and LocalFighter.Entity.RootPart then
            pcall(
                function()
                    LocalFighter.Entity.RootPart.CFrame = CFrame.new(tbl12.orbit.serverpos)
                end
            )
        end
        return true
    end
    local function func28(arg1)
        if not arg1 then
            return false
        end
        return LocalPlayer:GetAttribute("TeamID") == arg1:GetAttribute("TeamID")
    end
    local function func29(arg1)
        if not arg1 or not arg1.Parent then
            return false
        end
        local Humanoid = arg1:FindFirstChildOfClass("Humanoid")
        if not Humanoid or Humanoid.Health <= 0 then
            return false
        end
        if not arg1:FindFirstChild("HumanoidRootPart") then
            return false
        end
        local PlayerFromCharacter = v6:GetPlayerFromCharacter(arg1)
        if not PlayerFromCharacter or func28(PlayerFromCharacter) then
            return false
        end
        return true
    end
    local function func30(arg1)
        if not arg1 then
            return true
        end
        if arg1.Y < -350 then
            return true
        end
        if math.abs(arg1.X) > 8000 or math.abs(arg1.Z) > 8000 or arg1.Y < -500 then
            return true
        end
        return false
    end
    local function func31(arg1, arg2)
        local hvh = tbl12.hvh
        if not hvh then
            return false, nil
        end
        local v1 = arg2 and arg2.Position or nil
        local v2 = func30(v1)
        local v3 = arg1 and arg1.Name or tostring(arg2 and arg2.Parent)
        if not v2 and v1 then
            hvh.lastGround[v3] = v1
        end
        if hvh.resolver and hvh.exposureSnipe then
            if hvh.wasVoid[v3] and not v2 then
                hvh.exposureUntil[v3] = tick() + 1.2
            end
        end
        hvh.wasVoid[v3] = v2
        if v2 and hvh.resolver and hvh.voidChase then
            return true, hvh.lastGround[v3]
        end
        return v2, nil
    end
    local function func32()
        local touchCurrentPos
        if IS_MOBILE then
            if MOBILE_TOUCH_STATE.touching then
                touchCurrentPos = MOBILE_TOUCH_STATE.touchCurrentPos
            else
                local CurrentCamera1 = v9.CurrentCamera
                if CurrentCamera1 then
                    touchCurrentPos = Vector2.new(
                        CurrentCamera1.ViewportSize.X / 2, CurrentCamera1.ViewportSize.Y / 2
                    )
                else
                    touchCurrentPos = Vector2.zero
                end
            end
        else
            touchCurrentPos = v8:GetMouseLocation()
        end
        local v11
        local huge = math.huge
        for _, v1 in v6:GetPlayers() do
            if v1 ~= LocalPlayer and v1.Character then
                local Character = v1.Character
                if func29(Character) then
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                    local v2, v3 = func31(v1, HumanoidRootPart)
                    local v4 = v2 and v3 or HumanoidRootPart and HumanoidRootPart.Position
                    if HumanoidRootPart and v4 then
                        local v5, v7 = (getgenv().InstanceWorldToScreen or func5)(v4, CurrentCamera)
                        if v7 and v5 then
                            local Magnitude = (Vector2.new(v5.X, v5.Y) - touchCurrentPos).Magnitude
                            local v10 = tbl12.hvh and tbl12.hvh.exposureUntil[v1.Name]
                            if tbl12.hvh and tbl12.hvh.resolver and tbl12.hvh.exposureSnipe and v10 and tick(
                            ) < v10 then
                                Magnitude = Magnitude - 10000
                            end
                            if Magnitude < huge then
                                v11 = Character
                                huge = Magnitude
                            end
                        end
                    end
                end
            end
        end
        return v11
    end
    local function func33(arg1, arg2)
        if not arg1 then
            return nil
        end
        if arg2 == "Closest" then
            local v1 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(
                "HumanoidRootPart"
            )
            if not v1 then
                return arg1:FindFirstChild("Head")
            end
            local v3
            local huge = math.huge
            for _, v2 in pairs(arg1:GetChildren()) do
                if v2:IsA("BasePart") then
                    local Magnitude = (v2.Position - v1.Position).Magnitude
                    if Magnitude < huge then
                        huge = Magnitude
                        v3 = v2
                    end
                end
            end
            return v3 or arg1:FindFirstChild("Head")
        end
        if arg2 == "Random" then
            local tbl = {"Head", "HumanoidRootPart", "UpperTorso"}
            return arg1:FindFirstChild(tbl[math.random(#tbl)]) or arg1:FindFirstChild("Head")
        end
        return arg1:FindFirstChild(arg2) or arg1:FindFirstChild("Head")
    end
    local function func34()
        if not tbl12.target.character or not tbl12.prediction.enabled then
            tbl12.prediction.velocity = Vector3.new(0, 0, 0)
            tbl12.prediction.lastposition = nil
            return
        end
        local HumanoidRootPart = tbl12.target.character:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart then
            return
        end
        local v1 = tick()
        local v2 = v1 - tbl12.prediction.lasttime
        if v2 > 0 and v2 < 0.1 then
            local Position = HumanoidRootPart.Position
            if tbl12.prediction.lastposition then
                local v3 = (Position - tbl12.prediction.lastposition) / v2
                tbl12.prediction.velocity = tbl12.prediction.velocity:Lerp(v3, 0.6)
            end
            tbl12.prediction.lastposition = Position
            tbl12.prediction.lasttime = v1
        end
    end
    local function func35(arg1, arg2)
        if not tbl12.prediction.enabled or not arg1 then
            return arg1 and arg1.Position or Vector3.new()
        end
        local Position = arg1.Position
        local Magnitude = (Position - arg2).Magnitude
        local num = 0
        pcall(
            function()
                num = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
            end
        )
        local v1 = (Magnitude / 3000 + num) * tbl12.prediction.multiplier
        return Position + tbl12.prediction.velocity * v1
    end
    local function func36()
        local Character = LocalPlayer.Character
        if not Character then
            return false
        end
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if not Humanoid or Humanoid.Health <= 0 then
            return false
        end
        if func12() then
            return true
        end
        local v1, _, v2 = func21()
        if v1 == nil then
            return true
        end
        return v1 > 0 or v2
    end
    local function func37(arg1)
        return math.clamp(tonumber(arg1) or 1, 0.1, 2)
    end
    local function func38(arg1, arg2)
        local v1 = func37(arg1)
        local v2 = func37(arg2)
        if v2 < v1 then
            v2, v1 = v1, v2
        end
        if v1 == v2 then
            return v1
        end
        return v1 + math.random() * (v2 - v1)
    end
    local tbl18 = {}
    tbl18.cf = nil
    tbl18.lv = nil
    tbl18.av = nil
    local function func39()
        tbl18.cf = nil
        tbl18.lv = nil
        tbl18.av = nil
    end
    local function func40()
        local Character = LocalPlayer.Character
        return Character and Character:FindFirstChild("HumanoidRootPart")
    end
    local function func41(arg1, arg2, arg3, arg4)
        local v1 = math.random(arg1, arg2)
        while v1 >= arg3 and v1 <= arg4 do
            v1 = math.random(arg1, arg2)
        end
        return v1
    end
    local function func42(arg1)
        if not arg1 then
            return
        end
        if func9() then
            return
        end
        tbl18.cf = arg1.CFrame
        tbl18.lv = arg1.AssemblyLinearVelocity
        tbl18.av = arg1.AssemblyAngularVelocity
        pcall(
            function()
                local vector3 = Vector3.new(
                    func41(-2147483646, 2147483646, -1147483646, 1147483646),
                    func41(-2147483646, 2147483646, -1147483646, 1147483646),
                    (func41(-2147483646, 2147483646, -1147483646, 1147483646))
                )
                local vector31 = Vector3.new(
                    func41(-2147483646, 2147483646, -1147483646, 1147483646),
                    func41(-2147483646, 2147483646, -1147483646, 1147483646),
                    (func41(-2147483646, 2147483646, -1147483646, 1147483646))
                )
                arg1.CFrame = CFrame.new(vector3) * CFrame.Angles(math.pi, math.pi, math.pi)
                arg1.AssemblyLinearVelocity = vector31
                arg1.AssemblyAngularVelocity = vector31
            end
        )
    end
    v7:BindToRenderStep(
        "vfr_csync", Enum.RenderPriority.First.Value,
        function()
            if not tbl18.cf then
                return
            end
            local v1 = func40()
            if not v1 then
                return
            end
            pcall(
                function()
                    v1.CFrame = tbl18.cf
                    v1.AssemblyLinearVelocity = tbl18.lv
                    v1.AssemblyAngularVelocity = tbl18.av
                end
            )
        end
    )
    local function func43()
        local flag = false
        local v1 = tbl1.fighter and tbl1.fighter.LocalFighter
        local v2 = v1 and v1.EquippedItem
        if v2 then
            local v3, v4 = pcall(
                function()
                    return (func14(v2))
                end
            )
            flag = v3 and v4 and true or false
        end
        if (func20() or flag) and not tbl12.target.attackCustomEnabled then
            return {
                height = 0, front = 0, side = 0,
                vertical = -(tonumber(tbl12.target.meleeFeetDrop) or 3.5), radius = 0,
            }
        end
        if tbl12.target.attackCustomEnabled then
            return {
                height = tbl12.target.customHeight or 2, front = tbl12.target.customFront or 0,
                side = tbl12.target.customSide or 0, vertical = tbl12.target.customVertical or 0,
                radius = tbl12.target.customRadius or 0,
            }
        end
        local v5 = tbl12.target.attackPosition or "default"
        local v6 = func10()
        if v5 == "under" then
            return {
                height = 0, front = 0, side = 0, vertical = -(tbl12.target.underOffset or 4),
                radius = 0
            }
        end
        return {
            height = v6 and v6:lower():find("sniper") and 8 or 2, front = 0, side = 0, vertical = 0,
            radius = 0,
        }
    end
    local function func44(_)
        local v1 = func43()
        tbl12.orbit.height = v1.height
    end
    local function func45(arg1)
        if not arg1 then
            return Vector3.zero
        end
        local v1 = func43()
        local Position = arg1.Position
        local LookVector = arg1.CFrame.LookVector
        local RightVector = arg1.CFrame.RightVector
        return Position + LookVector * v1.front + RightVector * v1.side + Vector3.new(
            0, v1.vertical, 0
        )
    end
    local function func46()
        local v1 = func43()
        tbl12.orbit.radius = v1.radius or 0
    end
    local function func47()
        func44((func10()))
        func46()
    end
    local function func48()
        if not tbl12.state.csyncactive then
            return
        end
        if tbl12.orbit.connection then
            tbl12.orbit.connection:Disconnect()
            tbl12.orbit.connection = nil
        end
        tbl12.state.csyncactive = false
        tbl12.orbit.active = false
        func39()
        tbl12.voidspam.phase = nil
        if tbl12.orbit.savedpos and LocalFighter and LocalFighter.Entity and LocalFighter.Entity.RootPart and not getgenv(
        ).InstanceUndergroundEnabled then
            local v1, v2 = pcall(
                function()
                    return tbl12.orbit.savedpos
                end
            )
            if v1 and v2 then
                pcall(
                    function()
                        LocalFighter.Entity.RootPart.CFrame = v2
                    end
                )
            end
        end
        tbl12.orbit.serverpos = nil
        tbl12.orbit.savedpos = nil
        tbl12.voidspam.phase = nil
        v20 = nil
    end
    local function func49()
        return tbl12.voidspam.enabled and tbl12.voidspam.phase == "hide"
    end
    local function func50()
        if not tbl12.voidspam.enabled then
            return
        end
        local v1 = tick()
        local v2 = v1 - tbl12.voidspam.lastswitch
        if tbl12.voidspam.phase == "shoot" then
            if tbl12.flick and tbl12.flick.enabled and not tbl12.state.outofammo and not tbl12.state.reloading and v1 - (tbl12.flick.shootStart or v1) < 2 then
                tbl12.voidspam.lastswitch = v1
                return
            end
            if v2 >= tbl12.voidspam.currentduration then
                tbl12.voidspam.phase = "hide"
                tbl12.voidspam.currentduration = func38(
                    tbl12.voidspam.hide_min, tbl12.voidspam.hide_max
                )
                tbl12.voidspam.lastswitch = v1
            end
        elseif tbl12.voidspam.phase == "hide" then
            if v2 >= tbl12.voidspam.currentduration then
                tbl12.voidspam.phase = "shoot"
                tbl12.voidspam.currentduration = func38(
                    tbl12.voidspam.shoot_min, tbl12.voidspam.shoot_max
                )
                tbl12.voidspam.lastswitch = v1
                if tbl12.flick then
                    tbl12.flick.shootStart = v1
                end
            end
        else
            tbl12.voidspam.phase = "shoot"
            tbl12.voidspam.currentduration = func38(
                tbl12.voidspam.shoot_min, tbl12.voidspam.shoot_max
            )
            tbl12.voidspam.lastswitch = v1
            if tbl12.flick then
                tbl12.flick.shootStart = v1
            end
        end
    end
    local function func51()
        if not tbl12.voidspam.enabled then
            return
        end
        if func15((func10())) then
            return
        end
    end
    local function func52()
        tbl14.active = false
        tbl14.currentVoidPos = nil
        if tbl14.mainConnection then
            tbl14.mainConnection:Disconnect()
            tbl14.mainConnection = nil
        end
    end
    local function func53()
        if tbl12.state.csyncactive then
            return
        end
        if tbl12.target.immune then
            return
        end
        if not tbl12.target.character or not func29(tbl12.target.character) then
            return
        end
        func24()
        tbl12.state.csyncactive = true
        tbl12.orbit.active = true
        local v1 = func10()
        func44(v1)
        func46()
        if not tbl12.orbit.savedpos then
            if LocalFighter and LocalFighter.Entity and LocalFighter.Entity.RootPart then
                tbl12.orbit.savedpos = LocalFighter.Entity.RootPart.CFrame
            end
        end
        tbl12.orbit.connection = v7.Heartbeat:Connect(
            function(arg1)
                if not tbl12.state.csyncactive then
                    return
                end
                if tbl12.target.immune then
                    func48()
                    return
                end
                if not tbl12.target.character or not func29(tbl12.target.character) then
                    func48()
                    return
                end
                if not LocalFighter or not LocalFighter.Entity or not LocalFighter.Entity.RootPart then
                    func48()
                    return
                end
                if tbl12.target.immune then
                    func48()
                    return
                end
                func46()
                v20 = LocalFighter.Entity.RootPart.CFrame
                local function func()
                    if func20() then
                        return false
                    end
                    local v1 = tbl1.fighter and tbl1.fighter.LocalFighter
                    if not v1 or not v1.EquippedItem then
                        return false
                    end
                    local v2 = tostring(v1.EquippedItem:Get("Name") or ""):lower()
                    return v2:find("fist", 1, true) or v2:find("utility", 1, true)
                end
                local v1 = func10()
                local v2 = func15(v1)
                if func() then
                    return
                end
                func24()
                if func27(v2) then
                    return
                end
                if not v2 and tbl12.voidspam.enabled and not tbl12.target.immune then
                    func50()
                    if tbl12.voidspam.phase == "hide" then
                        local v3 = math.random(-10000, 10000)
                        local v4 = math.random(-10000, 10000)
                        tbl12.orbit.serverpos = Vector3.new(v3, -99999999999, v4)
                        pcall(
                            function()
                                LocalFighter.Entity.RootPart.CFrame = CFrame.new(
                                    tbl12.orbit.serverpos
                                )
                            end
                        )
                        return
                    end
                end
                if not tbl12.target.character then
                    func48()
                    return
                end
                local HumanoidRootPart = tbl12.target.character:FindFirstChild("HumanoidRootPart")
                if not HumanoidRootPart then
                    func48()
                    return
                end
                if not v2 and func49() then
                    local v5 = math.random(-10000, 10000)
                    local v6 = math.random(-10000, 10000)
                    tbl12.orbit.serverpos = Vector3.new(v5, -99999999999, v6)
                    pcall(
                        function()
                            LocalFighter.Entity.RootPart.CFrame = CFrame.new(tbl12.orbit.serverpos)
                        end
                    )
                    return
                end
                if v2 then
                    if tbl14 and tbl14.active then
                        local HumanoidRootPart1 = tbl12.target.character:FindFirstChild(
                            "HumanoidRootPart"
                        )
                        if HumanoidRootPart1 then
                            local Unit = Vector3.new(
                                HumanoidRootPart1.CFrame.LookVector.X, 0,
                                HumanoidRootPart1.CFrame.LookVector.Z
                            ).Unit
                            tbl12.orbit.serverpos = HumanoidRootPart1.Position + Vector3.new(
                                0, 15, 0
                            ) + Unit * 5
                        end
                    end
                end
                if tbl12.state.outofammo and not v2 and v1 and not func12() then
                    local v7 = func40()
                    if v7 then
                        func42(v7)
                    else
                        local v8 = math.random(-10000, 10000)
                        local v9 = math.random(-10000, 10000)
                        tbl12.orbit.serverpos = Vector3.new(v8, -99999999999, v9)
                        pcall(
                            function()
                                LocalFighter.Entity.RootPart.CFrame = CFrame.new(
                                    tbl12.orbit.serverpos
                                )
                            end
                        )
                    end
                    return
                end
                local v10 = func45(HumanoidRootPart)
                tbl12.orbit.angle = tbl12.orbit.angle + tbl12.orbit.speed * arg1
                local vector3 = Vector3.new(
                    math.cos(tbl12.orbit.angle) * tbl12.orbit.radius, tbl12.orbit.height,
                    math.sin(tbl12.orbit.angle) * tbl12.orbit.radius
                )
                if tbl12.hvh and tbl12.hvh.serverLock then
                    local v11 = tbl12.target.character and tbl12.target.character:FindFirstChild(
                        "Head"
                    )
                    local v12 = LocalFighter and LocalFighter.Entity and LocalFighter.Entity.RootPart
                    if v11 and v12 and (v11.Position - v12.Position).Magnitude <= 150 then
                        if tbl12.hvh.strafe then
                            local v13 = math.clamp(tonumber(tbl12.hvh.strafeR) or 4, 1, 6)
                            local v14 = math.clamp(tonumber(tbl12.hvh.strafeH) or 2, -2, 6)
                            tbl12.orbit.serverpos = v11.Position + Vector3.new(
                                math.random() * 2 * v13 - v13, v14 + (math.random() * 4 - 2),
                                math.random() * 2 * v13 - v13
                            )
                        else
                            tbl12.orbit.serverpos = v11.Position + Vector3.new(0, 0.5, 0)
                        end
                    else
                        tbl12.orbit.serverpos = v10 + vector3
                    end
                else
                    tbl12.orbit.serverpos = v10 + vector3
                end
                if not getgenv().InstanceUndergroundEnabled then
                    if LocalFighter and LocalFighter.Entity and LocalFighter.Entity.RootPart then
                        local CFrame1 = LocalFighter.Entity.RootPart.CFrame
                        local cFrame = CFrame.new(tbl12.orbit.serverpos)
                        if (cFrame.Position - CFrame1.Position).Magnitude < 2000 then
                            LocalFighter.Entity.RootPart.CFrame = cFrame
                            if tbl12.orbit.savedpos == nil then
                                tbl12.orbit.savedpos = CFrame1
                            end
                        end
                    end
                end
            end
        )
    end
    local function func54()
        if not func15((func10())) and tbl12.voidspam.enabled and tbl12.voidspam.phase == "hide" then
            return
        end
        if not tbl12.target.enabled or not tbl12.target.character or not tbl12.target.autoshoot then
            return
        end
        if tbl12.target.immune then
            return
        end
        if not func15((func10())) and tbl12.voidspam.enabled and tbl12.voidspam.phase == "hide" then
            return
        end
        if tbl12.voidspam.enabled and tbl12.voidspam.phase == "hide" then
            return
        end
        local v1 = func10()
        local v2 = func15(v1)
        func24()
        local v3 = tbl1.fighter and tbl1.fighter.LocalFighter
        if not v3 or not v3.EquippedItem then
            return
        end
        if not func12() then
            if tbl12.state.reloading or tbl12.state.outofammo then
                return
            end
            if not func36() then
                return
            end
        end
        local character = tbl12.target.character
        if not func29(character) then
            return
        end
        local v4 = func33(character, tbl12.target.hitpart)
        if not v4 then
            return
        end
        if tbl12.hvh and tbl12.hvh.resolver then
            local v6 = tbl12.prediction and tbl12.prediction.velocity
            if v6 and v6.Magnitude > 150 then
                local v7 = func33(character, "Closest")
                if v7 then
                    v4 = v7
                end
            end
        end
        if tbl12.hvh and tbl12.hvh.resolver then
            local v8 = v4 and v4.Position or nil
            if v8 and func30(v8) then
                return
            end
        end
        local v10
        if tbl14 and tbl14.active and v2 then
            local v9 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(
                "HumanoidRootPart"
            )
            v10 = v9 and v9.Position or Vector3.new()
        elseif tbl14 and tbl14.active then
            local v11 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(
                "HumanoidRootPart"
            )
            v10 = v11 and v11.Position or Vector3.new()
        elseif tbl12.state.csyncactive and tbl12.orbit.serverpos then
            v10 = tbl12.orbit.serverpos
        else
            local v12 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(
                "HumanoidRootPart"
            )
            v10 = v12 and v12.Position or Vector3.new()
        end
        local v13 = func35(v4, v10)
        if tbl12.hvh and tbl12.hvh.originSpoof and tbl12.hvh.serverLock then
            v10 = v10 + Vector3.new(
                math.random(-200, 200), math.random(-50, 50), math.random(-200, 200)
            )
            v13 = func35(v4, v10)
        end
        local tbl = {}
        local v14 = utf8.char(1)
        local tbl2 = {}
        tbl2[utf8.char(0)] = tbl1.utility:EncodeCFrame(CFrame.new(v10, v13))
        tbl2[utf8.char(1)] = tbl1.utility:EncodeCFrame(CFrame.new(v10, v13))
        tbl2[utf8.char(2)] = v4
        tbl2[utf8.char(3)] = tbl1.utility:EncodeCFrame(CFrame.new(0.43, 0.25, 0.42))
        tbl[v14] = tbl2
        local EquippedItem = v3.EquippedItem
        if EquippedItem and EquippedItem:Get("ObjectID") then
            tbl13.lastAttackTick = tick()
            for _ = 1, math.clamp(math.floor(tonumber(tbl12.target.shootAttempts) or 1), 1, 3) do
                pcall(
                    function()
                        v5.Remotes.Replication.Fighter.UseItem:FireServer(
                            EquippedItem:Get("ObjectID"), tbl1.enums:ToEnum("StartShooting"), tbl,
                            nil
                        )
                    end
                )
            end
            func51()
        end
    end
    local Update = tbl1.camcontrol.Update
    tbl1.camcontrol.Update = function(...)
        if getgenv().InstanceUndergroundEnabled then
            return Update(...)
        end
        if tbl12.state.csyncactive and LocalFighter and LocalFighter.Entity and LocalFighter.Entity.RootPart and v20 then
            LocalFighter.Entity.RootPart.CFrame = v20
        end
        return Update(...)
    end
    local tbl19 = {}
    local tbl20 = {}
    local tbl21 = {}
    local function func55(arg1)
        table.insert(tbl20, arg1)
    end
    local function func56(arg1)
        table.insert(tbl21, arg1)
    end
    v7.Heartbeat:Connect(
        function()
            if not tbl12.target.enabled then
                return
            end
            for _, v1 in pairs(v6:GetPlayers()) do
                if v1 ~= LocalPlayer then
                    local Character = v1.Character
                    local v2 = Character and Character:FindFirstChild("HumanoidRootPart")
                    local v3 = v2 and v2:FindFirstChild("Attachment") ~= nil
                    if v3 and not tbl19[v1.Name] then
                        tbl19[v1.Name] = true
                        for _, v4 in pairs(tbl20) do
                            v4(v1)
                        end
                    elseif not v3 and tbl19[v1.Name] then
                        tbl19[v1.Name] = nil
                        for _, v5 in pairs(tbl21) do
                            v5(v1)
                        end
                    end
                end
            end
        end
    )
    func55(
        function(arg1)
            if tbl12.target.lastplayer == arg1 then
                tbl12.target.immune = true
                tbl12.voidspam.phase = nil
                func39()
                drawing.Color = Color3.fromRGB(180, 0, 255)
                func48()
            end
        end
    )
    func56(
        function(arg1)
            if tbl12.target.lastplayer == arg1 then
                tbl12.target.immune = false
                drawing.Color = Color3.fromRGB(255, 50, 50)
                if tbl12.target.enabled and tbl12.target.character and func29(
                    tbl12.target.character
                ) then
                    func53()
                end
            end
        end
    )
    local function func57()
        tbl12.target.enabled = false
        func48()
        tbl12.target.character = nil
        tbl12.target.lastchar = nil
        tbl12.target.lastplayer = nil
        tbl12.target.manualkey = false
        tbl12.target.immune = false
        drawing.Color = Color3.fromRGB(255, 50, 50)
    end
    local function func58(arg1)
        if not arg1 then
            return
        end
        local PlayerFromCharacter = v6:GetPlayerFromCharacter(arg1)
        tbl12.target.enabled = true
        tbl12.target.character = arg1
        tbl12.target.lastchar = arg1
        tbl12.target.lastplayer = PlayerFromCharacter
        tbl12.target.immune = false
        drawing.Color = Color3.fromRGB(255, 50, 50)
        local HumanoidRootPart = arg1:FindFirstChild("HumanoidRootPart")
        if HumanoidRootPart and HumanoidRootPart:FindFirstChild("Attachment") then
            tbl12.target.immune = true
            drawing.Color = Color3.fromRGB(180, 0, 255)
        else
            func24()
            func53()
        end
    end
    local tbl22 = {enabled = false, connections = {}}
    local function func59()
        return (func15((func10())))
    end
    local function func60()
        local v1 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(
            "HumanoidRootPart"
        )
        if not v1 then
            return nil
        end
        local v4
        local huge = math.huge
        for _, v2 in ipairs(v6:GetPlayers()) do
            if v2 ~= LocalPlayer and v2.Character then
                local v3 = v2.Character:FindFirstChild("HitboxHead") or v2.Character:FindFirstChild(
                    "Head"
                )
                if v3 then
                    local Magnitude = (v3.Position - v1.Position).Magnitude
                    if Magnitude < huge then
                        v4 = v3
                        huge = Magnitude
                    end
                end
            end
        end
        return v4
    end
    local function func61()
        if tbl22.connections.touch then
            return
        end
        tbl22.connections.touch = v9.DescendantAdded:Connect(
            function(arg1)
                if arg1:IsA("BasePart") or arg1:IsA("Model") then
                    if arg1.Name == "Slingshot" or arg1.Name == "CoreProjectile" or arg1.Name == "OuterProjectile" then
                        task.spawn(
                            function()
                                task.wait(0.06)
                                local v1 = arg1:IsA("BasePart") and arg1 or arg1:FindFirstChildWhichIsA(
                                    "BasePart"
                                )
                                if not v1 then
                                    return
                                end
                                v1.CanTouch = true
                                for _ = 1, 60 do
                                    if not v1.Parent or not v1:IsDescendantOf(v9) then
                                        break
                                    end
                                    local v2 = func60()
                                    if v2 and v2:IsA("BasePart") and v2.Parent and v2:IsDescendantOf(
                                        v9
                                    ) then
                                        local v3 = pcall
                                        local v4 = firetouchinterest
                                        v3(v4, v2, v1, 0)
                                        v3(v4, v2, v1, 1)
                                    end
                                    task.wait()
                                end
                            end
                        )
                    end
                end
            end
        )
    end
    local function func62()
        if tbl22.connections.touch then
            tbl22.connections.touch:Disconnect()
            tbl22.connections.touch = nil
        end
    end
    local function func63()
        local v2 = func59()
        local v3 = tbl12.target.enabled and tbl12.target.character ~= nil
        if v2 then
            if not tbl22.enabled then
                tbl22.enabled = true
                func61()
            end
            if getgenv().InstanceSetUnderground then
                getgenv().InstanceSetUnderground(true)
            end
            tbl14.active = v3
            if v3 and not tbl12.state.csyncactive then
                func53()
            elseif not v3 and tbl12.state.csyncactive and not tbl12.target.enabled then
                func48()
            end
        else
            if tbl22.enabled then
                tbl22.enabled = false
                func62()
            end
            local AntiAimUnderground = v1.Toggles.AntiAimUnderground
            if not (AntiAimUnderground and AntiAimUnderground.Value) then
                if getgenv().InstanceSetUnderground then
                    getgenv().InstanceSetUnderground(false)
                end
            end
            tbl14.active = false
        end
    end
    local function func64()
        local v1 = tbl12.target.enabled and tbl12.target.character and func29(
            tbl12.target.character
        )
        local v2 = func59()
        if v1 and v2 then
            pcall(
                function()
                    setfflag("TargetTimeDelayFacctorTenths", "999999")
                end
            )
        else
            pcall(
                function()
                    setfflag("TargetTimeDelayFacctorTenths", "1")
                end
            )
        end
    end
    local v11 = tick()
    v7.RenderStepped:Connect(
        function()
            local v1 = getgenv().InstanceIsInLobby and getgenv().InstanceIsInLobby()
            local v2 = tbl12.visualizer.enabled or tbl12.ragestatus and tbl12.ragestatus.enabled or tbl12.hitNotifications and tbl12.hitNotifications.enabled or tbl12.target.enabled and tbl12.target.character and tbl12.prediction.enabled
            if v1 and not v2 then
                return
            end
            if func2() then
                drawing2.Visible = false
                drawing3.Visible = false
                if tbl.hideRageStatus then
                    tbl.hideRageStatus()
                end
                if tbl.updateHitNotifications then
                    tbl.updateHitNotifications(0)
                end
                return
            end
            local v3 = tick()
            local v4 = math.clamp(v3 - v11, 0, 0.05)
            v11 = v3
            if tbl12.ragestatus and tbl12.ragestatus.enabled and tbl.drawStatus then
                tbl.drawStatus()
            elseif tbl.hideRageStatus then
                tbl.hideRageStatus()
            end
            if tbl.updateHitNotifications then
                tbl.updateHitNotifications(v4)
            end
            if tbl12.target.enabled and tbl12.target.character and tbl12.prediction.enabled then
                func34()
            end
        end
    )
    v7.Heartbeat:Connect(
        function()
            func64()
            func63()
            func26()
            if tbl12.target.auto and not tbl12.target.manualkey then
                local v1, _, v2 = func21()
                if (v1 == nil or v1 > 0 or v2) and not tbl12.state.reloading then
                    if not tbl12.target.enabled or not tbl12.target.character or not func29(
                        tbl12.target.character
                    ) then
                        local v3 = func32()
                        if v3 then
                            if tbl12.target.enabled then
                                func48()
                            end
                            func58(v3)
                        end
                    end
                end
            end
            if tbl12.target.enabled and tbl12.target.character then
                if not func29(tbl12.target.character) then
                    func57()
                    return
                end
                func24()
                if tbl12.target.autoshoot and not tbl12.target.immune then
                    func54()
                end
                if tbl12.flick and tbl12.flick.enabled then
                    if tbl12.state.outofammo or tbl12.state.reloading then
                        tbl12.flick.count = 0
                        tbl12.voidspam.phase = "hide"
                        tbl12.voidspam.currentduration = func37(tbl12.flick.hide)
                        tbl12.voidspam.lastswitch = tick()
                    end
                end
            end
        end
    )
    tbl.config = tbl12
    tbl.nearest = func32
    tbl.settarget = func58
    tbl.cleartarget = func57
    tbl.stopvoid = func52
    tbl.vhState = tbl14
    tbl.ragePerf = tbl13
    tbl.getammo = func21
    tbl.muzzlepos = func11
    tbl.valid = func29
    tbl.player = LocalPlayer
    tbl.eqSlot = func24
    tbl.refreshAtk = func47
    local function func65()
        local v1, v2 = pcall(
            function()
                return Drawing.new("Text")
            end
        )
        local v6
        if v1 and v2 ~= nil then
            local v3 = getgenv and getgenv().InstanceTrackDrawingText
            if type(v3) == "function" then
                local v4, v5 = pcall(v3, v2)
                v6 = v4 and v5 or v2
            else
                v6 = v2
            end
        else
            v6 = {}
        end
        v6.Size = 13
        v6.Font = 2
        v6.Outline = true
        v6.Center = true
        v6.Visible = false
        v6.Color = tbl12.ragestatus.color
        pcall(
            function()
                v6.OutlineColor = Color3.fromRGB(0, 0, 0)
            end
        )
        return v6
    end
    local v12 = func65()
    local v13 = func65()
    local function func66(arg1)
        arg1.Size = 13
        arg1.Font = 2
        arg1.Outline = true
        arg1.Color = tbl12.ragestatus.color
        pcall(
            function()
                arg1.OutlineColor = Color3.fromRGB(0, 0, 0)
            end
        )
    end
    local function func67()
        if tbl12.ragestatus.mode == "muzzle" then
            local v1 = func11 and func11()
            if v1 then
                local v2, v3 = (getgenv().InstanceWorldToScreen or func5)(v1, CurrentCamera)
                if v3 and v2 then
                    return Vector2.new(v2.X, v2.Y)
                end
            end
        end
        local v4 = CurrentCamera or v9.CurrentCamera
        if not v4 then
            return Vector2.zero
        end
        return v4.ViewportSize / 2 + Vector2.new(
            tbl12.ragestatus.staticOffsetX or 0, tbl12.ragestatus.staticOffsetY or 0
        )
    end
    local function func68()
        return tbl12.target.enabled or tbl12.target.auto or tbl12.voidspam.enabled
    end
    local function func69()
        if tbl12.target.lastplayer then
            return tbl12.target.lastplayer.Name
        end
        if tbl12.target.character then
            local PlayerFromCharacter = game:GetService("Players"):GetPlayerFromCharacter(
                tbl12.target.character
            )
            if PlayerFromCharacter then
                return PlayerFromCharacter.Name
            end
        end
        return "target"
    end
    local function func70()
        if tbl14.active then
            return true
        end
        if tbl12.voidspam.enabled and tbl12.voidspam.phase == "hide" and func15((func10())) then
            return true
        end
        if tbl12.state.reloading and tbl12.ragestatus.hideOnReload ~= false then
            return true
        end
        return false
    end
    local function func71()
        if not func68() then
            return false
        end
        if tbl12.state.reloading or func70() then
            return false
        end
        if tbl12.target.immune then
            return false
        end
        if not tbl12.target.enabled or not tbl12.target.character or not func29(
            tbl12.target.character
        ) then
            return false
        end
        if tbl12.state.csyncactive then
            return true
        end
        if tbl12.voidspam.enabled and tbl12.voidspam.phase == "shoot" and func15((func10())) then
            return true
        end
        if tick() - (tbl13.lastAttackTick or 0) < 0.45 then
            return true
        end
        return false
    end
    local function func72()
        if func12() then
            return "∞"
        end
        local v1, v2, v3 = func21()
        if v1 == nil then
            return "∞"
        end
        if v3 then
            return "melee"
        end
        return string.format("%d/%d", math.floor(v1 or 0), math.max(math.floor(v2 or 0), 0))
    end
    local function func73(arg1, arg2)
        local v1 = func37(arg1)
        local v2 = func37(arg2)
        if v2 < v1 then
            v2, v1 = v1, v2
        end
        if math.abs(v1 - v2) < 0.05 then
            return string.format("%.1fs", v1)
        end
        return string.format("%.1f-%.1fs", v1, v2)
    end
    local function func74()
        if not tbl12.voidspam.enabled then
            return ""
        end
        local voidspam = tbl12.voidspam
        return string.format(
            "void %s atk · %s hide", func73(voidspam.shoot_min, voidspam.shoot_max),
            func73(voidspam.hide_min, voidspam.hide_max)
        )
    end
    local function func75()
        local v1 = tick()
        if func71() then
            if not tbl13.killStartAt then
                tbl13.killStartAt = v1
            end
        else
            tbl13.killStartAt = nil
        end
        if tbl12.state.reloading then
            return "ragebot: void hide", "reloading"
        end
        if func70() then
            local v2 = func74()
            return "ragebot: void hide", v2 ~= "" and v2 or ""
        end
        if func71() then
            local v3 = func69()
            local v4 = v1 - (tbl13.killStartAt or v1)
            local v5 = tbl12.target.character and tbl12.target.character:FindFirstChildOfClass(
                "Humanoid"
            )
            local v6 = string.format("ragebot : attacking (%s) · %.1fs", v3, v4)
            local tbl = {}
            local v7 = v5 and string.format("%.0f hp", v5.Health)
            tbl[#tbl + 1] = v7 or "hp ?"
            local v8 = func74()
            if v8 ~= "" then
                tbl[#tbl + 1] = v8
            end
            return v6, table.concat(tbl, " · ")
        end
        if func68() and tbl12.target.enabled and tbl12.target.character then
            local Humanoid = tbl12.target.character:FindFirstChildOfClass("Humanoid")
            return
                "ragebot: ready", Humanoid and string.format("%.0f hp", Humanoid.Health) or "locked"
        end
        return "ragebot: idle", ""
    end
    tbl.drawStatus = function()
        if not tbl12.ragestatus.enabled or func2() then
            v12.Visible = false
            v13.Visible = false
            return
        end
        local v1 = func67()
        local v2 = tbl12.ragestatus.lineGap or 14
        local v3 = tbl12.ragestatus.showAmmo ~= false
        if tbl13.lastRageColor ~= tbl12.ragestatus.color then
            tbl13.lastRageColor = tbl12.ragestatus.color
            func66(v12)
            func66(v13)
        end
        local v4, v5 = func75()
        local v6 = v3 and func72() or ""
        local v7 = v5
        if v5 ~= "" and v6 ~= "" then
            v7 = v5 .. " · " .. v6
        elseif v5 == "" then
            v7 = v6
        end
        local v8 = -(1 + (v7 ~= "" and 1 or 0) - 1) * (v2 / 2)
        if v4 ~= tbl13.lastRageStatusText then
            tbl13.lastRageStatusText = v4
            v12.Text = v4
        end
        v12.Position = v1 + Vector2.new(0, v8)
        v12.Visible = tbl12.ragestatus.enabled
        local v9 = v8 + v2
        if v7 ~= "" then
            if v7 ~= tbl13.lastRageDetailText then
                tbl13.lastRageDetailText = v7
                v13.Text = v7
            end
            v13.Position = v1 + Vector2.new(0, v9)
            v13.Visible = tbl12.ragestatus.enabled
        else
            tbl13.lastRageDetailText = ""
            v13.Visible = false
        end
    end
    tbl.hideRageStatus = function()
        v12.Visible = false
        v13.Visible = false
    end
    tbl.clrVoidSnap = func39
    local function func76()
        if tbl12.target.auto then
            return
        end
        if tbl12.target.enabled and tbl12.target.character then
            func57()
        else
            local v1 = func32()
            if v1 then
                tbl12.target.manualkey = true
                func58(v1)
            end
        end
    end
    local tbl23 = {targetgroup = _raw:AddRightTabbox()}
    tbl23.ragebottab = tbl23.targetgroup:AddTab("Ragebot")
    tbl23.ragebotvisualtab = tbl23.targetgroup:AddTab("Visualizer")
    tbl23.ragebottab:AddToggle(
        "TargetOn",
        {
            Text = "Enable", Default = false,
            Callback = function(arg1)
                tbl12.target.rageMasterOn = arg1
                if tbl12.target.auto then
                    return
                end
                if arg1 then
                    local v1 = func32()
                    if v1 then
                        tbl12.target.manualkey = true
                        func58(v1)
                    end
                else
                    func57()
                end
            end,
        }
    ):AddKeyPicker(
        "TargetKey",
        {
            Text = "Ragebot", Default = "None", Mode = "Toggle",
            Callback = function()
                func76()
            end,
        }
    )
    tbl23.ragebottab:AddToggle(
        "AutoTarget",
        {
            Text = "Auto Target", Default = false,
            Callback = function(arg1)
                tbl12.target.auto = arg1
            end,
        }
    )
    local tbl24 = {Type = "Toggle", Value = false}
    local tbl25 = {Type = "Toggle", Value = false}
    local function func77()
        local v1 = tbl12.target.attackCustomEnabled == true
        tbl24.Value = (tbl12.target.attackPosition or "default") == "under" and not v1
        tbl25.Value = v1
        if attackUnderDep and attackUnderDep.Update then
            attackUnderDep:Update()
        end
        if attackCustomDep and attackCustomDep.Update then
            attackCustomDep:Update()
        end
    end
    tbl23.ragebottab:AddDropdown(
        "AutoTargetAttackPos",
        {
            Text = "attack position", Default = "default", Values = {"default", "under"},
            Callback = function(arg1)
                tbl12.target.attackPosition = arg1
                func77()
                if tbl12.state.csyncactive and tbl.refreshAtk then
                    tbl.refreshAtk()
                end
            end,
        }
    )
    tbl23.ragebottab:AddToggle(
        "AttackCustomOverride",
        {
            Text = "attack position", Default = false,
            Tooltip = "overrides attack position dropdown when enabled",
            Callback = function(arg1)
                tbl12.target.attackCustomEnabled = arg1
                func77()
                if tbl12.state.csyncactive and tbl.refreshAtk then
                    tbl.refreshAtk()
                end
            end,
        }
    )
    local v14 = tbl23.ragebottab:AddDependencyBox()
    v14:AddSlider(
        "UnderAttackOffset",
        {
            Text = "Under Offset", Default = tbl12.target.underOffset, Min = 1, Max = 25,
            Rounding = 1, Compact = true,
            Callback = function(arg1)
                tbl12.target.underOffset = arg1
                if tbl12.target.attackPosition == "under" and not tbl12.target.attackCustomEnabled and tbl12.state.csyncactive and tbl.refreshAtk then
                    tbl.refreshAtk()
                end
            end,
        }
    )
    v14:SetupDependencies({{tbl24, true}})
    local v15 = tbl23.ragebottab:AddDependencyBox()
    local function func78()
        if tbl12.target.attackCustomEnabled and tbl12.state.csyncactive and tbl.refreshAtk then
            tbl.refreshAtk()
        end
    end
    v15:AddSlider(
        "CustomAttackHeight",
        {
            Text = "Orbit Height", Default = tbl12.target.customHeight, Min = -25, Max = 30,
            Rounding = 1, Compact = true,
            Callback = function(arg1)
                tbl12.target.customHeight = arg1
                func78()
            end,
        }
    )
    v15:AddSlider(
        "CustomAttackFront",
        {
            Text = "Front Offset", Default = tbl12.target.customFront, Min = -20, Max = 20,
            Rounding = 1, Compact = true,
            Callback = function(arg1)
                tbl12.target.customFront = arg1
                func78()
            end,
        }
    )
    v15:AddSlider(
        "CustomAttackSide",
        {
            Text = "Side Offset", Default = tbl12.target.customSide, Min = -20, Max = 20,
            Rounding = 1, Compact = true,
            Callback = function(arg1)
                tbl12.target.customSide = arg1
                func78()
            end,
        }
    )
    v15:AddSlider(
        "CustomAttackVertical",
        {
            Text = "Vertical Offset", Default = tbl12.target.customVertical, Min = -25, Max = 30,
            Rounding = 1, Compact = true,
            Callback = function(arg1)
                tbl12.target.customVertical = arg1
                func78()
            end,
        }
    )
    v15:AddSlider(
        "CustomAttackRadius",
        {
            Text = "Orbit Radius", Default = tbl12.target.customRadius, Min = 0, Max = 25,
            Rounding = 1, Compact = true,
            Callback = function(arg1)
                tbl12.target.customRadius = arg1
                func78()
            end,
        }
    )
    v15:SetupDependencies({{tbl25, true}})
    func77()
    task.defer(func77)
    tbl23.ragebottab:AddDropdown(
        "RageWeaponPick",
        {
            Text = "Weapon", Default = tbl12.target.weaponPick or "any",
            Values = {"any", "primary", "secondary", "melee"},
            Callback = function(arg1)
                tbl12.target.weaponPick = arg1
                if tbl12.state.csyncactive and tbl.refreshAtk then
                    tbl.refreshAtk()
                end
                if tbl.eqSlot then
                    tbl.eqSlot()
                end
            end,
        }
    )
    tbl23.ragebottab:AddSlider(
        "ShootAttempts",
        {
            Text = "Shoot Attempts", Default = 3, Min = 1, Max = 3, Rounding = 0, Suffix = "x",
            Callback = function(arg1)
                tbl12.target.shootAttempts = math.clamp(math.floor(tonumber(arg1) or 1), 1, 3)
            end,
        }
    )
    tbl23.ragebottab:AddDropdown(
        "TargetPart",
        {
            Text = "Hit Part", Default = "Head",
            Values = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "Closest", "Random"},
            Callback = function(arg1)
                tbl12.target.hitpart = arg1
            end,
        }
    )
    tbl23.ragebottab:AddToggle(
        "PredictT",
        {
            Text = "Prediction", Default = false,
            Callback = function(arg1)
                tbl12.prediction.enabled = arg1
            end,
        }
    )
    tbl23.ragebottab:AddSlider(
        "PredictMul",
        {
            Text = "Prediction Mult", Default = 1.2, Min = 0.1, Max = 3, Rounding = 1,
            Callback = function(arg1)
                tbl12.prediction.multiplier = arg1
            end,
        }
    )
    tbl23.ragebottab:AddToggle(
        "VoidSpam",
        {
            Text = "Voidspam", Default = false,
            Callback = function(arg1)
                tbl12.voidspam.enabled = arg1
                if arg1 then
                    if tbl12.target.immune then
                        tbl12.voidspam.phase = nil
                        return
                    end
                    if func15((func10())) then
                        tbl12.voidspam.lastswitch = tick()
                        tbl12.voidspam.phase = "shoot"
                        tbl12.voidspam.currentduration = func38(
                            tbl12.voidspam.shoot_min, tbl12.voidspam.shoot_max
                        )
                    else
                        tbl12.voidspam.phase = nil
                    end
                else
                    tbl12.voidspam.phase = nil
                    if tbl.clrVoidSnap then
                        tbl.clrVoidSnap()
                    end
                end
            end,
        }
    )
    tbl23.ragebottab:AddSlider(
        "VoidShootTime",
        {
            Default = 1, Text = "Attack", Min = 0.1, Max = 2, Rounding = 1, Compact = true,
            Callback = function(arg1)
                local v1 = func37(arg1)
                tbl12.voidspam.shoot_min = v1
                tbl12.voidspam.shoot_max = v1
            end,
        }
    )
    tbl23.ragebottab:AddSlider(
        "VoidHideTime",
        {
            Default = 1, Text = "Hide", Min = 0.1, Max = 2, Rounding = 1, Compact = true,
            Callback = function(arg1)
                local v1 = func37(arg1)
                tbl12.voidspam.hide_min = v1
                tbl12.voidspam.hide_max = v1
            end,
        }
    )
    local v16 = tbl23.ragebotvisualtab:AddToggle(
        "RageStatus",
        {
            Text = "Rage Status", Default = tbl12.ragestatus.enabled,
            Callback = function(arg1)
                tbl12.ragestatus.enabled = arg1
                if arg1 then
                    if tbl.drawStatus then
                        tbl.drawStatus()
                    end
                elseif tbl.hideRageStatus then
                    tbl.hideRageStatus()
                end
            end,
        }
    ):AddColorPicker(
        "RageStatusColor",
        {
            Title = "text color", Default = tbl12.ragestatus.color,
            Callback = function(arg1)
                tbl12.ragestatus.color = arg1
                if tbl.ragePerf then
                    tbl.ragePerf.lastRageColor = nil
                end
            end,
        }
    )
    local v17 = tbl23.ragebotvisualtab:AddDependencyBox()
    v17:SetupDependencies({{v16, true}})
    v17:AddDropdown(
        "RageStatusMode",
        {
            Text = "Position", Default = "static", Values = {"static", "muzzle"},
            Callback = function(arg1)
                tbl12.ragestatus.mode = arg1
            end,
        }
    )
    v17:AddSlider(
        "RageStatusStaticX",
        {
            Text = "Static X", Default = tbl12.ragestatus.staticOffsetX, Min = -500, Max = 500,
            Rounding = 0, Compact = true,
            Callback = function(arg1)
                tbl12.ragestatus.staticOffsetX = arg1
            end,
        }
    )
    v17:AddSlider(
        "RageStatusStaticY",
        {
            Text = "Static Y", Default = tbl12.ragestatus.staticOffsetY, Min = -500, Max = 500,
            Rounding = 0, Compact = true,
            Callback = function(arg1)
                tbl12.ragestatus.staticOffsetY = arg1
            end,
        }
    )
    v17:AddToggle(
        "RageStatusAmmo",
        {
            Text = "Show Ammo Line", Default = true,
            Callback = function(arg1)
                tbl12.ragestatus.showAmmo = arg1
            end,
        }
    )
    v17:AddToggle(
        "RageStatusReloadHide",
        {
            Text = "Hide While Reloading", Default = true,
            Callback = function(arg1)
                tbl12.ragestatus.hideOnReload = arg1
            end,
        }
    )
    tbl23.ragebotvisualtab:AddToggle(
        "VisEnabled",
        {
            Text = "Enable", Default = false,
            Callback = function(arg1)
                tbl12.visualizer.enabled = arg1
            end,
        }
    )
    tbl23.ragebotvisualtab:AddToggle(
        "VisTracerEnabled",
        {
            Text = "Tracer", Default = false,
            Callback = function(arg1)
                tbl12.visualizer.tracer.enabled = arg1
            end,
        }
    ):AddColorPicker(
        "VisTracerColor",
        {
            Default = tbl12.visualizer.tracer.color,
            Callback = function(arg1)
                tbl12.visualizer.tracer.color = arg1
            end,
        }
    )
    tbl23.ragebotvisualtab:AddDropdown(
        "VisTracerStart",
        {
            Text = "Tracer Start", Default = "cursor", Values = {"cursor", "muzzle"},
            Callback = function(arg1)
                tbl12.visualizer.tracer.start_point = arg1
            end,
        }
    )
    tbl23.ragebotvisualtab:AddToggle(
        "VisTracerOutline",
        {
            Text = "Tracer Outline", Default = true,
            Callback = function(arg1)
                tbl12.visualizer.tracer.outline = arg1
            end,
        }
    )
    tbl23.ragebotvisualtab:AddSlider(
        "VisTracerThickness",
        {
            Text = "Tracer Thickness", Default = 1, Min = 0.1, Max = 3, Rounding = 1,
            Callback = function(arg1)
                tbl12.visualizer.tracer.thickness = arg1
            end,
        }
    )
    getgenv().BazaRagebot = tbl
    local RunService = game:GetService("RunService")
    local LocalPlayer1 = game:GetService("Players").LocalPlayer
    local Workspace = game:GetService("Workspace")
    local tbl26 = {
        enabled = false, yawtype = "none", pitchtype = "none", angletype = "none", bodyyaw = "none",
        pitchpreset = "none", customangle = 0, minspeed = 10, maxspeed = 20, minangle = 30,
        maxangle = 60, randomangle = false, spindirection = 1, fakelag = false, fakelagstuds = 4,
        desync = false, desyncstuds = 3, microjitter = false, microstrength = 25,
        velocitybreaker = false,
    }
    getgenv().BazaAntiSettings = tbl26
    local tbl27 = {
        lastupdate = tick(), invertstate = false, smoothyaw = 0, smoothpitch = 0, smoothroll = 0,
        framecounter = 0,
    }
    local tbl28 = {
        getrandominrange = function(arg1, arg2)
            return arg1 + math.random() * (arg2 - arg1)
        end,
    }
    local tbl29 = {}
    if game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService(
        "ReplicatedStorage"
    ).Remotes:FindFirstChild("Replication") and game:GetService("ReplicatedStorage").Remotes.Replication:FindFirstChild(
        "Fighter"
    ) then
        game:GetService("ReplicatedStorage").Remotes.Replication.Fighter:FindFirstChild(
            "UpdateCameraRotation"
        )
    end
    local function func79()
        for k, v1 in pairs(tbl29) do
            if k and k.Parent then
                k.C0 = v1
            end
        end
    end
    local function func80()
        local ViewModels = Workspace:FindFirstChild("ViewModels")
        if not ViewModels then
            return nil
        end
        local FirstPerson = ViewModels:FindFirstChild("FirstPerson")
        if not FirstPerson then
            return nil
        end
        for _, v1 in ipairs(FirstPerson:GetChildren()) do
            local tbl = {}
            for k in v1.Name:gmatch("[^-]+") do
                table.insert(tbl, k:match("^%s*(.-)%s*$"))
            end
            if #tbl >= 2 then
                return tbl[2]
            end
        end
        return nil
    end
    local LocalFighter1 = func(
        game:GetService("Players").LocalPlayer.PlayerScripts.Controllers.FighterController
    ).LocalFighter
    local flag = false
    local v18 = func(
        game:GetService("Players").LocalPlayer.PlayerScripts.Controllers.CameraController
    )
    local v21
    local function func81(arg1)
        local vector3 = Vector3.new(0, -500, 0)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        if LocalFighter1 and LocalFighter1.Entity and LocalFighter1.Entity.RootPart then
            raycastParams.FilterDescendantsInstances = {LocalFighter1.Entity.RootPart.Parent}
        end
        local v1 = Workspace:Raycast(arg1, vector3, raycastParams)
        if v1 then
            return CFrame.new(Vector3.new(arg1.X, v1.Position.Y - 2, arg1.Z))
        end
        return nil
    end
    local Update1 = v18.Update
    v18.Update = function(...)
        local tbl = {...}
        if flag and LocalFighter1 and LocalFighter1.Entity and LocalFighter1.Entity.RootPart and v21 then
            LocalFighter1.Entity.RootPart.CFrame = v21
        end
        return Update1(table.unpack(tbl))
    end
    game:GetService("RunService").Heartbeat:Connect(
        function()
            if getgenv().InstanceConfigLoading then
                return
            end
            if not flag then
                v21 = nil
                return
            end
            if not func80() then
                v21 = nil
                return
            end
            if LocalFighter1 and LocalFighter1.Entity and LocalFighter1.Entity.RootPart then
                v21 = LocalFighter1.Entity.RootPart.CFrame
                local v1 = func81(LocalFighter1.Entity.RootPart.Position)
                if v1 then
                    LocalFighter1.Entity.RootPart.CFrame = v1
                end
            end
        end
    )
    local tbl30 = {
        calculateyaw = function(_)
            local num = 0
            local v1 = tick()
            if tbl26.yawtype == "jitter" then
                local v2 = math.rad(tbl26.minangle)
                local v3 = math.rad(tbl26.maxangle)
                if tbl26.randomangle then
                    num = tbl28.getrandominrange(-v3, v3)
                else
                    num = math.random() > 0.5 and v2 or -v2
                end
            elseif tbl26.yawtype == "spinbot" then
                num = v1 * tbl28.getrandominrange(tbl26.minspeed / 10, tbl26.maxspeed / 10) % (2 * math.pi)
            elseif tbl26.yawtype == "random" then
                if tbl27.framecounter % 30 == 0 then
                    num = tbl28.getrandominrange(
                        -math.rad(tbl26.maxangle), math.rad(tbl26.maxangle)
                    )
                else
                    num = tbl27.smoothyaw
                end
            end
            return num
        end,
        calculatepitch = function()
            local num = 0
            if tbl26.pitchtype == "jitter" then
                local v1 = math.rad(tbl26.minangle)
                local v2 = math.rad(tbl26.maxangle)
                if tbl26.randomangle then
                    num = tbl28.getrandominrange(-v2, v2)
                else
                    num = math.random() > 0.5 and v1 or -v1
                end
            elseif tbl26.pitchtype == "spinbot" then
                num = math.sin(tick() * (tbl26.maxspeed / 10)) * math.rad(tbl26.maxangle)
            elseif tbl26.pitchtype == "random" then
                if tbl27.framecounter % 20 == 0 then
                    num = tbl28.getrandominrange(-5099.324376664326, math.rad(89))
                else
                    num = tbl27.smoothpitch
                end
            end
            return num
        end,
        calculateroll = function()
            local num = 0
            if tbl26.angletype == "tilt 45" then
                num = 2578.3100780887044
            elseif tbl26.angletype == "tilt 90" then
                num = 5156.620156177409
            elseif tbl26.angletype == "upside down" then
                num = 10313.240312354817
            elseif tbl26.angletype == "custom" then
                num = math.rad(tbl26.customangle)
            end
            return num
        end,
    }
    local function func82(arg1)
        if not tbl26.enabled then
            return
        end
        if getgenv().InstanceConfigLoading then
            return
        end
        if getgenv().InstanceConfigLoading == nil then
            return
        end
        if tbl26.yawtype == "none" and tbl26.pitchtype == "none" and tbl26.angletype == "none" then
            return
        end
        if not func80() then
            return
        end
        local Character = LocalPlayer1.Character
        if not Character then
            return
        end
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart then
            return
        end
        tbl27.framecounter = tbl27.framecounter + 1
        local v1 = tbl30.calculateyaw(arg1)
        local v2 = tbl30.calculatepitch()
        local v3 = tbl30.calculateroll()
        local v4 = CFrame.Angles(v2, v1, v3)
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * v4
    end
    local function func83()
        v21 = nil
        tbl27.framecounter = 0
        tbl27.smoothyaw = 0
        tbl27.smoothpitch = 0
        tbl27.smoothroll = 0
        func79()
        local Character = LocalPlayer1.Character
        local v1 = Character and Character:FindFirstChild("HumanoidRootPart")
        if v1 then
            pcall(
                function()
                    v1.AssemblyAngularVelocity = Vector3.zero
                end
            )
        end
    end
    getgenv().InstanceFlushMovementState = function()
        func83()
        if getgenv().InstanceCleanupMovement then
            pcall(getgenv().InstanceCleanupMovement)
        else
            local v1 = _G
            v1.keyheldcframe = false
            v1.keyheldcframefly = false
        end
    end
    getgenv().InstanceSyncAfterConfigLoad = function()
        if getgenv().InstanceFlushMovementState then
            pcall(getgenv().InstanceFlushMovementState)
        end
        local v2 = _G
        v2.keyheldcframe = false
        v2.keyheldcframefly = false
        if v1.Toggles and v1.Toggles.AntiAimEnable then
            tbl26.enabled = v1.Toggles.AntiAimEnable.Value == true
        else
            tbl26.enabled = false
        end
        if v1.Toggles and v1.Toggles.AntiAimUnderground then
            flag = v1.Toggles.AntiAimUnderground.Value == true
            getgenv().InstanceUndergroundEnabled = flag
            if not flag then
                v21 = nil
            end
        else
            flag = false
            getgenv().InstanceUndergroundEnabled = false
            v21 = nil
        end
        if v1.Options and v1.Options.AntiAimYaw then
            tbl26.yawtype = v1.Options.AntiAimYaw.Value or "none"
        end
        if v1.Options and v1.Options.AntiAimPitch then
            tbl26.pitchtype = v1.Options.AntiAimPitch.Value or "none"
        end
        if v1.Options and v1.Options.AntiAimAngle then
            tbl26.angletype = v1.Options.AntiAimAngle.Value or "none"
        end
        if not tbl26.enabled or tbl26.yawtype == "none" and tbl26.pitchtype == "none" and tbl26.angletype == "none" then
            func83()
            v21 = nil
        end
    end
    LocalPlayer1.CharacterAdded:Connect(
        function()
            task.defer(func83)
        end
    )
    local v19 = _raw:AddLeftGroupbox("Anti Aim")
    v19:AddToggle(
        "AntiAimEnable",
        {
            Text = "Enable", Default = false,
            Callback = function(arg1)
                tbl26.enabled = arg1
                if getgenv().InstanceConfigLoading then
                    return
                end
                if not arg1 then
                    func83()
                end
            end,
        }
    )
    v19:AddDropdown(
        "AntiAimYaw",
        {
            Values = {"none", "jitter", "spinbot", "random"}, Default = "none", Text = "Yaw",
            Callback = function(arg1)
                tbl26.yawtype = arg1
            end,
        }
    )
    v19:AddDropdown(
        "AntiAimPitch",
        {
            Values = {"none", "jitter", "spinbot", "random"}, Default = "none", Text = "Pitch",
            Callback = function(arg1)
                tbl26.pitchtype = arg1
            end,
        }
    )
    v19:AddDropdown(
        "AntiAimAngle",
        {
            Values = {"none", "tilt 45", "tilt 90", "upside down", "custom"}, Default = "none",
            Text = "Angle",
            Callback = function(arg1)
                tbl26.angletype = arg1
            end,
        }
    )
    v19:AddSlider(
        "AntiAimCustomAngle",
        {
            Text = "Custom Angle", Default = 0, Min = 0, Max = 360, Rounding = 1, Suffix = "°",
            Callback = function(arg1)
                tbl26.customangle = arg1
            end,
        }
    )
    v19:AddSlider(
        "speedslider",
        {
            Text = "min speed", Default = 10, Min = 1, Max = 50, Rounding = 1, Suffix = "",
            Callback = function(arg1)
                tbl26.minspeed = arg1
            end,
        }
    )
    v19:AddSlider(
        "angleslider",
        {
            Text = "max speed", Default = 20, Min = 1, Max = 100, Rounding = 1, Suffix = "",
            Callback = function(arg1)
                tbl26.maxspeed = arg1
            end,
        }
    )
    v19:AddSlider(
        "minangleslider",
        {
            Text = "min angle", Default = 30, Min = 1, Max = 180, Rounding = 1, Suffix = "°",
            Callback = function(arg1)
                tbl26.minangle = arg1
            end,
        }
    )
    v19:AddSlider(
        "maxangleslider",
        {
            Text = "max angle", Default = 60, Min = 1, Max = 180, Rounding = 1, Suffix = "°",
            Callback = function(arg1)
                tbl26.maxangle = arg1
            end,
        }
    )
    v19:AddToggle(
        "randomangle",
        {
            Text = "Random Angle", Default = false,
            Callback = function(arg1)
                tbl26.randomangle = arg1
            end,
        }
    )
    v19:AddToggle(
        "AntiAimUnderground",
        {
            Text = "Underground", Default = false,
            Callback = function(arg1)
                flag = arg1
                getgenv().InstanceUndergroundEnabled = arg1
                if getgenv().InstanceConfigLoading then
                    return
                end
                if not arg1 then
                    v21 = nil
                end
            end,
        }
    )
    getgenv().InstanceSetUnderground = function(arg1)
        flag = arg1
        getgenv().InstanceUndergroundEnabled = arg1
        if not arg1 then
            v21 = nil
        end
    end
    RunService.Heartbeat:Connect(func82)
    local tbl31 = {enabled = false, mode = "Spin", strength = 5, spinspeed = 20}
    local tbl32 = {}
    tbl32.realCF = nil
    tbl32.tick = 0
    getgenv().BazaDesync = tbl31
    RunService.Heartbeat:Connect(
        function()
            local Character = LocalPlayer1.Character
            local v1 = Character and Character:FindFirstChild("HumanoidRootPart")
            local v2 = Character and Character:FindFirstChildOfClass("Humanoid")
            local BazaRagebot = getgenv().BazaRagebot
            local v3 = BazaRagebot and BazaRagebot.config
            local v4 = v3 and v3.voidspam
            local v5 = BazaRagebot and BazaRagebot.vhState and BazaRagebot.vhState.active or v4 and v4.phase == "hide" or v3 and v3.state and v3.state.reloading and v3.ragestatus and v3.ragestatus.hideOnReload
            if not tbl31.enabled or not tbl26.enabled or getgenv().InstanceConfigLoading or v1 == nil or v2 == nil or not (v2.Health > 0) or flag or v5 then
                local realCF = tbl32.realCF
                tbl32.realCF = nil
                if realCF ~= nil and v1 and not flag and not v5 then
                    pcall(
                        function()
                            v1.CFrame = realCF
                        end
                    )
                end
                return
            end
            tbl32.realCF = v1.CFrame
            tbl32.tick = tbl32.tick + 1
            local realCF1 = tbl32.realCF
            local v6 = math.clamp(tonumber(tbl31.strength) or 8, 1, 30)
            local v7
            if tbl31.mode == "Jitter" then
                v7 = realCF1 * CFrame.new(
                    (math.random() - 0.5) * 2 * v6, (math.random() - 0.5) * v6,
                    (math.random() - 0.5) * 2 * v6
                )
            elseif tbl31.mode == "Spin" then
                local v8 = math.clamp(tonumber(tbl31.spinspeed) or 20, 1, 50)
                v7 = realCF1 * CFrame.Angles(0, tick() * v8 % (math.pi * 2), 0)
            elseif tbl32.tick % 2 == 0 then
                v7 = realCF1 + Vector3.new(
                    (math.random() - 0.5) * v6, -v6 * 0.5, (math.random() - 0.5) * v6
                )
            else
                v7 = realCF1 + Vector3.new(
                    (math.random() - 0.5) * v6, v6, (math.random() - 0.5) * v6
                )
            end
            v1.CFrame = v7
        end
    )
    RunService.RenderStepped:Connect(
        function()
            if getgenv().InstanceConfigLoading then
                return
            end
            local realCF = tbl32.realCF
            if realCF == nil then
                return
            end
            local Character = LocalPlayer1.Character
            local v1 = Character and Character:FindFirstChild("HumanoidRootPart")
            if v1 then
                v1.CFrame = realCF
            else
                tbl32.realCF = nil
            end
        end
    )
    LocalPlayer1.CharacterAdded:Connect(
        function()
            tbl32.realCF = nil
        end
    )
end)()
local v16 = v3:AddTab("Visuals")
Players = game:GetService("Players")
RunService = game:GetService("RunService")
game:GetService("Workspace")
LocalPlayer = Players.LocalPlayer
local flag11 = false
local v17 = Color3.fromRGB(10, 10, 10)
local tbl6 = {}
local function func26(arg1)
    local HumanoidRootPart = arg1:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart and not HumanoidRootPart:FindFirstChild("ESP_Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.Adornee = arg1
        highlight.Parent = HumanoidRootPart
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = v17
        highlight.FillTransparency = 0.3
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    end
end
local function func27(arg1)
    local HumanoidRootPart = arg1:FindFirstChild("HumanoidRootPart")
    local v1 = HumanoidRootPart and HumanoidRootPart:FindFirstChild("ESP_Highlight")
    if v1 then
        v1:Destroy()
    end
end
local function func28(_, arg2)
    if tbl6[arg2] then
        tbl6[arg2]:Disconnect()
    end
    tbl6[arg2] = arg2.AncestryChanged:Connect(
        function(_, arg21)
            if not arg21 then
                if tbl6[arg2] then
                    tbl6[arg2]:Disconnect()
                    tbl6[arg2] = nil
                end
            end
        end
    )
    if flag11 then
        func26(arg2)
    end
end
local function func29(arg1)
    if arg1 == LocalPlayer then
        return
    end
    if arg1.Character then
        func28(arg1, arg1.Character)
    end
    arg1.CharacterAdded:Connect(
        function(arg2)
            func28(arg1, arg2)
        end
    )
    arg1.AncestryChanged:Connect(
        function(_, arg2)
            if not arg2 and arg1.Character then
                func27(arg1.Character)
            end
        end
    )
end
for _, v18 in ipairs(Players:GetPlayers()) do
    func29(v18)
end
Players.PlayerAdded:Connect(func29)
RunService.RenderStepped:Connect(
    function()
        if not flag11 then
            return
        end
        for _, v1 in ipairs(Players:GetPlayers()) do
            if v1 ~= LocalPlayer and v1.Character then
                func26(v1.Character)
            end
        end
    end
)
v16:AddSection("Best visual"):AddToggle(
    "Frame ESP", false,
    function(arg1)
        flag11 = arg1
        if not arg1 then
            for _, v1 in ipairs(Players:GetPlayers()) do
                if v1 ~= LocalPlayer and v1.Character then
                    func27(v1.Character)
                end
            end
        end
    end
)
LocalPlayer.Chatted:Connect(
    function(arg1)
        local v1, v2 = string.lower(tostring(arg1 or "")):match("^%s*!([%a]+)%s*(.-)%s*$")
        if not v1 then
            return
        end
        if v1 == "aim" then
            v4.CameraAimEnabled = v2 == "on"
        elseif v1 == "esp" then
            flag11 = v2 == "on"
            if not flag11 then
                for _, v3 in ipairs(Players:GetPlayers()) do
                    if v3 ~= LocalPlayer and v3.Character then
                        func27(v3.Character)
                    end
                end
            end
        elseif v1 == "fov" then
            local num = tonumber(v2)
            if num then
                v4.CameraFOVRadius = math.clamp(math.floor(num), 25, 1000)
            end
        elseif v1 == "speed" then
            local num1 = tonumber(v2)
            if num1 then
                v4.CameraAimSpeed = math.clamp(math.floor(num1), 1, 100)
            end
        elseif v1 == "part" then
            if v2 and v2 ~= "" then
                v4.CameraAimPart = v2:sub(1, 1):upper() .. v2:sub(2)
            end
        elseif v1 == "help" then
            print("[V.Roy] !aim on|off !esp on|off !fov <n> !speed <n> !part <Head|Auto|...>")
        end
    end
)
Players = game:GetService("Players")
RunService = game:GetService("RunService")
game:GetService("CollectionService")
LocalPlayer = Players.LocalPlayer
local tbl7 = {ShowSkeleton = false, ShowHealthBar = false}
getgenv().Config = getgenv().Config or {}
getgenv().Config.ShowSkeleton = tbl7.ShowSkeleton
getgenv().HealthBarEnabled = tbl7.ShowHealthBar
if v16 == nil then
    return
end
local tbl8 = {}
local function func30(arg1)
    arg1.Background.Visible = false
    arg1.Fill.Visible = false
end
local function func31()
    for _, v1 in pairs(tbl8) do
        func30(v1)
    end
end
RunService.RenderStepped:Connect(function(_) end)
getgenv().SetHealthBar = function(arg1)
    tbl7.ShowHealthBar = arg1 == true
    if not tbl7.ShowHealthBar then
        func31()
    end
end;
(function()
    local _raw = v16._raw
    game:GetService("Players")
    game:GetService("UserInputService")
    local InstanceWorldToScreen = getgenv().InstanceWorldToScreen;
    (function()
        local GuiService = game:GetService("GuiService")
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local GuiInset = GuiService:GetGuiInset()
        getgenv()
        local v1 = getgenv().InstanceWorldToScreenEsp or getgenv().InstanceWorldToScreen
        local InstanceScreenAnchor = getgenv().InstanceScreenAnchor
        local function func(arg1)
            if not arg1 then
                return "None"
            end
            local ViewModels = workspace:FindFirstChild("ViewModels")
            if not ViewModels then
                return "None"
            end
            local Name = arg1.Name
            local function func(arg1)
                local tbl = {}
                for k in arg1:gmatch("[^-]+") do
                    table.insert(tbl, k:match("^%s*(.-)%s*$"))
                end
                if #tbl >= 2 and tbl[1] == Name then
                    return tbl[2]
                end
                return nil
            end
            for _, v1 in ipairs(ViewModels:GetChildren()) do
                local v2 = func(v1.Name)
                if v2 then
                    return v2
                end
            end
            local FirstPerson = ViewModels:FindFirstChild("FirstPerson")
            if FirstPerson then
                for _, v3 in ipairs(FirstPerson:GetChildren()) do
                    local v4 = func(v3.Name)
                    if v4 then
                        return v4
                    end
                end
            end
            return "None"
        end
        local v2 = _G
        v2.BazaConfig = v2.BazaConfig or {
            Box = {
                MasterEnabled = false, Enable = false, OutlineColor = Color3.fromRGB(255, 255, 255),
                OutlineColor2 = Color3.fromRGB(255, 255, 255),
                FillColor = Color3.fromRGB(255, 255, 255),
                Filled = {Enable = false, Transparency = 0.5},
                Healthbar = {Enable = false, Thickness = 4},
                HealthLerpColors = {
                    Color1 = Color3.fromRGB(255, 255, 255), Color2 = Color3.fromRGB(255, 255, 255),
                    Color3 = Color3.fromRGB(255, 255, 255),
                },
            },
            Filled = {
                Enable = false, Transparency = 0.7, ColorStart = Color3.fromRGB(255, 255, 255),
                ColorEnd = Color3.fromRGB(255, 255, 255), Rotation = 0, Animated = false, Speed = 1,
            },
            Glow = {
                Enable = false, Transparency = 0.5, ColorStart = Color3.fromRGB(255, 255, 255),
                ColorEnd = Color3.fromRGB(255, 255, 255), Rotation = 0,
            },
            TextESP = {
                Names = false, Distance = false, Tools = false, NameSize = 8, DistanceSize = 8,
                ToolsSize = 8, NameColor = Color3.fromRGB(255, 255, 255),
                NameColor2 = Color3.fromRGB(255, 255, 255),
                DistanceColor = Color3.fromRGB(255, 255, 255),
                DistanceColor2 = Color3.fromRGB(255, 255, 255),
                ToolColor = Color3.fromRGB(255, 255, 255),
                ToolColor2 = Color3.fromRGB(255, 255, 255),
            },
            Skeleton = {
                Enable = false, Color = Color3.fromRGB(255, 255, 255),
                Color2 = Color3.fromRGB(255, 255, 255), Thickness = 1,
            },
            Tracers = {
                Enable = false, Color = Color3.fromRGB(255, 255, 255),
                Color2 = Color3.fromRGB(255, 255, 255), Thickness = 1, FromBottom = true,
            },
            Chams = {
                Enable = false, Color = Color3.fromRGB(255, 255, 255),
                Color2 = Color3.fromRGB(255, 255, 255), Transparency = 0,
            }, ESP = {HighRefresh = true, HealthLerpSpeed = 32, TargetHz = 240},
        }
        local v3 = _G
        v3.ESPObjects = v3.ESPObjects or {}
        local v4 = _G
        local Box = v4.BazaConfig.Box
        local ESPObjects = v4.ESPObjects
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "ESP"
        screenGui.DisplayOrder = 9000000000
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = game.CoreGui
        local tbl = {
            {"UpperTorso", "Head"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"},
            {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
            {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"},
            {"RightLowerArm", "RightHand"}, {"LowerTorso", "LeftUpperLeg"},
            {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
            {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"},
            {"RightLowerLeg", "RightFoot"},
        }
        local tbl1 = {
            {"Torso", "Head"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"},
            {"Torso", "Right Leg"},
        }
        local tbl2 = {}
        if not fontok then
            tbl2.main = Font.fromEnum(Enum.Font.Code)
        end
        local num = 0
        local function func1(arg1, arg2, arg3)
            return Color3.new(
                arg1.R + (arg2.R - arg1.R) * arg3, arg1.G + (arg2.G - arg1.G) * arg3,
                arg1.B + (arg2.B - arg1.B) * arg3
            )
        end
        local function func2(arg1, arg2, arg3)
            if not arg1 then
                return
            end
            local EspTextGradient = arg1:FindFirstChild("EspTextGradient")
            if not EspTextGradient then
                local uIGradient = Instance.new("UIGradient")
                EspTextGradient = uIGradient
                uIGradient.Name = "EspTextGradient"
                uIGradient.Rotation = 0
                uIGradient.Parent = arg1
            end
            EspTextGradient.Color = ColorSequence.new(
                {ColorSequenceKeypoint.new(0, arg2), ColorSequenceKeypoint.new(1, arg3)}
            )
            arg1.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        local function func3(arg1)
            local v1 = Box.HealthLerpColors or {
                Color1 = Color3.fromRGB(0, 255, 0), Color2 = Color3.fromRGB(255, 255, 0),
                Color3 = Color3.fromRGB(255, 0, 0),
            }
            if arg1 > 0.5 then
                return func1(v1.Color2, v1.Color1, (arg1 - 0.5) * 2)
            end
            return func1(v1.Color3, v1.Color2, arg1 * 2)
        end
        local function getClosestEnemy(arg1)
            if not arg1 or arg1 == LocalPlayer then
                return true
            end
            local Attribute = LocalPlayer:GetAttribute("TeamID")
            local Attribute1 = arg1:GetAttribute("TeamID")
            if Attribute ~= nil and Attribute1 ~= nil then
                return Attribute == Attribute1
            end
            return LocalPlayer.Team and arg1.Team and LocalPlayer.Team == arg1.Team
        end
        local function toggleTeleportToEnemy(arg1, arg2)
            local v1 = arg1:FindFirstChild(arg2)
            if v1 and v1:IsA("BasePart") then
                return v1
            end
            for _, v2 in ipairs(
                ({
                    ["Left Arm"] = {"LeftArm", "LeftUpperArm"},
                    ["Right Arm"] = {"RightArm", "RightUpperArm"},
                    ["Left Leg"] = {"LeftLeg", "LeftUpperLeg"},
                    ["Right Leg"] = {"RightLeg", "RightUpperLeg"},
                    Torso = {"UpperTorso", "LowerTorso"},
                })[arg2] or {}
            ) do
                local v3 = arg1:FindFirstChild(v2)
                if v3 and v3:IsA("BasePart") then
                    return v3
                end
            end
            return nil
        end
        local function func6(arg1)
            local Character = arg1.Character
            if not Character then
                return false
            end
            local BodyEffects = Character:FindFirstChild("BodyEffects")
            if BodyEffects then
                local v1 = BodyEffects:FindFirstChild("K.O") or BodyEffects:FindFirstChild("KO")
                return v1 and v1.Value
            end
            return false
        end
        local function func7(arg1)
            local Character = arg1.Character
            local Character1 = LocalPlayer.Character
            if Character and Character1 then
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                local HumanoidRootPart1 = Character1:FindFirstChild("HumanoidRootPart")
                if HumanoidRootPart and HumanoidRootPart1 then
                    return (HumanoidRootPart.Position - HumanoidRootPart1.Position).Magnitude
                end
            end
            return math.huge
        end
        local function func8(arg1)
            return (func(arg1))
        end
        local function func9(arg1)
            local textLabel = Instance.new("TextLabel")
            textLabel.Parent = arg1
            textLabel.Size = UDim2.new(0, 200, 0, 20)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextStrokeTransparency = 0
            textLabel.TextScaled = false
            textLabel.TextSize = 6
            textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            textLabel.FontFace = tbl2.main
            local v1 = Enum
            textLabel.TextXAlignment = v1.TextXAlignment.Left
            textLabel.TextYAlignment = v1.TextYAlignment.Top
            return textLabel
        end
        local function func10(arg1)
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.Adornee = arg1
            local v1 = _G
            highlight.FillColor = v1.BazaConfig.Chams.Color
            highlight.OutlineColor = v1.BazaConfig.Chams.Color2 or _G.BazaConfig.Chams.Color
            local v2 = _G
            highlight.FillTransparency = v2.BazaConfig.Chams.Transparency
            highlight.OutlineTransparency = math.clamp(v2.BazaConfig.Chams.Transparency, 0, 1)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = arg1
            return highlight
        end
        local function func11(arg1)
            if ESPObjects[arg1] then
                return
            end
            local tbl = {box = {}}
            tbl.box.square = Drawing.new("Square")
            tbl.box.inline = Drawing.new("Square")
            tbl.box.outline = Drawing.new("Square")
            tbl.filled = Instance.new("Frame")
            tbl.filled.BackgroundColor3 = Color3.new(1, 1, 1)
            tbl.filled.BackgroundTransparency = _G.BazaConfig.Filled.Transparency
            tbl.filled.BorderSizePixel = 0
            tbl.filled.Visible = false
            tbl.filled.ZIndex = 2
            tbl.filled.Parent = screenGui
            tbl.filled_gradient = Instance.new("UIGradient")
            local v1 = _G
            tbl.filled_gradient.Color = ColorSequence.new(
                {
                    ColorSequenceKeypoint.new(0, v1.BazaConfig.Filled.ColorStart),
                    ColorSequenceKeypoint.new(1, v1.BazaConfig.Filled.ColorEnd),
                }
            )
            tbl.filled_gradient.Rotation = 0
            tbl.filled_gradient.Parent = tbl.filled
            tbl.glow = Instance.new("ImageLabel")
            tbl.glow.Image = "rbxassetid://110204605000367"
            tbl.glow.ScaleType = Enum.ScaleType.Slice
            tbl.glow.SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
            tbl.glow.AutomaticSize = Enum.AutomaticSize.XY
            tbl.glow.ImageTransparency = _G.BazaConfig.Glow.Transparency
            tbl.glow.ResampleMode = Enum.ResamplerMode.Pixelated
            tbl.glow.BackgroundTransparency = 1
            tbl.glow.BorderSizePixel = 0
            tbl.glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            tbl.glow.ZIndex = 1
            tbl.glow.Visible = false
            tbl.glow.Parent = screenGui
            tbl.glow_gradient = Instance.new("UIGradient")
            tbl.glow_gradient.Rotation = _G.BazaConfig.Glow.Rotation
            local v2 = _G
            tbl.glow_gradient.Color = ColorSequence.new(
                {
                    ColorSequenceKeypoint.new(0, v2.BazaConfig.Glow.ColorStart),
                    ColorSequenceKeypoint.new(1, v2.BazaConfig.Glow.ColorEnd),
                }
            )
            tbl.glow_gradient.Transparency = NumberSequence.new(
                {NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0)}
            )
            tbl.glow_gradient.Parent = tbl.glow
            local uIPadding = Instance.new("UIPadding")
            uIPadding.PaddingTop = UDim.new(0, 21)
            uIPadding.PaddingBottom = UDim.new(0, 20)
            uIPadding.PaddingLeft = UDim.new(0, 21)
            uIPadding.PaddingRight = UDim.new(0, 20)
            uIPadding.Parent = tbl.glow
            tbl.bars = {}
            tbl.bars.hp_bars = {}
            tbl.bars.hp_outline = Drawing.new("Square")
            tbl.bars.last_hp = 1
            for i = 1, 50 do
                tbl.bars.hp_bars[i] = Drawing.new("Line")
            end
            tbl.skeleton = {lines = {}, outlines = {}}
            for i1 = 1, 15 do
                local drawing = Drawing.new("Line")
                drawing.Color = Color3.new(0, 0, 0)
                drawing.Thickness = 3
                drawing.Visible = false
                tbl.skeleton.outlines[i1] = drawing
                local drawing1 = Drawing.new("Line")
                drawing1.Color = Color3.new(1, 1, 1)
                drawing1.Thickness = 1
                drawing1.Visible = false
                tbl.skeleton.lines[i1] = drawing1
            end
            local screenGui1 = Instance.new("ScreenGui", game.CoreGui)
            local screenGui2 = Instance.new("ScreenGui", game.CoreGui)
            local screenGui3 = Instance.new("ScreenGui", game.CoreGui)
            tbl.text = {}
            tbl.text.studs = func9(screenGui1)
            tbl.text.tool = func9(screenGui3)
            tbl.text.name = func9(screenGui2)
            tbl.Tracer = Drawing.new("Line")
            tbl.Tracer.Visible = false
            tbl.Tracer.Color = _G.BazaConfig.Tracers.Color or Color3.fromRGB(255, 255, 255)
            tbl.Tracer.Thickness = _G.BazaConfig.Tracers.Thickness or 1
            ESPObjects[arg1] = tbl
        end
        local function func12(arg1)
            if ESPObjects[arg1] then
                local v1 = ESPObjects[arg1]
                if v1.box then
                    v1.box.square:Remove()
                    v1.box.outline:Remove()
                    v1.box.inline:Remove()
                end
                if v1.filled then
                    v1.filled:Destroy()
                end
                if v1.glow then
                    v1.glow:Destroy()
                end
                if v1.text then
                    if v1.text.studs then
                        v1.text.studs.Parent:Destroy()
                    end
                    if v1.text.tool then
                        v1.text.tool.Parent:Destroy()
                    end
                    if v1.text.name then
                        v1.text.name.Parent:Destroy()
                    end
                end
                if v1.bars then
                    v1.bars.hp_outline:Remove()
                    for _, v2 in pairs(v1.bars.hp_bars) do
                        v2:Remove()
                    end
                end
                if v1.skeleton then
                    for _, v3 in pairs(v1.skeleton.lines) do
                        v3:Remove()
                    end
                    for _, v4 in pairs(v1.skeleton.outlines) do
                        v4:Remove()
                    end
                end
                if v1.Tracer then
                    v1.Tracer:Remove()
                end
                if v1.Cham then
                    v1.Cham:Destroy()
                    v1.Cham = nil
                end
                ESPObjects[arg1] = nil
            end
        end
        local function func13(arg1)
            if not ESPObjects[arg1] then
                return
            end
            local v1 = ESPObjects[arg1]
            if v1.box then
                v1.box.square.Visible = false
                v1.box.outline.Visible = false
                v1.box.inline.Visible = false
            end
            if v1.filled then
                v1.filled.Visible = false
            end
            if v1.glow then
                v1.glow.Visible = false
            end
            if v1.text then
                v1.text.studs.Visible = false
                v1.text.tool.Visible = false
                v1.text.name.Visible = false
            end
            if v1.bars then
                v1.bars.hp_outline.Visible = false
                for _, v2 in pairs(v1.bars.hp_bars) do
                    v2.Visible = false
                end
            end
            if v1.skeleton then
                for _, v3 in pairs(v1.skeleton.lines) do
                    v3.Visible = false
                end
                for _, v4 in pairs(v1.skeleton.outlines) do
                    v4.Visible = false
                end
            end
            if v1.Tracer then
                v1.Tracer.Visible = false
            end
            if v1.Cham then
                v1.Cham.Enabled = false
            end
        end
        local function func14(_, arg2, arg3)
            if not _G.BazaConfig.Chams.Enable then
                if arg2.Cham then
                    arg2.Cham.Enabled = false
                end
                return
            end
            if not arg2.Cham or not arg2.Cham.Parent then
                arg2.Cham = func10(arg3)
            end
            if arg2.Cham then
                arg2.Cham.Enabled = true
                local v1 = _G
                arg2.Cham.FillColor = v1.BazaConfig.Chams.Color
                arg2.Cham.OutlineColor = v1.BazaConfig.Chams.Color2 or _G.BazaConfig.Chams.Color
                local v2 = _G
                arg2.Cham.FillTransparency = v2.BazaConfig.Chams.Transparency
                arg2.Cham.OutlineTransparency = math.clamp(v2.BazaConfig.Chams.Transparency, 0, 1)
            end
        end
        local function func15(_, arg2, arg3, arg4, _, _)
            if not _G.BazaConfig.Skeleton.Enable then
                for _, v2 in pairs(arg2.skeleton.lines) do
                    v2.Visible = false
                end
                for _, v3 in pairs(arg2.skeleton.outlines) do
                    v3.Visible = false
                end
                return
            end
            local v4 = arg4.RigType == Enum.HumanoidRigType.R15 and tbl or tbl1
            local v5 = _G.BazaConfig.Skeleton.Color or Color3.fromRGB(255, 255, 255)
            local v6 = _G.BazaConfig.Skeleton.Color2 or v5
            local v7 = _G.BazaConfig.Skeleton.Thickness or 1
            for i = 1, 15 do
                local v8 = v4[i]
                local v9 = arg2.skeleton.lines[i]
                local v10 = arg2.skeleton.outlines[i]
                if v8 then
                    local v11 = toggleTeleportToEnemy(arg3, v8[1])
                    local v12 = toggleTeleportToEnemy(arg3, v8[2])
                    if v11 and v12 then
                        local v13, v14 = v1(v11.Position)
                        local v15, v16 = v1(v12.Position)
                        if v14 and v16 then
                            local vector2 = Vector2.new(v13.X, v13.Y)
                            local vector21 = Vector2.new(v15.X, v15.Y)
                            local v17 = (vector2.X + vector21.X) * 0.5
                            local v18 = v17 >= vector2.X and func1(
                                v5, v6,
                                math.clamp(
                                    (v17 - vector2.X) / math.max(
                                        math.abs(vector21.X - vector2.X), 1
                                    ), 0, 1
                                )
                            ) or v5
                            v10.Visible = true
                            v10.From = vector2
                            v10.To = vector21
                            v10.Thickness = v7 + 2
                            v10.Color = Color3.new(0, 0, 0)
                            v9.Visible = true
                            v9.From = vector2
                            v9.To = vector21
                            v9.Color = v18
                            v9.Thickness = v7
                        else
                            v9.Visible = false
                            v10.Visible = false
                        end
                    else
                        v9.Visible = false
                        v10.Visible = false
                    end
                else
                    v9.Visible = false
                    v10.Visible = false
                end
            end
        end
        local function func16(_, arg2, arg3, arg4, arg5, arg6)
            if not (Box.Healthbar and Box.Healthbar.Enable) then
                arg2.bars.hp_outline.Visible = false
                for _, v1 in pairs(arg2.bars.hp_bars) do
                    v1.Visible = false
                end
                return
            end
            local v2 = math.clamp(arg3.Health / arg3.MaxHealth, 0, 1)
            local v3 = arg2.bars.last_hp or v2
            local v4 = _G.BazaConfig.ESP or {}
            local v5 = v4.HealthLerpSpeed or 32
            if v4.HighRefresh ~= false then
                local v6 = arg6 or 1 / (v4.TargetHz or 240)
                local v7 = v3 + (v2 - v3) * math.min(1, v6 * v5)
                arg2.bars.last_hp = v7
            else
                arg2.bars.last_hp = v3 + (v2 - v3) * 0.05
            end
            local v8 = math.ceil(arg4.Y * arg2.bars.last_hp)
            local v9 = arg5.X - 5
            local v10 = arg5.Y + (arg4.Y - v8)
            arg2.bars.hp_outline.Visible = true
            arg2.bars.hp_outline.Position = Vector2.new(v9 - 1, arg5.Y - 1)
            arg2.bars.hp_outline.Size = Vector2.new(3, arg4.Y + 2)
            arg2.bars.hp_outline.Color = Color3.new(0, 0, 0)
            arg2.bars.hp_outline.Filled = false
            local v11 = math.max(math.min(math.floor(v8 / 2), 50), 10)
            for i = 1, 50 do
                local v12 = arg2.bars.hp_bars[i]
                if i <= v11 then
                    local v13 = v8 / v11
                    local v14 = (i - 1) * v13
                    local v15 = 1 - (v14 + (arg4.Y - v8)) / arg4.Y
                    v12.Visible = true
                    v12.From = Vector2.new(v9, v10 + v14)
                    v12.To = Vector2.new(v9 + 1, v10 + v14)
                    v12.Color = func3(v15)
                    v12.Thickness = math.max(v13, 1)
                else
                    v12.Visible = false
                end
            end
        end
        local function func17(_, arg2, arg3, arg4)
            if not (Box.MasterEnabled and Box.Enable) then
                arg2.box.square.Visible = false
                arg2.box.outline.Visible = false
                arg2.box.inline.Visible = false
                return
            end
            local v1 = math.max(math.floor(arg3.X), 4)
            local v2 = math.max(math.floor(arg3.Y), 8)
            local vector2 = Vector2.new(v1, v2)
            local vector21 = Vector2.new(math.floor(arg4.X), math.floor(arg4.Y))
            arg2.box.square.Visible = true
            arg2.box.square.Position = vector21
            arg2.box.square.Size = vector2
            arg2.box.square.Color = func1(
                Box.OutlineColor, Box.OutlineColor2 or Box.OutlineColor, 0.5
            )
            arg2.box.square.Thickness = 1
            arg2.box.square.Filled = false
            arg2.box.outline.Visible = true
            arg2.box.outline.Position = vector21 - Vector2.new(1, 1)
            arg2.box.outline.Size = vector2 + Vector2.new(2, 2)
            arg2.box.outline.Color = Color3.new(0, 0, 0)
            arg2.box.outline.Thickness = 1
            arg2.box.outline.Filled = false
            arg2.box.inline.Visible = true
            arg2.box.inline.Position = vector21 + Vector2.new(1, 1)
            arg2.box.inline.Size = Vector2.new(math.max(v1 - 2, 2), math.max(v2 - 2, 4))
            arg2.box.inline.Color = Color3.new(0, 0, 0)
            arg2.box.inline.Thickness = 1
            arg2.box.inline.Filled = false
        end
        local function func18(_, arg2, arg3, arg4)
            local Filled = _G.BazaConfig.Filled
            if not Filled.Enable then
                arg2.filled.Visible = false
                return
            end
            arg2.filled.Visible = true
            arg2.filled.BackgroundTransparency = Filled.Transparency
            arg2.filled.Position = UDim2.fromOffset(arg4.X, arg4.Y)
            arg2.filled.Size = UDim2.fromOffset(arg3.X, arg3.Y)
            arg2.filled_gradient.Color = ColorSequence.new(
                {ColorSequenceKeypoint.new(0, Filled.ColorStart), ColorSequenceKeypoint.new(
                    1, Filled.ColorEnd
                )}
            )
            if Filled.Animated then
                arg2.filled_gradient.Rotation = math.sin(num * Filled.Speed) * 90 + Filled.Rotation
            else
                arg2.filled_gradient.Rotation = Filled.Rotation
            end
        end
        local function func19(_, arg2, arg3, arg4)
            local Glow = _G.BazaConfig.Glow
            if not Glow.Enable or not (Box.MasterEnabled and Box.Enable) then
                arg2.glow.Visible = false
                return
            end
            arg2.glow.Visible = true
            arg2.glow.ImageTransparency = Glow.Transparency
            arg2.glow.ImageColor3 = Glow.ColorStart
            arg2.glow.Position = UDim2.fromOffset(arg4.X - 21, arg4.Y - 21)
            arg2.glow.Size = UDim2.fromOffset(arg3.X + 42, arg3.Y + 42)
            arg2.glow_gradient.Color = ColorSequence.new(
                {ColorSequenceKeypoint.new(0, Glow.ColorStart), ColorSequenceKeypoint.new(
                    1, Glow.ColorEnd
                )}
            )
            arg2.glow_gradient.Rotation = 0
        end
        local function func20(arg1, arg2, arg3, arg4, arg5)
            local v1 = arg4.Y - GuiInset.Y
            if _G.BazaConfig.TextESP and _G.BazaConfig.TextESP.Names then
                arg2.text.name.Visible = true
                arg2.text.name.Position = UDim2.new(0, arg4.X + arg3.X / 2 - 100, 0, v1 - 15)
                arg2.text.name.Text = arg1.Name
                arg2.text.name.TextSize = _G.BazaConfig.TextESP.NameSize or 13
                func2(
                    arg2.text.name,
                    _G.BazaConfig.TextESP.NameColor or Color3.fromRGB(255, 255, 255),
                    _G.BazaConfig.TextESP.NameColor2 or _G.BazaConfig.TextESP.NameColor or Color3.fromRGB(
                        255, 255, 255
                    )
                )
                arg2.text.name.TextXAlignment = Enum.TextXAlignment.Center
            else
                arg2.text.name.Visible = false
            end
            if _G.BazaConfig.TextESP and _G.BazaConfig.TextESP.Tools then
                arg2.text.tool.Visible = true
                arg2.text.tool.Position = UDim2.new(0, arg4.X + arg3.X + 5, 0, v1)
                arg2.text.tool.Text = func8(arg1)
                arg2.text.tool.TextSize = _G.BazaConfig.TextESP.ToolsSize or 11
                func2(
                    arg2.text.tool,
                    _G.BazaConfig.TextESP.ToolColor or Color3.fromRGB(255, 255, 255),
                    _G.BazaConfig.TextESP.ToolColor2 or _G.BazaConfig.TextESP.ToolColor or Color3.fromRGB(
                        255, 255, 255
                    )
                )
                arg2.text.tool.TextXAlignment = Enum.TextXAlignment.Left
            else
                arg2.text.tool.Visible = false
            end
            if _G.BazaConfig.TextESP and _G.BazaConfig.TextESP.Distance then
                arg2.text.studs.Visible = true
                arg2.text.studs.Position = UDim2.new(
                    0, arg4.X + arg3.X / 2 - 100, 0, v1 + arg3.Y + 2
                )
                arg2.text.studs.Text = string.format("%.0f studs", arg5)
                arg2.text.studs.TextSize = _G.BazaConfig.TextESP.DistanceSize or 11
                func2(
                    arg2.text.studs,
                    _G.BazaConfig.TextESP.DistanceColor or Color3.fromRGB(255, 255, 255),
                    _G.BazaConfig.TextESP.DistanceColor2 or _G.BazaConfig.TextESP.DistanceColor or Color3.fromRGB(
                        255, 255, 255
                    )
                )
                arg2.text.studs.TextXAlignment = Enum.TextXAlignment.Center
            else
                arg2.text.studs.Visible = false
            end
        end
        local function func21(_, arg2, arg3)
            if not (_G.BazaConfig.Tracers and _G.BazaConfig.Tracers.Enable) then
                arg2.Tracer.Visible = false
                return
            end
            local v2, v3 = v1(arg3.Position)
            if v3 then
                arg2.Tracer.Visible = true
                arg2.Tracer.To = Vector2.new(v2.X, v2.Y)
                arg2.Tracer.From = (_G.BazaConfig.Tracers.FromBottom == nil or _G.BazaConfig.Tracers.FromBottom) and InstanceScreenAnchor(
                    0.5, 1
                ) or InstanceScreenAnchor(0.5, 0.5)
                arg2.Tracer.Color = func1(
                    _G.BazaConfig.Tracers.Color or Color3.fromRGB(255, 255, 255),
                    _G.BazaConfig.Tracers.Color2 or _G.BazaConfig.Tracers.Color or Color3.fromRGB(
                        255, 255, 255
                    ), 0.5
                )
                arg2.Tracer.Thickness = _G.BazaConfig.Tracers.Thickness or 1
            else
                arg2.Tracer.Visible = false
            end
        end
        local function func22(arg1)
            local CurrentCamera = workspace.CurrentCamera
            if not CurrentCamera or not arg1 then
                return nil, nil
            end
            local huge = math.huge
            local huge1 = math.huge
            local v2 = -math.huge
            local v3 = -math.huge
            local flag = false
            for _, v4 in ipairs(arg1:GetDescendants()) do
                if v4:IsA("BasePart") and v4.Transparency < 1 and v4.Size.Magnitude > 0 then
                    local CFrame1 = v4.CFrame
                    local Size = v4.Size
                    local v5 = CFrame1 * Vector3.new(-Size.X / 2, -Size.Y / 2, -Size.Z / 2)
                    local v6 = CFrame1 * Vector3.new(Size.X / 2, -Size.Y / 2, -Size.Z / 2)
                    local v7 = CFrame1 * Vector3.new(-Size.X / 2, Size.Y / 2, -Size.Z / 2)
                    local v8 = CFrame1 * Vector3.new(Size.X / 2, Size.Y / 2, -Size.Z / 2)
                    local v9 = CFrame1 * Vector3.new(-Size.X / 2, -Size.Y / 2, Size.Z / 2)
                    local v10 = CFrame1 * Vector3.new(Size.X / 2, -Size.Y / 2, Size.Z / 2)
                    local v11 = CFrame1 * Vector3.new(-Size.X / 2, Size.Y / 2, Size.Z / 2)
                    local v12 = CFrame1 * Vector3.new(Size.X / 2, Size.Y / 2, Size.Z / 2)
                    for _, v13 in ipairs({v5, v6, v7, v8, v9, v10, v11, v12}) do
                        local v14, v15 = v1(v13, CurrentCamera)
                        if v15 then
                            flag = true
                            huge = math.min(huge, v14.X)
                            huge1 = math.min(huge1, v14.Y)
                            v2 = math.max(v2, v14.X)
                            v3 = math.max(v3, v14.Y)
                        end
                    end
                end
            end
            if not flag then
                return nil, nil
            end
            return
                Vector2.new(math.max(v2 - huge, 4), math.max(v3 - huge1, 8)),
                Vector2.new(huge, huge1)
        end
        local function func23(arg1, arg2)
            if not arg1 or not ESPObjects[arg1] then
                return
            end
            if not Box.MasterEnabled then
                func13(arg1)
                return
            end
            if arg1 == LocalPlayer or getClosestEnemy(arg1) then
                func13(arg1)
                return
            end
            local Character = arg1.Character
            if not Character or func6(arg1) then
                func13(arg1)
                return
            end
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
            if not HumanoidRootPart or not Humanoid then
                func13(arg1)
                return
            end
            local v2, v3 = v1(HumanoidRootPart.Position)
            if not v3 then
                func13(arg1)
                return
            end
            local v4 = func7(arg1)
            local v5, v6 = func22(Character)
            local vector2, vector21
            if v5 and v6 then
                vector2 = Vector2.new(math.max(math.floor(v5.X), 4), math.max(math.floor(v5.Y), 8))
                vector21 = Vector2.new(math.floor(v6.X), math.floor(v6.Y))
            else
                local Head = Character:FindFirstChild("Head")
                local v7 = Head and Head.Position + Vector3.new(0, 0.5, 0) or HumanoidRootPart.Position + Vector3.new(
                    0, 3, 0
                )
                local v8 = HumanoidRootPart.Position - Vector3.new(0, 3, 0)
                local v9, v10 = v1(v7)
                local v11, v12 = v1(v8)
                if not v10 or not v12 then
                    func13(arg1)
                    return
                end
                local v13 = math.abs(v11.Y - v9.Y)
                local v14 = math.max(v13 * 0.55, 8)
                local vector22 = Vector2.new(
                    math.max(math.floor(v14), 4), math.max(math.floor(math.max(v13, 10)), 8)
                )
                vector2 = vector22
                vector21 = Vector2.new(
                    math.floor(v2.X - vector22.X / 2), math.floor(math.min(v9.Y, v11.Y))
                )
            end
            local v15 = ESPObjects[arg1]
            local BazaConfig = _G.BazaConfig
            func18(arg1, v15, vector2, vector21)
            func17(arg1, v15, vector2, vector21)
            func19(arg1, v15, vector2, vector21)
            if BazaConfig.Skeleton and BazaConfig.Skeleton.Enable then
                func15(arg1, v15, Character, Humanoid, vector2, vector21)
            else
                for _, v16 in pairs(v15.skeleton.lines) do
                    v16.Visible = false
                end
                for _, v17 in pairs(v15.skeleton.outlines) do
                    v17.Visible = false
                end
            end
            func16(arg1, v15, Humanoid, vector2, vector21, arg2)
            func20(arg1, v15, vector2, vector21, v4)
            if BazaConfig.Tracers and BazaConfig.Tracers.Enable then
                func21(arg1, v15, HumanoidRootPart)
            elseif v15.Tracer then
                v15.Tracer.Visible = false
            end
            if BazaConfig.Chams and BazaConfig.Chams.Enable then
                func14(arg1, v15, Character)
            elseif v15.Cham then
                v15.Cham.Enabled = false
            end
        end
        local flag = false
        local function func24(arg1)
            local v1 = arg1 or 1 / (_G.BazaConfig.ESP and _G.BazaConfig.ESP.TargetHz or 240)
            num = os.clock()
            if not Box.MasterEnabled then
                if flag then
                    flag = false
                    for k in pairs(ESPObjects) do
                        func13(k)
                    end
                end
                return
            end
            flag = true
            for _, v2 in ipairs(game:GetService("Players"):GetPlayers()) do
                if v2 ~= LocalPlayer then
                    func23(v2, v1)
                end
            end
        end
        if not pcall(
            function()
                game:GetService("RunService"):UnbindFromRenderStep("InstanceESPUpdate")
                game:GetService("RunService"):BindToRenderStep(
                    "InstanceESPUpdate", Enum.RenderPriority.Camera.Value + 1, func24
                )
            end
        ) then
            game:GetService("RunService").RenderStepped:Connect(func24)
        end
        for _, v5 in ipairs(game:GetService("Players"):GetPlayers()) do
            if v5 ~= LocalPlayer then
                func11(v5)
            end
        end
        game:GetService("Players").PlayerAdded:Connect(
            function(arg1)
                if arg1 ~= LocalPlayer then
                    func11(arg1)
                end
            end
        )
        game:GetService("Players").PlayerRemoving:Connect(func12)
        local v6 = _raw:AddLeftGroupbox("Visuals")
        ExploitsSection:AddToggle(
            "box_enabled",
            {
                Text = "enable", Default = Box.MasterEnabled or false,
                Callback = function(arg1)
                    Box.MasterEnabled = arg1
                end,
            }
        )
        local v7 = v6:AddDependencyBox()
        v7:AddToggle(
            "box_enabled2",
            {
                Text = "boxes", Default = Box.Enable or false,
                Callback = function(arg1)
                    Box.Enable = arg1
                end,
            }
        ):AddColorPicker(
            "box_outline_color",
            {
                Title = "box color 1", Default = Box.OutlineColor or Color3.fromRGB(255, 255, 255),
                Transparency = false,
                Callback = function(arg1)
                    Box.OutlineColor = arg1
                end,
            }
        ):AddColorPicker(
            "box_outline_color2",
            {
                Title = "box color 2", Default = Box.OutlineColor2 or Color3.fromRGB(255, 255, 255),
                Transparency = false,
                Callback = function(arg1)
                    Box.OutlineColor2 = arg1
                end,
            }
        )
        v7:AddToggle(
            "box_filled",
            {
                Text = "box fill", Default = _G.BazaConfig.Filled.Enable or false,
                Callback = function(arg1)
                    _G.BazaConfig.Filled.Enable = arg1
                end,
            }
        ):AddColorPicker(
            "box_filled_color_start",
            {
                Title = "fill color start",
                Default = _G.BazaConfig.Filled.ColorStart or Color3.fromRGB(255, 255, 255),
                Transparency = false,
                Callback = function(arg1)
                    _G.BazaConfig.Filled.ColorStart = arg1
                end,
            }
        ):AddColorPicker(
            "box_filled_color_end",
            {
                Title = "fill color end",
                Default = _G.BazaConfig.Filled.ColorEnd or Color3.fromRGB(255, 255, 255),
                Transparency = false,
                Callback = function(arg1)
                    _G.BazaConfig.Filled.ColorEnd = arg1
                end,
            }
        )
        v7:AddToggle(
            "box_filled_animated",
            {
                Text = "fill rotation", Default = _G.BazaConfig.Filled.Animated or false,
                Callback = function(arg1)
                    _G.BazaConfig.Filled.Animated = arg1
                end,
            }
        )
        v7:AddToggle(
            "box_glow",
            {
                Text = "box glow", Default = _G.BazaConfig.Glow.Enable or false,
                Callback = function(arg1)
                    _G.BazaConfig.Glow.Enable = arg1
                end,
            }
        ):AddColorPicker(
            "box_glow_color_start",
            {
                Title = "glow color start",
                Default = _G.BazaConfig.Glow.ColorStart or Color3.fromRGB(255, 255, 255),
                Transparency = false,
                Callback = function(arg1)
                    _G.BazaConfig.Glow.ColorStart = arg1
                end,
            }
        ):AddColorPicker(
            "box_glow_color_end",
            {
                Title = "glow color end",
                Default = _G.BazaConfig.Glow.ColorEnd or Color3.fromRGB(255, 255, 255),
                Transparency = false,
                Callback = function(arg1)
                    _G.BazaConfig.Glow.ColorEnd = arg1
                end,
            }
        )
        ExploitsSection:AddToggle(
            "textesp",
            {
                Text = "names", Default = _G.BazaConfig.TextESP.Names or false,
                Callback = function(arg1)
                    _G.BazaConfig.TextESP.Names = arg1
                end,
            }
        ):AddColorPicker(
            "name_color",
            {
                Title = "name color 1",
                Default = _G.BazaConfig.TextESP.NameColor or Color3.fromRGB(255, 255, 255),
                Transparency = false,
                Callback = function(arg1)
                    _G.BazaConfig.TextESP.NameColor = arg1
                end,
            }
        ):AddColorPicker(
            "name_color2",
            {
                Title = "name color 2",
                Default = _G.BazaConfig.TextESP.NameColor2 or Color3.fromRGB(255, 255, 255),
                Transparency = false,
                Callback = function(arg1)
                    _G.BazaConfig.TextESP.NameColor2 = arg1
                end,
            }
        )
        ExploitsSection:AddToggle(
            "textesp_distance",
            {
                Text = "distance", Default = _G.BazaConfig.TextESP.Distance or false,
                Callback = function(arg1)
                    _G.BazaConfig.TextESP.Distance = arg1
                end,
            }
        ):AddColorPicker(
            "distance_color",
            {
                Title = "distance color 1",
                Default = _G.BazaConfig.TextESP.DistanceColor or Color3.fromRGB(255, 255, 255),
                Transparency = false,
                Callback = function(arg1)
                    _G.BazaConfig.TextESP.DistanceColor = arg1
                end,
            }
        ):AddColorPicker(
            "distance_color2",
            {
                Title = "distance color 2",
                Default = _G.BazaConfig.TextESP.DistanceColor2 or Color3.fromRGB(255, 255, 255),
                Transparency = false,
                Callback = function(arg1)
                    _G.BazaConfig.TextESP.DistanceColor2 = arg1
                end,
            }
        )
        ExploitsSection:AddToggle(
            "textesp_tools",
            {
                Text = "tools", Default = _G.BazaConfig.TextESP.Tools or false,
                Callback = function(arg1)
                    _G.BazaConfig.TextESP.Tools = arg1
                end,
            }
        ):AddColorPicker(
            "tool_color",
            {
                Title = "tool color 1",
                Default = _G.BazaConfig.TextESP.ToolColor or Color3.fromRGB(255, 255, 255),
                Transparency = false,
                Callback = function(arg1)
                    _G.BazaConfig.TextESP.ToolColor = arg1
                end,
            }
        ):AddColorPicker(
            "tool_color2",
            {
                Title = "tool color 2",
                Default = _G.BazaConfig.TextESP.ToolColor2 or Color3.fromRGB(255, 255, 255),
                Transparency = false,
                Callback = function(arg1)
                    _G.BazaConfig.TextESP.ToolColor2 = arg1
                end,
            }
        )
        ExploitsSection:AddToggle(
            "tracers",
            {
                Text = "tracers", Default = _G.BazaConfig.Tracers.Enable or false,
                Callback = function(arg1)
                    _G.BazaConfig.Tracers.Enable = arg1
                end,
            }
        ):AddColorPicker(
            "tracers_color",
            {
                Title = "tracer color 1",
                Default = _G.BazaConfig.Tracers.Color or Color3.fromRGB(255, 255, 255),
                Transparency = false,
                Callback = function(arg1)
                    _G.BazaConfig.Tracers.Color = arg1
                end,
            }
        ):AddColorPicker(
            "tracers_color2",
            {
                Title = "tracer color 2",
                Default = _G.BazaConfig.Tracers.Color2 or Color3.fromRGB(255, 255, 255),
                Transparency = false,
                Callback = function(arg1)
                    _G.BazaConfig.Tracers.Color2 = arg1
                end,
            }
        )
        ExploitsSection:AddToggle(
            "chams",
            {
                Text = "chams", Default = _G.BazaConfig.Chams.Enable or false,
                Callback = function(arg1)
                    _G.BazaConfig.Chams.Enable = arg1
                end,
            }
        ):AddColorPicker(
            "chams_color",
            {
                Title = "chams color 1",
                Default = _G.BazaConfig.Chams.Color or Color3.fromRGB(255, 255, 255),
                Transparency = false,
                Callback = function(arg1)
                    _G.BazaConfig.Chams.Color = arg1
                end,
            }
        ):AddColorPicker(
            "chams_color2",
            {
                Title = "chams color 2",
                Default = _G.BazaConfig.Chams.Color2 or Color3.fromRGB(255, 255, 255),
                Transparency = false,
                Callback = function(arg1)
                    _G.BazaConfig.Chams.Color2 = arg1
                end,
            }
        )
        ExploitsSection:AddSlider(
            "box_filled_transparency",
            {
                Text = "fill transparency", Default = _G.BazaConfig.Filled.Transparency or 0.7,
                Min = 0, Max = 1, Rounding = 2, Compact = true,
                Callback = function(arg1)
                    _G.BazaConfig.Filled.Transparency = arg1
                end,
            }
        )
        ExploitsSection:AddSlider(
            "box_filled_rotation",
            {
                Text = "fill rotation", Default = _G.BazaConfig.Filled.Rotation or 0, Min = 0,
                Max = 360, Rounding = 0, Compact = true,
                Callback = function(arg1)
                    _G.BazaConfig.Filled.Rotation = arg1
                end,
            }
        )
        ExploitsSection:AddSlider(
            "box_filled_speed",
            {
                Text = "fill speed", Default = _G.BazaConfig.Filled.Speed or 1, Min = 0.1, Max = 10,
                Rounding = 1, Compact = true,
                Callback = function(arg1)
                    _G.BazaConfig.Filled.Speed = arg1
                end,
            }
        )
        ExploitsSection:AddSlider(
            "box_glow_transparency",
            {
                Text = "glow transparency", Default = _G.BazaConfig.Glow.Transparency or 0.8,
                Min = 0, Max = 1, Rounding = 2, Compact = true,
                Callback = function(arg1)
                    _G.BazaConfig.Glow.Transparency = arg1
                end,
            }
        )
        ExploitsSection:AddSlider(
            "box_glow_rotation",
            {
                Text = "glow rotation", Default = _G.BazaConfig.Glow.Rotation or 0, Min = 0,
                Max = 360, Rounding = 0, Compact = true,
                Callback = function(arg1)
                    _G.BazaConfig.Glow.Rotation = arg1
                end,
            }
        )
        ExploitsSection:AddSlider(
            "textesp_namesize",
            {
                Text = "name size", Default = _G.BazaConfig.TextESP.NameSize or 8, Min = 8,
                Max = 16, Rounding = 1, Compact = true,
                Callback = function(arg1)
                    _G.BazaConfig.TextESP.NameSize = arg1
                end,
            }
        )
        ExploitsSection:AddSlider(
            "textesp_distancesize",
            {
                Text = "distance size", Default = _G.BazaConfig.TextESP.DistanceSize or 8, Min = 8,
                Max = 14, Rounding = 1, Compact = true,
                Callback = function(arg1)
                    _G.BazaConfig.TextESP.DistanceSize = arg1
                end,
            }
        )
        ExploitsSection:AddSlider(
            "textesp_toolssize",
            {
                Text = "tools size", Default = _G.BazaConfig.TextESP.ToolsSize or 8, Min = 8,
                Max = 14, Rounding = 1, Compact = true,
                Callback = function(arg1)
                    _G.BazaConfig.TextESP.ToolsSize = arg1
                end,
            }
        )
        ExploitsSection:AddSlider(
            "tracers_thickness",
            {
                Text = "tracer thickness", Default = _G.BazaConfig.Tracers.Thickness or 1,
                Min = 0.5, Max = 5, Rounding = 1, Compact = true,
                Callback = function(arg1)
                    _G.BazaConfig.Tracers.Thickness = arg1
                end,
            }
        )
        ExploitsSection:AddSlider(
            "chams_transparency",
            {
                Text = "chams transparency", Default = _G.BazaConfig.Chams.Transparency or 0,
                Min = 0, Max = 1, Rounding = 2, Compact = true,
                Callback = function(arg1)
                    _G.BazaConfig.Chams.Transparency = arg1
                end,
            }
        )
    end)();
    (function()
        local v1 = getgenv().InstanceWorldToScreenEsp or getgenv().InstanceWorldToScreen
        local tbl = {
            enable = false, color = Color3.fromRGB(255, 255, 255),
            color2 = Color3.fromRGB(255, 255, 255), selected = {}, distance = false, images = false,
        }
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local ItemLibrary
        pcall(
            function()
                ItemLibrary = require(ReplicatedStorage.Modules.ItemLibrary)
            end
        )
        local tbl1 = {
            Grenade = "Grenade", SubspaceTripmineHitbox = "Substapce Tripmine",
            Flashbang = "Flashbang", Satchel = "Satchel", Warpstone = "Warpstone",
            Molotov = "Molotov", ["Smoke Grenade"] = "Smoke Grenade",
        }
        local tbl2 = {}
        local tbl3 = {
            Grenade = "rbxassetid://6603835352", Flashbang = "rbxassetid://243660364",
            Satchel = "rbxassetid://446111271", Warpstone = "rbxassetid://12781852245",
            Molotov = "rbxassetid://1084982556", ["Smoke Grenade"] = "rbxassetid://241650108",
            ["Subspace Tripmine"] = "rbxassetid://120777973",
        }
        local function func(arg1)
            if not arg1 or arg1 == "" then
                return ""
            end
            local str = tostring(arg1)
            if tonumber(str) then
                return "rbxassetid://" .. str
            end
            return str
        end
        local function func1(arg1)
            if tbl2[arg1] ~= nil then
                return tbl2[arg1]
            end
            local str = ""
            local tbl = {}
            local v1 = tbl1[arg1]
            if v1 then
                tbl[#tbl + 1] = v1
            end
            if arg1 == "SubspaceTripmineHitbox" then
                tbl[#tbl + 1] = "Subspace Tripmine"
            end
            savedElements[#savedElements + 1] = arg1
            pcall(
                function()
                    for _, v1 in ipairs(tbl) do
                        if str ~= "" then
                            break
                        end
                        if ItemLibrary and ItemLibrary.GetWeaponImage then
                            str = ItemLibrary:GetWeaponImage(v1, true) or ""
                        end
                        if str == "" and ItemLibrary and ItemLibrary.GetImageFromWeaponData then
                            str = ItemLibrary:GetImageFromWeaponData(
                                {Name = v1, Weapon = v1, WeaponName = v1}, true
                            ) or ""
                        end
                    end
                end
            )
            local v2 = func(str)
            if v2 == "" then
                v2 = tbl3[arg1] or tbl3[tbl1[arg1]] or ""
            end
            tbl2[arg1] = v2
            return v2
        end
        local tbl4 = {
            grenade = "Grenade", ["subspace tripmine"] = "SubspaceTripmineHitbox",
            flashbang = "Flashbang", satchel = "Satchel", warpstone = "Warpstone",
            molotov = "Molotov", ["smoke grenade"] = "Smoke Grenade",
        }
        local tbl5 = {}
        for k, v2 in pairs(tbl4) do
            tbl5[v2] = k
        end
        local function func2()
            for k in pairs(tbl4) do
                if tbl.selected[k] then
                    return true
                end
            end
            return false
        end
        local function func3(arg1)
            if not func2() then
                for _, v1 in pairs(tbl4) do
                    if v1 == arg1 then
                        return true
                    end
                end
                return false
            end
            for k, v2 in pairs(tbl4) do
                if v2 == arg1 and tbl.selected[k] then
                    return true
                end
            end
            return false
        end
        local function getClosestEnemy(arg1)
            if getgenv().InstanceTrackDrawingText then
                return getgenv().InstanceTrackDrawingText(arg1)
            end
            return arg1
        end
        local tbl6 = {}
        local function toggleTeleportToEnemy(arg1, arg2)
            if not Drawing or not Drawing.new then
                return nil
            end
            local v1, v2 = pcall(
                function()
                    local drawing = Drawing.new("Text")
                    return getClosestEnemy(drawing)
                end
            )
            if not v1 or not v2 then
                return nil
            end
            v2.Text = arg1
            v2.Color = arg2
            v2.Size = 15
            v2.Visible = false
            v2.Outline = true
            v2.OutlineColor = Color3.new(0, 0, 0)
            v2.Center = true
            v2.Font = getgenv().InstanceHudDrawFont or 2
            return v2
        end
        local function func6(arg1)
            local imageLabel = Instance.new("ImageLabel")
            imageLabel.BackgroundTransparency = 1
            imageLabel.BorderSizePixel = 0
            imageLabel.Image = arg1 or ""
            imageLabel.ImageTransparency = 0
            imageLabel.Size = UDim2.fromOffset(36, 36)
            imageLabel.Visible = false
            imageLabel.ZIndex = 10
            imageLabel.Parent = espgui
            return imageLabel
        end
        local function func7(arg1)
            if not arg1 then
                return nil, nil
            end
            if arg1:IsA("Model") then
                return
                    arg1,
                    arg1.PrimaryPart or arg1:FindFirstChild("Hitbox") or arg1:FindFirstChildWhichIsA(
                        "BasePart"
                    )
            end
            if arg1:IsA("BasePart") then
                return arg1.Parent and arg1.Parent:IsA("Model") and arg1.Parent or nil or arg1, arg1
            end
            return nil, nil
        end
        local function func8(arg1)
            local v1, v2 = func7(arg1)
            if not v1 or not v2 then
                return false
            end
            local v3 = v1:IsA("Model")
            return (func3(v3 and v1.Name or arg1.Name))
        end
        local function func9(arg1)
            if tbl6[arg1] then
                for _, v1 in ipairs(tbl6[arg1].drawings) do
                    pcall(
                        function()
                            v1:Remove()
                        end
                    )
                end
                if tbl6[arg1].image then
                    pcall(
                        function()
                            if typeof(tbl6[arg1].image) == "Instance" and tbl6[arg1].image:IsA(
                                "GuiObject"
                            ) then
                                tbl6[arg1].image:Destroy()
                            else
                                tbl6[arg1].image:Remove()
                            end
                        end
                    )
                end
                if tbl6[arg1].conn then
                    tbl6[arg1].conn:Disconnect()
                end
                tbl6[arg1] = nil
            end
        end
        local function func10()
            for k in pairs(tbl6) do
                func9(k)
            end
        end
        local function func11(arg1)
            local v2, v3 = func7(arg1)
            if not v2 or not v3 then
                return
            end
            if tbl6[v2] then
                return
            end
            local v4 = v2:IsA("Model") and v2.Name or tostring(v2)
            local v5 = tbl5[v4] or string.lower(v4)
            local v6 = toggleTeleportToEnemy(v5, tbl.color)
            local v7 = toggleTeleportToEnemy("", tbl.color)
            local v8 = func6((func1(v4)))
            if not v6 and not v7 then
                return
            end
            local tbl1 = {drawings = {}, image = v8}
            tbl1.conn = nil
            tbl1.root = v3
            tbl6[v2] = tbl1
            if v6 then
                tbl6[v2].drawings[#tbl6[v2].drawings + 1] = v6
            end
            if v7 then
                tbl6[v2].drawings[#tbl6[v2].drawings + 1] = v7
            end
            local connection = game:GetService("RunService").RenderStepped:Connect(
                function()
                    pcall(
                        function()
                            local v3 = tbl6[v2] and tbl6[v2].root
                            if not v3 or not v3.Parent then
                                func9(v2)
                                return
                            end
                            local CurrentCamera = workspace.CurrentCamera
                            if not CurrentCamera or not v1 then
                                return
                            end
                            local v5, v9 = v1(v3.Position)
                            if v9 and tbl.enable and func3(v4) then
                                if tbl.images and v8 and (not v8.Image or v8.Image == "") then
                                    local v10 = func1(v4)
                                    if v10 ~= "" then
                                        v8.Image = v10
                                    end
                                end
                                local v11 = tbl.images and v8 and v8.Image and v8.Image ~= ""
                                if v6 then
                                    if v11 then
                                        v6.Position = Vector2.new(v5.X, v5.Y - 18 - 14)
                                    else
                                        v6.Position = Vector2.new(v5.X, v5.Y - 8)
                                    end
                                    v6.Visible = true
                                end
                                if v8 then
                                    if v11 then
                                        v8.Position = UDim2.new(0, v5.X - 18, 0, v5.Y - 18)
                                        v8.Visible = true
                                    else
                                        v8.Visible = false
                                    end
                                end
                                if v7 then
                                    if tbl.distance then
                                        local v12 = math.floor(
                                            (CurrentCamera.CFrame.Position - v3.Position).Magnitude
                                        )
                                        v7.Text = getgenv().InstanceL("studs_short", v12)
                                        if v11 then
                                            v7.Position = Vector2.new(v5.X, v5.Y + 18 + 6)
                                        else
                                            v7.Position = Vector2.new(v5.X, v5.Y + 6)
                                        end
                                        v7.Visible = true
                                    else
                                        v7.Visible = false
                                    end
                                end
                            else
                                if v6 then
                                    v6.Visible = false
                                end
                                if v7 then
                                    v7.Visible = false
                                end
                                if v8 then
                                    v8.Visible = false
                                end
                            end
                        end
                    )
                end
            )
            tbl6[v2].conn = connection
            v2.AncestryChanged:Connect(
                function(_, arg2)
                    if not arg2 then
                        func9(v2)
                    end
                end
            )
        end
        local function func12()
            func10()
            if not tbl.enable then
                return
            end
            for _, v1 in ipairs(workspace:GetDescendants()) do
                if (v1:IsA("Model") or v1:IsA("BasePart")) and func8(v1) then
                    func11(v1)
                end
            end
        end
        local v3 = _raw:AddLeftGroupbox("utility")
        v3:AddToggle(
            "utilenable",
            {
                Text = "enable", Default = tbl.enable,
                Callback = function(arg1)
                    tbl.enable = arg1
                    func12()
                end,
            }
        ):AddColorPicker(
            "utilcolor",
            {
                Title = "text color 1", Default = tbl.color, Transparency = false,
                Callback = function(arg1)
                    tbl.color = arg1
                    for _, v1 in pairs(tbl6) do
                        for _, v2 in ipairs(v1.drawings) do
                            v2.Color = arg1
                        end
                    end
                end,
            }
        ):AddColorPicker(
            "utilcolor2",
            {
                Title = "text color 2", Default = tbl.color2 or tbl.color, Transparency = false,
                Callback = function(arg1)
                    tbl.color2 = arg1
                end,
            }
        )
        v3:AddDropdown(
            "utilitems",
            {
                Text = "utilities",
                Values = {
                    "grenade", "subspace tripmine", "flashbang", "satchel", "warpstone", "molotov",
                    "smoke grenade"
                }, Multi = true, Default = {},
                Callback = function(arg1)
                    tbl.selected = arg1
                    func12()
                end,
            }
        )
        v3:AddToggle(
            "utildistance",
            {
                Text = "distance", Default = tbl.distance,
                Callback = function(arg1)
                    tbl.distance = arg1
                end,
            }
        )
        v3:AddToggle(
            "utilimages",
            {
                Text = "images", Default = tbl.images,
                Callback = function(arg1)
                    tbl.images = arg1
                end,
            }
        )
        workspace.DescendantAdded:Connect(
            function(arg1)
                if not tbl.enable then
                    return
                end
                if not arg1:IsA("Model") and not arg1:IsA("BasePart") then
                    return
                end
                task.delay(
                    0.15,
                    function()
                        if not tbl.enable then
                            return
                        end
                        if func8(arg1) then
                            func11(arg1)
                        end
                    end
                )
            end
        )
    end)();
    (function()
        local v1 = _G
        v1.LightingSettings = v1.LightingSettings or {
            Enabled = false, Ambient = {Enabled = false, Color = Color3.fromRGB(255, 255, 255)},
            OutdoorAmbient = {Enabled = false, Color = Color3.fromRGB(255, 255, 255)},
            GlobalShadows = {Enabled = true}, ShadowSoftness = {Enabled = false, Value = 0.2},
            SunColor = {Enabled = false, Color = Color3.fromRGB(255, 255, 255)},
            ColorShiftTop = {Enabled = false, Color = Color3.fromRGB(255, 255, 255)},
            ColorShiftBottom = {Enabled = false, Color = Color3.fromRGB(255, 255, 255)},
            ClockTime = {Enabled = false, Value = 12},
            GeographicLatitude = {Enabled = false, Value = 41.8},
            Fog = {Enabled = false, Color = Color3.fromRGB(255, 255, 255), Start = 0, End = 100},
            EnvironmentDiffuseScale = {Enabled = false, Value = 1},
            EnvironmentSpecularScale = {Enabled = false, Value = 1},
            ColorCorrection = {Enabled = false, Contrast = 0, Saturation = 0, Brightness = 0},
            Bloom = {Enabled = false, Multiplier = 0.3, Threshold = 0.6},
        }
        local tbl = {}
        local v8
        local colorCorrectionEffect
        local tbl1 = {}
        local function func()
            local v1 = _G.LightingSettings and _G.LightingSettings.Bloom
            if not v1 then
                return
            end
            local v2 = math.clamp(tonumber(v1.Multiplier) or 1, 0, 1.5)
            for _, v3 in ipairs(game:GetService("Lighting"):GetChildren()) do
                if v3:IsA("BloomEffect") and v3.Name ~= "InstanceExtraBloom" then
                    v3.Enabled = false
                end
            end
            if v1.Enabled then
                local InstanceExtraBloom = game:GetService("Lighting"):FindFirstChild(
                    "InstanceExtraBloom"
                )
                if not InstanceExtraBloom then
                    local bloomEffect = Instance.new("BloomEffect")
                    InstanceExtraBloom = bloomEffect
                    bloomEffect.Name = "InstanceExtraBloom"
                    bloomEffect.Parent = game:GetService("Lighting")
                end
                InstanceExtraBloom.Intensity = v2 * 0.8
                InstanceExtraBloom.Size = 4
                InstanceExtraBloom.Threshold = 0.7
                InstanceExtraBloom.Enabled = true
            else
                local InstanceExtraBloom1 = game:GetService("Lighting"):FindFirstChild(
                    "InstanceExtraBloom"
                )
                if InstanceExtraBloom1 then
                    InstanceExtraBloom1:Destroy()
                end
                for _, v4 in ipairs(game:GetService("Lighting"):GetChildren()) do
                    if v4:IsA("BloomEffect") and v4.Name ~= "InstanceExtraBloom" then
                        local v5 = tbl1[v4]
                        if v5 then
                            v4.Intensity = v5.Intensity
                            v4.Size = v5.Size
                            v4.Threshold = v5.Threshold
                            v4.Enabled = v5.Enabled
                        end
                    end
                end
            end
        end;
        (function()
            tbl.Ambient = game:GetService("Lighting").Ambient
            tbl.OutdoorAmbient = game:GetService("Lighting").OutdoorAmbient
            tbl.GlobalShadows = game:GetService("Lighting").GlobalShadows
            tbl.ShadowSoftness = game:GetService("Lighting").ShadowSoftness
            tbl.ColorShift_Top = game:GetService("Lighting").ColorShift_Top
            tbl.ColorShift_Bottom = game:GetService("Lighting").ColorShift_Bottom
            tbl.ClockTime = game:GetService("Lighting").ClockTime
            tbl.GeographicLatitude = game:GetService("Lighting").GeographicLatitude
            tbl.FogColor = game:GetService("Lighting").FogColor
            tbl.FogStart = game:GetService("Lighting").FogStart
            tbl.FogEnd = game:GetService("Lighting").FogEnd
            tbl.EnvironmentDiffuseScale = game:GetService("Lighting").EnvironmentDiffuseScale
            tbl.EnvironmentSpecularScale = game:GetService("Lighting").EnvironmentSpecularScale
        end)()
        local function func1()
            return _G.Features and _G.Features.QOL and _G.Features.QOL.Shaders
        end
        local function func2(arg1, arg2, arg3)
            return Color3.new(
                arg1.R + (arg2.R - arg1.R) * arg3, arg1.G + (arg2.G - arg1.G) * arg3,
                arg1.B + (arg2.B - arg1.B) * arg3
            )
        end
        local function func3()
            local ColorCorrection = _G.LightingSettings.ColorCorrection
            if ColorCorrection and ColorCorrection.Enabled then
                if not colorCorrectionEffect or not colorCorrectionEffect.Parent then
                    colorCorrectionEffect = Instance.new("ColorCorrectionEffect")
                    local v1 = colorCorrectionEffect
                    v1.Name = "InstanceExtraColorCorrection"
                    v1.Parent = game:GetService("Lighting")
                end
                colorCorrectionEffect.Contrast = ColorCorrection.Contrast / 10
                colorCorrectionEffect.Saturation = ColorCorrection.Saturation / 10
                colorCorrectionEffect.Brightness = ColorCorrection.Brightness / 10
                colorCorrectionEffect.Enabled = true
            elseif colorCorrectionEffect then
                colorCorrectionEffect.Enabled = false
            end
            func()
        end
        local function getClosestEnemy()
            for k, v1 in pairs(tbl1) do
                if k.Parent then
                    k.Intensity = v1.Intensity
                    k.Size = v1.Size
                    k.Threshold = v1.Threshold
                    k.Enabled = v1.Enabled
                end
            end
            local InstanceExtraBloom = game:GetService("Lighting"):FindFirstChild(
                "InstanceExtraBloom"
            )
            if InstanceExtraBloom then
                InstanceExtraBloom:Destroy()
            end
        end
        local function toggleTeleportToEnemy()
            if colorCorrectionEffect then
                colorCorrectionEffect.Enabled = false
            end
            getClosestEnemy()
        end
        local function func6()
            if v8 then
                v8:Disconnect()
                v8 = nil
            end
            v8 = game:GetService("RunService").RenderStepped:Connect(
                function()
                    if not _G.LightingSettings.Enabled then
                        return
                    end
                    if _G.LightingSettings.Ambient.Enabled then
                        game:GetService("Lighting").Ambient = _G.LightingSettings.Ambient.Color
                    elseif not func1() then
                        game:GetService("Lighting").Ambient = tbl.Ambient
                    end
                    if _G.LightingSettings.SunColor.Enabled then
                        local v1 = _G.LightingSettings.OutdoorAmbient.Enabled and _G.LightingSettings.OutdoorAmbient.Color or (func1(
                        ) and Color3.fromRGB(88, 108, 140) or tbl.OutdoorAmbient)
                        game:GetService("Lighting").OutdoorAmbient = func2(
                            v1, _G.LightingSettings.SunColor.Color, 0.55
                        )
                    elseif _G.LightingSettings.OutdoorAmbient.Enabled then
                        game:GetService("Lighting").OutdoorAmbient = _G.LightingSettings.OutdoorAmbient.Color
                    elseif not func1() then
                        game:GetService("Lighting").OutdoorAmbient = tbl.OutdoorAmbient
                    end
                    if _G.LightingSettings.GlobalShadows.Enabled ~= nil then
                        game:GetService("Lighting").GlobalShadows = _G.LightingSettings.GlobalShadows.Enabled
                    else
                        game:GetService("Lighting").GlobalShadows = tbl.GlobalShadows
                    end
                    if _G.LightingSettings.ShadowSoftness.Enabled then
                        game:GetService("Lighting").ShadowSoftness = _G.LightingSettings.ShadowSoftness.Value
                    elseif not func1() then
                        game:GetService("Lighting").ShadowSoftness = tbl.ShadowSoftness
                    end
                    if _G.LightingSettings.SunColor.Enabled then
                        game:GetService("Lighting").ColorShift_Top = _G.LightingSettings.SunColor.Color
                    elseif _G.LightingSettings.ColorShiftTop.Enabled then
                        game:GetService("Lighting").ColorShift_Top = _G.LightingSettings.ColorShiftTop.Color
                    elseif not func1() then
                        game:GetService("Lighting").ColorShift_Top = tbl.ColorShift_Top
                    end
                    if _G.LightingSettings.ColorShiftBottom.Enabled then
                        game:GetService("Lighting").ColorShift_Bottom = _G.LightingSettings.ColorShiftBottom.Color
                    elseif not func1() then
                        game:GetService("Lighting").ColorShift_Bottom = tbl.ColorShift_Bottom
                    end
                    if _G.LightingSettings.ClockTime.Enabled then
                        game:GetService("Lighting").ClockTime = _G.LightingSettings.ClockTime.Value
                    else
                        game:GetService("Lighting").ClockTime = tbl.ClockTime
                    end
                    if _G.LightingSettings.GeographicLatitude.Enabled then
                        game:GetService("Lighting").GeographicLatitude = _G.LightingSettings.GeographicLatitude.Value
                    else
                        game:GetService("Lighting").GeographicLatitude = tbl.GeographicLatitude
                    end
                    if _G.LightingSettings.Fog.Enabled then
                        local Lighting = game:GetService("Lighting")
                        local v2 = _G
                        Lighting.FogColor = v2.LightingSettings.Fog.Color
                        game:GetService("Lighting").FogStart = v2.LightingSettings.Fog.Start
                        game:GetService("Lighting").FogEnd = v2.LightingSettings.Fog.End
                    else
                        game:GetService("Lighting").FogColor = tbl.FogColor
                        game:GetService("Lighting").FogStart = tbl.FogStart
                        game:GetService("Lighting").FogEnd = tbl.FogEnd
                    end
                    if _G.LightingSettings.EnvironmentDiffuseScale.Enabled then
                        game:GetService("Lighting").EnvironmentDiffuseScale = _G.LightingSettings.EnvironmentDiffuseScale.Value
                    elseif not func1() then
                        game:GetService("Lighting").EnvironmentDiffuseScale = tbl.EnvironmentDiffuseScale
                    end
                    if _G.LightingSettings.EnvironmentSpecularScale.Enabled then
                        game:GetService("Lighting").EnvironmentSpecularScale = _G.LightingSettings.EnvironmentSpecularScale.Value
                    elseif not func1() then
                        game:GetService("Lighting").EnvironmentSpecularScale = tbl.EnvironmentSpecularScale
                    end
                end
            )
        end
        local function func7()
            if v8 then
                v8:Disconnect()
                v8 = nil
            end
            game:GetService("Lighting").GlobalShadows = tbl.GlobalShadows
            game:GetService("Lighting").ClockTime = tbl.ClockTime
            game:GetService("Lighting").GeographicLatitude = tbl.GeographicLatitude
            game:GetService("Lighting").FogColor = tbl.FogColor
            game:GetService("Lighting").FogStart = tbl.FogStart
            game:GetService("Lighting").FogEnd = tbl.FogEnd
            if not func1() then
                game:GetService("Lighting").Ambient = tbl.Ambient
                game:GetService("Lighting").OutdoorAmbient = tbl.OutdoorAmbient
                game:GetService("Lighting").ShadowSoftness = tbl.ShadowSoftness
                game:GetService("Lighting").ColorShift_Top = tbl.ColorShift_Top
                game:GetService("Lighting").ColorShift_Bottom = tbl.ColorShift_Bottom
                game:GetService("Lighting").EnvironmentDiffuseScale = tbl.EnvironmentDiffuseScale
                game:GetService("Lighting").EnvironmentSpecularScale = tbl.EnvironmentSpecularScale
                for _, v1 in ipairs(game:GetService("Lighting"):GetChildren()) do
                    if v1:IsA("Atmosphere") then
                        v1:Destroy()
                    end
                end
                if origatmo then
                    local atmosphere = Instance.new("Atmosphere")
                    local v2 = origatmo
                    atmosphere.Density = v2.Density
                    atmosphere.Offset = v2.Offset
                    atmosphere.Haze = v2.Haze
                    atmosphere.Glare = v2.Glare
                    atmosphere.Color = v2.Color
                    atmosphere.Decay = v2.Decay
                    atmosphere.Parent = game:GetService("Lighting")
                end
            end
            func3()
        end
        local v2 = _raw:AddRightGroupbox("lighting")
        local v3 = _G
        v2:AddToggle(
            "lighting_master",
            {
                Text = "enable", Default = v3.LightingSettings.Enabled,
                Callback = function(arg1)
                    _G.LightingSettings.Enabled = arg1
                    if arg1 then
                        func6()
                    else
                        func7()
                    end
                end,
            }
        )
        v2:AddToggle(
            "lighting_ambient",
            {
                Text = "custom ambient", Default = v3.LightingSettings.Ambient.Enabled,
                Callback = function(arg1)
                    _G.LightingSettings.Ambient.Enabled = arg1
                end,
            }
        ):AddColorPicker(
            "lighting_ambient_color",
            {
                Default = v3.LightingSettings.Ambient.Color, Title = "ambient color",
                Callback = function(arg1)
                    _G.LightingSettings.Ambient.Color = arg1
                end,
            }
        )
        v2:AddToggle(
            "lighting_outdoorambient",
            {
                Text = "custom outdoor ambient",
                Default = v3.LightingSettings.OutdoorAmbient.Enabled,
                Callback = function(arg1)
                    _G.LightingSettings.OutdoorAmbient.Enabled = arg1
                end,
            }
        ):AddColorPicker(
            "lighting_outdoorambient_color",
            {
                Default = v3.LightingSettings.OutdoorAmbient.Color, Title = "outdoor ambient color",
                Callback = function(arg1)
                    _G.LightingSettings.OutdoorAmbient.Color = arg1
                end,
            }
        )
        v2:AddToggle(
            "lighting_suncolor",
            {
                Text = "custom sun color", Default = v3.LightingSettings.SunColor.Enabled,
                Callback = function(arg1)
                    _G.LightingSettings.SunColor.Enabled = arg1
                end,
            }
        ):AddColorPicker(
            "lighting_suncolor_color",
            {
                Default = v3.LightingSettings.SunColor.Color, Title = "sun color",
                Callback = function(arg1)
                    _G.LightingSettings.SunColor.Color = arg1
                end,
            }
        )
        v2:AddToggle(
            "lighting_globalshadows",
            {
                Text = "global shadows", Default = v3.LightingSettings.GlobalShadows.Enabled,
                Callback = function(arg1)
                    _G.LightingSettings.GlobalShadows.Enabled = arg1
                end,
            }
        )
        v2:AddToggle(
            "lighting_shadowsoftness",
            {
                Text = "custom shadow softness",
                Default = v3.LightingSettings.ShadowSoftness.Enabled,
                Callback = function(arg1)
                    _G.LightingSettings.ShadowSoftness.Enabled = arg1
                end,
            }
        )
        v2:AddToggle(
            "lighting_colorshifttop",
            {
                Text = "color shift top", Default = v3.LightingSettings.ColorShiftTop.Enabled,
                Callback = function(arg1)
                    _G.LightingSettings.ColorShiftTop.Enabled = arg1
                end,
            }
        ):AddColorPicker(
            "lighting_colorshifttop_color",
            {
                Default = v3.LightingSettings.ColorShiftTop.Color, Title = "top color",
                Callback = function(arg1)
                    _G.LightingSettings.ColorShiftTop.Color = arg1
                end,
            }
        )
        v2:AddToggle(
            "lighting_colorshiftbottom",
            {
                Text = "color shift bottom", Default = v3.LightingSettings.ColorShiftBottom.Enabled,
                Callback = function(arg1)
                    _G.LightingSettings.ColorShiftBottom.Enabled = arg1
                end,
            }
        ):AddColorPicker(
            "lighting_colorshiftbottom_color",
            {
                Default = v3.LightingSettings.ColorShiftBottom.Color, Title = "bottom color",
                Callback = function(arg1)
                    _G.LightingSettings.ColorShiftBottom.Color = arg1
                end,
            }
        )
        v2:AddToggle(
            "lighting_clocktime",
            {
                Text = "custom time", Default = v3.LightingSettings.ClockTime.Enabled,
                Callback = function(arg1)
                    _G.LightingSettings.ClockTime.Enabled = arg1
                end,
            }
        )
        v2:AddToggle(
            "lighting_latitude",
            {
                Text = "custom latitude", Default = v3.LightingSettings.GeographicLatitude.Enabled,
                Callback = function(arg1)
                    _G.LightingSettings.GeographicLatitude.Enabled = arg1
                end,
            }
        )
        v2:AddToggle(
            "lighting_fog",
            {
                Text = "custom fog", Default = v3.LightingSettings.Fog.Enabled,
                Callback = function(arg1)
                    _G.LightingSettings.Fog.Enabled = arg1
                end,
            }
        ):AddColorPicker(
            "lighting_fog_color",
            {
                Default = v3.LightingSettings.Fog.Color, Title = "fog color",
                Callback = function(arg1)
                    _G.LightingSettings.Fog.Color = arg1
                end,
            }
        )
        v2:AddToggle(
            "lighting_diffuse",
            {
                Text = "custom diffuse scale",
                Default = v3.LightingSettings.EnvironmentDiffuseScale.Enabled,
                Callback = function(arg1)
                    _G.LightingSettings.EnvironmentDiffuseScale.Enabled = arg1
                end,
            }
        )
        v2:AddToggle(
            "lighting_specular",
            {
                Text = "custom specular scale",
                Default = v3.LightingSettings.EnvironmentSpecularScale.Enabled,
                Callback = function(arg1)
                    _G.LightingSettings.EnvironmentSpecularScale.Enabled = arg1
                end,
            }
        )
        v2:AddSlider(
            "lighting_shadowsoftness_value",
            {
                Text = "shadow softness", Min = 0, Max = 1, Default = 0.2, Rounding = 2,
                Compact = true,
                Callback = function(arg1)
                    _G.LightingSettings.ShadowSoftness.Value = arg1
                end,
            }
        )
        v2:AddSlider(
            "lighting_clocktime_value",
            {
                Text = "hour", Min = 0, Max = 24, Default = 12, Rounding = 1, Compact = true,
                Callback = function(arg1)
                    _G.LightingSettings.ClockTime.Value = arg1
                end,
            }
        )
        v2:AddSlider(
            "lighting_latitude_value",
            {
                Text = "geographic latitude", Min = -90, Max = 90, Default = 41.8, Rounding = 1,
                Compact = true,
                Callback = function(arg1)
                    _G.LightingSettings.GeographicLatitude.Value = arg1
                end,
            }
        )
        v2:AddSlider(
            "lighting_fogstart",
            {
                Text = "fog start", Min = 0, Max = 1000, Default = 0, Rounding = 0, Compact = true,
                Callback = function(arg1)
                    _G.LightingSettings.Fog.Start = arg1
                end,
            }
        )
        v2:AddSlider(
            "lighting_fogend",
            {
                Text = "fog end", Min = 0, Max = 100000, Default = 100, Rounding = 0,
                Compact = true,
                Callback = function(arg1)
                    _G.LightingSettings.Fog.End = arg1
                end,
            }
        )
        v2:AddSlider(
            "lighting_diffuse_value",
            {
                Text = "diffuse scale", Min = 0, Max = 2, Default = 1, Rounding = 2, Compact = true,
                Callback = function(arg1)
                    _G.LightingSettings.EnvironmentDiffuseScale.Value = arg1
                end,
            }
        )
        v2:AddSlider(
            "lighting_specular_value",
            {
                Text = "specular scale", Min = 0, Max = 2, Default = 1, Rounding = 2,
                Compact = true,
                Callback = function(arg1)
                    _G.LightingSettings.EnvironmentSpecularScale.Value = arg1
                end,
            }
        )
        local v4 = _raw:AddRightTabbox()
        local v5 = v4:AddTab("color")
        local v6 = v4:AddTab("bloom")
        local v7 = _G
        v5:AddToggle(
            "lighting_color_correction",
            {
                Text = "enable", Default = v7.LightingSettings.ColorCorrection.Enabled,
                Callback = function(arg1)
                    _G.LightingSettings.ColorCorrection.Enabled = arg1
                    func3()
                end,
            }
        )
        v5:AddSlider(
            "lighting_cc_contrast",
            {
                Text = "contrast", Min = -10, Max = 10,
                Default = v7.LightingSettings.ColorCorrection.Contrast, Rounding = 1,
                Compact = true,
                Callback = function(arg1)
                    local v1 = _G
                    v1.LightingSettings.ColorCorrection.Contrast = arg1
                    if v1.LightingSettings.ColorCorrection.Enabled then
                        func3()
                    end
                end,
            }
        )
        v5:AddSlider(
            "lighting_cc_saturation",
            {
                Text = "saturation", Min = -10, Max = 10,
                Default = v7.LightingSettings.ColorCorrection.Saturation, Rounding = 1,
                Compact = true,
                Callback = function(arg1)
                    local v1 = _G
                    v1.LightingSettings.ColorCorrection.Saturation = arg1
                    if v1.LightingSettings.ColorCorrection.Enabled then
                        func3()
                    end
                end,
            }
        )
        v5:AddSlider(
            "lighting_cc_brightness",
            {
                Text = "brightness", Min = -10, Max = 10,
                Default = v7.LightingSettings.ColorCorrection.Brightness, Rounding = 1,
                Compact = true,
                Callback = function(arg1)
                    local v1 = _G
                    v1.LightingSettings.ColorCorrection.Brightness = arg1
                    if v1.LightingSettings.ColorCorrection.Enabled then
                        func3()
                    end
                end,
            }
        )
        ExploitsSection:AddToggle(
            "lighting_bloom_modifier",
            {
                Text = "enable", Default = v7.LightingSettings.Bloom.Enabled,
                Callback = function(arg1)
                    _G.LightingSettings.Bloom.Enabled = arg1
                    if not arg1 then
                        getClosestEnemy()
                    end
                    func3()
                end,
            }
        )
        ExploitsSection:AddSlider(
            "lighting_bloom_multiplier",
            {
                Text = "emissive intensity", Min = 0, Max = 1.5,
                Default = v7.LightingSettings.Bloom.Multiplier, Rounding = 2, Compact = true,
                Callback = function(arg1)
                    local v1 = _G
                    v1.LightingSettings.Bloom.Multiplier = arg1
                    if v1.LightingSettings.Bloom.Enabled then
                        local InstanceExtraBloom = game:GetService("Lighting"):FindFirstChild(
                            "InstanceExtraBloom"
                        )
                        if InstanceExtraBloom then
                            InstanceExtraBloom.Intensity = arg1 * 0.8
                        end
                    end
                end,
            }
        )
        ExploitsSection:AddSlider(
            "lighting_bloom_size",
            {
                Text = "glow size", Min = 2, Max = 8, Default = 4, Rounding = 1, Compact = true,
                Callback = function(arg1)
                    local v1 = _G
                    v1.LightingSettings.Bloom.Size = arg1
                    if v1.LightingSettings.Bloom.Enabled then
                        local InstanceExtraBloom = game:GetService("Lighting"):FindFirstChild(
                            "InstanceExtraBloom"
                        )
                        if InstanceExtraBloom then
                            InstanceExtraBloom.Size = arg1
                        end
                    end
                end,
            }
        )
        ExploitsSection:AddSlider(
            "lighting_bloom_threshold",
            {
                Text = "brightness threshold", Min = 0.5, Max = 1, Default = 0.7, Rounding = 2,
                Compact = true,
                Callback = function(arg1)
                    local v1 = _G
                    v1.LightingSettings.Bloom.Threshold = arg1
                    if v1.LightingSettings.Bloom.Enabled then
                        local InstanceExtraBloom = game:GetService("Lighting"):FindFirstChild(
                            "InstanceExtraBloom"
                        )
                        if InstanceExtraBloom then
                            InstanceExtraBloom.Threshold = arg1
                        end
                    end
                end,
            }
        )
        game:GetService("Lighting").ChildAdded:Connect(
            function(arg1)
                if arg1:IsA("BloomEffect") then
                    task.defer(func3)
                end
            end
        )
        game:GetService("ScriptContext").DescendantRemoving:Connect(
            function(arg1)
                if arg1 == script then
                    func7()
                    toggleTeleportToEnemy()
                end
            end
        )
    end)();
    (function()
        getgenv().crosshair = {
            enabled = false, refreshrate = 0.016, mode = "mouse", position = Vector2.new(0, 0),
            crosshair_mode = "static", width = 1.5, length = 10, radius = 11,
            crosshair_color = Color3.fromRGB(0, 200, 255), color1 = Color3.fromRGB(0, 200, 255),
            color2 = Color3.fromRGB(0, 153, 255), color3 = Color3.fromRGB(0, 107, 255),
            gradient_rotation = 0, spin = true, spin_speed = 150, spin_max = 340,
            spin_style = Enum.EasingStyle.Sine, resize = true, resize_speed = 150, resize_min = 5,
            resize_max = 22, scale_min = 1, scale_max = 1, show_ammo = false, show_watermark = true,
            show_lines = true,
        }
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        local TweenService = game:GetService("TweenService")
        local CurrentCamera = workspace.CurrentCamera
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local function func(arg1, arg2, arg3, arg4, arg5)
            local v1 = math.rad(arg2)
            local v2 = (arg1 * math.cos(v1) + (1 - arg1) * math.sin(v1)) % 1
            if v2 < 0.5 then
                local v3 = v2 * 2
                return Color3.new(
                    arg3.R + (arg4.R - arg3.R) * v3, arg3.G + (arg4.G - arg3.G) * v3,
                    arg3.B + (arg4.B - arg3.B) * v3
                )
            end
            local v4 = (v2 - 0.5) * 2
            return Color3.new(
                arg4.R + (arg5.R - arg4.R) * v4, arg4.G + (arg5.G - arg4.G) * v4,
                arg4.B + (arg5.B - arg4.B) * v4
            )
        end
        local tbl = {}
        for i = 1, 27 do
            local v1 = getgenv().InstanceTrackDrawingText(Drawing.new("Text"))
            v1.Size = 13
            v1.Font = 2
            v1.Outline = true
            v1.Text = ("Baza Hub | Baza2000ultrapro"):sub(i, i)
            v1.Color = Color3.new(1, 1, 1)
            tbl[i] = v1
        end
        local drawing = Drawing.new("Text")
        drawing.Size = 13
        drawing.Font = 2
        drawing.Text = "Baza Hub | Baza2000ultrapro"
        drawing.Visible = false
        local v2 = getgenv().InstanceTrackDrawingText(Drawing.new("Text"))
        v2.Size = 13
        v2.Font = 2
        v2.Outline = true
        v2.Color = Color3.new(1, 1, 1)
        v2.Visible = false
        local str = ""
        local num = 0
        local tbl1 = {}
        for i1 = 1, 8 do
            tbl1[i1] = Drawing.new("Line")
        end
        local num1 = 0
        local tbl2 = {0, 90, 180, 270}
        local function func1(arg1, arg2)
            local v1 = math.rad(arg1)
            return Vector2.new(math.sin(v1) * arg2, math.cos(v1) * arg2)
        end
        local function func2()
            local ViewModels = workspace:FindFirstChild("ViewModels")
            if not ViewModels then
                return nil
            end
            local FirstPerson = ViewModels:FindFirstChild("FirstPerson")
            if not FirstPerson then
                return nil
            end
            local Name = LocalPlayer.Name
            for _, v1 in pairs(FirstPerson:GetChildren()) do
                if v1:IsA("Model") and v1.Name:find("^" .. Name) then
                    local ItemVisual = v1:FindFirstChild("ItemVisual")
                    if ItemVisual then
                        local Body = ItemVisual:FindFirstChild("Body")
                        if Body then
                            local BodyPrimary = Body:FindFirstChild("BodyPrimary")
                            if BodyPrimary then
                                local _muzzle = BodyPrimary:FindFirstChild("_muzzle")
                                if _muzzle and _muzzle:IsA("Attachment") then
                                    return _muzzle.WorldPosition
                                end
                            end
                        end
                    end
                end
            end
            return nil
        end
        local tbl3 = {}
        tbl3.frame = nil
        tbl3.reserve = nil
        tbl3.ammo = nil
        tbl3.rescanAt = 0
        local function func3(arg1)
            if tbl3.frame and tbl3.frame.Parent and tbl3.frame.Visible then
                return
                    tonumber(tbl3.reserve.Text:match("%d+")) or 0,
                    tonumber(tbl3.ammo.Text:match("%d+")) or 0
            end
            if arg1 < tbl3.rescanAt then
                return 0, 0
            end
            tbl3.rescanAt = arg1 + 0.5
            tbl3.frame = nil
            tbl3.reserve = nil
            tbl3.ammo = nil
            for _, v1 in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
                if v1:IsA("Frame") and v1.Visible then
                    local Reserve = v1:FindFirstChild("Reserve")
                    if Reserve and v1:FindFirstChild("Icon") and v1:FindFirstChild("ItemName") then
                        local Ammo = Reserve:FindFirstChild("Ammo")
                        if Ammo then
                            tbl3.frame = v1
                            tbl3.reserve = Reserve
                            tbl3.ammo = Ammo
                            return
                                tonumber(Reserve.Text:match("%d+")) or 0,
                                tonumber(Ammo.Text:match("%d+")) or 0
                        end
                    end
                end
            end
            return 0, 0
        end
        RunService.PostSimulation:Connect(
            function()
                local v1 = os.clock()
                if v1 - num1 < getgenv().crosshair.refreshrate then
                    return
                end
                num1 = v1
                if isInstanceMenuOpen and isInstanceMenuOpen() then
                    for i = 1, 27 do
                        tbl[i].Visible = false
                    end
                    v2.Visible = false
                    for i1 = 1, 8 do
                        tbl1[i1].Visible = false
                    end
                    return
                end
                local crosshair = getgenv().crosshair
                local vector2
                if crosshair.crosshair_mode == "follow muzzle" then
                    local v3 = func2()
                    if v3 then
                        local v4, v5 = InstanceWorldToScreen(v3, CurrentCamera)
                        if v5 then
                            vector2 = Vector2.new(v4.X, v4.Y)
                        else
                            vector2 = crosshair.mode == "center" and CurrentCamera.ViewportSize / 2 or crosshair.mode == "mouse" and UserInputService:GetMouseLocation(
                            ) or crosshair.position
                        end
                    else
                        vector2 = crosshair.mode == "center" and CurrentCamera.ViewportSize / 2 or crosshair.mode == "mouse" and UserInputService:GetMouseLocation(
                        ) or crosshair.position
                    end
                else
                    vector2 = crosshair.mode == "center" and CurrentCamera.ViewportSize / 2 or crosshair.mode == "mouse" and UserInputService:GetMouseLocation(
                    ) or crosshair.position
                end
                if not crosshair.enabled then
                    for i2 = 1, 27 do
                        tbl[i2].Visible = false
                    end
                    v2.Visible = false
                    for i3 = 1, 8 do
                        tbl1[i3].Visible = false
                    end
                    return
                end
                local v6 = crosshair.scale_min + math.sin(v1 * crosshair.resize_speed) * (crosshair.scale_max - crosshair.scale_min)
                local length = crosshair.length
                if crosshair.resize then
                    local v7 = v1 * crosshair.resize_speed % 180
                    length = crosshair.resize_min + math.sin(math.rad(v7)) * crosshair.resize_max
                end
                local v8 = vector2.Y + (crosshair.show_lines and crosshair.radius + crosshair.length + 14 or 15)
                if crosshair.show_watermark then
                    local v9 = vector2.X - drawing.TextBounds.X / 2
                    for i4 = 1, 27 do
                        local v10 = func(
                            (i4 - 1) / 26 or 0, crosshair.gradient_rotation, crosshair.color1,
                            crosshair.color2, crosshair.color3
                        )
                        tbl[i4].Color = v10
                        tbl[i4].Position = Vector2.new(v9, v8)
                        tbl[i4].Visible = true
                        v9 = v9 + tbl[i4].TextBounds.X
                    end
                else
                    for i5 = 1, 27 do
                        tbl[i5].Visible = false
                    end
                end
                local v11
                if crosshair.show_watermark then
                    v11 = v8 + 18
                elseif crosshair.show_lines then
                    v11 = vector2.Y + crosshair.radius + crosshair.length + 18
                else
                    v11 = vector2.Y + 18
                end
                if crosshair.show_ammo then
                    local v12, v13 = func3(v1)
                    local v14 = tostring(v12) .. " / " .. tostring(v13)
                    if v14 ~= str then
                        str = v14
                        v2.Text = v14
                        num = v2.TextBounds.X
                    end
                    v2.Position = Vector2.new(vector2.X - num / 2, v11)
                    v2.Visible = true
                else
                    v2.Visible = false
                end
                if crosshair.show_lines then
                    local num2 = 0
                    if crosshair.spin then
                        num2 = TweenService:GetValue(
                            -(v1 * crosshair.spin_speed) % crosshair.spin_max / 360,
                            crosshair.spin_style, Enum.EasingDirection.InOut
                        ) * 360
                    end
                    for i6 = 1, 4 do
                        local v15 = tbl2[i6] + num2
                        local v16 = vector2 + func1(v15, crosshair.radius * v6)
                        local v17 = vector2 + func1(v15, (crosshair.radius + length) * v6)
                        local v18 = tbl1[i6 + 4]
                        v18.Visible = true
                        v18.Color = crosshair.crosshair_color
                        v18.From = v16
                        v18.To = v17
                        v18.Thickness = crosshair.width
                        local v19 = tbl1[i6]
                        v19.Visible = true
                        v19.Color = Color3.new(0, 0, 0)
                        v19.From = vector2 + func1(v15, crosshair.radius * v6 - 1)
                        v19.To = vector2 + func1(v15, (crosshair.radius + length) * v6 + 1)
                        v19.Thickness = crosshair.width + 1.5
                    end
                else
                    for i7 = 1, 8 do
                        tbl1[i7].Visible = false
                    end
                end
            end
        )
        local v3 = _raw:AddRightGroupbox("crosshair")
        v3:AddToggle(
            "crosshaireeee",
            {
                Text = "enable", Default = false,
                Callback = function(arg1)
                    getgenv().crosshair.enabled = arg1
                end,
            }
        ):AddColorPicker(
            "CrosshairColor",
            {
                Default = getgenv().crosshair.crosshair_color, Title = "Crosshair Color",
                Callback = function(arg1)
                    getgenv().crosshair.crosshair_color = arg1
                end,
            }
        ):AddColorPicker(
            "GradientColor1",
            {
                Default = getgenv().crosshair.color1, Title = "Text Color 1",
                Callback = function(arg1)
                    getgenv().crosshair.color1 = arg1
                end,
            }
        ):AddColorPicker(
            "GradientColor2",
            {
                Default = getgenv().crosshair.color2, Title = "Text Color 2",
                Callback = function(arg1)
                    getgenv().crosshair.color2 = arg1
                end,
            }
        ):AddColorPicker(
            "GradientColor3",
            {
                Default = getgenv().crosshair.color3, Title = "Text Color 3",
                Callback = function(arg1)
                    getgenv().crosshair.color3 = arg1
                end,
            }
        )
        v3:AddToggle(
            "showlines",
            {
                Text = "crosshair lines", Default = getgenv().crosshair.show_lines,
                Callback = function(arg1)
                    getgenv().crosshair.show_lines = arg1
                end,
            }
        )
        v3:AddToggle(
            "showwatermark",
            {
                Text = "watermark", Default = getgenv().crosshair.show_watermark,
                Callback = function(arg1)
                    getgenv().crosshair.show_watermark = arg1
                end,
            }
        )
        v3:AddToggle(
            "showammo",
            {
                Text = "ammo", Default = false,
                Callback = function(arg1)
                    getgenv().crosshair.show_ammo = arg1
                end,
            }
        )
        v3:AddSlider(
            "ooetg",
            {
                Text = "speed", Default = getgenv().crosshair.spin_speed, Min = 0, Max = 340,
                Rounding = 2, Suffix = "",
                Callback = function(arg1)
                    getgenv().crosshair.spin_speed = arg1
                end,
            }
        )
        v3:AddSlider(
            "GradientRotation",
            {
                Text = "rotation", Default = getgenv().crosshair.gradient_rotation, Min = 0,
                Max = 360, Rounding = 0, Suffix = "",
                Callback = function(arg1)
                    getgenv().crosshair.gradient_rotation = arg1
                end,
            }
        )
        v3:AddDropdown(
            "crosshairmode",
            {
                Text = "crosshair mode", Default = 1, Values = {"static", "follow muzzle"},
                Callback = function(arg1)
                    getgenv().crosshair.crosshair_mode = arg1
                end,
            }
        )
    end)()
end)()
local v19 = v3:AddTab("Mods")
local v20 = v19:AddSection("Gun Mods")
local tbl9 = {}
local flag12 = false
v20:AddToggle(
    "GUNS", false,
    function(arg1)
        local Modules = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
        local v1 = Modules and Modules:FindFirstChild("ItemLibrary")
        if not (v1 and v1:IsA("ModuleScript")) then
            warn("[V.Roy] Mods no disponibles en este servidor.")
            return
        end
        local v2, v3 = pcall(require, v1)
        if not v2 or type(v3) ~= "table" then
            return
        end
        local Items = v3.Items
        if arg1 and not flag12 then
            flag12 = true
            tbl9 = {}
            local tbl = {Sniper = false, Crossbow = false, Bow = false, RPG = false}
            for k, v4 in pairs(Items) do
                if typeof(v4) == "table" and not tbl[k] then
                    tbl9[k] = {}
                    for _, v5 in ipairs(
                        {"ShootSpread", "ShootAccuracy", "ShootRecoil", "ShootCooldown", "ShootBurstCooldown"}
                    ) do
                        if v4[v5] ~= nil then
                            tbl9[k][v5] = v4[v5]
                        end
                    end
                    if v4.ShootSpread then
                        v4.ShootSpread = 0
                    end
                    if v4.ShootAccuracy then
                        v4.ShootAccuracy = 0
                    end
                    if v4.ShootRecoil then
                        v4.ShootRecoil = 0
                    end
                    if v4.ShootCooldown then
                        v4.ShootCooldown = 0.001
                    end
                    if v4.ShootBurstCooldown then
                        v4.ShootBurstCooldown = 0.001
                    end
                end
            end
        elseif not arg1 and flag12 then
            flag12 = false
            for k1, v6 in pairs(tbl9) do
                local v7 = Items[k1]
                if typeof(v7) == "table" then
                    for k2, v8 in pairs(v6) do
                        v7[k2] = v8
                    end
                end
            end
            tbl9 = {}
        end
    end
)
local v21 = v19:AddSection("Melee Mod")
local tbl10 = {}
local flag13 = false
v21:AddToggle(
    "MELEE", false,
    function(arg1)
        local Modules = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
        local v1 = Modules and Modules:FindFirstChild("ItemLibrary")
        if not (v1 and v1:IsA("ModuleScript")) then
            warn("[V.Roy] Mods no disponibles en este servidor.")
            return
        end
        local v2, v3 = pcall(require, v1)
        if not v2 or type(v3) ~= "table" then
            return
        end
        local Items = v3.Items
        if arg1 and not flag13 then
            flag13 = true
            tbl10 = {}
            for k, v4 in pairs(Items) do
                if typeof(v4) == "table" then
                    tbl10[k] = {}
                    for _, v5 in ipairs(
                        {"AttackCooldown", "SwingCooldown", "MeleeCooldown", "Cooldown", "RecoveryTime", "ResetTime"}
                    ) do
                        if v4[v5] ~= nil then
                            tbl10[k][v5] = v4[v5]
                        end
                    end
                    if v4.AttackCooldown then
                        v4.AttackCooldown = 0.001
                    end
                    if v4.SwingCooldown then
                        v4.SwingCooldown = 0.001
                    end
                    if v4.MeleeCooldown then
                        v4.MeleeCooldown = 0.001
                    end
                    if v4.Cooldown then
                        v4.Cooldown = 0.001
                    end
                    if v4.RecoveryTime then
                        v4.RecoveryTime = 0.001
                    end
                    if v4.ResetTime then
                        v4.ResetTime = 0.001
                    end
                end
            end
        elseif not arg1 and flag13 then
            flag13 = false
            for k1, v6 in pairs(tbl10) do
                local v7 = Items[k1]
                if typeof(v7) == "table" then
                    for k2, v8 in pairs(v6) do
                        v7[k2] = v8
                    end
                end
            end
            tbl10 = {}
        end
    end
)
local v22 = v3:AddTab("Unlock All")
local v23 = v22:AddSection("Unlocker")
v23:AddLabel("This unlocks gun skins, wraps,", Color3.fromRGB(246, 248, 252))
v23:AddLabel("charms and dances.", Color3.fromRGB(246, 248, 252))
local flag14 = false
v23:AddButton(
    "Unlock all",
    function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local LocalPlayer = Players.LocalPlayer
        local v1 = LocalPlayer and LocalPlayer:FindFirstChild("PlayerScripts")
        if not (ReplicatedStorage:FindFirstChild("Modules") and v1 and v1:FindFirstChild(
            "Controllers"
        )) then
            warn("[Unlock all] No disponible en este servidor (faltan modulos del juego).")
            return
        end
        if flag14 then
            return
        end
        flag14 = true
        local v2, v3 = pcall(
            function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local HttpService = game:GetService("HttpService")
                local LocalPlayer = Players.LocalPlayer
                local Controllers = LocalPlayer.PlayerScripts.Controllers
                local EnumLibrary = require(
                    ReplicatedStorage.Modules:WaitForChild("EnumLibrary", 10)
                )
                if EnumLibrary then
                    EnumLibrary:WaitForEnumBuilder()
                end
                local CosmeticLibrary = require(
                    ReplicatedStorage.Modules:WaitForChild("CosmeticLibrary", 10)
                )
                local ItemLibrary = require(
                    ReplicatedStorage.Modules:WaitForChild("ItemLibrary", 10)
                )
                local PlayerDataController = require(
                    Controllers:WaitForChild("PlayerDataController", 10)
                )
                local tbl = {}
                local tbl1 = {}
                local v23
                local v24
                local function func(arg1, arg2, arg3)
                    local v1 = CosmeticLibrary.Cosmetics[arg1]
                    if not v1 then
                        return nil
                    end
                    local tbl = {}
                    for k, v2 in pairs(v1) do
                        tbl[k] = v2
                    end
                    tbl.Name = arg1
                    tbl.Type = tbl.Type or arg2
                    tbl.Seed = tbl.Seed or math.random(1, 1000000)
                    if EnumLibrary then
                        local v3, v4 = pcall(EnumLibrary.ToEnum, EnumLibrary, arg1)
                        if v3 and v4 then
                            local v5 = tbl.ObjectID or v4
                            tbl.Enum = v4
                            tbl.ObjectID = v5
                        end
                    end
                    if arg3 then
                        if arg3.inverted ~= nil then
                            tbl.Inverted = arg3.inverted
                        end
                        if arg3.favoritesOnly ~= nil then
                            tbl.OnlyUseFavorites = arg3.favoritesOnly
                        end
                    end
                    return tbl
                end
                local flag = false
                local function func1()
                    if not writefile or flag then
                        return
                    end
                    flag = true
                    task.spawn(
                        function()
                            task.wait(0.5)
                            pcall(
                                function()
                                    local tbl2 = {equipped = {}, favorites = tbl1}
                                    for k, v1 in pairs(tbl) do
                                        tbl2.equipped[k] = {}
                                        for k1, v2 in pairs(v1) do
                                            if v2 and v2.Name then
                                                tbl2.equipped[k][k1] = {
                                                    name = v2.Name, seed = v2.Seed,
                                                    inverted = v2.Inverted
                                                }
                                            end
                                        end
                                    end
                                    makefolder("unlockall")
                                    writefile("unlockall/config.json", HttpService:JSONEncode(tbl2))
                                end
                            )
                            flag = false
                        end
                    )
                end
                local function func2()
                    if not readfile or not isfile or not isfile("unlockall/config.json") then
                        return
                    end
                    pcall(
                        function()
                            local v1 = HttpService:JSONDecode(readfile("unlockall/config.json"))
                            if v1.equipped then
                                for k, v2 in pairs(v1.equipped) do
                                    tbl[k] = {}
                                    for k1, v3 in pairs(v2) do
                                        local v4 = func(v3.name, k1, {inverted = v3.inverted})
                                        if v4 then
                                            v4.Seed = v3.seed
                                            tbl[k][k1] = v4
                                        end
                                    end
                                end
                            end
                            tbl1 = v1.favorites or {}
                        end
                    )
                end
                CosmeticLibrary.OwnsCosmeticNormally = function(_, _, arg3, _)
                    local v1 = CosmeticLibrary.Cosmetics[arg3]
                    if v1 and v1.Type == "Skin" then
                        return true
                    end
                    return false
                end
                CosmeticLibrary.OwnsCosmeticUniversally = function(_, _, arg3, _)
                    local v1 = CosmeticLibrary.Cosmetics[arg3]
                    if v1 and v1.Type == "Skin" then
                        return true
                    end
                    return false
                end
                CosmeticLibrary.OwnsCosmeticForWeapon = function(_, _, arg3, _)
                    local v1 = CosmeticLibrary.Cosmetics[arg3]
                    if v1 and v1.Type == "Skin" then
                        return true
                    end
                    return false
                end
                local OwnsCosmetic = CosmeticLibrary.OwnsCosmetic
                CosmeticLibrary.OwnsCosmetic = function(arg1, arg2, arg3, arg4)
                    if arg3:find("MISSING_") then
                        return OwnsCosmetic(arg1, arg2, arg3, arg4)
                    end
                    local v1 = CosmeticLibrary.Cosmetics[arg3]
                    if v1 and v1.Type == "Skin" then
                        return true
                    end
                    return OwnsCosmetic(arg1, arg2, arg3, arg4)
                end
                local Get = PlayerDataController.Get
                PlayerDataController.Get = function(arg1, arg2)
                    local v1 = Get(arg1, arg2)
                    if arg2 == "CosmeticInventory" then
                        local tbl = {}
                        if v1 then
                            for k, v2 in pairs(v1) do
                                local v3 = CosmeticLibrary.Cosmetics[k]
                                if v3 and v3.Type == "Skin" then
                                    tbl[k] = v2
                                end
                            end
                        end
                        return setmetatable(
                            tbl,
                            {
                                __index = function(_, arg2)
                                    local v1 = CosmeticLibrary.Cosmetics[arg2]
                                    if v1 and v1.Type == "Skin" then
                                        return true
                                    end
                                    return nil
                                end,
                            }
                        )
                    end
                    if arg2 == "FavoritedCosmetics" then
                        local v4 = v1 and table.clone(v1) or {}
                        for k1, v5 in pairs(tbl1) do
                            v4[k1] = v4[k1] or {}
                            for k2, v6 in pairs(v5) do
                                local v7 = CosmeticLibrary.Cosmetics[k2]
                                if v7 and v7.Type == "Skin" then
                                    v4[k1][k2] = v6
                                end
                            end
                        end
                        return v4
                    end
                    return v1
                end
                local GetWeaponData = PlayerDataController.GetWeaponData
                PlayerDataController.GetWeaponData = function(arg1, arg2)
                    local v1 = GetWeaponData(arg1, arg2)
                    if not v1 then
                        return nil
                    end
                    local tbl1 = {}
                    for k, v2 in pairs(v1) do
                        tbl1[k] = v2
                    end
                    tbl1.Name = arg2
                    if tbl[arg2] then
                        for k1, v3 in pairs(tbl[arg2]) do
                            if k1 == "Skin" then
                                tbl1[k1] = v3
                            end
                        end
                    end
                    return tbl1
                end
                local FighterController
                pcall(
                    function()
                        FighterController = require(
                            Controllers:WaitForChild("FighterController", 10)
                        )
                    end
                )
                local v2, v3, v6, str, v8, func3
                if hookmetamethod then
                    local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    local v1 = Remotes and Remotes:FindFirstChild("Data")
                    v2 = v1 and v1:FindFirstChild("EquipCosmetic")
                    v3 = v1 and v1:FindFirstChild("FavoriteCosmetic")
                    local v4 = Remotes and Remotes:FindFirstChild("Replication")
                    local v5 = v4 and v4:FindFirstChild("Fighter")
                    v6 = v5
                    if v6 then
                        str = "UseItem"
                        v6 = v5:FindFirstChild("UseItem")
                    end
                    if v2 then
                        local v9
                        local v7 = hookmetamethod
                        v8 = game
                        func3 = function(arg1, ...)
                            if getnamecallmethod() ~= "FireServer" then
                                return v9(arg1, ...)
                            end
                            local tbl2 = {...}
                            if v6 and arg1 == v6 then
                                local v1 = tbl2[1]
                                if FighterController then
                                    pcall(
                                        function()
                                            local Fighter = FighterController:GetFighter(
                                                LocalPlayer
                                            )
                                            if Fighter and Fighter.Items then
                                                for _, v2 in pairs(Fighter.Items) do
                                                    if v2:Get("ObjectID") == v1 then
                                                        break
                                                    end
                                                end
                                            end
                                        end
                                    )
                                end
                            end
                            if arg1 == v2 then
                                local v4 = tbl2[1]
                                local v5 = tbl2[2]
                                local v7 = tbl2[3]
                                local v8 = tbl2[4] or {}
                                if v5 ~= "Skin" then
                                    return v9(arg1, ...)
                                end
                                if v7 and v7 ~= "None" and v7 ~= "" then
                                    local v10 = PlayerDataController:Get("CosmeticInventory")
                                    if v10 and rawget(v10, v7) then
                                        return v9(arg1, ...)
                                    end
                                end
                                tbl[v4] = tbl[v4] or {}
                                if not v7 or v7 == "None" or v7 == "" then
                                    tbl[v4][v5] = nil
                                    if not next(tbl[v4]) then
                                        tbl[v4] = nil
                                    end
                                else
                                    local v11 = func(
                                        v7, v5,
                                        {inverted = v8.IsInverted, favoritesOnly = v8.OnlyUseFavorites}
                                    )
                                    if v11 then
                                        tbl[v4][v5] = v11
                                    end
                                end
                                task.defer(
                                    function()
                                        pcall(
                                            function()
                                                PlayerDataController.CurrentData:Replicate(
                                                    "WeaponInventory"
                                                )
                                            end
                                        )
                                        func1()
                                    end
                                )
                                return
                            end
                            if arg1 == v3 then
                                local v12 = CosmeticLibrary.Cosmetics[tbl2[2]]
                                if v12 and v12.Type == "Skin" then
                                    tbl1[tbl2[1]] = tbl1[tbl2[1]] or {}
                                    tbl1[tbl2[1]][tbl2[2]] = tbl2[3] or nil
                                    func1()
                                    task.spawn(
                                        function()
                                            pcall(
                                                function()
                                                    PlayerDataController.CurrentData:Replicate(
                                                        "FavoritedCosmetics"
                                                    )
                                                end
                                            )
                                        end
                                    )
                                end
                                return
                            end
                            return v9(arg1, ...)
                        end
                        str = v7(v8, "__namecall", func3)
                        v9 = str
                    end
                end
                local ClientItem1
                local v10 = pcall
                v2 = function()
                    ClientItem1 = require(
                        LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem
                    )
                end
                v10(v2)
                if ClientItem1 and ClientItem1._CreateViewModel then
                    local _CreateViewModel = ClientItem1._CreateViewModel
                    v2 = function(arg1, arg2)
                        local Name = arg1.Name
                        local v1 = arg1.ClientFighter and arg1.ClientFighter.Player
                        v23 = v1 == LocalPlayer and Name or nil
                        if v1 == LocalPlayer and tbl[Name] and tbl[Name].Skin and arg2 then
                            local v2 = arg1:ToEnum("Data")
                            local v3 = arg1:ToEnum("Skin")
                            local v4 = arg1:ToEnum("Name")
                            if arg2[v2] then
                                arg2[v2][v3] = tbl[Name].Skin
                                arg2[v2][v4] = tbl[Name].Skin.Name
                            elseif arg2.Data then
                                arg2.Data.Skin = tbl[Name].Skin
                                arg2.Data.Name = tbl[Name].Skin.Name
                            end
                        end
                        local v5 = _CreateViewModel(arg1, arg2)
                        v23 = nil
                        return v5
                    end
                    ClientItem1._CreateViewModel = v2
                end
                v3 = LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses
                v2 = v3.ClientFighter
                local ClientItem = v2.ClientItem
                v3 = "ClientViewModel"
                v2 = ClientItem
                local v11 = ClientItem.FindFirstChild(v2, "ClientViewModel")
                if v11 then
                    v2 = require
                    v3 = v11
                    v2 = v2(v3)
                    v3 = v2.new
                    v2.new = function(arg1, arg2)
                        local v1 = v23 or arg2.Name
                        if (arg2.ClientFighter and arg2.ClientFighter.Player) == LocalPlayer and tbl[v1] then
                            local ReplicatedClass = require(
                                ReplicatedStorage.Modules.ReplicatedClass
                            )
                            local v2 = ReplicatedClass:ToEnum("Data")
                            arg1[v2] = arg1[v2] or {}
                            local v4 = tbl[v1]
                            if v4.Skin then
                                arg1[v2][ReplicatedClass:ToEnum("Skin")] = v4.Skin
                            end
                        end
                        return (v3(arg1, arg2))
                    end
                end
                v2 = ItemLibrary.GetViewModelImageFromWeaponData
                v3 = function(arg1, arg2, arg3)
                    if not arg2 then
                        return v2(arg1, arg2, arg3)
                    end
                    local Name = arg2.Name
                    if (arg2.Skin and tbl[Name] and arg2.Skin == tbl[Name].Skin or v24 == LocalPlayer and tbl[Name] and tbl[Name].Skin) and tbl[Name] and tbl[Name].Skin then
                        local v1 = arg1.ViewModels[tbl[Name].Skin.Name]
                        if v1 then
                            return v1[arg3 and "ImageHighResolution" or "Image"] or v1.Image
                        end
                    end
                    return v2(arg1, arg2, arg3)
                end
                ItemLibrary.GetViewModelImageFromWeaponData = v3
                v3 = CosmeticLibrary.OwnsCosmetic
                CosmeticLibrary.OwnsCosmetic = function(arg1, arg2, arg3, arg4)
                    if arg3:find("MISSING_") then
                        return v3(arg1, arg2, arg3, arg4)
                    end
                    local v1 = CosmeticLibrary.Cosmetics[arg3]
                    if v1 and (v1.Type == "Charm" or arg3:lower():find("charm")) then
                        return true
                    end
                    return v3(arg1, arg2, arg3, arg4)
                end
                local Get1 = PlayerDataController.Get
                PlayerDataController.Get = function(arg1, arg2)
                    local v1 = Get1(arg1, arg2)
                    if arg2 == "CosmeticInventory" then
                        local tbl = {}
                        if v1 then
                            for k, v2 in pairs(v1) do
                                local v3 = CosmeticLibrary.Cosmetics[k]
                                if v3 and (v3.Type == "Charm" or k:lower():find("charm")) then
                                    tbl[k] = v2
                                end
                            end
                        end
                        return setmetatable(
                            tbl,
                            {
                                __index = function(_, arg2)
                                    local v1 = CosmeticLibrary.Cosmetics[arg2]
                                    if v1 and (v1.Type == "Charm" or arg2:lower():find("charm")) then
                                        return true
                                    end
                                    return nil
                                end,
                            }
                        )
                    end
                    if arg2 == "FavoritedCosmetics" then
                        local v4 = v1 and table.clone(v1) or {}
                        for k1, v5 in pairs(tbl1) do
                            v4[k1] = v4[k1] or {}
                            for k2, v6 in pairs(v5) do
                                local v7 = CosmeticLibrary.Cosmetics[k2]
                                if v7 and (v7.Type == "Charm" or k2:lower():find("charm")) then
                                    v4[k1][k2] = v6
                                end
                            end
                        end
                        return v4
                    end
                    return v1
                end
                local GetWeaponData1 = PlayerDataController.GetWeaponData
                v6 = function(arg1, arg2)
                    local v1 = GetWeaponData1(arg1, arg2)
                    if not v1 then
                        return nil
                    end
                    local tbl1 = {}
                    for k, v2 in pairs(v1) do
                        tbl1[k] = v2
                    end
                    tbl1.Name = arg2
                    if tbl[arg2] then
                        for k1, v3 in pairs(tbl[arg2]) do
                            if k1 == "Charm" then
                                tbl1[k1] = v3
                            end
                        end
                    end
                    return tbl1
                end
                PlayerDataController.GetWeaponData = v6
                v6 = hookmetamethod
                local v14
                if v6 then
                    v6 = ReplicatedStorage.FindFirstChild
                    v6 = v6(ReplicatedStorage, "Remotes")
                    local v12 = v6 and v6:FindFirstChild("Data")
                    str = v12 and v12:FindFirstChild("EquipCosmetic")
                    v8 = v12
                    if v8 then
                        func3 = "FavoriteCosmetic"
                        v8 = v12:FindFirstChild("FavoriteCosmetic")
                    end
                    if str then
                        local v15
                        local v13 = hookmetamethod
                        v14 = game
                        func3 = v13(
                            v14, "__namecall",
                            function(arg1, ...)
                                if getnamecallmethod() ~= "FireServer" then
                                    return v15(arg1, ...)
                                end
                                local tbl2 = {...}
                                if arg1 == str then
                                    local v1 = tbl2[1]
                                    local v2 = tbl2[2]
                                    local v3 = tbl2[3]
                                    local v4 = tbl2[4] or {}
                                    if v2 ~= "Charm" then
                                        return v15(arg1, ...)
                                    end
                                    if v3 and v3 ~= "None" and v3 ~= "" then
                                        local v5 = PlayerDataController:Get("CosmeticInventory")
                                        if v5 and rawget(v5, v3) then
                                            return v15(arg1, ...)
                                        end
                                    end
                                    tbl[v1] = tbl[v1] or {}
                                    if not v3 or v3 == "None" or v3 == "" then
                                        tbl[v1][v2] = nil
                                        if not next(tbl[v1]) then
                                            tbl[v1] = nil
                                        end
                                    else
                                        local v6 = func(
                                            v3, v2,
                                            {inverted = v4.IsInverted, favoritesOnly = v4.OnlyUseFavorites}
                                        )
                                        if v6 then
                                            tbl[v1][v2] = v6
                                        end
                                    end
                                    task.defer(
                                        function()
                                            pcall(
                                                function()
                                                    PlayerDataController.CurrentData:Replicate(
                                                        "WeaponInventory"
                                                    )
                                                end
                                            )
                                            func1()
                                        end
                                    )
                                    return
                                end
                                if arg1 == v8 then
                                    local v7 = CosmeticLibrary.Cosmetics[tbl2[2]]
                                    if v7 and (v7.Type == "Charm" or tbl2[2]:lower():find("charm")) then
                                        tbl1[tbl2[1]] = tbl1[tbl2[1]] or {}
                                        tbl1[tbl2[1]][tbl2[2]] = tbl2[3] or nil
                                        func1()
                                        task.spawn(
                                            function()
                                                pcall(
                                                    function()
                                                        PlayerDataController.CurrentData:Replicate(
                                                            "FavoritedCosmetics"
                                                        )
                                                    end
                                                )
                                            end
                                        )
                                    end
                                    return
                                end
                                return v15(arg1, ...)
                            end
                        )
                        v15 = func3
                    end
                end
                v6 = ClientItem1
                v6 = v6 and ClientItem1._CreateViewModel
                if v6 then
                    v6 = ClientItem1._CreateViewModel
                    ClientItem1._CreateViewModel = function(arg1, arg2)
                        local Name = arg1.Name
                        local v1 = arg1.ClientFighter and arg1.ClientFighter.Player
                        v23 = v1 == LocalPlayer and Name or nil
                        if v1 == LocalPlayer and tbl[Name] and tbl[Name].Charm and arg2 then
                            local v2 = arg1:ToEnum("Data")
                            local v3 = arg1:ToEnum("Charm")
                            local v4 = arg1:ToEnum("Name")
                            if arg2[v2] then
                                arg2[v2][v3] = tbl[Name].Charm
                                arg2[v2][v4] = tbl[Name].Charm.Name
                            elseif arg2.Data then
                                arg2.Data.Charm = tbl[Name].Charm
                                arg2.Data.Name = tbl[Name].Charm.Name
                            end
                        end
                        local v5 = v6(arg1, arg2)
                        v23 = nil
                        return v5
                    end
                end
                if v11 then
                    v6 = require
                    v6 = v6(v11)
                    if v6.GetCharm then
                        local GetCharm = v6.GetCharm
                        str = function(arg1)
                            local v1 = arg1.ClientItem and arg1.ClientItem.Name
                            local v2 = arg1.ClientItem and arg1.ClientItem.ClientFighter and arg1.ClientItem.ClientFighter.Player
                            if v1 and v2 == LocalPlayer and tbl[v1] and tbl[v1].Charm then
                                return tbl[v1].Charm
                            end
                            return GetCharm(arg1)
                        end
                        v6.GetCharm = str
                    end
                    local new = v6.new
                    str = function(arg1, arg2)
                        local v1 = v23 or arg2.Name
                        if (arg2.ClientFighter and arg2.ClientFighter.Player) == LocalPlayer and tbl[v1] then
                            local ReplicatedClass = require(
                                ReplicatedStorage.Modules.ReplicatedClass
                            )
                            local v2 = ReplicatedClass:ToEnum("Data")
                            arg1[v2] = arg1[v2] or {}
                            local v3 = tbl[v1]
                            if v3.Charm then
                                arg1[v2][ReplicatedClass:ToEnum("Charm")] = v3.Charm
                            end
                        end
                        return (new(arg1, arg2))
                    end
                    v6.new = str
                end
                v6 = CosmeticLibrary.OwnsCosmetic
                CosmeticLibrary.OwnsCosmetic = function(arg1, arg2, arg3, arg4)
                    if arg3:find("MISSING_") then
                        return v6(arg1, arg2, arg3, arg4)
                    end
                    local v1 = CosmeticLibrary.Cosmetics[arg3]
                    if v1 and (v1.Type == "Dance" or v1.Type == "Emote" or arg3:lower():find(
                        "dance"
                    ) or arg3:lower():find("emote")) then
                        return true
                    end
                    return v6(arg1, arg2, arg3, arg4)
                end
                local Get2 = PlayerDataController.Get
                str = function(arg1, arg2)
                    local v1 = Get2(arg1, arg2)
                    if arg2 == "CosmeticInventory" then
                        local tbl = {}
                        if v1 then
                            for k, v2 in pairs(v1) do
                                local v3 = CosmeticLibrary.Cosmetics[k]
                                if v3 and (v3.Type == "Dance" or v3.Type == "Emote" or k:lower():find(
                                    "dance"
                                ) or k:lower():find("emote")) then
                                    tbl[k] = v2
                                end
                            end
                        end
                        return setmetatable(
                            tbl,
                            {
                                __index = function(_, arg2)
                                    local v1 = CosmeticLibrary.Cosmetics[arg2]
                                    if v1 and (v1.Type == "Dance" or v1.Type == "Emote" or arg2:lower(
                                    ):find("dance") or arg2:lower():find("emote")) then
                                        return true
                                    end
                                    return nil
                                end,
                            }
                        )
                    end
                    if arg2 == "FavoritedCosmetics" then
                        local v4 = v1 and table.clone(v1) or {}
                        for k1, v5 in pairs(tbl1) do
                            v4[k1] = v4[k1] or {}
                            for k2, v6 in pairs(v5) do
                                local v7 = CosmeticLibrary.Cosmetics[k2]
                                if v7 and (v7.Type == "Dance" or v7.Type == "Emote" or k2:lower():find(
                                    "dance"
                                ) or k2:lower():find("emote")) then
                                    v4[k1][k2] = v6
                                end
                            end
                        end
                        return v4
                    end
                    return v1
                end
                PlayerDataController.Get = str
                str = PlayerDataController.GetWeaponData
                v8 = function(arg1, arg2)
                    local v1 = str(arg1, arg2)
                    if not v1 then
                        return nil
                    end
                    local tbl = {}
                    for k, v2 in pairs(v1) do
                        tbl[k] = v2
                    end
                    tbl.Name = arg2
                    return tbl
                end
                PlayerDataController.GetWeaponData = v8
                v8 = hookmetamethod
                if v8 then
                    v8 = ReplicatedStorage.FindFirstChild
                    v8 = v8(ReplicatedStorage, "Remotes")
                    local v16 = v8 and v8:FindFirstChild("Data")
                    func3 = v16 and v16:FindFirstChild("EquipCosmetic")
                    v14 = v16 and v16:FindFirstChild("FavoriteCosmetic")
                    if func3 then
                        local v17
                        v17 = hookmetamethod(
                            game, "__namecall",
                            function(arg1, ...)
                                if getnamecallmethod() ~= "FireServer" then
                                    return v17(arg1, ...)
                                end
                                local tbl2 = {...}
                                if arg1 == func3 then
                                    local v1 = tbl2[2]
                                    local v2 = tbl2[3]
                                    local v3 = tbl2[4] or {}
                                    if v1 == "Dance" or v1 == "Emote" or v2 and (v2:lower():find(
                                        "dance"
                                    ) or v2:lower():find("emote")) then
                                        tbl.Dances = tbl.Dances or {}
                                        if not v2 or v2 == "None" or v2 == "" then
                                            tbl.Dances[v1] = nil
                                        else
                                            local v4 = func(
                                                v2, v1,
                                                {inverted = v3.IsInverted, favoritesOnly = v3.OnlyUseFavorites}
                                            )
                                            if v4 then
                                                tbl.Dances[v1] = v4
                                            end
                                        end
                                        task.defer(
                                            function()
                                                pcall(
                                                    function()
                                                        PlayerDataController.CurrentData:Replicate(
                                                            "CosmeticInventory"
                                                        )
                                                    end
                                                )
                                                func1()
                                            end
                                        )
                                        return
                                    end
                                    return v17(arg1, ...)
                                end
                                if arg1 == v14 then
                                    local v5 = CosmeticLibrary.Cosmetics[tbl2[2]]
                                    if v5 and (v5.Type == "Dance" or v5.Type == "Emote" or tbl2[2]:lower(
                                    ):find("dance") or tbl2[2]:lower():find("emote")) then
                                        tbl1[tbl2[1]] = tbl1[tbl2[1]] or {}
                                        tbl1[tbl2[1]][tbl2[2]] = tbl2[3] or nil
                                        func1()
                                        task.spawn(
                                            function()
                                                pcall(
                                                    function()
                                                        PlayerDataController.CurrentData:Replicate(
                                                            "FavoritedCosmetics"
                                                        )
                                                    end
                                                )
                                            end
                                        )
                                    end
                                    return
                                end
                                return v17(arg1, ...)
                            end
                        )
                    end
                end
                v8 = nil
                local v18 = pcall
                func3 = function()
                    v8 = require(Controllers:WaitForChild("EmoteController", 10))
                    if v8 and v8.GetEmotes then
                        local GetEmotes = v8.GetEmotes
                        v8.GetEmotes = function(arg1)
                            local v1 = GetEmotes(arg1)
                            for k, v2 in pairs(CosmeticLibrary.Cosmetics) do
                                if v2 and (v2.Type == "Dance" or v2.Type == "Emote" or k:lower():find(
                                    "dance"
                                ) or k:lower():find("emote")) then
                                    if not v1[k] then
                                        v1[k] = {
                                            Name = k, Type = v2.Type, ObjectID = v2.ObjectID,
                                            Enum = v2.Enum
                                        }
                                    end
                                end
                            end
                            return v1
                        end
                    end
                end
                v18(func3)
                local OwnsCosmetic1 = CosmeticLibrary.OwnsCosmetic
                func3 = function(arg1, arg2, arg3, arg4)
                    if arg3:find("MISSING_") then
                        return OwnsCosmetic1(arg1, arg2, arg3, arg4)
                    end
                    local v1 = CosmeticLibrary.Cosmetics[arg3]
                    if v1 and (v1.Type == "Wrap" or v1.Type == "Wrapping" or arg3:lower():find(
                        "wrap"
                    )) then
                        return true
                    end
                    return OwnsCosmetic1(arg1, arg2, arg3, arg4)
                end
                CosmeticLibrary.OwnsCosmetic = func3
                func3 = PlayerDataController.Get
                v14 = function(arg1, arg2)
                    local v1 = func3(arg1, arg2)
                    if arg2 == "CosmeticInventory" then
                        local tbl = {}
                        if v1 then
                            for k, v2 in pairs(v1) do
                                local v3 = CosmeticLibrary.Cosmetics[k]
                                if v3 and (v3.Type == "Wrap" or v3.Type == "Wrapping" or k:lower():find(
                                    "wrap"
                                )) then
                                    tbl[k] = v2
                                end
                            end
                        end
                        return setmetatable(
                            tbl,
                            {
                                __index = function(_, arg2)
                                    local v1 = CosmeticLibrary.Cosmetics[arg2]
                                    if v1 and (v1.Type == "Wrap" or v1.Type == "Wrapping" or arg2:lower(
                                    ):find("wrap")) then
                                        return true
                                    end
                                    return nil
                                end,
                            }
                        )
                    end
                    if arg2 == "FavoritedCosmetics" then
                        local v4 = v1 and table.clone(v1) or {}
                        for k1, v5 in pairs(tbl1) do
                            v4[k1] = v4[k1] or {}
                            for k2, v6 in pairs(v5) do
                                local v7 = CosmeticLibrary.Cosmetics[k2]
                                if v7 and (v7.Type == "Wrap" or v7.Type == "Wrapping" or k2:lower():find(
                                    "wrap"
                                )) then
                                    v4[k1][k2] = v6
                                end
                            end
                        end
                        return v4
                    end
                    return v1
                end
                PlayerDataController.Get = v14
                v14 = PlayerDataController.GetWeaponData
                PlayerDataController.GetWeaponData = function(arg1, arg2)
                    local v1 = v14(arg1, arg2)
                    if not v1 then
                        return nil
                    end
                    local tbl1 = {}
                    for k, v2 in pairs(v1) do
                        tbl1[k] = v2
                    end
                    tbl1.Name = arg2
                    if tbl[arg2] then
                        for k1, v3 in pairs(tbl[arg2]) do
                            if k1 == "Wrap" or k1 == "Wrapping" then
                                tbl1[k1] = v3
                            end
                        end
                    end
                    return tbl1
                end
                local v20
                if hookmetamethod then
                    local Remotes1 = ReplicatedStorage:FindFirstChild("Remotes")
                    local v19 = Remotes1 and Remotes1:FindFirstChild("Data")
                    v20 = v19 and v19:FindFirstChild("EquipCosmetic")
                    local v21 = v19 and v19:FindFirstChild("FavoriteCosmetic")
                    if v20 then
                        local v22
                        v22 = hookmetamethod(
                            game, "__namecall",
                            function(arg1, ...)
                                if getnamecallmethod() ~= "FireServer" then
                                    return v22(arg1, ...)
                                end
                                local tbl2 = {...}
                                if arg1 == v20 then
                                    local v1 = tbl2[1]
                                    local v2 = tbl2[2]
                                    local v3 = tbl2[3]
                                    local v4 = tbl2[4] or {}
                                    if v2 ~= "Wrap" and v2 ~= "Wrapping" then
                                        return v22(arg1, ...)
                                    end
                                    if v3 and v3 ~= "None" and v3 ~= "" then
                                        local v5 = PlayerDataController:Get("CosmeticInventory")
                                        if v5 and rawget(v5, v3) then
                                            return v22(arg1, ...)
                                        end
                                    end
                                    tbl[v1] = tbl[v1] or {}
                                    if not v3 or v3 == "None" or v3 == "" then
                                        tbl[v1][v2] = nil
                                        if not next(tbl[v1]) then
                                            tbl[v1] = nil
                                        end
                                    else
                                        local v6 = func(
                                            v3, v2,
                                            {inverted = v4.IsInverted, favoritesOnly = v4.OnlyUseFavorites}
                                        )
                                        if v6 then
                                            tbl[v1][v2] = v6
                                        end
                                    end
                                    task.defer(
                                        function()
                                            pcall(
                                                function()
                                                    PlayerDataController.CurrentData:Replicate(
                                                        "WeaponInventory"
                                                    )
                                                end
                                            )
                                            func1()
                                        end
                                    )
                                    return
                                end
                                if arg1 == v21 then
                                    local v7 = CosmeticLibrary.Cosmetics[tbl2[2]]
                                    if v7 and (v7.Type == "Wrap" or v7.Type == "Wrapping" or tbl2[2]:lower(
                                    ):find("wrap")) then
                                        tbl1[tbl2[1]] = tbl1[tbl2[1]] or {}
                                        tbl1[tbl2[1]][tbl2[2]] = tbl2[3] or nil
                                        func1()
                                        task.spawn(
                                            function()
                                                pcall(
                                                    function()
                                                        PlayerDataController.CurrentData:Replicate(
                                                            "FavoritedCosmetics"
                                                        )
                                                    end
                                                )
                                            end
                                        )
                                    end
                                    return
                                end
                                return v22(arg1, ...)
                            end
                        )
                    end
                end
                if ClientItem1 and ClientItem1._CreateViewModel then
                    local _CreateViewModel1 = ClientItem1._CreateViewModel
                    ClientItem1._CreateViewModel = function(arg1, arg2)
                        local Name = arg1.Name
                        local v1 = arg1.ClientFighter and arg1.ClientFighter.Player
                        v23 = v1 == LocalPlayer and Name or nil
                        if v1 == LocalPlayer and tbl[Name] and tbl[Name].Wrap and arg2 then
                            local v2 = arg1:ToEnum("Data")
                            local v3 = arg1:ToEnum("Wrap")
                            local v4 = arg1:ToEnum("Name")
                            if arg2[v2] then
                                arg2[v2][v3] = tbl[Name].Wrap
                                arg2[v2][v4] = tbl[Name].Wrap.Name
                            elseif arg2.Data then
                                arg2.Data.Wrap = tbl[Name].Wrap
                                arg2.Data.Name = tbl[Name].Wrap.Name
                            end
                        end
                        local v5 = _CreateViewModel1(arg1, arg2)
                        v23 = nil
                        return v5
                    end
                end
                if v11 then
                    local module = require(v11)
                    if module.GetWrap then
                        local GetWrap = module.GetWrap
                        v20 = function(arg1)
                            local v1 = arg1.ClientItem and arg1.ClientItem.Name
                            local v2 = arg1.ClientItem and arg1.ClientItem.ClientFighter and arg1.ClientItem.ClientFighter.Player
                            if v1 and v2 == LocalPlayer and tbl[v1] and tbl[v1].Wrap then
                                return tbl[v1].Wrap
                            end
                            return GetWrap(arg1)
                        end
                        module.GetWrap = v20
                    end
                    local new1 = module.new
                    v20 = function(arg1, arg2)
                        local v1 = arg2.ClientFighter and arg2.ClientFighter.Player
                        local v2 = v23 or arg2.Name
                        if v1 == LocalPlayer and tbl[v2] then
                            local ReplicatedClass = require(
                                ReplicatedStorage.Modules.ReplicatedClass
                            )
                            local v3 = ReplicatedClass:ToEnum("Data")
                            arg1[v3] = arg1[v3] or {}
                            local v4 = tbl[v2]
                            if v4.Wrap then
                                arg1[v3][ReplicatedClass:ToEnum("Wrap")] = v4.Wrap
                            end
                        end
                        local v5 = new1(arg1, arg2)
                        if v1 == LocalPlayer and tbl[v2] and tbl[v2].Wrap and v5._UpdateWrap then
                            v5:_UpdateWrap()
                            task.delay(
                                0.1,
                                function()
                                    if not v5._destroyed then
                                        v5:_UpdateWrap()
                                    end
                                end
                            )
                        end
                        return v5
                    end
                    module.new = v20
                end
                pcall(
                    function()
                        local ViewProfile = require(
                            LocalPlayer.PlayerScripts.Modules.Pages.ViewProfile
                        )
                        if ViewProfile and ViewProfile.Fetch then
                            local Fetch = ViewProfile.Fetch
                            ViewProfile.Fetch = function(arg1, arg2)
                                v24 = arg2
                                return Fetch(arg1, arg2)
                            end
                        end
                    end
                )
                func2()
            end
        )
        if not v2 then
            flag14 = false
            warn("[Unlock all] Error:", v3)
        end
    end
);
(function()
    local tbl = {}
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    tbl.camera = Workspace.CurrentCamera
    tbl.antikatana = false
    local tbl1 = {};
    (function()
        if not LocalPlayer:FindFirstChild("PlayerScripts") then
            LocalPlayer.PlayerScriptsAdded:Wait()
        end
        task.spawn(
            function()
                local v4
                local num = 0
                while num < 10 do
                    pcall(
                        function()
                            local Katana = LocalPlayer.PlayerScripts.Modules.Items:FindFirstChild(
                                "Katana", true
                            )
                            if Katana then
                                v4 = require(Katana)
                            end
                        end
                    )
                    if not v4 then
                        for _, v1 in pairs(LocalPlayer.PlayerScripts:GetDescendants()) do
                            if v1.Name == "Katana" and v1:IsA("ModuleScript") then
                                local v2, v3 = pcall(require, v1)
                                if v2 then
                                    v4 = v3
                                    break
                                end
                            end
                        end
                    end
                    if v4 and type(v4) == "table" and v4.StartAiming then
                        break
                    end
                    num = num + 1
                    task.wait(1)
                end
                if v4 and type(v4) == "table" and v4.StartAiming then
                    local StartAiming = v4.StartAiming
                    v4.StartAiming = function(arg1, arg2)
                        local ClientFighter = arg1.ClientFighter
                        local v1 = ClientFighter and ClientFighter.Player
                        if v1 then
                            tbl1[v1] = true
                            task.delay(
                                arg1.Info.DeflectDuration or 0.6,
                                function()
                                    tbl1[v1] = nil
                                end
                            )
                        end
                        return StartAiming(arg1, arg2)
                    end
                end
            end
        )
    end)()
    tbl.katanadeflect = function(arg1)
        return tbl1[arg1] == true
    end
    local tbl2 = {
        RapidFire = false, NoSpread = false, NoRecoil = false, MaxAccuracy = false,
        RapidAttack = false
    }
    tbl2.OriginalGunStartShooting = nil
    tbl2.OriginalMeleeStartShooting = nil
    tbl2.OriginalGetSpread = nil
    tbl2.OriginalRecoil = nil
    getgenv().CombatMods = tbl2
    task.spawn(
        function()
            local v1, v2 = pcall(
                function()
                    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
                    local v1 = PlayerScripts and PlayerScripts:FindFirstChild("Modules") and PlayerScripts.Modules:FindFirstChild(
                        "ItemTypes"
                    )
                    return require(v1.Gun)
                end
            )
            if v1 and v2 then
                if v2.StartShooting then
                    tbl2.OriginalGunStartShooting = v2.StartShooting
                    v2.StartShooting = function(arg1, arg2, arg3)
                        local ShootCooldown
                        if tbl2.RapidFire then
                            ShootCooldown = arg1.Info.ShootCooldown
                            arg1.Info.ShootCooldown = 0
                        end
                        local tbl = {tbl2.OriginalGunStartShooting(arg1, arg2, arg3)}
                        if tbl2.RapidFire then
                            arg1.Info.ShootCooldown = ShootCooldown
                        end
                        return unpack(tbl)
                    end
                end
                if v2._Recoil then
                    tbl2.OriginalRecoil = v2._Recoil
                    v2._Recoil = function(arg1, arg2)
                        if tbl2.NoRecoil then
                            return
                        end
                        return tbl2.OriginalRecoil(arg1, arg2)
                    end
                end
            end
        end
    )
    task.spawn(
        function()
            local v1, v2 = pcall(
                function()
                    return require(ReplicatedStorage.Modules.GameplayUtility)
                end
            )
            if v1 and v2 and v2.GetSpread then
                tbl2.OriginalGetSpread = v2.GetSpread
                v2.GetSpread = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
                    if tbl2.NoSpread or tbl2.MaxAccuracy then
                        return CFrame.new()
                    end
                    return tbl2.OriginalGetSpread(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
                end
            end
        end
    )
    task.spawn(
        function()
            local v1, v2 = pcall(
                function()
                    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
                    local v1 = PlayerScripts and PlayerScripts:FindFirstChild("Modules") and PlayerScripts.Modules:FindFirstChild(
                        "ItemTypes"
                    )
                    return require(v1.Melee)
                end
            )
            if v1 and v2 and v2.StartShooting then
                tbl2.OriginalMeleeStartShooting = v2.StartShooting
                v2.StartShooting = function(arg1, arg2, arg3)
                    local AttackCooldown
                    if tbl2.RapidAttack then
                        AttackCooldown = arg1.Info.AttackCooldown
                        arg1.Info.AttackCooldown = 0
                    end
                    local tbl = {tbl2.OriginalMeleeStartShooting(arg1, arg2, arg3)}
                    if tbl2.RapidAttack and AttackCooldown then
                        arg1.Info.AttackCooldown = AttackCooldown
                    end
                    return unpack(tbl)
                end
            end
        end
    )
    tbl.muzzleflashconn = nil
    local function func()
        local ViewModels = Workspace:FindFirstChild("ViewModels")
        if not ViewModels then
            return
        end
        local FirstPerson = ViewModels:FindFirstChild("FirstPerson")
        if not FirstPerson then
            return
        end
        for _, v1 in pairs(FirstPerson:GetChildren()) do
            if v1:IsA("Model") then
                local ItemVisual = v1:FindFirstChild("ItemVisual")
                local v2 = ItemVisual and ItemVisual:FindFirstChild("Body")
                local v3 = v2 and v2:FindFirstChild("BodyPrimary")
                local v4 = v3 and v3:FindFirstChild("_muzzle")
                if v4 then
                    local SpotLight = v4:FindFirstChild("SpotLight")
                    if SpotLight then
                        SpotLight:Destroy()
                    end
                    for _, v5 in pairs(v4:GetChildren()) do
                        if v5:IsA("ParticleEmitter") and v5.Name == "ParticleEmiter" then
                            v5:Destroy()
                        end
                    end
                end
            end
        end
    end
    tbl.nomuzzleflash = func
    v19:AddToggle(
        "Anti Katana",
        {
            Name = "Anti Katana", Default = false,
            Callback = function(arg1)
                tbl.antikatana = arg1 == true
            end,
        }
    )
    v19:AddToggle(
        "Rapid Fire",
        {
            Name = "Rapid Fire", Default = false,
            Callback = function(arg1)
                tbl2.RapidFire = arg1 == true
            end,
        }
    )
    v19:AddToggle(
        "No Spread",
        {
            Name = "No Spread", Default = false,
            Callback = function(arg1)
                tbl2.NoSpread = arg1 == true
            end,
        }
    )
    v19:AddToggle(
        "No Recoil",
        {
            Name = "No Recoil", Default = false,
            Callback = function(arg1)
                tbl2.NoRecoil = arg1 == true
            end,
        }
    )
    v19:AddToggle(
        "Max Accuracy",
        {
            Name = "Max Accuracy", Default = false,
            Callback = function(arg1)
                tbl2.MaxAccuracy = arg1 == true
            end,
        }
    )
    v19:AddToggle(
        "Rapid Attack",
        {
            Name = "Rapid Attack", Default = false,
            Callback = function(arg1)
                tbl2.RapidAttack = arg1 == true
            end,
        }
    )
    v19:AddToggle(
        "No Muzzle Flash",
        {
            Name = "No Muzzle Flash", Default = false,
            Callback = function(arg1)
                if arg1 then
                    func()
                    if tbl.muzzleflashconn then
                        tbl.muzzleflashconn:Disconnect()
                    end
                    tbl.muzzleflashconn = RunService.RenderStepped:Connect(func)
                elseif tbl.muzzleflashconn then
                    tbl.muzzleflashconn:Disconnect()
                    tbl.muzzleflashconn = nil
                end
            end,
        }
    )
end)()
local function func32()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TeleportService = game:GetService("TeleportService")
    local LocalPlayer = Players.LocalPlayer
    local v1 = v3:AddTab("Misc")
    local v2 = v1:AddSection("Anti Admin")
    local tbl = {enabled = false, action = "Notify", includeFriends = false}
    local tbl2 = {}
    local function func(arg1)
        pcall(
            function()
                VroyUI:Notify({Title = "Staff Detector", Text = arg1, Type = "warn"})
            end
        )
    end
    local function func1(arg1)
        if not arg1 or arg1 == LocalPlayer then
            return false
        end
        local v1, v2 = pcall(
            function()
                return arg1:GetRankInGroup(3461453)
            end
        )
        return v1 and type(v2) == "number" and v2 >= 100
    end
    local function func2(arg1, arg2)
        local v1 = arg1 .. ": " .. arg2
        if tbl.action == "Kick" then
            func(v1 .. " (kicking...)")
            pcall(
                function()
                    LocalPlayer:Kick("RIVALS staff detected: " .. arg2)
                end
            )
        elseif tbl.action == "To Lobby" then
            func(v1 .. " (going to lobby...)")
            pcall(
                function()
                    TeleportService:Teleport(17625359962, LocalPlayer)
                end
            )
        else
            func(v1)
        end
    end
    local function func3()
        for _, v1 in ipairs(Players:GetPlayers()) do
            if v1 ~= LocalPlayer and not tbl2[v1.UserId] then
                if func1(v1) then
                    tbl2[v1.UserId] = true
                    func2("Staff in server", v1.Name .. " (@" .. v1.DisplayName .. ")")
                elseif tbl.includeFriends then
                    local v2, v3 = pcall(Players.GetFriendsAsync, Players, v1.UserId)
                    if v2 and v3 then
                        local v4, v5 = pcall(v3.GetCurrentPage, v3)
                        if v4 and type(v5) == "table" then
                            local v6 = math.min(#v5, 10)
                            for i = 1, v6 do
                                local v7 = v5[i]
                                local v8 = type(v7) == "table" and tonumber(
                                    v7.Id or v7.UserId or v7.id
                                ) or nil
                                if v8 and tbl2[v8] then
                                    tbl2[v1.UserId] = true
                                    func2("Mod friend", v1.Name)
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    v2:AddToggle(
        {
            Name = "Staff Detector", Default = false,
            Callback = function(arg1)
                tbl.enabled = arg1 == true
                if arg1 then
                    task.spawn(
                        function()
                            pcall(func3)
                        end
                    )
                end
            end,
        }
    )
    v2:AddDropdown(
        {
            Name = "Staff Action", Options = {"Notify", "Kick", "To Lobby"}, Default = "Notify",
            Callback = function(arg1)
                local v1 = arg1
                if type(arg1) == "table" then
                    v1 = arg1[1]
                end
                tbl.action = tostring(v1 or "Notify")
            end,
        }
    )
    v2:AddToggle(
        {
            Name = "Include Mod Friends", Default = false,
            Callback = function(arg1)
                tbl.includeFriends = arg1 == true
            end,
        }
    )
    v2:AddButton(
        "Check Now",
        function()
            task.spawn(
                function()
                    local v1 = pcall
                    v1(func3)
                    v1(
                        function()
                            VroyUI:Notify(
                                {Title = "Staff Detector", Text = "Manual check done.", Type = "success"}
                            )
                        end
                    )
                end
            )
        end
    )
    task.spawn(
        function()
            while true do
                task.wait(5)
                if tbl.enabled then
                    pcall(func3)
                end
            end
        end
    )
    local v4 = v1:AddSection("Camera & Utils")
    local tbl3 = {noShake = false, thirdPerson = false, customFov = false, fov = 80}
    tbl3.shakeOrig = nil
    tbl3.ctrl = nil
    tbl3.tpdist = 12
    local function getClosestEnemy()
        if tbl3.ctrl then
            return tbl3.ctrl
        end
        local tbl = {}
        local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
        if PlayerScripts then
            local CameraController = PlayerScripts:FindFirstChild("CameraController", true)
            if CameraController then
                tbl[#tbl + 1] = CameraController
            end
            local Controllers = PlayerScripts:FindFirstChild("Controllers")
            if Controllers then
                local CameraController1 = Controllers:FindFirstChild("CameraController")
                if CameraController1 then
                    tbl[#tbl + 1] = CameraController1
                end
            end
        end
        local v1 = game
        local v2, v3 = pcall(v1.GetService, v1, "ReplicatedStorage")
        if v2 and v3 then
            local CameraController2 = v3:FindFirstChild("CameraController", true)
            if CameraController2 then
                tbl[#tbl + 1] = CameraController2
            end
        end
        for _, v4 in ipairs(tbl) do
            if v4:IsA("ModuleScript") then
                local v5, v6 = pcall(require, v4)
                if v5 and type(v6) == "table" then
                    tbl3.ctrl = v6
                    return v6
                end
            end
        end
        return nil
    end
    local v7
    local function toggleTeleportToEnemy(arg1)
        local v1 = getClosestEnemy()
        if v1 then
            if type(v1.SetThirdPersonOverride) == "function" then
                pcall(v1.SetThirdPersonOverride, v1, arg1)
            end
            pcall(
                function()
                    v1._third_person_override = arg1
                end
            )
        end
        if arg1 then
            v7 = v7 or {
                mode = LocalPlayer.CameraMode, min = LocalPlayer.CameraMinZoomDistance,
                max = LocalPlayer.CameraMaxZoomDistance,
            }
            pcall(
                function()
                    LocalPlayer.CameraMode = Enum.CameraMode.Classic
                    LocalPlayer.CameraMinZoomDistance = 4
                    LocalPlayer.CameraMaxZoomDistance = 60
                end
            )
        elseif v7 then
            pcall(
                function()
                    LocalPlayer.CameraMode = v7.mode
                    LocalPlayer.CameraMinZoomDistance = v7.min
                    LocalPlayer.CameraMaxZoomDistance = v7.max
                end
            )
        end
        return v1 ~= nil
    end
    v4:AddToggle(
        {
            Name = "No Camera Shake", Default = false,
            Callback = function(arg1)
                tbl3.noShake = arg1 == true
            end,
        }
    )
    local connection
    v4:AddToggle(
        {
            Name = "Anti-AFK", Default = false,
            Callback = function(arg1)
                if arg1 == true and not connection then
                    connection = LocalPlayer.Idled:Connect(
                        function()
                            pcall(
                                function()
                                    local VirtualUser = game:GetService("VirtualUser")
                                    VirtualUser:CaptureController()
                                    VirtualUser:ClickButton2(Vector2.new())
                                end
                            )
                        end
                    )
                end
            end,
        }
    )
    local v5 = pcall
    v5(
        function()
            RunService:UnbindFromRenderStep("VroyThirdPerson")
        end
    )
    v5(
        function()
            RunService:BindToRenderStep(
                "VroyThirdPerson", Enum.RenderPriority.Camera.Value + 100,
                function()
                    if not tbl3.thirdPerson then
                        return
                    end
                    local v1 = tonumber(tbl3.tpdist) or 0
                    if v1 <= 0 then
                        return
                    end
                    local CurrentCamera = workspace.CurrentCamera
                    if not CurrentCamera then
                        return
                    end
                    local LookVector = CurrentCamera.CFrame.LookVector
                    if LookVector.Magnitude < 0.01 then
                        return
                    end
                    local v2 = CurrentCamera.CFrame.Position - LookVector * v1
                    CurrentCamera.CFrame = CFrame.new(v2, v2 + LookVector)
                end
            )
        end
    )
    RunService.RenderStepped:Connect(
        function()
            if tbl3.noShake then
                local v1 = getClosestEnemy()
                if v1 then
                    if tbl3.shakeOrig == nil then
                        tbl3.shakeOrig = v1._shake_enabled
                    end
                    pcall(
                        function()
                            v1._shake_enabled = false
                        end
                    )
                end
            elseif tbl3.shakeOrig ~= nil then
                local v2 = getClosestEnemy()
                if v2 then
                    pcall(
                        function()
                            v2._shake_enabled = tbl3.shakeOrig
                        end
                    )
                end
                tbl3.shakeOrig = nil
            end
            if tbl3.thirdPerson then
                toggleTeleportToEnemy(true)
            end
            if tbl3.customFov then
                local CurrentCamera = workspace.CurrentCamera
                if CurrentCamera then
                    pcall(
                        function()
                            CurrentCamera.FieldOfView = tbl3.fov
                        end
                    )
                end
            end
        end
    )
    local v6 = v1:AddSection("Server")
    local HttpService = game:GetService("HttpService")
    local function func6(arg1)
        local v1 = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        if arg1 then
            v1 = v1 .. "&cursor=" .. arg1
        end
        local v2, v3 = pcall(
            function()
                return game:HttpGet(v1)
            end
        )
        if not v2 then
            return nil
        end
        local v4, v5 = pcall(
            function()
                return HttpService:JSONDecode(v3)
            end
        )
        if not v4 or not v5 or not v5.data then
            return nil
        end
        return v5
    end
    local function func7()
        local tbl = {}
        local nextPageCursor
        while true do
            local v1 = func6(nextPageCursor)
            if not v1 then
                break
            end
            for _, v2 in ipairs(v1.data) do
                if v2.playing < v2.maxPlayers and v2.id ~= game.JobId then
                    tbl[#tbl + 1] = v2
                end
            end
            nextPageCursor = v1.nextPageCursor
            if not nextPageCursor then
                break
            end
        end
        return tbl
    end
    local function func8(arg1, arg2)
        local v1 = pcall
        v1(
            function()
                VroyUI:Notify({Title = "Server", Text = arg2})
            end
        )
        v1(
            function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(
                    game.PlaceId, arg1, LocalPlayer
                )
            end
        )
    end
    v6:AddButton(
        "Rejoin",
        function()
            if game.JobId ~= "" then
                func8(game.JobId, "Rejoining...")
            end
        end
    )
    v6:AddButton(
        "Server Hop",
        function()
            local v1 = func7()
            if #v1 == 0 then
                return
            end
            local v2 = v1[math.random(#v1)]
            func8(v2.id, "Hopping (" .. v2.playing .. "/" .. v2.maxPlayers .. ")")
        end
    )
    v6:AddButton(
        "Lowest Players",
        function()
            local v1 = func7()
            if #v1 == 0 then
                return
            end
            table.sort(
                v1,
                function(arg1, arg2)
                    return arg1.playing < arg2.playing
                end
            )
            func8(v1[1].id, "Joining lowest (" .. v1[1].playing .. "/" .. v1[1].maxPlayers .. ")")
        end
    )
    v6:AddButton(
        "Biggest Server",
        function()
            local v1 = func7()
            if #v1 == 0 then
                return
            end
            table.sort(
                v1,
                function(arg1, arg2)
                    return arg1.playing > arg2.playing
                end
            )
            func8(v1[1].id, "Joining biggest (" .. v1[1].playing .. "/" .. v1[1].maxPlayers .. ")")
        end
    )
end
func32()
local v24 = v3:AddTab("World");
(function()
    local _raw = v24._raw
    local LocalPlayer = game:GetService("Players").LocalPlayer
    game:GetService("UserInputService")
    local InstanceWorldToScreen = getgenv().InstanceWorldToScreen
    getgenv()
    getgenv()
    local v1 = setmetatable({}, {__mode = "k"})
    local v2 = _raw:AddRightTabbox()
    local function func(arg1)
        local v2 = v1[arg1]
        if v2 ~= nil then
            return v2
        end
        if not arg1:IsA("BillboardGui") then
            return
        end
        if arg1.Name == "FortniteDamageNumber" then
            return
        end
        local TextLabel = arg1:FindFirstChildWhichIsA("TextLabel", true)
        if not TextLabel then
            return
        end
        local num = tonumber(TextLabel.Text)
        if not (num and num > 0) then
            return
        end
        local v3 = arg1.Adornee or arg1.Parent and arg1.Parent:IsA("BasePart") and arg1.Parent
        if not v3 then
            return
        end
        local tbl = {lbl = TextLabel, dmg = num, adornee = v3}
        v1[arg1] = tbl
        return tbl
    end;
    (function()
        local TweenService = game:GetService("TweenService")
        local tbl = {}
        tbl.main = (function()
            if getgenv().InstanceUIFont ~= nil then
                return getgenv().InstanceUIFont
            end
            for _, v1 in ipairs(
                {"Black", "Heavy", "ExtraBold", "Bold", "SemiBold", "Medium", "Regular"}
            ) do
                local v2, v3 = pcall(
                    function()
                        return Font.new(
                            "rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight[v1]
                        )
                    end
                )
                if v2 and v3 ~= nil then
                    return v3
                end
            end
            local v4, v5 = pcall(
                function()
                    return Font.new("rbxasset://fonts/families/GothamSSm.json")
                end
            )
            if v4 then
                return v5
            end
            return nil
        end)()
        local v1 = v2:AddTab("Hit Effects")
        local flag = false
        local v3 = Color3.fromRGB(159, 133, 195)
        local tbl1 = {Particles = true}
        local num = 7
        local num1 = 2.8
        local num2 = 1
        local v4 = v1:AddToggle(
            "HitEffects",
            {
                Text = "Enable", Default = false,
                Callback = function(arg1)
                    flag = arg1
                end,
            }
        )
        v4:AddColorPicker(
            "HitEffectColorPicker",
            {
                Default = Color3.fromRGB(159, 133, 195), Title = "Hit Effect Color",
                Callback = function(arg1)
                    v3 = arg1
                end,
            }
        )
        local v5 = v1:AddDependencyBox()
        v5:AddSlider(
            "HitEffectFloatSpeed",
            {
                Text = "Float Speed", Default = 7, Min = 1, Max = 25, Rounding = 1,
                Callback = function(arg1)
                    num = arg1
                end,
            }
        )
        v5:AddSlider(
            "HitEffectAliveTime",
            {
                Text = "Alive Time", Default = 2.8, Min = 0.5, Max = 8, Rounding = 1, Suffix = "s",
                Callback = function(arg1)
                    num1 = arg1
                    num2 = arg1 / 2.8
                end,
            }
        )
        v5:SetupDependencies({{v4, true}})
        v1:AddDropdown(
            "HitEffectStyleDropdown",
            {
                Text = "Style", Default = {"Particles"},
                Values = {
                    "Particles", "Fortnite", "Shockwave", "Lightning", "Blood", "Fire", "Ice",
                    "Hearts", "Stars", "Confetti", "Ripple", "Sparks", "Neon", "Void", "Plasma",
                    "Glitch", "Cosmic Shit",
                }, Multi = true,
                Callback = function(arg1)
                    tbl1 = arg1
                end,
            }
        )
        local function func1(arg1)
            if arg1:IsA("BasePart") then
                return arg1
            end
            if arg1:IsA("Attachment") then
                return arg1.Parent
            end
            if arg1:IsA("Model") and arg1.PrimaryPart then
                return arg1.PrimaryPart
            end
        end
        local function func2(arg1, arg2)
            local v1 = arg2 or 0.35
            return Color3.new(
                math.clamp(arg1.R + v1, 0, 1), math.clamp(arg1.G + v1 * 0.5, 0, 1),
                math.clamp(arg1.B + v1 * 0.25, 0, 1)
            )
        end
        local function func3(arg1, arg2)
            local v1 = arg2 or 0.45
            return Color3.new(
                math.clamp(arg1.R - v1, 0, 1), math.clamp(arg1.G - v1, 0, 1),
                math.clamp(arg1.B - v1 * 0.5, 0, 1)
            )
        end
        local function getClosestEnemy()
            return num2
        end
        local function toggleTeleportToEnemy(arg1)
            return arg1 * getClosestEnemy()
        end
        local function func6(arg1)
            local v1 = tbl1
            if type(v1) ~= "table" then
                arg1(v1)
                return
            end
            for k, v2 in pairs(v1) do
                local v3
                if type(k) == "number" and type(v2) == "string" then
                    v3 = v2
                elseif v2 == true then
                    v3 = k
                end
                if v3 then
                    arg1(v3)
                end
            end
        end
        local function func7(arg1, arg2, arg3)
            local v1 = arg3 or {}
            local part = Instance.new("Part")
            part.Name = v1.Name or "HitRing"
            part.Shape = Enum.PartType.Cylinder
            part.Anchored = true
            part.CanCollide = false
            part.CanQuery = false
            part.CanTouch = false
            part.Material = v1.Material or Enum.Material.Neon
            part.Color = arg2
            part.Transparency = v1.StartTransparency or 0.35
            local v2 = v1.StartSize or 0.35
            part.Size = Vector3.new(0.05, v2, v2)
            part.CFrame = arg1.CFrame * CFrame.Angles(0, 0, math.rad(90))
            part.Parent = workspace.CurrentCamera
            local v3 = v1.EndSize or 5
            local v4 = toggleTeleportToEnemy(v1.Duration or 0.55)
            local v5 = Enum
            TweenService:Create(
                part, TweenInfo.new(v4, v5.EasingStyle.Quad, v5.EasingDirection.Out),
                {Size = Vector3.new(0.05, v3, v3), Transparency = 1}
            ):Play()
            task.delay(
                v4 + 0.1,
                function()
                    if part and part.Parent then
                        part:Destroy()
                    end
                end
            )
            return part
        end
        local function func8(arg1, arg2, arg3, arg4, arg5)
            local v1 = toggleTeleportToEnemy(arg5 or 0.35)
            local pointLight = Instance.new("PointLight")
            pointLight.Name = "HitFlash"
            pointLight.Color = arg2
            pointLight.Brightness = arg3 or 6
            pointLight.Range = arg4 or 14
            pointLight.Parent = arg1
            local v2 = Enum
            TweenService:Create(
                pointLight, TweenInfo.new(v1, v2.EasingStyle.Quad, v2.EasingDirection.Out),
                {Brightness = 0, Range = 0}
            ):Play()
            task.delay(
                v1 + 0.05,
                function()
                    if pointLight and pointLight.Parent then
                        pointLight:Destroy()
                    end
                end
            )
        end
        local function func9(arg1, arg2)
            if getActiveParticles() >= MAX_ACTIVE_PARTICLES then
                return nil
            end
            local particleEmitter = Instance.new("ParticleEmitter")
            particleEmitter.Name = arg2.Name or "HitEffect"
            particleEmitter.Texture = arg2.Texture or "rbxassetid://6603835352"
            if typeof(arg2.Color) == "ColorSequence" then
                particleEmitter.Color = arg2.Color
            else
                particleEmitter.Color = ColorSequence.new(arg2.Color or v3)
            end
            particleEmitter.LightEmission = arg2.LightEmission or 1
            particleEmitter.Brightness = arg2.Brightness or 8
            particleEmitter.LightInfluence = arg2.LightInfluence or 0
            particleEmitter.Orientation = arg2.Orientation or Enum.ParticleOrientation.FacingCamera
            particleEmitter.LockedToPart = arg2.LockedToPart or false
            particleEmitter.Size = arg2.Size or NumberSequence.new(0.12)
            particleEmitter.Transparency = arg2.Transparency or NumberSequence.new(
                {NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}
            )
            particleEmitter.Speed = arg2.Speed or NumberRange.new(12, 18)
            particleEmitter.SpreadAngle = arg2.SpreadAngle or Vector2.new(120, 120)
            particleEmitter.EmissionDirection = arg2.EmissionDirection or Enum.NormalId.Top
            local v1 = arg2.Lifetime or NumberRange.new(0.6, 1.2)
            local v2 = getClosestEnemy()
            particleEmitter.Lifetime = NumberRange.new(v1.Min * v2, v1.Max * v2)
            particleEmitter.Drag = arg2.Drag or 2
            particleEmitter.Acceleration = arg2.Acceleration or Vector3.new(0, 4, 0)
            particleEmitter.RotSpeed = arg2.RotSpeed or NumberRange.new(0, 0)
            particleEmitter.Rate = 0
            particleEmitter.Enabled = true
            particleEmitter.Parent = arg1
            particleEmitter:Emit(arg2.EmitCount or 48)
            task.delay(
                toggleTeleportToEnemy(arg2.Cleanup or 4),
                function()
                    if particleEmitter and particleEmitter.Parent then
                        particleEmitter:Destroy()
                    end
                end
            )
        end
        local function func10(arg1, arg2)
            local v1 = arg2 or v3
            local v2 = func1(arg1)
            if not v2 or not v2:IsA("BasePart") then
                return
            end
            local particleEmitter = Instance.new("ParticleEmitter")
            particleEmitter.Name = "TinyGlowingDots"
            particleEmitter.Texture = "rbxassetid://6603835352"
            particleEmitter.Color = ColorSequence.new(v1)
            particleEmitter.LightEmission = 1
            particleEmitter.Brightness = 13
            particleEmitter.LightInfluence = 0
            particleEmitter.Orientation = Enum.ParticleOrientation.FacingCamera
            particleEmitter.LockedToPart = false
            particleEmitter.Size = NumberSequence.new(
                {
                    NumberSequenceKeypoint.new(0, 0.09), NumberSequenceKeypoint.new(0.5, 0.135),
                    NumberSequenceKeypoint.new(1, 0.068),
                }
            )
            particleEmitter.Transparency = NumberSequence.new(
                {
                    NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.25, 0),
                    NumberSequenceKeypoint.new(1, 1),
                }
            )
            particleEmitter.Speed = NumberRange.new(22, 29)
            particleEmitter.SpreadAngle = Vector2.new(130, 130)
            particleEmitter.EmissionDirection = Enum.NormalId.Top
            local v4 = toggleTeleportToEnemy(4)
            particleEmitter.Lifetime = NumberRange.new(v4, v4 + 0.1)
            particleEmitter.Drag = 3.2
            particleEmitter.Acceleration = Vector3.new(0, 5, 0)
            particleEmitter.Rate = 0
            particleEmitter.Enabled = true
            particleEmitter.Parent = v2
            particleEmitter:Emit(64)
            task.delay(
                toggleTeleportToEnemy(5),
                function()
                    if particleEmitter and particleEmitter.Parent then
                        particleEmitter:Destroy()
                    end
                end
            )
        end
        local tbl2 = {}
        local function func11(arg1, arg2)
            return arg1 + math.random() * (arg2 - arg1)
        end
        local function func12(arg1)
            local v1 = tbl2[arg1] or {}
            local v3
            local num = -1
            for _ = 1, 60 do
                local vector3 = Vector3.new(func11(-10, 10), func11(1, 8), (func11(-4, 4)))
                local huge = math.huge
                for _, v2 in ipairs(v1) do
                    local Magnitude = (vector3 - v2).Magnitude
                    if Magnitude < huge then
                        huge = Magnitude
                    end
                end
                if huge >= 5.5 then
                    return vector3
                end
                if huge > num then
                    num = huge
                    v3 = vector3
                end
            end
            return v3
        end
        local function func13()
            local num = 0
            for _, v1 in ipairs(workspace.CurrentCamera:GetChildren()) do
                if v1:IsA("BillboardGui") and v1.Name == "FortniteDamageNumber" then
                    num = num + 1
                end
            end
            return num
        end
        local tbl3 = {
            Particles = func10,
            Fortnite = function(arg1, arg2, arg3)
                local v1 = arg2 or v3
                if func13() >= 45 then
                    return
                end
                local v2
                if arg1:IsA("BasePart") then
                    v2 = arg1
                elseif arg1:IsA("Model") and arg1.PrimaryPart then
                    v2 = arg1.PrimaryPart
                end
                if not v2 then
                    return
                end
                local v4 = v2
                if not tbl2[v4] then
                    tbl2[v4] = {}
                end
                local v5 = func12(v4)
                local v6 = num1 or 2.8
                local v7 = v5 + Vector3.new(0, num or 7, 0)
                table.insert(tbl2[v4], v5)
                local billboardGui = Instance.new("BillboardGui")
                billboardGui.Name = "FortniteDamageNumber"
                billboardGui.Size = UDim2.new(0, 70, 0, 40)
                billboardGui.StudsOffset = v5
                billboardGui.AlwaysOnTop = true
                billboardGui.LightInfluence = 0
                billboardGui.Adornee = v2
                billboardGui.Parent = workspace.CurrentCamera
                local textLabel = Instance.new("TextLabel", billboardGui)
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = arg3
                textLabel.TextColor3 = v1
                textLabel.TextTransparency = 1
                textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                textLabel.TextStrokeTransparency = 1
                textLabel.TextScaled = true
                textLabel.FontFace = tbl.main
                textLabel.ZIndex = 1
                local v8 = toggleTeleportToEnemy(0.5)
                local v9 = Enum
                TweenService:Create(
                    textLabel, TweenInfo.new(0.12, v9.EasingStyle.Quad, v9.EasingDirection.Out),
                    {TextTransparency = 0, TextStrokeTransparency = 0.55}
                ):Play()
                TweenService:Create(
                    billboardGui, TweenInfo.new(v6, v9.EasingStyle.Quad, v9.EasingDirection.Out),
                    {StudsOffset = v7}
                ):Play()
                task.delay(
                    v6,
                    function()
                        if not billboardGui or not billboardGui.Parent then
                            return
                        end
                        local v1 = Enum
                        TweenService:Create(
                            textLabel,
                            TweenInfo.new(v8, v1.EasingStyle.Quad, v1.EasingDirection.In),
                            {TextTransparency = 1, TextStrokeTransparency = 1}
                        ):Play()
                        task.delay(
                            v8 + 0.02,
                            function()
                                if billboardGui and billboardGui.Parent then
                                    billboardGui:Destroy()
                                end
                                if tbl2[v4] then
                                    for i, v1 in ipairs(tbl2[v4]) do
                                        if v1 == v5 then
                                            table.remove(tbl2[v4], i)
                                            break
                                        end
                                    end
                                    if #tbl2[v4] == 0 then
                                        tbl2[v4] = nil
                                    end
                                end
                            end
                        )
                    end
                )
            end,
            Shockwave = function(arg1, arg2)
                local v1 = func1(arg1)
                if not v1 then
                    return
                end
                func8(v1, arg2, 8, 18, 0.4)
                func7(
                    v1, arg2, {Name = "ShockwaveRing", StartSize = 0.5, EndSize = 7, Duration = 0.5}
                )
                func7(
                    v1, func2(arg2, 0.2),
                    {Name = "ShockwaveRing2", StartSize = 0.25, EndSize = 5, Duration = 0.35, StartTransparency = 0.55}
                )
                func9(
                    v1,
                    {
                        Name = "ShockwaveBurst", Texture = "rbxassetid://243660364", Color = arg2,
                        EmitCount = 28, Speed = NumberRange.new(14, 24),
                        SpreadAngle = Vector2.new(180, 180),
                        EmissionDirection = Enum.NormalId.Front,
                        Lifetime = NumberRange.new(0.25, 0.45), Drag = 5,
                        Size = NumberSequence.new(
                            {NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(
                                1, 0.05
                            )}
                        ), Cleanup = 1.5,
                    }
                )
            end,
            Lightning = function(arg1, arg2)
                local v1 = func1(arg1)
                if not v1 then
                    return
                end
                local color3 = Color3.new(0.85, 0.92, 1)
                func8(v1, color3, 14, 22, 0.2)
                func9(
                    v1,
                    {
                        Name = "LightningCore", Texture = "rbxassetid://446111271", Color = color3,
                        Brightness = 16, EmitCount = 22, Speed = NumberRange.new(32, 48),
                        SpreadAngle = Vector2.new(18, 18), Lifetime = NumberRange.new(0.08, 0.22),
                        Drag = 0.2, Acceleration = Vector3.new(0, -20, 0), Cleanup = 1,
                    }
                )
                func9(
                    v1,
                    {
                        Name = "LightningArcs", Texture = "rbxassetid://12781852245",
                        Color = ColorSequence.new(
                            {
                                ColorSequenceKeypoint.new(0, color3),
                                ColorSequenceKeypoint.new(0.5, arg2),
                                ColorSequenceKeypoint.new(1, color3),
                            }
                        ), Brightness = 12, EmitCount = 40, Speed = NumberRange.new(20, 38),
                        SpreadAngle = Vector2.new(120, 120), Lifetime = NumberRange.new(0.12, 0.35),
                        Drag = 1, Acceleration = Vector3.new(0, -14, 0), Cleanup = 1.5,
                    }
                )
            end,
            Blood = function(arg1, arg2)
                local v1 = func1(arg1)
                if not v1 then
                    return
                end
                local color3 = Color3.new(
                    math.clamp(arg2.R * 0.9 + 0.35, 0, 1), math.clamp(arg2.G * 0.15, 0, 0.35),
                    math.clamp(arg2.B * 0.15, 0, 0.35)
                )
                func9(
                    v1,
                    {
                        Name = "BloodSplatter", Texture = "rbxassetid://243660364", Color = color3,
                        EmitCount = 70, Speed = NumberRange.new(12, 28),
                        SpreadAngle = Vector2.new(175, 175), Lifetime = NumberRange.new(0.7, 1.3),
                        Drag = 5, Acceleration = Vector3.new(0, -22, 0),
                        Size = NumberSequence.new(
                            {
                                NumberSequenceKeypoint.new(0, 0.22),
                                NumberSequenceKeypoint.new(0.6, 0.14),
                                NumberSequenceKeypoint.new(1, 0.04),
                            }
                        ),
                    }
                )
                func9(
                    v1,
                    {
                        Name = "BloodMist", Texture = "rbxassetid://6603835352",
                        Color = func3(color3, 0.15), EmitCount = 20, Speed = NumberRange.new(4, 10),
                        SpreadAngle = Vector2.new(180, 180), Lifetime = NumberRange.new(0.4, 0.8),
                        Transparency = NumberSequence.new(
                            {NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 1)}
                        ), Size = NumberSequence.new(0.5), Cleanup = 2,
                    }
                )
            end,
            Fire = function(arg1, arg2)
                local v1 = func1(arg1)
                if not v1 then
                    return
                end
                local color3 = Color3.new(
                    math.clamp(arg2.R + 0.25, 0, 1), math.clamp(arg2.G * 0.6 + 0.2, 0, 1),
                    math.clamp(arg2.B * 0.2, 0, 0.4)
                )
                func8(v1, color3, 10, 16, 0.45)
                func9(
                    v1,
                    {
                        Name = "FireFlames", Texture = "rbxassetid://241650108",
                        Color = ColorSequence.new(
                            {
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 120)),
                                ColorSequenceKeypoint.new(0.45, color3),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 20, 10)),
                            }
                        ), EmitCount = 55, Speed = NumberRange.new(8, 18),
                        SpreadAngle = Vector2.new(70, 70), Lifetime = NumberRange.new(0.45, 0.95),
                        Acceleration = Vector3.new(0, 14, 0), LightEmission = 1, Brightness = 14,
                        Size = NumberSequence.new(
                            {NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0.05)}
                        ),
                    }
                )
                func9(
                    v1,
                    {
                        Name = "FireEmbers", Texture = "rbxassetid://12781852245", Color = color3,
                        EmitCount = 25, Speed = NumberRange.new(14, 26),
                        SpreadAngle = Vector2.new(180, 180), Lifetime = NumberRange.new(0.6, 1.1),
                        Drag = 2, Acceleration = Vector3.new(0, 6, 0), Cleanup = 2.5,
                    }
                )
            end,
            Ice = function(arg1, arg2)
                local v1 = func1(arg1)
                if not v1 then
                    return
                end
                local color3 = Color3.new(
                    math.clamp(arg2.R * 0.35 + 0.55, 0, 1), math.clamp(arg2.G * 0.5 + 0.55, 0, 1),
                    math.clamp(arg2.B * 0.4 + 0.75, 0, 1)
                )
                func8(v1, color3, 6, 12, 0.35)
                func9(
                    v1,
                    {
                        Name = "IceShards", Texture = "rbxassetid://243660364", Color = color3,
                        EmitCount = 48, Speed = NumberRange.new(10, 20),
                        SpreadAngle = Vector2.new(110, 110), Lifetime = NumberRange.new(0.9, 1.5),
                        Drag = 1.5, RotSpeed = NumberRange.new(-180, 180),
                        Acceleration = Vector3.new(0, -6, 0),
                        Size = NumberSequence.new(
                            {NumberSequenceKeypoint.new(0, 0.28), NumberSequenceKeypoint.new(
                                1, 0.06
                            )}
                        ),
                    }
                )
                func9(
                    v1,
                    {
                        Name = "IceFrost", Texture = "rbxassetid://6603835352",
                        Color = Color3.new(1, 1, 1), EmitCount = 24, Speed = NumberRange.new(2, 6),
                        SpreadAngle = Vector2.new(180, 180), Lifetime = NumberRange.new(1.2, 1.8),
                        Transparency = NumberSequence.new(
                            {NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 1)}
                        ), Size = NumberSequence.new(0.4), Cleanup = 2.5,
                    }
                )
            end,
            Hearts = function(arg1, arg2)
                local v1 = func1(arg1)
                if not v1 then
                    return
                end
                local color3 = Color3.new(
                    math.clamp(arg2.R + 0.15, 0, 1), math.clamp(arg2.G * 0.35 + 0.2, 0, 1),
                    math.clamp(arg2.B * 0.4 + 0.35, 0, 1)
                )
                func9(
                    v1,
                    {
                        Name = "HeartsHit", Texture = "rbxassetid://120777973", Color = color3,
                        EmitCount = 24, Speed = NumberRange.new(5, 12),
                        SpreadAngle = Vector2.new(55, 55), Lifetime = NumberRange.new(1.1, 1.9),
                        Acceleration = Vector3.new(0, 8, 0), Drag = 1,
                        Size = NumberSequence.new(
                            {NumberSequenceKeypoint.new(0, 0.45), NumberSequenceKeypoint.new(1, 0.2)}
                        ), LightEmission = 0.6,
                    }
                )
            end,
            Stars = function(arg1, arg2)
                local v1 = func1(arg1)
                if not v1 then
                    return
                end
                func8(v1, arg2, 7, 14, 0.3)
                func9(
                    v1,
                    {
                        Name = "StarsBurst", Texture = "rbxassetid://1084982556", Color = arg2,
                        EmitCount = 40, Speed = NumberRange.new(16, 28),
                        SpreadAngle = Vector2.new(180, 180), Lifetime = NumberRange.new(0.6, 1.05),
                        RotSpeed = NumberRange.new(-240, 240), Brightness = 12,
                        Size = NumberSequence.new(
                            {NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 0.1)}
                        ),
                    }
                )
            end,
            Confetti = function(arg1, arg2)
                local v1 = func1(arg1)
                if not v1 then
                    return
                end
                local v2 = func2(arg2, 0.3)
                local color3 = Color3.new(arg2.G, arg2.B, arg2.R)
                func9(
                    v1,
                    {
                        Name = "ConfettiHit", Texture = "rbxassetid://243660364",
                        Color = ColorSequence.new(
                            {
                                ColorSequenceKeypoint.new(0, arg2),
                                ColorSequenceKeypoint.new(0.33, v2),
                                ColorSequenceKeypoint.new(0.66, color3),
                                ColorSequenceKeypoint.new(1, func2(v2, 0.2)),
                            }
                        ), EmitCount = 80, Speed = NumberRange.new(14, 30),
                        SpreadAngle = Vector2.new(180, 180), Lifetime = NumberRange.new(1.4, 2.4),
                        Drag = 2.5, Acceleration = Vector3.new(0, -10, 0),
                        RotSpeed = NumberRange.new(-420, 420),
                        Size = NumberSequence.new(
                            {NumberSequenceKeypoint.new(0, 0.22), NumberSequenceKeypoint.new(
                                1, 0.08
                            )}
                        ),
                    }
                )
            end,
            Ripple = function(arg1, arg2)
                local v1 = func1(arg1)
                if not v1 then
                    return
                end
                func7(
                    v1, arg2,
                    {Name = "RippleHit1", StartSize = 0.3, EndSize = 4.5, Duration = 0.45, StartTransparency = 0.3}
                )
                task.delay(
                    0.12,
                    function()
                        if v1 and v1.Parent then
                            func7(
                                v1, func2(arg2, 0.15),
                                {Name = "RippleHit2", StartSize = 0.2, EndSize = 6.5, Duration = 0.65, StartTransparency = 0.5}
                            )
                        end
                    end
                )
                func9(
                    v1,
                    {
                        Name = "RippleDroplets", Texture = "rbxassetid://6603835352", Color = arg2,
                        EmitCount = 16, Speed = NumberRange.new(6, 12),
                        SpreadAngle = Vector2.new(180, 180), Lifetime = NumberRange.new(0.5, 0.9),
                        Transparency = NumberSequence.new(
                            {NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1)}
                        ), Size = NumberSequence.new(0.12), Cleanup = 2,
                    }
                )
            end,
            Sparks = function(arg1, arg2)
                local v1 = func1(arg1)
                if not v1 then
                    return
                end
                func8(v1, arg2, 9, 12, 0.25)
                func9(
                    v1,
                    {
                        Name = "SparksHit", Texture = "rbxassetid://12781852245", Color = arg2,
                        EmitCount = 65, Speed = NumberRange.new(22, 42),
                        SpreadAngle = Vector2.new(180, 180), Lifetime = NumberRange.new(0.18, 0.5),
                        Drag = 4, Brightness = 14, LightEmission = 1,
                        Acceleration = Vector3.new(0, -16, 0),
                    }
                )
                func9(
                    v1,
                    {
                        Name = "SparksGlow", Texture = "rbxassetid://6603835352",
                        Color = func2(arg2, 0.4), EmitCount = 12, Speed = NumberRange.new(4, 8),
                        SpreadAngle = Vector2.new(180, 180), Lifetime = NumberRange.new(0.35, 0.6),
                        Size = NumberSequence.new(0.25), Cleanup = 1.5,
                    }
                )
            end,
            Neon = function(arg1, arg2)
                local v1 = func1(arg1)
                if not v1 then
                    return
                end
                func8(v1, arg2, 16, 20, 0.5)
                func7(
                    v1, arg2,
                    {Name = "NeonPulseRing", StartSize = 0.15, EndSize = 4, Duration = 0.35, StartTransparency = 0.15}
                )
                func9(
                    v1,
                    {
                        Name = "NeonPulseCore", Texture = "rbxassetid://6603835352", Color = arg2,
                        Brightness = 16, LightEmission = 1, EmitCount = 50,
                        Speed = NumberRange.new(4, 10), SpreadAngle = Vector2.new(180, 180),
                        Lifetime = NumberRange.new(0.5, 0.9),
                        Size = NumberSequence.new(
                            {
                                NumberSequenceKeypoint.new(0, 0.6),
                                NumberSequenceKeypoint.new(0.5, 0.35),
                                NumberSequenceKeypoint.new(1, 0),
                            }
                        ),
                        Transparency = NumberSequence.new(
                            {NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}
                        ),
                    }
                )
            end,
            Void = function(arg1, arg2)
                local v1 = func1(arg1)
                if not v1 then
                    return
                end
                local v2 = func3(arg2, 0.55)
                local v3 = func2(arg2, 0.1)
                func9(
                    v1,
                    {
                        Name = "VoidRiftCore", Texture = "rbxassetid://243660364", Color = v2,
                        EmitCount = 35, Speed = NumberRange.new(2, 8),
                        SpreadAngle = Vector2.new(180, 180),
                        EmissionDirection = Enum.NormalId.Bottom,
                        Lifetime = NumberRange.new(0.8, 1.4), Drag = 3,
                        Acceleration = Vector3.new(0, -14, 0),
                        Size = NumberSequence.new(
                            {NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0.1)}
                        ), LightEmission = 0.2, Brightness = 2,
                    }
                )
                func9(
                    v1,
                    {
                        Name = "VoidRiftEdge", Texture = "rbxassetid://446111271", Color = v3,
                        EmitCount = 45, Speed = NumberRange.new(10, 22),
                        SpreadAngle = Vector2.new(180, 180), Lifetime = NumberRange.new(0.4, 0.85),
                        RotSpeed = NumberRange.new(-300, 300), Brightness = 10, LightEmission = 1,
                        Cleanup = 2,
                    }
                )
            end,
            Plasma = function(arg1, arg2)
                local v1 = func1(arg1)
                if not v1 then
                    return
                end
                local color3 = Color3.new(
                    math.clamp(1 - arg2.R, 0, 1), math.clamp(arg2.G, 0, 1),
                    math.clamp(arg2.B + 0.3, 0, 1)
                )
                func8(v1, arg2, 12, 18, 0.35)
                func9(
                    v1,
                    {
                        Name = "PlasmaCore", Texture = "rbxassetid://446111271",
                        Color = ColorSequence.new(
                            {
                                ColorSequenceKeypoint.new(0, arg2),
                                ColorSequenceKeypoint.new(0.5, color3),
                                ColorSequenceKeypoint.new(1, arg2),
                            }
                        ), Brightness = 15, EmitCount = 55, Speed = NumberRange.new(6, 16),
                        SpreadAngle = Vector2.new(180, 180), Lifetime = NumberRange.new(0.35, 0.7),
                        Size = NumberSequence.new(
                            {NumberSequenceKeypoint.new(0, 0.55), NumberSequenceKeypoint.new(
                                1, 0.08
                            )}
                        ), LightEmission = 1,
                    }
                )
                func7(
                    v1, color3,
                    {Name = "PlasmaRing", StartSize = 0.4, EndSize = 5.5, Duration = 0.4, StartTransparency = 0.25}
                )
            end,
            Glitch = function(arg1, arg2)
                local v1 = func1(arg1)
                if not v1 then
                    return
                end
                for i = 1, 6 do
                    func9(
                        v1,
                        {
                            Name = "GlitchShard" .. i, Texture = "rbxassetid://243660364",
                            Color = i % 2 == 0 and arg2 or func2(arg2, 0.5), EmitCount = 8,
                            Speed = NumberRange.new(18, 32), SpreadAngle = Vector2.new(40, 40),
                            EmissionDirection = Enum.NormalId.Top,
                            Lifetime = NumberRange.new(0.1, 0.25), Drag = 0,
                            RotSpeed = NumberRange.new(-500, 500),
                            Size = NumberSequence.new(
                                {NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(
                                    1, 0.1
                                )}
                            ),
                            Transparency = NumberSequence.new(
                                {NumberSequenceKeypoint.new(0, math.random() * 0.4), NumberSequenceKeypoint.new(
                                    1, 1
                                )}
                            ), Cleanup = 0.8,
                        }
                    )
                end
                func8(v1, func2(arg2, 0.6), 8, 10, 0.15)
            end,
            ["Cosmic Shit"] = function(arg1, arg2)
                local v1 = func1(arg1)
                if not v1 then
                    return
                end
                func8(v1, func2(arg2, 0.25), 5, 16, 0.6)
                func9(
                    v1,
                    {
                        Name = "CosmicDust", Texture = "rbxassetid://1084982556",
                        Color = ColorSequence.new(
                            {
                                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                                ColorSequenceKeypoint.new(0.4, arg2),
                                ColorSequenceKeypoint.new(1, func3(arg2, 0.2)),
                            }
                        ), EmitCount = 60, Speed = NumberRange.new(3, 14),
                        SpreadAngle = Vector2.new(180, 180), Lifetime = NumberRange.new(1.2, 2),
                        Drag = 0.5, Acceleration = Vector3.new(0, 2, 0),
                        RotSpeed = NumberRange.new(-80, 80), Brightness = 9,
                        Size = NumberSequence.new(
                            {
                                NumberSequenceKeypoint.new(0, 0.08),
                                NumberSequenceKeypoint.new(0.5, 0.18),
                                NumberSequenceKeypoint.new(1, 0.04),
                            }
                        ),
                        Transparency = NumberSequence.new(
                            {NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1)}
                        ),
                    }
                )
                func7(
                    v1, func2(arg2, 0.1),
                    {
                        Name = "CosmicRing", StartSize = 0.2, EndSize = 3.5, Duration = 0.8,
                        StartTransparency = 0.65, Material = Enum.Material.Glass,
                    }
                )
            end,
        }
        workspace.DescendantAdded:Connect(
            function(arg1)
                if not flag then
                    return
                end
                if not arg1:IsA("BillboardGui") then
                    return
                end
                local v1 = func(arg1)
                if not v1 then
                    return
                end
                task.defer(
                    function()
                        if not arg1 or not arg1.Parent then
                            return
                        end
                        arg1.Enabled = false
                        func6(
                            function(arg1)
                                local v2 = tbl3[arg1]
                                if v2 then
                                    if arg1 == "Fortnite" then
                                        v2(v1.adornee, v3, v1.lbl.Text)
                                    else
                                        v2(v1.adornee, v3)
                                    end
                                end
                            end
                        )
                    end
                )
            end
        )
    end)()
    local v3 = _raw:AddRightTabbox()
    local v4 = v3:AddTab("view model")
    local v5 = v3:AddTab("viewport")
    local flag = false
    local flag1 = false
    local flag2 = false
    local flag3 = false
    local flag4 = false
    local v6 = Color3.fromRGB(255, 255, 255)
    local v7 = Color3.fromRGB(255, 255, 255)
    local v8 = Color3.fromRGB(255, 255, 255)
    local v9 = Color3.fromRGB(255, 255, 255)
    local v10 = Color3.fromRGB(255, 255, 255)
    local v11 = Color3.fromRGB(255, 255, 255)
    local v12 = Enum
    local Neon = v12.Material.Neon
    local ForceField = v12.Material.ForceField
    local v13 = Color3.fromRGB(255, 255, 255)
    local v14 = Color3.fromRGB(255, 255, 255)
    local v15 = Color3.fromRGB(255, 255, 255)
    local num = 1
    local num1 = 0
    local v16 = Color3.fromRGB(255, 255, 255)
    local v17 = Color3.fromRGB(255, 255, 255)
    local v18 = Color3.fromRGB(255, 255, 255)
    local num2 = 1
    local num3 = 0
    local num4 = 0
    local num5 = 0
    local flag5 = false
    local flag6 = false
    local v19 = Color3.fromRGB(255, 255, 255)
    local v20 = Color3.fromRGB(200, 200, 255)
    local v21 = Color3.fromRGB(255, 255, 255)
    local v22 = Color3.fromRGB(200, 200, 255)
    local v23 = Enum
    local Neon1 = v23.Material.Neon
    local num6 = 0
    local num7 = 0
    local num8 = 0
    local num9 = 0
    local num10 = 0
    local num11 = 0
    local tbl = {}
    local tbl1 = {}
    local tbl2 = {}
    local tbl3 = {}
    local tbl4 = {}
    local tbl5 = {}
    local folder = Instance.new("Folder")
    folder.Name = "\0ChamOutlines"
    folder.Parent = game.CoreGui
    local tbl6 = {
        ChamOutlineShell = true, ChamOutlineGlow = true, ChamOutlineBloom = true,
        WeaponWireframeCore = true, WeaponWireframeGlow = true, WeaponWireframeBloom = true,
        GunChamNeonGlow = true,
    }
    local flag7 = false
    local num12 = 0
    local num13 = 0
    local num14 = 0
    local function func1(arg1)
        if not tbl1[arg1] then
            tbl1[arg1] = {
                Material = arg1.Material, Color = arg1.Color, Transparency = arg1.Transparency,
                Reflectance = arg1.Reflectance, textures = {}, surfaceAppearances = {},
            }
            if arg1:IsA("MeshPart") then
                tbl1[arg1].TextureID = arg1.TextureID
            end
            for _, v1 in ipairs(arg1:GetChildren()) do
                if v1:IsA("Texture") or v1:IsA("Decal") then
                    tbl1[arg1].textures[v1] = v1.Transparency
                elseif v1:IsA("SurfaceAppearance") then
                    table.insert(tbl1[arg1].surfaceAppearances, v1:Clone())
                end
            end
        end
    end
    local function func2(arg1)
        local v1 = tbl1[arg1]
        if not v1 then
            return
        end
        pcall(
            function()
                arg1.Material = v1.Material
                arg1.Color = v1.Color
                arg1.Transparency = v1.Transparency
                arg1.Reflectance = v1.Reflectance or 0
                if arg1:IsA("MeshPart") and v1.TextureID ~= nil then
                    arg1.TextureID = v1.TextureID
                end
                for k, v2 in pairs(v1.textures) do
                    if k and k.Parent then
                        k.Transparency = v2
                    end
                end
                for _, v3 in ipairs(v1.surfaceAppearances or {}) do
                    if v3 and not arg1:FindFirstChild(v3.Name) then
                        v3:Clone().Parent = arg1
                    end
                end
            end
        )
    end
    local function func3(arg1, arg2, arg3, arg4, arg5)
        func1(arg1)
        pcall(
            function()
                arg1.Material = arg3
                arg1.Color = arg2
                arg1.Transparency = math.clamp(arg4 or 0, 0, 1)
                arg1.Reflectance = 0
                arg1.LocalTransparencyModifier = 0
                if arg1:IsA("MeshPart") then
                    arg1.TextureID = ""
                end
                local function func(arg3)
                    if arg3:IsA("SurfaceAppearance") or arg3:IsA("WrapLayer") then
                        arg3:Destroy()
                    elseif arg3:IsA("Texture") or arg3:IsA("Decal") then
                        if tbl1[arg1] and not tbl1[arg1].textures[arg3] then
                            tbl1[arg1].textures[arg3] = arg3.Transparency
                        end
                        if arg5 then
                            arg3:Destroy()
                        else
                            arg3.Transparency = 1
                        end
                    elseif arg3:IsA("SpecialMesh") or arg3:IsA("Mesh") then
                        arg3.TextureId = ""
                        if arg3:IsA("SpecialMesh") then
                            arg3.VertexColor = arg2
                        end
                    end
                end
                for _, v1 in ipairs(arg1:GetChildren()) do
                    func(v1)
                end
                if arg5 then
                    for _, v2 in ipairs(arg1:GetDescendants()) do
                        func(v2)
                    end
                end
            end
        )
    end
    local function getClosestEnemy(arg1, arg2, arg3, arg4)
        func3(arg1, arg2, arg3, arg4, true)
        pcall(
            function()
                arg1.Material = arg3
                arg1.Color = arg2
                arg1.Transparency = math.clamp(arg4 or 0, 0, 1)
                arg1.Reflectance = 0
                arg1.LocalTransparencyModifier = 0
                if arg1:IsA("MeshPart") then
                    arg1.TextureID = ""
                end
                for _, v1 in ipairs(arg1:GetDescendants()) do
                    if v1:IsA("SurfaceAppearance") or v1:IsA("WrapLayer") then
                        v1:Destroy()
                    elseif v1:IsA("Texture") or v1:IsA("Decal") then
                        v1:Destroy()
                    elseif v1:IsA("SpecialMesh") or v1:IsA("Mesh") then
                        v1.TextureId = ""
                        if v1:IsA("SpecialMesh") then
                            v1.VertexColor = arg2
                        end
                    end
                end
            end
        )
    end
    local function toggleTeleportToEnemy(arg1, arg2, arg3)
        return Color3.new(
            arg1.R + (arg2.R - arg1.R) * arg3, arg1.G + (arg2.G - arg1.G) * arg3,
            arg1.B + (arg2.B - arg1.B) * arg3
        )
    end
    local function func6(arg1, arg2, arg3, arg4, arg5)
        local v1 = (arg4 + arg5) % 1
        if v1 < 0.33 then
            return toggleTeleportToEnemy(arg1, arg2, v1 / 0.33)
        end
        if v1 < 0.66 then
            return toggleTeleportToEnemy(arg2, arg3, (v1 - 0.33) / 0.33)
        end
        return toggleTeleportToEnemy(arg3, arg1, (v1 - 0.66) / 0.34)
    end
    local function func7(arg1, arg2, arg3)
        local v1 = arg3 * 2
        if v1 > 1 then
            v1 = 2 - v1
        end
        return toggleTeleportToEnemy(arg2, arg1, v1)
    end
    local function func8(arg1)
        if tbl6[arg1.Name] then
            return false
        end
        if arg1.Transparency >= 0.99 then
            return false
        end
        local v1 = arg1.Name:lower()
        if v1:find("hitbox") or v1:find("collision") or v1:find("trigger") or v1:find("proxy") then
            return false
        end
        return true
    end
    local function func9(arg1)
        return string.format(
            "%d_%d_%d", math.floor(arg1.R * 255), math.floor(arg1.G * 255), math.floor(arg1.B * 255)
        )
    end
    local function func10(arg1)
        local ChamOutlineShell = arg1:FindFirstChild("ChamOutlineShell")
        if ChamOutlineShell then
            pcall(
                function()
                    ChamOutlineShell:Destroy()
                end
            )
        end
        local ChamOutline = arg1:FindFirstChild("ChamOutline")
        if ChamOutline and ChamOutline:IsA("Highlight") then
            pcall(
                function()
                    ChamOutline:Destroy()
                end
            )
        end
    end
    local function func11(arg1)
        for _, v1 in ipairs({tbl4, tbl5}) do
            local v2 = v1[arg1]
            if v2 then
                pcall(
                    function()
                        v2:Destroy()
                    end
                )
                v1[arg1] = nil
            end
        end
    end
    local function func12()
        local tbl = {}
        for k in pairs(tbl4) do
            tbl[k] = true
        end
        for k1 in pairs(tbl5) do
            tbl[k1] = true
        end
        for k2 in pairs(tbl) do
            func11(k2)
        end
    end
    local function func13(arg1)
        func10(arg1)
        func11(arg1)
        local v1 = tbl2[arg1]
        if v1 then
            pcall(
                function()
                    v1:Destroy()
                end
            )
            tbl2[arg1] = nil
        end
        tbl3[arg1] = nil
    end
    local function func14()
        func12()
        local tbl = {}
        for k in pairs(tbl2) do
            tbl[k] = true
        end
        for k1 in pairs(tbl) do
            func13(k1)
        end
    end
    local function func15(arg1, arg2)
        if not arg1 or not arg1.Parent then
            return
        end
        local v1 = func9(arg2)
        local v2 = tbl2[arg1]
        if v2 and v2.Parent and v2.Adornee == arg1 and tbl3[arg1] == v1 then
            return
        end
        func10(arg1)
        if not v2 or not v2.Parent then
            local highlight = Instance.new("Highlight")
            v2 = highlight
            highlight.Name = "ChamOutline"
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = folder
            tbl2[arg1] = highlight
        end
        v2.OutlineColor = arg2
        v2.OutlineTransparency = 0
        v2.FillColor = arg2
        v2.FillTransparency = 1
        v2.Adornee = arg1
        tbl3[arg1] = v1
    end
    local function func16(arg1)
        for k in pairs(tbl2) do
            if not arg1[k] then
                func13(k)
            end
        end
    end
    local function func17()
        return flag or flag1 or flag3 or flag4 or flag2 or flag5 or flag6
    end
    local function func18(arg1)
        local v1 = tbl[arg1]
        if v1 then
            pcall(
                function()
                    v1:Destroy()
                end
            )
            tbl[arg1] = nil
        end
        local v2 = arg1 and arg1:FindFirstChild("InstanceVmPartHighlight")
        if v2 and v2:IsA("Highlight") then
            pcall(
                function()
                    v2:Destroy()
                end
            )
        end
    end
    local function func19()
        for k in pairs(tbl) do
            func18(k)
        end
        tbl = {}
    end
    local function func20(arg1, arg2, arg3, arg4, arg5)
        if not arg1 or not arg1.Parent then
            func18(arg1)
            return
        end
        func18(arg1)
        local highlight = Instance.new("Highlight")
        highlight.Name = "InstanceVmPartHighlight"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = arg2
        highlight.OutlineColor = arg3
        highlight.FillTransparency = math.clamp(arg4 or 0, 0, 1)
        highlight.OutlineTransparency = math.clamp(arg5 or 0, 0, 1)
        highlight.Adornee = arg1
        highlight.Parent = arg1
        tbl[arg1] = highlight
    end
    local function func21(arg1)
        for k in pairs(tbl) do
            if not arg1[k] then
                func18(k)
            end
        end
    end
    local function func22(arg1)
        local tbl = {}
        for k in arg1.Name:gmatch("[^-]+") do
            table.insert(tbl, k:match("^%s*(.-)%s*$"):lower())
        end
        if #tbl >= 2 then
            local v1 = tbl[2]
            if v1 == "arms" or v1 == "arm" then
                return true
            end
            if v1:find("arm", 1, true) and not v1:find("charm", 1, true) and not v1:find(
                "armor", 1, true
            ) then
                return true
            end
            if v1:find("glove", 1, true) then
                return true
            end
            return false
        end
        local v2 = arg1.Name:lower()
        return v2:find("arms", 1, true) ~= nil or v2:find("glove", 1, true) ~= nil
    end
    local tbl7 = {
        hitbox = true, collision = true, trigger = true, proxy = true, handguard = true,
        handle = true, foregrip = true, charm = true, armor = true,
    }
    local function func23(arg1)
        local v1 = arg1:lower()
        for k in pairs(tbl7) do
            if v1:find(k, 1, true) then
                return false
            end
        end
        if v1 == "leftarm" or v1 == "rightarm" or v1 == "larm" or v1 == "rarm" then
            return true
        end
        if v1:find("leftarm", 1, true) or v1:find("rightarm", 1, true) then
            return true
        end
        if v1:find("left arm", 1, true) or v1:find("right arm", 1, true) then
            return true
        end
        if v1:find("forearm", 1, true) or v1:find("upperarm", 1, true) or v1:find(
            "lowerarm", 1, true
        ) then
            return true
        end
        if v1:find("glove", 1, true) or v1:find("sleeve", 1, true) then
            return true
        end
        if v1:find("finger", 1, true) or v1:find("wrist", 1, true) or v1:find("palm", 1, true) or v1:find(
            "thumb", 1, true
        ) then
            return true
        end
        if v1:find("hand", 1, true) then
            if v1:find("handguard", 1, true) or v1:find("handle", 1, true) then
                return false
            end
            return true
        end
        return false
    end
    local function func24(arg1, arg2)
        local Parent = arg1.Parent
        while Parent and Parent ~= arg2 do
            local v1 = Parent.Name:lower()
            if v1 == "arms" or v1 == "leftarm" or v1 == "rightarm" or v1 == "left arm" or v1 == "right arm" or v1 == "hands" or v1 == "gloves" then
                return true
            end
            if v1:find("glove", 1, true) or v1:find("sleeve", 1, true) then
                return true
            end
            if v1:find("arm", 1, true) and not v1:find("armor", 1, true) and not v1:find(
                "handguard", 1, true
            ) and not v1:find("foregrip", 1, true) and not v1:find("charm", 1, true) then
                return true
            end
            Parent = Parent.Parent
        end
        return false
    end
    local function func25(arg1, arg2)
        if not arg1 or not arg1:IsA("BasePart") then
            return false
        end
        if tbl6[arg1.Name] or arg1.Transparency >= 0.99 then
            return false
        end
        if func22(arg2) then
            local v1 = arg1.Name:lower()
            if tbl6[arg1.Name] then
                return false
            end
            if v1:find("hitbox") or v1:find("collision") or v1:find("trigger") or v1:find("proxy") then
                return false
            end
            return true
        end
        if func24(arg1, arg2) then
            return true
        end
        return (func23(arg1.Name))
    end
    local function func26(arg1, arg2)
        if not arg1 or not arg1:IsA("BasePart") then
            return false
        end
        if tbl6[arg1.Name] or arg1.Transparency >= 0.99 then
            return false
        end
        if func22(arg2) then
            return false
        end
        if func25(arg1, arg2) then
            return false
        end
        return (func8(arg1))
    end
    local func34
    local v37
    local num15 = 0
    local v38
    local flag8 = true
    local flag9 = false
    local flag10 = false
    local function func27()
        flag8 = true
    end
    local function func28()
        func14()
        func12()
        func19()
        for k in pairs(tbl1) do
            if k and k.Parent then
                func2(k)
            end
        end
        tbl1 = {}
        v38 = nil
        flag8 = true
    end
    local function func29(arg1)
        if not arg1 or flag10 then
            return
        end
        flag10 = true
        arg1.ChildAdded:Connect(
            function()
                task.defer(func27)
            end
        )
        arg1.ChildRemoved:Connect(
            function()
                task.defer(func27)
            end
        )
    end
    local function func30(arg1)
        v38 = {}
        for _, v1 in ipairs(arg1:GetChildren()) do
            if v1:IsA("Model") then
                for _, v2 in ipairs(v1:GetDescendants()) do
                    if v2:IsA("BasePart") then
                        local v3 = func25(v2, v1)
                        local v4 = func26(v2, v1)
                        if v3 or v4 then
                            table.insert(v38, {part = v2, model = v1, isArm = v3, isGun = v4})
                        end
                    end
                end
            end
        end
        flag8 = false
    end
    local function func31()
        pcall(
            function()
                game:GetService("RunService"):UnbindFromRenderStep("InstanceViewModelChams")
            end
        )
        if v37 then
            v37:Disconnect()
            v37 = nil
        end
        flag9 = false
        flag10 = false
        func28()
    end
    local function func32()
        if v37 then
            v37:Disconnect()
            v37 = nil
        end
        local v1 = pcall
        v1(
            function()
                game:GetService("RunService"):UnbindFromRenderStep("InstanceViewModelChams")
            end
        )
        if not v1(
            function()
                game:GetService("RunService"):BindToRenderStep(
                    "InstanceViewModelChams", Enum.RenderPriority.Last.Value, func34
                )
            end
        ) then
            v37 = game:GetService("RunService").RenderStepped:Connect(func34)
        end
    end
    local function func33()
        func27()
        if func17() then
            func32()
        else
            func31()
        end
    end
    getgenv().InstanceUpdViewModelChams = func33
    func34 = function(arg1)
        if isInstanceMenuOpen and isInstanceMenuOpen() then
            return
        end
        local v1 = arg1 or 0.004166666666666667
        if flag5 then
            num10 = (num10 + v1 * 0.12) % 1
        end
        if flag6 then
            num11 = (num11 + v1 * 0.12) % 1
        end
        if flag or flag1 or flag3 or flag4 or flag5 or flag6 then
            num15 = num15 + v1
            if num15 >= 0.016666666666666666 then
                num15 = num15 - 0.016666666666666666
                if flag or flag3 or flag5 then
                    num1 = (num1 + 0.016666666666666666 * num) % 1
                end
                if flag1 or flag4 or flag6 then
                    num3 = (num3 + 0.016666666666666666 * num2) % 1
                end
            end
        end
        if not func17() then
            if v38 or next(tbl1) then
                func28()
            end
            return
        end
        local ViewModels = game:GetService("Workspace"):FindFirstChild("ViewModels")
        if not ViewModels then
            if not flag9 then
                func28()
                flag9 = true
            end
            return
        end
        local FirstPerson = ViewModels:FindFirstChild("FirstPerson")
        if not FirstPerson then
            if not flag9 then
                func28()
                flag9 = true
            end
            flag10 = false
            return
        end
        flag9 = false
        func29(FirstPerson)
        if flag8 or not v38 then
            func30(FirstPerson)
        end
        local tbl = {}
        local tbl2 = {}
        local tbl3 = {}
        for _, v2 in ipairs(v38) do
            local part = v2.part
            if not part or not part.Parent then
                func27()
            else
                local isArm = v2.isArm
                local v3 = v2.isGun and not v2.isArm
                tbl2[part] = true
                func1(part)
                if flag2 and isArm then
                    part.Transparency = 1
                    for _, v4 in ipairs(part:GetChildren()) do
                        if v4:IsA("Texture") or v4:IsA("Decal") or v4:IsA("SurfaceAppearance") then
                            v4.Transparency = 1
                        end
                    end
                    func13(part)
                    func18(part)
                else
                    local v5 = flag5 and v3
                    local v12 = flag6 and isArm
                    local v23 = not v5 and not v12 and (isArm and flag1 or v3 and flag)
                    local v24 = isArm and flag4 and not v12 or v3 and flag3 and not v5
                    local v25 = func6(
                        isArm and v16 or v13, isArm and v17 or v14, isArm and v18 or v15, 0,
                        isArm and num3 or num1
                    )
                    local v26 = func6(
                        isArm and v9 or v6, isArm and v10 or v7, isArm and v11 or v8, 0,
                        isArm and num3 or num1
                    )
                    if v5 then
                        func2(part)
                        local v27 = func7(v19, v20, num10)
                        local v28 = toggleTeleportToEnemy(v27, Color3.new(0, 0, 0), 0.35)
                        func20(part, v27, v28, num6, num7)
                        tbl3[part] = true
                    elseif v12 then
                        local v29 = func7(v21, v22, num11)
                        local v30 = toggleTeleportToEnemy(v29, Color3.new(0, 0, 0), 0.35)
                        local v31 = num8
                        getClosestEnemy(part, v29, Neon1, v31)
                        func20(part, v29, v30, v31, num9)
                        tbl3[part] = true
                    elseif v23 then
                        local v32 = isArm and ForceField or Neon
                        local v33 = isArm and num4 or num5
                        if isArm then
                            getClosestEnemy(part, v25, v32, v33)
                        else
                            func3(part, v25, v32, v33, false)
                        end
                        func18(part)
                    elseif not v24 then
                        func2(part)
                        func18(part)
                    else
                        func18(part)
                    end
                    if v24 then
                        func15(part, v26)
                        tbl[part] = true
                    else
                        func13(part)
                    end
                end
            end
        end
        func16(tbl)
        func21(tbl3)
        for k in pairs(tbl1) do
            if not tbl2[k] then
                func2(k)
                tbl1[k] = nil
            end
        end
    end
    local connection
    local function func35()
        if connection then
            connection:Disconnect()
        end
        connection = game:GetService("RunService").RenderStepped:Connect(
            function()
                if isInstanceMenuOpen and isInstanceMenuOpen() then
                    return
                end
                if not flag7 then
                    return
                end
                local ViewModels = game:GetService("Workspace"):FindFirstChild("ViewModels")
                if not ViewModels then
                    return
                end
                local FirstPerson = ViewModels:FindFirstChild("FirstPerson")
                if not FirstPerson then
                    return
                end
                local v1 = workspace.CurrentCamera.CFrame * CFrame.new(num12, num13, num14)
                for _, v2 in ipairs(FirstPerson:GetChildren()) do
                    if v2:IsA("Model") then
                        if v2.PrimaryPart then
                            v2:SetPrimaryPartCFrame(v1)
                        end
                    end
                end
            end
        )
    end
    local function func36()
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
    v5:AddToggle(
        "EnableViewport",
        {
            Text = "Enable", Default = false,
            Callback = function(arg1)
                flag7 = arg1
                if arg1 then
                    func35()
                else
                    func36()
                end
            end,
        }
    )
    v5:AddSlider(
        "OffsetX",
        {
            Text = "x", Default = 0, Min = -10, Max = 10, Rounding = 2, Compact = true,
            Callback = function(arg1)
                num12 = arg1
            end,
        }
    )
    v5:AddSlider(
        "OffsetY",
        {
            Text = "y", Default = 0, Min = -10, Max = 10, Rounding = 2, Compact = true,
            Callback = function(arg1)
                num13 = arg1
            end,
        }
    )
    v5:AddSlider(
        "OffsetZ",
        {
            Text = "Z", Default = 0, Min = -10, Max = 10, Rounding = 2, Compact = true,
            Callback = function(arg1)
                num14 = arg1
            end,
        }
    )
    local flag11 = false
    local tbl8 = {}
    local tbl9 = {}
    local v39
    local tbl10 = {
        Idle = {"idle"}, Reloading = {"reload"}, Sprinting = {"sprint"}, Crouching = {"crouch"},
        Shooting = {"shoot", "fire", "shot"}, Aiming = {"aim", "ads", "scope"},
    }
    local function func37(arg1)
        local tbl = {arg1.Name:lower()}
        local Animation = arg1.Animation
        if Animation then
            table.insert(tbl, Animation.Name:lower())
            table.insert(tbl, tostring(Animation.AnimationId):lower())
        end
        return table.concat(tbl, " ")
    end
    local function func38(arg1)
        if not flag11 or type(tbl8) ~= "table" then
            return false
        end
        local v1 = func37(arg1)
        for k, v2 in pairs(tbl10) do
            if tbl8[k] then
                for _, v3 in ipairs(v2) do
                    if v1:find(v3, 1, true) then
                        return true
                    end
                end
            end
        end
        return false
    end
    local function func39(arg1)
        if func38(arg1) then
            pcall(
                function()
                    arg1:Stop(0)
                end
            )
        end
    end
    local function func40(arg1)
        if typeof(arg1) ~= "Instance" or not arg1:IsA("Animator") then
            return
        end
        if arg1:GetAttribute("InstanceNoAnimBound") then
            return
        end
        arg1:SetAttribute("InstanceNoAnimBound", true)
        local Parent = arg1.Parent
        if Parent and Parent:IsA("Humanoid") then
            table.insert(
                tbl9,
                Parent.AnimationPlayed:Connect(
                    function(arg1)
                        if flag11 then
                            task.defer(
                                function()
                                    func39(arg1)
                                end
                            )
                        end
                    end
                )
            )
        end
    end
    local function func41(arg1)
        if not arg1 then
            return
        end
        for _, v1 in ipairs(arg1:GetDescendants()) do
            if v1:IsA("Animator") then
                func40(v1)
                if flag11 then
                    for _, v2 in ipairs(v1:GetPlayingAnimationTracks()) do
                        func39(v2)
                    end
                end
            end
        end
    end
    local function func42()
        local ViewModels = game:GetService("Workspace"):FindFirstChild("ViewModels")
        if not ViewModels then
            return
        end
        local FirstPerson = ViewModels:FindFirstChild("FirstPerson")
        if FirstPerson then
            func41(FirstPerson)
            if not ViewModels:GetAttribute("InstanceNoAnimVmHooked") then
                ViewModels:SetAttribute("InstanceNoAnimVmHooked", true)
                table.insert(
                    tbl9,
                    FirstPerson.DescendantAdded:Connect(
                        function(arg1)
                            if arg1:IsA("Animator") then
                                func40(arg1)
                            end
                        end
                    )
                )
            end
        end
    end
    local function func43()
        if v39 then
            v39:Disconnect()
            v39 = nil
        end
        for _, v1 in ipairs(tbl9) do
            pcall(
                function()
                    v1:Disconnect()
                end
            )
        end
        table.clear(tbl9)
        local ViewModels = game:GetService("Workspace"):FindFirstChild("ViewModels")
        if ViewModels then
            ViewModels:SetAttribute("InstanceNoAnimVmHooked", nil)
            for _, v2 in ipairs(ViewModels:GetDescendants()) do
                if v2:IsA("Animator") then
                    v2:SetAttribute("InstanceNoAnimBound", nil)
                end
            end
        end
    end
    local function func44()
        func43()
        func42()
        v39 = game:GetService("RunService").RenderStepped:Connect(
            function()
                if not flag11 then
                    return
                end
                if isInstanceMenuOpen and isInstanceMenuOpen() then
                    return
                end
                func42()
                local ViewModels = game:GetService("Workspace"):FindFirstChild("ViewModels")
                local v1 = ViewModels and ViewModels:FindFirstChild("FirstPerson")
                if not v1 then
                    return
                end
                for _, v2 in ipairs(v1:GetDescendants()) do
                    if v2:IsA("Animator") then
                        for _, v3 in ipairs(v2:GetPlayingAnimationTracks()) do
                            func39(v3)
                        end
                    end
                end
            end
        )
    end
    local function func45()
        if flag11 then
            func44()
        else
            func43()
        end
    end
    local v25 = v5:AddToggle(
        "NoAnimations",
        {
            Text = "No Animations", Default = false,
            Callback = function(arg1)
                flag11 = arg1
                func45()
            end,
        }
    )
    local v26 = v5:AddDependencyBox()
    v26:AddDropdown(
        "NoAnimationsList",
        {
            Text = "Disabled Animations",
            Values = {"Idle", "Reloading", "Sprinting", "Crouching", "Shooting", "Aiming"},
            Default = {}, Multi = true,
            Callback = function(arg1)
                tbl8 = arg1 or {}
            end,
        }
    )
    v26:SetupDependencies({{v25, true}})
    local tbl11 = {
        "ForceField", "Neon", "SmoothPlastic", "Glass", "Ice", "Plastic", "Wood", "Marble",
        "Granite", "Brick", "Cobblestone", "Concrete", "Slate", "Foil",
    }
    local v27 = v4:AddToggle(
        "GunChams",
        {
            Text = "Gun Chams", Default = false,
            Callback = function(arg1)
                flag = arg1
                func33()
            end,
        }
    ):AddColorPicker(
        "GunColor1",
        {
            Default = Color3.fromRGB(255, 255, 255), Title = "gun color 1",
            Callback = function(arg1)
                v13 = arg1
            end,
        }
    ):AddColorPicker(
        "GunColor2",
        {
            Default = Color3.fromRGB(255, 255, 255), Title = "gun color 2",
            Callback = function(arg1)
                v14 = arg1
            end,
        }
    ):AddColorPicker(
        "GunColor3",
        {
            Default = Color3.fromRGB(255, 255, 255), Title = "gun color 3",
            Callback = function(arg1)
                v15 = arg1
            end,
        }
    )
    local v28 = v4:AddDependencyBox()
    v28:AddDropdown(
        "GunMaterial",
        {
            Text = "Gun Material", Default = "Neon", Values = tbl11,
            Callback = function(arg1)
                Neon = Enum.Material[arg1]
            end,
        }
    )
    v28:AddSlider(
        "GunChamSpeed",
        {
            Text = "Gradient Speed", Default = num, Min = 0.1, Max = 10, Rounding = 1,
            Compact = true,
            Callback = function(arg1)
                num = arg1
            end,
        }
    )
    v28:AddSlider(
        "GunChamTransparency",
        {
            Text = "Gun Transparency", Default = num5, Min = 0, Max = 1, Rounding = 2,
            Compact = true,
            Callback = function(arg1)
                num5 = arg1
            end,
        }
    )
    v28:SetupDependencies({{v27, true}})
    local v29 = v4:AddToggle(
        "ArmChams",
        {
            Text = "Arm Chams", Default = false,
            Callback = function(arg1)
                flag1 = arg1
                func33()
            end,
        }
    ):AddColorPicker(
        "ArmColor1",
        {
            Default = Color3.fromRGB(255, 255, 255), Title = "arm color 1",
            Callback = function(arg1)
                v16 = arg1
            end,
        }
    ):AddColorPicker(
        "ArmColor2",
        {
            Default = Color3.fromRGB(255, 255, 255), Title = "arm color 2",
            Callback = function(arg1)
                v17 = arg1
            end,
        }
    ):AddColorPicker(
        "ArmColor3",
        {
            Default = Color3.fromRGB(255, 255, 255), Title = "arm color 3",
            Callback = function(arg1)
                v18 = arg1
            end,
        }
    )
    local v30 = v4:AddDependencyBox()
    v30:AddDropdown(
        "ArmMaterial",
        {
            Text = "Arm Material", Default = "ForceField", Values = tbl11,
            Callback = function(arg1)
                ForceField = Enum.Material[arg1]
            end,
        }
    )
    v30:AddSlider(
        "ArmChamSpeed",
        {
            Text = "Gradient Speed", Default = num2, Min = 0.1, Max = 10, Rounding = 1,
            Compact = true,
            Callback = function(arg1)
                num2 = arg1
            end,
        }
    )
    v30:AddSlider(
        "ArmChamTransparency",
        {
            Text = "Arm Transparency", Default = num4, Min = 0, Max = 1, Rounding = 2,
            Compact = true,
            Callback = function(arg1)
                num4 = arg1
            end,
        }
    )
    v30:SetupDependencies({{v29, true}})
    v4:AddToggle(
        "GunOutline",
        {
            Text = "Gun Outline", Default = false,
            Callback = function(arg1)
                flag3 = arg1
                func33()
            end,
        }
    ):AddColorPicker(
        "GunOutlineColor1",
        {
            Title = "gun outline 1", Default = Color3.fromRGB(255, 255, 255),
            Callback = function(arg1)
                v6 = arg1
            end,
        }
    ):AddColorPicker(
        "GunOutlineColor2",
        {
            Title = "gun outline 2", Default = Color3.fromRGB(255, 255, 255),
            Callback = function(arg1)
                v7 = arg1
            end,
        }
    ):AddColorPicker(
        "GunOutlineColor3",
        {
            Title = "gun outline 3", Default = Color3.fromRGB(255, 255, 255),
            Callback = function(arg1)
                v8 = arg1
            end,
        }
    )
    v4:AddToggle(
        "ArmOutline",
        {
            Text = "Arm Outline", Default = false,
            Callback = function(arg1)
                flag4 = arg1
                func33()
            end,
        }
    ):AddColorPicker(
        "ArmOutlineColor1",
        {
            Title = "arm outline 1", Default = Color3.fromRGB(255, 255, 255),
            Callback = function(arg1)
                v9 = arg1
            end,
        }
    ):AddColorPicker(
        "ArmOutlineColor2",
        {
            Title = "arm outline 2", Default = Color3.fromRGB(255, 255, 255),
            Callback = function(arg1)
                v10 = arg1
            end,
        }
    ):AddColorPicker(
        "ArmOutlineColor3",
        {
            Title = "arm outline 3", Default = Color3.fromRGB(255, 255, 255),
            Callback = function(arg1)
                v11 = arg1
            end,
        }
    )
    local v31 = v4:AddToggle(
        "GunHighlight",
        {
            Text = "Gun Highlight", Default = false,
            Callback = function(arg1)
                flag5 = arg1
                func33()
            end,
        }
    ):AddColorPicker(
        "GunHighlightTop",
        {
            Default = Color3.fromRGB(255, 255, 255), Title = "gun top",
            Callback = function(arg1)
                v19 = arg1
            end,
        }
    ):AddColorPicker(
        "GunHighlightBottom",
        {
            Default = Color3.fromRGB(200, 200, 255), Title = "gun bottom",
            Callback = function(arg1)
                v20 = arg1
            end,
        }
    )
    local v32 = v4:AddDependencyBox()
    v32:AddDropdown(
        "GunHighlightMaterial",
        {Text = "Gun Highlight Material", Default = "Neon", Values = tbl11, Callback = function(_) end}
    )
    v32:AddSlider(
        "GunHighlightFillTransparency",
        {
            Text = "Transparency", Default = num6, Min = 0, Max = 1, Rounding = 2, Compact = true,
            Callback = function(arg1)
                num6 = arg1
            end,
        }
    )
    v32:AddSlider(
        "GunHighlightOutlineTransparency",
        {
            Text = "Outline Transparency", Default = num7, Min = 0, Max = 1, Rounding = 2,
            Compact = true,
            Callback = function(arg1)
                num7 = arg1
            end,
        }
    )
    v32:SetupDependencies({{v31, true}})
    local v33 = v4:AddToggle(
        "ArmHighlight",
        {
            Text = "Arm Highlight", Default = false,
            Callback = function(arg1)
                flag6 = arg1
                func33()
            end,
        }
    ):AddColorPicker(
        "ArmHighlightTop",
        {
            Default = Color3.fromRGB(255, 255, 255), Title = "arm top",
            Callback = function(arg1)
                v21 = arg1
            end,
        }
    ):AddColorPicker(
        "ArmHighlightBottom",
        {
            Default = Color3.fromRGB(200, 200, 255), Title = "arm bottom",
            Callback = function(arg1)
                v22 = arg1
            end,
        }
    )
    local v34 = v4:AddDependencyBox()
    v34:AddDropdown(
        "ArmHighlightMaterial",
        {
            Text = "Arm Highlight Material", Default = "Neon", Values = tbl11,
            Callback = function(arg1)
                Neon1 = Enum.Material[arg1]
            end,
        }
    )
    v34:AddSlider(
        "ArmHighlightFillTransparency",
        {
            Text = "Arm Highlight Fill Transparency", Default = num8, Min = 0, Max = 1,
            Rounding = 2, Compact = true,
            Callback = function(arg1)
                num8 = arg1
            end,
        }
    )
    v34:AddSlider(
        "ArmHighlightOutlineTransparency",
        {
            Text = "Arm Highlight Outline Transparency", Default = num9, Min = 0, Max = 1,
            Rounding = 2, Compact = true,
            Callback = function(arg1)
                num9 = arg1
            end,
        }
    )
    v34:SetupDependencies({{v33, true}})
    v4:AddToggle(
        "DisableArms",
        {
            Text = "Disable Arms", Default = false,
            Callback = function(arg1)
                flag2 = arg1
                func33()
            end,
        }
    )
    local v35 = _raw:AddLeftGroupbox("bullet tracers")
    local flag12 = false
    local v36 = Color3.fromRGB(255, 255, 255)
    local num16 = 3
    local num17 = 1
    local num18 = 0.5
    local num19 = 0
    local str = "Line"
    local tbl12 = {}
    local v40
    local flag13 = false
    local tbl13 = {}
    local tbl14 = {
        Line = "", Beam = "rbxassetid://12781852245", Lightning = "rbxassetid://446111271",
        Heartrate = "rbxassetid://5830549480", Chain = "rbxassetid://9632168658",
        Glitch = "rbxassetid://8089467613", Swirl = "rbxassetid://5638168605",
        Neon = "rbxassetid://6361963422", Plasma = "rbxassetid://8993645509",
        Laser = "rbxassetid://14549123968",
    }
    local function func46()
        local ViewModels = workspace:FindFirstChild("ViewModels")
        if not ViewModels then
            return nil
        end
        local FirstPerson = ViewModels:FindFirstChild("FirstPerson")
        if not FirstPerson then
            return nil
        end
        local Name = LocalPlayer.Name
        for _, v1 in ipairs(FirstPerson:GetChildren()) do
            if v1:IsA("Model") and v1.Name:find("^" .. Name) then
                local ItemVisual = v1:FindFirstChild("ItemVisual")
                if ItemVisual then
                    local Body = ItemVisual:FindFirstChild("Body")
                    if Body then
                        local BodyPrimary = Body:FindFirstChild("BodyPrimary")
                        if BodyPrimary then
                            local _muzzle = BodyPrimary:FindFirstChild("_muzzle")
                            if _muzzle and _muzzle:IsA("Attachment") then
                                return _muzzle.WorldPosition
                            end
                        end
                    end
                end
            end
        end
        if type(findShotMuzzlePosition) == "function" then
            return findShotMuzzlePosition()
        end
        return nil
    end
    local function func47(arg1, arg2)
        if num19 <= 0 then
            return arg1.EndPos
        end
        local v1 = math.max(num19 * 0.25, 0.001)
        local v2 = math.clamp(arg2 / v1, 0, 1)
        return arg1.StartPos:Lerp(arg1.EndPos, v2)
    end
    local function func48(arg1, arg2)
        local drawing = Drawing.new("Line")
        drawing.Thickness = 4 * num17
        drawing.Color = Color3.new(0, 0, 0)
        drawing.Transparency = 1
        drawing.Visible = false
        local drawing1 = Drawing.new("Line")
        drawing1.Thickness = 2 * num17
        drawing1.Color = v36
        drawing1.Transparency = 1
        drawing1.Visible = false
        table.insert(
            tbl12,
            {
                IsLine = true, Outline = drawing, Line = drawing1, StartPos = arg1, EndPos = arg2,
                Lifetime = num16, FadeTime = num18, CreatedTime = tick(),
            }
        )
    end
    local function func49(arg1, arg2)
        local attachment = Instance.new("Attachment")
        attachment.Parent = workspace.Terrain
        local attachment1 = Instance.new("Attachment")
        attachment1.Parent = workspace.Terrain
        local beam = Instance.new("Beam")
        beam.Attachment0 = attachment
        beam.Attachment1 = attachment1
        beam.Color = ColorSequence.new(v36)
        local v1 = str == "Laser" and 0.02 or 0.15
        beam.Width0 = v1 * num17
        beam.Width1 = v1 * num17
        beam.Transparency = NumberSequence.new(0)
        beam.FaceCamera = true
        beam.LightEmission = 0.8
        beam.LightInfluence = 0.2
        local v2 = tbl14[str]
        if v2 and v2 ~= "" then
            beam.Texture = v2
            beam.TextureLength = 4
            beam.TextureSpeed = 1
        else
            beam.Texture = ""
            beam.TextureLength = 1
            beam.TextureSpeed = 0
        end
        beam.Parent = workspace.Terrain
        attachment.WorldPosition = arg1
        attachment1.WorldPosition = arg2
        table.insert(
            tbl12,
            {
                IsLine = false, Beam = beam, Attachment0 = attachment, Attachment1 = attachment1,
                StartPos = arg1, EndPos = arg2, Lifetime = num16, FadeTime = num18,
                CreatedTime = tick(),
            }
        )
    end
    local function func50(arg1, arg2)
        if DISABLE_TRACERS or not flag12 or not arg1 or not arg2 then
            return
        end
        local v1 = math.floor(arg1.X * 5 + 0.5)
        local v2 = math.floor(arg1.Y * 5 + 0.5)
        local v3 = math.floor(arg1.Z * 5 + 0.5)
        local v4 = math.floor(arg2.X * 5 + 0.5)
        local v5 = math.floor(arg2.Y * 5 + 0.5)
        local v6 = math.floor(arg2.Z * 5 + 0.5)
        local v7 = v1 * 1000000000 + v2 * 1000000 + v3 * 1000 + v4 + v5 * 0.001 + v6 * 9.9999999999999995e-07
        local v8 = tick()
        local v9 = tbl13[v7]
        if v9 and v8 - v9 < 0.1 then
            return
        end
        tbl13[v7] = v8
        if str == "Line" then
            func48(arg1, arg2)
        else
            func49(arg1, arg2)
        end
    end
    local function func51(arg1)
        if arg1.IsLine then
            if arg1.Outline then
                arg1.Outline:Remove()
            end
            if arg1.Line then
                arg1.Line:Remove()
            end
        else
            if arg1.Beam then
                arg1.Beam:Destroy()
            end
            if arg1.Attachment0 then
                arg1.Attachment0:Destroy()
            end
            if arg1.Attachment1 then
                arg1.Attachment1:Destroy()
            end
        end
    end
    local num20 = 0
    local CurrentCamera = workspace.CurrentCamera
    local function func52()
        if #tbl12 == 0 then
            return
        end
        num20 = num20 + 1
        local v1 = tick()
        local v2 = CurrentCamera or workspace.CurrentCamera
        CurrentCamera = v2
        local Character = LocalPlayer.Character
        local v3 = Character and Character:FindFirstChild("HumanoidRootPart") and Character.HumanoidRootPart.Position
        if num20 % 120 == 0 then
            for k, v4 in next, tbl13, nil do
                if v1 - v4 > 1 then
                    tbl13[k] = nil
                end
            end
        end
        local v5 = #tbl12
        while v5 >= 1 do
            local v6 = tbl12[v5]
            local v7 = v1 - v6.CreatedTime
            if v7 >= v6.Lifetime then
                func51(v6)
                tbl12[v5] = tbl12[#tbl12]
                tbl12[#tbl12] = nil
            else
                local v8 = v6.Lifetime - v6.FadeTime
                local v9
                if v7 >= v8 then
                    v9 = 1 - math.clamp((v7 - v8) / v6.FadeTime, 0, 1)
                else
                    v9 = 1
                end
                if v6.IsLine then
                    local flag = false
                    local v10 = func47(v6, v7)
                    local v11 = v2 and v2.CFrame.Position
                    if v11 and (v6.StartPos - v11).Magnitude <= 12 or not v3 or (v6.StartPos - v3).Magnitude > 2 then
                        local v12, v13 = InstanceWorldToScreen(v6.StartPos, v2)
                        local v14, v15 = InstanceWorldToScreen(v10, v2)
                        if v13 and v15 then
                            local X = v12.X
                            local Y = v12.Y
                            local X1 = v14.X
                            local Y1 = v14.Y
                            if X == X and Y == Y and X1 == X1 and Y1 == Y1 and math.abs(X) < 20000 and math.abs(
                                Y
                            ) < 20000 and math.abs(X1) < 20000 and math.abs(Y1) < 20000 then
                                local v16 = X1 - X
                                local v17 = Y1 - Y
                                local v18 = math.sqrt(v16 * v16 + v17 * v17)
                                if v18 > 0.1 and v18 < 3000 then
                                    local vector2 = Vector2.new(X, Y)
                                    local vector21 = Vector2.new(X1, Y1)
                                    v6.Outline.From = vector2
                                    v6.Outline.To = vector21
                                    v6.Outline.Transparency = v9
                                    v6.Outline.Visible = true
                                    v6.Line.From = vector2
                                    v6.Line.To = vector21
                                    v6.Line.Transparency = v9
                                    v6.Line.Visible = true
                                    flag = true
                                end
                            end
                        end
                    end
                    if not flag then
                        v6.Outline.Visible = false
                        v6.Line.Visible = false
                    end
                else
                    local v19 = func47(v6, v7)
                    if v6.Attachment0 then
                        v6.Attachment0.WorldPosition = v6.StartPos
                    end
                    if v6.Attachment1 then
                        v6.Attachment1.WorldPosition = v19
                    end
                    v6.Beam.Transparency = NumberSequence.new(1 - v9)
                end
            end
            v5 = v5 - 1
        end
    end
    local function func53()
        if flag13 then
            return
        end
        pcall(
            function()
                local TracerEffect = require(LocalPlayer.PlayerScripts.Modules.TracerEffect)
                local Play = TracerEffect.Play
                TracerEffect.Play = function(arg1, arg2, arg3, arg4)
                    if flag12 and arg2 and arg2.IsLocal and arg2.RaycastResults then
                        local v1 = func46()
                        if v1 then
                            for _, v2 in ipairs(arg2.RaycastResults) do
                                if v2.Position then
                                    func50(v1, v2.Position)
                                end
                            end
                        end
                    end
                    return Play(arg1, arg2, arg3, arg4)
                end
                flag13 = true
            end
        )
    end
    local function func54()
        if DISABLE_TRACERS then
            flag12 = false
            return
        end
        if not flag12 then
            return
        end
        func53()
        v40 = v40 or game:GetService("RunService").RenderStepped:Connect(func52)
    end
    local function func55()
        if v40 then
            v40:Disconnect()
            v40 = nil
        end
        for _, v1 in ipairs(tbl12) do
            func51(v1)
        end
        tbl12 = {}
    end
    v35:AddToggle(
        "TracerEnabled",
        {
            Text = "enable", Default = false,
            Callback = function(arg1)
                flag12 = arg1
                if arg1 then
                    func54()
                else
                    func55()
                end
            end,
        }
    ):AddColorPicker(
        "TracerColor",
        {
            Default = Color3.fromRGB(255, 255, 255), Title = "tracer color",
            Callback = function(arg1)
                v36 = arg1
                for _, v1 in ipairs(tbl12) do
                    if v1.IsLine then
                        if v1.Line then
                            v1.Line.Color = arg1
                        end
                    elseif v1.Beam then
                        v1.Beam.Color = ColorSequence.new(arg1)
                    end
                end
            end,
        }
    )
    v35:AddDropdown(
        "TracerStyle",
        {
            Text = "style", Default = "Line",
            Values = {
                "Line", "Beam", "Lightning", "Heartrate", "Chain", "Glitch", "Swirl", "Neon",
                "Plasma", "Laser"
            },
            Callback = function(arg1)
                str = arg1
            end,
        }
    )
    v35:AddSlider(
        "TracerDuration",
        {
            Text = "duration", Default = 3, Min = 0.1, Max = 10, Rounding = 1, Compact = true,
            Callback = function(arg1)
                num16 = arg1
                for _, v1 in ipairs(tbl12) do
                    v1.Lifetime = arg1
                end
            end,
        }
    )
    v35:AddSlider(
        "TracerSize",
        {
            Text = "size", Default = 1, Min = 0.5, Max = 5, Rounding = 1, Compact = true,
            Callback = function(arg1)
                num17 = arg1
                for _, v1 in ipairs(tbl12) do
                    if v1.IsLine then
                        if v1.Outline then
                            v1.Outline.Thickness = 4 * arg1
                        end
                        if v1.Line then
                            v1.Line.Thickness = 2 * arg1
                        end
                    elseif v1.Beam then
                        local v2 = str == "Laser" and 0.02 or 0.15
                        v1.Beam.Width0 = v2 * arg1
                        v1.Beam.Width1 = v2 * arg1
                    end
                end
            end,
        }
    )
    v35:AddSlider(
        "TracerFade",
        {
            Text = "fade time", Default = 0.5, Min = 0, Max = 2, Rounding = 1, Compact = true,
            Callback = function(arg1)
                num18 = arg1
                for _, v1 in ipairs(tbl12) do
                    v1.FadeTime = arg1
                end
            end,
        }
    )
    v35:AddSlider(
        "TracerLerpSpeed",
        {
            Text = "lerp speed", Default = 0, Min = 0, Max = 5, Rounding = 1, Compact = true,
            Callback = function(arg1)
                num19 = arg1
            end,
        }
    )
    task.defer(
        function()
            if not DISABLE_TRACERS then
                func53()
            end
            for _ = 1, 30 do
                if flag13 then
                    break
                end
                func53()
                task.wait(0.5)
            end
        end
    )
end)()
local v25 = v3:AddTab("Config")
local _raw = v25._raw;
(function()
    local v2, v3 = pcall(
        function()
            return loadstring(
                game:HttpGet(
                    "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/addons/ThemeManager.lua"
                )
            )()
        end
    )
    local v4, v5 = pcall(
        function()
            return loadstring(
                game:HttpGet(
                    "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/addons/SaveManager.lua"
                )
            )()
        end
    )
    pcall(
        function()
            local v2 = _raw:AddLeftGroupbox("Menu")
            v2:AddLabel("Menu bind"):AddKeyPicker(
                "MenuKeybind", {Default = "RightControl", NoUI = true, Text = "Menu keybind"}
            )
            Library.ToggleKeybind = Library.Options.MenuKeybind
            v2:AddButton(
                "Unload",
                function()
                    pcall(
                        function()
                            Library:Unload()
                        end
                    )
                end
            )
        end
    )
    if v2 and type(v3) == "table" then
        pcall(
            function()
                v3:SetLibrary(Library)
                v3:SetFolder("VroyHub")
                v3.BuiltInThemes["V.Roy"] = {
                    9,
                    {
                        FontColor = "ffffff", MainColor = "101010", AccentColor = "ffffff",
                        BackgroundColor = "000000", OutlineColor = "808080",
                    },
                }
                v3.BuiltInThemes.Default = {
                    1,
                    {
                        FontColor = "ffffff", MainColor = "101010", AccentColor = "ffffff",
                        BackgroundColor = "000000", OutlineColor = "808080",
                    },
                }
                if writefile and isfile then
                    local v2
                    pcall(
                        function()
                            if isfile("VroyHub/themes/default.txt") then
                                v2 = readfile("VroyHub/themes/default.txt")
                            end
                        end
                    )
                    if v2 == nil or v2 == "" then
                        writefile("VroyHub/themes/default.txt", "V.Roy")
                    end
                end
                v3:ApplyToTab(_raw)
            end
        )
    end
    if v4 and type(v5) == "table" then
        pcall(
            function()
                v5:SetLibrary(Library)
                v5:IgnoreThemeSettings()
                v5:SetIgnoreIndexes({"MenuKeybind"})
                v5:SetFolder("VroyHub/Rivals")
                v5:BuildConfigSection(_raw)
                v5:LoadAutoloadConfig()
            end
        )
    else
        pcall(
            function()
                v25:AddSection("Configs"):AddLabel("SaveManager no cargo (revisa red/executor).")
            end
        )
    end
    local v6 = pcall
    v6(
        function()
            Library.BackgroundColor = Color3.fromRGB(0, 0, 0)
            Library.MainColor = Color3.fromRGB(16, 16, 16)
            Library.AccentColor = Color3.fromRGB(255, 255, 255)
            Library.OutlineColor = Color3.fromRGB(128, 128, 128)
            Library.FontColor = Color3.fromRGB(255, 255, 255)
            if type(Library.GetDarkerColor) == "function" then
                Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor)
            end
            if type(Library.UpdateColorsUsingRegistry) == "function" then
                Library:UpdateColorsUsingRegistry()
            end
        end
    )
    v6(
        function()
            local Options = Library.Options
            if type(Options) ~= "table" then
                return
            end
            local tbl = {
                BackgroundColor = Color3.fromRGB(0, 0, 0), MainColor = Color3.fromRGB(16, 16, 16),
                AccentColor = Color3.fromRGB(255, 255, 255),
                OutlineColor = Color3.fromRGB(128, 128, 128),
                FontColor = Color3.fromRGB(255, 255, 255),
            }
            for k, v2 in pairs(tbl) do
                pcall(
                    function()
                        if Options[k] and type(Options[k].SetValueRGB) == "function" then
                            Options[k]:SetValueRGB(v2)
                        end
                    end
                )
            end
        end
    )
    v6(
        function()
            if not (v2 and type(v3) == "table") then
                return
            end
            local v4
            if isfile then
                pcall(
                    function()
                        if isfile("VroyHub/themes/default.txt") then
                            v4 = readfile("VroyHub/themes/default.txt")
                        end
                    end
                )
            end
            if v4 ~= nil and v4 ~= "" and v4 ~= "V.Roy" then
                return
            end
            v3:ApplyTheme("V.Roy")
            if Library.Options and Library.Options.ThemeManager_ThemeList then
                Library.Options.ThemeManager_ThemeList:SetValue("V.Roy")
            end
        end
    )
    task.delay(
        2,
        function()
            pcall(
                function()
                    Library.BackgroundColor = Color3.fromRGB(0, 0, 0)
                    Library.MainColor = Color3.fromRGB(16, 16, 16)
                    Library.AccentColor = Color3.fromRGB(255, 255, 255)
                    Library.OutlineColor = Color3.fromRGB(128, 128, 128)
                    Library.FontColor = Color3.fromRGB(255, 255, 255)
                    if type(Library.GetDarkerColor) == "function" then
                        Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor)
                    end
                    local Options = Library.Options
                    if type(Options) == "table" then
                        for k, v2 in pairs(
                            {
                                BackgroundColor = Library.BackgroundColor, MainColor = Library.MainColor,
                                AccentColor = Library.AccentColor, OutlineColor = Library.OutlineColor,
                                FontColor = Library.FontColor,
                            }
                        ) do
                            pcall(
                                function()
                                    if Options[k] and type(Options[k].SetValueRGB) == "function" then
                                        Options[k]:SetValueRGB(v2)
                                    end
                                end
                            )
                        end
                    end
                    if type(Library.UpdateColorsUsingRegistry) == "function" then
                        Library:UpdateColorsUsingRegistry()
                    end
                end
            )
        end
    )
end)()
local v26 = v3:AddTab("Info")
local v27 = v26:AddSection("V.Roy Hub")
v27:AddLabel({Text = "Full script + HVH modes", Color = INFO_TEXT, Size = 13})
v27:AddLabel({Text = "Version 2 - Author: V.Roy", Color = INFO_MUTED, Size = 12})
local v28 = v26:AddSection("Discord")
v28:AddLabel({Text = "Join to get new scripts:", Color = INFO_MUTED, Size = 12})
v28:AddLabel({Text = DISCORD_INVITE, Color = INFO_ACCENT, Size = 13})
v28:AddButton(
    {
        Name = "Copy Invite",
        Callback = function(arg1)
            if not copyToClipboard(DISCORD_INVITE) then
                VroyUI:Notify(
                    {Title = "Couldn't copy.", Text = "Copy the link manually.", Type = "error"}
                )
                return
            end
            arg1:SetText("Copied!")
            VroyUI:Notify({Title = "Copied", Text = "Discord invite copied.", Type = "success"})
            task.delay(
                2,
                function()
                    if arg1 and arg1.Control then
                        arg1:SetText("Copy Invite")
                    end
                end
            )
        end,
    }
)
pcall(
    function()
        if type(getgenv) == "function" then
            local v1 = getgenv()
            if type(v1) == "table" then
                v1.VroySolixBuilt = true
                if type(v1.VroySolixWin) == "table" then
                    local VroySolixWin = v1.VroySolixWin
                    if VroySolixWin.Items and VroySolixWin.Items.MainFrame then
                        VroySolixWin.Items.MainFrame.Instance.Visible = true
                    end
                    VroySolixWin.IsOpen = true
                end
            end
        end
    end
)

-- https://discord.gg/hkQAMzyGum

