-- ============================================================================
-- multvallk Premium v3 - Fully Integrated Dual Engine (Valk UI Engine)
-- Mobile UI Auto-Scaling & Ragebot Integrated Edition (No Key System)
-- Integrated Feature: Advanced Device Spoofer Engine & Hit Sounds (UI Set)
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
    IntroLabel.Text = "multvallk Premium"
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
-- SECTION: Anti-Kick / Security / Anti-Cheat Bypass
-- ============================================================================
pcall(function()
    if LocalPlayer and typeof(LocalPlayer.Kick) == "function" then
        LocalPlayer.Kick = function(...) end
    end
end)

pcall(function()
    if getrenv and getrenv().setmetatable then
        local _stbl
        _stbl = hookfunction(getrenv().setmetatable, newcclosure(function(tbl, mt)
            if mt and typeof(mt) == "table" and rawget(mt, "__mode") == "kv" then
                local tr = debug.traceback()
                if tr and (tr:find("MiscellaneousController") or tr:find("anticheat") or tr:find("Detection") or tr:find("Security") or tr:find("AntiExploit") or tr:find("Integrity") or tr:find("KickHook")) then
                    return _stbl({1, 2, 3}, {})
                end
            end
            return _stbl(tbl, mt)
        end))
    end
    
    if hookmetamethod and getnamecallmethod then
        local bannedRemoteNames = {
            kick=true, ban=true, punish=true, anticheat=true, detect=true,
            report=true, flag=true, crash=true, log=true, screenshot=true,
            security=true, mod=true, admin=true, watchdog=true, sentinel=true,
        }
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" then
                return
            end
            if method == "FireServer" and self and self.Name then
                local sName = string.lower(self.Name)
                for k, _ in pairs(bannedRemoteNames) do
                    if string.find(sName, k, 1, true) then return end
                end
            end
            return oldNamecall(self, ...)
        end))
    end
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
-- ============================================================================
local deviceSpooferEnabled = false
local spoofedDeviceMode = "Touch" -- Options: "Touch", "Gamepad", "MouseKeyboard", "VR"

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

-- ============================================================================
-- SECTION: Hit Sound System Setup
-- ============================================================================
local hitSoundEnabled = true
local selectedHitSound = "bell" -- Default sound
local hitSoundVolume = 2.0

local hitSoundList = {
    ["rush hs"]      = "rbxassetid://7234320803",
    ["neverlose"]    = "rbxassetid://8679627751",
    ["sparkle"]      = "rbxassetid://9114223177",
    ["minecraft hit"]= "rbxassetid://4018616850",
    ["bonk"]         = "rbxassetid://6382086918",
    ["osu"]          = "rbxassetid://7147454322",
    ["among us"]     = "rbxassetid://5800030712",
    ["bruh"]         = "rbxassetid://4292881112",
    ["vine"]         = "rbxassetid://5332612338",
    ["gamesense"]    = "rbxassetid://4817809188"
}

local function playHitSound()
    if not hitSoundEnabled then return end
    local soundId = hitSoundList[selectedHitSound]
    if not soundId then return end

    task.spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = soundId
        sound.Volume = hitSoundVolume
        sound.PlayOnRemove = false
        sound.Parent = SoundService
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
        task.delay(3, function()
            if sound and sound.Parent then sound:Destroy() end
        end)
    end)
end

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

-- Ragebot Toggle & Sub-features (Hide & Attack Added)
local ragebotOrKillAura = false
local ragebotHeightOffset = 3
local ragebotHideDelay = 0.01   -- Hide (0.01s ~ 1.00s)
local ragebotAttackDelay = 0.01 -- Attack (0.01s ~ 1.00s)

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
local customSkyboxEnabled = false
local skyboxTheme = "Vaporwave"

local circleCrosshairEnabled = false
local circleCrosshairSize = 60
local circleRotationSpeed = 4

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
end)

-- Ragebot Hide Position Sync Loop (Hide Delay Controlled)
RunService.Heartbeat:Connect(function()
    pcall(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if originalCFrame then restoreDesyncCFrame() end

        if ragebotOrKillAura and activeTargetPart and can_shoot() then
            local targetChar = activeTargetPart:FindFirstAncestorOfClass("Model") or activeTargetPart.Parent
            local targetPlayer = Players:GetPlayerFromCharacter(targetChar)
            if targetPlayer and is_reflecting_or_parrying(targetPlayer) then return end

            originalCFrame = hrp.CFrame
            originalVelocity = hrp.AssemblyLinearVelocity
            local targetPos = activeTargetPart.Position
            local teleportPos = targetPos + Vector3.new(0, ragebotHeightOffset, 0)
            hrp.CFrame = CFrame.new(teleportPos, targetPos)
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

task.spawn(function()
    while true do
        task.wait(math.clamp(orbitDelay, 0.01, 1))
        if orbitEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local range = math.clamp(orbitRange, 50, 50000000)
                    local angle = tick() * 10
                    local xOffset = math.cos(angle) * range
                    local zOffset = math.sin(angle) * range
                    hrp.CFrame = hrp.CFrame + Vector3.new(xOffset * 0.00001, 0, zOffset * 0.00001)
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(math.clamp(voidSpamDelay, 0.01, 1))
        if voidSpamEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local range = math.clamp(voidSpamRange, 50, 50000000)
                    local randomOffset = Vector3.new(
                        math.random(-range, range) * 0.00001,
                        math.random(-range, range) * 0.00001,
                        math.random(-range, range) * 0.00001
                    )
                    hrp.CFrame = hrp.CFrame + randomOffset
                end
            end)
        end
    end
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
                addHitLog(player.Name, lastHealth - newHealth)
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
TopBarTitle.Text = "multvallk Premium v3 (No Key)"
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
ToggleBtn.Text = "multvallk UI"
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

-- Ragebot Tab Options (Includes Hide & Attack Sliders)
local rSec1 = RageTab:Section("Rage Engine", 1)
rSec1:Toggle("muilt premium ragebot", function() return ragebotOrKillAura end, function(v) ragebotOrKillAura = v end)
rSec1:Slider("Hide Delay", 0.01, 1.0, function() return ragebotHideDelay end, function(v) ragebotHideDelay = v end)
rSec1:Slider("Attack Delay", 0.01, 1.0, function() return ragebotAttackDelay end, function(v) ragebotAttackDelay = v end)

local rSec2 = RageTab:Section("Orbit & Void Spam", 2)
rSec2:Toggle("Orbit Feature", function() return orbitEnabled end, function(v) orbitEnabled = v end)
rSec2:Slider("Orbit Range", 50, 50000000, function() return orbitRange end, function(v) orbitRange = v end)
rSec2:Slider("Orbit Delay", 0.01, 1, function() return orbitDelay end, function(v) orbitDelay = v end)
rSec2:Toggle("Void Spam (3D Axis)", function() return voidSpamEnabled end, function(v) voidSpamEnabled = v end)
rSec2:Slider("Void Range", 50, 50000000, function() return voidSpamRange end, function(v) voidSpamRange = v end)
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
espSec:Toggle("ESP Health", function() return espHealthEnabled end, function(v) espHealthEnabled = v end)
espSec:Toggle("Gun Tracer Line", function() return gunTracerEnabled end, function(v) gunTracerEnabled = v end)

-- Misc Tab Options
local miscSec = MiscTab:Section("Movement & Mods", 1)
miscSec:Toggle("Mobile Fly (Touch)", function() return mobileFlyEnabled end, function(v) mobileFlyEnabled = v end)
miscSec:Toggle("PC Fly (WASD)", function() return pcFlyEnabled end, function(v) pcFlyEnabled = v end)
miscSec:Toggle("Unlock All Skins", function() return skinChangerEnabled end, function(v) skinChangerEnabled = v end)
miscSec:Toggle("Bullet Speed Boost", function() return bulletSpeedBoost end, function(v) bulletSpeedBoost = v end)
miscSec:Toggle("Rapid Speed Hack", function() return rapidSpeedEnabled end, function(v) rapidSpeedEnabled = v end)
miscSec:Toggle("Noclip", function() return noclipEnabled end, function(v) noclipEnabled = v end)

local spooferSec = MiscTab:Section("Device Spoofer", 2)
spooferSec:Toggle("Enable Device Spoofer", function() return deviceSpooferEnabled end, function(v) deviceSpooferEnabled = v end)
spooferSec:Toggle("Spoof: VR", function() return spoofedDeviceMode == "VR" end, function(v) if v then spoofedDeviceMode = "VR" end end)
spooferSec:Toggle("Spoof: Touch (Mobile)", function() return spoofedDeviceMode == "Touch" end, function(v) if v then spoofedDeviceMode = "Touch" end end)
spooferSec:Toggle("Spoof: Gamepad (Console)", function() return spoofedDeviceMode == "Gamepad" end, function(v) if v then spoofedDeviceMode = "Gamepad" end end)
spooferSec:Toggle("Spoof: Mouse & Keyboard", function() return spoofedDeviceMode == "MouseKeyboard" end, function(v) if v then spoofedDeviceMode = "MouseKeyboard" end end)

-- UI Set Tab Options (Hit Sounds & Skybox Included)
local hitSoundSec = UiTab:Section("Hit Sound Settings", 1)
hitSoundSec:Toggle("Enable Hit Sound", function() return hitSoundEnabled end, function(v) hitSoundEnabled = v end)
hitSoundSec:Slider("Sound Volume", 0.1, 10.0, function() return hitSoundVolume end, function(v) hitSoundVolume = v end)

hitSoundSec:Toggle("HS: rush hs", function() return selectedHitSound == "rush hs" end, function(v) if v then selectedHitSound = "rush hs"; playHitSound() end end)
hitSoundSec:Toggle("HS: neverlose", function() return selectedHitSound == "neverlose" end, function(v) if v then selectedHitSound = "neverlose"; playHitSound() end end)
hitSoundSec:Toggle("HS: sparkle", function() return selectedHitSound == "sparkle" end, function(v) if v then selectedHitSound = "sparkle"; playHitSound() end end)
hitSoundSec:Toggle("HS: minecraft hit", function() return selectedHitSound == "minecraft hit" end, function(v) if v then selectedHitSound = "minecraft hit"; playHitSound() end end)
hitSoundSec:Toggle("HS: bonk", function() return selectedHitSound == "bonk" end, function(v) if v then selectedHitSound = "bonk"; playHitSound() end end)
hitSoundSec:Toggle("HS: osu", function() return selectedHitSound == "osu" end, function(v) if v then selectedHitSound = "osu"; playHitSound() end end)
hitSoundSec:Toggle("HS: among us", function() return selectedHitSound == "among us" end, function(v) if v then selectedHitSound = "among us"; playHitSound() end end)
hitSoundSec:Toggle("HS: bruh", function() return selectedHitSound == "bruh" end, function(v) if v then selectedHitSound = "bruh"; playHitSound() end end)
hitSoundSec:Toggle("HS: vine", function() return selectedHitSound == "vine" end, function(v) if v then selectedHitSound = "vine"; playHitSound() end end)
hitSoundSec:Toggle("HS: gamesense", function() return selectedHitSound == "gamesense" end, function(v) if v then selectedHitSound = "gamesense"; playHitSound() end end)

local uiSec = UiTab:Section("Skybox & Crosshair", 2)
uiSec:Toggle("Circle Crosshair", function() return circleCrosshairEnabled end, function(v) circleCrosshairEnabled = v end)
uiSec:Toggle("Sky: Dark Sky", function() return customSkyboxEnabled and skyboxTheme == "Dark Sky" end, function(v) if v then setSkyboxTheme("Dark Sky") else customSkyboxEnabled = false; applySkybox() end end)
uiSec:Toggle("Sky: Vaporwave", function() return customSkyboxEnabled and skyboxTheme == "Vaporwave" end, function(v) if v then setSkyboxTheme("Vaporwave") else customSkyboxEnabled = false; applySkybox() end end)
uiSec:Toggle("Sky: Lake Sky", function() return customSkyboxEnabled and skyboxTheme == "Lake Sky" end, function(v) if v then setSkyboxTheme("Lake Sky") else customSkyboxEnabled = false; applySkybox() end end)
uiSec:Toggle("Sky: Black Mesa", function() return customSkyboxEnabled and skyboxTheme == "Black Mesa" end, function(v) if v then setSkyboxTheme("Black Mesa") else customSkyboxEnabled = false; applySkybox() end end)

MainFrame.Visible = true

print("[multvallk Premium v3] Script Fully Updated: Intro Added & Features Intact.")
