-- language: Lua, file: AuraKeyUI.lua
-- Executor: Delta / Fluxus / Codex / Arceus X / Solara / Wave
-- All-in-one: Get Key from web + Check Key (offline timestamp) + Load Script

--[[ ============================================================
     CẤU HÌNH — 4 HUB
     ============================================================ ]]
local WEB_URL = "https://brdoly.github.io/Brdoly/AURA_KEY.html"   -- <-- ĐỔI LINK WEB CỦA MÀY

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
        loadstring_url = "http://vxezestudio.online/api/scripts/script_G5CGjqj2X3rOS/strem/init"
    },
    [4] = {
        name    = "JUALNASI",
        secret  = "4a1f8c5e2b9d6f3a7c0e4b8d1f5a2c9e6b3d7f4a1c8e5b2d9f6a3c7e4b1d8f5a",
        loadstring_url = "https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua"
    }
}

--[[ ============================================================
     LOAD RAYFIELD
     ============================================================ ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "AURA KEY SYSTEM",
    LoadingTitle = "Aura Hub",
    LoadingSubtitle = "by ANON",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

local MainTab   = Window:CreateTab("🔑 Get Key", 4483362458)
local ScriptTab = Window:CreateTab("📜 Scripts", 4483362458)

--[[ ============================================================
     STATE
     ============================================================ ]]
local selectedHub    = 1
local unlockedHubs   = {}
local createdButtons = {}

--[[ ============================================================
     HASH DJB2 — PHẢI GIỐNG HÀM TRONG WEB
     ============================================================ ]]
local function djb2(s, seed)
    local h = seed
    for i = 1, #s do
        h = (h * 33 + string.byte(s, i)) % 4294967296
    end
    return h
end

local function hash8(str)
    local a = djb2(str .. "|a", 5381)
    local b = djb2(str .. "|b", 5381)
    local hex = string.format("%08x%08x", a, b)
    return hex:sub(1, 8):upper()
end

--[[ ============================================================
     CHECK KEY
     Format: AURA-KEY-{timestamp_base36}-{hash8}
     ============================================================ ]]
local function isValidKey(key, hubSecret)
    if type(key) ~= "string" then return false, "Key rỗng" end
    key = key:gsub("%s+", ""):upper()

    local parts = {}
    for p in key:gmatch("[^%-]+") do table.insert(parts, p) end

    if #parts ~= 4 then return false, "Key sai định dạng" end
    if parts[1] ~= "AURA" or parts[2] ~= "KEY" then return false, "Prefix sai" end

    local ts36  = parts[3]
    local hash8Str = parts[4]

    local ts = tonumber(ts36, 36)
    if not ts then return false, "Timestamp sai" end

    local nowSec = os.time()
    local age = nowSec - ts
    if age < 0 then return false, "Key không hợp lệ" end
    if age > 12 * 60 * 60 then return false, "Key đã hết hạn 12h" end

    local expected = hash8(hubSecret .. "|" .. ts36)
    if hash8Str ~= expected then
        return false, "Key không hợp lệ (hash sai)"
    end

    return true, "OK"
end

--[[ ============================================================
     UI — TAB GET KEY
     ============================================================ ]]
local hubNames = {}
for i, h in pairs(HUBS) do hubNames[i] = h.name end

local hubDropdown = MainTab:CreateDropdown({
    Name = "Chọn Hub",
    Options = hubNames,
    CurrentOption = { hubNames[1] },
    Flag = "SelectedHub",
    Callback = function(option)
        local picked = type(option) == "table" and option[1] or option
        for i, h in pairs(HUBS) do
            if h.name == picked then selectedHub = i break end
        end
        if statusLabel then statusLabel:Set("Đã chọn: " .. picked) end
    end
})

local keyInput = MainTab:CreateInput({
    Name = "Nhập Key",
    PlaceholderText = "AURA-KEY-XXXXXXX-XXXXXXXX",
    RemoveTextAfterFocusLost = false,
    Flag = "InputKey"
})

local statusLabel = MainTab:CreateLabel("Chưa chọn hub")

MainTab:CreateButton({
    Name = "🌐 GET KEY TỪ WEB",
    Callback = function()
        if setclipboard then setclipboard(WEB_URL) end
        Rayfield:Notify({
            Title = "🌐 MỞ WEB LẤY KEY",
            Content = "Đã copy link web:\n" .. WEB_URL .. "\n\nMở browser → dán → vượt link4m → copy key → quay lại dán.",
            Duration = 12
        })
        statusLabel:Set("📋 Đã copy link web")
    end
})

MainTab:CreateButton({
    Name = "✅ CHECK KEY",
    Callback = function()
        local rawKey = keyInput and keyInput.Value or ""
        rawKey = rawKey:gsub("%s+", ""):upper()

        local hub = HUBS[selectedHub]
        local ok, err = isValidKey(rawKey, hub.secret)

        if not ok then
            Rayfield:Notify({ Title = "❌ KEY SAI", Content = err, Duration = 6 })
            statusLabel:Set("❌ " .. err)
            return
        end

        unlockedHubs[selectedHub] = true
        Rayfield:Notify({
            Title = "✅ KEY HỢP LỆ",
            Content = "Đã mở khoá " .. hub.name .. "!",
            Duration = 5
        })
        statusLabel:Set("✅ " .. hub.name .. " — đã mở khoá")

        if not createdButtons[selectedHub] then
            createdButtons[selectedHub] = true
            ScriptTab:CreateButton({
                Name = "▶ Load " .. hub.name,
                Callback = function()
                    Rayfield:Notify({ Title = "⏳ Đang tải", Content = hub.name .. "...", Duration = 3 })
                    local success, e = pcall(function()
                        local src = game:HttpGet(hub.loadstring_url)
                        local fn = loadstring(src)
                        if not fn then error("loadstring failed") end
                        fn()
                    end)
                    if not success then
                        Rayfield:Notify({ Title = "❌ Lỗi", Content = tostring(e), Duration = 6 })
                    end
                end
            })
        end
    end
})

ScriptTab:CreateLabel("⚠️ Nhập key ở tab Get Key trước để mở khoá script.")
