--[[
  Cerus Unnamed
  UI: Linoria (GitHub live)
  Ragebot: UE opensource (Desync + Void spam + EncodeCFrame)
  Tabs: Main / Ragebot / ESP / Misc
  Toggle UI: RightShift
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

pcall(function()
    local setid = setthreadidentity or setidentity or set_thread_identity
    if setid then setid(8) end
end)

-- ============================================================================
-- Soft AC helpers
-- ============================================================================
pcall(function()
    if LP and typeof(LP.Kick) == "function" and hookfunction then
        hookfunction(LP.Kick, function() end)
    end
end)
pcall(function()
    if not (hookmetamethod and getnamecallmethod) then return end
    local old
    old = hookmetamethod(game, "__namecall", newcclosure and newcclosure(function(self, ...)
        local m = getnamecallmethod()
        if m == "Kick" or m == "kick" then return end
        return old(self, ...)
    end) or function(self, ...)
        local m = getnamecallmethod()
        if m == "Kick" then return end
        return old(self, ...)
    end)
end)

-- ============================================================================
-- UE Ragebot + Desync
-- ============================================================================
-- ============================================================================
-- Unnamed Enhancements (UE) — Ragebot + Desync Open Source
-- Feature surface recovered from UE config keys:
--   ragebot_enabled, ragebot_mode, ragebot_style, ragebot_weapon
--   ragebot_void_spam / ragebot_void_spam_hide / ragebot_void_spam_attack
--   ragebot_shoot_attempts, ragebot_bait, ragebot_priority*
--
-- Desync: Rivals-accurate server/client split (Elisium DesyncService pattern)
--   - Heartbeat: HRP moved to target (server-facing)
--   - RenderStepped restore: client visual stays at original CF
--   - Fire window keeps desync active while EncodeCFrame aim is rewritten
--
-- Usage:
--   loadstring(...)()
--   UE.RagebotEnable(true)
--   RightControl toggles
-- ============================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")
local Workspace         = workspace

local LP     = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera
end)

-- ---------------------------------------------------------------------------
-- Config
-- ---------------------------------------------------------------------------
UE = UE or {}
UE.ragebot = UE.ragebot or {
    enable            = false,
    mode              = "Closest",  -- Closest | FOV | Priority
    style             = "Desync",   -- Desync | Orbit | Void | Hybrid
    weapon            = "Auto",
    ffa               = true,
    team_check        = false,
    max_distance      = 2500,
    fov               = 360,
    hit_part          = "Head",
    prediction        = true,
    prediction_amount = 1.15,
    -- Desync (UE built-in equivalent)
    desync            = true,       -- master desync toggle
    desync_y          = 2,          -- offset on target
    desync_hold       = 0.15,       -- keep desync after shot (s)
    desync_always     = false,      -- if true, desync while target locked (not only on shot)
    -- Void spam (UE keys)
    void_spam         = true,
    void_hide         = 0.25,       -- UE default-like hide window
    void_attack       = 0.03,       -- UE default-like attack window
    void_hide_y       = -40,
    -- Fire
    shoot_attempts    = 4,
    auto_shoot        = true,
    bait              = false,
    bait_ms           = 300,
    -- Priority
    priority_enabled  = false,
    priority_targets  = {},
    priority_notify   = true,
    -- Status
    status            = "idle",
    last_target       = nil,
}

local CFG = UE.ragebot

-- ---------------------------------------------------------------------------
-- Modules
-- ---------------------------------------------------------------------------
local Utility, EnumLibrary, FighterController, GunModule

local function resolveModules()
    pcall(function()
        Utility = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility", 8))
    end)
    pcall(function()
        EnumLibrary = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("EnumLibrary", 8))
    end)
    pcall(function()
        local ps = LP:WaitForChild("PlayerScripts", 10)
        FighterController = require(ps.Controllers:WaitForChild("FighterController", 10))
    end)
    pcall(function()
        local ps = LP:WaitForChild("PlayerScripts", 10)
        GunModule = require(ps.Modules.ItemTypes:WaitForChild("Gun", 8))
    end)
end
resolveModules()
LP.CharacterAdded:Connect(function()
    task.delay(0.5, resolveModules)
end)

-- ---------------------------------------------------------------------------
-- Target helpers
-- ---------------------------------------------------------------------------
local function isEnemy(plr)
    if not plr or plr == LP then return false end
    if CFG.ffa then return true end
    if CFG.team_check then
        local a, b = LP:GetAttribute("TeamID"), plr:GetAttribute("TeamID")
        if a ~= nil and b ~= nil and a == b then return false end
        if LP.Team and plr.Team and LP.Team == plr.Team then return false end
    end
    return true
end

local function isAlive(plr)
    local ch = plr and plr.Character
    local h = ch and ch:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

local function getHitPart(char)
    if not char then return nil end
    if CFG.hit_part == "Body" then
        return char:FindFirstChild("HitboxBody")
            or char:FindFirstChild("UpperTorso")
            or char:FindFirstChild("Torso")
            or char:FindFirstChild("HumanoidRootPart")
    end
    return char:FindFirstChild("HitboxHead")
        or char:FindFirstChild("Head")
        or char:FindFirstChild("HumanoidRootPart")
end

local function isPriority(plr)
    if not CFG.priority_enabled then return false end
    for _, name in ipairs(CFG.priority_targets or {}) do
        if plr.Name == name or plr.DisplayName == name then return true end
    end
    return false
end

local function predictPos(part, plr)
    local pos = part.Position
    if not CFG.prediction then return pos end
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return pos end
    local ping = 0.05
    pcall(function() ping = LP:GetNetworkPing() end)
    return pos + hrp.AssemblyLinearVelocity * math.clamp(ping, 0, 0.4) * (CFG.prediction_amount or 1)
end

local function getTarget()
    Camera = Workspace.CurrentCamera or Camera
    if not Camera then return nil, nil end
    local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local origin = myHRP and myHRP.Position or Camera.CFrame.Position
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local best, bestPart, bestScore = nil, nil, math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if isAlive(plr) and isEnemy(plr) then
            local part = getHitPart(plr.Character)
            if part then
                local world = part.Position
                local dist = (world - origin).Magnitude
                if dist <= (CFG.max_distance or 2500) then
                    local score
                    if CFG.mode == "Priority" and isPriority(plr) then
                        score = dist * 0.01
                    elseif CFG.mode == "FOV" then
                        local sp, on = Camera:WorldToViewportPoint(world)
                        if on and sp.Z > 0 then
                            local sd = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                            if sd <= (CFG.fov or 360) then score = sd end
                        end
                    else
                        score = dist
                    end
                    if CFG.priority_enabled and isPriority(plr) and score then
                        score = score * 0.05
                    end
                    if score and score < bestScore then
                        bestScore, best, bestPart = score, plr, part
                    end
                end
            end
        end
    end
    return best, bestPart
end

-- ---------------------------------------------------------------------------
-- DesyncService (UE built-in equivalent)
-- Server sees you at target; client restores every frame
-- ---------------------------------------------------------------------------
local DesyncService = {
    active   = false,
    target   = nil,
    client   = nil,   -- last client CFrame
    server   = nil,   -- Vector3 server position
    hbConn   = nil,
    rsName   = "UE_DesyncRestore",
    holdUntil = 0,
}

function DesyncService:Init()
    -- nothing persistent beyond fields
end

function DesyncService:Start(target)
    if not CFG.desync then return end
    if not target or not target.Character then return end
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    self.target = target
    self.active = true
    self.holdUntil = os.clock() + (tonumber(CFG.desync_hold) or 0.15)

    if self.hbConn then
        self.hbConn:Disconnect()
        self.hbConn = nil
    end

    self.hbConn = RunService.Heartbeat:Connect(function()
        if not self.active or not CFG.enable or not CFG.desync then
            self:Stop()
            return
        end

        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local t = self.target
        if not root or not t or not t.Character then
            self:Stop()
            return
        end

        local aim = getHitPart(t.Character)
        if not aim then
            self:Stop()
            return
        end

        -- snapshot client pose
        self.client = root.CFrame
        local clientVel = root.AssemblyLinearVelocity

        local oy = tonumber(CFG.desync_y) or 2
        -- server-facing position (near target head/body)
        self.server = aim.Position + Vector3.new(0, oy, 0)
        root.CFrame = CFrame.new(self.server, aim.Position)

        -- restore client visual this frame (UE/Elisium style)
        RunService:BindToRenderStep(self.rsName, Enum.RenderPriority.Camera.Value - 1, function()
            if root and root.Parent and self.client then
                root.CFrame = self.client
                pcall(function() root.AssemblyLinearVelocity = clientVel end)
            end
            pcall(function() RunService:UnbindFromRenderStep(self.rsName) end)
        end)

        -- auto stop after hold if not always mode
        if not CFG.desync_always and os.clock() > self.holdUntil then
            -- keep alive only while void attack phase or explicit hold
        end
    end)
end

function DesyncService:Stop()
    self.active = false
    self.target = nil
    self.server = nil
    if self.hbConn then
        self.hbConn:Disconnect()
        self.hbConn = nil
    end
    pcall(function() RunService:UnbindFromRenderStep(self.rsName) end)
    -- snap client back if we still have a stored CF
    if self.client then
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if root then
            pcall(function() root.CFrame = self.client end)
        end
        self.client = nil
    end
end

function DesyncService:ExtendHold()
    self.holdUntil = os.clock() + (tonumber(CFG.desync_hold) or 0.15)
end

DesyncService:Init()

-- ---------------------------------------------------------------------------
-- Void spam (UE ragebot_void_spam*)
-- ---------------------------------------------------------------------------
local Void = { phase = "attack", endsAt = 0 }

local function voidTick(target, hitPart)
    if not CFG.void_spam then return "attack" end
    local now = os.clock()
    if now >= Void.endsAt then
        if Void.phase == "attack" then
            Void.phase = "hide"
            Void.endsAt = now + math.clamp(tonumber(CFG.void_hide) or 0.25, 0.01, 1.0)
        else
            Void.phase = "attack"
            Void.endsAt = now + math.clamp(tonumber(CFG.void_attack) or 0.03, 0.01, 1.0)
        end
    end

    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return Void.phase end

    if Void.phase == "hide" then
        -- during hide do NOT desync-attack
        local y = tonumber(CFG.void_hide_y) or -40
        if hitPart then
            hrp.CFrame = CFrame.new(hitPart.Position.X, y, hitPart.Position.Z)
        else
            hrp.CFrame = CFrame.new(hrp.Position.X, y, hrp.Position.Z)
        end
        if DesyncService.active and not CFG.desync_always then
            DesyncService:Stop()
        end
    elseif Void.phase == "attack" and hitPart then
        local style = CFG.style or "Desync"
        if style == "Orbit" or style == "Hybrid" then
            local ang = tick() * 7
            local off = Vector3.new(math.cos(ang) * 5, 2, math.sin(ang) * 5)
            hrp.CFrame = CFrame.new(hitPart.Position + off, hitPart.Position)
        elseif style == "Void" then
            hrp.CFrame = CFrame.new(hitPart.Position + Vector3.new(0, 2, 0), hitPart.Position)
        end
        -- Desync / Hybrid: DesyncService handles server offset on fire / always
        if (style == "Desync" or style == "Hybrid" or CFG.desync_always) and CFG.desync and target then
            if not DesyncService.active then
                DesyncService:Start(target)
            else
                DesyncService:ExtendHold()
            end
        end
    end
    return Void.phase
end

-- ---------------------------------------------------------------------------
-- Packet fire (EncodeCFrame rewrite)
-- ---------------------------------------------------------------------------
local Fire = { hooked = false, oldStart = nil }

local function encodeFire(hitPart, target)
    if not (Utility and Utility.EncodeCFrame and hitPart) then return end
    local aimPos = predictPos(hitPart, target)
    -- if desync active, origin from server pos (true UE/Elisium behavior)
    local origin
    if DesyncService.active and DesyncService.server then
        origin = DesyncService.server
    else
        origin = aimPos - Vector3.new(0, 3, 0)
    end
    return {
        [utf8.char(0)] = Utility:EncodeCFrame(CFrame.new(origin, aimPos)),
        [utf8.char(1)] = Utility:EncodeCFrame(CFrame.new(aimPos)),
        [utf8.char(2)] = hitPart,
    }
end

local function tryInputShoot()
    if not FighterController then return end
    local lf = FighterController.LocalFighter
    if not lf then return end
    pcall(function() lf:Input("StartShooting") end)
    pcall(function()
        local item = lf.EquippedItem
        if item and item.Input then item:Input("StartShooting") end
    end)
end

function Fire:Hook()
    if self.hooked then return true end
    if not GunModule or type(GunModule.StartShooting) ~= "function" then
        resolveModules()
        if not GunModule or type(GunModule.StartShooting) ~= "function" then
            return false
        end
    end
    self.oldStart = GunModule.StartShooting
    local old = self.oldStart

    GunModule.StartShooting = function(selfItem, ...)
        local results = { old(selfItem, ...) }
        if not CFG.enable then
            return table.unpack(results)
        end

        local isLocal = false
        pcall(function()
            isLocal = selfItem.ClientFighter and selfItem.ClientFighter.IsLocalPlayer
        end)
        if not isLocal then
            return table.unpack(results)
        end

        local target, hitPart = getTarget()
        if not target or not hitPart then
            return table.unpack(results)
        end

        CFG.last_target = target.Name
        CFG.status = "firing"

        -- core desync on every real shot
        if CFG.desync then
            DesyncService:Start(target)
            DesyncService:ExtendHold()
        end

        local camData = results[3]
        if type(camData) == "table" and Utility then
            local pack = encodeFire(hitPart, target)
            if pack then
                for k, v in pairs(pack) do
                    camData[k] = v
                end
                if camData.Hitbox then
                    camData.Hitbox = (CFG.hit_part == "Head") and "Head" or "Body"
                end
            end
            results[4] = true
        end

        return table.unpack(results)
    end

    self.hooked = true
    return true
end

function Fire:Unhook()
    if GunModule and self.oldStart then
        pcall(function() GunModule.StartShooting = self.oldStart end)
    end
    self.oldStart = nil
    self.hooked = false
end

-- ---------------------------------------------------------------------------
-- Service
-- ---------------------------------------------------------------------------
local Service = { running = false, conn = nil }

function Service:Start()
    if self.running then return end
    self.running = true
    CFG.enable = true
    CFG.status = "tracking"
    resolveModules()
    Fire:Hook()

    self.conn = RunService.Heartbeat:Connect(function()
        if not CFG.enable then return end
        if not Fire.hooked then Fire:Hook() end

        local target, hitPart = getTarget()
        if not target then
            CFG.status = "idle"
            CFG.last_target = nil
            if not CFG.desync_always then DesyncService:Stop() end
            return
        end

        CFG.last_target = target.Name
        local phase = voidTick(target, hitPart)

        if phase == "hide" then
            CFG.status = "void_hide"
            return
        end

        CFG.status = DesyncService.active and "desync" or "tracking"

        if CFG.desync_always and CFG.desync and not DesyncService.active then
            DesyncService:Start(target)
        end

        if CFG.auto_shoot then
            local attempts = math.clamp(tonumber(CFG.shoot_attempts) or 4, 1, 12)
            for _ = 1, attempts do
                tryInputShoot()
            end
        end
    end)
end

function Service:Stop()
    self.running = false
    CFG.enable = false
    CFG.status = "idle"
    CFG.last_target = nil
    if self.conn then
        self.conn:Disconnect()
        self.conn = nil
    end
    DesyncService:Stop()
    Fire:Unhook()
end

function UE.RagebotEnable(state)
    if state then Service:Start() else Service:Stop() end
end

-- flag watcher
task.spawn(function()
    local last = CFG.enable
    while task.wait(0.15) do
        if CFG.enable ~= last then
            last = CFG.enable
            if last then Service:Start() else Service:Stop() end
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        UE.RagebotEnable(not CFG.enable)
        print(string.format(
            "[UE Ragebot] %s | desync=%s void=%s target=%s status=%s",
            CFG.enable and "ON" or "OFF",
            tostring(CFG.desync),
            tostring(CFG.void_spam),
            tostring(CFG.last_target),
            tostring(CFG.status)
        ))
    end
end)

print("[UE Ragebot+Desync OS] loaded")
print("  UE.RagebotEnable(true)")
print("  desync=true (server@target / client restore)")
print("  void_hide=0.25 void_attack=0.03 | RightControl toggle")



-- Bridge
CerusUnnamed = CerusUnnamed or {}
CerusUnnamed.ragebot = UE and UE.ragebot or {}
function CerusUnnamed.RagebotEnable(v)
    if UE and UE.RagebotEnable then UE.RagebotEnable(v) end
end

local PURPLE = Color3.fromRGB(138, 43, 226)
local PURPLE2 = Color3.fromRGB(168, 85, 247)

local S = {
    Aimbot = false,
    SilentAim = false,
    AimFOV = 300,
    AimSmooth = 0.4,
    AimPart = "Head",
    TeamCheck = false,
    ShowFOV = true,
    AutoFire = false,
    Ragebot = false,
    ESP = true,
    ESPBox = true,
    ESPName = true,
    ESPDist = true,
    ESPHealth = true,
    SpeedOn = false,
    Speed = 22,
    InfJump = false,
    AntiAFK = false,
    RageDist = 2500,
}

local function isTeammate(p)
    if not S.TeamCheck or not p or not p.Team or not LP.Team then return false end
    return p.Team == LP.Team
end
local function getHum(p)
    local ch = (p or LP).Character
    return ch and ch:FindFirstChildOfClass("Humanoid")
end
local function getHRP(p)
    local ch = (p or LP).Character
    return ch and ch:FindFirstChild("HumanoidRootPart")
end
local function isAlive(p)
    if not p or p == LP then return false end
    local h = getHum(p)
    return h and h.Health > 0
end

local function safeParent()
    local ok, r = pcall(function()
        if gethui then return gethui() end
        return CoreGui
    end)
    if ok and r then return r end
    return LP:WaitForChild("PlayerGui")
end

-- FOV circle
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "CerusUnnamedFOV"
fovGui.ResetOnSpawn = false
fovGui.IgnoreGuiInset = true
fovGui.DisplayOrder = 50
fovGui.Parent = safeParent()
local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.Parent = fovGui
Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)
local fovStroke = Instance.new("UIStroke")
fovStroke.Color = PURPLE
fovStroke.Thickness = 1.5
fovStroke.Transparency = 0.25
fovStroke.Parent = fovCircle

local currentTarget = nil
local function getTargetPart(ch)
    if not ch then return nil end
    return ch:FindFirstChild(S.AimPart or "Head")
        or ch:FindFirstChild("HitboxHead")
        or ch:FindFirstChild("Head")
        or ch:FindFirstChild("HumanoidRootPart")
end

local function getClosestPart()
    Camera = workspace.CurrentCamera or Camera
    if not Camera then return nil end
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local myPos = (getHRP(LP) and getHRP(LP).Position) or Camera.CFrame.Position
    local best, bestScore = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if isAlive(plr) and not isTeammate(plr) then
            local part = getTargetPart(plr.Character)
            if part then
                local world = part.Position
                local dist3 = (world - myPos).Magnitude
                if dist3 <= (S.RageDist or 2500) then
                    local sp, on = Camera:WorldToViewportPoint(world)
                    if on and sp.Z > 0 then
                        local sd = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if S.Ragebot or sd <= S.AimFOV then
                            if sd < bestScore then bestScore = sd; best = part end
                        end
                    elseif S.Ragebot then
                        local sc = dist3 * 0.25
                        if sc < bestScore then bestScore = sc; best = part end
                    end
                end
            end
        end
    end
    return best
end

RunService.RenderStepped:Connect(function()
    Camera = workspace.CurrentCamera or Camera
    currentTarget = nil
    if S.Aimbot or S.SilentAim then
        currentTarget = getClosestPart()
    end
    local show = S.ShowFOV and (S.Aimbot or S.SilentAim or S.Ragebot)
    fovCircle.Visible = show
    if show and Camera then
        local r = math.max(S.AimFOV, 10)
        fovCircle.Size = UDim2.fromOffset(r*2, r*2)
        fovCircle.Position = UDim2.fromOffset(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    end
    if S.Aimbot and currentTarget and currentTarget.Parent and Camera then
        local goal = CFrame.new(Camera.CFrame.Position, currentTarget.Position)
        Camera.CFrame = Camera.CFrame:Lerp(goal, math.clamp(S.AimSmooth, 0.05, 1))
    end
    if S.SilentAim and currentTarget and currentTarget.Parent and Camera then
        local goal = CFrame.new(Camera.CFrame.Position, currentTarget.Position)
        Camera.CFrame = Camera.CFrame:Lerp(goal, 0.9)
    end
end)

task.spawn(function()
    while task.wait(0.05) do
        if S.AutoFire and (S.Aimbot or S.Ragebot) and currentTarget then
            local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
            if tool then pcall(function() tool:Activate() end) end
        end
    end
end)

-- ESP
local espObjects = {}
local function clearESP(p)
    local o = espObjects[p]
    if not o then return end
    for _, v in pairs(o) do pcall(function() v:Destroy() end) end
    espObjects[p] = nil
end
local function ensureESP(p)
    if espObjects[p] then return espObjects[p] end
    local gui = Instance.new("BillboardGui")
    gui.Size = UDim2.fromOffset(160, 40)
    gui.StudsOffset = Vector3.new(0, 3, 0)
    gui.AlwaysOnTop = true
    gui.MaxDistance = 5000
    local name = Instance.new("TextLabel")
    name.BackgroundTransparency = 1
    name.Size = UDim2.new(1, 0, 0.55, 0)
    name.Font = Enum.Font.GothamBold
    name.TextSize = 14
    name.TextColor3 = PURPLE2
    name.TextStrokeTransparency = 0.3
    name.Parent = gui
    local dist = Instance.new("TextLabel")
    dist.BackgroundTransparency = 1
    dist.Position = UDim2.new(0, 0, 0.5, 0)
    dist.Size = UDim2.new(1, 0, 0.5, 0)
    dist.Font = Enum.Font.Code
    dist.TextSize = 12
    dist.TextColor3 = Color3.fromRGB(220, 220, 230)
    dist.TextStrokeTransparency = 0.4
    dist.Parent = gui
    local box = Instance.new("BoxHandleAdornment")
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Transparency = 0.65
    box.Color3 = PURPLE
    box.Size = Vector3.new(2.2, 5, 2.2)
    espObjects[p] = { gui = gui, name = name, dist = dist, box = box }
    return espObjects[p]
end

RunService.RenderStepped:Connect(function()
    if not S.ESP then
        for p in pairs(espObjects) do clearESP(p) end
        return
    end
    local myPos = getHRP(LP) and getHRP(LP).Position or Vector3.zero
    local seen = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if isAlive(plr) and not isTeammate(plr) then
            seen[plr] = true
            local ch = plr.Character
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            local head = ch:FindFirstChild("Head")
            local hum = ch:FindFirstChildOfClass("Humanoid")
            local o = ensureESP(plr)
            if hrp then
                if S.ESPBox then o.box.Adornee = hrp; o.box.Parent = hrp else o.box.Parent = nil end
                local ad = head or hrp
                o.gui.Adornee = ad
                o.gui.Parent = ad
                if S.ESPName then
                    local hp = hum and math.floor(hum.Health) or 0
                    o.name.Text = S.ESPHealth and (plr.DisplayName .. " [" .. hp .. "]") or plr.DisplayName
                    o.name.Visible = true
                else o.name.Visible = false end
                if S.ESPDist then
                    o.dist.Text = math.floor((hrp.Position - myPos).Magnitude) .. "m"
                    o.dist.Visible = true
                else o.dist.Visible = false end
            end
        end
    end
    for p in pairs(espObjects) do if not seen[p] then clearESP(p) end end
end)

UIS.JumpRequest:Connect(function()
    if S.InfJump then
        local h = getHum(LP)
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)
RunService.Heartbeat:Connect(function()
    if S.SpeedOn then
        local h = getHum(LP)
        if h then h.WalkSpeed = S.Speed end
    end
end)
task.spawn(function()
    while task.wait(60) do
        if S.AntiAFK then
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController(); vu:ClickButton2(Vector2.new())
            end)
        end
    end
end)

local function setRagebot(v)
    S.Ragebot = v and true or false
    pcall(function()
        if UE and UE.ragebot then
            UE.ragebot.enable = S.Ragebot
        end
        if UE and UE.RagebotEnable then
            UE.RagebotEnable(S.Ragebot)
        end
    end)
end

-- ============================================================================
-- Linoria live (GitHub)
-- ============================================================================
local LINORIA_REPOS = {
    "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/",
    "https://cdn.jsdelivr.net/gh/mstudio45/LinoriaLib@main/",
    "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/",
}
local function httpGet(url)
    local function good(s) return type(s) == "string" and #s > 800 end
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and good(res) then return res end
    ok, res = pcall(function() return game:HttpGet(url, true) end)
    if ok and good(res) then return res end
    local req = (syn and syn.request) or http_request or request
    if req then
        ok, res = pcall(function() return req({Url=url, Method="GET"}) end)
        if ok and type(res)=="table" and good(res.Body or res.body) then return res.Body or res.body end
    end
    return nil
end

local Library, ThemeManager, SaveManager
do
    for _, repo in ipairs(LINORIA_REPOS) do
        local src = httpGet(repo .. "Library.lua")
        if src then
            local chunk = loadstring(src)
            if chunk then
                local ok, lib = pcall(chunk)
                if ok and type(lib)=="table" and lib.CreateWindow then
                    Library = lib
                    local tm = httpGet(repo .. "addons/ThemeManager.lua")
                    local sm = httpGet(repo .. "addons/SaveManager.lua")
                    if tm then local c=loadstring(tm); if c then pcall(function() ThemeManager=c() end) end end
                    if sm then local c=loadstring(sm); if c then pcall(function() SaveManager=c() end) end end
                    break
                end
            end
        end
    end
end

if Library then
    Library.AccentColor = PURPLE
    pcall(function()
        if Library.GetDarkerColor then Library.AccentColorDark = Library:GetDarkerColor(PURPLE) end
    end)
    Library.MainColor = Color3.fromRGB(18, 14, 24)
    Library.BackgroundColor = Color3.fromRGB(12, 10, 16)
    Library.OutlineColor = Color3.fromRGB(60, 40, 90)
    Library.FontColor = Color3.fromRGB(240, 235, 250)
end

local function buildLinoriaUI()
    local Window = Library:CreateWindow({
        Title = "Cerus Unnamed  |  Linoria",
        Center = true,
        AutoShow = true,
        TabPadding = 8,
        MenuFadeTime = 0.15,
    })
    local Tabs = {
        Main = Window:AddTab("Main"),
        Ragebot = Window:AddTab("Ragebot"),
        ESP = Window:AddTab("ESP"),
        Misc = Window:AddTab("Misc"),
    }

    local aim = Tabs.Main:AddLeftGroupbox("Aimbot")
    aim:AddToggle("Aimbot", { Text = "Aimbot", Default = false, Callback = function(v) S.Aimbot = v end })
    aim:AddToggle("SilentAim", { Text = "Silent Aim", Default = false, Callback = function(v) S.SilentAim = v end })
    aim:AddToggle("AutoFire", { Text = "Auto Fire", Default = false, Callback = function(v) S.AutoFire = v end })
    aim:AddToggle("TeamCheck", { Text = "Team Check", Default = false, Callback = function(v) S.TeamCheck = v end })
    aim:AddToggle("ShowFOV", { Text = "Show FOV", Default = true, Callback = function(v) S.ShowFOV = v end })
    aim:AddSlider("AimFOV", { Text = "FOV", Min = 20, Max = 600, Default = 300, Rounding = 0, Callback = function(v) S.AimFOV = v end })
    aim:AddSlider("Smooth", { Text = "Smooth", Min = 0.05, Max = 1, Default = 0.4, Rounding = 2, Callback = function(v) S.AimSmooth = v end })
    aim:AddDropdown("HitPart", { Text = "Hit Part", Values = {"Head","HitboxHead","HumanoidRootPart","UpperTorso"}, Default = 1, Callback = function(v) S.AimPart = v end })

    local info = Tabs.Main:AddRightGroupbox("Info")
    info:AddLabel("Cerus Unnamed")
    info:AddLabel("UE Ragebot + Linoria live")
    info:AddLabel("RightShift = menu")

    local rb = Tabs.Ragebot:AddLeftGroupbox("UE Ragebot")
    rb:AddToggle("Ragebot", { Text = "Enabled", Default = false, Callback = function(v) setRagebot(v) end })
    rb:AddToggle("Desync", { Text = "Desync", Default = true, Callback = function(v)
        pcall(function() if UE and UE.ragebot then UE.ragebot.desync = v end end)
    end })
    rb:AddToggle("VoidSpam", { Text = "Void Spam", Default = true, Callback = function(v)
        pcall(function() if UE and UE.ragebot then UE.ragebot.void_spam = v end end)
    end })
    rb:AddToggle("AutoShoot", { Text = "Auto Shoot", Default = true, Callback = function(v)
        pcall(function() if UE and UE.ragebot then UE.ragebot.auto_shoot = v end end)
    end })
    rb:AddToggle("FFA", { Text = "FFA Mode", Default = true, Callback = function(v)
        pcall(function() if UE and UE.ragebot then UE.ragebot.ffa = v end end)
    end })
    rb:AddDropdown("Style", { Text = "Style", Values = {"Desync","Orbit","Void","Hybrid"}, Default = 1, Callback = function(v)
        pcall(function() if UE and UE.ragebot then UE.ragebot.style = v end end)
    end })
    rb:AddDropdown("Mode", { Text = "Target Mode", Values = {"Closest","FOV","Priority"}, Default = 1, Callback = function(v)
        pcall(function() if UE and UE.ragebot then UE.ragebot.mode = v end end)
    end })
    rb:AddSlider("Hide", { Text = "Void Hide (s)", Min = 0.01, Max = 1, Default = 0.25, Rounding = 2, Callback = function(v)
        pcall(function() if UE and UE.ragebot then UE.ragebot.void_hide = v end end)
    end })
    rb:AddSlider("Attack", { Text = "Void Attack (s)", Min = 0.01, Max = 1, Default = 0.03, Rounding = 2, Callback = function(v)
        pcall(function() if UE and UE.ragebot then UE.ragebot.void_attack = v end end)
    end })
    rb:AddSlider("Attempts", { Text = "Shoot Attempts", Min = 1, Max = 12, Default = 4, Rounding = 0, Callback = function(v)
        pcall(function() if UE and UE.ragebot then UE.ragebot.shoot_attempts = v end end)
    end })
    rb:AddSlider("DesyncY", { Text = "Desync Y", Min = -5, Max = 10, Default = 2, Rounding = 1, Callback = function(v)
        pcall(function() if UE and UE.ragebot then UE.ragebot.desync_y = v end end)
    end })
    rb:AddSlider("Pred", { Text = "Prediction", Min = 0.1, Max = 3, Default = 1.15, Rounding = 2, Callback = function(v)
        pcall(function() if UE and UE.ragebot then UE.ragebot.prediction_amount = v; UE.ragebot.prediction = true end end)
    end })

    local rc = Tabs.Ragebot:AddRightGroupbox("Options")
    rc:AddSlider("RageDist", { Text = "Max Distance", Min = 50, Max = 5000, Default = 2500, Rounding = 0, Callback = function(v) S.RageDist = v
        pcall(function() if UE and UE.ragebot then UE.ragebot.max_distance = v end end)
    end })
    rc:AddLabel("Engine: UE opensource")
    rc:AddLabel("Packet + Desync + Void")

    local esp = Tabs.ESP:AddLeftGroupbox("ESP")
    esp:AddToggle("ESP", { Text = "Enabled", Default = true, Callback = function(v) S.ESP = v end })
    esp:AddToggle("ESPBox", { Text = "Box", Default = true, Callback = function(v) S.ESPBox = v end })
    esp:AddToggle("ESPName", { Text = "Name", Default = true, Callback = function(v) S.ESPName = v end })
    esp:AddToggle("ESPDist", { Text = "Distance", Default = true, Callback = function(v) S.ESPDist = v end })
    esp:AddToggle("ESPHealth", { Text = "Health in Name", Default = true, Callback = function(v) S.ESPHealth = v end })

    local mv = Tabs.Misc:AddLeftGroupbox("Movement")
    mv:AddToggle("SpeedOn", { Text = "Speed", Default = false, Callback = function(v)
        S.SpeedOn = v
        if not v then local h=getHum(LP); if h then h.WalkSpeed=16 end end
    end })
    mv:AddSlider("Speed", { Text = "WalkSpeed", Min = 16, Max = 200, Default = 22, Rounding = 0, Callback = function(v) S.Speed = v end })
    mv:AddToggle("InfJump", { Text = "Infinite Jump", Default = false, Callback = function(v) S.InfJump = v end })
    mv:AddToggle("AntiAFK", { Text = "Anti AFK", Default = false, Callback = function(v) S.AntiAFK = v end })

    pcall(function()
        if Library.SetWatermark then
            Library:SetWatermark("Cerus Unnamed | Linoria")
            Library:SetWatermarkVisibility(true)
        end
        if Library.Toggled == false and Library.Toggle then Library:Toggle() end
    end)
    if ThemeManager and ThemeManager.SetLibrary then
        pcall(function() ThemeManager:SetLibrary(Library); ThemeManager:SetFolder("CerusUnnamed") end)
    end
    if SaveManager and SaveManager.SetLibrary then
        pcall(function() SaveManager:SetLibrary(Library); SaveManager:SetFolder("CerusUnnamed"); SaveManager:BuildConfigSection(Tabs.Misc) end)
    end
    return Window
end

local function buildFallbackUI()
    local sg = Instance.new("ScreenGui")
    sg.Name = "CerusUnnamedFallback"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 999999
    sg.Parent = safeParent()
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(56,56)
    btn.Position = UDim2.new(0.5,-28,0,60)
    btn.BackgroundColor3 = PURPLE
    btn.Text = "CU"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Parent = sg
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    local W = Instance.new("Frame")
    W.Size = UDim2.fromScale(0.88,0.7)
    W.Position = UDim2.fromScale(0.5,0.5)
    W.AnchorPoint = Vector2.new(0.5,0.5)
    W.BackgroundColor3 = Color3.fromRGB(18,14,24)
    W.Visible = false
    W.Parent = sg
    Instance.new("UICorner", W).CornerRadius = UDim.new(0,12)
    Instance.new("UIStroke", W).Color = PURPLE
    local open = false
    btn.MouseButton1Click:Connect(function() open = not open; W.Visible = open end)
    local function addT(y, text, fn)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1,-20,0,32)
        b.Position = UDim2.new(0,10,0,y)
        b.BackgroundColor3 = Color3.fromRGB(38,28,52)
        b.Text = text .. ": OFF"
        b.TextColor3 = Color3.new(1,1,1)
        b.Font = Enum.Font.Code
        b.TextSize = 13
        b.Parent = W
        local on = false
        b.MouseButton1Click:Connect(function()
            on = not on
            b.Text = text .. ": " .. (on and "ON" or "OFF")
            b.BackgroundColor3 = on and PURPLE or Color3.fromRGB(38,28,52)
            pcall(fn, on)
        end)
    end
    addT(50, "Aimbot", function(v) S.Aimbot=v end)
    addT(88, "Silent Aim", function(v) S.SilentAim=v end)
    addT(126, "UE Rage", function(v) setRagebot(v) end)
    addT(164, "ESP", function(v) S.ESP=v end)
    return sg
end

if Library then
    local ok, err = pcall(buildLinoriaUI)
    if not ok then
        warn("[Cerus Unnamed] UI error: "..tostring(err))
        buildFallbackUI()
    end
else
    warn("[Cerus Unnamed] Linoria load failed — fallback UI")
    buildFallbackUI()
end

task.defer(function()
    pcall(function()
        local g = Instance.new("ScreenGui")
        g.Name = "CerusUnnamedOpenBtn"
        g.ResetOnSpawn = false
        g.DisplayOrder = 1000000
        g.IgnoreGuiInset = true
        g.Parent = safeParent()
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromOffset(120,30)
        b.Position = UDim2.fromOffset(12,12)
        b.BackgroundColor3 = Color3.fromRGB(24,16,36)
        b.Text = "Cerus Unnamed"
        b.Font = Enum.Font.GothamBold
        b.TextSize = 13
        b.TextColor3 = Color3.fromRGB(240,235,255)
        b.Parent = g
        Instance.new("UIStroke", b).Color = PURPLE
        b.MouseButton1Click:Connect(function()
            pcall(function() if Library and Library.Toggle then Library:Toggle() end end)
        end)
    end)
end)

task.spawn(function()
    while task.wait(1.5) do
        pcall(function()
            if Library and Library.ScreenGui and not Library.ScreenGui.Parent then
                Library.ScreenGui.Parent = safeParent()
                Library.ScreenGui.Enabled = true
            end
        end)
    end
end)

pcall(function()
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            if Library and Library.Toggle then Library:Toggle() end
        end
    end)
end)

print("[Cerus Unnamed] Loaded — Linoria live + UE Ragebot")
