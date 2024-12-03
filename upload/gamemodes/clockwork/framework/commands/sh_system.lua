--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

--setskin
--setattribute

local COMMAND = Clockwork.command:New("CfgListVars");
	COMMAND.tip = "Lister les variables de configuration de Clockwork.";
	COMMAND.text = "[string Find]";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local searchData = arguments[1] or "";
			netstream.Start(player, "CfgListVars", searchData);
		Clockwork.player:Notify(player, "Les variables de configuration ont été imprimées sur la console.");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CfgSetVar");
	COMMAND.tip = "Définir une variable de configuration Clockwork.";
	COMMAND.text = "<string Key> [all Value] [string Map]";
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local key = arguments[1];
		local value = arguments[2] or "";
		local configObject = config.Get(key);
		
		if (configObject:IsValid()) then
			local keyPrefix = "";
			local useMap = arguments[3];
			
			if (useMap == "") then
				useMap = nil;
			end;
			
			if (useMap) then
				useMap = string.lower(Clockwork.kernel:Replace(useMap, ".bsp", ""));
				keyPrefix = useMap.."'s ";
				
				if (!file.Exists("maps/"..useMap..".bsp", "GAME")) then
					Clockwork.player:Notify(player, useMap.." n'est pas une carte valide!");
					return;
				end;
			end;
			
			if (!configObject("isStatic")) then
				value = configObject:Set(value, useMap);
				
				if (value != nil) then
					local printValue = tostring(value);
					
					if (configObject("isPrivate")) then
						if (configObject("needsRestart")) then
							Clockwork.player:NotifyAll(player:Name().." a mis "..keyPrefix..key.." à '"..string.rep("*", string.len(printValue)).."' for the next restart.");
						else
							Clockwork.player:NotifyAll(player:Name().." a mis "..keyPrefix..key.." à '"..string.rep("*", string.len(printValue)).."'.");
						end;
					elseif (configObject("needsRestart")) then
						Clockwork.player:NotifyAll(player:Name().." a mis "..keyPrefix..key.." à '"..printValue.."' pour le prochain redémarrage.");
					else
						Clockwork.player:NotifyAll(player:Name().." a mis "..keyPrefix..key.." à '"..printValue.."'.");
					end;
				else
					Clockwork.player:Notify(player, key.." n'a pas pu être défini!");
				end;
			else
				Clockwork.player:Notify(player, key.." est une clé de configuration statique !");
			end;
		else
			Clockwork.player:Notify(player, key.." n'est pas une clé de configuration valide !");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("Announce");
	COMMAND.tip = "Notifier tous les joueurs sur le serveur.";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local text = table.concat(arguments, " ");
		
		if (text) then
			if Schema.EasyText then
				for _, v in _player.Iterator() do
					if IsValid(v) and v:HasInitialized() then
						Schema:EasyText(v, "icon16/bell.png", "goldenrod", "[ANNOUNCEMENT] "..text);
						v:SendLua([[Clockwork.Client:EmitSound("ui/pickup_secret01.wav", 80, 80)]]);
					end
				end
			else
				Clockwork.player:Notify(PlayerCache or _player.GetAll(), text);
			end
		end;
	end;
COMMAND:Register();

--[[local COMMAND = Clockwork.command:New("ClearItems");
	COMMAND.tip = "Clear all items from the map.";
	COMMAND.access = "a";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local items = 0;
		
		for k, v in pairs (ents.FindByClass("cw_item")) do
			if (hook.Run("CanClearItem", v)) then
				v:Remove();
				items = items + 1;
			end;
		end;
		
		if (items > 0) then
			Clockwork.player:Notify(player, "You removed "..items.." items.");
		else
			Clockwork.player:Notify(player, "There were no items to remove.");
		end;
	end;
COMMAND:Register();]]--

local COMMAND = Clockwork.command:New("ClearNPCs");
	COMMAND.tip = "Effacer tous les autocollants.";
	COMMAND.access = "a";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local npcs = 0;
		
		for k, v in pairs (ents.GetAll()) do
			if (v:IsNPC() or v:IsNextBot()) then
				v:Remove();
				npcs = npcs + 1;
			end;
		end;
		
		if (npcs > 0) then
			Clockwork.player:Notify(player, "Vous avez supprimé "..npcs.." NPCs.");
		else
			Clockwork.player:Notify(player, "Il n'y avait aucun PNJ à supprimer.");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyStopSound");
	COMMAND.tip = "Arrêter tous les sons sur un lecteur spécifique.";
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.alias = {"CharStopSound", "StopSoundTarget", "StopSoundPlayer"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);

		if (!target) then
			Clockwork.player:Notify(player, arguments[1].." n'est pas un joueur valide!");
			
			return;
		end;
	
		target:SendLua([[RunConsoleCommand("stopsound")]]);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("StopSoundGlobal");
	COMMAND.tip = "Arrêter tous les sons pour tous les joueurs.";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for _, v in _player.Iterator() do
			v:SendLua([[RunConsoleCommand("stopsound")]]);
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("StopSoundRadius");
	COMMAND.tip = "Arrête tous les sons pour tous les joueurs dans un rayon spécifié. Le rayon par défaut est 512.";
	COMMAND.optionalArguments = 1;
	COMMAND.access = "s";
	COMMAND.text = "[int Radius]";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local players = {};
		
		for k, v in pairs (ents.FindInSphere(player:GetPos(), arguments[1] or 512)) do
			if (v:IsPlayer()) then
				players[#players + 1] = v;
			end;
		end;
		
		for k, v in pairs(players) do
			v:SendLua([[RunConsoleCommand("stopsound")]]);
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ClearDecals");
	COMMAND.tip = "Effacer tous les autocollants.";
	COMMAND.access = "a";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for _, v in _player.Iterator() do
			v:SendLua([[RunConsoleCommand("r_cleardecals")]]);
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyReset");
	COMMAND.tip = "Réinitialiser un lecteur.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "a";
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"Reset", "CharReset"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);

		if (!target) then
			target = player;
		end;
		
		local name = target:Name();
			if (target == player) then
				name = "yourself";
			end;
		local position = target:GetPos();
		local angles = target:GetAngles();
		local eyeAngles = target:EyeAngles();

		target:KillSilent();
		target:Spawn();
		target:SetPos(position);
		target:SetAngles(angles);
		target:SetEyeAngles(eyeAngles);
		
		Clockwork.player:Notify(player, "Vous avez réinitialisé "..name..".");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyExtinguish");
	COMMAND.tip = "Éteindre un joueur.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.alias = {"CharExtinguish", "Extinguish"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			local name = target:Name();
			local playerName = player:Name();
			
			if (target:IsOnFire()) then
				target:Extinguish();
				Clockwork.player:Notify(player, "Tu as éteint "..name);
			else
				Clockwork.player:Notify(player, name.." n'est pas en feu!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un joueur valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyIgnite");
	COMMAND.tip = "Allumer un joueur.";
	COMMAND.text = "<string Name> <int Seconds>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;
	COMMAND.alias = {"CharIgnite", "Ignite"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			local name = target:Name();
			local playerName = player:Name();
			
			if (!target:IsOnFire()) then
				local time = tonumber(arguments[2]);
				
				for _, v in _player.Iterator() do
					if (v != player and v != target and v:IsAdmin() or v:IsUserGroup("operator")) then
						Clockwork.player:Notify(player, playerName.." s'est enflammé "..name.." pour "..time.." secondes.")
					end;
				end;
			
				Clockwork.player:Notify(player, "Tu as allumé "..name.." pour "..time.." secondes.")
					if (target:IsAdmin()) then
						Clockwork.player:Notify(target, "Vous avez été enflammé par "..playerName.."!");
					end;
				target:Ignite(time, 0);
			else
				Clockwork.player:Notify(player, name.." est déjà en feu!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un joueur valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyWarn");
	COMMAND.tip = "Ajouter un joueur à une liste blanche.";
	COMMAND.text = "<string Name> <string Warning>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;
	COMMAND.alias = {"CharWarn", "Warn"}

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			local playerName = player:Name();
			local name = target:Name();
			local message = table.concat(arguments, " ", 2);
			
			for _, v in _player.Iterator() do
				if (v != player and v != target and v:IsAdmin() or v:IsUserGroup("operator")) then
					Clockwork.player:Notify(v, playerName.." a prévenu "..name.." avec le message suivant: \""..message.."\"")
				end;
			end;
			
			Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, playerName.." a prévenu "..name.." avec le message suivant: \""..message.."\"");
			Clockwork.player:Notify(target, "Vous avez été prévenu par "..playerName..": \""..message.."\"");
			Clockwork.player:Notify(player, "Vous avez prévenu "..name..": \""..message.."\"");
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un joueur valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ListColors");
	COMMAND.tip = "Imprime toutes les couleurs disponibles sur votre console. Le premier argument permet une recherche dans la table.";
	COMMAND.text = "<string Search>";
	COMMAND.access = "a";
	COMMAND.optionalArguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local search = arguments[1];
		local colorTable = colors;
		local printTable = {};

		for k, v in pairs (colorTable) do
			if (search != nil and isstring(search)) then
				if (string.match(k, search)) then
					printTable[k] = v;
				else
					continue;
				end;
			else
				printTable[k] = v;
			end;
		end;
		
		if (printTable and !table.IsEmpty(printTable)) then
			netstream.Start(player, "PrintWithColor", "----- START COLOR LIST -----", Color(100, 255, 100));
				netstream.Heavy(player, "PrintTableWithColor", pon.encode(printTable));
			netstream.Start(player, "PrintWithColor", "----- END COLOR LIST -----", Color(100, 255, 100));
		elseif (isstring(search)) then
			Clockwork.player:Notify(player, "Aucune couleur trouvée avec l'argument de recherche '"..search.."'!")
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PluginLoad");
	COMMAND.tip = "Tenter de charger un plugin.";
	COMMAND.text = "<string Name>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "s";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local plugin = plugin.FindByID(arguments[1]);
		
		if (!plugin) then
			Clockwork.player:Notify(player, "Ce plugin n'est pas valide!");
			return;
		end;
		
		local unloadTable = Clockwork.command:FindByID("PluginLoad");
		local loadTable = Clockwork.command:FindByID("PluginLoad");
		
		if (!plugin.IsDisabled(plugin.name)) then
			local bSuccess = plugin.SetUnloaded(plugin.name, false);
			local recipients = {};
			
			if (bSuccess) then
				Clockwork.player:NotifyAll(player:Name().." a chargé le "..plugin.name.." plugin pour le prochain redémarrage.");
				
				for _, v in _player.Iterator() do
					if (v:HasInitialized()) then
						if (Clockwork.player:HasFlags(v, loadTable.access)
						or Clockwork.player:HasFlags(v, unloadTable.access)) then
							recipients[#recipients + 1] = v;
						end;
					end;
				end;
				
				if (#recipients > 0) then
					netstream.Start(recipients, "SystemPluginSet", {plugin.name, false});
				end;
			else
				Clockwork.player:Notify(player, "Ce plugin n'a pas pu être chargé!");
			end;
		else
			Clockwork.player:Notify(player, "Ce plugin dépend d'un autre plugin!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PluginUnload");
	COMMAND.tip = "Tenter de décharger un plugin.";
	COMMAND.text = "<string Name>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "s";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local plugin = plugin.FindByID(arguments[1]);
		
		if (!plugin) then
			Clockwork.player:Notify(player, "Ce plugin n'est pas valide!");
			return;
		end;
		
		local unloadTable = Clockwork.command:FindByID("PluginLoad");
		local loadTable = Clockwork.command:FindByID("PluginLoad");
		
		if (!plugin.IsDisabled(plugin.name)) then
			local bSuccess = plugin.SetUnloaded(plugin.name, true);
			local recipients = {};
			
			if (bSuccess) then
				Clockwork.player:NotifyAll(player:Name().." a déchargé le "..plugin.name.." plugin pour le prochain redémarrage.");
				
				for _, v in _player.Iterator() do
					if (v:HasInitialized()) then
						if (Clockwork.player:HasFlags(v, loadTable.access)
						or Clockwork.player:HasFlags(v, unloadTable.access)) then
							recipients[#recipients + 1] = v;
						end;
					end;
				end;
				
				if (#recipients > 0) then
					netstream.Start(recipients, "SystemPluginSet", {plugin.name, true});
				end;
			else
				Clockwork.player:Notify(player, "Ce plugin n'a pas pu être déchargé!");
			end;
		else
			Clockwork.player:Notify(player, "Ce plugin dépend d'un autre plugin!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ShutDown");
	COMMAND.tip = "Arrêtez le serveur en toute sécurité (c'est la seule façon d'appeler les fonctions de sauvegarde des données, utilisez donc cette option à la place du panneau de configuration). Laissez l'argument optionnel vide si vous souhaitez que l'arrêt soit immédiat.";
	COMMAND.text = "[seconds Delay]";
	COMMAND.access = "s";
	COMMAND.optionalArguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local delay = arguments[1];
	
		if delay and tonumber(delay) and tonumber(delay) > 0 then
			local message = "Le serveur va s'arrêter dans "..tostring(delay).." secondes!";
		
			for _, v in _player.Iterator() do
				Clockwork.player:Notify(v, message);
			end
			
			timer.Simple(delay, function()
				RunConsoleCommand("disconnect");
			end);
		else
			RunConsoleCommand("disconnect");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("SaveData");
	COMMAND.tip = "Enregistrer l’état du serveur manuellement.";
	COMMAND.access = "s";
	
	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		Clockwork.kernel:ProcessSaveData(false, true);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ToggleCharSwapping");
	COMMAND.tip = "Activer ou non l'échange de caractères. S'applique uniquement aux personnages vivants et aux non-administrateurs.";
	COMMAND.access = "s";
	COMMAND.alias = {"CharSwappingToggle", "DisableCharSwapping", "EnableCharSwapping"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if Clockwork.charSwappingDisabled then
			Clockwork.charSwappingDisabled = false;
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." a activé l'échange de caractères pour les non-administrateurs.");
			
			if Schema.fuckerJoeActive then
				Schema.fuckerJoeActive = false;
			end
		else
			Clockwork.charSwappingDisabled = true;
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." a désactivé l'échange de caractères pour les non-administrateurs.");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ToggleFactionRatio");
	COMMAND.tip = "Activer ou non le système de ratio de faction.";
	COMMAND.access = "s";
	COMMAND.alias = {"ToggleRatio", "FactionRatio", "RatioToggle"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if Clockwork.config:Get("faction_ratio_enabled"):Get() then
			Clockwork.config:Get("faction_ratio_enabled"):Set(false);
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." a désactivé le système de ratio de faction.");
		else
			Clockwork.config:Get("faction_ratio_enabled"):Set(true);
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." a activé le système de ratio de faction.");
		end
	end;
COMMAND:Register();