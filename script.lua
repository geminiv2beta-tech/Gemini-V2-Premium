-- [[ RayV3 Premium // Mobile Ultimate Edition & Universal Script v2.5 - Obfuscated & Upgraded ]]
-- [[ Combined Desync + Wallbang Anti-Cheat Bypass & Blind Automatic RageBot ]]

local _0x1a = game:GetService("Players")
local _0x1b = game:GetService("RunService")
local _0x1c = game:GetService("UserInputService")
local _0x1d = game:GetService("VirtualUser")
local _0x1e = game:GetService("Workspace")
local _0x1f = game:GetService("GuiService")
local _0x20 = game:GetService("Lighting")
local _0x21 = game:GetService("SoundService")
local _0x22 = game:GetService("HttpService")
local _0x23 = _0x1a.LocalPlayer

local _0x24 = false
local _0x25, _0x26, _0x27, _0x28, _0x29, _0x2a, _0x2b, _0x2c, _0x2d, _0x2e = false, false, false, false, false, false, false, false, false, false
local _0x2f, _0x30, _0x31, _0x32, _0x33, _0x34 = false, false, false, false, true, false 
local _0x35 = true 
local _0x36 = true 
local _0x37 = true 
local _0x38, _0x39, _0x3a, _0x3b = false, false, false, false
local _0x3c, _0x3d, _0x3e, _0x3f = true, true, true, true

local _0x40 = "Mobile" 
local _0x41 = "Gradient"   
local _0x42 = true         
local _0x43 = "Normal"

local _0x44 = 50
local _0x45 = 5 
local _0x46 = 380 
local _0x47 = 0.02
local _0x48 = nil
local _0x49 = nil 
local _0x4a = 0
local _0x4b = false
local _0x4c = false
local _0x4d = 0

local _0x4e = "RayV3_Mobile_Config.json"
local _0x4f = "RayV3_Mobile_Used.json"

pcall(function()
    if isfile and isfile(_0x4f) then _0x4b = true end
end)

local function _0x50()
    pcall(function()
        local _0x51 = {
            flySpeed = _0x44,
            fovRadius = _0x46,
            fireDelay = _0x47,
            selectedDeviceSpoof = _0x40,
            fovColorStyle = _0x41,
            mapColorTheme = _0x43,
            isRainbowGun = _0x42,
            isAntiCheatBypass = _0x36,
            isAntiKatana = _0x35,
            isNoRecoil = _0x3e,
            isNoSpread = _0x3f
        }
        if writefile then
            writefile(_0x4e, _0x22:JSONEncode(_0x51))
        end
    end)
end

local function _0x52()
    pcall(function()
        if isfile and isfile(_0x4e) then
            local _0x53 = _0x22:JSONDecode(readfile(_0x4e))
            if _0x53 then
                if _0x53.flySpeed then _0x44 = _0x53.flySpeed end
                if _0x53.fovRadius then _0x46 = _0x53.fovRadius end
                if _0x53.fireDelay then _0x47 = _0x53.fireDelay end
                if _0x53.selectedDeviceSpoof then _0x40 = _0x53.selectedDeviceSpoof end
                if _0x53.fovColorStyle then _0x41 = _0x53.fovColorStyle end
                if _0x53.mapColorTheme then _0x43 = _0x53.mapColorTheme end
                if _0x53.isRainbowGun ~= nil then _0x42 = _0x53.isRainbowGun end
                if _0x53.isAntiCheatBypass ~= nil then _0x36 = _0x53.isAntiCheatBypass end
                if _0x53.isAntiKatana ~= nil then _0x35 = _0x53.isAntiKatana end
                if _0x53.isNoRecoil ~= nil then _0x3e = _0x53.isNoRecoil end
                if _0x53.isNoSpread ~= nil then _0x3f = _0x53.isNoSpread end
            end
        end
    end)
end
_0x52()

local function _0x54(_0x55)
    if not _0x3d then return true end
    local _0x56, _0x57 = pcall(function()
        local _0x58 = _0x1e.CurrentCamera
        if not _0x58 then return false end
        local _0x59 = RaycastParams.new()
        _0x59.FilterType = Enum.RaycastFilterType.Exclude
        _0x59.FilterDescendantsInstances = {_0x23.Character, _0x58}
        _0x59.IgnoreWater = true
        
        local _0x5a = _0x58.CFrame.Position
        local _0x5b = _0x55.Position - _0x5a
        local _0x5c = _0x1e:Raycast(_0x5a, _0x5b, _0x59)
        
        if _0x5c then
            local _0x5d = _0x5c.Instance
            if _0x5d:IsDescendantOf(_0x55.Parent) then
                return true
            end
            return (_0x2b or _0x2c) -- Desync + Wallbang integration bypasses standard wall checks
        end
        return true
    end)
    return _0x56 and _0x57 or true
end

local function _0x5e(_0x5f, _0x60, _0x61)
    pcall(function()
        local _0x62 = 3000
        local _0x63 = RaycastParams.new()
        _0x63.FilterType = Enum.RaycastFilterType.Exclude
        _0x63.FilterDescendantsInstances = {_0x5f.Character}
        
        local _0x64 = workspace:Raycast(_0x60, _0x61 * _0x62, _0x63)
        if _0x64 or _0x2c or _0x2b then
            local _0x65 = _0x64 and _0x64.Position or (_0x60 + _0x61 * 100)
            local _0x66 = 120 -- Enhanced penetration depth for combined desync/wallbang
            local _0x67 = _0x65 + (_0x61 * _0x66)
            
            local _0x68 = RaycastParams.new()
            _0x68.FilterType = Enum.RaycastFilterType.Exclude
            _0x68.FilterDescendantsInstances = {_0x5f.Character, _0x64 and _0x64.Instance or nil}
            
            local _0x69 = workspace:Raycast(_0x67, _0x61 * _0x62, _0x68)
            if _0x69 then
                local _0x6a = _0x69.Instance
                local _0x6b = _0x6a.Parent:FindFirstChildOfClass("Humanoid")
                if _0x6b then
                    _0x6b:TakeDamage(100)
                end
            end
        end
    end)
end

local _0x6c, _0x6d, _0x6e
pcall(function()
    _0x6c = hookmetamethod(game, "__index", newcclosure(function(self, k)
        if not checkcaller() then
            if self == _0x1c or self == _0x1f or tostring(self):lower():find("userinputservice") or tostring(self):lower():find("guiservice") then
                if k == "Platform" or k == "Device" or k == "ClientPlatform" then
                    if _0x40 == "Mobile" then return Enum.Platform.IOS
                    elseif _0x40 == "Android" then return Enum.Platform.Android
                    elseif _0x40 == "PC" then return Enum.Platform.Windows
                    elseif _0x40 == "Tablet" then return Enum.Platform.IOS end
                end
            end
            if _0x36 and (k == "WalkSpeed" or k == "JumpPower" or k == "HipHeight" or k == "AssemblyLinearVelocity") then
                return 16
            end
        end
        return _0x6c(self, k)
    end))

    _0x6d = hookmetamethod(game, "__newindex", newcclosure(function(self, k, v)
        if not checkcaller() and _0x36 then
            if (self:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower")) then return end
        end
        return _0x6d(self, k, v)
    end))

    _0x6e = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if not checkcaller() then
            if method == "GetPlatform" or method == "GetDevice" or method == "CheckDevice" or method == "GetPlatformName" then
                if _0x40 == "Mobile" then return Enum.Platform.IOS
                elseif _0x40 == "Android" then return Enum.Platform.Android
                elseif _0x40 == "PC" then return Enum.Platform.Windows end
            end
            
            local methodName = tostring(method):lower()
            local selfName = tostring(self):lower()
            if _0x36 and (methodName:find("kick") or methodName:find("ban") or methodName:find("antishot") or methodName:find("report") or methodName:find("detect") or methodName:find("log") or methodName:find("telemetry") or selfName:find("anticheat") or selfName:find("security") or selfName:find("rivals") or selfName:find("integrity")) then
                return nil
            end
        end
        
        if _0x35 and not checkcaller() then
            local selfName = tostring(self):lower()
            local methodName = tostring(method):lower()
            if selfName:find("reflect") or selfName:find("counter") or selfName:find("katana") or selfName:find("parry") or selfName:find("block") or methodName:find("reflect") or methodName:find("parry") then
                return nil
            end
        end

        if (_0x2a or _0x29 or _0x28 or _0x2c or _0x2b) and _0x49 and not checkcaller() then
            local targetPosToUse = _0x49
            if _0x2c or _0x2b then
                targetPosToUse = _0x49 + Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
                pcall(function()
                    local myRoot = _0x23.Character and _0x23.Character:FindFirstChild("HumanoidRootPart")
                    if myRoot then
                        _0x5e(_0x23, myRoot.Position, (targetPosToUse - myRoot.Position).Unit)
                    end
                end)
            end

            if (method == "Raycast" or method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRayWithWhitelist") and self == _0x1e then
                local origin = args[1]
                if typeof(origin) == "Ray" then origin = origin.Origin end
                local direction = (targetPosToUse - origin)
                
                if method == "Raycast" then
                    args[2] = direction
                    local params = args[3]
                    if not params then
                        params = RaycastParams.new()
                        args[3] = params
                    end
                    pcall(function()
                        params.FilterType = Enum.RaycastFilterType.Exclude
                        params.FilterDescendantsInstances = {_0x23.Character}
                        params.IgnoreWater = true
                    end)
                elseif method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRayWithWhitelist" then
                    args[1] = Ray.new(origin, direction)
                end
                return _0x6e(self, unpack(args))
            elseif method == "FireServer" and (self.Name:lower():find("shoot") or self.Name:lower():find("fire") or self.Name:lower():find("weapon") or self.Name:lower():find("hit") or self.Name:lower():find("damage") or self.Name:lower():find("bullet") or self.Name:lower():find("melee") or self.Name:lower():find("attack")) then
                for i, v in pairs(args) do
                    if typeof(v) == "Vector3" then
                        args[i] = targetPosToUse
                    elseif typeof(v) == "Instance" and v:IsA("BasePart") then
                        args[i] = _0x48
                    elseif typeof(v) == "CFrame" then
                        args[i] = CFrame.new(v.Position, targetPosToUse)
                    end
                end
                return _0x6e(self, unpack(args))
            end
        end
        return _0x6e(self, ...)
    end))
end)

local _0x6f = Instance.new("ScreenGui")
_0x6f.Name = "RayV3MobilePremiumGui"
_0x6f.ResetOnSpawn = false
_0x6f.IgnoreGuiInset = true

local _0x70, _0x71 = pcall(function()
    if gethui then return gethui() else return game:GetService("CoreGui") end
end)
if not _0x70 or not _0x71 then _0x71 = _0x23:WaitForChild("PlayerGui") end
_0x6f.Parent = _0x71

local _0x72 = Instance.new("TextButton")
_0x72.Size = UDim2.new(0, 140, 0, 45)
_0x72.Position = UDim2.new(0.85, -140, 0, 20)
_0x72.Text = "💎 RayV3 Mobile"
_0x72.BackgroundColor3 = Color3.fromRGB(16, 8, 28)
_0x72.TextColor3 = Color3.fromRGB(255, 255, 255)
_0x72.Font = Enum.Font.Code
_0x72.TextSize = 12
_0x72.Visible = _0x4b
_0x72.Draggable = true
_0x72.Parent = _0x6f

local _0x73 = Instance.new("UIGradient") _0x73.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(165, 19, 174)), ColorSequenceKeypoint.new(1, Color3.fromRGB(215, 80, 225))}) _0x73.Parent = _0x72
local _0x74 = Instance.new("UIStroke") _0x74.Thickness = 1.5 _0x74.Color = Color3.fromRGB(165, 19, 174) _0x74.Parent = _0x72
local _0x75 = Instance.new("UICorner") _0x75.CornerRadius = UDim.new(0, 8) _0x75.Parent = _0x72

local _0x76 = Instance.new("Frame")
_0x76.Size = UDim2.new(0, 360, 0, 320)
_0x76.Position = UDim2.new(0.5, -180, 0.5, -160)
_0x76.BackgroundColor3 = Color3.fromRGB(16, 8, 28)
_0x76.BorderSizePixel = 0
_0x76.Active = true
_0x76.Draggable = true
_0x76.Visible = false
_0x76.Parent = _0x6f

local _0x77 = Instance.new("UICorner") _0x77.CornerRadius = UDim.new(0, 8) _0x77.Parent = _0x76
local _0x78 = Instance.new("UIStroke") _0x78.Thickness = 1.5 _0x78.Color = Color3.fromRGB(165, 19, 174) _0x78.Parent = _0x76

local _0x79 = nil
if not _0x4b then
    _0x79 = Instance.new("Frame")
    _0x79.Size = UDim2.new(0, 300, 0, 180)
    _0x79.Position = UDim2.new(0.5, -150, 0.5, -90)
    _0x79.BackgroundColor3 = Color3.fromRGB(16, 8, 28)
    _0x79.BorderSizePixel = 0
    _0x79.Active = true
    _0x79.Draggable = true
    _0x79.Parent = _0x6f

    local _0x7a = Instance.new("UIStroke") _0x7a.Thickness = 1.5 _0x7a.Color = Color3.fromRGB(165, 19, 174) _0x7a.Parent = _0x79
    local _0x7b = Instance.new("UICorner") _0x7b.CornerRadius = UDim.new(0, 8) _0x7b.Parent = _0x79

    local _0x7c = Instance.new("TextLabel") _0x7c.Size = UDim2.new(1, 0, 0, 35) _0x7c.BackgroundTransparency = 1 _0x7c.Text = "RayV3 Mobile // RIVALS" _0x7c.TextColor3 = Color3.fromRGB(255, 255, 255) _0x7c.Font = Enum.Font.Code _0x7c.TextSize = 12 _0x7c.ZIndex = 2 _0x7c.Parent = _0x79
    local _0x7d = Instance.new("UIGradient") _0x7d.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(165, 19, 174)), ColorSequenceKeypoint.new(1, Color3.fromRGB(215, 80, 225))}) _0x7d.Parent = _0x7c

    local _0x7e = Instance.new("TextBox")
    _0x7e.Size = UDim2.new(0, 260, 0, 36)
    _0x7e.Position = UDim2.new(0.5, -130, 0, 50)
    _0x7e.BackgroundColor3 = Color3.fromRGB(24, 12, 42)
    _0x7e.TextColor3 = Color3.fromRGB(255, 255, 255)
    _0x7e.Font = Enum.Font.Code
    _0x7e.TextSize = 11
    _0x7e.PlaceholderText = "ENTER LICENSE KEY..."
    _0x7e.Text = ""
    _0x7e.ZIndex = 2
    _0x7e.Parent = _0x79
    local _0x7f = Instance.new("UIStroke") _0x7f.Color = Color3.fromRGB(165, 19, 174) _0x7f.Parent = _0x7e
    local _0x80 = Instance.new("UICorner") _0x80.CornerRadius = UDim.new(0, 6) _0x80.Parent = _0x7e

    local _0x81 = Instance.new("TextButton")
    _0x81.Size = UDim2.new(0, 125, 0, 36)
    _0x81.Position = UDim2.new(0.5, -130, 0, 98)
    _0x81.BackgroundColor3 = Color3.fromRGB(110, 15, 120)
    _0x81.Text = "VERIFY KEY"
    _0x81.TextColor3 = Color3.fromRGB(230, 190, 255)
    _0x81.Font = Enum.Font.Code
    _0x81.TextSize = 11
    _0x81.ZIndex = 2
    _0x81.Parent = _0x79
    local _0x82 = Instance.new("UIStroke") _0x82.Color = Color3.fromRGB(165, 19, 174) _0x82.Parent = _0x81
    local _0x83 = Instance.new("UICorner") _0x83.CornerRadius = UDim.new(0, 6) _0x83.Parent = _0x81

    local _0x84 = Instance.new("TextButton")
    _0x84.Size = UDim2.new(0, 125, 0, 36)
    _0x84.Position = UDim2.new(0.5, 5, 0, 98)
    _0x84.BackgroundColor3 = Color3.fromRGB(20, 10, 35)
    _0x84.Text = "GET TIKTOK KEY"
    _0x84.TextColor3 = Color3.fromRGB(200, 200, 200)
    _0x84.Font = Enum.Font.Code
    _0x84.TextSize = 11
    _0x84.ZIndex = 2
    _0x84.Parent = _0x79
    local _0x85 = Instance.new("UIStroke") _0x85.Color = Color3.fromRGB(90, 25, 100) _0x85.Parent = _0x84
    local _0x86 = Instance.new("UICorner") _0x86.CornerRadius = UDim.new(0, 6) _0x86.Parent = _0x84

    local _0x87 = "creator_secret-key310086rayv3"
    local _0x88 = "Paid_masterkey-premium310086"
    local _0x89 = "Free_experience-key5Minutes"
    local _0x8a = "https://www.tiktok.com/@user2288587980062?_r=1&_t=ZS-99MrqT8RlBP"

    _0x81.MouseButton1Click:Connect(function()
        local _0x8b = _0x7e.Text
        if _0x8b == _0x87 or _0x8b == _0x88 or _0x8b == _0x89 then
            _0x4b = true
            _0x4c = (_0x8b == _0x87)
            pcall(function() if writefile then writefile(_0x4f, "locked") end end)
            if _0x79 then _0x79:Destroy() end
            _0x72.Visible = true
        else
            _0x7e.Text = ""
            _0x7e.PlaceholderText = "INVALID KEY!"
        end
    end)

    _0x84.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then
                setclipboard(_0x8a)
                _0x84.Text = "LINK COPIED!"
                task.wait(1.5)
                _0x84.Text = "GET TIKTOK KEY"
            end
        end)
    end)
end

_0x1b.RenderStepped:Connect(function()
    pcall(function()
        if not _0x4b then return end
        if not _0x28 and not _0x29 and not _0x27 and not _0x26 and not _0x2d and not _0x2c and not _0x2b and not _0x30 and not _0x31 and not _0x32 then 
            _0x48 = nil 
            _0x49 = nil
            return 
        end
        
        local _0x8c = _0x23.Character and _0x23.Character:FindFirstChild("HumanoidRootPart")
        if not _0x8c then return end
        
        local _0x8d = _0x2f and "Head" or "UpperTorso"
        
        local _0x8e = false
        if _0x48 and _0x48.Parent then
            local _0x8f = _0x48.Parent:FindFirstChildOfClass("Humanoid")
            if _0x8f and _0x8f.Health > 0 then
                if _0x54(_0x48) then
                    _0x8e = true
                end
            end
        end
        
        if not _0x8e then
            local _0x90 = math.huge
            local _0x91 = nil
            local _0x92 = _0x1e.CurrentCamera
            
            for _, p in pairs(_0x1a:GetPlayers()) do
                if p ~= _0x23 and p.Character then
                    local _0x93 = p.Character:FindFirstChildOfClass("Humanoid")
                    local _0x94 = p.Character:FindFirstChild(_0x8d) or p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
                    if _0x93 and _0x93.Health > 0 and _0x94 then
                        if _0x54(_0x94) then
                            local _0x95, _0x96 = _0x92:WorldToViewportPoint(_0x94.Position)
                            if _0x96 then
                                local _0x97 = (Vector2.new(_0x95.X, _0x95.Y) - Vector2.new(_0x92.ViewportSize.X / 2, _0x92.ViewportSize.Y / 2)).Magnitude
                                if _0x97 <= _0x46 and _0x97 < _0x90 then
                                    _0x90 = _0x97
                                    _0x91 = _0x94
                                end
                            end
                        end
                    end
                end
            end
            _0x48 = _0x91
        end
        
        if _0x48 then
            local _0x98 = _0x48.Parent
            local _0x99 = _0x98 and _0x98:FindFirstChild("HumanoidRootPart")
            local _0x9a = _0x99 and _0x99.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
            
            local _0x9b = (_0x48.Position - _0x8c.Position).Magnitude
            local _0x9c = _0x9b / 1600 
            local _0x9d = (_0x9a * _0x9c) + Vector3.new(0, 0.5 * 196.2 * (_0x9c ^ 2) * 0.1, 0)
            local _0x9e = _0x48.Position + _0x9d
            
            if not _0x49 then
                _0x49 = _0x9e
            else
                _0x49 = _0x49:Lerp(_0x9e, 0.92)
            end
        else
            _0x49 = nil
        end
    end)
end)

_0x1b.RenderStepped:Connect(function()
    pcall(function()
        if not _0x4b then return end
        local _0x9f = _0x23.Character
        if _0x9f then
            local _0xa0 = _0x9f:FindFirstChildOfClass("Tool")
            if _0xa0 then
                for _, v in pairs(_0xa0:GetDescendants()) do
                    if v:IsA("NumberValue") or v:IsA("DoubleValue") or v:IsA("Vector3Value") then
                        local _0xa1 = v.Name:lower()
                        if (_0x3e and (_0xa1:find("recoil") or _0xa1:find("kick") or _0xa1:find("shake") or _0xa1:find("recoilp"))) or 
                           (_0x3f and (_0xa1:find("spread") or _0xa1:find("accuracy") or _0xa1:find("deviation") or _0xa1:find("pattern"))) then
                            v.Value = 0
                        end
                    end
                end
            end
        end
    end)
end)

_0x1b.RenderStepped:Connect(function()
    pcall(function()
        if not _0x4b or not _0x42 then return end
        local _0xa2 = Color3.fromHSV((tick() % 3) / 3, 1, 1)
        local _0xa3 = _0x23.Character
        if _0xa3 then
            local _0xa4 = _0xa3:FindFirstChildOfClass("Tool")
            if _0xa4 then
                for _, v in pairs(_0xa4:GetDescendants()) do
                    if v:IsA("BasePart") or v:IsA("MeshPart") then
                        v.Color = _0xa2
                    end
                end
            end
        end
    end)
end)

local _0xa5 = _0x20:FindFirstChild("RayV3ColorCorrection") or Instance.new("ColorCorrectionEffect")
_0xa5.Name = "RayV3ColorCorrection"
_0xa5.Parent = _0x20
_0xa5.Enabled = false

_0x1b.RenderStepped:Connect(function()
    pcall(function()
        if not _0x4b then return end
        if _0x43 == "Purple" then
            _0x20.Ambient = Color3.fromRGB(135, 20, 145)
            _0x20.OutdoorAmbient = Color3.fromRGB(95, 12, 105)
            _0xa5.Enabled = true
            _0xa5.TintColor = Color3.fromRGB(240, 170, 250)
            _0xa5.Saturation = 0.35
        elseif _0x43 == "Red" then
            _0x20.Ambient = Color3.fromRGB(160, 45, 45)
            _0x20.OutdoorAmbient = Color3.fromRGB(130, 25, 25)
            _0xa5.Enabled = true
            _0xa5.TintColor = Color3.fromRGB(255, 180, 180)
            _0xa5.Saturation = 0.3
        elseif _0x43 == "Blue" then
            _0x20.Ambient = Color3.fromRGB(35, 50, 165)
            _0x20.OutdoorAmbient = Color3.fromRGB(25, 35, 130)
            _0xa5.Enabled = true
            _0xa5.TintColor = Color3.fromRGB(160, 185, 255)
            _0xa5.Saturation = 0.25
        else
            _0x20.Ambient = Color3.fromRGB(128, 128, 128)
            _0x20.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            _0xa5.Enabled = false
        end
    end)
end)

local _0xa6 = Instance.new("Frame")
_0xa6.Name = "FOVCircle"
_0xa6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
_0xa6.BackgroundTransparency = 0.25 
_0xa6.BorderSizePixel = 0
_0xa6.Position = UDim2.new(0.5, 0, 0.5, 0)
_0xa6.AnchorPoint = Vector2.new(0.5, 0.5)
_0xa6.Size = UDim2.new(0, 300, 0, 300)
_0xa6.Visible = false
_0xa6.Parent = _0x6f

local _0xa7 = Instance.new("UICorner") _0xa7.CornerRadius = UDim.new(1, 0) _0xa7.Parent = _0xa6
local _0xa8 = Instance.new("UIStroke") _0xa8.Thickness = 2 _0xa8.Color = Color3.fromRGB(215, 80, 225) _0xa8.Parent = _0xa6

local _0xa9 = Instance.new("UIGradient")
_0xa9.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 90, 235)),   
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(165, 19, 174)), 
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 105, 210))   
})
_0xa9.Rotation = 45
_0xa9.Parent = _0xa6

local _0xaa = Instance.new("Frame")
_0xaa.Name = "RotatingCenterBar"
_0xaa.Size = UDim2.new(0, 120, 0, 4)
_0xaa.Position = UDim2.new(0.5, 0, 0.5, 0)
_0xaa.AnchorPoint = Vector2.new(0.5, 0.5)
_0xaa.BackgroundColor3 = Color3.fromRGB(215, 80, 225)
_0xaa.BorderSizePixel = 0
_0xaa.Parent = _0xa6
local _0xab = Instance.new("UICorner") _0xab.CornerRadius = UDim.new(1, 0) _0xab.Parent = _0xaa

_0x1b.RenderStepped:Connect(function()
    pcall(function()
        if not _0x4b or not _0x27 then return end
        _0xaa.Rotation = (tick() * 120) % 360
        
        if _0x41 == "Gradient" then
            _0xa9.Enabled = true
            _0xa8.Color = Color3.fromRGB(215, 80, 225)
            _0xaa.BackgroundColor3 = Color3.fromRGB(215, 80, 225)
        elseif _0x41 == "Rainbow" then
            _0xa9.Enabled = false
            local _0xac = Color3.fromHSV((tick() % 3) / 3, 1, 1)
            _0xa6.BackgroundColor3 = _0xac
            _0xa8.Color = _0xac
            _0xaa.BackgroundColor3 = _0xac
        end
        
        if _0x48 then
            local _0xad = _0x1e.CurrentCamera
            if _0xad then
                local _0xae, _0xaf = _0xad:WorldToViewportPoint(_0x48.Position)
                if _0xaf then
                    local _0xb0 = UDim2.new(0, _0xae.X, 0, _0xae.Y)
                    _0xa6.Position = _0xa6.Position:Lerp(_0xb0, 0.3)
                end
            end
        else
            _0xa6.Position = _0xa6.Position:Lerp(UDim2.new(0.5, 0, 0.5, 0), 0.2)
        end
    end)
end)

local _0xb1 = Instance.new("TextLabel") _0xb1.Size = UDim2.new(1, -60, 0, 24) _0xb1.Position = UDim2.new(0, 10, 0, 6) _0xb1.BackgroundTransparency = 1 _0xb1.Text = "RayV3 Mobile // RIVALS" _0xb1.TextColor3 = Color3.fromRGB(255, 255, 255) _0xb1.Font = Enum.Font.Code _0xb1.TextSize = 11 _0xb1.TextXAlignment = Enum.TextXAlignment.Left _0xb1.ZIndex = 2 _0xb1.Parent = _0x76
local _0xb2 = Instance.new("UIGradient") _0xb2.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(165, 19, 174)), ColorSequenceKeypoint.new(1, Color3.fromRGB(215, 80, 225))}) _0xb2.Parent = _0xb1

local _0xb3 = Instance.new("Frame") _0xb3.Size = UDim2.new(1, -20, 0, 26) _0xb3.Position = UDim2.new(0, 10, 0, 32) _0xb3.BackgroundTransparency = 1 _0xb3.ZIndex = 2 _0xb3.Parent = _0x76
local _0xb4 = Instance.new("UIListLayout") _0xb4.FillDirection = Enum.FillDirection.Horizontal _0xb4.Padding = UDim.new(0, 4) _0xb4.Parent = _0xb3

local _0xb5, _0xb6 = {}, {}
local function _0xb7(_0xb8, _0xb9)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 78, 1, 0)
    btn.BackgroundColor3 = _0xb9 and Color3.fromRGB(45, 15, 80) or Color3.fromRGB(20, 10, 35)
    btn.Text = _0xb8
    btn.TextColor3 = _0xb9 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 140, 210)
    btn.Font = Enum.Font.Code
    btn.TextSize = 10
    btn.ZIndex = 2
    btn.Parent = _0xb3

    local _0xba = Instance.new("UICorner") _0xba.CornerRadius = UDim.new(0, 4) _0xba.Parent = btn
    local _0xbb = Instance.new("UIStroke") _0xbb.Color = _0xb9 and Color3.fromRGB(165, 19, 174) or Color3.fromRGB(45, 20, 75) _0xbb.Thickness = 1 _0xbb.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -10, 1, -70)
    page.Position = UDim2.new(0, 5, 0, 64)
    page.BackgroundTransparency = 1
    page.Visible = _0xb9
    page.ZIndex = 2
    page.CanvasSize = UDim2.new(0, 0, 0, 600)
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(165, 19, 174)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Parent = _0x76

    _0xb5[_0xb8] = page
    _0xb6[_0xb8] = {btn = btn, stroke = _0xbb}

    btn.MouseButton1Click:Connect(function()
        for name, p in pairs(_0xb5) do
            p.Visible = (name == _0xb8)
            local tb = _0xb6[name]
            tb.btn.BackgroundColor3 = (name == _0xb8) and Color3.fromRGB(45, 15, 80) or Color3.fromRGB(20, 10, 35)
            tb.btn.TextColor3 = (name == _0xb8) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 140, 210)
            tb.stroke.Color = (name == _0xb8) and Color3.fromRGB(165, 19, 174) or Color3.fromRGB(45, 20, 75)
        end
    end)
    return page
end

local _0xbc = _0xb7("Main", true)
local _0xbd = _0xb7("Combat", false)
local _0xbe = _0xb7("ESP", false)
local _0xbf = _0xb7("Misc", false)

local function _0xc0(page)
    local left = Instance.new("Frame") left.Size = UDim2.new(0.485, 0, 1, 0) left.BackgroundTransparency = 1 left.ZIndex = 2 left.Parent = page
    local _0xc1 = Instance.new("UIListLayout") _0xc1.Padding = UDim.new(0, 6) _0xc1.SortOrder = Enum.SortOrder.LayoutOrder _0xc1.Parent = left
    local right = Instance.new("Frame") right.Size = UDim2.new(0.485, 0, 1, 0) right.Position = UDim2.new(0.515, 0, 0, 0) right.BackgroundTransparency = 1 right.ZIndex = 2 right.Parent = page
    local _0xc2 = Instance.new("UIListLayout") _0xc2.Padding = UDim.new(0, 6) _0xc2.SortOrder = Enum.SortOrder.LayoutOrder _0xc2.Parent = right
    return left, right
end

local _0xc3, _0xc4 = _0xc0(_0xbc)
local _0xc5, _0xc6 = _0xc0(_0xbd)
local _0xc7, _0xc8 = _0xc0(_0xbe)
local _0xc9, _0xca = _0xc0(_0xbf)

local function _0xcb(parent, titleText)
    local sec = Instance.new("Frame")
    sec.AutomaticSize = Enum.AutomaticSize.Y
    sec.Size = UDim2.new(1, 0, 0, 0)
    sec.BackgroundColor3 = Color3.fromRGB(24, 12, 42)
    sec.BackgroundTransparency = 0.25
    sec.BorderSizePixel = 0
    sec.ZIndex = 2
    sec.Parent = parent

    local _0xcc = Instance.new("UICorner") _0xcc.CornerRadius = UDim.new(0, 5) _0xcc.Parent = sec
    local _0xcd = Instance.new("UIStroke") _0xcd.Color = Color3.fromRGB(165, 19, 174) _0xcd.Thickness = 1 _0xcd.Parent = sec
    local _0xce = Instance.new("TextLabel") _0xce.Size = UDim2.new(1, -10, 0, 20) _0xce.Position = UDim2.new(0, 5, 0, 2) _0xce.BackgroundTransparency = 1 _0xce.Text = titleText _0xce.TextColor3 = Color3.fromRGB(210, 180, 255) _0xce.Font = Enum.Font.Code _0xce.TextSize = 10 _0xce.TextXAlignment = Enum.TextXAlignment.Left _0xce.ZIndex = 2 _0xce.Parent = sec
    local _0xcf = Instance.new("Frame") _0xcf.Size = UDim2.new(1, -10, 0, 1) _0xcf.Position = UDim2.new(0, 5, 0, 22) _0xcf.BackgroundColor3 = Color3.fromRGB(165, 19, 174) _0xcf.BorderSizePixel = 0 _0xcf.ZIndex = 2 _0xcf.Parent = sec

    local container = Instance.new("Frame")
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.Size = UDim2.new(1, -10, 0, 0)
    container.Position = UDim2.new(0, 5, 0, 25)
    container.BackgroundTransparency = 1
    container.ZIndex = 2
    container.Parent = sec

    local _0xd0 = Instance.new("UIListLayout") _0xd0.Padding = UDim.new(0, 4) _0xd0.SortOrder = Enum.SortOrder.LayoutOrder _0xd0.Parent = container
    local _0xd1 = Instance.new("UIPadding") _0xd1.PaddingBottom = UDim.new(0, 5) _0xd1.Parent = sec
    return container
end

local _0xd2 = _0xcb(_0xc3, "Movement")
local _0xd3 = _0xcb(_0xc4, "Desync & Wallbang")
local _0xd4 = _0xcb(_0xc5, "Aimbot & Rage")
local _0xd5 = _0xcb(_0xc6, "Auto & Trigger")
local _0xd6 = _0xcb(_0xc7, "ESP Features")
local _0xd7 = _0xcb(_0xc9, "Inputs & Config")
local _0xd8 = _0xcb(_0xca, "Weapon & Theme")
local _0xd9 = _0xcb(_0xc9, "Device Spoof")

local function _0xda(parent, text, order, defaultState)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 26)
    btn.BackgroundTransparency = 1
    btn.Text = (defaultState and "[✔] " or "[ ] ")..text
    btn.TextColor3 = defaultState and Color3.fromRGB(210, 180, 255) or Color3.fromRGB(160, 150, 180)
    btn.Font = Enum.Font.Code
    btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = order
    btn.ZIndex = 2
    btn.Parent = parent
    return btn
end

local function _0xdb(btn, state, name)
    btn.Text = (state and "[✔] " or "[ ] ")..name
    btn.TextColor3 = state and Color3.fromRGB(210, 180, 255) or Color3.fromRGB(160, 150, 180)
end

local _0xdc = _0xda(_0xd2, "Fly", 1, false)
local _0xdd = _0xda(_0xd2, "Noclip", 2, false)
local _0xde = _0xda(_0xd2, "Target Feet TP (Prone)", 3, false)
local _0xdf = _0xda(_0xd2, "Void (Position Exploit)", 4, false)
local _0xe0 = _0xda(_0xd2, "Orbit Evasion", 5, false)

local _0xe1 = _0xda(_0xd3, "Anti-Cheat Bypass (Bulletproof)", 1, true)
local _0xe2 = _0xda(_0xd3, "Anti-Katana (Parry Bypass)", 2, true)
local _0xe3 = _0xda(_0xd3, "Desync + Rage Hit", 3, true)
local _0xe4 = _0xda(_0xd3, "Wallbang & Penetration", 4, true)

local _0xe5 = _0xda(_0xd4, "All-Head", 1, false)
local _0xe6 = _0xda(_0xd4, "Head Lock (Smooth)", 2, false)
local _0xe7 = _0xda(_0xd4, "Rage Bot (Blind / Auto)", 3, false)
local _0xe8 = _0xda(_0xd4, "360 Silent Aim (Bulletproof)", 4, true)
local _0xe9 = _0xda(_0xd4, "FOV Circle", 5, false)
local _0xea = _0xda(_0xd4, "Smart WallCheck", 6, true)

local _0xeb = _0xda(_0xd5, "Auto Fire", 1, false)
local _0xec = _0xda(_0xd5, "Trigger Bot", 2, false)

local _0xed = _0xda(_0xd6, "Skeleton ESP", 1, false)
local _0xee = _0xda(_0xd6, "Corner Box ESP", 2, false)
local _0xef = _0xda(_0xd6, "Name ESP", 3, false)
local _0xf0 = _0xda(_0xd6, "Health ESP", 4, false)

local _0xf1 = _0xda(_0xd8, "Hit Notify Log", 1, true)
local _0xf2 = _0xda(_0xd8, "Hit Sound", 2, true)
local _0xf3 = _0xda(_0xd8, "No Recoil", 3, true)
local _0xf4 = _0xda(_0xd8, "No Spread", 4, true)
local _0xf5 = _0xda(_0xd8, "Custom Skybox", 5, false)
local _0xf6 = _0xda(_0xd8, "Rivals Weapon Fix", 6, true)

local _0xf7 = _0xda(_0xd9, "Device: Mobile", 1, true)
local _0xf8 = _0xda(_0xd9, "Device: Android", 2, false)
local _0xf9 = _0xda(_0xd9, "Device: PC", 3, false)

local _0xfa = _0xda(_0xd7, "FOV Crosshair: Gradient", 4, true)
local _0xfb = _0xda(_0xd7, "FOV Crosshair: Rainbow", 5, false)

local _0xfc = _0xda(_0xd8, "Map Theme: Normal", 7, true)
local _0xfd = _0xda(_0xd8, "Map Theme: Red", 8, false)
local _0xfe = _0xda(_0xd8, "Map Theme: Blue", 9, false)
local _0xff = _0xda(_0xd8, "Map Theme: Deep Purple", 10, false)

local _0x100 = _0xda(_0xd7, "Rainbow Gun Skin", 9, true)
local _0x101 = _0xda(_0xd7, "💾 Save Config", 10, false)
local _0x102 = _0xda(_0xd7, "📂 Load Config", 11, false)

_0xe1.MouseButton1Click:Connect(function() if not _0x4b then return end _0x36 = not _0x36 _0xdb(_0xe1, _0x36, "Anti-Cheat Bypass (Bulletproof)") end)
_0xe2.MouseButton1Click:Connect(function() if not _0x4b then return end _0x35 = not _0x35 _0xdb(_0xe2, _0x35, "Anti-Katana (Parry Bypass)") end)
_0xe3.MouseButton1Click:Connect(function() if not _0x4b then return end _0x2b = not _0x2b _0xdb(_0xe3, _0x2b, "Desync + Rage Hit") end)
_0xe4.MouseButton1Click:Connect(function() if not _0x4b then return end _0x2c = not _0x2c _0xdb(_0xe4, _0x2c, "Wallbang & Penetration") end)
_0xde.MouseButton1Click:Connect(function() if not _0x4b then return end _0x30 = not _0x30 _0xdb(_0xde, _0x30, "Target Feet TP (Prone)") end)
_0xdf.MouseButton1Click:Connect(function() if not _0x4b then return end _0x31 = not _0x31 _0xdb(_0xdf, _0x31, "Void (Position Exploit)") end)
_0xe0.MouseButton1Click:Connect(function() if not _0x4b then return end _0x32 = not _0x32 _0xdb(_0xe0, _0x32, "Orbit Evasion") end)

_0xe5.MouseButton1Click:Connect(function() if not _0x4b then return end _0x2f = not _0x2f _0xdb(_0xe5, _0x2f, "All-Head") end)
_0xe7.MouseButton1Click:Connect(function() if not _0x4b then return end _0x28 = not _0x28 _0xdb(_0xe7, _0x28, "Rage Bot (Blind / Auto)") end)
_0xe8.MouseButton1Click:Connect(function() if not _0x4b then return end _0x2a = not _0x2a _0xdb(_0xe8, _0x2a, "360 Silent Aim (Bulletproof)") end)
_0xeb.MouseButton1Click:Connect(function() if not _0x4b then return end _0x25 = not _0x25 _0xdb(_0xeb, _0x25, "Auto Fire") end)
_0xec.MouseButton1Click:Connect(function() if not _0x4b then return end _0x33 = not _0x33 _0xdb(_0xec, _0x33, "Trigger Bot") end)
_0xea.MouseButton1Click:Connect(function() if not _0x4b then return end _0x3d = not _0x3d _0xdb(_0xea, _0x3d, "Smart WallCheck") end)

_0xed.MouseButton1Click:Connect(function() if not _0x4b then return end _0x39 = not _0x39 _0xdb(_0xed, _0x39, "Skeleton ESP") end)
_0xee.MouseButton1Click:Connect(function() if not _0x4b then return end _0x38 = not _0x38 _0xdb(_0xee, _0x38, "Corner Box ESP") end)
_0xef.MouseButton1Click:Connect(function() if not _0x4b then return end _0x3a = not _0x3a _0xdb(_0xef, _0x3a, "Name ESP") end)
_0xf0.MouseButton1Click:Connect(function() if not _0x4b then return end _0x3b = not _0x3b _0xdb(_0xf0, _0x3b, "Health ESP") end)

_0xf1.MouseButton1Click:Connect(function() if not _0x4b then return end _0x3c = not _0x3c _0xdb(_0xf1, _0x3c, "Hit Notify Log") end)
_0xf2.MouseButton1Click:Connect(function() if not _0x4b then return end _0x34 = not _0x34 _0xdb(_0xf2, _0x34, "Hit Sound") end)
_0xf3.MouseButton1Click:Connect(function() if not _0x4b then return end _0x3e = not _0x3e _0xdb(_0xf3, _0x3e, "No Recoil") end)
_0xf4.MouseButton1Click:Connect(function() if not _0x4b then return end _0x3f = not _0x3f _0xdb(_0xf4, _0x3f, "No Spread") end)
_0xf5.MouseButton1Click:Connect(function() if not _0x4b then return end _0x34 = not _0x34 _0xdb(_0xf5, _0x34, "Custom Skybox") end)
_0xf6.MouseButton1Click:Connect(function() if not _0x4b then return end _0x37 = not _0x37 _0xdb(_0xf6, _0x37, "Rivals Weapon Fix") end)

_0xf7.MouseButton1Click:Connect(function()
    if not _0x4b then return end
    _0x40 = "Mobile"
    _0xdb(_0xf7, true, "Device: Mobile")
    _0xdb(_0xf8, false, "Device: Android")
    _0xdb(_0xf9, false, "Device: PC")
end)

_0xf8.MouseButton1Click:Connect(function()
    if not _0x4b then return end
    _0x40 = "Android"
    _0xdb(_0xf7, false, "Device: Mobile")
    _0xdb(_0xf8, true, "Device: Android")
    _0xdb(_0xf9, false, "Device: PC")
end)

_0xf9.MouseButton1Click:Connect(function()
    if not _0x4b then return end
    _0x40 = "PC"
    _0xdb(_0xf7, false, "Device: Mobile")
    _0xdb(_0xf8, false, "Device: Android")
    _0xdb(_0xf9, true, "Device: PC")
end)

_0xfa.MouseButton1Click:Connect(function()
    if not _0x4b then return end
    _0x41 = "Gradient"
    _0xdb(_0xfa, true, "FOV Crosshair: Gradient")
    _0xdb(_0xfb, false, "FOV Crosshair: Rainbow")
end)

_0xfb.MouseButton1Click:Connect(function()
    if not _0x4b then return end
    _0x41 = "Rainbow"
    _0xdb(_0xfa, false, "FOV Crosshair: Gradient")
    _0xdb(_0xfb, true, "FOV Crosshair: Rainbow")
end)

_0xfc.MouseButton1Click:Connect(function()
    if not _0x4b then return end
    _0x43 = "Normal"
    _0xdb(_0xfc, true, "Map Theme: Normal")
    _0xdb(_0xfd, false, "Map Theme: Red")
    _0xdb(_0xfe, false, "Map Theme: Blue")
    _0xdb(_0xff, false, "Map Theme: Deep Purple")
end)

_0xfd.MouseButton1Click:Connect(function()
    if not _0x4b then return end
    _0x43 = "Red"
    _0xdb(_0xfc, false, "Map Theme: Normal")
    _0xdb(_0xfd, true, "Map Theme: Red")
    _0xdb(_0xfe, false, "Map Theme: Blue")
    _0xdb(_0xff, false, "Map Theme: Deep Purple")
end)

_0xfe.MouseButton1Click:Connect(function()
    if not _0x4b then return end
    _0x43 = "Blue"
    _0xdb(_0xfc, false, "Map Theme: Normal")
    _0xdb(_0xfd, false, "Map Theme: Red")
    _0xdb(_0xfe, true, "Map Theme: Blue")
    _0xdb(_0xff, false, "Map Theme: Deep Purple")
end)

_0xff.MouseButton1Click:Connect(function()
    if not _0x4b then return end
    _0x43 = "Purple"
    _0xdb(_0xfc, false, "Map Theme: Normal")
    _0xdb(_0xfd, false, "Map Theme: Red")
    _0xdb(_0xfe, false, "Map Theme: Blue")
    _0xdb(_0xff, true, "Map Theme: Deep Purple")
end)

_0x100.MouseButton1Click:Connect(function()
    if not _0x4b then return end
    _0x42 = not _0x42
    _0xdb(_0x100, _0x42, "Rainbow Gun Skin")
end)

_0x101.MouseButton1Click:Connect(function()
    if not _0x4b then return end
    _0x50()
    _0x101.Text = "[✔] Saved!"
    task.delay(1.5, function()
        _0x101.Text = "💾 Save Config"
    end)
end)

_0x102.MouseButton1Click:Connect(function()
    if not _0x4b then return end
    _0x52()
    _0x102.Text = "[✔] Loaded!"
    task.delay(1.5, function()
        _0x102.Text = "📂 Load Config"
    end)
end)

local function _0x103(parent, titleText, defaultText, order)
    local container = Instance.new("Frame") container.Size = UDim2.new(1, -4, 0, 38) container.BackgroundTransparency = 1 container.ZIndex = 2 container.LayoutOrder = order container.Parent = parent
    local label = Instance.new("TextLabel") label.Size = UDim2.new(1, 0, 0, 14) label.Text = titleText label.BackgroundTransparency = 1 label.TextColor3 = Color3.fromRGB(200, 170, 240) label.Font = Enum.Font.Code label.TextSize = 9 label.TextXAlignment = Enum.TextXAlignment.Left label.ZIndex = 2 label.Parent = container
    local input = Instance.new("TextBox") input.Size = UDim2.new(1, 0, 0, 22) input.Position = UDim2.new(0, 0, 0, 14) input.BackgroundColor3 = Color3.fromRGB(24, 12, 42) input.TextColor3 = Color3.fromRGB(210, 180, 255) input.Font = Enum.Font.Code input.TextSize = 10 input.Text = defaultText input.ClearTextOnFocus = false input.ZIndex = 2 input.Parent = container
    local cornerIn = Instance.new("UICorner") cornerIn.CornerRadius = UDim.new(0, 4) cornerIn.Parent = input
    local boxStroke = Instance.new("UIStroke") boxStroke.Color = Color3.fromRGB(165, 19, 174) boxStroke.Thickness = 1 boxStroke.Parent = input
    return input
end

local _0x104 = _0x103(_0xd7, "Fire Delay", tostring(_0x47), 1)
local _0x105 = _0x103(_0xd7, "Fly Speed", tostring(_0x44), 2)
local _0x106 = _0x103(_0xd7, "FOV Radius", tostring(_0x46), 3)

_0x72.MouseButton1Click:Connect(function() 
    if not _0x4b then return end 
    _0x24 = not _0x24 
    _0x76.Visible = _0x24 
end)

_0x105.FocusLost:Connect(function()
    local num = tonumber(_0x105.Text)
    if num then _0x44 = math.clamp(num, 1, 500) end
    _0x105.Text = tostring(_0x44)
end)

_0x106.FocusLost:Connect(function()
    local num = tonumber(_0x106.Text)
    if num then _0x46 = math.clamp(num, 50, 800) _0xa6.Size = UDim2.new(0, _0x46, 0, _0x46) end
    _0x106.Text = tostring(_0x46)
end)

_0x104.FocusLost:Connect(function()
    local num = tonumber(_0x104.Text)
    if num then _0x47 = math.clamp(num, 0.01, 10.0) end
    _0x104.Text = tostring(_0x47)
end)

_0x1b.Stepped:Connect(function()
    pcall(function()
        if not _0x4b then return end
        local char = _0x23.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            if _0xdd or _0x36 or _0x2c or _0x30 or _0x31 or _0x32 then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
            
            if _0x31 then
                root.CFrame = root.CFrame + Vector3.new(0, -300, 0)
                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            elseif _0x30 and _0x48 then
                local targetRoot = _0x48.Parent:FindFirstChild("HumanoidRootPart") or _0x48.Parent:FindFirstChild("Torso")
                if targetRoot then
                    local feetPos = targetRoot.Position - Vector3.new(0, 2.8, 0)
                    root.CFrame = CFrame.new(feetPos, targetRoot.Position + Vector3.new(0, -2.8, 0) + targetRoot.CFrame.LookVector * 2) * CFrame.Angles(math.rad(90), 0, 0)
                    root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
            elseif _0x32 then
                _0x4d = _0x4d + 0.06
                local patrolX = math.sin(_0x4d) * 35
                local patrolZ = math.cos(_0x4d * 0.8) * 35
                local undergroundY = -16 + (math.sin(_0x4d * 2.5) * 4)
                root.CFrame = CFrame.new(patrolX, undergroundY, patrolZ)
                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
            
            if _0x2b and not _0x30 and not _0x31 and not _0x32 then
                if math.random(1, 4) == 1 then
                    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity + Vector3.new(math.random(-_0x45, _0x45), 0, math.random(-_0x45, _0x45))
                end
            end
        end
    end)
end)

_0x1b.RenderStepped:Connect(function()
    pcall(function()
        if not _0x4b or not _0x37 then return end
        local cam = _0x1e.CurrentCamera
        if cam then
            for _, child in pairs(cam:GetChildren()) do
                if child:IsA("Model") or child:IsA("BasePart") then
                    for _, part in pairs(child:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.LocalTransparencyModifier = 0
                            part.Transparency = 0
                        end
                    end
                end
            end
        end
    end)
end)

local function _0x107()
    if not _0x34 then return end
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://9060603816"
        sound.Volume = 1
        sound.Parent = _0x21
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 1.5)
    end)
end

local function _0x108(targetName, damageDealt)
    if not _0x3c then return end
    pcall(function()
        local notif = Instance.new("TextLabel")
        notif.Size = UDim2.new(0, 200, 0, 24)
        notif.Position = UDim2.new(1, -215, 0.45, math.random(-40, 40))
        notif.BackgroundColor3 = Color3.fromRGB(16, 8, 28)
        notif.TextColor3 = Color3.fromRGB(215, 80, 225)
        notif.Font = Enum.Font.Code
        notif.TextSize = 10
        notif.TextXAlignment = Enum.TextXAlignment.Center
        notif.Text = "[HIT] " .. tostring(targetName) .. " (-" .. tostring(damageDealt) .. " HP)"
        notif.Parent = _0x6f
        
        local st = Instance.new("UIStroke", notif)
        st.Color = Color3.fromRGB(165, 19, 174)
        st.Thickness = 1
        local cornerNotif = Instance.new("UICorner", notif)
        cornerNotif.CornerRadius = UDim.new(0, 4)
        
        game:GetService("Debris"):AddItem(notif, 0.9)
    end)
end

_0x1b.RenderStepped:Connect(function()
    pcall(function()
        if not _0x4b or not _0x33 or _0x24 then return end
        local mouse = _0x23:GetMouse()
        local target = mouse.Target
        if target and target.Parent then
            local enemyHum = target.Parent:FindFirstChildOfClass("Humanoid")
            if enemyHum and enemyHum.Health > 0 and _0x1a:GetPlayerFromCharacter(target.Parent) ~= _0x23 then
                _0x1d:Button1Down(Vector2.new(0,0), _0x1e.CurrentCamera.CFrame)
                task.wait(0.01)
                _0x1d:Button1Up(Vector2.new(0,0), _0x1e.CurrentCamera.CFrame)
            end
        end
    end)
end)

task.spawn(function()
    while true do
        pcall(function()
            if _0x24 then
                _0x4a = 0
                task.wait(0.2)
                return
            end
            if _0x4b and (_0x25 or _0x28 or _0x2a or _0x2b) then
                local char = _0x23.Character
                if char and _0x48 then
                    local hum = _0x48.Parent:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local currentHP = hum.Health
                        if _0x4a == 0 then _0x4a = currentHP end

                        local targetPlayer = _0x1a:GetPlayerFromCharacter(_0x48.Parent)
                        local targetName = targetPlayer and targetPlayer.Name or _0x48.Parent.Name
                        
                        _0x1d:Button1Down(Vector2.new(0,0), _0x1e.CurrentCamera.CFrame)
                        
                        if currentHP < _0x4a then
                            local damage = math.round(_0x4a - currentHP)
                            if damage > 0 then
                                _0x108(targetName, damage)
                                _0x107()
                            end
                        end
                        _0x4a = currentHP

                        task.wait(0.01)
                        _0x1d:Button1Up(Vector2.new(0,0), _0x1e.CurrentCamera.CFrame)
                    else
                        _0x4a = 0
                    end
                end
                task.wait(_0x47)
            else
                _0x4a = 0
                task.wait(0.3)
            end
        end)
        task.wait(0.05)
    end
end)

-- [Blind Automatic RageBot Core - Camera Unlocked / Silent Tracking]
_0x1b:BindToRenderStep("RayEliteMobileRageBotLogic", Enum.RenderPriority.Camera.Value + 1, function()
    pcall(function()
        if not _0x4b or _0x24 then return end
        local cam = _0x1e.CurrentCamera
        if not cam then return end
        
        -- Smooth Aimbot keeps camera look, whereas RageBot now runs fully blind/automatic without locking opponent view
        if _0x26 and _0x48 and not _0x30 and not _0x32 and not _0x2b then
            local targetCF = CFrame.lookAt(cam.CFrame.Position, _0x49 or _0x48.Position)
            cam.CFrame = cam.CFrame:Lerp(targetCF, 0.96)
        end
    end)
end)

local _0x109 = {}
_0x1b.RenderStepped:Connect(function()
    pcall(function()
        if not _0x4b or not _0x39 then
            for _, lines in pairs(_0x109) do
                for _, line in pairs(lines) do line.Visible = false end
            end
            return
        end
        
        local cam = _0x1e.CurrentCamera
        if not cam then return end
        
        for _, p in pairs(_0x1a:GetPlayers()) do
            if p ~= _0x23 and p.Character then
                local char = p.Character
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    if not _0x109[p] then
                        pcall(function()
                            _0x109[p] = {
                                HeadToTorso = Drawing.new("Line"),
                            }
                            for _, line in pairs(_0x109[p]) do
                                line.Thickness = 1.5
                                line.Color = Color3.fromRGB(215, 80, 225)
                                line.Visible = false
                            end
                        end)
                    end
                    
                    local lines = _0x109[p]
                    if lines and lines.HeadToTorso then
                        local head = char:FindFirstChild("Head")
                        local torso = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
                        
                        if head and torso then
                            local headPos, headVis = cam:WorldToViewportPoint(head.Position)
                            local torsoPos, torsoVis = cam:WorldToViewportPoint(torso.Position)
                            
                            if headVis and torsoVis then
                                lines.HeadToTorso.From = Vector2.new(headPos.X, headPos.Y)
                                lines.HeadToTorso.To = Vector2.new(torsoPos.X, torsoPos.Y)
                                lines.HeadToTorso.Visible = true
                            else
                                lines.HeadToTorso.Visible = false
                            end
                        else
                            lines.HeadToTorso.Visible = false
                        end
                    end
                else
                    if _0x109[p] then
                        for _, line in pairs(_0x109[p]) do line.Visible = false end
                    end
                end
            end
        end
    end)
end)

local _0x10a, _0x10b
local function _0x10c()
    pcall(function()
        local char = _0x23.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        _0xdc = true
        _0xdb(_0xdc, _0xdc, "Fly")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = true end
        _0x10a = Instance.new("BodyVelocity", char.HumanoidRootPart) _0x10a.MaxForce = Vector3.new(math.huge, math.huge, math.huge) _0x10a.Velocity = Vector3.new(0, 0, 0)
        _0x10b = Instance.new("BodyGyro", char.HumanoidRootPart) _0x10b.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) _0x10b.CFrame = char.HumanoidRootPart.CFrame
    end)
end

local function _0x10d()
    pcall(function()
        _0xdc = false
        _0xdb(_0xdc, _0xdc, "Fly")
        local char = _0x23.Character
        if char then local hum = char:FindFirstChildOfClass("Humanoid") if hum then hum.PlatformStand = false end end
        if _0x10a then _0x10a:Destroy() end
        if _0x10b then _0x10b:Destroy() end
    end)
end

_0xdc.MouseButton1Click:Connect(function() if not _0x4b then return end if _0xdc then _0x10d() else _0x10c() end end)
_0xdd.MouseButton1Click:Connect(function() if not _0x4b then return end _0xdd = not _0xdd _0xdb(_0xdd, _0xdd, "Noclip") end)
_0xe6.MouseButton1Click:Connect(function() if not _0x4b then return end _0x26 = not _0x26 _0xdb(_0xe6, _0x26, "Head Lock (Smooth)") end)
_0xe9.MouseButton1Click:Connect(function() if not _0x4b then return end _0x27 = not _0x27 _0xdb(_0xe9, _0x27, "FOV Circle") _0xa6.Visible = _0x27 end)

local _0x10e, _0x10f = pcall(function() return require(_0x23:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")) end)
local _0x110 = _0x10e and _0x10f:GetControls() or nil

_0x1b.RenderStepped:Connect(function()
    pcall(function()
        if not _0x4b then return end
        local cam = _0x1e.CurrentCamera
        if _0xdc and _0x23.Character and _0x23.Character:FindFirstChild("HumanoidRootPart") and cam and _0x110 then
            local moveVector = _0x110:GetMoveVector()
            if _0x10a and _0x10b then
                _0x10b.CFrame = cam.CFrame
                if moveVector.Magnitude > 0 then
                    local moveDir = (cam.CFrame.RightVector * moveVector.X) - (cam.CFrame.LookVector * moveVector.Z)
                    _0x10a.Velocity = moveDir * _0x44
                else 
                    _0x10a.Velocity = Vector3.new(0, 0, 0) 
                end
            end
        end
    end)
end)

_0x23.CharacterAdded:Connect(function() if _0x4b and _0xdc then task.wait(0.5) _0x10c() end end)
