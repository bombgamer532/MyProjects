local jobblip = nil
local firetruck = nil
local tempdist = 0

local inveh = false
CreateThread(function()
	while true do
		Wait(0)
		if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
			if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))) == GetPlayerChar(GetPlayerId())) then
				if(IsCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), GetHashKey("firetruk"))) then
					if(missionstarted == 0) then
						if not inveh then
							PrintStringWithLiteralStringNow("STRING", "Press ~y~Caps Lock ~w~to ~y~start fireman mission", 5000, 1)
							inveh = true
						end
						if(IsGameKeyboardKeyJustPressed(58)) then
							firetruck = GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))
							local rx,ry,rz,rh = GetRandomNodeInRadius(GenerateRandomIntInRange(100, 3000))
							jobblip = AddBlipForCoord(rx, ry, rz)
							SetRoute(jobblip, true)
							tempdist = GetDistanceBetweenCoords3d(px, py, pz, rx, ry, rz)
							SetObjective("Extinguish ~y~the fire")
							currmission = 1
							missionstarted = 1
							TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Fireman mission started.')
						end
					end
				end
			end
		else
			inveh = false
		end
		if(DoesVehicleExist(firetruck)) then
			if(not IsCarDead(firetruck)) then
				if(IsCharInCar(GetPlayerChar(GetPlayerId()), firetruck)) then
					local bp = GetBlipCoords(jobblip)
					DrawCheckpoint(bp.x, bp.y, bp.z, 5.1, 255, GenerateRandomIntInRange(0, 256), 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 10)) then
						local fireprogress = 0
						PrintStringWithLiteralStringNow("STRING", "Use ~y~water gun ~w~to extinguish fire (0%)", 1, 1)
						while IsMouseButtonPressed(1) do
							Wait(0)
							fireprogress = fireprogress + 1
							PrintStringWithLiteralStringNow("STRING", "Use ~y~water gun ~w~to extinguish fire (" .. fireprogress .. "%)", 1, 1)
							if(fireprogress >= 100) then
								RemoveBlip(jobblip)
								money = money + math.floor(tempdist/10)
								experience = experience + 100
								SaveStats()
								DrawMessage("~y~Mission completed", "You have got " .. math.floor(tempdist/10) .. "$ and 100 EXP")
								firePassed = firePassed + 1
								SaveDailyStats()
								SetObjective("")
								currstage = 0
								currmission = 0
								missionstarted = 0
								break
							end
						end
					end
				else
					Settimera(0)
					while not IsCharInCar(GetPlayerChar(GetPlayerId()), firetruck) do
						Wait(0)
						SetObjective("Get back into the firetruck! Time left: ~y~" .. math.floor((10000-Timera())/1000) .. " seconds")
						if(Timera() > 10000) then
							RemoveBlip(jobblip)
							firetruck = nil
							missionstarted = 0
							TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Firetruck has been abandoned. Mission failed!')
							break
						end
					end
					if(missionstarted > 0) then
						SetObjective("Extinguish ~y~the fire")
					end
				end
			else
				RemoveBlip(jobblip)
				firetruck = nil
				missionstarted = 0
			end
		end
	end
end)