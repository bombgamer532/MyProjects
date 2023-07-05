RegisterServerEvent('playerActivated')
AddEventHandler('playerActivated', function()
	local playername = GetPlayerName(source)
	
	local filepass = io.open("saves/pass/" .. playername .. ".password", "r")
	if filepass then
		TriggerClientEvent('updPassword', source, 1)
		--print("SERVER: " .. playername .. ".password has been loaded.")
		io.close(filepass)
	else
		TriggerClientEvent('updPassword', source, 0)
	end
end)

RegisterServerEvent('savePassword')
AddEventHandler('savePassword', function(password)
	local playername = GetPlayerName(source)
	
	os.remove("saves/pass/" .. playername .. ".password")
	
	local f,err = io.open("saves/pass/" .. playername .. ".password", "w")
    if not f then return print(err) end
    f:write(password)
    --print("SERVER: " .. playername .. ".password has been saved.")
    f:close()
end)

RegisterServerEvent('checkPassword')
AddEventHandler('checkPassword', function(text)
	local playername = GetPlayerName(source)
	
	local filepass = io.open("saves/pass/" .. playername .. ".password", "r")
	if filepass then
		io.input(filepass)
		local password = io.read()
		if(text == password) then
			TriggerClientEvent('proceedPassword', source, 1)
		else
			TriggerClientEvent('proceedPassword', source, 0)
		end
		io.close(filepass)
	end
end)