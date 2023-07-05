local jobblip = {}
local polcar = nil
local crim = {}
local crimcar = nil
local tempdist = 0

local inveh = false
CreateThread(function()
	while true do
		Wait(0)
		if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
			if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))) == GetPlayerChar(GetPlayerId())) then
				if(IsCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), GetHashKey("police")) or
				IsCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), GetHashKey("police2")) or
				IsCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), GetHashKey("noose")) or
				IsCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), GetHashKey("pstockade")) or
				IsCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), GetHashKey("nstockade"))) then
					if(missionstarted == 0) then
						if not inveh then
							PrintStringWithLiteralStringNow("STRING", "Press ~y~Caps Lock ~w~to ~y~start police mission", 5000, 1)
							inveh = true
						end
						if(IsGameKeyboardKeyJustPressed(58)) then
							polcar = GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))
							local rx,ry,rz,rh = GetRandomNodeInRadius(GenerateRandomIntInRange(100, 3000))
							local vehs = {
							"schafter",
							"turismo",
							"coquette",
							"patriot",
							"comet",
							"cavalcade",
							"fxt",
							"e109",
							"blista"
							}
							crimcar = SpawnCar(GetHashKey(vehs[GenerateRandomIntInRange(1, #vehs+1)]), rx, ry, rz, rh)
							crim[1] = SpawnPed(GetHashKey("M_Y_GLAT_LO_01"), rx, ry, rz, rh)
							WarpCharIntoCar(crim[1], crimcar)
							TaskCarMission(crim[1], crimcar, crimcar, 1, 20.1, 2, 0, 10)
							SetCharKeepTask(crim[1], true)
							jobblip[1] = AddBlipForChar(crim[1])
							crim[2] = SpawnPed(GetHashKey("M_Y_GLAT_LO_01"), rx, ry, rz, rh)
							WarpCharIntoCarAsPassenger(crim[2], crimcar, 0)
							GiveWeaponToChar(crim[2], 7, 1000, 1)
							jobblip[2] = AddBlipForChar(crim[2])
							local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
							tempdist = CalculateTravelDistanceBetweenNodes(px, py, pz, rx, ry, rz)
							SetObjective("Kill ~y~the criminal")
							missionstarted = 1
							TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Police mission started.')
						end
					end
				end
			end
		else
			inveh = false
		end
		if(DoesVehicleExist(polcar)) then
			if(not IsCarDead(polcar)) then
				if(IsCharInCar(GetPlayerChar(GetPlayerId()), polcar)) then
					local pedskilled = 0
					for i=1,2,1 do
						if(IsCharDead(crim[i])) then
							RemoveBlip(jobblip[i])
							pedskilled = pedskilled + 1
						else
							if(IsPedNearPlayer(crim[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(crim[i], GetPlayerChar(GetPlayerId()), false) or HasCarBeenDamagedByChar(crimcar, GetPlayerChar(GetPlayerId()), false)) then
								AttackPlayer(crim[2])
							end
						end
					end
					if(pedskilled == 2) then
						for i=1,2,1 do
							RemoveBlip(jobblip[i])
							MarkCharAsNoLongerNeeded(crim[i])
						end
						MarkCarAsNoLongerNeeded(crimcar)
						polcar = nil
						local finalreward = {200 + math.floor(tempdist/10), 50 + math.floor(tempdist/20)}
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						policePassed = policePassed + 1
						SaveDailyStats()
						missionstarted = 0
					end
				else
					Settimera(0)
					while not IsCharInCar(GetPlayerChar(GetPlayerId()), polcar) do
						Wait(0)
						SetObjective("Get back into the police vehicle! Time left: ~y~" .. math.floor((10000-Timera())/1000) .. " seconds")
						if(Timera() > 10000) then
							for i=1,2,1 do
								RemoveBlip(jobblip[i])
								MarkCharAsNoLongerNeeded(crim[i])
							end
							MarkCarAsNoLongerNeeded(crimcar)
							polcar = nil
							missionstarted = 0
							TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Police vehicle has been abandoned. Mission failed!')
							break
						end
					end
					if(missionstarted > 0) then
						SetObjective("Kill ~y~the criminal")
					end
				end
			end
			if(IsPlayerDead(GetPlayerId())) then
				for i=1,2,1 do
					RemoveBlip(jobblip[i])
					MarkCharAsNoLongerNeeded(crim[i])
					crim[i] = nil
				end
				MarkCarAsNoLongerNeeded(crimcar)
				crimcar = nil
				polcar = nil
				missionstarted = 0
			end
		end
	end
end)