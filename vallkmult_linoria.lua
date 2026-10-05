--==========================================================================
--  vallkmult | Linoria Library
--  Rivals | PC + Mobile + Gamepad supported
--  Tabs: main / ragebot / esp / ffmode / misc / settings
--  Hard AC (Halmu+) | Rage HUD: vallkmult&NoVa:kill NAME/void
--  No Key / No HWID | Menu: RightControl
--==========================================================================
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
--==========================================================================
--  Platform: PC (Real) / Mobile / Tablet / Gamepad — all supported
--==========================================================================
do
    local UIS = UserInputService
    local function detectPlatform()
        local touch = false
        local kb = false
        local gp = false
        pcall(function() touch = UIS.TouchEnabled == true end)
        pcall(function() kb = UIS.KeyboardEnabled == true end)
        pcall(function() gp = UIS.GamepadEnabled == true end)
        -- PC real: keyboard/mouse, even if touch is also reported
        if kb then return "PC" end
        if touch and not kb then return "Mobile" end
        if gp and not kb then return "Gamepad" end
        return "PC"
    end
    getgenv()._VallkPlatform = detectPlatform()
    -- Prefer CoreGui/gethui on all platforms; PlayerGui fallback for restricted executors
    getgenv()._VallkHudParent = function()
        local h
        pcall(function()
            if gethui then h = gethui() end
        end)
        if h then return h end
        pcall(function() h = game:GetService("CoreGui") end)
        if h then return h end
        pcall(function()
            h = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 3)
        end)
        return h
    end
    print("[vallkmult] platform:", getgenv()._VallkPlatform)
end

--==========================================================================
--  vallkmult Rivals Anti-Cheat Bypass (HARD)
--  From Halmu free + extended Kick / Ban / ClientAlert / MiscController
--  Physics / JumpPower / namecall / getconnections / script cloak
--  Mobile-safe. Does not strip legitimate UseItem / StartShooting.
--==========================================================================
do
    local function LPH_NO_VIRTUALIZE(f) return f end
    local LP = player
    local PlayersSvc = Players
    local RS = RunService

    local BLOCK_REMOTE = {
        kick=true, ban=true, clientalert=true, anticheat=true, detection=true,
        moderation=true, security=true, reportcheat=true, flagplayer=true,
        reportplayer=true, cheatreport=true, antiexploit=true, exploitdetect=true,
        unexpectedbehavior=true, clientmisc=true, clientphysics=true,
        jumppower=true, punish=true, softkick=true, watchdog=true, sentinel=true,
        screenshot=true, crash=true,
    }

    local function remoteBlocked(name)
        if type(name) ~= "string" then return false end
        local low = string.lower(name)
        if BLOCK_REMOTE[low] then return true end
        for k in pairs(BLOCK_REMOTE) do
            if string.find(low, k, 1, true) then return true end
        end
        return false
    end

    -- 1) Direct Kick null + continuous re-null
    local function nullKick()
        pcall(function()
            if LP and typeof(LP.Kick) == "function" then
                LP.Kick = function() end
            end
        end)
    end
    nullKick()

    -- 1b) Soft-block suspicious Teleport spam (keep normal teleports)
    pcall(function()
        local TS = game:GetService("TeleportService")
        if TS and hookfunction and newcclosure and typeof(TS.Teleport) == "function" then
            local oldTP
            oldTP = hookfunction(TS.Teleport, newcclosure(function(self, placeId, ...)
                return oldTP(self, placeId, ...)
            end))
        end
    end)

    -- 2) namecall: Kick + detection remotes (keep UseItem / gameplay)
    pcall(function()
        if not (hookmetamethod and newcclosure and getnamecallmethod) then return end
        local old
        old = hookmetamethod(game, "__namecall", newcclosure(LPH_NO_VIRTUALIZE(function(self, ...)
            local method = getnamecallmethod()
            local m = type(method) == "string" and string.lower(method) or ""
            if m == "kick" then return end
            if m == "fireserver" or m == "invokeserver" or m == "fireserverasync" then
                local ok, nm = pcall(function() return self and self.Name end)
                if ok and remoteBlocked(nm) then return end
                local a1 = select(1, ...)
                if type(a1) == "string" then
                    local low = string.lower(a1)
                    if low:find("unexpected behavior", 1, true)
                        or low:find("client misc", 1, true)
                        or low:find("client physics", 1, true)
                        or low:find("jumppower error", 1, true)
                        or low:find("anticheat", 1, true)
                        or low:find("cheat detect", 1, true)
                        or low:find("exploit", 1, true)
                    then
                        return
                    end
                end
            end
            return old(self, ...)
        end)))
    end)

    -- 3) Instance Kick method via __index
    pcall(function()
        if not (hookmetamethod and newcclosure) then return end
        local old
        old = hookmetamethod(game, "__index", newcclosure(LPH_NO_VIRTUALIZE(function(self, key)
            if key == "Kick" and self == LP then
                return function() end
            end
            return old(self, key)
        end)))
    end)

    -- 4) MiscellaneousController weak-table probe (setmetatable / rawlen)
    pcall(function()
        if not (hookfunction and newcclosure and getcallingscript) then return end
        local Old1
        Old1 = hookfunction(setmetatable, newcclosure(function(Table, MetaTable)
            if type(MetaTable) == "table" and rawget(MetaTable, "__mode") == "kv" then
                local okc, Caller = pcall(getcallingscript)
                if okc and Caller then
                    local n = string.lower(tostring(Caller.Name or ""))
                    if n == "miscellaneouscontroller" or n:find("anticheat", 1, true)
                        or n == "localscript3" or n:find("security", 1, true)
                        or n:find("detection", 1, true) then
                        return Old1(Table, {})
                    end
                end
            end
            return Old1(Table, MetaTable)
        end))
    end)
    pcall(function()
        if not (hookfunction and newcclosure and getcallingscript) then return end
        local Ol2
        Ol2 = hookfunction(rawlen, newcclosure(function(Table)
            if type(Table) == "table" then
                local okc, Caller = pcall(getcallingscript)
                if okc and Caller then
                    local n = string.lower(tostring(Caller.Name or ""))
                    if n == "miscellaneouscontroller" or n:find("anticheat", 1, true)
                        or n:find("security", 1, true) then
                        return 3
                    end
                end
            end
            return Ol2(Table)
        end))
    end)

    -- 5) getrenv setmetatable (desktop) for MiscController
    pcall(function()
        if not (hookfunction and newcclosure and getrenv) then return end
        local renv = getrenv()
        if not renv or not renv.setmetatable then return end
        local oldtable
        oldtable = hookfunction(renv.setmetatable, newcclosure(function(Table, Metatable)
            if Metatable and typeof(Metatable) == "table" and rawget(Metatable, "__mode") == "kv" then
                local ok, trace = pcall(debug.traceback)
                if ok and type(trace) == "string" then
                    if trace:find("MiscellaneousController", 1, true)
                        or trace:find("LocalScript3", 1, true)
                        or trace:find("AntiCheat", 1, true)
                        or trace:find("Security", 1, true)
                    then
                        return oldtable({1, 2, 3}, {})
                    end
                end
            end
            return oldtable(Table, Metatable)
        end))
    end)

    -- 6) Fake ClientAlert + mute ScriptContext.Error
    pcall(function()
        if LP:FindFirstChild("ClientAlert") then return end
        local fake = Instance.new("RemoteEvent")
        fake.Name = "ClientAlert"
        fake.Parent = LP
    end)
    pcall(function()
        local sc = game:GetService("ScriptContext")
        if sc and sc.Error then sc.Error:Connect(function() end) end
    end)
    pcall(function()
        if setfflag then
            pcall(setfflag, "DebugRunServiceHumanoidCheck", "False")
            pcall(setfflag, "HumanoidParallelPropertyRegistrationEnabled", "False")
        end
    end)

    -- 7) Hide AC script names from probes
    pcall(function()
        if not (hookmetamethod and newcclosure and getcallingscript) then return end
        local detecteds = {
            localscript3 = true, miscellaneouscontroller = true, anticheat = true,
            security = true, detection = true, moderation = true, clientalert = true,
            antiexploit = true, exploitdetect = true,
        }
        local callerVerdicts = setmetatable({}, { __mode = "k" })
        local original
        original = hookmetamethod(game, "__index", newcclosure(LPH_NO_VIRTUALIZE(function(self, key)
            if key == "Name" or key == "Text" then
                local okc, caller = pcall(getcallingscript)
                if okc and caller then
                    local blocked = callerVerdicts[caller]
                    if blocked == nil then
                        local ok, result = pcall(function()
                            local n = original(caller, "Name")
                            return type(n) == "string" and detecteds[string.lower(n)] == true
                        end)
                        blocked = ok and result or false
                        callerVerdicts[caller] = blocked
                    end
                    if blocked then return "" end
                end
            end
            if key == "Kick" and self == LP then
                return function() end
            end
            return original(self, key)
        end)))
    end)

    -- 8) Disconnect AC Kick connections via getconnections
    task.spawn(function()
        if not getconnections then return end
        pcall(function()
            if LP and LP.Kick then
                for _, c in ipairs(getconnections(LP.Kick) or {}) do
                    pcall(function() c:Disable() end)
                    pcall(function() c:Disconnect() end)
                end
            end
        end)
        local function onChar(char)
            task.defer(function()
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not hum or not getconnections then return end
                for _, prop in ipairs({"JumpPower", "WalkSpeed", "HipHeight", "MaxHealth"}) do
                    pcall(function()
                        local sig = hum:GetPropertyChangedSignal(prop)
                        for _, c in ipairs(getconnections(sig) or {}) do
                            -- soft: leave gameplay watchers
                        end
                    end)
                end
            end)
        end
        if LP.Character then onChar(LP.Character) end
        LP.CharacterAdded:Connect(onChar)
    end)

    -- 9) Disable known AC LocalScripts / ModuleScripts (chunked, mobile-safe)
    task.spawn(function()
        local acWords = {
            "anticheat", "detection", "ban", "moderation", "security", "clientalert",
            "exploit", "cheatdetect", "punish", "softkick", "watchdog", "sentinel"
        }
        local function maybeDisable(obj)
            if not obj or not (obj:IsA("LocalScript") or obj:IsA("ModuleScript")) then return end
            local n = string.lower(obj.Name or "")
            if n:find("fighter", 1, true) or n:find("camera", 1, true)
                or n:find("control", 1, true) or n:find("replication", 1, true)
                or n:find("item", 1, true) or n:find("gun", 1, true)
                or n:find("character", 1, true) or n:find("animate", 1, true)
            then return end
            for _, ac in ipairs(acWords) do
                if string.find(n, ac, 1, true) then
                    pcall(function() obj.Disabled = true end)
                    break
                end
            end
            if n == "localscript3" or n == "miscellaneouscontroller" then
                pcall(function() obj.Disabled = true end)
            end
        end
        local roots = {}
        pcall(function() table.insert(roots, LP:FindFirstChild("PlayerScripts")) end)
        pcall(function() table.insert(roots, game:GetService("ReplicatedFirst")) end)
        pcall(function() table.insert(roots, game:GetService("StarterPlayer")) end)
        for _, root in ipairs(roots) do
            if not root then continue end
            pcall(function()
                root.DescendantAdded:Connect(function(o) task.defer(maybeDisable, o) end)
            end)
            local ok, desc = pcall(function() return root:GetDescendants() end)
            if ok and type(desc) == "table" then
                for i = 1, #desc do
                    maybeDisable(desc[i])
                    if i % 200 == 0 then task.wait() end
                end
            end
        end
    end)

    -- 10) Continuous Kick re-null + ClientAlert re-fake
    task.spawn(function()
        while not (K and K.destroyed) do
            nullKick()
            pcall(function()
                if not LP:FindFirstChild("ClientAlert") then
                    local fake = Instance.new("RemoteEvent")
                    fake.Name = "ClientAlert"
                    fake.Parent = LP
                end
            end)
            task.wait(1.5)
        end
    end)

    -- 11) Network owner soft-hold (Halmu pattern)
    task.spawn(function()
        local last = 0
        while not (K and K.destroyed) do
            if tick() - last >= 3 then
                last = tick()
                pcall(function()
                    local char = LP.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp and hrp.SetNetworkOwner then
                        hrp:SetNetworkOwner(LP)
                    end
                end)
            end
            task.wait(0.5)
        end
    end)

    print("[vallkmult] AC bypass armed (Halmu + hard Rivals)")
end

--==========================================================================
--  Rage status HUD (white, bottom) — PC + Mobile
--  ON+target -> vallkmult&NoVa:kill NAME
--  ON+none   -> vallkmult&NoVa:kill void
--  OFF       -> hidden
--==========================================================================
task.spawn(function()
    getgenv()._VallkRageEnabled = getgenv()._VallkRageEnabled or false
    getgenv()._VallkRageStatus = getgenv()._VallkRageStatus or "vallkmult&NoVa:kill void"
    local parent = nil
    pcall(function()
        if getgenv()._VallkHudParent then parent = getgenv()._VallkHudParent() end
    end)
    if not parent then
        pcall(function() parent = (gethui and gethui()) or game:GetService("CoreGui") end)
    end
    if not parent then
        parent = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)
    end
    if not parent then return end
    pcall(function()
        local old = parent:FindFirstChild("VallkRageStatusHUD")
        if old then old:Destroy() end
    end)
    local gui = Instance.new("ScreenGui")
    gui.Name = "VallkRageStatusHUD"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 9999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() gui.Parent = parent end)
    if not gui.Parent then
        pcall(function() gui.Parent = game:GetService("CoreGui") end)
    end
    if not gui.Parent then
        pcall(function()
            gui.Parent = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 3)
        end)
    end
    local label = Instance.new("TextLabel")
    label.Name = "Status"
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0, 560, 0, 22)
    label.Position = UDim2.new(0.5, -280, 1, -40)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0.3
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Text = ""
    label.Visible = false
    label.Parent = gui
    if K and K.onUnload then
        K.onUnload(function() pcall(function() gui:Destroy() end) end)
    end
    while not (K and K.destroyed) do
        local on = getgenv()._VallkRageEnabled == true
        if on then
            local st = getgenv()._VallkRageStatus
            if type(st) ~= "string" or st == "" then
                st = "vallkmult&NoVa:kill void"
            end
            label.Text = st
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.Visible = true
        else
            label.Text = ""
            label.Visible = false
        end
        task.wait(0.05)
    end
end)




local rawget, rawset = rawget, rawset

function K.fn(name)
    local v
    pcall(function() v = getfenv(0)[name] end)
    if type(v) ~= "function" then pcall(function() v = getfenv()[name] end) end
    return type(v) == "function" and v or nil
end

--==========================================================================
--  Rage status HUD (white, bottom) — PC + Mobile
--  ON+target -> vallkmult&NoVa:kill NAME
--  ON+none   -> vallkmult&NoVa:kill void
--  OFF       -> hidden
--==========================================================================
task.spawn(function()
    getgenv()._VallkRageEnabled = getgenv()._VallkRageEnabled or false
    getgenv()._VallkRageStatus = getgenv()._VallkRageStatus or "vallkmult&NoVa:kill void"
    local parent = nil
    pcall(function()
        if getgenv()._VallkHudParent then parent = getgenv()._VallkHudParent() end
    end)
    if not parent then
        pcall(function() parent = (gethui and gethui()) or game:GetService("CoreGui") end)
    end
    if not parent then
        parent = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)
    end
    if not parent then return end
    pcall(function()
        local old = parent:FindFirstChild("VallkRageStatusHUD")
        if old then old:Destroy() end
    end)
    local gui = Instance.new("ScreenGui")
    gui.Name = "VallkRageStatusHUD"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 9999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() gui.Parent = parent end)
    if not gui.Parent then
        pcall(function() gui.Parent = game:GetService("CoreGui") end)
    end
    if not gui.Parent then
        pcall(function()
            gui.Parent = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 3)
        end)
    end
    local label = Instance.new("TextLabel")
    label.Name = "Status"
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0, 560, 0, 22)
    label.Position = UDim2.new(0.5, -280, 1, -40)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0.3
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Text = ""
    label.Visible = false
    label.Parent = gui
    if K and K.onUnload then
        K.onUnload(function() pcall(function() gui:Destroy() end) end)
    end
    while not (K and K.destroyed) do
        local on = getgenv()._VallkRageEnabled == true
        if on then
            local st = getgenv()._VallkRageStatus
            if type(st) ~= "string" or st == "" then
                st = "vallkmult&NoVa:kill void"
            end
            label.Text = st
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.Visible = true
        else
            label.Text = ""
            label.Visible = false
        end
        task.wait(0.05)
    end
end)


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
    IntroLabel.Text = "Dv.a Premium"
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

-- Custom crosshair (from vallkmult)
local customCrosshairEnabled = false
local crosshairSpinEnabled = false
local crosshairSpinSpeed = 2
local crosshairPulseEnabled = false
local crosshairPulseSpeed = 3
local crosshairPulseIntensity = 5
local crosshairGap = 5
local crosshairLineSize = 10
local crosshairColor = Color3.fromRGB(255, 255, 255)

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
    logLabel.Text = string.format("(Dv.a hit %s damage: %.1f)", targetName, damage)
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

local function updateCrosshairLayout()
    local gap = crosshairGap or 5
    local sz = crosshairLineSize or 10
    -- Left
    crosshairLines[1].Line.Size = UDim2.new(0, sz, 0, 2)
    crosshairLines[1].Line.Position = UDim2.new(0.5, -gap - sz, 0.5, -1)
    -- Right
    crosshairLines[2].Line.Size = UDim2.new(0, sz, 0, 2)
    crosshairLines[2].Line.Position = UDim2.new(0.5, gap, 0.5, -1)
    -- Up
    crosshairLines[3].Line.Size = UDim2.new(0, 2, 0, sz)
    crosshairLines[3].Line.Position = UDim2.new(0.5, -1, 0.5, -gap - sz)
    -- Down
    crosshairLines[4].Line.Size = UDim2.new(0, 2, 0, sz)
    crosshairLines[4].Line.Position = UDim2.new(0.5, -1, 0.5, gap)
    for _, item in ipairs(crosshairLines) do
        item.Line.BackgroundColor3 = crosshairColor or Color3.fromRGB(255, 255, 255)
    end
end
updateCrosshairLayout()

-- Custom crosshair spin + pulse (vallkmult style)
local ccAngle = 0
local ccAnimTimer = 0
RunService.RenderStepped:Connect(function(dt)
    if customCrosshairEnabled then
        CrosshairContainer.Visible = true
        if crosshairSpinEnabled then
            ccAngle = (ccAngle + ((crosshairSpinSpeed or 2) * dt * 50)) % 360
            CrosshairContainer.Rotation = ccAngle
        else
            if not ragebotOrKillAura then
                CrosshairContainer.Rotation = 0
            end
        end
        if crosshairPulseEnabled then
            ccAnimTimer = ccAnimTimer + (dt * (crosshairPulseSpeed or 3))
            local pulseOffset = math.sin(ccAnimTimer) * (crosshairPulseIntensity or 5)
            local baseGap = crosshairGap or 5
            local sz = crosshairLineSize or 10
            local dynamicGap = math.max(1, baseGap + pulseOffset)
            crosshairLines[1].Line.Size = UDim2.new(0, sz, 0, 2)
            crosshairLines[1].Line.Position = UDim2.new(0.5, -dynamicGap - sz, 0.5, -1)
            crosshairLines[2].Line.Size = UDim2.new(0, sz, 0, 2)
            crosshairLines[2].Line.Position = UDim2.new(0.5, dynamicGap, 0.5, -1)
            crosshairLines[3].Line.Size = UDim2.new(0, 2, 0, sz)
            crosshairLines[3].Line.Position = UDim2.new(0.5, -1, 0.5, -dynamicGap - sz)
            crosshairLines[4].Line.Size = UDim2.new(0, 2, 0, sz)
            crosshairLines[4].Line.Position = UDim2.new(0.5, -1, 0.5, dynamicGap)
        end
        for _, item in ipairs(crosshairLines) do
            item.Line.BackgroundColor3 = crosshairColor or Color3.fromRGB(255, 255, 255)
        end
    end
end)


local RageTextLabel = Instance.new("TextLabel", RageUIGui)
RageTextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
RageTextLabel.Position = UDim2.new(0.5, 0, 0.5, 25)
RageTextLabel.Size = UDim2.new(0, 280, 0, 20)
RageTextLabel.BackgroundTransparency = 1
RageTextLabel.Text = "Dv.a:kill Void"
RageTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
RageTextLabel.TextStrokeTransparency = 0
RageTextLabel.Font = Enum.Font.GothamBold
RageTextLabel.TextSize = 12
RageTextLabel.TextXAlignment = Enum.TextXAlignment.Center
RageTextLabel.Visible = false

local rageHue = 0
local rotAngle = 0
local lastRageTargetName = nil
local lastKillShowUntil = 0
local lastKillName = nil

RunService.RenderStepped:Connect(function()
    -- Keep container visible for custom CH or rage
    if customCrosshairEnabled or ragebotOrKillAura then
        CrosshairContainer.Visible = true
    elseif not customCrosshairEnabled then
        -- leave visibility to other systems
    end
    RageTextLabel.Visible = ragebotOrKillAura
    if RageTextLabel.Visible then
        -- status text always white; rainbow only if custom CH color not forced
        rageHue = (rageHue + 2) % 360
        local rainbowColor = Color3.fromHSV(rageHue / 360, 1, 1)
        if not customCrosshairEnabled then
            for _, item in ipairs(crosshairLines) do item.Line.BackgroundColor3 = rainbowColor end
        end
        RageTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

        if not (customCrosshairEnabled and crosshairSpinEnabled) then
            rotAngle = (rotAngle + 4) % 360
            CrosshairContainer.Rotation = rotAngle
        end

        if not (customCrosshairEnabled and crosshairPulseEnabled) then
            local timeVal = tick() * 5
            local pulse = (math.sin(timeVal) + 1) * 0.5
            crosshairLines[1].Line.Position = UDim2.new(0, math.floor(3 + pulse * 6), 0.5, -1)
            crosshairLines[2].Line.Position = UDim2.new(1, math.floor(-11 - pulse * 6), 0.5, -1)
            crosshairLines[3].Line.Position = UDim2.new(0.5, -1, 0, math.floor(3 + pulse * 6))
            crosshairLines[4].Line.Position = UDim2.new(0.5, -1, 1, math.floor(-11 - pulse * 6))
        end

        local now = tick()

        if activeTargetPart and activeTargetPart.Parent then
            local tModel = activeTargetPart:FindFirstAncestorOfClass("Model") or activeTargetPart.Parent
            local plr = Players:GetPlayerFromCharacter(tModel)
            local targetName = (plr and (plr.DisplayName or plr.Name)) or (tModel and tModel.Name) or "Unknown"
            local hum = tModel and tModel:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health <= 0 then
                -- 상대 사망
                lastKillName = targetName
                lastKillShowUntil = now + 2.5
                lastRageTargetName = nil
                RageTextLabel.Text = "Dv.a & NoVa kill " .. targetName
            else
                lastRageTargetName = targetName
                RageTextLabel.Text = "Dv.a:kill " .. targetName
            end
        else
            if lastRageTargetName then
                -- 타겟 소실 = 킬로 처리
                lastKillName = lastRageTargetName
                lastKillShowUntil = now + 2.5
                lastRageTargetName = nil
            end
            if lastKillName and now < lastKillShowUntil then
                RageTextLabel.Text = "Dv.a & NoVa kill " .. lastKillName
            else
                RageTextLabel.Text = "Dv.a:kill Void"
            end
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



-- ============================================================================
-- SECTION: Linoria Library UI (Moon-style dark layout)
-- ============================================================================
local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local function _vallkLoadLinoria()
    local repos = {
        'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/',
        'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/',
        'https://raw.githubusercontent.com/ActualMasterOogway/Linoria-Library/main/',
    }
    local Library, ThemeManager, SaveManager
    local used
    for _, r in ipairs(repos) do
        local okL, lib = pcall(function() return loadstring(game:HttpGet(r .. 'Library.lua'))() end)
        if okL and lib then
            Library = lib
            used = r
            pcall(function() ThemeManager = loadstring(game:HttpGet(r .. 'addons/ThemeManager.lua'))() end)
            pcall(function() SaveManager = loadstring(game:HttpGet(r .. 'addons/SaveManager.lua'))() end)
            break
        end
    end
    if not Library then
        error('[vallkmult] Linoria Library HTTP load failed')
    end
    print('[vallkmult] Linoria from', tostring(used))
    return Library, ThemeManager, SaveManager
end
local Library, ThemeManager, SaveManager = _vallkLoadLinoria()

-- Lunara-style: pure black panels + bright sky/cyan blue accents
pcall(function()
    Library.Scheme = Library.Scheme or {}
    local S = Library.Scheme
    S.FontColor = Color3.fromRGB(240, 248, 255)
    S.MainColor = Color3.fromRGB(12, 12, 14)           -- near-black panel
    S.BackgroundColor = Color3.fromRGB(8, 8, 10)       -- window bg
    S.OutlineColor = Color3.fromRGB(0, 170, 255)       -- cyan border like Lunara
    S.AccentColor = Color3.fromRGB(0, 180, 255)        -- sky blue buttons / toggles
    S.AccentColorDark = Color3.fromRGB(0, 130, 210)
    S.AccentColorLight = Color3.fromRGB(80, 210, 255)
    S.RiskColor = Color3.fromRGB(255, 80, 90)
    S.InlineColor = Color3.fromRGB(18, 20, 24)
    S.LightContrast = Color3.fromRGB(28, 32, 40)
    S.DarkContrast = Color3.fromRGB(6, 6, 8)
end)

-- Keep forcing sky-blue accent (ThemeManager can overwrite)
local function applySkyBlueTheme()
    pcall(function()
        local S = Library.Scheme or {}
        S.AccentColor = Color3.fromRGB(0, 180, 255)
        S.AccentColorDark = Color3.fromRGB(0, 130, 210)
        S.AccentColorLight = Color3.fromRGB(80, 210, 255)
        S.OutlineColor = Color3.fromRGB(0, 170, 255)
        S.BackgroundColor = Color3.fromRGB(8, 8, 10)
        S.MainColor = Color3.fromRGB(12, 12, 14)
        if Library.UpdateColors then Library.UpdateColors() end
    end)
end
task.defer(applySkyBlueTheme)
task.delay(0.5, applySkyBlueTheme)

-- Hide system / executor mouse cursor on mobile (touch devices)
task.spawn(function()
    pcall(function()
        UserInputService.MouseIconEnabled = false
    end)
    pcall(function()
        if typeof(UserInputService.MouseIcon) == "string" or typeof(UserInputService.MouseIcon) == "Content" then
            UserInputService.MouseIcon = ""
        end
    end)
    -- destroy common custom cursor GUIs
    local function wipeCursors(root)
        if not root then return end
        for _, n in ipairs({"CustomCursorGui", "CustomCursor", "MouseCursor", "CursorGui", "ExecutorCursor"}) do
            local o = root:FindFirstChild(n)
            if o then pcall(function() o:Destroy() end) end
        end
    end
    pcall(function() wipeCursors(CoreGui) end)
    pcall(function() wipeCursors(PlayerGui) end)
    pcall(function() if gethui then wipeCursors(gethui()) end end)
    -- keep mouse icon off while script runs (mobile)
    RunService.Heartbeat:Connect(function()
        pcall(function()
            if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
                UserInputService.MouseIconEnabled = false
            end
        end)
    end)
end)


local Window = Library:CreateWindow({
    Title = 'vallkmult',
    Center = true,
    AutoShow = true,
    TabPadding = 6,
    MenuFadeTime = 0.15,
})

-- Tabs ordered similar to reference: main / combat-heavy first
local Tabs = {
    Main   = Window:AddTab('main'),
    Rage   = Window:AddTab('ragebot'),
    ESP    = Window:AddTab('esp'),
    FF     = Window:AddTab('ffmode'),
    Misc   = Window:AddTab('misc'),
    UISet  = Window:AddTab('settings'),
}

-- ========== MAIN (layout like screenshot: left silent/aimbot, right weapons/settings) ==========
local SilentGroup = Tabs.Main:AddLeftGroupbox('silent aim')
local AimGroup = Tabs.Main:AddLeftGroupbox('aimbot')
local WeaponGroup = Tabs.Main:AddRightGroupbox('weapons')
local FovGroup = Tabs.Main:AddRightGroupbox('fov settings')
local MobileMainGroup = Tabs.Main:AddRightGroupbox('mobile settings')

SilentGroup:AddToggle('SilentAim', {
    Text = 'enabled',
    Default = false,
    Callback = function(v) silentAimEnabled = v end,
})
SilentGroup:AddDropdown('SilentHitbox', {
    Values = { 'head', 'humanoidrootpart', 'torso' },
    Default = 1,
    Multi = false,
    Text = 'closest part',
    Callback = function(v) silentAimHitPart = v end,
})
SilentGroup:AddSlider('SilentFOV', {
    Text = 'max distance / fov',
    Default = 300, Min = 10, Max = 500, Rounding = 0,
    Callback = function(v) silentAimFovRadius = v end,
})
SilentGroup:AddToggle('SilentDrawFOV', {
    Text = 'show fov',
    Default = false,
    Callback = function(v) silentAimDrawFov = v end,
})
SilentGroup:AddToggle('SilentWall', {
    Text = 'wall check',
    Default = false,
    Callback = function(v) silentWallCheck = v end,
})
SilentGroup:AddSlider('AimbotSmoothX', {
    Text = 'x smooth',
    Default = 5, Min = 1, Max = 20, Rounding = 0,
    Callback = function(v) aimbotSmoothness = v end,
})

AimGroup:AddToggle('AimbotEnable', {
    Text = 'enabled',
    Default = false,
    Callback = function(v) aimbotEnabled = v end,
})
AimGroup:AddDropdown('AimbotHitbox', {
    Values = { 'head', 'humanoidrootpart', 'torso' },
    Default = 1,
    Multi = false,
    Text = 'closest part',
    Callback = function(v) aimbotHitPart = v end,
})
AimGroup:AddSlider('AimbotFOV', {
    Text = 'radius',
    Default = 100, Min = 10, Max = 500, Rounding = 0,
    Callback = function(v) aimbotFovRadius = v end,
})
AimGroup:AddSlider('AimbotSmooth', {
    Text = 'smoothing',
    Default = 5, Min = 1, Max = 20, Rounding = 0,
    Callback = function(v) aimbotSmoothness = v end,
})
AimGroup:AddToggle('AimbotDrawFOV', {
    Text = 'show fov',
    Default = false,
    Callback = function(v) aimbotDrawFov = v end,
})
AimGroup:AddToggle('AimbotWall', {
    Text = 'wall check',
    Default = false,
    Callback = function(v) aimbotWallCheck = v end,
})
AimGroup:AddToggle('AimbotScope', {
    Text = 'check scoped if',
    Default = false,
    Callback = function(v) aimbotScopeLook = v end,
})

WeaponGroup:AddToggle('NoSpread', {
    Text = 'no spread',
    Default = false,
    Callback = function(v) noSpreadEnabled = v end,
})
WeaponGroup:AddToggle('FastMelee', {
    Text = 'fastshoot / melee',
    Default = false,
    Callback = function(v) fastMeleeEnabled = v end,
})
WeaponGroup:AddToggle('RapidFire', {
    Text = 'fast projectile',
    Default = false,
    Callback = function(v) rapidFireEnabled = v end,
})
WeaponGroup:AddToggle('NoRecoil', {
    Text = 'full auto / no recoil',
    Default = false,
    Callback = function(v) noRecoilEnabled = v end,
})
WeaponGroup:AddToggle('NoCooldown', {
    Text = 'always backstab / no cd',
    Default = false,
    Callback = function(v) hoNyangNoCDEnabled = v end,
})
WeaponGroup:AddToggle('NoMuzzle', {
    Text = 'no muzzle flash',
    Default = false,
    Callback = function(v) noMuzzleFlashEnabled = v end,
})
WeaponGroup:AddToggle('BulletBoost', {
    Text = 'bullet speed boost',
    Default = false,
    Callback = function(v) bulletSpeedBoost = v end,
})

FovGroup:AddToggle('CircleCH', {
    Text = 'circle crosshair',
    Default = false,
    Callback = function(v) circleCrosshairEnabled = v end,
})
FovGroup:AddSlider('CircleSize', {
    Text = 'radius',
    Default = 60, Min = 10, Max = 300, Rounding = 0,
    Callback = function(v) circleCrosshairSize = v end,
})

-- Custom crosshair (vallkmult port)
FovGroup:AddToggle('CustomCH', {
    Text = 'enable custom crosshair',
    Default = false,
    Callback = function(v)
        customCrosshairEnabled = v
        CrosshairContainer.Visible = v or ragebotOrKillAura
        if v then updateCrosshairLayout() end
    end,
})
FovGroup:AddSlider('CHSize', {
    Text = 'crosshair line length',
    Default = 10, Min = 2, Max = 30, Rounding = 0,
    Callback = function(v)
        crosshairLineSize = v
        updateCrosshairLayout()
    end,
})
FovGroup:AddSlider('CHGap', {
    Text = 'crosshair gap',
    Default = 5, Min = 0, Max = 30, Rounding = 0,
    Callback = function(v)
        crosshairGap = v
        updateCrosshairLayout()
    end,
})
pcall(function()
    FovGroup:AddLabel('crosshair color'):AddColorPicker('CHColor', {
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(v)
            crosshairColor = v
            for _, item in ipairs(crosshairLines) do
                item.Line.BackgroundColor3 = v
            end
        end,
    })
end)
FovGroup:AddToggle('CHSpin', {
    Text = 'crosshair spin',
    Default = false,
    Callback = function(v) crosshairSpinEnabled = v end,
})
FovGroup:AddSlider('CHSpinSpeed', {
    Text = 'spin speed',
    Default = 2, Min = 1, Max = 10, Rounding = 0,
    Callback = function(v) crosshairSpinSpeed = v end,
})
FovGroup:AddToggle('CHPulse', {
    Text = 'crosshair pulse (breathe)',
    Default = false,
    Callback = function(v) crosshairPulseEnabled = v end,
})
FovGroup:AddSlider('CHPulseSpeed', {
    Text = 'pulse speed',
    Default = 3, Min = 1, Max = 10, Rounding = 1,
    Callback = function(v) crosshairPulseSpeed = v end,
})
FovGroup:AddSlider('CHPulseInt', {
    Text = 'pulse intensity',
    Default = 5, Min = 1, Max = 20, Rounding = 0,
    Callback = function(v) crosshairPulseIntensity = v end,
})

MobileMainGroup:AddToggle('MobileModeUI', {
    Text = 'enabled',
    Default = false,
    Callback = function(v) mobileOnEnabled = v end,
})
MobileMainGroup:AddToggle('MobileFly', {
    Text = 'mobile fly',
    Default = false,
    Callback = function(v) mobileFlyEnabled = v end,
})

-- ========== RAGEBOT ==========
local RageGroup = Tabs.Rage:AddLeftGroupbox('rage engine')
local LionGroup = Tabs.Rage:AddRightGroupbox('orbit / void')
local ExtraGroup = Tabs.Rage:AddLeftGroupbox('extra orbit & void spam')

RageGroup:AddToggle('RageEnable', {
    Text = 'enabled',
    Default = false,
    Callback = function(v) ragebotOrKillAura = v end,
})
RageGroup:AddSlider('HideDelay', {
    Text = 'hide delay',
    Default = 0.01, Min = 0.01, Max = 1.0, Rounding = 2,
    Callback = function(v) ragebotHideDelay = v end,
})
RageGroup:AddSlider('AttackDelay', {
    Text = 'attack delay',
    Default = 0.01, Min = 0.01, Max = 1.0, Rounding = 2,
    Callback = function(v) ragebotAttackDelay = v end,
})
RageGroup:AddSlider('HeightOffset', {
    Text = 'height offset',
    Default = 3, Min = 0, Max = 10, Rounding = 1,
    Callback = function(v) ragebotHeightOffset = v end,
})
RageGroup:AddDropdown('RageMode', {
    Values = { 'Orbit', 'Teleport', 'Void', 'Underground' },
    Default = 1,
    Multi = false,
    Text = 'mode',
    Callback = function(v) ragebotMode = v end,
})
RageGroup:AddToggle('HyperShoot', {
    Text = 'hyper (always shoot)',
    Default = false,
    Callback = function(v) ragebotHyper = v end,
})
RageGroup:AddToggle('AAInRage', {
    Text = 'anti aim in rage',
    Default = false,
    Callback = function(v) ragebotAntiAimInRage = v end,
})

LionGroup:AddSlider('OrbitDist', {
    Text = 'orbit dist',
    Default = 3, Min = 1, Max = 8, Rounding = 1,
    Callback = function(v) ragebotOrbitDist = v end,
})
LionGroup:AddSlider('OrbitHeight', {
    Text = 'orbit height',
    Default = 2, Min = -2, Max = 8, Rounding = 1,
    Callback = function(v) ragebotOrbitHeight = v end,
})
LionGroup:AddSlider('TeleportDelay', {
    Text = 'teleport delay',
    Default = 0.04, Min = 0.01, Max = 0.5, Rounding = 2,
    Callback = function(v) ragebotTeleportDelay = v end,
})
LionGroup:AddSlider('UndergroundDepth', {
    Text = 'underground depth',
    Default = 6, Min = 3, Max = 12, Rounding = 1,
    Callback = function(v) ragebotUndergroundDepth = v end,
})
LionGroup:AddSlider('VoidHideTime', {
    Text = 'void hide time',
    Default = 0.25, Min = 0.01, Max = 1.0, Rounding = 2,
    Callback = function(v) ragebotVoidHideTime = v end,
})
LionGroup:AddSlider('VoidShootTime', {
    Text = 'void shoot time',
    Default = 0.03, Min = 0.01, Max = 0.5, Rounding = 2,
    Callback = function(v) ragebotVoidShootTime = v end,
})
LionGroup:AddToggle('DirBack', {Text='dir: back', Default=true, Callback=function(v) ragebotDirBack=v end})
LionGroup:AddToggle('DirFront', {Text='dir: front', Default=false, Callback=function(v) ragebotDirFront=v end})
LionGroup:AddToggle('DirLeft', {Text='dir: left', Default=true, Callback=function(v) ragebotDirLeft=v end})
LionGroup:AddToggle('DirRight', {Text='dir: right', Default=true, Callback=function(v) ragebotDirRight=v end})
LionGroup:AddToggle('DirUp', {Text='dir: up', Default=true, Callback=function(v) ragebotDirUp=v end})
LionGroup:AddToggle('DirDown', {Text='dir: down', Default=false, Callback=function(v) ragebotDirDown=v end})

ExtraGroup:AddToggle('OrbitNexlib', {
    Text = 'orbit enabled',
    Default = false,
    Callback = function(v)
        orbitEnabled = v
        if not v then orbitAnchorPos = nil end
    end,
})
ExtraGroup:AddSlider('OrbitStuds', {
    Text = 'orbit studs',
    Default = 50000000, Min = 5, Max = 50000000, Rounding = 0,
    Callback = function(v) orbitRange = v end,
})
ExtraGroup:AddSlider('OrbitDelay', {
    Text = 'orbit delay',
    Default = 0.01, Min = 0.01, Max = 1, Rounding = 2,
    Callback = function(v) orbitDelay = v end,
})
ExtraGroup:AddToggle('VoidSpamHeight', {
    Text = 'void spam (height lock)',
    Default = false,
    Callback = function(v) voidSpamEnabled = v end,
})
ExtraGroup:AddSlider('VoidSpamY', {
    Text = 'void spam y',
    Default = 50, Min = 50, Max = 50000000, Rounding = 0,
    Callback = function(v) voidSpamRange = v end,
})
ExtraGroup:AddSlider('VoidDelay', {
    Text = 'void delay',
    Default = 0.01, Min = 0.01, Max = 1, Rounding = 2,
    Callback = function(v) voidSpamDelay = v end,
})

-- ========== ESP ==========
local ESPGroup = Tabs.ESP:AddLeftGroupbox('visual esp')
ESPGroup:AddToggle('ESPMaster', {Text='enabled', Default=false, Callback=function(v) espEnabled=v end})
ESPGroup:AddToggle('ESPBox', {Text='boxes', Default=false, Callback=function(v) espBoxEnabled=v end})
ESPGroup:AddToggle('ESPName', {Text='names', Default=false, Callback=function(v) espNameEnabled=v end})
ESPGroup:AddToggle('ESPDist', {Text='distance', Default=true, Callback=function(v) espDistanceEnabled=v end})
ESPGroup:AddToggle('ESPHP', {Text='health', Default=false, Callback=function(v) espHealthEnabled=v end})
ESPGroup:AddToggle('ESPSkel', {Text='skeleton', Default=false, Callback=function(v) espSkeletonEnabled=v end})
ESPGroup:AddToggle('ESPTracer', {Text='gun tracer', Default=false, Callback=function(v) gunTracerEnabled=v end})

-- ========== FFMODE ==========
local FFGroup = Tabs.FF:AddLeftGroupbox('ff mode')
FFGroup:AddToggle('FFEnable', {Text='enabled', Default=false, Callback=function(v) ffModeEnabled=v end})
FFGroup:AddToggle('FFTeam', {Text='team check', Default=true, Callback=function(v) ffTeamCheckEnabled=v end})
FFGroup:AddToggle('FFBait', {Text='baiting', Default=false, Callback=function(v) ffBaitingEnabled=v end})

-- ========== MISC ==========
local MoveGroup = Tabs.Misc:AddLeftGroupbox('movement')
local SpoofGroup = Tabs.Misc:AddRightGroupbox('device spoofer')
local AAGroup = Tabs.Misc:AddLeftGroupbox('anti aim')
local KatanaGroup = Tabs.Misc:AddRightGroupbox('anti katana')

MoveGroup:AddToggle('PCFly', {Text='pc fly (wasd)', Default=false, Callback=function(v) pcFlyEnabled=v end})
MoveGroup:AddToggle('AllSkins', {
    Text = 'unlock all skins',
    Default = false,
    Callback = function(v)
        skinChangerEnabled = v
        if v and _G.vallkRefreshAllSkins then pcall(_G.vallkRefreshAllSkins) end
    end,
})
MoveGroup:AddToggle('RapidSpeed', {Text='rapid speed', Default=false, Callback=function(v) rapidSpeedEnabled=v end})
MoveGroup:AddToggle('Noclip', {Text='noclip', Default=false, Callback=function(v) noclipEnabled=v end})

SpoofGroup:AddToggle('SpoofEnable', {
    Text = 'enabled',
    Default = false,
    Callback = function(v)
        deviceSpooferEnabled = v
        if v then fireDeviceSetControls() end
    end,
})
SpoofGroup:AddDropdown('SpoofDevice', {
    Values = { 'VR', 'Touch', 'Gamepad', 'MouseKeyboard' },
    Default = 1,
    Multi = false,
    Text = 'device',
    Callback = function(v)
        spoofedDeviceMode = normalizeDeviceMode(v)
        if deviceSpooferEnabled then fireDeviceSetControls() end
    end,
})

AAGroup:AddToggle('AAEnable', {
    Text = 'enabled',
    Default = false,
    Callback = function(v) setAntiAimEnabled(v) end,
})
AAGroup:AddDropdown('AAPitch', {
    Values = { 'disabled', 'up', 'down', 'zero', 'random' },
    Default = 1,
    Multi = false,
    Text = 'pitch',
    Callback = function(v)
        antiAimPitchMode = v
        if _G.AntiAimPoseConfig then _G.AntiAimPoseConfig.pitch = v end
    end,
})
AAGroup:AddDropdown('AAYaw', {
    Values = { 'disabled', 'backwards', 'spin', 'random' },
    Default = 1,
    Multi = false,
    Text = 'yaw',
    Callback = function(v)
        antiAimYawMode = v
        if _G.AntiAimPoseConfig then _G.AntiAimPoseConfig.yaw = v end
    end,
})
AAGroup:AddToggle('AAUnderground', {
    Text = 'underground',
    Default = false,
    Callback = function(v)
        antiAimUnderground = v
        if _G.AntiAimPoseConfig then _G.AntiAimPoseConfig.underground = v end
    end,
})

KatanaGroup:AddToggle('KatanaEnable', {
    Text = 'enabled',
    Default = false,
    Callback = function(v)
        antiKatanaEnabled = v
        if _G.AntiKatanaState then _G.AntiKatanaState.Enabled = v end
    end,
})
KatanaGroup:AddToggle('KatanaSound', {
    Text = 'deflect block sound',
    Default = false,
    Callback = function(v) antiKatanaSoundEnabled = v end,
})

-- ========== SETTINGS ==========
local HSGroup = Tabs.UISet:AddLeftGroupbox('hit sound')
local SkyGroup = Tabs.UISet:AddRightGroupbox('skybox')
local MenuGroup = Tabs.UISet:AddLeftGroupbox('menu')

HSGroup:AddToggle('HSEnable', {Text='enabled', Default=true, Callback=function(v) hitSoundEnabled=v end})
HSGroup:AddSlider('HSVolume', {
    Text = 'volume',
    Default = 1.0, Min = 0, Max = 2.0, Rounding = 1,
    Callback = function(v) hitSoundVolume = v end,
})
HSGroup:AddSlider('HSPitch', {
    Text = 'pitch',
    Default = 1.0, Min = 0.1, Max = 2.0, Rounding = 1,
    Callback = function(v) hitSoundPitch = v end,
})
HSGroup:AddDropdown('HSSelect', {
    Values = { 'rust hs', 'neverlose', 'sparkle', 'minecraft hit', 'bonk', 'osu', 'among us', 'bruh', 'vine', 'gamesense', '장충동 왕족발 보쌈' },
    Default = 1,
    Multi = false,
    Text = 'sound',
    Callback = function(v)
        selectedHitSound = v
        playHitSound()
    end,
})

SkyGroup:AddDropdown('SkyTheme', {
    Values = {
        'Disabled', 'Afternoon', 'Blue Space', 'Classic Roblox', 'Cloudy', 'Dusk', 'Dawn',
        'Dark Skies', 'Earth', 'Horizontal Milky Way', 'Heaven', 'Jungle', 'Mountains',
        'Nebula', 'Night Light', 'Night', 'Ocean Sky', 'Redshift', 'Space', 'Sunset',
        'Storm', 'SFOTH', 'Solid Black', 'Saturn', 'Smoke', 'Vertical Milky Way', 'White',
        'Dark Sky', 'Vaporwave', 'Lake Sky', 'Black Mesa'
    },
    Default = 1,
    Multi = false,
    Text = 'theme',
    Callback = function(v)
        if v == 'Disabled' then
            customSkyboxEnabled = false
            applySkybox()
        else
            setSkyboxTheme(v)
        end
    end,
})

MenuGroup:AddLabel('toggle menu: RightControl')
MenuGroup:AddButton('Unload', function()
    Library:Unload()
end)

Library:OnUnload(function()
    Library.Unloaded = true
end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
pcall(function()
    ThemeManager:SetTheme('Dark')
end)
-- Override theme colors to Lunara sky-blue after ThemeManager apply
pcall(function()
    local S = Library.Scheme or {}
    S.AccentColor = Color3.fromRGB(0, 180, 255)
    S.AccentColorDark = Color3.fromRGB(0, 130, 210)
    S.AccentColorLight = Color3.fromRGB(80, 210, 255)
    S.OutlineColor = Color3.fromRGB(0, 170, 255)
    S.BackgroundColor = Color3.fromRGB(8, 8, 10)
    S.MainColor = Color3.fromRGB(12, 12, 14)
    if Library.UpdateColors then Library.UpdateColors() end
end)
task.delay(0.3, function()
    pcall(function()
        local S = Library.Scheme or {}
        S.AccentColor = Color3.fromRGB(0, 180, 255)
        S.OutlineColor = Color3.fromRGB(0, 170, 255)
        if Library.UpdateColors then Library.UpdateColors() end
    end)
end)

ThemeManager:ApplyToTab(Tabs.UISet)
SaveManager:BuildConfigSection(Tabs.UISet)
pcall(function()
    SaveManager:LoadAutoloadConfig()
end)

print('[vallkmult] Linoria dark UI loaded — main/ragebot/esp/ffmode/misc/settings')
