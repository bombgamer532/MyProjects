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

RegisterServerEvent('playerActivated')
AddEventHandler('playerActivated', function()
	local playername = GetPlayerName(source)
	local data = nil
	
	data = GetDataFromFile("saves/daily/" .. playername .. ".stats", ",")
	if data then
		TriggerClientEvent('updDailyStats', source, data)
		print("SERVER: " .. playername .. ".stats (daily) has been loaded.")
	end
	
	data = GetDataFromFile("saves/daily/" .. playername .. ".obj", ",")
	if data then
		local arr = os.date("*t")
		if(tonumber(data[1]) ~= arr.day) then
			TriggerClientEvent('generateObjectives', source, arr.day)
		else
			TriggerClientEvent('updDaily', source, data)
		end
		print("SERVER: " .. playername .. ".obj has been loaded.")
	else
		local arr = os.date("*t")
		TriggerClientEvent('generateObjectives', source, arr.day)
	end
end)

RegisterServerEvent('saveDaily')
AddEventHandler('saveDaily', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/daily/" .. playername .. ".obj", data, ",")
end)

RegisterServerEvent('saveDailyStats')
AddEventHandler('saveDailyStats', function(data)
	local playername = GetPlayerName(source)
	SaveDataToFile("saves/daily/" .. playername .. ".stats", data, ",")
end)