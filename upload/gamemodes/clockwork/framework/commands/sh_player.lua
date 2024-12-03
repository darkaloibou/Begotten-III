--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local COMMAND = Clockwork.command:New("PlaySoundGlobal");
	COMMAND.tip = "Jouer un son sur tous les clients du joueur. Tous les arguments après le premier peuvent être des noms de joueurs, sur lesquels le son NE SERA PAS joué.";
	COMMAND.text = "<string SoundName> [int Level] [int Pitch] [varargs RecipientFilter]";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if (arguments[1]) then
			local info = {name = arguments[1], pitch = 100, level = 75};
			local translate = {[2] = "level", [3] = "pitch"};
			local startingIndex = 4;
			local filter, names = {}, {};
			
			for i = 2, 3 do
				if (tonumber(arguments[i]) == nil) then
					if (string.len(tostring(arguments[i])) > 0) then
						startingIndex = startingIndex - 1;
					end;
				else
					info[translate[i]] = tonumber(arguments[i]);
				end;
			end;
			
			for i = startingIndex, #arguments do
				if (arguments[i] and isstring(arguments[i])) then
					local target = Clockwork.player:FindByID(arguments[i]);
					
					if (istable(target)) then
						target = target[1];
					end;
					
					if (target and target:IsPlayer()) then
						filter[target] = true;
						names[#names + 1] = target:Name();
					end;
				end;
			end;
			
			local playerTable = _player.GetAll();
			
			if (!table.IsEmpty(filter)) then
				for k, v in pairs (playerTable) do
					if (filter[v]) then
						playerTable[k] = nil;
					end;
				end;
			end;
			
			local addon = ".";
			
			if (!table.IsEmpty(names)) then
				addon = " - Recipient Filter: "..table.concat(names, ", ")..".";
			end;
			
			netstream.Start(playerTable, "EmitSound", info);
			Clockwork.player:Notify(player, "Jouer du son à l'échelle mondiale: "..arguments[1]..addon);
		else
			Clockwork.player:Notify(player, "Vous devez spécifier un son valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlaySound");
	COMMAND.tip = "Jouer un son pour un joueur. Si un cinquième argument est spécifié, le son ne sera pas joué pour vous.";
	COMMAND.text = "<string Name> <string SoundName> [int Level 0-511] [int Pitch 30-255] [bool NoEavesdrop]";
	COMMAND.access = "o";
	COMMAND.arguments = 2;
	COMMAND.optionalArguments = 3;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			if (arguments[2]) then
				local info = {
					name = arguments[2],
					level = 75,
					pitch = 100,
				};
				
				if (arguments[3]) then info.level = tonumber(arguments[3]); end;
				if (arguments[4]) then info.pitch = tonumber(arguments[4]); end;
				
				netstream.Start(target, "EmitSound", info);
				
				if (target != player and !arguments[4]) then
					netstream.Start(player, "EmitSound", info);
				end;
			else
				Clockwork.player:Notify(player, "Vous devez spécifier un son valide!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un caractère valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("EmitSound");
	COMMAND.tip = "Émettre un son. La spécification d'un quatrième argument associe le son à vous. La spécification d'un cinquième argument recherchera un lecteur auquel associer le son. Si aucun quatrième ou cinquième argument n'est spécifié, le son sera émis depuis votre curseur. Si votre curseur touche une entité, l'entité émettra le son.";
	COMMAND.text = "<string SoundName> [int Level 0-511] [int Pitch 30-255] [bool Attach] [string PlayerName]";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 4;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if (arguments[1]) then
			local trace = player:GetEyeTraceNoCursor();
			local entity = trace.Entity;
			local hitPos = trace.HitPos;
			local info = {
				name = arguments[1],
				level = 75,
				pitch = 100,
				entity = hitPos,
			};
			
			if (IsValid(entity) and !entity:IsWorld()) then
				info.entity = entity;
			end;
			
			if (arguments[2]) then info.level = tonumber(arguments[2]); end;
			if (arguments[3]) then info.pitch = tonumber(arguments[3]); end;
			
			if (arguments[4] and tobool(arguments[4]) == true) then
				local target = player;
				
				if (arguments[5]) then
					local plyTarget = Clockwork.player:FindByID(arguments[5]);
					
					if (plyTarget) then
						if (istable(plyTarget)) then
							plyTarget = plyTarget[1];
						end;
						
						target = plyTarget;
					end;
				end;
				
				info.entity = target;
			end;
			
			netstream.Start(nil, "EmitSound", info);
		else
			Clockwork.player:Notify(player, "Vous devez spécifier un son valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyBan");
	COMMAND.tip = "Bannir un joueur du serveur.";
	COMMAND.text = "<string Name|SteamID|IPAddress> <number Minutes> [string Reason]";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "o";
	COMMAND.arguments = 2;
	COMMAND.optionalArguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local schemaFolder = Clockwork.kernel:GetSchemaFolder();
		local duration = tonumber(arguments[2]);
		local reason = table.concat(arguments, " ", 3);
		
		if (!reason or reason == "") then
			reason = nil;
		end;
		
		if (!Clockwork.player:IsProtected(arguments[1])) then
			if (duration) then
				duration = math.max(duration, 0);
				
				Clockwork.bans:Add(arguments[1], duration * 60, reason, function(steamName, duration, reason)
					if (IsValid(player)) then
						if (steamName) then
							if (duration > 0) then
								local hours = math.Round(duration / 3600);
								
								if (hours >= 1) then
									Clockwork.player:NotifyAll(player:Name().." a interdit '"..steamName.."' pour "..hours.." heures(s) ("..reason..").");
								else
									Clockwork.player:NotifyAll(player:Name().." a interdit '"..steamName.."' pour "..math.Round(duration / 60).." minute(s) ("..reason..").");
								end;
							else
								Clockwork.player:NotifyAll(player:Name().." a interdit '"..steamName.."' de mannière permanante pour ("..reason..").");
							end;
						else
							Clockwork.player:Notify(player, "Ce n'est pas un identifiant valide!");
						end;
					end;
				end);
			else
				Clockwork.player:Notify(player, "Ce n'est pas une durée valide!");
			end;
		else
			local target = Clockwork.player:FindByID(arguments[1]);
			
			if (target) then
				Clockwork.player:Notify(player, target:Name().." est protégé!");
			else
				Clockwork.player:Notify(player, "Ce joueur est protégé!");
			end;
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyGiveFlags");
	COMMAND.tip = "Donnez des drapeaux à un joueur. Ces drapeaux persisteront sur tous les personnages.";
	COMMAND.text = "<string Name> <string Flag(s)>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (istable(target)) then
			Clockwork.player:Notify(player, "Trop de joueurs avec l'identifiant '"..arguments[1].."' ont été trouvés. Entrez à nouveau la commande avec le nom d'un joueur spécifique !");
			return;
		end;
		
		if (target) then
			if (string.find(arguments[2], "a") or string.find(arguments[2], "s") or string.find(arguments[2], "o")) then
				if (!Clockwork.player:IsProtected(player)) then
					Clockwork.player:Notify(player, "Vous ne pouvez pas donner de drapeaux 'o', 'a' ou 's '!");
					return;
				end
			end;
			
			Clockwork.player:GivePlayerFlags(target, arguments[2]);
			Clockwork.player:NotifyAll(player:Name().." a donné "..target:Name().." '"..arguments[2].."' drapeaux des joueurs.");
			target:SaveCharacter();
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un caractère valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyMute");
	COMMAND.tip = "Couper le son d'un joueur.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.alias = {"CharMute", "Mute", "Gag", "PlyGag", "CharGag"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local name = target:Name();
			
			target:SetMuted(true);
			
			Clockwork.player:NotifyAdmins("operator", player:Name().." has muted "..name..".");
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un caractère valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyUnmute");
	COMMAND.tip = "Rétablir le son d'un joueur.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.alias = {"CharUnmute", "Unmute", "Ungag", "PlyUngag", "CharUngag"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local name = target:Name();
			
			target:SetMuted(false);
			
			Clockwork.player:NotifyAdmins("operator", player:Name().." has unmuted "..name..".");
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un caractère valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyMuteAll");
	COMMAND.tip = "Couper le son d'un joueur.";
	COMMAND.access = "s";
	COMMAND.alias = {"CharMuteAll", "MuteAll", "GagAll", "PlyGagAll", "CharGagAll"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for _, v in _player.Iterator() do
			if (!Clockwork.player:IsAdmin(v)) then
				v:SetMuted(true);
			end;
		end;
		
		Clockwork.player:NotifyAdmins("operator", player:Name().." a mis tous les joueurs en sourdine.");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyUnmuteAll");
	COMMAND.tip = "Rétablir le son d'un joueur.";
	COMMAND.access = "s";
	COMMAND.alias = {"CharUnmuteAll", "UnmuteAll", "UngagAll", "PlyUngagAll", "CharUngagAll"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for _, v in _player.Iterator() do
			if (!Clockwork.player:IsAdmin(v)) then
				v:SetMuted(false);
			end;
		end;
		
		Clockwork.player:NotifyAdmins("operator", player:Name().." a désactivé le son de tous les joueurs.");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyFreeze");
	COMMAND.tip = "Activer/désactiver le gel d'un joueur.";
	COMMAND.text = "<string Name> [bool Freeze 0-1] [bool Force 0-1]";
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"CharFreeze"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local name = target:Name();
			local isFrozen = target:IsFrozen();
			local freeze = arguments[2];
			local didFreeze;
			
			if (freeze != nil) then
				freeze = tobool(freeze);
				
				if (!arguments[3]) then
					if (freeze == true and isFrozen) then
						Clockwork.player:Notify(player, name.." est déjà gelé!");
						return;
					elseif (freeze == false and !isFrozen) then
						Clockwork.player:Notify(player, name.." n'est pas gelé!");
						return;
					end;
				end;
				
				target:Freeze(freeze);

				if (freeze != true) then
					didFreeze = "unfrozen";
				else
					didFreeze = "frozen";
				end;
			elseif (isFrozen) then
				didFreeze = "unfrozen";
				target:Freeze(false);
			else
				didFreeze = "frozen";
				target:Freeze(true);
			end;
			
			if (didFreeze != nil) then
				Clockwork.player:Notify(player, "Tu as "..didFreeze.." "..name..".");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un joueur valide !");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("FreezeAll");
	COMMAND.tip = "Geler tous les non-administrateurs sur la carte.";
	COMMAND.access = "s";
	COMMAND.alias = {"PlyFreezeAll", "CharFreezeAll"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for _, v in _player.Iterator() do
			if (!Clockwork.player:IsAdmin(v)) then
				v:Freeze(true);
			end;
		end;
		
		Clockwork.player:NotifyAdmins("operator", player:Name().." a gelé tous les joueurs non administrateurs.", nil);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("UnFreezeAll");
	COMMAND.tip = "Débloquer tous les non-administrateurs sur la carte.";
	COMMAND.access = "s";
	COMMAND.alias = {"PlyUnFreezeAll", "CharUnFreezeAll"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for _, v in _player.Iterator() do
			if (!Clockwork.player:IsAdmin(v)) then
				v:Freeze(false);
			end;
		end;
		
		Clockwork.player:NotifyAdmins("operator", player:Name().." a débloqué tous les joueurs non administrateurs.", nil);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyRespawn");
	COMMAND.tip = "Réapparaître un joueur à son point d'apparition par défaut.";
	COMMAND.text = "<string Name> [bool Bring] [bool Freeze]";
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])

		if (target) then
			if (istable(target)) then
				for k, v in pairs (target) do
					if (v:Alive() and #target > 1) then
						target[k] = nil;
					end;
				end;
				
				target = table.FindNext(target)
			end;
		
			local maxHealth = target:GetMaxHealth();
			local bring = arguments[2];
			local freeze = arguments[3];
			local name = target:Name();

			target:Spawn();
			target:SetHealth(maxHealth);
			
			if (bring != nil) then
				if (tobool(bring) == true) then
					local trace = player:GetEyeTraceNoCursor();
					local hitNormal = trace.HitNormal;
					local position = trace.HitPos + (hitNormal * 16);
					local playerAngles = player:GetAngles();
					
					target:SetPos(position);
					target:SetEyeAngles(Angle(0, -playerAngles.y, 0));
				end;
			end;
			
			if (freeze != nil) then
				target:Freeze(true);
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un caractère valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyRespawnBring");
	COMMAND.tip = "Faites réapparaître un joueur et amenez-le à votre position de réticule.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		player:RunClockworkCmd("PlyRespawn", arguments[1], "1");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyRespawnBringFreeze");
	COMMAND.tip = "Réapparaître un joueur et l'amener à votre position de réticule, ainsi que le geler.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		player:RunClockworkCmd("PlyRespawn", arguments[1], "1", "1");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyRespawnStay");
	COMMAND.tip = "Faire réapparaître un joueur à son dernier lieu de mort.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (istable(target)) then
			for k, v in pairs (target) do
				if (v:Alive() and #target > 1) then
					target[k] = nil;
				end;
			end;
			
			target = table.FindNext(target)
		end;
		
		if (target) then
			local maxHealth = target:GetMaxHealth();
			local name = target:Name();
			local freeze = arguments[2];

			target:Spawn();
			target:SetHealth(maxHealth);
			
			if (target.cwDeathPosition) then
				target:SetPos(target.cwDeathPosition + Vector(0, 0, 0));
			end;
			
			if (target.cwDeathAngles) then
				target:SetEyeAngles(target.cwDeathAngles);
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un caractère valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyRespawnStayFreeze");
	COMMAND.tip = "Réapparaître un joueur à son dernier lieu de mort et le geler.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		player:RunClockworkCmd("PlyRespawnStay", arguments[1], "1");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyRespawnStayAll");
	COMMAND.tip = "Réapparaître tous les joueurs morts à l'endroit où ils sont morts. Vous pouvez spécifier des noms individuels à exempter de la réapparition en masse.";
	COMMAND.text = "<vararg Ignore>";
	COMMAND.access = "s";
	COMMAND.optionalArgument = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local respawned = {};
		local arguments = arguments[1];
		local exempt = {};
		
		for k, v in pairs(string.Split(arguments, " ")) do
			local target = Clockwork.player:FindByID(v);
			
			if (target) then
				exempt[target] = true;
			end;
		end;
		
		for _, v in _player.Iterator() do
			if (exempt[v] or v:Alive() or !v.cwDeathPosition) then
				continue;
			end;
			
			local name = v:Name();
				player:RunClockworkCmd("PlyRespawnStay", name, false);
			respawned[#respawned + 1] = name;
		end;
		
		if (#respawned > 0) then
			Clockwork.player:Notify(player, "Vous avez réapparu les joueurs suivants: "..table.concat(respawned, ", ")..".");
		else
			Clockwork.player:Notify(player, "Il n'y avait aucun joueur mort à réapparaître!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("GetFlags");
	COMMAND.tip = "Récupérez les drapeaux importants (petcrnCW). Vous pouvez spécifier le nom d'un joueur à qui donner ces drapeaux. Le deuxième argument fait persister les drapeaux sur tous les personnages.";
	COMMAND.text = "<string Name> <bool PlayerFlags>";
	COMMAND.access = "s";
	COMMAND.optionalArguments = 2;
	COMMAND.alias = {"GiveFlags"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = player;
		local command = "CharGiveFlags";
		local playerFlags = arguments[2];
		
		if (arguments[1]) then
			local plyTarget = Clockwork.player:FindByID(arguments[1]);
			
			if (istable(plyTarget)) then
				Clockwork.player:Notify(player, "Trop de joueurs avec l'identifiant '"..arguments[1].."' ont été trouvés. Entrez à nouveau la commande avec le nom d'un joueur spécifique!");
				return;
			end;
		
			if (plyTarget) then
				target = plyTarget;
			end;
		end;
		
		if (playerFlags != nil) then
			command = "PlyGiveFlags";
		end;
		
		local playerName = player:Name();
		local name = target:Name();
		--local flagString = "";
		
		--[[for k, v in pairs (Clockwork.flag.stored) do
			flagString = flagString..k;
		end;]]--
		
		local flagString = "petcrnCW";
		
		if (string.len(flagString) > 0) then
			player:RunClockworkCmd(command, name, flagString);
		else
			Clockwork.player:Notify(player, "Aucun rôle n'a été trouvé!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlySlay");
	COMMAND.tip = "Tuez un joueur. Utiliser \"tuer en silence\" fera instantanément réapparaître le joueur à un point d'apparition. L'argument \"Bring\" n'est utilisé que lorsque «tuer en silence »
	 est vrai.";
	COMMAND.text = "<string Name> [bool Silent] [bool Bring]";
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 2;
	COMMAND.alias = {"CharSlay", "PlyKill", "CharKill"}

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local targetIsPlayer = false;

			if (istable(target)) then
				for k, v in pairs (target) do
					if (!v:Alive() and #target > 1) then
						target[k] = nil;
					end;
				end;
				
				target = table.FindNext(target)
			end;
			
			if (target and target:IsPlayer()) then
				local name = target:Name();
				local message = "";
				
				if (target == player) then
					targetIsPlayer = true;
					name = "yourself";
				end;
				
				if (target:Alive()) then
					if (tobool(arguments[2]) == true) then
						target:KillSilent();
						
						local addon = ".";

						if (tobool(arguments[3]) == true and !targetIsPlayer) then
							local frameTime = FrameTime();
							local gender = target:GetGender();
							local thirdPerson = {
								["Male"] = "him",
								["Female"] = "her",
							};

							addon = " et apporté "..thirdPerson[gender].." à votre curseur.";
							
							timer.Simple(frameTime * 2, function()
								local trace = player:GetEyeTraceNoCursor();
								local hitNormal = trace.HitNormal;
								local position = trace.HitPos + (hitNormal * 16);
								local playerAngles = player:GetAngles();
								
								target:SetPos(position);
								target:SetEyeAngles(Angle(0, -playerAngles.y, 0));
							end);
						end;
						
						message = "Tu as tué silencieusement "..name..addon;
					else
						target:Kill();
						message = "Tu as tué "..name..".";
					end;
				else
					message = name.." est déjà mort!";
				end;
				
				if (message) then
					Clockwork.player:Notify(player, message);
				end;
			else
				Clockwork.player:Notify(player, "Aucun joueur vivant trouvé avec l'identifiant '"..string.gsub(arguments[1], "^.", string.upper).."'!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un joueur valide !");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyDemote");
	COMMAND.tip = "Rétrograder un joueur de son groupe d'utilisateurs.";
	COMMAND.text = "<string Name>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "s";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			if (!Clockwork.player:IsProtected(player)) then
				local userGroup = target:GetClockworkUserGroup();
				
				Clockwork.player:NotifyAll(player:Name().." a tenté de rétrograder "..target:Name().." depuis "..userGroup.." à l'utilisateur, mais il n'a pas la permission de faire ça!!!");

				return false;
			end
			
			if (!Clockwork.player:IsProtected(target)) then
				local userGroup = target:GetClockworkUserGroup();
				
				if (userGroup != "user") then
					Clockwork.player:NotifyAll(player:Name().." a rétrogradé "..target:Name().." depuis "..userGroup.." à l'utilisateur.");
						target:SetClockworkUserGroup("user");
					Clockwork.player:LightSpawn(target, true, true);
				else
					Clockwork.player:Notify(player, "Ce joueur n'est qu'un utilisateur et ne peut pas être rétrogradé !");
				end;
			else
				Clockwork.player:Notify(player, target:Name().." est protégé !");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un joueur valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyGoto");
	COMMAND.tip = "Accéder à l'emplacement d'un joueur.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			if cwPickupObjects then
				cwPickupObjects:ForceDropEntity(player)
			end
		
			Clockwork.player:SetSafePosition(player, target:GetPos());
			Clockwork.player:NotifyAll(player:Name().." est allé à "..target:Name().." à son emplacement.");
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un joueur valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlySearch");
	COMMAND.tip = "Rechercher l'inventaire d'un joueur.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			if (!target.cwBeingSearched) then
				if (!player.cwSearching) then
					target.cwBeingSearched = true;
					player.cwSearching = target;
					
					Clockwork.storage:Open(player, {
						name = target:Name(),
						cash = target:GetCash(),
						weight = target:GetMaxWeight(),
						space = target:GetMaxSpace(),
						entity = target,
						inventory = target:GetInventory(),
						OnClose = function(player, storageTable, entity)
							player.cwSearching = nil;
							
							if (IsValid(entity)) then
								entity.cwBeingSearched = nil;
							end;
						end,
						OnTakeItem = function(player, storageTable, itemTable)
						end,
						OnGiveItem = function(player, storageTable, itemTable)
						end
					});
				else
					Clockwork.player:Notify(player, "Vous recherchez déjà un personnage!");
				end;
			else
				Clockwork.player:Notify(player, target:Name().." est déjà recherché!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un joueur valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyKick");
	COMMAND.tip = "Expulser un joueur du serveur.";
	COMMAND.text = "<string Name> <string Reason>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 1

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		local reason = table.concat(arguments, " ", 2);
		
		if (!reason or reason == "") then
			reason = "raison non spécifiée";
		end;
		
		if (target) then
			if (!Clockwork.player:IsProtected(arguments[1])) then
				Clockwork.player:NotifyAll(player:Name().." a donné un coup de pied '"..target:Name().."' ("..reason..").");
					target:Kick(reason);
				target.kicked = true;
			else
				Clockwork.player:Notify(player, target:Name().." est protégé!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un joueur valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlySetGroup");
	COMMAND.tip = "Définir le groupe d'utilisateurs d'un joueur.";
	COMMAND.text = "<string Name> <string UserGroup>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "s";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		local userGroup = arguments[2];
		
		if (userGroup != "superadmin" and userGroup != "admin"
		and userGroup != "operator") then
			Clockwork.player:Notify(player, "Le groupe d'utilisateurs doit être superadministrateur, administrateur ou opérateur!");
			
			return;
		end;
		
		if (target) then
			if (!Clockwork.player:IsProtected(target)) then
				Clockwork.player:NotifyAll(player:Name().." a mis "..target:Name().." au groupe d'utilisateurs"..userGroup..".");
					target:SetClockworkUserGroup(userGroup);
				Clockwork.player:LightSpawn(target, true, true);
			else
				Clockwork.player:Notify(player, target:Name().." est protégé!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un joueur valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyTeleport");
	COMMAND.tip = "Téléporter un joueur vers votre emplacement cible.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.alias = {"PlyBring", "CharTeleport", "CharBring"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			if target:IsRagdolled() then
				Clockwork.player:SetRagdollState(target, RAGDOLL_NONE);
			elseif cwPickupObjects then
				cwPickupObjects:ForceDropEntity(target)
			end
			
			Clockwork.player:SetSafePosition(target, player:GetEyeTraceNoCursor().HitPos);
			Clockwork.player:NotifyAll(player:Name().." s'est téléporté "..target:Name().." à leur emplacement cible.");
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un joueur valide !");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyTeleportFreeze");
	COMMAND.tip = "Téléporter un joueur vers votre emplacement cible.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.alias = {"PlyBringFreeze", "CharTeleportFreeze", "CharBringFreeze"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			if target:IsRagdolled() then
				Clockwork.player:SetRagdollState(target, RAGDOLL_NONE);
			elseif cwPickupObjects then
				cwPickupObjects:ForceDropEntity(target)
			end
		
			Clockwork.player:SetSafePosition(target, player:GetEyeTraceNoCursor().HitPos);
			Clockwork.player:NotifyAll(player:Name().." s'est téléporté "..target:Name().." vers leur emplacement cible.");
			
			if (!target:IsFrozen()) then
				target:Freeze(true);
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un joueur valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyUnban");
	COMMAND.tip = "Annuler l'exclusion d'un identifiant Steam du serveur.";
	COMMAND.text = "<string SteamID|IPAddress>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "o";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local playersTable = config.Get("mysql_players_table"):Get();
		local schemaFolder = Clockwork.kernel:GetSchemaFolder();
		local identifier = string.upper(arguments[1]);
		
		if (Clockwork.bans.stored[identifier]) then
			Clockwork.player:NotifyAll(player:Name().." a débloqué '"..Clockwork.bans.stored[identifier].steamName.."'.");
			Clockwork.bans:Remove(identifier);
		else
			Clockwork.player:Notify(player, "Il n'y a pas de joueurs bannis avec le '"..identifier.."' identifiant!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyUnwhitelist");
	COMMAND.tip = "Supprimer un joueur de la liste blanche d'une faction.";
	COMMAND.text = "<string Name> <string Faction>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local factionTable = Clockwork.faction:FindByID(table.concat(arguments, " ", 2));
			
			if (factionTable) then
				if (factionTable.whitelist) then
					if (Clockwork.player:IsWhitelisted(target, factionTable.name)) then
						Clockwork.player:SetWhitelisted(target, factionTable.name, false);
						Clockwork.player:SaveCharacter(target);
						
						Clockwork.player:Notify(target, "Vous avez été retiré de la "..factionTable.name.." liste blanche.");
						Clockwork.player:Notify(player, player:Name().." a supprimé "..target:Name().." de la "..factionTable.name.." liste blanche.");
						--Clockwork.player:NotifyAll(player:Name().." has removed "..target:Name().." from the "..factionTable.name.." whitelist.");
					else
						Clockwork.player:Notify(player, target:Name().." n'est pas sur le "..factionTable.name.." liste blanche!");
					end;
				else
					Clockwork.player:Notify(player, factionTable.name.." n'a pas de liste blanche!");
				end;
			else
				Clockwork.player:Notify(player, factionTable.name.." n'est pas une faction valide!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un joueur valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyUnwhitelistSubfaction");
	COMMAND.tip = "Supprimer un joueur de la liste blanche d'une sous-faction.";
	COMMAND.text = "<string Name> <string Subfaction>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local subfaction = table.concat(arguments, " ", 2);
		
			for k, v in pairs(Clockwork.faction:GetAll()) do
				local factionTable = v;
				
				if (factionTable) then
					if (factionTable.subfactions) then
						for k2, v2 in pairs(factionTable.subfactions) do
							if v2.name == subfaction then
								if v2.whitelist then
									if (Clockwork.player:IsWhitelistedSubfaction(target, subfaction)) then
										Clockwork.player:SetWhitelistedSubfaction(target, subfaction, false);
										Clockwork.player:SaveCharacter(target);
										
										Clockwork.player:Notify(target, "Vous avez été retiré de la "..subfaction.." liste blanche des sous-factions.");
										Clockwork.player:Notify(player, player:Name().." a supprimé "..target:Name().." de la "..subfaction.." liste blanche des sous-factions.");
										--Clockwork.player:NotifyAll(player:Name().." has removed "..target:Name().." from the "..subfaction.." subfaction whitelist.");
										return;
									else
										Clockwork.player:Notify(player, target:Name().." n'est pas sur le "..subfaction.." liste blanche des sous-factions!");
										return;
									end;
								else
									Clockwork.player:Notify(player, subfaction.." n'a pas de liste blanche!");
									return;
								end
							end;
						end;
					end;
				end
			end
			
			Clockwork.player:Notify(player, subfaction.." n'est pas une sous-faction valide!");
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un joueur valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyVoiceBan");
	COMMAND.tip = "Interdire à un joueur d'utiliser la voix sur le serveur.";
	COMMAND.text = "<string Name|SteamID|IPAddress>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "o";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (IsValid(target)) then
			if (!target:GetData("VoiceBan")) then
				target:SetData("VoiceBan", true);
			else
				Clockwork.player:Notify(player, target:Name().." est déjà interdit d'utiliser la voix!");
			end;
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyVoiceUnban");
	COMMAND.tip = "Annuler l'interdiction d'un joueur d'utiliser la voix sur le serveur.";
	COMMAND.text = "<string Name|SteamID|IPAddress>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "o";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (IsValid(target)) then
			if (target:GetData("VoiceBan")) then
				target:SetData("VoiceBan", false);
			else
				Clockwork.player:Notify(player, target:Name().." il n'est pas interdit d'utiliser la voix!");
			end;
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyWhitelist");
	COMMAND.tip = "Mettre un joueur sur liste blanche pour une faction.";
	COMMAND.text = "<string Name> <string Faction>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		if (target) then
			local factionTable = Clockwork.faction:FindByID(table.concat(arguments, " ", 2));
			if (factionTable) then
				if (factionTable.whitelist) then
					if (!Clockwork.player:IsWhitelisted(target, factionTable.name)) then
						Clockwork.player:SetWhitelisted(target, factionTable.name, true);
						Clockwork.player:SaveCharacter(target);
						
						Clockwork.player:Notify(target, "Vous avez été ajouté à la "..factionTable.name.." liste blanche.");
						Clockwork.player:Notify(player, player:Name().." a ajouté "..target:Name().." au "..factionTable.name.." liste blanche.");
						--Clockwork.player:NotifyAll(player:Name().." has added "..target:Name().." to the "..factionTable.name.." whitelist.");
					else
						Clockwork.player:Notify(player, target:Name().." est déjà sur le "..factionTable.name.." liste blanche!");
					end;
				else
					Clockwork.player:Notify(player, factionTable.name.." n'a pas de liste blanche!");
				end;
			else
				Clockwork.player:Notify(player, table.concat(arguments, " ", 2).." n'est pas une faction valide!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un joueur valide!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyWhitelistSubfaction");
	COMMAND.tip = "Mettre un joueur sur liste blanche pour une sous-faction.";
	COMMAND.text = "<string Name> <string Subfaction>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local subfaction = table.concat(arguments, " ", 2);
		
			for k, v in pairs(Clockwork.faction:GetAll()) do
				local factionTable = v;
				
				if (factionTable) then
					if (factionTable.subfactions) then
						for k2, v2 in pairs(factionTable.subfactions) do
							if v2.name == subfaction then
								if v2.whitelist then
									if (!Clockwork.player:IsWhitelistedSubfaction(target, subfaction)) then
										Clockwork.player:SetWhitelistedSubfaction(target, subfaction, true);
										Clockwork.player:SaveCharacter(target);
										
										Clockwork.player:Notify(target, "Vous avez été ajouté à la "..subfaction.." liste blanche des sous-factions.");
										Clockwork.player:Notify(player, player:Name().." a ajouté "..target:Name().." au "..subfaction.." sous-faction whitelist.");
										--Clockwork.player:NotifyAll(player:Name().." has added "..target:Name().." to the "..subfaction.." whitelist.");
										return;
									else
										Clockwork.player:Notify(player, target:Name().." est déjà sur le "..subfaction.." liste blanche des sous-factions!");
										return;
									end;
								else
									Clockwork.player:Notify(player, subfaction.." n'a pas de liste blanche!");
									return;
								end
							end;
						end;
					end;
				end
			end
			
			Clockwork.player:Notify(player, subfaction.." n'est pas une sous-faction valide!");
		else
			Clockwork.player:Notify(player, arguments[1].." n'est pas un joueur valide!");
		end;
	end;
COMMAND:Register();

-- Properties
properties.Add("ban", {
	MenuLabel = "Ban",
	Order = 50,
	MenuIcon = "icon16/cancel.png",
	Filter = function(self, ent, ply)
		if !IsValid(ent) or !IsValid(ply) or !ply:IsAdmin() then return false end
		if !ent:IsPlayer() then
			if Clockwork.entity:IsPlayerRagdoll(ent) then
				ent = Clockwork.entity:GetPlayer(ent);
			else
				return false;
			end
		end

		return true
	end,
	Action = function(self, ent)
		if IsValid(ent) then
			if !ent:IsPlayer() then
				if Clockwork.entity:IsPlayerRagdoll(ent) then
					ent = Clockwork.entity:GetPlayer(ent);
				else
					return false;
				end
			end
		
			Derma_StringRequest(ent:Name(), "Pendant combien de minutes souhaitez-vous les bannir ?", nil, function(minutes)
				if IsValid(ent) then
					Derma_StringRequest(ent:Name(), "Quelle est votre raison de les interdire ?", nil, function(reason)
						if IsValid(ent) then
							Clockwork.kernel:RunCommand("PlyBan", ent:Name(), minutes, reason)
						end
					end)
				end
			end)
		end
	end,
});

properties.Add("freeze", {
	MenuLabel = "Freeze",
	Order = 60,
	MenuIcon = "icon16/weather_snow.png",
	Filter = function(self, ent, ply)
		if !IsValid(ent) or !IsValid(ply) or !ply:IsAdmin() then return false end
		if !ent:IsPlayer() then return false end

		return true
	end,
	Action = function(self, ent)
		if IsValid(ent) then
			Clockwork.kernel:RunCommand("PlyFreeze", ent:Name())
		end
	end,
});

properties.Add("kick", {
	MenuLabel = "Kick",
	Order = 70,
	MenuIcon = "icon16/disconnect.png",
	Filter = function(self, ent, ply)
		if !IsValid(ent) or !IsValid(ply) or !ply:IsAdmin() then return false end
		if !ent:IsPlayer() then
			if Clockwork.entity:IsPlayerRagdoll(ent) then
				ent = Clockwork.entity:GetPlayer(ent);
			else
				return false;
			end
		end

		return true
	end,
	Action = function(self, ent)
		if IsValid(ent) then
			if !ent:IsPlayer() then
				if Clockwork.entity:IsPlayerRagdoll(ent) then
					ent = Clockwork.entity:GetPlayer(ent);
				else
					return false;
				end
			end
		
			Derma_StringRequest(ent:Name(), "Quelle est la raison pour laquelle tu les as expulsés ??", nil, function(reason)
				if IsValid(ent) then
					Clockwork.kernel:RunCommand("PlyKick", ent:Name(), reason)
				end
			end)
		end
	end,
});

properties.Add("search", {
	MenuLabel = "Search",
	Order = 80,
	MenuIcon = "icon16/zoom.png",
	Filter = function(self, ent, ply)
		if !IsValid(ent) or !IsValid(ply) or !ply:IsAdmin() then return false end
		if !ent:IsPlayer() then
			if Clockwork.entity:IsPlayerRagdoll(ent) then
				ent = Clockwork.entity:GetPlayer(ent);
			else
				return false;
			end
		end

		return true
	end,
	Action = function(self, ent)
		if IsValid(ent) then
			if !ent:IsPlayer() then
				if Clockwork.entity:IsPlayerRagdoll(ent) then
					ent = Clockwork.entity:GetPlayer(ent);
				else
					return false;
				end
			end
			
			Clockwork.kernel:RunCommand("PlySearch", ent:Name())
		end
	end,
});