-- Add LFM Tool for Leader to Form Easy Groups...
local mainFrameChild = CreateFrame("Frame", "MainFrameChild", MainFrame)
mainFrameChild:SetSize(200, 400)
mainFrameChild:SetPoint("TOPLEFT", MainFrame, "TOPLEFT", -200, 0)
mainFrameChild:SetBackdrop({
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeSize = 1,
})
mainFrameChild:SetBackdropColor(0, 0, 0, .5)
mainFrameChild:SetBackdropBorderColor(0, 0, 0)
local close = CreateFrame("Button", "mainFrameCloseButton", mainFrameChild, "UIPanelCloseButton")
close:SetFrameLevel(3) 
close:SetPoint("TOPRIGHT", mainFrameChild, "TOPRIGHT", 0, 2)
close:SetScript("OnClick", function()
	mainFrameChild:Hide()
end)

LFMBtn:HookScript("OnClick", function (self, button, down)
	mainFrameChild:Show()
end)

local font1 = mainFrameChild:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
font1:SetPoint("TOPLEFT", mainFrameChild, "TOPLEFT", 2, -2)
font1:SetText("Group Leader Options")

local font2 = mainFrameChild:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
font2:SetPoint("TOPLEFT", mainFrameChild, "TOPLEFT", 2, -30)
font2:SetText("Select Raid Instance")

local font3 = mainFrameChild:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
font3:SetPoint("TOPLEFT", mainFrameChild, "TOPLEFT", 2, -80)
font3:SetText("Select Raid Size")

local font3 = mainFrameChild:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
font3:SetPoint("TOPLEFT", mainFrameChild, "TOPLEFT", 2, -130)
font3:SetText("Which roles do you need?")

local font4 = mainFrameChild:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
font4:SetPoint("TOPLEFT", mainFrameChild, "TOPLEFT", 2, -230)
font4:SetText("Reserved Settings")

local font5 = mainFrameChild:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
font5:SetPoint("TOPLEFT", mainFrameChild, "TOPLEFT", 2, -310)
font5:SetText("Instance Difficulty")

-- Group (1)
local SearchedSpecialisiation = {}
SearchedSpecialisiation.Tank = false
SearchedSpecialisiation.Damage = false
SearchedSpecialisiation.Heal = false

local LootRules = {}
LootRules.BOE = false
LootRules.P = false

local InstanceDifficulty = {}
InstanceDifficulty.N = true
InstanceDifficulty.HC = false

local checkbox1 = CreateFrame("CheckButton", "checkbox1", mainFrameChild, "ChatConfigCheckButtonTemplate")
checkbox1:SetWidth(25)
checkbox1:SetPoint("TOPLEFT", mainFrameChild, "TOPLEFT", 5, -150)
getglobal(checkbox1:GetName() .. 'Text'):SetText("Tank")
checkbox1:SetText("Tank")
checkbox1:SetScript("OnClick",  function() 
	if SearchedSpecialisiation.Tank then
		SearchedSpecialisiation.Tank = false
	else
		SearchedSpecialisiation.Tank = true
	end
end)

local checkbox2 = CreateFrame("CheckButton", "checkbox2", mainFrameChild, "ChatConfigCheckButtonTemplate")
checkbox2:SetWidth(25)
checkbox2:SetPoint("TOPLEFT", mainFrameChild, "TOPLEFT", 5, -175)
getglobal(checkbox2:GetName() .. 'Text'):SetText("Damage")
checkbox2:SetText("Damage")
checkbox2:SetScript("OnClick",  function() 
	if SearchedSpecialisiation.Damage then
		SearchedSpecialisiation.Damage = false
	else
		SearchedSpecialisiation.Damage = true
	end
end)

local checkbox3 = CreateFrame("CheckButton", "checkbox3", mainFrameChild, "ChatConfigCheckButtonTemplate")
checkbox3:SetWidth(25)
checkbox3:SetPoint("TOPLEFT", mainFrameChild, "TOPLEFT", 5, -200)
getglobal(checkbox3:GetName() .. 'Text'):SetText("Heal")
checkbox3:SetText("Heal")
checkbox3:SetScript("OnClick",  function() 
	if SearchedSpecialisiation.Heal then
		SearchedSpecialisiation.Heal = false
	else
		SearchedSpecialisiation.Heal = true
	end
end)

-- Group (2)
local checkbox4 = CreateFrame("CheckButton", "checkbox4", mainFrameChild, "ChatConfigCheckButtonTemplate")
checkbox4:SetWidth(25)
checkbox4:SetPoint("TOPLEFT", mainFrameChild, "TOPLEFT", 5, -250)
getglobal(checkbox4:GetName() .. 'Text'):SetText("Primordials")
checkbox4:SetText("Primordials")
checkbox4:SetScript("OnClick",  function()
	if LootRules.P then
		LootRules.P = false
	else
		LootRules.P = true
	end
end)

local checkbox5 = CreateFrame("CheckButton", "checkbox5", mainFrameChild, "ChatConfigCheckButtonTemplate")
checkbox5:SetWidth(25)
checkbox5:SetPoint("TOPLEFT", mainFrameChild, "TOPLEFT", 5, -275)
getglobal(checkbox5:GetName() .. 'Text'):SetText("BOE")
checkbox5:SetText("BOE")
checkbox5:SetScript("OnClick",  function() 
	if LootRules.BOE then
		LootRules.BOE = false
	else
		LootRules.BOE = true
	end
end)

-- Group (3)

local checkboxNorm = CreateFrame("CheckButton", "checkbox6", mainFrameChild, "ChatConfigCheckButtonTemplate")
local checkboxHC = CreateFrame("CheckButton", "checkbox7", mainFrameChild, "ChatConfigCheckButtonTemplate")

checkboxNorm:SetWidth(25)
checkboxNorm:SetPoint("TOPLEFT", mainFrameChild, "TOPLEFT", 5, -330)
getglobal(checkbox6:GetName() .. 'Text'):SetText("Normal")
checkboxNorm:SetText("Normal")
checkboxNorm:SetChecked(true)
checkboxNorm:SetScript("OnClick",  function()
	
	if not checkbox6:GetChecked() then
		InstanceDifficulty.N = true
		InstanceDifficulty.HC = false
		checkbox6:SetChecked(true)
		checkbox7:SetChecked(false)
	end

	if checkbox7:GetChecked() then
		checkbox7:SetChecked(false)
	end
end)

checkboxHC:SetWidth(25)
checkboxHC:SetPoint("TOPLEFT", mainFrameChild, "TOPLEFT", 5, -355)
getglobal(checkbox7:GetName() .. 'Text'):SetText("HC")
checkboxHC:SetText("HC")
checkboxHC:SetScript("OnClick",  function() 
	if not checkbox7:GetChecked() then
		InstanceDifficulty.HC = true
		InstanceDifficulty.N = false
		checkbox6:SetChecked(false)
		checkbox7:SetChecked(true)
	end
	
	if checkbox6:GetChecked() then
		checkbox6:SetChecked(false)
	end
	
end)

local raidsArray = {"Icecrown Citatel", "Trial of the Crusader", "Naxxramas", "The Ruby Sanctum", "Vault of Archavon"}
local selectedInstance = "Icecrown Citatel" -- A user-configurable setting
 -- Create the dropdown, and configure its appearance
 local dropDown = CreateFrame("FRAME", "WPDemoDropDown", mainFrameChild, "UIDropDownMenuTemplate")
 dropDown:SetPoint("TOPLEFT", mainFrameChild, "TOPLEFT", 0, -45)
 UIDropDownMenu_SetWidth(dropDown, 160)
 UIDropDownMenu_SetText(dropDown, selectedInstance)
 
 -- Create and bind the initialization function to the dropdown menu
 UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
local info = UIDropDownMenu_CreateInfo()
	if (level or 1) == 1 then
	   for i = 0,table.getn(raidsArray) - 1 do
			info.checked = false
			info.menuList = i
			info.hasArrow = false
			info.func = self.SetValue
			info.text, info.arg1, info.checked = raidsArray[i+1], raidsArray[i+1], false == selectedInstance
			UIDropDownMenu_AddButton(info)
	   end
	 end
 end)

 function dropDown:SetValue(newValue)
  selectedInstance = newValue
  UIDropDownMenu_SetText(dropDown, selectedInstance)
  CloseDropDownMenus()
 end
 
 local groupSizes = {"5", "10", "25"}
local selectedGroupSize = "10" -- A user-configurable setting
 
 local dropDown2 = CreateFrame("FRAME", "DropDownGroupSize", mainFrameChild, "UIDropDownMenuTemplate")
 dropDown2:SetPoint("TOPLEFT", mainFrameChild, "TOPLEFT", 0, -95)
 UIDropDownMenu_SetWidth(dropDown2, 160)
 UIDropDownMenu_SetText(dropDown2, selectedGroupSize)
 UIDropDownMenu_Initialize(dropDown2, function(self, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
		if (level or 1) == 1 then
		   for i = 0,table.getn(groupSizes) - 1 do
				info.checked = false
				info.menuList = i
				info.hasArrow = false
				info.func = self.SetValue
				info.text, info.arg1, info.checked = groupSizes[i+1], groupSizes[i+1], false == selectedGroupSize
				UIDropDownMenu_AddButton(info)
		   end
		end
 end)
 
 function dropDown2:SetValue(newValue)
  selectedGroupSize = newValue
  UIDropDownMenu_SetText(dropDown2, selectedGroupSize)
  CloseDropDownMenus()
 end

local button = CreateFrame("Button", nil, mainFrameChild, "UIPanelButtonTemplate")
button:SetPoint("CENTER", mainFrameChild, "BOTTOM", 0, 15)
button:RegisterForClicks("AnyDown")
button:SetScript("OnClick", function (self, btn, down)
	
	if not SearchedSpecialisiation.Tank and not SearchedSpecialisiation.Damage and not SearchedSpecialisiation.Heal then
		print("Select roles")
		return
	end

	local channelCount = GetNumDisplayChannels();
	local LootRulesString = "Reserved: "
	if LootRules.BOE then
		LootRulesString = LootRulesString.."BOE, "
	end
	
	if LootRules.P then
		LootRulesString = LootRulesString.."Primortials"
	end
	
	local selectedDifficulty = ""
	if InstanceDifficulty.HC then
		selectedDifficulty = "HC"
	elseif InstanceDifficulty.N then
		selectedDifficulty = "N"
	end
	
	
	if SearchedSpecialisiation.Tank and not SearchedSpecialisiation.Damage and not SearchedSpecialisiation.Heal then
		for i=1, channelCount do 
			local id, name = GetChannelName(i);
			if id ~= 0 then
				SendChatMessage("LFM  "..selectedInstance.." "..selectedGroupSize.." "..selectedDifficulty.." "..LootRulesString.." Needed: Tank and Go!", "CHANNEL", "COMMON", i)
			end
		end
	end
	
	if SearchedSpecialisiation.Tank and SearchedSpecialisiation.Damage and not SearchedSpecialisiation.Heal then
		for i=1, channelCount do 
			local id, name = GetChannelName(i);
			if id ~= 0 then
				SendChatMessage("LFM  "..selectedInstance.." "..selectedGroupSize.." "..selectedDifficulty.." "..LootRulesString.." Needed: Tank, DPS and Go!", "CHANNEL", "COMMON", i)
			end
		end
	end
	
	if SearchedSpecialisiation.Tank and SearchedSpecialisiation.Damage and SearchedSpecialisiation.Heal then
		for i=1, channelCount do 
			local id, name = GetChannelName(i);
			if id ~= 0 then
				SendChatMessage("LFM  "..selectedInstance.." "..selectedGroupSize.." "..selectedDifficulty.." "..LootRulesString.." Needed: Tank, Heal, DPS !", "CHANNEL", "COMMON", i)
			end
		end
	end
	
	if not SearchedSpecialisiation.Tank and not SearchedSpecialisiation.Damage and SearchedSpecialisiation.Heal then
		for i=1, channelCount do 
			local id, name = GetChannelName(i);
			if id ~= 0 then
				SendChatMessage("LFM  "..selectedInstance.." "..selectedGroupSize.." "..selectedDifficulty.." "..LootRulesString.." Needed: Heal and Go!", "CHANNEL", "COMMON", i)
			end
		end
	end
	
	if not SearchedSpecialisiation.Tank and SearchedSpecialisiation.Damage and SearchedSpecialisiation.Heal then
		for i=1, channelCount do 
			local id, name = GetChannelName(i);
			if id ~= 0 then
				SendChatMessage("LFM  "..selectedInstance.." "..selectedGroupSize.." "..selectedDifficulty.." "..LootRulesString.." Needed: Heal, DPS and Go!", "CHANNEL", "COMMON", i)
			end
		end
	end
	
end)
button:SetSize(140, 20)
button:SetText("Search Members")

mainFrameChild:Show()