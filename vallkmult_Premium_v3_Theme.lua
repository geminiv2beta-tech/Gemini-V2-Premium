-- ============================================================================
-- vallkmult Premium v3 - Fully Integrated Dual Engine (Valk UI Engine)
-- Mobile UI Auto-Scaling & Ragebot Integrated Edition (No Key System)
-- Integrated Feature: Advanced Device Spoofer Engine & Hit Sounds (UI Set)
-- + Anti Aim (from Lion) fully ported into Misc — 100% function preserved
-- + Lion Ragebot open-source modes (Orbit / Teleport / Void / Underground) applied
-- + Device Selection (nexlib): VR / Touch / Gamepad / MouseKeyboard via SetControls + UIS hooks
-- + Lion full Skybox presets + Anti Katana (Misc)\n-- + Lion All Skins (CosmeticInventory spoof)
-- ============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local VRService = game:GetService("VRService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================================
-- SECTION: Intro UI (2초 후 등장, 3초간 유지 후 파란색으로 사라짐)
-- ============================================================================
task.spawn(function()
    task.wait(2) -- 2초 대기
    
    local IntroGui = Instance.new("ScreenGui")
    IntroGui.Name = "multvallkIntroUI"
    IntroGui.ResetOnSpawn = false
    pcall(function() if gethui then IntroGui.Parent = gethui() else IntroGui.Parent = CoreGui end end)
    if not IntroGui.Parent then IntroGui.Parent = PlayerGui end
    
    local IntroLabel = Instance.new("TextLabel", IntroGui)
    IntroLabel.Size = UDim2.new(1, 0, 0, 80)
    IntroLabel.Position = UDim2.new(0, 0, 0.4, 0)
    IntroLabel.BackgroundTransparency = 1
    IntroLabel.Text = "vallkmult Premium"
    IntroLabel.TextColor3 = Color3.fromRGB(0, 150, 255) -- 파란색 계열
    IntroLabel.TextStrokeTransparency = 0.5
    IntroLabel.Font = Enum.Font.GothamBold
    IntroLabel.TextSize = 36
    IntroLabel.TextXAlignment = Enum.TextXAlignment.Center
    IntroLabel.TextYAlignment = Enum.TextYAlignment.Center
    
    task.wait(3) -- 3초 동안 유지
    
    -- 파란색으로 부드럽게 사라지기 (Fade-out)
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(IntroLabel, tweenInfo, {
        TextTransparency = 1,
        TextStrokeTransparency = 1
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        IntroGui:Destroy()
    end)
end)

-- ============================================================================
-- SECTION: Anti-Kick / Security / Anti-Cheat Bypass (strengthened)
-- ============================================================================
pcall(function()
    -- 1) Local kick nullify
    if LocalPlayer and typeof(LocalPlayer.Kick) == "function" then
        local oldKick = LocalPlayer.Kick
        LocalPlayer.Kick = function(...) end
        pcall(function()
            if hookfunction then
                hookfunction(oldKick, newcclosure(function(...) end))
            end
        end)
    end

    -- 2) Players service kick / ban helpers
    pcall(function()
        if typeof(Players.Kick) == "function" then
            Players.Kick = function(...) end
        end
    end)

    -- 3) setmetatable anti-detection (kv weak tables from AC)
    if getrenv and getrenv().setmetatable and hookfunction then
        local _stbl
        _stbl = hookfunction(getrenv().setmetatable, newcclosure(function(tbl, mt)
            if mt and typeof(mt) == "table" and rawget(mt, "__mode") == "kv" then
                local tr = debug.traceback()
                if tr and (
                    tr:find("MiscellaneousController")
                    or tr:find("anticheat") or tr:find("AntiCheat")
                    or tr:find("Detection") or tr:find("Security")
                    or tr:find("AntiExploit") or tr:find("Integrity")
                    or tr:find("KickHook") or tr:find("Watchdog")
                    or tr:find("Sentinel") or tr:find("Moderation")
                ) then
                    return _stbl({1, 2, 3}, {})
                end
            end
            return _stbl(tbl, mt)
        end))
    end

    -- 4) namecall: block Kick + suspicious FireServer / InvokeServer
    if hookmetamethod and getnamecallmethod then
        local bannedRemoteNames = {
            kick=true, ban=true, punish=true, anticheat=true, detect=true,
            report=true, flag=true, crash=true, log=true, screenshot=true,
            security=true, mod=true, admin=true, watchdog=true, sentinel=true,
            integrity=true, exploit=true, cheater=true, violation=true,
            teleportkick=true, softkick=true, hardkick=true,
        }
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}

            if method == "Kick" or method == "kick" then
                return
            end

            if (method == "FireServer" or method == "InvokeServer" or method == "Fire" or method == "Invoke") and self then
                local sName = ""
                pcall(function() sName = string.lower(tostring(self.Name or "")) end)
                for k, _ in pairs(bannedRemoteNames) do
                    if sName ~= "" and string.find(sName, k, 1, true) then
                        return
                    end
                end
                -- also scan first string arg for kick/ban payloads
                if type(args[1]) == "string" then
                    local a = string.lower(args[1])
                    if string.find(a, "kick", 1, true) or string.find(a, "ban", 1, true)
                        or string.find(a, "anticheat", 1, true) or string.find(a, "exploit", 1, true) then
                        return
                    end
                end
            end

            return oldNamecall(self, ...)
        end))
    end

    -- 5) ScriptContext error silence (stops some AC error-based detection)
    pcall(function()
        local ScriptContext = game:GetService("ScriptContext")
        if ScriptContext and ScriptContext.Error then
            ScriptContext.Error:Connect(function() end)
        end
    end)

    -- 6) Cloak known cheat GUI names so scanners miss them
    pcall(function()
        local function cloak(inst)
            if not inst then return end
            pcall(function()
                inst.Name = tostring(math.random(100000, 999999))
            end)
        end
        task.defer(function()
            task.wait(1.2)
            local names = {
                "HalmuESP", "HalmuFOV", "HalmuIndicators", "ExecutorToggleUI",
                "CustomCursorGui", "multvallkHalmuUI", "multvallkHitLogUI",
                "multvallkRageUI", "multvallkIntroUI", "nexlib"
            }
            for _, n in ipairs(names) do
                local o = CoreGui:FindFirstChild(n)
                if o then cloak(o) end
                if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
                    local o2 = LocalPlayer.PlayerGui:FindFirstChild(n)
                    if o2 then cloak(o2) end
                end
                if gethui then
                    local ok, hui = pcall(gethui)
                    if ok and hui then
                        local o3 = hui:FindFirstChild(n)
                        if o3 then cloak(o3) end
                    end
                end
            end
        end)
    end)

    -- 7) Network owner re-claim (reduces some server authority kicks)
    pcall(function()
        local last = 0
        RunService.Heartbeat:Connect(function()
            if tick() - last < 2.5 then return end
            last = tick()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.SetNetworkOwner then
                pcall(function() hrp:SetNetworkOwner(LocalPlayer) end)
            end
        end)
    end)

    -- 8) Optional FFlag soften (if executor supports)
    pcall(function()
        if setfflag then
            pcall(setfflag, "DebugRunServiceHumanoidCheck", "False")
            pcall(setfflag, "HumanoidParallelRemoveNoPhysics", "False")
        end
    end)

    -- 9) LogService / CoreGui common kick paths soft-block
    pcall(function()
        if hookfunction and typeof(game.GetService) == "function" then
            -- no-op: keep stable; heavy GetService hooks break more than they help
        end
    end)
end)

-- Player Spawn Tracker
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        player:SetAttribute("SpawnTime", tick())
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function(char)
        player:SetAttribute("SpawnTime", tick())
    end)
    if player.Character then
        player:SetAttribute("SpawnTime", tick())
    end
end

-- ============================================================================
-- SECTION: Device Spoofer Engine & State Configuration
-- UIS property hooks + nexlib open-source SetControls remote (device selection)
-- Options: VR / Touch / Gamepad / MouseKeyboard
-- ============================================================================
local deviceSpooferEnabled = false
local spoofedDeviceMode = "VR" -- Options: "VR", "Touch", "Gamepad", "MouseKeyboard"

-- Map UI-friendly names (lowercase from nexlib dropdown) to internal mode
local function normalizeDeviceMode(v)
    if type(v) ~= "string" then return "VR" end
    local s = string.lower(v):gsub("%s+", "")
    if s == "vr" then return "VR"
    elseif s == "touch" or s == "mobile" then return "Touch"
    elseif s == "gamepad" or s == "console" then return "Gamepad"
    elseif s == "mousekeyboard" or s == "mouse&keyboard" or s == "pc" then return "MouseKeyboard"
    end
    return "VR"
end

pcall(function()
    if hookmetamethod and getnamecallmethod then
        local oldIndex
        oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, index)
            if deviceSpooferEnabled and not checkcaller() then
                if self == UserInputService then
                    if index == "TouchEnabled" then
                        return spoofedDeviceMode == "Touch"
                    elseif index == "KeyboardEnabled" or index == "MouseEnabled" then
                        return spoofedDeviceMode == "MouseKeyboard"
                    elseif index == "GamepadEnabled" then
                        return spoofedDeviceMode == "Gamepad"
                    elseif index == "VREnabled" then
                        return spoofedDeviceMode == "VR"
                    elseif index == "GyroscopesEnabled" or index == "AccelerometerEnabled" then
                        return spoofedDeviceMode == "Touch"
                    end
                elseif self == VRService then
                    if index == "VREnabled" then
                        return spoofedDeviceMode == "VR"
                    end
                end
            end
            return oldIndex(self, index)
        end))

        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if deviceSpooferEnabled and not checkcaller() then
                if self == UserInputService then
                    if method == "GetPlatform" then
                        if spoofedDeviceMode == "Touch" then
                            return Enum.Platform.IOS
                        elseif spoofedDeviceMode == "Gamepad" then
                            return Enum.Platform.XBoxOne
                        elseif spoofedDeviceMode == "MouseKeyboard" then
                            return Enum.Platform.Windows
                        elseif spoofedDeviceMode == "VR" then
                            return Enum.Platform.None
                        end
                    elseif method == "GetLastInputType" then
                        if spoofedDeviceMode == "Touch" then
                            return Enum.UserInputType.Touch
                        elseif spoofedDeviceMode == "Gamepad" then
                            return Enum.UserInputType.Gamepad1
                        elseif spoofedDeviceMode == "MouseKeyboard" then
                            return Enum.UserInputType.MouseButton1
                        elseif spoofedDeviceMode == "VR" then
                            return Enum.UserInputType.UserFocus
                        end
                    end
                end
            end
            return oldNamecall(self, ...)
        end))
    end
end)

-- nexlib open-source: periodically FireServer SetControls with selected device
local function fireDeviceSetControls()
    if not deviceSpooferEnabled then return end
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local replication = remotes and (remotes:FindFirstChild("Replication") or remotes)
        local fighter = replication and replication:FindFirstChild("Fighter")
        local setControls = fighter and fighter:FindFirstChild("SetControls")
        if setControls and setControls:IsA("RemoteEvent") then
            local mode = spoofedDeviceMode
            if mode == "VR" then
                setControls:FireServer("VR")
            elseif mode == "Touch" then
                setControls:FireServer("Touch")
            elseif mode == "Gamepad" then
                setControls:FireServer("Gamepad")
            elseif mode == "MouseKeyboard" then
                setControls:FireServer("MouseKeyboard")
            end
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(1)
        if deviceSpooferEnabled then
            fireDeviceSetControls()
        end
    end
end)

-- ============================================================================
-- SECTION: Hit Sound System (nexlib open-source — working asset IDs + ClientViewModel hook)
-- ============================================================================
local hitSoundEnabled = true
local selectedHitSound = "rust hs"
local hitSoundVolume = 1.0
local hitSoundPitch = 1.0
local _lastHitSoundAt = 0

-- nexlib verified working IDs (bruh etc. that actually play)
local hitSoundList = {
    ["rust hs"]              = "rbxassetid://4764109000",
    ["neverlose"]            = "rbxassetid://97643101798871",
    ["sparkle"]              = "rbxassetid://110241936966089",
    ["minecraft hit"]        = "rbxassetid://8766809464",
    ["bonk"]                 = "rbxassetid://5766898159",
    ["osu"]                  = "rbxassetid://7149255551",
    ["among us"]             = "rbxassetid://5700183626",
    ["bruh"]                 = "rbxassetid://4578740568",
    ["vine"]                 = "rbxassetid://5332680810",
    ["gamesense"]            = "rbxassetid://4817809188",
    ["장충동 왕족발 보쌈"]     = "rbxassetid://85775332966635",
}

local function playHitSound()
    if not hitSoundEnabled then return end
    local now = tick()
    if now - _lastHitSoundAt < 0.05 then return end
    _lastHitSoundAt = now

    local soundId = hitSoundList[selectedHitSound] or hitSoundList["rust hs"]
    if not soundId or soundId == "" then return end

    pcall(function()
        local sound = Instance.new("Sound")
        sound.Name = "vallkHitSound"
        sound.SoundId = soundId
        sound.Volume = math.clamp(tonumber(hitSoundVolume) or 1, 0, 2)
        sound.PlaybackSpeed = math.clamp(tonumber(hitSoundPitch) or 1, 0.1, 2)
        sound.Looped = false
        sound.PlayOnRemove = false
        sound.Parent = SoundService
        sound:Play()
        pcall(function()
            game:GetService("Debris"):AddItem(sound, 4)
        end)
        task.delay(4, function()
            if sound and sound.Parent then pcall(function() sound:Destroy() end) end
        end)
    end)
end

-- nexlib method: intercept game hit sounds on ClientViewModel (most reliable)
task.spawn(function()
    local function hookViewModel(vm)
        if not vm or vm:GetAttribute("vallkHSHooked") then return end
        pcall(function() vm:SetAttribute("vallkHSHooked", true) end)
        vm.ChildAdded:Connect(function(child)
            if not hitSoundEnabled then return end
            if child:IsA("Sound") and child.SoundId ~= "rbxassetid://16537449730" then
                pcall(function()
                    local sid = hitSoundList[selectedHitSound] or hitSoundList["rust hs"]
                    -- mute original game sound, play our custom
                    child.SoundId = sid
                    child.PlaybackSpeed = math.clamp(tonumber(hitSoundPitch) or 1, 0.1, 2)
                    child.Volume = 0

                    local s = Instance.new("Sound")
                    s.SoundId = sid
                    s.PlaybackSpeed = math.clamp(tonumber(hitSoundPitch) or 1, 0.1, 2)
                    s.Volume = math.clamp(tonumber(hitSoundVolume) or 1, 0, 2)
                    s.Parent = SoundService
                    s:Play()
                    pcall(function()
                        game:GetService("Debris"):AddItem(s, 4)
                    end)
                end)
            end
        end)
    end

    pcall(function()
        local path = LocalPlayer.PlayerScripts:FindFirstChild("Modules")
            and LocalPlayer.PlayerScripts.Modules:FindFirstChild("ClientReplicatedClasses")
            and LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses:FindFirstChild("ClientFighter")
            and LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter:FindFirstChild("ClientItem")
            and LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
        if path then
            hookViewModel(path)
            path.ChildAdded:Connect(function(ch)
                if ch:IsA("Model") or ch:IsA("Folder") then hookViewModel(ch) end
            end)
        end
    end)

    -- also watch Character tools / viewmodel under workspace.CurrentCamera
    pcall(function()
        local cam = Workspace.CurrentCamera
        if cam then
            cam.ChildAdded:Connect(function(ch)
                if ch:IsA("Model") then
                    for _, d in ipairs(ch:GetDescendants()) do
                        if d:IsA("Sound") then end
                    end
                    ch.DescendantAdded:Connect(function(d)
                        if not hitSoundEnabled then return end
                        if d:IsA("Sound") and d.SoundId ~= "rbxassetid://16537449730" then
                            pcall(function()
                                local sid = hitSoundList[selectedHitSound] or hitSoundList["rust hs"]
                                d.Volume = 0
                                local s = Instance.new("Sound")
                                s.SoundId = sid
                                s.PlaybackSpeed = math.clamp(tonumber(hitSoundPitch) or 1, 0.1, 2)
                                s.Volume = math.clamp(tonumber(hitSoundVolume) or 1, 0, 2)
                                s.Parent = SoundService
                                s:Play()
                                pcall(function() game:GetService("Debris"):AddItem(s, 4) end)
                            end)
                        end
                    end)
                end
            end)
        end
    end)
end)

-- ============================================================================
-- SECTION: Settings Variables (Key System Completely Removed)
-- ============================================================================
local mobileOnEnabled = false

-- Aimbot & Silent Aim
local aimbotEnabled = false
local aimbotSmoothness = 5
local aimbotFovRadius = 100
local aimbotHitPart = "head" -- "head", "humanoidrootpart", "torso"
local aimbotWallCheck = false
local aimbotDrawFov = false
local aimbotScopeLook = false

local silentAimEnabled = false
local silentAimHitPart = "head" -- "head", "humanoidrootpart", "torso"
local silentAimFovRadius = 300
local silentWallCheck = false
local silentAimDrawFov = false
local silentAimTarget = nil

-- Ragebot Toggle & Sub-features (Lion open-source modes applied)
local ragebotOrKillAura = false
local ragebotHeightOffset = 3
local ragebotHideDelay = 0.01   -- Hide (0.01s ~ 1.00s)
local ragebotAttackDelay = 0.01 -- Attack (0.01s ~ 1.00s)
-- Lion Ragebot modes / settings
local ragebotMode = "Orbit"           -- Orbit / Teleport / Void / Underground
local ragebotOrbitDist = 3
local ragebotOrbitHeight = 2
local ragebotTeleportDelay = 0.04
local ragebotUndergroundDepth = 6
local ragebotHyper = false
local ragebotVoidSpam = true
local ragebotVoidHideTime = 0.25
local ragebotVoidShootTime = 0.03
local ragebotDirBack = true
local ragebotDirFront = false
local ragebotDirLeft = true
local ragebotDirRight = true
local ragebotDirUp = true
local ragebotDirDown = false
local ragebotAntiAimInRage = false
local ragebotNextTeleportAt = 0
local ragebotVoidExposed = false
local ragebotAaPhase = 0

-- Vallk Features & Cooldowns
local fastMeleeEnabled = false
local hoNyangNoCDEnabled = false
local attackCooldownDisabled = false
local projectileCooldownDisabled = false

-- FFMode
local ffModeEnabled = false
local ffTeamCheckEnabled = true
local ffBaitingEnabled = false

-- Orbit & Void Spam (nexlib open-source behavior)
local orbitEnabled = false
local orbitRange = 50000000  -- nexlib default "orbit studs"
local orbitDelay = 0.01
local orbitAnchorPos = nil   -- locked when orbit starts

local voidSpamEnabled = false
local voidSpamRange = 50     -- nexlib "void spam studs" = lock Y height
local voidSpamDelay = 0.01

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
local espSkeletonEnabled = false
local espDistanceEnabled = true

local pcFlyEnabled = false
local mobileFlyEnabled = false
local noclipEnabled = false
local rapidSpeedEnabled = false
local rapidSpeedMultiplier = 2.5

local skinChangerEnabled = false
local customSkyboxEnabled = false
local skyboxTheme = "Vaporwave"

local circleCrosshairEnabled = false
local circleCrosshairSize = 60
local circleRotationSpeed = 4

-- ============================================================================
-- SECTION: ESP Engine (ported from Lion Drawing ESP)
-- Box / Name / Health / Tracer / Skeleton — team-aware, Drawing API
-- ============================================================================
local espObjects = {} -- [Player] = drawings table
local SKELETON_PAIRS = {
    {"Head", "UpperTorso"}, {"Head", "Torso"},
    {"UpperTorso", "LowerTorso"}, {"Torso", "HumanoidRootPart"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"Torso", "Left Arm"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"Torso", "Right Arm"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"Torso", "Left Leg"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
    {"Torso", "Right Leg"},
    {"HumanoidRootPart", "Left Leg"}, {"HumanoidRootPart", "Right Leg"},
}

local function espHealthColor(ratio)
    ratio = math.clamp(tonumber(ratio) or 1, 0, 1)
    return Color3.fromRGB(255 * (1 - ratio), 255 * ratio, 40)
end

local function destroyEspFor(player)
    local obj = espObjects[player]
    if not obj then return end
    for _, d in pairs(obj) do
        if type(d) == "table" then
            for _, line in pairs(d) do
                pcall(function() if line and line.Remove then line:Remove() end end)
            end
        else
            pcall(function() if d and d.Remove then d:Remove() end end)
        end
    end
    espObjects[player] = nil
end

local function ensureEspFor(player)
    if espObjects[player] then return espObjects[player] end
    local obj = {
        box = Drawing.new("Square"),
        border = Drawing.new("Square"),
        name = Drawing.new("Text"),
        healthBg = Drawing.new("Square"),
        healthFill = Drawing.new("Square"),
        tracer = Drawing.new("Line"),
        skeleton = {},
    }
    obj.box.Filled = false
    obj.box.Thickness = 1
    obj.box.Color = Color3.fromRGB(128, 213, 247)
    obj.box.Visible = false

    obj.border.Filled = false
    obj.border.Thickness = 3
    obj.border.Color = Color3.new(0, 0, 0)
    obj.border.Transparency = 0.4
    obj.border.Visible = false

    obj.name.Size = 14
    obj.name.Center = true
    obj.name.Outline = true
    obj.name.OutlineColor = Color3.new(0, 0, 0)
    obj.name.Color = Color3.fromRGB(255, 255, 255)
    obj.name.Font = 2
    obj.name.Visible = false

    obj.healthBg.Filled = true
    obj.healthBg.Color = Color3.new(0, 0, 0)
    obj.healthBg.Transparency = 0.35
    obj.healthBg.Visible = false

    obj.healthFill.Filled = true
    obj.healthFill.Color = Color3.fromRGB(0, 255, 80)
    obj.healthFill.Visible = false

    obj.tracer.Thickness = 1.5
    obj.tracer.Color = Color3.fromRGB(128, 213, 247)
    obj.tracer.Visible = false

    for i = 1, 16 do
        local line = Drawing.new("Line")
        line.Thickness = 1.5
        line.Color = Color3.fromRGB(128, 213, 247)
        line.Visible = false
        obj.skeleton[i] = line
    end

    espObjects[player] = obj
    return obj
end

local function hideEspObj(obj)
    if not obj then return end
    obj.box.Visible = false
    obj.border.Visible = false
    obj.name.Visible = false
    obj.healthBg.Visible = false
    obj.healthFill.Visible = false
    obj.tracer.Visible = false
    if obj.skeleton then
        for _, line in pairs(obj.skeleton) do
            line.Visible = false
        end
    end
end

local function updateSkeleton(obj, char, cam)
    if not obj.skeleton then return end
    local lineIdx = 1
    local used = {}
    for _, pair in ipairs(SKELETON_PAIRS) do
        if lineIdx > #obj.skeleton then break end
        local a = char:FindFirstChild(pair[1])
        local b = char:FindFirstChild(pair[2])
        if a and b and a:IsA("BasePart") and b:IsA("BasePart") then
            local key = pair[1] .. ">" .. pair[2]
            if not used[key] then
                used[key] = true
                local p1, o1 = cam:WorldToViewportPoint(a.Position)
                local p2, o2 = cam:WorldToViewportPoint(b.Position)
                local line = obj.skeleton[lineIdx]
                if (o1 or o2) and p1.Z > 0 and p2.Z > 0 then
                    line.From = Vector2.new(p1.X, p1.Y)
                    line.To = Vector2.new(p2.X, p2.Y)
                    line.Color = Color3.fromRGB(128, 213, 247)
                    line.Visible = true
                    lineIdx = lineIdx + 1
                end
            end
        end
    end
    for i = lineIdx, #obj.skeleton do
        obj.skeleton[i].Visible = false
    end
end

local function updateESP()
    if not espEnabled then
        for plr, obj in pairs(espObjects) do
            hideEspObj(obj)
        end
        return
    end

    local cam = Workspace.CurrentCamera
    if not cam then return end
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local viewport = cam.ViewportSize
    local tracerOrigin = Vector2.new(viewport.X / 2, viewport.Y)

    local seen = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        -- team check (safe: works even if is_teammate is defined later in file)
        local teammate = false
        if type(is_teammate) == "function" then
            local ok, res = pcall(is_teammate, player)
            teammate = ok and res == true
        else
            local myTeam = LocalPlayer:GetAttribute("TeamID")
            local pTeam = player:GetAttribute("TeamID")
            if myTeam ~= nil and pTeam ~= nil and myTeam == pTeam then
                teammate = true
            end
        end
        if teammate then
            destroyEspFor(player)
            continue
        end

        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and (char:FindFirstChild("Head") or hrp)
        if not (char and hum and hrp and head and hum.Health > 0) then
            destroyEspFor(player)
            continue
        end

        seen[player] = true
        local obj = ensureEspFor(player)

        -- world AABB via head + hrp (simple reliable box)
        local topPos, topOn = cam:WorldToViewportPoint((head.Position + Vector3.new(0, 0.9, 0)))
        local botPos, botOn = cam:WorldToViewportPoint((hrp.Position - Vector3.new(0, 2.2, 0)))
        local midPos = cam:WorldToViewportPoint(hrp.Position)

        if not (topOn or botOn) or topPos.Z < 0 then
            hideEspObj(obj)
            continue
        end

        local height = math.abs(botPos.Y - topPos.Y)
        local width = height * 0.55
        local x = midPos.X - width / 2
        local y = topPos.Y

        -- Box
        if espBoxEnabled then
            obj.border.Size = Vector2.new(width + 2, height + 2)
            obj.border.Position = Vector2.new(x - 1, y - 1)
            obj.border.Visible = true

            obj.box.Size = Vector2.new(width, height)
            obj.box.Position = Vector2.new(x, y)
            obj.box.Color = Color3.fromRGB(128, 213, 247)
            obj.box.Visible = true
        else
            obj.box.Visible = false
            obj.border.Visible = false
        end

        -- Name (+ optional distance)
        if espNameEnabled then
            local label = player.DisplayName or player.Name
            if espDistanceEnabled and myRoot then
                local dist = math.floor((myRoot.Position - hrp.Position).Magnitude)
                label = string.format("%s [%dm]", label, dist)
            end
            obj.name.Text = label
            obj.name.Position = Vector2.new(midPos.X, y - 16)
            obj.name.Visible = true
        else
            obj.name.Visible = false
        end

        -- Health bar (left of box)
        if espHealthEnabled then
            local ratio = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
            local barH = height
            local barW = 3
            local barX = x - 6
            obj.healthBg.Size = Vector2.new(barW, barH)
            obj.healthBg.Position = Vector2.new(barX, y)
            obj.healthBg.Visible = true

            local fillH = barH * ratio
            obj.healthFill.Size = Vector2.new(barW - 1, fillH)
            obj.healthFill.Position = Vector2.new(barX + 0.5, y + (barH - fillH))
            obj.healthFill.Color = espHealthColor(ratio)
            obj.healthFill.Visible = true
        else
            obj.healthBg.Visible = false
            obj.healthFill.Visible = false
        end

        -- Gun tracer (bottom-center screen -> player feet)
        if gunTracerEnabled then
            obj.tracer.From = tracerOrigin
            obj.tracer.To = Vector2.new(midPos.X, botPos.Y)
            obj.tracer.Color = Color3.fromRGB(128, 213, 247)
            obj.tracer.Visible = true
        else
            obj.tracer.Visible = false
        end

        -- Skeleton (Lion-style bone lines)
        if espSkeletonEnabled then
            updateSkeleton(obj, char, cam)
        elseif obj.skeleton then
            for _, line in pairs(obj.skeleton) do
                line.Visible = false
            end
        end
    end

    -- cleanup disconnected / unseen
    for plr, _ in pairs(espObjects) do
        if not seen[plr] then
            destroyEspFor(plr)
        end
    end
end

Players.PlayerRemoving:Connect(function(player)
    destroyEspFor(player)
end)

-- ============================================================================
-- SECTION: Anti Katana (from Lion — blocks shots while enemy deflects)
-- ============================================================================
local antiKatanaEnabled = false
local antiKatanaSoundEnabled = false

_G.AntiKatanaState = _G.AntiKatanaState or {
    Enabled = false,
    DeflectingEnemies = {},
    HookedKatana = false,
}

local function antiKatanaMarkDeflect(userId, duration)
    if not userId then return end
    duration = tonumber(duration) or 1.0
    local endTime = tick() + duration + 0.12
    _G.AntiKatanaState.DeflectingEnemies[userId] = endTime
    task.delay(duration + 0.25, function()
        if _G.AntiKatanaState.DeflectingEnemies[userId] == endTime then
            _G.AntiKatanaState.DeflectingEnemies[userId] = nil
        end
    end)
end

_G.ShouldBlockShotForKatana = function(target)
    if not antiKatanaEnabled or not _G.AntiKatanaState.Enabled then
        return false
    end
    local now = tick()
    local targetUserId = nil
    if typeof(target) == "Instance" then
        if target:IsA("Player") then
            targetUserId = target.UserId
        else
            local plr = Players:GetPlayerFromCharacter(target)
            if not plr then
                local model = target:FindFirstAncestorOfClass("Model")
                plr = model and Players:GetPlayerFromCharacter(model)
            end
            targetUserId = plr and plr.UserId
        end
    elseif type(target) == "number" then
        targetUserId = target
    end

    for key, expireTime in pairs(_G.AntiKatanaState.DeflectingEnemies) do
        if now >= expireTime then
            _G.AntiKatanaState.DeflectingEnemies[key] = nil
        elseif not targetUserId or key == targetUserId then
            return true
        end
    end
    return false
end

-- Hook katana ReplicateFromServer / attribute scan to mark deflecting enemies
task.spawn(function()
    local state = _G.AntiKatanaState
    -- Attribute / animation based detection (works without deep module hooks)
    RunService.Heartbeat:Connect(function()
        if not antiKatanaEnabled then return end
        state.Enabled = true
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            local char = player.Character
            if not char then continue end
            local deflecting = false
            for _, attr in ipairs({"Reflecting", "IsReflecting", "BulletReflect", "Reflect", "Deflecting", "Parrying", "IsDeflecting", "Blocking"}) do
                local val = char:GetAttribute(attr)
                if val == true or val == 1 then deflecting = true break end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    local hv = hum:GetAttribute(attr)
                    if hv == true or hv == 1 then deflecting = true break end
                end
            end
            if not deflecting then
                local tool = char:FindFirstChildOfClass("Tool")
                local hasKatana = tool and string.find(string.lower(tool.Name), "katana", 1, true)
                if hasKatana then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local ok, tracks = pcall(function() return hum:GetPlayingAnimationTracks() end)
                        if ok and tracks then
                            for _, track in ipairs(tracks) do
                                local n = string.lower(tostring(track.Name or ""))
                                local id = ""
                                pcall(function()
                                    if track.Animation then id = string.lower(tostring(track.Animation.AnimationId or "")) end
                                end)
                                local s = n .. " " .. id
                                if string.find(s, "deflect", 1, true) or string.find(s, "reflect", 1, true)
                                    or string.find(s, "parry", 1, true) or string.find(s, "block", 1, true) then
                                    deflecting = true
                                    break
                                end
                            end
                        end
                    end
                end
            end
            if deflecting then
                antiKatanaMarkDeflect(player.UserId, 1.15)
            end
        end
    end)

    -- Optional: hook UseItem FireServer to cancel StartShooting while any deflect active
    task.wait(1)
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local useItem = remotes and remotes:FindFirstChild("Replication")
            and remotes.Replication:FindFirstChild("Fighter")
            and remotes.Replication.Fighter:FindFirstChild("UseItem")
        if not useItem or not hookfunction then return end
        local shootingEnum = nil
        pcall(function()
            if EnumLibrary then shootingEnum = EnumLibrary:ToEnum("StartShooting") end
        end)
        local oldFire
        oldFire = hookfunction(useItem.FireServer, newcclosure(function(self, ...)
            if antiKatanaEnabled and self == useItem then
                local args = {...}
                local action = args[2]
                local isStart = false
                if shootingEnum then
                    isStart = (action == shootingEnum)
                else
                    isStart = (tostring(action) == "StartShooting")
                end
                if isStart then
                    local now = tick()
                    for uid, exp in pairs(state.DeflectingEnemies) do
                        if now < exp then
                            if antiKatanaSoundEnabled and not state._soundPlaying then
                                pcall(function()
                                    local s = Instance.new("Sound")
                                    s.SoundId = "rbxassetid://1848354536"
                                    s.Volume = 0.5
                                    s.Parent = SoundService
                                    s:Play()
                                    state._soundPlaying = true
                                    s.Ended:Connect(function()
                                        state._soundPlaying = false
                                        s:Destroy()
                                    end)
                                    task.delay(1.5, function()
                                        if s and s.Parent then s:Destroy() end
                                        state._soundPlaying = false
                                    end)
                                end)
                            end
                            return -- block shot into katana deflect
                        else
                            state.DeflectingEnemies[uid] = nil
                        end
                    end
                end
            end
            return oldFire(self, ...)
        end))
    end)
end)

-- ============================================================================
-- SECTION: Anti Aim (ported 100% from Lion — camera rotation spoof)
-- ============================================================================
local antiAimEnabled = false
local antiAimPitchMode = "disabled" -- disabled / up / down / zero / random
local antiAimYawMode = "disabled"   -- disabled / backwards / spin / random
local antiAimUnderground = false
local AntiAimCameraTask = nil

local function getAntiAimCameraRotation(cameraController)
    local currentRotation = cameraController.Rotation or Vector2.zero
    local pitch = currentRotation.X or 0
    local yaw = currentRotation.Y or 0
    local cfg = _G.AntiAimPoseConfig or {}
    local pitchMode = cfg.pitch or antiAimPitchMode or "disabled"
    local yawMode = cfg.yaw or antiAimYawMode or "disabled"

    if pitchMode == "up" then
        pitch = math.rad(-89)
    elseif pitchMode == "down" then
        pitch = math.rad(179)
    elseif pitchMode == "zero" then
        pitch = 0
    elseif pitchMode == "random" then
        pitch = math.rad(math.random(-89, 179))
    end

    if yawMode == "backwards" then
        yaw = yaw + math.rad(180)
    elseif yawMode == "spin" then
        yaw = math.rad((tick() * 720) % 360)
    elseif yawMode == "random" then
        yaw = math.rad(math.random(0, 359))
    end

    return Vector2.new(pitch, yaw)
end

local function stopAntiAimCamera()
    if AntiAimCameraTask then
        pcall(task.cancel, AntiAimCameraTask)
        AntiAimCameraTask = nil
    end
end

local function startAntiAimCamera()
    stopAntiAimCamera()

    local okUtility, utility = pcall(function()
        return require(ReplicatedStorage.Modules.Utility)
    end)
    if not okUtility or not utility then return end

    local okCamera, cameraController = pcall(function()
        return require(LocalPlayer.PlayerScripts.Controllers.CameraController)
    end)
    if not okCamera or not cameraController then return end

    local updateCameraRotation = ReplicatedStorage:FindFirstChild("Remotes")
        and ReplicatedStorage.Remotes:FindFirstChild("Replication")
        and ReplicatedStorage.Remotes.Replication:FindFirstChild("Fighter")
        and ReplicatedStorage.Remotes.Replication.Fighter:FindFirstChild("UpdateCameraRotation")
    if not updateCameraRotation then return end

    AntiAimCameraTask = task.spawn(function()
        while _G.AntiAimPoseConfig and _G.AntiAimPoseConfig.enabled do
            local cfg = _G.AntiAimPoseConfig or {}
            local randomBurst = cfg.yaw == "random" and 3 or 1

            for _ = 1, randomBurst do
                local cameraRotation = getAntiAimCameraRotation(cameraController)
                pcall(function()
                    updateCameraRotation:FireServer(utility:EncodeCameraRotation(cameraRotation), nil)
                end)
            end

            RunService.Heartbeat:Wait()
        end
    end)
end

local function stopAntiAim()
    stopAntiAimCamera()
end

local function startAntiAim()
    startAntiAimCamera()
end

local function setAntiAimEnabled(state)
    antiAimEnabled = state
    if state then
        _G.AntiAimPoseConfig = {
            enabled = true,
            pitch = antiAimPitchMode,
            yaw = antiAimYawMode,
            underground = antiAimUnderground
        }
        startAntiAim()
    else
        stopAntiAim()
        _G.AntiAimPoseConfig = nil
    end
end

-- keep anti-aim alive on respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.4)
    if antiAimEnabled and _G.AntiAimPoseConfig then
        startAntiAim()
    end
end)

-- Drawing FOV Circles
local aimbotFovCircle = Drawing.new("Circle")
aimbotFovCircle.Thickness = 1.5
aimbotFovCircle.Color = Color3.fromRGB(0, 255, 255)
aimbotFovCircle.Filled = false
aimbotFovCircle.Transparency = 1
aimbotFovCircle.Visible = false

local silentFovCircle = Drawing.new("Circle")
silentFovCircle.Thickness = 1.5
silentFovCircle.Color = Color3.fromRGB(255, 0, 100)
silentFovCircle.Filled = false
silentFovCircle.Transparency = 1
silentFovCircle.Visible = false

-- Controller Modules
local FighterController, SpectateController, CameraController, GunModule, UtilityModule, EnumLibrary
pcall(function()
    local ps = LocalPlayer:WaitForChild("PlayerScripts")
    local ctrl = ps:WaitForChild("Controllers")
    FighterController = require(ctrl:WaitForChild("FighterController"))
    SpectateController = require(ctrl:WaitForChild("SpectateController", 2))
    CameraController = require(ctrl:WaitForChild("CameraController", 2))
    GunModule = require(ps:WaitForChild("Modules"):WaitForChild("ItemTypes"):WaitForChild("Gun"))
    UtilityModule = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"))
    pcall(function() EnumLibrary = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("EnumLibrary")) end)
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
    -- Lion Anti Katana deflect window
    if antiKatanaEnabled and _G.ShouldBlockShotForKatana and _G.ShouldBlockShotForKatana(player) then
        return true
    end
    return false
end

-- 히트박스 선택 매핑 함수
local function resolve_target_part(char, selectedPartName)
    if not char then return nil end
    local lowerName = string.lower(selectedPartName or "head")
    
    if lowerName == "head" then
        return char:FindFirstChild("Head") or char:FindFirstChild("HitboxHead") or char:FindFirstChild("HitboxHeadSmall")
    elseif lowerName == "humanoidrootpart" then
        return char:FindFirstChild("HumanoidRootPart")
    elseif lowerName == "torso" then
        return char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("LowerTorso") or char:FindFirstChild("HumanoidRootPart")
    end
    return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
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

local function is_player_scoping()
    local char = LocalPlayer.Character
    if not char then return false end
    local isScoping = LocalPlayer:GetAttribute("IsScoping") or LocalPlayer:GetAttribute("Zoomed") or LocalPlayer:GetAttribute("Aiming")
    if isScoping == true then return true end
    
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        local scopeVal = tool:GetAttribute("Zoomed") or tool:GetAttribute("Aiming")
        if scopeVal == true then return true end
    end
    return false
end

-- ============================================================================
-- FILE INTEGRATED RAGEBOT ENGINE (WITH HIDE & ATTACK TIMERS)
-- ============================================================================
local activeTargetPart = nil
local originalCFrame = nil
local originalVelocity = nil

local function restoreDesyncCFrame()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not originalCFrame then return end
    hrp.CFrame = originalCFrame
    if originalVelocity then hrp.AssemblyLinearVelocity = originalVelocity end
    originalCFrame = nil
    originalVelocity = nil
end

pcall(function() RunService:UnbindFromRenderStep("RestoreDesyncPerfect") end)
pcall(function() RunService:BindToRenderStep("RestoreDesyncPerfect", 0, restoreDesyncCFrame) end)
RunService.RenderStepped:Connect(restoreDesyncCFrame)

local function createTeleportPacket(originPos, targetPart)
    local targetPos = targetPart.Position
    local lookCF = CFrame.lookAt(originPos, targetPos)
    local rx, ry, rz = lookCF:ToOrientation()
    local posTable = {
        [utf8.char(0)] = originPos.X, [utf8.char(1)] = originPos.Y, [utf8.char(2)] = originPos.Z,
        [utf8.char(3)] = rx, [utf8.char(4)] = ry, [utf8.char(5)] = rz,
    }
    local relCF = targetPart.CFrame:ToObjectSpace(CFrame.new(targetPos))
    local rrx, rry, rrz = relCF:ToOrientation()
    return {
        [utf8.char(1)] = {
            [utf8.char(0)] = posTable,
            [utf8.char(1)] = posTable,
            [utf8.char(2)] = targetPart,
            [utf8.char(3)] = {
                [utf8.char(0)] = relCF.X, [utf8.char(1)] = relCF.Y, [utf8.char(2)] = relCF.Z,
                [utf8.char(3)] = rrx, [utf8.char(4)] = rry, [utf8.char(5)] = rrz,
            },
        },
    }
end

-- Ragebot Attack Loop (Attack Delay Controlled)
task.spawn(function()
    local useItemRemote = ReplicatedStorage:WaitForChild("Remotes", 5)
        and ReplicatedStorage.Remotes:WaitForChild("Replication", 5)
        and ReplicatedStorage.Remotes.Replication:WaitForChild("Fighter", 5)
        and ReplicatedStorage.Remotes.Replication.Fighter:WaitForChild("UseItem", 5)

    local startShootingEnum = nil
    pcall(function()
        if EnumLibrary then startShootingEnum = EnumLibrary:ToEnum("StartShooting") end
    end)

    local cachedObjectID = nil
    local function getEquippedObjectID()
        if FighterController and FighterController.LocalFighter and FighterController.LocalFighter.EquippedItem then
            local item = FighterController.LocalFighter.EquippedItem
            local ok, id = pcall(function() return item:Get("ObjectID") end)
            if ok and id then return id end
            if item.Data and item.Data.ObjectID then return item.Data.ObjectID end
        end
        return cachedObjectID
    end

    while true do
        task.wait(math.clamp(ragebotAttackDelay, 0.01, 1.0))
        if ragebotOrKillAura and activeTargetPart and activeTargetPart.Parent then
            local targetChar = activeTargetPart:FindFirstAncestorOfClass("Model") or activeTargetPart.Parent
            local targetPlayer = Players:GetPlayerFromCharacter(targetChar)
            if targetPlayer and targetPlayer ~= LocalPlayer and not is_teammate(targetPlayer) then
                if not get_character_immune(targetPlayer) and not is_reflecting_or_parrying(targetPlayer) then
                    -- Lion void: only shoot when exposed (or hyper)
                    local allowShoot = true
                    if ragebotMode == "Void" and not ragebotVoidExposed and not ragebotHyper then
                        allowShoot = false
                    end
                    if allowShoot then
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local objID = getEquippedObjectID()
                            if objID then cachedObjectID = objID else objID = cachedObjectID end
                            if objID and useItemRemote and startShootingEnum then
                                local shootOrigin = activeTargetPart.Position + Vector3.new(0, 0.1, 0)
                                local packet = createTeleportPacket(shootOrigin, activeTargetPart)
                                pcall(function()
                                    useItemRemote:FireServer(objID, startShootingEnum, packet, nil)
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Ragebot Hide / Mode Position Sync Loop (Lion modes: Orbit / Teleport / Void / Underground)
local function getRageDirs(targetRoot)
    local dirs = {}
    local look = targetRoot.CFrame.LookVector
    local right = targetRoot.CFrame.RightVector
    if ragebotDirBack then table.insert(dirs, -look) end
    if ragebotDirFront then table.insert(dirs, look) end
    if ragebotDirLeft then table.insert(dirs, -right) end
    if ragebotDirRight then table.insert(dirs, right) end
    if #dirs == 0 then
        dirs[1] = -look
        dirs[2] = right
        dirs[3] = -right
    end
    return dirs
end

local function pickRageOffset(targetRoot, head)
    local dirs = getRageDirs(targetRoot)
    local dir = dirs[math.random(1, #dirs)]
    local radius = math.clamp(ragebotOrbitDist or 3, 1.25, 8)
    local height = math.clamp(ragebotOrbitHeight or 2, -2, 8)
    local pos = head.Position + dir * radius + Vector3.new(0, height, 0)
    if ragebotDirUp and math.random() < 0.2 then
        pos = pos + Vector3.new(0, math.max(1, height), 0)
    elseif ragebotDirDown and math.random() < 0.15 then
        pos = pos + Vector3.new(0, -math.max(1, math.min(3, ragebotUndergroundDepth or 2)), 0)
    end
    return pos
end

RunService.Heartbeat:Connect(function(dt)
    pcall(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if originalCFrame then restoreDesyncCFrame() end

        if not (ragebotOrKillAura and activeTargetPart and activeTargetPart.Parent) then
            ragebotVoidExposed = false
            return
        end

        local targetChar = activeTargetPart:FindFirstAncestorOfClass("Model") or activeTargetPart.Parent
        local targetPlayer = Players:GetPlayerFromCharacter(targetChar)
        if targetPlayer and is_reflecting_or_parrying(targetPlayer) then return end

        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        local head = activeTargetPart
        if not targetRoot or not head then return end

        local now = tick()
        local mode = ragebotMode or "Orbit"
        local isUnderground = mode == "Underground"
        local targetPos

        if mode == "Underground" then
            local depth = math.clamp(ragebotUndergroundDepth or 6, 3, 12)
            local radius = math.clamp(ragebotOrbitDist or 3, 1.25, 6)
            targetPos = head.Position - targetRoot.CFrame.LookVector * radius + Vector3.new(0, -depth, 0)
        elseif mode == "Void" then
            -- cycle hide / expose like Lion void spam
            local cycle = (ragebotVoidHideTime or 0.25) + (ragebotVoidShootTime or 0.03)
            local phase = (now % math.max(0.05, cycle))
            if phase < (ragebotVoidHideTime or 0.25) then
                ragebotVoidExposed = false
                targetPos = head.Position + Vector3.new(0, -5000, 0) -- deep void hide
            else
                ragebotVoidExposed = true
                targetPos = pickRageOffset(targetRoot, head)
            end
        elseif mode == "Teleport" then
            targetPos = head.Position + Vector3.new(0, ragebotHeightOffset or 3, 0)
        else -- Orbit (default)
            targetPos = pickRageOffset(targetRoot, head)
            ragebotVoidExposed = true
        end

        originalCFrame = hrp.CFrame
        originalVelocity = hrp.AssemblyLinearVelocity

        local faceCF = CFrame.new(targetPos, head.Position)
        if ragebotAntiAimInRage then
            ragebotAaPhase = ragebotAaPhase + (dt or 0.016) * 20
            faceCF = CFrame.new(targetPos, head.Position) * CFrame.Angles(0, math.rad(math.sin(ragebotAaPhase) * 70), 0)
        end

        if mode == "Void" and not ragebotVoidExposed then
            hrp.CFrame = faceCF
            return
        end

        if mode == "Teleport" then
            if now >= (ragebotNextTeleportAt or 0) then
                ragebotNextTeleportAt = now + math.max(0.01, ragebotTeleportDelay or 0.04)
                hrp.CFrame = faceCF
            end
        else
            hrp.CFrame = faceCF
        end
    end)
end)

-- Target Finder Loop (Hide Interval Supported)
task.spawn(function()
    while true do
        task.wait(math.clamp(ragebotHideDelay, 0.01, 1.0))
        if ragebotOrKillAura then
            local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.zero
            local closestPlayer = nil
            local closestDist = math.huge

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and not is_teammate(player) then
                    if get_character_immune(player) or is_reflecting_or_parrying(player) then continue end
                    local root = player.Character:FindFirstChild("HumanoidRootPart")
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    if root and hum and hum.Health > 0 then
                        local dist = (Vector3.new(myPos.X, 0, myPos.Z) - Vector3.new(root.Position.X, 0, root.Position.Z)).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closestPlayer = player
                        end
                    end
                end
            end

            if closestPlayer and closestPlayer.Character then
                activeTargetPart = get_character_root(closestPlayer.Character)
            else
                activeTargetPart = nil
            end
        else
            activeTargetPart = nil
        end
    end
end)

-- Baiting, Orbit, Void Spam Loops
task.spawn(function()
    while true do
        task.wait(0.01)
        if ffModeEnabled and ffBaitingEnabled then
            pcall(function()
                local myChar = LocalPlayer.Character
                local hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and not is_teammate(player) and player.Character then
                            local pRoot = player.Character:FindFirstChild("HumanoidRootPart")
                            if pRoot then
                                local dist = (hrp.Position - pRoot.Position).Magnitude
                                if dist < 25 then
                                    local baitVector = (hrp.Position - pRoot.Position).Unit * -2
                                    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(baitVector.X * 5, -10, baitVector.Z * 5)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ============================================================================
-- SECTION: Orbit & Void Spam (nexlib open-source — full stud radius + height lock)
-- Orbit: random unit vector * orbitRange around locked anchor (desync restore each frame)
-- Void Spam: lock HRP Y to voidSpamRange (height lock)
-- ============================================================================
local orbitOrigCF = nil
local orbitOrigVel = nil

local function restoreOrbitDesync()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not orbitOrigCF then return end
    hrp.CFrame = orbitOrigCF
    if orbitOrigVel then hrp.AssemblyLinearVelocity = orbitOrigVel end
    orbitOrigCF = nil
    orbitOrigVel = nil
end

-- Restore after server sees fake position (same pattern as ragebot desync)
pcall(function()
    RunService:BindToRenderStep("vallkOrbitRestore", Enum.RenderPriority.Last.Value, restoreOrbitDesync)
end)
RunService.RenderStepped:Connect(function()
    if orbitOrigCF then restoreOrbitDesync() end
end)

-- Anchor tracker (nexlib a39b72c33)
task.spawn(function()
    while true do
        task.wait(0.05)
        if orbitEnabled then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and not orbitAnchorPos then
                orbitAnchorPos = hrp.Position
            end
        else
            orbitAnchorPos = nil
        end
    end
end)

-- Orbit loop: nexlib flyEnabled logic
task.spawn(function()
    while true do
        task.wait(math.clamp(orbitDelay, 0.01, 1))
        if not orbitEnabled then continue end
        pcall(function()
            -- skip if ragebot already owns desync this frame
            if ragebotOrKillAura and activeTargetPart then return end
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            if not orbitAnchorPos then
                orbitAnchorPos = hrp.Position
            end
            orbitOrigCF = hrp.CFrame
            orbitOrigVel = hrp.AssemblyLinearVelocity
            local range = math.clamp(tonumber(orbitRange) or 50000000, 5, 50000000)
            local dir = Vector3.new(
                math.random(-100, 100),
                math.random(-100, 100),
                math.random(-100, 100)
            )
            if dir.Magnitude < 0.001 then dir = Vector3.new(1, 0, 0) end
            dir = dir.Unit
            local targetPos = orbitAnchorPos + dir * range
            local rotOnly = orbitOrigCF - orbitOrigCF.Position
            hrp.CFrame = CFrame.new(targetPos) * rotOnly
        end)
    end
end)

-- Void Spam loop: nexlib heightLockEnabled logic (lock Y)
task.spawn(function()
    while true do
        task.wait(math.clamp(voidSpamDelay, 0.01, 1))
        if not voidSpamEnabled then continue end
        pcall(function()
            if orbitEnabled then return end  -- orbit takes priority (nexlib: if flyEnabled return)
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local y = tonumber(voidSpamRange) or 50
            hrp.CFrame = CFrame.new(hrp.Position.X, y, hrp.Position.Z)
        end)
    end
end)

-- Also apply height lock on Heartbeat for smoother lock (nexlib Stepped pattern)
RunService.Heartbeat:Connect(function()
    if not voidSpamEnabled or orbitEnabled then return end
    pcall(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local y = tonumber(voidSpamRange) or 50
        if math.abs(hrp.Position.Y - y) > 0.5 then
            hrp.CFrame = CFrame.new(hrp.Position.X, y, hrp.Position.Z)
        end
    end)
end)

-- ============================================================================
-- SECTION: Hit Logs & Sound Integration (multvallk)
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

local function addHitLog(targetName, damage)
    playHitSound() -- Hit Sound Triggers Here!

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
                local dmg = lastHealth - newHealth
                if dmg > 0.05 then
                    addHitLog(player.Name, dmg)
                end
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

-- Extra reliable hit sound: hook FighterController damage number (Lion-style)
task.spawn(function()
    task.wait(1.5)
    pcall(function()
        local okFC, fc = pcall(function()
            return require(LocalPlayer.PlayerScripts.Controllers.FighterController)
        end)
        if not okFC or not fc then return end
        local fighter = fc.LocalFighter or (type(fc.GetFighter) == "function" and fc:GetFighter(LocalPlayer))
        if not fighter then return end
        local mt = getmetatable(fighter)
        local cls = mt and mt.__index
        if type(cls) ~= "table" or type(cls._DamageNumberEffect) ~= "function" then return end
        if cls._vallkHitSoundHooked then return end
        local original = cls._DamageNumberEffect
        cls._DamageNumberEffect = function(...)
            if hitSoundEnabled then
                pcall(playHitSound)
            end
            return original(...)
        end
        cls._vallkHitSoundHooked = true
    end)

    -- also try ItemInterface DamageEffect
    pcall(function()
        local itemInterface = require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ItemInterface)
        if type(itemInterface) == "table" and type(itemInterface.DamageEffect) == "function" then
            if itemInterface._vallkHitSoundHooked then return end
            local orig = itemInterface.DamageEffect
            itemInterface.DamageEffect = function(...)
                if hitSoundEnabled then pcall(playHitSound) end
                return orig(...)
            end
            itemInterface._vallkHitSoundHooked = true
        end
    end)
end)

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

-- ============================================================================
-- SECTION: Unlock All Skins (Lion open-source CosmeticInventory spoof)
-- Spoofs ownership of every cosmetic in CosmeticLibrary.Cosmetics
-- ============================================================================
pcall(function()
    local CosmeticLibrary = require(ReplicatedStorage.Modules:WaitForChild("CosmeticLibrary", 5))
    local DataController = require(LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController", 5))
    local EnumLibrary = nil
    pcall(function()
        EnumLibrary = require(ReplicatedStorage.Modules:WaitForChild("EnumLibrary", 5))
    end)

    local cosmeticsTable = CosmeticLibrary.Cosmetics or {}

    local function makeCosmeticEntry(name, data)
        local entry = {
            Name = name,
            Unlocked = true,
            Amount = 1,
            Count = 1,
        }
        if type(data) == "table" then
            for k, v in pairs(data) do
                if entry[k] == nil then entry[k] = v end
            end
        end
        pcall(function()
            if EnumLibrary and EnumLibrary.ToEnum then
                local eid = EnumLibrary:ToEnum(name)
                if eid then
                    entry.Enum = eid
                    entry.ObjectID = entry.ObjectID or eid
                end
            end
        end)
        return entry
    end

    local function buildFullInventory(base)
        local proxy = {}
        if type(base) == "table" then
            for k, v in pairs(base) do
                proxy[k] = v
            end
        end
        for name, data in pairs(cosmeticsTable) do
            if type(name) == "string" and name ~= "" then
                if proxy[name] == nil or type(proxy[name]) == "boolean" then
                    proxy[name] = makeCosmeticEntry(name, data)
                elseif type(proxy[name]) == "table" then
                    proxy[name].Unlocked = true
                    proxy[name].Amount = math.max(1, tonumber(proxy[name].Amount) or 1)
                    proxy[name].Count = math.max(1, tonumber(proxy[name].Count) or 1)
                end
            end
        end
        return setmetatable(proxy, {
            __index = function(_, key)
                if type(key) == "string" and key ~= "" then
                    local d = cosmeticsTable[key]
                    return makeCosmeticEntry(key, d)
                end
                return true
            end
        })
    end

    -- OwnsCosmetic family (Lion-style always true when enabled)
    local function forceOwn(...)
        if skinChangerEnabled then return true end
        return false
    end

    if type(CosmeticLibrary.OwnsCosmetic) == "function" then
        local originalOwns = CosmeticLibrary.OwnsCosmetic
        CosmeticLibrary.OwnsCosmetic = function(self, inv, name, wpn)
            if skinChangerEnabled then return true end
            return originalOwns(self, inv, name, wpn)
        end
    end
    for _, fnName in ipairs({
        "OwnsCosmeticNormally", "OwnsCosmeticUniversally", "OwnsCosmeticForWeapon",
        "Owns", "HasCosmetic", "IsOwned", "PlayerOwnsCosmetic"
    }) do
        if type(CosmeticLibrary[fnName]) == "function" then
            local orig = CosmeticLibrary[fnName]
            CosmeticLibrary[fnName] = function(...)
                if skinChangerEnabled then return true end
                return orig(...)
            end
        else
            CosmeticLibrary[fnName] = function(...)
                if skinChangerEnabled then return true end
                return false
            end
        end
    end

    -- DataController.Get: inject full CosmeticInventory (Lion rebuildinv pattern)
    local originalGet = DataController.Get
    DataController.Get = function(self, key)
        local data = originalGet(self, key)
        if skinChangerEnabled and key == "CosmeticInventory" then
            return buildFullInventory(data)
        end
        if skinChangerEnabled and key == "FavoritedCosmetics" then
            return data or {}
        end
        return data
    end

    -- Optional: GetWeaponData pass-through stays real (equip is separate)
    if type(DataController.GetWeaponData) == "function" then
        local originalGetWep = DataController.GetWeaponData
        DataController.GetWeaponData = function(self, wname)
            return originalGetWep(self, wname)
        end
    end

    -- When toggle flips on, try to replicate inventory so UI refreshes
    local function refreshCosmeticInventory()
        if not skinChangerEnabled then return end
        pcall(function()
            local cdata = DataController.CurrentData
            if cdata and cdata.Replicate then
                cdata:Replicate("CosmeticInventory")
                pcall(function() cdata:Replicate("WeaponInventory") end)
            end
        end)
    end

    -- expose for toggle
    _G.vallkRefreshAllSkins = refreshCosmeticInventory
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

local circleFill = Drawing.new("Circle")
circleFill.Thickness = 0
circleFill.NumSides = 64
circleFill.Filled = true
circleFill.Transparency = 1.0
circleFill.Visible = false

for i = 1, SEGMENT_COUNT do
    local line = Drawing.new("Line")
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
    ["Afternoon"] = { SkyboxBk = "rbxassetid://600830446", SkyboxDn = "rbxassetid://600831635", SkyboxFt = "rbxassetid://600832720", SkyboxLf = "rbxassetid://600886090", SkyboxRt = "rbxassetid://600833862", SkyboxUp = "rbxassetid://600835177" },
    ["Blue Space"] = { SkyboxBk = "rbxassetid://149397692", SkyboxDn = "rbxassetid://149397686", SkyboxFt = "rbxassetid://149397697", SkyboxLf = "rbxassetid://149397684", SkyboxRt = "rbxassetid://149397688", SkyboxUp = "rbxassetid://149397702" },
    ["Classic Roblox"] = { SkyboxBk = "rbxassetid://1012890", SkyboxDn = "rbxassetid://1012891", SkyboxFt = "rbxassetid://1012887", SkyboxLf = "rbxassetid://1012889", SkyboxRt = "rbxassetid://1012888", SkyboxUp = "rbxassetid://1014449" },
    ["Cloudy"] = { SkyboxBk = "rbxassetid://591058823", SkyboxDn = "rbxassetid://591059876", SkyboxFt = "rbxassetid://591058104", SkyboxLf = "rbxassetid://591057861", SkyboxRt = "rbxassetid://591057625", SkyboxUp = "rbxassetid://591059642" },
    ["Dusk"] = { SkyboxBk = "rbxassetid://264908339", SkyboxDn = "rbxassetid://264907909", SkyboxFt = "rbxassetid://264909420", SkyboxLf = "rbxassetid://264909758", SkyboxRt = "rbxassetid://264908886", SkyboxUp = "rbxassetid://264907379" },
    ["Dawn"] = { SkyboxBk = "rbxassetid://1417494030", SkyboxDn = "rbxassetid://1417494146", SkyboxFt = "rbxassetid://1417494253", SkyboxLf = "rbxassetid://1417494402", SkyboxRt = "rbxassetid://1417494499", SkyboxUp = "rbxassetid://1417494643" },
    ["Dark Skies"] = { SkyboxBk = "rbxassetid://570557514", SkyboxDn = "rbxassetid://570557775", SkyboxFt = "rbxassetid://570557559", SkyboxLf = "rbxassetid://570557620", SkyboxRt = "rbxassetid://570557672", SkyboxUp = "rbxassetid://570557727" },
    ["Earth"] = { SkyboxBk = "rbxassetid://6444884337", SkyboxDn = "rbxassetid://6444884785", SkyboxFt = "rbxassetid://6444884337", SkyboxLf = "rbxassetid://6444884785", SkyboxRt = "rbxassetid://6444884337", SkyboxUp = "rbxassetid://6444884785" },
    ["Horizontal Milky Way"] = { SkyboxBk = "rbxassetid://159454299", SkyboxDn = "rbxassetid://159454296", SkyboxFt = "rbxassetid://159454293", SkyboxLf = "rbxassetid://159454286", SkyboxRt = "rbxassetid://159454300", SkyboxUp = "rbxassetid://159454288" },
    ["Heaven"] = { SkyboxBk = "rbxassetid://591058823", SkyboxDn = "rbxassetid://591059642", SkyboxFt = "rbxassetid://591059876", SkyboxLf = "rbxassetid://591057625", SkyboxRt = "rbxassetid://591057861", SkyboxUp = "rbxassetid://591058104" },
    ["Jungle"] = { SkyboxBk = "rbxassetid://214253616", SkyboxDn = "rbxassetid://214253616", SkyboxFt = "rbxassetid://214253616", SkyboxLf = "rbxassetid://214253616", SkyboxRt = "rbxassetid://214253616", SkyboxUp = "rbxassetid://214253616" },
    ["Mountains"] = { SkyboxBk = "rbxassetid://452457785", SkyboxDn = "rbxassetid://452457806", SkyboxFt = "rbxassetid://452457839", SkyboxLf = "rbxassetid://452457866", SkyboxRt = "rbxassetid://452457896", SkyboxUp = "rbxassetid://452457928" },
    ["Nebula"] = { SkyboxBk = "rbxassetid://149397697", SkyboxDn = "rbxassetid://149397702", SkyboxFt = "rbxassetid://149397692", SkyboxLf = "rbxassetid://149397688", SkyboxRt = "rbxassetid://149397684", SkyboxUp = "rbxassetid://149397686" },
    ["Night Light"] = { SkyboxBk = "rbxassetid://12064107", SkyboxDn = "rbxassetid://12064152", SkyboxFt = "rbxassetid://12064121", SkyboxLf = "rbxassetid://12063984", SkyboxRt = "rbxassetid://12064115", SkyboxUp = "rbxassetid://12064131" },
    ["Night"] = { SkyboxBk = "rbxassetid://12064121", SkyboxDn = "rbxassetid://12064152", SkyboxFt = "rbxassetid://12064107", SkyboxLf = "rbxassetid://12064115", SkyboxRt = "rbxassetid://12063984", SkyboxUp = "rbxassetid://12064131" },
    ["Ocean Sky"] = { SkyboxBk = "rbxassetid://150335574", SkyboxDn = "rbxassetid://150335585", SkyboxFt = "rbxassetid://150335628", SkyboxLf = "rbxassetid://150335620", SkyboxRt = "rbxassetid://150335610", SkyboxUp = "rbxassetid://150335642" },
    ["Redshift"] = { SkyboxBk = "rbxassetid://401664839", SkyboxDn = "rbxassetid://401664862", SkyboxFt = "rbxassetid://401664960", SkyboxLf = "rbxassetid://401664881", SkyboxRt = "rbxassetid://401664901", SkyboxUp = "rbxassetid://401664936" },
    ["Space"] = { SkyboxBk = "rbxassetid://149397684", SkyboxDn = "rbxassetid://149397686", SkyboxFt = "rbxassetid://149397688", SkyboxLf = "rbxassetid://149397692", SkyboxRt = "rbxassetid://149397697", SkyboxUp = "rbxassetid://149397702" },
    ["Sunset"] = { SkyboxBk = "rbxassetid://264909420", SkyboxDn = "rbxassetid://264907909", SkyboxFt = "rbxassetid://264908339", SkyboxLf = "rbxassetid://264908886", SkyboxRt = "rbxassetid://264909758", SkyboxUp = "rbxassetid://264907379" },
    ["Storm"] = { SkyboxBk = "rbxassetid://570557514", SkyboxDn = "rbxassetid://570557775", SkyboxFt = "rbxassetid://570557559", SkyboxLf = "rbxassetid://570557620", SkyboxRt = "rbxassetid://570557672", SkyboxUp = "rbxassetid://570557727" },
    ["SFOTH"] = { SkyboxBk = "rbxassetid://1012887", SkyboxDn = "rbxassetid://1012891", SkyboxFt = "rbxassetid://1012890", SkyboxLf = "rbxassetid://1012888", SkyboxRt = "rbxassetid://1012889", SkyboxUp = "rbxassetid://1014449" },
    ["Solid Black"] = { SkyboxBk = "", SkyboxDn = "", SkyboxFt = "", SkyboxLf = "", SkyboxRt = "", SkyboxUp = "" },
    ["Saturn"] = { SkyboxBk = "rbxassetid://149397688", SkyboxDn = "rbxassetid://149397686", SkyboxFt = "rbxassetid://149397684", SkyboxLf = "rbxassetid://149397692", SkyboxRt = "rbxassetid://149397702", SkyboxUp = "rbxassetid://149397697" },
    ["Smoke"] = { SkyboxBk = "rbxassetid://570557672", SkyboxDn = "rbxassetid://570557514", SkyboxFt = "rbxassetid://570557727", SkyboxLf = "rbxassetid://570557559", SkyboxRt = "rbxassetid://570557775", SkyboxUp = "rbxassetid://570557620" },
    ["Vertical Milky Way"] = { SkyboxBk = "rbxassetid://159454286", SkyboxDn = "rbxassetid://159454288", SkyboxFt = "rbxassetid://159454299", SkyboxLf = "rbxassetid://159454300", SkyboxRt = "rbxassetid://159454296", SkyboxUp = "rbxassetid://159454293" },
    ["White"] = { SkyboxBk = "", SkyboxDn = "", SkyboxFt = "", SkyboxLf = "", SkyboxRt = "", SkyboxUp = "" },
    ["Dark Sky"] = { SkyboxBk = "rbxassetid://570555736", SkyboxDn = "rbxassetid://570555964", SkyboxFt = "rbxassetid://570555800", SkyboxLf = "rbxassetid://570555840", SkyboxRt = "rbxassetid://570555882", SkyboxUp = "rbxassetid://570555929" },
    ["Vaporwave"] = { SkyboxBk = "rbxassetid://1417494030", SkyboxDn = "rbxassetid://1417494146", SkyboxFt = "rbxassetid://1417494253", SkyboxLf = "rbxassetid://1417494402", SkyboxRt = "rbxassetid://1417494499", SkyboxUp = "rbxassetid://1417494643" },
    ["Lake Sky"] = { SkyboxBk = "rbxassetid://6823523318", SkyboxDn = "rbxassetid://6823525702", SkyboxFt = "rbxassetid://6823482923", SkyboxLf = "rbxassetid://6823530023", SkyboxRt = "rbxassetid://6823531746", SkyboxUp = "rbxassetid://6823528533" },
    ["Black Mesa"] = { SkyboxBk = "rbxassetid://9569742122", SkyboxDn = "rbxassetid://9569613307", SkyboxFt = "rbxassetid://9569611418", SkyboxLf = "rbxassetid://9569608166", SkyboxRt = "rbxassetid://9569601267", SkyboxUp = "rbxassetid://9569598752" },
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

    -- FOV Drawing UI 연동
    if aimbotDrawFov and aimbotEnabled then
        aimbotFovCircle.Position = mousePos
        aimbotFovCircle.Radius = aimbotFovRadius
        aimbotFovCircle.Visible = true
    else
        aimbotFovCircle.Visible = false
    end

    if silentAimDrawFov and silentAimEnabled then
        silentFovCircle.Position = mousePos
        silentFovCircle.Radius = silentAimFovRadius
        silentFovCircle.Visible = true
    else
        silentFovCircle.Visible = false
    end

    if circleCrosshairEnabled then
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

    -- ESP (Box / Name / Health / Tracer) — Lion-style Drawing ESP
    pcall(updateESP)

    -- Scope Look 체크
    local canAimByScope = not aimbotScopeLook or is_player_scoping()

    if aimbotEnabled and myChar and canAimByScope then
        local closestTarget = nil
        local closestDist = math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not is_teammate(player) and not get_character_immune(player) and not is_reflecting_or_parrying(player) then
                local hitPart = resolve_target_part(player.Character, aimbotHitPart)
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
                local hitPart = ragebotOrKillAura and get_character_root(player.Character) or resolve_target_part(player.Character, silentAimHitPart)
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

-- Theme Color System (from nexlib Theme Color dropdown)
local selectedThemeColor = "Sky Blue"
local themeColors = {
    ["Sky Blue"]   = Color3.fromRGB(128, 213, 247),
    ["Red"]        = Color3.fromRGB(255, 75, 75),
    ["Lime Green"] = Color3.fromRGB(75, 255, 75),
    ["Purple"]     = Color3.fromRGB(180, 75, 255),
    ["Orange"]     = Color3.fromRGB(255, 140, 0),
}

local function applyThemeColor(name)
    if themeColors[name] then
        selectedThemeColor = name
        valkLib.accentclr = themeColors[name]
    end
end

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

-- HALMU VALK Main Frame Construction
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = MainGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 480, 0, 560)
MainFrame.Visible = true
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
TopBarTitle.Text = "vallkmult Premium v3 (No Key)"
TopBarTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
TopBarTitle.TextSize = 15
TopBarTitle.TextXAlignment = Enum.TextXAlignment.Left

local TopBarLine = Instance.new("Frame", TopBar)
TopBarLine.BackgroundColor3 = valkLib.accentclr
TopBarLine.BorderSizePixel = 0
TopBarLine.Position = UDim2.new(0, 0, 0, 27)
TopBarLine.Size = UDim2.new(1, 0, 0, 1)


-- Close X button removed (open/close via "vallkmult UI" button + RightShift only)
make_draggable(TopBar, MainFrame)

local ContainerHolder = Instance.new("Frame", MainFrame)
ContainerHolder.Name = "ContainerHolderFrame"
ContainerHolder.AnchorPoint = Vector2.new(0.5, 0)
ContainerHolder.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
ContainerHolder.Position = UDim2.new(0.5, 0, 0, 35)
ContainerHolder.Size = UDim2.new(1, -12, 1, -42)
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
TabPadding.PaddingLeft = UDim.new(0, 3)

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
    
    local txtSize = TextService:GetTextSize(tabName, 13, Enum.Font.Code, Vector2.new(500, 500))
    btn.Size = UDim2.new(0, txtSize.X + 22, 0, 26)
    
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

            RunService.RenderStepped:Connect(refreshToggleUI)
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
            -- live accent color for slider fill
            RunService.RenderStepped:Connect(function()
                barFill.BackgroundColor3 = valkLib.accentclr
            end)
            updateSize()
        end

        return secObj
    end

    return tabObj
end

-- Toggle Menu Button
local ToggleBtn = Instance.new("TextButton", MainGui)
ToggleBtn.Size = UDim2.fromOffset(100, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.TextColor3 = valkLib.accentclr
ToggleBtn.Font = Enum.Font.Code
ToggleBtn.TextSize = 11
ToggleBtn.Text = "vallkmult UI"
ToggleBtn.BorderSizePixel = 0

local TogOutline = Instance.new("ImageLabel", ToggleBtn)
TogOutline.BackgroundTransparency = 1
TogOutline.Size = UDim2.new(1, 0, 1, 0)
TogOutline.Image = "rbxassetid://2592362371"
TogOutline.ImageColor3 = valkLib.accentclr
TogOutline.ScaleType = Enum.ScaleType.Slice
TogOutline.SliceCenter = Rect.new(2, 2, 62, 62)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

UserInputService.InputBegan:Connect(function(input, g)
    if g then return end
    if input.KeyCode == Enum.KeyCode.RightShift then 
        MainFrame.Visible = not MainFrame.Visible 
    end
end)

-- Live Theme Color accent refresh (TopBarLine, ToggleBtn, tab indicators)
task.spawn(function()
    while true do
        task.wait(0.05)
        pcall(function()
            if TopBarLine then TopBarLine.BackgroundColor3 = valkLib.accentclr end
            if ToggleBtn then ToggleBtn.TextColor3 = valkLib.accentclr end
            if TogOutline then TogOutline.ImageColor3 = valkLib.accentclr end
            -- update all tab top-line indicators that are visible
            for _, entry in pairs(tabEntries) do
                if entry and entry.topLine and entry.topLine.Visible then
                    entry.topLine.BackgroundColor3 = valkLib.accentclr
                end
            end
        end)
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

-- Main Tab Options (Aimbot & Hitbox Configuration)
local mSec1 = MainTab:Section("Aimbot Settings", 1)
mSec1:Toggle("Mobile Mode UI", function() return mobileOnEnabled end, function(v) mobileOnEnabled = v; updateMobileSize() end)
mSec1:Toggle("Aimbot (Smooth Camera)", function() return aimbotEnabled end, function(v) aimbotEnabled = v end)
mSec1:Slider("Aimbot Smoothness", 1, 20, function() return aimbotSmoothness end, function(v) aimbotSmoothness = v end)
mSec1:Slider("Aimbot FOV", 10, 500, function() return aimbotFovRadius end, function(v) aimbotFovRadius = v end)
mSec1:Toggle("Aimbot Draw FOV", function() return aimbotDrawFov end, function(v) aimbotDrawFov = v end)
mSec1:Toggle("Aimbot Wall Check", function() return aimbotWallCheck end, function(v) aimbotWallCheck = v end)
mSec1:Toggle("Aimbot Scope Look", function() return aimbotScopeLook end, function(v) aimbotScopeLook = v end)
mSec1:Toggle("Aimbot Hitbox: Head", function() return aimbotHitPart == "head" end, function(v) if v then aimbotHitPart = "head" end end)
mSec1:Toggle("Aimbot Hitbox: RootPart", function() return aimbotHitPart == "humanoidrootpart" end, function(v) if v then aimbotHitPart = "humanoidrootpart" end end)
mSec1:Toggle("Aimbot Hitbox: Torso", function() return aimbotHitPart == "torso" end, function(v) if v then aimbotHitPart = "torso" end end)

local mSec2 = MainTab:Section("Gun & Silent Aim", 2)
mSec2:Toggle("Silent Aim", function() return silentAimEnabled end, function(v) silentAimEnabled = v end)
mSec2:Slider("Silent FOV", 10, 500, function() return silentAimFovRadius end, function(v) silentAimFovRadius = v end)
mSec2:Toggle("Silent Draw FOV", function() return silentAimDrawFov end, function(v) silentAimDrawFov = v end)
mSec2:Toggle("Silent Wall Check", function() return silentWallCheck end, function(v) silentWallCheck = v end)
mSec2:Toggle("Silent Hitbox: Head", function() return silentAimHitPart == "head" end, function(v) if v then silentAimHitPart = "head" end end)
mSec2:Toggle("Silent Hitbox: RootPart", function() return silentAimHitPart == "humanoidrootpart" end, function(v) if v then silentAimHitPart = "humanoidrootpart" end end)
mSec2:Toggle("Silent Hitbox: Torso", function() return silentAimHitPart == "torso" end, function(v) if v then silentAimHitPart = "torso" end end)

mSec2:Toggle("Fast Melee", function() return fastMeleeEnabled end, function(v) fastMeleeEnabled = v end)
mSec2:Toggle("No Cooldown", function() return hoNyangNoCDEnabled end, function(v) hoNyangNoCDEnabled = v end)
mSec2:Toggle("No Recoil", function() return noRecoilEnabled end, function(v) noRecoilEnabled = v end)
mSec2:Toggle("No Spread", function() return noSpreadEnabled end, function(v) noSpreadEnabled = v end)
mSec2:Toggle("No Muzzle Flash", function() return noMuzzleFlashEnabled end, function(v) noMuzzleFlashEnabled = v end)
mSec2:Toggle("Rapid Fire", function() return rapidFireEnabled end, function(v) rapidFireEnabled = v end)

-- Ragebot Tab Options (Lion open-source modes + original)
local rSec1 = RageTab:Section("Rage Engine", 1)
rSec1:Toggle("vallkmult ragebot", function() return ragebotOrKillAura end, function(v) ragebotOrKillAura = v end)
rSec1:Slider("Hide Delay", 0.01, 1.0, function() return ragebotHideDelay end, function(v) ragebotHideDelay = v end)
rSec1:Slider("Attack Delay", 0.01, 1.0, function() return ragebotAttackDelay end, function(v) ragebotAttackDelay = v end)
rSec1:Slider("Height Offset", 0, 10, function() return ragebotHeightOffset end, function(v) ragebotHeightOffset = v end)

rSec1:Toggle("Mode: Orbit", function() return ragebotMode == "Orbit" end, function(v) if v then ragebotMode = "Orbit" end end)
rSec1:Toggle("Mode: Teleport", function() return ragebotMode == "Teleport" end, function(v) if v then ragebotMode = "Teleport" end end)
rSec1:Toggle("Mode: Void", function() return ragebotMode == "Void" end, function(v) if v then ragebotMode = "Void" end end)
rSec1:Toggle("Mode: Underground", function() return ragebotMode == "Underground" end, function(v) if v then ragebotMode = "Underground" end end)
rSec1:Toggle("Hyper (always shoot)", function() return ragebotHyper end, function(v) ragebotHyper = v end)
rSec1:Toggle("Anti Aim in Rage", function() return ragebotAntiAimInRage end, function(v) ragebotAntiAimInRage = v end)

local rSecModes = RageTab:Section("Lion Orbit / Void", 2)
rSecModes:Slider("Orbit Dist", 1, 8, function() return ragebotOrbitDist end, function(v) ragebotOrbitDist = v end)
rSecModes:Slider("Orbit Height", -2, 8, function() return ragebotOrbitHeight end, function(v) ragebotOrbitHeight = v end)
rSecModes:Slider("Teleport Delay", 0.01, 0.5, function() return ragebotTeleportDelay end, function(v) ragebotTeleportDelay = v end)
rSecModes:Slider("Underground Depth", 3, 12, function() return ragebotUndergroundDepth end, function(v) ragebotUndergroundDepth = v end)
rSecModes:Slider("Void Hide Time", 0.05, 1.0, function() return ragebotVoidHideTime end, function(v) ragebotVoidHideTime = v end)
rSecModes:Slider("Void Shoot Time", 0.01, 0.5, function() return ragebotVoidShootTime end, function(v) ragebotVoidShootTime = v end)
rSecModes:Toggle("Dir: Back", function() return ragebotDirBack end, function(v) ragebotDirBack = v end)
rSecModes:Toggle("Dir: Front", function() return ragebotDirFront end, function(v) ragebotDirFront = v end)
rSecModes:Toggle("Dir: Left", function() return ragebotDirLeft end, function(v) ragebotDirLeft = v end)
rSecModes:Toggle("Dir: Right", function() return ragebotDirRight end, function(v) ragebotDirRight = v end)
rSecModes:Toggle("Dir: Up", function() return ragebotDirUp end, function(v) ragebotDirUp = v end)
rSecModes:Toggle("Dir: Down", function() return ragebotDirDown end, function(v) ragebotDirDown = v end)

local rSec2 = RageTab:Section("Extra Orbit & Void Spam (nexlib)", 2)
rSec2:Toggle("Orbit (nexlib)", function() return orbitEnabled end, function(v)
    orbitEnabled = v
    if not v then orbitAnchorPos = nil end
end)
rSec2:Slider("Orbit Studs", 5, 50000000, function() return orbitRange end, function(v) orbitRange = v end)
rSec2:Slider("Orbit Delay", 0.01, 1, function() return orbitDelay end, function(v) orbitDelay = v end)
rSec2:Toggle("Void Spam (Height Lock)", function() return voidSpamEnabled end, function(v) voidSpamEnabled = v end)
rSec2:Slider("Void Spam Y / Studs", 50, 50000000, function() return voidSpamRange end, function(v) voidSpamRange = v end)
rSec2:Slider("Void Delay", 0.01, 1, function() return voidSpamDelay end, function(v) voidSpamDelay = v end)

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
espSec:Toggle("ESP Distance", function() return espDistanceEnabled end, function(v) espDistanceEnabled = v end)
espSec:Toggle("ESP Health", function() return espHealthEnabled end, function(v) espHealthEnabled = v end)
espSec:Toggle("ESP Skeleton", function() return espSkeletonEnabled end, function(v) espSkeletonEnabled = v end)
espSec:Toggle("Gun Tracer Line", function() return gunTracerEnabled end, function(v) gunTracerEnabled = v end)

-- Misc Tab Options
local miscSec = MiscTab:Section("Movement & Mods", 1)
miscSec:Toggle("Mobile Fly (Touch)", function() return mobileFlyEnabled end, function(v) mobileFlyEnabled = v end)
miscSec:Toggle("PC Fly (WASD)", function() return pcFlyEnabled end, function(v) pcFlyEnabled = v end)
miscSec:Toggle("Unlock All Skins", function() return skinChangerEnabled end, function(v)
    skinChangerEnabled = v
    if v and _G.vallkRefreshAllSkins then
        pcall(_G.vallkRefreshAllSkins)
    end
end)
miscSec:Toggle("Bullet Speed Boost", function() return bulletSpeedBoost end, function(v) bulletSpeedBoost = v end)
miscSec:Toggle("Rapid Speed Hack", function() return rapidSpeedEnabled end, function(v) rapidSpeedEnabled = v end)
miscSec:Toggle("Noclip", function() return noclipEnabled end, function(v) noclipEnabled = v end)

local spooferSec = MiscTab:Section("Device Spoofer", 2)
spooferSec:Toggle("Enable Device Spoofer", function() return deviceSpooferEnabled end, function(v)
    deviceSpooferEnabled = v
    if v then fireDeviceSetControls() end
end)
-- device selection (nexlib open-source options: vr / touch / gamepad / mousekeyboard)
spooferSec:Toggle("Device: VR", function() return spoofedDeviceMode == "VR" end, function(v)
    if v then
        spoofedDeviceMode = normalizeDeviceMode("vr")
        if deviceSpooferEnabled then fireDeviceSetControls() end
    end
end)
spooferSec:Toggle("Device: Touch", function() return spoofedDeviceMode == "Touch" end, function(v)
    if v then
        spoofedDeviceMode = normalizeDeviceMode("touch")
        if deviceSpooferEnabled then fireDeviceSetControls() end
    end
end)
spooferSec:Toggle("Device: Gamepad", function() return spoofedDeviceMode == "Gamepad" end, function(v)
    if v then
        spoofedDeviceMode = normalizeDeviceMode("gamepad")
        if deviceSpooferEnabled then fireDeviceSetControls() end
    end
end)
spooferSec:Toggle("Device: MouseKeyboard", function() return spoofedDeviceMode == "MouseKeyboard" end, function(v)
    if v then
        spoofedDeviceMode = normalizeDeviceMode("mousekeyboard")
        if deviceSpooferEnabled then fireDeviceSetControls() end
    end
end)

-- Anti Aim section in Misc (full function from Lion)
local antiAimSec = MiscTab:Section("Anti Aim", 1)
antiAimSec:Toggle("Enable Anti Aim", function() return antiAimEnabled end, function(v)
    setAntiAimEnabled(v)
end)

antiAimSec:Toggle("Pitch: disabled", function() return antiAimPitchMode == "disabled" end, function(v)
    if v then
        antiAimPitchMode = "disabled"
        if _G.AntiAimPoseConfig then _G.AntiAimPoseConfig.pitch = "disabled" end
    end
end)
antiAimSec:Toggle("Pitch: up", function() return antiAimPitchMode == "up" end, function(v)
    if v then
        antiAimPitchMode = "up"
        if _G.AntiAimPoseConfig then _G.AntiAimPoseConfig.pitch = "up" end
    end
end)
antiAimSec:Toggle("Pitch: down", function() return antiAimPitchMode == "down" end, function(v)
    if v then
        antiAimPitchMode = "down"
        if _G.AntiAimPoseConfig then _G.AntiAimPoseConfig.pitch = "down" end
    end
end)
antiAimSec:Toggle("Pitch: zero", function() return antiAimPitchMode == "zero" end, function(v)
    if v then
        antiAimPitchMode = "zero"
        if _G.AntiAimPoseConfig then _G.AntiAimPoseConfig.pitch = "zero" end
    end
end)
antiAimSec:Toggle("Pitch: random", function() return antiAimPitchMode == "random" end, function(v)
    if v then
        antiAimPitchMode = "random"
        if _G.AntiAimPoseConfig then _G.AntiAimPoseConfig.pitch = "random" end
    end
end)

antiAimSec:Toggle("Yaw: disabled", function() return antiAimYawMode == "disabled" end, function(v)
    if v then
        antiAimYawMode = "disabled"
        if _G.AntiAimPoseConfig then _G.AntiAimPoseConfig.yaw = "disabled" end
    end
end)
antiAimSec:Toggle("Yaw: backwards", function() return antiAimYawMode == "backwards" end, function(v)
    if v then
        antiAimYawMode = "backwards"
        if _G.AntiAimPoseConfig then _G.AntiAimPoseConfig.yaw = "backwards" end
    end
end)
antiAimSec:Toggle("Yaw: spin", function() return antiAimYawMode == "spin" end, function(v)
    if v then
        antiAimYawMode = "spin"
        if _G.AntiAimPoseConfig then _G.AntiAimPoseConfig.yaw = "spin" end
    end
end)
antiAimSec:Toggle("Yaw: random", function() return antiAimYawMode == "random" end, function(v)
    if v then
        antiAimYawMode = "random"
        if _G.AntiAimPoseConfig then _G.AntiAimPoseConfig.yaw = "random" end
    end
end)

antiAimSec:Toggle("Underground", function() return antiAimUnderground end, function(v)
    antiAimUnderground = v
    if _G.AntiAimPoseConfig then _G.AntiAimPoseConfig.underground = v end
end)

-- Anti Katana (Lion) in Misc
local antiKatanaSec = MiscTab:Section("Anti Katana", 2)
antiKatanaSec:Toggle("Enable Anti Katana", function() return antiKatanaEnabled end, function(v)
    antiKatanaEnabled = v
    if _G.AntiKatanaState then _G.AntiKatanaState.Enabled = v end
end)
antiKatanaSec:Toggle("Deflect Block Sound", function() return antiKatanaSoundEnabled end, function(v)
    antiKatanaSoundEnabled = v
end)

-- UI Set Tab Options (Hit Sounds & Skybox Included)
local hitSoundSec = UiTab:Section("Hit Sound Settings", 1)
hitSoundSec:Toggle("Enable Hit Sound", function() return hitSoundEnabled end, function(v) hitSoundEnabled = v end)
hitSoundSec:Slider("Sound Volume", 0, 2.0, function() return hitSoundVolume end, function(v) hitSoundVolume = v end)
hitSoundSec:Slider("Sound Pitch", 0.1, 2.0, function() return hitSoundPitch end, function(v) hitSoundPitch = v end)

hitSoundSec:Toggle("HS: rust hs", function() return selectedHitSound == "rust hs" end, function(v) if v then selectedHitSound = "rust hs"; playHitSound() end end)
hitSoundSec:Toggle("HS: neverlose", function() return selectedHitSound == "neverlose" end, function(v) if v then selectedHitSound = "neverlose"; playHitSound() end end)
hitSoundSec:Toggle("HS: sparkle", function() return selectedHitSound == "sparkle" end, function(v) if v then selectedHitSound = "sparkle"; playHitSound() end end)
hitSoundSec:Toggle("HS: minecraft hit", function() return selectedHitSound == "minecraft hit" end, function(v) if v then selectedHitSound = "minecraft hit"; playHitSound() end end)
hitSoundSec:Toggle("HS: bonk", function() return selectedHitSound == "bonk" end, function(v) if v then selectedHitSound = "bonk"; playHitSound() end end)
hitSoundSec:Toggle("HS: osu", function() return selectedHitSound == "osu" end, function(v) if v then selectedHitSound = "osu"; playHitSound() end end)
hitSoundSec:Toggle("HS: among us", function() return selectedHitSound == "among us" end, function(v) if v then selectedHitSound = "among us"; playHitSound() end end)
hitSoundSec:Toggle("HS: bruh", function() return selectedHitSound == "bruh" end, function(v) if v then selectedHitSound = "bruh"; playHitSound() end end)
hitSoundSec:Toggle("HS: vine", function() return selectedHitSound == "vine" end, function(v) if v then selectedHitSound = "vine"; playHitSound() end end)
hitSoundSec:Toggle("HS: gamesense", function() return selectedHitSound == "gamesense" end, function(v) if v then selectedHitSound = "gamesense"; playHitSound() end end)
hitSoundSec:Toggle("HS: 장충동 왕족발 보쌈", function() return selectedHitSound == "장충동 왕족발 보쌈" end, function(v) if v then selectedHitSound = "장충동 왕족발 보쌈"; playHitSound() end end)

-- Theme Color (nexlib Theme Color presets)
local themeSec = UiTab:Section("Theme Color", 1)
themeSec:Toggle("Theme: Sky Blue", function() return selectedThemeColor == "Sky Blue" end, function(v)
    if v then applyThemeColor("Sky Blue") end
end)
themeSec:Toggle("Theme: Red", function() return selectedThemeColor == "Red" end, function(v)
    if v then applyThemeColor("Red") end
end)
themeSec:Toggle("Theme: Lime Green", function() return selectedThemeColor == "Lime Green" end, function(v)
    if v then applyThemeColor("Lime Green") end
end)
themeSec:Toggle("Theme: Purple", function() return selectedThemeColor == "Purple" end, function(v)
    if v then applyThemeColor("Purple") end
end)
themeSec:Toggle("Theme: Orange", function() return selectedThemeColor == "Orange" end, function(v)
    if v then applyThemeColor("Orange") end
end)

local uiSec = UiTab:Section("Skybox & Crosshair", 2)
uiSec:Toggle("Circle Crosshair", function() return circleCrosshairEnabled end, function(v) circleCrosshairEnabled = v end)
uiSec:Toggle("Disable Custom Sky", function() return not customSkyboxEnabled end, function(v) if v then customSkyboxEnabled = false; applySkybox() end end)
uiSec:Toggle("Sky: Afternoon", function() return customSkyboxEnabled and skyboxTheme == "Afternoon" end, function(v) if v then setSkyboxTheme("Afternoon") else if skyboxTheme == "Afternoon" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Blue Space", function() return customSkyboxEnabled and skyboxTheme == "Blue Space" end, function(v) if v then setSkyboxTheme("Blue Space") else if skyboxTheme == "Blue Space" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Classic Roblox", function() return customSkyboxEnabled and skyboxTheme == "Classic Roblox" end, function(v) if v then setSkyboxTheme("Classic Roblox") else if skyboxTheme == "Classic Roblox" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Cloudy", function() return customSkyboxEnabled and skyboxTheme == "Cloudy" end, function(v) if v then setSkyboxTheme("Cloudy") else if skyboxTheme == "Cloudy" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Dusk", function() return customSkyboxEnabled and skyboxTheme == "Dusk" end, function(v) if v then setSkyboxTheme("Dusk") else if skyboxTheme == "Dusk" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Dawn", function() return customSkyboxEnabled and skyboxTheme == "Dawn" end, function(v) if v then setSkyboxTheme("Dawn") else if skyboxTheme == "Dawn" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Dark Skies", function() return customSkyboxEnabled and skyboxTheme == "Dark Skies" end, function(v) if v then setSkyboxTheme("Dark Skies") else if skyboxTheme == "Dark Skies" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Earth", function() return customSkyboxEnabled and skyboxTheme == "Earth" end, function(v) if v then setSkyboxTheme("Earth") else if skyboxTheme == "Earth" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Horizontal Milky Way", function() return customSkyboxEnabled and skyboxTheme == "Horizontal Milky Way" end, function(v) if v then setSkyboxTheme("Horizontal Milky Way") else if skyboxTheme == "Horizontal Milky Way" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Heaven", function() return customSkyboxEnabled and skyboxTheme == "Heaven" end, function(v) if v then setSkyboxTheme("Heaven") else if skyboxTheme == "Heaven" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Jungle", function() return customSkyboxEnabled and skyboxTheme == "Jungle" end, function(v) if v then setSkyboxTheme("Jungle") else if skyboxTheme == "Jungle" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Mountains", function() return customSkyboxEnabled and skyboxTheme == "Mountains" end, function(v) if v then setSkyboxTheme("Mountains") else if skyboxTheme == "Mountains" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Nebula", function() return customSkyboxEnabled and skyboxTheme == "Nebula" end, function(v) if v then setSkyboxTheme("Nebula") else if skyboxTheme == "Nebula" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Night Light", function() return customSkyboxEnabled and skyboxTheme == "Night Light" end, function(v) if v then setSkyboxTheme("Night Light") else if skyboxTheme == "Night Light" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Night", function() return customSkyboxEnabled and skyboxTheme == "Night" end, function(v) if v then setSkyboxTheme("Night") else if skyboxTheme == "Night" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Ocean Sky", function() return customSkyboxEnabled and skyboxTheme == "Ocean Sky" end, function(v) if v then setSkyboxTheme("Ocean Sky") else if skyboxTheme == "Ocean Sky" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Redshift", function() return customSkyboxEnabled and skyboxTheme == "Redshift" end, function(v) if v then setSkyboxTheme("Redshift") else if skyboxTheme == "Redshift" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Space", function() return customSkyboxEnabled and skyboxTheme == "Space" end, function(v) if v then setSkyboxTheme("Space") else if skyboxTheme == "Space" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Sunset", function() return customSkyboxEnabled and skyboxTheme == "Sunset" end, function(v) if v then setSkyboxTheme("Sunset") else if skyboxTheme == "Sunset" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Storm", function() return customSkyboxEnabled and skyboxTheme == "Storm" end, function(v) if v then setSkyboxTheme("Storm") else if skyboxTheme == "Storm" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: SFOTH", function() return customSkyboxEnabled and skyboxTheme == "SFOTH" end, function(v) if v then setSkyboxTheme("SFOTH") else if skyboxTheme == "SFOTH" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Solid Black", function() return customSkyboxEnabled and skyboxTheme == "Solid Black" end, function(v) if v then setSkyboxTheme("Solid Black") else if skyboxTheme == "Solid Black" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Saturn", function() return customSkyboxEnabled and skyboxTheme == "Saturn" end, function(v) if v then setSkyboxTheme("Saturn") else if skyboxTheme == "Saturn" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Smoke", function() return customSkyboxEnabled and skyboxTheme == "Smoke" end, function(v) if v then setSkyboxTheme("Smoke") else if skyboxTheme == "Smoke" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Vertical Milky Way", function() return customSkyboxEnabled and skyboxTheme == "Vertical Milky Way" end, function(v) if v then setSkyboxTheme("Vertical Milky Way") else if skyboxTheme == "Vertical Milky Way" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: White", function() return customSkyboxEnabled and skyboxTheme == "White" end, function(v) if v then setSkyboxTheme("White") else if skyboxTheme == "White" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Dark Sky", function() return customSkyboxEnabled and skyboxTheme == "Dark Sky" end, function(v) if v then setSkyboxTheme("Dark Sky") else if skyboxTheme == "Dark Sky" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Vaporwave", function() return customSkyboxEnabled and skyboxTheme == "Vaporwave" end, function(v) if v then setSkyboxTheme("Vaporwave") else if skyboxTheme == "Vaporwave" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Lake Sky", function() return customSkyboxEnabled and skyboxTheme == "Lake Sky" end, function(v) if v then setSkyboxTheme("Lake Sky") else if skyboxTheme == "Lake Sky" then customSkyboxEnabled = false; applySkybox() end end end)
uiSec:Toggle("Sky: Black Mesa", function() return customSkyboxEnabled and skyboxTheme == "Black Mesa" end, function(v) if v then setSkyboxTheme("Black Mesa") else if skyboxTheme == "Black Mesa" then customSkyboxEnabled = false; applySkybox() end end end)

MainFrame.Visible = true

print("[vallkmult Premium v3] Loaded — ESP (Box/Name/Health/Tracer) + FOV/Crosshair active. Open/Close: vallkmult UI + RightShift.")
