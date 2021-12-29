Config = {}
-- Distance at which you want to check for a player to show the ID card to
Config.DistanceShowID = 2.5
-- xPlayer variable that stores your player's "identification number" - for us it's identifier, you might store it as 'citizenid' or even 'slot'.
Config.CitizenID = 'identifier' -- if you use 'identifier' you can check this link https://forum.cfx.re/t/qidentification-a-free-id-card-resource/4024670/20?u=katoteki
-- time in SECONDS to enforce a cooldown between attempts to show your ID card to people around you
Config.ShowIDCooldown = 30 
-- The item you use for your physical currency
Config.MoneyItem = 'money' -- or 'cash' or whatever you use
Config.CustomMugshots = true -- for custom url, you can put your link for img

Config.MugshotScriptName = "MugShotBase64"


Config.IdentificationData = {
	{
		label = "ID Card",
		item = 'identification',
		cost = 500,
	},
	{
		label = "Drivers License",
		item = 'drivers_license',
		cost = 1500,
	},
	{
		label = "Firearms License",
		item = 'firearms_license',
		cost = 2500,
	},
}
--- NPC STUFF
Config.Invincible = true
Config.Frozen = true
Config.Stoic = true
Config.FadeIn = true
Config.DistanceSpawn = 20.0
Config.MinusOne = true

Config.GenderNumbers = {
	['male'] = 4,
	['female'] = 5
}

Config.NPCList = {
	{
		model = `cs_movpremmale`,
		coords = vector4(-549.6633, -189.9325, 38.2231, 193.0565), 
		gender = 'male',
		role = 'license',
	}
}
