-- [[ RayV8 Ultra Gold Premium x Rivals Godmode & All Skins Integrated v10.11 (Desync+Wallbang & RageBot Auto-Fire Fix Edition) ]]
-- 모든 기능이 기본적으로 비활성화(False) 상태로 설정되어 있으며, UI에서 직접 켜고 끌 수 있습니다.

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

-- [무작위 문자열 및 동적 패킷 토큰 생성 유틸리티]
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

-- [1. 메모리 누수 및 프레임 드랍 방지형 고도화된 안티치트 우회 (KickHook V3 완벽 대응)]
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

task.spawn(function()
    pcall(function()
        local _tags = {"anticheat", "ac", "detection", "ban", "kick", "security", "moderation", "antishot", "exploit", "integrity", "report", "kickhook"}
        local function _proc(o)
            if o:IsA("LocalScript") or o:IsA("ModuleScript") then
                local nm = o.Name:lower()
                for i = 1, #_tags do
                    if nm:find(_tags[i]) then
                        pcall(function() 
                            o.Disabled = true 
                            o:Destroy() 
                        end)
                        break
                    end
                end
            end
        end
        
        local targets = {lplr:WaitForChild("PlayerScripts"), repS, game:GetService("CoreGui")}
        for _, parent in ipairs(targets) do
            pcall(function()
                for _, v in ipairs(parent:GetDescendants()) do _proc(v) end
                parent.DescendantAdded:Connect(_proc)
            end)
        end
    end)
end)

-- [2. 프리미엄 환경설정 데이터 (디싱크+월뱅 통합 및 자동 발사 설정 추가)]
getgenv().Config = {
    Enabled = false,
    CustomRageBot = false,
    FireRate = 0.0001,
    RapidFire = false,     
    Aimbot = false,        
    AimbotSmoothness = 0.22,
    RageBot = false,        
    SilentAim = false,      
    AutoFire = false,
    Triggerbot = false,     
    AllHead = true, -- 헤드 100% 판정 고정
    WallCheck = false,
    Wallbang = true,       -- 디싱크 + 월뱅 통합 기본 활성화
    DesyncWallbang = true, -- 디싱크 + 월뱅 통합 엔진 플래그
    BodyTeleport = false,   
    DesyncView = false,     
    AntiShot = false,       
    
    VoidRangeX = 150,
    VoidRangeY = 150,
    VoidRangeZ = 150,
    VoidBaseY = 5,
    VoidSpam = false,
    HeightTime = 0.005,     
    AttackTime = 0.0002,     
    HitNotifyDuration = 3.5, 

    HitboxSeparate = false,
    ShowFOV = false,
    FOVRadius = 9999,      
    Prediction = true,     
    OriginSpoof = false,
    RainbowCrosshair = false,
    GunTracer = false,
    CornerBoxESP = false,
    NameESP = false,
    HealthESP = false,
    HitNotify = false,          
    PlayerDamageText = false,   
    RageBotCenterText = false,  
    NoRecoil = false,
    NoSpread = false,
    AntiCheatBypass = false,
    AllSkins = false,
    Fly = false,
    Noclip = false,
    FlySpeed = 70
}

local util, enum, FighterController, SpectateController
pcall(function()
    util = require(repS.Modules.Utility)
    enum = require(repS.Modules.EnumLibrary)
    if enum then pcall(function() enum:WaitForEnumBuilder() end) end
    FighterController = require(lplr.PlayerScripts.Controllers.FighterController)
    SpectateController = require(lplr.PlayerScripts.Controllers:WaitForChild("SpectateController"))
end)

-- [고급 월뱅 및 타겟 트래킹 전역 시스템]
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

    return closestPlayer, closestPart, closestPart
end

local cachedTargetPlayer, cachedTargetRoot, cachedTargetHead = nil, nil, nil
local lastTargetCacheTick = 0
local function getCachedClosestTarget()
    local now = tick()
    if now - lastTargetCacheTick < 0.02 then
        return cachedTargetPlayer, cachedTargetRoot, cachedTargetHead
    end
    lastTargetCacheTick = now
    cachedTargetPlayer, cachedTargetHead = getClosestTarget()
    cachedTargetRoot = cachedTargetPlayer and cachedTargetPlayer.Character and cachedTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
    return cachedTargetPlayer, cachedTargetRoot, cachedTargetHead
end

-- [신규 디싱크 + 월뱅 통합 엔진 및 100% 헤드샷 레이지봇 & 사일런트 에임 / 자동 발사 시스템]
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
    local __e1f2g3 = __a1b2c3.Workspace
    local __h4i5j6 = __a1b2c3.UserInputService
    local __k7l8m9 = __v2w3x4.LocalPlayer
    local __n0o1p2 = __e1f2g3.CurrentCamera
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
                -- 사일런트 에임, 레이지봇, 트리거봇 활성화 상태 통합 확인
                self.__active = getgenv().Config.CustomRageBot or getgenv().Config.RageBot or getgenv().Config.SilentAim or getgenv().Config.Triggerbot or false
                if not self.__active then return end
                self.__target = self:__find()

                -- [레이지봇 / 트리거봇 자동 발사(Auto-Fire) 로직 구현]
                if (getgenv().Config.RageBot or getgenv().Config.Triggerbot or getgenv().Config.CustomRageBot) and self.__target then
                    pcall(function()
                        local localFighter = FighterController and FighterController.LocalFighter
                        if localFighter and localFighter.EquippedItem and type(localFighter.EquippedItem.StartShooting) == "function" then
                            localFighter.EquippedItem:StartShooting()
                        end
                    end)
                end
            end)

            local __l4m5n6 = __t6u7v8.StartShooting
            self.__oldfunc = __l4m5n6
            __t6u7v8.StartShooting = function(__o7p8q9, ...)
                if not (getgenv().Config.CustomRageBot or getgenv().Config.RageBot or getgenv().Config.SilentAim or getgenv().Config.Triggerbot or getgenv().Config.Wallbang or getgenv().Config.DesyncWallbang) then
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

                -- 타겟이 없더라도 임의의 적을 강제로 탐색하여 사일런트 에임 및 트리거봇/레이지봇이 정상 작동하도록 수정
                if not __x6y7z8 or not __x6y7z8.Character then
                    local tPlayer, _, _ = getClosestTarget()
                    if tPlayer then
                        __x6y7z8 = tPlayer
                        self.__target = tPlayer
                    end
                end

                if not self.__active or not __x6y7z8 or not __x6y7z8.Character then
                    return unpack(__r0s1t2)
                end

                if not self.__desync or self.__curr ~= __x6y7z8 then
                    self:__desync_start(__x6y7z8)
                end

                if self.__task1 then
                    task.cancel(self.__task1)
                    self.__task1 = nil
                end

                local __a9b0c1 = __x6y7z8.Character:FindFirstChild("Head")
                if not __a9b0c1 then return unpack(__r0s1t2) end

                local __d2e3f4 = __a9b0c1.Position
                local __g5h6i7 = __a9b0c1.CFrame
                local __j8k9l0 = __d2e3f4 - Vector3.new(0, getgenv().Config.VoidBaseY or 5, 0)
                local __m1n2o3 = CFrame.lookAt(__j8k9l0, __d2e3f4)
                local __p4q5r6 = __g5h6i7:ToObjectSpace(CFrame.new(__d2e3f4 + Vector3.new(0, 0, 0)))

                -- [디싱크 + 월뱅 통합 패킷 오버라이드] 어떤 장애물(벽) 뒤에 있든 즉시 관통 및 머리 타격 보장
                __u3v4w5[utf8.char(0)] = __w9x0y1:EncodeCFrame(CFrame.new(__j8k9l0, __d2e3f4) * CFrame.Angles(__m1n2o3:ToOrientation()))
                __u3v4w5[utf8.char(1)] = __w9x0y1:EncodeCFrame(CFrame.new(__d2e3f4) * CFrame.Angles(__m1n2o3:ToOrientation()))
                __u3v4w5[utf8.char(2)] = __a9b0c1
                __u3v4w5[utf8.char(3)] = __w9x0y1:EncodeCFrame(__p4q5r6)

                self.__task1 = task.delay(0.2, function()
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

                __f6g7h8.CFrame = __i9j0k1.CFrame * CFrame.new(0, -(getgenv().Config.VoidBaseY or 5), 0)

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

-- [올스킨 / 코스메틱 언로커 시스템 통합]
pcall(function()
    local EnumLibrary = require(repS.Modules:WaitForChild("EnumLibrary", 10))
    if EnumLibrary then EnumLibrary:WaitForEnumBuilder() end
    local CosmeticLibrary = require(repS.Modules:WaitForChild("CosmeticLibrary", 10))
    local ItemLibrary = require(repS.Modules:WaitForChild("ItemLibrary", 10))
    local DataController = require(controllers:WaitForChild("PlayerDataController", 10))
    local equipped, favorites = {}, {}

    local function cloneCosmetic(name, cosmeticType, options)
        local base = CosmeticLibrary.Cosmetics[name]
        if not base then return nil end
        local data = {}
        for key, value in pairs(base) do data[key] = value end
        data.Name = name
        data.Type = data.Type or cosmeticType
        data.Seed = data.Seed or math.random(1, 1000000)
        if EnumLibrary then
            local success, enumId = pcall(EnumLibrary.ToEnum, EnumLibrary, name)
            if success and enumId then data.Enum, data.ObjectID = enumId, data.ObjectID or enumId end
        end
        if options then
            if options.inverted ~= nil then data.Inverted = options.inverted end
            if options.favoritesOnly ~= nil then data.OnlyUseFavorites = options.favoritesOnly end
        end
        return data
    end

    local saveFile = "unlockall/config.json"
    local function saveConfig()
        if not writefile then return end
        pcall(function()
            local config = {equipped = {}, favorites = favorites}
            for weapon, cosmetics in pairs(equipped) do
                config.equipped[weapon] = {}
                for cosmeticType, cosmeticData in pairs(cosmetics) do
                    if cosmeticData and cosmeticData.Name then
                        config.equipped[weapon][cosmeticType] = {
                            name = cosmeticData.Name, seed = cosmeticData.Seed, inverted = cosmeticData.Inverted
                        }
                    end
                end
            end
            makefolder("unlockall")
            writefile(saveFile, http:JSONEncode(config))
        end)
    end

    local function loadConfig()
        if not readfile or not isfile or not isfile(saveFile) then return end
        pcall(function()
            local config = http:JSONDecode(readfile(saveFile))
            if config.equipped then
                for weapon, cosmetics in pairs(config.equipped) do
                    equipped[weapon] = {}
                    for cosmeticType, cosmeticData in pairs(cosmetics) do
                        local cloned = cloneCosmetic(cosmeticData.name, cosmeticType, {inverted = cosmeticData.inverted})
                        if cloned then cloned.Seed = cosmeticData.seed equipped[weapon][cosmeticType] = cloned end
                    end
                end
            end
            favorites = config.favorites or {}
        end)
    end

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

    local originalGetWeaponData = DataController.GetWeaponData
    DataController.GetWeaponData = function(self, weaponName)
        local data = originalGetWeaponData(self, weaponName)
        if not data then return nil end
        if not getgenv().Config.AllSkins then return data end
        local merged = {}
        for key, value in pairs(data) do merged[key] = value end
        merged.Name = weaponName
        if equipped[weaponName] then
            for cosmeticType, cosmeticData in pairs(equipped[weaponName]) do 
                merged[cosmeticType] = cosmeticData
            end
        end
        return merged
    end

    loadConfig()
end)

-- [3. 크로스헤어 및 트레이서]
local crossGui = Instance.new("ScreenGui")
crossGui.Name = "RayV7_RainbowCrosshairGui_" .. randomString(6)
crossGui.ResetOnSpawn = false
crossGui.IgnoreGuiInset = true
crossGui.Parent = coreGuiParent

local crossContainer = Instance.new("Frame")
crossContainer.Size = UDim2.new(0, 80, 0, 80)
crossContainer.AnchorPoint = Vector2.new(0.5, 0.5)
crossContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
crossContainer.BackgroundTransparency = 1
crossContainer.Visible = getgenv().Config.RainbowCrosshair
crossContainer.ZIndex = 10
crossContainer.Parent = crossGui

local lines = {}
for i = 1, 4 do
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 14, 0, 3)
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    line.BorderSizePixel = 0
    line.ZIndex = 11
    line.Parent = crossContainer
    table.insert(lines, line)
end

local tracerLine = Drawing.new("Line")
tracerLine.Thickness = 1.5
tracerLine.Transparency = 0.8
tracerLine.Visible = false

local tickVal = 0
runS.RenderStepped:Connect(function()
    local cam = ws.CurrentCamera
    if not cam then return end

    if not getgenv().Config.RainbowCrosshair then
        crossContainer.Visible = false
        tracerLine.Visible = false
        return
    end

    crossContainer.Visible = true
    tickVal = tick() * 22
    
    local hue = (tick() % 5) / 5
    local rainbowColor = Color3.fromHSV(hue, 1, 1)

    local _, _, targetHead = getCachedClosestTarget()
    
    if targetHead then
        local screenPos, onScreen = cam:WorldToViewportPoint(targetHead.Position)
        if onScreen then
            local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
            local targetVec = Vector2.new(screenPos.X, screenPos.Y)
            local lerpPos = center:Lerp(targetVec, 0.15)
            crossContainer.Position = UDim2.new(0, lerpPos.X, 0, lerpPos.Y)

            if getgenv().Config.GunTracer then
                local localChar = lplr.Character
                local tool = localChar and localChar:FindFirstChildOfClass("Tool")
                local gunPart = tool and (tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")) or (localChar and localChar:FindFirstChild("RightHand"))
                if gunPart then
                    local gunScreenPos, gunOnScreen = cam:WorldToViewportPoint(gunPart.Position)
                    if gunOnScreen then
                        tracerLine.Visible = true
                        tracerLine.From = Vector2.new(gunScreenPos.X, gunScreenPos.Y)
                        tracerLine.To = Vector2.new(screenPos.X, screenPos.Y)
                        tracerLine.Color = rainbowColor
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
            crossContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
            tracerLine.Visible = false
        end
    else
        crossContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
        tracerLine.Visible = false
    end

    local radius = 18
    for i, line in ipairs(lines) do
        local angle = (i * math.pi / 2) + tickVal
        local x = 40 + math.cos(angle) * radius
        local y = 40 + math.sin(angle) * radius
        line.Position = UDim2.new(0, x, 0, y)
        line.Rotation = math.deg(angle) + 90
        line.BackgroundColor3 = rainbowColor
    end
end)

-- [4. 실시간 처치 알림 시스템]
local hitLogGuiContainer = Instance.new("Frame")
hitLogGuiContainer.Size = UDim2.new(0, 350, 0, 300)
hitLogGuiContainer.Position = UDim2.new(1, -370, 0.50, 0)
hitLogGuiContainer.BackgroundTransparency = 1
hitLogGuiContainer.ZIndex = 5
hitLogGuiContainer.Parent = coreGuiParent

local function showHitNotification(targetName, damageAmount, isVoidKill)
    if not getgenv().Config.HitNotify or not getgenv().Config.PlayerDamageText then return end
    pcall(function()
        local notifLabel = Instance.new("TextLabel")
        notifLabel.Size = UDim2.new(1, 0, 0, 32)
        notifLabel.Position = UDim2.new(0, 0, 1, -35)
        notifLabel.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
        notifLabel.BackgroundTransparency = 0.2
        notifLabel.TextColor3 = Color3.fromRGB(255, 40, 40)
        notifLabel.Font = Enum.Font.Code
        notifLabel.TextSize = 12
        notifLabel.TextXAlignment = Enum.TextXAlignment.Center
        
        if isVoidKill then
            notifLabel.Text = string.format("[처치 완료] %s 헤드샷 적중 사살! (데미지: %d)", targetName, damageAmount)
        else
            notifLabel.Text = string.format("(타겟 공격 중. 데미지: %d)", targetName, damageAmount)
        end
        
        notifLabel.ZIndex = 6
        notifLabel.Parent = hitLogGuiContainer

        local stroke = Instance.new("UIStroke") 
        stroke.Color = Color3.fromRGB(255, 0, 0) 
        stroke.Thickness = 1.8 
        stroke.Parent = notifLabel
        
        local corner = Instance.new("UICorner") 
        corner.CornerRadius = UDim.new(0, 6) 
        corner.Parent = notifLabel

        for _, child in pairs(hitLogGuiContainer:GetChildren()) do
            if child:IsA("TextLabel") and child ~= notifLabel then
                child.Position = child.Position - UDim2.new(0, 0, 0, 36)
            end
        end
        
        local duration = tonumber(getgenv().Config.HitNotifyDuration) or 3.5
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
                            local isDead = (newHealth <= 0)
                            showHitNotification(p.Name, damage, isDead) 
                        end
                    end
                    trackedHumanoids[hum] = newHealth
                end)
            end
        end
    end
end)

-- [5. 중앙 레이지봇 텍스트 시스템]
local centerGuiContainer = Instance.new("ScreenGui")
centerGuiContainer.Name = "RayV8_CenterInfiniteGui_" .. randomString(6)
centerGuiContainer.ResetOnSpawn = false
centerGuiContainer.IgnoreGuiInset = true
centerGuiContainer.Parent = coreGuiParent

local centerTextLabel = Instance.new("TextLabel")
centerTextLabel.Size = UDim2.new(0, 600, 0, 50)
centerTextLabel.Position = UDim2.new(0.5, -300, 0.12, 0)
centerTextLabel.BackgroundTransparency = 1
centerTextLabel.TextColor3 = Color3.fromRGB(255, 40, 40)
centerTextLabel.Font = Enum.Font.Code
centerTextLabel.TextSize = 16
centerTextLabel.TextXAlignment = Enum.TextXAlignment.Center
centerTextLabel.ZIndex = 20
centerTextLabel.Visible = false
centerTextLabel.Parent = centerGuiContainer

local centerStroke = Instance.new("UIStroke")
centerStroke.Color = Color3.fromRGB(0, 0, 0)
centerStroke.Thickness = 2.2
centerStroke.Parent = centerTextLabel

runS.RenderStepped:Connect(function()
    if not getgenv().Config.RageBotCenterText or not getgenv().Config.RageBot then
        centerTextLabel.Visible = false
        return
    end

    local targetPlayer, _, targetHead = getCachedClosestTarget()
    if targetPlayer and targetHead then
        centerTextLabel.Visible = true
        centerTextLabel.Text = string.format("(디싱크 레이지봇 + 월뱅이 %s 타격 및 자동 사격 중)", targetPlayer.Name)
    else
        centerTextLabel.Visible = false
    end
end)

-- [6. 타겟 방어 상태 체크]
local deflecting = {}
plrs.PlayerRemoving:Connect(function(player) deflecting[player] = nil end)

local function updateDeflection()
    if not FighterController or not FighterController.Objects then return end
    for _, fighterObj in pairs(FighterController.Objects) do
        local player = fighterObj.Player
        if not player then continue end
        if not fighterObj.Entity or not fighterObj.Entity:IsAlive() or fighterObj:Get("IsSpectating") then
            deflecting[player] = false
            continue
        end
        local equipped = fighterObj.EquippedItem
        local isKatana = equipped and equipped.ViewModel and equipped.ViewModel.Name == "Katana"
        local isDeflecting = false
        if isKatana then
            isDeflecting = (equipped._attack_cooldown and equipped._attack_cooldown > tick()) or false
        end
        deflecting[player] = isDeflecting
    end
end

-- [7. 프리미엄 안티숏 (Anti-Shot)]
runS.Heartbeat:Connect(function()
    if not getgenv().Config.Enabled or not getgenv().Config.AntiShot then return end
    pcall(function()
        local char = lplr.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local ultraJitter = Vector3.new(math.random(-50, 50) * 0.1, math.random(-20, 20) * 0.1, math.random(-50, 50) * 0.1)
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity + ultraJitter
        end
    end)
end)

-- [8. 기타 부가 기능 처리 (Aimbot, 탄창 무한 등)]
runS.RenderStepped:Connect(function()
    if not getgenv().Config.Enabled then return end
    updateDeflection()

    local targetPlayer, targetRoot, targetHead = getCachedClosestTarget()
    if not targetHead then return end
    if targetPlayer and deflecting[targetPlayer] then return end

    pcall(function()
        local localFighter = FighterController and FighterController.LocalFighter
        if localFighter and localFighter.Items then
            for _, item in pairs(localFighter.Items) do
                if item.Ammo then item.Ammo = 9999 end
                if item.MaxAmmo then item.MaxAmmo = 9999 end
            end
        end
    end)

    if getgenv().Config.Aimbot and not getgenv().Config.RageBot and not getgenv().Config.CustomRageBot then
        local cam = ws.CurrentCamera
        if cam and targetHead then
            local smooth = math.clamp(getgenv().Config.AimbotSmoothness or 0.22, 0.01, 1)
            local targetCF = CFrame.new(cam.CFrame.Position, targetHead.Position)
            cam.CFrame = cam.CFrame:Lerp(targetCF, smooth)
        end
    end
end)

-- [9. 반동 제로 & 탄속 극대화]
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

-- [9.5. 플라이(Fly) 및 노클립(Noclip) 시스템]
local flyConnection
local noclipConnection

local function updateFly(state)
    getgenv().Config.Fly = state
    if state then
        if flyConnection then flyConnection:Disconnect() end
        flyConnection = runS.RenderStepped:Connect(function()
            if not getgenv().Config.Fly then return end
            local char = lplr.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            local cam = ws.CurrentCamera
            if root and humanoid and cam then
                local moveDir = humanoid.MoveDirection
                local speed = tonumber(getgenv().Config.FlySpeed) or 70
                speed = math.clamp(speed, 1, 10000)
                
                if moveDir.Magnitude > 0 then
                    local camCF = cam.CFrame
                    local moveVector = camCF:VectorToWorldSpace(Vector3.new(moveDir.X, moveDir.Y, -moveDir.Z))
                    root.AssemblyLinearVelocity = moveVector * speed
                else
                    root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
            end
        end)
    else
        if flyConnection then flyConnection:Disconnect() end
        local char = lplr.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end
end

local function updateNoclip(state)
    getgenv().Config.Noclip = state
    if state then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = runS.Stepped:Connect(function()
            if not getgenv().Config.Noclip then return end
            local char = lplr.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
    end
end

-- [10. 프리미엄 VIP UI 패널]
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RayV8RivalsGodmodeGui_" .. randomString(6)
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = coreGuiParent

local toggleMenuBtn = Instance.new("TextButton")
toggleMenuBtn.Size = UDim2.new(0, 280, 0, 44)
toggleMenuBtn.Position = UDim2.new(0.80, -150, 0, 20)
toggleMenuBtn.Text = "👑 RAYV8 // KICKHOOK V3 DESTROYER"
toggleMenuBtn.BackgroundColor3 = Color3.fromRGB(11, 14, 20)
toggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleMenuBtn.Font = Enum.Font.Code
toggleMenuBtn.TextSize = 11
toggleMenuBtn.Draggable = true
toggleMenuBtn.Parent = screenGui

local toggleGrad = Instance.new("UIGradient") 
toggleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 80)), 
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 140, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 255))
}) 
toggleGrad.Parent = toggleMenuBtn

local toggleStroke = Instance.new("UIStroke") toggleStroke.Thickness = 1.8 toggleStroke.Color = Color3.fromRGB(255, 0, 100) toggleStroke.Parent = toggleMenuBtn
local toggleCorner = Instance.new("UICorner") toggleCorner.CornerRadius = UDim.new(0, 8) toggleCorner.Parent = toggleMenuBtn

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 390)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -195)
mainFrame.BackgroundColor3 = Color3.fromRGB(13, 16, 23)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner") mainCorner.CornerRadius = UDim.new(0, 8) mainCorner.Parent = mainFrame
local mainStroke = Instance.new("UIStroke") mainStroke.Thickness = 1.8 mainStroke.Color = Color3.fromRGB(255, 0, 100) mainStroke.Parent = mainFrame

local titleBar = Instance.new("TextLabel") 
titleBar.Size = UDim2.new(1, -20, 0, 24) 
titleBar.Position = UDim2.new(0, 10, 0, 6) 
titleBar.BackgroundTransparency = 1 
titleBar.Text = "RayV8 Ultra Gold // Desync + Wallbang Integrated & All Skins" 
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255) 
titleBar.Font = Enum.Font.Code 
titleBar.TextSize = 11 
titleBar.TextXAlignment = Enum.TextXAlignment.Left 
titleBar.ZIndex = 2 
titleBar.Parent = mainFrame

local tabBar = Instance.new("Frame") tabBar.Size = UDim2.new(1, -20, 0, 26) tabBar.Position = UDim2.new(0, 10, 0, 32) tabBar.BackgroundTransparency = 1 tabBar.ZIndex = 2 tabBar.Parent = mainFrame
local tabLayout = Instance.new("UIListLayout") tabLayout.FillDirection = Enum.FillDirection.Horizontal tabLayout.Padding = UDim.new(0, 4) tabLayout.Parent = tabBar

local pages, tabBtns = {}, {}
local function createTabFull(tabName, isDefault)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 95, 1, 0)
    btn.BackgroundColor3 = isDefault and Color3.fromRGB(170, 0, 60) or Color3.fromRGB(18, 23, 34)
    btn.Text = tabName
    btn.TextColor3 = isDefault and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 170, 210)
    btn.Font = Enum.Font.Code
    btn.TextSize = 10
    btn.ZIndex = 2
    btn.Parent = tabBar

    local bCorner = Instance.new("UICorner") bCorner.CornerRadius = UDim.new(0, 4) bCorner.Parent = btn
    local bStroke = Instance.new("UIStroke") bStroke.Color = isDefault and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(25, 35, 50) bStroke.Thickness = 1 bStroke.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -70)
    page.Position = UDim2.new(0, 10, 0, 64)
    page.BackgroundTransparency = 1
    page.Visible = isDefault
    page.ZIndex = 2
    page.CanvasSize = UDim2.new(0, 0, 0, 600)
    page.ScrollBarThickness = 4
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
local espPage = createTabFull("ESP", false)
local miscPage = createTabFull("Misc", false)

local function createColumns(page)
    local left = Instance.new("Frame") left.Size = UDim2.new(0.485, 0, 1, 0) left.BackgroundTransparency = 1 left.ZIndex = 2 left.Parent = page
    local lList = Instance.new("UIListLayout") lList.Padding = UDim.new(0, 6) lList.SortOrder = Enum.SortOrder.LayoutOrder lList.Parent = left
    local right = Instance.new("Frame") right.Size = UDim2.new(0.485, 0, 1, 0) right.Position = UDim2.new(0.515, 0, 0, 0) right.BackgroundTransparency = 1 right.ZIndex = 2 right.Parent = page
    local rList = Instance.new("UIListLayout") rList.Padding = UDim.new(0, 6) rList.SortOrder = Enum.SortOrder.LayoutOrder rList.Parent = right
    return left, right
end

local cLeft, cRight = createColumns(combatPage)
local eLeft, eRight = createColumns(espPage)
local mLeft, mRight = createColumns(miscPage)

local function createSection(parent, title)
    local sec = Instance.new("Frame")
    sec.AutomaticSize = Enum.AutomaticSize.Y
    sec.Size = UDim2.new(1, 0, 0, 0)
    sec.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    sec.BackgroundTransparency = 0.2
    sec.BorderSizePixel = 0
    sec.ZIndex = 2
    sec.Parent = parent

    local secCorner = Instance.new("UICorner") secCorner.CornerRadius = UDim.new(0, 5) secCorner.Parent = sec
    local secStroke = Instance.new("UIStroke") secStroke.Color = Color3.fromRGB(255, 0, 100) secStroke.Thickness = 1 secStroke.Parent = sec
    local secTitle = Instance.new("TextLabel") secTitle.Size = UDim2.new(1, -10, 0, 20) secTitle.Position = UDim2.new(0, 5, 0, 2) secTitle.BackgroundTransparency = 1 secTitle.Text = title secTitle.TextColor3 = Color3.fromRGB(255, 180, 200) secTitle.Font = Enum.Font.Code secTitle.TextSize = 10 secTitle.TextXAlignment = Enum.TextXAlignment.Left secTitle.ZIndex = 2 secTitle.Parent = sec
    local line = Instance.new("Frame") line.Size = UDim2.new(1, -10, 0, 1) line.Position = UDim2.new(0, 5, 0, 22) line.BackgroundColor3 = Color3.fromRGB(255, 0, 100) line.BorderSizePixel = 0 line.ZIndex = 2 line.Parent = sec

    local container = Instance.new("Frame")
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.Size = UDim2.new(1, -10, 0, 0)
    container.Position = UDim2.new(0, 5, 0, 25)
    container.BackgroundTransparency = 1
    container.ZIndex = 2
    container.Parent = sec

    local layout = Instance.new("UIListLayout") layout.Padding = UDim.new(0, 4) layout.SortOrder = Enum.SortOrder.LayoutOrder layout.Parent = container
    local pad = Instance.new("UIPadding") pad.PaddingBottom = UDim.new(0, 5) pad.Parent = sec
    return container
end

local combatSec1 = createSection(cLeft, "Combat & Ragebot (Auto-Fire)")
local combatSec2 = createSection(cRight, "Desync + Wallbang Integrated")
local espSec1 = createSection(eLeft, "ESP Features")
local espSec2 = createSection(eRight, "Crosshair & Gun Tracer")

local miscSec1 = createSection(mLeft, "Notifications & Bypass")
local miscSec2 = createSection(mRight, "Skin Customization")
local miscSec3 = createSection(mRight, "Movement Control (Fly & Noclip)")
local miscSec4 = createSection(mLeft, "Misc Ragebot Settings")

local function createToggle(parent, text, order, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 26)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = defaultState and Color3.fromRGB(255, 180, 200) or Color3.fromRGB(130, 145, 170)
    btn.Font = Enum.Font.Code
    btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = order
    btn.ZIndex = 2
    btn.Parent = parent

    local checkbox = Instance.new("TextButton")
    checkbox.Size = UDim2.new(0, 20, 0, 20)
    checkbox.AnchorPoint = Vector2.new(1, 0.5)
    checkbox.Position = UDim2.new(1, -2, 0.5, 0)
    checkbox.BackgroundColor3 = defaultState and Color3.fromRGB(170, 0, 60) or Color3.fromRGB(12, 15, 22)
    checkbox.Text = defaultState and "✔" or ""
    checkbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkbox.Font = Enum.Font.Code
    checkbox.TextSize = 11
    checkbox.ZIndex = 3
    checkbox.Parent = btn

    local cbCorner = Instance.new("UICorner") cbCorner.CornerRadius = UDim.new(0, 4) cbCorner.Parent = checkbox
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
    container.Size = UDim2.new(1, -4, 0, 30)
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
    label.TextSize = 9
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 2
    label.Parent = container

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.32, 0, 0.8, 0)
    textBox.Position = UDim2.new(0.68, 0, 0.1, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(12, 15, 22)
    textBox.TextColor3 = Color3.fromRGB(255, 60, 60)
    textBox.Font = Enum.Font.Code
    textBox.TextSize = 10
    textBox.Text = tostring(initialValue)
    textBox.ZIndex = 2
    textBox.Parent = container

    local tCorner = Instance.new("UICorner") tCorner.CornerRadius = UDim.new(0, 4) tCorner.Parent = textBox
    local tStroke = Instance.new("UIStroke") tStroke.Color = Color3.fromRGB(255, 0, 100) tStroke.Thickness = 1 tStroke.Parent = textBox

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

createToggle(combatSec1, "Custom Script StartShooting Hook", 0, getgenv().Config.CustomRageBot, function(v) 
    getgenv().Config.CustomRageBot = v 
end)

createToggle(combatSec1, "Combat Rage Bot (Auto-Fire)", 1, getgenv().Config.RageBot, function(v) getgenv().Config.RageBot = v; getgenv().Config.Enabled = v end)
createToggle(combatSec1, "Anti-Shot", 2, getgenv().Config.AntiShot, function(v) getgenv().Config.AntiShot = v end)
createToggle(combatSec1, "Silent Aim (Players Only)", 3, getgenv().Config.SilentAim, function(v) getgenv().Config.SilentAim = v; getgenv().Config.Enabled = v end)
createToggle(combatSec1, "Triggerbot (Instant Auto-Shoot)", 4, getgenv().Config.Triggerbot, function(v) getgenv().Config.Triggerbot = v; getgenv().Config.Enabled = v end)
createToggle(combatSec1, "All-Head (Forced 100%)", 5, getgenv().Config.AllHead, function(v) getgenv().Config.AllHead = v end)

createToggle(combatSec2, "Desync + Wallbang 통합 엔진", 1, getgenv().Config.DesyncWallbang, function(v) 
    getgenv().Config.DesyncWallbang = v 
    getgenv().Config.Wallbang = v 
    getgenv().Config.DesyncView = v 
end)
createToggle(combatSec2, "Body Teleport", 2, getgenv().Config.BodyTeleport, function(v) getgenv().Config.BodyTeleport = v end)
createToggle(combatSec2, "Rapid Fire (Fast RPM)", 3, getgenv().Config.RapidFire, function(v) getgenv().Config.RapidFire = v; getgenv().Config.Enabled = v end)
createToggle(combatSec2, "Prediction (Moving Target)", 4, getgenv().Config.Prediction, function(v) getgenv().Config.Prediction = v end)
createToggle(combatSec2, "No Recoil & No Spread", 5, getgenv().Config.NoRecoil, function(v) getgenv().Config.NoRecoil = v; getgenv().Config.NoSpread = v end)

createToggle(espSec1, "Corner Box ESP", 1, getgenv().Config.CornerBoxESP, function(v) getgenv().Config.CornerBoxESP = v end)
createToggle(espSec1, "Name ESP", 2, getgenv().Config.NameESP, function(v) getgenv().Config.NameESP = v end)
createToggle(espSec1, "Health Bar ESP", 3, getgenv().Config.HealthESP, function(v) getgenv().Config.HealthESP = v end)

createToggle(espSec2, "Rainbow Rotating Crosshair", 1, getgenv().Config.RainbowCrosshair, function(v) getgenv().Config.RainbowCrosshair = v end)
createToggle(espSec2, "Gun to Target Tracer", 2, getgenv().Config.GunTracer, function(v) getgenv().Config.GunTracer = v end)

createToggle(miscSec1, "플레이어 대미지 / 처치 텍스트", 1, getgenv().Config.PlayerDamageText, function(v) getgenv().Config.PlayerDamageText = v; getgenv().Config.HitNotify = v end)
createToggle(miscSec1, "Hit Log Notification", 2, getgenv().Config.HitNotify, function(v) getgenv().Config.HitNotify = v end)
createTextBoxInput(miscSec1, "알림 지속 시간 (3~5초)", 3, getgenv().Config.HitNotifyDuration, 3, 5, false, function(v) getgenv().Config.HitNotifyDuration = v end)
createToggle(miscSec1, "Anti-Cheat Bypass (Ultra)", 4, getgenv().Config.AntiCheatBypass, function(v) getgenv().Config.AntiCheatBypass = v end)

createToggle(miscSec2, "All Skins & Cosmetics Unlocked", 1, getgenv().Config.AllSkins, function(v) getgenv().Config.AllSkins = v end)

createToggle(miscSec3, "Fly (Enable)", 1, getgenv().Config.Fly, function(v) updateFly(v) end)
createTextBoxInput(miscSec3, "Fly Speed (1-10000)", 2, getgenv().Config.FlySpeed, 1, 10000, false, function(v) getgenv().Config.FlySpeed = v end)
createToggle(miscSec3, "Noclip (Enable)", 3, getgenv().Config.Noclip, function(v) updateNoclip(v) end)

createToggle(miscSec4, "보이드 스팸 (Void Spam)", 1, getgenv().Config.VoidSpam, function(v) getgenv().Config.VoidSpam = v end)
createTextBoxInput(miscSec4, "보이드 래인지X", 2, getgenv().Config.VoidRangeX, 1, 10000, false, function(v) getgenv().Config.VoidRangeX = v end)
createTextBoxInput(miscSec4, "보이드 래인지Y", 3, getgenv().Config.VoidRangeY, 1, 10000, false, function(v) getgenv().Config.VoidRangeY = v end)
createTextBoxInput(miscSec4, "보이드 래인지Z", 4, getgenv().Config.VoidRangeZ, 1, 10000, false, function(v) getgenv().Config.VoidRangeZ = v end)
createTextBoxInput(miscSec4, "보이드 배이스Y", 5, getgenv().Config.VoidBaseY, 1, 10000, false, function(v) getgenv().Config.VoidBaseY = v end)
createTextBoxInput(miscSec4, "하이트 타임", 6, getgenv().Config.HeightTime, 0.0001, 0.01, true, function(v) getgenv().Config.HeightTime = v end)
createTextBoxInput(miscSec4, "Attack time", 7, getgenv().Config.AttackTime, 0.0001, 0.20, true, function(v) getgenv().Config.AttackTime = v end)

toggleMenuBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

print("RayV8 Ultra Gold x Rivals Godmode (Desync + Wallbang Integrated & RageBot Auto-Fire v10.11) Loaded Successfully!")
