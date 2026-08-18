
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Potato5466794/Wind/refs/heads/main/Wind.luau"))()

getgenv().TransparencyEnabled = getgenv().TransparencyEnabled or false

if not task.spawn then task.spawn = spawn end
if not table.find then
    table.find = function(t, val)
        for i, v in ipairs(t) do
            if v == val then return i end
        end
        return nil
    end
end

local PETAState = {
    EnemyESP = false,
    KeyESP = false,
    Bypass = false, NoClip = false,
}
local PETALoops = {}
local PETASettings = { WalkSpeed = 70 }

local function AddESP(obj, color)
    if not obj:IsA("BasePart") and not obj:IsA("Model") then return end
    if obj:FindFirstChildOfClass("Highlight") then return end
    local hl = Instance.new("Highlight")
    hl.Name = "PETAPETA_ESP"
    hl.FillColor = color
    hl.FillTransparency = 0.2
    hl.OutlineTransparency = 1
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = obj
end

local function ClearAllESP()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Highlight") and v.Name == "PETAPETA_ESP" then v:Destroy() end
    end
end

local function StopAllPETALoops()
    for k, v in pairs(PETALoops) do if v then v:Disconnect() PETALoops[k] = nil end end
end

local function GetCharacter()
    local char = game.Players.LocalPlayer.Character
    if not char then return nil, nil end
    return char, char:FindFirstChild("HumanoidRootPart")
end

local function Teleport(pos)
    if not pos then return end
    local char, hrp = GetCharacter()
    if hrp then hrp.CFrame = pos end
end

-- 穿墙功能
local function EnableNoClip()
    if PETALoops.NoClip then return end
    PETALoops.NoClip = game:GetService("RunService").Stepped:Connect(function()
        if not PETAState.NoClip then return end
        local char = game.Players.LocalPlayer.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end)
end

local function DisableNoClip()
    if PETALoops.NoClip then PETALoops.NoClip:Disconnect() PETALoops.NoClip = nil end
    local char = game.Players.LocalPlayer.Character
    if char then for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end end
end

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if PETAState.NoClip then for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end
end)

local function CreateESPToggle(parent, title, targetName, color, stateKey)
    parent:Toggle({
        Title = title, Value = false,
        Callback = function(s)
            PETAState[stateKey] = s
            if s then
                if PETALoops[stateKey] then PETALoops[stateKey]:Disconnect() end
                PETALoops[stateKey] = task.spawn(function()
                    while PETAState[stateKey] do
                        for _, v in ipairs(workspace:GetDescendants()) do
                            if not PETAState[stateKey] then break end
                            if v.Name == targetName or (type(targetName) == "table" and table.find(targetName, v.Name)) then AddESP(v, color) end
                        end
                        task.wait(0.3)
                    end
                end)
            else
                if PETALoops[stateKey] then PETALoops[stateKey]:Disconnect() PETALoops[stateKey] = nil end
            end
        end
    })
end

local function gradient(text, startColor, endColor)
    local result, chars = "", {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        chars[#chars + 1] = uchar
    end
    for i = 1, #chars do
        local t = (i - 1) / math.max(#chars - 1, 1)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255), 
            math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255), 
            math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255), 
            chars[i])
    end
    return result
end

local themes = {"Dark", "Light", "Mocha", "Aqua"}
local currentThemeIndex = 1

-- 创建确认弹窗
local popupShown = false
local popup = WindUI:Popup({
    Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>H</font><font color='#444444'>U</font><font color='#222222'>B</font><font color='#FFAEC4'></font>",
    Icon = "sparkles",
    Content = "尊贵的破解版用户欢迎使用<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>H</font><font color='#444444'>U</font><font color='#222222'>B</font><font color='#FFAEC4'></font>PETAPETA无限旅馆第2章",
    Buttons = {
        { 
            Title = "确认启动", 
            Icon = "check", 
            Variant = "Primary", 
            Callback = function()
                popupShown = true
            end 
        }
    }
})

-- 等待用户点击确认
repeat task.wait() until popupShown

-- 等弹窗关闭后再创建主窗口
task.wait(0.5)

local Window = WindUI:CreateWindow({
    Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>H</font><font color='#444444'>U</font><font color='#222222'>B</font><font color='#FFAEC4'></font>",
    IconTransparency = 1,
    Author = "byBkFd",
    Folder = "PETAPETA_Data",
    Size = UDim2.fromOffset(650, 500),
    Transparent = true,
    Theme = "Dark",
    UserEnabled = true,
    SideBarWidth = 200,
    HasOutline = true,
    Background = "https://raw.githubusercontent.com/xiaoxi9008/chesksks/refs/heads/main/image_download_1776648555077.jpg",
    ScrollBarEnabled = true
})

Window:Tag({
        Title = "破解版",
        Radius = 10,
        Color = Color3.fromHex("#ffffff"),
    })

    Window:Tag({
        Title = "PETAPETA第2章",
        Radius = 10,
        Color = Color3.fromHex("#ffffff"),
    })

-- 黑白配色方案
local blackWhiteColor = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 150, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})

local COLOR_SCHEMES = {
    ["黑白配色"] = {blackWhiteColor, "waves"},
}

-- 强制应用黑白主题色
WindUI.Themes.Dark.Toggle = Color3.fromRGB(180, 180, 180)
WindUI.Themes.Dark.Checkbox = Color3.fromRGB(200, 200, 200)
WindUI.Themes.Dark.Button = Color3.fromRGB(220, 220, 220)
WindUI.Themes.Dark.Slider = Color3.fromRGB(180, 180, 180)
WindUI.Themes.Dark.ButtonBorder = Color3.fromRGB(200, 200, 200)

Window:EditOpenButton({
    Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>H</font><font color='#444444'>U</font><font color='#222222'>B</font><font color='#FFAEC4'></font>", 
    CornerRadius = UDim.new(16,16), 
    StrokeThickness = 2,
    Color = blackWhiteColor,
    Draggable = true,
})

local function createBlackWhiteBorder(window)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end
    local existingStroke = mainFrame:FindFirstChild("RainbowStroke")
    if existingStroke then existingStroke:Destroy() end
    if not mainFrame:FindFirstChildOfClass("UICorner") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
    end
    local stroke = Instance.new("UIStroke")
    stroke.Name = "RainbowStroke"
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(200, 200, 200)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Parent = mainFrame
    local glowEffect = Instance.new("UIGradient")
    glowEffect.Name = "GlowEffect"
    glowEffect.Color = blackWhiteColor
    glowEffect.Rotation = 0
    glowEffect.Parent = stroke
    return stroke
end

local function startBorderAnimation(window, speed)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end
    local stroke = mainFrame:FindFirstChild("RainbowStroke")
    if not stroke then return nil end
    local glowEffect = stroke:FindFirstChild("GlowEffect")
    if not glowEffect then return nil end
    local animation = game:GetService("RunService").Heartbeat:Connect(function()
        if not stroke or stroke.Parent == nil then animation:Disconnect() return end
        local time = tick()
        glowEffect.Rotation = (time * speed * 60) % 360
    end)
    return animation
end

local borderAnimation
local borderEnabled = true
local animationSpeed = 5

local stroke = createBlackWhiteBorder(Window)
if stroke then borderAnimation = startBorderAnimation(Window, animationSpeed) end

Window:SetToggleKey(Enum.KeyCode.F, true)

-- ==============================================
-- 创建选项卡（只保留：主页、PETAPETA、设置）
-- ==============================================
local Tabs = {
    Main = Window:Tab({ Title = "主页", Icon = "home" }),
    PETAPETA = Window:Tab({ Title = "主要功能", Icon = "gamepad-2" }),
    Settings = Window:Tab({ Title = "设置", Icon = "settings" })
}

-- ==================== 主页内容 ====================
Tabs.Main:Paragraph({
    Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>H</font><font color='#444444'>U</font><font color='#222222'>B</font><font color='#FFAEC4'></font>",
    Desc = "作者：byBkFd\n版本：v3.0.0\n\nUI提供yuxingchen |破解版这辈子不更新了",
    ImageSize = 50,
    Thumbnail = "https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/Image_1774762956572_963.jpg",
    ThumbnailSize = 170
})

Tabs.Main:Divider()
Tabs.Main:Button({ Title = "显示欢迎通知", Icon = "bell", Callback = function()
    WindUI:Notify({ Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>H</font><font color='#444444'>U</font><font color='#222222'>B</font><font color='#FFAEC4'></font>", Content = "感谢使用！", Icon = "heart", Duration = 3 })
end })

-- ==================== PETAPETA 选项卡 ====================
local petasSections = {
    About = Tabs.PETAPETA:Section({ Title = "关于作者", Icon = "info", Opened = true }),
    ESP = Tabs.PETAPETA:Section({ Title = "ESP 透视", Icon = "eye", Opened = true }),
    Speed = Tabs.PETAPETA:Section({ Title = "加速", Icon = "zap", Opened = true }),
    TP = Tabs.PETAPETA:Section({ Title = "传送", Icon = "map-pin", Opened = true }),
    Misc = Tabs.PETAPETA:Section({ Title = "杂项", Icon = "settings", Opened = true })
}

petasSections.About:Paragraph({
    Title = "PETAPETA",
    Desc = "版本: v1.0.0\n作者: byBkFd\n\n使用说明:\n1. 破解版\n无线旅馆第2章\n3. UI提供：yuxingchen"
})

-- ESP 功能（只保留怪物透视和钥匙透视）
CreateESPToggle(petasSections.ESP, "怪物透视", {"EnemyModel", "PetaModel"}, Color3.new(1, 0, 0), "EnemyESP")

petasSections.ESP:Toggle({ Title = "钥匙透视", Value = false, Callback = function(s) PETAState.KeyESP = s if s then if PETALoops.Key then PETALoops.Key:Disconnect() end PETALoops.Key = task.spawn(function() while PETAState.KeyESP do for _,v in ipairs(workspace:GetDescendants()) do if not PETAState.KeyESP then break end if v.Name:find("Key") then AddESP(v, Color3.new(0,1,1)) end end task.wait(0.3) end end) else if PETALoops.Key then PETALoops.Key:Disconnect() PETALoops.Key = nil end end end })

-- 加速
petasSections.Speed:Slider({ Title = "移动速度", Value = { Min = 16, Max = 200, Default = 70 }, Callback = function(v) PETASettings.WalkSpeed = v local c,_ = GetCharacter() if c then local h = c:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = v end end end })
task.spawn(function() while true do task.wait(0.2) local c,_ = GetCharacter() if c then local h = c:FindFirstChildOfClass("Humanoid") if h and h.WalkSpeed ~= PETASettings.WalkSpeed then h.WalkSpeed = PETASettings.WalkSpeed end end end end)

 petasSections.TP:Button({
     Title = "自动传送钥匙", 
     Callback = function()
         
         loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Mysterious-coral./refs/heads/main/%E4%BC%A0%E9%80%81%E5%88%B0%E9%92%A5%E5%8C%99.lua"))()
         
         
         pcall(function()
             game:GetService("StarterGui"):SetCore("SendNotification", {
                 Title = "脚本提示",
                 Text = "传送钥匙已执行！",
                 Duration = 3
             })
         end)
     end
 })

 petasSections.TP:Button({
     Title = "自动传送开锁门", 
     Callback = function()
         
         loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Mysterious-coral./refs/heads/main/%E4%BC%A0%E9%80%81%E5%88%B0%E5%A4%A7%E9%97%A8.lua"))()
         
         
         pcall(function()
             game:GetService("StarterGui"):SetCore("SendNotification", {
                 Title = "脚本提示",
                 Text = "传送大门已执行！",
                 Duration = 3
             })
         end)
     end
 })


-- 杂项
petasSections.Misc:Toggle({ Title = "穿墙", Value = false, Callback = function(s) PETAState.NoClip = s if s then EnableNoClip() else DisableNoClip() end end })
petasSections.Misc:Toggle({ Title = "秒互动", Value = false, Callback = function(s) PETAState.Bypass = s if s then for _,v in ipairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end workspace.DescendantAdded:Connect(function(v) if PETAState.Bypass and v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end) end end })
petasSections.Misc:Button({ Title = "清除所有高亮", Callback = function() ClearAllESP() end })


-- ==================== 设置选项卡 ====================
local borderSection = Tabs.Settings:Section({ Title = "边框设置", Icon = "square", Opened = true })

borderSection:Toggle({
    Title = "启用边框", Value = true,
    Callback = function(value)
        borderEnabled = value
        local mainFrame = Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                rainbowStroke.Enabled = value
                if value and not borderAnimation then borderAnimation = startBorderAnimation(Window, animationSpeed)
                elseif not value and borderAnimation then borderAnimation:Disconnect() borderAnimation = nil end
            end
        end
    end
})

local colorNames = {}
for name, _ in pairs(COLOR_SCHEMES) do table.insert(colorNames, name) end

borderSection:Dropdown({
    Title = "颜色方案", Values = colorNames, Value = "黑白配色",
    Callback = function(value)
        local mainFrame = Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
                if glowEffect then
                    local schemeData = COLOR_SCHEMES[value]
                    if schemeData then glowEffect.Color = schemeData[1] end
                end
            end
        end
    end
})

borderSection:Slider({
    Title = "动画速度", Value = { Min = 1, Max = 10, Default = 5 },
    Callback = function(value)
        animationSpeed = value
        if borderAnimation then borderAnimation:Disconnect() borderAnimation = nil end
        if borderEnabled then borderAnimation = startBorderAnimation(Window, animationSpeed) end
    end
})

borderSection:Slider({
    Title = "边框粗细", Value = { Min = 1, Max = 5, Default = 2 }, Step = 0.5,
    Callback = function(value)
        local mainFrame = Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then rainbowStroke.Thickness = value end
        end
    end
})

borderSection:Slider({
    Title = "圆角大小", Value = { Min = 0, Max = 30, Default = 16 },
    Callback = function(value)
        local mainFrame = Window.UIElements.Main
        if mainFrame then
            local corner = mainFrame:FindFirstChildOfClass("UICorner")
            if not corner then corner = Instance.new("UICorner"); corner.Parent = mainFrame end
            corner.CornerRadius = UDim.new(0, value)
        end
    end
})

local appearanceSection = Tabs.Settings:Section({ Title = "外观设置", Icon = "brush", Opened = true })

local themes_list = {}
for themeName, _ in pairs(WindUI:GetThemes()) do table.insert(themes_list, themeName) end
table.sort(themes_list)

appearanceSection:Dropdown({
    Title = "选择主题", Values = themes_list, Value = "Dark",
    Callback = function(theme)
        WindUI:SetTheme(theme)
        WindUI:Notify({ Title = "主题已应用", Content = theme, Icon = "palette", Duration = 2 })
    end
})

appearanceSection:Slider({
    Title = "透明度", Value = { Min = 0, Max = 1, Default = 0.2 }, Step = 0.1,
    Callback = function(value)
        Window:ToggleTransparency(tonumber(value) > 0)
        WindUI.TransparencyValue = tonumber(value)
    end
})

-- ==============================================
-- 窗口关闭清理
-- ==============================================
Window:OnClose(function()
    print("窗口关闭")
    if borderAnimation then borderAnimation:Disconnect() borderAnimation = nil end
    StopAllPETALoops()
    ClearAllESP()
    DisableNoClip()
end)

Window:OnDestroy(function()
    print("窗口已销毁")
end)