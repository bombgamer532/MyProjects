--[[tutorial = 0
page = 1
local campos = {
{-1197.72241, 696.63141, 528.03577, 240.184799194336},

{59.33262, 1155.59912, 30.89157, 55.8526992797852},
{59.33262, 1155.59912, 30.89157, 55.8526992797852},
{59.33262, 1155.59912, 30.89157, 55.8526992797852},
{59.33262, 1155.59912, 30.89157, 55.8526992797852},

{-463.79538, 1161.63855, 17.5746, 330.035491943359},

{-253.20424, 1332.66931, 32.65205, 35.4144325256348},

{58.05925, -342.46439, 15.06486, 274.546081542969},

{34.94876, 826.20392, 17.61312, 230.618392944336},

{141.10078, 702.23169, 81.01629, 224.310684204102},

{-455.02469, 1020.7019, 13.15641, 221.012466430664},
{-455.02469, 1020.7019, 13.15641, 221.012466430664},

{-446.04474, 1431.70471, 49.9539, 348.362854003906},
{-446.04474, 1431.70471, 49.9539, 348.362854003906},
{-446.04474, 1431.70471, 49.9539, 348.362854003906},

{119.86144, -675.4472, 14.77174, 326.737670898438},
{119.86144, -675.4472, 14.77174, 326.737670898438},

{1777.79065, 168.13655, 32.98972, 348.205017089844},
{2188.22095, 556.38904, 50.19133, 219.80354309082},
{-1528.57947, 81.18847, 34.10722, 146.425827026367},

{-1279.64734, 237.43582, 162.26085, 359.716796875},
{-1279.64734, 237.43582, 162.26085, 359.716796875},

{-667.50897, 155.80846, 32.35126, 105.475952148438},

{-1033.9458, -5.64141, 189.23407, 278.660034179688}
}
local pointcoord = {
{-236.3605, 45.90164, 156.19728, 215.009658813477},

{22.87924, 1189.74084, 17.77691, 234.436157226563},
{22.87924, 1189.74084, 17.77691, 234.436157226563},
{22.87924, 1189.74084, 17.77691, 234.436157226563},
{22.87924, 1189.74084, 17.77691, 234.436157226563},

{-442.53101, 1184.79907, 12.87976, 313.147064208984},

{-272.94739, 1352.86267, 25.63648, 48.9086723327637},

{65.87373, -342.33163, 14.76728, 267.276977539063},

{55.3578, 805.67169, 14.76263, 222.565124511719},

{458.35892, 325.09882, 30.04033, 239.96044921875},

{-440.87131, 998.87598, 10.10547, 152.653457641602},
{-440.87131, 998.87598, 10.10547, 152.653457641602},

{-427.13391, 1452.44397, 39.10844, 330.711120605469},
{-427.13391, 1452.44397, 39.10844, 330.711120605469},
{-427.13391, 1452.44397, 39.10844, 330.711120605469},

{126.54335, -666.84418, 14.77173, 318.03564453125},
{126.54335, -666.84418, 14.77173, 318.03564453125},

{1786.01123, 191.745, 20.97231, 334.806304931641},
{2257.57056, 473.16229, 5.90551, 39.8100814819336},	
{-1574.7948, 30.04659, 10.03034, 111.514678955078},

{-1236.50415, 802.06433, 87.3614, 359.716644287109},
{-1236.50415, 802.06433, 87.3614, 359.716644287109},

{-768.72052, 152.50604, 5.03348, 74.2318420410156},

{-345.95419, 122.35266, 175.25507, 283.660034179688}
}
local text = {
"Welcome to the server! This tutorial will help you to start playing. Use mouse buttons to navigate through the pages.",

"To get ~y~cash ~w~you have to do ~y~different activities~w~.",
"You can ~y~rob shops~w~, ~y~steal securicars ~w~or ~y~do taxi, vigilante and paramedic side-missions~w~.",
"Use ~y~Caps Lock ~w~to activate these ~y~side-missions~w~.",
"Each activity lets you obtain ~y~cash ~w~and ~y~experience ~w~to get access to ~y~more content~w~.",

"This is ~y~shop~w~. You can ~y~rob it ~w~or buy some ~y~snacks ~w~which may help you later.",

"This is ~y~clothes shop~w~. Here you can change your ~y~gender, head, hair, clothes, etc.",

"This is ~y~gun shop~w~. Here you can buy ~y~guns, ammo and armor~w~.",

"This is ~y~car shop~w~. Here you can buy ~y~vehicles ~w~which you can spawn at ~y~your apartment~w~.",

"Player menu (~y~I button~w~). Here you can ~y~use different items, request personal vehicles, etc.",

"~y~Missions ~w~are the best way to get ~y~cash and experience~w~. They are blocked by ~y~level~w~.",
"You can start it at any time and there you can meet other players who may help you or kill you.",

"~y~Apartments ~w~are needed to ~y~spawn at them and spawn your personal vehicles~w~.",
"When you own at least ~y~one apartment~w~, you are allowed to ~y~purchase a boatyard and a helipad",
"They are needed to ~y~purchase and spawn corresponding vehicles~w~.",

"If you own an apartment, you are able to ~y~purchase an organization~w~.",
"It is needed to ~y~start organization missions, start heists and do manipulations with clan~w~.",

"~y~Own a businesses ~w~to be able to ~y~start heists~w~. They provide you access to specific heists.",
"Every in-game day at 00:00 you get your income based on your ~y~base income~w~.",
"To increase income you should ~y~do business jobs~w~ to increase ~y~income multiplier~w~.",

"~y~Heist ~w~is a multi-step mission which consists of ~y~necessary ~w~and ~y~optional missions~w~.",
"You can get advantage in ~y~final mission ~w~by completing ~y~optinal preparation missions~w~.",

"You can join ~y~gamemodes ~w~to ~y~compete with other players~w~ and get ~y~cash and experience~w~.",

"This is the end of tutorial. You can use ~y~player menu ~w~to check tutorial again."
}

CreateThread(function()
	while true do
		Wait(0)
		if(loginform == 0) then
			if(tutorial == 1) then
				if(not DoesCamExist(camera)) then
					SetCamActive(GetGameCam(), false)
					camera = CreateCam(14, _i)
					SetCamPropagate(camera, 1)
					SetCamActive(camera, true)
					ActivateScriptedCams(1, 1)
				end
				SetPlayerControl(GetPlayerId(), false)
				SetCamPos(camera, campos[page][1], campos[page][2], campos[page][3])
				PointCamAtCoord(camera, pointcoord[page][1], pointcoord[page][2], pointcoord[page][3])
				PrintStringWithLiteralStringNow("STRING", "" .. text[page], 1, 1)
				if(IsMouseButtonJustPressed(1)) then
					if(page ~= #campos) then
						page = page + 1
					else
						page = 0
						tutorial = 0
						SetCamActive(camera, false)
						SetCamActive(GetGameCam(), true)
						SetCamPropagate(camera, 0)
						SetCamPropagate(GetGameCam(), 1)
						ActivateScriptedCams(0, 0)
						DestroyCam(camera)
						SetPlayerControl(GetPlayerId(), true)
					end
				end
				if(IsMouseButtonJustPressed(2)) then
					if(page > 1) then
						page = page - 1
					end
				end
			end
		end
	end
end)]]

--[[local currmission = 0
local currstage = 0
local misblip = {}
local objs = {}
local peds = {}
local cars = {}

CreateThread(function()
	while true do
		Wait(0)
		if(loginform == 0) then
			if(experience < 1800) then
				if(tutorial == 0) then
					missionstarted = 1
					if(currstage == 0) then
						SetPlayerControl(GetPlayerId(), false)
						SetCharCoordinates(GetPlayerChar(GetPlayerId()), 696.8183, 798.9353, 16.15635)
						DrawDescription("Introduction", {
						-----------------------------------------------------------------------------------------------
						"Welcome to Liberty City! You have just arrived here by ship and the first thing you should do",
						"is to figure out how to start making cash and climb the career ladder. There is a friend of",
						"yours who wants to meet you and tell some information."
						})
						if(Timera() > 10000) then
							PrintStringWithLiteralStringNow("STRING", "Press ~y~Space ~w~to ~y~continue", 1000, 1)
							if(IsGameKeyboardKeyJustPressed(57)) then
								cars[1] = SpawnCar(GetHashKey("ESPERANTO"), 573.01697, 747.07568, 2.80117, 268.759521484375)
								SetCarCanBeDamaged(cars[1], false)
								SetCarCanBeVisiblyDamaged(cars[1], false)
								peds[1] = SpawnPed(GetHashKey("IG_LUIS"), 573.01697, 747.07568, 2.80117, 268.759521484375)
								SetCharInvincible(peds[1], true)
								WarpCharIntoCarAsPassenger(peds[1], cars[1], 0)
								SetPlayerControl(GetPlayerId(), true)
								SetCurrentObjective("Reach ~y~the marked point ~w~and enter ~y~the car")
								currstage = 1
							end
						end
					elseif(currstage == 1) then
						if(not DoesBlipExist(misblip[1])) then
							misblip[1] = AddBlipForCar(cars[1], _i)
						end
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), cars[1])) then
							if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i) == GetPlayerChar(GetPlayerId())) then
								RemoveBlip(misblip[1])
								SetCurrentObjective("Drive to ~y~a gun shop")
								currstage = 2
							end
						end
					elseif(currstage == 2) then
						if(not DoesBlipExist(misblip[1])) then
							misblip[1] = AddBlipForCoord(1052.90942, 89.05853, 33.45435, _i)
							SetRoute(misblip[1], true)
						end
						DrawCheckpointWithAlpha(1052.90942, 89.05853, 33.45435-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(1052.90942, 89.05853, 33.45435, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), cars[1])) then
								RemoveBlip(misblip[1])
								SetCarForwardSpeed(cars[1], 0.0)
								money = money + 100
								SaveStats()
								Settimera(0)
								SetCurrentObjective("")
								currstage = 3
							end
						end
					elseif(currstage == 3) then
						SetPlayerControl(GetPlayerId(), false)
						DrawDescription("Gun shop", {
						-----------------------------------------------------------------------------------------------
						"In this city it's impossible to make great amounts of cash without using guns. You have",
						"received some cash from your friend to buy your first gun.",
						" ",
						"~y~Guns are automatically saved and you do not lose them even after death."
						})
						if(Timera() > 10000) then
							PrintStringWithLiteralStringNow("STRING", "Press ~y~Space ~w~to ~y~continue", 1000, 1)
							if(IsGameKeyboardKeyJustPressed(57)) then
								SetPlayerControl(GetPlayerId(), true)
								SetCurrentObjective("Enter ~y~the gun shop ~w~and buy ~y~a gun (firearm)")
								currstage = 4
							end
						end
					elseif(currstage == 4) then
						local gw,cw = GetCurrentCharWeapon(GetPlayerChar(GetPlayerId()))
						if(cw >= 7) then
							SetCurrentObjective("Drive to ~y~a shop")
							currstage = 5
						end
					elseif(currstage == 5) then
						if(not DoesBlipExist(misblip[1])) then
							misblip[1] = AddBlipForCoord(1657.86035, 229.42744, 24.97093, _i)
							SetRoute(misblip[1], true)
						end
						DrawCheckpointWithAlpha(1657.86035, 229.42744, 24.97093-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(1657.86035, 229.42744, 24.97093, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), cars[1])) then
								RemoveBlip(misblip[1])
								SetCarForwardSpeed(cars[1], 0.0)
								Settimera(0)
								SetCurrentObjective("")
								currstage = 6
							end
						end
					elseif(currstage == 6) then
						SetPlayerControl(GetPlayerId(), false)
						DrawDescription("Shop", {
						-----------------------------------------------------------------------------------------------
						"Shop is needed to replenish your health and buy some snacks. Snacks can be eaten any time to",
						"replenish health. Also shops can be robbed to get some extra cash.",
						" ",
						"~y~Use player menu (I button) to eat snacks and do other options."
						})
						if(Timera() > 10000) then
							PrintStringWithLiteralStringNow("STRING", "Press ~y~Space ~w~to ~y~continue", 1000, 1)
							if(IsGameKeyboardKeyJustPressed(57)) then
								SetPlayerControl(GetPlayerId(), true)
								SetCurrentObjective("Enter ~y~the shop ~w~and start robbery")
								currstage = 7
							end
						end
					elseif(currstage == 7) then
						if(StoreWantedLevel(GetPlayerId()) > 0) then
							SetCurrentObjective("Finish the robbery and lose ~y~wanted level")
							currstage = 8
						end
					elseif(currstage == 8) then
						if(StoreWantedLevel(GetPlayerId()) == 0) then
							if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
								SetCarForwardSpeed(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), 0.0)
							end
							Settimera(0)
							SetCurrentObjective("")
							currstage = 9
						end
					elseif(currstage == 9) then
						SetPlayerControl(GetPlayerId(), false)
						DrawDescription("Experience", {
						-----------------------------------------------------------------------------------------------
						"For losing wanted level and doing other activities you receive experience points. Experience",
						"is needed to reach new levels and levels are needed to get access to more content.",
						" ",
						"~y~Your current level and progress bar are displayed on top of the screen."
						})
						if(Timera() > 10000) then
							PrintStringWithLiteralStringNow("STRING", "Press ~y~Space ~w~to ~y~continue", 1000, 1)
							if(IsGameKeyboardKeyJustPressed(57)) then
								SetPlayerControl(GetPlayerId(), true)
								Settimera(0)
								SetCurrentObjective("")
								currstage = 10
							end
						end
					elseif(currstage == 10) then
						SetPlayerControl(GetPlayerId(), false)
						DrawDescription("Next step", {
						-----------------------------------------------------------------------------------------------
						"Your friend called you to pick up a car from his repair shop. It must be delivered to one",
						"well-known businessman."
						})
						if(Timera() > 10000) then
							PrintStringWithLiteralStringNow("STRING", "Press ~y~Space ~w~to ~y~continue", 1000, 1)
							if(IsGameKeyboardKeyJustPressed(57)) then
								cars[2] = SpawnCar(GetHashKey("ORACLE"), 1781.60046, 190.73061, 21.0877, 137.627365112305)
								SetCarCanBeDamaged(cars[2], false)
								SetCarCanBeVisiblyDamaged(cars[2], false)
								SetPlayerControl(GetPlayerId(), true)
								SetCurrentObjective("Reach ~y~the marked point ~w~and enter ~y~the car")
								currstage = 11
							end
						end
					elseif(currstage == 11) then
						if(not DoesBlipExist(misblip[1])) then
							misblip[1] = AddBlipForCar(cars[2], _i)
						end
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), cars[2])) then
							if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i) == GetPlayerChar(GetPlayerId())) then
								RemoveBlip(misblip[1])
								Settimera(0)
								SetCurrentObjective("")
								currstage = 12
							end
						end
					elseif(currstage == 12) then
						SetPlayerControl(GetPlayerId(), false)
						DrawDescription("Businesses and apartments", {
						-----------------------------------------------------------------------------------------------
						"Business provides you ability to get passive income which can be increased by doing business",
						"missions. Also you can purchase apartments to get ability to spawn at them and store your",
						"vehicles there."
						})
						if(Timera() > 10000) then
							PrintStringWithLiteralStringNow("STRING", "Press ~y~Space ~w~to ~y~continue", 1000, 1)
							if(IsGameKeyboardKeyJustPressed(57)) then
								peds[2] = SpawnPed(GetHashKey("m_y_goon_01"), 1347.7666, 544.48444, 30.42332, 88.5704727172852)
								SetCharInvincible(peds[2], true)
								SetPlayerControl(GetPlayerId(), true)
								SetCurrentObjective("Drive to ~y~the marked point ~w~and pick up ~y~a person")
								currstage = 13
							end
						end
					elseif(currstage == 13) then
						if(not DoesBlipExist(misblip[1])) then
							misblip[1] = AddBlipForChar(peds[2], _i)
						end
						local px,py,pz = GetCharCoordinates(peds[2])
						if(IsPlayerNearCoords(px, py, pz, 10)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), cars[2])) then
								if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i) == GetPlayerChar(GetPlayerId())) then
									TaskEnterCarAsPassenger(peds[2], cars[2], 20000, 0)
									Wait(3000)
									if(IsCharInCar(peds[2], cars[2])) then
										RemoveBlip(misblip[1])
										SetCurrentObjective("Deliver ~y~this person ~w~to several ~y~marked places")
										currstage = 14
									end
								else
									PrintStringWithLiteralStringNow("STRING", "~r~You must be in a driver seat to proceed", 1000, 1)
								end
							else
								PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission vehicle (Oracle) to proceed", 1000, 1)
							end
						end
					elseif(currstage == 14) then
						if(not DoesBlipExist(misblip[1])) then
							misblip[1] = AddBlipForCoord(1185.30542, 191.38922, 32.46483, _i)
							SetRoute(misblip[1], true)
						end
						DrawCheckpointWithDist(1185.30542, 191.38922, 32.46483-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(1185.30542, 191.38922, 32.46483, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), cars[2])) then
								SetCurrentObjective("Wait for ~y~the businessman")
								SetCarForwardSpeed(cars[2], 0.0)
								SetPlayerControl(GetPlayerId(), false)
								TaskLeaveAnyCar(peds[2])
								while IsCharInCar(peds[2], cars[2]) do
									Wait(0)
								end
								TaskGoToCoordAnyMeans(peds[2], 1204.6875, 196.81143, 33.55339, 3, -1)
								while not IsPedNearCoords(peds[2], 1204.6875, 196.81143, 33.55339, 1) do
									Wait(0)
								end
								RemoveBlip(misblip[1])
								Settimera(0)
								SetCurrentObjective("")
								currstage = 15
							else
								PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission vehicle (Oracle) to proceed", 1000, 1)
							end
						end
					elseif(currstage == 15) then
						SetPlayerControl(GetPlayerId(), false)
						DrawDescription("Side jobs", {
						-----------------------------------------------------------------------------------------------
						"Robbing shops is not the only way how you can make cash. Also you can do some legal side-jobs",
						"as taxi driver, policeman and medic. To start these jobs you should steal a corresponding",
						"vehicle and activate a mission. Also you can steal securicars (marked with a dollar sign) and",
						"deliver them to marked point to get cash.",
						" ",
						"~y~Use Caps Lock while in vehicle to activate side-jobs."
						})
						if(Timera() > 10000) then
							PrintStringWithLiteralStringNow("STRING", "Press ~y~Space ~w~to ~y~continue", 1000, 1)
							if(IsGameKeyboardKeyJustPressed(57)) then
								SetPlayerControl(GetPlayerId(), true)
								SetCurrentObjective("Wait for ~y~the businessman")
								currstage = 16
							end
						end
					elseif(currstage == 16) then
						TaskEnterCarAsPassenger(peds[2], cars[2], 20000, 0)
						while not IsCharInCar(peds[2], cars[2]) do
							Wait(0)
							TaskEnterCarAsPassenger(peds[2], cars[2], 20000, 0)
							Wait(3000)
						end
						SetCurrentObjective("Deliver ~y~this person ~w~to several ~y~marked places")
						currstage = 17
					elseif(currstage == 17) then
						if(not DoesBlipExist(misblip[1])) then
							misblip[1] = AddBlipForCoord(1915.78784, 427.47147, 18.19742, _i)
							SetRoute(misblip[1], true)
						end
						DrawCheckpointWithDist(1915.78784, 427.47147, 18.19742-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(1915.78784, 427.47147, 18.19742, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), cars[2])) then
								SetCurrentObjective("Wait for ~y~the businessman")
								SetCarForwardSpeed(cars[2], 0.0)
								SetPlayerControl(GetPlayerId(), false)
								TaskLeaveAnyCar(peds[2])
								while IsCharInCar(peds[2], cars[2]) do
									Wait(0)
								end
								TaskGoToCoordAnyMeans(peds[2], 1936.55603, 438.84668, 18.25696, 3, -1)
								while not IsPedNearCoords(peds[2], 1936.55603, 438.84668, 18.25696, 1) do
									Wait(0)
								end
								RemoveBlip(misblip[1])
								Settimera(0)
								SetCurrentObjective("")
								currstage = 18
							else
								PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission vehicle (Oracle) to proceed", 1000, 1)
							end
						end
					elseif(currstage == 18) then
						SetPlayerControl(GetPlayerId(), false)
						DrawDescription("Game modes", {
						-----------------------------------------------------------------------------------------------
						"You can participate in several multiplayer game modes around the map to get more extra cash",
						"and experience. For winning in such game modes you can receive great rewards."
						})
						if(Timera() > 10000) then
							PrintStringWithLiteralStringNow("STRING", "Press ~y~Space ~w~to ~y~continue", 1000, 1)
							if(IsGameKeyboardKeyJustPressed(57)) then
								SetPlayerControl(GetPlayerId(), true)
								SetCurrentObjective("Wait for ~y~the businessman")
								currstage = 19
							end
						end
					elseif(currstage == 19) then
						TaskEnterCarAsPassenger(peds[2], cars[2], 20000, 0)
						while not IsCharInCar(peds[2], cars[2]) do
							Wait(0)
							TaskEnterCarAsPassenger(peds[2], cars[2], 20000, 0)
							Wait(3000)
						end
						SetCurrentObjective("Deliver ~y~this person ~w~to several ~y~marked places")
						currstage = 20
					elseif(currstage == 20) then
						if(not DoesBlipExist(misblip[1])) then
							misblip[1] = AddBlipForCoord(79.71687, -654.88483, 12.68163, _i)
							SetRoute(misblip[1], true)
						end
						DrawCheckpointWithDist(79.71687, -654.88483, 12.68163-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(79.71687, -654.88483, 12.68163, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), cars[2])) then
								SetCurrentObjective("Wait for ~y~the businessman")
								SetCarForwardSpeed(cars[2], 0.0)
								SetPlayerControl(GetPlayerId(), false)
								TaskLeaveAnyCar(peds[2])
								while IsCharInCar(peds[2], cars[2]) do
									Wait(0)
								end
								TaskGoToCoordAnyMeans(peds[2], 77.28269, -682.21393, 14.76446, 3, -1)
								while not IsPedNearCoords(peds[2], 77.28269, -682.21393, 14.76446, 1) do
									Wait(0)
								end
								RemoveBlip(misblip[1])
								Settimera(0)
								SetCurrentObjective("")
								currstage = 21
							else
								PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission vehicle (Oracle) to proceed", 1000, 1)
							end
						end
					elseif(currstage == 21) then
						SetPlayerControl(GetPlayerId(), false)
						DrawDescription("Organization", {
						-----------------------------------------------------------------------------------------------
						"Organization is the most important place. Here you can collect income from your businesses,",
						"create and manage your clan, start heists and do other things.",
						"Heist is a multi-step mission which consists of necessary and optional missions. You can get",
						"advantage in final mission by completing optinal preparation missions. Heists are the most",
						"efficient way to make cash.",
						"Clan provides several advantages and access to area capturing."
						})
						if(Timera() > 10000) then
							PrintStringWithLiteralStringNow("STRING", "Press ~y~Space ~w~to ~y~continue", 1000, 1)
							if(IsGameKeyboardKeyJustPressed(57)) then
								SetPlayerControl(GetPlayerId(), true)
								Settimera(0)
								SetCurrentObjective("")
								currstage = 22
							end
						end
					elseif(currstage == 22) then
						SetPlayerControl(GetPlayerId(), false)
						DrawDescription("Missions", {
						-----------------------------------------------------------------------------------------------
						"There are many missions around the map. All of them are marked with question mark and each",
						"has its own level blocker. All currently available missions are marked with green question",
						"mark. This is the primary way of earning cash and experience. Higher level means higher",
						"difficulty and at the same time higher rewards."
						})
						if(Timera() > 10000) then
							PrintStringWithLiteralStringNow("STRING", "Press ~y~Space ~w~to ~y~continue", 1000, 1)
							if(IsGameKeyboardKeyJustPressed(57)) then
								SetPlayerControl(GetPlayerId(), true)
								Settimera(0)
								SetCurrentObjective("")
								currstage = 23
							end
						end
					elseif(currstage == 23) then
						SetPlayerControl(GetPlayerId(), false)
						DrawDescription("Outroduction", {
						-----------------------------------------------------------------------------------------------
						"This is the end of tutorial. There are more other things to explore. Good luck!"
						})
						if(Timera() > 10000) then
							PrintStringWithLiteralStringNow("STRING", "Press ~y~Space ~w~to ~y~continue", 1000, 1)
							if(IsGameKeyboardKeyJustPressed(57)) then
								SetPlayerControl(GetPlayerId(), true)
								for i=1,2,1 do
									DeleteCar(cars[i])
									DeleteChar(peds[i])
								end
								money = money + 5000
								experience = experience + 200
								tutorial = 1
								SaveStats()
								DrawMessage("~y~Tutorial completed", "You have got 5000$ and 200 EXP")
								SetCurrentObjective("")
								currstage = 0
								currmission = 0
								missionstarted = 0
							end
						end
					end
					if(IsPlayerDead(GetPlayerId())) then
						for i=1,15,1 do
							RemoveBlip(misblip[i])
							DeleteCar(cars[i])
							DeleteObject(objs[i])
							DeleteChar(peds[i])
						end
						while IsPlayerDead(GetPlayerId()) do
							Wait(0)
						end
						--SetCharCoordinates(GetPlayerChar(GetPlayerId()), )
						SetCurrentObjective("")
						currstage = 0
					end
				end
			end
		end
	end
end)]]

CreateThread(function()
	while true do
		Wait(0)
		if(loginform == 0) then
			if(tutorial == 0) then
				SetPlayerControl(GetPlayerId(), false)
				DrawDescription("Welcome to IV: ~y~Online!", {
				-----------------------------------------------------------------------------------------------
				"IV: Online is the representation of GTA Online in CitizenIV. The main goal of this project",
				"is to bring as much GTA Online abilities and features as possible. Here you can do missions,",
				"heists, side-jobs, buy apartments, businesses, vehicles, participate in several game modes",
				"and many other activities. To get full information about all aspects of gameplay, use ~y~player",
				"~y~menu (I button) ~w~and select ~y~Help ~w~item."
				})
				--if(Timera() > 10000) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~Space ~w~to ~y~close", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(57)) then
						SetPlayerControl(GetPlayerId(), true)
						tutorial = 1
						SaveStats()
					end
				--end
			end
		end
	end
end)