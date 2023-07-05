local shopcoords = {
{-426.56821, 1195.42383, 13.05202, 87.5031280517578, -926145642},
{-170.75505, 288.78564, 14.82508, 90.2621307373047, -926145642},
{-616.34241, 132.31723, 4.81617, 0.593680620193481, -926145642},
{-1007.28607, 1628.16931, 24.31901, 179.980697631836, -926145642},
{451.06821, 1503.71033, 16.32071, 29.1426696777344, -926145642},
{1111.88635, 1585.50928, 16.91252, 43.5563163757324, -926145642},
{1637.823, 224.83444, 25.21699, 269.103759765625, -926145642}
}
local cooldown = {}
for i=1,#shopcoords,1 do
	cooldown[i] = 0
end
local shopblip = {}
local seller = {}

--[[local spawned = 0
AddEventHandler('playerSpawned', function()
	if(spawned == 0) then
		if(GetNumberOfPlayers() == 1) then
			CreateThread(function()
				for i=1,#shopcoords,1 do
					seller[i] = SpawnPed(GetHashKey("M_Y_FF_BURGER_R"), shopcoords[i][1], shopcoords[i][2], shopcoords[i][3]-1, shopcoords[i][4], shopcoords[i][5])
					SetCharInvincible(seller[i], true)
					FreezeCharPosition(seller[i], true)
					--SetCharNeverTargetted(seller[i], true)
					--TaskStandGuard(seller[i])
					TaskStandStill(seller[i], 100000000)
					SetCharKeepTask(seller[i], true)
					--ClearCharTasksImmediately(seller[i])
				end
			end)
		end
		spawned = 1
	end
end)]]

CreateThread(function()
	while true do
		Wait(1000)
		for i=1,#shopcoords,1 do
			if(cooldown[i] > 0) then
				cooldown[i] = cooldown[i] - 1
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		for i=1,#shopcoords,1 do
			if(not DoesBlipExist(shopblip[i])) then
				shopblip[i] = AddBlipForCoord(shopcoords[i][1], shopcoords[i][2], shopcoords[i][3], _i)
				ChangeBlipSprite(shopblip[i], 21)
				ChangeBlipScale(shopblip[i], 0.7)
				ChangeBlipNameFromAscii(shopblip[i], "Shop")
				SetBlipAsShortRange(shopblip[i], true)
			end
			if(IsPlayerNearCoords(shopcoords[i][1], shopcoords[i][2], shopcoords[i][3], 10)) then
				PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~open shop menu ~w~(aim with firearm to start a robbery)", 1000, 1)
				if(IsGameKeyboardKeyJustPressed(18)) then
					::again::
					local tempitems = {}
					tempitems[#tempitems+1] = "Replenish health ~g~(100$)"
					tempitems[#tempitems+1] = "Cola ~g~(10$)"
					tempitems[#tempitems+1] = "Energy bar ~g~(15$)"
					tempitems[#tempitems+1] = "Chocolate ~g~(20$)"
					DrawWindow("Shop", tempitems)
					while menuactive do
						Wait(0)
					end
					if(menuresult > 0) then
						if(tempitems[menuresult] == "Replenish health ~g~(100$)") then
							if(money >= 100) then
								money = money - 100
								SaveStats()
								SetCharHealth(GetPlayerChar(GetPlayerId()), 200)
								TriggerEvent('chatMessage', '[Shop]', {0, 255, 0}, 'Health replenished')
							else
								TriggerEvent('chatMessage', '[Shop]', {255, 0, 0}, 'You cannot afford it!')
							end
						elseif(tempitems[menuresult] == "Cola ~g~(10$)") then
							if(inv[1] < 10) then
								if(money >= 10) then
									money = money - 10
									SaveStats()
									inv[1] = inv[1] + 1
									SaveInv()
									TriggerEvent('chatMessage', '[Shop]', {0, 255, 0}, 'Cola purchased')
								else
									TriggerEvent('chatMessage', '[Shop]', {255, 0, 0}, 'You cannot afford it!')
								end
							else
								TriggerEvent('chatMessage', '[Shop]', {255, 0, 0}, 'Maximum amount reached!')
							end
						elseif(tempitems[menuresult] == "Energy bar ~g~(15$)") then
							if(inv[2] < 10) then
								if(money >= 15) then
									money = money - 15
									SaveStats()
									inv[2] = inv[2] + 1
									SaveInv()
									TriggerEvent('chatMessage', '[Shop]', {0, 255, 0}, 'Energy bar purchased')
								else
									TriggerEvent('chatMessage', '[Shop]', {255, 0, 0}, 'You cannot afford it!')
								end
							else
								TriggerEvent('chatMessage', '[Shop]', {255, 0, 0}, 'Maximum amount reached!')
							end
						elseif(tempitems[menuresult] == "Chocolate ~g~(20$)") then
							if(inv[3] < 10) then
								if(money >= 20) then
									money = money - 20
									SaveStats()
									inv[3] = inv[3] + 1
									SaveInv()
									TriggerEvent('chatMessage', '[Shop]', {0, 255, 0}, 'Chocolate purchased')
								else
									TriggerEvent('chatMessage', '[Shop]', {255, 0, 0}, 'You cannot afford it!')
								end
							else
								TriggerEvent('chatMessage', '[Shop]', {255, 0, 0}, 'Maximum amount reached!')
							end
						end
						goto again
					end
				end
				--if(IsPlayerFreeAimingAtChar(GetPlayerId(), seller[i])) then
				if(IsMouseButtonPressed(2) or IsButtonPressed(0, 5)) then
					--if(GetCurrentCharWeapon(GetPlayerChar(GetPlayerId()), _i) >= 7) then
					local gw,cw = GetCurrentCharWeapon(GetPlayerChar(GetPlayerId()))
					if(cw >= 7) then
						if(cooldown[i] == 0) then
							Settimera(0)
							while Timera() < 60000 do
								Wait(0)
								PrintStringWithLiteralStringNow("STRING", "Do not leave ~y~this zone ~w~until robbery is finished (~y~" .. 60 - math.floor(Timera()/1000) .. " secs ~w~left)", 1000, 1)
								if((60 - math.floor(Timera()/1000))%20==0 and (60 - math.floor(Timera()/1000))~=0) then
									AlterWantedLevel(GetPlayerId(), StoreWantedLevel(GetPlayerId(), _i) + 1)
									ApplyWantedLevelChangeNow(GetPlayerId())
									Wait(1000)
								end
								if(IsPlayerDead(GetPlayerId())) then
									--TriggerEvent('chatMessage', '[Robbery]', {255, 0, 0}, 'Robbery has been failed!')
									DrawMessage("~r~Robbery failed", "You have died.")
									break
								end
								if(not IsPlayerNearCoords(shopcoords[i][1], shopcoords[i][2], shopcoords[i][3], 10)) then
									local temptimer = Timera()
									Settimerb(0)
									while Timerb() < 10000 do
										Wait(0)
										PrintStringWithLiteralStringNow("STRING", "~r~Return to the robbery zone! (~y~" .. 10 - math.floor(Timerb()/1000) .. " secs ~r~left)", 1000, 1)
										if(IsPlayerNearCoords(shopcoords[i][1], shopcoords[i][2], shopcoords[i][3], 10)) then
											Settimera(temptimer)
											break
										end
									end
									if(Timerb() >= 10000) then
										--TriggerEvent('chatMessage', '[Robbery]', {255, 0, 0}, 'Robbery has been failed!')
										DrawMessage("~r~Robbery failed", "You left the robbery zone.")
										break
									end
								end
							end
							if(Timera() >= 60000) then
								local finalmoney = GenerateRandomIntInRange(100, 500, _i)
								money = money + finalmoney
								SaveStats()
								cooldown[i] = 300
								--TriggerEvent('chatMessage', '[Robbery]', {0, 255, 0}, 'Robbery has been finished successfully! (+' .. finalmoney .. '$)')
								DrawMessage("~y~Robbery has been finished successfully", "You have got " .. finalmoney .. "$")
								shopsRobbed = shopsRobbed + 1
								SaveDailyStats()
							end
						else
							PrintStringWithLiteralStringNow("STRING", "This shop has been already robbed! Try again later", 1000, 1)
						end
					end
				end
			end
		end
	end
end)