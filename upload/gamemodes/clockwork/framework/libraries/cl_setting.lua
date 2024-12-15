--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

library.New("setting", Clockwork)

Clockwork.setting.stored = Clockwork.setting.stored or {}

-- A function to add a number slider setting.
function Clockwork.setting:AddNumberSlider(category, text, conVar, minimum, maximum, decimals, toolTip, Condition)
	local index = conVar

	self.stored[index] = {
		Condition = Condition,
		category = category,
		decimals = decimals,
		toolTip = toolTip,
		maximum = maximum,
		minimum = minimum,
		conVar = conVar,
		class = "numberSlider",
		text = text
	}

	return index
end

-- A function to add a multi-choice setting.
function Clockwork.setting:AddMultiChoice(category, text, conVar, options, toolTip, Condition)
	local index = conVar

	if (options) then
		table.sort(options, function(a, b) return a[1] < b[1]; end)
	else
		options = {}
	end

	self.stored[index] = {
		Condition = Condition,
		category = category,
		toolTip = toolTip,
		options = options,
		conVar = conVar,
		class = "multiChoice",
		text = text
	}

	return index
end

-- A function to add a number wang setting.
function Clockwork.setting:AddNumberWang(category, text, conVar, minimum, maximum, decimals, toolTip, Condition)
	local index = conVar

	self.stored[index] = {
		Condition = Condition,
		category = category,
		decimals = decimals,
		toolTip = toolTip,
		maximum = maximum,
		minimum = minimum,
		conVar = conVar,
		class = "numberWang",
		text = text
	}

	return index
end

-- A function to add a text entry setting.
function Clockwork.setting:AddTextEntry(category, text, conVar, toolTip, Condition)
	local index = conVar

	self.stored[index] = {
		Condition = Condition,
		category = category,
		toolTip = toolTip,
		conVar = conVar,
		class = "textEntry",
		text = text
	}

	return index
end

-- A function to add a check box setting.
function Clockwork.setting:AddCheckBox(category, text, conVar, toolTip, Condition)
	local index = conVar

	self.stored[index] = {
		Condition = Condition,
		category = category,
		toolTip = toolTip,
		conVar = conVar,
		class = "checkBox",
		text = text
	}

	return index
end

-- A function to add a color mixer setting.
function Clockwork.setting:AddColorMixer(category, text, conVar, toolTip, Condition)
	local index = conVar

	self.stored[index] = {
		Condition = Condition,
		category = category,
		toolTip = toolTip,
		conVar = conVar,
		class = "colorMixer",
		text = text
	}

	return index
end

-- A function to add a panel with custom functionality.
function Clockwork.setting:AddCustomPanel(category, text, class)
	local index = text

	self.stored[index] = {
		category = category,
		class = class,
		text = text
	}

	return index
end

-- A function to remove a setting by its index.
function Clockwork.setting:RemoveByIndex(index)
	self.stored[index] = nil
end

-- A function to remove a setting by its convar.
function Clockwork.setting:RemoveByConVar(conVar)
	for k, v in pairs(self.stored) do
		if (v.conVar == conVar) then
			self.stored[k] = nil
		end
	end
end

-- A function to remove a setting.
function Clockwork.setting:Remove(category, text, class, conVar)
	for k, v in pairs(self.stored) do
		if ((!category or v.category == category)
		and (!conVar or v.conVar == conVar)
		and (!class or v.class == class)
		and (!text or v.text == text)) then
			self.stored[k] = nil
		end
	end
end

function Clockwork.setting:AddSettings()
	--Clockwork.setting:AddCheckBox("Chatbox", "Show timestamps on messages.", "cwShowTimeStamps", "Whether or not to show you timestamps on messages.");
	--Clockwork.setting:AddCheckBox("Chatbox", "Show messages related to Clockwork.", "cwShowClockwork", "Whether or not to show you any Clockwork messages.");
	--Clockwork.setting:AddCheckBox("Chatbox", "Show messages from the server.", "cwShowServer", "Whether or not to show you any server messages.");
	--Clockwork.setting:AddCheckBox("Chatbox", "Show out-of-character messages.", "cwShowOOC", "Whether or not to show you any out-of-character messages.");
	--Clockwork.setting:AddCheckBox("Chatbox", "Show in-character messages.", "cwShowIC", "Whether or not to show you any in-character messages.");

	Clockwork.setting:AddCheckBox("Framework", "Afficher ou non le journal de la console d'administration.", "cwShowLog", "Activer le journal de la console d'administration.", function()
		return Clockwork.player:IsAdmin(Clockwork.Client)
	end)

	--Clockwork.setting:AddCheckBox("Framework", "Enable the twelve hour clock.", "cwTwelveHourClock", "Whether or not to show a twelve hour clock.");
	--Clockwork.setting:AddCheckBox("Framework", "Show bars at the top of the screen.", "cwTopBars", "Whether or not to show bars at the top of the screen.");
	--Clockwork.setting:AddCheckBox("Framework", "Draw top screen elements.", "cwDateTime", "Whether or not to draw elements at the top of the screen.");
	--Clockwork.setting:AddCheckBox("Framework", "Enable the hints system.", "cwShowHints", "Whether or not to show you any hints.");
	--Clockwork.setting:AddCheckBox("Framework", "Enable Vignette.", "cwShowVignette", "Whether or not to draw the vignette.");
	
	Clockwork.setting:AddCheckBox("Framework", "Activer les info-bulles du derma en suivant la souris.", "cwTooltipFollow", "Indique si les infobulles de Derma suivent ou non la souris. Les infobulles imbriquées se figent dans leur position actuelle lorsque le minuteur est écoulé.");
	Clockwork.setting:AddCheckBox("Framework", "Activer la clé d'inspection de la description physique.", "cwPhysdescKey", "Activer ou non l'inspection de la description physique.");

	Clockwork.setting:AddCheckBox("Admin ESP", "Activer l'ESP administrateur.", "cwAdminESP", "Afficher ou non l'ESP de l'administrateur.", function()
		return Clockwork.player:IsAdmin(Clockwork.Client);
	end);

	Clockwork.setting:AddCheckBox("Admin ESP", "Afficher les entités d'élément.", "cwItemESP", "Afficher ou non les éléments dans l'ESP d'administration.", function()
		return Clockwork.player:IsAdmin(Clockwork.Client);
	end);

	Clockwork.setting:AddCheckBox("Admin ESP", "Afficher les entités commerciales.", "cwSaleESP", "Afficher ou non les vendeurs dans l'ESP d'administration.", function()
		return Clockwork.player:IsAdmin(Clockwork.Client);
	end);

	Clockwork.setting:AddNumberSlider("Admin ESP", "Intervalle ESP:", "cwESPTime", 0, 2, 0, "Le temps entre les contrôles ESP.", function()
		return Clockwork.player:IsAdmin(Clockwork.Client);
	end);
	
	Clockwork.setting:AddCheckBox("Admin ESP", "Activer ESP peek.", "cwESPPeek", "Que l'aperçu ESP soit activé ou non. Utilisez le menu contextuel pour afficher un aperçu ESP.", function()
		return Clockwork.player:IsAdmin(Clockwork.Client);
	end);
end