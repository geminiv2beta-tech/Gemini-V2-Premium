-- ============================================================================
-- RayV3 Public Beta build // Complete Script with Key System & All Features (Updated)
-- ============================================================================

local plrs = game:GetService("Players")
repeat task.wait() until plrs.LocalPlayer
local lplr = plrs.LocalPlayer

local repS = game:GetService("ReplicatedStorage")
local runS = game:GetService("RunService")
local ws = game:GetService("Workspace")
local http = game:GetService("HttpService")
local userInput = game:GetService("UserInputService")

local playerScripts = lplr:WaitForChild("PlayerScripts")
local controllers = playerScripts:WaitForChild("Controllers")

-- [무작위 문자열 생성 유틸리티]
local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
local function randomString(length)
    local result = ""
    math.randomseed(tick() * math.random(1000, 9999))
    for i = 1, length do
        local rand = math.random(1, #chars)
        result = result .. chars:sub(rand, rand)
    end
    return result
end

-- [0. UI Parent 및 최적화]
local successParent, coreGuiParent = pcall(function()
    if gethui then 
        return gethui() 
    else 
        return game:GetService("CoreGui") 
    end
end)

if not successParent or not coreGuiParent then
    coreGuiParent = lplr:WaitForChild("PlayerGui")
end

-- ============================================================================
-- [KEY SYSTEM] 키 시스템 및 디스코드 인증 UI
-- ============================================================================
local validKey = "Paid_masterkey-premium310086"
local discordLink = "https://discord.gg/C5Cvb4GnD"

local keyGui = Instance.new("ScreenGui")
keyGui.Name = "RayV3_KeySystem_" .. randomString(6)
keyGui.ResetOnSpawn = false
keyGui.IgnoreGuiInset = true
keyGui.Parent = coreGuiParent

local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 320, 0, 190)
keyFrame.Position = UDim2.new(0.5, -160, 0.5, -95)
keyFrame.BackgroundColor3 = Color3.fromRGB(13, 16, 23)
keyFrame.BorderSizePixel = 0
keyFrame.Active = true
keyFrame.Draggable = true
keyFrame.Parent = keyGui

local kCorner = Instance.new("UICorner") kCorner.CornerRadius = UDim.new(0, 6) kCorner.Parent = keyFrame
local kStroke = Instance.new("UIStroke") kStroke.Thickness = 1.4 kStroke.Color = Color3.fromRGB(255, 0, 100) kStroke.Parent = keyFrame

local kTitle = Instance.new("TextLabel")
kTitle.Size = UDim2.new(1, 0, 0, 30)
kTitle.BackgroundTransparency = 1
kTitle.Text = "RayV3 Public Beta build // Key System"
kTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
kTitle.Font = Enum.Font.Code
kTitle.TextSize = 10
kTitle.Parent = keyFrame

local kBox = Instance.new("TextBox")
kBox.Size = UDim2.new(1, -30, 0, 32)
kBox.Position = UDim2.new(0, 15, 0, 42)
kBox.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
kBox.PlaceholderText = "Enter your key here..."
kBox.Text = ""
kBox.TextColor3 = Color3.fromRGB(255, 255, 255)
kBox.PlaceholderColor3 = Color3.fromRGB(100, 110, 130)
kBox.Font = Enum.Font.Code
kBox.TextSize = 10
kBox.Parent = keyFrame

local kbCorner = Instance.new("UICorner") kbCorner.CornerRadius = UDim.new(0, 4) kbCorner.Parent = kBox
local kbStroke = Instance.new("UIStroke") kbStroke.Color = Color3.fromRGB(255, 0, 100) kbStroke.Thickness = 1 kbStroke.Parent = kBox

local verifyBtn = Instance.new("TextButton")
verifyBtn.Size = UDim2.new(0.47, 0, 0, 32)
verifyBtn.Position = UDim2.new(0, 15, 0, 84)
verifyBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 60)
verifyBtn.Text = "확인 (Verify)"
verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyBtn.Font = Enum.Font.Code
verifyBtn.TextSize = 10
verifyBtn.Parent = keyFrame

local vbCorner = Instance.new("UICorner") vbCorner.CornerRadius = UDim.new(0, 4) vbCorner.Parent = verifyBtn
local vbStroke = Instance.new("UIStroke") vbStroke.Color = Color3.fromRGB(255, 0, 100) vbStroke.Thickness = 1 vbStroke.Parent = verifyBtn

local getKeyBtn = Instance.new("TextButton")
getKeyBtn.Size = UDim2.new(0.47, 0, 0, 32)
getKeyBtn.Position = UDim2.new(0.51, 0, 0, 84)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
getKeyBtn.Text = "키스탬 얻기 (Discord)"
getKeyBtn.TextColor3 = Color3.fromRGB(140, 170, 210)
getKeyBtn.Font = Enum.Font.Code
getKeyBtn.TextSize = 9
getKeyBtn.Parent = keyFrame

local gbCorner = Instance.new("UICorner") gbCorner.CornerRadius = UDim.new(0, 4) gbCorner.Parent = getKeyBtn
local gbStroke = Instance.new("UIStroke") gbStroke.Color = Color3.fromRGB(25, 35, 50) gbStroke.Thickness = 1 gbStroke.Parent = getKeyBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -30, 0, 28)
statusLabel.Position = UDim2.new(0, 15, 0, 126)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
statusLabel.Font = Enum.Font.Code
statusLabel.TextSize = 9
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.TextWrapped = true
statusLabel.Parent = keyFrame

getKeyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard(discordLink)
        end
    end)
    pcall(function()
        if syn and syn.request then
            syn.request({Url = discordLink, Method = "GET"})
        elseif request then
            request({Url = discordLink, Method = "GET"})
        end
    end)
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 180)
    statusLabel.Text = "디스코드 링크가 복사되었습니다! 가입 후 키를 입력하세요."
end)

local keyPassed = false
local function verifyKey()
    if kBox.Text == validKey then
        keyPassed = true
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 180)
        statusLabel.Text = "확인! RayV3 Public Beta 로딩 중..."
        task.wait(0.6)
        keyGui:Destroy()
    else
        statusLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
        statusLabel.Text = "잘못된 키입니다. 다시 확인해주세요."
    end
end

verifyBtn.MouseButton1Click:Connect(verifyKey)
kBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        verifyKey()
    end
end)

repeat task.wait() until keyPassed

-- ============================================================================
-- [1. 안티치트 우회 시스템]
pcall(function()
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
    
    if hookmetamethod then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" and self == lplr then
                return
            end
            if method == "FireServer" and self and self.Name and (self.Name:lower():find("anticheat") or self.Name:lower():find("ban") or self.Name:lower():find("report") or self.Name:lower():find("kickhook")) then
                return
            end
            return oldNamecall(self, ...)
        end)
    end
end)

-- [2. 환경설정 데이터]
getgenv().Config = {
    Enabled = true,          
    SilentAim = false,       
    Aimbot = false,          
    Triggerbot = false,      
    RageBot = false,         
    
    AimbotSmoothness = 1.0, 
    AimbotHitRate = 100,      -- 에임봇 명중률 설정 (1~100%)
    FireRate = 0.0001,
    RapidFire = false,     
    AutoFire = false,
    AllHead = false,         
    WallCheck = false,
    Wallbang = false,        
    BodyTeleport = false,   
    DesyncView = false,     
    AntiShot = false,       
    
    BulletSpeedBoost = false,
    BulletSpeedMultiplier = 100000,
    
    VoidRangeX = 150,
    VoidRangeY = 150,
    VoidRangeZ = 150,
    VoidBaseY = 2,           
    VoidSpam = false,
    HeightTime = 0.005,     
    AttackTime = 0.0002,     
    HitNotifyDuration = 4.0, 

    ShowFOV = false,
    FOVRadius = 9999,      
    Prediction = false,     
    OriginSpoof = false,
    
    CircleCrosshair = false,
    CircleCrosshairSize = 60,
    CircleRotationSpeed = 4,
    CircleFillColor = Color3.fromRGB(180, 140, 230),
    CircleFillTransparency = 0.75, 
    
    GunTracer = false,
    CornerBoxESP = false,
    NameESP = false,
    HealthESP = false,
    HitNotify = false,          
    PlayerDamageText = false,   
    RageBotCenterText = false,  
    NoRecoil = false,
    NoSpread = false,
    AntiCheatBypass = true,
    AllSkins = false,
    
    Fly = false,
    Noclip = false,
    FlySpeed = 70,
    MobileFriendly = true
}

local util, enum, FighterController, SpectateController, CameraController
pcall(function()
    util = require(repS.Modules.Utility)
    enum = require(repS.Modules.EnumLibrary)
    if enum then pcall(function() enum:WaitForEnumBuilder() end) end
    FighterController = require(lplr.PlayerScripts.Controllers.FighterController)
    SpectateController = require(lplr.PlayerScripts.Controllers:WaitForChild("SpectateController"))
    CameraController = require(lplr.PlayerScripts.Controllers:WaitForChild("CameraController"))
end)

-- [360도 타겟 트래킹 모듈]
local TrackedFighters = {}
local FighterControllerHooked = false

local function registerFighter(fighter)
    local player = fighter and fighter.Player
    if not player or player == lplr then return end
    TrackedFighters[player] = fighter
end

local function unregisterFighter(fighter)
    local player = fighter and fighter.Player
    if not player then return end
    if TrackedFighters[player] == fighter then
        TrackedFighters[player] = nil
    end
end

local function ensureTargetTracking()
    if not FighterControllerHooked then
        if FighterController then
            for _, fighter in ipairs(FighterController.Objects or {}) do
                registerFighter(fighter)
            end
            if FighterController.ObjectAdded and type(FighterController.ObjectAdded.Connect) == 'function' then
                FighterController.ObjectAdded:Connect(registerFighter)
            end
            if FighterController.ObjectRemoved and type(FighterController.ObjectRemoved.Connect) == 'function' then
                FighterController.ObjectRemoved:Connect(unregisterFighter)
            end
            FighterControllerHooked = true
        end
    end
end

local function isEnemy(player)
    if player == lplr then return false end
    pcall(function()
        local duel = SpectateController and SpectateController.CurrentDuelSubject
        local localDueler = duel and duel:GetDueler(lplr)
        local localTeam = localDueler and localDueler:Get("TeamID") or nil
        if localTeam and duel and duel.Duelers then
            for _, dueler in pairs(duel.Duelers) do
                if dueler.Player == player then
                    local team = dueler:Get("TeamID")
                    return team ~= localTeam
                end
            end
        end
    end)
    local pTeam = player:GetAttribute("TeamID")
    local lTeam = lplr:GetAttribute("TeamID")
    if pTeam and lTeam then return pTeam ~= lTeam end
    return true
end

local function getClosestTarget()
    ensureTargetTracking()
    local char = lplr.Character
    if not char then return nil, nil, nil end
    local cam = ws.CurrentCamera
    if not cam then return nil, nil, nil end
    local camPos = cam.CFrame.Position
    
    local closestPart, closestPlayer = nil, nil
    local closestDist = math.huge

    for player, _ in pairs(TrackedFighters) do
        if not isEnemy(player) then continue end
        local pChar = player.Character
        local pHead = pChar and pChar:FindFirstChild("Head")
        local pHum = pChar and pChar:FindFirstChildWhichIsA("Humanoid")
        if pHead and pHum and pHum.Health > 0 then
            local dist = (pHead.Position - camPos).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestPart = pHead
                closestPlayer = player
            end
        end
    end

    if not closestPlayer then
        for _, player in pairs(plrs:GetPlayers()) do
            if isEnemy(player) then
                local pChar = player.Character
                local pHead = pChar and pChar:FindFirstChild("Head")
                local pHum = pChar and pChar:FindFirstChildWhichIsA("Humanoid")
                if pHead and pHum and pHum.Health > 0 then
                    local dist = (pHead.Position - camPos).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPart = pHead
                        closestPlayer = player
                    end
                end
            end
        end
    end

    return closestPlayer, closestPart, closestPart
end

local cachedTargetPlayer, cachedTargetRoot, cachedTargetHead = nil, nil, nil
local lastTargetCacheTick = 0
local function getCachedClosestTarget()
    local now = tick()
    if now - lastTargetCacheTick < 0.005 then
        return cachedTargetPlayer, cachedTargetRoot, cachedTargetHead
    end
    lastTargetCacheTick = now
    cachedTargetPlayer, cachedTargetHead = getClosestTarget()
    cachedTargetRoot = cachedTargetPlayer and cachedTargetPlayer.Character and cachedTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
    return cachedTargetPlayer, cachedTargetRoot, cachedTargetHead
end

-- [강화된 사일런트 에임 & 월뱅 탄환 패킷 엔진]
pcall(function()
    local __a1b2c3 = setmetatable({}, {
        __index = function(__d4e5f6, __g7h8i9)
            local __j0k1l2, __m3n4o5 = pcall(function()
                return game:GetService(__g7h8i9)
            end)
            if __m3n4o5 then
                return cloneref(__m3n4o5)
            end
            return nil
        end
    })

    local __p6q7r8 = getgenv()
    if __p6q7r8.__s9t0u1 then
        __p6q7r8.__s9t0u1:Shutdown()
    end

    local __v2w3x4 = __a1b2c3.Players
    local __y5z6a7 = __a1b2c3.RunService
    local __b8c9d0 = __a1b2c3.ReplicatedStorage
    local __k7l8m9 = __v2w3x4.LocalPlayer
    local __q3r4s5 = __k7l8m9.PlayerScripts
    local __t6u7v8 = require(__q3r4s5.Modules.ItemTypes.Gun)
    local __w9x0y1 = require(__b8c9d0.Modules.Utility)

    local __z2a3b4 = setmetatable({}, {
        __index = function(_, __c5d6e7)
            local __f8g9h0 = __k7l8m9.Character
            if not __f8g9h0 then return nil end
            if __c5d6e7 == "__root" then
                return __f8g9h0:FindFirstChild("HumanoidRootPart")
            elseif __c5d6e7 == "__head" then
                return __f8g9h0:FindFirstChild("Head")
            end
            return nil
        end
    })

    __p6q7r8.__s9t0u1 = {}

    do
        local __i1j2k3 = __p6q7r8.__s9t0u1

        function __i1j2k3:__init()
            self.__active = true
            self.__target = nil
            self.__desync = false
            self.__conn1 = nil
            self.__conn2 = nil
            self.__task1 = nil
            self.__oldfunc = nil
            self:__setup()
        end

        function __i1j2k3:__setup()
            self.__conn1 = __y5z6a7.Heartbeat:Connect(function()
                local isActive = getgenv().Config.SilentAim or getgenv().Config.RageBot or getgenv().Config.Triggerbot
                if not isActive then 
                    self.__target = nil
                    return 
                end
                self.__target = self:__find()
            end)

            local __l4m5n6 = __t6u7v8.StartShooting
            self.__oldfunc = __l4m5n6
            __t6u7v8.StartShooting = function(__o7p8q9, ...)
                local isSilentActive = getgenv().Config.SilentAim or getgenv().Config.RageBot or getgenv().Config.Triggerbot
                if not isSilentActive then
                    return __l4m5n6(__o7p8q9, ...)
                end

                local hitChance = getgenv().Config.AimbotHitRate or 100
                if math.random(1, 100) > hitChance then
                    return __l4m5n6(__o7p8q9, ...)
                end

                local __r0s1t2 = {__l4m5n6(__o7p8q9, ...)}
                if not __o7p8q9.ClientFighter or not __o7p8q9.ClientFighter.IsLocalPlayer then
                    return unpack(__r0s1t2)
                end

                local __u3v4w5 = __r0s1t2[3]
                if not __u3v4w5 or typeof(__u3v4w5) ~= "table" then
                    return unpack(__r0s1t2)
                end

                __r0s1t2[4] = true
                local __x6y7z8 = self.__target

                if not __x6y7z8 or not __x6y7z8.Character then
                    local tPlayer, _, _ = getClosestTarget()
                    if tPlayer then
                        __x6y7z8 = tPlayer
                        self.__target = tPlayer
                    end
                end

                if not __x6y7z8 or not __x6y7z8.Character then
                    return unpack(__r0s1t2)
                end

                if (getgenv().Config.DesyncView or getgenv().Config.RageBot or getgenv().Config.Wallbang) and (not self.__desync or self.__curr ~= __x6y7z8) then
                    self:__desync_start(__x6y7z8)
                end

                if self.__task1 then
                    task.cancel(self.__task1)
                    self.__task1 = nil
                end

                local targetPart = __x6y7z8.Character:FindFirstChild("Head")
                if not targetPart or not getgenv().Config.AllHead then
                    targetPart = __x6y7z8.Character:FindFirstChild("HumanoidRootPart") or __x6y7z8.Character:FindFirstChild("Head")
                end
                
                if targetPart then
                    local hitPos = targetPart.Position
                    local targetCF = targetPart.CFrame
                    
                    local launchPos = hitPos - (targetCF.LookVector * 0.2) - Vector3.new(0, 0.1, 0)
                    local lookCF = CFrame.lookAt(launchPos, hitPos)
                    local relCF = targetCF:ToObjectSpace(CFrame.new(hitPos))

                    __u3v4w5[utf8.char(0)] = __w9x0y1:EncodeCFrame(CFrame.new(launchPos, hitPos) * CFrame.Angles(lookCF:ToOrientation()))
                    __u3v4w5[utf8.char(1)] = __w9x0y1:EncodeCFrame(CFrame.new(hitPos) * CFrame.Angles(lookCF:ToOrientation()))
                    __u3v4w5[utf8.char(2)] = targetPart
                    __u3v4w5[utf8.char(3)] = __w9x0y1:EncodeCFrame(relCF)
                end

                self.__task1 = task.delay(0.15, function()
                    self:__desync_stop()
                end)

                return unpack(__r0s1t2)
            end
        end

        function __i1j2k3:__find()
            local closestPlayer, _, _ = getClosestTarget()
            return closestPlayer
        end

        function __i1j2k3:__desync_start(__c3d4e5)
            if not getgenv().Config.DesyncView and not getgenv().Config.RageBot and not getgenv().Config.Wallbang then return end
            if self.__conn2 then self.__conn2:Disconnect() end
            self.__desync = true
            self.__curr = __c3d4e5

            self.__conn2 = __y5z6a7.Heartbeat:Connect(function()
                if not self.__desync then return end
                local __f6g7h8 = __z2a3b4.__root
                if not __f6g7h8 then return end

                local __i9j0k1 = __c3d4e5.Character and __c3d4e5.Character:FindFirstChild("HumanoidRootPart")
                if not __i9j0k1 then
                    self:__desync_stop()
                    return
                end

                local __l2m3n4 = __f6g7h8.CFrame
                local __o5p6q7 = __f6g7h8.AssemblyLinearVelocity
                local __r8s9t0 = __f6g7h8.AssemblyAngularVelocity

                __f6g7h8.CFrame = __i9j0k1.CFrame * CFrame.new(0, -(getgenv().Config.VoidBaseY or 2), 0)

                __y5z6a7:BindToRenderStep("__restore", 101, function()
                    __f6g7h8.CFrame = __l2m3n4
                    __f6g7h8.AssemblyLinearVelocity = __o5p6q7
                    __f6g7h8.AssemblyAngularVelocity = __r8s9t0
                    __y5z6a7:UnbindFromRenderStep("__restore")
                end)
            end)
        end

        function __i1j2k3:__desync_stop()
            self.__desync = false
            self.__curr = nil
            if self.__conn2 then
                self.__conn2:Disconnect()
                self.__conn2 = nil
            end
        end

        function __i1j2k3:Shutdown()
            self.__active = false
            if self.__conn1 then self.__conn1:Disconnect() end
            if self.__conn2 then self.__conn2:Disconnect() end
            if self.__task1 then task.cancel(self.__task1) end
            if self.__oldfunc then
                __t6u7v8.StartShooting = self.__oldfunc
            end
        end

        __i1j2k3:__init()
    end
end)

-- [올스킨 언로커]
pcall(function()
    local EnumLibrary = require(repS.Modules:WaitForChild("EnumLibrary", 10))
    if EnumLibrary then EnumLibrary:WaitForEnumBuilder() end
    local CosmeticLibrary = require(repS.Modules:WaitForChild("CosmeticLibrary", 10))
    local DataController = require(controllers:WaitForChild("PlayerDataController", 10))

    CosmeticLibrary.OwnsCosmeticNormally = function(self, inventory, name, weapon) if not getgenv().Config.AllSkins then return originalOwnsCosmeticNormally(self, inventory, name, weapon) end return true end
    CosmeticLibrary.OwnsCosmeticUniversally = function(self, inventory, name, weapon) if not getgenv().Config.AllSkins then return false end return true end
    CosmeticLibrary.OwnsCosmeticForWeapon = function(self, inventory, name, weapon) if not getgenv().Config.AllSkins then return false end return true end
    CosmeticLibrary.OwnsCosmetic = function(self, inventory, name, weapon) if not getgenv().Config.AllSkins then return false end return true end

    local originalGet = DataController.Get
    DataController.Get = function(self, key)
        local data = originalGet(self, key)
        if getgenv().Config.AllSkins then
            if key == "CosmeticInventory" then
                local proxy = {}
                if data then for k, v in pairs(data) do proxy[k] = v end end
                return setmetatable(proxy, {__index = function(t, k) return true end})
            end
            if key == "FavoritedCosmetics" then
                return data and table.clone(data) or {}
            end
        end
        return data
    end
end)

-- [3. 이미지 참조 스타일: 블루 -> 핑크/퍼플 회전 그라데이션 원형 조준선 및 채우기 렌더링]
local SEGMENT_COUNT = 32
local circleSegments = {}

local circleFill = Drawing.new("Circle")
circleFill.Thickness = 0
circleFill.NumSides = 64
circleFill.Filled = true
circleFill.Transparency = getgenv().Config.CircleFillTransparency or 0.75
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

    if factor < 0.25 then
        return blue:Lerp(lightBlue, factor * 4)
    elseif factor < 0.5 then
        return lightBlue:Lerp(lightPink, (factor - 0.25) * 4)
    elseif factor < 0.75 then
        return lightPink:Lerp(pink, (factor - 0.5) * 4)
    else
        return pink:Lerp(blue, (factor - 0.75) * 4)
    end
end

local tracerLine = Drawing.new("Line")
tracerLine.Thickness = 1.5
tracerLine.Transparency = 0.8
tracerLine.Visible = false

runS.RenderStepped:Connect(function()
    local cam = ws.CurrentCamera
    if not cam then return end

    if getgenv().Config.CircleCrosshair then
        local centerPos = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        local radius = math.clamp(tonumber(getgenv().Config.CircleCrosshairSize) or 60, 1, 600)
        local rotSpeed = tonumber(getgenv().Config.CircleRotationSpeed) or 4
        local currentRot = (tick() * rotSpeed) % (math.pi * 2)

        circleFill.Position = centerPos
        circleFill.Radius = radius
        circleFill.Color = getGradientColor((currentRot / (math.pi * 2)) % 1)
        circleFill.Transparency = getgenv().Config.CircleFillTransparency or 0.75
        circleFill.Visible = true

        for i = 1, SEGMENT_COUNT do
            local line = circleSegments[i]
            local angle1 = currentRot + ((i - 1) / SEGMENT_COUNT) * (math.pi * 2)
            local angle2 = currentRot + (i / SEGMENT_COUNT) * (math.pi * 2)

            local p1 = centerPos + Vector2.new(math.cos(angle1) * radius, math.sin(angle1) * radius)
            local p2 = centerPos + Vector2.new(math.cos(angle2) * radius, math.sin(angle2) * radius)

            line.From = p1
            line.To = p2
            line.Color = getGradientColor((i - 1) / SEGMENT_COUNT)
            line.Visible = true
        end
    else
        circleFill.Visible = false
        for _, line in ipairs(circleSegments) do
            line.Visible = false
        end
    end

    local targetPlayer, _, targetHead = getCachedClosestTarget()
    if getgenv().Config.GunTracer and targetHead then
        local screenPos, onScreen = cam:WorldToViewportPoint(targetHead.Position)
        if onScreen then
            local localChar = lplr.Character
            local tool = localChar and localChar:FindFirstChildOfClass("Tool")
            local gunPart = tool and (tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")) or (localChar and localChar:FindFirstChild("RightHand"))
            if gunPart then
                local gunScreenPos, gunOnScreen = cam:WorldToViewportPoint(gunPart.Position)
                if gunOnScreen then
                    tracerLine.Visible = true
                    tracerLine.From = Vector2.new(gunScreenPos.X, gunScreenPos.Y)
                    tracerLine.To = Vector2.new(screenPos.X, screenPos.Y)
                    tracerLine.Color = Color3.fromRGB(0, 255, 180)
                else
                    tracerLine.Visible = false
                end
            else
                tracerLine.Visible = false
            end
        else
            tracerLine.Visible = false
        end
    else
        tracerLine.Visible = false
    end
end)

-- [4. 모바일 화면 최적화 데미지 텍스트 알림 시스템]
local hitLogGuiContainer = Instance.new("ScreenGui")
hitLogGuiContainer.Name = "RayV3_MobileHitLogGui_" .. randomString(6)
hitLogGuiContainer.ResetOnSpawn = false
hitLogGuiContainer.IgnoreGuiInset = true
hitLogGuiContainer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
hitLogGuiContainer.Parent = coreGuiParent

local hitLogFrame = Instance.new("Frame")
hitLogFrame.Size = UDim2.new(0, 240, 0, 200)
hitLogFrame.Position = UDim2.new(1, -245, 0.30, 0)
hitLogFrame.BackgroundTransparency = 1
hitLogFrame.ZIndex = 10
hitLogFrame.Parent = hitLogGuiContainer

local function showHitNotification(targetName, damageAmount)
    if not getgenv().Config.HitNotify and not getgenv().Config.PlayerDamageText then return end
    pcall(function()
        local notifLabel = Instance.new("TextLabel")
        notifLabel.Size = UDim2.new(1, 0, 0, 28)
        notifLabel.Position = UDim2.new(0, 0, 1, -30)
        notifLabel.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
        notifLabel.BackgroundTransparency = 0.2
        notifLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
        notifLabel.Font = Enum.Font.Code
        notifLabel.TextSize = 11
        notifLabel.TextXAlignment = Enum.TextXAlignment.Center
        notifLabel.Text = string.format("(RayV3가 %s 데미지 입힘: %d)", targetName, damageAmount)
        notifLabel.ZIndex = 11
        notifLabel.Parent = hitLogFrame

        local stroke = Instance.new("UIStroke") 
        stroke.Color = Color3.fromRGB(255, 0, 0) 
        stroke.Thickness = 1.5 
        stroke.Parent = notifLabel
        
        local corner = Instance.new("UICorner") 
        corner.CornerRadius = UDim.new(0, 5) 
        corner.Parent = notifLabel

        for _, child in pairs(hitLogFrame:GetChildren()) do
            if child:IsA("TextLabel") and child ~= notifLabel then
                child.Position = child.Position - UDim2.new(0, 0, 0, 32)
            end
        end
        
        local duration = math.clamp(tonumber(getgenv().Config.HitNotifyDuration) or 4.0, 3.0, 5.0)
        task.delay(duration, function() 
            if notifLabel then 
                notifLabel:Destroy() 
            end 
        end)
    end)
end

local trackedHumanoids = {}
runS.Stepped:Connect(function()
    if not getgenv().Config.HitNotify and not getgenv().Config.PlayerDamageText then return end
    for _, p in pairs(plrs:GetPlayers()) do
        if p ~= lplr and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and not trackedHumanoids[hum] then
                trackedHumanoids[hum] = hum.Health
                hum.HealthChanged:Connect(function(newHealth)
                    local oldHealth = trackedHumanoids[hum]
                    if oldHealth and newHealth < oldHealth then
                        local damage = math.floor(oldHealth - newHealth)
                        if damage > 0 then 
                            showHitNotification(p.Name, damage) 
                        end
                    end
                    trackedHumanoids[hum] = newHealth
                end)
            end
        end
    end
end)

-- [5. 레이지봇 중앙 텍스트]
local centerGuiContainer = Instance.new("ScreenGui")
centerGuiContainer.Name = "RayV3_CenterInfiniteGui_" .. randomString(6)
centerGuiContainer.ResetOnSpawn = false
centerGuiContainer.IgnoreGuiInset = true
centerGuiContainer.Parent = coreGuiParent

local centerTextLabel = Instance.new("TextLabel")
centerTextLabel.Size = UDim2.new(0, 400, 0, 40)
centerTextLabel.Position = UDim2.new(0.5, -200, 0.10, 0)
centerTextLabel.BackgroundTransparency = 1
centerTextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
centerTextLabel.Font = Enum.Font.Code
centerTextLabel.TextSize = 14
centerTextLabel.TextXAlignment = Enum.TextXAlignment.Center
centerTextLabel.ZIndex = 20
centerTextLabel.Visible = false
centerTextLabel.Parent = centerGuiContainer

local centerStroke = Instance.new("UIStroke")
centerStroke.Color = Color3.fromRGB(0, 0, 0)
centerStroke.Thickness = 2
centerStroke.Parent = centerTextLabel

runS.RenderStepped:Connect(function()
    if not getgenv().Config.RageBotCenterText or not getgenv().Config.RageBot then
        centerTextLabel.Visible = false
        return
    end

    local targetPlayer, _, targetHead = getCachedClosestTarget()
    if targetPlayer and targetHead then
        centerTextLabel.Visible = true
        centerTextLabel.Text = string.format("(ragebot kill %s...^^)", targetPlayer.Name)
    else
        centerTextLabel.Visible = false
    end
end)

-- [6. 에임봇 / 트리거봇 / 레이지봇 독립 실행 루프 & 총알 속도 증폭]
local lastRageFire = 0
runS.Heartbeat:Connect(function()
    if not getgenv().Config.Enabled then return end

    local targetPlayer, targetRoot, targetHead = getCachedClosestTarget()

    -- 총알 속도 100,000배 증폭 엔진
    pcall(function()
        local localFighter = FighterController and FighterController.LocalFighter
        if localFighter and localFighter.Items then
            for _, item in pairs(localFighter.Items) do
                if getgenv().Config.BulletSpeedBoost then
                    local mult = getgenv().Config.BulletSpeedMultiplier or 100000
                    if item.BulletSpeed then
                        if not item._origBulletSpeed then item._origBulletSpeed = item.BulletSpeed end
                        item.BulletSpeed = item._origBulletSpeed * mult
                    end
                    if item.MuzzleVelocity then
                        if not item._origMuzzleVelocity then item._origMuzzleVelocity = item.MuzzleVelocity end
                        item.MuzzleVelocity = item._origMuzzleVelocity * mult
                    end
                    if item.Velocity then
                        if not item._origVelocity then item._origVelocity = item.Velocity end
                        item.Velocity = item._origVelocity * mult
                    end
                    if item.Speed then
                        if not item._origSpeed then item._origSpeed = item.Speed end
                        item.Speed = item._origSpeed * mult
                    end
                else
                    if item._origBulletSpeed then item.BulletSpeed = item._origBulletSpeed end
                    if item._origMuzzleVelocity then item.MuzzleVelocity = item._origMuzzleVelocity end
                    if item._origVelocity then item.Velocity = item._origVelocity end
                    if item._origSpeed then item.Speed = item._origSpeed end
                end
            end
        end
    end)

    -- [레이지봇(Rage Bot) 독립 자동 발사]
    if getgenv().Config.RageBot and targetHead then
        if tick() - lastRageFire >= (getgenv().Config.FireRate or 0.0001) then
            local hitChance = getgenv().Config.AimbotHitRate or 100
            if math.random(1, 100) <= hitChance then
                lastRageFire = tick()
                pcall(function()
                    local localFighter = FighterController and FighterController.LocalFighter
                    if localFighter and localFighter.CurrentItem then
                        local item = localFighter.CurrentItem
                        if item.Shoot and type(item.Shoot) == "function" then
                            item:Shoot()
                        elseif item.StartShooting and type(item.StartShooting) == "function" then
                            item:StartShooting()
                        end
                    end
                end)
            end
        end
    end

    -- [독립 에임봇 - 설정된 명중률(1~100%) 적용]
    if getgenv().Config.Aimbot and targetHead then
        pcall(function()
            local hitChance = getgenv().Config.AimbotHitRate or 100
            if math.random(1, 100) <= hitChance then
                if CameraController and CameraController.MimicRotation then
                    local cam = ws.CurrentCamera
                    if cam then
                        local smooth = math.clamp(getgenv().Config.AimbotSmoothness or 1.0, 0.01, 1)
                        local targetCF = CFrame.new(cam.CFrame.Position, targetHead.Position)
                        CameraController:MimicRotation(cam.CFrame:Lerp(targetCF, smooth))
                    end
                end
            end
        end)
    end

    -- [독립 트리거봇: 원 모양(CircleCrosshairSize) 안에 적이 들어오면 사일런트 에임 및 레이지봇 자동 사격 연동]
    if getgenv().Config.Triggerbot and targetHead then
        pcall(function()
            local cam = ws.CurrentCamera
            if cam then
                local screenPos, onScreen = cam:WorldToViewportPoint(targetHead.Position)
                if onScreen then
                    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    local circleRadius = tonumber(getgenv().Config.CircleCrosshairSize) or 60
                    
                    -- 적이 원 안으로 들어오면 트리거봇이 사일런트 에임/레이지봇을 자동 발동하여 적 처치
                    if dist <= circleRadius or getgenv().Config.SilentAim or getgenv().Config.RageBot then 
                        local hitChance = getgenv().Config.AimbotHitRate or 100
                        if math.random(1, 100) <= hitChance then
                            local localFighter = FighterController and FighterController.LocalFighter
                            if localFighter and localFighter.CurrentItem then
                                local item = localFighter.CurrentItem
                                if item.Shoot and type(item.Shoot) == "function" then
                                    item:Shoot()
                                elseif item.StartShooting and type(item.StartShooting) == "function" then
                                    item:StartShooting()
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- [7. 반동 및 탄쏠림 제거 모듈]
local lastToolCheck = 0
runS.Heartbeat:Connect(function()
    if not getgenv().Config.NoRecoil and not getgenv().Config.NoSpread then return end
    if tick() - lastToolCheck < 0.2 then return end
    lastToolCheck = tick()
    
    local char = lplr.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            local desc = tool:GetDescendants()
            for i = 1, #desc do
                local v = desc[i]
                if v:IsA("NumberValue") or v:IsA("DoubleValue") or v:IsA("Vector3Value") then
                    local name = v.Name:lower()
                    if (getgenv().Config.NoRecoil and (name:find("recoil") or name:find("kick") or name:find("shake"))) or 
                       (getgenv().Config.NoSpread and (name:find("spread") or name:find("accuracy") or name:find("deviation"))) then
                        v.Value = 0
                    end
                end
            end
        end
    end
end)

getgenv().Config.Fly = false
getgenv().Config.Noclip = false

-- [8. 모바일 UI 패널]
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RayV3PublicBetaGui_" .. randomString(6)
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = coreGuiParent

local toggleMenuBtn = Instance.new("TextButton")
toggleMenuBtn.Size = UDim2.new(0, 180, 0, 36)
toggleMenuBtn.Position = UDim2.new(0.5, -90, 0, 8)
toggleMenuBtn.Text = "👑 RAYV3 // MOBILE UI"
toggleMenuBtn.BackgroundColor3 = Color3.fromRGB(11, 14, 20)
toggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleMenuBtn.Font = Enum.Font.Code
toggleMenuBtn.TextSize = 10
toggleMenuBtn.Draggable = true
toggleMenuBtn.Active = true
toggleMenuBtn.Parent = screenGui

local toggleGrad = Instance.new("UIGradient") 
toggleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 80)), 
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 140, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 255))
}) 
toggleGrad.Parent = toggleMenuBtn

local toggleStroke = Instance.new("UIStroke") toggleStroke.Thickness = 1.4 toggleStroke.Color = Color3.fromRGB(255, 0, 100) toggleStroke.Parent = toggleMenuBtn
local toggleCorner = Instance.new("UICorner") toggleCorner.CornerRadius = UDim.new(0, 6) toggleCorner.Parent = toggleMenuBtn

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 280)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(13, 16, 23)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner") mainCorner.CornerRadius = UDim.new(0, 6) mainCorner.Parent = mainFrame
local mainStroke = Instance.new("UIStroke") mainStroke.Thickness = 1.4 mainStroke.Color = Color3.fromRGB(255, 0, 100) mainStroke.Parent = mainFrame

local titleBar = Instance.new("TextLabel") 
titleBar.Size = UDim2.new(1, -10, 0, 20) 
titleBar.Position = UDim2.new(0, 5, 0, 4) 
titleBar.BackgroundTransparency = 1 
titleBar.Text = "RayV3 Public Beta build // Mobile Edition v10.30" 
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255) 
titleBar.Font = Enum.Font.Code 
titleBar.TextSize = 9 
titleBar.TextXAlignment = Enum.TextXAlignment.Left 
titleBar.ZIndex = 2 
titleBar.Parent = mainFrame

local tabBar = Instance.new("Frame") tabBar.Size = UDim2.new(1, -10, 0, 22) tabBar.Position = UDim2.new(0, 5, 0, 26) tabBar.BackgroundTransparency = 1 tabBar.ZIndex = 2 tabBar.Parent = mainFrame
local tabLayout = Instance.new("UIListLayout") tabLayout.FillDirection = Enum.FillDirection.Horizontal tabLayout.Padding = UDim.new(0, 3) tabLayout.Parent = tabBar

local pages, tabBtns = {}, {}
local function createTabFull(tabName, isDefault)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 1, 0)
    btn.BackgroundColor3 = isDefault and Color3.fromRGB(170, 0, 60) or Color3.fromRGB(18, 23, 34)
    btn.Text = tabName
    btn.TextColor3 = isDefault and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 170, 210)
    btn.Font = Enum.Font.Code
    btn.TextSize = 9
    btn.ZIndex = 2
    btn.Parent = tabBar

    local bCorner = Instance.new("UICorner") bCorner.CornerRadius = UDim.new(0, 4) bCorner.Parent = btn
    local bStroke = Instance.new("UIStroke") bStroke.Color = isDefault and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(25, 35, 50) bStroke.Thickness = 1 bStroke.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -10, 1, -56)
    page.Position = UDim2.new(0, 5, 0, 52)
    page.BackgroundTransparency = 1
    page.Visible = isDefault
    page.ZIndex = 2
    page.CanvasSize = UDim2.new(0, 0, 0, 500)
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 100)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Parent = mainFrame

    pages[tabName] = page
    tabBtns[tabName] = {btn = btn, stroke = bStroke}

    btn.MouseButton1Click:Connect(function()
        for name, p in pairs(pages) do
            p.Visible = (name == tabName)
            local tb = tabBtns[name]
            tb.btn.BackgroundColor3 = (name == tabName) and Color3.fromRGB(170, 0, 60) or Color3.fromRGB(18, 23, 34)
            tb.btn.TextColor3 = (name == tabName) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 170, 210)
            tb.stroke.Color = (name == tabName) and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(25, 35, 50)
        end
    end)
    return page
end

local combatPage = createTabFull("Combat", true)
local espPage = createTabFull("ESP & Visual", false)
local miscPage = createTabFull("Misc & Speed", false)

local function createSingleColumn(page)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.ZIndex = 2
    container.Parent = page
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 5)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = container
    return container
end

local cCol = createSingleColumn(combatPage)
local eCol = createSingleColumn(espPage)
local mCol = createSingleColumn(miscPage)

local function createSection(parent, title)
    local sec = Instance.new("Frame")
    sec.AutomaticSize = Enum.AutomaticSize.Y
    sec.Size = UDim2.new(1, 0, 0, 0)
    sec.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    sec.BackgroundTransparency = 0.2
    sec.BorderSizePixel = 0
    sec.ZIndex = 2
    sec.Parent = parent

    local secCorner = Instance.new("UICorner") secCorner.CornerRadius = UDim.new(0, 4) secCorner.Parent = sec
    local secStroke = Instance.new("UIStroke") secStroke.Color = Color3.fromRGB(255, 0, 100) secStroke.Thickness = 1 secStroke.Parent = sec
    local secTitle = Instance.new("TextLabel") secTitle.Size = UDim2.new(1, -8, 0, 18) secTitle.Position = UDim2.new(0, 4, 0, 2) secTitle.BackgroundTransparency = 1 secTitle.Text = title secTitle.TextColor3 = Color3.fromRGB(255, 180, 200) secTitle.Font = Enum.Font.Code secTitle.TextSize = 9 secTitle.TextXAlignment = Enum.TextXAlignment.Left secTitle.ZIndex = 2 secTitle.Parent = sec
    local line = Instance.new("Frame") line.Size = UDim2.new(1, -8, 0, 1) line.Position = UDim2.new(0, 4, 0, 20) line.BackgroundColor3 = Color3.fromRGB(255, 0, 100) line.BorderSizePixel = 0 line.ZIndex = 2 line.Parent = sec

    local container = Instance.new("Frame")
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.Size = UDim2.new(1, -8, 0, 0)
    container.Position = UDim2.new(0, 4, 0, 22)
    container.BackgroundTransparency = 1
    container.ZIndex = 2
    container.Parent = sec

    local layout = Instance.new("UIListLayout") layout.Padding = UDim.new(0, 3) layout.SortOrder = Enum.SortOrder.LayoutOrder layout.Parent = container
    local pad = Instance.new("UIPadding") pad.PaddingBottom = UDim.new(0, 4) pad.Parent = sec
    return container
end

local combatSec1 = createSection(cCol, "Independent Combat Features")
local combatSec2 = createSection(cCol, "Desync & Wallbang")

local espSec1 = createSection(eCol, "ESP & Filled Circle Crosshair")

local miscSec1 = createSection(mCol, "Bullet Speed & Damage Settings")
local miscSec2 = createSection(mCol, "Skins & Controls")

local function createToggle(parent, text, order, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 22)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = defaultState and Color3.fromRGB(255, 180, 200) or Color3.fromRGB(130, 145, 170)
    btn.Font = Enum.Font.Code
    btn.TextSize = 9
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = order
    btn.ZIndex = 2
    btn.Parent = parent

    local checkbox = Instance.new("TextButton")
    checkbox.Size = UDim2.new(0, 16, 0, 16)
    checkbox.AnchorPoint = Vector2.new(1, 0.5)
    checkbox.Position = UDim2.new(1, -2, 0.5, 0)
    checkbox.BackgroundColor3 = defaultState and Color3.fromRGB(170, 0, 60) or Color3.fromRGB(12, 15, 22)
    checkbox.Text = defaultState and "✔" or ""
    checkbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkbox.Font = Enum.Font.Code
    checkbox.TextSize = 9
    checkbox.ZIndex = 3
    checkbox.Parent = btn

    local cbCorner = Instance.new("UICorner") cbCorner.CornerRadius = UDim.new(0, 3) cbCorner.Parent = checkbox
    local cbStroke = Instance.new("UIStroke") cbStroke.Color = Color3.fromRGB(255, 0, 100) cbStroke.Thickness = 1 cbStroke.Parent = checkbox

    local function toggleState()
        defaultState = not defaultState
        checkbox.BackgroundColor3 = defaultState and Color3.fromRGB(170, 0, 60) or Color3.fromRGB(12, 15, 22)
        checkbox.Text = defaultState and "✔" or ""
        btn.TextColor3 = defaultState and Color3.fromRGB(255, 180, 200) or Color3.fromRGB(130, 145, 170)
        callback(defaultState)
    end

    btn.MouseButton1Click:Connect(toggleState)
    checkbox.MouseButton1Click:Connect(toggleState)

    return btn
end

local function createTextBoxInput(parent, text, order, initialValue, minVal, maxVal, isFloat, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -4, 0, 24)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order
    container.ZIndex = 2
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 180, 200)
    label.Font = Enum.Font.Code
    label.TextSize = 8
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 2
    label.Parent = container

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.32, 0, 0.8, 0)
    textBox.Position = UDim2.new(0.68, 0, 0.1, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(12, 15, 22)
    textBox.TextColor3 = Color3.fromRGB(255, 60, 60)
    textBox.Font = Enum.Font.Code
    textBox.TextSize = 9
    textBox.Text = tostring(initialValue)
    textBox.ZIndex = 2
    textBox.Parent = container

    local tCorner = Instance.new("UICorner") tCorner.CornerRadius = UDim.new(0, 3) tCorner.Parent = textBox
    local tStroke = Instance.new("UIStroke") tStroke.Color = Color3.fromRGB(255, 0, 100) tStroke.Thickness = 1 tStroke.Parent = container

    textBox.FocusLost:Connect(function()
        local val = tonumber(textBox.Text)
        if val then
            val = math.clamp(val, minVal, maxVal)
            if not isFloat then
                val = math.floor(val)
            end
            textBox.Text = tostring(val)
            callback(val)
        else
            textBox.Text = tostring(initialValue)
        end
    end)
    return container
end

-- UI 구성
createToggle(combatSec1, "Master Switch (전체 활성화)", 0, getgenv().Config.Enabled, function(v) getgenv().Config.Enabled = v end)
createToggle(combatSec1, "Silent Aim (독립 사일런트 에임)", 1, getgenv().Config.SilentAim, function(v) getgenv().Config.SilentAim = v end)
createToggle(combatSec1, "Aimbot (CameraController 에임봇)", 2, getgenv().Config.Aimbot, function(v) getgenv().Config.Aimbot = v end)
createToggle(combatSec1, "Triggerbot (독립 트리거봇)", 3, getgenv().Config.Triggerbot, function(v) getgenv().Config.Triggerbot = v end)
createToggle(combatSec1, "Combat Rage Bot (자동사격 타겟팅)", 4, getgenv().Config.RageBot, function(v) getgenv().Config.RageBot = v end)
createToggle(combatSec1, "All-Head (올헤드 100% 판정)", 5, getgenv().Config.AllHead, function(v) getgenv().Config.AllHead = v end)

createToggle(combatSec2, "Desync + Wallbang (강화 디싱크+월뱅)", 1, getgenv().Config.Wallbang, function(v) getgenv().Config.Wallbang = v; getgenv().Config.DesyncView = v end)
createToggle(combatSec2, "Body Teleport", 2, getgenv().Config.BodyTeleport, function(v) getgenv().Config.BodyTeleport = v end)
createToggle(combatSec2, "Prediction (이동 예측)", 3, getgenv().Config.Prediction, function(v) getgenv().Config.Prediction = v end)

createToggle(espSec1, "회전 그라데이션 원형 조준선", 1, getgenv().Config.CircleCrosshair, function(v) getgenv().Config.CircleCrosshair = v end)
createTextBoxInput(espSec1, "원 조준선 크기 (1~600)", 2, getgenv().Config.CircleCrosshairSize, 1, 600, false, function(v) getgenv().Config.CircleCrosshairSize = v end)
createToggle(espSec1, "Corner Box ESP", 3, getgenv().Config.CornerBoxESP, function(v) getgenv().Config.CornerBoxESP = v end)
createToggle(espSec1, "Name ESP", 4, getgenv().Config.NameESP, function(v) getgenv().Config.NameESP = v end)
createToggle(espSec1, "Health Bar ESP", 5, getgenv().Config.HealthESP, function(v) getgenv().Config.HealthESP = v end)
createToggle(espSec1, "Gun to Target Tracer", 6, getgenv().Config.GunTracer, function(v) getgenv().Config.GunTracer = v end)

createToggle(miscSec1, "Bullet Speed x100,000 (총알 속도 10만배)", 1, getgenv().Config.BulletSpeedBoost, function(v) getgenv().Config.BulletSpeedBoost = v end)
createToggle(miscSec1, "오른쪽 데미지 텍스트 알림", 2, getgenv().Config.PlayerDamageText, function(v) getgenv().Config.PlayerDamageText = v; getgenv().Config.HitNotify = v end)
createToggle(miscSec1, "Ragebot Center Red Text", 3, getgenv().Config.RageBotCenterText, function(v) getgenv().Config.RageBotCenterText = v end)
createTextBoxInput(miscSec1, "알림 지속 시간 (3~5초)", 4, getgenv().Config.HitNotifyDuration, 3, 5, false, function(v) getgenv().Config.HitNotifyDuration = v end)
createTextBoxInput(miscSec1, "에임봇 명중률 (1~100%)", 5, getgenv().Config.AimbotHitRate or 100, 1, 100, false, function(v) getgenv().Config.AimbotHitRate = v end)

createToggle(miscSec2, "All Skins Unlocked (올스킨)", 1, getgenv().Config.AllSkins, function(v) getgenv().Config.AllSkins = v end)
createToggle(miscSec2, "Fly (비활성화됨)", 2, false, function(v) getgenv().Config.Fly = false end)
createToggle(miscSec2, "Noclip (비활성화됨)", 3, false, function(v) getgenv().Config.Noclip = false end)

toggleMenuBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

print("RayV3 Public Beta build Successfully Loaded with Gradient Circle Crosshair & Triggerbot/Silent Aim/RageBot Integration!")
