function IsPlayerNearCoords2d(x, y, radius)
	local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
	local dist = GetDistanceBetweenCoords2d(px, py, x, y)
	if(dist < radius) then
		return true
	else
		return false
	end
end

ProceedToImpromptuRace = function()
	::main::
	local tempitems = {}
	tempitems[#tempitems+1] = "Choose opponent"
	tempitems[#tempitems+1] = "Set bet ~y~(" .. racebet .. "$)"
	DrawWindow("Impromptu", tempitems)
	while menuactive do
		Wait(0)
	end
	if(menuresult > 0) then
		if(tempitems[menuresult] == "Choose opponent") then
			if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
				local blip = GetFirstBlipInfoId(8)
				if(DoesBlipExist(blip)) then
					local bp = GetBlipCoords(blip)
					local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
					if(CalculateTravelDistanceBetweenNodes(px, py, pz, bp.x, bp.y, bp.z) >= 500) then
						local tempitems = {}
						local tempids = {}
						local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
						for i=0,31,1 do
							if(IsNetworkPlayerActive(i)) then
								if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
									local px,py,pz = GetCharCoordinates(GetPlayerChar(i))
									if(IsPlayerNearCoords(px, py, pz, 50)) then
										if(IsCharInAnyCar(GetPlayerChar(i))) then
											tempitems[#tempitems+1] = GetPlayerName(i)
											tempids[#tempids+1] = i
										end
									end
								end
							end
						end
						if(#tempitems > 0) then
							DrawWindow("Select_player_for_race", tempitems)
							while menuactive do
								Wait(0)
							end
							if(menuresult > 0) then
								TriggerEvent('chatMessage', '[Impromptu]', {255, 255, 0}, 'Offer sent. Please wait...')
								local gz = GetGroundZFor3dCoord(bp.x, bp.y, bp.z+100)
								TriggerServerEvent('offerImpromptu', tempids[menuresult], ConvertIntToPlayerindex(GetPlayerId()), bp.x, bp.y, gz)
							end
						else
							TriggerEvent('chatMessage', '[Impromptu]', {255, 0, 0}, 'There are no drivers near you.')
						end
					else
						TriggerEvent('chatMessage', '[Impromptu]', {255, 0, 0}, 'Distance between you and a waypoint must be at least 500m.')
					end
				else
					TriggerEvent('chatMessage', '[Impromptu]', {255, 0, 0}, 'Specify a waypoint on the map.')
				end
			else
				TriggerEvent('chatMessage', '[Outrun]', {255, 0, 0}, 'You must be in a car.')
			end
		elseif(tempitems[menuresult] == "Set bet ~y~(" .. racebet .. "$)") then
			local chatstring = ""
			cursor = 1
			::again::
			Wait(0)
			SetPlayerControl(GetPlayerId(), false)
			DrawRectLeftTopCenter(0.3, 0.5, 0.4, 0.05, 0, 0, 0, 100)
			local numbers = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
			for i=1,10,1 do --numbers
				if(IsGameKeyboardKeyJustPressed(i+1)) then
					chatstring = "" .. chatstring .. "" .. numbers[i]
				end
			end
			if(IsGameKeyboardKeyJustPressed(14)) then
				--chatstring = chatstring:sub(1, -1)
				chatstring = chatstring:sub(1, #chatstring - 1)
			end
			if(chatstring ~= "") then
				SetTextScale(0.1500000,  0.3000000)
				SetTextEdge(1, 0, 0, 0, 255)
				--SetTextFont(6)
				--SetTextCentre(1)
				DisplayTextWithLiteralString(0.31, 0.515, "STRING", "" .. chatstring)
			else
				SetTextScale(0.1500000,  0.3000000)
				SetTextEdge(1, 0, 0, 0, 255)
				--SetTextFont(6)
				--SetTextCentre(1)
				DisplayTextWithLiteralString(0.31, 0.515, "STRING", "Enter amount")
			end
			DrawRectLeftTopCenter(0.4-0.1, 0.7, 0.2, 0.1, 0, 0, 0, 100)
			SetTextScale(0.300000,  0.6000000)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextCentre(1)
			DisplayTextWithLiteralString(0.5-0.1, 0.73, "STRING", "Set")
			if(IsCursorInAreaLeftTopCenter(0.4-0.1, 0.7, 0.2, 0.1)) then
				DrawRectLeftTopCenter(0.4-0.1, 0.7, 0.2, 0.1, 255, 255, 255, 255)
				if(IsMouseButtonJustPressed(1)) then
					if(chatstring ~= "") then
						local amount = tonumber(chatstring)
						if(amount>=1000 and amount<=10000) then
							racebet = amount
							cursor = 0
							SetPlayerControl(GetPlayerId(), true)
							goto main
						else
							TriggerEvent('chatMessage', '[Bet]', {255, 0, 0}, 'The bet can vary from 1000$ to 10000$!')
						end
					else
						TriggerEvent('chatMessage', '[Bet]', {255, 0, 0}, 'Enter the amount!')
					end
				end
			end
			DrawRectLeftTopCenter(0.4+0.1, 0.7, 0.2, 0.1, 0, 0, 0, 100)
			SetTextScale(0.300000,  0.6000000)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextCentre(1)
			SetTextWrap(0.0, 0.5+0.1)
			DisplayTextWithLiteralString(0.5+0.1, 0.73, "STRING", "Cancel")
			if(IsCursorInAreaLeftTopCenter(0.4+0.1, 0.7, 0.2, 0.1)) then
				DrawRectLeftTopCenter(0.4+0.1, 0.7, 0.2, 0.1, 255, 255, 255, 255)
				if(IsMouseButtonJustPressed(1)) then
					cursor = 0
					SetPlayerControl(GetPlayerId(), true)
					goto main
				end
			end
			goto again
		end
	end
end

RegisterNetEvent('offerImpromptu')
AddEventHandler('offerImpromptu', function(target, sender, x, y, z)
	if(ConvertIntToPlayerindex(GetPlayerId()) == ConvertIntToPlayerindex(target)) then
		DrawWindow("Impromptu_offered", {"Accept offer from " .. GetPlayerName(sender)})
		while menuactive do
			Wait(0)
		end
		if(menuresult > 0) then
			if(menuresult == 1) then
				TriggerServerEvent('sendMessageToPlayer', sender, "[Impromptu]", "Impromptu race offer accepted. Starting...")
				TriggerServerEvent('startImpromptu', target, sender, x, y, z)
				TriggerServerEvent('startImpromptu', sender, target, x, y, z)
			end
		else
			TriggerServerEvent('sendMessageToPlayer', sender, "[Impromptu]", GetPlayerName(target) .. "has declined your impromptu offer.")
		end
	end
end)

local imprompturival = -1
local impromptublip = nil
RegisterNetEvent('startImpromptu')
AddEventHandler('startImpromptu', function(id, rival, x, y, z)
	if(ConvertIntToPlayerindex(GetPlayerId()) == ConvertIntToPlayerindex(id)) then
		local blip = GetFirstBlipInfoId(8)
		if(DoesBlipExist(blip)) then
			RemoveBlip(blip)
		end
		impromptublip = AddBlipForCoord(x, y, z)
		SetRoute(impromptublip, true)
		StartCountdown()
		imprompturival = rival
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(imprompturival > -1) then
			if(not IsPlayerDead(GetPlayerId())) then
				if(IsNetworkPlayerActive(imprompturival)) then
					if(not IsPlayerDead(imprompturival)) then
						local bp = GetBlipCoords(impromptublip)
						DrawCheckpointWithAlpha(bp.x, bp.y, bp.z, 3.1, 0, 0, 255, 100)
						--if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 5)) then
						if(IsPlayerNearCoords2d(bp.x, bp.y, 5)) then
							RemoveBlip(impromptublip)
							DrawMessage("~y~Race won", "You have won the race!")
							TriggerServerEvent('finishImpromptu', imprompturival)
							imprompturival = -1
							--impromptusFinished = impromptusFinished + 1
							--SaveDailyStats()
						end
					else
						RemoveBlip(impromptublip)
						imprompturival = -1
						TriggerEvent('chatMessage', '[Impromptu]', {255, 255, 0}, 'Your rival is dead. Race ended.')
					end
				else
					RemoveBlip(impromptublip)
					imprompturival = -1
					TriggerEvent('chatMessage', '[Impromptu]', {255, 255, 0}, 'Your rival has left the server.')
				end
			else
				RemoveBlip(impromptublip)
				imprompturival = -1
				TriggerEvent('chatMessage', '[Impromptu]', {255, 0, 0}, 'You are dead. Race failed!')
			end
			--[[if(StoreWantedLevel(GetPlayerId()) < 2) then
				AlterWantedLevel(GetPlayerId(), 2)
				ApplyWantedLevelChangeNow(GetPlayerId())
			end]]
		end
	end
end)

RegisterNetEvent('finishImpromptu')
AddEventHandler('finishImpromptu', function(id)
	if(ConvertIntToPlayerindex(GetPlayerId()) == ConvertIntToPlayerindex(id)) then
		RemoveBlip(impromptublip)
		money = money - racebet
		SaveStats()
		TriggerServerEvent('sendImpromptuReward', imprompturival, racebet, ConvertIntToPlayerindex(GetPlayerId()))
		DrawMessage("~r~Race lost", "" .. GetPlayerName(imprompturival) .. " has won the race.")
		TriggerEvent('chatMessage', '[Impromptu]', {255, 255, 0}, 'You have paid a bet of ' .. racebet .. '$ to ' .. GetPlayerName(imprompturival))
		imprompturival = -1
		--impromptusFinished = impromptusFinished + 1
		--SaveDailyStats()
	end
end)

RegisterNetEvent('sendImpromptuReward')
AddEventHandler('sendImpromptuReward', function(id, amount, sender)
	if(ConvertIntToPlayerindex(GetPlayerId()) == ConvertIntToPlayerindex(id)) then
		money = money + amount
		SaveStats()
		TriggerEvent('chatMessage', '[Impromptu]', {0, 255, 0}, 'You have received ' .. amount .. '$ from ' .. GetPlayerName(sender))
	end
end)

RemoveImpromptu = function()
	imprompturival = -1
	RemoveBlip(impromptublip)
end