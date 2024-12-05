--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local Clockwork = Clockwork;
local pairs = pairs;
local vgui = vgui;
local math = math;

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(Clockwork.menu:GetWidth(), Clockwork.menu:GetHeight());
	
	self.panelList = vgui.Create("cwPanelList", self);
 	self.panelList:SetPadding(8);
 	self.panelList:SetSpacing(8);
 	self.panelList:SizeToContents();
	self.panelList:EnableVerticalScrollbar();
	
	Clockwork.system.panel = self;
	
	self:Rebuild();
end;

-- A function to rebuild the panel.
function PANEL:Rebuild()
	self.panelList:Clear();
	
	if (self.system) then
		self.navigationForm = vgui.Create("DForm", self);
			self.navigationForm:SetPadding(4);
			self.navigationForm:SetName("Navigation");
		self.panelList:AddItem(self.navigationForm);
	
		local backButton = vgui.Create("DButton", self);
			backButton:SetText("retour à la navigation");
			backButton:SetWide(self:GetParent():GetWide());
			
			-- Called when the button is clicked.
			function backButton.DoClick(button)
				self.system = nil;
				self:Rebuild();
			end;
		self.navigationForm:AddItem(backButton);
		
		local systemTable = Clockwork.system:FindByID(self.system);
		
		if (systemTable) then
			if (systemTable.doesCreateForm) then
				self.systemForm = vgui.Create("DForm", self);
					self.systemForm:SetPadding(4);
					self.systemForm:SetName(systemTable.name);
				self.panelList:AddItem(self.systemForm);
			end;
			
			systemTable:OnDisplay(self, self.systemForm);
		end;
	else
		local label = vgui.Create("cwInfoText", self);
			label:SetText("The "..Clockwork.option:GetKey("name_system").." vous fournit divers outils.");
			label:SetInfoColor("blue");
		self.panelList:AddItem(label);
		
		for k, v in pairs(Clockwork.system:GetAll()) do
			local systemButton = vgui.Create("cwInfoText", systemPanel);
				systemButton:SetText(v.name);
				systemButton:SetTextToLeft(true);
				
				if (v:HasAccess()) then
					systemButton:SetButton(true);
					systemButton:SetInfoColor("green");
					systemButton:SetToolTip("Cliquez ici pour ouvrir ce panneau système.");
					
					-- Called when the button is clicked.
					function systemButton.DoClick(button)
						self.system = v.name;
						self:Rebuild();
					end;
				else
					systemButton:SetInfoColor("red");
					systemButton:SetToolTip("Vous n'avez pas accès à ce panneau système.");
				end;
				
				systemButton:SetShowIcon(false);
			self.panelList:AddItem(systemButton);
		end;
	end;
	
	self.panelList:InvalidateLayout(true);
end;

-- A function to get whether the button is visible.
function PANEL:IsButtonVisible()
	for k, v in pairs(Clockwork.system:GetAll()) do
		if (v:HasAccess()) then
			return true;
		end;
	end;
end;

-- Called when the panel is selected.
function PANEL:OnSelected() self:Rebuild(); end;

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)
	self.panelList:StretchToParent(4, 28, 4, 4);
	self:SetSize(w, ScrH() * 0.75);
end;

-- Called when the panel is painted.
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "Frame", self, w, h);

	return true;
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
end;

vgui.Register("cwSystem", PANEL, "EditablePanel");