racebet = 1000

ProceedToOutrun = function()
	::main::
	local tempitems = {}
	tempitems[#tempitems+1] = "Choose opponent"
	tempitems[#tempitems+1] = "Set bet ~y~(" .. racebet .. "$)"
	DrawWindow("Outrun", tempitems)
	while menuactive do
		Wait(0)
	end
	if(menuresult > 0) then
		if(tempitems[menuresult] == "Choose opponent") then
			if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
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
					DrawWindow("Select_player_for_outrun", tempitems)
					while menuactive do
						Wait(0)
					end
					if(menuresult > 0) then
						TriggerEvent('chatMessage', '[Outrun]', {255, 255, 0}, 'Offer sent. Please wait...')
						TriggerServerEvent('offerOutrun', tempids[menuresult], ConvertIntToPlayerindex(GetPlayerId()))
					end
				else
					TriggerEvent('chatMessage', '[Outrun]', {255, 0, 0}, 'There are no drivers near you.')
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

RegisterNetEvent('offerOutrun')
AddEventHandler('offerOutrun', function(target, sender)
	if(ConvertIntToPlayerindex(GetPlayerId()) == ConvertIntToPlayerindex(target)) then
		DrawWindow("Outrun_offered", {"Accept offer from " .. GetPlayerName(sender)})
		while menuactive do
			Wait(0)
		end
		if(menuresult > 0) then
			if(menuresult == 1) then
				TriggerServerEvent('sendMessageToPlayer', sender, "[Outrun]", "Outrun offer accepted. Starting...")
				TriggerServerEvent('startOutrun', target, sender, 0)
				TriggerServerEvent('startOutrun', sender, target, 1)
			end
		else
			TriggerServerEvent('sendMessageToPlayer', sender, "[Outrun]", GetPlayerName(target) .. "has declined your outrun offer.")
		end
	end
end)

local outrunrival = -1
local outrunstatus = 0
RegisterNetEvent('startOutrun')
AddEventHandler('startOutrun', function(id, rival, status)
	if(ConvertIntToPlayerindex(GetPlayerId()) == ConvertIntToPlayerindex(id)) then
		StartCountdown()
		outrunrival = rival
		outrunstatus = status
	end
end)

RegisterNetEvent('changeOutrunStatus')
AddEventHandler('changeOutrunStatus', function(id, status)
	if(ConvertIntToPlayerindex(GetPlayerId()) == ConvertIntToPlayerindex(id)) then
		outrunstatus = status
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(outrunrival > -1) then
			if(not IsPlayerDead(GetPlayerId())) then
				if(IsNetworkPlayerActive(outrunrival)) then
					if(not IsPlayerDead(outrunrival)) then
						local pos1 = table.pack(GetCharCoordinates(GetPlayerChar(GetPlayerId())))
						local pos2 = table.pack(GetCharCoordinates(GetPlayerChar(outrunrival)))
						local dist = GetDistanceBetweenCoords3d(pos1[1], pos1[2], pos1[3], pos2[1], pos2[2], pos2[3])
						if(dist < 300) then
							DrawRectLeftTopCenter(0.9, 0.85, 0.08, 0.1, 0, 0, 0, 100)
							if(outrunstatus == 0) then
								SetTextScale(0.1500000, 0.4000000)
								SetTextDropshadow(0, 0, 0, 0, 0)
								SetTextEdge(1, 0, 0, 0, 255)
								DisplayTextWithLiteralString(0.905, 0.86, "STRING", "~g~You are runner")
							else
								SetTextScale(0.1500000, 0.4000000)
								SetTextDropshadow(0, 0, 0, 0, 0)
								SetTextEdge(1, 0, 0, 0, 255)
								DisplayTextWithLiteralString(0.905, 0.86, "STRING", "~r~You are catcher")
							end
							SetTextScale(0.1500000, 0.4000000)
							SetTextDropshadow(0, 0, 0, 0, 0)
							SetTextEdge(1, 0, 0, 0, 255)
							DisplayTextWithLiteralString(0.905, 0.91, "STRING", "Distance: ~y~" .. math.floor(dist))
							
							if(outrunstatus == 1) then
								local playercar = GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))
								local rivalcar = GetCarCharIsUsing(GetPlayerChar(outrunrival))
								if(playercar~=0 and rivalcar~=0) then
									if(IsCarTouchingCar(playercar, rivalcar)) then
										outrunstatus = 0
										Wait(500)
										TriggerServerEvent('changeOutrunStatus', outrunrival, 1)
									end
								end
							end
						else
							if(outrunstatus == 0) then
								DrawMessage("~y~Outrun won", "You have won the outrun!")
								TriggerServerEvent('finishOutrun', outrunrival)
								outrunrival = -1
								outrunsFinished = outrunsFinished + 1
								SaveDailyStats()
							end
						end
					else
						outrunrival = -1
						TriggerEvent('chatMessage', '[Outrun]', {255, 255, 0}, 'Your rival is dead. Outrun ended.')
					end
				else
					outrunrival = -1
					TriggerEvent('chatMessage', '[Outrun]', {255, 255, 0}, 'Your rival has left the server.')
				end
			else
				outrunrival = -1
			end
			--[[if(StoreWantedLevel(GetPlayerId()) < 2) then
				AlterWantedLevel(GetPlayerId(), 2)
				ApplyWantedLevelChangeNow(GetPlayerId())
			end]]
		end
	end
end)

RegisterNetEvent('finishOutrun')
AddEventHandler('finishOutrun', function(id)
	if(ConvertIntToPlayerindex(GetPlayerId()) == ConvertIntToPlayerindex(id)) then
		money = money - racebet
		SaveStats()
		TriggerServerEvent('sendOutrunReward', outrunrival, racebet, ConvertIntToPlayerindex(GetPlayerId()))
		DrawMessage("~r~Outrun lost", "" .. GetPlayerName(outrunrival) .. " has won the outrun.")
		TriggerEvent('chatMessage', '[Outrun]', {255, 255, 0}, 'You have paid a bet of ' .. racebet .. '$ to ' .. GetPlayerName(outrunrival))
		outrunrival = -1
		--outrunsFinished = outrunsFinished + 1
		--SaveDailyStats()
	end
end)

RegisterNetEvent('sendOutrunReward')
AddEventHandler('sendOutrunReward', function(id, amount, sender)
	if(ConvertIntToPlayerindex(GetPlayerId()) == ConvertIntToPlayerindex(id)) then
		money = money + amount
		SaveStats()
		TriggerEvent('chatMessage', '[Outrun]', {0, 255, 0}, 'You have received ' .. amount .. '$ from ' .. GetPlayerName(sender))
	end
end)

RemoveOutrun = function()
	outrunrival = -1
	outrunstatus = 0
end