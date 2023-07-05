local opponent = -1
local playerped = nil
local enemyped = nil
local side = 0
local balance = 0.0

ProceedToWrest = function(id)
	local ped = GetPlayerChar(GetPlayerId())
	--FreezeCharPosition(ped, true)
	local px,py,pz = GetCharCoordinates(ped)
	local ph = GetCharHeading(ped)
	local pos1 = {px, py, pz-1, ph}
	local pos2 = {px+1.15*math.cos(math.rad(ph+90))+0.2*math.cos(math.rad(ph)), py+1.15*math.sin(math.rad(ph+90))+0.2*math.sin(math.rad(ph)), pz-1, ph+180}
	TriggerServerEvent('sendWrestOffer', id, ConvertIntToPlayerindex(GetPlayerId()), pos1, pos2)
end

ClonePed = function(ped)
	local px,py,pz = GetCharCoordinates(ped)
	local ph = GetCharHeading(ped)
	
	local model = GetCharModel(ped)
	local drawvar = {}
	local textvar = {}
	for i=0,10,1 do
		drawvar[i] = GetCharDrawableVariation(ped, i)
		textvar[i] = GetCharTextureVariation(ped, i)
	end
	local props = {}
	for i=0,1,1 do
		props[i] = GetCharPropIndex(ped, i)
	end
	
	--[[RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(0)
		RequestModel(model)
	end
	local clone = CreateChar(1, model, px, py, pz, true)]]
	local clone = SpawnPed(model, px, py, pz, ph)
	if(IsInteriorScene() and GetKeyForViewportInRoom(GetGameViewportId())~=0) then
		SetRoomForCharByKey(clone, GetKeyForViewportInRoom(GetGameViewportId()))
	end
	for i=0,10,1 do
		SetCharComponentVariation(clone, i, drawvar[i], textvar[i])
	end
	for i=0,1,1 do
		SetCharPropIndex(clone, i, props[i])
	end
	SetCharHeading(clone, ph)
	return clone
end

CreateThread(function()
	local button = 1
	while true do
		Wait(0)
		RequestAnims("mini_arm")
		if(opponent > -1) then
			--if(IsCharPlayingAnim(GetPlayerChar(GetPlayerId()), "mini_arm", "attack") or IsCharPlayingAnim(GetPlayerChar(GetPlayerId()), "mini_arm", "defend")) then
				if(side == 1) then
					if(balance > 0) then
						--SetCharAnimCurrentTime(GetPlayerChar(GetPlayerId()), "mini_arm", "attack", balance)
						--TaskPlayAnimWithFlagsAndStartPhase(GetPlayerChar(GetPlayerId()), "attack", "mini_arm", 8.0, 0, 0, balance)
						TaskPlayAnimWithFlagsAndStartPhase(playerped, "attack", "mini_arm", 8.0, 0, 0, balance)
						TaskPlayAnimWithFlagsAndStartPhase(enemyped, "defend", "mini_arm", 8.0, 0, 0, balance)
					else
						--SetCharAnimCurrentTime(GetPlayerChar(GetPlayerId()), "mini_arm", "defend", -balance)
						--TaskPlayAnimWithFlagsAndStartPhase(GetPlayerChar(GetPlayerId()), "defend", "mini_arm", 8.0, 0, 0, -balance)
						TaskPlayAnimWithFlagsAndStartPhase(playerped, "defend", "mini_arm", 8.0, 0, 0, -balance)
						TaskPlayAnimWithFlagsAndStartPhase(enemyped, "attack", "mini_arm", 8.0, 0, 0, -balance)
					end
				else
					if(balance > 0) then
						--SetCharAnimCurrentTime(GetPlayerChar(GetPlayerId()), "mini_arm", "defend", balance)
						--TaskPlayAnimWithFlagsAndStartPhase(GetPlayerChar(GetPlayerId()), "defend", "mini_arm", 8.0, 0, 0, balance)
						TaskPlayAnimWithFlagsAndStartPhase(playerped, "defend", "mini_arm", 8.0, 0, 0, balance)
						TaskPlayAnimWithFlagsAndStartPhase(enemyped, "attack", "mini_arm", 8.0, 0, 0, balance)
					else
						--SetCharAnimCurrentTime(GetPlayerChar(GetPlayerId()), "mini_arm", "attack", -balance)
						--TaskPlayAnimWithFlagsAndStartPhase(GetPlayerChar(GetPlayerId()), "attack", "mini_arm", 8.0, 0, 0, -balance)
						TaskPlayAnimWithFlagsAndStartPhase(playerped, "attack", "mini_arm", 8.0, 0, 0, -balance)
						TaskPlayAnimWithFlagsAndStartPhase(enemyped, "defend", "mini_arm", 8.0, 0, 0, -balance)
					end
				end
			--end
			if(IsMouseButtonJustPressed(button)) then
				if(button == 1) then
					button = 2
				else
					button = 1
				end
				if(side == 1) then
					local isbelowzero = false
					if(balance < 0) then
						isbelowzero = true
					end
					balance = balance + 0.05
					TriggerServerEvent('updateWrestBalance', opponent, balance)
					if isbelowzero then
						if(balance >= 0) then
							TaskPlayAnimWithFlags(GetPlayerChar(GetPlayerId()), "attack", "mini_arm", 8.0, 3000000, 0)
						else
							--TriggerServerEvent('updateWrestAnim', opponent, "defend")
						end
					else
						if(balance > 1.0) then
							DrawMessage("~y~Armwrestling won", "You have won the armwrestling!")
							ClearCharTasksImmediately(GetPlayerChar(GetPlayerId()))
							TriggerServerEvent('finishWrest', opponent)
							--SetCharVisible(GetPlayerChar(opponent), true)
							--ForceNetPlayerInvisible(opponent, 0)
							SetCharVisible(GetPlayerChar(GetPlayerId()), true)
							opponent = -1
							DeleteChar(playerped)
							DeleteChar(enemyped)
							SetPlayerControl(GetPlayerId(), true)
							FreezeCharPosition(GetPlayerChar(GetPlayerId()), false)
							ClearCharTasksImmediately(GetPlayerChar(GetPlayerId()))
							Wait(1000)
							ClearCharTasksImmediately(GetPlayerChar(GetPlayerId()))
						end
					end
				else
					local isabovezero = false
					if(balance >= 0) then
						isabovezero = true
					end
					balance = balance - 0.05
					TriggerServerEvent('updateWrestBalance', opponent, balance)
					if isabovezero then
						if(balance < 0) then
							TaskPlayAnimWithFlags(GetPlayerChar(GetPlayerId()), "attack", "mini_arm", 8.0, 3000000, 0)
						else
							--TriggerServerEvent('updateWrestAnim', opponent, "defend")
						end
					else
						if(balance < -1.0) then
							DrawMessage("~y~Armwrestling won", "You have won the armwrestling!")
							ClearCharTasksImmediately(GetPlayerChar(GetPlayerId()))
							TriggerServerEvent('finishWrest', opponent)
							--SetCharVisible(GetPlayerChar(opponent), true)
							--ForceNetPlayerInvisible(opponent, 0)
							SetCharVisible(GetPlayerChar(GetPlayerId()), true)
							opponent = -1
							DeleteChar(playerped)
							DeleteChar(enemyped)
							SetPlayerControl(GetPlayerId(), true)
							FreezeCharPosition(GetPlayerChar(GetPlayerId()), false)
							ClearCharTasksImmediately(GetPlayerChar(GetPlayerId()))
							Wait(1000)
							ClearCharTasksImmediately(GetPlayerChar(GetPlayerId()))
						end
					end
				end
			end
		end
	end
end)

local wrestchecker = false
RegisterNetEvent('sendWrestOffer')
AddEventHandler('sendWrestOffer', function(id, sender, pos1, pos2)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		CreateThread(function()
			DrawWindow("Someone offers to do wrestling with you", {"Accept " .. GetPlayerName(sender) .. "'s offer"})
			while menuactive do
				Wait(0)
			end
			if(menuresult > 0) then
				RequestAnims("mini_arm")
				while not HaveAnimsLoaded("mini_arm") do
					Wait(0)
				end
				wrestchecker = false
				Settimerc(0)
				TriggerServerEvent('acceptWrestOffer', sender, id, pos1, pos2)
				while not wrestchecker do
					Wait(0)
					if(Timerc() >= 10000) then
						FreezeCharPosition(GetPlayerChar(GetPlayerId()), false)
						goto out
					end
				end
				--SetCharVisible(GetPlayerChar(sender), false)
				--ForceNetPlayerInvisible(sender, 1)
				DeleteChar(playerped)
				playerped = ClonePed(GetPlayerChar(GetPlayerId()))
				SetPedStopCloning(playerped, true)
				SetNetworkIdStopCloning(GetNetworkIdFromPed(playerped), true)
				FreezeCharPosition(playerped, true)
				SetCharCoordinates(playerped, pos2[1], pos2[2], pos2[3])
				SetCharHeading(playerped, pos2[4])
				
				DeleteChar(enemyped)
				enemyped = ClonePed(GetPlayerChar(sender))
				SetPedStopCloning(enemyped, true)
				SetNetworkIdStopCloning(GetNetworkIdFromPed(enemyped), true)
				FreezeCharPosition(enemyped, true)
				SetCharCoordinates(enemyped, pos1[1], pos1[2], pos1[3])
				SetCharHeading(enemyped, pos1[4])
				
				SetPlayerControl(GetPlayerId(), false)
				FreezeCharPosition(GetPlayerChar(GetPlayerId()), true)
				SetCurrentCharWeapon(GetPlayerChar(GetPlayerId()), 0, true)
				SetCharCoordinates(GetPlayerChar(GetPlayerId()), pos2[1], pos2[2], pos2[3])
				SetCharHeading(GetPlayerChar(GetPlayerId()), pos2[4])
				SetCharVisible(GetPlayerChar(GetPlayerId()), false)
				--TaskPlayAnimWithFlags(GetPlayerChar(GetPlayerId()), "attack", "mini_arm", 8.0, 0, 0)
				side = 1
				balance = 0.0
				opponent = sender
				::out::
			else
				--FreezeCharPosition(GetPlayerChar(GetPlayerId()), false)
				TriggerServerEvent('sendMessageToPlayer2', sender, "[Armwrestling]", "Your offer has been declined.")
			end
		end)
	end
end)
RegisterNetEvent('acceptWrestOffer')
AddEventHandler('acceptWrestOffer', function(id, sender, pos1, pos2)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		CreateThread(function()
			RequestAnims("mini_arm")
			while not HaveAnimsLoaded("mini_arm") do
				Wait(0)
			end
			TriggerServerEvent('acceptWrestOffer2', sender)
			--SetCharVisible(GetPlayerChar(sender), false)
			--ForceNetPlayerInvisible(sender, 1)
			DeleteChar(playerped)
			playerped = ClonePed(GetPlayerChar(GetPlayerId()))
			SetPedStopCloning(playerped, true)
			SetNetworkIdStopCloning(GetNetworkIdFromPed(playerped), true)
			FreezeCharPosition(playerped, true)
			SetCharCoordinates(playerped, pos1[1], pos1[2], pos1[3])
			SetCharHeading(playerped, pos1[4])
			
			DeleteChar(enemyped)
			enemyped = ClonePed(GetPlayerChar(sender))
			SetPedStopCloning(enemyped, true)
			SetNetworkIdStopCloning(GetNetworkIdFromPed(enemyped), true)
			FreezeCharPosition(enemyped, true)
			SetCharCoordinates(enemyped, pos2[1], pos2[2], pos2[3])
			SetCharHeading(enemyped, pos2[4])
			
			SetPlayerControl(GetPlayerId(), false)
			FreezeCharPosition(GetPlayerChar(GetPlayerId()), true)
			SetCurrentCharWeapon(GetPlayerChar(GetPlayerId()), 0, true)
			SetCharCoordinates(GetPlayerChar(GetPlayerId()), pos1[1], pos1[2], pos1[3])
			SetCharHeading(GetPlayerChar(GetPlayerId()), pos1[4])
			SetCharVisible(GetPlayerChar(GetPlayerId()), false)
			--TaskPlayAnimWithFlags(GetPlayerChar(GetPlayerId()), "defend", "mini_arm", 8.0, 0, 0)
			side = -1
			balance = 0.0
			opponent = sender
		end)
	end
end)
RegisterNetEvent('acceptWrestOffer2')
AddEventHandler('acceptWrestOffer2', function(id)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		wrestchecker = true
	end
end)

RegisterNetEvent('updateWrestBalance')
AddEventHandler('updateWrestBalance', function(id, b)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		balance = b
	end
end)
RegisterNetEvent('updateWrestAnim')
AddEventHandler('updateWrestAnim', function(id, anim)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		TaskPlayAnimWithFlags(GetPlayerChar(GetPlayerId()), anim, "mini_arm", 8.0, 3000000, 0)
	end
end)
RegisterNetEvent('finishWrest')
AddEventHandler('finishWrest', function(id)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		money = money - 100
		SaveStats()
		TriggerServerEvent('sendWrestReward', opponent, 100, ConvertIntToPlayerindex(GetPlayerId()))
		DrawMessage("~r~Armwrestling lost", "" .. GetPlayerName(opponent) .. " has won the armwrestling.")
		--TriggerEvent('chatMessage', '[Armwrestling]', {255, 255, 0}, 'You have paid a bet of ' .. racebet .. '$ to ' .. GetPlayerName(outrunrival))
		TriggerEvent('chatMessage', '[Armwrestling]', {255, 255, 0}, 'You have paid 100$ to ' .. GetPlayerName(opponent) .. ".")
		--SetCharVisible(GetPlayerChar(opponent), true)
		--ForceNetPlayerInvisible(opponent, 0)
		SetCharVisible(GetPlayerChar(GetPlayerId()), true)
		opponent = -1
		DeleteChar(playerped)
		DeleteChar(enemyped)
		SetPlayerControl(GetPlayerId(), true)
		FreezeCharPosition(GetPlayerChar(GetPlayerId()), false)
		ClearCharTasksImmediately(GetPlayerChar(GetPlayerId()))
	end
end)

RegisterNetEvent('sendWrestReward')
AddEventHandler('sendWrestReward', function(id, amount, sender)
	if(ConvertIntToPlayerindex(GetPlayerId()) == ConvertIntToPlayerindex(id)) then
		money = money + amount
		SaveStats()
		TriggerEvent('chatMessage', '[Armwrestling]', {0, 255, 0}, 'You have received ' .. amount .. '$ from ' .. GetPlayerName(sender) .. ".")
	end
end)