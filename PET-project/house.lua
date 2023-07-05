houseinfo = {
{50000, {-1249.48975, 1548.9707, 30.89815, 92.4977188110352}, {-1234.6698, 1541.40576, 25.20967, 178.10466003418}, 3},
{25000, {-1009.28711, 1225.31824, 28.42268, 178.694030761719}, {-988.4007, 1241.39136, 24.06977, 269.61328125}, 1},
{50000, {-969.32843, 891.87415, 19.00632, 177.153396606445}, {-966.23181, 901.31323, 13.58926, 268.219177246094}, 3},
{100000, {-432.73627, 1461.02502, 38.97145, 264.433135986328}, {-421.51892, 1492.65063, 18.7791, 267.330718994141}, 7},
{50000, {-127.62131, 1495.37952, 22.78276, 323.741180419922}, {-116.62468, 1493.01892, 18.46153, 223.160705566406}, 3},
{120000, {105.11219, 844.96503, 45.06986, 269.629638671875}, {119.02437, 845.48907, 14.6246, 178.315078735352}, 8},
{200000, {-183.37979, 578.56348, 122.78415, 357.192504882813}, {-164.23315, 617.08063, 14.73571, 86.8681716918945}, 13},
{50000, {602.80206, 1411.46582, 17.48467, 270.080230712891}, {589.51532, 1400.00146, 10.85497, 359.289855957031}, 3},
{25000, {567.10956, 1391.04236, 30.86005, 82.4105453491211}, {581.09314, 1402.42444, 10.90875, 178.267669677734}, 1},
{50000, {1363.62842, 525.15051, 33.11604, 269.781311035156}, {1398.19922, 529.90259, 28.972, 188.788970947266}, 3},
{10000, {878.41827, -15.27376, 28.44133, 97.5186767578125}, {893.28735, -34.31548, 27.33641, 179.93879699707}, 1},
{50000, {1369.64294, 217.04591, 35.68861, 351.688659667969}, {1367.44116, 187.34341, 27.17358, 89.334098815918}, 3},
{70000, {892.62335, -494.77954, 19.43723, 90.9429702758789}, {903.84229, -497.33853, 15.10181, 179.185241699219}, 5},
{80000, {857.47766, -512.59338, 16.28271, 177.329452514648}, {842.9953, -517.17694, 14.01474, 357.399383544922}, 5},
--{500000, {-15.34916, 780.75189, 66.21265, 359.271759033203}, {-39.45435, 792.15686, 14.65837, 358.755279541016}, 18},
--{200000, {-69.58076, -209.3956, 32.81075, 89.0550079345703}, {-74.2261, -229.80818, 14.57308, 88.5242156982422}, 13},
--{70000, {-1446.8905, 497.13519, 22.90181, 187.563507080078}, {-1474.29541, 490.7373, 19.47624, 358.341217041016}, 5},
--{100000, {-430.81015, 1395.45227, 16.46197, 92.7748107910156}, {-449.57709, 1389.73108, 15.40304, 358.742584228516}, 7},
--{70000, {1599.69983, 566.98462, 30.80721, 18.6751174926758}, {1575.15198, 568.06543, 28.93663, 358.111236572266}, 5},
--{50000, {-1953.79919, -74.90328, 11.37589, 350.419250488281}, {-1950.28174, -86.82784, 6.5897, 90.2191543579102}, 3},
{70000, {-548.90228, 1235.46301, 97.58067, 257.567230224609}, {-519.763, 1252.07397, 17.49931, 169.46142578125}, 5},
{30000, {-138.09778, 1383.15088, 32.8019, 176.576690673828}, {-146.93506, 1382.64307, 20.36282, 359.059143066406}, 1}
}
local houseblip = {}
houses = {}
for i=1,#houseinfo,1 do
	houses[i] = 0
end

RegisterNetEvent('updHouses')
AddEventHandler('updHouses', function(data)
	for i=1,#houseinfo,1 do
		if(data[i] == nil) then
			data[i] = 0
		end
		houses[i] = tonumber(data[i])
	end
end)

SaveHouses = function()
	local data = {}
	for i=1,#houses,1 do
		data[i] = houses[i]
	end
	TriggerServerEvent('saveHouses', data)
end

local outfits = {}
RegisterNetEvent('updOutfits')
AddEventHandler('updOutfits', function(data)
	for i=1,#data,1 do
		outfits[i] = {}
		for j=1,#data[i],1 do
			--if(j ~= 1) then
				outfits[i][j] = tonumber(data[i][j])
			--end
		end
	end
end)
SaveOutfits = function()
	local data = {}
	for i=1,#outfits,1 do
		data[i] = outfits[i]
	end
	TriggerServerEvent('saveOutfits', data)
end

local tps = {
{{-429.3829, 1474.45105, 20.15734, 264.607788085938}, {-426.2684, 1467.52307, 38.96716, 177.701553344727}},
{{97.3325, 840.97095, 15.79246, 179.197265625}, {96.28168, 851.79089, 45.05099, 270.314331054688}},
{{-184.02568, 597.3703, 15.34177, 269.438262939453}, {-184.15724, 597.37561, 114.44452, 269.975769042969}},
{{211.69096, -206.73399, 10.75592, 203.194732666016}, {214.4516, -200.84976, 53.90819, 24.505298614502}},
{{-29.58179, 792.60193, 14.95882, 269.121063232422}, {-9.89077, 797.75171, 62.80701, 359.216857910156}},
{{-74.54211, -223.26233, 14.62667, 180.804458618164}, {-72.29755, -199.12674, 32.81074, 89.4780120849609}},
{{-1462.35901, 490.82028, 20.40515, 89.6220474243164}, {-1452.04614, 490.16425, 22.89349, 268.436584472656}},
{{-542.67694, 1256.85364, 97.53958, 80.3351516723633}, {-542.66107, 1256.78076, 17.54518, 78.9661102294922}},
{{-132.37166, 1381.0896, 32.80192, 178.877883911133}, {-132.35594, 1379.49695, 32.80189, 178.550170898438}},
{{-70.45285, 56.6353, 14.76831, 91.1682510375977}, {-72.01129, 56.58701, 14.767, 89.4574432373047}},
{{-81.69284, 57.98582, 14.99217, 87.7236709594727}, {-85.80848, 62.6665, 19.62852, 266.988494873047}}
}
CreateThread(function()
	while true do
		Wait(0)
		for i=1,#tps,1 do
			for j=1,2,1 do
				DrawCheckpointWithDist(tps[i][j][1], tps[i][j][2], tps[i][j][3]-1, 1.1, 255, 255, 0, 100)
				if(IsPlayerNearCoords(tps[i][j][1], tps[i][j][2], tps[i][j][3], 1)) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~use", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						if(j == 1) then
							SetCharCoordinates(GetPlayerChar(GetPlayerId()), tps[i][2][1], tps[i][2][2], tps[i][2][3])
							SetCharHeading(GetPlayerChar(GetPlayerId()), tps[i][2][4])
						else
							SetCharCoordinates(GetPlayerChar(GetPlayerId()), tps[i][1][1], tps[i][1][2], tps[i][1][3])
							SetCharHeading(GetPlayerChar(GetPlayerId()), tps[i][1][4])
						end
						break
					end
				end
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		for i=1,#houseinfo,1 do
			if(not DoesBlipExist(houseblip[i])) then
				houseblip[i] = AddBlipForCoord(houseinfo[i][2][1], houseinfo[i][2][2], houseinfo[i][2][3], _i)
				ChangeBlipSprite(houseblip[i], 29)
				ChangeBlipScale(houseblip[i], 0.7)
				ChangeBlipNameFromAscii(houseblip[i], "Apartment #" .. i)
				SetBlipAsShortRange(houseblip[i], true)
			end
			if(houses[i] == 0) then
				DrawTextAtCoord(houseinfo[i][2][1], houseinfo[i][2][2], houseinfo[i][2][3], "Apartment_#" .. i .. " Price:_" .. houseinfo[i][1] .. "$ Garage_places:_" .. houseinfo[i][4], 20)
				ChangeBlipColour(houseblip[i], 0)
			else
				DrawTextAtCoord(houseinfo[i][2][1], houseinfo[i][2][2], houseinfo[i][2][3], "Apartment_#" .. i .. " Owned Garage_places:_" .. houseinfo[i][4], 20)
				ChangeBlipColour(houseblip[i], 2)
			end
			DrawCheckpointWithDist(houseinfo[i][2][1], houseinfo[i][2][2], houseinfo[i][2][3]-1, 1.1, 255, 255, 0, 100)
			if(IsPlayerNearCoords(houseinfo[i][2][1], houseinfo[i][2][2], houseinfo[i][2][3], 1)) then
				if(houses[i] == 0) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to purchase ~y~this apartment ~w~for ~g~" .. houseinfo[i][1] .. "$", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						if(money >= houseinfo[i][1]) then
							money = money - houseinfo[i][1]
							SaveStats()
							houses[i] = 1
							SaveHouses()
							TriggerEvent('chatMessage', '[Apartment]', {0, 255, 0}, 'This apartment has been successfully purchased!')
						else
							TriggerEvent('chatMessage', '[Apartment]', {255, 0, 0}, 'You cannot afford it!')
						end
					end
				else
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~open apartment menu", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						local tempitems = {}
						tempitems[#tempitems+1] = "Open garage menu"
						tempitems[#tempitems+1] = "Wardrobe"
						DrawWindow("Apartment_#" .. i, tempitems)
						while menuactive do
							Wait(0)
						end
						if(menuresult > 0) then
							if(tempitems[menuresult] == "Open garage menu") then
								::garage::
								local tempitems = {}
								tempitems[#tempitems+1] = "Personal vehicles"
								tempitems[#tempitems+1] = "Misc vehicles"
								tempitems[#tempitems+1] = "Trucks"
								DrawWindow("Garage_menu", tempitems)
								while menuactive do
									Wait(0)
								end
								if(menuresult > 0) then
									if(tempitems[menuresult] == "Personal vehicles") then
										::vehs::
										local tempitems = {}
										for j=1,#cars,1 do
											if(cars[j] == 1) then
												tempitems[#tempitems+1] = "" .. carinfo[j][1]
											end
										end
										DrawWindow("Personal_vehicles", tempitems)
										while menuactive do
											Wait(0)
										end
										if(menuresult > 0) then
											local tempcarid = 0
											for j=1,#carinfo,1 do
												if(carinfo[j][1] == tempitems[menuresult]) then
													tempcarid = j
												end
											end
											DrawWindow("" .. tempitems[menuresult], {"Spawn", "Sell ~y~(" .. carinfo[tempcarid][2]/2 .. "$)"})
											while menuactive do
												Wait(0)
											end
											if(menuresult > 0) then
												if(menuresult == 1) then
													DeleteCar(car)
													car = SpawnCar(carinfo[tempcarid][3], houseinfo[i][3][1], houseinfo[i][3][2], houseinfo[i][3][3], houseinfo[i][3][4])
													SetVehicleTuning(car)
													TriggerEvent('chatMessage', '[Apartment]', {0, 255, 0}, 'Vehicle spawned near the apartment.')
												elseif(menuresult == 2) then
													money = money + carinfo[tempcarid][2]/2
													SaveStats()
													cars[tempcarid] = 0
													SaveCars()
													TriggerEvent('chatMessage', '[Apartment]', {255, 255, 0}, 'Vehicle sold (+' .. carinfo[tempcarid][2]/2 .. '$).')
												end
											else
												goto vehs
											end
										else
											goto garage
										end
									elseif(tempitems[menuresult] == "Misc vehicles") then
										if(supporter == 1) then
											local tempitems = {}
											for j=1,#misccars,1 do
												tempitems[#tempitems+1] = "" .. misccars[j][1]
											end
											DrawWindow("Misc_vehicles", tempitems)
											while menuactive do
												Wait(0)
											end
											if(menuresult > 0) then
												local tempcarid = 0
												for j=1,#misccars,1 do
													if(misccars[j][1] == tempitems[menuresult]) then
														tempcarid = #carinfo + j
													end
												end
												DeleteCar(car)
												car = SpawnCar(misccars[menuresult][2], houseinfo[i][3][1], houseinfo[i][3][2], houseinfo[i][3][3], houseinfo[i][3][4])
												SetVehicleTuning(car)
												TriggerEvent('chatMessage', '[Apartment]', {0, 255, 0}, 'Vehicle spawned near the apartment.')
											else
												goto garage
											end
										else
											TriggerEvent('chatMessage', '[Garage]', {255, 0, 0}, 'You must be a supporter to use it!')
											goto garage
										end
									elseif(tempitems[menuresult] == "Trucks") then
										if(supporter == 1) then
											::trucks::
											local tempitems = {}
											for j=1,#trucks,1 do
												if(trucks[j] == 1) then
													tempitems[#tempitems+1] = "" .. truckinfo[j][1]
												end
											end
											DrawWindow("Trucks", tempitems)
											while menuactive do
												Wait(0)
											end
											if(menuresult > 0) then
												local tempcarid = 0
												local tempcarid2 = 0
												for j=1,#truckinfo,1 do
													if(truckinfo[j][1] == tempitems[menuresult]) then
														tempcarid = j
														tempcarid2 = #carinfo + #misccars + j
													end
												end
												DrawWindow("" .. tempitems[menuresult], {"Spawn", "Sell ~y~(" .. truckinfo[tempcarid][3]/2 .. "$)"})
												while menuactive do
													Wait(0)
												end
												if(menuresult > 0) then
													if(menuresult == 1) then
														DeleteCar(car)
														car = SpawnCar(truckinfo[tempcarid][2], houseinfo[i][3][1], houseinfo[i][3][2], houseinfo[i][3][3], houseinfo[i][3][4])
														SetVehicleTuning(car)
														TriggerEvent('chatMessage', '[Apartment]', {0, 255, 0}, 'Vehicle spawned near the apartment.')
													elseif(menuresult == 2) then
														money = money + truckinfo[tempcarid][3]/2
														SaveStats()
														trucks[tempcarid] = 0
														SaveTrucks()
														TriggerEvent('chatMessage', '[Apartment]', {255, 255, 0}, 'Vehicle sold (+' .. truckinfo[tempcarid][3]/2 .. '$).')
													end
												else
													goto trucks
												end
											else
												goto garage
											end
										else
											TriggerEvent('chatMessage', '[Garage]', {255, 0, 0}, 'You must be a supporter to use it!')
											goto garage
										end
									end
								end
							elseif(tempitems[menuresult] == "Wardrobe") then
								::wardrobe::
								local tempitems = {}
								tempitems[#tempitems+1] = "Saved outfits"
								tempitems[#tempitems+1] = "Save current outfit"
								DrawWindow("Wardrobe", tempitems)
								while menuactive do
									Wait(0)
								end
								if(menuresult > 0) then
									if(tempitems[menuresult] == "Saved outfits") then
										::outfits::
										local tempitems = {}
										for j=1,#outfits,1 do
											tempitems[j] = "Outfit " .. j
										end
										DrawWindow("Saved_outfits", tempitems)
										while menuactive do
											Wait(0)
										end
										if(menuresult > 0) then
											local sel = menuresult
											local tempitems = {}
											tempitems[#tempitems+1] = "Wear"
											tempitems[#tempitems+1] = "Delete"
											DrawWindow("Outfit_" .. sel, tempitems)
											while menuactive do
												Wait(0)
											end
											if(menuresult > 0) then
												if(tempitems[menuresult] == "Wear") then
													for j=1,#outfits[sel],1 do
														currparts[j] = outfits[sel][j]
													end
													SaveParts()
													SetDefaultSkin()
												elseif(tempitems[menuresult] == "Delete") then
													local newoutfits = {}
													for i=1,#outfits,1 do
														if(i ~= sel) then
															table.insert(newoutfits, outfits[i])
														end
													end
													outfits = newoutfits
													SaveOutfits()
													TriggerEvent('chatMessage', '[Wardrobe]', {255, 255, 0}, 'Outfit deleted.')
												end
											else
												goto outfits
											end
										else
											goto wardrobe
										end
									elseif(tempitems[menuresult] == "Save current outfit") then
										local tempoutfit = {}
										for i=1,#currparts,1 do
											tempoutfit[i] = currparts[i]
										end
										outfits[#outfits+1] = tempoutfit
										SaveOutfits()
										TriggerEvent('chatMessage', '[Wardrobe]', {255, 255, 0}, 'Outfit saved.')
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)