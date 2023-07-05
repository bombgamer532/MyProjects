local jobblip = nil
local taxi = nil
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
				if(IsCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), GetHashKey("taxi")) or
				IsCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), GetHashKey("taxi2")) or
				IsCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), GetHashKey("cabby"))) then
					if(missionstarted == 0) then
						if not inveh then
							PrintStringWithLiteralStringNow("STRING", "Press ~y~Caps Lock ~w~to ~y~start taxi mission", 5000, 1)
							inveh = true
						end
						if(IsGameKeyboardKeyJustPressed(58)) then
							taxi = GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))
							state = 0
							SetObjective("Look for ~y~a passenger")
							missionstarted = 1
							TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Taxi mission started.')
						end
					end
				end
			end
		else
			inveh = false
		end
		if(DoesVehicleExist(taxi)) then
			if(not IsCarDead(taxi)) then
				if(IsCharInCar(GetPlayerChar(GetPlayerId()), taxi)) then
					if(not IsCharDead(client)) then
						if(not IsCharInCar(client, taxi)) then
							SetObjective("Collect ~y~the passenger")
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
							SetObjective("Bring ~y~the passenger ~w~to ~y~the destination")
							if(state == 0) then
								state = 1
								RemoveBlip(jobblip)
								local rx,ry,rz,rh = GetRandomNodeInRadius(GenerateRandomIntInRange(1000, 5000))
								jobblip = AddBlipForCoord(rx, ry, rz)
								SetRoute(jobblip, true)
								local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
								tempdist = GetDistanceBetweenCoords3d(px, py, pz, rx, ry, rz)
							end
							--RemoveCharFromGroup(client)
							--RemoveGroup(group)
							--group = nil
						end
						if(state == 1) then
							local bp = GetBlipCoords(jobblip)
							DrawCheckpoint(bp.x, bp.y, bp.z, 1.1, 255, 255, 0, 100)
							if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
								if(GetCarSpeed(taxi) == 0) then
									RemoveCharFromGroup(client)
									RemoveGroup(group)
									group = nil
									RemoveBlip(jobblip)
									taxi = nil
									state = 0
									TaskLeaveAnyCar(client)
									MarkCharAsNoLongerNeeded(client)
									client = nil
									local finalreward = {math.floor(tempdist/10), 100}
									money = money + finalreward[1]
									experience = experience + finalreward[2]
									SaveStats()
									DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
									taxiPassed = taxiPassed + 1
									SaveDailyStats()
									missionstarted = 0
								end
							end
						end
					else
						RemoveBlip(jobblip)
						state = 0
						local rx,ry,rz,rh = GetRandomNodeInRadius(GenerateRandomIntInRange(500, 1000))
						client = SpawnRandomPed(rx, ry, rz, rh)
						jobblip = AddBlipForChar(client)
						SetRoute(jobblip, true)
						local dm = LoadCharDecisionMaker(1)
						SetDecisionMakerAttributeCaution(dm, 0)
						SetCharDecisionMaker(client, dm)
						--[[BeginCharSearchCriteria()
						local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
						randomped = GetRandomCharInAreaOffsetNoSave(px, py, pz, 50.1, 50.1, 50.1, _i)
						SetObjective("Look for ~y~a passenger")
						if(not IsCharDead(randomped)) then
							client = randomped
							SetCharAsMissionChar(client, true)
							jobblip = AddBlipForChar(client)
							local dm = LoadCharDecisionMaker(1)
							SetDecisionMakerAttributeCaution(dm, 0)
							SetCharDecisionMaker(client, dm)
							randomped = nil
						end
						EndCharSearchCriteria()]]
					end
				else
					if(DoesGroupExist(group)) then
						RemoveCharFromGroup(client)
						RemoveGroup(group)
						group = nil
					end
					Settimera(0)
					while not IsCharInCar(GetPlayerChar(GetPlayerId()), taxi) do
						Wait(0)
						SetObjective("Get back into the taxi! Time left: ~y~" .. math.floor((10000-Timera())/1000) .. " seconds")
						if(Timera() > 10000) then
							RemoveBlip(jobblip)
							taxi = nil
							client = nil
							missionstarted = 0
							TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Taxi has been abandoned. Mission failed!')
							break
						end
					end
					if(missionstarted > 0) then
						if(state == 0) then
							SetObjective("Look for ~y~a passenger")
						else
							SetObjective("Bring ~y~the passenger ~w~to ~y~the destination")
						end
					end
				end
			else
				RemoveBlip(jobblip)
				taxi = nil
				client = nil
				missionstarted = 0
			end
		end
	end
end)