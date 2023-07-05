RegisterServerEvent('sendWrestOffer')
AddEventHandler('sendWrestOffer', function(id, sender, pos1, pos2)
	TriggerClientEvent('sendWrestOffer', -1, id, sender, pos1, pos2)
end)

RegisterServerEvent('acceptWrestOffer')
AddEventHandler('acceptWrestOffer', function(id, sender, pos1, pos2)
	TriggerClientEvent('acceptWrestOffer', -1, id, sender, pos1, pos2)
end)

RegisterServerEvent('acceptWrestOffer2')
AddEventHandler('acceptWrestOffer2', function(id)
	TriggerClientEvent('acceptWrestOffer2', -1, id)
end)

RegisterServerEvent('updateWrestBalance')
AddEventHandler('updateWrestBalance', function(id, b)
	TriggerClientEvent('updateWrestBalance', -1, id, b)
end)

RegisterServerEvent('updateWrestAnim')
AddEventHandler('updateWrestAnim', function(id, anim)
	TriggerClientEvent('updateWrestAnim', -1, id, anim)
end)

RegisterServerEvent('finishWrest')
AddEventHandler('finishWrest', function(id)
	TriggerClientEvent('finishWrest', -1, id)
end)

RegisterServerEvent('sendWrestReward')
AddEventHandler('sendWrestReward', function(id, amount, sender)
	TriggerClientEvent('sendWrestReward', -1, id, amount, sender)
end)