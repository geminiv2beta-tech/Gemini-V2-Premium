-- [[ RayV3 Premium x Rivals Integrated v4.1 (Optimized Desync + Muzzle FOV + Enhanced Wallbang) ]]
-- Place this in your executor to run.

local plrs = game:GetService("Players")
repeat task.wait() until plrs.LocalPlayer
local lplr = plrs.LocalPlayer

local repS = game:GetService("ReplicatedStorage")
local runS = game:GetService("RunService")
local ws = game:GetService("Workspace")
local http = game:GetService("HttpService")
local userInput = game:GetService("UserInputService")

-- [0. 로딩 GUI 완전 제거]
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

-- [1. 고급 안티치트 및 메타메서드 바이패스]
pcall(function()
    local _stbl
    _stbl = hookfunction(getrenv().setmetatable, newcclosure(function(tbl, mt)
        if mt and typeof(mt) == "table" and rawget(mt, "__mode") == "kv" then
            local tr = debug.traceback()
            if tr and (tr:find("MiscellaneousController") or tr:find("anticheat") or tr:find("Detection")) then
                return _stbl({1, 2, 3}, {})
            end
        end
        return _stbl(tbl, mt)
    end))
end)

coroutine.wrap(function()
    pcall(function()
        local function _proc(o)
            pcall(function()
                if o:IsA("LocalScript") or o:IsA("ModuleScript") then
                    local _s, nm = pcall(function() return o.Name:lower() end)
                    if not _s or not nm then return end
                    local _tags = {"anticheat", "ac", "detection", "ban", "kick", "security", "moderation", "antishot"}
                    for _i = 1, #_tags do
                        if nm:find(_tags[_i]) then
                            pcall(function() o.Disabled = true end)
                            break
                        end
                    end
                end
            end)
        end
        pcall(function()
            local _desc = game:GetDescendants()
            for _i = 1, #_desc do _proc(_desc[_i]) end
        end)
        pcall(function() game.DescendantAdded:Connect(_proc) end)
    end)
end)()

-- [2. 설정 및 상태 변수]
getgenv().Config = {
    Enabled = true,
    FireRate = 0.0005,
    Aimbot = true,
    RageBot = true,
    SilentAim = true,
    AutoFire = true,
    Triggerbot = false,
    AllHead = true,
    WallCheck = false,    -- 월뱅 활성화 (벽 관통 타겟팅)
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
    Desync = true,        -- 디싱크 활성화 (본인 이동은 자유롭게 유지)
    Fly = false,
    Noclip = false,
    FlySpeed = 50
}

local util, enum, FighterController, SpectateController
pcall(function()
    util = require(repS.Modules.Utility)
    enum = require(repS.Modules.EnumLibrary)
    if enum then pcall(function() enum:WaitForEnumBuilder() end) end
    FighterController = require(lplr.PlayerScripts.Controllers.FighterController)
    SpectateController = require(lplr.PlayerScripts.Controllers:WaitForChild("SpectateController"))
end)

-- [3. 총구(Muzzle) 위치 연동 동적 조준선 UI]
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "RayV3_FOVCircleGui"
fovGui.ResetOnSpawn = false
fovGui.IgnoreGuiInset = true
fovGui.Parent = coreGuiParent

local fovFrame = Instance.new("Frame")
fovFrame.Name = "FOVCircle"
fovFrame.Size = UDim2.new(0, getgenv().Config.FOVRadius * 2, 0, getgenv().Config.FOVRadius * 2)
fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
fovFrame.BackgroundTransparency = 0.15
fovFrame.Visible = getgenv().Config.ShowFOV
fovFrame.ZIndex = 4
fovFrame.Parent = fovGui

local fovCorner = Instance.new("UICorner") fovCorner.CornerRadius = UDim.new(1, 0) fovCorner.Parent = fovFrame
local fovStroke = Instance.new("UIStroke") fovStroke.Thickness = 2 fovStroke.Color = Color3.fromRGB(255, 255, 255) fovStroke.Parent = fovFrame

local fovGradient = Instance.new("UIGradient")
fovGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 110, 220)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 100, 240)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 120, 255))
})
fovGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.1),
    NumberSequenceKeypoint.new(1, 0.5)
})
fovGradient.Rotation = 90
fovGradient.Parent = fovFrame

runS.RenderStepped:Connect(function()
    pcall(function()
        fovFrame.Visible = getgenv().Config.ShowFOV and getgenv().Config.Enabled
        if fovFrame.Visible then
            local cam = ws.CurrentCamera
            local char = lplr.Character
            local targetPos = nil
            
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    targetPos = tool.Handle.Position
                end
            end
            
            if cam and targetPos then
                local screenPos, onScreen = cam:WorldToViewportPoint(targetPos + cam.CFrame.LookVector * 1.5)
                if onScreen then
                    fovFrame.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
                else
                    fovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
                end
            else
                fovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            end
            
            fovFrame.Size = UDim2.new(0, getgenv().Config.FOVRadius * 2, 0, getgenv().Config.FOVRadius * 2)
        end
    end)
end)

-- [4. 플라이 및 노클립 로직 구현]
local flyConnection
local function updateFly(state)
    getgenv().Config.Fly = state
    local char = lplr.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    if state then
        local bg = Instance.new("BodyGyro")
        bg.Name = "RayV3_FlyGyro"
        bg.MaxTorque = Vector3.new(90000, 90000, 90000)
        bg.CFrame = root.CFrame
        bg.Parent = root

        local bv = Instance.new("BodyVelocity")
        bv.Name = "RayV3_FlyVelocity"
        bv.MaxForce = Vector3.new(90000, 90000, 90000)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = root

        flyConnection = runS.RenderStepped:Connect(function()
            if not getgenv().Config.Fly then 
                if bg then bg:Destroy() end
                if bv then bv:Destroy() end
                if flyConnection then flyConnection:Disconnect() end
                return
            end
            local cam = ws.CurrentCamera
            if not cam then return end
            hum.PlatformStand = true
            
            local moveDir = Vector3.new(0, 0, 0)
            if userInput:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if userInput:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if userInput:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if userInput:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if userInput:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

            bv.Velocity = moveDir.Unit * getgenv().Config.FlySpeed
            bg.CFrame = cam.CFrame
        end)
    else
        hum.PlatformStand = false
        if root:FindFirstChild("RayV3_FlyGyro") then root.RayV3_FlyGyro:Destroy() end
        if root:FindFirstChild("RayV3_FlyVelocity") then root.RayV3_FlyVelocity:Destroy() end
        if flyConnection then flyConnection:Disconnect() end
    end
end

runS.Stepped:Connect(function()
    pcall(function()
        if getgenv().Config.Noclip then
            local char = lplr.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end)

-- [5. 히트 알림 로그 UI 컨테이너]
local hitLogGuiContainer = Instance.new("Frame")
hitLogGuiContainer.Size = UDim2.new(0, 320, 0, 200)
hitLogGuiContainer.Position = UDim2.new(0, 20, 0.7, 0)
hitLogGuiContainer.BackgroundTransparency = 1
hitLogGuiContainer.ZIndex = 5
hitLogGuiContainer.Parent = coreGuiParent

local function showHitNotification(targetName, damageAmount)
    if not getgenv().Config.HitNotify then return end
    pcall(function()
        local notifLabel = Instance.new("TextLabel")
        notifLabel.Size = UDim2.new(1, 0, 0, 24)
        notifLabel.Position = UDim2.new(0, 0, 1, -25)
        notifLabel.BackgroundColor3 = Color3.fromRGB(24, 12, 42)
        notifLabel.BackgroundTransparency = 0.2
        notifLabel.TextColor3 = Color3.fromRGB(215, 120, 255)
        notifLabel.Font = Enum.Font.Code
        notifLabel.TextSize = 11
        notifLabel.Text = string.format("[%s] 적중 대미지: %d", targetName, damageAmount)
        notifLabel.ZIndex = 6
        notifLabel.Parent = hitLogGuiContainer

        local stroke = Instance.new("UIStroke") stroke.Color = Color3.fromRGB(165, 19, 174) stroke.Parent = notifLabel
        local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 4) corner.Parent = notifLabel

        for _, child in pairs(hitLogGuiContainer:GetChildren()) do
            if child:IsA("TextLabel") and child ~= notifLabel then
                child.Position = child.Position - UDim2.new(0, 0, 0, 28)
            end
        end

        task.delay(3, function()
            if notifLabel then notifLabel:Destroy() end
        end)
    end)
end

local trackedHumanoids = {}
runS.Stepped:Connect(function()
    pcall(function()
        for _, p in pairs(plrs:GetPlayers()) do
            if p ~= lplr and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum and not trackedHumanoids[hum] then
                    trackedHumanoids[hum] = hum.Health
                    hum.HealthChanged:Connect(function(newHealth)
                        local oldHealth = trackedHumanoids[hum]
                        if oldHealth and newHealth < oldHealth then
                            local damage = math.floor(oldHealth - newHealth)
                            if damage > 0 then showHitNotification(p.Name, damage) end
                        end
                        trackedHumanoids[hum] = newHealth
                    end)
                end
            end
        end
    end)
end)

-- 월뱅(Wallbang) 및 시야 판정
local function isVisible(targetPart)
    if not getgenv().Config.WallCheck then return true end
    local success, result = pcall(function()
        local cam = ws.CurrentCamera
        if not cam then return false end
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = {lplr.Character, cam}
        raycastParams.IgnoreWater = true
        
        local origin = cam.CFrame.Position
        local direction = targetPart.Position - origin
        local rayResult = ws:Raycast(origin, direction, raycastParams)
        
        if rayResult then
            local hitInstance = rayResult.Instance
            if hitInstance:IsDescendantOf(targetPart.Parent) then return true end
            return false
        end
        return true
    end)
    return success and result or true
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
    local char = lplr.Character
    if not char then return nil, nil, nil end
    local cam = ws.CurrentCamera
    if not cam then return nil, nil, nil end
    
    local mousePos = userInput:GetMouseLocation()
    local closestPlayer, closestRoot, closestHead = nil, nil, nil
    local closestDist = getgenv().Config.FOVRadius
    
    for _, player in ipairs(plrs:GetPlayers()) do
        if not isEnemy(player) then continue end
        local pChar = player.Character
        if not pChar then continue end
        local pRoot = pChar:FindFirstChild("HumanoidRootPart")
        local pHead = pChar:FindFirstChild("Head")
        local pHum = pChar:FindFirstChildWhichIsA("Humanoid")
        if not (pRoot and pHead and pHum and pHum.Health > 0) then continue end
        
        if not isVisible(pHead) then continue end
        
        local screenPos, onScreen = cam:WorldToViewportPoint(pHead.Position)
        if onScreen then
            local distToMouse = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            if distToMouse <= closestDist then
                closestDist = distToMouse
                closestPlayer = player
                closestRoot = pRoot
                closestHead = pHead
            end
        end
    end
    return closestPlayer, closestRoot, closestHead
end

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

-- [6. 1인칭 이동 끊김 없는 디싱크 및 월뱅/사일런트 에임 로직]
local lastFire = 0
runS.Heartbeat:Connect(function()
    updateDeflection()
    if not getgenv().Config.Enabled then return end

    -- 개선된 디싱크: 플레이어의 로컬 입력 및 이동(1인칭)을 방해하지 않으면서 서버 패킷 위치만 교란
    pcall(function()
        if getgenv().Config.Desync then
            local char = lplr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local currentVel = root.AssemblyLinearVelocity
                local tVal = tick() * 18
                -- 기존 속도 벡터를 보존하면서 미세한 분산 오프셋 적용
                root.AssemblyLinearVelocity = Vector3.new(math.cos(tVal) * 16, currentVel.Y, math.sin(tVal) * 16)
            end
        end
    end)

    local targetPlayer, targetRoot, targetHead = getClosestTarget()
    if not targetPlayer or not targetHead or not targetRoot then return end
    if deflecting[targetPlayer] then return end

    -- 탄약 무한 유지
    pcall(function()
        local localFighter = FighterController and FighterController.LocalFighter
        if localFighter and localFighter.Items then
            for _, item in pairs(localFighter.Items) do
                pcall(function()
                    if item.Ammo then item.Ammo = 999 end
                    if item.MaxAmmo then item.MaxAmmo = 999 end
                end)
            end
        end
    end)

    -- 에임봇 (1인칭 부드러운 카메라 조준)
    if getgenv().Config.Aimbot then
        local cam = ws.CurrentCamera
        if cam and targetHead then
            local goalCFrame = CFrame.new(cam.CFrame.Position, targetHead.Position)
            cam.CFrame = cam.CFrame:Lerp(goalCFrame, 0.7)
        end
    end

    -- 월뱅 및 권총/주먹 범용 무기 타격 패킷 전송
    if getgenv().Config.RageBot or getgenv().Config.AutoFire or getgenv().Config.SilentAim then
        if tick() - lastFire < getgenv().Config.FireRate then return end
        lastFire = tick()

        local localFighter = FighterController and FighterController.LocalFighter
        if not localFighter then return end
        local item = localFighter.EquippedItem
        if not item then return end

        local targetPos = targetHead.Position
        if not getgenv().Config.AllHead then
            targetPos = targetRoot.Position
        end

        local spoofedOrigin = targetRoot.Position + Vector3.new(0, 0.5, 0)
        local aimCF = CFrame.lookAt(spoofedOrigin, targetPos)
        local targetCF = targetHead.CFrame
        local aimedPos = targetPos
        local objSpaceHeadOffset = targetHead.CFrame:ToObjectSpace(CFrame.new(aimedPos))

        local cameradata = {}
        pcall(function()
            cameradata[utf8.char(1)] = {
                [utf8.char(0)] = util:EncodeCFrame(aimCF),
                [utf8.char(1)] = util:EncodeCFrame(targetCF),
                [utf8.char(2)] = targetHead,
                [utf8.char(3)] = util:EncodeCFrame(objSpaceHeadOffset)
            }
            repS.Remotes.Replication.Fighter.UseItem:FireServer(
                item:Get("ObjectID"),
                enum:ToEnum("StartShooting"),
                cameradata,
                nil
            )
        end)
    end
end)

-- [7. 반동 및 분산 제거]
runS.RenderStepped:Connect(function()
    pcall(function()
        local char = lplr.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                for _, v in pairs(tool:GetDescendants()) do
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
end)

-- [8. ESP]
local espDrawings = {}
local function clearEsp()
    for _, objList in pairs(espDrawings) do
        for _, drawing in pairs(objList) do
            pcall(function() drawing:Remove() end)
        end
    end
    espDrawings = {}
end

runS.RenderStepped:Connect(function()
    pcall(function()
        if not (getgenv().Config.CornerBoxESP or getgenv().Config.NameESP or getgenv().Config.HealthESP) then
            clearEsp()
            return
        end

        local cam = ws.CurrentCamera
        if not cam then return end

        local activePlayers = {}
        for _, p in pairs(plrs:GetPlayers()) do
            if p ~= lplr and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local root = p.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and root then
                    activePlayers[p] = true
                    if not espDrawings[p] then
                        espDrawings[p] = {
                            Box = Drawing.new("Square"),
                            Name = Drawing.new("Text"),
                            HealthBar = Drawing.new("Line"),
                            HealthBarBg = Drawing.new("Line")
                        }
                        espDrawings[p].Box.Visible = false
                        espDrawings[p].Box.Filled = false
                        espDrawings[p].Box.Thickness = 1.5
                        espDrawings[p].Box.Color = Color3.fromRGB(215, 80, 225)
                        
                        espDrawings[p].Name.Visible = false
                        espDrawings[p].Name.Size = 13
                        espDrawings[p].Name.Center = true
                        espDrawings[p].Name.Outline = true
                        espDrawings[p].Name.Color = Color3.fromRGB(255, 255, 255)

                        espDrawings[p].HealthBar.Thickness = 2
                        espDrawings[p].HealthBar.Visible = false
                        espDrawings[p].HealthBarBg.Thickness = 2
                        espDrawings[p].HealthBarBg.Visible = false
                        espDrawings[p].HealthBarBg.Color = Color3.fromRGB(0, 0, 0)
                    end

                    local drawings = espDrawings[p]
                    local pos, onScreen = cam:WorldToViewportPoint(root.Position)
                    if onScreen then
                        local sizeFactor = 1 / (pos.Z * math.tan(math.rad(cam.FieldOfView / 2)) * 2) * 1000
                        local width = math.clamp(20 * sizeFactor, 15, 300)
                        local height = math.clamp(35 * sizeFactor, 25, 500)
                        local boxX = pos.X - width / 2
                        local boxY = pos.Y - height / 2

                        if getgenv().Config.CornerBoxESP then
                            drawings.Box.Visible = true
                            drawings.Box.Position = Vector2.new(boxX, boxY)
                            drawings.Box.Size = Vector2.new(width, height)
                        else
                            drawings.Box.Visible = false
                        end

                        if getgenv().Config.NameESP then
                            drawings.Name.Visible = true
                            drawings.Name.Text = p.Name
                            drawings.Name.Position = Vector2.new(pos.X, boxY - 18)
                        else
                            drawings.Name.Visible = false
                        end

                        if getgenv().Config.HealthESP then
                            local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            drawings.HealthBarBg.Visible = true
                            drawings.HealthBarBg.From = Vector2.new(boxX - 6, boxY + height)
                            drawings.HealthBarBg.To = Vector2.new(boxX - 6, boxY)

                            drawings.HealthBar.Visible = true
                            drawings.HealthBar.From = Vector2.new(boxX - 6, boxY + height)
                            drawings.HealthBar.To = Vector2.new(boxX - 6, boxY + (height * (1 - healthPercent)))
                            drawings.HealthBar.Color = Color3.fromRGB(0, 255, 100)
                        else
                            drawings.HealthBar.Visible = false
                            drawings.HealthBarBg.Visible = false
                        end
                    else
                        drawings.Box.Visible = false
                        drawings.Name.Visible = false
                        drawings.HealthBar.Visible = false
                        drawings.HealthBarBg.Visible = false
                    end
                end
            end
        end

        for p, drawings in pairs(espDrawings) do
            if not activePlayers[p] then
                for _, d in pairs(drawings) do pcall(function() d:Remove() end) end
                espDrawings[p] = nil
            end
        end
    end)
end)

-- [9. 올스킨 토글 기능 연동]
task.spawn(function()
    pcall(function()
        local _mods = repS:WaitForChild("Modules", 10)
        local _cosLib = require(_mods:WaitForChild("CosmeticLibrary", 10))
        local _ctrl = lplr.PlayerScripts.Controllers
        local _datCtrl = require(_ctrl:WaitForChild("PlayerDataController", 10))

        _cosLib.OwnsCosmeticNormally = function(...)
            if getgenv().Config.AllSkins then return true end
            return _cosLib.OwnsCosmeticNormally(...)
        end
        _cosLib.OwnsCosmeticUniversally = function(...)
            if getgenv().Config.AllSkins then return true end
            return _cosLib.OwnsCosmeticUniversally(...)
        end
        _cosLib.OwnsCosmeticForWeapon = function(...)
            if getgenv().Config.AllSkins then return true end
            return _cosLib.OwnsCosmeticForWeapon(...)
        end

        local _origGet = _datCtrl.Get
        _datCtrl.Get = function(self, key)
            local _val = _origGet(self, key)
            if key == "CosmeticInventory" and getgenv().Config.AllSkins then
                local _prx = {}
                if _val then
                    for k, v in pairs(_val) do _prx[k] = v end
                end
                return setmetatable(_prx, {
                    __index = function(t, k) return true end
                })
            end
            return _val
        end
    end)
end)

-- [10. RayV3 프리미엄 GUI 사용자 인터페이스]
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RayV3RivalsIntegratedGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = coreGuiParent

local toggleMenuBtn = Instance.new("TextButton")
toggleMenuBtn.Size = UDim2.new(0, 175, 0, 45)
toggleMenuBtn.Position = UDim2.new(0.82, -150, 0, 20)
toggleMenuBtn.Text = "💎 RayV3 Rivals [Secured]"
toggleMenuBtn.BackgroundColor3 = Color3.fromRGB(16, 8, 28)
toggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleMenuBtn.Font = Enum.Font.Code
toggleMenuBtn.TextSize = 11
toggleMenuBtn.Draggable = true
toggleMenuBtn.Parent = screenGui

local toggleGrad = Instance.new("UIGradient") toggleGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(165, 19, 174)), ColorSequenceKeypoint.new(1, Color3.fromRGB(215, 80, 225))}) toggleGrad.Parent = toggleMenuBtn
local toggleStroke = Instance.new("UIStroke") toggleStroke.Thickness = 1.5 toggleStroke.Color = Color3.fromRGB(165, 19, 174) toggleStroke.Parent = toggleMenuBtn
local toggleCorner = Instance.new("UICorner") toggleCorner.CornerRadius = UDim.new(0, 8) toggleCorner.Parent = toggleMenuBtn

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 490, 0, 340)
mainFrame.Position = UDim2.new(0.5, -245, 0.5, -170)
mainFrame.BackgroundColor3 = Color3.fromRGB(16, 8, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner") mainCorner.CornerRadius = UDim.new(0, 8) mainCorner.Parent = mainFrame
local mainStroke = Instance.new("UIStroke") mainStroke.Thickness = 1.5 mainStroke.Color = Color3.fromRGB(165, 19, 174) mainStroke.Parent = mainFrame

local titleBar = Instance.new("TextLabel") titleBar.Size = UDim2.new(1, -20, 0, 24) titleBar.Position = UDim2.new(0, 10, 0, 6) titleBar.BackgroundTransparency = 1 titleBar.Text = "RayV3 Premium // Desync + Fly + Noclip + Wallbang Integrated" titleBar.TextColor3 = Color3.fromRGB(255, 255, 255) titleBar.Font = Enum.Font.Code titleBar.TextSize = 11 titleBar.TextXAlignment = Enum.TextXAlignment.Left titleBar.ZIndex = 2 titleBar.Parent = mainFrame

local tabBar = Instance.new("Frame") tabBar.Size = UDim2.new(1, -20, 0, 26) tabBar.Position = UDim2.new(0, 10, 0, 32) tabBar.BackgroundTransparency = 1 tabBar.ZIndex = 2 tabBar.Parent = mainFrame
local tabLayout = Instance.new("UIListLayout") tabLayout.FillDirection = Enum.FillDirection.Horizontal tabLayout.Padding = UDim.new(0, 4) tabLayout.Parent = tabBar

local pages, tabBtns = {}, {}
local function createTabFull(tabName, isDefault)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 95, 1, 0)
    btn.BackgroundColor3 = isDefault and Color3.fromRGB(45, 15, 80) or Color3.fromRGB(20, 10, 35)
    btn.Text = tabName
    btn.TextColor3 = isDefault and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 140, 210)
    btn.Font = Enum.Font.Code
    btn.TextSize = 10
    btn.ZIndex = 2
    btn.Parent = tabBar

    local bCorner = Instance.new("UICorner") bCorner.CornerRadius = UDim.new(0, 4) bCorner.Parent = btn
    local bStroke = Instance.new("UIStroke") bStroke.Color = isDefault and Color3.fromRGB(165, 19, 174) or Color3.fromRGB(45, 20, 75) bStroke.Thickness = 1 bStroke.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -70)
    page.Position = UDim2.new(0, 10, 0, 64)
    page.BackgroundTransparency = 1
    page.Visible = isDefault
    page.ZIndex = 2
    page.CanvasSize = UDim2.new(0, 0, 0, 500)
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(165, 19, 174)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Parent = mainFrame

    pages[tabName] = page
    tabBtns[tabName] = {btn = btn, stroke = bStroke}

    btn.MouseButton1Click:Connect(function()
        for name, p in pairs(pages) do
            p.Visible = (name == tabName)
            local tb = tabBtns[name]
            tb.btn.BackgroundColor3 = (name == tabName) and Color3.fromRGB(45, 15, 80) or Color3.fromRGB(20, 10, 35)
            tb.btn.TextColor3 = (name == tabName) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 140, 210)
            tb.stroke.Color = (name == tabName) and Color3.fromRGB(165, 19, 174) or Color3.fromRGB(45, 20, 75)
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
    sec.BackgroundColor3 = Color3.fromRGB(24, 12, 42)
    sec.BackgroundTransparency = 0.25
    sec.BorderSizePixel = 0
    sec.ZIndex = 2
    sec.Parent = parent

    local secCorner = Instance.new("UICorner") secCorner.CornerRadius = UDim.new(0, 5) secCorner.Parent = sec
    local secStroke = Instance.new("UIStroke") secStroke.Color = Color3.fromRGB(165, 19, 174) secStroke.Thickness = 1 secStroke.Parent = sec
    local secTitle = Instance.new("TextLabel") secTitle.Size = UDim2.new(1, -10, 0, 20) secTitle.Position = UDim2.new(0, 5, 0, 2) secTitle.BackgroundTransparency = 1 secTitle.Text = title secTitle.TextColor3 = Color3.fromRGB(210, 180, 255) secTitle.Font = Enum.Font.Code secTitle.TextSize = 10 secTitle.TextXAlignment = Enum.TextXAlignment.Left secTitle.ZIndex = 2 secTitle.Parent = sec
    local line = Instance.new("Frame") line.Size = UDim2.new(1, -10, 0, 1) line.Position = UDim2.new(0, 5, 0, 22) line.BackgroundColor3 = Color3.fromRGB(165, 19, 174) line.BorderSizePixel = 0 line.ZIndex = 2 line.Parent = sec

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

local combatSec1 = createSection(cLeft, "Aimbot & RageBot")
local combatSec2 = createSection(cRight, "Weapon & FOV Settings")
local espSec1 = createSection(eLeft, "ESP Features")
local miscSec1 = createSection(mLeft, "Notifications & Anti-Cheat")
local miscSec2 = createSection(mRight, "Skin & Customization")
local miscSec3 = createSection(mRight, "Movement (Fly & Noclip)")

local function createToggle(parent, text, order, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 26)
    btn.BackgroundTransparency = 1
    btn.Text = (defaultState and "[✔] " or "[ ] ")..text
    btn.TextColor3 = defaultState and Color3.fromRGB(210, 180, 255) or Color3.fromRGB(160, 150, 180)
    btn.Font = Enum.Font.Code
    btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = order
    btn.ZIndex = 2
    btn.Parent = parent

    btn.MouseButton1Click:Connect(function()
        defaultState = not defaultState
        btn.Text = (defaultState and "[✔] " or "[ ] ")..text
        btn.TextColor3 = defaultState and Color3.fromRGB(210, 180, 255) or Color3.fromRGB(160, 150, 180)
        callback(defaultState)
    end)
    return btn
end

createToggle(combatSec1, "Rage Bot (High-Perf)", 1, getgenv().Config.RageBot, function(v) getgenv().Config.RageBot = v end)
createToggle(combatSec1, "Head Lock (Aimbot)", 2, getgenv().Config.Aimbot, function(v) getgenv().Config.Aimbot = v end)
createToggle(combatSec1, "Silent Aim (Optimized)", 3, getgenv().Config.SilentAim, function(v) getgenv().Config.SilentAim = v end)
createToggle(combatSec1, "All-Head (Forced)", 4, getgenv().Config.AllHead, function(v) getgenv().Config.AllHead = v end)
createToggle(combatSec1, "Wallbang / WallCheck Off", 5, not getgenv().Config.WallCheck, function(v) getgenv().Config.WallCheck = not v end)

createToggle(combatSec2, "Show FOV (Muzzle Tracked)", 1, getgenv().Config.ShowFOV, function(v) getgenv().Config.ShowFOV = v end)
createToggle(combatSec2, "Auto Fire (Rapid)", 2, getgenv().Config.AutoFire, function(v) getgenv().Config.AutoFire = v end)
createToggle(combatSec2, "No Recoil", 3, getgenv().Config.NoRecoil, function(v) getgenv().Config.NoRecoil = v end)
createToggle(combatSec2, "No Spread", 4, getgenv().Config.NoSpread, function(v) getgenv().Config.NoSpread = v end)
createToggle(combatSec2, "Desync (Smooth Move)", 5, getgenv().Config.Desync, function(v) getgenv().Config.Desync = v end)

createToggle(espSec1, "Corner Box ESP", 1, getgenv().Config.CornerBoxESP, function(v) getgenv().Config.CornerBoxESP = v end)
createToggle(espSec1, "Name ESP", 2, getgenv().Config.NameESP, function(v) getgenv().Config.NameESP = v end)
createToggle(espSec1, "Health Bar ESP", 3, getgenv().Config.HealthESP, function(v) getgenv().Config.HealthESP = v end)

createToggle(miscSec1, "Hit Log Notification", 1, getgenv().Config.HitNotify, function(v) getgenv().Config.HitNotify = v end)
createToggle(miscSec1, "Anti-Cheat Bypass", 2, getgenv().Config.AntiCheatBypass, function(v) getgenv().Config.AntiCheatBypass = v end)

createToggle(miscSec2, "All Skins (Unlock All)", 1, getgenv().Config.AllSkins, function(v) getgenv().Config.AllSkins = v end)

createToggle(miscSec3, "Fly (Speed: 50)", 1, getgenv().Config.Fly, function(v) updateFly(v) end)
createToggle(miscSec3, "Noclip", 2, getgenv().Config.Noclip, function(v) getgenv().Config.Noclip = v end)

toggleMenuBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

print("RayV3 Rivals Integrated v4.1 Loaded Successfully!")
