local jobblip = nil
local ambulance = nil
local client = nil
local group = nil
local state = 0
local tempdist = 0

local inveh = false
CreateThread(function()
	while true do
		Wait(0)
		if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
			if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))) == GetPlayerChar(GetPlayerId())) then
				if(IsCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), GetHashKey("ambulance"))) then
					if(missionstarted == 0) then
						if not inveh then
							PrintStringWithLiteralStringNow("STRING", "Press ~y~Caps Lock ~w~to ~y~start medic mission", 5000, 1)
							inveh = true
						end
						if(IsGameKeyboardKeyJustPressed(58)) then
							ambulance = GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))
							local rx,ry,rz,rh = GetRandomNodeInRadius(GenerateRandomIntInRange(100, 3000))
							client = SpawnRandomPed(rx, ry, rz, rh)
							jobblip = AddBlipForChar(client)
							state = 0
							SetObjective("Collect ~y~an injured person")
							missionstarted = 1
							TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Paramedic mission started.')
						end
					end
				end
			end
		else
			inveh = false
		end
		if(DoesVehicleExist(ambulance)) then
			if(not IsCarDead(ambulance)) then
				if(IsCharInCar(GetPlayerChar(GetPlayerId()), ambulance)) then
					if(not IsCharDead(client)) then
						if(not IsCharInCar(client, ambulance)) then
							SetObjective("Collect ~y~an injured person")
							local px,py,pz = GetCharCoordinates(client)
							if(IsPlayerNearCoords(px, py, pz, 5)) then
								if(not DoesGroupExist(group)) then
									group = CreateGroup(false, true)
									SetGroupLeader(group, GetPlayerChar(GetPlayerId()))
									SetGroupMember(group, client)
									SetCharNeverLeavesGroup(client, true)
								end
							end
						else
							SetObjective("Bring ~y~the injured ~w~to ~y~a hospital")
							if(state == 0) then
								state = 1
								RemoveBlip(jobblip)
								local rx,ry,rz,rh = GetRandomNodeInRadius(GenerateRandomIntInRange(1000, 5000))
								jobblip = AddBlipForCoord(rx, ry, rz)
								SetRoute(jobblip, true)
								local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
								tempdist = GetDistanceBetweenCoords3d(px, py, pz, rx, ry, rz)
							end
							RemoveCharFromGroup(client)
							RemoveGroup(group)
							group = nil
						end
						if(state == 1) then
							local bp = GetBlipCoords(jobblip)
							DrawCheckpoint(bp.x, bp.y, bp.z, 1.1, 255, 255, 0, 100)
							if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
								if(GetCarSpeed(ambulance) == 0) then
									RemoveBlip(jobblip)
									ambulance = nil
									state = 0
									TaskLeaveAnyCar(client)
									MarkCharAsNoLongerNeeded(client)
									client = nil
									local finalreward = {math.floor(tempdist/10), 100}
									money = money + finalreward[1]
									experience = experience + finalreward[2]
									SaveStats()
									DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
									ambulancePassed = ambulancePassed + 1
									SaveDailyStats()
									missionstarted = 0
								end
							end
						end
					else
						RemoveBlip(jobblip)
						local rx,ry,rz,rh = GetRandomNodeInRadius(GenerateRandomIntInRange(100, 3000))
						client = SpawnRandomPed(rx, ry, rz, rh)
						jobblip = AddBlipForChar(client)
						state = 0
						SetObjective("Collect ~y~an injured person")
					end
				else
					Settimera(0)
					while not IsCharInCar(GetPlayerChar(GetPlayerId()), ambulance) do
						Wait(0)
						SetObjective("Get back into the ambulance! Time left: ~y~" .. math.floor((10000-Timera())/1000) .. " seconds")
						if(Timera() > 10000) then
							RemoveBlip(jobblip)
							ambulance = nil
							client = nil
							missionstarted = 0
							TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Ambulance has been abandoned. Mission failed!')
							break
						end
					end
					if(missionstarted > 0) then
						if(state == 0) then
							SetObjective("Collect ~y~an injured person")
						else
							SetObjective("Bring ~y~the injured ~w~to ~y~a hospital")
						end
					end
				end
			else
				RemoveBlip(jobblip)
				ambulance = nil
				MarkCharAsNoLongerNeeded(client)
				client = nil
				missionstarted = 0
			end
		end
	end
end)