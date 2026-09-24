local WEB_URL = "https://brdoly.github.io/Brdoly/AURA_KEY.html"
local SAVE = "aura_save.dat"
local SECRET = "7F3A9C2E"
local TTL = 30*60*60

local SCRIPTS = {
    {n="Vantablack Hub", u="https://raw.githubusercontent.com/tranduykhanh08428-web/VantablackHub/refs/heads/main/Stealanegg.lua.txt"},
    {n="Cao Mod Hub",    u="https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/Fn-stealanegg.lua"},
    {n="VZ Studio",      u="http://vxezestudio.online/api/scripts/script_G5CGjqj2X3rOS/strem/init"},
    {n="Miranda AFK",    u="https://raw.githubusercontent.com/miirandahub/loader/refs/heads/main/mirandaafk.lua"},
    {n="Zero In Hub",    u="https://zeroinhub.com/api/script"},
    {n="Ronnei Hub",     u="https://raw.githubusercontent.com/elonmod/skibidi/refs/heads/main/Ronneihub-keyless.lua"},
    {n="Rezzy Steal",    u="https://raw.githubusercontent.com/Roman666Cabj/Nether/refs/heads/main/RezzyStealAnEgg.lua"},
    {n="VoidShell Hub",  u="https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/StealAnEgg.luau"},
    {n="WhiteX Hub",     u="https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/StealEggOnly.luau"},
    {n="JualNasi Hub",   u="https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua"}
}

local S = game:GetService("HttpService")
local P = game:GetService("Players").LocalPlayer

local function ck(k)
    if type(k)~="string" then return "" end
    return k:gsub("%s+",""):gsub("[^A-Za-z0-9%-]",""):upper()
end

local function vk(k)
    k = ck(k)
    local p = {}
    for x in k:gmatch("[^%-]+") do table.insert(p,x) end
    if #p ~= 4 then return false,"format" end
    if p[1]~="AURA" or p[2]~="KEY" then return false,"prefix" end
    local t = tonumber(p[3],36)
    if not t then return false,"ts" end
    local a = os.time()-t
    if a<0 then return false,"future" end
    if a>TTL then return false,"expired" end
    if p[4]~=SECRET then return false,"secret" end
    return true,"ok"
end

local function sv(k)
    pcall(function()
        if writefile then writefile(SAVE,S:JSONEncode({k=k,saved=os.time()})) end
    end)
end

local function ld()
    local ok,c = pcall(function()
        if isfile and isfile(SAVE) then return readfile(SAVE) end
    end)
    if not ok or not c then return nil end
    local ok2,d = pcall(function() return S:JSONDecode(c) end)
    return ok2 and d or nil
end

local function dl()
    pcall(function()
        if delfile and isfile and isfile(SAVE) then delfile(SAVE) end
    end)
end

if P:FindFirstChild("AKG") then P.AKG:Destroy() end

local g = Instance.new("ScreenGui")
g.Name = "AKG"
g.ResetOnSpawn = false
g.IgnoreGuiInset = true
g.Parent = P:WaitForChild("PlayerGui")

local m = Instance.new("Frame")
m.Size = UDim2.new(0,420,0,460)
m.Position = UDim2.new(0.5,-210,0.5,-230)
m.BackgroundColor3 = Color3.fromRGB(20,14,34)
m.BorderSizePixel = 0
m.Parent = g
Instance.new("UICorner",m).CornerRadius = UDim.new(0,16)

local sk = Instance.new("UIStroke",m)
sk.Color = Color3.fromRGB(139,92,246)
sk.Thickness = 1.5
sk.Transparency = 0.4

local hd = Instance.new("Frame")
hd.Size = UDim2.new(1,0,0,60)
hd.BackgroundTransparency = 1
hd.Parent = m

local tl = Instance.new("TextLabel")
tl.Size = UDim2.new(1,-60,1,0)
tl.Position = UDim2.new(0,16,0,0)
tl.BackgroundTransparency = 1
tl.Text = "AURA KEY SYSTEM"
tl.TextColor3 = Color3.fromRGB(192,132,252)
tl.Font = Enum.Font.GothamBold
tl.TextSize = 18
tl.TextXAlignment = Enum.TextXAlignment.Left
tl.Parent = hd

local xb = Instance.new("TextButton")
xb.Size = UDim2.new(0,30,0,30)
xb.Position = UDim2.new(1,-40,0,15)
xb.BackgroundColor3 = Color3.fromRGB(50,25,55)
xb.Text = "✕"
xb.TextColor3 = Color3.fromRGB(255,130,130)
xb.Font = Enum.Font.GothamBold
xb.TextSize = 16
xb.Parent = hd
Instance.new("UICorner",xb).CornerRadius = UDim.new(0,8)

local sep = Instance.new("Frame")
sep.Size = UDim2.new(1,-32,0,1)
sep.Position = UDim2.new(0,16,0,60)
sep.BackgroundColor3 = Color3.fromRGB(139,92,246)
sep.BackgroundTransparency = 0.6
sep.BorderSizePixel = 0
sep.Parent = m

local pg1 = Instance.new("Frame")
pg1.Size = UDim2.new(1,0,1,-60)
pg1.Position = UDim2.new(0,0,0,60)
pg1.BackgroundTransparency = 1
pg1.Parent = m

local st = Instance.new("TextLabel",pg1)
st.Size = UDim2.new(1,-32,0,20)
st.Position = UDim2.new(0,16,0,14)
st.BackgroundTransparency = 1
st.Text = "Nhập key để mở khoá"
st.TextColor3 = Color3.fromRGB(180,160,210)
st.Font = Enum.Font.Gotham
st.TextSize = 12
st.TextXAlignment = Enum.TextXAlignment.Left

local kb = Instance.new("TextBox",pg1)
kb.Size = UDim2.new(1,-32,0,46)
kb.Position = UDim2.new(0,16,0,40)
kb.BackgroundColor3 = Color3.fromRGB(10,6,18)
kb.BorderSizePixel = 0
kb.PlaceholderText = "Dán key từ web vào đây..."
kb.PlaceholderColor3 = Color3.fromRGB(110,90,140)
kb.Text = ""
kb.TextColor3 = Color3.fromRGB(56,189,248)
kb.Font = Enum.Font.Code
kb.TextSize = 13
kb.ClearTextOnFocus = false
kb.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner",kb).CornerRadius = UDim.new(0,10)

local kp = Instance.new("UIPadding",kb)
kp.PaddingLeft = UDim.new(0,12)

local ks = Instance.new("UIStroke",kb)
ks.Color = Color3.fromRGB(139,92,246)
ks.Transparency = 0.5

local function btn(txt,y,c1,par)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-32,0,44)
    b.Position = UDim2.new(0,16,0,y)
    b.BackgroundColor3 = c1
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.AutoButtonColor = false
    b.Parent = par or pg1
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,10)
    return b
end

local bWeb = btn("🌐  GET KEY TỪ WEB", 100, Color3.fromRGB(139,92,246))
local bChk = btn("✅  CHECK KEY", 152, Color3.fromRGB(34,197,94))

local pg2 = Instance.new("Frame")
pg2.Size = UDim2.new(1,0,1,-60)
pg2.Position = UDim2.new(0,0,0,60)
pg2.BackgroundTransparency = 1
pg2.Visible = false
pg2.Parent = m

local ht = Instance.new("TextLabel",pg2)
ht.Size = UDim2.new(1,-32,0,20)
ht.Position = UDim2.new(0,16,0,12)
ht.BackgroundTransparency = 1
ht.Text = "📜 DANH SÁCH SCRIPT"
ht.TextColor3 = Color3.fromRGB(192,132,252)
ht.Font = Enum.Font.GothamBold
ht.TextSize = 13
ht.TextXAlignment = Enum.TextXAlignment.Left

local sc = Instance.new("ScrollingFrame",pg2)
sc.Size = UDim2.new(1,-32,1,-92)
sc.Position = UDim2.new(0,16,0,38)
sc.BackgroundColor3 = Color3.fromRGB(14,10,24)
sc.BorderSizePixel = 0
sc.ScrollBarThickness = 4
sc.ScrollBarImageColor3 = Color3.fromRGB(139,92,246)
sc.CanvasSize = UDim2.new(0,0,0,0)
sc.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner",sc).CornerRadius = UDim.new(0,12)

local sl = Instance.new("UIListLayout",sc)
sl.Padding = UDim.new(0,6)
sl.SortOrder = Enum.SortOrder.LayoutOrder

local sp = Instance.new("UIPadding",sc)
sp.PaddingTop = UDim.new(0,8)
sp.PaddingBottom = UDim.new(0,8)
sp.PaddingLeft = UDim.new(0,8)
sp.PaddingRight = UDim.new(0,8)

local status = Instance.new("TextLabel",pg2)
status.Size = UDim2.new(1,-32,0,20)
status.Position = UDim2.new(0,16,1,-24)
status.BackgroundTransparency = 1
status.Text = "Chọn 1 script để chạy"
status.TextColor3 = Color3.fromRGB(160,145,190)
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left

local function run(name,url)
    status.Text = "⏳ Đang tải "..name.."..."
    status.TextColor3 = Color3.fromRGB(236,72,153)
    local ok,err = pcall(function()
        local src = game:HttpGet(url)
        local fn = loadstring(src)
        if fn then fn() end
    end)
    if ok then
        status.Text = "✅ "..name.." đã chạy"
        status.TextColor3 = Color3.fromRGB(52,211,153)
    else
        status.Text = "❌ Lỗi: "..tostring(err):sub(1,50)
        status.TextColor3 = Color3.fromRGB(248,113,113)
    end
end

for i,s in ipairs(SCRIPTS) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,40)
    b.BackgroundColor3 = Color3.fromRGB(32,24,52)
    b.Text = i..". "..s.n
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.AutoButtonColor = false
    b.LayoutOrder = i
    b.Parent = sc
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)
    b.MouseButton1Click:Connect(function()
        run(s.n,s.u)
    end)
end

local function nt(t,c,col)
    local p = Instance.new("TextLabel")
    p.Size = UDim2.new(0,300,0,60)
    p.Position = UDim2.new(0.5,-150,0,20)
    p.BackgroundColor3 = Color3.fromRGB(24,16,40)
    p.Text = t.."\n"..c
    p.TextColor3 = col or Color3.fromRGB(192,132,252)
    p.Font = Enum.Font.Gotham
    p.TextSize = 12
    p.TextWrapped = true
    p.ZIndex = 100
    p.Parent = g
    Instance.new("UICorner",p).CornerRadius = UDim.new(0,12)
    local ps = Instance.new("UIStroke",p)
    ps.Color = col or Color3.fromRGB(192,132,252)
    ps.Thickness = 1.5
    task.delay(4,function() p:Destroy() end)
end

local rb = Instance.new("TextButton")
rb.Size = UDim2.new(0,50,0,50)
rb.Position = UDim2.new(0,20,0,120)
rb.BackgroundColor3 = Color3.fromRGB(139,92,246)
rb.Text = "🔑"
rb.TextSize = 22
rb.Visible = false
rb.Parent = g
Instance.new("UICorner",rb).CornerRadius = UDim.new(1,0)

xb.MouseButton1Click:Connect(function()
    m.Visible = false
    rb.Visible = true
end)
rb.MouseButton1Click:Connect(function()
    m.Visible = true
    rb.Visible = false
end)

bWeb.MouseButton1Click:Connect(function()
    pcall(function() if setclipboard then setclipboard(WEB_URL) end end)
    nt("🌐 LINK WEB","Đã copy: "..WEB_URL:sub(1,40).."...",Color3.fromRGB(56,189,248))
end)

bChk.MouseButton1Click:Connect(function()
    local r = ck(kb.Text or "")
    if r == "" then
        nt("❌ CHƯA CÓ KEY","Dán key vào ô phía trên.",Color3.fromRGB(248,113,113))
        return
    end
    local ok,err = vk(r)
    if ok then
        sv(r)
        nt("✅ KEY HỢP LỆ","Đã mở khoá 30 giờ!",Color3.fromRGB(52,211,153))
        pg1.Visible = false
        pg2.Visible = true
    else
        local msg = "Key không hợp lệ."
        if err=="expired" then msg = "Key hết hạn 30h. Lấy key mới."
        elseif err=="secret" then msg = "Key sai hệ thống."
        elseif err=="format" then msg = "Key sai định dạng."
        elseif err=="prefix" then msg = "Key sai tiền tố."
        elseif err=="future" then msg = "Key không hợp lệ."
        elseif err=="ts" then msg = "Timestamp sai." end
        nt("❌ KEY SAI",msg,Color3.fromRGB(248,113,113))
    end
end)

task.spawn(function()
    task.wait(0.5)
    local d = ld()
    if d and d.k then
        local ok,err = vk(d.k)
        if ok then
            kb.Text = d.k
            nt("🔓 KEY RESTORED","Tự động mở khoá.",Color3.fromRGB(52,211,153))
            task.wait(0.4)
            pg1.Visible = false
            pg2.Visible = true
        else
            dl()
        end
    end
end)

local dr,ds,sp2
hd.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        dr=true
        ds=inp.Position
        sp2=m.Position
        inp.Changed:Connect(function()
            if inp.UserInputState==Enum.UserInputState.End then dr=false end
        end)
    end
end)
hd.InputChanged:Connect(function(inp)
    if dr and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
        local dl2=inp.Position-ds
        m.Position=UDim2.new(sp2.X.Scale,sp2.X.Offset+dl2.X,sp2.Y.Scale,sp2.Y.Offset+dl2.Y)
    end
end)
