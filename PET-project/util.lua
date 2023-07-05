peds = {}
vehs = {}
objs = {}
blips = {}

RegisterNetEvent('restartScript')
AddEventHandler('restartScript', function(script)
	TerminateAllScriptsWithThisName(script)
	RequestScript(script)
	while not HasScriptLoaded(script) do
		Wait(0)
	end
	StartNewScript(script, 1024)
end)

RestartScript = function(script)
	TerminateAllScriptsWithThisName(script)
	RequestScript(script)
	while not HasScriptLoaded(script) do
		Wait(0)
	end
	StartNewScript(script, 1024)
	--Wait(1000)
end

local update = false
CreateThread(function()
	while true do
		Wait(0)
		if update then
			::again::
			update = false
			Wait(1000)
			if update then
				goto again
			end
			--TriggerServerEvent('restartScript', "cleanup")
			RestartScript("cleanup")
		end
	end
end)

SpawnCar = function(model, x, y, z, h)
	update = true
	RequestModel(model)
	while not HasModelLoaded(model) do 
		Wait(0)
		RequestModel(model)
	end
	local veh = exports.cleanup:SpawnCar(model, x, y, z, h)
	SetCarVisible(veh, false)
	SetCarCollision(veh, false)
	local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
	SetCarCoordinates(veh, px, py, pz)
	MarkCarAsNoLongerNeeded(veh)
	Wait(0)
	SetCarAsMissionCar(veh, true)
	SetNetworkIdCanMigrate(GetNetworkIdFromVehicle(veh), false)
	--RequestCollisionAtPosn(x, y, z)
	SetCarCoordinates(veh, x, y, z)
	SetCarVisible(veh, true)
	SetCarCollision(veh, true)
	return veh
end

SpawnPed = function(model, x, y, z, h, k)
	update = true
	RequestModel(model)
	while not HasModelLoaded(model) do 
		Wait(0)
		RequestModel(model)
	end
	local ped = exports.cleanup:SpawnPed(model, x, y, z, h, k)
	SetCharVisible(ped, false)
	SetCharCollision(ped, false)
	local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
	SetCharCoordinates(ped, px, py, pz)
	MarkCharAsNoLongerNeeded(ped)
	Wait(0)
	SetCharAsMissionChar(ped, true)
	SetNetworkIdCanMigrate(GetNetworkIdFromPed(ped), false)
	--RequestCollisionAtPosn(x, y, z)
	SetCharCoordinates(ped, x, y, z)
	SetCharVisible(ped, true)
	SetCharCollision(ped, true)
	return ped
end

SpawnRandomPed = function(model, x, y, z, h, k)
	update = true
	return exports.cleanup:SpawnRandomPed(model, x, y, z, h, k)
end

SpawnObject = function(model, x, y, z, h, k)
	update = true
	RequestModel(model)
	while not HasModelLoaded(model) do 
		Wait(0)
		RequestModel(model)
	end
	return exports.cleanup:SpawnObject(model, x, y, z, h, k)
end
------------------------------------------------
DisplaySprite = function(txd, texture, x, y, sx, sy, rot, r, g, b, a)
	RequestStreamedTxd(txd)
	while not HasStreamedTxdLoaded(txd) do
		Wait(0)
		RequestStreamedTxd(txd)
	end
	local texture = GetTextureFromStreamedTxd(txd, texture)
	DrawSpriteWithFixedRotation(texture, x, y, sx, sy, rot, r, g, b, a)
end

WorldToScreen = function(x, y, z)
	if(not DoesObjectExist(tempobj)) then
		local model = GetHashKey("cj_can_drink_1")
		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(0)
		end
		tempobj = CreateObjectNoOffset(model, x, y, z, _i, 1)
		SetObjectVisible(tempobj, false)
	end
	SetObjectCoordinates(tempobj, x, y, z)
	if(IsObjectOnScreen(tempobj)) then
		local bv,cx,cy = GetViewportPositionOfCoord(x, y, z, GetGameViewportId(_i), _f, _f)
		local sx,sy = GetScreenResolution(_i, _i)
		if(cx>0 and cx<sx) then
			cx = cx/sx
		else
			return false,0,0
		end
		if(cy>0 and cy<sy) then
			cy = cy/sy
		else
			return false,0,0
		end
		return true,cx,cy
	else
		return false,0,0
	end
end

DrawMessage = function(title, text, duration)
	local messagetime = 0
	if duration then
		messagetime = duration
	else
		messagetime = 10000
	end
	local message = true
	CreateThread(function()
		Wait(messagetime)
		message = false
	end)
	CreateThread(function()
		while message do
			Wait(0)
			DrawRectLeftTopCenter(0.0, 0.2, 1.0, 0.15, 0, 0, 0, 100)
			
			SetTextScale(0.500000, 1.0000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			SetTextFont(3)
			--SetTextEdge(1, 0, 0, 0, 255)
			--SetTextWrap(0.0, 0.85)
			SetTextCentre(1)
			DisplayTextWithLiteralString(0.5, 0.21, "STRING", "" .. title)
			
			SetTextScale(0.1500000,  0.3000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			--SetTextFont(4)
			--SetTextEdge(1, 0, 0, 0, 255)
			--SetTextWrap(0.0, 0.85)
			SetTextCentre(1)
			DisplayTextWithLiteralString(0.5, 0.31, "STRING", "" .. text)
		end
	end)
end

local signal = false
local signaltime = 0
DrawSignal = function(x, y, z, text, duration)
	signaltime = 0
	if duration then
		signaltime = duration
	else
		signaltime = 1000
	end
	signal = true
	CreateThread(function()
		while signal do
			Wait(0)
			local bv,cx,cy = WorldToScreen(x, y, z)
			if bv then
				SetTextScale(0.1500000, 0.3000000)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextWrap(0.0, cx)
				SetTextCentre(1)
				DisplayTextWithLiteralString(cx, cy, "STRING", "" .. text)
			end
		end
	end)
end
DrawSignalAttached = function(text, duration)
	signaltime = 0
	if duration then
		signaltime = duration
	else
		signaltime = 1000
	end
	signal = true
	CreateThread(function()
		while signal do
			Wait(0)
			local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
			local bv,cx,cy = WorldToScreen(px, py, pz)
			if bv then
				SetTextScale(0.1500000, 0.3000000)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextWrap(0.0, cx)
				SetTextCentre(1)
				DisplayTextWithLiteralString(cx, cy, "STRING", "" .. text)
			end
		end
	end)
end
CreateThread(function()
	while true do
		Wait(0)
		if signal then
			Wait(signaltime)
			signal = false
		end
	end
end)
--------------------------------------------------------
gamemode = 0
gmid = 0

missionstarted = 0
--currmission = 0
--currstage = 0

CleanMission = function()
	missionstarted = 0
	--currmission = 0
	--currstage = 0
	for i in pairs(peds) do
		DeleteChar(peds[i])
		peds[i] = nil
	end
	for i in pairs(vehs) do
		DeleteCar(vehs[i])
		vehs[i] = nil
	end
	for i in pairs(objs) do
		DeleteObject(objs[i])
		objs[i] = nil
	end
	for i in pairs(blips) do
		RemoveBlip(blips[i])
		blips[i] = nil
	end
	objective = ""
end

CreateThread(function()
	while true do
		Wait(0)
		if(missionstarted == 1) then
			for i in pairs(peds) do
				if(DoesCharExist(peds[i])) then
					if(IsCharDead(peds[i])) then
						for j=0,31,1 do
							if(IsNetworkPlayerActive(j)) then
								if(HasCharBeenDamagedByChar(peds[i], GetPlayerChar(j), false)) then
									if(coop[j]==ConvertIntToPlayerindex(GetPlayerId()) or ConvertIntToPlayerindex(j)==ConvertIntToPlayerindex(GetPlayerId())) then
										local px,py,pz = GetCharCoordinates(peds[i])
										TriggerServerEvent('awardPedKill', j, px, py, pz)
										ClearCharLastDamageEntity(peds[i])
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
RegisterNetEvent('awardPedKill')
AddEventHandler('awardPedKill', function(id, x, y, z)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		DrawSignal(x, y, z, "+25EXP")
		experience = experience + 25
		SaveStats()
	end
end)

playermode = {}
for i=0,31,1 do
	playermode[i] = {0, 0}
end
RegisterNetEvent('updModes')
AddEventHandler('updModes', function(modes)
	playermode = modes
end)
CreateThread(function()
	while true do
		Wait(0)
		for i=0,31,1 do
			if(playermode[i][1] > 0) then
				if(not IsNetworkPlayerActive(i)) then
					playermode[i] = {0, 0}
				end
			end
		end
	end
end)

preps = {}
for i=1,7,1 do
	preps[i] = {}
	for j=1,5,1 do
		preps[i][j] = 0
	end
end
RegisterNetEvent('updPreps')
AddEventHandler('updPreps', function(data)
	for i=1,#preps,1 do
		if(data[i] == nil) then
			data[i] = {}
			for j=1,5,1 do
				data[i][j] = 0
			end
		end
		for j=1,5,1 do
			preps[i][j] = tonumber(data[i][j])
		end
	end
end)
SavePreps = function()
	local data = {}
	for i=1,#preps,1 do
		data[i] = preps[i]
	end
	TriggerServerEvent('savePreps', data)
end

money = 0
org = 0
experience = 0
clan = "0"
bonusday = 0
sm = 0
clanowned = 0
storage = 0
cargo = 0
tutorial = 0
supporter = 0
kills = 0
deaths = 0
RegisterNetEvent('updStats')
AddEventHandler('updStats', function(data)
	money = tonumber(data[1]) or 0
	org = tonumber(data[2]) or 0
	experience = tonumber(data[3]) or 0
	clan = tostring(data[4]) or "0"
	if(type(tonumber(data[4])) == "number") then
		data[4] = "0"
	end
	bonusday = tonumber(data[5]) or 0
	sm = tonumber(data[6]) or 0
	clanowned = tonumber(data[7]) or 0
	storage = tonumber(data[8]) or 0
	cargo = tonumber(data[9]) or 0
	tutorial = tonumber(data[10]) or 0
	if(tutorial == 0) then
		if(experience >= 1800) then
			tutorial = 1
		end
	end
	supporter = tonumber(data[11]) or 0
	kills = tonumber(data[12]) or 0
	deaths = tonumber(data[13]) or 0
	
	if(clan ~= "0") then
		TriggerServerEvent('requestClanName', clan)
	end
end)
local savechanged = 0
SaveStats = function()
	if(IsScreenFadedIn()) then
		savechanged = 1
		local data = {}
		data[1] = money
		data[2] = org
		data[3] = experience
		data[4] = clan
		data[5] = bonusday
		data[6] = sm
		data[7] = clanowned
		data[8] = storage
		data[9] = cargo
		data[10] = tutorial
		data[11] = supporter
		data[12] = kills
		data[13] = deaths
		
		TriggerServerEvent('saveStats', data)
	end
end
CreateThread(function()
	while true do
		Wait(0)
		if(loginform == 0) then
			local tk = GenerateRandomIntInRange(1000, 10000)
			local tc = money + tk
			local te = experience + tk
			Wait(1000)
			if(savechanged == 0) then
				money = tc - tk
				experience = te - tk
			else
				savechanged = 0
			end
		end
	end
end)

local spawned = 0
RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function()
	if(spawned == 0) then
		local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
		local angle = GenerateRandomIntInRange(0, 360, _i)
		local radius = GenerateRandomIntInRange(1, 3000, _i)
		local rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
		SetCharCoordinates(GetPlayerChar(GetPlayerId()), rx, ry, rz)
		spawned = 1
	end
end)

CreateThread(function()
	local point = false
	while true do
		Wait(0)
		RequestAnims("cop_search_idles")
		local ped = GetPlayerChar(GetPlayerId())
		if((not IsCharDead(ped)) and (not IsCharInAnyCar(ped)) and (not IsPedRagdoll(ped)) and (not IsPlayerTargettingAnything(GetPlayerId())) and (not IsCharInAir(ped))) then
			local gw,cw = GetCurrentCharWeapon(ped)
			if(cw == 0) then
				if(IsGameKeyboardKeyJustPressed(34)) then
					if not point then
						point = true
					else
						point = false
					end
				end
				if point then
					TaskPlayAnimWithFlagsAndStartPhase(ped, "idle_point", "cop_search_idles", 4.00000000, 1, 1, 1, 0, 0)
					SetCharAnimCurrentTime(ped, "cop_search_idles", "idle_point", 0.62)
					local rx,ry,rz = GetCamRot(GetGameCam())
					SetCharHeading(ped, rz)
				end
			else
				point = false
			end
		else
			point = false
		end
	end
end)

--[[CreateThread(function()
	while true do
		Wait(0)
		local ped = GetPlayerChar(GetPlayerId())
		if(not IsCharDead(ped)) then
			if(not IsPedRagdoll(ped)) then
				if(not IsCharInAir(ped)) then
					local gw,cw = GetCurrentCharWeapon(ped)
					if(cw==16 or cw==17 or cw==35) then
						if(IsControlPressed(0, 87)) then
							if(IsControlPressed(0, 40)) then
								if(not IsCharPlayingAnim(ped, "move_player", "walk")) then
									TaskPlayAnimSecondaryNoInterrupt(ped, "walk", "move_player", 10000.00000000, 0, 0, 1, 0, 0)
								end
							elseif(IsControlPressed(0, 41)) then
								if(not IsCharPlayingAnim(ped, "move_player", "walk_strafe_b")) then
									TaskPlayAnimSecondaryNoInterrupt(ped, "walk_strafe_b", "move_player", 10000.00000000, 0, 0, 1, 0, 0)
								end
							elseif(IsControlPressed(0, 144)) then
								if(not IsCharPlayingAnim(ped, "move_player", "walk_strafe_r")) then
									TaskPlayAnimSecondaryNoInterrupt(ped, "walk_strafe_r", "move_player", 10000.00000000, 0, 0, 1, 0, 0)
								end
							elseif(IsControlPressed(0, 143)) then
								if(not IsCharPlayingAnim(ped, "move_player", "walk_strafe_l")) then
									TaskPlayAnimSecondaryNoInterrupt(ped, "walk_strafe_l", "move_player", 10000.00000000, 0, 0, 1, 0, 0)
								end
							end
						end
					end
				end
			end
		end
	end
end)]]
CreateThread(function()
	while true do
		Wait(0)
		local ped = GetPlayerChar(GetPlayerId())
		if(not IsCharDead(ped)) then
			if(not IsPedRagdoll(ped)) then
				if(not IsCharInAir(ped)) then
					local gw,cw = GetCurrentCharWeapon(ped)
					if(cw==16 or cw==17 or cw==35) then
						if(IsControlPressed(0, 87)) then
							local px,py,pz = GetCharCoordinates(ped)
							local ph = GetCharHeading(ped)
							local angle = nil
							if(IsControlPressed(0, 40)) then
								if(IsControlPressed(0, 144)) then
									angle = ph+45
								elseif(IsControlPressed(0, 143)) then
									angle = ph+135
								else
									angle = ph+90
								end
								--SetCharVelocity(ped, 1*math.cos(math.rad(ph+90)), 1*math.sin(math.rad(ph+90)), 0)
							elseif(IsControlPressed(0, 41)) then
								if(IsControlPressed(0, 144)) then
									angle = ph-45
								elseif(IsControlPressed(0, 143)) then
									angle = ph-135
								else
									angle = ph-90
								end
								--SetCharVelocity(ped, -1*math.cos(math.rad(ph+90)), -1*math.sin(math.rad(ph+90)), 0)
							elseif(IsControlPressed(0, 144)) then
								angle = ph
								--SetCharVelocity(ped, 1*math.cos(math.rad(ph)), 1*math.sin(math.rad(ph)), 0)
							elseif(IsControlPressed(0, 143)) then
								angle = ph+180
								--SetCharVelocity(ped, -1*math.cos(math.rad(ph)), -1*math.sin(math.rad(ph)), 0)
							end
							if angle then
								SetCharVelocity(ped, 2*math.cos(math.rad(angle)), 2*math.sin(math.rad(angle)), 0)
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
		if(IsPlayerControlOn(GetPlayerId())) then
			if(not IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
				BlockPedWeaponSwitching(GetPlayerChar(GetPlayerId()), true)
				local gw,cw = GetCurrentCharWeapon(GetPlayerChar(GetPlayerId()))
				local weps = {}
				for i=0,46,1 do
					if(HasCharGotWeapon(GetPlayerChar(GetPlayerId()), i)) then
						weps[#weps+1] = i
					end
				end
				--if(GetMouseWheel() ~= 0) then
				--	if(GetMouseWheel() == 127) then
				--if(not IsMouseButtonPressed(2)) then
				if(not IsControlPressed(0, 87)) then
					if(IsControlJustPressed(0, 8)) then
						for i=1,#weps,1 do
							if(weps[i] == cw) then
								if weps[i+1] then
									SetCurrentCharWeapon(GetPlayerChar(GetPlayerId()), weps[i+1], true)
								else
									SetCurrentCharWeapon(GetPlayerChar(GetPlayerId()), weps[1], true)
								end
								break
							end
						end
					end
					if(IsControlJustPressed(0, 9)) then
						for i=1,#weps,1 do
							if(weps[i] == cw) then
								if weps[i-1] then
									SetCurrentCharWeapon(GetPlayerChar(GetPlayerId()), weps[i-1], true)
								else
									SetCurrentCharWeapon(GetPlayerChar(GetPlayerId()), weps[#weps], true)
								end
								break
							end
						end
					end
				end
			else
				BlockPedWeaponSwitching(GetPlayerChar(GetPlayerId()), false)
			end
		end
	end
end)

local gunfire = {
{7, "gun@handgun", 0.83, 0.9, 300},
{9, "gun@deagle", 0.83, 0.92, 300},
{10, "gun@shotgun", 0.45, 0.89},
{11, "gun@baretta", 0.86, 0.92, 200},
{12, "gun@uzi", 0.85, 0.90, 100},
{13, "gun@mp5k", 0.8, 0.85, 100},
{14, "gun@ak47", 0.8, 0.85, 200},
{15, "gun@ak47", 0.8, 0.85, 200},
{22, "gun@test_gun", 0.82, 0.85, 300},
{26, "gun@sawnoff", 0.71, 0.78},
{27, "gun@cz75", 0.82, 0.85, 100},
{29, "gun@44A", 0.76, 0.85, 300},
{30, "gun@aa12", 0.7, 0.75, 300},
{31, "gun@aa12", 0.7, 0.75, 300},
{32, "gun@p90", 0.8, 0.85, 100},
{33, "gun@GOLD_UZI", 0.8, 0.85, 100},
{34, "gun@m249", 0.8, 0.85, 100}
}
CreateThread(function()
	while true do
		Wait(0)
		if(IsControlPressed(0, 87)) then
			if(IsControlPressed(0, 4)) then
				local ped = GetPlayerChar(GetPlayerId())
				local gw,cw = GetCurrentCharWeapon(ped)
				for i=1,#gunfire,1 do
					if(cw == gunfire[i][1]) then
						local ammo = GetAmmoInClip(ped, cw)
						if(type(ammo) == "number") then
							if(ammo > 0) then
								if(not IsCharDucking(ped)) then
									if(GetCharAnimCurrentTime(ped, gunfire[i][2], "fire") >= gunfire[i][4]) then
										SetCharAnimCurrentTime(ped, gunfire[i][2], "fire", gunfire[i][3])
									end
								else
									if(GetCharAnimCurrentTime(ped, gunfire[i][2], "fire_crouch") >= gunfire[i][4]) then
										SetCharAnimCurrentTime(ped, gunfire[i][2], "fire_crouch", gunfire[i][3])
									end
								end
							end
							break
						end
					end
				end
			end
		end
	end
end)
CreateThread(function()
	local anims = {
	{"jump_std", "jump_takeoff_l"},
	{"jump_std", "jump_takeoff_r"},
	{"jump_rifle", "jump_takeoff_l"},
	{"jump_rifle", "jump_takeoff_r"}
	}
	while true do
		Wait(0)
		local ped = GetPlayerChar(GetPlayerId())
		for i=1,#anims,1 do
			if(IsCharPlayingAnim(ped, anims[i][1], anims[i][2])) then
				if(GetCharAnimCurrentTime(ped, anims[i][1], anims[i][2]) > 0.9) then
					Wait(100)
					if(IsCharPlayingAnim(ped, anims[i][1], anims[i][2])) then
						ClearCharTasksImmediately(ped)
					end
				end
			end
		end
	end
end)
CreateThread(function()
	while true do
		Wait(0)
		--[[if(GetPlayerName(GetPlayerId()) == "vlados") then
			if(IsGameKeyboardKeyJustPressed(18)) then
				local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
				local ph = GetCharHeading(GetPlayerChar(GetPlayerId()))
				SpawnObject(GetHashKey("steeringwheel"), px, py, pz, ph)
			end
		end]]
		--[[RequestAnims("veh@low")
		RequestAnims("veh@low_conv")
		RequestAnims("veh@low_hi_hi")
		RequestAnims("veh@std")
		RequestAnims("veh@std_conv")
		RequestAnims("veh@std_fo1")
		RequestAnims("veh@truck")
		RequestAnims("veh@van")
		RequestAnims("veh@bike_chopper")
		RequestAnims("veh@bike_dirt")
		RequestAnims("veh@bike_freeway")
		RequestAnims("veh@bike_scooter")
		RequestAnims("veh@bike_spt")
		RequestAnims("veh@helicopter")
		RequestAnims("veh@boat_speed")
		RequestAnims("veh@boat_standing")
		RequestAnims("veh@boat_stand_big")
		RequestAnims("veh@bus")]]
		--[[if(GetPlayerName(GetPlayerId()) == "vlados") then
			for i=0,200,1 do
				if(IsControlJustPressed(0, i)) then
					Citizen.Trace("control " .. i)
				end
			end
		end]]
		--BlendOutCharMoveAnims(GetPlayerChar(GetPlayerId()))
		--ImproveLowPerformanceMissionPerFrameFlag()
		EnableMaxAmmoCap(0)
		--AllowLockonToFriendlyPlayers(ConvertIntToPlayerindex(GetPlayerId()), true)
		for i=0,31,1 do
			if(IsNetworkPlayerActive(i)) then
				SetCharNeverTargetted(GetPlayerChar(i), false)
			end
		end
		SwitchRandomTrains(1)
		AllowNetworkPopulationGroupCycling(true)
		SetDeadPedsDropWeapons(false)
		if(loginform == 0) then
			SetMultiplayerHudCash(math.floor(money))
			if(not IsGameKeyboardKeyPressed(42)) then
				SetNetworkWalkModeEnabled(false)
			else
				SetNetworkWalkModeEnabled(true)
			end
			SetTextScale(0.200000,  0.4000000)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextFont(3)
			SetTextCentre(1)
			--DisplayTextWithLiteralString(0.95, 0.005, "STRING", "IV: ~r~Online")
			DisplayTextWithLiteralString(0.95, 0.005, "STRING", "~b~IV: ~y~Online")
			
			if(not IsGameKeyboardKeyPressed(59)) then
				SetTextScale(0.1500000,  0.3000000)
				--SetTextEdge(1, 0, 0, 0, 255)
				--SetTextFont(3)
				--SetTextCentre(1)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextColour(255, 255, 255, 100)
				DisplayTextWithLiteralString(0.005, 0.975, "STRING", "F1 - Hotkeys")
			else
				SetTextScale(0.1500000,  0.3000000)
				--SetTextEdge(1, 0, 0, 0, 255)
				--SetTextFont(3)
				--SetTextCentre(1)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextColour(255, 255, 255, 100)
				DisplayTextWithLiteralString(0.005, 0.95, "STRING", "I - Player menu")
				SetTextScale(0.1500000,  0.3000000)
				--SetTextEdge(1, 0, 0, 0, 255)
				--SetTextFont(3)
				--SetTextCentre(1)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextColour(255, 255, 255, 100)
				DisplayTextWithLiteralString(0.005, 0.975, "STRING", "Arrow Up - Phone")
				SetTextScale(0.1500000,  0.3000000)
				--SetTextEdge(1, 0, 0, 0, 255)
				--SetTextFont(3)
				--SetTextCentre(1)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextColour(255, 255, 255, 100)
				DisplayTextWithLiteralString(0.105, 0.975, "STRING", "B - First Person View")
				SetTextScale(0.1500000,  0.3000000)
				--SetTextEdge(1, 0, 0, 0, 255)
				--SetTextFont(3)
				--SetTextCentre(1)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextColour(255, 255, 255, 100)
				DisplayTextWithLiteralString(0.105, 0.95, "STRING", "Z - Weapon selector")
				SetTextScale(0.1500000,  0.3000000)
				--SetTextEdge(1, 0, 0, 0, 255)
				--SetTextFont(3)
				--SetTextCentre(1)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextColour(255, 255, 255, 100)
				DisplayTextWithLiteralString(0.205, 0.975, "STRING", "N - Voice chat")
				SetTextScale(0.1500000,  0.3000000)
				--SetTextEdge(1, 0, 0, 0, 255)
				--SetTextFont(3)
				--SetTextCentre(1)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextColour(255, 255, 255, 100)
				DisplayTextWithLiteralString(0.205, 0.95, "STRING", "G - Finger point")
			end
			
			if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
				local blip = GetFirstBlipInfoId(8)
				if(DoesBlipExist(blip)) then
					local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
					local bp = GetBlipCoords(blip)
					local dist = math.floor(CalculateTravelDistanceBetweenNodes(px, py, pz, bp.x, bp.y, bp.z))
					SetTextScale(0.1500000,  0.3000000)
					--SetTextEdge(1, 0, 0, 0, 255)
					--SetTextFont(3)
					--SetTextCentre(1)
					SetTextDropshadow(0, 0, 0, 0, 0)
					SetTextColour(255, 255, 0, 255)
					DisplayTextWithLiteralString(0.005, 0.925, "STRING", "" .. dist .. "m")
				end
			end
		end
		ClearAreaOfCars(278.99063, 172.13618, -0.77399, 50.1)
		ClearAreaOfCars(-1645.67883, -189.1911, -0.43195, 50.1)
		ClearAreaOfCars(-923.29694, -259.46829, -0.7037, 50.1)
		if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
			SetVehicleDirtLevel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), 0.0)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(sm == 1) then
			RequestStreamedTxd("speedometer")
			while not HasStreamedTxdLoaded("speedometer") do
				Wait(0)
			end
			speedometer = GetTextureFromStreamedTxd("speedometer", "speedometer")
			tahometer = GetTextureFromStreamedTxd("speedometer", "tahometer")
			arrow = GetTextureFromStreamedTxd("speedometer", "arrow")
			indicator = GetTextureFromStreamedTxd("speedometer", "indicator")
			if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
				if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i) == GetPlayerChar(GetPlayerId())) then
					DrawSprite(speedometer, 0.9, 0.95, 0.09, 0.18, 0.0, 255, 255, 255, 255)
					--[[local carhp = GetCarHealth(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i)
					if(carhp >= 500) then
						DrawSpriteWithFixedRotation(indicator, 0.9, 0.92, 0.02, 0.01, 0.0, math.floor(255/(500/(1001-carhp))), 255, 0, 255)
					else
						DrawSpriteWithFixedRotation(indicator, 0.9, 0.92, 0.02, 0.01, 0.0, 255, math.floor(255/(500/carhp+1)), 0, 255)
					end]]
					--local speedinmeters = GetCarSpeed(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _f)
					if(IsCharInCar(GetPlayerChar(GetPlayerId()), car)) then
						for i=1,#carinfo,1 do
							if(IsCarModel(car, carinfo[i][3])) then
								SetTextScale(0.1500000,  0.3000000)
								SetTextDropshadow(0, 0, 0, 0, 0)
								SetTextFont(6)
								SetTextColour(255, 255, 0, 255)
								SetTextCentre(1)
								SetTextWrap(0.0, 0.9)
								DisplayTextWithLiteralString(0.9, 0.92, "STRING", "" .. math.floor(mileage[i]*10)/10)
								break
							end
						end
					end
					local speedinmeters = GetCharSpeed(GetPlayerChar(GetPlayerId()), _f)
					local speed = math.floor(speedinmeters*3600/1000)
					DrawSpriteWithFixedRotation(arrow, 0.9, 0.95, 0.13, 0.26, -10.1+((190.0/320)*speed), 255, 255, 255, 255)
					
					DrawSprite(tahometer, 0.8, 0.95, 0.09, 0.18, 0.0, 255, 255, 255, 255)
					local gear = GetVehicleGear(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i))
					if(gear > 0) then
						SetTextScale(0.200000,  0.4000000)
						SetTextDropshadow(0, 0, 0, 0, 0)
						SetTextFont(6)
						SetTextColour(255, 255, 0, 255)
						SetTextCentre(1)
						SetTextWrap(0.0, 0.8)
						DisplayTextWithLiteralString(0.8, 0.9, "STRING", "" .. gear)
					else
						SetTextScale(0.200000,  0.4000000)
						SetTextDropshadow(0, 0, 0, 0, 0)
						SetTextFont(6)
						SetTextColour(255, 255, 0, 255)
						SetTextCentre(1)
						SetTextWrap(0.0, 0.8)
						DisplayTextWithLiteralString(0.8, 0.9, "STRING", "R")
					end
					revs = GetVehicleEngineRevs(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i))
					--if(type(revs) == "number") then
						--revs = 9000*revs
					--else
					--	revs = 0
					--end
					DrawSpriteWithFixedRotation(arrow, 0.8, 0.95, 0.13, 0.26, -10.1+((240.0)*revs-50), 255, 255, 255, 255)
				end
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(GetCharHealth(GetPlayerChar(GetPlayerId()), _i) < 150) then
			Wait(5000)
			SetCharHealth(GetPlayerChar(GetPlayerId()), GetCharHealth(GetPlayerChar(GetPlayerId()), _i) + 5)
		end
	end
end)

local playerblips = {}
CreateThread(function()
	while true do
		Wait(0)
		for i=0,31,1 do
			if(IsNetworkPlayerActive(i)) then
				if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
					--if(IsCharVisible(GetPlayerChar(i))) then
						if(not DoesBlipExist(playerblips[i])) then
							playerblips[i] = AddBlipForChar(GetPlayerChar(i, _i), _i)
							ChangeBlipSprite(playerblips[i], 6)
							ChangeBlipNameFromAscii(playerblips[i], "" .. GetPlayerName(i, _s))
							ChangeBlipColour(playerblips[i], GetPlayerColour(i))
							SetBlipAsShortRange(playerblips[i], true)
							ChangeBlipScale(playerblips[i], 0.7)
						else
							if(not IsPauseMenuActive()) then
								local rx,ry,rz = GetCamRot(GetGameCam(), _f, _f, _f)
								ChangeBlipRotation(playerblips[i], math.floor(GetCharHeading(GetPlayerChar(i, _i), _f) + 90 - rz))
							else
								ChangeBlipRotation(playerblips[i], math.floor(GetCharHeading(GetPlayerChar(i, _i), _f) + 90))
							end
						end
					--[[else
						if(DoesBlipExist(playerblips[i])) then
							RemoveBlip(playerblips[i])
						end
					end]]
				end
			else
				if(DoesBlipExist(playerblips[i])) then
					RemoveBlip(playerblips[i])
				end
			end
		end
	end
end)

local fps = 0
local ping = 0
CreateThread(function()
	while true do
		Wait(1000)
		if(IsNetworkPlayerActive(GetPlayerId())) then
			fps = math.floor(1/GetFrameTime())
			if(IsGameKeyboardKeyPressed(15)) then
				TriggerServerEvent('ping')
			end
		end
	end
end)
RegisterNetEvent('ping')
AddEventHandler('ping', function(p)
	ping = p
end)
CreateThread(function()
	while true do
		Wait(0)
		if(loginform == 0) then
			if(IsGameKeyboardKeyPressed(15)) then
				DrawRectLeftTopCenter(0.4, 0.1, 0.2, 0.03, 0, 0, 0, 100)
				SetTextScale(0.1500000,  0.3000000)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextFont(6)
				SetTextEdge(1, 0, 0, 0, 255)
				--SetTextRightJustify(1)
				--SetTextWrap(0.0, 0.995)
				--SetTextCentre(1)
				DisplayTextWithLiteralString(0.41, 0.105, "STRING", "Players:_" .. GetNumberOfPlayers() .. "/32")
				SetTextScale(0.1500000,  0.3000000)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextFont(6)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextRightJustify(1)
				SetTextWrap(0.0, 0.59)
				DisplayTextWithLiteralString(0.59, 0.105, "STRING", "FPS:_" .. fps .. "_|_Ping:_" .. ping)
				local templist = {}
				local cooplist = {}
				for i=0,31,1 do
					if(IsNetworkPlayerActive(i)) then
						if(coop[ConvertIntToPlayerindex(GetPlayerId())] == -1) then
							if(coop[i] == ConvertIntToPlayerindex(GetPlayerId())) then
								cooplist[#cooplist+1] = i
							else
								templist[#templist+1] = i
							end
						elseif(i == coop[ConvertIntToPlayerindex(GetPlayerId())]) then
							cooplist[#cooplist+1] = i
						elseif(coop[i] == coop[ConvertIntToPlayerindex(GetPlayerId())]) then
							cooplist[#cooplist+1] = i
						else
							templist[#templist+1] = i
						end
					end
				end
				if(#cooplist > 0) then
					local newlist = {}
					local newcoop = {}
					for i=1,#templist,1 do
						if(templist[i] ~= ConvertIntToPlayerindex(GetPlayerId())) then
							table.insert(newlist, templist[i])
						else
							table.insert(newcoop, templist[i])
						end
					end
					templist = newlist
					for i=1,#cooplist,1 do
						table.insert(newcoop, cooplist[i])
					end
					cooplist = newcoop
				end
				local leader = -1
				if(#cooplist > 0) then
					if(coop[ConvertIntToPlayerindex(GetPlayerId())] == -1) then
						leader = ConvertIntToPlayerindex(GetPlayerId())
					else
						for i=1,#cooplist,1 do
							if(cooplist[i] == coop[ConvertIntToPlayerindex(GetPlayerId())]) then
								leader = cooplist[i]
							end
						end
					end
				end
				for i=1,#templist,1 do
					DrawRectLeftTopCenter(0.4, 0.1+0.03*i, 0.2, 0.03, 0, 0, 0, 100)
					local r,g,b = GetPlayerRgbColour(ConvertIntToPlayerindex(templist[i]), _i, _i, _i)
					if(#playercolor[ConvertIntToPlayerindex(templist[i])] > 0) then
						r = playercolor[templist[i]][1]
						g = playercolor[templist[i]][2]
						b = playercolor[templist[i]][3]
					end
					SetTextScale(0.1500000,  0.3000000)
					SetTextDropshadow(0, 0, 0, 0, 0)
					--SetTextFont(6)
					SetTextEdge(1, 0, 0, 0, 255)
					--SetTextRightJustify(1)
					--SetTextWrap(0.0, 0.995)
					SetTextCentre(1)
					SetTextColour(r, g, b, 255)
					DisplayTextWithLiteralString(0.5, 0.005+0.1+0.03*i, "STRING", "" .. GetPlayerName(templist[i]))
				end
				if(#cooplist > 0) then
					DrawRectLeftTopCenter(0.4, 0.1+0.03*(#templist+1), 0.2, 0.03, 0, 0, 0, 100)
					SetTextScale(0.1500000,  0.3000000)
					SetTextDropshadow(0, 0, 0, 0, 0)
					SetTextFont(6)
					SetTextEdge(1, 0, 0, 0, 255)
					--SetTextRightJustify(1)
					--SetTextWrap(0.0, 0.995)
					SetTextCentre(1)
					DisplayTextWithLiteralString(0.5, 0.005+0.1+0.03*(#templist+1), "STRING", "Co-op: " .. #cooplist .. " players")
					for i=1,#cooplist,1 do
						local temptext = ""
						if(cooplist[i] == leader) then
							temptext = "" .. GetPlayerName(cooplist[i]) .. " (Leader)"
						else
							temptext = "" .. GetPlayerName(cooplist[i])
						end
						DrawRectLeftTopCenter(0.4, 0.1+0.03*(#templist+1+i), 0.2, 0.03, 0, 0, 0, 100)
						local r,g,b = GetPlayerRgbColour(ConvertIntToPlayerindex(cooplist[i]), _i, _i, _i)
						if(#playercolor[ConvertIntToPlayerindex(cooplist[i])] > 0) then
							r = playercolor[cooplist[i]][1]
							g = playercolor[cooplist[i]][2]
							b = playercolor[cooplist[i]][3]
						end
						SetTextScale(0.1500000,  0.3000000)
						SetTextDropshadow(0, 0, 0, 0, 0)
						--SetTextFont(6)
						SetTextEdge(1, 0, 0, 0, 255)
						--SetTextRightJustify(1)
						--SetTextWrap(0.0, 0.995)
						SetTextCentre(1)
						SetTextColour(r, g, b, 255)
						DisplayTextWithLiteralString(0.5, 0.005+0.1+0.03*(#templist+1+i), "STRING", temptext)
					end
				end
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(not IsPlayerDead(GetPlayerId())) then
			if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
				if(not IsCharInAnyHeli(GetPlayerChar(GetPlayerId()))) then
					local speedinmeters = GetCharSpeed(GetPlayerChar(GetPlayerId()), _f)
					local speed = math.floor(speedinmeters*3600/1000)
					if(speed>=100 and speed<130) then --very slow
						SetCamComponentShake(GetGameCam(), 1, 4, 1000, 0.005, 5.1, 0)
					elseif(speed>=130 and speed<150) then --medium slow
						SetCamComponentShake(GetGameCam(), 1, 8, 1000, 0.005, 5.1, 0)
					elseif(speed>=150 and speed<170) then --slow
						SetCamComponentShake(GetGameCam(), 1, 7, 1000, 0.005, 5.1, 0)
					elseif(speed>=170 and speed<200) then --medium fast
						SetCamComponentShake(GetGameCam(), 1, 6, 1000, 0.005, 5.1, 0)
					elseif(speed>=200) then --fast
						SetCamComponentShake(GetGameCam(), 1, 5, 1000, 0.005, 5.1, 0)
					end
					Wait(1000)
				end
			end
		end
	end
end)

level = 1
CreateThread(function()
	while true do
		Wait(0)
		if(loginform == 0) then
			::again::
			DrawRect(0.5, 0.035, 0.13, 0.02, 0, 0, 0, 100)
			local expneeded = 0
			local currentexp = experience
			for i=1,level,1 do
				expneeded = expneeded + 100*i*1.2
				currentexp = currentexp - (level-i)*100*1.2
			end
			if(experience < expneeded) then
				DrawRect(0.435+(((0.13/(100*level*1.2))*currentexp)/2), 0.035, (0.13/(100*level*1.2))*currentexp, 0.02, 255, 255, 255, 255)
				SetTextScale(0.15000000,  0.3000000)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextEdge(1, 0, 0, 0, 255)
				--SetTextFont(6)
				SetTextCentre(1)
				DisplayTextWithLiteralString(0.5, 0.025, "STRING", "~w~" .. experience .. "/" .. math.floor(expneeded))
				
				SetTextScale(0.15000000,  0.3000000)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextEdge(1, 0, 0, 0, 255)
				--SetTextFont(6)
				SetTextRightJustify(1)
				SetTextWrap(0.0, 0.5-0.07)
				DisplayTextWithLiteralString(0.5-0.07, 0.025, "STRING", "~w~" .. level)
				
				SetTextScale(0.15000000,  0.3000000)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextEdge(1, 0, 0, 0, 255)
				--SetTextFont(6)
				DisplayTextWithLiteralString(0.5+0.07, 0.025, "STRING", "~w~" .. level+1)
			else
				level = level + 1
				goto again
			end
		end
	end
end)

biz = {}
bizmult = {}
bizmoney = {}
for i=1,17,1 do
	biz[i] = 0
	bizmult[i] = 1
	bizmoney[i] = 0
end
RegisterNetEvent('updBiz')
AddEventHandler('updBiz', function(data)
	for i=1,#biz,1 do
		if(data[i] == nil) then
			data[i] = 0
		end
		biz[i] = tonumber(data[i])
	end
end)
RegisterNetEvent('updBizMult')
AddEventHandler('updBizMult', function(data)
	for i=1,#bizmult,1 do
		if(data[i] == nil) then
			data[i] = 0
		end
		bizmult[i] = tonumber(data[i])
	end
end)
RegisterNetEvent('updBizMoney')
AddEventHandler('updBizMoney', function(data)
	for i=1,#bizmoney,1 do
		if(data[i] == nil) then
			data[i] = 0
		end
		bizmoney[i] = tonumber(data[i])
	end
end)
SaveBiz = function()
	local data = {}
	for i=1,#biz,1 do
		data[i] = biz[i]
	end
	TriggerServerEvent('saveBiz', data)
end
SaveBizMult = function()
	local data = {}
	for i=1,#bizmult,1 do
		data[i] = bizmult[i]
	end
	TriggerServerEvent('saveBizMult', data)
end
SaveBizMoney = function()
	local data = {}
	for i=1,#bizmoney,1 do
		data[i] = bizmoney[i]
	end
	TriggerServerEvent('saveBizMoney', data)
end

round = function(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

GetPlayerServerId = function()
	for j=0,31,1 do
		if(IsNetworkPlayerActive(j)) then
			if(GetPlayerChar(GetPlayerId(), _i) == GetPlayerChar(j, _i)) then
				return j
			end
		end
	end
end

IsPlayerNearCoords = function(x, y, z, radius)
	local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
	local X = x - px
	local Y = y - py
	local Z = z - pz
	return math.sqrt(X*X + Y*Y + Z*Z) < radius
end
IsPlayerNearCoords2 = function(px, py, pz, x, y, z, radius)
	local X = x - px
	local Y = y - py
	local Z = z - pz
	return math.sqrt(X*X + Y*Y + Z*Z) < radius
end

IsSpecificPlayerNearCoords = function(id, x, y, z, radius)
    local pos = table.pack(GetCharCoordinates(GetPlayerChar(id, _i), _f, _f, _f))
    local dist = GetDistanceBetweenCoords3d(x, y, z, pos[1], pos[2], pos[3], _f)
    if(dist < radius) then return true
    else return false
    end
end

IsPedNearPlayer = function(ped, pp, radius)
    local pos1 = table.pack(GetCharCoordinates(ped, _f, _f, _f))
	local pos2 = table.pack(GetCharCoordinates(pp, _f, _f, _f))
    local dist = GetDistanceBetweenCoords3d(pos2[1], pos2[2], pos2[3], pos1[1], pos1[2], pos1[3], _f);
    if(dist < radius) then return true
    else return false
    end
end

IsPedNearCoords = function(ped, x, y, z, radius)
    local pos = table.pack(GetCharCoordinates(ped, _f, _f, _f))
    local dist = GetDistanceBetweenCoords3d(x, y, z, pos[1], pos[2], pos[3], _f)
    if(dist < radius) then return true
    else return false
    end
end

local objective = ""
SetObjective = function(text)
	objective = text
end
GetCurrentObjective = function()
	if(missionstarted == 1) then
		return objective
	else
		return ""
	end
end
CreateThread(function()
	while true do
		Wait(0)
		if(objective ~= nil) then
			if(missionstarted == 1) then
				if(objective ~= "") then
					SetTextScale(0.1500000, 0.3000000)
					SetTextDropshadow(0, 0, 0, 0, 0)
					SetTextEdge(1, 0, 0, 0, 255)
					DisplayTextWithLiteralString(0.2, 0.95, "STRING", "" .. objective)
				end
			end
		end
	end
end)

AttackPlayer = function(ped)
	if(not IsCharDead(ped)) then
		if(not IsPedInCombat(ped)) then
			TaskCombat(ped, GetPlayerChar(GetPlayerId()))
		end
	end
end

DrawRectLeftTopCenter = function(x, y, width, height, r, g, b, a)
	DrawRect(x+width/2, y+height/2, width, height, r, g, b, a)
end

menuactive = false
menuresult = 0
currlist = 1
currbutton = 0
DrawWindow = function(title, items, colors)
	menuactive = true
	menuresult = 0
	--currlist = 1
	currbutton = 0
	cursor = 1
	SetCamActive(GetGameCam(), false)
	SetPlayerControl(GetPlayerId(), false)
	--items[#items+1] = "~r~Cancel"
	CreateThread(function()
		while menuactive do
			Wait(0)
			SetPlayerControl(GetPlayerId(), false)
			local tempcancel = 0
			for i=1,#items,1 do
				if(items[i] == "~r~Cancel") then
					tempcancel = tempcancel + 1
					if(tempcancel > 1) then
						items[i] = nil
					end
				end
			end
			
			SetTextScale(0.200000,  0.4000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			SetTextFont(6)
			--SetTextEdge(1, 0, 0, 0, 255)
			SetTextWrap(0.0, 0.85)
			SetTextCentre(1)
			DisplayTextWithLiteralString(0.85, 0.065, "STRING", GetStringWithoutSpaces("" .. title))
			
			DrawRectLeftTopCenter(0.75, 0.05, 0.2, 0.05, 0, 0, 100, 255)
			--DrawCurvedWindow(0.3, 0.28, 0.4, 0.42, 100)
			--DrawRectLeftTopCenter(0.7, 0.1, 0.2, 0.3, 90, 90, 90, 100)
			currbutton = 0
			if(#items > 0) then
				if(#items > 10) then
					local templist = {}
					local number = #items
					local finalnum = 0
					
					::retry::
					finalnum = finalnum + 1
					number = number - 10
					if(number > 10) then
						goto retry
					else
						finalnum = finalnum + 1
					end
					
					for i=1,finalnum,1 do
						templist[i] = {}
						for j=1,10,1 do
							if(items[10*(i-1)+j] ~= nil) then
								templist[i][j] = items[10*(i-1)+j]
							end
						end
					end
					
					if(currlist > finalnum) then
						currlist = 1
					end
					
					local sep = 10
					for i=1,#templist,1 do
						if(currlist == i) then
							for j=1,#templist[i],1 do
								SetTextScale(0.1500000,  0.3000000)
								SetTextDropshadow(0, 0, 0, 0, 0)
								SetTextFont(6)
								SetTextEdge(1, 0, 0, 0, 255)
								SetTextWrap(0.0, 0.85)
								SetTextCentre(1)
								DisplayTextWithLiteralString(0.85, 0.41, "STRING", "Page:_" .. currlist .. "/" .. #templist .. "_|_LMB_-_Select_/_RMB_-_Cancel_/_Wheel_-_Scroll")
								
								if(colors~=nil and colors[10*(i-1)+j]~=nil) then
									DrawRectLeftTopCenter(0.75, 0.1+0.3/sep*(j-1), 0.2, 0.3/sep, colors[10*(i-1)+j][1], colors[10*(i-1)+j][2], colors[10*(i-1)+j][3], 100)
								else
									DrawRectLeftTopCenter(0.75, 0.1+0.3/sep*(j-1), 0.2, 0.3/sep, 0, 0, 0, 100)
								end
								SetTextScale(0.1500000,  0.3000000)
								SetTextDropshadow(0, 0, 0, 0, 0)
								--SetTextFont(6)
								--SetTextEdge(1, 0, 0, 0, 255)
								--SetTextWrap(0.0, 0.3)
								--SetTextCentre(1)
								DisplayTextWithLiteralString(0.75+0.005, 0.1+0.3/sep*(j-1)+0.005, "STRING", "" .. templist[i][j])
								if(IsCursorInAreaLeftTopCenter(0.75, 0.1+0.3/sep*(j-1), 0.2, 0.3/sep)) then
									currbutton = j+10*(i-1)
									if(colors~=nil and colors[10*(i-1)+j]~=nil) then
										DrawRectLeftTopCenter(0.75, 0.1+0.3/sep*(j-1), 0.2, 0.3/sep, colors[10*(i-1)+j][1], colors[10*(i-1)+j][2], colors[10*(i-1)+j][3], 255)
									else
										DrawRectLeftTopCenter(0.75, 0.1+0.3/sep*(j-1), 0.2, 0.3/sep, 255, 255, 255, 255)
									end
									SetTextScale(0.1500000,  0.3000000)
									SetTextDropshadow(0, 0, 0, 0, 0)
									--SetTextFont(6)
									--SetTextEdge(1, 0, 0, 0, 255)
									--SetTextWrap(0.0, 0.3)
									--SetTextCentre(1)
									SetTextColour(0, 0, 0, 255)
									DisplayTextWithLiteralString(0.75+0.005, 0.1+0.3/sep*(j-1)+0.005, "STRING", "" .. templist[i][j])
									if(IsMouseButtonJustPressed(1)) then
										if(10*(i-1)+j ~= "~r~Cancel") then
											menuresult = 10*(i-1)+j
										end
										menuactive = false
										cursor = 0
									end
								end
								if(IsGameKeyboardKeyJustPressed(j+1)) then
									if(10*(i-1)+j ~= #items) then
										menuresult = 10*(i-1)+j
									end
									menuactive = false
									cursor = 0
								end
								if(IsMouseButtonJustPressed(2)) then
									menuactive = false
									cursor = 0
								end
							end
						end
					end
					if(GetMouseWheel(_i) ~= 0) then
						if(GetMouseWheel(_i) == 127) then
							if(currlist < #templist) then
								currlist = currlist + 1
							end
						else
							if(currlist > 1) then
								currlist = currlist - 1
							end
						end
					end
				else
					local sep = 0
					if(#items <= 10) then
						sep = 10
					else
						sep = #items
					end
					for i=1,#items,1 do
						SetTextScale(0.1500000,  0.3000000)
						SetTextDropshadow(0, 0, 0, 0, 0)
						SetTextFont(6)
						SetTextEdge(1, 0, 0, 0, 255)
						SetTextWrap(0.0, 0.85)
						SetTextCentre(1)
						DisplayTextWithLiteralString(0.85, 0.1+0.3/sep*#items+0.01, "STRING", "LMB_-_Select_/_RMB_-_Cancel")
						
						if(colors~=nil and colors[i]~=nil) then
							DrawRectLeftTopCenter(0.75, 0.1+0.3/sep*(i-1), 0.2, 0.3/sep, colors[i][1], colors[i][2], colors[i][3], 100)
						else
							DrawRectLeftTopCenter(0.75, 0.1+0.3/sep*(i-1), 0.2, 0.3/sep, 0, 0, 0, 100)
						end
						SetTextScale(0.1500000,  0.3000000)
						SetTextDropshadow(0, 0, 0, 0, 0)
						--SetTextFont(6)
						--SetTextEdge(1, 0, 0, 0, 255)
						--SetTextWrap(0.0, 0.3)
						--SetTextCentre(1)
						DisplayTextWithLiteralString(0.75+0.005, 0.1+0.3/sep*(i-1)+0.005, "STRING", "" .. items[i])
						if(IsCursorInAreaLeftTopCenter(0.75, 0.1+0.3/sep*(i-1), 0.2, 0.3/sep)) then
							currbutton = i
							if(colors~=nil and colors[i]~=nil) then
								DrawRectLeftTopCenter(0.75, 0.1+0.3/sep*(i-1), 0.2, 0.3/sep, colors[i][1], colors[i][2], colors[i][3], 255)
							else
								DrawRectLeftTopCenter(0.75, 0.1+0.3/sep*(i-1), 0.2, 0.3/sep, 255, 255, 255, 255)
							end
							SetTextScale(0.1500000,  0.3000000)
							SetTextDropshadow(0, 0, 0, 0, 0)
							--SetTextFont(6)
							--SetTextEdge(1, 0, 0, 0, 255)
							--SetTextWrap(0.0, 0.3)
							--SetTextCentre(1)
							SetTextColour(0, 0, 0, 255)
							DisplayTextWithLiteralString(0.75+0.005, 0.1+0.3/sep*(i-1)+0.005, "STRING", "" .. items[i])
							if(IsMouseButtonJustPressed(1)) then
								--if(i ~= #items) then
								if(items[i] ~= "~r~Cancel") then
									menuresult = i
								end
								menuactive = false
								cursor = 0
							end
						end
						if(IsGameKeyboardKeyJustPressed(i+1)) then
							if(items[i] ~= "~r~Cancel") then
								menuresult = i
							end
							menuactive = false
							cursor = 0
						end
						if(IsMouseButtonJustPressed(2)) then
							menuactive = false
							cursor = 0
						end
					end
				end
			else
				SetTextScale(0.1500000,  0.3000000)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextFont(6)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextWrap(0.0, 0.85)
				SetTextCentre(1)
				DisplayTextWithLiteralString(0.85, 0.1+0.01, "STRING", "RMB_-_Cancel")
				
				if(IsMouseButtonJustPressed(2)) then
					menuactive = false
					cursor = 0
				end
			end
		end
		--Wait(200)
		SetCamActive(GetGameCam(), true)
		SetPlayerControl(GetPlayerId(), true)
		SetGameCameraControlsActive(true)
	end)
end

DrawTextAtCoord = function(x, y, z, text, radius)
	if(loginform == 0) then
		--local px,py,pz = GetCamPos(GetGameCam(), _f, _f, _f)
		local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
		local dist = GetDistanceBetweenCoords3d(x, y, z, px, py, pz, _f)
		local model = GetHashKey("cj_can_drink_1")
		if(not DoesObjectExist(tempobj)) then
			RequestModel(model)
			while not HasModelLoaded(model) do
				Wait(0)
			end
			tempobj = CreateObject(model, x, y, z, _i, 1)
			SetObjectVisible(tempobj, false)
		end
		if(dist < radius) then
			SetObjectCoordinates(tempobj, x, y, z)
			if(IsObjectOnScreen(tempobj)) then
				local bv,cx,cy = GetViewportPositionOfCoord(x, y, z, GetGameViewportId(_i), _f, _f)
				local sx,sy = GetScreenResolution(_i, _i)
				if(cx>0 and cx<sx) then
					cx = cx/sx
				else
					cx = 0
				end
				if(cy>0 and cy<sy) then
					cy = cy/sy
				else
					cy = 0
				end
				if(cx>0 and cy>0) then
					local mult = radius - dist
					SetTextScale(0.300000/radius*mult, 0.6000000/radius*mult)
					SetTextDropshadow(0, 0, 0, 0, 0)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextWrap(0.0, cx)
					SetTextCentre(1)
					DisplayTextWithLiteralString(cx, cy, "STRING", "" .. text)
				end
			end
		end
	end
end

RegisterNetEvent('sendMessageToPlayer')
AddEventHandler('sendMessageToPlayer', function(name, m1, m2)
	if(GetPlayerName(GetPlayerId(), _s) == name) then
		TriggerEvent('chatMessage', '' .. m1, {255, 255, 0}, '' .. m2)
	end
end)
RegisterNetEvent('sendMessageToPlayer2')
AddEventHandler('sendMessageToPlayer2', function(id, m1, m2)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		TriggerEvent('chatMessage', '' .. m1, {255, 255, 0}, '' .. m2)
	end
end)
RegisterNetEvent('sendMessageToEveryone')
AddEventHandler('sendMessageToEveryone', function(m1, m2)
	TriggerEvent('chatMessage', '' .. m1, {255, 255, 0}, '' .. m2)
end)

RegisterNetEvent('sendMessageForGamemode')
AddEventHandler('sendMessageForGamemode', function(mode, modeid, m1, m2)
	if(gamemode == mode) then
		if(gmid == modeid) then
			TriggerEvent('chatMessage', '' .. m1, {255, 255, 0}, '' .. m2)
		end
	end
end)

function IsSpecificPlayerNearCoords(id, x, y, z, radius)
    local pos = table.pack(GetCharCoordinates(GetPlayerChar(id), _f, _f, _f))
    local dist = GetDistanceBetweenCoords3d(x, y, z, pos[1], pos[2], pos[3], _f)
    if(dist < radius) then return true
    else return false
    end
end

RegisterNetEvent('setPlayerPos')
AddEventHandler('setPlayerPos', function(id, x, y, z, h)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
	--if(GetPlayerChar(id) == GetPlayerChar(GetPlayerId())) then
		if(IsCharInAnyCar(GetPlayerChar(-1))) then
			SetCarCoordinates(GetCarCharIsUsing(GetPlayerChar(-1)), x, y, z)
			SetCarHeading(GetCarCharIsUsing(GetPlayerChar(-1)), h)
			SetCarOnGroundProperly(GetCarCharIsUsing(GetPlayerChar(-1)))
		else
			SetCharCoordinates(GetPlayerChar(-1), x, y, z)
			SetCharHeading(GetPlayerChar(-1), h)
		end
	end
end)

DrawCheckpointWithDist = function(x, y, z, radius, r, g, b, a)
	if(IsPlayerNearCoords(x, y, z, 50)) then
		DrawCheckpointWithAlpha(x, y, z, radius, r, g, b, a)
	end
end

GetClosestCoordWithIndex = function(coords)
	local tempdist = {}
	local pos = table.pack(GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f))
	for i=1,#coords,1 do
		tempdist[i] = GetDistanceBetweenCoords3d(coords[i][1], coords[i][2], coords[i][3], pos[1], pos[2], pos[3], _f)
	end
	local closestdist = 100000
	local closestid = 0
	for i=1,#tempdist,1 do
		if(tempdist[i] <= closestdist) then
			closestdist = tempdist[i]
			closestid = i
		end
	end
	return closestid
end

GetClosestCoord = function(coords)
	local tempdist = {}
	local pos = table.pack(GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f))
	for i=1,#coords,1 do
		tempdist[i] = GetDistanceBetweenCoords3d(coords[i][1], coords[i][2], coords[i][3], pos[1], pos[2], pos[3], _f)
	end
	local closestdist = 100000
	local closestid = 0
	for i=1,#tempdist,1 do
		if(tempdist[i] <= closestdist) then
			closestdist = tempdist[i]
			closestid = i
		end
	end
	return {coords[closestid][1],coords[closestid][2],coords[closestid][3]}
end

GetClosestCoordFromCoordWithIndex = function(coord, coords)
	local tempdist = {}
	for i=1,#coords,1 do
		tempdist[i] = GetDistanceBetweenCoords3d(coords[i][1], coords[i][2], coords[i][3], coord[1], coord[2], coord[3])
	end
	local closestdist = 100000
	local closestid = 0
	for i=1,#tempdist,1 do
		if(tempdist[i] <= closestdist) then
			closestdist = tempdist[i]
			closestid = i
		end
	end
	return closestid
end

getClan = function()
	if(clan ~= "0") then
		if(clanname[clan]==nil or clanname[clan]=="0") then
			return "" .. clan .. "'s clan"
		else
			return "" .. clanname[clan]
		end
	else
		return ""
	end
end

local signal = false
local signaltime = 0
DrawSignal = function(x, y, z, text, duration)
	signaltime = 0
	if duration then
		signaltime = duration
	else
		signaltime = 1000
	end
	signal = true
	CreateThread(function()
		while signal do
			Wait(0)
			local model = GetHashKey("cj_can_drink_1")
			if(not DoesObjectExist(tempobj)) then
				RequestModel(model)
				while not HasModelLoaded(model) do
					Wait(0)
				end
				tempobj = CreateObject(model, x, y, z, _i, 1)
				SetObjectVisible(tempobj, false)
			end
			SetObjectCoordinates(tempobj, x, y, z)
			if(IsObjectOnScreen(tempobj)) then
				local bv,cx,cy = GetViewportPositionOfCoord(x, y, z, GetGameViewportId(_i), _f, _f)
				local sx,sy = GetScreenResolution(_i, _i)
				if(cx>0 and cx<sx) then
					cx = cx/sx
				else
					cx = 0
				end
				if(cy>0 and cy<sy) then
					cy = cy/sy
				else
					cy = 0
				end
				if(cx>0 and cy>0) then
					SetTextScale(0.1500000, 0.3000000)
					SetTextDropshadow(0, 0, 0, 0, 0)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextWrap(0.0, cx)
					SetTextCentre(1)
					DisplayTextWithLiteralString(cx, cy, "STRING", "" .. text)
				end
			end
		end
	end)
end
DrawSignalAttached = function(text, duration)
	signaltime = 0
	if duration then
		signaltime = duration
	else
		signaltime = 1000
	end
	signal = true
	CreateThread(function()
		while signal do
			Wait(0)
			local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
			local model = GetHashKey("cj_can_drink_1")
			if(not DoesObjectExist(tempobj)) then
				RequestModel(model)
				while not HasModelLoaded(model) do
					Wait(0)
				end
				tempobj = CreateObject(model, px, py, pz, _i, 1)
				SetObjectVisible(tempobj, false)
			end
			SetObjectCoordinates(tempobj, px, py, pz)
			if(IsObjectOnScreen(tempobj)) then
				local bv,cx,cy = GetViewportPositionOfCoord(px, py, pz, GetGameViewportId(_i), _f, _f)
				local sx,sy = GetScreenResolution(_i, _i)
				if(cx>0 and cx<sx) then
					cx = cx/sx
				else
					cx = 0
				end
				if(cy>0 and cy<sy) then
					cy = cy/sy
				else
					cy = 0
				end
				if(cx>0 and cy>0) then
					SetTextScale(0.1500000, 0.3000000)
					SetTextDropshadow(0, 0, 0, 0, 0)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextWrap(0.0, cx)
					SetTextCentre(1)
					DisplayTextWithLiteralString(cx, cy, "STRING", "" .. text)
				end
			end
		end
	end)
end
CreateThread(function()
	while true do
		Wait(0)
		if signal then
			Wait(signaltime)
			signal = false
		end
	end
end)

local tempwanted = 0
CreateThread(function()
	while true do
		Wait(0)
		if(not IsPlayerDead(GetPlayerId())) then
			if(StoreWantedLevel(GetPlayerId()) > 0) then
				if(tempwanted < StoreWantedLevel(GetPlayerId())) then
					tempwanted = StoreWantedLevel(GetPlayerId())
				end
			else
				if(tempwanted > 0) then
					local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
					DrawSignalAttached("+" .. 50*tempwanted .. "EXP", 3000)
					experience = experience + 50*tempwanted
					SaveStats()
					timesCopsLost = timesCopsLost + 1
					SaveDailyStats()
					tempwanted = 0
				end
			end
		else
			tempwanted = 0
		end
	end
end)

local pausestatus = {}
local talkstatus = {}
local typestatus = {}
for i=0,31,1 do
	pausestatus[i] = 0
	talkstatus[i] = 0
	typestatus[i] = 0
end
RegisterNetEvent('updatePauseStatus')
AddEventHandler('updatePauseStatus', function(id, status)
	pausestatus[id] = status
end)
RegisterNetEvent('updateTalkStatus')
AddEventHandler('updateTalkStatus', function(id, status)
	talkstatus[id] = status
end)
RegisterNetEvent('updateTypeStatus')
AddEventHandler('updateTypeStatus', function(id, status)
	typestatus[id] = status
end)
CreateThread(function()
	local pauseblock = 0
	local keyblock = 0
	while true do
		Wait(0)
		for i=0,31,1 do
			if(not IsNetworkPlayerActive(i)) then
				pausestatus[i] = 0
				talkstatus[i] = 0
				typestatus[i] = 0
			end
		end
		if(IsGameKeyboardKeyPressed(49)) then
			if(keyblock == 0) then
				keyblock = 1
				TriggerServerEvent('updateTalkStatus', ConvertIntToPlayerindex(GetPlayerId()), 1)
			end
		elseif(IsGameKeyboardKeyPressed(36)) then
			if(keyblock == 0) then
				keyblock = 1
				TriggerServerEvent('updateTalkStatus', ConvertIntToPlayerindex(GetPlayerId()), 2)
			end
		else
			if(keyblock == 1) then
				keyblock = 0
				TriggerServerEvent('updateTalkStatus', ConvertIntToPlayerindex(GetPlayerId()), 0)
			end
		end
		if(IsPauseMenuActive()) then
			if(pauseblock == 0) then
				pauseblock = 1
				TriggerServerEvent('updatePauseStatus', ConvertIntToPlayerindex(GetPlayerId()), 1)
			end
		else
			if(pauseblock == 1) then
				pauseblock = 0
				TriggerServerEvent('updatePauseStatus', ConvertIntToPlayerindex(GetPlayerId()), 0)
			end
		end
	end
end)

local playerinfo = {}
RegisterNetEvent('requestPlayerInfo')
AddEventHandler('requestPlayerInfo', function(target)
	if(IsNetworkPlayerActive(GetPlayerId())) then
		if(ConvertIntToPlayerindex(target) == ConvertIntToPlayerindex(GetPlayerId())) then
			local paused = 0
			if(IsPauseMenuActive()) then
				paused = 1
			end
			TriggerServerEvent('sendPlayerInfo', target, level, clan, paused)
		end
	end
end)
RegisterNetEvent('sendPlayerInfo')
AddEventHandler('sendPlayerInfo', function(target, l, c, p)
	--if(ConvertIntToPlayerindex(requester) == ConvertIntToPlayerindex(GetPlayerId())) then
		playerinfo[target] = {l, c, p}
	--end
end)
CreateThread(function()
	while true do
		Wait(0)
		if(IsNetworkPlayerActive(GetPlayerId())) then
			if(ConvertIntToPlayerindex(GetPlayerId()) == ConvertIntToPlayerindex(GetHostId())) then
				Wait(1000*GetNumberOfPlayers())
				for i=0,31,1 do
					if(IsNetworkPlayerActive(i)) then
						--if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
						--	local px,py,pz = GetCharCoordinates(GetPlayerChar(i))
						--	if(IsPlayerNearCoords(px, py, pz, 20)) then
								TriggerServerEvent('requestPlayerInfo', i)
						--	end
						--end
					end
				end
			end
		end
	end
end)
CreateThread(function()
	while true do
		Wait(0)
		local checker = 0
		for i=0,31,1 do
			if(IsNetworkPlayerActive(i)) then
				if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
					local px,py,pz = GetCharCoordinates(GetPlayerChar(i))
					if(IsPlayerNearCoords(px, py, pz, 20)) then
						if(playerinfo[i] ~= nil) then
							TriggerServerEvent('requestClanName', "" .. playerinfo[i][2])
							checker = 1
						end
					end
				end
			end
		end
		if(checker == 1) then
			Wait(60000)
		end
	end
end)
playercolor = {}
for i=0,31,1 do
	playercolor[i] = {}
end
RegisterNetEvent('setPlayerColor')
AddEventHandler('setPlayerColor', function(id, color)
	playercolor[id] = color
end)
CreateThread(function()
	while loginform==1 do
		Wait(0)
	end
	TriggerServerEvent('setPlayerColor', ConvertIntToPlayerindex(GetPlayerId()), {})
end)
getColor = function()
	return playercolor[ConvertIntToPlayerindex(GetPlayerId())]
end
CreateThread(function()
	while true do
		Wait(0)
		DisplayPlayerNames(false)
		if(loginform == 0) then
			for i=0,31,1 do
				if(IsNetworkPlayerActive(i)) then
					SetDisplayPlayerNameAndIcon(i, false)
					if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
						if(IsCharVisible(GetPlayerChar(i))) then
							local px,py,pz = GetCharCoordinates(GetPlayerChar(i))
							local bp = GetPedBonePosition(GetPlayerChar(i), 0x4B5, 0, 0, 0)
							px,py,pz = bp.x,bp.y,bp.z+0.5
							if(IsPlayerNearCoords(px, py, pz, 20)) then
								local model = GetHashKey("cj_can_drink_1")
								if(not DoesObjectExist(tempobj)) then
									RequestModel(model)
									while not HasModelLoaded(model) do
										Wait(0)
									end
									tempobj = CreateObject(model, px, py, pz, _i, 1)
									SetObjectVisible(tempobj, false)
								end
								SetObjectCoordinates(tempobj, px, py, pz)
								if(IsObjectOnScreen(tempobj)) then
									local bv,cx,cy = GetViewportPositionOfCoord(px, py, pz, GetGameViewportId(_i), _f, _f)
									local sx,sy = GetScreenResolution(_i, _i)
									if(cx>0 and cx<sx) then
										cx = cx/sx
									else
										cx = 0
									end
									if(cy>0 and cy<sy) then
										cy = cy/sy
									else
										cy = 0
									end
									if(cx>0 and cy>0) then
										if(playerinfo[i] ~= nil) then
											local hp = GetCharHealth(GetPlayerChar(i))-100
											if(hp > 100) then
												hp = 100
											end
											if(hp > 0) then
												DrawRectLeftTopCenter(cx-0.05/2, cy-0.005-0.005/2, 0.05, 0.005, 0, 0, 0, 100)
												DrawRectLeftTopCenter(cx-0.05/2, cy-0.005-0.005/2, 0.05/100*hp, 0.005, 255, 0, 0, 255)
											end
											
											local ap = GetCharArmour(GetPlayerChar(i))
											if(ap > 100) then
												ap = 100
											end
											if(ap > 0) then
												DrawRectLeftTopCenter(cx-0.05/2, cy-0.01-0.005/2, 0.05, 0.005, 0, 0, 0, 100)
												DrawRectLeftTopCenter(cx-0.05/2, cy-0.01-0.005/2, 0.05/100*ap, 0.005, 0, 0, 100, 255)
											end
											local temptext = "" .. GetStringWithoutSpaces("" .. GetPlayerName(i)) .. " Level:_" .. playerinfo[i][1]
											if(playerinfo[i][2] ~= "0") then
												if(clanname["" .. playerinfo[i][2]]==nil or clanname["" .. playerinfo[i][2]]=="0") then
													temptext = temptext .. " " .. GetStringWithoutSpaces("" .. playerinfo[i][2]) .. "'s_clan"
												else
													temptext = temptext .. " " .. GetStringWithoutSpaces("" .. clanname[playerinfo[i][2]])
												end
											end
											if(pausestatus[i] == 1) then
												temptext = temptext .. " Paused"
											end
											if(talkstatus[i] == 1) then
												temptext = temptext .. " Talking..."
											end
											if(typestatus[i] == 1) then
												temptext = temptext .. " Typing..."
											end
											local r,g,b = GetPlayerRgbColour(ConvertIntToPlayerindex(i), _i, _i, _i)
											if(#playercolor[i] > 0) then
												r = playercolor[i][1]
												g = playercolor[i][2]
												b = playercolor[i][3]
											end
											SetTextScale(0.1500000, 0.3000000)
											SetTextDropshadow(0, 0, 0, 0, 0)
											SetTextEdge(1, 0, 0, 0, 255)
											SetTextWrap(0.0, cx)
											SetTextCentre(1)
											SetTextColour(r, g, b, 255)
											DisplayTextWithLiteralString(cx, cy, "STRING", "" .. temptext)
											--[[if(playerinfo[i][3] == 0) then
												if(playerinfo[i][2] == "0") then
													SetTextScale(0.1500000, 0.3000000)
													SetTextDropshadow(0, 0, 0, 0, 0)
													SetTextEdge(1, 0, 0, 0, 255)
													SetTextWrap(0.0, cx)
													SetTextCentre(1)
													local r,g,b = GetPlayerRgbColour(ConvertIntToPlayerindex(i), _i, _i, _i)
													SetTextColour(r, g, b, 255)
													DisplayTextWithLiteralString(cx, cy, "STRING", "" .. GetStringWithoutSpaces("" .. GetPlayerName(i)) .. " Level:_" .. playerinfo[i][1])
												else
													SetTextScale(0.1500000, 0.3000000)
													SetTextDropshadow(0, 0, 0, 0, 0)
													SetTextEdge(1, 0, 0, 0, 255)
													SetTextWrap(0.0, cx)
													SetTextCentre(1)
													local r,g,b = GetPlayerRgbColour(ConvertIntToPlayerindex(i), _i, _i, _i)
													SetTextColour(r, g, b, 255)
													DisplayTextWithLiteralString(cx, cy, "STRING", "" .. GetStringWithoutSpaces("" .. GetPlayerName(i)) .. " Level:_" .. playerinfo[i][1] .. " " .. GetStringWithoutSpaces("" .. playerinfo[i][2]) .. "'s_clan")
												end
											else
												if(playerinfo[i][2] == "0") then
													SetTextScale(0.1500000, 0.3000000)
													SetTextDropshadow(0, 0, 0, 0, 0)
													SetTextEdge(1, 0, 0, 0, 255)
													SetTextWrap(0.0, cx)
													SetTextCentre(1)
													local r,g,b = GetPlayerRgbColour(ConvertIntToPlayerindex(i), _i, _i, _i)
													SetTextColour(r, g, b, 255)
													DisplayTextWithLiteralString(cx, cy, "STRING", "" .. GetStringWithoutSpaces("" .. GetPlayerName(i)) .. " Level:_" .. playerinfo[i][1] .. " Paused")
												else
													SetTextScale(0.1500000, 0.3000000)
													SetTextDropshadow(0, 0, 0, 0, 0)
													SetTextEdge(1, 0, 0, 0, 255)
													SetTextWrap(0.0, cx)
													SetTextCentre(1)
													local r,g,b = GetPlayerRgbColour(ConvertIntToPlayerindex(i), _i, _i, _i)
													SetTextColour(r, g, b, 255)
													DisplayTextWithLiteralString(cx, cy, "STRING", "" .. GetStringWithoutSpaces("" .. GetPlayerName(i)) .. " Level:_" .. playerinfo[i][1] .. " " .. GetStringWithoutSpaces("" .. playerinfo[i][2]) .. "'s_clan Paused")
												end
											end]]
										end
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
GetStringWithoutSpaces = function(text)
	local newstring = ""
	for i=1,#text,1 do
		local tempchar = text:sub(i, i)
		if(tempchar == " ") then
			newstring = "" .. newstring .. "_"
		else
			newstring = "" .. newstring .. "" .. tempchar
		end
	end
	return newstring
end

DrawDescription = function(title, text)
	SetTextScale(0.200000,  0.4000000)
	SetTextDropshadow(0, 0, 0, 0, 0)
	SetTextFont(6)
	--SetTextEdge(1, 0, 0, 0, 255)
	--SetTextWrap(0.0, 0.85)
	SetTextCentre(1)
	DisplayTextWithLiteralString(0.5, 0.065, "STRING", "" .. title)
	DrawRectLeftTopCenter(0.3, 0.05, 0.4, 0.05, 0, 0, 100, 255)
	
	for i=1,#text,1 do
		DrawRectLeftTopCenter(0.3, 0.1+0.3/10*(i-1), 0.4, 0.3/10, 0, 0, 0, 100)
		SetTextScale(0.1500000,  0.3000000)
		SetTextDropshadow(0, 0, 0, 0, 0)
		--SetTextFont(6)
		--SetTextEdge(1, 0, 0, 0, 255)
		--SetTextWrap(0.0, 0.3)
		--SetTextCentre(1)
		DisplayTextWithLiteralString(0.3+0.005, 0.1+0.3/10*(i-1)+0.005, "STRING", "" .. text[i])
	end
end

local afk = 0
CreateThread(function()
	while true do
		Wait(1000)
		if(not IsPlayerPlaying(GetPlayerId())) then
			afk = afk + 1
			if(afk >= 600) then
				TriggerServerEvent('kickPlayer', "Kicked for inactivity")
			end
		else
			afk = 0
		end
	end
end)

local message = false
local messagetime = 0
DrawMessage = function(title, text, duration)
	messagetime = 0
	if duration then
		messagetime = duration
	else
		messagetime = 10000
	end
	message = true
	CreateThread(function()
		while message do
			Wait(0)
			DrawRectLeftTopCenter(0.0, 0.2, 1.0, 0.15, 0, 0, 0, 100)
			
			SetTextScale(0.500000, 1.0000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			SetTextFont(3)
			--SetTextEdge(1, 0, 0, 0, 255)
			--SetTextWrap(0.0, 0.85)
			SetTextCentre(1)
			DisplayTextWithLiteralString(0.5, 0.21, "STRING", "" .. title)
			
			SetTextScale(0.1500000,  0.3000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			--SetTextFont(4)
			--SetTextEdge(1, 0, 0, 0, 255)
			--SetTextWrap(0.0, 0.85)
			SetTextCentre(1)
			DisplayTextWithLiteralString(0.5, 0.31, "STRING", "" .. text)
		end
	end)
end
CreateThread(function()
	while true do
		Wait(0)
		if message then
			Wait(messagetime)
			message = false
		end
	end
end)

GetPlayerSeat = function()
	local player = GetPlayerChar(GetPlayerId())
	local car = GetCarCharIsUsing(player)
	if(GetDriverOfCar(car) == player) then
		return 0
	else
		for i=0,2,1 do
			if(not IsCarPassengerSeatFree(car, i)) then
				if(GetCharInCarPassengerSeat(car, i) == player) then
					return i+1
				end
			end
		end
	end
end

local fpv = 0
CreateThread(function()
	while true do
		Wait(0)
		if(loginform == 0) then
			if(IsPlayerControlOn(GetPlayerId())) then
				if(IsGameKeyboardKeyJustPressed(48)) then
					if(fpv == 0) then
						--SetCamActive(GetGameCam(), false)
						fpcam = CreateCam(14, _i)
						SetCamPropagate(fpcam, 1)
						SetCamActive(fpcam, true)
						ActivateScriptedCams(1, 1)
						local bp = GetPedBonePosition(GetPlayerChar(GetPlayerId()), 0x4B5, 0, 0, 0)
						SetCamPos(fpcam, bp.x, bp.y, bp.z)
						SetCamRot(fpcam, 0.0, 0.0, GetCharHeading(GetPlayerChar(GetPlayerId())))
						if(not DoesObjectExist(camobj)) then
							local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
							camobj = SpawnObject(GetHashKey("cj_can_drink_1"), px, py, pz, 0.0)
						end
						fpcam2 = CreateCam(14, _i)
						fpv = 1
					else
						SetCamActive(fpcam, false)
						--SetCamActive(GetGameCam(), true)
						SetCamPropagate(fpcam, 0)
						SetCamPropagate(GetGameCam(), 1)
						ActivateScriptedCams(0, 0)
						DestroyCam(fpcam)
						
						SetCamActive(fpcam2, false)
						--SetCamActive(GetGameCam(), true)
						SetCamPropagate(fpcam2, 0)
						SetCamPropagate(GetGameCam(), 1)
						ActivateScriptedCams(0, 0)
						DestroyCam(fpcam2)
						fpv = 0
					end
				end
				if(DoesObjectExist(camobj)) then
					SetObjectVisible(camobj, false)
				end
				if(fpv == 1) then
					ActivateScriptedCams(1, 1)
					local cx,cy,cz = GetCamRot(GetGameCam())
					local bp = GetPedBonePosition(GetPlayerChar(GetPlayerId()), 0x4B5, 0, 0, 0)
					local pp = GetPedBonePosition(GetPlayerChar(GetPlayerId()), 0, 0, 0, 0)
					local bx = bp.x - pp.x
					local by = bp.y - pp.y
					local bz = bp.z - pp.z
					--ForceGameTelescopeCam(true)
					SetFollowVehicleCamSubmode(2)
					SetObjectVisible(camobj, false)
					--AttachObjectToPed(camobj, GetPlayerChar(GetPlayerId()), 0x4D0, 0.1, 0, 0.15, 0, 0, 0, 0)
					if(IsMouseButtonPressed(2) or IsButtonPressed(0, 5)) then
						--[[SetCamActive(fpcam, false)
						SetCamPropagate(fpcam, 0)
						
						SetCamPropagate(fpcam2, 1)
						SetCamActive(fpcam2, true)
						AttachCamToObject(fpcam2, camobj)]]
					else
						SetCamActive(fpcam2, false)
						SetCamPropagate(fpcam2, 0)
						
						SetCamPropagate(fpcam, 1)
						SetCamActive(fpcam, true)
						AttachCamToPed(fpcam, GetPlayerChar(GetPlayerId()))
					end
					SetCamAttachOffsetIsRelative(fpcam, 0)
					--local fov = GetCamFov(GetGameCam())
					--SetCamFov(fpcam, fov)
					if(not IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
						if(IsMouseButtonPressed(2) or IsButtonPressed(0, 5)) then
							local gw,cw = GetCurrentCharWeapon(GetPlayerChar(GetPlayerId()))
							if(cw < 7) then
								SetCamAttachOffset(fpcam, bx+0.3*math.cos((GetCharHeading(GetPlayerChar(GetPlayerId()))+90)*math.pi/180), by+0.3*math.sin((GetCharHeading(GetPlayerChar(GetPlayerId()))+90)*math.pi/180), bz)
								SetCamRot(fpcam, cx, cy, GetCharHeading(GetPlayerChar(GetPlayerId())))
							elseif(cw==16 or cw==17 or cw==35) then
								ActivateScriptedCams(0, 0)
							else
								--AttachCamToObject(fpcam, camobj)
								--SetCamAttachOffset(fpcam, bx+0.3*math.cos((GetCharHeading(GetPlayerChar(GetPlayerId()))+90)*math.pi/180), by+0.3*math.sin((GetCharHeading(GetPlayerChar(GetPlayerId()))+90)*math.pi/180), bz)
								AttachObjectToPed(camobj, GetPlayerChar(GetPlayerId()), 0x4D0, 0.1, 0, 0.15, 0, 0, 0, 0)
								SetCamAttachOffset(fpcam2, 0, 0, 0)
								
								SetCamActive(fpcam, false)
								SetCamPropagate(fpcam, 0)
								
								SetCamPropagate(fpcam2, 1)
								SetCamActive(fpcam2, true)
								AttachCamToObject(fpcam2, camobj)
								
								SetCamRot(fpcam2, cx, cy, cz)--GetCharHeading(GetPlayerChar(GetPlayerId())))
							end
						else
							SetCamAttachOffset(fpcam, bx+0.3*math.cos((cz+90)*math.pi/180), by+0.3*math.sin((cz+90)*math.pi/180), bz)
							SetCamRot(fpcam, cx, cy, cz)
						end
					else
						if(IsMouseButtonPressed(2) or IsButtonPressed(0, 5)) then
							local gw,cw = GetCurrentCharWeapon(GetPlayerChar(GetPlayerId()))
							if(cw == 0) then
								SetCamAttachOffset(fpcam, bx+0.3*math.cos((cz+90)*math.pi/180), by+0.3*math.sin((cz+90)*math.pi/180), bz+0.1)
								SetCamRot(fpcam, cx, cy, cz)
							else
								if(GetPlayerSeat() == 0) then
									if(IsMouseButtonPressed(1)) then
										local model = GetCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())))
										if(IsThisModelABoat(model) or IsThisModelAHeli(model)) then
											if(GetPlayerSeat() == 0) then
												AttachObjectToPed(camobj, GetPlayerChar(GetPlayerId()), 0x4C3, -0.1, 0, -0.15, 0, 0, 0, 0)
											else
												AttachObjectToPed(camobj, GetPlayerChar(GetPlayerId()), 0x4D0, 0.1, 0, 0.15, 0, 0, 0, 0)
											end
										elseif(IsThisModelABike(model)) then
											AttachObjectToPed(camobj, GetPlayerChar(GetPlayerId()), 0x4D0, 0.1, 0, 0.15, 0, 0, 0, 0)
										else
											if(GetPlayerSeat()==0 or GetPlayerSeat()==2) then
												AttachObjectToPed(camobj, GetPlayerChar(GetPlayerId()), 0x4C3, -0.1, 0, -0.15, 0, 0, 0, 0)
											else
												AttachObjectToPed(camobj, GetPlayerChar(GetPlayerId()), 0x4D0, 0.1, 0, 0.15, 0, 0, 0, 0)
											end
										end
										SetCamAttachOffset(fpcam2, 0, 0, 0)
										
										SetCamActive(fpcam, false)
										SetCamPropagate(fpcam, 0)
										
										SetCamPropagate(fpcam2, 1)
										SetCamActive(fpcam2, true)
										AttachCamToObject(fpcam2, camobj)
										
										SetCamRot(fpcam2, cx, cy, cz)
									else
										SetCamActive(fpcam2, false)
										SetCamPropagate(fpcam2, 0)
										
										SetCamPropagate(fpcam, 1)
										SetCamActive(fpcam, true)
										AttachCamToPed(fpcam, GetPlayerChar(GetPlayerId()))
										
										SetCamAttachOffset(fpcam, bx+0.3*math.cos((cz+90)*math.pi/180), by+0.3*math.sin((cz+90)*math.pi/180), bz+0.1)
										SetCamRot(fpcam, cx, cy, cz)
									end
								else
									local model = GetCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())))
									if(IsThisModelABoat(model) or IsThisModelAHeli(model)) then
										AttachObjectToPed(camobj, GetPlayerChar(GetPlayerId()), 0x4D0, 0.1, 0, 0.15, 0, 0, 0, 0)
									elseif(IsThisModelABike(model)) then
										AttachObjectToPed(camobj, GetPlayerChar(GetPlayerId()), 0x4D0, 0.1, 0, 0.15, 0, 0, 0, 0)
									else
										if(GetPlayerSeat() == 2) then
											AttachObjectToPed(camobj, GetPlayerChar(GetPlayerId()), 0x4C3, -0.1, 0, -0.15, 0, 0, 0, 0)
										else
											AttachObjectToPed(camobj, GetPlayerChar(GetPlayerId()), 0x4D0, 0.1, 0, 0.15, 0, 0, 0, 0)
										end
									end
									SetCamAttachOffset(fpcam2, 0, 0, 0)
									
									SetCamActive(fpcam, false)
									SetCamPropagate(fpcam, 0)
									
									SetCamPropagate(fpcam2, 1)
									SetCamActive(fpcam2, true)
									AttachCamToObject(fpcam2, camobj)
									
									SetCamRot(fpcam2, cx, cy, cz)
								end
							end
						else
							SetCamAttachOffset(fpcam, bx+0.3*math.cos((cz+90)*math.pi/180), by+0.3*math.sin((cz+90)*math.pi/180), bz+0.1)
							SetCamRot(fpcam, cx, cy, cz)
						end
					end
					--[[local gx,gy,gz = GetCamPos(GetGameCam())
					local grx,gry,grz = GetCamRot(GetGameCam())
					local bp = GetPedBonePosition(GetPlayerChar(GetPlayerId()), 0x4B5, 0, 0, 0)
					local dist = GetDistanceBetweenCoords3d(gx, gy, gz, bp.x, bp.y, bp.z)
					local fx = gx+dist*math.sin(grx*math.pi/180)*math.cos((grz+90)*math.pi/180)
					local fy = gy+dist*math.sin(grx*math.pi/180)*math.sin((grz+90)*math.pi/180)
					local fz = gz+dist*math.cos(grx*math.pi/180)
					local bx = fx - bp.x
					local by = fy - bp.y
					local bz = fz - bp.z
					SetFollowVehicleCamSubmode(2)
					AttachCamToPed(fpcam, GetPlayerChar(GetPlayerId()))
					SetCamAttachOffsetIsRelative(fpcam, 0)
					if(IsMouseButtonPressed(2) or IsButtonPressed(0, 5)) then
						local gw,cw = GetCurrentCharWeapon(GetPlayerChar(GetPlayerId()))
						if(cw==16 or cw==17 or cw==35) then
							ActivateScriptedCams(0, 0)
						else
							SetCamAttachOffset(fpcam, bx+0.3*math.cos((GetCharHeading(GetPlayerChar(GetPlayerId()))+90)*math.pi/180), by+0.3*math.sin((GetCharHeading(GetPlayerChar(GetPlayerId()))+90)*math.pi/180), bz)
							SetCamRot(fpcam, grx, gry, GetCharHeading(GetPlayerChar(GetPlayerId())))
						end
					else
						SetCamAttachOffset(fpcam, bx+0.3*math.sin(grx*math.pi/180)*math.cos((grz+90)*math.pi/180), by+0.3*math.sin(grx*math.pi/180)*math.sin((grz+90)*math.pi/180), bz+math.cos(grx*math.pi/180))
						SetCamRot(fpcam, grx, gry, grz)
					end]]
					--[[local gx,gy,gz = GetCamPos(GetGameCam())
					local grx,gry,grz = GetCamRot(GetGameCam())
					local bp = GetPedBonePosition(GetPlayerChar(GetPlayerId()), 0x4B5, 0, 0, 0)
					local dist = GetDistanceBetweenCoords3d(gx, gy, gz, bp.x, bp.y, bp.z)
					SetFollowVehicleCamSubmode(2)
					AttachCamToViewport(fpcam, GetGameViewportId())
					SetCamAttachOffsetIsRelative(fpcam, 1)
					SetCamAttachOffset(fpcam, 0, dist, 0.5)
					SetCamRot(fpcam, grx, gry, grz)]]
					if(IsMouseButtonPressed(2) or IsButtonPressed(0, 5)) then
						DrawRect(0.5, 0.5, 0.005, 0.01, 255, 255, 255, 100)
					end
				end
			end
		end
	end
end)

local driftpoints = 0
CreateThread(function()
	while true do
		Wait(0)
		if(IsCharInCar(GetPlayerChar(GetPlayerId()), car)) then
			if(IsVehicleOnAllWheels(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())))) then
				if(GetCarSpeed(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))) > 5) then
					if(GetVehicleGear(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))) > 0) then
						local fv = GetCarForwardVector(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())))
						local sv = GetCarSpeedVector(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), false)
						local angle = GetAngleBetween2dVectors(fv.x, fv.y, sv.x, sv.y)
						if(angle>0 and angle<90) then
							if(angle >= 20) then
								driftpoints = driftpoints + 1
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
		if(driftpoints > 0) then
			SetTextScale(0.300000,  0.6000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			SetTextEdge(1, 0, 0, 0, 255)
			DisplayTextWithLiteralString(0.05, 0.7, "STRING", "~y~Drift: ~g~+" .. driftpoints .. "$")
		end
	end
end)
CreateThread(function()
	while true do
		Wait(0)
		if(driftpoints > 0) then
			local temppoints = driftpoints
			Wait(1000)
			if(driftpoints == temppoints) then
				money = money + driftpoints
				SaveStats()
				driftpoints = 0
			end
		end
	end
end)

local killfeed = {}
local killfeedtimer = 0
local killblocker = {}
for i=0,31,1 do
	killblocker[i] = 0
end
CreateThread(function()
	while true do
		Wait(0)
		if(killfeedtimer > 0) then
			Wait(1000)
			killfeedtimer = killfeedtimer - 1
		end
	end
end)
CreateThread(function()
	while true do
		Wait(0)
		for i=0,31,1 do
			if(IsNetworkPlayerActive(i)) then
				if(IsPlayerDead(i)) then
					if(killblocker[i] == 0) then
						local killerid = FindNetworkKillerOfPlayer(i)
						if(ConvertIntToPlayerindex(i) == ConvertIntToPlayerindex(killerid)) then
							killfeed[#killfeed+1] = "~y~" .. GetPlayerName(i) .. " ~w~died"
						else
							killfeed[#killfeed+1] = "~y~" .. GetPlayerName(i) .. " ~w~got killed by ~y~" .. GetPlayerName(killerid)
							if(ConvertIntToPlayerindex(GetPlayerId()) == ConvertIntToPlayerindex(killerid)) then
								if(gamemode == 1) then
									DmKill(i)
								elseif(gamemode == 2) then
									GgKill(i)
								elseif(gamemode == 5) then
									SvKill(i)
								end
								kills = kills + 1
								SaveStats()
							end
						end
						if(ConvertIntToPlayerindex(i) == ConvertIntToPlayerindex(GetPlayerId())) then
							deaths = deaths + 1
							SaveStats()
						end
						killblocker[i] = 1
						killfeedtimer = 10
					end
				else
					killblocker[i] = 0
				end
			end
		end
		if(killfeedtimer > 0) then
			local alpha = 255
			if(killfeedtimer == 3) then
				alpha = 200
			elseif(killfeedtimer == 2) then
				alpha = 100
			elseif(killfeedtimer == 1) then
				alpha = 50
			end
			if(#killfeed <= 5) then
				for i=1,#killfeed,1 do
					SetTextScale(0.1500000, 0.3000000)
					SetTextDropshadow(0, 0, 0, 0, 0)
					--SetTextEdge(1, 0, 0, 0, 255)
					SetTextColour(255, 255, 255, alpha)
					DisplayTextWithLiteralString(0.2, 0.75+0.03*(i-1), "STRING", "" .. killfeed[i])
				end
			else
				local count = 0
				for i=#killfeed-4,#killfeed,1 do
					count = count + 1
					SetTextScale(0.1500000, 0.3000000)
					SetTextDropshadow(0, 0, 0, 0, 0)
					--SetTextEdge(1, 0, 0, 0, 255)
					SetTextColour(255, 255, 255, alpha)
					DisplayTextWithLiteralString(0.2, 0.75+0.03*(count-1), "STRING", "" .. killfeed[i])
				end
			end
		end
	end
end)

local invX = 0
local invY = 0
CreateThread(function()
	while true do
		Wait(0)
		if(loginform == 0) then
			if(IsPlayerControlOn(GetPlayerId())) then
				if(IsGameKeyboardKeyPressed(44)) then
					invX = 0
					invY = 0
					::again::
					Wait(0)
					local result = 0
					--DrawRect(0.5+invX, 0.5+invY*2, 0.01, 0.02, 255, 255, 255, 255)
					local mx,my = GetMouseInput()
					if(mx > 0) then
						if(mx > 10000) then
							mx = mx - 4294967296
						end
						invX = invX + mx/500
					end
					if(my > 0) then
						if(my > 10000) then
							my = my - 4294967296
						end
						invY = invY + my/500
					end
					if(invX < -0.1) then invX = -0.1 end
					if(invX > 0.1) then invX = 0.1 end
					if(invY < -0.1) then invY = -0.1 end
					if(invY > 0.1) then invY = 0.1 end
					
					if(invX > -0.05 and invX < 0.05) then
						if(invY < -0.05) then
							result = 1 --melee / bottom
						end
						if(invY > 0.05) then
							result = 2 --handgun / top
						end
					end
					if(invY > -0.05 and invY < 0.05) then
						if(invX < -0.05) then
							result = 3 --shotgun / left
						end
						if(invX > 0.05) then
							result = 4 --smg / right
						end
					end
					if(invX < -0.05) then
						if(invY < -0.05) then
							result = 5 --rifle / bottom-left
						end
						if(invY > 0.05) then
							result = 6 --sniper / top-left
						end
					end
					if(invX > 0.05) then
						if(invY < -0.05) then
							result = 7 --heavy / bottom-right
						end
						if(invY > 0.05) then
							result = 8 --thrown / top-right
						end
					end
					RequestStreamedTxd("wepicons")
					while not HasStreamedTxdLoaded("wepicons") do
						Wait(0)
					end
					local gunnames = {}
					for i=1,8,1 do
						local gun = table.pack(GetCharWeaponInSlot(GetPlayerChar(GetPlayerId()), i, _i, _i, _i))
						if(gun[1] > 0) then
							for j=1,#guns,1 do
								if(gun[1] == guns[j][2]) then
									gunnames[i] = guns[j][1]
								end
							end
							if(gun[1] == 30) then
								gunnames[i] = "AA12_(Explosive_shells)"
							elseif(gun[1] == 35) then
								gunnames[i] = "Advanced_Sniper"
							end
						else
							gunnames[i] = "None"
						end
					end
					for i=1,8,1 do
						if(gunnames[i] == "None") then
							--[[if(i == 1) then
								if(result == 1) then
									SetTextScale(0.2000000,  0.4000000)
									SetTextDropshadow(0, 0, 0, 0, 0)
									SetTextEdge(1, 0, 0, 0, 255)
									SetTextCentre(1)
									SetTextWrap(0.0, 0.5)
									SetTextColour(255, 255, 0, 255)
									DisplayTextWithLiteralString(0.5, 0.5-0.15*2, "STRING", "Melee " .. gunnames[1])
								else
									SetTextScale(0.2000000,  0.4000000)
									SetTextDropshadow(0, 0, 0, 0, 0)
									SetTextEdge(1, 0, 0, 0, 255)
									SetTextCentre(1)
									SetTextWrap(0.0, 0.5)
									DisplayTextWithLiteralString(0.5, 0.5-0.15*2, "STRING", "Melee " .. gunnames[1])
								end
							elseif(i == 2) then
								if(result == 2) then
									SetTextScale(0.2000000,  0.4000000)
									SetTextDropshadow(0, 0, 0, 0, 0)
									SetTextEdge(1, 0, 0, 0, 255)
									SetTextCentre(1)
									SetTextWrap(0.0, 0.5)
									SetTextColour(255, 255, 0, 255)
									DisplayTextWithLiteralString(0.5, 0.5+0.15*2, "STRING", "Handgun " .. gunnames[2])
								else
									SetTextScale(0.2000000,  0.4000000)
									SetTextDropshadow(0, 0, 0, 0, 0)
									SetTextEdge(1, 0, 0, 0, 255)
									SetTextCentre(1)
									SetTextWrap(0.0, 0.5)
									DisplayTextWithLiteralString(0.5, 0.5+0.15*2, "STRING", "Handgun " .. gunnames[2])
								end
							elseif(i == 3) then
								if(result == 3) then
									SetTextScale(0.2000000,  0.4000000)
									SetTextDropshadow(0, 0, 0, 0, 0)
									SetTextEdge(1, 0, 0, 0, 255)
									SetTextCentre(1)
									SetTextWrap(0.0, 0.5-0.15)
									SetTextColour(255, 255, 0, 255)
									DisplayTextWithLiteralString(0.5-0.15, 0.5, "STRING", "Shotgun " .. gunnames[3])
								else
									SetTextScale(0.2000000,  0.4000000)
									SetTextDropshadow(0, 0, 0, 0, 0)
									SetTextEdge(1, 0, 0, 0, 255)
									SetTextCentre(1)
									SetTextWrap(0.0, 0.5-0.15)
									DisplayTextWithLiteralString(0.5-0.15, 0.5, "STRING", "Shotgun " .. gunnames[3])
								end
							elseif(i == 4) then
								if(result == 4) then
									SetTextScale(0.2000000,  0.4000000)
									SetTextDropshadow(0, 0, 0, 0, 0)
									SetTextEdge(1, 0, 0, 0, 255)
									SetTextCentre(1)
									SetTextWrap(0.0, 0.5+0.15)
									SetTextColour(255, 255, 0, 255)
									DisplayTextWithLiteralString(0.5+0.15, 0.5, "STRING", "SMG " .. gunnames[4])
								else
									SetTextScale(0.2000000,  0.4000000)
									SetTextDropshadow(0, 0, 0, 0, 0)
									SetTextEdge(1, 0, 0, 0, 255)
									SetTextCentre(1)
									SetTextWrap(0.0, 0.5+0.15)
									DisplayTextWithLiteralString(0.5+0.15, 0.5, "STRING", "SMG " .. gunnames[4])
								end
							elseif(i == 5) then
								if(result == 5) then
									SetTextScale(0.2000000,  0.4000000)
									SetTextDropshadow(0, 0, 0, 0, 0)
									SetTextEdge(1, 0, 0, 0, 255)
									SetTextCentre(1)
									SetTextWrap(0.0, 0.5-0.1)
									SetTextColour(255, 255, 0, 255)
									DisplayTextWithLiteralString(0.5-0.1, 0.5-0.1*2, "STRING", "Rifle " .. gunnames[5])
								else
									SetTextScale(0.2000000,  0.4000000)
									SetTextDropshadow(0, 0, 0, 0, 0)
									SetTextEdge(1, 0, 0, 0, 255)
									SetTextCentre(1)
									SetTextWrap(0.0, 0.5-0.1)
									DisplayTextWithLiteralString(0.5-0.1, 0.5-0.1*2, "STRING", "Rifle " .. gunnames[5])
								end
							elseif(i == 6) then
								if(result == 6) then
									SetTextScale(0.2000000,  0.4000000)
									SetTextDropshadow(0, 0, 0, 0, 0)
									SetTextEdge(1, 0, 0, 0, 255)
									SetTextCentre(1)
									SetTextWrap(0.0, 0.5-0.1)
									SetTextColour(255, 255, 0, 255)
									DisplayTextWithLiteralString(0.5-0.1, 0.5+0.1*2, "STRING", "Sniper " .. gunnames[6])
								else
									SetTextScale(0.2000000,  0.4000000)
									SetTextDropshadow(0, 0, 0, 0, 0)
									SetTextEdge(1, 0, 0, 0, 255)
									SetTextCentre(1)
									SetTextWrap(0.0, 0.5-0.1)
									DisplayTextWithLiteralString(0.5-0.1, 0.5+0.1*2, "STRING", "Sniper " .. gunnames[6])
								end
							elseif(i == 7) then
								if(result == 7) then
									SetTextScale(0.2000000,  0.4000000)
									SetTextDropshadow(0, 0, 0, 0, 0)
									SetTextEdge(1, 0, 0, 0, 255)
									SetTextCentre(1)
									SetTextWrap(0.0, 0.5+0.1)
									SetTextColour(255, 255, 0, 255)
									DisplayTextWithLiteralString(0.5+0.1, 0.5-0.1*2, "STRING", "Heavy " .. gunnames[7])
								else
									SetTextScale(0.2000000,  0.4000000)
									SetTextDropshadow(0, 0, 0, 0, 0)
									SetTextEdge(1, 0, 0, 0, 255)
									SetTextCentre(1)
									SetTextWrap(0.0, 0.5+0.1)
									DisplayTextWithLiteralString(0.5+0.1, 0.5-0.1*2, "STRING", "Heavy " .. gunnames[7])
								end
							elseif(i == 8) then
								if(result == 8) then
									SetTextScale(0.2000000,  0.4000000)
									SetTextDropshadow(0, 0, 0, 0, 0)
									SetTextEdge(1, 0, 0, 0, 255)
									SetTextCentre(1)
									SetTextWrap(0.0, 0.5+0.1)
									SetTextColour(255, 255, 0, 255)
									DisplayTextWithLiteralString(0.5+0.1, 0.5+0.1*2, "STRING", "Throwable " .. gunnames[8])
								else
									SetTextScale(0.2000000,  0.4000000)
									SetTextDropshadow(0, 0, 0, 0, 0)
									SetTextEdge(1, 0, 0, 0, 255)
									SetTextCentre(1)
									SetTextWrap(0.0, 0.5+0.1)
									DisplayTextWithLiteralString(0.5+0.1, 0.5+0.1*2, "STRING", "Throwable " .. gunnames[8])
								end
							end]]
							local icon = GetTextureFromStreamedTxd("wepicons", "cross")
							if(i == 1) then
								if(result == 1) then
									DrawSprite(icon, 0.5, 0.5-0.15*2, 0.1, 0.1, 0.0, 255, 255, 0, 255)
								else
									DrawSprite(icon, 0.5, 0.5-0.15*2, 0.1, 0.1, 0.0, 255, 255, 255, 255)
								end
							elseif(i == 2) then
								if(result == 2) then
									DrawSprite(icon, 0.5, 0.5+0.15*2, 0.1, 0.1, 0.0, 255, 255, 0, 255)
								else
									DrawSprite(icon, 0.5, 0.5+0.15*2, 0.1, 0.1, 0.0, 255, 255, 255, 255)
								end
							elseif(i == 3) then
								if(result == 3) then
									DrawSprite(icon, 0.5-0.15, 0.5, 0.1, 0.1, 0.0, 255, 255, 0, 255)
								else
									DrawSprite(icon, 0.5-0.15, 0.5, 0.1, 0.1, 0.0, 255, 255, 255, 255)
								end
							elseif(i == 4) then
								if(result == 4) then
									DrawSprite(icon, 0.5+0.15, 0.5, 0.1, 0.1, 0.0, 255, 255, 0, 255)
								else
									DrawSprite(icon, 0.5+0.15, 0.5, 0.1, 0.1, 0.0, 255, 255, 255, 255)
								end
							elseif(i == 5) then
								if(result == 5) then
									DrawSprite(icon, 0.5-0.1, 0.5-0.1*2, 0.1, 0.1, 0.0, 255, 255, 0, 255)
								else
									DrawSprite(icon, 0.5-0.1, 0.5-0.1*2, 0.1, 0.1, 0.0, 255, 255, 255, 255)
								end
							elseif(i == 6) then
								if(result == 6) then
									DrawSprite(icon, 0.5-0.1, 0.5+0.1*2, 0.1, 0.1, 0.0, 255, 255, 0, 255)
								else
									DrawSprite(icon, 0.5-0.1, 0.5+0.1*2, 0.1, 0.1, 0.0, 255, 255, 255, 255)
								end
							elseif(i == 7) then
								if(result == 7) then
									DrawSprite(icon, 0.5+0.1, 0.5-0.1*2, 0.1, 0.1, 0.0, 255, 255, 0, 255)
								else
									DrawSprite(icon, 0.5+0.1, 0.5-0.1*2, 0.1, 0.1, 0.0, 255, 255, 255, 255)
								end
							elseif(i == 8) then
								if(result == 8) then
									DrawSprite(icon, 0.5+0.1, 0.5+0.1*2, 0.1, 0.1, 0.0, 255, 255, 0, 255)
								else
									DrawSprite(icon, 0.5+0.1, 0.5+0.1*2, 0.1, 0.1, 0.0, 255, 255, 255, 255)
								end
							end
						else
							local names = {
							"bat",
							"cue",
							"cuehalf",
							"knife",
							"grenade",
							"molotov",
							"glock",
							"eagle",
							"shotgun",
							"pumpshot",
							"uzi",
							"mp5",
							"ak47",
							"m4",
							"psg1",
							"rifle",
							"rpg",
							"glauncher",
							"assaultshotgun",
							"sawnoff",
							"cz75",
							"pipebomb",
							"pistol44",
							"aa12",
							"p90",
							"goldenuzi",
							"m249",
							"stickybomb"
							}
							local icon = nil
							for j=1,#names,1 do
								if(gunnames[i] == guns[j][1]) then
									icon = GetTextureFromStreamedTxd("wepicons", names[j])
								end
							end
							if(gunnames[i] == "AA12_(Explosive_shells)") then
								icon = GetTextureFromStreamedTxd("wepicons", "aa12")
							elseif(gunnames[i] == "Advanced_Sniper") then
								icon = GetTextureFromStreamedTxd("wepicons", "dsr1")
							end
							if(i == 1) then
								if(result == 1) then
									DrawSprite(icon, 0.5, 0.5-0.15*2, 0.1, 0.1, 0.0, 255, 255, 0, 255)
								else
									DrawSprite(icon, 0.5, 0.5-0.15*2, 0.1, 0.1, 0.0, 255, 255, 255, 255)
								end
							elseif(i == 2) then
								if(result == 2) then
									DrawSprite(icon, 0.5, 0.5+0.15*2, 0.1, 0.1, 0.0, 255, 255, 0, 255)
								else
									DrawSprite(icon, 0.5, 0.5+0.15*2, 0.1, 0.1, 0.0, 255, 255, 255, 255)
								end
							elseif(i == 3) then
								if(result == 3) then
									DrawSprite(icon, 0.5-0.15, 0.5, 0.1, 0.1, 0.0, 255, 255, 0, 255)
								else
									DrawSprite(icon, 0.5-0.15, 0.5, 0.1, 0.1, 0.0, 255, 255, 255, 255)
								end
							elseif(i == 4) then
								if(result == 4) then
									DrawSprite(icon, 0.5+0.15, 0.5, 0.1, 0.1, 0.0, 255, 255, 0, 255)
								else
									DrawSprite(icon, 0.5+0.15, 0.5, 0.1, 0.1, 0.0, 255, 255, 255, 255)
								end
							elseif(i == 5) then
								if(result == 5) then
									DrawSprite(icon, 0.5-0.1, 0.5-0.1*2, 0.1, 0.1, 0.0, 255, 255, 0, 255)
								else
									DrawSprite(icon, 0.5-0.1, 0.5-0.1*2, 0.1, 0.1, 0.0, 255, 255, 255, 255)
								end
							elseif(i == 6) then
								if(result == 6) then
									DrawSprite(icon, 0.5-0.1, 0.5+0.1*2, 0.1, 0.1, 0.0, 255, 255, 0, 255)
								else
									DrawSprite(icon, 0.5-0.1, 0.5+0.1*2, 0.1, 0.1, 0.0, 255, 255, 255, 255)
								end
							elseif(i == 7) then
								if(result == 7) then
									DrawSprite(icon, 0.5+0.1, 0.5-0.1*2, 0.1, 0.1, 0.0, 255, 255, 0, 255)
								else
									DrawSprite(icon, 0.5+0.1, 0.5-0.1*2, 0.1, 0.1, 0.0, 255, 255, 255, 255)
								end
							elseif(i == 8) then
								if(result == 8) then
									DrawSprite(icon, 0.5+0.1, 0.5+0.1*2, 0.1, 0.1, 0.0, 255, 255, 0, 255)
								else
									DrawSprite(icon, 0.5+0.1, 0.5+0.1*2, 0.1, 0.1, 0.0, 255, 255, 255, 255)
								end
							end
						end
					end
					if(IsGameKeyboardKeyPressed(44)) then
						goto again
					else
						local gun = table.pack(GetCharWeaponInSlot(GetPlayerChar(GetPlayerId()), result, _i, _i, _i))
						SetCurrentCharWeapon(GetPlayerChar(GetPlayerId()), gun[1], true)
					end
				end
			end
		end
	end
end)

local texttimer = 0
local texttimer2 = 0
local laststreetname = ""
CreateThread(function()
	while true do
		Wait(0)
		if(texttimer > 0) then
			Wait(1000)
			texttimer = texttimer - 1
		end
	end
end)
CreateThread(function()
	while true do
		Wait(0)
		if(texttimer2 > 0) then
			Wait(1000)
			texttimer2 = texttimer2 - 1
		end
	end
end)
AddEventHandler('baseevents:enteredVehicle', function(veh, vehseat, vehname)
	texttimer = 5
end)
CreateThread(function()
	while true do
		Wait(0)
		DisplayAreaName(false)
		if(loginform == 0) then
			if(IsPlayerControlOn(GetPlayerId())) then
				if(IsGameKeyboardKeyJustPressed(20)) then
					texttimer = 5
					texttimer2 = 5
				end
				if(texttimer > 0) then
					local vehname = ""
					if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
						local vehs = {
						{0x31F0B376, "Western Annihilator, Military"},
						{0x78D70477, "Western Helitours Maverick, Helicopter"},
						{0x9D0450CA, "Western Maverick, Helicopter"},
						{0x1517D4D9, "Western Police Maverick, Helicopter"},
						
						{0x7A61B330, "Vapid Benson, Truck"},
						{0x32B91AE8, "HVY Biff, Truck"},
						{0x898ECCEA, "Brute Boxville, Van"},
						{2948279460, "Declasse Burrito, Van"},
						{0x50B0215A, "MTL Flatbed, Truck"},
						{0xC9E8FF76, "Declasse Laundromat, Van"},
						{0x22C16A2F, "Brute Mr. Tasty, Van"},
						{0x35ED670B, "Maibatsu Mule, Truck"},
						{0x21EEE87D, "MTL Packer, Truck"},
						{0x809AA4CB, "JoBuilt Phantom, Truck"},
						{4175309224, "Brute Pony, Van"},
						{0xCFB3870C, "Vapid Speedo, Van"},
						{0x63FFE6EC, "Vapid Steed, Truck"},
						{0xBE6FF06A, "Vapid Yankee, Truck"},
						
						{1075851868, "Vapid Bobcat, Offroad"},
						{2006918058, "Albany Cavalcade, SUV"},
						{675415136, "Albany Cavalcade FXT, SUV"},
						{2323011842, "Vapid Contender, SUV"},
						{884422927, "Emperor Habanero, SUV"},
						{486987393, "Vapid Huntley Sport, SUV"},
						{1269098716, "Dundreary Landstalker, SUV"},
						{3984502180, "Vapid Minivan, SUV"},
						{525509695, "Declasse Moonbeam, SUV"},
						{3486509883, "Mammoth Patriot, Offroad"},
						{1390084576, "Declasse Rancher, Offroad"},
						{83136452, "Ubermacht Rebla, SUV"},
						
						{3612755468, "Albany Buccaneer, Classic"},
						{723973206, "Imponte Dukes, Muscle"},
						{3609690755, "Albany Emperor, Classic"},
						{0x8FC3AADC, "Albany Emperor, Classic"},
						{4018066781, "Albany Esperanto, Sedan"},
						{2175389151, "Willard Faction, Sedan"},
						{2170765704, "Albany Manana, Classic"},
						{1304597482, "Willard Marbelle, Classic"},
						{1830407356, "Vapid Peyote, Classic"},
						{4067225593, "Imponte Ruiner, Sedan"},
						{3845944409, "Declasse Sabre, Sedan"},
						{0x4B5D021E, "Declasse Sabre, Sedan"},
						{2609945748, "Declasse Sabre GT, Muscle"},
						{1923400478, "Classique Stallion, Classic"},
						{1534326199, "Vapid Uranus, Sedan"},
						{3469130167, "Declasse Vigero, Muscle"},
						{0x973141FC, "Declasse Vigero, Muscle"},
						{3796912450, "Dundreary Virgo, Classic"},
						{2006667053, "Declasse Voodoo, Classic"},
						
						{0x71EF6313, "Brute Enforcer, Emergency"},
						{0x432EA949, "Bravado FIB Buffalo, Emergency"},
						{0x08DE2A8B, "Vapid NOOSE Stanier, Emergency"},
						{0xEB221FC2, "Mammoth NOOSE Patriot, Emergency"},
						{0x79FBB0C5, "Vapid Police Stanier, Emergency"},
						{0x9F05F101, "Declasse Police Merit, Emergency"},
						{0x8EB78F5A, "Brute Police Stockade, Emergency"},
						
						{2464508460, "WMC Freeway, Bike"},
						{2452219115, "Principe Faggio, Motorbike"},
						{584879743, "Hellfury, Bike"},
						{1203311498, "Shitzu NRG 900, Motorcycle"},
						{3385765638, "Shitzu PCJ 600, Motorcycle"},
						{788045382, "Maibatsu Sanchez, Motorcycle"},
						{3724934023, "LCC Zombie, Bike"},
						
						{0x3D961290, "Nagasaki Dinghy, Boat"},
						{0x33581161, "Grotti Jetmax, Boat"},
						{0xC1CE1183, "Dinka Marquis, Boat"},
						{0xE2E7D4AB, "Police Predator, Emergency"},
						{0x68E27CB6, "Reefer, Boat"},
						{0x17DF5EC2, "Grotti Squalo, Boat"},
						{0x1149422F, "Grotti Tropic, Boat"},
						{0x3F724E66, "Buckingham Tug, Boat"},
						
						{1264341792, "Dundreary Admiral, Executive"},
						{2264796000, "Enus Cognoscenti, Executive"},
						{3197138417, "Benefactor Feltzer, Sports"},
						{886934177, "Karin Intruder, Executive"},
						{1348744438, "Ubermacht Oracle, Executive"},
						{131140572, "Annis Pinnacle, Executive"},
						{1376298265, "Schyster PMP 600, Executive"},
						{3144368207, "Albany Primo, Executive"},
						{0x2560B2FC, "Albany Romero, Executive"},
						{3972623423, "Benefactor Schafter, Executive"},
						{2333339779, "Dundreary Stretch, Executive"},
						{1777363799, "Albany Washington, Executive"},
						
						{0x5D0AAC8F, "Airtug, Service"},
						{0x45D56ADA, "Brute Ambulance, Emergency"},
						{0xD577C962, "Brute Bus, Service"},
						{0x705A3E41, "Schyster Cabby, Service"},
						{0x3D285C4A, "Bravado Feroci FlyUS, Service"},
						{0x73920F8E, "MTL Fire Truck, Emergency"},
						{0x58E49664, "HVY Forklift, Service"},
						{0xA1363020, "Dinka Perennial FlyUS, Service"},
						{0xCD935EF9, "HVY Ripley, Service"},
						{0x8CD0264C, "Albany Roman's Taxi, Service"},
						{0x6827CF72, "Brute Securicar, Service"},
						{0x480DAF95, "Declasse Merit Taxi, Service"},
						{0xC703DB5F, "Vapid Stanier Taxi, Service"},
						{0x72435A19, "Brute Trashmaster, Service"},
						{0x8B887FDB, "Subway Car, Service"},
						
						{3253274834, "Bravado Banshee, Sports"},
						{1063483177, "Pfister Comet, Sports"},
						{108773431, "Invetero Coquette, Sports"},
						{418536135, "Pegassi Infernus, Super"},
						{3999278268, "Karin Sultan RS, Sports"},
						{1821991593, "Dewbauchee SuperGT, Super"},
						{2398307655, "Grotti Turismo, Super"},
						
						{3950024287, "Dinka Blista, Compact"},
						{4227685218, "Dinka Chavos, Sedan"},
						{0x09B56631, "Imponte DF8-90, Sedan"},
						{3164157193, "Karin Dilettante, Compact"},
						{974744810, "Bravado Feroci, Sedan"},
						{627033353, "Vapid Fortune, Sedan"},
						{2016857647, "Karin Futo, Sports"},
						{3953074643, "Dinka Hakumai, Sedan"},
						{3005245074, "Vulcar Ingot, Sedan"},
						{4257937240, "Emperor Lokus, Sedan"},
						{3034085758, "Declasse Merit, Sedan"},
						{2217223699, "Dinka Perennial, Sedan"},
						{2411098011, "Declasse Premier, Sedan"},
						{2332896166, "Albany Presidente, Executive"},
						{1349725314, "Ubermacht Sentinel, Coupe"},
						{1344573448, "Willard Solair, Sedan"},
						{1723137093, "Zirconium Stratum, Sedan"},
						{970598228, "Karin Sultan, Sports"},
						{3711685889, "Maibatsu Vincent, Sedan"},
						{1937616578, "Willard, Sedan"},
						
						{562680400, "HVY APC, Military"},
						{4180675781, "Pegassi Bati, Motorcycle"},
						{3403504941, "Pegassi Bati Custom, Motorcycle"},
						{3990165190, "Bravado Buffalo, Sports"},
						{2598821281, "Vapid Bullet GT, Super"},
						{2623969160, "Dinka Double T, Motorcycle"},
						{2535109211, "Dinka Double T Custom, Motorcycle"},
						{1265391242, "Shitzu Hakuchou, Motorcycle"},
						{4039289119, "Shitzu Hakuchou Custom, Motorcycle"},
						{301427732, "LCC Hexer, Bike"},
						{3039514899, "Benefactor Schafter II, Executive"},
						{1337041428, "Benefactor Serrano, SUV"},
						{729783779, "Vapid Slamvan, Van"},
						{1638119866, "Enus Super Drop Diamond, Executive"},
						{972671128, "Declasse Tampa, Muscle"},
						{841808271, "Declasse Rhapsody, Compact"},
						{802082487, "LCS Lycan, Bike"},
						{2688780135, "Western Nightblade, Bike"},
						{3935799761, "Western Revenant, Bike"},
						{3886915065, "Western Diabolus, Bike"},
						{3676349299, "Western Wolfsbane, Bike"},
						{2006142190, "Western Daemon, Bike"},
						{3723957976, "Western Angel, Bike"},
						{4217198264, "Western Wayfarer, Bike"},
						{4280472072, "Dundreary Regina, Classic"},
						{0x2F03547B, "Nagasaki Buzzard, Military"},
						{0x63ABADE7, "Dinka Akuma, Motorcycle"},
						{0xDCBCBE48, "Ocelot F620, Super"},
						{0x0350D1AB, "Principe Faggio Classic, Motorbike"},
						{0xF92AEC4D, "Benefactor Stretch E, Executive"},
						{0xA774B5A6, "Benefactor Schafter II Custom, Executive"},
						{0x3EA948D6, "Benefactor Serrano Custom, SUV"},
						{0xF79A00F7, "Shitzu Vader, Motorcycle"},
						{0xB820ED5E, "Grotti Blade, Boat"},
						{0x98CC6F33, "Grotti Floater, Boat"},
						{0x38527DEC, "Grotti Smuggler, Boat"},
						{0x3E48BF23, "HVY Skylift, Service"},
						{0xEBC24DF2, "Buckingham Swift, Helicopter"},
						{0xEDC6F847, "HVY Brickade, Van"},
						
						{0xB2499163, "Cessna, Plane"},
						{0x0B040C5E, "Cub, Plane"},
						{0x7C5561CB, "Gripen, Plane"}
						}
						local vehmodel = GetCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())))
						for j=1,#vehs,1 do
							if(vehmodel == vehs[j][1]) then
								vehname = "" .. vehs[j][2]
							end
						end
					end
					local alpha = 0
					if(texttimer > 3) then
						alpha = 255
					elseif(texttimer == 3) then
						alpha = 200
					elseif(texttimer == 2) then
						alpha = 100
					elseif(texttimer == 1) then
						alpha = 50
					end
					if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
						if(sm == 0) then
							SetTextScale(0.2000000,  0.4000000)
							SetTextDropshadow(0, 0, 0, 0, 0)
							SetTextEdge(1, 255, 255, 255, alpha)
							SetTextRightJustify(1)
							SetTextWrap(0.0, 0.98)
							SetTextColour(0, 0, 100, alpha)
							--SetTextFont(8)
							DisplayTextWithLiteralString(0.98, 0.9, "STRING", "" .. GetStringWithoutSpaces(vehname))
						else
							if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))) == GetPlayerChar(GetPlayerId())) then
								SetTextScale(0.2000000,  0.4000000)
								SetTextDropshadow(0, 0, 0, 0, 0)
								SetTextEdge(1, 255, 255, 255, alpha)
								SetTextRightJustify(1)
								SetTextWrap(0.0, 0.98)
								SetTextColour(0, 0, 100, alpha)
								--SetTextFont(8)
								DisplayTextWithLiteralString(0.98, 0.8, "STRING", "" .. GetStringWithoutSpaces(vehname))
							else
								SetTextScale(0.2000000,  0.4000000)
								SetTextDropshadow(0, 0, 0, 0, 0)
								SetTextEdge(1, 255, 255, 255, alpha)
								SetTextRightJustify(1)
								SetTextWrap(0.0, 0.98)
								SetTextColour(0, 0, 100, alpha)
								--SetTextFont(8)
								DisplayTextWithLiteralString(0.98, 0.9, "STRING", "" .. GetStringWithoutSpaces(vehname))
							end
						end
					else
						SetTextScale(0.2000000,  0.4000000)
						SetTextDropshadow(0, 0, 0, 0, 0)
						SetTextEdge(1, 255, 255, 255, alpha)
						SetTextRightJustify(1)
						SetTextWrap(0.0, 0.98)
						SetTextColour(0, 0, 100, alpha)
						--SetTextFont(8)
						DisplayTextWithLiteralString(0.98, 0.9, "STRING", "" .. GetStringWithoutSpaces(vehname))
					end
				end
				local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
				local s1,s2 = FindStreetNameAtPosition(px, py, pz)
				s1 = GetStringFromHashKey(s1)
				s2 = GetStringFromHashKey(s2)
				local streetname = ""
				if(#s2 > 0) then
					streetname = "" .. s1 .. ", " .. s2
				else
					streetname = "" .. s1
				end
				if(streetname ~= laststreetname) then
					laststreetname = streetname
					texttimer2 = 5
				end
				if(texttimer2 > 0) then
					local alpha = 0
					if(texttimer2 > 3) then
						alpha = 255
					elseif(texttimer2 == 3) then
						alpha = 200
					elseif(texttimer2 == 2) then
						alpha = 100
					elseif(texttimer2 == 1) then
						alpha = 50
					end
					if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
						if(sm == 0) then
							SetTextScale(0.2000000,  0.4000000)
							SetTextDropshadow(0, 0, 0, 0, 0)
							SetTextEdge(1, 255, 255, 255, alpha)
							SetTextRightJustify(1)
							SetTextWrap(0.0, 0.98)
							SetTextColour(0, 0, 100, alpha)
							--SetTextFont(8)
							DisplayTextWithLiteralString(0.98, 0.9, "STRING", "_ " .. GetStringWithoutSpaces(streetname))
						else
							if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))) == GetPlayerChar(GetPlayerId())) then
								SetTextScale(0.2000000,  0.4000000)
								SetTextDropshadow(0, 0, 0, 0, 0)
								SetTextEdge(1, 255, 255, 255, alpha)
								SetTextRightJustify(1)
								SetTextWrap(0.0, 0.98)
								SetTextColour(0, 0, 100, alpha)
								--SetTextFont(8)
								DisplayTextWithLiteralString(0.98, 0.8, "STRING", "_ " .. GetStringWithoutSpaces(streetname))
							else
								SetTextScale(0.2000000,  0.4000000)
								SetTextDropshadow(0, 0, 0, 0, 0)
								SetTextEdge(1, 255, 255, 255, alpha)
								SetTextRightJustify(1)
								SetTextWrap(0.0, 0.98)
								SetTextColour(0, 0, 100, alpha)
								--SetTextFont(8)
								DisplayTextWithLiteralString(0.98, 0.9, "STRING", "_ " .. GetStringWithoutSpaces(streetname))
							end
						end
					else
						SetTextScale(0.2000000,  0.4000000)
						SetTextDropshadow(0, 0, 0, 0, 0)
						SetTextEdge(1, 255, 255, 255, alpha)
						SetTextRightJustify(1)
						SetTextWrap(0.0, 0.98)
						SetTextColour(0, 0, 100, alpha)
						--SetTextFont(8)
						DisplayTextWithLiteralString(0.98, 0.9, "STRING", "_ " .. GetStringWithoutSpaces(streetname))
					end
				end
			end
		end
	end
end)

local rus = {}
RegisterNetEvent('updRus')
AddEventHandler('updRus', function(data)
	rus = data
end)
TranslateToRussian = function(text)
	if(rus[text] ~= nil) then
		return rus[text]
	else
		return text
	end
end

CreateThread(function()
	while loginform == 1 do
		Wait(0)
	end
	exports.voicechat:SetPlayerChannel(ConvertIntToPlayerindex(GetPlayerId()))
	while true do
		Wait(0)
		for i=0,31,1 do
			if(IsNetworkPlayerActive(i)) then
				if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
					if(talkstatus[i] == 1) then
						if(phonecall[i]==ConvertIntToPlayerindex(GetPlayerId()) or phonecall[ConvertIntToPlayerindex(GetPlayerId())]==i) then
							exports.voicechat:SetPlayerVolume(i, 0.99)
						else
							local radius = 20
							local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
							local ix,iy,iz = GetCharCoordinates(GetPlayerChar(i))
							local dist = GetDistanceBetweenCoords3d(px, py, pz, ix, iy, iz)
							if(dist < radius) then
								local volume = (radius - dist)/radius
								exports.voicechat:SetPlayerVolume(i, volume)
							else
								exports.voicechat:SetPlayerVolume(i, 0.0)
							end
						end
					end
				end
			end
		end
	end
end)

local damage = {}
for i=0,31,1 do
	damage[i] = {}
	for j=0,20,1 do
		damage[i][j] = 0
	end
end
CreateThread(function()
	while true do
		Wait(0)
		for i=0,31,1 do
			if(IsNetworkPlayerActive(i)) then
				for j=0,20,1 do
					if(not IsPlayerDead(i)) then
						local tempdamage = GetDamageToPedBodyPart(GetPlayerChar(i), j)
						if(tempdamage > damage[i][j]) then
							if(HasCharBeenDamagedByChar(GetPlayerChar(i), GetPlayerChar(GetPlayerId()), false)) then
								local finaldamage = tempdamage - damage[i][j]
								local bp = GetPedBonePosition(GetPlayerChar(i), GetCharLastDamageBone(GetPlayerChar(i)), 0, 0, 0)
								DrawSignal(bp.x, bp.y, bp.z, "-" .. finaldamage)
								--ClearCharLastDamageEntity(GetPlayerChar(i))
							end
							damage[i][j] = tempdamage
						end
					else
						damage[i][j] = 0
					end
				end
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(IsCharInAnyHeli(GetPlayerChar(GetPlayerId()))) then
			local veh = GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))
			if(GetDriverOfCar(veh) == GetPlayerChar(GetPlayerId())) then
				local vehmodel = GetCarModel(veh)
				if(vehmodel==0x31F0B376 or
				vehmodel==0x2F03547B) then
					local cx,cy,cz = GetCarCoordinates(veh)
					local model = GetHashKey("cj_can_drink_1")
					if(not DoesObjectExist(tempobj)) then
						RequestModel(model)
						while not HasModelLoaded(model) do
							Wait(0)
						end
						tempobj = CreateObject(model, cx, cy, cz, _i, 1)
						SetObjectVisible(tempobj, false)
					end
					AttachObjectToCar(tempobj, veh, 0, 0, 100.1, -1.1, 0, 0, 0)
					if(IsObjectOnScreen(tempobj)) then
						local ox,oy,oz = GetObjectCoordinates(tempobj)
						local bv,cx,cy = GetViewportPositionOfCoord(ox, oy, oz, GetGameViewportId(_i), _f, _f)
						local sx,sy = GetScreenResolution(_i, _i)
						if(cx>0 and cx<sx) then
							cx = cx/sx
						else
							cx = 0
						end
						if(cy>0 and cy<sy) then
							cy = cy/sy
						else
							cy = 0
						end
						if(cx>0 and cy>0) then
							DrawRect(cx, cy, 0.01, 0.02, 255, 255, 255, 100)
						end
					end
				end
			end
		end
	end
end)

local track = ""
CreateThread(function()
	while true do
		Wait(0)
		if(IsGameInControlOfMusic()) then
			local trackid = GetAudibleMusicTrackTextId()
			local trackname = "TM_82_" .. trackid
			if(DoesTextLabelExist(trackname)) then
				local finaltrack = GetStringFromTextFile(trackname)
				if(finaltrack:sub(1, 13) == "ZiT! Spotted ") then
					track = finaltrack:sub(14, #finaltrack)
				else
					track = "_"
				end
			else
				track = "_"
			end
		end
		if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
			if(IsRadioHudOn()) then
				SetTextScale(0.2000000,  0.4000000)
				SetTextDropshadow(0, 0, 0, 0, 0)
				--SetTextEdge(1, 255, 255, 255, alpha)
				--SetTextRightJustify(1)
				--SetTextWrap(0.0, 0.98)
				--SetTextColour(0, 0, 100, alpha)
				--SetTextFont(8)
				SetTextCentre(1)
				DisplayTextWithLiteralString(0.5, 0.15, "STRING", "" .. track)
			end
		end
	end
end)

CreateThread(function()
	RequestStreamedTxd("countdown")
	while not HasStreamedTxdLoaded("countdown") do
		Wait(0)
		RequestStreamedTxd("countdown")
	end
end)

function StartCountdown()
	local count = 3
	CreateThread(function()
		while count do
			Wait(0)
			RequestStreamedTxd("countdown")
			while not HasStreamedTxdLoaded("countdown") do
				Wait(0)
				RequestStreamedTxd("countdown")
			end
			local txd = GetTextureFromStreamedTxd("countdown", "circle")
			if(count ~= nil) then
				if(count > 0) then
					DrawSprite(txd, 0.5, 0.3, 0.05, 0.09, 0.0, 255, 255, 0, 100)
					SetTextScale(0.500000,  0.8000000)
					SetTextDropshadow(0, 0, 0, 0, 0)
					SetTextFont(4)
					SetTextCentre(1)
					DisplayTextWithLiteralString(0.5, 0.275, "STRING", "" .. count)
				else
					DrawSprite(txd, 0.5, 0.3, 0.05, 0.09, 0.0, 0, 255, 0, 100)
					SetTextScale(0.500000,  0.8000000)
					SetTextDropshadow(0, 0, 0, 0, 0)
					SetTextFont(4)
					SetTextCentre(1)
					DisplayTextWithLiteralString(0.5, 0.275, "STRING", "GO")
				end
			end
		end
	end)
	while not HasStreamedTxdLoaded("countdown") do
		Wait(0)
	end
	SetPlayerControl(GetPlayerId(), false)
	count = 3
	Wait(1000)
	count = 2
	Wait(1000)
	count = 1
	Wait(1000)
	count = 0
	SetPlayerControl(GetPlayerId(), true)
	Wait(1000)
	count = nil
end

local attachedcar = nil
CreateThread(function()
	while true do
		Wait(0)
		if(IsCharInAnyHeli(GetPlayerChar(GetPlayerId()))) then
			if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))) == GetPlayerChar(GetPlayerId())) then
				if not attachedcar then
					local veh = GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))
					if(GetCarModel(veh) == GetHashKey("skylift")) then
						local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
						local closestcar = GetClosestCar(px, py, pz, 10.1, 0, 70, _i)
						if(not DoesVehicleExist(closestcar)) then
							closestcar = GetClosestCar(px, py, pz, 10.1, 0, 69, _i)
						end
						if(not DoesVehicleExist(closestcar)) then
							closestcar = GetClosestCar(px, py, pz, 10.1, 0, 71, _i)
						end
						if(DoesVehicleExist(closestcar)) then
							--if(IsCarTouchingCar(veh, closestcar)) then
							local cx,cy,cz = GetCarCoordinates(closestcar)
							if(IsPlayerNearCoords(cx, cy, cz, 4)) then
								PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~attach", 1000, 1)
								if(IsGameKeyboardKeyJustPressed(18)) then
									--AttachCarToCarPhysically(closestcar, veh, 0, 0, 0, -2.5, -1.1, 0, 0, 0, 0, 0)
									SetCarAsMissionCar(closestcar, true)
									AttachCarToCar(closestcar, veh, 0, 0, -2.5, -1.1, 0, 0, 0)
									attachedcar = closestcar
								end
							end
						end
					end
				else
					if(IsGameKeyboardKeyJustPressed(18)) then
						DetachCar(attachedcar)
						MarkCarAsNoLongerNeeded(attachedcar)
						attachedcar = nil
					end
				end
			end
		end
	end
end)

local bomb = {}
local rocket = {}
local ptfx = {}
local target = {}
local wepswitch = 1
CreateThread(function()
	while true do
		Wait(0)
		if(IsCharInAnyPlane(GetPlayerChar(GetPlayerId()))) then
			if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))) == GetPlayerChar(GetPlayerId())) then
				local veh = GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))
				if(GetCarModel(veh) == GetHashKey("gripen")) then
					if(IsGameKeyboardKeyJustPressed(45)) then
						if(wepswitch == 1) then
							wepswitch = 2
						else
							wepswitch = 1
						end
					end
					if(wepswitch == 1) then
						if(IsGameKeyboardKeyPressed(57)) then
							local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
							local ph = GetCharHeading(GetPlayerChar(GetPlayerId()))
							bomb[#bomb+1] = SpawnObject(GetHashKey("ec_bomb_ne"), px, py, pz-1, ph)
							Wait(200)
						end
					elseif(wepswitch == 2) then
						local cx,cy,cz = GetCarCoordinates(veh)
						local model = GetHashKey("cj_can_drink_1")
						if(not DoesObjectExist(tempobj)) then
							RequestModel(model)
							while not HasModelLoaded(model) do
								Wait(0)
							end
							tempobj = CreateObject(model, cx, cy, cz, _i, 1)
							SetObjectVisible(tempobj, false)
						end
						AttachObjectToCar(tempobj, veh, 0, 0, 100.1, -1.1, 0, 0, 0)
						local ox,oy,oz = GetObjectCoordinates(tempobj)
						if(IsObjectOnScreen(tempobj)) then
							local bv,cx,cy = GetViewportPositionOfCoord(ox, oy, oz, GetGameViewportId(_i), _f, _f)
							local sx,sy = GetScreenResolution(_i, _i)
							if(cx>0 and cx<sx) then
								cx = cx/sx
							else
								cx = 0
							end
							if(cy>0 and cy<sy) then
								cy = cy/sy
							else
								cy = 0
							end
							if(cx>0 and cy>0) then
								DrawRect(cx, cy, 0.01, 0.02, 255, 255, 255, 100)
							end
						end
						if(IsGameKeyboardKeyPressed(57)) then
							local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
							rocket[#rocket+1] = SpawnObject(1224353592, px, py, pz, 0.0)
							SetObjectCollision(rocket[#rocket], false)
							ptfx[#ptfx+1] = StartPtfx("weap_rocket", rocket[#rocket], 0, 0, 0, 1065353216)
							--AttachObjectToCar(tempobj, veh, 0, 0, 1000.1, -1.1, 0, 0, 0)
							--local ox,oy,oz = GetObjectCoordinates(tempobj)
							local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
							local vx = (ox - px)*10
							local vy = (oy - py)*10
							local vz = (oz - pz)*10
							target[#target+1] = {px+vx, py+vy, pz+vz}
							Wait(500)
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
		if(IsCharInAnyPlane(GetPlayerChar(GetPlayerId()))) then
			if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))) == GetPlayerChar(GetPlayerId())) then
				local veh = GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))
				if(GetCarModel(veh) == GetHashKey("gripen")) then
					local temptext = ""
					local temptext2 = ""
					if(wepswitch == 1) then
						temptext = "Bombs"
						temptext2 = "Drop"
					elseif(wepswitch == 2) then
						temptext = "Rockets"
						temptext2 = "Shoot"
					end
					SetTextScale(0.1500000,  0.3000000)
					SetTextDropshadow(0, 0, 0, 0, 0)
					SetTextFont(6)
					SetTextEdge(1, 0, 0, 0, 255)
					DisplayTextWithLiteralString(0.3, 0.97, "STRING", "Current weapon: " .. temptext .. " (X - Switch | Space - " .. temptext2 .. ")")
				end
			end
		end
		for i=1,#bomb,1 do
			if(DoesObjectExist(bomb[i])) then
				local ox,oy,oz = GetObjectCoordinates(bomb[i])
				local groundz = GetGroundZFor3dCoord(ox, oy, oz)
				if(GetDistanceBetweenCoords3d(ox, oy, oz, ox, oy, groundz) > 1) then
					SetObjectCoordinates(bomb[i], ox, oy, oz-1)
					for j=0,31,1 do
						if(IsNetworkPlayerActive(j)) then
							if(ConvertIntToPlayerindex(j) ~= ConvertIntToPlayerindex(GetPlayerId())) then
								local px,py,pz = GetCharCoordinates(GetPlayerChar(j))
								if(GetDistanceBetweenCoords3d(ox, oy, oz, px, py, pz) < 3) then
									DeleteObject(bomb[i])
									AddExplosion(ox, oy, oz, 0, 5.1, true, false, 1.1)
								end
							end
						end
					end
				else
					DeleteObject(bomb[i])
					AddExplosion(ox, oy, oz, 0, 5.1, true, false, 1.1)
				end
			end
		end
		for i=1,#rocket,1 do
			if(DoesObjectExist(rocket[i])) then
				if(target[i] ~= nil) then
					local ox,oy,oz = GetOffsetFromObjectInWorldCoords(rocket[i], 0, -1.00000000, 0)
					UpdatePtfxOffsets(ptfx[i], ox, oy, oz, 0, 0, 0)
					local ox,oy,oz = GetObjectCoordinates(rocket[i])
					local dx = math.abs(target[i][1] - ox)
					local dy = math.abs(target[i][2] - oy)
					local dz = math.abs(target[i][3] - oz)
					SlideObject(rocket[i], target[i][1], target[i][2], target[i][3], dx/100, dy/100, dz/100, 0)
					local ox,oy,oz = GetObjectCoordinates(rocket[i])
					if(GetDistanceBetweenCoords3d(ox, oy, oz, target[i][1], target[i][2], target[i][3]) > 1) then
						local groundz = GetGroundZFor3dCoord(ox, oy, oz)
						if(GetDistanceBetweenCoords3d(ox, oy, oz, ox, oy, groundz) < 3) then
							AddExplosion(ox, oy, oz, 0, 5.1, true, false, 1.1)
							DeleteObject(rocket[i])
							StopPtfx(ptfx[i])
							target[i] = {}
						else
							for j=0,31,1 do
								if(IsNetworkPlayerActive(j)) then
									if(ConvertIntToPlayerindex(j) ~= ConvertIntToPlayerindex(GetPlayerId())) then
										local px,py,pz = GetCharCoordinates(GetPlayerChar(j))
										if(GetDistanceBetweenCoords3d(ox, oy, oz, px, py, pz) < 3) then
											AddExplosion(ox, oy, oz, 0, 5.1, true, false, 1.1)
											DeleteObject(rocket[i])
											StopPtfx(ptfx[i])
											target[i] = {}
										end
									end
								end
							end
						end
					else
						AddExplosion(ox, oy, oz, 0, 5.1, true, false, 1.1)
						DeleteObject(rocket[i])
						StopPtfx(ptfx[i])
						target[i] = {}
					end
				end
			end
		end
	end
end)

GetRandomNodeInRadius = function(radius)
	local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
	local angle = GenerateRandomFloatInRange(0, 360.1)
	local rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
	return rx,ry,rz,rh
end

GetRandomWaterNodeInRadius = function(radius)
	local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
	local angle = GenerateRandomFloatInRange(0, 360.1)
	local rb,rv,rh = GetNthClosestWaterNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, false, false)
	return rv.x,rv.y,rv.z,rh
end

GetStreetAtCoord = function(x, y, z)
	local s1,s2 = FindStreetNameAtPosition(x, y, z)
	s1 = GetStringFromHashKey(s1)
	s2 = GetStringFromHashKey(s2)
	local streetname = s1
	if(#s2 > 0) then
		streetname = streetname .. ", " .. s2
	end
	return streetname
end

PrintText = function(text, time)
	PrintStringWithLiteralStringNow("STRING", text, time, 1)
end

--[[CreateThread(function()
	while true do
		Wait(0)
		if(IsGameKeyboardKeyJustPressed(18)) then
			GiveWeaponToChar(GetPlayerChar(GetPlayerId()), 41, 10, 1)
			DeleteChar(tempped)
			local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
			tempped = SpawnRandomPed(px, py, pz, 0.0)
		end
	end
end)]]
CreateThread(function()
	local rocket = nil
	local ptfx = nil
	local target = -1
	while true do
		Wait(0)
		if(not DoesObjectExist(rocket)) then
			local gw,cw = GetCurrentCharWeapon(GetPlayerChar(GetPlayerId()))
			if(cw >= 41) then
				if(IsControlPressed(0, 87)) then
					--[[if(DoesCharExist(tempped)) then
						local px,py,pz = GetCharCoordinates(tempped)
						local bv,bx,by = WorldToScreen(px, py, pz)
						if bv then
							if(bx>0.475 and bx<0.525) then
								if(by>0.45 and by<0.55) then
									DrawRect(bx, by, 0.05, 0.1, 255, 255, 255, 100)
									if(IsControlJustPressed(0, 4)) then
										target = -2
										RequestModel(1224353592)
										while not HasModelLoaded(1224353592) do
											Wait(0)
											RequestModel(1224353592)
										end
										--local ox,oy,oz = GetOffsetFromCharInWorldCoords(GetPlayerChar(GetPlayerId()), 0, 1.00000000, 0)
										local ox,oy,oz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
										rocket = CreateObject(1224353592, ox, oy, oz, 1)
										SetObjectCollision(rocket, false)
										ptfx = StartPtfx("weap_rocket", ox, oy, oz, 0, 0, 0, 1065353216)
									end
								end
							end
						end
					end]]
					for i=0,31,1 do
						if(IsNetworkPlayerActive(i)) then
							if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
								local px,py,pz = GetCharCoordinates(GetPlayerChar(i))
								local bv,bx,by = WorldToScreen(px, py, pz)
								if bv then
									if(bx>0.475 and bx<0.525) then
										if(by>0.45 and by<0.55) then
											DrawRect(bx, by, 0.05, 0.1, 255, 255, 255, 100)
											if(IsControlJustPressed(0, 4)) then
												target = i
												--[[RequestModel(1224353592)
												while not HasModelLoaded(1224353592) then
													Wait(0)
													RequestModel(1224353592)
												end]]
												local ox,oy,oz = GetOffsetFromCharInWorldCoords(GetPlayerChar(GetPlayerId()), 0, 1.00000000, 0)
												rocket = SpawnObject(1224353592, ox, oy, oz, 0.0) --CreateObject(1224353592, ox, oy, oz, 1)
												SetObjectCollision(rocket, false)
												ptfx = StartPtfx("weap_rocket", rocket, 0, 0, 0, 1065353216)
												break
											end
										end
									end
								end
							end
						end
					end
				end
			end
		else
			local ox,oy,oz = GetOffsetFromObjectInWorldCoords(rocket, 0, -1.00000000, 0)
			UpdatePtfxOffsets(ptfx, ox, oy, oz, 0, 0, 0)
			local ox,oy,oz = GetObjectCoordinates(rocket)
			local px,py,pz = GetCharCoordinates(GetPlayerChar(target))
			if(GetDistanceBetweenCoords3d(ox, oy, oz, px, py, pz) > 1) then
				SlideObject(rocket, px, py, pz, 1.5, 1.5, 1.5, 0)
			else
				AddExplosion(ox, oy, oz, 0, 5.1, true, false, 1.1)
				DeleteObject(rocket)
				StopPtfx(ptfx)
				target = -1
			end
		end
	end
end)