-- This file manages the main menu parts of the code. 
-- I separated it here becuase it relies on nh-context and nh-keyboard and you may wish to replace it with your own method, maybe using ESX Menu Default? 



-- The event called by the qtarget to open the menu
RegisterNetEvent('qidentification:requestLicense')
AddEventHandler('qidentification:requestLicense',function()

	local sendMenu = {
		{
			id = 1,
			header = "<h6>Court House</h6>",
			txt = "",
			params = { 
				event = "fakeevent",
				args = {}
			}
		}
	}

	-- loop through identification data defined in config.lua and add options for each entry
	for i=1,#Config.IdentificationData,1 do 
		data = Config.IdentificationData[i]
		print(ESX.DumpTable(data))
		table.insert(sendMenu,{
			id = #sendMenu + 1,
			header = "<span class='target-icon'><i class='fa-solid fa-id-card fa-fw'></i></span> Request "..data.label,
			txt = "$"..data.cost,
			params = { 
				event = "qidentification:applyForLicense",
				args = {
					item = data.item
				}
			}
		})
	end

	-- not necessary as you can hit "escape" to leave the nh-context menu, but I define a cancel button because it looks nice and makes sense from a user experience perspective
	table.insert(sendMenu,
	{
		id = 99,
		header = "<span class='target-icon'><i class='fa-solid fa-circle-xmark fa-fw'></i></span> Cancel",
		txt = "",
		params = {
			event = "qidentification:cancel",
		}
	})

	-- actually trigger the menu event 
	TriggerEvent('nh-context:sendMenu', sendMenu)
end)


-- the event that handles applying for license
RegisterNetEvent('qidentification:applyForLicense')
AddEventHandler('qidentification:applyForLicense',function(data)
	-- check if we've got the money in our inventory -- uses linden_inventory CountItems export
	local moneyCount = exports['linden_inventory']:CountItems(Config.MoneyItem)[Config.MoneyItem]
	local identificationData = nil

	-- Loop through identificationdata and match item and set a variable for future use
	for k,v in pairs(Config.IdentificationData) do 
		if v.item == data.item then 
			identificationData = v
			break
		end
	end
	
	-- check money vs cost
	if moneyCount < identificationData.cost then 
		ESX.ShowNotification("You can't afford this license.")
	else 
		mugshotURL = exports['mugshot']:getMugshotUrl(ESX.PlayerData.ped,function(url)
			local mugshotURL = url
			-- if you allow custom mugshots, we use nh-keyboard to request the url - only direct image urls will work and it will be resized to fit.
			if Config.CustomMugshots then 
				local customMugshot = exports['nh-keyboard']:KeyboardInput({	
					header = "Custom Mugshot URL (Leave blank for default)",rows = {
					{
						id=0,
						txt="Direct Image URL (imgur,etc)"
					},
				}})
			
				if customMugshot ~= nil and customMugshot[1].input ~= nil then 
					mugshotURL = customMugshot[1].input
				else 
					-- if no url is defined, it'll just use the mugshot resource to take an automatic one.
					
				end 
			end 
			TriggerServerEvent('qidentification:server:payForLicense',identificationData,mugshotURL)
		end)

	end 
end)