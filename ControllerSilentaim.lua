local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer 
local camera = workspace.CurrentCamera 
local wtvpFunc = camera.WorldToViewportPoint

local mouse = localPlayer:GetMouse() 
local hiddenCharactersFolder = ReplicatedStorage.HiddenCharacters

local function findNearestEnemyHead()
    local maxDistance, target = math.huge 

    for i, v in next, Players.GetPlayers(Players) do 
        if v ~= localPlayer and v.Character.Humanoid.Health > 0 and v.Team ~= localPlayer.Team and v.Character and not hiddenCharactersFolder.FindFirstChild(hiddenCharactersFolder, v.Name) then 
            local enemyCharacter = v.Character 

            if enemyCharacter.FindFirstChild(enemyCharacter, "UpperTorso") then 
                local enemyHead = enemyCharacter.UpperTorso
                local headPos, onScreen = wtvpFunc(camera, enemyHead.Position)
        
                if onScreen then 
                    local mouseDistanceFromEnemyHead = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(headPos.X, headPos.Y)).Magnitude 

                    if mouseDistanceFromEnemyHead < maxDistance then 
                        maxDistance = mouseDistanceFromEnemyHead
                        target = enemyHead
                    end 
                end 
            end 
        end 
    end 
    return target
end 


local oldNamecall; oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local method = getnamecallmethod() 
    local arguments = {...}
    local callingScript = getcallingscript() 

    if method == "Raycast" and findNearestEnemyHead() and tostring(callingScript) == "GunController" then 
        local enemyHead = findNearestEnemyHead() 

       
        arguments[3] = (enemyHead.Position - arguments[2]).Unit * 1000
    end 

    return oldNamecall(unpack(arguments))
end))