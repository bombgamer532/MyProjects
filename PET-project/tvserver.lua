local turned = {}
local channel = {}
local volume = {}
for i=1,10,1 do
	turned[i] = false
	channel[i] = "CNT"
	volume[i] = -12.00000000
end

RegisterServerEvent('playerActivated')
AddEventHandler('playerActivated', function()
	for i=1,10,1 do
		TriggerClientEvent('turnTv', source, i, turned[i])
		TriggerClientEvent('setTvChannel', source, i, channel[i])
		TriggerClientEvent('setTvVolume', source, i, volume[i])
	end
end)

RegisterServerEvent('turnTv')
AddEventHandler('turnTv', function(id, set)
	turned[id] = set
	TriggerClientEvent('turnTv', -1, id, set)
end)

RegisterServerEvent('setTvChannel')
AddEventHandler('setTvChannel', function(id, c)
	channel[id] = c
	TriggerClientEvent('setTvChannel', -1, id, c)
end)

RegisterServerEvent('setTvVolume')
AddEventHandler('setTvVolume', function(id, v)
	volume[id] = v
	TriggerClientEvent('setTvVolume', -1, id, v)
end)