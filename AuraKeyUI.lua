-- language: Lua, file: AuraKeyUI.lua
-- UI thuần Roblox — không dùng lib ngoài
-- Executor: Delta / Fluxus / Codex / Arceus X / Solara / Wave

local WEB_URL = "https://brdoly.github.io/Brdoly/AURA_KEY.html"

local HUBS = {
    [1] = {
        name    = "VOIDSHELL",
        secret  = "7f3a9c2e8b5d1a4f6e0c9b2d8a7f3e1c5b4d9a2f8e6c1b3d7a5f9e2c4b8d6a1f",
        loadstring_url = "https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/StealAnEgg.luau"
    },
    [2] = {
        name    = "WHITEX",
        secret  = "2b8d4f1a6c9e3b7d5a0f2c8e4b9d1f6a3c7e5b2d8f4a9c1e6b3d7a5f2c8e4b9d",
        loadstring_url = "https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/StealEggOnly.luau"
    },
    [3] = {
        name    = "VZSTUDIO",
        secret  = "9e5c2a7f4b1d8e6c3a0f9b5d2e7c4a1f8b6d3e9c5a2f7b4d1e8c6a3f9b5d2e7c",
        loadstring_url = "https://vxezestudio.online/api/scripts/script_G5CGjqj2X3rOS/strem/init"
    },
    [4] = {
        name    = "JUALNASI",
        secret  = "4a1f8c5e2b9d6f3a7c0e4b8d1f5a2c9e6b3d7f4a1c8e5b2d9f6a3c7e4b1d8f5a",
        loadstring_url = "https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua"
    }
}

-- ============================================================
-- CHECK KEY
-- Format: AURA-KEY-{timestamp_base36}-{secret_slice_8}
-- ============================================================
local function cleanKey(str)
    if type(str) ~= "string" then return "" end
    return str:gsub("%s+", ""):gsub("[^A-Za-z0-9%-]", ""):upper()
end

local function isValidKey(key, hubSecret)
    if type(key) ~= "string" then return false, "Key rỗng" end
    key = cleanKey(key)

    local parts = {}
    for p in key:gmatch("[^%-]+") do table.insert(parts, p) end

    if #parts ~= 4 then
        return false, "Key sai định dạng (" .. #parts .. " phần)\nKey: " .. key
    end
    if parts[1] ~= "AURA" or parts[2] ~= "KEY" then
        return false, "Prefix sai\nKey: " .. key
    end

    local ts36       = parts[3]
    local secretPart = parts[4]

    local ts = tonumber(ts36, 36)
    if not ts then return false, "Timestamp sai: " .. ts36 end

    local age = os.time() - ts
    if age < 0 then return false, "Key không hợp lệ (tương lai)" end
    if age > 12 * 60 * 60 then
        return false, "Key đã hết hạn 12h\nTuổi: " .. math.floor(age/60) .. " phút"
    end

    local expected = hubSecret:sub(1, 8):upper()
    if secretPart ~= expected then
        return false, "Key không hợp lệ\nBạn: " .. secretPart .. "\nCần: " .. expected
    end

    return true, "OK"
end

-- ============================================================
-- UI
-- ============================================================
local Players = game:GetService("Players")
local player = Players.LocalPlayer

if player:FindFirstChild("AuraKeyGui") then
    player.AuraKeyGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "AuraKeyGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 420, 0, 420)
main.Position = UDim2.new(0.5, -210, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(24, 20, 38)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(139, 92, 246)
stroke.Thickness = 1.5
stroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 8)
title.BackgroundTransparency = 1
title.Text = "AURA KEY SYSTEM"
title.TextColor3 = Color3.fromRGB(192, 132, 252)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = main

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = main
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

closeBtn.MouseButton1Click:Connect(function()
    gui.Enabled = false
    if not gui:FindFirstChild("ReopenBtn") then
        local reopen = Instance.new("TextButton")
        reopen.Name = "ReopenBtn"
        reopen.Size = UDim2.new(0, 60, 0, 60)
        reopen.Position = UDim2.new(0, 20, 0, 100)
        reopen.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
        reopen.Text = "🔑"
        reopen.TextSize = 28
        reopen.Font = Enum.Font.GothamBold
        reopen.Parent = gui
        Instance.new("UICorner", reopen).CornerRadius = UDim.new(1, 0)
        reopen.MouseButton1Click:Connect(function()
            gui.Enabled = true
            reopen:Destroy()
        end)
    end
end)

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -40, 0, 40)
tabFrame.Position = UDim2.new(0, 20, 0, 55)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = main

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = tabFrame

local hubTabs = {}
local selectedHub = 1

for i, hub in pairs(HUBS) do
    local t = Instance.new("TextButton")
    t.Size = UDim2.new(0, 88, 1, 0)
    t.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
    t.Text = hub.name
    t.TextColor3 = Color3.fromRGB(184, 168, 216)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 11
    t.Parent = tabFrame
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 8)

    hubTabs[i] = t

    t.MouseButton1Click:Connect(function()
        selectedHub = i
        for j, btn in pairs(hubTabs) do
            if j == i then
                btn.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                btn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
                btn.TextColor3 = Color3.fromRGB(184, 168, 216)
            end
        end
        statusLabel.Text = "Đã chọn: " .. hub.name
    end)
end

hubTabs[1].BackgroundColor3 = Color3.fromRGB(139, 92, 246)
hubTabs[1].TextColor3 = Color3.fromRGB(255, 255, 255)

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -40, 0, 40)
keyBox.Position = UDim2.new(0, 20, 0, 110)
keyBox.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
keyBox.BorderSizePixel = 0
keyBox.PlaceholderText = "Dán key vào đây"
keyBox.PlaceholderColor3 = Color3.fromRGB(120, 100, 150)
keyBox.Text = ""
keyBox.TextColor3 = Color3.fromRGB(56, 189, 248)
keyBox.Font = Enum.Font.Code
keyBox.TextSize = 13
keyBox.ClearTextOnFocus = false
keyBox.TextXAlignment = Enum.TextXAlignment.Left
keyBox.Parent = main
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 8)

local kStroke = Instance.new("UIStroke")
kStroke.Color = Color3.fromRGB(139, 92, 246)
kStroke.Transparency = 0.6
kStroke.Parent = keyBox

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 24)
statusLabel.Position = UDim2.new(0, 20, 0, 158)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Chưa chọn hub"
statusLabel.TextColor3 = Color3.fromRGB(200, 180, 220)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = main

local btnWeb = Instance.new("TextButton")
btnWeb.Size = UDim2.new(1, -40, 0, 40)
btnWeb.Position = UDim2.new(0, 20, 0, 192)
btnWeb.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
btnWeb.Text = "🌐  GET KEY TỪ WEB"
btnWeb.TextColor3 = Color3.fromRGB(255, 255, 255)
btnWeb.Font = Enum.Font.GothamBold
btnWeb.TextSize = 14
btnWeb.Parent = main
Instance.new("UICorner", btnWeb).CornerRadius = UDim.new(0, 10)

local btnDebug = Instance.new("TextButton")
btnDebug.Size = UDim2.new(1, -40, 0, 36)
btnDebug.Position = UDim2.new(0, 20, 0, 240)
btnDebug.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
btnDebug.Text = "🔍  XEM KEY ĐÃ NHẬP"
btnDebug.TextColor3 = Color3.fromRGB(184, 168, 216)
btnDebug.Font = Enum.Font.Gotham
btnDebug.TextSize = 12
btnDebug.Parent = main
Instance.new("UICorner", btnDebug).CornerRadius = UDim.new(0, 8)

local btnCheck = Instance.new("TextButton")
btnCheck.Size = UDim2.new(1, -40, 0, 46)
btnCheck.Position = UDim2.new(0, 20, 0, 286)
btnCheck.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
btnCheck.Text = "✅  CHECK KEY"
btnCheck.TextColor3 = Color3.fromRGB(255, 255, 255)
btnCheck.Font = Enum.Font.GothamBold
btnCheck.TextSize = 15
btnCheck.Parent = main
Instance.new("UICorner", btnCheck).CornerRadius = UDim.new(0, 10)

local btnLoad = Instance.new("TextButton")
btnLoad.Size = UDim2.new(1, -40, 0, 40)
btnLoad.Position = UDim2.new(0, 20, 0, 340)
btnLoad.BackgroundColor3 = Color3.fromRGB(236, 72, 153)
btnLoad.Text = "▶  LOAD SCRIPT"
btnLoad.TextColor3 = Color3.fromRGB(255, 255, 255)
btnLoad.Font = Enum.Font.GothamBold
btnLoad.TextSize = 14
btnLoad.Visible = false
btnLoad.Parent = main
Instance.new("UICorner", btnLoad).CornerRadius = UDim.new(0, 10)

local function notify(titleText, contentText)
    local popup = Instance.new("Frame")
    popup.Size = UDim2.new(0, 340, 0, 100)
    popup.Position = UDim2.new(0.5, -170, 0, 30)
    popup.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
    popup.BorderSizePixel = 0
    popup.Parent = gui
    Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 12)

    local ps = Instance.new("UIStroke", popup)
    ps.Color = Color3.fromRGB(139, 92, 246)
    ps.Thickness = 1.5

    local tt = Instance.new("TextLabel")
    tt.Size = UDim2.new(1, -20, 0, 26)
    tt.Position = UDim2.new(0, 10, 0, 8)
    tt.BackgroundTransparency = 1
    tt.Text = titleText
    tt.TextColor3 = Color3.fromRGB(192, 132, 252)
    tt.Font = Enum.Font.GothamBold
    tt.TextSize = 14
    tt.TextXAlignment = Enum.TextXAlignment.Left
    tt.Parent = popup

    local ct = Instance.new("TextLabel")
    ct.Size = UDim2.new(1, -20, 0, 58)
    ct.Position = UDim2.new(0, 10, 0, 34)
    ct.BackgroundTransparency = 1
    ct.Text = contentText
    ct.TextColor3 = Color3.fromRGB(230, 220, 240)
    ct.Font = Enum.Font.Gotham
    ct.TextSize = 12
    ct.TextWrapped = true
    ct.TextXAlignment = Enum.TextXAlignment.Left
    ct.TextYAlignment = Enum.TextYAlignment.Top
    ct.Parent = popup

    task.spawn(function()
        task.wait(5)
        popup:Destroy()
    end)
end

btnWeb.MouseButton1Click:Connect(function()
    local ok = pcall(function()
        if setclipboard then setclipboard(WEB_URL) end
    end)
    if ok and setclipboard then
        notify("🌐 ĐÃ COPY LINK WEB", WEB_URL .. "\n\nMở browser → dán → vượt link4m → copy key → quay lại dán vào ô.")
    else
        notify("🌐 MỞ WEB LẤY KEY", "Mở browser vào:\n" .. WEB_URL)
    end
    statusLabel.Text = "📋 Đã copy link web"
end)

btnDebug.MouseButton1Click:Connect(function()
    local raw = cleanKey(keyBox.Text or "")
    notify("🔍 KEY ĐỌC ĐƯỢC", "Độ dài: " .. #raw .. " ký tự\nKey: " .. raw)
end)

btnCheck.MouseButton1Click:Connect(function()
    local rawKey = cleanKey(keyBox.Text or "")
    if rawKey == "" then
        notify("❌ CHƯA CÓ KEY", "Bấm vào ô nhập key, dán key vào, rồi bấm CHECK lại.")
        return
    end

    local hub = HUBS[selectedHub]
    local ok, err = isValidKey(rawKey, hub.secret)

    if not ok then
        notify("❌ KEY SAI", err)
        statusLabel.Text = "❌ " .. err:gsub("\n", " | ")
        return
    end

    notify("✅ KEY HỢP LỆ", "Đã mở khoá " .. hub.name .. "!\nBấm nút LOAD SCRIPT phía dưới.")
    statusLabel.Text = "✅ " .. hub.name .. " — đã mở khoá"

    btnLoad.Visible = true
    btnLoad.Text = "▶  LOAD " .. hub.name
end)

btnLoad.MouseButton1Click:Connect(function()
    local hub = HUBS[selectedHub]
    notify("⏳ ĐANG TẢI", hub.name .. "...")
    local ok, err = pcall(function()
        local src = game:HttpGet(hub.loadstring_url)
        local fn = loadstring(src)
        if not fn then error("loadstring failed") end
        fn()
    end)
    if not ok then
        notify("❌ LỖI LOAD", tostring(err))
    end
end)

local dragging, dragStart, startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

title.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

notify("✅ AURA KEY LOADED", "Chọn hub → bấm GET KEY TỪ WEB → vượt link4m → dán key → CHECK KEY.")
