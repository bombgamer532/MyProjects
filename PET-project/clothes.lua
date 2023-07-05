bodyparts2 = {
0,
1,
2,
7,
10,
4,
3
}
local skinnames = {
2274661858, --"M_Y_MULTIPLAYER",
3653091386, --"F_Y_MULTIPLAYER",

2813043386, --"m_y_runner", --"ig_johnnybiker",
2592931069, --"f_y_shopper_05", --"ig_katemc",

357919731, --"m_y_shopasst_01", --"ig_luis",
761763258 --"f_y_villbo_01" --"ig_mallorie"
}

currparts = {}
for i=1,17,1 do
	if(i == 1) then
		currparts[i] = skinnames[1]
	elseif(i>=2 and i<=15) then
		currparts[i] = 0
	else
		currparts[i] = -1
	end
end

RegisterNetEvent('updParts')
AddEventHandler('updParts', function(data)
	for i=1,#currparts,1 do
		if(data[i] ~= nil) then
			currparts[i] = tonumber(data[i])
		end
	end
end)

SaveParts = function()
	local data = {}
	for i=1,#currparts,1 do
		data[i] = currparts[i]
	end
	TriggerServerEvent('saveParts', data)
end

SetDefaultSkin = function()
	local ap,hp = 200,0
	for i=1,9,1 do
		if(i == 1) then
			local model = currparts[1]
			RequestModel(model)
			while not HasModelLoaded(model) do
				Wait(0)
				RequestModel(model)
			end
			hp = GetCharHealth(GetPlayerChar(GetPlayerId()))
			ap = GetCharArmour(GetPlayerChar(GetPlayerId()))
			ChangePlayerModel(GetPlayerId(), model)
			if(IsInteriorScene() and GetKeyForViewportInRoom(GetGameViewportId())~=0) then
				SetRoomForCharByKey(GetPlayerChar(GetPlayerId()), GetKeyForViewportInRoom(GetGameViewportId()))
			end
		elseif(i>=2 and i<=8) then
			SetCharComponentVariation(GetPlayerChar(GetPlayerId()), bodyparts2[i-1], currparts[i], currparts[i+7])
		else
			SetCharPropIndex(GetPlayerChar(GetPlayerId()), 0, currparts[16])
			SetCharPropIndex(GetPlayerChar(GetPlayerId()), 1, currparts[17])
		end
	end
	for i=1,8,1 do
		GiveWeaponToChar(GetPlayerChar(GetPlayerId()), weps[i][1], weps[i][2], 1)
	end
	SetCharHealth(GetPlayerChar(GetPlayerId()), hp)
	AddArmourToChar(GetPlayerChar(GetPlayerId()), ap)
end

IsDefaultSkin = function()
	if(IsCharModel(GetPlayerChar(GetPlayerId()), currparts[1])) then
		return true
	else
		return false
	end
end

local skinshopcoords = {
{-284.48291, 1364.14771, 25.63738, 222.996063232422},
{22.29914, 798.54492, 14.7668, 0.411204695701599},
{10.81859, -670.22687, 14.86652, 359.982604980469},
{880.54913, -446.63824, 15.85833, 311.022064208984}
}
local skinblip = {}

CreateThread(function()
	while true do
		Wait(0)
		BlockCharAmbientAnims(GetPlayerChar(GetPlayerId()), true)
		CancelCurrentlyPlayingAmbientSpeech(GetPlayerChar(GetPlayerId()))
		if(IsCharModel(GetPlayerChar(GetPlayerId()), skinnames[1]) or 
		IsCharModel(GetPlayerChar(GetPlayerId()), skinnames[3]) or 
		IsCharModel(GetPlayerChar(GetPlayerId()), skinnames[5])) then
			RequestAnims("move_m@multiplyr")
			while not HaveAnimsLoaded("move_m@multiplyr") do
				Wait(0)
			end
			SetAnimGroupForChar(GetPlayerChar(-1), "move_m@multiplyr")
		else
			RequestAnims("move_f@multiplyr")
			while not HaveAnimsLoaded("move_f@multiplyr") do
				Wait(0)
			end
			SetAnimGroupForChar(GetPlayerChar(-1), "move_f@multiplyr")
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		for i=1,#skinshopcoords,1 do
			if(not DoesBlipExist(skinblip[i])) then
				skinblip[i] = AddBlipForCoord(skinshopcoords[i][1], skinshopcoords[i][2], skinshopcoords[i][3], _i)
				ChangeBlipSprite(skinblip[i], 50)
				ChangeBlipScale(skinblip[i], 0.7)
				ChangeBlipNameFromAscii(skinblip[i], "Clothes shop")
				SetBlipAsShortRange(skinblip[i], true)
			end
			--DrawTextAtCoord(-766.86694, 203.2243, 6.3086, "Clothes_shop", 20)
			DrawCheckpointWithDist(skinshopcoords[i][1], skinshopcoords[i][2], skinshopcoords[i][3]-1, 1.1, 255, 255, 0, 100)
			if(IsPlayerNearCoords(skinshopcoords[i][1], skinshopcoords[i][2], skinshopcoords[i][3], 1)) then
				PrintText("Press ~y~E ~w~to ~y~open clothes shop menu", 1)
				if(IsGameKeyboardKeyJustPressed(18)) then
					SetCharCoordinates(GetPlayerChar(GetPlayerId()), skinshopcoords[i][1], skinshopcoords[i][2], skinshopcoords[i][3]-1)
					SetCharHeading(GetPlayerChar(GetPlayerId()), skinshopcoords[i][4])
					SetPlayerControl(GetPlayerId(), false)
					::main::
					local tempitems = {}
					tempitems[#tempitems+1] = "Gender"
					tempitems[#tempitems+1] = "Head"
					tempitems[#tempitems+1] = "Torso"
					tempitems[#tempitems+1] = "Legs"
					tempitems[#tempitems+1] = "Hair"
					tempitems[#tempitems+1] = "Face"
					tempitems[#tempitems+1] = "Hands"
					tempitems[#tempitems+1] = "Misc"
					tempitems[#tempitems+1] = "Hat"
					tempitems[#tempitems+1] = "Glasses"
					local amount = 0
					for j=1,#currparts,1 do
						if(j == 1) then
							if(not IsCharModel(GetPlayerChar(GetPlayerId()), currparts[j])) then
								amount = amount + 1
							end
						elseif(j>=2 and j<=8) then
							if(currparts[j] ~= GetCharDrawableVariation(GetPlayerChar(GetPlayerId()), bodyparts2[j-1])) then
								amount = amount + 1
							end
						elseif(j>=9 and j<=15) then
							if(currparts[j] ~= GetCharTextureVariation(GetPlayerChar(GetPlayerId()), bodyparts2[j-8])) then
								amount = amount + 1
							end
						elseif(j == 16) then
							if(currparts[j] ~= GetCharPropIndex(GetPlayerChar(GetPlayerId()), 0, _i)) then
								amount = amount + 1
							end
						elseif(j == 17) then
							if(currparts[j] ~= GetCharPropIndex(GetPlayerChar(GetPlayerId()), 1, _i)) then
								amount = amount + 1
							end
						end
					end
					local finalprice = 1000*amount
					tempitems[#tempitems+1] = "Purchase ~g~(" .. finalprice .. "$)"
					DrawWindow("Clothes_shop", tempitems)
					while menuactive do
						Wait(0)
						SetPlayerControl(GetPlayerId(), false)
						if(IsMouseButtonPressed(1)) then
							SetCamActive(GetGameCam(), true)
						else
							SetCamActive(GetGameCam(), false)
						end
					end
					if(menuresult > 0) then
						if(tempitems[menuresult] == "Gender") then
							::gender::
							DrawWindow("Gender", {"Male 1", "Female 1", "Male 2", "Female 2", "Male 3", "Female 3"})
							while menuactive do
								Wait(0)
								SetPlayerControl(GetPlayerId(), false)
								if(IsMouseButtonPressed(1)) then
									SetCamActive(GetGameCam(), true)
								else
									SetCamActive(GetGameCam(), false)
								end
							end
							if(menuresult > 0) then
								local model = skinnames[menuresult]
								RequestModel(model)
								while not HasModelLoaded(model) do
									Wait(0)
									RequestModel(model)
								end
								ChangePlayerModel(GetPlayerId(), model)
								for j=2,8,1 do
									SetCharComponentVariation(GetPlayerChar(GetPlayerId()), bodyparts2[j-1], 0, GetCharTextureVariation(GetPlayerChar(GetPlayerId()), bodyparts2[j-1]))
								end
								ClearCharProp(GetPlayerChar(GetPlayerId()), 0)
								ClearCharProp(GetPlayerChar(GetPlayerId()), 1)
								SetCharCoordinates(GetPlayerChar(GetPlayerId()), skinshopcoords[i][1], skinshopcoords[i][2], skinshopcoords[i][3]-1)
								SetCharHeading(GetPlayerChar(GetPlayerId()), skinshopcoords[i][4])
								SetPlayerControl(GetPlayerId(), false)
								SetRoomForCharByKey(GetPlayerChar(GetPlayerId()), GetKeyForViewportInRoom(GetGameViewportId()))
								for j=1,8,1 do
									GiveWeaponToChar(GetPlayerChar(GetPlayerId()), weps[j][1], weps[j][2], 1)
								end
								goto gender
							else
								goto main
							end
						elseif(menuresult>=2 and menuresult<=8) then
							local comp = menuresult-1
							local tempcomp = tempitems[menuresult]
							::comps::
							DrawWindow("" .. tempcomp, {"Model", "Variation"})
							while menuactive do
								Wait(0)
								SetPlayerControl(GetPlayerId(), false)
								if(IsMouseButtonPressed(1)) then
									SetCamActive(GetGameCam(), true)
								else
									SetCamActive(GetGameCam(), false)
								end
							end
							if(menuresult > 0) then
								if(menuresult == 1) then
									::comps2::
									local tempitems = {}
									for j=0,GetNumberOfCharDrawableVariations(GetPlayerChar(GetPlayerId()), bodyparts2[comp])-1,1 do
										tempitems[#tempitems+1] = "" .. j
									end
									DrawWindow("" .. tempcomp .. "_model", tempitems)
									while menuactive do
										Wait(0)
										SetPlayerControl(GetPlayerId(), false)
										if(IsMouseButtonPressed(1)) then
											SetCamActive(GetGameCam(), true)
										else
											SetCamActive(GetGameCam(), false)
										end
									end
									if(menuresult > 0) then
										local tempvar = GetCharTextureVariation(GetPlayerChar(GetPlayerId()), bodyparts2[comp])
										SetCharComponentVariation(GetPlayerChar(GetPlayerId()), bodyparts2[comp], menuresult-1, tempvar)
										goto comps2
									else
										goto comps
									end
								elseif(menuresult == 2) then
									::comps3::
									local tempitems = {}
									for j=0,GetNumberOfCharTextureVariations(GetPlayerChar(GetPlayerId()), bodyparts2[comp], GetCharDrawableVariation(GetPlayerChar(GetPlayerId()), bodyparts2[comp]))-1,1 do
										tempitems[#tempitems+1] = "" .. j
									end
									DrawWindow("" .. tempcomp .. "_variation", tempitems)
									while menuactive do
										Wait(0)
										SetPlayerControl(GetPlayerId(), false)
										if(IsMouseButtonPressed(1)) then
											SetCamActive(GetGameCam(), true)
										else
											SetCamActive(GetGameCam(), false)
										end
									end
									if(menuresult > 0) then
										local tempvar = GetCharDrawableVariation(GetPlayerChar(GetPlayerId()), bodyparts2[comp])
										SetCharComponentVariation(GetPlayerChar(GetPlayerId()), bodyparts2[comp], tempvar, menuresult-1)
										goto comps3
									else
										goto comps
									end
								end
							else
								goto main
							end
						elseif(menuresult == 9) then
							::hat::
							tempitems = {}
							for j=0,7,1 do
								tempitems[#tempitems+1] = "" .. j
							end
							tempitems[#tempitems+1] = "No hat"
							DrawWindow("Hat", tempitems)
							while menuactive do
								Wait(0)
								SetPlayerControl(GetPlayerId(), false)
								if(IsMouseButtonPressed(1)) then
									SetCamActive(GetGameCam(), true)
								else
									SetCamActive(GetGameCam(), false)
								end
							end
							if(menuresult > 0) then
								if(menuresult ~= #tempitems) then
									ClearCharProp(GetPlayerChar(GetPlayerId()), 0)
									SetCharPropIndex(GetPlayerChar(GetPlayerId()), 0, menuresult-1)
								else
									ClearCharProp(GetPlayerChar(GetPlayerId()), 0)
								end
								goto hat
							else
								goto main
							end
						elseif(menuresult == 10) then
							::glasses::
							tempitems = {}
							for j=0,7,1 do
								tempitems[#tempitems+1] = "" .. j
							end
							tempitems[#tempitems+1] = "No glasses"
							DrawWindow("Glasses", tempitems)
							while menuactive do
								Wait(0)
								SetPlayerControl(GetPlayerId(), false)
								if(IsMouseButtonPressed(1)) then
									SetCamActive(GetGameCam(), true)
								else
									SetCamActive(GetGameCam(), false)
								end
							end
							if(menuresult > 0) then
								if(menuresult ~= #tempitems) then
									ClearCharProp(GetPlayerChar(GetPlayerId()), 1)
									SetCharPropIndex(GetPlayerChar(GetPlayerId()), 1, menuresult-1)
								else
									ClearCharProp(GetPlayerChar(GetPlayerId()), 1)
								end
								goto glasses
							else
								goto main
							end
						elseif(tempitems[menuresult] == "Purchase ~g~(" .. finalprice .. "$)") then
							if(money >= finalprice) then
								money = money - finalprice
								SaveStats()
								for j=1,#currparts,1 do
									if(j == 1) then
										currparts[j] = GetCharModel(GetPlayerChar(GetPlayerId()), _i)
									elseif(j>=2 and j<=8) then
										currparts[j] = GetCharDrawableVariation(GetPlayerChar(GetPlayerId()), bodyparts2[j-1])
									elseif(j>=9 and j<=15) then
										currparts[j] = GetCharTextureVariation(GetPlayerChar(GetPlayerId()), bodyparts2[j-8])
									else
										currparts[16] = GetCharPropIndex(GetPlayerChar(GetPlayerId()), 0)
										currparts[17] = GetCharPropIndex(GetPlayerChar(GetPlayerId()), 1)
									end
								end
								SaveParts()
								TriggerEvent('chatMessage', '[Clothes shop]', {0, 255, 0}, 'Purchase is successful!')
								goto main
							else
								TriggerEvent('chatMessage', '[Clothes shop]', {255, 0, 0}, 'You do not have enough money!')
								goto main
							end
						end
					else
						SetCamActive(GetGameCam(), true)
						SetPlayerControl(GetPlayerId(), true)
						SetDefaultSkin()
					end
				end
			end
		end
	end
end)