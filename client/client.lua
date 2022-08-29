-- When (re)starting the resource, make sure we turn these state bags off just to be safe
LocalPlayer.state:set('idshown',false,false)
LocalPlayer.state:set('idvisible',false,false)

-- Register a keymapping for the "stop" command (to close the id)
RegisterKeyMapping('cancel', 'Cancel Action', 'keyboard', 'x')

-- Register an empty 'stop' command for future use
RegisterCommand('cancel', function()
	-- empty the command
end)


local ox_inventory = exports.ox_inventory
exports('identification', function(data, slot)
	if not LocalPlayer.state.idshown  then 
		ox_inventory:useItem(data, function(data)
			if data then
				TriggerEvent('qidentification:showID',data)
			end
		end)
	else
		ox_inventory:notify({text = 'License is in cooldown.'})
	end
end)

exports('Showidentification',function (data,slot)
    exports.ox_inventory:useItem(data, function(data)
        if data then
            local item = exports.ox_inventory:Items("identification")
			if item then
				TriggerEvent('qidentification:showID',item)
			end
        end
    end)
end)

exports('Showdrivers_license',function (data,slot)
    exports.ox_inventory:useItem(data, function(data)
        if data then
            local item = exports.ox_inventory:Items("drivers_license")
			if item then
				TriggerEvent('qidentification:showID',item)
			end
        end
    end)
end)

exports('Showfirearms_license',function (data,slot)
    exports.ox_inventory:useItem(data, function(data)
        if data then
            local item = exports.ox_inventory:Items("firearms_license")
			if item then
				TriggerEvent('qidentification:showID',item)
			end
        end
    end)

end)

-- Event to show your ID to nearby players
RegisterNetEvent('qidentification:showID')
AddEventHandler('qidentification:showID', function(item)
	if not LocalPlayer.state.idshown  then 
		local playersInArea = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), Config.DistanceShowID)
		-- loop through players in area and show them the id
		if #playersInArea > 0 then 
			local Playerinareaid = {} -- Probably a better way of doing this, feel free to fix this :) -PERPGamer
			for i = 1, #playersInArea do
				table.insert(Playerinareaid, GetPlayerServerId(playersInArea[i]))
			end
			TriggerServerEvent('qidentification:server:showID',item,Playerinareaid)
			TriggerEvent('qidentification:openID',item)
		end
		-- set a flag 
		LocalPlayer.state:set('idshown',true,false)
		-- open it for yourself too
		TriggerEvent('qidentification:openID',item)
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
	SendNUIMessage({
		action = "open",
		metadata = data.metadata
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

if Config.EnableLicenseBlip then
    Citizen.CreateThread(function()
		for k,v in pairs(Config.LicenseLocation) do
			for i = 1, #v.LicenseLocation, 1 do
				local blip = AddBlipForCoord(v.LicenseLocation[i])
				
				SetBlipSprite (blip, 483)
				SetBlipDisplay(blip, 4)
				SetBlipScale  (blip, 0.8)
				SetBlipColour (blip, 17)
				SetBlipAsShortRange(blip, true)
				
				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(Config.LicenseBlipName)
				EndTextCommandSetBlipName(blip)
			end
		end
	end)
end
