local blips = {}
local ped = nil
local veh = nil

local coords = {
{-286.38943, 1170.57959, 14.82203, 88.5729141235352},
{17.83252, 1647.49524, 29.95747, 297.118347167969},
{1411.81311, 1544.18872, 3.87816, 178.02653503418},
{559.55859, 1098.70972, 20.90947, 358.930725097656},
{831.42645, 614.60101, 38.57541, 268.453796386719},
{1484.98169, 983.75879, 13.97212, 283.307525634766},
{1630.53064, 198.90364, 26.32108, 130.757110595703},
{1117.72375, -328.30048, 39.66307, 128.586807250977},
{315.68579, -269.57489, 15.01909, 359.010375976563},
{-402.13022, -315.55978, 5.05872, 52.1042900085449},
{-536.97583, 392.66089, 6.66033, 357.754791259766},
{128.67781, 246.65601, 23.72121, 268.945007324219},
{-716.80408, 1170.01733, 19.39716, 87.8815765380859},
{-1600.5144, 1102.79272, 30.61357, 147.911727905273},
{-1293.13586, 505.79431, 50.97544, 178.319320678711},
{-1590.69348, -471.68146, 51.17069, 88.4913940429688},
{-1957.55591, 253.23891, 23.19406, 326.815673828125}
}

CreateThread(function()
	while true do
		Wait(0)
		if(not IsCarDead(veh)) then
			if(IsCharInCar(GetPlayerChar(GetPlayerId()), veh)) then
				if(not DoesBlipExist(blips[2])) then
					blips[2] = AddBlipForCoord(546.21387, 206.7056, 8.73118, _i)
				end
				DrawCheckpointWithDist(546.21387, 206.7056, 8.73118-1, 1.1, 255, 255, 0, 100)
				if(IsPlayerNearCoords(546.21387, 206.7056, 8.73118, 3)) then
					DeleteCar(veh)
					DeleteChar(ped)
					local tempmoney = GenerateRandomIntInRange(1000, 5000, _i)
					money = money + tempmoney
					experience = experience + 150
					SaveStats()
					DrawMessage("~y~Securicar has been successfully delivered", "You have got " .. tempmoney .. "$ and 150 EXP")
					securicarsStolen = securicarsStolen + 1
					SaveDailyStats()
				end
			else
				if(DoesBlipExist(blips[2])) then
					RemoveBlip(blips[2])
				end
			end
		else
			RemoveBlip(blips[1])
			DeleteCar(veh)
			DeleteChar(ped)
			Wait(600000)
			local rnd = GenerateRandomIntInRange(1, #coords+1)
			veh = SpawnCar(GetHashKey("STOCKADE"), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
			ped = SpawnPed(GetHashKey("M_Y_COP_TRAFFIC"), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
			GiveWeaponToChar(ped, 7, 1000, 1)
			WarpCharIntoCar(ped, veh)
			TaskCarMission(ped, veh, veh, 1, 10.1, 0, 0, 10)
			
			blips[1] = AddBlipForCar(veh, _i)
			ChangeBlipSprite(blips[1], 78)
			ChangeBlipScale(blips[1], 0.7)
			ChangeBlipNameFromAscii(blips[1], "Securicar")
			SetBlipAsShortRange(blips[1], true)
		end
	end
end)

AddEventHandler('baseevents:enteredVehicle', function(veh, vehseat, vehname)
	if(IsCarModel(veh, GetHashKey("STOCKADE"))) then
		if(StoreWantedLevel(GetPlayerId()) < 2) then
			AlterWantedLevel(GetPlayerId(), 2)
			ApplyWantedLevelChangeNow(GetPlayerId())
		end
	end
end)