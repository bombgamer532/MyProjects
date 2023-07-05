local salecooldown = 0
CreateThread(function()
	while true do
		Wait(0)
		if(salecooldown > 0) then
			Wait(1000)
			salecooldown = salecooldown - 1
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(not DoesBlipExist(carsellblip)) then
			carsellblip = AddBlipForCoord(935.7099, 1556.32336, 16.80302, _i)
			ChangeBlipSprite(carsellblip, 30)
			ChangeBlipColour(carsellblip, 19)
			ChangeBlipScale(carsellblip, 0.7)
			ChangeBlipNameFromAscii(carsellblip, "Car sale")
			SetBlipAsShortRange(carsellblip, true)
		end
		if(missionstarted == 0) then
			DrawTextAtCoord(935.7099, 1556.32336, 16.80302, "Car_sale", 20)
			DrawCheckpointWithDist(935.7099, 1556.32336, 16.80302-1, 3.1, 0, 255, 0, 100)
			if(IsPlayerNearCoords(935.7099, 1556.32336, 16.80302, 3)) then
				if(biz[3]==1 or biz[4]==1) then
					if(salecooldown == 0) then
						if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
							if(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())) ~= car) then
								local tempcar = 0
								for i=1,#carmodels,1 do
									if(GetCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))) == carmodels[i]) then
										tempcar = i
									end
								end
								if(tempcar ~= 0) then
									PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~sell this car", 1000, 1)
									if(IsGameKeyboardKeyJustPressed(18)) then
										DeleteCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())))
										money = money + math.floor(carprices[tempcar]/10)
										SaveStats()
										salecooldown = 300
										DrawMessage("~g~Car has been successfully sold", "You have got " .. math.floor(carprices[tempcar]/10) .. "$")
									end
								else
									PrintStringWithLiteralStringNow("STRING", "~r~This vehicle cannot be sold!", 1000, 1)
								end
							else
								PrintStringWithLiteralStringNow("STRING", "~r~You cannot sell your personal vehicle!", 1000, 1)
							end
						else
							PrintStringWithLiteralStringNow("STRING", "~r~You must be in car to use it", 1000, 1)
						end
					else
						PrintStringWithLiteralStringNow("STRING", "Come back in ~y~" .. salecooldown .. " seconds ~w~to use it", 1000, 1)
					end
				else
					PrintStringWithLiteralStringNow("STRING", "~r~You must own at least one repair shop business to use it", 1000, 1)
				end
			end
		end
	end
end)