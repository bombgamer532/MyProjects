local coords = {
--[[{-647.71228, 181.15038, 4.81676, 179.734390258789, 0},
{-1445.61182, 1363.60083, 20.57771, 270.148773193359, 0},
{973.04865, -616.02338, 14.22853, 270.0302734375, 0}]]
}
local airblip = {}
local tables = {}

local opponent = -1
local cam = nil
local puck = nil
local puck2 = nil
local playerped = nil
local playerpaddle = nil
local playerpaddle2 = nil
local enemyped = nil
local enemypaddle = nil
local enemypaddle2 = nil
local tablepos = {}
local side = 0
local playermove = {0.0, 0.0}
local enemymove = {0.0, 0.0}

local playerscore = 0
local enemyscore = 0

GetHeading = function(x1, y1, x2, y2)
	local Xdist = GetDistanceBetweenCoords2d(x1, 0, x2, 0)
	if(x2 < x1) then
		Xdist = -Xdist
	end
	local Ydist = GetDistanceBetweenCoords2d(0, y1, 0, y2)
	if(y2 < y1) then
		Ydist = -Ydist
	end
	return GetHeadingFromVector2d(Xdist, Ydist)
	--return math.deg(math.atan((y2 - y1)/(x2 - x1)))
end

local puckpos = nil
local puckvel = nil
local dist = 0
local pucknetid = nil
RegisterNetEvent('sharePuck')
AddEventHandler('sharePuck', function(id, netid)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		pucknetid = netid
	end
end)
--[[CreateThread(function()
	while true do
		Wait(0)
		if(opponent > -1) then
			if pucknetid then
				if(DoesPlayerHaveControlOfNetworkId(opponent, pucknetid)) then
					Citizen.Trace("opponent control")
					Wait(1000)
					while not RequestControlOfNetworkId(pucknetid) do
						Wait(0)
						RequestControlOfNetworkId(pucknetid)
					end
					dist = 0.0
					if(DoesObjectExistWithNetworkId(pucknetid)) then
						local ox,oy,oz = GetObjectCoordinates(GetObjectFromNetworkId(pucknetid))
						puckpos = {ox, oy, oz}
					end
					Citizen.Trace("player control")
				end
			end
		end
	end
end)]]

CreateThread(function()
	while true do
		Wait(0)
		RequestAnims("mini_air")
		if(opponent == -1) then
			for i=1,#coords,1 do
				if(not DoesObjectExist(tables[i])) then
					tables[i] = SpawnObject(GetHashKey("e2_air_hoc"), coords[i][1], coords[i][2], coords[i][3]-1, coords[i][4])
					FreezeObjectPosition(tables[i], true)
					SetObjectCollision(tables[i], true)
					--SetObjectDrawLast(tables[i], true)
					
					airblip[i] = AddBlipForCoord(coords[i][1], coords[i][2], coords[i][3])
					ChangeBlipSprite(airblip[i], 82)
					ChangeBlipColour(airblip[i], 3)
					ChangeBlipScale(airblip[i], 0.7)
					ChangeBlipNameFromAscii(airblip[i], "Air hockey")
					SetBlipAsShortRange(airblip[i], true)
				else
					local ox,oy,oz = GetObjectCoordinates(tables[i])
					if(IsPlayerNearCoords(ox, oy, oz, 5)) then
						PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to play air hockey", 1000, 1)
						if(IsGameKeyboardKeyJustPressed(18)) then
							for i=0,31,1 do
								if(IsNetworkPlayerActive(i)) then
									if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
										if(not IsPlayerDead(i)) then
											local px,py,pz = GetCharCoordinates(GetPlayerChar(i))
											if(GetDistanceBetweenCoords3d(px, py, pz, ox, oy, oz) < 5) then
												local oh = GetObjectHeading(tables[i])
												local pos1 = {ox+2*math.cos(math.rad(oh+90)), oy+2*math.sin(math.rad(oh+90)), oz, oh}
												local pos2 = {ox+2*math.cos(math.rad(oh-90)), oy+2*math.sin(math.rad(oh-90)), oz, oh+180}
												local tp = {ox, oy, oz, oh}
												TriggerServerEvent('sendAirOffer', i, ConvertIntToPlayerindex(GetPlayerId()), pos1, pos2, tp)
												TriggerEvent('chatMessage', '[Air hockey]', {255, 255, 0}, 'Air hockey offer sent to ' .. GetPlayerName(i) .. '.')
												goto out
											end
										end
									end
								end
							end
							TriggerEvent('chatMessage', '[Air hockey]', {255, 0, 0}, 'There is nobody near this table to play with.')
							::out::
						end
					end
				end
			end
			if(DoesCamExist(cam)) then
				SetCamActive(cam, false)
				SetCamPropagate(cam, 0)
				SetCamPropagate(GetGameCam(), 1)
				ActivateScriptedCams(0, 0)
				DestroyCam(cam)
			end
		else
			if(not IsCharDead(GetPlayerChar(GetPlayerId()))) then
				if(not DoesCamExist(cam)) then
					cam = CreateCam(14)
					SetCamPropagate(cam, 1)
					SetCamActive(cam, true)
					ActivateScriptedCams(1, 1)
					if(side == 1) then
						SetCamPos(cam,
						tablepos[1]+1*math.cos(math.rad(tablepos[4]-90)),
						tablepos[2]+1*math.sin(math.rad(tablepos[4]-90)),
						tablepos[3]+2)
					else
						SetCamPos(cam,
						tablepos[1]+1*math.cos(math.rad(tablepos[4]+90)),
						tablepos[2]+1*math.sin(math.rad(tablepos[4]+90)),
						tablepos[3]+2)
					end
					PointCamAtCoord(cam, tablepos[1], tablepos[2], tablepos[3])
				end
				TaskPlayAnimWithFlagsAndStartPhase(playerped, "strike", "mini_air", 8.0, 0, 0, playermove[2])
				SetCharAnimSpeed(playerped, "MINI_AIR", "strike", 0.00000000)
				TaskPlayAnimWithFlagsAndStartPhase(enemyped, "strike", "mini_air", 8.0, 0, 0, enemymove[2])
				SetCharAnimSpeed(enemyped, "MINI_AIR", "strike", 0.00000000)
				if(side == 1) then
					SetTextScale(0.4000000,  0.8000000)
					SetTextDropshadow(0, 0, 0, 0, 0)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextFont(6)
					SetTextCentre(1)
					--SetTextWrap(0.0, 0.5)
					DisplayTextWithLiteralString(0.5, 0.95, "STRING", "~b~" .. playerscore .. " ~w~: ~r~" .. enemyscore)
					
					SetCharHeading(playerped, tablepos[4])
					local ph = GetCharHeading(playerped)
					SetCharCoordinates(playerped,
					tablepos[1]+1.35*math.cos(math.rad(tablepos[4]-90))+playermove[1]*math.cos(math.rad(ph)),
					tablepos[2]+1.35*math.sin(math.rad(tablepos[4]-90))+playermove[1]*math.sin(math.rad(ph)),
					tablepos[3])
					
					SetCharHeading(enemyped, tablepos[4]+180.0)
					local ph = GetCharHeading(enemyped)
					SetCharCoordinates(enemyped,
					tablepos[1]+1.35*math.cos(math.rad(tablepos[4]+90))+enemymove[1]*math.cos(math.rad(ph)),
					tablepos[2]+1.35*math.sin(math.rad(tablepos[4]+90))+enemymove[1]*math.sin(math.rad(ph)),
					tablepos[3])
				else
					SetTextScale(0.4000000,  0.8000000)
					SetTextDropshadow(0, 0, 0, 0, 0)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextFont(6)
					SetTextCentre(1)
					--SetTextWrap(0.0, 0.5)
					DisplayTextWithLiteralString(0.5, 0.95, "STRING", "~b~" .. enemyscore .. " ~w~: ~r~" .. playerscore)
					
					SetCharHeading(playerped, tablepos[4]+180.0)
					local ph = GetCharHeading(playerped)
					SetCharCoordinates(playerped,
					tablepos[1]+1.35*math.cos(math.rad(tablepos[4]+90))+playermove[1]*math.cos(math.rad(ph)),
					tablepos[2]+1.35*math.sin(math.rad(tablepos[4]+90))+playermove[1]*math.sin(math.rad(ph)),
					tablepos[3])
					
					SetCharHeading(enemyped, tablepos[4])
					local ph = GetCharHeading(enemyped)
					SetCharCoordinates(enemyped,
					tablepos[1]+1.35*math.cos(math.rad(tablepos[4]-90))+enemymove[1]*math.cos(math.rad(ph)),
					tablepos[2]+1.35*math.sin(math.rad(tablepos[4]-90))+enemymove[1]*math.sin(math.rad(ph)),
					tablepos[3])
				end
				if(DoesObjectExist(playerpaddle)) then
					if(DoesObjectExist(puck)) then
					--if(pucknetid and DoesObjectExistWithNetworkId(pucknetid)) then
					--	local puck = GetObjectFromNetworkId(pucknetid)
						--[[if(IsGameKeyboardKeyJustPressed(18)) then
							dist = 0.0
							SetObjectInitialVelocity(puck, 0, 0, 0)
							SetObjectCoordinates(puck, tablepos[1], tablepos[2], tablepos[3]+0.82)
							local ox,oy,oz = GetObjectCoordinates(puck)
							puckpos = {ox, oy, oz}
						end]]
						--SetObjectRecordsCollisions(puck, true)
						--if(HasObjectCollidedWithAnything(puck)) then
							local ox,oy,oz = GetObjectCoordinates(puck)
							--[[if(oz <= GetGroundZFor3dCoord(ox, oy, oz)) then
								SetObjectCoordinates(puck, tablepos[1], tablepos[2], tablepos[3]+0.82)
							end]]
							if(oz>tablepos[3]+0.83 or oz<tablepos[3]+0.81) then
								SetObjectCoordinates(puck, ox, oy, tablepos[3]+0.82)
							elseif(oz < tablepos[3]+0.5) then
								SetObjectCoordinates(puck, tablepos[1], tablepos[2], tablepos[3]+0.82)
							end
							local vx,vy,vz = GetObjectVelocity(puck)
							if(dist == 0) then
								dist = 100*GetDistanceBetweenCoords2d(puckpos[1], puckpos[2], ox, oy)
								if(dist > 0) then
									if(dist > 3) then
										dist = 3
									end
									local dir = GetHeading(puckpos[1], puckpos[2], ox, oy)
									--Citizen.Trace(dist .. ", " .. dir)
									SetObjectInitialVelocity(puck, dist*math.cos(math.rad(dir+90)), dist*math.sin(math.rad(dir+90)), vz)
									puckpos = {ox, oy, oz}
								end
							else
								dist = dist - 0.005
								if(dist > 0.01) then
									local dir = GetHeading(puckpos[1], puckpos[2], ox, oy)
									--Citizen.Trace(dist .. ", " .. dir)
									SetObjectInitialVelocity(puck, dist*math.cos(math.rad(dir+90)), dist*math.sin(math.rad(dir+90)), vz)
								else
									dist = 0.0
								end
								puckpos = {ox, oy, oz}
							end
							local ox,oy,oz = GetObjectCoordinates(puck)
							local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
							local ex,ey,ez = GetCharCoordinates(GetPlayerChar(opponent))
							if(GetDistanceBetweenCoords3d(ox, oy, oz, px, py, pz) < 1.1) then
								if(enemyscore < 3) then
									enemyscore = enemyscore + 1
									TriggerServerEvent('updateAirScore', opponent, playerscore, enemyscore)
									dist = 0.0
									SetObjectInitialVelocity(puck, 0, 0, 0)
									SetObjectCoordinates(puck, tablepos[1], tablepos[2], tablepos[3]+0.82)
									local ox,oy,oz = GetObjectCoordinates(puck)
									puckpos = {ox, oy, oz}
								else
									TriggerServerEvent('finishAir2', opponent)
									Wait(1000)
								end
							elseif(GetDistanceBetweenCoords3d(ox, oy, oz, ex, ey, ez) < 1.1) then
								if(playerscore < 3) then
									playerscore = playerscore + 1
									TriggerServerEvent('updateAirScore', opponent, playerscore, enemyscore)
									dist = 0.0
									SetObjectInitialVelocity(puck, 0, 0, 0)
									SetObjectCoordinates(puck, tablepos[1], tablepos[2], tablepos[3]+0.82)
									local ox,oy,oz = GetObjectCoordinates(puck)
									puckpos = {ox, oy, oz}
								else
									TriggerEvent('finishAir2', ConvertIntToPlayerindex(GetPlayerId()))
									Wait(1000)
								end
							end
							--[[if(puckvel[1]~=0 or puckvel[2]~=0) then
								SetObjectInitialVelocity(puck, puckvel[1], puckvel[2], 0)
							end
							local vx,vy,vz = GetObjectVelocity(puck)
							Citizen.Trace(vx .. ", " .. vy .. ", " .. vz)
							if(vx ~= 0) then
								if(vx > 0) then
									vx = vx - 0.0001
								else
									vx = vx + 0.0001
								end
								if(math.abs(vx) < 0.001) then
									vx = 0.0
								end
							end
							if(vy ~= 0) then
								if(vy > 0) then
									vy = vy - 0.0001
								else
									vy = vy + 0.0001
								end
								if(math.abs(vy) < 0.001) then
									vy = 0.0
								end
							end
							puckvel[1] = 5*vx
							puckvel[2] = 5*vy]]
							--[[local vx,vy,vz = GetObjectVelocity(puck)
							Citizen.Trace(vx .. ", " .. vy .. ", " .. vz)
							if(puckvel[1] == 0) then
								if(vx ~= 0) then
									puckvel[1] = vx
								end
							else
								--if(math.abs(vx) > math.abs(puckvel[1])) then
								--	puckvel[1] = vx
								--else
									if(puckvel[1] > 0) then
										puckvel[1] = puckvel[1] - 0.0001
									else
										puckvel[1] = puckvel[1] + 0.0001
									end
									if(math.abs(puckvel[1]) < 0.001) then
										puckvel[1] = 0.0
									end
								--end
							end
							if(puckvel[2] == 0) then
								if(vy ~= 0) then
									puckvel[2] = vy
								end
							else
								--if(math.abs(vy) > math.abs(puckvel[2])) then
								--	puckvel[2] = vy
								--else
									if(puckvel[2] > 0) then
										puckvel[2] = puckvel[2] - 0.0001
									else
										puckvel[2] = puckvel[2] + 0.0001
									end
									if(math.abs(puckvel[2]) < 0.001) then
										puckvel[2] = 0.0
									end
								--end
							end
							SetObjectInitialVelocity(puck, puckvel[1], puckvel[2], 0)]]
							--[[if(vx ~= 0) then
								if vx < 0.1 then
									vx = 0.1
								elseif vx > -0.1 then
									vx = -0.1
								elseif vx > 5 then
									vx = 5
								elseif vx < -5 then
									vx = -5
								end
							end
							if(vy ~= 0) then
								if vy < 0.1 then
									vy = 0.1
								elseif vy > -0.1 then
									vy = -0.1
								elseif vy > 5 then
									vy = 5
								elseif vy < -5 then
									vy = -5
								end
							end
							Citizen.Trace(vx .. ", " .. vy .. ", " .. vz)
							SetObjectInitialVelocity(puck, 5*vx*0.9, 5*vy*0.9, 0)]]
							--ApplyForceToObject(puck, true, vx, vy, 0, 0, 0, 0, true, false, true, true)
						--end
						--local vx,vy,vz = GetObjectVelocity(puck)
						--SetObjectInitialVelocity(puck, vx, vy, -0.1)
						--[[local ox,oy,oz = GetObjectCoordinates(puck)
						local dist = GetDistanceBetweenCoords3d(puckpos[1], puckpos[2], puckpos[3], ox, oy, oz)
						if(dist > 0) then
							local dir = GetHeading(puckpos[1], puckpos[2], ox, oy)
							Citizen.Trace(dist .. ", " .. dir)
							SetObjectInitialVelocity(puck,
							10*dist*math.cos(math.rad(dir+90)),
							10*dist*math.sin(math.rad(dir+90)),
							0)
							ApplyForceToObject(puck, true, 11*dist*math.cos(math.rad(dir+90)), 11*dist*math.sin(math.rad(dir+90)), 0, 0, 0, 0, true, false, true, true)
							puckpos = {ox, oy, oz}
						end]]
						SetObjectPhysicsParams(puck, 0.1, 10.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0)
						--SetObjectInitialVelocity(puck, 1.1, 1.1, 0)
						SetActivateObjectPhysicsAsSoonAsItIsUnfrozen(puck, true)
						FreezeObjectPosition(puck, false)
						if(DoesObjectExist(puck)) then
							SetObjectRotation(puck, 0, 0, 0)
						end
					end
					if(DoesCharExist(playerped)) then
						local px,py,pz = GetCharCoordinates(playerped)
						local ph = GetCharHeading(playerped)
						SetActivateObjectPhysicsAsSoonAsItIsUnfrozen(playerpaddle, true)
						FreezeObjectPosition(playerpaddle, false)
						SetObjectRotation(playerpaddle, 0, 0, 0)
						--[[SetObjectCoordinates(playerpaddle,
						px+(0.5+playermove[2]*0.8)*math.cos(math.rad(ph+90)),
						py+(0.5+playermove[2]*0.8)*math.sin(math.rad(ph+90)),
						pz-0.18)]]
						SlideObject(playerpaddle,
						px+(0.5+playermove[2]*0.8)*math.cos(math.rad(ph+90)),
						py+(0.5+playermove[2]*0.8)*math.sin(math.rad(ph+90)),
						pz-0.18,
						10.1, 10.1, 10.1, true)
					end
					if(DoesCharExist(enemyped)) then
						local px,py,pz = GetCharCoordinates(enemyped)
						local ph = GetCharHeading(enemyped)
						SetActivateObjectPhysicsAsSoonAsItIsUnfrozen(enemypaddle, true)
						FreezeObjectPosition(enemypaddle, false)
						SetObjectRotation(enemypaddle, 0, 0, 0)
						SlideObject(enemypaddle,
						px+(0.5+enemymove[2]*0.8)*math.cos(math.rad(ph+90)),
						py+(0.5+enemymove[2]*0.8)*math.sin(math.rad(ph+90)),
						pz-0.18,
						10.1, 10.1, 10.1, true)
					end
					--[[local vx,vy,vz = GetObjectVelocity(puck)
					if(vx~=0 or vy~=0) then
						SetObjectInitialVelocity(puck, vx*0.9, vy*0.9, vz)
					end]]
				end
				--[[local px,py,pz = GetCharCoordinates(enemyped)
				local ph = GetCharHeading(enemyped)
				SetObjectCoordinates(enemypaddle,
				px+(0.5+enemymove[2]*0.8)*math.cos(math.rad(ph+90)),
				py+(0.5+enemymove[2]*0.8)*math.sin(math.rad(ph+90)),
				pz)]]
				
				local mx,my = GetMouseInput()
				if(mx > 0) then
					if(mx > 10000) then
						mx = mx - 4294967296
					end
					playermove[1] = playermove[1] + mx/500
					if(playermove[1] > 0.5) then
						playermove[1] = 0.5
					elseif(playermove[1] < -0.5) then
						playermove[1] = -0.5
					end
					TriggerServerEvent('updateAirAnim', opponent, playermove)
				end
				if(my > 0) then
					if(my > 10000) then
						my = my - 4294967296
					end
					playermove[2] = playermove[2] - my/500
					if(playermove[2] > 1.0) then
						playermove[2] = 1.0
					elseif(playermove[2] < 0.0) then
						playermove[2] = 0.0
					end
					TriggerServerEvent('updateAirAnim', opponent, playermove)
				end
				
				--[[if(DoesObjectExist(puck)) then
					local ox,oy,oz = GetObjectCoordinates(puck)
					--if(oz < tablepos[3]+0.5) then
						local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
						local ex,ey,ez = GetCharCoordinates(GetPlayerChar(opponent))
						if(GetDistanceBetweenCoords3d(ox, oy, oz, px, py, pz) < 1.1) then
							if(enemyscore < 3) then
								enemyscore = enemyscore + 1
								TriggerServerEvent('updateAirScore', opponent, playerscore, enemyscore)
								dist = 0.0
								SetObjectInitialVelocity(puck, 0, 0, 0)
								SetObjectCoordinates(puck, tablepos[1], tablepos[2], tablepos[3]+0.82)
								local ox,oy,oz = GetObjectCoordinates(puck)
								puckpos = {ox, oy, oz}
							else
								TriggerServerEvent('finishAir2', opponent)
								Wait(1000)
							end
						elseif(GetDistanceBetweenCoords3d(ox, oy, oz, ex, ey, ez) < 1.1) then
							if(playerscore < 3) then
								playerscore = playerscore + 1
								TriggerServerEvent('updateAirScore', opponent, playerscore, enemyscore)
								dist = 0.0
								SetObjectInitialVelocity(puck, 0, 0, 0)
								SetObjectCoordinates(puck, tablepos[1], tablepos[2], tablepos[3]+0.82)
								local ox,oy,oz = GetObjectCoordinates(puck)
								puckpos = {ox, oy, oz}
							else
								TriggerEvent('finishAir2', ConvertIntToPlayerindex(GetPlayerId()))
								Wait(1000)
							end
						end
					--end
				end]]
			else
				if(IsNetworkPlayerActive(opponent)) then
					TriggerServerEvent('finishAir2', opponent)
					Wait(1000)
				else
					TriggerEvent('finishAir2', ConvertIntToPlayerindex(GetPlayerId()))
					Wait(1000)
				end
			end
		end
	end
end)

local airchecker = false
RegisterNetEvent('sendAirOffer')
AddEventHandler('sendAirOffer', function(id, sender, pos1, pos2, tp)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		CreateThread(function()
			DrawWindow("Someone offers to play air hockey with you", {"Accept " .. GetPlayerName(sender) .. "'s offer"})
			while menuactive do
				Wait(0)
			end
			if(menuresult > 0) then
				RequestAnims("mini_air")
				while not HaveAnimsLoaded("mini_air") do
					Wait(0)
					RequestAnims("mini_air")
				end
				local model = GetHashKey("cj_paddle_1")
				RequestModel(model)
				while not HasModelLoaded(model) do
					Wait(0)
					RequestModel(model)
				end
				local model = GetHashKey("cj_paddle_2")
				RequestModel(model)
				while not HasModelLoaded(model) do
					Wait(0)
					RequestModel(model)
				end
				local model = GetHashKey("bm_coaster01")
				RequestModel(model)
				while not HasModelLoaded(model) do
					Wait(0)
					RequestModel(model)
				end
				local model = GetHashKey("bm_candlestick5")
				RequestModel(model)
				while not HasModelLoaded(model) do
					Wait(0)
					RequestModel(model)
				end
				local model = GetHashKey("cj_puck")
				RequestModel(model)
				while not HasModelLoaded(model) do
					Wait(0)
					RequestModel(model)
				end
				airchecker = false
				Settimerc(0)
				pos1 = {pos1[1]+0.0, pos1[2]+0.0, pos1[3]+0.0, pos1[4]+0.0}
				pos2 = {pos2[1]+0.0, pos2[2]+0.0, pos2[3]+0.0, pos2[4]+0.0}
				tp = {tp[1]+0.0, tp[2]+0.0, tp[3]+0.0, tp[4]+0.0}
				TriggerServerEvent('acceptAirOffer', sender, id, pos1, pos2, tp)
				while not airchecker do
					Wait(0)
					if(Timerc() >= 10000) then
						FreezeCharPosition(GetPlayerChar(GetPlayerId()), false)
						goto out
					end
				end
				tablepos = tp
				DeleteObject(puck)
				DeleteObject(puck2)
				DeleteChar(puckped)
				puck = SpawnObject(GetHashKey("bm_coaster01"), tp[1], tp[2], tp[3]+0.82, 0.0)
				SetNetworkIdCanMigrate(GetNetworkIdFromObject(puck), true)
				SetNetworkIdExistsOnAllMachines(GetNetworkIdFromObject(puck), true)
				--TriggerServerEvent('sharePuck', sender, GetNetworkIdFromObject(puck))
				SetObjectVisible(puck, false)
				puck2 = SpawnObject(GetHashKey("cj_puck"), tp[1], tp[2], tp[3]+0.82, 0.0)
				SetNetworkIdExistsOnAllMachines(GetNetworkIdFromObject(puck2), true)
				SetNetworkIdCanMigrate(GetNetworkIdFromObject(puck), true)
				SetNetworkIdCanMigrate(GetNetworkIdFromObject(puck2), true)
				AttachObjectToObject(puck2, puck, 0, 0, 0, 0, 0, 0, 0)
				puckped = ClonePed(GetPlayerChar(GetPlayerId()))
				SetNetworkIdCanMigrate(GetNetworkIdFromPed(puckped), true)
				SetNetworkIdExistsOnAllMachines(GetNetworkIdFromPed(puckped), true)
				SetCharVisible(puckped, false)
				AttachPedToObject(puckped, puck, 0, 0, 0, 0, 0, 0, false, false)
				local ox,oy,oz = GetObjectCoordinates(puck)
				puckpos = {ox, oy, oz}
				local vx,vy,vz = GetObjectVelocity(puck)
				puckvel = {vx, vy, vz}
				dist = 0.0
				playerscore = 0
				enemyscore = 0
				--SetObjectCollision(puck, true)
				--SetObjectRecordsCollisions(puck, true)
				--SetObjectDynamic(puck, true)
				
				DeleteChar(playerped)
				playerped = ClonePed(GetPlayerChar(GetPlayerId()))
				SetPedStopCloning(playerped, true)
				SetNetworkIdStopCloning(GetNetworkIdFromPed(playerped), true)
				FreezeCharPosition(playerped, true)
				SetCharCoordinates(playerped, pos2[1], pos2[2], pos2[3])
				SetCharHeading(playerped, pos2[4])
				DeleteObject(playerpaddle)
				DeleteObject(playerpaddle2)
				local px,py,pz = GetCharCoordinates(playerped)
				local ph = GetCharHeading(playerped)
				playerpaddle = SpawnObject(GetHashKey("bm_candlestick5"), px+1*math.cos(math.rad(ph+90)), py+1*math.sin(math.rad(ph+90)), pz, ph)
				SetObjectStopCloning(playerpaddle, true)
				SetNetworkIdStopCloning(GetNetworkIdFromObject(playerpaddle), true)
				SetObjectVisible(playerpaddle, false)
				playerpaddle2 = SpawnObject(GetHashKey("cj_paddle_1"), px+1*math.cos(math.rad(ph+90)), py+1*math.sin(math.rad(ph+90)), pz, ph)
				SetObjectStopCloning(playerpaddle2, true)
				SetNetworkIdStopCloning(GetNetworkIdFromObject(playerpaddle2), true)
				AttachObjectToObject(playerpaddle2, playerpaddle, 0, 0, 0, 0, 0, 0, 0)
				--FreezeObjectPosition(playerpaddle, true)
				--SetObjectCollision(playerpaddle, true)
				--SetObjectDynamic(playerpaddle, true)
				
				DeleteChar(enemyped)
				enemyped = ClonePed(GetPlayerChar(sender))
				SetPedStopCloning(enemyped, true)
				SetNetworkIdStopCloning(GetNetworkIdFromPed(enemyped), true)
				FreezeCharPosition(enemyped, true)
				SetCharCoordinates(enemyped, pos1[1], pos1[2], pos1[3])
				SetCharHeading(enemyped, pos1[4])
				DeleteObject(enemypaddle)
				DeleteObject(enemypaddle2)
				local px,py,pz = GetCharCoordinates(enemyped)
				local ph = GetCharHeading(enemyped)
				enemypaddle = SpawnObject(GetHashKey("bm_candlestick5"), px+1*math.cos(math.rad(ph+90)), py+1*math.sin(math.rad(ph+90)), pz, ph)
				SetObjectStopCloning(enemypaddle, true)
				SetNetworkIdStopCloning(GetNetworkIdFromObject(enemypaddle), true)
				SetObjectVisible(enemypaddle, false)
				enemypaddle2 = SpawnObject(GetHashKey("cj_paddle_2"), px+1*math.cos(math.rad(ph+90)), py+1*math.sin(math.rad(ph+90)), pz, ph)
				SetObjectStopCloning(enemypaddle2, true)
				SetNetworkIdStopCloning(GetNetworkIdFromObject(enemypaddle2), true)
				AttachObjectToObject(enemypaddle2, enemypaddle, 0, 0, 0, 0, 0, 0, 0)
				--FreezeObjectPosition(enemypaddle, true)
				--SetObjectCollision(enemypaddle, true)
				--SetObjectDynamic(enemypaddle, true)
				
				SetPlayerControl(GetPlayerId(), false)
				FreezeCharPosition(GetPlayerChar(GetPlayerId()), true)
				SetCurrentCharWeapon(GetPlayerChar(GetPlayerId()), 0, true)
				SetCharCoordinates(GetPlayerChar(GetPlayerId()), pos2[1], pos2[2], pos2[3])
				SetCharHeading(GetPlayerChar(GetPlayerId()), pos2[4])
				SetCharVisible(GetPlayerChar(GetPlayerId()), false)
				--TaskPlayAnimWithFlags(GetPlayerChar(GetPlayerId()), "attack", "mini_air", 8.0, 0, 0)
				side = 1
				playermove = {0.0, 0.0}
				enemymove = {0.0, 0.0}
				opponent = sender
				::out::
			else
				--FreezeCharPosition(GetPlayerChar(GetPlayerId()), false)
				TriggerServerEvent('sendMessageToPlayer2', sender, "[Air hockey]", "Your offer has been declined.")
			end
		end)
	end
end)
RegisterNetEvent('acceptAirOffer')
AddEventHandler('acceptAirOffer', function(id, sender, pos1, pos2, tp)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		CreateThread(function()
			RequestAnims("mini_air")
			while not HaveAnimsLoaded("mini_air") do
				Wait(0)
				RequestAnims("mini_air")
			end
			local model = GetHashKey("cj_paddle_1")
			RequestModel(model)
			while not HasModelLoaded(model) do
				Wait(0)
				RequestModel(model)
			end
			local model = GetHashKey("bm_candlestick5")
			RequestModel(model)
			while not HasModelLoaded(model) do
				Wait(0)
				RequestModel(model)
			end
			local model = GetHashKey("cj_paddle_2")
			RequestModel(model)
			while not HasModelLoaded(model) do
				Wait(0)
				RequestModel(model)
			end
			TriggerServerEvent('acceptAirOffer2', sender)
			pos1 = {pos1[1]+0.0, pos1[2]+0.0, pos1[3]+0.0, pos1[4]+0.0}
			pos2 = {pos2[1]+0.0, pos2[2]+0.0, pos2[3]+0.0, pos2[4]+0.0}
			tp = {tp[1]+0.0, tp[2]+0.0, tp[3]+0.0, tp[4]+0.0}
			tablepos = tp
			puckpos = {tp[1], tp[2], tp[3]+0.82}
			
			DeleteChar(playerped)
			playerped = ClonePed(GetPlayerChar(GetPlayerId()))
			SetPedStopCloning(playerped, true)
			SetNetworkIdStopCloning(GetNetworkIdFromPed(playerped), true)
			FreezeCharPosition(playerped, true)
			SetCharCoordinates(playerped, pos1[1], pos1[2], pos1[3])
			SetCharHeading(playerped, pos1[4])
			DeleteObject(playerpaddle)
			DeleteObject(playerpaddle2)
			local px,py,pz = GetCharCoordinates(playerped)
			local ph = GetCharHeading(playerped)
			playerpaddle = SpawnObject(GetHashKey("bm_candlestick5"), px+1*math.cos(math.rad(ph+90)), py+1*math.sin(math.rad(ph+90)), pz, ph)
			SetObjectStopCloning(playerpaddle, true)
			SetNetworkIdStopCloning(GetNetworkIdFromObject(playerpaddle), true)
			SetObjectVisible(playerpaddle, false)
			playerpaddle2 = SpawnObject(GetHashKey("cj_paddle_2"), px+1*math.cos(math.rad(ph+90)), py+1*math.sin(math.rad(ph+90)), pz, ph)
			SetObjectStopCloning(playerpaddle2, true)
			SetNetworkIdStopCloning(GetNetworkIdFromObject(playerpaddle2), true)
			AttachObjectToObject(playerpaddle2, playerpaddle, 0, 0, 0, 0, 0, 0, 0)
			--FreezeObjectPosition(playerpaddle, true)
			--SetObjectCollision(playerpaddle, true)
			--SetObjectDynamic(playerpaddle, true)
			
			DeleteChar(enemyped)
			enemyped = ClonePed(GetPlayerChar(sender))
			SetPedStopCloning(enemyped, true)
			SetNetworkIdStopCloning(GetNetworkIdFromPed(enemyped), true)
			FreezeCharPosition(enemyped, true)
			SetCharCoordinates(enemyped, pos2[1], pos2[2], pos2[3])
			SetCharHeading(enemyped, pos2[4])
			DeleteObject(enemypaddle)
			DeleteObject(enemypaddle2)
			local px,py,pz = GetCharCoordinates(enemyped)
			local ph = GetCharHeading(enemyped)
			enemypaddle = SpawnObject(GetHashKey("bm_coaster01"), px+1*math.cos(math.rad(ph+90)), py+1*math.sin(math.rad(ph+90)), pz, ph)
			SetObjectStopCloning(enemypaddle, true)
			SetNetworkIdStopCloning(GetNetworkIdFromObject(enemypaddle), true)
			SetObjectVisible(enemypaddle, false)
			enemypaddle2 = SpawnObject(GetHashKey("cj_paddle_1"), px+1*math.cos(math.rad(ph+90)), py+1*math.sin(math.rad(ph+90)), pz, ph)
			SetObjectStopCloning(enemypaddle2, true)
			SetNetworkIdStopCloning(GetNetworkIdFromObject(enemypaddle2), true)
			AttachObjectToObject(enemypaddle2, enemypaddle, 0, 0, 0, 0, 0, 0, 0)
			--FreezeObjectPosition(enemypaddle, true)
			--SetObjectCollision(enemypaddle, true)
			--SetObjectDynamic(enemypaddle, true)
			
			SetPlayerControl(GetPlayerId(), false)
			FreezeCharPosition(GetPlayerChar(GetPlayerId()), true)
			SetCurrentCharWeapon(GetPlayerChar(GetPlayerId()), 0, true)
			SetCharCoordinates(GetPlayerChar(GetPlayerId()), pos1[1], pos1[2], pos1[3])
			SetCharHeading(GetPlayerChar(GetPlayerId()), pos1[4])
			SetCharVisible(GetPlayerChar(GetPlayerId()), false)
			--TaskPlayAnimWithFlags(GetPlayerChar(GetPlayerId()), "defend", "mini_air", 8.0, 0, 0)
			side = -1
			playermove = {0.0, 0.0}
			enemymove = {0.0, 0.0}
			opponent = sender
		end)
	end
end)
RegisterNetEvent('acceptAirOffer2')
AddEventHandler('acceptAirOffer2', function(id)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		airchecker = true
	end
end)

RegisterNetEvent('updateAirAnim')
AddEventHandler('updateAirAnim', function(id, m)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		enemymove = {m[1]+0.0, m[2]+0.0}
	end
end)

RegisterNetEvent('updateAirScore')
AddEventHandler('updateAirScore', function(id, ps, es)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		playerscore = ps
		enemyscore = es
	end
end)

RegisterNetEvent('finishAir')
AddEventHandler('finishAir', function(id)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		money = money - 100
		SaveStats()
		TriggerServerEvent('sendAirReward', opponent, 100, ConvertIntToPlayerindex(GetPlayerId()))
		DrawMessage("~r~Air hockey lost", "" .. GetPlayerName(opponent) .. " has won the air hockey.")
		--TriggerEvent('chatMessage', '[Air hockey]', {255, 255, 0}, 'You have paid a bet of ' .. racebet .. '$ to ' .. GetPlayerName(outrunrival))
		TriggerEvent('chatMessage', '[Air hockey]', {255, 255, 0}, 'You have paid 100$ to ' .. GetPlayerName(opponent) .. ".")
		--SetCharVisible(GetPlayerChar(opponent), true)
		--ForceNetPlayerInvisible(opponent, 0)
		SetCharVisible(GetPlayerChar(GetPlayerId()), true)
		opponent = -1
		DeleteChar(playerped)
		DeleteChar(enemyped)
		DeleteObject(puck)
		DeleteObject(puck2)
		DeleteObject(playerpaddle)
		DeleteObject(playerpaddle2)
		DeleteObject(enemypaddle)
		DeleteObject(enemypaddle2)
		SetPlayerControl(GetPlayerId(), true)
		FreezeCharPosition(GetPlayerChar(GetPlayerId()), false)
		ClearCharTasksImmediately(GetPlayerChar(GetPlayerId()))
	end
end)
RegisterNetEvent('finishAir2')
AddEventHandler('finishAir2', function(id)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		DrawMessage("~y~Air hockey won", "You have won the air hockey!")
		TriggerServerEvent('finishAir', opponent)
		SetCharVisible(GetPlayerChar(GetPlayerId()), true)
		opponent = -1
		DeleteChar(playerped)
		DeleteChar(enemyped)
		DeleteObject(puck)
		DeleteObject(puck2)
		DeleteObject(playerpaddle)
		DeleteObject(playerpaddle2)
		DeleteObject(enemypaddle)
		DeleteObject(enemypaddle2)
		SetPlayerControl(GetPlayerId(), true)
		FreezeCharPosition(GetPlayerChar(GetPlayerId()), false)
		ClearCharTasksImmediately(GetPlayerChar(GetPlayerId()))
	end
end)

RegisterNetEvent('sendAirReward')
AddEventHandler('sendAirReward', function(id, amount, sender)
	if(ConvertIntToPlayerindex(GetPlayerId()) == ConvertIntToPlayerindex(id)) then
		money = money + amount
		SaveStats()
		TriggerEvent('chatMessage', '[Air hockey]', {0, 255, 0}, 'You have received ' .. amount .. '$ from ' .. GetPlayerName(sender) .. ".")
	end
end)