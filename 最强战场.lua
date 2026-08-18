local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Potato5466794/Wind/refs/heads/main/Wind.luau"))()

getgenv().TransparencyEnabled = getgenv().TransparencyEnabled or false





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


local Window = WindUI:CreateWindow({
    Title = "<font color='#FFB6C1'>X</font><font color='#FFA0B5'>I</font><font color='#FF8AA9'>A</font><font color='#FF749D'>O</font><font color='#FF5E91'>X</font><font color='#FF4885'>I</font>",
    IconTransparency = 1,
    Author = "byBkFd",
    Folder = "bsgm73",
    Size = UDim2.fromOffset(700, 500),
    Transparent = true,
    Theme = "Dark",
    UserEnabled = true,
    SideBarWidth = 220,
    HasOutline = true,
    Background = "video:https://raw.githubusercontent.com/xiaoxi9008/chesksks/refs/heads/main/VID_20260323_161157.mp4",
    ScrollBarEnabled = true
})

Window:Tag({
        Title = "破解版",
        Radius = 10,
        Color = Color3.fromHex("#ffffff"),
    })

    Window:Tag({
        Title = "最强战场",
        Radius = 10,
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
    Title = "<font color='#FFB6C1'>X</font><font color='#FFA0B5'>I</font><font color='#FF8AA9'>A</font><font color='#FF749D'>O</font><font color='#FF5E91'>X</font><font color='#FF4885'>I</font>",
    CornerRadius = UDim.new(16,16),
    StrokeThickness = 2,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 188, 217)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 153, 204)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 105, 180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 192, 203))
    }),
    Draggable = true,
})

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
        glowEffect.Rotation = (time * speed * 60) % 360
    end)
    
    return animation
end

local borderAnimation
local borderEnabled = true
local currentColor = "樱花粉2"
local animationSpeed = 5

local rainbowStroke = createRainbowBorder(Window, currentColor, animationSpeed)
if rainbowStroke then
    borderAnimation = startBorderAnimation(Window, animationSpeed)
end

local animationIDs = {
    ["rbxassetid://10468665991"] = true,
    ["rbxassetid://10466974800"] = true,
    ["rbxassetid://10471336737"] = true,
    ["rbxassetid://12510170988"] = true,
    ["rbxassetid://12272894215"] = true,
    ["rbxassetid://12296882427"] = true,
    ["rbxassetid://12307656616"] = true,
    ["rbxassetid://12351854556"] = true,
    ["rbxassetid://12534735382"] = true,
    ["rbxassetid://12502664044"] = true,
    ["rbxassetid://12509505723"] = true,
    ["rbxassetid://12618292188"] = true,
    ["rbxassetid://12684185971"] = true,
    ["rbxassetid://13376869471"] = true,
    ["rbxassetid://13294790250"] = true,
    ["rbxassetid://13376962659"] = true,
    ["rbxassetid://13501296372"] = true,
    ["rbxassetid://14004235777"] = true,
    ["rbxassetid://14003607057"] = true,
    ["rbxassetid://14046756619"] = true,
    ["rbxassetid://14048349132"] = true,
    ["rbxassetid://14299135500"] = true,
    ["rbxassetid://14967219354"] = true,
    ["rbxassetid://14357997687"] = true,
    ["rbxassetid://14357943487"] = true,
    ["rbxassetid://15290930205"] = true,
    ["rbxassetid://15145462680"] = true,
    ["rbxassetid://15295895753"] = true,
    ["rbxassetid://15311685628"] = true,
    ["rbxassetid://16139108718"] = true,
    ["rbxassetid://16139402582"] = true,
    ["rbxassetid://16515850153"] = true,
    ["rbxassetid://16431491215"] = true,
    ["rbxassetid://16597322398"] = true,
    ["rbxassetid://10469493270"] = true,
    ["rbxassetid://10469630950"] = true,
    ["rbxassetid://10469639222"] = true,
    ["rbxassetid://10469643643"] = true,
    ["rbxassetid://13532562418"] = true,
    ["rbxassetid://13491635433"] = true,
    ["rbxassetid://13296577783"] = true,
    ["rbxassetid://13295919399"] = true,
    ["rbxassetid://13370310513"] = true,
    ["rbxassetid://13390230973"] = true,
    ["rbxassetid://13378751717"] = true,
    ["rbxassetid://13378708199"] = true,
    ["rbxassetid://14004222985"] = true,
    ["rbxassetid://13997092940"] = true,
    ["rbxassetid://14001963401"] = true,
    ["rbxassetid://14136436157"] = true,
    ["rbxassetid://15259161390"] = true,
    ["rbxassetid://15240216931"] = true,
    ["rbxassetid://15240176873"] = true,
    ["rbxassetid://15162694192"] = true,
    ["rbxassetid://16515503507"] = true,
    ["rbxassetid://16515520431"] = true,
    ["rbxassetid://16515448089"] = true,
    ["rbxassetid://16552234590"] = true,
    ["rbxassetid://17889458563"] = true,
    ["rbxassetid://17889461810"] = true,
    ["rbxassetid://17889471098"] = true,
    ["rbxassetid://17889290569"] = true,
    ["rbxassetid://10479335397"] = true,
    ["rbxassetid://13380255751"] = true,
    ["rbxassetid://13362587853"] = true,
    ["rbxassetid://11365563255"] = {range = 175, behind = 17},
    ["rbxassetid://12983333733"] = {range = 200, behind = 16},
    ["rbxassetid://13927612951"] = {range = 100, behind = 16},
    ["rbxassetid://13146710762"] = {range = 200, behind = 24},
    ["rbxassetid://15520132233"] = {range = 100, behind = 75},
    ["rbxassetid://16082123712"] = {range = 40, behind = 20}
}

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local detectionRange = 15
local detectionMode = "360"
local lastTeleportTime = 0

local function getNearbyPlayers(radius)
    local players = {}
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player then
            local otherCharacter = otherPlayer.Character
            if otherCharacter then
                local otherHumanoidRootPart = otherCharacter:FindFirstChild("HumanoidRootPart")
                if otherHumanoidRootPart and (otherHumanoidRootPart.Position - humanoidRootPart.Position).Magnitude <= radius then
                    table.insert(players, otherPlayer)
                end
            end
        end
    end
    return players
end

local function isInFront(character, target)
    local lookVector = character.CFrame.lookVector
    local directionToTarget = (target.Position - character.Position).unit
    return lookVector:Dot(directionToTarget) > 0.5
end

local function checkAnimations()
    local currentTime = tick()
    if currentTime - lastTeleportTime < 0.1 then
        return
    end
    
    local nearbyPlayers = getNearbyPlayers(detectionRange)
    for _, otherPlayer in pairs(nearbyPlayers) do
        local otherCharacter = otherPlayer.Character
        if otherCharacter then
            local otherHumanoidRootPart = otherCharacter:FindFirstChild("HumanoidRootPart")
            if otherHumanoidRootPart then
                if (detectionMode == "360" or isInFront(humanoidRootPart, otherHumanoidRootPart)) then
                    for _, animTrack in pairs(otherCharacter:FindFirstChildOfClass("Humanoid"):GetPlayingAnimationTracks()) do
                        local animId = animTrack.Animation.AnimationId
                        local data = animationIDs[animId]
                        if data then
                            local teleportDistance = (type(data) == "table" and data.behind) or 18
                            local newPosition = otherHumanoidRootPart.Position - otherHumanoidRootPart.CFrame.lookVector * teleportDistance + Vector3.new(math.random(-1, 1), 0, math.random(-1, 1))
                            humanoidRootPart.CFrame = CFrame.new(newPosition)
                            lastTeleportTime = currentTime
                            return
                        end
                    end
                end
            end
        end
    end
end

local ultraInstinctActive = false

local RunService = game:GetService("RunService")

local function ultraInstinctLoop()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if ultraInstinctActive then
            checkAnimations()
        else
            connection:Disconnect()
        end
    end)
end

local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    if ultraInstinctActive then
        ultraInstinctLoop()
    end
end

local animationsToAvoid = {
    ["rbxassetid://10468665991"] = true,
    ["rbxassetid://10466974800"] = true,
    ["rbxassetid://10471336737"] = true,
    ["rbxassetid://12510170988"] = true,
    ["rbxassetid://12272894215"] = true,
    ["rbxassetid://12296882427"] = true,
    ["rbxassetid://12307656616"] = true,
    ["rbxassetid://12351854556"] = true,
    ["rbxassetid://12534735382"] = true,
    ["rbxassetid://12502664044"] = true,
    ["rbxassetid://12509505723"] = true,
    ["rbxassetid://12618292188"] = true,
    ["rbxassetid://12684185971"] = true,
    ["rbxassetid://13376869471"] = true,
    ["rbxassetid://13294790250"] = true,
    ["rbxassetid://13376962659"] = true,
    ["rbxassetid://13501296372"] = true,
    ["rbxassetid://14004235777"] = true,
    ["rbxassetid://14003607057"] = true,
    ["rbxassetid://14046756619"] = true,
    ["rbxassetid://14048349132"] = true,
    ["rbxassetid://14299135500"] = true,
    ["rbxassetid://14967219354"] = true,
    ["rbxassetid://14357997687"] = true,
    ["rbxassetid://14357943487"] = true,
    ["rbxassetid://15290930205"] = true,
    ["rbxassetid://15145462680"] = true,
    ["rbxassetid://15295895753"] = true,
    ["rbxassetid://15311685628"] = true,
    ["rbxassetid://16139108718"] = true,
    ["rbxassetid://16139402582"] = true,
    ["rbxassetid://16515850153"] = true,
    ["rbxassetid://16431491215"] = true,
    ["rbxassetid://16597322398"] = true,
    ["rbxassetid://10469493270"] = "special"
}

local skills = {
    firstskill = {"Normal Punch", "Flowing Water", "Machine Gun Blows", "Flash Strike", "Homerun", "Quick Slice", "Bullet Barrage", "Crushing Pull"},
    secondskill = {"Atmos Cleave", "Windstorm Fury", "Ignition Burst", "Whirlwind Kick", "Beatdown", "Consecutive Punches", "Lethal Whirlwind Stream", "Vanishing Kick"},
    thirdskill = {"Shove", "Hunter's Grasp", "Blitz Shot", "Scatter", "Grand Slam", "Pinpoint Cut", "Stone Coffin", "Whirlwind Drop"},
    fourthskill = {"Split Second Counter", "Expulsive Push", "Jet Dive", "Explosive Shuriken", "Foul Ball", "Uppercut", "Head First", "Prey's Peril"}
}

local skillCooldowns = {
    ["Normal Punch"] = 21,
    ["Flowing Water"] = 19,
    ["Machine Gun Blows"] = 17,
    ["Flash Strike"] = 18.5,
    ["Homerun"] = 18.6,
    ["Quick Slice"] = 21.5,
    ["Bullet Barrage"] = 22,
    ["Crushing Pull"] = 23,
    ["Consecutive Punches"] = 19,
    ["Lethal Whirlwind Stream"] = 22,
    ["Ignition Burst"] = 18.3,
    ["Whirlwind Kick"] = 21.5,
    ["Beatdown"] = 24.3,
    ["Atmos Cleave"] = 23.2,
    ["Windstorm Fury"] = 21,
    ["Vanishing Kick"] = 21,
    ["Shove"] = 11,
    ["Hunter's Grasp"] = 17.8,
    ["Blitz Shot"] = 26,
    ["Scatter"] = 22.3,
    ["Grand Slam"] = 21.7,
    ["Pinpoint Cut"] = 18,
    ["Stone Coffin"] = 25.7,
    ["Whirlwind Drop"] = 15.7,
    ["Jet Dive"] = 19.5,
    ["Explosive Shuriken"] = 18.5,
    ["Foul Ball"] = 24.8,
    ["Split Second Counter"] = 18.7,
    ["Expulsive Push"] = 20.7,
    ["Prey's Peril"] = 18.5,
    ["Head First"] = 22,
    ["Uppercut"] = 21
}

local skillUsage = {
    firstskill = 0,
    secondskill = 0,
    thirdskill = 0,
    fourthskill = 0
}

local function isAnimationPlaying(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            if animationsToAvoid[track.Animation.AnimationId] then
                return animationsToAvoid[track.Animation.AnimationId]
            end
        end
    end
    return false
end

local function teleportBehindTarget(player, targetPlayer, distance)
    local targetCharacter = targetPlayer.Character
    if targetCharacter then
        local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
        local playerHRP = player.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP and playerHRP then
            local backOffset = targetHRP.CFrame.lookVector * -distance
            playerHRP.CFrame = CFrame.new(targetHRP.Position + backOffset, targetHRP.Position)
        end
    end
end

local function equipAndUseSkill(player, skillType)
    local character = player.Character
    if character then
        local backpack = player.Backpack
        local liveFolder = workspace:FindFirstChild("Live")
        if backpack and liveFolder then
            for _, skill in pairs(skills[skillType]) do
                local tool = backpack:FindFirstChild(skill) or character:FindFirstChild(skill)
                if tool then
                    character.Humanoid:EquipTool(tool)
                    
                    local args = {
                        [1] = {
                            ["Mobile"] = true,
                            ["Goal"] = "LeftClick"
                        }
                    }
                    game:GetService("Players").LocalPlayer.Character.Communicate:FireServer(unpack(args))

                    wait(0.02)

                    local argsRelease = {
                        [1] = {
                            ["Goal"] = "LeftClickRelease",
                            ["Mobile"] = true
                        }
                    }
                    game:GetService("Players").LocalPlayer.Character.Communicate:FireServer(unpack(argsRelease))

                    character.Humanoid:UnequipTools()

                    if skillCooldowns[skill] then
                        skillUsage[skillType] = tick()
                        wait(skillCooldowns[skill])
                    end
                end
            end
        end
    end
end

local autoFarmThread
local useFirstSkill = false
local useSecondSkill = false
local useThirdSkill = false
local useFourthSkill = false
local ignoreFriends = false
local specificPlayerUsername = ""
local specificPlayerTarget = nil

local function findClosestMatchingPlayer(inputName)
    local players = game:GetService("Players"):GetPlayers()
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in pairs(players) do
        local distance = string.len(player.Name) + string.len(inputName) - 2 * string.len(player.Name:sub(1, string.len(inputName)))
        if distance < closestDistance then
            closestDistance = distance
            closestPlayer = player
        end
    end

    return closestPlayer
end

local function autoFarm()
    local player = game:GetService("Players").LocalPlayer
    local targetPlayer

    while true do
        wait(0.02)

        if specificPlayerTarget then
            targetPlayer = specificPlayerTarget
        else
            if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") or targetPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
                local players = game:GetService("Players"):GetPlayers()
                repeat
                    targetPlayer = players[math.random(1, #players)]
                until targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and (not ignoreFriends or not player:IsFriendsWith(targetPlayer.UserId))
            end
        end

        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            repeat wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        end

        local function handleAvoidAnimation()
            local endTime = tick() + 1
            while tick() < endTime do
                teleportBehindTarget(player, targetPlayer, 13)
                wait(0.02)
            end
        end

        if isAnimationPlaying(targetPlayer.Character) then
            handleAvoidAnimation()
        else
            teleportBehindTarget(player, targetPlayer, 3)

            local args = {
                [1] = {
                    ["Goal"] = "LeftClick",
                    ["Mobile"] = true
                }
            }
            game:GetService("Players").LocalPlayer.Character.Communicate:FireServer(unpack(args))

            local argsRelease = {
                [1] = {
                    ["Goal"] = "LeftClickRelease",
                    ["Mobile"] = true
                }
            }
            game:GetService("Players").LocalPlayer.Character.Communicate:FireServer(unpack(argsRelease))

            local currentTime = tick()

            if useFirstSkill and (currentTime - skillUsage["firstskill"] >= skillCooldowns[skills.firstskill[1]]) then
                coroutine.wrap(equipAndUseSkill)(player, "firstskill")
                skillUsage["firstskill"] = currentTime
            end
            if useSecondSkill and (currentTime - skillUsage["secondskill"] >= skillCooldowns[skills.secondskill[1]]) then
                coroutine.wrap(equipAndUseSkill)(player, "secondskill")
                skillUsage["secondskill"] = currentTime
            end
            if useThirdSkill and (currentTime - skillUsage["thirdskill"] >= skillCooldowns[skills.thirdskill[1]]) then
                coroutine.wrap(equipAndUseSkill)(player, "thirdskill")
                skillUsage["thirdskill"] = currentTime
            end
            if useFourthSkill and (currentTime - skillUsage["fourthskill"] >= skillCooldowns[skills.fourthskill[1]]) then
                coroutine.wrap(equipAndUseSkill)(player, "fourthskill")
                skillUsage["fourthskill"] = currentTime
            end
        end
    end
end

local punchAnimations = {
    ["10469493270"] = true,
    ["10469630950"] = true,
    ["10469639222"] = true,
    ["10469643643"] = true,
    ["13532562418"] = true,
    ["13491635433"] = true,
    ["13296577783"] = true,
    ["13295919399"] = true,
    ["13370310513"] = true,
    ["13390230973"] = true,
    ["13378751717"] = true,
    ["13378708199"] = true,
    ["14004222985"] = true,
    ["13997092940"] = true,
    ["14001963401"] = true,
    ["14136436157"] = true,
    ["15259161390"] = true,
    ["15240216931"] = true,
    ["15240176873"] = true,
    ["15162694192"] = true,
    ["16515503507"] = true,
    ["16515520431"] = true,
    ["16515448089"] = true,
    ["16552234590"] = true,
    ["17889458563"] = true,
    ["17889461810"] = true,
    ["17889471098"] = true,
    ["17889290569"] = true
}

local dashAnimations = {
    ["10479335397"] = true,
    ["13380255751"] = true
}

local skillAnimations = {
    ["10466974800"] = 1.8,
    ["12534735382"] = 1.9,
    ["14046756619"] = 0.5,
    ["13376962659"] = 1.0,
    ["12296882427"] = 0.4,
    ["12618292188"] = 0.6,
    ["12618271998"] = 0.6,
    ["13376869471"] = 0.5,
    ["17799224866"] = 0.9,
    ["18179181663"] = 0.6,
    ["16515850153"] = 0.8,
    ["16431491215"] = 0.7
}

local blockAnimations = {
    ["BlockingAnimationId"] = true
}

local function isPlayerInRange(player, range)
    local localPlayer = game:GetService("Players").LocalPlayer
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    local targetCharacter = player.Character
    if targetCharacter then
        local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
        if targetRootPart then
            local distance = (rootPart.Position - targetRootPart.Position).Magnitude
            return distance <= range
        end
    end
    return false
end

local function isLocalPlayerPlayingAnimation()
    local localPlayer = game:GetService("Players").LocalPlayer
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    for _, animTrack in pairs(character.Humanoid:GetPlayingAnimationTracks()) do
        local animId = animTrack.Animation.AnimationId:match("%d+$")
        if punchAnimations[animId] or dashAnimations[animId] or skillAnimations[animId] then
            return true
        end
    end
    return false
end

local function isLocalPlayerBlocking()
    local localPlayer = game:GetService("Players").LocalPlayer
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    for _, animTrack in pairs(character.Humanoid:GetPlayingAnimationTracks()) do
        local animId = animTrack.Animation.AnimationId:match("%d+$")
        if blockAnimations[animId] then
            return true
        end
    end
    return false
end

local function detectAnimations()
    local players = game:GetService("Players")

    for _, player in pairs(players:GetPlayers()) do
        if player ~= players.LocalPlayer then
            local inRange = false
            if detectionMode == "360" then
                inRange = isPlayerInRange(player, 50)
            end

            if inRange then
                local character = player.Character
                if character then
                    for _, animTrack in pairs(character.Humanoid:GetPlayingAnimationTracks()) do
                        local animId = animTrack.Animation.AnimationId:match("%d+$")
                        if not isLocalPlayerPlayingAnimation() then
                            if punchAnimations[animId] then
                                local args = {
                                    [1] = {
                                        ["Goal"] = "KeyPress",
                                        ["Key"] = Enum.KeyCode.F
                                    }
                                }

                                game:GetService("Players").LocalPlayer.Character.Communicate:FireServer(unpack(args))

                                wait(0.45)

                                local args = {
                                    [1] = {
                                        ["Goal"] = "KeyRelease",
                                        ["Key"] = Enum.KeyCode.F
                                    }
                                }

                                game:GetService("Players").LocalPlayer.Character.Communicate:FireServer(unpack(args))
                            elseif dashAnimations[animId] then
                                local args = {
                                    [1] = {
                                        ["Goal"] = "KeyPress",
                                        ["Key"] = Enum.KeyCode.F
                                    }
                                }

                                game:GetService("Players").LocalPlayer.Character.Communicate:FireServer(unpack(args))

                                wait(0.90)

                                local args = {
                                    [1] = {
                                        ["Goal"] = "KeyRelease",
                                        ["Key"] = Enum.KeyCode.F
                                    }
                                }

                                game:GetService("Players").LocalPlayer.Character.Communicate:FireServer(unpack(args))
                            elseif skillAnimations[animId] then
                                local args = {
                                    [1] = {
                                        ["Goal"] = "KeyPress",
                                        ["Key"] = Enum.KeyCode.F
                                    }
                                }

                                game:GetService("Players").LocalPlayer.Character.Communicate:FireServer(unpack(args))

                                wait(skillAnimations[animId])

                                local args = {
                                    [1] = {
                                        ["Goal"] = "KeyRelease",
                                        ["Key"] = Enum.KeyCode.F
                                    }
                                }

                                game:GetService("Players").LocalPlayer.Character.Communicate:FireServer(unpack(args))
                            end
                        end
                    end
                end
            end
        end
    end
end

local function autoPunch()
    local players = game:GetService("Players")

    for _, player in pairs(players:GetPlayers()) do
        if player ~= players.LocalPlayer then
            local inRange = false
            if detectionMode == "360" then
                inRange = isPlayerInRange(player, 7)
            end

            if inRange and not isLocalPlayerBlocking() then
                local args = {
                    [1] = {
                        ["Goal"] = "LeftClick",
                        ["Mobile"] = true
                    }
                }
                game:GetService("Players").LocalPlayer.Character.Communicate:FireServer(unpack(args))

                local argsRelease = {
                    [1] = {
                        ["Goal"] = "LeftClickRelease",
                        ["Mobile"] = true
                    }
                }
                game:GetService("Players").LocalPlayer.Character.Communicate:FireServer(unpack(argsRelease))
            end
        end
    end
end

local autoBlockEnabled = false
local autoPunchEnabled = false

game:GetService("RunService").Heartbeat:Connect(function()
    if autoBlockEnabled then
        detectAnimations()
    end
    if autoPunchEnabled then
        autoPunch()
    end
end)

local strongestBattleTab = Window:Tab({Title = "最强战场", Icon = "swords", Locked = false})

local combatSection = strongestBattleTab:Section({Title = "战斗功能", Icon = "sword", Opened = true})

local MusicTab = Window:Tab({Title = "音乐", Icon = "music", Locked = false})

combatSection:Keybind({
    Flag = "KeybindTest",
    Title = "快捷键",
    Desc = "打开UI的快捷键",
    Value = "G",
    Callback = function(v) 
        Window:SetToggleKey(Enum.KeyCode[v]) 
    end
})

combatSection:Toggle({
    Title = "防击打",
    Value = false,
    Callback = function(Value)
        ultraInstinctActive = Value
        if ultraInstinctActive then
            ultraInstinctLoop()
        end
    end
})

combatSection:Toggle({
    Title = "自动打人",
    Value = false,
    Callback = function(Value)
        if Value then
            autoFarmThread = coroutine.create(autoFarm)
            coroutine.resume(autoFarmThread)
        else
            if autoFarmThread then
                coroutine.close(autoFarmThread)
                autoFarmThread = nil
            end
        end
    end
})

combatSection:Input({
    Title = "输入玩家用户名",
    Placeholder = "输入玩家用户名",
    Callback = function(Value)
        specificPlayerUsername = Value
        specificPlayerTarget = findClosestMatchingPlayer(specificPlayerUsername)
    end
})

combatSection:Button({
    Title = "关闭自动打人",
    Callback = function()
        specificPlayerTarget = nil
    end
})

combatSection:Toggle({
    Title = "自动格挡",
    Value = false,
    Callback = function(Value)
        autoBlockEnabled = Value
    end
})

combatSection:Toggle({
    Title = "自动挥拳",
    Value = false,
    Callback = function(Value)
        autoPunchEnabled = Value
    end
})

combatSection:Toggle({
    Title = "自瞄玩家",
    Value = false,
    Callback = function(Value)
        getgenv().AutoAimlocking = Value
        game:GetService("RunService").RenderStepped:Connect(function() 
            if not getgenv().AutoAimlocking == true then 
                return 
            end 
            local x,b 
            for _,v in ipairs(game:GetService("Players"):GetPlayers()) do 
                if v.Character and v ~= game:GetService("Players").LocalPlayer then 
                    if not x or (v.Character.Head.Position - game:GetService("Players").LocalPlayer.Character.Head.Position).Magnitude < b then 
                        x = v 
                        b = (v.Character.Head.Position - game:GetService("Players").LocalPlayer.Character.Head.Position).Magnitude 
                    end 
                end 
            end 
            if x and b <= 15 then 
                game:GetService("Workspace").CurrentCamera.CFrame = CFrame.new(game:GetService("Workspace").CurrentCamera.CFrame.p, x.Character.HumanoidRootPart.Position) 
            end 
        end)
    end
})

combatSection:Toggle({
    Title = "自动躲技能",
    Value = false,
    Callback = function(Value)
        getgenv().AutoDodging = Value

        local DashAnims = {NormalDash = {10479335397},WeaponDash = {13380255751}}
        local SaitamaAnims = {
            NormalPunch = {10468665991}
        }
        local GarouAnims = {
            FlowingWater = {12272894215}
        }
        local GenosAnims = {
            MachineGunBlows = {12534735382}
        }
        local SonicAnims = {
            FlashStrike = {13376869471}
        }
        local MetalBatAnims = {
            Homerun = {14004235777,14003607057}
        }
        local SamuraiAnims = {
            QuickSlice = {15290930205}
        }
        local EsperAnims = {
            CrushingPull = {16139108718,16139402582}
        }

        local Animations = {}
        for _,x in pairs({DashAnims,SaitamaAnims,GarouAnims,GenosAnims,SonicAnims,MetalBatAnims,SamuraiAnims,EsperAnims}) do
            for _,k in pairs(x) do
                for _,v in pairs(k) do
                    table.insert(Animations,v)
                end
            end
        end

        task.spawn(function()
            local connection
            connection = game:GetService("RunService").RenderStepped:Connect(function()
                if getgenv().AutoDodging == true then
                    pcall(function()
                        for _,k in ipairs(workspace.Live:GetChildren()) do
                            if k:IsA("Model") and k:FindFirstChild("Head") and k.Head:IsA("Part") and k.Head.Name == "Head" and k.Head ~= game.Players.LocalPlayer.Character.Head then
                                if (k.Head.Position - game.Players.LocalPlayer.Character.Head.Position).magnitude <= 25 then
                                    if k:FindFirstChildOfClass("Humanoid") and k:FindFirstChildOfClass("Humanoid").Health > 0 then 
                                        local IsUsingAttacks = false
                                        for _,x in pairs(k:FindFirstChildOfClass("Humanoid"):GetPlayingAnimationTracks()) do
                                            local animId = x.Animation.AnimationId:match("%d+")
                                            if animId and table.find(Animations, tonumber(animId)) then
                                                IsUsingAttacks = true
                                                break
                                            end
                                        end

                                        if k:FindFirstChild("M1ing") or IsUsingAttacks then    
                                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(k.Head.Position + k.Head.CFrame.lookVector * -20 + Vector3.new(0,35,0),k.Head.Position)
                                        end
                                    end
                                end
                            end
                        end
                    end)
                else
                    if connection then
                        connection:Disconnect()
                    end
                end
            end)
        end)
    end
})

local autoSection = strongestBattleTab:Section({Title = "自动功能", Icon = "zap", Opened = true})

autoSection:Toggle({
    Title = "自动放技能1",
    Value = false,
    Callback = function(Value)
        useFirstSkill = Value
    end
})

autoSection:Toggle({
    Title = "自动放技能2",
    Value = false,
    Callback = function(Value)
        useSecondSkill = Value
    end
})

autoSection:Toggle({
    Title = "自动放技能3",
    Value = false,
    Callback = function(Value)
        useThirdSkill = Value
    end
})

autoSection:Toggle({
    Title = "自动放技能4",
    Value = false,
    Callback = function(Value)
        useFourthSkill = Value
    end
})

Window:OnClose(function()
    windowOpen = false
    if rainbowBorderAnimation then
        rainbowBorderAnimation:Disconnect()
        rainbowBorderAnimation = nil
    end
    applyBlurEffect(false)
end)

Window:OnDestroy(function()
    windowOpen = false
    if rainbowBorderAnimation then
        rainbowBorderAnimation:Disconnect()
        rainbowBorderAnimation = nil
    end
    for _, animation in pairs(fontColorAnimations) do
        animation:Disconnect()
    end
    fontColorAnimations = {}
    applyBlurEffect(false)
end)

MusicTab:Button({ -- 把 Scripts 改成 LoadScript
    Title = "网易云音乐",
    Icon = "file",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/网易云.lua"))()
        end)
        if success then
            WindUI:Notify({
                Title = "加载成功",
                Content = "网易云音乐已加载",
                Type = "success"
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "错误: " .. tostring(err),
                Type = "error"
            })
        end
    end
})