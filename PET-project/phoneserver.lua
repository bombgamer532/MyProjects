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

local bounty = {}
for i=0,31,1 do
	bounty[i] = {}
end
RegisterServerEvent('updBounty')
AddEventHandler('updBounty', function(id, data)
	bounty[id] = data
	TriggerClientEvent('updBounty', -1, id, data)
end)
RegisterServerEvent('setBounty')
AddEventHandler('setBounty', function(id, owner, amount)
	bounty[id] = {owner, amount}
	TriggerClientEvent('setBounty', -1, id, owner, amount)
end)
RegisterServerEvent('takeCash')
AddEventHandler('takeCash', function(id, amount)
	TriggerClientEvent('takeCash', -1, id, amount)
end)

RegisterServerEvent('playerActivated')
AddEventHandler('playerActivated', function()
	for i=0,31,1 do
		TriggerClientEvent('updBounty', source, i, bounty[i])
	end
	
	local playername = GetPlayerName(source)
	local data = nil
	
	data = GetDataFromFile("saves/phone/" .. playername .. ".msgtitles", ",")
	if data then
		TriggerClientEvent('updPhoneMessagesTitles', source, data)
		print("SERVER: " .. playername .. ".msgtitles has been loaded.")
	end
	
	data = GetDataFromFile("saves/phone/" .. playername .. ".msgs", ",")
	if data then
		TriggerClientEvent('updPhoneMessages', source, data)
		print("SERVER: " .. playername .. ".msgs has been loaded.")
	end
	
	data = GetDataFromFile("saves/phone/" .. playername .. ".back", ",")
	if data then
		TriggerClientEvent('updPhoneBack', source, data[1])
		print("SERVER: " .. playername .. ".back has been loaded.")
	end
	
	data = GetDataFromFile("saves/phone/" .. playername .. ".ring", ",")
	if data then
		TriggerClientEvent('updPhoneRing', source, data[1])
		print("SERVER: " .. playername .. ".ring has been loaded.")
	end
end)

RegisterServerEvent('savePhoneMessages')
AddEventHandler('savePhoneMessages', function(data)
	local playername = GetPlayerName(source)
	
	os.remove("saves/phone/" .. playername .. ".msgtitles")
	local tempstring = ""
	for i=1,#data,1 do
		if(i ~= #data) then
			tempstring = tempstring .. data[i][1] .. ","
		else
			tempstring = tempstring .. data[i][1]
		end
	end
	local f,err = io.open("saves/phone/" .. playername .. ".msgtitles", "w")
    if not f then return print(err) end
    f:write(tempstring)
    f:close()
	
	os.remove("saves/phone/" .. playername .. ".msgs")
	local tempstring = ""
	for i=1,#data,1 do
		if(i ~= #data) then
			tempstring = tempstring .. data[i][2] .. "|"
		else
			tempstring = tempstring .. data[i][2]
		end
	end
	local f,err = io.open("saves/phone/" .. playername .. ".msgs", "w")
    if not f then return print(err) end
    f:write(tempstring)
    f:close()
end)

RegisterServerEvent('sendPhoneMessage')
AddEventHandler('sendPhoneMessage', function(id, title, msg)
	TriggerClientEvent('sendPhoneMessage', -1, id, title, msg)
end)

RegisterServerEvent('saveBack')
AddEventHandler('saveBack', function(bid)
	local playername = GetPlayerName(source)
	
	os.remove("saves/phone/" .. playername .. ".back")
	
	local f,err = io.open("saves/phone/" .. playername .. ".back", "w")
    if not f then return print(err) end
    f:write(bid)
    f:close()
end)

RegisterServerEvent('saveRing')
AddEventHandler('saveRing', function(bid)
	local playername = GetPlayerName(source)
	
	os.remove("saves/phone/" .. playername .. ".ring")
	
	local f,err = io.open("saves/phone/" .. playername .. ".ring", "w")
    if not f then return print(err) end
    f:write(bid)
    f:close()
end)
---------------------
RegisterServerEvent('callPlayer')
AddEventHandler('callPlayer', function(target, caller)
	TriggerClientEvent('callPlayer', -1, target, caller)
end)

RegisterServerEvent('cancelCall')
AddEventHandler('cancelCall', function(target)
	TriggerClientEvent('cancelCall', -1, target)
end)

RegisterServerEvent('finishCall')
AddEventHandler('finishCall', function(target)
	TriggerClientEvent('finishCall', -1, target)
end)

RegisterServerEvent('returnCallResult')
AddEventHandler('returnCallResult', function(target, result)
	TriggerClientEvent('returnCallResult', -1, target, result)
end)

RegisterServerEvent('updateCall')
AddEventHandler('updateCall', function(id, state)
	TriggerClientEvent('updateCall', -1, id, state)
end)