-- 이파일은 Decompy 를 이용해서 난독화 해제가 돼었습니다 discord.gg/8FyqTtQsFu

local bit32Lib = bit32 or bit
local frameCounter = 0
local function everyNFrames(n)
    frameCounter = frameCounter + 1
    return (frameCounter % n) == 0
end
-- ═══════════════════════════════════════════════════
-- 안티킥 / 안티치트 우회
-- ═══════════════════════════════════════════════════
pcall(function()
    local Players = game:GetService("Players")
    local RS = game:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer
    local CoreGui = game:GetService("CoreGui")
    local StarterGui = game:GetService("StarterGui")
    local LogService = game:GetService("LogService")
    local ScriptContext = game:GetService("ScriptContext")
    local GuiService = game:GetService("GuiService")
    pcall(function()
        if LocalPlayer and typeof(LocalPlayer.Kick) == "function" then
            local oldKick = LocalPlayer.Kick
            LocalPlayer.Kick = function(...) end
        end
    end)
    pcall(function()
        if not hookmetamethod or not getnamecallmethod then
            return
        end
        local bannedRemoteNames = {
            kick = true,
            ban = true,
            punish = true,
            anticheat = true,
            detect = true,
            report = true,
            flag = true,
            crash = true,
            log = true,
            screenshot = true,
            security = true,
            mod = true,
            admin = true,
            watchdog = true,
            sentinel = true,
        }
        local function isSuspiciousName(name)
            if type(name) ~= "string" then
                return false
            end
            name = string.lower(name)
            for bannedName, _ in pairs(bannedRemoteNames) do
                if string.find(name, bannedName, 1, true) then
                    return true
                end
            end
            return false
        end
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure and newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" then
                return
            end
            return oldNamecall(self, ...)
        end) or function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" then
                return
            end
            return oldNamecall(self, ...)
        end)
    end)
    pcall(function()
        local function cloak(inst)
            if not inst then
                return
            end
            pcall(function()
                inst.Name = tostring(math.random(100000, 999999))
            end)
        end
        task.defer(function()
            task.wait(1)
            for _, guiName in ipairs({"HalmuESP", "HalmuFOV", "HalmuIndicators", "ExecutorToggleUI", "CustomCursorGui"}) do
                local existing = CoreGui:FindFirstChild(guiName)
                if existing then
                    cloak(existing)
                end
                if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
                    local existing = LocalPlayer.PlayerGui:FindFirstChild(guiName)
                    if existing then
                        cloak(existing)
                    end
                end
            end
        end)
    end)
    pcall(function()
        if ScriptContext and ScriptContext.Error then
            ScriptContext.Error:Connect(function() end)
        end
    end)
    pcall(function()
        if getconnections then
        end
    end)
    pcall(function()
        if setfflag then
            pcall(setfflag, "DebugRunServiceHumanoidCheck", "False")
        end
    end)
    pcall(function()
        local RunService = game:GetService("RunService")
        local lastRefresh = 0
        RunService.Heartbeat:Connect(function()
            if tick() - lastRefresh < 3 then
                return
            end
            lastRefresh = tick()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.SetNetworkOwner then
                pcall(function()
                    hrp:SetNetworkOwner(LocalPlayer)
                end)
            end
        end)
    end)
end)
local nexlib = {accentclr = Color3.fromRGB(128, 213, 247), dropdownframes = {}, colorpickerframes = {}}
local inputTypeNames = {
    [Enum.UserInputType.MouseButton1] = "M1",
    [Enum.UserInputType.MouseButton2] = "M2",
    [Enum.UserInputType.MouseButton3] = "M3",
}
local blockedKeys = {
    Enum.KeyCode.Unknown,
    Enum.KeyCode.W,
    Enum.KeyCode.A,
    Enum.KeyCode.S,
    Enum.KeyCode.D,
    Enum.KeyCode.Up,
    Enum.KeyCode.Left,
    Enum.KeyCode.Down,
    Enum.KeyCode.Right,
    Enum.KeyCode.Slash,
    Enum.KeyCode.Tab,
    Enum.KeyCode.Backspace,
    Enum.KeyCode.Escape,
    Enum.KeyCode.RightShift,
}
local function tableContains(tbl, value)
    for k, v in next, tbl do
        if v == value or k == value then
            return true
        end
    end
end
local function makeDraggable(clickObject, dragObject)
    pcall(function()
        local dragging = false
        local lastInput, startPos, startObjPos
        clickObject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                startPos = input.Position
                startObjPos = dragObject.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        clickObject.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                lastInput = input
            end
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input == lastInput and dragging then
                local delta = input.Position - startPos
                dragObject.Position = UDim2.new(startObjPos.X.Scale, startObjPos.X.Offset + delta.X, startObjPos.Y.Scale, startObjPos.Y.Offset + delta.Y)
            end
        end)
    end)
end
local mainScreenGui = Instance.new("ScreenGui")
mainScreenGui.Name = "nexlib"
setthreadidentity = setthreadidentity or function() end
setthreadidentity(8)
mainScreenGui.Parent = game:GetService("CoreGui")
mainScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local cursorGui = Instance.new("ScreenGui")
cursorGui.Name = "CustomCursorGui"
cursorGui.ResetOnSpawn = false
cursorGui.Parent = mainScreenGui
local cursorBox = Instance.new("Frame")
cursorBox.Name = "CursorBox"
cursorBox.Size = UDim2.new(0, 6, 0, 6)
cursorBox.BackgroundColor3 = Color3.fromRGB(128, 213, 247)
cursorBox.BorderSizePixel = 0
cursorBox.Visible = false
cursorBox.Parent = cursorGui
local notificationFolder = Instance.new("Folder")
notificationFolder.Name = "NotificationFolder"
notificationFolder.Parent = mainScreenGui
local notifications = {}
local NOTIF_HEIGHT = 22
local NOTIF_GAP = 6
local MAX_NOTIFS = 8
local DEFAULT_DURATION = 3
local NOTIF_START_Y = 40
local function refreshNotifications()
    local tweenService = game:GetService("TweenService")
    for i, notif in ipairs(notifications) do
        if notif.bar and notif.bar.Parent then
            local targetY = NOTIF_START_Y + (i - 1) * (NOTIF_HEIGHT + NOTIF_GAP)
            tweenService:Create(notif.bar, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, targetY)}):Play()
        end
    end
end
function nexlib.Notification(self, title, desc, duration)
    duration = duration or DEFAULT_DURATION
    local displayText = tostring(title or "")
    if desc and desc ~= "" then
        displayText = displayText .. "  ·  " .. tostring(desc)
    end
    local tweenService = game:GetService("TweenService")
    while #notifications >= MAX_NOTIFS do
        local removed = table.remove(notifications)
        if removed and removed.bar and removed.bar.Parent then
            local labelTween = tweenService:Create(removed.label, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
            local barTween = tweenService:Create(removed.bar, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, NOTIF_HEIGHT), BackgroundTransparency = 1})
            local strokeTween = tweenService:Create(removed.stroke, TweenInfo.new(0.2), {Transparency = 1})
            labelTween:Play()
            barTween:Play()
            strokeTween:Play()
            barTween.Completed:Connect(function()
                pcall(function()
                    if removed.bar then
                        removed.bar:Destroy()
                    end
                end)
                refreshNotifications()
            end)
        end
    end
    local frame = Instance.new("Frame")
    frame.Name = "Notification"
    frame.Parent = notificationFolder
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0.5, 0, 0, NOTIF_START_Y)
    frame.Size = UDim2.new(0, 0, 0, NOTIF_HEIGHT)
    frame.ClipsDescendants = true
    frame.BackgroundTransparency = 0.05
    frame.ZIndex = 100
    local stroke = Instance.new("UIStroke")
    stroke.Parent = frame
    stroke.Color = nexlib.accentclr
    stroke.Thickness = 1.5
    stroke.Transparency = 0.25
    local accentLine = Instance.new("Frame")
    accentLine.Name = "AccentLine"
    accentLine.Parent = frame
    accentLine.BackgroundColor3 = nexlib.accentclr
    accentLine.BorderSizePixel = 0
    accentLine.Size = UDim2.new(0, 3, 1, 0)
    accentLine.Position = UDim2.new(0, 0, 0, 0)
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(1, -28, 1, 0)
    label.Font = Enum.Font.Code
    label.Text = displayText
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextTransparency = 1
    label.TextTruncate = Enum.TextTruncate.None
    local textService = game:GetService("TextService")
    local textSize = textService:GetTextSize(displayText, 13, Enum.Font.Code, Vector2.new(2000, NOTIF_HEIGHT))
    local width = math.clamp(textSize.X + 48, 200, 480)
    table.insert(notifications, 1, {_356_632 = frame, _0xf0da = label, _3429x450 = stroke})
    refreshNotifications()
    local sizeTween = tweenService:Create(frame, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, width, 0, NOTIF_HEIGHT)})
    local textTween = tweenService:Create(label, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
    sizeTween:Play()
    task.delay(0.08, function()
        textTween:Play()
    end)
    task.delay(duration, function()
        for i, notif in ipairs(notifications) do
            if notif.bar == frame then
                table.remove(notifications, i)
                break
            end
        end
        if not frame or not frame.Parent then
            refreshNotifications()
            return
        end
        local labelTween = tweenService:Create(label, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        local barTween = tweenService:Create(frame, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, NOTIF_HEIGHT), BackgroundTransparency = 1})
        local strokeTween = tweenService:Create(stroke, TweenInfo.new(0.22), {Transparency = 1})
        labelTween:Play()
        barTween:Play()
        strokeTween:Play()
        barTween.Completed:Connect(function()
            pcall(function()
                frame:Destroy()
            end)
            refreshNotifications()
        end)
    end)
end
function nexlib.Window(self, windowTitle)
    local uiVisible = true
    local hasActiveTab = false
    local tabRegistry = {}
    local mainFrame = Instance.new("Frame")
    local outline1 = Instance.new("ImageLabel")
    local outline2 = Instance.new("ImageLabel")
    local containerHolder = Instance.new("Frame")
    local tabHolder = Instance.new("ScrollingFrame")
    local tabLayout = Instance.new("UIListLayout")
    local tabPadding = Instance.new("UIPadding")
    local topBar = Instance.new("Frame")
    local topBarTitle = Instance.new("TextLabel")
    local topBarLine = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = mainScreenGui
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.Size = UDim2.new(0, 525, 0, 631)
    mainFrame.Visible = true
    mainFrame.ClipsDescendants = true
    outline1.Name = "OutlineMainFrame1"
    outline1.Parent = mainFrame
    outline1.BackgroundTransparency = 1
    outline1.Position = UDim2.new(0, 1, 0, 1)
    outline1.Size = UDim2.new(1, -2, 1, -2)
    outline1.Image = "rbxassetid://2592362371"
    outline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
    outline1.ScaleType = Enum.ScaleType.Slice
    outline1.SliceCenter = Rect.new(2, 2, 62, 62)
    outline2.Name = "OutlineMainFrame2"
    outline2.Parent = mainFrame
    outline2.BackgroundTransparency = 1
    outline2.Size = UDim2.new(1, 0, 1, 0)
    outline2.Image = "rbxassetid://2592362371"
    outline2.ImageColor3 = Color3.fromRGB(0, 0, 0)
    outline2.ScaleType = Enum.ScaleType.Slice
    outline2.SliceCenter = Rect.new(2, 2, 62, 62)
    containerHolder.Name = "ContainerHolderFrame"
    containerHolder.Parent = mainFrame
    containerHolder.AnchorPoint = Vector2.new(0.5, 0)
    containerHolder.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    containerHolder.Position = UDim2.new(0.5, 0, 0.071, 10)
    containerHolder.Size = UDim2.new(1, -18, 1, -42)
    containerHolder.BackgroundTransparency = 1
    containerHolder.ClipsDescendants = true
    tabHolder.Name = "TabHolderFrame"
    tabHolder.Parent = containerHolder
    tabHolder.BackgroundTransparency = 1
    tabHolder.Size = UDim2.new(1, 0, 0, 32)
    tabHolder.Visible = true
    tabHolder.CanvasSize = UDim2.new(0, 700, 0, 0)
    tabHolder.ScrollBarThickness = 0
    tabLayout.Name = "TabHolderFrameLayout"
    tabLayout.Parent = tabHolder
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 4)
    tabPadding.Name = "TabHolderFramePadding"
    tabPadding.Parent = tabHolder
    tabPadding.PaddingLeft = UDim.new(0, 5)
    topBar.Name = "TopBar"
    topBar.Parent = mainFrame
    topBar.AnchorPoint = Vector2.new(0.5, 0)
    topBar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    topBar.BorderSizePixel = 0
    topBar.Position = UDim2.new(0.5, 0, 0, 2)
    topBar.Size = UDim2.new(1, -5, 0, 28)
    topBarTitle.Name = "TopBarTitle"
    topBarTitle.Parent = topBar
    topBarTitle.BackgroundTransparency = 1
    topBarTitle.Position = UDim2.new(0, 7, 0, 5)
    topBarTitle.Size = UDim2.new(0, 0, 0, 16)
    topBarTitle.Font = Enum.Font.Code
    topBarTitle.Text = windowTitle
    topBarTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
    topBarTitle.TextSize = 16
    topBarTitle.TextXAlignment = Enum.TextXAlignment.Left
    topBarLine.Name = "TopBarLine"
    topBarLine.Parent = topBar
    topBarLine.BackgroundColor3 = nexlib.accentclr
    topBarLine.BorderSizePixel = 0
    topBarLine.Position = UDim2.new(0, 0, 0, 27)
    topBarLine.Size = UDim2.new(1, 0, 0, 1)
    makeDraggable(topBar, mainFrame)
    local local shaderLighting = game:GetService("Lighting")
    local uiBlur = shaderLighting:FindFirstChild("ValkUIBlur") or Instance.new("BlurEffect")
    uiBlur.Name = "ValkUIBlur"
    uiBlur.Size = 0
    uiBlur.Parent = v56079
    local function applyVisibility()
        mainFrame.Visible = uiVisible
        cursorBox.Visible = uiVisible
        game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default
        local v53851 = game:GetService("TweenService")
        if uiVisible then
            v53851:Create(uiBlur, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 18}):Play()
            mainFrame.BackgroundTransparency = 1
            v53851:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.15}):Play()
        else
            v53851:Create(uiBlur, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0}):Play()
        end
    end
    game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        if input.KeyCode == Enum.KeyCode.RightShift then
            uiVisible = not uiVisible
            applyVisibility()
        end
    end)
    local a87b27c15 = game:GetService("CoreGui")
    if a87b27c15:FindFirstChild("ExecutorToggleUI") then
        a87b27c15.ExecutorToggleUI:Destroy()
    end
    local toggleGui = Instance.new("ScreenGui")
    toggleGui.Name = "ExecutorToggleUI"
    toggleGui.ResetOnSpawn = false
    toggleGui.Parent = a87b27c15
    local a81b35c84 = Instance.new("TextButton")
    a81b35c84.Name = "ToggleFrame"
    a81b35c84.Size = UDim2.new(0, 65, 0, 36)
    a81b35c84.Position = UDim2.new(0, 20, 0, 20)
    a81b35c84.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    a81b35c84.BorderSizePixel = 0
    a81b35c84.Active = true
    a81b35c84.Draggable = true
    a81b35c84.Parent = toggleGui
    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = nexlib.accentclr
    toggleStroke.Thickness = 2
    toggleStroke.Parent = a81b35c84
    local toggleLabel1 = Instance.new("TextLabel")
    toggleLabel1.Size = UDim2.new(1, -6, 0, 16)
    toggleLabel1.Position = UDim2.new(0, 3, 0, 2)
    toggleLabel1.BackgroundTransparency = 1
    toggleLabel1.Text = "Toggle"
    toggleLabel1.TextColor3 = Color3.fromRGB(230, 230, 230)
    toggleLabel1.TextSize = 12
    toggleLabel1.Font = Enum.Font.GothamBold
    toggleLabel1.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel1.Parent = a81b35c84
    local toggleLabel2 = Instance.new("TextLabel")
    toggleLabel2.Size = UDim2.new(1, -6, 0, 16)
    toggleLabel2.Position = UDim2.new(0, 3, 0, 18)
    toggleLabel2.BackgroundTransparency = 1
    toggleLabel2.Text = "Look"
    toggleLabel2.TextColor3 = Color3.fromRGB(230, 230, 230)
    toggleLabel2.TextSize = 12
    toggleLabel2.Font = Enum.Font.GothamBold
    toggleLabel2.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel2.Parent = a81b35c84
    a81b35c84.MouseButton1Click:Connect(function()
        uiVisible = not uiVisible
        applyVisibility()
    end)
    coroutine.wrap(function()
        while task.wait() do
            topBarLine.BackgroundColor3 = nexlib.accentclr
            toggleStroke.Color = nexlib.accentclr
            cursorBox.BackgroundColor3 = nexlib.accentclr
            if uiVisible then
                local mouseLocation = game:GetService("UserInputService"):GetMouseLocation()
                cursorBox.Position = UDim2.new(0, mouseLocation.X, 0, mouseLocation.Y)
            end
        end
    end)()
    local windowObj = {}
    function windowObj.Tab(self, tabName)
        local v87080 = 50
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName .. "_TabBtn"
        tabButton.Parent = tabHolder
        tabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        tabButton.BorderSizePixel = 0
        tabButton.Font = Enum.Font.Code
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        tabButton.TextSize = 14
        tabButton.AutoButtonColor = false
        local textService = game:GetService("TextService")
        local BzTmvdpMcGg = textService:GetTextSize(tabName, 14, Enum.Font.Code, Vector2.new(500, 500))
        tabButton.Size = UDim2.new(0, BzTmvdpMcGg.X + 28, 0, 26)
        local topLine = Instance.new("Frame")
        topLine.Name = "TopLine"
        topLine.Parent = tabButton
        topLine.BackgroundColor3 = nexlib.accentclr
        topLine.BorderSizePixel = 0
        topLine.Position = UDim2.new(0, 0, 0, 0)
        topLine.Size = UDim2.new(1, 0, 0, 2)
        topLine.Visible = false
        local v77745 = Instance.new("ImageLabel")
        v77745.Name = "Outline"
        v77745.Parent = tabButton
        v77745.BackgroundTransparency = 1
        v77745.Size = UDim2.new(1, 0, 1, 0)
        v77745.Image = "rbxassetid://2592362371"
        v77745.ImageColor3 = Color3.fromRGB(45, 45, 45)
        v77745.ScaleType = Enum.ScaleType.Slice
        v77745.SliceCenter = Rect.new(2, 2, 62, 62)
        local holder1 = Instance.new("ScrollingFrame")
        local pad1 = Instance.new("UIPadding")
        local layout1 = Instance.new("UIListLayout")
        local holder2 = Instance.new("ScrollingFrame")
        local a36b16c67 = Instance.new("UIPadding")
        local layout2 = Instance.new("UIListLayout")
        holder1.Name = tabName .. "_Holder1"
        holder1.Parent = containerHolder
        holder1.Active = true
        holder1.BackgroundTransparency = 1
        holder1.BorderSizePixel = 0
        holder1.Position = UDim2.new(0, 1, 0, 35)
        holder1.Size = UDim2.new(0, 245, 1, -40)
        holder1.Visible = false
        holder1.CanvasSize = UDim2.new(0, 0, 0, 0)
        holder1.ScrollBarThickness = 4
        holder1.ScrollingEnabled = true
        pad1.Parent = holder1
        pad1.PaddingTop = UDim.new(0, 5)
        layout1.Parent = holder1
        layout1.SortOrder = Enum.SortOrder.LayoutOrder
        layout1.Padding = UDim.new(0, 10)
        holder2.Name = tabName .. "_Holder2"
        holder2.Parent = containerHolder
        holder2.Active = true
        holder2.BackgroundTransparency = 1
        holder2.BorderSizePixel = 0
        holder2.Position = UDim2.new(0, 255, 0, 35)
        holder2.Size = UDim2.new(0, 245, 1, -40)
        holder2.Visible = false
        holder2.CanvasSize = UDim2.new(0, 0, 0, 0)
        holder2.ScrollBarThickness = 4
        holder2.ScrollingEnabled = true
        a36b16c67.Parent = holder2
        a36b16c67.PaddingTop = UDim.new(0, 5)
        layout2.Parent = holder2
        layout2.SortOrder = Enum.SortOrder.LayoutOrder
        layout2.Padding = UDim.new(0, 10)
        table.insert(tabRegistry, {
            btn = tabButton,
            topLine = topLine,
            outline = v77745,
            h1 = holder1,
            h2 = holder2,
        })
        if hasActiveTab == false then
            hasActiveTab = true
            holder1.Visible = true
            holder2.Visible = true
            tabButton.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
            tabButton.TextColor3 = Color3.fromRGB(230, 230, 230)
            topLine.Visible = true
            v77745.ImageColor3 = Color3.fromRGB(65, 65, 65)
        end
        tabButton.MouseButton1Click:Connect(function()
            local tweenService = game:GetService("TweenService")
            for YEzeEiWEWFAS, t in ipairs(tabRegistry) do
                if t.btn == tabButton then
                    tweenService:Create(t.btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(33, 33, 33), TextColor3 = Color3.fromRGB(230, 230, 230)}):Play()
                    t.topLine.Visible = true
                    t.outline.ImageColor3 = Color3.fromRGB(65, 65, 65)
                    t.h1.Visible = true
                    t.h2.Visible = true
                else
                    tweenService:Create(t.btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(22, 22, 22), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                    t.topLine.Visible = false
                    t.outline.ImageColor3 = Color3.fromRGB(45, 45, 45)
                    t.h1.Visible = false
                    t.h2.Visible = false
                end
            end
        end)
        coroutine.wrap(function()
            while task.wait() do
                if topLine.Visible then
                    topLine.BackgroundColor3 = nexlib.accentclr
                end
            end
        end)()
        local tabObj = {}
        function tabObj.Section(self, sectionName, forceSide)
            v87080 = v87080 - 1
            local parentFrame = nil
            if forceSide == 1 then
                parentFrame = holder1
            elseif forceSide == 2 then
                parentFrame = holder2
            else
                local count1 = 0
                local a89b99c60 = 0
                for s, f in next, holder1:GetChildren() do
                    if f.Name == "Section" or f.Name == "MultiSection" then
                        count1 = count1 + 1
                    end
                end
                for s, f in next, holder2:GetChildren() do
                    if f.Name == "Section" or f.Name == "MultiSection" then
                        a89b99c60 = a89b99c60 + 1
                    end
                end
                if count1 == 0 and a89b99c60 == 0 then
                    parentFrame = holder1
                elseif count1 == a89b99c60 then
                    parentFrame = holder1
                else
                    parentFrame = holder2
                end
            end
            local sectionFrame = Instance.new("Frame")
            local sectionOutline2 = Instance.new("ImageLabel")
            local sectionOutline1 = Instance.new("ImageLabel")
            local titleFrame = Instance.new("Frame")
            local titleLabel = Instance.new("TextLabel")
            local itemHolder = Instance.new("Frame")
            local itemLayout = Instance.new("UIListLayout")
            sectionFrame.Name = "Section"
            sectionFrame.Parent = parentFrame
            sectionFrame.AnchorPoint = Vector2.new(0.5, 0)
            sectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            sectionFrame.BorderSizePixel = 0
            sectionFrame.Size = UDim2.new(1, -2, 0, 24)
            sectionFrame.ZIndex = v87080
            sectionOutline2.Name = "SectionOutline2"
            sectionOutline2.Parent = sectionFrame
            sectionOutline2.BackgroundTransparency = 1
            sectionOutline2.Size = UDim2.new(1, 0, 1, 0)
            sectionOutline2.Image = "rbxassetid://2592362371"
            sectionOutline2.ImageColor3 = Color3.fromRGB(0, 0, 0)
            sectionOutline2.ScaleType = Enum.ScaleType.Slice
            sectionOutline2.SliceCenter = Rect.new(2, 2, 62, 62)
            sectionOutline1.Name = "SectionOutline1"
            sectionOutline1.Parent = sectionFrame
            sectionOutline1.BackgroundTransparency = 1
            sectionOutline1.Position = UDim2.new(0, 1, 0, 1)
            sectionOutline1.Size = UDim2.new(1, -2, 1, -2)
            sectionOutline1.Image = "rbxassetid://2592362371"
            sectionOutline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
            sectionOutline1.ScaleType = Enum.ScaleType.Slice
            sectionOutline1.SliceCenter = Rect.new(2, 2, 62, 62)
            titleFrame.Name = "SectionTitleFrame"
            titleFrame.Parent = sectionFrame
            titleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            titleFrame.BorderSizePixel = 0
            titleFrame.Position = UDim2.new(0, 10, 0, 0)
            titleLabel.Name = "SectionTitle"
            titleLabel.Parent = titleFrame
            titleLabel.BackgroundTransparency = 1
            titleLabel.Position = UDim2.new(0, 0, 0, -3)
            titleLabel.Size = UDim2.new(1, 0, 0, 7)
            titleLabel.Font = Enum.Font.Code
            titleLabel.Text = sectionName
            titleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
            titleLabel.TextSize = 14
            itemHolder.Name = "SectionItemHolderFrame"
            itemHolder.Parent = sectionFrame
            itemHolder.AnchorPoint = Vector2.new(0.5, 0)
            itemHolder.BackgroundTransparency = 1
            itemHolder.Position = UDim2.new(0.5, 0, 0, 15)
            itemHolder.Size = UDim2.new(1, -16, 0, 0)
            itemLayout.Parent = itemHolder
            itemLayout.SortOrder = Enum.SortOrder.LayoutOrder
            itemLayout.Padding = UDim.new(0, 5)
            titleFrame.Size = UDim2.new(0, titleLabel.TextBounds.X + 6, 0, 7)
            local function recalc()
                sectionFrame.Size = UDim2.new(1, -2, 0, itemLayout.AbsoluteContentSize.Y + 24)
                holder1.CanvasSize = UDim2.new(0, 0, 0, layout1.AbsoluteContentSize.Y + 20)
                holder2.CanvasSize = UDim2.new(0, 0, 0, layout2.AbsoluteContentSize.Y + 20)
            end
            local sectionApi = {}
            function sectionApi.Toggle(self, text, default, callback)
                local toggleButton = Instance.new("TextButton")
                local toggleOutline1 = Instance.new("ImageLabel")
                local toggleOutline2 = Instance.new("ImageLabel")
                local checkBox = Instance.new("Frame")
                local checkMark = Instance.new("Frame")
                local v41003 = Instance.new("TextLabel")
                toggleButton.Name = "Toggle"
                toggleButton.Parent = itemHolder
                toggleButton.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                toggleButton.BorderSizePixel = 0
                toggleButton.Size = UDim2.new(1, 0, 0, 22)
                toggleButton.AutoButtonColor = false
                toggleButton.Text = ""
                toggleOutline1.Parent = toggleButton
                toggleOutline1.BackgroundTransparency = 1
                toggleOutline1.Size = UDim2.new(1, 0, 1, 0)
                toggleOutline1.Image = "rbxassetid://2592362371"
                toggleOutline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
                toggleOutline1.ScaleType = Enum.ScaleType.Slice
                toggleOutline1.SliceCenter = Rect.new(2, 2, 62, 62)
                toggleOutline2.Parent = toggleButton
                toggleOutline2.BackgroundTransparency = 1
                toggleOutline2.Position = UDim2.new(0, 1, 0, 1)
                toggleOutline2.Size = UDim2.new(1, -2, 1, -2)
                toggleOutline2.Image = "rbxassetid://2592362371"
                toggleOutline2.ImageColor3 = Color3.fromRGB(0, 0, 0)
                toggleOutline2.ScaleType = Enum.ScaleType.Slice
                toggleOutline2.SliceCenter = Rect.new(2, 2, 62, 62)
                checkBox.Name = "Box"
                checkBox.Parent = toggleButton
                checkBox.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                checkBox.BorderSizePixel = 0
                checkBox.Position = UDim2.new(0, 6, 0.5, -6)
                checkBox.Size = UDim2.new(0, 12, 0, 12)
                checkMark.Name = "Check"
                checkMark.Parent = checkBox
                checkMark.BackgroundColor3 = nexlib.accentclr
                checkMark.BorderSizePixel = 0
                checkMark.Position = UDim2.new(0, 2, 0, 2)
                checkMark.Size = UDim2.new(0, 8, 0, 8)
                checkMark.Visible = default or false
                v41003.Parent = toggleButton
                v41003.BackgroundTransparency = 1
                v41003.Position = UDim2.new(0, 25, 0, 0)
                v41003.Size = UDim2.new(1, -25, 1, 0)
                v41003.Font = Enum.Font.Code
                v41003.Text = text
                v41003.TextColor3 = Color3.fromRGB(190, 190, 190)
                v41003.TextSize = 14
                v41003.TextXAlignment = Enum.TextXAlignment.Left
                local state = default or false
                toggleButton.MouseButton1Click:Connect(function()
                    state = not state
                    checkMark.Visible = state
                    pcall(callback, state)
                end)
                recalc()
                coroutine.wrap(function()
                    while task.wait() do
                        checkMark.BackgroundColor3 = nexlib.accentclr
                    end
                end)()
                local toggleApi = {}
                function toggleApi.Set(self, value)
                    state = value
                    checkMark.Visible = state
                    pcall(callback, state)
                end
                return toggleApi
            end
            function sectionApi.Button(self, text, callback)
                local button = Instance.new("TextButton")
                local buttonOutline1 = Instance.new("ImageLabel")
                local buttonOutline2 = Instance.new("ImageLabel")
                button.Name = "Button"
                button.Parent = itemHolder
                button.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                button.BorderColor3 = nexlib.accentclr
                button.BorderSizePixel = 0
                button.Size = UDim2.new(1, 0, 0, 20)
                button.AutoButtonColor = false
                button.Font = Enum.Font.Code
                button.TextColor3 = Color3.fromRGB(230, 230, 230)
                button.TextSize = 14
                button.Text = text
                buttonOutline1.Name = "ButtonOutline1"
                buttonOutline1.Parent = button
                buttonOutline1.BackgroundTransparency = 1
                buttonOutline1.Size = UDim2.new(1, 0, 1, 0)
                buttonOutline1.Image = "rbxassetid://2592362371"
                buttonOutline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
                buttonOutline1.ScaleType = Enum.ScaleType.Slice
                buttonOutline1.SliceCenter = Rect.new(2, 2, 62, 62)
                buttonOutline2.Name = "ButtonOutline2"
                buttonOutline2.Parent = button
                buttonOutline2.BackgroundTransparency = 1
                buttonOutline2.Position = UDim2.new(0, 1, 0, 1)
                buttonOutline2.Size = UDim2.new(1, -2, 1, -2)
                buttonOutline2.Image = "rbxassetid://2592362371"
                buttonOutline2.ImageColor3 = Color3.fromRGB(0, 0, 0)
                buttonOutline2.ScaleType = Enum.ScaleType.Slice
                buttonOutline2.SliceCenter = Rect.new(2, 2, 62, 62)
                button.MouseButton1Click:Connect(function()
                    pcall(callback)
                end)
                button.MouseEnter:Connect(function()
                    button.BorderSizePixel = 1
                end)
                button.MouseLeave:Connect(function()
                    button.BorderSizePixel = 0
                end)
                recalc()
                coroutine.wrap(function()
                    while task.wait() do
                        button.BorderColor3 = nexlib.accentclr
                    end
                end)()
            end
            function sectionApi.Slider(self, text, min, max, default, rounding, callback)
                local sliderBar = Instance.new("TextButton")
                local sliderFill = Instance.new("Frame")
                local sliderTitle = Instance.new("TextLabel")
                local sliderValue = Instance.new("TextLabel")
                sliderBar.Name = "SliderBar"
                sliderBar.Parent = itemHolder
                sliderBar.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                sliderBar.BorderSizePixel = 0
                sliderBar.Size = UDim2.new(1, 0, 0, 16)
                sliderBar.Text = ""
                sliderBar.AutoButtonColor = false
                local sliderOutline1 = Instance.new("ImageLabel")
                sliderOutline1.Parent = sliderBar
                sliderOutline1.BackgroundTransparency = 1
                sliderOutline1.Size = UDim2.new(1, 0, 1, 0)
                sliderOutline1.Image = "rbxassetid://2592362371"
                sliderOutline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
                sliderOutline1.ScaleType = Enum.ScaleType.Slice
                sliderOutline1.SliceCenter = Rect.new(2, 2, 62, 62)
                local sliderOutline2 = Instance.new("ImageLabel")
                sliderOutline2.Parent = sliderBar
                sliderOutline2.BackgroundTransparency = 1
                sliderOutline2.Position = UDim2.new(0, 1, 0, 1)
                sliderOutline2.Size = UDim2.new(1, -2, 1, -2)
                sliderOutline2.Image = "rbxassetid://2592362371"
                sliderOutline2.ImageColor3 = Color3.fromRGB(0, 0, 0)
                sliderOutline2.ScaleType = Enum.ScaleType.Slice
                sliderOutline2.SliceCenter = Rect.new(2, 2, 62, 62)
                sliderFill.Name = "SliderFill"
                sliderFill.Parent = sliderBar
                sliderFill.BackgroundColor3 = nexlib.accentclr
                sliderFill.BorderSizePixel = 0
                sliderFill.BackgroundTransparency = 0.55
                sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                sliderTitle.Name = "SliderTitle"
                sliderTitle.Parent = sliderBar
                sliderTitle.BackgroundTransparency = 1
                sliderTitle.Position = UDim2.new(0, 6, 0, 0)
                sliderTitle.Size = UDim2.new(0.7, 0, 1, 0)
                sliderTitle.Font = Enum.Font.Code
                sliderTitle.Text = text
                sliderTitle.TextColor3 = Color3.fromRGB(190, 190, 190)
                sliderTitle.TextSize = 13
                sliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                sliderTitle.ZIndex = 2
                sliderValue.Name = "SliderValue"
                sliderValue.Parent = sliderBar
                sliderValue.BackgroundTransparency = 1
                sliderValue.Position = UDim2.new(1, -75, 0, 0)
                sliderValue.Size = UDim2.new(0, 70, 1, 0)
                sliderValue.Font = Enum.Font.Code
                sliderValue.Text = tostring(default) .. "s"
                sliderValue.TextColor3 = Color3.fromRGB(240, 240, 240)
                sliderValue.TextSize = 13
                sliderValue.TextXAlignment = Enum.TextXAlignment.Right
                sliderValue.ZIndex = 5
                local dragging = false
                local function updateSlider(input)
                    local alpha = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                    local value = min + (max - min) * alpha
                    if rounding == 0 then
                        value = math.floor(value + 0.5)
                    else
                        value = tonumber(string.format("%." .. rounding .. "f", value))
                    end
                    sliderFill.Size = UDim2.new(alpha, 0, 1, 0)
                    sliderValue.Text = tostring(value) .. "s"
                    pcall(callback, value)
                end
                sliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        updateSlider(input)
                    end
                end)
                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(input)
                    end
                end)
                recalc()
                coroutine.wrap(function()
                    while task.wait() do
                        sliderFill.BackgroundColor3 = nexlib.accentclr
                    end
                end)()
            end
            function sectionApi.Input(self, text, default, placeholder, callback)
                local WpcgMLxB = Instance.new("Frame")
                local v26413 = Instance.new("TextLabel")
                local inputBox = Instance.new("TextBox")
                WpcgMLxB.Name = "Input"
                WpcgMLxB.Parent = itemHolder
                WpcgMLxB.BackgroundTransparency = 1
                WpcgMLxB.Size = UDim2.new(1, 0, 0, 38)
                v26413.Name = "InputTitle"
                v26413.Parent = WpcgMLxB
                v26413.BackgroundTransparency = 1
                v26413.Size = UDim2.new(1, 0, 0, 15)
                v26413.Font = Enum.Font.Code
                v26413.Text = text
                v26413.TextColor3 = Color3.fromRGB(190, 190, 190)
                v26413.TextSize = 14
                v26413.TextXAlignment = Enum.TextXAlignment.Left
                inputBox.Name = "InputBox"
                inputBox.Parent = WpcgMLxB
                inputBox.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                inputBox.BorderSizePixel = 0
                inputBox.Position = UDim2.new(0, 0, 0, 18)
                inputBox.Size = UDim2.new(1, 0, 0, 20)
                inputBox.Font = Enum.Font.Code
                inputBox.PlaceholderText = placeholder or ""
                inputBox.Text = default or ""
                inputBox.TextColor3 = Color3.fromRGB(230, 230, 230)
                inputBox.TextSize = 14
                inputBox.TextXAlignment = Enum.TextXAlignment.Left
                inputBox.FocusLost:Connect(function(enterPressed)
                    pcall(callback, inputBox.Text)
                end)
                recalc()
            end
            function sectionApi.Dropdown(self, text, list, default, callback)
                default = typeof(default) == "string" and default
                if default == "" then
                    default = nil
                end
                local dropdownContainer = Instance.new("Frame")
                local dropdownTitle = Instance.new("TextLabel")
                local dropdownButton = Instance.new("TextButton")
                local dropdownOutline1 = Instance.new("ImageLabel")
                local dropdownOutline2 = Instance.new("ImageLabel")
                local dropdownValueLabel = Instance.new("TextLabel")
                local dropdownArrow = Instance.new("ImageLabel")
                dropdownContainer.Name = "Dropdown"
                dropdownContainer.Parent = itemHolder
                dropdownContainer.BackgroundTransparency = 1
                dropdownContainer.Size = UDim2.new(1, 0, 0, 37)
                dropdownTitle.Name = "DropdownTitle"
                dropdownTitle.Parent = dropdownContainer
                dropdownTitle.BackgroundTransparency = 1
                dropdownTitle.Size = UDim2.new(0, 0, 0, 13)
                dropdownTitle.Font = Enum.Font.Code
                dropdownTitle.Text = text
                dropdownTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                dropdownTitle.TextSize = 14
                dropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
                dropdownButton.Name = "DropdownFrame"
                dropdownButton.Parent = dropdownContainer
                dropdownButton.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                dropdownButton.BorderSizePixel = 0
                dropdownButton.Position = UDim2.new(0, 0, 1, -20)
                dropdownButton.Size = UDim2.new(1, 0, 0, 20)
                dropdownButton.Text = ""
                dropdownButton.AutoButtonColor = false
                dropdownOutline1.Parent = dropdownButton
                dropdownOutline1.BackgroundTransparency = 1
                dropdownOutline1.Size = UDim2.new(1, 0, 1, 0)
                dropdownOutline1.Image = "rbxassetid://2592362371"
                dropdownOutline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
                dropdownOutline1.ScaleType = Enum.ScaleType.Slice
                dropdownOutline1.SliceCenter = Rect.new(2, 2, 62, 62)
                dropdownOutline2.Parent = dropdownButton
                dropdownOutline2.BackgroundTransparency = 1
                dropdownOutline2.Position = UDim2.new(0, 1, 0, 1)
                dropdownOutline2.Size = UDim2.new(1, -2, 1, -2)
                dropdownOutline2.Image = "rbxassetid://2592362371"
                dropdownOutline2.ImageColor3 = Color3.fromRGB(0, 0, 0)
                dropdownOutline2.ScaleType = Enum.ScaleType.Slice
                dropdownOutline2.SliceCenter = Rect.new(2, 2, 62, 62)
                dropdownValueLabel.Name = "DropdownText"
                dropdownValueLabel.Parent = dropdownButton
                dropdownValueLabel.BackgroundTransparency = 1
                dropdownValueLabel.Position = UDim2.new(0, 5, 0, 0)
                dropdownValueLabel.Size = UDim2.new(1, -5, 1, 0)
                dropdownValueLabel.Font = Enum.Font.Code
                dropdownValueLabel.Text = typeof(default) == "string" and default or "..."
                dropdownValueLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
                dropdownValueLabel.TextSize = 14
                dropdownValueLabel.TextXAlignment = Enum.TextXAlignment.Left
                dropdownArrow.Name = "DropdownArrow"
                dropdownArrow.Parent = dropdownButton
                dropdownArrow.AnchorPoint = Vector2.new(0, 0.5)
                dropdownArrow.BackgroundTransparency = 1
                dropdownArrow.Position = UDim2.new(1, -22, 0.5, 0)
                dropdownArrow.Size = UDim2.new(0, 20, 0, 20)
                dropdownArrow.Image = "http://www.roblox.com/asset/?id=6031091004"
                dropdownArrow.ImageColor3 = Color3.fromRGB(180, 180, 180)
                recalc()
                local dropdownHolderFrame = Instance.new("Frame")
                local ddHolderOutline1 = Instance.new("ImageLabel")
                local ddHolderOutline2 = Instance.new("ImageLabel")
                local dropdownScroll = Instance.new("ScrollingFrame")
                local dropdownLayout = Instance.new("UIListLayout")
                local dropdownPad = Instance.new("UIPadding")
                dropdownHolderFrame.Name = "DropdownHolderFrame"
                dropdownHolderFrame.Parent = sectionFrame
                dropdownHolderFrame.AnchorPoint = Vector2.new(0.5, 0)
                dropdownHolderFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                dropdownHolderFrame.BorderSizePixel = 0
                dropdownHolderFrame.Position = UDim2.new(0.5, 0, 0, itemLayout.AbsoluteContentSize.Y + 19)
                dropdownHolderFrame.Size = UDim2.new(1, -16, 0, 0)
                dropdownHolderFrame.Visible = false
                dropdownHolderFrame.ZIndex = 10
                ddHolderOutline1.Parent = dropdownHolderFrame
                ddHolderOutline1.BackgroundTransparency = 1
                ddHolderOutline1.Size = UDim2.new(1, 0, 1, 0)
                ddHolderOutline1.Image = "rbxassetid://2592362371"
                ddHolderOutline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
                ddHolderOutline1.ScaleType = Enum.ScaleType.Slice
                ddHolderOutline1.SliceCenter = Rect.new(2, 2, 62, 62)
                ddHolderOutline2.Parent = dropdownHolderFrame
                ddHolderOutline2.BackgroundTransparency = 1
                ddHolderOutline2.Position = UDim2.new(0, 1, 0, 1)
                ddHolderOutline2.Size = UDim2.new(1, -2, 1, -2)
                ddHolderOutline2.Image = "rbxassetid://2592362371"
                ddHolderOutline2.ImageColor3 = Color3.fromRGB(0, 0, 0)
                ddHolderOutline2.ScaleType = Enum.ScaleType.Slice
                ddHolderOutline2.SliceCenter = Rect.new(2, 2, 62, 62)
                dropdownScroll.Name = "DropdownHolder"
                dropdownScroll.Parent = dropdownHolderFrame
                dropdownScroll.Active = true
                dropdownScroll.BackgroundTransparency = 1
                dropdownScroll.BorderSizePixel = 0
                dropdownScroll.Size = UDim2.new(1, -4, 1, 0)
                dropdownScroll.ScrollBarThickness = 2
                dropdownScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
                dropdownLayout.Parent = dropdownScroll
                dropdownLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                dropdownLayout.Padding = UDim.new(0, 2)
                dropdownPad.Parent = dropdownScroll
                dropdownPad.PaddingTop = UDim.new(0, 6)
                table.insert(nexlib.dropdownframes, dropdownHolderFrame)
                table.insert(nexlib.dropdownframes, dropdownContainer)
                local dropdownApi = {}
                dropdownButton.MouseButton1Click:Connect(function()
                    if dropdownHolderFrame.Visible == false then
                        for s, f in next, nexlib.dropdownframes do
                            if f.Name == "DropdownHolderFrame" then
                                f.Visible = false
                            end
                        end
                        for s, f in next, nexlib.dropdownframes do
                            if f.Name == "Dropdown" then
                                f.DropdownFrame.DropdownArrow.Rotation = 0
                            end
                        end
                        dropdownArrow.Rotation = 180
                        dropdownHolderFrame.Visible = true
                    else
                        dropdownArrow.Rotation = 0
                        dropdownHolderFrame.Visible = false
                    end
                end)
                for s, f in next, list do
                    local itemButton = Instance.new("TextButton")
                    local itemLabel = Instance.new("TextLabel")
                    itemButton.Name = "Item"
                    itemButton.Parent = dropdownScroll
                    itemButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    itemButton.Size = UDim2.new(1, -12, 0, 20)
                    itemButton.AutoButtonColor = false
                    itemButton.Font = Enum.Font.Code
                    itemButton.Text = " " .. f
                    itemButton.TextColor3 = Color3.fromRGB(230, 230, 230)
                    itemButton.TextSize = 14
                    itemButton.TextXAlignment = Enum.TextXAlignment.Left
                    itemLabel.Name = "ItemText"
                    itemLabel.Parent = itemButton
                    itemLabel.BackgroundTransparency = 1
                    itemLabel.Position = UDim2.new(0, 7, 0, 0)
                    itemLabel.Size = UDim2.new(1, -7, 1, 0)
                    itemLabel.Font = Enum.Font.Code
                    itemLabel.Text = f
                    itemLabel.TextColor3 = nexlib.accentclr
                    itemLabel.TextSize = 14
                    itemLabel.TextXAlignment = Enum.TextXAlignment.Left
                    itemButton.MouseButton1Click:Connect(function()
                        dropdownHolderFrame.Visible = false
                        dropdownValueLabel.Text = f
                        default = f
                        pcall(callback, f)
                    end)
                    coroutine.wrap(function()
                        while task.wait() do
                            local selected = (typeof(default) == "string" and default == f)
                            itemLabel.BackgroundTransparency = 1
                            itemLabel.TextTransparency = selected and 0 or 1
                            itemButton.TextTransparency = selected and 1 or 0
                            itemButton.BackgroundTransparency = selected and 0 or 1
                            itemButton.BorderColor3 = nexlib.accentclr
                        end
                    end)()
                    dropdownHolderFrame.Size = UDim2.new(1, -16, 0, math.clamp(dropdownLayout.AbsoluteContentSize.Y + 12, 0, 150))
                    dropdownScroll.CanvasSize = UDim2.new(0, 0, 0, dropdownLayout.AbsoluteContentSize.Y + 12)
                end
                coroutine.wrap(function()
                    while task.wait() do
                        dropdownButton.BorderColor3 = nexlib.accentclr
                    end
                end)()
                function dropdownApi.Set(self, value)
                    dropdownValueLabel.Text = tostring(value)
                    default = value
                    pcall(callback, value)
                end
                return dropdownApi
            end
            function sectionApi.Label(self, text)
                local labelApi = {}
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Parent = itemHolder
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 0, 18)
                label.Font = Enum.Font.Code
                label.Text = text
                label.TextColor3 = Color3.fromRGB(230, 230, 230)
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                recalc()
                function labelApi.Change(self, newText)
                    label.Text = newText
                end
                return labelApi
            end
            return sectionApi
        end
        function tabObj.MultiSection(self, tabNames, forceSide)
            v87080 = v87080 - 1
            local parentFrame = nil
            if forceSide == 1 then
                parentFrame = holder1
            elseif forceSide == 2 then
                parentFrame = holder2
            else
                local count1, a89b99c60 = 0, 0
                for YEzeEiWEWFAS, f in next, holder1:GetChildren() do
                    if f.Name == "Section" or f.Name == "MultiSection" then
                        count1 = count1 + 1
                    end
                end
                for YEzeEiWEWFAS, f in next, holder2:GetChildren() do
                    if f.Name == "Section" or f.Name == "MultiSection" then
                        a89b99c60 = a89b99c60 + 1
                    end
                end
                if count1 <= a89b99c60 then
                    parentFrame = holder1
                else
                    parentFrame = holder2
                end
            end
            local multiSection = Instance.new("Frame")
            multiSection.Name = "MultiSection"
            multiSection.Parent = parentFrame
            multiSection.AnchorPoint = Vector2.new(0.5, 0)
            multiSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            multiSection.BorderSizePixel = 0
            multiSection.Size = UDim2.new(1, -2, 0, 50)
            multiSection.ZIndex = v87080
            local msOutline2 = Instance.new("ImageLabel")
            msOutline2.Parent = multiSection
            msOutline2.BackgroundTransparency = 1
            msOutline2.Size = UDim2.new(1, 0, 1, 0)
            msOutline2.Image = "rbxassetid://2592362371"
            msOutline2.ImageColor3 = Color3.fromRGB(0, 0, 0)
            msOutline2.ScaleType = Enum.ScaleType.Slice
            msOutline2.SliceCenter = Rect.new(2, 2, 62, 62)
            local msOutline1 = Instance.new("ImageLabel")
            msOutline1.Parent = multiSection
            msOutline1.BackgroundTransparency = 1
            msOutline1.Position = UDim2.new(0, 1, 0, 1)
            msOutline1.Size = UDim2.new(1, -2, 1, -2)
            msOutline1.Image = "rbxassetid://2592362371"
            msOutline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
            msOutline1.ScaleType = Enum.ScaleType.Slice
            msOutline1.SliceCenter = Rect.new(2, 2, 62, 62)
            local tabRow = Instance.new("Frame")
            tabRow.Parent = multiSection
            tabRow.BackgroundTransparency = 1
            tabRow.Position = UDim2.new(0, 6, 0, 4)
            tabRow.Size = UDim2.new(1, -12, 0, 22)
            local tabRowLayout = Instance.new("UIListLayout")
            tabRowLayout.Parent = tabRow
            tabRowLayout.FillDirection = Enum.FillDirection.Horizontal
            tabRowLayout.SortOrder = Enum.SortOrder.LayoutOrder
            tabRowLayout.Padding = UDim.new(0, 2)
            local pageHolder = Instance.new("Frame")
            pageHolder.Parent = multiSection
            pageHolder.BackgroundTransparency = 1
            pageHolder.Position = UDim2.new(0.5, 0, 0, 28)
            pageHolder.AnchorPoint = Vector2.new(0.5, 0)
            pageHolder.Size = UDim2.new(1, -16, 0, 0)
            local pages, tabButtons = {}, {}
            local result = {}
            local function recalcMulti()
                local maxHeight = 0
                for YEzeEiWEWFAS, page in ipairs(pages) do
                    local layout = page:FindFirstChildOfClass("UIListLayout")
                    if layout then
                        maxHeight = math.max(maxHeight, layout.AbsoluteContentSize.Y)
                    end
                end
                pageHolder.Size = UDim2.new(1, -16, 0, maxHeight)
                multiSection.Size = UDim2.new(1, -2, 0, maxHeight + 36)
                holder1.CanvasSize = UDim2.new(0, 0, 0, layout1.AbsoluteContentSize.Y + 20)
                holder2.CanvasSize = UDim2.new(0, 0, 0, layout2.AbsoluteContentSize.Y + 20)
            end
            for i, tabName in ipairs(tabNames) do
                local page = Instance.new("Frame")
                page.Name = "Page_" .. tabName
                page.Parent = pageHolder
                page.BackgroundTransparency = 1
                page.Size = UDim2.new(1, 0, 0, 0)
                page.Visible = (i == 1)
                local pageLayout = Instance.new("UIListLayout")
                pageLayout.Parent = page
                pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
                pageLayout.Padding = UDim.new(0, 5)
                pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    page.Size = UDim2.new(1, 0, 0, pageLayout.AbsoluteContentSize.Y)
                    recalcMulti()
                end)
                local tabBtn = Instance.new("TextButton")
                tabBtn.Parent = tabRow
                tabBtn.BackgroundColor3 = (i == 1) and Color3.fromRGB(38, 38, 38) or Color3.fromRGB(28, 28, 28)
                tabBtn.BorderSizePixel = 0
                tabBtn.Size = UDim2.new(0, 0, 1, 0)
                tabBtn.AutomaticSize = Enum.AutomaticSize.X
                tabBtn.AutoButtonColor = false
                tabBtn.Font = Enum.Font.Code
                tabBtn.Text = "  " .. tabName .. "  "
                tabBtn.TextColor3 = (i == 1) and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(150, 150, 150)
                tabBtn.TextSize = 13
                local underline = Instance.new("Frame")
                underline.Parent = tabBtn
                underline.BackgroundColor3 = nexlib.accentclr
                underline.BorderSizePixel = 0
                underline.Position = UDim2.new(0, 0, 1, -2)
                underline.Size = UDim2.new(1, 0, 0, 2)
                underline.Visible = (i == 1)
                table.insert(pages, page)
                table.insert(tabButtons, {_154_244 = tabBtn, underline = underline, page = page})
                tabBtn.MouseButton1Click:Connect(function()
                    for idx, a91b73c94 in ipairs(tabButtons) do
                        local isSelected = (idx == i)
                        a91b73c94.page.Visible = isSelected
                        a91b73c94.underline.Visible = isSelected
                        a91b73c94.btn.BackgroundColor3 = isSelected and Color3.fromRGB(38, 38, 38) or Color3.fromRGB(28, 28, 28)
                        a91b73c94.btn.TextColor3 = isSelected and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(150, 150, 150)
                    end
                    recalcMulti()
                end)
                coroutine.wrap(function()
                    while task.wait() do
                        if underline.Visible then
                            underline.BackgroundColor3 = nexlib.accentclr
                        end
                    end
                end)()
                local function recalcPage()
                    page.Size = UDim2.new(1, 0, 0, pageLayout.AbsoluteContentSize.Y)
                    recalcMulti()
                end
                local pageApi = {}
                function pageApi.Toggle(self, text, default, callback)
                    local toggleButton = Instance.new("TextButton")
                    toggleButton.Name = "Toggle"
                    toggleButton.Parent = page
                    toggleButton.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                    toggleButton.BorderSizePixel = 0
                    toggleButton.Size = UDim2.new(1, 0, 0, 22)
                    toggleButton.AutoButtonColor = false
                    toggleButton.Text = ""
                    local toggleOutline1 = Instance.new("ImageLabel")
                    toggleOutline1.Parent = toggleButton
                    toggleOutline1.BackgroundTransparency = 1
                    toggleOutline1.Size = UDim2.new(1, 0, 1, 0)
                    toggleOutline1.Image = "rbxassetid://2592362371"
                    toggleOutline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
                    toggleOutline1.ScaleType = Enum.ScaleType.Slice
                    toggleOutline1.SliceCenter = Rect.new(2, 2, 62, 62)
                    local toggleOutline2 = Instance.new("ImageLabel")
                    toggleOutline2.Parent = toggleButton
                    toggleOutline2.BackgroundTransparency = 1
                    toggleOutline2.Position = UDim2.new(0, 1, 0, 1)
                    toggleOutline2.Size = UDim2.new(1, -2, 1, -2)
                    toggleOutline2.Image = "rbxassetid://2592362371"
                    toggleOutline2.ImageColor3 = Color3.fromRGB(0, 0, 0)
                    toggleOutline2.ScaleType = Enum.ScaleType.Slice
                    toggleOutline2.SliceCenter = Rect.new(2, 2, 62, 62)
                    local checkBox = Instance.new("Frame")
                    checkBox.Parent = toggleButton
                    checkBox.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                    checkBox.BorderSizePixel = 0
                    checkBox.Position = UDim2.new(0, 6, 0.5, -6)
                    checkBox.Size = UDim2.new(0, 12, 0, 12)
                    local checkMark = Instance.new("Frame")
                    checkMark.Parent = checkBox
                    checkMark.BackgroundColor3 = nexlib.accentclr
                    checkMark.BorderSizePixel = 0
                    checkMark.Position = UDim2.new(0, 2, 0, 2)
                    checkMark.Size = UDim2.new(0, 8, 0, 8)
                    checkMark.Visible = default or false
                    local v41003 = Instance.new("TextLabel")
                    v41003.Parent = toggleButton
                    v41003.BackgroundTransparency = 1
                    v41003.Position = UDim2.new(0, 25, 0, 0)
                    v41003.Size = UDim2.new(1, -25, 1, 0)
                    v41003.Font = Enum.Font.Code
                    v41003.Text = text
                    v41003.TextColor3 = Color3.fromRGB(190, 190, 190)
                    v41003.TextSize = 14
                    v41003.TextXAlignment = Enum.TextXAlignment.Left
                    local state = default or false
                    toggleButton.MouseButton1Click:Connect(function()
                        state = not state
                        checkMark.Visible = state
                        pcall(callback, state)
                    end)
                    recalcPage()
                    coroutine.wrap(function()
                        while task.wait() do
                            checkMark.BackgroundColor3 = nexlib.accentclr
                        end
                    end)()
                    local toggleApi = {}
                    function toggleApi.Set(self, value)
                        state = value
                        checkMark.Visible = state
                        pcall(callback, state)
                    end
                    return toggleApi
                end
                function pageApi.Slider(self, text, min, max, default, rounding, callback)
                    local sliderBar = Instance.new("TextButton")
                    sliderBar.Name = "SliderBar"
                    sliderBar.Parent = page
                    sliderBar.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                    sliderBar.BorderSizePixel = 0
                    sliderBar.Size = UDim2.new(1, 0, 0, 16)
                    sliderBar.Text = ""
                    sliderBar.AutoButtonColor = false
                    local sliderOutline1 = Instance.new("ImageLabel")
                    sliderOutline1.Parent = sliderBar
                    sliderOutline1.BackgroundTransparency = 1
                    sliderOutline1.Size = UDim2.new(1, 0, 1, 0)
                    sliderOutline1.Image = "rbxassetid://2592362371"
                    sliderOutline1.ImageColor3 = Color3.fromRGB(60, 60, 60)
                    sliderOutline1.ScaleType = Enum.ScaleType.Slice
                    sliderOutline1.SliceCenter = Rect.new(2, 2, 62, 62)
                    local sliderOutline2 = Instance.new("ImageLabel")
                    sliderOutline2.Parent = sliderBar
                    sliderOutline2.BackgroundTransparency = 1
                    sliderOutline2.Position = UDim2.new(0, 1, 0, 1)
                    sliderOutline2.Size = UDim2.new(1, -2, 1, -2)
                    sliderOutline2.Image = "rbxassetid://2592362371"
                    sliderOutline2.ImageColor3 = Color3.fromRGB(0, 0, 0)
                    sliderOutline2.ScaleType = Enum.ScaleType.Slice
                    sliderOutline2.SliceCenter = Rect.new(2, 2, 62, 62)
                    local sliderFill = Instance.new("Frame")
                    sliderFill.Parent = sliderBar
                    sliderFill.BackgroundColor3 = nexlib.accentclr
                    sliderFill.BorderSizePixel = 0
                    sliderFill.BackgroundTransparency = 0.55
                    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                    local sliderTitle = Instance.new("TextLabel")
                    sliderTitle.Parent = sliderBar
                    sliderTitle.BackgroundTransparency = 1
                    sliderTitle.Position = UDim2.new(0, 6, 0, 0)
                    sliderTitle.Size = UDim2.new(0.7, 0, 1, 0)
                    sliderTitle.Font = Enum.Font.Code
                    sliderTitle.Text = text
                    sliderTitle.TextColor3 = Color3.fromRGB(190, 190, 190)
                    sliderTitle.TextSize = 13
                    sliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                    sliderTitle.ZIndex = 2
                    local sliderValue = Instance.new("TextLabel")
                    sliderValue.Parent = sliderBar
                    sliderValue.BackgroundTransparency = 1
                    sliderValue.Position = UDim2.new(1, -75, 0, 0)
                    sliderValue.Size = UDim2.new(0, 70, 1, 0)
                    sliderValue.Font = Enum.Font.Code
                    sliderValue.Text = tostring(default) .. "s"
                    sliderValue.TextColor3 = Color3.fromRGB(240, 240, 240)
                    sliderValue.TextSize = 13
                    sliderValue.TextXAlignment = Enum.TextXAlignment.Right
                    sliderValue.ZIndex = 5
                    local dragging = false
                    local function updateSlider(input)
                        local alpha = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                        local value = min + (max - min) * alpha
                        if rounding == 0 then
                            value = math.floor(value + 0.5)
                        else
                            value = tonumber(string.format("%." .. rounding .. "f", value))
                        end
                        sliderFill.Size = UDim2.new(alpha, 0, 1, 0)
                        sliderValue.Text = tostring(value) .. "s"
                        pcall(callback, value)
                    end
                    sliderBar.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = true
                            updateSlider(input)
                        end
                    end)
                    game:GetService("UserInputService").InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = false
                        end
                    end)
                    game:GetService("UserInputService").InputChanged:Connect(function(input)
                        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            updateSlider(input)
                        end
                    end)
                    recalcPage()
                    coroutine.wrap(function()
                        while task.wait() do
                            sliderFill.BackgroundColor3 = nexlib.accentclr
                        end
                    end)()
                end
                function pageApi.Label(self, text)
                    local labelApi = {}
                    local label = Instance.new("TextLabel")
                    label.Parent = page
                    label.BackgroundTransparency = 1
                    label.Size = UDim2.new(1, 0, 0, 18)
                    label.Font = Enum.Font.Code
                    label.Text = text
                    label.TextColor3 = Color3.fromRGB(230, 230, 230)
                    label.TextSize = 14
                    label.TextXAlignment = Enum.TextXAlignment.Left
                    recalcPage()
                    function labelApi.Change(self, newText)
                        label.Text = newText
                    end
                    return labelApi
                end
                result[tabName] = pageApi
            end
            task.defer(recalcMulti)
            return result
        end
        return tabObj
    end
    function windowObj.Destroy(self)
        if shaderLighting:FindFirstChild("ValkUIBlur") then
            shaderLighting.ValkUIBlur:Destroy()
        end
        mainScreenGui:Destroy()
    end
    local function updateTargeting()
        local v53851 = game:GetService("TweenService")
        local local shaderLighting = game:GetService("Lighting")
        task.wait(0.7)
        local startTime = tick()
        while tick() - startTime < 3 do
            task.wait()
        end
        local v10331 = tick()
        while tick() - v10331 < 2 do
            local YEzeEiWEWFAS = 0
            for i = 1, 500000 do
                YEzeEiWEWFAS = YEzeEiWEWFAS + i
            end
            task.wait()
        end
        local introBlur = shaderLighting:FindFirstChild("ValkUIBlur") or Instance.new("BlurEffect")
        introBlur.Name = "ValkUIBlur"
        introBlur.Size = 0
        introBlur.Parent = v56079
        local a73b89c71 = Instance.new("TextLabel")
        a73b89c71.Name = "IntroLEVK"
        a73b89c71.Parent = mainScreenGui
        a73b89c71.AnchorPoint = Vector2.new(0.5, 0.5)
        a73b89c71.Position = UDim2.new(0.5, 0, 0.5, 0)
        a73b89c71.Size = UDim2.new(0, 400, 0, 100)
        a73b89c71.BackgroundTransparency = 1
        a73b89c71.Font = Enum.Font.Code
        a73b89c71.Text = "LEVK"
        a73b89c71.TextColor3 = nexlib.accentclr
        a73b89c71.TextSize = 80
        a73b89c71.TextTransparency = 1
        local fadeIn = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local fadeOut = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        v53851:Create(introBlur, fadeIn, {Size = 24}):Play()
        v53851:Create(a73b89c71, fadeIn, {TextTransparency = 0}):Play()
        task.wait(2.2)
        local a23b36c50 = v53851:Create(introBlur, fadeOut, {Size = 18})
        local labelTween = v53851:Create(a73b89c71, fadeOut, {TextTransparency = 1})
        a23b36c50:Play()
        labelTween:Play()
        a23b36c50.Completed:Connect(function()
            a73b89c71:Destroy()
            uiVisible = true
            applyVisibility()
        end)
    end
    task.spawn(updateTargeting)
    return windowObj
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local teamCheckEnabled = true
local function isTeammate(player)
    if not teamCheckEnabled then
        return false
    end
    local myTeam = LocalPlayer:GetAttribute("TeamID")
    local theirTeam = player:GetAttribute("TeamID")
    if myTeam == nil or theirTeam == nil then
        return false
    end
    return theirTeam == myTeam
end
local function isImmune(playerOrChar)
    local char = playerOrChar
    if typeof(playerOrChar) == "Instance" and playerOrChar:IsA("Player") then
        char = playerOrChar.Character
    end
    if not char then
        return true
    end
    if char:FindFirstChildOfClass("ForceField") then
        return true
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and hrp:FindFirstChild("Attachment") then
        return true
    end
    local immuneAttr = char:GetAttribute("Immune") or char:GetAttribute("Invincible") or char:GetAttribute("IsImmune")
    if immuneAttr == true then
        return true
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local hImmune = hum:GetAttribute("Immune") or hum:GetAttribute("Invincible")
        if hImmune == true then
            return true
        end
    end
    return false
end
local function isReflecting(player)
    local char = player and player.Character
    if not char then
        return false
    end
    local reflectAttrs = {"Reflecting", "IsReflecting", "BulletReflect", "Reflect", "Deflecting", "Parrying"}
    for YEzeEiWEWFAS, a in ipairs(reflectAttrs) do
        local v = char:GetAttribute(a)
        if v == true or v == 1 or v == "true" then
            return true
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local hv = hum:GetAttribute(a)
            if hv == true or hv == 1 then
                return true
            end
        end
    end
    local hasKatana = false
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and string.find(string.lower(tool.Name), "katana", 1, true) then
        hasKatana = true
    end
    for YEzeEiWEWFAS, ch in ipairs(char:GetChildren()) do
        local chName = string.lower(ch.Name)
        if string.find(chName, "katana", 1, true) then
            hasKatana = true
        end
        if string.find(chName, "reflect", 1, true) or string.find(chName, "deflect", 1, true) then
            return true
        end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local ok, tracks = pcall(function()
            return hum:GetPlayingAnimationTracks()
        end)
        if ok and tracks then
            for YEzeEiWEWFAS, track in ipairs(tracks) do
                local trackName = string.lower(tostring(track.Name or ""))
                local animId = ""
                pcall(function()
                    if track.Animation then
                        animId = tostring(track.Animation.AnimationId or "")
                    end
                end)
                local combined = trackName .. " " .. string.lower(animId)
                if string.find(combined, "reflect", 1, true) or string.find(combined, "deflect", 1, true) or string.find(combined, "parry", 1, true) or string.find(combined, "block", 1, true) then
                    if hasKatana or string.find(combined, "katana", 1, true) then
                        return true
                    end
                    if string.find(combined, "reflect", 1, true) or string.find(combined, "deflect", 1, true) then
                        return true
                    end
                end
            end
        end
    end
    return false
end
local attackAllowed = true
local killAuraEnabled = false
local flyOrbitEnabled = false
local flyOrbitRadius = 50000000
local heightLockEnabled = false
local lockHeight = 50
local baitingEnabled = false
local voidSpamEnabled = false
local voidSpamHideTime = 0.25
local voidSpamAttackTime = 0.1
task.spawn(function()
    while true do
        if voidSpamEnabled and ragebotActive then
            attackAllowed = true
            local attackDelay = voidSpamAttackTime
            if typeof(attackDelay) ~= "number" or attackDelay < 0.01 then
                attackDelay = 0.01
            end
            task.wait(attackDelay)
            if voidSpamEnabled and ragebotActive then
                attackAllowed = false
                local hideDelay = voidSpamHideTime
                if typeof(hideDelay) ~= "number" or hideDelay < 0.01 then
                    hideDelay = 0.01
                end
                task.wait(hideDelay)
            else
                attackAllowed = true
            end
        else
            attackAllowed = true
            task.wait(0.05)
        end
    end
end)
local aimbotEnabled = false
local aimbotSmoothness = 5
local aimbotFovRadius = 100
local aimbotHitPart = "head"
local showAimbotFov = false
local aimbotWallCheck = false
local aimbotRequireRMB = false
local silentAimEnabled = false
local silentAimHitPart = "head"
local silentAimFovRadius = 300
local showSilentAimFov = false
local silentWallCheck = false
local silentAimTarget = nil
local triggerbotEnabled = false
local noSpread = false
local a49b29c66 = false
local a77b85c82 = false
local v50691 = false
local v34672 = false
local a72b52c65 = false
local a77b58c11 = false
local shaderEnabled = false
local indicatorRagebot = false
local indicatorAmmo = false
espEnabled = false
espBoxEnabled = true
espNameEnabled = true
espHealthEnabled = true
espWeaponEnabled = true
local autoGrabHealth = true
local autoGrabAmmo = true
local v18003 = false
local a54b51c88 = false
local pcFly = false
local mobileFlySpeed = 50
local pcFlySpeed = 50
local noclipEnabled = false
local a93b76c35 = "all walls"
local a13b53c88 = false
local emoteHopEnabled = false
local emoteSpeed = 40
local JBrJMqdvA = nil
local emoteAnimation = nil
local skyboxEnabled = false
local a16b37c97 = ""
local a67b95c93 = false
local deviceChoice = "vr"
local skyboxPresets = {
    ["Dark Sky"] = {
        SkyboxUp = "rbxassetid://570555929",
        SkyboxRt = "rbxassetid://570555882",
        SkyboxDn = "rbxassetid://570555964",
        SkyboxFt = "rbxassetid://570555800",
        SkyboxLf = "rbxassetid://570555840",
        SkyboxBk = "rbxassetid://570555736",
    },
    Vaporwave = {
        SkyboxUp = "rbxassetid://1417494643",
        SkyboxRt = "rbxassetid://1417494499",
        SkyboxLf = "rbxassetid://1417494402",
        SkyboxFt = "rbxassetid://1417494253",
        SkyboxBk = "rbxassetid://1417494030",
        SkyboxDn = "rbxassetid://1417494146",
    },
    ["Lake Sky"] = {
        SkyboxRt = "rbxassetid://6823531746",
        SkyboxUp = "rbxassetid://6823528533",
        SunTextureId = "rbxassetid://5392574622",
        SkyboxDn = "rbxassetid://6823525702",
        SkyboxFt = "rbxassetid://6823482923",
        SkyboxLf = "rbxassetid://6823530023",
        SkyboxBk = "rbxassetid://6823523318",
    },
    ["Black Mesa"] = {
        SkyboxUp = "rbxassetid://9569598752",
        SkyboxRt = "rbxassetid://9569601267",
        SkyboxDn = "rbxassetid://9569613307",
        SkyboxFt = "rbxassetid://9569611418",
        SkyboxLf = "rbxassetid://9569608166",
        SkyboxBk = "rbxassetid://9569742122",
    },
}
local function getRootPart(choice)
    local local shaderLighting = game:GetService("Lighting")
    local sky = shaderLighting:FindFirstChild("CustomSkybox")
    if not skyboxEnabled or not choice or choice == "" then
        if sky then
            sky:Destroy()
        end
        return
    end
    local a91b73c94 = skyboxPresets[choice]
    if a91b73c94 then
        if not sky then
            sky = Instance.new("Sky")
            sky.Name = "CustomSkybox"
            sky.Parent = v56079
        end
        sky.SkyboxUp = ""
        sky.SkyboxRt = ""
        sky.SkyboxDn = ""
        sky.SkyboxFt = ""
        sky.SkyboxLf = ""
        sky.SkyboxBk = ""
        sky.SunTextureId = ""
        for prop, val in pairs(a91b73c94) do
            sky[prop] = val
        end
    end
end
local fullbrightEnabled = false
local tmp1 = ""
local tmp2 = ""
local hWzhWiHR = false
local vel1 = Vector3.zero
local a69b36c91 = Vector3.new(0, 2, 0)
local a39b72c33 = nil
local currentTargetPart = nil
local function getCharacterRoot(char)
    if not char then
        return nil
    end
    return char:FindFirstChild("HitboxHead") or char:FindFirstChild("HitboxHeadSmall") or char:FindFirstChild("Head")
end
local ragebotConnection
local ragebotToggleHandler = function(on) end
local ragebotActive = false
local lhiRNgvZ = 3
task.spawn(function()
    local ok, v69764 = xpcall(function()
        local playerScripts = LocalPlayer.PlayerScripts
        local a66b43c59, fighterController = pcall(require, playerScripts.Controllers.FighterController)
        local enumOk, v27885 = pcall(require, ReplicatedStorage.Modules.EnumLibrary)
        local MAwXiJM = ReplicatedStorage.Remotes.Replication.Fighter.UseItem
        local startShootingEnum
        pcall(function()
            startShootingEnum = v27885:ToEnum("StartShooting")
        end)
        local function getEquippedObjectId()
            if not (a66b43c59 and fighterController) then
                return nil
            end
            local localFighter = fighterController.LocalFighter
            if not localFighter then
                return nil
            end
            local equippedItem = localFighter.EquippedItem
            if not equippedItem then
                return nil
            end
            local ok, val = pcall(function()
                return equippedItem:Get("ObjectID")
            end)
            if ok and val then
                return val
            end
            ok, val = pcall(function()
                return equippedItem.Data and equippedItem.Data.ObjectID
            end)
            return ok and val or nil
        end
        local function teleportCharacter(originPos, targetPart)
            local targetPos = targetPart.Position
            local lookCFrame = CFrame.lookAt(originPos, targetPos)
            local rx, ry, rz = lookCFrame:ToOrientation()
            local a49b75c71 = {
                [utf8.char(0)] = originPos.X,
                [utf8.char(1)] = originPos.Y,
                [utf8.char(2)] = originPos.Z,
                [utf8.char(3)] = rx,
                [utf8.char(4)] = ry,
                [utf8.char(5)] = rz,
            }
            local a12b15c22 = targetPart.CFrame:ToObjectSpace(CFrame.new(targetPos))
            local ox, oy, CtOClXPOnz = a12b15c22:ToOrientation()
            return {
                [utf8.char(1)] = {
                    [utf8.char(0)] = a49b75c71,
                    [utf8.char(1)] = a49b75c71,
                    [utf8.char(2)] = targetPart,
                    [utf8.char(3)] = {
                        [utf8.char(0)] = a12b15c22.X,
                        [utf8.char(1)] = a12b15c22.Y,
                        [utf8.char(2)] = a12b15c22.Z,
                        [utf8.char(3)] = ox,
                        [utf8.char(4)] = oy,
                        [utf8.char(5)] = CtOClXPOnz,
                    },
                },
            }
        end
        ragebotToggleHandler = function(on)
            if ragebotConnection then
                ragebotConnection:Disconnect()
                ragebotConnection = nil
            end
            if not on then
                return
            end
            local cachedId = nil
            ragebotConnection = RunService.Heartbeat:Connect(function()
                if not ragebotActive or not attackAllowed then
                    return
                end
                if not currentTargetPart or not currentTargetPart.Parent then
                    return
                end
                local a20b32c46 = currentTargetPart:FindFirstAncestorOfClass("Model") or currentTargetPart.Parent
                local a14b42c70 = Players:GetPlayerFromCharacter(a20b32c46)
                if not a14b42c70 or a14b42c70 == LocalPlayer then
                    return
                end
                if isTeammate(a14b42c70) then
                    return
                end
                if isImmune(a14b42c70) then
                    return
                end
                if isReflecting(a14b42c70) then
                    return
                end
                local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not myHrp then
                    return
                end
                local objectId = getEquippedObjectId()
                if objectId then
                    cachedId = objectId
                else
                    objectId = cachedId
                end
                if not objectId then
                    return
                end
                local targetPart = currentTargetPart
                local originPos = targetPart.Position + Vector3.new(0, 0.1, 0)
                local v84604 = teleportCharacter(originPos, targetPart)
                pcall(function()
                    MAwXiJM:FireServer(objectId, startShootingEnum, v84604, nil)
                end)
            end)
        end
    end, function(v69764) end)
end)
local savedCFrame = nil
local savedVelocity = nil
local function findClosestTarget()
    local v83548 = true
    pcall(function()
        local playerScripts = LocalPlayer.PlayerScripts
        local ok, fighterController = pcall(require, playerScripts.Controllers.FighterController)
        if not ok or not fighterController or not fighterController.LocalFighter then
            return
        end
        local equippedItem = fighterController.LocalFighter.EquippedItem
        if not equippedItem then
            v83548 = false
            return
        end
        local function getProperty(key)
            local ok, value = pcall(function()
                if equippedItem.Get then
                    return equippedItem:Get(key)
                end
                return equippedItem[key] or (equippedItem.Data and equippedItem.Data[key]) or (equippedItem.Info and equippedItem.Info[key])
            end)
            if ok then
                return value
            end
            return nil
        end
        local v43335 = getProperty("CurrentAmmo") or getProperty("Ammo") or getProperty("Bullets") or getProperty("MagazineAmmo")
        local reloading = getProperty("Reloading") or getProperty("IsReloading")
        if equippedItem.Info and type(equippedItem.Info) == "table" then
            if v43335 == nil then
                v43335 = equippedItem.Info.CurrentAmmo or equippedItem.Info.Ammo
            end
            if equippedItem.Info.Reloading == true or equippedItem.Info.IsReloading == true then
                reloading = true
            end
        end
        if reloading == true then
            v83548 = false
            return
        end
        if typeof(v43335) == "number" and v43335 <= 0 then
            v83548 = false
            return
        end
    end)
    return v83548
end
local function v26061()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not savedCFrame then
        return
    end
    hrp.CFrame = savedCFrame
    if savedVelocity then
        hrp.AssemblyLinearVelocity = savedVelocity
    end
    savedCFrame = nil
    savedVelocity = nil
end
pcall(function()
    RunService:UnbindFromRenderStep("RestoreDesyncPerfect")
end)
pcall(function()
    RunService:BindToRenderStep("RestoreDesyncPerfect", 0, v26061)
end)
RunService.RenderStepped:Connect(v26061)
RunService.Heartbeat:Connect(function()
    pcall(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            return
        end
        if savedCFrame then
            v26061()
        end
        if ragebotActive and attackAllowed and currentTargetPart and findClosestTarget() then
            local targetModel = currentTargetPart:FindFirstAncestorOfClass("Model") or currentTargetPart.Parent
            local targetPlayer = Players:GetPlayerFromCharacter(targetModel)
            if targetPlayer and isReflecting(targetPlayer) then
                return
            end
            savedCFrame = hrp.CFrame
            savedVelocity = hrp.AssemblyLinearVelocity
            local targetPos = currentTargetPart.Position
            local destPos = targetPos + Vector3.new(0, lhiRNgvZ, 0)
            hrp.CFrame = CFrame.new(destPos, targetPos)
            return
        end
        if flyOrbitEnabled then
            if not a39b72c33 then
                a39b72c33 = hrp.Position
            end
            savedCFrame = hrp.CFrame
            savedVelocity = hrp.AssemblyLinearVelocity
            local randomDir = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)).Unit
            local destPos = a39b72c33 + randomDir * flyOrbitRadius
            local rot = savedCFrame - savedCFrame.Position
            hrp.CFrame = CFrame.new(destPos) * rot
        end
    end)
end)
task.spawn(function()
    while true do
        task.wait(0.01)
        if ragebotActive and attackAllowed then
            local xxEEAQiVz = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.zero
            local bestPlayer = nil
            local UHvhQn = math.huge
            for YEzeEiWEWFAS, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and not isTeammate(player) then
                    if isImmune(player) then
                        continue
                    end
                    if isReflecting(player) then
                        continue
                    end
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    local hum = player.Character:FindFirstChild("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local flatDist = (Vector3.new(xxEEAQiVz.X, 0, xxEEAQiVz.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude
                        if flatDist < UHvhQn then
                            UHvhQn = flatDist
                            bestPlayer = player
                        end
                    end
                end
            end
            if bestPlayer and bestPlayer.Character then
                currentTargetPart = getCharacterRoot(bestPlayer.Character)
            else
                currentTargetPart = nil
            end
        else
            currentTargetPart = nil
        end
    end
end)
local baitingConnection = nil
local function setToggleState(on)
    if baitingConnection then
        baitingConnection:Disconnect()
        baitingConnection = nil
    end
    if not on then
        return
    end
    task.spawn(function()
        local ok, v69764 = xpcall(function()
            local playerScripts = LocalPlayer.PlayerScripts
            local a66b43c59, fighterController = pcall(require, playerScripts.Controllers.FighterController)
            local enumOk, v27885 = pcall(require, ReplicatedStorage.Modules.EnumLibrary)
            local MAwXiJM = ReplicatedStorage.Remotes.Replication.Fighter.UseItem
            local startShootingEnum
            pcall(function()
                startShootingEnum = v27885:ToEnum("StartShooting")
            end)
            local function getEquippedObjectId()
                if not (a66b43c59 and fighterController) then
                    return nil
                end
                local localFighter = fighterController.LocalFighter
                if not localFighter then
                    return nil
                end
                local equippedItem = localFighter.EquippedItem
                if not equippedItem then
                    return nil
                end
                local ok, val = pcall(function()
                    return equippedItem:Get("ObjectID")
                end)
                if ok and val then
                    return val
                end
                ok, val = pcall(function()
                    return equippedItem.Data and equippedItem.Data.ObjectID
                end)
                return ok and val or nil
            end
            local function teleportCharacter(originPos, targetPart)
                local targetPos = targetPart.Position
                local lookCFrame = CFrame.lookAt(originPos, targetPos)
                local rx, ry, rz = lookCFrame:ToOrientation()
                local a49b75c71 = {
                    [utf8.char(0)] = originPos.X,
                    [utf8.char(1)] = originPos.Y,
                    [utf8.char(2)] = originPos.Z,
                    [utf8.char(3)] = rx,
                    [utf8.char(4)] = ry,
                    [utf8.char(5)] = rz,
                }
                local a12b15c22 = targetPart.CFrame:ToObjectSpace(CFrame.new(targetPos))
                local ox, oy, CtOClXPOnz = a12b15c22:ToOrientation()
                return {
                    [utf8.char(1)] = {
                        [utf8.char(0)] = a49b75c71,
                        [utf8.char(1)] = a49b75c71,
                        [utf8.char(2)] = targetPart,
                        [utf8.char(3)] = {
                            [utf8.char(0)] = a12b15c22.X,
                            [utf8.char(1)] = a12b15c22.Y,
                            [utf8.char(2)] = a12b15c22.Z,
                            [utf8.char(3)] = ox,
                            [utf8.char(4)] = oy,
                            [utf8.char(5)] = CtOClXPOnz,
                        },
                    },
                }
            end
            local cachedId = nil
            baitingConnection = RunService.Heartbeat:Connect(function()
                if not baitingEnabled or not attackAllowed then
                    return
                end
                local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not myHrp then
                    return
                end
                local objectId = getEquippedObjectId()
                if objectId then
                    cachedId = objectId
                else
                    objectId = cachedId
                end
                if not objectId then
                    return
                end
                for YEzeEiWEWFAS, playersRef in ipairs(Players:GetPlayers()) do
                    if playersRef == LocalPlayer then
                        continue
                    end
                    if isTeammate(playersRef) then
                        continue
                    end
                    if isImmune(playersRef) then
                        continue
                    end
                    local char = playersRef.Character
                    if not char then
                        continue
                    end
                    local hum = char:FindFirstChildWhichIsA("Humanoid")
                    if not hum or hum.Health <= 0 then
                        continue
                    end
                    local targetPart = char:FindFirstChild("Head")
                    if not targetPart then
                        continue
                    end
                    local originPos = targetPart.Position - Vector3.new(0, 5, 0)
                    local v84604 = teleportCharacter(originPos, targetPart)
                    pcall(function()
                        MAwXiJM:FireServer(objectId, startShootingEnum, v84604, nil)
                    end)
                end
            end)
        end, function(v69764) end)
    end)
end
local playerScripts = LocalPlayer.PlayerScripts
local Controllers = playerScripts:WaitForChild("Controllers", 10)
local enumLib = require(ReplicatedStorage.Modules:WaitForChild("EnumLibrary", 10))
if enumLib then
    enumLib:WaitForEnumBuilder()
end
local cosmeticLib = require(ReplicatedStorage.Modules:WaitForChild("CosmeticLibrary", 10))
local a17b70c23 = require(ReplicatedStorage.Modules:WaitForChild("ItemLibrary", 10))
local playerDataController = require(Controllers:WaitForChild("PlayerDataController", 10))
local equippedCosmetics, favoriteCosmetics = {}, {}
local currentEquipWeapon, currentViewPlayer = nil, nil
local _unused = nil
local function getTargetPlayer(cosmeticName, slot, v18000)
    local base = cosmeticLib.Cosmetics[cosmeticName]
    if not base then
        return nil
    end
    local a91b73c94 = {}
    for key, value in pairs(base) do
        a91b73c94[key] = value
    end
    a91b73c94.Name = cosmeticName
    a91b73c94.Type = a91b73c94.Type or slot
    a91b73c94.Seed = a91b73c94.Seed or math.random(1, 1000000)
    if enumLib then
        local a37b43c30, enumVal = pcall(enumLib.ToEnum, enumLib, cosmeticName)
        if a37b43c30 and enumVal then
            a91b73c94.Enum, a91b73c94.ObjectID = enumVal, a91b73c94.ObjectID or enumVal
        end
    end
    if v18000 then
        if v18000.inverted ~= nil then
            a91b73c94.Inverted = v18000.inverted
        end
        if v18000.favoritesOnly ~= nil then
            a91b73c94.OnlyUseFavorites = v18000.favoritesOnly
        end
    end
    return a91b73c94
end
local CONFIG_PATH = "unlockall/config.json"
local function setFov()
    if not writefile then
        return
    end
    pcall(function()
        local out = {equippedCosmetics = {}, _0x8a53 = favoriteCosmetics}
        for weaponId, v43828 in pairs(equippedCosmetics) do
            out.equipped[weaponId] = {}
            for slot, cosmeticData in pairs(v43828) do
                if cosmeticData and cosmeticData.Name then
                    out.equipped[weaponId][slot] = {
                        _00IO01 = cosmeticData.Name,
                        seed = cosmeticData.Seed,
                        inverted = cosmeticData.Inverted,
                    }
                end
            end
        end
        makefolder("unlockall")
        writefile(CONFIG_PATH, HttpService:JSONEncode(out))
    end)
end
local function loadCosmeticConfig()
    if not readfile or not isfile or not isfile(CONFIG_PATH) then
        return
    end
    pcall(function()
        local data = HttpService:JSONDecode(readfile(CONFIG_PATH))
        if data.equipped then
            for weaponId, v43828 in pairs(data.equipped) do
                equippedCosmetics[weaponId] = {}
                for slot, cosmeticData in pairs(v43828) do
                    local data = getTargetPlayer(cosmeticData.name, slot, {inverted = cosmeticData.inverted})
                    if data then
                        data.Seed = cosmeticData.seed
                        equippedCosmetics[weaponId][slot] = data
                    end
                end
            end
        end
        favoriteCosmetics = data.favorites or {}
    end)
end
local cosmeticUnlockEnabled = false
local origOwnsCosmetic = cosmeticLib.OwnsCosmetic
cosmeticLib.OwnsCosmetic = function(self, userId, cosmeticName, weaponId)
    if not cosmeticUnlockEnabled then
        return origOwnsCosmetic(self, userId, cosmeticName, weaponId)
    end
    if cosmeticName:find("MISSING_") then
        return origOwnsCosmetic(self, userId, cosmeticName, weaponId)
    end
    local c = cosmeticLib.Cosmetics[cosmeticName]
    if c then
        local cType = c.Type
        if cType == "Skin" or cType == "Charm" or cType == "Dance" or cType == "Emote" or cType == "Wrap" or cType == "Wrapping" or cosmeticName:lower():find("charm") or cosmeticName:lower():find("dance") or cosmeticName:lower():find("emote") or cosmeticName:lower():find("wrap") then
            return true
        end
    end
    return origOwnsCosmetic(self, userId, cosmeticName, weaponId)
end
cosmeticLib.OwnsCosmeticNormally = function(self, userId, cosmeticName, weaponId)
    if not cosmeticUnlockEnabled then
        return false
    end
    local c = cosmeticLib.Cosmetics[cosmeticName]
    if c and c.Type == "Skin" then
        return true
    end
    return false
end
cosmeticLib.OwnsCosmeticUniversally = function(self, userId, cosmeticName, weaponId)
    if not cosmeticUnlockEnabled then
        return false
    end
    local c = cosmeticLib.Cosmetics[cosmeticName]
    if c and c.Type == "Skin" then
        return true
    end
    return false
end
cosmeticLib.OwnsCosmeticForWeapon = function(self, userId, cosmeticName, weaponId)
    if not cosmeticUnlockEnabled then
        return false
    end
    local c = cosmeticLib.Cosmetics[cosmeticName]
    if c and c.Type == "Skin" then
        return true
    end
    return false
end
local origGet = playerDataController.Get
playerDataController.Get = function(self, key)
    local a91b73c94 = origGet(self, key)
    if not cosmeticUnlockEnabled then
        return a91b73c94
    end
    if key == "CosmeticInventory" then
        local filtered = {}
        if a91b73c94 then
            for k, v in pairs(a91b73c94) do
                local c = cosmeticLib.Cosmetics[k]
                if c then
                    filtered[k] = v
                end
            end
        end
        return setmetatable(filtered, {
            _5087x733 = function(t, k)
                local c = cosmeticLib.Cosmetics[k]
                if c then
                    return true
                end
                return nil
            end,
        })
    end
    if key == "FavoritedCosmetics" then
        local clone = a91b73c94 and table.clone(a91b73c94) or {}
        for weaponId, favs in pairs(favoriteCosmetics) do
            clone[weaponId] = clone[weaponId] or {}
            for cosmeticName, v in pairs(favs) do
                clone[weaponId][cosmeticName] = v
            end
        end
        return clone
    end
    return a91b73c94
end
local origGetWeaponData = playerDataController.GetWeaponData
playerDataController.GetWeaponData = function(self, weaponName)
    local a91b73c94 = origGetWeaponData(self, weaponName)
    if not a91b73c94 then
        return nil
    end
    local out = {}
    for key, value in pairs(a91b73c94) do
        out[key] = value
    end
    out.Name = weaponName
    if equippedCosmetics[weaponName] then
        for slot, cosmeticData in pairs(equippedCosmetics[weaponName]) do
            out[slot] = cosmeticData
        end
    end
    return out
end
local fighterControllerCached
pcall(function()
    fighterControllerCached = require(Controllers:WaitForChild("FighterController", 10))
end)
local clientItemModule
pcall(function()
    clientItemModule = require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem)
end)
if clientItemModule and clientItemModule._CreateViewModel then
    local origCreateViewModel = clientItemModule._CreateViewModel
    clientItemModule._CreateViewModel = function(self, viewmodelRef)
        local weaponName = self.Name
        local ownerPlayer = self.ClientFighter and self.ClientFighter.Player
        currentEquipWeapon = (ownerPlayer == LocalPlayer) and weaponName or nil
        if ownerPlayer == LocalPlayer and equippedCosmetics[weaponName] and viewmodelRef then
            local dataKey = self:ToEnum("Data")
            local dataTbl = viewmodelRef[dataKey] or viewmodelRef.Data
            if dataTbl then
                if equippedCosmetics[weaponName].Skin then
                    dataTbl[self:ToEnum("Skin") or "Skin"] = equippedCosmetics[weaponName].Skin
                    dataTbl[self:ToEnum("Name") or "Name"] = equippedCosmetics[weaponName].Skin.Name
                end
                if equippedCosmetics[weaponName].Charm then
                    dataTbl[self:ToEnum("Charm") or "Charm"] = equippedCosmetics[weaponName].Charm
                end
                if equippedCosmetics[weaponName].Wrap then
                    dataTbl[self:ToEnum("Wrap") or "Wrap"] = equippedCosmetics[weaponName].Wrap
                end
            end
        end
        local vm = origCreateViewModel(self, viewmodelRef)
        currentEquipWeapon = nil
        return vm
    end
end
local clientVMFolder = LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
if clientVMFolder then
    local vmModule = require(clientVMFolder)
    if vmModule.GetCharm then
        local origGetCharm = vmModule.GetCharm
        vmModule.GetCharm = function(self)
            local weaponName = self.ClientItem and self.ClientItem.Name
            local ownerPlayer = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
            if weaponName and ownerPlayer == LocalPlayer and equippedCosmetics[weaponName] and equippedCosmetics[weaponName].Charm then
                return equippedCosmetics[weaponName].Charm
            end
            return origGetCharm(self)
        end
    end
    if vmModule.GetWrap then
        local origGetWrap = vmModule.GetWrap
        vmModule.GetWrap = function(self)
            local weaponName = self.ClientItem and self.ClientItem.Name
            local ownerPlayer = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
            if weaponName and ownerPlayer == LocalPlayer and equippedCosmetics[weaponName] and equippedCosmetics[weaponName].Wrap then
                return equippedCosmetics[weaponName].Wrap
            end
            return origGetWrap(self)
        end
    end
    local origNew = vmModule.new
    vmModule.new = function(replicatedData, clientItem)
        local ownerPlayer = clientItem.ClientFighter and clientItem.ClientFighter.Player
        local weaponName = currentEquipWeapon or clientItem.Name
        if ownerPlayer == LocalPlayer and equippedCosmetics[weaponName] then
            local a90b57c50 = require(ReplicatedStorage.Modules.ReplicatedClass)
            local dataKey = a90b57c50:ToEnum("Data")
            replicatedData[dataKey] = replicatedData[dataKey] or {}
            local v43828 = equippedCosmetics[weaponName]
            if v43828.Skin then
                replicatedData[dataKey][a90b57c50:ToEnum("Skin")] = v43828.Skin
            end
            if v43828.Charm then
                replicatedData[dataKey][a90b57c50:ToEnum("Charm")] = v43828.Charm
            end
            if v43828.Wrap then
                replicatedData[dataKey][a90b57c50:ToEnum("Wrap")] = v43828.Wrap
            end
        end
        local vm = origNew(replicatedData, clientItem)
        if ownerPlayer == LocalPlayer and equippedCosmetics[weaponName] and equippedCosmetics[weaponName].Wrap and vm._UpdateWrap then
            vm:_UpdateWrap()
            task.delay(0.1, function()
                if not vm._destroyed then
                    vm:_UpdateWrap()
                end
            end)
        end
        return vm
    end
end
a17b70c23.GetViewModelImageFromWeaponData = function(self, weaponData, highRes)
    if not weaponData then
        return nil
    end
    local weaponName = weaponData.Name
    local isMine = (weaponData.Skin and equippedCosmetics[weaponName] and weaponData.Skin == equippedCosmetics[weaponName].Skin) or (currentViewPlayer == LocalPlayer and equippedCosmetics[weaponName] and equippedCosmetics[weaponName].Skin)
    if isMine and equippedCosmetics[weaponName] and equippedCosmetics[weaponName].Skin then
        local vmData = self.ViewModels[equippedCosmetics[weaponName].Skin.Name]
        if vmData then
            return vmData[highRes and "ImageHighResolution" or "Image"] or vmData.Image
        end
    end
    return nil
end
local emoteController
pcall(function()
    emoteController = require(Controllers:WaitForChild("EmoteController", 10))
    if emoteController and emoteController.GetEmotes then
        local origGetEmotes = emoteController.GetEmotes
        emoteController.GetEmotes = function(self)
            local list = origGetEmotes(self)
            for name, c in pairs(cosmeticLib.Cosmetics) do
                if c and (c.Type == "Dance" or c.Type == "Emote" or name:lower():find("dance") or name:lower():find("emote")) then
                    if not list[name] then
                        list[name] = {
                            Name = name,
                            Type = c.Type,
                            ObjectID = c.ObjectID,
                            Enum = c.Enum,
                        }
                    end
                end
            end
            return list
        end
    end
end)
pcall(function()
    local viewProfile = require(LocalPlayer.PlayerScripts.Modules.Pages.ViewProfile)
    if viewProfile and viewProfile.Fetch then
        local origFetch = viewProfile.Fetch
        viewProfile.Fetch = function(self, targetPlayer)
            currentViewPlayer = targetPlayer
            return origFetch(self, targetPlayer)
        end
    end
end)
loadCosmeticConfig()
local window = nexlib:Window("할무발크 free")
local tabs = {
    Combat = window:Tab("Combat"),
    Visuals = window:Tab("Visuals"),
    Misc = window:Tab("Misc"),
    ["UI Settings"] = window:Tab("UI Settings"),
}
local secSilentAim = tabs["Combat"]:Section("silent aim", 2)
local secAimbot = tabs["Combat"]:Section("aimbot", 1)
secSilentAim:Toggle("enabled", false, function(value)
    silentAimEnabled = value
end)
secSilentAim:Dropdown("hitbox", {"head", "humanoidrootpart", "torso"}, "head", function(value)
    silentAimHitPart = value
end)
secSilentAim:Slider("fov radius", 10, 500, 300, 0, function(value)
    silentAimFovRadius = value
end)
secSilentAim:Toggle("draw fov", false, function(value)
    showSilentAimFov = value
end)
secSilentAim:Toggle("wallcheck", false, function(value)
    silentWallCheck = value
end)
secAimbot:Toggle("aimbot enabled", false, function(value)
    aimbotEnabled = value
end)
secAimbot:Dropdown("hitbox", {"head", "humanoidrootpart", "torso"}, "head", function(value)
    aimbotHitPart = value
end)
secAimbot:Slider("smoothness", 1, 20, 5, 1, function(value)
    aimbotSmoothness = value
end)
secAimbot:Slider("fov radius", 10, 500, 100, 0, function(value)
    aimbotFovRadius = value
end)
secAimbot:Toggle("draw fov", false, function(value)
    showAimbotFov = value
end)
secAimbot:Toggle("wallcheck", false, function(value)
    aimbotWallCheck = value
end)
secAimbot:Toggle("scope look", false, function(value)
    aimbotRequireRMB = value
end)
local secMobile = tabs["Combat"]:Section("mobile setting", 1)
secMobile:Toggle("mobile on", false, function(value)
    local mainFrame = mainScreenGui:FindFirstChild("MainFrame", true)
    if mainFrame then
        mainFrame.ClipsDescendants = true
        local containerHolder = mainFrame:FindFirstChild("ContainerHolderFrame")
        if containerHolder then
            containerHolder.ClipsDescendants = true
            containerHolder.Size = UDim2.new(1, -18, 1, -42)
        end
        local v53851 = game:GetService("TweenService")
        local newSize = value and UDim2.new(0, 525, 0, 300) or UDim2.new(0, 525, 0, 631)
        v53851:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = newSize}):Play()
    end
end)
local secPull = tabs["Combat"]:Section("pull enabled", 1)
secPull:Toggle("pull", false, function(value)
    killAuraEnabled = value
end)
local secRage = tabs["Combat"]:Section("ragebot", 1)
secRage:Toggle("enabled", false, function(value)
    ragebotActive = value
    pcall(function()
        ragebotToggleHandler(value)
    end)
end)
secRage:Toggle("orbit", false, function(value)
    flyOrbitEnabled = value
    if value then
        flyOrbitRadius = 5003
    end
end)
secRage:Toggle("voidspam", false, function(value)
    voidSpamEnabled = value
    if not value then
        attackAllowed = true
    end
end)
secRage:Slider("hide", 0.01, 1, 0.25, 2, function(value)
    voidSpamHideTime = value
end)
secRage:Slider("attack", 0.01, 1, 0.1, 2, function(value)
    voidSpamAttackTime = value
end)
local secFfa = tabs["Combat"]:Section("ffamods", 2)
secFfa:Toggle("team check", true, function(value)
    teamCheckEnabled = value
end)
secFfa:Toggle("baiting", false, function(value)
    baitingEnabled = value
    heightLockEnabled = value
    pcall(function()
        setToggleState(value)
    end)
end)
local secTrigger = tabs["Combat"]:Section("triggerbot", 2)
secTrigger:Toggle("enabled", false, function(value)
    triggerbotEnabled = value
end)
local secWeapons = tabs["Combat"]:Section("weapons", 2)
secWeapons:Toggle("no spread", false, function(value)
    noSpread = value
end)
secWeapons:Toggle("no muzzle flash", false, function(value)
    a49b29c66 = value
end)
secWeapons:Toggle("attack cooldown", false, function(value)
    a77b85c82 = value
    if not value then
        pcall(function()
            restoreGCAttribute("ShootCooldown")
        end)
        v50691 = false
    end
end)
secWeapons:Toggle("projectile cooldown", false, function(value)
    v34672 = value
    if value then
        pcall(enableInstantReload)
    else
        pcall(restoreReload)
    end
end)
local secOrbVoid = tabs["Combat"]:Section("orb,void", 2)
secOrbVoid:Toggle("orbit", false, function(value)
    flyOrbitEnabled = value
end)
secOrbVoid:Slider("orbit studs", 5, 10000, 50000000, 0, function(value)
    flyOrbitRadius = value
end)
secOrbVoid:Toggle("void spam", false, function(value)
    heightLockEnabled = value
end)
secOrbVoid:Slider("void spam studs", 50, 50000000, 50, 0, function(value)
    lockHeight = value
end)
local secEnv = tabs["Visuals"]:Section("environment", 1)
secEnv:Toggle("Fullbright", false, function(value)
    fullbrightEnabled = value
    local local shaderLighting = game:GetService("Lighting")
    if value then
        shaderLighting.Brightness = 2
        shaderLighting.ClockTime = 14
        shaderLighting.FogEnd = 100000
        shaderLighting.GlobalShadows = false
    else
        shaderLighting.Brightness = 1
        shaderLighting.ClockTime = 12
        shaderLighting.GlobalShadows = true
    end
end)
secEnv:Toggle("shader", false, function(value)
    shaderEnabled = value
end)
local secSkybox = tabs["Visuals"]:Section("skybox", 2)
secSkybox:Toggle("skyboxs", false, function(value)
    skyboxEnabled = value
    getRootPart(a16b37c97)
end)
secSkybox:Dropdown("Select Skybox", {"Dark Sky", "Vaporwave", "Lake Sky", "Black Mesa"}, "", function(value)
    a16b37c97 = value
    if skyboxEnabled then
        getRootPart(value)
    end
end)
local secEsp = tabs["Visuals"]:Section("visual esp", 1)
secEsp:Toggle("ESP Active", false, function(value)
    espEnabled = value
end)
secEsp:Toggle("Box Display", true, function(value)
    espBoxEnabled = value
end)
secEsp:Toggle("Name Display", true, function(value)
    espNameEnabled = value
end)
secEsp:Toggle("Health Display", true, function(value)
    espHealthEnabled = value
end)
secEsp:Toggle("weapon info", true, function(value)
    espWeaponEnabled = value
end)
local secIndicators = tabs["Visuals"]:Section("indicators", 1)
secIndicators:Toggle("ragebot", false, function(value)
    indicatorRagebot = value
end)
secIndicators:Toggle("ammo", false, function(value)
    indicatorAmmo = value
end)
local secVM = tabs["Visuals"]:Section("viewmodel cosmetics", 1)
secVM:Toggle("no recoil", false, function(value)
    a72b52c65 = value
    if not value then
        pcall(function()
            restoreGCAttribute("ShootRecoil")
        end)
        a77b58c11 = false
    end
end)
secVM:Toggle("unlock all", false, function(value)
    cosmeticUnlockEnabled = value
    pcall(function()
        if playerDataController and playerDataController.CurrentData then
            playerDataController.CurrentData:Replicate("CosmeticInventory")
            playerDataController.CurrentData:Replicate("WeaponInventory")
        end
    end)
end)
local hitSoundEnabled = false
local hitSoundChoice = "rust hs"
local hitSoundVolume = 1
local hitSoundPitch = 1
local hitSounds = {
    ["rust hs"] = "rbxassetid://4764109000",
    neverlose = "rbxassetid://97643101798871",
    sparkle = "rbxassetid://110241936966089",
    ["minecraft hit"] = "rbxassetid://8766809464",
    bonk = "rbxassetid://5766898159",
    osu = "rbxassetid://7149255551",
    ["among us"] = "rbxassetid://5700183626",
    bruh = "rbxassetid://4578740568",
    vine = "rbxassetid://5332680810",
    gamesense = "rbxassetid://4817809188",
    ["장충동 왕족발 보쌈"] = "rbxassetid://85775332966635",
}
local hitSoundList = {
    "rust hs",
    "neverlose",
    "sparkle",
    "minecraft hit",
    "bonk",
    "osu",
    "among us",
    "bruh",
    "vine",
    "gamesense",
    "장충동 왕족발 보쌈",
}
local secHitSounds = tabs["Visuals"]:Section("hit sounds", 2)
secHitSounds:Toggle("enable hit sound", false, function(value)
    hitSoundEnabled = value
end)
secHitSounds:Dropdown("hit sound style", hitSoundList, "rust hs", function(value)
    hitSoundChoice = value
end)
secHitSounds:Slider("volume", 0, 2, 1, 1, function(value)
    hitSoundVolume = value
end)
secHitSounds:Slider("pitch (speed)", 1, 20, 10, 1, function(value)
    hitSoundPitch = math.clamp(value / 10, 0.1, 2)
end)
pcall(function()
    local clientViewModel = LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ClientViewModel
    clientViewModel.ChildAdded:Connect(function(child)
        if not hitSoundEnabled then
            return
        end
        if child:IsA("Sound") and child.SoundId ~= "rbxassetid://16537449730" then
            pcall(function()
                local soundId = hitSounds[hitSoundChoice] or hitSounds["rust hs"]
                child.SoundId = soundId
                child.Pitch = hitSoundPitch
                child.Volume = 0
                local sound = Instance.new("Sound")
                sound.SoundId = soundId
                sound.Pitch = hitSoundPitch
                sound.Volume = hitSoundVolume
                sound.Parent = game:GetService("SoundService")
                sound:Play()
                game:GetService("Debris"):AddItem(sound, 4)
            end)
        end
    end)
end)
local secMovement = tabs["Misc"]:Section("movement", 1)
secMovement:Toggle("Mobile Fly", false, function(value)
    a54b51c88 = value
end)
secMovement:Slider("Mobile Fly Speed", 1, 3000, 50, 0, function(value)
    mobileFlySpeed = value
end)
secMovement:Toggle("PC Fly", false, function(value)
    pcFly = value
end)
secMovement:Slider("PC Fly Speed", 1, 10000, 50, 0, function(value)
    pcFlySpeed = value
end)
secMovement:Toggle("Noclip Active", false, function(value)
    noclipEnabled = value
end)
secMovement:Dropdown("Noclip Mode", {"all walls", "phong"}, "all walls", function(value)
    a93b76c35 = value
end)
local secEmote = tabs["Misc"]:Section("emote hop", 2)
secEmote:Toggle("Emote Hop", false, function(value)
    emoteHopEnabled = value
    if value and LocalPlayer.Character then
        playEmote(LocalPlayer.Character)
    else
        stopEmote()
    end
end)
secEmote:Slider("Emote Speed", 1, 40, 40, 0, function(value)
    emoteSpeed = value
    if JBrJMqdvA and JBrJMqdvA.IsPlaying then
        JBrJMqdvA:AdjustSpeed(value)
    end
end)
local secDeviceSpoof = tabs["Misc"]:Section("device spoofer", 2)
secDeviceSpoof:Toggle("device spoofer", false, function(value)
    a67b95c93 = value
end)
secDeviceSpoof:Dropdown("device selection", {"vr", "touch", "gamepad", "mousekeyboard"}, "vr", function(value)
    deviceChoice = value
end)
local secThirdPerson = tabs["Misc"]:Section("third person", 2)
secThirdPerson:Toggle("enabled", false, function(value)
    a13b53c88 = value
    pcall(function()
        local playersRef = cloneref(game:GetService("Players"))
        local cameraController = require(playersRef.LocalPlayer.PlayerScripts.Controllers.CameraController)
        if value then
            cameraController.CameraState:_SetPOVState(cameraController.CameraState.States.ThirdPersonMirrored)
        else
            local states = cameraController.CameraState.States
            local firstPersonState = states.FirstPerson or states.FirstPersonMirrored or states.Default
            if firstPersonState then
                cameraController.CameraState:_SetPOVState(firstPersonState)
            end
        end
    end)
end)
local secArcade = tabs["Misc"]:Section("arcade servers", 2)
secArcade:Toggle("automatically grab drops", false, function(value)
    v18003 = value
end)
local secMenu = tabs["UI Settings"]:Section("menu settings", 1)
secMenu:Label("Press [RightShift] to Toggle UI")
local themeDropdown = secMenu:Dropdown("Theme Color", {"Sky Blue", "Red", "Lime Green", "Purple", "Orange"}, "Sky Blue", function(colorName)
    if colorName == "Sky Blue" then
        nexlib.accentclr = Color3.fromRGB(128, 213, 247)
    elseif colorName == "Red" then
        nexlib.accentclr = Color3.fromRGB(255, 75, 75)
    elseif colorName == "Lime Green" then
        nexlib.accentclr = Color3.fromRGB(75, 255, 75)
    elseif colorName == "Purple" then
        nexlib.accentclr = Color3.fromRGB(180, 75, 255)
    elseif colorName == "Orange" then
        nexlib.accentclr = Color3.fromRGB(255, 140, 0)
    end
end)
secMenu:Button("Unload UI", function()
    nexlib:Notification("Shutting Down", "Goodbye!", 1.5)
    task.wait(1.5)
    window:Destroy()
end)
local secConfig = tabs["UI Settings"]:Section("Configuration", 2)
local configName = ""
secConfig:Input("Config Name", "", "Input here...", function(value)
    configName = value
end)
secConfig:Button("Create", function()
    if configName ~= "" then
        nexlib:Notification("Config", "Created: " .. configName, 1.5)
    else
        nexlib:Notification("Error", "Please enter a config name!", 1.5)
    end
end)
local selectedConfig = ""
local configList = {"Legitv1", "Ragev2"}
local configDropdown = secConfig:Dropdown("Configs", configList, "", function(value)
    selectedConfig = value
end)
secConfig:Button("Load", function()
    if selectedConfig ~= "" then
        nexlib:Notification("Config", "Loaded: " .. selectedConfig, 1.5)
    else
        nexlib:Notification("Error", "No config selected!", 1.5)
    end
end)
secConfig:Button("Save", function()
    if selectedConfig ~= "" then
        nexlib:Notification("Config", "Saved changes to: " .. selectedConfig, 1.5)
    else
        nexlib:Notification("Error", "No config selected to save!", 1.5)
    end
end)
secConfig:Button("Delete", function()
    if selectedConfig ~= "" then
        nexlib:Notification("Config", "Deleted: " .. selectedConfig, 1.5)
        selectedConfig = ""
    else
        nexlib:Notification("Error", "No config selected to delete!", 1.5)
    end
end)
local indicatorsGui = Instance.new("ScreenGui")
indicatorsGui.Name = "HalmuIndicators"
indicatorsGui.ResetOnSpawn = false
indicatorsGui.IgnoreGuiInset = true
indicatorsGui.DisplayOrder = 999
indicatorsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
    indicatorsGui.Parent = game:GetService("CoreGui")
end)
if not indicatorsGui.Parent then
    indicatorsGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
local ragebotIndicator = Instance.new("TextLabel")
ragebotIndicator.Name = "RagebotIndicator"
ragebotIndicator.BackgroundTransparency = 1
ragebotIndicator.Size = UDim2.new(0, 420, 0, 22)
ragebotIndicator.AnchorPoint = Vector2.new(0.5, 0)
ragebotIndicator.Position = UDim2.new(0.5, 0, 0.5, 36)
ragebotIndicator.Font = Enum.Font.Code
ragebotIndicator.TextSize = 14
ragebotIndicator.TextColor3 = Color3.fromRGB(245, 245, 245)
ragebotIndicator.TextStrokeTransparency = 0
ragebotIndicator.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
ragebotIndicator.Text = ""
ragebotIndicator.Visible = false
ragebotIndicator.Parent = indicatorsGui
local ammoIndicator = Instance.new("TextLabel")
ammoIndicator.Name = "AmmoIndicator"
ammoIndicator.BackgroundTransparency = 1
ammoIndicator.Size = UDim2.new(0, 420, 0, 18)
ammoIndicator.AnchorPoint = Vector2.new(0.5, 0)
ammoIndicator.Position = UDim2.new(0.5, 0, 0.5, 52)
ammoIndicator.Font = Enum.Font.Code
ammoIndicator.TextSize = 11
ammoIndicator.TextColor3 = Color3.fromRGB(245, 245, 245)
ammoIndicator.TextStrokeTransparency = 0
ammoIndicator.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
ammoIndicator.Text = ""
ammoIndicator.Visible = false
ammoIndicator.Parent = indicatorsGui
local function getLocalAmmoStatus()
    local v43335, reserveAmmo, reloading = nil, nil, false
    pcall(function()
        local playerScripts = LocalPlayer.PlayerScripts
        local ok, fighterController = pcall(require, playerScripts.Controllers.FighterController)
        if not ok or not fighterController then
            return
        end
        local localFighter = fighterController.LocalFighter
        if not localFighter then
            return
        end
        local equippedItem = localFighter.EquippedItem
        if not equippedItem then
            return
        end
        local function getProperty(key)
            local ok, value = pcall(function()
                if equippedItem.Get then
                    return equippedItem:Get(key)
                end
                return equippedItem[key] or (equippedItem.Data and equippedItem.Data[key]) or (equippedItem.Info and equippedItem.Info[key])
            end)
            if ok then
                return value
            end
            return nil
        end
        v43335 = getProperty("CurrentAmmo") or getProperty("Ammo") or getProperty("Bullets") or getProperty("MagazineAmmo")
        reserveAmmo = getProperty("ReserveAmmo") or getProperty("StoredAmmo") or getProperty("Reserve") or getProperty("TotalAmmo") or getProperty("MaxAmmo") or getProperty("MaxBullets")
        local reloadFlag = getProperty("Reloading") or getProperty("IsReloading") or getProperty("Reload")
        reloading = reloadFlag == true
        if equippedItem.Info and type(equippedItem.Info) == "table" then
            if v43335 == nil then
                v43335 = equippedItem.Info.CurrentAmmo or equippedItem.Info.Ammo
            end
            if reserveAmmo == nil then
                reserveAmmo = equippedItem.Info.ReserveAmmo or equippedItem.Info.StoredAmmo or equippedItem.Info.MaxAmmo
            end
            if equippedItem.Info.Reloading == true or equippedItem.Info.IsReloading == true then
                reloading = true
            end
        end
    end)
    return v43335, reserveAmmo, reloading
end
RunService.RenderStepped:Connect(function()
    local viewportSize = Camera.ViewportSize
    if indicatorRagebot and ragebotActive then
        local targetName = "idk"
        if currentTargetPart and currentTargetPart.Parent then
            local targetModel = currentTargetPart:FindFirstAncestorOfClass("Model") or currentTargetPart.Parent
            local targetPlayer = Players:GetPlayerFromCharacter(targetModel)
            if targetPlayer then
                targetName = targetPlayer.DisplayName or targetPlayer.Name
            elseif typeof(targetModel) == "Instance" then
                targetName = targetModel.Name
            end
        end
        ragebotIndicator.Text = "ragebot : " .. tostring(targetName) .. "..."
        ragebotIndicator.Position = UDim2.new(0.5, 0, 0.5, 36)
        ragebotIndicator.Visible = true
    else
        ragebotIndicator.Visible = false
    end
    if indicatorAmmo then
        local v43335, reserveAmmo, reloading = getLocalAmmoStatus()
        local ammoText
        if reloading or (typeof(v43335) == "number" and v43335 <= 0 and (reserveAmmo == nil or (typeof(reserveAmmo) == "number" and reserveAmmo >= 0))) then
            if reloading or (typeof(v43335) == "number" and v43335 <= 0) then
                if reloading then
                    ammoText = "reloading"
                elseif typeof(v43335) == "number" and typeof(reserveAmmo) == "number" then
                    ammoText = string.format("%d/%d", reserveAmmo, v43335)
                else
                    ammoText = "reloading"
                end
            end
        end
        if not ammoText then
            if typeof(v43335) == "number" and typeof(reserveAmmo) == "number" then
                ammoText = string.format("%d/%d", reserveAmmo, v43335)
            elseif typeof(v43335) == "number" then
                ammoText = tostring(v43335)
            else
                ammoText = nil
            end
        end
        if reloading then
            ammoText = "reloading"
        end
        if ammoText then
            ammoIndicator.Text = ammoText
            local yPos = 52
            if indicatorRagebot and ragebotActive then
                yPos = 52
            end
            ammoIndicator.Position = UDim2.new(0.5, 0, 0.5, yPos)
            ammoIndicator.Visible = true
        else
            ammoIndicator.Visible = false
        end
    else
        ammoIndicator.Visible = false
    end
end)
RunService.RenderStepped:Connect(function()
    if not v18003 then
        return
    end
    local char = LocalPlayer.Character
    if not char then
        return
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end
    local hum = char:FindFirstChild("Humanoid")
    local needsHealth = hum and hum.Health < hum.MaxHealth
    for YEzeEiWEWFAS, obj in workspace:GetChildren() do
        if obj.Name == "_drop" and obj:IsA("BasePart") then
            if (autoGrabHealth and obj:FindFirstChild("Health") and needsHealth) or (autoGrabAmmo and obj:FindFirstChild("Ammo")) then
                pcall(function()
                    firetouchinterest(hrp, obj, 0)
                    firetouchinterest(hrp, obj, 1)
                end)
            end
        end
    end
end)
local gcBackups = {
    ShootCooldown = setmetatable({}, {__mode = "k"}),
    ShootRecoil = setmetatable({}, {__mode = "k"}),
}
local function overrideGcAttribute(attribute, value)
    local backup = gcBackups[attribute]
    if not backup then
        return
    end
    for YEzeEiWEWFAS, gcVal in pairs(getgc(true)) do
        if type(gcVal) == "table" then
            local v43335 = rawget(gcVal, attribute)
            if v43335 ~= nil then
                if backup[gcVal] == nil then
                    backup[gcVal] = v43335
                end
                gcVal[attribute] = value
            end
        end
    end
end
local function restoreGcAttribute(attribute)
    local backup = gcBackups[attribute]
    if not backup then
        return
    end
    for gcVal, original in pairs(backup) do
        if type(gcVal) == "table" then
            pcall(function()
                gcVal[attribute] = original
            end)
        end
        backup[gcVal] = nil
    end
end
local reloadBackups = {}
local instantReloadActive = false
local function enableInstantReload()
    local a17b70c23 = require(game:GetService("ReplicatedStorage").Modules.ItemLibrary)
    local Items = rawget(a17b70c23, "Items")
    if not Items then
        return
    end
    local TARGET_ITEMS = {"Bow", "Daggers", "Slingshot"}
    for YEzeEiWEWFAS, Item in pairs(Items) do
        local Name = Item.Name
        if table.find(TARGET_ITEMS, Name) and Item["ReloadLength"] ~= nil then
            if reloadBackups[Name] == nil then
                reloadBackups[Name] = Item["ReloadLength"]
            end
            rawset(Item, "ReloadLength", (Name == "Daggers" and 0.09 or 0))
        end
    end
    instantReloadActive = true
end
local function restoreReload()
    local a17b70c23 = require(game:GetService("ReplicatedStorage").Modules.ItemLibrary)
    local Items = rawget(a17b70c23, "Items")
    if not Items then
        return
    end
    local TARGET_ITEMS = {"Bow", "Daggers", "Slingshot"}
    for YEzeEiWEWFAS, Item in pairs(Items) do
        local Name = Item.Name
        if table.find(TARGET_ITEMS, Name) and reloadBackups[Name] ~= nil then
            rawset(Item, "ReloadLength", reloadBackups[Name])
        end
    end
    instantReloadActive = false
end
RunService.Heartbeat:Connect(function()
    if a77b85c82 then
        pcall(function()
            overrideGcAttribute("ShootCooldown", 0)
        end)
        v50691 = true
    elseif v50691 then
        pcall(function()
            restoreGcAttribute("ShootCooldown")
        end)
        v50691 = false
    end
    if a72b52c65 then
        pcall(function()
            overrideGcAttribute("ShootRecoil", 0)
        end)
        a77b58c11 = true
    elseif a77b58c11 then
        pcall(function()
            restoreGcAttribute("ShootRecoil")
        end)
        a77b58c11 = false
    end
    if v34672 then
        pcall(enableInstantReload)
    elseif instantReloadActive then
        pcall(restoreReload)
    end
end)
LocalPlayer.CharacterAdded:Connect(function(char)
    if emoteHopEnabled then
        char:WaitForChild("Humanoid")
        task.wait(0.1)
        if playEmote then
            playEmote(char)
        end
    end
    if a13b53c88 then
        task.defer(function()
            pcall(function()
                local playersRef = cloneref(game:GetService("Players"))
                local cameraController = require(playersRef.LocalPlayer.PlayerScripts.Controllers.CameraController)
                cameraController.CameraState:_SetPOVState(cameraController.CameraState.States.ThirdPersonMirrored)
            end)
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(1)
        if a67b95c93 then
            pcall(function()
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                local replication = remotes and remotes:FindFirstChild("Replication") or remotes
                local fighter = replication and replication:FindFirstChild("Fighter")
                local setControls = fighter and fighter:FindFirstChild("SetControls")
                if setControls and setControls:IsA("RemoteEvent") then
                    if deviceChoice == "vr" then
                        setControls:FireServer("VR")
                    elseif deviceChoice == "touch" then
                        setControls:FireServer("Touch")
                    elseif deviceChoice == "gamepad" then
                        setControls:FireServer("Gamepad")
                    elseif deviceChoice == "mousekeyboard" then
                        setControls:FireServer("MouseKeyboard")
                    end
                end
            end)
        end
    end
end)
RunService.Stepped:Connect(function(deltaTime)
    local v11706 = LocalPlayer.Character
    if not v11706 then
        return
    end
    local hrp = v11706:FindFirstChild("HumanoidRootPart")
    local hum = v11706:FindFirstChild("Humanoid")
    if not hrp then
        return
    end
    if noclipEnabled then
        for YEzeEiWEWFAS, part in pairs(v11706:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    if (a54b51c88 or pcFly) then
        if hum then
            hum.PlatformStand = true
        end
        local vel = Vector3.zero
        if a54b51c88 then
            if hum and hum.MoveDirection.Magnitude > 0 then
                vel = Camera.CFrame.LookVector * mobileFlySpeed
            end
        elseif pcFly then
            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                dir = dir + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                dir = dir - Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                dir = dir - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                dir = dir + Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                dir = dir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                dir = dir - Vector3.new(0, 1, 0)
            end
            if dir.Magnitude > 0 then
                vel = dir.Unit * pcFlySpeed
            end
        end
        hrp.AssemblyLinearVelocity = vel
        hrp.AssemblyAngularVelocity = Vector3.zero
    else
        if hum and hum.PlatformStand then
            hum.PlatformStand = false
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end
end)
local function resolveAnimationAsset(assetId)
    local a37b43c30, objs = pcall(function()
        return game:GetObjects(assetId)
    end)
    if a37b43c30 and objs and #objs > 0 then
        for i = 1, #objs do
            if objs[i]:IsA("Animation") then
                return objs[i].AnimationId
            end
        end
    end
    return assetId
end
task.spawn(function()
    local animId = "rbxassetid://92281817840531"
    animId = resolveAnimationAsset(animId)
    emoteAnimation = Instance.new("Animation")
    emoteAnimation.AnimationId = animId
end)
function playEmote(char)
    if not emoteHopEnabled or not char or not emoteAnimation then
        return
    end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hum then
        return
    end
    if JBrJMqdvA then
        JBrJMqdvA:Stop()
        JBrJMqdvA = nil
    end
    local animator = hum:FindFirstChildOfClass("Animator") or hum
    local ok, track = pcall(function()
        return animator:LoadAnimation(emoteAnimation)
    end)
    if ok and track then
        JBrJMqdvA = track
        track.Priority = Enum.AnimationPriority.Action4
        track:Play()
        track:AdjustSpeed(emoteSpeed)
        track.Stopped:Connect(function()
            if emoteHopEnabled and LocalPlayer.Character == char then
                playEmote(char)
            end
        end)
    end
end
function stopEmote()
    if JBrJMqdvA then
        JBrJMqdvA:Stop()
        JBrJMqdvA = nil
    end
end
task.spawn(function()
    while true do
        task.wait(0.05)
        if flyOrbitEnabled then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and not a39b72c33 then
                a39b72c33 = hrp.Position
            end
        else
            a39b72c33 = nil
        end
    end
end)
local function getHitPart(char, hitboxName)
    if not char then
        return nil
    end
    local n = string.lower(tostring(hitboxName or "head"))
    if n == "humanoidrootpart" then
        return char:FindFirstChild("HumanoidRootPart")
    elseif n == "torso" then
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    end
    return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
end
local function hasLineOfSight(targetPart, v11706)
    if not targetPart then
        return false
    end
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {v11706, Camera}
    rayParams.IgnoreWater = true
    local hit = workspace:Raycast(origin, direction, rayParams)
    if not hit then
        return true
    end
    local hitModel = hit.Instance and hit.Instance:FindFirstAncestorOfClass("Model")
    local targetModel = targetPart:FindFirstAncestorOfClass("Model")
    return hitModel ~= nil and targetModel ~= nil and hitModel == targetModel
end
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "HalmuFOV"
fovGui.ResetOnSpawn = false
fovGui.IgnoreGuiInset = true
fovGui.DisplayOrder = 50
pcall(function()
    fovGui.Parent = game:GetService("CoreGui")
end)
if not fovGui.Parent then
    fovGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
local function createFovCircle(name, color)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = fovGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = frame
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = color
    stroke.Transparency = 0.15
    stroke.Parent = frame
    return frame
end
local aimbotFovCircle = createFovCircle("AimbotFOV", Color3.fromRGB(255, 255, 255))
local silentAimFovCircle = createFovCircle("SilentAimFOV", Color3.fromRGB(255, 80, 80))
local function updateFovCircle(frame, mousePos, radius, visible)
    if not visible then
        frame.Visible = false
        return
    end
    local r = math.max(tonumber(radius) or 50, 10)
    frame.Size = UDim2.fromOffset(r * 2, r * 2)
    frame.Position = UDim2.fromOffset(mousePos.X, mousePos.Y)
    frame.Visible = true
end
pcall(function()
    local fighterControllerCached = require(LocalPlayer.PlayerScripts.Controllers.FighterController)
    local LocalFighter = fighterControllerCached.LocalFighter
    if LocalFighter and LocalFighter.GetMouseLocation then
        local origGetMouseLocation = LocalFighter.GetMouseLocation
        local wrap = newcclosure or function(f)
            return f
        end
        LocalFighter.GetMouseLocation = wrap(function(...)
            if silentAimEnabled and silentAimTarget then
                local v40724 = Camera:WorldToScreenPoint(silentAimTarget.Position)
                return Vector2.new(v40724.X, v40724.Y)
            end
            return origGetMouseLocation(...)
        end)
    end
end)
RunService.RenderStepped:Connect(function(deltaTime)
    local v11706 = LocalPlayer.Character
    local mousePos = UserInputService:GetMouseLocation()
    Camera = workspace.CurrentCamera or Camera
    updateFovCircle(aimbotFovCircle, mousePos, aimbotFovRadius, showAimbotFov == true)
    updateFovCircle(silentAimFovCircle, mousePos, silentAimFovRadius, showSilentAimFov == true)
    silentAimTarget = nil
    if silentAimEnabled and v11706 then
        local bestDist = math.huge
        local camPos = Camera.CFrame.Position
        local camLook = Camera.CFrame.LookVector
        for YEzeEiWEWFAS, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= LocalPlayer and not isTeammate(otherPlayer) then
                local char = otherPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 and not char:FindFirstChildOfClass("ForceField") then
                        local targetPart = getHitPart(char, silentAimHitPart)
                        if targetPart then
                            local v40724, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                            if onScreen then
                                local screenVec = Vector2.new(v40724.X, v40724.Y)
                                local dist = (screenVec - mousePos).Magnitude
                                if dist <= silentAimFovRadius and dist < bestDist then
                                    local dir = (targetPart.Position - camPos)
                                    if dir.Magnitude > 0 and camLook:Dot(dir.Unit) > 0 then
                                        if (not silentWallCheck) or hasLineOfSight(targetPart, v11706) then
                                            bestDist = dist
                                            silentAimTarget = targetPart
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    local aimActive = aimbotEnabled and v11706 and ((not aimbotRequireRMB) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2))
    if aimActive then
        local best = nil
        local a19b46c84 = aimbotFovRadius
        for YEzeEiWEWFAS, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and not isTeammate(player) then
                local char = player.Character
                local hum = char:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    local targetPart = getHitPart(char, aimbotHitPart)
                    if targetPart then
                        local screenX, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local dist = (Vector2.new(screenX.X, screenX.Y) - mousePos).Magnitude
                            if dist < a19b46c84 then
                                if (not aimbotWallCheck) or hasLineOfSight(targetPart, v11706) then
                                    a19b46c84 = dist
                                    best = targetPart
                                end
                            end
                        end
                    end
                end
            end
        end
        if best then
            local screenPos = Camera:WorldToViewportPoint(best.Position)
            local dx = (screenPos.X - mousePos.X) / math.max(aimbotSmoothness, 1)
            local dy = (screenPos.Y - mousePos.Y) / math.max(aimbotSmoothness, 1)
            if mousemoverel then
                mousemoverel(dx, dy)
            end
        end
    end
end)
RunService.Heartbeat:Connect(function()
    local v11706 = LocalPlayer.Character
    local hrp = v11706 and v11706:FindFirstChild("HumanoidRootPart")
    local hum = v11706 and v11706:FindFirstChild("Humanoid")
    if not hrp or (hum and hum.Health <= 0) then
        return
    end
    if killAuraEnabled and everyNFrames(3) then
        local n = 0
        for YEzeEiWEWFAS, player in pairs(Players:GetPlayers()) do
            n = n + 1
            if n > 8 then
                break
            end
            if player ~= LocalPlayer and player.Character then
                local pHrp = player.Character:FindFirstChild("HumanoidRootPart")
                local pHum = player.Character:FindFirstChild("Humanoid")
                if pHrp and pHum and pHum.Health > 0 then
                    pHrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -3)
                    pHrp.AssemblyLinearVelocity = Vector3.zero
                end
            end
        end
        local tool = v11706:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
    end
    if flyOrbitEnabled then
        return
    end
    if heightLockEnabled then
        hrp.CFrame = CFrame.new(hrp.Position.X, lockHeight, hrp.Position.Z)
        return
    end
end)
local espGui = Instance.new("ScreenGui")
espGui.Name = "HalmuESP"
espGui.ResetOnSpawn = false
espGui.IgnoreGuiInset = true
espGui.DisplayOrder = 40
pcall(function()
    espGui.Parent = game:GetService("CoreGui")
end)
if not espGui.Parent then
    espGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
local function getWeaponInfo(player)
    local label, ammoStr = nil, nil
    pcall(function()
        local fighterController = fighterControllerCached
        if not fighterController then
            local ok, mod = pcall(require, LocalPlayer.PlayerScripts.Controllers.FighterController)
            if ok then
                fighterController = mod
                fighterControllerCached = mod
            end
        end
        if not fighterController then
            return
        end
        local fighter = nil
        if type(fighterController.GetFighter) == "function" then
            fighter = fighterController:GetFighter(player)
        end
        if not fighter and player == LocalPlayer then
            fighter = fighterController.LocalFighter
        end
        if not fighter then
            return
        end
        local equippedItem = fighter.EquippedItem
        if not equippedItem then
            local char = player.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            if tool then
                label = tool.Name
            end
            return
        end
        local function getProperty(key)
            local ok, value = pcall(function()
                if equippedItem.Get then
                    return equippedItem:Get(key)
                end
                return equippedItem[key] or (equippedItem.Data and equippedItem.Data[key]) or (equippedItem.Info and equippedItem.Info[key])
            end)
            if ok then
                return value
            end
            return nil
        end
        local v43335 = getProperty("CurrentAmmo") or getProperty("Ammo") or getProperty("Bullets") or getProperty("MagazineAmmo")
        local reserveAmmo = getProperty("ReserveAmmo") or getProperty("StoredAmmo") or getProperty("Reserve") or getProperty("TotalAmmo")
        local reloading = getProperty("Reloading") or getProperty("IsReloading")
        if equippedItem.Info and type(equippedItem.Info) == "table" then
            if v43335 == nil then
                v43335 = equippedItem.Info.CurrentAmmo or equippedItem.Info.Ammo
            end
            if reserveAmmo == nil then
                reserveAmmo = equippedItem.Info.ReserveAmmo or equippedItem.Info.StoredAmmo
            end
            if equippedItem.Info.Reloading == true or equippedItem.Info.IsReloading == true then
                reloading = true
            end
        end
        local reloadCooldown = rawget(equippedItem, "_reload_cooldown")
        if type(reloadCooldown) == "number" and reloadCooldown > tick() then
            reloading = true
        end
        local weaponName = equippedItem.Name or getProperty("Name") or "weapon"
        label = (reloading == true) and "*Reloading*" or tostring(weaponName)
        if typeof(v43335) == "number" and typeof(reserveAmmo) == "number" then
            ammoStr = string.format("%d/%d", math.floor(v43335 + 0.5), math.floor(reserveAmmo + 0.5))
        elseif typeof(v43335) == "number" then
            ammoStr = tostring(math.floor(v43335 + 0.5))
        end
    end)
    if not label then
        pcall(function()
            local char = player.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            if tool then
                label = tool.Name
            end
        end)
    end
    if not label then
        return nil
    end
    if ammoStr and ammoStr ~= "" then
        return label .. " | " .. ammoStr
    end
    return label
end

-- ── ESP / 트리거봇 / 셰이더 ────────────────

local _espEntries = {}
local function createEspEntry(player)
    if _espEntries[player] then return end

    local box = Instance.new("Frame")
    box.Name = "Box"
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.Parent = espGui
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(255, 70, 70)
    stroke.Parent = box

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Name"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.Code
    nameLabel.TextSize = 13
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.Size = UDim2.new(0, 160, 0, 16)
    nameLabel.Visible = false
    nameLabel.Parent = espGui

    local hpBg = Instance.new("Frame")
    hpBg.Name = "HealthBg"
    hpBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    hpBg.BackgroundTransparency = 0.35
    hpBg.BorderSizePixel = 0
    hpBg.Visible = false
    hpBg.Parent = espGui

    local hpBar = Instance.new("Frame")
    hpBar.Name = "HealthBar"
    hpBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    hpBar.BorderSizePixel = 0
    hpBar.Visible = false
    hpBar.Parent = espGui

    local weaponLabel = Instance.new("TextLabel")
    weaponLabel.Name = "Weapon"
    weaponLabel.BackgroundTransparency = 1
    weaponLabel.Font = Enum.Font.Code
    weaponLabel.TextSize = 12
    weaponLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    weaponLabel.TextStrokeTransparency = 0
    weaponLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    weaponLabel.TextXAlignment = Enum.TextXAlignment.Center
    weaponLabel.Size = UDim2.new(0, 180, 0, 14)
    weaponLabel.Visible = false
    weaponLabel.Parent = espGui

    _espEntries[player] = {
        Box = box,
        BoxStroke = stroke,
        Name = nameLabel,
        HealthBg = hpBg,
        HealthBar = hpBar,
        Weapon = weaponLabel,
    }
end

local function destroyEspEntry(player)
    if _espEntries[player] then
        for k, d in pairs(_espEntries[player]) do
            if typeof(d) == "Instance" then
                pcall(function() d:Destroy() end)
            end
        end
        _espEntries[player] = nil
    end
end
for __YEzeEiWEWFAS, __RrBoATP in pairs(Players:GetPlayers()) do
    if __RrBoATP ~= LocalPlayer then createEspEntry(__RrBoATP) end
end
Players.PlayerAdded:Connect(function(__RrBoATP)
    if __RrBoATP ~= LocalPlayer then createEspEntry(__RrBoATP) end
end)
Players.PlayerRemoving:Connect(destroyEspEntry)

RunService.RenderStepped:Connect(function()
    Camera = workspace.CurrentCamera or Camera
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not everyNFrames(2) then return end
    for player, drawings in pairs(_espEntries) do
        local box, nameLabel, hpBg, hpBar = drawings.Box, drawings.Name, drawings.HealthBg, drawings.HealthBar
        local stroke = drawings.BoxStroke
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local head = char and (char:FindFirstChild("Head") or char:FindFirstChild("HitboxHead") or hrp)

        local weaponLabel = drawings.Weapon
        local function hideAll()
            box.Visible = false
            nameLabel.Visible = false
            hpBg.Visible = false
            hpBar.Visible = false
            if weaponLabel then weaponLabel.Visible = false end
        end

        if espEnabled and hrp and hum and head and hum.Health > 0 then
            local headPos = head.Position + Vector3.new(0, 0.6, 0)
            local footPos = hrp.Position - Vector3.new(0, 3, 0)
            local headScreen, headOn = Camera:WorldToViewportPoint(headPos)
            local footScreen, footOn = Camera:WorldToViewportPoint(footPos)
            local centerScreen, centerOn = Camera:WorldToViewportPoint(hrp.Position)

            if (centerOn or headOn or footOn) and centerScreen.Z > 0 then
                local height = math.abs(headScreen.Y - footScreen.Y)
                if height < 8 then height = 40 end
                local width = height * 0.55
                local xPos = centerScreen.X - width / 2
                local yPos = headScreen.Y

                if espBoxEnabled then
                    box.Size = UDim2.fromOffset(width, height)
                    box.Position = UDim2.fromOffset(xPos, yPos)
                    local boxColor = isTeammate(player) and Color3.fromRGB(80, 160, 255) or Color3.fromRGB(255, 70, 70)
                    if stroke then stroke.Color = boxColor end
                    box.Visible = true
                else
                    box.Visible = false
                end

                if espNameEnabled then
                    local distTxt = ""
                    if myHrp then
                        distTxt = " [" .. math.floor((hrp.Position - myHrp.Position).Magnitude) .. "m]"
                    end
                    nameLabel.Text = (player.DisplayName or player.Name) .. distTxt
                    nameLabel.Position = UDim2.fromOffset(centerScreen.X - 80, yPos - 16)
                    nameLabel.TextColor3 = isTeammate(player) and Color3.fromRGB(120, 180, 255) or Color3.fromRGB(255, 255, 255)
                    nameLabel.Visible = true
                else
                    nameLabel.Visible = false
                end

                if espHealthEnabled then
                    local hpPct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                    hpBg.Size = UDim2.fromOffset(3, height)
                    hpBg.Position = UDim2.fromOffset(xPos - 6, yPos)
                    hpBg.Visible = true
                    local hpFill = math.max(height * hpPct, 1)
                    hpBar.Size = UDim2.fromOffset(3, hpFill)
                    hpBar.Position = UDim2.fromOffset(xPos - 6, yPos + (height - hpFill))
                    hpBar.BackgroundColor3 = Color3.fromHSV(hpPct * 0.33, 1, 1)
                    hpBar.Visible = true
                else
                    hpBg.Visible = false
                    hpBar.Visible = false
                end

                if espWeaponEnabled and weaponLabel then
                    local weaponInfo = getWeaponInfo(player)
                    if weaponInfo and weaponInfo ~= "" then
                        weaponLabel.Text = weaponInfo
                        weaponLabel.Position = UDim2.fromOffset(centerScreen.X - 90, yPos + height + 2)
                        weaponLabel.TextColor3 = isTeammate(player) and Color3.fromRGB(140, 190, 255) or Color3.fromRGB(220, 220, 220)
                        weaponLabel.Visible = true
                    else
                        weaponLabel.Visible = false
                    end
                elseif weaponLabel then
                    weaponLabel.Visible = false
                end
            else
                hideAll()
            end
        else
            hideAll()
        end
    end
end)

local _triggerHolding = false
local _lastClickTime = 0
local _rayParams = RaycastParams.new()
_rayParams.FilterType = Enum.RaycastFilterType.Exclude

local function isCrosshairEnemy()
    local char = LocalPlayer.Character
    if not char then return false end

    _rayParams.FilterDescendantsInstances = {char, Camera}
    local hit = workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector * 400, _rayParams)

    if hit and hit.Instance then
        local model = hit.Instance:FindFirstAncestorOfClass("Model")
        if model and model ~= char then
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local hitPlayer = Players:GetPlayerFromCharacter(model)
                if hitPlayer and isTeammate(hitPlayer) then
                    return false
                end
                return true
            end
        end
    end
    return false
end

RunService.RenderStepped:Connect(function()
    if not everyNFrames(2) then return end
    if not triggerbotEnabled then
        if _triggerHolding then
            pcall(mouse1release)
            local _triggerHolding = false
        end
        return
    end

    if mouse1click and (isrbxactive or iswindowactive) and (isrbxactive() or iswindowactive()) then
        if isCrosshairEnemy() then
            if _lastClickTime < tick() then
                if _triggerHolding then
                    pcall(mouse1release)
                    _lastClickTime = tick() + 0.07
                else
                    pcall(mouse1press)
                end
                _triggerHolding = not _triggerHolding
            end
        else
            if _triggerHolding then
                pcall(mouse1release)
                local _triggerHolding = false
            end
        end
    end
end)
local shaderLighting = game:GetService("Lighting")
local _savedLighting = {}
local _shaderBlur = Instance.new("BlurEffect")
_shaderBlur.Name = "ShaderBlur"
_shaderBlur.Size = 6

local _shaderColor = Instance.new("ColorCorrectionEffect")
_shaderColor.Name = "ShaderColor"
_shaderColor.Saturation = -0.35

local function enableShader()
    _savedLighting = {
        Ambient = shaderLighting.Ambient,
        Brightness = shaderLighting.Brightness,
        OutdoorAmbient = shaderLighting.OutdoorAmbient,
        ShadowSoftness = shaderLighting.ShadowSoftness,
        TimeOfDay = shaderLighting.TimeOfDay,
        ColorShift_Top = shaderLighting.ColorShift_Top,
        ColorShift_Bottom = shaderLighting.ColorShift_Bottom
    }

    shaderLighting.Ambient = Color3.fromRGB(94, 99, 188)
    shaderLighting.Brightness = 3.5
    shaderLighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
    shaderLighting.ShadowSoftness = 2.5
    shaderLighting.TimeOfDay = "00:30:00"
    shaderLighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    shaderLighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)

    _shaderBlur.Parent = v56079
    _shaderColor.Parent = v56079
end

local function disableShader()
    if next(_savedLighting) then
        shaderLighting.Ambient = _savedLighting.Ambient
        shaderLighting.Brightness = _savedLighting.Brightness
        shaderLighting.OutdoorAmbient = _savedLighting.OutdoorAmbient
        shaderLighting.ShadowSoftness = _savedLighting.ShadowSoftness
        shaderLighting.TimeOfDay = _savedLighting.TimeOfDay
        shaderLighting.ColorShift_Top = _savedLighting.ColorShift_Top
        shaderLighting.ColorShift_Bottom = _savedLighting.ColorShift_Bottom
    end

    _shaderBlur.Parent = nil
    _shaderColor.Parent = nil
end

local _shaderState = false
RunService.Heartbeat:Connect(function()
    if shaderEnabled ~= _shaderState then
        _shaderState = shaderEnabled
        if shaderEnabled then
            enableShader()
        else
            disableShader()
        end
    end
end)

task.defer(function()
    pcall(function()
        local c = game:GetService("CoreGui")
        local n = c:FindFirstChild("nexlib")
        if n then
            for _, ch in ipairs(n:GetDescendants()) do
                if ch.Name == "MainFrame" then
                    ch.Visible = true
                end
            end
        end
        game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default
        game:GetService("UserInputService").MouseIconEnabled = true
    end)
end)
