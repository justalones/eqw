
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Z PIECE SCRIPT BY NAMELESS SCRIPTS" .. Fluent.Version,
    SubTitle = "",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Aqua",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Auto Farm", Icon = "sword" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "Notification",
        Content = "This is a notification",
        SubContent = "SubContent", -- Optional
        Duration = 5 -- Set to nil to make the notification not disappear
    })


    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    
    local player = Players.LocalPlayer
    local character
    
    local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Farm Nearest Enemy", Default = false})
    
    local continueTeleport = false
    
    local function findNearestEnemy()
        local humanoidEnemies = {} -- Assuming enemies are humanoid models
    
        local enemiesFolder = workspace:FindFirstChild("Enemies")
    
        if not enemiesFolder then
            return nil
        end
    
        for _, enemy in pairs(enemiesFolder:GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChildOfClass("Humanoid") then
                table.insert(humanoidEnemies, enemy)
            end
        end
    
        local nearestEnemy = nil
        local minDistance = math.huge
    
        local playerPosition = character.HumanoidRootPart.Position
    
        for _, enemy in pairs(humanoidEnemies) do
            local enemyPosition = enemy:FindFirstChildOfClass("Humanoid").Parent.HumanoidRootPart.Position
            local distance = (playerPosition - enemyPosition).Magnitude
    
            if distance < minDistance then
                nearestEnemy = enemy
                minDistance = distance
            end
        end
    
        return nearestEnemy
    end
    
    local function teleportInFrontOfEnemy(target)
        if target then
            local playerPosition = character.HumanoidRootPart.Position
            local enemyPosition = target:FindFirstChildOfClass("Humanoid").Parent.HumanoidRootPart.Position
            local direction = (enemyPosition - playerPosition).Unit
    
            local distanceToTeleportInFront = 5 -- Adjust this distance as needed
    
            local newPosition = enemyPosition + (direction * distanceToTeleportInFront)
    
            character:SetPrimaryPartCFrame(CFrame.new(newPosition, enemyPosition))
        else
            print("No target found.")
        end
    end
    
    local function applyBodyVelocity(target)
        if target then
            local playerPosition = character.HumanoidRootPart.Position
            local enemyPosition = target:FindFirstChildOfClass("Humanoid").Parent.HumanoidRootPart.Position
            local direction = (playerPosition - enemyPosition).Unit
    
            local distanceToMoveAway = 5 -- Adjust this distance as needed
    
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = direction * distanceToMoveAway
            bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
            bodyVelocity.P = 5000 -- Adjust this value as needed
    
            bodyVelocity.Parent = character.HumanoidRootPart
    
            RunService.Heartbeat:Wait()
            bodyVelocity:Destroy()
        else
            print("No target found.")
        end
    end
    
    local function isAlive(enemy)
        if enemy and enemy:FindFirstChildOfClass("Humanoid") then
            return enemy:FindFirstChildOfClass("Humanoid").Health > 0
        end
        return false
    end
    
    local function updateTeleport()
        while wait(1) do -- Adjust the delay as needed
            if continueTeleport and character and character:IsA("Model") and character:FindFirstChildOfClass("Humanoid") then
                local targetEnemy = findNearestEnemy()
    
                if targetEnemy then
                    if not isAlive(targetEnemy) then
                        targetEnemy = findNearestEnemy()
                    end
    
                    if continueTeleport then
                        teleportInFrontOfEnemy(targetEnemy)
                    end
                end
            end
        end
    end
    
    local function updateMovement()
        while wait(0.1) do -- Adjust the delay as needed
            if continueTeleport and character and character:IsA("Model") and character:FindFirstChildOfClass("Humanoid") then
                local targetEnemy = findNearestEnemy()
    
                if targetEnemy then
                    applyBodyVelocity(targetEnemy)
                end
            end
        end
    end
    
    local function onCharacterAdded(newCharacter)
        character = newCharacter
    end
    
    local function checkToggle()
        continueTeleport = Toggle.Value
    end
    
    Toggle:OnChanged(checkToggle)
    checkToggle()
    
    player.CharacterAdded:Connect(onCharacterAdded)
    onCharacterAdded(player.Character) -- In case the character already exists when the script runs
    
    spawn(updateTeleport)
    spawn(updateMovement)   


    local isToggleOn = false
    local selectedValue = ""
    
    -- Dropdown creation block
    local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
        Title = "Select Option to Auto Skill",
        Values = {"BUDHA", "BARRIER", "FIRE", "SPIN", "SHADOW", "DRAGON", "DOUGH", "UTA", "ICE", "GHOST", "LIGHT", "SAND", "CHOP", "KILO", "SPIN", "SHADOW MONARCH SWORD", "KAMING WRATH", "VENOM DAGGER"},
        Multi = false,
        Default = 1,
    })
    
    Dropdown:SetValue("four")
    
    Dropdown:OnChanged(function(Value)
        selectedValue = Value
        print("Dropdown changed:", selectedValue)
    end)
    
    -- Toggle creation block
    local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Auto Skill Selected", Default = false })
    
    -- Function to handle actions based on toggle state
    local function HandleToggleAction()
        while isToggleOn do
            print("Toggle changed:", Toggle.Value)
    
            if isToggleOn then
                if selectedValue == "BUDHA" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Buddha.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Buddha.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Buddha.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Buddha.Remotes.v:FireServer(unpack(args))
                elseif dropdownValue == "BARRIER" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Barrier.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Barrier.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Barrier.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Barrier.Remotes.v:FireServer(unpack(args))
                elseif dropdownValue == "BOMB" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Bomb.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Bomb.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Bomb.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Bomb.Remotes.v:FireServer(unpack(args))
                elseif dropdownValue == "VENOM DAGGER" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.VenomDagger.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.VenomDagger.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.VenomDagger.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.VenomDagger.Remotes.v:FireServer(unpack(args))
                elseif dropdownValue == "CHOP" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Chop.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Chop.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Chop.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Chop.Remotes.v:FireServer(unpack(args))
                elseif dropdownValue == "KILO" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Kilo.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Kilo.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Kilo.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Kilo.Remotes.v:FireServer(unpack(args))
                elseif dropdownValue == "SPIN" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Spin.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Spin.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Spin.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Spin.Remotes.v:FireServer(unpack(args))
                elseif dropdownValue == "UTA" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Uta.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Uta.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Uta.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Uta.Remotes.v:FireServer(unpack(args))
                elseif dropdownValue == "DOUGH" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Dough.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Dough.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Dough.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Dough.Remotes.v:FireServer(unpack(args))
                elseif dropdownValue == "GHOST" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Ghost.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Ghost.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Ghost.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Ghost.Remotes.v:FireServer(unpack(args))
                elseif dropdownValue == "LIGHT" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Light.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Light.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Light.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Light.Remotes.v:FireServer(unpack(args))
                elseif dropdownValue == "SAND" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Sand.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Sand.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Sand.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Sand.Remotes.v:FireServer(unpack(args))
                elseif dropdownValue == "ICE" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Ice.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Ice.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Ice.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Ice.Remotes.v:FireServer(unpack(args))
                elseif dropdownValue == "QUAKE" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Quake.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Quake.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Quake.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Quake.Remotes.v:FireServer(unpack(args))
                elseif dropdownValue == "DRAGON" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Dragon.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Dragon.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Dragon.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Dragon.Remotes.v:FireServer(unpack(args))
                elseif dropdownValue == "KAMISH WRATH" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.KamishWrath.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.KamishWrath.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.KamishWrath.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.KamishWrath.Remotes.v:FireServer(unpack(args))
                elseif dropdownValue == "SHADOW MONARCH SWORD" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.ShadowMonarchSword.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.ShadowMonarchSword.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.ShadowMonarchSword.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.ShadowMonarchSword.Remotes.v:FireServer(unpack(args))
                elseif dropdownValue == "SHADOW" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Shadow.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Shadow.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Shadow.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Shadow.Remotes.v:FireServer(unpack(args))
                elseif dropdownValue == "FIRE" then
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Fire.Remotes.z:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Fire.Remotes.x:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Fire.Remotes.c:FireServer(unpack(args))
                    wait(0.2)
                    local args = {
                        [1] = "release"
                    }
                    
                    game:GetService("Players").LocalPlayer.Character.Fire.Remotes.v:FireServer(unpack(args))
                else
                    print("Toggle is ON and unexpected option selected")
                end
            end
            
            wait()
            end
            end
            
            Toggle:OnChanged(function(value)
            isToggleOn = value
            print("Toggle is now:", isToggleOn)
            
            if isToggleOn then
            -- Start the toggle action in a new thread to not block the UI
            spawn(HandleToggleAction)
            end
            end)
            
            if Toggle.Value then
            -- Start the toggle action initially
            spawn(HandleToggleAction)
            end

            local Tabs = {
                Main = Window:AddTab({ Title = "Auto Attack", Icon = "sword" }),
            }

                -- Start of main script block

local isToggleOn = false
local selectedValue = ""

-- Dropdown creation block
local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
    Title = "Select a Weapon",
    Values = {"Combat", "Night Blade", "Katana", "Dual Katana", "Venom Dagger", "Shadow Monarch Sword", "Triple Katana", "The Battle Spear", "Hassaikai", "Mogur", "ThunderPole", "Bisento", "NightBlade", "ShadowBlades", "Gear5 Sword", "Sea Beast Blade"},
    Multi = false,
    Default = 1,
})

Dropdown:SetValue("four")

Dropdown:OnChanged(function(Value)
    selectedValue = Value
    print("Dropdown changed:", selectedValue)
end)

-- Toggle creation block
local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Use Selected Weapon", Default = false })


-- Function to handle actions based on toggle state
local function HandleToggleAction()
    while isToggleOn do
        print("Toggle changed:", Toggle.Value)
        
        if isToggleOn then
            if selectedValue == "Combat" then
                local args = {
                    [1] = "attack"
                }
                
                game:GetService("Players").LocalPlayer.Character.Combat.Remotes.attack:FireServer(unpack(args))                            
            elseif dropdownValue == "Night Blade" then
                local args = {
                    [1] = "attack"
                }
                
                game:GetService("Players").LocalPlayer.Character.NightBlade.Remotes.attack:FireServer(unpack(args))   
            elseif dropdownValue == "Katana" then
                local args = {
                    [1] = "attack"
                }
                
                game:GetService("Players").LocalPlayer.Character.Katana.Remotes.attack:FireServer(unpack(args)) 
            elseif dropdownValue == "Dual Katana" then
                local args = {
                    [1] = "attack"
                }
                
                game:GetService("Players").LocalPlayer.Character.DualKatana.Remotes.attack:FireServer(unpack(args)) 
            elseif dropdownValue == "Venom Dagger" then
                local args = {
                    [1] = "attack"
                }
                
                game:GetService("Players").LocalPlayer.Character.VenomDagger.Remotes.attack:FireServer(unpack(args))
            elseif dropdownValue == "Shark Blade" then
                local args = {
                    [1] = "attack"
                }
                
                game:GetService("Players").LocalPlayer.Character.SharkBlade.Remotes.attack:FireServer(unpack(args))
            elseif dropdownValue == "Mogur" then
                local args = {
                    [1] = "attack"
                }
                
                game:GetService("Players").LocalPlayer.Character.Mogur.Remotes.attack:FireServer(unpack(args))
            elseif dropdownValue == "Triple Katana" then
                local args = {
                    [1] = "attack"
                }
                
                game:GetService("Players").LocalPlayer.Character.TripleKatana.Remotes.attack:FireServer(unpack(args))
            elseif dropdownValue == "Thunder Pole" then
                local args = {
                    [1] = "attack"
                }
                
                game:GetService("Players").LocalPlayer.Character.ThunderPole.Remotes.attack:FireServer(unpack(args))
            elseif dropdownValue == "Bisento" then
                local args = {
                    [1] = "attack"
                }
                
                game:GetService("Players").LocalPlayer.Character.Bisento.Remotes.attack:FireServer(unpack(args))
            elseif dropdownValue == "Shadow Blades" then
                local args = {
                    [1] = "attack"
                }
                
                game:GetService("Players").LocalPlayer.Character.ShadowBlades.Remotes.attack:FireServer(unpack(args))
            elseif dropdownValue == "Sea Beast Blade" 
            local args = {
                [1] = "attack"
            }
            
            game:GetService("Players").LocalPlayer.Character.SeaBeastBlade.Remotes.attack:FireServer(unpack(args))
            elseif dropdownValue == "Hassaikai" then
                local args = {
                    [1] = "attack"
                }
                
                game:GetService("Players").LocalPlayer.Character.Hassaikai.Remotes.attack:FireServer(unpack(args))
            elseif dropdownValue == "Gear5 Sword" then
                local args = {
                    [1] = "attack"
                }
                
                game:GetService("Players").LocalPlayer.Character.Gear5Sword.Remotes.attack:FireServer(unpack(args))
            elseif dropdownValue == "The Battle Spear" then
                local args = {
                    [1] = "attack"
                }
                
                game:GetService("Players").LocalPlayer.Character.TheBattleSpear.Remotes.attack:FireServer(unpack(args))
            else
                print("Toggle is ON and unexpected option selected")
            end
        end
        
        wait()
    end
end

Toggle:OnChanged(function(value)
    isToggleOn = value
    print("Toggle is now:", isToggleOn)
    
    if isToggleOn then
        -- Start the toggle action in a new thread to not block the UI
        spawn(HandleToggleAction)
    end
end)

if Toggle.Value then
    -- Start the toggle action initially
    spawn(HandleToggleAction)
end

local Tabs = {
    Main = Window:AddTab({ Title = "Misc", Icon = "star" }),
}

    local Keybind = Tabs.Main:AddKeybind("Keybind", {
        Title = "KeyBind",
        Mode = "Toggle", -- Always, Toggle, Hold
        Default = "LeftControl", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

        -- Occurs when the keybind is clicked, Value is `true`/`false`
        Callback = function(Value)
            print("Keybind clicked!", Value)
        end,

        -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
        ChangedCallback = function(New)
            print("Keybind changed!", New)
        end
    })

    -- OnClick is only fired when you press the keybind and the mode is Toggle
    -- Otherwise, you will have to use Keybind:GetState()
    Keybind:OnClick(function()
        print("Keybind clicked:", Keybind:GetState())
    end)

    Keybind:OnChanged(function()
        print("Keybind changed:", Keybind.Value)
    end)

    task.spawn(function()
        while true do
            wait(1)

            -- example for checking if a keybind is being pressed
            local state = Keybind:GetState()
            if state then
                print("Keybind is being held down")
            end

            if Fluent.Unloaded then break end
        end
    end)

    Keybind:SetValue("MB2", "Toggle") -- Sets keybind to MB2, mode to Hold


    local Input = Tabs.Main:AddInput("Input", {
        Title = "Input",
        Default = "Default",
        Placeholder = "Placeholder",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(Value)
            print("Input changed:", Value)
        end
    })

    Input:OnChanged(function()
        print("Input updated:", Input.Value)
    end)
end


-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
