--[[ 
    RayV3 Virtualization & Obfuscation Engine v4.1 (Protected Layer)
    Target: Rivals Integrated Script
]]
local _0x_G = (getgenv and getgenv()) or _G;
if _0x_G._RayV3_VirtualMachine_Loaded then return end;
_0x_G._RayV3_VirtualMachine_Loaded = true;

local function _0x_dec(...)
    local _0x_args = {...}
    local _0x_res = ""
    for _0x_i = 1, #_0x_args do
        _0x_res = _0x_res .. string.char(_0x_args[_0x_i] - 7)
    end
    return _0x_res
end

local _0x_srv = function(_0x_name)
    return game:GetService(_0x_name)
end

local _0x_plrs = _0x_srv(_0x_dec(119, 115, 104, 128, 108, 122, 123))
local _0x_reps = _0x_srv(_0x_dec(89, 108, 119, 112, 118, 108, 104, 127, 108, 122, 90, 121, 118, 110, 110, 112, 111))
local _0x_runs = _0x_srv(_0x_dec(89, 124, 117, 108, 90, 108, 121, 125, 108, 110))
local _0x_ws   = _0x_srv(_0x_dec(96, 121, 108, 106, 123, 121, 104, 108))
local _0x_http = _0x_srv(_0x_dec(79, 123, 123, 111, 86, 112, 111, 110, 108, 110))
local _0x_user = _0x_srv(_0x_dec(92, 124, 117, 110, 113, 109, 110, 123, 86, 112, 111, 110, 108, 110))

repeat task.wait() until _0x_plrs.LocalPlayer
local _0x_lplr = _0x_plrs.LocalPlayer

local _0x_sP, _0x_cG = pcall(function()
    if gethui then return gethui() else return _0x_srv(_0x_dec(74, 118, 121, 108, 78, 124, 112)) end
end)

if not _0x_sP or not _0x_cG then
    _0x_cG = _0x_lplr:WaitForChild(_0x_dec(87, 115, 104, 108, 125, 108, 121, 74, 124, 124))
end

pcall(function()
    local _0x_stbl
    _0x_stbl = hookfunction(getrenv().setmetatable, newcclosure(function(_0x_tbl, _0x_mt)
        if _0x_mt and typeof(_0x_mt) == _0x_dec(123, 104, 111, 107, 119, 108) and rawget(_0x_mt, _0x_dec(95, 95, 116, 118, 108, 108)) == _0x_dec(114, 126) then
            local _0x_tr = debug.traceback()
            if _0x_tr and (_0x_tr:find(_0x_dec(84, 112, 122, 108, 104, 108, 121, 118, 99, 118, 118, 123, 121, 115, 108, 121)) or _0x_tr:find(_0x_dec(104, 117, 108, 112, 106, 108, 104, 123)) or _0x_tr:find(_0x_dec(75, 108, 123, 104, 108, 99, 123, 112, 111, 110))) then
                return _0x_stbl({1, 2, 3}, {})
            end
        end
        return _0x_stbl(_0x_tbl, _0x_mt)
    end))
end)

coroutine.wrap(function()
    pcall(function()
        local function _0x_proc(_0x_o)
            pcall(function()
                if _0x_o:IsA(_0x_dec(83, 118, 104, 99, 115, 108, 121, 106, 112, 114, 110)) or _0x_o:IsA(_0x_dec(84, 118, 111, 117, 119, 108, 79, 108, 121, 106, 112, 114, 110)) then
                    local _0x_s, _0x_nm = pcall(function() return _0x_o.Name:lower() end)
                    if not _0x_s or not _0x_nm then return end
                    local _0x_tags = {_0x_dec(104, 117, 108, 112, 106, 108, 104, 123), _0x_dec(104, 100), _0x_dec(107, 108, 123, 108, 104, 123, 112, 111, 110), _0x_dec(105, 104, 117), _0x_dec(114, 112, 106, 114), _0x_dec(122, 108, 106, 118, 121, 112, 123, 126), _0x_dec(116, 118, 108, 103, 108, 121, 97, 123, 112, 111, 110), _0x_dec(104, 117, 108, 112, 106, 115, 111, 118, 123)}
                    for _0x_i = 1, #_0x_tags do
                        if _0x_nm:find(_0x_tags[_0x_i]) then
                            pcall(function() _0x_o.Disabled = true end)
                            break
                        end
                    end
                end
            end)
        end
        pcall(function()
            local _0x_desc = game:GetDescendants()
            for _0x_i = 1, #_0x_desc do _0x_proc(_0x_desc[_0x_i]) end
        end)
        pcall(function() game.DescendantAdded:Connect(_0x_proc) end)
    end)
end)()

_0x_G.Config = {
    Enabled = true,
    FireRate = 0.0005,
    Aimbot = true,
    RageBot = true,
    SilentAim = true,
    AutoFire = true,
    Triggerbot = false,
    AllHead = true,
    WallCheck = false,
    ShowFOV = true,
    FOVRadius = 170,
    CornerBoxESP = false,
    NameESP = false,
    HealthESP = false,
    HitNotify = true,
    NoRecoil = true,
    NoSpread = true,
    AntiKatana = true,
    AntiCheatBypass = true,
    AntiShot = true,
    AllSkins = false,
    Desync = true,
    Fly = false,
    Noclip = false,
    FlySpeed = 50
}

local _0x_util, _0x_enum, _0x_fc, _0x_sc
pcall(function()
    _0x_util = require(_0x_reps.Modules.Utility)
    _0x_enum = require(_0x_reps.Modules.EnumLibrary)
    if _0x_enum then pcall(function() _0x_enum:WaitForEnumBuilder() end) end
    _0x_fc = require(_0x_lplr.PlayerScripts.Controllers.FighterController)
    _0x_sc = require(_0x_lplr.PlayerScripts.Controllers:WaitForChild(_0x_dec(92, 123, 108, 106, 123, 94, 118, 121, 75, 118, 117, 123, 121, 118, 110, 110, 112, 111)))
end)

local _0x_fGui = Instance.new(_0x_dec(92, 106, 121, 108, 108, 77, 121, 110))
_0x_fGui.Name = _0x_dec(89, 104, 128, 73, 53, 79, 86, 96, 76, 118, 123, 85, 121, 114, 78, 121, 110)
_0x_fGui.ResetOnSpawn = false
_0x_fGui.IgnoreGuiInset = true
_0x_fGui.Parent = _0x_cG

local _0x_fFr = Instance.new(_0x_dec(77, 121, 104, 117, 108))
_0x_fFr.Name = _0x_dec(77, 86, 96, 76, 118, 123, 85, 121, 114)
_0x_fFr.Size = UDim2.new(0, _0x_G.Config.FOVRadius * 2, 0, _0x_G.Config.FOVRadius * 2)
_0x_fFr.AnchorPoint = Vector2.new(0.5, 0.5)
_0x_fFr.Position = UDim2.new(0.5, 0, 0.5, 0)
_0x_fFr.BackgroundTransparency = 0.15
_0x_fFr.Visible = _0x_G.Config.ShowFOV
_0x_fFr.ZIndex = 4
_0x_fFr.Parent = _0x_fGui

local _0x_fCr = Instance.new(_0x_dec(92, 106, 74, 118, 121, 117, 108, 121)) _0x_fCr.CornerRadius = UDim.new(1, 0) _0x_fCr.Parent = _0x_fFr
local _0x_fSt = Instance.new(_0x_dec(92, 106, 92, 123, 121, 118, 111, 108)) _0x_fSt.Thickness = 2 _0x_fSt.Color = Color3.fromRGB(255, 255, 255) _0x_fSt.Parent = _0x_fFr

local _0x_fGr = Instance.new(_0x_dec(92, 106, 78, 121, 104, 107, 110, 108, 117, 110))
_0x_fGr.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 110, 220)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 100, 240)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 120, 255))
})
_0x_fGr.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.1),
    NumberSequenceKeypoint.new(1, 0.5)
})
_0x_fGr.Rotation = 90
_0x_fGr.Parent = _0x_fFr

_0x_runs.RenderStepped:Connect(function()
    pcall(function()
        _0x_fFr.Visible = _0x_G.Config.ShowFOV and _0x_G.Config.Enabled
        if _0x_fFr.Visible then
            local _0x_cam = _0x_ws.CurrentCamera
            local _0x_char = _0x_lplr.Character
            local _0x_tp = nil
            
            if _0x_char then
                local _0x_tool = _0x_char:FindFirstChildOfClass(_0x_dec(91, 118, 118, 115))
                if _0x_tool and _0x_tool:FindFirstChild(_0x_dec(79, 104, 117, 107, 115, 108)) then
                    _0x_tp = _0x_tool.Handle.Position
                end
            end
            
            if _0x_cam and _0x_tp then
                local _0x_sp, _0x_os = _0x_cam:WorldToViewportPoint(_0x_tp + _0x_cam.CFrame.LookVector * 1.5)
                if _0x_os then
                    _0x_fFr.Position = UDim2.new(0, _0x_sp.X, 0, _0x_sp.Y)
                else
                    _0x_fFr.Position = UDim2.new(0.5, 0, 0.5, 0)
                end
            else
                _0x_fFr.Position = UDim2.new(0.5, 0, 0.5, 0)
            end
            
            _0x_fFr.Size = UDim2.new(0, _0x_G.Config.FOVRadius * 2, 0, _0x_G.Config.FOVRadius * 2)
        end
    end)
end)

local _0x_flyConn
local function _0x_updFly(_0x_st)
    _0x_G.Config.Fly = _0x_st
    local _0x_char = _0x_lplr.Character
    if not _0x_char then return end
    local _0x_root = _0x_char:FindFirstChild(_0x_dec(79, 126, 118, 117, 104, 110, 117, 89, 118, 110, 123, 89, 104, 121, 123))
    local _0x_hum = _0x_char:FindFirstChildOfClass(_0x_dec(79, 126, 118, 117, 104, 110, 117, 104, 110, 108))
    if not _0x_root or not _0x_hum then return end

    if _0x_st then
        local _0x_bg = Instance.new(_0x_dec(69, 118, 107, 128, 78, 133, 121, 118))
        _0x_bg.Name = _0x_dec(89, 104, 128, 73, 53, 77, 115, 126, 78, 133, 121, 118)
        _0x_bg.MaxTorque = Vector3.new(90000, 90000, 90000)
        _0x_bg.CFrame = _0x_root.CFrame
        _0x_bg.Parent = _0x_root

        local _0x_bv = Instance.new(_0x_dec(69, 118, 107, 89, 112, 119, 118, 107, 110, 108, 121))
        _0x_bv.Name = _0x_dec(89, 104, 128, 73, 53, 77, 115, 126, 89, 112, 119, 118, 107, 110, 108, 121)
        _0x_bv.MaxForce = Vector3.new(90000, 90000, 90000)
        _0x_bv.Velocity = Vector3.new(0, 0, 0)
        _0x_bv.Parent = _0x_root

        _0x_flyConn = _0x_runs.RenderStepped:Connect(function()
            if not _0x_G.Config.Fly then 
                if _0x_bg then _0x_bg:Destroy() end
                if _0x_bv then _0x_bv:Destroy() end
                if _0x_flyConn then _0x_flyConn:Disconnect() end
                return
            end
            local _0x_cam = _0x_ws.CurrentCamera
            if not _0x_cam then return end
            _0x_hum.PlatformStand = true
            
            local _0x_md = Vector3.new(0, 0, 0)
            if _0x_user:IsKeyDown(Enum.KeyCode.W) then _0x_md = _0x_md + _0x_cam.CFrame.LookVector end
            if _0x_user:IsKeyDown(Enum.KeyCode.S) then _0x_md = _0x_md - _0x_cam.CFrame.LookVector end
            if _0x_user:IsKeyDown(Enum.KeyCode.A) then _0x_md = _0x_md - _0x_cam.CFrame.RightVector end
            if _0x_user:IsKeyDown(Enum.KeyCode.D) then _0x_md = _0x_md + _0x_cam.CFrame.RightVector end
            if _0x_user:IsKeyDown(Enum.KeyCode.Space) then _0x_md = _0x_md + Vector3.new(0, 1, 0) end
            if _0x_user:IsKeyDown(Enum.KeyCode.LeftShift) then _0x_md = _0x_md - Vector3.new(0, 1, 0) end

            _0x_bv.Velocity = _0x_md.Unit * _0x_G.Config.FlySpeed
            _0x_bg.CFrame = _0x_cam.CFrame
        end)
    else
        _0x_hum.PlatformStand = false
        if _0x_root:FindFirstChild(_0x_dec(89, 104, 128, 73, 53, 77, 115, 126, 78, 133, 121, 118)) then _0x_root.RayV3_FlyGyro:Destroy() end
        if _0x_root:FindFirstChild(_0x_dec(89, 104, 128, 73, 53, 77, 115, 126, 89, 112, 119, 118, 107, 110, 108, 121)) then _0x_root.RayV3_FlyVelocity:Destroy() end
        if _0x_flyConn then _0x_flyConn:Disconnect() end
    end
end

_0x_runs.Stepped:Connect(function()
    pcall(function()
        if _0x_G.Config.Noclip then
            local _0x_char = _0x_lplr.Character
            if _0x_char then
                for _, _0x_part in pairs(_0x_char:GetDescendants()) do
                    if _0x_part:IsA(_0x_dec(69, 112, 123, 108, 89, 112, 118, 123)) then
                        _0x_part.CanCollide = false
                    end
                end
            end
        end
    end)
end)

local _0x_hlCont = Instance.new(_0x_dec(77, 121, 104, 117, 108))
_0x_hlCont.Size = UDim2.new(0, 320, 0, 200)
_0x_hlCont.Position = UDim2.new(0, 20, 0.7, 0)
_0x_hlCont.BackgroundTransparency = 1
_0x_hlCont.ZIndex = 5
_0x_hlCont.Parent = _0x_cG

local function _0x_showHitNotif(_0x_tName, _0x_dmg)
    if not _0x_G.Config.HitNotify then return end
    pcall(function()
        local _0x_lbl = Instance.new(_0x_dec(91, 104, 131, 123, 73, 112, 113, 108, 118))
        _0x_lbl.Size = UDim2.new(1, 0, 0, 24)
        _0x_lbl.Position = UDim2.new(0, 0, 1, -25)
        _0x_lbl.BackgroundColor3 = Color3.fromRGB(24, 12, 42)
        _0x_lbl.BackgroundTransparency = 0.2
        _0x_lbl.TextColor3 = Color3.fromRGB(215, 120, 255)
        _0x_lbl.Font = Enum.Font.Code
        _0x_lbl.TextSize = 11
        _0x_lbl.Text = string.format("[%s] 적중 대미지: %d", _0x_tName, _0x_dmg)
        _0x_lbl.ZIndex = 6
        _0x_lbl.Parent = _0x_hlCont

        local _0x_st = Instance.new(_0x_dec(92, 106, 92, 123, 121, 118, 111, 108)) _0x_st.Color = Color3.fromRGB(165, 19, 174) _0x_st.Parent = _0x_lbl
        local _0x_cr = Instance.new(_0x_dec(92, 106, 74, 118, 121, 117, 108, 121)) _0x_cr.CornerRadius = UDim.new(0, 4) _0x_cr.Parent = _0x_lbl

        for _, _0x_ch in pairs(_0x_hlCont:GetChildren()) do
            if _0x_ch:IsA(_0x_dec(91, 104, 131, 123, 73, 112, 113, 108, 118)) and _0x_ch ~= _0x_lbl then
                _0x_ch.Position = _0x_ch.Position - UDim2.new(0, 0, 0, 28)
            end
        end

        task.delay(3, function()
            if _0x_lbl then _0x_lbl:Destroy() end
        end)
    end)
end

local _0x_trHum = {}
_0x_runs.Stepped:Connect(function()
    pcall(function()
        for _, _0x_p in pairs(_0x_plrs:GetPlayers()) do
            if _0x_p ~= _0x_lplr and _0x_p.Character then
                local _0x_hum = _0x_p.Character:FindFirstChildOfClass(_0x_dec(79, 126, 118, 117, 104, 110, 117, 104, 110, 108))
                if _0x_hum and not _0x_trHum[_0x_hum] then
                    _0x_trHum[_0x_hum] = _0x_hum.Health
                    _0x_hum.HealthChanged:Connect(function(_0x_nh)
                        local _0x_oh = _0x_trHum[_0x_hum]
                        if _0x_oh and _0x_nh < _0x_oh then
                            local _0x_d = math.floor(_0x_oh - _0x_nh)
                            if _0x_d > 0 then _0x_showHitNotif(_0x_p.Name, _0x_d) end
                        end
                        _0x_trHum[_0x_hum] = _0x_nh
                    end)
                end
            end
        end
    end)
end)

local function _0x_isVisible(_0x_tPart)
    if not _0x_G.Config.WallCheck then return true end
    local _0x_s, _0x_r = pcall(function()
        local _0x_cam = _0x_ws.CurrentCamera
        if not _0x_cam then return false end
        local _0x_rp = RaycastParams.new()
        _0x_rp.FilterType = Enum.RaycastFilterType.Exclude
        _0x_rp.FilterDescendantsInstances = {_0x_lplr.Character, _0x_cam}
        _0x_rp.IgnoreWater = true
        
        local _0x_orig = _0x_cam.CFrame.Position
        local _0x_dir = _0x_tPart.Position - _0x_orig
        local _0x_rr = _0x_ws:Raycast(_0x_orig, _0x_dir, _0x_rp)
        
        if _0x_rr then
            local _0x_hi = _0x_rr.Instance
            if _0x_hi:IsDescendantOf(_0x_tPart.Parent) then return true end
            return false
        end
        return true
    end)
    return _0x_s and _0x_r or true
end

local function _0x_isEnemy(_0x_p)
    if _0x_p == _0x_lplr then return false end
    pcall(function()
        local _0x_duel = _0x_sc and _0x_sc.CurrentDuelSubject
        local _0x_ld = _0x_duel and _0x_duel:GetDueler(_0x_lplr)
        local _0x_lt = _0x_ld and _0x_ld:Get(_0x_dec(91, 118, 123, 115, 80, 78)) or nil
        if _0x_lt and _0x_duel and _0x_duel.Duelers then
            for _, _0x_dueler in pairs(_0x_duel.Duelers) do
                if _0x_dueler.Player == _0x_p then
                    local _0x_tm = _0x_dueler:Get(_0x_dec(91, 118, 123, 115, 80, 78))
                    return _0x_tm ~= _0x_lt
                end
            end
        end
    end)
    local _0x_pt = _0x_p:GetAttribute(_0x_dec(91, 118, 123, 115, 80, 78))
    local _0x_ltm = _0x_lplr:GetAttribute(_0x_dec(91, 118, 123, 115, 80, 78))
    if _0x_pt and _0x_ltm then return _0x_pt ~= _0x_ltm end
    return true
end

local function _0x_getClosest()
    local _0x_char = _0x_lplr.Character
    if not _0x_char then return nil, nil, nil end
    local _0x_cam = _0x_ws.CurrentCamera
    if not _0x_cam then return nil, nil, nil end
    
    local _0x_mp = _0x_user:GetMouseLocation()
    local _0x_cp, _0x_cr, _0x_ch = nil, nil, nil
    local _0x_cd = _0x_G.Config.FOVRadius
    
    for _, _0x_player in ipairs(_0x_plrs:GetPlayers()) do
        if not _0x_isEnemy(_0x_player) then continue end
        local _0x_pc = _0x_player.Character
        if not _0x_pc then continue end
        local _0x_pr = _0x_pc:FindFirstChild(_0x_dec(79, 126, 118, 117, 104, 110, 117, 89, 118, 110, 123, 89, 104, 121, 123))
        local _0x_ph = _0x_pc:FindFirstChild(_0x_dec(79, 118, 118, 107))
        local _0x_phum = _0x_pc:FindFirstChildWhichIsA(_0x_dec(79, 126, 118, 117, 104, 110, 117, 104, 110, 108))
        if not (_0x_pr and _0x_ph and _0x_phum and _0x_phum.Health > 0) then continue end
        
        if not _0x_isVisible(_0x_ph) then continue end
        
        local _0x_sp, _0x_os = _0x_cam:WorldToViewportPoint(_0x_ph.Position)
        if _0x_os then
            local _0x_dtm = (Vector2.new(_0x_sp.X, _0x_sp.Y) - _0x_mp).Magnitude
            if _0x_dtm <= _0x_cd then
                _0x_cd = _0x_dtm
                _0x_cp = _0x_player
                _0x_cr = _0x_pr
                _0x_ch = _0x_ph
            end
        end
    end
    return _0x_cp, _0x_cr, _0x_ch
end

local _0x_defl = {}
_0x_plrs.PlayerRemoving:Connect(function(_0x_p) _0x_defl[_0x_p] = nil end)

local function _0x_updDefl()
    if not _0x_fc or not _0x_fc.Objects then return end
    for _, _0x_fObj in pairs(_0x_fc.Objects) do
        local _0x_p = _0x_fObj.Player
        if not _0x_p then continue end
        if not _0x_fObj.Entity or not _0x_fObj.Entity:IsAlive() or _0x_fObj:Get(_0x_dec(78, 126, 90, 115, 117, 118, 121, 110, 118, 118, 110, 110)) then
            _0x_defl[_0x_p] = false
            continue
        end
        local _0x_eq = _0x_fObj.EquippedItem
        local _0x_isKat = _0x_eq and _0x_eq.ViewModel and _0x_eq.ViewModel.Name == _0x_dec(78, 118, 123, 118, 117, 118)
        local _0x_isDef = false
        if _0x_isKat then
            _0x_isDef = (_0x_eq._attack_cooldown and _0x_eq._attack_cooldown > tick()) or false
        end
        _0x_defl[_0x_p] = _0x_isDef
    end
end

local _0x_lf = 0
_0x_runs.Heartbeat:Connect(function()
    _0x_updDefl()
    if not _0x_G.Config.Enabled then return end

    pcall(function()
        if _0x_G.Config.Desync then
            local _0x_char = _0x_lplr.Character
            if _0x_char and _0x_char:FindFirstChild(_0x_dec(79, 126, 118, 117, 104, 110, 117, 89, 118, 110, 123, 89, 104, 121, 123)) then
                local _0x_root = _0x_char.HumanoidRootPart
                local _0x_cv = _0x_root.AssemblyLinearVelocity
                local _0x_tv = tick() * 18
                _0x_root.AssemblyLinearVelocity = Vector3.new(math.cos(_0x_tv) * 16, _0x_cv.Y, math.sin(_0x_tv) * 16)
            end
        end
    end)

    local _0x_tp, _0x_tr, _0x_th = _0x_getClosest()
    if not _0x_tp or not _0x_th or not _0x_tr then return end
    if _0x_defl[_0x_tp] then return end

    pcall(function()
        local _0x_lFig = _0x_fc and _0x_fc.LocalFighter
        if _0x_lFig and _0x_lFig.Items then
            for _, _0x_item in pairs(_0x_lFig.Items) do
                pcall(function()
                    if _0x_item.Ammo then _0x_item.Ammo = 999 end
                    if _0x_item.MaxAmmo then _0x_item.MaxAmmo = 999 end
                end)
            end
        end
    end)

    if _0x_G.Config.Aimbot then
        local _0x_cam = _0x_ws.CurrentCamera
        if _0x_cam and _0x_th then
            local _0x_gc = CFrame.new(_0x_cam.CFrame.Position, _0x_th.Position)
            _0x_cam.CFrame = _0x_cam.CFrame:Lerp(_0x_gc, 0.7)
        end
    end

    if _0x_G.Config.RageBot or _0x_G.Config.AutoFire or _0x_G.Config.SilentAim then
        if tick() - _0x_lf < _0x_G.Config.FireRate then return end
        _0x_lf = tick()

        local _0x_lFig = _0x_fc and _0x_fc.LocalFighter
        if not _0x_lFig then return end
        local _0x_item = _0x_lFig.EquippedItem
        if not _0x_item then return end

        local _0x_targetPos = _0x_th.Position
        if not _0x_G.Config.AllHead then
            _0x_targetPos = _0x_tr.Position
        end

        local _0x_spOrigin = _0x_tr.Position + Vector3.new(0, 0.5, 0)
        local _0x_aimCF = CFrame.lookAt(_0x_spOrigin, _0x_targetPos)
        local _0x_targetCF = _0x_th.CFrame
        local _0x_objHeadOff = _0x_th.CFrame:ToObjectSpace(CFrame.new(_0x_targetPos))

        local _0x_cdat = {}
        pcall(function()
            _0x_cdat[utf8.char(1)] = {
                [utf8.char(0)] = _0x_util:EncodeCFrame(_0x_aimCF),
                [utf8.char(1)] = _0x_util:EncodeCFrame(_0x_targetCF),
                [utf8.char(2)] = _0x_th,
                [utf8.char(3)] = _0x_util:EncodeCFrame(_0x_objHeadOff)
            }
            _0x_reps.Remotes.Replication.Fighter.UseItem:FireServer(
                _0x_item:Get(_0x_dec(79, 105, 114, 108, 68, 75, 110)),
                _0x_enum:ToEnum(_0x_dec(90, 123, 108, 119, 113, 111, 110, 110, 112, 118, 110)),
                _0x_cdat,
                nil
            )
        end)
    end
end)

_0x_runs.RenderStepped:Connect(function()
    pcall(function()
        local _0x_char = _0x_lplr.Character
        if _0x_char then
            local _0x_tool = _0x_char:FindFirstChildOfClass(_0x_dec(91, 118, 118, 115))
            if _0x_tool then
                for _, _0x_v in pairs(_0x_tool:GetDescendants()) do
                    if _0x_v:IsA(_0x_dec(85, 123, 118, 110, 108, 89, 108, 119, 123)) or _0x_v:IsA(_0x_dec(75, 118, 124, 111, 118, 89, 108, 119, 123)) or _0x_v:IsA(_0x_dec(93, 108, 121, 110, 121, 108, 90, 108, 119, 123)) then
                        local _0x_nm = _0x_v.Name:lower()
                        if (_0x_G.Config.NoRecoil and (_0x_nm:find(_0x_dec(121, 108, 104, 110, 116, 119)) or _0x_nm:find(_0x_dec(118, 110, 110, 116)) or _0x_nm:find(_0x_dec(122, 109, 108, 108, 110))) or 
                           (_0x_G.Config.NoSpread and (_0x_nm:find(_0x_dec(122, 119, 121, 108, 108, 105)) or _0x_nm:find(_0x_dec(104, 104, 104, 121, 123, 108, 121)) or _0x_nm:find(_0x_dec(107, 108, 124, 118, 104, 123, 118, 110)))) then
                            _0x_v.Value = 0
                        end
                    end
                end
            end
        end
    end)
end)

local _0x_espD = {}
local function _0x_clrEsp()
    for _, _0x_oL in pairs(_0x_espD) do
        for _, _0x_dr in pairs(_0x_oL) do
            pcall(function() _0x_dr:Remove() end)
        end
    end
    _0x_espD = {}
end

_0x_runs.RenderStepped:Connect(function()
    pcall(function()
        if not (_0x_G.Config.CornerBoxESP or _0x_G.Config.NameESP or _0x_G.Config.HealthESP) then
            _0x_clrEsp()
            return
        end

        local _0x_cam = _0x_ws.CurrentCamera
        if not _0x_cam then return end

        local _0x_actP = {}
        for _, _0x_p in pairs(_0x_plrs:GetPlayers()) do
            if _0x_p ~= _0x_lplr and _0x_p.Character then
                local _0x_hum = _0x_p.Character:FindFirstChildOfClass(_0x_dec(79, 126, 118, 117, 104, 110, 117, 104, 110, 108))
                local _0x_root = _0x_p.Character:FindFirstChild(_0x_dec(79, 126, 118, 117, 104, 110, 117, 89, 118, 110, 123, 89, 104, 121, 123))
                if _0x_hum and _0x_hum.Health > 0 and _0x_root then
                    _0x_actP[_0x_p] = true
                    if not _0x_espD[_0x_p] then
                        _0x_espD[_0x_p] = {
                            Box = Drawing.new(_0x_dec(90, 120, 124, 104, 119, 108)),
                            Name = Drawing.new(_0x_dec(91, 104, 131, 123)),
                            HealthBar = Drawing.new(_0x_dec(79, 110, 117, 108)),
                            HealthBarBg = Drawing.new(_0x_dec(79, 110, 117, 108))
                        }
                        _0x_espD[_0x_p].Box.Visible = false
                        _0x_espD[_0x_p].Box.Filled = false
                        _0x_espD[_0x_p].Box.Thickness = 1.5
                        _0x_espD[_0x_p].Box.Color = Color3.fromRGB(215, 80, 225)
                        
                        _0x_espD[_0x_p].Name.Visible = false
                        _0x_espD[_0x_p].Name.Size = 13
                        _0x_espD[_0x_p].Name.Center = true
                        _0x_espD[_0x_p].Name.Outline = true
                        _0x_espD[_0x_p].Name.Color = Color3.fromRGB(255, 255, 255)

                        _0x_espD[_0x_p].HealthBar.Thickness = 2
                        _0x_espD[_0x_p].HealthBar.Visible = false
                        _0x_espD[_0x_p].HealthBarBg.Thickness = 2
                        _0x_espD[_0x_p].HealthBarBg.Visible = false
                        _0x_espD[_0x_p].HealthBarBg.Color = Color3.fromRGB(0, 0, 0)
                    end

                    local _0x_draws = _0x_espD[_0x_p]
                    local _0x_pos, _0x_os = _0x_cam:WorldToViewportPoint(_0x_root.Position)
                    if _0x_os then
                        local _0x_sf = 1 / (_0x_pos.Z * math.tan(math.rad(_0x_cam.FieldOfView / 2)) * 2) * 1000
                        local _0x_w = math.clamp(20 * _0x_sf, 15, 300)
                        local _0x_h = math.clamp(35 * _0x_sf, 25, 500)
                        local _0x_bx = _0x_pos.X - _0x_w / 2
                        local _0x_by = _0x_pos.Y - _0x_h / 2

                        if _0x_G.Config.CornerBoxESP then
                            _0x_draws.Box.Visible = true
                            _0x_draws.Box.Position = Vector2.new(_0x_bx, _0x_by)
                            _0x_draws.Box.Size = Vector2.new(_0x_w, _0x_h)
                        else
                            _0x_draws.Box.Visible = false
                        end

                        if _0x_G.Config.NameESP then
                            _0x_draws.Name.Visible = true
                            _0x_draws.Name.Text = _0x_p.Name
                            _0x_draws.Name.Position = Vector2.new(_0x_pos.X, _0x_by - 18)
                        else
                            _0x_draws.Name.Visible = false
                        end

                        if _0x_G.Config.HealthESP then
                            local _0x_hp = math.clamp(_0x_hum.Health / _0x_hum.MaxHealth, 0, 1)
                            _0x_draws.HealthBarBg.Visible = true
                            _0x_draws.HealthBarBg.From = Vector2.new(_0x_bx - 6, _0x_by + _0x_h)
                            _0x_draws.HealthBarBg.To = Vector2.new(_0x_bx - 6, _0x_by)

                            _0x_draws.HealthBar.Visible = true
                            _0x_draws.HealthBar.From = Vector2.new(_0x_bx - 6, _0x_by + _0x_h)
                            _0x_draws.HealthBar.To = Vector2.new(_0x_bx - 6, _0x_by + (_0x_h * (1 - _0x_hp)))
                            _0x_draws.HealthBar.Color = Color3.fromRGB(0, 255, 100)
                        else
                            _0x_draws.HealthBar.Visible = false
                            _0x_draws.HealthBarBg.Visible = false
                        end
                    else
                        _0x_draws.Box.Visible = false
                        _0x_draws.Name.Visible = false
                        _0x_draws.HealthBar.Visible = false
                        _0x_draws.HealthBarBg.Visible = false
                    end
                end
            end
        end

        for _0x_p, _0x_draws in pairs(_0x_espD) do
            if not _0x_actP[_0x_p] then
                for _, _0x_d in pairs(_0x_draws) do pcall(function() _0x_d:Remove() end) end
                _0x_espD[_0x_p] = nil
            end
        end
    end)
end)

task.spawn(function()
    pcall(function()
        local _0x_mods = _0x_reps:WaitForChild(_0x_dec(76, 118, 117, 118, 110, 108, 123), 10)
        local _0x_cosLib = require(_0x_mods:WaitForChild(_0x_dec(74, 118, 122, 109, 108, 117, 118, 104, 75, 118, 117, 123), 10))
        local _0x_ctrl = _0x_lplr.PlayerScripts.Controllers
        local _0x_datCtrl = require(_0x_ctrl:WaitForChild(_0x_dec(87, 115, 96, 118, 123, 75, 118, 110, 123, 118, 110, 108, 121), 10))

        _0x_cosLib.OwnsCosmeticNormally = function(...)
            if _0x_G.Config.AllSkins then return true end
            return _0x_cosLib.OwnsCosmeticNormally(...)
        end
        _0x_cosLib.OwnsCosmeticUniversally = function(...)
            if _0x_G.Config.AllSkins then return true end
            return _0x_cosLib.OwnsCosmeticUniversally(...)
        end
        _0x_cosLib.OwnsCosmeticForWeapon = function(...)
            if _0x_G.Config.AllSkins then return true end
            return _0x_cosLib.OwnsCosmeticForWeapon(...)
        end

        local _0x_origGet = _0x_datCtrl.Get
        _0x_datCtrl.Get = function(_0x_self, _0x_key)
            local _0x_val = _0x_origGet(_0x_self, _0x_key)
            if _0x_key == _0x_dec(74, 118, 122, 109, 108, 117, 118, 104, 80, 117, 123, 110, 118, 117, 123, 126) and _0x_G.Config.AllSkins then
                local _0x_prx = {}
                if _0x_val then
                    for _0x_k, _0x_v in pairs(_0x_val) do _0x_prx[_0x_k] = _0x_v end
                end
                return setmetatable(_0x_prx, {
                    __index = function(_0x_t, _0x_k) return true end
                })
            end
            return _0x_val
        end
    end)
end)

local _0x_sGui = Instance.new(_0x_dec(92, 106, 121, 108, 108, 77, 121, 110))
_0x_sGui.Name = _0x_dec(89, 104, 128, 73, 53, 91, 118, 123, 114, 110, 108, 122, 80, 110, 123, 108, 104, 110, 108, 103)
_0x_sGui.ResetOnSpawn = false
_0x_sGui.IgnoreGuiInset = true
_0x_sGui.Parent = _0x_cG

local _0x_tBtn = Instance.new(_0x_dec(91, 104, 131, 123, 73, 112, 113, 108, 118))
_0x_tBtn.Size = UDim2.new(0, 175, 0, 45)
_0x_tBtn.Position = UDim2.new(0.82, -150, 0, 20)
_0x_tBtn.Text = "💎 RayV3 Rivals [Secured]"
_0x_tBtn.BackgroundColor3 = Color3.fromRGB(16, 8, 28)
_0x_tBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
_0x_tBtn.Font = Enum.Font.Code
_0x_tBtn.TextSize = 11
_0x_tBtn.Draggable = true
_0x_tBtn.Parent = _0x_sGui

local _0x_tGrad = Instance.new(_0x_dec(92, 106, 78, 121, 104, 107, 110, 108, 117, 110)) _0x_tGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(165, 19, 174)), ColorSequenceKeypoint.new(1, Color3.fromRGB(215, 80, 225))}) _0x_tGrad.Parent = _0x_tBtn
local _0x_tStk = Instance.new(_0x_dec(92, 106, 92, 123, 121, 118, 111, 108)) _0x_tStk.Thickness = 1.5 _0x_tStk.Color = Color3.fromRGB(165, 19, 174) _0x_tStk.Parent = _0x_tBtn
local _0x_tCrn = Instance.new(_0x_dec(92, 106, 74, 118, 121, 117, 108, 121)) _0x_tCrn.CornerRadius = UDim.new(0, 8) _0x_tCrn.Parent = _0x_tBtn

local _0x_mFr = Instance.new(_0x_dec(77, 121, 104, 117, 108))
_0x_mFr.Size = UDim2.new(0, 490, 0, 340)
_0x_mFr.Position = UDim2.new(0.5, -245, 0.5, -170)
_0x_mFr.BackgroundColor3 = Color3.fromRGB(16, 8, 28)
_0x_mFr.BorderSizePixel = 0
_0x_mFr.Active = true
_0x_mFr.Draggable = true
_0x_mFr.Visible = false
_0x_mFr.Parent = _0x_sGui

local _0x_mCrn = Instance.new(_0x_dec(92, 106, 74, 118, 121, 117, 108, 121)) _0x_mCrn.CornerRadius = UDim.new(0, 8) _0x_mCrn.Parent = _0x_mFr
local _0x_mStk = Instance.new(_0x_dec(92, 106, 92, 123, 121, 118, 111, 108)) _0x_mStk.Thickness = 1.5 _0x_mStk.Color = Color3.fromRGB(165, 19, 174) _0x_mStk.Parent = _0x_mFr

local _0x_tBar = Instance.new(_0x_dec(91, 104, 131, 123, 73, 112, 113, 108, 118)) _0x_tBar.Size = UDim2.new(1, -20, 0, 24) _0x_tBar.Position = UDim2.new(0, 10, 0, 6) _0x_tBar.BackgroundTransparency = 1 _0x_tBar.Text = "RayV3 Premium // Desync + Fly + Noclip + Wallbang Integrated" _0x_tBar.TextColor3 = Color3.fromRGB(255, 255, 255) _0x_tBar.Font = Enum.Font.Code _0x_tBar.TextSize = 11 _0x_tBar.TextXAlignment = Enum.TextXAlignment.Left _0x_tBar.ZIndex = 2 _0x_tBar.Parent = _0x_mFr

local _0x_tbBar = Instance.new(_0x_dec(77, 121, 104, 117, 108)) _0x_tbBar.Size = UDim2.new(1, -20, 0, 26) _0x_tbBar.Position = UDim2.new(0, 10, 0, 32) _0x_tbBar.BackgroundTransparency = 1 _0x_tbBar.ZIndex = 2 _0x_tbBar.Parent = _0x_mFr
local _0x_tbLay = Instance.new(_0x_dec(75, 118, 110, 121, 118, 92, 108, 110, 104, 108, 121)) _0x_tbLay.FillDirection = Enum.FillDirection.Horizontal _0x_tbLay.Padding = UDim.new(0, 4) _0x_tbLay.Parent = _0x_tbBar

local _0x_pages, _0x_tabBtns = {}, {}
local function _0x_crtTab(_0x_tName, _0x_isDef)
    local _0x_btn = Instance.new(_0x_dec(91, 104, 131, 123, 73, 112, 113, 108, 118))
    _0x_btn.Size = UDim2.new(0, 95, 1, 0)
    _0x_btn.BackgroundColor3 = _0x_isDef and Color3.fromRGB(45, 15, 80) or Color3.fromRGB(20, 10, 35)
    _0x_btn.Text = _0x_tName
    _0x_btn.TextColor3 = _0x_isDef and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 140, 210)
    _0x_btn.Font = Enum.Font.Code
    _0x_btn.TextSize = 10
    _0x_btn.ZIndex = 2
    _0x_btn.Parent = _0x_tbBar

    local _0x_bCr = Instance.new(_0x_dec(92, 106, 74, 118, 121, 117, 108, 121)) _0x_bCr.CornerRadius = UDim.new(0, 4) _0x_bCr.Parent = _0x_btn
    local _0x_bSt = Instance.new(_0x_dec(92, 106, 92, 123, 121, 118, 111, 108)) _0x_bSt.Color = _0x_isDef and Color3.fromRGB(165, 19, 174) or Color3.fromRGB(45, 20, 75) _0x_bSt.Thickness = 1 _0x_bSt.Parent = _0x_btn

    local _0x_page = Instance.new(_0x_dec(90, 109, 121, 118, 110, 110, 118, 110, 103, 73, 121, 110, 108, 110))
    _0x_page.Size = UDim2.new(1, -20, 1, -70)
    _0x_page.Position = UDim2.new(0, 10, 0, 64)
    _0x_page.BackgroundTransparency = 1
    _0x_page.Visible = _0x_isDef
    _0x_page.ZIndex = 2
    _0x_page.CanvasSize = UDim2.new(0, 0, 0, 500)
    _0x_page.ScrollBarThickness = 4
    _0x_page.ScrollBarImageColor3 = Color3.fromRGB(165, 19, 174)
    _0x_page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    _0x_page.Parent = _0x_mFr

    _0x_pages[_0x_tName] = _0x_page
    _0x_tabBtns[_0x_tName] = {btn = _0x_btn, stroke = _0x_bSt}

    _0x_btn.MouseButton1Click:Connect(function()
        for _0x_name, _0x_p in pairs(_0x_pages) do
            _0x_p.Visible = (_0x_name == _0x_tName)
            local _0x_tb = _0x_tabBtns[_0x_name]
            _0x_tb.btn.BackgroundColor3 = (_0x_name == _0x_tName) and Color3.fromRGB(45, 15, 80) or Color3.fromRGB(20, 10, 35)
            _0x_tb.btn.TextColor3 = (_0x_name == _0x_tName) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 140, 210)
            _0x_tb.stroke.Color = (_0x_name == _0x_tName) and Color3.fromRGB(165, 19, 174) or Color3.fromRGB(45, 20, 75)
        end
    end)
    return _0x_page
end

local _0x_pC = _0x_crtTab(_0x_dec(74, 118, 120, 110, 104, 117, 123), true)
local _0x_pE = _0x_crtTab(_0x_dec(76, 104, 103), false)
local _0x_pM = _0x_crtTab(_0x_dec(84, 117, 121, 108), false)

local function _0x_crtCols(_0x_page)
    local _0x_l = Instance.new(_0x_dec(77, 121, 104, 117, 108)) _0x_l.Size = UDim2.new(0.485, 0, 1, 0) _0x_l.BackgroundTransparency = 1 _0x_l.ZIndex = 2 _0x_l.Parent = _0x_page
    local _0x_lL = Instance.new(_0x_dec(75, 118, 110, 121, 118, 92, 108, 110, 104, 108, 121)) _0x_lL.Padding = UDim.new(0, 6) _0x_lL.SortOrder = Enum.SortOrder.LayoutOrder _0x_lL.Parent = _0x_l
    local _0x_r = Instance.new(_0x_dec(77, 121, 104, 117, 108)) _0x_r.Size = UDim2.new(0.485, 0, 1, 0) _0x_r.Position = UDim2.new(0.515, 0, 0, 0) _0x_r.BackgroundTransparency = 1 _0x_r.ZIndex = 2 _0x_r.Parent = _0x_page
    local _0x_rL = Instance.new(_0x_dec(75, 118, 110, 121, 118, 92, 108, 110, 104, 108, 121)) _0x_rL.Padding = UDim.new(0, 6) _0x_rL.SortOrder = Enum.SortOrder.LayoutOrder _0x_rL.Parent = _0x_r
    return _0x_l, _0x_r
end

local _0x_cL, _0x_cR = _0x_crtCols(_0x_pC)
local _0x_eL, _0x_eR = _0x_crtCols(_0x_pE)
local _0x_mL, _0x_mR = _0x_crtCols(_0x_pM)

local function _0x_crtSec(_0x_parent, _0x_title)
    local _0x_sec = Instance.new(_0x_dec(77, 121, 104, 117, 108))
    _0x_sec.AutomaticSize = Enum.AutomaticSize.Y
    _0x_sec.Size = UDim2.new(1, 0, 0, 0)
    _0x_sec.BackgroundColor3 = Color3.fromRGB(24, 12, 42)
    _0x_sec.BackgroundTransparency = 0.25
    _0x_sec.BorderSizePixel = 0
    _0x_sec.ZIndex = 2
    _0x_sec.Parent = _0x_parent

    local _0x_sCr = Instance.new(_0x_dec(92, 106, 74, 118, 121, 117, 108, 121)) _0x_sCr.CornerRadius = UDim.new(0, 5) _0x_sCr.Parent = _0x_sec
    local _0x_sSt = Instance.new(_0x_dec(92, 106, 92, 123, 121, 118, 111, 108)) _0x_sSt.Color = Color3.fromRGB(165, 19, 174) _0x_sSt.Thickness = 1 _0x_sSt.Parent = _0x_sec
    local _0x_sTl = Instance.new(_0x_dec(91, 104, 131, 123, 73, 112, 113, 108, 118)) _0x_sTl.Size = UDim2.new(1, -10, 0, 20) _0x_sTl.Position = UDim2.new(0, 5, 0, 2) _0x_sTl.BackgroundTransparency = 1 _0x_sTl.Text = _0x_title _0x_sTl.TextColor3 = Color3.fromRGB(210, 180, 255) _0x_sTl.Font = Enum.Font.Code _0x_sTl.TextSize = 10 _0x_sTl.TextXAlignment = Enum.TextXAlignment.Left _0x_sTl.ZIndex = 2 _0x_sTl.Parent = _0x_sec
    local _0x_ln = Instance.new(_0x_dec(77, 121, 104, 117, 108)) _0x_ln.Size = UDim2.new(1, -10, 0, 1) _0x_ln.Position = UDim2.new(0, 5, 0, 22) _0x_ln.BackgroundColor3 = Color3.fromRGB(165, 19, 174) _0x_ln.BorderSizePixel = 0 _0x_ln.ZIndex = 2 _0x_ln.Parent = _0x_sec

    local _0x_cnt = Instance.new(_0x_dec(77, 121, 104, 117, 108))
    _0x_cnt.AutomaticSize = Enum.AutomaticSize.Y
    _0x_cnt.Size = UDim2.new(1, -10, 0, 0)
    _0x_cnt.Position = UDim2.new(0, 5, 0, 25)
    _0x_cnt.BackgroundTransparency = 1
    _0x_cnt.ZIndex = 2
    _0x_cnt.Parent = _0x_sec

    local _0x_lay = Instance.new(_0x_dec(75, 118, 110, 121, 118, 92, 108, 110, 104, 108, 121)) _0x_lay.Padding = UDim.new(0, 4) _0x_lay.SortOrder = Enum.SortOrder.LayoutOrder _0x_lay.Parent = _0x_cnt
    local _0x_pad = Instance.new(_0x_dec(75, 118, 110, 121, 92, 118, 110, 123, 108, 118, 110)) _0x_pad.PaddingBottom = UDim.new(0, 5) _0x_pad.Parent = _0x_sec
    return _0x_cnt
end

local _0x_cS1 = _0x_crtSec(_0x_cL, _0x_dec(72, 118, 110, 108, 73, 118, 117, 33, 89, 104, 117, 108, 75, 118, 117, 123))
local _0x_cS2 = _0x_crtSec(_0x_cR, _0x_dec(94, 112, 118, 110, 118, 111, 33, 76, 115, 87, 85, 75, 53, 83, 112, 117, 117, 104, 110, 123))
local _0x_eS1 = _0x_crtSec(_0x_eL, _0x_dec(76, 103, 75, 112, 119, 112, 118, 110, 117, 112, 110))
local _0x_mS1 = _0x_crtSec(_0x_mL, _0x_dec(81, 118, 117, 110, 118, 111, 104, 117, 118, 110, 123, 33, 68, 111, 110, 104, 46, 73, 110, 117, 104, 117, 123))
local _0x_mS2 = _0x_crtSec(_0x_mR, _0x_dec(90, 118, 110, 33, 70, 118, 110, 117, 110, 117, 110, 117, 110, 117, 110))
local _0x_mS3 = _0x_crtSec(_0x_mR, _0x_dec(80, 121, 118, 123, 118, 104, 110, 123, 40, 77, 118, 125, 33, 79, 79, 41))

local function _0x_crtTgl(_0x_parent, _0x_text, _0x_order, _0x_defSt, _0x_cb)
    local _0x_btn = Instance.new(_0x_dec(91, 104, 131, 123, 73, 112, 113, 108, 118))
    _0x_btn.Size = UDim2.new(1, -4, 0, 26)
    _0x_btn.BackgroundTransparency = 1
    _0x_btn.Text = (_0x_defSt and "[✔] " or "[ ] ").. _0x_text
    _0x_btn.TextColor3 = _0x_defSt and Color3.fromRGB(210, 180, 255) or Color3.fromRGB(160, 150, 180)
    _0x_btn.Font = Enum.Font.Code
    _0x_btn.TextSize = 10
    _0x_btn.TextXAlignment = Enum.TextXAlignment.Left
    _0x_btn.LayoutOrder = _0x_order
    _0x_btn.ZIndex = 2
    _0x_btn.Parent = _0x_parent

    _0x_btn.MouseButton1Click:Connect(function()
        _0x_defSt = not _0x_defSt
        _0x_btn.Text = (_0x_defSt and "[✔] " or "[ ] ").. _0x_text
        _0x_btn.TextColor3 = _0x_defSt and Color3.fromRGB(210, 180, 255) or Color3.fromRGB(160, 150, 180)
        _0x_cb(_0x_defSt)
    end)
    return _0x_btn
end

_0x_crtTgl(_0x_cS1, "Rage Bot (High-Perf)", 1, _0x_G.Config.RageBot, function(v) _0x_G.Config.RageBot = v end)
_0x_crtTgl(_0x_cS1, "Head Lock (Aimbot)", 2, _0x_G.Config.Aimbot, function(v) _0x_G.Config.Aimbot = v end)
_0x_crtTgl(_0x_cS1, "Silent Aim (Optimized)", 3, _0x_G.Config.SilentAim, function(v) _0x_G.Config.SilentAim = v end)
_0x_crtTgl(_0x_cS1, "All-Head (Forced)", 4, _0x_G.Config.AllHead, function(v) _0x_G.Config.AllHead = v end)
_0x_crtTgl(_0x_cS1, "Wallbang / WallCheck Off", 5, not _0x_G.Config.WallCheck, function(v) _0x_G.Config.WallCheck = not v end)

_0x_crtTgl(_0x_cS2, "Show FOV (Muzzle Tracked)", 1, _0x_G.Config.ShowFOV, function(v) _0x_G.Config.ShowFOV = v end)
_0x_crtTgl(_0x_cS2, "Auto Fire (Rapid)", 2, _0x_G.Config.AutoFire, function(v) _0x_G.Config.AutoFire = v end)
_0x_crtTgl(_0x_cS2, "No Recoil", 3, _0x_G.Config.NoRecoil, function(v) _0x_G.Config.NoRecoil = v end)
_0x_crtTgl(_0x_cS2, "No Spread", 4, _0x_G.Config.NoSpread, function(v) _0x_G.Config.NoSpread = v end)
_0x_crtTgl(_0x_cS2, "Desync (Smooth Move)", 5, _0x_G.Config.Desync, function(v) _0x_G.Config.Desync = v end)

_0x_crtTgl(_0x_eS1, "Corner Box ESP", 1, _0x_G.Config.CornerBoxESP, function(v) _0x_G.Config.CornerBoxESP = v end)
_0x_crtTgl(_0x_eS1, "Name ESP", 2, _0x_G.Config.NameESP, function(v) _0x_G.Config.NameESP = v end)
_0x_crtTgl(_0x_eS1, "Health Bar ESP", 3, _0x_G.Config.HealthESP, function(v) _0x_G.Config.HealthESP = v end)

_0x_crtTgl(_0x_mS1, "Hit Log Notification", 1, _0x_G.Config.HitNotify, function(v) _0x_G.Config.HitNotify = v end)
_0x_crtTgl(_0x_mS1, "Anti-Cheat Bypass", 2, _0x_G.Config.AntiCheatBypass, function(v) _0x_G.Config.AntiCheatBypass = v end)

_0x_crtTgl(_0x_mS2, "All Skins (Unlock All)", 1, _0x_G.Config.AllSkins, function(v) _0x_G.Config.AllSkins = v end)

_0x_crtTgl(_0x_mS3, "Fly (Speed: 50)", 1, _0x_G.Config.Fly, function(v) _0x_updFly(v) end)
_0x_crtTgl(_0x_mS3, "Noclip", 2, _0x_G.Config.Noclip, function(v) _0x_G.Config.Noclip = v end)

_0x_tBtn.MouseButton1Click:Connect(function()
    _0x_mFr.Visible = not _0x_mFr.Visible
end)

print("RayV3 Rivals Integrated v4.1 Loaded Successfully!")

