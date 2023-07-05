local prizes = {
"10000$",
"20000$",
"30000$",
"1000 EXP",
"2000 EXP",
"3000 EXP",
"Random vehicle"
}

local slotcoords = {
{-226.063522338867, 40.7786598205566, 14.4988021850586, 90.0124664306641, 877820577},
{-239.508850097656, 40.7753524780273, 14.498872756958, 90.3622055053711, 877820577}
}
local slotm = {}
CreateThread(function()
	while true do
		Wait(0)
		if(not DoesBlipExist(luckyblip)) then
			luckyblip = AddBlipForCoord(-234.95645, 47.55979, 15.705, _i)
			ChangeBlipSprite(luckyblip, 49)
			ChangeBlipColour(luckyblip, 19)
			ChangeBlipScale(luckyblip, 0.7)
			ChangeBlipNameFromAscii(luckyblip, "Lucky wheel")
			SetBlipAsShortRange(luckyblip, true)
		end
		if(IsPlayerControlOn(GetPlayerId())) then
			DrawTextAtCoord(-234.95645, 47.55979, 15.705, "Lucky_wheel", 20)
			DrawCheckpointWithDist(-234.95645, 47.55979, 15.705-1, 1.1, 255, 255, 0, 100)
			if(IsPlayerNearCoords(-234.95645, 47.55979, 15.705, 1)) then
				DrawDescription("Lucky wheel", {
				-----------------------------------------------------------------------------------------------
				"You can use the lucky wheel once per day. All chances are equal. Possible prizes:",
				"- 10000$",
				"- 30000$",
				"- 50000$",
				"- 1000 EXP",
				"- 2000 EXP",
				"- 3000 EXP",
				"- Random vehicle (duplicates are possible)"
				})
				PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~spin lucky wheel", 1000, 1)
				if(IsGameKeyboardKeyJustPressed(18)) then
					if(level >= 10) then
						if(bonusday ~= currday) then
							SpinLuckyWheel()
							bonusday = currday
							SaveStats()
						else
							TriggerEvent('chatMessage', '[Lucky wheel]', {255, 0, 0}, 'You can spin lucky wheel only once per day! Try again later.')
						end
					else
						TriggerEvent('chatMessage', '[Lucky wheel]', {255, 0, 0}, 'You must reach level 10!')
					end
				end
			end
			for i=1,#slotcoords,1 do
				if(not DoesObjectExist(slotm[i])) then
					local model = GetHashKey("gb_hosp_machine01")
					RequestModel(model)
					while not HasModelLoaded(model) do
						Wait(0)
					end
					slotm[i] = CreateObjectNoOffset(model, slotcoords[i][1], slotcoords[i][2], slotcoords[i][3], 0)
					MarkModelAsNoLongerNeeded(model)
					ActivateInterior(GetInteriorAtCoords(slotcoords[i][1], slotcoords[i][2], slotcoords[i][3], _i), true)
					LoadSceneForRoomByKey(GetInteriorAtCoords(slotcoords[i][1], slotcoords[i][2], slotcoords[i][3]), slotcoords[i][5])
					AddObjectToInteriorRoomByKey(slotm[i], slotcoords[i][5])
					SetObjectHeading(slotm[i], slotcoords[i][4])
					FreezeObjectPosition(slotm[i], true)
					
					--slotm[i] = SpawnObject(GetHashKey("gb_hosp_machine01"), slotcoords[i][1], slotcoords[i][2], slotcoords[i][3], slotcoords[i][4], slotcoords[i][5])
					--FreezeObjectPosition(slotm[i], true)
				end
				DrawTextAtCoord(slotcoords[i][1], slotcoords[i][2], slotcoords[i][3], "Slot_machine", 20)
				--DrawCheckpointWithDist(slotcoords[i][1], slotcoords[i][2], slotcoords[i][3]-1, 1.1, 0, 255, 0, 100)
				if(IsPlayerNearCoords(slotcoords[i][1], slotcoords[i][2], slotcoords[i][3], 1)) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~start slot machine ~w~for ~g~1000$", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						if(money >= 1000) then
							money = money - 1000
							SaveStats()
							StartSlotMachine()
						else
							TriggerEvent('chatMessage', '[Slot machine]', {255, 0, 0}, 'You do not have enough money!')
						end
					end
				end
			end
		end
	end
end)

local text = ""
SpinLuckyWheel = function()
	SetPlayerControl(GetPlayerId(), false)
	local rnd = 0
	for i=1,10,1 do
		rnd = GenerateRandomIntInRange(1, #prizes+1)
		text = "" .. prizes[rnd]
		Wait(200)
	end
	for i=1,5,1 do
		rnd = GenerateRandomIntInRange(1, #prizes+1)
		text = "" .. prizes[rnd]
		Wait(500)
	end
	for i=1,3,1 do
		rnd = GenerateRandomIntInRange(1, #prizes+1)
		text = "" .. prizes[rnd]
		Wait(1000)
	end
	if(rnd ~= 7) then
		if(rnd == 1) then
			money = money + 10000
			SaveStats()
		elseif(rnd == 2) then
			money = money + 20000
			SaveStats()
		elseif(rnd == 3) then
			money = money + 30000
			SaveStats()
		elseif(rnd == 4) then
			experience = experience + 1000
			SaveStats()
		elseif(rnd == 5) then
			experience = experience + 2000
			SaveStats()
		elseif(rnd == 6) then
			experience = experience + 3000
			SaveStats()
		end
		text = "~y~" .. prizes[rnd]
	else
		rnd = GenerateRandomIntInRange(1, #carinfo+1)
		cars[rnd] = 1
		SaveCars()
		text = "~y~" .. carinfo[rnd][1]
	end
	Wait(5000)
	text = ""
	SetPlayerControl(GetPlayerId(), true)
end

CreateThread(function()
	while true do
		Wait(0)
		if(text ~= "") then
			SetTextScale(0.300000,  0.5000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			SetTextCentre(1)
			DisplayTextWithLiteralString(0.5, 0.35, "STRING", "Your prize is:")
		
			DrawRect(0.5, 0.5, 0.4, 0.2, 0, 0, 0, 100)
			SetTextScale(0.300000,  0.5000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			SetTextCentre(1)
			SetTextFont(6)
			DisplayTextWithLiteralString(0.5, 0.48, "STRING", "" .. text)
		end
	end
end)

local text1 = ""
local text2 = ""
local text3 = ""
local textf = ""
StartSlotMachine = function()
	SetPlayerControl(GetPlayerId(), false)
	local rnd1 = 0
	local rnd2 = 0
	local rnd3 = 0
	for i=1,10,1 do
		rnd1 = GenerateRandomIntInRange(1, 10)
		rnd2 = GenerateRandomIntInRange(1, 10)
		rnd3 = GenerateRandomIntInRange(1, 10)
		text1 = "" .. rnd1
		text2 = "" .. rnd2
		text3 = "" .. rnd3
		Wait(500)
	end
	if(rnd1==rnd2 and rnd2==rnd3) then
		money = money + 50000
		SaveStats()
		textf = "~y~Jackpot! You won 50000$"
	elseif(rnd1==rnd2 or rnd1==rnd3 or rnd2==rnd3) then
		money = money + 5000
		SaveStats()
		textf = "~g~You won 5000$"
	else
		textf = "~r~Try again"
	end
	Wait(5000)
	text1 = ""
	text2 = ""
	text3 = ""
	textf = ""
	SetPlayerControl(GetPlayerId(), true)
end

CreateThread(function()
	while true do
		Wait(0)
		if(textf ~= "") then
			SetTextScale(0.300000,  0.5000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			SetTextCentre(1)
			DisplayTextWithLiteralString(0.5, 0.35, "STRING", "" .. textf)
		end
		if(text1 ~= "") then
			DrawRect(0.4, 0.5, 0.08, 0.2, 0, 0, 0, 100)
			SetTextScale(0.300000,  0.5000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			SetTextCentre(1)
			SetTextFont(6)
			SetTextWrap(0.0, 0.4)
			DisplayTextWithLiteralString(0.4, 0.48, "STRING", "" .. text1)
		end
		if(text2 ~= "") then
			DrawRect(0.5, 0.5, 0.08, 0.2, 0, 0, 0, 100)
			SetTextScale(0.300000,  0.5000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			SetTextCentre(1)
			SetTextFont(6)
			SetTextWrap(0.0, 0.5)
			DisplayTextWithLiteralString(0.5, 0.48, "STRING", "" .. text2)
		end
		if(text3 ~= "") then
			DrawRect(0.6, 0.5, 0.08, 0.2, 0, 0, 0, 100)
			SetTextScale(0.300000,  0.5000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			SetTextCentre(1)
			SetTextFont(6)
			SetTextWrap(0.0, 0.6)
			DisplayTextWithLiteralString(0.6, 0.48, "STRING", "" .. text3)
		end
	end
end)