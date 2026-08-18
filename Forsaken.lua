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

print("✅ 环境净化完成干扰已禁用")

local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    Workspace = game:GetService("Workspace"),
    UserInputService = game:GetService("UserInputService"),
    CoreGui = game:GetService("CoreGui"),
    ReplicatedStorage = game:GetService("ReplicatedStorage")
}

local LocalPlayer = Services.Players.LocalPlayer
local Camera = Services.Workspace.CurrentCamera
local RunService = Services.RunService
local MapFolder = Services.Workspace:WaitForChild("Map"):WaitForChild("Ingame")



local ESPSettings = {
    killerESP = false,
    playerESP = false,
    generatorESP = false,
    itemESP = false,
    pizzaEsp = false,
    pizzaDeliveryEsp = false,
    zombieEsp = false,
    taphTripwireEsp = false,
    tripMineEsp = false,
    twoTimeRespawnEsp = false,
    graffitiEsp = false,
    sukkarsEsp = false,
    killerTracers = false,
    survivorTracers = false,
    generatorTracers = false,
    itemTracers = false,
    pizzaTracers = false,
    pizzaDeliveryTracers = false,
    zombieTracers = false,
    taphTripwireTracers = false,
    tripMineTracers = false,
    twoTimeRespawnTracers = false,
    killerSkinESP = false,
    survivorSkinESP = false,
    killerNameESP = true,
    killerHealthESP = true,
    survivorNameESP = true,
    survivorHealthESP = true,
    killerFillTransparency = 0.7,
    killerOutlineTransparency = 0.3,
    survivorFillTransparency = 0.7,
    survivorOutlineTransparency = 0.3,
    killerColor = Color3.fromRGB(255, 100, 100),
    survivorColor = Color3.fromRGB(100, 255, 100),
    generatorColor = Color3.fromRGB(200, 100, 200),
    itemColor = Color3.fromRGB(200, 200, 0),
    pizzaColor = Color3.fromRGB(200, 150, 0),
    pizzaDeliveryColor = Color3.fromRGB(200, 100, 100),
    zombieColor = Color3.fromRGB(200, 100, 100),
    taphTripwireColor = Color3.fromRGB(100, 0, 100),
    tripMineColor = Color3.fromRGB(255, 0, 255),
    twoTimeRespawnColor = Color3.fromRGB(0, 150, 200),
    graffitiColor = Color3.fromRGB(255, 255, 255),
    sukkarsColor = Color3.fromRGB(200, 130, 0)
}

local DummyNames = {
    "PizzaDeliveryRig", "Mafiaso1", "Mafiaso2", "Builderman", "Elliot",
    "ShedletskyCORRUPT", "ChancecORRUPT", "ChanceCORRUPT", "Mafia1", "Mafia2",
    "Mafia3", "Mafia4", "Mafia5", "Mafia6", "Mafia7", "Mafia8", "Mafia9",
    "GreenGuy", "RedGuy", "BlueGuy", "PurpleGuy", "PinkGuy", "YellowGuy",
    "OrangeGuy", "GreyGuy"
}

local PlayerESPData = {}
local ObjectESPData = {}
local TracerData = {}
local Highlights = {}
local Nametags = {}

local AdvancedSettings = {
    Enabled = false, 
    OutlineOnly = true, 
    ShowNametag = false, 
    Color = Color3.fromRGB(0, 255, 255)
}

local AdvancedNames = {
    "BuildermanDispenser","BuildermanSentry","HumanoidRootProjectile",
    "Swords","shockwave","Voidstar","Shadow"
}

local ESP = {}

local function IsRagdoll(model)
    local ragdolls = Services.Workspace:FindFirstChild("Ragdolls")
    if not ragdolls then return false end
    return model:IsDescendantOf(ragdolls) or (model.Parent == ragdolls)
end

local function IsSpectating(player)
    if not player then return false end
    local playersFolder = Services.Workspace:FindFirstChild("Players")
    if not playersFolder then return false end
    local spectating = playersFolder:FindFirstChild("Spectating")
    if not spectating then return false end
    return spectating:FindFirstChild(player.Name) ~= nil
end

local function GetGeneratorPart(model)
    if not model then return nil end
    local instances = model:FindFirstChild("Instances")
    if instances then
        local generator = instances:FindFirstChild("Generator")
        if generator then
            local cube = generator:FindFirstChild("Cube.003")
            if cube and cube:IsA("BasePart") then return cube end
            for _, v in ipairs(generator:GetDescendants()) do
                if v:IsA("BasePart") then return v end
            end
        end
        for _, v in ipairs(instances:GetDescendants()) do
            if v:IsA("BasePart") and tostring(v.Name):lower():find("cube") then
                return v
            end
        end
    end
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("cube") then
            return v
        end
    end
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") then return v end
    end
    return nil
end

local function GetModelRootPart(model)
    if not model then return nil end
    if model:IsA("BasePart") then return model end
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if hrp then return hrp end
    local primary = model.PrimaryPart
    if primary then return primary end
    for _, v in ipairs(model:GetChildren()) do
        if v:IsA("BasePart") then return v end
    end
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") then return v end
    end
    return nil
end

local function UpdatePlayerBillboardText(data)
    if not data or not data.model or not data.nameLabel then return end
    
    local model = data.model
    local isKiller = data.isKiller
    
    local actorText = model:GetAttribute("ActorDisplayName") or (isKiller and "杀手" or "幸存者")
    local skinText = model:GetAttribute("SkinNameDisplay")
    
    if actorText == "Noli" and model:GetAttribute("IsFakeNoli") == true then
        actorText = actorText .. " (假)"
    end
    
    local displayText = actorText
    
    local showSkin = (isKiller and ESPSettings.killerSkinESP) or (not isKiller and ESPSettings.survivorSkinESP)
    if showSkin and skinText and tostring(skinText) ~= "" then
        displayText = displayText .. " | " .. skinText
    end
    
    local showName = (isKiller and ESPSettings.killerNameESP) or (not isKiller and ESPSettings.survivorNameESP)
    data.nameLabel.Text = showName and displayText or ""
    data.nameLabel.Visible = showName
    
    if data.hpLabel then
        local humanoid = model:FindFirstChild("Humanoid")
        if humanoid then
            local hp = math.floor(humanoid.Health)
            local maxhp = math.floor(humanoid.MaxHealth)
            data.hpLabel.Text = string.format("血量: %d/%d", hp, maxhp)
        end
        local showHealth = (isKiller and ESPSettings.killerHealthESP) or (not isKiller and ESPSettings.survivorHealthESP)
        data.hpLabel.Visible = showHealth
    end
    
    local highlight = model:FindFirstChild("TAOWARE_Highlight")
    if highlight then
        if isKiller then
            highlight.FillTransparency = ESPSettings.killerFillTransparency
            highlight.OutlineTransparency = ESPSettings.killerOutlineTransparency
        else
            highlight.FillTransparency = ESPSettings.survivorFillTransparency
            highlight.OutlineTransparency = ESPSettings.survivorOutlineTransparency
        end
    end
end

local function UpdateGeneratorProgress(data)
    if not data or not data.model or not data.progressLabel then return end
    
    local model = data.model
    local progress = model:FindFirstChild("Progress")
    
    if progress then
        local progressValue = math.floor(progress.Value)
        data.progressLabel.Text = string.format("进度: %d%%", progressValue)
    end
end

local function UpdateAllPlayerESPText()
    for _, data in ipairs(PlayerESPData) do
        UpdatePlayerBillboardText(data)
    end
end

local function CreateNametag(adornee, text, color)
    if Nametags[adornee] then 
        pcall(function()
            Nametags[adornee].Parent:Destroy()
        end)
        Nametags[adornee] = nil
    end
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = adornee
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = true
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = color
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0,0,0)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 6
    textLabel.Parent = billboard
    billboard.Parent = adornee
    Nametags[adornee] = textLabel
end

local function CreateESP(model, color, isGenerator, isItem, isPizza, isPizzaDelivery, isZombie, isKiller, isTaph, isTripMine, isRespawn, isGraffiti, isSukkars)
    if not model then return end
    if model:FindFirstChild("TAOWARE_Highlight") then return end
    if isGenerator and model:FindFirstChild("Progress") and model.Progress.Value == 100 then return end
    if IsRagdoll(model) then return end

    local targetPart
    if isGenerator then
        targetPart = GetGeneratorPart(model)
    elseif isItem then
        targetPart = model:FindFirstChild("ItemRoot")
    elseif isPizza or isPizzaDelivery or isZombie or isGraffiti or isSukkars then
        targetPart = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
    elseif isTaph or isTripMine or isRespawn then
        if model:IsA("Model") then
            targetPart = GetGeneratorPart(model) or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
        else
            targetPart = model
        end
    else
        targetPart = model:FindFirstChild("HumanoidRootPart")
    end

    if not targetPart then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "TAOWARE_Highlight"
    highlight.Adornee = model
    highlight.FillColor = color
    highlight.OutlineColor = color
    
    if isKiller then
        highlight.FillTransparency = ESPSettings.killerFillTransparency
        highlight.OutlineTransparency = ESPSettings.killerOutlineTransparency
    elseif not isGenerator and not isItem and not isPizza and not isPizzaDelivery and not isZombie and not isTaph and not isTripMine and not isRespawn and not isGraffiti and not isSukkars then
        highlight.FillTransparency = ESPSettings.survivorFillTransparency
        highlight.OutlineTransparency = ESPSettings.survivorOutlineTransparency
    else
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 0.3
    end
    
    highlight.Parent = model

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "TAOWARE_Billboard"
    billboard.Adornee = targetPart
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = model

    if not isGenerator and not isItem and not isPizza and not isPizzaDelivery and not isZombie and not isTaph and not isTripMine and not isRespawn and not isGraffiti and not isSukkars then
        local humanoid = model:FindFirstChild("Humanoid")
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.33, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = "加载中..."
        nameLabel.Font = Enum.Font.GothamBlack
        nameLabel.TextColor3 = color
        nameLabel.TextSize = 8
        nameLabel.TextStrokeTransparency = 0.6
        nameLabel.Parent = billboard

        local hpLabel = Instance.new("TextLabel")
        hpLabel.Size = UDim2.new(1, 0, 0.33, 0)
        hpLabel.Position = UDim2.new(0, 0, 0.3, 0)
        hpLabel.BackgroundTransparency = 1
        hpLabel.Text = "血量: " .. (humanoid and string.format("%.0f", humanoid.Health) or "N/A")
        hpLabel.Font = Enum.Font.GothamBlack
        hpLabel.TextColor3 = color
        hpLabel.TextSize = 8
        hpLabel.TextStrokeTransparency = 0.6
        hpLabel.Parent = billboard

        local espData = {
            model = model, 
            nameLabel = nameLabel, 
            hpLabel = hpLabel, 
            color = color,
            isKiller = isKiller
        }
        
        table.insert(PlayerESPData, espData)
        
        UpdatePlayerBillboardText(espData)
        
        model:GetAttributeChangedSignal("ActorDisplayName"):Connect(function()
            UpdatePlayerBillboardText(espData)
        end)
        
        model:GetAttributeChangedSignal("SkinNameDisplay"):Connect(function()
            UpdatePlayerBillboardText(espData)
        end)
        
        model:GetAttributeChangedSignal("IsFakeNoli"):Connect(function()
            UpdatePlayerBillboardText(espData)
        end)
        
        if humanoid then
            humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                UpdatePlayerBillboardText(espData)
            end)
            humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
                UpdatePlayerBillboardText(espData)
            end)
        end
    elseif isGenerator then
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = "发电机"
        nameLabel.Font = Enum.Font.GothamBlack
        nameLabel.TextColor3 = color
        nameLabel.TextSize = 8
        nameLabel.TextStrokeTransparency = 0.6
        nameLabel.Parent = billboard
        
        local progressLabel = Instance.new("TextLabel")
        progressLabel.Size = UDim2.new(1, 0, 0.5, 0)
        progressLabel.Position = UDim2.new(0, 0, 0.5, 0)
        progressLabel.BackgroundTransparency = 1
        progressLabel.Text = "进度: 0%"
        progressLabel.Font = Enum.Font.GothamBlack
        progressLabel.TextColor3 = color
        progressLabel.TextSize = 8
        progressLabel.TextStrokeTransparency = 0.6
        progressLabel.Parent = billboard
        
        local espData = {
            model = model,
            nameLabel = nameLabel,
            progressLabel = progressLabel,
            highlight = highlight,
            billboard = billboard
        }
        
        table.insert(ObjectESPData, espData)
        
        UpdateGeneratorProgress(espData)
        
        local progress = model:FindFirstChild("Progress")
        if progress then
            progress:GetPropertyChangedSignal("Value"):Connect(function()
                UpdateGeneratorProgress(espData)
            end)
        end
    else
        local displayName = model.Name
        if isPizza then displayName = "披萨" end
        if isPizzaDelivery then displayName = "披萨送货员" end
        if isZombie then displayName = "僵尸" end
        if isTaph then displayName = "绊线" end
        if isTripMine then displayName = "地雷" end
        if isRespawn then displayName = "重生点" end
        if isGraffiti then displayName = "涂鸦" end
        if isSukkars then displayName = "姜饼" end
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = displayName
        textLabel.Font = Enum.Font.GothamBlack
        textLabel.TextColor3 = color
        textLabel.TextSize = 8
        textLabel.TextStrokeTransparency = 0.6
        textLabel.Parent = billboard

        table.insert(ObjectESPData, {model = model, highlight = highlight, billboard = billboard, type = displayName})
    end
end

local function RemoveESP(model)
    if not model then return end
    for i = #PlayerESPData, 1, -1 do
        if PlayerESPData[i].model == model then
            table.remove(PlayerESPData, i)
        end
    end
    for i = #ObjectESPData, 1, -1 do
        if ObjectESPData[i].model == model then
            table.remove(ObjectESPData, i)
        end
    end
    pcall(function()
        if model:FindFirstChild("TAOWARE_Highlight") then
            model.TAOWARE_Highlight:Destroy()
        end
        if model:FindFirstChild("TAOWARE_Billboard") then
            model.TAOWARE_Billboard:Destroy()
        end
    end)
end

local function CreateTracer(model, part, color)
    if not model or not part or not part:IsA("BasePart") then return end
    if TracerData[model] then return end

    local line = Drawing.new("Line")
    line.Visible = true
    line.Color = color or Color3.fromRGB(255, 255, 255)
    line.Thickness = 2
    line.Transparency = 1

    TracerData[model] = {line = line, part = part}
end

local function RemoveTracer(model)
    if TracerData[model] then
        pcall(function()
            TracerData[model].line.Visible = false
            TracerData[model].line:Remove()
        end)
        TracerData[model] = nil
    end
end

local function UpdateTracers()
    for model, data in pairs(TracerData) do
        local line = data.line
        local part = data.part
        if line and part and part.Parent then
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                line.Visible = true
                line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                line.To = Vector2.new(pos.X, pos.Y)
            else
                line.Visible = false
            end
        else
            RemoveTracer(model)
        end
    end
end

local noliByUsername = {}
local function clearFakeTags()
    local playersFolder = Services.Workspace:FindFirstChild("Players")
    if not playersFolder then return end
    local killers = playersFolder:FindFirstChild("Killers")
    if not killers then return end
    
    for _, killer in ipairs(killers:GetChildren()) do
        if killer:GetAttribute("ActorDisplayName") == "Noli" then
            killer:SetAttribute("IsFakeNoli", false)
        end
    end
end

local function scanNolis()
    local playersFolder = Services.Workspace:FindFirstChild("Players")
    if not playersFolder then return end
    local killers = playersFolder:FindFirstChild("Killers")
    if not killers then return end
    
    noliByUsername = {}
    for _, killer in ipairs(killers:GetChildren()) do
        if killer:GetAttribute("ActorDisplayName") == "Noli" then
            local username = killer:GetAttribute("Username")
            if username then
                if not noliByUsername[username] then
                    noliByUsername[username] = {}
                end
                table.insert(noliByUsername[username], killer)
            end
        end
    end
    for username, models in pairs(noliByUsername) do
        if #models > 1 then
            for i = 2, #models do
                models[i]:SetAttribute("IsFakeNoli", true)
            end
            models[1]:SetAttribute("IsFakeNoli", false)
        else
            models[1]:SetAttribute("IsFakeNoli", false)
        end
    end
end

local function updateFakeNolis()
    clearFakeTags()
    scanNolis()
end

local function AddHighlightAdvanced(Obj, Config)
    if Highlights[Obj] then 
        pcall(function()
            Highlights[Obj]:Destroy()
        end)
        Highlights[Obj] = nil
    end
    local hl = Instance.new("Highlight")
    hl.Adornee = Obj
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled = Config.Enabled
    hl.OutlineColor = Config.Color
    hl.FillColor = Config.Color
    hl.OutlineTransparency = 0
    local alwaysFill = table.find({"BuildermanDispenser","BuildermanSentry","PizzaDeliveryRig","HumanoidRootProjectile","Swords","shockwave","Voidstar","Shadow"}, Obj.Name)
    hl.FillTransparency = Config.OutlineOnly and 1 or (alwaysFill and 0.65 or 1)
    hl.Parent = Obj
    Highlights[Obj] = hl
    Obj.AncestryChanged:Connect(function(_, parent)
        if not parent then
            if Highlights[Obj] then 
                pcall(function()
                    Highlights[Obj]:Destroy()
                end)
                Highlights[Obj] = nil
            end
            if Nametags[Obj] then 
                pcall(function()
                    Nametags[Obj].Parent:Destroy()
                end)
                Nametags[Obj] = nil
            end
        end
    end)
end

local function ApplyToTargetAdvanced(target, Config)
    if not target or not target.Parent then return end
    AddHighlightAdvanced(target, Config)
end

local function HandleAdvanced(obj)
    if table.find(AdvancedNames, obj.Name) or (obj.Name == "Shadow" and obj.Parent and obj.Parent.Name == "Shadows") then
        ApplyToTargetAdvanced(obj, AdvancedSettings)
    end
end

for _, v in ipairs(MapFolder:GetDescendants()) do HandleAdvanced(v) end
MapFolder.DescendantAdded:Connect(HandleAdvanced)

task.spawn(function()
    while task.wait(0.3) do
        for obj, hl in pairs(Highlights) do
            if not hl or not hl.Parent then continue end
            hl.Enabled = AdvancedSettings.Enabled
            hl.OutlineColor = AdvancedSettings.Color
            hl.FillColor = AdvancedSettings.Color
            hl.OutlineTransparency = 0
            hl.FillTransparency = AdvancedSettings.OutlineOnly and 1 or 0.65
            if AdvancedSettings.ShowNametag then
                local baseName = obj.Name
                local nameText = baseName
                if Nametags[obj] then
                    Nametags[obj].Text = nameText
                    Nametags[obj].TextColor3 = AdvancedSettings.Color
                else
                    CreateNametag(obj, nameText, AdvancedSettings.Color)
                end
            else
                if Nametags[obj] then
                    pcall(function()
                        Nametags[obj].Parent:Destroy()
                    end)
                    Nametags[obj] = nil
                end
            end
        end
    end
end)

local function UpdateESP()
    local mapFolder = Services.Workspace:FindFirstChild("Map")
    if not mapFolder or not mapFolder:FindFirstChild("Ingame") then
        for i = #PlayerESPData, 1, -1 do
            RemoveESP(PlayerESPData[i].model)
        end
        for i = #ObjectESPData, 1, -1 do
            RemoveESP(ObjectESPData[i].model)
        end
        for model in pairs(TracerData) do
            RemoveTracer(model)
        end
        return
    end

    local ingame = mapFolder.Ingame

    local playersFolder = Services.Workspace:FindFirstChild("Players")
    if playersFolder then
        local killers = playersFolder:FindFirstChild("Killers")
        if killers then
            for _, killer in ipairs(killers:GetChildren()) do
                if killer == LocalPlayer.Character then continue end
                if IsRagdoll(killer) then
                    RemoveESP(killer)
                    RemoveTracer(killer)
                    continue
                end
                local player = Services.Players:GetPlayerFromCharacter(killer)
                if not player or IsSpectating(player) then
                    RemoveESP(killer)
                    RemoveTracer(killer)
                    continue
                end

                if ESPSettings.killerESP and not killer:FindFirstChild("TAOWARE_Highlight") and killer:FindFirstChild("HumanoidRootPart") then
                    CreateESP(killer, ESPSettings.killerColor, false, false, false, false, false, true)
                elseif not ESPSettings.killerESP then
                    RemoveESP(killer)
                end

                if ESPSettings.killerTracers and killer:FindFirstChild("HumanoidRootPart") then
                    CreateTracer(killer, killer.HumanoidRootPart, ESPSettings.killerColor)
                else
                    RemoveTracer(killer)
                end
            end
        end

        local survivors = playersFolder:FindFirstChild("Survivors")
        if survivors then
            for _, survivor in ipairs(survivors:GetChildren()) do
                if survivor == LocalPlayer.Character then continue end
                if IsRagdoll(survivor) then
                    RemoveESP(survivor)
                    RemoveTracer(survivor)
                    continue
                end
                local player = Services.Players:GetPlayerFromCharacter(survivor)
                if not player or IsSpectating(player) then
                    RemoveESP(survivor)
                    RemoveTracer(survivor)
                    continue
                end

                if ESPSettings.playerESP and not survivor:FindFirstChild("TAOWARE_Highlight") and survivor:FindFirstChild("HumanoidRootPart") then
                    CreateESP(survivor, ESPSettings.survivorColor, false, false, false, false, false, false)
                elseif not ESPSettings.playerESP then
                    RemoveESP(survivor)
                end

                if ESPSettings.survivorTracers and survivor:FindFirstChild("HumanoidRootPart") then
                    CreateTracer(survivor, survivor.HumanoidRootPart, ESPSettings.survivorColor)
                else
                    RemoveTracer(survivor)
                end
            end
        end
    end

    if ingame:FindFirstChild("Map") then
        for _, gen in ipairs(ingame.Map:GetChildren()) do
            if gen:IsA("Model") and gen.Name:lower():find("generator") and gen.Name ~= "FakeGenerator" then
                if IsRagdoll(gen) then
                    RemoveESP(gen)
                    RemoveTracer(gen)
                    continue
                end
                local progress = gen:FindFirstChild("Progress")
                if ESPSettings.generatorESP and progress and progress.Value < 100 and not gen:FindFirstChild("TAOWARE_Highlight") then
                    CreateESP(gen, ESPSettings.generatorColor, true, false, false, false, false, false)
                elseif not ESPSettings.generatorESP or (progress and progress.Value >= 100) then
                    RemoveESP(gen)
                end

                if ESPSettings.generatorTracers and progress and progress.Value < 100 then
                    local part = GetGeneratorPart(gen)
                    if part then
                        CreateTracer(gen, part, ESPSettings.generatorColor)
                    end
                else
                    RemoveTracer(gen)
                end
            end
        end
        
        for _, item in ipairs(ingame.Map:GetDescendants()) do
            if item.Name == "ItemRoot" and item.Parent and item.Parent:IsA("Model") then
                local itemModel = item.Parent
                if ESPSettings.itemESP and not itemModel:FindFirstChild("TAOWARE_Highlight") then
                    CreateESP(itemModel, ESPSettings.itemColor, false, true, false, false, false, false)
                elseif not ESPSettings.itemESP then
                    RemoveESP(itemModel)
                end
                
                if ESPSettings.itemTracers and item:IsA("BasePart") then
                    CreateTracer(itemModel, item, ESPSettings.itemColor)
                else
                    RemoveTracer(itemModel)
                end
            end
        end
    end
    
    for _, pizza in ipairs(ingame:GetChildren()) do
        if pizza.Name == "Pizza" and pizza:IsA("BasePart") then
            if ESPSettings.pizzaEsp and not pizza:FindFirstChild("TAOWARE_Highlight") then
                CreateESP(pizza, ESPSettings.pizzaColor, false, false, true, false, false, false)
            elseif not ESPSettings.pizzaEsp then
                RemoveESP(pizza)
            end
            
            if ESPSettings.pizzaTracers then
                CreateTracer(pizza, pizza, ESPSettings.pizzaColor)
            else
                RemoveTracer(pizza)
            end
        end
    end
    
    for _, delivery in ipairs(ingame:GetChildren()) do
        if delivery:IsA("Model") and table.find(DummyNames, delivery.Name) then
            if ESPSettings.pizzaDeliveryEsp and not delivery:FindFirstChild("TAOWARE_Highlight") then
                local hrp = delivery:FindFirstChild("HumanoidRootPart")
                if hrp then
                    CreateESP(delivery, ESPSettings.pizzaDeliveryColor, false, false, false, true, false, false)
                end
            elseif not ESPSettings.pizzaDeliveryEsp then
                RemoveESP(delivery)
            end
            
            if ESPSettings.pizzaDeliveryTracers then
                local hrp = delivery:FindFirstChild("HumanoidRootPart")
                if hrp then
                    CreateTracer(delivery, hrp, ESPSettings.pizzaDeliveryColor)
                end
            else
                RemoveTracer(delivery)
            end
        end
    end
    
    for _, zombie in ipairs(ingame:GetChildren()) do
        if zombie.Name == "1x1x1x1Zombie" and zombie:IsA("Model") then
            if ESPSettings.zombieEsp and not zombie:FindFirstChild("TAOWARE_Highlight") then
                local hrp = zombie:FindFirstChild("HumanoidRootPart")
                if hrp then
                    CreateESP(zombie, ESPSettings.zombieColor, false, false, false, false, true, false)
                end
            elseif not ESPSettings.zombieEsp then
                RemoveESP(zombie)
            end
            
            if ESPSettings.zombieTracers then
                local hrp = zombie:FindFirstChild("HumanoidRootPart")
                if hrp then
                    CreateTracer(zombie, hrp, ESPSettings.zombieColor)
                end
            else
                RemoveTracer(zombie)
            end
        end
    end
    
    for _, obj in ipairs(ingame:GetChildren()) do
        if obj.Name:match("TaphTripwire$") and obj:IsA("Model") then
            if ESPSettings.taphTripwireEsp and not obj:FindFirstChild("TAOWARE_Highlight") then
                CreateESP(obj, ESPSettings.taphTripwireColor, false, false, false, false, false, false, true)
            elseif not ESPSettings.taphTripwireEsp then
                RemoveESP(obj)
            end
            
            if ESPSettings.taphTripwireTracers then
                local part = GetGeneratorPart(obj) or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    CreateTracer(obj, part, ESPSettings.taphTripwireColor)
                end
            else
                RemoveTracer(obj)
            end
        end
    end
    
    for _, obj in ipairs(ingame:GetChildren()) do
        if obj.Name == "SubspaceTripmine" and obj:IsA("Model") then
            if ESPSettings.tripMineEsp and not obj:FindFirstChild("TAOWARE_Highlight") then
                CreateESP(obj, ESPSettings.tripMineColor, false, false, false, false, false, false, false, true)
            elseif not ESPSettings.tripMineEsp then
                RemoveESP(obj)
            end
            
            if ESPSettings.tripMineTracers then
                local part = GetGeneratorPart(obj) or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    CreateTracer(obj, part, ESPSettings.tripMineColor)
                end
            else
                RemoveTracer(obj)
            end
        end
    end
    
    for _, obj in ipairs(ingame:GetDescendants()) do
        if obj and obj.Name and tostring(obj.Name):lower():find("respawnlocation") then
            local target = obj
            if obj:IsA("Model") then
                target = obj
            elseif obj:IsA("BasePart") then
                target = obj
            else
                target = obj:FindFirstAncestorOfClass("Model") or (obj:IsA("BasePart") and obj)
            end
            
            if not target or IsRagdoll(target) then continue end
            
            if ESPSettings.twoTimeRespawnEsp and not target:FindFirstChild("TAOWARE_Highlight") then
                if target:IsA("Model") then
                    CreateESP(target, ESPSettings.twoTimeRespawnColor, false, false, false, false, false, false, false, false, true)
                else
                    CreateESP(target, ESPSettings.twoTimeRespawnColor, false, false, true, false, false, false, false, false, true)
                end
            elseif not ESPSettings.twoTimeRespawnEsp then
                RemoveESP(target)
            end
            
            if ESPSettings.twoTimeRespawnTracers then
                local part = nil
                if target:IsA("Model") then
                    part = GetGeneratorPart(target) or target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart", true)
                elseif target:IsA("BasePart") then
                    part = target
                end
                if part then
                    CreateTracer(target, part, ESPSettings.twoTimeRespawnColor)
                end
            else
                RemoveTracer(target)
            end
        end
    end
    
    for _, obj in ipairs(ingame:GetChildren()) do
        if obj.Name == "GraffitiCL" and obj:IsA("BasePart") then
            if ESPSettings.graffitiEsp and not obj:FindFirstChild("TAOWARE_Highlight") then
                CreateESP(obj, ESPSettings.graffitiColor, false, false, false, false, false, false, false, false, false, true)
            elseif not ESPSettings.graffitiEsp then
                RemoveESP(obj)
            end
        end
    end
    
    local currencyLocations = ingame:FindFirstChild("CurrencyLocations")
    if currencyLocations then
        for _, sukkar in ipairs(currencyLocations:GetChildren()) do
            if sukkar:IsA("Model") then
                if ESPSettings.sukkarsEsp and not sukkar:FindFirstChild("TAOWARE_Highlight") then
                    CreateESP(sukkar, ESPSettings.sukkarsColor, false, false, false, false, false, false, false, false, false, false, true)
                elseif not ESPSettings.sukkarsEsp then
                    RemoveESP(sukkar)
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        UpdateESP()
        updateFakeNolis()
        task.wait(0.5)
    end
end)

RunService.RenderStepped:Connect(function()
    UpdateTracers()
end)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _env = getgenv and getgenv() or {}
local _hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")


    local repo = 'https://raw.githubusercontent.com/xiaoxi9008/-UI/refs/heads/main/'
    local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
    -- 修正：删掉了 addons/，因为文件在仓库根目录
    local ThemeManager = loadstring(game:HttpGet(repo .. '颜色修改.lua'))()
    local SaveManager = loadstring(game:HttpGet(repo .. 'XIoxihei.lua'))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true


local Window = Library:CreateWindow({
	Title = 'XIAOXI SCRIPT',
	Footer = "Forsaken",
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = true,
	NotifySide = "Right",
	TabPadding = 8,
	MenuFadeTime = 0
})



local Tabs = {
    new = Window:AddTab('信息', 'person-standing'),
    Esp = Window:AddTab('透视','eye'),
    ani = Window:AddTab('反检测','cpu'),
    Main = Window:AddTab('杂项','house'),
    Bro = Window:AddTab('战斗','biohazard'),
    Block = Window:AddTab('格挡','user'),
    zdx = Window:AddTab('修机','printer'),
    Sat = Window:AddTab('力量','zap'),
    ["UI Settings"] = Window:AddTab('界面设置', 'settings')
    
}




local information = Tabs.new:AddRightGroupbox('Player','info')

information:AddLabel("注入器 : " ..identifyexecutor())
information:AddLabel("用户名 : " ..game.Players.LocalPlayer.Name)
information:AddLabel("玩家ID : "..game.Players.LocalPlayer.UserId)
information:AddLabel("昵称 : "..game.Players.LocalPlayer.DisplayName)
information:AddLabel("注册时长 : "..game.Players.LocalPlayer.AccountAge.." 天")





local new = Tabs.new:AddLeftGroupbox('公告')

new:AddLabel("bsgm73 SCRIPT破解版Forsaken")


new:AddLabel("Dev 提供者: Yuxingchen")


new:AddLabel("脚本所有者: byBkFd")



local KillerSurvival = Tabs.Main:AddRightGroupbox('聊天框可见')

KillerSurvival:AddToggle('AlwaysShowChat', {
        Text = "显示聊天框",
        Callback = function(state)
            if state then
                _G.showChat = true
                task.spawn(function()
                    while _G.showChat and task.wait() do
                        game:GetService("TextChatService"):FindFirstChildOfClass("ChatWindowConfiguration").Enabled = true
                    end
                end)
            else
                _G.showChat = false
                if playingState ~= "Spectating" then
                    game:GetService("TextChatService"):FindFirstChildOfClass("ChatWindowConfiguration").Enabled = false
                end
            end
        end
    })

    function panic()
        for i, v in pairs(Toggles) do
            pcall(function()
                if v.Value == false then return end
                v:SetValue(false)
            end)
        end
    end

    Library:OnUnload(function()
        _G.VoidsakenExecuted = false
        panic()
        getgenv().FlipUI:Destroy()
        getgenv().AimbotUI:Destroy()
        getgenv().BlockUI:Destroy()
    end)




local ZZ = Tabs.Main:AddRightGroupbox('自动拾取物品')


ZZ:AddToggle('自动拾取医疗包', {
    Text = '自动互动医疗包',
    Default = false,
    Tooltip = '自动与医疗包互动',
    
    Callback = function(state)
        autoMedkitEnabled = state
        
        if autoMedkitEnabled then
            medkitThread = task.spawn(function()
                while autoMedkitEnabled and task.wait(0.5) do
                    local medkit = workspace:FindFirstChild("Map", true)
                    if medkit then
                        medkit = medkit:FindFirstChild("Ingame", true)
                        if medkit then
                            medkit = medkit:FindFirstChild("Medkit", true)
                            if medkit then
                                local itemRoot = medkit:FindFirstChild("ItemRoot", true)
                                if itemRoot then
                                    local prompt = itemRoot:FindFirstChild("ProximityPrompt", true)
                                    if prompt then
                                        fireproximityprompt(prompt)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        elseif medkitThread then
            task.cancel(medkitThread)
            medkitThread = nil
        end
    end
})


ZZ:AddToggle('自动拾取可乐', {
    Text = '自动互动可乐',
    Default = false,
    Tooltip = '自动与可乐互动',
    
    Callback = function(state)
        autoColaEnabled = state
        
        if autoColaEnabled then
            colaThread = task.spawn(function()
                while autoColaEnabled and task.wait(0.5) do
                    local cola = workspace:FindFirstChild("Map", true)
                    if cola then
                        cola = cola:FindFirstChild("Ingame", true)
                        if cola then
                            cola = cola:FindFirstChild("BloxyCola", true)
                            if cola then
                                local itemRoot = cola:FindFirstChild("ItemRoot", true)
                                if itemRoot then
                                    local prompt = itemRoot:FindFirstChild("ProximityPrompt", true)
                                    if prompt then
                                        fireproximityprompt(prompt)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        elseif colaThread then
            task.cancel(colaThread)
            colaThread = nil
        end
    end
})


local FPS = Tabs.Main:AddLeftGroupbox('FPS')



FPS:AddToggle("MyToggle1", {
    Text = "解锁FPS",
    Default = false,
    Callback = function(Value)
        local function setfpscap(fps)
            if setfpscap then
                setfpscap(fps)
            else
                local RunService = game:GetService("RunService")
                RunService:SetRenderFPS(fps)
            end
        end
        
        if Value then
            setfpscap(1000000)
        else
            setfpscap(60)
        end
    end,
})


FPS:AddButton({
	Text = "降低FPS",
	Func = function()
	
	local lighting = game:GetService("Lighting")
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        lighting.GlobalShadows = false
        lighting.FogEnd = 9e9
        if terrain then
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 0
        end
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart")
                or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Explosion") then
                v.BlastPressure = 0
                v.BlastRadius = 0
            end
        end
	
	
	

	end,
	DoubleClick = false,
	Tooltip = "加载",
	DisabledTooltip = "我已禁用！",
	Disabled = false,
	Visible = true,
	Risky = false,
})






local MainTabbox = Tabs.Main:AddLeftTabbox()
local Lighting = MainTabbox:AddTab("亮度调节")
local Camera = MainTabbox:AddTab("视野")

local lightingConnection
local cameraConnection

Lighting:AddSlider("B", {
    Text = "亮度数值",
    Min = 0,
    Default = 0,
    Max = 3,
    Rounding = 1,
    Compact = true,
    Callback = function(v)
        _env.Brightness = v
    end
})

Lighting:AddToggle("无阴影", {
    Text = "无阴影",
    Default = false,
    Callback = function(v)
        _env.GlobalShadows = v
    end
})

Lighting:AddToggle("除雾", {
    Text = "除雾",
    Default = false,
    Callback = function(v)
        _env.NoFog = v
    end
})

Lighting:AddDivider()

Lighting:AddToggle("启用功能", {
    Text = "启用",
    Default = false,
    Callback = function(v)
        _env.Fullbright = v
        
        if lightingConnection then
            lightingConnection:Disconnect()
            lightingConnection = nil
        end
        
        if v then
            lightingConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if not game.Lighting:GetAttribute("FogStart") then 
                    game.Lighting:SetAttribute("FogStart", game.Lighting.FogStart) 
                end
                if not game.Lighting:GetAttribute("FogEnd") then 
                    game.Lighting:SetAttribute("FogEnd", game.Lighting.FogEnd) 
                end
                
                game.Lighting.FogStart = _env.NoFog and 0 or game.Lighting:GetAttribute("FogStart")
                game.Lighting.FogEnd = _env.NoFog and math.huge or game.Lighting:GetAttribute("FogEnd")
                
                local fog = game.Lighting:FindFirstChildOfClass("Atmosphere")
                if fog then
                    if not fog:GetAttribute("Density") then 
                        fog:SetAttribute("Density", fog.Density) 
                    end
                    fog.Density = _env.NoFog and 0 or fog:GetAttribute("Density")
                end
                
                game.Lighting.OutdoorAmbient = Color3.new(1,1,1)
                game.Lighting.Brightness = _env.Brightness or 0
                game.Lighting.GlobalShadows = not _env.GlobalShadows
            end)
        else
            game.Lighting.OutdoorAmbient = Color3.fromRGB(55,55,55)
            game.Lighting.Brightness = 0
            game.Lighting.GlobalShadows = true
        end
    end
})

local FOVEnabled = true
local FOVValue = 80

Camera:AddToggle("FieldOfViewToggle", {
    Text = "启用FOV调节",
    Default = true,
    Callback = function(Enabled)
        FOVEnabled = Enabled
        local FieldOfView = game:GetService("Players").LocalPlayer.PlayerData.Settings.Game.FieldOfView
        if FieldOfView then
            if Enabled then
                FieldOfView.Value = FOVValue
            else
                FieldOfView.Value = 80
            end
        end
    end,
})

Camera:AddSlider("FieldOfView", {
    Text = "视野 (FOV)",
    Default = 80,
    Min = 0,
    Max = 120,
    Rounding = 1,
    Callback = function(Value)
        FOVValue = Value
        if FOVEnabled then
            local FieldOfView = game:GetService("Players").LocalPlayer.PlayerData.Settings.Game.FieldOfView
            if FieldOfView then
                FieldOfView.Value = Value
            end
        end
    end,
})

local LOL = Tabs.Bro:AddRightTabbox()
local SM = LOL:AddTab("HitBox追踪")


local HitboxTrackingEnabled = false
local HeartbeatConnection = nil
local MaxDistance = 120
local FilterSurvivors = false
local FilterKillers = false
local WallCheckEnabled = false 
local TrackSubspaceTripmine = false
local TrackBuildermanDispenser = false
local TrackBuildermanSentry = false

local Killers = {
    ["Slasher"] = true, ["1x1x1x1"] = true, ["c00lkidd"] = true,
    ["Noli"] = true, ["JohnDoe"] = true, ["Guest 666"] = true,
    ["Sixer"] = true, ["Nosferatu"]=true
}
local Survivors = {
    ["Noob"] = true, ["Guest1337"] = true, ["Elliot"] = true,
    ["Shedletsky"] = true, ["TwoTime"] = true, ["007n7"] = true,
    ["Chance"] = true, ["Builderman"] = true, ["Taph"] = true,
    ["Dusekkar"] = true, ["Veeronica"] = true
}

local AttackAnimations = {
    'rbxassetid://131430497821198',
    'rbxassetid://83829782357897',
    'rbxassetid://126830014841198',
    'rbxassetid://126355327951215',
    'rbxassetid://121086746534252',
    'rbxassetid://105458270463374',
    'rbxassetid://18885909645',
    'rbxassetid://87259391926321',
    'rbxassetid://106014898528300',
    'rbxassetid://86545133269813',
    'rbxassetid://89448354637442',
    'rbxassetid://90499469533503',
    'rbxassetid://116618003477002',
    'rbxassetid://106086955212611',
    'rbxassetid://107640065977686',
    'rbxassetid://77124578197357',
    'rbxassetid://101771617803133',
    'rbxassetid://134958187822107',
    'rbxassetid://111313169447787',
    'rbxassetid://71685573690338',
    'rbxassetid://129843313690921',
    'rbxassetid://97623143664485',
    'rbxassetid://136007065400978',
    'rbxassetid://86096387000557',
    'rbxassetid://108807732150251',
    'rbxassetid://138040001965654',
    'rbxassetid://73502073176819',
    'rbxassetid://86709774283672',
    'rbxassetid://140703210927645',
    'rbxassetid://96173857867228',
    'rbxassetid://121255898612475',
    'rbxassetid://98031287364865',
    'rbxassetid://119462383658044',
    'rbxassetid://77448521277146',
    'rbxassetid://103741352379819',
    'rbxassetid://131696603025265',
    'rbxassetid://122503338277352',
    'rbxassetid://97648548303678',
    'rbxassetid://94162446513587',
    'rbxassetid://84426150435898',
    'rbxassetid://93069721274110',
    'rbxassetid://114620047310688',
    'rbxassetid://97433060861952',
    'rbxassetid://82183356141401',
    'rbxassetid://100592913030351',
    'rbxassetid://121293883585738',
    'rbxassetid://70447634862911',
    'rbxassetid://92173139187970',
    'rbxassetid://106847695270773',
    'rbxassetid://125403313786645',
    'rbxassetid://81639435858902',
    'rbxassetid://137314737492715',
    'rbxassetid://120112897026015',
    'rbxassetid://82113744478546',
    'rbxassetid://118298475669935',
    'rbxassetid://126681776859538',
    'rbxassetid://129976080405072',
    'rbxassetid://109667959938617',
    'rbxassetid://74707328554358',
    'rbxassetid://133336594357903',
    'rbxassetid://86204001129974',
    'rbxassetid://124243639579224',
    'rbxassetid://70371667919898',
    'rbxassetid://131543461321709',
    'rbxassetid://136323728355613',
    'rbxassetid://109230267448394',
    'rbxassetid://139835501033932',
    'rbxassetid://106538427162796',
    'rbxassetid://110400453990786',
    'rbxassetid://83685305553364',
    'rbxassetid://126171487400618',
    'rbxassetid://122709416391891',
    'rbxassetid://87989533095285',
    'rbxassetid://119326397274934',
    'rbxassetid://140365014326125',
    'rbxassetid://139309647473555',
    'rbxassetid://133363345661032',
    'rbxassetid://128414736976503',
    'rbxassetid://121808371053483',
    'rbxassetid://88451353906104',
    'rbxassetid://81299297965542',
    'rbxassetid://99829427721752',
    'rbxassetid://126896426760253',
    'rbxassetid://77375846492436',
    'rbxassetid://94634594529334',
    'rbxassetid://101031946095087',
    'rbxassetid://84069821282466',
    'rbxassetid://90620531468240',
    'rbxassetid://114506382930939',
    'rbxassetid://130958529065375',
    'rbxassetid://126727756047566',
    'rbxassetid://94958041603347',
    'rbxassetid://110702884830060',
    'rbxassetid://131642454238375',
    'rbxassetid://138938529389204',
    'rbxassetid://108018357044094',
    'rbxassetid://100725497418533',
    'rbxassetid://131082534135875',
    'rbxassetid://83251433279852',
    'rbxassetid://88970503168421',
    'rbxassetid://96571077893813',
    'rbxassetid://97167027849946',
    'rbxassetid://98456918873918',
    'rbxassetid://106776364623742',
    'rbxassetid://109700476007435',
    'rbxassetid://114356208094580',
    'rbxassetid://124705663396411',
    'rbxassetid://93366464803829',
    'rbxassetid://98590570796574',
    'rbxassetid://114152086302685',
    'rbxassetid://18885906143',
    'rbxassetid://73833636394121',
    'rbxassetid://92645737884601',
    'rbxassetid://86451881483688'
}
SM:AddSlider("DistanceSlider", {
    Text = "追踪范围",
    Default = 120,
    Min = 1,
    Max = 300,
    Rounding = 0,
    Callback = function(value)
        MaxDistance = value
    end
})

SM:AddToggle("FilterSurvivorsToggle", {
    Text = "过滤[不追踪]幸存者",
    Default = false,
    Callback = function(state)
        FilterSurvivors = state
    end
})

SM:AddToggle("FilterKillersToggle", {
    Text = "过滤[不追踪]杀手",
    Default = false,
    Callback = function(state)
        FilterKillers = state
    end
})


SM:AddToggle("WallCheckToggle", {
    Text = "Wallcheck",
    Default = false,
    Callback = function(state)
        WallCheckEnabled = state
    end
})

SM:AddToggle("TrackSubspaceTripmine", {
    Text = "追踪空间炸弹",
    Default = false,
    Callback = function(state)
        TrackSubspaceTripmine = state
    end
})

SM:AddToggle("TrackBuildermanDispenser", {
    Text = "追踪炮台",
    Default = false,
    Callback = function(state)
        TrackBuildermanDispenser = state
    end
})

SM:AddToggle("TrackBuildermanSentry", {
    Text = "追踪治疗机",
    Default = false,
    Callback = function(state)
        TrackBuildermanSentry = state
    end
})

SM:AddToggle("HitboxTrackingToggle", {
    Text = "Hitbox追踪",
    Default = false,
    Callback = function(state)
        HitboxTrackingEnabled = state
        
        if HeartbeatConnection then
            HeartbeatConnection:Disconnect()
            HeartbeatConnection = nil
        end
        
        if not state then return end
        
        repeat task.wait() until game:IsLoaded();

        local Players = game:GetService('Players');
        local Player = Players.LocalPlayer;
        local Character = Player.Character or Player.CharacterAdded:Wait();
        local Humanoid = Character:WaitForChild("Humanoid");
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart");

        Player.CharacterAdded:Connect(function(NewCharacter)
            Character = NewCharacter;
            Humanoid = Character:WaitForChild("Humanoid");
            HumanoidRootPart = Character:WaitForChild("HumanoidRootPart");
        end);

        local RNG = Random.new();
        local RaycastParams = RaycastParams.new()  
        RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        RaycastParams.IgnoreWater = true
        
        
        local function isTargetVisible(targetCharacter)
            if not WallCheckEnabled or not targetCharacter or not targetCharacter:FindFirstChild("HumanoidRootPart") then
                return true
            end
            
            local targetHRP = targetCharacter.HumanoidRootPart
            local origin = HumanoidRootPart.Position
            local direction = (targetHRP.Position - origin).Unit
            local distance = (targetHRP.Position - origin).Magnitude
            
           
            local filterList = {Character, targetCharacter}
            RaycastParams.FilterDescendantsInstances = filterList
            
            local rayResult = workspace:Raycast(origin, direction * distance, RaycastParams)
            
           
            if not rayResult then
                return true
            end
            
        
            local hitInstance = rayResult.Instance
            if hitInstance and hitInstance:IsDescendantOf(targetCharacter) then
                return true
            end
            
            
            return false
        end
        
        local function getCharacterRole(character)
            local modelName = character.Name
            if Killers[modelName] then
                return "Killer"
            elseif Survivors[modelName] then
                return "Survivor"
            end
            return "Unknown"
        end
        
        local function findTrackableObjects()
            local objects = {}
            
            if TrackSubspaceTripmine then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj.Name == "SubspaceTripmine" and obj:IsA("Model") and obj.PrimaryPart then
                        table.insert(objects, obj)
                    end
                end
            end
            
            if TrackBuildermanDispenser then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj.Name == "BuildermanDispenser" and obj:IsA("Model") and obj.PrimaryPart then
                        table.insert(objects, obj)
                    end
                end
            end
            
            if TrackBuildermanSentry then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj.Name == "BuildermanSentry" and obj:IsA("Model") and obj.PrimaryPart then
                        table.insert(objects, obj)
                    end
                end
            end
            
            return objects
        end
        
        HeartbeatConnection = game:GetService('RunService').Heartbeat:Connect(function()
            if not HitboxTrackingEnabled or not HumanoidRootPart then
                return;
            end

            local Playing = false;
            for _,v in Humanoid:GetPlayingAnimationTracks() do
                if table.find(AttackAnimations, v.Animation.AnimationId) and (v.TimePosition / v.Length < 0.75) then
                    Playing = true;
                end
            end

            if not Playing then
                return;
            end

            local PlayerRole = getCharacterRole(Character)
            local OppositeTable = nil
            if PlayerRole == "Killer" then
                OppositeTable = Survivors
            elseif PlayerRole == "Survivor" then
                OppositeTable = Killers
            end

            local Target = nil
            local CurrentNearestDist = MaxDistance

            local OppTarget = nil
            local OppNearestDist = MaxDistance

            local function loopForOpp(t)
                for _,v in pairs(t) do
                    if v == Character or not v:FindFirstChild("HumanoidRootPart") or not v:FindFirstChild("Humanoid") then
                        continue
                    end
                    
                 
                    if WallCheckEnabled and not isTargetVisible(v) then
                        continue
                    end
                    
                    local modelName = v.Name
                    if OppositeTable and OppositeTable[modelName] then
                        local Dist = (v.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
                        if Dist < OppNearestDist then
                            OppNearestDist = Dist
                            OppTarget = v
                        end
                    end
                end
            end

            if OppositeTable then
                loopForOpp(workspace.Players:GetDescendants())
                local npcsFolder = workspace.Map:FindFirstChild("NPCs", true)
                if npcsFolder then
                    loopForOpp(npcsFolder:GetChildren())
                end
            end

            local function loopAll(t)
                for _,v in pairs(t) do
                    if v == Character or not v:FindFirstChild("HumanoidRootPart") or not v:FindFirstChild("Humanoid") then
                        continue
                    end
                    
                   
                    if WallCheckEnabled and not isTargetVisible(v) then
                        continue
                    end
                    
                    local characterRole = getCharacterRole(v)
                    
                    if FilterSurvivors and characterRole == "Survivor" then
                        continue
                    end
                    if FilterKillers and characterRole == "Killer" then
                        continue
                    end
                    
                    if PlayerRole == "Killer" and characterRole == "Killer" then
                        continue
                    end
                    if PlayerRole == "Survivor" and characterRole == "Survivor" then
                        continue
                    end
                    
                    local Dist = (v.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
                    if Dist < CurrentNearestDist then
                        CurrentNearestDist = Dist
                        Target = v
                    end
                end
            end

            local trackableObjects = findTrackableObjects()
            local NearestObject = nil
            local NearestObjectDist = MaxDistance
            
            for _, obj in ipairs(trackableObjects) do
                if obj.PrimaryPart then
                    local Dist = (obj.PrimaryPart.Position - HumanoidRootPart.Position).Magnitude
                    if Dist < NearestObjectDist then
                        NearestObjectDist = Dist
                        NearestObject = obj
                    end
                end
            end

            local FinalTarget = nil
            if OppTarget then
                FinalTarget = OppTarget
            elseif NearestObject and NearestObjectDist < CurrentNearestDist then
                FinalTarget = NearestObject
            else
                loopAll(workspace.Players:GetDescendants())
                local npcsFolder2 = workspace.Map:FindFirstChild("NPCs", true)
                if npcsFolder2 then
                    loopAll(npcsFolder2:GetChildren())
                end
                FinalTarget = Target
            end

            if not FinalTarget then
                return;
            end

            local targetPart = FinalTarget:FindFirstChild("HumanoidRootPart") or FinalTarget.PrimaryPart
            if not targetPart then
                return
            end

            local OldVelocity = HumanoidRootPart.Velocity;
            local NeededVelocity =
            (targetPart.Position + Vector3.new(
                RNG:NextNumber(-1.5, 1.5),
                0,
                RNG:NextNumber(-1.5, 1.5)
            ) + (targetPart.Velocity * (Player:GetNetworkPing() * 1.25))
                - HumanoidRootPart.Position
            ) / (Player:GetNetworkPing() * 2);

            HumanoidRootPart.Velocity = NeededVelocity;
            game:GetService('RunService').RenderStepped:Wait();
            HumanoidRootPart.Velocity = OldVelocity;
        end);
    end,
})


local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MVP = Tabs.Sat:AddLeftGroupbox("体力设置")

local StaminaSettings = {
    MaxStamina = 100,
    StaminaGain = 25,
    StaminaLoss = 10,
    SprintSpeed = 28,
    InfiniteGain = 9999
}

local SettingToggles = {
    MaxStamina = false,
    StaminaGain = false,
    StaminaLoss = false,
    SprintSpeed = false
}

local SprintingModule = ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting")
local GetModule = function() return require(SprintingModule) end

task.spawn(function()
    while true do
        local m = GetModule()
        for key, value in pairs(StaminaSettings) do
            if SettingToggles[key] then
                m[key] = value
            end
        end
        task.wait(0.5)
    end
end)

local bai = {Spr = false}
local connection

MVP:AddToggle('MyToggle', {
    Text = '无限体力',
    Default = false,
    Tooltip = '无限体力',
    Callback = function(state)
        bai.Spr = state
        local Sprinting = GetModule()

        if state then
            Sprinting.StaminaLoss = 0
            Sprinting.StaminaGain = StaminaSettings.InfiniteGain

            if connection then connection:Disconnect() end
            connection = RunService.Heartbeat:Connect(function()
                if not bai.Spr then return end
                Sprinting.StaminaLoss = 0
                Sprinting.StaminaGain = StaminaSettings.InfiniteGain
            end)
        else
            Sprinting.StaminaLoss = 10
            Sprinting.StaminaGain = 25

            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end
})

MVP:AddToggle('MaxStaminaToggle', {
    Text = '启用体力调整',
    Default = false,
    Callback = function(Value)
        SettingToggles.MaxStamina = Value
    end
})

MVP:AddToggle('StaminaGainToggle', {
    Text = '启用体力恢复调整',
    Default = false,
    Callback = function(Value)
        SettingToggles.StaminaGain = Value
    end
})

MVP:AddToggle('StaminaLossToggle', {
    Text = '启用体力消耗调整',
    Default = false,
    Callback = function(Value)
        SettingToggles.StaminaLoss = Value
    end
})

MVP:AddToggle('SprintSpeedToggle', {
    Text = '启用奔跑速度调整',
    Default = false,
    Callback = function(Value)
        SettingToggles.SprintSpeed = Value
    end
})

local MVP2 = Tabs.Sat:AddRightGroupbox("调试设置")

MVP2:AddSlider('InfStaminaGainSlider', {
    Text = '无限体力恢复速度',
    Default = 9999,
    Min = 0,
    Max = 10000,
    Rounding = 0,
    Callback = function(Value)
        StaminaSettings.InfiniteGain = Value
        if bai.Spr then
            local Sprinting = GetModule()
            Sprinting.StaminaGain = Value
        end
    end
})

MVP2:AddSlider('MySlider1', {
    Text = '最大体力值',
    Default = 100,
    Min = 0,
    Max = 9999,
    Rounding = 0,
    Callback = function(Value)
        StaminaSettings.MaxStamina = Value
        if SettingToggles.MaxStamina then
            local Sprinting = GetModule()
            Sprinting.MaxStamina = Value
        end
    end
})

MVP2:AddSlider('MySlider2', {
    Text = '体力恢复速度',
    Default = 25,
    Min = 0,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        StaminaSettings.StaminaGain = Value
        if SettingToggles.StaminaGain and not bai.Spr then
            local Sprinting = GetModule()
            Sprinting.StaminaGain = Value
        end
    end
})

MVP2:AddSlider('MySlider3', {
    Text = '体力消耗速度',
    Default = 10,
    Min = 0,
    Max = 800,
    Rounding = 0,
    Callback = function(Value)
        StaminaSettings.StaminaLoss = Value
        if SettingToggles.StaminaLoss and not bai.Spr then
            local Sprinting = GetModule()
            Sprinting.StaminaLoss = Value
        end
    end
})

MVP2:AddSlider('MySlider4', {
    Text = '奔跑速度',
    Default = 28,
    Min = 0,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        StaminaSettings.SprintSpeed = Value
        if SettingToggles.SprintSpeed then
            local Sprinting = GetModule()
            Sprinting.SprintSpeed = Value
        end
    end
})









local Generator = Tabs.zdx:AddLeftGroupbox("自动修机/演戏(事件)")

Generator:AddSlider("RepairSpeed", {
    Text = "修机速度 (s)",
    Default = 4,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Compact = false,
    Callback = function(v)
        _G.CustomSpeed = v
    end
})

Generator:AddToggle("AutoGenerator",{
    Text = "自动修机",
    Default = false,
    Callback = function(v)
        _G.AutoGen = v
        task.spawn(function()
            while _G.AutoGen do
                if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("PuzzleUI") then
                    local delayTime = _G.CustomSpeed or 4
                    
                    wait(delayTime)
                    
                    for _,v in ipairs(workspace["Map"]["Ingame"]["Map"]:GetChildren()) do
                        if v.Name == "Generator" then
                            v["Remotes"]["RE"]:FireServer()
                        end
                    end
                end
                wait()
            end
        end)
    end
})


local RunService = game:GetService("RunService")

local function getDirection(currentRow, currentCol, otherRow, otherCol)
    if otherRow < currentRow then return "up" end
    if otherRow > currentRow then return "down" end
    if otherCol < currentCol then return "left" end
    if otherCol > currentCol then return "right" end
end

local function getConnections(prev, curr, nextnode)
    local connections = {}
    if prev and curr then
        local dir = getDirection(curr.row, curr.col, prev.row, prev.col)
        if dir == "up" then dir = "down"
        elseif dir == "down" then dir = "up"
        elseif dir == "left" then dir = "right"
        elseif dir == "right" then dir = "left" end
        if dir then connections[dir] = true end
    end
    if nextnode and curr then
        local dir = getDirection(curr.row, curr.col, nextnode.row, nextnode.col)
        if dir then connections[dir] = true end
    end
    return connections
end

local function isNeighbourLocal(r1, c1, r2, c2)
    if r2 == r1 - 1 and c2 == c1 then return "up" end
    if r2 == r1 + 1 and c2 == c1 then return "down" end
    if r2 == r1 and c2 == c1 - 1 then return "left" end
    if r2 == r1 and c2 == c1 + 1 then return "right" end
    return false
end

local function coordKey(node)
    return `{node.row}-{node.col}`
end

local function orderPathFromEndpoints(path, endpoints)
    if not path or #path == 0 then return path end
    
    local startEndpoint
    for _, ep in endpoints or {} do
        for _, n in path do
            if n.row == ep.row and n.col == ep.col then
                startEndpoint = { row = ep.row, col = ep.col }
                break
            end
        end
        if startEndpoint then break end
    end
    
    if not startEndpoint then
        local inPath = {}
        for _, n in path do inPath[coordKey(n)] = n end
        
        for _, n in path do
            local neighbours = 0
            local dirs = { { n.row - 1, n.col }, { n.row + 1, n.col }, { n.row, n.col - 1 }, { n.row, n.col + 1 } }
            for _, dir in dirs do
                local r, c = dir[1], dir[2]
                if inPath[`{r}-{c}`] then neighbours += 1 end
            end
            if neighbours == 1 then
                startEndpoint = { row = n.row, col = n.col }
                break
            end
        end
    end
    
    if not startEndpoint then
        startEndpoint = { row = path[1].row, col = path[1].col }
    end
    
    local remaining = {}
    for _, n in path do remaining[coordKey(n)] = { row = n.row, col = n.col } end
    
    local ordered = {}
    local current = { row = startEndpoint.row, col = startEndpoint.col }
    table.insert(ordered, table.clone(current))
    remaining[coordKey(current)] = nil
    
    while true do
        local _size = 0
        for _ in remaining do _size += 1 end
        if not (_size > 0) then break end
        
        local foundNext = false
        for key, node in remaining do
            local _value = isNeighbourLocal(current.row, current.col, node.row, node.col)
            if _value then
                table.insert(ordered, table.clone(node))
                remaining[key] = nil
                current = node
                foundNext = true
                break
            end
        end
        if not foundNext then return path end
    end
    return ordered
end

local HintSystem = {}
do
    function HintSystem:DrawSolutionOneByOne(puzzle, delayTime)
        delayTime = delayTime or 0.05
        if not puzzle or not puzzle.Solution then return end
        
        local lastUpdate = tick()
        local updateInterval = 0.1
        local batchSize = 3
        
        local totalPaths = #puzzle.Solution
        local indices = {}
        for i = 1, totalPaths do table.insert(indices, i) end
        
        for i = totalPaths, 2, -1 do
            local j = math.random(i)
            indices[i], indices[j] = indices[j], indices[i]
        end
        
        for _, colorIndex in indices do
            local path = puzzle.Solution[colorIndex]
            local endpoints = puzzle.targetPairs[colorIndex]
            local orderedPath = orderPathFromEndpoints(path, endpoints)
            puzzle.paths[colorIndex] = {}
            
            local batchNodes = {}
            
            for i = 0, #orderedPath - 1 do
                local node = orderedPath[i + 1]
                table.insert(puzzle.paths[colorIndex], { row = node.row, col = node.col })
                local prev = orderedPath[i]
                local nextNode = orderedPath[i + 2]
                local conn = getConnections(prev, node, nextNode)
                
                puzzle.gridConnections = puzzle.gridConnections or {}
                puzzle.gridConnections[`{node.row}-{node.col}`] = conn
                
                table.insert(batchNodes, node)
                
                if #batchNodes >= batchSize or i == #orderedPath - 1 then
                    local currentTime = tick()
                    if currentTime - lastUpdate >= updateInterval then
                        puzzle:updateGui()
                        lastUpdate = currentTime
                        RunService.Heartbeat:Wait()
                        task.wait(delayTime * 0.5)
                    end
                    batchNodes = {}
                else
                    if delayTime > 0 then task.wait(delayTime * 0.3) end
                end
            end
            
            puzzle:checkForWin()
            
            if delayTime > 0 then task.wait(delayTime * 2) end
        end
        
        puzzle:updateGui()
        puzzle:checkForWin()
    end
end

local LeftGroupBox = Tabs.zdx:AddLeftGroupbox("自动连线修机")

local AutoConnectEnabled = false
local ConnectionSpeed = 0.05

LeftGroupBox:AddToggle("AutoConnectToggle", {
    Text = "启用自动连接",
    Default = false,
    Callback = function(Value)
        AutoConnectEnabled = Value
        print("自动连接:", Value)
    end,
})

LeftGroupBox:AddSlider("ConnectionSpeed", {
    Text = "连接速度",
    Default = 0.05,
    Min = 0.001,
    Max = 0.2,
    Rounding = 3,
    Compact = false,
    Callback = function(Value)
        ConnectionSpeed = Value
        print("连接速度:", Value)
    end,
    Tooltip = "值越小速度越快",
})

local _result = ReplicatedStorage:WaitForChild("Modules"):FindFirstChild("Misc")
if _result then
    _result = _result:FindFirstChild("FlowGameManager")
    if _result then
        _result = _result:FindFirstChild("FlowGame")
    end
end
local bb = _result
if bb then
    local FlowGameModule = require(bb)
    local old = FlowGameModule.new
    FlowGameModule.new = function(...)
        local args = { ... }
        local output = { old(unpack(args)) }
        local puzzle = output[1]
        task.spawn(function()
            if puzzle and puzzle.Solution and AutoConnectEnabled then
            
                local startTime = tick()
                while AutoConnectEnabled and tick() - startTime < 10 do 
                    if Players.LocalPlayer.PlayerGui:FindFirstChild("PuzzleUI") then
                        local totalNodes = 0
                        for _, path in ipairs(puzzle.Solution) do
                            totalNodes += #path
                        end
                        local delayTime = ConnectionSpeed
                        HintSystem:DrawSolutionOneByOne(puzzle, delayTime)
                        break
                    end
                    task.wait(0.2) 
                end
            end
        end)
        return puzzle
    end
end



local KillerSurvival = Tabs.zdx:AddRightGroupbox('传送修机[危险]')

KillerSurvival:AddToggle("AutoFix", {
    Text = "自动发电机农场",
    Default = false,
    Callback = function(enabled)
        local threadId = tostring(math.random(1, 99999))
        _G.AutoFixThreadId = threadId
        
        local function shouldContinue()
            return _G.AutoFixThreadId == threadId and enabled
        end
        
        -- 检查是否所有发电机进度都达到100%
        local function allGeneratorsCompleted()
            local allCompleted = true
            local anyGeneratorFound = false
            
            for _, v in ipairs(workspace.Map.Ingame.Map:GetChildren()) do
                if v.Name == "Generator" and v:FindFirstChild("Progress") then
                    anyGeneratorFound = true
                    if v.Progress.Value < 100 then
                        allCompleted = false
                        break
                    end
                end
            end
            
            -- 如果没有找到任何发电机，也返回true（没有需要修理的发电机）
            return allCompleted or not anyGeneratorFound
        end
        
        -- 使用事件进行修理
        local function repairGenerator(generator)
            pcall(function()
                generator.Remotes.RE:FireServer()
            end)
        end

        -- 使用ProximityPrompt互动（用于进入和离开）
        local function promptInteract(generator)
            local prompts = {}
            for _, prompt in ipairs(generator:GetDescendants()) do
                if prompt.ClassName == "ProximityPrompt" then
                    table.insert(prompts, prompt)
                end
            end
            
            for _, prompt in ipairs(prompts) do
                pcall(function()
                    fireproximityprompt(prompt)
                end)
            end
        end
        
        local function runGenerator()
            while shouldContinue() do
                -- 检查是否所有发电机都已完成
                if allGeneratorsCompleted() then
                    -- 所有发电机都100%，停止运行
                    break
                end
                
                -- 获取所有未完成的发电机（进度<100）
                local generators = {}
                for _, v in ipairs(workspace.Map.Ingame.Map:GetChildren()) do
                    if v.Name == "Generator" and v:FindFirstChild("Progress") and v.Progress.Value < 100 then
                        table.insert(generators, v)
                    end
                end
                
                -- 如果没有未完成的发电机，也停止
                if #generators == 0 then
                    break
                end
                
                for _, generator in ipairs(generators) do
                    if not shouldContinue() then break end
                    
                    -- 在处理每个发电机前再次检查是否所有发电机已完成
                    if allGeneratorsCompleted() then
                        break
                    end
                    
                    local char = game.Players.LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        -- 传送
                        local startTP = tick()
                        
                        -- 寻找传送点
                        local bestPos, minDist = nil, math.huge
                        if generator:FindFirstChild("Positions") then
                            for _, pos in ipairs(generator.Positions:GetChildren()) do
                                local dist = (char.HumanoidRootPart.Position - pos.Position).Magnitude
                                if dist < minDist then
                                    bestPos = pos
                                    minDist = dist
                                end
                            end
                            
                            if bestPos then
                                char.HumanoidRootPart.CFrame = bestPos.CFrame * CFrame.new(0, 0, -1.2)
                            end
                        end
                        
                        -- 等待传送完成
                        local elapsed = tick() - startTP
                        if elapsed < 0.17 then
                            task.wait(0.17 - elapsed)
                        end
                        
                        -- 进入发电机
                        promptInteract(generator)
                        task.wait(0.00001)
                        
                        -- 修理发电机
                        repairGenerator(generator)
                        task.wait(0.1)
                        
                        -- 离开发电机
                        promptInteract(generator)
                        
                        -- 电机间间隔
                        task.wait(0.000000000000001)
                    end
                end
                
                if shouldContinue() then
                    task.wait(0.000000000000000001)
                end
            end
            
            -- 循环结束时的清理
            if _G.AutoFixThreadId == threadId then
                enabled = false
            end
        end

        if enabled then
            if _G.AutoFixThread then
                _G.AutoFixThreadId = tostring(math.random(1, 99999))
                task.cancel(_G.AutoFixThread)
            end
            _G.AutoFixThread = task.spawn(runGenerator)
        else
            _G.AutoFixThreadId = tostring(math.random(1, 99999))
            if _G.AutoFixThread then
                task.cancel(_G.AutoFixThread)
                _G.AutoFixThread = nil
            end
        end
    end
})

KillerSurvival:AddButton({
    Text = '传送到发电机',
    Func = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        local generators = workspace.Map.Ingame.Map:GetChildren()
        for _, generator in ipairs(generators) do
            if generator.Name == "Generator" and 
               generator:FindFirstChild("Progress") and 
               generator.Progress.Value < 100 then
                
                local generatorPart = generator:FindFirstChild("Main") or  
                                     generator:FindFirstChild("Model") or
                                     generator:FindFirstChild("Base")
                
                if generatorPart then
                    character.HumanoidRootPart.CFrame = generatorPart.CFrame + Vector3.new(0, 3, 0)
                    return  
                end
            end
        end
        warn("没有找到可修理的发电机")
    end
})




local ZZ = Tabs.zdx:AddRightGroupbox('切换服务器')

ZZ:AddButton({
    Text = "Switching server", 
    Func = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local HttpService = game:GetService("HttpService")
        
        local requestFunc = http_request or syn.request or request
        if not requestFunc then return end
            
        local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local response = requestFunc({Url = url, Method = "GET"})
        
        if response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            if data and data.data and #data.data > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, data.data[math.random(1, #data.data)].id, Players.LocalPlayer)
            end
        end
    end
})
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local MapFolder = Workspace:WaitForChild("Map"):WaitForChild("Ingame")

local Settings = {
	Advanced = { Enabled = false, OutlineOnly = true, ShowNametag = false, Color = Color3.fromRGB(0, 255, 255) }
}


local VisualTabBox = Tabs.Esp:AddLeftTabbox()
local KillerGroup = VisualTabBox:AddTab("杀手")
local SurvivorGroup = VisualTabBox:AddTab("幸存者")
local AdvancedVisualGroup = VisualTabBox:AddTab("技能")

local ObjectTabBox = Tabs.Esp:AddRightTabbox()
local ItemGroup = ObjectTabBox:AddTab("物品")
local SpecialGroup = ObjectTabBox:AddTab("特殊")
local TracerGroup = ObjectTabBox:AddTab("追踪线")

-- 杀手ESP设置
KillerGroup:AddToggle("KillerESP", {
    Text = "启用杀手透视",
    Default = false,
    Callback = function(Value)
        ESPSettings.killerESP = Value
    end,
})

KillerGroup:AddToggle("KillerTracers", {
    Text = "杀手追踪线",
    Default = false,
    Callback = function(Value)
        ESPSettings.killerTracers = Value
    end,
})

KillerGroup:AddToggle("KillerNameESP", {
    Text = "显示杀手名称",
    Default = true,
    Callback = function(Value)
        ESPSettings.killerNameESP = Value
        UpdateAllPlayerESPText()
    end,
})

KillerGroup:AddToggle("KillerHealthESP", {
    Text = "显示杀手血量",
    Default = true,
    Callback = function(Value)
        ESPSettings.killerHealthESP = Value
        UpdateAllPlayerESPText()
    end,
})

KillerGroup:AddToggle("KillerSkinESP", {
    Text = "显示杀手皮肤",
    Default = false,
    Callback = function(Value)
        ESPSettings.killerSkinESP = Value
        UpdateAllPlayerESPText()
    end,
})

KillerGroup:AddSlider("KillerFillTransparency", {
    Text = "填充透明度",
    Default = 0.7,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = false,
    Callback = function(Value)
        ESPSettings.killerFillTransparency = Value
        UpdateAllPlayerESPText()
    end,
})

KillerGroup:AddSlider("KillerOutlineTransparency", {
    Text = "轮廓透明度",
    Default = 0.3,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = false,
    Callback = function(Value)
        ESPSettings.killerOutlineTransparency = Value
        UpdateAllPlayerESPText()
    end,
})

KillerGroup:AddLabel("杀手颜色"):AddColorPicker("KillerColor", {
    Default = ESPSettings.killerColor,
    Title = "杀手透视颜色",
    Callback = function(Value)
        ESPSettings.killerColor = Value
    end,
})

-- 幸存者ESP设置
SurvivorGroup:AddToggle("SurvivorESP", {
    Text = "启用幸存者透视",
    Default = false,
    Callback = function(Value)
        ESPSettings.playerESP = Value
    end,
})

SurvivorGroup:AddToggle("SurvivorTracers", {
    Text = "幸存者追踪线",
    Default = false,
    Callback = function(Value)
        ESPSettings.survivorTracers = Value
    end,
})

SurvivorGroup:AddToggle("SurvivorNameESP", {
    Text = "显示幸存者名称",
    Default = true,
    Callback = function(Value)
        ESPSettings.survivorNameESP = Value
        UpdateAllPlayerESPText()
    end,
})

SurvivorGroup:AddToggle("SurvivorHealthESP", {
    Text = "显示幸存者血量",
    Default = true,
    Callback = function(Value)
        ESPSettings.survivorHealthESP = Value
        UpdateAllPlayerESPText()
    end,
})

SurvivorGroup:AddToggle("SurvivorSkinESP", {
    Text = "显示幸存者皮肤",
    Default = false,
    Callback = function(Value)
        ESPSettings.survivorSkinESP = Value
        UpdateAllPlayerESPText()
    end,
})

SurvivorGroup:AddSlider("SurvivorFillTransparency", {
    Text = "填充透明度",
    Default = 0.7,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = false,
    Callback = function(Value)
        ESPSettings.survivorFillTransparency = Value
        UpdateAllPlayerESPText()
    end,
})

SurvivorGroup:AddSlider("SurvivorOutlineTransparency", {
    Text = "轮廓透明度",
    Default = 0.3,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = false,
    Callback = function(Value)
        ESPSettings.survivorOutlineTransparency = Value
        UpdateAllPlayerESPText()
    end,
})

SurvivorGroup:AddLabel("幸存者颜色"):AddColorPicker("SurvivorColor", {
    Default = ESPSettings.survivorColor,
    Title = "幸存者透视颜色",
    Callback = function(Value)
        ESPSettings.survivorColor = Value
    end,
})

-- 物品ESP设置
ItemGroup:AddToggle("GeneratorESP", {
    Text = "发电机透视",
    Default = false,
    Callback = function(value)
        ESPSettings.generatorESP = value
    end,
}):AddColorPicker("GeneratorColor", {
    Default = ESPSettings.generatorColor,
    Title = "发电机颜色",
    Callback = function(value)
        ESPSettings.generatorColor = value
    end,
})

ItemGroup:AddToggle("ItemESP", {
    Text = "物品透视",
    Default = false,
    Callback = function(value)
        ESPSettings.itemESP = value
    end,
}):AddColorPicker("ItemColor", {
    Default = ESPSettings.itemColor,
    Title = "物品颜色",
    Callback = function(value)
        ESPSettings.itemColor = value
    end,
})

ItemGroup:AddToggle("PizzaESP", {
    Text = "披萨透视",
    Default = false,
    Callback = function(value)
        ESPSettings.pizzaEsp = value
    end,
}):AddColorPicker("PizzaColor", {
    Default = ESPSettings.pizzaColor,
    Title = "披萨颜色",
    Callback = function(value)
        ESPSettings.pizzaColor = value
    end,
})

ItemGroup:AddToggle("TaphTripwireESP", {
    Text = "绊线透视",
    Default = false,
    Callback = function(value)
        ESPSettings.taphTripwireEsp = value
    end,
}):AddColorPicker("TaphTripwireColor", {
    Default = ESPSettings.taphTripwireColor,
    Title = "绊线颜色",
    Callback = function(value)
        ESPSettings.taphTripwireColor = value
    end,
})

ItemGroup:AddToggle("TripMineESP", {
    Text = "地雷透视",
    Default = false,
    Callback = function(value)
        ESPSettings.tripMineEsp = value
    end,
}):AddColorPicker("TripMineColor", {
    Default = ESPSettings.tripMineColor,
    Title = "地雷颜色",
    Callback = function(value)
        ESPSettings.tripMineColor = value
    end,
})

ItemGroup:AddToggle("TwoTimeRespawnESP", {
    Text = "重生点透视",
    Default = false,
    Callback = function(value)
        ESPSettings.twoTimeRespawnEsp = value
    end,
}):AddColorPicker("TwoTimeRespawnColor", {
    Default = ESPSettings.twoTimeRespawnColor,
    Title = "重生点颜色",
    Callback = function(value)
        ESPSettings.twoTimeRespawnColor = value
    end,
})

ItemGroup:AddToggle("GraffitiESP", {
    Text = "涂鸦透视",
    Default = false,
    Callback = function(value)
        ESPSettings.graffitiEsp = value
    end,
}):AddColorPicker("GraffitiColor", {
    Default = ESPSettings.graffitiColor,
    Title = "涂鸦颜色",
    Callback = function(value)
        ESPSettings.graffitiColor = value
    end,
})

ItemGroup:AddToggle("SukkarsESP", {
    Text = "姜饼透视",
    Default = false,
    Callback = function(value)
        ESPSettings.sukkarsEsp = value
    end,
}):AddColorPicker("SukkarsColor", {
    Default = ESPSettings.sukkarsColor,
    Title = "姜饼颜色",
    Callback = function(value)
        ESPSettings.sukkarsColor = value
    end,
})

-- 特殊ESP设置
SpecialGroup:AddToggle("PizzaDeliveryESP", {
    Text = "披萨送货员透视",
    Default = false,
    Callback = function(value)
        ESPSettings.pizzaDeliveryEsp = value
    end,
}):AddColorPicker("PizzaDeliveryColor", {
    Default = ESPSettings.pizzaDeliveryColor,
    Title = "送货员颜色",
    Callback = function(value)
        ESPSettings.pizzaDeliveryColor = value
    end,
})

SpecialGroup:AddToggle("ZombieESP", {
    Text = "僵尸透视",
    Default = false,
    Callback = function(value)
        ESPSettings.zombieEsp = value
    end,
}):AddColorPicker("ZombieColor", {
    Default = ESPSettings.zombieColor,
    Title = "僵尸颜色",
    Callback = function(value)
        ESPSettings.zombieColor = value
    end,
})

-- 追踪线设置
TracerGroup:AddToggle("GeneratorTracers", {
    Text = "发电机追踪线",
    Default = false,
    Callback = function(value)
        ESPSettings.generatorTracers = value
    end,
})

TracerGroup:AddToggle("ItemTracers", {
    Text = "物品追踪线",
    Default = false,
    Callback = function(value)
        ESPSettings.itemTracers = value
    end,
})

TracerGroup:AddToggle("PizzaTracers", {
    Text = "披萨追踪线",
    Default = false,
    Callback = function(value)
        ESPSettings.pizzaTracers = value
    end,
})

TracerGroup:AddToggle("PizzaDeliveryTracers", {
    Text = "送货员追踪线",
    Default = false,
    Callback = function(value)
        ESPSettings.pizzaDeliveryTracers = value
    end,
})

TracerGroup:AddToggle("ZombieTracers", {
    Text = "僵尸追踪线",
    Default = false,
    Callback = function(value)
        ESPSettings.zombieTracers = value
    end,
})

TracerGroup:AddToggle("TaphTripwireTracers", {
    Text = "绊线追踪线",
    Default = false,
    Callback = function(value)
        ESPSettings.taphTripwireTracers = value
    end,
})

TracerGroup:AddToggle("TripMineTracers", {
    Text = "地雷追踪线",
    Default = false,
    Callback = function(value)
        ESPSettings.tripMineTracers = value
    end,
})

TracerGroup:AddToggle("TwoTimeRespawnTracers", {
    Text = "重生点追踪线",
    Default = false,
    Callback = function(value)
        ESPSettings.twoTimeRespawnTracers = value
    end,
})

-- 高级透视设置
AdvancedVisualGroup:AddToggle("AdvancedESP", {
    Text = "启用",
    Default = false,
    Callback = function(Value)
        AdvancedSettings.Enabled = Value
    end,
})

AdvancedVisualGroup:AddToggle("AdvancedOutline", {
    Text = "仅显示轮廓",
    Default = true,
    Callback = function(Value)
        AdvancedSettings.OutlineOnly = Value
    end,
})

AdvancedVisualGroup:AddToggle("AdvancedNametag", {
    Text = "显示名称标签",
    Default = false,
    Callback = function(Value)
        AdvancedSettings.ShowNametag = Value
    end,
})

AdvancedVisualGroup:AddLabel("高级颜色"):AddColorPicker("AdvancedColor", {
    Default = AdvancedSettings.Color,
    Title = "高级颜色",
    Callback = function(Value)
        AdvancedSettings.Color = Value
    end,
})

AdvancedVisualGroup:AddToggle("NST", {
    Text = "地雷生成提示",
    Default = false,
    Callback = function(v)
        if not _G.NSTData then
            _G.NSTData = {
                connection = nil
            }
        end
        local data = _G.NSTData
        if data.connection then
            data.connection:Disconnect()
            data.connection = nil
        end
        if v then
            data.connection = workspace.Map.Ingame.DescendantAdded:Connect(function(v)
                if v.Name == "SubspaceTripmine" then
                    Library:Notify("地雷已生成！")
                end
            end)
        end
    end
})

AdvancedVisualGroup:AddToggle("NEK", {
    Text = "实体生成提示",
    Default = false,
    Callback = function(v)
        if not _G.NEKData then
            _G.NEKData = {
                connection = nil
            }
        end
        local data = _G.NEKData
        if data.connection then
            data.connection:Disconnect()
            data.connection = nil
        end
        if v then
            data.connection = workspace.DescendantAdded:Connect(function(v)
                if v:IsA("Model") and (v.Name == "PizzaDeliveryRig" or v.Name == "Mafia1" or v.Name == "Mafia2" or v.Name == "Mafia3" or v.Name == "Mafia4") then
                    Library:Notify("实体 '" .. v.Name .. "' 已生成！")
                elseif v:IsA("Model") and v.Name == "1x1x1x1Zombie" then
                    Library:Notify("僵尸已生成！")
                end
            end)
        end
    end
})



local v437 = Tabs.ani:AddLeftGroupbox("通用反效果")





v437:AddToggle("AntiBlindness", {
    Text = "反致盲",
    Default = false,
    Callback = function()
        task.spawn(function()
            while Toggles.AntiBlindness.Value and task.wait() do
                if game.Lighting:FindFirstChild("BlindnessBlur") then
                    game.Lighting.BlindnessBlur:Destroy()
                end
            end
        end)
    end
})
v437:AddToggle("AntiSubspace", {
    Text = "反子空间爆炸",
    Default = false,
    Callback = function()
        task.spawn(function()
            while Toggles.AntiSubspace.Value and task.wait() do
                for _, v447 in pairs({"SubspaceVFXBlur", "SubspaceVFXColorCorrection"}) do
                    if game.Lighting:FindFirstChild(v447) then
                        game.Lighting[v447]:Destroy()
                    end
                end
            end
        end)
    end
})


local ZZ2 = Tabs.ani:AddRightGroupbox('NOOB 反效果')

ZZ2:AddToggle("RemoveSlateskin", {
    Text = "反Noob石板速度", 
    Default = false,
    Callback = function(v)
        if not _G.SlateskinCleanup then _G.SlateskinCleanup = {} end
        local connections = _G.SlateskinCleanup

        for _, conn in pairs(connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        _G.SlateskinCleanup = {}

        if not v then return end

        local function CleanSlateskins()
            local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
            if not survivorsFolder then return end
            
            local survivorList = survivorsFolder:GetChildren()
            for i = 1, #survivorList, 5 do
                task.spawn(function()
                    for j = i, math.min(i + 4, #survivorList) do
                        local survivor = survivorList[j]
                        local slateskin = survivor:FindFirstChild("SlateskinStatus")
                        if slateskin then
                            slateskin:Destroy()
                        end
                    end
                end)
            end
        end

        task.spawn(CleanSlateskins)

        connections.heartbeat = game:GetService("RunService").Heartbeat:Connect(function()
            task.wait(2)
            CleanSlateskins()
        end)

        local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
        if survivorsFolder then
            connections.descendantAdded = survivorsFolder.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "SlateskinStatus" then
                    descendant:Destroy()
                end
            end)
        end
    end
})




local Disabled = Tabs.ani:AddLeftGroupbox('访客反效果')

Disabled:AddToggle("RemoveSlowed", {
    Text = "反缓慢", 
    Default = false,
    Callback = function(v)
        if not _G.SlowedCleanup then _G.SlowedCleanup = {} end
        local connections = _G.SlowedCleanup

        for _, conn in pairs(connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        _G.SlowedCleanup = {}

        if not v then return end

        local function CleanSlowedStatuses()
            local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
            if not survivorsFolder then return end
            
            for _, survivor in ipairs(survivorsFolder:GetDescendants()) do
                if survivor.Name == "SlowedStatus" then
                    survivor:Destroy()
                end
            end
        end

        task.spawn(CleanSlowedStatuses)

        connections.heartbeat = game:GetService("RunService").Heartbeat:Connect(function()
            task.wait(1.5)
            CleanSlowedStatuses()
        end)

        local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
        if survivorsFolder then
            connections.descendantAdded = survivorsFolder.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "SlowedStatus" then
                    descendant:Destroy()
                end
            end)
        end
    end
})

Disabled:AddToggle("RemoveBlockingSlow", {
    Text = "反格挡速度", 
    Default = false,
    Callback = function(v)
        if not _G.BlockingCleanup then _G.BlockingCleanup = {} end
        local connections = _G.BlockingCleanup

        for _, conn in pairs(connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        _G.BlockingCleanup = {}

        if not v then return end

        local function CleanStatuses()
            local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
            if not survivorsFolder then return end
            
            for _, survivor in ipairs(survivorsFolder:GetDescendants()) do
                if survivor.Name == "ResistanceStatus" or survivor.Name == "GuestBlocking" then
                    survivor:Destroy()
                end
            end
        end

        task.spawn(CleanStatuses)

        connections.heartbeat = game:GetService("RunService").Heartbeat:Connect(function()
            task.wait(1.5)
            CleanStatuses()
        end)

        local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
        if survivorsFolder then
            connections.descendantAdded = survivorsFolder.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "ResistanceStatus" or descendant.Name == "GuestBlocking" then
                    descendant:Destroy()
                end
            end)
        end
    end
})

Disabled:AddToggle("RemovePunchSlow", {
    Text = "反拳击速度", 
    Default = false,
    Callback = function(v)
        if not _G.PunchCleanup then _G.PunchCleanup = {} end
        local connections = _G.PunchCleanup

        for _, conn in pairs(connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        _G.PunchCleanup = {}

        if not v then return end

        local function CleanStatuses()
            local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
            if not survivorsFolder then return end
            
            for _, survivor in ipairs(survivorsFolder:GetDescendants()) do
                if survivor.Name == "ResistanceStatus" or survivor.Name == "PunchAbility" then
                    survivor:Destroy()
                end
            end
        end

        task.spawn(CleanStatuses)

        connections.heartbeat = game:GetService("RunService").Heartbeat:Connect(function()
            task.wait(1.5)
            CleanStatuses()
        end)

        local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
        if survivorsFolder then
            connections.descendantAdded = survivorsFolder.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "ResistanceStatus" or descendant.Name == "PunchAbility" then
                    descendant:Destroy()
                end
            end)
        end
    end
})

Disabled:AddToggle("RemoveChargeEnded", {
    Text = "反冲刺结束后效果", 
    Default = false,
    Callback = function(v)
        if not _G.ChargeEndedCleanup then _G.ChargeEndedCleanup = {} end
        local connections = _G.ChargeEndedCleanup

        for _, conn in pairs(connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        _G.ChargeEndedCleanup = {}

        if not v then return end

        local function CleanChargeEndedEffects()
            local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
            if not survivorsFolder then return end
            
            for _, survivor in ipairs(survivorsFolder:GetDescendants()) do
                if survivor.Name == "GuestChargeEnded" then
                    survivor:Destroy()
                end
            end
        end

        task.spawn(CleanChargeEndedEffects)

        connections.heartbeat = game:GetService("RunService").Heartbeat:Connect(function()
            task.wait(1.5)
            CleanChargeEndedEffects()
        end)

        local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
        if survivorsFolder then
            connections.descendantAdded = survivorsFolder.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "GuestChargeEnded" then
                    descendant:Destroy()
                end
            end)
        end
    end
})









local LeftGroupBox = Tabs.ani:AddRightGroupbox("c00lkidd")

if not getgenv().originalNamecall then
	getgenv().HookRules = {}
	getgenv().originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
		local method = getnamecallmethod()
		local args = {...}
		if method == "FireServer" then
			for _, rule in ipairs(getgenv().HookRules) do
				if (not rule.remoteName or self.Name == rule.remoteName) then
					if not rule.blockedFirstArg or args[1] == rule.blockedFirstArg then
						if rule.block then
							return
						end
					end
				end
			end
		end
		return getgenv().originalNamecall(self, ...)
	end)
end

getgenv().activateRemoteHook = function(remoteName, blockedFirstArg)
	for _, rule in ipairs(getgenv().HookRules) do
		if rule.remoteName == remoteName and rule.blockedFirstArg == blockedFirstArg then
			return
		end
	end
	table.insert(getgenv().HookRules, {
		remoteName = remoteName,
		blockedFirstArg = blockedFirstArg,
		block = true
	})
end

getgenv().deactivateRemoteHook = function(remoteName, blockedFirstArg)
	for i, rule in ipairs(getgenv().HookRules) do
		if rule.remoteName == remoteName and rule.blockedFirstArg == blockedFirstArg then
			table.remove(getgenv().HookRules, i)
			break
		end
	end
end

getgenv().EnableC00lkidd = function()
	getgenv().activateRemoteHook("RemoteEvent", game.Players.LocalPlayer.Name .. "C00lkiddCollision")
end

getgenv().DisableC00lkidd = function()
	getgenv().deactivateRemoteHook("RemoteEvent", game.Players.LocalPlayer.Name .. "C00lkiddCollision")
end

local globalEnv = getgenv()
globalEnv.Players = game:GetService("Players")
globalEnv.RunService = game:GetService("RunService")
globalEnv.Camera = workspace.CurrentCamera
globalEnv.Player = globalEnv.Players.LocalPlayer
globalEnv.walkSpeed = 100
globalEnv.toggle = false
globalEnv.connection = nil

function globalEnv.getCharacter()
	return globalEnv.Player.Character or globalEnv.Player.CharacterAdded:Wait()
end

function globalEnv.onHeartbeat()
	local player = globalEnv.Player
	local character = globalEnv.getCharacter()
	if character.Name ~= "c00lkidd" then return end
	local char = globalEnv.getCharacter()
	local rootPart = char:FindFirstChild("HumanoidRootPart")
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	local lv = rootPart and rootPart:FindFirstChild("LinearVelocity")
	if not rootPart or not humanoid or not lv then return end
	if lv then
		lv.VectorVelocity = Vector3.new(math.huge, math.huge, math.huge)
		lv.Enabled = false
	end
	local stopMovement = false
	local validValues = {
		Timeout = true,
		Collide = true,
		Hit = true
	}
	local function watchResult(result)
		local function checkValue()
			if validValues[result.Value] then
				stopMovement = true
			end
		end
		checkValue()
		result:GetPropertyChangedSignal("Value"):Connect(checkValue)
	end
	local function onCharacterAdded(character)
		local result = character:FindFirstChild("Result")
		if result and result:IsA("StringValue") then
			watchResult(result)
		end
		character.ChildAdded:Connect(function(child)
			if child.Name == "Result" and child:IsA("StringValue") then
				watchResult(child)
			end
		end)
	end
	player.CharacterAdded:Connect(onCharacterAdded)
	if player.Character then
		onCharacterAdded(player.Character)
	end
	if not stopMovement then
		local lookVector = globalEnv.Camera.CFrame.LookVector
		local moveDir = Vector3.new(lookVector.X, 0, lookVector.Z)
		if moveDir.Magnitude > 0 then
			moveDir = moveDir.Unit
			rootPart.Velocity = Vector3.new(moveDir.X * globalEnv.walkSpeed, rootPart.Velocity.Y, moveDir.Z * globalEnv.walkSpeed)
			rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + moveDir)
		end
	end
end



LeftGroupBox:AddToggle("WalkspeedOverrideController", {
	Text = "自由移动(锁定视角)",
	Tooltip = "启用速度覆盖控制器",
	Default = false,
	Callback = function(value)
		if value then
			globalEnv.connection = globalEnv.RunService.Heartbeat:Connect(globalEnv.onHeartbeat)
		else
			if globalEnv.connection then
				globalEnv.connection:Disconnect()
			end
		end
	end,
})

LeftGroupBox:AddToggle("IgnoreObjectables", {
	Text = "无视碰撞物体",
	Tooltip = "启用无视碰撞",
	Default = false,
	Callback = function(Value)
		if Value then
			getgenv().EnableC00lkidd()
		else
			getgenv().DisableC00lkidd()
		end
	end
})














local ZZ = Tabs.ani:AddRightGroupbox('1x4')local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local AutoPopup = {
    Enabled = false,
    Task = nil,
    Connections = {},
    Interval = 0.5
}

local function deletePopups()
    if not LocalPlayer or not LocalPlayer:FindFirstChild("PlayerGui") then
        return false
    end
    
    local tempUI = LocalPlayer.PlayerGui:FindFirstChild("TemporaryUI")
    if not tempUI then
        return false
    end
    
    local deleted = false
    for _, popup in ipairs(tempUI:GetChildren()) do
        if popup.Name == "1x1x1x1Popup" then
            popup:Destroy()
            deleted = true
        end
    end
    return deleted
end

local function triggerEntangled()
    pcall(function()
        ReplicatedStorage.Modules.Network.Network.RemoteEvent:FireServer("Entangled", {})
    end)
end

local function setupPopupListener()
    if not LocalPlayer or not LocalPlayer:FindFirstChild("PlayerGui") then return end
    
    local tempUI = LocalPlayer.PlayerGui:FindFirstChild("TemporaryUI")
    if not tempUI then
        tempUI = Instance.new("Folder")
        tempUI.Name = "TemporaryUI"
        tempUI.Parent = LocalPlayer.PlayerGui
    end
    
    if AutoPopup.Connections.ChildAdded then
        AutoPopup.Connections.ChildAdded:Disconnect()
    end
    
    AutoPopup.Connections.ChildAdded = tempUI.ChildAdded:Connect(function(child)
        if AutoPopup.Enabled and child.Name == "1x1x1x1Popup" then
            task.defer(function()
                child:Destroy()
                triggerEntangled()
            end)
        end
    end)
end

local function runMainTask()
    while AutoPopup.Enabled do
        deletePopups()
        task.wait(AutoPopup.Interval)
    end
end

local function startAutoPopup()
    if AutoPopup.Enabled then return end
    
    AutoPopup.Enabled = true
    setupPopupListener()
    
    if AutoPopup.Task then
        task.cancel(AutoPopup.Task)
    end
    AutoPopup.Task = task.spawn(runMainTask)
end

local function stopAutoPopup()
    if not AutoPopup.Enabled then return end
    
    AutoPopup.Enabled = false
    
    if AutoPopup.Task then
        task.cancel(AutoPopup.Task)
        AutoPopup.Task = nil
    end
    
    for _, connection in pairs(AutoPopup.Connections) do
        connection:Disconnect()
    end
    AutoPopup.Connections = {}
end

ZZ:AddSlider('AutoPopupInterval', {
    Text = '执行间隔(s)',
    Default = 0.5,
    Min = 0.5,
    Max = 2,
    Rounding = 0,
    Tooltip = '设置自动执行的间隔时间(1-5秒)',
    Callback = function(value)
        AutoPopup.Interval = value
    end
})

ZZ:AddToggle('AutoPopupCheckBox', {
    Text = '反弹窗',
    Default = false,
    Tooltip = '去除弹窗和懒惰效果',
    Callback = function(state)
        if state then
            startAutoPopup()
        else
            stopAutoPopup()
        end
    end
})

if LocalPlayer then
    LocalPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
        if not LocalPlayer.Parent then
            stopAutoPopup()
        end
    end)
end



local NoliGroup = Tabs.ani:AddLeftGroupbox("Noli")



local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer

local noliDeleterActive = false
local deletionConnection = nil
local allowedNoli = nil
local isVoidRushCrashed = false
local characterCheckLoop = nil

local function deleteNewNoli()
    local killers = workspace:WaitForChild("Players"):WaitForChild("Killers")
    
    allowedNoli = killers:FindFirstChild("Noli")
    if not allowedNoli then
        return
    end
    
    if deletionConnection then
        deletionConnection:Disconnect()
        deletionConnection = nil
    end
    
    deletionConnection = RunService.Heartbeat:Connect(function()
        allowedNoli = killers:FindFirstChild("Noli")
        
        if not allowedNoli then
            if deletionConnection then
                deletionConnection:Disconnect()
                deletionConnection = nil
            end
            return
        end
        
        for _, child in killers:GetChildren() do
            if child.Name == "Noli" and child ~= allowedNoli then
                child:Destroy()
            end
        end
    end)
end

local function manageVoidRushState(character)
    while isVoidRushCrashed and character and character.Parent do
        character:SetAttribute("VoidRushState", "Crashed")
        task.wait(0.5)
    end
end



NoliGroup:AddToggle("NoliDeleter", {
    Text = "反假Noli",
    Default = false,
    Callback = function(enabled)
        noliDeleterActive = enabled
        
        if enabled then
            if deletionConnection then
                deletionConnection:Disconnect()
                deletionConnection = nil
            end
            
            local success = pcall(deleteNewNoli)
            
            if not success then
                noliDeleterActive = false
            end
        else
            if deletionConnection then
                deletionConnection:Disconnect()
                deletionConnection = nil
            end
            allowedNoli = nil
        end
    end
})

NoliGroup:AddToggle("無視障礙[Noli]", {
    Text = "Noli无视障碍",
    Default = false,
    Callback = function(enabled)
        isVoidRushCrashed = enabled
        local character = player.Character
        
        if characterCheckLoop then
            task.cancel(characterCheckLoop)
            characterCheckLoop = nil
        end
        
        if enabled then
            if character then
                characterCheckLoop = task.spawn(function()
                    manageVoidRushState(character)
                end)
            end
        else
            if character then
                character:SetAttribute("VoidRushState", nil)
            end
        end
    end
})

local killers = workspace:WaitForChild("Players"):WaitForChild("Killers")

killers.ChildAdded:Connect(function(child)
    if noliDeleterActive and child.Name == "Noli" and not deletionConnection then
        task.wait(0.5)
        if noliDeleterActive and not deletionConnection then
            deleteNewNoli()
        end
    end
end)

player.CharacterAdded:Connect(function(newCharacter)
    if isVoidRushCrashed then
        if characterCheckLoop then
            task.cancel(characterCheckLoop)
        end
        characterCheckLoop = task.spawn(function()
            manageVoidRushState(newCharacter)
        end)
    end
end)












local ZZ = Tabs.Bro:AddLeftGroupbox('玩家移动')
local CFSpeed = 50
local CFLoop = nil
local RunService = game:GetService("RunService")


local speedValue = 0
_G.SpeedToggle = false

ZZ:AddSlider("SpeedBypass", {
    Text = "速度调节",
    Default = 16,
    Min = 1,
    Max = 500,
    Rounding = 0,
    Callback = function(value)
        speedValue = value
    end
})

ZZ:AddToggle("SpeedToggle", {
    Text = "速度黑客",
    Default = false,
    Callback = function(state)
        _G.SpeedToggle = state
        task.spawn(function()
            local LocalPlayer = game.Players.LocalPlayer
            while task.wait() and _G.SpeedToggle do
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.MoveDirection ~= Vector3.zero then
                    LocalPlayer.Character:TranslateBy(humanoid.MoveDirection * speedValue * game:GetService("RunService").RenderStepped:Wait())
                end
            end
        end)
    end
})




local noclipParts = {}
_G.noclipState = false

local function enableNoclip()
    local LocalPlayer = game.Players.LocalPlayer
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                noclipParts[part] = part
                part.CanCollide = false
            end
        end
    end
end

local function disableNoclip()
    for _, part in pairs(noclipParts) do
        part.CanCollide = true
    end
end

ZZ:AddToggle("EnableNoclip", {
    Text = "穿墙",
    Default = false,
    Callback = function(state)
        _G.noclipState = state
        task.spawn(function()
            while task.wait() do
                if _G.noclipState then
                    enableNoclip()
                else
                    disableNoclip()
                    break
                end
            end
        end)
    end
})


local function StartCFly()
    local speaker = game.Players.LocalPlayer
    local character = speaker.Character
    if not character or not character.Parent then return end
    
    local humanoid = character:FindFirstChildOfClass('Humanoid')
    local head = character:FindFirstChild("Head")
    
    if not humanoid or not head then return end
    
    humanoid.PlatformStand = true
    head.Anchored = true
    
    if CFLoop then 
        CFLoop:Disconnect() 
        CFLoop = nil
    end
    
    local function isCharacterValid()
        if not character or not character.Parent then return false end
        if not humanoid or humanoid.Parent ~= character then return false end
        if not head or head.Parent ~= character then return false end
        return true
    end
    
    CFLoop = RunService.Heartbeat:Connect(function(deltaTime)
        if not isCharacterValid() then 
            if CFLoop then 
                CFLoop:Disconnect() 
                CFLoop = nil
            end
            return 
        end
        
        local moveDirection = humanoid.MoveDirection
        local headCFrame = head.CFrame
        local camera = workspace.CurrentCamera
        
        if not camera then return end
        
        local cameraCFrame = camera.CFrame
        local cameraOffset = headCFrame:ToObjectSpace(cameraCFrame).Position
        cameraCFrame = cameraCFrame * CFrame.new(-cameraOffset.X, -cameraOffset.Y, -cameraOffset.Z + 1)
        local cameraPosition = cameraCFrame.Position
        local headPosition = headCFrame.Position

        local objectSpaceVelocity = CFrame.new(cameraPosition, Vector3.new(headPosition.X, cameraPosition.Y, headPosition.Z)):VectorToObjectSpace(moveDirection * (CFSpeed * deltaTime))
        
        if isCharacterValid() then
            head.CFrame = CFrame.new(headPosition) * (cameraCFrame - cameraPosition) * CFrame.new(objectSpaceVelocity)
        end
    end)
end

local function StopCFly()
    local speaker = game.Players.LocalPlayer
    local character = speaker.Character
    
    if CFLoop then
        CFLoop:Disconnect()
        CFLoop = nil
    end
    
    if character and character.Parent then
        local humanoid = character:FindFirstChildOfClass('Humanoid')
        local head = character:FindFirstChild("Head")
        
        if humanoid then
            humanoid.PlatformStand = false
        end
        if head then
            head.Anchored = false
        end
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    StopCFly()
end)

ZZ:AddToggle("CFlyToggle", {
    Text = "飞行",
    Default = false,
    Callback = function(Value)
        if Value then
            task.wait(0.1)
            StartCFly()
        else
            StopCFly()
        end
    end
})

ZZ:AddSlider("CFlySpeed", {
    Text = "飞行速度",
    Default = 50,
    Min = 1,
    Max = 200,
    Rounding = 1,
    Callback = function(Value)
        CFSpeed = Value
    end
})




ZZ:AddLabel("以上均绕过 / 暴力使用")


if getgenv().ExistingConnections then
    for _, conn in ipairs(getgenv().ExistingConnections) do
        if conn then
            pcall(function() conn:Disconnect() end)
        end
    end
end




getgenv().ExistingConnections = {}

getgenv().Players = game:GetService("Players")
getgenv().RunService = game:GetService("RunService")
getgenv().LocalPlayer = getgenv().Players.LocalPlayer
getgenv().ReplicatedStorage = game:GetService("ReplicatedStorage")
getgenv().buffer = buffer or require(getgenv().ReplicatedStorage.Buffer)
getgenv().RemoteEvent = getgenv().ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("Network"):WaitForChild("RemoteEvent")

local Plrs = getgenv().Players
local RSvc = getgenv().RunService
local LocalP = getgenv().LocalPlayer
local RS = getgenv().ReplicatedStorage
getgenv().AutoBlockSounds = {
   ["12222216"] = true,
   ["71805956520207"] = true,
   ["71834552297085"] = true,
   ["72425554233832"] = true,
   ["75330693422988"] = true,
   ["76467993976301"] = true,
   ["76959687420003"] = true,
   ["77245770579014"] = true,
   ["78298577002481"] = true,
   ["79391273191671"] = true,
   ["79980897195554"] = true,
   ["80516583309685"] = true,
   ["81702359653578"] = true,
   ["82221759983649"] = true,
   ["84116622032112"] = true,
   ["84307400688050"] = true,
   ["85810983952228"] = true,
   ["85853080745515"] = true,
   ["86174610237192"] = true,
   ["86494585504534"] = true,
   ["86833981571073"] = true,
   ["89004992452376"] = true,
   ["89315669689903"] = true,
   ["90878551190839"] = true,
   ["94043596324983"] = true,
   ["95079963655241"] = true,
   ["97894923442490"] = true,
   ["98675142200448"] = true,
   ["99829427721752"] = true,
   ["101199185291628"] = true,
   ["101553872555606"] = true,
   ["101698569375359"] = true,
   ["102228729296384"] = true,
   ["103684883268194"] = true,
   ["104910828105172"] = true,
   ["105200830849301"] = true,
   ["105840448036441"] = true,
   ["106300477136129"] = true,
   ["107444859834748"] = true,
   ["108610718831698"] = true,
   ["108907358619313"] = true,
   ["109348678063422"] = true,
   ["109431876587852"] = true,
   ["110115912768379"] = true,
   ["110372418055226"] = true,
   ["112395455254818"] = true,
   ["112809109188560"] = true,
   ["113037804008732"] = true,
   ["114742322778642"] = true,
   ["115026634746636"] = true,
   ["116581754553533"] = true,
   ["117173212095661"] = true,
   ["117231507259853"] = true,
   ["119089145505438"] = true,
   ["119583605486352"] = true,
   ["119942598489800"] = true,
   ["121954639447247"] = true,
   ["124330645976935"] = true,
   ["124397369810639"] = true,
   ["124903763333174"] = true,
   ["125213046326879"] = true,
   ["127793641088496"] = true,
   ["128856426573270"] = true,
   ["131123355704017"] = true,
   ["131406927389838"] = true,
   ["135448067174226"] = true,
   ["136323728355613"] = true,
   ["136841625231863"] = true,
   ["140242176732868"] = true,
   ["128367348686124"] = true,
   ["116527305931161"] = true
}

getgenv().AutoBlockAnims = {
   ["18885909645"] = true,
   ["70371667919898"] = true,
   ["70447634862911"] = true,
   ["99135633258223"] = true,
   ["74707328554358"] = true,
   ["81299297965542"] = true,
   ["81639435858902"] = true,
   ["82113744478546"] = true,
   ["83251433279852"] = true,
   ["83685305553364"] = true,
   ["83829782357897"] = true,
   ["86204001129974"] = true,
   ["87989533095285"] = true,
   ["88451353906104"] = true,
   ["88970503168421"] = true,
   ["92173139187970"] = true,
   ["93069721274110"] = true,
   ["94162446513587"] = true,
   ["96571077893813"] = true,
   ["97167027849946"] = true,
   ["97433060861952"] = true,
   ["98456918873918"] = true,
   ["99135633258223"] = true,
   ["99829427721752"] = true,
   ["100592913030351"] = true,
   ["105458270463374"] = true,
   ["106538427162796"] = true,
   ["106776364623742"] = true,
   ["106847695270773"] = true,
   ["109230267448394"] = true,
   ["109667959938617"] = true,
   ["114356208094580"] = true,
   ["114506382930939"] = true,
   ["118298475669935"] = true,
   ["120112897026015"] = true,
   ["121086746534252"] = true,
   ["121293883585738"] = true,
   ["122709416391891"] = true,
   ["124705663396411"] = true,
   ["125403313786645"] = true,
   ["126171487400618"] = true,
   ["126355327951215"] = true,
   ["126681776859538"] = true,
   ["126830014841198"] = true,
   ["126896426760253"] = true,
   ["128414736976503"] = true,
   ["129976080405072"] = true,
   ["131430497821198"] = true,
   ["131543461321709"] = true,
   ["133336594357903"] = true,
   ["133363345661032"] = true,
   ["137314737492715"] = true,
   ["138938529389204"] = true,
   ["139309647473555"] = true,
   ["139835501033932"] = true,
   ["109700476007435"] = true,
   ["93366464803829"] = true,
   ["98590570796574"] = true
}

getgenv().PunchAnims = {
    ["108911997126897"]=true,["82137285150006"]=true,["129843313690921"]=true,
    ["140703210927645"]=true,["136007065400978"]=true,["86096387000557"]=true,
    ["87259391926321"]=true,["86709774283672"]=true,["108807732150251"]=true,
    ["138040001965654"]=true
}

getgenv().AutoBlockEnabled = false
getgenv().LooseFacingCheck = false
getgenv().SenseRange = 18
getgenv().PlayerFacingAngle = 90
getgenv().KillerFacingAngle = 90
getgenv().KillerFacingCheckEnabled = false
getgenv().KillersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")
getgenv().SenseRangeSq = getgenv().SenseRange * getgenv().SenseRange
getgenv().FacingCheckEnabled = false
getgenv().InnerCircleVisible = false
getgenv().OuterCircleVisible = false
getgenv().KillerCircles = {}
getgenv().SoundHooks = {}
getgenv().AnimHooks = {}
getgenv().SoundBlockedUntil = {}
getgenv().AnimBlockedUntil = {}
getgenv().SoundStartTime = {}
getgenv().AnimStartTime = {}
getgenv().MaxSoundAge = 1.2
getgenv().MaxAnimAge = 1.5
getgenv().autoPunchOn = false
getgenv().aimbotPunchOn = false
getgenv().punchRange = 50
getgenv().aimbotDelay = 0.1
getgenv().lastAimbotTime = 0
getgenv().KnownKillers = {"c00lkidd","Jason","JohnDoe","1x1x1x1","Noli","Slasher","Sixer","Nosferatu"}
getgenv().CachedGui = getgenv().LocalPlayer:WaitForChild("PlayerGui")
getgenv().CachedPunchBtn = nil
getgenv().CachedCharges = nil
getgenv().CachedBlockBtn = nil
getgenv().CachedCooldown = nil
getgenv().HDPullEnabled = false
getgenv().HDSpeed = 12
getgenv().pulling = false
getgenv().wallCheckEnabled = false
getgenv().visualizationParts = {}
getgenv().lastVisUpdate = 0
getgenv().visUpdateInterval = 0.016
getgenv().VisualizationMode = "指南针"
getgenv().BoxLength = 15
getgenv().BoxWidth = 6
getgenv().BoxColor = Color3.fromRGB(255, 0, 255)
getgenv().BoxTransparency = 0.7
getgenv().BoxSafeColor = Color3.fromRGB(0, 255, 0)
getgenv().BoxDangerColor = Color3.fromRGB(255, 0, 0)
getgenv().lastBlockTime = 0
getgenv().blockCooldown = 0.2
getgenv().faceKillerUntil = 0
getgenv().currentTargetKiller = nil
getgenv().faceKillerDuration = 3

getgenv().FireBlockRemote = function()
    local now = tick()
    if now - getgenv().lastBlockTime < getgenv().blockCooldown then return end
    getgenv().lastBlockTime = now
    local args = {"UseActorAbility", {buffer.fromstring("\3\5\0\0\0Block")}}
    game:GetService("ReplicatedStorage").Modules.Network.Network.RemoteEvent:FireServer(unpack(args))
end

getgenv().fireRemotePunch = function()
    local args = {"UseActorAbility", {buffer.fromstring("\3\5\0\0\0Punch")}}
    game:GetService("ReplicatedStorage").Modules.Network.Network.RemoteEvent:FireServer(unpack(args))
    
    local closest = getgenv().getClosestKiller()
    if closest then
        getgenv().currentTargetKiller = closest
        getgenv().faceKillerUntil = tick() + getgenv().faceKillerDuration
    end
end

getgenv().IsPlayerFacingKiller = function(myRoot,killerRoot)
    if not getgenv().FacingCheckEnabled then return true end
    if not myRoot or not killerRoot then return false end
    local dirToKiller = (killerRoot.Position - myRoot.Position)
    local flatDir = Vector3.new(dirToKiller.X, 0, dirToKiller.Z).Unit
    local playerLookDir = Vector3.new(myRoot.CFrame.LookVector.X, 0, myRoot.CFrame.LookVector.Z).Unit
    local dotProduct = playerLookDir:Dot(flatDir)
    local angleInDegrees = math.deg(math.acos(math.clamp(dotProduct,-1,1)))
    return angleInDegrees <= getgenv().PlayerFacingAngle
end

getgenv().IsKillerFacingPlayer = function(myRoot,killerRoot)
    if not getgenv().KillerFacingCheckEnabled then return true end
    if not myRoot or not killerRoot then return false end
    local dirToPlayer = (myRoot.Position - killerRoot.Position)
    local flatDir = Vector3.new(dirToPlayer.X, 0, dirToPlayer.Z).Unit
    local killerLookDir = Vector3.new(killerRoot.CFrame.LookVector.X, 0, killerRoot.CFrame.LookVector.Z).Unit
    local dotProduct = killerLookDir:Dot(flatDir)
    local angleInDegrees = math.deg(math.acos(math.clamp(dotProduct,-1,1)))
    return angleInDegrees <= getgenv().KillerFacingAngle
end

getgenv().HasLineOfSight = function(targetRoot)
    if not getgenv().wallCheckEnabled then return true end
    local myRoot = LocalP.Character and LocalP.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return false end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.IgnoreWater = true
    rayParams.FilterDescendantsInstances = {LocalP.Character}
    local origin = myRoot.Position
    local direction = targetRoot.Position - origin
    local result = workspace:Raycast(origin,direction,rayParams)
    return not result or result.Instance:IsDescendantOf(targetRoot.Parent)
end

getgenv().IsPlayerInBox = function(myRoot, killerRoot)
    if not myRoot or not killerRoot then return false end
    
    local forward = killerRoot.CFrame.LookVector
    local forwardOffset = forward * (getgenv().BoxLength/2)
    local boxPos = killerRoot.Position + forwardOffset
    local boxCFrame = CFrame.lookAt(boxPos, boxPos + forward * 100)
    
    local relative = myRoot.Position - boxPos
    local localSpace = boxCFrame:VectorToObjectSpace(relative)
    local halfX = getgenv().BoxWidth / 2
    local halfY = 4
    local halfZ = getgenv().BoxLength / 2
    
    return math.abs(localSpace.X) <= halfX and math.abs(localSpace.Y) <= halfY and math.abs(localSpace.Z) <= halfZ
end

getgenv().CheckAllBlockConditions = function(myRoot,killerRoot)
    if not myRoot or not killerRoot then return false end
    
    local dvec = killerRoot.Position - myRoot.Position
    local distSq = dvec.X^2 + dvec.Y^2 + dvec.Z^2
    
    if getgenv().VisualizationMode == "Box" then
        if not getgenv().IsPlayerInBox(myRoot, killerRoot) then return false end
    elseif getgenv().VisualizationMode == "球体" then
        if distSq > getgenv().SenseRangeSq then return false end
    else
        if distSq > getgenv().SenseRangeSq then return false end
    end
    
    if not getgenv().IsKillerFacingPlayer(myRoot,killerRoot) then return false end
    if not getgenv().HasLineOfSight(killerRoot) then return false end
    if not getgenv().IsPlayerFacingKiller(myRoot,killerRoot) then return false end
    
    return true
end

getgenv().GetSoundIdNumeric = function(snd)
    if not snd or not snd.SoundId then return nil end
    local sid = tostring(snd.SoundId)
    return sid:match("%d+")
end

getgenv().GetAnimIdNumeric = function(anim)
    if not anim or not anim.AnimationId then return nil end
    local aid = tostring(anim.AnimationId)
    return aid:match("%d+")
end

getgenv().GetSoundPosition = function(snd)
    if not snd then return nil end
    if snd.Parent and snd.Parent:IsA("BasePart") then
        return snd.Parent.Position,snd.Parent
    end
    if snd.Parent and snd.Parent:IsA("Attachment") and snd.Parent.Parent and snd.Parent.Parent:IsA("BasePart") then
        return snd.Parent.Parent.Position,snd.Parent.Parent
    end
    local found = snd.Parent and snd.Parent:FindFirstChildWhichIsA("BasePart",true)
    return found and found.Position,found or nil,nil
end

getgenv().GetCharFromDescendant = function(inst)
    if not inst then return nil end
    local mdl = inst:FindFirstAncestorOfClass("Model")
    return mdl and mdl:FindFirstChildOfClass("Humanoid") and mdl or nil
end

getgenv().CanUseBlock = function()
    if getgenv().CachedCooldown and getgenv().CachedCooldown.Text ~= "" then return false end
    return true
end

getgenv().DoHDPull = function(targetPos)
    if getgenv().pulling or not getgenv().CanUseBlock() then return end
    getgenv().pulling = true
    local hrp = LocalP.Character and LocalP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then getgenv().pulling = false return end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(50000,0,50000)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp
    local startTime = tick()
    local conn
    conn = RSvc.Heartbeat:Connect(function()
        if not bv.Parent or tick() - startTime > 0.4 then 
            if bv.Parent then bv:Destroy() end
            conn:Disconnect() 
            getgenv().pulling = false 
            return 
        end
        local vec = targetPos - hrp.Position
        if vec.Magnitude < 3 then 
            bv:Destroy() 
            conn:Disconnect() 
            getgenv().pulling = false 
            return 
        end
        bv.Velocity = vec.Unit * (getgenv().HDSpeed * 25)
    end)
end

getgenv().AttemptBlockSound = function(snd)
    if not getgenv().AutoBlockEnabled then return end
    if not snd or not snd:IsA("Sound") then return end
    if not snd.IsPlaying then return end
    local id = getgenv().GetSoundIdNumeric(snd)
    if not id or not getgenv().AutoBlockSounds[id] then return end
    
    local now = tick()
    
    if not getgenv().SoundStartTime[snd] then
        getgenv().SoundStartTime[snd] = now
    end
    local soundAge = now - getgenv().SoundStartTime[snd]
    if soundAge > getgenv().MaxSoundAge then return end
    
    if getgenv().SoundBlockedUntil[snd] and now < getgenv().SoundBlockedUntil[snd] then return end
    
    local myRoot = LocalP.Character and LocalP.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local pos,part = getgenv().GetSoundPosition(snd)
    if not pos or not part then return end
    local char = getgenv().GetCharFromDescendant(part)
    local plr = char and Plrs:GetPlayerFromCharacter(char)
    if not plr or plr == LocalP then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if not getgenv().CheckAllBlockConditions(myRoot,hrp) then return end
    
    getgenv().FireBlockRemote()
    if getgenv().HDPullEnabled then
        task.spawn(function() getgenv().DoHDPull(hrp.Position) end)
    end
    getgenv().SoundBlockedUntil[snd] = now + 0.8
end

getgenv().AttemptBlockAnim = function(animTrack)
    if not getgenv().AutoBlockEnabled then return end
    if not animTrack or not animTrack.Animation then return end
    if not animTrack.IsPlaying then return end
    local id = getgenv().GetAnimIdNumeric(animTrack.Animation)
    if not id or not getgenv().AutoBlockAnims[id] then return end
    
    local now = tick()
    
    if not getgenv().AnimStartTime[animTrack] then
        getgenv().AnimStartTime[animTrack] = now
    end
    local animAge = now - getgenv().AnimStartTime[animTrack]
    if animAge > getgenv().MaxAnimAge then return end
    
    if getgenv().AnimBlockedUntil[animTrack] and now < getgenv().AnimBlockedUntil[animTrack] then return end
    
    local myRoot = LocalP.Character and LocalP.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local animator = animTrack.Parent
    if not animator or not animator:IsA("Animator") then return end
    local char = getgenv().GetCharFromDescendant(animator)
    if not char then return end
    local plr = Plrs:GetPlayerFromCharacter(char)
    if not plr or plr == LocalP then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if not getgenv().CheckAllBlockConditions(myRoot,hrp) then return end
    
    getgenv().FireBlockRemote()
    if getgenv().HDPullEnabled then
        task.spawn(function() getgenv().DoHDPull(hrp.Position) end)
    end
    getgenv().AnimBlockedUntil[animTrack] = now + 0.8
end

getgenv().HookSound = function(snd)
    if not snd or not snd:IsA("Sound") then return end
    if getgenv().SoundHooks[snd] then return end
    
    local playConn = snd.Played:Connect(function()
        getgenv().SoundStartTime[snd] = tick()
        task.defer(getgenv().AttemptBlockSound,snd)
    end)
    
    local propConn = snd:GetPropertyChangedSignal("IsPlaying"):Connect(function()
        if snd.IsPlaying then 
            if not getgenv().SoundStartTime[snd] then
                getgenv().SoundStartTime[snd] = tick()
            end
            task.defer(getgenv().AttemptBlockSound,snd)
        else
            getgenv().SoundStartTime[snd] = nil
        end
    end)
    
    local destroyConn
    destroyConn = snd.Destroying:Connect(function()
        if playConn.Connected then playConn:Disconnect() end
        if propConn.Connected then propConn:Disconnect() end
        if destroyConn.Connected then destroyConn:Disconnect() end
        getgenv().SoundHooks[snd] = nil
        getgenv().SoundBlockedUntil[snd] = nil
        getgenv().SoundStartTime[snd] = nil
    end)
    
    getgenv().SoundHooks[snd] = {playConn,propConn,destroyConn}
    
    if snd.IsPlaying then
        getgenv().SoundStartTime[snd] = tick()
        task.defer(getgenv().AttemptBlockSound,snd)
    end
end

getgenv().HookAnimator = function(animator)
    if not animator or not animator:IsA("Animator") then return end
    animator.AnimationPlayed:Connect(function(animTrack)
        pcall(function()
            getgenv().AnimStartTime[animTrack] = tick()
            
            local playConn = animTrack:GetPropertyChangedSignal("IsPlaying"):Connect(function()
                if animTrack.IsPlaying then
                    if not getgenv().AnimStartTime[animTrack] then
                        getgenv().AnimStartTime[animTrack] = tick()
                    end
                    task.defer(getgenv().AttemptBlockAnim,animTrack)
                else
                    getgenv().AnimStartTime[animTrack] = nil
                end
            end)
            
            animTrack.Stopped:Connect(function()
                if playConn.Connected then playConn:Disconnect() end
                getgenv().AnimBlockedUntil[animTrack] = nil
                getgenv().AnimStartTime[animTrack] = nil
            end)
            
            if animTrack.IsPlaying then
                task.defer(getgenv().AttemptBlockAnim,animTrack)
            end
        end)
    end)
end

for _,d in ipairs(game:GetDescendants()) do
    if d:IsA("Sound") then pcall(getgenv().HookSound,d) end
    if d:IsA("Animator") then pcall(getgenv().HookAnimator,d) end
end

game.DescendantAdded:Connect(function(d)
    if d:IsA("Sound") then task.defer(getgenv().HookSound,d) end
    if d:IsA("Animator") then task.defer(getgenv().HookAnimator,d) end
end)

getgenv().CreateCompassVisualization = function(killer, myRoot)
    if not killer or not killer:FindFirstChild("HumanoidRootPart") or not myRoot then return nil end
    local killerRoot = killer.HumanoidRootPart
    
    local folder = Instance.new("Folder")
    folder.Name = "CompassVisualization"
    folder.Parent = killerRoot
    
    local segments = 32
    local parts = {}
    
    local centerPart = Instance.new("Part")
    centerPart.Name = "Center"
    centerPart.Size = Vector3.new(0.6,0.1,0.6)
    centerPart.Anchored = true
    centerPart.CanCollide = false
    centerPart.Transparency = 0.7
    centerPart.Material = Enum.Material.Neon
    centerPart.Color = Color3.fromRGB(255,255,0)
    centerPart.Position = killerRoot.Position + Vector3.new(0, 0.1, 0)
    centerPart.Parent = folder
    table.insert(parts, centerPart)
    
    for i = 1, segments do
        local part = Instance.new("Part")
        part.Name = "ArcPoint"..i
        part.Size = Vector3.new(0.4,0.15,0.4)
        part.Anchored = true
        part.CanCollide = false
        part.Transparency = 0.5
        part.Material = Enum.Material.Neon
        part.Color = Color3.fromRGB(255,100,100)
        part.Parent = folder
        table.insert(parts, part)
    end
    
    return {folder = folder, parts = parts, killer = killer, mode = "指南针"}
end

getgenv().CreateFixedVisualization = function(killer)
    if not killer or not killer:FindFirstChild("HumanoidRootPart") then return nil end
    local killerRoot = killer.HumanoidRootPart
    
    local folder = Instance.new("Folder")
    folder.Name = "FixedVisualization"
    folder.Parent = killerRoot
    
    local segments = 32
    local parts = {}
    
    local centerPart = Instance.new("Part")
    centerPart.Name = "Center"
    centerPart.Size = Vector3.new(0.6,0.1,0.6)
    centerPart.Anchored = true
    centerPart.CanCollide = false
    centerPart.Transparency = 0.7
    centerPart.Material = Enum.Material.Neon
    centerPart.Color = Color3.fromRGB(255,255,0)
    centerPart.Position = killerRoot.Position + Vector3.new(0, 0.1, 0)
    centerPart.Parent = folder
    table.insert(parts, centerPart)
    
    for i = 1, segments do
        local part = Instance.new("Part")
        part.Name = "ArcPoint"..i
        part.Size = Vector3.new(0.4,0.15,0.4)
        part.Anchored = true
        part.CanCollide = false
        part.Transparency = 0.5
        part.Material = Enum.Material.Neon
        part.Color = Color3.fromRGB(100,100,255)
        part.Parent = folder
        table.insert(parts, part)
    end
    
    return {folder = folder, parts = parts, killer = killer, mode = "固定"}
end

getgenv().CreateBoxVisualization = function(killer)
    if not killer or not killer:FindFirstChild("HumanoidRootPart") then return nil end
    local killerRoot = killer.HumanoidRootPart
    
    local folder = Instance.new("Folder")
    folder.Name = "BoxVisualization"
    folder.Parent = killerRoot
    
    local box = Instance.new("Part")
    box.Name = "DetectionBox"
    box.Material = Enum.Material.ForceField
    box.Anchored = true
    box.CanCollide = false
    box.Transparency = getgenv().BoxTransparency
    box.Color = getgenv().BoxColor
    box.Size = Vector3.new(getgenv().BoxWidth, 8, getgenv().BoxLength)
    box.Parent = folder
    
    return {folder = folder, box = box, killer = killer, mode = "Box"}
end

getgenv().CreateSphereVisualization = function(killer)
    if not killer or not killer:FindFirstChild("HumanoidRootPart") then return nil end
    local killerRoot = killer.HumanoidRootPart
    
    local folder = Instance.new("Folder")
    folder.Name = "SphereVisualization"
    folder.Parent = killerRoot
    
    local sphere = Instance.new("Part")
    sphere.Name = "DetectionSphere"
    sphere.Shape = Enum.PartType.Ball
    sphere.Material = Enum.Material.ForceField
    sphere.Anchored = true
    sphere.CanCollide = false
    sphere.Transparency = 0.8
    sphere.Color = Color3.fromRGB(255, 0, 0)
    sphere.Size = Vector3.new(getgenv().SenseRange * 2, getgenv().SenseRange * 2, getgenv().SenseRange * 2)
    sphere.Parent = folder
    
    return {folder = folder, sphere = sphere, killer = killer, mode = "球体"}
end

getgenv().UpdateCompassVisualization = function(visData, myRoot)
    if not visData or not visData.folder or not visData.folder.Parent then return end
    if not myRoot or not visData.killer or not visData.killer:FindFirstChild("HumanoidRootPart") then return end
    
    local killerRoot = visData.killer.HumanoidRootPart
    local dirToPlayer = (myRoot.Position - killerRoot.Position)
    local forward = Vector3.new(dirToPlayer.X, 0, dirToPlayer.Z).Unit
    local right = Vector3.new(-forward.Z, 0, forward.X)
    
    local angle = getgenv().KillerFacingCheckEnabled and getgenv().KillerFacingAngle or 360
    local angleRad = math.rad(angle)
    local distance = getgenv().SenseRange
    local segments = #visData.parts - 1
    
    visData.parts[1].Position = killerRoot.Position + Vector3.new(0, 0.1, 0)
    
    for i = 2, #visData.parts do
        local t = (i - 2) / math.max(1, segments - 1)
        local currentAngle = -angleRad/2 + angleRad * t
        local direction = forward * math.cos(currentAngle) + right * math.sin(currentAngle)
        visData.parts[i].Position = killerRoot.Position + Vector3.new(0, 0.1, 0) + direction * distance
    end
    
    local shouldBlock = getgenv().CheckAllBlockConditions(myRoot, killerRoot)
    local color = shouldBlock and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    for _, part in ipairs(visData.parts) do
        part.Color = color
    end
end

getgenv().UpdateFixedVisualization = function(visData, myRoot)
    if not visData or not visData.folder or not visData.folder.Parent then return end
    if not myRoot or not visData.killer or not visData.killer:FindFirstChild("HumanoidRootPart") then return end
    
    local killerRoot = visData.killer.HumanoidRootPart
    local forward = Vector3.new(killerRoot.CFrame.LookVector.X, 0, killerRoot.CFrame.LookVector.Z).Unit
    local right = Vector3.new(-forward.Z, 0, forward.X)
    
    local angle = getgenv().KillerFacingCheckEnabled and getgenv().KillerFacingAngle or 360
    local angleRad = math.rad(angle)
    local distance = getgenv().SenseRange
    local segments = #visData.parts - 1
    
    visData.parts[1].Position = killerRoot.Position + Vector3.new(0, 0.1, 0)
    
    for i = 2, #visData.parts do
        local t = (i - 2) / math.max(1, segments - 1)
        local currentAngle = -angleRad/2 + angleRad * t
        local direction = forward * math.cos(currentAngle) + right * math.sin(currentAngle)
        visData.parts[i].Position = killerRoot.Position + Vector3.new(0, 0.1, 0) + direction * distance
    end
    
    local shouldBlock = getgenv().CheckAllBlockConditions(myRoot, killerRoot)
    local color = shouldBlock and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 255)
    for _, part in ipairs(visData.parts) do
        part.Color = color
    end
end

getgenv().UpdateBoxVisualization = function(visData, myRoot)
    if not visData or not visData.folder or not visData.folder.Parent then return end
    if not myRoot or not visData.killer or not visData.killer:FindFirstChild("HumanoidRootPart") then return end
    
    local killerRoot = visData.killer.HumanoidRootPart
    local forward = killerRoot.CFrame.LookVector
    local forwardOffset = forward * (getgenv().BoxLength/2)
    local boxPos = killerRoot.Position + forwardOffset
    
    visData.box.Size = Vector3.new(getgenv().BoxWidth, 8, getgenv().BoxLength)
    visData.box.CFrame = CFrame.lookAt(boxPos, boxPos + forward * 100)
    visData.box.Transparency = getgenv().BoxTransparency
    
    local shouldBlock = getgenv().IsPlayerInBox(myRoot, killerRoot) and getgenv().CheckAllBlockConditions(myRoot, killerRoot)
    visData.box.Color = shouldBlock and getgenv().BoxSafeColor or getgenv().BoxDangerColor
end

getgenv().UpdateSphereVisualization = function(visData, myRoot)
    if not visData or not visData.folder or not visData.folder.Parent then return end
    if not myRoot or not visData.killer or not visData.killer:FindFirstChild("HumanoidRootPart") then return end
    
    local killerRoot = visData.killer.HumanoidRootPart
    
    visData.sphere.Size = Vector3.new(getgenv().SenseRange * 2, getgenv().SenseRange * 2, getgenv().SenseRange * 2)
    visData.sphere.CFrame = killerRoot.CFrame
    
    local dvec = myRoot.Position - killerRoot.Position
    local distSq = dvec.X^2 + dvec.Y^2 + dvec.Z^2
    local shouldBlock = distSq <= getgenv().SenseRangeSq and getgenv().CheckAllBlockConditions(myRoot, killerRoot)
    visData.sphere.Color = shouldBlock and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end

getgenv().CreateVisualizationForKiller = function(killer)
    if not killer or not killer:FindFirstChild("HumanoidRootPart") then return nil end
    
    if getgenv().VisualizationMode == "指南针" then
        local myRoot = LocalP.Character and LocalP.Character:FindFirstChild("HumanoidRootPart")
        return getgenv().CreateCompassVisualization(killer, myRoot)
    elseif getgenv().VisualizationMode == "固定" then
        return getgenv().CreateFixedVisualization(killer)
    elseif getgenv().VisualizationMode == "Box" then
        return getgenv().CreateBoxVisualization(killer)
    elseif getgenv().VisualizationMode == "球体" then
        return getgenv().CreateSphereVisualization(killer)
    end
    return nil
end

getgenv().UpdateVisualization = function(visData, myRoot)
    if not visData then return end
    
    if visData.mode == "指南针" then
        getgenv().UpdateCompassVisualization(visData, myRoot)
    elseif visData.mode == "固定" then
        getgenv().UpdateFixedVisualization(visData, myRoot)
    elseif visData.mode == "Box" then
        getgenv().UpdateBoxVisualization(visData, myRoot)
    elseif visData.mode == "球体" then
        getgenv().UpdateSphereVisualization(visData, myRoot)
    end
end

getgenv().AddKillerCircle = function(killer)
    if not killer:FindFirstChild("HumanoidRootPart") then return end
    if getgenv().KillerCircles[killer] then return end
    
    local innerCirc, outerCirc
    
    if getgenv().InnerCircleVisible then
        innerCirc = Instance.new("CylinderHandleAdornment")
        innerCirc.Name = "KillerInnerCircle"
        innerCirc.Adornee = killer.HumanoidRootPart
        innerCirc.Color3 = Color3.fromRGB(255,0,0)
        innerCirc.AlwaysOnTop = true
        innerCirc.ZIndex = 1
        innerCirc.Transparency = 0.6
        innerCirc.Radius = getgenv().SenseRange
        innerCirc.Height = 0.1
        innerCirc.CFrame = CFrame.Angles(math.rad(90),0,0)
        innerCirc.Parent = killer.HumanoidRootPart
    end
    
    if getgenv().OuterCircleVisible then
        outerCirc = Instance.new("CylinderHandleAdornment")
        outerCirc.Name = "KillerOuterCircle"
        outerCirc.Adornee = killer.HumanoidRootPart
        outerCirc.Color3 = Color3.fromRGB(0,255,255)
        outerCirc.AlwaysOnTop = true
        outerCirc.ZIndex = 0
        outerCirc.Transparency = 0.3
        outerCirc.Radius = getgenv().punchRange
        outerCirc.Height = 0.1
        outerCirc.CFrame = CFrame.Angles(math.rad(90),0,0)
        outerCirc.Parent = killer.HumanoidRootPart
    end
    
    local visData = getgenv().CreateVisualizationForKiller(killer)
    
    getgenv().KillerCircles[killer] = {innerCircle = innerCirc, outerCircle = outerCirc, visualization = visData}
end

getgenv().RemoveKillerCircle = function(killer)
    if getgenv().KillerCircles[killer] then
        if getgenv().KillerCircles[killer].innerCircle then
            getgenv().KillerCircles[killer].innerCircle:Destroy()
        end
        if getgenv().KillerCircles[killer].outerCircle then
            getgenv().KillerCircles[killer].outerCircle:Destroy()
        end
        if getgenv().KillerCircles[killer].visualization and getgenv().KillerCircles[killer].visualization.folder then
            getgenv().KillerCircles[killer].visualization.folder:Destroy()
        end
        getgenv().KillerCircles[killer] = nil
    end
end

getgenv().RefreshKillerCircles = function()
    for _,killer in ipairs(getgenv().KillersFolder:GetChildren()) do
        if getgenv().InnerCircleVisible or getgenv().OuterCircleVisible then
            getgenv().AddKillerCircle(killer)
        else
            getgenv().RemoveKillerCircle(killer)
        end
    end
end

getgenv().UpdateVisualizationMode = function(newMode)
    getgenv().VisualizationMode = newMode
    
    for killer, data in pairs(getgenv().KillerCircles) do
        if data.visualization and data.visualization.folder then
            data.visualization.folder:Destroy()
        end
        
        local newVisData = getgenv().CreateVisualizationForKiller(killer)
        data.visualization = newVisData
    end
end

getgenv().UpdateBoxColors = function()
    for killer, data in pairs(getgenv().KillerCircles) do
        if data.visualization and data.visualization.mode == "Box" and data.visualization.box then
            data.visualization.box.Transparency = getgenv().BoxTransparency
        end
    end
end

RSvc.Heartbeat:Connect(function()
    if not (getgenv().InnerCircleVisible or getgenv().OuterCircleVisible) then return end
    
    local now = tick()
    if now - getgenv().lastVisUpdate < getgenv().visUpdateInterval then return end
    getgenv().lastVisUpdate = now
    
    local myRoot = LocalP.Character and LocalP.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    for killer, data in pairs(getgenv().KillerCircles) do
        if killer:FindFirstChild("HumanoidRootPart") then
            local killerRoot = killer.HumanoidRootPart
            
            if data.innerCircle and data.innerCircle.Parent then
                data.innerCircle.Radius = getgenv().SenseRange
                local shouldBlock = getgenv().CheckAllBlockConditions(myRoot, killerRoot)
                data.innerCircle.Color3 = shouldBlock and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            end
            
            if data.outerCircle and data.outerCircle.Parent then
                data.outerCircle.Radius = getgenv().punchRange
                local dvec = killerRoot.Position - myRoot.Position
                local dist = math.sqrt(dvec.X^2 + dvec.Y^2 + dvec.Z^2)
                data.outerCircle.Color3 = dist <= getgenv().punchRange and Color3.fromRGB(0, 150, 150) or Color3.fromRGB(0, 100, 100)
            end
            
            if data.visualization then
                pcall(getgenv().UpdateVisualization, data.visualization, myRoot)
            end
        end
    end
end)

getgenv().KillersFolder.ChildAdded:Connect(function(killer)
    if getgenv().InnerCircleVisible or getgenv().OuterCircleVisible then
        task.spawn(function()
            local hrp = killer:WaitForChild("HumanoidRootPart",5)
            if hrp then getgenv().AddKillerCircle(killer) end
        end)
    end
end)

getgenv().KillersFolder.ChildRemoved:Connect(function(killer)
    getgenv().RemoveKillerCircle(killer)
end)

getgenv().RefreshUI = function()
    getgenv().CachedGui = getgenv().LocalPlayer:FindFirstChild("PlayerGui") or getgenv().CachedGui
    local mainUI = getgenv().CachedGui and getgenv().CachedGui:FindFirstChild("MainUI")
    if mainUI then
        local abilityContainer = mainUI:FindFirstChild("AbilityContainer")
        getgenv().CachedPunchBtn = abilityContainer and abilityContainer:FindFirstChild("Punch")
        getgenv().CachedBlockBtn = abilityContainer and abilityContainer:FindFirstChild("Block")
        getgenv().CachedCharges = getgenv().CachedPunchBtn and getgenv().CachedPunchBtn:FindFirstChild("Charges")
        getgenv().CachedCooldown = getgenv().CachedBlockBtn and getgenv().CachedBlockBtn:FindFirstChild("CooldownTime")
    else
        getgenv().CachedPunchBtn,getgenv().CachedBlockBtn,getgenv().CachedCharges,getgenv().CachedCooldown = nil,nil,nil,nil
    end
end

getgenv().RefreshUI()

if getgenv().CachedGui then
    getgenv().CachedGui.ChildAdded:Connect(function(child)
        if child.Name == "MainUI" then
            task.delay(0.02,getgenv().RefreshUI)
        end
    end)
end

getgenv().LocalPlayer.CharacterAdded:Connect(function()
    task.delay(0.5,getgenv().RefreshUI)
end)

getgenv().getClosestKiller = function()
    local myChar = getgenv().LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local closest,closestDist = nil,math.huge
    local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
    if killersFolder then
        for _,name in ipairs(getgenv().KnownKillers) do
            local killer = killersFolder:FindFirstChild(name)
            if killer and killer:FindFirstChild("HumanoidRootPart") then
                local root = killer.HumanoidRootPart
                local dvec = root.Position - myRoot.Position
                local dist = math.sqrt(dvec.X^2 + dvec.Y^2 + dvec.Z^2)
                if dist < closestDist and dist <= getgenv().punchRange then
                    closest = killer
                    closestDist = dist
                end
            end
        end
    end
    return closest
end

RSvc.Heartbeat:Connect(function()
    local now = tick()
    
    if getgenv().faceKillerUntil > now and getgenv().currentTargetKiller then
        local myChar = LocalP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if myRoot and getgenv().currentTargetKiller:FindFirstChild("HumanoidRootPart") then
            local killerRoot = getgenv().currentTargetKiller.HumanoidRootPart
            local direction = (killerRoot.Position - myRoot.Position)
            local flatDir = Vector3.new(direction.X, 0, direction.Z)
            if flatDir.Magnitude > 0.1 then
                myRoot.CFrame = CFrame.new(myRoot.Position, myRoot.Position + flatDir)
            end
        end
    else
        getgenv().currentTargetKiller = nil
    end
end)

getgenv().RunService.RenderStepped:Connect(function()
    if not getgenv().autoPunchOn and not getgenv().aimbotPunchOn then return end
    local myChar = getgenv().LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local gui = getgenv().CachedGui:FindFirstChild("MainUI")
    local punchBtn = gui and gui:FindFirstChild("AbilityContainer") and gui.AbilityContainer:FindFirstChild("Punch")
    local charges = punchBtn and punchBtn:FindFirstChild("Charges")
    if punchBtn and charges and myRoot then
        local chargeCount = tonumber(charges.Text) or 0
        if chargeCount >= 1 then
            local killer = getgenv().getClosestKiller()
            if killer and killer:FindFirstChild("HumanoidRootPart") then
                if getgenv().aimbotPunchOn then
                    local currentTime = tick()
                    if currentTime - getgenv().lastAimbotTime >= getgenv().aimbotDelay then
                        getgenv().fireRemotePunch()
                        getgenv().lastAimbotTime = currentTime
                    end
                elseif getgenv().autoPunchOn then
                    getgenv().fireRemotePunch()
                end
            end
        end
    end
end)

getgenv().punchAnimIds = {
    "108911997126897","82137285150006","129843313690921",
    "140703210927645","136007065400978","86096387000557",
    "87259391926321","86709774283672","108807732150251",
    "138040001965654"
}

getgenv().killerNames = {"c00lkidd","Jason","JohnDoe","1x1x1x1","Noli","Slasher","Sixer","Nosferatu"}
getgenv().autoFallPunchOn = false
getgenv().autoDashEnabled = false
getgenv().DASH_SPEED = 100
getgenv().MIN_TARGET_MAXHP = 300

if not getgenv().originalNamecall then
    getgenv().HookRules = {}
    getgenv().originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "FireServer" then
            for _, rule in ipairs(getgenv().HookRules) do
                if (not rule.remoteName or self.Name == rule.remoteName) then
                    if not rule.blockedFirstArg or args[1] == rule.blockedFirstArg then
                        if rule.block then
                            return
                        end
                    end
                end
            end
        end
        return getgenv().originalNamecall(self, ...)
    end)
end

getgenv().activateRemoteHook = function(remoteName, blockedFirstArg)
    for _, rule in ipairs(getgenv().HookRules) do
        if rule.remoteName == remoteName and rule.blockedFirstArg == blockedFirstArg then
            return
        end
    end
    table.insert(getgenv().HookRules, {
        remoteName = remoteName,
        blockedFirstArg = blockedFirstArg,
        block = true
    })
end

getgenv().deactivateRemoteHook = function(remoteName, blockedFirstArg)
    for i, rule in ipairs(getgenv().HookRules) do
        if rule.remoteName == remoteName and rule.blockedFirstArg == blockedFirstArg then
            table.remove(getgenv().HookRules, i)
            break
        end
    end
end

getgenv().EnableC00lkidd = function()
    getgenv().activateRemoteHook("RemoteEvent", game.Players.LocalPlayer.Name .. "C00lkiddCollision")
end

getgenv().DisableC00lkidd = function()
    getgenv().deactivateRemoteHook("RemoteEvent", game.Players.LocalPlayer.Name .. "C00lkiddCollision")
end

local globalEnv = getgenv()
globalEnv.walkSpeed = 100
globalEnv.toggle = false
globalEnv.connection = nil

function globalEnv.getCharacter()
    return globalEnv.LocalPlayer.Character or globalEnv.LocalPlayer.CharacterAdded:Wait()
end

function globalEnv.onHeartbeat()
    local player = globalEnv.LocalPlayer
    local character = globalEnv.getCharacter()
    if character.Name ~= "c00lkidd" then return end
    
    local char = globalEnv.getCharacter()
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local lv = rootPart and rootPart:FindFirstChild("LinearVelocity")
    
    if not rootPart or not humanoid or not lv then return end
    
    if lv then
        lv.VectorVelocity = Vector3.new(math.huge, math.huge, math.huge)
        lv.Enabled = false
    end

    local stopMovement = false
    local validValues = {
        Timeout = true,
        Collide = true,
        Hit = true
    }

    if not stopMovement then
        local lookVector = workspace.CurrentCamera.CFrame.LookVector
        local moveDir = Vector3.new(lookVector.X, 0, lookVector.Z)
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
            rootPart.Velocity = Vector3.new(moveDir.X * globalEnv.walkSpeed, rootPart.Velocity.Y, moveDir.Z * globalEnv.walkSpeed)
            rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + moveDir)
        end
    end
end

local function validTarget(player)
    if not player or player == getgenv().LocalPlayer then return false end
    local char = player.Character
    if not char then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return false end
    if humanoid.Health <= 0 then return false end
    if humanoid.MaxHealth < getgenv().MIN_TARGET_MAXHP then return false end
    local myChar = getgenv().LocalPlayer.Character
    if not myChar then return false end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return false end
    if (hrp.Position - myHrp.Position).Magnitude > getgenv().punchRange then return false end
    return true
end

local function findClosestValidTarget()
    local best, bestDist = nil, math.huge
    local myChar = getgenv().LocalPlayer.Character
    if not myChar then return nil end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil end
    for _, p in pairs(getgenv().Players:GetPlayers()) do
        if validTarget(p) then
            local targetHrp = p.Character:FindFirstChild("HumanoidRootPart")
            local d = (targetHrp.Position - myHrp.Position).Magnitude
            if d < bestDist then
                bestDist = d
                best = p
            end
        end
    end
    return best
end

local function isPunchAnimationPlaying()
    local char = getgenv().LocalPlayer.Character
    if not char then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    local trackList = humanoid:GetPlayingAnimationTracks()
    for _, track in ipairs(trackList) do
        local animId = tostring(track.Animation.AnimationId)
        for _, id in ipairs(getgenv().punchAnimIds) do
            if animId == "rbxassetid://" .. id then
                return true
            end
        end
    end
    return false
end

getgenv().RunService.Heartbeat:Connect(function()
    local myChar = getgenv().LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local gui = getgenv().LocalPlayer.PlayerGui:FindFirstChild("MainUI")
    local punchBtn = gui and gui:FindFirstChild("AbilityContainer") and gui.AbilityContainer:FindFirstChild("Punch")
    local charges = punchBtn and punchBtn:FindFirstChild("Charges")
    
    if getgenv().autoFallPunchOn and punchBtn and charges and myRoot then
        local chargeCount = tonumber(charges.Text) or 0
        if chargeCount >= 1 then
            local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
            if killersFolder then
                for _, name in ipairs(getgenv().killerNames) do
                    local killer = killersFolder:FindFirstChild(name)
                    if killer and killer:FindFirstChild("HumanoidRootPart") then
                        local root = killer.HumanoidRootPart
                        if (root.Position - myRoot.Position).Magnitude <= getgenv().punchRange then
                            myRoot.CFrame = myRoot.CFrame + Vector3.new(0, 8, 0)
                            getgenv().fireRemotePunch()
                            task.wait(0.01)
                        end
                    end
                end
            end
        end
    end
    
    if not getgenv().autoDashEnabled then return end
    local char = getgenv().LocalPlayer.Character
    if not char or char.Name ~= "Guest1337" then return end
    if not isPunchAnimationPlaying() then return end
    
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local target = findClosestValidTarget()
    if target and target.Character then
        local tgtHrp = target.Character:FindFirstChild("HumanoidRootPart")
        if tgtHrp then
            local dir = (tgtHrp.Position - rootPart.Position)
            local horiz = Vector3.new(dir.X, 0, dir.Z)
            local dist = horiz.Magnitude
            if dist > 3 then
                local unit = horiz.Unit
                local vel = unit * getgenv().DASH_SPEED
                local currentY = rootPart.AssemblyLinearVelocity.Y
                rootPart.AssemblyLinearVelocity = Vector3.new(vel.X, currentY, vel.Z)
            end
        end
    end
end)

local MainBlockTab = Tabs.Block:AddLeftTabbox()
local MainGroup = MainBlockTab:AddTab("Block")
local CombatGroup = MainBlockTab:AddTab("Punch")
local BoxGroup = MainBlockTab:AddTab("Box")
local AdvancedGroup = MainBlockTab:AddTab("Misc")


MainGroup:AddToggle("AutoBlockToggle",{
    Text = "自动格挡",
    Default = false,
    Tooltip = "开启/关闭自动格挡",
    Callback = function(Value)
        getgenv().AutoBlockEnabled = Value
    end,
})

MainGroup:AddToggle("InnerCircleToggle",{
    Text = "可视化",
    Default = false,
    Tooltip = "显示杀手内圈格挡检测范围",
    Callback = function(Value)
        getgenv().InnerCircleVisible = Value
        getgenv().RefreshKillerCircles()
    end,
})



MainGroup:AddDropdown("VisualizationModeDropdown",{
    Values = {"指南针", "固定", "Box", "球体"},
    Default = 1,
    Multi = false,
    Text = "可视化模式",
    Tooltip = "选择可视化显示模式\n指南针: 范围朝向玩家\n固定: 范围跟随杀手面向\nBox: 长方形检测范围\n球体: 球形检测范围",
    Callback = function(Value)
        getgenv().UpdateVisualizationMode(Value)
    end
})

MainGroup:AddToggle("FacingCheck",{
    Text = "玩家面向检测",
    Default = false,
    Tooltip = "仅在面向杀手时格挡",
    Callback = function(Value)
        getgenv().FacingCheckEnabled = Value
    end,
})

MainGroup:AddToggle("KillerFacingCheck",{
    Text = "杀手面向检测",
    Default = false,
    Tooltip = "仅在杀手面向玩家时格挡",
    Callback = function(Value)
        getgenv().KillerFacingCheckEnabled = Value
    end,
})

MainGroup:AddToggle("WallCheck",{
    Text = "Wallcheck",
    Default = false,
    Tooltip = "检测是否有墙体遮挡",
    Callback = function(Value)
        getgenv().wallCheckEnabled = Value
    end,
})

MainGroup:AddSlider("SenseRange",{
    Text = "格挡范围",
    Default = 18,
    Min = 5,
    Max = 50,
    Rounding = 1,
    Tooltip = "格挡检测的距离范围",
    Callback = function(Value)
        getgenv().SenseRange = Value
        getgenv().SenseRangeSq = Value * Value
    end,
})

MainGroup:AddSlider("PlayerFacingAngle",{
    Text = "玩家面向角度",
    Default = 90,
    Min = 30,
    Max = 180,
    Rounding = 1,
    Tooltip = "玩家面向杀手的角度检测",
    Callback = function(Value)
        getgenv().PlayerFacingAngle = Value
    end,
})

MainGroup:AddSlider("KillerFacingAngle",{
    Text = "杀手面向角度",
    Default = 90,
    Min = 30,
    Max = 180,
    Rounding = 1,
    Tooltip = "杀手面向玩家的角度检测",
    Callback = function(Value)
        getgenv().KillerFacingAngle = Value
    end,
})



MainGroup:AddSlider("MaxSoundAge",{
    Text = "最大声音检测时长(秒)",
    Default = 1.5,
    Min = 0.5,
    Max = 5,
    Rounding = 1,
    Tooltip = "声音播放超过此时长后将被忽略",
    Callback = function(Value)
        getgenv().MaxSoundAge = Value
    end,
})

MainGroup:AddSlider("MaxAnimAge",{
    Text = "最大动画检测时长(秒)",
    Default = 1.5,
    Min = 0.5,
    Max = 5,
    Rounding = 1,
    Tooltip = "动画播放超过此时长后将被忽略",
    Callback = function(Value)
        getgenv().MaxAnimAge = Value
    end,
})




CombatGroup:AddToggle("AutoPunch", {
    Text = "自动拳击",
    Default = false,
    Tooltip = "自动检测范围内的敌人并拳击",
    Callback = function(Value)
        getgenv().autoPunchOn = Value
    end
})

CombatGroup:AddToggle("AimbotPunch", {
    Text = "自瞄拳击",
    Default = false,
    Tooltip = "拳击后自动面向杀手3秒",
    Callback = function(Value)
        getgenv().aimbotPunchOn = Value
    end
})

CombatGroup:AddToggle("OuterCircleToggle",{
    Text = "可视化",
    Default = false,
    Tooltip = "显示杀手外圈拳击检测范围",
    Callback = function(Value)
        getgenv().OuterCircleVisible = Value
        getgenv().RefreshKillerCircles()
    end,
})

CombatGroup:AddSlider("PunchRange", {
    Text = "拳击范围",
    Default = 50,
    Min = 10,
    Max = 100,
    Rounding = 1,
    Tooltip = "拳击检测距离",
    Callback = function(Value)
        getgenv().punchRange = Value
    end
})

CombatGroup:AddSlider("AimbotDelay", {
    Text = "自瞄拳击间隔",
    Default = 0.1,
    Min = 0.01,
    Max = 1,
    Rounding = 2,
    Tooltip = "自瞄拳击之间的延迟时间（秒）",
    Callback = function(Value)
        getgenv().aimbotDelay = Value
    end
})

CombatGroup:AddSlider("FaceKillerDuration", {
    Text = "持续时间",
    Default = 3,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Tooltip = "拳击后持续面向杀手的时间（秒）",
    Callback = function(Value)
        getgenv().faceKillerDuration = Value
    end
})

CombatGroup:AddToggle("AutoFallPunch", {
    Text = "空中连拳",
    Default = false,
    Tooltip = "在空中自动触发拳击",
    Callback = function(Value)
        getgenv().autoFallPunchOn = Value
    end
})

AdvancedGroup:AddToggle("HDPullToggle", {
    Text = "格挡拉近（HDPull）",
    Default = false,
    Tooltip = "格挡时自动拉近到敌人",
    Callback = function(Value)
        getgenv().HDPullEnabled = Value
    end
})

AdvancedGroup:AddSlider("HDSpeed", {
    Text = "拉近速度",
    Default = 12,
    Min = 5,
    Max = 50,
    Rounding = 1,
    Tooltip = "格挡时向敌人移动的速度",
    Callback = function(Value)
        getgenv().HDSpeed = Value
    end
})

AdvancedGroup:AddToggle("AutoDash", {
    Text = "自动锁定",
    Default = false,
    Tooltip = "拳击时自动向敌人冲刺",
    Callback = function(Value)
        getgenv().autoDashEnabled = Value
    end
})

AdvancedGroup:AddSlider("DashSpeed", {
    Text = "冲刺速度",
    Default = 100,
    Min = 50,
    Max = 500,
    Rounding = 1,
    Tooltip = "自动冲刺时的速度",
    Callback = function(Value)
        getgenv().DASH_SPEED = Value
    end
})



BoxGroup:AddSlider("BoxLength",{
    Text = "Box长度",
    Default = 20,
    Min = 5,
    Max = 50,
    Rounding = 1,
    Tooltip = "Box模式的长度(仅Box模式有效)",
    Callback = function(Value)
        getgenv().BoxLength = Value
    end,
})

BoxGroup:AddSlider("BoxWidth",{
    Text = "Box宽度",
    Default = 15,
    Min = 2,
    Max = 30,
    Rounding = 1,
    Tooltip = "Box模式的宽度(仅Box模式有效)",
    Callback = function(Value)
        getgenv().BoxWidth = Value
    end,
})

BoxGroup:AddSlider("BoxTransparency",{
    Text = "Box透明度",
    Default = 0.7,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Tooltip = "Box的透明度(0=完全不透明,1=完全透明)",
    Callback = function(Value)
        getgenv().BoxTransparency = Value
        getgenv().UpdateBoxColors()
    end,
})

BoxGroup:AddLabel("Box安全颜色 (玩家在范围内):")
BoxGroup:AddSlider("BoxSafeColorR",{
    Text = "红色 (R)",
    Default = 0,
    Min = 0,
    Max = 255,
    Rounding = 0,
    Tooltip = "Box安全状态的红色值",
    Callback = function(Value)
        local current = getgenv().BoxSafeColor
        getgenv().BoxSafeColor = Color3.fromRGB(Value, current.G * 255, current.B * 255)
    end,
})

BoxGroup:AddSlider("BoxSafeColorG",{
    Text = "绿色 (G)",
    Default = 255,
    Min = 0,
    Max = 255,
    Rounding = 0,
    Tooltip = "Box安全状态的绿色值",
    Callback = function(Value)
        local current = getgenv().BoxSafeColor
        getgenv().BoxSafeColor = Color3.fromRGB(current.R * 255, Value, current.B * 255)
    end,
})

BoxGroup:AddSlider("BoxSafeColorB",{
    Text = "蓝色 (B)",
    Default = 0,
    Min = 0,
    Max = 255,
    Rounding = 0,
    Tooltip = "Box安全状态的蓝色值",
    Callback = function(Value)
        local current = getgenv().BoxSafeColor
        getgenv().BoxSafeColor = Color3.fromRGB(current.R * 255, current.G * 255, Value)
    end,
})

BoxGroup:AddLabel("Box危险颜色 (玩家不在范围内):")

BoxGroup:AddSlider("BoxDangerColorR",{
    Text = "红色 (R)",
    Default = 255,
    Min = 0,
    Max = 255,
    Rounding = 0,
    Tooltip = "Box危险状态的红色值",
    Callback = function(Value)
        local current = getgenv().BoxDangerColor
        getgenv().BoxDangerColor = Color3.fromRGB(Value, current.G * 255, current.B * 255)
    end,
})

BoxGroup:AddSlider("BoxDangerColorG",{
    Text = "绿色 (G)",
    Default = 0,
    Min = 0,
    Max = 255,
    Rounding = 0,
    Tooltip = "Box危险状态的绿色值",
    Callback = function(Value)
        local current = getgenv().BoxDangerColor
        getgenv().BoxDangerColor = Color3.fromRGB(current.R * 255, Value, current.B * 255)
    end,
})

BoxGroup:AddSlider("BoxDangerColorB",{
    Text = "蓝色 (B)",
    Default = 0,
    Min = 0,
    Max = 255,
    Rounding = 0,
    Tooltip = "Box危险状态的蓝色值",
    Callback = function(Value)
        local current = getgenv().BoxDangerColor
        getgenv().BoxDangerColor = Color3.fromRGB(current.R * 255, current.G * 255, Value)
    end,
})









getgenv().ExistingConnections = {}

getgenv().Players = game:GetService("Players")
getgenv().RunService = game:GetService("RunService")
getgenv().LocalPlayer = getgenv().Players.LocalPlayer
getgenv().ReplicatedStorage = game:GetService("ReplicatedStorage")
getgenv().buffer = buffer or require(getgenv().ReplicatedStorage.Buffer)
getgenv().RemoteEvent = getgenv().ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("Network"):WaitForChild("RemoteEvent")

local Plrs = getgenv().Players
local RSvc = getgenv().RunService
local LocalP = getgenv().LocalPlayer
local RS = getgenv().ReplicatedStorage
local Workspace = game:GetService("Workspace")

getgenv().AutoBlockSounds = {
   ["12222216"] = true,
   ["71805956520207"] = true,
   ["71834552297085"] = true,
   ["72425554233832"] = true,
   ["75330693422988"] = true,
   ["76467993976301"] = true,
   ["76959687420003"] = true,
   ["77245770579014"] = true,
   ["78298577002481"] = true,
   ["79391273191671"] = true,
   ["79980897195554"] = true,
   ["80516583309685"] = true,
   ["81702359653578"] = true,
   ["82221759983649"] = true,
   ["84116622032112"] = true,
   ["84307400688050"] = true,
   ["85810983952228"] = true,
   ["85853080745515"] = true,
   ["86174610237192"] = true,
   ["86494585504534"] = true,
   ["86833981571073"] = true,
   ["89004992452376"] = true,
   ["89315669689903"] = true,
   ["90878551190839"] = true,
   ["94043596324983"] = true,
   ["95079963655241"] = true,
   ["97894923442490"] = true,
   ["98675142200448"] = true,
   ["99829427721752"] = true,
   ["101199185291628"] = true,
   ["101553872555606"] = true,
   ["101698569375359"] = true,
   ["102228729296384"] = true,
   ["103684883268194"] = true,
   ["104910828105172"] = true,
   ["105200830849301"] = true,
   ["105840448036441"] = true,
   ["106300477136129"] = true,
   ["107444859834748"] = true,
   ["108610718831698"] = true,
   ["108907358619313"] = true,
   ["109348678063422"] = true,
   ["109431876587852"] = true,
   ["110115912768379"] = true,
   ["110372418055226"] = true,
   ["112395455254818"] = true,
   ["112809109188560"] = true,
   ["113037804008732"] = true,
   ["114742322778642"] = true,
   ["115026634746636"] = true,
   ["116581754553533"] = true,
   ["117173212095661"] = true,
   ["117231507259853"] = true,
   ["119089145505438"] = true,
   ["119583605486352"] = true,
   ["119942598489800"] = true,
   ["121954639447247"] = true,
   ["124330645976935"] = true,
   ["124397369810639"] = true,
   ["124903763333174"] = true,
   ["125213046326879"] = true,
   ["127793641088496"] = true,
   ["128856426573270"] = true,
   ["131123355704017"] = true,
   ["131406927389838"] = true,
   ["135448067174226"] = true,
   ["136323728355613"] = true,
   ["136841625231863"] = true,
   ["140242176732868"] = true,
   ["128367348686124"] = true,
   ["116527305931161"] = true
}

getgenv().AutoBlockAnims = {
   ["18885909645"] = true,
   ["70371667919898"] = true,
   ["70447634862911"] = true,
   ["99135633258223"] = true,
   ["74707328554358"] = true,
   ["81299297965542"] = true,
   ["81639435858902"] = true,
   ["82113744478546"] = true,
   ["83251433279852"] = true,
   ["83685305553364"] = true,
   ["83829782357897"] = true,
   ["86204001129974"] = true,
   ["87989533095285"] = true,
   ["88451353906104"] = true,
   ["88970503168421"] = true,
   ["92173139187970"] = true,
   ["93069721274110"] = true,
   ["94162446513587"] = true,
   ["96571077893813"] = true,
   ["97167027849946"] = true,
   ["97433060861952"] = true,
   ["98456918873918"] = true,
   ["99135633258223"] = true,
   ["99829427721752"] = true,
   ["100592913030351"] = true,
   ["105458270463374"] = true,
   ["106538427162796"] = true,
   ["106776364623742"] = true,
   ["106847695270773"] = true,
   ["109230267448394"] = true,
   ["109667959938617"] = true,
   ["114356208094580"] = true,
   ["114506382930939"] = true,
   ["118298475669935"] = true,
   ["120112897026015"] = true,
   ["121086746534252"] = true,
   ["121293883585738"] = true,
   ["122709416391891"] = true,
   ["124705663396411"] = true,
   ["125403313786645"] = true,
   ["126171487400618"] = true,
   ["126355327951215"] = true,
   ["126681776859538"] = true,
   ["126830014841198"] = true,
   ["126896426760253"] = true,
   ["128414736976503"] = true,
   ["129976080405072"] = true,
   ["131430497821198"] = true,
   ["131543461321709"] = true,
   ["133336594357903"] = true,
   ["133363345661032"] = true,
   ["137314737492715"] = true,
   ["138938529389204"] = true,
   ["139309647473555"] = true,
   ["139835501033932"] = true,
   ["109700476007435"] = true,
   ["93366464803829"] = true,
   ["98590570796574"] = true
}

-- 基础设置
getgenv().AutoBlockEnabled = false
getgenv().KillerFacingCheckEnabled = false
getgenv().wallCheckEnabled = false
getgenv().BoxLength = 7.5
getgenv().BoxWidth = 4.5
getgenv().BoxHeight = 6
getgenv().BoxTransparency = 0.7
getgenv().BoxSafeColor = Color3.fromRGB(0, 255, 0)
getgenv().BoxDangerColor = Color3.fromRGB(255, 0, 0)
getgenv().BoxSizeMultiplier = 1.0  -- Box整体大小倍数
getgenv().BoxForwardOffset = -1.4  -- Box前后位置偏移

-- Hitbox视觉效果设置
getgenv().HitboxVisualizationEnabled = false
getgenv().HitboxColor = Color3.fromRGB(255, 255, 255)
getgenv().HitboxTransparency = 0.5
getgenv().processedHitboxes = {}
getgenv().hitboxDetectionLoop = nil

getgenv().KillersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")
getgenv().SoundHooks = {}
getgenv().AnimHooks = {}
getgenv().SoundBlockedUntil = {}
getgenv().AnimBlockedUntil = {}
getgenv().SoundStartTime = {}
getgenv().AnimStartTime = {}
getgenv().MaxSoundAge = 1.2
getgenv().MaxAnimAge = 1.5
getgenv().lastBlockTime = 0
getgenv().blockCooldown = 0.2
getgenv().BoxVisualizations = {}
getgenv().KillerFacingAngle = 90

getgenv().FireBlockRemote = function()
   local now = tick()
   if now - getgenv().lastBlockTime < getgenv().blockCooldown then return end
   getgenv().lastBlockTime = now
   local args = {"UseActorAbility", {buffer.fromstring("\3\5\0\0\0Block")}}
   game:GetService("ReplicatedStorage").Modules.Network.Network.RemoteEvent:FireServer(unpack(args))
end

getgenv().IsKillerFacingPlayer = function(myRoot,killerRoot)
   if not getgenv().KillerFacingCheckEnabled then return true end
   if not myRoot or not killerRoot then return false end
   local dirToPlayer = (myRoot.Position - killerRoot.Position)
   local flatDir = Vector3.new(dirToPlayer.X, 0, dirToPlayer.Z).Unit
   local killerLookDir = Vector3.new(killerRoot.CFrame.LookVector.X, 0, killerRoot.CFrame.LookVector.Z).Unit
   local dotProduct = killerLookDir:Dot(flatDir)
   local angleInDegrees = math.deg(math.acos(math.clamp(dotProduct,-1,1)))
   return angleInDegrees <= getgenv().KillerFacingAngle
end

getgenv().HasLineOfSight = function(targetRoot)
   if not getgenv().wallCheckEnabled then return true end
   local myRoot = LocalP.Character and LocalP.Character:FindFirstChild("HumanoidRootPart")
   if not myRoot then return false end
   local rayParams = RaycastParams.new()
   rayParams.FilterType = Enum.RaycastFilterType.Exclude
   rayParams.IgnoreWater = true
   rayParams.FilterDescendantsInstances = {LocalP.Character}
   local origin = myRoot.Position
   local direction = targetRoot.Position - origin
   local result = workspace:Raycast(origin,direction,rayParams)
   return not result or result.Instance:IsDescendantOf(targetRoot.Parent)
end

getgenv().IsPlayerInBox = function(myRoot, killerRoot)
   if not myRoot or not killerRoot then return false end
   
   local forward = killerRoot.CFrame.LookVector
   -- 应用前后偏移和整体倍数
   local effectiveLength = getgenv().BoxLength * getgenv().BoxSizeMultiplier
   local forwardOffset = forward * ((effectiveLength/2) + getgenv().BoxForwardOffset)
   local boxPos = killerRoot.Position + forwardOffset
   local boxCFrame = CFrame.lookAt(boxPos, boxPos + forward * 100)
   
   local relative = myRoot.Position - boxPos
   local localSpace = boxCFrame:VectorToObjectSpace(relative)
   
   -- 应用整体倍数
   local halfX = (getgenv().BoxWidth * getgenv().BoxSizeMultiplier) / 2
   local halfY = (getgenv().BoxHeight * getgenv().BoxSizeMultiplier) / 2
   local halfZ = effectiveLength / 2
   
   return math.abs(localSpace.X) <= halfX and math.abs(localSpace.Y) <= halfY and math.abs(localSpace.Z) <= halfZ
end

getgenv().CheckAllBlockConditions = function(myRoot,killerRoot)
   if not myRoot or not killerRoot then return false end
   
   if not getgenv().IsPlayerInBox(myRoot, killerRoot) then return false end
   if not getgenv().IsKillerFacingPlayer(myRoot,killerRoot) then return false end
   if not getgenv().HasLineOfSight(killerRoot) then return false end
   
   return true
end

getgenv().GetSoundIdNumeric = function(snd)
   if not snd or not snd.SoundId then return nil end
   local sid = tostring(snd.SoundId)
   return sid:match("%d+")
end

getgenv().GetAnimIdNumeric = function(anim)
   if not anim or not anim.AnimationId then return nil end
   local aid = tostring(anim.AnimationId)
   return aid:match("%d+")
end

getgenv().GetSoundPosition = function(snd)
   if not snd then return nil end
   if snd.Parent and snd.Parent:IsA("BasePart") then
       return snd.Parent.Position,snd.Parent
   end
   if snd.Parent and snd.Parent:IsA("Attachment") and snd.Parent.Parent and snd.Parent.Parent:IsA("BasePart") then
       return snd.Parent.Parent.Position,snd.Parent.Parent
   end
   local found = snd.Parent and snd.Parent:FindFirstChildWhichIsA("BasePart",true)
   return found and found.Position,found or nil,nil
end

getgenv().GetCharFromDescendant = function(inst)
   if not inst then return nil end
   local mdl = inst:FindFirstAncestorOfClass("Model")
   return mdl and mdl:FindFirstChildOfClass("Humanoid") and mdl or nil
end

getgenv().AttemptBlockSound = function(snd)
   if not getgenv().AutoBlockEnabled then return end
   if not snd or not snd:IsA("Sound") then return end
   if not snd.IsPlaying then return end
   local id = getgenv().GetSoundIdNumeric(snd)
   if not id or not getgenv().AutoBlockSounds[id] then return end
   
   local now = tick()
   
   if not getgenv().SoundStartTime[snd] then
       getgenv().SoundStartTime[snd] = now
   end
   local soundAge = now - getgenv().SoundStartTime[snd]
   if soundAge > getgenv().MaxSoundAge then return end
   
   if getgenv().SoundBlockedUntil[snd] and now < getgenv().SoundBlockedUntil[snd] then return end
   
   local myRoot = LocalP.Character and LocalP.Character:FindFirstChild("HumanoidRootPart")
   if not myRoot then return end
   local pos,part = getgenv().GetSoundPosition(snd)
   if not pos or not part then return end
   local char = getgenv().GetCharFromDescendant(part)
   local plr = char and Plrs:GetPlayerFromCharacter(char)
   if not plr or plr == LocalP then return end
   local hrp = char:FindFirstChild("HumanoidRootPart")
   if not hrp then return end
   
   if not getgenv().CheckAllBlockConditions(myRoot,hrp) then return end
   
   getgenv().FireBlockRemote()
   getgenv().SoundBlockedUntil[snd] = now + 0.8
end

getgenv().AttemptBlockAnim = function(animTrack)
   if not getgenv().AutoBlockEnabled then return end
   if not animTrack or not animTrack.Animation then return end
   if not animTrack.IsPlaying then return end
   local id = getgenv().GetAnimIdNumeric(animTrack.Animation)
   if not id or not getgenv().AutoBlockAnims[id] then return end
   
   local now = tick()
   
   if not getgenv().AnimStartTime[animTrack] then
       getgenv().AnimStartTime[animTrack] = now
   end
   local animAge = now - getgenv().AnimStartTime[animTrack]
   if animAge > getgenv().MaxAnimAge then return end
   
   if getgenv().AnimBlockedUntil[animTrack] and now < getgenv().AnimBlockedUntil[animTrack] then return end
   
   local myRoot = LocalP.Character and LocalP.Character:FindFirstChild("HumanoidRootPart")
   if not myRoot then return end
   local animator = animTrack.Parent
   if not animator or not animator:IsA("Animator") then return end
   local char = getgenv().GetCharFromDescendant(animator)
   if not char then return end
   local plr = Plrs:GetPlayerFromCharacter(char)
   if not plr or plr == LocalP then return end
   local hrp = char:FindFirstChild("HumanoidRootPart")
   if not hrp then return end
   
   if not getgenv().CheckAllBlockConditions(myRoot,hrp) then return end
   
   getgenv().FireBlockRemote()
   getgenv().AnimBlockedUntil[animTrack] = now + 0.8
end

getgenv().HookSound = function(snd)
   if not snd or not snd:IsA("Sound") then return end
   if getgenv().SoundHooks[snd] then return end
   
   local playConn = snd.Played:Connect(function()
       getgenv().SoundStartTime[snd] = tick()
       task.defer(getgenv().AttemptBlockSound,snd)
   end)
   
   local propConn = snd:GetPropertyChangedSignal("IsPlaying"):Connect(function()
       if snd.IsPlaying then 
           if not getgenv().SoundStartTime[snd] then
               getgenv().SoundStartTime[snd] = tick()
           end
           task.defer(getgenv().AttemptBlockSound,snd)
       else
           getgenv().SoundStartTime[snd] = nil
       end
   end)
   
   local destroyConn
   destroyConn = snd.Destroying:Connect(function()
       if playConn.Connected then playConn:Disconnect() end
       if propConn.Connected then propConn:Disconnect() end
       if destroyConn.Connected then destroyConn:Disconnect() end
       getgenv().SoundHooks[snd] = nil
       getgenv().SoundBlockedUntil[snd] = nil
       getgenv().SoundStartTime[snd] = nil
   end)
   
   getgenv().SoundHooks[snd] = {playConn,propConn,destroyConn}
   
   if snd.IsPlaying then
       getgenv().SoundStartTime[snd] = tick()
       task.defer(getgenv().AttemptBlockSound,snd)
   end
end

getgenv().HookAnimator = function(animator)
   if not animator or not animator:IsA("Animator") then return end
   animator.AnimationPlayed:Connect(function(animTrack)
       pcall(function()
           getgenv().AnimStartTime[animTrack] = tick()
           
           local playConn = animTrack:GetPropertyChangedSignal("IsPlaying"):Connect(function()
               if animTrack.IsPlaying then
                   if not getgenv().AnimStartTime[animTrack] then
                       getgenv().AnimStartTime[animTrack] = tick()
                   end
                   task.defer(getgenv().AttemptBlockAnim,animTrack)
               else
                   getgenv().AnimStartTime[animTrack] = nil
               end
           end)
           
           animTrack.Stopped:Connect(function()
               if playConn.Connected then playConn:Disconnect() end
               getgenv().AnimBlockedUntil[animTrack] = nil
               getgenv().AnimStartTime[animTrack] = nil
           end)
           
           if animTrack.IsPlaying then
               task.defer(getgenv().AttemptBlockAnim,animTrack)
           end
       end)
   end)
end

for _,d in ipairs(game:GetDescendants()) do
   if d:IsA("Sound") then pcall(getgenv().HookSound,d) end
   if d:IsA("Animator") then pcall(getgenv().HookAnimator,d) end
end

game.DescendantAdded:Connect(function(d)
   if d:IsA("Sound") then task.defer(getgenv().HookSound,d) end
   if d:IsA("Animator") then task.defer(getgenv().HookAnimator,d) end
end)

getgenv().CreateBoxVisualization = function(killer)
   if not killer or not killer:FindFirstChild("HumanoidRootPart") then return nil end
   local killerRoot = killer.HumanoidRootPart
   
   local folder = Instance.new("Folder")
   folder.Name = "BoxVisualization"
   folder.Parent = killerRoot
   
   local box = Instance.new("Part")
   box.Name = "DetectionBox"
   box.Material = Enum.Material.ForceField
   box.Anchored = true
   box.CanCollide = false
   box.Transparency = getgenv().BoxTransparency
   box.Color = getgenv().BoxDangerColor
   box.Size = Vector3.new(
       getgenv().BoxWidth * getgenv().BoxSizeMultiplier, 
       getgenv().BoxHeight * getgenv().BoxSizeMultiplier, 
       getgenv().BoxLength * getgenv().BoxSizeMultiplier
   )
   box.Parent = folder
   
   return {folder = folder, box = box, killer = killer}
end

getgenv().UpdateBoxVisualization = function(visData, myRoot)
   if not visData or not visData.folder or not visData.folder.Parent then return end
   if not myRoot or not visData.killer or not visData.killer:FindFirstChild("HumanoidRootPart") then return end
   
   local killerRoot = visData.killer.HumanoidRootPart
   local forward = killerRoot.CFrame.LookVector
   local effectiveLength = getgenv().BoxLength * getgenv().BoxSizeMultiplier
   local forwardOffset = forward * ((effectiveLength/2) + getgenv().BoxForwardOffset)
   local boxPos = killerRoot.Position + forwardOffset
   
   visData.box.Size = Vector3.new(
       getgenv().BoxWidth * getgenv().BoxSizeMultiplier, 
       getgenv().BoxHeight * getgenv().BoxSizeMultiplier, 
       effectiveLength
   )
   visData.box.CFrame = CFrame.lookAt(boxPos, boxPos + forward * 100)
   visData.box.Transparency = getgenv().BoxTransparency
   
   local shouldBlock = getgenv().IsPlayerInBox(myRoot, killerRoot) and getgenv().CheckAllBlockConditions(myRoot, killerRoot)
   visData.box.Color = shouldBlock and getgenv().BoxSafeColor or getgenv().BoxDangerColor
end

getgenv().AddBoxVisualization = function(killer)
   if not killer:FindFirstChild("HumanoidRootPart") then return end
   if getgenv().BoxVisualizations[killer] then return end
   
   local visData = getgenv().CreateBoxVisualization(killer)
   getgenv().BoxVisualizations[killer] = visData
end

getgenv().RemoveBoxVisualization = function(killer)
   if getgenv().BoxVisualizations[killer] then
       if getgenv().BoxVisualizations[killer].folder then
           getgenv().BoxVisualizations[killer].folder:Destroy()
       end
       getgenv().BoxVisualizations[killer] = nil
   end
end

getgenv().RefreshBoxVisualizations = function()
   for killer, _ in pairs(getgenv().BoxVisualizations) do
       getgenv().RemoveBoxVisualization(killer)
   end
   
   if getgenv().AutoBlockEnabled then
       for _,killer in ipairs(getgenv().KillersFolder:GetChildren()) do
           getgenv().AddBoxVisualization(killer)
       end
   end
end

-- Hitbox可视化功能
getgenv().GetKillerUsernames = function()
   local killerNames = {}
   
   if Workspace:FindFirstChild("Players") then
       local playersFolder = Workspace.Players
       if playersFolder:FindFirstChild("Killers") then
           local killersFolder = playersFolder.Killers
           
           for _, killerModel in pairs(killersFolder:GetChildren()) do
               local killerPlayer = Players:GetPlayerFromCharacter(killerModel)
               if killerPlayer then
                   table.insert(killerNames, killerPlayer.Name)
               else
                   table.insert(killerNames, killerModel.Name)
               end
           end
       end
   end
   
   return killerNames
end

getgenv().FindKillerHitboxes = function()
   local hitboxes = {}
   local killerNames = getgenv().GetKillerUsernames()
   
   if #killerNames == 0 then
       return hitboxes
   end
   
   local hitboxesFolder = Workspace:FindFirstChild("Hitboxes")
   if not hitboxesFolder then return hitboxes end
   
   for _, child in pairs(hitboxesFolder:GetChildren()) do
       if child:IsA("BasePart") and string.find(child.Name, "Hitbox") then
           for _, killerName in pairs(killerNames) do
               if string.find(child.Name, killerName) then
                   hitboxes[child] = true
                   break
               end
           end
       end
   end
   
   return hitboxes
end

getgenv().EnlargeHitbox = function(hitbox)
   if hitbox and hitbox:IsA("BasePart") then
       if not getgenv().processedHitboxes[hitbox] then
           getgenv().processedHitboxes[hitbox] = {
               originalSize = hitbox.Size,
               originalColor = hitbox.Color,
               originalTransparency = hitbox.Transparency,
               originalMaterial = hitbox.Material
           }
           
           -- 使用与Box相同的大小倍数
           local multiplier = getgenv().BoxSizeMultiplier
           hitbox.Size = hitbox.Size * multiplier
           hitbox.Color = getgenv().HitboxColor
           hitbox.Transparency = getgenv().HitboxTransparency
       else
           -- 更新已存在的hitbox
           local multiplier = getgenv().BoxSizeMultiplier
           local original = getgenv().processedHitboxes[hitbox]
           hitbox.Size = original.originalSize * multiplier
           hitbox.Color = getgenv().HitboxColor
           hitbox.Transparency = getgenv().HitboxTransparency
       end
   end
end

getgenv().StartHitboxVisualization = function()
   if getgenv().hitboxDetectionLoop then return end
   
   getgenv().hitboxDetectionLoop = RSvc.Heartbeat:Connect(function()
       if not getgenv().HitboxVisualizationEnabled then return end
       
       local hitboxes = getgenv().FindKillerHitboxes()
       
       for hitbox, _ in pairs(hitboxes) do
           pcall(getgenv().EnlargeHitbox, hitbox)
       end
   end)
   
  
end

getgenv().StopHitboxVisualization = function()
   if getgenv().hitboxDetectionLoop then
       getgenv().hitboxDetectionLoop:Disconnect()
       getgenv().hitboxDetectionLoop = nil
   end
   
   -- 恢复所有处理过的hitbox
   for hitbox, originalData in pairs(getgenv().processedHitboxes) do
       if hitbox and hitbox.Parent then
           pcall(function()
               hitbox.Size = originalData.originalSize
               hitbox.Color = originalData.originalColor
               hitbox.Transparency = originalData.originalTransparency
           end)
       end
   end
   
   getgenv().processedHitboxes = {}
   print("杀手Hitbox可视化已停止")
end

RSvc.Heartbeat:Connect(function()
   if not getgenv().AutoBlockEnabled then return end
   
   local myRoot = LocalP.Character and LocalP.Character:FindFirstChild("HumanoidRootPart")
   if not myRoot then return end
   
   for killer, visData in pairs(getgenv().BoxVisualizations) do
       if killer:FindFirstChild("HumanoidRootPart") then
           pcall(getgenv().UpdateBoxVisualization, visData, myRoot)
       end
   end
end)

getgenv().KillersFolder.ChildAdded:Connect(function(killer)
   if getgenv().AutoBlockEnabled then
       task.spawn(function()
           local hrp = killer:WaitForChild("HumanoidRootPart",5)
           if hrp then getgenv().AddBoxVisualization(killer) end
       end)
   end
end)

getgenv().KillersFolder.ChildRemoved:Connect(function(killer)
   getgenv().RemoveBoxVisualization(killer)
end)

-- UI部分
local MainBlockTab = Tabs.Block:AddRightTabbox()
local MainGroup = MainBlockTab:AddTab("Block")
local Box = MainBlockTab:AddTab("Box设置")
local BoxGroup = MainBlockTab:AddTab("Box颜色")
local HitboxGroup = MainBlockTab:AddTab("Hitbox视觉")

MainGroup:AddToggle("AutoBlockToggle",{
   Text = "自动格挡",
   Default = false,
   Tooltip = "开启/关闭自动格挡和Box可视化",
   Callback = function(Value)
       getgenv().AutoBlockEnabled = Value
       getgenv().RefreshBoxVisualizations()
   end,
})

MainGroup:AddToggle("KillerFacingCheck",{
   Text = "杀手面向检测",
   Default = false,
   Tooltip = "仅在杀手面向玩家时格挡",
   Callback = function(Value)
       getgenv().KillerFacingCheckEnabled = Value
   end,
})

MainGroup:AddToggle("WallCheck",{
   Text = "Wallcheck",
   Default = false,
   Tooltip = "检测是否有墙体遮挡",
   Callback = function(Value)
       getgenv().wallCheckEnabled = Value
   end,
})

MainGroup:AddSlider("KillerFacingAngle",{
   Text = "杀手面向角度",
   Default = 90,
   Min = 30,
   Max = 180,
   Rounding = 1,
   Tooltip = "杀手面向玩家的角度检测",
   Callback = function(Value)
       getgenv().KillerFacingAngle = Value
   end,
})

MainGroup:AddSlider("MaxSoundAge",{
   Text = "最大声音检测时长(秒)",
   Default = 1.2,
   Min = 0.5,
   Max = 5,
   Rounding = 1,
   Tooltip = "声音播放超过此时长后将被忽略",
   Callback = function(Value)
       getgenv().MaxSoundAge = Value
   end,
})

MainGroup:AddSlider("MaxAnimAge",{
   Text = "最大动画检测时长(秒)",
   Default = 1.5,
   Min = 0.5,
   Max = 5,
   Rounding = 1,
   Tooltip = "动画播放超过此时长后将被忽略",
   Callback = function(Value)
       getgenv().MaxAnimAge = Value
   end,
})

-- Box设置
Box:AddSlider("BoxLength",{
   Text = "Box长度",
   Default = 7.5,
   Min = 1,
   Max = 15,
   Rounding = 1,
   Tooltip = "Box的长度(未应用倍数前)",
   Callback = function(Value)
       getgenv().BoxLength = Value
   end,
})

Box:AddSlider("BoxWidth",{
   Text = "Box宽度",
   Default = 4.5,
   Min = 2,
   Max = 15,
   Rounding = 1,
   Tooltip = "Box的宽度(未应用倍数前)",
   Callback = function(Value)
       getgenv().BoxWidth = Value
   end,
})

Box:AddSlider("BoxHeight",{
   Text = "Box高度",
   Default = 6,
   Min = 2,
   Max = 10,
   Rounding = 1,
   Tooltip = "Box的高度(未应用倍数前)",
   Callback = function(Value)
       getgenv().BoxHeight = Value
   end,
})

Box:AddSlider("BoxSizeMultiplier",{
   Text = "Box整体大小倍数",
   Default = 1.0,
   Min = 0.5,
   Max = 3.0,
   Rounding = 2,
   Tooltip = "Box整体大小的放大倍数",
   Callback = function(Value)
       getgenv().BoxSizeMultiplier = Value
   end,
})

Box:AddSlider("BoxForwardOffset",{
   Text = "Box前后位置",
   Default = -1.4,
   Min = -10,
   Max = 10,
   Rounding = 1,
   Tooltip = "Box在杀手前后方向的偏移(负数向后,正数向前)",
   Callback = function(Value)
       getgenv().BoxForwardOffset = Value
   end,
})

Box:AddSlider("BoxTransparency",{
   Text = "Box透明度",
   Default = 1,
   Min = 0,
   Max = 1,
   Rounding = 2,
   Tooltip = "Box的透明度(0=完全不透明,1=完全透明)",
   Callback = function(Value)
       getgenv().BoxTransparency = Value
   end,
})

BoxGroup:AddLabel("Box安全颜色 (玩家在范围内):")
BoxGroup:AddSlider("BoxSafeColorR",{
   Text = "红色 (R)",
   Default = 0,
   Min = 0,
   Max = 255,
   Rounding = 0,
   Callback = function(Value)
       local current = getgenv().BoxSafeColor
       getgenv().BoxSafeColor = Color3.fromRGB(Value, current.G * 255, current.B * 255)
   end,
})

BoxGroup:AddSlider("BoxSafeColorG",{
   Text = "绿色 (G)",
   Default = 255,
   Min = 0,
   Max = 255,
   Rounding = 0,
   Callback = function(Value)
       local current = getgenv().BoxSafeColor
       getgenv().BoxSafeColor = Color3.fromRGB(current.R * 255, Value, current.B * 255)
   end,
})

BoxGroup:AddSlider("BoxSafeColorB",{
   Text = "蓝色 (B)",
   Default = 0,
   Min = 0,
   Max = 255,
   Rounding = 0,
   Callback = function(Value)
       local current = getgenv().BoxSafeColor
       getgenv().BoxSafeColor = Color3.fromRGB(current.R * 255, current.G * 255, Value)
   end,
})

BoxGroup:AddLabel("Box危险颜色 (玩家不在范围内):")

BoxGroup:AddSlider("BoxDangerColorR",{
   Text = "红色 (R)",
   Default = 255,
   Min = 0,
   Max = 255,
   Rounding = 0,
   Callback = function(Value)
       local current = getgenv().BoxDangerColor
       getgenv().BoxDangerColor = Color3.fromRGB(Value, current.G * 255, current.B * 255)
   end,
})

BoxGroup:AddSlider("BoxDangerColorG",{
   Text = "绿色 (G)",
   Default = 0,
   Min = 0,
   Max = 255,
   Rounding = 0,
   Callback = function(Value)
       local current = getgenv().BoxDangerColor
       getgenv().BoxDangerColor = Color3.fromRGB(current.R * 255, Value, current.B * 255)
   end,
})

BoxGroup:AddSlider("BoxDangerColorB",{
   Text = "蓝色 (B)",
   Default = 0,
   Min = 0,
   Max = 255,
   Rounding = 0,
   Callback = function(Value)
       local current = getgenv().BoxDangerColor
       getgenv().BoxDangerColor = Color3.fromRGB(current.R * 255, current.G * 255, Value)
   end,
})

-- Hitbox视觉效果设置
HitboxGroup:AddToggle("HitboxVisualization",{
   Text = "启用Hitbox视觉效果",
   Default = false,
   Tooltip = "显示放大的杀手Hitbox(大小与Box一致)",
   Callback = function(Value)
       getgenv().HitboxVisualizationEnabled = Value
       if Value then
           getgenv().StartHitboxVisualization()
       else
           getgenv().StopHitboxVisualization()
       end
   end,
})

HitboxGroup:AddSlider("HitboxTransparency",{
   Text = "Hitbox透明度",
   Default = 0.85,
   Min = 0,
   Max = 1,
   Rounding = 2,
   Tooltip = "Hitbox的透明度",
   Callback = function(Value)
       getgenv().HitboxTransparency = Value
   end,
})

HitboxGroup:AddLabel("Hitbox颜色:")
HitboxGroup:AddSlider("HitboxColorR",{
   Text = "红色 (R)",
   Default = 255,
   Min = 0,
   Max = 255,
   Rounding = 0,
   Callback = function(Value)
       local current = getgenv().HitboxColor
       getgenv().HitboxColor = Color3.fromRGB(Value, current.G * 255, current.B * 255)
   end,
})

HitboxGroup:AddSlider("HitboxColorG",{
   Text = "绿色 (G)",
   Default = 255,
   Min = 0,
   Max = 255,
   Rounding = 0,
   Callback = function(Value)
       local current = getgenv().HitboxColor
       getgenv().HitboxColor = Color3.fromRGB(current.R * 255, Value, current.B * 255)
   end,
})

HitboxGroup:AddSlider("HitboxColorB",{
   Text = "蓝色 (B)",
   Default = 255,
   Min = 0,
   Max = 255,
   Rounding = 0,
   Callback = function(Value)
       local current = getgenv().HitboxColor
       getgenv().HitboxColor = Color3.fromRGB(current.R * 255, current.G * 255, Value)
   end,
})



local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("调试")

MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,  
    Text = "快捷菜单",
    Callback = function(value)
        Library.KeybindFrame.Visible = value  
    end,
})


MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "鼠标光标",
    Default = true,  
    Callback = function(Value)
        Library.ShowCustomCursor = Value  
    end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",  
    Text = "通知位置",
    Callback = function(Value)
        Library:SetNotifySide(Value)  
    end,
})

MenuGroup:AddDropdown("DPIDropdown", {
    Values = { "25%", "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "75%",  
    Text = "UI大小",
    Callback = function(Value)
        Value = Value:gsub("%%", "")  
        local DPI = tonumber(Value)   
        Library:SetDPIScale(DPI)      
    end,
})


MenuGroup:AddDivider()  
MenuGroup:AddLabel("Menu bind")  
    :AddKeyPicker("MenuKeybind", { 
        Default = "RightShift",  
        NoUI = true,            
        Text = "Menu keybind"    
    })


MenuGroup:AddButton("销毁UI", function()
    Library:Unload()  
end)




ThemeManager:SetLibrary(Library)  
SaveManager:SetLibrary(Library)   
SaveManager:IgnoreThemeSettings() 


SaveManager:SetIgnoreIndexes({ "MenuKeybind" })  
ThemeManager:SetFolder("MyScriptHub")            
SaveManager:SetFolder("MyScriptHub/specific-game")  
SaveManager:SetSubFolder("specific-place")       
SaveManager:BuildConfigSection(Tabs["UI Settings"])  

ThemeManager:ApplyToTab(Tabs["UI Settings"])

SaveManager:LoadAutoloadConfig()





    Library:SetWatermarkVisibility(true)

    local function updateWatermark()
        local fps = 60
        local frameTimer = tick()
        local frameCounter = 0

        game:GetService('RunService').RenderStepped:Connect(function()
            frameCounter = frameCounter + 1

            if ((tick() - frameTimer) >= 1) then
                fps = frameCounter
                frameTimer = tick()
                frameCounter = 0
            end

            Library:SetWatermark(string.format('Forsaken | %d FPS | XIAOXI SCRIPT |%d ping ', math.floor(fps), math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())))
        end)
    end

    updateWatermark()


