local Clockwork = Clockwork;

local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Backpack Base";
ITEM.uniqueID = "backpack_base";
ITEM.model = "models/props_c17/suitcase_passenger_physics.mdl";
ITEM.weight = 2; -- The real, actual weight of the item (as opposed to the perceived weight)
ITEM.invSpace = 4; -- The amount of additional space this item gives when equipped
ITEM.useText = "Équiper";
ITEM.category = "Backpacks";
ITEM.description = "Un joli sac à dos noir qui peut contenir des affaires.";
ITEM.excludeFactions = {};
ITEM.requireFaction = {};
ITEM.requireSubfaction = {};
ITEM.requireFaith = {};
ITEM.excludeSubfactions = {};
ITEM.slots = {"Backpacks"};
ITEM.equipmentSaveString = "backpack";

-- Called when a player has unequipped the item.
function ITEM:OnPlayerUnequipped(player, extraData)
	if Clockwork.equipment:UnequipItem(player, self) then
		local useSound = self.useSound;
		local infoTable = player.cwInfoTable;

		infoTable.inventoryWeight = Clockwork.inventory:CalculateWeight(player:GetInventory());
		infoTable.maxWeight = player:GetMaxWeight();
		
		--[[player:SetLocalVar("InvWeight", math.ceil(infoTable.inventoryWeight))
		
		if infoTable.inventorySpace then
			player:SetLocalVar("InvSpace", math.ceil(infoTable.inventorySpace))
		end]]--
		
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
		
		return true;
	end
	
	return false;
end

function ITEM:HasPlayerEquipped(player)
	return player:GetBackpackEquipped(self);
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
	local faction = player:GetFaction();
	local subfaction = player:GetSubfaction();
	local kinisgerOverride = player:GetNetVar("kinisgerOverride");
	local kinisgerOverrideSubfaction = player:GetNetVar("kinisgerOverrideSubfaction");

	if (self:HasPlayerEquipped(player)) then
		if !player.spawning then
			Schema:EasyText(player, "peru", "Vous ne pouvez pas équiper un objet que vous utilisez déjà.")
		end
		
		return false
	end
	
	if (table.HasValue(self.excludeFactions, kinisgerOverride or faction)) then
		if !player.spawning then
			Schema:EasyText(player, "peru", "Vous n'êtes pas la bonne faction pour porter cela!")
		end
			
		return false
	end
	
	if (table.HasValue(self.excludeSubfactions, kinisgerOverrideSubfaction or subfaction)) then
		if !player.spawning then
			Schema:EasyText(player, "peru", "Votre sous-faction ne peut pas porter cela!")
		end
		
		return false
	end
	
	if #self.requireFaith > 0 then
		if (!table.HasValue(self.requireFaith, player:GetFaith())) then
			if !player.spawning then
				Schema:EasyText(player, "chocolate", "Vous n'êtes pas de la bonne foi pour cet article!")
			end

			return false
		end
	end
	
	if #self.requireFaction > 0 then
		if (!table.HasValue(self.requireFaction, faction) and (!kinisgerOverride or !table.HasValue(self.requireFaction, kinisgerOverride))) then
			if !player.spawning then
				Schema:EasyText(player, "peru", "Vous n’êtes pas la bonne faction pour porter ça !")
			end
			
			return false
		end
	end
	
	if #self.requireSubfaction > 0 then
		if (!table.HasValue(self.requireSubfaction, subfaction) and (!kinisgerOverrideSubfaction or !table.HasValue(self.requireSubfaction, kinisgerOverrideSubfaction))) then
			if !player.spawning then
				Schema:EasyText(player, "peru", "Vous n'êtes pas la bonne sous-faction pour porter cela!")
			end
			
			return false
		end
	end

	if (player:Alive()) then
		local backpack = player:GetBackpackEquipped();
		
		if backpack and backpack.uniqueID == self.uniqueID then
			if !player.spawning then
				Schema:EasyText(player, "peru", "Vous possédez déjà un sac à dos de ce type équipé!")
			end
			
			return false
		end
		
		local infoTable = player.cwInfoTable;

		infoTable.inventoryWeight = Clockwork.inventory:CalculateWeight(player:GetInventory());
		infoTable.maxWeight = player:GetMaxWeight();
		
		--[[player:SetLocalVar("InvWeight", math.ceil(infoTable.inventoryWeight))
		
		if infoTable.inventorySpace then
			player:SetLocalVar("InvSpace", math.ceil(infoTable.inventorySpace))
		end]]--
		
		Clockwork.equipment:EquipItem(player, self, "Backpacks")

		return true
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