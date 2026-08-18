-- 初始化 WindUI
local WindUI
do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)
    if ok then
        WindUI = result
    else 
        WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Potato5466794/Wind/refs/heads/main/Wind.luau"))()
    end
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Subtitles = require(ReplicatedStorage.UI.Modules.Subtitles)

local player = Players.LocalPlayer

local AUDIO_IDS = {
    red_eyes_01 = 118285668249883,
    system_01 = 101196436867574,
    red_eyes_02 = 79795517272309,
    red_eyes_03 = 77138874517096,
    red_eyes_04 = 113442545987763,
    red_eyes_death_01 = 100522332445068,
    red_eyes_revive_01 = 100522332445068,
}

local function playSound(audioId)
    if not audioId then return end
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(audioId)
    sound.Volume = 0.7
    sound.Parent = workspace
    sound:Play()
    
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

local function sayWithVoice(speaker, text, duration, audioKey)
    Subtitles.say(speaker, text, duration)
    
    if audioKey and AUDIO_IDS[audioKey] then
        task.spawn(function()
            playSound(AUDIO_IDS[audioKey])
        end)
    end
    
    task.wait(duration)
end
if not player.Character then
    player.CharacterAdded:Wait()
end


local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local LocalPlayer = Players.LocalPlayer

local speeds = 1
local nowe = false
local tis
local dis
local tpwalking = false
local SPEED_LIMIT = 10
local isAntiSelfDamage = false
local isAntiKnockback = false
local isAntiRagdoll = false
local namecallHook1 = nil
local namecallHook2 = nil
local renderConnection = nil

-- WindUI 初始化
local Window = WindUI:CreateWindow({
    Title = "<font color='#FFFFFF'>X</font><font color='#D9D9D9'>I</font><font color='#B3B3B3'>A</font><font color='#8C8C8C'>O</font><font color='#666666'>X</font><font color='#404040'>I</font> <font color='#8C8C8C'>H</font><font color='#666666'>U</font><font color='#404040'>B</font> <font color='#8C8C8C'>|</font> <font color='#666666'>G</font><font color='#404040'>B</font><font color='#FFAEC4'></font>",
    Folder = "XKScript",
    NewElements = true,
    HideSearchBar = false,
    Size = UDim2.fromOffset(600, 450),
    Theme = "Dark",
    UserEnabled = true,
    SideBarWidth = 135,
    HasOutline = true,
    Background = "https://raw.githubusercontent.com/xiaoxi9008/Mysterious-coral./refs/heads/main/1777784268833.jpeg",
})

Window:EditOpenButton({
    Title = "<font color='#FFFFFF'>X</font><font color='#D9D9D9'>I</font><font color='#B3B3B3'>A</font><font color='#8C8C8C'>O</font><font color='#666666'>X</font><font color='#404040'>I</font> <font color='#8C8C8C'>H</font><font color='#666666'>U</font><font color='#404040'>B</font> <font color='#8C8C8C'>|</font> <font color='#666666'>G</font><font color='#404040'>B</font><font color='#FFAEC4'></font>",
    CornerRadius = UDim.new(0, 12),
    StrokeThickness = 1,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 128, 128)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }),
    Draggable = true,
    TitleSettings = {
        RichText = true
    }
})

Window:Tag({ Title = "破解版", Radius = 10, Color = Color3.fromHex("#ffffff") })
    Window:Tag({ Title = "内脏与黑火药", Radius = 10, Color = Color3.fromHex("#ffffff") })
    
-- 黑白渐变边框效果
local function startGrayscaleBorder()
    local mainFrame = Window.UIElements and Window.UIElements.Main
    if not mainFrame then
        task.wait(0.2)
        mainFrame = Window.UIElements and Window.UIElements.Main
        if not mainFrame then
            warn("无法找到窗口主框架")
            return
        end
    end
    
    local corner = mainFrame:FindFirstChildOfClass("UICorner")
    if not corner then
        corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
    end
    
    local oldStroke = mainFrame:FindFirstChild("GrayscaleStroke")
    if oldStroke then oldStroke:Destroy() end
    
    local colorScheme = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FFFFFF")),
        ColorSequenceKeypoint.new(0.25, Color3.fromHex("CCCCCC")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("999999")),
        ColorSequenceKeypoint.new(0.75, Color3.fromHex("666666")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("333333"))
    })
    
    local stroke = Instance.new("UIStroke")
    stroke.Name = "GrayscaleStroke"
    stroke.Thickness = 3
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Parent = mainFrame
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = colorScheme
    gradient.Rotation = 0
    gradient.Parent = stroke
    
    local angle = 0
    local animationConnection = game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
        if not stroke or stroke.Parent == nil then
            animationConnection:Disconnect()
            return
        end
        angle = (angle + 180 * deltaTime) % 360
        gradient.Rotation = angle
    end)
    
    print("黑白渐变边框动画已启动")
    return animationConnection
end

startGrayscaleBorder()

local LP = game.Players.LocalPlayer
local MS = game:GetService("MarketplaceService")

-- Tabs
local Tabs = {}

-- 创建所有标签页的函数
local function createTabs()
    Tabs.w = Window:Tab({
        Title = "主要功能",
        Icon = "solar:shield-check-bold",
        IconColor = Color3.fromHex("#999999"),
    })
    Tabs.e = Window:Tab({
        Title = "透视",
        Icon = "solar:eye-bold",
        IconColor = Color3.fromHex("#999999"),
    })
    Tabs.r = Window:Tab({
        Title = "杀戮光环",
        Icon = "solar:sword-bold",
        IconColor = Color3.fromHex("#999999"),
    })
    Tabs.y = Window:Tab({
        Title = "玩家",
        Icon = "solar:users-bold",
        IconColor = Color3.fromHex("#999999"),
    })
    Tabs.u = Window:Tab({
        Title = "职业",
        Icon = "solar:heart-bold",
        IconColor = Color3.fromHex("#999999"),
    })
    Tabs.p = Window:Tab({
        Title = "其他",
        Icon = "solar:settings-bold",
        IconColor = Color3.fromHex("#999999"),
    })
    Tabs["界面设置"] = Window:Tab({
        Title = "界面设置",
        Icon = "solar:gear-bold",
        IconColor = Color3.fromHex("#999999"),
    })
end

createTabs()

Tabs.about = Window:Tab({
    Title = "公告",
    Icon = "solar:info-square-bold",
    IconColor = Color3.fromHex("#999999"),
})

Tabs.about:Paragraph({
    Title = "欢迎使用 <font color='#FFFFFF'>X</font><font color='#D9D9D9'>I</font><font color='#B3B3B3'>A</font><font color='#8C8C8C'>O</font><font color='#666666'>X</font><font color='#404040'>I</font> <font color='#8C8C8C'>H</font><font color='#666666'>U</font><font color='#404040'>B</font> <font color='#8C8C8C'>|</font> <font color='#666666'>G</font><font color='#404040'>B</font><font color='#FFAEC4'></font> 脚本",
    Desc = "作者：BkFd｜这个服务器刺刀每次重生都得开一次飞行不建议开我飞一会就600了",
    ImageSize = 50,
    Thumbnail = "https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/Image_1774762956572_963.jpg",
    ThumbnailSize = 170
})

Tabs.about:Divider()

AboutTab:Keybind({
    Flag = "KeybindTest",
    Title = "快捷键",
    Desc = "打开UI的快捷键",
    Value = "G",
    Callback = function(v) 
        Window:SetToggleKey(Enum.KeyCode[v]) 
    end
})

Tabs.about:Button({
    Title = "显示欢迎通知",
    Icon = "bell",
    Callback = function()
        WindUI:Notify({
            Title = "欢迎!",
            Content = "感谢使用<font color='#FFFFFF'>X</font><font color='#D9D9D9'>I</font><font color='#B3B3B3'>A</font><font color='#8C8C8C'>O</font><font color='#666666'>X</font><font color='#404040'>I</font> <font color='#8C8C8C'>H</font><font color='#666666'>U</font><font color='#404040'>B</font> <font color='#8C8C8C'>|</font> <font color='#666666'>G</font><font color='#404040'>B</font><font color='#FFAEC4'></font>",
            Icon = "heart",
            Duration = 3
        })
    end
})

local ToggleValues = {}
local SliderValues = {}
local function getToggle(name)
    return ToggleValues[name] or false
end
local function setToggle(name, value)
    ToggleValues[name] = value
end
local function getSlider(name)
    return SliderValues[name] or 0
end
local function setSlider(name, value)
    SliderValues[name] = value
end

-- 通知函数
local function Notify(title, description, duration)
    WindUI:Notify({
        Title = title or "通知",
        Content = description or "",
        Duration = duration or 2,
        Icon = "bell",
    })
end

-- ########## 主要功能 标签页 ##########
do
    -- 获取区域
    local gm = Tabs.w:Section({
        Title = "获取",
        Description = "获取物品"
    })

    gm:Button({
        Title = "Voivode",
        Color = Color3.fromHex("#999999"),
        Callback = function()
            local h = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Customize"):WaitForChild("PurchaseEvent")
            h:FireServer("Voivode")
        end
    })

    gm:Button({
        Title = "Iron Stake",
        Color = Color3.fromHex("#999999"),
        Callback = function()
            local h = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Customize"):WaitForChild("PurchaseEvent")
            h:FireServer("Iron Stake")
        end
    })

    -- 视角区域
    local sj = Tabs.w:Section({
        Title = "视角",
        Description = "视角设置"
    })

    local noRecoilEnabled = false
    local recoilConnection = nil

    local function toggleAntiSelfDamage(state)
        noRecoilEnabled = state
        if state then
            if not recoilConnection then
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local recoilEvent = ReplicatedStorage:FindFirstChild("RecoilEvent")
                if not recoilEvent then
                    warn("RecoilEvent not found")
                    return
                end
                for _, v in pairs(getconnections(recoilEvent.Event)) do
                    v:Disable()
                end
                recoilConnection = recoilEvent.Event:Connect(function()
                    recoilEvent:Fire(CFrame.identity)
                end)
            end
        else
            if recoilConnection then
                recoilConnection:Disconnect()
                recoilConnection = nil
            end
        end
    end

    sj:Toggle({
        Title = "无后坐",
        Description = "禁用视角后坐力",
        Default = false,
        Callback = function(value)
            toggleAntiSelfDamage(value)
        end
    })

    -- 飞行区域
    local FlightGroup = Tabs.w:Section({
        Title = "飞行",
        Description = "飞行功能设置"
    })

    local function updateSpeedDisplay()
        if speeds >= SPEED_LIMIT then
            Notify("通知", "速度已达到上限: " .. SPEED_LIMIT, 2)
        end
        if nowe then
            tpwalking = false
            for i = 1, speeds do
                spawn(function()
                    local hb = RunService.Heartbeat
                    while tpwalking and hb:Wait() do
                        local chr = LocalPlayer.Character
                        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                        if chr and hum and hum.Parent then
                            if hum.MoveDirection.Magnitude > 0 then
                                chr:TranslateBy(hum.MoveDirection)
                            end
                        end
                    end
                end)
            end
        end
    end

    local function toggleFly(Value)
        nowe = Value
        local chr = LocalPlayer.Character
        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
        local humRootPart = chr and chr:FindFirstChild("HumanoidRootPart")
        
        if not hum or not humRootPart then 
            Notify("错误", "无法找到角色或Humanoid", 3)
            return 
        end
        
        if nowe then
            humRootPart.CanCollide = false
            tpwalking = true
            for i = 1, speeds do
                spawn(function()
                    local hb = RunService.Heartbeat
                    while tpwalking and hb:Wait() do
                        local chr = LocalPlayer.Character
                        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                        if chr and hum and hum.Parent then
                            if hum.MoveDirection.Magnitude > 0 then
                                chr:TranslateBy(hum.MoveDirection)
                            end
                        end
                    end
                end)
            end
            hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Running, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
            hum:ChangeState(Enum.HumanoidStateType.Swimming)
            if chr:FindFirstChild("Animate") then
                chr.Animate.Disabled = true
            end
            for i, v in next, hum:GetPlayingAnimationTracks() do
                v:AdjustSpeed(0)
            end
            local rootPart = hum.RigType == Enum.HumanoidRigType.R6 and chr.Torso or chr.UpperTorso
            local bg = Instance.new("BodyGyro", rootPart)
            bg.P = 9e4
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.cframe = rootPart.CFrame
            local bv = Instance.new("BodyVelocity", rootPart)
            bv.velocity = Vector3.new(0, 0.1, 0)
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            hum.PlatformStand = true
            local ctrl = { f = 0, b = 0, l = 0, r = 0 }
            local maxspeed = 50
            local flySpeed = 0
            spawn(function()
                while nowe and hum.Health > 0 do
                    RunService.RenderStepped:Wait()
                    ctrl.f = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0
                    ctrl.b = UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0
                    ctrl.l = UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0
                    ctrl.r = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
                    if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                        flySpeed = flySpeed + 0.5 + (flySpeed / maxspeed)
                        flySpeed = math.clamp(flySpeed, 0, maxspeed)
                    else
                        flySpeed = math.clamp(flySpeed - 1, 0, maxspeed)
                    end
                    if flySpeed > 0 then
                        local dir = (workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) +
                            ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).p) -
                                workspace.CurrentCamera.CoordinateFrame.p)
                        bv.velocity = dir * flySpeed
                        bg.cframe = workspace.CurrentCamera.CoordinateFrame *
                            CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * flySpeed / maxspeed), 0, 0)
                    else
                        bv.velocity = Vector3.new(0, 0.1, 0)
                    end
                end
                bg:Destroy()
                bv:Destroy()
                if hum and hum.Parent then
                    hum.PlatformStand = false
                end
                if chr and chr:FindFirstChild("Animate") then
                    chr.Animate.Disabled = false
                end
            end)
        else
            humRootPart.CanCollide = true
            tpwalking = false
            hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
            hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
            if chr:FindFirstChild("Animate") then
                chr.Animate.Disabled = false
            end
        end
    end

    local function toggleAntiSelfDamageFunc(Value)
        isAntiSelfDamage = Value
        if isAntiSelfDamage then
            namecallHook1 = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local method = getnamecallmethod():lower()
                if self.Name == "ForceSelfDamage" and method == "fireserver" then
                    return nil
                end
                return namecallHook1(self, ...)
            end))
        else
            if namecallHook1 then
                hookmetamethod(game, "__namecall", namecallHook1)
                namecallHook1 = nil
            end
        end
    end

    local function toggleAntiKnockbackFunc(Value)
        isAntiKnockback = Value
        if isAntiKnockback then
            renderConnection = RunService.RenderStepped:Connect(function(deltaTime)
                local char = LocalPlayer.Character
                if not char then return end
                local hum = char:FindFirstChildWhichIsA("Humanoid")
                if not hum then return end
                local antiFlingObj = char:FindFirstChild("Anti-fling/LocalPlat")
                if antiFlingObj then
                    antiFlingObj:Destroy()
                end
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
            end)
        else
            if renderConnection then
                renderConnection:Disconnect()
                renderConnection = nil
            end
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildWhichIsA("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
                end
            end
        end
    end

    local function toggleAntiRagdollFunc(Value)
        isAntiRagdoll = Value
        if isAntiRagdoll then
            namecallHook2 = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local method = getnamecallmethod()
                local args = { ... }
                if method == "SetStateEnabled" and typeof(self) == "Instance" and self:IsA("Humanoid") then
                    local state = args[1]
                    if state == Enum.HumanoidStateType.Ragdoll then
                        return namecallHook2(self, state, false)
                    end
                end
                return namecallHook2(self, ...)
            end))
        else
            if namecallHook2 then
                hookmetamethod(game, "__namecall", namecallHook2)
                namecallHook2 = nil
            end
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildWhichIsA("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                end
            end
        end
    end

    FlightGroup:Toggle({
        Title = "飞行开关",
        Description = "开启/关闭飞行功能",
        Default = false,
        Callback = function(Value)
            toggleFly(Value)
        end
    })

    FlightGroup:Slider({
        Title = "飞行速度",
        Description = "设置飞行速度等级",
        Value = {
            Min = 1,
            Max = SPEED_LIMIT,
            Default = 1,
        },
        Callback = function(Value)
            speeds = Value
            Notify("通知", "速度已设置为: " .. Value .. " 级", 1)
            updateSpeedDisplay()
        end
    })

    FlightGroup:Toggle({
        Title = "防自伤",
        Description = "防止自我伤害",
        Default = false,
        Callback = toggleAntiSelfDamageFunc
    })

    FlightGroup:Toggle({
        Title = "防击飞",
        Description = "防止被其他玩家或机制击飞",
        Default = false,
        Callback = toggleAntiKnockbackFunc
    })

    FlightGroup:Toggle({
        Title = "防布娃娃",
        Description = "防止进入布娃娃状态",
        Default = false,
        Callback = toggleAntiRagdollFunc
    })
end

-- ########## 杀戮光环 标签页 (旧版) ##########
do
    local CombatLeftGroup = Tabs.r:Section({
        Title = "杀戮光环·枪械",
        Description = "枪械相关设置"
    })

    CombatLeftGroup:Toggle({
        Title = "刺刀杀戮光环",
        Description = "自动用刺刀攻击附近的僵尸",
        Default = false,
        Callback = function(value)
            setToggle("BayonetKillAura", value)
        end
    })

    CombatLeftGroup:Toggle({
        Title = "攻击炸药桶",
        Description = "是否攻击炸药桶类型的僵尸",
        Default = false,
        Callback = function(value)
            setToggle("BayonetAttackBarrels", value)
        end
    })

    CombatLeftGroup:Toggle({
        Title = "自动转向",
        Description = "攻击时自动面向目标",
        Default = false,
        Callback = function(value)
            setToggle("BayonetAutoRotate", value)
        end
    })

    local CombatRightGroup = Tabs.r:Section({
        Title = "劳大肘击",
        Description = "近战眩晕功能"
    })

    CombatRightGroup:Toggle({
        Title = "肘击",
        Description = "使用斧头眩晕僵尸",
        Default = false,
        Callback = function(value)
            setToggle("ElbowStrike", value)
        end
    })

    CombatRightGroup:Toggle({
        Title = "卡宾枪肘击",
        Description = "多目标眩晕",
        Default = false,
        Callback = function(value)
            setToggle("CarbineStun", value)
        end
    })

    CombatRightGroup:Slider({
        Title = "目标数量",
        Description = "每次攻击最多眩晕的目标数",
        Value = {
            Min = 1,
            Max = 10,
            Default = 5,
        },
        Callback = function(value)
            setSlider("StunTargets", value)
        end
    })
end

-- ########## 玩家 标签页 ##########
do
    local AutoLeftGroup = Tabs.u:Section({
        Title = "自动",
        Description = "自动化功能"
    })

    local AutoBellActive = false
    AutoLeftGroup:Toggle({
        Title = "自动敲钟",
        Description = "自动敲击钟楼（莱比锡地图）",
        Default = false,
        Callback = function(Value)
            AutoBellActive = Value
            if Value then
                _G.AutoBellLoop = game:GetService("RunService").Heartbeat:Connect(function()
                    if not AutoBellActive then return end
                    local leipzig = workspace:FindFirstChild("Leipzig")
                    if leipzig and leipzig:FindFirstChild("Modes") then
                        local modes = leipzig.Modes
                        if modes:FindFirstChild("Objective") then
                            local objective = modes.Objective
                            if objective:FindFirstChild("BellInteract") then
                                local bell = objective.BellInteract
                                if bell:FindFirstChild("Interact") then
                                    pcall(function()
                                        bell.Interact:FireServer()
                                    end)
                                end
                            end
                        end
                    end
                end)
            else
                if _G.AutoBellLoop then
                    _G.AutoBellLoop:Disconnect()
                    _G.AutoBellLoop = nil
                end
            end
        end
    })

    local AutoBucketActive = false
    AutoLeftGroup:Toggle({
        Title = "自动水桶灭火",
        Description = "自动使用水桶扑灭火焰",
        Default = false,
        Callback = function(Value)
            AutoBucketActive = Value
            if Value then
                _G.AutoBucketLoop = game:GetService("RunService").Heartbeat:Connect(function()
                    if not AutoBucketActive then return end
                    local player = game.Players.LocalPlayer
                    local char = player.Character
                    if not char then return end
                    local bucket = char:FindFirstChild("Water Bucket") or 
                                  player.Backpack:FindFirstChild("Water Bucket")
                    if bucket then
                        if bucket.Parent ~= char then
                            bucket.Parent = char
                            task.wait(0.1)
                        end
                        if bucket:FindFirstChild("RemoteEvent") then
                            pcall(function()
                                bucket.RemoteEvent:FireServer("Throw")
                            end)
                            task.spawn(function()
                                task.wait(0.2)
                                if bucket and bucket.Parent == char then
                                    bucket.Parent = player.Backpack
                                end
                            end)
                        end
                    end
                end)
            else
                if _G.AutoBucketLoop then
                    _G.AutoBucketLoop:Disconnect()
                    _G.AutoBucketLoop = nil
                end
            end
        end
    })

    AutoLeftGroup:Divider()

    AutoLeftGroup:Toggle({
        Title = "自动修桥",
        Description = "自动修复Berezina的桥",
        Default = false,
        Callback = function(value)
            setToggle("AutoRepairBridge", value)
        end
    })

    AutoLeftGroup:Toggle({
        Title = "自动拿木头",
        Description = "自动收集木头",
        Default = false,
        Callback = function(value)
            setToggle("AutoGetLogs", value)
        end
    })

    AutoLeftGroup:Toggle({
        Title = "自动放木头",
        Description = "自动放置木头",
        Default = false,
        Callback = function(value)
            setToggle("AutoPlaceLogs", value)
        end
    })

    AutoLeftGroup:Slider({
        Title = "自动化速度",
        Description = "自动化操作的间隔时间(ms)",
        Value = {
            Min = 10,
            Max = 1000,
            Default = 100,
        },
        Callback = function(value)
            setSlider("AutoSpeed", value)
        end
    })
end

-- ########## 旧版杀戮光环逻辑 (保持原有逻辑，但使用新的 Toggle 值存储) ##########
do
    local connections = {}
    local activeFunctions = {}

    local function getCharacter()
        return player.Character
    end

    local function distance(a, b)
        if not a or not b or not a:FindFirstChild("HumanoidRootPart") or not b:FindFirstChild("HumanoidRootPart") then
            return math.huge
        end
        return (a.HumanoidRootPart.Position - b.HumanoidRootPart.Position).magnitude
    end

    local function rotateToTarget(character, target)
        if not character or not target or not target:FindFirstChild("HumanoidRootPart") then 
            return false 
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then 
            return false 
        end
        local originalAutoRotate = humanoid.AutoRotate
        humanoid.AutoRotate = false
        local targetPos = target.HumanoidRootPart.Position
        local lookAtPos = Vector3.new(targetPos.X, rootPart.Position.Y, targetPos.Z)
        rootPart.CFrame = CFrame.new(rootPart.Position, lookAtPos)
        humanoid.AutoRotate = originalAutoRotate
        return true
    end

    local function bayonetKillAuraLoop()
        while getToggle("BayonetKillAura") do
            local character = getCharacter()
            if not character or character:FindFirstChildOfClass("Humanoid").Health <= 0 then 
                task.wait(0.1)
                continue 
            end
            local zombies = workspace:FindFirstChild("Zombies")
            if not zombies then 
                task.wait(0.1)
                continue 
            end
            local weapon = character:FindFirstChild("Musket") or player.Backpack:FindFirstChild("Musket")
            if not weapon then 
                task.wait(0.1)
                continue 
            end
            if weapon.Parent ~= character then
                weapon.Parent = character
                task.wait(0.2)
            end
            local remoteEvent = weapon:FindFirstChild("RemoteEvent")
            if not remoteEvent then 
                task.wait(0.1)
                continue 
            end
            for _, zombie in pairs(zombies:GetChildren()) do
                if not getToggle("BayonetKillAura") then break end
                if zombie:IsA("Model") and zombie:FindFirstChild("HumanoidRootPart") then
                    if zombie:GetAttribute("Type") == "Barrel" and not getToggle("BayonetAttackBarrels") then
                        continue
                    end
                    if zombie:FindFirstChild("Barrel") then
                        continue
                    end
                    if distance(character, zombie) <= 15 then
                        local state = zombie:FindFirstChild("State")
                        if not state or state.Value ~= "Spawn" then
                            if getToggle("BayonetAutoRotate") then
                                rotateToTarget(character, zombie)
                                task.wait(0.05) 
                            end
                            remoteEvent:FireServer("ThrustBayonet")
                            task.wait(0.1) 
                            local hitPart = zombie:FindFirstChild("Head") or zombie:FindFirstChild("HumanoidRootPart")
                            if hitPart then
                                remoteEvent:FireServer("Bayonet_HitZombie", zombie, hitPart.Position, true)
                            end
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end

    local function elbowStrikeLoop()
        while getToggle("ElbowStrike") do
            local character = getCharacter()
            if not character or character:FindFirstChildOfClass("Humanoid").Health <= 0 then 
                task.wait(0.1)
                continue 
            end
            local zombies = workspace:FindFirstChild("Zombies")
            if not zombies then 
                task.wait(0.1)
                continue 
            end
            local weapon = character:FindFirstChild("Axe") or player.Backpack:FindFirstChild("Axe")
            if not weapon then 
                task.wait(0.1)
                continue 
            end
            if weapon.Parent ~= character then
                weapon.Parent = character
                task.wait(0.2)
            end
            local remoteEvent = weapon:FindFirstChild("RemoteEvent")
            if not remoteEvent then 
                task.wait(0.1)
                continue 
            end
            for _, zombie in pairs(zombies:GetChildren()) do
                if not getToggle("ElbowStrike") then break end
                if zombie:IsA("Model") and zombie:FindFirstChild("HumanoidRootPart") then
                    if distance(character, zombie) <= 15 then
                        local state = zombie:FindFirstChild("State")
                        if state and state.Value == "Stunned" then
                            continue
                        end
                        remoteEvent:FireServer("BraceBlock")
                        task.wait(0.05)
                        remoteEvent:FireServer("StopBraceBlock")
                        task.wait(0.05)
                        remoteEvent:FireServer("FeedbackStun", zombie, zombie.HumanoidRootPart.CFrame.Position)
                        task.wait(0.1)
                    end
                end
            end
            task.wait(0.2)
        end
    end

    local function carbineStunLoop()
        while getToggle("CarbineStun") do
            local character = getCharacter()
            if not character or character:FindFirstChildOfClass("Humanoid").Health <= 0 then 
                task.wait(0.5)
                continue 
            end
            local zombies = workspace:FindFirstChild("Zombies")
            if not zombies then 
                task.wait(1)
                continue 
            end
            local carbine = character:FindFirstChild("Carbine") or player.Backpack:FindFirstChild("Carbine")
            if not carbine then 
                task.wait(1)
                continue 
            end
            local remoteEvent = carbine:FindFirstChild("RemoteEvent")
            if not remoteEvent then 
                task.wait(1)
                continue 
            end
            local zombiesInRange = {}
            local characterRoot = character:FindFirstChild("HumanoidRootPart")
            if not characterRoot then 
                task.wait(0.1)
                continue 
            end
            for _, zombie in pairs(zombies:GetChildren()) do
                if zombie:IsA("Model") and zombie:FindFirstChild("HumanoidRootPart") then
                    local dist = (zombie.HumanoidRootPart.Position - characterRoot.Position).Magnitude
                    if dist <= 15 then
                        table.insert(zombiesInRange, zombie)
                    end
                end
            end
            table.sort(zombiesInRange, function(a, b)
                return (a.HumanoidRootPart.Position - characterRoot.Position).Magnitude < 
                       (b.HumanoidRootPart.Position - characterRoot.Position).Magnitude
            end)
            local maxTargets = math.min(getSlider("StunTargets"), #zombiesInRange)
            if maxTargets > 0 then
                if maxTargets > 0 and zombiesInRange[1] then
                    rotateToTarget(character, zombiesInRange[1])
                    task.wait(0.1)
                end
                remoteEvent:FireServer("Shove")
                task.wait(0.2)
                for i = 1, maxTargets do
                    local zombie = zombiesInRange[i]
                    remoteEvent:FireServer("FeedbackStun", zombie, zombie.HumanoidRootPart.CFrame.Position)
                    if i < maxTargets then
                        task.wait(0.1)
                    end
                end
            end
            task.wait(0.5)
        end
    end

    local function autoRepairBridgeLoop()
        while getToggle("AutoRepairBridge") do
            local character = getCharacter()
            if not character or not character:FindFirstChild("HumanoidRootPart") then 
                task.wait(0.5)
                continue 
            end
            local root = character.HumanoidRootPart
            local bridge = workspace:FindFirstChild("Berezina")
            if not bridge then 
                task.wait(1)
                continue 
            end
            bridge = bridge:FindFirstChild("Modes")
            if not bridge then 
                task.wait(1)
                continue 
            end
            bridge = bridge:FindFirstChild("Holdout")
            if not bridge then 
                task.wait(1)
                continue 
            end
            bridge = bridge:FindFirstChild("Bridge")
            if not bridge then 
                task.wait(1)
                continue 
            end
            local nearest, nearestDist = nil, math.huge
            for _, section in ipairs(bridge:GetChildren()) do
                local posts = section:FindFirstChild("Posts")
                if posts then
                    for _, part in ipairs(posts:GetChildren()) do
                        if part:IsA("BasePart") and part:FindFirstChild("ConstructHealth") then
                            local d = (part.Position - root.Position).Magnitude
                            if d < nearestDist then
                                nearestDist = d
                                nearest = part.ConstructHealth
                            end
                        end
                    end
                end
                local beam = section:FindFirstChild("Beam")
                if beam and beam:FindFirstChild("ConstructHealth") then
                    local d = (beam.Position - root.Position).Magnitude
                    if d < nearestDist then
                        nearestDist = d
                        nearest = beam.ConstructHealth
                    end
                end
                for _, joists in ipairs(section:GetChildren()) do
                    if joists.Name == "Joists" and joists:FindFirstChild("ConstructHealth") then
                        local d = (joists.Position - root.Position).Magnitude
                        if d < nearestDist then
                            nearestDist = d
                            nearest = joists.ConstructHealth
                        end
                    end
                end
            end
            if nearest and nearestDist < 20 then 
                local hammer = player.Backpack:FindFirstChild("Hammer") or player.Backpack:FindFirstChild("Claw Hammer")
                if hammer and hammer:FindFirstChild("RemoteEvent") then
                    if hammer.Parent ~= character then
                        hammer.Parent = character
                        task.wait(0.2)
                    end
                    hammer.RemoteEvent:FireServer("Repair", nearest)
                end
            end
            task.wait(0.2)
        end
    end

    local function autoGetLogsLoop()
        local waitTime = math.max(50, 1010 - getSlider("AutoSpeed")) / 1000
        while getToggle("AutoGetLogs") do
            local remoteEvent = workspace:FindFirstChild("Berezina")
            if remoteEvent then
                remoteEvent = remoteEvent:FindFirstChild("Modes")
                if remoteEvent then
                    remoteEvent = remoteEvent:FindFirstChild("Holdout")
                    if remoteEvent then
                        remoteEvent = remoteEvent:FindFirstChild("Log")
                        if remoteEvent then
                            remoteEvent = remoteEvent:FindFirstChild("Log")
                            if remoteEvent then
                                remoteEvent = remoteEvent:FindFirstChild("Interact")
                                if remoteEvent and remoteEvent:IsA("RemoteEvent") then
                                    pcall(function()
                                        remoteEvent:FireServer()
                                    end)
                                end
                            end
                        end
                    end
                end
            end
            task.wait(waitTime)
        end
    end

    local function autoPlaceLogsLoop()
        local waitTime = math.max(50, 1010 - getSlider("AutoSpeed")) / 1000
        while getToggle("AutoPlaceLogs") do
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.Name == "PlaceLogProximityPrompt" then
                    pcall(function()
                        fireproximityprompt(prompt)
                    end)
                    task.wait(0.05) 
                end
            end
            task.wait(waitTime)
        end
    end

    local function startFunction(funcName, loopFunc)
        if activeFunctions[funcName] then
            task.cancel(activeFunctions[funcName])
        end
        activeFunctions[funcName] = task.spawn(loopFunc)
    end

    local function stopFunction(funcName)
        if activeFunctions[funcName] then
            task.cancel(activeFunctions[funcName])
            activeFunctions[funcName] = nil
        end
    end

    -- 监测 Toggle 变化
    local function monitorToggles()
        task.spawn(function()
            local lastBayonet = getToggle("BayonetKillAura")
            local lastElbow = getToggle("ElbowStrike")
            local lastCarbine = getToggle("CarbineStun")
            local lastBridge = getToggle("AutoRepairBridge")
            local lastLogs = getToggle("AutoGetLogs")
            local lastPlace = getToggle("AutoPlaceLogs")
            while true do
                task.wait(0.2)
                local b = getToggle("BayonetKillAura")
                if b ~= lastBayonet then
                    lastBayonet = b
                    if b then startFunction("BayonetKillAura", bayonetKillAuraLoop) else stopFunction("BayonetKillAura") end
                end
                local e = getToggle("ElbowStrike")
                if e ~= lastElbow then
                    lastElbow = e
                    if e then startFunction("ElbowStrike", elbowStrikeLoop) else stopFunction("ElbowStrike") end
                end
                local c = getToggle("CarbineStun")
                if c ~= lastCarbine then
                    lastCarbine = c
                    if c then startFunction("CarbineStun", carbineStunLoop) else stopFunction("CarbineStun") end
                end
                local br = getToggle("AutoRepairBridge")
                if br ~= lastBridge then
                    lastBridge = br
                    if br then startFunction("AutoRepairBridge", autoRepairBridgeLoop) else stopFunction("AutoRepairBridge") end
                end
                local lg = getToggle("AutoGetLogs")
                if lg ~= lastLogs then
                    lastLogs = lg
                    if lg then startFunction("AutoGetLogs", autoGetLogsLoop) else stopFunction("AutoGetLogs") end
                end
                local pl = getToggle("AutoPlaceLogs")
                if pl ~= lastPlace then
                    lastPlace = pl
                    if pl then startFunction("AutoPlaceLogs", autoPlaceLogsLoop) else stopFunction("AutoPlaceLogs") end
                end
            end
        end)
    end
    monitorToggles()

    player.CharacterAdded:Connect(function(character)
        task.wait(1) 
        for funcName, _ in pairs(activeFunctions) do
            stopFunction(funcName)
        end
        setToggle("BayonetKillAura", false)
        setToggle("ElbowStrike", false)
        setToggle("CarbineStun", false)
        setToggle("AutoRepairBridge", false)
        setToggle("AutoGetLogs", false)
        setToggle("AutoPlaceLogs", false)
    end)
end

-- ########## 职业 标签页 ##########
do
    local MedicSection = Tabs.u:Section({
        Title = "医疗兵",
        Description = "医疗兵功能"
    })

    local AutoRequestHealEnabled = false
    local HealRange = 10
    local HealCooldown = 3
    local HealThreshold = 25
    local HealData = {}
    local HealNotify = {}

    local function RequestHeal(player, humanoid)
        if not player or not humanoid then return end
        if humanoid.Health > humanoid.MaxHealth * (HealThreshold / 100) then return end
        local lastReq = HealData[player] or 0
        if tick() - lastReq < HealCooldown then return end
        HealData[player] = tick()
        local localChar = LocalPlayer.Character
        if not localChar then return end
        local localHRP = localChar:FindFirstChild("HumanoidRootPart")
        if not localHRP then return end
        local targetHRP = humanoid.Parent:FindFirstChild("HumanoidRootPart") or humanoid.Parent:FindFirstChild("Torso")
        if not targetHRP then return end
        if (localHRP.Position - targetHRP.Position).Magnitude > HealRange then return end
        local medSupplies = localChar:FindFirstChild("Medical Supplies")
        if not medSupplies then return end
        local remote = medSupplies:FindFirstChild("RemoteEvent")
        if not remote then return end
        pcall(function()
            remote:FireServer("SendRequest", humanoid)
            local lastNotify = HealNotify[player] or 0
            if tick() - lastNotify >= HealCooldown then
                HealNotify[player] = tick()
                Notify("自动治疗", "已为 " .. player.Name .. " 请求治疗", 2)
            end
        end)
    end

    task.spawn(function()
        while task.wait(0.25) do
            if not AutoRequestHealEnabled then continue end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
                    if humanoid and humanoid.Health <= humanoid.MaxHealth * (HealThreshold / 100) then
                        pcall(function() RequestHeal(player, humanoid) end)
                    end
                end
            end
        end
    end)

    MedicSection:Toggle({
        Title = "自动请求治疗濒死玩家",
        Description = "当附近玩家生命值低时自动请求治疗",
        Default = false,
        Callback = function(state)
            AutoRequestHealEnabled = state
        end
    })

    MedicSection:Slider({
        Title = "治疗阈值 (%)",
        Description = "自动治疗的生命值百分比阈值",
        Value = {
            Min = 1,
            Max = 100,
            Default = 25,
        },
        Callback = function(val) HealThreshold = val end
    })

    local SapperSection = Tabs.u:Section({
        Title = "工兵",
        Description = "工兵功能"
    })

    local AutoRepairEnabled = false
    local AutoRepairCooldown = 0.1

    local function FireRepair(buildHealth)
        local char = LocalPlayer.Character
        if not (char and buildHealth) then return end
        local hammer = char:FindFirstChild("Hammer")
        if not hammer or not hammer:FindFirstChild("RemoteEvent") then return end
        local args = {"Repair", buildHealth}
        pcall(function() hammer.RemoteEvent:FireServer(unpack(args)) end)
    end

    local function GetLookedStructure()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local origin = Workspace.CurrentCamera.CFrame.Position
        local direction = Workspace.CurrentCamera.CFrame.LookVector * 50
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {LocalPlayer.Character}
        params.FilterType = Enum.RaycastFilterType.Blacklist
        local rayResult = Workspace:Raycast(origin, direction, params)
        if not rayResult or not rayResult.Instance then return nil end
        local hit = rayResult.Instance
        local model = hit:FindFirstAncestorOfClass("Model")
        if not model then return nil end
        local buildHealth = model:FindFirstChild("BuildingHealth") or (model.Parent and model.Parent:FindFirstChild("BuildingHealth"))
        return buildHealth
    end

    task.spawn(function()
        while true do
            task.wait(AutoRepairCooldown)
            if not AutoRepairEnabled then continue end
            local buildHealth = GetLookedStructure()
            if buildHealth then
                local currentHealth = buildHealth.Value
                local maxHealth = buildHealth:GetAttribute("MaxHealth")
                if maxHealth and currentHealth < maxHealth then FireRepair(buildHealth) end
            end
        end
    end)

    SapperSection:Toggle({
        Title = "自动修复",
        Description = "自动修复建筑",
        Default = false,
        Callback = function(state)
            AutoRepairEnabled = state
            Notify("自动修复", state and "自动修复已启用" or "自动修复已禁用", 2)
        end
    })

    local ChaplainSection = Tabs.u:Section({
        Title = "牧师",
        Description = "牧师功能"
    })

    local PlayersSvc = game:GetService("Players")
    local AutoBlessEnabled = false
    local BlessThreshold = 50
    local BlessCooldown = 2
    local BlessRange = 15
    local BlessData = {}

    local function GetEquippedBlessRemote()
        local localChar = LocalPlayer and LocalPlayer.Character
        if not localChar then return nil end
        local tool = localChar:FindFirstChild("Blessing")
        if tool and tool:FindFirstChild("RemoteEvent") then return tool:FindFirstChild("RemoteEvent") end
        for _, child in ipairs(localChar:GetChildren()) do
            if child:IsA("Tool") and child.Name:lower():find("bless") and child:FindFirstChild("RemoteEvent") then
                return child:FindFirstChild("RemoteEvent")
            end
        end
        return nil
    end

    local function InRangeOfLocal(player, maxRange)
        local localChar = LocalPlayer and LocalPlayer.Character
        if not (localChar and localChar:FindFirstChild("HumanoidRootPart")) then return false end
        if not (player and player.Character) then return false end
        local targetHRP = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
        if not targetHRP then return false end
        return (localChar.HumanoidRootPart.Position - targetHRP.Position).Magnitude <= (maxRange or BlessRange)
    end

    local function FireBlessByPlayer_Silent(player)
        if not player then return false end
        local remote = GetEquippedBlessRemote()
        if not remote then return false end
        if not InRangeOfLocal(player, BlessRange) then return false end
        local humanoid = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
        if not humanoid then return false end
        local ok, err = pcall(function() remote:FireServer("SendRequest", humanoid) end)
        if not ok then return false end
        return true
    end

    local function GetPlayerInfectedValue(player)
        local ok, val = pcall(function()
            local wsPlayers = Workspace:FindFirstChild("Players")
            if wsPlayers then
                local wsP = wsPlayers:FindFirstChild(player.Name)
                if wsP and wsP:FindFirstChild("UserStates") and wsP.UserStates:FindFirstChild("Infected") then
                    return wsP.UserStates.Infected.Value
                end
            end
            if player:FindFirstChild("UserStates") and player.UserStates:FindFirstChild("Infected") then
                return player.UserStates.Infected.Value
            end
            if player.Character and player.Character:FindFirstChild("UserStates") and player.Character.UserStates:FindFirstChild("Infected") then
                return player.Character.UserStates.Infected.Value
            end
            return nil
        end)
        if ok then return val end
        return nil
    end

    task.spawn(function()
        while task.wait(0.25) do
            if not AutoBlessEnabled then continue end
            for _, player in ipairs(PlayersSvc:GetPlayers()) do
                if not player or player == LocalPlayer then continue end
                local infectedVal = nil
                pcall(function() infectedVal = GetPlayerInfectedValue(player) end)
                if infectedVal ~= nil then
                    local numeric = nil
                    if type(infectedVal) == "number" then numeric = infectedVal
                    elseif type(infectedVal) == "string" then numeric = tonumber(infectedVal)
                    elseif type(infectedVal) == "boolean" then numeric = infectedVal and 1 or 0 end
                    local thresholdNum = tonumber(BlessThreshold) or 0
                    if numeric and numeric >= thresholdNum then
                        local uid = player.UserId or player.Name
                        local last = BlessData[uid] or 0
                        if tick() - last >= (tonumber(BlessCooldown) or 0) then
                            local success = false
                            pcall(function() success = FireBlessByPlayer_Silent(player) end)
                            if success then
                                BlessData[uid] = tick()
                                Notify("自动祝福", "已向 " .. player.Name .. " 发送祝福", 2)
                            end
                        end
                    end
                end
            end
        end
    end)

    ChaplainSection:Toggle({
        Title = "自动祝福感染玩家",
        Description = "开启自动祝福",
        Default = false,
        Callback = function(state)
            AutoBlessEnabled = state
            Notify("牧师", state and "自动祝福已启用" or "自动祝福已禁用", 2)
        end
    })

    ChaplainSection:Slider({
        Title = "感染阈值",
        Description = "自动祝福的阈值",
        Value = {
            Min = 0,
            Max = 200,
            Default = 50,
        },
        Callback = function(val) BlessThreshold = tonumber(val) or 0 end
    })
end

-- ########## 瞄准 & 其他功能 ##########
do
    local AimingGroup = Tabs.w:Section({
        Title = "瞄准",
        Description = "瞄准相关设置"
    })

    local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules")
    
    local FlintLockSuccess, FlintLock = pcall(require, Modules.Weapons:FindFirstChild("Flintlock"))
    local originBayonet, changeBayonet
    
    if FlintLockSuccess then
        originBayonet = FlintLock.BayonetHitCheck
        
        local v_u_1 = {}
        v_u_1.__index = v_u_1
        
        function v_u_1.BayonetHitCheck(p115, p116, p117, p118, p119)
            local v120 = workspace:Raycast(p116, p117, p118)
            if v120 then
                if v120.Instance.Parent.Name == "m_Zombie" then
                    local v121 = p118.FilterDescendantsInstances
                    local v122 = v120.Instance
                    table.insert(v121, v122)
                    p118.FilterDescendantsInstances = v121
                    local v123 = v120.Instance.Parent:FindFirstChild("Orig")
                    if v123 then
                        local Head = nil
                        for i, part in pairs(v120.Instance.Parent:GetChildren()) do
                            if part.Name == "Head" and (part.ClassName == "Part" or part.ClassName == "MeshPart") then
                                Head = part
                                break
                            end
                        end
                        if Head then
                            p115.remoteEvent:FireServer("Bayonet_HitZombie", v123.Value, Head.CFrame.Position, true, "Head")
                            local v_u_124 = v123.Value
                            local v_u_125 = tick()
                            v_u_124:SetAttribute("WepHitID", tick())
                            v_u_124:SetAttribute("WepHitDirection", p117 * 10)
                            v_u_124:SetAttribute("WepHitPos", v120.Position)
                            task.delay(0.2, function()
                                if v_u_124:GetAttribute("WepHitID") == v_u_125 then
                                    v_u_124:SetAttribute("WepHitDirection", nil)
                                    v_u_124:SetAttribute("WepHitPos", nil)
                                    v_u_124:SetAttribute("WepHitID", nil)
                                end
                            end)
                        end
                    end
                    return 1
                end
                local v126 = v120.Instance.Parent:FindFirstChild("DoorHit") or v120.Instance:FindFirstChild("BreakGlass")
                if v126 and not table.find(p119, v126) then
                    table.insert(p119, v126)
                    p115.remoteEvent:FireServer("Bayonet_HitCon", v120.Instance, v120.Position, v120.Normal, v120.Material)
                    return 2
                end
                local v127 = v120.Instance.Parent:FindFirstChild("Humanoid") or v120.Instance.Parent.Parent:FindFirstChild("Humanoid")
                if v127 and not table.find(p119, v127) then
                    table.insert(p119, v127)
                    p115.remoteEvent:FireServer("Bayonet_HitPlayer", v127, v120.Position)
                    return 2
                end
            end
            return 0
        end
        
        function changeBayonet(value)
            FlintLock.BayonetHitCheck = value and v_u_1.BayonetHitCheck or originBayonet
        end
    else
        warn("刺刀模块未找到!")
    end
    
    local MeleeBaseSuccess, MeleeBase = pcall(require, Modules.Weapons:FindFirstChild("MeleeBase"))
    local originMelee, changeMelee
    
    if MeleeBaseSuccess then
        originMelee = MeleeBase.MeleeHitCheck
        
        local u1 = {}
        u1.__index = u1
        
        local u8 = game:GetService("CollectionService")
        local u10 = require(game.ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RbxUtil"):WaitForChild("DebugVisualizer"))
        local v11 = game.Players.LocalPlayer:WaitForChild("Options")
        local u14 = v11:WaitForChild("Gore")
        local u15 = v11:WaitForChild("WeaponStains")
        local v5 = game.ReplicatedStorage:WaitForChild("GameStates"):WaitForChild("Gameplay")
        local u7 = v5:WaitForChild("PVP")
        
        function u1.MeleeHitCheck(p100, p101, p102, p103, p104, p105)
            local v106 = workspace:Raycast(p101, p102, p103)
            if v106 then
                if v106.Instance.Parent.Name == "m_Zombie" then
                    local v107 = p103.FilterDescendantsInstances
                    local v108 = v106.Instance
                    table.insert(v107, v108)
                    p103.FilterDescendantsInstances = v107
                    local v109 = v106.Instance.Parent:FindFirstChild("Orig")
                    if v109 then
                        if p100.sharp and shared.Gib ~= nil then
                            if v109.Value then
                                local v110 = v109.Value:FindFirstChild("Zombie")
                                local v111 = not p100.Stats.HeadshotMulti and 2.3 or p100.Stats.HeadshotMulti
                                if v110 and v110.Health - p100.Stats.Damage * v111 <= 0 then
                                    shared.Gib(v109.Value, v106.Instance.Name, v106.Position, v106.Normal, true)
                                end
                            else
                                shared.Gib(v109.Value, v106.Instance.Name, v106.Position, v106.Normal, true)
                            end
                        end
                        if not p104[v109] or p104[v109] < (p100.Stats.MaxHits or 3) then
                            if p105 then
                                p100.remoteEvent:FireServer("ThrustCharge", v109.Value, v106.Position, v106.Normal)
                            else
                                local Head = nil
                                for i, part in pairs(v106.Instance.Parent:GetChildren()) do
                                    if part.Name == "Head" and (part.ClassName == "Part" or part.ClassName == "MeshPart") then
                                        Head = part
                                        break
                                    end
                                end
                                if Head then
                                    local u112 = v109.Value
                                    local v113 = Head.CFrame.Position - p101
                                    if v113:Dot(v113) > 1 then
                                        v113 = v113.Unit
                                    end
                                    local v114 = v113 * 25
                                    p100.remoteEvent:FireServer("HitZombie", u112, Head.CFrame.Position, true, v114, "Head", v106.Normal)
                                    if not u112:GetAttribute("WepHitDirection") then
                                        local u115 = tick()
                                        u112:SetAttribute("WepHitID", tick())
                                        u112:SetAttribute("WepHitDirection", v114)
                                        u112:SetAttribute("WepHitPos", v106.Position)
                                        task.delay(0.2, function()
                                            if u112:GetAttribute("WepHitID") == u115 then
                                                u112:SetAttribute("WepHitDirection", nil)
                                                u112:SetAttribute("WepHitPos", nil)
                                                u112:SetAttribute("WepHitID", nil)
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    end
                    return 1
                end
            end
            return 0
        end
        
        function changeMelee(value)
            MeleeBase.MeleeHitCheck = value and u1.MeleeHitCheck or originMelee
        end
    else
        warn("近战基础模块未找到!")
    end
    
    AimingGroup:Toggle({
        Title = "头部命中",
        Description = "强制近战和刺刀攻击瞄准僵尸头部 (跳过点燃者僵尸)",
        Default = false,
        Callback = function(Value)
            if FlintLockSuccess then changeBayonet(Value) end
            if MeleeBaseSuccess then changeMelee(Value) end
            Notify("瞄准", Value and "头部命中已启用" or "头部命中已禁用", 2)
        end
    })

    -- 炸弹僵尸锁定
    local AimlockBomberEnabled = false
    local AimlockBomberRange = 150
    local AimlockBomberSmoothness = 0.2
    local AimlockBomberUseFOV = false
    local AimlockBomberFOVVisible = false
    local AimlockBomberFOV = 90
    local AimlockBomberCheckWalls = true
    local aimlockConnection = nil

    local function getCamera()
        return Workspace.CurrentCamera
    end
    
    local previousPositions = {}
    
    local function isMoving(model)
        if not model or not model:IsA("Model") then return false end
        local head = model:FindFirstChild("Head")
        if not head then return false end
        local prevPos = previousPositions[model]
        previousPositions[model] = head.Position
        if not prevPos then return false end
        return (head.Position - prevPos).Magnitude > 0.05
    end
    
    local function getTargetPart(model)
        if not model then return nil end
        if isMoving(model) then
            return model:FindFirstChild("Barrel") or model:FindFirstChild("Head")
        else
            return model:FindFirstChild("Head") or model:FindFirstChild("Barrel")
        end
    end
    
    local function inCameraFOV(camCFrame, pos, fovDegrees)
        local camPos = camCFrame.Position
        local camLook = camCFrame.LookVector
        local dir = (pos - camPos)
        local dist = dir.Magnitude
        if dist == 0 then return true end
        local unit = dir / dist
        local dot = unit:Dot(camLook)
        return dot >= math.cos(math.rad(fovDegrees / 2))
    end
    
    local function isObstructed(camPos, targetPos, targetModel)
        if not AimlockBomberCheckWalls then return false end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        local ignoreList = {}
        local camFolder = Workspace:FindFirstChild("Camera")
        if camFolder then table.insert(ignoreList, camFolder) end
        local zombiesFolder = Workspace:FindFirstChild("Zombies")
        if zombiesFolder then table.insert(ignoreList, zombiesFolder) end
        if targetModel and targetModel:IsA("Instance") then table.insert(ignoreList, targetModel) end
        if LocalPlayer and LocalPlayer.Character then table.insert(ignoreList, LocalPlayer.Character) end
        params.FilterDescendantsInstances = ignoreList
        local dir = (targetPos - camPos)
        local result = Workspace:Raycast(camPos, dir, params)
        return result ~= nil
    end
    
    local function getNearestBomber(range)
        local cam = getCamera()
        if not cam then return nil end
        local camFolder = Workspace:FindFirstChild("Camera")
        if not camFolder then return nil end
        local camPos = cam.CFrame.Position
        local camLook = cam.CFrame.LookVector
        local closestPart, closestDist = nil, range
        
        for _, model in ipairs(camFolder:GetChildren()) do
            if model:IsA("Model") and model.Name == "m_Zombie" and model:FindFirstChild("Barrel") then
                local targetPart = getTargetPart(model)
                if targetPart and targetPart:IsA("BasePart") then
                    local dir = (targetPart.Position - camPos)
                    local dist = dir.Magnitude
                    if dist <= range then
                        if AimlockBomberUseFOV and not inCameraFOV(cam.CFrame, targetPart.Position, AimlockBomberFOV) then
                        else
                            local dot = camLook:Dot(dir.Unit)
                            if dot > 0.01 then
                                if not isObstructed(camPos, targetPart.Position, model) then
                                    if dist < closestDist then
                                        closestDist = dist
                                        closestPart = targetPart
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        return closestPart
    end
    
    local function startAimlockBomber()
        if aimlockConnection then return end
        aimlockConnection = RunService.RenderStepped:Connect(function(dt)
            if not AimlockBomberEnabled then return end
            local cam = getCamera()
            if not cam then return end
            local targetPart = getNearestBomber(AimlockBomberRange)
            if not targetPart then return end
            local camPos = cam.CFrame.Position
            local targetPos = targetPart.Position
            local desired = CFrame.new(camPos, targetPos)
            local responsiveness = math.clamp(1 - (AimlockBomberSmoothness or 0.2), 0, 1)
            local frameAlpha = responsiveness * math.clamp(dt * 60, 0, 1)
            frameAlpha = math.clamp(frameAlpha, 0.001, 0.999)
            local ok, newCFrame = pcall(function() return cam.CFrame:Lerp(desired, frameAlpha) end)
            if ok and newCFrame then
                pcall(function() cam.CFrame = newCFrame end)
            end
        end)
    end
    
    local function stopAimlockBomber()
        if aimlockConnection then
            aimlockConnection:Disconnect()
            aimlockConnection = nil
        end
        previousPositions = {}
    end
    
    AimingGroup:Toggle({
        Title = "炸弹僵尸锁定",
        Description = "将摄像头锁定到炸弹僵尸",
        Default = false,
        Callback = function(Value)
            AimlockBomberEnabled = Value
            if Value then
                startAimlockBomber()
            else
                stopAimlockBomber()
            end
        end
    })

    AimingGroup:Slider({
        Title = "范围 (格)",
        Description = "锁定范围",
        Value = {
            Min = 1,
            Max = 300,
            Default = 150,
        },
        Callback = function(Value)
            AimlockBomberRange = math.clamp(tonumber(Value) or AimlockBomberRange, 1, 300)
        end
    })

    AimingGroup:Slider({
        Title = "平滑度 (越低越快)",
        Description = "锁定平滑度",
        Value = {
            Min = 0.01,
            Max = 1.0,
            Default = 0.2,
        },
        Callback = function(Value)
            AimlockBomberSmoothness = math.clamp(tonumber(Value) or AimlockBomberSmoothness, 0.01, 1.0)
        end
    })

    AimingGroup:Toggle({
        Title = "使用视野",
        Description = "只在视野圆圈内锁定",
        Default = false,
        Callback = function(Value)
            AimlockBomberUseFOV = Value
        end
    })

    AimingGroup:Slider({
        Title = "视野角度",
        Description = "视野角度大小",
        Value = {
            Min = 10,
            Max = 180,
            Default = 90,
        },
        Callback = function(Value)
            AimlockBomberFOV = math.clamp(tonumber(Value) or AimlockBomberFOV, 10, 180)
        end
    })

    AimingGroup:Toggle({
        Title = "显示视野",
        Description = "显示视野圆圈",
        Default = false,
        Callback = function(Value)
            AimlockBomberFOVVisible = Value
        end
    })

    AimingGroup:Toggle({
        Title = "检查墙壁",
        Description = "不会瞄准墙后的炸弹僵尸",
        Default = true,
        Callback = function(Value)
            AimlockBomberCheckWalls = Value
        end
    })
end

-- ########## 其他功能 ##########
do
    local LegitGroup = Tabs.w:Section({
        Title = "其他功能",
        Description = "杂项功能"
    })

    -- 自动跳跃
    local TARGET_ANIM_IDS = {
        "rbxassetid://17406577733",
        "rbxassetid://15669224658",
        "rbxassetid://12591948314",
        "rbxassetid://12333491302",
    }
    local TARGETS = {}
    for _, v in ipairs(TARGET_ANIM_IDS) do
        local id = tostring(v)
        if id:match("^%d+$") then id = "rbxassetid://" .. id end
        TARGETS[id] = true
    end
    local humanoid, animator
    local playedTracks = {}
    local monitoring = false

    local function normalizeAnimId(id)
        if not id then return nil end
        local s = tostring(id)
        if s:match("^%d+$") then return "rbxassetid://" .. s end
        return s
    end

    local function trackIsTarget(track)
        if not track or not track.IsPlaying then return false end
        local anim = track.Animation
        if not anim or not anim.AnimationId then return false end
        local aId = normalizeAnimId(anim.AnimationId)
        return aId and TARGETS[aId]
    end

    local function doJump()
        if not humanoid or not humanoid.Parent then return end
        task.spawn(function()
            pcall(function()
                local timeout = 1
                local startTime = os.clock()
                while os.clock() - startTime < timeout do
                    local state = humanoid:GetState()
                    if state == Enum.HumanoidStateType.Running or state == Enum.HumanoidStateType.Landed or state == Enum.HumanoidStateType.RunningNoPhysics or state == Enum.HumanoidStateType.Climbing then
                        break
                    end
                    task.wait(0.05)
                end
                local root = humanoid.RootPart or humanoid.Parent:FindFirstChild("HumanoidRootPart")
                if root then
                    local gravity = workspace.Gravity
                    local JumpPower = 30
                    local JumpHeight = 7.199999809265137
                    local jumpVelocity
                    if humanoid.UseJumpPower then
                        jumpVelocity = JumpPower
                    else
                        jumpVelocity = math.sqrt(2 * gravity * JumpHeight)
                    end
                    root.Velocity = Vector3.new(root.Velocity.X, jumpVelocity, root.Velocity.Z)
                end
            end)
        end)
    end

    local function refreshCharacter(char)
        humanoid = char and char:FindFirstChildOfClass("Humanoid") or nil
        animator = nil
        if humanoid then
            animator = humanoid:FindFirstChildOfClass("Animator")
            if not animator then
                animator = Instance.new("Animator")
                animator.Name = "AutoAnimator"
                animator.Parent = humanoid
            end
        end
        playedTracks = {}
    end

    refreshCharacter(LocalPlayer.Character)
    LocalPlayer.CharacterAdded:Connect(function(ch)
        ch:WaitForChild("Humanoid", 5)
        ch:WaitForChild("HumanoidRootPart", 5)
        refreshCharacter(ch)
    end)

    LegitGroup:Toggle({
        Title = "自动跳跃",
        Description = "当你刺击武器时自动跳跃",
        Default = false,
        Callback = function(Value)
            if Value then
                if not monitoring then
                    monitoring = true
                    task.spawn(function()
                        while monitoring do
                            if animator then
                                local ok, tracks = pcall(function() return animator:GetPlayingAnimationTracks() end)
                                if ok and tracks then
                                    for _, track in ipairs(tracks) do
                                        if trackIsTarget(track) and not playedTracks[track] then
                                            playedTracks[track] = true
                                            pcall(doJump)
                                            track.Stopped:Connect(function() playedTracks[track] = nil end)
                                        end
                                    end
                                end
                            end
                            task.wait(0.08)
                        end
                    end)
                end
            else
                monitoring = false
                playedTracks = {}
            end
        end
    })

    -- 保持物品栏
    LegitGroup:Toggle({
        Title = "保持物品栏开启",
        Description = "始终显示背包界面",
        Default = false,
        Callback = function(Value)
            if Value then
                local player = game.Players.LocalPlayer
                local backpackGui = player.PlayerGui:FindFirstChild("BackpackGui")
                if backpackGui then
                    backpackGui.Enabled = true
                    if not _G.BackpackConnection then
                        _G.BackpackConnection = backpackGui:GetPropertyChangedSignal("Enabled"):Connect(function()
                            if backpackGui.Enabled == false then
                                backpackGui.Enabled = true
                            end
                        end)
                    end
                end
                Notify("通知", "已开启物品栏保持", 3)
            else
                if _G.BackpackConnection then
                    _G.BackpackConnection:Disconnect()
                    _G.BackpackConnection = nil
                end
                Notify("通知", "已关闭物品栏保持", 3)
            end
        end
    })

    -- 无减速效果
    LegitGroup:Toggle({
        Title = "无减速效果",
        Description = "免疫所有减速效果",
        Default = false,
        Callback = function(Value)
            if Value then
                local player = game.Players.LocalPlayer
                local function EnforceSpeed()
                    local char = player.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                                if hum.WalkSpeed < 16 then
                                    hum.WalkSpeed = 16
                                end
                            end)
                            if hum.WalkSpeed < 16 then
                                hum.WalkSpeed = 16
                            end
                        end
                    end
                end
                EnforceSpeed()
                Notify("通知", "已开启无减速效果", 3)
            else
                Notify("通知", "已关闭无减速效果", 3)
            end
        end
    })

    -- 自救
    LegitGroup:Toggle({
        Title = "自救",
        Description = "被僵尸抓住时自动攻击解脱",
        Default = false,
        Callback = function(Value)
            if Value then
                _G.SelfRescueLoop = game:GetService("RunService").Heartbeat:Connect(function()
                    local player = game.Players.LocalPlayer
                    local char = player.Character
                    if not char then return end
                    local weapon = nil
                    for _, child in pairs(char:GetChildren()) do
                        if child:GetAttribute("Melee") then weapon = child break end
                    end
                    if not weapon then
                        local backpack = player.Backpack
                        for _, child in pairs(backpack:GetChildren()) do
                            if child:GetAttribute("Melee") then weapon = child break end
                        end
                    end
                    if weapon then
                        local zombies = workspace:FindFirstChild("Zombies")
                        if zombies then
                            for _, zombie in pairs(zombies:GetChildren()) do
                                pcall(function()
                                    if zombie:GetAttribute("Type") ~= "Barrel" and zombie:FindFirstChild("HumanoidRootPart") then
                                        local remote = char:FindFirstChild(weapon.Name)
                                        if remote and remote:FindFirstChild("RemoteEvent") then
                                            local remoteEvent = remote.RemoteEvent
                                            remoteEvent:FireServer("Swing", "Side")
                                            remoteEvent:FireServer("HitZombie", zombie, zombie.Head.CFrame.Position, true)
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end)
            else
                if _G.SelfRescueLoop then
                    _G.SelfRescueLoop:Disconnect()
                    _G.SelfRescueLoop = nil
                end
            end
        end
    })

    -- 防断腿
    LegitGroup:Toggle({
        Title = "防断腿",
        Description = "防止断腿",
        Default = false,
        Callback = function(state)
            _G.NoFallDamageEnabled = state
            if state then
                if not _G.BrokenLegsHook then
                    local rs = game:GetService("ReplicatedStorage")
                    local BrokenLegs = require(rs.Modules.Gameplay.CharacterStates.BrokenLegs)
                    _G.OriginalEntered = _G.OriginalEntered or BrokenLegs.Entered
                    _G.BrokenLegsHook = hookfunction(BrokenLegs.Entered, function(self, ...)
                        if _G.NoFallDamageEnabled then
                            self.RestrictsBackpack = false
                            self.RestrictsAutoRotate = false
                            self.KillsVelocity = false
                            return
                        end
                        return _G.OriginalEntered(self, ...)
                    end)   
                end
            else
                if _G.BrokenLegsHook and _G.OriginalEntered then
                    local rs = game:GetService("ReplicatedStorage")
                    local BrokenLegs = require(rs.Modules.Gameplay.CharacterStates.BrokenLegs)
                    BrokenLegs.Entered = _G.OriginalEntered
                    _G.BrokenLegsHook = nil
                end
            end
        end
    })
end

-- ########## 音乐环绕 ##########
do
    local LegitGroup = Tabs.w:Section({
        Title = "特效",
        Description = "视觉特效"
    })

    local AMOUNT = 40
    local BASE_DISTANCE = 7
    local HEIGHT = 1
    local SIZE = Vector3.new(0.3, 0.3, 0.3)
    local BEAT_FORCE = 0.012
    local SMOOTHING = 0.35
    local COLOR_SPEED = 0.15
    local PASTEL_SATURATION = 0.35
    local PASTEL_BRIGHTNESS = 1

    local SoundService = game:GetService("SoundService")
    local character, root
    local diamonds = {}
    local currentDistance = BASE_DISTANCE
    local colorTime = 0
    local Enabled = false
    local Connection = nil

    local function CreateDiamonds()
        for i = 1, AMOUNT do
            if diamonds[i] and diamonds[i].part then continue end
            local part = Instance.new("Part")
            part.Size = SIZE
            part.Anchored = true
            part.CanCollide = false
            part.Material = Enum.Material.Neon
            part.Parent = workspace
            diamonds[i] = { part = part, angle = (math.pi * 2 / AMOUNT) * i, colorOffset = i / AMOUNT }
        end
    end

    local function DestroyDiamonds()
        for _, data in ipairs(diamonds) do
            if data.part then data.part:Destroy() end
        end
        table.clear(diamonds)
    end

    local function setCharacter(char)
        character = char
        root = character:WaitForChild("HumanoidRootPart")
    end

    if player.Character then setCharacter(player.Character) end
    player.CharacterAdded:Connect(setCharacter)

    local function getLoudness()
        local loudness = 0
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Sound") and obj.IsPlaying and obj.Volume > 0 then
                loudness = math.max(loudness, obj.PlaybackLoudness)
            end
        end
        for _, obj in ipairs(SoundService:GetDescendants()) do
            if obj:IsA("Sound") and obj.IsPlaying and obj.Volume > 0 then
                loudness = math.max(loudness, obj.PlaybackLoudness)
            end
        end
        return loudness
    end

    local function Start()
        if Connection then return end
        CreateDiamonds()
        Connection = RunService.RenderStepped:Connect(function(dt)
            if not root then return end
            local loudness = getLoudness()
            colorTime += dt * COLOR_SPEED
            local target = BASE_DISTANCE - (loudness * BEAT_FORCE)
            target = math.clamp(target, BASE_DISTANCE - 2, BASE_DISTANCE)
            currentDistance += (target - currentDistance) * SMOOTHING
            for _, data in ipairs(diamonds) do
                local x = math.cos(data.angle) * currentDistance
                local z = math.sin(data.angle) * currentDistance
                local hue = (colorTime + data.colorOffset) % 1
                data.part.Color = Color3.fromHSV(hue, PASTEL_SATURATION, PASTEL_BRIGHTNESS)
                data.part.CFrame = CFrame.new(root.Position + Vector3.new(x, HEIGHT, z)) * CFrame.Angles(math.rad(45), math.rad(45), 0)
            end
        end)
    end

    local function Stop()
        if Connection then Connection:Disconnect() Connection = nil end
        DestroyDiamonds()
        colorTime = 0
        currentDistance = BASE_DISTANCE
    end

    LegitGroup:Toggle({
        Title = "音乐环绕",
        Description = "根据音乐节奏显示环绕",
        Default = false,
        Callback = function(v)
            Enabled = v
            if v then Start() else Stop() end
        end
    })

    -- 防坠落按钮
    LegitGroup:Button({
        Title = "防坠落",
        Color = Color3.fromHex("#999999"),
        Callback = function()
            local RunService = game:GetService("RunService")
            local LocalPlayer = game.Players.LocalPlayer

            local OldNamecall
            OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local Method = getnamecallmethod()
                local Args = {...}
                if Method == "FireServer" and typeof(self) == "Instance" and self.Name == "ForceSelfDamage" then
                    return nil
                end
                if Method == "SetStateEnabled" and typeof(self) == "Instance" and self:IsA("Humanoid") then
                    local stateArg = Args[1]
                    if typeof(stateArg) == "EnumItem" then
                        if stateArg == Enum.HumanoidStateType.FallingDown or stateArg == Enum.HumanoidStateType.Ragdoll or stateArg == Enum.HumanoidStateType.Freefall then
                            return OldNamecall(self, stateArg, false)
                        end
                    end
                end
                return OldNamecall(self, ...)
            end))

            RunService.PreRender:Connect(function()
                pcall(function()
                    local char = LocalPlayer.Character
                    if not char then return end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if not hum then return end
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
                end)
            end)
            Notify("通知", "防坠落已启用", 3)
        end
    })
end

-- ########## 命中框 ##########
do
    local HitboxGroup = Tabs.w:Section({
        Title = "命中框",
        Description = "命中框扩展设置"
    })

    local hitboxEnabled = false
    local hitboxSize = 10
    local MaxRange = 30
    local zombieFolder = Workspace:WaitForChild("Zombies")

    local function inRange(zombie)
        local hrp = zombie:FindFirstChild("HumanoidRootPart")
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not (hrp and myHrp) then return false end
        return (hrp.Position - myHrp.Position).Magnitude <= MaxRange
    end

    local function createHitbox(zombie, partName, attachPart, size)
        if zombie:FindFirstChild(partName) then return end
        local part = Instance.new("Part")
        part.Name = partName
        part.Size = size
        part.Transparency = 1
        part.CanCollide = false
        part.Massless = true
        part.Parent = zombie
        part.CFrame = attachPart.CFrame
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = attachPart
        weld.Part1 = part
        weld.Parent = part
    end

    local function updateZombie(zombie)
        if not zombie or not zombie.Parent then return end
        local hrp = zombie:FindFirstChild("HumanoidRootPart")
        local head = zombie:FindFirstChild("Head")
        if not (hrp and head) then return end
        if hitboxEnabled and inRange(zombie) then
            createHitbox(zombie, "OuterHitbox", hrp, Vector3.new(hitboxSize, hitboxSize, hitboxSize))
            createHitbox(zombie, "HeadHitbox", head, Vector3.new(hitboxSize/2, hitboxSize/2, hitboxSize/2))
        else
            local o = zombie:FindFirstChild("OuterHitbox")
            local h = zombie:FindFirstChild("HeadHitbox")
            if o then o:Destroy() end
            if h then h:Destroy() end
        end
    end

    RunService.Heartbeat:Connect(function()
        if not hitboxEnabled then return end
        for _, zombie in ipairs(zombieFolder:GetChildren()) do
            updateZombie(zombie)
        end
    end)

    zombieFolder.ChildAdded:Connect(function(zombie)
        task.wait(0.2)
        updateZombie(zombie)
    end)

    HitboxGroup:Toggle({
        Title = "命中框扩展",
        Description = "扩大僵尸命中框",
        Default = false,
        Callback = function(v) hitboxEnabled = v end
    })

    HitboxGroup:Slider({
        Title = "命中框大小",
        Description = "命中框的大小",
        Value = {
            Min = 1,
            Max = 30,
            Default = 10,
        },
        Callback = function(v) hitboxSize = v end
    })

    HitboxGroup:Slider({
        Title = "命中框范围",
        Description = "命中框生效范围",
        Value = {
            Min = 5,
            Max = 100,
            Default = 30,
        },
        Callback = function(v) MaxRange = v end
    })
end

-- ########## 自动射击 ##########
do
    local LOOK_DURATION = 0.28
    local MAX_TARGET_RANGE = 200
    local FIRE_DELAY_AFTER_LOOK = 0.03
    local BOMBER_CHECK_INTERVAL = 0.1
    local BOMBER_APPEAR_DELAY = 0.5
    local EPS = 1e-4
    local CHECK_WALLS = true
    local AUTO_RELOAD_ENABLED = false
    local USER_AUTO_SHOOT_TOGGLE = false
    local USER_AUTO_SHOOT_CAVALRY_TOGGLE = false
    local USER_AUTO_SHOOT_RUNNER_TOGGLE = false
    local USER_AUTO_SHOOT_ELECTROCUTIONER_TOGGLE = false
    local USER_AUTO_SHOOT_IGNITER_TOGGLE = false

    local lastReloadNotify = 0
    local NOTIFY_COOLDOWN = 4

    local function notifyReload()
        local now = tick()
        if now - lastReloadNotify < NOTIFY_COOLDOWN then return end
        lastReloadNotify = now
        Notify("自动装填", "已装填一发子弹。", 3)
    end

    local function isGun(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local animFolder = tool:FindFirstChild("Animations")
        if not animFolder then return false end
        if animFolder:FindFirstChild("Aim") then return true end
        if animFolder:FindFirstChild("Aiming") then return true end
        return false
    end

    local function getShotsLoadedForTool(tool)
        if not tool then return 0 end
        local s = tool:FindFirstChild("ShotsLoaded")
        if s and (s:IsA("IntValue") or s:IsA("NumberValue")) then return s.Value end
        return 0
    end

    local function findRemoteForTool(tool)
        if not tool then return nil end
        local remote = tool:FindFirstChild("RemoteEvent")
        if remote then return remote end
        return nil
    end

    local function tryReloadTool(tool)
        if not tool then return end
        if not AUTO_RELOAD_ENABLED then return end
        if not isGun(tool) then return end
        local shots = getShotsLoadedForTool(tool)
        if shots and shots == 0 then
            local remote = findRemoteForTool(tool)
            if remote then pcall(function() remote:FireServer("Reload") end) end
        end
    end

    local function isObstructedBetween(origin, targetPos, targetModel)
        if not CHECK_WALLS then return false end
        if not origin or not targetPos then return false end
        local dir = targetPos - origin
        local dist = dir.Magnitude
        if dist <= 0 then return false end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        local ignoreList = {}
        local camFolder = Workspace:FindFirstChild("Camera")
        if camFolder then
            for _, desc in ipairs(camFolder:GetDescendants()) do
                if desc and desc:IsA("Model") and desc.Name == "m_Zombie" then
                    table.insert(ignoreList, desc)
                end
            end
        end
        local zombiesFolder = Workspace:FindFirstChild("Zombies")
        if zombiesFolder then table.insert(ignoreList, zombiesFolder) end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl and pl.Character and pl.Character:IsA("Model") then
                table.insert(ignoreList, pl.Character)
            end
        end
        if targetModel then table.insert(ignoreList, targetModel) end
        params.FilterDescendantsInstances = ignoreList
        local result = Workspace:Raycast(origin, dir, params)
        return result ~= nil
    end

    local ZombieTypeMatchers = {
        Bomber = function(model) return model:FindFirstChild("Barrel") ~= nil end,
        Cuirassier = function(model) return model:FindFirstChild("Sword") ~= nil end,
        Runner = function(model) return model:FindFirstChild("Eye") and not model:FindFirstChild("Axe") and model:FindFirstChild("Head") end,
        Electrocutioner = function(model) return model:FindFirstChild("Axe") and model:FindFirstChild("Head") end,
        Igniter = function(model) return model:FindFirstChild("Whale Oil Lantern") ~= nil end,
    }

    local function getNearestTargetHeadByMatcher(range, matcherFunc)
        local camFolder = Workspace:FindFirstChild("Camera")
        local cam = Workspace.CurrentCamera
        local originPos = nil
        if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character.Parent then
            local head = LocalPlayer.Character:FindFirstChild("Head")
            if head and head:IsA("BasePart") then originPos = head.Position end
        end
        if not originPos and cam then originPos = cam.CFrame.Position end
        if not originPos then return nil, nil end
        local bestPart, bestDist, bestModel = nil, range + EPS, nil
        if not camFolder then return nil, nil end
        for _, model in ipairs(camFolder:GetChildren()) do
            if model:IsA("Model") and model.Name == "m_Zombie" then
                if not matcherFunc(model) then continue end
                local head = model:FindFirstChild("Head")
                local barrel = model:FindFirstChild("Barrel")
                local torso = model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso") or model:FindFirstChild("HumanoidRootPart")
                local measurePart = barrel or head or torso
                if measurePart and measurePart:IsA("BasePart") then
                    local okDist, d = pcall(function() return (measurePart.Position - originPos).Magnitude end)
                    if okDist and d and d <= range + EPS and d < bestDist then
                        if not isObstructedBetween(originPos, measurePart.Position, model) then
                            bestPart, bestDist, bestModel = measurePart, d, model
                        end
                    end
                end
            end
        end
        return bestPart, bestModel
    end

    local function smoothLookAtDynamic(rootPart, getPosFunc, duration)
        if not rootPart or not getPosFunc then return end
        local start = tick()
        local startCFrame = rootPart.CFrame
        local ok, initTarget = pcall(getPosFunc)
        if not ok or not initTarget then return end
        while tick() - start < duration do
            if not rootPart.Parent then return end
            local curPos = nil
            pcall(function() curPos = getPosFunc() end)
            if not curPos then curPos = initTarget end
            local desired = CFrame.new(rootPart.Position, Vector3.new(curPos.X, rootPart.Position.Y, curPos.Z))
            local t = math.clamp((tick() - start) / duration, 0, 1)
            local smoothT = t * t * (3 - 2 * t)
            local lerped = startCFrame:Lerp(desired, smoothT)
            local safeCFrame = CFrame.new(rootPart.Position, rootPart.Position + lerped.LookVector)
            pcall(function() rootPart.CFrame = safeCFrame end)
            RunService.RenderStepped:Wait()
        end
    end

    local function aimThenShootGun(targetModel, initialPart, tool)
        if not targetModel or not targetModel.Parent then return end
        if not initialPart or not initialPart.Parent or not initialPart:IsA("BasePart") then return end
        if not tool or not tool.Parent or not tool:IsDescendantOf(LocalPlayer.Character) then return end
        if not isGun(tool) then return end
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local remote = tool:FindFirstChild("RemoteEvent") or nil
        local root = char:FindFirstChild("HumanoidRootPart")
        if root and targetModel and targetModel.Parent then
            local function getPosFunc()
                return initialPart.Position
            end
            pcall(function() smoothLookAtDynamic(root, getPosFunc, LOOK_DURATION) end)
        end
        task.wait(FIRE_DELAY_AFTER_LOOK)
        if not initialPart or not initialPart.Parent then return end
        pcall(function()
            local modelRef = char:FindFirstChild("Model") or char
            local t = Workspace:GetServerTimeNow()
            remote = remote or tool:FindFirstChild("RemoteEvent")
            if remote and initialPart and initialPart.Parent then
                remote:FireServer("Fire", modelRef, initialPart.Position, t)
            end
        end)
    end

    local isAiming = false
    task.spawn(function()
        while true do
            if not isAiming then
                isAiming = true
                local equippedTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                local equippedIsGun = equippedTool and isGun(equippedTool)
                local shotsForEquipped = (equippedTool and equippedIsGun) and getShotsLoadedForTool(equippedTool) or 0
                
                if USER_AUTO_SHOOT_TOGGLE and equippedIsGun and shotsForEquipped >= 1 then
                    local part, model = getNearestTargetHeadByMatcher(MAX_TARGET_RANGE, ZombieTypeMatchers.Bomber)
                    if part and model then
                        task.wait(BOMBER_APPEAR_DELAY)
                        local currentTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if currentTool and currentTool == equippedTool then
                            aimThenShootGun(model, part, currentTool)
                        end
                    end
                end
                
                if USER_AUTO_SHOOT_CAVALRY_TOGGLE and equippedIsGun and shotsForEquipped >= 1 then
                    local part, model = getNearestTargetHeadByMatcher(MAX_TARGET_RANGE, ZombieTypeMatchers.Cuirassier)
                    if part and model then
                        task.wait(BOMBER_APPEAR_DELAY)
                        local currentTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if currentTool and currentTool == equippedTool then
                            aimThenShootGun(model, part, currentTool)
                        end
                    end
                end

                if USER_AUTO_SHOOT_RUNNER_TOGGLE and equippedIsGun and shotsForEquipped >= 1 then
                    local part, model = getNearestTargetHeadByMatcher(MAX_TARGET_RANGE, ZombieTypeMatchers.Runner)
                    if part and model then
                        task.wait(BOMBER_APPEAR_DELAY)
                        local currentTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if currentTool and currentTool == equippedTool then
                            aimThenShootGun(model, part, currentTool)
                        end
                    end
                end

                if USER_AUTO_SHOOT_ELECTROCUTIONER_TOGGLE and equippedIsGun and shotsForEquipped >= 1 then
                    local part, model = getNearestTargetHeadByMatcher(MAX_TARGET_RANGE, ZombieTypeMatchers.Electrocutioner)
                    if part and model then
                        task.wait(BOMBER_APPEAR_DELAY)
                        local currentTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if currentTool and currentTool == equippedTool then
                            aimThenShootGun(model, part, currentTool)
                        end
                    end
                end

                if USER_AUTO_SHOOT_IGNITER_TOGGLE and equippedIsGun and shotsForEquipped >= 1 then
                    local part, model = getNearestTargetHeadByMatcher(MAX_TARGET_RANGE, ZombieTypeMatchers.Igniter)
                    if part and model then
                        task.wait(BOMBER_APPEAR_DELAY)
                        local currentTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if currentTool and currentTool == equippedTool then
                            aimThenShootGun(model, part, currentTool)
                        end
                    end
                end
                
                task.wait(0.05)
                isAiming = false
            end
            task.wait(BOMBER_CHECK_INTERVAL)
        end
    end)

    local GunModSection = Tabs.w:Section({
        Title = "枪械模组",
        Description = "自动射击设置"
    })

    local ShootingSection = Tabs.w:Section({
        Title = "射击",
        Description = "自动射击目标选择"
    })

    ShootingSection:Toggle({
        Title = "自动射击炸弹僵尸",
        Description = "射击炸弹僵尸",
        Default = false,
        Callback = function(state) USER_AUTO_SHOOT_TOGGLE = state end
    })

    ShootingSection:Toggle({
        Title = "自动射击胸甲骑兵",
        Description = "自动瞄准并射击胸甲骑兵",
        Default = false,
        Callback = function(state) USER_AUTO_SHOOT_CAVALRY_TOGGLE = state end
    })

    ShootingSection:Toggle({
        Title = "自动射击奔跑者",
        Description = "自动瞄准并射击奔跑者",
        Default = false,
        Callback = function(state) USER_AUTO_SHOOT_RUNNER_TOGGLE = state end
    })

    ShootingSection:Toggle({
        Title = "自动射击斧头者",
        Description = "自动瞄准并射击斧头者",
        Default = false,
        Callback = function(state) USER_AUTO_SHOOT_ELECTROCUTIONER_TOGGLE = state end
    })

    ShootingSection:Toggle({
        Title = "自动射击点燃者",
        Description = "自动瞄准并射击点燃者",
        Default = false,
        Callback = function(state) USER_AUTO_SHOOT_IGNITER_TOGGLE = state end
    })

    ShootingSection:Slider({
        Title = "最大目标范围",
        Description = "最大检测范围",
        Value = {
            Min = 50,
            Max = 600,
            Default = 200,
        },
        Callback = function(val) MAX_TARGET_RANGE = val end
    })

    ShootingSection:Toggle({
        Title = "墙壁检查 (射线检测)",
        Description = "墙后的目标将被忽略",
        Default = true,
        Callback = function(state) CHECK_WALLS = state end
    })

    GunModSection:Toggle({
        Title = "自动装填",
        Description = "自动装填, 与自动射击配合良好",
        Default = false,
        Callback = function(state)
            AUTO_RELOAD_ENABLED = state
            Notify("自动装填", state and "自动装填已启用" or "自动装填已禁用", 2)
        end
    })

    -- 监视工具
    local function monitorCharacterTools(char)
        if not char then return end
        for _, c in ipairs(char:GetChildren()) do
            if c:IsA("Tool") and isGun(c) then
                pcall(function() tryReloadTool(c) end)
            end
        end
        char.ChildAdded:Connect(function(child)
            if child and child:IsA("Tool") and isGun(child) then
                pcall(function() tryReloadTool(child) end)
            end
        end)
    end
    LocalPlayer.CharacterAdded:Connect(monitorCharacterTools)
    if LocalPlayer.Character then monitorCharacterTools(LocalPlayer.Character) end
end

-- ########## 透视与僵尸警报 ##########
do
    local ESPSection = Tabs.e:Section({
        Title = "透视与僵尸警报",
        Description = "僵尸透视和警报设置"
    })

    local RunService = RunService or game:GetService("RunService")
    local CameraFolder = workspace:FindFirstChild("Camera")
    local IdentifiedIgniters = {}
    
    local ESPConfigs = {
        Bomber = { color = Color3.fromRGB(255, 180, 60), label = "自爆僵尸", match = function(model) if not model or not model:IsA("Model") then return false end return model:FindFirstChild("Barrel", true) ~= nil end },
        Cuirassier = { color = Color3.fromRGB(0, 200, 255), label = "胸甲骑兵", match = function(model) return model:FindFirstChild("Sword", true) ~= nil end },
        Runner = { color = Color3.fromRGB(255, 0, 0), label = "红眼", match = function(model) return model:FindFirstChild("Eye") and not model:FindFirstChild("Axe") and model:FindFirstChild("Head") end },
        Zapper = { color = Color3.fromRGB(0, 255, 0), label = "斧头", match = function(model) return model:FindFirstChild("Axe") and model:FindFirstChild("Head") end },
        Igniter = { color = Color3.fromRGB(255, 255, 0), label = "提灯人", match = function(model) if not model or not model:IsA("Model") then return false end if model:FindFirstChild("Whale Oil Lantern") then IdentifiedIgniters[model] = true return true end return IdentifiedIgniters[model] or false end },
    }
    
    local ESPData = { Bomber = {}, Cuirassier = {}, Runner = {}, Zapper = {}, Igniter = {} }
    local EnabledESPs = { Bomber = false, Cuirassier = false, Runner = false, Zapper = false, Igniter = false }
    local ShowBillboards = false
    local ChamsTransparency = 0.6
    local PerformanceMode = false
    local activeCount = 0
    local scanLoop, renderConn

    local function GetAdorneePart(model)
        if not model or not model:IsA("Model") then return nil end
        local head = model:FindFirstChild("Head", true)
        if head and head:IsA("BasePart") then return head end
        local hrp = model:FindFirstChild("HumanoidRootPart", true)
        if hrp and hrp:IsA("BasePart") then return hrp end
        if model.PrimaryPart and model.PrimaryPart:IsA("BasePart") then return model.PrimaryPart end
        for _, p in ipairs(model:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "Whale Oil Lantern" then return p end
        end
        return nil
    end

    local function CreateVisual(espType, zombie)
        if not zombie or not zombie:IsA("Model") or ESPData[espType][zombie] then return end
        local config = ESPConfigs[espType]
        local headPart = GetAdorneePart(zombie)
        if not headPart then return end
        local data = {}
        ESPData[espType][zombie] = data
        local offset = Vector3.new(0, 3, 0)
        if not PerformanceMode then
            local hl = Instance.new("Highlight")
            hl.Name = espType .. "Highlight"
            hl.Adornee = zombie
            hl.FillColor = config.color
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = ChamsTransparency
            hl.OutlineTransparency = 0
            hl.Parent = zombie
            data.highlight = hl
        end
    end

    local function RemoveVisual(espType, zombie)
        local data = ESPData[espType][zombie]
        if not data then return end
        pcall(function()
            if data.highlight then data.highlight:Destroy() end
            if data.billboard then data.billboard:Destroy() end
        end)
        ESPData[espType][zombie] = nil
    end

    local function ScanAll()
        if not CameraFolder then return end
        local children = CameraFolder:GetChildren()
        for espType, enabled in pairs(EnabledESPs) do
            if enabled then
                for _, z in ipairs(children) do
                    if z:IsA("Model") and z.Name == "m_Zombie" then
                        if ESPConfigs[espType].match(z) and not ESPData[espType][z] then
                            CreateVisual(espType, z)
                        end
                    end
                end
            end
        end
    end

    local function StartShared()
        activeCount = activeCount + 1
        if activeCount == 1 then
            ScanAll()
            scanLoop = task.spawn(function()
                while activeCount > 0 do
                    ScanAll()
                    task.wait(0.25)
                end
            end)
        end
    end

    local function StopShared()
        activeCount = activeCount - 1
        if activeCount == 0 then
            if scanLoop then task.cancel(scanLoop) scanLoop = nil end
            if renderConn then renderConn:Disconnect() renderConn = nil end
        end
    end

    ESPSection:Toggle({
        Title = "自爆透视",
        Description = "显示所有自爆!",
        Default = false,
        Callback = function(state)
            EnabledESPs.Bomber = state
            if state then StartShared() else for z in pairs(ESPData.Bomber) do RemoveVisual("Bomber", z) end ESPData.Bomber = {} StopShared() end
        end
    })

    ESPSection:Toggle({
        Title = "胸甲骑兵透视",
        Description = "显示胸甲骑兵僵尸",
        Default = false,
        Callback = function(state)
            EnabledESPs.Cuirassier = state
            if state then StartShared() else for z in pairs(ESPData.Cuirassier) do RemoveVisual("Cuirassier", z) end ESPData.Cuirassier = {} StopShared() end
        end
    })

    ESPSection:Toggle({
        Title = "胸甲骑兵冲锋警报",
        Description = "当胸甲骑兵僵尸冲锋时发出警告",
        Default = false,
        Callback = function(state)
            Notify("胸甲骑兵冲锋", state and "冲锋警报开启" or "冲锋警报关闭", 2)
        end
    })

    ESPSection:Toggle({
        Title = "红眼透视",
        Description = "显示所有红眼僵尸",
        Default = false,
        Callback = function(state)
            EnabledESPs.Runner = state
            if state then StartShared() else for z in pairs(ESPData.Runner) do RemoveVisual("Runner", z) end ESPData.Runner = {} StopShared() end
        end
    })

    ESPSection:Toggle({
        Title = "斧头透视",
        Description = "显示所有斧头者僵尸",
        Default = false,
        Callback = function(state)
            EnabledESPs.Zapper = state
            if state then StartShared() else for z in pairs(ESPData.Zapper) do RemoveVisual("Zapper", z) end ESPData.Zapper = {} StopShared() end
        end
    })

    ESPSection:Toggle({
        Title = "提灯人透视",
        Description = "显示所有提灯人",
        Default = false,
        Callback = function(state)
            EnabledESPs.Igniter = state
            if state then StartShared() else for z in pairs(ESPData.Igniter) do RemoveVisual("Igniter", z) end ESPData.Igniter = {} IdentifiedIgniters = {} StopShared() end
        end
    })

    local SettingsSection = Tabs.e:Section({
        Title = "设置",
        Description = "透视设置"
    })

    SettingsSection:Toggle({
        Title = "显示标签",
        Description = "切换僵尸上方的标签",
        Default = false,
        Callback = function(state) ShowBillboards = state end
    })

    SettingsSection:Slider({
        Title = "透视透明度",
        Description = "透视的透明度",
        Value = {
            Min = 0,
            Max = 1,
            Default = 0.6,
        },
        Callback = function(value)
            ChamsTransparency = math.clamp(tonumber(value) or 0.6, 0, 1)
        end
    })

    SettingsSection:Toggle({
        Title = "性能模式",
        Description = "将透视变为点并简化标签",
        Default = false,
        Callback = function(state) PerformanceMode = state end
    })
end

-- ########## 杀戮光环 合法 (完整移植版) ##########
do
    local PlayersSvc = Players or game:GetService("Players")
    local WorkspaceSvc = Workspace or game:GetService("Workspace")
    local LocalPlayer = PlayersSvc.LocalPlayer
    
    local KillAuraEnabled = false
    local KillAuraRange = 19
    local LoopInterval = 0.01
    local KillAuraSpamCount = 1
    local MultiTarget = 1
    local TargetESP = false
    local FOVEnabled = false
    local FOVVisible = false
    local FOVSize = 90
    local AutoLook = false
    
    local remotes = {}
    local HeadCache = {}
    local lastRemoteScan = 0
    local zombiesFolder = WorkspaceSvc:FindFirstChild("Zombies")
    local dots = {}
    local fovCircle = Drawing and Drawing.new and Drawing.new("Circle") or nil
    if fovCircle then
        fovCircle.Color = Color3.fromRGB(255, 255, 255)
        fovCircle.Thickness = 2
        fovCircle.NumSides = 100
        fovCircle.Filled = false
        fovCircle.Visible = false
    end
    
    local renderConn = nil
    local autoLookConn = nil
    local currentAuraLoopId = 0
    
    local function distSqVec3(a,b)
        local dx, dy, dz = a.X - b.X, a.Y - b.Y, a.Z - b.Z
        return dx*dx + dy*dy + dz*dz
    end
    
    local function findHead(zombie)
        if not (zombie and zombie:IsA("Model")) then return nil end
        local head = zombie:FindFirstChild("Head") or zombie:FindFirstChild("head")
        if head and head:IsA("BasePart") then return head end
        local hrp = zombie:FindFirstChild("HumanoidRootPart")
        if hrp and hrp:IsA("BasePart") then return hrp end
        if zombie.PrimaryPart and zombie.PrimaryPart:IsA("BasePart") then return zombie.PrimaryPart end
        local children = zombie:GetChildren()
        local possible = children[12]
        if possible and possible:IsA("BasePart") then return possible end
        for _, p in ipairs(zombie:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "Whale Oil Lantern" then return p end
        end
        return nil
    end
    
    local function addHeadToCache(model)
        if not (model and model:IsA("Model")) then return end
        local isZombie = false
        if zombiesFolder then
            isZombie = model:IsDescendantOf(zombiesFolder) or model.Parent == zombiesFolder
        else
            local nm = tostring(model.Name or ""):lower()
            isZombie = nm == "m_zombie" or nm:find("zombie")
        end
        if not isZombie then return end
        local ok, head = pcall(findHead, model)
        if ok and head then HeadCache[model] = head end
    end
    
    local function removeFromCaches(model) HeadCache[model] = nil end
    
    if zombiesFolder then
        for _, z in ipairs(zombiesFolder:GetChildren()) do if z:IsA("Model") then addHeadToCache(z) end end
        zombiesFolder.ChildAdded:Connect(function(c) if c and c:IsA("Model") then task.delay(0.03, function() addHeadToCache(c) end) end end)
        zombiesFolder.ChildRemoved:Connect(function(c) if c then removeFromCaches(c) end end)
    else
        for _, obj in ipairs(WorkspaceSvc:GetDescendants()) do
            if obj:IsA("Model") and (tostring(obj.Name) == "m_Zombie" or tostring(obj.Name):lower():find("zombie")) then addHeadToCache(obj) end
        end
    end
    
    local function ScanRemotesNow()
        table.clear(remotes)
        local char = LocalPlayer and LocalPlayer.Character
        if not char then return end
        for _, tool in ipairs(char:GetChildren()) do
            if tool and tool:IsA("Tool") then
                for _, ch in ipairs(tool:GetChildren()) do
                    if ch and ch:IsA("RemoteEvent") then remotes[ch] = true end
                end
            end
        end
        lastRemoteScan = tick()
    end
    
    if LocalPlayer then
        LocalPlayer.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            ScanRemotesNow()
            char.ChildAdded:Connect(function(c) if c and c:IsA("Tool") then task.delay(0.05, ScanRemotesNow) end end)
            char.ChildRemoved:Connect(function(c) if c and c:IsA("Tool") then task.delay(0.05, ScanRemotesNow) end end)
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.AutoRotate = true end
        end)
        if LocalPlayer.Character then task.defer(ScanRemotesNow) end
    end
    
    local function fireSwing(remote)
        if remote and remote:IsA("RemoteEvent") then
            pcall(function() remote:FireServer("Swing", "Thrust") end)
        end
    end
    
    local function fireHit(remote, model, headPos)
        if not (remote and remote:IsA("RemoteEvent") and model and headPos) then return end
        pcall(function()
            remote:FireServer("HitZombie", model, headPos, true, Vector3.new(0,15,0), "Head", Vector3.new(0,1,0))
        end)
    end
    
    local function isInFOV(pos)
        local cam = WorkspaceSvc.CurrentCamera
        if not cam then return false end
        local camPos = cam.CFrame.Position
        local camLook = cam.CFrame.LookVector
        local dir = (pos - camPos)
        local dist = dir.Magnitude
        if dist == 0 then return true end
        local unit = dir / dist
        local dot = unit:Dot(camLook)
        return dot >= math.cos(math.rad(FOVSize / 2))
    end
    
    local function getTargetsInRange(range, hrpPos, useFOV)
        local rangeSq = range * range
        local targets = {}
        if not hrpPos then return targets end
        for model, head in pairs(HeadCache) do
            if not (model and model.Parent and head and head.Parent) then HeadCache[model] = nil continue end
            local hum = model:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then continue end
            local ok, pos = pcall(function() return head.Position end)
            if not ok or not pos then continue end
            local d2 = distSqVec3(pos, hrpPos)
            if d2 <= rangeSq then
                if not useFOV or isInFOV(pos) then
                    targets[#targets+1] = { model = model, head = head, d2 = d2, headPos = pos }
                end
            end
        end
        table.sort(targets, function(a,b) return a.d2 < b.d2 end)
        return targets
    end
    
    -- 主动作循环
    task.spawn(function()
        while true do
            task.wait(LoopInterval or 0.1)
            if not KillAuraEnabled then continue end
            currentAuraLoopId = currentAuraLoopId + 1
            local loopId = currentAuraLoopId
            local char = LocalPlayer and LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            if tick() - lastRemoteScan > 1 then ScanRemotesNow() end
            local trueRange = KillAuraRange or 19
            local targets = getTargetsInRange(trueRange, hrp.Position, FOVEnabled)
            if #targets == 0 then continue end
            local maxTargets = math.max(1, math.floor(MultiTarget or 1))
            for i = 1, math.min(#targets, maxTargets) do
                if not KillAuraEnabled or loopId ~= currentAuraLoopId then break end
                local entry = targets[i]
                if not entry then break end
                for remote in pairs(remotes) do
                    if remote then
                        task.spawn(function()
                            if not KillAuraEnabled or loopId ~= currentAuraLoopId then return end
                            local spamCount = math.max(1, math.floor(KillAuraSpamCount or 1))
                            for s = 1, spamCount do
                                if not KillAuraEnabled or loopId ~= currentAuraLoopId then break end
                                fireSwing(remote)
                                task.wait(0.01)
                                if not KillAuraEnabled or loopId ~= currentAuraLoopId then break end
                                local headPos = entry.headPos or (entry.head and entry.head.Position)
                                if headPos then fireHit(remote, entry.model, headPos) end
                            end
                        end)
                    end
                end
            end
        end
    end)
    
    -- 视觉更新
    local function updateVisuals()
        local char = LocalPlayer and LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local cam = WorkspaceSvc.CurrentCamera
        if not (char and hrp and cam) then
            for _, d in pairs(dots) do if d then d.Visible = false end end
            if fovCircle then fovCircle.Visible = false end
            return
        end
        if TargetESP then
            local tool = char:FindFirstChildWhichIsA("Tool")
            local restPos = hrp.Position
            if tool then
                local handle = tool:FindFirstChild("Handle")
                if handle then restPos = handle.Position end
            end
            local trueRange = KillAuraRange or 19
            local targets = getTargetsInRange(trueRange, hrp.Position, FOVEnabled)
            local maxDots = math.max(1, math.floor(MultiTarget or 1))
            for i = 1, maxDots do
                local dot = dots[i]
                if not dot and Drawing and Drawing.new then
                    dot = Drawing.new("Circle")
                    dot.Color = Color3.fromRGB(255, 0, 0)
                    dot.Thickness = 1
                    dot.NumSides = 12
                    dot.Radius = 5
                    dot.Filled = true
                    dot.Transparency = 1
                    dot.Visible = false
                    dots[i] = dot
                end
                local targetPos
                if i <= #targets then targetPos = targets[i].headPos or targets[i].head.Position
                else targetPos = restPos end
                local screenPos, onScreen = cam:WorldToViewportPoint(targetPos)
                if dot then
                    if onScreen then
                        dot.Position = Vector2.new(screenPos.X, screenPos.Y)
                        dot.Visible = true
                    else dot.Visible = false end
                end
            end
            for i = (math.max(1, math.floor(MultiTarget or 1)) + 1), #dots do if dots[i] then dots[i].Visible = false end end
        else
            for _, d in pairs(dots) do if d then d.Visible = false end end
        end
        if FOVVisible and fovCircle then
            local size = cam.ViewportSize
            local center = size / 2
            fovCircle.Position = center
            local fovRad = math.rad(FOVSize)
            local camFovRad = math.rad(cam.FieldOfView)
            local radius = (math.tan(fovRad / 2) / math.tan(camFovRad / 2)) * (size.Y / 2)
            fovCircle.Radius = radius
            fovCircle.Visible = true
        elseif fovCircle then fovCircle.Visible = false end
    end
    
    local function manageRenderLoop()
        if (TargetESP or FOVVisible) and not renderConn then
            renderConn = RunService.RenderStepped:Connect(updateVisuals)
        elseif not (TargetESP or FOVVisible) and renderConn then
            renderConn:Disconnect()
            renderConn = nil
            for _, d in pairs(dots) do if d then d.Visible = false end end
            if fovCircle then fovCircle.Visible = false end
        end
    end
    
    local function updateAutoLook()
        local char = LocalPlayer and LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not (hrp and hum) then return end
        local autoLookRange = 30
        local targets = getTargetsInRange(autoLookRange, hrp.Position, false)
        if #targets == 0 then
            if not hum.AutoRotate then hum.AutoRotate = true end
            return
        end
        if hum.AutoRotate then hum.AutoRotate = false end
        local closest = targets[1]
        if not closest or not closest.head or not closest.head.Parent then return end
        local headPos = closest.headPos or closest.head.Position
        if not headPos then return end
        local direction = (headPos - hrp.Position)
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude <= 0.01 then return end
        local targetCFrame = CFrame.lookAt(hrp.Position, hrp.Position + flatDir)
        hrp.CFrame = hrp.CFrame:Lerp(targetCFrame, 0.25)
    end
    
    local function manageAutoLook()
        local char = LocalPlayer and LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if AutoLook and not autoLookConn then
            autoLookConn = RunService.Heartbeat:Connect(updateAutoLook)
            if hum then hum.AutoRotate = true end
        elseif not AutoLook and autoLookConn then
            autoLookConn:Disconnect()
            autoLookConn = nil
            if hum then hum.AutoRotate = true end
        end
    end
    
    manageRenderLoop()
    manageAutoLook()
    
    -- ########## UI 部分 ##########
    local MainSection = Tabs.r:Section({
        Title = "杀戮光环",
        Description = "合法击杀范围内的僵尸"
    })
    
    MainSection:Toggle({
        Title = "杀戮光环(半合法)",
        Description = "自动击杀范围内的僵尸",
        Default = false,
        Callback = function(v)
            KillAuraEnabled = v
            if v then
                ScanRemotesNow()
            else
                currentAuraLoopId = currentAuraLoopId + 1
            end
        end
    })
    
    MainSection:Slider({
        Title = "杀戮光环范围",
        Description = "攻击范围",
        Value = {
            Min = 5,
            Max = 30,
            Default = 19,
        },
        Callback = function(v) KillAuraRange = v end
    })
    
    MainSection:Slider({
        Title = "攻击速度",
        Description = "攻击速度等级",
        Value = {
            Min = 1,
            Max = 5,
            Default = 1,
        },
        Callback = function(v) KillAuraSpamCount = math.max(1, math.floor(v)) end
    })
    
    local SettingsSection2 = Tabs.r:Section({
        Title = "合法设置",
        Description = "合法杀戮光环设置"
    })
    
    SettingsSection2:Slider({
        Title = "多目标",
        Description = "每次攻击击杀多少僵尸",
        Value = {
            Min = 1,
            Max = 10,
            Default = 1,
        },
        Callback = function(v) MultiTarget = math.max(1, math.floor(v)) end
    })
    
    SettingsSection2:Toggle({
        Title = "目标透视",
        Description = "显示当前瞄准的僵尸",
        Default = false,
        Callback = function(v)
            TargetESP = v
            if not v then for _, d in pairs(dots) do if d then d.Visible = false end end dots = {} end
            manageRenderLoop()
        end
    })
    
    SettingsSection2:Slider({
        Title = "视野大小",
        Description = "视野圆圈的大小",
        Value = {
            Min = 10,
            Max = 180,
            Default = 90,
        },
        Callback = function(v) FOVSize = v end
    })
    
    SettingsSection2:Toggle({
        Title = "启用视野",
        Description = "只瞄准视野内的僵尸",
        Default = false,
        Callback = function(v) FOVEnabled = v end
    })
    
    SettingsSection2:Toggle({
        Title = "显示视野",
        Description = "显示视野圆圈",
        Default = false,
        Callback = function(v)
            FOVVisible = v
            if not v and fovCircle then fovCircle.Visible = false end
            manageRenderLoop()
        end
    })
    
    SettingsSection2:Toggle({
        Title = "自动注视",
        Description = "自动看向最近的僵尸",
        Default = false,
        Callback = function(v)
            AutoLook = v
            manageAutoLook()
        end
    })
end

-- ########## 玩家透视 ##########
do
    local PlayerESPSection = Tabs.y:Section({
        Title = "玩家透视",
        Description = "玩家相关透视功能"
    })

    local ChamsESPEnabled = false
    local BillboardESPEnabled = false
    local PlayerESPData = {}

    local function RemovePlayerESP(player)
        local data = PlayerESPData[player]
        if not data then return end
        pcall(function()
            if data.Highlight then data.Highlight:Destroy() end
        end)
        PlayerESPData[player] = nil
    end

    local function CreatePlayerESP(player)
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if not hum then return end
        RemovePlayerESP(player)
        local highlight = nil
        if ChamsESPEnabled then
            highlight = Instance.new("Highlight")
            highlight.Name = "PlayerCham"
            highlight.Adornee = char
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.FillTransparency = 0.45
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.Parent = char
        end
        PlayerESPData[player] = { Char = char, Highlight = highlight }
    end

    RunService.Heartbeat:Connect(function()
        if not (ChamsESPEnabled or BillboardESPEnabled) then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local data = PlayerESPData[player]
                if not player.Character or not player.Character.Parent then
                    if data then RemovePlayerESP(player) end
                    continue
                end
                if not data or data.Char ~= player.Character then
                    CreatePlayerESP(player)
                end
            end
        end
    end)

    PlayerESPSection:Toggle({
        Title = "玩家透视 (Chams)",
        Description = "在玩家上显示Chams透视",
        Default = false,
        Callback = function(state)
            ChamsESPEnabled = state
            if state then
                Notify("玩家透视", "玩家Chams透视已启用", 2)
            else
                for p in pairs(PlayerESPData) do RemovePlayerESP(p) end
                Notify("玩家透视", "玩家Chams透视已禁用", 2)
            end
        end
    })

    local GrabbedSection = Tabs.y:Section({
        Title = "被抓与压制",
        Description = "玩家状态通知"
    })

    GrabbedSection:Toggle({
        Title = "被抓与被压制玩家通知",
        Description = "当玩家被抓或被压制时通知",
        Default = false,
        Callback = function(state)
            Notify("被抓/压制监视器", state and "监视器开启" or "监视器关闭", 2)
        end
    })
end

-- ########## 其他 标签页 ##########
do
    local MovementSection = Tabs.p:Section({
        Title = "移动",
        Description = "移动相关设置"
    })

    local desiredWalkSpeed = 16
    local walkLoopEnabled = false
    local heartbeatConn = nil

    local function safeSetWalk(hum, speed)
        if not (hum and hum.Parent) then return end
        pcall(function() hum.WalkSpeed = speed end)
    end

    local function startWalkForceLoop()
        if heartbeatConn then heartbeatConn:Disconnect() end
        heartbeatConn = RunService.Heartbeat:Connect(function()
            if not walkLoopEnabled then return end
            local char = LocalPlayer and LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then safeSetWalk(hum, desiredWalkSpeed) end
            end
        end)
    end

    local function stopWalkForceLoop()
        if heartbeatConn then heartbeatConn:Disconnect() heartbeatConn = nil end
        pcall(function()
            local char = LocalPlayer and LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 16 end
            end
        end)
    end

    MovementSection:Slider({
        Title = "移动速度",
        Description = "设置移动速度",
        Value = {
            Min = 16,
            Max = 45,
            Default = 16,
        },
        Callback = function(v)
            desiredWalkSpeed = math.clamp(tonumber(v) or desiredWalkSpeed, 16, 45)
            Notify("移动", "移动速度设置为 " .. tostring(desiredWalkSpeed), 2)
        end
    })

    MovementSection:Toggle({
        Title = "应用移动速度",
        Description = "强制移动速度",
        Default = false,
        Callback = function(state)
            walkLoopEnabled = state
            if state then startWalkForceLoop() else stopWalkForceLoop() end
        end
    })

    local VisualSection = Tabs.p:Section({
        Title = "视觉",
        Description = "视觉效果设置"
    })

    local fullbrightEnabled = false
    local fullbrightConn = nil
    local noFogEnabled = false
    local noFogConn = nil

    local originalLighting = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        GlobalShadows = Lighting.GlobalShadows,
    }

    local function startFullbright()
        if fullbrightConn then fullbrightConn:Disconnect() end
        fullbrightConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.FogEnd = 1e6
                Lighting.GlobalShadows = false
            end)
        end)
    end

    local function stopFullbright()
        if fullbrightConn then fullbrightConn:Disconnect() fullbrightConn = nil end
        pcall(function()
            Lighting.Brightness = originalLighting.Brightness
            Lighting.ClockTime = originalLighting.ClockTime
            Lighting.FogEnd = originalLighting.FogEnd
            Lighting.GlobalShadows = originalLighting.GlobalShadows
        end)
    end

    VisualSection:Toggle({
        Title = "全亮",
        Description = "循环全亮",
        Default = false,
        Callback = function(state)
            fullbrightEnabled = state
            if state then startFullbright() else stopFullbright() end
        end
    })

    local function startNoFog()
        if noFogConn then noFogConn:Disconnect() end
        noFogConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                Lighting.FogEnd = 1e6
            end)
        end)
    end

    local function stopNoFog()
        if noFogConn then noFogConn:Disconnect() noFogConn = nil end
        pcall(function()
            Lighting.FogEnd = originalLighting.FogEnd
        end)
    end

    VisualSection:Toggle({
        Title = "无雾",
        Description = "开启无雾",
        Default = false,
        Callback = function(state)
            noFogEnabled = state
            if state then startNoFog() else stopNoFog() end
        end
    })

    local ServerSection = Tabs.p:Section({
        Title = "服务器工具",
        Description = "服务器相关功能"
    })

    ServerSection:Button({
        Title = "重新加入服务器",
        Color = Color3.fromHex("#999999"),
        Callback = function()
            Notify("服务器", "正在重新加入服务器...", 3)
            pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
        end
    })

    ServerSection:Button({
        Title = "切换服务器",
        Color = Color3.fromHex("#999999"),
        Callback = function()
            Notify("服务器", "正在寻找新服务器...", 3)
            local servers = {}
            local success, result = pcall(function()
                return game:HttpGet(string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", game.PlaceId))
            end)
            if success and result and type(result) == "string" then
                local ok, data = pcall(function() return HttpService:JSONDecode(result) end)
                if ok and data and data.data then
                    for _, v in pairs(data.data) do
                        if v.playing < v.maxPlayers and v.id ~= game.JobId then table.insert(servers, v.id) end
                    end
                end
            end
            if #servers > 0 then
                pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1,#servers)], LocalPlayer) end)
            else
                Notify("错误", "未找到可用服务器。", 5)
            end
        end
    })
end

-- ########## 界面设置 标签页 ##########
do
    local MenuGroup = Tabs["界面设置"]:Section({
        Title = "菜单",
        Description = "界面相关设置"
    })

    MenuGroup:Button({
        Title = "卸载脚本",
        Color = Color3.fromHex("#FF4444"),
        Callback = function()
            if nowe then toggleFly(false) end
            if isAntiSelfDamage then toggleAntiSelfDamageFunc(false) end
            if isAntiKnockback then toggleAntiKnockbackFunc(false) end
            if isAntiRagdoll then toggleAntiRagdollFunc(false) end
            Window:Destroy()
        end
    })
end

-- ########## 角色重生处理 ##########
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.7)
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    local humRootPart = char:FindFirstChild("HumanoidRootPart")
    
    if hum then hum.PlatformStand = false end
    if humRootPart then humRootPart.CanCollide = true end
    if char:FindFirstChild("Animate") then char.Animate.Disabled = false end
    
    nowe = false
    tpwalking = false
    speeds = 1
    
    if isAntiSelfDamage then
        if namecallHook1 then hookmetamethod(game, "__namecall", namecallHook1) end
        namecallHook1 = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod():lower()
            if self.Name == "ForceSelfDamage" and method == "fireserver" then return nil end
            return namecallHook1(self, ...)
        end))
    end
    
    if isAntiKnockback then
        if renderConnection then renderConnection:Disconnect() end
        renderConnection = RunService.RenderStepped:Connect(function(deltaTime)
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if not hum then return end
            local antiFlingObj = char:FindFirstChild("Anti-fling/LocalPlat")
            if antiFlingObj then antiFlingObj:Destroy() end
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        end)
    end
    
    if isAntiRagdoll then
        if namecallHook2 then hookmetamethod(game, "__namecall", namecallHook2) end
        namecallHook2 = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = { ... }
            if method == "SetStateEnabled" and typeof(self) == "Instance" and self:IsA("Humanoid") then
                local state = args[1]
                if state == Enum.HumanoidStateType.Ragdoll then
                    return namecallHook2(self, state, false)
                end
            end
            return namecallHook2(self, ...)
        end))
    end
end)

-- 飞行按键控制
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and nowe then
        if input.KeyCode == Enum.KeyCode.Space then
            tis = RunService.RenderStepped:Connect(function()
                local humRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if humRootPart then
                    humRootPart.CFrame = humRootPart.CFrame * CFrame.new(0, 1, 0)
                end
            end)
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            dis = RunService.RenderStepped:Connect(function()
                local humRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if humRootPart then
                    humRootPart.CFrame = humRootPart.CFrame * CFrame.new(0, -1, 0)
                end
            end)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.Space and tis then
            tis:Disconnect()
            tis = nil
        elseif input.KeyCode == Enum.KeyCode.LeftShift and dis then
            dis:Disconnect()
            dis = nil
        end
    end
end)