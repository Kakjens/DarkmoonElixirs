--SavedVariables Setup
local myPanel = {}
local myRed, myGreen, myBlue =0, 0.753, 1

local darkmoonelixirs = {}
darkmoonelixirs = {
	[1] = 124642, --"Darkmoon Draught of Supremacy",
	[2] = 124659, --"Darkmoon Tincture of Supremacy",
	[3] = 124646, --"Darkmoon Draught of Flexibility",
	[4] = 124658, --"Darkmoon Tincture of Flexibility",
	[5] = 124645, --"Darkmoon Draught of Precision",
	[6] = 124657, --"Darkmoon Tincture of Precision",
	[7] = 124648, --"Darkmoon Draught of Divergence",
	[8] = 124655, --"Darkmoon Tincture of Divergence",
	[9] = 124647, --"Darkmoon Draught of Alacrity",
	[10] = 124656, --"Darkmoon Tincture of Alacrity",
	[11] = 124650, --"Darkmoon Draught of Deftness",
	[12] = 124653, --"Darkmoon Tincture of Deftness",
	[13] = 124651, --"Darkmoon Draught of Deflection",
	[14] = 124652, --"Darkmoon Tincture of Deflection",
	[15] = 124649, --"Darkmoon Draught of Defense",
	[16] = 124654, --"Darkmoon Tincture of Defense",
}

local potions = {}
potions = {
	[1] = 118, --"Minor Healing Potion",
	[3] = 858, --"Lesser Healing Potion",
	[5] = 929, --"Healing Potion",
	[7] = 1710, --"Greater Healing Potion",
	[9] = 3928, --"Superior Healing Potion",
	[11] = 13446, --"Major Healing Potion",
	[13] = 22829, --"Super Healing Potion",
	[15] = 39671, --"Resurgent Healing Potion",
	[17] = 33447, --"Runic Healing Potion",
	[19] = 57191, --"Mythical Healing Potion",
	[21] = 76097, --"Master Healing Potion",
	[23] = 109223, --"Healing Tonic",
	[25] = 127834, --"Ancient Healing Potion",
	[2] = 2455, --"Minor Mana Potion",
	[4] = 3385, --"Lesser Mana Potion",
	[6] = 3827, --"Mana Potion",
	[8] = 6149, --"Greater Mana Potion",
	[10] = 13443, --"Superior Mana Potion",
	[12] = 13444, --"Major Mana Potion",
	[14] = 22832, --"Super Mana Potion",
	[16] = 40067, --"Icy Mana Potion",
	[18] = 33448, --"Runic Mana Potion",
	[20] = 57192, --"Mythical Mana Potion",
	[22] = 76098, --"Master Mana Potion",
	[24] = 109222, --"Draenic Mana Potion",
	[26] = 127835, --"Ancient Mana Potion"
}

local itemset = {}
local what_to_do = "Darkmoon"
--local what_to_do = "Potions"
if (what_to_do == "Darkmoon") then
	itemset = darkmoonelixirs
else
	itemset = potions
end
local numIte = #itemset

local stage = {}
local which = {}

local addonname="DarkmoonElixirs"



local private = {}
private.defaults = {}
private.defaults.DarkmoonElixirsCheckboxes = {
	hide_if_none_at_bag = true,
	but_show_if_there_are_in_bank_static = false,
	but_show_if_there_are_in_bank_dynamic = false,
	frame_visible = true,
	dynamic_buttons = false,
	show_buttons = true,
}

local MyDefaultConfig = private.defaults.DarkmoonElixirsCheckboxes

private.db = {}
private.db.DarkmoonElixirsCheckboxes = {}

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
	loader:SetScript("OnEvent", function(self, event, arg1)
		if event == "ADDON_LOADED" and arg1 == addonname then
			local function initDB(db, defaults)
				if type(db) ~= "table" then db = {} end
				if type(defaults) ~= "table" then return db end
				for k, v in pairs(defaults) do
					if type(v) == "table" then
						db[k] = initDB(db[k], v)
					elseif type(v) ~= type(db[k]) then
						db[k] = v
					end
				end
				return db
			end
			DarkmoonElixirsDB = initDB(DarkmoonElixirsDB, private.defaults)
			private.db = DarkmoonElixirsDB
			self:UnregisterEvent(event)
		end
	end)


myPanel = {};

myPanel.panel = CreateFrame( "Frame", addonname.."Panel", UIParent );
-- Register in the Interface Addon Options GUI
-- Set the name for the Category for the Options Panel
myPanel.panel.name = addonname;
-- Add the panel to the Interface Options
InterfaceOptions_AddCategory(myPanel.panel);

-- Make a child panel
-- myPanel.childpanel = CreateFrame( "Frame", addonname.."Child", myPanel.panel);
-- myPanel.childpanel.name = "MyChild";
-- Specify childness of this panel (this puts it under the little red [+], instead of giving it a normal AddOn category)
-- myPanel.childpanel.parent = myPanel.panel.name;
-- Add the child to the Interface Options
-- InterfaceOptions_AddCategory(myPanel.childpanel);
--local myamazingpanel = _G[addonname.."Panel"]
--Panel Title
local title=CreateFrame("Frame", addonname.."title", myPanel.panel)
	title:SetPoint("TOPLEFT", 5, -5)
	title:SetScale(2.0)
	title:SetWidth(150)
	title:SetHeight(50)
	title:Show()

local titleFS = title:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	titleFS:SetText('|cff00c0ff'..addonname..'|r')
	titleFS:SetPoint("TOPLEFT", 0, 0)
	titleFS:SetFont("Fonts\\FRIZQT__.TTF", 10)

local MyDragFrame = CreateFrame("Frame", addonname.."DragFrame", UIParent)

local function reset_position()
	DEFAULT_CHAT_FRAME:AddMessage("Reseting positions", myRed, myGreen, myBlue)
	MyDragFrame:Hide() -- for some reason needs to be hidden
	MyDragFrame:ClearAllPoints()
	MyDragFrame:SetPoint("CENTER", UIParent,"CENTER", 0, 0)
	MyDragFrame:Show()
end

local function reset_position_reload()
	reset_position()
	DarkmoonElixirsDB = private.defaults
	ReloadUI();
end


	
local resetcheck = CreateFrame("Button", addonname.."ResetButton", myPanel.panel, "UIPanelButtonTemplate")
	resetcheck:ClearAllPoints()
	resetcheck:SetPoint("BOTTOMLEFT", 5, 5)
	resetcheck:SetScale(1.25)
	resetcheck:SetWidth(125)
	resetcheck:SetHeight(30)
	_G[resetcheck:GetName() .. "Text"]:SetText("Reset to Default")
	resetcheck:SetScript("OnClick", function (self, button, down)
		--reset_position()
		reset_position_reload()
 		--DarkmoonElixirsDB = private.defaults;
		--ReloadUI();
end)

local function ShowEnableFrames()
	MyDragFrame:Show()
	MyDragFrame:EnableMouse(true)
	--MyDragFrame:Show()
	--MyDragFrame:EnableMouse(true)
end

local y
local x
local biasy = 22
local buttonSize = 32
local padding = 10
local button_pad = buttonSize + padding
local index0
local index1
local indexxx
local gotin


local MyHideFrame = CreateFrame("Frame", addonname.."HideFrame", MyDragFrame)
local MyInitFrame = CreateFrame("Frame", addonname.."InitFrame", MyHideFrame)

local function updatebuttons()
	local hide_if_none_at_bag = private.db.DarkmoonElixirsCheckboxes.hide_if_none_at_bag
	local but_show_if_there_are_in_bank_static = private.db.DarkmoonElixirsCheckboxes.but_show_if_there_are_in_bank_static
	local but_show_if_there_are_in_bank_dynamic = private.db.DarkmoonElixirsCheckboxes.but_show_if_there_are_in_bank_dynamic
	local dynamic_buttons = private.db.DarkmoonElixirsCheckboxes.dynamic_buttons
	if dynamic_buttons then
		index0 = -1
		index1 = -1
		for index = 1, numIte, 1 do
			local itemID = itemset[index]
			local itemcount_bag = GetItemCount(itemID, false, false)
			local itemcount_bank = GetItemCount(itemID, true, false)
			gotin = false
			local button = _G["buttonframe"..itemID]
			if button then
				button:Hide()
				if itemcount_bank > 0 then
					if itemcount_bag == 0 then
						if but_show_if_there_are_in_bank_dynamic then
							gotin = true
							if stage[itemID] then
								index0 = index0 + 1
								y = 0
								indexxx = index0
							else
								index1 = index1 + 1
								y = button_pad
								indexxx = index1
							end
							x = button_pad * indexxx
							button:SetPoint("BOTTOMLEFT", MyInitFrame, x, y + biasy)
							button.slot:SetScript("OnEnter", function()
								local _, itemLink= GetItemInfo(itemID)
								GameTooltip:SetOwner(button, "ANCHOR_CURSOR")
								GameTooltip:SetHyperlink(itemLink)
								GameTooltip:Show()
							end)
						end --if but_show_if_there_are_in_bank_dynamic then
					else
						gotin = true
						if stage[itemID] then
							index0 = index0 + 1
							y = 0
							indexxx = index0
						else
							index1 = index1 + 1
							y = button_pad
							indexxx = index1
						end
						x = button_pad * indexxx
						button:SetPoint("BOTTOMLEFT", MyInitFrame, x, y + biasy)
						local bagID, slotID
						for bag = 0, 4 do
							for slot = 1, GetContainerNumSlots(bag) do
								local bagitemID = GetContainerItemID(bag, slot)
								if bagitemID == itemID then
									bagID = bag
									slotID = slot
								end
							end
						end
						button:SetID(bagID)
						button.slot:SetID(slotID)
						button.slot:SetScript("OnEnter", function()
							local bag = button:GetID()
							local slot = button.slot:GetID()
							GameTooltip:SetOwner(button, "ANCHOR_CURSOR")
							GameTooltip:SetBagItem(bag, slot);
							GameTooltip:Show()
						end)
					end --if itemcount_bag = 0 then
					if gotin then
						button.slot.Count:SetText(itemcount_bag)
						button.slot.Count:Show()
						button.slot.Count1:Hide()
						if itemcount_bag ~= itemcount_bank then
							button.slot.Count1:SetText(itemcount_bank)
							button.slot.Count1:Show()
						end
						button:Show()
						if hide_if_none_at_bag then
							if itemcount_bag == 0 then button:Hide() end
						end
						if itemcount_bank == 0 then
							button.slot.icon:SetDesaturated(true)
						else
							button.slot.icon:SetDesaturated(false)
						end
						if but_show_if_there_are_in_bank_dynamic then
							if itemcount_bank > 0 then button:Show() end
							if itemcount_bag == 0 then
								button.slot.icon:SetDesaturated(true)
							else
								button.slot.icon:SetDesaturated(false)
							end
						end
						_G["buttonframe"..itemID] = button
					end --if gotin then
				end --if itemcount_bank > 0 then
			end --if button then
		end --for index = 1, numIte, 1 do
	else
		for index = 1, numIte, 1 do
			local itemID = itemset[index]
			local itemcount_bag = GetItemCount(itemID, false, false)
			local itemcount_bank = GetItemCount(itemID, true, false)
			local button = _G["buttonframe"..itemID]
			if button then
				button:Hide()
				if stage[itemID] then y = 0 else y = button_pad end
				x = button_pad * which[itemID]
				button:SetPoint("BOTTOMLEFT", MyInitFrame, x, y + biasy)
				local bagID, slotID
				if itemcount_bag > 0 then
					for bag = 0, 4 do
						for slot = 1, GetContainerNumSlots(bag) do
							local bagitemID = GetContainerItemID(bag, slot)
							if bagitemID == itemID then
								bagID = bag
								slotID = slot
							end
						end
					end
				end
				if bagID then
					button:SetID(bagID)
					button.slot:SetID(slotID)
					button.slot:SetScript("OnEnter", function()
						local bag = button:GetID()
						local slot = button.slot:GetID()
						GameTooltip:SetOwner(button, "ANCHOR_CURSOR")
						GameTooltip:SetBagItem(bag, slot);
						GameTooltip:Show()
					end)
				else
					button.slot:SetScript("OnEnter", function()
						local _, itemLink= GetItemInfo(itemID)
						GameTooltip:SetOwner(button, "ANCHOR_CURSOR")
						GameTooltip:SetHyperlink(itemLink)
						GameTooltip:Show()
					end)
				end
				button.slot.Count:SetText(itemcount_bag)
				button.slot.Count:Show()
				button.slot.Count1:Hide()
				if itemcount_bag ~= itemcount_bank then
					button.slot.Count1:SetText(itemcount_bank)
					button.slot.Count1:Show()
				end
				button:Show()
				if hide_if_none_at_bag then
					if itemcount_bag == 0 then button:Hide() end
				end
				if itemcount_bank == 0 then
					button.slot.icon:SetDesaturated(true)
				else
					button.slot.icon:SetDesaturated(false)
				end
				if but_show_if_there_are_in_bank_static then
					if itemcount_bank > 0 then button:Show() end
					if itemcount_bag == 0 then
						button.slot.icon:SetDesaturated(true)
					else
						button.slot.icon:SetDesaturated(false)
					end
				end
				_G["buttonframe"..itemID] = button
			end
		end
	end
end

local MyStaticCheck = CreateFrame("CheckButton", addonname.."StaticCheck",  myPanel.panel, "InterfaceOptionsCheckButtonTemplate")
local MyDynamicCheck = CreateFrame("CheckButton", addonname.."DynamicCheck",  myPanel.panel, "InterfaceOptionsCheckButtonTemplate")
local MyHideCheckStatic = CreateFrame("CheckButton", addonname.."HideCheckStatic",  myPanel.panel, "InterfaceOptionsCheckButtonTemplate")
local MyLimitedShowCheckStatic = CreateFrame("CheckButton", addonname.."ShowCheckStatic",  myPanel.panel, "InterfaceOptionsCheckButtonTemplate")
local MyShowHide = CreateFrame("CheckButton", addonname.."ShowHide", myPanel.panel, "InterfaceOptionsCheckButtonTemplate")
local MyLimitedShowCheckDynamic = CreateFrame("CheckButton", addonname.."ShowCheckDynamic",  myPanel.panel, "InterfaceOptionsCheckButtonTemplate")


local where_to_place = -20
local decrement = 30

	
	where_to_place = where_to_place - decrement
	MyShowHide:RegisterEvent("ADDON_LOADED")
	MyShowHide:ClearAllPoints()
	MyShowHide:SetPoint("TOPLEFT", 25, where_to_place)
	MyShowHide:SetScale(1.25)
	_G[MyShowHide:GetName() .. "Text"]:SetText("Display or hide DarkmoonElixirs frame")
	MyShowHide.tooltipText = 'Checked shows DarkmoonElixirs. Unchecked hides DarkmoonElixirs.' --Creates a tooltip on mouseover.
	
local function setframevisibility(state)
		if state then
			--MyDragFrame:Hide()
			MyDragFrame:Show()
			--MyShowHideButton:Show()
		else
			--MyDragFrame:Show()
			MyDragFrame:Hide()
			--MyShowHideButton:Hide()
		end
end
	
	MyShowHide:SetScript("OnEvent", function(self, button, up)
		local checked = private.db.DarkmoonElixirsCheckboxes.frame_visible
		self:SetChecked(checked)
		setframevisibility(checked)
	end)
	
	MyShowHide:SetScript("OnClick", function(self, button, up)
		local checked = self:GetChecked()
		private.db.DarkmoonElixirsCheckboxes.frame_visible = checked
		setframevisibility(checked)
	end)	

local MyHideCheckStatictext = "Hide icon for Darkmoon elixir if none in bag"
local MyLimitedShowCheckStatictext = "But display icon for Darkmoon elixir if it's in bank"
local MyLimitedShowCheckDynamictext = "Also for Darkmoon elixirs in bank"
local greycode = "|cff7f7f7f"
local function update_checbox_availability()
	local status = private.db.DarkmoonElixirsCheckboxes.dynamic_buttons
	if status then
		MyHideCheckStatic:Disable()
		_G[MyHideCheckStatic:GetName() .. "Text"]:SetText(greycode .. MyHideCheckStatictext .. "|r")
		MyLimitedShowCheckStatic:Disable()
		_G[MyLimitedShowCheckStatic:GetName() .. "Text"]:SetText(greycode .. MyLimitedShowCheckStatictext .. "|r")
		MyLimitedShowCheckDynamic:Enable()
		_G[MyLimitedShowCheckDynamic:GetName() .. "Text"]:SetText(MyLimitedShowCheckDynamictext)
	else
		MyHideCheckStatic:Enable()
		_G[MyHideCheckStatic:GetName() .. "Text"]:SetText(MyHideCheckStatictext)
		local status1 = private.db.DarkmoonElixirsCheckboxes.hide_if_none_at_bag
		if status1 then
			MyLimitedShowCheckStatic:Enable()
			_G[MyLimitedShowCheckStatic:GetName() .. "Text"]:SetText(MyLimitedShowCheckStatictext)
		else
			MyLimitedShowCheckStatic:Disable()
			_G[MyLimitedShowCheckStatic:GetName() .. "Text"]:SetText(greycode .. MyLimitedShowCheckStatictext.. "|r")
		end
		MyLimitedShowCheckDynamic:Disable()
		_G[MyLimitedShowCheckDynamic:GetName() .. "Text"]:SetText(greycode .. MyLimitedShowCheckDynamictext .. "|r")
	end
end
--[[
local function update_checbox_availability(status)
	if status then
			DCS_butShowifChecked:Enable()
			_G[DCS_butShowifChecked:GetName() .. "Text"]:SetText(L["But show if checked"])
		else
			DCS_butShowifChecked:SetChecked(false)
			gdbprivate.gdb.gdbdefaults.dejacharacterstatsbutShowifCheckedChecked.SetChecked = false
			_G[DCS_butShowifChecked:GetName() .. "Text"]:SetText("|cff7f7f7f" .. L["But show if checked"] .. "|r" )
			DCS_butShowifChecked:Disable()
		end
end

--]]



	where_to_place = where_to_place - decrement
	MyStaticCheck:RegisterEvent("ADDON_LOADED")
	MyStaticCheck:ClearAllPoints()
	MyStaticCheck:SetPoint("TOPLEFT", 25, where_to_place)
	MyStaticCheck:SetScale(1.25)
	_G[MyStaticCheck:GetName() .. "Text"]:SetText("Static display:")
	MyStaticCheck.tooltipText = 'Checked preserves positions of icons for Darkmoon elixirs. Exclusive with Dynamic display.' --Creates a tooltip on mouseover.
	
	MyStaticCheck:SetScript("OnEvent", function(self, button, up)
		local checked = not private.db.DarkmoonElixirsCheckboxes.dynamic_buttons
		self:SetChecked(checked)
		update_checbox_availability()
		--private.db.DarkmoonElixirsCheckboxes.but_show_if_there_are_in_bank = checked --???
	end)

	MyStaticCheck:SetScript("OnClick", function(self, button, up)
		local checked = self:GetChecked()
		private.db.DarkmoonElixirsCheckboxes.dynamic_buttons = not checked
		MyDynamicCheck:SetChecked(not checked)
		update_checbox_availability()
		updatebuttons()
	end)
	
	where_to_place = where_to_place - decrement
	MyHideCheckStatic:RegisterEvent("ADDON_LOADED")
	MyHideCheckStatic:ClearAllPoints()
	MyHideCheckStatic:SetPoint("TOPLEFT", 40, where_to_place)
	MyHideCheckStatic:SetScale(1.25)
	--_G[MyHideCheckStatic:GetName() .. "Text"]:SetText("Hide icon for Darkmoon elixir if none in bag")
	MyHideCheckStatic.tooltipText = 'Checked hides icons for Darkmoon elixirs which are not in bag. Unchecked shows all possible Darkmoon elixirs.' --Creates a tooltip on mouseover.
	
	MyHideCheckStatic:SetScript("OnEvent", function(self, button, up)
		local checked = private.db.DarkmoonElixirsCheckboxes.hide_if_none_at_bag
		--if checked then MyLimitedShowCheckStatic:Enable() else MyLimitedShowCheckStatic:Disable() end --conflict with update_checbox_availability()
		self:SetChecked(checked)
		--private.db.DarkmoonElixirsCheckboxes.hide_if_none_at_bag = checked --???
	end)

	MyHideCheckStatic:SetScript("OnClick", function(self, button, up)
		local checked = self:GetChecked()
		private.db.DarkmoonElixirsCheckboxes.hide_if_none_at_bag = checked
		update_checbox_availability()
		--[[
			local checked = self:GetChecked()
			private.db.DarkmoonElixirsCheckboxes.hide_if_none_at_bag = checked
			if checked then MyLimitedShowCheckStatic:Enable() else MyLimitedShowCheckStatic:Disable() end
		--]]
		updatebuttons()
	end)
		
	where_to_place = where_to_place - decrement
	MyLimitedShowCheckStatic:RegisterEvent("ADDON_LOADED")
	MyLimitedShowCheckStatic:ClearAllPoints()
	MyLimitedShowCheckStatic:SetPoint("TOPLEFT", 55, where_to_place)
	MyLimitedShowCheckStatic:SetScale(1.25)
	--_G[MyLimitedShowCheckStatic:GetName() .. "Text"]:SetText("But display icon for Darkmoon elixir if it's in bank")
	MyLimitedShowCheckStatic.tooltipText = 'Checked displays icons for Darkmoon elixirs which are in bag or bank.' --Creates a tooltip on mouseover.
	
	MyLimitedShowCheckStatic:SetScript("OnEvent", function(self, button, up)
		local checked = private.db.DarkmoonElixirsCheckboxes.but_show_if_there_are_in_bank_static
		self:SetChecked(checked)
		--private.db.DarkmoonElixirsCheckboxes.but_show_if_there_are_in_bank = checked --???
	end)

	MyLimitedShowCheckStatic:SetScript("OnClick", function(self, button, up)
		local checked = self:GetChecked()
		private.db.DarkmoonElixirsCheckboxes.but_show_if_there_are_in_bank_static = checked
		updatebuttons()
	end)	
	
	where_to_place = where_to_place - decrement
	MyDynamicCheck:RegisterEvent("ADDON_LOADED")
	MyDynamicCheck:ClearAllPoints()
	MyDynamicCheck:SetPoint("TOPLEFT", 25, where_to_place)
	MyDynamicCheck:SetScale(1.25)
	_G[MyDynamicCheck:GetName() .. "Text"]:SetText("Dynamic display:")
	--MyDynamicCheck.tooltipText = 'Unchecked preserves positions of icons for Darkmoon elixirs. Exclusive with Static eisplay.' --Creates a tooltip on mouseover.
	MyDynamicCheck.tooltipText = 'Checked collapses display for Darkmoon elixirs in bags. Exclusive with Static eisplay.' --Creates a tooltip on mouseover.
	
	MyDynamicCheck:SetScript("OnEvent", function(self, button, up)
		local checked = private.db.DarkmoonElixirsCheckboxes.dynamic_buttons
		self:SetChecked(checked)
		update_checbox_availability()
		--private.db.DarkmoonElixirsCheckboxes.but_show_if_there_are_in_bank = checked --???
	end)

	MyDynamicCheck:SetScript("OnClick", function(self, button, up)
		local checked = self:GetChecked()
		private.db.DarkmoonElixirsCheckboxes.dynamic_buttons = checked
		MyStaticCheck:SetChecked(not checked)
		update_checbox_availability()
		updatebuttons()
	end)	
	
where_to_place = where_to_place - decrement
	MyLimitedShowCheckDynamic:RegisterEvent("ADDON_LOADED")
	MyLimitedShowCheckDynamic:ClearAllPoints()
	MyLimitedShowCheckDynamic:SetPoint("TOPLEFT", 55, where_to_place)
	MyLimitedShowCheckDynamic:SetScale(1.25)
	--_G[MyLimitedShowCheckDynamic:GetName() .. "Text"]:SetText("But display icon for Darkmoon elixir if it's in bank")
	--_G[MyLimitedShowCheckDynamic:GetName() .. "Text"]:SetText("Also for Darkmoon elixirs in bank")
	MyLimitedShowCheckDynamic.tooltipText = 'Checked displays icons for Darkmoon elixirs which are in bag or bank.' --Creates a tooltip on mouseover.
	
	MyLimitedShowCheckDynamic:SetScript("OnEvent", function(self, button, up)
		local checked = private.db.DarkmoonElixirsCheckboxes.but_show_if_there_are_in_bank_dynamic
		self:SetChecked(checked)
		--private.db.DarkmoonElixirsCheckboxes.but_show_if_there_are_in_bank = checked --???
	end)

	MyLimitedShowCheckDynamic:SetScript("OnClick", function(self, button, up)
		local checked = self:GetChecked()
		private.db.DarkmoonElixirsCheckboxes.but_show_if_there_are_in_bank_dynamic = checked
		updatebuttons()
	end)	

	


--Open Categaories Fix
do
	local function get_panel_name(panel)
		local tp = type(panel)
		local cat = INTERFACEOPTIONS_ADDONCATEGORIES
		if tp == "string" then
			for i = 1, #cat do
				local p = cat[i]
				if p.name == panel then
					if p.parent then
						return get_panel_name(p.parent)
					else
						return panel
					end
				end
			end
		elseif tp == "table" then
			for i = 1, #cat do
				local p = cat[i]
				if p == panel then
					if p.parent then
						return get_panel_name(p.parent)
					else
						return panel.name
					end
				end
			end
		end
	end

	local function InterfaceOptionsFrame_OpenToCategory_Fix(panel)
		if doNotRun or InCombatLockdown() then return end
		local panelName = get_panel_name(panel)
		if not panelName then return end -- if its not part of our list return early
		local noncollapsedHeaders = {}
		local shownpanels = 0
		local mypanel
		local t = {}
		local cat = INTERFACEOPTIONS_ADDONCATEGORIES
		for i = 1, #cat do
			local panel = cat[i]
			if not panel.parent or noncollapsedHeaders[panel.parent] then
				if panel.name == panelName then
					panel.collapsed = true
					t.element = panel
					InterfaceOptionsListButton_ToggleSubCategories(t)
					noncollapsedHeaders[panel.name] = true
					mypanel = shownpanels + 1
				end
				if not panel.collapsed then
					noncollapsedHeaders[panel.name] = true
				end
				shownpanels = shownpanels + 1
			end
		end
		local Smin, Smax = InterfaceOptionsFrameAddOnsListScrollBar:GetMinMaxValues()
		if shownpanels > 15 and Smin < Smax then 
		  local val = (Smax/(shownpanels-15))*(mypanel-2)
		  InterfaceOptionsFrameAddOnsListScrollBar:SetValue(val)
		end
		doNotRun = true
		InterfaceOptionsFrame_OpenToCategory(panel)
		doNotRun = false
	end

	hooksecurefunc("InterfaceOptionsFrame_OpenToCategory", InterfaceOptionsFrame_OpenToCategory_Fix)
end

--addons Slash Setup
local RegisteredEvents = {};
local myslash = CreateFrame("Frame", addonname.."Slash", UIParent)

myslash:SetScript("OnEvent", function (self, event, ...) 
	if (RegisteredEvents[event]) then 
		return RegisteredEvents[event](self, event, ...) 
	end
end)
local addon
SLASH_DARKMOONELIXIRS1 = '/dme'
local slashcommand = SLASH_DARKMOONELIXIRS1

local upperaddonname = string.upper(addonname)

function RegisteredEvents:ADDON_LOADED( ...)
	_, addon = ...
	if (addon == addonname) then
		--SLASH_DARKMOONELIXIRS1 = '/dme'
		SlashCmdList[upperaddonname] = function (...)
			myPanel.SlashCmdHandler(...)	
		end
		DEFAULT_CHAT_FRAME:AddMessage(addonname .. " loaded successfully. Type " .. slashcommand .. " for usage", myRed, myGreen, myBlue)
	end
end

for k, v in pairs(RegisteredEvents) do
	myslash:RegisterEvent(k)
end

function myPanel.ShowHelp()
	DEFAULT_CHAT_FRAME:AddMessage(addonname .. " Slash commands (" .. slashcommand .. "):", myRed, myGreen, myBlue)
	DEFAULT_CHAT_FRAME:AddMessage("  " .. slashcommand .. " config: Open the " .. addonname .. " addon config menu.", myRed, myGreen, myBlue)
	DEFAULT_CHAT_FRAME:AddMessage("  " .. slashcommand .. " reset:  Resets " .. addonname .. " frames to default positions.", myRed, myGreen, myBlue)
end

--function myPanel.SetConfigToDefaults()
--	print("Resetting config to defaults")
--	DarkmoonElixirsDB = DefaultConfig
	--RELOADUI()
--end

function myPanel.GetConfigValue(key)
	return DarkmoonElixirsDB.DarkmoonElixirsCheckboxes[key]
end

local mem
function myPanel.PrintPerformanceData()
	UpdateAddOnMemoryUsage()
	mem = GetAddOnMemoryUsage(addonname)
	DEFAULT_CHAT_FRAME:AddMessage(addonname .. "is currently using " .. mem .. " kbytes of memory", myRed, myGreen, myBlue)
	collectgarbage("collect")
	UpdateAddOnMemoryUsage()
	mem = GetAddOnMemoryUsage(addonname)
	DEFAULT_CHAT_FRAME:AddMessage(addonname .. "is currently using " .. mem .. " kbytes of memory after garbage collection", myRed, myGreen, myBlue)
end
local lowcase
local smth
function myPanel.SlashCmdHandler(msg, editbox)
	--print("command is " .. msg .. "\n")
	lowcase = string.lower(msg)
	if (lowcase == "config") then
		InterfaceOptionsFrame_OpenToCategory(addonname);
	elseif (lowcase == "dumpconfig") then
		DEFAULT_CHAT_FRAME:AddMessage("Current values:", myRed, myGreen, myBlue)
		for k,value2 in pairs(MyDefaultConfig) do
			local value1 = myPanel.GetConfigValue(k)
			if value1 == value2 then
				DEFAULT_CHAT_FRAME:AddMessage(k .. " " .. tostring(value1))
				--print(k,value1,"(",value2,")")
			else
				DEFAULT_CHAT_FRAME:AddMessage(k .. " " .. tostring(value1) .. " Default: " .. tostring(value2), myRed, myGreen, myBlue)
			end
		end
	elseif (lowcase == "reset") then
		DarkmoonElixirsDB = private.defaults;
		ReloadUI();
	elseif (lowcase == "perf") then
		myPanel.PrintPerformanceData()	
	else
		myPanel.ShowHelp()
	end
end
	SlashCmdList[upperaddonname] = myPanel.SlashCmdHandler;


	-- itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, 
	-- itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = 
	-- GetItemInfo(itemID or "itemString" or "itemName" or "itemLink")




	--MyDragFrame:RegisterEvent("PLAYER_LOGIN")
	--MyDragFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	--MyDragFrame:RegisterEvent("ADDON_LOADED")
	--MyDragFrame:RegisterEvent("ZONE_CHANGED")
	--MyDragFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	--MyDragFrame:RegisterEvent("WORLD_MAP_UPDATE")
	--MyDragFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
	MyDragFrame:RegisterEvent("MODIFIER_STATE_CHANGED")
	
	MyDragFrame:SetClampedToScreen(true)
	MyDragFrame:ClearAllPoints()
	MyDragFrame:SetPoint("CENTER", UIParent, 0, 0)
	MyDragFrame:SetWidth(340)
	MyDragFrame:SetHeight(164)
	MyDragFrame:Show()

	--Basic draggable frames
	MyDragFrame:SetMovable(true)
	--MyDragFrame:EnableMouse(true)
	MyDragFrame:RegisterForDrag("LeftButton","RightButton")
	
	--Debugging Texture
	--local MyDragFrametexture=MyDragFrame:CreateTexture(nil,"ARTWORK")
	--MyDragFrametexture:SetAllPoints(MyDragFrame)
	--MyDragFrametexture:SetColorTexture(1, 1, 1, 0.7)

	MyDragFrame:SetScript("OnEvent", function(self, event, ...)
		if event == "MODIFIER_STATE_CHANGED" then
			--if IsModifierKeyDown() then
			if IsShiftKeyDown() or IsControlKeyDown() then
				self:EnableMouse(true)
				--print("mod down")
			else
				self:EnableMouse(false)
				self:StopMovingOrSizing() 
				--print("mod up")
			end
		end
	end)

	MyDragFrame:SetScript("OnDragStart", MyDragFrame.StartMoving) 
	
	MyDragFrame:SetScript("OnDragStop", MyDragFrame.StopMovingOrSizing)
	
--local MyHideFrame = CreateFrame("Frame", addonname.."HideFrame", MyDragFrame)
	--MyHideFrame:RegisterEvent("PLAYER_LOGIN")
	MyHideFrame:SetClampedToScreen(true)
	MyHideFrame:ClearAllPoints()
	MyHideFrame:SetPoint("BOTTOMLEFT", MyDragFrame)
	MyHideFrame:SetWidth(236)
	MyHideFrame:SetHeight(180)
	
	--Debugging Texture
	--local MyHideFrametexture=MyHideFrame:CreateTexture(nil,"ARTWORK")
	--MyHideFrametexture:SetAllPoints(MyHideFrame)
	--MyHideFrametexture:SetColorTexture(0, 0.75, 1, 0.7)



local MyShowHideButtontooltipText



local MyShowHideButton = CreateFrame("Button", addonname.."ShowHideButton", MyDragFrame, "UIPanelButtonGrayTemplate")
	MyShowHideButton:RegisterEvent("PLAYER_LOGIN")
	MyShowHideButton:ClearAllPoints()
	MyShowHideButton:SetPoint("BOTTOMLEFT", MyHideFrame, -2, 10)
	MyShowHideButton:SetWidth(94)
	MyShowHideButton:SetHeight(30)
	MyShowHideButton:Show()

local function MyShowHideTooltipChangeText()
	GameTooltip:SetOwner(MyShowHideButton, "ANCHOR_RIGHT");
	GameTooltip:SetText(MyShowHideButtontooltipText, 1, 1, 1, 1, true)
	--GameTooltip_Hide()
end
	
	
	--Button Color (Overrides default red buttons)
--local MyShowHideButtonTexture=MyShowHideButton:CreateTexture(nil,"ARTWORK")
--	MyShowHideButtonTexture:SetAllPoints(MyShowHideButton)
--	MyShowHideButtonTexture:SetColorTexture(0, 0.75, 1, 1)

local MyShowHideButtonFS = MyShowHideButton:CreateFontString("FontString","OVERLAY","GameTooltipText")
	MyShowHideButtonFS:SetPoint("CENTER", MyShowHideButton)
	MyShowHideButtonFS:SetFont("Fonts\\FRIZQT__.TTF", 12)
	MyShowHideButtonFS:SetShadowOffset(1, -1)
	MyShowHideButtonFS:SetTextColor(1, 1, 0);
	MyShowHideButtonFS:SetText("")

local function updateshowhide()
	local ShowHideButtonCheck = private.db.DarkmoonElixirsCheckboxes.show_buttons
	if ShowHideButtonCheck then
		MyHideFrame:Show()
		--MyDragFrame:Show()
		MyShowHideButtontooltipText = "Hides buttons for Darkmoon Draughts and Tinctures." --Creates a tooltip on mouseover.
		MyShowHideButtonFS:SetText("Hide")
	else
		MyHideFrame:Hide()
		--MyDragFrame:Hide()
		MyShowHideButtontooltipText = "Shows buttons for Darkmoon Draughts and Tinctures in your bags. For available ways of displaying of items check Interface Options" --Creates a tooltip on mouseover.
		MyShowHideButtonFS:SetText("Show")
		--print("Hidden")--Debugging
	end
	MyShowHideTooltipChangeText()
end
			
	MyShowHideButton:SetScript("OnEvent", function(self, button, up)
		updateshowhide()
		GameTooltip_Hide()
	end)
	
	MyShowHideButton:SetScript("OnClick", function(self, button, up)
		private.db.DarkmoonElixirsCheckboxes.show_buttons = not private.db.DarkmoonElixirsCheckboxes.show_buttons
		updateshowhide()
	end)
 
 	MyShowHideButton:SetScript("OnEnter", function(self)
		MyShowHideTooltipChangeText()
		--print("on nether")
		--GameTooltip:Show()
	end)

	MyShowHideButton:SetScript("OnLeave", function(self)
		GameTooltip_Hide()
	end)
	
		
	-- Parent Frame for currency
local noclickFrame = CreateFrame("Frame", addonname.."noclickFrame", MyHideFrame)
	--noclickFrame:RegisterEvent("PLAYER_LOGIN")
	noclickFrame:ClearAllPoints()
	noclickFrame:SetPoint("CENTER", MyShowHideButton, "CENTER", 170, 0)
	noclickFrame:SetWidth(232)
	noclickFrame:SetHeight(42)
	noclickFrame:Show()

	--Debugging Texture
local noclickFrameTexture=noclickFrame:CreateTexture(nil,"ARTWORK")
	noclickFrameTexture:SetAllPoints(noclickFrame)
	--noclickFrameTexture:SetColorTexture(0.3, 0.75, 0.1, 1)--Optional Color
	noclickFrameTexture:SetColorTexture(0.15, 0.15, 0.15, 0.7)

local itemsetcurrency = {
	[1] = 71083, --Darkmoon Game Token
	[2] = 124669, --Darkmoon Daggermaw
	[3] = 515,--Darkmoon Faire Ticket
}
local numcurrency = #itemsetcurrency

local function updatecurrency(itemID)
	local currencyIconFrame = _G[addonname..itemID.."currencyIconFrame"]
	if itemID == 515 then
		local itemName, currentAmount, itemTexture = GetCurrencyInfo(itemID)--Darkmoon Faire Ticket
		--print("prize ticket")
		if itemName then
			currencyIconFrame.currencyFS:SetFormattedText("%s: %.0f", itemName,currentAmount)
			currencyIconFrame.currencyFSTexture:SetTexture(itemTexture)
		end
	else
		local itemcount = GetItemCount(itemID, false, false)
		local itemcount_bank = GetItemCount(itemID, true, false)
		local itemName, _, _,_,_,_,_,_,_,itemTexture = GetItemInfo(itemID)
		if itemName then
			if itemcount == itemcount_bank then
				currencyIconFrame.currencyFS:SetFormattedText("%s: %.0f", itemName,itemcount)
			else
				currencyIconFrame.currencyFS:SetFormattedText("%s: %.0f(%.0f)", itemName, itemcount,itemcount_bank)
			end
			currencyIconFrame.currencyFSTexture:SetTexture(itemTexture)
		end
	end
	_G[addonname..itemID.."currencyIconFrame"] = currencyIconFrame
end

local function create_currency(itemID)
	local currencyIconFrame = CreateFrame("Frame", addonname..itemID.."currencyIconFrame", noclickFrame)
	currencyIconFrame:ClearAllPoints()
	if itemID == 515 then
		currencyIconFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		--currencyIconFrame:RegisterEvent("BAG_UPDATE_DELAYED");
		currencyIconFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
		currencyIconFrame:SetPoint("BOTTOMLEFT", noclickFrame, "BOTTOMLEFT", 0, 0)
	else
		--currencyIconFrame:RegisterEvent("PLAYER_LOGIN")
		currencyIconFrame:RegisterEvent("BAG_UPDATE_DELAYED");
		--currencyIconFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
		if itemID == 71083 then
			--print(itemID,"1")
			currencyIconFrame:SetPoint("TOPLEFT", noclickFrame, "TOPLEFT", 0, 0)
		else
			--print(itemID,"2")
			currencyIconFrame:SetPoint("LEFT", noclickFrame, "LEFT", 0, 0)
		end
	end
	currencyIconFrame:SetWidth(14)
	currencyIconFrame:SetHeight(14)
	currencyIconFrame:Show()
	currencyIconFrame.currencyFS = currencyIconFrame:CreateFontString("FontString","OVERLAY","GameTooltipText")
	currencyIconFrame.currencyFS:SetPoint("LEFT", currencyIconFrame, "RIGHT", -1, 1)
	currencyIconFrame.currencyFS:SetFont("Fonts\\FRIZQT__.TTF", 12)
	currencyIconFrame.currencyFS:SetFormattedText("")
	currencyIconFrame.currencyFS:SetShadowOffset(1, -1)
	currencyIconFrame.currencyFS:SetTextColor(1, 1, 1, 1);
	currencyIconFrame.currencyFS:Show()
	currencyIconFrame.currencyFSTexture=currencyIconFrame:CreateTexture(nil,"ARTWORK")
	currencyIconFrame.currencyFSTexture:SetAllPoints(currencyIconFrame)
	currencyIconFrame:SetScript("OnEvent", function(self, event, ...)
		updatecurrency(itemID)
		--[[
		local itemName, currentAmount, itemTexture = GetCurrencyInfo(itemID)--Darkmoon Faire Ticket
		print("prize ticket")
		if itemName then
			currencyFS:SetFormattedText("%s: %.0f", itemName,currentAmount)
			currencyFSTexture:SetTexture(itemTexture)
		end
		--]]
	end)
end
		
local info_received = 'GET_ITEM_INFO_RECEIVED'
local wait_curr = {}

local cache_writer_curr = CreateFrame('Frame')
cache_writer_curr:SetScript('OnEvent', function(self, event, ...)
	if event == info_received then
		-- the info is now downloaded and cached
		local itemID = ...
		if wait_curr[itemID] then
			--print(itemID,"received_currency")
			create_currency(itemID)
			wait_curr[itemID] = nil
			updatecurrency(itemID)
			--if wait == {} then updatebuttons();self:UnregisterEvent(event) end --test
			if wait_curr == {} then self:UnregisterEvent(event) end
		end
	end
end)
cache_writer_curr:RegisterEvent(info_received)
local function createcurrencyloop()
	for index = 1, numcurrency, 1 do
		local itemID = itemsetcurrency[index]
		local name 
		if itemID == 515 then
			name = GetCurrencyInfo(itemID)
		else
			name = GetItemInfo(itemID)
		end
		if name then
			create_currency(itemID)
		else
		--add item to wait list
			wait_curr[itemID] = {}
		end
	end
end
	
local function createonebutton(itemID)
	--local button = CreateFrame("Frame", "buttonframe"..itemID, MyInitFrame)
	local button = CreateFrame("Frame", "buttonframe"..itemID, MyHideFrame)
			--local index = #parent.beacons + 1 or 1
			
			button:SetSize(buttonSize, buttonSize);
			
			button.slot = CreateFrame("Button", "buttonslotframe"..itemID, button, "ContainerFrameItemButtonTemplate")
			
			--button.slot:RegisterForClicks("AnyDown")
			button.slot:RegisterForClicks("RightButtonDown")
			
			button.slot:SetSize(buttonSize, buttonSize)
			button.slot:SetPoint("CENTER")
			--if stage[itemID] then y = 0 else y = buttonSize + padding end
			--button:SetPoint("BOTTOMLEFT", MyInitFrame, (button_pad*which[itemID]), y)
			local name, _, _,_,_,_,_,_,_,texture,_ = GetItemInfo(itemID)
			button.slot.icon:SetTexture(texture)

			button.slot.Count = button.slot:CreateFontString("$parent_FontString","OVERLAY")
			button.slot.Count:SetPoint("BOTTOMRIGHT", button.slot)
			button.slot.Count:SetFont("Fonts\\FRIZQT__.TTF", 14, "THINOUTLINE")
			button.slot.Count:SetTextColor(1, 1, 1);
			
			button.slot.Count1 = button.slot:CreateFontString("$parent_FontString","OVERLAY")
			button.slot.Count1:SetPoint("TOPRIGHT", button.slot)
			button.slot.Count1:SetFont("Fonts\\FRIZQT__.TTF", 14, "THINOUTLINE")
			button.slot.Count1:SetTextColor(1, 1, 1);			
			
			button.slot:SetScript("OnDragStart", nil)
			button.slot:SetScript("OnLeave", GameTooltip_Hide)
			button.slot:Show()
			
			button.slot.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925);
			button.slot.BattlepayItemTexture:Hide()
		end	
		
		
		
--local info_received = 'GET_ITEM_INFO_RECEIVED'
local wait = {}

local cache_writer = CreateFrame('Frame')
cache_writer:SetScript('OnEvent', function(self, event, ...)
	if event == info_received then
		-- the info is now downloaded and cached
		local itemID = ...
		if wait[itemID] then
			--print(itemID,"received")
			createonebutton(itemID)
			wait[itemID] = nil
			if wait == {} then updatebuttons();self:UnregisterEvent(event) end --test
		end
	end
end)
cache_writer:RegisterEvent(info_received)
local function createButtons()
	for index = 1, numIte, 1 do
		local itemID = itemset[index]
		local name = GetItemInfo(itemID)
		if name then
			createonebutton(itemID)
		else
		--add item to wait list
			wait[itemID] = {}
		end
	end
end
		 
		MyInitFrame:SetPoint("BOTTOMLEFT", MyHideFrame, 2, buttonSize );
		local login_event = "PLAYER_LOGIN"
		MyInitFrame:RegisterEvent(login_event)
		MyInitFrame:SetScript("OnEvent", function(self, event, ...)
			if event == login_event then
				self:RegisterEvent("BAG_UPDATE_DELAYED")
				local where_stage = true
				for index = 1, numIte, 1 do
					local itemID = itemset[index]
					local name = GetItemInfo(itemID)
					stage[itemID] = where_stage
					where_stage = not where_stage
					which[itemID] = ceil(index/2)-1
				end
				local width = (buttonSize * 2) + padding
				local height = ceil(numIte / 2) * button_pad - padding
				self:SetSize(width, height)
				createButtons()
				createcurrencyloop()
				updatebuttons()
				return
			end
			updatebuttons()
			
		end)
