-- When (re)starting the resource, make sure we turn these state bags off just to be safe
LocalPlayer.state:set('idshown',false,false)
LocalPlayer.state:set('idvisible',false,false)

-- Register a keymapping for the "stop" command (to close the id)
RegisterKeyMapping('cancel', 'Cancel Action', 'keyboard', 'x')

-- Register an empty 'stop' command for future use
RegisterCommand('cancel', function()
	-- empty the command
end)

RegisterNetEvent('qidentification:identification')
AddEventHandler('qidentification:identification', function()
	local item = exports.ox_inventory:Items("identification")
	if item then
		TriggerEvent('qidentification:showID',item)
	end
end)
RegisterNetEvent('qidentification:drivers_license')
AddEventHandler('qidentification:drivers_license', function()
	local item = exports.ox_inventory:Items("drivers_license")
	if item then
		TriggerEvent('qidentification:showID',item)
	end
end)
RegisterNetEvent('qidentification:firearms_license')
AddEventHandler('qidentification:firearms_license', function()
	local item = exports.ox_inventory:Items("firearms_license")
	if item then
		TriggerEvent('qidentification:showID',item)
	end
end)


-- Event to show your ID to nearby players
RegisterNetEvent('qidentification:showID')
AddEventHandler('qidentification:showID', function(item)
	if not LocalPlayer.state.idshown  then 
		local playersInArea = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), Config.DistanceShowID)
		-- loop through players in area and show them the id
		if #playersInArea > 0 then 
			TriggerServerEvent('qidentification:server:showID',item.name,playersInArea)
			TriggerEvent('qidentification:openID',item.name)
		end
		-- set a flag 
		LocalPlayer.state:set('idshown',true,false)
		-- open it for yourself too
		TriggerEvent('qidentification:openID',item.name)
		Citizen.CreateThread(function()
			-- Fire and forget cooldown
			Citizen.Wait(Config.ShowIDCooldown * 1000)
			LocalPlayer.state:set('idshown',false,false) -- Doesn't need to be replicated to the server
		end)
	end 
end)

-- Event to show your ID to nearby players
RegisterNetEvent('qidentification:openID')
AddEventHandler('qidentification:openID', function(item)
	print("opening ID")
	print(LocalPlayer.state.idvisible)
	if LocalPlayer.state.idvisible == nil or not LocalPlayer.state.idvisible then 
		TriggerEvent('qidentification:showUI',item)
	end 
end)

-- NUI Events 
-- We define a "stop" command inside this too
RegisterNetEvent('qidentification:showUI')
AddEventHandler('qidentification:showUI', function(data)
	LocalPlayer.state:set('idvisible',true,false)
	local id = exports.ox_inventory:Search(1, data)
	for _, v in pairs(id) do
		SendNUIMessage({
			action = "open",
			metadata = v.metadata
		})

		RegisterCommand('cancel', function()
			SendNUIMessage({
				action = "close"
			})
			LocalPlayer.state:set('idvisible',false,false)
			-- Once the NUI is closed, we redefine the command to do nothing again, so it can be used by other resources
			RegisterCommand('cancel', function()
				-- empty the command
			end)
		end)
	end

end)

-- Backup command to force close any id shown on your screen (in case something breaks)
RegisterCommand('closeidentification',function()
	SendNUIMessage({
		action = "close"
	})
	LocalPlayer.state:set('idvisible',false,false)
end)

-- DEBUG COMMANDS, uncomment this block if you need to test issuing the card without using the events
--[[

RegisterCommand('issueidcard', function()
	exports['mugshot']:getMugshotUrl(ESX.PlayerData.ped, function(url)
		TriggerServerEvent('qidentification:createCard',source,url,"identification")
	end)
end, false)

RegisterCommand('issuedriverslicense', function()
	exports['mugshot']:getMugshotUrl(ESX.PlayerData.ped, function(url)
		TriggerServerEvent('qidentification:createCard',source,url,"drivers_license")
	end)
end, false)

RegisterCommand('issuefirearmslicense', function()
	exports['mugshot']:getMugshotUrl(ESX.PlayerData.ped, function(url)
		TriggerServerEvent('qidentification:createCard',source,url,"firearms_license")
	end)
end, false)
]]--
