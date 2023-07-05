local coords = {
{
{1104.10071, 264.02542, 31.36295, 358.375732421875},
{1128.64636, 422.03195, 29.8626, 338.170349121094},
{1226.30615, 604.71936, 38.08655, 328.560913085938},
{1315.8717, 788.92908, 29.02226, 328.661193847656},
{1403.79883, 920.46332, 14.03866, 315.704223632813},
{1575.39368, 977.87921, 14.03944, 256.360290527344},
{1779.97974, 938.05511, 24.17869, 256.320495605469},
{1978.55151, 819.83362, 9.18187, 216.967559814453},
{2061.88794, 580.63281, 19.60613, 183.398666381836},
{2074.27319, 393.17813, 20.42556, 177.833999633789},
{2051.09863, 214.96873, 18.86116, 148.418243408203},
{1867.02136, 116.25735, 18.00099, 88.8822631835938},
{1755.59143, 193.80405, 23.49556, 43.9117736816406},
{1649.20386, 206.45055, 25.66823, 111.665885925293},
{1574.02856, 96.63984, 27.15474, 126.252662658691},
{1426.75159, -28.68206, 24.02266, 140.494537353516},
{1389.11682, -190.67236, 20.86169, 198.270629882813},
{1469.17688, -361.0408, 14.42799, 148.155517578125},
{1300.90747, -559.03638, 14.16078, 100.554595947266},
{1094.93225, -554.81842, 13.52539, 1.89969253540039},
{1095.17651, -402.59042, 17.82314, 336.672698974609},
{1138.20166, -316.5061, 18.22946, 15.0260343551636},
{1128.58594, -77.04958, 36.30084, 355.679931640625},
{1104.12793, 38.32746, 34.06294, 359.371337890625},
{1104.03918, 210.69803, 31.05324, 358.868194580078},
{1031.42676, 282.29541, 31.44826, 55.3653373718262}
},
{
{1078.44006, 296.22101, 31.03681, 87.4312362670898},
{900.36591, 270.54532, 42.5553, 88.2329559326172},
{606.84601, 272.1304, 43.8472, 89.164306640625},
{310.79553, 272.19501, 43.75595, 88.2434997558594},
{22.55995, 267.33774, 14.76958, 88.8172912597656},
{-225.72169, 267.34756, 14.87375, 88.4736862182617},
{-539.55219, 235.50232, 6.77607, 192.773620605469},
{-519.54565, -66.08124, 7.9053, 178.269821166992},
{-497.44501, -273.40717, 7.987, 223.106002807617},
{-342.65802, -390.84485, 4.96574, 205.259552001953},
{-236.6226, -710.52026, 4.81555, 177.293197631836},
{-110.71642, -791.08685, 5.23749, 262.770721435547},
{143.08501, -678.32703, 4.96153, 358.314331054688},
{177.32181, -416.42279, 14.80534, 268.812164306641},
{495.65045, -415.5997, 39.16133, 268.346862792969},
{909.58093, -421.59955, 37.45432, 242.605072021484},
{1043.02808, -405.40005, 18.73556, 31.0061893463135},
{1001.63361, -255.44347, 21.77018, 0.0539098270237446},
{957.19928, 23.87033, 25.58482, 326.402709960938},
{1030.31445, 282.96457, 31.44828, 56.31640625}
},
{
{1104.15234, 266.49185, 31.36391, 358.793579101563},
{1128.7998, 422.75607, 29.85993, 338.55224609375},
{1224.57825, 601.6189, 38.08561, 328.296020507813},
{1319.21973, 794.90173, 29.02232, 330.608917236328},
{1340.97864, 975.28754, 13.62413, 314.653503417969},
{1417.32947, 1315.90637, 11.6153, 358.221038818359},
{1417.34656, 1696.35327, 16.70223, 356.595703125},
{1293.97803, 1822.48071, 9.97502, 358.9853515625},
{1144.65808, 1889.6543, 10.89819, 87.9220962524414},
{1057.52148, 1931.26208, 13.77527, 94.0427703857422},
{847.21631, 1918.38, 37.68539, 92.0910568237305},
{675.21173, 1787.62952, 32.50979, 88.3636703491211},
{334.89218, 1757.47961, 17.31142, 180.131011962891},
{386.14487, 1574.38245, 16.32109, 198.436737060547},
{500.91833, 1355.35803, 11.87232, 200.78239440918},
{543.54761, 1035.58838, 20.92319, 176.491577148438},
{541.16016, 679.81732, 20.92258, 181.284027099609},
{798.30695, 617.4278, 38.6567, 268.56982421875},
{1208.8772, 599.28729, 37.88055, 149.198165893555},
{1116.83716, 424.73743, 29.87162, 162.837966918945},
{1030.40894, 282.94809, 31.44827, 55.5391273498535}
}
}

local mainjobblip = nil
local jobblip = nil
local bus = nil
local route = 0
local coord = 0
local tempdist = 0
CreateThread(function()
	while true do
		Wait(0)
		if(not DoesBlipExist(mainjobblip)) then
			mainjobblip = AddBlipForCoord(1034.09448, 298.09409, 32.03739, _i)
			ChangeBlipSprite(mainjobblip, 58)
			ChangeBlipColour(mainjobblip, 19)
			ChangeBlipScale(mainjobblip, 0.7)
			ChangeBlipNameFromAscii(mainjobblip, "Bus driver")
			SetBlipAsShortRange(mainjobblip, true)
		end
		DrawTextAtCoord(1034.09448, 298.09409, 32.03739, "Bus_driver", 20)
		DrawCheckpointWithDist(1034.09448, 298.09409, 32.03739-1, 1.1, 255, 255, 0, 100)
		if(IsPlayerNearCoords(1034.09448, 298.09409, 32.03739, 0.5)) then
			if(IsCarDead(bus)) then
				PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~start bus driver job", 1000, 1)
				if(IsGameKeyboardKeyJustPressed(18)) then
					if(missionstarted == 0) then
						local tempitems = {}
						for i=1,#coords,1 do
							tempitems[i] = "Route " .. i
						end
						DrawWindow("Select_route", tempitems)
						while menuactive do
							Wait(0)
						end
						if(menuresult > 0) then
							DeleteCar(bus)
							bus = SpawnCar(GetHashKey("bus"), 1031.39563, 285.04279, 31.44827, 234.692260742188)
							WarpCharIntoCar(GetPlayerChar(GetPlayerId()), bus)
							route = menuresult
							jobblip = AddBlipForCoord(coords[route][1][1], coords[route][1][2], coords[route][1][3])
							SetRoute(jobblip, true)
							coord = 1
							local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
							tempdist = GetDistanceBetweenCoords3d(px, py, pz, coords[route][1][1], coords[route][1][2], coords[route][1][3])
							SetObjective("Follow ~y~the route")
							TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
							missionstarted = 1
						end
					else
						TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Mission in progress!')
					end
				end
			else
				PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~finish bus driver job", 1000, 1)
				if(IsGameKeyboardKeyJustPressed(18)) then
					DeleteCar(bus)
					RemoveBlip(busblip)
					SetObjective("")
					missionstarted = 0
				end
			end
		end
		if(DoesVehicleExist(bus)) then
			if(not IsCarDead(bus)) then
				local bp = GetBlipCoords(jobblip)
				DrawCheckpoint(bp.x, bp.y, bp.z-1, 2.1, 255, 255, 0, 100)
				if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
					if(IsCharInCar(GetPlayerChar(GetPlayerId()), bus)) then
						if(coord ~= #coords[route]) then
							coord = coord + 1
							local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
							tempdist = tempdist + GetDistanceBetweenCoords3d(px, py, pz, coords[route][coord][1], coords[route][coord][2], coords[route][coord][3])
							SetBlipCoordinates(jobblip, coords[route][coord][1], coords[route][coord][2], coords[route][coord][3])
							SetRoute(jobblip, true)
						else
							coord = 0
							RemoveBlip(jobblip)
							local finalreward = {math.floor(tempdist/1000*50), math.floor(tempdist/1000*70)}
							money = money + finalreward[1]
							experience = experience + finalreward[2]
							SaveStats()
							DrawSignalAttached("+" .. finalreward[1] .. "$ +" .. finalreward[2] .. "EXP")
							DrawMessage("~y~Route completed", "The route has been finished (+" .. finalreward[1] .. "$ +" .. finalreward[2] .. "EXP).")
							busPassed = busPassed + 1
							SaveDailyStats()
							SetObjective("")
							missionstarted = 0
						end
					end
				end
				if(IsPlayerDead(GetPlayerId())) then
					RemoveBlip(jobblip)
					DrawMessage("~r~Mission failed", "You have died.")
					SetObjective("")
					missionstarted = 0
				end
			else
				RemoveBlip(jobblip)
				DrawMessage("~r~Mission failed", "Bus destroyed.")
				SetObjective("")
				missionstarted = 0
			end
		end
	end
end)