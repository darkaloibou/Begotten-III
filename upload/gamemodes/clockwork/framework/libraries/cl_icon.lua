--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

library.New("icon", Clockwork)

Clockwork.icon.stored = Clockwork.icon.stored or {}

-- A function to add a chat icon.
function Clockwork.icon:Add(uniqueID, path, callback, bIsPlayer)
	if (uniqueID) then
		if (path) then
			if (callback) then
				self.stored[uniqueID] = {
					path = path,
					callback = callback,
					isPlayer = bIsPlayer
				}
			else
				MsgC(Color(255, 100, 0, 255), "[Clockwork:Icon] Erreur : tentative d'ajout d'une icône sans fournir de rappel.\n")
			end
		else
			MsgC(Color(255, 100, 0, 255), "[Clockwork:Icon] Erreur : tentative d'ajout d'une icône sans fournir de chemin..\n")
		end
	else
		MsgC(Color(255, 100, 0, 255), "[Clockwork:Icon] Erreur : tentative d'ajout d'une icône sans fournir d'ID unique.\n")
	end
end

-- A function to remove a chat icon.
function Clockwork.icon:Remove(uniqueID)
	if (uniqueID) then
		self.stored[uniqueID] = nil
	else
		MsgC(Color(255, 100, 0, 255), "[Clockwork:Icon] Erreur : tentative de suppression d'une icône sans fournir d'ID unique.\n")
	end
end

-- A function to set a player's icon.
function Clockwork.icon:PlayerSet(steamID, uniqueID, path)
	Clockwork.icon:Add(uniqueID, path, function(player)
		if (steamID == player:SteamID()) then
			return true
		end
	end, true)
end

-- A function to set a group's icon.
function Clockwork.icon:GroupSet(group, uniqueID, path)
	Clockwork.icon:Add(uniqueID, path, function(player)
		if (player:IsUserGroup(group)) then
			return true
		end
	end)
end

-- A function to return the stored icons.
function Clockwork.icon:GetAll()
	return Clockwork.icon.stored
end

local adminIcons = {
	["icon16/shield.png"] = true,
	["icon16/star.png"] = true,
	["icon16/emoticon_smile.png"] = true,
}

function Clockwork.icon:IsAdminIcon(icon)
	return adminIcons[icon];
end;

Clockwork.icon:GroupSet("superadmin", "SuperAdminShield", "icon16/shield.png")
Clockwork.icon:GroupSet("admin", "AdminStar", "icon16/star.png")
Clockwork.icon:GroupSet("operator", "OperatorSmile", "icon16/emoticon_smile.png")