-- language: Lua, file: AuraGui.lua
-- AURA KEY SYSTEM — Premium Edition
-- Full UI with animations, particles, ripple, toast, spinner

local WEB_URL = "https://brdoly.github.io/Brdoly/AURA_KEY.html"
local SAVE_FILE = "aura_save.dat"
local CROWN_URL = "https://files.catbox.moe/cfdgvm.jpg"
local CROWN_FALLBACK = "rbxassetid://10709799087"
local DISCORD_URL = "https://discord.gg/aura"
local TELEGRAM_URL = "https://t.me/aurakey"

local HUBS = {
    [1] = {n="VOIDSHELL", s="7f3a9c2e8b5d1a4f6e0c9b2d8a7f3e1c5b4d9a2f8e6c1b3d7a5f9e2c4b8d6a1f",
        u="https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/StealAnEgg.luau",
        tag="TOP 1", uses="1818"},
    [2] = {n="WHITEX", s="2b8d4f1a6c9e3b7d5a0f2c8e4b9d1f6a3c7e5b2d8f4a9c1e6b3d7a5f2c8e4b9d",
        u="https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/StealEggOnly.luau",
        tag="HOT", uses="1245"},
    [3] = {n="VZSTUDIO", s="9e5c2a7f4b1d8e6c3a0f9b5d2e7c4a1f8b6d3e9c5a2f7b4d1e8c6a3f9b5d2e7c",
        u="https://vxezestudio.online/api/scripts/script_G5CGjqj2X3rOS/strem/init",
        tag="NEW", uses="876"},
    [4] = {n="JUALNASI", s="4a1f8c5e2b9d6f3a7c0e4b8d1f5a2c9e6b3d7f4a1c8e5b2d9f6a3c7e4b1d8f5a",
        u="https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua",
        tag="STABLE", uses="2034"}
}

-- ============================================================
-- SERVICES
-- ============================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local P = Players.LocalPlayer

-- ============================================================
-- ICON LOADER
-- ============================================================
local function getCrownId()
    if CROWN_URL ~= "" then
        local ok, id = pcall(function()
            local fname = "aura_crown_tmp.jpg"
            if writefile then
                writefile(fname, game:HttpGet(CROWN_URL))
                return getcustomasset(fname)
            end
        end)
        if ok and id then return id end
    end
    return CROWN_FALLBACK
end
local CROWN_ID = getCrownId()

-- ============================================================
-- KEY VALIDATION
-- ============================================================
local function cleanKey(k)
    if type(k)~="string" then return "" end
    return k:gsub("%s+",""):gsub("[^A-Za-z0-9%-]",""):upper()
end

local function validKey(k, secret)
    if type(k)~="string" then return false end
    k = cleanKey(k)
    local p = {}
    for x in k:gmatch("[^%-]+") do table.insert(p, x) end
    if #p ~= 4 then return false end
    if p[1]~="AURA" or p[2]~="KEY" then return false end
    local t = tonumber(p[3], 36)
    if not t then return false end
    local age = os.time() - t
    if age < 0 or age > 43200 then return false end
    if p[4] ~= secret:sub(1,8):upper() then return false end
    return true
end

local function saveKey(h, k)
    pcall(function()
        if writefile then
            writefile(SAVE_FILE, HttpService:JSONEncode({h=h,k=k,saved=os.time()}))
        end
    end)
end

local function loadSaved()
    local ok, c = pcall(function()
        if isfile and isfile(SAVE_FILE) then return readfile(SAVE_FILE) end
    end)
    if not ok or not c then return nil end
    local ok2, d = pcall(function() return HttpService:JSONDecode(c) end)
    return ok2 and d or nil
end

local function delSaved()
    pcall(function()
        if delfile and isfile and isfile(SAVE_FILE) then delfile(SAVE_FILE) end
    end)
end

-- ============================================================
-- WIPE OLD GUI
-- ============================================================
if P:FindFirstChild("AKG") then P.AKG:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "AKG"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.Parent = P:WaitForChild("PlayerGui")

-- ============================================================
-- BACKGROUND EFFECTS — particles ambient
-- ============================================================
task.spawn(function()
    local rng = Random.new()
    while gui.Parent do
        local p = Instance.new("Frame")
        p.Size = UDim2.new(0, rng:NextNumber(3, 7), 0, rng:NextNumber(3, 7))
        p.Position = UDim2.new(rng:NextNumber(0, 1), 0, 1.05, 0)
        p.BackgroundColor3 = Color3.fromRGB(
            rng:NextInteger(140, 220),
            rng:NextInteger(100, 180),
            rng:NextInteger(200, 255)
        )
        p.BorderSizePixel = 0
        p.BackgroundTransparency = 0.3
        p.ZIndex = 0
        p.Parent = gui
        Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)

        local duration = rng:NextNumber(4, 8)
        local targetY = rng:NextNumber(-0.1, 0.5)

        TweenService:Create(p, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Position = UDim2.new(p.Position.X.Scale, 0, targetY, 0),
            BackgroundTransparency = 1
        }):Play()

        task.delay(duration, function()
            if p.Parent then p:Destroy() end
        end)

        task.wait(rng:NextNumber(0.15, 0.4))
    end
end)

-- ============================================================
-- MAIN FRAME
-- ============================================================
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 0, 0, 0)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(16, 12, 28)
main.BorderSizePixel = 0
main.ZIndex = 5
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 22)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Thickness = 1.8
mainStroke.Transparency = 0.2

local strokeGrad = Instance.new("UIGradient", mainStroke)
strokeGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(192, 132, 252)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(236, 72, 153)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(56, 189, 248)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(192, 132, 252))
}
strokeGrad.Rotation = 45

-- animated gradient rotation
task.spawn(function()
    while mainStroke.Parent do
        strokeGrad.Rotation = (strokeGrad.Rotation + 1) % 360
        RunService.RenderStepped:Wait()
    end
end)

-- background gradient
local bgGrad = Instance.new("UIGradient", main)
bgGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 20, 48)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 14, 36)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 10, 26))
}
bgGrad.Rotation = 135

-- drop shadow
local shadow = Instance.new("ImageLabel")
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Size = UDim2.new(1, 120, 1, 120)
shadow.Position = UDim2.new(0.5, 0, 0.5, 25)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5028857084"
shadow.ImageColor3 = Color3.fromRGB(80, 40, 120)
shadow.ImageTransparency = 0.4
shadow.ZIndex = 4
shadow.Parent = gui

-- open animation
task.spawn(function()
    TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 480, 0, 600)
    }):Play()
    task.wait(0.15)
    local glowTween = TweenService:Create(mainStroke, TweenInfo.new(0.3), {
        Transparency = 0.2
    })
    glowTween:Play()
end)

task.spawn(function()
    while main.Parent and shadow.Parent do
        TweenService:Create(shadow, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
            ImageTransparency = 0.55
        }):Play()
        task.wait(0.5)
        TweenService:Create(shadow, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
            ImageTransparency = 0.4
        }):Play()
        task.wait(0.5)
    end
end)

shadow.Size = main.Size
task.spawn(function()
    while main.Parent and shadow.Parent do
        shadow.Size = UDim2.new(main.Size.X.Scale, main.Size.X.Offset + 120,
                                main.Size.Y.Scale, main.Size.Y.Offset + 120)
        shadow.Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset,
                                    main.Position.Y.Scale, main.Position.Y.Offset + 25)
        RunService.RenderStepped:Wait()
    end
end)

-- ============================================================
-- HEADER
-- ============================================================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 80)
header.BackgroundTransparency = 1
header.ZIndex = 6
header.Parent = main

-- Logo
local logoWrap = Instance.new("Frame")
logoWrap.Size = UDim2.new(0, 56, 0, 56)
logoWrap.Position = UDim2.new(0, 18, 0, 16)
logoWrap.BackgroundColor3 = Color3.fromRGB(12, 8, 22)
logoWrap.BorderSizePixel = 0
logoWrap.ZIndex = 7
logoWrap.Parent = header
Instance.new("UICorner", logoWrap).CornerRadius = UDim.new(1, 0)

local logoStroke = Instance.new("UIStroke", logoWrap)
logoStroke.Thickness = 2
logoStroke.Transparency = 0.2

local logoStrokeGrad = Instance.new("UIGradient", logoStroke)
logoStrokeGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(192, 132, 252)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(236, 72, 153))
}
logoStrokeGrad.Rotation = 45

task.spawn(function()
    while logoStrokeGrad.Parent do
        logoStrokeGrad.Rotation = (logoStrokeGrad.Rotation + 2) % 360
        RunService.RenderStepped:Wait()
    end
end)

local logoImg = Instance.new("ImageLabel")
logoImg.Size = UDim2.new(1, -10, 1, -10)
logoImg.Position = UDim2.new(0.5, 0, 0.5, 0)
logoImg.AnchorPoint = Vector2.new(0.5, 0.5)
logoImg.BackgroundTransparency = 1
logoImg.Image = CROWN_ID
logoImg.ScaleType = Enum.ScaleType.Fit
logoImg.ZIndex = 8
logoImg.Parent = logoWrap

-- pulse
task.spawn(function()
    while logoWrap.Parent do
        TweenService:Create(logoWrap, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 62, 0, 62)
        }):Play()
        task.wait(1.8)
        if not logoWrap.Parent then break end
        TweenService:Create(logoWrap, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 56, 0, 56)
        }):Play()
        task.wait(1.8)
    end
end)

-- Title
local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, -220, 0, 28)
titleLbl.Position = UDim2.new(0, 86, 0, 20)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "AURA KEY SYSTEM"
titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 22
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 8
titleLbl.Parent = header

local titleGrad = Instance.new("UIGradient", titleLbl)
titleGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(192, 132, 252)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(236, 72, 153)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(56, 189, 248))
}

-- Subtitle with version badge
local subLbl = Instance.new("TextLabel")
subLbl.Size = UDim2.new(1, -220, 0, 16)
subLbl.Position = UDim2.new(0, 86, 0, 46)
subLbl.BackgroundTransparency = 1
subLbl.Text = "Premium Edition  •  v2.0  •  by ANON"
subLbl.TextColor3 = Color3.fromRGB(160, 140, 190)
subLbl.Font = Enum.Font.Gotham
subLbl.TextSize = 11
subLbl.TextXAlignment = Enum.TextXAlignment.Left
subLbl.ZIndex = 8
subLbl.Parent = header

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 34, 0, 34)
closeBtn.Position = UDim2.new(1, -50, 0, 20)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 130, 130)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 8
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 10)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(220, 60, 60),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 36, 0, 36)
    }):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(40, 22, 50),
        TextColor3 = Color3.fromRGB(255, 130, 130),
        Size = UDim2.new(0, 34, 0, 34)
    }):Play()
end)

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 34, 0, 34)
minBtn.Position = UDim2.new(1, -90, 0, 20)
minBtn.BackgroundColor3 = Color3.fromRGB(38, 30, 55)
minBtn.Text = "–"
minBtn.TextColor3 = Color3.fromRGB(180, 160, 220)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.AutoButtonColor = false
minBtn.ZIndex = 8
minBtn.Parent = header
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 10)

minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(70, 50, 100),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
end)
minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(38, 30, 55),
        TextColor3 = Color3.fromRGB(180, 160, 220)
    }):Play()
end)

-- separator line
local sep = Instance.new("Frame")
sep.Size = UDim2.new(1, -32, 0, 1)
sep.Position = UDim2.new(0, 16, 0, 80)
sep.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
sep.BackgroundTransparency = 0.6
sep.BorderSizePixel = 0
sep.ZIndex = 6
sep.Parent = main

-- ============================================================
-- HUB TABS
-- ============================================================
local tabWrap = Instance.new("Frame")
tabWrap.Size = UDim2.new(1, -32, 0, 42)
tabWrap.Position = UDim2.new(0, 16, 0, 94)
tabWrap.BackgroundTransparency = 1
tabWrap.ZIndex = 6
tabWrap.Parent = main

local tabLayout = Instance.new("UIListLayout", tabWrap)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 6)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local hubTabs, selectedHub = {}, 1
local keyBox, statusLbl, loadBtn

local function setActiveTab(id)
    for j, btn in pairs(hubTabs) do
        local active = (j == id)
        TweenService:Create(btn, TweenInfo.new(0.25), {
            BackgroundColor3 = active and Color3.fromRGB(139, 92, 246) or Color3.fromRGB(32, 24, 52),
            TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 145, 190)
        }):Play()
        if btn:FindFirstChild("ActiveGlow") then
            btn.ActiveGlow.Visible = active
        end
    end
end

for i, hub in pairs(HUBS) do
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0, 102, 1, 0)
    tab.BackgroundColor3 = Color3.fromRGB(32, 24, 52)
    tab.Text = hub.n
    tab.TextColor3 = Color3.fromRGB(160, 145, 190)
    tab.Font = Enum.Font.GothamBold
    tab.TextSize = 11
    tab.AutoButtonColor = false
    tab.ZIndex = 7
    tab.Parent = tabWrap
    Instance.new("UICorner", tab).CornerRadius = UDim.new(0, 10)

    local tabStroke = Instance.new("UIStroke", tab)
    tabStroke.Color = Color3.fromRGB(139, 92, 246)
    tabStroke.Thickness = 1
    tabStroke.Transparency = 1

    local activeGlow = Instance.new("Frame", tab)
    activeGlow.Name = "ActiveGlow"
    activeGlow.Size = UDim2.new(0.5, 0, 0, 3)
    activeGlow.Position = UDim2.new(0.5, 0, 1, -5)
    activeGlow.AnchorPoint = Vector2.new(0.5, 0)
    activeGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    activeGlow.BorderSizePixel = 0
    activeGlow.Visible = false
    activeGlow.ZIndex = 8
    Instance.new("UICorner", activeGlow).CornerRadius = UDim.new(1, 0)

    hubTabs[i] = tab

    tab.MouseButton1Click:Connect(function()
        selectedHub = i
        setActiveTab(i)
        if statusLbl then
            statusLbl.Text = "Đã chọn: " .. hub.n
            statusLbl.TextColor3 = Color3.fromRGB(160, 145, 190)
        end
    end)
    tab.MouseEnter:Connect(function()
        if selectedHub ~= i then
            TweenService:Create(tab, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(45, 32, 72)
            }):Play()
            TweenService:Create(tabStroke, TweenInfo.new(0.2), {
                Transparency = 0.5
            }):Play()
        end
    end)
    tab.MouseLeave:Connect(function()
        if selectedHub ~= i then
            TweenService:Create(tab, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(32, 24, 52)
            }):Play()
            TweenService:Create(tabStroke, TweenInfo.new(0.2), {
                Transparency = 1
            }):Play()
        end
    end)
end
setActiveTab(1)

-- ============================================================
-- HUB INFO CARD
-- ============================================================
local infoCard = Instance.new("Frame")
infoCard.Size = UDim2.new(1, -32, 0, 58)
infoCard.Position = UDim2.new(0, 16, 0, 148)
infoCard.BackgroundColor3 = Color3.fromRGB(20, 14, 36)
infoCard.BorderSizePixel = 0
infoCard.ZIndex = 6
infoCard.Parent = main
Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 12)

local infoStroke = Instance.new("UIStroke", infoCard)
infoStroke.Color = Color3.fromRGB(139, 92, 246)
infoStroke.Transparency = 0.7

-- status dot
local dot = Instance.new("Frame", infoCard)
dot.Size = UDim2.new(0, 8, 0, 8)
dot.Position = UDim2.new(0, 18, 0.5, -4)
dot.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
dot.BorderSizePixel = 0
dot.ZIndex = 7
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    while dot.Parent do
        TweenService:Create(dot, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {
            BackgroundTransparency = 0.6
        }):Play()
        task.wait(0.8)
        if not dot.Parent then break end
        TweenService:Create(dot, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {
            BackgroundTransparency = 0
        }):Play()
        task.wait(0.8)
    end
end)

local infoLbl = Instance.new("TextLabel", infoCard)
infoLbl.Size = UDim2.new(1, -50, 0, 20)
infoLbl.Position = UDim2.new(0, 36, 0, 8)
infoLbl.BackgroundTransparency = 1
infoLbl.Text = "HỆ THỐNG ĐANG HOẠT ĐỘNG"
infoLbl.TextColor3 = Color3.fromRGB(200, 180, 230)
infoLbl.Font = Enum.Font.GothamBold
infoLbl.TextSize = 11
infoLbl.TextXAlignment = Enum.TextXAlignment.Left
infoLbl.ZIndex = 7

local infoSub = Instance.new("TextLabel", infoCard)
infoSub.Size = UDim2.new(1, -50, 0, 22)
infoSub.Position = UDim2.new(0, 36, 0, 26)
infoSub.BackgroundTransparency = 1
infoSub.Text = "Anti-Bypass V2  •  HWID Locked  •  12H Auto-Reset"
infoSub.TextColor3 = Color3.fromRGB(140, 120, 170)
infoSub.Font = Enum.Font.Gotham
infoSub.TextSize = 10
infoSub.TextXAlignment = Enum.TextXAlignment.Left
infoSub.ZIndex = 7

-- ============================================================
-- KEY INPUT
-- ============================================================
local keyLbl = Instance.new("TextLabel")
keyLbl.Size = UDim2.new(1, -32, 0, 20)
keyLbl.Position = UDim2.new(0, 16, 0, 218)
keyLbl.BackgroundTransparency = 1
keyLbl.Text = "🔑  YOUR KEY"
keyLbl.TextColor3 = Color3.fromRGB(192, 132, 252)
keyLbl.Font = Enum.Font.GothamBold
keyLbl.TextSize = 11
keyLbl.TextXAlignment = Enum.TextXAlignment.Left
keyLbl.ZIndex = 6
keyLbl.Parent = main

keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -32, 0, 48)
keyBox.Position = UDim2.new(0, 16, 0, 240)
keyBox.BackgroundColor3 = Color3.fromRGB(10, 6, 18)
keyBox.BorderSizePixel = 0
keyBox.PlaceholderText = "Dán key từ web vào đây..."
keyBox.PlaceholderColor3 = Color3.fromRGB(110, 90, 140)
keyBox.Text = ""
keyBox.TextColor3 = Color3.fromRGB(56, 189, 248)
keyBox.Font = Enum.Font.Code
keyBox.TextSize = 14
keyBox.ClearTextOnFocus = false
keyBox.TextXAlignment = Enum.TextXAlignment.Left
keyBox.ZIndex = 7
keyBox.Parent = main
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 12)

local keyPad = Instance.new("UIPadding", keyBox)
keyPad.PaddingLeft = UDim.new(0, 14)
keyPad.PaddingRight = UDim.new(0, 14)

local keyStroke = Instance.new("UIStroke", keyBox)
keyStroke.Color = Color3.fromRGB(139, 92, 246)
keyStroke.Transparency = 0.5

keyBox.Focused:Connect(function()
    TweenService:Create(keyStroke, TweenInfo.new(0.2), {
        Transparency = 0, Thickness = 1.5
    }):Play()
end)
keyBox.FocusLost:Connect(function()
    TweenService:Create(keyStroke, TweenInfo.new(0.2), {
        Transparency = 0.5, Thickness = 1
    }):Play()
end)

statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -32, 0, 20)
statusLbl.Position = UDim2.new(0, 16, 0, 294)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "Chưa chọn hub"
statusLbl.TextColor3 = Color3.fromRGB(160, 145, 190)
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 11
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.ZIndex = 6
statusLbl.Parent = main

-- ============================================================
-- BUTTON FACTORY
-- ============================================================
local function makeButton(text, y, height, c1, c2, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -32, 0, height)
    btn.Position = UDim2.new(0, 16, 0, y)
    btn.BackgroundColor3 = c1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 7
    btn.Parent = main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    local bg = Instance.new("UIGradient", btn)
    bg.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(1, c2)
    }
    bg.Rotation = 45

    local glowStroke = Instance.new("UIStroke", btn)
    glowStroke.Color = c2
    glowStroke.Thickness = 1
    glowStroke.Transparency = 0.6

    local label = Instance.new("TextLabel", btn)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.ZIndex = 8

    -- ripple effect on click
    btn.MouseButton1Down:Connect(function()
        local r = Instance.new("Frame", btn)
        r.AnchorPoint = Vector2.new(0.5, 0.5)
        r.Size = UDim2.new(0, 0, 0, 0)
        r.Position = UDim2.new(0.5, 0, 0.5, 0)
        r.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        r.BackgroundTransparency = 0.6
        r.BorderSizePixel = 0
        r.ZIndex = 6
        Instance.new("UICorner", r).CornerRadius = UDim.new(1, 0)
        TweenService:Create(r, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(2, 0, 2, 0),
            BackgroundTransparency = 1
        }):Play()
        task.delay(0.6, function() r:Destroy() end)
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            Size = UDim2.new(1, -28, 0, height + 2),
            Position = UDim2.new(0, 14, 0, y - 1)
        }):Play()
        TweenService:Create(glowStroke, TweenInfo.new(0.2), {
            Transparency = 0.2, Thickness = 1.8
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            Size = UDim2.new(1, -32, 0, height),
            Position = UDim2.new(0, 16, 0, y)
        }):Play()
        TweenService:Create(glowStroke, TweenInfo.new(0.2), {
            Transparency = 0.6, Thickness = 1
        }):Play()
    end)

    return btn, label
end

local webBtn = makeButton("🌐   GET KEY FROM WEB", 320, 48,
    Color3.fromRGB(139, 92, 246), Color3.fromRGB(236, 72, 153))

local checkBtn = makeButton("✅   CHECK KEY", 374, 52,
    Color3.fromRGB(34, 197, 94), Color3.fromRGB(16, 150, 70))

loadBtn, _ = makeButton("▶   LOAD SCRIPT", 432, 48,
    Color3.fromRGB(236, 72, 153), Color3.fromRGB(249, 115, 22))
loadBtn.Visible = false

-- ============================================================
-- FOOTER
-- ============================================================
local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, -32, 0, 40)
footer.Position = UDim2.new(0, 16, 1, -52)
footer.BackgroundTransparency = 1
footer.ZIndex = 6
footer.Parent = main

local footerLine = Instance.new("Frame", footer)
footerLine.Size = UDim2.new(1, 0, 0, 1)
footerLine.Position = UDim2.new(0, 0, 0, 0)
footerLine.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
footerLine.BackgroundTransparency = 0.6
footerLine.BorderSizePixel = 0
footerLine.ZIndex = 7

local function makeSocial(text, posX, url)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 130, 0, 30)
    btn.Position = UDim2.new(0, posX, 0, 5)
    btn.BackgroundColor3 = Color3.fromRGB(28, 20, 46)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(180, 160, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.AutoButtonColor = false
    btn.ZIndex = 7
    btn.Parent = footer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(45, 32, 72),
            TextColor3 = Color3.fromRGB(220, 200, 250)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(28, 20, 46),
            TextColor3 = Color3.fromRGB(180, 160, 220)
        }):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then setclipboard(url) end
        end)
    end)
    return btn
end

local social1 = makeSocial("💬  Discord", 0, DISCORD_URL)
local social2 = makeSocial("✈️  Telegram", 138, TELEGRAM_URL)

-- ============================================================
-- TOAST NOTIFICATION SYSTEM
-- ============================================================
local toastStack = {}
local toastOffset = 0

local function pushToast(title, content, color)
    local popup = Instance.new("Frame")
    popup.Size = UDim2.new(0, 340, 0, 0)
    popup.Position = UDim2.new(0.5, -170, 0, 20 + toastOffset)
    popup.BackgroundColor3 = Color3.fromRGB(24, 16, 40)
    popup.BorderSizePixel = 0
    popup.ZIndex = 100 + #toastStack
    popup.Parent = gui
    Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 14)

    local ps = Instance.new("UIStroke", popup)
    ps.Color = color or Color3.fromRGB(192, 132, 252)
    ps.Thickness = 1.5

    local accent = Instance.new("Frame", popup)
    accent.Size = UDim2.new(0, 4, 0.9, 0)
    accent.Position = UDim2.new(0, 0, 0.05, 0)
    accent.BackgroundColor3 = color or Color3.fromRGB(192, 132, 252)
    accent.BorderSizePixel = 0
    accent.ZIndex = 101
    Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 4)

    local tt = Instance.new("TextLabel", popup)
    tt.Size = UDim2.new(1, -30, 0, 22)
    tt.Position = UDim2.new(0, 16, 0, 10)
    tt.BackgroundTransparency = 1
    tt.Text = title
    tt.TextColor3 = color or Color3.fromRGB(192, 132, 252)
    tt.Font = Enum.Font.GothamBold
    tt.TextSize = 13
    tt.TextXAlignment = Enum.TextXAlignment.Left
    tt.ZIndex = 101

    local ct = Instance.new("TextLabel", popup)
    ct.Size = UDim2.new(1, -30, 0, 60)
    ct.Position = UDim2.new(0, 16, 0, 36)
    ct.BackgroundTransparency = 1
    ct.Text = content
    ct.TextColor3 = Color3.fromRGB(220, 210, 235)
    ct.Font = Enum.Font.Gotham
    ct.TextSize = 11
    ct.TextWrapped = true
    ct.TextXAlignment = Enum.TextXAlignment.Left
    ct.TextYAlignment = Enum.TextYAlignment.Top
    ct.ZIndex = 101

    table.insert(toastStack, popup)
    toastOffset = toastOffset + 105

    TweenService:Create(popup, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 340, 0, 100)
    }):Play()

    task.delay(4, function()
        if popup.Parent then
            TweenService:Create(popup, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 340, 0, 0),
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.3)
            for i, p in ipairs(toastStack) do
                if p == popup then
                    table.remove(toastStack, i)
                    break
                end
            end
            toastOffset = math.max(0, toastOffset - 105)
            popup:Destroy()
        end
    end)
end

-- ============================================================
-- UNLOCK HUB
-- ============================================================
local function unlockHub(id)
    loadBtn.Visible = true
    local _, lbl = nil, nil
    for _, child in pairs(loadBtn:GetChildren()) do
        if child:IsA("TextLabel") then lbl = child end
    end
    if lbl then lbl.Text = "▶   LOAD " .. HUBS[id].n end
    statusLbl.Text = "✅ " .. HUBS[id].n .. " — UNLOCKED"
    statusLbl.TextColor3 = Color3.fromRGB(52, 211, 153)
end

-- ============================================================
-- AUTO LOAD SAVED KEY
-- ============================================================
task.spawn(function()
    task.wait(0.8)
    local saved = loadSaved()
    if saved and saved.k and saved.h then
        local hub = HUBS[saved.h]
        if hub and validKey(saved.k, hub.s) then
            selectedHub = saved.h
            setActiveTab(saved.h)
            keyBox.Text = saved.k
            unlockHub(saved.h)
            pushToast("🔓 KEY RESTORED", "Tự động mở khoá " .. hub.n, Color3.fromRGB(52, 211, 153))
        else
            delSaved()
        end
    end
end)

-- ============================================================
-- BUTTON ACTIONS
-- ============================================================
webBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard(WEB_URL) end
    end)
    pushToast("🌐 LINK ĐÃ COPY", WEB_URL, Color3.fromRGB(56, 189, 248))
    statusLbl.Text = "📋 Đã copy link web"
    statusLbl.TextColor3 = Color3.fromRGB(160, 145, 190)
end)

checkBtn.MouseButton1Click:Connect(function()
    local raw = cleanKey(keyBox.Text or "")
    if raw == "" then
        pushToast("❌ CHƯA CÓ KEY", "Dán key vào ô phía trên trước.", Color3.fromRGB(248, 113, 113))
        return
    end
    local hub = HUBS[selectedHub]
    if validKey(raw, hub.s) then
        saveKey(selectedHub, raw)
        pushToast("✅ KEY HỢP LỆ", "Đã mở khoá " .. hub.n .. "\nKey được lưu tự động.", Color3.fromRGB(52, 211, 153))
        unlockHub(selectedHub)
    else
        pushToast("❌ KEY SAI", "Key không đúng hoặc đã hết hạn 12h.", Color3.fromRGB(248, 113, 113))
        statusLbl.Text = "❌ Key không hợp lệ"
        statusLbl.TextColor3 = Color3.fromRGB(248, 113, 113)
    end
end)

loadBtn.MouseButton1Click:Connect(function()
    local hub = HUBS[selectedHub]
    pushToast("⏳ ĐANG TẢI", hub.n .. "...", Color3.fromRGB(236, 72, 153))
    local ok, err = pcall(function()
        local src = game:HttpGet(hub.u)
        local fn = loadstring(src)
        if not fn then error("loadstring failed") end
        fn()
    end)
    if not ok then
        pushToast("❌ LỖI LOAD", tostring(err), Color3.fromRGB(248, 113, 113))
    end
end)

-- ============================================================
-- MINIMIZE / RESTORE
-- ============================================================
local restoreBtn = Instance.new("ImageButton")
restoreBtn.Size = UDim2.new(0, 64, 0, 64)
restoreBtn.Position = UDim2.new(0, 20, 0, 120)
restoreBtn.BackgroundColor3 = Color3.fromRGB(16, 12, 28)
restoreBtn.Image = CROWN_ID
restoreBtn.ScaleType = Enum.ScaleType.Fit
restoreBtn.Visible = false
restoreBtn.ZIndex = 20
restoreBtn.Parent = gui
Instance.new("UICorner", restoreBtn).CornerRadius = UDim.new(1, 0)

local rstStroke = Instance.new("UIStroke", restoreBtn)
rstStroke.Thickness = 2
rstStroke.Transparency = 0.15

local rstStrokeGrad = Instance.new("UIGradient", rstStroke)
rstStrokeGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(192, 132, 252)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(236, 72, 153))
}
rstStrokeGrad.Rotation = 45

task.spawn(function()
    while rstStrokeGrad.Parent do
        rstStrokeGrad.Rotation = (rstStrokeGrad.Rotation + 2) % 360
        RunService.RenderStepped:Wait()
    end
end)

local rstPad = Instance.new("UIPadding", restoreBtn)
rstPad.PaddingTop = UDim.new(0, 8)
rstPad.PaddingBottom = UDim.new(0, 8)
rstPad.PaddingLeft = UDim.new(0, 8)
rstPad.PaddingRight = UDim.new(0, 8)

task.spawn(function()
    while restoreBtn.Parent do
        TweenService:Create(restoreBtn, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 70, 0, 70)
        }):Play()
        task.wait(1.5)
        if not restoreBtn.Parent then break end
        TweenService:Create(restoreBtn, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 64, 0, 64)
        }):Play()
        task.wait(1.5)
    end
end)

local function minimize()
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.3)
    main.Visible = false
    restoreBtn.Visible = true
end

local function restore()
    main.Visible = true
    TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 480, 0, 600)
    }):Play()
    task.wait(0.4)
    restoreBtn.Visible = false
end

closeBtn.MouseButton1Click:Connect(minimize)
minBtn.MouseButton1Click:Connect(minimize)
restoreBtn.MouseButton1Click:Connect(restore)

-- ============================================================
-- DRAG
-- ============================================================
local dragging, dragStart, startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
       or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
       or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ============================================================
-- WELCOME
-- ============================================================
task.wait(0.6)
pushToast("👑 AURA KEY SYSTEM", "Chào mừng trở lại!\nChọn hub → GET KEY → vượt link → CHECK.", Color3.fromRGB(192, 132, 252))
