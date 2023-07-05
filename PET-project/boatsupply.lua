local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end

local dist = 0
CreateThread(function()
	while true do
		Wait(0)
		if(not DoesBlipExist(boatsupplyblip)) then
			boatsupplyblip = AddBlipForCoord(724.56818, 7.67924, 6.03773, _i)
			ChangeBlipSprite(boatsupplyblip, 48)
			ChangeBlipColour(boatsupplyblip, 19)
			ChangeBlipScale(boatsupplyblip, 0.7)
			ChangeBlipNameFromAscii(boatsupplyblip, "Boat supply")
			SetBlipAsShortRange(boatsupplyblip, true)
		end
		if(missionstarted == 0) then
			DrawTextAtCoord(724.56818, 7.67924, 6.03773, "Boat_supply", 20)
			DrawCheckpointWithDist(724.56818, 7.67924, 6.03773-1, 1.1, 255, 255, 0, 100)
			if(IsPlayerNearCoords(724.56818, 7.67924, 6.03773, 1)) then
				if(biz[8]==1 or biz[9]==1) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~start boat supply job", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						local rx,ry,rz,rh = GetRandomWaterNodeInRadius(GenerateRandomIntInRange(500, 2000))
						vehs[1] = SpawnCar(GetHashKey(boatspecs[GenerateRandomIntInRange(1, #boatspecs)][2]), rx, ry, rz, rh)
						blips[1] = AddBlipForCar(vehs[1])
						local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
						dist = GetDistanceBetweenCoords3d(px, py, pz, rv.x, rv.y, rv.z)
						SetObjective("Steal ~y~the boat")
						TriggerEvent('chatMessage', '[Boat supply]', {255, 255, 0}, 'Mission started!')
						currmission = 1
						missionstarted = 1
					end
				else
					PrintStringWithLiteralStringNow("STRING", "~r~You must own at least one warehouse business to use it", 1000, 1)
				end
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(currmission > 0) then
			if(currmission == 1) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(675.2243, -59.79591, -0.76348)
							local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
							local bp = GetBlipCoords(blips[1])
							dist = dist + GetDistanceBetweenCoords3d(px, py, pz, bp.x, bp.y, bp.z)
							SetObjective("Deliver ~y~this boat ~w~to ~y~the dock")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Boat destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						AlterWantedLevel(GetPlayerId(), 3)
						ApplyWantedLevelChangeNow(GetPlayerId())
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							local bp = GetBlipCoords(blips[1])
							DrawCheckpointWithDist(bp.x, bp.y, bp.z, 1.1, 255, 255, 0, 100)
							if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
								local boatcash = 0
								local model = GetCarModel(vehs[1])
								for i=1,#boatspecs,1 do
									if(model == GetHashKey(boatspecs[i][2])) then
										boatcash = math.floor(boatspecs[i][3]/10)
									end
								end
								local finalreward = {}
								finalreward[1] = boatcash + math.floor(dist)
								finalreward[2] = math.floor(dist/10)
								money = money + finalreward[1]
								experience = experience + finalreward[2]
								SaveStats()
								AlterWantedLevel(GetPlayerId(), 0)
								ApplyWantedLevelChangeNow(GetPlayerId())
								DrawMessage("~y~Boat delivered", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
								EndMission()
							end
						end
					else
						DrawMessage("~r~Mission failed", "Boat destroyed.")
						EndMission()
					end
				end
			end
			if(IsPlayerDead(GetPlayerId())) then
				DrawMessage("~r~Mission failed", "You have died.")
				EndMission()
			end
		end
	end
end)