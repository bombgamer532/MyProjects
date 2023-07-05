local coords = {
{894.54910000, -493.45960000, 18.45280000},
{102.14850000, 853.13370000, 44.13510000},
{-965.44760000, 891.74320000, 18.00130000},
{-423.80960000, 1460.38800000, 37.96650000},
{598.83250000, 1408.44300000, 16.47130000},
{-544.17273, 1243.09497, 97.57115},
{-136.5267, 1379.1001, 32.80625},
{-1248.79529, 1555.3053, 26.06886},
{1372.19958, 526.27936, 33.1296},
{852.5755, -513.84583, 16.28271}
}
local turned = {}
local channel = {}
local volume = {}
for i=1,#coords,1 do
	channel[i] = "CNT"
	volume[i] = -12.00000000
end

local time = 0.0
RegisterNetEvent('turnTv')
AddEventHandler('turnTv', function(id, set)
	turned[id] = set
end)
RegisterNetEvent('setTvChannel')
AddEventHandler('setTvChannel', function(id, c)
	channel[id] = c
	if(IsPlayerNearCoords(coords[id][1], coords[id][2], coords[id][3], 20)) then
		StopMovie()
		ReleaseMovie()
		DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 255)
		SetCurrentMovie(channel[id])
		SetMovieTime(time)
		PlayMovie()
	end
end)
--[[function SetChannel(id, c)
	channel[id] = c
	StopMovie()
	ReleaseMovie()
	DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 255)
	SetCurrentMovie(channel[id])
	SetMovieTime(time)
	PlayMovie()
end]]
RegisterNetEvent('setTvVolume')
AddEventHandler('setTvVolume', function(id, v)
	volume[id] = v + 0.00000000
	SetMovieVolume(volume[id])
end)
--[[function SetVolume(id, v)
	volume[id] = v
	SetMovieVolume(volume[id])
end]]

CreateThread(function()
	local renderid = nil
	local block = false
	local first = false
	while true do
		Wait(0)
		time = time + 0.01
		if(time > 100.0) then
			time = 0.0
			--SetMovieTime(time)
		end
		local isneartv = false
		for i=1,#coords,1 do
			if(IsPlayerNearCoords(coords[i][1], coords[i][2], coords[i][3], 20)) then
				isneartv = true
			end
		end
		if isneartv then
			for i=1,#coords,1 do
				if(IsPlayerNearCoords(coords[i][1], coords[i][2], coords[i][3], 20)) then
					if turned[i] then
						if not block then
							renderid = GetScriptRendertargetRenderId()
							SetTextRenderId(renderid)
							DrawRect(0.50000000, 0.50000000, 1.00000000, 1.00000000, 0, 0, 0, 255)
							Wait(250)
							RequestAmbientAudioBank("SCRIPT_AMBIENT\\TELEVISION")
							SetCurrentMovie(channel[i])
							SetMovieTime(time)
							SetMovieVolume(volume[i])
							PlayMovie()
							SetTextRenderId(renderid)
							DrawMovie(0.50000000, 0.50000000, 1.00000000, 1.00000000, 0.00000000, 255, 255, 255, 255)
							--if not first then
								StopMovie()
								ReleaseMovie()
								AmbientAudioBankNoLongerNeeded()
								SetTextRenderId(renderid)
								DrawRect(0.5, 0.5, 1.1, 1.1, 0, 0, 0, 255)
								Wait(250)
								
								SetTextRenderId(renderid)
								DrawRect(0.50000000, 0.50000000, 1.00000000, 1.00000000, 0, 0, 0, 255)
								Wait(250)
								RequestAmbientAudioBank("SCRIPT_AMBIENT\\TELEVISION")
								SetCurrentMovie(channel[i])
								SetMovieTime(time)
								SetMovieVolume(volume[i])
								PlayMovie()
								SetTextRenderId(renderid)
								DrawMovie(0.50000000, 0.50000000, 1.00000000, 1.00000000, 0.00000000, 255, 255, 255, 255)
							--	first = true
							--end
							loginform = 2
							block = true
						end
						--SetCurrentMovie(channel[i])
						--SetMovieVolume(volume[i])
						SetTextRenderId(renderid)
						DrawMovie(0.50000000, 0.50000000, 1.00000000, 1.00000000, 0.00000000, 255, 255, 255, 255)
						--SetMovieTime(time)
					else
						if block then
							StopMovie()
							ReleaseMovie()
							AmbientAudioBankNoLongerNeeded()
							SetTextRenderId(renderid)
							DrawRect(0.5, 0.5, 1.1, 1.1, 0, 0, 0, 255)
							Wait(250)
							loginform = 0
							block = false
						end
					end
				end
			end
		else
			if block then
				StopMovie()
				ReleaseMovie()
				AmbientAudioBankNoLongerNeeded()
				SetTextRenderId(renderid)
				DrawRect(0.5, 0.5, 1.1, 1.1, 0, 0, 0, 255)
				Wait(250)
				loginform = 0
				block = false
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		for i=1,#coords,1 do
			if(IsPlayerNearCoords(coords[i][1], coords[i][2], coords[i][3], 3)) then
				if not turned[i] then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to turn on TV", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						turned[i] = true
						TriggerServerEvent('turnTv', i, true)
					end
				else
					PrintStringWithLiteralStringNow("STRING", "~y~E ~w~- turn off; ~y~Arrow Down ~w~- switch channel; ~y~Arrow Left/Right ~w~- volume", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						turned[i] = false
						TriggerServerEvent('turnTv', i, false)
						--loginform = 0
					end
					if(IsGameKeyboardKeyJustPressed(200) or IsGameKeyboardKeyJustPressed(208)) then
						if(channel[i] == "CNT") then
							channel[i] = "weazel"
						else
							channel[i] = "CNT"
						end
						--SetChannel(i, channel[i])
						TriggerServerEvent('setTvChannel', i, channel[i])
					end
					if(IsGameKeyboardKeyPressed(205)) then
						volume[i] = volume[i] + 1
						if(volume[i] > 0.0) then
							volume[i] = 0.0
						end
						--SetVolume(i, volume[i])
						TriggerServerEvent('setTvVolume', i, volume[i])
					end
					if(IsGameKeyboardKeyPressed(203)) then
						volume[i] = volume[i] - 1
						if(volume[i] < -24.00000000) then
							volume[i] = -24.00000000
						end
						--SetVolume(i, volume[i])
						TriggerServerEvent('setTvVolume', i, volume[i])
					end
				end
			end
		end
	end
end)