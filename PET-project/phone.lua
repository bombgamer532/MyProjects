local phonemenu = 0
local backid = 1
local ringid = 0
local messages = {
--{title, message}
}

RegisterNetEvent('updPhoneMessagesTitles')
AddEventHandler('updPhoneMessagesTitles', function(data)
	for i=1,#data,1 do
		messages[i] = {}
		messages[i][1] = tostring(data[i])
	end
end)

RegisterNetEvent('updPhoneMessages')
AddEventHandler('updPhoneMessages', function(data)
	for i=1,#data,1 do
		messages[i][2] = tostring(data[i])
	end
end)

RegisterNetEvent('updPhoneBack')
AddEventHandler('updPhoneBack', function(bid)
	backid = tonumber(bid)
end)

RegisterNetEvent('updPhoneRing')
AddEventHandler('updPhoneRing', function(rid)
	ringid = tonumber(rid)
end)

local bounty = {}
for i=0,31,1 do
	bounty[i] = {}
end
local bountycooldown = 0
CreateThread(function()
	while true do
		Wait(0)
		if(bountycooldown > 0) then
			Wait(1000)
			bountycooldown = bountycooldown - 1
		end
	end
end)
CreateThread(function()
	while true do
		Wait(0)
		for i=0,31,1 do
			if(not IsNetworkPlayerActive(i)) then
				bounty[i] = {}
			else
				if(#bounty[i] > 0) then
					for j=1,#bounty[i],1 do
						if(not IsNetworkPlayerActive(bounty[i][j][1])) then
							local newbounty = {}
							for k=1,#bounty[i],1 do
								if(bounty[i][k] ~= bounty[i][j]) then
									table.insert(newbounty, bounty[i][k])
								end
							end
							bounty[i] = newbounty
							TriggerServerEvent('updBounty', i, bounty[i])
						end
					end
				end
			end
		end
	end
end)
RegisterNetEvent('updBounty')
AddEventHandler('updBounty', function(id, data)
	bounty[id] = data
end)
RegisterNetEvent('setBounty')
AddEventHandler('setBounty', function(id, owner, amount)
	bounty[id][#bounty[id]+1] = {owner, amount}
	if(#bounty[id] == 1) then
		TriggerEvent('chatMessage', '[Bounty]', {255, 255, 0}, "Bounty of " .. amount .. "$ has been set on " .. GetPlayerName(id) .. "'s head!")
	else
		local totalcash = 0
		for i=1,#bounty[id],1 do
			totalcash = totalcash + bounty[id][i][2]
		end
		totalcash = totalcash + amount
		TriggerEvent('chatMessage', '[Bounty]', {255, 255, 0}, "Bounty for " .. GetPlayerName(id) .. "'s head has been increased to " .. totalcash .. "$!")
	end
end)
RegisterNetEvent('takeCash')
AddEventHandler('takeCash', function(id, amount)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		money = money - amount
		SaveStats()
		TriggerEvent('chatMessage', '[Bounty]', {0, 255, 0}, "Your target has been successfully killed (-" .. amount .. "$)")
	end
end)
CreateThread(function()
	while true do
		Wait(0)
		for i=0,31,1 do
			if(IsNetworkPlayerActive(i)) then
				if(IsPlayerDead(i)) then
					if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
						if(FindNetworkKillerOfPlayer(i) == GetPlayerId()) then
							if(#bounty[i] > 0) then
								local check = 0
								for j=1,#bounty[i],1 do
									if(ConvertIntToPlayerindex(bounty[i][j][1]) == ConvertIntToPlayerindex(GetPlayerId())) then
										check = 1
									end
								end
								if(check == 0) then
									local totalcash = 0
									for j=1,#bounty[i],1 do
										totalcash = totalcash + bounty[i][j][2]
										TriggerServerEvent('takeCash', bounty[i][j][1], bounty[i][j][2])
									end
									money = money + totalcash
									SaveStats()
									bounty[i] = {}
									TriggerServerEvent('updBounty', i, bounty[i])
									TriggerEvent('chatMessage', '[Bounty]', {0, 255, 0}, 'You have got a bounty of ' .. totalcash .. "$ for killing " .. GetPlayerName(i) .. "!")
								end
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
		RequestStreamedTxd("phone")
		while not HasStreamedTxdLoaded("phone") do
			Wait(0)
		end
		local phone = GetTextureFromStreamedTxd("phone", "phone")
		local background = GetTextureFromStreamedTxd("phone", "back" .. backid)
		--[[if(phonemenu == 1) then
			DrawSprite(phone, 0.845, 0.8, 0.2, 0.35, 0.0, 255, 255, 255, 255)
			DrawSprite(background, 0.845, 0.8, 0.09, 0.28, 0.0, 255, 255, 255, 255)
		end]]
	end
end)

local phonemenuactive = false
local phonemenuresult = 0
local phonecurrlist = 1
local currbutton = 0
local function DrawPhoneItems(title, items)
	phonemenuactive = true
	phonemenuresult = 0
	phonecurrlist = 1
	currbutton = 0
	cursor = 1
	SetCamActive(GetGameCam(), false)
	SetPlayerControl(GetPlayerId(), false)
	--items[#items+1] = "~r~Cancel"
	CreateThread(function()
		while phonemenuactive do
			Wait(0)
			SetPlayerControl(GetPlayerId(), false)
			
			RequestStreamedTxd("phone")
			while not HasStreamedTxdLoaded("phone") do
				Wait(0)
			end
			local phone = GetTextureFromStreamedTxd("phone", "phone")
			local background = GetTextureFromStreamedTxd("phone", "back" .. backid)
			DrawSprite(phone, 0.845, 0.8, 0.2, 0.35, 0.0, 255, 255, 255, 255)
			DrawSprite(background, 0.845, 0.8, 0.09, 0.28, 0.0, 255, 255, 255, 255)
			
			SetTextScale(0.200000,  0.4000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			SetTextFont(6)
			--SetTextEdge(1, 0, 0, 0, 255)
			SetTextWrap(0.0, 0.8+0.09/2)
			SetTextCentre(1)
			DisplayTextWithLiteralString(0.8+0.09/2, 0.8-0.28/2+0.005, "STRING", "" .. title)
			
			DrawRectLeftTopCenter(0.8, 0.8-0.28/2, 0.09, 0.03, 0, 0, 100, 255)
			--DrawCurvedWindow(0.3, 0.28, 0.4, 0.42, 100)
			--DrawRectLeftTopCenter(0.7, 0.1, 0.2, 0.3, 90, 90, 90, 100)
			currbutton = 0
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
				
				if(phonecurrlist > finalnum) then
					phonecurrlist = 1
				end
				
				local sep = 10
				for i=1,#templist,1 do
					if(phonecurrlist == i) then
						for j=1,#templist[i],1 do
							DrawRectLeftTopCenter(0.8, 0.8-0.28/2+0.03+0.22/sep*(j-1), 0.09, 0.22/sep, 0, 0, 0, 100)
							SetTextScale(0.100000,  0.3000000)
							SetTextDropshadow(0, 0, 0, 0, 0)
							--SetTextFont(6)
							--SetTextEdge(1, 0, 0, 0, 255)
							--SetTextWrap(0.0, 0.3)
							--SetTextCentre(1)
							DisplayTextWithLiteralString(0.8+0.0025, 0.8-0.28/2+0.03+0.22/sep*(j-1)+0.0025, "STRING", "" .. templist[i][j])
							if(IsCursorInAreaLeftTopCenter(0.8, 0.8-0.28/2+0.03+0.22/sep*(j-1), 0.09, 0.22/sep)) then
								currbutton = j+10*(i-1)
								DrawRectLeftTopCenter(0.8, 0.8-0.28/2+0.03+0.22/sep*(j-1), 0.09, 0.22/sep, 255, 255, 255, 255)
								SetTextScale(0.100000,  0.3000000)
								SetTextDropshadow(0, 0, 0, 0, 0)
								--SetTextFont(6)
								--SetTextEdge(1, 0, 0, 0, 255)
								--SetTextWrap(0.0, 0.3)
								--SetTextCentre(1)
								SetTextColour(0, 0, 0, 255)
								DisplayTextWithLiteralString(0.8+0.0025, 0.8-0.28/2+0.03+0.22/sep*(j-1)+0.0025, "STRING", "" .. templist[i][j])
								if(IsMouseButtonJustPressed(1)) then
									--if(10*(i-1)+j ~= #items) then
										phonemenuresult = 10*(i-1)+j
									--end
									phonemenuactive = false
									cursor = 0
								end
							end
							DrawRectLeftTopCenter(0.89-0.005, 0.8-0.28/2+0.03+0.22/#templist*(phonecurrlist-1), 0.005, 0.22/#templist, 255, 255, 0, 255)
						end
					end
				end
				if(GetMouseWheel(_i) ~= 0) then
					if(GetMouseWheel(_i) == 127) then
						if(phonecurrlist < #templist) then
							phonecurrlist = phonecurrlist + 1
						end
					else
						if(phonecurrlist > 1) then
							phonecurrlist = phonecurrlist - 1
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
					DrawRectLeftTopCenter(0.8, 0.8-0.28/2+0.03+0.22/sep*(i-1), 0.09, 0.22/sep, 0, 0, 0, 100)
					SetTextScale(0.100000,  0.3000000)
					SetTextDropshadow(0, 0, 0, 0, 0)
					--SetTextFont(6)
					--SetTextEdge(1, 0, 0, 0, 255)
					--SetTextWrap(0.0, 0.3)
					--SetTextCentre(1)
					DisplayTextWithLiteralString(0.8+0.0025, 0.8-0.28/2+0.03+0.22/sep*(i-1)+0.0025, "STRING", "" .. items[i])
					if(IsCursorInAreaLeftTopCenter(0.8, 0.8-0.28/2+0.03+0.22/sep*(i-1), 0.09, 0.22/sep)) then
						currbutton = i
						DrawRectLeftTopCenter(0.8, 0.8-0.28/2+0.03+0.22/sep*(i-1), 0.09, 0.22/sep, 255, 255, 255, 255)
						SetTextScale(0.100000,  0.3000000)
						SetTextDropshadow(0, 0, 0, 0, 0)
						--SetTextFont(6)
						--SetTextEdge(1, 0, 0, 0, 255)
						--SetTextWrap(0.0, 0.3)
						--SetTextCentre(1)
						SetTextColour(0, 0, 0, 255)
						DisplayTextWithLiteralString(0.8+0.0025, 0.8-0.28/2+0.03+0.22/sep*(i-1)+0.0025, "STRING", "" .. items[i])
						if(IsMouseButtonJustPressed(1)) then
							--if(i ~= #items) then
							if(items[i] ~= "~r~Cancel") then
								phonemenuresult = i
							end
							phonemenuactive = false
							cursor = 0
						end
					end
				end
			end
			if(IsMouseButtonJustPressed(2)) then
				phonemenuactive = false
				cursor = 0
			end
			
			SetTextScale(0.100000,  0.3000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			--SetTextFont(6)
			SetTextEdge(1, 0, 0, 0, 255)
			--SetTextWrap(0.0, 0.3)
			--SetTextCentre(1)
			SetTextColour(0, 255, 0, 255)
			DisplayTextWithLiteralString(0.8+0.0025, 0.8+0.28/2-0.03+0.005, "STRING", "Select (LMB)")
			
			SetTextScale(0.100000,  0.3000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			--SetTextFont(6)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextWrap(0.0, 0.89-0.005)
			--SetTextCentre(1)
			SetTextRightJustify(1)
			SetTextColour(255, 0, 0, 255)
			DisplayTextWithLiteralString(0.89-0.0025, 0.8+0.28/2-0.03+0.005, "STRING", "(RMB)_Back")
		end
		Wait(200)
		SetCamActive(GetGameCam(), true)
		SetPlayerControl(GetPlayerId(), true)
		SetGameCameraControlsActive(true)
	end)
end

local signal = false
local signaltime = 0
local function DrawPhoneSignal(text, duration)
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
			SetTextScale(0.1500000, 0.3000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			SetTextEdge(1, 0, 0, 0, 255)
			--SetTextWrap(0.0, cx)
			--SetTextCentre(1)
			DisplayTextWithLiteralString(0.05, 0.7, "STRING", "" .. text)
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

RegisterNetEvent('sendPhoneMessage')
AddEventHandler('sendPhoneMessage', function(id, title, msg)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		messages[#messages+1] = {title, msg}
		TriggerServerEvent('savePhoneMessages', messages)
		DrawPhoneSignal("New message received", 10000)
	end
end)

local phonemessageactive = false
local phonemessageresult = 0
local function DrawPhoneMessage(text, additional)
	phonemessageactive = true
	phonemessageresult = 0
	cursor = 1
	SetCamActive(GetGameCam(), false)
	SetPlayerControl(GetPlayerId(), false)
	
	local temptext = text
	local textlines = {}
	::again::
	textlines[#textlines+1] = temptext:sub(1, 25)
	temptext = temptext:sub(26, #temptext)
	if(#temptext > 0) then
		goto again
	end
	
	CreateThread(function()
		while phonemessageactive do
			Wait(0)
			SetPlayerControl(GetPlayerId(), false)
			
			RequestStreamedTxd("phone")
			while not HasStreamedTxdLoaded("phone") do
				Wait(0)
			end
			local phone = GetTextureFromStreamedTxd("phone", "phone")
			local background = GetTextureFromStreamedTxd("phone", "back" .. backid)
			DrawSprite(phone, 0.845, 0.8, 0.2, 0.35, 0.0, 255, 255, 255, 255)
			DrawSprite(background, 0.845, 0.8, 0.09, 0.28, 0.0, 255, 255, 255, 255)
			
			DrawRectLeftTopCenter(0.8, 0.8-0.28/2, 0.09, 0.25, 0, 0, 0, 100)
			for i=1,#textlines,1 do
				SetTextScale(0.100000,  0.3000000)
				SetTextDropshadow(0, 0, 0, 0, 0)
				--SetTextFont(6)
				--SetTextEdge(1, 0, 0, 0, 255)
				--SetTextWrap(0.0, 0.3)
				--SetTextCentre(1)
				DisplayTextWithLiteralString(0.8+0.0025, 0.8-0.28/2+0.25/10*(i-1)+0.0025, "STRING", "" .. textlines[i])
			end
			
			if(additional ~= nil) then
				SetTextScale(0.100000,  0.3000000)
				SetTextDropshadow(0, 0, 0, 0, 0)
				--SetTextFont(6)
				SetTextEdge(1, 0, 0, 0, 255)
				--SetTextWrap(0.0, 0.3)
				--SetTextCentre(1)
				SetTextColour(0, 255, 0, 255)
				DisplayTextWithLiteralString(0.8+0.0025, 0.8+0.28/2-0.03+0.005, "STRING", additional .. " (LMB)")
				
				if(IsMouseButtonJustPressed(1)) then
					phonemessageresult = 1
					phonemessageactive = false
					cursor = 0
				end
			end
			
			SetTextScale(0.100000,  0.3000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			--SetTextFont(6)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextWrap(0.0, 0.89-0.005)
			--SetTextCentre(1)
			SetTextRightJustify(1)
			SetTextColour(255, 0, 0, 255)
			DisplayTextWithLiteralString(0.89-0.0025, 0.8+0.28/2-0.03+0.005, "STRING", "(RMB)_Back")
			
			if(IsMouseButtonJustPressed(2)) then
				phonemessageactive = false
				cursor = 0
			end
		end
		Wait(200)
		SetCamActive(GetGameCam(), true)
		SetPlayerControl(GetPlayerId(), true)
		SetGameCameraControlsActive(true)
	end)
end

phonecall = {}
for i=0,31,1 do
	phonecall[i] = i
end
RegisterNetEvent('updateCall')
AddEventHandler('updateCall', function(id, state)
	phonecall[id] = state
end)
RegisterNetEvent('callPlayer')
AddEventHandler('callPlayer', function(target, caller)
	if(ConvertIntToPlayerindex(target) == ConvertIntToPlayerindex(GetPlayerId())) then
		phonemenuresult = 1000
		phonemenuactive = false
		phonemessageactive = false
		cursor = 0
		StartCustomMobilePhoneRinging(ringid)
		DrawPhoneItems("Incoming_call", {"Answer to " .. GetPlayerName(caller)})
		while phonemenuactive do
			Wait(0)
			SetPlayerControl(GetPlayerId(), true)
			SetCamBehindPed(GetPlayerChar(-1))
			SetGameCameraControlsActive(false)
		end
		if(phonemenuresult > 0) then
			StopMobilePhoneRinging()
			if(phonemenuresult == 1) then
				TriggerServerEvent('returnCallResult', caller, 1)
				--exports.voicechat:SetPlayerChannel(target)
				TriggerServerEvent('updateCall', target, target)
				DrawPhoneMessage("Hold N to talk")
				while phonemessageactive do
					Wait(0)
					SetPlayerControl(GetPlayerId(), true)
					SetCamBehindPed(GetPlayerChar(-1))
					SetGameCameraControlsActive(false)
				end
				--exports.voicechat:SetPlayerChannel(target)
				TriggerServerEvent('updateCall', target, target)
				TriggerServerEvent('finishCall', caller)
			end
		else
			StopMobilePhoneRinging()
			TriggerServerEvent('returnCallResult', caller, 0)
		end
	end
end)
RegisterNetEvent('cancelCall')
AddEventHandler('cancelCall', function(target)
	if(ConvertIntToPlayerindex(target) == ConvertIntToPlayerindex(GetPlayerId())) then
		phonemenuresult = 1000
		phonemenuactive = false
		cursor = 0
		StopMobilePhoneRinging()
	end
end)
RegisterNetEvent('finishCall')
AddEventHandler('finishCall', function(target)
	if(ConvertIntToPlayerindex(target) == ConvertIntToPlayerindex(GetPlayerId())) then
		--exports.voicechat:SetPlayerChannel(target)
		TriggerServerEvent('updateCall', target, target)
		phonemessageactive = false
		cursor = 0
	end
end)
callresult = nil
RegisterNetEvent('returnCallResult')
AddEventHandler('returnCallResult', function(target, result)
	if(ConvertIntToPlayerindex(target) == ConvertIntToPlayerindex(GetPlayerId())) then
		callresult = result
	end
end)

local numbers = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
local letters1 = {"q", "w", "e", "r", "t", "y", "u", "i", "o", "p"}
local letters2 = {"a", "s", "d", "f", "g", "h", "j", "k", "l"}
local letters3 = {"z", "x", "c", "v", "b", "n", "m"}
local letters1c = {"Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"}
local letters2c = {"A", "S", "D", "F", "G", "H", "J", "K", "I"}
local letters3c = {"Z", "X", "C", "V", "B", "N", "M"}
local keys = {12, 13, 26, 27, 39, 40, 41, 51, 52, 53, 55, 57}
local keysresult = {"-", "=", "[", "]", ";", "'", "`", ",", ".", "/", "*", " "}
local keys2 = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 26, 27, 53, 39, 40}
local keysresult2 = {"!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "+", "{", "}", "?", ":", "\""}

function ActivateInput(buttonname)
	local chatstring = ""
	cursor = 1
	SetCamActive(GetGameCam(), false)
	SetPlayerControl(GetPlayerId(), false)
	while true do
		Wait(0)
		SetPlayerControl(GetPlayerId(), false)
		DrawRectLeftTopCenter(0.3, 0.5, 0.4, 0.05, 0, 0, 0, 100)
		if(not IsGameKeyboardKeyPressed(42)) then --letters
			for i=1,10,1 do
				if(IsGameKeyboardKeyJustPressed(i+15)) then
					chatstring = "" .. chatstring .. "" .. letters1[i]
				end
			end
			for i=1,9,1 do
				if(IsGameKeyboardKeyJustPressed(i+29)) then
					chatstring = "" .. chatstring .. "" .. letters2[i]
				end
			end
			for i=1,7,1 do
				if(IsGameKeyboardKeyJustPressed(i+43)) then
					chatstring = "" .. chatstring .. "" .. letters3[i]
				end
			end
		else --letters with shift
			for i=1,10,1 do
				if(IsGameKeyboardKeyJustPressed(i+15)) then
					chatstring = "" .. chatstring .. "" .. letters1c[i]
				end
			end
			for i=1,9,1 do
				if(IsGameKeyboardKeyJustPressed(i+29)) then
					chatstring = "" .. chatstring .. "" .. letters2c[i]
				end
			end
			for i=1,7,1 do
				if(IsGameKeyboardKeyJustPressed(i+43)) then
					chatstring = "" .. chatstring .. "" .. letters3c[i]
				end
			end
		end
		if(not IsGameKeyboardKeyPressed(42)) then --additional symbols
			for i=1,10,1 do --numbers
				if(IsGameKeyboardKeyJustPressed(i+1)) then
					chatstring = "" .. chatstring .. "" .. numbers[i]
				end
			end
			for i=1,12,1 do --additional symbols 1
				if(IsGameKeyboardKeyJustPressed(keys[i])) then
					chatstring = "" .. chatstring .. "" .. keysresult[i]
				end
			end
		else
			for i=1,17,1 do --additional symbols 2 (with shift)
				if(IsGameKeyboardKeyJustPressed(keys2[i])) then
					chatstring = "" .. chatstring .. "" .. keysresult2[i]
				end
			end
		end
		if(IsGameKeyboardKeyJustPressed(14)) then
			--chatstring = chatstring:sub(1, -1)
			chatstring = chatstring:sub(1, #chatstring - 1)
		end
		if(chatstring ~= "") then
			if(#chatstring <= 100) then
				SetTextScale(0.100000,  0.3000000)
				SetTextEdge(1, 0, 0, 0, 255)
				--SetTextFont(6)
				--SetTextCentre(1)
				DisplayTextWithLiteralString(0.31, 0.515, "STRING", "" .. chatstring)
			else
				chatstring = chatstring:sub(1, #chatstring - 1)
				TriggerEvent('chatMessage', '[Server]', {255, 0, 0}, 'Message cannot exceed 100 characters!')
			end
		else
			SetTextScale(0.1000000,  0.3000000)
			SetTextEdge(1, 0, 0, 0, 255)
			--SetTextFont(6)
			--SetTextCentre(1)
			DisplayTextWithLiteralString(0.31, 0.515, "STRING", "Enter message")
		end
		------
		local temptext = "Send"
		if(buttonname ~= nil) then
			temptext = "" .. buttonname
		end
		DrawRectLeftTopCenter(0.4-0.1, 0.7, 0.2, 0.1, 0, 0, 0, 100)
		SetTextScale(0.300000,  0.6000000)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextCentre(1)
		SetTextWrap(0.0, 0.5-0.1)
		DisplayTextWithLiteralString(0.5-0.1, 0.73, "STRING", "" .. temptext)
		if(IsCursorInAreaLeftTopCenter(0.4-0.1, 0.7, 0.2, 0.1)) then
			DrawRectLeftTopCenter(0.4-0.1, 0.7, 0.2, 0.1, 255, 255, 255, 255)
			if(IsMouseButtonJustPressed(1)) then
				if(chatstring ~= "") then
					cursor = 0
					SetPlayerControl(GetPlayerId(), true)
					SetCamActive(GetGameCam(), true)
					return chatstring
				else
					TriggerEvent('chatMessage', '[Message]', {255, 0, 0}, 'Enter text!')
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
				return ""
			end
		end
	end
end

local waypoint = {}
CreateThread(function()
	while true do
		Wait(0)
		RemoveBlip(wayblip)
		if(#waypoint > 0) then
			wayblip = AddBlipForCoord(waypoint[1], waypoint[2], waypoint[3])
			ChangeBlipNameFromAscii(wayblip, "Waypoint")
			ChangeBlipSprite(wayblip, 8)
			SetRoute(wayblip, true)
			if(IsPlayerNearCoords(waypoint[1], waypoint[2], waypoint[3], 10)) then
				waypoint = {}
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(IsGameKeyboardKeyJustPressed(200)) then
			if(IsPlayerControlOn(GetPlayerId())) then
				--if(phonemenu == 0) then
				--	phonemenu = 1
					::main::
					local tempday = GetCurrentDayOfWeek()
					local days = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
					days[0] = "Sunday"
					local day = days[tempday]
					if(day == nil) then
						day = ""
					end
					local h,m = GetTimeOfDay()
					if(h < 10) then
						h = "0" .. h
					else
						h = "" .. h
					end
					if(m < 10) then
						m = "0" .. m
					else
						m = "" .. m
					end
					local tempitems = {}
					tempitems[#tempitems+1] = "Phonebook"
					tempitems[#tempitems+1] = "Messages"
					tempitems[#tempitems+1] = "Navigation"
					tempitems[#tempitems+1] = "Car delivery"
					local wantedprice = 0
					if(agency > 0) then
						if(StoreWantedLevel(GetPlayerId()) > 0) then
							wantedprice = math.floor(200*StoreWantedLevel(GetPlayerId()))
							tempitems[#tempitems+1] = "Remove wanted level ~g~(" .. wantedprice .. "$)"
						end
					end
					tempitems[#tempitems+1] = "Bounties"
					tempitems[#tempitems+1] = "MP3 player"
					tempitems[#tempitems+1] = "Settings"
					--tempitems[#tempitems+1] = "Change background"
					DrawPhoneItems("" .. day .. "_" .. h .. ":" .. m, tempitems)
					while phonemenuactive do
						Wait(0)
						SetPlayerControl(GetPlayerId(), true)
						SetCamBehindPed(GetPlayerChar(-1))
						SetGameCameraControlsActive(false)
					end
					if(phonemenuresult > 0) then
						if(tempitems[phonemenuresult] == "Phonebook") then
							::phonebook::
							local tempplayers = {}
							for i=0,31,1 do
								if(IsNetworkPlayerActive(i)) then
									if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
										tempplayers[#tempplayers+1] = i
									end
								end
							end
							local tempitems = {}
							tempitems[#tempitems+1] = "Police"
							tempitems[#tempitems+1] = "Ambulance"
							tempitems[#tempitems+1] = "Firefighter"
							if(org > 0) then
								tempitems[#tempitems+1] = "Gun van"
								tempitems[#tempitems+1] = "Personal driver"
							end
							for i=1,#tempplayers,1 do
								tempitems[#tempitems+1] = "" .. GetPlayerName(tempplayers[i])
							end
							DrawPhoneItems("Phonebook", tempitems)
							while phonemenuactive do
								Wait(0)
								SetPlayerControl(GetPlayerId(), true)
								SetCamBehindPed(GetPlayerChar(-1))
								SetGameCameraControlsActive(false)
							end
							if(phonemenuresult > 0) then
								if(tempitems[phonemenuresult] == "Police") then
									DeleteCar(emscar)
									DeleteChar(emsped)
									local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
									local angle = GenerateRandomIntInRange(0, 360, _i)
									local radius = 200
									local rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
									emscar = SpawnCar(GetHashKey("police2"), rx, ry, rz, rh)
									emsped = SpawnPed(GetHashKey("M_Y_COP"), rx, ry, rz, rh)
									WarpCharIntoCar(emsped, emscar)
									SwitchCarSiren(emscar, true)
									TaskCarMissionCoorsTarget(emsped, emscar, px, py, pz, 4, 20.1, 3, 10, 10)
									TriggerEvent('chatMessage', '[Emergency]', {255, 255, 0}, 'Police has been requested. Please wait...')
								elseif(tempitems[phonemenuresult] == "Ambulance") then
									DeleteCar(emscar)
									DeleteChar(emsped)
									local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
									local angle = GenerateRandomIntInRange(0, 360, _i)
									local radius = 200
									local rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
									emscar = SpawnCar(GetHashKey("ambulance"), rx, ry, rz, rh)
									emsped = SpawnPed(GetHashKey("M_Y_PMEDIC"), rx, ry, rz, rh)
									WarpCharIntoCar(emsped, emscar)
									SwitchCarSiren(emscar, true)
									TaskCarMissionCoorsTarget(emsped, emscar, px, py, pz, 4, 20.1, 3, 10, 10)
									TriggerEvent('chatMessage', '[Emergency]', {255, 255, 0}, 'Ambulance has been requested. Please wait...')
								elseif(tempitems[phonemenuresult] == "Firefighter") then
									DeleteCar(emscar)
									DeleteChar(emsped)
									local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
									local angle = GenerateRandomIntInRange(0, 360, _i)
									local radius = 200
									local rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
									emscar = SpawnCar(GetHashKey("firetruk"), rx, ry, rz, rh)
									emsped = SpawnPed(GetHashKey("M_Y_FIREMAN"), rx, ry, rz, rh)
									WarpCharIntoCar(emsped, emscar)
									SwitchCarSiren(emscar, true)
									TaskCarMissionCoorsTarget(emsped, emscar, px, py, pz, 4, 20.1, 3, 10, 10)
									TriggerEvent('chatMessage', '[Emergency]', {255, 255, 0}, 'Firefighter has been requested. Please wait...')
								elseif(tempitems[phonemenuresult] == "Gun van") then
									DeleteCar(gunvan)
									DeleteChar(gunped)
									local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
									local angle = GenerateRandomIntInRange(0, 360, _i)
									local radius = 200
									local rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
									gunvan = SpawnCar(GetHashKey("slamvan"), rx, ry, rz, rh)
									LockCarDoors(gunvan, 2)
									gunped = SpawnPed(GetHashKey("M_Y_DEALER"), rx, ry, rz, rh)
									WarpCharIntoCar(gunped, gunvan)
									TaskCarMissionCoorsTarget(gunped, gunvan, px, py, pz, 4, 20.1, 3, 10, 10)
									TriggerEvent('chatMessage', '[Gun van]', {255, 255, 0}, 'Gun van has been requested. Please wait...')
								elseif(tempitems[phonemenuresult] == "Personal driver") then
									DeleteCar(limo)
									DeleteChar(limoped)
									local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
									local angle = GenerateRandomIntInRange(0, 360, _i)
									local radius = 200
									local rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
									limo = SpawnCar(GetHashKey("stretch"), rx, ry, rz, rh)
									LockCarDoors(limo, 2)
									limoped = SpawnPed(GetHashKey("m_y_goon_01"), rx, ry, rz, rh)
									WarpCharIntoCar(limoped, limo)
									TaskCarMissionCoorsTarget(limoped, limo, px, py, pz, 4, 20.1, 3, 10, 10)
									TriggerEvent('chatMessage', '[Personal driver]', {255, 255, 0}, 'Limousine has been requested. Please wait...')
								else
									local currplayer = nil
									if(org > 0) then
										currplayer = tempplayers[phonemenuresult-5]
									else
										currplayer = tempplayers[phonemenuresult-3]
									end
									local tempitems = {}
									tempitems[#tempitems+1] = "Send message"
									tempitems[#tempitems+1] = "Call"
									DrawPhoneItems("" .. GetStringWithoutSpaces("" .. GetPlayerName(currplayer)), tempitems)
									while phonemenuactive do
										Wait(0)
										SetPlayerControl(GetPlayerId(), true)
										SetCamBehindPed(GetPlayerChar(-1))
										SetGameCameraControlsActive(false)
									end
									if(phonemenuresult > 0) then
										if(tempitems[phonemenuresult] == "Send message") then
											local message = ActivateInput()
											if(message ~= "") then
												TriggerServerEvent('sendPhoneMessage', currplayer, "Message from " .. GetPlayerName(GetPlayerId()), message)
											end
											goto phonebook
										elseif(tempitems[phonemenuresult] == "Call") then
											if(phonecall[currplayer] == currplayer) then
												TriggerServerEvent('callPlayer', currplayer, ConvertIntToPlayerindex(GetPlayerId()))
												DrawPhoneMessage("Calling to " .. GetPlayerName(currplayer) .. "...")
												while phonemessageactive do
													Wait(0)
													SetPlayerControl(GetPlayerId(), true)
													SetCamBehindPed(GetPlayerChar(-1))
													SetGameCameraControlsActive(false)
													if(callresult ~= nil) then
														if(callresult == 0) then
															callresult = nil
															cursor = 0
															phonemessageactive = false
															Wait(100)
															DrawPhoneMessage("The call was rejected.")
															while phonemessageactive do
																Wait(0)
																SetPlayerControl(GetPlayerId(), true)
																SetCamBehindPed(GetPlayerChar(-1))
																SetGameCameraControlsActive(false)
															end
															goto finish4
														else
															callresult = nil
															cursor = 0
															phonemessageactive = false
															Wait(100)
															--exports.voicechat:SetPlayerChannel(currplayer)
															TriggerServerEvent('updateCall', ConvertIntToPlayerindex(GetPlayerId()), currplayer)
															DrawPhoneMessage("Hold N to talk")
															while phonemessageactive do
																Wait(0)
																SetPlayerControl(GetPlayerId(), true)
																SetCamBehindPed(GetPlayerChar(-1))
																SetGameCameraControlsActive(false)
															end
															--exports.voicechat:SetPlayerChannel(ConvertIntToPlayerindex(GetPlayerId()))
															TriggerServerEvent('updateCall', ConvertIntToPlayerindex(GetPlayerId()), ConvertIntToPlayerindex(GetPlayerId()))
															TriggerServerEvent('finishCall', currplayer)
															goto finish4
														end
													end
												end
												TriggerServerEvent('cancelCall', currplayer)
												::finish4::
											else
												DrawPhoneMessage("This player is currently talking.")
												while phonemessageactive do
													Wait(0)
													SetPlayerControl(GetPlayerId(), true)
													SetCamBehindPed(GetPlayerChar(-1))
													SetGameCameraControlsActive(false)
												end
											end
										end
									else
										goto phonebook
									end
								end
							else
								goto main
							end
						elseif(tempitems[phonemenuresult] == "Messages") then
							::messages::
							local tempitems = {}
							for i=1,#messages,1 do
								tempitems[i] = "" .. messages[i][1]
							end
							DrawPhoneItems("Messages", tempitems)
							while phonemenuactive do
								Wait(0)
								SetPlayerControl(GetPlayerId(), true)
								SetCamBehindPed(GetPlayerChar(-1))
								SetGameCameraControlsActive(false)
							end
							if(phonemenuresult > 0) then
								local currmessage = phonemenuresult
								DrawPhoneMessage("" .. messages[phonemenuresult][2], "Options")
								while phonemessageactive do
									Wait(0)
									SetPlayerControl(GetPlayerId(), true)
									SetCamBehindPed(GetPlayerChar(-1))
									SetGameCameraControlsActive(false)
								end
								if(phonemessageresult > 0) then
									local tempitems = {}
									tempitems[#tempitems+1] = "Delete"
									DrawPhoneItems("Options", tempitems)
									while phonemenuactive do
										Wait(0)
										SetPlayerControl(GetPlayerId(), true)
										SetCamBehindPed(GetPlayerChar(-1))
										SetGameCameraControlsActive(false)
									end
									if(phonemenuresult > 0) then
										if(tempitems[phonemenuresult] == "Delete") then
											local newmessages = {}
											for i=1,#messages,1 do
												if(messages[i] ~= messages[currmessage]) then
													table.insert(newmessages, messages[i])
												end
											end
											messages = newmessages
											TriggerServerEvent('savePhoneMessages', messages)
											goto messages
										end
									else
										goto messages
									end
								end
								goto messages
							else
								goto main
							end
						elseif(tempitems[phonemenuresult] == "Navigation") then
							::navigation::
							local tempitems = {}
							tempitems[#tempitems+1] = "Important places"
							tempitems[#tempitems+1] = "Missions"
							tempitems[#tempitems+1] = "Apartments"
							tempitems[#tempitems+1] = "Boatyards"
							tempitems[#tempitems+1] = "Helipads"
							tempitems[#tempitems+1] = "Hangars"
							tempitems[#tempitems+1] = "Businesses"
							tempitems[#tempitems+1] = "Specials"
							tempitems[#tempitems+1] = "Side-jobs"
							tempitems[#tempitems+1] = "Game modes"
							tempitems[#tempitems+1] = "Remove waypoint"
							DrawPhoneItems("Navigation", tempitems)
							while phonemenuactive do
								Wait(0)
								SetPlayerControl(GetPlayerId(), true)
								SetCamBehindPed(GetPlayerChar(-1))
								SetGameCameraControlsActive(false)
							end
							if(phonemenuresult > 0) then
								if(tempitems[phonemenuresult] == "Important places") then
									local tempitems = {}
									tempitems[#tempitems+1] = "Closest shop"
									tempitems[#tempitems+1] = "Closest gun shop"
									tempitems[#tempitems+1] = "Closest car shop"
									tempitems[#tempitems+1] = "Closest clothes shop"
									tempitems[#tempitems+1] = "Closest respray"
									tempitems[#tempitems+1] = "Closest internet cafe"
									tempitems[#tempitems+1] = "Tuning shop"
									tempitems[#tempitems+1] = "Boat tuning shop"
									tempitems[#tempitems+1] = "Helicopter tuning shop"
									tempitems[#tempitems+1] = "Plane tuning shop"
									tempitems[#tempitems+1] = "Lucky wheel"
									DrawPhoneItems("Important_places", tempitems)
									while phonemenuactive do
										Wait(0)
										SetPlayerControl(GetPlayerId(), true)
										SetCamBehindPed(GetPlayerChar(-1))
										SetGameCameraControlsActive(false)
									end
									if(phonemenuresult > 0) then
										if(tempitems[phonemenuresult] == "Closest shop") then
											local tempcoord = GetClosestCoord({
											{-426.56821, 1195.42383, 13.05202, 87.5031280517578, -926145642},
											{-170.75505, 288.78564, 14.82508, 90.2621307373047, -926145642},
											{-616.34241, 132.31723, 4.81617, 0.593680620193481, -926145642},
											{-1007.28607, 1628.16931, 24.31901, 179.980697631836, -926145642},
											{451.06821, 1503.71033, 16.32071, 29.1426696777344, -926145642},
											{1111.88635, 1585.50928, 16.91252, 43.5563163757324, -926145642},
											{1637.823, 224.83444, 25.21699, 269.103759765625, -926145642}
											})
											waypoint = {tempcoord[1], tempcoord[2], tempcoord[3]}
										elseif(tempitems[phonemenuresult] == "Closest gun shop") then
											local tempcoord = GetClosestCoord({
											{1067.31335, 87.11202, 34.25125, 178.692932128906},
											{82.20334, -342.00589, 11.18179, 178.316635131836},
											{-1333.16357, 318.77249, 14.62244, 276.131530761719}
											})
											waypoint = {tempcoord[1], tempcoord[2], tempcoord[3]}
										elseif(tempitems[phonemenuresult] == "Closest car shop") then
											local tempcoord = GetClosestCoord({
											{-1496.90393, 1118.74939, 23.21376, 269.805053710938},
											{-1088.06372, 1473.52173, 24.79185, 90.0429992675781},
											{80.17219, 801.10474, 15.16314, 270.032409667969}
											})
											waypoint = {tempcoord[1], tempcoord[2], tempcoord[3]}
										elseif(tempitems[phonemenuresult] == "Closest clothes shop") then
											local tempcoord = GetClosestCoord({
											{-284.48291, 1364.14771, 25.63738, 222.996063232422},
											{22.29914, 798.54492, 14.7668, 0.411204695701599},
											{10.81859, -670.22687, 14.86652, 359.982604980469},
											{880.54913, -446.63824, 15.85833, 311.022064208984}
											})
											waypoint = {tempcoord[1], tempcoord[2], tempcoord[3]}
										elseif(tempitems[phonemenuresult] == "Closest respray") then
											local tempcoord = GetClosestCoord({
											{-307.8573, 1539.99805, 20.30938, 359.974426269531},
											{-1148.06714, 1188.22766, 17.50671, 177.032287597656},
											{-1300.18738, 283.09348, 10.80944, 178.410720825195},
											{1058.24109, -296.93875, 21.35996, 356.611114501953},
											{-513.74414, 367.13248, 6.48891, 357.628387451172}
											})
											waypoint = {tempcoord[1], tempcoord[2], tempcoord[3]}
										elseif(tempitems[phonemenuresult] == "Closest internet cafe") then
											local tempcoord = GetClosestCoord({
											{-1572.75037, 461.73026, 24.9496, 239.948699951172},
											{-330.04291, 1394.24402, 12.41896, 269.362274169922},
											{966.72644, -174.15999, 23.69951, 105.562049865723}
											})
											waypoint = {tempcoord[1], tempcoord[2], tempcoord[3]}
										elseif(tempitems[phonemenuresult] == "Tuning shop") then
											waypoint = {876.68719, -116.28477, 6.02292}
										elseif(tempitems[phonemenuresult] == "Boat tuning shop") then
											waypoint = {420.75119, 1094.61877, -0.49913}
										elseif(tempitems[phonemenuresult] == "Helicopter tuning shop") then
											waypoint = {-267.25989, 215.44418, 222.59259}
										elseif(tempitems[phonemenuresult] == "Plane tuning shop") then
											waypoint = {2631.94238, 376.37827, 5.81486}
										elseif(tempitems[phonemenuresult] == "Lucky wheel") then
											waypoint = {-234.95645, 47.55979, 15.705}
										end
										goto navigation
									else
										goto navigation
									end
								elseif(tempitems[phonemenuresult] == "Missions") then
									local tempitems = {}
									for i=1,#mis,1 do
										tempitems[i] = "" .. mis[i].name .. " (" .. mis[i].level .. ")"
									end
									DrawPhoneItems("Missions", tempitems)
									while phonemenuactive do
										Wait(0)
										SetPlayerControl(GetPlayerId(), true)
										SetCamBehindPed(GetPlayerChar(-1))
										SetGameCameraControlsActive(false)
									end
									if(phonemenuresult > 0) then
										waypoint = {mis[phonemenuresult].pos[1], mis[phonemenuresult].pos[2], mis[phonemenuresult].pos[3]}
										goto navigation
									else
										goto navigation
									end
								elseif(tempitems[phonemenuresult] == "Apartments") then
									local tempitems = {}
									for i=1,#houseinfo,1 do
										tempitems[i] = "Apartment #" .. i .. " (" .. houseinfo[i][1] .. "$)"
									end
									DrawPhoneItems("Apartments", tempitems)
									while phonemenuactive do
										Wait(0)
										SetPlayerControl(GetPlayerId(), true)
										SetCamBehindPed(GetPlayerChar(-1))
										SetGameCameraControlsActive(false)
									end
									if(phonemenuresult > 0) then
										waypoint = {houseinfo[phonemenuresult][2][1], houseinfo[phonemenuresult][2][2], houseinfo[phonemenuresult][2][3]}
										goto navigation
									else
										goto navigation
									end
								elseif(tempitems[phonemenuresult] == "Boatyards") then
									local tempitems = {}
									for i=1,#boatinfo,1 do
										tempitems[i] = "Boatyard #" .. i .. " (" .. boatinfo[i][1] .. "$)"
									end
									DrawPhoneItems("Boatyards", tempitems)
									while phonemenuactive do
										Wait(0)
										SetPlayerControl(GetPlayerId(), true)
										SetCamBehindPed(GetPlayerChar(-1))
										SetGameCameraControlsActive(false)
									end
									if(phonemenuresult > 0) then
										waypoint = {boatinfo[phonemenuresult][2][1], boatinfo[phonemenuresult][2][2], boatinfo[phonemenuresult][2][3]}
										goto navigation
									else
										goto navigation
									end
								elseif(tempitems[phonemenuresult] == "Helipads") then
									local tempitems = {}
									for i=1,#heliinfo,1 do
										tempitems[i] = "Helipad #" .. i .. " (" .. heliinfo[i][1] .. "$)"
									end
									DrawPhoneItems("Helipads", tempitems)
									while phonemenuactive do
										Wait(0)
										SetPlayerControl(GetPlayerId(), true)
										SetCamBehindPed(GetPlayerChar(-1))
										SetGameCameraControlsActive(false)
									end
									if(phonemenuresult > 0) then
										waypoint = {heliinfo[phonemenuresult][2][1], heliinfo[phonemenuresult][2][2], heliinfo[phonemenuresult][2][3]}
										goto navigation
									else
										goto navigation
									end
								elseif(tempitems[phonemenuresult] == "Hangars") then
									local tempitems = {}
									for i=1,#hangarinfo,1 do
										tempitems[i] = "Hangar #" .. i .. " (" .. hangarinfo[i][1] .. "$)"
									end
									DrawPhoneItems("Hangars", tempitems)
									while phonemenuactive do
										Wait(0)
										SetPlayerControl(GetPlayerId(), true)
										SetCamBehindPed(GetPlayerChar(-1))
										SetGameCameraControlsActive(false)
									end
									if(phonemenuresult > 0) then
										waypoint = {hangarinfo[phonemenuresult][2][1], hangarinfo[phonemenuresult][2][2], hangarinfo[phonemenuresult][2][3]}
										goto navigation
									else
										goto navigation
									end
								elseif(tempitems[phonemenuresult] == "Businesses") then
									local tempitems = {}
									tempitems[#tempitems+1] = "F Auto Repair"
									tempitems[#tempitems+1] = "Muscle Mary's"
									tempitems[#tempitems+1] = "Ron"
									tempitems[#tempitems+1] = "Terroil"
									tempitems[#tempitems+1] = "Globe Oil"
									tempitems[#tempitems+1] = "The Triangle Club"
									tempitems[#tempitems+1] = "Honkers"
									tempitems[#tempitems+1] = "Topaz Car Park"
									tempitems[#tempitems+1] = "Leftwood Car Park"
									tempitems[#tempitems+1] = "Airport Car Park"
									tempitems[#tempitems+1] = "East Hook Warehouse"
									tempitems[#tempitems+1] = "Fishmarket Warehouse"
									tempitems[#tempitems+1] = "Bahama Mamas"
									--tempitems[#tempitems+1] = "Hercules"
									--tempitems[#tempitems+1] = "Maisonette 9"
									tempitems[#tempitems+1] = "Lost MC"
									tempitems[#tempitems+1] = "Angels of Death"
									DrawPhoneItems("Businesses", tempitems)
									while phonemenuactive do
										Wait(0)
										SetPlayerControl(GetPlayerId(), true)
										SetCamBehindPed(GetPlayerChar(-1))
										SetGameCameraControlsActive(false)
									end
									if(phonemenuresult > 0) then
										if(tempitems[phonemenuresult] == "F Auto Repair") then
											waypoint = {1790.29871, 192.80301, 21.09239}
										elseif(tempitems[phonemenuresult] == "Muscle Mary's") then
											waypoint = {705.50323, 1512.13904, 14.84259}
										elseif(tempitems[phonemenuresult] == "Ron") then
											waypoint = {763.99829, 190.9456, 6.19825}
										elseif(tempitems[phonemenuresult] == "Terroil") then
											waypoint = {106.01157, 1120.41931, 14.67003}
										elseif(tempitems[phonemenuresult] == "Globe Oil") then
											waypoint = {-1408.60828, 33.21207, 7.15618}
										elseif(tempitems[phonemenuresult] == "The Triangle Club") then
											waypoint = {1150.92285, 1670.46143, 16.72696}
										elseif(tempitems[phonemenuresult] == "Honkers") then
											waypoint = {-1578.08435, 1.42009, 10.01467}
										elseif(tempitems[phonemenuresult] == "Topaz Car Park") then
											waypoint = {54.20298, 1112.75818, 3.59875}
										elseif(tempitems[phonemenuresult] == "Leftwood Car Park") then
											waypoint = {-1035.18567, 1404.40918, 25.83926}
										elseif(tempitems[phonemenuresult] == "Airport Car Park") then
											waypoint = {2276.02515, 372.60135, 7.4955}
										elseif(tempitems[phonemenuresult] == "East Hook Warehouse") then
											waypoint = {785.70697, -175.26114, 6.09661}
										elseif(tempitems[phonemenuresult] == "Fishmarket Warehouse") then
											waypoint = {344.24582, -226.75497, 5.73458}
										elseif(tempitems[phonemenuresult] == "Bahama Mamas") then
											waypoint = {-399.89844, 396.58929, 14.41455}
										elseif(tempitems[phonemenuresult] == "Hercules") then
											waypoint = {-438.55597, 348.77353, 11.71665}
										elseif(tempitems[phonemenuresult] == "Maisonette 9") then
											waypoint = {-487.60895, 162.38007, 7.68131}
										elseif(tempitems[phonemenuresult] == "Lost MC") then
											waypoint = {-1715.17285, 354.49796, 26.34677}
										elseif(tempitems[phonemenuresult] == "Angels of Death") then
											waypoint = {-624.85583, 1207.82568, 6.06082}
										end
										goto navigation
									else
										goto navigation
									end
								elseif(tempitems[phonemenuresult] == "Specials") then
									local tempitems = {}
									tempitems[#tempitems+1] = "Organization"
									tempitems[#tempitems+1] = "Storage"
									tempitems[#tempitems+1] = "Agency"
									DrawPhoneItems("Specials", tempitems)
									while phonemenuactive do
										Wait(0)
										SetPlayerControl(GetPlayerId(), true)
										SetCamBehindPed(GetPlayerChar(-1))
										SetGameCameraControlsActive(false)
									end
									if(phonemenuresult > 0) then
										if(tempitems[phonemenuresult] == "Organization") then
											waypoint = {126.44315, -668.15814, 14.77173}
										elseif(tempitems[phonemenuresult] == "Storage") then
											waypoint = {695.12683, 1464.05505, 14.85285}
										elseif(tempitems[phonemenuresult] == "Agency") then
											waypoint = {-80.0815, 51.95913, 19.62856}
										end
										goto navigation
									else
										goto navigation
									end
								elseif(tempitems[phonemenuresult] == "Side-jobs") then
									local tempitems = {}
									tempitems[#tempitems+1] = "Closest shooting range"
									tempitems[#tempitems+1] = "Closest checkpoint race"
									tempitems[#tempitems+1] = "Car sale"
									tempitems[#tempitems+1] = "Trucking"
									tempitems[#tempitems+1] = "Boat supply"
									tempitems[#tempitems+1] = "Bus driver"
									tempitems[#tempitems+1] = "Garbage trucker"
									tempitems[#tempitems+1] = "Subway driver"
									DrawPhoneItems("Side-jobs", tempitems)
									while phonemenuactive do
										Wait(0)
										SetPlayerControl(GetPlayerId(), true)
										SetCamBehindPed(GetPlayerChar(-1))
										SetGameCameraControlsActive(false)
									end
									if(phonemenuresult > 0) then
										if(tempitems[phonemenuresult] == "Closest shooting range") then
											local tempcoord = GetClosestCoord({
											{-1307.63049, 304.76132, 13.43661},
											{105.22015, -368.34442, 14.76503},
											{1043.1344, 49.22543, 33.6464}
											})
											waypoint = {tempcoord[1], tempcoord[2], tempcoord[3]}
										elseif(tempitems[phonemenuresult] == "Closest checkpoint race") then
											local tempcoord = GetClosestCoord({
											{-196.93669, 1208.56311, 14.48088, 89.5987701416016},
											{-173.27719, -588.92999, 4.81455, 89.2749404907227}
											})
											waypoint = {tempcoord[1], tempcoord[2], tempcoord[3]}
										elseif(tempitems[phonemenuresult] == "Car sale") then
											waypoint = {935.7099, 1556.32336, 16.80302}
										elseif(tempitems[phonemenuresult] == "Trucking") then
											waypoint = {-933.73364, 313.80618, 4.47026}
										elseif(tempitems[phonemenuresult] == "Boat supply") then
											waypoint = {724.56818, 7.67924, 6.03773}
										elseif(tempitems[phonemenuresult] == "Bus driver") then
											waypoint = {1034.09448, 298.09409, 32.03739}
										elseif(tempitems[phonemenuresult] == "Garbage trucker") then
											waypoint = {359.98627, -360.16705, 5.87929}
										elseif(tempitems[phonemenuresult] == "Subway driver") then
											waypoint = {1023.68921, -547.24896, 24.69202}
										end
										goto navigation
									else
										goto navigation
									end
								elseif(tempitems[phonemenuresult] == "Game modes") then
									local tempitems = {}
									tempitems[#tempitems+1] = "Deathmatch 1"
									tempitems[#tempitems+1] = "Deathmatch 2"
									tempitems[#tempitems+1] = "Deathmatch 3"
									tempitems[#tempitems+1] = "Gun game 1"
									tempitems[#tempitems+1] = "Race 1"
									tempitems[#tempitems+1] = "Race 2"
									tempitems[#tempitems+1] = "Race 3"
									tempitems[#tempitems+1] = "Race 4"
									tempitems[#tempitems+1] = "Pursuit race 1"
									tempitems[#tempitems+1] = "Pursuit race 2"
									tempitems[#tempitems+1] = "Pursuit race 3"
									tempitems[#tempitems+1] = "Survival 1"
									tempitems[#tempitems+1] = "Derby 1"
									tempitems[#tempitems+1] = "APC Battle 1"
									tempitems[#tempitems+1] = "APC Battle 2"
									DrawPhoneItems("Game_modes", tempitems)
									while phonemenuactive do
										Wait(0)
										SetPlayerControl(GetPlayerId(), true)
										SetCamBehindPed(GetPlayerChar(-1))
										SetGameCameraControlsActive(false)
									end
									if(phonemenuresult > 0) then
										if(tempitems[phonemenuresult] == "Deathmatch 1") then
											waypoint = {456.8407, 293.80322, 8.70864}
										elseif(tempitems[phonemenuresult] == "Deathmatch 2") then
											waypoint = {-1831.24683, -659.117, 3.04918}
										elseif(tempitems[phonemenuresult] == "Deathmatch 3") then
											waypoint = {1920.90796, 425.0192, 18.20598}
										elseif(tempitems[phonemenuresult] == "Gun game 1") then
											waypoint = {-697.58844, 154.52199, 4.81718}
										elseif(tempitems[phonemenuresult] == "Race 1") then
											waypoint = {-590.67426, 1416.15137, 9.88483}
										elseif(tempitems[phonemenuresult] == "Race 2") then
											waypoint = {-476.01187, 228.96767, 9.86433}
										elseif(tempitems[phonemenuresult] == "Race 3") then
											waypoint = {1335.30139, 892.88434, 13.76129}
										elseif(tempitems[phonemenuresult] == "Race 4") then
											waypoint = {-1485.82654, 1413.13184, 13.05528}
										elseif(tempitems[phonemenuresult] == "Pursuit race 1") then
											waypoint = {245.37164, -705.11041, 4.95597}
										elseif(tempitems[phonemenuresult] == "Pursuit race 2") then
											waypoint = {1433.75598, 1705.16309, 16.70929}
										elseif(tempitems[phonemenuresult] == "Pursuit race 3") then
											waypoint = {-1252.71118, -552.43097, 2.87905}
										elseif(tempitems[phonemenuresult] == "Survival 1") then
											waypoint = {-441.33722, -956.42731, 3.62176}
										elseif(tempitems[phonemenuresult] == "Derby 1") then
											waypoint = {1593.30774, 901.17218, 16.15937}
										elseif(tempitems[phonemenuresult] == "APC Battle 1") then
											waypoint = {-572.83936, -13.51472, 4.81739}
										elseif(tempitems[phonemenuresult] == "APC Battle 2") then
											waypoint = {2218.43066, 367.85641, 17.21117}
										end
										goto navigation
									else
										goto navigation
									end
								elseif(tempitems[phonemenuresult] == "Remove waypoint") then
									waypoint = {}
									goto navigation
								end
							else
								goto main
							end
						elseif(tempitems[phonemenuresult] == "Car delivery") then
							::delivery::
							local tempitems = {}
							tempitems[#tempitems+1] = "Personal vehicles"
							tempitems[#tempitems+1] = "Misc vehicles"
							tempitems[#tempitems+1] = "Trucks"
							DrawPhoneItems("Car_delivery", tempitems)
							while phonemenuactive do
								Wait(0)
								SetPlayerControl(GetPlayerId(), true)
								SetCamBehindPed(GetPlayerChar(-1))
								SetGameCameraControlsActive(false)
							end
							if(phonemenuresult > 0) then
								if(tempitems[phonemenuresult] == "Personal vehicles") then
									::vehs::
									local tempitems = {}
									for j=1,#cars,1 do
										if(cars[j] == 1) then
											tempitems[#tempitems+1] = "" .. carinfo[j][1]
										end
									end
									DrawPhoneItems("Personal_vehicles", tempitems)
									while phonemenuactive do
										Wait(0)
										SetPlayerControl(GetPlayerId(), true)
										SetCamBehindPed(GetPlayerChar(-1))
										SetGameCameraControlsActive(false)
									end
									if(phonemenuresult > 0) then
										local tempcarid = 0
										for j=1,#carinfo,1 do
											if(carinfo[j][1] == tempitems[phonemenuresult]) then
												tempcarid = j
											end
										end
										DrawPhoneItems("" .. tempitems[phonemenuresult], {"Deliver ~g~(1000$)"})
										while phonemenuactive do
											Wait(0)
											SetPlayerControl(GetPlayerId(), true)
											SetCamBehindPed(GetPlayerChar(-1))
											SetGameCameraControlsActive(false)
										end
										if(phonemenuresult > 0) then
											if(phonemenuresult == 1) then
												if(money >= 1000) then
													money = money - 1000
													SaveStats()
													local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
													local cb,cx,cy,cz,ch = GetNextClosestCarNodeWithHeading(px, py, pz, _f, _f, _f, _f)
													DeleteCar(car)
													car = SpawnCar(carinfo[tempcarid][3], cx, cy, cz, ch)
													SetVehicleTuning(car)
													RemoveBlip(carblip)
													carblip = AddBlipForCar(car, _i)
													TriggerEvent('chatMessage', '[Delivery]', {0, 255, 0}, 'Vehicle delivered to the marked point.')
												else
													TriggerEvent('chatMessage', '[Delivery]', {255, 0, 0}, 'You do not have enough money!')
												end
											end
										else
											goto vehs
										end
									else
										goto delivery
									end
								elseif(tempitems[phonemenuresult] == "Misc vehicles") then
									if(supporter == 1) then
										::misc::
										local tempitems = {}
										for j=1,#misccars,1 do
											tempitems[#tempitems+1] = "" .. misccars[j][1]
										end
										DrawPhoneItems("Misc_vehicles", tempitems)
										while phonemenuactive do
											Wait(0)
											SetPlayerControl(GetPlayerId(), true)
											SetCamBehindPed(GetPlayerChar(-1))
											SetGameCameraControlsActive(false)
										end
										if(phonemenuresult > 0) then
											local tempcarid = 0
											local tempcarid2 = 0
											for j=1,#misccars,1 do
												if(misccars[j][1] == tempitems[phonemenuresult]) then
													tempcarid = #carinfo + j
													tempcarid2 = j
												end
											end
											DrawPhoneItems("" .. tempitems[phonemenuresult], {"Deliver ~g~(1000$)"})
											while phonemenuactive do
												Wait(0)
												SetPlayerControl(GetPlayerId(), true)
												SetCamBehindPed(GetPlayerChar(-1))
												SetGameCameraControlsActive(false)
											end
											if(phonemenuresult > 0) then
												if(phonemenuresult == 1) then
													if(money >= 1000) then
														money = money - 1000
														SaveStats()
														local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
														local cb,cx,cy,cz,ch = GetNextClosestCarNodeWithHeading(px, py, pz, _f, _f, _f, _f)
														DeleteCar(car)
														car = SpawnCar(misccars[tempcarid2][2], cx, cy, cz, ch)
														SetVehicleTuning(car)
														TriggerEvent('chatMessage', '[Delivery]', {0, 255, 0}, 'Vehicle delivered to the marked point.')
													else
														TriggerEvent('chatMessage', '[Delivery]', {255, 0, 0}, 'You do not have enough money!')
													end
												end
											else
												goto misc
											end
										else
											goto delivery
										end
									else
										TriggerEvent('chatMessage', '[Delivery]', {255, 0, 0}, 'You must be a supporter to use it!')
										goto delivery
									end
								elseif(tempitems[phonemenuresult] == "Trucks") then
									if(supporter == 1) then
										::trucks::
										local tempitems = {}
										for j=1,#trucks,1 do
											if(trucks[j] == 1) then
												tempitems[#tempitems+1] = "" .. truckinfo[j][1]
											end
										end
										DrawPhoneItems("Trucks", tempitems)
										while phonemenuactive do
											Wait(0)
											SetPlayerControl(GetPlayerId(), true)
											SetCamBehindPed(GetPlayerChar(-1))
											SetGameCameraControlsActive(false)
										end
										if(phonemenuresult > 0) then
											local tempcarid = 0
											local tempcarid2 = 0
											for j=1,#truckinfo,1 do
												if(truckinfo[j][1] == tempitems[phonemenuresult]) then
													tempcarid = j
													tempcarid2 = #carinfo + #misccars + j
												end
											end
											DrawPhoneItems("" .. tempitems[phonemenuresult], {"Deliver ~g~(1000$)"})
											while phonemenuactive do
												Wait(0)
												SetPlayerControl(GetPlayerId(), true)
												SetCamBehindPed(GetPlayerChar(-1))
												SetGameCameraControlsActive(false)
											end
											if(phonemenuresult > 0) then
												if(phonemenuresult == 1) then
													if(money >= 1000) then
														money = money - 1000
														SaveStats()
														local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
														local cb,cx,cy,cz,ch = GetNextClosestCarNodeWithHeading(px, py, pz, _f, _f, _f, _f)
														DeleteCar(car)
														car = SpawnCar(truckinfo[tempcarid][2], cx, cy, cz, ch)
														SetVehicleTuning(car)
														TriggerEvent('chatMessage', '[Delivery]', {0, 255, 0}, 'Vehicle delivered to the marked point.')
													else
														TriggerEvent('chatMessage', '[Delivery]', {255, 0, 0}, 'You do not have enough money!')
													end
												end
											else
												goto trucks
											end
										else
											goto delivery
										end
									else
										TriggerEvent('chatMessage', '[Delivery]', {255, 0, 0}, 'You must be a supporter to use it!')
										goto delivery
									end
								end
							else
								goto main
							end
						elseif(tempitems[phonemenuresult] == "Remove wanted level ~g~(" .. wantedprice .. "$)") then
							if(money >= wantedprice) then
								money = money - wantedprice
								SaveStats()
								AlterWantedLevel(GetPlayerId(), 0)
								ApplyWantedLevelChangeNow(GetPlayerId())
							else
								TriggerEvent('chatMessage', '[Wanted level]', {255, 0, 0}, 'You do not have enough money!')
							end
						elseif(tempitems[phonemenuresult] == "Bounties") then
							::bounties::
							local tempitems = {}
							tempitems[#tempitems+1] = "Current bounties"
							tempitems[#tempitems+1] = "Set bounty on player"
							DrawPhoneItems("Bounties", tempitems)
							while phonemenuactive do
								Wait(0)
								SetPlayerControl(GetPlayerId(), true)
								SetCamBehindPed(GetPlayerChar(-1))
								SetGameCameraControlsActive(false)
							end
							if(phonemenuresult > 0) then
								if(tempitems[phonemenuresult] == "Current bounties") then
									::currbounties::
									local tempitems = {}
									for i=0,31,1 do
										if(IsNetworkPlayerActive(i)) then
											if(#bounty[i] > 0) then
												local totalcash = 0
												for j=1,#bounty[i],1 do
													totalcash = totalcash + bounty[i][j][2]
												end
												tempitems[#tempitems+1] = "" .. GetPlayerName(i) .. " - ~g~" .. totalcash .. "$"
											end
										end
									end
									DrawPhoneItems("Current_bounties", tempitems)
									while phonemenuactive do
										Wait(0)
										SetPlayerControl(GetPlayerId(), true)
										SetCamBehindPed(GetPlayerChar(-1))
										SetGameCameraControlsActive(false)
									end
									if(phonemenuresult > 0) then
										goto currbounties
									else
										goto bounties
									end
								elseif(tempitems[phonemenuresult] == "Set bounty on player") then
									if(bountycooldown == 0) then
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
										DrawPhoneItems("Select_player", tempitems)
										while phonemenuactive do
											Wait(0)
											SetPlayerControl(GetPlayerId(), true)
											SetCamBehindPed(GetPlayerChar(-1))
											SetGameCameraControlsActive(false)
										end
										if(phonemenuresult > 0) then
											local chatstring = ""
											cursor = 1
											::again2::
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
											DrawRectLeftTopCenter(0.4-0.1, 0.7, 0.2, 0.1, 0, 0, 0, 100)
											SetTextScale(0.300000,  0.6000000)
											SetTextEdge(1, 0, 0, 0, 255)
											SetTextCentre(1)
											SetTextWrap(0.0, 0.5-0.1)
											DisplayTextWithLiteralString(0.5-0.1, 0.73, "STRING", "Set")
											if(IsCursorInAreaLeftTopCenter(0.4-0.1, 0.7, 0.2, 0.1)) then
												DrawRectLeftTopCenter(0.4-0.1, 0.7, 0.2, 0.1, 255, 255, 255, 255)
												if(IsMouseButtonJustPressed(1)) then
													if(chatstring ~= "") then
														if(tonumber(chatstring)>=1000 and tonumber(chatstring)<=10000) then
															if(money >= tonumber(chatstring)) then
																TriggerServerEvent('setBounty', tempids[phonemenuresult], ConvertIntToPlayerindex(GetPlayerId()), tonumber(chatstring))
																bountycooldown = 300
															else
																TriggerEvent('chatMessage', '[Bounty]', {255, 0, 0}, 'You do not have this amount of money!')
															end
														else
															TriggerEvent('chatMessage', '[Bounty]', {255, 0, 0}, 'Bounty can only vary from 1000$ to 10000$!')
														end
														cursor = 0
														SetPlayerControl(GetPlayerId(), true)
														goto finish2
													else
														TriggerEvent('chatMessage', '[Bounty]', {255, 0, 0}, 'Enter the amount!')
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
													SetPlayerControl(GetPlayerId(), true)
													goto finish2
												end
											end
											goto again2
										else
											goto bounties
										end
										::finish2::
									else
										TriggerEvent('chatMessage', '[Bounty]', {255, 0, 0}, 'You will be able to set a new bounty in ' .. bountycooldown .. ' seconds!')
									end
								end
							else
								goto main
							end
						elseif(tempitems[phonemenuresult] == "MP3 player") then
							::radio::
							local tempitems = {}
							tempitems[#tempitems+1] = "Radio Off"
							tempitems[#tempitems+1] = "The Vibe"
							tempitems[#tempitems+1] = "Liberty Rock Radio"
							tempitems[#tempitems+1] = "Jazz Nation Radio"
							tempitems[#tempitems+1] = "Massive B"
							tempitems[#tempitems+1] = "K 109"
							tempitems[#tempitems+1] = "WKTT"
							tempitems[#tempitems+1] = "LCHC"
							tempitems[#tempitems+1] = "The Journey"
							tempitems[#tempitems+1] = "Fusion FM"
							tempitems[#tempitems+1] = "The Beat 102.7"
							tempitems[#tempitems+1] = "Radio Broker"
							tempitems[#tempitems+1] = "Vladivostok FM"
							tempitems[#tempitems+1] = "PLR"
							tempitems[#tempitems+1] = "San Juan Sounds"
							tempitems[#tempitems+1] = "Electro-choc"
							tempitems[#tempitems+1] = "The Classics"
							tempitems[#tempitems+1] = "IF 99"
							tempitems[#tempitems+1] = "Tuff Gong"
							tempitems[#tempitems+1] = "Independence FM"
							tempitems[#tempitems+1] = "Integrity 2.0"
							DrawPhoneItems("MP3_player", tempitems)
							while phonemenuactive do
								Wait(0)
								SetPlayerControl(GetPlayerId(), true)
								SetCamBehindPed(GetPlayerChar(-1))
								SetGameCameraControlsActive(false)
							end
							if(phonemenuresult > 0) then
								if(phonemenuresult == 1) then
									RetuneRadioToStationIndex(255)
									SetMobilePhoneRadioState(0)
									SetMobileRadioEnabledDuringGameplay(0)
								else
									SetMobilePhoneRadioState(1)
									SetMobileRadioEnabledDuringGameplay(1)
									RetuneRadioToStationIndex(phonemenuresult-2)
								end
								goto radio
							else
								goto main
							end
						elseif(tempitems[phonemenuresult] == "Settings") then
							::settings::
							local tempitems = {}
							tempitems[#tempitems+1] = "Background"
							tempitems[#tempitems+1] = "Ringtone"
							DrawPhoneItems("Settings", tempitems)
							while phonemenuactive do
								Wait(0)
								SetPlayerControl(GetPlayerId(), true)
								SetCamBehindPed(GetPlayerChar(-1))
								SetGameCameraControlsActive(false)
							end
							if(phonemenuresult > 0) then
								if(tempitems[phonemenuresult] == "Background") then
									if(backid < 8) then
										backid = backid + 1
									else
										backid = 1
									end
									TriggerServerEvent('saveBack', backid)
									goto settings
								elseif(tempitems[phonemenuresult] == "Ringtone") then
									::ringtone::
									local tempring = {
									{"Standard", 0},
									{"Ringing 1", 1},
									{"Ringing 2", 2},
									{"Countryside", 3},
									{"Fox", 4},
									{"High Seas", 5},
									{"Malfunction", 6},
									{"Pager", 7},
									{"Spy", 8},
									{"Teeker", 9},
									{"Text", 10},
									{"Cool Room", 11},
									{"Katja's Waltz", 12},
									{"Laidback", 13},
									{"Solo", 14},
									{"Swing It", 15},
									{"109", 16},
									{"Bassmatic", 17},
									{"Credit Check", 18},
									{"Drive", 19},
									{"Funk In Time", 20},
									{"Get Down", 21},
									{"Into Something", 22},
									{"Mine Until Monday", 23},
									{"Take The Pain", 24},
									{"The One For Me", 25},
									{"Tonight", 26},
									{"Beheading", 27},
									{"Champagne", 28},
									{"Diamonds", 29},
									{"Flat Line", 30},
									{"Hooker", 31},
									{"Jet", 32},
									{"Lesbians", 33},
									{"Money Counter", 34},
									{"Old Bitch", 35},
									{"St. Thomas", 37},
									{"Dragon Brain", 60},
									{"Science of Crime", 61}
									}
									local tempitems = {}
									for i=1,#tempring,1 do
										if(tempring[i][2] == ringid) then
											tempitems[i] = "~y~" .. tempring[i][1]
										else
											tempitems[i] = tempring[i][1]
										end
									end
									local prevring = 0
									DrawPhoneItems("Ringtone", tempitems)
									while phonemenuactive do
										Wait(0)
										SetPlayerControl(GetPlayerId(), true)
										SetCamBehindPed(GetPlayerChar(-1))
										SetGameCameraControlsActive(false)
										if(currbutton ~= prevring) then
											prevring = currbutton
											if(currbutton > 0) then
												PreviewRingtone(tempring[currbutton][2])
											else
												StopPreviewRingtone()
											end
										end
									end
									if(phonemenuresult > 0) then
										ringid = tempring[phonemenuresult][2]
										TriggerServerEvent('saveRing', ringid)
										goto ringtone
									else
										StopPreviewRingtone()
										goto settings
									end
								end
							else
								goto main
							end
						elseif(tempitems[phonemenuresult] == "Change background") then
							if(backid < 8) then
								backid = backid + 1
							else
								backid = 1
							end
							TriggerServerEvent('saveBack', backid)
							goto main
						end
					else
						phonemenu = 0
					end
				--end
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(not IsCarDead(gunvan)) then
			if(not IsCharDead(gunped)) then
				if(IsCharTouchingVehicle(GetPlayerChar(GetPlayerId()), gunvan)) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~open gun van menu", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						::again::
						local tempitems = {}
						tempitems[#tempitems+1] = "Finish deal"
						tempitems[#tempitems+1] = "Replenish armor ~g~(300$)"
						tempitems[#tempitems+1] = "Light armor vest ~g~(150$)"
						tempitems[#tempitems+1] = "Heavy armor vest ~g~(300$)"
						tempitems[#tempitems+1] = "Ammo box 100 bullets ~g~(500$)"
						for i=1,#guns,1 do
							if(i>=1 and i<=6) then
								tempitems[#tempitems+1] = "" .. guns[i][1] .. " ~g~(" .. guns[i][3] .. "$)"
							else
								tempitems[#tempitems+1] = "" .. guns[i][1]
							end
						end
						DrawWindow("Gun_shop", tempitems)
						while menuactive do
							Wait(0)
						end
						if(menuresult > 0) then
							if(tempitems[menuresult] == "Finish deal") then
								TaskCarMission(gunped, gunvan, gunvan, 1, 10.1, 0, 0, 10)
								MarkCarAsNoLongerNeeded(gunvan)
								goto finish3
							elseif(tempitems[menuresult] == "Replenish armor ~g~(300$)") then
								if(money >= 300) then
									money = money - 300
									SaveStats()
									AddArmourToChar(GetPlayerChar(GetPlayerId()), 100)
									TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, 'Armor replenished')
								else
									TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
								end
							elseif(tempitems[menuresult] == "Light armor vest ~g~(150$)") then
								if(inv[4] < 10) then
									if(money >= 150) then
										money = money - 150
										SaveStats()
										inv[4] = inv[4] + 1
										SaveInv()
										TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, 'Light armor vest purchased')
									else
										TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
									end
								else
									TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'Maximum amount reached!')
								end
							elseif(tempitems[menuresult] == "Heavy armor vest ~g~(300$)") then
								if(inv[5] < 10) then
									if(money >= 300) then
										money = money - 300
										SaveStats()
										inv[5] = inv[5] + 1
										SaveInv()
										TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, 'Heavy armor vest purchased')
									else
										TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
									end
								else
									TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'Maximum amount reached!')
								end
							elseif(tempitems[menuresult] == "Ammo box 100 bullets ~g~(500$)") then
								if(inv[6] < 10) then
									if(money >= 500) then
										money = money - 500
										SaveStats()
										inv[6] = inv[6] + 1
										SaveInv()
										TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, 'Ammo box purchased')
									else
										TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
									end
								else
									TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'Maximum amount reached!')
								end
							else
								for i=1,#guns,1 do
									if(i>=1 and i<=6) then
										if(tempitems[menuresult] == "" .. guns[i][1] .. " ~g~(" .. guns[i][3] .. "$)") then
											if(money >= guns[i][3]) then
												money = money - guns[i][3]
												SaveStats()
												GiveWeaponToChar(GetPlayerChar(GetPlayerId()), guns[i][2], guns[i][4], 1)
												TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, '' .. guns[i][1] .. ' purchased')
											else
												TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
											end
										end
									else
										if(tempitems[menuresult] == "" .. guns[i][1]) then
											::wep::
											local tempitems = {}
											tempitems[#tempitems+1] = "" .. guns[i][4] .. " bullets ~g~(" .. guns[i][3] .. "$)"
											tempitems[#tempitems+1] = "" .. guns[i][4]*2 .. " bullets ~g~(" .. guns[i][3]*2 .. "$)"
											tempitems[#tempitems+1] = "" .. guns[i][4]*5 .. " bullets ~g~(" .. guns[i][3]*5 .. "$)"
											tempitems[#tempitems+1] = "" .. guns[i][4]*10 .. " bullets ~g~(" .. guns[i][3]*10 .. "$)"
											DrawWindow("" .. guns[i][1], tempitems)
											while menuactive do
												Wait(0)
											end
											if(menuresult > 0) then
												if(tempitems[menuresult] == "" .. guns[i][4] .. " bullets ~g~(" .. guns[i][3] .. "$)") then
													if(money >= guns[i][3]) then
														money = money - guns[i][3]
														SaveStats()
														GiveWeaponToChar(GetPlayerChar(GetPlayerId()), guns[i][2], guns[i][4], 1)
														TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, '' .. guns[i][1] .. ' purchased')
													else
														TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
													end
												elseif(tempitems[menuresult] == "" .. guns[i][4]*2 .. " bullets ~g~(" .. guns[i][3]*2 .. "$)") then
													if(money >= guns[i][3]*2) then
														money = money - guns[i][3]*2
														SaveStats()
														GiveWeaponToChar(GetPlayerChar(GetPlayerId()), guns[i][2], guns[i][4]*2, 1)
														TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, '' .. guns[i][1] .. ' purchased')
													else
														TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
													end
												elseif(tempitems[menuresult] == "" .. guns[i][4]*5 .. " bullets ~g~(" .. guns[i][3]*5 .. "$)") then
													if(money >= guns[i][3]*5) then
														money = money - guns[i][3]*5
														SaveStats()
														GiveWeaponToChar(GetPlayerChar(GetPlayerId()), guns[i][2], guns[i][4]*5, 1)
														TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, '' .. guns[i][1] .. ' purchased')
													else
														TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
													end
												elseif(tempitems[menuresult] == "" .. guns[i][4]*10 .. " bullets ~g~(" .. guns[i][3]*10 .. "$)") then
													if(money >= guns[i][3]*10) then
														money = money - guns[i][3]*10
														SaveStats()
														GiveWeaponToChar(GetPlayerChar(GetPlayerId()), guns[i][2], guns[i][4]*10, 1)
														TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, '' .. guns[i][1] .. ' purchased')
													else
														TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
													end
												end
												goto wep
											end
										end
									end
								end
							end
							goto again
							::finish3::
						end
					end
				end
				local cx,cy,cz = GetCarCoordinates(gunvan)
				if(not IsPlayerNearCoords(cx, cy, cz, 500)) then
					TaskCarMission(gunped, gunvan, gunvan, 1, 10.1, 0, 0, 10)
					MarkCarAsNoLongerNeeded(gunvan)
				end
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(not IsCarDead(limo)) then
			if(not IsCharDead(limoped)) then
				if(not IsCharInCar(GetPlayerChar(GetPlayerId()), limo)) then
					if(IsCharTouchingVehicle(GetPlayerChar(GetPlayerId()), limo)) then
						PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~interact", 1000, 1)
						if(IsGameKeyboardKeyJustPressed(18)) then
							local tempitems = {}
							tempitems[#tempitems+1] = "Enter as passenger"
							tempitems[#tempitems+1] = "Finish service"
							DrawWindow("Personal_driver", tempitems)
							while menuactive do
								Wait(0)
							end
							if(menuresult > 0) then
								if(tempitems[menuresult] == "Enter as passenger") then
									WarpCharIntoCarAsPassenger(GetPlayerChar(GetPlayerId()), limo, 1)
								elseif(tempitems[menuresult] == "Finish service") then
									TaskCarMission(limoped, limo, limo, 1, 10.1, 0, 0, 10)
									MarkCarAsNoLongerNeeded(limo)
								end
							end
						end
					end
				else
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~set or change route", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						local blip = GetFirstBlipInfoId(8)
						if(DoesBlipExist(blip)) then
							local bp = GetBlipCoords(blip)
							--if(#waypoint > 0) then
							TaskCarMissionCoorsTarget(limoped, limo, bp.x, bp.y, bp.z, 4, 20.1, 4, 10, 10)
						else
							TriggerEvent('chatMessage', '[Personal driver]', {255, 0, 0}, "Specify a waypoint on the map!")
						end
					end
				end
				local cx,cy,cz = GetCarCoordinates(limo)
				if(not IsPlayerNearCoords(cx, cy, cz, 500)) then
					TaskCarMission(limoped, limo, limo, 1, 10.1, 0, 0, 10)
					MarkCarAsNoLongerNeeded(limo)
				end
			end
		end
	end
end)