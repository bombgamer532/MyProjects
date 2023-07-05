blacklist = {}
local file = io.open("saves/bans/blacklist", "r")
if file then
	io.input(file)
	local lines = io.read()
	local parts = Split(lines, ",")
	for i=1,#parts,1 do
		blacklist[i] = parts[i]
	end
	print("SERVER: Blacklist has been loaded.")
	io.close(file)
end

RegisterServerEvent('playerActivated')
AddEventHandler('playerActivated', function()
	local playername = GetPlayerName(source)
	if(#playername > 30) then
		DropPlayer(source, "Too long nickname")
	end
	
	local file1 = io.open("saves/admins/" .. playername .. ".admin", "r")
	if file1 then
		io.input(file1)
		local admin = io.read()
		TriggerClientEvent('updAdmin', source, admin)
		--print("SERVER: " .. playername .. ".admin has been loaded.")
		io.close(file1)
	end
	
	local file2 = io.open("saves/bans/" .. playername .. ".ban", "r")
	if file2 then
		--io.input(file2)
		--local admin = io.read()
		DropPlayer(source, "Banned")
		--print("SERVER: " .. playername .. ".ban has been loaded.")
		io.close(file2)	
	end
	
	local file3 = io.open("saves/bans/blacklist", "r")
	if file3 then
		io.input(file3)
		local lines = io.read()
		local parts = Split(lines, ",")
		for i=1,#parts,1 do
			blacklist[i] = parts[i]
		end
		print("SERVER: Blacklist has been loaded.")
		io.close(file3)
	end
	
	local endpoint = GetPlayerEP(source)
	local ipport = Split(endpoint, ":")
	--local ip = endpoint:sub(1, #endpoint - 6)
	local ip = ipport[1]
	for i=1,#blacklist,1 do
		if(blacklist[i] == ip) then
			DropPlayer(source, "Banned")
		end
	end
end)

RegisterServerEvent('requestKick1')
AddEventHandler('requestKick1', function(id)
	TriggerClientEvent('requestKick2', id)
end)
RegisterServerEvent('kickPlayer2')
AddEventHandler('kickPlayer2', function()
	DropPlayer(source, "Kicked")
end)
RegisterServerEvent('kickPlayer')
AddEventHandler('kickPlayer', function(id)
	DropPlayer(id, "Kicked")
end)

RegisterServerEvent('requestBan1')
AddEventHandler('requestBan1', function(id)
	TriggerClientEvent('requestBan2', id)
end)
RegisterServerEvent('banPlayer')
AddEventHandler('banPlayer', function(id)
	local playername = GetPlayerName(id)
	
	os.remove("saves/bans/" .. playername .. ".ban")
	
	local f,err = io.open("saves/bans/" .. playername .. ".ban", "w")
    if not f then return print(err) end
    f:write(1)
    --print("SERVER: " .. playername .. ".ban has been saved.")
    f:close()
	
	DropPlayer(id, "Banned")
end)

RegisterServerEvent('requestBanIP1')
AddEventHandler('requestBanIP1', function(id)
	TriggerClientEvent('requestBanIP2', id)
end)
RegisterServerEvent('banPlayerIP')
AddEventHandler('banPlayerIP', function(id)
	local playername = GetPlayerName(id)
	local endpoint = GetPlayerEP(id)
	
	local ipport = Split(endpoint, ":")
	--local ip = endpoint:sub(1, #endpoint - 6)
	local ip = ipport[1]
	blacklist[#blacklist+1] = ip
	
	os.remove("saves/bans/" .. playername .. ".ip")
	local f,err = io.open("saves/bans/" .. playername .. ".ip", "w")
    if not f then return print(err) end
    f:write(ip)
    f:close()
	
	local f,err = io.open("saves/bans/blacklist", "w")
    if not f then
		f:write(ip)
	else
		f:write("," .. ip)
	end
    f:close()
	
	DropPlayer(id, "Banned IP")
end)

RegisterServerEvent('performAdminRequest')
AddEventHandler('performAdminRequest', function(target, requester, id, args)
	TriggerClientEvent('performAdminRequest', -1, target, requester, id, args)
end)

RegisterServerEvent('showPlayerInfo')
AddEventHandler('showPlayerInfo', function(id, data)
	TriggerClientEvent('showPlayerInfo', -1, id, data)
end)