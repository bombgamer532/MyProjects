local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end

local supplies = 0
local drugs = 0
RegisterNetEvent('updAcid')
AddEventHandler('updAcid', function(data)
	if data[1] then
		supplies = tonumber(data[1])
	end
	if data[2] then
		drugs = tonumber(data[2])
	end
end)
SaveAcid = function()
	local data = {}
	data[1] = supplies
	data[2] = drugs
	TriggerServerEvent('saveAcid', data)
end
CreateThread(function()
	while true do
		Wait(0)
		if(supplies > 0) then
			Wait(600000)
			supplies = supplies - 1
			drugs = drugs + 1
			SaveAcid()
		end
	end
end)

local inveh = false
CreateThread(function()
	while true do
		Wait(0)
		if(not IsCarDead(car)) then
			if(IsCarModel(car, GetHashKey("brickade"))) then
				if(IsCharInCar(GetPlayerChar(GetPlayerId()), car)) then
					if(missionstarted == 0) then
						if not inveh then
							PrintStringWithLiteralStringNow("STRING", "Press ~y~Caps Lock ~w~to ~y~open acid lab menu", 5000, 1)
							inveh = true
						end
						if(IsGameKeyboardKeyJustPressed(58)) then
							local tempitems = {}
							tempitems[#tempitems+1] = "Supply ~y~(" .. supplies .. " supplies left)"
							tempitems[#tempitems+1] = "Sell ~y~(" .. drugs .. " drugs produced)"
							DrawWindow("Acid Lab", tempitems)
							while menuactive do
								Wait(0)
							end
							if(menuresult > 0) then
								if(menuresult == 1) then
									local rnd = GenerateRandomIntInRange(1, 4)
									if(rnd == 1) then
										local coords = {
										--crate, {peds}
										{
										{1984.5675, 690.85425, 19.41141, 267.491027832031, 0},
										{
										{1984.82495, 684.61121, 19.41141, 188.104873657227, 0},
										{1979.18542, 695.25342, 19.41141, 242.953125, 0},
										{1988.49426, 694.7514, 18.05994, 269.079071044922, 0},
										{1988.3999, 688.59723, 18.06017, 179.374725341797, 0},
										{1992.98975, 685.29529, 18.06017, 238.062561035156, 0},
										{1993.9729, 696.92059, 18.06003, 91.4679489135742, 0},
										{1990.83252, 704.74548, 18.05987, 2.98379802703857, 0},
										{1985.19666, 707.62915, 18.06017, 162.728973388672, 0},
										{1978.93188, 706.16833, 18.04936, 76.0045928955078, 0},
										{1987.08801, 698.4231, 18.06017, 272.151672363281, 0},
										}
										},
										{
										{1301.8479, -612.28882, 12.8198, 289.336120605469, 0},
										{
										{1302.63293, -607.03247, 12.8814, 271.600738525391, 0},
										{1305.4187, -610.93634, 12.80359, 334.116485595703, 0},
										{1308.49841, -607.92371, 12.79722, 262.258422851563, 0},
										{1312.44958, -614.23132, 12.73566, 336.539093017578, 0},
										{1315.07129, -607.79553, 12.73509, 50.0364379882813, 0},
										{1316.26709, -615.25476, 12.72576, 189.521682739258, 0},
										{1319.60986, -603.53809, 12.5673, 352.001373291016, 0},
										{1322.40662, -608.48926, 12.5673, 188.266220092773, 0},
										{1319.82935, -614.16351, 12.5673, 203.849746704102, 0},
										{1301.02124, -609.79102, 12.86954, 262.599334716797, 0},
										}
										},
										{
										{1023.42822, 720.84515, 29.96931, 265.932250976563, 0},
										{
										{1023.21039, 724.62842, 29.96931, 167.818405151367, 0},
										{1026.55603, 717.02551, 29.9693, 2.57333493232727, 0},
										{1027.61865, 726.086, 29.9693, 114.663131713867, 0},
										{1024.26782, 712.77545, 29.9693, 170.552337646484, 0},
										{1023.56714, 709.28308, 29.9693, 331.894775390625, 0},
										{1028.07153, 708.16791, 29.9693, 15.9135904312134, 0},
										{1024.14722, 730.85474, 29.9693, 315.456787109375, 0},
										{1022.98657, 738.03137, 29.9693, 271.045288085938, 0},
										{1030.53149, 733.71899, 29.9693, 180.09033203125, 0},
										{1021.76855, 721.26782, 29.9693, 272.515502929688, 0},
										}
										},
										{
										{1227.46594, 1544.96094, 16.81107, 154.234878540039, 0},
										{
										{1228.90161, 1541.15833, 16.79144, 163.716033935547, 0},
										{1222.40894, 1545.84143, 16.80342, 219.417037963867, 0},
										{1217.75842, 1549.29419, 16.81126, 67.9746932983398, 0},
										{1212.47852, 1554.35901, 16.78258, 147.853698730469, 0},
										{1215.28503, 1540.49976, 16.7492, 167.702529907227, 0},
										{1225.59607, 1535.78516, 16.95005, 23.8600540161133, 0},
										{1210.02234, 1548.15967, 16.79688, 87.0529479980469, 0},
										{1208.58362, 1542.31079, 16.88713, 146.047119140625, 0},
										{1219.54932, 1553.31616, 16.78981, 131.87043762207, 0},
										{1219.79431, 1544.07971, 16.82048, 278.351440429688, 0},
										}
										},
										{
										{-224.15675, 1666.74866, 18.76562, 358.156280517578, 0},
										{
										{-226.7567, 1657.5708, 18.71593, 204.851287841797, 0},
										{-220.04073, 1658.73889, 18.71593, 260.576538085938, 0},
										{-218.31476, 1655.85132, 18.7461, 204.881607055664, 0},
										{-213.54536, 1659.06702, 18.71593, 97.6771774291992, 0},
										{-229.43008, 1669.1488, 18.76562, 190.756561279297, 0},
										{-227.67686, 1664.81104, 18.76562, 7.3661675453186, 0},
										{-231.14822, 1655.12524, 18.71593, 174.785140991211, 0},
										{-225.94128, 1651.60095, 18.66402, 251.419891357422, 0},
										{-221.96338, 1650.64917, 18.62793, 84.9241943359375, 0},
										{-213.45418, 1651.04529, 18.6429, 7.31093168258667, 0},
										}
										},
										{
										{-58.26078, -917.0694, 4.96379, 357.626770019531, 0},
										{
										{-60.62904, -912.80005, 4.96379, 49.0007934570313, 0},
										{-56.09089, -909.49481, 4.96379, 318.277648925781, 0},
										{-57.1848, -928.98932, 4.96379, 138.281814575195, 0},
										{-53.15723, -924.23883, 4.96379, 319.241088867188, 0},
										{-54.87165, -902.27063, 4.96379, 346.175537109375, 0},
										{-58.99121, -896.90247, 4.96379, 61.2990646362305, 0},
										{-46.32117, -904.45294, 5.04158, 104.564918518066, 0},
										{-44.48635, -907.95807, 5.01653, 23.2252082824707, 0},
										{-47.4864, -920.83044, 4.9631, 9.34904956817627, 0},
										{-47.95205, -918.22998, 4.96379, 190.40690612793, 0},
										}
										},
										{
										{-977.1004, 1898.10693, 22.2923, 86.7883682250977, 0},
										{
										{-979.91815, 1901.62402, 22.29047, 91.9870986938477, 0},
										{-981.43402, 1892.599, 22.30255, 173.090362548828, 0},
										{-984.24805, 1898.7196, 22.28992, 218.973037719727, 0},
										{-977.36688, 1906.19434, 22.30915, 294.710540771484, 0},
										{-986.46643, 1904.23511, 22.28993, 190.619277954102, 0},
										{-990.65198, 1890.34875, 22.3092, 309.38330078125, 0},
										{-988.67346, 1891.99573, 22.30063, 128.824523925781, 0},
										{-986.76819, 1883.35901, 23.29087, 337.068969726563, 0},
										{-983.03046, 1882.31848, 22.32339, 255.586883544922, 0},
										{-976.71783, 1882.96375, 22.33081, 261.2060546875, 0},
										}
										},
										{
										{-937.41339, 464.74313, 4.37788, 28.3755264282227, 0},
										{
										{-932.76709, 459.38, 4.37788, 263.29541015625, 0},
										{-938.36621, 454.68695, 4.37788, 124.575782775879, 0},
										{-933.54126, 450.07037, 4.37788, 164.885757446289, 0},
										{-935.90741, 449.61725, 4.37788, 265.233947753906, 0},
										{-939.01221, 443.13754, 4.37788, 306.240600585938, 0},
										{-942.86731, 469.6142, 4.37788, 358.335113525391, 0},
										{-943.48456, 463.21722, 4.37788, 101.27806854248, 0},
										{-946.14856, 468.24258, 4.37788, 66.4167938232422, 0},
										{-952.00836, 462.18289, 4.37788, 97.6003952026367, 0},
										{-939.35339, 468.90228, 4.37788, 323.47265625, 0},
										}
										},
										{
										{-2032.88147, -356.23886, 4.37071, 185.811996459961, 0},
										{
										{-2037.68604, -358.58932, 4.37071, 107.093368530273, 0},
										{-2033.73999, -358.59509, 4.37071, 221.921035766602, 0},
										{-2028.40381, -353.52365, 4.37071, 316.327087402344, 0},
										{-2028.70508, -359.54547, 4.37071, 249.759857177734, 0},
										{-2026.25305, -360.25708, 4.37071, 74.6030654907227, 0},
										{-2028.8186, -362.55768, 4.37071, 126.485877990723, 0},
										{-2036.43933, -360.63235, 4.37071, 331.857177734375, 0},
										{-2024.95032, -365.52344, 4.37071, 246.788528442383, 0},
										{-2030.0614, -367.17444, 4.37071, 101.663162231445, 0},
										{-2041.96753, -364.12582, 4.37071, 147.228576660156, 0},
										}
										}
										}
										local rnd = GenerateRandomIntInRange(1, #coords+1)
										objs[1] = SpawnObject(GetHashKey("bm_mu_crate_03a"), coords[rnd][1][1], coords[rnd][1][2], coords[rnd][1][3]-1, coords[rnd][1][4])
										blips[1] = AddBlipForObject(objs[1])
										SetRoute(blips[1], true)
										for i=1,10,1 do
											peds[i] = SpawnPed(GetHashKey("M_M_GUNNUT_01"), coords[rnd][2][i][1], coords[rnd][2][i][2], coords[rnd][2][i][3], coords[rnd][2][i][4], coords[rnd][2][i][5])
											GiveWeaponToChar(peds[i], 15, 1000, 1)
										end
										SetObjective("Obtain ~y~the package")
										TriggerEvent('chatMessage', '[Acid Lab]', {255, 255, 0}, 'Supply mission started.')
										currmission = 11
										missionstarted = 1
									elseif(rnd == 2) then
										for i=1,3,1 do
											local rx,ry,rz,rh = GetRandomNodeInRadius(GenerateRandomIntInRange(500, 3000))
											vehs[i] = SpawnCar(GetHashKey("speedo"), rx, ry, rz, rh)
											blips[i] = AddBlipForCar(vehs[i])
											peds[i] = SpawnPed(GetHashKey("M_Y_GALB_LO_01"), rx, ry, rz, rh)
											WarpCharIntoCar(peds[i], vehs[i])
											TaskCarMission(peds[i], vehs[i], vehs[i], 1, 10.1, 0, 0, 10)
										end
										SetObjective("One of ~y~vans ~w~contains ~g~supplies~w~. Find ~y~it")
										TriggerEvent('chatMessage', '[Acid Lab]', {255, 255, 0}, 'Supply mission started.')
										currmission = 12
										missionstarted = 1
									elseif(rnd == 3) then
										local coords = {
										--truck, {peds}
										{
										{1755.22644, 495.85364, 29.03854, 229.625762939453, 0},
										{
										{1756.65527, 503.16171, 29.18048, 231.586929321289, 0},
										{1757.55103, 498.58609, 29.08125, 211.419708251953, 0},
										{1758.38403, 496.75302, 29.03544, 23.4961490631104, 0},
										{1762.84766, 491.69556, 28.87934, 41.8575286865234, 0},
										{1766.00232, 494.73059, 28.89881, 107.516983032227, 0},
										{1750.86658, 492.83743, 29.0182, 102.597328186035, 0},
										{1747.35437, 490.3924, 29.02734, 83.9730224609375, 0},
										{1746.14563, 485.39502, 28.98411, 14.5770149230957, 0},
										{1741.29724, 488.42667, 29.03647, 58.5245819091797, 0},
										{1755.70154, 488.5249, 28.88704, 32.2433471679688, 0},
										}
										},
										{
										{862.66553, -325.57053, 16.67696, 179.916931152344, 0},
										{
										{860.7027, -330.35263, 16.63651, 157.431167602539, 0},
										{865.26111, -330.24213, 16.65724, 97.2698135375977, 0},
										{861.50305, -334.74365, 16.63714, 143.631134033203, 0},
										{857.75751, -331.46741, 16.5169, 187.702178955078, 0},
										{855.01282, -333.07538, 16.42231, 76.777458190918, 0},
										{853.58112, -332.99438, 16.36763, 267.241668701172, 0},
										{855.41638, -339.63498, 16.43954, 205.366928100586, 0},
										{851.99371, -339.95557, 16.31064, 101.167915344238, 0},
										{848.13373, -331.91718, 16.12103, 96.3136520385742, 0},
										{845.73108, -334.83438, 16.02084, 93.2617416381836, 0},
										}
										},
										{
										{300.7092, 1857.59985, 17.74366, 179.043823242188, 0},
										{
										{304.42111, 1861.01685, 17.77721, 268.211975097656, 0},
										{298.34683, 1849.42029, 17.77721, 185.504913330078, 0},
										{300.28961, 1843.5946, 17.77721, 319.074249267578, 0},
										{305.95148, 1841.48596, 17.77721, 340.133544921875, 0},
										{309.56931, 1846.82227, 17.6871, 334.630798339844, 0},
										{306.69855, 1865.4707, 17.7772, 269.897827148438, 0},
										{310.66296, 1866.6759, 17.77721, 148.555847167969, 0},
										{313.90149, 1858.73743, 17.77043, 200.706344604492, 0},
										{314.27499, 1853.02783, 17.76942, 0.614143311977386, 0},
										{312.38458, 1848.45422, 17.77328, 263.047576904297, 0},
										}
										},
										{
										{-314.21631, 448.03601, 14.78366, 359.980102539063, 0},
										{
										{-311.90775, 439.98627, 14.80587, 185.366424560547, 0},
										{-315.80261, 440.81049, 14.7684, 229.574768066406, 0},
										{-313.32266, 455.60999, 14.7939, 252.020416259766, 0},
										{-309.47717, 444.88495, 14.74976, 1.36544072628021, 0},
										{-309.29343, 462.39053, 14.67421, 209.472137451172, 0},
										{-313.59399, 461.92102, 14.78172, 159.229278564453, 0},
										{-315.18936, 464.47366, 14.75921, 10.4599800109863, 0},
										{-321.48987, 461.42981, 14.76138, 300.120452880859, 0},
										{-322.06857, 463.60339, 14.75921, 27.2456760406494, 0},
										{-320.453, 444.14764, 14.75921, 267.591979980469, 0},
										}
										},
										{
										{-1489.29309, 1366.89526, 13.05524, 270.24609375, 0},
										{
										{-1487.25818, 1375.61719, 13.17506, 174.944686889648, 0},
										{-1489.86121, 1373.052, 13.05528, 104.443450927734, 0},
										{-1493.67542, 1363.86926, 13.17506, 89.4246063232422, 0},
										{-1488.66821, 1362.1106, 13.05523, 306.635803222656, 0},
										{-1484.00671, 1357.89673, 13.05523, 182.059356689453, 0},
										{-1482.45166, 1365.95129, 13.05529, 352.915710449219, 0},
										{-1482.48035, 1367.90027, 13.05529, 237.698654174805, 0},
										{-1484.07153, 1375.47412, 13.17506, 187.861877441406, 0},
										{-1479.33252, 1370.26355, 13.05529, 261.012268066406, 0},
										{-1477.64368, 1377.14917, 13.17506, 337.113922119141, 0},
										}
										},
										{
										{-1924.01782, 13.27818, 7.47274, 16.6650314331055, 0},
										{
										{-1922.7179, 19.48102, 7.47274, 307.234069824219, 0},
										{-1927.11365, 16.85667, 7.47274, 112.642585754395, 0},
										{-1926.33337, 7.91041, 7.47247, 175.729293823242, 0},
										{-1932.88428, 3.91877, 7.47275, 307.49658203125, 0},
										{-1927.90759, 1.02292, 7.47274, 220.994598388672, 0},
										{-1929.37122, 11.69362, 7.47275, 27.8711795806885, 0},
										{-1930.48987, 20.61956, 7.47275, 72.6025009155273, 0},
										{-1932.21777, 21.14423, 7.47275, 241.532455444336, 0},
										{-1938.00439, 20.19532, 7.47275, 132.531051635742, 0},
										{-1929.48071, -4.73451, 7.47274, 173.393753051758, 0},
										}
										}
										}
										local rnd = GenerateRandomIntInRange(1, #coords+1)
										vehs[1] = SpawnCar(GetHashKey("mule"), coords[rnd][1][1], coords[rnd][1][2], coords[rnd][1][3], coords[rnd][1][4])
										blips[1] = AddBlipForCar(vehs[1])
										SetRoute(blips[1], true)
										for i=1,10,1 do
											peds[i] = SpawnPed(GetHashKey("M_Y_GLAT_LO_01"), coords[rnd][2][i][1], coords[rnd][2][i][2], coords[rnd][2][i][3], coords[rnd][2][i][4], coords[rnd][2][i][5])
											GiveWeaponToChar(peds[i], 14, 1000, 1)
										end
										SetObjective("Steal ~y~the truck")
										TriggerEvent('chatMessage', '[Acid Lab]', {255, 255, 0}, 'Supply mission started.')
										currmission = 13
										missionstarted = 1
									end
								elseif(menuresult == 2) then
									if(drugs > 0) then
										local rnd = GenerateRandomIntInRange(1, 3)
										if(rnd == 1) then
											for i=1,5,1 do
												local rx,ry,rz,rh = GetRandomNodeInRadius(GenerateRandomIntInRange(500, 2000))
												blips[i] = AddBlipForCoord(rx, ry, rz)
											end
											SetObjective("Deliver ~y~drugs ~w~to ~y~the points")
											TriggerEvent('chatMessage', '[Acid Lab]', {255, 255, 0}, 'Sell mission started.')
											currmission = 21
											missionstarted = 1
										elseif(rnd == 2) then
											local coords = {
											{77.81879, 1136.23767, 2.91673, 180.148788452148, 0},
											{-611.03168, 488.26328, 4.94424, 178.994079589844, 0},
											{-987.90167, 1405.23193, 25.68967, 359.592956542969, 0},
											{2255.20044, 377.797, 7.49959, 269.999328613281, 0},
											{1139.75403, 138.98798, 32.93008, 89.5817260742188, 0},
											{1135.30762, 566.11456, 32.45714, 271.084716796875, 0},
											{1760.18433, 405.69009, 25.41919, 89.9305038452148, 0},
											{460.47888, 1738.85339, 15.80869, 233.583480834961, 0},
											{1.39831, -191.8354, 14.53183, 0.116277135908604, 0},
											{-533.2251, 1127.85449, 9.98309, 358.571685791016, 0},
											{-594.87897, -97.80893, 6.43994, 177.629516601563, 0},
											{185.79355, 175.86176, 14.76956, 179.677947998047, 0},
											{-1424.78125, 621.49609, 19.57296, 106.875793457031, 0},
											{-1865.62903, 158.94798, 15.01166, 277.306518554688, 0}
											}
											local rnd = GenerateRandomIntInRange(1, #coords+1)
											vehs[1] = SpawnCar(GetHashKey("landstalker"), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
											blips[1] = AddBlipForCar(vehs[1])
											SetObjective("Deliver ~y~drugs ~w~to ~y~the marked vehicle")
											TriggerEvent('chatMessage', '[Acid Lab]', {255, 255, 0}, 'Sell mission started.')
											currmission = 22
											missionstarted = 1
										end
									else
										TriggerEvent('chatMessage', '[Acid Lab]', {255, 0, 0}, 'No drugs to sell.')
									end
								end
							end
						end
					end
				else
					inveh = false
				end
			end
		else
			inveh = false
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(currmission > 0) then
			if(currmission == 11) then
				if(currstage == 0) then
					for i=1,10,1 do
						if(not IsCharDead(peds[i])) then
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,10,1 do
									AttackPlayer(peds[j])
								end
							end
						end
					end
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(IsPlayerNearCoords(ox, oy, oz, 2)) then
						if(not IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
							RemoveBlip(blips[1])
							DeleteObject(objs[1])
							SetObjective("Bring ~y~this package ~w~to your ~y~acid lab")
							currstage = 1
						end
					end
				elseif(currstage == 1) then
					if(IsCharInCar(GetPlayerChar(GetPlayerId()), car)) then
						if(IsCarModel(car, GetHashKey("brickade"))) then
							supplies = supplies + 2
							SaveAcid()
							experience = experience + 100
							SaveStats()
							DrawMessage("~y~Mission completed", "You have got 2 supplies and 100 EXP")
							EndMission()
						end
					end
				end
			elseif(currmission == 12) then
				if(currstage == 0) then
					for i=1,3,1 do
						if(DoesBlipExist(blips[i])) then
							if(not IsCarDead(vehs[i])) then
								if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[i])) then
									local amount = 0
									for j=1,3,1 do
										if(DoesBlipExist(blips[j])) then
											amount = amount + 1
										end
									end
									if(amount > 1) then
										if(GenerateRandomIntInRange(0, 2) == 1) then
											for j=1,3,1 do
												RemoveBlip(blips[j])
												if(i ~= j) then
													DeleteCar(vehs[j])
												end
											end
											vehs[1] = vehs[i]
											AlterWantedLevel(GetPlayerId(), 3)
											ApplyWantedLevelChangeNow(GetPlayerId())
											SetObjective("Lose ~y~wanted level")
											currstage = 1
											break
										else
											RemoveBlip(blips[i])
											PrintStringWithLiteralStringNow("STRING", "~r~Wrong van", 3000, 1)
										end
									else
										for j=1,3,1 do
											RemoveBlip(blips[j])
										end
										vehs[1] = vehs[i]
										AlterWantedLevel(GetPlayerId(), 3)
										ApplyWantedLevelChangeNow(GetPlayerId())
										SetObjective("Lose ~y~wanted level")
										currstage = 1
									end
								end
							else
								DrawMessage("~r~Mission failed", "One of the vans got destroyed.")
								EndMission()
							end
						end
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						if(StoreWantedLevel(GetPlayerId()) == 0) then
							SetObjective("Bring ~y~this van ~w~to your ~y~acid lab")
							currstage = 2
						end
					else
						DrawMessage("~r~Mission failed", "Van destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
					if(not IsCarDead(vehs[1])) then
						if(not IsCarDead(car)) then
							if(IsCarModel(car, GetHashKey("brickade"))) then
								local cx,cy,cz = GetCarCoordinates(car)
								if(IsPlayerNearCoords(cx, cy, cz, 5)) then
									if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
										supplies = supplies + 3
										SaveAcid()
										experience = experience + 150
										SaveStats()
										DrawMessage("~y~Mission completed", "You have got 3 supplies and 150 EXP")
										EndMission()
									end
								end
							end
						end
					else
						DrawMessage("~r~Mission failed", "Van destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 13) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						for i=1,10,1 do
							if(not IsCharDead(peds[i])) then
								if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
									for j=1,10,1 do
										AttackPlayer(peds[j])
									end
								end
							end
						end
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							AlterWantedLevel(GetPlayerId(), 3)
							ApplyWantedLevelChangeNow(GetPlayerId())
							SetObjective("Lose ~y~wanted level")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Truck destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						if(StoreWantedLevel(GetPlayerId()) == 0) then
							SetObjective("Bring ~y~this truck ~w~to your ~y~acid lab")
							currstage = 2
						end
					else
						DrawMessage("~r~Mission failed", "Truck destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
					if(not IsCarDead(vehs[1])) then
						if(not IsCarDead(car)) then
							if(IsCarModel(car, GetHashKey("brickade"))) then
								local cx,cy,cz = GetCarCoordinates(car)
								if(IsPlayerNearCoords(cx, cy, cz, 5)) then
									if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
										supplies = supplies + 4
										SaveAcid()
										experience = experience + 200
										SaveStats()
										DrawMessage("~y~Mission completed", "You have got 4 supplies and 200 EXP")
										EndMission()
									end
								end
							end
						end
					else
						DrawMessage("~r~Mission failed", "Truck destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 21) then
				if(currstage == 0) then
					local delivered = 0
					for i=1,5,1 do
						if(DoesBlipExist(blips[i])) then
							local bp = GetBlipCoords(blips[i])
							DrawCheckpointWithAlpha(bp.x, bp.y, bp.z, 1.1, 255, 255, 0, 100)
							if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
								RemoveBlip(blips[i])
								PrintStringWithLiteralStringNow("STRING", "~y~Delivered!", 2000, 1)
							end
						else
							delivered = delivered + 1
						end
					end
					if(delivered == 5) then
						local finalcash = 2000*drugs
						drugs = 0
						SaveAcid()
						money = money + finalcash
						experience = experience + 200
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalcash .. "$ and 200 EXP")
						EndMission()
					end
				end
			elseif(currmission == 22) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							for i=1,3,1 do
								local rx,ry,rz,rh = GetRandomNodeInRadius(50)
								vehs[i+1] = SpawnCar(GetHashKey("police2"), rx, ry, rz, rh)
								for j=1,4,1 do
									peds[4*(i-1)+j] = SpawnPed(GetHashKey("M_Y_COP"), rx, ry, rz, rh)
									blips[4*(i-1)+j] = AddBlipForChar(peds[4*(i-1)+j])
									GiveWeaponToChar(peds[4*(i-1)+j], 7, 1000, 1)
									if(j == 1) then
										WarpCharIntoCar(peds[4*(i-1)+j], vehs[i+1])
									else
										WarpCharIntoCarAsPassenger(peds[4*(i-1)+j], vehs[i+1], j-2)
									end
								end
							end
							SetObjective("Get rid of ~y~cops")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Vehicle destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						local pedskilled = 0
						for i=1,12,1 do
							if(not IsCharDead(peds[i])) then
								AttackPlayer(peds[i])
							else
								RemoveBlip(blips[i])
								pedskilled = pedskilled + 1
							end
						end
						if(pedskilled == 12) then
							SetObjective("Lose ~y~wanted level")
							currstage = 2
						end
					else
						DrawMessage("~r~Mission failed", "Vehicle destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
					if(not IsCarDead(vehs[1])) then
						if(StoreWantedLevel(GetPlayerId()) == 0) then
							local coords = {
							{588.98132, 742.5387, 2.80086, 267.193054199219, 0},
							{439.95923, 19.47267, 8.75881, 282.642120361328, 0},
							{-1037.40723, -557.08167, 2.85199, 0.00653576385229826, 0},
							{1401.146, -839.17981, 8.1579, 193.946792602539, 0},
							{1103.10193, 2005.81213, 3.72806, 296.843292236328, 0},
							}
							local cid = GetClosestCoordWithIndex(coords)
							blips[1] = AddBlipForCoord(coords[cid][1], coords[cid][2], coords[cid][3])
							SetRoute(blips[1], true)
							SetObjective("Park ~y~this vehicle ~w~at ~y~the marked point")
							currstage = 3
						end
					else
						DrawMessage("~r~Mission failed", "Vehicle destroyed.")
						EndMission()
					end
				elseif(currstage == 3) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 2.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							local finalcash = 2000*drugs
							drugs = 0
							SaveAcid()
							money = money + finalcash
							experience = experience + 200
							SaveStats()
							DrawMessage("~y~Mission completed", "You have got " .. finalcash .. "$ and 200 EXP")
							EndMission()
						end
					else
						DrawMessage("~r~Mission failed", "Vehicle destroyed.")
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