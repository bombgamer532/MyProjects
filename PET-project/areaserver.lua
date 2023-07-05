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
	local data = nil
	data = GetDataFromFile("saves/areas.info", ",")
	if data then
		TriggerClientEvent('updAreas', source, data)
		print("SERVER: areas.info has been loaded.")
	end
end)

RegisterServerEvent('saveAreas')
AddEventHandler('saveAreas', function(data)
	SaveDataToFile("saves/areas.info", data, ",")
	TriggerClientEvent('updAreas', -1, data)
end)

RegisterServerEvent('startCapture')
AddEventHandler('startCapture', function(areaid, owner)
	TriggerClientEvent('startCapture', -1, areaid, owner)
end)

RegisterServerEvent('finishCapture')
AddEventHandler('finishCapture', function(areaid)
	TriggerClientEvent('finishCapture', -1, areaid)
end)

RegisterServerEvent('sendMessageToClans')
AddEventHandler('sendMessageToClans', function(m1, m2)
	TriggerClientEvent('sendMessageToClans', -1, m1, m2)
end)