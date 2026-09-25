-- ============================================================================
--   [ vallkmult free v1 - Ultimate Rivals Rage & Legit Integration ]
--   [ Obfuscated & Protected by Custom Heavy Engine v6.9 ]
-- ============================================================================

local _0x_Junk_Data_Table = {
    0x3F2A1B, 0x984B2C, 0x1104AE, 0xFF3810, 0x552A1F, 0x99283C, 0x482911, 0x19283A,
    0x58291B, 0x33421C, 0x99182D, 0x77281E, 0x55621F, 0x112830, 0x442919, 0x993828,
    0x128391, 0x492810, 0x559281, 0x882391, 0x991283, 0x334281, 0x221938, 0x556781,
    0x889123, 0x443219, 0x998123, 0x112938, 0x665432, 0x778899, 0x123456, 0xFEDCBA
}

local function _0x_Junk_Eval()
    local _0x_acc = 0
    for _0x_i = 1, #_0x_Junk_Data_Table do
        _0x_acc = (_0x_acc + _0x_Junk_Data_Table[_0x_i]) % 0xFFFF
    end
    return _0x_acc ~= -1
end

if _0x_Junk_Eval() then
    local _0x_HOME_DIR = "kiciahook/rivals/"
    if makefolder then
        pcall(makefolder, _0x_HOME_DIR)
        pcall(makefolder, _0x_HOME_DIR .. "cosmetics")
        pcall(makefolder, _0x_HOME_DIR .. "configs")
    end

    do
        repeat task.wait() until game:IsLoaded()

        local function _0x_safeRef(_0x_ref)
            return cloneref and cloneref(_0x_ref) or _0x_ref
        end

        local _0x_setidentity = setthreadcontext or setthreadidentity or set_thread_identity or set_thread_context or setidentity

        local _0x_Players = _0x_safeRef(game:GetService("Players"))
        local _0x_RunService = _0x_safeRef(game:GetService("RunService"))
        local _0x_UserInputService = _0x_safeRef(game:GetService("UserInputService"))
        local _0x_CoreGui = _0x_safeRef(game:GetService("CoreGui"))
        local _0x_HttpService = _0x_safeRef(game:GetService("HttpService"))
        local _0x_ReplicatedStorage = _0x_safeRef(game:GetService("ReplicatedStorage"))
        local _0x_Workspace = _0x_safeRef(game:GetService("Workspace"))
        local _0x_Lighting = _0x_safeRef(game:GetService("Lighting"))
        local _0x_Camera = _0x_Workspace.CurrentCamera
        local _0x_LocalPlayer = _0x_Players.LocalPlayer

        for _, _0x_name in ipairs({"vallkmult free v1", "mult up free v1", "MuteUpGUI", "RagebotStatusHUD", "RagebotdkCenterHUD", "zero up 나다 free v1", "LuminousPureHub", "HoNyang💩FOV", "HalmuESP", "multvallkRageUI", "ExecutorToggleUI"}) do
            local _0x_oldGui = _0x_CoreGui:FindFirstChild(_0x_name) or _0x_LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(_0x_name)
            if _0x_oldGui then _0x_oldGui:Destroy() end
        end

        --------------------------------------------------------------------
        -- [ HIGH PERFORMANCE ANTI-CHEAT BYPASS SYSTEM ]
        --------------------------------------------------------------------
        pcall(function()
            if _0x_LocalPlayer and typeof(_0x_LocalPlayer.Kick) == "function" then
                local _0x_oldKick = _0x_LocalPlayer.Kick
                _0x_LocalPlayer.Kick = function(...) end
                pcall(function()
                    if hookfunction then
                        hookfunction(_0x_oldKick, newcclosure(function(...) end))
                    end
                end)
            end

            pcall(function()
                if typeof(_0x_Players.Kick) == "function" then
                    _0x_Players.Kick = function(...) end
                end
            end)

            if hookmetamethod and getnamecallmethod then
                local _0x_bannedRemotes = {
                    kick=true, ban=true, punish=true, anticheat=true, detect=true,
                    report=true, flag=true, crash=true, log=true, screenshot=true,
                    security=true, mod=true, admin=true, watchdog=true, sentinel=true,
                }
                local _0x_oldNamecall
                _0x_oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(_0x_self, ...)
                    local _0x_method = getnamecallmethod()
                    if _0x_method == "Kick" or _0x_method == "kick" then
                        return
                    end

                    if (_0x_method == "FireServer" or _0x_method == "InvokeServer") and _0x_self then
                        local _0x_sName = ""
                        pcall(function() _0x_sName = string.lower(tostring(_0x_self.Name or "")) end)
                        for _0x_k, _ in pairs(_0x_bannedRemotes) do
                            if _0x_sName ~= "" and string.find(_0x_sName, _0x_k, 1, true) then
                                return
                            end
                        end
                    end
                    return _0x_oldNamecall(_0x_self, ...)
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
            AimbotHitPart = "Head",
            AimbotDrawFOV = false,
            AimbotFOVSize = 120,
            AimbotWallCheck = false,
            SilentEnabled = false,
            SilentHitPart = "Head",
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
        local _0x_centerHudGui = Instance.new("ScreenGui")
        _0x_centerHudGui.Name = "vallkmult free v1_HUD"
        _0x_centerHudGui.ResetOnSpawn = false
        _0x_centerHudGui.IgnoreGuiInset = true
        _0x_centerHudGui.DisplayOrder = 100001
        if _0x_setidentity then _0x_setidentity(8) end
        _0x_centerHudGui.Parent = _0x_CoreGui

        local _0x_centerLabel = Instance.new("TextLabel")
        _0x_centerLabel.Name = "StatusLabel"
        _0x_centerLabel.Size = UDim2.new(0, 320, 0, 32)
        _0x_centerLabel.Position = UDim2.new(0.5, 0, 0.5, 60)
        _0x_centerLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        _0x_centerLabel.Font = Enum.Font.Code
        _0x_centerLabel.TextSize = 14
        _0x_centerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        _0x_centerLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        _0x_centerLabel.BorderColor3 = Color3.fromRGB(55, 175, 225)
        _0x_centerLabel.BorderSizePixel = 1
        _0x_centerLabel.Text = "vallkmult free v1 [Active]"
        _0x_centerLabel.Parent = _0x_centerHudGui

        local _0x_centerCorner = Instance.new("UICorner")
        _0x_centerCorner.CornerRadius = UDim.new(0, 4)
        _0x_centerCorner.Parent = _0x_centerLabel

        --------------------------------------------------------------------
        -- [ Kiciahook UI Framework Engine ]
        --------------------------------------------------------------------
        local _0x_UISection = {}
        _0x_UISection.__index = _0x_UISection
        function _0x_UISection.new(_0x_pC, _0x_side, _0x_label)
            local _0x_self = setmetatable({}, _0x_UISection)
            _0x_self.instances = {}

            local _0x_container = Instance.new("Frame")
            _0x_container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            _0x_container.BorderColor3 = Color3.fromRGB(50, 50, 50)
            _0x_container.Size = UDim2.new(1, -2, 0, 22)
            _0x_self.instances.container = _0x_container

            local _0x_inline = Instance.new("Frame")
            _0x_inline.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            _0x_inline.BorderSizePixel = 0
            _0x_inline.Position = UDim2.new(0, 1, 0, 1)
            _0x_inline.Size = UDim2.new(1, -2, 1, -2)
            _0x_inline.Parent = _0x_container

            local _0x_theme = Instance.new("Frame")
            _0x_theme.BackgroundColor3 = Color3.fromRGB(55, 175, 225)
            _0x_theme.BorderSizePixel = 0
            _0x_theme.Size = UDim2.new(1, 0, 0, 2)
            _0x_theme.Parent = _0x_inline

            local _0x_lbl = Instance.new("TextLabel")
            _0x_lbl.BackgroundTransparency = 1
            _0x_lbl.Font = Enum.Font.Arial
            _0x_lbl.TextSize = 12
            _0x_lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            _0x_lbl.TextXAlignment = Enum.TextXAlignment.Left
            _0x_lbl.Position = UDim2.new(0, 4, 0, 5)
            _0x_lbl.Size = UDim2.new(1, -8, 0, 11)
            _0x_lbl.Text = _0x_label or "Section"
            _0x_lbl.Parent = _0x_inline
            _0x_self.instances.label = _0x_lbl

            local _0x_canvas = Instance.new("Frame")
            _0x_canvas.Position = UDim2.new(0, 0, 1, 0)
            _0x_canvas.Size = UDim2.new(1, 0, 1, -20)
            _0x_canvas.AnchorPoint = Vector2.new(0, 1)
            _0x_canvas.BackgroundTransparency = 1
            _0x_canvas.Parent = _0x_inline
            _0x_self.instances.canvas = _0x_canvas

            local _0x_listLayout = Instance.new("UIListLayout")
            _0x_listLayout.Padding = UDim.new(0, 4)
            _0x_listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            _0x_listLayout.Parent = _0x_canvas

            _0x_container.Parent = _0x_pC[_0x_side]
            return _0x_self
        end

        local _0x_UIBase = {}
        _0x_UIBase.__index = _0x_UIBase
        function _0x_UIBase.new()
            local _0x_self = setmetatable({}, _0x_UIBase)
            _0x_self.instances = {}
            _0x_self.visible = true
            _0x_self.tabs = {}
            _0x_self.tabButtons = {}
            _0x_self.currentTab = nil

            local _0x_screenGui = Instance.new("ScreenGui")
            _0x_screenGui.Name = "vallkmult free v1"
            _0x_screenGui.ResetOnSpawn = false
            _0x_screenGui.IgnoreGuiInset = true
            _0x_screenGui.DisplayOrder = 99999
            _0x_self.instances.gui = _0x_screenGui

            local _0x_container = Instance.new("Frame")
            _0x_container.Name = "MainContainer"
            _0x_container.BackgroundColor3 = Color3.fromRGB(55, 175, 225)
            _0x_container.BorderSizePixel = 1
            _0x_container.BorderColor3 = Color3.fromRGB(0, 0, 0)
            _0x_container.AnchorPoint = Vector2.new(0.5, 0.5)
            _0x_container.Position = UDim2.new(0.5, 0, 0.5, 0)
            _0x_container.Size = UDim2.new(0, 540, 0, 440)
            _0x_container.Parent = _0x_screenGui
            _0x_self.instances.container = _0x_container

            local _0x_uiScale = Instance.new("UIScale")
            _0x_uiScale.Scale = 1.0
            _0x_uiScale.Parent = _0x_container

            local _0x_background = Instance.new("Frame")
            _0x_background.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            _0x_background.Position = UDim2.new(0, 1, 0, 1)
            _0x_background.Size = UDim2.new(1, -2, 1, -2)
            _0x_background.BorderSizePixel = 0
            _0x_background.Parent = _0x_container

            local _0x_title = Instance.new("TextLabel")
            _0x_title.Size = UDim2.new(1, -8, 0, 15)
            _0x_title.Position = UDim2.new(0, 6, 0, 4)
            _0x_title.Font = Enum.Font.ArialBold
            _0x_title.TextSize = 12
            _0x_title.BackgroundTransparency = 1
            _0x_title.TextXAlignment = Enum.TextXAlignment.Left
            _0x_title.TextColor3 = Color3.fromRGB(255, 255, 255)
            _0x_title.Text = "vallkmult free v1 - Ultimate Combat Hub"
            _0x_title.Parent = _0x_background

            local _0x_tabBar = Instance.new("Frame")
            _0x_tabBar.Name = "TabBar"
            _0x_tabBar.BackgroundTransparency = 1
            _0x_tabBar.Position = UDim2.new(0, 5, 0, 22)
            _0x_tabBar.Size = UDim2.new(1, -10, 0, 24)
            _0x_tabBar.Parent = _0x_background

            local _0x_tabLayout = Instance.new("UIListLayout")
            _0x_tabLayout.FillDirection = Enum.FillDirection.Horizontal
            _0x_tabLayout.Padding = UDim.new(0, 3)
            _0x_tabLayout.Parent = _0x_tabBar

            local _0x_contentArea = Instance.new("Frame")
            _0x_contentArea.Name = "ContentArea"
            _0x_contentArea.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            _0x_contentArea.Position = UDim2.new(0, 5, 0, 48)
            _0x_contentArea.Size = UDim2.new(1, -10, 1, -54)
            _0x_contentArea.BorderColor3 = Color3.fromRGB(50, 50, 50)
            _0x_contentArea.Parent = _0x_background
            _0x_self.instances.contentArea = _0x_contentArea

            local _0x_drag = Instance.new("TextButton")
            _0x_drag.BackgroundTransparency = 1
            _0x_drag.Text = ""
            _0x_drag.Size = UDim2.new(1, -80, 0, 20)
            _0x_drag.Parent = _0x_container

            local _0x_openBtn = Instance.new("TextButton")
            _0x_openBtn.Name = "OpenButton"
            _0x_openBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            _0x_openBtn.BorderColor3 = Color3.fromRGB(55, 175, 225)
            _0x_openBtn.Position = UDim2.new(0.5, 0, 0, 8)
            _0x_openBtn.AnchorPoint = Vector2.new(0.5, 0)
            _0x_openBtn.Size = UDim2.new(0, 70, 0, 26)
            _0x_openBtn.Font = Enum.Font.Arial
            _0x_openBtn.TextSize = 12
            _0x_openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            _0x_openBtn.Text = "Menu [Close]"
            _0x_openBtn.Parent = _0x_screenGui

            local _0x_openCorner = Instance.new("UICorner")
            _0x_openCorner.CornerRadius = UDim.new(0, 4)
            _0x_openCorner.Parent = _0x_openBtn

            _0x_openBtn.MouseButton1Click:Connect(function()
                _0x_self.visible = not _0x_self.visible
                _0x_container.Visible = _0x_self.visible
                _0x_openBtn.Text = _0x_self.visible and "Menu [Close]" or "Menu [Open]"
            end)

            local _0x_dragging, _0x_dragStart, _0x_startPos
            _0x_drag.InputBegan:Connect(function(_0x_input)
                if _0x_input.UserInputType == Enum.UserInputType.MouseButton1 or _0x_input.UserInputType == Enum.UserInputType.Touch then
                    _0x_dragging = true
                    _0x_dragStart = _0x_input.Position
                    _0x_startPos = _0x_container.Position
                end
            end)

            _0x_UserInputService.InputChanged:Connect(function(_0x_input)
                if _0x_dragging and (_0x_input.UserInputType == Enum.UserInputType.MouseMovement or _0x_input.UserInputType == Enum.UserInputType.Touch) then
                    local _0x_delta = _0x_input.Position - _0x_dragStart
                    _0x_container.Position = UDim2.new(_0x_startPos.X.Scale, _0x_startPos.X.Offset + _0x_delta.X, _0x_startPos.Y.Scale, _0x_startPos.Y.Offset + _0x_delta.Y)
                end
            end)

            return _0x_self
        end

        function _0x_UIBase:AddTab(_0x_name)
            local _0x_tabBtn = Instance.new("TextButton")
            _0x_tabBtn.Name = _0x_name .. "TabBtn"
            _0x_tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            _0x_tabBtn.BorderColor3 = Color3.fromRGB(60, 60, 60)
            _0x_tabBtn.Size = UDim2.new(0, 80, 1, 0)
            _0x_tabBtn.Font = Enum.Font.ArialBold
            _0x_tabBtn.TextSize = 11
            _0x_tabBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
            _0x_tabBtn.Text = _0x_name
            _0x_tabBtn.Parent = self.instances.contentArea.Parent:FindFirstChild("TabBar")

            local _0x_tabHolder = Instance.new("Frame")
            _0x_tabHolder.Name = _0x_name .. "Holder"
            _0x_tabHolder.BackgroundTransparency = 1
            _0x_tabHolder.Position = UDim2.new(0, 1, 0, 1)
            _0x_tabHolder.Size = UDim2.new(1, -2, 1, -2)
            _0x_tabHolder.Visible = false
            _0x_tabHolder.Parent = self.instances.contentArea

            local _0x_leftCanvas = Instance.new("ScrollingFrame")
            _0x_leftCanvas.BackgroundTransparency = 1
            _0x_leftCanvas.Position = UDim2.new(0, 5, 0, 5)
            _0x_leftCanvas.AutomaticCanvasSize = Enum.AutomaticSize.Y
            _0x_leftCanvas.Size = UDim2.new(0.5, -8, 1, -10)
            _0x_leftCanvas.BorderSizePixel = 0
            _0x_leftCanvas.CanvasSize = UDim2.new(0, 0)
            _0x_leftCanvas.ScrollBarThickness = 1
            _0x_leftCanvas.Parent = _0x_tabHolder

            local _0x_uiLayoutL = Instance.new("UIListLayout")
            _0x_uiLayoutL.Padding = UDim.new(0, 7)
            _0x_uiLayoutL.Parent = _0x_leftCanvas

            local _0x_rightCanvas = Instance.new("ScrollingFrame")
            _0x_rightCanvas.BackgroundTransparency = 1
            _0x_rightCanvas.Position = UDim2.new(0.5, 3, 0, 5)
            _0x_rightCanvas.AutomaticCanvasSize = Enum.AutomaticSize.Y
            _0x_rightCanvas.Size = UDim2.new(0.5, -8, 1, -10)
            _0x_rightCanvas.BorderSizePixel = 0
            _0x_rightCanvas.CanvasSize = UDim2.new(0, 0)
            _0x_rightCanvas.ScrollBarThickness = 1
            _0x_rightCanvas.Parent = _0x_tabHolder

            local _0x_uiLayoutR = Instance.new("UIListLayout")
            _0x_uiLayoutR.Padding = UDim.new(0, 7)
            _0x_uiLayoutR.Parent = _0x_rightCanvas

            local _0x_holderObj = { left = _0x_leftCanvas, right = _0x_rightCanvas }
            self.tabs[_0x_name] = _0x_holderObj

            _0x_tabBtn.MouseButton1Click:Connect(function()
                for _0x_tName, _0x_h in pairs(self.tabs) do
                    local _0x_btn = self.tabButtons[_0x_tName]
                    local _0x_isTarget = (_0x_tName == _0x_name)
                    _0x_h.left.Parent.Visible = _0x_isTarget
                    if _0x_btn then
                        _0x_btn.TextColor3 = _0x_isTarget and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 170, 170)
                        _0x_btn.BackgroundColor3 = _0x_isTarget and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(25, 25, 25)
                        _0x_btn.BorderColor3 = _0x_isTarget and Color3.fromRGB(55, 175, 225) or Color3.fromRGB(60, 60, 60)
                    end
                end
            end)

            self.tabButtons[_0x_name] = _0x_tabBtn

            if not self.currentTab then
                self.currentTab = _0x_name
                _0x_tabHolder.Visible = true
                _0x_tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                _0x_tabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                _0x_tabBtn.BorderColor3 = Color3.fromRGB(55, 175, 225)
            end

            return _0x_holderObj
        end

        function _0x_UIBase:Finish()
            if _0x_setidentity then _0x_setidentity(8) end
            self.instances.gui.Parent = _0x_CoreGui
        end

        --------------------------------------------------------------------
        -- [ UI COMPONENTS (Toggle, Slider, Dropdown) ]
        --------------------------------------------------------------------
        local _0x_UIToggle = {}
        _0x_UIToggle.__index = _0x_UIToggle
        function _0x_UIToggle.new(_0x_sec, _0x_flag, _0x_labelText, _0x_defaultVal, _0x_callback)
            local _0x_self = setmetatable({}, _0x_UIToggle)
            _0x_self.value = _0x_defaultVal or false
            _0x_self.callback = _0x_callback or function() end

            _0x_sec.instances.container.Size += UDim2.new(0, 0, 0, 20)

            local _0x_btn = Instance.new("TextButton")
            _0x_btn.BackgroundTransparency = 1
            _0x_btn.Size = UDim2.new(1, 0, 0, 18)
            _0x_btn.Text = ""
            _0x_btn.Parent = _0x_sec.instances.canvas

            local _0x_box = Instance.new("Frame")
            _0x_box.BorderColor3 = Color3.fromRGB(0, 0, 0)
            _0x_box.BackgroundColor3 = _0x_self.value and Color3.fromRGB(55, 175, 225) or Color3.fromRGB(35, 35, 35)
            _0x_box.Size = UDim2.new(0, 12, 0, 12)
            _0x_box.Position = UDim2.new(0, 4, 0.5, 0)
            _0x_box.AnchorPoint = Vector2.new(0, 0.5)
            _0x_box.Parent = _0x_btn

            local _0x_lbl = Instance.new("TextLabel")
            _0x_lbl.Font = Enum.Font.Arial
            _0x_lbl.TextSize = 12
            _0x_lbl.Position = UDim2.new(0, 22, 0.5, 0)
            _0x_lbl.AnchorPoint = Vector2.new(0, 0.5)
            _0x_lbl.Size = UDim2.new(1, -25, 0, 12)
            _0x_lbl.Text = _0x_labelText or _0x_flag
            _0x_lbl.BackgroundTransparency = 1
            _0x_lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
            _0x_lbl.TextXAlignment = Enum.TextXAlignment.Left
            _0x_lbl.Parent = _0x_btn

            _0x_btn.MouseButton1Click:Connect(function()
                _0x_self.value = not _0x_self.value
                _0x_box.BackgroundColor3 = _0x_self.value and Color3.fromRGB(55, 175, 225) or Color3.fromRGB(35, 35, 35)
                _0x_self.callback(_0x_self.value)
            end)

            return _0x_self
        end

        local _0x_UISlider = {}
        _0x_UISlider.__index = _0x_UISlider
        function _0x_UISlider.new(_0x_sec, _0x_flag, _0x_labelText, _0x_min, _0x_max, _0x_defaultVal, _0x_callback)
            local _0x_self = setmetatable({}, _0x_UISlider)
            _0x_self.min = _0x_min or 0
            _0x_self.max = _0x_max or 100
            _0x_self.value = _0x_defaultVal or _0x_min
            _0x_self.callback = _0x_callback or function() end

            _0x_sec.instances.container.Size += UDim2.new(0, 0, 0, 28)

            local _0x_container = Instance.new("Frame")
            _0x_container.BackgroundTransparency = 1
            _0x_container.Size = UDim2.new(1, 0, 0, 26)
            _0x_container.Parent = _0x_sec.instances.canvas

            local _0x_lbl = Instance.new("TextLabel")
            _0x_lbl.Font = Enum.Font.Arial
            _0x_lbl.TextSize = 12
            _0x_lbl.Position = UDim2.new(0, 4, 0, 1)
            _0x_lbl.Size = UDim2.new(1, -8, 0, 11)
            _0x_lbl.Text = string.format("%s: %s", _0x_labelText or _0x_flag, tostring(_0x_self.value))
            _0x_lbl.BackgroundTransparency = 1
            _0x_lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
            _0x_lbl.TextXAlignment = Enum.TextXAlignment.Left
            _0x_lbl.Parent = _0x_container

            local _0x_track = Instance.new("TextButton")
            _0x_track.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            _0x_track.BorderColor3 = Color3.fromRGB(0, 0, 0)
            _0x_track.Size = UDim2.new(1, -8, 0, 8)
            _0x_track.Position = UDim2.new(0, 4, 0, 15)
            _0x_track.Text = ""
            _0x_track.AutoButtonColor = false
            _0x_track.Parent = _0x_container

            local _0x_fill = Instance.new("Frame")
            _0x_fill.BorderSizePixel = 0
            _0x_fill.Size = UDim2.new((_0x_self.value - _0x_self.min)/(_0x_self.max - _0x_self.min), 0, 1, 0)
            _0x_fill.BackgroundColor3 = Color3.fromRGB(55, 175, 225)
            _0x_fill.Parent = _0x_track

            local function _0x_update(_0x_input)
                local _0x_pct = math.clamp((_0x_input.Position.X - _0x_track.AbsolutePosition.X) / _0x_track.AbsoluteSize.X, 0, 1)
                _0x_self.value = math.floor((_0x_self.min + (_0x_self.max - _0x_self.min) * _0x_pct) * 10000) / 10000
                _0x_fill.Size = UDim2.new(_0x_pct, 0, 1, 0)
                _0x_lbl.Text = string.format("%s: %s", _0x_labelText or _0x_flag, tostring(_0x_self.value))
                _0x_self.callback(_0x_self.value)
            end

            local _0x_sliding = false
            _0x_track.InputBegan:Connect(function(_0x_input)
                if _0x_input.UserInputType == Enum.UserInputType.MouseButton1 or _0x_input.UserInputType == Enum.UserInputType.Touch then
                    _0x_sliding = true
                    _0x_update(_0x_input)
                end
            end)
            _0x_UserInputService.InputChanged:Connect(function(_0x_input)
                if _0x_sliding and (_0x_input.UserInputType == Enum.UserInputType.MouseMovement or _0x_input.UserInputType == Enum.UserInputType.Touch) then
                    _0x_update(_0x_input)
                end
            end)
            _0x_UserInputService.InputEnded:Connect(function(_0x_input)
                if _0x_input.UserInputType == Enum.UserInputType.MouseButton1 or _0x_input.UserInputType == Enum.UserInputType.Touch then
                    _0x_sliding = false
                end
            end)

            return _0x_self
        end

        local _0x_UIDropdown = {}
        _0x_UIDropdown.__index = _0x_UIDropdown
        function _0x_UIDropdown.new(_0x_sec, _0x_flag, _0x_labelText, _0x_list, _0x_defaultVal, _0x_callback)
            local _0x_self = setmetatable({}, _0x_UIDropdown)
            _0x_self.value = _0x_defaultVal or _0x_list[1]
            _0x_self.callback = _0x_callback or function() end
            _0x_self.open = false

            _0x_sec.instances.container.Size += UDim2.new(0, 0, 0, 38)

            local _0x_container = Instance.new("Frame")
            _0x_container.BackgroundTransparency = 1
            _0x_container.Size = UDim2.new(1, 0, 0, 36)
            _0x_container.Parent = _0x_sec.instances.canvas

            local _0x_lbl = Instance.new("TextLabel")
            _0x_lbl.Font = Enum.Font.Arial
            _0x_lbl.TextSize = 12
            _0x_lbl.Position = UDim2.new(0, 4, 0, 1)
            _0x_lbl.Size = UDim2.new(1, -8, 0, 11)
            _0x_lbl.Text = _0x_labelText or _0x_flag
            _0x_lbl.BackgroundTransparency = 1
            _0x_lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
            _0x_lbl.TextXAlignment = Enum.TextXAlignment.Left
            _0x_lbl.Parent = _0x_container

            local _0x_btn = Instance.new("TextButton")
            _0x_btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            _0x_btn.BorderColor3 = Color3.fromRGB(0, 0, 0)
            _0x_btn.Size = UDim2.new(1, -8, 0, 20)
            _0x_btn.Position = UDim2.new(0, 4, 0, 14)
            _0x_btn.Font = Enum.Font.Arial
            _0x_btn.TextSize = 12
            _0x_btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            _0x_btn.Text = tostring(_0x_self.value)
            _0x_btn.Parent = _0x_container

            local _0x_dropFrame = Instance.new("Frame")
            _0x_dropFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            _0x_dropFrame.BorderColor3 = Color3.fromRGB(55, 175, 225)
            _0x_dropFrame.Position = UDim2.new(0, 4, 0, 36)
            _0x_dropFrame.Size = UDim2.new(1, -8, 0, #_0x_list * 20)
            _0x_dropFrame.Visible = false
            _0x_dropFrame.ZIndex = 10
            _0x_dropFrame.Parent = _0x_container

            local _0x_listLayout = Instance.new("UIListLayout")
            _0x_listLayout.Parent = _0x_dropFrame

            for _, _0x_item in ipairs(_0x_list) do
                local _0x_itemBtn = Instance.new("TextButton")
                _0x_itemBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                _0x_itemBtn.BorderSizePixel = 0
                _0x_itemBtn.Size = UDim2.new(1, 0, 0, 20)
                _0x_itemBtn.Font = Enum.Font.Arial
                _0x_itemBtn.TextSize = 12
                _0x_itemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                _0x_itemBtn.Text = tostring(_0x_item)
                _0x_itemBtn.ZIndex = 11
                _0x_itemBtn.Parent = _0x_dropFrame

                _0x_itemBtn.MouseButton1Click:Connect(function()
                    _0x_self.value = _0x_item
                    _0x_btn.Text = tostring(_0x_item)
                    _0x_dropFrame.Visible = false
                    _0x_self.open = false
                    _0x_self.callback(_0x_self.value)
                end)
            end

            _0x_btn.MouseButton1Click:Connect(function()
                _0x_self.open = not _0x_self.open
                _0x_dropFrame.Visible = _0x_self.open
            end)

            return _0x_self
        end

        --------------------------------------------------------------------
        -- [ DEVICE SPOOFER ]
        --------------------------------------------------------------------
        getgenv().DeviceSpooferEnabled = getgenv().MultConfig.DeviceSpooferEnabled
        getgenv().SpoofedDeviceMode = getgenv().MultConfig.SpoofedDeviceMode or "MouseKeyboard"

        local function _0x_normalizeDeviceMode(_0x_mode)
            if not _0x_mode then return "MouseKeyboard" end
            local _0x_m = tostring(_0x_mode):lower():gsub("%s+", "")
            if _0x_m == "vr" then return "VR" end
            if _0x_m == "touch" or _0x_m == "mobile" then return "Touch" end
            if _0x_m == "gamepad" or _0x_m == "controller" or _0x_m == "console" then return "Gamepad" end
            if _0x_m == "mousekeyboard" or _0x_m == "keyboard" or _0x_m == "pc" or _0x_m == "desktop" then return "MouseKeyboard" end
            return "MouseKeyboard"
        end

        local function _0x_getSetControlsRemote()
            local _0x_ok, _0x_remote = pcall(function()
                local _0x_remotes = _0x_ReplicatedStorage:FindFirstChild("Remotes")
                local _0x_replication = _0x_remotes and _0x_remotes:FindFirstChild("Replication")
                local _0x_fighter = _0x_replication and _0x_replication:FindFirstChild("Fighter")
                return _0x_fighter and _0x_fighter:FindFirstChild("SetControls")
            end)
            return _0x_ok and _0x_remote or nil
        end

        local function _0x_fireDeviceSetControls(_0x_mode)
            _0x_mode = _0x_normalizeDeviceMode(_0x_mode or getgenv().SpoofedDeviceMode)
            getgenv().SpoofedDeviceMode = _0x_mode
            if getgenv().MultConfig then
                getgenv().MultConfig.SpoofedDeviceMode = _0x_mode
            end
            local _0x_remote = _0x_getSetControlsRemote()
            if not _0x_remote then return false end
            pcall(function() _0x_remote:FireServer(_0x_mode) end)
            return true
        end

        task.spawn(function()
            while true do
                task.wait(2.5)
                if getgenv().DeviceSpooferEnabled or (getgenv().MultConfig and getgenv().MultConfig.DeviceSpooferEnabled) then
                    _0x_fireDeviceSetControls(getgenv().SpoofedDeviceMode)
                end
            end
        end)

        _0x_LocalPlayer.CharacterAdded:Connect(function()
            if getgenv().DeviceSpooferEnabled or (getgenv().MultConfig and getgenv().MultConfig.DeviceSpooferEnabled) then
                task.wait(1)
                _0x_fireDeviceSetControls(getgenv().SpoofedDeviceMode)
            end
        end)

        --------------------------------------------------------------------
        -- [ UI BUILD & TABS ]
        --------------------------------------------------------------------
        local _0x_UI = _0x_UIBase.new()

        local _0x_mainTab = _0x_UI:AddTab("Main")
        local _0x_rageTab = _0x_UI:AddTab("Ragebot")
        local _0x_combatTab = _0x_UI:AddTab("Combat")
        local _0x_espTab = _0x_UI:AddTab("ESP")
        local _0x_miscTab = _0x_UI:AddTab("Misc")
        local _0x_spooferTab = _0x_UI:AddTab("Spoofer")

        local _0x_mainSec = _0x_UISection.new(_0x_mainTab, "left", "General Information")
        _0x_UIToggle.new(_0x_mainSec, "WelcomeToggle", "vallkmult free v1 허브 활성화됨", true, function() end)

        local _0x_rageSec = _0x_UISection.new(_0x_rageTab, "left", "Ragebot Settings")
        _0x_UIDropdown.new(_0x_rageSec, "RageVersion", "레이지봇 버전 선택", {"vallkmult_premium_v6", "vallkmult_old_rage_bot_v3"}, "vallkmult_premium_v6", function(_0x_sel)
            getgenv().MultConfig.RageVersion = _0x_sel
        end)
        _0x_UIToggle.new(_0x_rageSec, "RagebotToggle", "레이지봇 활성화 (RageBot)", true, function(_0x_val)
            getgenv().MultConfig.RageEnabled = _0x_val
        end)
        _0x_UISlider.new(_0x_rageSec, "FireRateSlider", "발사 속도 (FireRate)", 0.0001, 0.01, 0.0005, function(_0x_val)
            getgenv().MultConfig.FireRate = _0x_val
        end)

        local _0x_aimSec = _0x_UISection.new(_0x_combatTab, "left", "Aimbot Settings")
        _0x_UIToggle.new(_0x_aimSec, "AimbotToggle", "에임봇 활성화", false, function(_0x_v) getgenv().MultConfig.AimbotEnabled = _0x_v end)
        _0x_UIDropdown.new(_0x_aimSec, "AimPart", "에임봇 타겟 파트", {"Head", "HumanoidRootPart", "Torso"}, "Head", function(_0x_v) getgenv().MultConfig.AimbotHitPart = _0x_v end)
        _0x_UIToggle.new(_0x_aimSec, "AimFOV", "에임봇 FOV 표시 (Draw FOV)", false, function(_0x_v) getgenv().MultConfig.AimbotDrawFOV = _0x_v end)
        _0x_UIToggle.new(_0x_aimSec, "AimWall", "에임봇 벽 체크 (Wallcheck)", false, function(_0x_v) getgenv().MultConfig.AimbotWallCheck = _0x_v end)

        local _0x_silentSec = _0x_UISection.new(_0x_combatTab, "right", "Silent Aim Settings")
        _0x_UIToggle.new(_0x_silentSec, "SilentToggle", "사일런트 에임 활성화", false, function(_0x_v) getgenv().MultConfig.SilentEnabled = _0x_v end)
        _0x_UIDropdown.new(_0x_silentSec, "SilentPart", "사일런트 타겟 파트", {"Head", "HumanoidRootPart", "Torso"}, "Head", function(_0x_v) getgenv().MultConfig.SilentHitPart = _0x_v end)
        _0x_UIToggle.new(_0x_silentSec, "SilentFOV", "사일런트 FOV 표시 (Draw FOV)", false, function(_0x_v) getgenv().MultConfig.SilentDrawFOV = _0x_v end)
        _0x_UIToggle.new(_0x_silentSec, "SilentWall", "사일런트 벽 체크 (Wallcheck)", false, function(_0x_v) getgenv().MultConfig.SilentWallCheck = _0x_v end)
        _0x_UIToggle.new(_0x_silentSec, "SilentScope", "사일런트 Scope Look", false, function(_0x_v) getgenv().MultConfig.SilentScopeLook = _0x_v end)

        local _0x_trigSec = _0x_UISection.new(_0x_combatTab, "right", "Triggerbot")
        _0x_UIToggle.new(_0x_trigSec, "TriggerToggle", "트리거봇 활성화 (Triggerbot)", false, function(_0x_v) getgenv().MultConfig.TriggerbotEnabled = _0x_v end)

        local _0x_espSec = _0x_UISection.new(_0x_espTab, "left", "ESP Visuals")
        _0x_UIToggle.new(_0x_espSec, "EspToggle", "플레이어 시각화 (ESP)", false, function(_0x_v) getgenv().MultConfig.EspEnabled = _0x_v end)
        _0x_UIToggle.new(_0x_espSec, "BoxEsp", "박스 ESP (Box)", false, function(_0x_v) getgenv().MultConfig.BoxEsp = _0x_v end)
        _0x_UIToggle.new(_0x_espSec, "NameEsp", "이름 ESP (Name)", false, function(_0x_v) getgenv().MultConfig.NameEsp = _0x_v end)
        _0x_UIToggle.new(_0x_espSec, "HealthEsp", "체력바 ESP (Health)", false, function(_0x_v) getgenv().MultConfig.HealthEsp = _0x_v end)

        local _0x_miscSec = _0x_UISection.new(_0x_miscTab, "left", "Miscellaneous")
        _0x_UIToggle.new(_0x_miscSec, "BypassStatus", "안티 치트 바이패스 활성됨", true, function() end)

        local _0x_spooferSec = _0x_UISection.new(_0x_spooferTab, "left", "Device Spoofer")
        _0x_UIToggle.new(_0x_spooferSec, "DeviceSpooferMaster", "Enable Device Spoofer", false, function(_0x_v)
            getgenv().DeviceSpooferEnabled = _0x_v
            getgenv().MultConfig.DeviceSpooferEnabled = _0x_v
            if _0x_v then _0x_fireDeviceSetControls(getgenv().SpoofedDeviceMode) end
        end)
        _0x_UIToggle.new(_0x_spooferSec, "DeviceVR", "Device: VR", false, function(_0x_v)
            if _0x_v then
                getgenv().SpoofedDeviceMode = _0x_normalizeDeviceMode("vr")
                getgenv().MultConfig.SpoofedDeviceMode = getgenv().SpoofedDeviceMode
                if getgenv().DeviceSpooferEnabled then _0x_fireDeviceSetControls() end
            end
        end)
        _0x_UIToggle.new(_0x_spooferSec, "DeviceTouch", "Device: Touch", false, function(_0x_v)
            if _0x_v then
                getgenv().SpoofedDeviceMode = _0x_normalizeDeviceMode("touch")
                getgenv().MultConfig.SpoofedDeviceMode = getgenv().SpoofedDeviceMode
                if getgenv().DeviceSpooferEnabled then _0x_fireDeviceSetControls() end
            end
        end)
        _0x_UIToggle.new(_0x_spooferSec, "DeviceGamepad", "Device: Gamepad", false, function(_0x_v)
            if _0x_v then
                getgenv().SpoofedDeviceMode = _0x_normalizeDeviceMode("gamepad")
                getgenv().MultConfig.SpoofedDeviceMode = getgenv().SpoofedDeviceMode
                if getgenv().DeviceSpooferEnabled then _0x_fireDeviceSetControls() end
            end
        end)
        _0x_UIToggle.new(_0x_spooferSec, "DeviceMouseKeyboard", "Device: MouseKeyboard", true, function(_0x_v)
            if _0x_v then
                getgenv().SpoofedDeviceMode = _0x_normalizeDeviceMode("mousekeyboard")
                getgenv().MultConfig.SpoofedDeviceMode = getgenv().SpoofedDeviceMode
                if getgenv().DeviceSpooferEnabled then _0x_fireDeviceSetControls() end
            end
        end)

        local _0x_spooferInfo = _0x_UISection.new(_0x_spooferTab, "right", "Info")
        _0x_UIToggle.new(_0x_spooferInfo, "SpoofInfo", "SetControls: VR/Touch/Gamepad/MK", true, function() end)

        _0x_UI:Finish()

        --------------------------------------------------------------------
        -- [ ESP & DRAWING SYSTEM ENGINE ]
        --------------------------------------------------------------------
        local _0x_ESP_Cache = {}

        local function _0x_createESP(_0x_plr)
            if _0x_ESP_Cache[_0x_plr] then return end
            local _0x_drawings = {
                Box = Drawing.new("Square"),
                Name = Drawing.new("Text"),
                HealthBar = Drawing.new("Line"),
                HealthBarBack = Drawing.new("Line")
            }
            _0x_drawings.Box.Visible = false
            _0x_drawings.Box.Thickness = 1
            _0x_drawings.Box.Color = Color3.fromRGB(55, 175, 225)
            _0x_drawings.Box.Filled = false

            _0x_drawings.Name.Visible = false
            _0x_drawings.Name.Size = 14
            _0x_drawings.Name.Center = true
            _0x_drawings.Name.Outline = true
            _0x_drawings.Name.Color = Color3.fromRGB(255, 255, 255)

            _0x_drawings.HealthBar.Visible = false
            _0x_drawings.HealthBar.Thickness = 2
            _0x_drawings.HealthBar.Color = Color3.fromRGB(0, 255, 0)

            _0x_drawings.HealthBarBack.Visible = false
            _0x_drawings.HealthBarBack.Thickness = 2
            _0x_drawings.HealthBarBack.Color = Color3.fromRGB(0, 0, 0)

            _0x_ESP_Cache[_0x_plr] = _0x_drawings
        end

        local function _0x_removeESP(_0x_plr)
            if _0x_ESP_Cache[_0x_plr] then
                for _, _0x_obj in pairs(_0x_ESP_Cache[_0x_plr]) do
                    pcall(function() _0x_obj:Remove() end)
                end
                _0x_ESP_Cache[_0x_plr] = nil
            end
        end

        for _, _0x_p in ipairs(_0x_Players:GetPlayers()) do
            if _0x_p ~= _0x_LocalPlayer then _0x_createESP(_0x_p) end
        end
        _0x_Players.PlayerAdded:Connect(_0x_createESP)
        _0x_Players.PlayerRemoving:Connect(_0x_removeESP)

        local _0x_fovAimCircle = Drawing.new("Circle")
        _0x_fovAimCircle.Visible = false
        _0x_fovAimCircle.Thickness = 1
        _0x_fovAimCircle.Color = Color3.fromRGB(255, 255, 255)
        _0x_fovAimCircle.Filled = false

        local _0x_fovSilentCircle = Drawing.new("Circle")
        _0x_fovSilentCircle.Visible = false
        _0x_fovSilentCircle.Thickness = 1
        _0x_fovSilentCircle.Color = Color3.fromRGB(255, 0, 0)
        _0x_fovSilentCircle.Filled = false

        --------------------------------------------------------------------
        -- [ CORE COMBAT & RAGEBOT LOOP ]
        --------------------------------------------------------------------
        local _0x_Utility = pcall(function() return require(_0x_ReplicatedStorage.Modules.Utility) end) and require(_0x_ReplicatedStorage.Modules.Utility) or nil
        local _0x_EnumLibrary = pcall(function() return require(_0x_ReplicatedStorage.Modules.EnumLibrary) end) and require(_0x_ReplicatedStorage.Modules.EnumLibrary) or nil
        local _0x_FighterController = pcall(function() return require(_0x_LocalPlayer.PlayerScripts.Controllers.FighterController) end) and require(_0x_LocalPlayer.PlayerScripts.Controllers.FighterController) or nil
        local _0x_SpectateController = pcall(function() return require(_0x_LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController")) end) and require(_0x_LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController")) or nil

        local _0x_lastFireTick = 0

        local function _0x_getTargetPart(_0x_character, _0x_partName)
            if not _0x_character then return nil end
            if _0x_partName == "Head" then
                return _0x_character:FindFirstChild("Head")
            elseif _0x_partName == "Torso" then
                return _0x_character:FindFirstChild("Torso") or _0x_character:FindFirstChild("UpperTorso") or _0x_character:FindFirstChild("LowerTorso")
            else
                return _0x_character:FindFirstChild("HumanoidRootPart") or _0x_character:FindFirstChild("Head")
            end
        end

        local function _0x_isEnemy(_0x_plr)
            if _0x_plr == _0x_LocalPlayer then return false end
            if _0x_SpectateController then
                local _0x_subject = _0x_SpectateController.CurrentDuelSubject
                local _0x_dueler = _0x_subject and _0x_subject:GetDueler(_0x_LocalPlayer)
                local _0x_teamID = _0x_dueler and _0x_dueler:Get("TeamID") or nil
                if _0x_teamID and _0x_subject and _0x_subject.Duelers then
                    for _, _0x_d in _0x_subject.Duelers do
                        if _0x_d.Player == _0x_plr then
                            return _0x_d:Get("TeamID") ~= _0x_teamID
                        end
                    end
                end
            end
            return _0x_plr:GetAttribute("TeamID") ~= _0x_LocalPlayer:GetAttribute("TeamID")
        end

        local function _0x_wallCheckPass(_0x_targetPart)
            if not _0x_targetPart or not _0x_LocalPlayer.Character then return true end
            local _0x_origin = _0x_Camera.CFrame.Position
            local _0x_rayParams = RaycastParams.new()
            _0x_rayParams.FilterType = Enum.RaycastFilterType.Exclude
            _0x_rayParams.FilterDescendantsInstances = {_0x_LocalPlayer.Character, _0x_Camera}
            local _0x_result = _0x_Workspace:Raycast(_0x_origin, _0x_targetPart.Position - _0x_origin, _0x_rayParams)
            if _0x_result and _0x_result.Instance then
                local _0x_model = _0x_result.Instance:FindFirstAncestorOfClass("Model")
                if _0x_model and _0x_model == _0x_targetPart.Parent then return true end
                return false
            end
            return true
        end

        local function _0x_getClosestTargetToCursor(_0x_maxDist, _0x_needWallCheck, _0x_partName)
            local _0x_mousePos = _0x_UserInputService:GetMouseLocation()
            local _0x_closestPlr, _0x_closestPart, _0x_shortestDist = nil, nil, _0x_maxDist

            for _, _0x_plr in ipairs(_0x_Players:GetPlayers()) do
                if _0x_isEnemy(_0x_plr) then
                    local _0x_char = _0x_plr.Character
                    local _0x_hum = _0x_char and _0x_char:FindFirstChildWhichIsA("Humanoid")
                    local _0x_targetPart = _0x_getTargetPart(_0x_char, _0x_partName)
                    if _0x_char and _0x_hum and _0x_hum.Health > 0 and _0x_targetPart then
                        if not _0x_needWallCheck or _0x_wallCheckPass(_0x_targetPart) then
                            local _0x_screenPos, _0x_onScreen = _0x_Camera:WorldToViewportPoint(_0x_targetPart.Position)
                            if _0x_onScreen then
                                local _0x_dist = (Vector2.new(_0x_screenPos.X, _0x_screenPos.Y) - _0x_mousePos).Magnitude
                                if _0x_dist < _0x_shortestDist then
                                    _0x_shortestDist = _0x_dist
                                    _0x_closestPlr = _0x_plr
                                    _0x_closestPart = _0x_targetPart
                                end
                            end
                        end
                    end
                end
            end
            return _0x_closestPlr, _0x_closestPart
        end

        _0x_RunService.Heartbeat:Connect(function()
            _0x_fovAimCircle.Visible = getgenv().MultConfig.AimbotDrawFOV and getgenv().MultConfig.AimbotEnabled
            _0x_fovAimCircle.Position = _0x_UserInputService:GetMouseLocation()
            _0x_fovAimCircle.Radius = getgenv().MultConfig.AimbotFOVSize

            _0x_fovSilentCircle.Visible = getgenv().MultConfig.SilentDrawFOV and getgenv().MultConfig.SilentEnabled
            _0x_fovSilentCircle.Position = _0x_UserInputService:GetMouseLocation()
            _0x_fovSilentCircle.Radius = getgenv().MultConfig.SilentFOVSize

            for _0x_plr, _0x_drawings in pairs(_0x_ESP_Cache) do
                local _0x_show = getgenv().MultConfig.EspEnabled and _0x_plr.Character and _0x_plr.Character:FindFirstChild("HumanoidRootPart") and _0x_plr.Character:FindFirstChildWhichIsA("Humanoid") and _0x_plr.Character.Humanoid.Health > 0
                if _0x_show then
                    local _0x_char = _0x_plr.Character
                    local _0x_hrp = _0x_char.HumanoidRootPart
                    local _0x_hum = _0x_char.Humanoid
                    local _0x_vector, _0x_onScreen = _0x_Camera:WorldToViewportPoint(_0x_hrp.Position)
                    if _0x_onScreen then
                        local _0x_head = _0x_char:FindFirstChild("Head")
                        local _0x_topPos = _0x_head and _0x_Camera:WorldToViewportPoint(_0x_head.Position + Vector3.new(0, 0.5, 0)) or _0x_vector
                        local _0x_bottomPos = _0x_Camera:WorldToViewportPoint(_0x_hrp.Position - Vector3.new(0, 3, 0))
                        local _0x_height = math.abs(_0x_topPos.Y - _0x_bottomPos.Y)
                        local _0x_width = _0x_height / 2

                        if getgenv().MultConfig.BoxEsp then
                            _0x_drawings.Box.Visible = true
                            _0x_drawings.Box.Size = Vector2.new(_0x_width, _0x_height)
                            _0x_drawings.Box.Position = Vector2.new(_0x_vector.X - _0x_width / 2, _0x_topPos.Y)
                        else
                            _0x_drawings.Box.Visible = false
                        end

                        if getgenv().MultConfig.NameEsp then
                            _0x_drawings.Name.Visible = true
                            _0x_drawings.Name.Text = _0x_plr.Name
                            _0x_drawings.Name.Position = Vector2.new(_0x_vector.X, _0x_topPos.Y - 16)
                        else
                            _0x_drawings.Name.Visible = false
                        end

                        if getgenv().MultConfig.HealthEsp then
                            local _0x_healthPct = math.clamp(_0x_hum.Health / _0x_hum.MaxHealth, 0, 1)
                            _0x_drawings.HealthBarBack.Visible = true
                            _0x_drawings.HealthBarBack.From = Vector2.new(_0x_vector.X - _0x_width / 2 - 6, _0x_topPos.Y + _0x_height)
                            _0x_drawings.HealthBarBack.To = Vector2.new(_0x_vector.X - _0x_width / 2 - 6, _0x_topPos.Y)

                            _0x_drawings.HealthBar.Visible = true
                            _0x_drawings.HealthBar.From = Vector2.new(_0x_vector.X - _0x_width / 2 - 6, _0x_topPos.Y + _0x_height)
                            _0x_drawings.HealthBar.To = Vector2.new(_0x_vector.X - _0x_width / 2 - 6, _0x_topPos.Y + (_0x_height * (1 - _0x_healthPct)))
                            _0x_drawings.HealthBar.Color = Color3.fromRGB(255 * (1 - _0x_healthPct), 255 * _0x_healthPct, 0)
                        else
                            _0x_drawings.HealthBar.Visible = false
                            _0x_drawings.HealthBarBack.Visible = false
                        end
                    else
                        for _, _0x_d in pairs(_0x_drawings) do _0x_d.Visible = false end
                    end
                else
                    for _, _0x_d in pairs(_0x_drawings) do _0x_d.Visible = false end
                end
            end

            if getgenv().MultConfig.AimbotEnabled and _0x_UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                local _, _0x_targetPart = _0x_getClosestTargetToCursor(getgenv().MultConfig.AimbotFOVSize, getgenv().MultConfig.AimbotWallCheck, getgenv().MultConfig.AimbotHitPart)
                if _0x_targetPart then
                    _0x_Camera.CFrame = CFrame.lookAt(_0x_Camera.CFrame.Position, _0x_targetPart.Position)
                end
            end

            if getgenv().MultConfig.TriggerbotEnabled then
                local _0x_mouseTarget = _0x_LocalPlayer:GetMouse().Target
                if _0x_mouseTarget then
                    local _0x_model = _0x_mouseTarget:FindFirstAncestorOfClass("Model")
                    local _0x_targetPlr = _0x_model and _0x_Players:GetPlayerFromCharacter(_0x_model)
                    if _0x_targetPlr and _0x_isEnemy(_0x_targetPlr) then
                        mouse1click()
                    end
                end
            end

            if not getgenv().MultConfig.RageEnabled then return end
            
            local _0x_char = _0x_LocalPlayer.Character
            local _0x_hrp = _0x_char and _0x_char:FindFirstChild("HumanoidRootPart")
            if not _0x_hrp then return end

            local _0x_targetPlr, _0x_targetHRP, _0x_targetHead = nil, nil, nil
            local _0x_maxDist = 500

            for _, _0x_plr in ipairs(_0x_Players:GetPlayers()) do
                if _0x_isEnemy(_0x_plr) then
                    local _0x_pChar = _0x_plr.Character
                    local _0x_pHRP = _0x_pChar and _0x_pChar:FindFirstChild("HumanoidRootPart")
                    local _0x_pHead = _0x_pChar and _0x_pChar:FindFirstChild("Head")
                    local _0x_pHum = _0x_pChar and _0x_pChar:FindFirstChildWhichIsA("Humanoid")
                    if _0x_pHRP and _0x_pHead and _0x_pHum and _0x_pHum.Health > 0 then
                        local _0x_dist = (_0x_hrp.Position - _0x_pHRP.Position).Magnitude
                        if _0x_dist < _0x_maxDist then
                            _0x_maxDist = _0x_dist
                            _0x_targetPlr = _0x_plr
                            _0x_targetHRP = _0x_pHRP
                            _0x_targetHead = _0x_pHead
                        end
                    end
                end
            end

            if _0x_targetPlr and _0x_targetHead and _0x_targetHRP then
                _0x_centerLabel.Text = "[vallkmult] -> " .. _0x_targetPlr.Name
                _0x_centerLabel.TextColor3 = Color3.fromRGB(255, 75, 75)

                local _0x_targetPos = (_0x_targetHRP.CFrame * CFrame.new(0, 1, 2)).Position
                local _0x_targetCFrame = CFrame.lookAt(_0x_targetPos, _0x_targetHead.Position)

                local _0x_origCF, _0x_origVel, _0x_origRot = _0x_hrp.CFrame, _0x_hrp.Velocity, _0x_hrp.RotVelocity
                _0x_hrp.CFrame = _0x_targetCFrame
                _0x_RunService:BindToRenderStep("__restore", 101, function()
                    if _0x_hrp then
                        _0x_hrp.CFrame, _0x_hrp.Velocity, _0x_hrp.RotVelocity = _0x_origCF, _0x_origVel, _0x_origRot
                    end
                    _0x_RunService:UnbindFromRenderStep("__restore")
                end)

                if _0x_FighterController and _0x_FighterController.LocalFighter and _0x_Utility and _0x_EnumLibrary then
                    local _0x_item = _0x_FighterController.LocalFighter.EquippedItem
                    if _0x_item and tick() - _0x_lastFireTick >= getgenv().MultConfig.FireRate then
                        _0x_lastFireTick = tick()
                        local _0x_payload = {
                            [utf8.char(1)] = {
                                [utf8.char(0)] = _0x_Utility:EncodeCFrame(CFrame.lookAt(_0x_targetPos, _0x_targetHead.Position)),
                                [utf8.char(1)] = _0x_Utility:EncodeCFrame(_0x_targetHead.CFrame),
                                [utf8.char(2)] = _0x_targetHead,
                                [utf8.char(3)] = _0x_Utility:EncodeCFrame(_0x_targetHead.CFrame:ToObjectSpace(CFrame.new(_0x_targetHead.Position)))
                            }
                        }
                        pcall(function()
                            _0x_ReplicatedStorage.Remotes.Replication.Fighter.UseItem:FireServer(_0x_item:Get("ObjectID"), _0x_EnumLibrary:ToEnum("StartShooting"), _0x_payload, nil)
                        end)
                    end
                end
            else
                _0x_centerLabel.Text = "[vallkmult free v1] [Searching...]"
                _0x_centerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end)
    end
end
