-- [[ multvallk Ultra Gold Premium x Vallk Dual-Engine Edition - File Ragebot Integrated ]]
-- 파일 내 레이지봇(반사/패링/카타나 감지, 무적 감지, RestoreDesyncPerfect CFrame 복구, UseItem 리모트 패킷 사격) 통합 버전
-- [FFMode: Team Check 및 Baiting(낙사 유도) 기능 추가됨]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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

-- Player Spawn Time Tracker
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
-- SECTION: Key System & Global Variables
-- ============================================================================
local validKey = "Paid_masterkey-vallkmult"
local keyPassed = false

-- vallkmult Combat Settings
local aimbotEnabled = false
local silentAimEnabled = false
local silentAimHitPart = "head"
local silentAimFovRadius = 300
local silentWallCheck = false
local silentAimTarget = nil

-- Ragebot Toggles
local ragebotOrKillAura = false
local hoNyangRageEnabled = false

-- Vallk Independent Features Toggle
local fastMeleeEnabled = false
local hoNyangNoCDEnabled = false

-- ============================================================================
-- SECTION: FFMode (Team Check & Baiting 낙사 유도 기술) 추가 설정
-- ============================================================================
local ffModeEnabled = false
local ffTeamCheckEnabled = true
local ffBaitingEnabled = false

-- Orbit & Void Spam Independent Settings (추가된 기능)
local orbitEnabled = false
local orbitRange = 50
local orbitDelay = 0.01

local voidSpamEnabled = false
local voidSpamRange = 50
local voidSpamDelay = 0.01

-- Gun Utility Toggles
local triggerbotEnabled = false
local rapidFireEnabled = false
local noRecoilEnabled = false
local noSpreadEnabled = false
local bulletSpeedBoost = false
local bulletSpeedMult = 100000

-- ESP & Movement & Skins
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

-- Modules Init
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

-- Helpers
local function is_teammate(player)
    if ffModeEnabled and ffTeamCheckEnabled then
        local myTeam = LocalPlayer:GetAttribute("TeamID")
        local pTeam = player:GetAttribute("TeamID")
        if myTeam ~= nil and pTeam ~= nil and myTeam == pTeam then
            return true
        end
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
    if tool and string.find(string.lower(tool.Name), "katana", 1, true) then
        isKatana = true
    end
    for _, child in ipairs(char:GetChildren()) do
        local childName = string.lower(child.Name)
        if string.find(childName, "katana", 1, true) then isKatana = true end
        if string.find(childName, "reflect", 1, true) or string.find(childName, "deflect", 1, true) then
            return true
        end
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
        if not item then
            canShoot = false
            return
        end
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
        if isReloading == true or (typeof(ammo) == "number" and ammo <= 0) then
            canShoot = false
        end
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
-- FILE INTEGRATED RAGEBOT ENGINE
-- ============================================================================
local activeTargetPart = nil
local originalCFrame = nil
local originalVelocity = nil
local desyncHeightOffset = 3

local function restoreDesyncCFrame()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not originalCFrame then return end
    hrp.CFrame = originalCFrame
    if originalVelocity then
        hrp.AssemblyLinearVelocity = originalVelocity
    end
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

    RunService.Heartbeat:Connect(function()
        if not (ragebotOrKillAura or hoNyangRageEnabled) then return end
        if not activeTargetPart or not activeTargetPart.Parent then return end

        local targetChar = activeTargetPart:FindFirstAncestorOfClass("Model") or activeTargetPart.Parent
        local targetPlayer = Players:GetPlayerFromCharacter(targetChar)
        if not targetPlayer or targetPlayer == LocalPlayer or is_teammate(targetPlayer) then return end
        if get_character_immune(targetPlayer) or is_reflecting_or_parrying(targetPlayer) then return end

        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local objID = getEquippedObjectID()
        if objID then cachedObjectID = objID else objID = cachedObjectID end
        if not objID or not useItemRemote or not startShootingEnum then return end

        local shootOrigin = activeTargetPart.Position + Vector3.new(0, 0.1, 0)
        local packet = createTeleportPacket(shootOrigin, activeTargetPart)
        pcall(function()
            useItemRemote:FireServer(objID, startShootingEnum, packet, nil)
        end)
    end)
end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if originalCFrame then restoreDesyncCFrame() end

        if (ragebotOrKillAura or hoNyangRageEnabled) and activeTargetPart and can_shoot() then
            local targetChar = activeTargetPart:FindFirstAncestorOfClass("Model") or activeTargetPart.Parent
            local targetPlayer = Players:GetPlayerFromCharacter(targetChar)
            if targetPlayer and is_reflecting_or_parrying(targetPlayer) then return end

            originalCFrame = hrp.CFrame
            originalVelocity = hrp.AssemblyLinearVelocity
            local targetPos = activeTargetPart.Position
            local teleportPos = targetPos + Vector3.new(0, desyncHeightOffset, 0)
            hrp.CFrame = CFrame.new(teleportPos, targetPos)
        end
    end)
end)

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
                                    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(baitVector.X * 5, 0, baitVector.Z * 5)
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
                    local randomOffset = Vector3.new(math.random(-range, range) * 0.00001, 0, math.random(-range, range) * 0.00001)
                    hrp.CFrame = hrp.CFrame + randomOffset
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.01)
        if ragebotOrKillAura or hoNyangRageEnabled then
            local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.zero
            local closestPlayer = nil
            local closestDist = math.huge

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and not is_teammate(player) then
                    if get_character_immune(player) or is_reflecting_or_parrying(player) then
                        continue
                    end

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

-- ============================================================================
-- SECTION: Hit Logs Integration (추가된 히트 로그 기능)
-- ============================================================================
local HitLogGui = Instance.new("ScreenGui")
HitLogGui.Name = "multvallkHitLogUI"
HitLogGui.ResetOnSpawn = false
pcall(function() if gethui then HitLogGui.Parent = gethui() else HitLogGui.Parent = CoreGui end end)
if not HitLogGui.Parent then HitLogGui.Parent = PlayerGui end

local HitLogFrame = Instance.new("Frame", HitLogGui)
HitLogFrame.Size = UDim2.new(0, 350, 0, 200)
HitLogFrame.Position = UDim2.new(0, 10, 0.5, -100)
HitLogFrame.BackgroundTransparency = 1

local HitLogLayout = Instance.new("UIListLayout", HitLogFrame)
HitLogLayout.SortOrder = Enum.SortOrder.LayoutOrder
HitLogLayout.Padding = UDim.new(0, 4)
HitLogLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

local function addHitLog(targetName, damage)
    local logLabel = Instance.new("TextLabel")
    logLabel.Size = UDim2.new(1, 0, 0, 20)
    logLabel.BackgroundTransparency = 1
    logLabel.Text = string.format("(mult hit %s 데미지: %.1f)", targetName, damage)
    logLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
    logLabel.TextStrokeTransparency = 0.2
    logLabel.Font = Enum.Font.Code
    logLabel.TextSize = 13
    logLabel.TextXAlignment = Enum.TextXAlignment.Left
    logLabel.Parent = HitLogFrame

    task.delay(4, function()
        pcall(function()
            local tween = TweenService:Create(logLabel, TweenInfo.new(0.5), {TextTransparency = 1, TextStrokeTransparency = 1})
            tween:Play()
            tween.Completed:Connect(function()
                logLabel:Destroy()
            end)
        end)
    end)
end

local monitoredPlayers = {}

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
                addHitLog(player.Name, dmg)
            end
            lastHealth = newHealth
        end)

        hum.Died:Connect(function()
            if conn then conn:Disconnect() end
        end)
    end

    if player.Character then trackCharacter(player.Character) end
    player.CharacterAdded:Connect(trackCharacter)
end

for _, p in ipairs(Players:GetPlayers()) do
    setupPlayerDamageTracker(p)
end
Players.PlayerAdded:Connect(setupPlayerDamageTracker)

-- ============================================================================
-- ENGINE 2: Ragebot UI & Crosshair Info UI Engine
-- ============================================================================
local RageUIGui = Instance.new("ScreenGui", PlayerGui)
RageUIGui.Name = "vallkmultRageUI"
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
RageTextLabel.Size = UDim2.new(0, 300, 0, 25)
RageTextLabel.BackgroundTransparency = 1
RageTextLabel.Text = "(vallkmult ragebot:in the void...^^)"
RageTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
RageTextLabel.TextStrokeTransparency = 0
RageTextLabel.Font = Enum.Font.GothamBold
RageTextLabel.TextSize = 13
RageTextLabel.TextXAlignment = Enum.TextXAlignment.Center
RageTextLabel.Visible = false

local rageHue = 0
local rotAngle = 0
RunService.RenderStepped:Connect(function()
    RageTextLabel.Visible = CrosshairContainer.Visible or ragebotOrKillAura or hoNyangRageEnabled
    if RageTextLabel.Visible then
        rageHue = (rageHue + 2) % 360
        local rainbowColor = Color3.fromHSV(rageHue / 360, 1, 1)
        for _, item in ipairs(crosshairLines) do
            item.Line.BackgroundColor3 = rainbowColor
        end
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
            RageTextLabel.Text = "(vallkmult ragebot kill " .. tModel.Name .. ")"
        else
            RageTextLabel.Text = "(vallkmult ragebot:in the void...^^)"
        end
    end
end)

-- ============================================================================
-- SECTION: Fast Melee & Cooldown 0 Loops
-- ============================================================================
task.spawn(function()
    while true do
        task.wait(1.5)
        if fastMeleeEnabled then
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" then
                        if rawget(v, "Cooldown") then v.Cooldown = 0 end
                        if rawget(v, "AttackCooldown") then v.AttackCooldown = 0 end
                        if rawget(v, "SwingCooldown") then v.SwingCooldown = 0 end
                        if rawget(v, "HitCooldown") then v.HitCooldown = 0 end
                        if rawget(v, "Delay") then v.Delay = 0 end
                    end
                end
                
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
            end)
        end
    end
end)

local hoNyangOriginalWeaponValues = {}
task.spawn(function()
    while true do
        task.wait(1)
        if hoNyangNoCDEnabled then
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" then
                        if rawget(v, "ShootCooldown") and not hoNyangOriginalWeaponValues[v] then
                            hoNyangOriginalWeaponValues[v] = {Key = "ShootCooldown", Val = v.ShootCooldown}
                        end
                        if rawget(v, "FireRate") and not hoNyangOriginalWeaponValues[v] then
                            hoNyangOriginalWeaponValues[v] = {Key = "FireRate", Val = v.FireRate}
                        end
                        if rawget(v, "Cooldown") and not hoNyangOriginalWeaponValues[v] then
                            hoNyangOriginalWeaponValues[v] = {Key = "Cooldown", Val = v.Cooldown}
                        end

                        if rawget(v, "ShootCooldown") then v.ShootCooldown = 0 end
                        if rawget(v, "FireRate") then v.FireRate = 0 end
                        if rawget(v, "Cooldown") then v.Cooldown = 0 end
                    end
                end
            end)
        else
            if next(hoNyangOriginalWeaponValues) then
                pcall(function()
                    for tbl, info in pairs(hoNyangOriginalWeaponValues) do
                        if type(tbl) == "table" and info and info.Key then
                            tbl[info.Key] = info.Val
                        end
                    end
                    table.clear(hoNyangOriginalWeaponValues)
                end)
            end
        end
    end
end)

-- ============================================================================
-- SECTION: Gun Hooking & All Skins
-- ============================================================================
pcall(function()
    if FighterController and FighterController.LocalFighter and FighterController.LocalFighter.GetMouseLocation then
        local LocalFighter = FighterController.LocalFighter
        local oldMouseLoc = LocalFighter.GetMouseLocation
        LocalFighter.GetMouseLocation = newcclosure(function(...)
            if silentAimTarget and (silentAimEnabled or ragebotOrKillAura or hoNyangRageEnabled) then
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

    local originalOwns = CosmeticLibrary.OwnsCosmeticNormally
    CosmeticLibrary.OwnsCosmeticNormally = function(self, inv, name, wpn) if skinChangerEnabled then return true end return originalOwns(self, inv, name, wpn) end
    CosmeticLibrary.OwnsCosmeticUniversally = function(...) if skinChangerEnabled then return true end return false end
    CosmeticLibrary.OwnsCosmeticForWeapon = function(...) if skinChangerEnabled then return true end return false end
    CosmeticLibrary.OwnsCosmetic = function(...) if skinChangerEnabled then return true end return false end

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

local gcCache = {
    ShootCooldown = setmetatable({}, { __mode = "k" }),
    ShootRecoil = setmetatable({}, { __mode = "k" }),
}

local function override_gc_attribute(attribute, value)
    local cache = gcCache[attribute]
    if not cache then return end
    for _, gcVal in pairs(getgc(true)) do
        if type(gcVal) == "table" then
            local rawV = rawget(gcVal, attribute)
            if rawV ~= nil then
                if cache[gcVal] == nil then cache[gcVal] = rawV end
                gcVal[attribute] = value
            end
        end
    end
end

local function restore_gc_attribute(attribute)
    local cache = gcCache[attribute]
    if not cache then return end
    for gcVal, original in pairs(cache) do
        if type(gcVal) == "table" then
            pcall(function() gcVal[attribute] = original end)
        end
        cache[gcVal] = nil
    end
end

RunService.Heartbeat:Connect(function()
    if rapidFireEnabled then pcall(function() override_gc_attribute("ShootCooldown", 0) end)
    else pcall(function() restore_gc_attribute("ShootCooldown") end) end

    if noRecoilEnabled then pcall(function() override_gc_attribute("ShootRecoil", 0) end)
    else pcall(function() restore_gc_attribute("ShootRecoil") end) end

    pcall(function()
        local localFighter = FighterController and FighterController.LocalFighter
        if localFighter and localFighter.Items then
            for _, item in pairs(localFighter.Items) do
                if bulletSpeedBoost then
                    if item.BulletSpeed then
                        if not item._origBulletSpeed then item._origBulletSpeed = item.BulletSpeed end
                        item.BulletSpeed = item._origBulletSpeed * bulletSpeedMult
                    end
                else
                    if item._origBulletSpeed then item.BulletSpeed = item._origBulletSpeed end
                end
            end
        end
    end)
end)

-- ============================================================================
-- SECTION: Render / Visuals & Skybox
-- ============================================================================
local SEGMENT_COUNT = 32
local circleSegments = {}
local circleFill = Drawing.new("Circle")
circleFill.Thickness = 0
circleFill.NumSides = 64
circleFill.Filled = true
circleFill.Transparency = 0.75
circleFill.Visible = false

for i = 1, SEGMENT_COUNT do
    local line = Drawing.new("Line")
    line.Thickness = 2.2
    line.Transparency = 1
    line.Visible = false
    table.insert(circleSegments, line)
end

local function getGradientColor(factor)
    local blue = Color3.fromRGB(30, 100, 255)
    local lightBlue = Color3.fromRGB(120, 180, 255)
    local lightPink = Color3.fromRGB(240, 150, 220)
    local pink = Color3.fromRGB(255, 60, 160)

    if factor < 0.25 then return blue:Lerp(lightBlue, factor * 4)
    elseif factor < 0.5 then return lightBlue:Lerp(lightPink, (factor - 0.25) * 4)
    elseif factor < 0.75 then return lightPink:Lerp(pink, (factor - 0.5) * 4)
    else return pink:Lerp(blue, (factor - 0.75) * 4) end
end

local skyPresets = {
    ["Dark Sky"] = { SkyboxUp = "rbxassetid://570555929", SkyboxRt = "rbxassetid://570555882", SkyboxDn = "rbxassetid://570555964", SkyboxFt = "rbxassetid://570555800", SkyboxLf = "rbxassetid://570555840", SkyboxBk = "rbxassetid://570555736" },
    ["Vaporwave"] = { SkyboxUp = "rbxassetid://1417494643", SkyboxRt = "rbxassetid://1417494499", SkyboxLf = "rbxassetid://1417494402", SkyboxFt = "rbxassetid://1417494253", SkyboxBk = "rbxassetid://1417494030", SkyboxDn = "rbxassetid://1417494146" }
}

local function applySkybox()
    local customSky = Lighting:FindFirstChild("vallkmultCustomSky")
    if not customSkyboxEnabled then
        if customSky then customSky:Destroy() end
        return
    end
    local skyData = skyPresets[skyboxTheme] or skyPresets["Vaporwave"]
    if not customSky then
        customSky = Instance.new("Sky")
        customSky.Name = "vallkmultCustomSky"
        customSky.Parent = Lighting
    end
    for prop, val in pairs(skyData) do pcall(function() customSky[prop] = val end) end
end

RunService.RenderStepped:Connect(function()
    local myChar = LocalPlayer.Character
    local mousePos = UserInputService:GetMouseLocation()

    if circleCrosshairEnabled then
        local centerPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local radius = math.clamp(circleCrosshairSize, 1, 600)
        local currentRot = (tick() * circleRotationSpeed) % (math.pi * 2)

        circleFill.Position = centerPos
        circleFill.Radius = radius
        circleFill.Color = getGradientColor((currentRot / (math.pi * 2)) % 1)
        circleFill.Visible = true

        for i = 1, SEGMENT_COUNT do
            local line = circleSegments[i]
            local angle1 = currentRot + ((i - 1) / SEGMENT_COUNT) * (math.pi * 2)
            local angle2 = currentRot + (i / SEGMENT_COUNT) * (math.pi * 2)

            line.From = centerPos + Vector2.new(math.cos(angle1) * radius, math.sin(angle1) * radius)
            line.To = centerPos + Vector2.new(math.cos(angle2) * radius, math.sin(angle2) * radius)
            line.Color = getGradientColor((i - 1) / SEGMENT_COUNT)
            line.Visible = true
        end
    else
        circleFill.Visible = false
        for _, line in ipairs(circleSegments) do line.Visible = false end
    end

    silentAimTarget = nil
    if (silentAimEnabled or ragebotOrKillAura or hoNyangRageEnabled) and myChar then
        local closestDist = math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not is_teammate(player) and not get_character_immune(player) and not is_reflecting_or_parrying(player) then
                local hitPart = get_character_root(player.Character)
                if hitPart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hitPart.Position)
                    if onScreen then
                        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        local maxFov = (ragebotOrKillAura or hoNyangRageEnabled) and 99999 or silentAimFovRadius
                        
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
-- SECTION: User Interface (Mobile Optimized & Draggable)
-- ============================================================================
do
    local ACC = Color3.fromRGB(80, 150, 255)
    local BG = Color3.fromRGB(18, 20, 26)
    local PANEL = Color3.fromRGB(24, 28, 36)
    local TAB_BG = Color3.fromRGB(14, 16, 20)

    local gui = Instance.new("ScreenGui")
    gui.Name = "vallkmultIntegratedUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 100000
    pcall(function() if gethui then gui.Parent = gethui() else gui.Parent = CoreGui end end)
    if not gui.Parent then gui.Parent = PlayerGui end

    local toggleMenuBtn = Instance.new("TextButton")
    toggleMenuBtn.Size = UDim2.fromOffset(80, 32)
    toggleMenuBtn.Position = UDim2.new(1, -90, 0, 10)
    toggleMenuBtn.BackgroundColor3 = BG
    toggleMenuBtn.TextColor3 = ACC
    toggleMenuBtn.Font = Enum.Font.Code
    toggleMenuBtn.TextSize = 11
    toggleMenuBtn.Text = "vallkmult"
    toggleMenuBtn.BorderSizePixel = 0
    toggleMenuBtn.ZIndex = 999999
    toggleMenuBtn.Parent = gui
    Instance.new("UICorner", toggleMenuBtn).CornerRadius = UDim.new(0, 6)

    local keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.fromOffset(280, 150)
    keyFrame.Position = UDim2.new(0.5, -140, 0.5, -75)
    keyFrame.BackgroundColor3 = BG
    keyFrame.BorderSizePixel = 0
    keyFrame.Visible = not keyPassed
    keyFrame.Parent = gui
    Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0, 8)

    local keyTitle = Instance.new("TextLabel")
    keyTitle.Size = UDim2.new(1, 0, 0, 32)
    keyTitle.BackgroundTransparency = 1
    keyTitle.Text = "vallkmult - Key System"
    keyTitle.TextColor3 = ACC
    keyTitle.Font = Enum.Font.Code
    keyTitle.TextSize = 12
    keyTitle.Parent = keyFrame

    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(0.85, 0, 0, 32)
    keyBox.Position = UDim2.new(0.075, 0, 0.32, 0)
    keyBox.BackgroundColor3 = PANEL
    keyBox.PlaceholderText = "Enter Master Key..."
    keyBox.Text = ""
    keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyBox.Font = Enum.Font.Code
    keyBox.TextSize = 11
    keyBox.Parent = keyFrame
    Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 4)

    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(0.85, 0, 0, 32)
    submitBtn.Position = UDim2.new(0.075, 0, 0.62, 0)
    submitBtn.BackgroundColor3 = ACC
    submitBtn.Text = "Submit Key"
    submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitBtn.Font = Enum.Font.Code
    submitBtn.TextSize = 11
    submitBtn.Parent = keyFrame
    Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0, 4)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(360, 260)
    frame.Position = UDim2.new(0.5, -180, 0.5, -130)
    frame.BackgroundColor3 = BG
    frame.BorderSizePixel = 0
    frame.Visible = keyPassed
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -12, 0, 26)
    title.Position = UDim2.new(0, 8, 0, 4)
    title.BackgroundTransparency = 1
    title.Text = "multvallk Premium"
    title.TextColor3 = ACC
    title.Font = Enum.Font.Code
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local tabHeader = Instance.new("Frame")
    tabHeader.Size = UDim2.new(1, -16, 0, 26)
    tabHeader.Position = UDim2.new(0, 8, 0, 30)
    tabHeader.BackgroundTransparency = 1
    tabHeader.Parent = frame

    local tabLay = Instance.new("UIListLayout")
    tabLay.Parent = tabHeader
    tabLay.FillDirection = Enum.FillDirection.Horizontal
    tabLay.Padding = UDim.new(0, 3)

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -16, 1, -66)
    content.Position = UDim2.new(0, 8, 0, 60)
    content.BackgroundColor3 = PANEL
    content.Parent = frame
    Instance.new("UICorner", content).CornerRadius = UDim.new(0, 4)

    local pages = {}
    local function makePage(name)
        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, -8, 1, -8)
        scroll.Position = UDim2.new(0, 4, 0, 4)
        scroll.BackgroundTransparency = 1
        scroll.ScrollBarThickness = 2
        scroll.ScrollBarImageColor3 = ACC
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Visible = false
        scroll.Parent = content
        local lay = Instance.new("UIListLayout")
        lay.Parent = scroll
        lay.Padding = UDim.new(0, 3)
        pages[name] = scroll
        return scroll
    end

    local tabBtns = {}
    local function selectTab(name)
        for n, pg in pairs(pages) do pg.Visible = (n == name) end
        for n, btn in pairs(tabBtns) do
            btn.TextColor3 = (n == name) and ACC or Color3.fromRGB(150, 155, 160)
            btn.BackgroundColor3 = (n == name) and Color3.fromRGB(30, 36, 48) or TAB_BG
        end
    end

    local function addTab(name)
        makePage(name)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0.158, 0, 1, 0)
        b.BackgroundColor3 = TAB_BG
        b.BorderSizePixel = 0
        b.Text = name
        b.TextColor3 = Color3.fromRGB(150, 155, 160)
        b.Font = Enum.Font.Code
        b.TextSize = 9
        b.Parent = tabHeader
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 3)
        tabBtns[name] = b
        b.MouseButton1Click:Connect(function() selectTab(name) end)
    end

    local toggleUpdaters = {}
    local function toggle(page, name, getv, setv)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -4, 0, 24)
        b.BackgroundColor3 = Color3.fromRGB(30, 34, 44)
        b.BorderSizePixel = 0
        b.Font = Enum.Font.Code
        b.TextSize = 10
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.Parent = page
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 3)

        local function update()
            local on = getv()
            b.Text = "  " .. (on and "☑ " or "☐ ") .. name
            b.TextColor3 = on and ACC or Color3.fromRGB(170, 175, 180)
        end
        update()
        table.insert(toggleUpdaters, update)
        b.MouseButton1Click:Connect(function()
            setv(not getv())
            for _, u in ipairs(toggleUpdaters) do u() end
        end)
    end

    local function addSlider(page, name, min, max, getv, setv)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -4, 0, 36)
        f.BackgroundColor3 = Color3.fromRGB(30, 34, 44)
        f.BorderSizePixel = 0
        f.Parent = page
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 3)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -10, 0, 18)
        lbl.Position = UDim2.new(0, 5, 0, 2)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Code
        lbl.TextSize = 10
        lbl.TextColor3 = Color3.fromRGB(170, 175, 180)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = name .. ": " .. tostring(getv())
        lbl.Parent = f

        local barBg = Instance.new("TextButton")
        barBg.Size = UDim2.new(1, -10, 0, 10)
        barBg.Position = UDim2.new(0, 5, 0, 22)
        barBg.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
        barBg.BorderSizePixel = 0
        barBg.Text = ""
        barBg.AutoButtonColor = false
        barBg.Parent = f
        Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 2)

        local barFill = Instance.new("Frame")
        barFill.Size = UDim2.new(math.clamp((getv() - min) / (max - min), 0, 1), 0, 1, 0)
        barFill.BackgroundColor3 = ACC
        barFill.BorderSizePixel = 0
        barFill.Parent = barBg
        Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 2)

        local dragging = false
        barBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local pos = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
                local val = min + (max - min) * pos
                setv(val)
                barFill.Size = UDim2.new(pos, 0, 1, 0)
                lbl.Text = name .. ": " .. string.format(max > 1000 and "%.0f" or "%.2f", val)
            end
        end)
    end

    addTab("Main")
    addTab("Ragebot")
    addTab("FFMode")
    addTab("ESP")
    addTab("Misc")
    addTab("UI Set")

    -- Main Tab
    toggle(pages["Main"], "Silent Aim", function() return silentAimEnabled end, function(v) silentAimEnabled = v end)
    toggle(pages["Main"], "Aimbot", function() return aimbotEnabled end, function(v) aimbotEnabled = v end)
    toggle(pages["Main"], "Fast Melee", function() return fastMeleeEnabled end, function(v) fastMeleeEnabled = v end)
    toggle(pages["Main"], "Bullet Speed 0 (CD)", function() return hoNyangNoCDEnabled end, function(v) hoNyangNoCDEnabled = v end)
    toggle(pages["Main"], "No Recoil", function() return noRecoilEnabled end, function(v) noRecoilEnabled = v end)
    toggle(pages["Main"], "No Spread", function() return noSpreadEnabled end, function(v) noSpreadEnabled = v end)
    toggle(pages["Main"], "Rapid Fire", function() return rapidFireEnabled end, function(v) rapidFireEnabled = v end)

    -- Ragebot Tab
    toggle(pages["Ragebot"], "[File Engine] Advanced Ragebot", function() return ragebotOrKillAura end, function(v) 
        ragebotOrKillAura = v 
        if v then hoNyangRageEnabled = false end
    end)
    toggle(pages["Ragebot"], "[File Engine] Auto UseItem Teleport", function() return hoNyangRageEnabled end, function(v) 
        hoNyangRageEnabled = v 
        if v then ragebotOrKillAura = false end
    end)

    toggle(pages["Ragebot"], "Orbit Feature (Independent)", function() return orbitEnabled end, function(v) orbitEnabled = v end)
    addSlider(pages["Ragebot"], "Orbit Range", 50, 50000000, function() return orbitRange end, function(v) orbitRange = v end)
    addSlider(pages["Ragebot"], "Orbit Delay (Speed)", 0.01, 1, function() return orbitDelay end, function(v) orbitDelay = v end)

    toggle(pages["Ragebot"], "Void Spam Feature (Independent)", function() return voidSpamEnabled end, function(v) voidSpamEnabled = v end)
    addSlider(pages["Ragebot"], "Void Spam Range", 50, 50000000, function() return voidSpamRange end, function(v) voidSpamRange = v end)
    addSlider(pages["Ragebot"], "Void Spam Delay (Speed)", 0.01, 1, function() return voidSpamDelay end, function(v) voidSpamDelay = v end)

    -- FFMode Tab
    toggle(pages["FFMode"], "Enable FFMode", function() return ffModeEnabled end, function(v) ffModeEnabled = v end)
    toggle(pages["FFMode"], "Team Check", function() return ffTeamCheckEnabled end, function(v) ffTeamCheckEnabled = v end)
    toggle(pages["FFMode"], "Baiting (Fall Inducer)", function() return ffBaitingEnabled end, function(v) ffBaitingEnabled = v end)

    -- ESP Tab
    toggle(pages["ESP"], "ESP Master Toggle", function() return espEnabled end, function(v) espEnabled = v end)
    toggle(pages["ESP"], "ESP Boxes", function() return espBoxEnabled end, function(v) espBoxEnabled = v end)
    toggle(pages["ESP"], "ESP Names", function() return espNameEnabled end, function(v) espNameEnabled = v end)
    toggle(pages["ESP"], "ESP Health", function() return espHealthEnabled end, function(v) espHealthEnabled = v end)
    toggle(pages["ESP"], "Gun Tracer Line", function() return gunTracerEnabled end, function(v) gunTracerEnabled = v end)

    -- Misc Tab
    toggle(pages["Misc"], "Unlock All Skins", function() return skinChangerEnabled end, function(v) skinChangerEnabled = v end)
    toggle(pages["Misc"], "Bullet Speed Boost (100k)", function() return bulletSpeedBoost end, function(v) bulletSpeedBoost = v end)
    toggle(pages["Misc"], "Rapid Speed (Speed Hack)", function() return rapidSpeedEnabled end, function(v) rapidSpeedEnabled = v end)
    toggle(pages["Misc"], "PC Fly (WASD)", function() return pcFlyEnabled end, function(v) pcFlyEnabled = v end)
    toggle(pages["Misc"], "Noclip", function() return noclipEnabled end, function(v) noclipEnabled = v end)

    -- UI Set Tab
    toggle(pages["UI Set"], "Circle Crosshair (Gradient)", function() return circleCrosshairEnabled end, function(v) circleCrosshairEnabled = v end)
    toggle(pages["UI Set"], "Custom Skybox", function() return customSkyboxEnabled end, function(v) customSkyboxEnabled = v; applySkybox() end)
    toggle(pages["UI Set"], "Sky: Dark Sky", function() return skyboxTheme == "Dark Sky" end, function() skyboxTheme = "Dark Sky"; applySkybox() end)
    toggle(pages["UI Set"], "Sky: Vaporwave", function() return skyboxTheme == "Vaporwave" end, function() skyboxTheme = "Vaporwave"; applySkybox() end)

    selectTab("Main")

    local function makeDraggable(topBar, targetFrame)
        local dragging, dragInput, dragStart, startPos
        topBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = targetFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        topBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    makeDraggable(title, frame)
    makeDraggable(keyTitle, keyFrame)

    submitBtn.MouseButton1Click:Connect(function()
        if keyBox.Text == validKey then
            keyPassed = true
            keyFrame.Visible = false
            
            pcall(function()
                local wmGui = Instance.new("ScreenGui", gui)
                wmGui.Name = "multvallkWatermark"
                wmGui.ResetOnSpawn = false
                
                local wmLabel = Instance.new("TextLabel", wmGui)
                wmLabel.Size = UDim2.new(0, 400, 0, 60)
                wmLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                wmLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
                wmLabel.BackgroundTransparency = 1
                wmLabel.Text = "multvallk."
                wmLabel.TextColor3 = Color3.fromRGB(0, 120, 255)
                wmLabel.Font = Enum.Font.GothamBold
                wmLabel.TextSize = 36
                wmLabel.TextStrokeTransparency = 0.3
                
                task.delay(3, function()
                    pcall(function() wmGui:Destroy() end)
                end)
            end)

            frame.Visible = true
        else
            keyBox.Text = ""
            keyBox.PlaceholderText = "Invalid Key! Try Again."
        end
    end)

    toggleMenuBtn.MouseButton1Click:Connect(function()
        if keyPassed then
            frame.Visible = not frame.Visible
        end
    end)

    UserInputService.InputBegan:Connect(function(input, g)
        if g then return end
        if input.KeyCode == Enum.KeyCode.RightShift and keyPassed then 
            frame.Visible = not frame.Visible 
        end
    end)
end

print("[vallkmult File Ragebot Edition] Successfully Loaded with FFMode (Team Check & Baiting) Integrated.")
