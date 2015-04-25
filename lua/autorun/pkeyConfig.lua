--[[

PKey:
This addon works pretty much in the same way as Teamspeak permission keys.

People of specified ranks can generate a key and any user can redeem the
keys, there's a cooldown to prevent people trying to brute force keys.

Created by Adzter: http://steamcommunity.com/id/imadzter
--]]

pKey = {}

--List of people that can generate keys
pKey.permissions = {
	"superadmin"
}

--List of ranks you can generate keys for
pKey.canGenerate = {
	"admin",
	"operator"
}

--Use DarkRP notify or not?
pKey.darkRP = true

--Cooldown between redeeming keys
pKey.cooldownTime = 3

--Cooldown message
pKey.cooldownMessage = "You cannot redeem keys that fast"

--Key not found error message
pKey.notFound = "Sorry, key not found"

--Message for when the user receives their rank
pKey.added = "You were added to the rank: "