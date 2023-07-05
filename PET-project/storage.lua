techs = {0,0,0,0,0}
cargocooldown = {0,0,0,0}

RegisterNetEvent('updTechs')
AddEventHandler('updTechs', function(data)
	for i=1,#techs,1 do
		if(data[i] == nil) then
			data[i] = 0
		end
		techs[i] = tonumber(data[i])
	end
end)

SaveTechs = function()
	local data = {}
	for i=1,#techs,1 do
		data[i] = techs[i]
	end
	TriggerServerEvent('saveTechs', data)
end

local storageprice = 300000
local storageblip = nil

local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end

local cooldown = 0
CreateThread(function()
	while true do
		Wait(0)
		if(cooldown > 0) then
			Wait(1000)
			cooldown = cooldown - 1
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(not DoesBlipExist(storageblip)) then
			storageblip = AddBlipForCoord(695.12683, 1464.05505, 14.85285, _i)
			ChangeBlipSprite(storageblip, 82)
			ChangeBlipScale(storageblip, 0.7)
			ChangeBlipNameFromAscii(storageblip, "Storage")
			SetBlipAsShortRange(storageblip, true)
		end
		if(storage == 0) then
			DrawTextAtCoord(695.12683, 1464.05505, 14.85285, "Storage Price:_" .. storageprice .. "$ Level_needed:_50", 20)
			ChangeBlipColour(storageblip, 0)
		else
			DrawTextAtCoord(695.12683, 1464.05505, 14.85285, "Storage", 20)
			ChangeBlipColour(storageblip, 2)
		end
		DrawCheckpointWithDist(695.12683, 1464.05505, 14.85285-1, 1.1, 255, 255, 0, 100)
		if(IsPlayerNearCoords(695.12683, 1464.05505, 14.85285, 1)) then
			DrawDescription("Storage", {
			-----------------------------------------------------------------------------------------------
			"Storage lets you start cargo missions which let you receive and collect cargo. This cargo can",
			"be sold or spent to unlock some special abilities and weapons. Special abilities can be",
			"activated in \"Specials\" section of player menu."
			})
			if(storage == 0) then
				PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to purchase ~y~this storage ~w~for ~g~" .. storageprice .. "$", 1000, 1)
				if(IsGameKeyboardKeyJustPressed(18)) then
					if(level >= 50) then
						if(org > 0) then
							if(money >= storageprice) then
								money = money - storageprice
								storage = 1
								SaveStats()
								TriggerEvent('chatMessage', '[Storage]', {0, 255, 0}, 'This storage has been successfully purchased!')
							else
								TriggerEvent('chatMessage', '[Storage]', {255, 0, 0}, 'You cannot afford it!')
							end
						else
							TriggerEvent('chatMessage', '[Storage]', {255, 0, 0}, 'You must own an organization!')
						end
					else
						TriggerEvent('chatMessage', '[Storage]', {255, 0, 0}, 'You must reach level 50!')
					end
				end
			else
				PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~open storage menu", 1000, 1)
				if(IsGameKeyboardKeyJustPressed(18)) then
					::main::
					local tempitems = {}
					tempitems[#tempitems+1] = "Cargo: " .. cargo .. " ~g~(Click to sell 10 for 10000$)"
					tempitems[#tempitems+1] = "Start supply mission"
					tempitems[#tempitems+1] = "Ammunition upgrades"
					tempitems[#tempitems+1] = "Gun workshop"
					tempitems[#tempitems+1] = "Buy 3 cargo for ~g~3500$"
					DrawWindow("Storage", tempitems)
					while menuactive do
						Wait(0)
					end
					if(menuresult > 0) then
						if(tempitems[menuresult] == "Cargo: " .. cargo .. " ~g~(Click to sell 10 for 10000$)") then
							if(cargo >= 10) then
								cargo = cargo - 10
								money = money + 10000
								SaveStats()
								TriggerEvent('chatMessage', '[Cargo]', {0, 255, 0}, 'Cargo sold!')
							else
								TriggerEvent('chatMessage', '[Cargo]', {255, 0, 0}, 'Not enough cargo!')
							end
							goto main
						elseif(tempitems[menuresult] == "Start supply mission") then
							if(missionstarted == 0) then
								local rnd = GenerateRandomIntInRange(1, 5)
								if(rnd == 1) then
									local coords = {
									{
									{179.37694, -539.82104, 10.94544, 268.392150878906},
									{182.1749, -528.88177, 9.07294, 264.428771972656},
									{195.38593, -527.14441, 9.07368, 90.5752944946289},
									{191.74841, -518.93207, 11.13894, 18.9552516937256},
									{183.26848, -526.07275, 11.15017, 270.996459960938},
									{178.39011, -528.67975, 12.09558, 195.938629150391},
									{171.99747, -529.37476, 13.88631, 152.572250366211},
									{193.89571, -539.48511, 9.08281, 266.092315673828},
									{168.83229, -546.3515, 12.32263, 180.241470336914},
									{167.26402, -539.58014, 12.32218, 278.429016113281}
									},
									{
									{-1082.58435, -583.77521, 3.88147, 266.386627197266},
									{-1076.82861, -593.61328, 3.01527, 267.291839599609},
									{-1065.06714, -596.14893, 3.01527, 265.660095214844},
									{-1078.14783, -557.80518, 2.88365, 4.42104196548462},
									{-1065.03772, -557.56219, 2.85199, 279.175231933594},
									{-1059.62708, -571.80237, 2.85199, 260.921234130859},
									{-1043.11755, -561.11169, 2.85199, 162.461868286133},
									{-1042.56677, -598.36334, 2.85195, 267.191497802734},
									{-1026.69409, -570.47638, 3.0156, 177.592712402344},
									{-1012.58655, -578.58063, 2.85218, 103.021064758301}
									},
									{
									{-1852.34668, 106.79424, 9.49213, 97.0236511230469},
									{-1865.77295, 106.67425, 9.31074, 17.3292331695557},
									{-1873.47266, 99.0377, 9.31074, 130.895843505859},
									{-1836.56165, 112.24213, 9.36229, 174.096923828125},
									{-1843.05847, 93.9962, 9.86754, 287.507659912109},
									{-1827.82007, 98.64787, 9.9898, 205.07275390625},
									{-1817.79199, 90.53823, 9.95067, 286.917602539063},
									{-1809.52319, 90.53222, 10.14598, 194.749542236328},
									{-1808.95227, 100.14233, 10.11302, 305.296447753906},
									{-1830.87268, 87.31917, 9.86754, 350.76904296875}
									},
									{
									{961.40594, -421.18881, 15.53686, 165.082763671875},
									{949.17023, -420.04504, 16.13676, 207.129241943359},
									{947.3338, -432.30646, 15.98102, 261.788360595703},
									{955.64557, -437.98419, 15.95536, 80.1800689697266},
									{952.45453, -442.5369, 15.90387, 179.429428100586},
									{951.12103, -454.5137, 15.925, 179.845123291016},
									{962.63165, -438.12305, 15.97946, 289.138458251953},
									{969.96973, -427.03278, 15.758, 263.543304443359},
									{976.05426, -437.66763, 15.9798, 314.179016113281},
									{962.71252, -431.19699, 15.75339, 64.4567489624023}
									}
									}
									local rnd = GenerateRandomIntInRange(1, #coords+1)
									for i=1,10,1 do
										peds[i] = SpawnPed(GetHashKey("M_M_EE_HEAVY_01"), coords[rnd][i][1], coords[rnd][i][2], coords[rnd][i][3], coords[rnd][i][4])
										GiveWeaponToChar(peds[i], 9, 1000, 1)
									end
									coords = {
									{179.70909, -532.43445, 9.072, 268.016448974609},
									{-1080.23938, -598.42029, 3.88147, 359.222686767578},
									{-1839.1875, 85.5682, 9.86754, 281.045043945313},
									{946.71136, -426.8093, 16.18056, 269.561248779297}
									}
									objs[1] = SpawnObject(GetHashKey("bm_mu_crate_03a"), coords[rnd][1], coords[rnd][2], coords[rnd][3]-1, coords[rnd][4])
									blips[1] = AddBlipForObject(objs[1])
									SetObjective("Steal ~y~the crate ~w~at ~y~the marked point")
									TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
									currmission = 1
									missionstarted = 1
								elseif(rnd == 2) then
									local coords = {
									{
									{-2214.02344, -198.94728, -0.41145, 57.6219177246094},
									{-2223.68188, -211.90155, -0.46968, 232.285980224609},
									{-2206.65674, -217.51668, -0.34847, 311.52392578125}
									},
									{
									{-2128.68774, 272.38327, -0.48375, 312.525512695313},
									{-2128.5481, 285.76801, -0.40045, 98.6699752807617},
									{-2140.89722, 280.92749, -0.77203, 168.945678710938}
									},
									{
									{-761.59705, -551.5899, -0.74843, 298.145294189453},
									{-753.10779, -540.69489, -0.21108, 352.555572509766},
									{-769.3183, -536.92139, -0.60853, 120.946594238281}
									},
									{
									{440.79166, -882.8363, -0.22284, 276.785736083984},
									{453.06134, -875.31482, -0.47329, 9.36447811126709},
									{441.36755, -863.15363, -0.74625, 84.7790679931641}
									},
									{
									{1223.33459, -959.68774, -0.73396, 81.6749114990234},
									{1209.93689, -967.60419, -0.33321, 151.858276367188},
									{1223.89233, -975.64966, -0.43061, 266.374908447266}
									}
									}
									local rnd = GenerateRandomIntInRange(1, #coords+1)
									vehs[1] = SpawnCar(GetHashKey("MARQUIS"), coords[rnd][1][1], coords[rnd][1][2], coords[rnd][1][3], coords[rnd][1][4])
									objs[1] = SpawnObject(GetHashKey("bm_mu_crate_03a"), coords[rnd][1][1], coords[rnd][1][2], coords[rnd][1][3]+1, coords[rnd][1][4])
									peds[1] = SpawnPed(GetHashKey("M_M_CHINATOWN_01"), coords[rnd][1][1], coords[rnd][1][2], coords[rnd][1][3], coords[rnd][1][4])
									peds[2] = SpawnPed(GetHashKey("M_M_CHINATOWN_01"), coords[rnd][1][1], coords[rnd][1][2], coords[rnd][1][3], coords[rnd][1][4])
									
									vehs[2] = SpawnCar(GetHashKey("JETMAX"), coords[rnd][2][1], coords[rnd][2][2], coords[rnd][2][3], coords[rnd][2][4])
									peds[3] = SpawnPed(GetHashKey("M_M_CHINATOWN_01"), coords[rnd][2][1], coords[rnd][2][2], coords[rnd][2][3], coords[rnd][2][4])
									peds[4] = SpawnPed(GetHashKey("M_M_CHINATOWN_01"), coords[rnd][2][1], coords[rnd][2][2], coords[rnd][2][3], coords[rnd][2][4])
									peds[5] = SpawnPed(GetHashKey("M_M_CHINATOWN_01"), coords[rnd][2][1], coords[rnd][2][2], coords[rnd][2][3], coords[rnd][2][4])
									
									vehs[3] = SpawnCar(GetHashKey("JETMAX"), coords[rnd][3][1], coords[rnd][3][2], coords[rnd][3][3], coords[rnd][3][4])
									peds[6] = SpawnPed(GetHashKey("M_M_CHINATOWN_01"), coords[rnd][3][1], coords[rnd][3][2], coords[rnd][3][3], coords[rnd][3][4])
									peds[7] = SpawnPed(GetHashKey("M_M_CHINATOWN_01"), coords[rnd][3][1], coords[rnd][3][2], coords[rnd][3][3], coords[rnd][3][4])
									peds[8] = SpawnPed(GetHashKey("M_M_CHINATOWN_01"), coords[rnd][3][1], coords[rnd][3][2], coords[rnd][3][3], coords[rnd][3][4])
									
									for i=1,8,1 do
										GiveWeaponToChar(peds[i], 14, 1000, 1)
									end
									blips[1] = AddBlipForObject(objs[1])
									SetObjective("Steal ~y~the crate ~w~from ~y~the boat")
									TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
									currmission = 2
									missionstarted = 1
								elseif(rnd == 3) then
									local coords = {
									{
									{-1870.46924, -128.33714, 1.62451, 177.73225402832},
									{-1865.55688, -130.23349, 1.30894, 173.14909362793},
									{-1870.08911, -123.75774, 3.34144, 156.504135131836},
									{-1865.37708, -121.32754, 4.85733, 267.243041992188},
									{-1857.25952, -119.72297, 4.83784, 244.622924804688},
									{-1870.13123, -110.44518, 6.31861, 359.717803955078},
									{-1879.8689, -109.52037, 6.42798, 33.3892135620117},
									{-1886.52515, -114.02522, 6.07491, 112.035446166992},
									{-1888.11987, -119.12316, 4.63363, 182.281234741211},
									{-1883.04663, -119.5602, 4.85855, 169.571014404297}
									},
									{
									{-772.04211, -97.86717, 1.51614, 359.183929443359},
									{-763.70026, -98.19801, 1.51614, 175.859191894531},
									{-757.49109, -97.16328, 1.5163, 337.063934326172},
									{-757.28192, -87.83769, 1.5163, 89.9628524780273},
									{-757.336, -79.6989, 1.51631, 357.699554443359},
									{-757.54114, -69.90752, 1.5163, 71.3780288696289},
									{-761.17804, -67.64684, 1.51614, 97.7464599609375},
									{-771.49127, -67.54388, 1.51614, 107.154754638672},
									{-757.104, -62.00533, 1.5163, 161.199035644531},
									{-751.59625, -98.12412, 1.5163, 152.554107666016}
									},
									{
									{-411.62997, -673.92352, 1.4738, 121.646430969238},
									{-402.77832, -668.4873, 1.4738, 206.764022827148},
									{-392.69113, -662.55884, 1.4738, 20.380485534668},
									{-382.02512, -657.11188, 1.4738, 229.118347167969},
									{-400.85574, -691.44818, 1.4738, 173.478012084961},
									{-395.47015, -687.6933, 1.4738, 201.10090637207},
									{-385.52802, -682.56647, 1.4738, 199.453598022461},
									{-373.60141, -675.78418, 1.4738, 271.540008544922},
									{-365.66904, -665.51489, 2.15728, 114.092193603516},
									{-373.19504, -654.04211, 2.15728, 133.041854858398}
									},
									{
									{501.01529, -511.4064, 1.49107, 184.456268310547},
									{502.1936, -504.09998, 1.49107, 266.491546630859},
									{501.00046, -496.69714, 1.49107, 3.27667760848999},
									{500.9848, -488.39584, 1.49211, 341.784820556641},
									{500.64224, -478.38785, 1.49211, 269.630981445313},
									{500.7171, -469.13483, 1.49211, 5.39058542251587},
									{497.0506, -505.09494, 2.60883, 280.867309570313},
									{495.66531, -498.53165, 2.64996, 289.670959472656},
									{495.20184, -511.75162, 2.68135, 223.21760559082},
									{489.5824, -519.2821, 3.97774, 142.824020385742}
									}
									}
									local rnd = GenerateRandomIntInRange(1, #coords+1)
									for i=1,10,1 do
										peds[i] = SpawnPed(GetHashKey("M_M_PITALIAN_01"), coords[rnd][i][1], coords[rnd][i][2], coords[rnd][i][3], coords[rnd][i][4])
										GiveWeaponToChar(peds[i], 12, 1000, 1)
									end
									coords = {
									{-1868.40698, -136.25082, -0.46141, 88.1985549926758},
									{-770.86041, -90.61866, -0.69755, 95.7308044433594},
									{-392.63971, -674.12988, -0.5385, 118.182350158691},
									{506.27612, -501.50119, -0.31517, 182.122314453125}
									}
									vehs[1] = SpawnCar(GetHashKey("SQUALO"), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
									blips[1] = AddBlipForCar(vehs[1])
									SetObjective("Steal ~y~the boat with cargo ~w~from ~y~the dock")
									TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
									currmission = 3
									missionstarted = 1
								elseif(rnd == 4) then
									local coords = {
									{
									{-909.55133, -312.59567, 2.92335, 208.151977539063},
									{-903.62695, -302.46466, 2.92335, 334.662414550781},
									{-903.73541, -318.86462, 2.92377, 188.473937988281},
									{-903.98444, -330.99109, 2.92377, 227.844711303711},
									{-911.67328, -317.73404, 2.92377, 77.8645858764648},
									{-923.19501, -313.12125, 2.92335, 81.4197463989258},
									{-926.646, -323.28314, 2.92377, 168.186508178711},
									{-925.79559, -299.25085, 2.92335, 355.385070800781},
									{-934.31427, -296.47937, 2.92335, 64.3979187011719},
									{-934.44354, -313.00641, 2.92335, 116.664268493652},
									{-944.72717, -316.74405, 2.92377, 105.316795349121},
									{-950.23822, -311.6615, 2.92335, 43.9553756713867},
									{-922.20398, -321.8024, 5.80024, 251.445343017578},
									{-910.19055, -322.60468, 5.80024, 267.42236328125},
									{-915.72559, -329.93356, 5.80024, 122.248634338379}
									},
									{
									{371.10565, -745.9942, 4.69672, 170.943328857422},
									{359.34528, -738.62292, 4.69671, 131.422973632813},
									{347.00943, -729.72241, 4.69672, 44.5296783447266},
									{353.52798, -718.31799, 4.69671, 333.291381835938},
									{361.45605, -711.52869, 4.69682, 333.765350341797},
									{372.28885, -712.59009, 4.69699, 334.950561523438},
									{388.3576, -717.065, 4.69699, 324.397155761719},
									{391.21509, -728.18756, 4.697, 250.325012207031},
									{408.04053, -736.55304, 4.697, 249.543685913086},
									{402.77249, -744.79785, 4.697, 185.704406738281},
									{394.91675, -761.27979, 4.697, 168.952819824219},
									{387.93582, -752.77179, 4.69692, 59.9658889770508},
									{384.40704, -739.59094, 4.697, 358.374267578125},
									{373.04211, -722.32593, 4.69674, 259.765869140625},
									{359.00412, -729.44556, 4.69672, 136.991928100586}
									},
									{
									{943.23572, -945.69171, 14.73766, 197.381088256836},
									{936.38257, -946.90747, 14.73766, 97.7492065429688},
									{935.41626, -929.38873, 14.73766, 7.24083185195923},
									{943.12799, -927.83173, 14.73766, 162.969619750977},
									{936.94098, -920.56482, 14.73766, 49.4242286682129},
									{943.58313, -915.50171, 14.73766, 297.317749023438},
									{936.8551, -910.77802, 14.73766, 121.235260009766},
									{941.83026, -902.22058, 14.73765, 316.963409423828},
									{931.55017, -896.63251, 14.73765, 88.9664993286133},
									{916.83765, -895.80725, 14.73765, 86.5841598510742},
									{945.50995, -896.02094, 14.73765, 306.896362304688},
									{954.39844, -896.71753, 14.73753, 261.706604003906},
									{964.30438, -892.99921, 14.73752, 283.403381347656},
									{944.20477, -889.20691, 14.73765, 322.867858886719},
									{937.09076, -886.5752, 14.73766, 1.73146510124207}
									}
									}
									local rnd = GenerateRandomIntInRange(1, #coords+1)
									for i=1,15,1 do
										peds[i] = SpawnPed(GetHashKey("M_M_PLATIN_01"), coords[rnd][i][1], coords[rnd][i][2], coords[rnd][i][3], coords[rnd][i][4])
										GiveWeaponToChar(peds[i], 12, 1000, 1)
									end
									coords = {
									{-916.03571, -304.18393, 5.80024, 88.3044662475586},
									{368.34277, -730.48755, 4.69671, 150.255874633789},
									{939.65894, -938.30664, 14.73766, 180.128295898438}
									}
									vehs[1] = SpawnCar(GetHashKey("MAVERICK"), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
									blips[1] = AddBlipForCar(vehs[1])
									SetObjective("Steal ~y~the helicopter with cargo ~w~from ~y~the marked point")
									TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
									currmission = 4
									missionstarted = 1
								end
							else
								TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Mission in progress!')
							end
						elseif(tempitems[menuresult] == "Ammunition upgrades") then
							::upgrades::
							local tempitems = {}
							if(techs[1] == 0) then
								tempitems[#tempitems+1] = "Gun crate ~g~(50 cargo)"
							else
								tempitems[#tempitems+1] = "Gun crate (Unlocked)"
							end
							if(techs[2] == 0) then
								tempitems[#tempitems+1] = "Heavy suit ~g~(100 cargo)"
							else
								tempitems[#tempitems+1] = "Heavy suit (Unlocked)"
							end
							if(techs[3] == 0) then
								tempitems[#tempitems+1] = "AA12 Explosive shells ~g~(70 cargo)"
							else
								tempitems[#tempitems+1] = "AA12 Explosive shells (Unlocked)"
							end
							if(techs[4] == 0) then
								tempitems[#tempitems+1] = "Advanced Sniper ~g~(110 cargo)"
							else
								tempitems[#tempitems+1] = "Advanced Sniper (Unlocked)"
							end
							if(techs[5] == 0) then
								tempitems[#tempitems+1] = "RPG with homing missiles ~g~(110 cargo)"
							else
								tempitems[#tempitems+1] = "RPG with homing missiles (Unlocked)"
							end
							DrawWindow("Ammunition_upgrades", tempitems)
							while menuactive do
								Wait(0)
								if(currbutton == 1) then
									DrawDescription("Gun crate", {
									-----------------------------------------------------------------------------------------------
									"Allows you to make a request of an airdrop with several guns. This crate can be requested",
									"anywhere."
									})
								elseif(currbutton == 2) then
									DrawDescription("Heavy suit", {
									-----------------------------------------------------------------------------------------------
									"Allows you to make a request of an airdrop with heavy suit which gives you 200 HP, 200 AP",
									"and increases your movement speed by 1.5. This crate can be requested anywhere."
									})
								end
							end
							if(menuresult > 0) then
								if(menuresult == 1) then
									if(techs[1] == 0) then
										if(cargo >= 50) then
											cargo = cargo - 50
											SaveStats()
											techs[1] = 1
											SaveTechs()
											TriggerEvent('chatMessage', '[Upgrade]', {0, 255, 0}, 'Gun crate upgrade purchased! Use player menu to request it.')
										else
											TriggerEvent('chatMessage', '[Upgrade]', {255, 0, 0}, 'Not enough cargo!')
										end
									else
										TriggerEvent('chatMessage', '[Upgrade]', {255, 255, 0}, 'Already unlocked!')
									end
								elseif(menuresult == 2) then
									if(techs[2] == 0) then
										if(cargo >= 100) then
											cargo = cargo - 100
											SaveStats()
											techs[2] = 1
											SaveTechs()
											TriggerEvent('chatMessage', '[Upgrade]', {0, 255, 0}, 'Heavy suit upgrade purchased! Use player menu to request it.')
										else
											TriggerEvent('chatMessage', '[Upgrade]', {255, 0, 0}, 'Not enough cargo!')
										end
									else
										TriggerEvent('chatMessage', '[Upgrade]', {255, 255, 0}, 'Already unlocked!')
									end
								elseif(menuresult == 3) then
									if(techs[3] == 0) then
										if(cargo >= 70) then
											cargo = cargo - 70
											SaveStats()
											techs[3] = 1
											SaveTechs()
											TriggerEvent('chatMessage', '[Upgrade]', {0, 255, 0}, 'AA12 Explosive shells upgrade purchased! Use gun workshop to get it.')
										else
											TriggerEvent('chatMessage', '[Upgrade]', {255, 0, 0}, 'Not enough cargo!')
										end
									else
										TriggerEvent('chatMessage', '[Upgrade]', {255, 255, 0}, 'Already unlocked!')
									end
								elseif(menuresult == 4) then
									if(techs[4] == 0) then
										if(cargo >= 110) then
											cargo = cargo - 110
											SaveStats()
											techs[4] = 1
											SaveTechs()
											TriggerEvent('chatMessage', '[Upgrade]', {0, 255, 0}, 'Advanced Sniper upgrade purchased! Use gun workshop to get it.')
										else
											TriggerEvent('chatMessage', '[Upgrade]', {255, 0, 0}, 'Not enough cargo!')
										end
									else
										TriggerEvent('chatMessage', '[Upgrade]', {255, 255, 0}, 'Already unlocked!')
									end
								elseif(menuresult == 5) then
									if(techs[5] == 0) then
										if(cargo >= 110) then
											cargo = cargo - 110
											SaveStats()
											techs[5] = 1
											SaveTechs()
											TriggerEvent('chatMessage', '[Upgrade]', {0, 255, 0}, 'RPG with homing missiles upgrade purchased! Use gun workshop to get it.')
										else
											TriggerEvent('chatMessage', '[Upgrade]', {255, 0, 0}, 'Not enough cargo!')
										end
									else
										TriggerEvent('chatMessage', '[Upgrade]', {255, 255, 0}, 'Already unlocked!')
									end
								end
								goto upgrades
							else
								goto main
							end
						elseif(tempitems[menuresult] == "Gun workshop") then
							::workshop::
							local tempitems = {}
							if(techs[3] == 0) then
								tempitems[#tempitems+1] = "AA12 Explosive shells (Blocked)"
							else
								tempitems[#tempitems+1] = "AA12 Explosive shells ~g~(1 bullet / 1 cargo)"
							end
							if(techs[4] == 0) then
								tempitems[#tempitems+1] = "Advanced Sniper (Blocked)"
							else
								tempitems[#tempitems+1] = "Advanced Sniper ~g~(1 bullet / 1 cargo)"
							end
							if(techs[5] == 0) then
								tempitems[#tempitems+1] = "RPG with homing missiles (Blocked)"
							else
								tempitems[#tempitems+1] = "RPG with homing missiles ~g~(1 bullet / 1 cargo)"
							end
							DrawWindow("Gun_workshop", tempitems)
							while menuactive do
								Wait(0)
							end
							if(menuresult > 0) then
								if(menuresult == 1) then
									if(techs[3] == 1) then
										if(cargo >= 1) then
											cargo = cargo - 1
											SaveStats()
											local wep = table.pack(GetCharWeaponInSlot(GetPlayerChar(GetPlayerId()), 3))
											if(wep[1] ~= 30) then
												RemoveWeaponFromChar(GetPlayerChar(GetPlayerId()), wep[1])
											end
											GiveWeaponToChar(GetPlayerChar(GetPlayerId()), 30, 1, 1)
										else
											TriggerEvent('chatMessage', '[Gun workshop]', {255, 0, 0}, 'Not enough cargo!')
										end
									else
										TriggerEvent('chatMessage', '[Gun workshop]', {255, 0, 0}, 'This weapon is blocked!')
									end
								elseif(menuresult == 2) then
									if(techs[4] == 1) then
										if(cargo >= 1) then
											cargo = cargo - 1
											SaveStats()
											local wep = table.pack(GetCharWeaponInSlot(GetPlayerChar(GetPlayerId()), 6))
											if(wep[1] ~= 35) then
												RemoveWeaponFromChar(GetPlayerChar(GetPlayerId()), wep[1])
											end
											GiveWeaponToChar(GetPlayerChar(GetPlayerId()), 35, 1, 1)
										else
											TriggerEvent('chatMessage', '[Gun workshop]', {255, 0, 0}, 'Not enough cargo!')
										end
									else
										TriggerEvent('chatMessage', '[Gun workshop]', {255, 0, 0}, 'This weapon is blocked!')
									end
								elseif(menuresult == 3) then
									if(techs[5] == 1) then
										if(cargo >= 1) then
											cargo = cargo - 1
											SaveStats()
											local wep = table.pack(GetCharWeaponInSlot(GetPlayerChar(GetPlayerId()), 7))
											if(wep[1] ~= 41) then
												RemoveWeaponFromChar(GetPlayerChar(GetPlayerId()), wep[1])
											end
											GiveWeaponToChar(GetPlayerChar(GetPlayerId()), 41, 1, 1)
										else
											TriggerEvent('chatMessage', '[Gun workshop]', {255, 0, 0}, 'Not enough cargo!')
										end
									else
										TriggerEvent('chatMessage', '[Gun workshop]', {255, 0, 0}, 'This weapon is blocked!')
									end
								end
								goto workshop
							else
								goto main
							end
						elseif(tempitems[menuresult] == "Buy 3 cargo for ~g~3500$") then
							if(cooldown <= 0) then
								if(money >= 3500) then
									money = money - 3500
									cargo = cargo + 3
									SaveStats()
									cooldown = 600
								else
									TriggerEvent('chatMessage', '[Cargo]', {255, 0, 0}, 'You do not have enough money.')
								end
							else
								TriggerEvent('chatMessage', '[Cargo]', {255, 0, 0}, 'You will be able to that again in ' .. cooldown .. ' seconds.')
							end
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
					for i=1,10,1 do
						if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
							for j=1,10,1 do
								AttackPlayer(peds[j])
							end
						end
					end
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(IsCharTouchingObject(GetPlayerChar(GetPlayerId()), objs[1]) or IsPlayerNearCoords(ox, oy, oz, 1)) then
						DeleteObject(objs[1])
						RemoveBlip(blips[1])
						blips[1] = AddBlipForCoord(706.59802, 1464.28162, 14.85285)
						SetRoute(blips[1], true)
						SetObjective("Deliver ~y~this crate ~w~to ~y~the storage")
						currstage = 1
					end
				elseif(currstage == 1) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						cargo = cargo + 5
						experience = experience + 300
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got 5 cargo and 300 EXP")
						EndMission()
						cargocooldown[1] = 200
					end
				end
			elseif(currmission == 2) then
				if(currstage == 0) then
					for i=1,8,1 do
						if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
							for j=1,8,1 do
								AttackPlayer(peds[j])
							end
						end
					end
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(IsCharTouchingObject(GetPlayerChar(GetPlayerId()), objs[1]) or IsPlayerNearCoords(ox, oy, oz, 1)) then
						DeleteObject(objs[1])
						RemoveBlip(blips[1])
						blips[1] = AddBlipForCoord(706.59802, 1464.28162, 14.85285)
						SetRoute(blips[1], true)
						SetObjective("Deliver ~y~this crate ~w~to ~y~the storage")
						currstage = 1
					end
				elseif(currstage == 1) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						cargo = cargo + 5
						experience = experience + 300
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got 5 cargo and 300 EXP")
						EndMission()
						cargocooldown[2] = 200
					end
				end
			elseif(currmission == 3) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						for i=1,10,1 do
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,10,1 do
									AttackPlayer(peds[j])
								end
							end
						end
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(715.7959, 1256.82117, -0.62042)
							SetRoute(blips[1], true)
							SetObjective("Deliver ~y~this boat ~w~to ~y~the storage")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Boat destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithAlpha(bp.x, bp.y, bp.z, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								cargo = cargo + 7
								experience = experience + 400
								SaveStats()
								DrawMessage("~y~Mission completed", "You have got 7 cargo and 400 EXP")
								EndMission()
								cargocooldown[3] = 300
							end
						end
					else
						DrawMessage("~r~Mission failed", "Boat destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 4) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						for i=1,15,1 do
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,15,1 do
									AttackPlayer(peds[j])
								end
							end
						end
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(721.93585, 1437.40771, 19.62214)
							SetRoute(blips[1], true)
							SetObjective("Deliver ~y~this helicopter ~w~to ~y~the storage")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Helicopter destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								cargo = cargo + 10
								experience = experience + 500
								SaveStats()
								DrawMessage("~y~Mission completed", "You have got 10 cargo and 500 EXP")
								EndMission()
								cargocooldown[4] = 400
							end
						end
					else
						DrawMessage("~r~Mission failed", "Helicopter destroyed.")
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