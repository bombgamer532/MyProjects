local basecoords = {
--{base, type, start, {checks}}
{{-224.08449, -100.58294, 14.62134, 92.0907440185547, 0}, 0, {-283.35794, -104.59518, 390.62976, 186.211166381836, 0}, 
{
{-281.30243, -123.4837, 366.62976, 186.211166381836, 0},
{-326.08951, -162.6226, 288.62976, 56.2104797363281, 0},
{-357.48593, -56.06352, 207.62976, 336.210418701172, 0},
{-208.46718, 80.47245, 100.62976, 1.21032702922821, 0},
{-203.51561, 261.33768, 14.87694, 358.134368896484, 0}
}},
{{174.18079, -642.17462, 8.11913, 359.327758789063, 0}, 0, {152.51074, -614.59485, 263.22617, 89.6731796264648, 0}, 
{
{129.84647, -617.63904, 221.22617, 108.71418762207, 0},
{114.10602, -714.58331, 150.22617, 203.713989257813, 0},
{268.22842, -773.896, 50.22617, 303.713928222656, 0},
{368.27911, -730.586, 4.69671, 330.284210205078, 0}
}},
{{1120.43103, 76.30985, 35.45176, 221.81298828125, 0}, 1, {1117.22449, -5.49316, 759.45178, 181.813049316406, 0}, 
{
{1158.71448, -108.28165, 687.45178, 246.813171386719, 0},
{1078.89697, -262.13907, 524.45178, 91.81298828125, 0},
{1056.64978, -485.75217, 378.45178, 176.812652587891, 0},
{901.02405, -640.62689, 219.45178, 131.812591552734, 0},
{765.10773, -761.32391, 5.76654, 74.8096160888672, 0}
}},
{{-1288.02869, 885.87408, 19.9724, 0.16591340303421, 0}, 0, {-1291.42432, 930.96851, 173.86656, 359.611206054688, 0}, 
{
{-1291.56506, 955.48132, 143.86656, 356.480743408203, 0},
{-1329.33667, 976.47443, 110.86656, 86.4806289672852, 0},
{-1374.22498, 939.89771, 19.8859, 177.369995117188, 0}
}},
{{2366.11401, 376.82944, 6.08523, 269.327239990234, 0}, 1, {2199.69556, 439.89203, 875.08521, 79.32666015625, 0}, 
{
{2089.09595, 392.49319, 796.08521, 94.326530456543, 0},
{1946.09534, 523.59009, 682.08521, 59.3264579772949, 0},
{1896.40332, 708.76349, 528.08521, 34.3264427185059, 0},
{1706.82581, 765.36713, 300.08521, 94.3263702392578, 0},
{1568.1554, 881.0318, 165.08521, 79.3261795043945, 0},
{1497.5061, 912.47687, 15.68451, 133.605560302734, 0}
}}
}

local basemainblip = {}
local currbase = 0
local check = 0
local amount = 0
local baseblip = nil
local baseblip2 = nil
local heli = nil
CreateThread(function()
	while true do
		Wait(0)
		for i=1,#basecoords,1 do
			if(not DoesBlipExist(basemainblip[i])) then
				basemainblip[i] = AddBlipForCoord(basecoords[i][1][1], basecoords[i][1][2], basecoords[i][1][3])
				ChangeBlipSprite(basemainblip[i], 72)
				ChangeBlipColour(basemainblip[i], 19)
				ChangeBlipScale(basemainblip[i], 0.7)
				ChangeBlipNameFromAscii(basemainblip[i], "Basejumping " .. i)
				SetBlipAsShortRange(basemainblip[i], true)
			end
			DrawCheckpointWithDist(basecoords[i][1][1], basecoords[i][1][2], basecoords[i][1][3]-1, 1.1, 255, 255, 0, 100)
			if(IsPlayerNearCoords(basecoords[i][1][1], basecoords[i][1][2], basecoords[i][1][3], 1)) then
				PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~start basejumping", 1000, 1)
				if(IsGameKeyboardKeyJustPressed(18)) then
					if(missionstarted == 0) then
						if(basecoords[i][2] == 0) then
							SetCharCoordinates(GetPlayerChar(GetPlayerId()), basecoords[i][3][1], basecoords[i][3][2], basecoords[i][3][3]-1)
							SetCharHeading(GetPlayerChar(GetPlayerId()), basecoords[i][3][4])
						elseif(basecoords[i][2] == 1) then
							heli = SpawnCar(GetHashKey("maverick"), basecoords[i][3][1], basecoords[i][3][2], basecoords[i][3][3], basecoords[i][3][4])
							SetHeliBladesFullSpeed(heli)
							FreezeCarPosition(heli, true)
							WarpCharIntoCar(GetPlayerChar(GetPlayerId()), heli)
						end
						exports.parachute:setParachute(true)
						StartCountdown()
						currbase = i
						check = 1
						amount = 0
						baseblip = AddBlipForCoord(basecoords[currbase][4][check][1], basecoords[currbase][4][check][2], basecoords[currbase][4][check][3])
						baseblip2 = AddBlipForCoord(basecoords[currbase][4][check+1][1], basecoords[currbase][4][check+1][2], basecoords[currbase][4][check+1][3])
						ChangeBlipScale(baseblip2, 0.5)
						TriggerEvent('chatMessage', '[Basejumping]', {255, 255, 0}, 'Basejumping started!')
						missionstarted = 1
					else
						TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Mission in progress!')
					end
				end
			end
		end
		if(DoesBlipExist(baseblip)) then
			if(not IsPlayerDead(GetPlayerId())) then
				local bp = GetBlipCoords(baseblip)
				if(check ~= #basecoords[currbase][4]) then
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 10.1, 255, 255, 0, 100)
					local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
					if(pz >= bp.z) then
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 5.1)) then
							RemoveBlip(baseblip)
							RemoveBlip(baseblip2)
							check = check + 1
							baseblip = AddBlipForCoord(basecoords[currbase][4][check][1], basecoords[currbase][4][check][2], basecoords[currbase][4][check][3])
							if(basecoords[currbase][4][check+1] ~= nil) then
								baseblip2 = AddBlipForCoord(basecoords[currbase][4][check+1][1], basecoords[currbase][4][check+1][2], basecoords[currbase][4][check+1][3])
								ChangeBlipScale(baseblip2, 0.5)
							end
							amount = amount + 1
						end
					else
						RemoveBlip(baseblip)
						RemoveBlip(baseblip2)
						check = check + 1
						baseblip = AddBlipForCoord(basecoords[currbase][4][check][1], basecoords[currbase][4][check][2], basecoords[currbase][4][check][3])
						if(basecoords[currbase][4][check+1] ~= nil) then
							baseblip2 = AddBlipForCoord(basecoords[currbase][4][check+1][1], basecoords[currbase][4][check+1][2], basecoords[currbase][4][check+1][3])
							ChangeBlipScale(baseblip2, 0.5)
						end
					end
				else
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 20.1, 255, 0, 0, 100)
					if(GetCharHeightAboveGround(GetPlayerChar(GetPlayerId())) <= 1.1) then
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z-1, 10.1)) then
							RemoveBlip(baseblip)
							DeleteCar(heli)
							local finalreward = {}
							local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
							local dist = 10 - GetDistanceBetweenCoords2d(px, py, bp.x, bp.y)
							finalreward[1] = math.floor(100*dist + 100*amount)
							finalreward[2] = math.floor(20*dist + 20*amount)
							money = money + finalreward[1]
							experience = experience + finalreward[2]
							SaveStats()
							DrawMessage("~y~Basejumping completed", "Checkpoints collected: " .. amount .. ". Accuracy is " .. math.floor(dist*10) .. "%. You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP.")
							--exports.parachute:setParachute(false)
							missionstarted = 0
						else
							RemoveBlip(baseblip)
							DeleteCar(heli)
							DrawMessage("~r~Basejumping failed", "Landing point missed.")
							missionstarted = 0
						end
					end
				end
			else
				RemoveBlip(baseblip)
				RemoveBlip(baseblip2)
				DeleteCar(heli)
				currbase = 0
				check = 0
				missionstarted = 0
				DrawMessage("~r~Basejumping failed", "You died.")
				exports.parachute:setParachute(false)
			end
		end
	end
end)