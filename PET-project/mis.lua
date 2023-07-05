local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end

local mismainblip = {}
mis = {
{pos = {-184.81686, 1602.34912, 20.5696}, name = "Drug stealing", level = 20, 
desc = {
-----------------------------------------------------------------------------------------------
"Our boss is interested in getting a great amount of coke. We've got the information about",
"temporary russian mafia base. Enter this base, get rid off every mobster you will meet and",
"bring their stuff to our place. And we don't need cops here."
}, reward = {10000, 500}},
{pos = {-1718.79236, 509.74197, 27.41769}, name = "Prisoners' rescue", level = 10, 
desc = {
-----------------------------------------------------------------------------------------------
"I'm a politian and a great deal of my electorate got cuffed and about to move into the prison.",
"They are currently in a prison bus at a police station and are being highly secured. Steal the",
"bus, lose cops and deliver these people to me. And remember, I need all these people alive."
}, reward = {6500, 450}},
{pos = {1225.29797, 689.02557, 37.62317}, name = "Deal breaker", level = 10, 
desc = {
-----------------------------------------------------------------------------------------------
"Russians and triads are trying to do some deal. They have something really important for us.",
"Break this deal by killing all these bastards, find the briefcase and deliver it to our",
"drop-off. Be careful, I don't think they will let you take their stuff so easy."
}, reward = {5000, 350}},
{pos = {-1173.66394, 566.57513, 7.8087}, name = "Biker problem", level = 10, 
desc = {
-----------------------------------------------------------------------------------------------
"Some scumbag bikers think they are too cool to follow the rules. We want to pay them back by",
"destroying their shitty bikes. We give you coordinates and you blow these bikes up. They can",
"try to fight back and if it will happen - get rid of them too."
}, reward = {5000, 350}},
{pos = {1033.72034, 1788.65137, 13.52933}, name = "Cargo escort", level = 0, 
desc = {
-----------------------------------------------------------------------------------------------
"Some mobsters have stolen our boat with stuff and are on their way to deliver it to their",
"boss. Get control of this boat and move it back to our dock."
}, reward = {5000, 300}},
{pos = {1235.66138, -330.4256, 21.55029}, name = "Debts kicking", level = 20, 
desc = {
-----------------------------------------------------------------------------------------------
"We know some people who still can't pay their debts and it seems like their time is up. It's",
"time for you to interfere their life and get back our cash. We are not so violent, so we do",
"not need casualties. Use force only if it's really needed."
}, reward = {7000, 400}},
{pos = {168.11372, 367.50784, 15.17904}, name = "Chaos starter", level = 0, 
desc = {
-----------------------------------------------------------------------------------------------
"We need to do some clever move to remove a rival gang from the game for some time. I need you",
"to attract cops' attention and bring them to this gang's place. Other stuff will be done by",
"cops."
}, reward = {10000, 500}},
{pos = {-440.92795, 998.73578, 10.10546}, name = "I scream, you scream", level = 10, 
desc = {
-----------------------------------------------------------------------------------------------
"We know that some russian mobsters are really into eating ice cream. So we are going to use",
"it against them. You have to steal an ice cream van, drive into our repair shop to install",
"explosives, park this van at the correct place and wait for the show! If someone is still",
"alive after explosion - end them."
}, reward = {5000, 350}},
{pos = {-1063.71289, -259.20486, 4.62139}, name = "Trunk surprise", level = 20, 
desc = {
-----------------------------------------------------------------------------------------------
"We've managed to kill some really valuable guy of italian mafia. But now they are trying to",
"deliver his body to their boss as the evidence of his death. We think it will turn the boss",
"mad so it's better for us to steal the car with this corpse and get rid of it. Of course,",
"don't expect italians to ignore that."
}, reward = {7000, 400}},
{pos = {-182.74974, 84.36775, 14.77295}, name = "Rooftop rumble", level = 0, 
desc = {
-----------------------------------------------------------------------------------------------
"I hate when someone keeps stealing some valuable information from me. I've managed to figure",
"out that is done by some group of FIB agents. Ambush their team and bring the briefcase with",
"their files to my place. You'll be rewarded."
}, reward = {5000, 350}},
{pos = {-1207.47522, 1748.31628, 32.72989}, name = "Hacked connection", level = 10, 
desc = {
-----------------------------------------------------------------------------------------------
"Our boss managed to get a van with hacking device. But we need someone to reach the entry",
"point on this van, start a hacking process and protect this van from rivals. After",
"successful hacking, lose cops because we don't need them to find out of our hacking device."
}, reward = {10000, 600}},
{pos = {-1279.33484, 820.94696, 19.57202}, name = "Out of commission", level = 30, 
desc = {
-----------------------------------------------------------------------------------------------
"Local italian mafia boss keeps interfering our business. Now it's time for him to stop. We",
"are going to stop him by force, and we need someone who can help. He is hiding in their",
"temporary base at abandoned casino. He is highly protected and there is a chance that he",
"will be too scared to 'talk' to you and may try to escape. So keep your eyes pilled."
}, reward = {18000, 900}},
{pos = {488.13226, 1756.92566, 28.10784}, name = "Bury the hatchet", level = 0, 
desc = {
-----------------------------------------------------------------------------------------------
"The rival chinese gang decided to make peace with us. For that they decided to provide us",
"some of their goods. They decided to remove unneeded suspicions, that's why the bag will be",
"waiting for you at the cemetery. It seems like a simple assignment."
}, reward = {6000, 400}},
{pos = {1803.06396, 821.78839, 16.60901}, name = "Clocking off", level = 20, 
desc = {
-----------------------------------------------------------------------------------------------
"We are currently transporting some stuff at the pier and someone who can take a part in its",
"protection would really come in handy. Drive to this pier and meet my guys there. If something",
"goes wrong, push rivals back with my guys and make sure that the stuff is secured."
}, reward = {10000, 600}},
{pos = {-2082.15674, 43.05592, 7.0984}, name = "Bull in china shop", level = 30, 
desc = {
-----------------------------------------------------------------------------------------------
"Local korean mobs are currently trying to control our area. They based at the restaurant and",
"we want you to obliterate this place to remove their appearence from this area. They will",
"probably try to fight you back and they won't leave you alone until you either die or kill",
"them all. Come back alive and you will get high reward."
}, reward = {15000, 800}},
{pos = {-207.22748, -436.54608, 14.06336}, name = "Departure time", level = 40, 
desc = {
-----------------------------------------------------------------------------------------------
"IAA is interested in liquidizing a dangerous drug lord who speards his junk all over the city.",
"We can provide a location of a huge drug storage full of his goons. Reach this place, get",
"rid of drugs and find this bastard. In any case we will try to provide you a fresh information",
"about his location, so don't waste much time and do everything quickly."
}, reward = {20000, 1200}}
}
CreateThread(function()
	while true do
		Wait(0)
		for i=1,#mis,1 do
			if(not DoesBlipExist(mismainblip[i])) then
				mismainblip[i] = AddBlipForCoord(mis[i].pos[1], mis[i].pos[2], mis[i].pos[3])
				ChangeBlipSprite(mismainblip[i], 33)
				ChangeBlipScale(mismainblip[i], 0.7)
				ChangeBlipNameFromAscii(mismainblip[i], "" .. mis[i].name .. " (" .. mis[i].level .. ")")
				SetBlipAsShortRange(mismainblip[i], true)
			end
			if(level >= mis[i].level) then
				ChangeBlipColour(mismainblip[i], 2)
			end
			if(missionstarted == 0) then
				if(mis[i].level > 0) then
					DrawTextAtCoord(mis[i].pos[1], mis[i].pos[2], mis[i].pos[3], "" .. GetStringWithoutSpaces(mis[i].name) .. " Level_" .. mis[i].level, 20)
				else
					DrawTextAtCoord(mis[i].pos[1], mis[i].pos[2], mis[i].pos[3], "" .. GetStringWithoutSpaces(mis[i].name), 20)
				end
				DrawCheckpointWithDist(mis[i].pos[1], mis[i].pos[2], mis[i].pos[3]-1, 1.1, 255, 255, 0, 100)
				if(IsPlayerNearCoords(mis[i].pos[1], mis[i].pos[2], mis[i].pos[3], 1)) then
					DrawDescription(mis[i].name, mis[i].desc)
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~start mission", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						if(level >= mis[i].level) then
							if(coop[ConvertIntToPlayerindex(GetPlayerId())] == -1) then
								if(missionstarted == 0) then
									if(mis[i].name == "Drug stealing") then
										local coords = {
										{1193.49915, 1443.65405, 16.72425, 313.299285888672, -955235926},
										{1192.89648, 1458.70227, 16.72437, 251.534469604492, -955235926},
										{1212.80835, 1460.68774, 16.7244, 168.707595825195, -955235926},
										{1227.57861, 1451.87109, 16.72425, 90.1185760498047, -955235926},
										{1222.37012, 1447.43811, 21.6884, 77.9246826171875, -955235926},
										{1204.00659, 1444.63684, 21.68838, 1.38095355033875, -955235926},
										{1198.13416, 1438.51624, 25.98554, 351.679626464844, -955235926},
										{1221.33838, 1438.88257, 25.98553, 62.069580078125, -955235926},
										{1221.89392, 1460.63855, 25.98555, 97.2689208984375, -955235926},
										{1211.63647, 1469.25037, 30.28512, 193.749618530273, -955235926},
										{1191.4303, 1464.64795, 30.21733, 267.903839111328, -955235926},
										{1191.41724, 1450.71216, 30.25549, 268.916717529297, -955235926},
										{1197.93262, 1438.04663, 30.31162, 38.0887680053711, -1460632209},
										{1210.5957, 1440.85815, 30.28511, 177.659790039063, -1460632209},
										{1204.57922, 1445.46765, 30.28511, 4.15578413009644, -1460632209}
										}
										for i=1,15,1 do
											peds[i] = SpawnPed(GetHashKey("M_Y_CHINATOWN_03"), coords[i][1], coords[i][2], coords[i][3], coords[i][4], coords[i][5])
											GiveWeaponToChar(peds[i], 9, 1000, 1)
											blips[i] = AddBlipForChar(peds[i])
										end
										SetObjective("Reach ~y~the marked point ~w~and ~y~kill all mobsters")
										TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
										currmission = 1
										missionstarted = 1
									elseif(mis[i].name == "Prisoners' rescue") then
										local coords = {
										{-890.93634, 1335.58264, 22.09773, 178.367477416992},
										{-874.3678, 1337.45142, 22.09765, 176.659744262695},
										{-866.69971, 1325.74524, 22.12646, 87.53564453125},
										{-852.14301, 1321.37585, 21.97742, 176.372940063477},
										{-860.68677, 1305.39404, 21.97799, 4.44145393371582},
										{-850.86597, 1296.86035, 21.97798, 206.237167358398},
										{-872.74994, 1285.83997, 22.09778, 4.64271259307861},
										{-898.92187, 1319.11975, 24.2908, 359.4970703125},
										{-933.73181, 1323.41284, 24.74607, 85.8603057861328},
										{-933.41821, 1335.49646, 24.4993, 177.208953857422}
										}
										for i=1,10,1 do
											peds[i] = SpawnPed(GetHashKey("M_Y_COP"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
											GiveWeaponToChar(peds[i], 15, 1000, 1)
										end
										vehs[1] = SpawnCar(GetHashKey("PSTOCKADE"), -878.06616, 1306.38818, 21.97767, 355.874938964844)
										blips[1] = AddBlipForCar(vehs[1])
										for i=11,13,1 do
											peds[i] = SpawnPed(GetHashKey("M_Y_PRISON"), -878.06616, 1306.38818, 21.97767, 355.874938964844)
											WarpCharIntoCarAsPassenger(peds[i], vehs[1], i-11)
										end
										SetObjective("Steal ~y~the prison transport ~w~with ~y~prisoners")
										TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
										currmission = 2
										missionstarted = 1
									elseif(mis[i].name == "Deal breaker") then
										local coords = {
										{497.29639, 1090.94812, 2.7195, 271.780700683594},
										{488.13046, 1083.2948, 2.7195, 267.970642089844},
										{484.44998, 1093.73535, 2.7195, 0.786366045475006},
										{478.94531, 1095.82092, 2.7195, 96.2887573242188},
										{484.47821, 1086.25269, 2.7195, 87.9205703735352},
										{480.7774, 1086.41833, 2.7195, 267.81298828125},
										{475.60327, 1079.34399, 2.7195, 4.55381536483765},
										{485.96295, 1077.43713, 2.7195, 0.0974224582314491},
										{468.53625, 1091.27527, 2.7195, 253.975112915039},
										{470.9231, 1085.62939, 2.7195, 257.979919433594}
										}
										for i=1,10,1 do
											peds[i] = SpawnPed(GetHashKey("M_Y_CHINATOWN_03"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
											blips[i] = AddBlipForChar(peds[i])
										end
										for i=1,5,1 do
											GiveWeaponToChar(peds[i], 12, 1000, 1)
										end
										for i=6,10,1 do
											GiveWeaponToChar(peds[i], 13, 1000, 1)
										end
										SetObjective("Break ~y~the deal ~w~by killing ~y~all mobsters")
										TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
										currmission = 3
										missionstarted = 1
									elseif(mis[i].name == "Biker problem") then
										local coords = {
										{-1218.34509, -340.53574, 2.83687, 359.132202148438},
										{-1222.51855, -344.65616, 2.83687, 324.269012451172},
										{-1223.14844, -334.07025, 2.83687, 358.690093994141}
										}
										for i=1,3,1 do
											vehs[i] = SpawnCar(GetHashKey("zombieb"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
											blips[i] = AddBlipForCar(vehs[i])
										end
										SetObjective("Destroy all ~y~marked bikes")
										TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
										currmission = 4
										missionstarted = 1
									elseif(mis[i].name == "Cargo escort") then
										vehs[1] = SpawnCar(GetHashKey("squalo"), -726.88043, 1052.13025, -0.76482, 172.191741943359)
										blips[1] = AddBlipForCar(vehs[1])
										for i=1,3,1 do
											peds[i] = SpawnPed(GetHashKey("M_M_EE_HEAVY_01"), -726.88043, 1052.13025, -0.76482, 172.191741943359)
											GiveWeaponToChar(peds[i], 13, 1000, 1)
											if(i == 1) then
												WarpCharIntoCar(peds[i], vehs[1])
											else
												WarpCharIntoCarAsPassenger(peds[i], vehs[1], i-2)
											end
										end
										TaskCarMission(peds[1], vehs[1], vehs[1], 1, 10.1, 0, 0, 10)
										SetObjective("Steal ~y~the boat")
										TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
										currmission = 5
										missionstarted = 1
									elseif(mis[i].name == "Debts kicking") then
										for i=1,3,1 do
											local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
											local angle = GenerateRandomIntInRange(0, 360, _i)
											local radius = GenerateRandomIntInRange(100, 3000, _i)
											rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
											peds[i] = SpawnPed(GetHashKey("M_Y_BARMAN_01"), rx, ry, rz, rh)
											TaskSmartFleeChar(peds[i], GetPlayerChar(GetPlayerId()), 99.9, 20000)
											if(i == 3) then
												GiveWeaponToChar(peds[i], 7, 1000, 1)
											end
											blips[i] = AddBlipForChar(peds[i])
										end
										cashcollected = {0,0,0}
										SetObjective("Beat out debts from ~y~marked people~w~. Try not to kill them.")
										TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
										currmission = 6
										missionstarted = 1
									elseif(mis[i].name == "Chaos starter") then
										SetObjective("Reach ~y~4 stars wanted level")
										TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
										currmission = 7
										missionstarted = 1
									elseif(mis[i].name == "I scream, you scream") then
										local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
										local angle = GenerateRandomIntInRange(0, 360, _i)
										local radius = GenerateRandomIntInRange(100, 3000, _i)
										rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
										vehs[1] = SpawnCar(GetHashKey("MRTASTY"), rx, ry, rz, rh)
										peds[1] = SpawnPed(GetHashKey("M_M_TAXIDRIVER"), rx, ry, rz, rh)
										WarpCharIntoCar(peds[1], vehs[1])
										TaskCarMission(peds[1], vehs[1], vehs[1], 1, 10.1, 0, 0, 10)
										blips[1] = AddBlipForCar(vehs[1])
										SetObjective("Steal ~y~an ice cream van")
										TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
										currmission = 8
										missionstarted = 1
									elseif(mis[i].name == "Trunk surprise") then
										local coords = {
										{-1010.24841, 1524.1731, 23.21619, 51.5824737548828},
										{-1301.05542, 947.82617, 19.57198, 357.731994628906},
										{-1843.04687, 151.13824, 15.01167, 97.6274642944336},
										{-1199.63306, -185.08418, 3.92877, 180.918838500977},
										{-73.98379, -821.60193, 5.33858, 336.869934082031},
										{1009.14691, -408.22281, 15.8693, 91.3853073120117},
										{1407.42822, 350.95172, 19.00147, 182.876480102539},
										{1864.81726, 686.84686, 27.20218, 356.214660644531},
										{1112.8457, 1854.1936, 11.49665, 58.9172706604004},
										{-210.8152, 1398.16895, 20.35069, 355.495391845703}
										}
										local rnd = GenerateRandomIntInRange(1, #coords+1, _i)
										vehs[1] = SpawnCar(GetHashKey("ORACLE"), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
										blips[1] = AddBlipForCar(vehs[1])
										SetObjective("Steal ~y~the car ~w~with ~y~a corpse")
										TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
										currmission = 9
										missionstarted = 1
									elseif(mis[i].name == "Rooftop rumble") then
										local coords = {
										{96.50155, 1143.00171, 2.91673, 100.596954345703},
										{88.51476, 1134.61377, 2.91673, 109.198593139648},
										{80.52225, 1144.85657, 2.91673, 49.1186332702637},
										{76.41266, 1127.99622, 2.91673, 103.183822631836},
										{87.9355, 1126.1217, 2.91673, 218.45458984375},
										{101.75387, 1129.10376, 2.91673, 48.5619735717773},
										{112.43619, 1146.69861, 2.91673, 107.079460144043},
										{105.9361, 1157.81067, 2.91673, 129.893600463867},
										{96.62839, 1163.07983, 2.91673, 134.383438110352},
										{80.42553, 1161.69348, 2.91673, 170.574325561523}
										}
										for i=1,10,1 do
											peds[i] = SpawnPed(GetHashKey("m_y_gmaf_hi_02"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
											GiveWeaponToChar(peds[i], 15, 1000, 1)
											blips[i] = AddBlipForChar(peds[i])
										end
										SetObjective("Kill all ~y~agents ~w~in ~y~the underground parking lot")
										TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
										currmission = 10
										missionstarted = 1
									elseif(mis[i].name == "Hacked connection") then
										vehs[1] = SpawnCar(GetHashKey("moonbeam"), -1726.11938, 687.9021, 31.17275, 260.251892089844)
										blips[1] = AddBlipForCar(vehs[1])
										SetObjective("Reach ~y~the van ~w~with ~y~hacking device")
										TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
										currmission = 11
										missionstarted = 1
									elseif(mis[i].name == "Out of commission") then
										local coords = {
										{-1236.15906, 1861.07288, 6.56989, 183.846252441406, -335502243},
										{-1243.40662, 1865.34717, 6.5784, 245.75813293457, -335502243},
										{-1246.25854, 1871.70923, 10.7388, 232.454437255859, -335502243},
										{-1244.28308, 1883.46851, 6.70417, 244.639892578125, -335502243},
										{-1238.43787, 1894.85046, 6.5572, 184.312408447266, -335502243},
										{-1252.89136, 1895.28699, 6.5465, 352.349517822266, -1036502482},
										{-1260.68616, 1890.46558, 9.83199, 269.013061523438,-1036502482},
										{-1260.84814, 1885.50476, 12.00682, 351.867431640625, -1036502482},
										{-1253.98999, 1885.63977, 15.25812, 94.5124664306641, -1036502482},
										{-1260.6394, 1897.8385, 11.0017, 180.086181640625, -1036502482},
										{-1258.7522, 1891.7124, 15.67255, 274.211486816406, 0},
										{-1253.80518, 1906.90735, 15.64922, 0.737995147705078, 0},
										{-1256.77319, 1877.89673, 15.66632, 187.130920410156, 0},
										{-1267.62915, 1897.43127, 21.6264, 268.695526123047, 0},
										{-1247.46948, 1897.66663, 18.4352, 92.6315155029297, 0}
										}
										for i=1,15,1 do
											peds[i] = SpawnPed(GetHashKey("M_M_PITALIAN_02"), coords[i][1], coords[i][2], coords[i][3], coords[i][4], coords[i][5])
											blips[i] = AddBlipForChar(peds[i])
										end
										for i=1,5,1 do
											GiveWeaponToChar(peds[i], 14, 1000, 1)
										end
										for i=6,10,1 do
											GiveWeaponToChar(peds[i], 10, 1000, 1)
										end
										for i=11,15,1 do
											GiveWeaponToChar(peds[i], 12, 1000, 1)
										end
										SetObjective("Eliminate all ~y~mobsters ~w~and find ~y~the boss")
										TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
										currmission = 12
										missionstarted = 1
									elseif(mis[i].name == "Bury the hatchet") then
										objs[1] = SpawnObject(GetHashKey("gb_bagdrug01"), 477.29855, 335.27954, 8.61718-1, 269.955474853516)
										blips[1] = AddBlipForObject(objs[1])
										SetObjective("Reach ~y~the marked point ~w~and collect ~y~the bag")
										TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
										currmission = 13
										missionstarted = 1
									elseif(mis[i].name == "Clocking off") then
										blips[1] = AddBlipForCoord(279.56778, 1756.39075, 11.01372)
										SetRoute(blips[1], true)
										SetObjective("Reach ~y~the pier")
										TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
										currmission = 14
										missionstarted = 1
									elseif(mis[i].name == "Bull in china shop") then
										local coords = {
										{-1239.69812, 1080.55896, 19.78534, 170.551971435547, 1331891362},
										{-1232.64111, 1075.12927, 19.78524, 92.1871490478516, 543253775},
										{-1235.8407, 1086.23657, 19.78527, 178.911972045898, -561230668},
										{-1225.30371, 1088.04944, 22.2864, 131.649703979492, -561230668},
										{-1221.70667, 1078.28198, 24.78531, 91.6097259521484, 7861588},
										{-1235.14404, 1079.96484, 24.78531, 307.119659423828, 7861588},
										{-1231.51367, 1092.92944, 24.78533, 202.576858520508, 7861588},
										{-1222.57373, 1093.56543, 24.78534, 156.823837280273, 7861588},
										{-1214.50061, 1078.05493, 24.78534, 191.272064208984, -686136475},
										{-1215.3512, 1092.953, 24.78531, 29.4401664733887, -686136475},
										{-1210.80591, 1089.80151, 25.56508, 355.278259277344, 0},
										{-1214.31238, 1077.66736, 28.94887, 338.295501708984, 0},
										{-1214.09705, 1089.11499, 28.94889, 340.101379394531, 0},
										{-1235.10095, 1081.03931, 19.78525, 292.418762207031, -561230668},
										{-1239.99133, 1087.67639, 19.78525, 168.420959472656, 1331891362}
										}
										for i=1,15,1 do
											peds[i] = SpawnPed(GetHashKey("M_Y_GKOR_LO_01"), coords[i][1], coords[i][2], coords[i][3], coords[i][4], coords[i][5])
											GiveWeaponToChar(peds[i], 12, 1000, 1)
										end
										blips[1] = AddBlipForCoord(-1213.84937, 1086.70007, 24.78533)
										SetRoute(blips[1], true)
										SetObjective("Reach ~y~the marked point ~w~and plant ~y~a bomb")
										TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
										currmission = 15
										missionstarted = 1
									elseif(mis[i].name == "Departure time") then
										local coords = {
										{1034.64648, -674.93744, 14.2246, 5.25834798812866, 0},
										{1030.68921, -658.77942, 14.22459, 350.969909667969, 0},
										{1029.05688, -684.62665, 14.22459, 175.581909179688, 0},
										{1044.15503, -672.99847, 13.99897, 118.600639343262, 0},
										{1024.41736, -665.95734, 14.2246, 59.8984527587891, 0},
										{1054.10352, -637.88428, 13.65245, 151.731399536133, 0},
										{1056.35632, -645.55652, 13.57422, 141.194946289063, 0},
										{1065.95654, -640.67236, 13.49224, 292.561492919922, 0},
										{1073.20825, -637.14923, 13.49224, 306.141540527344, 0},
										{1050.91821, -627.35944, 13.76313, 22.8624744415283, 0},
										{1057.72852, -588.04504, 13.61647, 158.365737915039, 0},
										{1050.73364, -587.40179, 13.82962, 158.356185913086, 0},
										{1056.45667, -596.14233, 13.57336, 214.994415283203, 0},
										{1052.16064, -603.72113, 13.71947, 339.401641845703, 0},
										{1060.34521, -601.89014, 13.49224, 267.500946044922, 0},
										{999.76642, -682.271, 14.22419, 131.155227661133, 0},
										{992.65594, -675.65137, 14.22407, 7.38718891143799, 0},
										{996.39478, -673.7298, 14.22398, 297.301971435547, 0},
										{988.04846, -669.88593, 14.22399, 71.7469863891602, 0},
										{1006.16827, -678.11823, 14.22399, 299.230255126953, 0}
										}
										for i=1,20,1 do
											peds[i] = SpawnPed(GetHashKey("M_Y_GRUS_HI_02"), coords[i][1], coords[i][2], coords[i][3], coords[i][4], coords[i][5])
											GiveWeaponToChar(peds[i], 14, 1000, 1)
										end
										local coords = {
										{991.05029, -683.34991, 14.22412, 269.115142822266, 0},
										{1063.08948, -634.52246, 13.49224, 163.824188232422, 0},
										{1051.90247, -582.67584, 13.84296, 179.570541381836, 0}
										}
										for i=1,3,1 do
											objs[i] = SpawnObject(GetHashKey("cj_hippo_bin"), coords[i][1], coords[i][2], coords[i][3]-1, coords[i][4]+180)
											FreezeObjectPosition(objs[i], true)
											blips[i] = AddBlipForObject(objs[i])
										end
										SetObjective("Reach ~y~the marked point ~w~and destroy all ~y~drug bins")
										TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
										currmission = 16
										missionstarted = 1
									end
								else
									TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Mission in progress!')
								end
							else
								TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Only a leader of your co-op team can start missions!')
							end
						else
							TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'You must reach level ' .. mis[i].level .. '!')
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
					local mobskilled = 0
					for i=1,15,1 do
						if(not IsCharDead(peds[i])) then
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,15,1 do
									AttackPlayer(peds[j])
								end
							end
						else
							RemoveBlip(blips[i])
							mobskilled = mobskilled + 1
						end
					end
					if(mobskilled == 15) then
						objs[1] = SpawnObject(GetHashKey("gb_bagdrug01"), 1204.59241, 1438.85278, 30.28512-1, 86.6335678100586, -1460632209)
						blips[1] = AddBlipForObject(objs[1])
						SetObjective("Steal ~y~the bag of drugs")
						currstage = 1
					end
				elseif(currstage == 1) then
					if(IsCharTouchingObject(GetPlayerChar(GetPlayerId()), objs[1]) or IsPlayerNearCoords(1204.59241, 1438.85278, 30.28512, 1)) then
						RemoveBlip(blips[1])
						DeleteObject(objs[1])
						local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
						objs[1] = SpawnObject(GetHashKey("cj_mk_drug_bag"), px, py, pz, 0.0)
						AttachObjectToPed(objs[1],GetPlayerChar(GetPlayerId()),0x4B2,0.3,0,0,0,-math.pi/2,math.pi,0)
						SetObjective("Lose ~y~wanted level")
						currstage = 2
					end
				elseif(currstage == 2) then
					if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
						blips[1] = AddBlipForCoord(1442.65955, 193.67424, 26.75827)
						SetRoute(blips[1], true)
						SetObjective("Deliver and exchange ~y~the bag ~w~at ~y~the marked point")
						currstage = 3
					end
				elseif(currstage == 3) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						local finalreward = SeparateReward(mis[currmission].reward[1], mis[currmission].reward[2])
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						missionsCompleted = missionsCompleted + 1
						SaveDailyStats()
						EndMission()
					end
				end
			elseif(currmission == 2) then
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
							if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i) == GetPlayerChar(GetPlayerId())) then
								RemoveBlip(blips[1])
								AlterWantedLevel(GetPlayerId(), 4)
								ApplyWantedLevelChangeNow(GetPlayerId())
								SetObjective("Lose ~y~wanted level")
								currstage = 1
							end
						end
					else
						DrawMessage("~r~Mission failed", "Transport destroyed.")
						EndMission()
					end
					for i=11,13,1 do
						if(IsCharDead(peds[i])) then
							DrawMessage("~r~Mission failed", "One of prisoners got killed.")
							EndMission()
							break
						end
					end
				elseif(currstage == 1) then
					if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
						blips[1] = AddBlipForCoord(-345.461, -669.80444, 4.79059)
						SetRoute(blips[1], true)
						SetObjective("Bring ~y~this prison transport ~w~to ~y~the drop-off")
						currstage = 2
					end
				elseif(currstage == 2) then
					for i=11,13,1 do
						if(IsCharDead(peds[i])) then
							DrawMessage("~r~Mission failed", "One of prisoners got killed.")
							EndMission()
							break
						end
					end
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i) == GetPlayerChar(GetPlayerId())) then
								if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
									local finalreward = SeparateReward(mis[currmission].reward[1], mis[currmission].reward[2])
									money = money + finalreward[1]
									experience = experience + finalreward[2]
									SaveStats()
									DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
									missionsCompleted = missionsCompleted + 1
									SaveDailyStats()
									EndMission()
								end
							end
						end
					else
						DrawMessage("~r~Mission failed", "Transport destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 3) then
				if(currstage == 0) then
					local mobskilled = 0
					for i=1,10,1 do
						if(not IsCharDead(peds[i])) then
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,10,1 do
									AttackPlayer(peds[j])
								end
							end
						else
							RemoveBlip(blips[i])
							mobskilled = mobskilled + 1
						end
					end
					if(mobskilled == 10) then
						vehs[1] = SpawnCar(GetHashKey("PMP600"), 538.73694, 1096.26355, 2.72778, 278.689147949219)
						for i=11,14,1 do
							peds[i] = SpawnPed(GetHashKey("M_Y_CHINATOWN_03"), 538.73694, 1096.26355, 2.72778, 278.689147949219)
							GiveWeaponToChar(peds[i], 12, 1000, 1)
							if(i == 11) then
								WarpCharIntoCar(peds[i], vehs[1])
							else
								WarpCharIntoCarAsPassenger(peds[i], vehs[1], i-12)
							end
						end
						blips[1] = AddBlipForChar(peds[11])
						TaskCarMission(peds[11], vehs[1], vehs[1], 1, 20.1, 0, 0, 10)
						SetObjective("Kill escaping ~y~mobsters")
						currstage = 1
					end
				elseif(currstage == 1) then
					for i=11,14,1 do
						if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId())) or HasCarBeenDamagedByChar(vehs[1], GetPlayerChar(GetPlayerId()))) then
							AttackPlayer(peds[i])
						end
					end
					if(IsCharDead(peds[11])) then
						RemoveBlip(blips[1])
						local px,py,pz = GetCharCoordinates(peds[11])
						objs[1] = SpawnObject(GetHashKey("cj_case_2"), px, py, pz, 0.0)
						blips[1] = AddBlipForObject(objs[1])
						SetObjective("Collect ~y~the briefcase")
						currstage = 2
					end
				elseif(currstage == 2) then
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(IsCharTouchingObject(GetPlayerChar(GetPlayerId()), objs[1]) or IsPlayerNearCoords(ox, oy, oz, 1)) then
						DeleteObject(objs[1])
						RemoveBlip(blips[1])
						blips[1] = AddBlipForCoord(1464.17188, 1750.20203, 16.86455)
						SetRoute(blips[1], true)
						SetObjective("Deliver ~y~this briefcase ~w~to ~y~the drop-off")
						currstage = 3
					end
				elseif(currstage == 3) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						local finalreward = SeparateReward(mis[currmission].reward[1], mis[currmission].reward[2])
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						missionsCompleted = missionsCompleted + 1
						SaveDailyStats()
						EndMission()
					end
				end
			elseif(currmission == 4) then
				if(currstage == 0) then
					local bikesdead = 0
					for i=1,3,1 do
						if(IsCarDead(vehs[i])) then
							RemoveBlip(blips[i])
							bikesdead = bikesdead + 1
						end
					end
					if(bikesdead == 3) then
						vehs[4] = SpawnCar(GetHashKey("zombieb"), -1212.59814, -235.75542, 3.04088, 177.784759521484)
						vehs[5] = SpawnCar(GetHashKey("zombieb"), -1107.65637, -303.95181, 3.05656, 91.4705505371094)
						vehs[6] = SpawnCar(GetHashKey("zombieb"), -1363.83862, -365.2088, 2.92268, 267.372528076172)
						peds[1] = SpawnPed(GetHashKey("M_Y_GBIK_LO_01"), -1212.59814, -235.75542, 3.04088, 177.784759521484)
						peds[2] = SpawnPed(GetHashKey("M_Y_GBIK_LO_01"), -1212.59814, -235.75542, 3.04088, 177.784759521484)
						peds[3] = SpawnPed(GetHashKey("M_Y_GBIK_LO_01"), -1107.65637, -303.95181, 3.05656, 91.4705505371094)
						peds[4] = SpawnPed(GetHashKey("M_Y_GBIK_LO_01"), -1107.65637, -303.95181, 3.05656, 91.4705505371094)
						peds[5] = SpawnPed(GetHashKey("M_Y_GBIK_LO_01"), -1363.83862, -365.2088, 2.92268, 267.372528076172)
						peds[6] = SpawnPed(GetHashKey("M_Y_GBIK_LO_01"), -1363.83862, -365.2088, 2.92268, 267.372528076172)
						WarpCharIntoCar(peds[1], vehs[4])
						WarpCharIntoCarAsPassenger(peds[2], vehs[4], 0)
						WarpCharIntoCar(peds[3], vehs[5])
						WarpCharIntoCarAsPassenger(peds[4], vehs[5], 0)
						WarpCharIntoCar(peds[5], vehs[6])
						WarpCharIntoCarAsPassenger(peds[6], vehs[6], 0)
						for i=1,6,1 do
							GiveWeaponToChar(peds[i], 12, 1000, 1)
							blips[i] = AddBlipForChar(peds[i])
						end
						SetObjective("Survive the attack of ~y~bikers")
						currstage = 1
					end
				elseif(currstage == 1) then
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
						SetObjective("Lose ~y~wanted level")
						currstage = 2
					end
				elseif(currstage == 2) then
					if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
						local finalreward = SeparateReward(mis[currmission].reward[1], mis[currmission].reward[2])
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						missionsCompleted = missionsCompleted + 1
						SaveDailyStats()
						EndMission()
					end
				end
			elseif(currmission == 5) then
				if(currstage == 0) then
					for i=1,3,1 do
						if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId())) or HasCarBeenDamagedByChar(vehs[1], GetPlayerChar(GetPlayerId()))) then
							AttackPlayer(peds[i])
						end
					end
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							AlterWantedLevel(GetPlayerId(), 3)
							ApplyWantedLevelChangeNow(GetPlayerId())
							SetObjective("Lose ~y~wanted level")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Boat destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
						blips[1] = AddBlipForCoord(1232.875, 1329.9375, -0.57585)
						SetRoute(blips[1], true)
						SetObjective("Deliver ~y~this boat ~w~to ~y~the drop-off")
						currstage = 2
					end
				elseif(currstage == 2) then
					if(IsCarDead(vehs[1])) then
						DrawMessage("~r~Mission failed", "Boat destroyed.")
						EndMission()
					end
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithDist(bp.x, bp.y, bp.z, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
						local finalreward = SeparateReward(mis[currmission].reward[1], mis[currmission].reward[2])
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						missionsCompleted = missionsCompleted + 1
						SaveDailyStats()
						EndMission()
					end
				end
			elseif(currmission == 6) then
				if(currstage == 0) then
					for i=1,3,1 do
						if(not IsCharDead(peds[i])) then
							if(HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								if(i == 1) then
									if(cashcollected[i] == 0) then
										if(not DoesObjectExist(objs[i])) then
											local px,py,pz = GetCharCoordinates(peds[i], _f, _f, _f)
											objs[i] = SpawnObject(GetHashKey("cj_cash_pile_1"), px, py, pz+1, 0.0)
											SetObjectAsStealable(objs[i], true)
											TaskSmartFleeChar(peds[i], GetPlayerChar(GetPlayerId()), 99.9, 20000)
										end
									end
								elseif(i == 2) then
									AttackPlayer(peds[i])
								elseif(i == 3) then
									AttackPlayer(peds[i])
								end
							end
						else
							if(i == 1) then
								DrawMessage("~r~Mission failed", "Wrong person is dead.")
								EndMission()
								break
							else
								if(cashcollected[i] == 0) then
									if(not DoesObjectExist(objs[i])) then
										local px,py,pz = GetCharCoordinates(peds[i], _f, _f, _f)
										objs[i] = SpawnObject(GetHashKey("cj_cash_pile_1"), px, py, pz, 0.0)
										SetObjectAsStealable(objs[i], true)
										TaskSmartFleeChar(peds[i], GetPlayerChar(GetPlayerId()), 99.9, 20000)
									end
								end
							end
						end
						if(DoesObjectExist(objs[i])) then
							if(not DoesBlipExist(blips[i])) then
								blips[i] = AddBlipForObject(objs[i], _i)
							end
							--if(GetObjectPedIsHolding(GetPlayerChar(GetPlayerId())) == objs[i]) then
							local ox,oy,oz = GetObjectCoordinates(objs[i], _f, _f, _f)
							if(IsCharTouchingObject(GetPlayerChar(GetPlayerId()), objs[i]) or IsPlayerNearCoords(ox, oy, oz, 1)) then
								PrintStringWithLiteralStringNow("STRING", "~g~Cash collected", 5000, 1)
								RemoveBlip(blips[i])
								DeleteObject(objs[i])
								cashcollected[i] = 1
							end
						end
					end
					if(cashcollected[1]==1 and cashcollected[2]==1 and cashcollected[3]==1) then
						cashcollected = {0,0,0}
						for i=1,3,1 do
							RemoveBlip(blips[i])
						end
						blips[1] = AddBlipForCoord(1291.22498, -354.44293, 18.71315)
						SetRoute(blips[1], true)
						SetObjective("Deliver ~y~the cash ~w~to ~y~the drop-off")
						currstage = 1
					end
				elseif(currstage == 1) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						local finalreward = SeparateReward(mis[currmission].reward[1], mis[currmission].reward[2])
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						missionsCompleted = missionsCompleted + 1
						SaveDailyStats()
						EndMission()
					end
				end
			elseif(currmission == 7) then
				if(currstage == 0) then
					if(StoreWantedLevel(GetPlayerId(), _i) >= 4) then
						blips[1] = AddBlipForCoord(-1229.16394, 15.16302, 4.21166)
						SetRoute(blips[1], true)
						SetObjective("Reach ~y~the marked point~w~. Don't lose ~y~cops~w~!")
						currstage = 1
					end
				elseif(currstage == 1) then
					if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
						DrawMessage("~r~Mission failed", "You have lost the cops.")
						EndMission()
					end
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						AlterWantedLevel(GetPlayerId(), 0)
						ApplyWantedLevelChangeNow(GetPlayerId())
						local finalreward = SeparateReward(mis[currmission].reward[1], mis[currmission].reward[2])
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						missionsCompleted = missionsCompleted + 1
						SaveDailyStats()
						EndMission()
					end
				end
			elseif(currmission == 8) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							local coords = {
							{-307.8573, 1539.99805, 20.30938, 359.974426269531},
							{-1148.06714, 1188.22766, 17.50671, 177.032287597656},
							{-1300.18738, 283.09348, 10.80944, 178.410720825195},
							{1058.24109, -296.93875, 21.35996, 356.611114501953},
							{-513.74414, 367.13248, 6.48891, 357.628387451172}
							}
							local var = GetClosestCoordWithIndex(coords)
							blips[1] = AddBlipForCoord(coords[var][1], coords[var][2], coords[var][3])
							SetRoute(blips[1], true)
							SetObjective("Install ~y~explosives ~w~into ~y~this van")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Ice cream van destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(670.31256, 770.31305, 2.7651)
							SetRoute(blips[1], true)
							SetObjective("Park ~y~this van ~w~at ~y~the marked point")
							currstage = 2
						end
					else
						DrawMessage("~r~Mission failed", "Ice cream van destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
					if(IsCarDead(vehs[1])) then
						DrawMessage("~r~Mission failed", "Ice cream van destroyed.")
						EndMission()
					end
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
						RemoveBlip(blips[1])
						local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
						local angle = GenerateRandomIntInRange(0, 360, _i)
						local radius = 50
						rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
						local cx,cy,cz = GetCarCoordinates(vehs[1])
						for i=1,5,1 do
							peds[i] = SpawnPed(GetHashKey("M_M_PITALIAN_01"), rx, ry, rz, rh)
							GiveWeaponToChar(peds[i], 7, 1000, 1)
							TaskGoToCoordAnyMeans(peds[i], cx, cy, cz, 3, -1)
							blips[i] = AddBlipForChar(peds[i])
						end
						TaskLeaveAnyCar(GetPlayerChar(GetPlayerId()))
						SetObjective("Leave ~y~the ice cream van ~w~and wait for ~y~mobsters")
						while (not IsPedNearCoords(peds[1], cx, cy, cz, 5)) or 
						(not IsPedNearCoords(peds[2], cx, cy, cz, 5)) or 
						(not IsPedNearCoords(peds[3], cx, cy, cz, 5)) or 
						(not IsPedNearCoords(peds[4], cx, cy, cz, 5)) or 
						(not IsPedNearCoords(peds[5], cx, cy, cz, 5)) do
							Wait(0)
							local mobskilled = 0
							for i=1,5,1 do
								if(IsCharDead(peds[i])) then
									mobskilled = mobskilled + 1
								end
							end
							if(mobskilled == 5) then
								local finalreward = SeparateReward(mis[currmission].reward[1], mis[currmission].reward[2])
								money = money + finalreward[1]
								experience = experience + finalreward[2]
								SaveStats()
								DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
								missionsCompleted = missionsCompleted + 1
								SaveDailyStats()
								EndMission()
								goto finish
							end
							if(IsPlayerDead(GetPlayerId())) then
								goto finish
							end
						end
						ExplodeCar(vehs[1], 1, true)
						SetObjective("Kill ~y~survived mobsters")
						currstage = 3
						::finish::
					end
				elseif(currstage == 3) then
					local mobskilled = 0
					for i=1,5,1 do
						if(not IsCharDead(peds[i])) then
							AttackPlayer(peds[i])
						else
							RemoveBlip(blips[i])
							mobskilled = mobskilled + 1
						end
					end
					if(mobskilled == 5) then
						local finalreward = SeparateReward(mis[currmission].reward[1], mis[currmission].reward[2])
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						missionsCompleted = missionsCompleted + 1
						SaveDailyStats()
						EndMission()
					end
				end
			elseif(currmission == 9) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))) == GetPlayerChar(GetPlayerId())) then
								RemoveBlip(blips[1])
								for i=1,3,1 do
									local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
									local angle = GenerateRandomIntInRange(0, 360, _i)
									local radius = 100
									rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
									vehs[i+1] = SpawnCar(GetHashKey("PMP600"), rx, ry, rz, rh)
									for j=1,4,1 do
										peds[4*(i-1)+j] = SpawnPed(GetHashKey("M_M_PITALIAN_01"), rx, ry, rz, rh)
										if(i == 1) then
											WarpCharIntoCar(peds[4*(i-1)+j], vehs[i+1])
										else
											WarpCharIntoCarAsPassenger(peds[4*(i-1)+j], vehs[i+1], j-2)
										end
										GiveWeaponToChar(peds[4*(i-1)+j], 12, 1000, 1)
										blips[4*(i-1)+j] = AddBlipForChar(peds[4*(i-1)+j])
									end
								end
								SetObjective("Get rid of ~y~rivals")
								currstage = 1
							end
						end
					else
						DrawMessage("~r~Mission failed", "Car destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					local mobskilled = 0
					for i=1,12,1 do
						if(not IsCharDead(peds[i])) then
							AttackPlayer(peds[i])
						else
							RemoveBlip(blips[i])
							mobskilled = mobskilled + 1
						end
					end
					if(mobskilled == 9) then
						for i=1,9,1 do
							RemoveBlip(blips[i])
						end
						SetObjective("Drop ~y~this car ~w~into ~y~water")
						currstage = 2
					end
					if(IsCarDead(vehs[1])) then
						DrawMessage("~r~Mission failed", "Car destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
					if(not IsCarDead(vehs[1])) then
						if(IsCarInWater(vehs[1])) then
							local finalreward = SeparateReward(mis[currmission].reward[1], mis[currmission].reward[2])
							money = money + finalreward[1]
							experience = experience + finalreward[2]
							SaveStats()
							DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
							missionsCompleted = missionsCompleted + 1
							SaveDailyStats()
							EndMission()
						end
					else
						DrawMessage("~r~Mission failed", "Car destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 10) then
				if(currstage == 0) then
					local mobskilled = 0
					for i=1,10,1 do
						if(not IsCharDead(peds[i])) then
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 10) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,10,1 do
									AttackPlayer(peds[j])
								end
							end
						else
							RemoveBlip(blips[i])
							mobskilled = mobskilled + 1
						end
					end
					if(mobskilled == 10) then
						local px,py,pz = GetCharCoordinates(peds[1])
						objs[1] = SpawnObject(GetHashKey("cj_case_2"), px, py, pz-1, 0.0)
						FreezeObjectPosition(objs[1], true)
						blips[1] = AddBlipForObject(objs[1])
						SetObjective("Collect ~y~the briefcase")
						currstage = 1
					end
				elseif(currstage == 1) then
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(IsCharTouchingObject(GetPlayerChar(GetPlayerId()), objs[1]) or IsPlayerNearCoords(ox, oy, oz, 2)) then
						DeleteObject(objs[1])
						RemoveBlip(blips[1])
						blips[1] = AddBlipForCoord(1328.92773, -79.94022, 26.48151)
						SetRoute(blips[1], true)
						SetObjective("Deliver ~y~this briefcase ~w~to ~y~the drop-off")
						currstage = 2
					end
				elseif(currstage == 2) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						local finalreward = SeparateReward(mis[currmission].reward[1], mis[currmission].reward[2])
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						missionsCompleted = missionsCompleted + 1
						SaveDailyStats()
						EndMission()
					end
				end
			elseif(currmission == 11) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i) == GetPlayerChar(GetPlayerId())) then
								RemoveBlip(blips[1])
								blips[1] = AddBlipForCoord(-152.89978, -866.27167, 5.12683)
								SetRoute(blips[1], true)
								SetObjective("Deliver ~y~this van ~w~to ~y~the destination")
								currstage = 1
							end
						end
					else
						DrawMessage("~r~Mission failed", "Van destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(IsCarDead(vehs[1])) then
						DrawMessage("~r~Mission failed", "Van destroyed.")
						EndMission()
					end
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							SetCarForwardSpeed(vehs[1], 0.0)
							TaskLeaveAnyCar(GetPlayerChar(GetPlayerId()))
							while IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1]) do
								Wait(0)
							end
							RemoveBlip(blips[1])
							Settimera(0)
							FreezeCarPosition(vehs[1], true)
							blips[1] = AddBlipForCar(vehs[1])
							SetObjective("Protect ~y~the hacker ~w~from ~y~rivals ~w~(~y~200 ~w~seconds left)")
							currstage = 2
						else
							PrintStringWithLiteralStringNow("STRING", "~r~You must be in mission vehicle!", 1000, 1)
						end
					end
				elseif(currstage == 2) then
					if(Timera() < 200000) then
						SetObjective("Protect ~y~the hacker ~w~from ~y~rivals ~w~(~y~" .. 200 - math.floor(Timera()/1000) .. " ~w~seconds left)")
						local pedsdead = 0
						for i=1,3,1 do
							if(IsCharDead(peds[i])) then
								RemoveBlip(blips[i+1])
								pedsdead = pedsdead + 1
							else
								AttackPlayer(peds[i])
							end
						end
						if(pedsdead == 3) then
							for i=1,3,1 do
								DeleteChar(peds[i])
							end
							local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
							local angle = GenerateRandomIntInRange(0, 360, _i)
							local radius = 100
							local rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
							while IsPlayerNearCoords(rx, ry, rz, 50) or (rz<pz-5) do
								Wait(0)
								px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
								local angle = GenerateRandomIntInRange(0, 360, _i)
								local radius = 100
								rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
							end
							for i=1,3,1 do
								peds[i] = SpawnPed(GetHashKey("M_Y_CHINATOWN_03"), rx, ry, rz, rh)
								GiveWeaponToChar(peds[i], 14, 1000, 1)
								RemoveBlip(blips[i+1])
								blips[i+1] = AddBlipForChar(peds[i], _i)
							end
						end
						if(IsCarDead(vehs[1])) then
							DrawMessage("~r~Mission failed", "Van destroyed.")
							EndMission()
						else
							local cx,cy,cz = GetCarCoordinates(vehs[1], _f, _f, _f)
							if(not IsPlayerNearCoords(cx, cy, cz, 10)) then
								local temptimer = Timera()
								Settimerb(0)
								while Timerb()<10000 do
									Wait(0)
									SetObjective("Get back to ~y~the van~w~! ~w~(~y~" .. 10 - math.floor(Timerb()/1000) .. " ~w~seconds left)")
									if(IsPlayerNearCoords(cx, cy, cz, 10)) then
										Settimera(temptimer)
										break
									end
									if(IsPlayerDead(GetPlayerId())) then
										break
									end
								end
								if(Timerb() >= 10000) then
									DrawMessage("~r~Mission failed", "Van abandoned.")
									EndMission()
								end
							end
						end
					else
						for i=1,4,1 do
							RemoveBlip(blips[i])
						end
						FreezeCarPosition(vehs[1], false)
						SetObjective("Lose ~y~wanted level")
						currstage = 3
					end
				elseif(currstage == 3) then
					if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
						local finalreward = SeparateReward(mis[currmission].reward[1], mis[currmission].reward[2])
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						missionsCompleted = missionsCompleted + 1
						SaveDailyStats()
						EndMission()
					end
				end
			elseif(currmission == 12) then
				if(currstage == 0) then
					local mobskilled = 0
					for i=1,15,1 do
						if(not IsCharDead(peds[i])) then
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,15,1 do
									AttackPlayer(peds[j])
								end
							end
						else
							RemoveBlip(blips[i])
							mobskilled = mobskilled + 1
						end
					end
					if(mobskilled == 15) then
						vehs[1] = SpawnCar(GetHashKey("annihilator"), -1208.94812, 1884.77258, 18.78073, 359.532592773438)
						blips[1] = AddBlipForCar(vehs[1])
						SetObjective("~y~The boss ~w~is escaping! Get into ~y~the helicopter")
						currstage = 1
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i) == GetPlayerChar(GetPlayerId())) then
								RemoveBlip(blips[1])
								vehs[2] = SpawnCar(GetHashKey("DINGHY"), -1757.10913, 1067.93335, -0.80396, 141.635040283203)
								peds[16] = SpawnPed(GetHashKey("M_M_PITALIAN_01"), -1757.10913, 1067.93335, -0.80396, 141.635040283203)
								WarpCharIntoCar(peds[16], vehs[2])
								TaskCarMission(peds[16], vehs[2], vehs[2], 1, 10.1, 0, 0, 10)
								blips[1] = AddBlipForChar(peds[16])
								SetObjective("Catch ~y~the boss ~w~and kill him")
								currstage = 2
							end
						end
					else
						DrawMessage("~r~Mission failed", "Helicopter destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
					if(IsCharDead(peds[16])) then
						RemoveBlip(blips[1])
						AlterWantedLevel(GetPlayerId(), 3)
						ApplyWantedLevelChangeNow(GetPlayerId())
						SetObjective("Lose ~y~wanted level")
						currstage = 3
					end
				elseif(currstage == 3) then
					if(StoreWantedLevel(GetPlayerId()) == 0) then
						local finalreward = SeparateReward(mis[currmission].reward[1], mis[currmission].reward[2])
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						missionsCompleted = missionsCompleted + 1
						SaveDailyStats()
						EndMission()
					end
				end
			elseif(currmission == 13) then
				if(currstage == 0) then
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(IsCharTouchingObject(GetPlayerChar(GetPlayerId()), objs[1]) or IsPlayerNearCoords(ox, oy, oz, 3)) then
						DeleteObject(objs[1])
						local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
						objs[1] = SpawnObject(GetHashKey("cj_mk_drug_bag"), px, py, pz, 0.0)
						AttachObjectToPed(objs[1],GetPlayerChar(GetPlayerId()),0x4B2,0.3,0,0,0,-math.pi/2,math.pi,0)
						RemoveBlip(blips[1])
						local coords = {
						{472.07495, 301.05719, 8.59821, 358.755187988281},
						{465.90579, 301.44766, 8.56036, 359.511352539063},
						{466.18524, 365.94501, 8.70538, 179.638931274414},
						{471.34662, 365.61923, 8.70538, 180.428604125977},
						{519.21851, 353.87961, 8.57158, 91.0261001586914},
						{519.46777, 341.89001, 8.57158, 87.4706954956055},
						{519.76141, 329.38174, 8.57158, 77.4781265258789},
						{412.05069, 317.1767, 8.57159, 274.690979003906},
						{411.91104, 328.95142, 8.57159, 268.905029296875},
						{411.88211, 341.11868, 8.57158, 267.822052001953}
						}
						for i=1,10,1 do
							peds[i] = SpawnPed(GetHashKey("M_Y_CHINATOWN_03"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
							GiveWeaponToChar(peds[i], 7, 1000, 1)
							blips[i] = AddBlipForChar(peds[i])
						end
						SetObjective("It's an ambush! Get rid of ~y~mobsters")
						currstage = 1
					end
				elseif(currstage == 1) then
					local mobskilled = 0
					for i=1,10,1 do
						if(not IsCharDead(peds[i])) then
							AttackPlayer(peds[i])
						else
							RemoveBlip(blips[i])
							mobskilled = mobskilled + 1
						end
					end
					if(mobskilled == 10) then
						SetObjective("Lose ~y~wanted level")
						currstage = 2
					end
				elseif(currstage == 2) then
					if(StoreWantedLevel(GetPlayerId()) == 0) then
						blips[1] = AddBlipForCoord(-290.5188, 731.95953, 10.96576)
						SetRoute(blips[1], true)
						SetObjective("Deliver ~y~this bag ~w~to ~y~the drop-off")
						currstage = 3
					end
				elseif(currstage == 3) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						local finalreward = SeparateReward(mis[currmission].reward[1], mis[currmission].reward[2])
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						missionsCompleted = missionsCompleted + 1
						SaveDailyStats()
						EndMission()
					end
				end
			elseif(currmission == 14) then
				if(currstage == 0) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
						RemoveBlip(blips[1])
						vehs[1] = SpawnCar(GetHashKey("REEFER"), 227.80334, 1733.47119, -0.28546, 77.8168106079102)
						LockCarDoors(vehs[1], 2)
						local coords = {
						{258.21143, 1707.11853, 4.63962, 359.417938232422},
						{257.94113, 1715.19153, 4.63962, 178.737213134766},
						{254.69568, 1729.58582, 1.30183, 160.90852355957},
						{244.52121, 1733.93567, 1.30184, 243.379837036133},
						{224.06607, 1740.1189, 1.30184, 256.147918701172}
						}
						for i=1,5,1 do
							peds[i] = SpawnPed(GetHashKey("M_M_GTRI_HI_01"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
							GiveWeaponToChar(peds[i], 9, 1000, 1)
							blips[i] = AddBlipForChar(peds[i])
							ChangeBlipColour(blips[i], 2)
							ChangeBlipScale(blips[i], 0.5)
							SetBlipAsShortRange(blips[i], true)
						end
						blips[6] = AddBlipForCoord(229.16934, 1738.92627, 1.30184)
						SetObjective("Go to ~y~your crewmates")
						currstage = 1
					end
				elseif(currstage == 1) then
					if(IsCarDead(vehs[1])) then
						DrawMessage("~r~Mission failed", "Boat destroyed.")
						EndMission()
					end
					local bp = GetBlipCoords(blips[6])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						RemoveBlip(blips[6])
						local coords = {
						{280.80856, 1712.25598, 11.01373, 87.2288589477539},
						{280.14758, 1725.95337, 11.01373, 93.9615936279297},
						{283.84003, 1709.26917, 11.01373, 10.3469715118408},
						{286.21536, 1697.60583, 15.82447, 11.5778255462646},
						{283.20834, 1730.38525, 11.01373, 173.598068237305},
						{283.11026, 1740.32825, 15.76391, 180.019241333008},
						{293.24573, 1745.45911, 15.84616, 113.105003356934},
						{304.52213, 1734.17041, 15.84693, 145.569290161133},
						{294.78723, 1724.20349, 15.84694, 120.192321777344},
						{297.41806, 1711.04468, 15.84694, 97.0851211547852}
						}
						for i=6,15,1 do
							peds[i] = SpawnPed(GetHashKey("M_Y_GKOR_LO_01"), coords[i-5][1], coords[i-5][2], coords[i-5][3], coords[i-5][4])
							GiveWeaponToChar(peds[i], 12, 1000, 1)
							blips[i] = AddBlipForChar(peds[i])
						end
						group = CreateGroup(false, true)
						SetGroupLeader(group, GetPlayerChar(GetPlayerId()))
						for i=1,5,1 do
							SetGroupMember(group, peds[i])
							SetCharNeverLeavesGroup(peds[i], true)
						end
						SetObjective("Get rid of ~y~rivals")
						currstage = 2
					end
				elseif(currstage == 2) then
					if(IsCarDead(vehs[1])) then
						DrawMessage("~r~Mission failed", "Boat destroyed.")
						EndMission()
					end
					for i=1,5,1 do
						if(not IsCharDead(peds[i])) then
							if(not IsPedInCombat(peds[i])) then
								TaskCombat(peds[i], peds[GenerateRandomIntInRange(6, 16)])
							end
						else
							RemoveBlip(blips[i])
						end
					end
					local mobskilled = 0
					for i=6,15,1 do
						if(not IsCharDead(peds[i])) then
							AttackPlayer(peds[i])
						else
							RemoveBlip(blips[i])
							mobskilled = mobskilled + 1
						end
					end
					if(mobskilled == 10) then
						vehs[2] = SpawnCar(GetHashKey("CAVALCADE"), 335.13153, 1756.04126, 17.10168, 178.841201782227)
						blips[16] = AddBlipForCar(vehs[2])
						peds[16] = SpawnPed(GetHashKey("M_Y_GKOR_LO_01"), 335.13153, 1756.04126, 17.10168, 178.841201782227)
						GiveWeaponToChar(peds[16], 12, 1000, 1)
						WarpCharIntoCar(peds[16], vehs[2])
						TaskCarMission(peds[16], vehs[2], vehs[2], 1, 20.1, 0, 0, 10)
						SetObjective("Someone has stolen the stuff! Get back ~y~the car")
						currstage = 3
					end
				elseif(currstage == 3) then
					if(not IsCarDead(vehs[2])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[2])) then
							if(GetDriverOfCar(vehs[2]) == GetPlayerChar(GetPlayerId())) then
								RemoveBlip(blips[16])
								blips[16] = AddBlipForCoord(279.56778, 1756.39075, 11.01372)
								SetRoute(blips[16], true)
								SetObjective("Return ~y~this car ~w~to ~y~the pier")
								currstage = 4
							end
						end
					else
						DrawMessage("~r~Mission failed", "Car destroyed.")
						EndMission()
					end
				elseif(currstage == 4) then
					if(not IsCarDead(vehs[2])) then
						local bp = GetBlipCoords(blips[16])
						DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[2])) then
								local finalreward = SeparateReward(mis[currmission].reward[1], mis[currmission].reward[2])
								money = money + finalreward[1]
								experience = experience + finalreward[2]
								SaveStats()
								DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
								missionsCompleted = missionsCompleted + 1
								SaveDailyStats()
								EndMission()
							end
						end
					else
						DrawMessage("~r~Mission failed", "Car destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 15) then
				if(currstage == 0) then
					for i=1,15,1 do
						if(not IsCharDead(peds[i])) then
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 10) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,15,1 do
									AttackPlayer(peds[j])
								end
							end
						end
					end
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						RemoveBlip(blips[1])
						objs[1] = SpawnObject(GetHashKey("ec_bomb_ne"), bp.x, bp.y, bp.z-1, 270.630859375, -686136475)
						SetObjective("Leave ~y~this area")
						currstage = 1
					end
				elseif(currstage == 1) then
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(not IsPlayerNearCoords(ox, oy, oz, 200)) then
						for i=1,3,1 do
							local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
							local angle = GenerateRandomIntInRange(0, 360, _i)
							local radius = 100
							local rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
							vehs[i] = SpawnCar(GetHashKey("oracle"), rx, ry, rz, rh)
							for j=1,4,1 do
								peds[4*(i-1)+j] = SpawnPed(GetHashKey("M_M_GBIK_LO_03"), rx, ry, rz, rh)
								if(j == 1) then
									WarpCharIntoCar(peds[4*(i-1)+j], vehs[i])
								else
									WarpCharIntoCarAsPassenger(peds[4*(i-1)+j], vehs[i], j-2)
								end
								GiveWeaponToChar(peds[4*(i-1)+j], 12, 1000, 1)
								blips[4*(i-1)+j] = AddBlipForChar(peds[4*(i-1)+j])
							end
						end
						SetObjective("Get rid of ~y~reinforcements")
						currstage = 2
					end
				elseif(currstage == 2) then
					local mobsdead = 0
					for i=1,12,1 do
						if(not IsCharDead(peds[i])) then
							AttackPlayer(peds[i])
						else
							RemoveBlip(blips[i])
							mobsdead = mobsdead + 1
						end
					end
					if(mobsdead == 12) then
						SetObjective("Lose ~y~wanted level")
						currstage = 3
					end
				elseif(currstage == 3) then
					if(StoreWantedLevel(GetPlayerId()) == 0) then
						local finalreward = SeparateReward(mis[currmission].reward[1], mis[currmission].reward[2])
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						missionsCompleted = missionsCompleted + 1
						SaveDailyStats()
						EndMission()
					end
				end
			elseif(currmission == 16) then
				if(currstage == 0) then
					for i=1,20,1 do
						if(not IsCharDead(peds[i])) then
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 10) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,20,1 do
									AttackPlayer(peds[j])
								end
							end
						end
					end
					local binsdestroyed = 0
					for i=1,3,1 do
						if(DoesObjectExist(objs[i])) then
							if(HasObjectBeenDamagedByChar(objs[i], GetPlayerChar(GetPlayerId()), false)) then
								DeleteObject(objs[i])
								RemoveBlip(blips[i])
							end
						else
							binsdestroyed = binsdestroyed + 1
						end
					end
					if(binsdestroyed == 3) then
						vehs[1] = SpawnCar(GetHashKey("cessna"), 2447.33472, 591.81628, 5.81287, 315.915618896484)
						peds[16] = SpawnPed(GetHashKey("IG_BULGARIN"), 2447.33472, 591.81628, 5.81287, 315.915618896484)
						WarpCharIntoCar(peds[16], vehs[1])
						blips[1] = AddBlipForChar(peds[16])
						Settimera(0)
						SetObjective("The boss is trying to escape! Kill ~y~him ~w~(~y~200 ~w~seconds left)")
						currstage = 1
					end
				elseif(currstage == 1) then
					if(Timera() < 200000) then
						SetObjective("The boss is trying to escape! Kill ~y~him ~w~(~y~" .. 200 - math.floor(Timera()/1000) .. " ~w~seconds left)")
						if(IsCharDead(peds[16])) then
							local finalreward = SeparateReward(mis[currmission].reward[1], mis[currmission].reward[2])
							money = money + finalreward[1]
							experience = experience + finalreward[2]
							SaveStats()
							DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
							missionsCompleted = missionsCompleted + 1
							SaveDailyStats()
							EndMission()
						end
					else
						DrawMessage("~r~Mission failed", "The boss has escaped.")
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