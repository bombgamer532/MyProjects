local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end

local count = 0
local checkcollected = 0
local crcoords = {
{-196.93669, 1208.56311, 14.48088, 89.5987701416016},
{-173.27719, -588.92999, 4.81455, 89.2749404907227}
}

local mismainblip = {}
CreateThread(function()
	while true do
		Wait(0)
		for i=1,#crcoords,1 do
			if(not DoesBlipExist(mismainblip[i])) then
				mismainblip[i] = AddBlipForCoord(crcoords[i][1], crcoords[i][2], crcoords[i][3], _i)
				ChangeBlipSprite(mismainblip[i], 52)
				ChangeBlipScale(mismainblip[i], 0.7)
				ChangeBlipNameFromAscii(mismainblip[i], "Checkpoint race (20)")
				SetBlipAsShortRange(mismainblip[i], true)
			end
			if(missionstarted == 0) then
				DrawTextAtCoord(crcoords[i][1], crcoords[i][2], crcoords[i][3], "Checkpoint_race Level_20", 20)
				DrawCheckpointWithDist(crcoords[i][1], crcoords[i][2], crcoords[i][3]-1, 1.1, 255, 255, 0, 100)
				if(IsPlayerNearCoords(crcoords[i][1], crcoords[i][2], crcoords[i][3], 3)) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~start checkpoint race", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						if(missionstarted == 0) then
							if(level >= 20) then
								if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
									if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))) == GetPlayerChar(GetPlayerId())) then
										checkcollected = 0
										for i=1,50,1 do
											local rx,ry,rz,rh = GetRandomNodeInRadius(GenerateRandomIntInRange(100, 3000))
											blips[i] = AddBlipForCoord(rx, ry, rz)
										end
										SetCarCoordinates(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), crcoords[i][1], crcoords[i][2], crcoords[i][3])
										SetCarHeading(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), crcoords[i][4])
										StartCountdown()
										Settimera(0)
										SetCurrentObjective("Collect ~y~checkpoints ~w~until time is up (~y~200 ~w~seconds left)")
										TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Checkpoint race started!')
										currmission = 1
										missionstarted = 1
									else
										TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'You must be a driver of this car!')
									end
								else
									TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'You must be in a car!')
								end
							else
								TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'You must reach level 20!')
							end
						else
							TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Mission in progress!')
						end
					end
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
					if(Timera() < 200000) then
						SetCurrentObjective("Collect ~y~checkpoints ~w~until time is up (~y~" .. 200 - math.floor(Timera()/1000) .. " ~w~seconds left). ~y~" .. checkcollected .. " ~w~checkpoints collected")
						for i=1,50,1 do
							if(DoesBlipExist(blips[i])) then
								local bp = GetBlipCoords(blips[i])
								DrawCheckpointWithDist(bp.x, bp.y, bp.z, 1.1, 0, 0, 255, 100)
								if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
									RemoveBlip(blips[i])
									checkcollected = checkcollected + 1
								end
							end
						end
					else
						local finalexp = 50*checkcollected
						while checkcollected>=10 do
							finalexp = finalexp + 50
							checkcollected = checkcollected - 10
						end
						experience = experience + finalexp
						SaveStats()
						DrawMessage("Time is up!", "You have got " .. finalexp .. " EXP")
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