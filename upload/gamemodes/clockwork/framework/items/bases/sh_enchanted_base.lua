--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local ITEM = item.New(nil, true);
	ITEM.name = "Base enchantée"
	ITEM.model = "models/props_c17/suitcase_passenger_physics.mdl"
	ITEM.weight = 2
	ITEM.useText = "Équiper"
	ITEM.category = "Charms"
	ITEM.description = "Un objet enchanté avec une aura mystérieuse."
	ITEM.requireFaith = nil;
	ITEM.slots = {"Charm1", "Charm2"};
	ITEM.equipmentSaveString = "charms";

	-- Called when a player has unequipped the item.
	function ITEM:OnPlayerUnequipped(player, extraData)
		if Clockwork.equipment:UnequipItem(player, self) then
			local useSound = self.useSound;
			
			if !player:IsNoClipping() and (!player.GetCharmEquipped or !player:GetCharmEquipped("urn_silence")) then
				if (useSound) then
					if (type(useSound) == "table") then
						player:EmitSound(useSound[math.random(1, #useSound)]);
					else
						player:EmitSound(useSound);
					end;
				elseif (useSound != false) then
					player:EmitSound("begotten/items/first_aid.wav");
				end;
			end
			
			-- kind of shit but oh well
			if self.uniqueID == "ring_vitality" or self.uniqueID == "ring_vitality_lesser" then
				local max_health = player:GetMaxHealth();
				
				player:SetMaxHealth(player:GetMaxHealth());
				player:SetHealth(math.Clamp(player:Health(), 1, max_health));
			--[[elseif self.uniqueID == "ring_courier" then
				local max_stamina = player:GetMaxStamina();
				local new_stamina = math.Clamp(player:GetCharacterData("Stamina", 100), 0, max_stamina);

				player:SetLocalVar("Max_Stamina", max_stamina);
				player:SetCharacterData("Max_Stamina", max_stamina);
				player:SetNWInt("Stamina", new_stamina);
				player:SetCharacterData("Stamina", new_stamina);]]--
			end
		end
	end
	
	function ITEM:HasPlayerEquipped(player)
		return player:GetCharmEquipped(self);
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position)
		if (self:HasPlayerEquipped(player)) then
			if !player.spawning then
				Schema:EasyText(player, "peru", "Vous ne pouvez pas laisser tomber un article que vous portez actuellement.")
			end
			
			return false
		end
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		if (self:HasPlayerEquipped(player)) then
			if !player.spawning then
				Schema:EasyText(player, "peru", "Vous avez déjà un charme de ce type équipé!")
			end
			
			return false
		end
	
		if self.requireFaith and not (table.HasValue(self.requireFaith, player:GetFaith())) then
			if !self.kinisgerOverride or self.kinisgerOverride and !player:GetCharacterData("apostle_of_many_faces") then
				if !player.spawning then
					Schema:EasyText(player, "chocolate", "Vous n'êtes pas de la bonne foi pour porter cela!")
				end
				
				return false
			end
		end
		
		if self.requiredSubfaiths and not (table.HasValue(self.requiredSubfaiths, player:GetSubfaith())) then
			if !self.kinisgerOverride or self.kinisgerOverride and !player:GetCharacterData("apostle_of_many_faces") then
				if !player.spawning then
					Schema:EasyText(player, "chocolate", "Vous n'êtes pas de la bonne sous-confession pour porter cela!")
				end
				
				return false
			end
		end
		
		if self.mutuallyExclusive then
			for i, v in ipairs(self.mutuallyExclusive) do
				if player:GetCharmEquipped(v) then
					if !player.spawning then
						Schema:EasyText(player, "chocolate", "Ce charme est mutuellement exclusif avec un autre charme équipé!")
					end
					
					return false
				end
			end
		end

		if (player:Alive()) then
			for i, v in ipairs(self.slots) do
				if !player.equipmentSlots[v] then
					Clockwork.equipment:EquipItem(player, self, v);
				
					local max_stamina = player:GetMaxStamina();
					
					player:SetMaxHealth(player:GetMaxHealth());
					player:SetLocalVar("Max_Stamina", max_stamina);
					player:SetCharacterData("Max_Stamina", max_stamina);

					return true
				end
			end
	
			if !player.spawning then
				Schema:EasyText(player, "peru", "Vous n'avez pas d'emplacement ouvert pour équiper ce charme dans!")
			end
			
			return false;
		else
			if !player.spawning then
				Schema:EasyText(player, "peru", "Vous ne pouvez pas effectuer cette action pour le moment.")
			end
		end

		return false
	end
	
	function ITEM:OnInstantiated()
		-- why is this here?
		--printp("FUCKED")
	end;
ITEM:Register();