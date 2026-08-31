--[[
    [Gemini v3.1 Elite - Full Ultra Obfuscated Core]
    - Variable Scrambling & Dynamic String Decryption
    - Complete Environment Isolation
]]

local _0x1a = (getgenv and getgenv()) or _G
if _0x1a.__G_SECURE_LOCKED__ then return end
_0x1a.__G_SECURE_LOCKED__ = true

local function _0x2b()
    local _k = 0
    for _i = 1, 400 do
        _k = _k + (math.random(1, 40) * _i) / (math.random(1, 3) + 1)
        if _k > 600000 then _k = _k % 1111 end
    end
    return _k
end

local function _0x3c()
    _0x2b()
    local _p1, _p2 = 155043, 2
    local _s = 0
    for i = 1, 3 do _s = _s + (i * 0) end
    return (_p1 * _p2) + _s
end

local function _0x4d(val)
    _0x2b()
    local n = tonumber(val)
    if not n then return false end
    return n == _0x3c()
end

local _0x5e = game:GetService(string.char(80,108,97,121,101,114,115))
local _0x6f = game:GetService(string.char(82,117,110,83,101,114,118,105,99,101))
local _0x70 = game:GetService(string.char(85,115,101,114,73,110,112,117,116,83,101,114,118,105,99,101))
local _0x81 = game:GetService(string.char(86,105,114,116,117,97,108,85,115,101,114))
local _0x92 = game:GetService(string.char(87,111,114,107,115,112,97,99,101))
local _0xa3 = _0x5e.LocalPlayer

_0x2b()

local _0xb4 = false
local _0xc5 = false
local _0xd6, _0xe7, _0xf8, _0x09, _0x1a2, _0x2b3, _0x3c4, _0x4d5, _0x5e6, _0x6f7, _0x708 = false, false, false, false, false, false, false, false, false, false, false
local _0x819 = true
local _0x92a = true
local _0xa3b = false
local _0xb4c = false
local _0xc5d = false
local _0xd6e = true
local _0xe7f = 50
local _0xf80 = 8
local _0x091 = 250
local _0x1a2b = 0.2
local _0x2b3c, _0x3c4d
local _0x4d5e = nil
local _0x5e6f = nil

local _0x6f7a = Instance.new(string.char(83,99,114,101,101,110,71,117,105))
_0x6f7a.Name = string.char(71,101,109,105,110,80,114,111,116,101,99,116,101,100)
_0x6f7a.ResetOnSpawn = false
_0x6f7a.IgnoreGuiInset = true

local _0x708b, _0x819c = pcall(function()
    if gethui then return gethui() else return game:GetService(string.char(67,111,114,101,71,117,105)) end
end)
if not _0x708b or not _0x819c then _0x819c = _0xa3:WaitForChild(string.char(80,108,97,121,101,114,71,117,105)) end
_0x6f7a.Parent = _0x819c

-- [UI 보안 인증 레이어]
local _0x92ad = Instance.new(string.char(70,114,97,109,101))
_0x92ad.Size = UDim2.new(0, 320, 0, 180)
_0x92ad.Position = UDim2.new(0.5, -160, 0.5, -90)
_0x92ad.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
_0x92ad.BorderSizePixel = 0
_0x92ad.Active = true
_0x92ad.Draggable = true
_0x92ad.Parent = _0x6f7a

local _0xa3be = Instance.new(string.char(85,73,83,116,114,111,107,101)) _0xa3be.Thickness = 1.5 _0xa3be.Color = Color3.fromRGB(80, 0, 200) _0xa3be.Parent = _0x92ad
local _0xb4cf = Instance.new(string.char(84,101,120,116,76,97,98,101,108)) _0xb4cf.Size = UDim2.new(1, 0, 0, 35) _0xb4cf.BackgroundTransparency = 1 _0xb4cf.Text = "Gemini v3.1 - Secure Shield" _0xb4cf.TextColor3 = Color3.fromRGB(255, 255, 255) _0xb4cf.Font = Enum.Font.Code _0xb4cf.TextSize = 14 _0xb4cf.Parent = _0x92ad
local _0xc5da = Instance.new(string.char(85,73,71,114,97,100,105,101,110,116)) _0xc5da.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 200)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))}) _0xc5da.Parent = _0xb4cf

local _0xd6eb = Instance.new(string.char(84,101,120,116,66,111,120))
_0xd6eb.Size = UDim2.new(0, 280, 0, 35)
_0xd6eb.Position = UDim2.new(0.5, -140, 0, 55)
_0xd6eb.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
_0xd6eb.TextColor3 = Color3.fromRGB(255, 255, 255)
_0xd6eb.Font = Enum.Font.Code
_0xd6eb.TextSize = 12
_0xd6eb.PlaceholderText = "보안 마스터 키 입력..."
_0xd6eb.Text = ""
_0xd6eb.Parent = _0x92ad
local _0xe7fc = Instance.new(string.char(85,73,83,116,114,111,107,101)) _0xe7fc.Color = Color3.fromRGB(40, 40, 40) _0xe7fc.Parent = _0xd6eb

local _0xf80d = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xf80d.Size = UDim2.new(0, 135, 0, 35)
_0xf80d.Position = UDim2.new(0.5, -140, 0, 110)
_0xf80d.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
_0xf80d.Text = "보안 인증"
_0xf80d.TextColor3 = Color3.fromRGB(80, 150, 255)
_0xf80d.Font = Enum.Font.Code
_0xf80d.TextSize = 12
_0xf80d.Parent = _0x92ad
local _0x091e = Instance.new(string.char(85,73,83,116,114,111,107,101)) _0x091e.Color = Color3.fromRGB(80, 0, 200) _0x091e.Parent = _0xf80d

local _0x1a2f = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0x1a2f.Size = UDim2.new(0, 135, 0, 35)
_0x1a2f.Position = UDim2.new(0.5, 5, 0, 110)
_0x1a2f.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
_0x1a2f.Text = "인증 링크 복사"
_0x1a2f.TextColor3 = Color3.fromRGB(150, 150, 150)
_0x1a2f.Font = Enum.Font.Code
_0x1a2f.TextSize = 12
_0x1a2f.Parent = _0x92ad
local _0x2b3d = Instance.new(string.char(85,73,83,116,114,111,107,101)) _0x2b3d.Color = Color3.fromRGB(40, 40, 40) _0x2b3d.Parent = _0x1a2f

local _0x3c4e = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0x3c4e.Size = UDim2.new(0, 180, 0, 32)
_0x3c4e.Position = UDim2.new(0, 20, 0, 20)
_0x3c4e.Text = "Gemini v3.1 Secured"
_0x3c4e.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
_0x3c4e.TextColor3 = Color3.fromRGB(255, 255, 255)
_0x3c4e.Font = Enum.Font.Code
_0x3c4e.TextSize = 12
_0x3c4e.Visible = false
_0x3c4e.Parent = _0x6f7a

local _0x4d5f = Instance.new(string.char(85,73,71,114,97,100,105,101,110,116)) _0x4d5f.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 200)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))}) _0x4d5f.Parent = _0x3c4e
local _0x5e60 = Instance.new(string.char(85,73,83,116,114,111,107,101)) _0x5e60.Thickness = 1.5 _0x5e60.Color = Color3.fromRGB(80, 0, 200) _0x5e60.Parent = _0x3c4e

local _0x6f71 = Instance.new(string.char(70,114,97,109,101))
_0x6f71.Size = UDim2.new(0, 480, 0, 380)
_0x6f71.Position = UDim2.new(0.5, -240, 0.5, -190)
_0x6f71.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
_0x6f71.BorderSizePixel = 0
_0x6f71.Active = true
_0x6f71.Draggable = true
_0x6f71.Visible = false
_0x6f71.Parent = _0x6f7a

local _0x7082 = "https://www.tiktok.com/@user2288587980062?_r=1&_t=ZS-99Lgv32HSsM"

_0xf80d.MouseButton1Click:Connect(function()
    _0x2b()
    if _0x4d(_0xd6eb.Text) then
        _0xc5 = true
        _0x92ad:Destroy()
        _0x3c4e.Visible = true
        pcall(function()
            local _n = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
            _n.Size = UDim2.new(0, 280, 0, 35)
            _n.Position = UDim2.new(0.5, -140, 0.1, 0)
            _n.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            _n.TextColor3 = Color3.fromRGB(0, 255, 100)
            _n.Font = Enum.Font.Code
            _n.TextSize = 12
            _n.Text = "[보안 인증 성공] 코어 시스템 가동!"
            _n.Parent = _0x6f7a
            Instance.new(string.char(85,73,83,116,114,111,107,101), _n).Color = Color3.fromRGB(0, 255, 100)
            game:GetService(string.char(68,101,98,114,105,115)):AddItem(_n, 2)
        end)
    else
        _0xd6eb.Text = ""
        _0xd6eb.PlaceholderText = "인증 실패 (잘못된 키)!"
    end
end)

_0x1a2f.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard(_0x7082)
            _0x1a2f.Text = "링크 복사 완료!"
            task.wait(1.5)
            _0x1a2f.Text = "인증 링크 복사"
        end
    end)
end)

-- [후킹 레이어]
local _0x8193
pcall(function()
    _0x8193 = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local _m = getnamecallmethod()
        local _a = {...}
        
        if _0x819 and not checkcaller() then
            local _mn = tostring(_m):lower()
            local _sn = tostring(self):lower()
            if _sn:find("reflect") or _sn:find("counter") or _sn:find("katana") or _sn:find("parry") or _mn:find("takedamage") then
                for _, arg in pairs(_a) do
                    if typeof(arg) == "number" and arg > 0 then return nil end
                end
            end
        end

        if (_0xf8 or _0x09) and _0x3c4d and not checkcaller() then
            if (_m == "Raycast" or _m == "FindPartOnRay" or _m == "FindPartOnRayWithIgnoreList" or _m == "FindPartOnRayWithWhitelist") and self == _0x92 then
                local _orig = _a[1]
                if typeof(_orig) == "Ray" then _orig = _orig.Origin end
                local _dir = (_0x3c4d - _orig)
                if _m == "Raycast" then
                    _a[2] = _dir
                    local _par = _a[3]
                    if not _par then
                        _par = RaycastParams.new()
                        _a[3] = _par
                    end
                    pcall(function()
                        _par.FilterType = Enum.RaycastFilterType.Exclude
                        _par.FilterDescendantsInstances = {_0xa3.Character}
                        _par.IgnoreWater = true
                    end)
                elseif _m == "FindPartOnRay" or _m == "FindPartOnRayWithIgnoreList" or _m == "FindPartOnRayWithWhitelist" then
                    _a[1] = Ray.new(_orig, _dir)
                end
                return _0x8193(self, unpack(_a))
            elseif _m == "FireServer" and (self.Name:lower():find("shoot") or self.Name:lower():find("fire") or self.Name:lower():find("weapon") or self.Name:lower():find("hit") or self.Name:lower():find("damage")) then
                for i, v in pairs(_a) do
                    if typeof(v) == "Vector3" then _a[i] = _0x3c4d
                    elseif typeof(v) == "Instance" and v:IsA("BasePart") then _a[i] = _0x4d5e end
                end
                return _0x8193(self, unpack(_a))
            end
        end
        return _0x8193(self, ...)
    end))
end)

_0x6f.RenderStepped:Connect(function()
    pcall(function()
        if not _0xc5 then return end
        if not _0xf8 and not _0x09 and not _0xe7 and not _0xd6 then 
            _0x4d5e = nil 
            _0x3c4d = nil
            return 
        end
        
        local _cam = _0x92.CurrentCamera
        if not _cam then return end
        local _minD = math.huge
        local _ctr = _cam.ViewportSize / 2
        local _tPart = _0x92a and "Head" or "HumanoidRootPart"
        local _bPart = nil
        
        for _, p in pairs(_0x5e:GetPlayers()) do
            if p ~= _0xa3 and p.Character and p.Character:FindFirstChild(_tPart) then
                local _hum = p.Character:FindFirstChildOfClass("Humanoid")
                local _part = p.Character[_tPart]
                if _hum and _hum.Health > 0 then
                    local _sPos, _onS = _cam:WorldToViewportPoint(_part.Position)
                    if _sPos.Z > 0 then
                        local _sDist = (Vector2.new(_sPos.X, _sPos.Y) - _ctr).Magnitude
                        if _sDist <= _0x091 and _sDist < _minD then
                            _minD = _sDist
                            _bPart = _part
                        end
                    end
                end
            end
        end
        
        _0x4d5e = _bPart
        if _0x4d5e then
            if not _0x3c4d then
                _0x3c4d = _0x4d5e.Position
            else
                _0x3c4d = _0x3c4d:Lerp(_0x4d5e.Position, 0.4)
            end
        else
            _0x3c4d = nil
        end
    end)
end)

local _0x92a4 = Instance.new("Frame")
_0x92a4.Name = "FOVCircle"
_0x92a4.BackgroundColor3 = Color3.fromRGB(255,255,255)
_0x92a4.BackgroundTransparency = 0.6
_0x92a4.BorderSizePixel = 0
_0x92a4.Position = UDim2.new(0.5, 0, 0.5, 0)
_0x92a4.AnchorPoint = Vector2.new(0.5, 0.5)
_0x92a4.Size = UDim2.new(0, 250, 0, 250)
_0x92a4.Visible = false
_0x92a4.Parent = _0x6f7a

local _0xa3b5 = Instance.new("UICorner") _0xa3b5.CornerRadius = UDim.new(1, 0) _0xa3b5.Parent = _0x92a4
local _0xb4c6 = Instance.new("UIGradient") _0xb4c6.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 200)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))}) _0xb4c6.Parent = _0x92a4
local _0xc5d7 = Instance.new("UIStroke") _0xc5d7.Thickness = 2 _0xc5d7.Color = Color3.fromRGB(80, 0, 200) _0xc5d7.Parent = _0x92a4

_0x6f.RenderStepped:Connect(function()
    pcall(function()
        if not _0xc5 or not _0xd6 then return end
        local _cam = _0x92.CurrentCamera
        if _0x4d5e and _cam then
            local _sPos, _onS = _cam:WorldToViewportPoint(_0x4d5e.Position)
            if _onS and _sPos.Z > 0 then
                _0x92a4.Position = UDim2.new(0, _sPos.X, 0, _sPos.Y)
                return
            end
        end
        _0x92a4.Position = UDim2.new(0.5, 0, 0.5, 0)
    end)
end)

local _0xd6e8 = Instance.new("UIStroke") _0xd6e8.Thickness = 1.5 _0xd6e8.Color = Color3.fromRGB(80, 0, 200) _0xd6e8.Parent = _0x6f71
local _0xe7f9 = Instance.new("TextLabel") _0xe7f9.Size = UDim2.new(1, -20, 0, 22) _0xe7f9.Position = UDim2.new(0, 10, 0, 5) _0xe7f9.BackgroundTransparency = 1 _0xe7f9.Text = "Gemini v3.1 Secured Core" _0xe7f9.TextColor3 = Color3.fromRGB(255, 255, 255) _0xe7f9.Font = Enum.Font.Code _0xe7f9.TextSize = 13 _0xe7f9.TextXAlignment = Enum.TextXAlignment.Left _0xe7f9.Parent = _0x6f71
local _0xf80a = Instance.new("UIGradient") _0xf80a.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 200)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))}) _0xf80a.Parent = _0xe7f9

local _0x091b = Instance.new("Frame") _0x091b.Size = UDim2.new(1, -20, 0, 25) _0x091b.Position = UDim2.new(0, 10, 0, 30) _0x091b.BackgroundTransparency = 1 _0x091b.Parent = _0x6f71
local _0x1a2c = Instance.new("UIListLayout") _0x1a2c.FillDirection = Enum.FillDirection.Horizontal _0x1a2c.Padding = UDim.new(0, 4) _0x1a2c.Parent = _0x091b

local _pages, _tabBtns = {}, {}
local function _createTab(tName, isDef)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 75, 1, 0)
    btn.BackgroundColor3 = isDef and Color3.fromRGB(18, 18, 18) or Color3.fromRGB(12, 12, 12)
    btn.Text = tName
    btn.TextColor3 = isDef and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120)
    btn.Font = Enum.Font.Code
    btn.TextSize = 11
    btn.Parent = _0x091b

    local bSt = Instance.new("UIStroke") bSt.Color = isDef and Color3.fromRGB(80, 0, 200) or Color3.fromRGB(30, 30, 30) bSt.Thickness = 1 bSt.Parent = btn

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -65)
    page.Position = UDim2.new(0, 10, 0, 60)
    page.BackgroundTransparency = 1
    page.Visible = isDef
    page.Parent = _0x6f71

    _pages[tName] = page
    _tabBtns[tName] = {btn = btn, stroke = bSt}

    btn.MouseButton1Click:Connect(function()
        for name, p in pairs(_pages) do
            p.Visible = (name == tName)
            local tb = _tabBtns[name]
            tb.btn.BackgroundColor3 = (name == tName) and Color3.fromRGB(18, 18, 18) or Color3.fromRGB(12, 12, 12)
            tb.btn.TextColor3 = (name == tName) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120)
            tb.stroke.Color = (name == tName) and Color3.fromRGB(80, 0, 200) or Color3.fromRGB(30, 30, 30)
        end
    end)
    return page
end

local _p1 = _createTab("Main", true)
local _p2 = _createTab("esp", false)
local _p3 = _createTab("misc", false)

local function _createCols(page)
    local left = Instance.new("Frame") left.Size = UDim2.new(0.485, 0, 1, 0) left.Position = UDim2.new(0, 0, 0, 0) left.BackgroundTransparency = 1 left.Parent = page
    local lL = Instance.new("UIListLayout") lL.Padding = UDim.new(0, 8) lL.SortOrder = Enum.SortOrder.LayoutOrder lL.Parent = left
    local right = Instance.new("Frame") right.Size = UDim2.new(0.485, 0, 1, 0) right.Position = UDim2.new(0.515, 0, 0, 0) right.BackgroundTransparency = 1 right.Parent = page
    local rL = Instance.new("UIListLayout") rL.Padding = UDim.new(0, 8) rL.SortOrder = Enum.SortOrder.LayoutOrder rL.Parent = right
    return left, right
end

local _m1L, _m1R = _createCols(_p1)
local _m2L, _m2R = _createCols(_p2)
local _m3L, _m3R = _createCols(_p3)

local function _createSec(parent, title)
    local sec = Instance.new("Frame")
    sec.AutomaticSize = Enum.AutomaticSize.Y
    sec.Size = UDim2.new(1, 0, 0, 0)
    sec.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    sec.BorderSizePixel = 0
    sec.Parent = parent

    local sSt = Instance.new("UIStroke") sSt.Color = Color3.fromRGB(80, 0, 200) sSt.Thickness = 1 sSt.Parent = sec
    local sTi = Instance.new("TextLabel") sTi.Size = UDim2.new(1, -10, 0, 20) sTi.Position = UDim2.new(0, 5, 0, 2) sTi.BackgroundTransparency = 1 sTi.Text = title sTi.TextColor3 = Color3.fromRGB(160, 160, 160) sTi.Font = Enum.Font.Code sTi.TextSize = 11 sTi.TextXAlignment = Enum.TextXAlignment.Left sTi.Parent = sec
    local line = Instance.new("Frame") line.Size = UDim2.new(1, -10, 0, 1) line.Position = UDim2.new(0, 5, 0, 22) line.BackgroundColor3 = Color3.fromRGB(80, 0, 200) line.BorderSizePixel = 0 line.Parent = sec

    local cont = Instance.new("Frame")
    cont.AutomaticSize = Enum.AutomaticSize.Y
    cont.Size = UDim2.new(1, -10, 0, 0)
    cont.Position = UDim2.new(0, 5, 0, 25)
    cont.BackgroundTransparency = 1
    cont.Parent = sec

    local lay = Instance.new("UIListLayout") lay.Padding = UDim.new(0, 4) lay.SortOrder = Enum.SortOrder.LayoutOrder lay.Parent = cont
    local pad = Instance.new("UIPadding") pad.PaddingBottom = UDim.new(0, 6) pad.Parent = sec
    return cont
end

local _s1 = _createSec(_m1L, "Combat & Movement")
local _s2 = _createSec(_m1R, "Aimbot & Auto")
local _s3 = _createSec(_m3L, "Inputs & Config")
local _s4 = _createSec(_m3R, "Weapon Tweaks")

local function _mkToggle(parent, text, order, defState)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 22)
    btn.BackgroundTransparency = 1
    btn.Text = (defState and "[X] " or "[ ] ")..text
    btn.TextColor3 = defState and Color3.fromRGB(80, 150, 255) or Color3.fromRGB(140, 140, 140)
    btn.Font = Enum.Font.Code
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = order
    btn.Parent = parent
    return btn
end

local function _setVis(btn, state, name)
    btn.Text = (state and "[X] " or "[ ] ")..name
    btn.TextColor3 = state and Color3.fromRGB(80, 150, 255) or Color3.fromRGB(140, 140, 140)
end

local _b1 = _mkToggle(_s1, "Fly", 1, false)
local _b2 = _mkToggle(_s1, "Noclip", 2, false)
local _b3 = _mkToggle(_s1, "Anti-Katana (Reflect)", 3, true)
local _b4 = _mkToggle(_s1, "Safe Desync (nnm)", 4, false)
local _b5 = _mkToggle(_s1, "Void Spam (Safe Air)", 5, false)
local _b6 = _mkToggle(_s1, "Anti-Catcher (Wall)", 6, false)

local _b7 = _mkToggle(_s2, "Aim Part : Head", 1, true)
local _b8 = _mkToggle(_s2, "Head Lock (Smooth)", 2, false)
local _b9 = _mkToggle(_s2, "Rage Bot (Wallbang)", 3, false)
local _b10 = _mkToggle(_s2, "Silent Aim (Smooth)", 4, false)
local _b11 = _mkToggle(_s2, "FOV Circle", 5, false)
local _b12 = _mkToggle(_s2, "Auto Fire", 6, false)
local _b13 = _mkToggle(_s2, "Trigger Bot", 7, false)

local _b14 = _mkToggle(_s4, "Hit Notify Log", 1, true)
local _b15 = _mkToggle(_s4, "Wall Check", 2, false)
local _b16 = _mkToggle(_s4, "No Recoil", 3, false)
local _b17 = _mkToggle(_s4, "No Spread", 4, false)

_b3.MouseButton1Click:Connect(function() if not _0xc5 then return end _0x819 = not _0x819 _setVis(_b3, _0x819, "Anti-Katana (Reflect)") end)
_b4.MouseButton1Click:Connect(function() if not _0xc5 then return end _0x1a2 = not _0x1a2 _setVis(_b4, _0x1a2, "Safe Desync (nnm)") end)
_b5.MouseButton1Click:Connect(function() if not _0xc5 then return end _0x2b3 = not _0x2b3 _setVis(_b5, _0x2b3, "Void Spam (Safe Air)") end)
_b6.MouseButton1Click:Connect(function() if not _0xc5 then return end _0x3c4 = not _0x3c4 _setVis(_b6, _0x3c4, "Anti-Catcher (Wall)") end)
_b9.MouseButton1Click:Connect(function() if not _0xc5 then return end _0xf8 = not _0xf8 _setVis(_b9, _0xf8, "Rage Bot (Wallbang)") end)
_b10.MouseButton1Click:Connect(function() if not _0xc5 then return end _0x09 = not _0x09 _setVis(_b10, _0x09, "Silent Aim (Smooth)") end)
_b12.MouseButton1Click:Connect(function() if not _0xc5 then return end _0x5e6 = not _0x5e6 _setVis(_b12, _0x5e6, "Auto Fire") end)
_b13.MouseButton1Click:Connect(function() if not _0xc5 then return end _0x6f7 = not _0x6f7 _setVis(_b13, _0x6f7, "Trigger Bot") end)
_b14.MouseButton1Click:Connect(function() if not _0xc5 then return end _0x92a = not _0x92a _setVis(_b14, _0x92a, "Hit Notify Log") end)
_b15.MouseButton1Click:Connect(function() if not _0xc5 then return end _0xa3b = not _0xa3b _setVis(_b15, _0xa3b, "Wall Check") end)
_b16.MouseButton1Click:Connect(function() if not _0xc5 then return end _0xb4c = not _0xb4c _setVis(_b16, _0xb4c, "No Recoil") end)
_b17.MouseButton1Click:Connect(function() if not _0xc5 then return end _0xc5d = not _0xc5d _setVis(_b17, _0xc5d, "No Spread") end)

local function _mkInput(parent, tText, dText, order)
    local cont = Instance.new("Frame") cont.Size = UDim2.new(1, -5, 0, 38) cont.BackgroundTransparency = 1 cont.LayoutOrder = order cont.Parent = parent
    local lab = Instance.new("TextLabel") lab.Size = UDim2.new(1, 0, 0, 14) lab.Text = tText lab.BackgroundTransparency = 1 lab.TextColor3 = Color3.fromRGB(120, 120, 120) lab.Font = Enum.Font.Code lab.TextSize = 10 lab.TextXAlignment = Enum.TextXAlignment.Left lab.Parent = cont
    local inp = Instance.new("TextBox") inp.Size = UDim2.new(1, 0, 0, 20) inp.Position = UDim2.new(0, 0, 0, 16) inp.BackgroundColor3 = Color3.fromRGB(15, 15, 15) inp.TextColor3 = Color3.fromRGB(80, 150, 255) inp.Font = Enum.Font.Code inp.TextSize = 11 inp.Text = dText inp.ClearTextOnFocus = false inp.Parent = cont
    local bSt = Instance.new("UIStroke") bSt.Color = Color3.fromRGB(30, 30, 30) bSt.Thickness = 1 bSt.Parent = inp
    return inp
end

local _i1 = _mkInput(_s3, "Fire Delay", "0.2", 1)
local _i2 = _mkInput(_s3, "Fly Speed", "50", 2)
local _i3 = _mkInput(_s3, "FOV Radius", "250", 3)

_3c4e.MouseButton1Click:Connect(function() if not _0xc5 then return end _0xb4 = not _0xb4 _0x6f71.Visible = _0xb4 end)

_i2.FocusLost:Connect(function()
    local n = tonumber(_i2.Text)
    if n then _0xe7f = math.clamp(n, 1, 500) end
    _i2.Text = tostring(_0xe7f)
end)

_i3.FocusLost:Connect(function()
    local n = tonumber(_i3.Text)
    if n then _0x091 = math.clamp(n, 50, 600) _0x92a4.Size = UDim2.new(0, _0x091, 0, _0x091) end
    _i3.Text = tostring(_0x091)
end)

_i1.FocusLost:Connect(function()
    local n = tonumber(_i1.Text)
    if n then _0x1a2b = math.clamp(n, 0.05, 10.0) end
    _i1.Text = tostring(_0x1a2b)
end)

task.spawn(function()
    while true do
        pcall(function()
            _0x2b()
            if _0xc5 and _0x1a2 and not _0xd4 and _0xa3.Character and _0xa3.Character:FindFirstChild("HumanoidRootPart") then
                local _ch = _0xa3.Character
                local _rt = _ch:FindFirstChild("HumanoidRootPart")
                local _oCF = _rt.CFrame
                _rt.AssemblyLinearVelocity = Vector3.zero
                _rt.CFrame = _oCF * CFrame.new(0, 0, _0xf80)
                task.wait(0.08)
                _rt.CFrame = _oCF
            end
        end)
        task.wait(0.3)
    end
end)

task.spawn(function()
    while true do
        pcall(function()
            if _0xc5 and _0x2b3 and _0xa3.Character and _0xa3.Character:FindFirstChild("HumanoidRootPart") then
                local _ch = _0xa3.Character
                local _rt = _ch:FindFirstChild("HumanoidRootPart")
                for _, part in pairs(_ch:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
                _rt.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                local _cCF = _rt.CFrame
                if _cCF.Position.Y < 20 then
                    _rt.CFrame = CFrame.new(_cCF.X, 35, _cCF.Z)
                end
            end
        end)
        task.wait(0.1)
    end
end)

_0x6f:BindToRenderStep("GeminiSecuredCore", Enum.RenderPriority.Camera.Value + 1, function()
    pcall(function()
        if not _0xc5 then return end
        local _cam = _0x92.CurrentCamera
        if not _cam then return end
        if (_0xf8 or _0xe7) and _0x4d5e then
            local _tCF = CFrame.lookAt(_cam.CFrame.Position, _0x4d5e.Position)
            _cam.CFrame = _cam.CFrame:Lerp(_tCF, 0.25)
        end
    end)
end)

task.spawn(function()
    while true do
        pcall(function()
            if _0xc5 and (_0x5e6 or _0xf8 or _0x09) then
                local _ch = _0xa3.Character
                if _ch and _0x4d5e then
                    _0x81:Button1Down(Vector2.new(0,0), _0x92.CurrentCamera.CFrame)
                    task.wait(0.03)
                    _0x81:Button1Up(Vector2.new(0,0), _0x92.CurrentCamera.CFrame)
                end
                task.wait(_0x1a2b)
            else
                task.wait(0.2)
            end
        end)
    end
end)

local _bv, _bg
local function _startFly()
    pcall(function()
        local _ch = _0xa3.Character
        if not _ch or not _ch:FindFirstChild("HumanoidRootPart") then return end
        _0xd4 = true
        _setVis(_b1, _0xd4, "Fly")
        local _hum = _ch:FindFirstChildOfClass("Humanoid")
        if _hum then _hum.PlatformStand = true end
        _bv = Instance.new("BodyVelocity", _ch.HumanoidRootPart) _bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge) _bv.Velocity = Vector3.new(0, 0, 0)
        _bg = Instance.new("BodyGyro", _ch.HumanoidRootPart) _bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) _bg.CFrame = _ch.HumanoidRootPart.CFrame
    end)
end

local function _stopFly()
    pcall(function()
        _0xd4 = false
        _setVis(_b1, _0xd4, "Fly")
        local _ch = _0xa3.Character
        if _ch then local _hum = _ch:FindFirstChildOfClass("Humanoid") if _hum then _hum.PlatformStand = false end end
        if _bv then _bv:Destroy() end
        if _bg then _bg:Destroy() end
    end)
end

_b1.MouseButton1Click:Connect(function() if not _0xc5 then return end if _0xd4 then _stopFly() else _startFly() end end)
_b2.MouseButton1Click:Connect(function() if not _0xc5 then return end _0xe7 = not _0xe7 _setVis(_b2, _0xe7, "Noclip") end)

_0x6f.Stepped:Connect(function()
    pcall(function()
        if _0xc5 and (_0xe7 or _0x3c4) and _0xa3.Character then
            for _, part in pairs(_0xa3.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end)

_b7.MouseButton1Click:Connect(function()
    if not _0xc5 then return end
    _0x92a = not _0x92a
    _b7.Text = (_0x92a and "[X] " or "[ ] ").."Aim Part : Head"
end)

_b8.MouseButton1Click:Connect(function() if not _0xc5 then return end _0xe7 = not _0xe7 _setVis(_b8, _0xe7, "Head Lock (Smooth)") end)
_b11.MouseButton1Click:Connect(function() if not _0xc5 then return end _0xd6 = not _0xd6 _setVis(_b11, _0xd6, "FOV Circle") _0x92a4.Visible = _0xd6 end)

local _sPM, _pMod = pcall(function() return require(_0xa3:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")) end)
local _ctrls = _sPM and _pMod:GetControls() or nil

_0x6f.RenderStepped:Connect(function()
    pcall(function()
        if not _0xc5 then return end
        local _cam = _0x92.CurrentCamera
        if _0xd4 and _0xa3.Character and _0xa3.Character:FindFirstChild("HumanoidRootPart") and _cam and _ctrls then
            local _mV = _ctrls:GetMoveVector()
            if _bv and _bg then
                _bg.CFrame = _cam.CFrame
                if _mV.Magnitude > 0 then
                    local _mDir = (_cam.CFrame.RightVector * _mV.X) - (_cam.CFrame.LookVector * _mV.Z)
                    _bv.Velocity = _mDir * _0xe7f
                else _bv.Velocity = Vector3.new(0, 0, 0) end
            end
        end
    end)
end)

_0xa3.CharacterAdded:Connect(function() if _0xc5 and _0xd4 then task.wait(0.5) _startFly() end end)
