local run = game:GetService("RunService")
local rep = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local starterGui = game:GetService("StarterGui")
local debris = game:GetService("Debris")
local tweenService = game:GetService("TweenService")
local lighting = game:GetService("Lighting")
local contentService = game:GetService("ContentProvider")
local contextAction = game:GetService("ContextActionService")
local teleService = game:GetService("TeleportService")
local market = game:GetService("MarketplaceService")
--[[
Little Note For Future Development. I disabled Voodoo from prompting up for new players because VOID will be added, meaning they will have to go to void for it.
CodyMeys
]]
local MainCounter = 0

local spawnLocations = {}
for _,v in next,workspace.SpawnParts:GetChildren() do
spawnLocations[#spawnLocations+1] = CFrame.new(v.CFrame.p)
end

lighting.Bloom.Intensity = 1
lighting.Bloom.Size = 13

starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)

coroutine.wrap(function()
    local timeout = 1
    local t = tick()
    while not pcall(game.StarterGui.SetCore, game.StarterGui, "TopbarEnabled", false) and tick()-t<timeout do
        wait()
    end
end)()

local resetBindable = Instance.new("BindableEvent")
resetBindable.Event:connect(function()
if not game.Players.LocalPlayer.Character.Head:FindFirstChild("LogNotice")  then
game.Players.LocalPlayer.Character:BreakJoints()
else
functionBank.CreateNotification("You can't reset in combat",Color3.fromRGB(255,0,0),4)
end 
end)

local setCoreDelay = coroutine.wrap(function()
wait()
starterGui:SetCore("ResetButtonCallback", resetBindable)
end)
setCoreDelay()


--starterGui:SetCore("SetAvatarContextMenuEnabled", true)
--print("avatar context  true")
--To add your own custom options to the menu use the following example:

--local TestEvent = Instance.new("BindableEvent")
--local args = {}
--args[1] = "Tribe Invite"
--args[2] = TestEvent
--starterGui:SetCore("AddAvatarContextMenuOption",args)
--print("adding business")
--cd = TestEvent.Event:connect(function(targetPlayer)
--print("dat event fired")
--rep.Events.TribeInvite:FireServer(targetPlayer.Name)
--end)


local defaultData = require(rep.Modules.DefaultData)
local colorData = require(rep.Modules.ColorData)
local itemData = require(rep.Modules.ItemData)
local levelData = require(rep.Modules.LevelData)
local cosmeticData = require(rep.Modules.CosmeticData)
local patchNotes = require(rep.Modules.PatchNotes)
local ambientData = require(rep.Modules.AmbientData)

--[[
local sounds = {
-- nature
Nature = {
Rain =  "rbxassetid://258063500",
Field =  "http://www.roblox.com/asset/?id=159798309",
Thunder =  "rbxassetid://278321082",
Campfire =  "rbxassetid://1283547333",
Cave =  "http://www.roblox.com/asset/?id=206166604",
AncientDespair =  "http://www.roblox.com/asset/?id=155791979",
Wind =  "rbxassetid://1124255533",
Echoes =  "rbxassetid://172313730",
},
Quicks = {
},

}

--]]

-- preload everything from itemData
--local assetsToPreload = {}
--for itemName,itemInfo in next,itemData do
--if itemInfo.image then
--assetsToPreload[#assetsToPreload+1] = itemInfo.image
--end
--end
--local preloadRoutine = coroutine.wrap(function() 
--contentService:PreloadAsync(assetsToPreload)
--end)
--preloadRoutine()


local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local char
local root
local hum
local head

local tper -- pie was here // this will be used for tpauth.
local tpType -- this will be used for way-way direction.

local firstSpawn = true
local raftTut = true

local currentWalkSpeed = 16
local charActive = false
local moveAllowed = false
local cam
local camFocus
local camOffsetMin,camOffsetMax
local camRot = 0
local zoomLevel = 17
local camOffset = Vector3.new(25,17,-25)
local rmbHeld = false
local dragObject
local mouseBoundStructure
local buildingRotation = 0
local selectionTarget
local hasShifted = false

local hideOthers = false

local bodyRotSpeed = .2125

local activateHeld = false
local drawBack = 0

local ignoreLastSwing = false
local draggingIcon

local lockTorsoOrientation = true

local lastInventoryCategory = "all"

local rainPart = nil

local collisionDetect = Instance.new("Part")
collisionDetect.Transparency = 1
collisionDetect.CanCollide = false
collisionDetect.Anchored = true
collisionDetect.Touched:connect(function()
end)

local anims = {}
ping = 0

_G.data = rep.Events.RequestData:InvokeServer()
--tribes = rep.Events.RequestTribeData:InvokeServer()
--repeat _G.data = rep.Events.RequestData:InvokeServer() if not _G.data then wait() end until _G.data

game:GetService("ContentProvider"):PreloadAsync(game.ReplicatedStorage.Animations:GetChildren())

local playerGui = player:WaitForChild("PlayerGui")
--local isolatedHack = script:WaitForChild("IsolatedHack")
--if player.Name == "LollyLeeloo" then
--	isolatedHack.Disabled = false
--end
playerGui:SetTopbarTransparency(1)

local mainGui = playerGui:WaitForChild("MainGui")
local secondaryGui = playerGui:WaitForChild("SecondaryGui")
local spawnGui = playerGui:WaitForChild("SpawnGui")
local backpack = player:WaitForChild("Backpack")
backpack.ChildAdded:connect(function()
player:Kick()
end)

local busyTags = {}

local noteSerializer = 1
local maxNotifications = 3

bodyColorList = {
["LeftUpperLeg"] = true,
["LeftLowerLeg"] = true,
["LeftFoot"] = true,
["RightUpperLeg"] = true,
["RightLowerLeg"] = true,
["RightFoot"] = true,
["UpperTorso"] = true,
["LowerTorso"] = true, 
}

skinColorList = {
LeftUpperArm = true,
LeftLowerArm = true,
LeftHand = true,
RightUpperArm = true,
RightLowerArm = true,
RightHand = true,
Head = true,
}

-- for the clan creator
local chosenColor,chosenWay = nil,"yeet"

if not uis.MouseEnabled then
--print("MOUSE NOT DETECTED")
mainGui.Panels.Stats.SpellImage.ImageButton.TouchTap:connect(function()
--print("TAPPED")
local part,pos,norm,mat = functionBank.CursorRay()
rep.Events.VoodooSpell:FireServer(pos)
end)
else
--print("MOUSE DETECTED")
mainGui.Panels.Stats.SpellImage.ImageButton.Activated:connect(function()
--print("CLICKED")
local part,pos,norm,mat = functionBank.CursorRay()
rep.Events.VoodooSpell:FireServer(pos)
end)
end


for _,v in next,mainGui.Panels.VoodooSelect.List:GetChildren() do
if v:IsA("ImageButton") then
v.Activated:connect(function()
mainGui.Panels.VoodooSelect.Chosen.Value = v.Name
mainGui.Panels.VoodooSelect.DescFrame.DescText.Text = itemData[v.Name].description
-- make all grey, make it green(?)
for _,k in next,mainGui.Panels.VoodooSelect.List:GetChildren() do
if k:IsA("ImageButton") and k ~= v then
k.BackgroundColor3 = Color3.fromRGB(0,0,0)
elseif k == v then
k.BackgroundColor3 = Color3.fromRGB(200,200,200)
end
end
end)
end
end

-- Cody was here, disabled vodooo for new players, since void is now a thing =D

mainGui.Panels.VoodooSelect.ConfirmButton.Activated:connect(function()
local chosenVal = mainGui.Panels.VoodooSelect.Chosen.Value
if chosenVal and chosenVal ~= "" then
-- tell the server, make the tutorial visible
rep.Events.PromptSpellChoice:FireServer(chosenVal)
mainGui.Panels.VoodooTutorial.Visible = true
mainGui.Panels.VoodooSelect.Visible = false
end
end)

mainGui.Panels.VoodooTutorial.ExitButton.Activated:connect(function()
mainGui.Panels.VoodooTutorial.Visible = false
end)


--mainGui.Primary.Tribe.NewTribe.Frame.Frame.CancelButton.InputBegan:connect(function(input,gp)
--if functionBank.InteractInput(input,gp) then
--functionBank.TogglePrimaryMenu("Tribe",false)
--end
--end)

mainGui.Panels.UpdateNotifier.Backdrop.ConfirmButton.Activated:connect(function()
mainGui.Panels.UpdateNotifier.Visible = false
end)

mainGui.Panels.PurchaseConfirm.Backdrop.ExitButton.Activated:connect(function()
mainGui.Panels.PurchaseConfirm.Visible = false
end)

mainGui.Panels.PurchaseConfirm.Backdrop.ConfirmButton.Activated:connect(function()
rep.Events.PurchaseMojoItem:FireServer(mainGui.Panels.PurchaseConfirm.Backdrop.LastSelected.Value)
mainGui.Panels.PurchaseConfirm.Visible = false
end)

for _,frame in next,mainGui.LeftPanel.Mojo.Lists.MojoList:GetChildren() do
if frame:IsA("Frame") then
local itemInfo = itemData[frame.Name]
--print("frame name is",frame.Name)
if itemInfo.toggleable then
	frame.TextButton.Activated:connect(function()
		rep.Events.ToggleMojo:FireServer(frame.Name)
	end)
end

frame.ImageButton.Activated:connect(function()
if functionBank.HasMojoRecipe(frame.Name) then
functionBank.CreateNotification("You already own this", Color3.fromRGB(255,255,111),2)
return
end

mainGui.Panels.PurchaseConfirm.Backdrop.ItemDescription.Text = itemInfo.description
mainGui.Panels.PurchaseConfirm.Backdrop.LastSelected.Value = frame.Name
mainGui.Panels.PurchaseConfirm.Backdrop.ItemNameLabel.Text = string.upper(frame.Name)
mainGui.Panels.PurchaseConfirm.Backdrop.ImageLabel.Image = itemInfo.image

if itemInfo.mojoCost then
	if itemInfo.mojoCost > 1 then
		mainGui.Panels.PurchaseConfirm.Backdrop.MojoCost.Text = itemInfo.mojoCost.." mojo points"
	elseif itemInfo.mojoCost == 1 then
		mainGui.Panels.PurchaseConfirm.Backdrop.MojoCost.Text = itemInfo.mojoCost.." mojo point"
	end
	mainGui.Panels.PurchaseConfirm.Backdrop.ConfirmButton.Visible = true
else
	-- no cost
	mainGui.Panels.PurchaseConfirm.Backdrop.MojoCost.Text = "Event Item - Not For Sale"
	mainGui.Panels.PurchaseConfirm.Backdrop.ConfirmButton.Visible = false
end

mainGui.Panels.PurchaseConfirm.Visible = true

end)
end
end

mainGui.Panels.MojoConfirm.LevelUpFrame.ExitButton.Activated:connect(function()
mainGui.Panels.MojoConfirm.Visible = false
end)

mainGui.Panels.MojoConfirm.LevelUpFrame.ConfirmButton.Activated:connect(function()
mainGui.Panels.MojoConfirm.Visible = false
rep.Events.Rebirth:FireServer()
end)

mainGui.LeftPanel.Mojo.RebirthButton.Activated:connect(function()
mainGui.Panels.MojoConfirm.Visible = true
end)

mainGui.Panels.Unban.Backdrop.YesButton.Activated:connect(function()
market:PromptProductPurchase(player,1082519935)
end)

mainGui.LeftPanel.NewTribe.Frame.CreateButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
if chosenColor and chosenWay then
-- fire the server to create a new clan
rep.Events.CreateTribe:FireServer(chosenColor,chosenWay)
rep.LocalSounds.Quicks.TribeSound:Play()
--functionBank.TogglePrimaryMenu("Tribe",true)
functionBank.DrawTribeGui()
end
end
end)

mainGui.LeftPanel.Tribe.LeaveButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
rep.Events.TribeLeave:FireServer()
end
end)

mainGui.LeftPanel.Tribe.TotemButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
local tribeKey,tribeData = functionBank.IsInTribe()
if tribeData and tribeData.chief == player.Name then
-- they are the chief, let's make sure
if not workspace.Totems:FindFirstChild(tribeData.color.." Tribe") then
local totemClone = rep.Deployables["Tribe Totem"]:Clone()
--totemClone.Name = "Totem"
functionBank.BindMouseStructure(totemClone)
end
else
functionBank.CreateNotification("Only the Chief can make a Totem!",colorData.badRed,2)
end
end
end)


for _,v in next,mainGui.RightPanel.Inventory.ArmorFrame.Selection:GetChildren() do
if v:IsA("ImageButton") then
v.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
if _G.data.armor[v.Name] and _G.data.armor[v.Name] ~= "none" then
rep.Events.UnequipArmor:FireServer(_G.data.armor[v.Name])
end
end
end)
end
end

secondaryGui.PlayerList.List.ActionPanel.KickButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
local targetPlayerName = secondaryGui.PlayerList.List.ActionPanel.TargetPlayerName.Value
if targetPlayerName then
local targetPlayer = game.Players:FindFirstChild(targetPlayerName)
if targetPlayer then
rep.Events.TribeKick:FireServer(targetPlayer)
secondaryGui.PlayerList.List.ActionPanel.Visible = false
end
end
end
end)

secondaryGui.PlayerList.List.ActionPanel.CancelButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
secondaryGui.PlayerList.List.ActionPanel.Visible = false
end
end)

secondaryGui.PlayerList.List.ActionPanel.InviteButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
rep.Events.TribeInvite:FireServer(game.Players:FindFirstChild(secondaryGui.PlayerList.List.ActionPanel.TargetPlayerName.Value))
secondaryGui.PlayerList.List.ActionPanel.Visible = false
end
end)

mainGui.Mobile.StructureButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
PlaceStructureFunction()
end
end)


for _,button in next,mainGui.LeftPanel.Craft.Selection:GetChildren() do
if button:IsA("ImageButton") then
button.InputBegan:connect(function(input,gp)

if functionBank.InteractInput(input,gp) then
-- make them all grey
button.ActiveImage.Visible  = true
for _,v in next,mainGui.LeftPanel.Craft.Selection:GetChildren() do
if v:IsA("ImageButton") and v ~= button then
v.ActiveImage.Visible = false
end
end
functionBank.DrawCraftMenu(button.Category.Value)
end
end)
end
end

mainGui.LeftPanel.Craft.SearchBar.Changed:connect(function(property)
if property == "Text" then
if mainGui.LeftPanel.Craft.SearchBar.Text == "" then
functionBank.DrawCraftMenu("all")
else
for _,v in next,mainGui.LeftPanel.Craft.Selection:GetChildren() do
if v:IsA("ImageButton") then
v.BackgroundColor3 = colorData.ironGrey
end
end

functionBank.DrawCraftMenu("all",mainGui.LeftPanel.Craft.SearchBar.Text)
end
end
end)

for _,button in next,mainGui.RightPanel.Inventory.Selection:GetChildren() do
if button:IsA("ImageButton") then
button.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
-- make them all grey
button.ActiveImage.Visible  = true
for _,v in next,mainGui.RightPanel.Inventory.Selection:GetChildren() do
if v:IsA("ImageButton") and v ~= button then
v.ActiveImage.Visible = false
end
end
--print("redrawing with category")
functionBank.DrawInventory(button.Category.Value)
lastInventoryCategory = button.Category.Value
end
end)
end
end

mainGui.RightPanel.Inventory.RedoAvatarButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
rep.Events.RedoAvatar:FireServer()
end
end)

local chestdb = false
for _,chestFrame in next,mainGui.LeftPanel.Shop.Lists.ChestList:GetChildren() do
if chestFrame:IsA("Frame") then
chestFrame.OpenButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
if chestFrame.OpenButton.Text ~= "OPEN" then
--market:PromptProductPurchase(player,chestFrame.OpenButton.ProductId.Value)
functionBank.CreateNotification("You don't have any "..chestFrame.Name.."s.",colorData.badRed,2)
elseif player.Name == "y" then
if not chestdb then
chestdb = true
rep.Events.ChestDrop:FireServer(chestFrame.Name)
wait(0.1)
chestdb = false
end
else					
if not chestdb then
chestdb = true
rep.Events.ChestDrop:FireServer(chestFrame.Name)
functionBank.CreateNotification("Rate limited. 1 chest per second.")
wait(1)
chestdb = false
end
end
end
end)

chestFrame.BuyButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
rep.Events.PurchaseChest:FireServer(chestFrame.Name)
end
end)

end -- end of if is a frame
end


for _,button in next,mainGui.LeftPanel.Shop.Selection:GetChildren() do
if button:IsA("ImageButton") then
button.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
--print("input on button")


-- make them all invisible and set the colors of the buttons to grey
mainGui.LeftPanel.Shop.CategoryTitle.Text = button.Name
for _,frame in next,mainGui.LeftPanel.Shop.Lists:GetChildren() do
if frame:IsA("Frame") or frame:IsA("ScrollingFrame") then
if frame ~= button.Pointer.Value then
--print("frame",frame.Name,"is not the pointer value, which is",button.Pointer.Value)
frame.Visible = false
else
--print("frame",frame.Name,"matches pointer val",button.Pointer.Value)
frame.Visible = true
end
end
end


for _,otherButton in next,mainGui.LeftPanel.Shop.Selection:GetChildren() do
if otherButton:IsA("ImageButton") then
if otherButton ~= button then
otherButton.BackgroundColor3 = colorData.ironGrey
else
otherButton.BackgroundColor3 = colorData.goodGreen
end
end
end

end -- end of interactinput
end)
end
end


mainGui.LeftPanel.Market.SubmitButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
local selectedName = mainGui.LeftPanel.Market.Selected.Value
local selectedQuantity = mainGui.LeftPanel.Market.SelectedQuantity.Value
local goldQuantity = mainGui.LeftPanel.Market.GoldQuantity.Value
if selectedName and selectedQuantity >= 1 and goldQuantity >=1 then
rep.Events.SubmitTrade:FireServer(selectedName,selectedQuantity,goldQuantity)
else
functionBank.CreateNotification("Complete the form!",colorData.badRed,3)
end
end
end)


	
mainGui.LeftPanel.Market.SearchBar.Changed:connect(function()
if #mainGui.LeftPanel.Market.SearchBar.Text then
for _,itemFrame in next,mainGui.LeftPanel.Market.Lists.AllList:GetChildren() do
if itemFrame:IsA("Frame") then
if not itemFrame.Name:lower():match(mainGui.LeftPanel.Market.SearchBar.Text:lower()) then
itemFrame.Visible = false
else
itemFrame.Visible = true
end
end
end
--
--for _,itemFrame in next,mainGui.LeftPanel.Market.Lists.AllList:GetChildren() do
--if itemFrame:IsA("Frame") then
--itemFrame.Visible = true
--end
--end
end
end)


mainGui.LeftPanel.Market.GoldTextBox.Changed:connect(function()
local text = mainGui.LeftPanel.Market.GoldTextBox.Text
local num = tonumber(text) 
if num then
mainGui.LeftPanel.Market.GoldQuantity.Value = num
end
end)


mainGui.LeftPanel.Market.HowManyTextBox.Changed:connect(function()
local text = mainGui.LeftPanel.Market.HowManyTextBox.Text
local num = tonumber(text) 
if num then
mainGui.LeftPanel.Market.SelectedQuantity.Value = num
end
end)


local projectiles = {
-- arrow template
--arrow = {
--position = Vector3.new(-6, 130.5, -15),
--velocity = Vector3.new(0,100,300),
--acceleration = Vector3.new(0,-196.2,0),
--object = workspace:WaitForChild("Arrow")
-- age = 0,
-- owned = true,
--}

}

function PhaseThing(thing,yeet) -- true bring them in, false bring them out
if yeet then
thing.Parent = workspace
else
thing.Parent = rep
end
end

game.Players.PlayerAdded:connect(function(otherPlayer)
if not otherPlayer == player then
otherPlayer.CharacterAdded:connect(function(otherChar)
if hideOthers then
PhaseThing(otherChar)
end
end)
end
end)

function ToggleOtherCharacters(toggle)
for _,otherPlayer in next,game.Players:GetPlayers() do
if otherPlayer ~= player then
if otherPlayer.Character then
PhaseThing(otherPlayer.Character,toggle)
end
end
end
end

run.RenderStepped:connect(function(dt)
for key,projectileData in next,projectiles do
if os.time()-projectiles[key].age > 6.5 then -- if it's too old
projectiles[key].object:Destroy()
table.remove(projectiles,key)
else

local oldPos = projectiles[key].position
projectiles[key].velocity = projectileData.velocity + (projectileData.acceleration*dt)
projectiles[key].position = projectileData.position+ (projectileData.velocity*dt)
local direction = projectiles[key].position-oldPos

if projectiles[key].object:IsA("Model")  then
projectiles[key].object:SetPrimaryPartCFrame(CFrame.new(projectiles[key].position,projectiles[key].position+direction))
else
projectiles[key].object.CFrame = CFrame.new(projectiles[key].position,projectiles[key].position+direction)
end


local part,pos,norm,mat = workspace:FindPartOnRay(Ray.new(oldPos,(projectiles[key].position-oldPos)),projectiles[key].object)
if part and (part.CanCollide or part.Transparency <1) or (part == workspace.Terrain and not mat == Enum.Material.Water) then
local asdf = Instance.new("Part")
asdf.Size = Vector3.new(.6,.6,.6)
asdf.Anchored = true
asdf.Transparency = 1
asdf.CanCollide = false
asdf.CFrame = CFrame.new(pos)
asdf.Parent = workspace
local projDistance = (player.Character.PrimaryPart.Position-pos).magnitude
if projectiles[key].owned then
rep.Events.DequipCosmetic:FireServer(part,pos,projectiles[key],projDistance)

local impacted
if (part:FindFirstChild("Health") or (part.Parent and part.Parent:FindFirstChild("Health"))) and (part:FindFirstChild("Health") or (part.Parent and part.Parent:FindFirstChild("Health"))):IsA("IntValue") then
impacted = true
end
for _,v in next,game.Players:GetPlayers() do
if v.Character then
if part:IsDescendantOf(v.Character) then
impacted = true
end
end
end

if impacted then
functionBank.CreateSound(rep.LocalSounds.Quicks.HitMarker,playerGui)
end


end
--projectiles[key].object:Destroy()
debris:AddItem(projectiles[key].object,2)
projectiles[key].object.Transparency = 1
table.remove(projectiles,key)


end
end
end
end)

rep.Events.CreateProjectile.OnClientEvent:connect(function(p, o, projectileData)
MakeProjectile(projectileData.toolName,projectileData.originCF,projectileData.drawStrength,projectileData.owner)
end)

function MakeProjectile(toolName,originCF,drawStrength,owner)

local projectileName = itemData[toolName].projectileName
local newProjectile = rep.Projectiles:FindFirstChild(projectileName):Clone()
newProjectile.CFrame = originCF
local projectileTable = {
origin = originCF.p,
position = originCF.p,
velocity = originCF.lookVector*(math.clamp(itemData[toolName].velocityMagnitude*drawStrength,100,500)),
acceleration = Vector3.new(0,-196.2,0),
age = os.time(),
toolFrom = toolName,
object = newProjectile
}
if (mouse.hit.p-root.Position).magnitude > 50 then
projectileTable.velocity = projectileTable.velocity+Vector3.new(0,15,0)
end
projectileTable.owned = owner or false
--print(itemData[projectileName].velocityMagnitude,drawStrength)
projectiles[#projectiles+1] = projectileTable
newProjectile.Parent = workspace

if owner then
rep.Events.CreateProjectile:FireServer({
["originCF"] = originCF,
["drawStrength"] = drawStrength,
["toolName"] = toolName,
})
end

end


-- vars for the functionbank
local rayIgnore = {}
local lastToast,toastWait = 0,0
local currentToast = 1
local lastCraftCategory,lastCraftSearch = "all",nil
--mimic = rep.Creatures.Mimic:Clone()
--mimic.Parent = workspace


for  _,coinFrame in next,mainGui.RightPanel.Shop.List:GetChildren() do
if coinFrame:IsA("Frame") then
coinFrame.OpenButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
market:PromptProductPurchase(player,coinFrame.OpenButton.ProductId.Value) -- 123456
end
end)
end
end

for  _,gemFrame in next,mainGui.RightPanel.Shop.List:GetChildren() do
if gemFrame:IsA("Frame") then
gemFrame.OpenButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
market:PromptProductPurchase(player,gemFrame.OpenButton.ProductId.Value) -- 123456
end
end)
end
end

functionBank = {

["ChangeSkybox"] = function(skyboxName)
for _,v in next,lighting:GetChildren() do
if v:IsA("Sky") then
v:Destroy()
end
end
-- new skybox
local newSkybox = rep.Skies:FindFirstChild(skyboxName):Clone()
newSkybox.Parent = lighting
end,

["DoomWeather"] = function()
functionBank.ChangeSkybox("Doom")
lighting.FogEnd = ambientData.doomSuite.fogDist
lighting.FogColor = ambientData.doomSuite.fogColor
lighting.Brightness = ambientData.doomSuite.brightness
end,

["SunnyDays"] = function()
functionBank.ChangeSkybox("Shine")
lighting.FogEnd = ambientData.shineSuite.fogDist
lighting.FogColor = ambientData.shineSuite.fogColor
lighting.Brightness = ambientData.shineSuite.brightness
end,

["MakeItSnow"] = function(toggle)
if toggle then
snowPart = rep.Misc.SnowPart:Clone()
snowPart.Parent = workspace
else -- if toggle is false
for _, v in next,workspace:GetChildren() do
if v.Name == "SnowPart" then
v:Destroy()
end
end
end
end,

["MakeItRain"] = function(toggle)
if toggle then
rainPart = rep.Misc.RainPart:Clone()
rainPart.Parent = workspace
rep.LocalSounds.Nature.Rain:Play()
rep.LocalSounds.Nature.Thunder:Play()
functionBank.ChangeSkybox("Rain")
lighting.FogEnd = ambientData.rainSuite.fogDist
lighting.FogColor = ambientData.rainSuite.fogColor
lighting.Brightness = ambientData.rainSuite.brightness
--if rainPart then
--rainPart.CFrame = root.CFrame*CFrame.new(0,100,0)
----local ray = Ray.new(char.Head.Position,Vector3.new(0,50,0))
----local part,pos,norm,mat = workspace:FindPartOnRay(ray,char) 
----if part then
----rainPart.Parent = nil
----else
----rainPart.Parent = workspace
----end
--run.Stepped:wait()
--end

else -- if toggle is false
for _,v in next,workspace:GetChildren() do
if v.Name == "RainPart" then
v:Destroy()
end
end
rep.LocalSounds.Nature.Rain:Stop()
rep.LocalSounds.Nature.Thunder:Stop()
end
end,


["RestorePhysicality"] = function(thing)
if thing:IsA("BasePart") then
thing.Anchored = false
thing.CanCollide = true
elseif thing:IsA("Model") then
for _,v in next,thing:GetDescendants() do
if v:IsA("BasePart") then
v.Anchored = false
v.CanCollide = true
end
end
end
end,

["CursorRay"] = function(ignoreInstance)
local screenRay = cam:ScreenPointToRay(mouse.x,mouse.y)
local newRay = Ray.new(screenRay.Origin,screenRay.Direction*250)
local part,pos,norm,mat = workspace:FindPartOnRay(newRay,ignoreInstance or char)
return part,pos,norm,mat
end,

["MiddleScreenRay"] = function(ignoreInstance)
local screenRay = cam:ScreenPointToRay(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)
local newRay = Ray.new(screenRay.Origin,screenRay.Direction*9999)
local part,pos,norm,mat = workspace:FindPartOnRay(newRay,ignoreInstance or workspace)
return part,pos,norm,mat
end,

["FirstPartOnRay"] = function(ray,ignoreInstance)
local part,pos,norm,mat = workspace:FindPartOnRay(ray,ignoreInstance)
return part,pos,norm,mat
end,

["UpdateTrades"] = function(trades)
-- clear the old trades list
for _,tradeFrame in next,mainGui.RightPanel.Market.List:GetChildren() do
	if tradeFrame:IsA("Frame") then
		tradeFrame:Destroy()
	end
end

-- add new frames
for tradeKey, tradeData in next, (trades or {}) do
	if not tradeData.bought then
		local tradeFrame = mainGui.RightPanel.Market.Templates.OfferFrame:Clone()
		--tradeFrame.OfferId.Value = tradeData.tradeId
		tradeFrame.GetIcon.Image = itemData[tradeData.giveName].image
		--tradeFrame.GiveIcon = "rbxassetid:/1452604544"
		tradeFrame.GetTitle.Text = tradeData.giveQuantity..' '..tradeData.giveName
		tradeFrame.GiveTitle.Text = tradeData.getCoins..' Coin'..(tradeData.getCoins > 1 and 's' or '')
		tradeFrame.From.Text = "Seller: "..tradeData.trader
		
		if tradeData.trader == player.Name then
			tradeFrame.BuyButton.Text = 'CANCEL'
			tradeFrame.BuyButton.BackgroundColor3 = colorData.badRed
		else
			tradeFrame.BuyButton.Text = 'Buy'
			tradeFrame.BuyButton.BackgroundColor3 = colorData.goodGreen
		end
		
		tradeFrame.Visible = true
		tradeFrame.Parent = mainGui.RightPanel.Market.List
		tradeFrame.BuyButton.InputBegan:connect(function(input, gp)
			if functionBank.InteractInput(input, gp) then
				rep.Events.AcceptTrade:FireServer(tradeKey)
			end
		end)
	end
end

local firstFrame = mainGui.RightPanel.Market.List:FindFirstChildOfClass("Frame")
local absY = 5
if firstFrame then
absY = firstFrame.AbsoluteSize.Y
end

mainGui.RightPanel.Market.List.CanvasSize = UDim2.new(0,0,0,300+(#mainGui.RightPanel.Market.List:GetChildren()*absY))

end,

["UpdateBoosts"] = function() -- Cody was here (fixed it hehehehehehe)
-- clear the old boosts
for _,frame in next,mainGui.LeftPanel.Shop.Lists.BoostList:GetChildren() do
if frame:IsA("Frame") then
frame:Destroy()
end
end

for itemKey,itemInfo in next,itemData do
if itemInfo.fruit and not itemInfo.cakey then -- if its a coin hat
local newFrame = mainGui.LeftPanel.Shop.Templates.MarketFrame:Clone()
if itemInfo.cost then
	newFrame.TextButton.Text = itemInfo.cost
end

newFrame.ImageButton.Image = itemInfo.image or ""
newFrame.AmountGiven.Text = itemInfo.amount .. " "..itemInfo.itemgiven
newFrame.ItemNameLabel.Text = itemInfo.itemgiven
newFrame.TextButton.Text = itemInfo.cost.." ".."Gold"
newFrame.LayoutOrder = itemInfo.shopOrder
newFrame.Visible = true
newFrame.Parent = mainGui.LeftPanel.Shop.Lists.BoostList
newFrame.ImageButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
rep.Events.PurchaseFromShop:FireServer(itemKey,itemInfo.itemgiven)
end
end)

newFrame.TextButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
rep.Events.PurchaseFromShop:FireServer(itemKey,itemInfo.itemgiven)
--print("asking for purchase")
end
end)
end
if  itemInfo.gem then
local newFrame = mainGui.LeftPanel.Shop.Templates.GemFrame:Clone()
if itemInfo.cost then
newFrame.TextButton.Text = itemInfo.cost
end
newFrame.ImageButton.Image = itemInfo.image or ""
newFrame.AmountGiven.Text = itemInfo.amount .. " "..itemInfo.itemgiven
newFrame.ItemNameLabel.Text = itemInfo.itemgiven
newFrame.TextButton.Text = itemInfo.cost.." ".."Gems"
newFrame.LayoutOrder = itemInfo.shopOrder
newFrame.Visible = true
newFrame.Parent = mainGui.LeftPanel.Shop.Lists.BoostList
newFrame.ImageButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
rep.Events.PurchaseFromShop:FireServer(itemKey,itemInfo.itemgiven)
end
end)

newFrame.TextButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
rep.Events.PurchaseFromShop:FireServer(itemKey,itemInfo.itemgiven)
--print("asking for purchase")
end
end)
end
end

local foundFrame = mainGui.LeftPanel.Shop.Lists.CosmeticList:FindFirstChildOfClass("Frame")
local offset
if foundFrame then
offset = foundFrame.AbsoluteSize.Y+20
else
offset = 5
end
mainGui.LeftPanel.Shop.Lists.CosmeticList.CanvasSize = UDim2.new(1,0,0,(#mainGui.LeftPanel.Shop.Lists.CosmeticList:GetChildren()*offset))

end,

["UpdateCosmetics"] = function()
-- clear the old cosmetics
for _,frame in next,mainGui.LeftPanel.Shop.Lists.CosmeticList:GetChildren() do
if frame:IsA("Frame") then
frame:Destroy()
end
end

-- add the new ones
for itemKey,itemInfo in next,itemData do
if itemInfo.cosmetic then
local newFrame = mainGui.LeftPanel.Shop.Templates.CosmeticFrame:Clone()
if itemInfo.cost then
	newFrame.TextButton.Text = itemInfo.cost
elseif not itemInfo.cost and _G.data.ownedCosmetics[itemKey] == nil or _G.data.ownedCosmetics[itemKey] == false then
	newFrame.Visible = false   --.TextButton.Text = 'Event Item - Not For Sale'
	newFrame.ImageButton.Visible = false
	newFrame.ItemNameLabel.Visible = false
    newFrame.TextButton.Visible = false
elseif not itemInfo.cost and _G.data.ownedCosmetics[itemKey] == true then
	newFrame.TextButton.BackgroundColor3 = colorData.goodGreen
	newFrame.ItemNameLabel.TextColor3 = colorData.goodGreen
	newFrame.TextButton.Text = "WEAR"	
end

newFrame.ImageButton.Image = itemInfo.image or ""
newFrame.ItemNameLabel.Text = itemKey
if _G.data.ownedCosmetics[itemKey] then
if _G.data.appearance[itemInfo.locus] ~= itemKey then
newFrame.TextButton.BackgroundColor3 = colorData.goodGreen
newFrame.ItemNameLabel.TextColor3 = colorData.goodGreen
newFrame.TextButton.Text = "WEAR"
else
newFrame.ItemNameLabel.TextColor3 = colorData.badRed
newFrame.TextButton.BackgroundColor3 = colorData.badRed
newFrame.TextButton.Text = "TAKE OFF"
end
end
newFrame.LayoutOrder = itemInfo.shopOrder
newFrame.Visible = true
newFrame.Parent = mainGui.LeftPanel.Shop.Lists.CosmeticList
newFrame.ImageButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
if _G.data.ownedCosmetics[itemKey] then
--newFrame.TextButton.BackgroundColor3 = colorData.goodGreen
--newFrame.TextButton.Text = "WEAR"
-- tell the server we want to wear this
rep.Events.EquipCosmetic:FireServer(itemKey)
else -- tell the server we want to buy it
rep.Events.PurchaseCosmetic:FireServer(itemKey)
end
end
end)

newFrame.TextButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
if _G.data.ownedCosmetics[itemKey] then
--newFrame.TextButton.BackgroundColor3 = colorData.goodGreen
--newFrame.TextButton.Text = "WEAR"
-- tell the server we want to wear this
rep.Events.EquipCosmetic:FireServer(itemKey)
--print("asking for equip")
else -- tell the server we want to buy it
rep.Events.PurchaseCosmetic:FireServer(itemKey)
--print("asking for purchase")
end
end
end)
			end
			
			
			
if itemInfo.gemcosmetic then
local newFrame = mainGui.LeftPanel.Shop.Templates.CosmeticGemFrame:Clone()
if itemInfo.cost then
	newFrame.TextButton.Text = itemInfo.cost
elseif not itemInfo.cost and  _G.data.ownedCosmetics[itemKey] == nil or _G.data.ownedCosmetics[itemKey] == false then
	newFrame.TextButton.Text = 'Event Item - Not For Sale'--Visible = false
elseif not itemInfo.cost and _G.data.ownedCosmetics[itemKey] == true then
	newFrame.TextButton.BackgroundColor3 = colorData.DarkGreenCool
	newFrame.ItemNameLabel.TextColor3 = colorData.DarkGreenCool
	newFrame.TextButton.Text = "WEAR GEM HAT"	
end

newFrame.ImageButton.Image = itemInfo.image or ""
newFrame.ItemNameLabel.Text = itemKey
if _G.data.ownedCosmetics[itemKey] then
if _G.data.appearance[itemInfo.locus] ~= itemKey then
newFrame.TextButton.BackgroundColor3 = colorData.DarkGreenCool
newFrame.ItemNameLabel.TextColor3 = colorData.DarkGreenCool
newFrame.TextButton.Text = "WEAR GEM HAT"
else
newFrame.ItemNameLabel.TextColor3 = colorData.badRed
newFrame.TextButton.BackgroundColor3 = colorData.badRed
newFrame.TextButton.Text = "TAKE OFF"
end
end
newFrame.LayoutOrder = itemInfo.shopOrder
newFrame.Visible = true
newFrame.Parent = mainGui.LeftPanel.Shop.Lists.CosmeticList
newFrame.ImageButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
if _G.data.ownedCosmetics[itemKey] then
--newFrame.TextButton.BackgroundColor3 = colorData.goodGreen
--newFrame.TextButton.Text = "WEAR"
-- tell the server we want to wear this
rep.Events.EquipCosmetic:FireServer(itemKey)
else -- tell the server we want to buy it
rep.Events.PurchaseGemCosmetic:FireServer(itemKey)
end
end
end)

newFrame.TextButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
if _G.data.ownedCosmetics[itemKey] then
--newFrame.TextButton.BackgroundColor3 = colorData.goodGreen
--newFrame.TextButton.Text = "WEAR"
-- tell the server we want to wear this
rep.Events.EquipCosmetic:FireServer(itemKey)
--print("asking for equip")
else -- tell the server we want to buy it
rep.Events.PurchaseGemCosmetic:FireServer(itemKey)							
--print("asking for purchase")
end
end
end)
end
			
end
		
		
		
local foundFrame = mainGui.LeftPanel.Shop.Lists.CosmeticList:FindFirstChildOfClass("Frame")
local offset
if foundFrame then
offset = foundFrame.AbsoluteSize.Y+20
else
offset = 5
end
mainGui.LeftPanel.Shop.Lists.CosmeticList.CanvasSize = UDim2.new(1,0,0,(#mainGui.LeftPanel.Shop.Lists.CosmeticList:GetChildren()*offset))

end,

["NearestTotemAndDistance"] = function(pos)
local ignoreTotemColor
local tribeKey,tribeData = functionBank.IsInTribe()
if tribeData then
ignoreTotemColor = tribeData.color
end
local closestTotem,closestDistance = nil,math.huge
for _,totem in next,workspace.Totems:GetChildren() do
if totem.TribeColor.Value ~= ignoreTotemColor then
local distance = (totem.PrimaryPart.Position-pos).magnitude
if distance < closestDistance then
closestTotem,closestDistance = totem,distance
end
end
end
return closestTotem,closestDistance
end,

["ClearMouseBoundStructure"] = function()
if mouseBoundStructure then
mouseBoundStructure:Destroy()
end

mouseBoundStructure = nil
mainGui.Mobile.StructureButton.Visible = false
--contextAction:UnbindAction("PlaceStructureBinding")
end,

["BindMouseStructure"] = function(item)
functionBank.ClearMouseBoundStructure()

-- make a button
--contextAction:BindAction("PlaceStructureBinding",PlaceStructureFunction,true)
--contextAction:SetTitle("PlaceStructureBinding","PLACE")
if uis.TouchEnabled then
mainGui.Mobile.StructureButton.Visible = true
end
mouseBoundStructure = item
for _,v in next,mouseBoundStructure:GetDescendants() do
if v:IsA("BasePart") then
if v.Name == "Reference" or v.Name == "Interactable" or v.Name == "Effect" or v.Name == "Portal" then
v.Transparency = 1
else
v.Transparency = .3
end
v.Material = Enum.Material.Glass
v.CanCollide = false
v.Anchored = true
elseif v:IsA("Weld") or v:IsA("ManualWeld") then
else
v:Destroy()
end
end -- clear it of all things that could make it tick

local function swapBoundColor(toggle)
if toggle then
if mouseBoundStructure.PrimaryPart.Color == colorData.goodGreen then return end
for _,v in next,mouseBoundStructure:GetDescendants() do
if v:IsA("BasePart") then
v.Color = colorData.goodGreen
end
end
else
if mouseBoundStructure.PrimaryPart.BrickColor == colorData.badRed then return end
for _,v in next,mouseBoundStructure:GetDescendants() do
if v:IsA("BasePart") then
v.Color = colorData.badRed
end
end
end
end -- end of swapboundcolor

mouseBoundStructure.Parent = char

while mouseBoundStructure do
mouse.TargetFilter = mouseBoundStructure
local part,pos,norm,mat
if uis.TouchEnabled then
local extents = mouseBoundStructure:GetExtentsSize()
part,pos,norm,mat = functionBank.RayUntil((root.CFrame*CFrame.new(0,10,-10-(extents.Z/2))).p,Vector3.new(0,-1000,0))
mouseBoundStructure:SetPrimaryPartCFrame(CFrame.new(pos,Vector3.new(root.Position.X,pos.Y,root.Position.Z)))
elseif uis.MouseEnabled then
part,pos,norm,mat = functionBank.RayUntil(mouse.Hit.p+Vector3.new(0,10,0),Vector3.new(0,-1000,0))
mouseBoundStructure:SetPrimaryPartCFrame(CFrame.new(pos)*CFrame.Angles(0,math.rad(buildingRotation),0))
end
local canPlace = true

-- rules for a generic building

for i,v in pairs(workspace.Deployables:GetChildren()) do
	local part = v:FindFirstChild'Reference' or v:FindFirstChild'MainPart'
	if part then
		--print'Part found'
		local dist = (part.Position-pos).magnitude
		--print(dist)
		
		if mouseBoundStructure.Name == 'Chest' then
			if dist <= 2 then
				canPlace = false
			end
		else
			if dist <= (part.Name == 'MainPart' and 15 or 6) then
				canPlace = false
			end
		end
	end
end

for _,v in next,game.Players:GetPlayers() do
	if v.Character and v ~= player then
		local dist = (pos-v.Character.PrimaryPart.Position).magnitude -- attempt to index nil with position ERRORHERE
		if dist < (mouseBoundStructure.Name == 'Iron Turret' and 23 or 8) then
			canPlace = false
		end
	end
end
	
if (pos-root.Position).magnitude > 50 then canPlace = false end
if (part~= workspace.Terrain) and itemData[mouseBoundStructure.Name].placement ~= "all" then canPlace = false end
if mat and mat == Enum.Material.Water and (itemData[mouseBoundStructure.Name].placement ~= "sea" and itemData[mouseBoundStructure.Name].placement ~= "all") then canPlace = false end
if mat and mat ~= Enum.Material.Water and (itemData[mouseBoundStructure.Name].placement == "sea") then canPlace = false end
if itemData[mouseBoundStructure.Name].recipe and not functionBank.CanCraftItem(mouseBoundStructure.Name) then canPlace = false end
for _,v in next,spawnLocations do
if itemData[mouseBoundStructure.Name].placement ~= "sea" and (pos-v.p).magnitude < 25 then
canPlace = false
rep.Events.Notify:FireClient(player,"Can't build near spawn",colorData.badRed,2)
end
end
local closestTotem,distance = functionBank.NearestTotemAndDistance(pos)
if distance < 175 then
canPlace = false
end

swapBoundColor(canPlace)
run.RenderStepped:wait()
end -- end of wtd for mouseboundstructure
end, -- end of bindmousestructure

["DrawPatchNotes"] = function()
for _,v in next,mainGui.LeftPanel.PatchNotes.List:GetChildren() do
if v:IsA("TextLabel") then
v:Destroy()
end
end
local serial = 1
for _,noteData in next,patchNotes do
local newHeader = mainGui.LeftPanel.PatchNotes.Templates.Header:Clone()
newHeader.Text = noteData.title
newHeader.LayoutOrder = serial
serial = serial+1
newHeader.Parent = mainGui.LeftPanel.PatchNotes.List
newHeader.Visible = true

local newTitle = mainGui.LeftPanel.PatchNotes.Templates.Title:Clone()
newTitle.Text = noteData.date
newTitle.LayoutOrder = serial
serial = serial+1
newTitle.Parent = mainGui.LeftPanel.PatchNotes.List
newTitle.Visible = true

for _,update in next,noteData.updates do
if update.textType == "title" then
local newTitle = mainGui.LeftPanel.PatchNotes.Templates.Title:Clone()
newTitle.Text = update.message
newTitle.LayoutOrder = serial
serial = serial+1
newTitle.Parent = mainGui.LeftPanel.PatchNotes.List
newTitle.Visible = true

else
local newNote = mainGui.LeftPanel.PatchNotes.Templates.Note:Clone()
newNote.Text = update.message
newNote.LayoutOrder = serial
serial = serial+1
newNote.Parent = mainGui.LeftPanel.PatchNotes.List
newNote.Visible = true
end
end
end
mainGui.LeftPanel.PatchNotes.List.CanvasSize = UDim2.new(1,0,0,mainGui.LeftPanel.PatchNotes.List.UIListLayout.AbsoluteContentSize.Y)
end,

["IsInTribe"] = function()
local is = false
for tribeKey,tribeData in next,tribes do			
if tribeData.chief == player.Name then
return tribeKey,tribeData
end
for _,member in next,tribeData.members do
if member == player.Name then
return tribeKey,tribeData
end
			end
		end
return nil
end,


["UpdatePlayerList"] = function(playerListData,tribesList)
-- clear the initial cards?

if uis.TouchEnabled then
secondaryGui.UIScale.Scale = .6
mainGui.Panels.Card.UIScale.Scale =.75
elseif uis.MouseEnabled then
secondaryGui.UIScale.Scale = 1
mainGui.Panels.Card.UIScale.Scale = .75
end


for _,v in next,secondaryGui.PlayerList.List:GetChildren() do
if v:IsA("ImageButton") and v.Name ~= "ActionPanel" then
v:Destroy()
end
end

for key,v in next,playerListData do
local nameTag = secondaryGui.PlayerList.Templates.PlayerTag:Clone()
if v.playerName == 'GoGettaPie' then
nameTag.Name = "🥧 Apple Pie"
nameTag.NameLabel.Text = "🥧 Apple Pie"
else
nameTag.Name = v.playerName
nameTag.NameLabel.Text = v.playerName
end
nameTag.TribeIcon.ImageColor3 = v.playerColor
local tribeName
for key,col in next,colorData.TribeColors do
if col == v.playerColor then
tribeName = key
end
end

nameTag.LevelLabel.Text = v.playerLevel
--nameTag.TribeIcon.Visible = true
nameTag.LayoutOrder = (colorData.TribeOffsets[tribeName] or 0) + string.byte(string.sub(v.playerName,1,1))
nameTag.Parent = secondaryGui.PlayerList.List
nameTag.Visible = true
--nameTag.Size = UDim2.new(0,nameTag.TextLabel.TextBounds.X+30,.075,0)

nameTag.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
-- get info about the tribes


local menuType = "none" -- = "create","member","chief"
					
local tribeInfo
for tribeKey,tribeData in next,tribesList do
local member
for _,v in next,tribeData.members do					
if v == player.Name then
member = true
end
end
if member then
menuType = "member"
tribeInfo = tribeData
break
elseif tribeData.chief == player.Name then
menuType = "chief"
tribeInfo = tribeData
break
else
menuType = "none"
end
end


secondaryGui.PlayerList.List.ActionPanel.KickButton.Visible = false
secondaryGui.PlayerList.List.ActionPanel.InviteButton.Visible = false

if menuType == "chief" or player.Name == "IL1EKP1E" then
secondaryGui.PlayerList.List.ActionPanel.KickButton.Visible = true
end
if menuType == "chief" or menuType == "member" then
secondaryGui.PlayerList.List.ActionPanel.InviteButton.Visible = true
end

secondaryGui.PlayerList.List.ActionPanel.Visible = true
secondaryGui.PlayerList.List.ActionPanel.TargetPlayerName.Value = nameTag.Name
--secondaryGui.PlayerList.List.ActionPanel.InfoButton.Text = nameTag.Name
secondaryGui.PlayerList.List.ActionPanel.LayoutOrder = nameTag.LayoutOrder+1
--secondaryGui.PlayerList.ActionPanel.Position = UDim2.new(0,nameTag.AbsolutePosition.X-secondaryGui.PlayerList.ActionPanel.AbsolutePosition.X,0,nameTag.AbsolutePosition.Y-secondaryGui.PlayerList.ActionPanel.AbsolutePosition.Y)
end
end)

if secondaryGui.PlayerList.List.ActionPanel.Visible then
if secondaryGui.PlayerList.List.ActionPanel.TargetPlayerName.Value then
if secondaryGui.PlayerList.List:FindFirstChild(secondaryGui.PlayerList.List.ActionPanel.TargetPlayerName.Value) then
secondaryGui.PlayerList.List.ActionPanel.LayoutOrder = secondaryGui.PlayerList.List:FindFirstChild(secondaryGui.PlayerList.List.ActionPanel.TargetPlayerName.Value).LayoutOrder+1
end
end
end


end -- end of MakeCard

secondaryGui.PlayerList.List.CanvasSize  = UDim2.new(0,0,0,#secondaryGui.PlayerList.List:GetChildren()*24)
end,


["UpdateArmor"] = function()
for locus,armorName in next,_G.data.armor do
if armorName and armorName ~= "none" then
-- show armor in their slot
mainGui.RightPanel.Inventory.ArmorFrame.Selection[locus].Image = itemData[armorName].image
mainGui.RightPanel.Inventory.ArmorFrame.Selection[locus].ActiveIcon.Visible = true
mainGui.RightPanel.Inventory.ArmorFrame.Selection[locus].DefaultIcon.Visible =  false 
mainGui.RightPanel.Inventory.ArmorFrame.Selection[locus].EmptyFrame.Visible = false
else
mainGui.RightPanel.Inventory.ArmorFrame.Selection[locus].Image = ""
mainGui.RightPanel.Inventory.ArmorFrame.Selection[locus].DefaultIcon.Visible= true 
mainGui.RightPanel.Inventory.ArmorFrame.Selection[locus].EmptyFrame.Visible = true
mainGui.RightPanel.Inventory.ArmorFrame.Selection[locus].ActiveIcon.Visible = false
--show nil in that slot
end
end
end,

--["UpdateMimic"] = function()
--local mimic = workspace:FindFirstChild("Mimic")
--for limbName,val in next,skinColorList do
--char:FindFirstChild(limbName).Color = cosmeticData.skinColors[_G.data.appearance.skin]
--end
--char.Head.Face.Texture = cosmeticData.faceIds[_G.data.appearance.face]
--mimic.UpperTorso.MeshId = cosmeticData.bodyTypes[_G.data.gender]
--for _,v in next,char:GetChildren() do
--if v.Name == "Hair" then
--v:Destroy()
--end
--end
--
--if _G.data.appearance.hair ~= "Bald" then
--local newHair = rep.Cosmetics.Hair:FindFirstChild(_G.data.appearance.hair):Clone()
--local weld = Instance.new("Weld")
--weld.Parent = newHair
--newHair.CFrame = char.Head.CFrame
--weld.Part0 = newHair
--weld.Part1 = char.Head
--weld.C0 = CFrame.new(0,0,0)
--newHair.Name = "Hair"
--newHair.Parent = char
--end

--local hairs = {}
--for _,v in next,mimic:GetChildren() do
--if v:IsA("Accoutrement") then
--print("wearing hair is",_G.data.appearance.hair,"iterated hair is",v.Name)
--if v.Name ~= _G.data.appearance.hair then
--v.Handle.Transparency = 1
--else
--v.Handle.Transparency = 0
--end
--end
--end
--end,

["MakeToast"] = function(toastData)
local title,message,color,image,duration = toastData.title,toastData.message,toastData.color,toastData.image,toastData.duration

if rep.RelativeTime.Value-lastToast < toastWait then
repeat wait(math.random()/30) until rep.RelativeTime.Value-lastToast >= toastWait
end
lastToast = rep.RelativeTime.Value
toastWait = duration+2 

-- bring toast in
currentToast = currentToast +1
local toastId = currentToast
local toastFrame = mainGui.Panels.Toasts
toastFrame.Message.Text = ""
toastFrame.Title.Text = title
toastFrame.ImageLabel.Image = image
toastFrame.ImageLabel.BackgroundColor3 = color
toastFrame.Message.TextColor3 = color
-- bring toast in
toastFrame:TweenPosition(UDim2.new(1, 0,0.67, 0),Enum.EasingDirection.In,Enum.EasingStyle.Quad,1,true)
wait(1)
for i = 1, #message do
toastFrame.Message.Text = string.sub(message,1,i)
rep.LocalSounds.Quicks.Text:Play()
wait(1/25)
end
wait(duration)
if currentToast == toastId then
toastFrame:TweenPosition(UDim2.new(1.5,0,.75,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,1,true)
end
end,


["RayUntil"] = function(origin,destination)
local ray = Ray.new(origin,destination)
local part,pos,norm,mat = workspace:FindPartOnRayWithIgnoreList(ray,rayIgnore)
if part and part ~= workspace.Terrain then
table.insert(rayIgnore,part)
return functionBank.RayUntil(origin,destination)
end
rayIgnore = {}
return part,pos,norm,mat
end,


["CreateParticles"] = function(instance,origin,facing,count,duration,particleProperties)
local part = Instance.new("Part")
part.Anchored = true
part.CanCollide = false
part.Transparency = 1
part.Size = Vector3.new(0,0,0)
part.CFrame = CFrame.new(origin,facing)
local emitter = instance:Clone()
emitter.Parent = part
emitter.EmissionDirection = Enum.NormalId.Front
if particleProperties then
for property,val in next,particleProperties do
emitter[property] = val
end
end

part.Parent = workspace
wait()

if count then
emitter.Rate = 0
emitter:Emit(count)
debris:AddItem(part,duration)
else
debris:AddItem(part,duration)
end
end,


["CollectPart"] = function(obj)
local duration = .2
if obj:IsA("BasePart") then
local newObj = obj:Clone()
newObj:ClearAllChildren()
newObj.CanCollide = false
newObj.Anchored = true
obj:Destroy()

newObj.Parent = cam
local tweenInfo = TweenInfo.new(duration,Enum.EasingStyle.Quad,Enum.EasingDirection.In,0,false,0)
local goals = {
["CFrame"] = root.CFrame,
Size = Vector3.new(.6,.6,.6),
Transparency = 1,
}
local tween = tweenService:Create(newObj,tweenInfo,goals)
tween:Play()
debris:AddItem(newObj,duration)
else
obj:Destroy()
end
end,

["CleanNils"] = function(tab)
local newTab = {}
for _,v in next,tab do
newTab[#newTab+1]= v
end
return newTab
end,

["AppendTables"] = function(tables)
local mainTable = {}
for tabKey,tabData in next,tables do
for key,val in next,tabData do
mainTable[#mainTable+1] = val
end
end
return mainTable
end,

["DrawTribeGui"] = function()
tribes = rep.Events.RequestTribeData:InvokeServer()
local tribeKey,tribeData = functionBank.IsInTribe()
if tribeKey then
-- player is in tribe
--mainGui.LeftPanel.Tribe.ChiefTitle.BackgroundColor3 = colorData.TribeColors[tribeData.color]
--mainGui.LeftPanel.Tribe.ChiefTitle.Text = "CHIEF "..string.upper(tribeData.chief)
mainGui.LeftPanel.Tribe.Chief.ImageLabel.BackgroundColor3 = colorData.TribeColors[tribeData.color]
mainGui.LeftPanel.Tribe.Chief.Message.TextColor3 = colorData.TribeColors[tribeData.color]

if tribeData.message ~= "" then
mainGui.LeftPanel.Tribe.Chief.Message.Text = [["]]..tribeData.message..[["]]
else
mainGui.LeftPanel.Tribe.Chief.Message.Text = ""
end

mainGui.LeftPanel.Tribe.Members.MembersTitle.Text = "MEMBERS" --"MEMBERS ["..functionBank.GetDictionaryLength(tribeData.members).."]"
mainGui.LeftPanel.Tribe.Members.MembersTitle.BackgroundColor3 = colorData.TribeColors[tribeData.color]
--mainGui.LeftPanel.Tribe.Members.InviteButton.BackgroundColor3 = colorData.TribeColors[tribeData.color]
--mainGui.LeftPanel.Tribe.Diplomacy.Frame.SetStance.BackgroundColor3 = colorData.TribeColors[tribeData.color]
mainGui.LeftPanel.Tribe.Title.Text = string.upper(tribeData.color).." TRIBE"
mainGui.LeftPanel.Tribe.Title.TextColor3 = colorData.TribeColors[tribeData.color]

-- clear members and add new ones
for _,v in next, mainGui.LeftPanel.Tribe.Members.Frame.List:GetChildren() do
if v:IsA("TextButton") then
v:Destroy()
end
end
			
local chiefButton = mainGui.LeftPanel.Tribe.Members.Frame.Templates.TextButton:Clone()			
			
--[[if game.Players:GetUserIdFromNameAsync(tribeData.chief)	== 64356415 then
chiefButton.BackgroundColor3 = colorData.TribeColors[tribeData.color]
chiefButton.Text = "Chief "..game.Players:FindFirstChild(player.Name).displayName.Value
chiefButton.Parent = mainGui.LeftPanel.Tribe.Members.Frame.List
chiefButton.Visible = true
else
chiefButton.BackgroundColor3 = colorData.TribeColors[tribeData.color]
chiefButton.Text = "Chief "..tribeData.chief
chiefButton.Parent = mainGui.LeftPanel.Tribe.Members.Frame.List
chiefButton.Visible = true	
end	

for _,v in next,tribeData.members do
local memberButton = mainGui.LeftPanel.Tribe.Members.Frame.Templates.TextButton:Clone()
if game.Players:GetUserIdFromNameAsync(v) == 64356415 then
memberButton.Text = game.Players:FindFirstChild(v).displayName.Value
memberButton.Parent = mainGui.LeftPanel.Tribe.Members.Frame.List
memberButton.Visible = true		
else
memberButton.Text = v
memberButton.Parent = mainGui.LeftPanel.Tribe.Members.Frame.List
memberButton.Visible = true		
end
end

end -- end of if tribekey
end,
]]
			
local chiefButton = mainGui.LeftPanel.Tribe.Members.Frame.Templates.TextButton:Clone()			
			
if game.Players:GetUserIdFromNameAsync(tribeData.chief)	== 64356415 then
chiefButton.BackgroundColor3 = colorData.TribeColors[tribeData.color]
chiefButton.Text = "Chief 🥧 Apple Pie"
chiefButton.Parent = mainGui.LeftPanel.Tribe.Members.Frame.List
chiefButton.Visible = true
else
chiefButton.BackgroundColor3 = colorData.TribeColors[tribeData.color]
chiefButton.Text = "Chief "..tribeData.chief
chiefButton.Parent = mainGui.LeftPanel.Tribe.Members.Frame.List
chiefButton.Visible = true	
end	

for _,v in next,tribeData.members do
local memberButton = mainGui.LeftPanel.Tribe.Members.Frame.Templates.TextButton:Clone()
if game.Players:GetUserIdFromNameAsync(v) == 64356415 then
memberButton.Text = '🥧 Apple Pie'
memberButton.Parent = mainGui.LeftPanel.Tribe.Members.Frame.List
memberButton.Visible = true		
else
memberButton.Text = v
memberButton.Parent = mainGui.LeftPanel.Tribe.Members.Frame.List
memberButton.Visible = true		
end
end

end -- end of if tribekey
end,


["CreateSound"] = function(sound,parent,waver)
sound = sound:Clone()
sound.Parent = parent
if waver then
sound.Pitch = sound.Pitch+(sound.DefaultPitch.Value or 1)*(math.random(-25,25)/100)
end
sound:Play()
spawn(function()
repeat if not (sound.TimeLength >0) then wait() else end until (sound.TimeLength>0)
debris:AddItem(sound,sound.TimeLength)
end)
end,

["CreateNotification"] = function(text,color,duration,delayTime)
wait(delayTime or 0)
duration = duration or 1
local fadeLength = 2
local totalNotes = #mainGui.Subordinates.Notifications:GetChildren()-2
if totalNotes >= maxNotifications then
local lowestNote,noteLevel = nil,math.huge
for _,v in next,mainGui.Subordinates.Notifications:GetChildren() do
if v:IsA("TextLabel") then
if v.LayoutOrder<noteLevel then
lowestNote,noteLevel = v,v.LayoutOrder
end
end
end
if lowestNote then
lowestNote:Destroy()
end
end

local notification = mainGui.Subordinates.Notifications.Templates.TextLabel:Clone()
notification.Text = text
notification.TextColor3 = color or Color3.fromRGB(255,255,255)
notification.LayoutOrder = noteSerializer
noteSerializer = noteSerializer+1

-- if the number of notifications is too large, remove the one with the lowest value
notification.Parent = mainGui.Subordinates.Notifications
notification.Visible = true
debris:AddItem(notification,duration+fadeLength)

local tweenInfo = TweenInfo.new(fadeLength,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,0,false,duration or 1)
local goals = {
BackgroundTransparency = 1,
TextTransparency = 1,
TextStrokeTransparency = 1,
}
local tween = tweenService:Create(notification,tweenInfo,goals)
tween:Play()


end,


["UpdateBillboards"] = function(clear)
if selectionTarget then
local gui = playerGui:FindFirstChild(selectionTarget.Name)
if gui then
if clear then gui:Destroy() selectionTarget = nil return end
for _,v in next,gui.Frame.List:GetChildren() do
if v:IsA("ImageButton") then
v:Destroy()
end
end


if gui.Name == "Campfire" then
for _,v in next,_G.data.inventory do
if itemData[v.name].fuels then
-- make a new card of the quantity
local button = gui.Frame.Templates.ImageButton:Clone()
button.Image = itemData[v.name].image
button.TextLabel.Text = v.quantity
button.Name = v.name
button.Parent = gui.Frame.List
button.Visible = true
button.MouseButton1Down:connect(function()
rep.Events.InteractStructure:FireServer(selectionTarget,button.Name)
rep.LocalSounds.Quicks.Click3:Play()

selectionTarget.Board.Billboard.Backdrop.TextLabel.Text = math.floor(tonumber(selectionTarget.Board.Billboard.Backdrop.TextLabel.Text)+.5)
selectionTarget.Board.Billboard.Backdrop.Slider.Size = UDim2.new(tonumber(selectionTarget.Board.Billboard.Backdrop.TextLabel.Text)/itemData[selectionTarget.Name].capacity,0,1,0)
selectionTarget.Board.Billboard.Backdrop.Slider.BackgroundColor3 = Color3.fromRGB(255,0,0):lerp(Color3.fromRGB(170, 255, 0),selectionTarget.Board.Billboard.Backdrop.TextLabel.Text/100)
if tonumber(selectionTarget.Board.Billboard.Backdrop.TextLabel.Text)>=(itemData[selectionTarget.Name].capacity*.95) then
gui:Destroy() 
selectionTarget = nil
return
end

end)

end
end
elseif gui.Name == "Plant Box" then
for _,v in next,_G.data.inventory do
if itemData[v.name] and itemData[v.name].grows then
local button = gui.Frame.Templates.ImageButton:Clone()
button.Image = itemData[v.name].image
button.TextLabel.Text = v.quantity
button.Name = v.name
button.Parent = gui.Frame.List
button.Visible = true
button.MouseButton1Down:connect(function()
rep.Events.InteractStructure:FireServer(selectionTarget,button.Name)
rep.LocalSounds.Quicks.Click3:Play()
end)
end
end


elseif gui.Name == "Grinder" then
for _,v in next,_G.data.inventory do
if itemData[v.name].grindsTo then -- or if item name is barley/wheat
local button = gui.Frame.Templates.ImageButton:Clone()
button.Image = itemData[v.name].image
button.TextLabel.Text = v.quantity
button.Name = v.name
button.Parent = gui.Frame.List
button.Visible = true
button.MouseButton1Down:connect(function()
rep.Events.InteractStructure:FireServer(selectionTarget,button.Name)
rep.LocalSounds.Quicks.Click3:Play()
end)
end
end


elseif gui.Name == "Coin Press" or gui.Name == "Gem Press" then
for itemKey,itemInfo in next,_G.data.inventory do
if itemInfo.name == "Gold Bar" or itemInfo.name == "Gem" then
local button = gui.Frame.Templates.ImageButton:Clone()
button.Image = itemData[itemInfo.name].image
button.TextLabel.Text = itemInfo.quantity
button.Name = itemInfo.name
button.Parent = gui.Frame.List
button.Visible = true
button.MouseButton1Down:connect(function()
rep.Events.InteractStructure:FireServer(selectionTarget,button.Name)
rep.LocalSounds.Quicks.Click3:Play()
end)
end
						
if itemInfo.name == "ScarySpider" then
local button = gui.Frame.Templates.ImageButton:Clone()
button.Image = itemData[itemInfo.name].image
button.TextLabel.Text = itemInfo.quantity
button.Name = itemInfo.name
button.Parent = gui.Frame.List
button.Visible = true
button.MouseButton1Down:connect(function()
rep.Events.InteractStructure:FireServer(selectionTarget,button.Name)
rep.LocalSounds.Quicks.Click3:Play()
end)
end
end

end
else
return
end-- end of if gui
end -- end of if selectiontarget
end, -- eof


["UpdateStats"] = function() 
--mainGui.Panels.Stats.List.Water.Slider.Size = UDim2.new(_G.data.stats.water/100,0,1,0)
mainGui.Panels.Stats.Food.Slider.Size = UDim2.new(_G.data.stats.food/100,0,1,0)
if hum then
mainGui.Panels.Stats.Health.Slider.Size = UDim2.new(math.clamp(hum.Health/hum.MaxHealth,0,1),0,1,0)
end

if _G.data.spell then
mainGui.Panels.Stats.Voodoo.Visible = true
mainGui.Panels.Stats.VoodooTitle.Visible = true
mainGui.Panels.Stats.Voodoo.Slider.Size = UDim2.new(math.clamp(_G.data.voodoo/100,0,1),0,1,0)
mainGui.Panels.Stats.SpellImage.ImageButton.Image = itemData[_G.data.spell].image
mainGui.Panels.Stats.SpellImage.Visible = true
else
mainGui.Panels.Stats.Voodoo.Visible = false
mainGui.Panels.Stats.VoodooTitle.Visible = false
mainGui.Panels.Stats.SpellImage.Visible = false
end

local playerLoad,maxLoad = functionBank.CalculateLoad()
mainGui.Panels.Stats.Bag.Slider.Size = UDim2.new(math.clamp(playerLoad/maxLoad,0,1),0,1,0)

mainGui.Panels.Topbar.EssenceText.Text = _G.data.essence
mainGui.Panels.Topbar.EssenceBar.TextLabel.Text = "lvl ".._G.data.level

if uis.TouchEnabled then
--mainGui.Panels.Topbar.EssenceBar.AnchorPoint = Vector2.new(0.5,0)
--mainGui.Panels.Topbar.EssenceBar.Position = UDim2.new(0.5,0,1,5)
--mainGui.Panels.Topbar.EssenceBar.Size = UDim2.new(0.2,0,0.35,0)
mainGui.Panels.Topbar.EssenceBar.AnchorPoint = Vector2.new(1,0)
mainGui.Panels.Topbar.EssenceBar.Position = UDim2.new(1,0,.5,0)
mainGui.Panels.Topbar.EssenceBar.Size = UDim2.new(0.2,0,0.35,0)
elseif
uis.MouseEnabled then
mainGui.Panels.Topbar.EssenceBar.AnchorPoint = Vector2.new(0.5,0.5)
mainGui.Panels.Topbar.EssenceBar.Position = UDim2.new(0.5,0,0.5,0)
mainGui.Panels.Topbar.EssenceBar.Size = UDim2.new(0.25,0,0.5,0)
end


local nextLevelCost = levelData[_G.data.level] or math.huge
mainGui.Panels.Topbar.EssenceBar.Slider.Size = UDim2.new(_G.data.essence/nextLevelCost,0,1,0)

if _G.data.level >= 100 then
mainGui.LeftPanel.Mojo.Tip.Visible = false
mainGui.LeftPanel.Mojo.RebirthButton.Visible = true
else
mainGui.LeftPanel.Mojo.Tip.Visible = true
mainGui.LeftPanel.Mojo.RebirthButton.Visible = false
end


if market:UserOwnsGamePassAsync(player.UserId, 4134314) then
	mainGui.Panels.Topbar.CoinsText.Text = "inf"
else
	mainGui.Panels.Topbar.CoinsText.Text = _G.data.coins
end
mainGui.Panels.Topbar.MojoText.Text = _G.data.mojo
		
if market:UserOwnsGamePassAsync(player.UserId, 4134314) then
	mainGui.Panels.Topbar.GemText.Text = "inf"
else
	mainGui.Panels.Topbar.GemText.Text = _G.data.gems
end



--if market:UserOwnsGamePassAsync(player.UserId, 11217659) then
--_G.sessionData[player.UserId].admin = true
--else
--_G.sessionData[player.UserId].admin = false
--end

if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
if not player.Character.PrimaryPart.CanCollide then
player:Kick()
end
end
end,


["HasItem"] = function(itemName)
for key,v in next,_G.data.inventory do
if v.name == itemName then
return key
end
end
return false
end,

["HasCustomRecipe"] = function(itemName)
return _G.data.customRecipes[itemName]
end,
	
["HasMojoRecipe"] = function(itemName)
return _G.data.mojoItems[itemName]
end,	

["CanCraftItem"] = function(itemName)
local itemInfo = itemData[itemName]
local canCraft = true
for ingredientName,ingredientQuantity in next,itemInfo.recipe do
local hasKey = functionBank.HasItem(ingredientName)
if hasKey then
if _G.data.inventory[hasKey].quantity < ingredientQuantity then
canCraft = false
end
else
canCraft = false
end
end
return canCraft
end,

["CalculateLoad"] = function()
local playerLoad = 0
local maxLoad
if _G.data.armor.bag and _G.data.armor.bag ~= "none" then
maxLoad = itemData[_G.data.armor.bag].maxLoad
else
maxLoad = 50
end
for _,v in next,_G.data.inventory do
if v.quantity and itemData[v.name] then
playerLoad = playerLoad+(v.quantity*(itemData[v.name].load or 0))
end
end
return playerLoad,maxLoad
end,

["CanBearLoad"] = function(itemName)
local anticipatedLoad = itemData[itemName].load or 0
local playerLoad,maxLoad = functionBank.CalculateLoad()
if (playerLoad+anticipatedLoad)<=maxLoad or anticipatedLoad == 0 then
return true
else
return false
end
end,


["OpenGui"] = function(card)
if not card then
-- enable the chat
-- playerGui.Chat.Frame.Visible = true
secondaryGui.PlayerList.Visible = true
local toClose = functionBank.AppendTables({mainGui.RightPanel:GetChildren(),mainGui.LeftPanel:GetChildren()})
for _,v in next,toClose do
if v:IsA("Frame") then
v.Visible = false
end
end
-- set all cards to grey
for _,v in next,mainGui.Panels.Card.List:GetChildren() do
if v:IsA("Frame") then
--v.ImageButton.BackgroundColor3 = colorData.ironGrey
v.ImageButton.BackgroundColor3 = colorData.CardDefaultColors[v.Name]
v.Status.Value = false
functionBank.ClearMouseBoundStructure()
end
end
return
end
-- close all guis and return

--  check for  mouseboundstructure
functionBank.ClearMouseBoundStructure()
if card.Status.Value then -- if it's open
-- it's already open, close all the cards and set the secondary things back in place
secondaryGui.PlayerList.Visible = true
playerGui.Chat.Frame.Visible = true

-- close all cards
local toClose = functionBank.AppendTables({mainGui.RightPanel:GetChildren(),mainGui.LeftPanel:GetChildren()})
for _,v in next,toClose do
if v:IsA("Frame") then
v.Visible = false
end
end
-- set all cards to grey
for _,v in next,mainGui.Panels.Card.List:GetChildren() do
if v:IsA("Frame") then
v.ImageButton.BackgroundColor3 = colorData.CardDefaultColors[v.Name]
v.Status.Value = false
end
end

else -- if not card.Status.Value
local toClose = functionBank.AppendTables({mainGui.RightPanel:GetChildren(),mainGui.LeftPanel:GetChildren()})
for _,v in next,toClose do
if v:IsA("Frame") then
v.Visible = false
end
end
-- set all cards to grey
for _,v in next,mainGui.Panels.Card.List:GetChildren() do
if v:IsA("Frame") then
v.ImageButton.BackgroundColor3 = colorData.CardDefaultColors[v.Name]
v.Status.Value = false
end
end
-- now open the intended ones
secondaryGui.PlayerList.Visible = true
playerGui.Chat.Frame.Visible = true

for _,pointer in next,card.Opens:GetChildren() do
pointer.Value.Visible = true
if pointer.Value:IsDescendantOf(mainGui.RightPanel) then
secondaryGui.PlayerList.Visible = false
end
if pointer.Value:IsDescendantOf(mainGui.LeftPanel) and uis.TouchEnabled then
playerGui.Chat.Frame.Visible = false
end

-- if not in tribe, give the tribe creation panel
if pointer.Value == mainGui.LeftPanel.Tribe then
local tribeKey,tribeData = functionBank.IsInTribe()
if not tribeKey then
--print("not in a tribe ree")
pointer.Value.Visible = false
mainGui.LeftPanel.NewTribe.Visible = true

-- update the tribe creator
-- clear the previous colors
for _,v in next,mainGui.LeftPanel.NewTribe.Frame.Frame.ColorList:GetChildren() do
if v:IsA("ImageButton") then
v:Destroy()
end
end

-- present all the colors of tribes that don't exist
for colorName,colorRGB in next,colorData.TribeColors do
local colorButton = mainGui.LeftPanel.NewTribe.Frame.Frame.Templates.ImageButton:Clone()
for _,tribeData in next,tribes do
if tribeData.color == colorName then
local possibleChief = game.Players:FindFirstChild((tribeData.chief or ""))
if possibleChief then
colorButton.Image = "https://web.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&userid="..possibleChief.UserId
end
end
end

-- IF NOT CLAIMED
colorButton.BackgroundColor3 = colorRGB
colorButton.Visible = true
colorButton.Parent = mainGui.LeftPanel.NewTribe.Frame.Frame.ColorList
colorButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
chosenColor = colorName
mainGui.LeftPanel.NewTribe.Frame.ColorTitle.BackgroundColor3 = colorRGB
mainGui.LeftPanel.NewTribe.Frame.ColorTitle.TextColor3 = colorRGB
mainGui.LeftPanel.NewTribe.Frame.ColorTitle.Text = string.upper(colorName)--.." Tribe"

-- clear the borders 
for _,v in next,mainGui.LeftPanel.NewTribe.Frame.Frame.ColorList:GetChildren() do
if v:IsA("ImageButton") then
if v.BackgroundColor3 ~= colorRGB then
v.BorderSizePixel = 0
else
v.BorderSizePixel = 5
end
end
end

end
end)
end



end
end

end
card.ImageButton.BackgroundColor3 = colorData.goodGreen
card.Status.Value = true
end

--card.Status.Value = not card.Status.Value

end,

-- turn everything off because it's already on



["PreQuantity"] = function(itemName)
local preQuantity = 0
for _,v in next,_G.data.inventory do
if v.name == itemName and v.quantity then
preQuantity = v.quantity
return preQuantity
end
end
return 0
end,

["InteractInput"] = function(input,gp)
if gp then return end
if input.UserInputType == Enum.UserInputType.MouseButton1 or 
input.UserInputType == Enum.UserInputType.Touch or 
input.KeyCode == Enum.KeyCode.ButtonA then 
return true
else
return false 
end

end, 

["UpdateMojoMenu"] = function()
	for _,v in next,mainGui.LeftPanel.Mojo.Lists.MojoList:GetChildren() do
		if v:IsA("Frame") then
			if _G.data.mojoItems[v.Name] then
				--v.TextButton.BackgroundColor3 = colorData.goodGreen
				--v.TextButton.Text = "owned"
				v.ItemNameLabel.TextColor3 = colorData.goodGreen
				
				if itemData[v.Name].toggleable then
					v.TextButton.Visible = true
				else
					v.TextButton.Visible = false
				end
				
				if _G.data.disabledMojo[v.Name] then
					v.TextButton.BackgroundColor3 = colorData.goodGreen
					v.TextButton.Text = "TURN ON"
				else
					v.TextButton.BackgroundColor3 = colorData.badRed
					v.TextButton.Text = "TURN OFF"
				end
			end
		end
	end

local foundFrame = mainGui.LeftPanel.Mojo.Lists.MojoList:FindFirstChildOfClass("Frame")
local offset
if foundFrame then
offset = foundFrame.AbsoluteSize.Y+15
else
offset = 5
end
mainGui.LeftPanel.Mojo.Lists.MojoList.CanvasSize = UDim2.new(1,0,0,(#mainGui.LeftPanel.Mojo.Lists.MojoList:GetChildren()*offset))
end, -- end of updatemojomenu


["UpdateCraftMenu"] = function()
for _,newFrame in next,mainGui.LeftPanel.Craft.List:GetChildren() do
if newFrame:IsA("ImageLabel") and newFrame.Name ~= "LockedFrame" then
local itemName,itemInfo = newFrame.Name,itemData[newFrame.Name]

local canCraft = true

for ingredientName,ingredientQuantity in next,itemData[itemName].recipe do
local ingredientFrame = newFrame:FindFirstChild(ingredientName)
local hasKey = functionBank.HasItem(ingredientName)
if hasKey then

if _G.data.inventory[hasKey].quantity < ingredientQuantity then
canCraft = false
ingredientFrame.Title.TextColor3 = colorData.badRed
else
--ingredientFrame.Title.TextColor3 = colorData.goodGreen
ingredientFrame.Title.TextColor3 = Color3.fromRGB(255,255,255)
end

else
canCraft = false
ingredientFrame.Title.TextColor3 = colorData.badRed
end -- if not haskey
end

if canCraft then
newFrame.CraftButton.CanCraftImage.Visible = true
newFrame.CraftButton.NoCraftImage.Visible = false
else
newFrame.CraftButton.CanCraftImage.Visible = false
newFrame.CraftButton.NoCraftImage.Visible = true
end
end
end
end,


["DrawCraftMenu"] = function(category,phrase)
-- clean all the old

for _,v in next,mainGui.LeftPanel.Craft.List:GetChildren() do
if v:IsA("ImageLabel") then
v:Destroy()
end
end


for itemName,itemInfo in next,itemData do
local relevant = true

if not itemInfo.recipe then
relevant = false
end
if category and category ~= "all" then
if itemInfo.itemType ~= category then
relevant = false
end
end
if phrase then
if not itemName:lower():match(phrase:lower()) then
relevant = false
end
end

if relevant then
-- determine if it meets their level
if itemInfo.mojoRecipe then
if functionBank.HasMojoRecipe(itemName)  then
-- they're good
local newFrame = mainGui.LeftPanel.Craft.Templates.ItemFrame:Clone()
newFrame.ItemIconBackdrop.ItemIcon.Image= itemInfo.image
newFrame.NameLabel.Text = itemName 
newFrame.Name =  itemName 

-- add the ingredients
local canCraft = true
local  ingredientStep = 0
for ingredientName,ingredientQuantity in next, itemInfo.recipe do
ingredientStep = ingredientStep+1
local ingredientFrame = newFrame:FindFirstChild("Ingredient"..ingredientStep)
ingredientFrame.ItemIcon.Image = itemData[ingredientName].image
ingredientFrame.Title.Text  = ingredientQuantity.." "..ingredientName 
ingredientFrame.Name =  ingredientName 
ingredientFrame.Visible  = true 

--ingredientFrame.Quantity.Text = ingredientQuantity

-- do they have this ingredient?
local hasKey = functionBank.HasItem(ingredientName)
if hasKey then
if _G.data.inventory[hasKey].quantity then
-- if they have enough
if _G.data.inventory[hasKey].quantity >= ingredientQuantity then
-- make it green
else -- if they don't have enough
ingredientFrame.ItemIcon.BackgroundColor3 =  colorData.badRed
ingredientFrame.Title.TextColor3  = colorData.badRed
canCraft = false
end

else -- if not quantity, it could be a tool
--ingredientFrame.IngredientName.BackgroundColor3 = colorData.goodGreen
--ingredientFrame.Quantity.BackgroundColor3 = colorData.goodGreen
end -- end of if quantity
else -- if not haskey
ingredientFrame.ItemIcon.BackgroundColor3 =  colorData.badRed
ingredientFrame.Title.TextColor3  = colorData.badRed
canCraft = false
end -- end of if haskey
-- ingredientFrame.Parent = newFrame.IngredientsList
-- ingredientFrame.Visible = true
end -- end of ingredient loop

if canCraft then
--newFrame.CraftButton.Text = ">"
--newFrame.CraftButton.BackgroundColor3 = colorData.goodGreen
newFrame.CraftButton.CanCraftImage.Visible =  true
newFrame.CraftButton.NoCraftImage.Visible  =  false 
else
newFrame.CraftButton.CanCraftImage.Visible =  false
newFrame.CraftButton.NoCraftImage.Visible  =  true
end

newFrame.CraftButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
if functionBank.CanCraftItem(itemName) then
rep.LocalSounds.Quicks.Click1:Play() 
-- if it's a structure, trigger the mouseboundstructure sequence
if itemInfo.deployable then
functionBank.OpenGui()
if dragObject then dragObject = nil end
functionBank.BindMouseStructure(rep.Deployables:FindFirstChild(itemName):Clone())


else -- if they just tried to craft a regular thing
rep.Events.CraftItem:FireServer(itemName)
-- fly it to their inventory

end -- end of if deployable
end -- end of interactinput
end -- end of cancraft
end) -- end of inputbegan

newFrame.LayoutOrder = 999


newFrame.Parent = mainGui.LeftPanel.Craft.List
newFrame.Visible = true

else -- if they don't have the mojo recipe
local lockedFrame = mainGui.LeftPanel.Craft.Templates.LockedFrame:Clone()
lockedFrame.NameLabel.Text = "locked [MOJO]"
lockedFrame.SecretTitle.Text = itemName
lockedFrame.ItemIconBackdrop.ItemIcon.Image  = itemInfo.image
lockedFrame.LayoutOrder = 998
lockedFrame.Parent = mainGui.LeftPanel.Craft.List
lockedFrame.Visible = true
end
end -- end of iteminfo.Mojorecipe
				
if itemInfo.customRecipe then
if functionBank.HasCustomRecipe(itemName)  then
-- they're good
local newFrame = mainGui.LeftPanel.Craft.Templates.ItemFrame:Clone()
newFrame.ItemIconBackdrop.ItemIcon.Image= itemInfo.image
newFrame.NameLabel.Text = itemName 
newFrame.Name =  itemName 

-- add the ingredients
local canCraft = true
local  ingredientStep = 0
for ingredientName,ingredientQuantity in next, itemInfo.recipe do
ingredientStep = ingredientStep+1
local ingredientFrame = newFrame:FindFirstChild("Ingredient"..ingredientStep)
ingredientFrame.ItemIcon.Image = itemData[ingredientName].image
ingredientFrame.Title.Text  = ingredientQuantity.." "..ingredientName 
ingredientFrame.Name =  ingredientName 
ingredientFrame.Visible  = true 

--ingredientFrame.Quantity.Text = ingredientQuantity

-- do they have this ingredient?
local hasKey = functionBank.HasItem(ingredientName)
if hasKey then
if _G.data.inventory[hasKey].quantity then
-- if they have enough
if _G.data.inventory[hasKey].quantity >= ingredientQuantity then
-- make it green
else -- if they don't have enough
ingredientFrame.ItemIcon.BackgroundColor3 =  colorData.badRed
ingredientFrame.Title.TextColor3  = colorData.badRed
canCraft = false
end

else -- if not quantity, it could be a tool
--ingredientFrame.IngredientName.BackgroundColor3 = colorData.goodGreen
--ingredientFrame.Quantity.BackgroundColor3 = colorData.goodGreen
end -- end of if quantity
else -- if not haskey
ingredientFrame.ItemIcon.BackgroundColor3 =  colorData.badRed
ingredientFrame.Title.TextColor3  = colorData.badRed
canCraft = false
end -- end of if haskey
-- ingredientFrame.Parent = newFrame.IngredientsList
-- ingredientFrame.Visible = true
end -- end of ingredient loop

if canCraft then
--newFrame.CraftButton.Text = ">"
--newFrame.CraftButton.BackgroundColor3 = colorData.goodGreen
newFrame.CraftButton.CanCraftImage.Visible =  true
newFrame.CraftButton.NoCraftImage.Visible  =  false 
else
newFrame.CraftButton.CanCraftImage.Visible =  false
newFrame.CraftButton.NoCraftImage.Visible  =  true
end

newFrame.CraftButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
if functionBank.CanCraftItem(itemName) then
rep.LocalSounds.Quicks.Click1:Play() 
-- if it's a structure, trigger the mouseboundstructure sequence
if itemInfo.deployable then
functionBank.OpenGui()
if dragObject then dragObject = nil end
functionBank.BindMouseStructure(rep.Deployables:FindFirstChild(itemName):Clone())


else -- if they just tried to craft a regular thing
rep.Events.CraftItem:FireServer(itemName)
-- fly it to their inventory

end -- end of if deployable
end -- end of interactinput
end -- end of cancraft
end) -- end of inputbegan

newFrame.LayoutOrder = 999


newFrame.Parent = mainGui.LeftPanel.Craft.List
newFrame.Visible = true

else -- if they don't have the event recipe
-- nothing lol
end
end -- end of iteminfo.EventRecipe

if (itemInfo.craftLevel <= _G.data.level) and not itemInfo.mojoRecipe and not itemInfo.customRecipe then
-- they're good
local newFrame = mainGui.LeftPanel.Craft.Templates.ItemFrame:Clone()
newFrame.ItemIconBackdrop.ItemIcon.Image= itemInfo.image
newFrame.NameLabel.Text = itemName 
newFrame.Name =  itemName 

-- add the ingredients
local canCraft = true
local  ingredientStep = 0
for ingredientName,ingredientQuantity in next, itemInfo.recipe do
ingredientStep = ingredientStep+1
local ingredientFrame = newFrame:FindFirstChild("Ingredient"..ingredientStep)
ingredientFrame.ItemIcon.Image = itemData[ingredientName].image
ingredientFrame.Title.Text  = ingredientQuantity.." "..ingredientName 
ingredientFrame.Name =  ingredientName 
ingredientFrame.Visible  = true 

--ingredientFrame.Quantity.Text = ingredientQuantity

-- do they have this ingredient?
local hasKey = functionBank.HasItem(ingredientName)
if hasKey then
if _G.data.inventory[hasKey].quantity then
-- if they have enough
if _G.data.inventory[hasKey].quantity >= ingredientQuantity then
-- make it green
else -- if they don't have enough
ingredientFrame.ItemIcon.BackgroundColor3 =  colorData.badRed
ingredientFrame.Title.TextColor3  = colorData.badRed
canCraft = false
end

else -- if not quantity, it could be a tool
--ingredientFrame.IngredientName.BackgroundColor3 = colorData.goodGreen
--ingredientFrame.Quantity.BackgroundColor3 = colorData.goodGreen
end -- end of if quantity
else -- if not haskey
ingredientFrame.ItemIcon.BackgroundColor3 =  colorData.badRed
ingredientFrame.Title.TextColor3  = colorData.badRed
canCraft = false
end -- end of if haskey
-- ingredientFrame.Parent = newFrame.IngredientsList
-- ingredientFrame.Visible = true
end -- end of ingredient loop

if canCraft then
--newFrame.CraftButton.Text = ">"
--newFrame.CraftButton.BackgroundColor3 = colorData.goodGreen
newFrame.CraftButton.CanCraftImage.Visible =  true
newFrame.CraftButton.NoCraftImage.Visible  =  false 
else
newFrame.CraftButton.CanCraftImage.Visible =  false
newFrame.CraftButton.NoCraftImage.Visible  =  true
end

newFrame.CraftButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
if functionBank.CanCraftItem(itemName) then
rep.LocalSounds.Quicks.Click1:Play() 
-- if it's a structure, trigger the mouseboundstructure sequence
if itemInfo.deployable then
functionBank.OpenGui()
if dragObject then dragObject = nil end
functionBank.BindMouseStructure(rep.Deployables:FindFirstChild(itemName):Clone()) -- ERRORHERE


else -- if they just tried to craft a regular thing
rep.Events.CraftItem:FireServer(itemName)
-- fly it to their inventory

end -- end of if deployable
end -- end of interactinput
end -- end of cancraft
end) -- end of inputbegan

newFrame.LayoutOrder = itemInfo.craftLevel
newFrame.Parent = mainGui.LeftPanel.Craft.List
newFrame.Visible = true

else -- if their item level isn't high enough
-- add a locked frame
if not itemInfo.mojoRecipe and not itemInfo.customRecipe then
local lockedFrame = mainGui.LeftPanel.Craft.Templates.LockedFrame:Clone()
lockedFrame.NameLabel.Text = "locked ["..itemInfo.craftLevel.."]"
lockedFrame.SecretTitle.Text = itemName
lockedFrame.ItemIconBackdrop.ItemIcon.Image  = itemInfo.image
lockedFrame.LayoutOrder = 200+itemInfo.craftLevel
lockedFrame.Parent = mainGui.LeftPanel.Craft.List
lockedFrame.Visible = true
end

end -- end of if craftlevel is too high
--[[elseif itemInfo.staffItem ~= nil then -- if not relevant
	local main1 = _G.HDAdminMain
	local plrRank = main1.pdata.Rank
	if plrRank < 3 then
		local lockedFrame = mainGui.LeftPanel.Craft.Templates.LockedFrame:Clone()
		lockedFrame.NameLabel.Text = "locked ["..itemInfo.craftLevel.."]"
		lockedFrame.SecretTitle.Text = itemName
		lockedFrame.ItemIconBackdrop.ItemIcon.Image  = itemInfo.image
		lockedFrame.LayoutOrder = 200+itemInfo.craftLevel
		lockedFrame.Parent = mainGui.LeftPanel.Craft.List
		lockedFrame.Visible = true	
	elseif plrRank == 3 then
		local lockedFrame = mainGui.LeftPanel.Craft.Templates.LockedFrame:Clone()
		lockedFrame.NameLabel.Text = "locked ["..itemInfo.craftLevel.."]"
		lockedFrame.SecretTitle.Text = itemName
		lockedFrame.ItemIconBackdrop.ItemIcon.Image  = itemInfo.image
		lockedFrame.LayoutOrder = 200+itemInfo.craftLevel
		lockedFrame.Parent = mainGui.LeftPanel.Craft.List
		lockedFrame.Visible = true	
end--]]
end -- end of relevant


end -- end of big iterative loop

--mainGui.LeftPanel.Craft.List.CanvasSize = UDim2.new(1,0,0,(#mainGui.LeftPanel.Craft.List:GetChildren()-1))
--print("absoluely", mainGui.LeftPanel.Craft.List.UIListLayout.AbsoluteContentSize.Y)
local foundFrame = mainGui.LeftPanel.Craft.List:FindFirstChildOfClass("ImageLabel")
local offset
if foundFrame then
offset = foundFrame.AbsoluteSize.Y+15
else
offset = 5
end
mainGui.LeftPanel.Craft.List.CanvasSize = UDim2.new(1,0,0,(#mainGui.LeftPanel.Craft.List:GetChildren()*offset))
end,


["DrawInventory"] = function(category)
if not category then
category = lastInventoryCategory
end

-- with the clean inventory, let's update the chests
for _,chestFrame in next,mainGui.LeftPanel.Shop.Lists.ChestList:GetChildren() do
if chestFrame:IsA("Frame") then
local count = 0
local hasKey = functionBank.HasItem(chestFrame.Name)

if hasKey then
count = _G.data.inventory[hasKey].quantity
end

chestFrame.Quantity.Text = count

if count > 0  then
chestFrame.OpenButton.Text = "OPEN"
chestFrame.OpenButton.BackgroundColor3 = colorData.goodGreen
chestFrame.OpenButton.Visible = true
chestFrame.Quantity.TextColor3 = colorData.goodGreen

else
chestFrame.OpenButton.Text = ">> "
chestFrame.OpenButton.BackgroundColor3 = colorData.ironGrey
chestFrame.Quantity.TextColor3 = Color3.fromRGB(255, 255, 255)
end -- end of count

end -- end of if it's a frame
end -- end of the chestFrames loop

-- sort the ammo
if _G.data.equipped then
local toolInfo = itemData[_G.data.toolbar[_G.data.equipped].name]
if toolInfo.toolType == "ranged" then
-- bring up the panel
mainGui.Panels.Stats.AmmoImage.Image = itemData[toolInfo.projectileName].image
local hasKey = functionBank.HasItem(toolInfo.projectileName)
if hasKey then
mainGui.Panels.Stats.AmmoImage.ImageLabel.QuantityLabel.Text = _G.data.inventory[hasKey].quantity
else
mainGui.Panels.Stats.AmmoImage.ImageLabel.QuantityLabel.Text = "0"
end
mainGui.Panels.Stats.AmmoImage.Visible = true
end
-- elseif it's not ranged but something else
else
mainGui.Panels.Stats.AmmoImage.Visible = false
end


-- clear the market
for _,itemFrame in next,mainGui.LeftPanel.Market.Lists.AllList:GetChildren() do
if itemFrame:IsA'ImageLabel' then
itemFrame:Destroy()
end
end

for itemKey,itemInfo in next,_G.data.inventory do
	local data = itemData[itemInfo.name]
	if data and data.itemType ~= 'dropChest' and not data.mojoRecipe then
		--  make them for  the  market
		local id = data.image
		
		local newFrame = mainGui.LeftPanel.Market.Templates.ItemFrame:Clone()
		newFrame.Name = itemInfo.name
		newFrame.ImageButton.Image = id
		newFrame.Title.Text = itemInfo.name
		newFrame.QuantityImage.QuantityText.Text = itemInfo.quantity or ''
		newFrame.Visible = true
		newFrame.Parent = mainGui.LeftPanel.Market.Lists.AllList
		
		newFrame.ImageButton.InputBegan:connect(function(input,gp)
			if functionBank.InteractInput(input,gp) then
				mainGui.LeftPanel.Market.Selected.Value = itemInfo.name
				for _,v in next,mainGui.LeftPanel.Market.Lists.AllList:GetChildren() do
					if v:IsA'ImageLabel' then
						if v ~= newFrame then
						--mainGui.LeftPanel.Market.OfferFrame.OfferItem.Image = ''
						v.ImageColor3 = Color3.fromRGB(216, 216, 216)
					else
						mainGui.LeftPanel.Market.OfferFrame.OfferItem.Image = id
						--print(id) debugger
						v.ImageColor3 = colorData.goodGreen
					end
				end
			end
			end
		end)
	end
end

-- clear the current tabs
for _,itemFrame in next,mainGui.RightPanel.Inventory.List:GetChildren() do
if itemFrame:IsA("ImageLabel") then
itemFrame:Destroy()
-- end of internal categoryFrame loop
end
end


for itemKey,itemInfo in next,_G.data.inventory do
local relevant = true
if category and category ~= "all" then
if itemData[itemInfo.name].itemType ~= category then
--print(itemData[itemInfo.name].itemType,"is  not",category) 
relevant = false
else --print("CATEGORY MATCH",itemData[itemInfo.name].itemType)
end
-- the exceptions

end
--  establish relevance
-- put them where they belong
if itemData[itemInfo.name].itemType ~= "dropChest" and  relevant then
local newFrame = mainGui.RightPanel.Inventory.Templates.ItemFrame:Clone()
newFrame.ImageButton.Image = itemData[itemInfo.name].image
newFrame.Name = itemInfo.name


--newFrame.ImageButton.MouseButton1Down:connect(function(input,gp)
--rep.Events.UseBagItem:FireServer(itemInfo.name)
--if itemData[itemInfo.name].nourishment then
--functionBank.CreateSound(rep.LocalSounds.Quicks.Eat,player.PlayerGui,true)
--end
--end)

newFrame.ImageButton.InputBegan:connect(function(input,gp)
if input.UserInputType == Enum.UserInputType.Touch and not  draggingIcon then
--print("dragging icon established",newFrame.Name)
draggingIcon = newFrame:Clone()
draggingIcon.Size = UDim2.new(0,newFrame.AbsoluteSize.X,0,newFrame.AbsoluteSize.Y)
draggingIcon.AnchorPoint = Vector2.new(.5,.5)
draggingIcon.Parent = mainGui.TempEffects
while draggingIcon do
draggingIcon.Position = UDim2.new(0,mouse.X,0,mouse.Y)
run.RenderStepped:wait() 
end
elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
rep.LocalSounds.Quicks.Click1:Play() 
--	print("USING ITEM,MOUSE INPUT")
--			if player:FindFirstChild'PressGui'.Value == false then
--			player:FindFirstChild'PressGui'.Value = true
--		end
rep.Events.NiceExploits:FireServer(itemInfo.name)
if itemData[itemInfo.name].nourishment then
functionBank.CreateSound(rep.LocalSounds.Quicks.Eat,player.PlayerGui,true)
local chosenVal = itemData[itemInfo.name].image
--print(chosenVal)
if chosenVal and chosenVal ~= "" then
rep.Events.ChangeFood:FireServer(chosenVal)
end
end
if MainCounter >= 1 then
SwingUrWeapon()
MainCounter = 0
--	wait(.3)
else
MainCounter += 1
end
elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
rep.Events.DropBagItem:FireServer(itemInfo.name)
end
end)


newFrame.Title.Text = itemInfo.name
if  uis.MouseEnabled then
newFrame.Title.Visible = false
else
newFrame.Title.Visible  = true
end 

newFrame.ImageButton.MouseEnter:connect(function()
newFrame.Title.Visible = true
end)

newFrame.ImageButton.MouseLeave:connect(function()
if uis.MouseEnabled then
newFrame.Title.Visible = false
end 
end)


if itemInfo.quantity and itemInfo.quantity >0 then
newFrame.QuantityImage.QuantityText.Text = itemInfo.quantity
end
newFrame.Parent = mainGui.RightPanel.Inventory.List
newFrame.Visible = true
end -- end of if not chestDrop
end -- end of loop

-- go through all the frames and set their size
--for _,categoryFrame in next,mainGui.RightPanel.Inventory.List:GetChildren() do
--if categoryFrame:IsA("Frame") then
--local frameSize = 100
--local totalFrames = #categoryFrame:GetChildren()-1
--local numInRow = math.floor(categoryFrame.AbsoluteSize.X/100)
--local columns = math.ceil(totalFrames/numInRow)
--categoryFrame.Size = UDim2.new(1,0,0,columns*100)
----categoryFrame.Size = UDim2.new(1,0,0,categoryFrame.UIGridLayout.AbsoluteContentSize.Y)
----categoryFrame.UIGridLayout:ApplyLayout()
--end
--end

local  spAbs = mainGui.RightPanel.Inventory.List.AbsoluteSize
local  cellSize  = (spAbs.X/4)-15
mainGui.RightPanel.Inventory.List.UIGridLayout.CellSize = UDim2.new(0,cellSize,0,cellSize)
mainGui.RightPanel.Inventory.List.CanvasSize = UDim2.new(0,0,0,mainGui.RightPanel.Inventory.List.UIGridLayout.AbsoluteContentSize.Y+100)

--mainGui.RightPanel.Inventory.List.CanvasSize = UDim2.new(1,0,0,mainGui.RightPanel.Inventory.List.UIListLayout.AbsoluteContentSize.Y)
--mainGui.RightPanel.Inventory.List.UIListLayout:ApplyLayout()

-- update the billboards
functionBank.UpdateBillboards()
end,

["ToggleBusyTag"] = function(thing,toggle)
if toggle then
busyTags[thing] = rep.RelativeTime.Value
else
if busyTags[thing] then
busyTags[thing] = nil
end
end
end,


["ClearBetweenPoints"] = function(pos1,pos2,ignoreTable)
local ray = Ray.new(pos1,pos2-pos1)
local part,pos,norm,mat = workspace:FindPartOnRayWithIgnoreList(ray,ignoreTable)
if part then
return false
else
return true
end
end,

["GetDictionaryLength"] = function(tab)
local count = 0
for _,v in next,tab do
count = count+1
end
return count
end,

["SortToolbar"] = function()
for _,v in next,mainGui.Panels.Toolbar.List:GetChildren() do
if v:IsA("ImageButton") then
--repeat if not tonumber(v.Name) then wait() else break end until tonumber(v.Name)
if (functionBank.GetDictionaryLength(_G.data.toolbar[tonumber(v.Name)]) > 0) then
-- print the contents of the table
v.Image = itemData[_G.data.toolbar[tonumber(v.Name)].name].image
else
v.Image = ""
end
if tonumber(v.Name) == _G.data.equipped then
--v.BackgroundColor3 = colorData.goodGreen
v.ActiveIcon.Visible  = true
v.InactiveIcon.Visible = false
else
--v.BackgroundColor3 = colorData.ironGrey
v.ActiveIcon.Visible  = false
v.InactiveIcon.Visible = true
end
end
end

if not _G.data.equipped then
mainGui.Panels.Toolbar.Title.Visible = false
for _,v in next,anims do
v:Stop()
end
mainGui.Panels.Stats.AmmoImage.Visible = false
--  else if  _G.data.equipped

else
if functionBank.GetDictionaryLength(_G.data.toolbar[_G.data.equipped]) >0 then
for _,v in next,anims do
v:Stop()
end
if itemData[_G.data.toolbar[_G.data.equipped].name].idleAnim then
anims[itemData[_G.data.toolbar[_G.data.equipped].name].idleAnim]:Play()
end
local physicalTool = char:WaitForChild(_G.data.toolbar[_G.data.equipped].name,2)
if physicalTool then
for _,v in next,physicalTool:GetChildren() do
if v.Name == "Draw" then
v.Transparency = 1
elseif v.Name == "Rest" then
v.Transparency = 0
end
end
end
end 
local toolInfo = itemData[_G.data.toolbar[_G.data.equipped].name]
if toolInfo.toolType == "ranged" then
-- bring up the panel
mainGui.Panels.Stats.AmmoImage.Image = itemData[toolInfo.projectileName].image
local hasKey = functionBank.HasItem(toolInfo.projectileName)
if hasKey then
mainGui.Panels.Stats.AmmoImage.ImageLabel.QuantityLabel.Text = _G.data.inventory[hasKey].quantity
else
mainGui.Panels.Stats.AmmoImage.ImageLabel.QuantityLabel.Text = "0"
end
mainGui.Panels.Stats.AmmoImage.Visible = true
end
-- elseif it's not ranged but something else
end
end,

} -- END OF FUNCTIONBANK

functionBank.SortToolbar()
--functionBank.SortInventory()
--functionBank.SetupCraftList()
-- functionBank.SortTribeList()
functionBank.DrawInventory()
functionBank.DrawCraftMenu()
functionBank.UpdateCosmetics()
functionBank.UpdateBoosts()
functionBank.DrawTribeGui()
functionBank.DrawPatchNotes()
functionBank.OpenGui() --mainGui.Panels.Card.List.PatchNotes
functionBank.UpdateStats()
functionBank.UpdateMojoMenu()


--for _,v in next,spawnGui.Customization.Appearance.HairFrame:GetChildren() do
--if v:IsA("ImageButton") then
--v.InputBegan:connect(function(input,gp)
--if functionBank.InteractInput(input,gp) then
--_G.data.appearance.hair = v.Name
--rep.Events.CosmeticChange:FireServer("hair",v.Name)
----functionBank.UpdateMimic()
---- tell the server we want to change hair
--end
--end)
--end
--end

--spawnGui.TestServer.InputBegan:connect(function(input,gp)
--if functionBank.InteractInput(input,gp) then
--teleService:Teleport(1402361425)
--end
--end)

--for _,v in next,spawnGui.Customization.Appearance.GenderFrame:GetChildren() do
--if v:IsA("ImageButton") then
--v.InputBegan:connect(function(input,gp)
--if functionBank.InteractInput(input,gp) then
--_G.data.appearance.gender = v.Name
--rep.Events.CosmeticChange:FireServer("gender",v.Name)
----functionBank.UpdateMimic()
--end
--end)
--end
--end

--for _,v in next,spawnGui.Customization.Appearance.SkinFrame:GetChildren() do
--if v:IsA("ImageButton") then
--v.InputBegan:connect(function(input,gp)
--if functionBank.InteractInput(input,gp) then
--_G.data.appearance.skin = v.Name
--rep.Events.CosmeticChange:FireServer("skin",v.Name)
----functionBank.UpdateMimic()
--end
--end)
--end
--end

--for _,v in next,spawnGui.Customization.Appearance.FaceFrame:GetChildren() do
--if v:IsA("ImageButton") then
--v.InputBegan:connect(function(input,gp)
--if functionBank.InteractInput(input,gp) then
--_G.data.appearance.face = v.Name
--rep.Events.CosmeticChange:FireServer("face",v.Name)
----functionBank.UpdateMimic()
--end
--end)
--end
--end

spawnGui.Customization.PlayButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
_G.data.hasSpawned = true
cam.CameraType = Enum.CameraType.Custom
hideOthers = false
ToggleOtherCharacters(true)
rep.Events.SpawnFirst:FireServer()
starterGui:SetCore("TopbarEnabled",true)
end
end)

-- set up craft gui selectors
--for _,v in next,mainGui.Primary.Bag.Craft.Selection:GetChildren() do
--if v:IsA("TextButton") then
--v.InputBegan:connect(function(input,gp)
--if functionBank.InteractInput(input,gp) then
--else return end
--functionBank.SortCraftList(v.Name)
--functionBank.CreateSound(rep.LocalSounds.Quicks.UIToggle,player.PlayerGui)
--end)
--end
--end

-- card list click response
for _,v in next,mainGui.Panels.Card.List:GetChildren() do
if v:IsA("Frame") then
v.ImageButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
functionBank.OpenGui(v)
end
end)
end
end

-- toolbar click response
ghost = nil
for _,v in next,mainGui.Panels.Toolbar.List:GetChildren() do
if v:IsA("ImageButton") then

-- when the left or right click it
v.DragBegin:connect(function(startPos)

ghost = v:Clone()
ghost.Size = UDim2.new(0,v.AbsoluteSize.X,0,v.AbsoluteSize.Y)
ghost.AnchorPoint = Vector2.new(.5,.5)
ghost.Parent = mainGui.TempEffects
while ghost do
run.RenderStepped:wait()
ghost.Position = UDim2.new(0,mouse.X,0,mouse.Y)
end


end)

v.DragStopped:connect(function(xEnd,yEnd)
if ghost then ghost:Destroy() end

local overlapsWith
for _,otherButton in next,mainGui.Panels.Toolbar.List:GetChildren() do
if otherButton:IsA("ImageButton") then
local xmin,xmax,ymin,ymax = 
otherButton.AbsolutePosition.X,
otherButton.AbsolutePosition.X+otherButton.AbsoluteSize.X,
otherButton.AbsolutePosition.Y,
otherButton.AbsolutePosition.Y+otherButton.AbsoluteSize.Y


if xEnd >= xmin and xEnd <=xmax and yEnd >=ymin and yEnd<=ymax then
overlapsWith = otherButton
break
end
end
end

if overlapsWith == v then
rep.Events.EquipTool:FireServer(tonumber(v.Name))
-- it overlapped over another frame
mainGui.Panels.Toolbar.Title.Visible = true

mainGui.Panels.Toolbar.Title.Text = string.upper(_G.data.toolbar[tonumber(v.Name)].name)
rep.LocalSounds.Quicks.ToolSwitch:Play()
--starterGui:SetCore("SetAvatarContextMenuEnabled", false)


elseif overlapsWith and overlapsWith ~= v then
---- it overlapped over another frame
rep.Events.ToolSwap:FireServer(tonumber(v.Name),tonumber(overlapsWith.Name))
--elseif not overlapsWith then
--rep.Events.DropTool:FireServer(tonumber(v.Name))
--starterGui:SetCore("SetAvatarContextMenuEnabled", true)
else
rep.LocalSounds.Quicks.Click1:Play() 
if mouse.X< (cam.ViewportSize.X*.75) and mouse.Y  < (cam.ViewportSize.Y*.9) then
--print("left 3/4 and top 9/10th, drop it")
rep.Events.DropBagItem:FireServer(tonumber(v.Name))
elseif  mouse.X> (cam.ViewportSize.X*.75) and mouse.Y  < (cam.ViewportSize.Y*.9) then
if mainGui.RightPanel.Inventory.Visible then
--print("right 1/4 and top 9/10th, drop it")
rep.Events.Retool:FireServer(tonumber(v.Name))
else
rep.Events.DropBagItem:FireServer(tonumber(v.Name))
end 
else
end
end
end)


v.InputBegan:connect(function(input,gp)
if gp then return end
if input.UserInputType == Enum.UserInputType.MouseButton2 and functionBank.GetDictionaryLength(_G.data.toolbar[tonumber(v.Name)]) >0 then
rep.Events.Retool:FireServer(tonumber(v.Name))
end
end)
end
end


function lerp(a, b, t)
return a * (1-t) + (b*t)
end

function ObjectWithinStuds(obj,studs)
if (root.Position-obj.Position).magnitude <= studs then
return true
else
return false
end
end

function ScanArray(tab,element)
for _,v in next,tab do
if v == element then
return false
end
end
return true
end

function FadeTrack(sound,duration,hold)
local newTweenInfo = TweenInfo.new(duration or 5,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,0,false,hold)
local newGoal = {Volume = 0,}
local newTween = tweenService:Create(sound,newTweenInfo,newGoal)
newTween:Play()
end

function PartsAlongRay(ray)
local ignoreTable = {}
local part,pos
repeat
part,pos = workspace:FindPartOnRayWithIgnoreList(ray,ignoreTable)
if part ~= workspace.Terrain then
ignoreTable[#ignoreTable+1] = part
end
until (not part) or (part == workspace.Terrain)
return ignoreTable
end

local determinePingAsync = coroutine.wrap(function()
while wait(1) do
local start = rep.RelativeTime.Value
local yieldFor = rep.Events.Pinger:InvokeServer()
ping = math.clamp(rep.RelativeTime.Value-start,0,300/1000)
end
end)
determinePingAsync()

function SetupCharacter(newChar)
char = newChar
root,head,hum = newChar:WaitForChild("HumanoidRootPart"),newChar:WaitForChild("Head"),newChar:WaitForChild("Humanoid")
cam = workspace.CurrentCamera
cam.FieldOfView = 65

--[[ lol hi Vince here o.o
local newTweenInfo = TweenInfo.new(13,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
local newGoal = {Size = 13,}
local newTween = tweenService:Create(,newTweenInfo,newGoal)
newTween:Play()
--]]
game.Lighting.Bloom.Size = 13

if not _G.data.hasSpawned then
hideOthers = true
ToggleOtherCharacters(false)

cam.CameraType = Enum.CameraType.Scriptable
lockTorsoOrientation = false 

playerGui.SpawnGui.Enabled = true
playerGui.MainGui.Enabled = false
cam.CFrame = rep.SpawnCamCF.Value
--functionBank.UpdateMimic()
return
else
cam.CameraType = Enum.CameraType.Custom
lockTorsoOrientation = true
playerGui.SpawnGui.Enabled = false
		playerGui.MainGui.Enabled = true
end

rep.LocalSounds.Music.BeautyMusic:Play()
if not _G.data.hasSpawned then
FadeTrack(rep.LocalSounds.Music.BeautyMusic,50,30)
spawn(function()
wait(4)
functionBank.MakeToast({
title = "YOU:",
message = "...Where am I?",
color = colorData.brownUI,
image = "",
duration = 6,
})


wait(6)
if not _G.data.hasSpawned then
functionBank.MakeToast({
title = "YOU:",
message = "I should make a raft...",
					color = colorData.brownUI,
image = "",
duration = 8,
})

wait(4)
end
if not _G.data.hasSpawned then
functionBank.CreateNotification("Press C to open your bag!",colorData.badRed,4)
end
wait(14)
if not _G.data.hasSpawned then
functionBank.CreateNotification(player.Name.."! ".."Press C to open your bag!",colorData.badRed,6)
end

end)
else
FadeTrack(rep.LocalSounds.Music.BeautyMusic,30,0)
end


-- start day1 sequence


repeat if not char.Parent then wait() end until char.Parent == workspace
cam.CameraType = Enum.CameraType.Custom
hum.HealthChanged:connect(function()
functionBank.UpdateStats()
end)

--hum.StateChanged:connect(function()
--if hum:GetState() == Enum.HumanoidStateType.Seated then
--char.Head:FindFirstChild("Running"):Stop()
--local rayDown = Ray.new(root.Position,Vector3.new(0,-10,0))
--local part,pos,norm,mat = workspace:FindPartOnRay(rayDown,char)
--if part and part.Name == "VehicleSeat" then
--bodyRotSpeed = .05
--lockTorsoOrientation = true
--else
--bodyRotSpeed = .2215
--lockTorsoOrientation = false
--end
--else
--lockTorsoOrientation = true
--end
--end)

hum.StateChanged:connect(function()
if hum:GetState() == Enum.HumanoidStateType.Seated then
char.Head:FindFirstChild("Running"):Stop()
lockTorsoOrientation = false
else
lockTorsoOrientation = true
end
end)

hum.Died:connect(function()
lockTorsoOrientation =  false
end)

hum:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
camFocus = root
moveAllowed = true
charActive = true
anims = {}

local loadAnims = coroutine.wrap(function()
for _,v in next,rep.Animations:GetChildren() do
local newAnim = v:Clone() 
anims[v.Name] = hum:LoadAnimation(newAnim)
wait()
end 
end) 
loadAnims()

--local rotationCoroutine = coroutine.wrap(function()
--local bodyRotationGyro = rep.Misc.BodyRotationGyro:Clone()
--bodyRotationGyro.Parent = root
--bodyRotationGyro.AncestryChanged:connect(function()
--if (not bodyRotationGyro:IsDescendantOf(char)) and bodyRotationGyro.Parent ~= nil then
--print("BODYROTATION IS NOT DESCENDANT OF CHAR OR OF NIL")
--player:Kick()
--end
--end)
--while run.RenderStepped:wait() do
--if cam then
--local camPointOut = cam.CFrame*CFrame.new(0,0,-1000)
--if charActive and root and  (not uis:IsKeyDown(Enum.KeyCode.LeftControl)) then
--bodyRotationGyro.CFrame = CFrame.new(root.Position,camPointOut.p)
--end
--end
--end
--end)
--rotationCoroutine()
end


if player.Character then
SetupCharacter(player.Character)
end

player.CharacterAdded:connect(function(newChar)
SetupCharacter(newChar)
--if currentWeather == "Rain" then
--functionBank.MakeItRain()
--end

newChar.DescendantAdded:connect(function(descendant)
--if descendant:IsA("BodyMover") and not (descendant:IsA("BodyGyro") and descendant.Parent == newChar.PrimaryPart) then
--error(player.Name,"removed")
--player:Kick()
--end
if descendant:IsA("Tool") or descendant:IsA("HopperBin") then
--print("lmao f3x tools detected")
player:Kick()
end
end)

end)

--run:BindToRenderStep("AfterCamera", Enum.RenderPriority.Camera.Value, function()
--if char.Head.CanCollide == false and (char.Humanoid.Health >0)  then
--print(player.Name,"head collide")
--
--end
--end)

local selectionBox = Instance.new("SelectionBox")
selectionBox.Parent = workspace
selectionBox.Color3 = Color3.fromRGB(170, 255, 0)

local lastRotate = tick()
run.RenderStepped:connect(function()
mainGui.Panels.MouseFrame.Position = UDim2.new(0,mouse.X+40,0,mouse.Y+10)

if charActive and root then

if rainPart then
rainPart.CFrame = root.CFrame*CFrame.new(0,100,0)
end

if snowPart then -- weatherupdate
snowPart.CFrame = root.CFrame*CFrame.new(0,200,0)
end

--[[local lateralRootVelocity = Vector3.new(root.Velocity.X,0,root.Velocity.Z)
if lateralRootVelocity.magnitude>30 then
print(lateralRootVelocity)
print("throtttle")
root.Velocity = Vector3.new(0,0,0)
end]]

local ray = Ray.new(root.Position+Vector3.new(0,5,0),Vector3.new(0,-15,0))
local part,pos,norm,mat = workspace:FindPartOnRay(ray,char)
if mat == Enum.Material.Water and not (functionBank.HasMojoRecipe("Water Walker") and (not _G.data.disabledMojo["Water Walker"]))then
hum.WalkSpeed = currentWalkSpeed/2.5
elseif player.UserId == 4 then
hum.WalkSpeed = 60
else
hum.WalkSpeed = currentWalkSpeed
end
-- rotate torso
local camPointOut = cam.CFrame*CFrame.new(0,0,-1000)
if charActive and root and  (not uis:IsKeyDown(Enum.KeyCode.LeftControl)) then
local stayLock = true
local rayDown = Ray.new(root.Position,Vector3.new(0,-10,0))
local part,pos,norm,mat = workspace:FindPartOnRay(rayDown,char)
if part and (part.Name == "VehicleSeat" or part.Name == "Seat") then
stayLock= false
if part.Name == "VehicleSeat" and hum:GetState() == Enum.HumanoidStateType.Seated then
local rayPart,at = functionBank.MiddleScreenRay()
part.LookEvent:FireServer(at)
end

end
if lockTorsoOrientation and stayLock then
local newDir = CFrame.new(root.Position,Vector3.new(camPointOut.p.x,root.Position.Y,camPointOut.p.z))
root.CFrame = root.CFrame:lerp(newDir,bodyRotSpeed)
local angleBetween = root.CFrame.lookVector:Dot(newDir.lookVector)
if angleBetween < 5 and (tick()-lastRotate>1)then
root.CFrame = newDir
end
lastRotate = tick()
end

end
end

if not _G.data.hasSpawned then
hum.WalkSpeed = 0
hum.JumpPower = 0
end

if charActive and root  and head then
if (cam.CFrame.p-head.Position).magnitude < 1.5 and _G.data.equipped then

for _,v in next,char:GetDescendants() do
if v:IsA("BasePart") then
if v.Name ~= "GhostRightArm" and v.Parent.Name ~= (_G.data.toolbar[_G.data.equipped].name) then
v.LocalTransparencyModifier = 1
else
v.LocalTransparencyModifier = 0
end
end
end
else
if char:FindFirstChild("GhostRightArm") then
char.GhostRightArm.LocalTransparencyModifier = 1
end
end
end

if charActive and root then
if mouse.Target then

if ((mouse.Target:FindFirstChild("Draggable") or mouse.Target.Parent:FindFirstChild("Draggable")) or dragObject  or mouse.Target:FindFirstChild("DoorButton") or mouse:FindFirstChild("OpenGuiPanel")) and ObjectWithinStuds(mouse.Target,25) then
mouse.Icon = "http://www.roblox.com/asset/?id=455570287"

elseif mouse.Target.Parent:FindFirstChild("Interactable") then
if mouse.Target.Parent:FindFirstChild("InteractPart") then
selectionBox.Adornee = mouse.Target.Parent.InteractPart
else
selectionBox.Adornee = mouse.Target.Parent
end

elseif ((mouse.Target:FindFirstChild("Health") or mouse.Target.Parent:FindFirstChild("Health") or mouse.Target.Parent:FindFirstChild("Humanoid")) and _G.data.equipped and (mouse.Target.Position-root.Position).magnitude <= 25) or activateHeld then
mouse.Icon = "rbxassetid://117431027"
else mouse.Icon = ""
selectionBox.Adornee = nil
end

local targName
if mouse.Target:FindFirstChild("Pickup") then
targName = mouse.Target.Name
elseif mouse.Target.Parent:FindFirstChild("Pickup") then
targName = mouse.Target.Parent.Name
end
if targName and ObjectWithinStuds(mouse.Target,25) then
mainGui.Panels.MouseFrame.Title.Text = targName
mainGui.Panels.MouseFrame.ELabel.Text = "F - harvest"
mainGui.Panels.MouseFrame.Visible = true
if (itemData[targName] and itemData[targName].nourishment) then
mainGui.Panels.MouseFrame.FLabel.Text = "E - eat"
elseif mouse.Target.Material == Enum.Material.Water then
mainGui.Panels.MouseFrame.FLabel.Text = "E - drink"
else
mainGui.Panels.MouseFrame.FLabel.Text = ""
end

else
mainGui.Panels.MouseFrame.Visible = false
end


else mouse.Icon = ""
selectionBox.Adornee = nil
end -- end of if mouse.Target
else mouse.Icon = ""
selectionBox.Adornee = nil
end -- end of if char active and root
end)


local draggerBodyPos
--[[
draggerBodyPos.AncestryChanged:connect(function()
local invalid = false
for _,v in next,game.Players:GetPlayers() do
if v.Character then
if draggerBodyPos:IsDescendantOf(v.Character) then
print(player.Name,"DRAGGERBODYPOS WAS MOVED TO A DESCENDANT OF CHAR")
invalid = true
end
end
end
if draggerBodyPos.Parent then
if draggerBodyPos.Parent:IsA("BasePart") then
if not draggerBodyPos.Parent:FindFirstChild("Draggable") then
print(player.Name,"DRAGGERBODYPOS IS NOT IN A DRAGGABLE OBJECT")
invalid = true
end
end
end
if invalid then
player:Kick()
end
end)
]]--


function DragFunction()

if not draggerBodyPos then
draggerBodyPos= Instance.new("BodyPosition")
draggerBodyPos.Parent = dragObject
draggerBodyPos.P = 25000
draggerBodyPos.D = 1500
draggerBodyPos.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
draggerBodyPos.AncestryChanged:connect(function()
if (not draggerBodyPos) or (not draggerBodyPos.Parent) then
draggerBodyPos = nil
--[[
if dragObject then
dragObject.CanCollide = true
end
]]--
end
end)
end

if dragObject and draggerBodyPos then
if dragObject.Parent and dragObject.Parent:IsA("Model") and dragObject.Parent ~= workspace then
mouse.TargetFilter = dragObject.Parent
else
mouse.TargetFilter = dragObject
end
if dragObject:FindFirstChild("Draggable") or (dragObject.Parent and dragObject.Parent:FindFirstChild("Draggable")) then
local reachRay = Ray.new(root.Position,(mouse.Hit.p-root.Position).unit*math.clamp((root.Position-mouse.Hit.p).magnitude,3,30))
local part,pos = workspace:FindPartOnRayWithIgnoreList(reachRay,PartsAlongRay(reachRay))
draggerBodyPos.Position = pos+Vector3.new(0,(dragObject.Size.Y/2),0)
end
end
end


local hotkeyBank = {
["pickup"] = Enum.KeyCode.F,
["eat"] = Enum.KeyCode.E,
["rotate"] = Enum.KeyCode.R,
["toggleBag"] = Enum.KeyCode.C,
["toggleTribe"] = Enum.KeyCode.T,
--["togglePatchNotes"] = Enum.KeyCode.X,
['toggleBobuxShop'] = Enum.KeyCode.J,
["toggleShop"] = Enum.KeyCode.Z,
["toggleMojo"] = Enum.KeyCode.K,
["toggleAdminPanel"] = Enum.KeyCode.L,
}


function SwingUrWeapon()
	if _G.data.equipped then
		if ignoreLastSwing then ignoreLastSwing = false return end
		if (rep.RelativeTime.Value-_G.data.toolbar[_G.data.equipped].lastSwing >= itemData[_G.data.toolbar[_G.data.equipped].name].speed) then
			--print("good to fire",rep.RelativeTime.Value-_G.data.toolbar[_G.data.equipped].lastSwing,">=",itemData[_G.data.toolbar[_G.data.equipped].name].speed)
			_G.data.toolbar[_G.data.equipped].lastSwing = rep.RelativeTime.Value
--[[
local regionOrigin = root.CFrame*CFrame.new(0,0,-3)
regionLeftFrontTop,regionRightBackBottom =
regionOrigin*CFrame.new(-4,2,-5),regionOrigin*CFrame.new(4,-2,2)
print("good to fire")
]]--
			local toolName,toolInfo = _G.data.toolbar[_G.data.equipped].name,itemData[_G.data.toolbar[_G.data.equipped].name]
			if toolInfo.toolType == "ranged" then
				if not functionBank.HasItem(toolInfo.projectileName) then
					functionBank.CreateNotification("No ammo!",colorData.badRed,2)
					return
				end

				activateHeld = true
				-- we finna draw back

				for _,v in next,char:WaitForChild(toolName):GetChildren() do
					if v.Name == "Draw" then
						v.Transparency = 0
					elseif v.Name == "Rest" then
						v.Transparency = 1
					end
				end
				if toolInfo.pullSound then
					functionBank.CreateSound(rep.LocalSounds.BowSounds[toolInfo.soundClass].Pullback,root)
				end
				drawBack = 0
				if uis.MouseEnabled then
					if itemData[toolName].drawAnim then
						anims[itemData[toolName].drawAnim]:Play(itemData[toolName].drawAnim.drawAnimLength)
					end
					while activateHeld do
						drawBack = math.clamp(drawBack+.025,0,itemData[toolName].drawLength)
						cam.FieldOfView = 65-(drawBack*2)
						hum.WalkSpeed = currentWalkSpeed-(drawBack*10)
						mainGui.Panels.Stats.Power.Visible = true
						mainGui.Panels.Stats.Power.Slider.Size = UDim2.new(drawBack/itemData[toolName].drawLength,0,1,0)
						run.RenderStepped:wait()
					end

				elseif uis.TouchEnabled then
					if itemData[toolName].drawAnim then
						anims[itemData[toolName].drawAnim]:Play(itemData[toolName].drawAnim,0)
						anims[itemData[toolName].drawAnim]:Stop(itemData[toolName].drawAnim,3)
					end
					activateHeld = false
					drawBack = itemData[toolName].drawLength
				end 

				mainGui.Panels.Stats.Power.Visible = false
				_G.data.toolbar[_G.data.equipped].lastSwing = rep.RelativeTime.Value
				functionBank.CreateSound(rep.LocalSounds.BowSounds[toolInfo.soundClass].Fire,root)
				local part,at = functionBank.CursorRay()

				MakeProjectile(toolName,CFrame.new((char.PrimaryPart.CFrame*CFrame.new(1.4,-.4,-3)).p,at),(drawBack/itemData[toolName].drawLength),true)
				drawBack = 0
				cam.FieldOfView = 65

				for _,v in next,char:WaitForChild(toolName):GetChildren() do
					if v.Name == "Draw" then
						v.Transparency = 1
					elseif v.Name == "Rest" then
						v.Transparency = 0
					end
				end
				if itemData[toolName].drawAnim then
					anims[itemData[toolName].drawAnim]:Stop(itemData[toolName].drawAnimSlow)
				end
				if toolInfo.postFireSound then
					functionBank.CreateSound(rep.LocalSounds.BowSounds[toolInfo.soundClass].PostFire,root)
				end


				-- upon release, send that bizniss
			else -- if it's not a ranged tool
				collisionDetect.Size = Vector3.new(6,11,5)
				collisionDetect.CFrame = char.PrimaryPart.CFrame*CFrame.new(0,-2,-collisionDetect.Size.Z/2)
				collisionDetect.Parent = char

				local touchedParts = collisionDetect:GetTouchingParts()
				collisionDetect.Parent =nil
				local curated = {}
				for  _,v in next,touchedParts  do
					if v:IsDescendantOf(char) or v ==  workspace.Terrain then
					else
						curated[#curated+1] = v
					end
				end

				if itemData[_G.data.toolbar[_G.data.equipped].name].useType == "Slash" then
					rep.Events.SwingTool:FireServer(rep.RelativeTime.Value ,curated)
					--if itemData[_G.data.toolbar[_G.data.equipped].name].useType then
					anims[itemData[_G.data.toolbar[_G.data.equipped].name].useType]:Play(.1,1,1) -- play the slash animation
				--	print('played')

				elseif itemData[_G.data.toolbar[_G.data.equipped].name].useType == "Horn" then
					anims[itemData[_G.data.toolbar[_G.data.equipped].name].useType]:Play() -- play the horn animation
					rep.Events.MusicTool:FireServer(rep.RelativeTime.Value)

				elseif itemData[_G.data.toolbar[_G.data.equipped].name].useType == "Target" then
					local screenRay = cam:ScreenPointToRay(mouse.X,mouse.Y)
					local newRay = Ray.new(screenRay.Origin,screenRay.Direction*2000)
					rep.Events.TargetTool:FireServer(rep.RelativeTime.Value,functionBank.FirstPartOnRay(newRay,char))

				elseif itemData[_G.data.toolbar[_G.data.equipped].name].useType == "Rod" then
					--print("yoot")
					local screenRay = cam:ScreenPointToRay(mouse.X,mouse.Y)
					local newRay = Ray.new(screenRay.Origin,screenRay.Direction*2000)
					rep.Events.RodSwing:FireServer(rep.RelativeTime.Value,newRay)

				end

				return
			end
		end
	end
end
function SwingTool()
	if _G.data.equipped then
		if ignoreLastSwing then ignoreLastSwing = false return end
		if (rep.RelativeTime.Value-_G.data.toolbar[_G.data.equipped].lastSwing >= itemData[_G.data.toolbar[_G.data.equipped].name].speed) then
			--print("good to fire",rep.RelativeTime.Value-_G.data.toolbar[_G.data.equipped].lastSwing,">=",itemData[_G.data.toolbar[_G.data.equipped].name].speed)
			_G.data.toolbar[_G.data.equipped].lastSwing = rep.RelativeTime.Value
--[[
local regionOrigin = root.CFrame*CFrame.new(0,0,-3)
regionLeftFrontTop,regionRightBackBottom =
regionOrigin*CFrame.new(-4,2,-5),regionOrigin*CFrame.new(4,-2,2)
print("good to fire")
]]--
			local toolName,toolInfo = _G.data.toolbar[_G.data.equipped].name,itemData[_G.data.toolbar[_G.data.equipped].name]
			if toolInfo.toolType == "ranged" then
				if not functionBank.HasItem(toolInfo.projectileName) then
					functionBank.CreateNotification("No ammo!",colorData.badRed,2)
					return
				end

				activateHeld = true
				-- we finna draw back

				for _,v in next,char:WaitForChild(toolName):GetChildren() do
					if v.Name == "Draw" then
						v.Transparency = 0
					elseif v.Name == "Rest" then
						v.Transparency = 1
					end
				end
				if toolInfo.pullSound then
					functionBank.CreateSound(rep.LocalSounds.BowSounds[toolInfo.soundClass].Pullback,root)
				end
				drawBack = 0
				if uis.MouseEnabled then
					if itemData[toolName].drawAnim then
						anims[itemData[toolName].drawAnim]:Play(itemData[toolName].drawAnim.drawAnimLength)
					end
					while activateHeld do
						drawBack = math.clamp(drawBack+.025,0,itemData[toolName].drawLength)
						cam.FieldOfView = 65-(drawBack*2)
						hum.WalkSpeed = currentWalkSpeed-(drawBack*10)
						mainGui.Panels.Stats.Power.Visible = true
						mainGui.Panels.Stats.Power.Slider.Size = UDim2.new(drawBack/itemData[toolName].drawLength,0,1,0)
						run.RenderStepped:wait()
					end

				elseif uis.TouchEnabled then
					if itemData[toolName].drawAnim then
						anims[itemData[toolName].drawAnim]:Play(itemData[toolName].drawAnim,0)
						anims[itemData[toolName].drawAnim]:Stop(itemData[toolName].drawAnim,3)
					end
					activateHeld = false
					drawBack = itemData[toolName].drawLength
				end 

				mainGui.Panels.Stats.Power.Visible = false
				if _G.data.equipped then 
					_G.data.toolbar[_G.data.equipped].lastSwing = rep.RelativeTime.Value 
				elseif itemData[_G.data.toolbar[_G.data.equipped].name].toolType == "ranged" then
					-- its a bow, dont end
				else
					warn('nice try') return
				end
				functionBank.CreateSound(rep.LocalSounds.BowSounds[toolInfo.soundClass].Fire,root)
				local part,at = functionBank.CursorRay()

				MakeProjectile(toolName,CFrame.new((char.PrimaryPart.CFrame*CFrame.new(1.4,-.4,-3)).p,at),(drawBack/itemData[toolName].drawLength),true)
				drawBack = 0
				cam.FieldOfView = 65

				for _,v in next,char:WaitForChild(toolName):GetChildren() do
					if v.Name == "Draw" then
						v.Transparency = 1
					elseif v.Name == "Rest" then
						v.Transparency = 0
					end
				end
				if itemData[toolName].drawAnim then
					anims[itemData[toolName].drawAnim]:Stop(itemData[toolName].drawAnimSlow)
				end
				if toolInfo.postFireSound then
					functionBank.CreateSound(rep.LocalSounds.BowSounds[toolInfo.soundClass].PostFire,root)
				end


				-- upon release, send that bizniss
			else -- if it's not a ranged tool
				collisionDetect.Size = Vector3.new(6,11,5)
				collisionDetect.CFrame = char.PrimaryPart.CFrame*CFrame.new(0,-2,-collisionDetect.Size.Z/2)
				collisionDetect.Parent = char

				local touchedParts = collisionDetect:GetTouchingParts()
				collisionDetect.Parent =nil
				local curated = {}
				for  _,v in next,touchedParts  do
					if v:IsDescendantOf(char) or v ==  workspace.Terrain then
					else
						curated[#curated+1] = v
					end
				end

				if itemData[_G.data.toolbar[_G.data.equipped].name].useType == "Slash" then
					rep.Events.SwingTool:FireServer(rep.RelativeTime.Value ,curated)
					--if itemData[_G.data.toolbar[_G.data.equipped].name].useType then
					anims[itemData[_G.data.toolbar[_G.data.equipped].name].useType]:Play() -- play the slash animation

				elseif itemData[_G.data.toolbar[_G.data.equipped].name].useType == "Horn" then
					anims[itemData[_G.data.toolbar[_G.data.equipped].name].useType]:Play() -- play the horn animation
					rep.Events.MusicTool:FireServer(rep.RelativeTime.Value)

				elseif itemData[_G.data.toolbar[_G.data.equipped].name].useType == "Target" then
					local screenRay = cam:ScreenPointToRay(mouse.X,mouse.Y)
					local newRay = Ray.new(screenRay.Origin,screenRay.Direction*2000)
					rep.Events.TargetTool:FireServer(rep.RelativeTime.Value,functionBank.FirstPartOnRay(newRay,char))

				elseif itemData[_G.data.toolbar[_G.data.equipped].name].useType == "Rod" then
					--print("yoot")
					local screenRay = cam:ScreenPointToRay(mouse.X,mouse.Y)
					local newRay = Ray.new(screenRay.Origin,screenRay.Direction*2000)
					rep.Events.RodSwing:FireServer(rep.RelativeTime.Value,newRay)

				end

				return
			end
		end
	end
end



uis.TouchEnded:connect(function(input,gp)
if not gp then
SwingTool()
end
-- elseif the input happened over a gui object
if draggingIcon then
-- determine mouseX and mouseY and if they fall within the boundaries
if mouse.X< (cam.ViewportSize.X*.75) then
rep.Events.DropBagItem:FireServer(draggingIcon.Name)
draggingIcon:Destroy()
draggingIcon = nil
else
-- determine if it's within the boundaries of one of the inventory items
--draggingIcon:Destroy() 
--draggingIcon =nil
local overlapsWith
local contents = mainGui.RightPanel.Inventory.List:GetChildren()

for _,frame in next,contents do
if frame:IsA("ImageLabel") then
--if mouse.X <= frame.AbsoluteSize.X+frame.AbsolutePosition.X and
--mouse.X >= frame.AbsolutePosition.X and
--mouse.Y <= frame.AbsoluteSize.Y+frame.AbsolutePosition.Y and
--mouse.Y >= frame.AbsolutePosition.Y then
local xmin,xmax,ymin,ymax = 
frame.AbsolutePosition.X,
frame.AbsolutePosition.X+frame.AbsoluteSize.X,
frame.AbsolutePosition.Y,
frame.AbsolutePosition.Y+frame.AbsoluteSize.Y
if mouse.X >= xmin and mouse.X <=xmax and mouse.Y >=ymin and mouse.Y <=ymax then
overlapsWith = frame
break
end
end
end

if overlapsWith and  overlapsWith.Name == draggingIcon.Name then
if itemData[draggingIcon.name].nourishment then
functionBank.CreateSound(rep.LocalSounds.Quicks.Eat,player.PlayerGui,true)
end
rep.Events.NiceExploits:FireServer(draggingIcon.Name)
end
draggingIcon:Destroy()
draggingIcon = nil
end
else
end
--end of if not gp
end)

function PlaceStructureFunction()
	if mouseBoundStructure then
--contextAction:UnbindAction("PlaceStructureBinding")
if uis.MouseEnabled then
	--print("place that structure boiii",mouseBoundStructure.Name)
	rep.Events.PIaceStructure:FireServer(mouseBoundStructure.Name,mouseBoundStructure.PrimaryPart.CFrame,buildingRotation)
		functionBank.ClearMouseBoundStructure()
		functionBank.OpenGui(mainGui.Panels.Card.List.Bag)
		return
	elseif uis.TouchEnabled then
		rep.Events.PIaceStructure:FireServer(mouseBoundStructure.Name,mouseBoundStructure.PrimaryPart.CFrame,buildingRotation)
		functionBank.ClearMouseBoundStructure()
		functionBank.OpenGui(mainGui.Panels.Card.List.Bag)
	end
	end
end

uis.TouchMoved:connect(function(input,gp)
if not gp then
ignoreLastSwing = true
end
end)

uis.InputBegan:connect(function(input,gp)
if gp then return end
local keyCode = input.KeyCode
local vdPlayer = game.Players.LocalPlayer
--print (vdPlayer)

if input.UserInputType == Enum.UserInputType.MouseWheel then
-- end of MouseWheel

elseif input.UserInputType == Enum.UserInputType.Gamepad1 then
if input.KeyCode == Enum.KeyCode.ButtonA then
end
--  end  of  if  gamepad

elseif input.UserInputType == Enum.UserInputType.Keyboard then
local num = input.KeyCode.Value-48
if num >= 1 and num <= 6 then -- if it's a number between 1 and 6
if num == _G.data.equipped or functionBank.GetDictionaryLength(_G.data.toolbar[num])==0 then -- if it's the tool they already have, or an empty slot
for _,v in next,anims do
v:Stop()
end
_G.data.equipped = nil
--starterGui:SetCore("SetAvatarContextMenuEnabled", true)

elseif num ~= _G.data.equipped and functionBank.GetDictionaryLength(_G.data.toolbar[num])>0 then -- otherwise, if it's not a slot they have equipped and the slot contains a tool
_G.data.equipped = num
mainGui.Panels.Toolbar.Title.Visible = true
mainGui.Panels.Toolbar.Title.Text = string.upper(_G.data.toolbar[_G.data.equipped].name)
rep.LocalSounds.Quicks.ToolSwitch:Play()

--starterGui:SetCore("SetAvatarContextMenuEnabled", false)
end
rep.Events.EquipTool:FireServer(num)
functionBank.SortToolbar()

elseif keyCode == Enum.KeyCode.V then
--voodootest
local part,pos,norm,mat = functionBank.CursorRay()
rep.Events.VoodooSpell:FireServer(pos)

elseif keyCode == Enum.KeyCode.R then
if dragObject then
dragObject.CFrame = CFrame.new(dragObject.CFrame.p)*CFrame.Angles(0,buildingRotation,0)
dragObject.Velocity = Vector3.new(0,0,0)
elseif mouseBoundStructure then
while uis:IsKeyDown(Enum.KeyCode.R) do
buildingRotation = buildingRotation+3
run.RenderStepped:wait()
end
end

elseif keyCode == Enum.KeyCode.Q then
if dragObject then
dragObject.CFrame = CFrame.new(dragObject.CFrame.p)*CFrame.Angles(0,buildingRotation,0)
dragObject.Velocity = Vector3.new(0,0,0)
elseif mouseBoundStructure then
while uis:IsKeyDown(Enum.KeyCode.Q) do
buildingRotation = buildingRotation-3
run.RenderStepped:wait()
end
end
			
		elseif keyCode == Enum.KeyCode.J then
			functionBank.OpenGui(mainGui.Panels.Card.List.BobuxShop)
			
elseif keyCode == hotkeyBank.pickup then
--print("PICKUP KEY")
if mouse.Target and (mouse.Target:FindFirstChild("Pickup") or mouse.Target.Parent:FindFirstChild("Pickup")) and ((mouse.Target.Position-root.Position).magnitude <= 25) and (player.Character and player.Character.Humanoid and player.Character.Humanoid.Health >0) then -- and functionBank.ClearBetweenPoints(mouse.Target.Position,char.Head.Position,AppendTables({char:GetDescendants(),{mouse.Target}})) then
				
if uis.TouchEnabled then
ignoreLastSwing = true
end
local targ
if mouse.Target:FindFirstChild("Pickup") then
targ = mouse.Target
elseif mouse.Target.Parent:FindFirstChild("Pickup") then
targ = mouse.Target.Parent
end
local canHold = functionBank.CanBearLoad(targ.Name)
--print(targ.Name)

if canHold then
rep.LocalSounds.Quicks.Pickup:Play()
rep.Events.Pickkup:FireServer(targ)
if ping <= 1/1000 then
else
functionBank.CollectPart(targ)
--targ:Destroy()
end
-- they can't hold it mannnn
else
functionBank.CreateNotification("BAG FULL",colorData.badRed,1.3)
--spawn(function()
--mainGui.Panels.Stats.Bag.Slider.BackgroundColor3 = colorData.badRed
--wait(.1)
--mainGui.Panels.Stats.Bag.Slider.BackgroundColor3 = Color3.fromRGB(255, 185, 185)
--wait(.1)
--mainGui.Panels.Stats.Bag.Slider.BackgroundColor3 = colorData.badRed
--wait(.1)
--mainGui.Panels.Stats.Bag.Slider.BackgroundColor3 = Color3.fromRGB(255, 185, 185)
--wait(.1)
--mainGui.Panels.Stats.Bag.Slider.BackgroundColor3 = colorData.badRed
--wait(.1)
--mainGui.Panels.Stats.Bag.Slider.BackgroundColor3 = Color3.fromRGB(255, 185, 185)
--wait(.1)
--end)

end
else
-- there is nothing named pickup innit boii
end

elseif keyCode == hotkeyBank.eat then
local targ = mouse.Target
if targ and ((itemData[targ.Name] and itemData[targ.Name].nourishment and targ:FindFirstChild("Pickup")) or targ.Material == Enum.Material.Water) and (targ.Position-root.Position).magnitude <=25 then
if targ ~= workspace.Terrain then
rep.Events.Consume:FireServer(targ)
if ping <= 1/1000 then
--print("I ate a thing, server should kill it")
else
--print("destroying heckin thing")
if targ:IsA("BasePart") then
functionBank.CreateParticles(rep.Particles.Fissure,targ.CFrame.p,targ.CFrame.p+Vector3.new(0,1,0),math.random(2,4),4,{Color =ColorSequence.new(targ.Color,targ.Color)})
--instance,origin,facing,count,duration,particleProperties
end
targ:Destroy()
end
						
functionBank.CreateSound(rep.LocalSounds.Quicks.Eat,playerGui,true)
else
-- play drink
end
end

elseif keyCode == hotkeyBank.toggleBag then
--print("TOGGLE  KEY REE")
functionBank.OpenGui(mainGui.Panels.Card.List.Bag)
functionBank.ClearMouseBoundStructure()
elseif keyCode == hotkeyBank.toggleTribe then
functionBank.OpenGui(mainGui.Panels.Card.List.Tribe)
functionBank.DrawTribeGui()
functionBank.ClearMouseBoundStructure()

elseif keyCode == hotkeyBank.togglePatchNotes then
functionBank.OpenGui(mainGui.Panels.Card.List.PatchNotes)

elseif keyCode == hotkeyBank.toggleShop then
functionBank.OpenGui(mainGui.Panels.Card.List.Shop)
			
elseif keyCode == hotkeyBank.toggleBobuxShop then
functionBank.OpenGui(mainGui.Panels.Card.List.BobuxShop)
			
elseif keyCode == hotkeyBank.toggleMojo then
functionBank.OpenGui(mainGui.Panels.Card.List.Mojo)
			
elseif keyCode == hotkeyBank.toggleAdminPanel then
functionBank.OpenGui(mainGui.Panels.Card.List.AdminPanel)
end

elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
local part,at = functionBank.CursorRay(workspace.Terrain)
if part and part.Name == "RadioButton" then
part.Clicker:FireServer()
return
end 

local interactionType
if input.UserInputType  == Enum.UserInputType.MouseButton1 then
interactionType = "mouse" 
elseif input.UserInputType == Enum.UserInputType.Touch then
interactionType = "touch"
end

if mouseBoundStructure then
if interactionType == "mouse" then
PlaceStructureFunction()

if uis:IsKeyDown(Enum.KeyCode.LeftShift) then --and functionBank.HasItem(mouseBoundStructure.Name) then
hasShifted = true
return
else
functionBank.ClearMouseBoundStructure()
functionBank.OpenGui(mainGui.Panels.Card.List.Bag)
end
-- play an error noise, toast them
functionBank.ClearMouseBoundStructure()
else
end
return
end


if mouse.Target then
if (mouse.Target:FindFirstChild("Pickup") or mouse.Target.Parent:FindFirstChild("Pickup")) and ((mouse.Target.Position-root.Position).magnitude <= 25) and (player.Character and player.Character.Humanoid and player.Character.Humanoid.Health >0) then -- and functionBank.ClearBetweenPoints(mouse.Target.Position,char.Head.Position,AppendTables({char:GetDescendants(),{mouse.Target}})) then
if interactionType == "touch" then
local targ
if mouse.Target:FindFirstChild("Pickup") then
targ = mouse.Target
elseif mouse.Target.Parent:FindFirstChild("Pickup") then
targ = mouse.Target.Parent
end
local canHold = functionBank.CanBearLoad(targ.Name)
								
if canHold then
rep.LocalSounds.Quicks.Pickup:Play()
rep.Events.Pickkup:FireServer(targ)
if ping <= 1/1000 then
else
functionBank.CollectPart(targ)
--targ:Destroy()
end
-- they can't hold it mannnn
else
functionBank.CreateNotification("BAG FULL",colorData.badRed,1.3)
--spawn(function()
--mainGui.Panels.Stats.List.Bag.Slider.BackgroundColor3 = colorData.badRed
--wait(.1)
--mainGui.Panels.Stats.List.Bag.Slider.BackgroundColor3 = Color3.fromRGB(255, 185, 185)
--wait(.1)
--mainGui.Panels.Stats.List.Bag.Slider.BackgroundColor3 = colorData.badRed
--wait(.1)
--mainGui.Panels.Stats.List.Bag.Slider.BackgroundColor3 = Color3.fromRGB(255, 185, 185)
--wait(.1)
--mainGui.Panels.Stats.List.Bag.Slider.BackgroundColor3 = colorData.badRed
--wait(.1)
--mainGui.Panels.Stats.List.Bag.Slider.BackgroundColor3 = Color3.fromRGB(255, 185, 185)
--wait(.1)
--end)

end
end
end

if mouse.Target.Parent:FindFirstChild("Interactable") and ObjectWithinStuds(mouse.Target,25) then
--print("DO IT YO")
if selectionTarget  then
if selectionTarget == mouse.Target.Parent then
if playerGui:FindFirstChild(selectionTarget.Name) then
playerGui:FindFirstChild(selectionTarget.Name):Destroy()
selectionTarget = nil
end
return
else 
if playerGui:FindFirstChild(selectionTarget.Name) then
playerGui:FindFirstChild(selectionTarget.Name):Destroy()
selectionTarget = nil
end
end
end
selectionTarget = mouse.Target.Parent
functionBank.CreateSound(rep.LocalSounds.Quicks.UIToggle,player.PlayerGui)
local guiClone = rep.Guis:FindFirstChild(mouse.Target.Parent.Name)
if guiClone then guiClone = guiClone:Clone() end
if guiClone then
guiClone.Parent = playerGui
guiClone.Adornee = mouse.Target.Parent.PrimaryPart
guiClone.Frame.List.Exit.MouseButton1Down:connect(function()
selectionTarget = nil
guiClone:Destroy()
end)
end
functionBank.UpdateBillboards()
-- give them the interactable menu for the object
-- functionBank update interactable, it finds the UI through the selectionTarget
return
end

if (mouse.Target:FindFirstChild("Draggable") or mouse.Target.Parent:FindFirstChild("Draggable")) and ObjectWithinStuds(mouse.Target,25) and interactionType == "mouse" then -- and functionBank.ClearBetweenPoints(char.Head.Position,mouse.Target.Position,AppendTables({char:GetDescendants(),{mouse.Target}})) then
if interactionType ==  "mouse"  then
--print("draggable and found mouse")
dragObject = mouse.Target
--if ping > 1 then
if mouse.Target:FindFirstChild("Draggable") then
functionBank.RestorePhysicality(dragObject)
rep.Events.ForceInteract:FireServer(dragObject)
elseif mouse.Target.Parent:FindFirstChild("Draggable") then
functionBank.RestorePhysicality(dragObject)
rep.Events.ForceInteract:FireServer(dragObject.Parent)
end
--end
rep.LocalSounds.Quicks.Click3:Play()
run:BindToRenderStep("Dragger",Enum.RenderPriority.Camera.Value-1,DragFunction)
return -- it's a drag event
end

end 
end

if mouse.Target and mouse.Target:FindFirstChild("DoorButton") and ObjectWithinStuds(mouse.Target,25) then
rep.Events.ToggleDoor:FireServer(mouse.Target.Parent)
return
end

if mouse.Target and mouse.Target:FindFirstChild("OpenGuiPanel") and ObjectWithinStuds(mouse.Target,25) then
functionBank.OpenGui(mainGui.Panels.Card.List[mouse.Target.OpenGuiPanel.Value])
return
end

if interactionType == "mouse" then
SwingTool() -- if we got this far then swing a heckin tool
end


elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
rmbHeld = true
end -- end of UserInputType
end)


uis.InputChanged:connect(function(input,gp)
if gp then return end
-- if mousewheel
if input.UserInputType == Enum.UserInputType.MouseWheel then
local pos = -input.Position.Z*6
zoomLevel = math.clamp(zoomLevel+pos,12,80)

elseif input.UserInputType == Enum.UserInputType.MouseMovement then
if rmbHeld then
camRot = camRot + input.Delta.X
end

end
end) -- end of input changed

uis.InputEnded:connect(function(input,gp)
--if gp then return end
if input.UserInputType == Enum.UserInputType.MouseButton1 then
activateHeld = false
--drawBack = 0
if dragObject then
dragObject.CanCollide = true
dragObject = nil
if draggerBodyPos then
draggerBodyPos:Destroy()
draggerBodyPos = nil
end 
mouse.TargetFilter = char
run:UnbindFromRenderStep("Dragger")
rep.Events.ForceInteract:FireServer()
end
-- end of mousebutton1
elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
rmbHeld = false

--elseif input.UserInputType  == Enum.UserInputType.Touch then
----if mouseBoundStructure then
----if (mouse.Hit.p-root.Position).magnitude <=50 and mouse.Target == workspace.Terrain then
----rep.Events.PlaceStructure:FireServer(mouseBoundStructure.Name,mouse.Hit.p,buildingRotation)
----if mouseBoundStructure.Name == "Raft" then
------raftTut = false
------functionBank.CreateNotification("Good luck, "..player.Name.."!",colorData.goodGreen,4)
----end
----end
----mouseBoundStructure:Destroy() 
----mouseBoundStructure = nil
----end
--
--activateHeld = false
----drawBack = 0
--if dragObject then
--dragObject.CanCollide = true
--dragObject = nil
--if draggerBodyPos then
--draggerBodyPos:Destroy()
--draggerBodyPos = nil
--end 
--mouse.TargetFilter = char
--run:UnbindFromRenderStep("Dragger")
--rep.Events.ForceInteract:FireServer()
--end


elseif input.KeyCode == Enum.KeyCode.LeftShift then
if mouseBoundStructure then
local hasKey = functionBank.HasItem(mouseBoundStructure.Name)
if (not hasKey) or hasShifted then
hasShifted = false
functionBank.ClearMouseBoundStructure()
functionBank.OpenGui(mainGui.Panels.Card.List.Bag)
end
end

end
end)


--[[
-- this is for rotating something in world coordinates despite its rotation

function rotate(cf, cfAngles)
	local cfWorld = CFrame.new(cf.p); -- default point cframe
	local offset = cfWorld:inverse() * cf; -- offset, equiv to cfWorld:toObjectSpace(cf)
	return (cfWorld * cfAngles) * offset; -- apply rotation, then offset
end;

part.CFrame = rotate(part.CFrame, CFrame.Angles(math.pi/4, 0, 0));
]]--

local lastTargetAcquired = 0
local duration = 2
rep.Events.TargetAcquire.OnClientEvent:connect(function(targetName,targetHealth,targetHealthProportion)
mainGui.Panels.Target.Visible = true
mainGui.Panels.Target.HealthBackdrop.Slider.Size = UDim2.new(targetHealthProportion,0,1,0)
mainGui.Panels.Target.HealthBackdrop.HealthLabel.Text = math.ceil(targetHealth)
if targetName == "GoGettaPie" then
mainGui.Panels.Target.HealthBackdrop.Title.Text = "🥧 Apple Pie"
else
if itemData[targetName] then
mainGui.Panels.Target.HealthBackdrop.Title.Text = itemData[targetName].alias or targetName
else
mainGui.Panels.Target.HealthBackdrop.Title.Text = targetName
end
end

if targetHealth == 0 then
lastTargetAcquired = rep.RelativeTime.Value-math.clamp(duration,1,math.huge)
else
lastTargetAcquired = rep.RelativeTime.Value
end

while wait() do
if rep.RelativeTime.Value-lastTargetAcquired >= duration then
mainGui.Panels.Target.Visible = false
return
end
end
end)


rep.Events.UpdateData.OnClientEvent:connect(function(newData,functions)
_G.data = newData
if functions then
for functionKey,functionData in next,functions do
if functionData[2] then
functionBank[functionData[1]](unpack(functionData[2]))
 -- first is the name of the function, second is the table of arguments received
else
local functionName = functionData[1]
--print("FUNCTION NAME IS",functionName,"FOR THE LOVE OF CHRIST")
functionBank[functionName]()
end
end
end
end)

rep.Events.Notify.OnClientEvent:connect(functionBank.CreateNotification)

local currentPrompts = {}
function rep.Events.PromptClient.OnClientInvoke(promptData)
if #currentPrompts >0 then
repeat wait() until #currentPrompts == 0
end
local uiClone
if promptData.promptType then
uiClone = mainGui.Subordinates.Prompts.Templates:FindFirstChild(promptData.promptType):Clone()
uiClone.Description.Text = promptData.message
uiClone.Parent = mainGui.Subordinates.Prompts
uiClone.Visible = true
--debris:AddItem(uiClone,14)
table.insert(currentPrompts,uiClone)
-- play a sound
else return
end

local datum = {}
local done

if promptData.promptType == "YesNo" then
--yes button
uiClone.YesButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
datum.result = "yes"
done = true
end
end)
--no button
uiClone.NoButton.InputBegan:connect(function(input,gp)
if functionBank.InteractInput(input,gp) then
datum.result = "no"
done = true
end
end)

elseif promptData.promptType == "TextInput" then
--[[
uiClone.TextBox.EventThatEnters:connect(function()
if rep.TextCheck:InvokeServer(uiClone.TextBox.Text) then
_G.data.result = uiClone.TextBox.Text
else
-- notify the player that their text was rejected
end
end)
]]--

end -- end of if promptDatta.promptType

local start = rep.RelativeTime.Value
repeat wait()
if (rep.RelativeTime.Value-start) >= 14 then datum = "no response" done = true end 
until done
uiClone:Destroy()
currentPrompts[1] = nil
currentPrompts = functionBank.CleanNils(currentPrompts)
return datum
end -- end of promptclient

--function rep.Events.HoldForSpawn.OnClientInvoke()
---- we need to wait for them to click the play button
--local done = false
--local connection = playerGui.SpawnGui.Customization.PlayButton.InputBegan:connect(function(input,gp)
--if functionBank.InteractInput(input,gp) then
--done = true
--end
--end)
--
--repeat wait() until done
--return
--end -- end of holdfor spawn

function rep.Events.AskForDeviceType.OnClientInvoke()
	--print("device type received")
if uis.MouseEnabled then
return "pc"
elseif  uis.TouchEnabled then
return "mobile"
elseif uis.GamepadEnabled then
return "gamepad" 
end
return "pc"
end 

local currentTrack = rep.LocalSounds.Nature.Nature
local ambienceEvent = nil
local tweeningSound = nil
local lastRemark = rep.RelativeTime.Value
local lastRemarkTrackName = ""

function CrossfadeTracks(playTrack,stopAll)
if stopAll then

else -- fade out the currently playing
tweeningSound = true
--cross fade over 5-10 seconds?
playTrack.Volume = 0
playTrack:Play()
local oldTweenInfo = TweenInfo.new(13,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut)
local oldGoal = {Volume = 0,}
local oldTween = tweenService:Create(currentTrack,oldTweenInfo,oldGoal)
oldTween:Play()
--print("the old track out")

local newTweenInfo = TweenInfo.new(6,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut)
local newGoal = {Volume = playTrack.MaxVolume.Value,}
local newTween = tweenService:Create(playTrack,oldTweenInfo,newGoal)
newTween:Play()

if playTrack.Name == "AncientDespair" then
	local newTweenInfo = TweenInfo.new(40, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
	local newGoal = {Size = 40}
	local newTween = tweenService:Create(game.Lighting.Bloom, oldTweenInfo, newGoal)
	newTween:Play()
else
	local newTweenInfo = TweenInfo.new(13, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
	local newGoal = {Size = 13}
	local newTween = tweenService:Create(game.Lighting.Bloom, oldTweenInfo, newGoal)
	newTween:Play()
end

--print("bringing the new track in")
wait(6)

if rep.RelativeTime.Value-lastRemark > 360 and lastRemarkTrackName ~= playTrack then
lastRemark = rep.RelativeTime.Value
lastRemarkTrackName = playTrack.Name

if playTrack.Name == "Wind" then
functionBank.MakeToast({
title = "YOU:",
message = "It's cold up here...",
color = colorData.brownUI,
image = "",
duration = 5,
})

elseif playTrack.Name == "Cave" then
functionBank.MakeToast({
title = "YOU:",
message = "Maybe there are resources down here...",
color = colorData.brownUI,
image = "",
duration = 6,
})

elseif playTrack.Name == "AncientDespair" then
functionBank.MakeToast({
title = "YOU:",
message = "This place is ancient...",
color = colorData.brownUI,
image = "",
duration = 6,
})
end
end

currentTrack:Stop()
currentTrack = playTrack
tweeningSound = nil
end
end -- end of crossfadeTracks


local previousEnvironment = "nature"
local DetectAmbience = coroutine.wrap(function()
while wait(1) and not ambienceEvent  and not tweeningSound do
local environment = "nature"
-- check to see if their environment has changed
local upRay = Ray.new(root.Position,Vector3.new(0,35,0))
local part,pos,norm,mat = workspace:FindPartOnRay(upRay,char)
if root.Position.Y <(-15) and part and part == workspace.Terrain and mat ~= Enum.Material.Air then
--print("they're in a cave it seems")
environment = "cave"
end
if root.Position.Y < -170 then
environment = "deep"
end
if root.Position.Y > 50 then
environment = "wind"
end


if environment ~= previousEnvironment then
--print("the environments are not the same")
local newTrack
if environment == "cave" then
newTrack = rep.LocalSounds.Nature.Cave
elseif environment == "nature" then
newTrack = rep.LocalSounds.Nature.Nature
elseif environment == "deep" then
newTrack = rep.LocalSounds.Nature.AncientDespair
elseif environment == "wind" then
newTrack = rep.LocalSounds.Nature.Wind
--elseif environment == "something else then
end
previousEnvironment = environment

--print("I want to crossfade out the old, and bring in the newtrack",newTrack.Name)
CrossfadeTracks(newTrack)


end

end
end) 
DetectAmbience()

rep.Events.Toast.OnClientEvent:connect(function(title,message,color,image)
functionBank.MakeToast(title,message,color,image)
end)

rep.Events.UpdateAllPlayerList.OnClientEvent:connect(functionBank.UpdatePlayerList)

--local checkSound = coroutine.wrap(function()
--local soundScript = script.Parent:WaitForChild("SoundCheckers")
--wait(1)
--soundScript.Changed:connect(function()
--player:Kick()
--end)
--end)
--checkSound()

workspace.Totems.ChildAdded:connect(function(child)
local tribeKey,tribeData =  functionBank.IsInTribe()
repeat wait() until child:FindFirstChild("TribeColor") and child.TribeColor.Value
if tribeData and tribeData.color == child.TribeColor.Value then
local newIndicator = rep.Guis.TribeLocator:Clone()
newIndicator.ImageLabel.ImageColor3 = colorData.TribeColors[tribeData.color]
newIndicator.Parent = playerGui
newIndicator.Adornee = child.Board
wait(1)
child.AncestryChanged:connect(function()
newIndicator:Destroy()
end)

end
end)

rep.Events.UpdateTradeData.OnClientEvent:connect(function(trades)
	functionBank.UpdateTrades(trades)
end)

local unloadedMovers= {}

--local takeALoadOff = coroutine.wrap(function()
--while wait(4) do
--local critters = workspace.Critters:GetChildren()
--local step = 0
--for _,critter in next,critters do
--step = step+1
--if itemData[critter.Name].itemType == "creature" and critter.PrimaryPart  then
--local distance = (player.Character.PrimaryPart.Position-critter.PrimaryPart.Position).magnitude
--if distance > 600 and not itemData[critter.Name].noUnload then
--unloadedMovers[#unloadedMovers+1] = critter
--critter.Parent = nil
--end
--end
--if step >=10 then
--step = 0
--wait()
--end
--end -- end of unload loop
--
--for key,critter in next,unloadedMovers do
--if critter and critter.PrimaryPart then
--local distance = (player.Character.PrimaryPart.Position-critter.PrimaryPart.Position).magnitude
--if distance < 600 then
--table.remove(unloadedMovers,key)
--critter.Parent = workspace.Critters
--wait(1/10)
--end
--end
--end
--end 
--
--end)
--if not game:GetService("RunService"):IsStudio() then
--takeALoadOff()
--end

rep.Events.PlaySoundAtPosition.OnClientEvent:connect(function(originalSound,pos)
--[[local part = Instance.new("Part")
part.Size = Vector3.new(0,0,0)
part.Anchored = true
part.CanCollide = false
part.CFrame = CFrame.new(pos)--]]
--[[local sound = originalSound:Clone()
sound.Parent = part
part.Parent = workspace
sound.PlayOnRemove = true
wait()
part:Destroy()--]]
end)

--while true do
--if root then
--wait()
--print(Vector3.new(root.Velocity.X,0,root.Velocity.Z).magnitude)
--end
--end

rep.Events.Weather.OnClientEvent:connect(function(weatherName,toggle)
-- removed for the winterupdate
--[[if weatherName == "Rain" then
-- do the rain sequence for everyone
functionBank.MakeItRain(toggle)

elseif weatherName == "Shine" then
functionBank.SunnyDays(toggle)

elseif weatherName == "Doom" then
functionBank.DoomWeather(toggle)

end--]]
if weatherName == "Snow" then
functionBank.MakeItSnow(toggle)
end
end)

rep.Events.UnbanNotify.OnClientEvent:connect(function(toggle)
mainGui.Panels.Unban.Visible = toggle
end)

rep.Events.ShowUpdateNotifier.OnClientEvent:connect(function()
--mainGui.Panels.UpdateNotifier.Visible = true
end)

--pie was here

rep.Events.ShowVoodooSelection.OnClientEvent:connect(function()
mainGui.Panels.VoodooSelect.Visible = true
end)



game.ReplicatedStorage.Events.ModError.OnClientEvent:Connect(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "Error";
	Text = "Attempted to give Blacklisted item";
	})
end)

--[[game.ReplicatedStorage.Events.DestroyEgg.OnClientEvent:Connect(function(eggName)
	print'omg event???????'
	print(eggName)
	for i,v in pairs(game.Workspace.Eggs:GetChildren()) do        
		if v.Name == eggName then
			print('yesss')
			v:Destroy()
		end
	end
end)



game.ReplicatedStorage.Events.GoldenEggDestroy.OnClientEvent:Connect(function(eggName)
	print'omg event???????'
	print(eggName)
	for i,v in pairs(game.Workspace.GoldenEgg:GetChildren()) do        
		if v.Name == eggName then
			print('yesss')
			v:Destroy()
		end
	end
end)]]

while true do
	wait(1)
	if workspace.Gravity == 0 then
		player:Kick("swim hax")
	end

	MainCounter = 0

end
