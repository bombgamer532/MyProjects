local racecoords = {
{{-590.67426, 1416.15137, 9.88483, 340.616668701172}, {-597.94171, 1385.30896, 8.14084, 347.517242431641}},
{{-476.01187, 228.96767, 9.86433, 1.65168762207031}, {-467.44879, 261.32516, 9.90827, 269.684265136719}},
{{1335.30139, 892.88434, 13.76129, 280.878570556641}, {1391.86328, 908.65686, 14.03881, 310.152709960938}},
{{-1485.82654, 1413.13184, 13.05528, 307.792510986328}, {-1486.66309, 1421.59326, 13.05529, 266.333343505859}},
{{1022.24286, 1536.45667, -0.61369, 13.371485710144, 0}, {1003.84845, 1478.4989, -0.56772, 160.868377685547, 0}},
{{-763.06982, -769.09869, -0.72776, 184.200088500977, 0}, {-756.06262, -836.53723, -0.61597, 181.664749145508, 0}},
{{-994.41522, 558.83344, -0.33391, 245.156066894531, 0}, {-923.64954, 496.31879, -0.25955, 225.022598266602, 0}}
}
local check = 0
local checks = {
{
{-596.05737, 1427.06104, 9.97801, 348.642822265625},
{-566.20441, 1558.84802, 10.00869, 351.206756591797},
{-529.88806, 1773.46045, 4.40182, 342.610717773438},
{-450.08478, 1798.78308, 4.46688, 301.322937011719},
{-428.24918, 1851.51343, 4.4556, 327.183746337891},
{-365.53348, 1857.42151, 4.42699, 250.95068359375},
{-323.87491, 1769.73254, 7.5654, 235.206298828125},
{-213.99028, 1748.47729, 7.53717, 270.536987304688},
{-77.7653, 1739.05212, 7.56449, 229.118789672852},
{-8.89281, 1628.95764, 3.79932, 203.091079711914},
{29.8637, 1526.20068, 5.01759, 186.303237915039},
{58.75298, 1409.88232, 3.32623, 228.173568725586},
{121.15607, 1346.15466, 3.00281, 190.077941894531},
{183.68306, 1220.65686, 2.5051, 229.9189453125},
{221.99623, 1147.08643, 5.93207, 178.085250854492},
{206.19025, 1060.5072, 5.9225, 178.522247314453},
{205.73463, 893.90051, 5.95377, 177.606460571289},
{199.43079, 752.94238, 4.68603, 170.780166625977},
{193.87283, 709.57758, 4.68604, 176.807601928711}
},
{
{-385.93729, 261.42776, 14.75518, 266.804870605469},
{-363.80536, 281.68579, 14.81012, 357.766357421875},
{-363.73318, 502.45062, 14.82842, 358.078277587891},
{-363.7085, 722.729, 14.76789, 357.494232177734},
{-363.70883, 950.73425, 14.76721, 357.248138427734},
{-363.76169, 1146.25317, 14.82218, 357.374572753906},
{-344.09338, 1167.64197, 14.82263, 267.64990234375},
{-68.82166, 1167.60901, 14.82196, 268.613220214844},
{-49.2744, 1148.2854, 14.82264, 177.624740600586},
{-49.28349, 1026.03845, 14.76689, 177.929016113281},
{-29.51852, 1011.59906, 14.7758, 267.888122558594},
{67.85165, 1011.58014, 14.76712, 268.403137207031},
{210.0679, 1004.57098, 14.96391, 266.768432617188},
{428.22308, 999.2652, 26.86647, 260.547180175781},
{543.013, 894.50153, 20.92326, 178.286117553711},
{541.71777, 692.35052, 20.92315, 178.235382080078},
{637.69922, 617.40289, 20.57829, 267.597229003906},
{821.03925, 617.48334, 38.63322, 268.107208251953},
{1026.77295, 624.27942, 38.52702, 268.303619384766},
{1191.6814, 624.38898, 38.86295, 267.071014404297},
{1212.33228, 593.65869, 37.73826, 147.207229614258},
{1127.0144, 435.31702, 29.78749, 157.113830566406},
{1099.78687, 325.22446, 30.35549, 170.800933837891},
{1080.43091, 296.24377, 31.02781, 88.0196228027344},
{911.44208, 270.83881, 43.13264, 88.8893890380859},
{678.50214, 271.88446, 42.33829, 87.3860092163086},
{492.87006, 272.24506, 44.92643, 88.7424240112305},
{314.2869, 272.20291, 43.91487, 88.3307647705078},
{23.85868, 261.3743, 14.77254, 87.6313705444336},
{-224.55005, 261.31662, 14.86491, 87.9663467407227},
{-362.31824, 261.16766, 14.8064, 86.9528121948242}
},
{
{1467.61487, 974.70532, 14.03913, 291.390655517578},
{1627.1925, 967.75043, 14.09858, 256.729553222656},
{1846.45361, 919.69128, 24.1796, 244.403137207031},
{1954.59436, 847.82031, 9.8854, 220.391067504883},
{2055.01367, 766.29944, 10.95603, 217.961288452148},
{2138.4873, 652.60779, 13.14056, 223.467697143555},
{2268.15698, 571.90735, 6.10458, 255.631500244141},
{2333.83081, 513.8324, 5.95144, 251.680572509766},
{2414.50366, 509.23093, 6.10438, 237.451553344727},
{2448.54175, 356.95602, 6.10478, 168.381500244141},
{2403.29736, 261.7236, 5.81273, 179.050277709961},
{2456.20703, 193.16718, 5.81284, 229.986999511719},
{2409.4248, 85.96574, 5.83806, 137.151962280273},
{2305.59277, 66.81558, 5.81422, 90.9269943237305},
{2231.78247, 80.20607, 5.81284, 88.1301956176758},
{2134.13794, 80.74532, 5.81507, 90.0212631225586},
{2122.77197, 139.34698, 5.81517, 356.986572265625},
{2161.61548, 170.50879, 5.81526, 268.095367431641},
{2232.00781, 170.63127, 5.81285, 270.460906982422},
{2237.99976, 189.33302, 5.90428, 358.620758056641},
{2178.88794, 228.12814, 5.93163, 50.5063362121582},
{2056.80762, 258.94107, 5.70532, 90.0305786132813},
{1958.63269, 271.15482, 5.00509, 88.1475143432617},
{1809.948, 274.81165, 6.28005, 81.05810546875},
{1643.65186, 295.23499, 8.89247, 72.5084686279297},
{1498.12488, 329.79407, 16.22015, 92.7943267822266},
{1302.97632, 293.21283, 28.41125, 84.3801422119141},
{1174.89233, 260.70978, 37.70731, 103.489768981934},
{1002.85406, 265.32779, 48.87196, 76.5412368774414},
{862.94592, 271.58759, 41.1499, 87.8722534179688},
{577.7207, 272.03253, 44.1987, 87.9108581542969},
{296.5239, 272.20709, 43.1078, 87.3605422973633},
{40.19825, 261.42636, 14.75126, 88.5373840332031}
},
{
{-1467.43213, 1445.74817, 12.82863, 357.445983886719},
{-1436.4397, 1570.27893, 16.19304, 341.112243652344},
{-1393.30994, 1706.09668, 18.24325, 358.650817871094},
{-1263.0592, 1809.64233, 18.65548, 266.824005126953},
{-1066.72607, 1809.50879, 8.32035, 269.359924316406},
{-999.9765, 1778.14612, 10.11861, 154.589752197266},
{-1041.70862, 1780.06506, 13.52853, 80.1913070678711},
{-1145.07996, 1774.7395, 28.36912, 109.886650085449},
{-1191.66455, 1717.68457, 32.79961, 88.1338043212891},
{-1315.30554, 1713.72021, 27.71056, 119.390617370605},
{-1319.05603, 1613.49353, 27.82163, 267.139923095703},
{-1076.84583, 1615.31238, 34.65527, 261.028656005859},
{-997.25873, 1586.30066, 23.93446, 317.512329101563},
{-940.79437, 1586.19287, 23.90274, 227.281326293945},
{-925.69104, 1423.56836, 25.03194, 177.693817138672},
{-957.94519, 1345.5874, 24.7515, 205.575210571289},
{-925.71332, 1245.81262, 23.30565, 268.184936523438},
{-900.92688, 1184.10608, 18.144, 178.477432250977},
{-920.8512, 1169.46667, 17.88233, 88.4049606323242},
{-1084.17786, 1170.28003, 29.42963, 87.9573593139648},
{-1357.09839, 1170.29785, 30.66881, 87.8902282714844},
{-1546.36426, 1148.91833, 30.66919, 117.710952758789},
{-1640.83118, 1027.1095, 30.6689, 151.318572998047},
{-1638.01465, 934.58685, 30.66841, 204.453247070313},
{-1678.57227, 820.02966, 30.6033, 124.333381652832},
{-1767.60303, 688.06116, 28.62806, 177.488784790039},
{-1768.38818, 556.1228, 24.08654, 174.377883911133},
{-1858.38867, 375.46167, 22.85318, 140.212646484375},
{-1996.92761, 180.1548, 25.40676, 168.301742553711},
{-1964.86938, 9.19004, 28.15128, 214.277236938477},
{-1855.11609, -172.14024, 51.17933, 202.861328125},
{-1806.45667, -365.73407, 51.22238, 177.277282714844},
{-1705.37744, -493.91705, 51.26852, 262.5419921875},
{-1643.77893, -500.75507, 51.24902, 267.965087890625},
{-1479.35608, -484.20935, 51.22435, 297.366485595703},
{-1415.55322, -307.12894, 51.22489, 357.492095947266},
{-1409.18665, 22.72493, 51.18249, 357.773468017578},
{-1412.82483, 184.14012, 51.16895, 344.081756591797},
{-1307.95557, 273.84515, 51.18098, 307.232635498047},
{-1276.69263, 480.80087, 51.18147, 356.565643310547},
{-1241.25146, 755.92102, 19.73322, 350.378082275391},
{-1240.00952, 967.53351, 19.6203, 358.237823486328}
},
{
{882.16003, 1217.81128, -0.74978, 93.9379043579102, 0},
{355.61548, 1139.9137, -0.25597, 180.510711669922, 0},
{318.72568, 397.49472, -0.55314, 162.374389648438, 0},
{564.63464, -215.60477, -0.20873, 338.638671875, 0},
{687.14569, 716.05005, -0.45814, 3.55110788345337, 0}
},
{
{-680.84729, -1057.16333, -0.32526, 245.067947387695, 0},
{-506.61334, -1135.58325, -0.50874, 324.584838867188, 0},
{-377.54611, -998.90179, -0.27439, 359.895355224609, 0},
{-910.78088, -9.92099, -0.80071, 348.517883300781, 0},
{-760.91345, 786.62531, -0.73378, 349.820129394531, 0},
{-690.06805, 1490.81592, -0.31527, 355.670623779297, 0},
{-473.3992, 1836.96118, -0.73761, 232.06217956543, 0}
},
{
{-902.86938, -7.26209, -0.55814, 193.576919555664, 0},
{-867.72186, -404.80408, -0.26904, 180.519302368164, 0},
{-1073.62195, -632.52765, -0.56421, 141.53385925293, 0},
{-1257.71606, -734.14191, -0.88137, 95.2243804931641, 0},
{-1674.88879, -712.21533, -0.57827, 114.926986694336, 0},
{-2013.93872, -710.47156, -0.42287, 60.6562156677246, 0},
{-2084.0293, -484.75177, -0.46562, 19.9682903289795, 0},
{-2059.05322, -177.3802, -0.72052, 310.276580810547, 0},
{-1737.1449, -148.65887, -0.855, 265.276550292969, 0},
{-1376.50964, -150.21323, -0.58444, 266.712493896484, 0}
}
}

local restimer = 0
local racemainblip = {}
local raceblip = {}
CreateThread(function()
	while true do
		Wait(0)
		for i=1,#racecoords,1 do
			if(not DoesBlipExist(racemainblip[i])) then
				racemainblip[i] = AddBlipForCoord(racecoords[i][1][1], racecoords[i][1][2], racecoords[i][1][3], _i)
				ChangeBlipSprite(racemainblip[i], 65)
				ChangeBlipScale(racemainblip[i], 0.7)
				ChangeBlipNameFromAscii(racemainblip[i], "Race " .. i)
				SetBlipAsShortRange(racemainblip[i], true)
			end
			if(gamemode == 0) then
				DrawTextAtCoord(racecoords[i][1][1], racecoords[i][1][2], racecoords[i][1][3], "Race_" .. i, 20)
				DrawCheckpointWithAlpha(racecoords[i][1][1], racecoords[i][1][2], racecoords[i][1][3]-1, 10.1, 255, 255, 0, 100)
				if(IsPlayerNearCoords(racecoords[i][1][1], racecoords[i][1][2], racecoords[i][1][3], 5)) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~start race", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						if(missionstarted == 0) then
							if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
								if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i) == GetPlayerChar(GetPlayerId())) then
									local racers = {}
									for j=0,31,1 do
										if(IsNetworkPlayerActive(j)) then
											if(IsSpecificPlayerNearCoords(j, racecoords[i][1][1], racecoords[i][1][2], racecoords[i][1][3], 5)) then
												if(IsCharInAnyCar(GetPlayerChar(j, _i))) then
													if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(j, _i), _i), _i) == GetPlayerChar(j, _i)) then
														racers[#racers+1] = j
													end
												end
											end
										end
									end
									if(#racers >= 2) then
										for k=1,#racers,1 do
											local step = 0
											for j=3,33,3 do
												if(k > j) then
													step = step + 1
												end
											end
											if(k==1 or k==4 or k==7 or k==10 or k==13 or k==16 or k==19 or k==22 or k==25 or k==28 or k==31) then
												TriggerServerEvent('setPlayerPos', racers[k], racecoords[i][2][1]+5*step*math.cos((racecoords[i][2][4]-90)*math.pi/180), racecoords[i][2][2]+5*step*math.sin((racecoords[i][2][4]-90)*math.pi/180), racecoords[i][2][3], racecoords[i][2][4])
											elseif(k==2 or k==5 or k==8 or k==11 or k==14 or k==17 or k==20 or k==23 or k==26 or k==29 or k==32) then
												TriggerServerEvent('setPlayerPos', racers[k], racecoords[i][2][1]+5*step*math.cos((racecoords[i][2][4]-90)*math.pi/180)+3*math.cos((racecoords[i][2][4]+180)*math.pi/180), racecoords[i][2][2]+5*step*math.sin((racecoords[i][2][4]-90)*math.pi/180)+3*math.sin((racecoords[i][2][4]+180)*math.pi/180), racecoords[i][2][3], racecoords[i][2][4])
											elseif(k==3 or k==6 or k==9 or k==12 or k==15 or k==18 or k==21 or k==24 or k==27 or k==30 or k==33) then
												TriggerServerEvent('setPlayerPos', racers[k], racecoords[i][2][1]+5*step*math.cos((racecoords[i][2][4]-90)*math.pi/180)+3*math.cos((racecoords[i][2][4]-0)*math.pi/180), racecoords[i][2][2]+5*step*math.sin((racecoords[i][2][4]-90)*math.pi/180)+3*math.sin((racecoords[i][2][4]-0)*math.pi/180), racecoords[i][2][3], racecoords[i][2][4])
											end
											TriggerServerEvent('startRace', i, racers[k])
										end
									else
										TriggerEvent('chatMessage', '[Race]', {255, 0, 0}, 'There must be at least 2 players in the circle to start race!')
									end
								else
									TriggerEvent('chatMessage', '[Race]', {255, 0, 0}, 'You must be a driver of this car to start race!')
								end
							else
								TriggerEvent('chatMessage', '[Race]', {255, 0, 0}, 'You must be in a car to start race!')
							end
						else
							TriggerEvent('chatMessage', '[Deathmatch]', {255, 0, 0}, 'Mission in progress!')
						end
					end
				end
			end
		end
		if(gamemode == 3) then
			if(not IsPlayerDead(GetPlayerId())) then
				if(IsPlayerControlOn(GetPlayerId())) then
					if(not IsGameKeyboardKeyPressed(19)) then
						DrawRectLeftTopCenter(0.9, 0.9, 0.08, 0.05, 0, 0, 0, 100)
						SetTextScale(0.1500000, 0.4000000)
						SetTextDropshadow(0, 0, 0, 0, 0)
						SetTextEdge(1, 0, 0, 0, 255)
						DisplayTextWithLiteralString(0.905, 0.91, "STRING", "Checkpoint: ~y~" .. check .. "/" .. #checks[raceid])
					end
					if(IsGameKeyboardKeyPressed(19)) then
						if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
							DrawRectLeftTopCenter(0.9, 0.9, 0.05, 0.02, 0, 0, 0, 100)
							DrawRectLeftTopCenter(0.9, 0.9, 0.05/100*restimer, 0.02, 0, 0, 100, 255)
							SetTextScale(0.1500000, 0.3000000)
							SetTextDropshadow(0, 0, 0, 0, 0)
							SetTextEdge(1, 0, 0, 0, 255)
							DisplayTextWithLiteralString(0.9, 0.87, "STRING", "Hold ~y~R ~w~to ~y~respawn")
						else
							SetTextScale(0.1500000, 0.3000000)
							SetTextDropshadow(0, 0, 0, 0, 0)
							SetTextEdge(1, 0, 0, 0, 255)
							DisplayTextWithLiteralString(0.9, 0.87, "STRING", "~y~You must be in a car")
						end
					else
						restimer = 0
					end
				end
			else
				RemoveBlip(raceblip[1])
				RemoveBlip(raceblip[2])
				gamemode = 0
				TriggerEvent('chatMessage', '[Race]', {255, 0, 0}, 'You are dead. Race failed!')
				while IsPlayerDead(GetPlayerId()) do
					Wait(0)
				end
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(gamemode == 3) then
			if(IsGameKeyboardKeyPressed(19)) then
				if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
					if(IsPlayerControlOn(GetPlayerId())) then
						restimer = restimer + 1
						if(restimer >= 100) then
							if(check > 1) then
								SetCarCoordinates(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), checks[raceid][check-1][1], checks[raceid][check-1][2], checks[raceid][check-1][3])
								SetCarHeading(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), checks[raceid][check-1][4])
								SetCarOnGroundProperly(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i))
								FixCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i))
							else
								SetCarCoordinates(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), racecoords[raceid][2][1], racecoords[raceid][2][2], racecoords[raceid][2][3])
								SetCarHeading(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), racecoords[raceid][2][4])
								SetCarOnGroundProperly(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i))
								FixCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i))
							end
							restimer = 0
						end
						--Wait(3)
					end
				end
			end
		end
	end
end)

local racepos = 1
local count = 0
RegisterNetEvent('startRace')
AddEventHandler('startRace', function(rid, id)
	CreateThread(function()
		if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
			TriggerServerEvent('sendMessageToEveryone', '[Race]', '' .. GetPlayerName(GetPlayerId(), _s) .. ' has joined Race ' .. rid .. '.')
			check = 0
			gamemode = 3
			raceid = rid
			racepos = 1
			RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
			--[[SetPlayerControl(GetPlayerId(), false)
			count = 3
			Wait(1000)
			count = 2
			Wait(1000)
			count = 1
			Wait(1000)
			count = -1
			SetPlayerControl(GetPlayerId(), true)]]
			StartCountdown()
			check = 1
			--Wait(1000)
			--count = 0
		end
	end)
end)

CreateThread(function()
	while true do
		Wait(0)
		if(count > 0) then
			DrawRectLeftTopCenter(0.45, 0.3, 0.1, 0.15, 0, 0, 0, 100)
			SetTextScale(0.500000, 1.0000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextFont(4)
			SetTextCentre(1)
			DisplayTextWithLiteralString(0.5, 0.34, "STRING", "~r~" .. count)
		elseif(count == -1) then
			DrawRectLeftTopCenter(0.45, 0.3, 0.1, 0.15, 0, 0, 0, 100)
			SetTextScale(0.400000, 0.8000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextFont(4)
			SetTextCentre(1)
			DisplayTextWithLiteralString(0.5, 0.34, "STRING", "~r~GO")
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(gamemode == 3) then
			if(check > 0) then
				if(not DoesBlipExist(raceblip[1])) then
					raceblip[1] = AddBlipForCoord(checks[raceid][check][1], checks[raceid][check][2], checks[raceid][check][3], _i)
					if(check == #checks[raceid]) then
						--ChangeBlipSprite(raceblip[1], 65)
						--ChangeBlipScale(raceblip[1], 0.5)
					end
				end
				DrawCheckpointWithAlpha(checks[raceid][check][1], checks[raceid][check][2], checks[raceid][check][3]-1, 3.1, 0, 0, 255, 100)
				if(checks[raceid][check+1] ~= nil) then
					if(not DoesBlipExist(raceblip[2])) then
						raceblip[2] = AddBlipForCoord(checks[raceid][check+1][1], checks[raceid][check+1][2], checks[raceid][check+1][3], _i)
						if(check+1 == #checks[raceid]) then
							--ChangeBlipSprite(raceblip[2], 65)
							--ChangeBlipScale(raceblip[2], 0.5)
						end
					end
					DrawCheckpointWithAlpha(checks[raceid][check+1][1], checks[raceid][check+1][2], checks[raceid][check+1][3]-1, 3.1, 0, 0, 255, 50)
				end
				if(IsPlayerNearCoords(checks[raceid][check][1], checks[raceid][check][2], checks[raceid][check][3], 5)) then
					RemoveBlip(raceblip[1])
					RemoveBlip(raceblip[2])
					if(check ~= #checks[raceid]) then
						check = check + 1
						local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
						DrawSignalAttached("+50$ +25EXP")
						money = money + 50
						experience = experience + 25
						SaveStats()
						--TriggerEvent('chatMessage', '', {0, 255, 0}, '+50$/+25 EXP')
					else
						local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
						DrawSignalAttached("+" .. math.floor(4000/racepos) .. "$ +" .. math.floor(250/racepos) .. "EXP")
						money = money + math.floor(4000/racepos)
						experience = experience + math.floor(250/racepos)
						SaveStats()
						TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has finished ' .. racepos .. '! (+' .. math.floor(4000/racepos) .. '$/+' .. math.floor(250/racepos) .. ' EXP)')
						TriggerServerEvent('finishRound', 3, raceid)
						Wait(5000)
						gamemode = 0
						RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
						for i=1,8,1 do
							GiveWeaponToChar(GetPlayerChar(GetPlayerId()), weps[i][1], weps[i][2], 1)
						end
					end
				end
			end
		else
			RemoveBlip(raceblip[1])
			RemoveBlip(raceblip[2])
		end
	end
end)

RegisterNetEvent('finishRound')
AddEventHandler('finishRound', function(id, modeid)
	if(gamemode == id) then
		if(id == 3) then
			if(raceid == modeid) then
				racepos = racepos + 1
				--gamemode = 0
			end
		end
	end
end)