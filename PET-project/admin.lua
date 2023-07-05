local admin = 0
RegisterNetEvent('updAdmin')
AddEventHandler('updAdmin', function(padmin)
	admin = tonumber(padmin)
end)

RegisterNetEvent('requestKick2')
AddEventHandler('requestKick2', function(id)
	if(id == PlayerId()) then
		TriggerServerEvent('kickPlayer2')
	end
end)
RegisterNetEvent('requestBan2')
AddEventHandler('requestBan2', function(id)
	if(id == PlayerId()) then
		TriggerServerEvent('banPlayer')
	end
end)
RegisterNetEvent('requestBanIP2')
AddEventHandler('requestBanIP2', function(id)
	if(id == PlayerId()) then
		TriggerServerEvent('banPlayerIP')
	end
end)

RegisterNetEvent('performAdminRequest')
AddEventHandler('performAdminRequest', function(target, requester, id, args)
	if(ConvertIntToPlayerindex(target) == ConvertIntToPlayerindex(GetPlayerId())) then
		if(id == "imprison") then
			SetCharCoordinatesNoOffset(GetPlayerChar(GetPlayerId()), -1073.36658, -459.22778, 2.26232) --jail
			demorgan = args[1]
			SaveStats()
			TriggerServerEvent('sendMessageToEveryone', "^1Administator " .. GetPlayerName(requester) .. " has imprisoned " .. GetPlayerName(target) .. " for " .. args[1] .. " seconds. Reason: " .. args[2])
		elseif(id == "setfaction") then
			job = args[1]
			SaveStats()
			SetDefaultSkin()
			ChatMessage("Your faction has been changed by " .. GetPlayerName(requester) .. ".")
			TriggerServerEvent('sendMessageToPlayer', requester, "Faction set.")
		elseif(id == "setrank") then
			rank = args[1]
			SaveStats()
			ChatMessage("Your rank has been changed by " .. GetPlayerName(requester) .. ".")
			TriggerServerEvent('sendMessageToPlayer', requester, "Rank set.")
		elseif(id == "setleader") then
			leader = args[1]
			SaveStats()
			ChatMessage("Your leader status has been changed by " .. GetPlayerName(requester) .. ".")
			TriggerServerEvent('sendMessageToPlayer', requester, "Leader set.")
		end
	end
end)

RegisterNetEvent('setPlayerPos')
AddEventHandler('setPlayerPos', function(id, x, y, z)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		SetCharCoordinatesNoOffset(GetPlayerChar(GetPlayerId()), x, y, z)
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(loginform == 0) then
			if(admin == 1) then
				if(IsGameKeyboardKeyJustPressed(63)) then --f5
					::main::
					local tempitems = {}
					local tempids = {}
					for i=0,31,1 do
						if(IsNetworkPlayerActive(i)) then
							--if(i ~= PlayerId()) then
								tempitems[#tempitems+1] = GetPlayerName(i)
								tempids[#tempids+1] = i
							--end
						end
					end
					DrawWindow("Admin menu", tempitems)
					while menuactive do
						Wait(0)
					end
					if(menuresult > 0) then
						local player = tempids[menuresult]
						::option::
						local tempitems = {}
						tempitems[#tempitems+1] = "Kick"
						tempitems[#tempitems+1] = "Ban account"
						tempitems[#tempitems+1] = "Ban IP"
						tempitems[#tempitems+1] = "Teleport yourself to player"
						tempitems[#tempitems+1] = "Teleport player to you"
						tempitems[#tempitems+1] = "Spectate"
						DrawWindow("" .. GetPlayerName(player), tempitems)
						while menuactive do
							Wait(0)
						end
						if(menuresult > 0) then
							if(tempitems[menuresult] == "Kick") then
								TriggerServerEvent('kickPlayer', GetPlayerServerId(player))
								TriggerServerEvent('sendMessageToEveryone', "^1Player " .. GetPlayerName(player) .. " has been kicked by " .. GetPlayerName(PlayerId()) .. ".")
							elseif(tempitems[menuresult] == "Ban account") then
								TriggerServerEvent('banPlayer', GetPlayerServerId(player))
								TriggerServerEvent('sendMessageToEveryone', "^1Player " .. GetPlayerName(player) .. " has been banned by " .. GetPlayerName(PlayerId()) .. ".")
							elseif(tempitems[menuresult] == "Ban IP") then
								TriggerServerEvent('banPlayerIP', GetPlayerServerId(player))
								TriggerServerEvent('sendMessageToEveryone', "^1Player " .. GetPlayerName(player) .. " has been banned by IP by " .. GetPlayerName(PlayerId()) .. ".")
							elseif(tempitems[menuresult] == "Teleport yourself to player") then
								local px,py,pz = GetCharCoordinates(GetPlayerChar(player))
								SetCharCoordinatesNoOffset(GetPlayerChar(GetPlayerId()), px, py, pz)
							elseif(tempitems[menuresult] == "Teleport player to you") then
								local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
								TriggerServerEvent('setPlayerPos', player, px, py, pz, 0.0)
							elseif(tempitems[menuresult] == "Spectate") then
								local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
								--FreezeCharPosition(GetPlayerChar(GetPlayerId()), true)
								SetCharVisible(GetPlayerChar(GetPlayerId()), false)
								SetCharCollision(GetPlayerChar(GetPlayerId()), false)
								EnableCamCollision(GetGameCam(), false)
								SetPlayerControl(GetPlayerId(), false)
								--SetInSpectatorMode(1, GetPlayerChar(player))
								while true do
									Wait(0)
									local cx,cy,cz = GetCharCoordinates(GetPlayerChar(player))
									SetCharCoordinatesNoOffset(GetPlayerChar(GetPlayerId()), cx, cy, cz)
									PrintText("Press ~y~E ~w~to leave spectator mode", 1)
									if(IsGameKeyboardKeyJustPressed(18)) then
										--SetInSpectatorMode(0, GetPlayerChar(player))
										RequestCollisionAtPosn(px, py, pz)
										SetCharCoordinatesNoOffset(GetPlayerChar(GetPlayerId()), px, py, pz)
										FreezeCharPosition(GetPlayerChar(GetPlayerId()), false)
										SetCharVisible(GetPlayerChar(GetPlayerId()), true)
										SetCharCollision(GetPlayerChar(GetPlayerId()), true)
										EnableCamCollision(GetGameCam(), true)
										SetPlayerControl(GetPlayerId(), true)
										break
									end
								end
							end
						else
							goto main
						end
					end
				end
			end
		end
	end
end)