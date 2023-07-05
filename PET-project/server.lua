SetGameType('FreeroamIRPGIPvE')

function Split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

function GetDataFromFile(path, sep)
	local file = io.open(path, "r")
	if file then
		io.input(file)
		local lines = io.read()
		local parts = Split(lines, sep)
		io.close(file)
		return parts
	else
		return nil
	end
end

function SaveDataToFile(path, data, sep)
	os.remove(path)
	local tempstring = ""
	for i=1,#data,1 do
		if(i ~= #data) then
			tempstring = tempstring .. data[i] .. sep
		else
			tempstring = tempstring .. data[i]
		end
	end
	local f,err = io.open(path, "w")
    if not f then return print(err) end
    f:write(tempstring)
    f:close()
end

local playercolor = {}
for i=0,31,1 do
	playercolor[i] = {}
end

local coop = {}
for i=0,31,1 do
	coop[i] = -1
end

local playermode = {}
for i=0,31,1 do
	playermode[i] = {0, 0}
end

local rus = {}
rus["Press ~y~E ~w~to ~y~start mission"] = "Нажмите ~y~E~w~, чтобы ~y~начать миссию"

RegisterServerEvent('playerActivated')
AddEventHandler('playerActivated', function()
	TriggerClientEvent('updRus', source, rus)
	for i=0,31,1 do
		TriggerClientEvent('updCoop', source, i, coop[i])
		TriggerClientEvent('setPlayerColor', source, i, playercolor[i])
	end
	TriggerClientEvent('updModes', source, playermode)
	
	local playername = GetPlayerName(source)
	local data = nil
	
	data = GetDataFromFile("saves/inv/" .. playername .. ".inv", ",")
	if data then
		TriggerClientEvent('updInv', source, data)
		print("SERVER: " .. playername .. ".inv has been loaded.")
	end
	
	data = GetDataFromFile("saves/weps/" .. playername .. ".weps", "|")
	if data then
		local data2 = {}
		for i=1,#data,1 do
			data2[i] = Split(data[i], ",")
		end
		TriggerClientEvent('updWeps', source, data2)
		print("SERVER: " .. playername .. ".weps has been loaded.")
	end
	
	data = GetDataFromFile("saves/stats/" .. playername .. ".stats", ",")
	if data then
		TriggerClientEvent('updStats', source, data)
		print("SERVER: " .. playername .. ".stats has been loaded.")
	end
	
	local data = {}
	for i=1,300,1 do
		data2 = GetDataFromFile("saves/tuning/" .. playername .. ".tuning" .. i, ",")
		if data2 then
			data[i] = data2
		end
	end
	if(#data > 0) then
		TriggerClientEvent('updTuning', source, data)
		print("SERVER: " .. playername .. ".tuning has been loaded.")
	end
	
	data = GetDataFromFile("saves/houses/" .. playername .. ".houses", ",")
	if data then
		TriggerClientEvent('updHouses', source, data)
		print("SERVER: " .. playername .. ".houses has been loaded.")
	end
	
	data = GetDataFromFile("saves/cars/" .. playername .. ".cars", ",")
	if data then
		TriggerClientEvent('updCars', source, data)
		print("SERVER: " .. playername .. ".cars has been loaded.")
	end
	
	data = GetDataFromFile("saves/biz/" .. playername .. ".biz", ",")
	if data then
		TriggerClientEvent('updBiz', source, data)
		print("SERVER: " .. playername .. ".biz has been loaded.")
	end
	
	data = GetDataFromFile("saves/bizmult/" .. playername .. ".bizmult", ",")
	if data then
		TriggerClientEvent('updBizMult', source, data)
		print("SERVER: " .. playername .. ".bizmult has been loaded.")
	end
	
	data = GetDataFromFile("saves/bizmoney/" .. playername .. ".bizmoney", ",")
	if data then
		TriggerClientEvent('updBizMoney', source, data)
		print("SERVER: " .. playername .. ".bizmoney has been loaded.")
	end
	------
	data = GetDataFromFile("saves/boatyards/" .. playername .. ".boatyards", ",")
	if data then
		TriggerClientEvent('updBoatyards', source, data)
		print("SERVER: " .. playername .. ".boatyards has been loaded.")
	end
	
	data = GetDataFromFile("saves/boats/" .. playername .. ".boats", ",")
	if data then
		TriggerClientEvent('updBoats', source, data)
		print("SERVER: " .. playername .. ".boats has been loaded.")
	end
	------
	data = GetDataFromFile("saves/helipads/" .. playername .. ".helipads", ",")
	if data then
		TriggerClientEvent('updHelipads', source, data)
		print("SERVER: " .. playername .. ".helipads has been loaded.")
	end
	
	data = GetDataFromFile("saves/helis/" .. playername .. ".helis", ",")
	if data then
		TriggerClientEvent('updHelis', source, data)
		print("SERVER: " .. playername .. ".helis has been loaded.")
	end
	------
	data = GetDataFromFile("saves/parts/" .. playername .. ".parts", ",")
	if data then
		TriggerClientEvent('updParts', source, data)
		print("SERVER: " .. playername .. ".parts has been loaded.")
	end
	
	data = GetDataFromFile("saves/drugs/" .. playername .. ".drugs", ",")
	if data then
		TriggerClientEvent('updDrugs', source, data)
		print("SERVER: " .. playername .. ".drugs has been loaded.")
	end
	
	data = GetDataFromFile("saves/techs/" .. playername .. ".techs", ",")
	if data then
		TriggerClientEvent('updTechs', source, data)
		print("SERVER: " .. playername .. ".techs has been loaded.")
	end
	
	data = GetDataFromFile("saves/trucks/" .. playername .. ".trucks", ",")
	if data then
		TriggerClientEvent('updTrucks', source, data)
		print("SERVER: " .. playername .. ".trucks has been loaded.")
	end
	
	data = GetDataFromFile("saves/preps/" .. playername .. ".preps", "|")
	if data then
		local data2 = {}
		for i=1,#data,1 do
			data2[i] = Split(data[i], ",")
		end
		TriggerClientEvent('updPreps', source, data2)
		print("SERVER: " .. playername .. ".preps has been loaded.")
	end
	
	data = GetDataFromFile("saves/outfits/" .. playername .. ".outfits", "|")
	if data then
		local data2 = {}
		for i=1,#data,1 do
			data2[i] = Split(data[i], ",")
		end
		TriggerClientEvent('updOutfits', source, data2)
		print("SERVER: " .. playername .. ".outfits has been loaded.")
	end
	
	data = GetDataFromFile("saves/agency/" .. playername .. ".agency", ",")
	if data then
		TriggerClientEvent('updAgency', source, data)
		print("SERVER: " .. playername .. ".agency has been loaded.")
	end
	------
	local data = {}
	for i=1,300,1 do
		data2 = GetDataFromFile("saves/boattuning/" .. playername .. ".boattuning" .. i, ",")
		if data2 then
			data[i] = data2
		end
	end
	if(#data > 0) then
		TriggerClientEvent('updBoatTuning', source, data)
		print("SERVER: " .. playername .. ".boattuning has been loaded.")
	end
	
	data = {}
	for i=1,300,1 do
		data2 = GetDataFromFile("saves/helituning/" .. playername .. ".helituning" .. i, ",")
		if data2 then
			data[i] = data2
		end
	end
	if(#data > 0) then
		TriggerClientEvent('updHeliTuning', source, data)
		print("SERVER: " .. playername .. ".helituning has been loaded.")
	end
	------
	data = GetDataFromFile("saves/hangars/" .. playername .. ".hangars", ",")
	if data then
		TriggerClientEvent('updHangars', source, data)
		print("SERVER: " .. playername .. ".hangars has been loaded.")
	end
	
	data = GetDataFromFile("saves/planes/" .. playername .. ".planes", ",")
	if data then
		TriggerClientEvent('updPlanes', source, data)
		print("SERVER: " .. playername .. ".planes has been loaded.")
	end
	
	data = {}
	for i=1,300,1 do
		data2 = GetDataFromFile("saves/planetuning/" .. playername .. ".planetuning" .. i, ",")
		if data2 then
			data[i] = data2
		end
	end
	if(#data > 0) then
		TriggerClientEvent('updPlaneTuning', source, data)
		print("SERVER: " .. playername .. ".planetuning has been loaded.")
	end
	
	data = GetDataFromFile("saves/acid/" .. playername .. ".acid", ",")
	if data then
		TriggerClientEvent('updAcid', source, data)
		print("SERVER: " .. playername .. ".acid has been loaded.")
	end
	
	data = GetDataFromFile("saves/mileage/" .. playername .. ".mileage", ",")
	if data then
		TriggerClientEvent('updMileage', source, data)
		print("SERVER: " .. playername .. ".mileage has been loaded.")
	end
end)

RegisterServerEvent('saveInv')
AddEventHandler('saveInv', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/inv/" .. playername .. ".inv", data, ",")
end)

RegisterServerEvent('saveWeps')
AddEventHandler('saveWeps', function(data)
	local playername = GetPlayerName(source)
	
	os.remove("saves/weps/" .. playername .. ".weps")
	
	local tempstring = ""
	for i=1,#data,1 do
		for j=1,#data[i],1 do
			if(j ~= #data[i]) then
				tempstring = tempstring .. data[i][j] .. ","
			else
				if(i ~= #data) then
					tempstring = tempstring .. data[i][j] .. "|"
				else
					tempstring = tempstring .. data[i][j]
				end
			end
		end
	end
	
	local f,err = io.open("saves/weps/" .. playername .. ".weps", "w")
    if not f then return print(err) end
    f:write(tempstring)
    f:close()
	
	TriggerClientEvent('updWeps', source, data)
end)

RegisterServerEvent('saveStats')
AddEventHandler('saveStats', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/stats/" .. playername .. ".stats", data, ",")
end)

RegisterServerEvent('saveTuning')
AddEventHandler('saveTuning', function(data)
	local playername = GetPlayerName(source)
	
	for i=1,#data,1 do
		SaveDataToFile("saves/tuning/" .. playername .. ".tuning" .. i, data[i], ",")
	end
end)

RegisterServerEvent('saveHouses')
AddEventHandler('saveHouses', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/houses/" .. playername .. ".houses", data, ",")
end)

RegisterServerEvent('saveCars')
AddEventHandler('saveCars', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/cars/" .. playername .. ".cars", data, ",")
end)

RegisterServerEvent('saveTrucks')
AddEventHandler('saveTrucks', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/trucks/" .. playername .. ".trucks", data, ",")
end)

RegisterServerEvent('saveBiz')
AddEventHandler('saveBiz', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/biz/" .. playername .. ".biz", data, ",")
end)
RegisterServerEvent('saveBizMult')
AddEventHandler('saveBizMult', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/bizmult/" .. playername .. ".bizmult", data, ",")
end)
RegisterServerEvent('saveBizMoney')
AddEventHandler('saveBizMoney', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/bizmoney/" .. playername .. ".bizmoney", data, ",")
end)
------
RegisterServerEvent('saveBoatyards')
AddEventHandler('saveBoatyards', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/boatyards/" .. playername .. ".boatyards", data, ",")
end)

RegisterServerEvent('saveBoats')
AddEventHandler('saveBoats', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/boats/" .. playername .. ".boats", data, ",")
end)
------
RegisterServerEvent('saveHelipads')
AddEventHandler('saveHelipads', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/helipads/" .. playername .. ".helipads", data, ",")
end)

RegisterServerEvent('saveHelis')
AddEventHandler('saveHelis', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/helis/" .. playername .. ".helis", data, ",")
end)
------
RegisterServerEvent('saveParts')
AddEventHandler('saveParts', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/parts/" .. playername .. ".parts", data, ",")
end)

RegisterServerEvent('sendMessageToPlayer')
AddEventHandler('sendMessageToPlayer', function(name, m1, m2)
	TriggerClientEvent('sendMessageToPlayer', -1, name, m1, m2)
end)
RegisterServerEvent('sendMessageToPlayer2')
AddEventHandler('sendMessageToPlayer2', function(id, m1, m2)
	TriggerClientEvent('sendMessageToPlayer2', -1, id, m1, m2)
end)
RegisterServerEvent('sendMessageToEveryone')
AddEventHandler('sendMessageToEveryone', function(m1, m2)
	TriggerClientEvent('sendMessageToEveryone', -1, m1, m2)
end)
RegisterServerEvent('sendMessageForGamemode')
AddEventHandler('sendMessageForGamemode', function(mode, modeid, m1, m2)
	TriggerClientEvent('sendMessageForGamemode', -1, mode, modeid, m1, m2)
end)

RegisterServerEvent('rewardDmKill')
AddEventHandler('rewardDmKill', function(id, x, y, z)
	TriggerClientEvent('rewardDmKill', -1, id, x, y, z)
end)
RegisterServerEvent('rewardGgKill')
AddEventHandler('rewardGgKill', function(id, x, y, z)
	TriggerClientEvent('rewardGgKill', -1, id, x, y, z)
end)
RegisterServerEvent('rewardSvKill')
AddEventHandler('rewardSvKill', function(id, x, y, z)
	TriggerClientEvent('rewardSvKill', -1, id, x, y, z)
end)
RegisterServerEvent('decreaseKills')
AddEventHandler('decreaseKills', function(id)
	TriggerClientEvent('decreaseKills', -1, id)
end)
RegisterServerEvent('updModes')
AddEventHandler('updModes', function(modes)
	playermode = modes
	TriggerClientEvent('updModes', -1, modes)
end)
RegisterServerEvent('finishRound')
AddEventHandler('finishRound', function(id, modeid)
	TriggerClientEvent('finishRound', -1, id, modeid)
end)

RegisterServerEvent('setPlayerPos')
AddEventHandler('setPlayerPos', function(id, x, y, z, h)
	TriggerClientEvent('setPlayerPos', -1, id, x, y, z, h)
end)

RegisterServerEvent('startRace')
AddEventHandler('startRace', function(rid, id)
	TriggerClientEvent('startRace', -1, rid, id)
end)

RegisterServerEvent('startPursuitRace')
AddEventHandler('startPursuitRace', function(rid, id)
	TriggerClientEvent('startPursuitRace', -1, rid, id)
end)
------
RegisterServerEvent('invitePlayerToClan')
AddEventHandler('invitePlayerToClan', function(id, owner)
	TriggerClientEvent('invitePlayerToClan', -1, id, owner)
end)

RegisterServerEvent('removePlayerFromClan')
AddEventHandler('removePlayerFromClan', function(id, owner)
	TriggerClientEvent('removePlayerFromClan', -1, id, owner)
end)

RegisterServerEvent('setClanName')
AddEventHandler('setClanName', function(clan, name)
	SaveDataToFile("saves/clannames/" .. clan .. ".clanname", {name}, ",")
	TriggerClientEvent('updClanName', -1, clan, name)
end)

RegisterServerEvent('requestClanName')
AddEventHandler('requestClanName', function(clan)
	local data = GetDataFromFile("saves/clannames/" .. clan .. ".clanname", ",")
	if data then
		TriggerClientEvent('updClanName', source, clan, data[1])
	end
end)
------
RegisterServerEvent('sendMoney')
AddEventHandler('sendMoney', function(id, owner, amount)
	TriggerClientEvent('sendMoney', -1, id, owner, amount)
end)
RegisterServerEvent('giveGun')
AddEventHandler('giveGun', function(id, owner, wep, amount)
	TriggerClientEvent('giveGun', -1, id, owner, wep, amount)
end)

RegisterServerEvent('checkClanmate')
AddEventHandler('checkClanmate', function(id, killer, c)
	TriggerClientEvent('checkClanmate', -1, id, killer, c)
end)

RegisterServerEvent('punishKiller')
AddEventHandler('punishKiller', function(id)
	TriggerClientEvent('punishKiller', -1, id)
end)

RegisterServerEvent('requestBonus')
AddEventHandler('requestBonus', function(bday)
	local arr = os.date("*t")
	if(bday ~= arr.day) then
		TriggerClientEvent('requestBonus', source, arr.day)
	else
		TriggerClientEvent('sendMessageToPlayer', source, GetPlayerName(source), "[Bonus]", "You have already collected your daily bonus! Try again at the next day.")
	end
end)

RegisterServerEvent('requestPlayerInfo')
AddEventHandler('requestPlayerInfo', function(target)
	TriggerClientEvent('requestPlayerInfo', -1, target)
end)
RegisterServerEvent('sendPlayerInfo')
AddEventHandler('sendPlayerInfo', function(target, l, c, p)
	TriggerClientEvent('sendPlayerInfo', -1, target, l, c, p)
end)

RegisterServerEvent('saveDrugs')
AddEventHandler('saveDrugs', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/drugs/" .. playername .. ".drugs", data, ",")
end)

RegisterServerEvent('kickPlayer')
AddEventHandler('kickPlayer', function(reason)
	DropPlayer(source, reason)
end)

RegisterServerEvent('saveTechs')
AddEventHandler('saveTechs', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/techs/" .. playername .. ".techs", data, ",")
end)

RegisterServerEvent('spawnFire')
AddEventHandler('spawnFire', function(id, x, y, z)
	TriggerClientEvent('spawnFire', -1, id, x, y, z)
end)

RegisterServerEvent('reportFire')
AddEventHandler('reportFire', function(id)
	TriggerClientEvent('reportFire', -1, id)
end)

RegisterServerEvent('updCoop')
AddEventHandler('updCoop', function(id, state)
	coop[id] = state
	TriggerClientEvent('updCoop', -1, id, state)
end)
RegisterServerEvent('invitePlayerToCoop')
AddEventHandler('invitePlayerToCoop', function(id, owner)
	TriggerClientEvent('invitePlayerToCoop', -1, id, owner)
end)
RegisterServerEvent('removePlayerFromCoop')
AddEventHandler('removePlayerFromCoop', function(id, owner)
	TriggerClientEvent('removePlayerFromCoop', -1, id, owner)
end)

RegisterServerEvent('awardPedKill')
AddEventHandler('awardPedKill', function(id, x, y, z)
	TriggerClientEvent('awardPedKill', -1, id, x, y, z)
end)

RegisterServerEvent('sendCoopReward')
AddEventHandler('sendCoopReward', function(id, cash, exp)
	TriggerClientEvent('sendCoopReward', -1, id, cash, exp)
end)

RegisterServerEvent('savePreps')
AddEventHandler('savePreps', function(data)
	local playername = GetPlayerName(source)
	
	os.remove("preps/" .. playername .. ".preps")
	
	local tempstring = ""
	for i=1,#data,1 do
		for j=1,#data[i],1 do
			if(j ~= #data[i]) then
				tempstring = tempstring .. data[i][j] .. ","
			else
				if(i ~= #data) then
					tempstring = tempstring .. data[i][j] .. "|"
				else
					tempstring = tempstring .. data[i][j]
				end
			end
		end
	end
	
	local f,err = io.open("saves/preps/" .. playername .. ".preps", "w")
    if not f then return print(err) end
    f:write(tempstring)
    f:close()
end)

RegisterServerEvent('sendBlipsForCoop')
AddEventHandler('sendBlipsForCoop', function(id, blipinfo)
	TriggerClientEvent('sendBlipsForCoop', -1, id, blipinfo)
end)

RegisterServerEvent('sendObjectiveForCoop')
AddEventHandler('sendObjectiveForCoop', function(id, text)
	TriggerClientEvent('sendObjectiveForCoop', -1, id, text)
end)

RegisterServerEvent('requestNeon')
AddEventHandler('requestNeon', function(target)
	TriggerClientEvent('requestNeon', -1, target)
end)
RegisterServerEvent('sendNeon')
AddEventHandler('sendNeon', function(target, r, g, b)
	TriggerClientEvent('sendNeon', -1, target, r, g, b)
end)

RegisterServerEvent('ping')
AddEventHandler('ping', function()
	TriggerClientEvent('ping', source, GetPlayerPing(source))
end)

RegisterServerEvent('restartScript')
AddEventHandler('restartScript', function(script)
	TriggerClientEvent('restartScript', source, script)
end)

RegisterServerEvent('saveOutfits')
AddEventHandler('saveOutfits', function(data)
	local playername = GetPlayerName(source)
	
	os.remove("saves/outfits/" .. playername .. ".outfits")
	
	local tempstring = ""
	for i=1,#data,1 do
		for j=1,#data[i],1 do
			if(j ~= #data[i]) then
				tempstring = tempstring .. data[i][j] .. ","
			else
				if(i ~= #data) then
					tempstring = tempstring .. data[i][j] .. "|"
				else
					tempstring = tempstring .. data[i][j]
				end
			end
		end
	end
	
	local f,err = io.open("saves/outfits/" .. playername .. ".outfits", "w")
    if not f then return print(err) end
    f:write(tempstring)
    f:close()
end)

RegisterServerEvent('saveAgency')
AddEventHandler('saveAgency', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/agency/" .. playername .. ".agency", data, ",")
end)

RegisterServerEvent('saveAcid')
AddEventHandler('saveAcid', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/acid/" .. playername .. ".acid", data, ",")
end)

RegisterServerEvent('updatePauseStatus')
AddEventHandler('updatePauseStatus', function(id, status)
	TriggerClientEvent('updatePauseStatus', -1, id, status)
end)
RegisterServerEvent('updateTalkStatus')
AddEventHandler('updateTalkStatus', function(id, status)
	TriggerClientEvent('updateTalkStatus', -1, id, status)
end)
RegisterServerEvent('updateTypeStatus')
AddEventHandler('updateTypeStatus', function(id, status)
	TriggerClientEvent('updateTypeStatus', -1, id, status)
end)
----------------------------------
RegisterServerEvent('saveBoatTuning')
AddEventHandler('saveBoatTuning', function(data)
	local playername = GetPlayerName(source)
	
	for i=1,#data,1 do
		SaveDataToFile("saves/boattuning/" .. playername .. ".boattuning" .. i, data[i], ",")
	end
end)

RegisterServerEvent('saveHeliTuning')
AddEventHandler('saveHeliTuning', function(data)
	local playername = GetPlayerName(source)
	
	for i=1,#data,1 do
		SaveDataToFile("saves/helituning/" .. playername .. ".helituning" .. i, data[i], ",")
	end
end)
----------------------------------------
RegisterServerEvent('saveHangars')
AddEventHandler('saveHangars', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/hangars/" .. playername .. ".hangars", data, ",")
end)

RegisterServerEvent('savePlanes')
AddEventHandler('savePlanes', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/planes/" .. playername .. ".planes", data, ",")
end)

RegisterServerEvent('savePlaneTuning')
AddEventHandler('savePlaneTuning', function(data)
	local playername = GetPlayerName(source)
	
	for i=1,#data,1 do
		SaveDataToFile("saves/planetuning/" .. playername .. ".planetuning" .. i, data[i], ",")
	end
end)
-----------------------------------------------------
RegisterServerEvent('offerOutrun')
AddEventHandler('offerOutrun', function(target, sender)
	TriggerClientEvent('offerOutrun', -1, target, sender)
end)

RegisterServerEvent('startOutrun')
AddEventHandler('startOutrun', function(id, rival, status)
	TriggerClientEvent('startOutrun', -1, id, rival, status)
end)

RegisterServerEvent('changeOutrunStatus')
AddEventHandler('changeOutrunStatus', function(id, status)
	TriggerClientEvent('changeOutrunStatus', -1, id, status)
end)

RegisterServerEvent('finishOutrun')
AddEventHandler('finishOutrun', function(id)
	TriggerClientEvent('finishOutrun', -1, id)
end)

RegisterServerEvent('sendOutrunReward')
AddEventHandler('sendOutrunReward', function(id, amount, sender)
	TriggerClientEvent('sendOutrunReward', -1, id, amount, sender)
end)
---------------------------------------------------
RegisterServerEvent('offerImpromptu')
AddEventHandler('offerImpromptu', function(target, sender, x, y, z)
	TriggerClientEvent('offerImpromptu', -1, target, sender, x, y, z)
end)

RegisterServerEvent('startImpromptu')
AddEventHandler('startImpromptu', function(id, rival, x, y, z)
	TriggerClientEvent('startImpromptu', -1, id, rival, x, y, z)
end)

RegisterServerEvent('finishImpromptu')
AddEventHandler('finishImpromptu', function(id)
	TriggerClientEvent('finishImpromptu', -1, id)
end)

RegisterServerEvent('sendImpromptuReward')
AddEventHandler('sendImpromptuReward', function(id, amount, sender)
	TriggerClientEvent('sendImpromptuReward', -1, id, amount, sender)
end)

RegisterServerEvent('setPlayerColor')
AddEventHandler('setPlayerColor', function(id, color)
	playercolor[id] = color
	TriggerClientEvent('setPlayerColor', -1, id, color)
end)

RegisterServerEvent('sendStuffOffer')
AddEventHandler('sendStuffOffer', function(id, sender, type)
	TriggerClientEvent('sendStuffOffer', -1, id, sender, type)
end)
RegisterServerEvent('acceptStuffOffer')
AddEventHandler('acceptStuffOffer', function(id, sender, type)
	TriggerClientEvent('acceptStuffOffer', -1, id, sender, type)
end)
RegisterServerEvent('acceptStuffOffer2')
AddEventHandler('acceptStuffOffer2', function(id)
	TriggerClientEvent('acceptStuffOffer2', -1, id)
end)

RegisterServerEvent('saveMileage')
AddEventHandler('saveMileage', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/mileage/" .. playername .. ".mileage", data, ",")
end)