
-- ============================================================================

-- ============================================================================

-- ============================================================================

-- ============================================================================

-- ============================================================================

-- ============================================================================

-- ============================================================================

-- ============================================================================
-- 諛붿씠�⑥뒪 FULL (�덉쟾 踰꾩쟾 �� overflow �좊컻 ��ぉ �쒖쇅)
-- �ы븿: Kick, setmetatable, namecall Kick, GetMouse, Ping, CameraSecurity soft
-- �쒖쇅: FireServer 愿묒뿭 李⑤떒, CameraSecurity __index=nil, getgc 媛뺤젣 ��
-- ============================================================================
task.defer(function()
    if getgenv().__VallkBypassFullSafe then return end
    getgenv().__VallkBypassFullSafe = true

    local function sc(fn)
        return newcclosure and newcclosure(fn) or fn
    end

    pcall(function()
        if setthreadidentity then setthreadidentity(8) end
    end)

    local LP = game:GetService("Players").LocalPlayer

    -- Kick
    pcall(function()
        if not LP then return end
        if hookfunction and typeof(LP.Kick) == "function" then
            local oldKick
            oldKick = hookfunction(LP.Kick, sc(function(self, ...)
                if self == LP then return nil end
                return oldKick(self, ...)
            end))
        else
            pcall(function() LP.Kick = function() end end)
        end
    end)

    -- setmetatable weak-mode (original only)
    pcall(function()
        local okEnv, renv = pcall(getrenv)
        local sm = okEnv and renv and renv.setmetatable
        if not (hookfunction and sm) then return end
        local oldSM
        oldSM = hookfunction(sm, sc(function(tbl, mt)
            -- pass-through by default to avoid lobby pairs(nil) breakage
            if type(oldSM) ~= "function" then
                return tbl
            end
            if mt and type(mt) == "table" then
                local mode = rawget(mt, "__mode")
                if mode == "kv" or mode == "v" or mode == "k" then
                    local ok, tr = pcall(debug.traceback)
                    tr = ok and tr or ""
                    -- only CameraSecurity / Analytics �� avoid Lobby/Misc lobby paths
                    if tr:find("CameraSecurity", 1, true)
                        or tr:find("AnalyticsPipelineController", 1, true) then
                        if not tr:find("Lobby", 1, true) and not tr:find("LobbyElements", 1, true) then
                            return oldSM({1, 2, 3}, {})
                        end
                    end
                end
            end
            return oldSM(tbl, mt)
        end))
    end)

    -- namecall Kick only
    pcall(function()
        if getgenv().__VallkNCFull then return end
        if not (hookmetamethod and getnamecallmethod) then return end
        local old
        old = hookmetamethod(game, "__namecall", sc(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" then
                return
            end
            return old(self, ...)
        end))
        getgenv().__VallkNCFull = true
    end)

    -- GetMouse (Misc only) �� return real mouse, no fake mt
    task.delay(1, function()
        pcall(function()
            if not (LP and hookfunction) then return end
            local oldGetMouse
            oldGetMouse = hookfunction(LP.GetMouse, sc(function(self, ...)
                return oldGetMouse(self, ...)
            end))
        end)
    end)

    -- CameraSecurity soft (tostring only, no __index nil)
    task.delay(2, function()
        pcall(function()
            local ps = LP and LP:FindFirstChild("PlayerScripts")
            local mod = ps and ps:FindFirstChild("Modules") and ps.Modules:FindFirstChild("CameraSecurity")
            if not mod then return end
            local ok, cs = pcall(require, mod)
            if not ok or not cs then return end
            local mt = getrawmetatable and getrawmetatable(cs)
            if not mt then return end
            if setreadonly then pcall(setreadonly, mt, false) end
            pcall(function()
                mt.__tostring = function() return "CameraSecurity" end
            end)
        end)
    end)

    -- Ping
    task.delay(4, function()
        pcall(function()
            local RS = game:GetService("ReplicatedStorage")
            local ServerPing = workspace:FindFirstChild("ServerPing")
            local Remotes = RS and RS:FindFirstChild("Remotes")
            local PingRemote = Remotes and Remotes:FindFirstChild("Ping")
            if not PingRemote then return end
            while true do
                task.wait(15 + math.random() * 10)
                local rnd = math.random(1, 9999)
                local sp = ServerPing and ServerPing.Value
                local value = rnd == 6961 and 2137 or (sp and rnd == sp and 2138 or rnd)
                pcall(function() PingRemote:FireServer(value) end)
            end
        end)
    end)
end)

-- SECTION: Anti-Kick / Security / Anti-Cheat Bypass
-- ============================================================================
pcall(function()
    if LocalPlayer and typeof(LocalPlayer.Kick) == "function" then
        LocalPlayer.Kick = function(...) end
    end
end)

-- Anti-Kick namecall block removed (syntax fix + overflow)

-- Player Spawn Tracker
local _Players = game:GetService("Players")
_Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        player:SetAttribute("SpawnTime", tick())
    end)
end)

for _, player in ipairs(_Players:GetPlayers()) do
    player.CharacterAdded:Connect(function(char)
        player:SetAttribute("SpawnTime", tick())
    end)
    if player.Character then
        player:SetAttribute("SpawnTime", tick())
    end
end

-- ============================================================================

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera
end)

-- SECTION: Key System & Settings Variables
-- ============================================================================
local validKey = "Paid_masterkey-vallkmult"
local keyPassed = false

local mobileOnEnabled = false

-- Aimbot & Silent Aim
local aimbotEnabled = false
local aimbotSmoothness = 5
local aimbotFovRadius = 100
local aimbotHitPart = "head"
local aimbotWallCheck = false

local silentAimEnabled = false
local wallbangEnabled = false
local silentAimHitPart = "head"
local silentAimFovRadius = 300
local silentWallCheck = false
local silentAimTarget = nil

-- Ragebot Toggle (Single Engine Integration)
local ragebotOrKillAura = false
local ragebotHeightOffset = 3

-- Vallk Features & Cooldowns
local fastMeleeEnabled = false
local hoNyangNoCDEnabled = false
local attackCooldownDisabled = false
local projectileCooldownDisabled = false

-- FFMode
local ffModeEnabled = false
local ffTeamCheckEnabled = true
local ffBaitingEnabled = false

-- Orbit & Void Spam
local orbitEnabled = false
local orbitRange = 50
local orbitDelay = 0.01

local voidSpamEnabled = false
local voidSpamRange = 50
local voidSpamDelay = 0.01
local voidHideTime = 0.25
local voidShootTime = 0.03
local voidAttackAttempts = 1
local hitNotifyEnabled = true
local ragebotIndicatorEnabled = true
local ammoIndicatorEnabled = true
local hitSoundVolume = 0.7
local hitSoundEnabled = false
local hitSoundName = "neverlose"
local HIT_SOUND_IDS = {
    neverlose = "rbxassetid://6607204501",
    gamesense = "rbxassetid://4817809188",
    skeet = "rbxassetid://5447626464",
    rust = "rbxassetid://5043539486",
    bell = "rbxassetid://6534947240",
    bubble = "rbxassetid://6534947588",
    minecraft = "rbxassetid://4018616850",
    osu = "rbxassetid://7149255551",
    tf2 = "rbxassetid://2868331684",
    ["�μ땐�� �뺤”諛� 蹂댁뙂"] = "rbxassetid://85775332966635",
}
local HIT_SOUND_LIST = {"neverlose","gamesense","skeet","rust","bell","bubble","minecraft","osu","tf2","�μ땐�� �뺤”諛� 蹂댁뙂"}

local hideCrosshairEnabled = false

-- Gun Utilities
local triggerbotEnabled = false
local rapidFireEnabled = false
local noRecoilEnabled = false
local noSpreadEnabled = false
local noMuzzleFlashEnabled = false
local bulletSpeedBoost = false
local bulletSpeedMult = 100000

-- ESP & Movement
local espEnabled = false
local espBoxEnabled = false
local espNameEnabled = false
local espHealthEnabled = false
local gunTracerEnabled = false

local pcFlyEnabled = false
local mobileFlyEnabled = false
local noclipEnabled = false
local rapidSpeedEnabled = false
local rapidSpeedMultiplier = 2.5

local skinChangerEnabled = false
local autoRespawnEnabled = false
local collectDropsEnabled = false
local arcadeEnabled = false
local customSkyboxEnabled = false
local skyboxTheme = "Vaporwave"

local circleCrosshairEnabled = false
local circleCrosshairSize = 60
local circleRotationSpeed = 4

-- Controller Modules
local FighterController, SpectateController, CameraController, GunModule, UtilityModule, EnumLibrary
task.defer(function()
    pcall(function()
        local ps = LocalPlayer:WaitForChild("PlayerScripts", 10)
        if not ps then return end
        local ctrl = ps:WaitForChild("Controllers", 10)
        if not ctrl then return end
        pcall(function() FighterController = require(ctrl:WaitForChild("FighterController", 5)) end)
        pcall(function() SpectateController = require(ctrl:WaitForChild("SpectateController", 2)) end)
        pcall(function() CameraController = require(ctrl:WaitForChild("CameraController", 2)) end)
        pcall(function() GunModule = require(ps:WaitForChild("Modules"):WaitForChild("ItemTypes"):WaitForChild("Gun")) end)
        pcall(function() UtilityModule = require(ReplicatedStorage:WaitForChild("Modules", 5):WaitForChild("Utility", 5)) end)
        pcall(function() EnumLibrary = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("EnumLibrary")) end)
    end)
end)

-- Helpers & Safety Checks
local function is_teammate(player)
    if ffModeEnabled and ffTeamCheckEnabled then
        local myTeam = LocalPlayer:GetAttribute("TeamID")
        local pTeam = player:GetAttribute("TeamID")
        if myTeam ~= nil and pTeam ~= nil and myTeam == pTeam then return true end
    end
    local myTeam = LocalPlayer:GetAttribute("TeamID")
    local pTeam = player:GetAttribute("TeamID")
    if myTeam == nil or pTeam == nil then return false end
    return myTeam == pTeam
end

local function get_character_immune(playerOrChar)
    local char = playerOrChar
    if typeof(playerOrChar) == "Instance" and playerOrChar:IsA("Player") then
        char = playerOrChar.Character
    end
    if not char then return true end
    if char:FindFirstChildOfClass("ForceField") then return true end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and hrp:FindFirstChild("Attachment") then return true end
    local isImmuneAttr = char:GetAttribute("Immune") or char:GetAttribute("Invincible") or char:GetAttribute("IsImmune")
    if isImmuneAttr == true then return true end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if hum.Health <= 0 then return true end
        local humImmune = hum:GetAttribute("Immune") or hum:GetAttribute("Invincible")
        if humImmune == true then return true end
    end
    return false
end

local function is_reflecting_or_parrying(player)
    local char = player and player.Character
    if not char then return false end

    local reflectAttrs = {"Reflecting", "IsReflecting", "BulletReflect", "Reflect", "Deflecting", "Parrying"}
    for _, attr in ipairs(reflectAttrs) do
        local val = char:GetAttribute(attr)
        if val == true or val == 1 or val == "true" then return true end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local hVal = hum:GetAttribute(attr)
            if hVal == true or hVal == 1 then return true end
        end
    end

    local isKatana = false
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and string.find(string.lower(tool.Name), "katana", 1, true) then isKatana = true end
    for _, child in ipairs(char:GetChildren()) do
        local childName = string.lower(child.Name)
        if string.find(childName, "katana", 1, true) then isKatana = true end
        if string.find(childName, "reflect", 1, true) or string.find(childName, "deflect", 1, true) then return true end
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local ok, anims = pcall(function() return hum:GetPlayingAnimationTracks() end)
        if ok and anims then
            for _, track in ipairs(anims) do
                local animName = string.lower(tostring(track.Name or ""))
                local animId = ""
                pcall(function()
                    if track.Animation then animId = tostring(track.Animation.AnimationId or "") end
                end)
                local fullStr = animName .. " " .. string.lower(animId)
                if string.find(fullStr, "reflect", 1, true) or string.find(fullStr, "deflect", 1, true)
                    or string.find(fullStr, "parry", 1, true) or string.find(fullStr, "block", 1, true) then
                    if isKatana or string.find(fullStr, "katana", 1, true) then return true end
                    if string.find(fullStr, "reflect", 1, true) or string.find(fullStr, "deflect", 1, true) then return true end
                end
            end
        end
    end
    return false
end

local function get_character_root(char)
    if not char then return nil end
    return char:FindFirstChild("HitboxHead")
        or char:FindFirstChild("HitboxHeadSmall")
        or char:FindFirstChild("Head")
end

local function can_shoot()
    local canShoot = true
    pcall(function()
        if not FighterController or not FighterController.LocalFighter then return end
        local item = FighterController.LocalFighter.EquippedItem
        if not item then canShoot = false; return end
        local function getProp(key)
            local ok, res = pcall(function()
                if item.Get then return item:Get(key) end
                return item[key] or (item.Data and item.Data[key]) or (item.Info and item.Info[key])
            end)
            return ok and res or nil
        end
        local ammo = getProp("CurrentAmmo") or getProp("Ammo") or getProp("Bullets") or getProp("MagazineAmmo")
        local isReloading = getProp("Reloading") or getProp("IsReloading")
        if item.Info and type(item.Info) == "table" then
            if ammo == nil then ammo = item.Info.CurrentAmmo or item.Info.Ammo end
            if item.Info.Reloading == true or item.Info.IsReloading == true then isReloading = true end
        end
        if isReloading == true or (typeof(ammo) == "number" and ammo <= 0) then canShoot = false end
    end)
    return canShoot
end

local function has_line_of_sight(targetPart, myChar)
    if not targetPart then return false end
    local origin = Camera.CFrame.Position
    local dir = targetPart.Position - origin
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { myChar, Camera }
    params.IgnoreWater = true
    local result = Workspace:Raycast(origin, dir, params)
    if not result then return true end
    local model = result.Instance and result.Instance:FindFirstAncestorOfClass("Model")
    return model == targetPart:FindFirstAncestorOfClass("Model")
end

-- ============================================================================


-- ============================================================================
-- PASTED RAGEBOT ENGINE (no dual UI �� wired to Valk toggles)
-- ============================================================================
local function setRagebotStatus(active, target)
    -- indicator uses activeTargetPart / ragebotOrKillAura
    if active and target and target.Character then
        activeTargetPart = target.Character:FindFirstChild("HitboxHead")
            or target.Character:FindFirstChild("Head")
    elseif not active then
        activeTargetPart = nil
    end
end

-- RAGEBOT SETTINGS
-- ============================================================================
local RagebotSettings = {
    on = false,
    targetMode = "Closest",
    autoSwitch = true,
    autoSwapSecondary = true,
    autoReloadPrimary = true,
    primarySlot = 1,
    secondarySlot = 2,
    acSpd = 0.05,
    shootDelay = 0,
    teleportDelay = 0.04,
    orbitDist = 3,
    orbitHeight = 2,
    randomMovement = false,
    randomRefresh = 0.08,
    mode = "Orbit",
    strafeSpeed = 5,
    undergroundDepth = 6,
    behindDist = 4,
    antiAim = false,
    hyper = false,
    useManipulation = true,
    voidSpam = true,
    voidHideTime = 0.25,
    voidShootTime = 0.03,
    shootAttempts = 1,
    otherMatchAvoidDistance = 1000,
    settleUntil = 0,
    dirBack = true, dirFront = false, dirLeft = true, dirRight = true, dirUp = true, dirDown = false,
}

local rbGen = 0
local rbDuelMod, rbInMatchT, rbInMatch = nil, 0, false
local rbTgtT = 0
local slotKey = {[1] = Enum.KeyCode.One, [2] = Enum.KeyCode.Two, [3] = Enum.KeyCode.Three, [4] = Enum.KeyCode.Four}

local util, enums, useItemRemote, fighterCtrl
pcall(function()
    util = require(ReplicatedStorage.Modules.Utility)
    enums = require(ReplicatedStorage.Modules.EnumLibrary)
    useItemRemote = ReplicatedStorage.Remotes.Replication.Fighter.UseItem
    fighterCtrl = require(LocalPlayer.PlayerScripts.Controllers.FighterController)
end)

local function isShootingRange()
    local function matches(value)
        if value == nil then return false end
        local text = tostring(value):lower():gsub("[%s_%-]", "")
        return text:find("shootingrange", 1, true) ~= nil
            or text:find("firingrange", 1, true) ~= nil
            or text:find("�ш꺽��", 1, true) ~= nil
    end
    for _, object in ipairs({workspace, LocalPlayer}) do
        for _, attribute in ipairs({"Map","MapName","Mode","GameMode","Arena","Environment","EnvironmentName","ShootingRange"}) do
            local value = object:GetAttribute(attribute)
            if (value == true and attribute == "ShootingRange") or matches(value) then
                return true
            end
        end
    end
    return false
end

local IDKRagebotState = {
    active = false, target = nil, conn = nil, ammoThread = nil, voidThread = nil,
    voidHbConn = nil, csyncHbConn = nil, voidExposed = false, voidTargetCF = nil,
    nextTeleportAt = 0, ammoActionAt = 0, hideOrbitUntil = 0, randPos = nil, randT = 0,
    lastFakePos = nil, csyncCF = nil, csyncLV = nil, csyncAV = nil,
    csyncLocalCF = nil, csyncLocalLV = nil, csyncLocalAV = nil, csyncWroteFake = false,
    noclipConn = nil, orbitClientCF = nil, orbitRenderRunning = false, suspended = false,
}

local function getRoot(char) return char and char:FindFirstChild("HumanoidRootPart") end

local function getFighter()
    if fighterCtrl and fighterCtrl.LocalFighter then return fighterCtrl.LocalFighter end
    if fighterCtrl and fighterCtrl.GetFighter then
        local ok, fighter = pcall(fighterCtrl.GetFighter, fighterCtrl, LocalPlayer)
        if ok then return fighter end
    end
    return nil
end

local function pressKey(kc)
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, kc, false, game)
    task.wait(0.03)
    vim:SendKeyEvent(false, kc, false, game)
end

local function scanWeapon(plr)
    local vms = workspace:FindFirstChild("ViewModels")
    if not vms then return "" end
    for _, model in vms:GetChildren() do
        if model:IsA("Model") then
            local sp = model.Name:find(" - ", 1, true)
            if sp and model.Name:sub(1, sp - 1) == plr.Name then
                return model.Name:sub(sp + 3):lower()
            end
        end
    end
    return ""
end

local function playerIsDead(plr)
    local char = plr and plr.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return not char or not hum or hum.Health <= 0 or not getRoot(char)
end

local function isInvincible(plr)
    local char = plr and plr.Character
    if not char then return true end
    local root = getRoot(char)
    if not root then return true end
    for _, obj in root:GetChildren() do
        if obj:IsA("Attachment") and obj.Name == "Attachment" then return true end
    end
    return char:FindFirstChild("InvincibilityParticles", true) ~= nil
end

local function isKatana(plr) return scanWeapon(plr):find("katana", 1, true) ~= nil end

local function isRiotShield(plr)
    local w = scanWeapon(plr)
    return w:find("riot", 1, true) ~= nil or w:find("shield", 1, true) ~= nil
end

local function IsValidMatch(player)
    return player:GetAttribute("EnvironmentID") == LocalPlayer:GetAttribute("EnvironmentID")
end

local function isNearOtherMatch(pos, ignorePlayer)
    local avoid = RagebotSettings.otherMatchAvoidDistance or 1000
    if typeof(pos) ~= "Vector3" or avoid <= 0 then return false end
    for _, plr in Players:GetPlayers() do
        if plr ~= LocalPlayer and plr ~= ignorePlayer and not IsValidMatch(plr) then
            local r = getRoot(plr.Character)
            if r and (r.Position - pos).Magnitude <= avoid then return true end
        end
    end
    return false
end

local function isSafeRagebotPos(pos, targetPlayer) return not isNearOtherMatch(pos, targetPlayer) end

local function shouldSkip(plr)
    if plr == LocalPlayer or playerIsDead(plr) then return true end
    if not IsValidMatch(plr) then return true end
    if isInvincible(plr) then return true end
    local root = getRoot(plr.Character)
    if root and isNearOtherMatch(root.Position, plr) then return true end
    return root and root:FindFirstChild("TeammateLabel") ~= nil
end

local function getBestTarget()
    local root = getRoot(LocalPlayer.Character)
    if not root then return nil end
    if RagebotSettings.prioritizedPlayer then
        local pp = Players:FindFirstChild(RagebotSettings.prioritizedPlayer)
        if pp and not shouldSkip(pp) then return pp end
    end
    local best, bestV = nil, math.huge
    local useHP = RagebotSettings.targetMode == "Lowest Health"
    for _, plr in Players:GetPlayers() do
        if not shouldSkip(plr) then
            local char = plr.Character
            local tr = getRoot(char)
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local value = useHP and hum.Health or (tr.Position - root.Position).Magnitude
            if value < bestV then bestV = value; best = plr end
        end
    end
    return best
end

local function hasValidTarget()
    return IDKRagebotState.target and not playerIsDead(IDKRagebotState.target) and not isInvincible(IDKRagebotState.target)
end

-- �� ��寃� �놁쑝硫� 臾댁“嫄� void...
local function updateRagebotStatus()
    local target = hasValidTarget() and IDKRagebotState.target or nil
    if setRagebotStatus then
        setRagebotStatus(IDKRagebotState.active and RagebotSettings.on, target)
    end
end

local function shouldShoot()
    if not hasValidTarget() then return false end
    if isKatana(IDKRagebotState.target) then return false end
    if RagebotSettings.mode == "Void" and not IDKRagebotState.voidExposed then return false end
    return true
end

local function handleAmmo()
    local fighter = getFighter()
    local item = fighter and fighter.EquippedItem
    if not fighter or not item then return false end
    local ammo = item:Get("Ammo") or 0
    local slot = item:Get("Slot") or 1
    local now = tick()
    if fighter:Get("Reloading") then
        IDKRagebotState.hideOrbitUntil = math.max(IDKRagebotState.hideOrbitUntil or 0, now + 0.25)
        IDKRagebotState.ammoActionAt = math.max(IDKRagebotState.ammoActionAt or 0, now + 0.1)
        return true
    end
    if ammo > 0 then return false end
    if now < (IDKRagebotState.ammoActionAt or 0) then return true end
    local primary = RagebotSettings.primarySlot or 1
    local secondary = RagebotSettings.secondarySlot or 2
    if slot == primary and RagebotSettings.autoSwapSecondary then
        IDKRagebotState.ammoActionAt = now + 0.45
        IDKRagebotState.hideOrbitUntil = math.max(IDKRagebotState.hideOrbitUntil or 0, now + 0.45)
        pressKey(slotKey[secondary] or Enum.KeyCode.Two); return true
    end
    if slot == secondary and RagebotSettings.autoReloadPrimary then
        IDKRagebotState.ammoActionAt = now + 0.6
        IDKRagebotState.hideOrbitUntil = math.max(IDKRagebotState.hideOrbitUntil or 0, now + 0.6)
        pressKey(slotKey[primary] or Enum.KeyCode.One)
        task.delay(0.18, function()
            if not IDKRagebotState.active then return end
            local f2 = getFighter()
            local i2 = f2 and f2.EquippedItem
            if f2 and i2 and (i2:Get("Slot") or 1) == primary and (i2:Get("Ammo") or 0) <= 0 and not f2:Get("Reloading") then
                pressKey(Enum.KeyCode.R)
            end
        end)
        return true
    end
    if slot == primary and RagebotSettings.autoReloadPrimary then
        IDKRagebotState.ammoActionAt = now + 0.5
        IDKRagebotState.hideOrbitUntil = math.max(IDKRagebotState.hideOrbitUntil or 0, now + 0.5)
        pressKey(Enum.KeyCode.R); return true
    end
    return true
end

local function buildCameraData(fromPos, part)
    if not util or not part then return nil end
    local look = CFrame.new(fromPos, part.Position)
    local data = {}
    data[utf8.char(1)] = {
        [utf8.char(0)] = util:EncodeCFrame(look),
        [utf8.char(1)] = util:EncodeCFrame(look),
        [utf8.char(2)] = part,
        [utf8.char(3)] = util:EncodeCFrame(part.CFrame:ToObjectSpace(CFrame.new(part.Position)))
    }
    return data
end

local function doFire(part)
    local fighter = getFighter()
    local item = fighter and fighter.EquippedItem
    if not item or not part then return false end
    local cam = workspace.CurrentCamera
    local fromPos = (IDKRagebotState.csyncCF and IDKRagebotState.csyncCF.Position) or (cam and cam.CFrame.Position) or part.Position
    local anyFired = false
    local attempts = math.max(1, math.floor(RagebotSettings.shootAttempts or 1))
    for _ = 1, attempts do
        local fired = false
        if RagebotSettings.useManipulation and useItemRemote and enums and util then
            local ammo = item.Get and (item:Get("Ammo") or 0) or 0
            if ammo > 0 then
                local oid = item:Get("ObjectID")
                local shootEnum = enums:ToEnum("StartShooting")
                local data = buildCameraData(fromPos, part)
                if oid and shootEnum and data then
                    fired = pcall(function() useItemRemote:FireServer(oid, shootEnum, data, nil) end)
                end
            end
        end
        if not fired and item.UseItem then fired = pcall(function() item:UseItem() end) end
        if not fired and fighter and fighter.UseItem then fired = pcall(function() fighter:UseItem() end) end
        anyFired = anyFired or fired
    end
    return anyFired
end

local function isLobby()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local mg = pg and pg:FindFirstChild("MainGui")
    local mf = mg and mg:FindFirstChild("MainFrame")
    local lb = mf and mf:FindFirstChild("Lobby")
    local cur = lb and lb:FindFirstChild("Currency")
    return cur and cur.Visible == true
end

local function getDuel()
    if not rbDuelMod then
        local ps = LocalPlayer:FindFirstChild("PlayerScripts")
        local ct = ps and ps:FindFirstChild("Controllers")
        local dc = ct and ct:FindFirstChild("DuelController")
        if dc then
            local ok, mod = pcall(require, dc)
            if ok and mod then rbDuelMod = mod end
        end
    end
    if rbDuelMod and rbDuelMod.GetDuel then
        local ok, duel = pcall(rbDuelMod.GetDuel, rbDuelMod, LocalPlayer)
        if ok then return duel end
    end
end

local function isValidMatch()
    if isLobby() or isShootingRange() then return false end
    local char = LocalPlayer.Character
    local root = getRoot(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not root or not hum or hum.Health <= 0 then return false end
    if getDuel() ~= nil then return true end
    return getFighter() ~= nil
end

local function inMatch()
    local now = tick()
    if now - rbInMatchT < 0.25 then return rbInMatch end
    rbInMatchT = now
    rbInMatch = isValidMatch()
    return rbInMatch
end

local function undergroundPos(head, targetRoot)
    local depth = math.clamp(RagebotSettings.undergroundDepth or 6, 3, 8)
    local radius = math.clamp(RagebotSettings.orbitDist or 3, 1.25, 4)
    return head.Position - targetRoot.CFrame.LookVector * radius + Vector3.new(0, -depth, 0)
end

local oldFireServerRagebot
local rbHookInstalled = false
local enterVoidState
local setVoidCsync

local function installRagebotHook()
    if rbHookInstalled or not useItemRemote then return end
    rbHookInstalled = true
    oldFireServerRagebot = hookfunction(useItemRemote.FireServer, newcclosure(function(self, oid, action, cameradata, ...)
        if IDKRagebotState.active and RagebotSettings.on and RagebotSettings.mode == "Void" and RagebotSettings.useManipulation and action == enums:ToEnum("StartShooting") then
            if isLobby() or not inMatch() then
                return oldFireServerRagebot(self, oid, action, cameradata, ...)
            end
            local target = IDKRagebotState.target
            if hasValidTarget() and not isKatana(target) then
                local tc = target.Character
                local tr = getRoot(tc)
                local head = tc and (tc:FindFirstChild("Head") or tr)
                if tr and head then
                    local shootPos = isRiotShield(target)
                        and (tr.Position - tr.CFrame.LookVector * (RagebotSettings.behindDist or 4))
                        or (tr.Position - tr.CFrame.LookVector * 2.5 + Vector3.new(0, 1.5, 0))
                    if not isSafeRagebotPos(shootPos, target) then
                        enterVoidState()
                        return oldFireServerRagebot(self, oid, action, cameradata, ...)
                    end
                    local shootCF = CFrame.new(shootPos, head.Position)
                    IDKRagebotState.voidExposed = true
                    IDKRagebotState.voidTargetCF = shootCF
                    setVoidCsync(shootCF, Vector3.zero, Vector3.zero)
                    updateRagebotStatus()
                    task.wait(0.02)
                    local newData = buildCameraData(shootPos, head) or cameradata
                    task.spawn(function()
                        task.wait(0.05)
                        enterVoidState()
                    end)
                    return oldFireServerRagebot(self, oid, action, newData, ...)
                end
            end
        end
        return oldFireServerRagebot(self, oid, action, cameradata, ...)
    end))
end

local function rnd() return math.random() * 2 - 1 end
local function rndDir()
    local angle = math.random() * math.pi * 2
    return Vector3.new(math.cos(angle), 0, math.sin(angle))
end

local function getDirs(targetRoot)
    local dirs = {}
    local look = targetRoot.CFrame.LookVector
    local right = targetRoot.CFrame.RightVector
    if RagebotSettings.dirBack then table.insert(dirs, -look) end
    if RagebotSettings.dirFront then table.insert(dirs, look) end
    if RagebotSettings.dirLeft then table.insert(dirs, -right) end
    if RagebotSettings.dirRight then table.insert(dirs, right) end
    if #dirs == 0 then dirs[1] = -look; dirs[2] = right; dirs[3] = -right end
    return dirs
end

local function pickOffset(targetRoot, head)
    local dirs = getDirs(targetRoot)
    local dir = dirs[math.random(1, #dirs)]
    local radius = math.clamp(RagebotSettings.orbitDist or 3, 1.25, 5)
    local height = math.clamp(RagebotSettings.orbitHeight or 2, -2, 6)
    local pos = head.Position + dir * radius + Vector3.new(0, height, 0)
    if RagebotSettings.dirUp and math.random() < 0.2 then
        pos += Vector3.new(0, math.max(1, height), 0)
    elseif RagebotSettings.dirDown and math.random() < 0.15 then
        pos += Vector3.new(0, -math.max(1, math.min(3, RagebotSettings.undergroundDepth or 2)), 0)
    end
    return pos
end

local function setCsync(cf, pos, dt)
    local old = IDKRagebotState.lastFakePos
    IDKRagebotState.csyncCF = cf
    IDKRagebotState.csyncLV = old and dt and dt > 0 and (pos - old) / dt or Vector3.zero
    IDKRagebotState.csyncAV = Vector3.zero
    IDKRagebotState.lastFakePos = pos
end

local function clearCsyncTarget()
    IDKRagebotState.csyncCF = nil
    IDKRagebotState.csyncLV = nil
    IDKRagebotState.csyncAV = nil
    IDKRagebotState.lastFakePos = nil
end

local function isRagebotSettling()
    return os.clock() < (RagebotSettings.settleUntil or 0)
end

local function restoreLocalRoot(root)
    if not root or not IDKRagebotState.csyncLocalCF then return false end
    local liveVelocity = root.AssemblyLinearVelocity
    root.CFrame = IDKRagebotState.csyncLocalCF
    if IDKRagebotState.csyncLocalLV then
        root.AssemblyLinearVelocity = Vector3.new(IDKRagebotState.csyncLocalLV.X, liveVelocity.Y, IDKRagebotState.csyncLocalLV.Z)
    end
    if IDKRagebotState.csyncLocalAV then
        root.AssemblyAngularVelocity = IDKRagebotState.csyncLocalAV
    end
    return true
end

local function startCsync()
    if IDKRagebotState.csyncHbConn then return end
    IDKRagebotState.csyncHbConn = RunService.Heartbeat:Connect(function()
        local root = getRoot(LocalPlayer.Character)
        if not root then return end
        if IDKRagebotState.csyncWroteFake and IDKRagebotState.csyncLocalCF then
            restoreLocalRoot(root)
        end
        if isRagebotSettling() then
            IDKRagebotState.csyncLocalCF = root.CFrame
            IDKRagebotState.csyncLocalLV = root.AssemblyLinearVelocity
            IDKRagebotState.csyncLocalAV = root.AssemblyAngularVelocity
            IDKRagebotState.csyncWroteFake = false
            return
        end
        IDKRagebotState.csyncLocalCF = root.CFrame
        IDKRagebotState.csyncLocalLV = root.AssemblyLinearVelocity
        IDKRagebotState.csyncLocalAV = root.AssemblyAngularVelocity
        if IDKRagebotState.csyncCF then
            root.CFrame = IDKRagebotState.csyncCF
            local fakeVelocity = IDKRagebotState.csyncLV or IDKRagebotState.csyncLocalLV or root.AssemblyLinearVelocity
            local localVelocity = IDKRagebotState.csyncLocalLV or root.AssemblyLinearVelocity
            root.AssemblyLinearVelocity = Vector3.new(fakeVelocity.X, localVelocity.Y, fakeVelocity.Z)
            root.AssemblyAngularVelocity = IDKRagebotState.csyncAV or IDKRagebotState.csyncLocalAV or root.AssemblyAngularVelocity
            IDKRagebotState.csyncWroteFake = true
        else
            IDKRagebotState.csyncWroteFake = false
        end
    end)
    RunService:BindToRenderStep("IDK_RagebotCsync", Enum.RenderPriority.Camera.Value - 1, function()
        local root = getRoot(LocalPlayer.Character)
        if not root or not IDKRagebotState.csyncLocalCF then return end
        if IDKRagebotState.csyncWroteFake and restoreLocalRoot(root) then
            IDKRagebotState.csyncWroteFake = false
        end
    end)
end

local function stopCsync()
    if IDKRagebotState.csyncHbConn then IDKRagebotState.csyncHbConn:Disconnect(); IDKRagebotState.csyncHbConn = nil end
    RunService:UnbindFromRenderStep("IDK_RagebotCsync")
    restoreLocalRoot(getRoot(LocalPlayer.Character))
    clearCsyncTarget()
    IDKRagebotState.csyncLocalCF = nil
    IDKRagebotState.csyncLocalLV = nil
    IDKRagebotState.csyncLocalAV = nil
    IDKRagebotState.csyncWroteFake = false
end

local function voidRand()
    local n = math.random(-2147483646, 2147483646)
    repeat n = math.random(-2147483646, 2147483646)
    until n < -1147483646 or n > 1147483646
    return n
end

local function voidRandCF()
    return CFrame.new(voidRand(), voidRand(), voidRand()) * CFrame.Angles(math.pi, math.pi, math.pi)
end

setVoidCsync = function(cf, lv, av)
    IDKRagebotState.csyncCF = cf
    IDKRagebotState.csyncLV = lv or Vector3.zero
    IDKRagebotState.csyncAV = av or Vector3.zero
    IDKRagebotState.lastFakePos = cf and cf.Position or nil
end

enterVoidState = function()
    IDKRagebotState.voidTargetCF = nil
    IDKRagebotState.voidExposed = false
    IDKRagebotState.orbitClientCF = nil
    if not IDKRagebotState.active or not RagebotSettings.on then
        clearCsyncTarget()
        updateRagebotStatus()
        return
    end
    if RagebotSettings.voidSpam then
        setVoidCsync(voidRandCF())
    else
        clearCsyncTarget()
    end
    updateRagebotStatus()
end

local function enableVoidCsync()
    if IDKRagebotState.voidHbConn then return end
    startCsync()
    IDKRagebotState.voidHbConn = RunService.Heartbeat:Connect(function()
        if isRagebotSettling() then
            IDKRagebotState.voidTargetCF = nil
            IDKRagebotState.voidExposed = false
            clearCsyncTarget()
            return
        end
        local tcf = IDKRagebotState.voidTargetCF
        if tcf then
            setVoidCsync(tcf, Vector3.zero, Vector3.zero)
        elseif RagebotSettings.voidSpam then
            setVoidCsync(voidRandCF())
        else
            clearCsyncTarget()
        end
    end)
end

local function disableVoidCsync()
    if IDKRagebotState.voidHbConn then IDKRagebotState.voidHbConn:Disconnect(); IDKRagebotState.voidHbConn = nil end
    RunService:UnbindFromRenderStep("IDK_RagebotVoid")
    IDKRagebotState.voidTargetCF = nil
    IDKRagebotState.voidThread = nil
    IDKRagebotState.voidExposed = false
end

local function StartOrbitRenderFix()
    if IDKRagebotState.orbitRenderRunning then return end
    IDKRagebotState.orbitRenderRunning = true
    RunService:BindToRenderStep("IDK_RagebotOrbit", Enum.RenderPriority.First.Value, function()
        if not IDKRagebotState.orbitClientCF then return end
        local root = getRoot(LocalPlayer.Character)
        if not root then return end
        root.CFrame = IDKRagebotState.orbitClientCF
    end)
end

local function StopOrbitRenderFix()
    if not IDKRagebotState.orbitRenderRunning then return end
    RunService:UnbindFromRenderStep("IDK_RagebotOrbit")
    IDKRagebotState.orbitRenderRunning = false
    IDKRagebotState.orbitClientCF = nil
end

local function startVoidLoop(myGen)
    if IDKRagebotState.voidThread then return end
    enableVoidCsync()
    local vt
    vt = task.spawn(function()
        while IDKRagebotState.active and RagebotSettings.on and rbGen == myGen and not IDKRagebotState.suspended do
            if isRagebotSettling() then
                IDKRagebotState.voidTargetCF = nil
                IDKRagebotState.voidExposed = false
                clearCsyncTarget()
                task.wait(0.03)
                continue
            end
            if not inMatch() or not hasValidTarget() or isKatana(IDKRagebotState.target) then
                enterVoidState(); task.wait(0.1); continue
            end
            enterVoidState()
            if RagebotSettings.voidHideTime > 0 then task.wait(RagebotSettings.voidHideTime) end
            if not IDKRagebotState.active or not RagebotSettings.on or rbGen ~= myGen or IDKRagebotState.suspended or not inMatch() then break end
            local target = IDKRagebotState.target
            if hasValidTarget() and not isKatana(target) then
                local tc = target.Character
                local tr = getRoot(tc)
                local head = tc and (tc:FindFirstChild("Head") or tr)
                if tr and head then
                    local shootPos = isRiotShield(target)
                        and (tr.Position - tr.CFrame.LookVector * (RagebotSettings.behindDist or 4))
                        or (tr.Position - tr.CFrame.LookVector * 2.5 + Vector3.new(0, 1.5, 0))
                    if not isSafeRagebotPos(shootPos, target) then
                        enterVoidState(); task.wait(0.1); continue
                    end
                    local shootCF = CFrame.new(shootPos, head.Position)
                    IDKRagebotState.voidExposed = true
                    IDKRagebotState.voidTargetCF = shootCF
                    setVoidCsync(shootCF, Vector3.zero, Vector3.zero)
                    updateRagebotStatus()
                    if RagebotSettings.voidShootTime > 0 then task.wait(RagebotSettings.voidShootTime) end
                    if hasValidTarget() and not isKatana(target) then doFire(head) end
                    task.wait(0.05)
                    enterVoidState()
                end
            end
        end
        if IDKRagebotState.voidThread == vt then IDKRagebotState.voidThread = nil end
        if rbGen == myGen and not IDKRagebotState.suspended and IDKRagebotState.voidThread == nil then
            disableVoidCsync()
        end
    end)
    IDKRagebotState.voidThread = vt
end

local function enableNoclip()
    if IDKRagebotState.noclipConn then return end
    IDKRagebotState.noclipConn = RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in char:GetDescendants() do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end)
end

local function startAmmoLoop()
    if IDKRagebotState.ammoThread then return end
    IDKRagebotState.ammoThread = task.spawn(function()
        while IDKRagebotState.active do
            if isShootingRange() then task.wait(0.1); continue end
            if not handleAmmo() and shouldShoot() and not RagebotSettings.hyper then
                local tc = IDKRagebotState.target and IDKRagebotState.target.Character
                local head = tc and (tc:FindFirstChild("Head") or getRoot(tc))
                if head then
                    if RagebotSettings.shootDelay > 0 then task.wait(RagebotSettings.shootDelay) end
                    doFire(head)
                end
            end
            task.wait(math.max(0.01, RagebotSettings.acSpd))
        end
        IDKRagebotState.ammoThread = nil
    end)
end

local function stopRagebot()
    rbGen += 1
    IDKRagebotState.active = false
    RagebotSettings.on = false
    if setRagebotStatus then setRagebotStatus(false) end
    if IDKRagebotState.conn then IDKRagebotState.conn:Disconnect(); IDKRagebotState.conn = nil end
    if IDKRagebotState.noclipConn then IDKRagebotState.noclipConn:Disconnect(); IDKRagebotState.noclipConn = nil end
    IDKRagebotState.target = nil
    IDKRagebotState.voidExposed = false
    IDKRagebotState.nextTeleportAt = 0
    IDKRagebotState.ammoActionAt = 0
    IDKRagebotState.hideOrbitUntil = 0
    IDKRagebotState.randPos = nil
    IDKRagebotState.randT = 0
    IDKRagebotState.lastFakePos = nil
    rbInMatchT = 0
    rbInMatch = false
    stopCsync(); disableVoidCsync(); StopOrbitRenderFix()
    local char = LocalPlayer.Character
    if char then
        for _, part in char:GetDescendants() do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

local function startRagebot()
    if IDKRagebotState.active then return end
    IDKRagebotState.active = true
    RagebotSettings.on = true
    RagebotSettings.settleUntil = 0
    rbGen += 1
    local myGen = rbGen
    if setRagebotStatus then setRagebotStatus(true, nil) end
    startAmmoLoop()
    installRagebotHook()
    enableNoclip()
    if RagebotSettings.mode == "Void" then startVoidLoop(myGen)
    elseif RagebotSettings.mode == "Orbit" then enableVoidCsync()
    else startCsync() end

    local aaPhase = 0
    local orbitAngle = math.random() * math.pi * 2

    IDKRagebotState.conn = RunService.Stepped:Connect(function(_, dt)
        if not IDKRagebotState.active or not RagebotSettings.on then
            if IDKRagebotState.conn then IDKRagebotState.conn:Disconnect(); IDKRagebotState.conn = nil end
            return
        end
        if isShootingRange() then
            if not IDKRagebotState.suspended then
                IDKRagebotState.suspended = true
                IDKRagebotState.target = nil
                IDKRagebotState.randPos = nil
                IDKRagebotState.voidTargetCF = nil
                IDKRagebotState.voidExposed = false
                if IDKRagebotState.noclipConn then IDKRagebotState.noclipConn:Disconnect(); IDKRagebotState.noclipConn = nil end
                stopCsync(); disableVoidCsync(); StopOrbitRenderFix()
                updateRagebotStatus()
            end
            return
        end
        if IDKRagebotState.suspended then
            IDKRagebotState.suspended = false
            enableNoclip()
            if RagebotSettings.mode == "Void" then startVoidLoop(myGen)
            elseif RagebotSettings.mode == "Orbit" then enableVoidCsync(); StartOrbitRenderFix()
            else startCsync() end
        end
        local root = getRoot(LocalPlayer.Character)
        if not root then return end
        if isRagebotSettling() then
            IDKRagebotState.voidTargetCF = nil
            IDKRagebotState.voidExposed = false
            IDKRagebotState.orbitClientCF = nil
            clearCsyncTarget()
            updateRagebotStatus()
            return
        end
        if not inMatch() then
            clearCsyncTarget()
            IDKRagebotState.target = nil
            updateRagebotStatus()
            return
        end
        local now = tick()
        if IDKRagebotState.target and playerIsDead(IDKRagebotState.target) then
            IDKRagebotState.target = nil
        end
        if IDKRagebotState.target and isInvincible(IDKRagebotState.target) then
            clearCsyncTarget(); updateRagebotStatus(); return
        end
        if now - rbTgtT >= 0.05 and (RagebotSettings.autoSwitch or not IDKRagebotState.target) then
            rbTgtT = now
            if RagebotSettings.autoSwitch then
                local t = getBestTarget()
                if t then IDKRagebotState.target = t end
            elseif not IDKRagebotState.target then
                IDKRagebotState.target = getBestTarget()
            end
        end
        if not IDKRagebotState.target then
            clearCsyncTarget(); updateRagebotStatus(); return
        end
        local tc = IDKRagebotState.target.Character
        local tr = getRoot(tc)
        local head = tc and (tc:FindFirstChild("Head") or tr)
        if not tc or not tr or not head then
            IDKRagebotState.target = nil; updateRagebotStatus(); return
        end
        if isNearOtherMatch(tr.Position, IDKRagebotState.target) then
            IDKRagebotState.target = nil
            IDKRagebotState.randPos = nil
            clearCsyncTarget(); updateRagebotStatus(); return
        end
        updateRagebotStatus()
        if RagebotSettings.mode == "Void" then return end
        if RagebotSettings.mode == "Orbit" and (now < (IDKRagebotState.hideOrbitUntil or 0) or handleAmmo()) then
            IDKRagebotState.voidTargetCF = nil
            IDKRagebotState.voidExposed = false
            IDKRagebotState.orbitClientCF = nil
            enterVoidState(); return
        end
        local isUnderground = RagebotSettings.mode == "Underground"
        local isShield = isRiotShield(IDKRagebotState.target)
        local height = math.clamp(RagebotSettings.orbitHeight or 2, -2, 6)
        local radius = math.clamp(RagebotSettings.orbitDist or 3, 1.25, 5)
        local targetPos
        if isShield then
            targetPos = tr.Position - tr.CFrame.LookVector * (RagebotSettings.behindDist or 3)
        elseif isUnderground then
            targetPos = undergroundPos(head, tr)
        elseif RagebotSettings.mode == "Teleport" then
            if RagebotSettings.randomMovement then
                if not IDKRagebotState.randPos or (now - (IDKRagebotState.randT or 0)) >= (RagebotSettings.randomRefresh or 0.08) then
                    IDKRagebotState.randT = now
                    IDKRagebotState.randPos = pickOffset(tr, head) + rndDir() * (math.random() * 1.05) + Vector3.new(0, rnd() * 0.7, 0)
                end
                targetPos = IDKRagebotState.randPos
            else
                targetPos = pickOffset(tr, head)
            end
        elseif RagebotSettings.mode == "Orbit" then
            orbitAngle += dt * math.max(1, (RagebotSettings.strafeSpeed or 5) * 1.5)
            targetPos = head.Position + Vector3.new(math.cos(orbitAngle) * radius, height, math.sin(orbitAngle) * radius)
        else
            targetPos = undergroundPos(head, tr)
        end
        if not isSafeRagebotPos(targetPos, IDKRagebotState.target) then
            IDKRagebotState.randPos = nil
            clearCsyncTarget(); updateRagebotStatus(); return
        end
        local faceCF = CFrame.new(targetPos, head.Position)
        if RagebotSettings.antiAim then
            aaPhase += dt * 20
            faceCF = CFrame.new(targetPos, head.Position) * CFrame.Angles(0, math.rad(math.sin(aaPhase) * 70), 0)
        end
        if RagebotSettings.mode == "Orbit" then
            if RagebotSettings.hyper or not isUnderground then
                IDKRagebotState.voidExposed = true
                IDKRagebotState.voidTargetCF = faceCF
                setCsync(faceCF, targetPos, dt)
                updateRagebotStatus()
                if shouldShoot() then doFire(head) end
            end
        else
            setCsync(faceCF, targetPos, dt)
            if RagebotSettings.hyper then
                if shouldShoot() then doFire(head) end
            elseif RagebotSettings.mode == "Teleport" and not isUnderground then
                if now >= (IDKRagebotState.nextTeleportAt or 0) then
                    IDKRagebotState.nextTeleportAt = now + math.max(0.01, RagebotSettings.teleportDelay or 0.04)
                    if shouldShoot() then doFire(head) end
                end
            end
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        stopCsync(); disableVoidCsync(); StopOrbitRenderFix()
        IDKRagebotState.target = nil
        clearCsyncTarget()
        IDKRagebotState.csyncLocalCF = nil
        IDKRagebotState.csyncLocalLV = nil
        IDKRagebotState.csyncLocalAV = nil
        IDKRagebotState.csyncWroteFake = false
        IDKRagebotState.voidExposed = false
        IDKRagebotState.hideOrbitUntil = 0
        if IDKRagebotState.active then
            task.wait(0.5)
            if IDKRagebotState.active then
                if RagebotSettings.mode == "Void" then startVoidLoop(myGen)
                elseif RagebotSettings.mode == "Orbit" then enableVoidCsync(); StartOrbitRenderFix()
                else startCsync() end
            end
        end
    end)
end

-- ============================================================================
-- Indicators
-- ============================================================================
local _9376x428 = Instance.new("ScreenGui")
_9376x428.Name = "HalmuIndicators"
_9376x428.ResetOnSpawn = false
_9376x428.IgnoreGuiInset = true
_9376x428.DisplayOrder = 999
_9376x428.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() _9376x428.Parent = game:GetService("CoreGui") end)
if not _9376x428.Parent then _9376x428.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local _993_318 = Instance.new("TextLabel")
_993_318.Name = "RagebotIndicator"
_993_318.BackgroundTransparency = 1
_993_318.Size = UDim2.new(0, 420, 0, 22)
_993_318.AnchorPoint = Vector2.new(0.5, 0)
_993_318.Position = UDim2.new(0.5, 0, 0.5, 36)
_993_318.Font = Enum.Font.Code
_993_318.TextSize = 14
_993_318.TextColor3 = Color3.fromRGB(255, 60, 60)
_993_318.TextStrokeTransparency = 0
_993_318.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
_993_318.Text = ""
_993_318.Visible = false
_993_318.Parent = _9376x428

local _0011Il00 = Instance.new("TextLabel")
_0011Il00.Name = "AmmoIndicator"
_0011Il00.BackgroundTransparency = 1
_0011Il00.Size = UDim2.new(0, 420, 0, 18)
_0011Il00.AnchorPoint = Vector2.new(0.5, 0)
_0011Il00.Position = UDim2.new(0.5, 0, 0.5, 52)
_0011Il00.Font = Enum.Font.Code
_0011Il00.TextSize = 11
_0011Il00.TextColor3 = Color3.fromRGB(255, 60, 60)
_0011Il00.TextStrokeTransparency = 0
_0011Il00.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
_0011Il00.Text = ""
_0011Il00.Visible = false
_0011Il00.Parent = _9376x428

-- �� ��寃� �놁쑝硫� 臾댁“嫄� void...
function setRagebotStatus(enabled, target)
    if not _993_318 then return end
    if not enabled then _993_318.Visible = false; return end
    if target then
        local name = (target.DisplayName or target.Name or "target")
        _993_318.Text = "ragebot : killing " .. tostring(name) .. "..."
    else
        _993_318.Text = "ragebot : void..."
    end
    _993_318.Visible = true
end

local function get_local_ammo_status()
    local v43335, _0xfd96, L505_10 = nil, nil, false
    pcall(function()
        local _3213x326 = LocalPlayer.PlayerScripts
        local _0x9ec3, _0lO010OIIO = pcall(require, _3213x326.Controllers.FighterController)
        if not _0x9ec3 or not _0lO010OIIO then return end
        local _0x3584 = _0lO010OIIO.LocalFighter
        if not _0x3584 then return end
        local _549_282 = _0x3584.EquippedItem
        if not _549_282 then return end
        local function get_property(key)
            local L704_40, L619_44 = pcall(function()
                if _549_282.Get then return _549_282:Get(key) end
                return _549_282[key] or (_549_282.Data and _549_282.Data[key]) or (_549_282.Info and _549_282.Info[key])
            end)
            if L704_40 then return L619_44 end
            return nil
        end
        v43335 = get_property("CurrentAmmo") or get_property("Ammo") or get_property("Bullets") or get_property("MagazineAmmo")
        _0xfd96 = get_property("ReserveAmmo") or get_property("StoredAmmo") or get_property("Reserve") or get_property("TotalAmmo") or get_property("MaxAmmo") or get_property("MaxBullets")
        local L616_26 = get_property("Reloading") or get_property("IsReloading") or get_property("Reload")
        L505_10 = L616_26 == true
        if _549_282.Info and type(_549_282.Info) == "table" then
            if v43335 == nil then v43335 = _549_282.Info.CurrentAmmo or _549_282.Info.Ammo end
            if _0xfd96 == nil then _0xfd96 = _549_282.Info.ReserveAmmo or _549_282.Info.StoredAmmo or _549_282.Info.MaxAmmo end
            if _549_282.Info.Reloading == true or _549_282.Info.IsReloading == true then L505_10 = true end
        end
    end)
    return v43335, _0xfd96, L505_10
end

RunService.RenderStepped:Connect(function()
    if a41b78c88 then
        local v43335, _0xfd96, L505_10 = get_local_ammo_status()
        local __UGHeELfMSX
        if L505_10 then __UGHeELfMSX = "reloading"
        elseif typeof(v43335) == "number" and typeof(_0xfd96) == "number" then
            __UGHeELfMSX = string.format("%d/%d", math.floor(v43335 + 0.5), math.floor(_0xfd96 + 0.5))
        elseif typeof(v43335) == "number" then
            __UGHeELfMSX = tostring(math.floor(v43335 + 0.5))
        else __UGHeELfMSX = nil end
        if __UGHeELfMSX then
            _0011Il00.Text = __UGHeELfMSX
            _0011Il00.Position = UDim2.new(0.5, 0, 0.5, 52)
            _0011Il00.Visible = true
        else _0011Il00.Visible = false end
    else _0011Il00.Visible = false end
end)

-- ============================================================================
-- Wallbang (Head/Body/Auto 泥댁씤�� �좎�, Desync Always On �쒓굅)
-- ============================================================================
local _GunItem, _Utility
pcall(function() _GunItem = require(LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun) end)
pcall(function() _Utility = require(ReplicatedStorage.Modules.Utility) end)

local wbAimPart = "Head"

local WallbangController = {}
do
    WallbangController.active = false
    WallbangController.startShootingRef = nil
    WallbangController.desyncCleanup = nil

    WallbangController.Desync = {}
    do
        WallbangController.Desync.active = false
        WallbangController.Desync.connection = nil
        WallbangController.Desync.currentTarget = nil

        function WallbangController.Desync:Start(target)
            self:Stop()
            self.active = true
            self.connection = RunService.Heartbeat:Connect(function()
                if not self.active then return end
                local char = LocalPlayer.Character
                local rootPart = char and char:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end
                local targetRoot = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                if not targetRoot then self:Stop() return end
                self.currentTarget = target
                local desyncCFrame = targetRoot.CFrame * CFrame.new(0, -5, 0)
                local backupCFrame = rootPart.CFrame
                local backupVelocity = rootPart.Velocity
                local backupRotVelocity = rootPart.RotVelocity
                rootPart.CFrame = desyncCFrame
                RunService:BindToRenderStep('wb_desync_fallback', 101, function()
                    if rootPart and rootPart.Parent then
                        rootPart.CFrame = backupCFrame
                        rootPart.Velocity = backupVelocity
                        rootPart.RotVelocity = backupRotVelocity
                    end
                    RunService:UnbindFromRenderStep('wb_desync_fallback')
                end)
                self:Stop()
            end)
        end

        function WallbangController.Desync:Stop()
            self.active = false
            self.currentTarget = nil
            if self.connection then self.connection:Disconnect(); self.connection = nil end
        end
    end

    WallbangController.Target = {}
    do
        WallbangController.Target.active = true
        WallbangController.Target.target = nil
        WallbangController.Target.connection = nil

        function WallbangController.Target:IsValidTarget(character)
            local rootPart = character:FindFirstChild('HumanoidRootPart')
            local head = character:FindFirstChild('Head')
            local humanoid = character:FindFirstChildWhichIsA('Humanoid')
            return rootPart and head and humanoid and humanoid.Health > 0 or false
        end

        function WallbangController.Target:IsValidTeam(player)
            return player:GetAttribute('TeamID') ~= LocalPlayer:GetAttribute('TeamID')
        end

        function WallbangController.Target:GetClosestTarget()
            local closestTarget = nil
            local maxDistance = math.huge
            local mousePos = UserInputService:GetMouseLocation()
            for _, player in next, Players:GetPlayers() do
                if player == LocalPlayer then continue end
                if not self:IsValidTeam(player) then continue end
                local character = player.Character
                if not character then continue end
                if not self:IsValidTarget(character) then continue end
                local rootPart = character.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if not onScreen then continue end
                local targetDist = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).magnitude
                if targetDist > maxDistance then continue end
                maxDistance = targetDist
                closestTarget = player
            end
            return closestTarget
        end

        function WallbangController.Target:Start()
            if self.connection then return end
            self.connection = RunService.Heartbeat:Connect(function()
                if not self.active then return end
                self.target = self:GetClosestTarget()
            end)
        end

        function WallbangController.Target:Stop()
            self.active = false
            if self.connection then self.connection:Disconnect(); self.connection = nil end
        end
    end

    local function resolve_aim_part(targetPlayer)
        if wbAimPart == "Head" then return "Head" end
        if wbAimPart == "Body" then return "Body" end
        local char = targetPlayer and targetPlayer.Character
        if not char then return "Body" end
        local head = char:FindFirstChild("Head")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not head or not root then return "Body" end
        local mousePos = UserInputService:GetMouseLocation()
        local headPos = Camera:WorldToViewportPoint(head.Position)
        if not headPos then return "Body" end
        if mousePos.Y > headPos.Y then return "Body" end
        return "Head"
    end

    function WallbangController:Start()
        if not _GunItem or not _Utility then return end
        self:Stop()
        self.active = true
        self.startShootingRef = _GunItem.StartShooting
        WallbangController.Target.active = true
        WallbangController.Target:Start()

        _GunItem.StartShooting = function(controller, ...)
            local result = {self.startShootingRef(controller, ...)}
            local clientFighter = controller.ClientFighter
            if not clientFighter.IsLocalPlayer then return unpack(result) end
            local cameraData = result[3]
            if not cameraData or typeof(cameraData) ~= 'table' then return unpack(result) end
            result[4] = true
            local targetPlayer = WallbangController.Target.target
            if not self.active or not targetPlayer or (targetPlayer and not targetPlayer.Character) then return unpack(result) end
            if WallbangController.Desync.currentTarget ~= targetPlayer then
                WallbangController.Desync:Start(targetPlayer)
                task.wait(0.05)
            end
            if self.desyncCleanup then task.cancel(self.desyncCleanup); self.desyncCleanup = nil end
            local aimPart = resolve_aim_part(targetPlayer)
            local targetChar = targetPlayer.Character
            local targetPart
            if aimPart == "Head" then
                targetPart = targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart")
            else
                targetPart = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Head")
            end
            if not targetPart then return unpack(result) end
            local targetPos = targetPart.Position
            local targetCFrame = targetPart.CFrame
            local shootingPos = targetPos - Vector3.new(0, 5, 0)
            local shootingOffset = targetCFrame:ToObjectSpace(CFrame.new(targetPos + Vector3.new(math.random(), math.random(), math.random())))
            cameraData[utf8.char(0)] = _Utility:EncodeCFrame(CFrame.new(shootingPos, targetPos) * CFrame.Angles(CFrame.lookAt(shootingPos, targetPos):ToOrientation()))
            cameraData[utf8.char(1)] = _Utility:EncodeCFrame(CFrame.new(targetPos) * CFrame.Angles(CFrame.lookAt(shootingPos, targetPos):ToOrientation()))
            cameraData[utf8.char(2)] = targetPart
            cameraData[utf8.char(3)] = _Utility:EncodeCFrame(shootingOffset)
            self.desyncCleanup = task.delay(0.15, function() WallbangController.Desync:Stop() end)
            return unpack(result)
        end
    end

    function WallbangController:Stop()
        self.active = false
        if _GunItem and self.startShootingRef then _GunItem.StartShooting = self.startShootingRef end
        WallbangController.Desync:Stop()
        WallbangController.Target:Stop()
        if self.desyncCleanup then task.cancel(self.desyncCleanup); self.desyncCleanup = nil end
    end
end


-- Wire Valk toggles <-> RagebotSettings
task.spawn(function()
    local lastOn = false
    while true do
        task.wait(0.15)
        pcall(function()
            RagebotSettings.voidHideTime = voidHideTime or RagebotSettings.voidHideTime
            RagebotSettings.voidShootTime = voidShootTime or RagebotSettings.voidShootTime
            RagebotSettings.voidSpam = voidSpamEnabled == true
            RagebotSettings.shootAttempts = voidAttackAttempts or 1
            local want = ragebotOrKillAura == true
            if want and not lastOn then
                RagebotSettings.on = true
                if startRagebot then startRagebot() end
                lastOn = true
            elseif not want and lastOn then
                if stopRagebot then stopRagebot() end
                RagebotSettings.on = false
                lastOn = false
            end
        end)
    end
end)

-- SECTION: Hit Logs Integration (multvallk)
-- ============================================================================
local HitLogGui = Instance.new("ScreenGui")
HitLogGui.Name = "multvallkHitLogUI"
HitLogGui.ResetOnSpawn = false
pcall(function() if gethui then HitLogGui.Parent = gethui() else HitLogGui.Parent = CoreGui end end)
if not HitLogGui.Parent then HitLogGui.Parent = PlayerGui end

local HitLogFrame = Instance.new("Frame", HitLogGui)
HitLogFrame.Size = UDim2.new(0, 280, 0, 150)
HitLogFrame.Position = UDim2.new(0, 10, 0.5, -75)
HitLogFrame.BackgroundTransparency = 1

local HitLogLayout = Instance.new("UIListLayout", HitLogFrame)
HitLogLayout.SortOrder = Enum.SortOrder.LayoutOrder
HitLogLayout.Padding = UDim.new(0, 4)
HitLogLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom


local function playHitSound()
    if not hitSoundEnabled then return end
    local id = HIT_SOUND_IDS[hitSoundName] or HIT_SOUND_IDS.neverlose
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = id
        s.Volume = math.clamp(hitSoundVolume or 0.7, 0, 5)
        s.Parent = workspace
        s:Play()
        game:GetService("Debris"):AddItem(s, 3)
    end)
end

local function addHitLog(targetName, damage)
    local logLabel = Instance.new("TextLabel")
    logLabel.Size = UDim2.new(1, 0, 0, 18)
    logLabel.BackgroundTransparency = 1
    logLabel.Text = string.format("(mult hit %s damage: %.1f)", targetName, damage)
    logLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
    logLabel.TextStrokeTransparency = 0.2
    logLabel.Font = Enum.Font.Code
    logLabel.TextSize = 11
    logLabel.TextXAlignment = Enum.TextXAlignment.Left
    logLabel.Parent = HitLogFrame

    task.delay(4, function()
        pcall(function()
            local tween = TweenService:Create(logLabel, TweenInfo.new(0.5), {TextTransparency = 1, TextStrokeTransparency = 1})
            tween:Play()
            tween.Completed:Connect(function() logLabel:Destroy() end)
        end)
    end)
end

local function setupPlayerDamageTracker(player)
    if player == LocalPlayer then return end
    local function trackCharacter(char)
        if not char then return end
        local hum = char:WaitForChild("Humanoid", 5)
        if not hum then return end
        local lastHealth = hum.Health
        local conn
        conn = hum.HealthChanged:Connect(function(newHealth)
            if newHealth < lastHealth then
                addHitLog(player.Name, lastHealth - newHealth)
                if hitSoundEnabled then playHitSound() end
            end
            lastHealth = newHealth
        end)
        hum.Died:Connect(function() if conn then conn:Disconnect() end end)
    end
    if player.Character then trackCharacter(player.Character) end
    player.CharacterAdded:Connect(trackCharacter)
end

for _, p in ipairs(Players:GetPlayers()) do setupPlayerDamageTracker(p) end
Players.PlayerAdded:Connect(setupPlayerDamageTracker)

-- ============================================================================
-- SECTION: Ragebot UI & Rainbow Crosshair Indicator (multvallk)
-- ============================================================================
local RageUIGui = Instance.new("ScreenGui", PlayerGui)
RageUIGui.Name = "multvallkRageUI"
RageUIGui.ResetOnSpawn = false

local CrosshairContainer = Instance.new("Frame", RageUIGui)
CrosshairContainer.AnchorPoint = Vector2.new(0.5, 0.5)
CrosshairContainer.Position = UDim2.new(0.5, 0, 0.5, -35)
CrosshairContainer.Size = UDim2.new(0, 40, 0, 40)
CrosshairContainer.BackgroundTransparency = 1
CrosshairContainer.Visible = false

local lines = {
    {Size = UDim2.new(0, 8, 0, 2), DefaultPos = UDim2.new(0, 0, 0.5, -1)},
    {Size = UDim2.new(0, 8, 0, 2), DefaultPos = UDim2.new(1, -8, 0.5, -1)},
    {Size = UDim2.new(0, 2, 0, 8), DefaultPos = UDim2.new(0.5, -1, 0, 0)},
    {Size = UDim2.new(0, 2, 0, 8), DefaultPos = UDim2.new(0.5, -1, 1, -8)}
}

local crosshairLines = {}
for _, info in ipairs(lines) do
    local line = Instance.new("Frame", CrosshairContainer)
    line.Size = info.Size
    line.Position = info.DefaultPos
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    line.BorderSizePixel = 0
    table.insert(crosshairLines, {Line = line, DefaultPos = info.DefaultPos})
end

local RageTextLabel = Instance.new("TextLabel", RageUIGui)
RageTextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
RageTextLabel.Position = UDim2.new(0.5, 0, 0.5, 25)
RageTextLabel.Size = UDim2.new(0, 280, 0, 20)
RageTextLabel.BackgroundTransparency = 1
RageTextLabel.Text = "(multvallk ragebot:in the void...^^)"
RageTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
RageTextLabel.TextStrokeTransparency = 0
RageTextLabel.Font = Enum.Font.GothamBold
RageTextLabel.TextSize = 12
RageTextLabel.TextXAlignment = Enum.TextXAlignment.Center
RageTextLabel.Visible = false

local rageHue = 0
local rotAngle = 0
RunService.RenderStepped:Connect(function()
    RageTextLabel.Visible = CrosshairContainer.Visible or ragebotOrKillAura
    if RageTextLabel.Visible then
        rageHue = (rageHue + 2) % 360
        local rainbowColor = Color3.fromHSV(rageHue / 360, 1, 1)
        for _, item in ipairs(crosshairLines) do item.Line.BackgroundColor3 = rainbowColor end
        RageTextLabel.TextColor3 = rainbowColor

        rotAngle = (rotAngle + 4) % 360
        CrosshairContainer.Rotation = rotAngle

        local timeVal = tick() * 5
        local pulse = (math.sin(timeVal) + 1) * 0.5
        
        crosshairLines[1].Line.Position = UDim2.new(0, math.floor(3 + pulse * 6), 0.5, -1)
        crosshairLines[2].Line.Position = UDim2.new(1, math.floor(-11 - pulse * 6), 0.5, -1)
        crosshairLines[3].Line.Position = UDim2.new(0.5, -1, 0, math.floor(3 + pulse * 6))
        crosshairLines[4].Line.Position = UDim2.new(0.5, -1, 1, math.floor(-11 - pulse * 6))

        if activeTargetPart and activeTargetPart.Parent then
            local tModel = activeTargetPart:FindFirstAncestorOfClass("Model") or activeTargetPart.Parent
            RageTextLabel.Text = "(multvallk ragebot kill " .. tModel.Name .. ")"
        else
            RageTextLabel.Text = "(multvallk ragebot:in the void...^^)"
        end
    end
end)

-- Fast Melee & Cooldown Override Loops
task.spawn(function()
    while true do
        task.wait(0.1)
        if fastMeleeEnabled or attackCooldownDisabled or projectileCooldownDisabled then
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" then
                        if attackCooldownDisabled or fastMeleeEnabled then
                            if rawget(v, "Cooldown") then rawset(v, "Cooldown", 0) end
                            if rawget(v, "AttackCooldown") then rawset(v, "AttackCooldown", 0) end
                            if rawget(v, "SwingCooldown") then rawset(v, "SwingCooldown", 0) end
                            if rawget(v, "HitCooldown") then rawset(v, "HitCooldown", 0) end
                            if rawget(v, "Delay") then rawset(v, "Delay", 0) end
                        end
                        if projectileCooldownDisabled then
                            if rawget(v, "ProjectileCooldown") then rawset(v, "ProjectileCooldown", 0) end
                            if rawget(v, "ThrowCooldown") then rawset(v, "ThrowCooldown", 0) end
                        end
                    end
                end
                
                if fastMeleeEnabled then
                    local char = LocalPlayer.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            for _, track in pairs(hum:GetPlayingAnimationTracks()) do
                                local animName = string.lower(track.Animation.AnimationId)
                                if animName:find("sword") or animName:find("melee") or animName:find("knife") or animName:find("slash") or animName:find("punch") or animName:find("attack") then
                                    track:AdjustSpeed(8.0)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Gun Hooking & Silent Aim Mechanics
pcall(function()
    if FighterController and FighterController.LocalFighter and FighterController.LocalFighter.GetMouseLocation then
        local LocalFighter = FighterController.LocalFighter
        local oldMouseLoc = LocalFighter.GetMouseLocation
        LocalFighter.GetMouseLocation = newcclosure(function(...)
            if silentAimTarget and (silentAimEnabled or ragebotOrKillAura) then
                local screenPos = Camera:WorldToScreenPoint(silentAimTarget.Position)
                return Vector2.new(screenPos.X, screenPos.Y)
            end
            return oldMouseLoc(...)
        end)
    end
end)

pcall(function()
    local CosmeticLibrary = require(ReplicatedStorage.Modules:WaitForChild("CosmeticLibrary", 5))
    local DataController = require(LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController", 5))

    local originalOwns = CosmeticLibrary.OwnsCosmetic
    CosmeticLibrary.OwnsCosmetic = function(self, inv, name, wpn)
        if skinChangerEnabled then return true end
        return originalOwns(self, inv, name, wpn)
    end
    CosmeticLibrary.OwnsCosmeticNormally = function(...) if skinChangerEnabled then return true end return false end
    CosmeticLibrary.OwnsCosmeticUniversally = function(...) if skinChangerEnabled then return true end return false end
    CosmeticLibrary.OwnsCosmeticForWeapon = function(...) if skinChangerEnabled then return true end return false end

    local originalGet = DataController.Get
    DataController.Get = function(self, key)
        local data = originalGet(self, key)
        if skinChangerEnabled and key == "CosmeticInventory" then
            local proxy = {}
            if data then for k, v in pairs(data) do proxy[k] = v end end
            return setmetatable(proxy, {__index = function() return true end})
        end
        return data
    end
end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        if not FighterController or not FighterController.LocalFighter then return end
        local item = FighterController.LocalFighter.EquippedItem
        if not item then return end

        if noSpreadEnabled then
            if rawget(item, "Spread") then rawset(item, "Spread", 0) end
            if rawget(item, "CurrentSpread") then rawset(item, "CurrentSpread", 0) end
            if item.Info and type(item.Info) == "table" then
                if rawget(item.Info, "Spread") then rawset(item.Info, "Spread", 0) end
            end
        end

        if rapidFireEnabled or hoNyangNoCDEnabled then
            if rawget(item, "ShootCooldown") then rawset(item, "ShootCooldown", 0) end
            if rawget(item, "FireRate") then rawset(item, "FireRate", 0) end
            if rawget(item, "Cooldown") then rawset(item, "Cooldown", 0) end
            if item.Info and type(item.Info) == "table" then
                if rawget(item.Info, "ShootCooldown") then rawset(item.Info, "ShootCooldown", 0) end
                if rawget(item.Info, "FireRate") then rawset(item.Info, "FireRate", 0) end
            end
        end

        if noRecoilEnabled then
            if rawget(item, "Recoil") then rawset(item, "Recoil", 0) end
            if rawget(item, "CameraRecoil") then rawset(item, "CameraRecoil", 0) end
            if item.Info and type(item.Info) == "table" then
                if rawget(item.Info, "Recoil") then rawset(item.Info, "Recoil", 0) end
            end
        end

        if noMuzzleFlashEnabled then
            if rawget(item, "MuzzleFlash") then rawset(item, "MuzzleFlash", false) end
        end

        if bulletSpeedBoost then
            if item.BulletSpeed then
                if not item._origBulletSpeed then item._origBulletSpeed = item.BulletSpeed end
                item.BulletSpeed = item._origBulletSpeed * bulletSpeedMult
            end
        else
            if item._origBulletSpeed then item.BulletSpeed = item._origBulletSpeed end
        end
    end)
end)

-- Render / Visuals & Skybox Presets
local SEGMENT_COUNT = 32
local circleSegments = {}

local circleFill = (Drawing and Drawing.new or function() return setmetatable({},{__index=function() return function() end end, __newindex=function() end}) end)("Circle")
circleFill.Thickness = 0
circleFill.NumSides = 64
circleFill.Filled = true
circleFill.Transparency = 1.0
circleFill.Visible = false

for i = 1, SEGMENT_COUNT do
    local line = (Drawing and Drawing.new or function() return setmetatable({},{__index=function() return function() end end, __newindex=function() end}) end)("Line")
    line.Thickness = 2.2
    line.Transparency = 1
    line.Visible = false
    table.insert(circleSegments, line)
end

local function getRainbowColor(hueOffset)
    local hue = (tick() * 0.5 + hueOffset) % 1
    return Color3.fromHSV(hue, 1, 1)
end

local skyPresets = {
    ["Dark Sky"] = { SkyboxUp = "rbxassetid://570555929", SkyboxRt = "rbxassetid://570555882", SkyboxDn = "rbxassetid://570555964", SkyboxFt = "rbxassetid://570555800", SkyboxLf = "rbxassetid://570555840", SkyboxBk = "rbxassetid://570555736" },
    ["Vaporwave"] = { SkyboxUp = "rbxassetid://1417494643", SkyboxRt = "rbxassetid://1417494499", SkyboxLf = "rbxassetid://1417494402", SkyboxFt = "rbxassetid://1417494253", SkyboxBk = "rbxassetid://1417494030", SkyboxDn = "rbxassetid://1417494146" },
    ["Lake Sky"] = { SkyboxRt = "rbxassetid://6823531746", SkyboxUp = "rbxassetid://6823528533", SunTextureId = "rbxassetid://5392574622", SkyboxDn = "rbxassetid://6823525702", SkyboxFt = "rbxassetid://6823482923", SkyboxLf = "rbxassetid://6823530023", SkyboxBk = "rbxassetid://6823523318" },
    ["Black Mesa"] = { SkyboxUp = "rbxassetid://9569598752", SkyboxRt = "rbxassetid://9569601267", SkyboxDn = "rbxassetid://9569613307", SkyboxFt = "rbxassetid://9569611418", SkyboxLf = "rbxassetid://9569608166", SkyboxBk = "rbxassetid://9569742122" }
}

local function applySkybox()
    local customSky = Lighting:FindFirstChild("multvallkCustomSky")
    if not customSkyboxEnabled then
        if customSky then customSky:Destroy() end
        return
    end
    local skyData = skyPresets[skyboxTheme] or skyPresets["Vaporwave"]
    if not customSky then
        customSky = Instance.new("Sky")
        customSky.Name = "multvallkCustomSky"
        customSky.Parent = Lighting
    end
    for prop, val in pairs(skyData) do pcall(function() customSky[prop] = val end) end
end

local function setSkyboxTheme(selectedTheme)
    skyboxTheme = selectedTheme
    customSkyboxEnabled = true
    applySkybox()
end

RunService.RenderStepped:Connect(function()
    local myChar = LocalPlayer.Character
    local mousePos = UserInputService:GetMouseLocation()

    if false and circleCrosshairEnabled then -- Drawing crosshair disabled (freeze)
        local centerPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local radius = math.clamp(circleCrosshairSize, 1, 600)
        local currentRot = (tick() * circleRotationSpeed) % (math.pi * 2)

        circleFill.Position = centerPos
        circleFill.Radius = radius
        circleFill.Color = getRainbowColor(0)
        circleFill.Visible = true

        for i = 1, SEGMENT_COUNT do
            local line = circleSegments[i]
            local angle1 = currentRot + ((i - 1) / SEGMENT_COUNT) * (math.pi * 2)
            local angle2 = currentRot + (i / SEGMENT_COUNT) * (math.pi * 2)

            line.From = centerPos + Vector2.new(math.cos(angle1) * radius, math.sin(angle1) * radius)
            line.To = centerPos + Vector2.new(math.cos(angle2) * radius, math.sin(angle2) * radius)
            line.Color = getRainbowColor((i - 1) / SEGMENT_COUNT)
            line.Visible = true
        end
    else
        circleFill.Visible = false
        for _, line in ipairs(circleSegments) do line.Visible = false end
    end

    if aimbotEnabled and myChar then
        local closestTarget = nil
        local closestDist = math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not is_teammate(player) and not get_character_immune(player) and not is_reflecting_or_parrying(player) then
                local hitPart = player.Character and player.Character:FindFirstChild(aimbotHitPart)
                if hitPart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hitPart.Position)
                    if onScreen then
                        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if screenDist <= aimbotFovRadius and screenDist < closestDist then
                            if (not aimbotWallCheck) or has_line_of_sight(hitPart, myChar) then
                                closestDist = screenDist
                                closestTarget = hitPart
                            end
                        end
                    end
                end
            end
        end
        if closestTarget then
            local targetPos = Camera:WorldToScreenPoint(closestTarget.Position)
            local currentPos = UserInputService:GetMouseLocation()
            local moveVector = (Vector2.new(targetPos.X, targetPos.Y) - currentPos) / math.max(1, aimbotSmoothness)
            mousemoverel(moveVector.X, moveVector.Y)
        end
    end

    silentAimTarget = nil
    if (silentAimEnabled or ragebotOrKillAura) and myChar then
        local closestDist = math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not is_teammate(player) and not get_character_immune(player) and not is_reflecting_or_parrying(player) then
                local hitPart = get_character_root(player.Character)
                if hitPart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hitPart.Position)
                    if onScreen then
                        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        local maxFov = ragebotOrKillAura and 99999 or silentAimFovRadius
                        
                        if screenDist <= maxFov and screenDist < closestDist then
                            if (not silentWallCheck) or has_line_of_sight(hitPart, myChar) then
                                closestDist = screenDist
                                silentAimTarget = hitPart
                            end
                        end
                    end
                end
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local hrp = myChar:FindFirstChild("HumanoidRootPart")
    local hum = myChar:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    if noclipEnabled then
        for _, part in pairs(myChar:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    if rapidSpeedEnabled and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (rapidSpeedMultiplier * 0.4))
    end

    if (pcFlyEnabled or mobileFlyEnabled) then
        hum.PlatformStand = true
        local flyVel = Vector3.zero
        if pcFlyEnabled then
            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            if moveDir.Magnitude > 0 then flyVel = moveDir.Unit * 50 end
        elseif mobileFlyEnabled and hum.MoveDirection.Magnitude > 0 then
            flyVel = Camera.CFrame.LookVector * 50
        end
        hrp.AssemblyLinearVelocity = flyVel
        hrp.AssemblyAngularVelocity = Vector3.zero
    else
        if hum.PlatformStand then hum.PlatformStand = false end
    end
end)

-- ============================================================================
-- SECTION: User Interface Framework (Optimized Size & Left Margin Applied)
-- ============================================================================
local valkLib = { accentclr = Color3.fromRGB(128, 213, 247) }

local function make_draggable(clickObject, dragObject)
    pcall(function()
        local dragging = false
        local dragInput, dragStart, startPos
        clickObject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
                dragging = true
                dragStart = input.Position
                startPos = dragObject.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end 
                end)
            end 
        end)
        clickObject.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end 
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then 
                local delta = input.Position - dragStart
                dragObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end 
        end)
    end)
end

local MainGui = Instance.new("ScreenGui")
MainGui.Name = "multvallkHalmuUI"
MainGui.ResetOnSpawn = false
pcall(function() if gethui then MainGui.Parent = gethui() else MainGui.Parent = CoreGui end end)
if not MainGui.Parent then MainGui.Parent = PlayerGui end

-- HALMU VALK Main Frame Construction (紐⑤컮�� 媛��낆꽦�� �꾪빐 �ш린瑜� �댁쭩 以꾩씠怨� 醫뚯륫 �щ갚/鍮꾩쑉 理쒖쟻��)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = MainGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 480, 0, 560) -- �ш린 理쒖쟻�� 異뺤냼
MainFrame.Visible = false -- key �듦낵 �� �쒖떆
MainFrame.ClipsDescendants = true

local Outline1 = Instance.new("ImageLabel", MainFrame)
Outline1.BackgroundTransparency = 1
Outline1.Position = UDim2.new(0, 1, 0, 1)
Outline1.Size = UDim2.new(1, -2, 1, -2)
Outline1.Image = "rbxassetid://2592362371"
Outline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
Outline1.ScaleType = Enum.ScaleType.Slice
Outline1.SliceCenter = Rect.new(2, 2, 62, 62)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Name = "TopBar"
TopBar.AnchorPoint = Vector2.new(0.5, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
TopBar.BorderSizePixel = 0
TopBar.Position = UDim2.new(0.5, 0, 0, 2)
TopBar.Size = UDim2.new(1, -5, 0, 28)

local TopBarTitle = Instance.new("TextLabel", TopBar)
TopBarTitle.BackgroundTransparency = 1
TopBarTitle.Position = UDim2.new(0, 7, 0, 5)
TopBarTitle.Size = UDim2.new(0, 0, 0, 16)
TopBarTitle.Font = Enum.Font.Code
TopBarTitle.Text = "multvallk Premium v3 (Optimized UI)"
TopBarTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
TopBarTitle.TextSize = 15
TopBarTitle.TextXAlignment = Enum.TextXAlignment.Left

local TopBarLine = Instance.new("Frame", TopBar)
TopBarLine.BackgroundColor3 = valkLib.accentclr
TopBarLine.BorderSizePixel = 0
TopBarLine.Position = UDim2.new(0, 0, 0, 27)
TopBarLine.Size = UDim2.new(1, 0, 0, 1)

make_draggable(TopBar, MainFrame)

local ContainerHolder = Instance.new("Frame", MainFrame)
ContainerHolder.Name = "ContainerHolderFrame"
ContainerHolder.AnchorPoint = Vector2.new(0.5, 0)
ContainerHolder.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
ContainerHolder.Position = UDim2.new(0.5, 0, 0, 35)
ContainerHolder.Size = UDim2.new(1, -12, 1, -42) -- �쇱そ �щ갚�� 以꾩뿬 紐⑤컮�� �섎┝ 諛⑹�
ContainerHolder.BackgroundTransparency = 1

local TabHolder = Instance.new("ScrollingFrame", ContainerHolder)
TabHolder.Name = "TabHolderFrame"
TabHolder.BackgroundTransparency = 1
TabHolder.Size = UDim2.new(1, 0, 0, 32)
TabHolder.CanvasSize = UDim2.new(0, 700, 0, 0)
TabHolder.ScrollBarThickness = 0

local TabListLayout = Instance.new("UIListLayout", TabHolder)
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 4)

local TabPadding = Instance.new("UIPadding", TabHolder)
TabPadding.PaddingLeft = UDim.new(0, 3) -- �쇱そ �⑤뵫 理쒖냼��

-- Tab Creation System
local tabEntries = {}
local isFirstTab = true

local function AddValkTab(tabName)
    local btn = Instance.new("TextButton", TabHolder)
    btn.Name = tabName .. "_TabBtn"
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.Code
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.TextSize = 13
    btn.AutoButtonColor = false
    
    local txtSize
    pcall(function()
        txtSize = TextService:GetTextSize(tabName, 13, Enum.Font.Code, Vector2.new(500, 500))
    end)
    btn.Size = UDim2.new(0, (txtSize and txtSize.X or (#tabName * 7)) + 22, 0, 26)
    
    local topLine = Instance.new("Frame", btn)
    topLine.BackgroundColor3 = valkLib.accentclr
    topLine.BorderSizePixel = 0
    topLine.Position = UDim2.new(0, 0, 0, 0)
    topLine.Size = UDim2.new(1, 0, 0, 2)
    topLine.Visible = false
    
    local outline = Instance.new("ImageLabel", btn)
    outline.BackgroundTransparency = 1
    outline.Size = UDim2.new(1, 0, 1, 0)
    outline.Image = "rbxassetid://2592362371"
    outline.ImageColor3 = Color3.fromRGB(45, 45, 45)
    outline.ScaleType = Enum.ScaleType.Slice
    outline.SliceCenter = Rect.new(2, 2, 62, 62)

    local holder1 = Instance.new("ScrollingFrame", ContainerHolder)
    holder1.Name = tabName .. "_Holder1"
    holder1.BackgroundTransparency = 1
    holder1.Position = UDim2.new(0, 1, 0, 35)
    holder1.Size = UDim2.new(0.49, -2, 1, -40)
    holder1.Visible = false
    holder1.ScrollBarThickness = 3

    local h1Padding = Instance.new("UIPadding", holder1)
    h1Padding.PaddingTop = UDim.new(0, 5)
    local h1Layout = Instance.new("UIListLayout", holder1)
    h1Layout.SortOrder = Enum.SortOrder.LayoutOrder
    h1Layout.Padding = UDim.new(0, 8)
    h1Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        holder1.CanvasSize = UDim2.new(0, 0, 0, h1Layout.AbsoluteContentSize.Y + 20)
    end)

    local holder2 = Instance.new("ScrollingFrame", ContainerHolder)
    holder2.Name = tabName .. "_Holder2"
    holder2.BackgroundTransparency = 1
    holder2.Position = UDim2.new(0.51, 1, 0, 35)
    holder2.Size = UDim2.new(0.49, -2, 1, -40)
    holder2.Visible = false
    holder2.ScrollBarThickness = 3

    local h2Padding = Instance.new("UIPadding", holder2)
    h2Padding.PaddingTop = UDim.new(0, 5)
    local h2Layout = Instance.new("UIListLayout", holder2)
    h2Layout.SortOrder = Enum.SortOrder.LayoutOrder
    h2Layout.Padding = UDim.new(0, 8)
    h2Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        holder2.CanvasSize = UDim2.new(0, 0, 0, h2Layout.AbsoluteContentSize.Y + 20)
    end)

    local entry = {btn = btn, topLine = topLine, outline = outline, h1 = holder1, h2 = holder2}
    table.insert(tabEntries, entry)

    if isFirstTab then
        isFirstTab = false
        holder1.Visible = true
        holder2.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
        btn.TextColor3 = Color3.fromRGB(230, 230, 230)
        topLine.Visible = true
        outline.ImageColor3 = Color3.fromRGB(65, 65, 65)
    end

    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(tabEntries) do
            if t.btn == btn then
                t.btn.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
                t.btn.TextColor3 = Color3.fromRGB(230, 230, 230)
                t.topLine.Visible = true
                t.outline.ImageColor3 = Color3.fromRGB(65, 65, 65)
                t.h1.Visible = true
                t.h2.Visible = true
            else
                t.btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
                t.btn.TextColor3 = Color3.fromRGB(150, 150, 150)
                t.topLine.Visible = false
                t.outline.ImageColor3 = Color3.fromRGB(45, 45, 45)
                t.h1.Visible = false
                t.h2.Visible = false
            end
        end
    end)

    local tabObj = {}
    function tabObj:Section(sectionName, side)
        local parentHolder = (side == 2) and holder2 or holder1

        local secFrame = Instance.new("Frame", parentHolder)
        secFrame.Name = "Section"
        secFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        secFrame.BorderSizePixel = 0
        secFrame.Size = UDim2.new(1, -2, 0, 24)

        local secOutline = Instance.new("ImageLabel", secFrame)
        secOutline.BackgroundTransparency = 1
        secOutline.Size = UDim2.new(1, 0, 1, 0)
        secOutline.Image = "rbxassetid://2592362371"
        secOutline.ImageColor3 = Color3.fromRGB(60, 60, 60)
        secOutline.ScaleType = Enum.ScaleType.Slice
        secOutline.SliceCenter = Rect.new(2, 2, 62, 62)

        local secTitleFrame = Instance.new("Frame", secFrame)
        secTitleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        secTitleFrame.BorderSizePixel = 0
        secTitleFrame.Position = UDim2.new(0, 8, 0, 0)

        local secTitle = Instance.new("TextLabel", secTitleFrame)
        secTitle.BackgroundTransparency = 1
        secTitle.Position = UDim2.new(0, 0, 0, -3)
        secTitle.Size = UDim2.new(1, 0, 0, 7)
        secTitle.Font = Enum.Font.Code
        secTitle.Text = sectionName
        secTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
        secTitle.TextSize = 13
        secTitleFrame.Size = UDim2.new(0, secTitle.TextBounds.X + 6, 0, 7)

        local itemHolder = Instance.new("Frame", secFrame)
        itemHolder.AnchorPoint = Vector2.new(0.5, 0)
        itemHolder.BackgroundTransparency = 1
        itemHolder.Position = UDim2.new(0.5, 0, 0, 14)
        itemHolder.Size = UDim2.new(1, -12, 0, 0)

        local itemLayout = Instance.new("UIListLayout", itemHolder)
        itemLayout.SortOrder = Enum.SortOrder.LayoutOrder
        itemLayout.Padding = UDim.new(0, 4)

        local function updateSize()
            secFrame.Size = UDim2.new(1, -2, 0, itemLayout.AbsoluteContentSize.Y + 22)
            holder1.CanvasSize = UDim2.new(0, 0, 0, holder1:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y + 20)
            holder2.CanvasSize = UDim2.new(0, 0, 0, holder2:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y + 20)
        end

        itemLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)

        local secObj = {}
        function secObj:Toggle(text, getv, setv)
            local toggleBtn = Instance.new("TextButton", itemHolder)
            toggleBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            toggleBtn.BorderSizePixel = 0
            toggleBtn.Size = UDim2.new(1, 0, 0, 21)
            toggleBtn.Text = ""

            local btnOutline = Instance.new("ImageLabel", toggleBtn)
            btnOutline.BackgroundTransparency = 1
            btnOutline.Size = UDim2.new(1, 0, 1, 0)
            btnOutline.Image = "rbxassetid://2592362371"
            btnOutline.ImageColor3 = Color3.fromRGB(60, 60, 60)
            btnOutline.ScaleType = Enum.ScaleType.Slice
            btnOutline.SliceCenter = Rect.new(2, 2, 62, 62)

            local indicator = Instance.new("Frame", toggleBtn)
            indicator.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            indicator.Position = UDim2.new(1, -16, 0, 3)
            indicator.Size = UDim2.new(0, 14, 0, 14)
            indicator.BorderSizePixel = 0

            local indColor = Instance.new("Frame", indicator)
            indColor.Size = UDim2.new(1, -4, 1, -4)
            indColor.Position = UDim2.new(0, 2, 0, 2)
            indColor.BorderSizePixel = 0
            indColor.BackgroundColor3 = getv() and valkLib.accentclr or Color3.fromRGB(40, 40, 40)

            local label = Instance.new("TextLabel", toggleBtn)
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 5, 0, 0)
            label.Size = UDim2.new(1, -22, 1, 0)
            label.Font = Enum.Font.Code
            label.Text = text
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.TextSize = 11
            label.TextXAlignment = Enum.TextXAlignment.Left

            local function refreshToggleUI()
                indColor.BackgroundColor3 = getv() and valkLib.accentclr or Color3.fromRGB(40, 40, 40)
            end

            toggleBtn.MouseButton1Click:Connect(function()
                setv(not getv())
                refreshToggleUI()
            end)
            -- no per-frame UI refresh (was causing freeze)
            updateSize()
        end

        function secObj:Slider(text, min, max, getv, setv)
            local sliderFrame = Instance.new("Frame", itemHolder)
            sliderFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Size = UDim2.new(1, 0, 0, 30)

            local sOutline = Instance.new("ImageLabel", sliderFrame)
            sOutline.BackgroundTransparency = 1
            sOutline.Size = UDim2.new(1, 0, 1, 0)
            sOutline.Image = "rbxassetid://2592362371"
            sOutline.ImageColor3 = Color3.fromRGB(60, 60, 60)
            sOutline.ScaleType = Enum.ScaleType.Slice
            sOutline.SliceCenter = Rect.new(2, 2, 62, 62)

            local lbl = Instance.new("TextLabel", sliderFrame)
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 5, 0, 2)
            lbl.Size = UDim2.new(1, -10, 0, 12)
            lbl.Font = Enum.Font.Code
            lbl.Text = text .. ": " .. string.format(max > 1000 and "%.0f" or "%.2f", getv())
            lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
            lbl.TextSize = 10
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local barBg = Instance.new("TextButton", sliderFrame)
            barBg.Position = UDim2.new(0, 5, 0, 16)
            barBg.Size = UDim2.new(1, -10, 0, 8)
            barBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            barBg.BorderSizePixel = 0
            barBg.Text = ""

            local barFill = Instance.new("Frame", barBg)
            barFill.BackgroundColor3 = valkLib.accentclr
            barFill.BorderSizePixel = 0
            barFill.Size = UDim2.new(math.clamp((getv() - min) / (max - min), 0, 1), 0, 1, 0)

            local dragging = false
            barBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local pos = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
                    local val = min + (max - min) * pos
                    setv(val)
                    barFill.Size = UDim2.new(pos, 0, 1, 0)
                    lbl.Text = text .. ": " .. string.format(max > 1000 and "%.0f" or "%.2f", val)
                end
            end)
            updateSize()
        end

        return secObj
    end

    return tabObj
end

-- Key System Frame
local KeyFrame = Instance.new("Frame", MainGui)
KeyFrame.Size = UDim2.fromOffset(260, 130)
KeyFrame.Position = UDim2.new(0.5, -130, 0.5, -65)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyFrame.BorderSizePixel = 0
KeyFrame.Visible = not keyPassed

local KeyOutline = Instance.new("ImageLabel", KeyFrame)
KeyOutline.BackgroundTransparency = 1
KeyOutline.Size = UDim2.new(1, 0, 1, 0)
KeyOutline.Image = "rbxassetid://2592362371"
KeyOutline.ImageColor3 = Color3.fromRGB(60, 60, 60)
KeyOutline.ScaleType = Enum.ScaleType.Slice
KeyOutline.SliceCenter = Rect.new(2, 2, 62, 62)

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, 0, 0, 28)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "multvallk Key System"
KeyTitle.TextColor3 = valkLib.accentclr
KeyTitle.Font = Enum.Font.Code
KeyTitle.TextSize = 12

local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.Size = UDim2.new(0.85, 0, 0, 28)
KeyBox.Position = UDim2.new(0.075, 0, 0.3, 0)
KeyBox.PlaceholderText = "Enter Key..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.Font = Enum.Font.Code
KeyBox.TextSize = 11

local SubmitBtn = Instance.new("TextButton", KeyFrame)
SubmitBtn.Size = UDim2.new(0.85, 0, 0, 28)
SubmitBtn.Position = UDim2.new(0.075, 0, 0.62, 0)
SubmitBtn.BackgroundColor3 = valkLib.accentclr
SubmitBtn.Text = "Submit Key"
SubmitBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
SubmitBtn.Font = Enum.Font.Code
SubmitBtn.TextSize = 11

make_draggable(KeyTitle, KeyFrame)

-- Toggle Menu Button
local ToggleBtn = Instance.new("TextButton", MainGui)
ToggleBtn.Size = UDim2.fromOffset(100, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.TextColor3 = valkLib.accentclr
ToggleBtn.Font = Enum.Font.Code
ToggleBtn.TextSize = 11
ToggleBtn.Text = "multvallk UI"
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Visible = true

local TogOutline = Instance.new("ImageLabel", ToggleBtn)
TogOutline.BackgroundTransparency = 1
TogOutline.Size = UDim2.new(1, 0, 1, 0)
TogOutline.Image = "rbxassetid://2592362371"
TogOutline.ImageColor3 = valkLib.accentclr
TogOutline.ScaleType = Enum.ScaleType.Slice
TogOutline.SliceCenter = Rect.new(2, 2, 62, 62)

local function trySubmitKey()
    local typed = tostring(KeyBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if typed == validKey or typed == "Paid_masterkey-vallkmult" then
        keyPassed = true
        KeyFrame.Visible = false
        MainFrame.Visible = true
        ToggleBtn.Visible = true
        pcall(function()
            if tabEntries and tabEntries[1] and tabEntries[1].btn then
                -- ensure first tab content visible
            end
        end)
        print("[multvallk] Key OK �� UI open (RightShift toggle)")
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Invalid Key!"
    end
end
SubmitBtn.MouseButton1Click:Connect(trySubmitKey)
KeyBox.FocusLost:Connect(function(enter)
    if enter then trySubmitKey() end
end)
UserInputService.InputBegan:Connect(function(input, g)
    if g then return end
    if KeyFrame.Visible and input.KeyCode == Enum.KeyCode.Return then
        trySubmitKey()
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    if keyPassed then MainFrame.Visible = not MainFrame.Visible end
end)

UserInputService.InputBegan:Connect(function(input, g)
    if g then return end
    if input.KeyCode == Enum.KeyCode.RightShift and keyPassed then 
        MainFrame.Visible = not MainFrame.Visible 
    end
end)

-- Mobile Scaling Adjuster
local function updateMobileSize()
    if mobileOnEnabled then
        MainFrame.Size = UDim2.fromOffset(560, 320)
    else
        MainFrame.Size = UDim2.fromOffset(480, 560)
    end
    for _, t in ipairs(tabEntries) do
        if t.h1 and t.h1:FindFirstChildOfClass("UIListLayout") then
            t.h1.CanvasSize = UDim2.new(0, 0, 0, t.h1:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y + 20)
        end
        if t.h2 and t.h2:FindFirstChildOfClass("UIListLayout") then
            t.h2.CanvasSize = UDim2.new(0, 0, 0, t.h2:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y + 20)
        end
    end
end

-- Tab Setup & Feature Assignments
local MainTab = AddValkTab("Main")
local RageTab = AddValkTab("Ragebot")
local FFTab = AddValkTab("FFMode")
local EspTab = AddValkTab("ESP")
local MiscTab = AddValkTab("Misc")
local UiTab = AddValkTab("UI Set")
-- Force show first tab content
task.defer(function()
    if tabEntries[1] then
        for i, t in ipairs(tabEntries) do
            local on = (i == 1)
            t.h1.Visible = on
            t.h2.Visible = on
            if on then
                t.btn.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
                t.btn.TextColor3 = Color3.fromRGB(230, 230, 230)
                t.topLine.Visible = true
            end
        end
    end
end)


-- Main Tab Options
local mSec1 = MainTab:Section("Aimbot Settings", 1)
mSec1:Toggle("Mobile Mode UI", function() return mobileOnEnabled end, function(v) mobileOnEnabled = v; updateMobileSize() end)
mSec1:Toggle("Aimbot (Smooth Camera)", function() return aimbotEnabled end, function(v) aimbotEnabled = v end)
mSec1:Toggle("Wallbang", function() return wallbangEnabled end, function(v)
    wallbangEnabled = v
    if not v then
        pcall(function()
            local e = getgenv()
            if e.DesyncController then e.DesyncController:Stop() end
        end)
    end
end)
mSec1:Slider("Aimbot Smoothness", 1, 20, function() return aimbotSmoothness end, function(v) aimbotSmoothness = v end)
mSec1:Slider("Aimbot FOV", 10, 500, function() return aimbotFovRadius end, function(v) aimbotFovRadius = v end)
mSec1:Toggle("Aimbot Wall Check", function() return aimbotWallCheck end, function(v) aimbotWallCheck = v end)

local mSec2 = MainTab:Section("Gun & Silent Aim", 2)
mSec2:Toggle("Silent Aim", function() return silentAimEnabled end, function(v) silentAimEnabled = v end)
mSec2:Slider("Silent FOV", 10, 1000, function() return silentAimFovRadius end, function(v) silentAimFovRadius = v end)
mSec2:Toggle("Silent Wall Check", function() return silentWallCheck end, function(v) silentWallCheck = v end)
mSec2:Toggle("Fast Melee", function() return fastMeleeEnabled end, function(v) fastMeleeEnabled = v end)
mSec2:Toggle("No Cooldown", function() return hoNyangNoCDEnabled end, function(v) hoNyangNoCDEnabled = v end)
mSec2:Toggle("No Recoil", function() return noRecoilEnabled end, function(v) noRecoilEnabled = v end)
mSec2:Toggle("No Spread", function() return noSpreadEnabled end, function(v) noSpreadEnabled = v end)
mSec2:Toggle("No Muzzle Flash", function() return noMuzzleFlashEnabled end, function(v) noMuzzleFlashEnabled = v end)
mSec2:Toggle("Rapid Fire", function() return rapidFireEnabled end, function(v) rapidFireEnabled = v end)

-- Ragebot Tab Options (Single Ragebot Integrated)
local rSec1 = RageTab:Section("Rage Engine", 1)
rSec1:Toggle("muilt premium ragebot", function() return ragebotOrKillAura end, function(v) ragebotOrKillAura = v end)

local rSec2 = RageTab:Section("Ragebot / Void Spam", 2)
rSec2:Toggle("Void Spam", function() return voidSpamEnabled end, function(v) voidSpamEnabled = v end)
rSec2:Slider("Hide", 0, 1, function() return voidHideTime end, function(v) voidHideTime = v end)
rSec2:Slider("Attack", 0, 1, function() return voidShootTime end, function(v) voidShootTime = v end)
rSec2:Toggle("Ragebot Indicator", function() return ragebotIndicatorEnabled end, function(v) ragebotIndicatorEnabled = v end)
rSec2:Toggle("Ammo Indicator", function() return ammoIndicatorEnabled end, function(v) ammoIndicatorEnabled = v end)

-- Shoot Attempts / Height: internal only (hidden from menu)
-- voidAttackAttempts, ragebotHeightOffset keep defaults

-- FFMode Tab Options
local ffSec = FFTab:Section("FF Mode Mechanics", 1)
ffSec:Toggle("Enable FFMode", function() return ffModeEnabled end, function(v) ffModeEnabled = v end)
ffSec:Toggle("Team Check", function() return ffTeamCheckEnabled end, function(v) ffTeamCheckEnabled = v end)
ffSec:Toggle("Baiting (Fall Inducer)", function() return ffBaitingEnabled end, function(v) ffBaitingEnabled = v end)

-- ESP Tab Options
local espSec = EspTab:Section("Visual ESP", 1)
espSec:Toggle("Master ESP Toggle", function() return espEnabled end, function(v) espEnabled = v end)
espSec:Toggle("ESP Boxes", function() return espBoxEnabled end, function(v) espBoxEnabled = v end)
espSec:Toggle("ESP Names", function() return espNameEnabled end, function(v) espNameEnabled = v end)
espSec:Toggle("ESP Health", function() return espHealthEnabled end, function(v) espHealthEnabled = v end)
espSec:Toggle("Gun Tracer Line", function() return gunTracerEnabled end, function(v) gunTracerEnabled = v end)
local skinSec = EspTab:Section("Cosmetics / All Skins", 2)
skinSec:Toggle("Unlock All Skins", function() return skinChangerEnabled end, function(v) skinChangerEnabled = v end)


-- Misc Tab Options
local miscSec = MiscTab:Section("Movement & Mods", 1)
miscSec:Toggle("Mobile Fly (Touch)", function() return mobileFlyEnabled end, function(v) mobileFlyEnabled = v end)
miscSec:Toggle("PC Fly (WASD)", function() return pcFlyEnabled end, function(v) pcFlyEnabled = v end)

local miscSecLion = MiscTab:Section("Lion Misc", 2)
miscSecLion:Toggle("Auto Respawn", function() return autoRespawnEnabled end, function(v) autoRespawnEnabled = v end)
miscSecLion:Toggle("Collect Drops", function() return collectDropsEnabled end, function(v) collectDropsEnabled = v end)
miscSecLion:Toggle("Hit Notifier", function() return hitNotifyEnabled end, function(v) hitNotifyEnabled = v end)
miscSecLion:Toggle("Hit Sound", function() return hitSoundEnabled end, function(v) hitSoundEnabled = v end)
miscSecLion:Slider("Hit Sound Volume", 0, 5, function() return hitSoundVolume end, function(v) hitSoundVolume = v end)
-- Hit sound picker (�몃꽩 �ㅽ��� �좏깮)
for _, snd in ipairs(HIT_SOUND_LIST) do
    local name = snd
    miscSecLion:Toggle("Sound: " .. name, function() return hitSoundName == name end, function(v)
        if v then hitSoundName = name end
    end)
end

miscSec:Toggle("Bullet Speed Boost", function() return bulletSpeedBoost end, function(v) bulletSpeedBoost = v end)
miscSec:Toggle("Rapid Speed Hack", function() return rapidSpeedEnabled end, function(v) rapidSpeedEnabled = v end)
miscSec:Toggle("Noclip", function() return noclipEnabled end, function(v) noclipEnabled = v end)

miscSec:Toggle("Hit Sound", function() return hitSoundEnabled end, function(v) hitSoundEnabled = v; hitNotifyEnabled = true end)
miscSec:Slider("Hit Sound Volume", 0, 5, function() return hitSoundVolume end, function(v) hitSoundVolume = v end)
miscSec:Toggle("Sound: neverlose", function() return hitSoundName=="neverlose" end, function(v) if v then hitSoundName="neverlose" end end)
miscSec:Toggle("Sound: gamesense", function() return hitSoundName=="gamesense" end, function(v) if v then hitSoundName="gamesense" end end)
miscSec:Toggle("Sound: skeet", function() return hitSoundName=="skeet" end, function(v) if v then hitSoundName="skeet" end end)
miscSec:Toggle("Sound: rust", function() return hitSoundName=="rust" end, function(v) if v then hitSoundName="rust" end end)
miscSec:Toggle("Sound: �μ땐�� �뺤”諛� 蹂댁뙂", function() return hitSoundName=="�μ땐�� �뺤”諛� 蹂댁뙂" end, function(v) if v then hitSoundName="�μ땐�� �뺤”諛� 蹂댁뙂" end end)
miscSec:Toggle("Hit Notify Text", function() return hitNotifyEnabled end, function(v) hitNotifyEnabled = v end)

-- UI Set Tab Options
local uiSec = UiTab:Section("Skybox & Crosshair", 1)
uiSec:Toggle("Circle Crosshair", function() return circleCrosshairEnabled end, function(v) circleCrosshairEnabled = v end)
uiSec:Toggle("Sky: Dark Sky", function() return customSkyboxEnabled and skyboxTheme == "Dark Sky" end, function(v) if v then setSkyboxTheme("Dark Sky") else customSkyboxEnabled = false; applySkybox() end end)
uiSec:Toggle("Sky: Vaporwave", function() return customSkyboxEnabled and skyboxTheme == "Vaporwave" end, function(v) if v then setSkyboxTheme("Vaporwave") else customSkyboxEnabled = false; applySkybox() end end)
uiSec:Toggle("Sky: Lake Sky", function() return customSkyboxEnabled and skyboxTheme == "Lake Sky" end, function(v) if v then setSkyboxTheme("Lake Sky") else customSkyboxEnabled = false; applySkybox() end end)
uiSec:Toggle("Sky: Black Mesa", function() return customSkyboxEnabled and skyboxTheme == "Black Mesa" end, function(v) if v then setSkyboxTheme("Black Mesa") else customSkyboxEnabled = false; applySkybox() end end)

MainFrame.Visible = keyPassed -- false until key


-- Yokai.win Crosshair
task.spawn(function()
    getgenv()._vallkYokaiCrosshair = getgenv()._vallkYokaiCrosshair ~= false
    if _G.YokaiCrosshair then pcall(function() _G.YokaiCrosshair:Destroy() end) end
    if _G.YokaiCrosshairConnection then pcall(function() _G.YokaiCrosshairConnection:Disconnect() end) end
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Yokai.winCrosshair"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 99999
    screenGui.IgnoreGuiInset = true
    pcall(function()
        if gethui then screenGui.Parent = gethui() else screenGui.Parent = CoreGui end
    end)
    if not screenGui.Parent then screenGui.Parent = PlayerGui end
    _G.YokaiCrosshair = screenGui
    local container = Instance.new("Frame")
    container.BackgroundTransparency = 1
    container.Size = UDim2.fromOffset(28, 28)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Parent = screenGui
    local lines = {Top=Instance.new("Frame"),Bottom=Instance.new("Frame"),Left=Instance.new("Frame"),Right=Instance.new("Frame")}
    for _, line in pairs(lines) do
        line.BackgroundColor3 = Color3.new(1,1,1)
        line.BorderSizePixel = 0
        line.ZIndex = 10
        line.Parent = container
        local st = Instance.new("UIStroke"); st.Color = Color3.new(0,0,0); st.Thickness = 1; st.Parent = line
    end
    lines.Top.Size = UDim2.fromOffset(3, -12)
    lines.Top.Position = UDim2.new(0.5, -1.5, 0, 0)
    lines.Bottom.Size = UDim2.fromOffset(3, -12)
    lines.Bottom.Position = UDim2.new(0.5, -1.5, 1, 12)
    lines.Left.Size = UDim2.fromOffset(-12, 3)
    lines.Left.Position = UDim2.new(0, 0, 0.5, -1.5)
    lines.Right.Size = UDim2.fromOffset(-12, 3)
    lines.Right.Position = UDim2.new(1, 12, 0.5, -1.5)
    local textLabel = Instance.new("TextLabel")
    textLabel.Text = "lll.win"
    textLabel.Font = Enum.Font.Arcade
    textLabel.TextSize = 16
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.fromOffset(100, 20)
    textLabel.ZIndex = 20
    textLabel.TextColor3 = Color3.new(1,1,1)
    textLabel.Parent = screenGui
    local ts = Instance.new("UIStroke"); ts.Color = Color3.new(0,0,0); ts.Thickness = 1; ts.Parent = textLabel
    local t = 0
    _G.YokaiCrosshairConnection = RunService.RenderStepped:Connect(function(dt)
        if hideCrosshairEnabled or getgenv()._vallkYokaiCrosshair == false then
            screenGui.Enabled = false
            return
        end
        screenGui.Enabled = true
        t = t + dt
        local mousePos = UserInputService:GetMouseLocation()
        container.Position = UDim2.fromOffset(mousePos.X, mousePos.Y)
        textLabel.Position = UDim2.fromOffset(mousePos.X - 50, mousePos.Y + 36)
        local speed = 175 + 90 * (0.5 + 0.5 * math.sin(t * 2.2))
        container.Rotation = (container.Rotation + dt * speed) % 360
        local pulse = math.sin(t * 4.0) * 0.5 + 0.5
        local len = -12 - 14 * (pulse * pulse)
        lines.Top.Size = UDim2.fromOffset(3, len)
        lines.Bottom.Size = UDim2.fromOffset(3, len)
        lines.Bottom.Position = UDim2.new(0.5, -1.5, 1, -len)
        lines.Left.Size = UDim2.fromOffset(len, 3)
        lines.Right.Size = UDim2.fromOffset(len, 3)
        lines.Right.Position = UDim2.new(1, -len, 0.5, -1.5)
        local color = Color3.fromHSV((t * 0.20) % 1, 1, 1)
        lines.Top.BackgroundColor3 = color
        lines.Bottom.BackgroundColor3 = color
        lines.Left.BackgroundColor3 = color
        lines.Right.BackgroundColor3 = color
        textLabel.TextColor3 = color
    end)
end)


task.spawn(function()
    local gui = Instance.new("ScreenGui")
    gui.Name = "VallkESP"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 40
    pcall(function() if gethui then gui.Parent = gethui() else gui.Parent = CoreGui end end)
    if not gui.Parent then gui.Parent = PlayerGui end
    local entries = {}
    local function ensure(plr)
        if entries[plr] or plr == LocalPlayer then return end
        local box = Instance.new("Frame")
        box.BackgroundTransparency = 1
        box.Visible = false
        box.Parent = gui
        local stroke = Instance.new("UIStroke", box)
        stroke.Thickness = 1.5
        stroke.Color = Color3.fromRGB(255, 80, 80)
        local name = Instance.new("TextLabel")
        name.BackgroundTransparency = 1
        name.Font = Enum.Font.Code
        name.TextSize = 12
        name.TextColor3 = Color3.new(1,1,1)
        name.TextStrokeTransparency = 0
        name.Size = UDim2.fromOffset(140, 14)
        name.Visible = false
        name.Parent = gui
        entries[plr] = {box=box, name=name}
    end
    for _, plr in ipairs(Players:GetPlayers()) do ensure(plr) end
    Players.PlayerAdded:Connect(ensure)
    Players.PlayerRemoving:Connect(function(plr)
        local e = entries[plr]
        if e then pcall(function() e.box:Destroy() e.name:Destroy() end) entries[plr]=nil end
    end)
    local f = 0
    RunService.RenderStepped:Connect(function()
        f += 1
        if f % 2 ~= 0 then return end
        local cam = Workspace.CurrentCamera
        if not cam then return end
        for plr, e in pairs(entries) do
            if not espEnabled then e.box.Visible=false; e.name.Visible=false
            else
                local char = plr.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local head = char and (char:FindFirstChild("HitboxHead") or char:FindFirstChild("Head") or hrp)
                if hrp and hum and head and hum.Health > 0 and not is_teammate(plr) then
                    local top = cam:WorldToViewportPoint(head.Position + Vector3.new(0,0.7,0))
                    local mid = cam:WorldToViewportPoint(hrp.Position)
                    local bot = cam:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))
                    if mid.Z > 0 then
                        local h = math.max(math.abs(top.Y - bot.Y), 20)
                        local w = h * 0.55
                        if espBoxEnabled then
                            e.box.Size = UDim2.fromOffset(w, h)
                            e.box.Position = UDim2.fromOffset(mid.X - w/2, top.Y)
                            e.box.Visible = true
                        else e.box.Visible = false end
                        if espNameEnabled then
                            e.name.Text = plr.DisplayName or plr.Name
                            e.name.Position = UDim2.fromOffset(mid.X - 70, top.Y - 14)
                            e.name.Visible = true
                        else e.name.Visible = false end
                    else e.box.Visible=false; e.name.Visible=false end
                else e.box.Visible=false; e.name.Visible=false end
            end
        end
    end)
end)




-- Wallbang + Desync (Main) �� toggle via wallbangEnabled
task.spawn(function()
    if getgenv().__VallkWallbangInit then return end
    getgenv().__VallkWallbangInit = true
    local env = getgenv()
    pcall(function()
        if env.DesyncController and env.DesyncController.Stop then env.DesyncController:Stop() end
        if env.TargetController and env.TargetController.Stop then env.TargetController:Stop() end
        if env.WallbangController and env.WallbangController.Stop then env.WallbangController:Stop() end
    end)

    local function cref(x)
        return (cloneref and cloneref(x)) or x
    end
    local Players = cref(game:GetService("Players"))
    local RunService = cref(game:GetService("RunService"))
    local ReplicatedStorage = cref(game:GetService("ReplicatedStorage"))
    local Workspace = cref(game:GetService("Workspace"))
    local UserInputService = cref(game:GetService("UserInputService"))
    local LP = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera

    local GunItem, Utility
    pcall(function()
        GunItem = require(LP.PlayerScripts.Modules.ItemTypes.Gun)
        Utility = require(ReplicatedStorage.Modules.Utility)
    end)
    if not GunItem or not Utility then
        warn("[Wallbang] GunItem/Utility missing")
        return
    end

    local DesyncController = {}
    function DesyncController:init()
        self.active = false
        self.connection = nil
        self.currentTarget = nil
    end
    function DesyncController:Start(target)
        self:Stop()
        self.active = true
        self.connection = RunService.Heartbeat:Connect(function()
            if not self.active or not wallbangEnabled then return end
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local tr = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            if not tr then self:Stop() return end
            self.currentTarget = target
            local desyncCF = tr.CFrame * CFrame.new(0, -5, 0)
            local bakCF, bakVel = root.CFrame, root.AssemblyLinearVelocity
            root.CFrame = desyncCF
            pcall(function()
                RunService:BindToRenderStep("vallk_desync_fb", 101, function()
                    root.CFrame = bakCF
                    root.AssemblyLinearVelocity = bakVel
                    pcall(function() RunService:UnbindFromRenderStep("vallk_desync_fb") end)
                end)
            end)
        end)
    end
    function DesyncController:Stop()
        self.active = false
        self.currentTarget = nil
        if self.connection then self.connection:Disconnect() self.connection = nil end
        pcall(function() RunService:UnbindFromRenderStep("vallk_desync_fb") end)
    end
    DesyncController:init()
    env.DesyncController = DesyncController

    local TargetController = {}
    function TargetController:init()
        self.active = true
        self.target = nil
        self.connection = RunService.Heartbeat:Connect(function()
            if not wallbangEnabled then self.target = nil return end
            self.target = self:GetClosestTarget()
        end)
    end
    function TargetController:IsValid(character)
        local root = character:FindFirstChild("HumanoidRootPart")
        local head = character:FindFirstChild("Head")
        local hum = character:FindFirstChildWhichIsA("Humanoid")
        return root and head and hum and hum.Health > 0
    end
    function TargetController:IsEnemy(player)
        local a, b = player:GetAttribute("TeamID"), LP:GetAttribute("TeamID")
        if a ~= nil and b ~= nil then return a ~= b end
        return true
    end
    function TargetController:GetClosestTarget()
        local closest, best = nil, math.huge
        local mouse = UserInputService:GetMouseLocation()
        local cam = Workspace.CurrentCamera
        if not cam then return nil end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and self:IsEnemy(player) then
                local ch = player.Character
                if ch and self:IsValid(ch) then
                    local root = ch.HumanoidRootPart
                    local sp, on = cam:WorldToViewportPoint(root.Position)
                    if on then
                        local d = (mouse - Vector2.new(sp.X, sp.Y)).Magnitude
                        if d < best then best, closest = d, player end
                    end
                end
            end
        end
        return closest
    end
    function TargetController:Stop()
        if self.connection then self.connection:Disconnect() self.connection = nil end
    end
    TargetController:init()
    env.TargetController = TargetController

    local WallbangController = {}
    function WallbangController:init()
        self.startShootingRef = GunItem.StartShooting
        self.desyncCleanup = nil
        self.hooked = false
    end
    function WallbangController:Start()
        if self.hooked then return end
        self.hooked = true
        local startRef = self.startShootingRef
        GunItem.StartShooting = function(controller, ...)
            local result = {startRef(controller, ...)}
            if not wallbangEnabled then
                return unpack(result)
            end
            local clientFighter = controller and controller.ClientFighter
            if not clientFighter or not clientFighter.IsLocalPlayer then
                return unpack(result)
            end
            local cameraData = result[3]
            if type(cameraData) ~= "table" then
                return unpack(result)
            end
            result[4] = true -- no spread
            local targetPlayer = TargetController.target
            if not targetPlayer or not targetPlayer.Character then
                return unpack(result)
            end
            if DesyncController.currentTarget ~= targetPlayer then
                DesyncController:Start(targetPlayer)
                task.wait(0.05)
            end
            if self.desyncCleanup then pcall(task.cancel, self.desyncCleanup) end
            local head = targetPlayer.Character:FindFirstChild("Head")
            if not head then return unpack(result) end
            local targetPos = head.Position
            local targetCF = head.CFrame
            local shootingPos = targetPos - Vector3.new(0, 5, 0)
            local shootingOffset = targetCF:ToObjectSpace(CFrame.new(targetPos + Vector3.new(math.random(), math.random(), math.random())))
            pcall(function()
                cameraData[utf8.char(0)] = Utility:EncodeCFrame(CFrame.new(shootingPos, targetPos) * CFrame.Angles(CFrame.lookAt(shootingPos, targetPos):ToOrientation()))
                cameraData[utf8.char(1)] = Utility:EncodeCFrame(CFrame.new(targetPos) * CFrame.Angles(CFrame.lookAt(shootingPos, targetPos):ToOrientation()))
                cameraData[utf8.char(2)] = head
                cameraData[utf8.char(3)] = Utility:EncodeCFrame(shootingOffset)
            end)
            self.desyncCleanup = task.delay(0.15, function()
                DesyncController:Stop()
            end)
            return unpack(result)
        end
    end
    function WallbangController:Stop()
        if self.startShootingRef then
            GunItem.StartShooting = self.startShootingRef
        end
        self.hooked = false
        DesyncController:Stop()
    end
    WallbangController:init()
    env.WallbangController = WallbangController

    -- keep hook installed; gate with wallbangEnabled
    WallbangController:Start()
    print("[multvallk] Wallbang ready (toggle in Main)")
end)

-- Ragebot / Ammo red indicators (void / killing / reloading)
task.spawn(function()
    if getgenv().__VallkRageIndicators then return end
    getgenv().__VallkRageIndicators = true
    local gui = Instance.new("ScreenGui")
    gui.Name = "VallkRageIndicators"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999
    pcall(function()
        if gethui then gui.Parent = gethui() else gui.Parent = game:GetService("CoreGui") end
    end)
    if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local function makeLabel(name, y)
        local t = Instance.new("TextLabel")
        t.Name = name
        t.BackgroundTransparency = 1
        t.Size = UDim2.new(0, 420, 0, 22)
        t.AnchorPoint = Vector2.new(0.5, 0)
        t.Position = UDim2.new(0.5, 0, 0.5, y)
        t.Font = Enum.Font.Code
        t.TextSize = 14
        t.TextColor3 = Color3.fromRGB(255, 60, 60)
        t.TextStrokeTransparency = 0
        t.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        t.Text = ""
        t.Visible = false
        t.Parent = gui
        return t
    end
    local rageLbl = makeLabel("RagebotIndicator", 36)
    local ammoLbl = makeLabel("AmmoIndicator", 52)
    ammoLbl.TextSize = 11
    ammoLbl.Size = UDim2.new(0, 420, 0, 18)

    local function getAmmo()
        local cur, max, reloading = nil, nil, false
        pcall(function()
            local ps = LocalPlayer.PlayerScripts
            local ok, fc = pcall(require, ps.Controllers.FighterController)
            if not ok or not fc or not fc.LocalFighter then return end
            local item = fc.LocalFighter.EquippedItem
            if not item then return end
            local function gp(key)
                local s, v = pcall(function()
                    if item.Get then return item:Get(key) end
                    return item[key] or (item.Data and item.Data[key]) or (item.Info and item.Info[key])
                end)
                return s and v or nil
            end
            cur = gp("CurrentAmmo") or gp("Ammo") or gp("Bullets") or gp("MagazineAmmo")
            max = gp("ReserveAmmo") or gp("StoredAmmo") or gp("MaxAmmo") or gp("MaxBullets")
            reloading = gp("Reloading") == true or gp("IsReloading") == true
            if item.Info and type(item.Info) == "table" then
                if cur == nil then cur = item.Info.CurrentAmmo or item.Info.Ammo end
                if max == nil then max = item.Info.ReserveAmmo or item.Info.MaxAmmo end
                if item.Info.Reloading or item.Info.IsReloading then reloading = true end
            end
        end)
        return cur, max, reloading
    end

    if not RunService then return end
    RunService.RenderStepped:Connect(function()
        local rageOn = ragebotOrKillAura == true
        if ragebotIndicatorEnabled and rageOn then
            local cur, max, reloading = getAmmo()
            local isReload = reloading or (typeof(cur) == "number" and cur <= 0)
            if isReload then
                rageLbl.Text = "ragebot : reloading..."
            elseif activeTargetPart and activeTargetPart.Parent then
                local model = activeTargetPart:FindFirstAncestorOfClass("Model") or activeTargetPart.Parent
                local plr = Players:GetPlayerFromCharacter(model)
                local name = plr and (plr.DisplayName or plr.Name) or (typeof(model) == "Instance" and model.Name or "???")
                rageLbl.Text = "ragebot : killing " .. tostring(name) .. "..."
            else
                -- 怨듦꺽 �� �� �� 臾댁“嫄� void
                rageLbl.Text = "ragebot : void..."
            end
            rageLbl.Visible = true
        else
            rageLbl.Visible = false
        end

        if ammoIndicatorEnabled then
            local cur, max, reloading = getAmmo()
            local text
            if reloading then
                text = "reloading"
            elseif typeof(cur) == "number" and typeof(max) == "number" then
                text = string.format("%d/%d", math.floor(cur + 0.5), math.floor(max + 0.5))
            elseif typeof(cur) == "number" then
                text = tostring(math.floor(cur + 0.5))
            end
            if text then
                ammoLbl.Text = text
                ammoLbl.Position = UDim2.new(0.5, 0, 0.5, (ragebotIndicatorEnabled and rageOn) and 52 or 36)
                ammoLbl.Visible = true
            else
                ammoLbl.Visible = false
            end
        else
            ammoLbl.Visible = false
        end
    end)
end)

-- Lion Auto Respawn + Collect Drops
task.spawn(function()
    local deathConn
    local function getRespawnRemote()
        local ok, r = pcall(function()
            local RS = game:GetService("ReplicatedStorage")
            local duels = RS:FindFirstChild("Duels") or RS:FindFirstChild("Remotes")
            if duels then
                return duels:FindFirstChild("RespawnNow") or duels:FindFirstChild("Respawn")
            end
            for _, d in ipairs(RS:GetDescendants()) do
                if d:IsA("RemoteEvent") and d.Name:lower():find("respawn") then
                    return d
                end
            end
        end)
        return ok and r or nil
    end
    local function setup(char)
        if deathConn then pcall(function() deathConn:Disconnect() end) deathConn = nil end
        if not autoRespawnEnabled then return end
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        deathConn = hum.Died:Connect(function()
            task.wait(0.15)
            if not autoRespawnEnabled then return end
            pcall(function()
                local r = getRespawnRemote()
                if r then r:FireServer() end
            end)
        end)
    end
    if LocalPlayer.Character then setup(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(setup)

    local tracked = {}
    local function track(obj)
        if obj:FindFirstChild("Ammo") or obj:FindFirstChild("Health") then
            tracked[obj] = true
        end
    end
    for _, c in ipairs(Workspace:GetChildren()) do track(c) end
    Workspace.ChildAdded:Connect(track)
    Workspace.ChildRemoved:Connect(function(o) tracked[o] = nil end)

    local nextT = 0
    RunService.Heartbeat:Connect(function()
        if not collectDropsEnabled then return end
        if tick() < nextT then return end
        nextT = tick() + 0.4
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp or not firetouchinterest then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local needHp = hum and hum.Health < hum.MaxHealth
        for obj in pairs(tracked) do
            if not obj.Parent then tracked[obj] = nil
            elseif (obj:FindFirstChild("Health") and needHp) or obj:FindFirstChild("Ammo") then
                pcall(firetouchinterest, hrp, obj, 0)
                pcall(firetouchinterest, hrp, obj, 1)
            end
        end
    end)
end)

-- Skin unlock reinforce when toggled
task.spawn(function()
    while true do
        task.wait(2)
        if not skinChangerEnabled then continue end
        pcall(function()
            if not CosmeticLibrary then
                local ok, lib = pcall(function()
                    return require(ReplicatedStorage:WaitForChild("Modules", 2):WaitForChild("CosmeticLibrary", 2))
                end)
                if ok then CosmeticLibrary = lib end
            end
            if not CosmeticLibrary then return end
            for _, name in ipairs({"OwnsCosmetic", "OwnsCosmeticNormally", "OwnsCosmeticUniversally", "OwnsCosmeticForWeapon", "PlayerOwnsCosmetic"}) do
                if type(CosmeticLibrary[name]) == "function" then
                    local orig = CosmeticLibrary[name]
                    CosmeticLibrary[name] = function(self, ...)
                        if skinChangerEnabled then return true end
                        return orig(self, ...)
                    end
                end
            end
        end)
    end
end)

print("[multvallk Premium v3] Loaded (anti-freeze patches)")
-- anti-freeze: toggle UI no longer refreshes every frame; old void loop disabled
