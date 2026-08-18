local WindUI

do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)

    if ok then
        WindUI = result
    else 
        WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/ui.lua"))()
    end
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ========== 自动连跳功能 ==========
local AutoJumpEnabled = false
local AutoJumpConnection = nil

local function StartAutoJump()
    if AutoJumpConnection then
        AutoJumpConnection:Disconnect()
    end
    
    AutoJumpConnection = RunService.Heartbeat:Connect(function()
        if AutoJumpEnabled and LocalPlayer.Character then
            local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if Humanoid and Humanoid.FloorMaterial ~= Enum.Material.Air then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

local function StopAutoJump()
    if AutoJumpConnection then
        AutoJumpConnection:Disconnect()
        AutoJumpConnection = nil
    end
end

local function ToggleAutoJump(Enabled)
    AutoJumpEnabled = Enabled
    if Enabled then
        StartAutoJump()
    else
        StopAutoJump()
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    if AutoJumpEnabled then
        StartAutoJump()
    end
end)

-- ========== 自动蹲下功能（和连跳一样逻辑） ==========
local AutoCrouchEnabled = false
local AutoCrouchConnection = nil

local function StartAutoCrouch()
    if AutoCrouchConnection then
        AutoCrouchConnection:Disconnect()
    end
    
    AutoCrouchConnection = RunService.Heartbeat:Connect(function()
        if AutoCrouchEnabled and LocalPlayer.Character then
            local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                if Humanoid.FloorMaterial ~= Enum.Material.Air then
                    Humanoid.Crouch = true
                else
                    Humanoid.Crouch = false
                end
            end
        end
    end)
end

local function StopAutoCrouch()
    if AutoCrouchConnection then
        AutoCrouchConnection:Disconnect()
        AutoCrouchConnection = nil
    end
end

local function ToggleAutoCrouch(Enabled)
    AutoCrouchEnabled = Enabled
    if Enabled then
        StartAutoCrouch()
    else
        StopAutoCrouch()
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    if AutoCrouchEnabled then
        StartAutoCrouch()
    end
end)

-- ========== 忠实往前走功能 ==========
local AutoWalkEnabled = false
local AutoWalkConnection = nil
local WalkSpeed = 16

local function StartAutoWalk()
    if AutoWalkConnection then
        AutoWalkConnection:Disconnect()
    end
    
    local StartDirection = nil
    
    AutoWalkConnection = RunService.Heartbeat:Connect(function()
        if not AutoWalkEnabled then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local Humanoid = character:FindFirstChildOfClass("Humanoid")
        local RootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not Humanoid or not RootPart then return end
        
        if not StartDirection then
            StartDirection = RootPart.CFrame.LookVector
            StartDirection = Vector3.new(StartDirection.X, 0, StartDirection.Z).Unit
        end
        
        RootPart.CFrame = CFrame.new(RootPart.Position, RootPart.Position + StartDirection)
        Humanoid:Move(StartDirection, false)
    end)
end

local function StopAutoWalk()
    if AutoWalkConnection then
        AutoWalkConnection:Disconnect()
        AutoWalkConnection = nil
    end
    
    local character = LocalPlayer.Character
    if character then
        local Humanoid = character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid:Move(Vector3.new(0, 0, 0), false)
        end
    end
end

local function ToggleAutoWalk(Enabled)
    AutoWalkEnabled = Enabled
    if Enabled then
        StartAutoWalk()
    else
        StopAutoWalk()
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    if AutoWalkEnabled then
        task.wait(0.5)
        StartAutoWalk()
    end
end)

-- ========== 执行脚本 ==========
local function executeScript(url, name)
    if Window and Window.Destroy then
        Window:Destroy()
    end
    
    task.wait(0.1)
    loadstring(game:HttpGet(url))()
end

-- ========== 创建UI ==========
local function createUI()
    Window = WindUI:CreateWindow({
        Title = "<font color='#C0C0C0'>X</font><font color='#B0B0B0'>I</font><font color='#A0A0A0'>A</font><font color='#909090'>O</font><font color='#808080'>X</font><font color='#707070'>I</font> <font color='#C0C0C0'>H</font><font color='#B0B0B0'>U</font><font color='#A0A0A0'>B</font>",
        Folder = "nico",
        NewElements = true,
        HideSearchBar = false,
        Size = UDim2.fromOffset(220, 420),
        Theme = "Dark",
        UserEnabled = true,
        SideBarWidth = 135,
        HasOutline = true,
        Background = "video:https://raw.githubusercontent.com/xiaoxi9008/chesksks/refs/heads/main/Video_1773198866292_902.mp4",
        
        OpenButton = {
            Title = "<font color='#C0C0C0'>X</font><font color='#B0B0B0'>I</font><font color='#A0A0A0'>A</font><font color='#909090'>O</font><font color='#808080'>X</font><font color='#707070'>I</font>",
            CornerRadius = UDim.new(1,0),
            StrokeThickness = 2,
            Enabled = true,
            Draggable = true,
            OnlyMobile = false,
            Color = ColorSequence.new(
                Color3.fromRGB(80, 80, 80), 
                Color3.fromRGB(180, 180, 180)
            )
        },
        Topbar = {
            Height = 44,
            ButtonsType = "Mac",
        }
    })

    Window:Tag({
        Title = "nico下一个机器人",
        Color = Color3.fromRGB(150, 150, 150)
    })

    local Red = Color3.fromRGB(255, 80, 80)
    local LightRed = Color3.fromRGB(255, 130, 130)
    local White = Color3.fromRGB(255, 255, 255)
    local Grey = Color3.fromRGB(180, 180, 180)

    -- ========== 首页选项卡 ==========
    local HomeTab = Window:Tab({
        Title = "首页",
        Desc = "作者介绍", 
        Icon = "solar:robot-bold",
        IconColor = Red,
        IconShape = "Square",
        Border = true,
    })

    HomeTab:Paragraph({
        Title = "nico的下一个机器人",
        Desc = "欢迎使用bsgm73 HUB | nico下一个机器人",
        ImageSize = 50,
        Thumbnail = "https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/Image_1774762956572_963.jpg",
        ThumbnailSize = 170
    })
    
HomeTab:Keybind({
    Flag = "KeybindTest",
    Title = "快捷键",
    Desc = "打开UI的快捷键",
    Value = "G",
    Callback = function(v) 
        Window:SetToggleKey(Enum.KeyCode[v]) 
    end
})    
    
    HomeTab:Divider()

    HomeTab:Button({
        Title = "显示欢迎",
        Icon = "heart",
        IconColor = Red,
        Callback = function()
            WindUI:Notify({
                Title = "nico的下一个机器人",
                Content = "欢迎使用！",
                Icon = "robot",
                Duration = 3
            })
        end
    })

    -- ========== 功能选项卡 ==========
    local FunctionTab = Window:Tab({
        Title = "主要功能",
        Desc = "辅助功能",
        Icon = "solar:bolt-bold",
        IconColor = Color3.fromRGB(255, 100, 100),
        IconShape = "Square",
        Border = true,
    })

    FunctionTab:Section({
        Title = "自动移动",
        Description = "自动移动"
    })

    FunctionTab:Toggle({
        Title = "自动连跳",
        Default = false,
        Callback = function(Value)
            ToggleAutoJump(Value)
            WindUI:Notify({
                Title = "nico",
                Content = "自动连跳 " .. (Value and "已开启" or "已关闭"),
                Icon = "robot",
                Duration = 1.5
            })
        end
    })

    FunctionTab:Toggle({
    Title = "自动蹲下",
    Default = false,
    Callback = function(Value)
        ToggleAutoCrouch(Value)
        WindUI:Notify({
            Title = "nico",
            Content = "自动蹲下 " .. (Value and "已开启" or "已关闭"),
            Icon = "robot",
            Duration = 1.5
        })
    end
})

    FunctionTab:Toggle({
        Title = "忠实往前走",
        Default = false,
        Callback = function(Value)
            ToggleAutoWalk(Value)
            WindUI:Notify({
                Title = "nico",
                Content = "忠实往前走 " .. (Value and "已开启" or "已关闭"),
                Icon = "robot",
                Duration = 1.5
            })
        end
    })

    FunctionTab:Paragraph({
        Title = "说明",
        Desc = "刷分专属😋"
    })

    -- ========== 设置选项卡 ==========
    local SettingsTab = Window:Tab({
        Title = "设置",
        Desc = "脚本设置",
        Icon = "solar:settings-bold",
        IconColor = Grey,
        IconShape = "Square",
        Border = true,
    })

    SettingsTab:Section({
        Title = "nico设置",
        Description = "基础设置选项"
    })

    SettingsTab:Button({
        Title = "重新加载",
        Icon = "refresh",
        Callback = function()
            if Window and Window.Destroy then
                Window:Destroy()
            end
            task.wait(0.1)
            createUI()
        end
    })

    SettingsTab:Button({
        Title = "销毁界面",
        Icon = "close",
        Color = Color3.fromRGB(255, 80, 80),
        Callback = function()
            if Window and Window.Destroy then
                Window:Destroy()
            end
        end
    })

    -- ========== 关于选项卡 ==========
    local AboutTab = Window:Tab({
        Title = "关于",
        Desc = "脚本信息",
        Icon = "solar:info-circle-bold",
        IconColor = White,
        IconShape = "Square",
        Border = true,
    })

    AboutTab:Paragraph({
        Title = "nico的下一个机器人",
        Desc = "版本：1.0.0\n作者：BkFdI\n永久免费脚本\n严禁倒卖！"
    })

    -- ========== 黑白渐变边框动画 ==========
    local function startBlackWhiteBorder()
        task.wait(0.3)
        
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if not mainFrame then
            mainFrame = Window.Main
        end
        
        if not mainFrame then
            warn("无法找到窗口主框架")
            return
        end
        
        local corner = mainFrame:FindFirstChildOfClass("UICorner")
        if not corner then
            corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 16)
            corner.Parent = mainFrame
        end
        
        local oldStroke = mainFrame:FindFirstChild("BWStroke")
        if oldStroke then oldStroke:Destroy() end
        
        local colorScheme = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
            ColorSequenceKeypoint.new(0.2, Color3.fromRGB(100, 100, 100)),
            ColorSequenceKeypoint.new(0.4, Color3.fromRGB(200, 200, 200)),
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.8, Color3.fromRGB(200, 200, 200)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
        })
        
        local stroke = Instance.new("UIStroke")
        stroke.Name = "BWStroke"
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.LineJoinMode = Enum.LineJoinMode.Round
        stroke.Enabled = true
        stroke.Transparency = 0
        stroke.Parent = mainFrame
        
        local gradient = Instance.new("UIGradient")
        gradient.Color = colorScheme
        gradient.Rotation = 0
        gradient.Parent = stroke
        
        local angle = 0
        local animationConnection = RunService.Heartbeat:Connect(function(deltaTime)
            if not stroke or stroke.Parent == nil then
                animationConnection:Disconnect()
                return
            end
            angle = (angle + 60 * deltaTime) % 360
            gradient.Rotation = angle
        end)
        
        print("黑白渐变边框动画已启动")
    end

    startBlackWhiteBorder()
end

-- 启动
createUI()