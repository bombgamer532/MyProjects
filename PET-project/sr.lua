local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end

local count = 0
local targetshots = 0
local rangecoords = {
--{start, {targets}}
{{-1307.63049, 304.76132, 13.43661, 359.0205078125},
{
{-1312.73669, 312.0658, 14.81845, 212.127548217773},
{-1310.13062, 314.3887, 14.81846, 179.166809082031},
{-1304.86853, 314.57709, 14.81844, 177.766677856445},
{-1301.83667, 309.71024, 15.35577, 158.760192871094}
}},
{{105.22015, -368.34442, 14.76503, 337.74755859375},
{
{102.84203, -357.129, 14.764, 187.336288452148},
{112.38556, -358.02463, 14.76401, 155.03369140625},
{107.45763, -357.28888, 14.76401, 182.939224243164},
{113.39336, -365.728, 14.98735, 91.9000549316406}
}
},
{{1043.1344, 49.22543, 33.6464, 224.889678955078},
{
{1055.09314, 49.49638, 33.41436, 88.8138427734375},
{1050.79736, 44.74486, 33.54045, 90.1328125},
{1048.86121, 39.46542, 33.62165, 40.4618186950684},
{1042.93494, 38.84087, 33.60967, 1.76418316364288}
}
}
}

local mismainblip = {}
CreateThread(function()
	while true do
		Wait(0)
		for i=1,#rangecoords,1 do
			if(not DoesBlipExist(mismainblip[i])) then
				mismainblip[i] = AddBlipForCoord(rangecoords[i][1][1], rangecoords[i][1][2], rangecoords[i][1][3], _i)
				ChangeBlipSprite(mismainblip[i], 76)
				ChangeBlipScale(mismainblip[i], 0.7)
				ChangeBlipColour(mismainblip[i], 19)
				ChangeBlipNameFromAscii(mismainblip[i], "Shooting range (10)")
				SetBlipAsShortRange(mismainblip[i], true)
			end
			if(missionstarted == 0) then
				DrawTextAtCoord(rangecoords[i][1][1], rangecoords[i][1][2], rangecoords[i][1][3], "Shooting_range Level_10", 20)
				DrawCheckpointWithDist(rangecoords[i][1][1], rangecoords[i][1][2], rangecoords[i][1][3]-1, 1.1, 255, 255, 0, 100)
				if(IsPlayerNearCoords(rangecoords[i][1][1], rangecoords[i][1][2], rangecoords[i][1][3], 1)) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~start shooting targets ~w~(gun is required)", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						if(missionstarted == 0) then
							if(level >= 10) then
								local gw,cw = GetCurrentCharWeapon(GetPlayerChar(GetPlayerId()))
								if(cw >= 7) then
									targetshots = 0
									variation = i
									local rnd = GenerateRandomIntInRange(1, #rangecoords[i][2]+1)
									variation2 = rnd
									objs[1] = SpawnObject(GetHashKey("cj_dart_board_cab"), rangecoords[i][2][rnd][1], rangecoords[i][2][rnd][2], rangecoords[i][2][rnd][3]-0.5, rangecoords[i][2][rnd][4]-180)
									blips[1] = AddBlipForObject(objs[1])
									FreezeObjectPosition(objs[1], true)
									SetCharCoordinates(GetPlayerChar(GetPlayerId()), rangecoords[i][1][1], rangecoords[i][1][2], rangecoords[i][1][3]-1)
									SetCharHeading(GetPlayerChar(GetPlayerId()), rangecoords[i][1][4])
									FreezeCharPosition(GetPlayerChar(GetPlayerId()), true)
									StartCountdown()
									Settimera(0)
									SetObjective("Shoot ~y~targets ~w~until time is up (~y~200 ~w~seconds left)")
									TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Shooting started! Shoot as much targets as you can until time is up.')
									currmission = 1
									missionstarted = 1
								else
									TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'You must have a gun(firearm) in your hand!')
								end
							else
								TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'You must reach level 10!')
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
					AlterWantedLevel(GetPlayerId(), 0)
					ApplyWantedLevelChangeNow(GetPlayerId())
					if(Timera() < 200000) then
						SetObjective("Shoot ~y~targets ~w~until time is up (~y~" .. 200 - math.floor(Timera()/1000) .. " ~w~seconds left). ~y~" .. targetshots .. " ~w~targets shot")
						if(HasObjectBeenDamagedByChar(objs[1], GetPlayerChar(GetPlayerId()))) then
							ClearObjectLastDamageEntity(objs[1])
							targetshots = targetshots + 1
							local rnd = GenerateRandomIntInRange(1, #rangecoords[variation][2]+1, _i)
							while rnd==variation2 do
								rnd = GenerateRandomIntInRange(1, #rangecoords[variation][2]+1, _i)
							end
							variation2 = rnd
							SetObjectCoordinates(objs[1], rangecoords[variation][2][rnd][1], rangecoords[variation][2][rnd][2], rangecoords[variation][2][rnd][3]-0.5)
							SetObjectHeading(objs[1], rangecoords[variation][2][rnd][4]-180)
						end
					else
						FreezeCharPosition(GetPlayerChar(GetPlayerId()), false)
						local finalexp = 10*targetshots
						while targetshots>=10 do
							finalexp = finalexp + 20
							targetshots = targetshots - 10
						end
						experience = experience + finalexp
						SaveStats()
						DrawMessage("Time is up!", "You have got " .. finalexp .. " EXP")
						EndMission()
					end
				end
			end
			if(IsPlayerDead(GetPlayerId())) then
				FreezeCharPosition(GetPlayerChar(GetPlayerId()), false)
				DrawMessage("~r~Mission failed", "You have died.")
				EndMission()
			end
		end
	end
end)