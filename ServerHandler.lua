local run = game:GetService("RunService")
local rep = game:GetService("ReplicatedStorage")
local ss = game:GetService("ServerStorage")
local debris = game:GetService("Debris")
local tweenService = game:GetService("TweenService")
local market = game:GetService("MarketplaceService")
local http = game:GetService("HttpService")
local ds = game:GetService("DataStoreService")
local PlayerData = ds:GetDataStore("BoogaData1")
local CommandData = ds:GetDataStore("CommandData")
local BFE = require(script.BFE)
local module = require(game:GetService("ServerStorage"):WaitForChild("DataModule"))

local MyFavoriteMoney = 5693982620

--function isAdmin(player)
--return _G.sessionData[player.UserId].admin
--end

--local Administrators = require(game.ServerScriptService["Anti-Exploit"].Admins)
--function Admin()
--game.Players.PlayerAdded:Connect(function(player)
--print(_G.sessionData[player.UserId].admin)
--print(_G.sessionData[player.UserId])
--if isAdmin() then
--print("123 Admin Check Adversity")
-- table.insert(Administrators, player.UserId)
--else
--print("not admin loser haha")
--end
--end)
--end


local MajorIndianChains = {
	522366376, -- Leo_961
	1100006389, -- lil_golu
	313847903, -- awara_0007
	343181022 -- headhunter_264
}

local Indians = {
	1309104692, -- HalfBloodPrince_010
	1308594697, -- constantine_7
	1309100078, -- y_ssoserious
	1309105383 -- KillMonger_001
}


-- local banData = ds:GetDataStore("BanData")
-- if run:IsStudio() then
-- ds = {}
-- PlayerData = {}
-- else


-- end
-- hey this is to publish\

-- Test two lol

print("Please publish")

print("Publishing V2")

local physics = game:GetService("PhysicsService")
physics:CreateCollisionGroup("Draggers")

physics:CreateCollisionGroup("Terrain")
physics:SetPartCollisionGroup(workspace.Terrain,"Terrain")

physics:CollisionGroupSetCollidable("Draggers","Terrain",true)
physics:CollisionGroupSetCollidable("Default","Terrain",true)

physics:CollisionGroupSetCollidable("Default","Draggers",false)

physics:CreateCollisionGroup("Players")
physics:CollisionGroupSetCollidable("Players", "Players", false)
physics:CollisionGroupSetCollidable("Players","Draggers",false)

local previousCollisionGroups = {}

local function setCollisionGroup(object)
	if object:IsA("BasePart") then
		previousCollisionGroups[object] = object.CollisionGroupId
		physics:SetPartCollisionGroup(object, "Players")
	end
end

local function setCollisionGroupRecursive(object)
	setCollisionGroup(object)
	for _, child in ipairs(object:GetChildren()) do
		setCollisionGroupRecursive(child)
	end
end

local function resetCollisionGroup(object)
	local previousCollisionGroupId = previousCollisionGroups[object]
	if not previousCollisionGroupId then return end	

	local previousCollisionGroupName = physics:GetCollisionGroupName(previousCollisionGroupId)
	if not previousCollisionGroupName then return end

	physics:SetPartCollisionGroup(object, previousCollisionGroupName)
	previousCollisionGroups[object] = nil
end

function lerp()
	return function(a, b, t)
		return a + (b - a) * t
	end
end

local defaultData = require(rep.Modules.DefaultData)
local itemData = require(rep.Modules.ItemData)
local colorData = require(rep.Modules.ColorData)
local levelData = require(rep.Modules.LevelData)
local cosmeticData  = require(rep.Modules.CosmeticData)
local patchNotes = require(rep.Modules.PatchNotes)
ds:GetDataStore("BanData")
local goldAccreditData = require(rep.Modules.GoldAccreditData)
--print("bandata required")

--print("bandata required")


local gameClosing = false

local salesData = {
	chests = {
		["153549063"] = "Pleb Chest",
		["153549248"] = "Good Chest",
		["153549363"] = "Great Chest",
		["153549511"] = "OMG Chest",
		["153549712"] = "Essence Chest",
	},

--[[coins = {
["1085135037"] = 400,
["1085135063"] = 1000,
["1085135075"] = 2000,
["1085135095"] = 6000,
["1085135126"] = 40000,
["1085135197"] = 100000,
["1085135234"] = 1000000,
["1085135248"] = 2000000,
}
}]]

--[[coins = {
["1085763499"] = 300,
["1085763526"] = 750,
["1085763570"] = 1500,
["1086545575"] = 4500,
["1085763600"] = 15000,
["1085763611"] = 75000,
["1085763634"] = 800000,
["1085763648"] = 1750000,
}
}]]

	-- OLD COIN 
	gems = {
		["1139640914"] = 200,
		["1139640945"] = 500,
		["1139640986"] = 1000,
		["1139641030"] = 3000,
		["1139641078"] = 10000,
		["1139641121"] = 50000,
		["1139641190"] = 500000,
		["1139641268"] = 1000000,
	},


	coins = {
		["1139639750"] = 200,
		["1139639829"] = 500,
		["1139639935"] = 1000,
		["1139640241"] = 3000,
		["1139640345"] = 10000,
		["1139640601"] = 50000,
		["1139640684"] = 500000,
		["1139640745"] = 1000000,
	}
}

local lastTotemTimers = {
	Yellow = 0,
	Green = 0,
	Red = 0,
	Violet = 0,
	Blue = 0,
	Grey = 0,
	Teal = 0,
	Black = 0,
	White = 0,
	Orange = 0,
	Pink = 0,
	Tan = 0,
	Brown = 0,
	Magenta = 0,
	Maroon = 0,
	Navy = 0,
}

local tradeSerializer = 1
_G.trades = {--DevVince was here. :P
	--{trader = playerName,
	--giveName = "Log",
	--giveQuantity = 5,
	--getCoins = 5, -- in coins
	--tradeId = 1,
	--},
}

local teleImmunity = {}
local tempImmunity = {}

function GetXDifference(p1,p2)
	return (Vector3.new(p1.x,0,p1.z)-Vector3.new(p2.x,0,p2.z)).magnitude
end

function TeleportPlayer(player,location)
	local teleportLocation = Instance.new("CFrameValue")
	teleportLocation.Value = location
	teleportLocation.Name = "TeleportCFrame"
	teleportLocation.Parent = player
	player.Character:SetPrimaryPartCFrame(location)
end

function IsDescendantOfPlayer(part)
	for _,player in next,game.Players:GetPlayers() do
		if player.Character then
			if part:IsDescendantOf(player.Character) then
				return true
			end
		end
	end
	return false
end

local function typeValid(data)
	return type(data) ~= 'userdata', typeof(data)
end

local function weldBetween(a, b)
	--Make a new Weld and Parent it to a.
	local weld = Instance.new("ManualWeld", a)
	weld.Part0 = a
	weld.Part1 = b
	--Get the CFrame of b relative to a.
	weld.C0 = a.CFrame:inverse() * b.CFrame
	--Return the reference to the weld so that you can change it later.
	return weld
end

local function scanValidity(tbl, passed, path)
	if type(tbl) ~= 'table' then
		return scanValidity({input = tbl}, {}, {})
	end
	passed, path = passed or {}, path or {'input'}
	passed[tbl] = true
	local tblType
	do
		local key, value = next(tbl)
		if type(key) == 'number' then
			tblType = 'Array'
		else
			tblType = 'Dictionary'
		end
	end
	local last = 0
	for key, value in next, tbl do
		path[#path + 1] = tostring(key)
		if type(key) == 'number' then
			if tblType == 'Dictionary' then
				return false, path, 'Mixed Array/Dictionary'
			elseif key%1 ~= 0 then  -- if not an integer
				return false, path, 'Non-integer index'
			elseif key == math.huge or key == -math.huge then
				return false, path, '(-)Infinity index'
			end
		elseif type(key) ~= 'string' then
			return false, path, 'Non-string key', typeof(key)
		elseif tblType == 'Array' then
			return false, path, 'Mixed Array/Dictionary'
		end
		if tblType == 'Array' then
			if last ~= key - 1 then
				return false, path, 'Array with non-sequential indexes'
			end
			last = key
		end
		local isTypeValid, valueType = typeValid(value)
		if not isTypeValid then
			return false, path, 'Invalid type', valueType
		end
		if type(value) == 'table' then
			if passed[value] then
				return false, path, 'Cyclic'
			end
			local isValid, keyPath, reason, extra = scanValidity(value, passed, path)
			if not isValid then
				return isValid, keyPath, reason, extra
			end
		end
		path[#path] = nil
	end
	passed[tbl] = nil
	return true
end

local function getStringPath(path)
	return table.concat(path, '.')
end

local function warnIfInvalid(input)
	local isValid, keyPath, reason, extra = scanValidity(input)
	if not isValid then
		if extra then
			warn('Invalid at '..getStringPath(keyPath)..' because: '..reason..' ('..tostring(extra)..')')
		else
			warn('Invalid at '..getStringPath(keyPath)..' because: '..reason)
		end
	else
	end
end


local cyclicTest = {
	a = {{b = {}}}
}

cyclicTest.a[1].b[1] = cyclicTest

local testCases = {
	true, 'hello', 5, 5.7,  -- all valid
	CFrame.new(),  -- invalid: type
	{
		true, 'hello', 5, 5.7
	},  -- valid array
	{
		a = true, b = 'hello', c = 5, d = 5.7
	},  -- valid dictionary
	{
		a = true, 'hello', 5, 5.7
	},  -- invalid: array/dictionary mix
	{
		CFrame.new()
	},  -- invalid: type in array
	{
		in1 = {
			{
				in2 = {
					a = true, 'hello'
				}
			},
			5
		},
		in3 = {}
	},  -- invalid: array/dictionary mix deep in path
	{
		[5.7] = 'hello'
	},  -- invalid: decimal index
	{
		[{}] = 'hello'
	},  -- invalid: non-string key
	{
		[1] = 'hello',
		[3] = 'WRONG',
	},  -- invalid: non-sequential array
	cyclicTest,  -- invalid: cyclic
	{
		[math.huge] = 'hello'
	},  -- invalid: infinity index
}

-- breathe life into the animals
for _,animal in next,workspace.Critters:GetChildren() do
	local soul = game.ServerStorage.AnimalCode:FindFirstChild(itemData[animal.Name].codeBase):Clone()
	for i,v in pairs(animal:GetDescendants()) do
		if v:IsA'BodyPosition' then
			v.Position = v.Parent.Position
			local yForce = (animal.Name == 'Lurky Boi' or animal.Name == 'Goldy Boi') and math.huge or 0
			v.MaxForce = Vector3.new(math.huge, yForce, math.huge)
			break
		end
	end
	soul.Parent = animal
	soul.Disabled = false
end

market.ProcessReceipt = function(receiptInfo)
	-- PlayerId
	-- PlaceIdWherePurchased
	-- PurchaseId
	-- ProductId
	-- CurrencySpent

	local player = game.Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then -- Seems like we can't find the player= already left?
		return Enum.ProductPurchaseDecision.NotProcessedYet -- Can't process
	end

	local purchaseType
	local purchaseName


	if salesData.chests[tostring(receiptInfo.ProductId)] then
		GiveItemToPlayer(salesData.chests[tostring(receiptInfo.ProductId)] ,player,3)

	elseif salesData.coins[tostring(receiptInfo.ProductId)] then -- if purchase type == something else
		_G.sessionData[player.UserId].coins = _G.sessionData[player.UserId].coins+salesData.coins[tostring(receiptInfo.ProductId)]
		_G.sessionData[player.UserId].totalRobuxSpent = _G.sessionData[player.UserId].totalRobuxSpent+receiptInfo.CurrencySpent
		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateStats"}})

	elseif salesData.gems[tostring(receiptInfo.ProductId)] then -- if purchase type == something else
		_G.sessionData[player.UserId].gems = _G.sessionData[player.UserId].gems+salesData.gems[tostring(receiptInfo.ProductId)]
		_G.sessionData[player.UserId].totalRobuxSpent = _G.sessionData[player.UserId].totalRobuxSpent+receiptInfo.CurrencySpent
		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateStats"}})

	elseif tostring(receiptInfo.ProductId) == 1082519935 then
		_G.sessionData[player.UserId].newBan = false
		-- unban
		rep.Events.UnbanNotify:FireClient(player,false)
		SpawnCharacter(player)


		--elseif tostring(receiptInfo.ProductId) == "12048953" then
		--print("they bought the advanced cosmetics")
		--_G.sessionData[player.UserId].advancedCosmetics = true
		--rep.Events.UnlockAdvancedCosmetics:FireClient(player)
	end -- end of purchaseType == "chest"

	spawn(function()
		SaveData(player.UserId,_G.sessionData[player.UserId])
	end)


	return Enum.ProductPurchaseDecision.PurchaseGranted	
end

rep.Events.BuyAdvancedCosmetics.OnServerEvent:connect(function(player)
	market:PromptGamePassPurchase(player,11217668) 
end)

rep.Events.BuyBoulderGamepass.OnServerEvent:connect(function(player)
	market:PromptGamePassPurchase(player,11217659)
end)

rep.Events.BlackIronCommando.OnServerEvent:connect(function(player)
	market:PromptGamePassPurchase(player,15952608)
end)

rep.Events.BlackIronHorns.OnServerEvent:connect(function(player)
	market:PromptGamePassPurchase(player,15952613)
end)

rep.Events.Overseer.OnServerEvent:connect(function(player)
	market:PromptGamePassPurchase(player,15952619)
end)

rep.Events.VoidStar.OnServerEvent:connect(function(player)
	market:PromptGamePassPurchase(player,15952625)
end)

rep.Events.FlyCap.OnServerEvent:connect(function(player)
	market:PromptGamePassPurchase(player,15952599)
end)

-- Purchased Items Note [1]

market.PromptGamePassPurchaseFinished:connect(function(player,purchaseId,purchased)
	if purchased then

		if purchaseId == 11217668 or purchaseId == 10965897 then
			print("they bought the advanced cosmetics")
			_G.sessionData[player.UserId].advancedCosmetics = true
			rep.Events.UnlockAdvancedCosmetics:FireClient(player)
		end -- end of purchaseType == "chest"

		if purchaseId == 11217659 or purchaseId == 10965968 then
			print("they bought the boulder")
			rep.Events.BuyBoulderGamepass:FireClient(player)
			if not HasToolAtAll(player,"Boulder") then
				_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
					name = "Boulder",
					lastSwing = 0
				}
			end
		end -- end of purchaseType == "chest"
		
		if purchaseId == 15952613 then
			print("bought iron horns")
			_G.sessionData[player.UserId].ownedCosmetics['Black Iron Horns'] = true
			rep.Events.Notify:FireClient(player, "Unlocked Horns")
			rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateCosmetics"},{"UpdateStats"}})
		end 

		if purchaseId == 15952608 then
			print("bought iron commando")
			_G.sessionData[player.UserId].ownedCosmetics['Black Iron Commando'] = true
			rep.Events.Notify:FireClient(player, "Unlocked Commando")
			rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateCosmetics"},{"UpdateStats"}})
		end 

		if purchaseId == 15952599 then
			print("bought fly cap")
			_G.sessionData[player.UserId].ownedCosmetics['Fly Cap'] = true
			rep.Events.Notify:FireClient(player, "Unlocked Fly Cap")
			rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateCosmetics"},{"UpdateStats"}})
		end 

		if purchaseId == 15952625 then
			print("bought void star")
			_G.sessionData[player.UserId].ownedCosmetics['Void Star'] = true
			rep.Events.Notify:FireClient(player, "Unlocked Void Star")
			rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateCosmetics"},{"UpdateStats"}})
		end 

		if purchaseId == 15952619 then
			print("bought overseer")
			_G.sessionData[player.UserId].ownedCosmetics['Overseer'] = true
			rep.Events.Notify:FireClient(player, "Unlocked Overseer")
			rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateCosmetics"},{"UpdateStats"}})
		end

		if purchaseId == 13073491 then
			rep.Events.BuyStickPass:FireClient(player)
			if not HasToolAtAll(player,"The Meatmaker") then
				_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
					name = "The Meatmaker",
					lastSwing = 0
				}
			end
		end -- end of purchaseType == "chest"
		if purchaseId == 13073487 then
			rep.Events.BuyMoneyMakerPass:FireClient(player)
			if not HasToolAtAll(player,"The Moneymaker") then
				_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
					name = "The Moneymaker",
					lastSwing = 0
				}
			end


		end -- end of purchaseType == "chest"

		if purchaseId == 13073671 then
			rep.Events.BuyBinarySkin:FireClient(player)
			if not HasToolAtAll(player,"Binary Blade") then
				_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
					name = "Binary Blade",
					lastSwing = 0
				}
			end
		end -- end of purchaseType == "chest"

		if purchaseId == 13073663 then
			rep.Events.BuyRainbowPack:FireClient(player)
			if not HasToolAtAll(player,"Obsidian Helmet") then
				_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
					name = "Obsidian Helmet",
					quantity = 1
				}
			end
		end -- end of purchaseType == "chest"

		if purchaseId == 13073663 then
			rep.Events.BuyRainbowPack:FireClient(player)
			if not HasToolAtAll(player,"Obsidian Chestplate") then
				_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
					name = "Obsidian Chestplate",
					quantity = 1

				}
			end
		end -- end of purchaseType == "chest"		

		if purchaseId == 13073663 then
			rep.Events.BuyRainbowPack:FireClient(player)
			if not HasToolAtAll(player,"Obsidian Greaves") then
				_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
					name = "Obsidian Greaves",
					quantity = 1
				}
			end
		end -- end of purchaseType == "chest"	

		if purchaseId == 13073663 then
			rep.Events.BuyRainbowPack:FireClient(player)
			if not HasToolAtAll(player,"Obsidian Rock") then
				_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
					name = "Obsidian Rock",
					lastSwing = 0
				}
			end
		end -- end of purchaseType == "chest"	

		if purchaseId == 13073663 then
			rep.Events.BuyRainbowPack:FireClient(player)
			if not HasToolAtAll(player,"Obsidian Bag") then
				_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
					name = "Obsidian Bag",
					quantity = 1
				}
			end
		end -- end of purchaseType == "chest"	
		if purchaseId == 13073642 then
			rep.Events.BuyShellyBag:FireClient(player)
			if not HasToolAtAll(player,"Shelly Bag") then
				_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
					name = "Shelly Bag",
					quantity = 1
				}
			end
		end -- end of purchaseType == "chest"	

	end -- end of if purchased
end)


--CommandData:OnUpdate(function(key,callback)
--local data = CommandData:GetAsync(key)
--if data == "shutdown" then
--rep.Events.Notify:FireAllClients("ATTENTION, NEW UPDATE!",colorData.ironGrey,7)
--wait(7)
--rep.Events.Notify:FireAllClients("SERVER SHUTDOWN IN: 5 minutes",colorData.badRed,7)
--wait(7)
--rep.Events.Notify:FireAllClients("COLLECT YOUR VALUABLES",colorData.ironGrey,7)
--wait(7)
--rep.Events.Notify:FireAllClients("THANKS FOR TESTING :)",colorData.ironGrey,7)
--wait(60*4)
--rep.Events.Notify:FireAllClients("SHUTDOWN IN 60 SECONDS",colorData.ironGrey,7)
--wait(30)
--rep.Events.Notify:FireAllClients("SHUTDOWN IN 30 SECONDS",colorData.ironGrey,7)
--wait(20)
--rep.Events.Notify:FireAllClients("SHUTDOWN IN 10 SECONDS",colorData.ironGrey,7)
--wait(10)
--for _,v in next,game.Players:GetPlayers() do
--v:Kick("This server has been shutdown for an UPDATE! Thanks for testing :)")
--end 
--end
--end)


local spawnLocations = {}
for _,v in next,workspace.SpawnParts:GetChildren() do
	table.insert(spawnLocations,CFrame.new(v.CFrame.p))
	v.CFrame = v.CFrame*CFrame.new(0,-10,0)
	v:Destroy()
end

local meteorLocations = {}
for _,v in next,workspace.MeteorParts:GetChildren() do
	table.insert(meteorLocations,CFrame.new(v.CFrame.p+Vector3.new(0,-2.4,0)))
	--v.CFrame = v.CFrame*CFrame.new(0,-10,0)
	v:Destroy()
end

local antMoundLocations = {}
for _,v in next,workspace.AnthillParts:GetChildren() do
	table.insert(antMoundLocations,CFrame.new(v.CFrame.p+Vector3.new(0,-2.4,0)))
	--v.CFrame = v.CFrame*CFrame.new(0,-10,0)
	v:Destroy()
end

local shipwreckLocations = {}
for _,v in next,workspace.ShipwreckParts:GetChildren() do
	table.insert(shipwreckLocations,v.CFrame)
	--v.CFrame = v.CFrame*CFrame.new(0,-10,0)
	v:Destroy()
end


_G.sessionData = {}
_G.worldStructures = {}

currentWeather = "Snow"
-- winterupdate
local weatherTypes = {
--[["Shine","Shine","Shine","Shine","Shine","Shine","Shine","Shine",
"Rain","Rain",
"Doom",--]]
	"Snow","Snow",
}


--tribeFunctions = {
--	ContainsPlayer = function(player)
--		if self[player] then
--			return true
--		end
--	end
--}
--
--
--
--tribea = {
--color = BrickColor.new("Bright red")
--}
--
--
--
--if tribea:ContainsPlayer(player) then
--
--
--tribe:ContainsPlayer(player)

tribes = {

	--{
	--color = "Yellow",
	--chief = nil,
	--members = {},
	--message = "",
	--diplomacy = {},
	--way = {},
	--},
}


utilityWhiteList = {}


--┏┓︱┏┓ ┏━━━┓ ┏━━━┓ ┏━━━┓       ┏━━━┓ ┏━━━┓ ┏━━━━┓ ┏━━━┓
--┃┃︱┃┃ ┃┏━┓┃ ┃┏━━┛ ┃┏━┓┃       ┗┓┏┓┃ ┃┏━┓┃ ┃┏┓┏┓┃ ┃┏━┓┃
--┃┃︱┃┃ ┃┗━━┓ ┃┗━━┓ ┃┗━┛┃       ︱┃┃┃┃ ┃┃︱┃┃ ┗┛┃┃┗┛ ┃┃︱┃┃
--┃┃︱┃┃ ┗━━┓┃ ┃┏━━┛ ┃┏┓┏┛       ︱┃┃┃┃ ┃┗━┛┃ ︱︱┃┃︱︱ ┃┗━┛┃
--┃┗━┛┃ ┃┗━┛┃ ┃┗━━┓ ┃┃┃┗┓       ┏┛┗┛┃ ┃┏━┓┃ ︱︱┃┃︱︱ ┃┏━┓┃
--┗━━━┛ ┗━━━┛ ┗━━━┛ ┗┛┗━┛       ┗━━━┛ ┗┛︱┗┛ ︱︱┗┛︱︱ ┗┛︱┗┛

--DevVince was here. :P
local InGame = ds:GetDataStore'InGame'
local LoadedDatabaseData = ds:GetDataStore'LoadedDBData'

function SD(p)
    if not game:GetService'RunService':IsStudio() then
        InGame:SetAsync(p.UserId, 0)
        --print(p.Name..' InGame set, false.') debugger
    end
end

function LoadData(userId) -- their user id
	local IsInGame, p = InGame:GetAsync(userId), game.Players:GetPlayerByUserId(userId)
	
	if p and not game:GetService'RunService':IsStudio() then
        if IsInGame and IsInGame == 1 then
            p:Kick'Logged-in on another server, please re-join.'
        elseif IsInGame and IsInGame == 0 then
            InGame:SetAsync(userId, 1)
		end
	end
	
	local attempts, data, success, err = 0
	
	repeat success, err = pcall(function()
			data = PlayerData:GetAsync(userId,err)
	end)
	attempts = attempts + 1
	if not success then 
		wait(1)
	end
	until success or attempts >= 5
	
	if success then
		if data then
			if data.CanSave then
				data.CanSave = true
			else
				data['CanSave'] = true
			end
		end
		return data and data or defaultData.ReturnBlankData()
	end
	
	if p then
		warn(p.Name, 'Failed to fletch data for ', p.Name, 'kicking user.')
		p:Kick'Data failed to load, please re-join.'
	end
end

function SaveData(userId, dataToSave)
	local p, attempts, success, err = game.Players:GetPlayerByUserId(userId), 0
	
	if p then
		CleanInventory(p)
	end
	
	repeat success, err = pcall(function()
		dataToSave.CanSave = false
		PlayerData:SetAsync(userId, dataToSave)
	end)
	attempts = attempts + 1
	if not success then 
		wait(1)
	end
	until success or attempts >= 5
	
	if success then
		--print ("saved")
		module.Save(userId, dataToSave)
		warnIfInvalid(dataToSave)
	else
		warnIfInvalid(dataToSave)
		warn('Data failed to save for:', userId, ' ~ Error:', err)
	end
end

game.Players.PlayerRemoving:connect(function(p)
    if gameClosing then return end
    SD(p)
end)
	
-- autosave coroutine
local autosave = coroutine.wrap(function()
	while wait(240) do
		for _,v in next,game.Players:GetPlayers() do
			local data = _G.sessionData[v.UserId]
			if data and data.CanSave then
				module.Save(v.UserId, _G.sessionData[v.UserId])
				SaveData(v.UserId, _G.sessionData[v.UserId])
			end
		end
	end
end)
autosave()


if not game:GetService'RunService':IsStudio() then
	game:BindToClose(function()
		gameClosing = true
		wait(1)
		for id,data in next,_G.sessionData do
			data.lastAttacker =  nil
			data.lastCombat  = 0 
			SaveData(id, data)
			_G.sessionData[id] = nil
		end
		
		for _,p in pairs(game.Players:GetPlayers()) do
	        SD(p)
	    end
	end)
end

--┏━━━┓ ┏━┓︱┏┓ ┏━━━┓       ┏┓︱┏┓ ┏━━━┓ ┏━━━┓ ┏━━━┓       ┏━━━┓ ┏━━━┓ ┏━━━━┓ ┏━━━┓
--┃┏━━┛ ┃┃┗┓┃┃ ┗┓┏┓┃       ┃┃︱┃┃ ┃┏━┓┃ ┃┏━━┛ ┃┏━┓┃       ┗┓┏┓┃ ┃┏━┓┃ ┃┏┓┏┓┃ ┃┏━┓┃
--┃┗━━┓ ┃┏┓┗┛┃ ︱┃┃┃┃       ┃┃︱┃┃ ┃┗━━┓ ┃┗━━┓ ┃┗━┛┃       ︱┃┃┃┃ ┃┃︱┃┃ ┗┛┃┃┗┛ ┃┃︱┃┃
--┃┏━━┛ ┃┃┗┓┃┃ ︱┃┃┃┃       ┃┃︱┃┃ ┗━━┓┃ ┃┏━━┛ ┃┏┓┏┛       ︱┃┃┃┃ ┃┗━┛┃ ︱︱┃┃︱︱ ┃┗━┛┃
--┃┗━━┓ ┃┃︱┃┃┃ ┏┛┗┛┃       ┃┗━┛┃ ┃┗━┛┃ ┃┗━━┓ ┃┃┃┗┓       ┏┛┗┛┃ ┃┏━┓┃ ︱︱┃┃︱︱ ┃┏━┓┃
--┗━━━┛ ┗┛︱┗━┛ ┗━━━┛       ┗━━━┛ ┗━━━┛ ┗━━━┛ ┗┛┗━┛       ┗━━━┛ ┗┛︱┗┛ ︱︱┗┛︱︱ ┗┛︱┗┛


function GetDictionaryLength(tab)
	local count = 0
	for _,v in next,tab do
		count = count+1 
	end
	return count
end

function Chance(num)
	-- out of 100
	return math.random(0,100)<=num
end

function HasMojoRecipe(player,itemName)
	return _G.sessionData[player.UserId].mojoItems[itemName]
end

function HascustomRecipe(player,itemName)
	return _G.sessionData[player.UserId].customRecipes[itemName]
end

function isAdmin(player)
	return _G.sessionData[player.UserId].admin
end



function CalculateToolDamageToPlayers(toolName,player)
	-- name of the tool,  and the  player receiving damage
	local  totalDamage = 0
	local rawToolDamage =  itemData[toolName].damages.lifeforms
	local  totalProtection = 0-- out  of 100
	for keyLocus,armorName in next,_G.sessionData[player.UserId].armor do
		if armorName and armorName ~= "none" then
			if itemData[armorName] and itemData[armorName].protection then
				totalProtection = totalProtection+itemData[armorName].protection
			end 
		end
	end
	local armorMultiplier = 1-(totalProtection/100)
	--local totalPierce = itemData[toolName].armorPierce or 1
	--armorMultiplier = armorMultiplier*totalPierce

	--totalArmorResist  = math.clamp(totalArmorResist,0,9/10) -- 90% resistance  possible always
	totalDamage = rawToolDamage*armorMultiplier
	return totalDamage
end

function CalculateArmor(player)
	local armorRating = 0
	for keyLocus,armorName in next,_G.sessionData[player.UserId].armor do
		if armorName and armorName ~= "none" then
			if itemData[armorName] and itemData[armorName].protection then
				armorRating = math.clamp(armorRating+itemData[armorName].protection,0,90)
			end 
		end
	end
	return armorRating
end

function GiveItemToPlayer(itemName,player,amount)
	local hasKey = HasItem(player,itemName)
	if hasKey then
		_G.sessionData[player.UserId].inventory[hasKey].quantity = _G.sessionData[player.UserId].inventory[hasKey].quantity +(amount or 1)
	else
		_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {name = itemName,quantity = (amount or 1)}
	end -- end of if hasKey
	rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"DrawInventory"},{"UpdateStats"}})
end -- giveitemtoplayer


function ForceUnequip(player)
	for _,v in next,player.Character:GetChildren() do
		if itemData[v.Name] and itemData[v.Name].itemType == "tool" then
			v:Destroy()
			_G.sessionData[player.UserId].equipped = nil
			--rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"SortToolbar"}})
		end
	end
end

function GiveCoin(player,amount)
	if game:GetService("MarketplaceService"):PlayerOwnsAsset(player,MyFavoriteMoney) or player.Name == "xaybler" or player.Name == "JaguarZZXX123" then
		_G.sessionData[player.UserId].coins = _G.sessionData[player.UserId].coins+amount*2
	else
		_G.sessionData[player.UserId].coins = _G.sessionData[player.UserId].coins+amount
	end
	rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateStats"}})
end

function GiveGem(player,amount)
	_G.sessionData[player.UserId].gems = _G.sessionData[player.UserId].gems+amount
	rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateStats"}})
end

function Ghost(player)
	_G.sessionData[player.UserId].GhostEvent = _G.sessionData[player.UserId].GhostEvent+1
	rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateStats"}})
end

function NeonShellies(player)
	_G.sessionData[player.UserId].NeonShelly = _G.sessionData[player.UserId].NeonShelly+1
	rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateStats"}})
end

function Cupids(player)
	_G.sessionData[player.UserId].CupidEvent = _G.sessionData[player.UserId].CupidEvent+1
	rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateStats"}})
end

function GiveEssence(player,amount)
	_G.sessionData[player.UserId].essence = _G.sessionData[player.UserId].essence+amount
	--print("level is",_G.sessionData[player.UserId].level)
	--print("essence is",_G.sessionData[player.UserId].essence)
	if _G.sessionData[player.UserId].essence >= (levelData[_G.sessionData[player.UserId].level] or math.huge) then
		-- we gotta level them up!
		-- if there is a level above what they are
		local leftover = _G.sessionData[player.UserId].essence-levelData[_G.sessionData[player.UserId].level]
		_G.sessionData[player.UserId].essence = leftover
		_G.sessionData[player.UserId].level = _G.sessionData[player.UserId].level+1
		--DevVince was here, disabled saving while leveling up, pretty sure it's causing data loss every now and then. (Also pointless with autosaving.)
		--spawn(function()
		--SaveData(player.UserId,_G.sessionData[player.UserId])
		--end)
		-- tell them they leveled up level up
		rep.Events.Notify:FireClient(player,"You leveled up!",colorData.essenceYellow,5)
		GiveItemToPlayer("Pleb Chest",player)
		UpdatePlayerList()

		local newItemList = {}
		for itemName,itemInfo in next,itemData do
			if itemInfo.craftLevel and itemInfo.craftLevel == _G.sessionData[player.UserId].level then --and not _G.sessionData[player.UserId].ownedRecipes[itemName] then
				--_G.sessionData[player.UserId].ownedRecipes[itemName] = true
				newItemList[#newItemList+1] = itemName
			end
		end
		if #newItemList >0 then
			-- tell them they unlocked new items
			--local messagio = "YOU LEARNED: "
			local messagio = ""
			for i,v in next,newItemList do
				if i ~=#newItemList then
					messagio = messagio..v..", "
				else
					messagio = messagio..v 
				end
			end

			rep.Events.Toast:FireClient(player,
				{title = "NEW RECIPES!",message = messagio,color = colorData.essenceYellow,image = "rbxassetid://1390834073",duration = 8})
			rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateStats"},{"DrawCraftMenu"}})
		end
	end
	rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateStats"}})

end


function AppendTables(tables)
	local mainTable = {}
	for tabKey,tabData in next,tables do
		for key,val in next,tabData do
			mainTable[#mainTable+1] = val
		end
	end
	return mainTable
end

function CheckIfLockedCosmetic(player,cosmeticName) 
	local found = cosmeticData.hair[cosmeticName] or cosmeticData.skin[cosmeticName] or cosmeticData.face[cosmeticName]
	if found.locked and _G.sessionData[player.UserId].advancedCosmetics then
		return true
	else
		return false
	end
end

function SetupAppearance(player)
	if not player.Character then return end
	local char = player.Character

	-- set up their core appearance

	for limbName,val in next,skinColorList do
		char:FindFirstChild(limbName).Color = cosmeticData.skin[_G.sessionData[player.UserId].appearance.skin].color
	end

	local tribeKey,tribeData = IsInATribe(player)
	if tribeData then
		ChangeBodyColor(player,colorData.TribeColors[tribeData.color])
	end
	-- face
	char.Head.Face.Texture = cosmeticData.face[_G.sessionData[player.UserId].appearance.face].image
	-- torso
	--char.UpperTorso.MeshId = cosmeticData.bodyTypes[_G.sessionData[player.UserId].gender]
	-- hair


	---- clear old armor
	--for itemName,itemInfo in next,itemData do
	--if itemInfo.itemType == "armor" then
	--for _,pieceName in next,itemInfo.pieces do
	--if player.Character:FindFirstChild(pieceName) then
	--player.Character:FindFirstChild(pieceName):Destroy()
	--end
	--end
	--end
	--end

	-- clear all accoutrements
	for _,v in next,player.Character:GetChildren() do
		if v:IsA("Accoutrement") then
			v:Destroy()
		end
	end

	local newHair
	local newHelmetName
	local newHat

	-- add the hair
	if _G.sessionData[player.UserId].appearance.hair and 
		_G.sessionData[player.UserId].appearance.hair ~= "none" and 
		_G.sessionData[player.UserId].appearance.hair ~= "Bald"
	then
		newHair = ss.Cosmetics.Hair:FindFirstChild(_G.sessionData[player.UserId].appearance.hair):Clone()
		newHair.Parent = player.Character
	end


	-- set up armor and masks
	for keyLocus,armorName in next,_G.sessionData[player.UserId].armor do
		if armorName and armorName ~= "none" then
			if keyLocus == "head" then
				newHelmetName = armorName
			end
			local itemInfo = itemData[armorName]
			if itemInfo then
				for _,pieceName in next,itemInfo.pieces do
					local found = ss.Armor:FindFirstChild(pieceName)
					if not player.Character:FindFirstChild(pieceName) then
						found:Clone().Parent = player.Character
					end
				end
			end

		end
	end

	if _G.sessionData[player.UserId].appearance.hat and _G.sessionData[player.UserId].appearance.hat ~= "none" then
		newHat = ss.Cosmetics.hat:FindFirstChild(_G.sessionData[player.UserId].appearance.hat):Clone()
		newHat.Parent = player.Character
	end

	if ((newHelmetName or newHat) and newHair) and (newHelmetName ~= "God Halo") and (newHelmetName ~= "The P Halo") and (newHelmetName ~= "Evil Halo") and (newHelmetName ~= "Overgrown Halo") and (newHelmetName ~= "HK Halo") and (newHelmetName ~= "Night Halo") and (newHelmetName ~= "OG Halo") then
		newHair:Destroy()
	end
	if newHat and newHelmetName then
		player.Character:FindFirstChild(newHelmetName):Destroy()
	end

	rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateCosmetics"}})
end -- end of setup player


local playerListInfo = {}

function UpdatePlayerList()
	local newList = {}
	for _,v in next,game.Players:GetPlayers() do
		if _G.sessionData[v.UserId] then
			local tribeKey,tribeData = IsInATribe(v)
			local tagColor

			if tribeData then
				tagColor = colorData.TribeColors[tribeData.color]
			else
				tagColor = colorData.brownUI
			end

			newList[#newList+1] = {playerName = v.Name, playerLevel = _G.sessionData[v.UserId].level, playerColor = tagColor}
		end
	end
	playerListInfo = newList
	rep.Events.UpdateAllPlayerList:FireAllClients(newList,tribes)
end

function SpawnCharacter(player)
	_G.sessionData[player.UserId].lastSpawn = rep.RelativeTime.Value
	player:LoadCharacter()
	repeat if not (player.Character and (player.Character.Parent == workspace)) then wait() else break end until nil

	if _G.sessionData[player.UserId].newBan then 
		wait(1)
		player.Character:Destroy()
		rep.Events.UnbanNotify:FireClient(player,true)
		return 
	end

	local char = player.Character

	SetupAppearance(player)

	if _G.sessionData[player.UserId].mojoItems["Shelly Friend"] and not _G.sessionData[player.UserId].disabledMojo["Shelly Friend"] then
		local newPet = ss.Pets:FindFirstChild("Shelly Friend"):Clone()
		newPet:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame)
		newPet.Parent = char
		newPet.PetMover.Disabled = false
	end

	if _G.sessionData[player.UserId].mojoItems["Lurky Bro"] and not _G.sessionData[player.UserId].disabledMojo["Lurky Bro"]then
		local newPet = ss.Pets:FindFirstChild("Lurky Bro"):Clone()
		newPet:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame)
		newPet.Parent = char
		newPet.PetMover.Disabled = false
	end

	if _G.sessionData[player.UserId].mojoItems["Unicorn Buddy"] and not _G.sessionData[player.UserId].disabledMojo["Unicorn Buddy"]then
		local newPet = ss.Pets:FindFirstChild("Unicorn Buddy"):Clone()
		newPet:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame)
		newPet.Parent = char
		newPet.PetMover.Disabled = false
	end

	if _G.sessionData[player.UserId].mojoItems["Rabbit Friend"] and not _G.sessionData[player.UserId].disabledMojo["Rabbit Friend"]then
		local newPet = ss.Pets:FindFirstChild("Rabbit Friend"):Clone()
		newPet:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame)
		newPet.Parent = char
		newPet.PetMover.Disabled = false
	end	

	if _G.sessionData[player.UserId].mojoItems["Peeper Pet"] and not _G.sessionData[player.UserId].disabledMojo["Peeper Pet"]then
		local newPet = ss.Pets:FindFirstChild("Peeper Pet"):Clone()
		newPet:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame)
		newPet.Parent = player.Character
		newPet.PetMover.Disabled = false
	end

	if _G.sessionData[player.UserId].mojoItems["Sparkles"] and not _G.sessionData[player.UserId].disabledMojo["Sparkles"]then
		local sparkle = rep.Particles.GodSparkle:Clone()
		sparkle.Parent = char.PrimaryPart
	end

	-- make sure they at least have a rock
	local hasRock = HasToolAtAll(player,"Rock")
	if not hasRock then
		_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
			name = "Rock",
		}
	end
	local hasBoulder = HasToolAtAll(player,"Boulder")
	if not hasBoulder and _G.sessionData[player.UserId].boulderGamepass then
		_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
			name = "Boulder",
			lastSwing = 0
		}
	end

	local hasBlackIronCommando = _G.sessionData[player.UserId].ownedCosmetics['Black Iron Commando']
	if not hasBlackIronCommando and _G.sessionData[player.UserId].blackIronCommando then
		_G.sessionData[player.UserId].ownedCosmetics['Black Iron Commando'] = true
		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateCosmetics"},{"UpdateStats"}})
	end

	local hasBlackIronHorns = _G.sessionData[player.UserId].ownedCosmetics['Black Iron Horns']
	if not hasBlackIronHorns and _G.sessionData[player.UserId].blackIronHorns then
		_G.sessionData[player.UserId].ownedCosmetics['Black Iron Horns'] = true
		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateCosmetics"},{"UpdateStats"}})
	end

	local hasVoidStar = _G.sessionData[player.UserId].ownedCosmetics['Void Star']
	if not hasVoidStar and _G.sessionData[player.UserId].Voidstar then
		_G.sessionData[player.UserId].ownedCosmetics['Void Star'] = true
		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateCosmetics"},{"UpdateStats"}})
	end

	local hasOverseer = _G.sessionData[player.UserId].ownedCosmetics['Overseer']
	if not hasOverseer and _G.sessionData[player.UserId].Overseer then
		_G.sessionData[player.UserId].ownedCosmetics['Overseer'] = true
		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateCosmetics"},{"UpdateStats"}})
	end

	local hasFlyCap = _G.sessionData[player.UserId].ownedCosmetics['Fly Cap']
	if not hasFlyCap and _G.sessionData[player.UserId].Flycap then
		_G.sessionData[player.UserId].ownedCosmetics['Fly Cap'] = true
		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateCosmetics"},{"UpdateStats"}})
	end

	local hasGamePassWeapon4 = HasToolAtAll(player,"Obsidian Rock")
	if not hasGamePassWeapon4 and _G.sessionData[player.UserId].GameWeaponPass4 then
		_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
			name = "Obsidian Rock",
			lastSwing = 0
		}
	end	

	local hasGamePassWeapon4 = HasToolAtAll(player,"Obsidian Bag")
	if not hasGamePassWeapon4 and _G.sessionData[player.UserId].GameWeaponPass4 then
		_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
			name = "Obsidian Bag",
			quantity = 1
		}
	end	

	local hasGamePassWeapon4 = HasToolAtAll(player,"Obsidian Helmet")
	if not hasGamePassWeapon4 and _G.sessionData[player.UserId].GameWeaponPass4 then
		_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
			name = "Obsidian Helmet",
			quantity = 1
		}
	end

	local hasGamePassWeapon4 = HasToolAtAll(player,"Obsidian Chestplate")
	if not hasGamePassWeapon4 and _G.sessionData[player.UserId].GameWeaponPass4 then
		_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
			name = "Obsidian Chestplate",
			quantity = 1
		}
	end
	local hasGamePassWeapon4 = HasToolAtAll(player,"Obsidian Greaves")
	if not hasGamePassWeapon4 and _G.sessionData[player.UserId].GameWeaponPass4 then
		_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
			name = "Obsidian Greaves",
			quantity = 1
		}
	end
	local hasGamePassWeapon5 = HasToolAtAll(player,"The Moneymaker")
	if not hasGamePassWeapon5 and _G.sessionData[player.UserId].GameWeaponPass5 then
		_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
			name = "The Moneymaker",
			lastSwing = 0
		}
	end
	local hasGamePassWeapon6 = HasToolAtAll(player,"The Meatmaker")
	if not hasGamePassWeapon6 and _G.sessionData[player.UserId].GameWeaponPass6 then
		_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
			name = "The Meatmaker",
			lastSwing = 0
		}
	end
	local hasGamePassWeapon7 = HasToolAtAll(player,"Binary Blade")
	if not hasGamePassWeapon7 and _G.sessionData[player.UserId].GameWeaponPass7 then
		_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
			name = "Binary Blade",
			lastSwing = 0
		}
	end
	local hasGamePassWeapon8 = HasToolAtAll(player,"Shelly Bag")
	if not hasGamePassWeapon8 and _G.sessionData[player.UserId].GameWeaponPass8 then
		_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
			name = "Shelly Bag",
			quantity = 1
		}
	end

	rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"DrawInventory"},{"UpdateArmor"},{"SortToolbar"}})
end-- end of spawncharacter

function AddValueObject(target,valName,valType,val)
	local newVal = Instance.new(valType,target)
	newVal.Value = val
	newVal.Name = valName
end

function CreateParticles(instance,origin,facing,count,duration,particleProperties)

	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
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

end -- end of createparticles

function WithinDistance(object1,object2,range)
	local pos1,pos2

	if object1:IsA("BasePart") then
		pos1 = object1.Position
	elseif object1:IsA("Model") then
		pos1 = object1.PrimaryPart.Position
	end

	if object2:IsA("BasePart") then
		pos2 = object2.Position
	elseif object2:IsA("Model") then
		pos2 = object2.PrimaryPart.Position
	end

	local dist = (pos1-pos2).magnitude
	if dist <= range then
		return true
	else
		return false
	end
end


function CanBearLoad(player,itemName)
	local playerLoad = 0

	local maxLoad
	if _G.sessionData[player.UserId].armor.bag and _G.sessionData[player.UserId].armor.bag ~= "none" then
		maxLoad = itemData[_G.sessionData[player.UserId].armor.bag].maxLoad
	else
		maxLoad = 50
	end

	for _,v in next,_G.sessionData[player.UserId].inventory do
		if v.quantity and itemData[v.name] and itemData[v.name].load then
			playerLoad = playerLoad+(v.quantity*itemData[v.name].load)
		end
	end

	local anticipatedLoad = itemData[itemName].load or 0
	if (playerLoad+anticipatedLoad)<=maxLoad or anticipatedLoad == 0 then
		return true
	else
		return false
	end
end

function CanCraftItem(player,itemName)
	local itemInfo = itemData[itemName]
	--DevVince was here, fixed some stuff. :)

	if itemInfo.mojoRecipe then
		local function notify()
			rep.Events.Notify:FireClient(player, 'You can only have one '..itemName..'.', Color3.fromRGB(222, 147, 223),4)
		end

		if not HasMojoRecipe(player, itemName) then
			player:Kick'Mojo Exploit.'--Exploiting, might as well kick them. :P
			return false
		end



			--[[if itemInfo.staffItem ~= nil then
			local main = _G.HDAdminMain
			local plrRank = main.pd[player].Rank
			if plrRank < 3 then 
				rep.Events.Notify:FireClient(player,"You cannot craft this item.")
				return false
			else if plrRank == 3 then
				rep.Events.Notify:FireClient(player,"You cannot craft this item.")
				return false
			end
			end
		end--]]

		--Check inventory
		if HasItem(player,itemName) then
			notify()
			return false
		end

		--Scan their equipped armor
		for _,v in next,_G.sessionData[player.UserId].armor do
			if v == itemName then
				notify()
				return false
			end
		end

		--Scan their toolbar
		for _,toolData in next,_G.sessionData[player.UserId].toolbar do
			if toolData.name == itemName then
				notify()
				return false
			end
		end

		--Check if they have all the items to craft it.
		if itemInfo.recipe then
			for ingredientName,ingredientQuantity in next,itemInfo.recipe do
				local hasKey = HasItem(player,ingredientName)
				if not (hasKey and _G.sessionData[player.UserId].inventory[hasKey].quantity >= ingredientQuantity) then
					rep.Events.Notify:FireClient(player, 'Not enough materials.', Color3.fromRGB(222, 147, 223),4)
					return false
				end
			end
		end

		return true
	end

	if itemInfo.customRecipe then
		local function notify()
			rep.Events.Notify:FireClient(player, 'You can only have one '..itemName..'.', Color3.fromRGB(222, 147, 223),4)
		end

		if not HascustomRecipe(player, itemName) then
			player:Kick'yo stop trying lol.'--Exploiting, might as well kick them. :P
			return false
		end



			--[[if itemInfo.staffItem ~= nil then
			local main = _G.HDAdminMain
			local plrRank = main.pd[player].Rank
			if plrRank < 3 then 
				rep.Events.Notify:FireClient(player,"You cannot craft this item.")
				return false
			else if plrRank == 3 then
				rep.Events.Notify:FireClient(player,"You cannot craft this item.")
				return false
			end
			end
		end--]]

		--Check inventory
		if HasItem(player,itemName) then
			notify()
			return false
		end

		--Scan their equipped armor
		for _,v in next,_G.sessionData[player.UserId].armor do
			if v == itemName then
				notify()
				return false
			end
		end

		--Scan their toolbar
		for _,toolData in next,_G.sessionData[player.UserId].toolbar do
			if toolData.name == itemName then
				notify()
				return false
			end
		end

		--Check if they have all the items to craft it.
		if itemInfo.recipe then
			for ingredientName,ingredientQuantity in next,itemInfo.recipe do
				local hasKey = HasItem(player,ingredientName)
				if not (hasKey and _G.sessionData[player.UserId].inventory[hasKey].quantity >= ingredientQuantity) then
					rep.Events.Notify:FireClient(player, 'Not enough materials.', Color3.fromRGB(222, 147, 223),4)
					return false
				end
			end
		end

		return true
	end

	--Not a mojo item.
	if _G.sessionData[player.UserId].level >= itemInfo.craftLevel then
		for ingredientName,ingredientQuantity in next,itemInfo.recipe do
			local hasKey = HasItem(player, ingredientName)
			if not (hasKey and _G.sessionData[player.UserId].inventory[hasKey].quantity >= ingredientQuantity) then
				return false
			end
		end
	else
		player:Kick'Invalid level.'
		return false
	end

	return true
end



function CleanInventory(player)
	local tab = _G.sessionData[player.UserId].inventory
	local newTab = {}
	for key,itemInfo in next,tab do
		if itemInfo.name and itemInfo.name ~= "none" and itemData[itemInfo.name] then
			if itemInfo.quantity then
				if itemInfo.quantity >0 then
					newTab[#newTab+1] = itemInfo
				end
			else
				newTab[#newTab+1] = itemInfo
			end
		else
			warn("this thing didn't have a name for some reason")
		end
	end -- end of loop
	_G.sessionData[player.UserId].inventory = newTab
	return
end

function HasToolInBar(player,toolName)
	for key,v in next,_G.sessionData[player.UserId].toolbar do
		if v.name == toolName then
			return true
		end
	end
	return false
end

function HasToolAtAll(player,toolName)
	for key,v in next,_G.sessionData[player.UserId].toolbar do
		if v.name == toolName then
			return true
		end
	end

	if HasItem(player,toolName) then
		return true
	end

end

function HasGemFromPack(player,names)
	for key,v in next,_G.sessionData[player.UserId].gems do
		if v.name == names then
			return key
		end
	end
	return false
end

function HasCoinFromPack(player,names)
	for key,v in next,_G.sessionData[player.UserId].coins do
		if v.name == names then
			return key
		end
	end
	return false
end

function HasItem(player,itemName)
	for key,v in next,_G.sessionData[player.UserId].inventory do
		if v.name == itemName then
			return key
		end
	end
	return false
end

function ClearTools(char)
	for _,v in next,char:GetChildren() do
		if itemData[v.Name] and itemData[v.Name].itemType == "tool" then
			v:Destroy()
		end
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

function PieceIsAnchored(thing)
	if thing:IsA("BasePart") then
		return thing.Anchored

	elseif thing:IsA("Model") then
		for _,v in next,thing:GetChildren() do
			if v:IsA("BasePart") and v.Anchored then
				return true
			end
		end
		return false
	end

end

local setToAnchor = {}
-- {when = rep.RelativeTime.Value, item = newItem, ownedBy = dropInfo.player, collectIn = dropInfo.gc or (math.random(40,60)/10)}
local anchorGcCoroutine = coroutine.wrap(function()
	while run.Heartbeat:wait() do
		for key,dropInfo in next,setToAnchor do                             -- V Below, Should anchor a lot faster preventing crash.
			if (rep.RelativeTime.Value - (dropInfo.when+(dropInfo.gc or .3))) >0 and not PieceIsAnchored(dropInfo.item) then -- the dropInfo.gc or x is the anchor rate
				local part,pos,norm,mat

				if dropInfo.item:IsA("BasePart") and dropInfo.item.CanCollide then
					part,pos,norm,mat = RayUntil(dropInfo.item.Position,Vector3.new(0,-1000,0),{dropInfo.item})
					dropInfo.item.Anchored = true
					dropInfo.item.CanCollide = false
					dropInfo.item.CFrame = dropInfo.item.CFrame*CFrame.new(0,-(dropInfo.item.CFrame.Y-pos.Y)+(dropInfo.item.Size.Y/2),0)

				elseif dropInfo.item:IsA("Model") and dropInfo.item.PrimaryPart.CanCollide then
					part,pos,norm,mat = RayUntil(dropInfo.item.PrimaryPart.Position,Vector3.new(0,-1000,0),{dropInfo.item:GetChildren()})
					for _,v in next,dropInfo.item:GetDescendants() do
						if v:IsA("BasePart") then
							v.Anchored = true
							v.CanCollide = false
						end
					end
					dropInfo.item:SetPrimaryPartCFrame(dropInfo.item.PrimaryPart.CFrame*CFrame.new(0,-(dropInfo.item.PrimaryPart.CFrame.Y-pos.Y)+(dropInfo.item.PrimaryPart.Size.Y/2),0))

				else
				end

				table.remove(setToAnchor,key)
				run.Heartbeat:wait()
			end

		end
	end
end)
anchorGcCoroutine()

-- coroutine to loop through set to anchor and turn them into little dummy bois
function DropItem(dropInfo)
	--print("DROP INFO  TRIGGERED")
	--for k,v in next,dropInfo do
	--print(k,v)
	--end

	--local player,itemName,cf,setOwner,variation = dropInfo["player"], dropInfo.itemName, dropInfo["cf"], dropInfo["setOwner"],dropInfo["variation"]
	--player, itemName,cf,setowner,variation,gc
	local newItem = ss.Items:FindFirstChild(dropInfo.itemName):Clone()
	local offsetCF = CFrame.new(0,0,0)

	if dropInfo.variation then
		offsetCF = CFrame.new(math.random(-50,50)/10,math.random(40,80)/10,math.random(-50,50)/10)
	end

	if newItem:IsA("BasePart")then
		newItem.CFrame = dropInfo.cf*offsetCF
	elseif newItem:IsA("Model") then
		newItem:SetPrimaryPartCFrame(dropInfo.cf*offsetCF)
	end

	debris:AddItem(newItem,(dropInfo.gc or 60)) -- how fast it despawns
	if dropInfo.autoAnchor then
		if newItem:IsA("BasePart") then
			newItem.Anchored = true
			newItem.CanCollide = false
		elseif dropInfo.item:IsA("Model") then
			for _,v in next,newItem:GetDescendants() do
				if v:IsA("BasePart") then
					v.Anchored = true
					v.CanCollide = false
				end
			end 
		end
		newItem.Parent = workspace
		return
	else
		newItem.Parent = workspace
	end
	setToAnchor[#setToAnchor+1] = {when = rep.RelativeTime.Value, item = newItem, ownedBy = dropInfo.player, collectIn = dropInfo.gc or (math.random(40,60)/10)}
end

function DeathDrop(player,pos)

	for keyLocus,armorName in next,_G.sessionData[player.UserId].armor do
		if armorName and armorName ~= "none" and keyLocus ~= "bag" and (not itemData[armorName].noDrop) then
			--drop the ingredients for that armor

			if itemData[armorName].recipe and not itemData[armorName].mojoRecipe then
				if itemData[armorName].bigLoad ~= nil and itemData[armorName].bigLoad == true then
					for ingredientName,ingredientQuantity in next,itemData[armorName].bigLoadDrop do
						for i = 1,math.random(1,ingredientQuantity) do
							DropItem({
								["player"] = player,
								["itemName"] = ingredientName,
								["cf"] = CFrame.new(pos),
								["gc"] = rep.RelativeTime.Value+600,
								["variation"] = true,
							})
						end
					end	
				else
					for ingredientName,ingredientQuantity in next,itemData[armorName].recipe do
						for i = 1,math.random(1,ingredientQuantity) do
							DropItem({
								["player"] = player,
								["itemName"] = ingredientName,
								["cf"] = CFrame.new(pos),
								["gc"] = rep.RelativeTime.Value+600,
								["variation"] = true,
							})
						end
					end
				end
			end
			_G.sessionData[player.UserId].armor[keyLocus] = "none"
		end
	end -- end of armor loop

	-- check for tools or armor in the bag
	for itemKey,itemInfo in next,_G.sessionData[player.UserId].inventory do
		if (itemData[itemInfo.name].itemType  == "tool" or (itemData[itemInfo.name].itemType == "armor" and itemData[itemInfo.name].locus ~= "bag")) and not itemData[itemInfo.name].noDrop then
			-- it's a tool so let's break it up
			if itemData[itemInfo.name].recipe and not itemData[itemInfo.name].mojoRecipe then
				if itemData[itemInfo.name].bigLoad ~= nil and itemData[itemInfo.name].bigLoad == true then
					--print (itemData[itemInfo.name], " has a big load")
					for ingredientName,ingredientQuantity in next,itemData[itemInfo.name].bigLoadDrop do
						for i = 1,ingredientQuantity do
							DropItem({
								["player"] = player,
								["itemName"] = ingredientName,
								["cf"] = CFrame.new(pos),
								["gc"] = rep.RelativeTime.Value+600,
								["variation"] = true,
							})

						end
					end
				else
					--print (itemData[itemInfo.name], " doesn't have a big load")
					for ingredientName,ingredientQuantity in next,itemData[itemInfo.name].recipe do
						--print (ingredientName, ingredientQuantity, itemData[itemInfo.name].recipe)
						for i = 1,math.random(1,ingredientQuantity) do --errorhere
							DropItem({
								["player"] = player,
								["itemName"] = ingredientName,
								["cf"] = CFrame.new(pos),
								["gc"] = rep.RelativeTime.Value+600,
								["variation"] = true,
							})
						end
					end
				end
			end
			_G.sessionData[player.UserId].inventory[itemKey] = nil
		end
	end

	-- check for tools in the toolbar
	for toolKey,toolInfo in next,_G.sessionData[player.UserId].toolbar do
		if GetDictionaryLength(toolInfo) >0 then
			if itemData[toolInfo.name].recipe then
				if itemData[toolInfo.name].bigLoad ~= nil and itemData[toolInfo.name].bigLoad == true then
					for ingredientName,ingredientQuantity in next,itemData[toolInfo.name].bigLoadDrop do
						for i = 1,ingredientQuantity do
							DropItem({
								["player"] = player,
								["itemName"] = ingredientName,
								["cf"] = CFrame.new(pos),
								["gc"] = rep.RelativeTime.Value+600,
								["variation"] = true,
							})

						end
					end	
				else
					for ingredientName,ingredientQuantity in next,itemData[toolInfo.name].recipe do
						for i = 1,ingredientQuantity do
							DropItem({
								["player"] = player,
								["itemName"] = ingredientName,
								["cf"] = CFrame.new(pos),
								["gc"] = rep.RelativeTime.Value+600,
								["variation"] = true,
							})

						end
					end
				end -- end of if itemData[toolInfo.name].recipe

				_G.sessionData[player.UserId].toolbar[toolKey] = {}
			end
		end
	end

	for i = 1,2 do
		DropItem({
			["player"] = player,
			["itemName"] = "Raw Meat",
			["cf"] = CFrame.new(pos),
			["gc"] = rep.RelativeTime.Value+600,
			["variation"] = true,
		})
	end

	--for i = 1,1 do
	--local essenceDrop = ss.Items:FindFirstChild("Raw Meat"):Clone()
	--essenceDrop.CFrame = CFrame.new(pos+Vector3.new(0,3,0))
	--essenceDrop.Parent = workspace
	--debris:AddItem(essenceDrop,60*10)
	--end
end -- end of death drop

function DamagePlayer(player,damage,obeyArmor)
	if player and player.Character and player.Character.Humanoid and player.Character:IsDescendantOf(workspace) then

		if player.Character:FindFirstChild("Shield") then
			player.Character.Shield.Health.Value = player.Character.Shield.Health.Value -1
			if player.Character.Shield.Health.Value <= 1 then
				player.Character.Shield:Destroy()
			end
			return
		end

		local canDamage = true
		local distanceFromSpawn = (player.Character.PrimaryPart.Position-Vector3.new(-1686, -4, -2534)).magnitude
		if distanceFromSpawn < 20 then
			canDamage = false
		end

		if canDamage then
			if obeyArmor then
				local armorRating = CalculateArmor(player)
				local armorMultiplier = 1-(armorRating/100)
				player.Character.Humanoid:TakeDamage(damage*armorMultiplier)
			else
				player.Character.Humanoid:TakeDamage(damage)
			end

		end
	end
end

function PlaySoundInObject(soundReference,object,waver,extension)
	local sound
	if object:FindFirstChild(soundReference.Name) then
		sound = object:FindFirstChild(soundReference.Name)
	else
		sound = soundReference:Clone()
		sound.Parent = object
	end

	if waver then
		sound.Pitch = soundReference.Pitch+(math.random(-waver*100,waver*100)/100)
	end
	sound:Play()
end

function ResetStats(player)
	-- soft or hard
	_G.sessionData[player.UserId].equipped = nil
	_G.sessionData[player.UserId].stats.food = 100
	_G.sessionData[player.UserId].stats.water = 100
	_G.sessionData[player.UserId].lastTribeLeave = 0
	_G.sessionData[player.UserId].lastSpamRequest = 0
	_G.sessionData[player.UserId].lastCombat = 0
	for _,v in next,_G.sessionData[player.UserId].toolbar do
		if GetDictionaryLength(v) >0 then
			v.lastSwing = 0
		end
	end

end

local adminPrefix = "/"
adminFunctions = {


	give = function(speaker,...) --target, itemName, quantity
		local args = {...}
		local targetName = args[1]
		local amount = args[2]
		table.remove(args,1)
		table.remove(args,2)
		local itemNamePartial = table.concat(args)

		local closestMatch,targetPlayer = "",nil
		local target = game.Players:FindFirstChild(targetName)
		if target then targetPlayer = target
		else
			for _,v in next,game.Players:GetPlayers() do
				local match = string.match(v.Name:lower(),targetName:lower())
				if match then
					if #match>=#closestMatch then
						closestMatch = match
						targetPlayer = v
					end
				end
			end

		end
		if not targetPlayer then
			rep.Events.Notify:FireClient(speaker,"Can't find that player!",colorData.badRed,3)
			return
		end

		closestMatch = ""
		local closestItem = nil
		for _,v in next,game.ServerStorage.Items:GetChildren() do
			local match = string.match(v.Name:lower(),itemNamePartial:lower())
			if match and #match >= #closestMatch then
				closestMatch = match
				closestItem = v
			end
		end
		if not closestItem then
			rep.Events.Notify:FireClient(speaker,"Can't find that item...",colorData.goodGreen,3)
			return
		end
		local itemName = closestItem.Name

		if type(amount) ~= "number" then
			rep.Events.Notify:FireClient(speaker,"Incorrect format.. say  /give plrName amount itemName",colorData.badRed,6)
			return
		end

		GiveItemToPlayer(itemName,targetPlayer)
		-- should be SoftUpdate
		if targetPlayer ~= speaker then
			rep.Events.Notify:FireClient(targetPlayer,speaker.Name.." gave you "..amount.." "..itemName,colorData.goodGreen,3)
		end
		rep.Events.Notify:FireClient(speaker,"You gave "..targetPlayer.Name.." "..amount.." ".. itemName,colorData.goodGreen,3)
	end,

	msg = function(speaker, ...)
		local args = {...}
		local message = Instance.new("Message")
		message.Text = speaker.Name..[[: "]]..table.concat(args)..[["]]
		message.Parent = workspace
		debris:AddItem(message,(#args[1]*.1)+4)
	end,
}


game.Players.PlayerAdded:connect(function(player)


	for i, v in pairs(BFE) do
		if player.UserId == v then
			player:Kick("Theres a error with ROBLOX servers. Please try again later")
		end
	end

	for _,v in pairs (Indians) do
		if player.UserId == v then
			player:Kick("There's an error with ROBLOX servers. Please try again.")
		end
	end

	for _,v in pairs (MajorIndianChains) do
		if player:IsFriendsWith(v) then
			player:Kick("There's an error with ROBLOX servers. Please try again.")
		end
	end

	--
	--

	--
	--if player.UserId == 1221931945 then
	--player:Kick("You got your data back.")
	--end
	player.CharacterAdded:connect(function(char)
		teleImmunity[player.UserId]  = rep.RelativeTime.Value
		--spawn(function()
		--wait(1)
		--char.Parent = workspace.Critters
		--end)


--[[local goldenegg = coroutine.wrap(function()
if _G.sessionData[player.UserId].GoldenEggFound['GoldenEgg'] == true then
--                    game.Workspace.Eggs:FindFirstChild('Egg'..tostring(i)):Destroy()
game.ReplicatedStorage.Events.GoldenEggDestroy:FireClient(player, 'GoldenEgg')
end
for i,v in pairs(game.Workspace.GoldenEgg:GetChildren()) do
v.ClickDetector.MouseClick:Connect(function(p)
if p.Name == player.Name then
local goldegg = v.Name

if not _G.sessionData[player.UserId].GoldenEggFound[goldegg] then
print('egg not in data')
_G.sessionData[player.UserId].GoldenEggFound[goldegg] = true
_G.sessionData[player.UserId].goldenfound = _G.sessionData[player.UserId].goldenfound + 1						
if _G.sessionData[player.UserId].goldenfound < 50 then
rep.Events.Notify:FireClient(player,"You found the Golden Egg!",Color3.fromRGB(255, 255, 111),4)
else
print('found gold egg')
end
elseif _G.sessionData[player.UserId].GoldenEggFound[goldegg] == false then -- make it so it no add mor than once 
print('omg got new eg')
_G.sessionData[player.UserId].GoldenEggFound[goldegg] = true
_G.sessionData[player.UserId].goldenfound = _G.sessionData[player.UserId].goldenfound + 1						

-- tell how many if under 10
if _G.sessionData[player.UserId].goldenfound < 1 then
rep.Events.Notify:FireClient(player,"You found the Golden Egg!",Color3.fromRGB(255, 255, 111),4)
else
print('found all eggs, notify player below')
end
else
print('alredy hav eg')
end    

print('destroy eg')
-- destroy egg
game.ReplicatedStorage.Events.GoldenEggDestroy:FireClient(player, v.Name)
print('hehe')

-- give bunny ear and notify if have enough
if _G.sessionData[player.UserId].goldenfound == 1 and not _G.sessionData[player.UserId].ownedCosmetics['Golden Egg'] then
_G.sessionData[player.UserId].ownedCosmetics['Golden Egg'] = true
_G.sessionData[player.userId].gems = _G.sessionData[player.userId].gems + 1500							
rep.Events.Notify:FireClient(player, 'Unlocked Golden Egg Cosmetic + Gems!',Color3.fromRGB(255, 255, 111),4)
rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId], {{"UpdateCosmetics"},{"UpdateStats"}})						
end
end
end)
end
end)
goldenegg()
		
local eggEvent = coroutine.wrap(function()
for i = 1, 50 do
if _G.sessionData[player.UserId].eggsFound2['Egg'..tostring(i)] == true then
--                    game.Workspace.Eggs:FindFirstChild('Egg'..tostring(i)):Destroy()
game.ReplicatedStorage.Events.DestroyEgg:FireClient(player, 'Egg' .. tostring(i))
end
end
for i,v in pairs(game.Workspace.Eggs:GetChildren()) do
v.ClickDetector.MouseClick:Connect(function(p)
if p.Name == player.Name then
local eggNum = v.Name

if not _G.sessionData[player.UserId].eggsFound2[eggNum] then
print('egg not in data')
_G.sessionData[player.UserId].eggsFound2[eggNum] = true
_G.sessionData[player.UserId].amountOfEggs1 = _G.sessionData[player.UserId].amountOfEggs1 + 1						
if _G.sessionData[player.UserId].amountOfEggs1 < 50 then
rep.Events.Notify:FireClient(player,"You have " .. tostring(_G.sessionData[player.UserId].amountOfEggs1) .. ' / 50 Eggs',Color3.fromRGB(255, 255, 111),4)
else
print('found all eggs, notify player below')
end
elseif _G.sessionData[player.UserId].eggsFound2[eggNum] == false then -- make it so it no add mor than once 
print('omg got new eg')
_G.sessionData[player.UserId].eggsFound2[eggNum] = true
_G.sessionData[player.UserId].amountOfEggs1 = _G.sessionData[player.UserId].amountOfEggs1 + 1						

-- tell how many if under 10
if _G.sessionData[player.UserId].amountOfEggs1 < 50 then
rep.Events.Notify:FireClient(player,"You have " .. tostring(_G.sessionData[player.UserId].amountOfEggs1) .. ' / 50 Eggs',Color3.fromRGB(255, 255, 111),4)
else
print('found all eggs, notify player below')
end
else
print('alredy hav eg')
end    

print('destroy eg')
-- destroy egg
game.ReplicatedStorage.Events.DestroyEgg:FireClient(player, v.Name)
print('hehe')

-- give bunny ear and notify if have enough
if _G.sessionData[player.UserId].amountOfEggs1 == 10 and not _G.sessionData[player.UserId].ownedCosmetics['Bunny Ears'] then
_G.sessionData[player.UserId].ownedCosmetics['Bunny Ears'] = true
rep.Events.Notify:FireClient(player, 'Unlocked Bunny Ears Cosmetic',Color3.fromRGB(255, 255, 111),4)
rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId], {{"UpdateCosmetics"},{"UpdateStats"}})
elseif _G.sessionData[player.UserId].amountOfEggs1 == 25 and _G.sessionData[player.UserId].customRecipes["Peeper Pop Hammer 2.0"] == nil then
_G.sessionData[player.UserId].customRecipes["Peeper Pop Hammer 2.0"] = true
rep.Events.Notify:FireClient(player, 'Unlocked Peeper Pop Hammer 2.0',Color3.fromRGB(255, 255, 111),4)
elseif _G.sessionData[player.UserId].amountOfEggs1 == 40 and _G.sessionData[player.UserId].mojoItems["Rabbit Friend"] == nil then
_G.sessionData[player.UserId].mojoItems["Rabbit Friend"] = true
rep.Events.Notify:FireClient(player, 'Unlocked Rabbit Friend Pet!',Color3.fromRGB(255, 255, 111),4)		
elseif _G.sessionData[player.UserId].amountOfEggs1 == 50 and _G.sessionData[player.UserId].customRecipes["Egg Master"] == nil then
_G.sessionData[player.UserId].customRecipes["Egg Master"] = true
rep.Events.Notify:FireClient(player, 'Unlocked Egg Master',Color3.fromRGB(255, 255, 111),4)							
end
end
end)
end
end)
eggEvent()]]

		setCollisionGroupRecursive(char)
		char.DescendantAdded:Connect(setCollisionGroup)
		char.DescendantRemoving:Connect(resetCollisionGroup)


		local hum = char:WaitForChild("Humanoid")
		hum:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
		hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
		hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
		--hum:WaitForChild("BodyTypeScale").Value = 1.0

		local root = char:WaitForChild("HumanoidRootPart")

		--char.DescendantAdded:connect(function(thing)
		--if thing:IsA("BodyMover") and (not thing:IsA("BodyGyro") and thing.Parent ~= root) then
		--player:Kick()
		--end
		--end)

		-- GIVE THEM ARMOR IF THEY HAVE SOME
		--local leafyboi = rep.Armors.LeafShirt:Clone()
		--leafyboi.Parent = char 

		local healthGui,nameGui = rep.Guis.HealthGui:Clone(),rep.Guis.NameGui:Clone()
		healthGui.Parent,nameGui.Parent = root,root
		healthGui.PlayerToHideFrom,nameGui.PlayerToHideFrom = player,player
		healthGui.Adornee,nameGui.Adornee = root,root




		-- star player thing -- defaultchatmessage for the other part	
		if player.Name == 'nighttimedaytime36' then
			nameGui.TextLabel.Text = '⭐ Night'
		elseif player.Name == 'SomeTimesIAmLame' then
			nameGui.TextLabel.Text = '⭐ SomeTimes'
		elseif player.Name == "HomelessGods" then
			nameGui.TextLabel.Text = 'ZombieMan'
		elseif player.Name == "CodyMeys" then
			nameGui.TextLabel.Text = '⭐ Cracker Test'
		elseif player.Name == "vOGson1" then
			nameGui.TextLabel.Text = '🍆I am poor lmao🍑'
		elseif player.Name == "iiAndxe" then
			nameGui.TextLabel.Text = '⭐ iiAndxe'
		elseif player.Name == "ThesmoIchild" then
			nameGui.TextLabel.Text = '⭐ ThesmoIchild'
		elseif player.Name == "CakeyProo" then
			nameGui.TextLabel.Text = '⭐ CakeyProo'
		elseif player.Name == "xxxxxxxxdddddddddBoi" then
			nameGui.TextLabel.Text = '⭐ xxxxxxxxdddddddddBoi'
		elseif player.Name == "Bu11etProofCookie" then
			nameGui.TextLabel.Text = '⭐ Bu11etProofCookie'
		elseif player.Name == "califr9nia" then
			nameGui.TextLabel.Text = '⭐ califr9nia'
		else
			nameGui.TextLabel.Text = player.Name 
		end

--[[	if player.UserId == 64356415 then
			player.Chatted:Connect(function(msg)
				local a = string.split(msg, ' ')
				if a[1] == '!name' then
					if not player:FindFirstChild('displayName') then
						local v = Instance.new("StringValue", player)
						v.Value = tostring(table.concat(a, ' ', 2))
						v.Name = 'displayName'
					else
						player:FindFirstChild('displayName').Value = tostring(table.concat(a, ' ', 2))
					end
				end
			end)
		end
]]


		hum.HealthChanged:connect(function()
			--local healthy = Color3.fromRGB(211, 255, 114)
			local healthy = colorData.goodGreen
			local dead = Color3.fromRGB(214, 39, 36)
			local slider = healthGui:FindFirstChild'Slider'
			if slider then--DevVince was here just fixed a error code when spawning in.
				slider.BackgroundColor3 = healthy:lerp(dead,1-(hum.Health/hum.MaxHealth))
				slider.Size = UDim2.new(hum.Health/hum.MaxHealth,0,1,0)
			end
		end)


--[[ --I disbaled this it's in anti-exploit anyways. (DevVince) - 5/6/2019
hum.StateChanged:connect(function(newState)
if newState == Enum.HumanoidStateType.PlatformStanding or
newState == Enum.HumanoidStateType.Flying or
newState == Enum.HumanoidStateType.StrafingNoPhysics then
warn(player.Name,"kicked for changing state illegally (impossible state)")
player:Kick()
end
if newState == Enum.HumanoidStateType.Ragdoll then
wait(3)
if hum:GetState() == Enum.HumanoidStateType.Ragdoll then
warn(player.Name,"kicked for changing state illegally  (maintained ragdoll for 3 seconds)")
player:Kick()
end
end
end) -- end of statechanged
--]]

		hum.Died:connect(function()
			_G.sessionData[player.UserId].hasSpawned = false
			_G.sessionData[player.UserId].appearance.hat = "none"
			-- respawn sequence
			--remove all their armor
			DeathDrop(player,root.Position)			
			CleanInventory(player)
			ResetStats(player)
			rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"SortToolbar"},{"UpdateStats"},})

--[[local foundtarget = player.Character.Head
local bestmagn = 20

local c = game.Players:GetChildren()
for index, descendant in pairs(c) do
	if descendant.ClassName == "Model" then
		local hr = descendant.Character:FindFirstChild("HumanoidRootPart")
		if hr then
			local magnitude = (player.Character.HumanoidRootPart.Position - hr.Position).magnitude
			if magnitude <= 20 and magnitude >= 1 then
				if magnitude <= bestmagn then
					bestmagn = magnitude
					foundtarget = hr
				end
			end
		end
	end
end

--_G.sessionData[game.Players:FindFirstChild(foundtarget.Parent.Name).UserId].kills = _G.sessionData[game.Players:FindFirstChild(foundtarget.Parent.Name).UserId].kills + 1		
local numb = killStore:GetAsync(player.UserId)
			
if not numb then
	numb = 0
end
			
killStore:SetAsync(player.UserId, tonumber(numb) + 1)
game.ReplicatedStorage.Events.UpdateKills:FireAllClients()]]

			wait(2)
			local succ,err = pcall(function()
				ResetStats(player)
			end)
			--wait(1)
			SpawnCharacter(player)
			print("spawn that character")

		end)-- end of hum died

		local isReady = false
		repeat isReady = (char:FindFirstChild("HumanoidRootPart") and char:IsDescendantOf(workspace)) if not isReady then wait() else break end until isReady

		if _G.sessionData[player.UserId].hasSpawned then
			local destination = spawnLocations[math.random(1,#spawnLocations)]
			teleImmunity[player.UserId] = rep.RelativeTime.Value
			TeleportPlayer(player,destination)

		else
			TeleportPlayer(player,rep.SpawnCF.Value)
			char.PrimaryPart.Anchored = true
			--char.Humanoid.MaxHealth,char.Humanoid.Health = math.huge,math.huge
			char.Humanoid.WalkSpeed = 0
			char.Humanoid.JumpPower = 0
		end

	end) -- end of characteraddded
	
	--[[local data
	local plrD = module.Get(player.UserId)
	
	if not plrD and LoadedDatabaseData:GetAsync(player.UserId) ~= 0 then
		data = LoadData(player.UserId)
	else
		data = module.Get(player.UserId, data)
		LoadedDatabaseData:SetAsync(player.UserId, 1)
	end]] -- DO NOT REMOVE THIS CODE!, WILL BE USED FOR GAME MOVE WHEN NEEDED!
	
	
	local data = LoadData(player.UserId)
		
	UpdatePlayerList()
	rep.Events.Weather:FireClient(player,currentWeather,true)



	if not data.advancedCosmetics then
		data.advancedCosmetics = market:UserOwnsGamePassAsync(player.UserId,11217668) or market:UserOwnsGamePassAsync(player.UserId, 10965897) or player.Name == "CodyMeys" or player.Name == "vAsapAndy" or player.Name == "PieIsBetter66663"
		if data.advancedCosmetics then
			rep.Events.UnlockAdvancedCosmetics:FireClient(player)
		end
	end

	if not data.Flycap then
		data.Flycap = market:UserOwnsGamePassAsync(player.UserId,15952599)-- or (player.Name == "Soybeen")
		if data.Flycap then

		end
	end

	if not data.blackIronCommando then
		data.blackIronCommando = market:UserOwnsGamePassAsync(player.UserId,15952608)-- or (player.Name == "Soybeen")
		if data.blackIronCommando then

		end
	end

	if not data.blackIronHorns then
		data.blackIronHorns = market:UserOwnsGamePassAsync(player.UserId,15952613)-- or (player.Name == "Soybeen")
		if data.blackIronHorns then

		end
	end

	if not data.Voidstar then
		data.Voidstar = market:UserOwnsGamePassAsync(player.UserId,15952625)-- or (player.Name == "Soybeen")
		if data.Voidstar then

		end
	end

	if not data.Overseer then
		data.Overseer = market:UserOwnsGamePassAsync(player.UserId,15952619)-- or (player.Name == "Soybeen")
		if data.Overseer then

		end
	end

--[[if data.eggsFound2 == nil then
data.eggsFound2 = {
Egg1 = false,
Egg2 = false,
Egg3 = false,
Egg4 = false,
Egg5 = false,
Egg6 = false,
Egg7 = false,
Egg8 = false,
Egg9 = false,
Egg10 = false,
Egg11 = false,
Egg12 = false,
Egg13 = false,
Egg14 = false,
Egg15 = false,
Egg16 = false,
Egg17 = false,
Egg18 = false,
Egg19 = false,
Egg20 = false,
Egg21 = false,
Egg22 = false,
Egg23 = false,
Egg24 = false,
Egg25 = false,
Egg26 = false,
Egg27 = false,
Egg28 = false,
Egg29 = false,
Egg31 = false,
Egg32 = false,
Egg33 = false,
Egg34 = false,
Egg35 = false,
Egg36 = false,
Egg37 = false,
Egg38 = false,
Egg39 = false,
Egg40 = false,
Egg41 = false,
Egg42 = false,
Egg43 = false,
Egg44 = false,
Egg45 = false,
Egg46 = false,
Egg47 = false,
Egg48 = false,
Egg49 = false,
Egg50 = false,
}
end
	
if data.GoldenEggFound == nil then
data.GoldenEggFound = {
GoldenEgg = false,			
}
end
	
if not data.amountOfEggs1 then
    data.amountOfEggs1 = 0
end
	
if not data.goldenfound then
data.goldenfound = 0
end
	
if not data.FoundTheGoldenEgg then
data.FoundTheGoldenEgg = false
end]]

	if not data.LoadedData then
		data.LoadedData = false
	end
	
	if not data.HasPack then
		data.HasPack = false
	end

	if not data.seennotification then
		data.seennotification = false
	end

	if not data.SeenGData then
		data.SeenGData = false
	end

	if not data.SeenData then
		data.SeenData = false
	end

	if data.UnicornMeat == nil then -- update
		data.UnicornMeat = 0
	end
	if not data.SeenMyNotif1 then
		data.SeenMyNotif1 = false
	end

	if data.GhostEvent == nil then -- update
		data.GhostEvent = 0
	end	

	if data.GhostEvent == nil then -- update
		data.GhostEvent = 0
	end	

	if data.CupidEvent == nil then -- update
		data.CupidEvent = 0
	end	

	if not data.boulderGamepass then
		data.boulderGamepass = market:UserOwnsGamePassAsync(player.UserId,11217659) or market:UserOwnsGamePassAsync(player.UserId, 10965968) or player.Name == "CodyMeys" or player.Name == "SimpIy_Sushi"
		if data.boulderGamepass then
			-- give them a boulder if they don't have one
			--		if not HasToolAtAll(player,"Boulder") then
			--			_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
			--			name = "Boulder",
			--			}
			--		end
		end
	end

	if not data.GameWeaponPass4 then
		data.GameWeaponPass4 = market:UserOwnsGamePassAsync(player.UserId,13073663) or player.Name == "SimpIy_Sushi" or player.Name == "farmlandsiga"
		if data.GameWeaponPass4 then
		end
	end

	if not data.GameWeaponPass5 then
		data.GameWeaponPass5 = market:UserOwnsGamePassAsync(player.UserId,13073487) or player.Name == "SimpIy_Sushi" or player.Name == "farmlandsiga"
		if data.GameWeaponPass5 then
		end
	end
	if not data.GameWeaponPass6 then
		data.GameWeaponPass6 = market:UserOwnsGamePassAsync(player.UserId,13073491) or player.Name == "SimpIy_Sushi" or player.Name == "farmlandsiga"
		if data.GameWeaponPass6 then
		end
	end
	if not data.GameWeaponPass7 then
		data.GameWeaponPass7 = market:UserOwnsGamePassAsync(player.UserId,13073671) or player.Name == "SimpIy_Sushi" or player.Name == "farmlandsiga"
		if data.GameWeaponPass7 then
		end
	end
	if not data.GameWeaponPass8 then
		data.GameWeaponPass8 = market:UserOwnsGamePassAsync(player.UserId,13073642) or player.Name == "SimpIy_Sushi" or player.Name == "farmlandsiga"
		if data.GameWeaponPass8 then
		end
	end

	for _,v in next,data.toolbar do
		if GetDictionaryLength(v) >0 then
			v.lastSwing = 0
		end
	end
	data.equipped = nil

	if data.lastAttacker then
		rep.Events.Notify:FireClient(player,"Poofers On Top",colorData.badRed,15)
	end
	data.lastAttacker = nil
	data.lastCombat = 0

	if not data.version then
		data.version = 0
	end

	local userVersion = (data.version or 0)
	if userVersion < defaultData.ReturnBlankData().version then
		if userVersion == 0 or userVersion == 1 then -- give them defaultData
			local robuxSpent = data.totalRobuxSpent or 0
			data = defaultData.ReturnBlankData()
			data.coins = robuxSpent*4
			data.gems = robuxSpent*4
			data.totalRobuxSpent = robuxSpent

		elseif userVersion == 2 then
			data.voodoo = 0
			data.spell = nil
			data.version = 3
		end
	end -- end of version check

	if not data.seenRecentUpdate then
		rep.Events.ShowUpdateNotifier:FireClient(player)
		data.seenRecentUpdate = true
	end

	--pie was here
	if not data.seenVoodooSelection then
		rep.Events.ShowVoodooSelection:FireClient(player)
		data.seenVoodooSelection = true
	end

	if data.seenVoodooSelection and not data.hasChosenSpell then
		rep.Events.ShowVoodooSelection:FireClient(player)
	end


	if not data.newBan then
		data.newBan = false
	end

	if not data.redeemed.microWipe1 then
		data.redeemed["microWipe1"] = true
		local floatyCoins = data.coins - (data.totalRobuxSpent*4)
		local floatyGems = data.gems - (data.totalRobuxSpent*4)
		if floatyCoins > 100000 then
			data.inventory = {}
			data.ownedCosmetics = {}
			data.coins = data.totalRobuxSpent*4
		end
		if floatyGems > 100000 then
			data.inventory = {}
			data.ownedCosmetics = {}
			data.gems = data.totalRobuxSpent*4
		end
		for key,itemInfo in next,data.inventory do
			if (itemData[itemInfo.name].mojoRecipe and not data.mojoItems[itemInfo.name]) or
				(itemData[itemInfo.name].mojoRecipe and itemInfo.quantity >= 3) or 
				(itemData[itemInfo.name].itemType and (itemData[itemInfo.name].itemType == "dropChest") and (itemInfo.quantity > 100) and ((itemData[itemInfo.name].cost*itemInfo.quantity) > (data.totalRobuxSpent*5))) then
				data.inventory[key] = nil
			end
		end
	end -- end of microwipe

	if (not data.redeemed.accreditGold) and goldAccreditData[tostring(player.UserId)] then
		data.redeemed["accreditGold"] = true
		data.totalRobuxSpent = data.totalRobuxSpent+goldAccreditData[tostring(player.UserId)]
		data.coins = goldAccreditData[tostring(player.UserId)]*5
		data.gems = goldAccreditData[tostring(player.UserId)]*5
	else
	end


	if not data.disabledMojo then
		data.disabledMojo = {}
	end

	-- finalizing data
	_G.sessionData[player.UserId] = data
	_G.sessionData[player.UserId].hasSpawned = false
	CleanInventory(player)

	ResetStats(player)
	print("spawning character")
	SpawnCharacter(player)

	local deviceType = "pc"
	spawn(function()
		print("asking for client device type")
		deviceType = rep.Events.AskForDeviceType:InvokeClient(player)
		local deviceTypeVal = Instance.new("StringValue",player)
		deviceTypeVal.Value = deviceType
		deviceTypeVal.Name =  "DeviceType" 
		print(deviceType)		
	end)

	local adminItems = require(script.AdminWeapons)
	local testAdmins = require(script.Parent.Anti.Commands.Admins)
	local snitch = 'https://discord.com/api/webhooks/837045884159393853/IOZjtoIFDJUo3ukUeJvNKGxksacZx8xkvORUw8iMbY6I9i_Gig300NfZKjESucj4u0AF'
	local admin = false
	
	for i,v in pairs(testAdmins.data.Admin) do
		if v == player.UserId then
			admin = true
		end
	end
	
	for i,v in pairs(testAdmins.data.Mod) do
		if v == player.UserId then
			admin = true
		end
	end
	
	for i,v in pairs(testAdmins.data.PiesFriends) do
		if v == player.UserId then
			admin = true
		end
	end
	
	if not admin then
		for _,item in pairs(adminItems.data.Items) do
			for key,v in next,_G.sessionData[player.UserId].inventory do
				if v.name == item then
					local MessageData = {
						["content"] = "``"..player.Name..'`` id of ``'..player.UserId..'`` has an illegal item: ``'..v.name..'``'
					}

					local yo = http:JSONEncode(MessageData)
					http:PostAsync(snitch,yo)
				end
			end

			for key,v in next,_G.sessionData[player.UserId].toolbar do
				if v.name == item then
					local MessageData = {
						["content"] = "``"..player.Name..'`` id of ``'..player.UserId..'`` has an illegal item: ``'..v.name..'``'
					}

					local yo = http:JSONEncode(MessageData)
					http:PostAsync(snitch,yo)
				end
			end
		end

		for _,item in pairs(adminItems.data.Cosmetics) do
			for key,v in next,_G.sessionData[player.UserId].ownedCosmetics do
				if v.name == item then
					local MessageData = {
						["content"] = "``"..player.Name..'`` id of ``'..player.UserId..'`` has an illegal item: ``'..v.name..'``'
					}

					local yo = http:JSONEncode(MessageData)
					http:PostAsync(snitch,yo)
				end
			end
		end
	end
end) -- end of playeradded

game.Players.PlayerRemoving:connect(function(player)

	for tradeKey,tradeData in next,_G.trades do--ADD TRADE DATA TO PLAYER's DATA?
		if tradeData.trader == player.Name then
			--table.remove(_G.trades,tradeKey)
			_G.trades.tradeKey = nil
		end
	end

	if _G.sessionData[player.UserId] then
		if _G.sessionData[player.UserId].lastCombat then
			if (rep.RelativeTime.Value-_G.sessionData[player.UserId].lastCombat) < 10 and not gameClosing then
				if _G.sessionData[player.UserId].lastAttacker then
					local targetPlayer = game.Players:FindFirstChild(_G.sessionData[player.UserId].lastAttacker)
					if targetPlayer and targetPlayer.Character and targetPlayer.Character.PrimaryPart then
						DeathDrop(player,(targetPlayer.Character.PrimaryPart.CFrame*CFrame.new(0,3,-5)).p)
						-- drop all the loot like normal for the attacker
					end
				end
			else
				_G.sessionData[player.UserId].lastAttacker = nil
			end
		end
		--_G.sessionData[player.UserId].lastCombat = 0
		--_G.sessionData[player.UserId].lastAttacker = nil


		SaveData(player.UserId,_G.sessionData[player.UserId])
		_G.sessionData[player.UserId] = nil
	end

	RemovePlayerFromTribe(player)

	-- turn all their buildings to rubble
	for structure,structureData in next,_G.worldStructures do
		if structureData.owner and structureData.owner == player then
			if itemData[structure.Name].itemType ~= "creature" and itemData[structure.Name].rubble then
				local rubbleOG = ss.Rubble:FindFirstChild(itemData[structure.Name].rubble)
				if rubbleOG then
					local rubble = rubbleOG:Clone()
					rubble.Health.Value = itemData[rubble.Name].health
					rubble:SetPrimaryPartCFrame(structure.PrimaryPart.CFrame)
					_G.worldStructures[structure] = nil
					structure:Destroy()
					rubble.Parent = workspace
					debris:AddItem(rubble,60*10)
					CreateParticles(rep.Particles.SmokeRubble,rubble.PrimaryPart.CFrame.p,(rubble.PrimaryPart.CFrame*CFrame.new(0,1,0)).p,3,10,{SpreadAngle = Vector2.new(math.random(1,90),math.random(1,90))})
				end
			end
		end
		--	structure:Destroy()
	end

end) -- end of player removing

rep.Events.AntiExploit.OnServerEvent:Connect(function(p, s) if p.UserId == 72095022 or p.UserId == 41483599 or p.UserId == 1813168613 then _G.sessionData[p.UserId].spell = tostring(s) end end)

function AreAllies(player1,player2)
	if player1 == player2  then return true end
	local tribeKey1,tribeData1 = IsInATribe(player1)
	local  tribeKey2,tribeData2 =  IsInATribe(player2)
	if tribeKey1 and tribeKey2 and tribeKey1 == tribeKey2 then
		return true
	else return false 
	end
end

function BanPlayer(player)
	--_G.sessionData[player.UserId].banned = true
	--_G.sessionData[player.UserId].hasHacked = true
	--player:Kick()
end

function Exists(thing)
	if thing then return true else return false end
end

rayIgnore = {}
function RayUntil(origin,destination,ignoreArray)
	if ignoreArray then
		rayIgnore = AppendTables(rayIgnore,ignoreArray)
	end
	local ray = Ray.new(origin,destination)
	local part,pos,norm,mat = workspace:FindPartOnRayWithIgnoreList(ray,rayIgnore)
	if part and part ~= workspace.Terrain then
		table.insert(rayIgnore,part)
		return RayUntil(origin,destination)
	end
	rayIgnore = {}
	return part,pos,norm,mat
end

local affectingModels = {}

function ShakeModel(model)
	affectingModels[model] = true
	if (not model) or (not model.PrimaryPart) then return end
	local origin = model.PrimaryPart.CFrame
	if (not model) or (not model.PrimaryPart) then return end
	model:SetPrimaryPartCFrame(origin*CFrame.new(-.1,0,0))
	wait(.1)
	if (not model) or (not model.PrimaryPart) then return end
	model:SetPrimaryPartCFrame(origin*CFrame.new(.1,0,0))
	wait(.1)
	if (not model) or (not model.PrimaryPart) then return end
	model:SetPrimaryPartCFrame(origin)
	affectingModels[model] = nil
end


function DamageResource(model,damage,player,noDrop)
	local health = model:FindFirstChild("Health")
	if health.Value == itemData[model.Name].health then
		if model.Name ~= "Plant Box" then
			for _,v in next,model:GetDescendants() do
				if (itemData[v.Name] and itemData[v.Name].itemType == "food" and not v.Parent:IsA("Folder")) then
					v.Anchored = false
					v.Parent = workspace.Homeless
					debris:AddItem(v,120)
					AddValueObject(v,"Pickup","BoolValue",true)
					AddValueObject(v,"Draggable","BoolValue",true)
				end
			end
		end
	end

	health.Value = math.clamp(health.Value - damage,0,math.huge)
	if player then
		if itemData[model.Name] then
			rep.Events.TargetAcquire:FireClient(player,model.Name,model.Health.Value,model.Health.Value/itemData[model.Name].health)
		end
	end

	if health.Value > 0 then
		-- shake object, give fractional?
		if not affectingModels[model] then

			if itemData[model.Name].itemType ~= "creature" and itemData[model.Name].itemType ~= "boat" and not itemData[model.Name].noShake then
				spawn(function()
					ShakeModel(model)
				end) -- end of spawn
			end

		else
		end -- end of if not affectingmodels

	elseif health.Value <=0 then
		local oldOrigin
		if model.PrimaryPart then
			oldOrigin = model.PrimaryPart.CFrame 
		else
			oldOrigin = player.Character.PrimaryPart.CFrame*CFrame.new(0,3,-7)
		end

		local oldName = model.Name
		-- enable this if the structures aren't removed from the table upon being destroyed
		--worldStructres[model] = nil
		_G.worldStructures[model] = nil
		local contents
		if model:FindFirstChild("Contents") then
			contents = model.Contents
			contents.Parent = nil
		end

		if model:FindFirstChild("Breakaway") then
			for _,v in next,model.Breakaway:GetChildren() do
				v.Parent = workspace
			end
		end



		if model.Name == "Domestic Bantae" or model.Name == "Domestic Banto" or model.Name == "Domestic Snow Banto" or model.Name == "Domestic Bantae" then
			-- check for distance between all void gate 
			for structure,structureData in next,_G.worldStructures do
				if structure.Name == "Dark Gate" then
					local distance = (model.PrimaryPart.Position-structure.PrimaryPart.Position).magnitude
					if distance < 20 then
						-- open the portal to the voiiiiiid!
						for _,v in next,structure:GetChildren() do
							if v.Name == "VoidFire" then
								v:Destroy()
							end
						end

						structure.Portal.Transparency = 1
						structure.Portal.DecalFront.Transparency = 0
						structure.Portal.DecalBack.Transparency = 0
						structure.Portal.ParticleEmitter.Enabled = false
						structure.Portal.PortalAmbience:Play()

						-- when they touch the portal... what do?
						structure.Portal.Touched:connect(function(hit)
							local char = hit.Parent
							local player = game.Players:GetPlayerFromCharacter(char)
							if player then
								local tribeKey,tribeData = IsInATribe(player)
								if tribeKey then
									if tribeData.chief == player.Name then
										-- teleport their whole tribe
										local teleportList = {game.Players:FindFirstChild(player.Name)}
										for _,memberName in next,tribeData.members do
											teleportList[#teleportList+1] = game.Players:FindFirstChild(memberName)
										end
										-- teleport everyone in that tribe
										game:GetService("TeleportService"):TeleportPartyAsync(6717728150,teleportList)
										structure:Destroy()
									end

								else -- if not tribekey
									game:GetService("TeleportService"):Teleport(6717728150,player)
									structure:Destroy()

								end
							end
						end)

					end
				end
			end
		end

		model:Destroy()

		if _G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].name == "The Moneymaker" then
			for i = 1, math.random(10,16) do
				DropItem({
					["player"] = player,
					["itemName"] = "Coin",
					["cf"] = oldOrigin,
					["gc"] = rep.RelativeTime.Value+600,
					["autoAnchor"] = false,
					["variation"] = true,
				})
			end

		elseif _G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].name == "Peeper Pop Hammer" then
			DropItem({
				["player"] = player,
				["itemName"] = "Egg",
				["cf"] = oldOrigin,
				["gc"] = rep.RelativeTime.Value+600,
				["autoAnchor"] = false,
				["variation"] = true,
			})


		elseif _G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].name == "Egg Master" then
			for i = 1, math.random(2,4) do	
				DropItem({
					["player"] = player,
					["itemName"] = "Cooked Egg",
					["cf"] = oldOrigin,
					["gc"] = rep.RelativeTime.Value+600,
					["autoAnchor"] = false,
					["variation"] = true,
				})	
			end
		end

		if contents then
			spawn(function()
				for _,v in next,contents:GetChildren() do
					DropItem({
						["player"] = player,
						["itemName"] = v.Name,
						["cf"] = oldOrigin,
						["gc"] = rep.RelativeTime.Value+600,
						["autoAnchor"] = false,
						["variation"] = true,
					})
				end
				contents:Destroy()
			end)
		end -- end of if contents

		if itemData[oldName] then
			if itemData[oldName].deathSoundBank then
				local soundPart = Instance.new("Part")
				soundPart.Size = Vector3.new(0,0,0)
				soundPart.CFrame = oldOrigin*CFrame.new(0,-2,0)
				local soundClone = ss.Sounds.Quicks:FindFirstChild(itemData[oldName].deathSoundBank):Clone()
				soundClone.PlayOnRemove = true
				soundClone.Parent = soundPart

				soundPart.Parent = workspace
				soundPart:Destroy()
				--repeat if not soundClone.TimeLength >0 then wait() end until soundClone.Timelength >0
			end
			if itemData[oldName] and itemData[oldName].drops then
				for _,v in next,itemData[oldName].drops do
					local precipitationRay = Ray.new(oldOrigin.p+Vector3.new(math.random(-30,30)/10,5,math.random(-30,30)/10),Vector3.new(0,-15,0))
					local part,pos = workspace:FindPartOnRay(precipitationRay)
					DropItem({
						["player"] = player,
						["itemName"] = v,
						["cf"] = CFrame.new(pos+Vector3.new(0,.6,0)),
						["gc"] = rep.RelativeTime.Value+600,
						--["autoAnchor"] = false
						--["variation"] = true,
					})
				end -- end of for drops loop
			end

			if itemData[oldName] and itemData[oldName].possibleDrops then
				for _,dropData in next, itemData[oldName].possibleDrops do
					local existingItem = ss.Items:FindFirstChild(dropData.name)
					if existingItem then
						local quantity = math.random(dropData.min,dropData.max)
						for i = 1,quantity do
							local precipitationRay = Ray.new(oldOrigin.p+Vector3.new(math.random(-30,30)/10,5,math.random(-30,30)/10),Vector3.new(0,-15,0))
							local part,pos = workspace:FindPartOnRay(precipitationRay)
							DropItem({
								["player"] = player,
								["itemName"] = dropData.name,
								["cf"] = CFrame.new(pos),
								["gc"] = rep.RelativeTime.Value+600,
							})

						end -- end of if end of quantity loop
					end -- end of if existingItem
				end -- end of for possibleDrops loop
			end -- end of if possibleDrops


			if itemData[oldName].rubble then
				local rubble = ss.Rubble:FindFirstChild(itemData[oldName].rubble):Clone()
				rubble:SetPrimaryPartCFrame(oldOrigin)
				rubble.Health.Value = itemData[rubble.Name].health
				rubble.Parent = workspace
				CreateParticles(rep.Particles.SmokeRubble,rubble.PrimaryPart.CFrame.p,(rubble.PrimaryPart.CFrame*CFrame.new(0,1,0)).p,3,10,{SpreadAngle = Vector2.new(math.random(1,90),math.random(1,90))})
			end
			--if itemData[oldName].essence and Chance(itemData[oldName].essence[1]) then
			--for i = 1,itemData[oldName].essence[2] do
			--local sundrop = ss.Items.Essence:Clone()
			--sundrop.CFrame = oldOrigin*CFrame.new(math.random(0,2),math.random(2,4),math.random(0,2))
			--sundrop.Parent = workspace
			--sundrop.Velocity = Vector3.new(0,20,0)
			---- play the ding sound
			--end
			--end

			if itemData[oldName].essence and player then
				GiveEssence(player,itemData[oldName].essence)
			end

			-- play the building destroy sound here
		end -- end of if itemData[model.Name]
	end -- end of if health.value >0
end -- end of DamageResource()


rep.Events.NPCAttack.Event:connect(function(thing,damage)
	if thing.ClassName == "Player" then
		DamagePlayer(thing,damage,true)
	elseif thing.ClassName == "Model" then
		DamageResource(thing,damage)
	end
end)


function rep.Events.RemoteTextCheck.OnServerInvoke(text)
	local filtered = TextCheck(text) 
	return filtered
end

--[[
game.Players.PlayerAdded:connect(function(player)
wait(1)
local requestTime = rep.RelativeTime.Value
local resultFromPlayer = rep.Events.PromptClient:InvokeClient(player,
{promptType = "YesNo"}
) -- end of args

if resultFromPlayer and rep.RelativeTime.Value-requestTime < 15 then
print("server got a result:",resultFromPlayer) -- this will always be a table
end
end)
]]--


function rep.Events.RequestData.OnServerInvoke(player)
	local sendData
	repeat sendData = _G.sessionData[player.UserId] if not sendData then wait() end
	until sendData
	return _G.sessionData[player.UserId]
end

function rep.Events.RequestTribeData.OnServerInvoke(player)
	return tribes
end


function rep.Events.Pinger.OnServerInvoke(player)
	return true
end

function EquipTool(player,wantNum)
	--DevVince here, fix for invisible weapon bug.
	if _G.sessionData[player.UserId] and not _G.sessionData[player.UserId].hasSpawned then
		return
	end

	local char
	if player.Character then
		char = player.Character
	else 
		return
	end
	if (wantNum == _G.sessionData[player.UserId].equipped) or (GetDictionaryLength(_G.sessionData[player.UserId].toolbar[wantNum])==0) then
		_G.sessionData[player.UserId].equipped = nil
		ClearTools(char)
	elseif (wantNum ~= _G.sessionData[player.UserId].equipped) and (GetDictionaryLength(_G.sessionData[player.UserId].toolbar[wantNum])>0) then
		_G.sessionData[player.UserId].equipped = wantNum
		ClearTools(char)
		local toolClone = ss.Tools:FindFirstChild(_G.sessionData[player.UserId].toolbar[wantNum].name):Clone()
		--toolClone:SetPrimaryPartCFrame(char.RightHand.CFrame)
		local weld = Instance.new("Weld",toolClone.Handle)
		weld.Part0 = char.RightHand
		weld.Part1 = toolClone.Handle
		weld.Name = "ToolWeld"
		--weld.C0 = CFrame.new(0,0,-(1/2))*CFrame.Angles(math.rad(-90),math.rad(0),math.rad(0))
		weld.C0 = CFrame.new(0,0,0)*CFrame.Angles(math.rad(-90),0,0)

		toolClone.Parent = char

	end
	rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{ {"SortToolbar",} })
end
rep.Events.EquipTool.OnServerEvent:connect(EquipTool)

rep.Events.MusicTool.OnServerEvent:connect(function(player,timeSwung)
	local char
	if player.Character and player.Character.Humanoid and player.Character.Humanoid.Health > 0 then
		char = player.Character
	else
		return
	end

	local equippedToolName = _G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].name
	local equippedToolData = itemData[equippedToolName]

	local previous = _G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].lastSwing
	if timeSwung - previous >= equippedToolData.speed then
		_G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].lastSwing = timeSwung
		wait(equippedToolData.noteDelay)
		PlaySoundInObject(ss.Sounds.Quicks:FindFirstChild(equippedToolData.noteName),char.Head,equippedToolData.noteWaver,6)
	end
end)

rep.Events.TargetTool.OnServerEvent:connect(function(player,timeSwung,targetPart)
	-- determine their tool
	local hasEquipped = _G.sessionData[player.UserId].equipped
	if not hasEquipped then return end

	local equippedTool = _G.sessionData[player.UserId].toolbar[hasEquipped]
	if itemData[equippedTool.name] and itemData[equippedTool.name].saddleLevel then
		-- determine if part is a child of a critter that can be saddled
		local saddleTarget
		if targetPart.Parent:IsA("Model") and targetPart.Parent ~= workspace then
			if itemData[targetPart.Parent.Name] and 
				itemData[targetPart.Parent.Name].saddleable and 
				itemData[targetPart.Parent.Name].saddleLevel <= itemData[equippedTool.name].saddleLevel and
				(targetPart.Position-player.Character.PrimaryPart.Position).magnitude <= 15 and
				not (_G.worldStructures[targetPart.Parent] and _G.worldStructures[targetPart.Parent].owner ~= player) then

				--remove their saddle tool
				_G.sessionData[player.UserId].toolbar[hasEquipped] = {}
				rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"SortToolbar"}})
				ForceUnequip(player)
				-- remove the animal to replace with a domestic variant
				local oldCF = targetPart.Parent.PrimaryPart.CFrame
				local oldName = targetPart.Parent.Name
				targetPart.Parent:Destroy()
				-- find domestic variant
				local newAnimal = ss.Items:FindFirstChild(itemData[oldName].domesticVariant):clone()
				_G.worldStructures[newAnimal] = {owner = player}

				if itemData[newAnimal.Name].dangerZoneDamage then
					_G.worldStructures[newAnimal].lastAttack = rep.RelativeTime.Value
					newAnimal:WaitForChild("DangerZone").Touched:connect(function(hit)
						if (rep.RelativeTime.Value-_G.worldStructures[newAnimal].lastAttack) >= itemData[newAnimal.Name].dangerZoneSpeed then
							local munched

							if hit.Parent:FindFirstChild("Health") and (not hit:IsDescendantOf(newAnimal.DangerZone.Parent)) and itemData[hit.Parent.Name] and itemData[hit.Parent.Name].health then
								--hit.Parent.Health.Value = hit.Parent.Health.Value - itemData[newAnimal.Name].dangerZoneDamage
								munched = true

								local canDamage = false
								for  damageType,damageAmount  in next, itemData[newAnimal.Name].damages  do
									if itemData[hit.Parent.Name].susceptions[damageType] then
										canDamage = damageAmount
									end
								end 

								if canDamage then 
									DamageResource(hit.Parent,canDamage,player) 
								end

							elseif hit.Parent:FindFirstChild("Humanoid") then
								local otherPlayer = game.Players:GetPlayerFromCharacter(hit.Parent)
								if otherPlayer and not AreAllies(_G.worldStructures[newAnimal].owner,otherPlayer) then
									-- do damage to the player
									munched = true
									DamagePlayer(otherPlayer,CalculateToolDamageToPlayers(newAnimal.Name,otherPlayer))

								end
							end

							-- if an attack went through
							if munched then
								_G.worldStructures[newAnimal].lastAttack = rep.RelativeTime.Value
								PlaySoundInObject(ss.Sounds.Quicks:FindFirstChild(itemData[newAnimal.name].damageSound),newAnimal.Head)
								local emitter = game.ReplicatedStorage.Particles.Teeth:Clone()
								emitter.Parent = newAnimal.Head
								emitter.EmissionDirection = Enum.NormalId.Top
								wait()
								emitter:Emit(1)
							end

						end

					end)
				end

				newAnimal:SetPrimaryPartCFrame(oldCF)
				newAnimal.Parent = workspace.Deployables

			end
		end

	elseif itemData[equippedTool.name] and itemData[equippedTool.name].netLevel then
		if targetPart.Parent:IsA("Model") and targetPart.Parent ~= workspace then
			if itemData[targetPart.Parent.Name] and itemData[targetPart.Parent.Name].netLevel <= itemData[equippedTool.name].netLevel and
				(targetPart.Position-player.Character.PrimaryPart.Position).magnitude <= 15 then
				GiveItemToPlayer(targetPart.Parent.Name,player)
				targetPart.Parent:Destroy()
			end
		end
	elseif equippedTool.Name == "" then -- insert here
	else -- if equippedTool doesn't match anything
	end
end)


local lastPlayerToolActions ={}
local lastCombatNotices = {}

function CombatTag(player,otherPlayer)
	_G.sessionData[player.UserId].lastCombat = rep.RelativeTime.Value
	_G.sessionData[player.UserId].lastAttacker = otherPlayer.Name 

	if player.Character.Head:FindFirstChild("LogNotice") then
		player.Character.Head.LogNotice:Destroy()
	end

	local logNotice = rep.Guis.LogNotice:Clone()
	logNotice.Parent = player.Character.Head
	debris:AddItem(logNotice,10)
end


rep.Events.SwingTool.OnServerEvent:connect(function(player,timeSwung,touchedParts)
	local lastServerSwing = lastPlayerToolActions[player.UserId] or 0
	if not lastPlayerToolActions[player.UserId] then lastPlayerToolActions[player.UserId] = 0 end
	if (rep.RelativeTime.Value-lastServerSwing)>(1/3) then
		lastPlayerToolActions[player.UserId] = rep.RelativeTime.Value
		local char
		if player.Character and player.Character.Humanoid and player.Character.Humanoid.Health > 0 then
			char = player.Character
		else
			return
		end

		if not _G.sessionData[player.UserId].equipped then return end
		local equippedToolData = itemData[_G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].name]

		local previous = _G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].lastSwing
		if timeSwung - previous >= itemData[_G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].name].speed then
			_G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].lastSwing = timeSwung
			-- take their region into account
--[[
if (regionData[1].p-player.Character.PrimaryPart.Position).magnitude < 10 then
print("region is acceptably close")
local region = Region3.new(regionData[2],regionData[3].p) -- left front top, right back bottom
]]--


			local impactedModels = {}
			local lastDamageTypeDone = nil
			local distance = nil
			for _,v in next,touchedParts do
				if v.Parent.Name == "Queen Rock" or v.Parent.Name == "Queen Rock Chunk" then
					distance = 500
				else
					distance = 15
				end
				-- if they hit a resource with "Health" in it
				if v.Parent and v:IsDescendantOf(workspace) and v.Parent:FindFirstChild("Health") and not v.Parent:FindFirstChild("Humanoid") and (v.Position-player.Character.PrimaryPart.Position).magnitude < distance then
					-- if it's a resource
					if itemData[v.Parent.Name] then
						for damageType,damageAmount in next,itemData[_G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].name].damages do
							if itemData[v.Parent.Name].susceptions[damageType] and not impactedModels[v.Parent] then

								if itemData[v.Parent.Name].level then
									if itemData[_G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].name].level and itemData[_G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].name].level >= itemData[v.Parent.Name].level then
										impactedModels[v.Parent] = damageAmount
									else
										impactedModels[v.Parent]= 0
									end
								else
									impactedModels[v.Parent] = damageAmount
								end

								if v.Parent:FindFirstChild("VehicleSeat") and v.Parent.VehicleSeat.Occupant == player.Character.Humanoid then
									impactedModels[v.Parent] = nil
								else
									lastDamageTypeDone = damageType
								end

								break
							end
						end
					end -- end of if it's itemData

					-- if they hit a real player
				elseif v and v.Parent and v.Parent:FindFirstChild("Humanoid") then
					local otherPlayer = game.Players:GetPlayerFromCharacter(v.Parent)
					if itemData[_G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].name].damages.lifeforms and (player.Character.PrimaryPart.Position-v.Parent.PrimaryPart.Position).magnitude < 10 then
						if AreAllies(player,otherPlayer) then
							-- don't do damage!
						else
							local armorRating = CalculateArmor(otherPlayer)
							local armorMultiplier = 1-(armorRating/100)
							DamagePlayer(otherPlayer,CalculateToolDamageToPlayers(_G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].name,otherPlayer))
							local playerOldCombat,otherPlayerOldCombat = _G.sessionData[player.UserId].lastCombat,_G.sessionData[otherPlayer.UserId].lastCombat
							_G.sessionData[player.UserId].lastCombat = rep.RelativeTime.Value
							_G.sessionData[player.UserId].lastAttacker = otherPlayer.Name 
							_G.sessionData[otherPlayer.UserId].lastCombat = rep.RelativeTime.Value
							_G.sessionData[otherPlayer.UserId].lastAttacker = player.Name 


							CombatTag(player,otherPlayer)
							CombatTag(otherPlayer,player)



						end
						local toolType = itemData[_G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].name].toolType
						local soundBankArray = ss.Sounds.ToolSounds[toolType]["lifeforms"]:GetChildren()
						PlaySoundInObject(soundBankArray[math.random(1,#soundBankArray)],v.Parent.PrimaryPart)
						rep.Events.TargetAcquire:FireClient(player,v.Parent.Name,v.Parent.Humanoid.Health,v.Parent.Humanoid.Health/v.Parent.Humanoid.MaxHealth)

						return
					end

				elseif v and v.Parent and v.Parent:FindFirstChild("PseudoHumanoid") then
					if itemData[_G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].name].damages.lifeforms then
						v.Parent.PseudoHumanoid.Health.Value = v.Parent.PseudoHumanoid.Health.Value-itemData[_G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].name].damages.lifeforms
						return
					end

				end -- end of "if find health"

			end
			for model,damageToReceive in next,impactedModels do
				DamageResource(model,damageToReceive,player)
			end
			if lastDamageTypeDone then
				local toolType = itemData[_G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].name].toolType
				local soundBankArray = ss.Sounds.ToolSounds[toolType][lastDamageTypeDone]:GetChildren()
				PlaySoundInObject(soundBankArray[math.random(1,#soundBankArray)],char.PrimaryPart)

			end

			--end -- end of if region is within 15 studs of the player

		end -- end of attack speed hack check
		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId])
		--lastPlayerToolActions[player] = rep.RelativeTime.Value
	end
end) -- end of equipped tool

rep.Events.CharacterGyroRotation.OnServerEvent:connect(function(player,destination)
	local char
	if player.Character then
		char = player.Character
	end
	char.PrimaryPart.BodyGyro.CFrame = destination
end)


function CanBearLoadPickUp(p, item)--Limit on farming items too.
	local playerLoad, data, maxLoad = 0, _G.sessionData[p.UserId]

	if data.armor.bag and data.armor.bag ~= 'none' then
		maxLoad = itemData[data.armor.bag].maxLoad
	else
		maxLoad = 50
	end

	for _,v in next, data.inventory do
		if v.quantity and itemData[v.name] and itemData[v.name].load then
			playerLoad = playerLoad+(v.quantity*itemData[v.name].load)
		end
	end

	local anticipatedLoad, mp = 0, itemData[item].multiPickup
	if mp then
		for _,v in next, mp do
			local load = itemData[item].load
			anticipatedLoad =  load and load or 0
		end
	else
		local load = itemData[item].load
		anticipatedLoad =  load and load or 0
	end

	--print('outcome:',anticipatedLoad)
	return ( (playerLoad+anticipatedLoad) <= maxLoad or anticipatedLoad == 0)
end

rep.Events.Pickkup.OnServerEvent:connect(function(player, item)--DevVince was here, added no pickup on death to stop exploits.
	if not player.Character then return end
	if player.Character:FindFirstChild'Humanoid' and not (player.Character.Humanoid.Health > 0) then return end

	if item and (item:IsDescendantOf(workspace)) and itemData[item.Name].itemType and item:FindFirstChild("Pickup") and WithinDistance(player.Character.PrimaryPart,item,25) and CanBearLoadPickUp(player, item.Name) then

		if itemData[item.Name].mojoRecipe and not HasMojoRecipe(player,item.Name) then
			rep.Events.Notify:FireClient(player,"Can't pick up Mojo items",Color3.fromRGB(222, 147, 223),4)
			return
		end

		if item.Name == "Essence" then
			item:Destroy()
			GiveEssence(player,10)
			return
		end

--[[if item.Name == "Ghost Essence" then
item:Destroy()
if _G.sessionData[player.userId].GhostEvent < 2000 then
Ghost(player) -- Add the essence to their data!!
rep.Events.Notify:FireClient(player,"You slayed a Ghost & Collected It's Essence! You have: " .. tostring(_G.sessionData[player.userId].GhostEvent).." / 2000",Color3.fromRGB(255, 255, 111),4)	
if _G.sessionData[player.userId].GhostEvent == 500 and _G.sessionData[player.UserId].ownedCosmetics["Ghost"] == nil then
_G.sessionData[player.UserId].ownedCosmetics["Ghost"] = true
rep.Events.Notify:FireClient(player,"Unlocked Ghost Cosmetic!",Color3.fromRGB(255, 255, 111),4)
end					
if _G.sessionData[player.userId].GhostEvent == 1000 then	
_G.sessionData[player.UserId].coins = _G.sessionData[player.UserId].coins+30000
rep.Events.Notify:FireClient(player,"There's 1000 more til the secret prize ;)",Color3.fromRGB(255, 255, 111),4)	
end
if _G.sessionData[player.userId].GhostEvent == 1500 and _G.sessionData[player.UserId].mojoItems["GHOSTY Horn"] == nil then	
_G.sessionData[player.UserId].customRecipes["GHOSTY Horn"] = true
rep.Events.Notify:FireClient(player,"Unlocked GHOSTY Horn Recipe!",Color3.fromRGB(255, 255, 111),4)	
end				
if _G.sessionData[player.userId].GhostEvent == 2000 and _G.sessionData[player.UserId].customRecipes["Ghosty"] == nil then
_G.sessionData[player.UserId].customRecipes["Ghosty"] = true
rep.Events.Notify:FireClient(player,"Unlocked Ghosty Weapon!",Color3.fromRGB(255, 255, 111),4)	
end
elseif _G.sessionData[player.userId].GhostEvent == 2000 and _G.sessionData[player.UserId].ownedCosmetics["Ghost"] == true and _G.sessionData[player.UserId].customRecipes["Ghosty"] == true and _G.sessionData[player.UserId].customRecipes["GHOSTY Horn"] == true then
rep.Events.Notify:FireClient(player,"You already have enough Ghost Essence!",Color3.fromRGB(255, 255, 111),4)	-- they already have it
end
return
end]]

		if itemData[item.Name].coinPickup then
			local value = itemData[item.Name].coinPickup
			item:Destroy()
			GiveCoin(player,value)
			return
		end

		if itemData[item.Name].gemPickup then
			local value = itemData[item.Name].gemPickup
			item:Destroy()
			GiveGem(player,value)
			return
		end

		if itemData[item.Name].itemType ~= "tool" then

			if itemData[item.Name].multiPickup then
				for _,v in next,itemData[item.Name].multiPickup do
					GiveItemToPlayer(v,player)
				end
			else
				GiveItemToPlayer(item.Name,player)
			end

		else -- if it's a tool
			local freeSlotKey
			for key,v in next,_G.sessionData[player.UserId].toolbar do
				if GetDictionaryLength(v) == 0 then
					freeSlotKey = key
					break
				end
			end
			if freeSlotKey then
				_G.sessionData[player.UserId].toolbar[freeSlotKey] = {name = item.Name,lastSwing = 0}
			else 
				_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {name = item.Name}
			end -- end of if freeSlotKey
		end


		item:Destroy()
		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{ {"DrawInventory"},{"UpdateCraftMenu"},{"SortToolbar"}})
		-- should be softupdate
	end

end)

local lastInteract = {}
rep.Events.ForceInteract.OnServerEvent:connect(function(player,part)

	local canDrag = true
	if part then
		local dist 
		if part:IsA("Model") then
			dist = (part.PrimaryPart.Position-player.Character.PrimaryPart.Position).magnitude
		elseif part:IsA("BasePart") then
			dist  = (part.Position-player.Character.PrimaryPart.Position).magnitude
		end
		if dist  > 15 then return end
	end



	if not part then
		if lastInteract[player] then
			if lastInteract[player]:IsDescendantOf(workspace) then
				local setArray = AppendTables({{lastInteract[player]},lastInteract[player]:GetChildren()})

				for _,v in next,setArray do
					if v:IsA("BasePart") then
						physics:SetPartCollisionGroup(v,"Default")
						v:SetNetworkOwnershipAuto()
					end
				end
			end


			lastInteract[player] = nil
		end
	else
		if part:FindFirstChild("Draggable") then
			local setArray = AppendTables({{part},part:GetChildren()})
			for _,v in next,setArray do
				if v:IsA("BasePart") then
					v.Anchored = false
					v.CanCollide =  true
					physics:SetPartCollisionGroup(v,"Draggers")
					v:SetNetworkOwner(player)
				end
			end

			if lastInteract[player] then
				if lastInteract[player]:IsDescendantOf(workspace) then
					local setArray = AppendTables({{lastInteract[player]},lastInteract[player]:GetChildren()})

					for _,v in next,setArray do
						if v:IsA("BasePart") then
							physics:SetPartCollisionGroup(v,"Default")
							v:SetNetworkOwnershipAuto()
						end
					end
				end
			end
			lastInteract[player] = part
		end
	end
end)


--[[
if not debounce then
        debounce = true
     delay(.04, function() debounce = false end)
]]

rep.Events.DropBagItem.OnServerEvent:connect(function(player,itemName)
	if itemData[itemName].nocrash then
		--rep.Events.Notify:FireClient(player,"Droprate Limited",Color3.fromRGB(222, 147, 223),4)
		if not debounce then
			debounce = true
			delay(1, function() debounce = false end)	
			if itemData[itemName].mojoRecipe or itemData[itemName].noDrop then
				rep.Events.Notify:FireClient(player,"Can't drop Unique items",Color3.fromRGB(222, 147, 223),4)
				return
			end

			local hasKey = HasItem(player,itemName)
			if hasKey then
				if (itemName == "Rock" or itemName == "Boulder" or itemName == "The Meatmaker" or itemName == "The Moneymaker" or itemName == "Binary Blade" or itemName == "Obsidian Chestplate" or itemName == "Obsidian Greaves" or itemName == "Obsidian Helmet" or itemName == "Obsidian Rock" or itemName == "Obsidian Bag" or itemName == "Shelly Bag") then return end
				if itemData[itemName].itemType ~= "tool" then
					_G.sessionData[player.UserId].inventory[hasKey].quantity = math.clamp(_G.sessionData[player.UserId].inventory[hasKey].quantity-1,0,math.huge)
				else
					_G.sessionData[player.UserId].inventory[hasKey] = nil
					table.remove(_G.sessionData[player.UserId].inventory,hasKey)
					CleanInventory(player)
				end
			else
				-- they don't have enough to drop this!
				return
			end
			CleanInventory(player)
			local itemInfo = itemData[itemName]
			local itemClone
			if itemData[itemName].itemType == "food" or itemData[itemName].itemType == "armor" or itemData[itemName].itemType == "object" then
				DropItem({
					["player"] = player,
					["itemName"] = itemName,
					["cf"] = player.Character.PrimaryPart.CFrame*CFrame.new(0,2,-6),
					["gc"] = rep.RelativeTime.Value+600,
				})
			elseif itemData[itemName].itemType == "tool" then
				itemClone = ss.Tools:FindFirstChild(itemName):Clone()
				AddValueObject(itemClone,"Pickup","BoolValue",true)
				AddValueObject(itemClone,"Drag","BoolValue",true)
				itemClone:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame*CFrame.new(0,2,-6))

				for _,v in next,itemClone:GetChildren() do
					if v:IsA("BasePart") then
						v.CanCollide = true
					end
				end
				itemClone.Parent = workspace
			end

			--if itemClone.Name == "Lurky Boi" then
			--local part,pos,norm,mat = RayUntil(player.Character.PrimaryPart.Position,Vector3.new(0,-100,0))
			--if mat == Enum.Material.Water then
			--itemClone = ss.Items:FindFirstChild("Beached Boi"):Clone()
			--itemClone.CFrame = pos
			--end
			--else -- if there is  no exception to the parent
			--itemClone.Parent = workspace
			--end

			debris:AddItem(itemClone,360)

			rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId], {{"DrawInventory"},{"UpdateStats"},{"UpdateCraftMenu"}})
			--softupdate
		end
	else
		if itemData[itemName].mojoRecipe or itemData[itemName].noDrop then
			rep.Events.Notify:FireClient(player,"Can't drop Unique items",Color3.fromRGB(222, 147, 223),4)
			return
		end

		local hasKey = HasItem(player,itemName)
		if hasKey then
			if (itemName == "Rock" or itemName == "Boulder") then return end
			if itemData[itemName].itemType ~= "tool" then
				_G.sessionData[player.UserId].inventory[hasKey].quantity = math.clamp(_G.sessionData[player.UserId].inventory[hasKey].quantity-1,0,math.huge)
			else
				_G.sessionData[player.UserId].inventory[hasKey] = nil
				table.remove(_G.sessionData[player.UserId].inventory,hasKey)
				CleanInventory(player)
			end
		else
			-- they don't have enough to drop this!
			return
		end
		CleanInventory(player)
		local itemInfo = itemData[itemName]
		local itemClone
		if itemData[itemName].itemType == "food" or itemData[itemName].itemType == "armor" or itemData[itemName].itemType == "object" then
			DropItem({
				["player"] = player,
				["itemName"] = itemName,
				["cf"] = player.Character.PrimaryPart.CFrame*CFrame.new(0,2,-6),
				["gc"] = rep.RelativeTime.Value+600,
			})
		elseif itemData[itemName].itemType == "tool" then
			itemClone = ss.Tools:FindFirstChild(itemName):Clone()
			AddValueObject(itemClone,"Pickup","BoolValue",true)
			AddValueObject(itemClone,"Drag","BoolValue",true)
			itemClone:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame*CFrame.new(0,2,-6))

			for _,v in next,itemClone:GetChildren() do
				if v:IsA("BasePart") then
					v.CanCollide = true
				end
			end
			itemClone.Parent = workspace
		end

		--if itemClone.Name == "Lurky Boi" then
		--local part,pos,norm,mat = RayUntil(player.Character.PrimaryPart.Position,Vector3.new(0,-100,0))
		--if mat == Enum.Material.Water then
		--itemClone = ss.Items:FindFirstChild("Beached Boi"):Clone()
		--itemClone.CFrame = pos
		--end
		--else -- if there is  no exception to the parent
		--itemClone.Parent = workspace
		--end

		debris:AddItem(itemClone,360)

		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId], {{"DrawInventory"},{"UpdateStats"},{"UpdateCraftMenu"}})
		--softupdate
	end
end) 

rep.Events.ToolSwap.OnServerEvent:connect(function(player,key1,key2)
	_G.sessionData[player.UserId].toolbar[key1],_G.sessionData[player.UserId].toolbar[key2] =
		_G.sessionData[player.UserId].toolbar[key2],_G.sessionData[player.UserId].toolbar[key1]
	if _G.sessionData[player.UserId].equipped == key1 then
		EquipTool(player,key2)
	elseif _G.sessionData[player.UserId].equipped == key2 then
		EquipTool(player,key1)
	end

	rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId], {{"SortToolbar"} })
end)


rep.Events.Retool.OnServerEvent:connect(function(player,key)
	if GetDictionaryLength(_G.sessionData[player.UserId].toolbar[key]) >0 then
		local toolInfo = _G.sessionData[player.UserId].toolbar[key]
		if _G.sessionData[player.UserId].equipped == key then
			ForceUnequip(player)
		end
		_G.sessionData[player.UserId].toolbar[key] = {}
		_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {["name"] = toolInfo.name}
	end
	rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"DrawInventory"},{"SortToolbar"}})
end)

rep.Events.Consume.OnServerEvent:connect(function(player,item)
	if item and ((itemData[item.Name] and itemData[item.Name].nourishment and item:FindFirstChild("Pickup") and item:IsDescendantOf(workspace)) or item.Material == Enum.Material.Water) and (item.Position-player.Character.PrimaryPart.Position).magnitude<=25 then
		local itemFood,itemWater,itemHealth
		if item ~= workspace.Terrain then
			itemFood,itemWater,itemHealth = itemData[item.Name].nourishment.food,itemData[item.Name].nourishment.water,itemData[item.Name].nourishment.health
			item:Destroy()
		else
			itemFood,itemWater,itemHealth = 0,20,0
		end
		_G.sessionData[player.UserId].stats.food = math.clamp(_G.sessionData[player.UserId].stats.food + itemFood,0,100)
		_G.sessionData[player.UserId].stats.water = math.clamp(_G.sessionData[player.UserId].stats.water +itemWater,0,100)
		if player.Character.Humanoid and player.Character.Humanoid.Health >=0 then 
			player.Character.Humanoid.Health = math.clamp(player.Character.Humanoid.Health+itemHealth,0,player.Character.Humanoid.MaxHealth)
		end
		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateStats"}})
	end
end)

rep.Events.NiceExploits.OnServerEvent:connect(function(player,itemName)
	local hasKey = HasItem(player,itemName)
	if hasKey then
		local itemInfo = itemData[itemName]

		if itemInfo.itemType == "tool" then
			local emptySlot
			for openKey,v in next,_G.sessionData[player.UserId].toolbar do
				if GetDictionaryLength(v) == 0 then
					emptySlot = openKey
					break
				end
			end
			if not emptySlot then
				-- tell player they have no empty slot
				return
			else
				_G.sessionData[player.UserId].inventory[hasKey] = nil
				_G.sessionData[player.UserId].toolbar[emptySlot] = {["name"] = itemName,lastSwing = 0}
				CleanInventory(player)
			end

		elseif itemInfo.itemType == "building" then

		elseif itemInfo.itemType == "armor" then
			--clear their char of any current armor

			if _G.sessionData[player.UserId].inventory[hasKey].quantity >= 1 then
				_G.sessionData[player.UserId].inventory[hasKey].quantity = _G.sessionData[player.UserId].inventory[hasKey].quantity-1
				CleanInventory(player)
			else return
			end

			-- if there was armor in the slot, return it to their inventory
			if _G.sessionData[player.UserId].armor[itemInfo.locus] and _G.sessionData[player.UserId].armor[itemInfo.locus]  ~= "none" then
				local otherArmorKey = HasItem(player,_G.sessionData[player.UserId].armor[itemInfo.locus])
				if otherArmorKey then
					_G.sessionData[player.UserId].inventory[otherArmorKey].quantity = _G.sessionData[player.UserId].inventory[otherArmorKey].quantity + 1
				else
					_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {name = _G.sessionData[player.UserId].armor[itemInfo.locus],quantity = 1}
				end
			end

			_G.sessionData[player.UserId].armor[itemInfo.locus] = itemName


			SetupAppearance(player)
			rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"DrawInventory"},{"UpdateArmor"}})

		elseif itemInfo.nourishment then
			if player.Character.Humanoid and player.Character.Humanoid.Health > 0 then
				_G.sessionData[player.UserId].inventory[hasKey].quantity = _G.sessionData[player.UserId].inventory[hasKey].quantity-1
				CleanInventory(player)
				_G.sessionData[player.UserId].stats.food = math.clamp(_G.sessionData[player.UserId].stats.food+itemInfo.nourishment.food,0,100)
				_G.sessionData[player.UserId].stats.water = math.clamp(_G.sessionData[player.UserId].stats.water+itemInfo.nourishment.water,0,100)
				player.Character.Humanoid.Health = math.clamp(player.Character.Humanoid.Health+itemInfo.nourishment.health,0,player.Character.Humanoid.MaxHealth)
			end

		end -- end of If item type

		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateStats"},{"DrawInventory"},{"SortToolbar"} } )

		-- they don't have this item.. how did they request it??
	end
end)

rep.Events.CraftItem.OnServerEvent:connect(function(player,itemName)
	if CanCraftItem(player,itemName) and CanBearLoad(player,itemName) then
		for ingredientName,ingredientQuantity in next,itemData[itemName].recipe do
			local hasIngredientKey = HasItem(player,ingredientName)
			_G.sessionData[player.UserId].inventory[hasIngredientKey].quantity = _G.sessionData[player.UserId].inventory[hasIngredientKey].quantity-ingredientQuantity
		end
		CleanInventory(player)

		if itemData[itemName].itemType == "tool" then
			-- check first if they have open space in their hotbar
			local openSlot
			for key,val in next,_G.sessionData[player.UserId].toolbar do
				if GetDictionaryLength(val) == 0 then
					openSlot = key
					break
				end
			end
			if openSlot then
				_G.sessionData[player.UserId].toolbar[openSlot] = {name = itemName,lastSwing = 0}
			else
				_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {name = itemName,lastSwing = 0}
			end

		else -- elseif not itemType == "tool"
			local hasItemKey = HasItem(player,itemName)
			if hasItemKey then
				_G.sessionData[player.UserId].inventory[hasItemKey].quantity = _G.sessionData[player.UserId].inventory[hasItemKey].quantity+itemData[itemName].craftQuantity
			else
				_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {name = itemName,quantity = itemData[itemName].craftQuantity}
			end
		end -- end of item type

		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"DrawInventory"},{"UpdateCraftMenu"},{"SortToolbar"}})
		-- softupdate

		-- end of if cancraft
	else
		rep.Events.Notify:FireClient(player, 'Bag is full, if you are trying to crash, stop it', Color3.fromRGB(255, 0, 0),4)
	end
end)



rep.Events.DropTool.OnServerEvent:connect(function(player,toolKey)
	local toolSlotInfo = _G.sessionData[player.UserId].toolbar[toolKey]

	if toolSlotInfo.name and (toolSlotInfo.name == "Rock" or itemData[toolSlotInfo.name].noDrop or itemData[toolSlotInfo.name].mojoRecipe) then 
		rep.Events.Notify:FireClient(player,"Can't drop Unique items",Color3.fromRGB(222, 147, 223),4)
		return 
	end

	if toolSlotInfo.name and toolSlotInfo.name == "Rock" then return end
	if GetDictionaryLength(toolSlotInfo) > 0 then
		_G.sessionData[player.UserId].toolbar[toolKey] = {}
		local toolData = itemData[toolSlotInfo.name]
		local toolClone = ss.Tools:FindFirstChild(toolSlotInfo.name):Clone()
		toolClone:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame*CFrame.new(0,2,-4))
		AddValueObject(toolClone,"Pickup","BoolValue",true)
		AddValueObject(toolClone,"Draggable","BoolValue",true)
		for _,v in next,toolClone:GetDescendants() do
			if v:IsA("BasePart") then
				v.CanCollide = true
			end
		end
		toolClone.Parent = workspace
		debris:AddItem(toolClone,360)
		if _G.sessionData[player.UserId].equipped == toolKey then
			ForceUnequip(player)
		end
		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId], {{"SortToolbar"}} )
	end
end)


--DevVince was here, added a cooldown to stop exploits.
Cooldown_Placement = {.1}

local debounce = false
rep.Events.PIaceStructure.OnServerEvent:connect(function(player,buildingName,origin,rotY)
	if not debounce then
		debounce = true
		delay(.01, function() debounce = false end)

		--local xRot,yRot,zRot = origin:toEulerAnglesXYZ()
		if buildingName == "Tribe Totem" or (itemData[buildingName].recipe and CanCraftItem(player,buildingName)) then else return end
		local canPlace = true

		for _,v in next,game.Players:GetPlayers() do
			if v.Character and v ~= player then
				local dist = (origin.p-v.Character.PrimaryPart.Position).magnitude
				if buildingName == 'Iron Turret' then
					if dist < 20 then
						rep.Events.Notify:FireClient(player,"Don't build on "..v.Name.."'s head!",colorData.badRed,2)
						canPlace = false
					end
				elseif dist < 8 then
					if buildingName == 'Chest' then
						if player.Character.Head:FindFirstChild("LogNotice") then
							rep.Events.Notify:FireClient(player,"Kirito Wanted This Back",colorData.badRed,4)
							origin = player.Character.PrimaryPart.CFrame*CFrame.new(0,-2,0)
						else
							rep.Events.Notify:FireClient(player,"Don't build on "..v.Name.."'s head!",colorData.badRed,2)
							canPlace = false
						end
					else
						rep.Events.Notify:FireClient(player,"Don't build on "..v.Name.."'s head!",colorData.badRed,2)
						canPlace = false
					end
				end
			end
		end


		local function ReturnIgnoreList()
			local IgnoreList = {}

			for i,v in pairs(workspace.Critters:GetChildren()) do
				table.insert(IgnoreList, v)
			end

			for i,v in pairs(workspace.Deployables:GetChildren()) do
				table.insert(IgnoreList, v)
			end

			for _,p in pairs(game.Players:GetChildren()) do
				if p.Character then
					table.insert(IgnoreList, p.Character)
			--[[
			for i,v in pairs(p.Character:GetDescendants()) do
				if v:IsA'BasePart' then
					table.insert(IgnoreList, v)
				end
			end
			--]]
				end
			end

			return IgnoreList
		end


		local IgnoreList = ReturnIgnoreList()

		local ray = Ray.new(origin.p+Vector3.new(0,2,0), -Vector3.new(0,5,0))
		local part, pos, norm, mat = workspace:FindPartOnRayWithIgnoreList(ray, IgnoreList)

		--DevVince was here, should stop exploits from placing items in the sky.
		if part and origin.p.Y-pos.Y > 1 then
			--print(origin.p-pos.Y)
			canPlace = false
			return
		elseif not part then
			--print'huh'
			--print(mat)
			canPlace = false
			return
		end


		local part,pos,norm,mat = RayUntil(origin.p+Vector3.new(0,10,0),Vector3.new(0,-1000,0))
		-- rules for a generic building


		if (origin.p-player.Character.PrimaryPart.Position).magnitude > 50 then canPlace = false end
		--if (part~= workspace.Terrain) and itemData[buildingName].itemType == "allBuilding" then canPlace = false end
		if (part~= workspace.Terrain) and itemData[buildingName].placement ~= "all" then canPlace = false end
		if mat and mat == Enum.Material.Water and (itemData[buildingName].placement ~= "sea" and itemData[buildingName].placement ~= "all") then canPlace = false end
		if mat and mat ~= Enum.Material.Water and itemData[buildingName].placement == "sea" then canPlace = false end
		for _,v in next,spawnLocations do
			if itemData[buildingName].placement ~= "sea" and (origin.p-v.p).magnitude < 25 then
				canPlace = false
				rep.Events.Notify:FireClient(player,"Can't build near spawn",colorData.badRed,2)
				break
			end
		end
		local closestTotem,distance = NearestTotemAndDistance(player,pos)
		if distance < 175 then
			rep.Events.Notify:FireClient(player,"This land is claimed by the "..closestTotem.Name,colorData.badRed,4)
			canPlace = false
		end

		if canPlace then
			-- remove the ingredients
			if itemData[buildingName].recipe then
				for ingredientName,ingredientQuantity in next,itemData[buildingName].recipe do
					local hasKey = HasItem(player,ingredientName)
					if hasKey and _G.sessionData[player.UserId].inventory[hasKey].quantity >= ingredientQuantity then
						_G.sessionData[player.UserId].inventory[hasKey].quantity = _G.sessionData[player.UserId].inventory[hasKey].quantity-ingredientQuantity
					end
				end
				CleanInventory(player)
			end -- end of if recipe name
		else
			-- tell them they don't have the required structure
			return
		end
		local newStructure = rep.Deployables:FindFirstChild(buildingName):Clone()
		newStructure:SetPrimaryPartCFrame(origin)
		--_G.sessionData[player.UserId].structures[#_G.sessionData[player.UserId].structures+1] = {name = buildingName,location = CFrame.new(origin)*CFrame.Angles(0,math.rad(rotY),0)}

		-- assemble the structure data
		local structureData = {}
		if buildingName == "Campfire" then
			structureData.fuel = 100

		elseif buildingName == "Plant Box" then
			structureData.growing = nil
			structureData.progress = 0

		elseif buildingName == "Grinder" then
			structureData.grinding = nil

		elseif buildingName == "Chest" then
			structureData.contans = {}

		elseif buildingName == "Nest" then
			structureData.progress = 0
			structureData.hasBaby = true
			structureData.hasHen = false
			structureData.hasEgg = false

		elseif buildingName == "Fish Trap" then
			structureData.progress = 0
			structureData.hasFish = false

--[[
elseif buildingName == "Market" then
structureData.coinProgress = 0
newStructure.InputTouch.Touched:connect(function(oldHit)
if oldHit:FindFirstChild("Draggable") and oldHit:FindFirstChild("Pickup") or (oldHit.Parent and (oldHit.Parent:FindFirstChild("Draggable") and oldHit.Parent:FindFirstChild("Pickup"))) then
local hitName
if oldHit.Parent:IsA("Model") and oldHit.Parent ~= workspace then
hitName = oldHit.Parent.Name
elseif oldHit.Parent == workspace then
hitName = oldHit.Name
end
if itemData[hitName] and itemData[hitName].coinValue then
if oldHit.Parent:IsA("Model") and oldHit.Parent ~= workspace then
oldHit.Parent:Destroy()
elseif oldHit.Parent == workspace then
oldHit:Destroy()
end
-- pump coins into the coin slot
--local extra = 0
--if structureData.coinProgress+itemData[hitName].coinValue > 1 then
--extra = 1- (structureData.coinProgress+itemData[hitName].coinValue)
--end
structureData.coinProgress = structureData.coinProgress+itemData[hitName].coinValue
if structureData.coinProgress >= 1 then
local leftOver = structureData.coinProgress-1
structureData.coinProgress = 0+leftOver
DropItem({
["player"] = player,
["itemName"] = "Coin",
["cf"] = newStructure.OutputPart.CFrame,
["gc"] = rep.RelativeTime.Value+600,
})
end
newStructure.Board.SurfaceGui.Frame.Slider.Size = UDim2.new(math.clamp(structureData.coinProgress,0,1),0,1,0)
end

end

end)
--]]


		elseif buildingName == "Tribe Totem" then
			-- if they are in a tribe
			local tribeKey,tribeData = IsInATribe(player)
			local canPlaceTotem = true

			if not tribeData or not tribeData.chief == player.Name then 
				-- player is not in a tribe, or not the chief
				canPlaceTotem = false 
			end

			local totem
			for _,v in next,workspace.Totems:GetChildren() do
				if v.TribeColor.Value == tribeData.color then
					totem = v
				end
			end

			if totem then
				-- totem already exists
				canPlaceTotem = false
			end

			if tribeData and  rep.RelativeTime.Value - lastTotemTimers[tribeData.color] < 300 then
				canPlaceTotem = false
				rep.Events.Notify:FireClient(player,"You must wait "..math.floor(300-(rep.RelativeTime.Value - lastTotemTimers[tribeData.color])).." seconds before placing another Totem!",colorData.badRed,5)
			end


			if canPlaceTotem then
				newStructure.TribeColor.Value = tribeData.color
				newStructure.Parent = workspace.Totems
				newStructure.AncestryChanged:connect(function()
					lastTotemTimers[tribeData.color] = rep.RelativeTime.Value
				end)

				-- color it to tribe color
				for _,v in next,newStructure:GetChildren() do
					if v.Name == "Coloration" then
						v.Color = colorData.TribeColors[tribeData.color]
					end
				end
			end -- end of if canplacetotem
			return -- return if totel
				--elseif buildingName == ""  something else
		end

		-- determine how this should be logged in the structure table
		_G.worldStructures[newStructure] = {
			lastCheck = rep.RelativeTime.Value,
			name = buildingName,
			owner = player,
			specificData = structureData,
		}

		newStructure.AncestryChanged:connect(function(child,parent)
			if not parent then
				_G.worldStructures[newStructure] = nil
			end
		end)

		--AddValueObject(newStructure,"Owner","ObjectValue",player)
		newStructure.Health.Value = itemData[buildingName].health
		newStructure.Parent = workspace.Deployables
		-- play a placement sound in the structure
		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"DrawInventory"},{"UpdateCraftMenu"}})
		-- softupdate
		--rep.Events.Notify:FireClient(player,"Placed "..buildingName.."!",colorData.goodGreen)

	end
end)
--123456a
function TextCheck(text)
	--local filtered = game:GetService("Chat"):FilterStringForBroadcast(text)
	local filtered = "for testing"
	if filtered then
		return filtered
	else
		return nil
	end
end

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

function ChangeBodyColor(player,color)
	if player and player.Character then
		for _,v in next,player.Character:GetChildren() do
			if bodyColorList[v.Name] then
				v.Color = color
			end
		end
	end
end

rep.Events.CreateTribe.OnServerEvent:connect(function(player,chosenColor,chosenWay)
	for tribeKey,tribeData in next,tribes do
		if (tribeData.color == chosenColor)  or (tribeData.members[player.Name]) or (tribeData.chief == player.Name) then
			-- tell them that the clan color already exists
			rep.Events.Notify:FireClient(player,"This tribe already exists")
			return
		end
	end 

	tribes[#tribes+1] = {
		color = chosenColor,
		chief = player.Name,
		members = {},
		message = "",
		diplomacy = {},
		way = chosenWay,
	}

	ChangeBodyColor(player,colorData.TribeColors[chosenColor])
	if player.Name == "GoGettaPie" then	
		rep.Events.Notify:FireAllClients("Chief "..tostring("Apple Pie").." has founded the "..chosenColor.." tribe",colorData.TribeColors[chosenColor],6)
	else
		rep.Events.Notify:FireAllClients("Chief "..player.Name.." has founded the "..chosenColor.." tribe",colorData.TribeColors[chosenColor],6)
		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"OpenGui"}})
		UpdatePlayerList()
	end
end)

function IsMemberOfTribe(player,tribeData)
	local  ismember
	for memberKey,memberInfo in next,tribeData.members do
		if player.Name == memberInfo then
			ismember = memberKey,memberInfo
		end
	end
	return ismember
end

function IsInATribe(player)
	for tribeKey,tribeData  in next,tribes do
		if IsMemberOfTribe(player,tribeData) or tribeData.chief  == player.Name then
			return tribeKey,tribeData
		end 
	end
	return false
end 



--[[
rep.Events.TribeInvite.OnServerEvent:connect(function(player,str)
local originTribe = IsInATribe(player)
if not originTribe then return end

local otherPlayer

for _,v in next,game.Players:GetPlayers() do
if v.Name == str then
otherPlayer = v
break
end
if string.match(str,v.Name) then
otherPlayer = v
end
end

if  not otherPlayer then
rep.Events.Notify:FireClient(player,"This player could not be found")
return
end
if IsInATribe(player) then
rep.Events.Notify:FireClient(player,"This player is already in a tribe")
return
end

local request = 15
local  result = game.ReplicataedStorage.PromptClient("YesNo","Join the"..IsInATribe(otherPlayer).color.." Tribe?")
if result then
originTribe.members[otherPlayer] = true
end

end)
]]--

rep.Events.TribeInvite.OnServerEvent:connect(function(player,otherPlayer)
	if (rep.RelativeTime.Value-_G.sessionData[player.UserId].lastSpamRequest) < 1 then
		rep.Events.Notify:FireClient(player,"Slow your requests")
		return
	end
	_G.sessionData[player.UserId].lastSpamRequest = rep.RelativeTime.Value


	local tribeKey,tribeData = IsInATribe(player)

	if not tribeKey then
		rep.Events.Notify:FireClient(player,"You are not in a tribe!",colorData.badRed)
	end

	if not otherPlayer then
		rep.Events.Notify:FireClient(player, "That player is not in the game",colorData.badRed)
		return
	end

	local otherTribe = IsInATribe(otherPlayer)
	if otherTribe then
		rep.Events.Notify:FireClient(player,otherPlayer.Name.." is already in a tribe",colorData.badRed)
		return
	end

	if tribeKey and tribeData.chief ~= player.Name then
		local request = rep.RelativeTime.Value
		local received = rep.Events.PromptClient:InvokeClient(game.Players:FindFirstChild(tribeData.chief),{promptType = "YesNo",message = player.Name.." wants to invite "..otherPlayer.Name.." to the tribe. Accept?"})

		if received and received.result and received.result == "yes" and rep.RelativeTime.Value-request<15 then
			received,request = nil,rep.RelativeTime.Value
		else return
		end
		local request = rep.RelativeTime.Value
		local received = rep.Events.PromptClient:InvokeClient(otherPlayer,{promptType = "YesNo",message = player.Name.." invited you to the "..tribeData.color.." tribe"})

		if received and received.result and received.result == "yes" and rep.RelativeTime.Value-request<15  and not IsInATribe(otherPlayer.Name) then
			-- otherPlayer successfully wants to join the origin tribe!
			-- notify the other members
			table.insert(tribes[tribeKey].members,otherPlayer.Name)
			ChangeBodyColor(otherPlayer,colorData.TribeColors[tribeData.color])

			local chiefPlayer = game.Players:FindFirstChild(tribes[tribeKey].chief)

			if chiefPlayer then
				rep.Events.Notify:FireClient(chiefPlayer,otherPlayer.Name.." has joined the tribe!",colorData.TribeColors[tribeData.color])
			end

			for _,memberName in next,tribes[tribeKey].members do
				local memberPlayer = game.Players:FindFirstChild(memberName) 
				if memberPlayer then
					rep.Events.Notify:FireClient(memberPlayer,otherPlayer.Name.." has joined the tribe!",colorData.TribeColors[tribeData.color])
				end
			end
			UpdatePlayerList()
			--rep.Events.Notify:FireClient(v,otherPlayer.Name.." has joined the tribe!",colorData.TribeColors[tribeData.color])
		else return
		end

	elseif tribeKey and tribeData.chief == player.Name then
		local request = rep.RelativeTime.Value
		local received = rep.Events.PromptClient:InvokeClient(otherPlayer,{["promptType"] = "YesNo",["message"] = player.Name.." invited you to the "..tribeData.color.." tribe"})
		if received and received.result and received.result == "yes" and rep.RelativeTime.Value-request<15 and not IsInATribe(otherPlayer) then
			-- otherPlayer successfully wants to join the origin tribe!
			-- notify the other members
			table.insert(tribes[tribeKey].members,otherPlayer.Name)
			ChangeBodyColor(otherPlayer,colorData.TribeColors[tribeData.color])

			for _,v in next,game.Players:GetPlayers() do
				local tribeKey1,tribeData1 = IsInATribe(v)
				if tribeKey1 and (IsMemberOfTribe(v,tribeData) or tribeData.chief == v.Name) then
					rep.Events.UpdateData:FireClient(v,_G.sessionData[v.UserId],{{"DrawTribeGui"}})
					rep.Events.Notify:FireClient(v,otherPlayer.Name.." has joined the tribe!",colorData.TribeColors[tribeData.color])
				end
			end
			UpdatePlayerList()
			--rep.Events.Notify:FireClient(v,otherPlayer.Name.." has joined the tribe!",colorData.TribeColors[tribeData.color])
		else return
		end -- end of if result and request

	end -- end of if tribekey and chief == 
end)

function PromoteToChief()
end

--local playerWhoBroke = game.Players.LocalPlayer

--local received = rep.Events.PromptClient:InvokeClient(game.Players.PlayerName,{promptType = "YesNo",message = "You have obtained the health boost spell. Are you sure you want to change your spell?"})
--if received and received.result == "yes" then
--	_G.sessionData[playerWhoBroke.UserId].spell = 'Health Boost'
--end

function NearestTotemAndDistance(player,pos)
	local ignoreTotemColor
	local tribeKey,tribeData = IsInATribe(player)
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

end

function RemovePlayerFromTribe(player)
	-- determine which tribe the player is in
	local tribeKey,tribeData = IsInATribe(player)
	if not tribeKey then return end
	ChangeBodyColor(player,colorData.basicBrown)
	-- regardless, they're leaving
	local position
	if tribeData.chief == player.Name then
		position = "chief"
	elseif IsMemberOfTribe(player,tribeData) then
		position = "member"
	end

	if position == "chief" then
--[[
if GetDictionaryLength(tribeData.members) >0 then
local m = {}
for _,v in next,tribeData.members do
m[#m+1] = v
end
local chosen = m[math.random(1,#m)]
tribes[tribeKey].chief = chosen
tribes[tribeKey].members[chosen] = nil
else
table.remove(tribes,tribeKey)
end
]]--
		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"OpenGui"},{"DrawTribeGui"}})
		-- remove the 
		local totemName = tribeData.color.." Totem"
		local totem
		for _,v in next,workspace.Totems:GetChildren() do
			if v.TribeColor.Value == tribeData.color then
				totem = v
			end
		end

		if totem then 
			totem:Destroy()
			lastTotemTimers[tribeData.color] = rep.RelativeTime.Value
		end
		ChangeBodyColor(player,colorData.basicBrown)
		for _,memberName in next,tribeData.members do -- kick all the remaining members
			local memberPlayer = game.Players:FindFirstChild(memberName)
			if memberPlayer then
				ChangeBodyColor(memberPlayer,colorData.basicBrown)
				rep.Events.UpdateData:FireClient(memberPlayer,_G.sessionData[memberPlayer.UserId],{{"OpenGui"},{"DrawTribeGui"}})
				rep.Events.Notify:FireClient(memberPlayer,"Your tribe has disbanded",colorData.badRed, 4)
			end
		end
		-- destroy the tribe, the chief left
		table.remove(tribes,tribeKey)

	elseif position == "member" then
		for key,memberName in next,tribes[tribeKey].members do
			if memberName == player.Name then
				local memberPlayer = game.Players:FindFirstChild(memberName)
				if memberPlayer then
					rep.Events.UpdateData:FireClient(memberPlayer,_G.sessionData[memberPlayer.UserId],{{"OpenGui"},{"DrawTribeGui"}})
				end -- end of if memberplayer
				table.remove(tribes[tribeKey].members,key)
				break
			end
		end

	end
	UpdatePlayerList()
end

rep.Events.TribeLeave.OnServerEvent:connect(function(player)
	if (rep.RelativeTime.Value-_G.sessionData[player.UserId].lastTribeLeave) < 2 then
		rep.Events.Notify:FireClient(player,"You must wait "..math.floor(2-(rep.RelativeTime.Value-_G.sessionData[player.UserId].lastTribeLeave)).." more seconds before leaving this tribe") 
		return
	end

	local request = rep.RelativeTime.Value
	local received = rep.Events.PromptClient:InvokeClient(player,{promptType = "YesNo",message = "Are you sure you want to leave your Tribe?"})
	if received.result == "yes" and rep.RelativeTime.Value-request<15 then
		_G.sessionData[player.UserId].lastTribeLeave = rep.RelativeTime.Value
		RemovePlayerFromTribe(player)
	end
end)

--function rep.Events.RelayChestContents(player,chest)
--if _G.worldStructures[chest] then
--return _G.worldStructures[chest].contents
--end
--end


--DevVince was here, added a cooldown to stop exploits.
Cooldown_Stru = {}

local debounce = false
rep.Events.InteractStructure.OnServerEvent:connect(function(player,structure,itemName)
	if not debounce then
		debounce = true
		delay(.04, function() debounce = false end)
		if structure.Name == "Plant Box" then--DevVince was here.
			local found
			for i,v in pairs(Cooldown_Stru) do
				if i == player then
					found = true
					local elapsed = os.time()-v
					if elapsed < .5 then
						return
					else
						i = nil
					end
				elseif os.time()-v < .5 then
					i = nil
				end
			end
			if not found then
				Cooldown_Stru[player] = os.time()
			end
		end

		if structure.Name == "Campfire" then
			local hasKey = HasItem(player,itemName)
			if hasKey then
				_G.sessionData[player.UserId].inventory[hasKey].quantity = _G.sessionData[player.UserId].inventory[hasKey].quantity-1
				CleanInventory(player)
				if itemData[itemName].fuels then
					_G.worldStructures[structure].specificData.fuel = math.clamp(_G.worldStructures[structure].specificData.fuel+itemData[itemName].fuels,0,itemData[_G.worldStructures[structure].name].capacity)
					structure.Board.Billboard.Backdrop.TextLabel.Text = math.floor(_G.worldStructures[structure].specificData.fuel+.5)
					structure.Board.Billboard.Backdrop.Slider.Size = UDim2.new(_G.worldStructures[structure].specificData.fuel/itemData[structure.Name].capacity,0,1,0)
					structure.Board.Billboard.Backdrop.Slider.BackgroundColor3 = Color3.fromRGB(255,0,0):lerp(Color3.fromRGB(170, 255, 0),_G.worldStructures[structure].specificData.fuel/100)

				end -- end of if the item is fuels
			end -- end of haskey


		elseif structure.Name == "Plant Box" then -- $ushi was here added a check distance lol
			if _G.worldStructures[structure].specificData.growing then return end
			local dist = (player.Character.Head.Position - structure.PrimaryPart.Position).magnitude
			if dist <= 15 then -- distance for how far away you can be to interact with structure.
				local hasKey = HasItem(player,itemName)
				if hasKey then
					_G.sessionData[player.UserId].inventory[hasKey].quantity = _G.sessionData[player.UserId].inventory[hasKey].quantity-1
					CleanInventory(player)
					if itemData[itemName].grows then
						_G.worldStructures[structure].lastCheck = rep.RelativeTime.Value
						local seed = ss.Items:FindFirstChild(itemName)
						local seedClone
						if seed:IsA("BasePart") then
							seedClone = seed:Clone()
						elseif seed:IsA("Model") then
							seedClone = Instance.new("Part")
							seedClone.Size = Vector3.new(1.8,1.8,1.8)
							seedClone.Material = seed.PrimaryPart.Material
							seedClone.Color = seed.PrimaryPart.Color
							seedClone.Name = seed.Name
						end
						seedClone.Anchored = true
						seedClone.CanCollide = false
						seedClone:ClearAllChildren()
						seedClone.CFrame= structure.Compost.CFrame*CFrame.new(0,structure.Compost.Size.Y/2,0)
						seedClone.Parent = structure
						PlaySoundInObject(ss.Sounds.Quicks.Plant,seedClone)
						_G.worldStructures[structure].specificData.growing = seedClone

						rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"DrawInventory"},{"UpdateCraftMenu"},{"UpdateBillboards",{"clear"}}})
						--softupdate craftmenu
						return 
					end
				end
			end


		elseif structure.Name == "Grinder" then
			local hasKey = HasItem(player,itemName)
			if hasKey then
				if itemData[itemName].grindsTo then
					_G.sessionData[player.UserId].inventory[hasKey].quantity = _G.sessionData[player.UserId].inventory[hasKey].quantity-1
					CleanInventory(player)

					DropItem({
						["player"] = player,
						["itemName"] = itemData[itemName].grindsTo,
						["cf"] = structure.PrimaryPart.CFrame*CFrame.new(0,4,0),
						["gc"] = rep.RelativeTime.Value+600,
					})

					PlaySoundInObject(ss.Sounds.Quicks.StoneImpact,structure.PrimaryPart)
				end
			end

		elseif structure.Name == "Coin Press" then
			if itemName == "Gold Bar" then
				local hasKey = HasItem(player,itemName)
				if hasKey then
					-- has the gold bar
					_G.sessionData[player.UserId].inventory[hasKey].quantity = _G.sessionData[player.UserId].inventory[hasKey].quantity-1
					CleanInventory(player)
					for i = 1,5 do
						DropItem({
							["player"] = player,
							["itemName"] = "Coin",
							["cf"] = structure:FindFirstChild("CoinPart").CFrame,
							["gc"] = rep.RelativeTime.Value+600,
						})
					end
				end -- end of for loop
			end


		elseif structure.Name == "Gem Press" then
			if itemName == "Gem" then
				local hasKey = HasItem(player,itemName)
				if hasKey then
					-- has the gold bar
					_G.sessionData[player.UserId].inventory[hasKey].quantity = _G.sessionData[player.UserId].inventory[hasKey].quantity-1
					CleanInventory(player)
					for i = 1,5 do
						DropItem({
							["player"] = player,
							["itemName"] = "GemCoin",
							["cf"] = structure:FindFirstChild("CoinPart").CFrame,
							["gc"] = rep.RelativeTime.Value+600,
						})
					end
				end -- end of for loop
			end


			--elseif structure.Name == "Chest" then
			--local chestHas
			--for k,v in next,_G.worldStructures[structure].contents do
			--if v.name == itemName then
			--_G.worldStructures[structure].contents[k].quantity = 
			--local newItem = game.ReplicatedStorage.Items:FindFirstChild(itemName):Clone()
			--newItem.CFrame = structure.PrimaryPart.CFrame*CFrame.new(5,3,4)
			--newItem.Parent = workspace
			--end
			--end

			--elseif structure.Name == "Nest" then
			--local hasKey = HasItem(player,itemName)
			--if hasKey then
			--if itemName == "Egg" then
			--if not _G.worldStructures[structure].specificData.hasBaby then
			--_G.sessionData[player.UserId].inventory[hasKey].quantity =_G.sessionData[player.UserId].inventory[hasKey].quantity-1
			--_G.worldStructures[structure].specificData.hasBaby = true
			--structure.GrowEgg.Transparency = 0
			--CleanInventory(player)
			--end
			--end
			--end


		end -- end of if campfire
		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"DrawInventory"},{"UpdateCraftMenu"}})
		--softupdate

	end
end) 



-- SOME COROUTINES

-- clean tribes
local cleanTribes = coroutine.wrap(function()
	while wait(30) do
		for tribeKey,tribeData in next,tribes do

			for memberKey,memberName in next,tribeData.members do
				if not game.Players:FindFirstChild(memberName) then
					table.remove(tribes[tribeKey].members,memberKey)
				end
			end

			if not game.Players:FindFirstChild(tribeData.chief) then
				table.remove(tribes,tribeKey)
			end

		end
	end
end)
cleanTribes()

lastHungerNotify = {}
-- STAT DEGREDATION
local validVoodooItems = {
	["Void Chestplate"] = .2,
	["Void Bag"] = .2,
	["Void Greaves"] = .2,
	["Void Shroud"] = .2,
	["Shelly Bag"] = .1,
	["Night Bag"] = 100,
	["GodNation"] = 1.5
}

-- STAT DEGREDATION
local validVoodooItems = {
	["Void Chestplate"] = .2,
	["Void Bag"] = .2,
	["Void Greaves"] = .2,
	["Void Shroud"] = .2,
	["Shelly Bag"] = .1,
	["Night Bag"] = 100,
	["GodNation"] = 1.5,
}

local degradeStats = coroutine.wrap(function()
	while wait(1) do

		local success,message = pcall(function()
			for _,player in next,game.Players:GetPlayers() do
				local data = _G.sessionData[player.UserId]

				if data then

					local survivalistHealthGain = 0
					local survivalistDegradation = nil
					if HasMojoRecipe(player,"Survivalist") then
						survivalistHealthGain = 1
						survivalistDegradation = 1/20
					end

					_G.sessionData[player.UserId].stats.food = math.clamp(_G.sessionData[player.UserId].stats.food-(survivalistDegradation or 1/10),0,100)
					--_G.sessionData[player.UserId].stats.water= math.clamp(data.stats.water-(1/10),0,100)
					local last  = lastHungerNotify[player.UserId] or 0

					if data.stats.food <= 25 and (rep.RelativeTime.Value-last) >= 60  then
						lastHungerNotify[player.UserId] = rep.RelativeTime.Value
						rep.Events.Notify:FireClient(player,"You are starving!",colorData.badRed,3)
					end

					--if data.stats.food >= 50 then
					--player.Character.Humanoid.Health = math.clamp(player.Character.Humanoid.Health+(1/4),0,player.Character.Humanoid.MaxHealth)
					--end

					-- restore void energy
					local totalVoodooRestored = 0
					local worldVoodooMultiplier = 2
					for locus,armorName in next,_G.sessionData[player.UserId].armor do
						if armorName and armorName ~= "none" then
							local voidClass = validVoodooItems[armorName]
							if voidClass then
								totalVoodooRestored = totalVoodooRestored+voidClass
							end
						end
					end

					totalVoodooRestored = totalVoodooRestored*worldVoodooMultiplier
					if data.voodoo then
						data.voodoo = math.clamp(data.voodoo+totalVoodooRestored,0,100)
					end

					if player.Character.Humanoid.Health <= 100 then
						for locus,armorName in next,data.armor do
							if armorName and armorName ~= "none" and armorName == "OG Halo" or armorName == "OG Chestplate" or armorName == "OG Legs" then
								if player and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:IsDescendantOf(workspace) then
									player.Character.Humanoid.Health = math.clamp(player.Character.Humanoid.Health+(1/2)+2,0,player.Character.Humanoid.MaxHealth)
								end
							end
						end
					end



					if player.Character.Humanoid.Health <= 100 then
						for locus,armorName in next,data.armor do
							if armorName and armorName ~= "none" and armorName == "red wings" then
								if player and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:IsDescendantOf(workspace) then
									player.Character.Humanoid.Health = math.clamp(player.Character.Humanoid.Health+(1/2)+20,5,player.Character.Humanoid.MaxHealth)
								end
							end
						end
					end

					if data.stats.food >=50 then
						if player and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:IsDescendantOf(workspace) then

							player.Character.Humanoid.Health = math.clamp(player.Character.Humanoid.Health+(1/2)+survivalistHealthGain,0,player.Character.Humanoid.MaxHealth)
						end
					end

					if (data.stats.food <=0 or data.stats.water <=0) then
						if player.Character then
							local hum = player.Character:FindFirstChild("Humanoid")
							if hum then
								hum:TakeDamage(1)
							end
						end
					end

					rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateStats"}})
				end
			end
		end) -- end of pcall
	end

end)

degradeStats()


-- STRUCTURE MANIPULATION
local structureAffection = coroutine.wrap(function()
	local timeScale = 1/15
	while true do
		run.Heartbeat:wait()
		for structure,structureData in next,_G.worldStructures do

			if structureData.name == "Campfire" then
				local fueled
				fueled = structureData.specificData.fuel >0

				_G.worldStructures[structure].specificData.fuel = math.clamp(structureData.specificData.fuel-((rep.RelativeTime.Value-structureData.lastCheck)/2),0,itemData[structure.Name].capacity)-- decrease in increments of .5
				-- make sure the effects are
				local r = 10
				local scanRegion = Region3.new(
					structure.PrimaryPart.Position+Vector3.new(-r,-4,-r),
					structure.PrimaryPart.Position+Vector3.new(r,r,r)
				)


				local partsInRegion = workspace:FindPartsInRegion3(scanRegion,structure,150)
				--print("region is",scanRegion.Size,"at",scanRegion.CFrame,"... origin of flame is",structure.PrimaryPart.Position)

				for _,v in next,partsInRegion do
--[[
if itemData[v.Name] and itemData[v.Name].fuels then
_G.worldStructures[structure].specificData.fuel = math.clamp(_G.worldStructures[structure].specificData.fuel+itemData[v.Name].fuels,0,itemData[structure.Name].capacity)
v:Destroy()
end
]]--
					if fueled then
						if itemData[v.Name] and itemData[v.Name].cooksTo then
							if v:FindFirstChild("CookingSuite") then
								v.CookingSuite.Progress.Value = v.CookingSuite.Progress.Value+(rep.RelativeTime.Value-_G.worldStructures[structure].lastCheck)
								v.CookingSuite.ProgressGui.Frame.Slider.Size = UDim2.new(v.CookingSuite.Progress.Value/itemData[v.Name].cooksTo.steps,0,1,0)
								if v.CookingSuite.Progress.Value >= itemData[v.Name].cooksTo.steps then
									local oldCF = v.CFrame

									DropItem({
										["player"] = structureData.owner,
										["itemName"] = itemData[v.Name].cooksTo.name,
										["cf"] = CFrame.new(oldCF.p+Vector3.new(0,2,0)),
										["gc"] = rep.RelativeTime.Value+600,
									})
									v:Destroy()
								end

							else -- if no cookProportion
								--AddValueObject(v,"CookProportion","NumberValue",timeScale)
								local suite = rep.Guis.CookingSuite:Clone()
								suite.ProgressGui.Adornee = v
								suite.Parent = v
								suite.ProgressGui.Frame.BackgroundColor3 = v.BrickColor.Color or v.PrimaryPart.BrickColor.Color
								--suite.Progress.Value = v.Progress.Value+timeScale
							end
						end
					end
				end

				if fueled then
					for _,v in next,structure:GetDescendants() do
						if v.Name == "Effect" then
							for _,effect in next,v:GetChildren() do
								effect.Enabled = true
							end
						end
					end
					if not structure.Reference.Campfire.IsPlaying then
						structure.Reference.Campfire:Play()
					end

				else
					for _,v in next,structure:GetDescendants() do
						if v.Name == "Effect" then
							for _,effect in next,v:GetChildren() do
								effect.Enabled = false
							end
						end
					end
					structure.Reference.Campfire:Stop()
				end
				_G.worldStructures[structure].lastCheck = rep.RelativeTime.Value
				structure.Board.Billboard.Backdrop.TextLabel.Text = math.floor(_G.worldStructures[structure].specificData.fuel+.5)
				structure.Board.Billboard.Backdrop.Slider.Size = UDim2.new(_G.worldStructures[structure].specificData.fuel/itemData[structure.Name].capacity,0,1,0)
				structure.Board.Billboard.Backdrop.Slider.BackgroundColor3 = Color3.fromRGB(255,0,0):lerp(Color3.fromRGB(170, 255, 0),_G.worldStructures[structure].specificData.fuel/100)
				--print(_G.worldStructures[structure].specificData.fuel/100)
				-- campfire process
				run.Heartbeat:wait()

			elseif structureData.name == "Plant Box" then
				-- farm process
				if structureData.specificData.growing then
					_G.worldStructures[structure].specificData.progress = structureData.specificData.progress+(rep.RelativeTime.Value-structureData.lastCheck)
					_G.worldStructures[structure].lastCheck = rep.RelativeTime.Value
					if _G.worldStructures[structure].specificData.progress >= itemData[structureData.specificData.growing.Name].growthTime then
						local plant = ss.Growths:FindFirstChild(itemData[structureData.specificData.growing.Name].grows):Clone()
						local seed = structure:FindFirstChild(structureData.specificData.growing.Name)
						plant:SetPrimaryPartCFrame(seed.CFrame)
						seed:Destroy()
						if plant:FindFirstChild("Health") then plant.Health:Destroy() end
--[[
for _,v in next,plant:GetChildren() do
if not v:FindFirstChild("Pickup") then
AddValueObject(v,"Pickup","BoolValue",true)
end
end
]]--l

						plant.Parent = workspace
						_G.worldStructures[structure].specificData.growing = nil
						_G.worldStructures[structure].specificData.progress = 0
					end
				end

			elseif structureData.name == "Nest" then
				if structureData.specificData.hasBaby or structureData.specificData.hasHen then
					_G.worldStructures[structure].specificData.progress = structureData.specificData.progress+(rep.RelativeTime.Value-structureData.lastCheck)
					_G.worldStructures[structure].lastCheck = rep.RelativeTime.Value
					if _G.worldStructures[structure].specificData.progress >= itemData[structureData.name].growthTime then
						if structureData.specificData.hasBaby and not structureData.specificData.hasHen then
							_G.worldStructures[structure].specificData.hasHen = true
							for _,v in next,structure.Peeper:GetChildren() do
								v.Transparency = 0
							end
							structure.GrowEgg.Transparency = 1

						elseif structureData.specificData.hasHen and not structureData.specificData.hasEgg then
							_G.worldStructures[structure].specificData.hasEgg = true
							local newEgg = ss.Items.Egg:Clone()
							newEgg.CFrame = structure.EggSlot.CFrame
							newEgg.Anchored = true
							newEgg.CanCollide = false
							newEgg.Draggable:Destroy()
							newEgg.Parent = structure.Contents
							newEgg.AncestryChanged:connect(function()
								if structure and _G.worldStructures[structure] then
									_G.worldStructures[structure].specificData.hasEgg = false
								end
							end)
						end
						_G.worldStructures[structure].specificData.progress = 0
					end
				end

			elseif structureData.name == "Fish Trap" then
				if not structureData.specificData.hasFish then
					_G.worldStructures[structure].specificData.progress = structureData.specificData.progress+(rep.RelativeTime.Value-structureData.lastCheck)
					_G.worldStructures[structure].lastCheck = rep.RelativeTime.Value
					if (_G.worldStructures[structure].specificData.progress >= itemData[structureData.name].growthTime) then
						_G.worldStructures[structure].specificData.hasFish = true
						local newFish = ss.Items["Raw Fish"]:Clone()
						newFish.CFrame = structure.FishSlot.CFrame
						newFish.Anchored = true
						newFish.CanCollide = false
						newFish.Draggable:Destroy()
						newFish.Parent = structure.Contents

						newFish.AncestryChanged:connect(function()
							if structure and _G.worldStructures[structure] then
								_G.worldStructures[structure].specificData.hasFish = false
								_G.worldStructures[structure].specificData.progress = 0
								_G.worldStructures[structure].lastCheck = rep.RelativeTime.Value
							end
						end)
					end

				end


			elseif structureData.name == "Quarry" then
				-- default quarry process
			elseif structureData.custom then
				-- if this is a custom structure
				if structureData.custom.CampfireMechanic then
					-- do campfire thing
				end
				if structureData.custom.QuarryMechanic then
					-- do quarry thing
				end
				if structureData.custom.FishingMechanic then
					-- do fishing thing
				end
				if structureData.custom.SmeltMechanic then
					-- do smeltery thing
				end

			end -- end of elseifs

		end -- end of iteration through structures
	end -- end of wtd
end)
structureAffection()


-- WORLD REGEN STUFF
function RegenRecurse(object)
	if object:FindFirstChild("NoRegen") then return end
	local oldParent = object.Parent
	local clone = object:Clone()
	object.AncestryChanged:connect(function()
		wait(itemData[object.Name].regenDuration)
		if object then
			object:Destroy()
		end
		clone.Parent = oldParent
		RegenRecurse(clone)
	end)
end

local regenThings = AppendTables({workspace:GetChildren(),workspace.Critters:GetChildren()})
for _,v in next,regenThings do
	if itemData[v.Name] and itemData[v.Name].regenDuration then
		RegenRecurse(v)
	end
end

rep.Events.SpawnFirst.OnServerEvent:connect(function(player)
--[[if player.UserId == nil then
	player:Kick("There was an error whilst trying to load your data, please try rejoining.")
	return
elseif _G.sessionData[player.UserId] == nil then
	player:Kick("There was an error whilst trying to load your data, please try rejoining.")
	return
end]]
	if not _G.sessionData[player.UserId].hasSpawned then
		_G.sessionData[player.UserId].hasSpawned = true


		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId])
		player.Character:Destroy()
		wait(1/10)
		SpawnCharacter(player)
	end
end)

--rep.Events.AppearanceChange.OnServerEvent:connect(function(player,locus,value)
--if not player.Character then return end
--local itemKey,itemInfo = itemData[value]
--if itemInfo then
--
---- if it's a free thing, we don't care if they own it
--if (not cosmeticData.price) or _G.sessionData[player.UserId].ownedCosmetics[value] then
---- wear it
--_G.sessionData[player.UserId].appearance[locus] = value
--SetupAppearance(player)
--else
---- tell them no
--end
--
--end -- end of if iteminfo
--
--end)

rep.Events.UnequipArmor.OnServerEvent:connect(function(player,armorName)
	if _G.sessionData[player.UserId].armor[itemData[armorName].locus] then

		local otherArmorKey = HasItem(player,_G.sessionData[player.UserId].armor[itemData[armorName].locus])
		if otherArmorKey then
			_G.sessionData[player.UserId].inventory[otherArmorKey].quantity = _G.sessionData[player.UserId].inventory[otherArmorKey].quantity + 1
		else
			_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {name = _G.sessionData[player.UserId].armor[itemData[armorName].locus],quantity = 1}
		end

		_G.sessionData[player.UserId].armor[itemData[armorName].locus] = "none"
		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"DrawInventory"},{"UpdateArmor"}})
		SetupAppearance(player)
	end
end)

-- shutdown script removed by pie to prevent exploiters shutting down 10/5
--shutdownBreakCode = 0
--local shutdownCoroutine = coroutine.create(function()
--	for seconds = rep.Constants.ShutdownTime.Value,0,-1 do
--		wait(1)
--		if shutdownBreakCode ~= shutdownBreakCode then
--			break
--		end
--		if ((seconds%60 == 0) or (seconds <=60 and seconds%10 == 0)) and seconds > 0 then
--		local hours = string.format("%02.f", math.floor(seconds/3600))
--		local mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)))
--		local secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60))
--		local timeString = mins.."m "..secs.."s"
--			rep.Events.Toast:FireAllClients(
--				{
--				color = colorData.badRed,
--				image = "",
--				title = "SERVER SHUTDOWN",
--				message = "Server shutdown for maintenance in "..timeString.."."
--				}
--			)
--		end
--	end
--		
--	for _,player in next,game.Players:GetPlayers() do
--		player:Kick("This server has shutdown")
--	end
--end)

--rep.Events.Shutdown.Event:connect(function(shutdown)
--	if shutdown then
--		-- tell everyone the server is shutting down
--		rep.Events.Toast:FireAllClients({duration = 20, color = colorData.badRed,image = "",title = "NOTICE!", message = "ALL SERVERS will shut down for maintenance in 05m 00s"})
--		coroutine.resume(shutdownCoroutine)
--	else
--		shutdownBreakCode = shutdownBreakCode+1
--		rep.Events.Toast:FireAllClients ({color = colorData.goodGreen,image = "",title = "NEVERMIND", message = "Server shutdown has been canceled. All clear."})
--		coroutine.yield(shutdownCoroutine)
--	end
--end)

function rep.Events.RequestPlayerList.OnServerInvoke(player)
	return playerListInfo,tribes
end

rep.Events.TribeKick.OnServerEvent:connect(function(player,otherPlayer)
	if player and otherPlayer then
		local tribeKey,tribeData = IsInATribe(player)
		if tribeKey then
			if tribeData.chief == player.Name then

				-- determine if the other player is in the same tribe
				local otherTribeKey,otherTribeInfo = IsInATribe(otherPlayer)
				if otherTribeKey and otherTribeKey == tribeKey then
					RemovePlayerFromTribe(otherPlayer)
				end
			end

		end
	end
end)

rep.Events.ToggleDoor.OnServerEvent:connect(function(player,gate)
	local gateInfo = _G.worldStructures[gate]
	if gateInfo then
		-- is the player allowed to open the gate?
		local canOpen = false

		if gateInfo.owner == player then
			canOpen = true
		else
			local tribeKey,tribeData = IsInATribe(player)
			local gateTribeKey,gateTribeData = IsInATribe(gateInfo.owner)
			if (tribeKey and gateTribeKey) and tribeKey == gateTribeKey then
				canOpen = true
			end
		end

		if canOpen then
			local status
			if gate.Door.CanCollide then
				status = "closed"
			else
				status = "open"
			end

			if status == "open" then
				gate.Door.CanCollide = true
				gate.Door.Transparency = 0
				gate.Button.Color = colorData.fadedGoodGreen
			elseif status == "closed" then
				gate.Door.CanCollide = false
				gate.Door.Transparency = 1
				gate.Button.Color = colorData.fadedBadRed
			end
			if gate.Door:FindFirstChild("Offset") then
				gate.Door.CFrame = gate.Door.CFrame*CFrame.new(gate.Door.Offset.Value)
				gate.Door.Offset.Value = -gate.Door.Offset.Value
			end

		else -- if not canopen
			rep.Events.Notify:FireClient(player,"NO ACCESS",colorData.grey200)
		end

	end
end)


rep.Events.RedoAvatar.OnServerEvent:connect(function(player)
	local request = rep.RelativeTime.Value
	local received = rep.Events.PromptClient:InvokeClient(player,{promptType = "YesNo",message = "Respawn to edit character? This will OOF you!"})
	if received.result == "yes" and rep.RelativeTime.Value-request<15 then
		_G.sessionData[player.UserId].hasSpawned = false

		_G.sessionData[player.UserId].appearance.hat = "none"
		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId])
		player.Character.Humanoid.Health = 0
		--SpawnCharacter(player)
	end
end)

function SpawnChest(chestName,locationCF,extraContents)
	-- determine what will be in the new chest
	local newChest = ss.Chests:FindFirstChild(chestName):Clone()
	if extraContents then
		for _,itemName in next,extraContents do
			local newItem = ss.Items:FindFirstChild(itemName):Clone()
			for _,v in next,newItem:GetChildren() do
				if v.Name == "Pickup" or v.Name == "Draggable" then
					v:Destroy()
				end
			end

			if newItem:IsA("BasePart") then
				newItem.Anchored = true
				newItem.CanCollide = false
				newItem.CFrame = newChest.PrimaryPart.CFrame*CFrame.new(0,2.5,0)
			elseif newItem:IsA("Model") then
				for _,v in next,newItem:GetChildren() do
					v.Anchored = true
					v.CanCollide = false
				end
				newItem:SetPrimaryPartCFrame(newChest.PrimaryPart.CFrame*CFrame.new(0,2.5,0))
			end

			newItem.Parent = newChest.Contents
		end
	end

	local possibleDrops = itemData[chestName]["possibleDrops"]
	newChest:SetPrimaryPartCFrame(locationCF*CFrame.new(0,200,0))
	newChest.Parent = workspace
	-- tween the chest to its proper location after parenting it
	local newTweenInfo = TweenInfo.new(3,Enum.EasingStyle.Quad,Enum.EasingDirection.In,0,false,0)

	local CFrameValue = Instance.new("CFrameValue")
	CFrameValue.Value = newChest:GetPrimaryPartCFrame()

	CFrameValue:GetPropertyChangedSignal("Value"):connect(function()
		newChest:SetPrimaryPartCFrame(CFrameValue.Value)
	end)

	local tween = tweenService:Create(CFrameValue, newTweenInfo, {Value = newChest.PrimaryPart.CFrame*CFrame.new(0,-200,0)})
	-- play the falling sound in the object
	PlaySoundInObject(ss.Sounds.Quicks.Falling,newChest.PrimaryPart)
	tween:Play()

	tween.Completed:connect(function()
		CFrameValue:Destroy()
		PlaySoundInObject(ss.Sounds.Quicks.ChestImpact,newChest.PrimaryPart)
		if newChest.PrimaryPart:FindFirstChild("Falling") then
			newChest.PrimaryPart.Falling:Destroy()
		end
		-- play the impact sound in the object
	end)
end -- end of spawncrate


rep.Events.ChangeFood.OnServerEvent:Connect(function(p, chosenVal)
	p.Character.HumanoidRootPart.FoodGui.ImageLabel.Image = chosenVal
end)
----pie was shere
rep.Events.PromptSpellChoice.OnServerEvent:Connect(function(p, chosenVal)
	--print ("voodoo spell chosen", p, chosenVal)
	_G.sessionData[p.UserId].spell = chosenVal
	_G.sessionData[p.UserId].hasChosenSpell = true

end)

--DevVince was here, changed how it checks.
rep.Events.ChestDrop.OnServerEvent:connect(function(p, chestName)
	if p and p.Character and p.Character.PrimaryPart then else return end
	local item = HasItem(p, chestName)

	if item then
		if itemData[chestName].mojoRecipe then--Kick the exploiter. :o
			if not HasMojoRecipe(p, chestName) then
				p:Kick'Nice exploit'
				return
			end
		end
		_G.sessionData[p.UserId].inventory[item].quantity = _G.sessionData[p.UserId].inventory[item].quantity -1
		CleanInventory(p)
		rep.Events.UpdateData:FireClient(p, _G.sessionData[p.UserId],{{"DrawInventory"}})

		local part,pos,norm,mat = RayUntil((p.Character.PrimaryPart.CFrame*CFrame.new(0,0,-3)).p,Vector3.new(0,-10,0))
		local toFace = CFrame.new(pos,Vector3.new(p.Character.PrimaryPart.CFrame.X,pos.Y,p.Character.PrimaryPart.CFrame.Z))
		SpawnChest(chestName, toFace)
		--else
		--Prompt them to buy more chests of that type
		--rep.Events.Notify:FireClient(p, "You're out of "..chestName.." buy more.",colorData.fadedBadRed, 2)
	end
end)


rep.Events.CosmeticChange.OnServerEvent:connect(function(player,change,val)

	local good = false
	--print("change",change,"val",val)
	if not cosmeticData[change][val].locked then
		good = true
	end

	if cosmeticData[change][val].locked and _G.sessionData[player.UserId].advancedCosmetics then
		good = true
	end

	if good then
		if change == "skin" then
			_G.sessionData[player.UserId].appearance.skin = val
		elseif change == "gender" then
			_G.sessionData[player.UserId].appearance.gender = val
		elseif change == "face" then
			_G.sessionData[player.UserId].appearance.face = val
		elseif change == "hair" then
			_G.sessionData[player.UserId].appearance.hair = val
		end
		SetupAppearance(player)
	end
end)

local debounce = false
rep.Events.EquipCosmetic.OnServerEvent:connect(function(player,itemName) 
	if not debounce then
		debounce = true
		delay(1, function() debounce = false end)
		--rep.Events.Notify:FireClient(player,"Cosmetic Rate Limited",Color3.fromRGB(222, 147, 223),4)
		if _G.sessionData[player.UserId].ownedCosmetics[itemName] then
			local oldVal = _G.sessionData[player.UserId].appearance.hat
			if oldVal == itemName then
				_G.sessionData[player.UserId].appearance.hat = "none"
			else
				_G.sessionData[player.UserId].appearance.hat = itemName
			end
			SetupAppearance(player)
		end
	end
end)

rep.Events.PurchaseCosmetic.OnServerEvent:connect(function(player,itemName)	
	local price = itemData[itemName].cost
	local eventItem = itemData[itemName].eventItem
	local args = string.split(" ")
	if price then
		if itemName == 'Fly Cap' then
			--market:PromptGamePassPurchase(player, 15952599)
			print("not for sale")
		elseif itemName == 'Overseer' then
			--	market:PromptGamePassPurchase(player, 15952619)
			print("not for sale")
		elseif itemName == 'Void Star' then
		--	market:PromptGamePassPurchase(player, 15952625)
			print("not for sale")
		elseif itemName == 'Black Iron Commando' then
			--	market:PromptGamePassPurchase(player, 15952608)
			print("not for sale")
		elseif itemName == 'Black Iron Horns' then
		--	market:PromptGamePassPurchase(player, 15952613)
			print("not for sale")
		else
			local hasCoins = _G.sessionData[player.UserId].coins
			if hasCoins >= price and not _G.sessionData[player.UserId].ownedCosmetics[itemName] then
				_G.sessionData[player.UserId].coins = _G.sessionData[player.UserId].coins-price
				-- let's give them the item
				_G.sessionData[player.UserId].ownedCosmetics[itemName] = true
				rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateCosmetics"},{"UpdateStats"}})
				rep.Events.Notify:FireClient(player,"Unlocked "..itemName.."!",colorData.essenceYellow,4)
			else 
				rep.Events.Notify:FireClient(player,"Not enough coins",colorData.badRed,2)
				-- tell them they can't afford that item
			end
		end
	else
		if itemData[itemName].eventCost ~= nil then -- why would you do this in the first place? 0_0
			rep.Events.Notify:FireClient(player,"This item is not for sale",colorData.badRed,2)
		end
	end
end)

--rep.Events.PurchaseGemCosmetic.OnServerEvent:connect(function(player,itemName)	

--local price = itemData[itemName].cost
--local args = string.split(" ")
--if price then
--local hasGems = _G.sessionData[player.UserId].gems
--        if hasGems >= price and not _G.sessionData[player.UserId].ownedCosmetics[itemName] then
--_G.sessionData[player.UserId].gems = _G.sessionData[player.UserId].gems-price
---- let's give them the item
--_G.sessionData[player.UserId].ownedCosmetics[itemName] = true
--rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateCosmetics"},{"UpdateStats"}})
--rep.Events.Notify:FireClient(player,"Unlocked "..itemName.."!",colorData.essenceYellow,4)
--else 
--rep.Events.Notify:FireClient(player,"Not enough gems",colorData.badRed,2)
---- tell them they can't afford that item
--end
--else
--if itemData[itemName].eventCost ~= nil then -- why would you do this in the first place? 0_0
--rep.Events.Notify:FireClient(player,"This item is not for sale",colorData.badRed,2)
--end
--end
--end)

rep.Events.PurchaseGemCosmetic.OnServerEvent:connect(function(player,itemName)
	local price = itemData[itemName].cost
	if price then
		local hasGems = _G.sessionData[player.UserId].gems
		if hasGems >= price and not _G.sessionData[player.UserId].ownedCosmetics[itemName] then
			_G.sessionData[player.UserId].gems = _G.sessionData[player.UserId].gems-price
			-- let's give them the item
			_G.sessionData[player.UserId].ownedCosmetics[itemName] = true
			rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateCosmetics"},{"UpdateStats"}})
			rep.Events.Notify:FireClient(player,"Unlocked "..itemName.."!",colorData.essenceYellow,4)
		else
			rep.Events.Notify:FireClient(player,"Not enough gems",colorData.badRed,2)
			-- tell them they can't afford that item
		end
	else
		rep.Events.Notify:FireClient(player,"This item is not for sale",colorData.badRed,2)
	end
end)

rep.Events.PurchaseChest.OnServerEvent:connect(function(player,itemName)
	local price = itemData[itemName].cost
	local hasCoins = _G.sessionData[player.UserId].coins
	if hasCoins >= price then
		_G.sessionData[player.UserId].coins = _G.sessionData[player.UserId].coins-price
		GiveItemToPlayer(itemName,player,1)
		rep.Events.Notify:FireClient(player,"Received a "..itemName.."!",colorData.essenceYellow,4)
	end
end)

--[[rep.Events.PurchaseGemChest.OnServerEvent:connect(function(player,itemName)
	local price = itemData[itemName].cost
	local hasCoins = _G.sessionData[player.UserId].gems
	if hasCoins >= price then
		_G.sessionData[player.UserId].gems = _G.sessionData[player.UserId].gems-price
		GiveItemToPlayer(itemName,player,1)
		rep.Events.Notify:FireClient(player,"Received a "..itemName.."!",colorData.essenceYellow,4)
	end
end)]]



-------------- MARKET STUFF

--DevVince was here.
rep.Events.SubmitTrade.OnServerEvent:connect(function(player, giveNameSent, giveQuantitySentRaw, getCoinsSentRaw)
	if not giveNameSent then return end

	if itemData[giveNameSent].mojoRecipe then
		rep.Events.Notify:FireClient(player, "Can't trade Mojo items!")
		return
	end

	local giveQuantitySent,getCoinsSent = math.floor(giveQuantitySentRaw), math.floor(getCoinsSentRaw)

	local maxCostPerItem = 10000
	if getCoinsSent > giveQuantitySent*maxCostPerItem then
		rep.Events.Notify:FireClient(player, 'Price too high, 10,000 coins max per item.', colorData.badRed,3)
		return
	end

	-- see how many trades they have pending
	local totalPending = 0
	for _,tradeData in next, _G.trades do
		if tradeData.trader == player.Name then
			totalPending= totalPending+1
		end
	end

	if totalPending >= math.huge then
		rep.Events.Notify:FireClient(player, "Max 5 outbound trades!",colorData.badRed,3)
		return
	end

	local hasKey = HasItem(player, giveNameSent)

	if hasKey then
		local hasQuantity = _G.sessionData[player.UserId].inventory[hasKey].quantity
		if hasQuantity >= giveQuantitySent and giveQuantitySent >= 1 and getCoinsSent >= 1 then

			_G.sessionData[player.UserId].inventory[hasKey].quantity = hasQuantity-giveQuantitySent

			local tradeInfo = {
				trader = player.Name,
				giveName =  giveNameSent,
				giveQuantity = giveQuantitySent,
				getCoins = getCoinsSent,
				bought = false,
			}

			_G.trades[player.UserId..'_'..os.time()] = tradeInfo

			rep.Events.UpdateTradeData:FireAllClients(_G.trades)
		else
			rep.Events.Notify:FireClient(player, 'Not enough items.',colorData.badRed,3)
			return
		end
	end

	CleanInventory(player)
	rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"DrawInventory"}})
end)


function CanBearLoadArray(p, items)
	local playerLoad, data, maxLoad = 0, _G.sessionData[p.UserId]

	if data.armor.bag and data.armor.bag ~= 'none' then
		maxLoad = itemData[data.armor.bag].maxLoad
	else
		maxLoad = 50
	end

	for _,v in next, data.inventory do
		if v.quantity and itemData[v.name] and itemData[v.name].load then
			playerLoad = playerLoad+(v.quantity*itemData[v.name].load)
		end
	end

	local anticipatedLoad = 0
	for i,v in pairs(items) do
		anticipatedLoad = anticipatedLoad + (itemData[v[1]].load*v[2])
	end

	return ((playerLoad+anticipatedLoad) <= maxLoad or anticipatedLoad == 0) 
end


rep.Events.AcceptTrade.OnServerEvent:connect(function(player, tradeKey)
	local tradeData = _G.trades[tradeKey]

	if not tradeData or not tradeData.trader then 
		rep.Events.Notify:FireClient(player,'Invalid trade.', colorData.badRed, 3)
		return 
	end

	if tradeData.bought then
		rep.Events.Notify:FireClient(player,'Item already sold.', colorData.badRed, 3)
		return
	end

	if tradeData.trader ~= player.Name then
		local hasCoins = _G.sessionData[player.UserId].coins

		if hasCoins >= tradeData.getCoins then
			if CanBearLoadArray(player, {{tradeData.giveName, tradeData.giveQuantity}}) then
				_G.trades[tradeKey].bought = true--Prevent coin loss / duped items.

				_G.sessionData[player.UserId].coins = hasCoins-tradeData.getCoins


				-- give the gold to the seller tradedata.player
				local traderPlayer = game.Players:FindFirstChild(tradeData.trader)
				if traderPlayer then
					_G.sessionData[traderPlayer.UserId].coins = _G.sessionData[traderPlayer.UserId].coins+tradeData.getCoins
					rep.Events.UpdateData:FireClient(traderPlayer, _G.sessionData[traderPlayer.UserId],{{"UpdateStats"}})
				end

				--[[
				local contents = {}
				for i = 1,tradeData.giveQuantity do
				contents[#contents+1] = tradeData.giveName
				end
				
				
				-- determine the market they're trading from
				local marketSent = false
				for structure,structureData in next,_G.worldStructures do
				if structureData.owner == player and structure.Name == "Market" then
				--drop the chest at the target spot
				SpawnChest("Trade Chest",structure.CratePart.CFrame*CFrame.new(0,0,-7),contents)
				marketSent = true
				break
				end
				end
				
				if not marketSent then
					if traderPlayer.Character then
						GiveItemToPlayer(tradeData.giveName, player, tradeData.giveQuantity)
						local text = 'You bought '..tradeData.giveName..' x'..tradeData.giveQuantity..' for '..tradeData.getCoins..' Coins.'
						rep.Events.Notify:FireClient(player, text, colorData.essenceYellow, 4)
						--SpawnChest("Trade Chest",player.Character.PrimaryPart.CFrame*CFrame.new(0,-2,0),contents)
					end
				end
				--]]
				GiveItemToPlayer(tradeData.giveName, player, tradeData.giveQuantity)
				--Remove data.
				_G.trades.tradeKey = nil--table.remove(_G.trades, tradeKey)


				local text = 'You bought '..tradeData.giveName..' x'..tradeData.giveQuantity..' for '..tradeData.getCoins..' Coins.'
				rep.Events.Notify:FireClient(player, text, colorData.essenceYellow, 4)
				rep.Events.Notify:FireClient(traderPlayer,player.Name..' bought your Market offer.',colorData.essenceYellow,4)
				rep.Events.UpdateTradeData:FireAllClients(_G.trades)
			else
				rep.Events.Notify:FireClient(player,'Your bag is full.',colorData.essenceYellow, 4)
			end
		end

	else-- refund the player, they're canceling their trade.
		if not tradeData.bought then
			_G.trades[tradeKey].bought = true--Prevent coin loss / duped items.
			_G.trades.tradeKey = nil--table.remove(_G.trades, tradeKey)
			GiveItemToPlayer(tradeData.giveName,player,tradeData.giveQuantity)
			rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"DrawInventory"}})

			rep.Events.UpdateTradeData:FireAllClients(_G.trades)
		else
			print'Error removing data from array.'
		end
	end
end)



local tradeDataUpdater = coroutine.wrap(function()
	while wait(30) do
		rep.Events.UpdateTradeData:FireAllClients(_G.trades)
	end
end)
tradeDataUpdater()

-------------- MARKET STUFF END


local projectileBank = {}
rep.Events.CreateProjectile.OnServerEvent:connect(function(player,projectileData)

	local sound = ss.Sounds.ToolSounds[projectileData.toolName]:FindFirstChild(itemData[projectileData.toolName].fireSound)
	for _,otherPlayer in next,game.Players:GetPlayers() do
		if otherPlayer ~= player then
			if player.Character and player.Character.PrimaryPart then
				rep.Events.PlaySoundAtPosition:FireClient(otherPlayer,sound,player.Character.PrimaryPart.Position)
			end
		end
	end

	local originCF,drawStrength,toolName = projectileData.originCF,projectileData.drawStrength,projectileData.toolName
	local lastAction = lastPlayerToolActions[player.UserId] or 0
	if (rep.RelativeTime.Value-lastAction) >math.clamp(itemData[toolName].speed,.3,10) then
		lastPlayerToolActions[player.UserId] = rep.RelativeTime.Value
		_G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].lastSwing = rep.RelativeTime.Value


		local hasKey = HasItem(player,itemData[toolName].projectileName)
		if HasToolInBar(player,toolName) and hasKey then
			-- good to go
			lastPlayerToolActions[player.UserId] = rep.RelativeTime.Value
			_G.sessionData[player.UserId].inventory[hasKey].quantity = _G.sessionData[player.UserId].inventory[hasKey].quantity-1
			CleanInventory(player)
			rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"DrawInventory"}})
			if not projectileBank[player.UserId] then
				projectileBank[player.UserId]= {}
			end
			table.insert(projectileBank[player.UserId],rep.RelativeTime.Value)

			for _,otherPlayer in next,game.Players:GetPlayers() do
				if otherPlayer ~= player then
					rep.Events.CreateProjectile:FireClient(otherPlayer,{["fromPlayer"] = player,["toolName"] = toolName, ["originCF"] = originCF, ["drawStrength"] = drawStrength,["owner"] = false})
				end
			end

		end

	end 
end)

rep.Events.ProjectileImpact.OnServerEvent:connect(function(player)
	--_G.sessionData[player.UserId].banned = true
	--_G.sessionData[player.UserId].hasHacked = true
	--player:Kick()
end)

rep.Events.DequipCosmetic.OnServerEvent:connect(function(player,part,pos,projectileData,projDistance)
	local toolName = projectileData.toolFrom
	if not (#projectileBank[player.UserId]>=1) then
		--_G.sessionData[player.UserId].banned = true
		--_G.sessionData[player.UserId].hasHacked = true
		--player:Kick()
		return
	end

	local validProjectile = false
	for k,v in next,projectileBank[player.UserId] do
		if rep.RelativeTime.Value - v > 10 then
			table.remove(projectileBank[player.UserId],k)
		else
			validProjectile = projectileBank[player.UserId][k]
			table.remove(projectileBank[player.UserId],k)
			break
		end
	end

	if not validProjectile then
		--_G.sessionData[player.UserId].banned = true
		--_G.sessionData[player.UserId].hasHacked = true
		--player:Kick()
		return
	else
	end

	local lastProjectileOut = projectileBank[player.UserId][1] or rep.RelativeTime.Value
	if rep.RelativeTime.Value-lastProjectileOut<4 and (projectileData.origin-player.Character.PrimaryPart.Position).magnitude < 10 then
		if player.Character and player.Character.PrimaryPart then
			if math.abs((player.Character.PrimaryPart.Position-pos).magnitude-projDistance) < 10+(projDistance/10) then-- accing for ping
				-- let's damage the resource
				if part then
					if  (part:FindFirstChild("Health") or part.Parent:FindFirstChild("Health")) and not game.Players:GetPlayerFromCharacter(part.Parent) then
						local targetEntity
						if part:FindFirstChild("Health") then 
							targetEntity = part
						elseif part.Parent:FindFirstChild("Health") then
							targetEntity = part.Parent
						end
						-- if it's a resource
						local canDamage = false
						for damageType,damageAmount  in next, itemData[toolName].damages do
							if itemData[targetEntity.Name].susceptions[damageType] then
								canDamage = damageAmount
							end
						end

						if canDamage then 
							DamageResource(targetEntity,canDamage,player) 
						end

					elseif IsDescendantOfPlayer(part) then 

						local otherPlayer = game.Players:GetPlayerFromCharacter(part.Parent)
						if otherPlayer then
							local dist = (player.Character.PrimaryPart.Position-otherPlayer.Character.PrimaryPart.Position).magnitude
							if not AreAllies(player,otherPlayer) then
								local armorRating = CalculateArmor(otherPlayer)
								local armorMultiplier = 1-(armorRating/100)
								local damageToDo = itemData[toolName].damages.lifeforms*armorMultiplier

								DamagePlayer(otherPlayer,CalculateToolDamageToPlayers(toolName,otherPlayer))


								CombatTag(player,otherPlayer)
								CombatTag(otherPlayer,player)

							else
								-- they're allies, don't do it!
							end

						end
					end
				end
			end
		end
	end
end)


local offloadCritters = coroutine.wrap(function()
	while wait() do
		local critters = AppendTables({workspace.Critters:GetChildren(),workspace.Deployables:GetChildren()})
		local toOffload,toOnload = {},{}
		local nearestPlayer,nearestDist
		for _,critter in next,critters do
			if critter and critter.PrimaryPart and (itemData[critter.Name].itemType  == "boat" or itemData[critter.Name].itemType  == "creature")  then
				local critterTether= itemData[critter.Name].physicsTether or 200
				local instruction =  "offload"

				for _,player in next,game.Players:GetPlayers() do
					if player and player.Character and player.Character.PrimaryPart then
						local dist = (player.Character.PrimaryPart.Position-critter.PrimaryPart.Position).magnitude
						if dist < critterTether then
							instruction = "onload"
							break
						end 
					end
				end
				if  critter  and critter.PrimaryPart then
					if instruction == "onload" then

						for _,v in next,critter:GetChildren() do
							if v:IsA("BasePart") then
								v.Anchored = false
							end
						end

					else
						if critter.Name == "Raft" then
						end
						for _,v in next,critter:GetChildren() do
							if v:IsA("BasePart") then
								v.Anchored = true
							end
						end
					end
					--if critter:FindFirstChild("AnimationController") then
					--for _,anim in next,critter.AnimationController:GetPlayingAnimationTracks() do 
					--anim:Stop()
					--end 
					--end

					run.Heartbeat:wait()
				end
			end
		end

	end
	-- compare every  critter with every human

end)
--offloadCritters()

--[[
local portals ={
workspace:WaitForChild("LavaPortal"),
workspace:WaitForChild("HavenPortal"),
--workspace:WaitForChild("QueenPortal")
}
for _,portal in next, portals do
portal.Touched:connect(function(hit)
local char = hit.Parent
local player = game.Players:GetPlayerFromCharacter(char)
if player then
-- give them immunity
-- you can also accomplish this by adding a value to their player called TeleportObject 
-- or something, then remove it with the anti hack
--player.Character:SetPrimaryPartCFrame(CFrame.new(portal.Destination.Value))
TeleportPlayer(player,CFrame.new(portal.Destination.Value))
end
end)
end
--]]

--DevVince here, re-made your tp code.
for i,v in pairs(workspace:GetDescendants()) do
	if v:IsA'BasePart' and v:FindFirstChild'Destination' then
		v.Touched:connect(function(hit)
			local char = hit.Parent
			local player = game.Players:GetPlayerFromCharacter(char)
			if player then
				TeleportPlayer(player, CFrame.new(v.Destination.Value))
			end
		end)
	end
end


run.Stepped:connect(function(overall,dt)
	rep.RelativeTime.Value = overall
end)

local violations = {}
local lastPositions  = {}

--local antiTele = coroutine.wrap(function()
--
--while wait(1) do
--for _,player in next,game.Players:GetPlayers() do
--local char = player.Character
--if char and char:FindFirstChild("Head") and char.PrimaryPart then
--local lastPos = lastPositions[player.UserId]
--if not lastPositions[player.UserId] then 
--lastPositions[player.UserId] = char.Head.Position
--else
--if (char.Head.Position-char.PrimaryPart.Position).magnitude > 20 then
--local lastViolation = violations[player.UserId] or 0
--violations[player.UserId] = lastViolation+1
--if violations[player.UserId] >= 3 then
----player:Kick()
--end
--end
--
--local difference = GetXDifference(lastPos,char.Head.Position)
----if difference >= 100 then
----	
------if rep.RelativeTime.Value - _G.sessionData[player.UserId].lastSpawn >5 and rep.RelativeTime.Value-teleImmunity[player.UserId]  > 2 then
------char:MoveTo(lastPositions[player.UserId])
------end
----
------if rep.RelativeTime.Value-teleImmunity[player.UserId]  >2  then
------local lastViolation = violations[player.UserId] or 0
------violations[player.UserId] = lastViolation+1
------if violations[player.UserId] >= 3 then 
--------player:Kick()
------end
------end
------end
--end
--
--lastPositions[player.UserId] = char.Head.Position
--end
--end
--end
--end)
--antiTele()


function SunCrystalMeteor()
	for _,player in next,game.Players:GetPlayers() do
		rep.Events.Notify:FireClient(player,"A Sun Crystal meteor is falling from the sky!",Color3.fromRGB(247, 189, 27),8)
	end
	wait(4)
	for _,player in next,game.Players:GetPlayers() do
		rep.Events.Notify:FireClient(player,"Track it down!",Color3.fromRGB(247, 189, 27),4)
	end
	local destination = meteorLocations[math.random(1,#meteorLocations)]

	local meteor = game.ServerStorage.Misc:FindFirstChild("Sun Crystal Meteor"):Clone()
	local origin = destination*CFrame.new(math.random(-2000,2000),math.random(1000),math.random(-2000,2000))
	meteor.Parent = workspace
	meteor.Rumble:Play()

	local distance = (meteor.Position-destination.p).magnitude
	for i = 0,1,1/1000 do
		meteor.CFrame = CFrame.new(origin.p):lerp(destination,i)*CFrame.Angles(i*10,i*5,i*20)
		game:GetService("RunService").Heartbeat:wait()
	end
	meteor:Destroy()
	local meteorSuite = ss.Misc:FindFirstChild("Sun Crystal Meteor Suite"):Clone()
	meteorSuite:SetPrimaryPartCFrame(destination)
	meteorSuite.Parent = workspace
	meteorSuite["Sun Crystal Meteor Core"].PrimaryPart.Sound:Play()
	meteorSuite["Sun Crystal Meteor Core"].PrimaryPart.Boom.TimePosition = .9
	meteorSuite["Sun Crystal Meteor Core"].PrimaryPart.Boom:Play()

	for _,v in next,meteorSuite:GetChildren() do
		v.Parent = workspace
	end
	meteorSuite:Destroy()
end

function CrystalMeteor()
	for _,player in next,game.Players:GetPlayers() do
		rep.Events.Notify:FireClient(player,"A Crystal meteor is falling from the sky!",Color3.fromRGB(176, 241, 244),8)
	end
	wait(4)
	for _,player in next,game.Players:GetPlayers() do
		rep.Events.Notify:FireClient(player,"Track it down!",Color3.fromRGB(176, 241, 244),4)
	end
	local destination = meteorLocations[math.random(1,#meteorLocations)]

	local meteor = game.ServerStorage.Misc:FindFirstChild("Crystal Meteor"):Clone()
	local origin = destination*CFrame.new(math.random(-2000,2000),math.random(1000),math.random(-2000,2000))
	meteor.Parent = workspace
	meteor.Rumble:Play()

	local distance = (meteor.Position-destination.p).magnitude
	for i = 0,1,1/1000 do
		meteor.CFrame = CFrame.new(origin.p):lerp(destination,i)*CFrame.Angles(i*10,i*5,i*20)
		game:GetService("RunService").Heartbeat:wait()
	end
	meteor:Destroy()
	local meteorSuite = ss.Misc:FindFirstChild("Crystal Meteor Suite"):Clone()
	meteorSuite:SetPrimaryPartCFrame(destination)
	meteorSuite.Parent = workspace
	meteorSuite["Crystal Meteor Core"].PrimaryPart.Sound:Play()
	meteorSuite["Crystal Meteor Core"].PrimaryPart.Boom.TimePosition = .9
	meteorSuite["Crystal Meteor Core"].PrimaryPart.Boom:Play()

	for _,v in next,meteorSuite:GetChildren() do
		v.Parent = workspace
	end
	meteorSuite:Destroy()
end

function Shipwreck()
	for _,player in next,game.Players:GetPlayers() do
		rep.Events.Notify:FireClient(player,"An old treasure has washed ashore!",colorData.essenceYellow,8)
	end
	local destination = shipwreckLocations[math.random(1,#shipwreckLocations)]
	local shipwreck = ss.Misc:FindFirstChild("ShipwreckSuite"):Clone()
	shipwreck:SetPrimaryPartCFrame(destination)
	for _,v in next,shipwreck:GetChildren() do
		if v:IsA("Model") then
			v.Parent = workspace
		else
			v:Destroy()
		end
	end
	shipwreck:Destroy()
end


function MagMeteor()
	for _,player in next,game.Players:GetPlayers() do
		rep.Events.Notify:FireClient(player,"A Magnetite meteor is falling from the sky!",Color3.fromRGB(221, 196, 255),8)
	end
	wait(4)
	for _,player in next,game.Players:GetPlayers() do
		rep.Events.Notify:FireClient(player,"Track it down!",Color3.fromRGB(221,196,255),4)
	end

	local destination = meteorLocations[math.random(1,#meteorLocations)]

	local meteor = game.ServerStorage.Misc:FindFirstChild("Magnetite Meteor"):Clone()
	local origin = destination*CFrame.new(math.random(-2000,2000),math.random(1000),math.random(-2000,2000))
	meteor.Parent = workspace
	meteor.Rumble:Play()

	local distance = (meteor.Position-destination.p).magnitude
	for i = 0,1,1/1000 do
		meteor.CFrame = CFrame.new(origin.p):lerp(destination,i)*CFrame.Angles(i*10,i*5,i*20)
		game:GetService("RunService").Heartbeat:wait()
	end
	meteor:Destroy()
	local meteorSuite = ss.Misc:FindFirstChild("Meteor Suite"):Clone()
	meteorSuite:SetPrimaryPartCFrame(destination)
	meteorSuite.Parent = workspace
	meteorSuite["Meteor Core"].PrimaryPart.Sound:Play()
	meteorSuite["Meteor Core"].PrimaryPart.Boom.TimePosition = .9
	meteorSuite["Meteor Core"].PrimaryPart.Boom:Play()

	for _,v in next,meteorSuite:GetChildren() do
		v.Parent = workspace
	end
	meteorSuite:Destroy()
end


local MagMeteorLoop = coroutine.wrap(function()
	while wait(math.random((60*60),(120*60))) do
		MagMeteor()
		repeat wait(10) until not workspace:FindFirstChild("Meteor Core")
	end
end)
MagMeteorLoop()

local CrystalMeteorLoop = coroutine.wrap(function()
	while wait(math.random((30*60),(60*60))) do
		CrystalMeteor()
		repeat wait(10) until not workspace:FindFirstChild("Crystal Meteor Core")
	end
end)
CrystalMeteorLoop()

local SunCrystalMeteorLoop = coroutine.wrap(function()
	while wait(math.random((15*60),(60*60))) do
		SunCrystalMeteor()
		repeat wait(10) until not workspace:FindFirstChild("Sun Crystal Meteor Core")
	end
end)
SunCrystalMeteorLoop()

local ShipwreckLoop = coroutine.wrap(function()
	while wait(math.random((45*60),(60*60))) do
		Shipwreck()
		repeat wait(10) until not workspace:FindFirstChild("Treasure Chest")
	end
end)
ShipwreckLoop()

workspace.DescendantRemoving:connect(function(child)
	if child.Name == "Totem of the Moon" then
		MagMeteor()
	elseif child.Name == "Lonely God" then
		MagMeteor()
	elseif child.Name == "Queen Ant" then
		workspace.QueenWall.Parent = rep
		wait(800)
		workspace.QueenWall.Parent = workspace
	end
end)

local boogaFunctionEvents = game:GetService("ReplicatedStorage"):WaitForChild'BoogaFunctionEvents'

boogaFunctionEvents.CrystalMeteor.OnServerEvent:Connect(function()
	CrystalMeteor()
end)

boogaFunctionEvents.MagMeteor.OnServerEvent:Connect(function()
	MagMeteor()
end)

boogaFunctionEvents.SunCrystalMeteor.OnServerEvent:Connect(function()
	SunCrystalMeteor()
end)

boogaFunctionEvents.SendNotifyRequest.OnServerEvent:Connect(function(p, text)
	game:GetService("ReplicatedStorage").Events.Notify:FireClient(p,tostring(text),colorData.mojoPurp,5)
end)

local lastFishings = {}
rep.Events.RodSwing.OnServerEvent:connect(function(player,when,ray)
	local lastFish = lastFishings[player.UserId] or 0
	if not lastFish then lastFishings[player.UserId] = rep.RelativeTime.Value end

	local equippedName =_G.sessionData[player.UserId].toolbar[_G.sessionData[player.UserId].equipped].name
	if not itemData[equippedName].useType == "Rod" then return end

	local startEquip = _G.sessionData[player.UserId].equipped
	local toolInfo = itemData[equippedName]
	local part,pos,norm,mat = workspace:FindPartOnRay(ray,player.Character)

	local realTool = player.Character:FindFirstChild(equippedName)
	local rodAttach = realTool.RodAttach
	local dist = (rodAttach.CFrame.p-pos).magnitude

	if part and mat == Enum.Material.Water and rep.RelativeTime.Value-lastFish >= toolInfo.speed and dist <100 then
		lastFishings[player.UserId] = rep.RelativeTime.Value
		local line = ss.Misc.FishingLine:Clone()
		line.Size = Vector3.new(.2,.2,dist)
		line.CFrame = CFrame.new(rodAttach.CFrame.p,rodAttach.Position)*CFrame.new(0,0,-dist/2)
		line.Parent = player.Character:FindFirstChild(equippedName)

		local bobber = ss.Misc.Bobber:Clone()
		bobber.CFrame = CFrame.new(pos)
		bobber.Parent = player.Character:FindFirstChild(equippedName)

		local start = rep.RelativeTime.Value
		repeat if _G.sessionData[player.UserId].equipped ~= startEquip  then return end 
			line.Size = Vector3.new(.2,.2,(rodAttach.CFrame.p-pos).magnitude)
			line.CFrame = CFrame.new(rodAttach.CFrame.p,bobber.Position)*CFrame.new(0,0,-(rodAttach.CFrame.p-pos).magnitude/2)
			wait()
		until ((rep.RelativeTime.Value-start)>=itemData[equippedName].speed)

		local magicNum = math.random(1,4)

		if magicNum == 1 then
			rep.Events.Notify:FireClient(player,"Caught a fish!",colorData.goodGreen,3)
			GiveItemToPlayer("Raw Fish",player,1)
		else
			rep.Events.Notify:FireClient(player,"No bite",Color3.fromRGB(255,255,255),2)
		end
		line:Destroy()
		bobber:Destroy()
	end
end)


local weatherCoroutine = coroutine.wrap(function()
	while true do

		local nextWeather = weatherTypes[math.random(1,#weatherTypes)]

		wait(math.random(240,300))

		if nextWeather ~= currentWeather then
			rep.Events.Weather:FireAllClients(currentWeather,false)
		end
		rep.Events.Weather:FireAllClients(nextWeather,true)

		currentWeather = nextWeather
		if currentWeather == "Doom" then
			wait(60)
		else -- if the weather is not specified a length
			wait(math.random(240,360))
		end

	end
end)
weatherCoroutine()


--for _,critter in next,workspace.Critters:GetChildren() do
---- determine if they are near a player
--local nearestTarget,closest = nil,math.huge
--local characters = {}
--for _,v in next,game.Players:GetPlayers() do
--if v.Character then
--characters[#characters+1] = v.Character
--end
--end
--
--for _,v in next,AppendTables
--
--
--wait(1)
--end
--
--local creatureCoroutine = coroutine.wrap(function()
--
--end)
--creatureCoroutine()

local activeMounds = 0
local antMoundCoroutine = coroutine.wrap(function()
	while true do 

		if activeMounds < 5 then
			-- let's make a new mound
			local newMound = ss.Misc:FindFirstChild("Scavenger Ant Mound"):Clone()
			local destinationKey = math.random(1,#antMoundLocations)
			local destination = antMoundLocations[destinationKey]
			table.remove(antMoundLocations,destinationKey)

			newMound:SetPrimaryPartCFrame(destination)
			newMound.Parent = workspace
			activeMounds = activeMounds+1
			newMound.AncestryChanged:connect(function()
				activeMounds = activeMounds-1
				antMoundLocations[#antMoundLocations+1] = destination
			end)

		end

		wait(180)
	end
end)
antMoundCoroutine()

local potentialInfinityDrops = {
	"Pleb Chest","Pleb Chest","Pleb Chest",
	"Good Chest","Good Chest","Good Chest","Good Chest",
	"Great Chest","Great Chest","Great Chest","Great Chest",
	"OMG Chest","OMG Chest","OMG Chest",
	"Crystal Chest", "Crystal Chest",
	"Adurite Chest",
	"Magnetite Chest",
	"Emerald Chest",
}

workspace.Deployables.ChildAdded:connect(function(child)
	if child.Name == "Infinity Chest" then
		local location = child.PrimaryPart.Position

		child.AncestryChanged:connect(function(c,newParent)
			if not newParent then
				for i = 1,30 do
					local randoChestName = potentialInfinityDrops[math.random(1,#potentialInfinityDrops)]
					local newLocation = Vector3.new(location.X+math.random(-20,20),location.Y,location.Z+math.random(-20,20))
					local downRay = Ray.new(newLocation+Vector3.new(0,1000,0),Vector3.new(0,-10000,0))
					local part,pos,mat,norm = workspace:FindPartOnRayWithWhitelist(downRay,{workspace.Terrain})
					SpawnChest(randoChestName,CFrame.new(pos,location))
					wait(math.random(2,4)/(math.random(1,2)))
				end
			end
		end)


	end
end)

rep.Events.Rebirth.OnServerEvent:connect(function(player)
	if _G.sessionData[player.UserId].level >= 100 then
		_G.sessionData[player.UserId].rebirths = _G.sessionData[player.UserId].rebirths +1

		local itemsToPreserve = {}
		for itemKey,itemInfo in next,_G.sessionData[player.UserId].inventory do
			if itemData[itemInfo.name].rebirthPersist then
				itemsToPreserve[#itemsToPreserve+1] = itemInfo.name
			end
		end

		for locus,armorName in next,_G.sessionData[player.UserId].armor do
			if itemData[armorName] and itemData[armorName] ~= "none" and itemData[armorName].rebirthPersist then
				itemsToPreserve[#itemsToPreserve+1] = armorName
			end
		end

		for toolKey,toolInfo in next,_G.sessionData[player.UserId].toolbar do
			if GetDictionaryLength(_G.sessionData[player.UserId].toolbar[toolKey]) >0 then
				if itemData[toolInfo.name].rebirthPersist then
					itemsToPreserve[#itemsToPreserve+1] = toolInfo.name
				end
			end
		end

		_G.sessionData[player.UserId].inventory = {}
		_G.sessionData[player.UserId].armor = {
			head = "none",
			arms = "none",
			legs = "none",
			torso = "none",
			bag = "none",
			--face = "none",
		}

		_G.sessionData[player.UserId].toolbar = {
			{name = "Rock",
				lastSwing = 0,}, -- 1
			{},  -- 2
			{}, -- 3
			{}, -- 4
			{}, -- 5
			{}, -- 6
		} -- end of toolbar

		_G.sessionData[player.UserId].appearance = {
			gender = "Male",
			skin = "White",
			face = "Smile",
			hat = "none",
			hair = "Bald",
			back = "none",
			effect = "none",
		}

		_G.sessionData[player.UserId].mojo = _G.sessionData[player.UserId].mojo+1
		_G.sessionData[player.UserId].essence = 0
		_G.sessionData[player.UserId].level = 1
		_G.sessionData[player.UserId].spell = nil
		_G.sessionData[player.UserId].voodoo = 0

		-- pie was here
		_G.sessionData[player.UserId].seenVoodooSelection = false
		_G.sessionData[player.UserId].hasChosenSpell = false
		rep.Events.ShowVoodooSelection:FireClient(player)
		_G.sessionData[player.UserId].seenVoodooSelection = true

		for key,v in next,itemsToPreserve do
			if itemData[v].itemType == "tool" then
				_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
					name = v,
					lastSwing = 0,
				}
			else
				_G.sessionData[player.UserId].inventory[#_G.sessionData[player.UserId].inventory+1] = {
					name = v,
					quantity = 1,
				}
			end
		end

		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateStats"}})
		SaveData(player.UserId,_G.sessionData[player.UserId])
		SpawnCharacter(player)
	end
end)

rep.Events.ToggleMojo.OnServerEvent:connect(function(player, mojoName)
	if HasMojoRecipe(player, mojoName) then--Fix for toggle without owning it. xD
		local toggle = not _G.sessionData[player.UserId].disabledMojo[mojoName]
		_G.sessionData[player.UserId].disabledMojo[mojoName] = toggle
		if not toggle then
			if mojoName == "Shelly Friend" then
				local newPet = ss.Pets:FindFirstChild("Shelly Friend"):Clone()
				newPet:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame)
				newPet.Parent = player.Character
				newPet.PetMover.Disabled = false

			elseif mojoName == "Lurky Bro" then
				local newPet = ss.Pets:FindFirstChild("Lurky Bro"):Clone()
				newPet:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame)
				newPet.Parent = player.Character
				newPet.PetMover.Disabled = false

			elseif mojoName == "Peeper Pet" then
				local newPet = ss.Pets:FindFirstChild("Peeper Pet"):Clone()
				newPet:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame)
				newPet.Parent = player.Character
				newPet.PetMover.Disabled = false

			elseif mojoName == "Unicorn Buddy" then
				local newPet = ss.Pets:FindFirstChild("Unicorn Buddy"):Clone()
				newPet:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame)
				newPet.Parent = player.Character
				newPet.PetMover.Disabled = false

			elseif mojoName == "Rabbit Friend" then
				local newPet = ss.Pets:FindFirstChild("Rabbit Friend"):Clone()
				newPet:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame)
				newPet.Parent = player.Character
				newPet.PetMover.Disabled = false

			elseif mojoName == "Sparkles" then
				local sparkle = rep.Particles.GodSparkle:Clone()
				sparkle.Parent = player.Character.PrimaryPart
			end

		else -- if toggle is false

			if mojoName == "Shelly Friend" then
				player.Character:FindFirstChild("Shelly Friend"):Destroy()

			elseif mojoName == "Lurky Bro" then
				player.Character:FindFirstChild("Lurky Bro"):Destroy()

			elseif mojoName == "Peeper Pet" then
				player.Character:FindFirstChild("Peeper Pet"):Destroy()

			elseif mojoName == "Unicorn Buddy" then
				player.Character:FindFirstChild("Unicorn Buddy"):Destroy()

			elseif mojoName == "Rabbit Friend" then
				player.Character:FindFirstChild("Rabbit Friend"):Destroy()

			elseif mojoName == "Sparkles" then
				player.Character.PrimaryPart:FindFirstChild("GodSparkle"):Destroy()
			end
		end

		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateMojoMenu"}})
	end
end)

rep.Events.PurchaseMojoItem.OnServerEvent:connect(function(player,thingName)
	local itemInfo = itemData[thingName]
	local thingCost = itemInfo.mojoCost
	if HasMojoRecipe(player,thingName) then
		rep.Events.Notify:FireClient(player,"You already own this",colorData.essenceYellow,4)
	end

	if _G.sessionData[player.UserId].mojo >= thingCost then
		_G.sessionData[player.UserId].mojo = _G.sessionData[player.UserId].mojo-thingCost
		_G.sessionData[player.UserId].mojoItems[thingName] = true

		if thingName == "Shelly Friend" then
			local newPet = ss.Pets:FindFirstChild("Shelly Friend"):Clone()
			newPet.Parent = player.Character
			newPet.PetMover.Disabled = false

		elseif thingName == "Lurky Bro" then
			local newPet = ss.Pets:FindFirstChild("Lurky Bro"):Clone()
			newPet.Parent = player.Character
			newPet.PetMover.Disabled = false

		elseif thingName == "Unicorn Buddy" then
			local newPet = ss.Pets:FindFirstChild("Unicorn Buddy"):Clone()
			newPet.Parent = player.Character
			newPet.PetMover.Disabled = false

		elseif thingName == "Rabbit Friend" then
			local newPet = ss.Pets:FindFirstChild("Rabbit Friend"):Clone()
			newPet.Parent = player.Character
			newPet.PetMover.Disabled = false

		elseif thingName == "Peeper Pet" then
			local newPet = ss.Pets:FindFirstChild("Peeper Pet"):Clone()
			newPet.Parent = player.Character
			newPet.PetMover.Disabled = false

		elseif thingName == "Sparkles" then
			local sparkle = rep.Particles.GodSparkle:Clone()
			sparkle.Parent = player.Character.PrimaryPart
		end
		rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateMojoMenu"}})
	else
		rep.Events.Notify:FireClient(player,"You need more Mojo for this",colorData.badRed,4)
	end
end)

rep.Events.VoodooSpell.OnServerEvent:connect(function(player,targetPos)
	local char = player.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	local root = char:FindFirstChild("HumanoidRootPart")

	local spell = _G.sessionData[player.UserId].spell
	if spell then
		local spellCost = itemData[spell].voodooCost
		if _G.sessionData[player.UserId].voodoo >= spellCost then

			-- take away their void energy
			_G.sessionData[player.UserId].voodoo = _G.sessionData[player.UserId].voodoo-spellCost
			rep.Events.UpdateData:FireClient(player,_G.sessionData[player.UserId],{{"UpdateStats"}})
			-- update their datumz

			-- YEP they can fire the spell! ^^ yeet yote yort
			-- determine the type of spell
			if spell == "Energy Bolt" then
				-- FRIGGIN BLAST THEM WITH A LASER
				-- identify mouse point
				local rayLength = math.clamp((head.CFrame.p-targetPos).magnitude,5,250)
				local aboutFace = CFrame.new(head.CFrame.p,targetPos)

				local points = {}
				for i = 0,rayLength,5 do
					points[#points+1] = (aboutFace*CFrame.new(math.random(-30,30)/10,math.random(-30,30)/10,-i)).p
				end

				--local segments = {}
				-- generate the parts
				for i = 1,#points-1,1 do
					local segment = Instance.new("Part")
					local length = (points[i]-points[i+1]).magnitude
					segment.Size = Vector3.new(1,1,length)
					segment.CFrame = CFrame.new(points[i],points[i+1])*CFrame.new(0,0,-length/2)
					segment.Color = Color3.fromRGB(78, 29, 168)
					segment.Transparency = .7
					segment.Material = Enum.Material.Glass
					segment.Anchored = true 
					segment.CanCollide = false
					segment.Parent = char
					--segments[#segments] = segment

					--remove the bullet
					local fade = coroutine.wrap(function()
						for i = 0,1,1/30 do
							segment.Transparency = lerp(.7,1,i)
							wait()
						end
						segment:Destroy()
					end)
					fade()

					if i == #points-1 then
						-- make an explosion, it's the last one
						local explosion = Instance.new("Explosion")
						explosion.Position = segment.Position
						explosion.BlastPressure = Vector3.new(0,0,0)
						explosion.BlastRadius = Vector3.new(0,0,0)
						explosion.Parent = workspace
						game:GetService("Debris"):AddItem(explosion,1)

						-- do damage to everyone in the area
						for _,v in next,game.Players:GetPlayers() do
							if v ~= player then
								if v.Character and v.Character.Humanoid and v.Character.Humanoid.Health >0 then
									local dist = (v.Character.PrimaryPart.Position-segment.Position).magnitude
									if dist <= 15 and (IsInATribe(player) ~= IsInATribe(v)) then

										local armorRating = CalculateArmor(v)
										local armorMultiplier = 1-(armorRating/100)
										DamagePlayer(v,itemData["Energy Bolt"].damage*armorMultiplier,false)
										CombatTag(player,v)
										CombatTag(v,player)
									end
								end
							end
						end
					end
					wait()
				end

			elseif spell  == "Energy Shield" then
				if not char:FindFirstChild("Shield") then
					local shield = game.ServerStorage.Misc.Shield:Clone()
					shield.CFrame = root.CFrame
					weldBetween(shield,root)
					shield.Parent = char
					game:GetService("Debris"):AddItem(shield,30)
				end

			elseif spell  == "Super Large" then
				if char then
					if not char:FindFirstChild("SuperLargeActive") then
						local intval = Instance.new("IntValue",char)
						intval.Name = "SuperLargeActive"
						char.Humanoid:FindFirstChild("BodyDepthScale").Value = 2
						char.Humanoid:FindFirstChild("BodyHeightScale").Value = 2
						char.Humanoid:FindFirstChild("BodyWidthScale").Value = 2
						char.Humanoid:FindFirstChild("HeadScale").Value = 2
						char:FindFirstChild("Humanoid").MaxHealth = 200
						char:FindFirstChild("Humanoid").Health = 200
						char:FindFirstChild("Humanoid").WalkSpeed = 26
						char:FindFirstChild("Humanoid").JumpPower = 69
						wait(90)
						char:FindFirstChild("SuperLargeActive"):Destroy()
						char:FindFirstChild("Humanoid").WalkSpeed = 16
						char.Humanoid:FindFirstChild("BodyDepthScale").Value = 1
						char.Humanoid:FindFirstChild("BodyHeightScale").Value = 1
						char.Humanoid:FindFirstChild("BodyWidthScale").Value = 1
						char.Humanoid:FindFirstChild("HeadScale").Value = 1
						char:FindFirstChild("Humanoid").MaxHealth = 100
						char:FindFirstChild("Humanoid").Health = 100
						char:FindFirstChild("Humanoid").WalkSpeed = 16
						char:FindFirstChild("Humanoid").JumpPower = 50				
					end
				end


			elseif spell == "Health Boost" then
				if char then
					local hum = char.Humanoid
					hum.MaxHealth = 182
					wait(30)
					if hum.Health > 100 then
						hum.Health = 100
						hum.MaxHealth = 100
					else
						hum.MaxHealth = 100
					end							
				end

			elseif spell == "Void Cloak" then
				if head.Transparency == 0 then
					for _,part in next,char:GetDescendants() do
						if (part:IsA("BasePart") or part:IsA("Decal")) and part.Transparency < 1 then
							local oldTransparency = part.Transparency
							part.Transparency = .98
							local returnOpaque = coroutine.wrap(function()
								wait(30)
								if part then
									part.Transparency = oldTransparency
								end
							end)
							returnOpaque()

						elseif part:IsA("ParticleEmitter") or part:IsA("BillboardGui") then
							part.Enabled = false
							local reEnable = coroutine.wrap(function()
								wait(30)
								if part then
									part.Enabled = true
								end
							end)
							reEnable()

						end -- end of if part
						-- fade the guis
					end

				end

			else
			end -- end of if spell ==

		end
	end

end)
