local agencyprice = 200000
local agencycoords = {
{-80.0815, 51.95913, 19.62856, 175.404266357422}
}
local agencyblip = {}

agency = 0
local agepoints = 0
local agemis = {1, 1}
RegisterNetEvent('updAgency')
AddEventHandler('updAgency', function(data)
	for i=1,10,1 do
		if(data[i] == nil) then
			data[i] = 0
		end
	end
	agency = tonumber(data[1])
	agepoints = tonumber(data[2])
	for i=1,#agemis,1 do
		agemis[i] = tonumber(data[i+2])
	end
end)
SaveAgency = function()
	local data = {}
	data[1] = agency
	data[2] = agepoints
	for i=1,#agemis,1 do
		data[i+2] = agemis[i]
	end
	TriggerServerEvent('saveAgency', data)
end

local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end
local misvar = {}

CreateThread(function()
	while true do
		Wait(0)
		for i=1,#agencycoords,1 do
			if(not DoesBlipExist(agencyblip[i])) then
				agencyblip[i] = AddBlipForCoord(agencycoords[i][1], agencycoords[i][2], agencycoords[i][3], _i)
				ChangeBlipSprite(agencyblip[i], 82)
				ChangeBlipScale(agencyblip[i], 0.7)
				ChangeBlipNameFromAscii(agencyblip[i], "Agency")
				SetBlipAsShortRange(agencyblip[i], true)
			end
			if(agency == 0) then
				DrawTextAtCoord(agencycoords[i][1], agencycoords[i][2], agencycoords[i][3], "Agency Price:_" .. agencyprice .. "$ Level_needed:_50", 20)
				ChangeBlipColour(agencyblip[i], 0)
			else
				DrawTextAtCoord(agencycoords[i][1], agencycoords[i][2], agencycoords[i][3], "Agency", 20)
				ChangeBlipColour(agencyblip[i], 2)
			end
			DrawCheckpointWithDist(agencycoords[i][1], agencycoords[i][2], agencycoords[i][3]-1, 1.1, 255, 255, 0, 100)
			if(IsPlayerNearCoords(agencycoords[i][1], agencycoords[i][2], agencycoords[i][3], 1)) then
				DrawDescription("Agency", {
				-----------------------------------------------------------------------------------------------
				"Agency provides you access to a set of missions - contracts. By completing them you not only",
				"receive a payment but you also can unlock VIP-contracts. Such contracts are sets of consistent",
				"plot-related missions; payment is received only after full completion of all of them.",
				"Besides that owning an agency lets you receive contract killer missions. They are marked with",
				"a white person blip on the map which marks a location a payphone from where you can get a",
				"target to kill. Objective text will specify a bonus condition. If you meet this condition, you",
				"receive an increased reward. New target can be obtained only after 10 minutes cooldown (you",
				"will be notified in the chat when you can start new contract killer mission).",
				"Also you can use your phone to pay to remove wanted level any time you need it."
				})
				if(agency == 0) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to purchase ~y~this agency ~w~for ~g~" .. agencyprice .. "$", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						if(level >= 50) then
							if(org > 0) then
								if(money >= agencyprice) then
									money = money - agencyprice
									SaveStats()
									agency = i
									SaveAgency()
									TriggerEvent('chatMessage', '[Agency]', {0, 255, 0}, 'This agency has been successfully purchased!')
								else
									TriggerEvent('chatMessage', '[Agency]', {255, 0, 0}, 'You cannot afford it!')
								end
							else
								TriggerEvent('chatMessage', '[Agency]', {255, 0, 0}, 'You must own an organization!')
							end
						else
							TriggerEvent('chatMessage', '[Agency]', {255, 0, 0}, 'You must reach level 50!')
						end
					end
				elseif(agency == i) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~open agency menu", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						::main::
						local tempitems = {}
						tempitems[#tempitems+1] = "Contract points: ~y~" .. agepoints
						tempitems[#tempitems+1] = "Collect income from all businesses"
						tempitems[#tempitems+1] = "Contracts"
						tempitems[#tempitems+1] = "VIP Contracts"
						--tempitems[#tempitems+1] = "Clan"
						DrawWindow("Agency", tempitems)
						while menuactive do
							Wait(0)
							if(currbutton == 1) then
								DrawDescription("Contract points", {
								-----------------------------------------------------------------------------------------------
								"You get contract points for completing contracts. These points are needed to launch VIP",
								"Contracts."
								})
							elseif(currbutton == 3) then
								DrawDescription("Contracts", {
								-----------------------------------------------------------------------------------------------
								"There are several contracts which can be launched but in this list you always see only 2 of",
								"them. Each time you complete a contract, this list gets refreshed and replaced by other",
								"contracts."
								})
							end
						end
						if(menuresult > 0) then
							if(tempitems[menuresult] == "Contract points: ~y~" .. agepoints) then
								goto main
							elseif(tempitems[menuresult] == "Collect income from all businesses") then
								local tempmoney = 0
								for j=1,#biz,1 do
									tempmoney = tempmoney + bizmoney[j]
									bizmoney[j] = 0
								end
								SaveBizMoney()
								money = money + tempmoney
								SaveStats()
								TriggerEvent('chatMessage', '[Business]', {0, 255, 0}, 'Income collected (+' .. tempmoney .. '$)')
							elseif(tempitems[menuresult] == "Contracts") then
								if(#misvar == 0) then
									misvar[1] = GenerateRandomIntInRange(1, 7)
									misvar[2] = GenerateRandomIntInRange(1, 7)
									while misvar[2] == misvar[1] do
										misvar[2] = GenerateRandomIntInRange(1, 7)
									end
								end
								local tempitems = {}
								--[[tempitems[#tempitems+1] = "Asset Protection"
								tempitems[#tempitems+1] = "Gang Termination"
								tempitems[#tempitems+1] = "Liquidize Assets"
								tempitems[#tempitems+1] = "Recover Valuables"
								tempitems[#tempitems+1] = "Rescue Operation"
								tempitems[#tempitems+1] = "Vehicle Recovery"]]
								if(misvar[1] == 1) then
									tempitems[#tempitems+1] = "Asset Protection"
								elseif(misvar[1] == 2) then
									tempitems[#tempitems+1] = "Gang Termination"
								elseif(misvar[1] == 3) then
									tempitems[#tempitems+1] = "Liquidize Assets"
								elseif(misvar[1] == 4) then
									tempitems[#tempitems+1] = "Recover Valuables"
								elseif(misvar[1] == 5) then
									tempitems[#tempitems+1] = "Rescue Operation"
								elseif(misvar[1] == 6) then
									tempitems[#tempitems+1] = "Vehicle Recovery"
								end
								if(misvar[2] == 1) then
									tempitems[#tempitems+1] = "Asset Protection"
								elseif(misvar[2] == 2) then
									tempitems[#tempitems+1] = "Gang Termination"
								elseif(misvar[2] == 3) then
									tempitems[#tempitems+1] = "Liquidize Assets"
								elseif(misvar[2] == 4) then
									tempitems[#tempitems+1] = "Recover Valuables"
								elseif(misvar[2] == 5) then
									tempitems[#tempitems+1] = "Rescue Operation"
								elseif(misvar[2] == 6) then
									tempitems[#tempitems+1] = "Vehicle Recovery"
								end
								DrawWindow("Contracts", tempitems)
								while menuactive do
									Wait(0)
									if(tempitems[currbutton] == "Asset Protection") then
										DrawDescription("Asset Protection", {
										-----------------------------------------------------------------------------------------------
										"Reach a location and meet the crew. Team up to protect this area from enemies for some period",
										"of time and leave this area."
										})
									elseif(tempitems[currbutton] == "Gang Termination") then
										DrawDescription("Gang Termination", {
										-----------------------------------------------------------------------------------------------
										"Reach an area, find several highly protected enemy units and kill them all."
										})
									elseif(tempitems[currbutton] == "Liquidize Assets") then
										DrawDescription("Liquidize Assets", {
										-----------------------------------------------------------------------------------------------
										"Follow the helicopter to find out an enemy's hideout location. Destroy all vans there and",
										"plant a bomb to entirely get rid of this place."
										})
									elseif(tempitems[currbutton] == "Recover Valuables") then
										DrawDescription("Recover Valuables", {
										-----------------------------------------------------------------------------------------------
										"Locate a safe in a marked location and find codes to open it. Collect its content and bring",
										"to the agency."
										})
									elseif(tempitems[currbutton] == "Rescue Operation") then
										DrawDescription("Rescue Operation", {
										-----------------------------------------------------------------------------------------------
										"Rescue a client surrounded by an enemy group and bring them to their safehouse."
										})
									elseif(tempitems[currbutton] == "Vehicle Recovery") then
										DrawDescription("Vehicle Recovery", {
										-----------------------------------------------------------------------------------------------
										"Return a vehicle stolen by mobsters to the agency."
										})
									end
								end
								if(menuresult > 0) then
									if(coop[ConvertIntToPlayerindex(GetPlayerId())] == -1) then
										if(missionstarted == 0) then
											if(tempitems[menuresult] == "Asset Protection") then
												local coords = {
												{-91.78078, -332.42535, 14.70588, 0.863207221031189},
												{-330.0694, 1134.17981, 13.49852, 45.6603088378906},
												{-1099.48999, 1288.95874, 24.60139, 5.56892013549805},
												{-1670.21387, 126.53448, 12.41465, 176.466888427734},
												{834.0036, -582.33002, 13.85855, 359.029235839844},
												{1640.04663, 438.80798, 29.16832, 224.663879394531},
												{884.84125, 1649.10767, 17.05901, 211.577941894531}
												}
												local rnd = GenerateRandomIntInRange(1, #coords+1)
												for i=1,5,1 do
													peds[i] = SpawnPed(GetHashKey("m_y_gmaf_hi_02"), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
													GiveWeaponToChar(peds[i], 15, 1000, 1)
												end
												blips[1] = AddBlipForCoord(coords[rnd][1], coords[rnd][2], coords[rnd][3])
												SetRoute(blips[1], true)
												SetObjective("Reach ~y~the marked point ~w~and meet your crewmates")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 1
												missionstarted = 1
											elseif(tempitems[menuresult] == "Gang Termination") then
												local coords = { --first 3 are targets
												{
												{1175.84009, 1797.28247, 10.13641, 211.440551757813},
												{1181.93958, 1820.10815, 10.13133, 1.4703540802002},
												{1201.32568, 1815.87134, 10.13689, 271.286346435547},
												{1185.4093, 1784.19434, 10.10286, 187.668548583984},
												{1170.20374, 1789.06287, 10.13712, 73.2621383666992},
												{1165.46985, 1797.8136, 10.91505, 83.5293045043945},
												{1197.76697, 1782.88599, 10.10024, 266.591186523438},
												{1184.12781, 1800.01819, 10.0961, 4.05491256713867},
												{1191.80652, 1823.12061, 10.27237, 12.5167169570923},
												{1206.86731, 1807.69153, 10.18865, 186.686111450195},
												{1181.32214, 1835.11707, 10.18944, 356.730621337891},
												{1173.54858, 1804.11206, 10.181, 82.3319320678711},
												{1189.41382, 1793.5719, 10.19371, 89.3958892822266}
												},
												{
												{1526.57568, 527.01141, 29.37977, 223.126983642578},
												{1526.18506, 550.93604, 29.41293, 345.421875},
												{1503.91846, 526.9873, 29.41784, 125.789031982422},
												{1491.70227, 521.80365, 29.33011, 127.701721191406},
												{1511.77637, 532.22089, 29.40106, 68.4972076416016},
												{1525.5968, 532.84271, 29.28296, 292.132873535156},
												{1530.12036, 517.97198, 29.30436, 201.280410766602},
												{1541.71179, 516.90637, 29.3583, 239.447845458984},
												{1541.67395, 535.25751, 29.30436, 338.861206054688},
												{1546.97644, 551.81647, 29.30437, 280.787261962891},
												{1542.80505, 563.00293, 29.3045, 78.9517593383789},
												{1528.75769, 568.34399, 29.39805, 27.3410491943359},
												{1525.89905, 577.92773, 29.4093, 3.97179412841797}
												},
												{
												{-229.69737, 1024.40491, 7.29846, 205.91667175293},
												{-255.4641, 1036.85242, 7.88013, 66.4547119140625},
												{-231.51045, 1070.65527, 6.12224, 319.463958740234},
												{-221.55429, 1060.38037, 6.16424, 323.323120117188},
												{-226.86641, 1084.54395, 6.15572, 339.719421386719},
												{-240.03731, 1084.37, 6.37726, 77.183219909668},
												{-248.80861, 1054.39404, 6.45185, 204.719375610352},
												{-277.98703, 1040.67578, 7.78793, 95.4710006713867},
												{-257.73444, 1014.10278, 6.21653, 178.88410949707},
												{-245.9198, 1007.25537, 6.46588, 256.601654052734},
												{-228.67946, 1004.35535, 6.16557, 262.159698486328},
												{-218.00345, 1013.50793, 6.16327, 309.59130859375},
												{-222.54697, 1036.14063, 6.16354, 321.690399169922}
												},
												{
												{-1252.8302, 1642.82996, 34.24964, 78.6966094970703},
												{-1250.65259, 1673.01013, 34.43857, 3.75425434112549},
												{-1221.28186, 1678.87036, 34.56129, 302.792724609375},
												{-1235.17578, 1640.76416, 34.2548, 247.392837524414},
												{-1220.93774, 1637.31799, 34.25381, 237.338775634766},
												{-1251.10864, 1652.51196, 34.24963, 38.0670890808105},
												{-1243.09631, 1678.88477, 34.43844, 316.869537353516},
												{-1229.18909, 1671.46204, 34.56144, 251.218612670898},
												{-1216.55481, 1685.91772, 34.56126, 328.464324951172},
												{-1207.57092, 1676.1283, 34.56141, 227.432662963867},
												{-1195.84875, 1672.24487, 34.56144, 255.388275146484},
												{-1252.06531, 1685.69592, 34.43843, 187.024505615234},
												{-1254.40125, 1665.98853, 34.35292, 170.824310302734}
												},
												{
												{-1430.58777, -471.90482, 3.10292, 258.617218017578},
												{-1457.11877, -474.91211, 3.10292, 111.531562805176},
												{-1493.66272, -467.01053, 3.02875, 351.474395751953},
												{-1499.96484, -465.77582, 2.87798, 62.8734741210938},
												{-1489.35925, -460.46118, 3.02862, 346.028594970703},
												{-1469.83533, -460.59183, 3.03096, 288.046569824219},
												{-1455.98657, -460.9498, 3.03812, 313.526794433594},
												{-1449.41931, -469.98691, 3.10292, 358.433349609375},
												{-1433.52856, -467.79288, 3.10292, 295.426147460938},
												{-1421.21008, -474.86545, 3.07414, 243.153228759766},
												{-1420.29749, -463.50519, 2.98849, 357.821929931641},
												{-1441.3208, -460.87061, 3.03655, 6.54086780548096},
												{-1466.38062, -474.92862, 3.80232, 268.032165527344}
												}
												}
												local rnd = GenerateRandomIntInRange(1, #coords+1)
												for i=1,3,1 do
													peds[i] = SpawnPed(GetHashKey("M_Y_GAFR_HI_01"), coords[rnd][i][1], coords[rnd][i][2], coords[rnd][i][3], coords[rnd][i][4])
													GiveWeaponToChar(peds[i], 13, 1000, 1)
													SetCharHealth(peds[i], 1000)
													blips[i] = AddBlipForChar(peds[i])
												end
												for i=4,13,1 do
													peds[i] = SpawnPed(GetHashKey("M_Y_GAFR_LO_01"), coords[rnd][i][1], coords[rnd][i][2], coords[rnd][i][3], coords[rnd][i][4])
													GiveWeaponToChar(peds[i], 9, 1000, 1)
												end
												SetObjective("Eliminate ~y~the targets")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 2
												missionstarted = 1
											elseif(tempitems[menuresult] == "Liquidize Assets") then
												local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
												local angle = GenerateRandomIntInRange(0, 360, _i)
												local radius = GenerateRandomIntInRange(100, 1000, _i)
												local rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
												vehs[1] = SpawnCar(GetHashKey("MAVERICK"), rx, ry, rz+100, rh)
												blips[1] = AddBlipForCar(vehs[1])
												peds[1] = SpawnPed(GetHashKey("M_M_PITALIAN_01"), rx, ry, rz+100, rh)
												WarpCharIntoCar(peds[1], vehs[1])
												SetHeliStabiliser(vehs[1])
												SetHeliBladesFullSpeed(vehs[1])
												FreezeCarPosition(vehs[1], true)
												SetObjective("Reach ~y~the helicopter")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 3
												missionstarted = 1
											elseif(tempitems[menuresult] == "Recover Valuables") then
												coords = { --1st is safe, other 3 are codes
												{
												{1199.35388, 1695.42114, 17.72685, 43.2325820922852, -2096494209},
												{1179.5365, 1706.1189, 17.72698, 227.253616333008, -2096494209},
												{1166.81311, 1667.62903, 17.72696, 311.540069580078, -2096494209},
												{1160.40356, 1690.55408, 17.56974, 313.58837890625, -2096494209}
												},
												{
												{-1572.125, 19.11241, 10.01533, 355.615325927734, -534648211},
												{-1581.89575, 0.20224, 10.01544, 353.836242675781, 713594162},
												{-1558.82678, 10.45711, 10.01534, 86.1492233276367, -1634702078},
												{-1563.21155, 5.08487, 10.01533, 355.197570800781, -1634702078}
												}
												}
												rnd = GenerateRandomIntInRange(1, #coords+1)
												objs[1] = SpawnObject(GetHashKey("gb_safe01"), coords[rnd][1][1], coords[rnd][1][2], coords[rnd][1][3]-1, coords[rnd][1][4]-180, coords[rnd][1][5])
												FreezeObjectPosition(objs[1], true)
												blips[1] = AddBlipForObject(objs[1])
												SetObjective("Reach ~y~the marked point ~w~and find ~y~a safe")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 4
												missionstarted = 1
											elseif(tempitems[menuresult] == "Rescue Operation") then
												local coords = { --1st is client, others are enemies
												{
												{-53.34193, -950.01965, 4.77349, 0.793695271015167, 0},
												{-48.74761, -946.23315, 4.85953, 39.8100280761719, 0},
												{-60.7126, -947.27185, 4.83574, 307.783386230469, 0},
												{-59.64063, -935.17712, 4.95751, 21.317455291748, 0},
												{-57.37371, -923.3913, 5.49466, 178.691207885742, 0},
												{-49.68887, -929.22314, 4.96379, 288.423492431641, 0},
												{-37.9664, -939.96301, 4.95135, 35.8122367858887, 0},
												{-26.53913, -940.12451, 4.98165, 273.441955566406, 0},
												{-28.07051, -927.44037, 5.02877, 356.020568847656, 0},
												{-41.16333, -915.95752, 5.0088, 27.1825428009033, 0}
												},
												{
												{-244.00761, 690.38641, 3.4475, 308.946746826172, 0},
												{-228.46127, 690.98608, 3.44741, 39.5024223327637, 0},
												{-234.54549, 695.09619, 3.4474, 12.5872974395752, 0},
												{-228.11366, 700.48975, 3.4474, 6.6866307258606, 0},
												{-233.68306, 708.21436, 3.4474, 24.9264717102051, 0},
												{-228.21097, 714.70679, 3.4474, 351.174499511719, 0},
												{-243.49295, 717.79016, 3.42453, 46.7169723510742, 0},
												{-242.75491, 708.27618, 3.44621, 336.779022216797, 0},
												{-239.08037, 720.3703, 3.43585, 3.62265753746033, 0},
												{-223.4809, 720.03326, 3.44277, 46.5743179321289, 0}
												},
												{
												{397.29407, 1120.90405, 2.72033, 216.872360229492, 0},
												{396.92807, 1107.24939, 2.72034, 187.202438354492, 0},
												{406.9509, 1112.42957, 1.66701, 254.489944458008, 0},
												{411.95352, 1112.94519, 1.66701, 294.372009277344, 0},
												{424.67896, 1112.1062, 1.66701, 263.533050537109, 0},
												{438.14267, 1112.8313, 1.66701, 289.442565917969, 0},
												{437.87674, 1119.71606, 2.71894, 257.102111816406, 0},
												{423.71848, 1120.8114, 2.71894, 47.6404228210449, 0},
												{410.43942, 1118.87292, 2.71895, 103.183555603027, 0},
												{406.94873, 1122.4491, 2.71894, 15.5114307403564, 0}
												},
												{
												{736.44659, 1932.74316, 27.14323, 120.005241394043, 0},
												{733.86023, 1923.16174, 27.16421, 135.095687866211, 0},
												{723.08771, 1938.42065, 27.16422, 33.5049781799316, 0},
												{713.54456, 1940.74561, 27.16421, 78.4088439941406, 0},
												{713.22729, 1932.40967, 27.16421, 160.842483520508, 0},
												{719.04858, 1923.73169, 27.16421, 176.780487060547, 0},
												{722.58551, 1913.16406, 27.16421, 181.177597045898, 0},
												{711.02289, 1909.89355, 27.16421, 95.0995178222656, 0},
												{703.96692, 1921.79285, 27.16419, 45.7069206237793, 0},
												{702.01752, 1936.52734, 27.1642, 16.8575992584229, 0}
												},
												{
												{2107.02588, 157.79892, 5.81513, 229.133239746094, 0},
												{2113.06519, 144.74678, 6.15098, 349.811645507813, 0},
												{2114.98413, 152.67497, 5.81517, 259.648284912109, 0},
												{2117.17773, 161.95578, 5.81517, 304.159118652344, 0},
												{2123.11304, 156.12851, 5.81517, 227.571655273438, 0},
												{2129.70801, 162.54968, 5.81517, 309.917602539063, 0},
												{2120.47754, 145.52733, 5.81517, 168.95817565918, 0},
												{2113.49854, 139.2467, 5.81517, 250.228790283203, 0},
												{2131.20313, 149.57718, 5.81517, 278.731689453125, 0},
												{2130.01074, 170.36823, 5.81526, 151.778137207031, 0}
												},
												{
												{908.8764, -635.08228, 15.02667, 257.67138671875, 0},
												{917.25641, -625.47699, 14.58366, 273.593292236328, 0},
												{911.10828, -649.56415, 16.10759, 204.575714111328, 0},
												{918.78003, -644.84497, 15.61433, 254.826126098633, 0},
												{929.11688, -637.35315, 14.76287, 297.446350097656, 0},
												{933.11694, -629.76251, 14.53553, 290.964263916016, 0},
												{941.90356, -621.08447, 14.35429, 313.481140136719, 0},
												{940.26501, -638.32318, 14.54247, 184.285171508789, 0},
												{937.95465, -650.65314, 14.89273, 334.899963378906, 0},
												{928.04706, -652.18616, 15.33246, 11.6595849990845, 0}
												},
												{
												{-994.36481, -277.5535, 2.92335, 131.682373046875, 0},
												{-994.18201, -284.81512, 2.92335, 172.916473388672, 0},
												{-1002.1745, -275.30756, 2.92335, 182.908569335938, 0},
												{-1007.52649, -283.41721, 2.92335, 146.416091918945, 0},
												{-994.55603, -300.61368, 2.92335, 46.6813087463379, 0},
												{-1007.03973, -297.39133, 2.92335, 71.2034912109375, 0},
												{-984.96985, -295.25333, 2.92335, 276.000732421875, 0},
												{-974.81555, -296.42444, 2.92335, 261.727416992188, 0},
												{-1014.08398, -313.66858, 2.92335, 149.98323059082, 0},
												{-1026.34131, -309.57053, 2.92335, 128.009841918945, 0}
												},
												{
												{-1207.73059, 596.77808, 4.37801, 178.402160644531, 0},
												{-1213.54858, 590.90771, 4.37801, 215.568542480469, 0},
												{-1218.82385, 586.75775, 4.37801, 192.705642700195, 0},
												{-1201.60376, 588.99042, 4.37801, 261.324432373047, 0},
												{-1195.86267, 596.26422, 4.37801, 294.358581542969, 0},
												{-1195.599, 582.91748, 4.37801, 250.122589111328, 0},
												{-1203.03394, 575.5213, 4.37801, 305.253112792969, 0},
												{-1213.79163, 570.46979, 4.37801, 222.057800292969, 0},
												{-1206.07434, 566.70575, 4.37801, 252.603149414063, 0},
												{-1186.36475, 586.91681, 4.37801, 282.541931152344, 0}
												}
												}
												local rnd = GenerateRandomIntInRange(1, #coords+1)
												peds[1] = SpawnPed(GetHashKey("M_Y_GMAF_HI_01"), coords[rnd][1][1], coords[rnd][1][2], coords[rnd][1][3], coords[rnd][1][4])
												blips[1] = AddBlipForChar(peds[1])
												for i=2,10,1 do
													peds[i] = SpawnPed(GetHashKey("M_M_GTRI_HI_01"), coords[rnd][i][1], coords[rnd][i][2], coords[rnd][i][3], coords[rnd][i][4])
													GiveWeaponToChar(peds[i], 12, 1000, 1)
												end
												SetObjective("Find and rescue ~y~the client")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 5
												missionstarted = 1
											elseif(tempitems[menuresult] == "Vehicle Recovery") then
												local coords = { --1st is car, others are enemies
												{
												{968.9563, -326.9346, 19.24034, 178.311111450195, 0},
												{977.14728, -326.06113, 19.24034, 128.263763427734, 0},
												{977.92114, -336.12857, 19.24034, 257.175537109375, 0},
												{977.44977, -342.51233, 19.26604, 5.53046846389771, 0},
												{970.88776, -342.52658, 19.24968, 311.112640380859, 0},
												{953.35742, -341.91019, 19.24034, 109.443626403809, 0},
												{957.02032, -334.55502, 19.24034, 63.2575149536133, 0},
												{956.87567, -325.85471, 19.24034, 85.2909240722656, 0},
												{952.90454, -319.30917, 19.35799, 1.40990459918976, 0},
												{948.12726, -337.13623, 18.26248, 346.116760253906, 0},
												{988.90002, -336.43561, 19.6714, 271.095489501953, 0}
												},
												{
												{1999.21521, 388.59933, 18.02627, 271.201843261719, 0},
												{2009.047, 388.28531, 18.14999, 257.661468505859, 0},
												{2016.28162, 396.75534, 18.44555, 296.07958984375, 0},
												{1996.11365, 400.29404, 18.1106, 68.7583236694336, 0},
												{1995.57495, 407.23767, 18.16754, 31.7330646514893, 0},
												{2020.11621, 412.22867, 18.41348, 268.407806396484, 0},
												{2005.24915, 410.59598, 18.25922, 152.42529296875, 0},
												{2008.11084, 399.9119, 18.2898, 269.215576171875, 0},
												{1986.5863, 414.11642, 18.23485, 61.1253280639648, 0},
												{1984.66101, 405.16339, 18.16455, 158.383056640625, 0},
												{1980.60742, 393.27728, 18.09106, 177.360427856445, 0}
												},
												{
												{1185.96204, 1381.66235, 16.99154, 1.4437108039856, 0},
												{1175.10217, 1393.67444, 16.99154, 283.037322998047, 0},
												{1174.4978, 1400.31897, 16.99154, 305.413665771484, 0},
												{1191.51819, 1392.48901, 16.99213, 86.8233642578125, 0},
												{1197.41992, 1401.29236, 16.99213, 298.924682617188, 0},
												{1187.57153, 1406.24231, 16.99214, 35.1108016967773, 0},
												{1192.35364, 1374.0448, 16.99154, 204.662612915039, 0},
												{1175.41309, 1372.96143, 16.99243, 100.079795837402, 0},
												{1181.72046, 1416.8634, 16.77206, 0.159620463848114, 0},
												{1191.37671, 1416.5791, 16.77324, 274.940093994141, 0},
												{1199.65161, 1414.06677, 16.7694, 42.9026832580566, 0}
												},
												{
												{-115.51607, 1590.00708, 19.98913, 188.888717651367, 0},
												{-109.76154, 1575.8595, 18.4927, 191.52507019043, 0},
												{-116.22166, 1574.8772, 19.09956, 166.417205810547, 0},
												{-118.69726, 1568.375, 18.97003, 130.588348388672, 0},
												{-119.13434, 1582.65027, 19.71375, 166.803268432617, 0},
												{-110.31593, 1584.86072, 19.39254, 100.134719848633, 0},
												{-121.70014, 1602.34192, 20.42067, 25.6373176574707, 0},
												{-115.10378, 1607.9928, 20.59173, 342.607177734375, 0},
												{-126.50298, 1612.17969, 20.41233, 62.3427581787109, 0},
												{-119.17276, 1616.22961, 20.3914, 314.627685546875, 0},
												{-109.14011, 1618.01501, 19.94992, 328.664154052734, 0}
												},
												{
												{-985.36096, 1433.32043, 28.02068, 359.237640380859, 0},
												{-991.35284, 1433.94836, 28.02068, 98.8994903564453, 0},
												{-992.63263, 1440.95398, 28.02069, 14.1486854553223, 0},
												{-984.48499, 1445.16821, 28.02069, 339.260711669922, 0},
												{-976.65833, 1435.29749, 28.02068, 249.954330444336, 0},
												{-968.23376, 1434.58923, 28.02068, 329.695861816406, 0},
												{-969.0517, 1445.05054, 28.02068, 342.506469726563, 0},
												{-961.9101, 1452.35669, 28.02068, 286.919403076172, 0},
												{-955.00995, 1445.02185, 28.02061, 213.30615234375, 0},
												{-993.55713, 1453.22693, 28.02069, 51.0756645202637, 0},
												{-1008.18823, 1452.21985, 28.02071, 84.9410858154297, 0}
												},
												{
												{-1613.51111, 161.7085, 12.41451, 90.6742782592773, 0},
												{-1621.77222, 167.24721, 12.4145, 87.0120391845703, 0},
												{-1624.58618, 160.75867, 12.41451, 143.280639648438, 0},
												{-1604.86707, 155.60686, 12.41451, 225.401824951172, 0},
												{-1601.64905, 169.035, 12.41451, 349.196624755859, 0},
												{-1604.19604, 142.65309, 12.41465, 170.635803222656, 0},
												{-1627.34863, 149.77286, 12.4145, 182.648513793945, 0},
												{-1634.98816, 144.69862, 12.41465, 256.864379882813, 0},
												{-1633.6333, 172.16948, 12.41451, 8.22227573394775, 0},
												{-1624.18066, 179.86131, 12.41451, 344.810668945313, 0},
												{-1631.99304, 186.10768, 12.41451, 30.8911304473877, 0}
												}
												}
												local rnd = GenerateRandomIntInRange(1, #coords+1)
												local hash = {
												"oracle",
												"comet",
												"nrg900",
												"sultanrs"
												}
												vehs[1] = SpawnCar(GetHashKey(hash[GenerateRandomIntInRange(1, #hash+1)]), coords[rnd][1][1], coords[rnd][1][2], coords[rnd][1][3], coords[rnd][1][4])
												blips[1] = AddBlipForCar(vehs[1])
												for i=1,10,1 do
													peds[i] = SpawnPed(GetHashKey("M_Y_GKOR_LO_01"), coords[rnd][i+1][1], coords[rnd][i+1][2], coords[rnd][i+1][3], coords[rnd][i+1][4])
													GiveWeaponToChar(peds[i], 9, 1000, 1)
												end
												SetObjective("Recover ~y~the vehicle")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 6
												missionstarted = 1
											end
										else
											TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Mission in progress!')
										end
									else
										TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Only a leader of your co-op team can start missions!')
									end
								else
									goto main
								end
							elseif(tempitems[menuresult] == "VIP Contracts") then
								::vip::
								local tempitems = {}
								tempitems[#tempitems+1] = "Nightlife ~y~(5 points)"
								tempitems[#tempitems+1] = "High Society ~y~(8 points)"
								DrawWindow("VIP_Contracts", tempitems)
								while menuactive do
									Wait(0)
									if(currbutton == 1) then
										DrawDescription("Nightlife", {
										-----------------------------------------------------------------------------------------------
										"Find a special device to place it near the contender's base in a night club, which will",
										"provide a great advangate in getting control over them."
										})
									elseif(currbutton == 2) then
										DrawDescription("High Society", {
										-----------------------------------------------------------------------------------------------
										"Make the mafia boss get out of his hideout to liquidize him and get control over the district."
										})
									end
								end
								if(menuresult > 0) then
									if(coop[ConvertIntToPlayerindex(GetPlayerId())] == -1) then
										if(missionstarted == 0) then
											if(tempitems[menuresult] == "Nightlife ~y~(5 points)") then
												if(agepoints >= 5) then
													local tempitems = {}
													if(agemis[1] >= 2) then
														tempitems[#tempitems+1] = "Leak ~g~(Done)"
													else
														tempitems[#tempitems+1] = "Leak"
													end
													if(agemis[1] >= 3) then
														tempitems[#tempitems+1] = "Yacht ~g~(Done)"
													else
														tempitems[#tempitems+1] = "Yacht"
													end
													tempitems[#tempitems+1] = "Finale"
													DrawWindow("Nightlife", tempitems)
													while menuactive do
														Wait(0)
														if(currbutton == 1) then
															DrawDescription("Leak", {
															-----------------------------------------------------------------------------------------------
															"There is a leaked information about special device location. We know several people who may",
															"potentially hold a flash drive with this information. Check each of them until you find it."
															})
														elseif(currbutton == 2) then
															DrawDescription("Yacht", {
															-----------------------------------------------------------------------------------------------
															"Using this flash drive we figured out that special device is located at the yacht. Reach it",
															"collect the briefcase and bring it to the agency."
															})
														elseif(currbutton == 3) then
															DrawDescription("Finale", {
															-----------------------------------------------------------------------------------------------
															"Now we can install this device into some vehicle and park it near the night club. There is a",
															"chance there will be some guards, so stay alarmed."
															})
														end
													end
													if(menuresult > 0) then
														if(menuresult == agemis[1]) then
															if(menuresult == 1) then
																local coords = {
																{508.00772, 1428.30444, 14.75183, 88.7984390258789, 65606395},
																{1367.30542, 193.53743, 31.68828, 0.17356875538826, -1632800252},
																{-1556.09009, 8.85046, 10.01533, 87.0965194702148, -1634702078}
																}
																for i=1,3,1 do
																	peds[i] = SpawnPed(GetHashKey("M_Y_GLAT_LO_01"), coords[i][1], coords[i][2], coords[i][3], coords[i][4], coords[i][5])
																	GiveWeaponToChar(peds[i], 9, 1000, 1)
																	blips[i] = AddBlipForChar(peds[i])
																end
																rnd = GenerateRandomIntInRange(1, #coords+1)
																SetObjective("One of ~y~targets ~w~has ~y~a flash drive~w~. Find it")
																TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
																currmission = 11
																missionstarted = 1
															elseif(menuresult == 2) then
																vehs[1] = SpawnCar(GetHashKey("tuga"), 2194.01318, 1448.17676, -0.1589-8, 16.1615886688232)
																LockCarDoors(vehs[1], 2)
																FreezeCarPosition(vehs[1], true)
																SetCarCanBeDamaged(vehs[1], false)
																SetCarCanBeVisiblyDamaged(vehs[1], false)
																local cx,cy,cz = GetCarCoordinates(vehs[1])
																local ch = GetCarHeading(vehs[1])
																for i=1,5,1 do
																	peds[i] = SpawnPed(GetHashKey("M_M_GTRI_HI_02"), cx+36*math.cos((ch-90)*math.pi/180), cy+36*math.sin((ch-90)*math.pi/180), cz-0.5, 0.0)
																	GiveWeaponToChar(peds[i], 9, 1000, 1)
																end
																for i=6,10,1 do
																	peds[i] = SpawnPed(GetHashKey("M_M_GTRI_HI_02"), cx+25*math.cos((ch-90)*math.pi/180), cy+25*math.sin((ch-90)*math.pi/180), cz+5.5, 0.0)
																	GiveWeaponToChar(peds[i], 11, 1000, 1)
																end
																for i=11,15,1 do
																	peds[i] = SpawnPed(GetHashKey("M_M_GTRI_HI_02"), cx+2*math.cos((ch+90)*math.pi/180), cy+2*math.sin((ch+90)*math.pi/180), cz+10.5, 0.0)
																	GiveWeaponToChar(peds[i], 15, 1000, 1)
																end
																objs[1] = SpawnObject(GetHashKey("cj_case_2"), cx+2*math.cos((ch+90)*math.pi/180), cy+2*math.sin((ch+90)*math.pi/180), cz+10.5, 0.0)
																FreezeObjectPosition(objs[1], true)
																blips[1] = AddBlipForObject(objs[1])
																SetObjective("Obtain ~y~the briefcase ~w~from ~y~the yacht")
																TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
																currmission = 12
																missionstarted = 1
															elseif(menuresult == 3) then
																blips[1] = AddBlipForCoord(960.48639, -377.17743, 16.54825)
																SetRoute(blips[1], true)
																SetObjective("Bring any car to ~y~the garage ~w~and install ~y~the hacking device")
																TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
																currmission = 13
																missionstarted = 1
															end
														elseif(menuresult < agemis[1]) then
															TriggerEvent('chatMessage', '[Contract]', {255, 0, 0}, 'This mission is already completed!')
														elseif(menuresult > agemis[1]) then
															TriggerEvent('chatMessage', '[Contract]', {255, 0, 0}, 'Complete previous mission first!')
														end
													else
														goto vip
													end
												else
													TriggerEvent('chatMessage', '[Contract]', {255, 0, 0}, 'Not enough contract points!')
													goto vip
												end
											elseif(tempitems[menuresult] == "High Society ~y~(8 points)") then
												if(agepoints >= 8) then
													local tempitems = {}
													if(agemis[2] >= 2) then
														tempitems[#tempitems+1] = "Attention ~g~(Done)"
													else
														tempitems[#tempitems+1] = "Attention"
													end
													if(agemis[2] >= 3) then
														tempitems[#tempitems+1] = "Lawyer ~g~(Done)"
													else
														tempitems[#tempitems+1] = "Lawyer"
													end
													tempitems[#tempitems+1] = "Finale"
													DrawWindow("High_society", tempitems)
													while menuactive do
														Wait(0)
														if(currbutton == 1) then
															DrawDescription("Attention", {
															-----------------------------------------------------------------------------------------------
															"We need to draw attention of the mafia boss. For that you should tail one of his capos until",
															"he reaches one of their businesses. Destroy this limo to remove a witness and plant a bomb",
															"at this place."
															})
														elseif(currbutton == 2) then
															DrawDescription("Lawyer", {
															-----------------------------------------------------------------------------------------------
															"Previous actions made the boss call his personal lawyer to settle issues caused by that. This",
															"is our chance to intercept this lawyer to get info about current boss' location."
															})
														elseif(currbutton == 3) then
															DrawDescription("Finale", {
															-----------------------------------------------------------------------------------------------
															"Using the lawyer we figured out that the boss is currently hiding in a highly protected area.",
															"Getting rid of his personal bodyguards will make him show up. Use this chance to eliminate him."
															})
														end
													end
													if(menuresult > 0) then
														if(menuresult == agemis[2]) then
															if(menuresult == 1) then
																coords = { --1st is target, 2nd is bomb
																{
																{-1529.82837, 770.90149, 25.25955, 267.666381835938, 0},
																{-1529.68567, 762.51721, 25.75999, 179.527587890625, 0}
																},
																{
																{551.04932, 1736.09375, 32.20451, 357.552795410156, 0},
																{562.29272, 1737.59644, 32.29465, 87.9334869384766, 0}
																},
																{
																{1805.08203, 720.0769, 25.78053, 88.7517547607422, 0},
																{1804.62305, 728.13751, 25.79229, 180.112503051758, 0}
																}
																}
																local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
																local angle = GenerateRandomIntInRange(0, 360, _i)
																local radius = GenerateRandomIntInRange(100, 1000, _i)
																local rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
																vehs[1] = SpawnCar(GetHashKey("stretch"), rx, ry, rz, rh)
																blips[1] = AddBlipForCar(vehs[1])
																peds[1] = SpawnPed(GetHashKey("M_M_PITALIAN_01"), rx, ry, rz, rh)
																WarpCharIntoCar(peds[1], vehs[1])
																rnd = GenerateRandomIntInRange(1, #coords+1)
																TaskCarMissionCoorsTarget(peds[1], vehs[1], coords[rnd][1][1], coords[rnd][1][2], coords[rnd][1][3], 4, 10.1, 4, 10, 10)
																blips[1] = AddBlipForCar(vehs[1])
																SetObjective("Tail ~y~the limo")
																TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
																currmission = 21
																missionstarted = 1
															elseif(menuresult == 2) then
																local coords = {
																{213.67833, 1001.54822, 15.04908, 268.771026611328, 0},
																{198.86957, 1001.94775, 14.70795, 266.938171386719, 0},
																{184.48564, 1002.63293, 14.71015, 267.473388671875, 0}
																}
																vehs[1] = SpawnCar(GetHashKey("cognoscenti"), coords[1][1], coords[1][2], coords[1][3], coords[1][4])
																for i=1,4,1 do
																	peds[i] = SpawnPed(GetHashKey("M_Y_GMAF_LO_01"), coords[1][1], coords[1][2], coords[1][3], coords[1][4])
																	GiveWeaponToChar(peds[i], 13, 1000, 1)
																	if(i == 1) then
																		WarpCharIntoCar(peds[i], vehs[1])
																	else
																		WarpCharIntoCarAsPassenger(peds[i], vehs[1], i-2)
																	end
																end
																TaskCarMission(peds[1], vehs[1], vehs[1], 1, 10.1, 0, 0, 10)
																
																vehs[2] = SpawnCar(GetHashKey("stretch"), coords[2][1], coords[2][2], coords[2][3], coords[2][4])
																peds[5] = SpawnPed(GetHashKey("M_Y_GMAF_LO_01"), coords[2][1], coords[2][2], coords[2][3], coords[2][4])
																GiveWeaponToChar(peds[5], 13, 1000, 1)
																WarpCharIntoCar(peds[5], vehs[2])
																TaskCarMission(peds[5], vehs[2], vehs[1], 2, 10.1, 0, 0, 10)
																peds[6] = SpawnPed(GetHashKey("M_Y_GMAF_HI_01"), coords[2][1], coords[2][2], coords[2][3], coords[2][4])
																WarpCharIntoCarAsPassenger(peds[6], vehs[2], 2)
																blips[1] = AddBlipForChar(peds[6])
																
																vehs[3] = SpawnCar(GetHashKey("cognoscenti"), coords[3][1], coords[3][2], coords[3][3], coords[3][4])
																for i=1,4,1 do
																	peds[i+6] = SpawnPed(GetHashKey("M_Y_GMAF_LO_01"), coords[3][1], coords[3][2], coords[3][3], coords[3][4])
																	GiveWeaponToChar(peds[i+6], 13, 1000, 1)
																	if(i == 1) then
																		WarpCharIntoCar(peds[i+6], vehs[3])
																	else
																		WarpCharIntoCarAsPassenger(peds[i+6], vehs[3], i-2)
																	end
																end
																TaskCarMission(peds[7], vehs[3], vehs[2], 2, 10.1, 0, 0, 10)
																
																SetObjective("Get control of ~y~a limo ~w~with ~y~the target~w~. Do not kill him")
																TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
																currmission = 22
																missionstarted = 1
															elseif(menuresult == 3) then
																local coords = {
																{1661.7561, 435.62088, 29.10563, 161.186676025391, 0},
																{1658.66919, 446.19409, 29.09286, 77.9869995117188, 0},
																{1661.11255, 455.66772, 29.07829, 345.756896972656, 0},
																{1675.24585, 435.02069, 29.01444, 214.476837158203, 0},
																{1682.00134, 437.08328, 29.02439, 279.205688476563, 0},
																{1687.69299, 416.24506, 29.05754, 286.954254150391, 0},
																{1679.29639, 412.97028, 28.95207, 81.2571792602539, 0},
																{1674.54309, 418.47815, 28.96306, 38.4081611633301, 0},
																{1667.95605, 413.11914, 28.95852, 309.646209716797, 0},
																{1663.14246, 418.53656, 29.07022, 54.2305946350098, 0},
																{1628.0863, 445.14059, 29.13745, 182.891387939453, 0},
																{1629.90271, 436.37439, 29.15109, 188.999389648438, 0},
																{1618.59204, 434.27063, 29.11638, 97.7061080932617, 0},
																{1609.29236, 431.71881, 29.0977, 128.350860595703, 0},
																{1600.33838, 431.50101, 29.0919, 264.907409667969, 0},
																{1630.4646, 414.84854, 28.99786, 11.2624082565308, 0},
																{1621.15442, 413.45334, 28.96789, 112.582038879395, 0},
																{1615.64124, 416.74384, 29.01938, 48.4089698791504, 0},
																{1610.17712, 413.57272, 29.00142, 65.9431457519531, 0},
																{1601.66138, 413.15866, 29.00876, 274.149505615234, 0}
																}
																for i=1,20,1 do
																	peds[i] = SpawnPed(GetHashKey("M_Y_GMAF_LO_02"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
																	GiveWeaponToChar(peds[i], 15, 1000, 1)
																	blips[i] = AddBlipForChar(peds[i])
																end
																SetObjective("Eliminate ~y~the bodyguards")
																TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
																currmission = 23
																missionstarted = 1
															end
														elseif(menuresult < agemis[2]) then
															TriggerEvent('chatMessage', '[Contract]', {255, 0, 0}, 'This mission is already completed!')
														elseif(menuresult > agemis[2]) then
															TriggerEvent('chatMessage', '[Contract]', {255, 0, 0}, 'Complete previous mission first!')
														end
													else
														goto vip
													end
												else
													TriggerEvent('chatMessage', '[Contract]', {255, 0, 0}, 'Not enough contract points!')
													goto vip
												end
											end
										else
											TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Mission in progress!')
										end
									else
										TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Only a leader of your co-op team can start missions!')
									end
								else
									goto main
								end
							end
						end
					end
				else
					PrintStringWithLiteralStringNow("STRING", "~r~You already own an agency!", 1000, 1)
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
					local bp = GetBlipCoords(blips[1])
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 10)) then
						group = CreateGroup(false, true)
						SetGroupLeader(group, GetPlayerChar(GetPlayerId()))
						for i=1,5,1 do
							SetGroupMember(group, peds[i])
							SetCharNeverLeavesGroup(peds[i], true)
						end
						Settimera(0)
						SetObjective("Protect ~y~this point ~w~for ~y~200 seconds")
						currstage = 1
					end
				elseif(currstage == 1) then
					if(Timera() < 200000) then
						SetObjective("Protect ~y~this point ~w~for ~y~" .. 200 - math.floor(Timera()/1000) .. " seconds")
						local pedsdead = 0
						for i=6,13,1 do
							if(IsCharDead(peds[i])) then
								RemoveBlip(blips[i+1])
								pedsdead = pedsdead + 1
							else
								local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
								if(IsPedNearCoords(peds[i], px, py, pz, 250)) then
									AttackPlayer(peds[i])
								else
									DeleteChar(peds[i])
								end
							end
						end
						if(pedsdead == 8) then
							DeleteCar(vehs[1])
							local rx,ry,rz,rh = GetRandomNodeInRadius(200)
							vehs[1] = SpawnCar(GetHashKey("cavalcade"), rx, ry, rz, rh)
							for i=6,9,1 do
								DeleteChar(peds[i+5])
								peds[i] = SpawnPed(GetHashKey("M_Y_CHINATOWN_03"), rx, ry, rz, rh)
								GiveWeaponToChar(peds[i], 14, 1000, 1)
								RemoveBlip(blips[i+1])
								blips[i+1] = AddBlipForChar(peds[i], _i)
								if(i == 6) then
									WarpCharIntoCar(peds[i], vehs[1])
								else
									WarpCharIntoCarAsPassenger(peds[i], vehs[1], i-7)
								end
							end
							local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
							local angle = GenerateRandomIntInRange(0, 360, _i)
							local radius = 200
							local rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
							DeleteCar(vehs[2])
							vehs[2] = SpawnCar(GetHashKey("cavalcade"), rx, ry, rz, rh)
							for i=10,13,1 do
								DeleteChar(peds[i+9])
								peds[i] = SpawnPed(GetHashKey("M_Y_CHINATOWN_03"), rx, ry, rz, rh)
								GiveWeaponToChar(peds[i], 14, 1000, 1)
								RemoveBlip(blips[i+1])
								blips[i+1] = AddBlipForChar(peds[i], _i)
								if(i == 10) then
									WarpCharIntoCar(peds[i], vehs[2])
								else
									WarpCharIntoCarAsPassenger(peds[i], vehs[2], i-11)
								end
							end
						end
						local bp = GetBlipCoords(blips[1])
						if(not IsPlayerNearCoords(bp.x, bp.y, bp.z, 10)) then
							local temptimer = Timera()
							Settimerb(0)
							while Timerb()<10000 do
								Wait(0)
								SetObjective("Get back to ~y~the point~w~! ~w~(~y~" .. 10 - math.floor(Timerb()/1000) .. " ~w~seconds left)")
								if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 10)) then
									Settimera(temptimer)
									break
								end
								if(IsPlayerDead(GetPlayerId())) then
									break
								end
							end
							if(Timerb() >= 10000) then
								DrawMessage("~r~Mission failed", "Protection area abandoned.")
								EndMission()
							end
						end
					else	
						misvar = {}
						agepoints = agepoints + 1
						SaveAgency()
						local finalreward = SeparateReward(10000, 500)
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						EndMission()
					end
				end
			elseif(currmission == 2) then
				if(currstage == 0) then
					local pedsdead = 0
					for i=1,13,1 do
						if(not IsCharDead(peds[i])) then
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,13,1 do
									AttackPlayer(peds[j])
								end
							end
						else
							RemoveBlip(blips[i])
							if(i <= 3) then
								pedsdead = pedsdead + 1
							end
						end
					end
					if(pedsdead == 3) then
						SetObjective("Leave ~y~this area")
						currstage = 1
					end
				elseif(currstage == 1) then
					local px,py,pz = GetCharCoordinates(peds[1])
					if(not IsPlayerNearCoords(px, py, pz, 200)) then
						misvar = {}
						agepoints = agepoints + 1
						SaveAgency()
						local finalreward = SeparateReward(8000, 400)
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						EndMission()
					end
				end
			elseif(currmission == 3) then
				if(currstage == 0) then
					if(IsCarDead(vehs[1])) then
						DrawMessage("~r~Mission failed", "Helicopter destroyed.")
						EndMission()
					elseif(IsCharDead(peds[1])) then
						DrawMessage("~r~Mission failed", "Helicopter driver is dead.")
						EndMission()
					else
						local cx,cy,cz = GetCarCoordinates(vehs[1])
						if(IsPlayerNearCoords(cx, cy, cz, 100) or IsPlayerNearCoords(cx, cy, cz-100, 100)) then
							coords = { --last coord is bomb
							{
							{-1512.78149, -64.72153, 6.30138, 291.473815917969},
							{-1510.36377, -70.59155, 6.30138, 291.390014648438},
							{-1505.125, -85.34504, 6.29151, 1.80325162410736},
							{-1502.91077, -54.23812, 6.78533, 196.95622253418}
							},
							{
							{-1070.75696, 925.0611, 13.60652, 180.785797119141},
							{-1061.10291, 924.61151, 13.63791, 180.335632324219},
							{-1083.98962, 934.07428, 13.58752, 92.8156280517578},
							{-1074.16687, 929.31134, 13.56053, 271.69091796875}
							},
							{
							{84.32368, 1412.67615, 3.32427, 140.896545410156},
							{89.12331, 1408.18311, 3.32427, 138.719451904297},
							{71.16992, 1413.57837, 3.32427, 231.536682128906},
							{79.40838, 1424.99841, 3.32427, 230.690536499023}
							},
							{
							{-406.59744, -461.87976, 4.93532, 299.287841796875},
							{-410.87262, -472.31644, 4.9461, 250.305114746094},
							{-418.1347, -477.21539, 4.9461, 238.604690551758},
							{-422.8064, -465.55075, 5.82232, 209.362533569336}
							},
							{
							{853.78802, -182.71288, 5.86771, 89.6523513793945},
							{851.98102, -178.34737, 5.85589, 138.842666625977},
							{851.25519, -192.47351, 5.92962, 14.2666521072388},
							{858.41016, -187.29956, 5.89145, 95.8892364501953}
							},
							{
							{1975.70605, 542.13965, 18.04605, 269.445220947266},
							{1976.052, 554.34015, 18.05005, 266.821441650391},
							{1983.10779, 560.07629, 18.0492, 178.237762451172},
							{1965.21216, 558.93335, 18.05163, 179.928527832031}
							},
							{
							{327.16644, 1871.82141, 17.77416, 268.717010498047},
							{327.72467, 1889.52771, 17.77259, 268.705413818359},
							{318.44138, 1883.00745, 22.03711, 86.9504623413086},
							{302.47482, 1895.73792, 22.03711, 81.9268951416016}
							}
							}
							rnd = GenerateRandomIntInRange(1, #coords+1)
							for i=2,4,1 do
								vehs[i] = SpawnCar(GetHashKey("burrito"), coords[rnd][i-1][1], coords[rnd][i-1][2], coords[rnd][i-1][3], coords[rnd][i-1][4])
							end
							FreezeCarPosition(vehs[1], false)
							TaskHeliMission(peds[1], vehs[1], 0, 0, coords[rnd][2][1], coords[rnd][2][2], coords[rnd][2][3]+100, 4, 10.1, 5, -1, Round(100.1)+1, 40)
							SetObjective("Follow ~y~the helicopter")
							currstage = 1
						end
					end
				elseif(currstage == 1) then
					if(IsCarDead(vehs[1])) then
						DrawMessage("~r~Mission failed", "Helicopter destroyed.")
						EndMission()
					elseif(IsCharDead(peds[1])) then
						DrawMessage("~r~Mission failed", "Helicopter driver is dead.")
						EndMission()
					else
						local cx,cy,cz = GetCarCoordinates(vehs[2])
						if(IsPedNearCoords(peds[1], cx, cy, cz+100, 50)) then
							RemoveBlip(blips[1])
							for i=2,4,1 do
								blips[i] = AddBlipForCar(vehs[i])
							end
							SetObjective("Destroy ~y~the marked vans")
							currstage = 2
						end
					end
				elseif(currstage == 2) then
					local carsdead = 0
					for i=2,4,1 do
						if(IsCarDead(vehs[i])) then
							RemoveBlip(blips[i])
							carsdead = carsdead + 1
						end
					end
					if(carsdead == 3) then
						blips[5] = AddBlipForCoord(coords[rnd][4][1], coords[rnd][4][2], coords[rnd][4][3])
						SetRoute(blips[1], true)
						SetObjective("Plant ~y~a bomb")
						currstage = 3
					end
				elseif(currstage == 3) then
					DrawCheckpointWithDist(coords[rnd][4][1], coords[rnd][4][2], coords[rnd][4][3]-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(coords[rnd][4][1], coords[rnd][4][2], coords[rnd][4][3], 1)) then
						RemoveBlip(blips[5])
						objs[1] = SpawnObject(GetHashKey("ec_bomb_ne"), coords[rnd][4][1], coords[rnd][4][2], coords[rnd][4][3]-1, coords[rnd][4][4])
						SetObjective("Leave ~y~this area")
						currstage = 4
					end
				elseif(currstage == 4) then
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(not IsPlayerNearCoords(ox, oy, oz, 100)) then
						misvar = {}
						agepoints = agepoints + 1
						SaveAgency()
						local finalreward = SeparateReward(10000, 500)
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						EndMission()
					end
				end
			elseif(currmission == 4) then
				if(currstage == 0) then
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(IsPlayerNearCoords(ox, oy, oz, 5)) then
						rnd2 = GenerateRandomIntInRange(2, 5)
						objs[2] = SpawnObject(GetHashKey("csbusinesscard"), coords[rnd][rnd2][1], coords[rnd][rnd2][2], coords[rnd][rnd2][3], coords[rnd][rnd2][4], coords[rnd][rnd2][5])
						SetObjective("Find ~y~the safe code ~w~in this area")
						currstage = 1
					end
				elseif(currstage == 1) then
					local ox,oy,oz = GetObjectCoordinates(objs[2])
					if(IsPlayerNearCoords(ox, oy, oz, 10)) then
						blips[2] = AddBlipForObject(objs[2])
						SetObjective("Collect ~y~the code")
						currstage = 2
					end
				elseif(currstage == 2) then
					local ox,oy,oz = GetObjectCoordinates(objs[2])
					if(IsPlayerNearCoords(ox, oy, oz, 3)) then
						RemoveBlip(blips[2])
						DeleteObject(objs[2])
						SetObjective("Collect ~y~the values ~w~from ~y~the safe")
						currstage = 3
					end
				elseif(currstage == 3) then
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(IsPlayerNearCoords(ox, oy, oz, 3)) then
						RemoveBlip(blips[1])
						blips[1] = AddBlipForCoord(-77.07187, 61.20687, 14.767)
						SetRoute(blips[1], true)
						SetObjective("Deliver ~y~the values ~w~to ~y~the agency")
						currstage = 4
					end
				elseif(currstage == 4) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
						misvar = {}
						agepoints = agepoints + 1
						SaveAgency()
						local finalreward = SeparateReward(5000, 300)
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						EndMission()
					end
				end
			elseif(currmission == 5) then
				if(currstage == 0) then
					for i=2,10,1 do
						if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
							for j=2,10,1 do
								AttackPlayer(peds[j])
							end
						end
					end
					if(not IsCharDead(peds[1])) then
						local px,py,pz = GetCharCoordinates(peds[1])
						if(IsPlayerNearCoords(px, py, pz, 5)) then
							RemoveBlip(blips[1])
							group = CreateGroup(false, true)
							SetGroupLeader(group, GetPlayerChar(GetPlayerId()))
							SetGroupMember(group, peds[1])
							SetCharNeverLeavesGroup(peds[1], true)
							local coords = {
							{-1194.93018, 1044.35962, 19.5786, 358.9130859375, 0},
							{-1760.89185, 288.62375, 25.3972, 148.496200561523, 0},
							{-433.55441, -270.63843, 7.21828, 358.786834716797, 0},
							{48.99086, 1278.86804, 20.34354, 268.684783935547, 0},
							{973.71698, 873.97607, 24.31471, 86.8264007568359, 0},
							{1531.25317, 173.66924, 23.02384, 218.724914550781, 0}
							}
							local rnd = GenerateRandomIntInRange(1, #coords+1)
							blips[1] = AddBlipForCoord(coords[rnd][1], coords[rnd][2], coords[rnd][3])
							SetRoute(blips[1], true)
							SetObjective("Deliver ~y~the client ~w~to ~y~the safehouse")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Client died.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCharDead(peds[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPedNearCoords(peds[1], bp.x, bp.y, bp.z, 5)) then
							misvar = {}
							agepoints = agepoints + 1
							SaveAgency()
							local finalreward = SeparateReward(8000, 400)
							money = money + finalreward[1]
							experience = experience + finalreward[2]
							SaveStats()
							DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
							EndMission()
						end
					else
						DrawMessage("~r~Mission failed", "Client died.")
						EndMission()
					end
				end
			elseif(currmission == 6) then
				if(currstage == 0) then
					for i=1,10,1 do
						if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
							for j=1,10,1 do
								AttackPlayer(peds[j])
							end
						end
					end
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(-58.50722, 55.69907, 14.74268)
							SetRoute(blips[1], true)
							SetObjective("Deliver ~y~this vehicle ~w~to ~y~the agency")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Vehicle destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 5)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								misvar = {}
								agepoints = agepoints + 1
								SaveAgency()
								local finalreward = SeparateReward(8000, 400)
								money = money + finalreward[1]
								experience = experience + finalreward[2]
								SaveStats()
								DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
								EndMission()
							end
						end
					else
						DrawMessage("~r~Mission failed", "Vehicle destroyed.")
						EndMission()
					end
				end
			-------------------------------------------------
			elseif(currmission == 11) then
				if(currstage == 0) then
					for i=1,3,1 do
						if(IsCharDead(peds[i])) then
							RemoveBlip(blips[i])
							if(i == rnd) then
								for j=1,3,1 do
									RemoveBlip(blips[j])
								end
								local px,py,pz = GetCharCoordinates(peds[i])
								objs[1] = SpawnObject(GetHashKey("bm_usbstick"), px, py, pz-1, 0.0, GetKeyForCharInRoom(peds[i]))
								blips[1] = AddBlipForObject(objs[1])
								SetObjective("Collect ~y~the flash drive")
								currstage = 1
							end
						end
					end
				elseif(currstage == 1) then
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(IsPlayerNearCoords(ox, oy, oz, 3)) then
						RemoveBlip(blips[1])
						DeleteObject(objs[1])
						blips[1] = AddBlipForCoord(-77.07187, 61.20687, 14.767)
						SetRoute(blips[1], true)
						SetObjective("Deliver ~y~this flash drive ~w~to ~y~the agency")
						currstage = 2
					end
				elseif(currstage == 2) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
						agemis[1] = agemis[1] + 1
						SaveAgency()
						DrawMessage("~y~Mission completed", "Flash drive with information has been acquired.")
						EndMission()
					end
				end
			elseif(currmission == 12) then
				if(currstage == 0) then
					for i=1,15,1 do
						if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
							for j=1,15,1 do
								AttackPlayer(peds[j])
							end
						end
					end
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(IsPlayerNearCoords(ox, oy, oz, 3)) then
						RemoveBlip(blips[1])
						DeleteObject(objs[1])
						blips[1] = AddBlipForCoord(-77.07187, 61.20687, 14.767)
						SetRoute(blips[1], true)
						SetObjective("Deliver ~y~this briefcase ~w~to ~y~the agency")
						currstage = 1
					end
				elseif(currstage == 1) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
						agemis[1] = agemis[1] + 1
						SaveAgency()
						DrawMessage("~y~Mission completed", "Briefcase with device has been acquired.")
						EndMission()
					end
				end
			elseif(currmission == 13) then
				if(currstage == 0) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 5)) then
						if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
							if(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())) ~= car) then
								RemoveBlip(blips[1])
								vehs[1] = GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))
								blips[1] = AddBlipForCoord(-415.79272, 403.26514, 12.16481)
								SetRoute(blips[1], true)
								SetObjective("Park ~y~this vehicle ~w~at ~y~the marked point")
								currstage = 1
							else
								PrintStringWithLiteralStringNow("STRING", "~r~You cannot use your personal vehicle", 1000, 1)
							end
						end
					end
				elseif(currstage == 1) then
					if(IsCarDead(vehs[1])) then
						DrawMessage("~r~Mission failed", "Vehicle destroyed.")
						EndMission()
					end
					local bp = GetBlipCoords(blips[1])
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 100)) then
						RemoveBlip(blips[1])
						local coords = {
						{-410.65292, 395.29761, 12.62759, 186.873672485352, 0},
						{-421.37384, 395.55258, 11.2911, 149.182861328125, 0},
						{-416.0166, 398.66129, 12.14711, 112.313331604004, 0},
						{-420.39572, 409.48386, 11.50912, 188.548324584961, 0},
						{-413.80249, 414.72153, 12.31195, 157.00244140625, 0},
						{-420.23764, 418.42209, 11.82346, 270.001647949219, 0},
						{-411.90073, 426.08905, 12.45255, 333.557373046875, 0},
						{-417.52426, 431.3446, 11.72869, 88.3938064575195, 0},
						{-432.22882, 430.98209, 10.22215, 90.1943969726563, 0},
						{-407.54465, 435.57037, 12.60155, 145.280136108398, 0},
						{-401.77756, 426.02118, 14.75184, 92.2685012817383, 0},
						{-402.19788, 435.21881, 14.75184, 173.743606567383, 0},
						{-402.8811, 392.41727, 13.51084, 265.26904296875, 0},
						{-433.73962, 393.79941, 10.143, 90.6865310668945, 0},
						{-442.2326, 395.06146, 9.85718, 231.241912841797, 0}
						}
						for i=1,15,1 do
							peds[i] = SpawnPed(GetHashKey("M_Y_GRUS_LO_01"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
							GiveWeaponToChar(peds[i], 14, 1000, 1)
							blips[i] = AddBlipForChar(peds[i])
						end
						SetObjective("Get rid of ~y~mobsters")
						currstage = 2
					end
				elseif(currstage == 2) then
					if(IsCarDead(vehs[1])) then
						DrawMessage("~r~Mission failed", "Vehicle destroyed.")
						EndMission()
					end
					local pedsdead = 0
					for i=1,15,1 do
						if(not IsCharDead(peds[i])) then
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,15,1 do
									AttackPlayer(peds[j])
								end
							end
						else
							RemoveBlip(blips[i])
							pedsdead = pedsdead + 1
						end
					end
					if(pedsdead == 15) then
						SetObjective("Lose ~y~wanted level")
						currstage = 3
					end
				elseif(currstage == 3) then
					if(StoreWantedLevel(GetPlayerId()) == 0) then
						blips[1] = AddBlipForCoord(-415.79272, 403.26514, 12.16481)
						SetRoute(blips[1], true)
						SetObjective("Park ~y~this vehicle ~w~at ~y~the marked point")
						currstage = 4
					end
				elseif(currstage == 4) then
					if(IsCarDead(vehs[1])) then
						DrawMessage("~r~Mission failed", "Vehicle destroyed.")
						EndMission()
					end
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 5)) then
						SetCarForwardSpeed(vehs[1], 0.0)
						FreezeCarPosition(vehs[1], true)
						TaskLeaveAnyCar(GetPlayerChar(GetPlayerId()))
						SetObjective("Leave ~y~this area")
						currstage = 5
					end
				elseif(currstage == 5) then
					if(IsCarDead(vehs[1])) then
						DrawMessage("~r~Mission failed", "Vehicle destroyed.")
						EndMission()
					end
					local bp = GetBlipCoords(blips[1])
					if(not IsPlayerNearCoords(bp.x, bp.y, bp.z, 200)) then
						agemis[1] = 1
						agepoints = agepoints - 5
						SaveAgency()
						local finalreward = SeparateReward(100000, 3000)
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						EndMission()
					end
				end
			-------------------------------------------------
			elseif(currmission == 21) then
				if(currstage == 0) then
					if(IsCarDead(vehs[1])) then
						DrawMessage("~r~Mission failed", "Limo destroyed.")
						EndMission()
					end
					if(IsCharDead(peds[1])) then
						DrawMessage("~r~Mission failed", "Limo driver is dead.")
						EndMission()
					end
					local cx,cy,cz = GetCarCoordinates(vehs[1])
					if(IsPlayerNearCoords(cx, cy, cz, 50)) then
						TaskCarMissionCoorsTarget(peds[1], vehs[1], coords[rnd][1][1], coords[rnd][1][2], coords[rnd][1][3], 4, 30.1, 3, 10, 10)
						currstage = 1
					end
				elseif(currstage == 1) then
					if(IsCarDead(vehs[1])) then
						DrawMessage("~r~Mission failed", "Limo destroyed.")
						EndMission()
					end
					if(IsCharDead(peds[1])) then
						DrawMessage("~r~Mission failed", "Limo driver is dead.")
						EndMission()
					end
					if(IsPedNearCoords(peds[1], coords[rnd][1][1], coords[rnd][1][2], coords[rnd][1][3], 20)) then
						SetObjective("Destroy ~y~the limo")
						currstage = 2
					end
				elseif(currstage == 2) then
					if(IsCarDead(vehs[1])) then
						RemoveBlip(blips[1])
						blips[1] = AddBlipForCoord(coords[rnd][2][1], coords[rnd][2][2], coords[rnd][2][3])
						SetRoute(blips[1], true)
						SetObjective("Plant ~y~a bomb")
						currstage = 3
					end
				elseif(currstage == 3) then
					DrawCheckpointWithDist(coords[rnd][2][1], coords[rnd][2][2], coords[rnd][2][3]-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(coords[rnd][2][1], coords[rnd][2][2], coords[rnd][2][3], 3)) then
						RemoveBlip(blips[1])
						objs[1] = SpawnObject(GetHashKey("ec_bomb_ne"), coords[rnd][2][1], coords[rnd][2][2], coords[rnd][2][3]-1, coords[rnd][2][4])
						SetObjective("Leave ~y~this area")
						currstage = 4
					end
				elseif(currstage == 4) then
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(not IsPlayerNearCoords(ox, oy, oz, 100)) then
						DeleteCar(vehs[1])
						for i=1,3,1 do
							local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
							local angle = GenerateRandomIntInRange(0, 360, _i)
							local radius = 100
							local rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
							vehs[i] = SpawnCar(GetHashKey("zombieb"), rx, ry, rz, rh)
							for j=1,2,1 do
								peds[2*(i-1)+j] = SpawnPed(GetHashKey("M_M_GBIK_LO_03"), rx, ry, rz, rh)
								if(j == 1) then
									WarpCharIntoCar(peds[2*(i-1)+j], vehs[i])
								else
									WarpCharIntoCarAsPassenger(peds[2*(i-1)+j], vehs[i], j-2)
								end
								GiveWeaponToChar(peds[2*(i-1)+j], 7, 1000, 1)
								blips[2*(i-1)+j] = AddBlipForChar(peds[2*(i-1)+j])
							end
						end
						SetObjective("Get rid of ~y~reinforcements")
						currstage = 5
					end
				elseif(currstage == 5) then
					local mobsdead = 0
					for i=1,6,1 do
						if(not IsCharDead(peds[i])) then
							AttackPlayer(peds[i])
						else
							RemoveBlip(blips[i])
							mobsdead = mobsdead + 1
						end
					end
					if(mobsdead == 6) then
						agemis[2] = agemis[2] + 1
						SaveAgency()
						DrawMessage("~y~Mission completed", "Mafia's hideout has been successfully destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 22) then
				if(currstage == 0) then
					for i=1,10,1 do
						if(HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId())) or HasCarBeenDamagedByChar(vehs[i], GetPlayerChar(GetPlayerId()))) then
							for j=1,10,1 do
								if(j ~= 6) then
									AttackPlayer(peds[j])
								end
							end
						end
					end
					if(not IsCharDead(peds[6])) then
						if(IsCharInCar(peds[6], vehs[2])) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[2])) then
								if(GetDriverOfCar(vehs[2]) == GetPlayerChar(GetPlayerId())) then
									RemoveBlip(blips[1])
									blips[1] = AddBlipForCoord(-58.50722, 55.69907, 14.74268)
									SetRoute(blips[1], true)
									SetObjective("Deliver ~y~the target ~w~to ~y~the agency")
									currstage = 1
								end
							end
						else
							WarpCharIntoCarAsPassenger(peds[6], vehs[2], 2)
						end
					else
						DrawMessage("~r~Mission failed", "The target is dead.")
						EndMission()
					end
				elseif(currstage == 1) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(not IsCharDead(peds[6])) then
						if(not IsCarDead(vehs[2])) then
							if(IsCharInCar(peds[6], vehs[2])) then
								if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[2])) then
									if(GetDriverOfCar(vehs[2]) == GetPlayerChar(GetPlayerId())) then
										if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 5)) then
											agemis[2] = agemis[2] + 1
											SaveAgency()
											DrawMessage("~y~Mission completed", "Lawyer has been successfully intercepted.")
											EndMission()
										end
									end
								end
							else
								WarpCharIntoCarAsPassenger(peds[6], vehs[2], 2)
							end
						else
							DrawMessage("~r~Mission failed", "Limo destroyed.")
							EndMission()
						end
					else
						DrawMessage("~r~Mission failed", "The target is dead.")
						EndMission()
					end
				end
			elseif(currmission == 23) then
				if(currstage == 0) then
					local pedsdead = 0
					for i=1,20,1 do
						if(not IsCharDead(peds[i])) then
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,20,1 do
									AttackPlayer(peds[j])
								end
							end
						else
							RemoveBlip(blips[i])
							pedsdead = pedsdead + 1
						end
					end
					if(pedsdead == 20) then
						local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
						local angle = GenerateRandomIntInRange(0, 360, _i)
						local radius = 100
						local rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
						vehs[1] = SpawnCar(GetHashKey("MAVERICK"), rx, ry, rz+100, rh)
						peds[21] = SpawnPed(GetHashKey("M_Y_GMAF_HI_02"), rx, ry, rz+100, rh)
						blips[1] = AddBlipForChar(peds[21])
						WarpCharIntoCar(peds[21], vehs[1])
						SetHeliStabiliser(vehs[1])
						SetHeliBladesFullSpeed(vehs[1])
						TaskHeliMission(peds[21], vehs[1], 0, 0, -812.58966, 1634.94116, 2.60673+100, 4, 10.1, 5, -1, Round(100.1)+1, 40)
						SetObjective("~y~The boss ~w~is trying to escape on ~y~helicopter~w~! Kill him")
						currstage = 1
					end
				elseif(currstage == 1) then
					if(not IsCharDead(peds[21])) then
						if(IsPedNearCoords(peds[21], -812.58966, 1634.94116, 2.60673+100, 50)) then
							RequestCollisionAtPosn(-813.0177, 1648.87646, 2.3767)
							SetCarCoordinates(vehs[1], -813.0177, 1648.87646, 2.3767+1)
							SetCarOnGroundProperly(vehs[1])
							WarpCharFromCarToCoord(peds[21], -816.02423, 1639.69495, 2.64771)
							RequestAnims("amb@wasted_b")
							while not HaveAnimsLoaded("amb@wasted_b") do
								Wait(0)
								RequestAnims("amb@wasted_b")
							end
							TaskPlayAnimWithFlags(peds[21], "idle_a", "amb@wasted_b", 8.0, 3000000, 0)
							SetObjective("~y~The boss ~w~has crashed. Catch him!")
							currstage = 2
						end
					else
						RemoveBlip(blips[1])
						AlterWantedLevel(GetPlayerId(), 4)
						ApplyWantedLevelChangeNow(GetPlayerId())
						SetObjective("Lose ~y~wanted level")
						currstage = 3
					end
				elseif(currstage == 2) then
					if(IsCharDead(peds[21])) then
						RemoveBlip(blips[1])
						AlterWantedLevel(GetPlayerId(), 4)
						ApplyWantedLevelChangeNow(GetPlayerId())
						SetObjective("Lose ~y~wanted level")
						currstage = 3
					end
				elseif(currstage == 3) then
					if(StoreWantedLevel(GetPlayerId()) == 0) then
						agemis[2] = 1
						agepoints = agepoints - 8
						SaveAgency()
						local finalreward = SeparateReward(150000, 5000)
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
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