-- language: Lua, file: AuraKeyUI.lua
-- Obfuscated để tránh detect

local a = "https://brdoly.github.io/Brdoly/AURA_KEY.html"
local s = "aura_save.dat"
local CROWN_URL = "https://files.catbox.moe/cfdgvm.jpg"
local CROWN_FALLBACK = "rbxassetid://10709799087"

local H = {
    [1] = {n="VOIDSHELL", s="7f3a9c2e8b5d1a4f6e0c9b2d8a7f3e1c5b4d9a2f8e6c1b3d7a5f9e2c4b8d6a1f",
        u="https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/StealAnEgg.luau"},
    [2] = {n="WHITEX", s="2b8d4f1a6c9e3b7d5a0f2c8e4b9d1f6a3c7e5b2d8f4a9c1e6b3d7a5f2c8e4b9d",
        u="https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/StealEggOnly.luau"},
    [3] = {n="VZSTUDIO", s="9e5c2a7f4b1d8e6c3a0f9b5d2e7c4a1f8b6d3e9c5a2f7b4d1e8c6a3f9b5d2e7c",
        u="https://vxezestudio.online/api/scripts/script_G5CGjqj2X3rOS/strem/init"},
    [4] = {n="JUALNASI", s="4a1f8c5e2b9d6f3a7c0e4b8d1f5a2c9e6b3d7f4a1c8e5b2d9f6a3c7e4b1d8f5a",
        u="https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua"}
}

-- ============================================================
-- TẢI ẢNH VƯƠNG MIỆN
-- ============================================================
local function getCrownId()
    if CROWN_URL ~= "" then
        local ok, id = pcall(function()
            local fname = "aura_crown_tmp.jpg"
            writefile(fname, game:HttpGet(CROWN_URL))
            return getcustomasset(fname)
        end)
        if ok and id then return id end
    end
    return CROWN_FALLBACK
end
local CROWN_ID = getCrownId()

-- ============================================================
-- CHECK KEY
-- ============================================================
local function ck(k)
    if type(k)~="string" then return "" end
    return k:gsub("%s+",""):gsub("[^A-Za-z0-9%-]",""):upper()
end

local function vk(k, s)
    if type(k)~="string" then return false end
    k = ck(k)
    local p = {}
    for x in k:gmatch("[^%-]+") do table.insert(p, x) end
    if #p ~= 4 then return false end
    if p[1]~="AURA" or p[2]~="KEY" then return false end
    local t = tonumber(p[3], 36)
    if not t then return false end
    local ag = os.time() - t
    if ag < 0 or ag > 43200 then return false end
    if p[4] ~= s:sub(1,8):upper() then return false end
    return true
end

local function sk(h, k)
    pcall(function()
        if writefile then
            writefile(s, game:GetService("HttpService"):JSONEncode({h=h,k=k}))
        end
    end)
end

local function lk()
    local ok, c = pcall(function()
        if isfile and isfile(s) then return readfile(s) end
    end)
    if not ok or not c then return nil end
    local ok2, d = pcall(function()
        return game:GetService("HttpService"):JSONDecode(c)
    end)
    return ok2 and d or nil
end

local function dk()
    pcall(function()
        if delfile and isfile and isfile(s) then delfile(s) end
    end)
end

-- ============================================================
-- UI
-- ============================================================
local P = game:GetService("Players").LocalPlayer
if P:FindFirstChild("AKG") then P.AKG:Destroy() end

local g = Instance.new("ScreenGui")
g.Name = "AKG"
g.ResetOnSpawn = false
g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
g.Parent = P:WaitForChild("PlayerGui")

local m = Instance.new("Frame")
m.Size = UDim2.new(0,440,0,500)
m.Position = UDim2.new(0.5,-220,0.5,-250)
m.BackgroundColor3 = Color3.fromRGB(22,16,38)
m.BorderSizePixel = 0
m.Parent = g
Instance.new("UICorner", m).CornerRadius = UDim.new(0,18)

local st = Instance.new("UIStroke", m)
st.Color = Color3.fromRGB(139,92,246)
st.Thickness = 1.5
st.Transparency = 0.4

-- Logo vương miện trên header
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0,44,0,44)
logo.Position = UDim2.new(0,16,0,12)
logo.BackgroundColor3 = Color3.fromRGB(15,10,25)
logo.BorderSizePixel = 0
logo.Image = CROWN_ID
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = m
Instance.new("UICorner", logo).CornerRadius = UDim.new(1, 0)

local logoStroke = Instance.new("UIStroke", logo)
logoStroke.Color = Color3.fromRGB(255,255,255)
logoStroke.Thickness = 1.5
logoStroke.Transparency = 0.3

local logoPad = Instance.new("UIPadding", logo)
logoPad.PaddingTop = UDim.new(0, 6)
logoPad.PaddingBottom = UDim.new(0, 6)
logoPad.PaddingLeft = UDim.new(0, 6)
logoPad.PaddingRight = UDim.new(0, 6)

-- Title
local ti = Instance.new("TextLabel")
ti.Size = UDim2.new(1,-100,0,26)
ti.Position = UDim2.new(0,70,0,14)
ti.BackgroundTransparency = 1
ti.Text = "AURA KEY"
ti.TextColor3 = Color3.fromRGB(192,132,252)
ti.Font = Enum.Font.GothamBlack
ti.TextSize = 18
ti.TextXAlignment = Enum.TextXAlignment.Left
ti.Parent = m

local tiGrad = Instance.new("UIGradient", ti)
tiGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(192,132,252)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(236,72,153)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(56,189,248))
}

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1,-100,0,16)
sub.Position = UDim2.new(0,70,0,38)
sub.BackgroundTransparency = 1
sub.Text = "Premium Edition"
sub.TextColor3 = Color3.fromRGB(150,130,180)
sub.Font = Enum.Font.Gotham
sub.TextSize = 10
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.Parent = m

-- Close button
local xb = Instance.new("TextButton")
xb.Size = UDim2.new(0,32,0,32)
xb.Position = UDim2.new(1,-44,0,16)
xb.BackgroundColor3 = Color3.fromRGB(50,25,60)
xb.Text = "×"
xb.TextColor3 = Color3.fromRGB(255,120,120)
xb.Font = Enum.Font.GothamBold
xb.TextSize = 20
xb.Parent = m
Instance.new("UICorner", xb).CornerRadius = UDim.new(0,8)

-- Nút mở lại — ảnh vương miện tròn
local op = Instance.new("ImageButton")
op.Size = UDim2.new(0,64,0,64)
op.Position = UDim2.new(0,20,0,120)
op.BackgroundColor3 = Color3.fromRGB(15,10,25)
op.Image = CROWN_ID
op.ScaleType = Enum.ScaleType.Fit
op.Visible = false
op.Parent = g
Instance.new("UICorner", op).CornerRadius = UDim.new(1, 0)

local opStroke = Instance.new("UIStroke", op)
opStroke.Color = Color3.fromRGB(255,255,255)
opStroke.Thickness = 2
opStroke.Transparency = 0.15

local opPad = Instance.new("UIPadding", op)
opPad.PaddingTop = UDim.new(0, 8)
opPad.PaddingBottom = UDim.new(0, 8)
opPad.PaddingLeft = UDim.new(0, 8)
opPad.PaddingRight = UDim.new(0, 8)

-- pulse cho nút mở lại
task.spawn(function()
    local T = game:GetService("TweenService")
    while op.Parent do
        T:Create(op, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0,70,0,70)
        }):Play()
        task.wait(1.2)
        if not op.Parent then break end
        T:Create(op, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0,64,0,64)
        }):Play()
        task.wait(1.2)
    end
end)

xb.MouseButton1Click:Connect(function()
    m.Visible = false
    op.Visible = true
end)
op.MouseButton1Click:Connect(function()
    m.Visible = true
    op.Visible = false
end)

-- Hub tabs
local tf = Instance.new("Frame")
tf.Size = UDim2.new(1,-40,0,40)
tf.Position = UDim2.new(0,20,0,72)
tf.BackgroundTransparency = 1
tf.Parent = m
local tl = Instance.new("UIListLayout", tf)
tl.FillDirection = Enum.FillDirection.Horizontal
tl.Padding = UDim.new(0,6)

local hb = {}
local sh = 1
local kb, sl

for i, h in pairs(H) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,92,1,0)
    b.BackgroundColor3 = Color3.fromRGB(38,28,58)
    b.Text = h.n
    b.TextColor3 = Color3.fromRGB(170,150,200)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.AutoButtonColor = false
    b.Parent = tf
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    hb[i] = b

    b.MouseButton1Click:Connect(function()
        sh = i
        for j, x in pairs(hb) do
            game:GetService("TweenService"):Create(x, TweenInfo.new(0.2), {
                BackgroundColor3 = (j==i) and Color3.fromRGB(139,92,246) or Color3.fromRGB(38,28,58)
            }):Play()
            x.TextColor3 = (j==i) and Color3.fromRGB(255,255,255) or Color3.fromRGB(170,150,200)
        end
        if sl then sl.Text = "Đã chọn: "..h.n end
    end)
end
hb[1].BackgroundColor3 = Color3.fromRGB(139,92,246)
hb[1].TextColor3 = Color3.fromRGB(255,255,255)

-- Key input
local kl = Instance.new("TextLabel")
kl.Size = UDim2.new(1,-40,0,16)
kl.Position = UDim2.new(0,20,0,124)
kl.BackgroundTransparency = 1
kl.Text = "🔑  NHẬP KEY"
kl.TextColor3 = Color3.fromRGB(192,132,252)
kl.Font = Enum.Font.GothamBold
kl.TextSize = 11
kl.TextXAlignment = Enum.TextXAlignment.Left
kl.Parent = m

kb = Instance.new("TextBox")
kb.Size = UDim2.new(1,-40,0,42)
kb.Position = UDim2.new(0,20,0,144)
kb.BackgroundColor3 = Color3.fromRGB(12,8,20)
kb.BorderSizePixel = 0
kb.PlaceholderText = "Dán key..."
kb.PlaceholderColor3 = Color3.fromRGB(120,100,150)
kb.Text = ""
kb.TextColor3 = Color3.fromRGB(56,189,248)
kb.Font = Enum.Font.Code
kb.TextSize = 13
kb.ClearTextOnFocus = false
kb.TextXAlignment = Enum.TextXAlignment.Left
kb.Parent = m
Instance.new("UICorner", kb).CornerRadius = UDim.new(0,10)

local kStroke = Instance.new("UIStroke", kb)
kStroke.Color = Color3.fromRGB(139,92,246)
kStroke.Transparency = 0.5

kb.Focused:Connect(function()
    game:GetService("TweenService"):Create(kStroke, TweenInfo.new(0.2), {Transparency=0}):Play()
end)
kb.FocusLost:Connect(function()
    game:GetService("TweenService"):Create(kStroke, TweenInfo.new(0.2), {Transparency=0.5}):Play()
end)

sl = Instance.new("TextLabel")
sl.Size = UDim2.new(1,-40,0,18)
sl.Position = UDim2.new(0,20,0,190)
sl.BackgroundTransparency = 1
sl.Text = "Chưa chọn hub"
sl.TextColor3 = Color3.fromRGB(160,140,190)
sl.Font = Enum.Font.Gotham
sl.TextSize = 11
sl.TextXAlignment = Enum.TextXAlignment.Left
sl.Parent = m

-- Helper tạo button
local function mk(txt, y, hh, c1, c2)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-40,0,hh)
    b.Position = UDim2.new(0,20,0,y)
    b.BackgroundColor3 = c1
    b.Text = ""
    b.AutoButtonColor = false
    b.Parent = m
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)

    local gr = Instance.new("UIGradient", b)
    gr.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,c1),ColorSequenceKeypoint.new(1,c2)}
    gr.Rotation = 45

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,0,1,0)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = Color3.fromRGB(255,255,255)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 14
    l.Parent = b

    b.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(b, TweenInfo.new(0.15), {BackgroundTransparency=0.15}):Play()
    end)
    b.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(b, TweenInfo.new(0.15), {BackgroundTransparency=0}):Play()
    end)

    return b, l
end

local bw = mk("🌐  GET KEY TỪ WEB", 218, 44, Color3.fromRGB(139,92,246), Color3.fromRGB(236,72,153))
local bd = mk("🔍  XEM KEY ĐÃ NHẬP", 270, 34, Color3.fromRGB(50,38,72), Color3.fromRGB(65,50,90))
local bc = mk("✅  CHECK KEY", 312, 46, Color3.fromRGB(34,197,94), Color3.fromRGB(16,150,70))
local bl, bll = mk("▶  LOAD SCRIPT", 366, 44, Color3.fromRGB(236,72,153), Color3.fromRGB(249,115,22))
bl.Visible = false

local bx = Instance.new("TextButton")
bx.Size = UDim2.new(1,-40,0,28)
bx.Position = UDim2.new(0,20,0,420)
bx.BackgroundColor3 = Color3.fromRGB(50,25,30)
bx.Text = "🗑  XOÁ KEY ĐÃ LƯU"
bx.TextColor3 = Color3.fromRGB(255,140,140)
bx.Font = Enum.Font.Gotham
bx.TextSize = 11
bx.Parent = m
Instance.new("UICorner", bx).CornerRadius = UDim.new(0,8)

-- Notify
local function nt(t, c)
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0,320,0,90)
    p.Position = UDim2.new(0.5,-160,0,30)
    p.BackgroundColor3 = Color3.fromRGB(28,18,44)
    p.BorderSizePixel = 0
    p.ZIndex = 10
    p.Parent = g
    Instance.new("UICorner", p).CornerRadius = UDim.new(0,12)

    local ps = Instance.new("UIStroke", p)
    ps.Color = Color3.fromRGB(192,132,252)
    ps.Thickness = 1.5

    local a1 = Instance.new("TextLabel", p)
    a1.Size = UDim2.new(1,-20,0,24)
    a1.Position = UDim2.new(0,10,0,8)
    a1.BackgroundTransparency = 1
    a1.Text = t
    a1.TextColor3 = Color3.fromRGB(192,132,252)
    a1.Font = Enum.Font.GothamBold
    a1.TextSize = 13
    a1.TextXAlignment = Enum.TextXAlignment.Left
    a1.ZIndex = 11

    local a2 = Instance.new("TextLabel", p)
    a2.Size = UDim2.new(1,-20,0,52)
    a2.Position = UDim2.new(0,10,0,32)
    a2.BackgroundTransparency = 1
    a2.Text = c
    a2.TextColor3 = Color3.fromRGB(220,210,240)
    a2.Font = Enum.Font.Gotham
    a2.TextSize = 11
    a2.TextWrapped = true
    a2.TextXAlignment = Enum.TextXAlignment.Left
    a2.TextYAlignment = Enum.TextYAlignment.Top
    a2.ZIndex = 11

    task.delay(4, function() p:Destroy() end)
end

local function uh(i)
    bl.Visible = true
    bll.Text = "▶  LOAD "..H[i].n
    sl.Text = "✅ "..H[i].n.." — đã mở khoá"
    sl.TextColor3 = Color3.fromRGB(52,211,153)
end

-- Auto load saved key
task.spawn(function()
    local d = lk()
    if d and d.k and d.h then
        local h = H[d.h]
        if h and vk(d.k, h.s) then
            sh = d.h
            for j, x in pairs(hb) do
                x.BackgroundColor3 = (j==d.h) and Color3.fromRGB(139,92,246) or Color3.fromRGB(38,28,58)
                x.TextColor3 = (j==d.h) and Color3.fromRGB(255,255,255) or Color3.fromRGB(170,150,200)
            end
            kb.Text = d.k
            uh(d.h)
            nt("🔓 KEY ĐÃ LƯU", H[d.h].n)
        else
            dk()
        end
    end
end)

-- Actions
bw.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard(a) end
    end)
    nt("🌐 LINK WEB", a)
    sl.Text = "📋 Đã copy link"
    sl.TextColor3 = Color3.fromRGB(160,140,190)
end)

bd.MouseButton1Click:Connect(function()
    local r = ck(kb.Text or "")
    nt("🔍 KEY ĐỌC ĐƯỢC", "Dài: "..#r.."\n"..r)
end)

bc.MouseButton1Click:Connect(function()
    local r = ck(kb.Text or "")
    if r == "" then
        nt("❌ CHƯA CÓ KEY", "Dán key vào ô.")
        return
    end
    local h = H[sh]
    if vk(r, h.s) then
        sk(sh, r)
        nt("✅ KEY HỢP LỆ", "Đã mở khoá "..h.n)
        uh(sh)
    else
        nt("❌ KEY SAI", "Key không đúng / hết hạn.")
        sl.Text = "❌ Key sai"
        sl.TextColor3 = Color3.fromRGB(248,113,113)
    end
end)

bl.MouseButton1Click:Connect(function()
    local h = H[sh]
    nt("⏳ ĐANG TẢI", h.n)
    local ok, err = pcall(function()
        local src = game:HttpGet(h.u)
        local fn = loadstring(src)
        if not fn then error("load fail") end
        fn()
    end)
    if not ok then nt("❌ LỖI LOAD", tostring(err)) end
end)

bx.MouseButton1Click:Connect(function()
    dk()
    kb.Text = ""
    bl.Visible = false
    sl.Text = "🗑 Đã xoá key"
    nt("🗑 XOÁ", "Key đã lưu bị xoá.")
end)

-- Drag
local dr, ds, sp
ti.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dr = true
        ds = inp.Position
        sp = m.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then dr = false end
        end)
    end
end)
ti.InputChanged:Connect(function(inp)
    if dr and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local dl = inp.Position - ds
        m.Position = UDim2.new(sp.X.Scale, sp.X.Offset + dl.X, sp.Y.Scale, sp.Y.Offset + dl.Y)
    end
end)

nt("👑 AURA KEY LOADED", "Chọn hub → GET KEY → vượt link4m → dán key → CHECK.")
