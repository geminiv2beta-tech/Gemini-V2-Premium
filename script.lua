-- ============================================================================
--   [ vallkmult free v1 - Medium Obfuscated Protection Layer ]
-- ============================================================================
local _S_DAT = {
    [1] = string.char(107, 105, 99, 105, 97, 104, 111, 111, 107, 47, 114, 105, 118, 97, 108, 115, 47),
    [2] = string.char(99, 111, 115, 109, 101, 116, 105, 99, 115),
    [3] = string.char(99, 111, 110, 102, 105, 103, 115),
    [4] = string.char(118, 97, 108, 108, 107, 109, 117, 108, 116, 32, 102, 114, 101, 101, 32, 118, 49),
    [5] = string.char(80, 108, 97, 121, 101, 114, 115),
    [6] = string.char(82, 117, 110, 83, 101, 114, 118, 105, 99, 101),
    [7] = string.char(85, 115, 101, 114, 73, 110, 112, 117, 116, 83, 101, 114, 118, 105, 99, 101),
    [8] = string.char(67, 111, 114, 101, 71, 117, 105),
    [9] = string.char(72, 116, 116, 112, 83, 101, 114, 118, 105, 99, 101),
    [10] = string.char(82, 101, 112, 108, 105, 99, 97, 116, 101, 100, 83, 116, 111, 114, 97, 103, 101),
    [11] = string.char(87, 111, 114, 107, 115, 112, 97, 99, 101),
    [12] = string.char(72, 101, 97, 100),
    [13] = string.char(72, 117, 109, 97, 110, 111, 105, 100, 82, 111, 111, 116, 80, 97, 114, 116),
    [14] = string.char(84, 111, 114, 115, 111)
}

local function _DECODE(tbl)
    local _r = ""
    for i = 1, #tbl do
        _r = _r .. string.char(tbl[i])
    end
    return _r
end

local _HOME_DIR = _S_DAT[1]
if makefolder then
    pcall(makefolder, _HOME_DIR)
    pcall(makefolder, _HOME_DIR .. _S_DAT[2])
    pcall(makefolder, _HOME_DIR .. _S_DAT[3])
end

do
    repeat task.wait() until game:IsLoaded()

    local function _SAFE_REF(_ref)
        return cloneref and cloneref(_ref) or _ref
    end

    local _SET_IDENTITY = setthreadcontext or setthreadidentity or set_thread_identity or set_thread_context or setidentity

    local _Players = _SAFE_REF(game:GetService(_S_DAT[5]))
    local _RunService = _SAFE_REF(game:GetService(_S_DAT[6]))
    local _UserInputService = _SAFE_REF(game:GetService(_S_DAT[7]))
    local _CoreGui = _SAFE_REF(game:GetService(_S_DAT[8]))
    local _HttpService = _SAFE_REF(game:GetService(_S_DAT[9]))
    local _ReplicatedStorage = _SAFE_REF(game:GetService(_S_DAT[10]))
    local _Workspace = _SAFE_REF(game:GetService(_S_DAT[11]))
    local _Camera = _Workspace.CurrentCamera
    local _LocalPlayer = _Players.LocalPlayer

    -- 기존 UI 및 HUD 중복 제거 보호막
    local _OLD_NAMES = {
        _S_DAT[4],
        "mult up free v1",
        "MuteUpGUI",
        "RagebotStatusHUD",
        "RagebotdkCenterHUD",
        "zero up 나다 free v1",
        "LuminousPureHub",
        "HoNyang💩FOV",
        "HalmuESP",
        "multvallkRageUI",
        "ExecutorToggleUI"
    }
    for _, _name in ipairs(_OLD_NAMES) do
        local _oldGui = _CoreGui:FindFirstChild(_name) or _LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(_name)
        if _oldGui then _oldGui:Destroy() end
    end

    --------------------------------------------------------------------
    -- [ HIGH PERFORMANCE ANTI-CHEAT BYPASS SYSTEM ]
    --------------------------------------------------------------------
    pcall(function()
        if _LocalPlayer and typeof(_LocalPlayer.Kick) == "function" then
            local _oldKick = _LocalPlayer.Kick
            _LocalPlayer.Kick = function(...) end
            pcall(function()
                if hookfunction then
                    hookfunction(_oldKick, newcclosure(function(...) end))
                end
            end)
        end

        pcall(function()
            if typeof(_Players.Kick) == "function" then
                _Players.Kick = function(...) end
            end
        end)

        if hookmetamethod and getnamecallmethod then
            local _bannedRemotes = {
                kick=true, ban=true, punish=true, anticheat=true, detect=true,
                report=true, flag=true, crash=true, log=true, screenshot=true,
                security=true, mod=true, admin=true, watchdog=true, sentinel=true,
            }
            local _oldNamecall
            _oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local _method = getnamecallmethod()
                if _method == "Kick" or _method == "kick" then
                    return
                end

                if (_method == "FireServer" or _method == "InvokeServer") and self then
                    local _sName = ""
                    pcall(function() _sName = string.lower(tostring(self.Name or "")) end)
                    for _k, _ in pairs(_bannedRemotes) do
                        if _sName ~= "" and string.find(_sName, _k, 1, true) then
                            return
                        end
                    end
                end
                return _oldNamecall(self, ...)
            end))
        end
    end)

    --------------------------------------------------------------------
    -- [ CONFIGURATION & SETTINGS ]
    --------------------------------------------------------------------
    getgenv().MultConfig = {
        RageEnabled = true,
        FireRate = 0.0005,
        RageVersion = "vallkmult_premium_v6",
        AimbotEnabled = false,
        AimbotHitPart = _S_DAT[12],
        AimbotDrawFOV = false,
        AimbotFOVSize = 120,
        AimbotWallCheck = false,
        SilentEnabled = false,
        SilentHitPart = _S_DAT[12],
        SilentDrawFOV = false,
        SilentFOVSize = 150,
        SilentWallCheck = false,
        SilentScopeLook = false,
        TriggerbotEnabled = false,
        EspEnabled = false,
        BoxEsp = false,
        NameEsp = false,
        HealthEsp = false,
        DeviceSpooferEnabled = false,
        SpoofedDeviceMode = "MouseKeyboard"
    }

    --------------------------------------------------------------------
    -- [ 화면 중앙 HUD ]
    --------------------------------------------------------------------
    local _centerHudGui = Instance.new("ScreenGui")
    _centerHudGui.Name = _S_DAT[4] .. "_HUD"
    _centerHudGui.ResetOnSpawn = false
    _centerHudGui.IgnoreGuiInset = true
    _centerHudGui.DisplayOrder = 100001
    if _SET_IDENTITY then _SET_IDENTITY(8) end
    _centerHudGui.Parent = _CoreGui

    local _centerLabel = Instance.new("TextLabel")
    _centerLabel.Name = "StatusLabel"
    _centerLabel.Size = UDim2.new(0, 320, 0, 32)
    _centerLabel.Position = UDim2.new(0.5, 0, 0.5, 60)
    _centerLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    _centerLabel.Font = Enum.Font.Code
    _centerLabel.TextSize = 14
    _centerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    _centerLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    _centerLabel.BorderColor3 = Color3.fromRGB(55, 175, 225)
    _centerLabel.BorderSizePixel = 1
    _centerLabel.Text = _S_DAT[4] .. " [Active]"
    _centerLabel.Parent = _centerHudGui

    local _centerCorner = Instance.new("UICorner")
    _centerCorner.CornerRadius = UDim.new(0, 4)
    _centerCorner.Parent = _centerLabel

    --------------------------------------------------------------------
    -- [ Kiciahook UI Framework Engine (Obfuscated Layers) ]
    --------------------------------------------------------------------
    local _UISection = {}
    _UISection.__index = _UISection
    function _UISection.new(parentContainer, side, label)
        local self = setmetatable({}, _UISection)
        self.instances = {}

        local container = Instance.new("Frame")
        container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        container.BorderColor3 = Color3.fromRGB(50, 50, 50)
        container.Size = UDim2.new(1, -2, 0, 22)
        self.instances.container = container

        local inline = Instance.new("Frame")
        inline.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        inline.BorderSizePixel = 0
        inline.Position = UDim2.new(0, 1, 0, 1)
        inline.Size = UDim2.new(1, -2, 1, -2)
        inline.Parent = container

        local theme = Instance.new("Frame")
        theme.BackgroundColor3 = Color3.fromRGB(55, 175, 225)
        theme.BorderSizePixel = 0
        theme.Size = UDim2.new(1, 0, 0, 2)
        theme.Parent = inline

        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Arial
        lbl.TextSize = 12
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Position = UDim2.new(0, 4, 0, 5)
        lbl.Size = UDim2.new(1, -8, 0, 11)
        lbl.Text = label or "Section"
        lbl.Parent = inline
        self.instances.label = lbl

        local canvas = Instance.new("Frame")
        canvas.Position = UDim2.new(0, 0, 1, 0)
        canvas.Size = UDim2.new(1, 0, 1, -20)
        canvas.AnchorPoint = Vector2.new(0, 1)
        canvas.BackgroundTransparency = 1
        canvas.Parent = inline
        self.instances.canvas = canvas

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 4)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = canvas

        container.Parent = parentContainer[side]
        return self
    end

    local _UIBase = {}
    _UIBase.__index = _UIBase
    function _UIBase.new()
        local self = setmetatable({}, _UIBase)
        self.instances = {}
        self.visible = true
        self.tabs = {}
        self.tabButtons = {}
        self.currentTab = nil

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = _S_DAT[4]
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.DisplayOrder = 99999
        self.instances.gui = screenGui

        local container = Instance.new("Frame")
        container.Name = "MainContainer"
        container.BackgroundColor3 = Color3.fromRGB(55, 175, 225)
        container.BorderSizePixel = 1
        container.BorderColor3 = Color3.fromRGB(0, 0, 0)
        container.AnchorPoint = Vector2.new(0.5, 0.5)
        container.Position = UDim2.new(0.5, 0, 0.5, 0)
        container.Size = UDim2.new(0, 540, 0, 440)
        container.Parent = screenGui
        self.instances.container = container

        local uiScale = Instance.new("UIScale")
        uiScale.Scale = 1.0
        uiScale.Parent = container
        self.instances.uiScale = uiScale

        local background = Instance.new("Frame")
        background.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        background.Position = UDim2.new(0, 1, 0, 1)
        background.Size = UDim2.new(1, -2, 1, -2)
        background.BorderSizePixel = 0
        background.Parent = container

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -8, 0, 15)
        title.Position = UDim2.new(0, 6, 0, 4)
        title.Font = Enum.Font.ArialBold
        title.TextSize = 12
        title.BackgroundTransparency = 1
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Text = _S_DAT[4] .. " - Ultimate Combat Hub"
        title.Parent = background

        local tabBar = Instance.new("Frame")
        tabBar.Name = "TabBar"
        tabBar.BackgroundTransparency = 1
        tabBar.Position = UDim2.new(0, 5, 0, 22)
        tabBar.Size = UDim2.new(1, -10, 0, 24)
        tabBar.Parent = background

        local tabLayout = Instance.new("UIListLayout")
        tabLayout.FillDirection = Enum.FillDirection.Horizontal
        tabLayout.Padding = UDim.new(0, 3)
        tabLayout.Parent = tabBar

        local contentArea = Instance.new("Frame")
        contentArea.Name = "ContentArea"
        contentArea.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        contentArea.Position = UDim2.new(0, 5, 0, 48)
        contentArea.Size = UDim2.new(1, -10, 1, -54)
        contentArea.BorderColor3 = Color3.fromRGB(50, 50, 50)
        contentArea.Parent = background
        self.instances.contentArea = contentArea

        local drag = Instance.new("TextButton")
        drag.BackgroundTransparency = 1
        drag.Text = ""
        drag.Size = UDim2.new(1, -80, 0, 20)
        drag.Parent = container

        local openBtn = Instance.new("TextButton")
        openBtn.Name = "OpenButton"
        openBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        openBtn.BorderColor3 = Color3.fromRGB(55, 175, 225)
        openBtn.AnchorPoint = Vector2.new(0, 0.5)
        openBtn.Position = UDim2.new(0, 12, 0.5, 0)
        openBtn.Size = UDim2.new(0, 78, 0, 32)
        openBtn.Font = Enum.Font.Arial
        openBtn.TextSize = 12
        openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        openBtn.Text = "Menu [Close]"
        openBtn.Parent = screenGui
        openBtn.ZIndex = 100

        local openCorner = Instance.new("UICorner")
        openCorner.CornerRadius = UDim.new(0, 4)
        openCorner.Parent = openBtn

        openBtn.MouseButton1Click:Connect(function()
            self.visible = not self.visible
            container.Visible = self.visible
            openBtn.Text = self.visible and "Menu [Close]" or "Menu [Open]"
        end)

        local dragging, dragStart, startPos
        drag.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = container.Position
            end
        end)

        _UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)

        return self
    end

    function _UIBase:AddTab(name)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = name .. "TabBtn"
        tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        tabBtn.BorderColor3 = Color3.fromRGB(60, 60, 60)
        tabBtn.Size = UDim2.new(0, 80, 1, 0)
        tabBtn.Font = Enum.Font.ArialBold
        tabBtn.TextSize = 11
        tabBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
        tabBtn.Text = name
        tabBtn.Parent = self.instances.contentArea.Parent:FindFirstChild("TabBar")

        local tabHolder = Instance.new("Frame")
        tabHolder.Name = name .. "Holder"
        tabHolder.BackgroundTransparency = 1
        tabHolder.Position = UDim2.new(0, 1, 0, 1)
        tabHolder.Size = UDim2.new(1, -2, 1, -2)
        tabHolder.Visible = false
        tabHolder.Parent = self.instances.contentArea

        local leftCanvas = Instance.new("ScrollingFrame")
        leftCanvas.BackgroundTransparency = 1
        leftCanvas.Position = UDim2.new(0, 5, 0, 5)
        leftCanvas.AutomaticCanvasSize = Enum.AutomaticSize.Y
        leftCanvas.Size = UDim2.new(0.5, -8, 1, -10)
        leftCanvas.BorderSizePixel = 0
        leftCanvas.CanvasSize = UDim2.new(0, 0)
        leftCanvas.ScrollBarThickness = 1
        leftCanvas.Parent = tabHolder

        local uiLayoutL = Instance.new("UIListLayout")
        uiLayoutL.Padding = UDim.new(0, 7)
        uiLayoutL.Parent = leftCanvas

        local rightCanvas = Instance.new("ScrollingFrame")
        rightCanvas.BackgroundTransparency = 1
        rightCanvas.Position = UDim2.new(0.5, 3, 0, 5)
        rightCanvas.AutomaticCanvasSize = Enum.AutomaticSize.Y
        rightCanvas.Size = UDim2.new(0.5, -8, 1, -10)
        rightCanvas.BorderSizePixel = 0
        rightCanvas.CanvasSize = UDim2.new(0, 0)
        rightCanvas.ScrollBarThickness = 1
        rightCanvas.Parent = tabHolder

        local uiLayoutR = Instance.new("UIListLayout")
        uiLayoutR.Padding = UDim.new(0, 7)
        uiLayoutR.Parent = rightCanvas

        local holderObj = { left = leftCanvas, right = rightCanvas }
        self.tabs[name] = holderObj

        tabBtn.MouseButton1Click:Connect(function()
            for tName, h in pairs(self.tabs) do
                local btn = self.tabButtons[tName]
                local isTarget = (tName == name)
                h.left.Parent.Visible = isTarget
                if btn then
                    btn.TextColor3 = isTarget and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 170, 170)
                    btn.BackgroundColor3 = isTarget and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(25, 25, 25)
                    btn.BorderColor3 = isTarget and Color3.fromRGB(55, 175, 225) or Color3.fromRGB(60, 60, 60)
                end
            end
        end)

        self.tabButtons[name] = tabBtn

        if not self.currentTab then
            self.currentTab = name
            tabHolder.Visible = true
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            tabBtn.BorderColor3 = Color3.fromRGB(55, 175, 225)
        end

        return holderObj
    end

    function _UIBase:Finish()
        if _SET_IDENTITY then _SET_IDENTITY(8) end
        self.instances.gui.Parent = _CoreGui
    end

    --------------------------------------------------------------------
    -- [ UI COMPONENTS (Toggle, Slider, Dropdown) ]
    --------------------------------------------------------------------
    local _UIToggle = {}
    _UIToggle.__index = _UIToggle
    function _UIToggle.new(section, flag, labelText, defaultVal, callback)
        local self = setmetatable({}, _UIToggle)
        self.value = defaultVal or false
        self.callback = callback or function() end

        section.instances.container.Size = section.instances.container.Size + UDim2.new(0, 0, 0, 20)

        local btn = Instance.new("TextButton")
        btn.BackgroundTransparency = 1
        btn.Size = UDim2.new(1, 0, 0, 18)
        btn.Text = ""
        btn.Parent = section.instances.canvas

        local box = Instance.new("Frame")
        box.BorderColor3 = Color3.fromRGB(0, 0, 0)
        box.BackgroundColor3 = self.value and Color3.fromRGB(55, 175, 225) or Color3.fromRGB(35, 35, 35)
        box.Size = UDim2.new(0, 12, 0, 12)
        box.Position = UDim2.new(0, 4, 0.5, 0)
        box.AnchorPoint = Vector2.new(0, 0.5)
        box.Parent = btn

        local lbl = Instance.new("TextLabel")
        lbl.Font = Enum.Font.Arial
        lbl.TextSize = 12
        lbl.Position = UDim2.new(0, 22, 0.5, 0)
        lbl.AnchorPoint = Vector2.new(0, 0.5)
        lbl.Size = UDim2.new(1, -25, 0, 12)
        lbl.Text = labelText or flag
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = btn

        btn.MouseButton1Click:Connect(function()
            self.value = not self.value
            box.BackgroundColor3 = self.value and Color3.fromRGB(55, 175, 225) or Color3.fromRGB(35, 35, 35)
            self.callback(self.value)
        end)

        return self
    end

    local _UISlider = {}
    _UISlider.__index = _UISlider
    function _UISlider.new(section, flag, labelText, min, max, defaultVal, callback)
        local self = setmetatable({}, _UISlider)
        self.min = min or 0
        self.max = max or 100
        self.value = defaultVal or min
        self.callback = callback or function() end

        section.instances.container.Size = section.instances.container.Size + UDim2.new(0, 0, 0, 28)

        local container = Instance.new("Frame")
        container.BackgroundTransparency = 1
        container.Size = UDim2.new(1, 0, 0, 26)
        container.Parent = section.instances.canvas

        local lbl = Instance.new("TextLabel")
        lbl.Font = Enum.Font.Arial
        lbl.TextSize = 12
        lbl.Position = UDim2.new(0, 4, 0, 1)
        lbl.Size = UDim2.new(1, -8, 0, 11)
        lbl.Text = string.format("%s: %s", labelText or flag, tostring(self.value))
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = container

        local track = Instance.new("TextButton")
        track.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        track.BorderColor3 = Color3.fromRGB(0, 0, 0)
        track.Size = UDim2.new(1, -8, 0, 8)
        track.Position = UDim2.new(0, 4, 0, 15)
        track.Text = ""
        track.AutoButtonColor = false
        track.Parent = container

        local fill = Instance.new("Frame")
        fill.BorderSizePixel = 0
        fill.Size = UDim2.new((self.value - self.min)/(self.max - self.min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(55, 175, 225)
        fill.Parent = track

        local function update(input)
            local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            self.value = math.floor((self.min + (self.max - self.min) * pct) * 10000) / 10000
            fill.Size = UDim2.new(pct, 0, 1, 0)
            lbl.Text = string.format("%s: %s", labelText or flag, tostring(self.value))
            self.callback(self.value)
        end

        local sliding = false
        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = true
                update(input)
            end
        end)
        _UserInputService.InputChanged:Connect(function(input)
            if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)
        _UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = false
            end
        end)

        return self
    end

    local _UIDropdown = {}
    _UIDropdown.__index = _UIDropdown
    function _UIDropdown.new(section, flag, labelText, list, defaultVal, callback)
        local self = setmetatable({}, _UIDropdown)
        self.value = defaultVal or list[1]
        self.callback = callback or function() end
        self.open = false

        section.instances.container.Size = section.instances.container.Size + UDim2.new(0, 0, 0, 38)

        local container = Instance.new("Frame")
        container.BackgroundTransparency = 1
        container.Size = UDim2.new(1, 0, 0, 36)
        container.Parent = section.instances.canvas

        local lbl = Instance.new("TextLabel")
        lbl.Font = Enum.Font.Arial
        lbl.TextSize = 12
        lbl.Position = UDim2.new(0, 4, 0, 1)
        lbl.Size = UDim2.new(1, -8, 0, 11)
        lbl.Text = labelText or flag
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = container

        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        btn.BorderColor3 = Color3.fromRGB(0, 0, 0)
        btn.Size = UDim2.new(1, -8, 0, 20)
        btn.Position = UDim2.new(0, 4, 0, 14)
        btn.Font = Enum.Font.Arial
        btn.TextSize = 12
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = tostring(self.value)
        btn.Parent = container

        local dropFrame = Instance.new("Frame")
        dropFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        dropFrame.BorderColor3 = Color3.fromRGB(55, 175, 225)
        dropFrame.Position = UDim2.new(0, 4, 0, 36)
        dropFrame.Size = UDim2.new(1, -8, 0, #list * 20)
        dropFrame.Visible = false
        dropFrame.ZIndex = 10
        dropFrame.Parent = container

        local listLayout = Instance.new("UIListLayout")
        listLayout.Parent = dropFrame

        for _, item in ipairs(list) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            itemBtn.BorderSizePixel = 0
            itemBtn.Size = UDim2.new(1, 0, 0, 20)
            itemBtn.Font = Enum.Font.Arial
            itemBtn.TextSize = 12
            itemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            itemBtn.Text = tostring(item)
            itemBtn.ZIndex = 11
            itemBtn.Parent = dropFrame

            itemBtn.MouseButton1Click:Connect(function()
                self.value = item
                btn.Text = tostring(item)
                dropFrame.Visible = false
                self.open = false
                self.callback(self.value)
            end)
        end

        btn.MouseButton1Click:Connect(function()
            self.open = not self.open
            dropFrame.Visible = self.open
        end)

        return self
    end

    --------------------------------------------------------------------
    -- [ DEVICE SPOOFER ]
    --------------------------------------------------------------------
    getgenv().DeviceSpooferEnabled = getgenv().MultConfig.DeviceSpooferEnabled
    getgenv().SpoofedDeviceMode = getgenv().MultConfig.SpoofedDeviceMode or "MouseKeyboard"

    local function _normalizeDeviceMode(mode)
        if not mode then return "MouseKeyboard" end
        local m = tostring(mode):lower():gsub("%s+", "")
        if m == "vr" then return "VR" end
        if m == "touch" or m == "mobile" then return "Touch" end
        if m == "gamepad" or m == "controller" or m == "console" then return "Gamepad" end
        return "MouseKeyboard"
    end

    local function _getSetControlsRemote()
        local ok, remote = pcall(function()
            local remotes = _ReplicatedStorage:FindFirstChild("Remotes")
            local replication = remotes and remotes:FindFirstChild("Replication")
            local fighter = replication and replication:FindFirstChild("Fighter")
            return fighter and fighter:FindFirstChild("SetControls")
        end)
        return ok and remote or nil
    end

    local function _fireDeviceSetControls(mode)
        mode = _normalizeDeviceMode(mode or getgenv().SpoofedDeviceMode)
        getgenv().SpoofedDeviceMode = mode
        if getgenv().MultConfig then
            getgenv().MultConfig.SpoofedDeviceMode = mode
        end
        local remote = _getSetControlsRemote()
        if not remote then return false end
        pcall(function()
            remote:FireServer(mode)
        end)
        return true
    end

    task.spawn(function()
        while true do
            task.wait(2.5)
            if getgenv().DeviceSpooferEnabled or (getgenv().MultConfig and getgenv().MultConfig.DeviceSpooferEnabled) then
                _fireDeviceSetControls(getgenv().SpoofedDeviceMode)
            end
        end
    end)

    _LocalPlayer.CharacterAdded:Connect(function()
        if getgenv().DeviceSpooferEnabled or (getgenv().MultConfig and getgenv().MultConfig.DeviceSpooferEnabled) then
            task.wait(1)
            _fireDeviceSetControls(getgenv().SpoofedDeviceMode)
        end
    end)

    --------------------------------------------------------------------
    -- [ UI BUILD & TABS ]
    --------------------------------------------------------------------
    local UI = _UIBase.new()

    local mainTab = UI:AddTab("Main")
    local rageTab = UI:AddTab("Ragebot")
    local combatTab = UI:AddTab("Combat")
    local espTab = UI:AddTab("ESP")
    local miscTab = UI:AddTab("Misc")
    local spooferTab = UI:AddTab("Spoofer")

    local mainSec = _UISection.new(mainTab, "left", "General Information")
    _UIToggle.new(mainSec, "WelcomeToggle", "vallkmult free v1 허브 활성화됨", true, function(v) end)

    local rageSec = _UISection.new(rageTab, "left", "Ragebot Settings")
    _UIDropdown.new(rageSec, "RageVersion", "레이지봇 버전 선택", {"vallkmult_premium_v6", "vallkmult_old_rage_bot_v3"}, "vallkmult_premium_v6", function(sel)
        getgenv().MultConfig.RageVersion = sel
    end)
    _UIToggle.new(rageSec, "RagebotToggle", "레이지봇 활성화 (RageBot)", true, function(val)
        getgenv().MultConfig.RageEnabled = val
    end)
    _UISlider.new(rageSec, "FireRateSlider", "발사 속도 (FireRate)", 0.0001, 0.01, 0.0005, function(val)
        getgenv().MultConfig.FireRate = val
    end)

    local aimSec = _UISection.new(combatTab, "left", "Aimbot Settings")
    _UIToggle.new(aimSec, "AimbotToggle", "에임봇 활성화", false, function(v) getgenv().MultConfig.AimbotEnabled = v end)
    _UIDropdown.new(aimSec, "AimPart", "에임봇 타겟 파트", {"Head", "HumanoidRootPart", "Torso"}, "Head", function(v) getgenv().MultConfig.AimbotHitPart = v end)
    _UIToggle.new(aimSec, "AimFOV", "에임봇 FOV 표시 (Draw FOV)", false, function(v) getgenv().MultConfig.AimbotDrawFOV = v end)
    _UIToggle.new(aimSec, "AimWall", "에임봇 벽 체크 (Wallcheck)", false, function(v) getgenv().MultConfig.AimbotWallCheck = v end)

    local silentSec = _UISection.new(combatTab, "right", "Silent Aim Settings")
    _UIToggle.new(silentSec, "SilentToggle", "사일런트 에임 활성화", false, function(v) getgenv().MultConfig.SilentEnabled = v end)
    _UIDropdown.new(silentSec, "SilentPart", "사일런트 타겟 파트", {"Head", "HumanoidRootPart", "Torso"}, "Head", function(v) getgenv().MultConfig.SilentHitPart = v end)
    _UIToggle.new(silentSec, "SilentFOV", "사일런트 FOV 표시 (Draw FOV)", false, function(v) getgenv().MultConfig.SilentDrawFOV = v end)
    _UIToggle.new(silentSec, "SilentWall", "사일런트 벽 체크 (Wallcheck)", false, function(v) getgenv().MultConfig.SilentWallCheck = v end)
    _UIToggle.new(silentSec, "SilentScope", "사일런트 Scope Look", false, function(v) getgenv().MultConfig.SilentScopeLook = v end)

    local trigSec = _UISection.new(combatTab, "right", "Triggerbot")
    _UIToggle.new(trigSec, "TriggerToggle", "트리거봇 활성화 (Triggerbot)", false, function(v) getgenv().MultConfig.TriggerbotEnabled = v end)

    local espSec = _UISection.new(espTab, "left", "ESP Visuals")
    _UIToggle.new(espSec, "EspToggle", "플레이어 시각화 (ESP)", false, function(v) getgenv().MultConfig.EspEnabled = v end)
    _UIToggle.new(espSec, "BoxEsp", "박스 ESP (Box)", false, function(v) getgenv().MultConfig.BoxEsp = v end)
    _UIToggle.new(espSec, "NameEsp", "이름 ESP (Name)", false, function(v) getgenv().MultConfig.NameEsp = v end)
    _UIToggle.new(espSec, "HealthEsp", "체력바 ESP (Health)", false, function(v) getgenv().MultConfig.HealthEsp = v end)

    local miscSec = _UISection.new(miscTab, "left", "Miscellaneous")
    _UIToggle.new(miscSec, "BypassStatus", "안티 치트 바이패스 활성됨", true, function(v) end)

    local spooferSec = _UISection.new(spooferTab, "left", "Device Spoofer")
    _UIToggle.new(spooferSec, "DeviceSpooferMaster", "Enable Device Spoofer", false, function(v)
        getgenv().DeviceSpooferEnabled = v
        getgenv().MultConfig.DeviceSpooferEnabled = v
        if v then _fireDeviceSetControls(getgenv().SpoofedDeviceMode) end
    end)
    _UIToggle.new(spooferSec, "DeviceVR", "Device: VR", false, function(v)
        if v then
            getgenv().SpoofedDeviceMode = _normalizeDeviceMode("vr")
            getgenv().MultConfig.SpoofedDeviceMode = getgenv().SpoofedDeviceMode
            if getgenv().DeviceSpooferEnabled then _fireDeviceSetControls() end
        end
    end)
    _UIToggle.new(spooferSec, "DeviceTouch", "Device: Touch", false, function(v)
        if v then
            getgenv().SpoofedDeviceMode = _normalizeDeviceMode("touch")
            getgenv().MultConfig.SpoofedDeviceMode = getgenv().MultConfig.SpoofedDeviceMode
            if getgenv().DeviceSpooferEnabled then _fireDeviceSetControls() end
        end
    end)
    _UIToggle.new(spooferSec, "DeviceGamepad", "Device: Gamepad", false, function(v)
        if v then
            getgenv().SpoofedDeviceMode = _normalizeDeviceMode("gamepad")
            getgenv().MultConfig.SpoofedDeviceMode = getgenv().MultConfig.SpoofedDeviceMode
            if getgenv().DeviceSpooferEnabled then _fireDeviceSetControls() end
        end
    end)
    _UIToggle.new(spooferSec, "DeviceMouseKeyboard", "Device: MouseKeyboard", true, function(v)
        if v then
            getgenv().SpoofedDeviceMode = _normalizeDeviceMode("mousekeyboard")
            getgenv().MultConfig.SpoofedDeviceMode = getgenv().MultConfig.SpoofedDeviceMode
            if getgenv().DeviceSpooferEnabled then _fireDeviceSetControls() end
        end
    end)

    local spooferInfo = _UISection.new(spooferTab, "right", "Info")
    _UIToggle.new(spooferInfo, "SpoofInfo", "SetControls: VR/Touch/Gamepad/MK", true, function() end)

    UI:Finish()

    --------------------------------------------------------------------
    -- [ ESP & DRAWING SYSTEM ENGINE ]
    --------------------------------------------------------------------
    local _ESP_Cache = {}

    local function _createESP(plr)
        if _ESP_Cache[plr] then return end
        local drawings = {
            Box = Drawing.new("Square"),
            Name = Drawing.new("Text"),
            HealthBar = Drawing.new("Line"),
            HealthBarBack = Drawing.new("Line")
        }
        drawings.Box.Visible = false
        drawings.Box.Thickness = 1
        drawings.Box.Color = Color3.fromRGB(55, 175, 225)
        drawings.Box.Filled = false

        drawings.Name.Visible = false
        drawings.Name.Size = 14
        drawings.Name.Center = true
        drawings.Name.Outline = true
        drawings.Name.Color = Color3.fromRGB(255, 255, 255)

        drawings.HealthBar.Visible = false
        drawings.HealthBar.Thickness = 2
        drawings.HealthBar.Color = Color3.fromRGB(0, 255, 0)

        drawings.HealthBarBack.Visible = false
        drawings.HealthBarBack.Thickness = 2
        drawings.HealthBarBack.Color = Color3.fromRGB(0, 0, 0)

        _ESP_Cache[plr] = drawings
    end

    local function _removeESP(plr)
        if _ESP_Cache[plr] then
            for _, obj in pairs(_ESP_Cache[plr]) do
                pcall(function() obj:Remove() end)
            end
            _ESP_Cache[plr] = nil
        end
    end

    for _, p in ipairs(_Players:GetPlayers()) do
        if p ~= _LocalPlayer then _createESP(p) end
    end
    _Players.PlayerAdded:Connect(_createESP)
    _Players.PlayerRemoving:Connect(_removeESP)

    local _fovAimCircle = Drawing.new("Circle")
    _fovAimCircle.Visible = false
    _fovAimCircle.Thickness = 1
    _fovAimCircle.Color = Color3.fromRGB(255, 255, 255)
    _fovAimCircle.Filled = false

    local _fovSilentCircle = Drawing.new("Circle")
    _fovSilentCircle.Visible = false
    _fovSilentCircle.Thickness = 1
    _fovSilentCircle.Color = Color3.fromRGB(255, 0, 0)
    _fovSilentCircle.Filled = false

    --------------------------------------------------------------------
    -- [ CORE COMBAT & RAGEBOT LOOP ]
    --------------------------------------------------------------------
    local _Utility = pcall(function() return require(_ReplicatedStorage.Modules.Utility) end) and require(_ReplicatedStorage.Modules.Utility) or nil
    local _EnumLibrary = pcall(function() return require(_ReplicatedStorage.Modules.EnumLibrary) end) and require(_ReplicatedStorage.Modules.EnumLibrary) or nil
    local _FighterController = pcall(function() return require(_LocalPlayer.PlayerScripts.Controllers.FighterController) end) and require(_LocalPlayer.PlayerScripts.Controllers.FighterController) or nil
    local _SpectateController = pcall(function() return require(_LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController")) end) and require(_LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController")) or nil

    local _lastFireTick = 0

    local function _getTargetPart(character, partName)
        if not character then return nil end
        if partName == "Head" then
            return character:FindFirstChild("Head")
        elseif partName == "Torso" then
            return character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("LowerTorso")
        else
            return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
        end
    end

    local function _isEnemy(plr)
        if plr == _LocalPlayer then return false end
        if _SpectateController then
            local subject = _SpectateController.CurrentDuelSubject
            local dueler = subject and subject:GetDueler(_LocalPlayer)
            local teamID = dueler and dueler:Get("TeamID") or nil
            if teamID and subject and subject.Duelers then
                for _, d in subject.Duelers do
                    if d.Player == plr then
                        return d:Get("TeamID") ~= teamID
                    end
                end
            end
        end
        return plr:GetAttribute("TeamID") ~= _LocalPlayer:GetAttribute("TeamID")
    end

    local function _wallCheckPass(targetPart)
        if not targetPart or not _LocalPlayer.Character then return true end
        local origin = _Camera.CFrame.Position
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.FilterDescendantsInstances = {_LocalPlayer.Character, _Camera}
        local result = _Workspace:Raycast(origin, targetPart.Position - origin, rayParams)
        if result and result.Instance then
            local model = result.Instance:FindFirstAncestorOfClass("Model")
            if model and model == targetPart.Parent then
                return true
            end
            return false
        end
        return true
    end

    local function _getClosestTargetToCursor(maxDist, needWallCheck, partName)
        local mousePos = _UserInputService:GetMouseLocation()
        local closestPlr = nil
        local closestPart = nil
        local shortestDist = maxDist

        for _, plr in ipairs(_Players:GetPlayers()) do
            if _isEnemy(plr) then
                local char = plr.Character
                local hum = char and char:FindFirstChildWhichIsA("Humanoid")
                local targetPart = _getTargetPart(char, partName)
                if char and hum and hum.Health > 0 and targetPart then
                    if not needWallCheck or _wallCheckPass(targetPart) then
                        local screenPos, onScreen = _Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                closestPlr = plr
                                closestPart = targetPart
                            end
                        end
                    end
                end
            end
        end
        return closestPlr, closestPart
    end

    _RunService.Heartbeat:Connect(function()
        _fovAimCircle.Visible = getgenv().MultConfig.AimbotDrawFOV and getgenv().MultConfig.AimbotEnabled
        _fovAimCircle.Position = _UserInputService:GetMouseLocation()
        _fovAimCircle.Radius = getgenv().MultConfig.AimbotFOVSize

        _fovSilentCircle.Visible = getgenv().MultConfig.SilentDrawFOV and getgenv().MultConfig.SilentEnabled
        _fovSilentCircle.Position = _UserInputService:GetMouseLocation()
        _fovSilentCircle.Radius = getgenv().MultConfig.SilentFOVSize

        for plr, drawings in pairs(_ESP_Cache) do
            local show = getgenv().MultConfig.EspEnabled and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildWhichIsA("Humanoid") and plr.Character.Humanoid.Health > 0
            if show then
                local char = plr.Character
                local hrp = char.HumanoidRootPart
                local hum = char.Humanoid
                local vector, onScreen = _Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local head = char:FindFirstChild("Head")
                    local topPos = head and _Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)) or vector
                    local bottomPos = _Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    local height = math.abs(topPos.Y - bottomPos.Y)
                    local width = height / 2

                    if getgenv().MultConfig.BoxEsp then
                        drawings.Box.Visible = true
                        drawings.Box.Size = Vector2.new(width, height)
                        drawings.Box.Position = Vector2.new(vector.X - width / 2, topPos.Y)
                    else
                        drawings.Box.Visible = false
                    end

                    if getgenv().MultConfig.NameEsp then
                        drawings.Name.Visible = true
                        drawings.Name.Text = plr.Name
                        drawings.Name.Position = Vector2.new(vector.X, topPos.Y - 16)
                    else
                        drawings.Name.Visible = false
                    end

                    if getgenv().MultConfig.HealthEsp then
                        local healthPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        drawings.HealthBarBack.Visible = true
                        drawings.HealthBarBack.From = Vector2.new(vector.X - width / 2 - 6, topPos.Y + height)
                        drawings.HealthBarBack.To = Vector2.new(vector.X - width / 2 - 6, topPos.Y)

                        drawings.HealthBar.Visible = true
                        drawings.HealthBar.From = Vector2.new(vector.X - width / 2 - 6, topPos.Y + height)
                        drawings.HealthBar.To = Vector2.new(vector.X - width / 2 - 6, topPos.Y + (height * (1 - healthPct)))
                        drawings.HealthBar.Color = Color3.fromRGB(255 * (1 - healthPct), 255 * healthPct, 0)
                    else
                        drawings.HealthBar.Visible = false
                        drawings.HealthBarBack.Visible = false
                    end
                else
                    for _, d in pairs(drawings) do d.Visible = false end
                end
            else
                for _, d in pairs(drawings) do d.Visible = false end
            end
        end

        if getgenv().MultConfig.AimbotEnabled and _UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local _, targetPart = _getClosestTargetToCursor(getgenv().MultConfig.AimbotFOVSize, getgenv().MultConfig.AimbotWallCheck, getgenv().MultConfig.AimbotHitPart)
            if targetPart then
                _Camera.CFrame = CFrame.lookAt(_Camera.CFrame.Position, targetPart.Position)
            end
        end

        if getgenv().MultConfig.TriggerbotEnabled then
            local mouseTarget = _LocalPlayer:GetMouse().Target
            if mouseTarget then
                local model = mouseTarget:FindFirstAncestorOfClass("Model")
                local targetPlr = model and _Players:GetPlayerFromCharacter(model)
                if targetPlr and _isEnemy(targetPlr) then
                    mouse1click()
                end
            end
        end

        if not getgenv().MultConfig.RageEnabled then return end

        local char = _LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local targetPlr, targetHRP, targetHead = nil, nil, nil
        local maxDist = 500

        for _, plr in ipairs(_Players:GetPlayers()) do
            if _isEnemy(plr) then
                local pChar = plr.Character
                local pHRP = pChar and pChar:FindFirstChild("HumanoidRootPart")
                local pHead = pChar and pChar:FindFirstChild("Head")
                local pHum = pChar and pChar:FindFirstChildWhichIsA("Humanoid")
                if pHRP and pHead and pHum and pHum.Health > 0 then
                    local dist = (hrp.Position - pHRP.Position).Magnitude
                    if dist < maxDist then
                        maxDist = dist
                        targetPlr = plr
                        targetHRP = pHRP
                        targetHead = pHead
                    end
                end
            end
        end

        if targetPlr and targetHead and targetHRP then
            _centerLabel.Text = "[vallkmult] -> " .. targetPlr.Name
            _centerLabel.TextColor3 = Color3.fromRGB(255, 75, 75)

            local targetPos = (targetHRP.CFrame * CFrame.new(0, 1, 2)).Position
            local targetCFrame = CFrame.lookAt(targetPos, targetHead.Position)

            local origCF, origVel, origRot = hrp.CFrame, hrp.Velocity, hrp.RotVelocity
            hrp.CFrame = targetCFrame
            _RunService:BindToRenderStep("__restore", 101, function()
                if hrp then
                    hrp.CFrame, hrp.Velocity, hrp.RotVelocity = origCF, origVel, origRot
                end
                _RunService:UnbindFromRenderStep("__restore")
            end)

            if _FighterController and _FighterController.LocalFighter and _Utility and _EnumLibrary then
                local item = _FighterController.LocalFighter.EquippedItem
                if item and tick() - _lastFireTick >= getgenv().MultConfig.FireRate then
                    _lastFireTick = tick()
                    local payload = {
                        [utf8.char(1)] = {
                            [utf8.char(0)] = _Utility:EncodeCFrame(CFrame.lookAt(targetPos, targetHead.Position)),
                            [utf8.char(1)] = _Utility:EncodeCFrame(targetHead.CFrame),
                            [utf8.char(2)] = targetHead,
                            [utf8.char(3)] = _Utility:EncodeCFrame(targetHead.CFrame:ToObjectSpace(CFrame.new(targetHead.Position)))
                        }
                    }
                    pcall(function()
                        _ReplicatedStorage.Remotes.Replication.Fighter.UseItem:FireServer(item:Get("ObjectID"), _EnumLibrary:ToEnum("StartShooting"), payload, nil)
                    end)
                end
            end
        else
            _centerLabel.Text = "[vallkmult free v1] [Searching...]"
            _centerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
end
