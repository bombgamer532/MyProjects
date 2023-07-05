inv = {}
for i=1,10,1 do
	inv[i] = 0
end

RegisterNetEvent('updInv')
AddEventHandler('updInv', function(data)
	for i=1,#inv,1 do
		if(data[i] == nil) then
			data[i] = 0
		end
		inv[i] = tonumber(data[i])
	end
end)

SaveInv = function()
	local data = {}
	for i=1,#inv,1 do
		data[i] = inv[i]
	end
	TriggerServerEvent('saveInv', data)
end

local anims = {
{"Hands up", "armsup_loop", "cop", 1},
{"Sit down", "sit_down_front_b", "amb_sit_chair_m", 2},
{"Lie", "idle_a", "amb@wasted_b", 1},
{"Wave", "wave", "gestures@mp_male", 0},
{"Middle finger", "finger", "gestures@mp_male", 0},
{"Smoke", "stand_smoke", "amb@smoking", 1},
{"Dance 1", "loop_a", "amb@dance_femidl_a", 1},
{"Dance 2", "loop_b", "amb@dance_femidl_b", 1},
{"Dance 3", "loop_c", "amb@dance_femidl_c", 1},
{"Dance 4", "loop_a", "amb@dance_maleidl_a", 1},
{"Dance 5", "loop_b", "amb@dance_maleidl_b", 1},
{"Dance 6", "loop_c", "amb@dance_maleidl_c", 1},
{"Dance 7", "loop_d", "amb@dance_maleidl_d", 1},
{"Dance 8", "dance_m_default", "amb@default", 1},
{"Dance 9", "dance_f_default", "amb@default", 1},
{"Piss", "piss_loop", "missttkill", 1},
{"Crossarms", "lookaround_a", "amb@bouncer_idles_b", 1},
{"Lean", "lean_idle_a", "amb@lean_idles", 1}
}
--[[CreateThread(function()
	while true do
		Wait(0)
		if(GetPlayerName(GetPlayerId()) == "vlados") then
			if(IsGameKeyboardKeyJustPressed(20)) then
				local anims = {
				{"Jump Out", "jump_out_ds", "PARACHUTE", 3},
				{"Free Fall", "Free_Fall", "PARACHUTE", 3},
				{"Hang Idle", "Hang_Idle", "PARACHUTE", 3}
				}
				local tempitems = {}
				for i=1,#anims,1 do
					tempitems[i] = anims[i][1]
				end
				DrawWindow("Animations", tempitems)
				while menuactive do
					Wait(0)
				end
				if(menuresult > 0) then
					--ClearCharTasksImmediately(GetPlayerChar(GetPlayerId()))
					RequestAnims(anims[menuresult][3])
					while not HaveAnimsLoaded(anims[menuresult][3]) do
						Wait(0)
					end
					TaskPlayAnimWithFlags(GetPlayerChar(GetPlayerId()), anims[menuresult][2], anims[menuresult][3], 8.0, 3000000, 0)
				end
			end
		end
	end
end)]]

local speccooldown = {}
for i=1,2,1 do
	speccooldown[i] = 0
end
CreateThread(function()
	while true do
		Wait(1000)
		for i=1,#speccooldown,1 do
			if(speccooldown[i] > 0) then
				speccooldown[i] = speccooldown[i] - 1
			end
		end
	end
end)

coop = {}
for i=0,31,1 do
	coop[i] = -1
end
CreateThread(function()
	while true do
		Wait(0)
		if(loginform == 0) then
			if(IsNetworkPlayerActive(GetPlayerId())) then
				if(not IsPlayerDead(GetPlayerId())) then
					for i=0,31,1 do
						if(not IsNetworkPlayerActive(i)) then
							coop[i] = -1
						end
					end
					if(coop[ConvertIntToPlayerindex(GetPlayerId())] ~= -1) then
						if(coop[coop[ConvertIntToPlayerindex(GetPlayerId())]] ~= -1) then
							coop[ConvertIntToPlayerindex(GetPlayerId())] = -1
							TriggerServerEvent('updCoop', ConvertIntToPlayerindex(GetPlayerId()), -1)
						end
						if(not IsNetworkPlayerActive(coop[ConvertIntToPlayerindex(GetPlayerId())])) then
							coop[ConvertIntToPlayerindex(GetPlayerId())] = -1
							TriggerServerEvent('updCoop', ConvertIntToPlayerindex(GetPlayerId()), -1)
						end
					end
				end
			end
		end
	end
end)
RegisterNetEvent('updCoop')
AddEventHandler('updCoop', function(id, state)
	coop[id] = state
end)
RegisterNetEvent('invitePlayerToCoop')
AddEventHandler('invitePlayerToCoop', function(id, owner)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		if(level >= 10) then
			DrawWindow("You_have_been_invited_to_co-op", {"Accept invite to " .. GetPlayerName(owner, _s) .. "'s co-op team"})
			while menuactive do
				Wait(0)
			end
			if(menuresult > 0) then
				coop[id] = owner
				TriggerServerEvent('updCoop', id, owner)
				TriggerServerEvent('sendMessageToPlayer', "" .. GetPlayerName(owner, _s), "[Co-op]", "" .. GetPlayerName(id, _s) .. " has accepted your invitation!")
			else
				TriggerServerEvent('sendMessageToPlayer', "" .. GetPlayerName(owner, _s), "[Co-op]", "" .. GetPlayerName(id, _s) .. " has declined your invitation.")
			end
		else
			TriggerServerEvent('sendMessageToPlayer', "" .. GetPlayerName(owner, _s), "[Co-op]", "" .. GetPlayerName(id, _s) .. " must reach level 10 to be invited.")
		end
	end
end)
RegisterNetEvent('removePlayerFromCoop')
AddEventHandler('removePlayerFromCoop', function(id, owner)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		coop[id] = -1
		TriggerServerEvent('updCoop', id, -1)
		TriggerEvent('chatMessage', '[Co-op]', {255, 255, 0}, "You have been removed from " .. GetPlayerName(owner) .. "'s co-op team.")
		TriggerServerEvent('sendMessageToPlayer', "" .. GetPlayerName(owner, _s), "[Co-op]", "Player has been removed from your co-op team.")
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(IsGameKeyboardKeyJustPressed(23)) then
			if(IsPlayerControlOn(GetPlayerId())) then
				::main::
				local tempitems = {}
				tempitems[#tempitems+1] = "Items"
				--tempitems[#tempitems+1] = "Snacks"
				--tempitems[#tempitems+1] = "Ammunition"
				tempitems[#tempitems+1] = "Specials"
				--tempitems[#tempitems+1] = "Car delivery"
				tempitems[#tempitems+1] = "Drugs inventory"
				tempitems[#tempitems+1] = "Animations"
				--tempitems[#tempitems+1] = "Send money"
				--tempitems[#tempitems+1] = "Tutorial"
				--tempitems[#tempitems+1] = "Collect daily bonus"
				tempitems[#tempitems+1] = "Give weapon"
				tempitems[#tempitems+1] = "Co-op"
				tempitems[#tempitems+1] = "Daily objectives"
				tempitems[#tempitems+1] = "Help"
				tempitems[#tempitems+1] = "Outrun"
				tempitems[#tempitems+1] = "Impromptu race"
				tempitems[#tempitems+1] = "Set nickname color"
				tempitems[#tempitems+1] = "Enable/disable speedometer"
				if(gamemode > 0) then
					tempitems[#tempitems+1] = "Leave event"
				end
				local armid = nil
				if(not IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
					for i=0,31,1 do
						if(IsNetworkPlayerActive(i)) then
							if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
								if(not IsPlayerDead(i)) then
									if(not IsCharInAnyCar(GetPlayerChar(i))) then
										armid = i
										tempitems[#tempitems+1] = "Do armwrestling with " .. GetPlayerName(armid)
										break
									end
								end
							end
						end
					end
				end
				local ped = GetPlayerChar(GetPlayerId())
				local veh = GetCarCharIsUsing(ped)
				local ped2 = nil
				if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
					if(GetMaximumNumberOfPassengers(veh) > 0) then
						local blacklist = {
						"akuma",
						"angel",
						"bati",
						"bati2",
						"daemon",
						"diabolus",
						"double",
						"double2",
						"faggio",
						"faggio2",
						"bobber",
						"hakuchou",
						"hakuchou2",
						"hellfury",
						"hexer",
						"lycan",
						"nightblade",
						"nrg900",
						"pcj",
						"revenant",
						"sanchez",
						"vader",
						"wayfarer",
						"wolfsbane",
						"zombieb"
						}
						local checker = 0
						for i=1,#blacklist,1 do
							if(IsCarModel(veh, GetHashKey(blacklist[i]))) then
								checker = 1
							end
						end
						if(checker == 0) then
							if(GetDriverOfCar(veh) == ped) then
								if(not IsCarPassengerSeatFree(veh, 0)) then
									if(not IsCharDead(GetCharInCarPassengerSeat(veh, 0))) then
										ped2 = GetCharInCarPassengerSeat(veh, 0)
										if(IsThisPedAPlayer(ped2)) then
											tempitems[#tempitems+1] = "Do stuff with " .. GetPlayerName(GetPlayerIdForThisPed(ped2))
										end
									end
								end
							elseif(GetCharInCarPassengerSeat(veh, 0) == ped) then
								if(not IsCharDead(GetDriverOfCar(veh))) then
									ped2 = GetDriverOfCar(veh)
									if(IsThisPedAPlayer(ped2)) then
										tempitems[#tempitems+1] = "Do stuff with " .. GetPlayerName(GetPlayerIdForThisPed(ped2))
									end
								end
							elseif(GetCharInCarPassengerSeat(veh, 1) == ped) then
								if(not IsCarPassengerSeatFree(veh, 2)) then
									if(not IsCharDead(GetCharInCarPassengerSeat(veh, 2))) then
										ped2 = GetCharInCarPassengerSeat(veh, 2)
										if(IsThisPedAPlayer(ped2)) then
											tempitems[#tempitems+1] = "Do stuff with " .. GetPlayerName(GetPlayerIdForThisPed(ped2))
										end
									end
								end
							elseif(GetCharInCarPassengerSeat(veh, 2) == ped) then
								if(not IsCarPassengerSeatFree(veh, 1)) then
									if(not IsCharDead(GetCharInCarPassengerSeat(veh, 1))) then
										ped2 = GetCharInCarPassengerSeat(veh, 1)
										if(IsThisPedAPlayer(ped2)) then
											tempitems[#tempitems+1] = "Do stuff with " .. GetPlayerName(GetPlayerIdForThisPed(ped2))
										end
									end
								end
							end
						end
					end
				end
				DrawWindow("" .. GetStringWithoutSpaces(GetPlayerName(GetPlayerId(), _s)), tempitems)
				while menuactive do
					Wait(0)
					SetPlayerControl(GetPlayerId(), true)
					SetCamBehindPed(GetPlayerChar(-1))
					--SetGameCameraControlsActive(false)
				end
				if(menuresult > 0) then
					if(tempitems[menuresult] == "Items") then
						::items::
						local tempitems = {}
						tempitems[#tempitems+1] = "Snacks"
						tempitems[#tempitems+1] = "Ammunition"
						tempitems[#tempitems+1] = "Repair kit ~y~(" .. inv[7] .. ")"
						DrawWindow("Items", tempitems)
						while menuactive do
							Wait(0)
							SetPlayerControl(GetPlayerId(), true)
							SetCamBehindPed(GetPlayerChar(-1))
							--SetGameCameraControlsActive(false)
						end
						if(menuresult > 0) then
							if(tempitems[menuresult] == "Snacks") then
								::snacks::
								local tempitems = {}
								tempitems[#tempitems+1] = "Cola ~y~(" .. inv[1] .. ")"
								tempitems[#tempitems+1] = "Energy bar ~y~(" .. inv[2] .. ")"
								tempitems[#tempitems+1] = "Chocolate ~y~(" .. inv[3] .. ")"
								DrawWindow("Snacks", tempitems)
								while menuactive do
									Wait(0)
									SetPlayerControl(GetPlayerId(), true)
									SetCamBehindPed(GetPlayerChar(-1))
									--SetGameCameraControlsActive(false)
								end
								if(menuresult > 0) then
									if(tempitems[menuresult] == "Cola ~y~(" .. inv[1] .. ")") then
										if(inv[1] > 0) then
											inv[1] = inv[1] - 1
											SaveInv()
											SetCharHealth(GetPlayerChar(GetPlayerId()), GetCharHealth(GetPlayerChar(GetPlayerId()), _i)+10)
										end
									elseif(tempitems[menuresult] == "Energy bar ~y~(" .. inv[2] .. ")") then
										if(inv[2] > 0) then
											inv[2] = inv[2] - 1
											SaveInv()
											SetCharHealth(GetPlayerChar(GetPlayerId()), GetCharHealth(GetPlayerChar(GetPlayerId()), _i)+20)
										end
									elseif(tempitems[menuresult] == "Chocolate ~y~(" .. inv[3] .. ")") then
										if(inv[3] > 0) then
											inv[3] = inv[3] - 1
											SaveInv()
											SetCharHealth(GetPlayerChar(GetPlayerId()), GetCharHealth(GetPlayerChar(GetPlayerId()), _i)+30)
										end
									end
									goto snacks
								else
									goto items
								end
							elseif(tempitems[menuresult] == "Ammunition") then
								::ammo::
								local tempitems = {}
								tempitems[#tempitems+1] = "Light armor ~y~(" .. inv[4] .. ")"
								tempitems[#tempitems+1] = "Heavy armor ~y~(" .. inv[5] .. ")"
								tempitems[#tempitems+1] = "Ammo box ~y~(" .. inv[6] .. ")"
								DrawWindow("Ammunition", tempitems)
								while menuactive do
									Wait(0)
									SetPlayerControl(GetPlayerId(), true)
									SetCamBehindPed(GetPlayerChar(-1))
									--SetGameCameraControlsActive(false)
								end
								if(menuresult > 0) then
									if(tempitems[menuresult] == "Light armor ~y~(" .. inv[4] .. ")") then
										if(inv[4] > 0) then
											inv[4] = inv[4] - 1
											SaveInv()
											AddArmourToChar(GetPlayerChar(GetPlayerId()), 50)
										end
									elseif(tempitems[menuresult] == "Heavy armor ~y~(" .. inv[5] .. ")") then
										if(inv[5] > 0) then
											inv[5] = inv[5] - 1
											SaveInv()
											AddArmourToChar(GetPlayerChar(GetPlayerId()), 100)
										end
									elseif(tempitems[menuresult] == "Ammo box ~y~(" .. inv[6] .. ")") then
										if(inv[6] > 0) then
											--if(GetCurrentCharWeapon(GetPlayerChar(GetPlayerId()), _i) >= 7) then
											local gw,cw = GetCurrentCharWeapon(GetPlayerChar(GetPlayerId()))
											if(cw >= 7) then
												if(cw~=30 and cw~=35 and
												cw~=18 and cw~=21 and cw~=24 and cw~=28 and cw~=36) then
													inv[6] = inv[6] - 1
													SaveInv()
													local tempgun = 0
													for i=1,#guns,1 do
														if(cw == guns[i][2]) then
															tempgun = i
														end
													end
													AddAmmoToChar(GetPlayerChar(GetPlayerId()), cw, guns[tempgun][4]*5)
												else
													TriggerEvent('chatMessage', '[Ammo]', {255, 0, 0}, 'This weapon cannot be replenished by ammo box!')
												end
											else
												TriggerEvent('chatMessage', '[Ammo]', {255, 0, 0}, 'You must have a gun in your hand!')
											end
										end
									end
									goto ammo
								else
									goto items
								end
							elseif(tempitems[menuresult] == "Repair kit ~y~(" .. inv[7] .. ")") then
								if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
									if(inv[7] > 0) then
										inv[7] = inv[7] - 1
										SaveInv()
										FixCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())))
										SetCarOnGroundProperly(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())))
										if(IsCharInCar(GetPlayerChar(GetPlayerId()), car)) then
											for j=1,#carinfo,1 do
												if(GetCarModel(car, _i) == carinfo[j][3]) then
													tempcar = j
												end
											end
											for j=1,#misccars,1 do
												if(GetCarModel(car, _i) == misccars[j][2]) then
													tempcar = #carinfo + j
												end
											end
											for j=1,#truckinfo,1 do
												if(GetCarModel(car, _i) == truckinfo[j][2]) then
													tempcar = #carinfo + #misccars + j
												end
											end
											if(currtuning[tempcar][21] > 0) then
												SetEngineHealth(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), 2000.1)
												SetPetrolTankHealth(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), 2000.1)
												SetCarHealth(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), 2000)
											end
										end
									end
								end
								goto items
							end
						else
							goto main
						end
					elseif(tempitems[menuresult] == "Specials") then
						::special::
						local tempitems = {}
						tempitems[#tempitems+1] = "Gun crate ~g~(5000$)"
						tempitems[#tempitems+1] = "Heavy suit ~g~(10000$)"
						DrawWindow("Specials", tempitems)
						while menuactive do
							Wait(0)
							SetPlayerControl(GetPlayerId(), true)
							SetCamBehindPed(GetPlayerChar(-1))
							--SetGameCameraControlsActive(false)
						end
						if(menuresult > 0) then
							if(tempitems[menuresult] == "Gun crate ~g~(5000$)") then
								if(techs[1] == 1) then
									if(speccooldown[1] == 0) then
										if(money >= 5000) then
											money = money - 5000
											SaveStats()
											local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
											DeleteObject(crate1)
											crate1 = SpawnObject(GetHashKey("bm_crate4"), px, py, pz+100)
											RemoveBlip(crateblip1)
											crateblip1 = AddBlipForObject(crate1)
											ChangeBlipNameFromAscii(crateblip1, "Gun crate")
											speccooldown[1] = 100
											TriggerEvent('chatMessage', '[Request]', {0, 255, 0}, 'Gun crate has been dropped!')
											for i=100,0,-1 do
												if(DoesObjectExist(crate1)) then
													SetObjectCoordinates(crate1, px, py, pz-1+i)
													Wait(20)
												end
											end
										else
											TriggerEvent('chatMessage', '[Request]', {255, 0, 0}, 'You cannot afford it!')
										end
									else
										TriggerEvent('chatMessage', '[Request]', {255, 0, 0}, 'You will be able to use it in ' .. speccooldown[1] .. ' seconds!')
									end
								else
									TriggerEvent('chatMessage', '[Request]', {255, 0, 0}, 'This item is locked!')
								end
							elseif(tempitems[menuresult] == "Heavy suit ~g~(10000$)") then
								if(techs[2] == 1) then
									if(speccooldown[2] == 0) then
										if(money >= 10000) then
											money = money - 10000
											SaveStats()
											local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
											DeleteObject(crate2)
											crate2 = SpawnObject(GetHashKey("bm_crate4"), px, py, pz+100)
											RemoveBlip(crateblip2)
											crateblip2 = AddBlipForObject(crate2)
											ChangeBlipNameFromAscii(crateblip2, "Heavy suit")
											speccooldown[2] = 100
											TriggerEvent('chatMessage', '[Request]', {0, 255, 0}, 'Heavy suit has been dropped!')
											for i=100,0,-1 do
												if(DoesObjectExist(crate2)) then
													SetObjectCoordinates(crate2, px, py, pz-1+i)
													Wait(20)
												end
											end
										else
											TriggerEvent('chatMessage', '[Request]', {255, 0, 0}, 'You cannot afford it!')
										end
									else
										TriggerEvent('chatMessage', '[Request]', {255, 0, 0}, 'You will be able to use it in ' .. speccooldown[1] .. ' seconds!')
									end
								else
									TriggerEvent('chatMessage', '[Request]', {255, 0, 0}, 'This item is locked!')
								end
							end
						else
							goto main
						end
					elseif(tempitems[menuresult] == "Car delivery") then
						::delivery::
						local tempitems = {}
						for j=1,#cars,1 do
							if(cars[j] == 1) then
								tempitems[#tempitems+1] = "" .. carinfo[j][1]
							end
						end
						DrawWindow("Select_car_to_deliver", tempitems)
						while menuactive do
							Wait(0)
							SetPlayerControl(GetPlayerId(), true)
							SetCamBehindPed(GetPlayerChar(-1))
							--SetGameCameraControlsActive(false)
						end
						if(menuresult > 0) then
							local tempcarid = 0
							for j=1,#carinfo,1 do
								if(carinfo[j][1] == tempitems[menuresult]) then
									tempcarid = j
								end
							end
							DrawWindow("" .. tempitems[menuresult], {"Deliver ~g~(1000$)"})
							while menuactive do
								Wait(0)
								SetPlayerControl(GetPlayerId(), true)
								SetCamBehindPed(GetPlayerChar(-1))
								--SetGameCameraControlsActive(false)
							end
							if(menuresult > 0) then
								if(menuresult == 1) then
									if(money >= 1000) then
										money = money - 1000
										SaveStats()
										local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
										local cb,cx,cy,cz,ch = GetNextClosestCarNodeWithHeading(px, py, pz, _f, _f, _f, _f)
										DeleteCar(car)
										car = SpawnCar(carinfo[tempcarid][3], cx, cy, cz, ch)
										ChangeCarColour(car, currtuning[tempcarid][1], currtuning[tempcarid][2])
										SetExtraCarColours(car, currtuning[tempcarid][3], currtuning[tempcarid][4])
										for j=1,9,1 do
											if(currtuning[tempcarid][j+4] == 0) then
												TurnOffVehicleExtra(car, j, true)
											else
												TurnOffVehicleExtra(car, j, false)
											end
										end
										rgb = {}
										for j=1,3,1 do
											rgb[j] = currtuning[tempcarid][13+j]
										end
										RemoveBlip(carblip)
										carblip = AddBlipForCar(car, _i)
										TriggerEvent('chatMessage', '[Delivery]', {0, 255, 0}, 'Vehicle delivered to the marked point.')
									else
										TriggerEvent('chatMessage', '[Delivery]', {255, 0, 0}, 'You do not have enough money!')
									end
								end
							else
								goto delivery
							end
						else
							goto main
						end
					elseif(tempitems[menuresult] == "Drugs inventory") then
						if(org > 0) then
							local bizes = 0
							for j=1,#biz,1 do
								if(biz[j] == 1) then
									bizes = bizes + 1
								end
							end
							if(bizes >= 2) then
								::drugs::
								local tempitems = {}
								tempitems[#tempitems+1] = "Heroin - " .. druginv[1]
								tempitems[#tempitems+1] = "Coke - " .. druginv[2]
								tempitems[#tempitems+1] = "Ecstasy - " .. druginv[3]
								tempitems[#tempitems+1] = "Acid - " .. druginv[4]
								tempitems[#tempitems+1] = "Weed - " .. druginv[5]
								tempitems[#tempitems+1] = "Downers - " .. druginv[6]
								DrawWindow("Drugs_inventory", tempitems)
								while menuactive do
									Wait(0)
									SetPlayerControl(GetPlayerId(), true)
									SetCamBehindPed(GetPlayerChar(-1))
									--SetGameCameraControlsActive(false)
								end
								if(menuresult > 0) then
									goto drugs
								else
									goto main
								end
							else
								TriggerEvent('chatMessage', '[Player menu]', {255, 0, 0}, 'You must own at least 2 businesses to get access to this menu!')
							end
						else
							TriggerEvent('chatMessage', '[Player menu]', {255, 0, 0}, 'You must own an organization to get access to this menu!')
						end
					elseif(tempitems[menuresult] == "Animations") then
						::anims::
						local tempitems = {}
						for i=1,#anims,1 do
							tempitems[i] = anims[i][1]
						end
						tempitems[#tempitems+1] = "Stop animation"
						DrawWindow("Animations", tempitems)
						while menuactive do
							Wait(0)
							SetPlayerControl(GetPlayerId(), true)
							SetCamBehindPed(GetPlayerChar(-1))
							--SetGameCameraControlsActive(false)
						end
						if(menuresult > 0) then
							if(tempitems[menuresult] == "Stop animation") then
								--SetPlayerControl(GetPlayerId(), true)
								ClearCharTasksImmediately(GetPlayerChar(GetPlayerId()))
							else
								ClearCharTasksImmediately(GetPlayerChar(GetPlayerId()))
								RequestAnims(anims[menuresult][3])
								while not HaveAnimsLoaded(anims[menuresult][3]) do
									Wait(0)
									SetPlayerControl(GetPlayerId(), true)
									SetCamBehindPed(GetPlayerChar(-1))
									--SetGameCameraControlsActive(false)
								end
								if(anims[menuresult][4] == 0) then
									TaskPlayAnimWithFlags(GetPlayerChar(GetPlayerId()), anims[menuresult][2], anims[menuresult][3], 8.0, 0, 0)
								elseif(anims[menuresult][4] == 1) then
									TaskPlayAnimWithFlags(GetPlayerChar(GetPlayerId()), anims[menuresult][2], anims[menuresult][3], 8.0, 3000000, 0)
								elseif(anims[menuresult][4] == 2) then
									TaskPlayAnimWithFlags(GetPlayerChar(GetPlayerId()), anims[menuresult][2], anims[menuresult][3], 8.0, 0, 0x20)
								end
							end
							goto anims
						else
							goto main
						end
					elseif(tempitems[menuresult] == "Leave event") then
						gamemode = 0
						playermode[ConvertIntToPlayerindex(GetPlayerId())] = {0, 0}
						TriggerServerEvent('updModes', playermode)
						if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
							if((not IsCharInCar(GetPlayerChar(GetPlayerId()), car)) and (not IsCharInCar(GetPlayerChar(GetPlayerId()), boat)) and (not IsCharInCar(GetPlayerChar(GetPlayerId()), heli))) then
								DeleteCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())))
							end
						end
						RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
						for i=1,8,1 do
							GiveWeaponToChar(GetPlayerChar(GetPlayerId()), weps[i][1], weps[i][2], 1)
						end
						TriggerEvent('chatMessage', '[Event]', {255, 255, 0}, 'You have left the event.')
					elseif(tempitems[menuresult] == "Send money") then
						local tempitems = {}
						local tempids = {}
						for i=0,31,1 do
							if(IsNetworkPlayerActive(i)) then
								if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
									tempitems[#tempitems+1] = "" .. GetPlayerName(i, _s)
									tempids[#tempids+1] = i
								end
							end
						end
						DrawWindow("Select_player_to_send", tempitems)
						while menuactive do
							Wait(0)
							SetPlayerControl(GetPlayerId(), true)
							SetCamBehindPed(GetPlayerChar(-1))
							--SetGameCameraControlsActive(false)
						end
						if(menuresult > 0) then
							local chatstring = ""
							cursor = 1
							::again::
							Wait(0)
							SetPlayerControl(GetPlayerId(), false)
							DrawRectLeftTopCenter(0.3, 0.5, 0.4, 0.05, 0, 0, 0, 100)
							local numbers = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
							for i=1,10,1 do --numbers
								if(IsGameKeyboardKeyJustPressed(i+1)) then
									chatstring = "" .. chatstring .. "" .. numbers[i]
								end
							end
							if(IsGameKeyboardKeyJustPressed(14)) then
								--chatstring = chatstring:sub(1, -1)
								chatstring = chatstring:sub(1, #chatstring - 1)
							end
							if(chatstring ~= "") then
								SetTextScale(0.1500000,  0.3000000)
								SetTextEdge(1, 0, 0, 0, 255)
								--SetTextFont(6)
								--SetTextCentre(1)
								DisplayTextWithLiteralString(0.31, 0.515, "STRING", "" .. chatstring)
							else
								SetTextScale(0.1500000,  0.3000000)
								SetTextEdge(1, 0, 0, 0, 255)
								--SetTextFont(6)
								--SetTextCentre(1)
								DisplayTextWithLiteralString(0.31, 0.515, "STRING", "Enter amount")
							end
							DrawRectLeftTopCenter(0.4, 0.7, 0.2, 0.1, 0, 0, 0, 100)
							SetTextScale(0.300000,  0.6000000)
							SetTextEdge(1, 0, 0, 0, 255)
							SetTextCentre(1)
							DisplayTextWithLiteralString(0.5, 0.73, "STRING", "Send")
							if(IsCursorInAreaLeftTopCenter(0.4, 0.7, 0.2, 0.1)) then
								DrawRectLeftTopCenter(0.4, 0.7, 0.2, 0.1, 255, 255, 255, 255)
								if(IsMouseButtonJustPressed(1)) then
									if(chatstring ~= "") then
										if(money >= tonumber(chatstring)) then
											TriggerServerEvent('sendMoney', tempids[menuresult], ConvertIntToPlayerindex(GetPlayerId()), tonumber(chatstring))
											--TriggerEvent('chatMessage', '[Cash]', {0, 255, 0}, 'Money have been successfully sent.')
											money = money - tonumber(chatstring)
											SaveStats()
										else
											TriggerEvent('chatMessage', '[Cash]', {255, 0, 0}, 'You do not have this amount of money!')
										end
										cursor = 0
										SetPlayerControl(GetPlayerId(), true)
										goto finish
									else
										TriggerEvent('chatMessage', '[Cash]', {255, 0, 0}, 'Enter the amount!')
									end
								end
							end
							goto again
						end
						::finish::
					elseif(tempitems[menuresult] == "Give weapon") then
						local gw,cw = GetCurrentCharWeapon(GetPlayerChar(GetPlayerId()))
						if(cw ~= 0) then
							local checker = 0
							for i=0,31,1 do
								if(IsNetworkPlayerActive(i)) then
									if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
										local px,py,pz = GetCharCoordinates(GetPlayerChar(i))
										if(IsPlayerNearCoords(px, py, pz, 5)) then
											checker = 1
											
											local chatstring = ""
											cursor = 1
											::again::
											Wait(0)
											SetPlayerControl(GetPlayerId(), false)
											DrawRectLeftTopCenter(0.3, 0.5, 0.4, 0.05, 0, 0, 0, 100)
											local numbers = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
											for i=1,10,1 do --numbers
												if(IsGameKeyboardKeyJustPressed(i+1)) then
													chatstring = "" .. chatstring .. "" .. numbers[i]
												end
											end
											if(IsGameKeyboardKeyJustPressed(14)) then
												--chatstring = chatstring:sub(1, -1)
												chatstring = chatstring:sub(1, #chatstring - 1)
											end
											if(chatstring ~= "") then
												SetTextScale(0.1500000,  0.3000000)
												SetTextEdge(1, 0, 0, 0, 255)
												--SetTextFont(6)
												--SetTextCentre(1)
												DisplayTextWithLiteralString(0.31, 0.515, "STRING", "" .. chatstring)
											else
												SetTextScale(0.1500000,  0.3000000)
												SetTextEdge(1, 0, 0, 0, 255)
												--SetTextFont(6)
												--SetTextCentre(1)
												DisplayTextWithLiteralString(0.31, 0.515, "STRING", "Enter amount for " .. GetPlayerName(i))
											end
											DrawRectLeftTopCenter(0.4-0.1, 0.7, 0.2, 0.1, 0, 0, 0, 100)
											SetTextScale(0.300000,  0.6000000)
											SetTextEdge(1, 0, 0, 0, 255)
											SetTextCentre(1)
											DisplayTextWithLiteralString(0.5-0.1, 0.73, "STRING", "Give")
											if(IsCursorInAreaLeftTopCenter(0.4-0.1, 0.7, 0.2, 0.1)) then
												DrawRectLeftTopCenter(0.4-0.1, 0.7, 0.2, 0.1, 255, 255, 255, 255)
												if(IsMouseButtonJustPressed(1)) then
													if(chatstring ~= "") then
														local ammo = GetAmmoInCharWeapon(GetPlayerChar(GetPlayerId()), cw)
														if(ammo >= tonumber(chatstring)) then
															TriggerServerEvent('giveGun', i, ConvertIntToPlayerindex(GetPlayerId()), cw, tonumber(chatstring))
															--TriggerEvent('chatMessage', '[Cash]', {0, 255, 0}, 'Money have been successfully sent.')
															ammo = ammo - tonumber(chatstring)
															SetCharAmmo(GetPlayerChar(GetPlayerId()), cw, ammo)
															--GiveWeaponToChar(GetPlayerChar(i), cw, tonumber(chatstring), 1)
														else
															TriggerEvent('chatMessage', '[Weapon]', {255, 0, 0}, 'You do not have this amount of ammo!')
														end
														cursor = 0
														Wait(500)
														SetPlayerControl(GetPlayerId(), true)
														goto finish
													else
														TriggerEvent('chatMessage', '[Cash]', {255, 0, 0}, 'Enter the amount!')
													end
												end
											end
											DrawRectLeftTopCenter(0.4+0.1, 0.7, 0.2, 0.1, 0, 0, 0, 100)
											SetTextScale(0.300000,  0.6000000)
											SetTextEdge(1, 0, 0, 0, 255)
											SetTextCentre(1)
											SetTextWrap(0.0, 0.5+0.1)
											DisplayTextWithLiteralString(0.5+0.1, 0.73, "STRING", "Cancel")
											if(IsCursorInAreaLeftTopCenter(0.4+0.1, 0.7, 0.2, 0.1)) then
												DrawRectLeftTopCenter(0.4+0.1, 0.7, 0.2, 0.1, 255, 255, 255, 255)
												if(IsMouseButtonJustPressed(1)) then
													cursor = 0
													Wait(500)
													SetPlayerControl(GetPlayerId(), true)
													goto finish
												end
											end
											goto again
										end
									end
								end
							end
							if(checker == 0) then
								TriggerEvent('chatMessage', '[Weapon]', {255, 0, 0}, 'No-one is near to give a weapon!')
							end
							::finish::
						else
							TriggerEvent('chatMessage', '[Weapon]', {255, 0, 0}, 'You must have a gun in your hand!')
						end
					elseif(tempitems[menuresult] == "Co-op") then
						::coop::
						local tempitems = {}
						if(coop[ConvertIntToPlayerindex(GetPlayerId())] == -1) then
							tempitems[#tempitems+1] = "Invite player"
							tempitems[#tempitems+1] = "Remove player"
						else
							tempitems[#tempitems+1] = "Leave co-op team"
						end
						DrawWindow("Co-op", tempitems)
						while menuactive do
							Wait(0)
							SetPlayerControl(GetPlayerId(), true)
							SetCamBehindPed(GetPlayerChar(-1))
							--SetGameCameraControlsActive(false)
						end
						if(menuresult > 0) then
							if(tempitems[menuresult] == "Invite player") then
								::invite::
								local tempitems = {}
								local tempids = {}
								for i=0,31,1 do
									if(IsNetworkPlayerActive(i)) then
										if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
											if(coop[i] == -1) then
												tempitems[#tempitems+1] = "" .. GetPlayerName(i, _s)
												tempids[#tempids+1] = i
											end
										end
									end
								end
								DrawWindow("Select_player_to_invite", tempitems)
								while menuactive do
									Wait(0)
									SetPlayerControl(GetPlayerId(), true)
									SetCamBehindPed(GetPlayerChar(-1))
									--SetGameCameraControlsActive(false)
								end
								if(menuresult > 0) then
									TriggerServerEvent('invitePlayerToCoop', tempids[menuresult], ConvertIntToPlayerindex(GetPlayerId()))
									TriggerEvent('chatMessage', '[Co-op]', {255, 255, 0}, 'Invite has been sent.')
									goto invite
								else
									goto coop
								end
							elseif(tempitems[menuresult] == "Remove player") then
								::remove::
								local tempitems = {}
								local tempids = {}
								for i=0,31,1 do
									if(IsNetworkPlayerActive(i)) then
										if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
											if(coop[i] == ConvertIntToPlayerindex(GetPlayerId())) then
												tempitems[#tempitems+1] = "" .. GetPlayerName(i, _s)
												tempids[#tempids+1] = i
											end
										end
									end
								end
								DrawWindow("Select_player_to_remove", tempitems)
								while menuactive do
									Wait(0)
									SetPlayerControl(GetPlayerId(), true)
									SetCamBehindPed(GetPlayerChar(-1))
									--SetGameCameraControlsActive(false)
								end
								if(menuresult > 0) then
									TriggerServerEvent('removePlayerFromCoop', tempids[menuresult], ConvertIntToPlayerindex(GetPlayerId()))
									goto remove
								else
									goto coop
								end
							elseif(tempitems[menuresult] == "Leave co-op team") then
								TriggerServerEvent('sendMessageToPlayer', GetPlayerName(coop[ConvertIntToPlayerindex(GetPlayerId())]), "[Co-op]", "" .. GetPlayerName(GetPlayerId()) .. " has left your co-op team.")
								TriggerServerEvent('removePlayerFromCoop', ConvertIntToPlayerindex(GetPlayerId()), coop[ConvertIntToPlayerindex(GetPlayerId())])
								TriggerEvent('chatMessage', '[Co-op]', {255, 255, 0}, 'You have left co-op team.')
							end
						else
							goto main
						end
					elseif(tempitems[menuresult] == "Collect daily bonus") then
						TriggerServerEvent('requestBonus', bonusday)
					elseif(tempitems[menuresult] == "Daily objectives") then
						ProceedToDailyObjectives()
					elseif(tempitems[menuresult] == "Help") then
						::help::
						local tempitems = {}
						tempitems[#tempitems+1] = "Shop"
						tempitems[#tempitems+1] = "Gun shop"
						tempitems[#tempitems+1] = "Clothes shop"
						tempitems[#tempitems+1] = "Internet cafe"
						tempitems[#tempitems+1] = "Side-jobs"
						tempitems[#tempitems+1] = "Missions"
						tempitems[#tempitems+1] = "Organization"
						tempitems[#tempitems+1] = "Heists"
						tempitems[#tempitems+1] = "Businesses"
						tempitems[#tempitems+1] = "Storage"
						tempitems[#tempitems+1] = "Agency"
						tempitems[#tempitems+1] = "Clan"
						tempitems[#tempitems+1] = "Co-op"
						tempitems[#tempitems+1] = "Phone"
						tempitems[#tempitems+1] = "Game modes"
						tempitems[#tempitems+1] = "Lucky wheel"
						tempitems[#tempitems+1] = "Daily objectives"
						tempitems[#tempitems+1] = "Apartments"
						tempitems[#tempitems+1] = "Car shop"
						tempitems[#tempitems+1] = "Tuning"
						tempitems[#tempitems+1] = "Boatyards"
						tempitems[#tempitems+1] = "Helipads"
						tempitems[#tempitems+1] = "Yacht"
						tempitems[#tempitems+1] = "Acid Lab"
						DrawWindow("Help", tempitems)
						while menuactive do
							Wait(0)
							SetPlayerControl(GetPlayerId(), true)
							SetCamBehindPed(GetPlayerChar(-1))
							--SetGameCameraControlsActive(false)
							if(currbutton > 0) then
								if(tempitems[currbutton] == "Shop") then
									DrawDescription("Shop", {
									-----------------------------------------------------------------------------------------------
									"Shop is needed to replenish your health and buy snacks. Snacks can be eaten any time to",
									"replenish health via player menu. Also shops can be robbed to get cash. To rob shop you need",
									"to enter it and aim your gun (firearm) to start robbery. After that you have to stay in a",
									"robbery zone until timer is up. During this process there may be cops who will try to",
									"interfere the robbery."
									})
								elseif(tempitems[currbutton] == "Gun shop") then
									DrawDescription("Gun shop", {
									-----------------------------------------------------------------------------------------------
									"Gun shops provide ability to buy guns, replenish armor and buy armor vests. These vests later",
									"can be used via player menu any time."
									})
								elseif(tempitems[currbutton] == "Clothes shop") then
									DrawDescription("Clothes shop", {
									-----------------------------------------------------------------------------------------------
									"Use clothes shop to change gender (skin), face, hair, torso, legs and other components of",
									"your character."
									})
								elseif(tempitems[currbutton] == "Internet cafe") then
									DrawDescription("Internet cafe", {
									-----------------------------------------------------------------------------------------------
									"This place is needed to do some illegal side-jobs like drug dealing and gunrunning. Access is",
									"provided only when you own an organization and 2 businesses."
									})
								elseif(tempitems[currbutton] == "Side-jobs") then
									DrawDescription("Side-jobs", {
									-----------------------------------------------------------------------------------------------
									"There are side-jobs for new players and for experienced players.",
									"New players are allowed to start taxi, police, ambulance and firefighter jobs. For that you",
									"are supposed to get into corresponding vehicle and press ~y~Caps Lock ~w~button. To get one",
									"of these vehicles you can just steal them or call them via your phone (~y~Arrow Up ~w~button).",
									"Also you can work as bus driver and garbage trucker (look for markers on the map to find them).",
									"Experienced players can do car selling, trucking, drug dealing, gunrunning and other side-jobs."
									})
								elseif(tempitems[currbutton] == "Missions") then
									DrawDescription("Missions", {
									-----------------------------------------------------------------------------------------------
									"Missions are marked of the map with question marks and each of them has their specific level",
									"requirement. All currently available missions for you are marked with green question mark.",
									"Missions are the main way of getting cash and experience."
									})
								elseif(tempitems[currbutton] == "Organization") then
									DrawDescription("Organization", {
									-----------------------------------------------------------------------------------------------
									"Organization is the most important place. Here you can collect income from your businesses,",
									"create and manage your clan, start heists and do other things. It also unlocks additional",
									"content. There are several missions which are available only when you own an organization."
									})
								elseif(tempitems[currbutton] == "Heists") then
									DrawDescription("Organization", {
									-----------------------------------------------------------------------------------------------
									"Heist is a multi-step mission which consists of necessary and optional missions. You can get",
									"advantage in the final mission by completing optinal preparation missions. Heists are the most",
									"efficient way of making cash and getting experience."
									})
								elseif(tempitems[currbutton] == "Businesses") then
									DrawDescription("Businesses", {
									-----------------------------------------------------------------------------------------------
									"Business provides you ability to get passive income which can be increased by doing business",
									"missions. Business missions let you receive extra experience and increase your income",
									"multiplier. Every in-game day in 00:00 your business gets income based on this multiplier and",
									"this multiplier is getting lowered. If you stop increasing your income multiplier, you may",
									"stop receiving income. Income can be collected either at a business or at organization.",
									"If you own several businesses of same type, income multiplier increases faster by doing",
									"business missions."
									})
								elseif(tempitems[currbutton] == "Storage") then
									DrawDescription("Storage", {
									-----------------------------------------------------------------------------------------------
									"Storage is used to store cargo which can be acquired by doing supply missions. Cargo is",
									"needed to perform ammunition upgrades which provide you some special equipment and weapons.",
									"Cargo is also needed to purchase special weapons (when they are unlocked) and you can sell",
									"cargo anytime to get extra cash. Storage can be used as spawn point."
									})
								elseif(tempitems[currbutton] == "Agency") then
									DrawDescription("Agency", {
									-----------------------------------------------------------------------------------------------
									"Agency provides ability to do contract missions. Each contract provides some cash and EXP",
									"payment and also contract points. Contract points are needed to launch VIP contracts which",
									"consist of 3 connected missions. Completion of such contracts is highly rewarded."
									})
								elseif(tempitems[currbutton] == "Clan") then
									DrawDescription("Clan", {
									-----------------------------------------------------------------------------------------------
									"You can create or join clan only when you own an organization. Being a part of a clan provides",
									"you some benifits such as special clan gun shop with lowered prices, increased rewards for",
									"organization missions and ability to capture territories around the city. Every in-game day",
									"you receive bonus cash and EXP based on amount of captured territories."
									})
								elseif(tempitems[currbutton] == "Co-op") then
									DrawDescription("Co-op", {
									-----------------------------------------------------------------------------------------------
									"Via player menu you are able to create or join co-op team. When you are a leader of co-op",
									"team other members will be able to see your current mission objective and mission markers.",
									"Also if mission is completed successfully, all members will get separated reward. Leader is",
									"able to remove players from their team and if you are a member of team, you are allowed to",
									"leave it any time. You can do co-op not only regular missions but also heists and organization",
									"missions."
									})
								elseif(tempitems[currbutton] == "Phone") then
									DrawDescription("Phone", {
									-----------------------------------------------------------------------------------------------
									"Phone (~y~Arrow Up ~w~button) can be used for various actions like calling emergency services,",
									"chatting with other players, requesting car delivery, etc."
									})
								elseif(tempitems[currbutton] == "Game modes") then
									DrawDescription("Game modes", {
									-----------------------------------------------------------------------------------------------
									"You can participate in several multiplayer game modes around the map to get extra cash and",
									"experience. For winning in such game modes you can receive great rewards. Presented game",
									"modes: Deathmatch, Gun game, Race, Pursuit race, Survival, Derby. To start race or pursuit",
									"race, you and your rivals are supposed to enter the race checkpoint and after that one of",
									"participants must start a race. Other game modes are session-like and you just have to join it",
									"via game mode checkpoint, other players are allowed to join later any time until the end of",
									"event."
									})
								elseif(tempitems[currbutton] == "Lucky wheel") then
									DrawDescription("Lucky wheel", {
									-----------------------------------------------------------------------------------------------
									"Lucky wheel can spinned once per real day. There you can get money, EXP rewards and also",
									"win a random car. You can win a car even if you do not own an apartment."
									})
								elseif(tempitems[currbutton] == "Daily objectives") then
									DrawDescription("Daily objectives", {
									-----------------------------------------------------------------------------------------------
									"Via player menu you can check your current daily objectives and their completion statuses.",
									"If you complete all of them, you can receive a great reward. They can be done and reward can",
									"be received only once per real day."
									})
								elseif(tempitems[currbutton] == "Apartments") then
									DrawDescription("Apartments", {
									-----------------------------------------------------------------------------------------------
									"Apartments can be used as spawn point, they are needed to store your personal vehicles and",
									"there you can spawn them. Each apartment has its specific amount of garage places. When you",
									"own several apartments, you can select at which you want to spawn when you enter the",
									"server. Besides that garage places of all apartments you own are being summed up."
									})
								elseif(tempitems[currbutton] == "Car shop") then
									DrawDescription("Car shop", {
									-----------------------------------------------------------------------------------------------
									"Car shop is used to purchase land vehicles. To buy a vehicle you must own at least one",
									"apartment and have at least one free garage place available to store this vehicle. All owned",
									"cars can be spawned at your apartment or you can request car delivery via your phone."
									})
								elseif(tempitems[currbutton] == "Tuning") then
									DrawDescription("Tuning", {
									-----------------------------------------------------------------------------------------------
									"You are able to tune your purchased cars. For that visit a tuning shop and enter its menu.",
									"Here you can change colors, set extras and add neon lights. Also you can do performance",
									"tuning which lets you upgrade an engine, brakes, nitro and setup hydraulics. Also you can",
									"install armor, bullet-proof tires and fire protection."
									})
								elseif(tempitems[currbutton] == "Boatyards") then
									DrawDescription("Boatyards", {
									-----------------------------------------------------------------------------------------------
									"Boatyards are needed to purchase and store marine vehicles. Here you can spawn your boats.",
									"To purchase a boatyard you must own at least one apartment."
									})
								elseif(tempitems[currbutton] == "Helipads") then
									DrawDescription("Helipads", {
									-----------------------------------------------------------------------------------------------
									"Helipads are needed to purchase and store air vehicles. Here you can spawn your helicopters.",
									"To purchase a helipad you must own at least one apartment."
									})
								elseif(tempitems[currbutton] == "Yacht") then
									DrawDescription("Yacht", {
									-----------------------------------------------------------------------------------------------
									"Yacht can be purchased at a boatyard. It can be used as a spawn point and here you can spawn",
									"your personal marine and air vehicles. Also yacht provides access to several special missions."
									})
								elseif(tempitems[currbutton] == "Acid Lab") then
									DrawDescription("Acid Lab", {
									-----------------------------------------------------------------------------------------------
									"Acid Lab lets you produce and sell drugs. To get it, you need to purchase a Brickade van.",
									"First you need to do supply missions, and then wait some time until drugs are produced.",
									"Produced drugs can be sold by doing sell missions."
									})
								end
							end
						end
						if(menuresult > 0) then
							goto help
						else
							goto main
						end
					elseif(tempitems[menuresult] == "Outrun") then
						ProceedToOutrun()
					elseif(tempitems[menuresult] == "Impromptu race") then
						ProceedToImpromptuRace()
					elseif(tempitems[menuresult] == "Tutorial") then
						Wait(100)
						tutorial = 1
						page = 1
					elseif(tempitems[menuresult] == "Set nickname color") then
						local clr = {0, 0, 0}
						if(#playercolor[ConvertIntToPlayerindex(GetPlayerId())] > 0) then
							clr = playercolor[ConvertIntToPlayerindex(GetPlayerId())]
						end
						::color::
						local tempitems = {}
						tempitems[#tempitems+1] = "Red"
						tempitems[#tempitems+1] = "Green"
						tempitems[#tempitems+1] = "Blue"
						tempitems[#tempitems+1] = "Set"
						DrawWindow("Nickname_color", tempitems)
						while menuactive do
							Wait(0)
						end
						if(menuresult > 0) then
							if(menuresult ~= 4) then
								local tempitem = {menuresult, tempitems[menuresult]}
								::colorswitch::
								local tempitems = {}
								for j=0,255,1 do
									tempitems[#tempitems+1] = j
								end
								DrawWindow("" .. tempitem[2], tempitems)
								while menuactive do
									Wait(0)
								end
								if(menuresult > 0) then
									clr[tempitem[1]] = menuresult-1
									goto colorswitch
								else
									goto color
								end
							else
								TriggerServerEvent('setPlayerColor', ConvertIntToPlayerindex(GetPlayerId()), clr)
								TriggerEvent('chatMessage', '[Color]', {0, 255, 0}, 'Color changed.')
							end
						else
							goto main
						end
						--[[local tempitems = {}
						tempitems[#tempitems+1] = "Orange"
						tempitems[#tempitems+1] = "Purple"
						tempitems[#tempitems+1] = "Green"
						tempitems[#tempitems+1] = "Red"
						tempitems[#tempitems+1] = "Yellow"
						tempitems[#tempitems+1] = "Blue"
						tempitems[#tempitems+1] = "Hot pink"
						tempitems[#tempitems+1] = "Tan"
						tempitems[#tempitems+1] = "Dark green"
						tempitems[#tempitems+1] = "Dark blue"
						tempitems[#tempitems+1] = "Pink"
						tempitems[#tempitems+1] = "Light blue"
						tempitems[#tempitems+1] = "Olive green"
						tempitems[#tempitems+1] = "Light green"
						tempitems[#tempitems+1] = "Gray"
						tempitems[#tempitems+1] = "Brown"
						DrawWindow("Nickname_color", tempitems)
						while menuactive do
							Wait(0)
						end
						if(menuresult > 0) then
							TriggerServerEvent('setPlayerColor', ConvertIntToPlayerindex(GetPlayerId()), menuresult)
							TriggerEvent('chatMessage', '[Color]', {0, 255, 0}, 'Color changed.')
						else
							goto main
						end]]
					elseif(tempitems[menuresult] == "Enable/disable speedometer") then
						if(sm == 0) then
							sm = 1
						else
							sm = 0
						end
						SaveStats()
					else
						if(string.match(tempitems[menuresult], "armwrestling")) then
							ProceedToWrest(armid)
						elseif(string.match(tempitems[menuresult], "stuff")) then
							DrawWindow("Stuff with " .. GetPlayerName(GetPlayerIdForThisPed(ped2)), {"Handjob", "Blowjob", "Sex"})
							while menuactive do
								Wait(0)
							end
							if(menuresult > 0) then
								TriggerServerEvent('sendStuffOffer', GetPlayerIdForThisPed(ped2), ConvertIntToPlayerindex(GetPlayerId()), menuresult)
							end
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
		if(DoesBlipExist(carblip)) then
			if(IsCharInCar(GetPlayerChar(GetPlayerId()), car)) then
				RemoveBlip(carblip)
			end
		end
	end
end)

RegisterNetEvent('sendMoney')
AddEventHandler('sendMoney', function(id, owner, amount)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		if(IsNetworkPlayerActive(id)) then
			money = money + amount
			SaveStats()
			TriggerEvent('chatMessage', '[Cash]', {0, 255, 0}, "" .. GetPlayerName(owner, _s) .. " has sent " .. amount .. "$ to you!")
			TriggerServerEvent('sendMessageToPlayer', "" .. GetPlayerName(owner, _s), "[Cash]", "" .. GetPlayerName(id, _s) .. " has successfully received your cash!")
		else
			TriggerServerEvent('sendMessageToPlayer', "" .. GetPlayerName(owner, _s), "[Cash]", "" .. GetPlayerName(id, _s) .. " has left the server.")
		end
	end
end)

RegisterNetEvent('giveGun')
AddEventHandler('giveGun', function(id, owner, wep, amount)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		if(IsNetworkPlayerActive(id)) then
			GiveWeaponToChar(GetPlayerChar(GetPlayerId()), wep, amount, 1)
			TriggerEvent('chatMessage', '[Weapon]', {0, 255, 0}, "" .. GetPlayerName(owner, _s) .. " has given a gun to you!")
		end
	end
end)

local killblocker = {}
for i=0,31,1 do
	killblocker[i] = 0
end
CreateThread(function()
	while true do
		Wait(0)
		if(gamemode == 0) then
			for i=0,31,1 do
				if(IsNetworkPlayerActive(i)) then
					if(IsPlayerDead(i)) then
						if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
							if(FindNetworkKillerOfPlayer(i) == GetPlayerId()) then
								if(killblocker[i] == 0) then
									if(clan ~= "0") then
										TriggerServerEvent('checkClanmate', i, ConvertIntToPlayerindex(GetPlayerId()), clan)
										killblocker[i] = 1
									end
								end
							end
						end
					else
						killblocker[i] = 0
					end
				end
			end
		end
	end
end)

RegisterNetEvent('checkClanmate')
AddEventHandler('checkClanmate', function(id, killer, c)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		if(clan == c) then
			TriggerServerEvent('punishKiller', killer)
			TriggerEvent('chatMessage', '[Clan]', {255, 0, 0}, "You have been killed by your clanmate: " .. GetPlayerName(killer, _s))
			TriggerServerEvent('sendMessageToPlayer', "" .. GetPlayerName(killer, _s), "[Clan]", "You have killed your clanmate (-50 HP)!")
		end
	end
end)

RegisterNetEvent('punishKiller')
AddEventHandler('punishKiller', function(id)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		DamageChar(GetPlayerChar(GetPlayerId()), 50, 0)
	end
end)

RegisterNetEvent('requestBonus')
AddEventHandler('requestBonus', function(bday)
	local finalbonus = 0
	finalbonus = 100*level
	money = money + finalbonus
	bonusday = tonumber(bday)
	SaveStats()
	TriggerEvent('chatMessage', '[Bonus]', {0, 255, 0}, 'You have got a bonus +' .. finalbonus .. '$!')
end)

CreateThread(function()
	while true do
		Wait(0)
		if(DoesObjectExist(crate1)) then
			local ox,oy,oz = GetObjectCoordinates(crate1)
			if(IsPlayerNearCoords(ox, oy, oz, 2)) then
				RemoveBlip(crateblip1)
				DeleteObject(crate1)
				GiveWeaponToChar(GetPlayerChar(GetPlayerId()), 9, 100, 1)
				GiveWeaponToChar(GetPlayerChar(GetPlayerId()), 13, 200, 1)
				GiveWeaponToChar(GetPlayerChar(GetPlayerId()), 15, 100, 1)
				PrintStringWithLiteralStringNow("STRING", "Gun crate collected", 3000, 1)
			end
		end
		if(DoesObjectExist(crate2)) then
			local ox,oy,oz = GetObjectCoordinates(crate2)
			if(IsPlayerNearCoords(ox, oy, oz, 2)) then
				RemoveBlip(crateblip2)
				DeleteObject(crate2)
				SetCharHealth(GetPlayerChar(GetPlayerId()), 300)
				AddArmourToChar(GetPlayerChar(GetPlayerId()), 200)
				SetCharMoveAnimSpeedMultiplier(GetPlayerChar(GetPlayerId()), 1.5)
				PrintStringWithLiteralStringNow("STRING", "Heavy suit collected", 3000, 1)
			end
		end
		if(IsPlayerDead(GetPlayerId())) then
			SetCharMoveAnimSpeedMultiplier(GetPlayerChar(GetPlayerId()), 1.0)
		end
	end
end)

SeparateReward = function(cash, exp)
	local tempamount = 1
	for i=0,31,1 do
		if(IsNetworkPlayerActive(i)) then
			if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
				if(coop[i] == ConvertIntToPlayerindex(GetPlayerId())) then
					tempamount = tempamount + 1
				end
			end
		end
	end
	for i=0,31,1 do
		if(IsNetworkPlayerActive(i)) then
			if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
				if(coop[i] == ConvertIntToPlayerindex(GetPlayerId())) then
					TriggerServerEvent('sendCoopReward', i, math.floor(cash/tempamount), math.floor(exp/tempamount))
				end
			end
		end
	end
	return {math.floor(cash/tempamount), math.floor(exp/tempamount)}
end

RegisterNetEvent('sendCoopReward')
AddEventHandler('sendCoopReward', function(id, cash, exp)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		money = money + cash
		experience = experience + exp
		SaveStats()
		--TriggerEvent('chatMessage', '[Co-op]', {0, 255, 0}, "You have got co-op reward: " .. cash .. "$ and " .. exp .. " EXP")
		DrawMessage("~b~Co-op mission completed", "You have got " .. cash .. "$ and " .. exp .. " EXP")
	end
end)

local coopblip = {}
RegisterNetEvent('sendBlipsForCoop')
AddEventHandler('sendBlipsForCoop', function(id, blipinfo)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		for i=1,#coopblip,1 do
			RemoveBlip(coopblip[i])
			coopblip[i] = nil
		end
		for i=1,#blipinfo,1 do
			coopblip[i] = AddBlipForCoord(blipinfo[i][1], blipinfo[i][2], blipinfo[i][3])
			--ChangeBlipNameFromAscii(coopblip[i], blipinfo[i][4])
			ChangeBlipColour(coopblip[i], blipinfo[i][4])
		end
	end
end)
CreateThread(function()
	while true do
		Wait(0)
		--if(#coopblip > 0) then
			if(coop[ConvertIntToPlayerindex(GetPlayerId())] == -1) then
				for i=1,#coopblip,1 do
					RemoveBlip(coopblip[i])
					coopblip[i] = nil
				end
				SetCurrentCoopObjective("")
			else
				if(not IsNetworkPlayerActive(coop[ConvertIntToPlayerindex(GetPlayerId())])) then
					for i=1,#coopblip,1 do
						RemoveBlip(coopblip[i])
						coopblip[i] = nil
					end
					SetCurrentCoopObjective("")
				end
			end
		--end
	end
end)
CreateThread(function()
	while true do
		Wait(1000)
		local blipinfo = {}
		if(missionstarted == 1) then
			for i=1,100,1 do
				if(DoesBlipExist(blips[i])) then
					blipinfo[#blipinfo+1] = {}
					local bp = GetBlipCoords(blips[i])
					blipinfo[#blipinfo][1] = bp.x
					blipinfo[#blipinfo][2] = bp.y
					blipinfo[#blipinfo][3] = bp.z
					--blipinfo[#blipinfo][4] = GetBlipName(blips[i])
					blipinfo[#blipinfo][4] = GetBlipColour(blips[i])
				end
			end
		end
		for i=0,31,1 do
			if(IsNetworkPlayerActive(i)) then
				if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
					if(coop[i] == ConvertIntToPlayerindex(GetPlayerId())) then
						TriggerServerEvent('sendBlipsForCoop', i, blipinfo)
						TriggerServerEvent('sendObjectiveForCoop', i, GetCurrentObjective())
					end
				end
			end
		end
	end
end)

local objective = ""
SetCurrentCoopObjective = function(text)
	objective = text
end
CreateThread(function()
	while true do
		Wait(0)
		if(objective ~= nil) then
			--if(missionstarted == 1) then
				if(objective ~= "") then
					SetTextScale(0.1500000, 0.3000000)
					SetTextDropshadow(0, 0, 0, 0, 0)
					SetTextEdge(1, 0, 0, 0, 255)
					DisplayTextWithLiteralString(0.2, 0.9, "STRING", "~b~Co-op:~w~ " .. objective)
				end
			--end
		end
	end
end)
RegisterNetEvent('sendObjectiveForCoop')
AddEventHandler('sendObjectiveForCoop', function(id, text)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		SetCurrentCoopObjective("" .. text)
	end
end)

local stuffchecker = false
RegisterNetEvent('sendStuffOffer')
AddEventHandler('sendStuffOffer', function(id, sender, type)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		CreateThread(function()
			DrawWindow("Someone offers to do stuff with you", {"Accept " .. GetPlayerName(sender) .. "'s offer"})
			while menuactive do
				Wait(0)
			end
			if(menuresult > 0) then
				local ped = GetPlayerChar(GetPlayerId())
				local veh = GetCarCharIsUsing(ped)
				local manims = {"m_handjob_loop", "m_blowjob_loop", "m_sex_loop"}
				local fanims = {"f_handjob_loop", "f_blowjob_loop", "f_sex_loop"}
				--ClearCharTasksImmediately(GetPlayerChar(GetPlayerId()))
				RequestAnims("misscar_sex")
				while not HaveAnimsLoaded("misscar_sex") do
					Wait(0)
				end
				stuffchecker = false
				Settimerc(0)
				TriggerServerEvent('acceptStuffOffer', sender, id, type)
				while not stuffchecker do
					Wait(0)
					if(Timerc() >= 10000) then
						goto out
					end
				end
				if(GetDriverOfCar(veh)==ped or GetCharInCarPassengerSeat(veh, 1)==ped) then
					TaskPlayAnimWithFlags(ped, manims[type], "misscar_sex", 8.0, 3000000, 0)
				elseif(GetCharInCarPassengerSeat(veh, 0)==ped or GetCharInCarPassengerSeat(veh, 2)==ped) then
					--SetScriptedAnimSeatOffset(ped, 0.80900000)
					TaskPlayAnimWithFlags(ped, fanims[type], "misscar_sex", 8.0, 3000000, 0)
				end
				::out::
			else
				TriggerServerEvent('sendMessageToPlayer2', sender, "[Stuff]", "Your offer has been declined.")
			end
		end)
	end
end)
RegisterNetEvent('acceptStuffOffer')
AddEventHandler('acceptStuffOffer', function(id, sender, type)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		CreateThread(function()
			local ped = GetPlayerChar(GetPlayerId())
			local veh = GetCarCharIsUsing(ped)
			local manims = {"m_handjob_loop", "m_blowjob_loop", "m_sex_loop"}
			local fanims = {"f_handjob_loop", "f_blowjob_loop", "f_sex_loop"}
			--ClearCharTasksImmediately(GetPlayerChar(GetPlayerId()))
			RequestAnims("misscar_sex")
			while not HaveAnimsLoaded("misscar_sex") do
				Wait(0)
			end
			TriggerServerEvent('acceptStuffOffer2', sender)
			if(GetDriverOfCar(veh)==ped or GetCharInCarPassengerSeat(veh, 1)==ped) then
				TaskPlayAnimWithFlags(ped, manims[type], "misscar_sex", 8.0, 3000000, 0)
			elseif(GetCharInCarPassengerSeat(veh, 0)==ped or GetCharInCarPassengerSeat(veh, 2)==ped) then
				--SetScriptedAnimSeatOffset(ped, 0.80900000)
				TaskPlayAnimWithFlags(ped, fanims[type], "misscar_sex", 8.0, 3000000, 0)
			end
		end)
	end
end)
RegisterNetEvent('acceptStuffOffer2')
AddEventHandler('acceptStuffOffer2', function(id)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		stuffchecker = true
	end
end)