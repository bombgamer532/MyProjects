local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end

local pedpath = {
{
{
{-954.68243, 183.47702, 4.21535, 184.609832763672},
{-953.04303, 173.18173, 4.21327, 194.192825317383},
{-956.2644, 165.57603, 4.21334, 138.511337280273},
{-960.52148, 154.28043, 4.22691, 163.874984741211},
{-960.45197, 149.34084, 4.22547, 188.736221313477},
{-955.79797, 146.76181, 4.21173, 252.278701782227},
{-953.29437, 156.33821, 4.21173, 346.018829345703},
{-952.30957, 170.48369, 4.21288, 354.665679931641}
},
{
{-994.96094, 184.85167, 4.241, 83.9502487182617},
{-1004.06982, 179.14629, 4.23751, 108.803062438965},
{-1018.26221, 176.72148, 4.24829, 97.9781188964844},
{-1031.09009, 180.94455, 4.25982, 78.6395874023438},
{-1050.13794, 180.65416, 4.2622, 86.5867767333984},
{-1061.46545, 186.40265, 4.27089, 64.6963882446289},
{-1071.27905, 179.42775, 4.25645, 121.551132202148},
{-1059.16467, 174.88405, 4.22031, 255.712921142578},
{-1041.71826, 176.43137, 4.23541, 287.516357421875},
{-1028.73572, 178.76306, 4.2577, 276.103149414063},
{-1014.54016, 187.14247, 4.24634, 309.264709472656}
},
{
{-1084.02686, 130.21001, 4.23792, 79.8733062744141},
{-1097.78491, 135.97659, 4.23793, 59.4190483093262},
{-1100.16992, 147.24307, 4.23792, 352.322479248047},
{-1093.92883, 156.5818, 4.23792, 304.347717285156},
{-1080.23413, 156.55827, 4.23785, 265.334503173828},
{-1061.41833, 153.90996, 4.23765, 261.744415283203},
{-1052.11987, 147.16945, 4.23765, 224.914978027344},
{-1054.91394, 130.93665, 4.23766, 166.437164306641}
},
{
{-1111.13196, 168.1021, 4.21371, 91.1226425170898},
{-1121.10803, 166.17931, 4.22236, 107.952575683594},
{-1123.42615, 150.52808, 4.2371, 171.871078491211},
{-1121.49292, 140.31187, 4.2371, 195.241821289063},
{-1106.87488, 142.26999, 4.23792, 272.731567382813},
{-1105.93994, 155.57372, 4.23792, 0.973125398159027},
{-1109.36914, 167.53561, 4.21409, 27.7240505218506}
},
{
{-993.83398, 143.90361, 4.19834, 88.3044662475586},
{-1014.29437, 144.29449, 4.25241, 88.9098892211914},
{-1026.42578, 133.95325, 4.1859, 165.080261230469},
{-1010.0694, 129.47012, 4.13092, 256.794250488281},
{-995.41217, 129.09084, 4.21218, 269.824920654297},
{-986.58551, 136.41861, 4.21174, 313.480712890625}
},
{
{-1209.10693, 33.08915, 4.21697, 107.678901672363},
{-1223.85999, 28.31507, 4.31187, 124.424644470215},
{-1226.94482, 16.34413, 4.21167, 174.543823242188},
{-1231.33472, 18.69427, 4.21167, 52.4979057312012},
{-1230.88977, 32.78125, 4.2115, 359.182006835938},
{-1218.57605, 38.87701, 4.22264, 286.196197509766},
{-1204.63562, 38.21968, 4.22532, 269.854583740234}
},
{
{-1157.73145, 26.85451, 4.21536, 179.995056152344},
{-1157.69287, 10.69182, 4.21201, 180.165267944336},
{-1121.27234, 10.89022, 4.21201, 275.720031738281},
{-1121.09143, 26.23659, 4.21389, 2.18403100967407}
},
{
{-1081.08569, 25.43939, 4.2131, 199.098190307617},
{-1080.51025, 9.95712, 4.21295, 182.718460083008},
{-1048.58643, 10.62751, 4.21219, 270.869049072266},
{-1048.90869, 24.86892, 4.21212, 354.796600341797}
},
{
{-1032.36609, 58.11225, 4.23235, 312.384338378906},
{-1023.99475, 60.25405, 4.23235, 280.475158691406},
{-1027.23621, 52.77495, 4.23235, 169.066558837891},
{-1027.69006, 41.90816, 4.22594, 178.845657348633},
{-1036.25012, 35.40406, 4.22056, 114.607109069824},
{-1029.01184, 29.62141, 4.21485, 255.236724853516},
{-1027.71558, 53.38012, 4.23235, 0.126550152897835},
{-1028.54431, 57.03412, 4.23235, 36.7979049682617}
},
{
{-1222.48474, -34.61548, 4.21116, 169.535095214844},
{-1223.91577, -50.91131, 4.21116, 176.800537109375},
{-1222.68994, -68.15574, 4.21116, 185.000640869141},
{-1228.72571, -75.88154, 4.21116, 132.21696472168},
{-1231.59814, -64.37785, 4.21116, 9.09876155853271},
{-1230.69763, -50.47701, 4.21115, 350.857299804688}
},
{
{-1180.47388, -95.82117, 4.42112, 93.9137420654297},
{-1188.81177, -98.18433, 4.25177, 102.201705932617},
{-1198.5426, -98.70306, 4.25177, 94.2594299316406},
{-1199.72131, -113.45386, 4.25177, 177.622451782227},
{-1205.65771, -117.43233, 4.25177, 106.404319763184},
{-1207.90784, -105.29915, 4.25177, 1.07626497745514},
{-1202.62305, -96.57552, 4.25207, 277.627593994141},
{-1185.67871, -95.61669, 4.42336, 271.7470703125}
},
{
{-1151.61877, -125.54169, 4.25183, 133.264144897461},
{-1152.03345, -132.51158, 4.25182, 188.147964477539},
{-1140.21155, -135.20894, 4.25182, 260.658386230469},
{-1122.64331, -133.46184, 4.25183, 280.104278564453},
{-1116.95435, -125.34921, 4.25182, 3.90730261802673},
{-1127.65564, -124.68608, 4.25183, 89.9166564941406}
},
{
{-1205.25354, 1.97566, 4.31153, 2.15977430343628},
{-1205.25049, 15.58854, 4.26124, 359.467895507813},
{-1215.88025, 16.54751, 4.31153, 88.6150283813477},
{-1216.88794, 1.03495, 4.31187, 183.207015991211}
},
{
{-1104.40259, -98.63326, 4.25183, 259.835510253906},
{-1096.31189, -103.19553, 4.25182, 238.344055175781},
{-1096.87878, -124.297, 4.25182, 185.57844543457},
{-1106.58691, -123.60892, 4.25183, 74.7088928222656},
{-1105.25659, -112.2001, 4.25183, 351.153961181641}
},
{
{-1212.80615, -88.36073, 4.23224, 9.0819673538208},
{-1213.59424, -81.78244, 4.21921, 32.605770111084},
{-1220.08887, -81.76349, 4.2204, 93.6494827270508},
{-1221.94153, -89.26914, 4.22543, 172.717712402344},
{-1219.26733, -101.81779, 4.25405, 208.396408081055},
{-1211.46863, -103.26536, 4.25319, 264.882141113281}
},
{
{-1236.26001, -65.0921, 4.21115, 8.06611442565918},
{-1237.12476, -50.62384, 4.21116, 1.69162619113922},
{-1234.39917, -41.29113, 4.2119, 346.296051025391},
{-1230.65906, -27.78043, 4.20976, 344.125762939453},
{-1228.7229, -32.95829, 4.21115, 191.037796020508},
{-1227.49048, -54.09303, 4.21116, 185.447128295898}
},
{
{-1213.28076, -7.03673, 4.31187, 110.719528198242},
{-1226.5946, -11.90304, 4.15138, 101.898475646973},
{-1233.37109, -18.68742, 4.20823, 143.705261230469},
{-1225.80676, -23.56904, 4.21116, 248.073684692383},
{-1217.68408, -17.82943, 4.21116, 311.349884033203}
},
{
{-1185.09814, 26.0662, 4.31173, 179.86833190918},
{-1185.78833, 14.78534, 4.31165, 175.629150390625},
{-1185.89233, 2.64728, 4.31165, 181.700454711914},
{-1184.3446, 10.45819, 4.31165, 347.844696044922},
{-1182.76917, 18.5659, 4.31165, 350.014709472656}
},
{
{-1118.32043, 63.12762, 4.23134, 161.503143310547},
{-1116.88367, 53.67498, 4.2322, 193.267959594727},
{-1114.77124, 45.53919, 4.22752, 189.220230102539},
{-1111.56152, 47.40209, 4.22919, 350.012969970703},
{-1112.68213, 56.21602, 4.23252, 5.04890584945679}
},
{
{-1051.37903, 63.24083, 4.23235, 89.2549896240234},
{-1098.50159, 63.01282, 4.23134, 87.7068099975586}
},
{
{-1169.07678, 134.86159, 4.19037, 79.7616653442383},
{-1184.81067, 136.58736, 4.23708, 81.8370361328125},
{-1202.86731, 129.91135, 4.21937, 124.459465026855},
{-1197.24353, 122.82125, 4.23555, 258.47607421875},
{-1176.08582, 123.11899, 4.23709, 270.449829101563},
{-1160.55688, 128.72456, 4.23724, 283.474700927734}
},
{
{-1096.74231, 190.77353, 4.23449, 81.7537841796875},
{-1106.23535, 191.44539, 4.25001, 85.5156478881836},
{-1112.90149, 186.9216, 4.21018, 168.908920288086},
{-1099.23254, 178.80688, 4.21936, 248.874206542969},
{-1081.48462, 177.79999, 4.25049, 274.686798095703},
{-1081.28809, 180.92026, 4.27704, 65.9906158447266},
{-1094.11792, 181.96062, 4.27286, 83.97998046875}
},
{
{-957.21246, 125.27776, 4.21173, 51.7278709411621},
{-960.71301, 133.33051, 4.21319, 8.67533397674561},
{-962.81372, 138.69221, 4.21585, 81.9573059082031},
{-984.41571, 139.81, 4.16576, 90.6297988891602},
{-983.35229, 126.69236, 4.21174, 189.954055786133}
},
{
{-970.13953, 188.33861, 4.22157, 86.0188674926758},
{-992.55322, 187.4637, 4.22708, 90.5562210083008},
{-999.74426, 182.16661, 4.24365, 133.443878173828},
{-993.0683, 176.5175, 4.22953, 250.354476928711},
{-981.54742, 178.87036, 4.2254, 278.693450927734},
{-970.25568, 179.44905, 4.22073, 269.268035888672}
},
{
{-1190.32666, 61.25414, 4.23166, 89.8632431030273},
{-1202.30713, 60.58877, 4.23167, 94.4575424194336},
{-1202.12671, 43.59441, 4.23163, 184.242065429688},
{-1208.10559, 42.72771, 4.23163, 10.9785280227661},
{-1210.60181, 56.97694, 4.23163, 5.63095998764038},
{-1203.89807, 64.29584, 4.23166, 301.409759521484},
{-1193.28198, 64.43388, 4.23167, 265.695251464844}
}
}
}
local pedtarget = {}
for i=1,25,1 do
	pedtarget[i] = 1
end
ProceedToRobbery7 = function()
	local tempitems = {}
	tempitems[#tempitems+1] = "Start heist"
	if(preps[7][1] == 0) then
		tempitems[#tempitems+1] = "Main target"
	else
		tempitems[#tempitems+1] = "Main target ~g~(Done)"
	end
	if(preps[7][2] == 0) then
		tempitems[#tempitems+1] = "Values location (optional)"
	else
		tempitems[#tempitems+1] = "Values location ~g~(Done)"
	end
	if(preps[7][3] == 0) then
		tempitems[#tempitems+1] = "Supply removal (optional)"
	else
		tempitems[#tempitems+1] = "Supply removal ~g~(Done)"
	end
	DrawWindow("Special_cargo", tempitems)
	while menuactive do
		Wait(0)
		if(currbutton == 1) then
			DrawDescription("Robbery", {
			-----------------------------------------------------------------------------------------------
			"Reach the docks and get the target item to proceed. The docks are being highly protected, so",
			"it is recommended to stay quite and try to avoid making alarm go off. Alarm will make whole",
			"security to attack you. After getting what we need, leave the docks by any possible way.",
			" ",
			"* Values location plans will provide you ability to steal more items and get higher reward.",
			"** Getting rid of supplies will remove security armor vests.",
			"~y~*** Entering the docks by helicopter will make alarm go off immediately.",
			"~y~**** Finishing the heist without raising the alarm will let you get doubled reward."
			})
		elseif(currbutton == 2) then
			DrawDescription("Main target", {
			-----------------------------------------------------------------------------------------------
			"We've spotted a helicopter which is about to head to the possible source of information.",
			"Follow this helicopter until you reach this place and get the information."
			})
		elseif(currbutton == 3) then
			DrawDescription("Values location", {
			-----------------------------------------------------------------------------------------------
			"Infiltrate a ship near the docks and steal values location plans to use them during heist to",
			"find more valuable items."
			})
		elseif(currbutton == 4) then
			DrawDescription("Supply removal", {
			-----------------------------------------------------------------------------------------------
			"Get rid of supply boats which are heading to the docks to prevent security from getting armor",
			"vests."
			})
		end
	end
	if(menuresult > 0) then
		if(tempitems[menuresult] == "Start heist") then
			if(preps[7][1] == 1) then
				variation = GenerateRandomIntInRange(1, #pedpath+1)
				for i=1,25,1 do
					peds[i] = SpawnPed(GetHashKey("M_M_GUNNUT_01"), pedpath[variation][i][1][1], pedpath[variation][i][1][2], pedpath[variation][i][1][3], pedpath[variation][i][1][4])
					GiveWeaponToChar(peds[i], 15, 1000, 1)
					if(preps[7][3] == 0) then
						AddArmourToChar(peds[i], 100)
					end
					pedtarget[i] = 1
				end
				coords = {
				{-1047.93896, 187.66472, 4.73864, 90.2794418334961},
				{-1015.8233, 47.61287, 5.19448, 89.900146484375},
				{-1217.0614, -58.26637, 4.73388, 180.125213623047},
				{-1185.11804, -2.28722, 4.31165, 7.2618293762207}
				}
				local rnd = GenerateRandomIntInRange(1, #coords+1)
				objs[1] = SpawnObject(GetHashKey("gb_bagdrug01"), coords[rnd][1], coords[rnd][2], coords[rnd][3]-1, coords[rnd][4])
				blips[26] = AddBlipForObject(objs[1])
				FreezeObjectPosition(objs[1], true)
				alarm = 0
				local coords = {
				{-962.51361, 156.90932, 5.10446, 88.4486618041992},
				{-1082.37561, 145.45761, 4.23792, 268.098205566406},
				{-1210.59106, 24.33547, 4.31154, 241.016052246094},
				{-1135.49695, 18.74223, 4.21201, 271.051330566406},
				{-1217.24561, -2.01805, 4.31153, 171.399993896484},
				{-1175.20349, -98.63615, 4.25183, 1.30718874931335},
				{-1142.41418, -120.67049, 5.25169, 0.657127022743225}
				}
				local itemcoords = {}
				itemcoords[1] = GenerateRandomIntInRange(1, #coords+1)
				itemcoords[2] = GenerateRandomIntInRange(1, #coords+1)
				while itemcoords[2]==itemcoords[1] do
					itemcoords[2] = GenerateRandomIntInRange(1, #coords+1)
				end
				itemcoords[3] = GenerateRandomIntInRange(1, #coords+1)
				while itemcoords[3]==itemcoords[1] or itemcoords[3]==itemcoords[2] do
					itemcoords[3] = GenerateRandomIntInRange(1, #coords+1)
				end
				for i=1,3,1 do
					blips[26+i] = AddBlipForCoord(coords[itemcoords[i]][1], coords[itemcoords[i]][2], coords[itemcoords[i]][3])
					ChangeBlipScale(blips[26+i], 0.5)
				end
				SetObjective("Find and steal ~y~the bag ~w~at ~y~the marked point")
				TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
				currmission = 4
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'You have to complete all necessary preparation missions first!')
			end
		elseif(menuresult == 2) then
			if(preps[7][1] == 0) then
				local rx,ry,rz,rh = GetRandomNodeInRadius(GenerateRandomIntInRange(100, 1000))
				vehs[1] = SpawnCar(GetHashKey("MAVERICK"), rx, ry, rz+100, rh)
				blips[1] = AddBlipForCar(vehs[1])
				peds[1] = SpawnPed(GetHashKey("M_M_PITALIAN_01"), rx, ry, rz+100, rh)
				WarpCharIntoCar(peds[1], vehs[1])
				SetHeliStabiliser(vehs[1])
				SetHeliBladesFullSpeed(vehs[1])
				FreezeCarPosition(vehs[1], true)
				SetObjective("Reach ~y~the helicopter")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 1
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'This mission is already completed.')
			end
		elseif(menuresult == 3) then
			if(preps[7][2] == 0) then
				coords = {
				{-1099.26819, 239.66109, 13.61056, 275.712219238281},
				{-1083.95886, 245.53497, 13.60949, 342.865356445313},
				{-1058.43677, 249.35274, 8.75798, 322.354705810547},
				{-1036.99084, 253.54803, 8.75781, 295.784240722656},
				{-1001.03265, 252.91669, 8.75836, 273.173400878906},
				{-974.3382, 252.95421, 8.75802, 359.854309082031},
				{-966.09998, 239.98268, 8.75797, 168.125534057617},
				{-975.64423, 230.96332, 8.75797, 131.599029541016},
				{-998.39252, 230.74316, 8.75836, 65.6333541870117},
				{-1033.44836, 231.91806, 8.75799, 145.270812988281},
				{-947.80267, 231.45476, 8.75859, 282.375366210938},
				{-928.71216, 239.76894, 8.7586, 325.391235351563},
				{-939.27881, 251.99153, 8.7586, 83.0667114257813},
				{-1024.82703, 240.79224, 8.75836, 24.3009414672852},
				{-1061.51794, 230.8952, 8.75799, 95.7795562744141}
				}
				for i=1,15,1 do
					peds[i] = SpawnPed(GetHashKey("M_Y_GTRI_LO_02"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
					GiveWeaponToChar(peds[i], 15, 1000, 1)
				end
				coords = {
				{-1093.45886, 242.00298, 13.60948, 272.308837890625},
				{-996.37903, 244.74966, 8.75837, 357.005706787109},
				{-930.89349, 235.98094, 8.75859, 210.724639892578}
				}
				local rnd = GenerateRandomIntInRange(1, #coords+1)
				objs[1] = SpawnObject(2736900820, coords[rnd][1], coords[rnd][2], coords[rnd][3]-1, coords[rnd][4])
				blips[1] = AddBlipForObject(objs[1])
				FreezeObjectPosition(objs[1], true)
				SetObjective("Reach ~y~the marked point ~w~and steal ~y~blueprints")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 2
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'This mission is already completed.')
			end
		elseif(menuresult == 4) then
			if(preps[7][3] == 0) then
				carmarker = {}
				local coords = {
				{
				{-741.42932, 1048.42126, -0.3693, 170.234024047852},
				{-732.80505, 1058.17834, -0.63981, 182.166900634766},
				{-744.83923, 1062.29468, -0.53612, 173.624084472656}
				},
				{
				{-743.00275, 770.65527, -0.52105, 163.13786315918},
				{-735.38336, 773.00763, -0.21931, 158.147735595703},
				{-742.19318, 782.89154, -0.27077, 159.228210449219}
				},
				{
				{-764.98773, -327.06653, -0.72876, 31.919059753418},
				{-765.3208, -334.7767, -0.20739, 29.6897487640381},
				{-755.78259, -330.46735, -0.68212, 31.2031021118164}
				},
				{
				{-498.64084, -660.52527, -0.39882, 37.0552139282227},
				{-496.66599, -668.39056, -0.74035, 42.1376495361328},
				{-489.90021, -663.70361, -0.23576, 37.7802047729492}
				}
				}
				local rnd = GenerateRandomIntInRange(1, #coords+1)
				for i=1,3,1 do
					vehs[i] = SpawnCar(GetHashKey("TROPIC"), coords[rnd][i][1], coords[rnd][i][2], coords[rnd][i][3], coords[rnd][i][4])
					peds[i] = SpawnPed(GetHashKey("M_M_PITALIAN_01"), coords[rnd][i][1], coords[rnd][i][2], coords[rnd][i][3], coords[rnd][i][4])
					WarpCharIntoCar(peds[i], vehs[i])
					TaskCarMission(peds[i], vehs[i], vehs[i], 1, 10.1, 0, 0, 10)
				end
				for i=1,3,1 do
					peds[3+i] = SpawnPed(GetHashKey("M_M_PITALIAN_01"), coords[rnd][i][1], coords[rnd][i][2], coords[rnd][i][3], coords[rnd][i][4])
					WarpCharIntoCarAsPassenger(peds[3+i], vehs[i], 0)
					GiveWeaponToChar(peds[3+i], 13, 1000, 1)
				end
				SetObjective("Destroy ~y~all supply boats")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 3
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'This mission is already completed.')
			end
		end
	end
end

local pedzone = {}
for i=1,25,1 do
	pedzone[i] = {}
end
CreateThread(function()
	while true do
		Wait(0)
		if(currmission == 4) then
			if(variation ~= nil) then
				if(alarm == 0) then
					for i=1,25,1 do
						if(not IsCharDead(peds[i])) then
							if(not (IsPedNearCoords(peds[i], pedpath[variation][i][pedtarget[i]][1], pedpath[variation][i][pedtarget[i]][2], pedpath[variation][i][pedtarget[i]][3], 1))) then
								TaskGoStraightToCoord(peds[i], pedpath[variation][i][pedtarget[i]][1], pedpath[variation][i][pedtarget[i]][2], pedpath[variation][i][pedtarget[i]][3], 2, -1)
							else
								if(pedpath[variation][i][pedtarget[i]+1] ~= nil) then
									pedtarget[i] = pedtarget[i] + 1
								else
									pedtarget[i] = 1
								end
							end
						else
							pedtarget[i] = 1
						end
						if(not IsCharDead(peds[i])) then
							if(not DoesBlipExist(blips[i])) then
								blips[i] = AddBlipForChar(peds[i], _i)
								ChangeBlipSprite(blips[i], 6)
								--ChangeBlipNameFromAscii(blips[i], "" .. GetPlayerName(i, _s))
								ChangeBlipColour(blips[i], 1)
								SetBlipAsShortRange(blips[i], true)
								ChangeBlipScale(blips[i], 0.5)
							else
								if(not IsPauseMenuActive()) then
									local rx,ry,rz = GetCamRot(GetGameCam(), _f, _f, _f)
									ChangeBlipRotation(blips[i], math.floor(GetCharHeading(peds[i], _f) + 90 - rz))
								else
									ChangeBlipRotation(blips[i], math.floor(GetCharHeading(peds[i], _f) + 90))
								end
							end
							local px,py,pz = GetCharCoordinates(peds[i])
							for j=1,10,1 do
								RemoveBlip(pedzone[i][j])
								pedzone[i][j] = AddBlipForCoord(px+50*math.cos((36*j)*math.pi/180), py+50*math.sin((36*j)*math.pi/180), pz)
								ChangeBlipScale(pedzone[i][j], 0.1)
								ChangeBlipColour(pedzone[i][j], 1)
								ChangeBlipNameFromAscii(pedzone[i][j], "Vision area")
								SetBlipAsShortRange(pedzone[i][j], true)
							end
						end
						if(not IsCharDead(peds[i])) then
							for j=0,31,1 do
								if(IsNetworkPlayerActive(j)) then
									--if(HasCharBeenDamagedByChar(peds[i], GetPlayerChar(i))) then
									--	for k=1,25,1 do
									--		AttackPlayer(peds[k])
									--	end
									--	alarm = 1
									--end
									if(IsPedNearPlayer(peds[i], GetPlayerChar(j), 50)) then
										if(HasCharSpottedCharInFront(peds[i], GetPlayerChar(j))) then
											for k=1,25,1 do
												AttackPlayer(peds[k])
											end
											alarm = 1
										end
									end
								end
							end
						else
							RemoveBlip(blips[i])
							for j=1,10,1 do
								RemoveBlip(pedzone[i][j])
							end
						end
						if(not IsCharDead(peds[i])) then
							local px,py,pz = GetCharCoordinates(peds[i])
							if(IsPlayerNearCoords(px, py, pz, 200)) then
								if(IsCharInAnyHeli(GetPlayerChar(-1))) then
									alarm = 1
								end
							end
						end
					end
				else
					for i=1,25,1 do
						if(not IsCharDead(peds[i])) then
							--if(not (IsPedNearPlayer(peds[i], GetPlayerChar(-1), 25))) then
							--	local pos = table.pack(GetCharCoordinates(GetPlayerChar(-1), _f, _f, _f))
							--	TaskGoStraightToCoord(peds[i], pos[1], pos[2], pos[3], 4, -1)
							--else
								if(not (IsPedInCombat(peds[i]))) then
									TaskCombat(peds[i], GetPlayerChar(-1))
								end
							--end
						end
						RemoveBlip(blips[i])
						for j=1,10,1 do
							RemoveBlip(pedzone[i][j])
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
		if(currmission > 0) then
			if(currmission == 1) then
				if(currstage == 0) then
					if(IsCarDead(vehs[1])) then
						DrawMessage("~r~Mission failed", "Helicopter destroyed.")
						EndMission()
					elseif(IsCharDead(peds[1])) then
						DrawMessage("~r~Mission failed", "Helicopter driver is dead.")
						EndMission()
					else
						local cx,cy,cz = GetCarCoordinates(vehs[1])
						if(IsPlayerNearCoords(cx, cy, cz, 100) or IsPlayerNearCoords(cx, cy, cz-100, 100)) then
							coords = {
							{1202.20911, -108.69057, 28.42811, 182.0302734375},
							{2294.43555, 510.39438, 6.08036, 90.315803527832},
							{1162.17419, 857.10364, 36.12377, 315.580444335938},
							{1360.96033, 1560.91821, 4.77103, 0.455628246068954},
							{324.49536, 1889.55603, 17.77722, 268.902404785156},
							{-272.83511, 1468.88098, 20.44196, 270.433044433594},
							{-320.47165, 557.21387, 14.65968, 181.118347167969},
							{-1321.16602, -255.01822, 2.92883, 89.4573593139648},
							{-1752.3905, 369.30792, 25.44915, 60.4460525512695},
							{-1026.01282, 1327.0238, 24.40552, 90.5962295532227}
							}
							variation = GenerateRandomIntInRange(1, #coords+1)
							FreezeCarPosition(vehs[1], false)
							TaskHeliMission(peds[1], vehs[1], 0, 0, coords[variation][1], coords[variation][2], coords[variation][3]+100, 4, 10.1, 5, -1, Round(100.1)+1, 40)
							SetObjective("Follow ~y~the helicopter")
							currstage = 1
						end
					end
				elseif(currstage == 1) then
					if(IsCarDead(vehs[1])) then
						DrawMessage("~r~Mission failed", "Helicopter destroyed.")
						EndMission()
					elseif(IsCharDead(peds[1])) then
						DrawMessage("~r~Mission failed", "Helicopter driver is dead.")
						EndMission()
					else
						if(IsPedNearCoords(peds[1], coords[variation][1], coords[variation][2], coords[variation][3]+100, 50) --[[or IsPlayerNearCoords(coords[variation][1], coords[variation][2], coords[variation][3], 50)]]) then
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(coords[variation][1], coords[variation][2], coords[variation][3], _i)
							SetRoute(blips[1], true)
							SetObjective("Get ~y~information")
							currstage = 2
						end
					end
				elseif(currstage == 2) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						RemoveBlip(blips[1])
						AlterWantedLevel(GetPlayerId(), StoreWantedLevel(GetPlayerId())+2)
						ApplyWantedLevelChangeNow(GetPlayerId())
						SetObjective("You have been spotted! Lose ~y~wanted level")
						currstage = 3
					end
				elseif(currstage == 3) then
					if(StoreWantedLevel(GetPlayerId()) == 0) then
						DrawMessage("~y~Preparation mission completed", "You have got the information about location of the main target.")
						preps[7][1] = 1
						SavePreps()
						EndMission()
					end
				end
			elseif(currmission == 2) then
				if(currstage == 0) then
					for i=1,15,1 do
						if(not IsCharDead(peds[i])) then
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,15,1 do
									AttackPlayer(peds[j])
								end
							end
						end
					end
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(IsPlayerNearCoords(ox, oy, oz, 2)) then
						RemoveBlip(blips[1])
						blips[1] = AddBlipForCoord(-1097.17334, 677.17975, 8.65565)
						SetRoute(blips[1], true)
						DeleteObject(objs[1])
						SetObjective("Deliver ~y~the blueprints ~w~to ~y~the base")
						currstage = 1
					end
				elseif(currstage == 1) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						DrawMessage("~y~Preparation mission completed", "You have got the information about location of valuable items.")
						preps[7][2] = 1
						SavePreps()
						EndMission()
					end
				end
			elseif(currmission == 3) then
				if(currstage == 0) then
					for i=1,3,1 do
						if(not IsCarDead(vehs[i])) then
							if(not DoesBlipExist(blips[i])) then
								blips[i] = AddBlipForCar(vehs[i], _i)
							end
						else
							RemoveBlip(blips[i])
						end
					end
					for i=1,6,1 do
						if(not IsCharDead(peds[i])) then
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,6,1 do
									AttackPlayer(peds[j])
								end
							end
						end
					end
					local boatsdead = 0
					for i=1,3,1 do
						if(IsCarDead(vehs[i])) then
							boatsdead = boatsdead + 1
						end
					end
					if(boatsdead == 3) then
						DrawMessage("~y~Preparation mission completed", "Supplies for security have been removed.")
						preps[7][3] = 1
						SavePreps()
						EndMission()
					end
				end
			elseif(currmission == 4) then
				if(currstage == 0) then
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(IsPlayerNearCoords(ox, oy, oz, 2)) then
						--if(IsPlayerNearCoords(coords[rnd][1], coords[rnd][2], coords[rnd][3], 2)) then
							DeleteObject(objs[1])
							local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
							objs[1] = SpawnObject(GetHashKey("cj_mk_drug_bag"), px, py, pz, 0.0)
							AttachObjectToPed(objs[1],GetPlayerChar(GetPlayerId()),0x4B2,0.3,0,0,0,-math.pi/2,math.pi,0)
							RemoveBlip(blips[26])
							if(preps[7][2] == 1) then
								SetObjective("Escape ~y~the docks ~w~or collect ~y~more items")
							else
								SetObjective("Escape ~y~the docks")
							end
							currstage = 1
						--end
					end
					if(alarm == 1) then
						local pedsdead = 0
						for i=1,5,1 do
							if(IsCharDead(peds[25+i])) then
								RemoveBlip(blips[29+i])
								pedsdead = pedsdead + 1
							else
								AttackPlayer(peds[25+i])
							end
						end
						if(pedsdead == 5) then
							for i=1,5,1 do
								DeleteChar(peds[25+i])
							end
							for i=1,5,1 do
								--local pos = table.pack(GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f))
								--local xy = GenerateRandomIntInRange(0, 360, _i)
								--local groundz = GetGroundZFor3dCoord(pos[1]+50*math.cos(xy*math.pi/180), pos[2]+50*math.sin(xy*math.pi/180), pos[3]+100, _f)
								--peds[25+i] = SpawnPed(GetHashKey("M_M_GUNNUT_01"), pos[1]+50*math.cos(xy*math.pi/180), pos[2]+50*math.sin(xy*math.pi/180), groundz+1, 0.0)
								local rx,ry,rz,rh = GetRandomNodeInRadius(50)
								peds[25+i] = SpawnPed(GetHashKey("M_M_GUNNUT_01"), rx, ry, rz, rh)
								GiveWeaponToChar(peds[25+i], 15, 1000, 1)
								if(preps[7][3] == 0) then
									AddArmourToChar(peds[25+i], 100)
								end
								RemoveBlip(blips[29+i])
								blips[29+i] = AddBlipForChar(peds[25+i], _i)
							end
						end
					end
					if(preps[7][2] == 1) then
						for i=1,3,1 do
							if(DoesBlipExist(blips[26+i])) then
								local bp = GetBlipCoords(blips[26+i])
								DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
								if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
									RemoveBlip(blips[26+i])
									PrintStringWithLiteralStringNow("STRING", "~y~Item collected", 3000, 1)
								end
							end
						end
					end
				elseif(currstage == 1) then
					if(alarm == 1) then
						local pedsdead = 0
						for i=1,5,1 do
							if(IsCharDead(peds[25+i])) then
								RemoveBlip(blips[29+i])
								pedsdead = pedsdead + 1
							else
								AttackPlayer(peds[25+i])
							end
						end
						if(pedsdead == 5) then
							for i=1,5,1 do
								DeleteChar(peds[25+i])
							end
							for i=1,5,1 do
								local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
								local angle = GenerateRandomFloatInRange(0, 360.1)
								local radius = 50
								local rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
								peds[25+i] = SpawnPed(GetHashKey("M_M_GUNNUT_01"), rx, ry, rz, rh)
								GiveWeaponToChar(peds[25+i], 15, 1000, 1)
								if(preps[7][3] == 0) then
									AddArmourToChar(peds[25+i], 100)
								end
								RemoveBlip(blips[29+i])
								blips[29+i] = AddBlipForChar(peds[25+i], _i)
							end
						end
					end
					if(preps[7][2] == 1) then
						for i=1,3,1 do
							if(DoesBlipExist(blips[26+i])) then
								local bp = GetBlipCoords(blips[26+i])
								DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
								if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
									RemoveBlip(blips[26+i])
									PrintStringWithLiteralStringNow("STRING", "~y~Item collected", 3000, 1)
								end
							end
						end
					end
					if(not IsPlayerNearCoords(-1118.97314, 17.40052, 4.21201, 300)) then
						for i=1,25,1 do
							RemoveBlip(blips[i])
							for j=1,10,1 do
								RemoveBlip(pedzone[i][j])
							end
						end
						local finalmoney = 100000
						for i=1,3,1 do
							if(not DoesBlipExist(blips[26+i])) then
								finalmoney = finalmoney + 25000
							end
						end
						if(alarm == 0) then
							finalmoney = finalmoney*2
						end
						local finalexp = 3000 + math.floor(finalmoney/100)
						local finalreward = SeparateReward(finalmoney, finalexp)
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						heistsCompleted = heistsCompleted + 1
						SaveDailyStats()
						for i=1,3,1 do
							preps[7][i] = 0
						end
						SavePreps()
						EndMission()
					end
				end
			end
			if(IsPlayerDead(GetPlayerId())) then
				for i=1,25,1 do
					RemoveBlip(blips[i])
					for j=1,10,1 do
						RemoveBlip(pedzone[i][j])
					end
				end
				DrawMessage("~r~Mission failed", "You have died.")
				EndMission()
			end
		end
	end
end)