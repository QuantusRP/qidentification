-- Server event to call open identification card on valid players
RegisterServerEvent('qidentification:server:showID')
AddEventHandler('qidentification:server:showID', function(item, players)
	if #players > 0 and item.metadata.isIdentification then 
		for _,player in pairs(players) do 
			TriggerClientEvent('qidentification:openID',item)
		end 
	end 
end)

-- Creating the card using item metadata.
RegisterServerEvent('qidentification:createCard')
AddEventHandler('qidentification:createCard', function(source,url,type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local card_metadata = {}
	card_metadata.type = xPlayer.name
	card_metadata.citizenid = xPlayer[Config.CitizenID]
	card_metadata.firstName = xPlayer.firstName
	card_metadata.lastName = xPlayer.lastName
	card_metadata.dateofbirth = xPlayer.dateofbirth
	card_metadata.sex = xPlayer.sex
	card_metadata.height = xPlayer.height
	card_metadata.mugshoturl = url
	card_metadata.cardtype = type
	local curtime = os.time(os.date("!*t"))
	local diftime = curtime + 2629746
	card_metadata.issuedon = os.date('%m / %d / %Y',curtime)
	card_metadata.expireson = os.date('%m / %d / %Y', diftime)
	print("Hello frens")
	print(type)
	if type == "identification" then 
		print("Type is identification")
		local sex, identifier = xPlayer.sex
		if sex == 'm' then sex = 'male' elseif sex == 'f' then sex = 'female' end
		card_metadata.description = ('Sex: %s | DOB: %s'):format( sex, xPlayer.dateofbirth )
	elseif type == "drivers_license" then 
		MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @identifier', {['@identifier'] = xPlayer.identifier},
		function (licenses)
			for i=1, #licenses, 1 do
				if licenses[i].type == 'drive' or licenses[i].type == 'drive_bike' or licenses[i].type == 'drive_truck' then
					card_metadata.licenses = licenses
				end
			end
		end)
	elseif type == "firearms_license" then 
		MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @identifier', {['@identifier'] = xPlayer.identifier},
		function (licenses)
			for i=1, #licenses, 1 do
				if licenses[i].type == 'weapon' then
					card_metadata.licenses = licenses
				end
			end
		end)
	end
	xPlayer.addInventoryItem(type, 1, card_metadata)
end)

-- Server event to call open identification card on valid players
RegisterServerEvent('qidentification:server:payForLicense')
AddEventHandler('qidentification:server:payForLicense', function(identificationData,mugshotURL)
	print(ESX.DumpTable(identificationData))
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(identificationData.cost)
	TriggerEvent('qidentification:createCard',source,mugshotURL,identificationData.item)
end)