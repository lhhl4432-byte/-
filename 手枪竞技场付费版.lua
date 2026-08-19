local WindUI

do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)

    if ok then
        WindUI = result
    else 
        WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/-UI/refs/heads/main/Wind.lua"))()
    end
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- 添加占位函数，防止 AddSnowEffect 未定义导致脚本中断
local function AddSnowEffect() end

local function createUI()
    local Window = WindUI:CreateWindow({
        Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>H</font><font color='#444444'>U</font><font color='#222222'>B</font><font color='#FFAEC4'></font>",
        Folder = "ftgshub",
        NewElements = true,
        HideSearchBar = false,
        Size = UDim2.fromOffset(600, 450),
        Theme = "Dark",  
        UserEnabled = true,
        SideBarWidth = 135,
        HasOutline = true,
        Background = "https://raw.githubusercontent.com/xiaoxi9008/chesksks/refs/heads/main/image_download_1776648555077.jpg",
        
        OpenButton = {
            Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>H</font><font color='#444444'>U</font><font color='#222222'>B</font><font color='#FFAEC4'></font>",
            CornerRadius = UDim.new(1,0),
            StrokeThickness = 1.5,
            Enabled = true,
            Draggable = true,
            OnlyMobile = false,
            Color = ColorSequence.new(
                Color3.fromHex("FFFFFF"), 
                Color3.fromHex("FFFFFF")
            )
        },
        Topbar = {
            Height = 44,
            ButtonsType = "Mac",
        }
    })
    
    -- 原 AddSnowEffect 调用，现在安全（因为已定义占位函数）
    AddSnowEffect(Window.UIElements.Main.Background, 30, 14, 0.5)

    Window:Tag({
        Title = "v1.0版",
        Radius = 4,
        Color = Color3.fromHex("#ffffff"),
    })

    Window:Tag({
        Title = "手枪竞技场",
        Radius = 4,
        Color = Color3.fromHex("#ffffff"),
    })
    
   local RunService = game:GetService("RunService")

local fpsTag = Window:Tag({
    Title = "FPS: 0",
    Radius = 4,
    Color = Color3.fromHex("#ffffff"),
})

local fps = 0
local frames = 0
local lastTime = tick()

local flash = false

RunService.RenderStepped:Connect(function()
    frames += 1

    if tick() - lastTime >= 1 then

        fps = frames

        frames = 0
        lastTime = tick()

        -- 使用 pcall 保护，防止 SetTitle 不存在报错
        pcall(function() fpsTag:SetTitle("FPS: "..fps) end)

        -- FPS 颜色
        if fps <= 19 then
            pcall(function() fpsTag:SetColor(Color3.fromRGB(255, 70, 70)) end)
        elseif fps >= 20 and fps <= 60 then
            pcall(function() fpsTag:SetColor(Color3.fromRGB(255, 220, 0)) end)
        elseif fps >= 61 and fps <= 90 then
            pcall(function() fpsTag:SetColor(Color3.fromRGB(255, 255, 255)) end)
        elseif fps >= 91 and fps <= 120 then
            pcall(function() fpsTag:SetColor(Color3.fromRGB(35, 35, 35)) end)
        elseif fps >= 121 and fps <= 165 then
            flash = not flash
            if flash then
                pcall(function() fpsTag:SetColor(Color3.fromRGB(255, 240, 120)) end)
            else
                pcall(function() fpsTag:SetColor(Color3.fromRGB(255, 200, 0)) end)
            end
        elseif fps >= 166 and fps <= 240 then
            flash = not flash
            if flash then
                pcall(function() fpsTag:SetColor(Color3.fromRGB(20, 20, 20)) end)
            else
                pcall(function() fpsTag:SetColor(Color3.fromRGB(120, 90, 20)) end)
            end
        end
    end
end)

local Stats = game:GetService("Stats")

local pingTag = Window:Tag({
    Title = "0 ms",
    Radius = 4,
    Color = Color3.fromHex("#ffffff"),
})

local flash = false

task.spawn(function()
    while true do
        task.wait(1)
        local ping = math.floor(
            Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        )
        pcall(function() pingTag:SetTitle(ping.." ms") end)

        if ping <= 199 then
            pcall(function() pingTag:SetColor(Color3.fromRGB(0,255,120)) end)
        elseif ping >= 200 and ping <= 1000 then
            pcall(function() pingTag:SetColor(Color3.fromRGB(255,60,60)) end)
        elseif ping > 1000 then
            flash = not flash
            if flash then
                pcall(function() pingTag:SetColor(Color3.fromRGB(255,0,0)) end)
            else
                pcall(function() pingTag:SetColor(Color3.fromRGB(80,0,0)) end)
            end
        end
    end
end)

    local White = Color3.fromHex("#FFFFFF")
    local LightGray = Color3.fromHex("#CCCCCC")
    local Gray = Color3.fromHex("#999999")
    local DarkGray = Color3.fromHex("#666666")
    local AlmostBlack = Color3.fromHex("#333333")

    local AboutTab = Window:Tab({
        Title = "公告",
        Desc = "脚本信息", 
        Icon = "solar:info-square-bold",
        IconColor = Gray,
        IconShape = "Square",
        Border = true,
    })

    AboutTab:Paragraph({
        Title = "欢迎使用 <font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#222222'>I</font> 脚本",
        Desc = "作者：BkFd｜该服务器为手枪竞技场暴力不开无视墙壁被踢的概率会很低，普通愤怒随便开一辈子不会被踢",
        ImageSize = 50,
        Thumbnail = "https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/7fdb4ab15ea4447bc9566c7caf856f82fc31ae85362243f5f0dd837a41c9ea86.png",
        ThumbnailSize = 170
    })

    AboutTab:Divider()

AboutTab:Keybind({
    Flag = "KeybindTest",
    Title = "快捷键",
    Desc = "打开UI的快捷键",
    Value = "G",
    Callback = function(v) 
        Window:SetToggleKey(Enum.KeyCode[v]) 
    end
})

    AboutTab:Button({
        Title = "显示欢迎通知",
        Icon = "bell",
        Color = Gray,
        Callback = function()
            WindUI:Notify({
                Title = "欢迎!",
                Content = "感谢使用破解版",
                Icon = "heart",
                Duration = 3
            })
        end
    })

local GeneralTab = Window:Tab({
        Title = "通用",
        Desc = "脚本信息", 
        Icon = "solar:widget-bold",
        IconColor = Gray,
        IconShape = "Square",
        Border = true,
    })

local GeneralSection = GeneralTab:Section({
    Title = "通用设置",
})

local Speed = 1
local sudu = nil

GeneralTab:Toggle({
    Title = "移速修改",
    Default = false,
    Callback = function(v)
        if v then
            sudu = RunService.Heartbeat:Connect(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then
                    local humanoid = character.Humanoid
                    if humanoid.MoveDirection.Magnitude > 0 then
                        character:TranslateBy(humanoid.MoveDirection * Speed / 10)
                    end
                end
            end)
        else
            if sudu then
                sudu:Disconnect()
                sudu = nil
            end
        end
    end
})    

GeneralTab:Slider({
    Title = "速度设置",
    Value = {
        Min = 1,
        Max = 100,
        Default = 1,
    },
    Callback = function(Value)
        Speed = Value
    end
})

-- 飞行V4 - XIAOXI HUB
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera
local pgui = lp:WaitForChild("PlayerGui")

local ControlModule = require(lp.PlayerScripts:WaitForChild("PlayerModule")):GetControls()

-- 飞行相关变量
local bv_new = nil
local bg_new = nil
local animCache_new = nil
local hrp_new = nil
local hum_new = nil
local isFlying_new = false
local flySpeed_new = 40
local isWallhack_new = false
local flyTurner_new = nil
local originalCollisions_new = {}

-- ============ 功能函数 ============
local function bypassFlyBan()
    local devv = ReplicatedStorage:FindFirstChild("devv")
    if devv then
        local remoteStorage = devv:FindFirstChild("remoteStorage")
        if remoteStorage then
            local makeExplosion = remoteStorage:FindFirstChild("makeExplosion")
            if makeExplosion then
                makeExplosion:Destroy()
            end
        end
    end
end

local function getBodyParts(character)
    local parts = {}
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local success, rigParts = pcall(function()
            return humanoid:GetRigParts()
        end)
        if success and rigParts then
            for _, part in rigParts do
                if part:IsA("BasePart") then
                    table.insert(parts, part)
                end
            end
        end
    end
    if #parts == 0 then
        local bodyNames = {
            "Head", "Torso", "UpperTorso", "LowerTorso", "HumanoidRootPart",
            "Left Arm", "Right Arm", "Left Leg", "Right Leg",
            "LeftUpperArm", "LeftLowerArm", "RightUpperArm", "RightLowerArm",
            "LeftUpperLeg", "LeftLowerLeg", "RightUpperLeg", "RightLowerLeg"
        }
        for _, name in bodyNames do
            local part = character:FindFirstChild(name)
            if part and part:IsA("BasePart") then
                table.insert(parts, part)
            end
        end
    end
    return parts
end

-- 平滑转身
local SmoothTurner = {}
SmoothTurner.__index = SmoothTurner

function SmoothTurner.new(rootPart, camera, options)
    options = options or {}
    local self = setmetatable({}, SmoothTurner)
    self.RootPart = rootPart
    self.Camera = camera or workspace.CurrentCamera
    self.Enabled = false
    self.BodyGyro = nil
    self.P = options.P or 10000
    self.D = options.D or 50
    self.MaxTorque = options.MaxTorque or Vector3.new(1e6, 1e6, 1e6)
    return self
end

function SmoothTurner:Start()
    if self.Enabled then return end
    if not self.RootPart or not self.RootPart.Parent then return end
    local gyro = Instance.new("BodyGyro")
    gyro.MaxTorque = self.MaxTorque
    gyro.P = self.P
    gyro.D = self.D
    gyro.CFrame = self.RootPart.CFrame
    gyro.Parent = self.RootPart
    self.BodyGyro = gyro
    self.Enabled = true
    self:_startHeartbeat()
end

function SmoothTurner:Stop()
    if self.BodyGyro then
        self.BodyGyro:Destroy()
        self.BodyGyro = nil
    end
    self.Enabled = false
    if self.HeartbeatConn then
        self.HeartbeatConn:Disconnect()
        self.HeartbeatConn = nil
    end
end

function SmoothTurner:SetDirection(direction)
    if not self.Enabled or not self.BodyGyro or not self.RootPart then return end
    local newCFrame = CFrame.lookAt(self.RootPart.Position, self.RootPart.Position + direction.Unit)
    self.BodyGyro.CFrame = newCFrame
end

function SmoothTurner:_startHeartbeat()
    if self.HeartbeatConn then self.HeartbeatConn:Disconnect() end
    self.HeartbeatConn = RunService.Heartbeat:Connect(function()
        if not self.Enabled or not self.BodyGyro or not self.RootPart or not self.Camera then return end
        local look = self.Camera.CFrame.LookVector
        self:SetDirection(look)
    end)
end

function SmoothTurner:Destroy()
    self:Stop()
    self.RootPart = nil
    self.Camera = nil
end

local function clearFlyRes_new()
    local char = lp.Character
    if char then
        local bodyParts = getBodyParts(char)
        for part, originalState in pairs(originalCollisions_new) do
            if part and part.Parent then
                for _, bp in bodyParts do
                    if bp == part then
                        part.CanCollide = originalState
                        break
                    end
                end
            end
        end
        originalCollisions_new = {}
    end
    if animCache_new and lp.Character then
        animCache_new.Parent = lp.Character
    end
    if bv_new then bv_new:Destroy() end
    if bg_new then bg_new:Destroy() end
    bv_new = nil
    bg_new = nil
    if flyTurner_new then
        flyTurner_new:Destroy()
        flyTurner_new = nil
    end
    if hum_new and hum_new.Parent then
        hum_new:ChangeState(Enum.HumanoidStateType.Running)
    end
end

local function ensurePhysics_new(hrp, useGyro)
    if hrp:FindFirstChild("LeipzigBV_new") then
        hrp.LeipzigBV_new:Destroy()
    end
    if hrp:FindFirstChild("LeipzigBG_new") then
        hrp.LeipzigBG_new:Destroy()
    end
    bv_new = Instance.new("BodyVelocity", hrp)
    bv_new.Name = "LeipzigBV_new"
    bv_new.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    if useGyro then
        if flyTurner_new then
            flyTurner_new:Destroy()
        end
        flyTurner_new = SmoothTurner.new(hrp, workspace.CurrentCamera)
        flyTurner_new:Start()
    end
end

local function applyWallhackState_new()
    local char = lp.Character
    if not char then return end
    if isWallhack_new then
        local bodyParts = getBodyParts(char)
        originalCollisions_new = {}
        for _, part in bodyParts do
            originalCollisions_new[part] = part.CanCollide
            part.CanCollide = false
        end
    else
        for part, originalState in originalCollisions_new do
            if part and part.Parent then
                part.CanCollide = originalState
            end
        end
        originalCollisions_new = {}
    end
end

local function startFlyNormal_new()
    local char = lp.Character
    if not char then return end
    hrp_new = char:WaitForChild("HumanoidRootPart")
    hum_new = char:WaitForChild("Humanoid")
    local ani = char:FindFirstChild("Animate")
    if ani then
        animCache_new = ani
        ani.Parent = nil
    end
    ensurePhysics_new(hrp_new, true)
    task.spawn(function()
        while isFlying_new and char.Parent do
            local mv = ControlModule:GetMoveVector()
            local cf = camera.CFrame
            local dir = (cf.LookVector * -mv.Z) + (cf.RightVector * mv.X)
            if mv.Magnitude > 0 then
                bv_new.Velocity = dir.Unit * flySpeed_new
            else
                bv_new.Velocity = Vector3.new(0, 0.01, 0)
            end
            hum_new:ChangeState(Enum.HumanoidStateType.Climbing)
            RunService.RenderStepped:Wait()
        end
        clearFlyRes_new()
    end)
end

local function startFlyWallhack_new()
    local char = lp.Character
    if not char then return end
    hrp_new = char:WaitForChild("HumanoidRootPart")
    hum_new = char:WaitForChild("Humanoid")
    local ani = char:FindFirstChild("Animate")
    if ani then
        animCache_new = ani
        ani.Parent = nil
    end
    applyWallhackState_new()
    ensurePhysics_new(hrp_new, true)
    task.spawn(function()
        local lastPos = hrp_new.Position
        local lastTime = tick()
        while isFlying_new and char.Parent do
            local dt = tick() - lastTime
            lastTime = tick()
            local mv = ControlModule:GetMoveVector()
            local cf = camera.CFrame
            local dir = (cf.LookVector * -mv.Z) + (cf.RightVector * mv.X)
            local targetVelocity
            if mv.Magnitude > 0 then
                targetVelocity = dir.Unit * flySpeed_new
                bv_new.Velocity = targetVelocity
            else
                bv_new.Velocity = Vector3.new(0, 0.01, 0)
                targetVelocity = Vector3.new(0, 0.01, 0)
            end
            hum_new:ChangeState(Enum.HumanoidStateType.Climbing)
            RunService.RenderStepped:Wait()
            local expectedPos = lastPos + targetVelocity * dt
            local actualPos = hrp_new.Position
            local deviation = actualPos - expectedPos
            if deviation.Magnitude > 0.00001 then
                hrp_new.CFrame = CFrame.new(expectedPos) * hrp_new.CFrame.Rotation
                bv_new.Velocity = targetVelocity
                lastPos = expectedPos
            else
                lastPos = actualPos
            end
        end
        clearFlyRes_new()
    end)
end

local function startFly_new()
    if isFlying_new then return end
    isFlying_new = true
    bypassFlyBan()
    if isWallhack_new then
        startFlyWallhack_new()
    else
        startFlyNormal_new()
    end
end

local function stopFly_new()
    if not isFlying_new then return end
    isFlying_new = false
    clearFlyRes_new()
end

-- 角色重生绑定
local function bindCharacter_new()
    local char = lp.Character or lp.CharacterAdded:Wait()
    hrp_new = char:WaitForChild("HumanoidRootPart")
    hum_new = char:WaitForChild("Humanoid")
    clearFlyRes_new()
    char.AncestryChanged:Connect(function(_, parent)
        if not parent then
            clearFlyRes_new()
            bindCharacter_new()
        end
    end)
end
bindCharacter_new()

-- ============ 创建UI和Toggle ============
local UI_BG = Color3.fromRGB(20, 20, 20)
local BTN_OFF = Color3.fromRGB(50, 50, 50)
local BTN_ON = Color3.fromRGB(90, 90, 90)
local DESTROY_BTN = Color3.fromRGB(70, 70, 70)
local TEXT_COLOR = Color3.fromRGB(240, 240, 240)
local SPEED_BG = Color3.fromRGB(40, 40, 40)

local function createUI()
    -- 如果已存在就显示
    if pgui:FindFirstChild("NewFlightUI") then
        pgui.NewFlightUI.Enabled = true
        return
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NewFlightUI"
    ScreenGui.Parent = pgui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 150, 0, 195)
    MainFrame.Position = UDim2.new(0.5, -75, 0.3, 0)
    MainFrame.BackgroundColor3 = UI_BG
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.Draggable = true
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local bgImage = Instance.new("ImageLabel", MainFrame)
    bgImage.Name = "CustomBackground"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = "rbxassetid://87099566895194"
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ImageTransparency = 0.3
    bgImage.ZIndex = -1
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", MainFrame)
    stroke.Name = "GradientStroke"
    stroke.Thickness = 2
    stroke.Transparency = 0
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.LineJoinMode = Enum.LineJoinMode.Round

    local strokeGradient = Instance.new("UIGradient", stroke)
    strokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    })

    task.spawn(function()
        while MainFrame and MainFrame.Parent do
            strokeGradient.Rotation = (strokeGradient.Rotation + 2) % 360
            RunService.RenderStepped:Wait()
        end
    end)

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 20)
    Title.Position = UDim2.new(0, 0, 0, 2)
    Title.BackgroundTransparency = 1
    Title.Text = "BkFd HUB飞行V4"
    Title.TextColor3 = TEXT_COLOR
    Title.TextSize = 12
    Title.Font = Enum.Font.GothamBold
    Title.ZIndex = 2

    local titleStroke = Instance.new("UIStroke", Title)
    titleStroke.Color = Color3.fromRGB(0, 0, 0)
    titleStroke.Thickness = 1.5
    titleStroke.Transparency = 0.5

    local SpeedInput = Instance.new("TextBox", MainFrame)
    SpeedInput.Size = UDim2.new(0, 120, 0, 24)
    SpeedInput.Position = UDim2.new(0.5, -60, 0, 30)
    SpeedInput.BackgroundColor3 = SPEED_BG
    SpeedInput.BackgroundTransparency = 0.4
    SpeedInput.Text = "40"
    SpeedInput.TextColor3 = TEXT_COLOR
    SpeedInput.TextSize = 11
    SpeedInput.PlaceholderText = "速度"
    SpeedInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    SpeedInput.ZIndex = 2
    Instance.new("UICorner", SpeedInput).CornerRadius = UDim.new(0, 7)

    local speedStroke = Instance.new("UIStroke", SpeedInput)
    speedStroke.Color = Color3.fromRGB(80, 80, 80)
    speedStroke.Thickness = 1
    speedStroke.Transparency = 0.5

    local BypassBtn = Instance.new("TextButton", MainFrame)
    BypassBtn.Size = UDim2.new(0, 120, 0, 26)
    BypassBtn.Position = UDim2.new(0.5, -60, 0, 64)
    BypassBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    BypassBtn.BackgroundTransparency = 0.35
    BypassBtn.Text = "V5飞行"
    BypassBtn.TextColor3 = TEXT_COLOR
    BypassBtn.TextSize = 11
    BypassBtn.Font = Enum.Font.GothamSemibold
    BypassBtn.AutoButtonColor = true
    BypassBtn.ZIndex = 2
    Instance.new("UICorner", BypassBtn).CornerRadius = UDim.new(0, 8)

    local bypassStroke = Instance.new("UIStroke", BypassBtn)
    bypassStroke.Color = Color3.fromRGB(100, 100, 100)
    bypassStroke.Thickness = 1

    BypassBtn.MouseButton1Click:Connect(function()
        bypassFlyBan()
        if isFlying_new then
            stopFly_new()
            task.wait(0.05)
            startFly_new()
        end
    end)

    local WallhackBtn = Instance.new("TextButton", MainFrame)
    WallhackBtn.Size = UDim2.new(0, 120, 0, 26)
    WallhackBtn.Position = UDim2.new(0.5, -60, 0, 99)
    WallhackBtn.BackgroundColor3 = BTN_OFF
    WallhackBtn.BackgroundTransparency = 0.35
    WallhackBtn.Text = "穿墙模式: 关闭"
    WallhackBtn.TextColor3 = TEXT_COLOR
    WallhackBtn.TextSize = 11
    WallhackBtn.Font = Enum.Font.GothamSemibold
    WallhackBtn.AutoButtonColor = true
    WallhackBtn.ZIndex = 2
    Instance.new("UICorner", WallhackBtn).CornerRadius = UDim.new(0, 8)

    local whStroke = Instance.new("UIStroke", WallhackBtn)
    whStroke.Color = Color3.fromRGB(100, 100, 100)
    whStroke.Thickness = 1

    local FlyBtn = Instance.new("TextButton", MainFrame)
    FlyBtn.Size = UDim2.new(0, 120, 0, 26)
    FlyBtn.Position = UDim2.new(0.5, -60, 0, 133)
    FlyBtn.BackgroundColor3 = BTN_OFF
    FlyBtn.BackgroundTransparency = 0.35
    FlyBtn.Text = "飞行"
    FlyBtn.TextColor3 = TEXT_COLOR
    FlyBtn.TextSize = 11
    FlyBtn.Font = Enum.Font.GothamSemibold
    FlyBtn.AutoButtonColor = true
    FlyBtn.ZIndex = 2
    Instance.new("UICorner", FlyBtn).CornerRadius = UDim.new(0, 8)

    local flyStroke = Instance.new("UIStroke", FlyBtn)
    flyStroke.Color = Color3.fromRGB(100, 100, 100)
    flyStroke.Thickness = 1

    local DestroyUI = Instance.new("TextButton", MainFrame)
    DestroyUI.Size = UDim2.new(0, 120, 0, 26)
    DestroyUI.Position = UDim2.new(0.5, -60, 0, 167)
    DestroyUI.BackgroundColor3 = DESTROY_BTN
    DestroyUI.BackgroundTransparency = 0.35
    DestroyUI.Text = "销毁UI"
    DestroyUI.TextColor3 = TEXT_COLOR
    DestroyUI.TextSize = 11
    DestroyUI.Font = Enum.Font.GothamSemibold
    DestroyUI.AutoButtonColor = true
    DestroyUI.ZIndex = 2
    Instance.new("UICorner", DestroyUI).CornerRadius = UDim.new(0, 8)

    local destroyStroke = Instance.new("UIStroke", DestroyUI)
    destroyStroke.Color = Color3.fromRGB(100, 100, 100)
    destroyStroke.Thickness = 2

    -- 拖动功能
    local dragging = false
    local dragStart = nil
    local startPos = nil

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- 速度输入
    SpeedInput.FocusLost:Connect(function()
        local val = tonumber(SpeedInput.Text)
        if val then
            flySpeed_new = math.clamp(val, 10, 520131491781367)
        else
            flySpeed_new = 150
        end
        SpeedInput.Text = tostring(flySpeed_new)
    end)

    -- 穿墙按钮
    WallhackBtn.MouseButton1Click:Connect(function()
        isWallhack_new = not isWallhack_new
        WallhackBtn.Text = "穿墙模式: " .. (isWallhack_new and "开启" or "关闭")
        WallhackBtn.BackgroundColor3 = isWallhack_new and BTN_ON or BTN_OFF
        if isFlying_new then
            stopFly_new()
            task.wait(0.05)
            startFly_new()
        else
            applyWallhackState_new()
        end
    end)

    -- 飞行按钮
    FlyBtn.MouseButton1Click:Connect(function()
        if isFlying_new then
            stopFly_new()
            FlyBtn.Text = "飞行"
            FlyBtn.BackgroundColor3 = BTN_OFF
        else
            startFly_new()
            FlyBtn.Text = "飞行开"
            FlyBtn.BackgroundColor3 = BTN_ON
        end
    end)

    -- 销毁UI按钮
    DestroyUI.MouseButton1Click:Connect(function()
        stopFly_new()
        applyWallhackState_new()
        ScreenGui:Destroy()
    end)

    -- 动画效果
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame:TweenSize(
        UDim2.new(0, 150, 0, 195),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.4,
        true
    )
end

-- ============ 注册Toggle ============
GeneralTab:Toggle({
    Title = "飞行",
    Default = false,
    Callback = function(v)
        if v == true then
            createUI()
        else
            -- 关闭UI并停止飞行
            stopFly_new()
            if pgui:FindFirstChild("NewFlightUI") then
                pgui.NewFlightUI.Enabled = false
            end
        end
    end
})

GeneralTab:Toggle({
    Title = "无限跳",
    Default = false,
    Callback = function(v)
        local JumpEnabled = v  -- 使用局部变量，避免未定义全局
        if v == true then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if JumpEnabled then
                    game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
                end
            end)
        end
    end
})

GeneralTab:Button({
    Title = "网易云音乐",
    Callback = function()
        print("脚本执行了")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/网易云.lua"))() 
    end
})

local Ragebot1Tab = Window:Tab({
        Title = "Ragebot",
        Desc = "脚本信息", 
        Icon = "solar:shield-bold",
        IconColor = Gray,
        IconShape = "Square",
        Border = true,
    })


local RagebotSection = Ragebot1Tab:Section({
    Title = "愤怒机器人设置",
    Icon = "solar:shield-bold",
})

local ragebotEnabled = false
local lastShotTime = 0
local connection = nil
local fireRateValue = 1
local wallCheckEnabled = true
local headshotEnabled = true

-- 删除这行，顶部已经定义过了
-- local LocalPlayer = Players.LocalPlayer
-- 删除这行，用顶部的 Camera
-- local Camera = Workspace.CurrentCamera

-- 获取远程事件
local function getDamageRemote()
    local systemResources = ReplicatedStorage:FindFirstChild("SystemResources")
    if not systemResources then return nil end
    local bufferCache = systemResources:FindFirstChild("BufferCache")
    if not bufferCache then return nil end
    return bufferCache:FindFirstChild("RequestActionSync")
end

local function getFakeBulletRemote()
    local events = ReplicatedStorage:FindFirstChild("Events")
    if not events then return nil end
    local remoteEvents = events:FindFirstChild("RemoteEvents")
    if not remoteEvents then return nil end
    return remoteEvents:FindFirstChild("ReplicateFakeBullet")
end

local function getMuzzleFlashRemote()
    local events = ReplicatedStorage:FindFirstChild("Events")
    if not events then return nil end
    local remoteEvents = events:FindFirstChild("RemoteEvents")
    if not remoteEvents then return nil end
    return remoteEvents:FindFirstChild("CharacterMuzzleFlash")
end

-- 墙壁检测函数
local function checkWallBetween(origin, targetPos, targetCharacter)
    if not wallCheckEnabled then
        return false
    end
    
    local direction = (targetPos - origin).Unit
    local distance = (targetPos - origin).Magnitude
    
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, targetCharacter}
    rayParams.IgnoreWater = true
    
    local ray = Workspace:Raycast(origin, direction * distance, rayParams)
    
    if ray then
        local hitInstance = ray.Instance
        if hitInstance:IsDescendantOf(targetCharacter) then
            return false
        end
        if hitInstance.Transparency >= 0.9 then
            return false
        end
        return true
    end
    
    return false
end

-- 检查玩家是否死亡
local function isDead(player)
    if not player or not player.Character then return true end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    return not humanoid or humanoid.Health <= 0
end

-- 射击音效 - 直接复制暴力版的
local function playShootSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://6534948092"
    sound.Volume = 0.5
    sound.Parent = Camera
    sound.PlayOnRemove = true
    sound:Destroy()
end

-- 创建弹道特效 - 直接复制暴力版的
local function createBeam(startPos, endPos)
    local part1 = Instance.new("Part")
    part1.Anchored = true
    part1.CanCollide = false
    part1.Transparency = 1
    part1.Size = Vector3.new(0.1, 0.1, 0.1)
    part1.Position = startPos
    part1.Parent = Workspace

    local part2 = Instance.new("Part")
    part2.Anchored = true
    part2.CanCollide = false
    part2.Transparency = 1
    part2.Size = Vector3.new(0.1, 0.1, 0.1)
    part2.Position = endPos
    part2.Parent = Workspace

    local attachment1 = Instance.new("Attachment")
    attachment1.Parent = part1
    local attachment2 = Instance.new("Attachment")
    attachment2.Parent = part2

    local beam1 = Instance.new("Beam")
    beam1.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
    beam1.Transparency = NumberSequence.new(0)
    beam1.Width0 = 0.25
    beam1.Width1 = 0.25
    beam1.Texture = "rbxassetid://7136858729"
    beam1.TextureSpeed = 0.8
    beam1.TextureMode = Enum.TextureMode.Wrap
    beam1.Brightness = 1
    beam1.LightEmission = 0
    beam1.FaceCamera = true
    beam1.Attachment0 = attachment1
    beam1.Attachment1 = attachment2
    beam1.Parent = part1

    local beam2 = Instance.new("Beam")
    beam2.Color = ColorSequence.new(Color3.fromRGB(180, 200, 255))
    beam2.Transparency = NumberSequence.new(0.4)
    beam2.Width0 = 0.12
    beam2.Width1 = 0.12
    beam2.Texture = "rbxassetid://7136858729"
    beam2.TextureSpeed = 1.2
    beam2.TextureMode = Enum.TextureMode.Wrap
    beam2.Brightness = 1.2
    beam2.LightEmission = 0.6
    beam2.FaceCamera = true
    beam2.Attachment0 = attachment1
    beam2.Attachment1 = attachment2
    beam2.Parent = part1

    local shaking = true
    task.spawn(function()
        while shaking and part1 and part1.Parent do
            attachment1.Position = Vector3.new(math.random(-3, 3) / 100, math.random(-3, 3) / 100, math.random(-3, 3) / 100)
            attachment2.Position = Vector3.new(math.random(-3, 3) / 100, math.random(-3, 3) / 100, math.random(-3, 3) / 100)
            task.wait(0.02)
        end
    end)

    task.delay(math.random(10, 40) / 10, function()
        shaking = false
        for i = 0, 1, 0.05 do
            if not part1 or not part1.Parent then break end
            beam1.Transparency = NumberSequence.new(i)
            beam2.Transparency = NumberSequence.new(0.4 + i * 0.6)
            task.wait(0.03)
        end
        pcall(function() part1:Destroy() end)
        pcall(function() part2:Destroy() end)
    end)
end

-- 获取所有可用目标
local function getAvailableTargets()
    local targets = {}
    local character = LocalPlayer.Character
    if not character then return targets end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return targets end
    
    local myPosition = humanoidRootPart.Position
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not isDead(player) and player.Character then
            local targetChar = player.Character
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            
            if targetRoot then
                local targetPart = targetRoot
                local targetPos = targetRoot.Position
                
                if headshotEnabled then
                    local head = targetChar:FindFirstChild("Head")
                    if head then
                        targetPart = head
                        targetPos = head.Position
                    end
                end
                
                local hasWall = checkWallBetween(myPosition, targetPos, targetChar)
                
                if not hasWall then
                    table.insert(targets, {
                        player = player,
                        character = targetChar,
                        part = targetPart,
                        position = targetPos,
                        distance = (targetPos - myPosition).Magnitude
                    })
                end
            end
        end
    end
    
    table.sort(targets, function(a, b) return a.distance < b.distance end)
    return targets
end

-- 执行射击
local function shootTarget(target)
    local currentTime = tick()
    if currentTime - lastShotTime < fireRateValue then
        return false
    end
    
    local character = LocalPlayer.Character
    if not character then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    local origin = humanoidRootPart.Position
    local targetPart = target.part
    local targetPos = target.position
    local targetChar = target.character
    
    if not targetPart or not targetChar then return false end
    
    local direction = (targetPos - origin).Unit
    local cframe = CFrame.lookAt(origin, targetPos)
    
    pcall(function()
        local fakeBullet = getFakeBulletRemote()
        if fakeBullet then
            fakeBullet:FireServer(cframe, direction)
        end
    end)
    
    pcall(function()
        local muzzleFlash = getMuzzleFlashRemote()
        if muzzleFlash then
            muzzleFlash:FireServer()
        end
    end)
    
    pcall(function()
        local humanoid = targetChar:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health > 0 then
            local args = {
                {
                    direction = direction,
                    hitPosition = targetPos,
                    origin = origin,
                    hitInstance = targetPart,
                    hitHumanoid = humanoid,
                    IsHeadshot = (targetPart.Name == "Head")
                }
            }
            
            local damageRemote = getDamageRemote()
            if damageRemote then
                damageRemote:FireServer(unpack(args))
            end
        end
    end)
    
    createBeam(origin, targetPos)
    playShootSound()
    
    lastShotTime = currentTime
    return true
end

RagebotSection:Toggle({
    Title = "强制爆头",
    Desc = "只射击头部",
    Value = true,
    Callback = function(state)
        headshotEnabled = state
        print("强制爆头:", state)
    end
})

RagebotSection:Toggle({
    Title = "无视墙壁",
    Desc = "安全开了不会被踢因为射的慢",
    Value = false,
    Callback = function(state)
        wallCheckEnabled = not state
        if state then
            WindUI:Notify({
                Title = "无视墙壁",
                Content = "已开启",
                Duration = 2,
            })
        else
            WindUI:Notify({
                Title = "无视墙壁",
                Content = "已关闭",
                Duration = 2,
            })
        end
    end
})

RagebotSection:Toggle({
    Title = "愤怒机器人",
    Desc = "Ragebot安全",
    Value = false,
    Callback = function(state)
        ragebotEnabled = state
        
        if connection then
            connection:Disconnect()
            connection = nil
        end
        
        if state then
            connection = RunService.Heartbeat:Connect(function()
                if not ragebotEnabled then return end
                
                pcall(function()
                    local targets = getAvailableTargets()
                    if #targets > 0 then
                        local target = targets[1]
                        shootTarget(target)
                    end
                end)
            end)
            
            WindUI:Notify({
                Title = "Ragebot",
                Content = "已开启",
                Duration = 2,
            })
        else
            WindUI:Notify({
                Title = "Ragebot",
                Content = "已关闭",
                Duration = 2,
            })
        end
    end
})

local RagebotSection = Ragebot1Tab:Section({
    Title = "暴力愤怒机器人设置",
    Icon = "solar:danger-bold",
})

local ragebotEnabled = false
local lastShotTime = 0
local connection = nil
local fireRateValue = 0.5
local wallCheckEnabled = true
local headshotEnabled = true


-- 获取远程事件
local function getDamageRemote()
    local systemResources = ReplicatedStorage:FindFirstChild("SystemResources")
    if not systemResources then return nil end
    local bufferCache = systemResources:FindFirstChild("BufferCache")
    if not bufferCache then return nil end
    return bufferCache:FindFirstChild("RequestActionSync")
end

local function getFakeBulletRemote()
    local events = ReplicatedStorage:FindFirstChild("Events")
    if not events then return nil end
    local remoteEvents = events:FindFirstChild("RemoteEvents")
    if not remoteEvents then return nil end
    return remoteEvents:FindFirstChild("ReplicateFakeBullet")
end

local function getMuzzleFlashRemote()
    local events = ReplicatedStorage:FindFirstChild("Events")
    if not events then return nil end
    local remoteEvents = events:FindFirstChild("RemoteEvents")
    if not remoteEvents then return nil end
    return remoteEvents:FindFirstChild("CharacterMuzzleFlash")
end

-- 墙壁检测函数
local function checkWallBetween(origin, targetPos, targetCharacter)
    if not wallCheckEnabled then
        return false
    end
    
    local direction = (targetPos - origin).Unit
    local distance = (targetPos - origin).Magnitude
    
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, targetCharacter}
    rayParams.IgnoreWater = true
    
    local ray = Workspace:Raycast(origin, direction * distance, rayParams)
    
    if ray then
        local hitInstance = ray.Instance
        if hitInstance:IsDescendantOf(targetCharacter) then
            return false
        end
        if hitInstance.Transparency >= 0.9 then
            return false
        end
        return true
    end
    
    return false
end

-- 检查玩家是否死亡
local function isDead(player)
    if not player or not player.Character then return true end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    return not humanoid or humanoid.Health <= 0
end

-- 射击音效 - 直接复制暴力版的
local function playShootSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://6534948092"
    sound.Volume = 0.5
    sound.Parent = Camera
    sound.PlayOnRemove = true
    sound:Destroy()
end

-- 创建弹道特效 - 直接复制暴力版的
local function createBeam(startPos, endPos)
    local part1 = Instance.new("Part")
    part1.Anchored = true
    part1.CanCollide = false
    part1.Transparency = 1
    part1.Size = Vector3.new(0.1, 0.1, 0.1)
    part1.Position = startPos
    part1.Parent = Workspace

    local part2 = Instance.new("Part")
    part2.Anchored = true
    part2.CanCollide = false
    part2.Transparency = 1
    part2.Size = Vector3.new(0.1, 0.1, 0.1)
    part2.Position = endPos
    part2.Parent = Workspace

    local attachment1 = Instance.new("Attachment")
    attachment1.Parent = part1
    local attachment2 = Instance.new("Attachment")
    attachment2.Parent = part2

    local beam1 = Instance.new("Beam")
    beam1.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
    beam1.Transparency = NumberSequence.new(0)
    beam1.Width0 = 0.25
    beam1.Width1 = 0.25
    beam1.Texture = "rbxassetid://7136858729"
    beam1.TextureSpeed = 0.8
    beam1.TextureMode = Enum.TextureMode.Wrap
    beam1.Brightness = 1
    beam1.LightEmission = 0
    beam1.FaceCamera = true
    beam1.Attachment0 = attachment1
    beam1.Attachment1 = attachment2
    beam1.Parent = part1

    local beam2 = Instance.new("Beam")
    beam2.Color = ColorSequence.new(Color3.fromRGB(180, 200, 255))
    beam2.Transparency = NumberSequence.new(0.4)
    beam2.Width0 = 0.12
    beam2.Width1 = 0.12
    beam2.Texture = "rbxassetid://7136858729"
    beam2.TextureSpeed = 1.2
    beam2.TextureMode = Enum.TextureMode.Wrap
    beam2.Brightness = 1.2
    beam2.LightEmission = 0.6
    beam2.FaceCamera = true
    beam2.Attachment0 = attachment1
    beam2.Attachment1 = attachment2
    beam2.Parent = part1

    local shaking = true
    task.spawn(function()
        while shaking and part1 and part1.Parent do
            attachment1.Position = Vector3.new(math.random(-3, 3) / 100, math.random(-3, 3) / 100, math.random(-3, 3) / 100)
            attachment2.Position = Vector3.new(math.random(-3, 3) / 100, math.random(-3, 3) / 100, math.random(-3, 3) / 100)
            task.wait(0.02)
        end
    end)

    task.delay(math.random(10, 40) / 10, function()
        shaking = false
        for i = 0, 1, 0.05 do
            if not part1 or not part1.Parent then break end
            beam1.Transparency = NumberSequence.new(i)
            beam2.Transparency = NumberSequence.new(0.4 + i * 0.6)
            task.wait(0.03)
        end
        pcall(function() part1:Destroy() end)
        pcall(function() part2:Destroy() end)
    end)
end

-- 获取所有可用目标
local function getAvailableTargets()
    local targets = {}
    local character = LocalPlayer.Character
    if not character then return targets end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return targets end
    
    local myPosition = humanoidRootPart.Position
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not isDead(player) and player.Character then
            local targetChar = player.Character
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            
            if targetRoot then
                local targetPart = targetRoot
                local targetPos = targetRoot.Position
                
                if headshotEnabled then
                    local head = targetChar:FindFirstChild("Head")
                    if head then
                        targetPart = head
                        targetPos = head.Position
                    end
                end
                
                local hasWall = checkWallBetween(myPosition, targetPos, targetChar)
                
                if not hasWall then
                    table.insert(targets, {
                        player = player,
                        character = targetChar,
                        part = targetPart,
                        position = targetPos,
                        distance = (targetPos - myPosition).Magnitude
                    })
                end
            end
        end
    end
    
    table.sort(targets, function(a, b) return a.distance < b.distance end)
    return targets
end

-- 执行射击
local function shootTarget(target)
    local currentTime = tick()
    if currentTime - lastShotTime < fireRateValue then
        return false
    end
    
    local character = LocalPlayer.Character
    if not character then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    local origin = humanoidRootPart.Position
    local targetPart = target.part
    local targetPos = target.position
    local targetChar = target.character
    
    if not targetPart or not targetChar then return false end
    
    local direction = (targetPos - origin).Unit
    local cframe = CFrame.lookAt(origin, targetPos)
    
    pcall(function()
        local fakeBullet = getFakeBulletRemote()
        if fakeBullet then
            fakeBullet:FireServer(cframe, direction)
        end
    end)
    
    pcall(function()
        local muzzleFlash = getMuzzleFlashRemote()
        if muzzleFlash then
            muzzleFlash:FireServer()
        end
    end)
    
    pcall(function()
        local humanoid = targetChar:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health > 0 then
            local args = {
                {
                    direction = direction,
                    hitPosition = targetPos,
                    origin = origin,
                    hitInstance = targetPart,
                    hitHumanoid = humanoid,
                    IsHeadshot = (targetPart.Name == "Head")
                }
            }
            
            local damageRemote = getDamageRemote()
            if damageRemote then
                damageRemote:FireServer(unpack(args))
            end
        end
    end)
    
    createBeam(origin, targetPos)
    playShootSound()
    
    lastShotTime = currentTime
    return true
end

RagebotSection:Toggle({
    Title = "强制爆头",
    Desc = "只射击头部",
    Value = true,
    Callback = function(state)
        headshotEnabled = state
        print("强制爆头:", state)
    end
})

RagebotSection:Toggle({
    Title = "无视墙壁",
    Desc = "暴力开了被踢的概率会变高",
    Value = false,
    Callback = function(state)
        wallCheckEnabled = not state
        if state then
            WindUI:Notify({
                Title = "无视墙壁",
                Content = "已开启",
                Duration = 2,
            })
        else
            WindUI:Notify({
                Title = "无视墙壁",
                Content = "已关闭",
                Duration = 2,
            })
        end
    end
})

RagebotSection:Toggle({
    Title = "愤怒机器人",
    Desc = "Ragebot暴力",
    Value = false,
    Callback = function(state)
        ragebotEnabled = state
        
        if connection then
            connection:Disconnect()
            connection = nil
        end
        
        if state then
            connection = RunService.Heartbeat:Connect(function()
                if not ragebotEnabled then return end
                
                pcall(function()
                    local targets = getAvailableTargets()
                    if #targets > 0 then
                        local target = targets[1]
                        shootTarget(target)
                    end
                end)
            end)
            
            WindUI:Notify({
                Title = "Ragebot",
                Content = "已开启",
                Duration = 2,
            })
        else
            WindUI:Notify({
                Title = "Ragebot",
                Content = "已关闭",
                Duration = 2,
            })
        end
    end
})

RagebotSection:Space()

local ESPTab = Window:Tab({
        Title = "ESP",
        Desc = "脚本信息", 
        Icon = "solar:eye-closed-bold",
        IconColor = Gray,
        IconShape = "Square",
        Border = true,
    })


local ESPSection = ESPTab:Section({
    Title = "ESP 设置",
})

local vu88 = {}
local vu85 = false


local AttributesTeamCheck = {
    Enabled = false,           
    AttributeName = "Team"     
}

local function getTeamAttribute(player)
    local attr = player:GetAttribute(AttributesTeamCheck.AttributeName)
    if attr ~= nil then return attr end
    if player.Character then
        attr = player.Character:GetAttribute(AttributesTeamCheck.AttributeName)
        if attr ~= nil then return attr end
    end
    return nil
end

local function isTeammateByAttribute(player)
    if not AttributesTeamCheck.Enabled then return false end
    local myTeam = getTeamAttribute(game.Players.LocalPlayer)
    local theirTeam = getTeamAttribute(player)
    if myTeam == nil or theirTeam == nil then
        return false
    end
    return myTeam == theirTeam
end

local vu97 = function(player)
    return player.Team == game.Players.LocalPlayer.Team
end

local ESPSettings = {
    Enabled = true,
    TeamCheck = true,
    MaxDistance = 200,
    FontSize = 11,
    FadeOut = {
        OnDistance = true,
        OnDeath = false,
        OnLeave = false,
    },
    Options = {
        Teamcheck = false, TeamcheckRGB = Color3.fromRGB(0, 255, 0),
        Friendcheck = true, FriendcheckRGB = Color3.fromRGB(0, 255, 0),
        Highlight = false, HighlightRGB = Color3.fromRGB(255, 0, 0),
    },
    Drawing = {
        Names = {
            Enabled = true,
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Flags = {
            Enabled = true,
        },
        Distances = {
            Enabled = true,
            Position = "Text",
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Weapons = {
            Enabled = true, WeaponTextRGB = Color3.fromRGB(119, 120, 255),
            Outlined = false,
            Gradient = false,
            GradientRGB1 = Color3.fromRGB(255, 255, 255), GradientRGB2 = Color3.fromRGB(119, 120, 255),
        },
        Healthbar = {
            Enabled = true,
            HealthText = true, 
            Lerp = false, 
            HealthTextRGB = Color3.fromRGB(0, 255, 0),
            Width = 2.5,
            Gradient = false,
            GradientRGB1 = Color3.fromRGB(0, 255, 0),
            GradientRGB2 = Color3.fromRGB(0, 255, 0),
            GradientRGB3 = Color3.fromRGB(0, 255, 0),
        },
        Boxes = {
            Animate = false,
            RotationSpeed = 300,
            Gradient = false,
            GradientRGB1 = Color3.fromRGB(119, 120, 255),
            GradientRGB2 = Color3.fromRGB(0, 0, 0),
            GradientFill = false,
            GradientFillRGB1 = Color3.fromRGB(119, 120, 255),
            GradientFillRGB2 = Color3.fromRGB(0, 0, 0),
            Filled = {
                Enabled = true,
                Transparency = 0.75,
                RGB = Color3.fromRGB(0, 0, 0),
            },
            Full = {
                Enabled = true,
                RGB = Color3.fromRGB(255, 255, 255),
            },
            Corner = {
                Enabled = true,
                RGB = Color3.fromRGB(255, 255, 255),
            },
        },
    },
}

local Weapon_Icons = {
    ["Wooden Bow"] = "http://www.roblox.com/asset/?id=17677465400",
    ["Crossbow"] = "http://www.roblox.com/asset/?id=17677473017",
    ["Salvaged SMG"] = "http://www.roblox.com/asset/?id=17677463033",
    ["Salvaged AK47"] = "http://www.roblox.com/asset/?id=17677455113",
    ["Salvaged AK74u"] = "http://www.roblox.com/asset/?id=17677442346",
    ["Salvaged M14"] = "http://www.roblox.com/asset/?id=17677444642",
    ["Salvaged Python"] = "http://www.roblox.com/asset/?id=17677451737",
    ["Military PKM"] = "http://www.roblox.com/asset/?id=17677449448",
    ["Military M4A1"] = "http://www.roblox.com/asset/?id=17677479536",
    ["Bruno's M4A1"] = "http://www.roblox.com/asset/?id=17677471185",
    ["Military Barrett"] = "http://www.roblox.com/asset/?id=17677482998",
    ["Salvaged Skorpion"] = "http://www.roblox.com/asset/?id=17677459658",
    ["Salvaged Pump Action"] = "http://www.roblox.com/asset/?id=17677457186",
    ["Military AA12"] = "http://www.roblox.com/asset/?id=17677475227",
    ["Salvaged Break Action"] = "http://www.roblox.com/asset/?id=17677468751",
    ["Salvaged Pipe Rifle"] = "http://www.roblox.com/asset/?id=17677468751",
    ["Salvaged P250"] = "http://www.roblox.com/asset/?id=17677447257",
    ["Nail Gun"] = "http://www.roblox.com/asset/?id=17677484756"
}

local Workspace, RunService, Players, CoreGui = cloneref(game:GetService("Workspace")), cloneref(game:GetService("RunService")), cloneref(game:GetService("Players")), game:GetService("CoreGui")
local lplayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local Cam = Workspace.CurrentCamera
local ScreenGui = nil

local function Create(Class, Properties)
    local _Instance = typeof(Class) == 'string' and Instance.new(Class) or Class
    for Property, Value in pairs(Properties) do
        _Instance[Property] = Value
    end
    return _Instance
end

local function FadeOutOnDist(element, distance)
    if not element then return end
    local transparency = math.max(0.1, 1 - (distance / ESPSettings.MaxDistance))
    if element:IsA("TextLabel") then
        element.TextTransparency = 1 - transparency
    elseif element:IsA("ImageLabel") then
        element.ImageTransparency = 1 - transparency
    elseif element:IsA("UIStroke") then
        element.Transparency = 1 - transparency
    elseif element:IsA("Frame") then
        element.BackgroundTransparency = 1 - transparency
    end
end

local function CreatePlayerESP(plr)
    if not ScreenGui then return end
    if vu88[plr] then return end

    local Name = Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, -11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESPSettings.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
    local Distance = Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESPSettings.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
    local Weapon = Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 31), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESPSettings.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
    local Box = Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESPSettings.Drawing.Boxes.Filled.RGB, BackgroundTransparency = 0.75, BorderSizePixel = 0})
    local Outline = Create("UIStroke", {Parent = Box, Enabled = true, Transparency = 0, Color = ESPSettings.Drawing.Boxes.Full.RGB, LineJoinMode = Enum.LineJoinMode.Miter})
    local Healthbar = Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(0, 255, 0), BackgroundTransparency = 0})
    local BehindHealthbar = Create("Frame", {Parent = ScreenGui, ZIndex = -1, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0})
    local HealthText = Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 31), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = ESPSettings.Drawing.Healthbar.HealthTextRGB, Font = Enum.Font.Code, TextSize = ESPSettings.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
    local WeaponIcon = Create("ImageLabel", {Parent = ScreenGui, BackgroundTransparency = 1, BorderColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Size = UDim2.new(0, 40, 0, 40)})
    local LeftTop, LeftSide, RightTop, RightSide = Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESPSettings.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)}), Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESPSettings.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)}), Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESPSettings.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)}), Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESPSettings.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
    local BottomSide, BottomDown, BottomRightSide, BottomRightDown = Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESPSettings.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)}), Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESPSettings.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)}), Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESPSettings.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)}), Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESPSettings.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
    local Flag1, Flag2 = Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESPSettings.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)}), Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESPSettings.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})

    local function HideESP()
        Box.Visible, Name.Visible, Distance.Visible, Weapon.Visible = false, false, false, false
        Healthbar.Visible, BehindHealthbar.Visible, HealthText.Visible = false, false, false
        WeaponIcon.Visible, LeftTop.Visible, LeftSide.Visible = false, false, false
        BottomSide.Visible, BottomDown.Visible, RightTop.Visible = false, false, false
        RightSide.Visible, BottomRightSide.Visible, BottomRightDown.Visible = false, false, false
        Flag1.Visible, Flag2.Visible = false, false
    end

    local connection = RunService.RenderStepped:Connect(function()
        if not ESPSettings.Enabled then
            HideESP()
            return
        end
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local HRP = plr.Character.HumanoidRootPart
            local Humanoid = plr.Character:FindFirstChild("Humanoid")
            if not Humanoid then return end
            local Pos, OnScreen = Cam:WorldToScreenPoint(HRP.Position)
            local Dist = (Cam.CFrame.Position - HRP.Position).Magnitude / 3.5714285714
            if OnScreen and Dist <= ESPSettings.MaxDistance then
                local Size = HRP.Size.Y
                local scaleFactor = (Size * Cam.ViewportSize.Y) / (Pos.Z * 2)
                local w, h = 3 * scaleFactor, 4.5 * scaleFactor

                if ESPSettings.FadeOut.OnDistance then
                    FadeOutOnDist(Box, Dist); FadeOutOnDist(Outline, Dist); FadeOutOnDist(Name, Dist)
                    FadeOutOnDist(Distance, Dist); FadeOutOnDist(Weapon, Dist); FadeOutOnDist(Healthbar, Dist)
                    FadeOutOnDist(BehindHealthbar, Dist); FadeOutOnDist(HealthText, Dist); FadeOutOnDist(WeaponIcon, Dist)
                    FadeOutOnDist(LeftTop, Dist); FadeOutOnDist(LeftSide, Dist); FadeOutOnDist(BottomSide, Dist)
                    FadeOutOnDist(BottomDown, Dist); FadeOutOnDist(RightTop, Dist); FadeOutOnDist(RightSide, Dist)
                    FadeOutOnDist(BottomRightSide, Dist); FadeOutOnDist(BottomRightDown, Dist)
                    FadeOutOnDist(Flag1, Dist); FadeOutOnDist(Flag2, Dist)
                end

               
                local shouldShowESP = false
                if AttributesTeamCheck.Enabled then
                    
                    shouldShowESP = not isTeammateByAttribute(plr)
                else
                    
                    if ESPSettings.TeamCheck and plr ~= lplayer and ((lplayer.Team ~= plr.Team and plr.Team) or (not lplayer.Team and not plr.Team)) then
                        shouldShowESP = true
                    elseif not ESPSettings.TeamCheck then
                        shouldShowESP = true
                    end
                end
                

                if shouldShowESP then
                    LeftTop.Visible = ESPSettings.Drawing.Boxes.Corner.Enabled
                    LeftTop.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                    LeftTop.Size = UDim2.new(0, w / 5, 0, 1)
                    LeftSide.Visible = ESPSettings.Drawing.Boxes.Corner.Enabled
                    LeftSide.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                    LeftSide.Size = UDim2.new(0, 1, 0, h / 5)
                    BottomSide.Visible = ESPSettings.Drawing.Boxes.Corner.Enabled
                    BottomSide.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                    BottomSide.Size = UDim2.new(0, 1, 0, h / 5)
                    BottomSide.AnchorPoint = Vector2.new(0, 5)
                    BottomDown.Visible = ESPSettings.Drawing.Boxes.Corner.Enabled
                    BottomDown.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                    BottomDown.Size = UDim2.new(0, w / 5, 0, 1)
                    BottomDown.AnchorPoint = Vector2.new(0, 1)
                    RightTop.Visible = ESPSettings.Drawing.Boxes.Corner.Enabled
                    RightTop.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y - h / 2)
                    RightTop.Size = UDim2.new(0, w / 5, 0, 1)
                    RightTop.AnchorPoint = Vector2.new(1, 0)
                    RightSide.Visible = ESPSettings.Drawing.Boxes.Corner.Enabled
                    RightSide.Position = UDim2.new(0, Pos.X + w / 2 - 1, 0, Pos.Y - h / 2)
                    RightSide.Size = UDim2.new(0, 1, 0, h / 5)
                    RightSide.AnchorPoint = Vector2.new(0, 0)
                    BottomRightSide.Visible = ESPSettings.Drawing.Boxes.Corner.Enabled
                    BottomRightSide.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                    BottomRightSide.Size = UDim2.new(0, 1, 0, h / 5)
                    BottomRightSide.AnchorPoint = Vector2.new(1, 1)
                    BottomRightDown.Visible = ESPSettings.Drawing.Boxes.Corner.Enabled
                    BottomRightDown.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                    BottomRightDown.Size = UDim2.new(0, w / 5, 0, 1)
                    BottomRightDown.AnchorPoint = Vector2.new(1, 1)

                    Box.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                    Box.Size = UDim2.new(0, w, 0, h)
                    Box.Visible = ESPSettings.Drawing.Boxes.Full.Enabled
                    Box.BackgroundColor3 = ESPSettings.Drawing.Boxes.Filled.RGB
                    Box.BackgroundTransparency = ESPSettings.Drawing.Boxes.Filled.Enabled and ESPSettings.Drawing.Boxes.Filled.Transparency or 1
                    Outline.Color = ESPSettings.Drawing.Boxes.Full.RGB

                    local health = Humanoid.Health / Humanoid.MaxHealth
                    Healthbar.Visible = ESPSettings.Drawing.Healthbar.Enabled
                    Healthbar.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2 + h * (1 - health))
                    Healthbar.Size = UDim2.new(0, ESPSettings.Drawing.Healthbar.Width, 0, h * health)
                    BehindHealthbar.Visible = ESPSettings.Drawing.Healthbar.Enabled
                    BehindHealthbar.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2)
                    BehindHealthbar.Size = UDim2.new(0, ESPSettings.Drawing.Healthbar.Width, 0, h)
                    
                    if ESPSettings.Drawing.Healthbar.HealthText then
                        local healthPercentage = math.floor(Humanoid.Health / Humanoid.MaxHealth * 100)
                        HealthText.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2 + h * (1 - healthPercentage / 100) + 3)
                        HealthText.Text = tostring(healthPercentage)
                        HealthText.Visible = Humanoid.Health < Humanoid.MaxHealth
                        HealthText.TextColor3 = ESPSettings.Drawing.Healthbar.HealthTextRGB
                    else
                        HealthText.Visible = false
                    end

                    Name.Visible = ESPSettings.Drawing.Names.Enabled
                    if ESPSettings.Options.Friendcheck and lplayer:IsFriendsWith(plr.UserId) then
                        Name.Text = string.format('(<font color="rgb(%d, %d, %d)">F</font>) %s', ESPSettings.Options.FriendcheckRGB.R * 255, ESPSettings.Options.FriendcheckRGB.G * 255, ESPSettings.Options.FriendcheckRGB.B * 255, plr.Name)
                    else
                        Name.Text = string.format('(<font color="rgb(%d, %d, %d)">E</font>) %s', 255, 0, 0, plr.Name)
                    end
                    Name.Position = UDim2.new(0, Pos.X, 0, Pos.Y - h / 2 - 9)

                    if ESPSettings.Drawing.Distances.Enabled then
                        if ESPSettings.Drawing.Distances.Position == "Bottom" then
                            Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 18)
                            WeaponIcon.Position = UDim2.new(0, Pos.X - 21, 0, Pos.Y + h / 2 + 15)
                            Distance.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 7)
                            Distance.Text = string.format("%d meters", math.floor(Dist))
                            Distance.Visible = true
                        elseif ESPSettings.Drawing.Distances.Position == "Text" then
                            Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 8)
                            WeaponIcon.Position = UDim2.new(0, Pos.X - 21, 0, Pos.Y + h / 2 + 5)
                            Distance.Visible = false
                            if ESPSettings.Options.Friendcheck and lplayer:IsFriendsWith(plr.UserId) then
                                Name.Text = string.format('(<font color="rgb(%d, %d, %d)">F</font>) %s [%d]', ESPSettings.Options.FriendcheckRGB.R * 255, ESPSettings.Options.FriendcheckRGB.G * 255, ESPSettings.Options.FriendcheckRGB.B * 255, plr.Name, math.floor(Dist))
                            else
                                Name.Text = string.format('(<font color="rgb(%d, %d, %d)">E</font>) %s [%d]', 255, 0, 0, plr.Name, math.floor(Dist))
                            end
                            Name.Visible = ESPSettings.Drawing.Names.Enabled
                        end
                    end

                    Weapon.Text = "none"
                    Weapon.Visible = ESPSettings.Drawing.Weapons.Enabled
                else
                    HideESP()
                end
            else
                HideESP()
            end
        else
            HideESP()
        end
    end)
    vu88[plr] = {connection}
end

local function vu158()
    if ScreenGui then
        ScreenGui:Destroy()
        ScreenGui = nil
    end
    for _, conn in pairs(vu88) do
        if type(conn) == "table" then
            for _, c in ipairs(conn) do
                pcall(function() c:Disconnect() end)
            end
        else
            pcall(function() conn:Disconnect() end)
        end
    end
    vu88 = {}
    ESPSettings.Enabled = false
end

local function vu153()
    vu158()
    ESPSettings.Enabled = true
    ScreenGui = Create("ScreenGui", {Parent = CoreGui, Name = "ESPHolder"})
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lplayer and not vu88[v] then
            CreatePlayerESP(v)
        end
    end
    
    vu88.PlayerAdded = Players.PlayerAdded:Connect(function(v)
        if v ~= lplayer and not vu88[v] then
            CreatePlayerESP(v)
        end
    end)
end

ESPSection:Toggle({
    Title = "总开关ESP", 
    Value = false, 
    Callback = function(state)
        vu85 = state
        if state then
            vu153() 
        else
            vu158() 
        end
    end
})

ESPSection:Toggle({
    Title = "初始化（点和不点都一样就是防止ESP没效果）",
    Value = false,
    Callback = function(state)
        AttributesTeamCheck.Enabled = state
    end
})

    task.wait(0.5)

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
        
        local runService = game:GetService("RunService")
        local angle = 0
        local animationConnection = runService.Heartbeat:Connect(function(deltaTime)
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
    
    task.wait(1)
    WindUI:Notify({
        Title = "BkFdI HUB通知",
        Content = "速度已绕过",
        Duration = 2,
    })   
    
end

WindUI:Popup({
    Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>H</font><font color='#444444'>U</font><font color='#222222'>B</font>",
    IconThemed = true,
    Content = "尊贵的用户" .. game.Players.LocalPlayer.Name .. "使用<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>H</font><font color='#444444'>U</font><font color='#222222'>B</font>手枪竞技场",
    Buttons = {
        {
            Title = "取消",
            Callback = function() 
                createUI()
            end,
            Variant = "Secondary",
        },
        {
            Title = "执行",
            Icon = "arrow-right",
            Callback = function() 
                createUI()
            end,
            Variant = "Primary",
        }
    }
})
