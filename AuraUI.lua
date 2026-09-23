-- AuraMenu obfuscated
local function _d(s) return (s:gsub("%x%x",function(h)return string.char(tonumber(h,16))end)) end
local _s = {}
_s[1] = _d("68747470733a2f2f6272646f6c792e6769746875622e696f2f4272646f6c792f415552415f4b45592e68746d6c")
_s[2] = _d("617572615f736176652e646174")
_s[3] = _d("68747470733a2f2f74696b746f6b2e636f6d2f4062726d6f6437")
_s[4] = _d("726278617373657469643a2f2f3130373039373939303837")
_s[5] = _d("564f49445348454c4c")
_s[6] = _d("3746336139633265")
_s[7] = _d("68747470733a2f2f7261772e67697468756275736572636f6e74656e742e636f6d2f566f69645368656c6c2d6e756c6c2f566f69645368656c6c2d4875622f726566732f68656164732f6d61696e2f536372697074732f537465616c416e4567672e6c756175")
_s[8] = _d("574849544558")
_s[9] = _d("3242386434663161")
_s[10] = _d("68747470733a2f2f7261772e67697468756275736572636f6e74656e742e636f6d2f576869746558313230382f536372697074732f726566732f68656164732f6d61696e2f537465616c4567674f6e6c792e6c756175")
_s[11] = _d("565a53545544494f")
_s[12] = _d("3945356332613766")
_s[13] = _d("68747470733a2f2f7678657a6573747564696f2e6f6e6c696e652f6170692f736372697074732f7363726970745f473543476a716a325833724f532f737472656d2f696e6974")
_s[14] = _d("4a55414c4e415349")
_s[15] = _d("3441316638633565")
_s[16] = _d("68747470733a2f2f7261772e67697468756275736572636f6e74656e742e636f6d2f4a75616c4e61736952656e64616e672f6c6f616465722f726566732f68656164732f6d61696e2f6d61696e2e6c7561")

local W = _s[1]
local F = _s[2]
local TT = _s[3]
local ICON = _s[4]

local H = {
    [1]={n=_s[5],s=_s[6],u=_s[7]},
    [2]={n=_s[8],s=_s[9],u=_s[10]},
    [3]={n=_s[11],s=_s[12],u=_s[13]},
    [4]={n=_s[14],s=_s[15],u=_s[16]}
}

local T = game:GetService("TweenService")
local S = game:GetService("HttpService")
local P = game:GetService("Players").LocalPlayer

local function ck(k) if type(k)~="string" then return "" end return k:gsub("%s+",""):gsub("[^A-Za-z0-9%-]",""):upper() end

local function vk(k,sec)
    if type(k)~="string" then return false end
    k=ck(k)
    local p={}
    for x in k:gmatch("[^%-]+") do table.insert(p,x) end
    if #p~=4 then return false end
    if p[1]~="AURA" or p[2]~="KEY" then return false end
    local t=tonumber(p[3],36)
    if not t then return false end
    local a=os.time()-t
    if a<0 or a>43200 then return false end
    if p[4]~=sec:upper() then return false end
    return true
end

local function sv(h,k) pcall(function() if writefile then writefile(F,S:JSONEncode({h=h,k=k})) end end) end

local function ld()
    local ok,c=pcall(function() if isfile and isfile(F) then return readfile(F) end end)
    if not ok or not c then return nil end
    local ok2,d=pcall(function() return S:JSONDecode(c) end)
    return ok2 and d or nil
end

local function dl() pcall(function() if delfile and isfile and isfile(F) then delfile(F) end end) end

if P:FindFirstChild("AKG") then P.AKG:Destroy() end

local g=Instance.new("ScreenGui")
g.Name="AKG"
g.ResetOnSpawn=false
g.IgnoreGuiInset=true
g.Parent=P:WaitForChild("PlayerGui")

local m=Instance.new("Frame")
m.Size=UDim2.new(0,0,0,0)
m.Position=UDim2.new(0.5,0,0.5,0)
m.AnchorPoint=Vector2.new(0.5,0.5)
m.BackgroundColor3=Color3.fromRGB(18,14,30)
m.BorderSizePixel=0
m.Parent=g
Instance.new("UICorner",m).CornerRadius=UDim.new(0,18)

local bgl=Instance.new("UIGradient",m)
bgl.Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0,Color3.fromRGB(30,20,50)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(14,10,26))
}
bgl.Rotation=135

local sk=Instance.new("UIStroke",m)
sk.Thickness=1.5
sk.Transparency=0.3

local skg=Instance.new("UIGradient",sk)
skg.Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0,Color3.fromRGB(192,132,252)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(236,72,153)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(56,189,248))
}
skg.Rotation=45

task.spawn(function()
    while sk.Parent do
        skg.Rotation=(skg.Rotation+1.5)%360
        task.wait()
    end
end)

T:Create(m,TweenInfo.new(0.4,Enum.EasingStyle.Back),{
    Size=UDim2.new(0,440,0,470)
}):Play()

local hd=Instance.new("Frame")
hd.Size=UDim2.new(1,0,0,70)
hd.BackgroundTransparency=1
hd.Parent=m

local lg=Instance.new("ImageLabel")
lg.Size=UDim2.new(0,46,0,46)
lg.Position=UDim2.new(0,16,0,12)
lg.BackgroundColor3=Color3.fromRGB(12,8,22)
lg.Image=ICON
lg.ScaleType=Enum.ScaleType.Fit
lg.Parent=hd
Instance.new("UICorner",lg).CornerRadius=UDim.new(1,0)

local lgs=Instance.new("UIStroke",lg)
lgs.Color=Color3.fromRGB(192,132,252)
lgs.Thickness=1.5

local lgp=Instance.new("UIPadding",lg)
lgp.PaddingTop=UDim.new(0,6)
lgp.PaddingBottom=UDim.new(0,6)
lgp.PaddingLeft=UDim.new(0,6)
lgp.PaddingRight=UDim.new(0,6)

local tl=Instance.new("TextLabel")
tl.Size=UDim2.new(1,-160,0,24)
tl.Position=UDim2.new(0,72,0,16)
tl.BackgroundTransparency=1
tl.Text="AURA KEY"
tl.TextColor3=Color3.fromRGB(255,255,255)
tl.Font=Enum.Font.GothamBlack
tl.TextSize=19
tl.TextXAlignment=Enum.TextXAlignment.Left
tl.Parent=hd

local tlg=Instance.new("UIGradient",tl)
tlg.Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0,Color3.fromRGB(192,132,252)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(236,72,153))
}

local sb=Instance.new("TextLabel")
sb.Size=UDim2.new(1,-160,0,14)
sb.Position=UDim2.new(0,72,0,42)
sb.BackgroundTransparency=1
sb.Text="by ANON • v3.0"
sb.TextColor3=Color3.fromRGB(150,130,180)
sb.Font=Enum.Font.Gotham
sb.TextSize=10
sb.TextXAlignment=Enum.TextXAlignment.Left
sb.Parent=hd

local xb=Instance.new("TextButton")
xb.Size=UDim2.new(0,32,0,32)
xb.Position=UDim2.new(1,-44,0,18)
xb.BackgroundColor3=Color3.fromRGB(45,25,55)
xb.Text="✕"
xb.TextColor3=Color3.fromRGB(255,130,130)
xb.Font=Enum.Font.GothamBold
xb.TextSize=16
xb.AutoButtonColor=false
xb.Parent=hd
Instance.new("UICorner",xb).CornerRadius=UDim.new(0,10)

local tsp=Instance.new("Frame")
tsp.Size=UDim2.new(1,-32,0,1)
tsp.Position=UDim2.new(0,16,0,70)
tsp.BackgroundColor3=Color3.fromRGB(139,92,246)
tsp.BackgroundTransparency=0.7
tsp.BorderSizePixel=0
tsp.Parent=m

local tw=Instance.new("Frame")
tw.Size=UDim2.new(1,-32,0,36)
tw.Position=UDim2.new(0,16,0,82)
tw.BackgroundTransparency=1
tw.Parent=m

local tly=Instance.new("UIListLayout",tw)
tly.FillDirection=Enum.FillDirection.Horizontal
tly.Padding=UDim.new(0,6)
tly.HorizontalAlignment=Enum.HorizontalAlignment.Center

local tabs,sh,sel={},1
local kb,st,lb

local function stb(id)
    for j,b in pairs(tabs) do
        local a=(j==id)
        T:Create(b,TweenInfo.new(0.2),{
            BackgroundColor3=a and Color3.fromRGB(139,92,246) or Color3.fromRGB(32,24,52),
            TextColor3=a and Color3.fromRGB(255,255,255) or Color3.fromRGB(160,145,190)
        }):Play()
    end
end

for i,h in pairs(H) do
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(0,98,1,0)
    b.BackgroundColor3=Color3.fromRGB(32,24,52)
    b.Text=h.n
    b.TextColor3=Color3.fromRGB(160,145,190)
    b.Font=Enum.Font.GothamBold
    b.TextSize=11
    b.AutoButtonColor=false
    b.Parent=tw
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    tabs[i]=b
    b.MouseButton1Click:Connect(function()
        sh=i
        stb(i)
        st.Text="Đã chọn: "..h.n
    end)
end
stb(1)

kb=Instance.new("TextBox")
kb.Size=UDim2.new(1,-32,0,42)
kb.Position=UDim2.new(0,16,0,130)
kb.BackgroundColor3=Color3.fromRGB(10,6,18)
kb.BorderSizePixel=0
kb.PlaceholderText="Dán key..."
kb.PlaceholderColor3=Color3.fromRGB(110,90,140)
kb.Text=""
kb.TextColor3=Color3.fromRGB(56,189,248)
kb.Font=Enum.Font.Code
kb.TextSize=13
kb.ClearTextOnFocus=false
kb.TextXAlignment=Enum.TextXAlignment.Left
kb.Parent=m
Instance.new("UICorner",kb).CornerRadius=UDim.new(0,10)

local kp=Instance.new("UIPadding",kb)
kp.PaddingLeft=UDim.new(0,12)

local ks=Instance.new("UIStroke",kb)
ks.Color=Color3.fromRGB(139,92,246)
ks.Transparency=0.5

st=Instance.new("TextLabel")
st.Size=UDim2.new(1,-32,0,18)
st.Position=UDim2.new(0,16,0,178)
st.BackgroundTransparency=1
st.Text="Chưa chọn hub"
st.TextColor3=Color3.fromRGB(160,145,190)
st.Font=Enum.Font.Gotham
st.TextSize=11
st.TextXAlignment=Enum.TextXAlignment.Left
st.Parent=m

local function mk(txt,y,ht,c1,c2)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,-32,0,ht)
    b.Position=UDim2.new(0,16,0,y)
    b.BackgroundColor3=c1
    b.Text=""
    b.AutoButtonColor=false
    b.Parent=m
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    local gr=Instance.new("UIGradient",b)
    gr.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,c1),ColorSequenceKeypoint.new(1,c2)}
    gr.Rotation=45
    local l=Instance.new("TextLabel",b)
    l.Size=UDim2.new(1,0,1,0)
    l.BackgroundTransparency=1
    l.Text=txt
    l.TextColor3=Color3.fromRGB(255,255,255)
    l.Font=Enum.Font.GothamBold
    l.TextSize=14
    b.MouseEnter:Connect(function()
        T:Create(b,TweenInfo.new(0.15),{BackgroundTransparency=0.15}):Play()
    end)
    b.MouseLeave:Connect(function()
        T:Create(b,TweenInfo.new(0.15),{BackgroundTransparency=0}):Play()
    end)
    return b,l
end

local wb=mk("🌐  GET KEY TỪ WEB",204,44,Color3.fromRGB(139,92,246),Color3.fromRGB(236,72,153))
local cb=mk("✅  CHECK KEY",254,48,Color3.fromRGB(34,197,94),Color3.fromRGB(16,150,70))
lb,lbl=mk("▶  LOAD SCRIPT",308,44,Color3.fromRGB(236,72,153),Color3.fromRGB(249,115,22))
lb.Visible=false

local tt=mk("🎵  TIKTOK @brmod7",358,38,Color3.fromRGB(20,20,25),Color3.fromRGB(45,45,60))

local function nt(t,c,col)
    local p=Instance.new("Frame")
    p.Size=UDim2.new(0,300,0,0)
    p.Position=UDim2.new(0.5,-150,0,20)
    p.BackgroundColor3=Color3.fromRGB(24,16,40)
    p.BorderSizePixel=0
    p.ZIndex=10
    p.Parent=g
    Instance.new("UICorner",p).CornerRadius=UDim.new(0,12)
    local ps=Instance.new("UIStroke",p)
    ps.Color=col or Color3.fromRGB(192,132,252)
    ps.Thickness=1.5
    local a1=Instance.new("TextLabel",p)
    a1.Size=UDim2.new(1,-20,0,22)
    a1.Position=UDim2.new(0,10,0,8)
    a1.BackgroundTransparency=1
    a1.Text=t
    a1.TextColor3=col or Color3.fromRGB(192,132,252)
    a1.Font=Enum.Font.GothamBold
    a1.TextSize=13
    a1.TextXAlignment=Enum.TextXAlignment.Left
    a1.ZIndex=11
    local a2=Instance.new("TextLabel",p)
    a2.Size=UDim2.new(1,-20,0,50)
    a2.Position=UDim2.new(0,10,0,32)
    a2.BackgroundTransparency=1
    a2.Text=c
    a2.TextColor3=Color3.fromRGB(220,210,240)
    a2.Font=Enum.Font.Gotham
    a2.TextSize=11
    a2.TextWrapped=true
    a2.TextXAlignment=Enum.TextXAlignment.Left
    a2.TextYAlignment=Enum.TextYAlignment.Top
    a2.ZIndex=11
    T:Create(p,TweenInfo.new(0.3,Enum.EasingStyle.Back),{Size=UDim2.new(0,300,0,90)}):Play()
    task.delay(3.5,function()
        if p.Parent then
            T:Create(p,TweenInfo.new(0.25),{Size=UDim2.new(0,300,0,0),BackgroundTransparency=1}):Play()
            task.wait(0.25)
            p:Destroy()
        end
    end)
end

local function uh(i)
    lb.Visible=true
    lbl.Text="▶  LOAD "..H[i].n
    st.Text="✅ "..H[i].n.." — UNLOCKED"
    st.TextColor3=Color3.fromRGB(52,211,153)
end

local rb=Instance.new("ImageButton")
rb.Size=UDim2.new(0,60,0,60)
rb.Position=UDim2.new(0,20,0,120)
rb.BackgroundColor3=Color3.fromRGB(16,12,28)
rb.Image=ICON
rb.ScaleType=Enum.ScaleType.Fit
rb.Visible=false
rb.Parent=g
Instance.new("UICorner",rb).CornerRadius=UDim.new(1,0)

local rbs=Instance.new("UIStroke",rb)
rbs.Color=Color3.fromRGB(192,132,252)
rbs.Thickness=2

local rbp=Instance.new("UIPadding",rb)
rbp.PaddingTop=UDim.new(0,8)
rbp.PaddingBottom=UDim.new(0,8)
rbp.PaddingLeft=UDim.new(0,8)
rbp.PaddingRight=UDim.new(0,8)

local function mn()
    T:Create(m,TweenInfo.new(0.25),{Size=UDim2.new(0,0,0,0)}):Play()
    task.wait(0.25)
    m.Visible=false
    rb.Visible=true
end

local function rs()
    m.Visible=true
    T:Create(m,TweenInfo.new(0.35,Enum.EasingStyle.Back),{Size=UDim2.new(0,440,0,470)}):Play()
    task.wait(0.35)
    rb.Visible=false
end

xb.MouseButton1Click:Connect(mn)
rb.MouseButton1Click:Connect(rs)

task.spawn(function()
    task.wait(0.5)
    local d=ld()
    if d and d.k and d.h then
        local h=H[d.h]
        if h and vk(d.k,h.s) then
            sh=d.h
            stb(d.h)
            kb.Text=d.k
            uh(d.h)
            nt("🔓 KEY ĐÃ LƯU","Tự động mở khoá "..h.n,Color3.fromRGB(52,211,153))
        else
            dl()
        end
    end
end)

wb.MouseButton1Click:Connect(function()
    pcall(function() if setclipboard then setclipboard(W) end end)
    nt("🌐 LINK WEB","Đã copy:\n"..W,Color3.fromRGB(56,189,248))
    st.Text="📋 Đã copy link"
end)

cb.MouseButton1Click:Connect(function()
    local r=ck(kb.Text or "")
    if r=="" then nt("❌ CHƯA CÓ KEY","Dán key vào ô.",Color3.fromRGB(248,113,113)) return end
    local h=H[sh]
    if vk(r,h.s) then
        sv(sh,r)
        nt("✅ KEY HỢP LỆ","Đã mở khoá "..h.n,Color3.fromRGB(52,211,153))
        uh(sh)
    else
        nt("❌ KEY SAI","Key sai / hết hạn 12h",Color3.fromRGB(248,113,113))
        st.Text="❌ Key không hợp lệ"
        st.TextColor3=Color3.fromRGB(248,113,113)
    end
end)

lb.MouseButton1Click:Connect(function()
    local h=H[sh]
    nt("⏳ ĐANG TẢI",h.n,Color3.fromRGB(236,72,153))
    local ok,err=pcall(function()
        local src=game:HttpGet(h.u)
        local fn=loadstring(src)
        if fn then fn() end
    end)
    if not ok then nt("❌ LỖI",tostring(err),Color3.fromRGB(248,113,113)) end
end)

tt.MouseButton1Click:Connect(function()
    pcall(function() if setclipboard then setclipboard(TT) end end)
    nt("🎵 TIKTOK","Đã copy:\n"..TT,Color3.fromRGB(255,50,150))
    st.Text="📋 Đã copy TikTok @brmod7"
end)

local dr,ds,sp
hd.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        dr=true
        ds=inp.Position
        sp=m.Position
        inp.Changed:Connect(function()
            if inp.UserInputState==Enum.UserInputState.End then dr=false end
        end)
    end
end)
hd.InputChanged:Connect(function(inp)
    if dr and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
        local dl=inp.Position-ds
        m.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dl.X,sp.Y.Scale,sp.Y.Offset+dl.Y)
    end
end)

task.wait(0.6)
nt("👑 AURA KEY","Chào mừng!\nFollow TikTok @brmod7",Color3.fromRGB(192,132,252))
