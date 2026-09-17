
-- [[ vallkmult Ultra Gold Premium x Vallk Dual-Engine Edition - Mobile Optimized ]]
-- vallkmult 레이지봇과 Vallk 레이지봇이 서로 섞이지 않고 각각 독립적으로 동작하며, 고급 디싱크(머리 위 누운 자세 + Velocity Spoof)가 적용되었습니다.

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
-- SECTION: Anti-Kick / Security / Anti-Cheat Bypass (고급 우회)
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

-- Player Spawn Time Tracker (Immunity check)
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
local allHeadEnabled = false

-- Vallkmult Original Ragebot Toggle
local ragebotOrKillAura = false
local ragebotMagicBullet = false

-- Vallk Independent Features Toggle
local hoNyangRageEnabled = false
local fastMeleeEnabled = false
local hoNyangNoCDEnabled = false

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

-- Modules Hook Init
local FighterController, SpectateController, CameraController, GunModule, UtilityModule
pcall(function()
    local ps = LocalPlayer:WaitForChild("PlayerScripts")
    local ctrl = ps:WaitForChild("Controllers")
    FighterController = require(ctrl:WaitForChild("FighterController"))
    SpectateController = require(ctrl:WaitForChild("SpectateController", 2))
    CameraController = require(ctrl:WaitForChild("CameraController", 2))
    
    GunModule = require(ps:WaitForChild("Modules"):WaitForChild("ItemTypes"):WaitForChild("Gun"))
    UtilityModule = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"))
end)

-- Helpers
local function is_teammate(player)
    local myTeam = LocalPlayer:GetAttribute("TeamID")
    local pTeam = player:GetAttribute("TeamID")
    if myTeam == nil or pTeam == nil then return false end
    return myTeam == pTeam
end

local function get_character_valid(player)
    local char = player.Character
    if not char then return false end
    if char:FindFirstChildOfClass("ForceField") then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    return true
end

-- 순수 헤드 타겟 고정
local function get_hit_part(char, hitboxName)
    if not char then return nil end
    return char:FindFirstChild("HitboxHead") or char:FindFirstChild("Head")
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
-- ENGINE 1: vallkmult Original RageBot Engine (고급 머리+누운 자세 Ultra Desync)
-- ============================================================================
local currentRageTarget = nil
local isDesyncActive = false
local desyncConnection = nil
local desyncResetTask = nil

local function getClosestRageTarget()
    local myChar = LocalPlayer.Character
    if not myChar then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    local closest = nil
    local closestDist = math.huge
    local MAX_DISTANCE = 500

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not is_teammate(player) and get_character_valid(player) then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = (myRoot.Position - root.Position).Magnitude
                if dist <= MAX_DISTANCE and dist < closestDist then
                    closestDist = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

local function stopDesync()
    isDesyncActive = false
    if desyncConnection then
        desyncConnection:Disconnect()
        desyncConnection = nil
    end
end

local function startDesync(targetPlayer)
    if desyncConnection then desyncConnection:Disconnect() end
    isDesyncActive = true

    desyncConnection = RunService.Heartbeat:Connect(function()
        if not isDesyncActive or not (ragebotOrKillAura or ragebotMagicBullet) then return end
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local targetHead = targetPlayer.Character and (targetPlayer.Character:FindFirstChild("HitboxHead") or targetPlayer.Character:FindFirstChild("Head"))
        if not targetHead then
            stopDesync()
            return
        end

        local oldCFrame = myRoot.CFrame
        local oldVel = myRoot.AssemblyLinearVelocity or myRoot.Velocity
        local oldRotVel = myRoot.AssemblyAngularVelocity or myRoot.RotVelocity

        -- [고급 디싱크 기술] 적 머리 밀착 + 누운 자세(-90도 Pitch) + 마이크로 지터(서버 동기화 교란) + 속도 영점화
        local microJitter = Vector3.new((math.random() - 0.5) * 0.01, 0, (math.random() - 0.5) * 0.01)
        local headLyingCF = targetHead.CFrame * CFrame.new(0, 1.2, 0) * CFrame.Angles(math.rad(-90), 0, math.rad(math.random(-5, 5))) + microJitter

        myRoot.CFrame = headLyingCF
        if myRoot:IsA("BasePart") then
            myRoot.AssemblyLinearVelocity = Vector3.zero
            myRoot.AssemblyAngularVelocity = Vector3.zero
        end

        RunService:BindToRenderStep("__restore_vk", 101, function()
            myRoot.CFrame = oldCFrame
            if myRoot:IsA("BasePart") then
                myRoot.AssemblyLinearVelocity = oldVel
                myRoot.AssemblyAngularVelocity = oldRotVel
            end
            RunService:UnbindFromRenderStep("__restore_vk")
        end)
    end)
end

pcall(function()
    if GunModule and GunModule.StartShooting then
        local oldStartShooting = GunModule.StartShooting
        GunModule.StartShooting = function(self, ...)
            local ret = {oldStartShooting(self, ...)}
            if not self.ClientFighter or not self.ClientFighter.IsLocalPlayer then
                return unpack(ret)
            end

            local shootData = ret[3]
            if not shootData or type(shootData) ~= "table" then
                return unpack(ret)
            end

            ret[4] = true
            local target = currentRageTarget

            if not (ragebotOrKillAura or ragebotMagicBullet) or not target or not target.Character then
                return unpack(ret)
            end

            if not isDesyncActive then
                startDesync(target)
                task.wait(0.02)
            end

            if desyncResetTask then
                task.cancel(desyncResetTask)
                desyncResetTask = nil
            end

            -- 헤드 100% 정밀 타격 영점 조절
            local head = target.Character:FindFirstChild("HitboxHead") or target.Character:FindFirstChild("Head")
            if not head or not UtilityModule then return unpack(ret) end

            local headPos = head.Position
            local headCF = head.CFrame
            local originPos = headPos + Vector3.new(0, 1.2, 0)
            local lookCF = CFrame.lookAt(originPos, headPos)
            local randomOffset = headCF:ToObjectSpace(CFrame.new(headPos))

            shootData[utf8.char(0)] = UtilityModule:EncodeCFrame(CFrame.new(originPos, headPos) * CFrame.Angles(lookCF:ToOrientation()))
            shootData[utf8.char(1)] = UtilityModule:EncodeCFrame(CFrame.new(headPos) * CFrame.Angles(lookCF:ToOrientation()))
            shootData[utf8.char(2)] = head
            shootData[utf8.char(3)] = UtilityModule:EncodeCFrame(randomOffset)

            desyncResetTask = task.delay(0.12, function()
                stopDesync()
            end)

            return unpack(ret)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.01)
        if ragebotOrKillAura or ragebotMagicBullet then
            currentRageTarget = getClosestRageTarget()
        else
            currentRageTarget = nil
            stopDesync()
        end
    end
end)

-- ============================================================================
-- ENGINE 2: Vallk Independent RageBot & Crosshair UI Engine
-- ============================================================================
local RageUIGui = Instance.new("ScreenGui", PlayerGui)
RageUIGui.Name = "VallkRageUI"
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
RageTextLabel.Text = "(vallk ragebot:in the void...^^)"
RageTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
RageTextLabel.TextStrokeTransparency = 0
RageTextLabel.Font = Enum.Font.GothamBold
RageTextLabel.TextSize = 13
RageTextLabel.TextXAlignment = Enum.TextXAlignment.Center
RageTextLabel.Visible = false

local rageHue = 0
local rotAngle = 0
RunService.RenderStepped:Connect(function()
    RageTextLabel.Visible = CrosshairContainer.Visible or ragebotOrKillAura or ragebotMagicBullet
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

        local activeTarget = currentRageTarget or (HoNyangEngine and HoNyangEngine.target)
        if activeTarget and activeTarget.Name then
            RageTextLabel.Text = "(Vallk ragebot kill " .. activeTarget.Name .. ")"
        else
            RageTextLabel.Text = "(vallk ragebot:in the void...^^)"
        end
    end
end)

-- Vallk 독자 레이지봇 Class (개선된 머리+누운 자세 적용)
local HoNyangEngine = {}
do
    local function isImmune(char, player)
        if not char then return true end
        if char:FindFirstChildOfClass("ForceField") then return true end
        if player then
            local spawnTime = player:GetAttribute("SpawnTime") or 0
            if tick() - spawnTime < 1.5 then return true end
        end
        return false
    end

    function HoNyangEngine:init()
        self.active = false
        self.target = nil
        self.desync = false
        self.conn1 = nil
        self.conn2 = nil
        self.task1 = nil
        self.activateTime = 0
        self:setup()
    end

    function HoNyangEngine:setup()
        self.conn1 = RunService.Heartbeat:Connect(function()
            if not self.active then return end
            self.target = self:findTarget()
        end)

        pcall(function()
            if GunModule and GunModule.StartShooting then
                local oldFunc = GunModule.StartShooting
                GunModule.StartShooting = function(selfObj, ...)
                    local ret = {oldFunc(selfObj, ...)}
                    if not self.active then return unpack(ret) end

                    if tick() - self.activateTime < 1.4 then return unpack(ret) end
                    if not selfObj.ClientFighter or not selfObj.ClientFighter.IsLocalPlayer then return unpack(ret) end

                    local shootData = ret[3]
                    if not shootData or typeof(shootData) ~= "table" then return unpack(ret) end

                    local target = self.target
                    if not target or not target.Character or isImmune(target.Character, target) then return unpack(ret) end

                    ret[4] = true
                    if not self.desync or self.curr ~= target then
                        self:startDesync(target)
                    end

                    if self.task1 then
                        task.cancel(self.task1)
                        self.task1 = nil
                    end

                    local head = target.Character:FindFirstChild("HitboxHead") or target.Character:FindFirstChild("Head")
                    if not head or not UtilityModule then return unpack(ret) end

                    local headCF = head.CFrame
                    local offset = headCF:ToObjectSpace(CFrame.new(head.Position))

                    shootData[utf8.char(0)] = UtilityModule:EncodeCFrame(headCF)
                    shootData[utf8.char(1)] = UtilityModule:EncodeCFrame(headCF)
                    shootData[utf8.char(2)] = head
                    shootData[utf8.char(3)] = UtilityModule:EncodeCFrame(offset)

                    self.task1 = task.delay(0.04, function()
                        self:stopDesync()
                    end)

                    return unpack(ret)
                end
            end
        end)
    end

    function HoNyangEngine:findTarget()
        local myChar = LocalPlayer.Character
        if not myChar then return nil end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
       
        local closest = nil
        local closestDist = math.huge

        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer or is_teammate(player) then continue end
            local char = player.Character
            if not char or isImmune(char, player) then continue end

            local head = char:FindFirstChild("HitboxHead") or char:FindFirstChild("Head")
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if not (head and hum and hum.Health > 0) then continue end
           
            local dist = (myRoot.Position - head.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = player
            end
        end
        return closest
    end

    function HoNyangEngine:startDesync(targetPlayer)
        if self.conn2 then self.conn2:Disconnect() end
        self.desync = true
        self.curr = targetPlayer

        self.conn2 = RunService.Heartbeat:Connect(function()
            if not self.desync then return end
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end

            if not targetPlayer.Character or isImmune(targetPlayer.Character, targetPlayer) then
                self:stopDesync()
                return
            end

            local enemyHead = targetPlayer.Character:FindFirstChild("HitboxHead") or targetPlayer.Character:FindFirstChild("Head")
            if not enemyHead then
                self:stopDesync()
                return
            end

            local oldCF = myRoot.CFrame
            local oldVel = myRoot.AssemblyLinearVelocity or myRoot.Velocity
            local oldRot = myRoot.AssemblyAngularVelocity or myRoot.RotVelocity

            -- 머리 위 누운 자세 (-90도 회전 및 밀착 위치)
            myRoot.CFrame = enemyHead.CFrame * CFrame.new(0, 1.2, 0) * CFrame.Angles(math.rad(-90), 0, 0)
            if myRoot:IsA("BasePart") then
                myRoot.AssemblyLinearVelocity = Vector3.zero
                myRoot.AssemblyAngularVelocity = Vector3.zero
            end

            RunService:BindToRenderStep("__restore_hn", 1, function()
                myRoot.CFrame = oldCF
                if myRoot:IsA("BasePart") then
                    myRoot.AssemblyLinearVelocity = oldVel
                    myRoot.AssemblyAngularVelocity = oldRot
                end
                RunService:UnbindFromRenderStep("__restore_hn")
            end)
        end)
    end

    function HoNyangEngine:stopDesync()
        self.desync = false
        self.curr = nil
        if self.conn2 then
            self.conn2:Disconnect()
            self.conn2 = nil
        end
    end

    function HoNyangEngine:SetState(state)
        self.active = state
        CrosshairContainer.Visible = state
        if state then
            self.activateTime = tick()
            task.spawn(function()
                while self.active do
                    self.activateTime = tick()
                    task.wait(1.4)
                    local lastShoot = 0
                    while self.active do
                        local myChar = LocalPlayer.Character
                        if not myChar or not myChar:FindFirstChild("Humanoid") or myChar.Humanoid.Health <= 0 then break end

                        local now = tick()
                        if now - lastShoot >= 0.04 then
                            lastShoot = now
                            pcall(function()
                                if self.target and self.target.Character and not isImmune(self.target.Character, self.target) then
                                    local tool = myChar:FindFirstChildOfClass("Tool")
                                    if tool then tool:Activate() end
                                    local vim = game:GetService("VirtualInputManager")
                                    vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                                    task.wait()
                                    vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                                end
                            end)
                        end
                        task.wait()
                    end
                end
            end)
        else
            self:stopDesync()
        end
    end

    HoNyangEngine:init()
end

-- ============================================================================
-- SECTION: Vallk Fast Melee & Cooldown 0 Loops
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
-- SECTION: Magic Bullet, Gun Hooking & All Skins
-- ============================================================================
pcall(function()
    if FighterController and FighterController.LocalFighter and FighterController.LocalFighter.GetMouseLocation then
        local LocalFighter = FighterController.LocalFighter
        local oldMouseLoc = LocalFighter.GetMouseLocation
        LocalFighter.GetMouseLocation = newcclosure(function(...)
            if silentAimTarget and (silentAimEnabled or ragebotOrKillAura or ragebotMagicBullet) then
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
    if (silentAimEnabled or ragebotOrKillAura or ragebotMagicBullet) and myChar then
        local closestDist = math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not is_teammate(player) and get_character_valid(player) then
                local hitPart = get_hit_part(player.Character, "head")
                if hitPart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hitPart.Position)
                    if onScreen then
                        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        local maxFov = (ragebotOrKillAura or ragebotMagicBullet) and 99999 or silentAimFovRadius
                        
                        if screenDist <= maxFov and screenDist < closestDist then
                            if ragebotMagicBullet or (not silentWallCheck) or has_line_of_sight(hitPart, myChar) then
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
-- SECTION: User Interface (Mobile Optimized, Draggable & Dual Engine Integrated)
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
    title.Text = "vallkmult x Vallk Hub"
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
    tabLay.Padding = UDim.new(0, 4)

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
        b.Size = UDim2.new(0.185, 0, 1, 0)
        b.BackgroundColor3 = TAB_BG
        b.BorderSizePixel = 0
        b.Text = name
        b.TextColor3 = Color3.fromRGB(150, 155, 160)
        b.Font = Enum.Font.Code
        b.TextSize = 10
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

    -- 탭 구성
    addTab("Main")
    addTab("Ragebot")
    addTab("ESP")
    addTab("Misc")
    addTab("UI Set")

    -- Main Tab
    toggle(pages["Main"], "Silent Aim", function() return silentAimEnabled end, function(v) silentAimEnabled = v end)
    toggle(pages["Main"], "Aimbot", function() return aimbotEnabled end, function(v) aimbotEnabled = v end)
    toggle(pages["Main"], "Vallk 빠름근접", function() return fastMeleeEnabled end, function(v) fastMeleeEnabled = v end)
    toggle(pages["Main"], "Vallk총알속도 0", function() return hoNyangNoCDEnabled end, function(v) hoNyangNoCDEnabled = v end)
    toggle(pages["Main"], "No Recoil", function() return noRecoilEnabled end, function(v) noRecoilEnabled = v end)
    toggle(pages["Main"], "No Spread", function() return noSpreadEnabled end, function(v) noSpreadEnabled = v end)
    toggle(pages["Main"], "Rapid Fire", function() return rapidFireEnabled end, function(v) rapidFireEnabled = v end)

    -- Ragebot Tab (3개 레이지봇 상호 배타적 동작 처리)
    toggle(pages["Ragebot"], "vallkv1 ragebot", function() return hoNyangRageEnabled end, function(v) 
        hoNyangRageEnabled = v 
        if v then
            ragebotOrKillAura = false
            ragebotMagicBullet = false
        end
        if HoNyangEngine then HoNyangEngine:SetState(v) end
    end)
    toggle(pages["Ragebot"], "[vallkmult] Rage Bot Aim (Desync)", function() return ragebotOrKillAura end, function(v) 
        ragebotOrKillAura = v 
        if v then
            hoNyangRageEnabled = false
            if HoNyangEngine then HoNyangEngine:SetState(false) end
            ragebotMagicBullet = false
        end
    end)
    toggle(pages["Ragebot"], "[vallkmult] Magic Bullet", function() return ragebotMagicBullet end, function(v) 
        ragebotMagicBullet = v 
        if v then
            hoNyangRageEnabled = false
            if HoNyangEngine then HoNyangEngine:SetState(false) end
            ragebotOrKillAura = false
        end
    end)

    -- ESP Tab
    toggle(pages["ESP"], "ESP Master Toggle", function() return espEnabled end, function(v) espEnabled = v end)
    toggle(pages["ESP"], "ESP Boxes", function() return espBoxEnabled end, function(v) espBoxEnabled = v end)
    toggle(pages["ESP"], "ESP Names", function() return espNameEnabled end, function(v) espNameEnabled = v end)
    toggle(pages["ESP"], "ESP Health", function() return espHealthEnabled end, function(v) espHealthEnabled = v end)
    toggle(pages["ESP"], "Gun Tracer Line", function() return gunTracerEnabled end, function(v) gunTracerEnabled = v end)

    -- Misc Tab
    toggle(pages["Misc"], "Unlock All Skins (올스킨)", function() return skinChangerEnabled end, function(v) skinChangerEnabled = v end)
    toggle(pages["Misc"], "Bullet Speed Boost (100k)", function() return bulletSpeedBoost end, function(v) bulletSpeedBoost = v end)
    toggle(pages["Misc"], "Rapid Speed (스피드 핵)", function() return rapidSpeedEnabled end, function(v) rapidSpeedEnabled = v end)
    toggle(pages["Misc"], "PC Fly (WASD)", function() return pcFlyEnabled end, function(v) pcFlyEnabled = v end)
    toggle(pages["Misc"], "Noclip", function() return noclipEnabled end, function(v) noclipEnabled = v end)

    -- UI Set Tab
    toggle(pages["UI Set"], "Circle Crosshair (Gradient)", function() return circleCrosshairEnabled end, function(v) circleCrosshairEnabled = v end)
    toggle(pages["UI Set"], "Custom Skybox", function() return customSkyboxEnabled end, function(v) customSkyboxEnabled = v; applySkybox() end)

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

print("[vallkmult x Vallk Dual-Rage Edition] Loaded Successfully.")
