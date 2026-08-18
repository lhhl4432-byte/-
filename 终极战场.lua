local HttpService = cloneref(game:GetService("HttpService"))

local Env = getfenv()

local LogService = game:GetService("LogService")
local getconnections = Env.getconnections
local MessageOut = "MessageOut"
local cons = getconnections(LogService[MessageOut])
if cons then
    for _, v in pairs(cons) do
        pcall(function() v:Disable() end)
    end
end

local function cleanupConnections()
    pcall(function()
        
        for _, conn in ipairs(getconnections(LogService.MessageOut) or {}) do
            pcall(function() conn:Disable() end)
        end
    end)
end
cleanupConnections()

print("✅ 环境净化完成，LogService 干扰已禁用")

local isfunctionhooked = clonefunction(isfunctionhooked)
if isfunctionhooked(game.HttpGet) or isfunctionhooked(getnamecallmethod) or isfunctionhooked(request) then 
    return 
end

local function verifyKey(k)
    local ok, res = pcall(function()
        return request({
            Url = "https://ouo.lat/api/verify.php",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({key = k, time = os.time()})
        })
    end)
    
    if not ok then return false end
    
    if res.Body ~= "True" then
        return false
    end
    
    local ok2, res2 = pcall(function()
        return game:HttpGet("https://www.wtb.lat/keysystem/check-key?key="..k.."&user="..game.Players.LocalPlayer.Name)
    end)
    
    return ok2 and res2 == "success"
end

local key = ""
pcall(function() key = readfile("DyzhKey.json") end)
if key ~= "" then
    if verifyKey(key) then
        print('验证完成')
    else
        return
    end
end

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/-UI/refs/heads/main/Wind.lua"))()
local Window = WindUI:CreateWindow({
    Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>H</font><font color='#444444'>U</font><font color='#222222'>B</font><font color='#FFAEC4'></font>",
    IconThemed = true,
    Author = "byBkFd",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(600, 450),
    Transparent = true,
    Theme = "Dark",
    UserEnabled = true,
    SideBarWidth = 135,
    HasOutline = true,
    Transparent = true,
    Background = "https://raw.githubusercontent.com/xiaoxi9008/Mysterious-coral./refs/heads/main/1777784268833.jpeg",
    Theme = "Dark",
    User = {
        Enabled = true,
        Callback = function() end,
        Anonymous = false
    },
    SideBarWidth = 200,
    ScrollBarEnabled = true
})

AddSnowEffect(Window.UIElements.Main.Background, 30, 14, 0.5)

Window:Tag({
        Title = "破解版",
        Radius = 4,
        Color = Color3.fromHex("#ffffff"),
    })

    Window:Tag({
        Title = "终极战场",
        Radius = 4,
        Color = Color3.fromHex("#ffffff"),
    })

WindUI.Themes.Dark.Button = Color3.fromRGB(255, 255, 255)  
WindUI.Themes.Dark.ButtonBorder = Color3.fromRGB(255, 255, 255)  

local function addButtonBorderStyle()
    local mainFrame = Window.UIElements.Main
    if not mainFrame then return end
    
    local styleSheet = Instance.new("StyleSheet")
    styleSheet.Parent = mainFrame
    
    local rule = Instance.new("StyleRule")
    rule.Selector = "Button, ImageButton, TextButton"
    rule.Parent = styleSheet
    
    local borderProp = Instance.new("StyleProperty")
    borderProp.Name = "BorderSizePixel"
    borderProp.Value = 1
    borderProp.Parent = rule
    
    local colorProp = Instance.new("StyleProperty")
    colorProp.Name = "BorderColor3"
    colorProp.Value = Color3.fromRGB(255, 255, 255)
    colorProp.Parent = rule
end

Window:CreateTopbarButton("theme-switcher", "moon", function()
    local themes_list = {"Dark", "Light", "Mocha", "Aqua"}
    currentThemeIndex = (currentThemeIndex % #themes_list) + 1
    local newTheme = themes_list[currentThemeIndex]
    WindUI:SetTheme(newTheme)
    WindUI:Notify({
        Title = "主题已切换",
        Content = "当前主题: "..newTheme,
        Duration = 2
    })
end, 990)

WindUI.Themes.Dark.Toggle = Color3.fromHex("FF69B4")
WindUI.Themes.Dark.Checkbox = Color3.fromHex("FFB6C1")
WindUI.Themes.Dark.Button = Color3.fromHex("FF1493")
WindUI.Themes.Dark.Slider = Color3.fromHex("FF69B4")

local COLOR_SCHEMES = {
    ["黑白流动"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FFFFFF")), 
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("000000")),  
        ColorSequenceKeypoint.new(1, Color3.fromHex("FFFFFF"))  
    }), "waves"},

    ["彩虹颜色"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),
        ColorSequenceKeypoint.new(0.16, Color3.fromHex("FFA500")),
        ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),
        ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),
        ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("EE82EE"))
    }), "palette"},
    
    ["樱花粉1"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF69B4")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF1493")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("FFB6C1"))
    }), "candy"},

    ["樱花粉2"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FED0E0")),
        ColorSequenceKeypoint.new(0.2, Color3.fromHex("FDBAD2")),
        ColorSequenceKeypoint.new(0.4, Color3.fromHex("FCA5C5")),
        ColorSequenceKeypoint.new(0.6, Color3.fromHex("FB8FB7")),
        ColorSequenceKeypoint.new(0.8, Color3.fromHex("FA7AA9")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("F9649B"))
    }), "waves"},
}

Window:EditOpenButton({
    Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>H</font><font color='#444444'>U</font><font color='#222222'>B</font><font color='#FFAEC4'></font>",
    CornerRadius = UDim.new(16,16),
    StrokeThickness = 2,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FFFFFF")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("000000")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("FFFFFF"))
    }),
    Draggable = true,
})


task.spawn(function()
    local button = Window.UIElements.Main:FindFirstChild("OpenButton")
    if not button then
        for _, child in ipairs(Window.UIElements.Main:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("ImageButton") then
                button = child
                break
            end
        end
    end
    if not button then return end
    
    local stroke = button:FindFirstChildOfClass("UIStroke")
    if stroke then
        local gradient = stroke:FindFirstChild("UIGradient") or Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("FFFFFF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("000000")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("FFFFFF"))
        })
        gradient.Parent = stroke
        game:GetService("RunService").Heartbeat:Connect(function()
            gradient.Rotation = (tick() * 60) % 360
        end)
    end
end)

local function createRainbowBorder(window, colorScheme, speed)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end
    
    local existingStroke = mainFrame:FindFirstChild("RainbowStroke")
    if existingStroke then
        existingStroke:Destroy()
    end
    
    if not mainFrame:FindFirstChildOfClass("UICorner") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
    end
    
    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Thickness = 2
    rainbowStroke.Color = Color3.new(1, 1, 1)
    rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
    rainbowStroke.Parent = mainFrame
    
    local glowEffect = Instance.new("UIGradient")
    glowEffect.Name = "GlowEffect"
    
    local schemeData = COLOR_SCHEMES[colorScheme or "樱花粉2"]
    if schemeData then
        glowEffect.Color = schemeData[1]
    else
        glowEffect.Color = COLOR_SCHEMES["樱花粉2"][1]
    end
    
    glowEffect.Rotation = 0
    glowEffect.Parent = rainbowStroke
    
    return rainbowStroke
end

local function startBorderAnimation(window, speed)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end
    
    local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
    if not rainbowStroke then return nil end
    
    local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
    if not glowEffect then return nil end
    
    local animation = game:GetService("RunService").Heartbeat:Connect(function()
        if not rainbowStroke or rainbowStroke.Parent == nil then
            animation:Disconnect()
            return
        end
        
        local time = tick()
        
        glowEffect.Rotation = (time * speed * 30) % 360
        
      
        rainbowStroke.Transparency = 0.3 + math.sin(time * 2) * 0.2
    end)
    
    return animation
end

local borderAnimation
local borderEnabled = true
local currentColor = "黑白流动"
local animationSpeed = 5

local rainbowStroke = createRainbowBorder(Window, currentColor, animationSpeed)
if rainbowStroke then
    borderAnimation = startBorderAnimation(Window, animationSpeed)
end

local TimeTag = Window:Tag({
    Title = "--:--",
    Radius = 999,
    Color = Color3.fromRGB(255, 255, 255),
})

task.spawn(function()
	while true do
		local now = os.date("*t")
		local hours = string.format("%02d", now.hour)
		local minutes = string.format("%02d", now.min)
		
		TimeTag:SetTitle(hours .. ":" .. minutes)
		task.wait(0.06)
	end
end)
local LangTab = Window:Tab({
    Title = "选择语言/Select Language",
    Icon = "smile",
    Locked = false,
})
local function createChineseUI()
local notTab = Window:Tab({
    Title = "公告",
    Icon = "",
    Locked = false,
})

notTab:Paragraph({
    Title = "欢迎使用BkFd脚本",
    Desc = "作者：BkFd｜ UI提供：鱼腥草｜脚本帮助:联邦\n版本：v4.0.0\n\n一个功能强大的脚本",
    ImageSize = 50,
    Thumbnail = "https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/7fdb4ab15ea4447bc9566c7caf856f82fc31ae85362243f5f0dd837a41c9ea86.png",
    ThumbnailSize = 170
})

notTab:Divider()

notTab:Button({
    Title = "显示欢迎通知",
    Icon = "bell",
    Callback = function()
        WindUI:Notify({
            Title = "欢迎!",
            Content = "感谢使用",
            Icon = "heart",
            Duration = 3
        })
    end
})

local Tab = Window:Tab({
    Title = "功能",
    Icon = "sword",
    Locked = false,
})
local HttpService = game:GetService("HttpService")

local InviteCode = "E6meCtvdZ"
local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

local Response = HttpService:JSONDecode(WindUI.Creator.Request({
    Url = DiscordAPI,
    Method = "GET"
}).Body)

if Response and Response.guild then
    local iconUrl = Response.guild.icon and ("https://cdn.discordapp.com/icons/" .. Response.guild.id .. "/" .. Response.guild.icon .. ".png?size=1024") or "rbxassetid://129260712070622"

    Tab:Paragraph({
        Title = Response.guild.name,
        Desc =
            ' <font color="#52525b">●</font> 总人数: ' .. tostring(Response.approximate_member_count) ..
            '\n <font color="#16a34a">●</font> 在线人数: ' .. tostring(Response.approximate_presence_count),
        Image = iconUrl,
        ImageSize = 42,
    })
else
    warn("Discord API Error: ", HttpService:JSONEncode(Response))
end

Tab:Button({
    Title = "篡改",
    Desc = "玩的时候第一先开启这个功能一定要开",
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dream77239/ubg-script/refs/heads/main/%E6%8B%A6%E6%88%AA.txt"))()
    end
})
local fakeBlockEnabled = false
local loopRunning = false

Tab:Toggle({
    Title = "假防(关闭功能后按一次防御即可取消假防)",
    Value = false,
    Callback = function(state)
        fakeBlockEnabled = state

        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local BlockRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Block")
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        local function enableBlock()
            pcall(function()
                BlockRemote:FireServer(true)
            end)
        end

        if fakeBlockEnabled then
            enableBlock()
        end

        if not loopRunning then
            loopRunning = true
            task.spawn(function()
                while true do
                    task.wait(0.01)
                    if fakeBlockEnabled then
                        local success, isBlocking = pcall(function()
                            return character:GetAttribute("IsBlocking")
                        end)
                        if success and not isBlocking then
                            enableBlock()
                        end
                    end
                end
            end)
        end
    end
})

local defaultCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Dash.Value

Tab:Toggle({
    Title = "侧闪无冷却",
    Value = false,
    Callback = function(state)
        local dashCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Dash
        if state then
            dashCooldown.Value = 1
        else
            dashCooldown.Value = defaultCooldown
        end
    end
})
local defaultMeleeCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Melee.Value

Tab:Toggle({
    Title = "近战无冷却",
    Value = false,
    Callback = function(state)
        local meleeCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Melee
        if state then
            meleeCooldown.Value = 1
        else
            meleeCooldown.Value = defaultMeleeCooldown
        end
    end
})
local rs = game:GetService("ReplicatedStorage")
local settings = rs.Settings

local defaultAbility = settings.Cooldowns.Ability.Value
Tab:Toggle({
    Title = "技能无冷却(仅宿傩角色)",
    Value = false,
    Callback = function(state)
        settings.Cooldowns.Ability.Value = state and 1 or defaultAbility
    end
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local noSlowdownsToggle = ReplicatedStorage.Settings.Toggles.NoSlowdowns

local defaultValue = false

Tab:Toggle({
    Title = "无减速效果",
    Value = noSlowdownsToggle.Value,
    Callback = function(state)
        if state then
            noSlowdownsToggle.Value = true
        else
            noSlowdownsToggle.Value = defaultValue
        end
    end
})

local defaultDisableHitStun = settings.Toggles.DisableHitStun.Value
Tab:Toggle({
    Title = "取消被攻击硬直",
    Value = false,
    Callback = function(state)
        settings.Toggles.DisableHitStun.Value = state
    end
})

local defaultDisableIntros = settings.Toggles.DisableIntros.Value
Tab:Toggle({
    Title = "跳过角色开场动作",
    Value = false,
    Callback = function(state)
        settings.Toggles.DisableIntros.Value = state
    end
})

local defaultNoStunOnMiss = settings.Toggles.NoStunOnMiss.Value
Tab:Toggle({
    Title = "普攻无僵直",
    Value = false,
    Callback = function(state)
        settings.Toggles.NoStunOnMiss.Value = state
    end
})

local defaultRagdollTimer = settings.Multipliers.RagdollTimer.Value
Tab:Toggle({
    Title = "被别人击倒不会变成布娃娃",
    Value = false,
    Callback = function(state)
        settings.Multipliers.RagdollTimer.Value = state and 0.5 or defaultRagdollTimer
    end
})

local defaultUltimateTimer = settings.Multipliers.UltimateTimer.Value
Tab:Toggle({
    Title = "延长大招时间",
    Value = false,
    Callback = function(state)
        settings.Multipliers.UltimateTimer.Value = state and 100000 or defaultUltimateTimer
    end
})

local defaultInstantTransformation = settings.Toggles.InstantTransformation.Value
Tab:Toggle({
    Title = "秒开大",
    Value = false,
    Callback = function(state)
        settings.Toggles.InstantTransformation.Value = state
    end
})
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Ping = player:WaitForChild("Info"):WaitForChild("Ping")

local loop

Tab:Toggle({
    Title = "ping乱码",
    Value = false,
    Callback = function(state)
        if state then
            loop = task.spawn(function()
                while state do
                    for i = 0, 999, 25 do
                        if not state then break end
                        Ping.Value = i
                        task.wait(0.03)
                    end
                    for i = 999, 0, -25 do
                        if not state then break end
                        Ping.Value = i
                        task.wait(0.03)
                    end
                end
            end)
        else
            if loop then
                task.cancel(loop)
                loop = nil
            end
        end
    end
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MeleeDamage = ReplicatedStorage:WaitForChild("Settings"):WaitForChild("Multipliers"):WaitForChild("MeleeDamage")

MeleeDamage.Value = 100

Tab:Toggle({
    Title = "一拳倒地",
    Value = false,
    Callback = function(state)
        if state then
            MeleeDamage.Value = 1000000
        else
            MeleeDamage.Value = 100
        end
    end
})
Tab:Toggle({
    Title = "一拳击飞",
    Value = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RunService = game:GetService("RunService")

        local LocalPlayer = Players.LocalPlayer
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

        local RagdollPower = ReplicatedStorage:WaitForChild("Settings"):WaitForChild("Multipliers"):WaitForChild("RagdollPower")

        local maxTeleportDistance = 50
        local lastPosition = HumanoidRootPart.Position
        local connection

        if state then
            RagdollPower.Value = 10000

            connection = RunService.RenderStepped:Connect(function()
                
                if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                    lastPosition = HumanoidRootPart.Position
                end

                local currentPos = HumanoidRootPart.Position
                local distance = (currentPos - lastPosition).Magnitude

                if distance > maxTeleportDistance then
                    HumanoidRootPart.CFrame = CFrame.new(lastPosition)
                else
                    lastPosition = currentPos
                end
            end)
        else
            RagdollPower.Value = 100
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local wallCombo = ReplicatedStorage.Settings.Cooldowns.WallCombo

Tab:Toggle({
    Title = "墙打无冷却",
    Value = false,
    Callback = function(state)
        if state then
            wallCombo.Value = 0
            print("WallCombo cooldown set to 0")
        else
            wallCombo.Value = 100
            print("WallCombo cooldown reset to 100")
        end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local wall = nil
pcall(function()
    wall = workspace.Map.Structural.Terrain:GetChildren()[5]:GetChildren()[12]
end)

if not wall then
    wall = Instance.new("Part")
    wall.Parent = workspace
end

wall.Size = Vector3.new(12,6,2)
wall.Transparency = 0.6
wall.Material = Enum.Material.SmoothPlastic
wall.Anchored = true
wall.CanCollide = true
wall.CFrame = wall.CFrame or CFrame.new(0,5,0)

if getconnections then
    for _, conn in pairs(getconnections(wall.AncestryChanged)) do
        conn:Disable()
    end
end

local mt = getrawmetatable(game)
setreadonly(mt,false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if self == wall and method == "Destroy" then
        return
    end
    return old(self, ...)
end)
setreadonly(mt,true)

local followConnection = nil
Tab:Toggle({
    Title = "随处墙打",
    Value = false,
    Callback = function(state)
        if state then
            if not followConnection then
                followConnection = RunService.RenderStepped:Connect(function()
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        wall.CFrame = hrp.CFrame * CFrame.new(0,0,-8)
                    end
                end)
            end
        else
            if followConnection then
                followConnection:Disconnect()
                followConnection = nil
            end
        end
    end
})
local originalData = {}
local skyBackup = nil

Tab:Toggle({
    Title = "防卡",
    Value = false,
    Callback = function(state)
        if state then
            originalData = {}
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Explosion") then
                    originalData[v] = v.Enabled
                    v.Enabled = false
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    originalData[v] = v.Transparency
                    v.Transparency = 1
                elseif v:IsA("MeshPart") or v:IsA("UnionOperation") or v:IsA("Part") then
                    if v.Name ~= "HumanoidRootPart" then
                        originalData[v] = v.Material
                        v.Material = Enum.Material.SmoothPlastic
                    end
                elseif v:IsA("SurfaceGui") or v:IsA("BillboardGui") or v:IsA("Beam") then
                    if v:IsA("Beam") then
                        originalData[v] = v.Enabled
                        v.Enabled = false
                    else
                        originalData[v] = v.Enabled ~= nil and v.Enabled or true
                        if v.Enabled ~= nil then
                            v.Enabled = false
                        end
                    end
                end
            end
            originalData["GlobalShadows"] = game.Lighting.GlobalShadows
            originalData["FogEnd"] = game.Lighting.FogEnd
            game.Lighting.GlobalShadows = false
            game.Lighting.FogEnd = 9e9
            local sky = game.Lighting:FindFirstChildOfClass("Sky")
            if sky then
                skyBackup = sky:Clone()
                sky:Destroy()
            end
            local newSky = Instance.new("Sky")
            newSky.SkyboxBk = ""
            newSky.SkyboxDn = ""
            newSky.SkyboxFt = ""
            newSky.SkyboxLf = ""
            newSky.SkyboxRt = ""
            newSky.SkyboxUp = ""
            newSky.SunAngularSize = 0
            newSky.MoonAngularSize = 0
            newSky.Parent = game.Lighting
            game.Lighting.Ambient = Color3.fromRGB(128,128,128)
            game.Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
        else
            for obj, value in pairs(originalData) do
                if typeof(obj) == "Instance" and obj.Parent then
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Explosion") then
                        obj.Enabled = value
                    elseif obj:IsA("Decal") or obj:IsA("Texture") then
                        obj.Transparency = value
                    elseif obj:IsA("MeshPart") or obj:IsA("UnionOperation") or obj:IsA("Part") then
                        obj.Material = value
                    elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") or obj:IsA("Beam") then
                        if obj:IsA("Beam") then
                            obj.Enabled = value
                        elseif obj.Enabled ~= nil then
                            obj.Enabled = value
                        end
                    end
                elseif obj == "GlobalShadows" then
                    game.Lighting.GlobalShadows = value
                elseif obj == "FogEnd" then
                    game.Lighting.FogEnd = value
                end
            end
            if skyBackup then
                local currentSky = game.Lighting:FindFirstChildOfClass("Sky")
                if currentSky then
                    currentSky:Destroy()
                end
                skyBackup.Parent = game.Lighting
                skyBackup = nil
            end
            originalData = {}
        end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

local clone, platform, originalCFrame, originalCameraSubject

local function CreatePlatform(position)
    local part = Instance.new("Part")
    part.Size = Vector3.new(10, 1, 10)
    part.Position = position - Vector3.new(0, 3, 0)
    part.Anchored = true
    part.CanCollide = true
    part.Transparency = 0.5
    part.Parent = workspace
    return part
end

local function CreateClone()
    local newClone = Character:Clone()
    for _, v in ipairs(newClone:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = 0.5
        end
    end
    newClone.Parent = workspace
    return newClone
end

local function ToggleInvisibility(state)
    if state then
        originalCFrame = HumanoidRootPart.CFrame
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, -50, 0)
        platform = CreatePlatform(HumanoidRootPart.Position)
        
        task.wait(1)
        
        clone = CreateClone()
        clone:MoveTo(originalCFrame.Position)
        Camera.CameraSubject = clone:FindFirstChildWhichIsA("Humanoid")
        LocalPlayer.Character = clone
    else
        if clone then
            clone:Destroy()
            clone = nil
        end
        
        if platform then
            platform:Destroy()
            platform = nil
        end
        
        if originalCFrame then
            HumanoidRootPart.CFrame = originalCFrame
            originalCFrame = nil
        end
        
        Camera.CameraSubject = Character:FindFirstChildWhichIsA("Humanoid")
        LocalPlayer.Character = Character
    end
end

Tab:Toggle({
    Title = "隐身",
    Value = false,
    Callback = ToggleInvisibility
})
local v_u_1 = require(game.ReplicatedStorage:WaitForChild("Core"))
local v155 = game.Players.LocalPlayer:WaitForChild("Data"):WaitForChild("Character")
local v156 = game.ReplicatedStorage.Characters:FindFirstChild(v155.Value):FindFirstChild("WallCombo")
local v158 = Vector3.new(7, 5, 7)
local v159 = CFrame.new(0, 0, 0)
local v160 = v_u_1.Get("Character", "FullCustomReplication").GetCFrame()
local v163 = game.Players.LocalPlayer.Character

local v167 = {
    ["Size"] = v158,
    ["Offset"] = v159,
    ["CustomValidation"] = function()
        return true
    end,
}

local v_u_168 = v_u_1.Get("Combat", "Hit").Box(nil, v163, v167)
local v58 = v156:GetAttribute("Interrupt")

function Run(p_u_7, p8, p_u_9, p10, ...)
    local v_u_11 = p_u_7 and p_u_7:FindFirstChild("Humanoid") or p_u_7
    local v_u_12 = p_u_7 and p_u_7:FindFirstChild("HumanoidRootPart") or p_u_7
    if p_u_7 and (v_u_11 and v_u_12) then
        local v_u_13 = p_u_7 == game.Players.LocalPlayer.Character
        local v_u_17 = p8
        v_u_1.Get("Combat", "Cancel").Init(v_u_17, p_u_9, p_u_7)
        v_u_1.Get("Combat", "Cancel").Set(v_u_17, p_u_9, p_u_7, "Timeout")
        local v_u_36 = { ... }
        task.spawn(function()
            local v37 = {}
            local v38 = v_u_36
            for i, v in ipairs({ p_u_7, v_u_11, v_u_12, v_u_13, p_u_9 }) do
                v37[i] = v
            end
            for i, v in ipairs(v38) do
                v37[#v37 + 1] = v
            end
            v_u_1.Get("Cosmetics", "KillEmote").RunAfter(v_u_17, table.unpack(v37))
        end)
    end
end

local originPos = v160.Position
local rs = game:GetService("RunService")
local running = false

Tab:Toggle({
    Title = "杀戮光环",
    Value = false,
    Callback = function(state)
        running = state
        if running then
            rs:BindToRenderStep("KillAura", Enum.RenderPriority.Input.Value, function()
                local pos = originPos + v160.LookVector * 6
                for i = 1, 4 do
                    task.spawn(function()
                        v_u_1.Library("Remote").Send("Ability", v156, 9e9, v58, v_u_168, pos)
                        Run(game.Players.LocalPlayer.Character, v156, 9e9, v58, v_u_168, pos)
                    end)
                end
            end)
        else
            rs:UnbindFromRenderStep("KillAura")
        end
    end
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local wallComboSpamming = false
local wallComboHeartbeat = nil
local wallComboPerFrame = 2
local wallComboKeybind = Enum.KeyCode.E

local core = require(ReplicatedStorage.Core)
local chars = ReplicatedStorage.Characters
local char = LocalPlayer.Data.Character

local function executeWallCombo()
    local head = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not head then return end

    local res = core.Get("Combat","Hit").Box(nil, LocalPlayer.Character, {Size = Vector3.new(50,50,50)})
    if res then
        local success, err = pcall(core.Get("Combat","Ability").Activate, chars[char.Value].WallCombo, res, head.Position + Vector3.new(0,0,2.5))
        if not success then
            warn(err)
        end
    end
end

local active = false 
local function getLocalPlayerCharacter()
    return Players.LocalPlayer and Players.LocalPlayer.Character
end
local function generateActionNumber()
    return "Action" .. math.random(1000, 9999)
end
local function getServerTime()
    return tick()
end
local function wallcomboveryud()
    local playerChar = getLocalPlayerCharacter()
    if not playerChar then return false end
    local head = playerChar:FindFirstChild("Head")
    if not head then return false end
    local LocalPlayer = Players.LocalPlayer
    local charData = LocalPlayer:FindFirstChild("Data")
    local charValue = charData and charData:FindFirstChild("Character") and charData.Character.Value
    if not charValue then return false end
    local charsFolder = ReplicatedStorage:FindFirstChild("Characters")
    if not charsFolder or not charsFolder:FindFirstChild(charValue) then return false end
    local wallComboAbility = charsFolder[charValue]:FindFirstChild("WallCombo")
    if not wallComboAbility then return false end
    local targetCharacter = playerChar
    if not targetCharacter then return false end
    local actionNumber = generateActionNumber()
    local serverTime = getServerTime()
    local randomId = math.random(100000, 999999)
    local remoteArgs = {
        wallComboAbility,
        "Characters:" .. charValue .. ":WallCombo",
        1,
        randomId,
        {
            HitboxCFrames = {nil},
            BestHitCharacter = targetCharacter,
            HitCharacters = {targetCharacter},
            Ignore = {[actionNumber] = {targetCharacter}},
            DeathInfo = {},
            Actions = {[actionNumber] = {}},
            HitInfo = {
                Blocked = false,
                IsFacing = true,
                IsInFront = true
            },
            BlockedCharacters = {},
            ServerTime = serverTime,
            FromCFrame = nil
        },
        actionNumber
    }
    pcall(function()
        ReplicatedStorage.Remotes.Abilities.Ability:FireServer(wallComboAbility, randomId)
    end)
    pcall(function()
        ReplicatedStorage.Remotes.Combat.Action:FireServer(unpack(remoteArgs))
    end)
end

task.spawn(function()
    while task.wait(0.01) do
        if active then
            pcall(wallcomboveryud)
        end
    end
end)

function ToggleInvincibility(state)
    active = state
    print(state and "无敌已开启" or "无敌已关闭")
end

local KillauraV1 = {
    IgnoreFriends = false,
    MaxDistance = 100,
    Damage = 9999,
    HealthLimit = 0,
    DashInterval = 0.7,
    AttackInterval = 0.001,
    running = false,
    conn = nil,
    lastDash = 0,
    lastAttack = 0
}
local data = Players.LocalPlayer:WaitForChild("Data")
local charValue = data:WaitForChild("Character")
local localCharacterName = charValue.Value
local ability = ReplicatedStorage:WaitForChild("Characters"):WaitForChild(localCharacterName):WaitForChild("WallCombo")
local AbilitiesRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Abilities"):WaitForChild("Ability")
local CombatRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Action")
local function getLocalRootPart()
    local c = Players.LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function triggerDash()
    if tick() - KillauraV1.lastDash < KillauraV1.DashInterval then return end
    KillauraV1.lastDash = tick()
    local hrp = getLocalRootPart()
    if not hrp then return end
    local dashRemote = ReplicatedStorage.Remotes.Character:FindFirstChild("Dash")
    if dashRemote then
        pcall(function()
            dashRemote:FireServer(hrp.CFrame, "L", hrp.CFrame.LookVector, nil, tick())
        end)
    end
end
local function sendKillAuraV1()
    if tick() - KillauraV1.lastAttack < KillauraV1.AttackInterval then return end
    KillauraV1.lastAttack = tick()
    local localRootPart = getLocalRootPart()
    if not localRootPart then return end
    triggerDash()
    local maxDistSq = KillauraV1.MaxDistance * KillauraV1.MaxDistance
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= Players.LocalPlayer then
            local targetChar = targetPlayer.Character
            if targetChar then
                local targetRootPart = targetChar:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = targetChar:FindFirstChild("Humanoid")
                if targetRootPart and targetHumanoid and targetHumanoid.Health > KillauraV1.HealthLimit then
                    if not (KillauraV1.IgnoreFriends and Players.LocalPlayer:IsFriendsWith(targetPlayer.UserId)) then
                        local delta = localRootPart.Position - targetRootPart.Position
                        if delta.Magnitude * delta.Magnitude <= maxDistSq then
                            pcall(function()
                                AbilitiesRemote:FireServer(ability, KillauraV1.Damage, {}, targetRootPart.Position)
                            end)
                            pcall(function()
                                CombatRemote:FireServer(
                                    ability,
                                    localCharacterName .. ":WallCombo",
                                    2,
                                    KillauraV1.Damage,
                                    {
                                        HitboxCFrames = {targetRootPart.CFrame, targetRootPart.CFrame},
                                        BestHitCharacter = targetChar,
                                        HitCharacters = {targetChar},
                                        Ignore = {},
                                        DeathInfo = {},
                                        BlockedCharacters = {},
                                        HitInfo = {IsFacing = false, IsInFront = true},
                                        ServerTime = os.time(),
                                        Actions = {
                                            ActionNumber1 = {
                                                [targetPlayer.Name] = {
                                                    StartCFrameStr = tostring(localRootPart.CFrame),
                                                    Local = true,
                                                    Collision = false,
                                                    Animation = "Punch1Hit",
                                                    Preset = "Punch",
                                                    Velocity = Vector3.zero,
                                                    FromPosition = targetRootPart.Position,
                                                    Seed = math.random(1,999999)
                                                }
                                            }
                                        },
                                        FromCFrame = targetRootPart.CFrame
                                    },
                                    "Action150",
                                    0
                                )
                            end)
                        end
                    end
                end
            end
        end
    end
end
local function startAuraV1()
    if KillauraV1.conn then KillauraV1.conn:Disconnect() KillauraV1.conn = nil end
    KillauraV1.conn = RunService.Heartbeat:Connect(function()
        if KillauraV1.running then
            sendKillAuraV1()
        end
    end)
end
local function stopAuraV1()
    if KillauraV1.conn then KillauraV1.conn:Disconnect() KillauraV1.conn = nil end
end

local function updateWallComboHeartbeat()
    if wallComboHeartbeat then
        wallComboHeartbeat:Disconnect()
        wallComboHeartbeat = nil
    end
    if wallComboSpamming then
        wallComboHeartbeat = RunService.Heartbeat:Connect(function()
            for i = 1, wallComboPerFrame do
                executeWallCombo()
            end
        end)
    end
end

UserInputService.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end
    if input.KeyCode == wallComboKeybind then
        executeWallCombo()
    end
end)

Tab:Toggle({
    Title = "墙打秒杀（超大范围）",
    Value = false,
    Callback = function(state)
        wallComboSpamming = state
        updateWallComboHeartbeat()
    end
})

Tab:Toggle({
    Title = "无敌",
    Value = false,
    Callback = function(state)
        ToggleInvincibility(state)
    end
})

Tab:Toggle({
    Title = "杀戮光环（暴力）",
    Value = false,
    Callback = function(state)
        KillauraV1.running = state
        if state then
            startAuraV1()
        else
            stopAuraV1()
        end
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local enabled = false
local conn
local PlayersList = {}
local index = 1
local RANGE = 70  
local DASH_INTERVAL = 0.25  
local lastDash = 0

local function C()
    return LocalPlayer.Character
end

local function HRP()
    if C() and C():FindFirstChild("Humanoid") then
        return C().Humanoid.RootPart
    end
end

local function isFriend(p)
    return LocalPlayer:IsFriendsWith(p.UserId)
end

local function triggerDash()
    local now = tick()
    if now - lastDash < DASH_INTERVAL then return end
    lastDash = now
    local hrp = HRP()
    if not hrp then return end
    local dashRemote = ReplicatedStorage.Remotes.Character:FindFirstChild("Dash")
    if dashRemote then
        pcall(function()
            dashRemote:FireServer(
                hrp.CFrame,
                "L",
                hrp.CFrame.LookVector,
                nil,
                now
            )
        end)
    end
end

local function getTargets()
    local targets = {}
    local hrp = HRP()
    if not hrp then return targets end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if isFriend(p) then continue end  
            local hum = p.Character:FindFirstChild("Humanoid")
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 and not p.Character:GetAttribute("Invincible") then
                if (root.Position - hrp.Position).Magnitude <= RANGE then
                    table.insert(targets, p.Character)
                end
            end
        end
    end
    return targets
end

local function KillAura(count)
    triggerDash()
    local targets = getTargets()
    for _, char in ipairs(targets) do
        for i = 1, count do
            PlayersList[index] = char
            index += 1
        end
    end
    if index > 1 then
        local combo = ReplicatedStorage.Characters[LocalPlayer.Data.Character.Value].WallCombo
        ReplicatedStorage.Remotes.Abilities.Ability:FireServer(combo, 69)
        ReplicatedStorage.Remotes.Combat.Action:FireServer(
            combo,
            "",
            4,
            69,
            {
                BestHitCharacter = nil,
                HitCharacters = PlayersList,
                Ignore = {},
                Actions = {}
            }
        )
        table.clear(PlayersList)
        index = 1
    end
end

Tab:Toggle({
    Flag = "23.5",
    Title = "杀戮光环（秒杀）",
    Value = false,
    Callback = function(state)
        enabled = state
        if enabled then
            conn = RunService.Heartbeat:Connect(function()

                local count = (LocalPlayer.Data.Character.Value == "Gon") and 20 or 50
                KillAura(count)
            end)
        else
            if conn then
                conn:Disconnect()
                conn = nil
            end
        end
    end
})

local function updateWallComboHeartbeat()
    if wallComboHeartbeat then
        wallComboHeartbeat:Disconnect()
        wallComboHeartbeat = nil
    end
    if wallComboSpamming then
        wallComboHeartbeat = RunService.Heartbeat:Connect(function()
            for i = 1, wallComboPerFrame do
                executeWallCombo()
            end
        end)
    end
end

UserInputService.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end
    if input.KeyCode == wallComboKeybind then
        executeWallCombo()
    end
end)

Tab:Toggle({
    Title = "墙打秒杀",
    Value = false,
    Callback = function(state)
        wallComboSpamming = state
        updateWallComboHeartbeat()
    end
})
Tab:Button({
    Title = "删除墙打特效",
    Desc = "点了该功能就无法恢复墙打特效",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local paths = {
            ReplicatedStorage.Characters.Gon.WallCombo.GonWallCombo.Center,
            ReplicatedStorage.Characters.Gon.WallCombo.GonWallCombo.Explosion,
            ReplicatedStorage.Characters.Gon.WallCombo.GonIntroHands,
            ReplicatedStorage.Characters.Mob.WallCombo.MobWallCombo.Center,
            ReplicatedStorage.Characters.Nanami.WallCombo.NanamiWallCombo.Center,
            ReplicatedStorage.Characters.Stark.WallCombo.StarkWallCombo.Center,
            ReplicatedStorage.Characters.Sukuna.WallCombo.SukunaTransformWallCombo,
            ReplicatedStorage.Characters.Sukuna.WallCombo.SukunaWallCombo
        }

        for _, obj in ipairs(paths) do
            if obj and obj:IsA("Instance") then
                for _, child in ipairs(obj:GetChildren()) do
                    child:Destroy()
                end
            end
        end
    end
})
Tab:Button({
    Title = "删除击杀表情特效",
    Desc = "点击删除击杀表情的部分特效,不可恢复",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local KillEmote = ReplicatedStorage:WaitForChild("Cosmetics"):WaitForChild("KillEmote")

        local function removeEffects(obj)
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("ParticleEmitter") 
                or child:IsA("Trail") 
                or child:IsA("Beam") 
                or child:IsA("Fire") 
                or child:IsA("Smoke") 
                or child:IsA("Sparkles") 
                or child:IsA("Light") then
                    child:Destroy()
                else
                    removeEffects(child)
                end
            end
        end

        removeEffects(KillEmote)
        print("KillEmote 特效已删除（保留本体）")
    end
})
 local ReplicatedStorage = game:GetService("ReplicatedStorage")
local multiUseCutscenesToggle = ReplicatedStorage.Settings.Toggles.MultiUseCutscenes

local defaultValue = false

Tab:Toggle({
    Title = "艾斯帕大招技能多次使用(全角色通用)",
    Value = multiUseCutscenesToggle.Value,
    Callback = function(state)
        if state then
            multiUseCutscenesToggle.Value = true
        else
            multiUseCutscenesToggle.Value = defaultValue
        end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local tpwalking = false
local tpwalkSpeed = 100

Tab:Toggle({
    Title = "速度",
    Value = false,
    Callback = function(state)
        tpwalking = state
        if state then
            spawn(function()
                while tpwalking do
                    local chr = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local hrp = chr:FindFirstChild("HumanoidRootPart")
                    local hum = chr:FindFirstChildWhichIsA("Humanoid")
                    local delta = RunService.Heartbeat:Wait()
                    if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * tpwalkSpeed * delta)
                    end
                end
            end)
        end
    end
})

Tab:Slider({
    Title = "速度调节",
    Value = {
        Min = 0,
        Max = 250,
        Default = tpwalkSpeed,
    },
    Callback = function(value)
        tpwalkSpeed = value
    end
})
Tab:Slider({
    Title = "冲刺加速(默认值100)",
    Value = {
        Min = 0,
        Max = 1000,
        Default = 100,
    },
    Callback = function(value)
        game:GetService("ReplicatedStorage").Settings.Multipliers.DashSpeed.Value = value
    end
})

Tab:Slider({
    Title = "跳跃增强(默认值100)",
    Value = {
        Min = 0,
        Max = 1000,
        Default = 100,
    },
    Callback = function(value)
        game:GetService("ReplicatedStorage").Settings.Multipliers.JumpHeight.Value = value
    end
})

Tab:Slider({
    Title = "攻击加速(默认值100)",
    Value = {
        Min = 0,
        Max = 1000,
        Default = 100,
    },
    Callback = function(value)
        game:GetService("ReplicatedStorage").Settings.Multipliers.MeleeSpeed.Value = value
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer


local _F = {
    P = Players,
    R = RunService,
    RS = ReplicatedStorage,
    W = Workspace,
    L = LocalPlayer,
    Cfg = {
        Enabled = false,
        Range = 9999, 
        Friends = true, 
        Target = "Closest" 
    },
    Data = {
        List = {},
        Idx = 1,
        FCon = nil,
        KCon = nil,
        OSub = nil,
        OType = nil,
        SCFrame = nil,
        SCCFrame = nil,
        SCType = nil
    }
}

function _F.Dash()
    local char = _F.L.Character or _F.L.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        pcall(function()
            require(_F.RS:WaitForChild("Core")).Library("Remote").Send("Dash", hrp.CFrame, "L", 1)
        end)
    end
end

function _F.HRP()
    local c = _F.L.Character
    if c and c:FindFirstChild('Humanoid') and c.Humanoid.RootPart then
        return c.Humanoid.RootPart
    end
    return nil
end

function _F.IsF(p)
    if not p or p == _F.L then return false end
    return _F.L:IsFriendsWith(p.UserId)
end

function _F.GetT()
    local tgs = {}
    local root = _F.HRP()
    if not root then return tgs end
    local pos = root.Position
    
    for _, v in ipairs(_F.P:GetPlayers()) do
        local char = v.Character
        if char and v ~= _F.L and char:FindFirstChild(' ') == nil then
            if _F.Cfg.Friends and _F.IsF(v) then continue end
            local hum = char:FindFirstChild('Humanoid')
            local hrp = char:FindFirstChild('HumanoidRootPart')
            
            if hum and hrp then
                local dist = (hrp.Position - pos).Magnitude
                if dist < _F.Cfg.Range then
                    local lchar = _F.L.Character
                    if lchar then
                        local lName = lchar.Name
                        local cs = char:GetAttribute("Cutscene")
                        local csV = not cs or cs == lchar:GetAttribute("Cutscene")
                        
                        if hrp and not char:GetAttribute("Ignore") and csV and 
                           ((not char:GetAttribute("Grabbed") or char:GetAttribute("Grabbed") == lName) and 
                           (not char:GetAttribute("Victim") or char:GetAttribute("Victim") == lName)) and 
                           not char:GetAttribute("Invincible") and not char:GetAttribute("Grabbing") then
                            
                            table.insert(tgs, {c = char, d = dist, h = hum:GetAttribute("Health") or hum.Health or 0})
                        end
                    end
                end
            end
        end
    end
    
    if _F.Cfg.Target == "Closest" and #tgs > 0 then
        table.sort(tgs, function(a, b) return a.d < b.d end)
        return {tgs[1]}
    end
    return tgs
end

function _F.Aura(n)
    local root = _F.HRP()
    if not root then return end
    local tgs = _F.GetT()
    for _, data in ipairs(tgs) do
        if data.c then
            for i=1, n do
                _F.Data.List[_F.Data.Idx] = data.c
                _F.Data.Idx = _F.Data.Idx + 1
            end
        end
    end
    if _F.Data.Idx > 1 then
        local name = _F.L.Data.Character.Value
        local combo = _F.RS.Characters[name].WallCombo
        _F.RS.Remotes.Abilities.Ability:FireServer(combo, 69)
        _F.RS.Remotes.Combat.Action:FireServer(combo, "", 4, 69, {BestHitCharacter=nil, HitCharacters=_F.Data.List, Ignore={}, Actions={}})
        for k in pairs(_F.Data.List) do _F.Data.List[k] = nil end
        _F.Data.Idx = 1
    end
end

function _F.GetR()
    local al = {}
    for _, p in ipairs(_F.P:GetPlayers()) do
        if p ~= _F.L and p.Character then
            local hu = p.Character:FindFirstChild("Humanoid")
            local hr = p.Character:FindFirstChild("HumanoidRootPart")
            if hu and hr and (hu:GetAttribute("Health") or 0) > 0 and not hu:GetAttribute("Godmode") then
                table.insert(al, p)
            end
        end
    end
    return #al > 0 and al[math.random(1, #al)] or nil
end

function _F.TP(p)
    if not p or not p.Character then return false end
    local hr = p.Character:FindFirstChild("HumanoidRootPart")
    if not hr then return false end
    pcall(function()
        require(_F.L.PlayerScripts.Character.FullCustomReplication).Override(_F.L.Character, CFrame.new(hr.Position - Vector3.new(0, 30, 0)))
    end)
    return true
end

function _F.Spec(p)
    local cam = _F.W.CurrentCamera
    if cam and p and p.Character then
        local hu = p.Character:FindFirstChildOfClass("Humanoid")
        if hu then cam.CameraType = Enum.CameraType.Custom cam.CameraSubject = hu end
    end
end

function _F.Loop()
    local c = _F.L.Character
    if not c or not c.Parent then return end
    local r = _F.GetR()
    if r then
        _F.TP(r)
        _F.Spec(r)
        task.wait(0.5)
    end
end

function _F.Grav(b)
    local c = _F.L.Character
    if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Anchored = not b
            if not b then p.Velocity = Vector3.new(0,0,0) end
        end
    end
end

function _F.Save()
    local c = _F.L.Character
    local hr = c and c:FindFirstChild("HumanoidRootPart")
    if not hr then return false end
    _F.Data.SCFrame = hr.CFrame
    local cam = _F.W.CurrentCamera
    if cam then 
        _F.Data.SCCFrame = cam.CFrame 
        _F.Data.SCType = cam.CameraType 
    end
    return true
end

function _F.Rest()
    if not _F.Data.SCFrame or not _F.L.Character then return end
    pcall(function() require(_F.L.PlayerScripts.Character.FullCustomReplication).Override(_F.L.Character, _F.Data.SCFrame) end)
    task.delay(0.1, function()
        local cam = _F.W.CurrentCamera
        if cam and _F.Data.SCCFrame then 
            cam.CameraType = _F.Data.SCType 
            cam.CFrame = _F.Data.SCCFrame 
        end
    end)
end

function _F.Start()
    if not _F.Save() then return end
    _F.Grav(false)
    local cam = _F.W.CurrentCamera
    if cam then 
        _F.Data.OSub = cam.CameraSubject 
        _F.Data.OType = cam.CameraType 
    end
    _F.Data.FCon = _F.R.Heartbeat:Connect(_F.Loop)
    _F.Data.KCon = _F.R.Heartbeat:Connect(function()
        _F.Dash()
        local cn = _F.L.Data.Character.Value
        _F.Aura(cn == "Gon" and 20 or 50) 
    end)
end

function _F.Stop()
    if _F.Data.FCon then _F.Data.FCon:Disconnect() _F.Data.FCon = nil end
    if _F.Data.KCon then _F.Data.KCon:Disconnect() _F.Data.KCon = nil end
    _F.Rest()
    _F.Grav(true)
    local cam = _F.W.CurrentCamera
    if cam and _F.Data.OSub then 
        cam.CameraSubject = _F.Data.OSub 
        cam.CameraType = _F.Data.OType 
    end
end

local Tab = Window:Tab({  
    Title = "刷击杀",  
    Icon = "crosshair",  
    Locked = false,
})

Tab:Toggle({
    Title = "开启全图秒杀",
    Value = false,
    Callback = function(state)
        _F.Cfg.Enabled = state
        if _F.Cfg.Enabled then
            _F.Start()
            print("✅ 全图秒杀已开启（范围9999，自动忽略好友）")
        else
            _F.Stop()
            print("❌ 全图秒杀已关闭")
        end
    end
})

Tab:Toggle({
    Title = "秒杀忽略好友",
    Value = true,
    Callback = function(state)
        _F.Cfg.Friends = state
        print("忽略好友：" .. tostring(state))
    end
})

_F.L.CharacterAdded:Connect(function()
    if _F.Cfg.Enabled then
        _F.Stop()
        _F.Cfg.Enabled = false
        print("⚠️ 角色重生，全图秒杀已自动停止，请重新开启")
    end
end)

local CrashTab = Window:Tab({  
    Title = "让服务器溃的功能",  
    Icon = "skull",  
    Locked = false,
})

CrashTab:Button({
    Title = "崩服",
    Desc = "你不卡别人卡死就是前期延迟会高后面就没事了",
    Callback = function()
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RunService = game:GetService("RunService")

        local player = Players.LocalPlayer
        local active = true
        local spawnedTasks = {}

        
        local function buildCombatArgs()
            return {
                [1] = ReplicatedStorage.Characters.Gon.WallCombo,
                [2] = "Characters:Gon:WallCombo",
                [3] = 1,
                [4] = 33036,
                [5] = {
                    ["HitboxCFrames"] = {},
                    ["BestHitCharacter"] = workspace.Characters.NPCs:FindFirstChild("The Ultimate Bum"),
                    ["HitCharacters"] = {workspace.Characters.NPCs:FindFirstChild("The Ultimate Bum")},
                    ["Ignore"] = {},
                    ["DeathInfo"] = {},
                    ["Actions"] = {},
                    ["HitInfo"] = {
                        ["IsFacing"] = true,
                        ["IsInFront"] = true
                    },
                    ["BlockedCharacters"] = {},
                    ["ServerTime"] = os.clock(),
                    ["FromCFrame"] = CFrame.new(534.693, 5.532, 79.486)
                },
                [6] = "Action651",
                [7] = 0
            }
        end

        local abilityArgs = {
            [1] = ReplicatedStorage.Characters.Gon.WallCombo,
            [2] = 33036,
            [4] = workspace.Characters.NPCs:FindFirstChild("The Ultimate Bum"),
            [5] = Vector3.new(527.693, 4.532, 79.978)
        }

        
        for i = 1, 10000 do
            local t = task.spawn(function()
                if active then
                    pcall(function()
                        local combatArgs = buildCombatArgs()
                        ReplicatedStorage.Remotes.Abilities.Ability:FireServer(unpack(abilityArgs))
                        ReplicatedStorage.Remotes.Combat.Action:FireServer(unpack(combatArgs))
                    end)
                end
            end)
            table.insert(spawnedTasks, t)
        end

        
        task.delay(3, function()
            active = false
            for _, t in ipairs(spawnedTasks) do
                if task.cancel then
                    task.cancel(t)
                end
            end
            spawnedTasks = {}

            
            local localContainers = workspace:FindFirstChild("Container(Drawing)")
            if localContainers then
                for _, v in ipairs(localContainers:GetChildren()) do
                    if v.Name:match(tostring(player.UserId)) then
                        v:Destroy()
                    end
                end
            end

            WindUI:Notify({
                Title = "卡服完成",
                Content = "别人已卡死",
                Icon = "skull",
                Duration = 3
            })
        end)

        WindUI:Notify({
            Title = "恭喜你死浮木了哟吼吼吼",
            Content = "卡死别人💀",
            Icon = "alert-triangle",
            Duration = 2
        })
    end
})

local crashing = false
local crashConnection = nil

CrashTab:Toggle({
    Title = "防止崩服失败",
    Desc = "如果崩服没成功就开这个",
    Value = false,
    Callback = function(state)
        crashing = state
        
        if crashing then
            
            local charValue = Players.LocalPlayer.Data.Character.Value
            local wallComboAbility = ReplicatedStorage.Characters[charValue].WallCombo
            
            crashConnection = RunService.Heartbeat:Connect(function()
                if crashing then
                    
                    for i = 1, 5 do
                        task.spawn(function()
                            pcall(function()
                                
                                ReplicatedStorage.Remotes.Abilities.Ability:FireServer(wallComboAbility, math.random(100000, 999999))
                                
                                ReplicatedStorage.Remotes.Combat.Action:FireServer(
                                    wallComboAbility,
                                    charValue .. ":WallCombo",
                                    1,
                                    math.random(100000, 999999),
                                    {
                                        HitboxCFrames = {nil},
                                        BestHitCharacter = Players.LocalPlayer.Character,
                                        HitCharacters = {Players.LocalPlayer.Character},
                                        Ignore = {},
                                        DeathInfo = {},
                                        Actions = {},
                                        HitInfo = {
                                            Blocked = false,
                                            IsFacing = true,
                                            IsInFront = true
                                        },
                                        BlockedCharacters = {},
                                        ServerTime = tick(),
                                        FromCFrame = nil
                                    },
                                    "Action" .. math.random(1000, 9999)
                                )
                            end)
                        end)
                    end
                end
            end)
            
            WindUI:Notify({
                Title = "黑客已开启",
                Content = "正在持续攻击服务器",
                Icon = "flame",
                Duration = 2
            })
        else
            if crashConnection then
                crashConnection:Disconnect()
                crashConnection = nil
            end
            WindUI:Notify({
                Title = "黑客已关闭",
                Content = "已停止攻击",
                Icon = "shield",
                Duration = 2
            })
        end
    end
})

CrashTab:Button({
    Title = "让别人变卡一些卡服",
    Desc = "演技比较好让别人帧率变低",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Players = game:GetService("Players")
        local charValue = Players.LocalPlayer.Data.Character.Value
        local wallComboAbility = ReplicatedStorage.Characters[charValue].WallCombo
        
        for i = 1, 500 do
            task.spawn(function()
                pcall(function()
                    ReplicatedStorage.Remotes.Abilities.Ability:FireServer(wallComboAbility, math.random(100000, 999999))
                    ReplicatedStorage.Remotes.Combat.Action:FireServer(
                        wallComboAbility,
                        charValue .. ":WallCombo",
                        1,
                        math.random(100000, 999999),
                        {
                            HitboxCFrames = {nil},
                            BestHitCharacter = Players.LocalPlayer.Character,
                            HitCharacters = {Players.LocalPlayer.Character},
                            Ignore = {},
                            DeathInfo = {},
                            Actions = {},
                            HitInfo = {
                                Blocked = false,
                                IsFacing = true,
                                IsInFront = true
                            },
                            BlockedCharacters = {},
                            ServerTime = tick(),
                            FromCFrame = nil
                        },
                        "Action" .. math.random(1000, 9999)
                    )
                end)
            end)
        end
        
        WindUI:Notify({
            Title = "💀",
            Content = "帧率已下降",
            Icon = "zap",
            Duration = 2
        })
    end
})

local Players = game:GetService("Players")
local Tab = Window:Tab({
    Title = "碰撞箱扩大",
    Icon = "box",
    Locked = false,
})

pcall(function()
    setthreadidentity(8)
end)

local S = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    Cfg = {
        Hitbox = false,
        X = 150, 
        Y = 150, 
        Z = 150, 
        Multi = 3 
    },
    Cache = {},
    Conn = nil,
    DashT = 0
}
local LP = S.Players.LocalPlayer
getgenv().HitboxEnabled = false

function S:HRP()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

function S:GetCore()
    if self.Cache.Core then
        return self.Cache.Core
    end
    local ok, core = pcall(function()
        return require(self.ReplicatedStorage:WaitForChild("Core", 10))
    end)
    if ok then
        self.Cache.Core = core
        return core
    end
end

function S:ToggleHitbox(state)
    self.Cfg.Hitbox = state
    getgenv().HitboxEnabled = state
    local core = self:GetCore()
    if not core or not core.Get then return end
    local hit = core.Get("Combat", "Hit")
    if not hit or not hit.Box then return end
    
    if state then
        if not self.Cache.OrigBox then
            self.Cache.OrigBox = hit.Box
        end
        
        hit.Box = function(_, char, data)
            data = data or {}
            data.Size = Vector3.new(self.Cfg.X, self.Cfg.Y, self.Cfg.Z)
            return self.Cache.OrigBox(nil, char, data)
        end
    else
        
        if self.Cache.OrigBox then
            hit.Box = self.Cache.OrigBox
        end
    end
end

function S:EnableEnhancer()
    if self.Cache.HitProc then return end
    local ok, hit = pcall(function()
        return require(LP.PlayerScripts:WaitForChild("Combat"):WaitForChild("Hit"))
    end)
    if not ok or not hit.Process then return end
    self.Cache.HitProc = hit.Process
    hit.Process = function(...)
        local best, targets, blocked = self.Cache.HitProc(...)
        if not targets or #targets == 0 then
            return best, targets, blocked
        end
        
        local r = self.ReplicatedStorage.Remotes.Combat.Action
        for _ = 1, self.Cfg.Multi do
            pcall(function()
                r:FireServer(nil, "", 4, 69, {BestHitCharacter=nil, HitCharacters=targets, Ignore={}, Actions={}})
            end)
        end
        return best, targets, blocked
    end
end

function S:DisableEnhancer()
    if not self.Cache.HitProc then return end
    local ok, hit = pcall(function()
        return require(LP.PlayerScripts.Combat.Hit)
    end)
    if ok then
        hit.Process = self.Cache.HitProc
    end
    self.Cache.HitProc = nil
end

function S:StartDashLoop()
    if self.Conn then return end
    self.Conn = self.RunService.Heartbeat:Connect(function()
        if tick() - self.DashT < 0.18 then return end
        self.DashT = tick()
        local hrp = self:HRP()
        if hrp then
            pcall(function()
                self:GetCore().Library("Remote").Send("Dash", hrp.CFrame, "L", 1)
            end)
        end
    end)
end

function S:StopDashLoop()
    if self.Conn then
        self.Conn:Disconnect()
        self.Conn = nil
    end
end

Tab:Toggle({
    Title = "碰撞箱扩大",
    Desc = "开启后扩大攻击碰撞箱，提升命中概率",
    Value = false,
    Callback = function(v)
        if v then
            S:ToggleHitbox(true)
            S:EnableEnhancer()
            S:StartDashLoop()
        else
            S:ToggleHitbox(false)
            S:DisableEnhancer()
            S:StopDashLoop()
        end
    end
})

Tab:Input({
    Title = "碰撞箱X轴",
    Value = tostring(S.Cfg.X),
    Callback = function(v)
        v = tonumber(v)
        if v then
            S.Cfg.X = math.clamp(v, 10, 1000)
            if S.Cfg.Hitbox then
                S:ToggleHitbox(true) 
            end
        end
    end
})

Tab:Input({
    Title = "碰撞箱Y轴",
    Value = tostring(S.Cfg.Y),
    Callback = function(v)
        v = tonumber(v)
        if v then
            S.Cfg.Y = math.clamp(v, 10, 1000)
            if S.Cfg.Hitbox then
                S:ToggleHitbox(true)
            end
        end
    end
})

Tab:Input({
    Title = "碰撞箱Z轴",
    Value = tostring(S.Cfg.Z),
    Callback = function(v)
        v = tonumber(v)
        if v then
            S.Cfg.Z = math.clamp(v, 10, 1000)
            if S.Cfg.Hitbox then
                S:ToggleHitbox(true)
            end
        end
    end
})

local lightningCharacterSwapTab = Window:Tab({
    Title = "快速切换角色",
    Icon = "bird",
    Locked = false,
})

local lastPosition

local function getHumanoidRootPart()
    local character = LocalPlayer.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function savePosition()
    local rootPart = getHumanoidRootPart()
    if rootPart then
        lastPosition = rootPart.CFrame
    end
end

local function handleKeyPress(characterName)
    savePosition()
    
    local rootPart = getHumanoidRootPart()
    if rootPart then
        rootPart.CFrame = CFrame.new(1011.1289672851562, -1009.359588623046875, 116.37605285644531)
    end

    ReplicatedStorage.Remotes.Character.ChangeCharacter:FireServer(characterName)

    local groundY = workspace.Map.Structural.Ground:GetChildren()[21].Position.Y
    repeat task.wait() until getHumanoidRootPart() and getHumanoidRootPart().Position.Y > groundY
    task.wait(0.15)

    local newRootPart = getHumanoidRootPart()
    if newRootPart and lastPosition then
        repeat
            newRootPart.CFrame = lastPosition
            task.wait(0.1)
        until (newRootPart.Position - lastPosition.Position).Magnitude < 10
    end
end

lightningCharacterSwapTab:Button({
    Title = "快速切换成小杰",
    Locked = false,
    Callback = function() handleKeyPress("Gon") end
})

lightningCharacterSwapTab:Button({
    Title = "快速切换成被诅咒的导师",
    Locked = false,
    Callback = function() handleKeyPress("Nanami") end
})

lightningCharacterSwapTab:Button({
    Title = "快速切换成沉默的艾丝帕",
    Locked = false,
    Callback = function() handleKeyPress("Mob") end
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local core = require(ReplicatedStorage:WaitForChild("Core"))
local Character = LocalPlayer.Character
local HumanoidRootPart = Character and Character:WaitForChild("HumanoidRootPart")
local orbitToggle = nil
local fakeWallToggle = nil
local serverStatus = "goodstate"

local forceKillEmoteTab = Window:Tab({
    Title = "击杀表情功能",
    Icon = "smile",
    Locked = false,
})

local killEmotes = {}
local isAuraMode = false
local isSpammingSelectedEmote = false
local auraDelay = 0.5
local spamDelay = 0.5
local selectedEmote = ""
local selectedKeybind = Enum.KeyCode.G
local emoteDropdown

local function getRoot(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function useEmote(emoteName)
    local emoteModule = ReplicatedStorage:WaitForChild("Cosmetics"):WaitForChild("KillEmote"):FindFirstChild(emoteName)
    local myRoot = getRoot(LocalPlayer.Character)
    if not myRoot then return end
    local closestTarget = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetRoot = getRoot(player.Character)
            if targetRoot then
                local distance = (myRoot.Position - targetRoot.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestTarget = player.Character
                end
            end
        end
    end
    if closestTarget and emoteModule then
        task.spawn(function()
            _G.KillEmote = true
            pcall(function()
                if core and core.Get then
                    core.Get("Combat", "Ability").Activate(emoteModule, closestTarget)
                end
            end)
            _G.KillEmote = false
        end)
    end
end

local function useRandomEmote()
    if #killEmotes > 0 then
        local randomEmote = killEmotes[math.random(1, #killEmotes)]
        useEmote(randomEmote)
    end
end

task.spawn(function()
    while true do
        if isAuraMode then
            useRandomEmote()
            task.wait(auraDelay)
        else
            task.wait(0.1)
        end
    end
end)

task.spawn(function()
    while true do
        if isSpammingSelectedEmote and selectedEmote ~= "" then
            useEmote(selectedEmote)
            task.wait(spamDelay)
        else
            task.wait(0.1)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, isGameProcessed)
    if isGameProcessed then return end
    if input.KeyCode == selectedKeybind and selectedEmote ~= "" then
        useEmote(selectedEmote)
    end
end)

local function createOrUpdateEmoteDropdown(emoteList)
    local values = emoteList
    if not values or #values == 0 then
        values = {"No emotes found"}
    end
    emoteDropdown = forceKillEmoteTab:Dropdown({
        Title = "击杀表情功能(要靠近别人)",
        Values = values,
        Multi = false,
        AllowNone = false,
        Callback = function(option)
            if option ~= "No emotes found" then
                selectedEmote = option
                useEmote(option)
            end
        end
    })
end

forceKillEmoteTab:Button({
    Title = "刷新击杀表情",
    Desc = "刷新可用的击杀表情",
    Callback = function()
        local currentEmotes = {}
        for _, emote in pairs(ReplicatedStorage:WaitForChild("Cosmetics"):WaitForChild("KillEmote"):GetChildren()) do
            table.insert(currentEmotes, emote.Name)
        end
        killEmotes = currentEmotes
        createOrUpdateEmoteDropdown(killEmotes)
    end
})

for _, emote in pairs(ReplicatedStorage:WaitForChild("Cosmetics"):WaitForChild("KillEmote"):GetChildren()) do
    table.insert(killEmotes, emote.Name)
end

createOrUpdateEmoteDropdown(killEmotes)

forceKillEmoteTab:Toggle({
    Title = "击杀表情光环",
    Desc = "对旁边的人持续使用随机的击杀表情",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(isEnabled)
        isAuraMode = isEnabled
    end
})

forceKillEmoteTab:Slider({
    Title = "击杀表情光环间隔",
    Step = 0.01,
    Value = { Min = 0.01, Max = 5.0, Default = 0.5 },
    Callback = function(value)
        auraDelay = value
    end
})

forceKillEmoteTab:Toggle({
    Title = "持续发送你选择的表情",
    Desc = "持续发送当前选择的表情",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(isEnabled)
        isSpammingSelectedEmote = isEnabled
    end
})

forceKillEmoteTab:Slider({
    Title = "调整你选择的表情速度",
    Step = 0.01,
    Value = { Min = 0.01, Max = 5.0, Default = 0.5 },
    Callback = function(value)
        spamDelay = value
    end
})

local emoteKeybindOptions = { "G", "F", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M", "Q", "E", "R", "T", "Y", "U", "I", "O", "P" }
local emoteKeybindMap = {
    ["G"] = Enum.KeyCode.G, ["F"] = Enum.KeyCode.F, ["H"] = Enum.KeyCode.H,
    ["J"] = Enum.KeyCode.J, ["K"] = Enum.KeyCode.K, ["L"] = Enum.KeyCode.L,
    ["Z"] = Enum.KeyCode.Z, ["X"] = Enum.KeyCode.X, ["C"] = Enum.KeyCode.C,
    ["V"] = Enum.KeyCode.V, ["B"] = Enum.KeyCode.B, ["N"] = Enum.KeyCode.N,
    ["M"] = Enum.KeyCode.M, ["Q"] = Enum.KeyCode.Q, ["E"] = Enum.KeyCode.E,
    ["R"] = Enum.KeyCode.R, ["T"] = Enum.KeyCode.T, ["Y"] = Enum.KeyCode.Y,
    ["U"] = Enum.KeyCode.U, ["I"] = Enum.KeyCode.I, ["O"] = Enum.KeyCode.O,
    ["P"] = Enum.KeyCode.P
}

forceKillEmoteTab:Dropdown({
    Title = "快捷键设置",
    Values = emoteKeybindOptions,
    Value = "G",
    Multi = false,
    AllowNone = false,
    Callback = function(option)
        selectedKeybind = emoteKeybindMap[option]
    end
})

forceKillEmoteTab:Button({
    Title = "随机用一个击杀表情",
    Desc = "字面意思",
    Locked = false,
    Callback = function()
        useRandomEmote()
    end
})
local MusicTab = Window:Tab({
    Title = "音乐",
    Icon = "music",
    Locked = false,
})

local SoundService = game:GetService("SoundService")

local music1 = Instance.new("Sound")
music1.SoundId = "rbxassetid://107990547300911"
music1.Volume = 1
music1.Looped = true
music1.Parent = SoundService
MusicTab:Toggle({
    Title = "QQ音乐",
    Value = false,
    Callback = function(state)
        if state then music1:Play() else music1:Stop() end
    end
})

MusicTab:Button({
     Title = "网易云音乐",
     Icon = "code",
     Callback = function()
         loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E7%BD%91%E6%98%93%E4%BA%91.lua"))()
         WindUI:Notify({
             Title = "执行成功",
             Content = "网易云音乐",
             Icon = "check",
             Duration = 3
         })
     end
 })

local Tab = Window:Tab({
    Title = "设置",
    Icon = "settings",
    Locked = false,
})
local themeValues = {}
for name, _ in pairs(WindUI:GetThemes()) do
    table.insert(themeValues, name)
end

Tab:Dropdown({
    Title = "更改ui颜色",
    Multi = false,
    AllowNone = false,
    Value = nil,
    Values = themeValues,
    Callback = function(theme)
        WindUI:SetTheme(theme)
    end
})
end

local function createEnglishUI()
local Tab = Window:Tab({
    Title = "function",
    Icon = "sword",
    Locked = false,
})
local HttpService = game:GetService("HttpService")

local InviteCode = "E6meCtvdZ"
local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

local Response = HttpService:JSONDecode(WindUI.Creator.Request({
    Url = DiscordAPI,
    Method = "GET"
}).Body)

if Response and Response.guild then
    local iconUrl = Response.guild.icon and ("https://cdn.discordapp.com/icons/" .. Response.guild.id .. "/" .. Response.guild.icon .. ".png?size=1024") or "rbxassetid://129260712070622"

    Tab:Paragraph({
        Title = Response.guild.name,
        Desc =
            ' <font color="#52525b">●</font> overallpeople: ' .. tostring(Response.approximate_member_count) ..
            '\n <font color="#16a34a">●</font> online: ' .. tostring(Response.approximate_presence_count),
        Image = iconUrl,
        ImageSize = 42,
    })
else
    warn("Discord API Error: ", HttpService:JSONEncode(Response))
end
Tab:Button({
    Title = "copy discord link",
    Callback = function()
        setclipboard("https://discord.gg/E6meCtvdZ")
    end
})
Tab:Button({
    Title = "distort",
    Desc = "Click this function if you want to play spam wallcombo",
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dream77239/ubg-script/refs/heads/main/%E6%8B%A6%E6%88%AA.txt"))()
    end
})
local fakeBlockEnabled = false
local loopRunning = false

Tab:Toggle({
    Title = "fake block",
    Value = false,
    Callback = function(state)
        fakeBlockEnabled = state

        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local BlockRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Block")
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        local function enableBlock()
            pcall(function()
                BlockRemote:FireServer(true)
            end)
        end

        if fakeBlockEnabled then
            enableBlock()
        end

        if not loopRunning then
            loopRunning = true
            task.spawn(function()
                while true do
                    task.wait(0.01)
                    if fakeBlockEnabled then
                        local success, isBlocking = pcall(function()
                            return character:GetAttribute("IsBlocking")
                        end)
                        if success and not isBlocking then
                            enableBlock()
                        end
                    end
                end
            end)
        end
    end
})

local defaultCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Dash.Value

Tab:Toggle({
    Title = "no dash cooldown",
    Value = false,
    Callback = function(state)
        local dashCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Dash
        if state then
            dashCooldown.Value = 1
        else
            dashCooldown.Value = defaultCooldown
        end
    end
})
local defaultMeleeCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Melee.Value

Tab:Toggle({
    Title = "no melee cooldown",
    Value = false,
    Callback = function(state)
        local meleeCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Melee
        if state then
            meleeCooldown.Value = 1
        else
            meleeCooldown.Value = defaultMeleeCooldown
        end
    end
})
local rs = game:GetService("ReplicatedStorage")
local settings = rs.Settings

local defaultAbility = settings.Cooldowns.Ability.Value
Tab:Toggle({
    Title = "no skill cooldown(only sukuna)",
    Value = false,
    Callback = function(state)
        settings.Cooldowns.Ability.Value = state and 1 or defaultAbility
    end
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local noSlowdownsToggle = ReplicatedStorage.Settings.Toggles.NoSlowdowns

local defaultValue = false

Tab:Toggle({
    Title = "no slowdown",
    Value = noSlowdownsToggle.Value,
    Callback = function(state)
        if state then
            noSlowdownsToggle.Value = true
        else
            noSlowdownsToggle.Value = defaultValue
        end
    end
})

local defaultDisableHitStun = settings.Toggles.DisableHitStun.Value
Tab:Toggle({
    Title = "no stun",
    Value = false,
    Callback = function(state)
        settings.Toggles.DisableHitStun.Value = state
    end
})

local defaultDisableIntros = settings.Toggles.DisableIntros.Value
Tab:Toggle({
    Title = "Skip opening action",
    Value = false,
    Callback = function(state)
        settings.Toggles.DisableIntros.Value = state
    end
})

local defaultNoStunOnMiss = settings.Toggles.NoStunOnMiss.Value
Tab:Toggle({
    Title = "Melee no rigidity",
    Value = false,
    Callback = function(state)
        settings.Toggles.NoStunOnMiss.Value = state
    end
})

local defaultRagdollTimer = settings.Multipliers.RagdollTimer.Value
Tab:Toggle({
    Title = "no ragdoll",
    Value = false,
    Callback = function(state)
        settings.Multipliers.RagdollTimer.Value = state and 0.5 or defaultRagdollTimer
    end
})

local defaultUltimateTimer = settings.Multipliers.UltimateTimer.Value
Tab:Toggle({
    Title = "Extend the ultimate time",
    Value = false,
    Callback = function(state)
        settings.Multipliers.UltimateTimer.Value = state and 100000 or defaultUltimateTimer
    end
})
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Ping = player:WaitForChild("Info"):WaitForChild("Ping")

local loop

Tab:Toggle({
    Title = "ping error",
    Value = false,
    Callback = function(state)
        if state then
            loop = task.spawn(function()
                while state do
                    for i = 0, 999, 25 do
                        if not state then break end
                        Ping.Value = i
                        task.wait(0.03)
                    end
                    for i = 999, 0, -25 do
                        if not state then break end
                        Ping.Value = i
                        task.wait(0.03)
                    end
                end
            end)
        else
            if loop then
                task.cancel(loop)
                loop = nil
            end
        end
    end
})
local defaultInstantTransformation = settings.Toggles.InstantTransformation.Value
Tab:Toggle({
    Title = "Open the ultimate immediately",
    Value = false,
    Callback = function(state)
        settings.Toggles.InstantTransformation.Value = state
    end
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MeleeDamage = ReplicatedStorage:WaitForChild("Settings"):WaitForChild("Multipliers"):WaitForChild("MeleeDamage")

MeleeDamage.Value = 100

Tab:Toggle({
    Title = "one punch fall",
    Value = false,
    Callback = function(state)
        if state then
            MeleeDamage.Value = 1000000
        else
            MeleeDamage.Value = 100
        end
    end
})
Tab:Toggle({
    Title = "one punch kill(collocation one punch fall)",
    Value = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RunService = game:GetService("RunService")

        local LocalPlayer = Players.LocalPlayer
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

        local RagdollPower = ReplicatedStorage:WaitForChild("Settings"):WaitForChild("Multipliers"):WaitForChild("RagdollPower")

        local maxTeleportDistance = 50
        local lastPosition = HumanoidRootPart.Position
        local connection

        if state then
            RagdollPower.Value = 10000

            connection = RunService.RenderStepped:Connect(function()
                
                if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                    lastPosition = HumanoidRootPart.Position
                end

                local currentPos = HumanoidRootPart.Position
                local distance = (currentPos - lastPosition).Magnitude

                if distance > maxTeleportDistance then
                    HumanoidRootPart.CFrame = CFrame.new(lastPosition)
                else
                    lastPosition = currentPos
                end
            end)
        else
            RagdollPower.Value = 100
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local wallCombo = ReplicatedStorage.Settings.Cooldowns.WallCombo

Tab:Toggle({
    Title = "wallcombo no cooldown",
    Value = false,
    Callback = function(state)
        if state then
            wallCombo.Value = 0
            print("WallCombo cooldown set to 0")
        else
            wallCombo.Value = 100
            print("WallCombo cooldown reset to 100")
        end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local wall = nil
pcall(function()
    wall = workspace.Map.Structural.Terrain:GetChildren()[5]:GetChildren()[12]
end)

if not wall then
    wall = Instance.new("Part")
    wall.Parent = workspace
end

wall.Size = Vector3.new(12,6,2)
wall.Transparency = 0.6
wall.Material = Enum.Material.SmoothPlastic
wall.Anchored = true
wall.CanCollide = true
wall.CFrame = wall.CFrame or CFrame.new(0,5,0)

if getconnections then
    for _, conn in pairs(getconnections(wall.AncestryChanged)) do
        conn:Disable()
    end
end

local mt = getrawmetatable(game)
setreadonly(mt,false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if self == wall and method == "Destroy" then
        return
    end
    return old(self, ...)
end)
setreadonly(mt,true)

local followConnection = nil
Tab:Toggle({
    Title = "wallcombo anywhere",
    Value = false,
    Callback = function(state)
        if state then
            if not followConnection then
                followConnection = RunService.RenderStepped:Connect(function()
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        wall.CFrame = hrp.CFrame * CFrame.new(0,0,-8)
                    end
                end)
            end
        else
            if followConnection then
                followConnection:Disconnect()
                followConnection = nil
            end
        end
    end
})
local originalData = {}
local skyBackup = nil

Tab:Toggle({
    Title = "antiLag",
    Value = false,
    Callback = function(state)
        if state then
            originalData = {}
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Explosion") then
                    originalData[v] = v.Enabled
                    v.Enabled = false
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    originalData[v] = v.Transparency
                    v.Transparency = 1
                elseif v:IsA("MeshPart") or v:IsA("UnionOperation") or v:IsA("Part") then
                    if v.Name ~= "HumanoidRootPart" then
                        originalData[v] = v.Material
                        v.Material = Enum.Material.SmoothPlastic
                    end
                elseif v:IsA("SurfaceGui") or v:IsA("BillboardGui") or v:IsA("Beam") then
                    if v:IsA("Beam") then
                        originalData[v] = v.Enabled
                        v.Enabled = false
                    else
                        originalData[v] = v.Enabled ~= nil and v.Enabled or true
                        if v.Enabled ~= nil then
                            v.Enabled = false
                        end
                    end
                end
            end
            originalData["GlobalShadows"] = game.Lighting.GlobalShadows
            originalData["FogEnd"] = game.Lighting.FogEnd
            game.Lighting.GlobalShadows = false
            game.Lighting.FogEnd = 9e9
            local sky = game.Lighting:FindFirstChildOfClass("Sky")
            if sky then
                skyBackup = sky:Clone()
                sky:Destroy()
            end
            local newSky = Instance.new("Sky")
            newSky.SkyboxBk = ""
            newSky.SkyboxDn = ""
            newSky.SkyboxFt = ""
            newSky.SkyboxLf = ""
            newSky.SkyboxRt = ""
            newSky.SkyboxUp = ""
            newSky.SunAngularSize = 0
            newSky.MoonAngularSize = 0
            newSky.Parent = game.Lighting
            game.Lighting.Ambient = Color3.fromRGB(128,128,128)
            game.Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
        else
            for obj, value in pairs(originalData) do
                if typeof(obj) == "Instance" and obj.Parent then
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Explosion") then
                        obj.Enabled = value
                    elseif obj:IsA("Decal") or obj:IsA("Texture") then
                        obj.Transparency = value
                    elseif obj:IsA("MeshPart") or obj:IsA("UnionOperation") or obj:IsA("Part") then
                        obj.Material = value
                    elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") or obj:IsA("Beam") then
                        if obj:IsA("Beam") then
                            obj.Enabled = value
                        elseif obj.Enabled ~= nil then
                            obj.Enabled = value
                        end
                    end
                elseif obj == "GlobalShadows" then
                    game.Lighting.GlobalShadows = value
                elseif obj == "FogEnd" then
                    game.Lighting.FogEnd = value
                end
            end
            if skyBackup then
                local currentSky = game.Lighting:FindFirstChildOfClass("Sky")
                if currentSky then
                    currentSky:Destroy()
                end
                skyBackup.Parent = game.Lighting
                skyBackup = nil
            end
            originalData = {}
        end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

local clone, platform, originalCFrame, originalCameraSubject

local function CreatePlatform(position)
    local part = Instance.new("Part")
    part.Size = Vector3.new(10, 1, 10)
    part.Position = position - Vector3.new(0, 3, 0)
    part.Anchored = true
    part.CanCollide = true
    part.Transparency = 0.5
    part.Parent = workspace
    return part
end

local function CreateClone()
    local newClone = Character:Clone()
    for _, v in ipairs(newClone:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = 0.5
        end
    end
    newClone.Parent = workspace
    return newClone
end

local function ToggleInvisibility(state)
    if state then
        originalCFrame = HumanoidRootPart.CFrame
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, -50, 0)
        platform = CreatePlatform(HumanoidRootPart.Position)
        
        task.wait(1)
        
        clone = CreateClone()
        clone:MoveTo(originalCFrame.Position)
        Camera.CameraSubject = clone:FindFirstChildWhichIsA("Humanoid")
        LocalPlayer.Character = clone
    else
        if clone then
            clone:Destroy()
            clone = nil
        end
        
        if platform then
            platform:Destroy()
            platform = nil
        end
        
        if originalCFrame then
            HumanoidRootPart.CFrame = originalCFrame
            originalCFrame = nil
        end
        
        Camera.CameraSubject = Character:FindFirstChildWhichIsA("Humanoid")
        LocalPlayer.Character = Character
    end
end

Tab:Toggle({
    Title = "invisible",
    Value = false,
    Callback = ToggleInvisibility
})
local v_u_1 = require(game.ReplicatedStorage:WaitForChild("Core"))
local v155 = game.Players.LocalPlayer:WaitForChild("Data"):WaitForChild("Character")
local v156 = game.ReplicatedStorage.Characters:FindFirstChild(v155.Value):FindFirstChild("WallCombo")
local v158 = Vector3.new(7, 5, 7)
local v159 = CFrame.new(0, 0, 0)
local v160 = v_u_1.Get("Character", "FullCustomReplication").GetCFrame()
local v163 = game.Players.LocalPlayer.Character

local v167 = {
    ["Size"] = v158,
    ["Offset"] = v159,
    ["CustomValidation"] = function()
        return true
    end,
}

local v_u_168 = v_u_1.Get("Combat", "Hit").Box(nil, v163, v167)
local v58 = v156:GetAttribute("Interrupt")

function Run(p_u_7, p8, p_u_9, p10, ...)
    local v_u_11 = p_u_7 and p_u_7:FindFirstChild("Humanoid") or p_u_7
    local v_u_12 = p_u_7 and p_u_7:FindFirstChild("HumanoidRootPart") or p_u_7
    if p_u_7 and (v_u_11 and v_u_12) then
        local v_u_13 = p_u_7 == game.Players.LocalPlayer.Character
        local v_u_17 = p8
        v_u_1.Get("Combat", "Cancel").Init(v_u_17, p_u_9, p_u_7)
        v_u_1.Get("Combat", "Cancel").Set(v_u_17, p_u_9, p_u_7, "Timeout")
        local v_u_36 = { ... }
        task.spawn(function()
            local v37 = {}
            local v38 = v_u_36
            for i, v in ipairs({ p_u_7, v_u_11, v_u_12, v_u_13, p_u_9 }) do
                v37[i] = v
            end
            for i, v in ipairs(v38) do
                v37[#v37 + 1] = v
            end
            v_u_1.Get("Cosmetics", "KillEmote").RunAfter(v_u_17, table.unpack(v37))
        end)
    end
end

local originPos = v160.Position
local rs = game:GetService("RunService")
local running = false

Tab:Toggle({
    Title = "killaura",
    Value = false,
    Callback = function(state)
        running = state
        if running then
            rs:BindToRenderStep("KillAura", Enum.RenderPriority.Input.Value, function()
                local pos = originPos + v160.LookVector * 6
                for i = 1, 4 do
                    task.spawn(function()
                        v_u_1.Library("Remote").Send("Ability", v156, 9e9, v58, v_u_168, pos)
                        Run(game.Players.LocalPlayer.Character, v156, 9e9, v58, v_u_168, pos)
                    end)
                end
            end)
        else
            rs:UnbindFromRenderStep("KillAura")
        end
    end
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local wallComboSpamming = false
local wallComboHeartbeat = nil
local wallComboPerFrame = 2
local wallComboKeybind = Enum.KeyCode.E

local core = require(ReplicatedStorage.Core)
local chars = ReplicatedStorage.Characters
local char = LocalPlayer.Data.Character

local function executeWallCombo()
    local head = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not head then return end

    local res = core.Get("Combat","Hit").Box(nil, LocalPlayer.Character, {Size = Vector3.new(50,50,50)})
    if res then
        local success, err = pcall(core.Get("Combat","Ability").Activate, chars[char.Value].WallCombo, res, head.Position + Vector3.new(0,0,2.5))
        if not success then
            warn(err)
        end
    end
end

local function updateWallComboHeartbeat()
    if wallComboHeartbeat then
        wallComboHeartbeat:Disconnect()
        wallComboHeartbeat = nil
    end
    if wallComboSpamming then
        wallComboHeartbeat = RunService.Heartbeat:Connect(function()
            for i = 1, wallComboPerFrame do
                executeWallCombo()
            end
        end)
    end
end

UserInputService.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end
    if input.KeyCode == wallComboKeybind then
        executeWallCombo()
    end
end)

Tab:Toggle({
    Title = "spam wallcombo",
    Value = false,
    Callback = function(state)
        wallComboSpamming = state
        updateWallComboHeartbeat()
    end
})
Tab:Button({
    Title = "Delete the spam wallcombo special effects",
    Desc = "Click this function, you can't restore the wall special effects",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local paths = {
            ReplicatedStorage.Characters.Gon.WallCombo.GonWallCombo.Center,
            ReplicatedStorage.Characters.Gon.WallCombo.GonWallCombo.Explosion,
            ReplicatedStorage.Characters.Gon.WallCombo.GonIntroHands,
            ReplicatedStorage.Characters.Mob.WallCombo.MobWallCombo.Center,
            ReplicatedStorage.Characters.Nanami.WallCombo.NanamiWallCombo.Center,
            ReplicatedStorage.Characters.Stark.WallCombo.StarkWallCombo.Center,
            ReplicatedStorage.Characters.Sukuna.WallCombo.SukunaTransformWallCombo,
            ReplicatedStorage.Characters.Sukuna.WallCombo.SukunaWallCombo
        }

        for _, obj in ipairs(paths) do
            if obj and obj:IsA("Instance") then
                for _, child in ipairs(obj:GetChildren()) do
                    child:Destroy()
                end
            end
        end
    end
})
Tab:Button({
    Title = "Delete the kill emoticon effect",
    Desc = "Click delete to kill some special effects of the expression, which cannot be recovered",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local KillEmote = ReplicatedStorage:WaitForChild("Cosmetics"):WaitForChild("KillEmote")

        local function removeEffects(obj)
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("ParticleEmitter") 
                or child:IsA("Trail") 
                or child:IsA("Beam") 
                or child:IsA("Fire") 
                or child:IsA("Smoke") 
                or child:IsA("Sparkles") 
                or child:IsA("Light") then
                    child:Destroy()
                else
                    removeEffects(child)
                end
            end
        end

        removeEffects(KillEmote)
        print("KillEmote 特效已删除（保留本体）")
    end
})
 local ReplicatedStorage = game:GetService("ReplicatedStorage")
local multiUseCutscenesToggle = ReplicatedStorage.Settings.Toggles.MultiUseCutscenes

local defaultValue = false

Tab:Toggle({
    Title = "Esper's big move skill used many times",
    Value = multiUseCutscenesToggle.Value,
    Callback = function(state)
        if state then
            multiUseCutscenesToggle.Value = true
        else
            multiUseCutscenesToggle.Value = defaultValue
        end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local tpwalking = false
local tpwalkSpeed = 100

Tab:Toggle({
    Title = "tpwalk",
    Value = false,
    Callback = function(state)
        tpwalking = state
        if state then
            spawn(function()
                while tpwalking do
                    local chr = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local hrp = chr:FindFirstChild("HumanoidRootPart")
                    local hum = chr:FindFirstChildWhichIsA("Humanoid")
                    local delta = RunService.Heartbeat:Wait()
                    if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * tpwalkSpeed * delta)
                    end
                end
            end)
        end
    end
})

Tab:Slider({
    Title = "tpwalk set",
    Value = {
        Min = 0,
        Max = 250,
        Default = tpwalkSpeed,
    },
    Callback = function(value)
        tpwalkSpeed = value
    end
})
Tab:Slider({
    Title = "dash speed",
    Value = {
        Min = 0,
        Max = 1000,
        Default = 100,
    },
    Callback = function(value)
        game:GetService("ReplicatedStorage").Settings.Multipliers.DashSpeed.Value = value
    end
})

Tab:Slider({
    Title = "jump power",
    Value = {
        Min = 0,
        Max = 1000,
        Default = 100,
    },
    Callback = function(value)
        game:GetService("ReplicatedStorage").Settings.Multipliers.JumpHeight.Value = value
    end
})

Tab:Slider({
    Title = "melee speed",
    Value = {
        Min = 0,
        Max = 1000,
        Default = 100,
    },
    Callback = function(value)
        game:GetService("ReplicatedStorage").Settings.Multipliers.MeleeSpeed.Value = value
    end
})
local Players = game:GetService("Players")
local Tab = Window:Tab({
    Title = "hit box",
    Icon = "box",
    Locked = false,
})

local expansionMethod = "Add"
local hitboxX, hitboxY, hitboxZ = 0, 0, 0
local isHitboxExpanded = false
local hitModuleTable = nil
local originalBox = nil
local sizeModifier = Vector3.new(0, 0, 0)

local function setupHitboxHook()
    if hitModuleTable and hitModuleTable._boxSizeModifierHookInstalled then
        print("Hitbox hook already installed.")
        return true
    end
    
    local player = Players.LocalPlayer
    local playerScripts = player:WaitForChild("PlayerScripts")
    local combatFolder = playerScripts:WaitForChild("Combat")
    local hitModule = combatFolder:WaitForChild("Hit")
    
    hitModuleTable = require(hitModule)
    originalBox = hitModuleTable.Box
    
    hitModuleTable.Box = function(...)
        local args = {...}
        if args[3] and typeof(args[3]) == "table" then
            local config = args[3]
            if config.Size and typeof(config.Size) == "Vector3" then
                if not config._originalSize then
                    config._originalSize = config.Size
                end
                if expansionMethod == "Set" then
                    config.Size = sizeModifier
                elseif expansionMethod == "Add" then
                    config.Size = config._originalSize + sizeModifier
                end
            end
            return originalBox(...)
        else
            return originalBox(...)
        end
    end
    hitModuleTable._boxSizeModifierHookInstalled = true
    return true
end

local function applySigmaHitbox(x, y, z)
    if not setupHitboxHook() then
        warn("Failed to setup hitbox hook!")
        return
    end
    sizeModifier = Vector3.new(x, y, z)
    print("Sigma hitbox expansion applied:", sizeModifier)
end

Tab:Input({
    Title = "X",
    Value = "0",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "输入一个数字...",
    Callback = function(input)
        hitboxX = tonumber(input) or 0
        print("Hitbox X vector set to:", hitboxX)
    end
})

Tab:Input({
    Title = "Y",
    Value = "0",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "输入一个数字...",
    Callback = function(input)
        hitboxY = tonumber(input) or 0
        print("Hitbox Y vector set to:", hitboxY)
    end
})

Tab:Input({
    Title = "Z",
    Value = "0",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "输入一个数字...",
    Callback = function(input)
        hitboxZ = tonumber(input) or 0
        print("Hitbox Z vector set to:", hitboxZ)
    end
})

Tab:Dropdown({
    Title = "Extension method",
    Values = {"Add", "Set"},
    Value = "Add",
    Multi = false,
    AllowNone = false,
    Callback = function(option)
        expansionMethod = option
        print("Hitbox method set to:", expansionMethod)
    end
})

Tab:Button({
    Title = "Apply collision box modification",
    Desc = nil,
    Locked = false,
    Callback = function()
        applySigmaHitbox(hitboxX, hitboxY, hitboxZ)
        isHitboxExpanded = true
    end
})

Tab:Button({
    Title = "Slight expansion(5)",
    Desc = nil,
    Locked = false,
    Callback = function()
        hitboxX, hitboxY, hitboxZ = 5, 5, 5
        applySigmaHitbox(hitboxX, hitboxY, hitboxZ)
        isHitboxExpanded = true
    end
})

Tab:Button({
    Title = "Mesomorphic extension(10)",
    Desc = nil,
    Locked = false,
    Callback = function()
        hitboxX, hitboxY, hitboxZ = 10, 10, 10
        applySigmaHitbox(hitboxX, hitboxY, hitboxZ)
        isHitboxExpanded = true
    end
})

Tab:Button({
    Title = "Large expansion(20)",
    Desc = nil,
    Locked = false,
    Callback = function()
        hitboxX, hitboxY, hitboxZ = 20, 20, 20
        applySigmaHitbox(hitboxX, hitboxY, hitboxZ)
        isHitboxExpanded = true
    end
})
local lightningCharacterSwapTab = Window:Tab({
    Title = "Fast switching role function",
    Icon = "bird",
    Locked = false,
})

local lastPosition

local function getHumanoidRootPart()
    local character = LocalPlayer.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function savePosition()
    local rootPart = getHumanoidRootPart()
    if rootPart then
        lastPosition = rootPart.CFrame
    end
end

local function handleKeyPress(characterName)
    savePosition()
    
    local rootPart = getHumanoidRootPart()
    if rootPart then
        rootPart.CFrame = CFrame.new(1011.1289672851562, -1009.359588623046875, 116.37605285644531)
    end

    ReplicatedStorage.Remotes.Character.ChangeCharacter:FireServer(characterName)

    local groundY = workspace.Map.Structural.Ground:GetChildren()[21].Position.Y
    repeat task.wait() until getHumanoidRootPart() and getHumanoidRootPart().Position.Y > groundY
    task.wait(0.15)

    local newRootPart = getHumanoidRootPart()
    if newRootPart and lastPosition then
        repeat
            newRootPart.CFrame = lastPosition
            task.wait(0.1)
        until (newRootPart.Position - lastPosition.Position).Magnitude < 10
    end
end

lightningCharacterSwapTab:Button({
    Title = "Quickly switch to mob",
    Locked = false,
    Callback = function() handleKeyPress("Gon") end
})

lightningCharacterSwapTab:Button({
    Title = "Quick switch to nanami",
    Locked = false,
    Callback = function() handleKeyPress("Nanami") end
})

lightningCharacterSwapTab:Button({
    Title = "Quick switch to esper",
    Locked = false,
    Callback = function() handleKeyPress("Mob") end
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local core = require(ReplicatedStorage:WaitForChild("Core"))
local Character = LocalPlayer.Character
local HumanoidRootPart = Character and Character:WaitForChild("HumanoidRootPart")
local orbitToggle = nil
local fakeWallToggle = nil
local serverStatus = "goodstate"

local forceKillEmoteTab = Window:Tab({
    Title = "kill emote",
    Icon = "smile",
    Locked = false,
})

local killEmotes = {}
local isAuraMode = false
local isSpammingSelectedEmote = false
local auraDelay = 0.5
local spamDelay = 0.5
local selectedEmote = ""
local selectedKeybind = Enum.KeyCode.G
local emoteDropdown

local function getRoot(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function useEmote(emoteName)
    local emoteModule = ReplicatedStorage:WaitForChild("Cosmetics"):WaitForChild("KillEmote"):FindFirstChild(emoteName)
    local myRoot = getRoot(LocalPlayer.Character)
    if not myRoot then return end
    local closestTarget = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetRoot = getRoot(player.Character)
            if targetRoot then
                local distance = (myRoot.Position - targetRoot.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestTarget = player.Character
                end
            end
        end
    end
    if closestTarget and emoteModule then
        task.spawn(function()
            _G.KillEmote = true
            pcall(function()
                if core and core.Get then
                    core.Get("Combat", "Ability").Activate(emoteModule, closestTarget)
                end
            end)
            _G.KillEmote = false
        end)
    end
end

local function useRandomEmote()
    if #killEmotes > 0 then
        local randomEmote = killEmotes[math.random(1, #killEmotes)]
        useEmote(randomEmote)
    end
end

task.spawn(function()
    while true do
        if isAuraMode then
            useRandomEmote()
            task.wait(auraDelay)
        else
            task.wait(0.1)
        end
    end
end)

task.spawn(function()
    while true do
        if isSpammingSelectedEmote and selectedEmote ~= "" then
            useEmote(selectedEmote)
            task.wait(spamDelay)
        else
            task.wait(0.1)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, isGameProcessed)
    if isGameProcessed then return end
    if input.KeyCode == selectedKeybind and selectedEmote ~= "" then
        useEmote(selectedEmote)
    end
end)

local function createOrUpdateEmoteDropdown(emoteList)
    local values = emoteList
    if not values or #values == 0 then
        values = {"No emotes found"}
    end
    emoteDropdown = forceKillEmoteTab:Dropdown({
        Title = "Kill emote function(need to be close to others)",
        Values = values,
        Multi = false,
        AllowNone = false,
        Callback = function(option)
            if option ~= "No emotes found" then
                selectedEmote = option
                useEmote(option)
            end
        end
    })
end

forceKillEmoteTab:Button({
    Title = "Refresh the available kill emote",
    Desc = ":p",
    Callback = function()
        local currentEmotes = {}
        for _, emote in pairs(ReplicatedStorage:WaitForChild("Cosmetics"):WaitForChild("KillEmote"):GetChildren()) do
            table.insert(currentEmotes, emote.Name)
        end
        killEmotes = currentEmotes
        createOrUpdateEmoteDropdown(killEmotes)
    end
})

for _, emote in pairs(ReplicatedStorage:WaitForChild("Cosmetics"):WaitForChild("KillEmote"):GetChildren()) do
    table.insert(killEmotes, emote.Name)
end

createOrUpdateEmoteDropdown(killEmotes)

forceKillEmoteTab:Toggle({
    Title = "Kill aura of expression",
    Desc = ":p",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(isEnabled)
        isAuraMode = isEnabled
    end
})

forceKillEmoteTab:Slider({
    Title = "Kill emote halo interval",
    Step = 0.01,
    Value = { Min = 0.01, Max = 5.0, Default = 0.5 },
    Callback = function(value)
        auraDelay = value
    end
})

forceKillEmoteTab:Toggle({
    Title = "Keep sending kill emote of your choice",
    Desc = "nothing",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(isEnabled)
        isSpammingSelectedEmote = isEnabled
    end
})

forceKillEmoteTab:Slider({
    Title = "Adjust your currently selected kill emote aura",
    Step = 0.01,
    Value = { Min = 0.01, Max = 5.0, Default = 0.5 },
    Callback = function(value)
        spamDelay = value
    end
})

local emoteKeybindOptions = { "G", "F", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M", "Q", "E", "R", "T", "Y", "U", "I", "O", "P" }
local emoteKeybindMap = {
    ["G"] = Enum.KeyCode.G, ["F"] = Enum.KeyCode.F, ["H"] = Enum.KeyCode.H,
    ["J"] = Enum.KeyCode.J, ["K"] = Enum.KeyCode.K, ["L"] = Enum.KeyCode.L,
    ["Z"] = Enum.KeyCode.Z, ["X"] = Enum.KeyCode.X, ["C"] = Enum.KeyCode.C,
    ["V"] = Enum.KeyCode.V, ["B"] = Enum.KeyCode.B, ["N"] = Enum.KeyCode.N,
    ["M"] = Enum.KeyCode.M, ["Q"] = Enum.KeyCode.Q, ["E"] = Enum.KeyCode.E,
    ["R"] = Enum.KeyCode.R, ["T"] = Enum.KeyCode.T, ["Y"] = Enum.KeyCode.Y,
    ["U"] = Enum.KeyCode.U, ["I"] = Enum.KeyCode.I, ["O"] = Enum.KeyCode.O,
    ["P"] = Enum.KeyCode.P
}

forceKillEmoteTab:Dropdown({
    Title = "Shortcut key setting",
    Values = emoteKeybindOptions,
    Value = "G",
    Multi = false,
    AllowNone = false,
    Callback = function(option)
        selectedKeybind = emoteKeybindMap[option]
    end
})

forceKillEmoteTab:Button({
    Title = "Randomly use a kill emote",
    Desc = "Literal meaning",
    Locked = false,
    Callback = function()
        useRandomEmote()
    end
})
local MusicTab = Window:Tab({
    Title = "music",
    Icon = "music",
    Locked = false,
})

local SoundService = game:GetService("SoundService")

local music1 = Instance.new("Sound")
music1.SoundId = "rbxassetid://107990547300911"
music1.Volume = 1
music1.Looped = true
music1.Parent = SoundService
MusicTab:Toggle({
    Title = "QQ音乐已失效",
    Value = false,
    Callback = function(state)
        if state then music1:Play() else music1:Stop() end
    end
})

MusicTab:Button({
     Title = "网易云音乐",
     Icon = "code",
     Callback = function()
         loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E7%BD%91%E6%98%93%E4%BA%91.lua"))()
         WindUI:Notify({
             Title = "执行成功",
             Content = "网易云音乐",
             Icon = "check",
             Duration = 3
         })
     end
 })

local Tab = Window:Tab({
    Title = "setting",
    Icon = "settings",
    Locked = false,
})
local themeValues = {}
for name, _ in pairs(WindUI:GetThemes()) do
    table.insert(themeValues, name)
end

Tab:Dropdown({
    Title = "Change ui color",
    Multi = false,
    AllowNone = false,
    Value = nil,
    Values = themeValues,
    Callback = function(theme)
        WindUI:SetTheme(theme)
    end
})
end

LangTab:Button({
    Title = "中文",
    Callback = function()
        createChineseUI()
    end
})

LangTab:Button({
    Title = "English",
    Callback = function()
        createEnglishUI()
    end
})

local MainScript = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/终极战场通知.lua"))()
]]

queue_on_teleport(MainScript)