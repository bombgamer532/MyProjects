local restimer = 0
CreateThread(function()
	while true do
		Wait(0)
		if(IsPlayerDead(GetPlayerId())) then
			restimer = 0
			while IsPlayerDead(GetPlayerId()) do
				Wait(0)
				DrawRectLeftTopCenter(0.9, 0.9, 0.05, 0.02, 0, 0, 0, 100)
				DrawRectLeftTopCenter(0.9, 0.9, 0.05/100*restimer, 0.02, 0, 0, 100, 255)
				SetTextScale(0.1500000, 0.3000000)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextEdge(1, 0, 0, 0, 255)
				DisplayTextWithLiteralString(0.9, 0.87, "STRING", "Press ~y~R ~w~to ~y~respawn")
				if(IsGameKeyboardKeyJustPressed(19)) then
					restimer = restimer + 5
				end
				if(restimer >= 100) then
					DoScreenFadeOut(1000)
					Wait(1000)
					local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
					local angle = GenerateRandomIntInRange(0, 360, _i)
					local rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+100*math.cos(angle*math.pi/180), py+100*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
					exports.spawnmanager:forceRespawn2(rx, ry, rz, rh)
					DoScreenFadeIn(1000)
				end
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(IsPlayerDead(GetPlayerId())) then
			SetCamActive(GetGameCam(), false)
			Wait(100)
			restimer = restimer + 1
		else
			if(IsPlayerControlOn(GetPlayerId())) then
				SetCamActive(GetGameCam(), true)
			end
		end
	end
end)