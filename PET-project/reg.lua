loginform = 1
local registered = 0
local password = -1
local passwordentered = 0
local attempt = 1
local display = 1

local chatstring = ""
local keys = {
{2, "1", "!"}, {3, "2", "@"}, {4, "3", "#"}, {5, "4", "$"}, {6, "5", "%"}, {7, "6", "^"}, {8, "7", "&"}, {9, "8", "*"}, {10, "9", "("}, {11, "0", ")"}, {12, "-", "_"}, {13, "=", "+"},
{16, "q", "Q"}, {17, "w", "W"}, {18, "e", "E"}, {19, "r", "R"}, {20, "t", "T"}, {21, "y", "Y"}, {22, "u", "U"}, {23, "i", "I"}, {24, "o", "O"}, {25, "p", "P"}, {26, "[", "{"}, {27, "]", "}"},
{30, "a", "A"}, {31, "s", "S"}, {32, "d", "D"}, {33, "f", "F"}, {34, "g", "G"}, {35, "h", "H"}, {36, "j", "J"}, {37, "k", "K"}, {38, "l", "L"}, {39, ";", ":"}, {40, "'", "\""}, {41, "`", ""},
{44, "z", "Z"}, {45, "x", "X"}, {46, "c", "C"}, {47, "v", "V"}, {48, "b", "B"}, {49, "n", "N"}, {50, "m", "M"}, {51, ",", "<"}, {52, ".", ">"}, {53, "/", "?"}, {55, "*", ""}, {57, " ", ""}
}

RegisterNetEvent('updPassword')
AddEventHandler('updPassword', function(ppassword)
	password = ppassword
end)

local checkresult = 0
RegisterNetEvent('proceedPassword')
AddEventHandler('proceedPassword', function(state)
	checkresult = state
end)

CreateThread(function()
	while true do
		Wait(0)
		if(loginform == 1) then
			if(not DoesCamExist(camera)) then
				SetCamActive(GetGameCam(), false)
				camera = CreateCam(14, _i)
				SetCamPropagate(camera, 1)
				SetCamActive(camera, true)
				ActivateScriptedCams(1, 1)
				SetCamPos(camera, -1197.72241, 696.63141, 528.03577)
				PointCamAtCoord(camera, -236.3605, 45.90164, 156.19728)
			end
			
			while password==-1 do
				Wait(0)
			end
			cursor = 1
			SetPlayerControl(GetPlayerId(), false)
			--SetCamActive(GetGameCam(), false)
			FreezeCharPosition(GetPlayerChar(GetPlayerId()), true)
			SetCharVisible(GetPlayerChar(GetPlayerId()), false)
			SetCharInvincible(GetPlayerChar(GetPlayerId()), false)
			
			SetTextScale(0.500000,  1.0000000)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextFont(3)
			SetTextCentre(1)
			DisplayTextWithLiteralString(0.5, 0.15, "STRING", "Welcome to")
			SetTextScale(0.500000,  1.0000000)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextFont(3)
			SetTextCentre(1)
			DisplayTextWithLiteralString(0.5, 0.2, "STRING", "IV: ~r~Online")
			
			DrawRectLeftTopCenter(0.3, 0.5, 0.4, 0.05, 0, 0, 0, 100)
			for i=1,#keys,1 do
				if(IsGameKeyboardKeyJustPressed(keys[i][1])) then
					if(not IsGameKeyboardKeyPressed(42)) then
						chatstring = chatstring .. "" .. keys[i][2]
					else
						chatstring = chatstring .. "" .. keys[i][3]
					end
				end
			end
			if(IsGameKeyboardKeyJustPressed(14)) then
				chatstring = chatstring:sub(1, #chatstring - 1)
			end
			if(chatstring ~= "") then
				if(#chatstring <= 40) then
					if(display == 1) then
						SetTextScale(0.1500000,  0.3000000)
						SetTextEdge(1, 0, 0, 0, 255)
						--SetTextFont(6)
						--SetTextCentre(1)
						DisplayTextWithLiteralString(0.31, 0.515, "STRING", "" .. chatstring)
					else
						local hiddentext = ""
						for i=1,#chatstring,1 do
							hiddentext = hiddentext .. "*"
						end
						SetTextScale(0.1500000,  0.3000000)
						SetTextEdge(1, 0, 0, 0, 255)
						--SetTextFont(6)
						--SetTextCentre(1)
						DisplayTextWithLiteralString(0.31, 0.515, "STRING", "" .. hiddentext)
					end
				else
					chatstring = chatstring:sub(1, #chatstring - 1)
					TriggerEvent('chatMessage', '[Server]', {255, 0, 0}, 'Password cannot exceed 40 characters!')
				end
			elseif(password == 0) then
				SetTextScale(0.1500000,  0.3000000)
				SetTextEdge(1, 0, 0, 0, 255)
				--SetTextFont(6)
				--SetTextCentre(1)
				DisplayTextWithLiteralString(0.31, 0.515, "STRING", "Create a password")
			else
				SetTextScale(0.1500000,  0.3000000)
				SetTextEdge(1, 0, 0, 0, 255)
				--SetTextFont(6)
				--SetTextCentre(1)
				DisplayTextWithLiteralString(0.31, 0.515, "STRING", "Enter password")
			end
			------
			if(display == 1) then
				DrawRect(0.3+0.025/4, 0.56+0.05/4, 0.025/2, 0.05/2, 0, 0, 0, 100)
			else
				DrawRect(0.3+0.025/4, 0.56+0.05/4, 0.025/2, 0.05/2, 255, 255, 255, 255)
			end
			SetTextScale(0.1500000,  0.3000000)
			SetTextEdge(1, 0, 0, 0, 255)
			--SetTextFont(6)
			--SetTextCentre(1)
			DisplayTextWithLiteralString(0.32, 0.565, "STRING", "Hide password")
			if(IsCursorInArea(0.3+0.05, 0.56+0.05/4, 0.1, 0.05/2)) then
				DrawRect(0.3+0.025/4, 0.56+0.05/4, 0.025/2, 0.05/2, 255, 255, 255, 100)
				if(IsMouseButtonJustPressed(1)) then
					if(display == 0) then
						display = 1
					else
						display = 0
					end
				end
			end
			
			DrawRectLeftTopCenter(0.4, 0.7, 0.2, 0.1, 0, 0, 0, 100)
			SetTextScale(0.300000,  0.6000000)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextCentre(1)
			DisplayTextWithLiteralString(0.5, 0.73, "STRING", "Enter")
			if(IsCursorInAreaLeftTopCenter(0.4, 0.7, 0.2, 0.1)) then
				DrawRectLeftTopCenter(0.4, 0.7, 0.2, 0.1, 255, 255, 255, 255)
				--[[SetTextScale(0.300000,  0.6000000)
				--SetTextEdge(1, 0, 0, 0, 255)
				SetTextColour(0, 0, 0, 255)
				SetTextCentre(1)
				DisplayTextWithLiteralString(0.5, 0.73, "STRING", "Enter")]]
				if(IsMouseButtonJustPressed(1)) then
					if(password == 0) then
						if(chatstring ~= "") then
							TriggerServerEvent('savePassword', "" .. chatstring)
							TriggerEvent('chatMessage', '[Server]', {255, 255, 0}, 'You have successfully registered! Use this password in the future to enter this server.')
							
							loginform = 0
							cursor = 0
							SetPlayerControl(GetPlayerId(), true)
							SetCamActive(GetGameCam(), false)
							SetCharInvincible(GetPlayerChar(GetPlayerId()), false)
							FreezeCharPosition(GetPlayerChar(GetPlayerId()), false)
							SetCharVisible(GetPlayerChar(GetPlayerId()), true)
							--tutorial = 1
							
							SetCamActive(camera, false)
							SetCamActive(GetGameCam(), true)
							SetCamPropagate(camera, 0)
							SetCamPropagate(GetGameCam(), 1)
							ActivateScriptedCams(0, 0)
							DestroyCam(camera)
						else
							TriggerEvent('chatMessage', '[Server]', {255, 0, 0}, 'Create a password!')
						end
					else
						TriggerServerEvent('checkPassword', chatstring)
						Wait(1000)
						if(checkresult == 1) then
							local amount = 0
							local temphouses = {}
							for i=1,#houses,1 do
								if(houses[i] == 1) then
									temphouses[#temphouses+1] = i
									amount = amount + 1
								end
							end
							if(boats[7] == 1) then
								amount = amount + 1
							end
							if(org>0 or clan~="0") then
								amount = amount + 1
							end
							if(storage > 0) then
								amount = amount + 1
							end
							if(agency > 0) then
								amount = amount + 1
							end
							if(amount > 0) then
								if(amount == 1) then
									SetCharCoordinates(GetPlayerChar(GetPlayerId()), houseinfo[temphouses[1]][2][1], houseinfo[temphouses[1]][2][2], houseinfo[temphouses[1]][2][3])
									SetCharHeading(GetPlayerChar(GetPlayerId()), houseinfo[temphouses[1]][2][4])
								else
									::again::
									local tempitems = {}
									local tempstreets = {}
									for i=1,#temphouses,1 do
										local street = GetStreetAtCoord(houseinfo[temphouses[i]][2][1], houseinfo[temphouses[i]][2][2], houseinfo[temphouses[i]][2][3])
										tempstreets[#tempstreets+1] = street
										tempitems[#tempitems+1] = "Apt_#" .. temphouses[i] .. " (" .. street .. ")"
									end
									if(boats[7] == 1) then
										tempitems[#tempitems+1] = "Yacht"
									end
									if(org>0 or clan~="0") then
										tempitems[#tempitems+1] = "Organization"
									end
									if(storage > 0) then
										tempitems[#tempitems+1] = "Storage"
									end
									if(agency > 0) then
										tempitems[#tempitems+1] = "Agency"
									end
									DrawWindow("Select_spawnpoint", tempitems)
									while menuactive do
										Wait(0)
									end
									if(menuresult > 0) then
										for i=1,#temphouses,1 do
											if(tempitems[menuresult] == "Apt_#" .. temphouses[i] .. " (" .. tempstreets[i] .. ")") then
												SetCharCoordinates(GetPlayerChar(GetPlayerId()), houseinfo[temphouses[i]][2][1], houseinfo[temphouses[i]][2][2], houseinfo[temphouses[i]][2][3])
												SetCharHeading(GetPlayerChar(GetPlayerId()), houseinfo[temphouses[i]][2][4])
											end
										end
										if(tempitems[menuresult] == "Organization") then
											SetCharCoordinates(GetPlayerChar(GetPlayerId()), 126.44315, -668.15814, 14.77173)
											SetCharHeading(GetPlayerChar(GetPlayerId()), 176.78288269043)
										end
										if(tempitems[menuresult] == "Yacht") then
											DeleteCar(yacht)
											RemoveBlip(yachtblip)
											local coords = {
											{-529.63379, 2039.76245, -0.38107, 271.696228027344},
											{1944.99768, 1520.64111, -0.45675, 194.838821411133},
											{2067.3645, -553.62286, -0.17268, 105.141761779785},
											{-975.93256, -1028.28748, -0.14308, 64.8627395629883},
											{-2620.62476, -230.35472, -0.50019, 353.522369384766}
											}
											local cc = GetClosestCoordWithIndex(coords)
											yacht = SpawnCar(boatspecs[7][2], coords[cc][1], coords[cc][2], coords[cc][3]-8, coords[cc][4])
											local cx,cy,cz = GetCarCoordinates(yacht)
											local ch = GetCarHeading(yacht)
											SetCharCoordinates(GetPlayerChar(GetPlayerId()), cx, cy, cz+10)
											SetCharHeading(GetPlayerChar(GetPlayerId()), ch)
										end
										if(tempitems[menuresult] == "Storage") then
											SetCharCoordinates(GetPlayerChar(GetPlayerId()), 695.12683, 1464.05505, 14.85285)
											SetCharHeading(GetPlayerChar(GetPlayerId()), 177.584030151367)
										end
										if(tempitems[menuresult] == "Agency") then
											SetCharCoordinates(GetPlayerChar(GetPlayerId()), -80.0815, 51.95913, 19.62856)
											SetCharHeading(GetPlayerChar(GetPlayerId()), 175.404266357422)
										end
									else
										TriggerEvent('chatMessage', '[Spawn]', {255, 255, 0}, 'You must select spawnpoint!')
										goto again
									end
								end
							end
							
							TriggerEvent('chatMessage', '[Server]', {255, 255, 0}, 'You have entered the server! Good game!')
							loginform = 0
							cursor = 0
							SetPlayerControl(GetPlayerId(), true)
							SetCharInvincible(GetPlayerChar(GetPlayerId()), false)
							FreezeCharPosition(GetPlayerChar(GetPlayerId()), false)
							SetCharVisible(GetPlayerChar(GetPlayerId()), true)
							
							SetCamActive(camera, false)
							SetCamActive(GetGameCam(), true)
							SetCamPropagate(camera, 0)
							SetCamPropagate(GetGameCam(), 1)
							ActivateScriptedCams(0, 0)
							DestroyCam(camera)
						else
							chatstring = ""
							TriggerEvent('chatMessage', '[Server]', {255, 0, 0}, 'Wrong password!')
						end
					end
				end
			end
		end
	end
end)