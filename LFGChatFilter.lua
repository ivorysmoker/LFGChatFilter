-- SavedVariables
LFG_Settings = {}
-- Copy of SaveVars - 
LFG_Settings_Default = {}

-- If the User repeat hes LFM/LFG Message the Timer would felt up
local displayTimeInSeconds = 60

-- (Window Resolution Settings)
local windowX = 800
local windowY = 400

-- (Used for SavedVariables LFG_Settings)
local localizedClass, englishClass, classIndex  = UnitClass("player")
local classGearScore = 0
local className = localizedClass
local classSpecialisation = ""

-- MainFrame
local mainFrame = CreateFrame("Frame", "MainFrame", UIParent)
mainFrame:SetSize(windowX, windowY)
mainFrame:SetPoint("CENTER")
mainFrame:SetBackdrop({
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeSize = 1,
})
mainFrame:SetBackdropColor(0, 0, 0, .5)
mainFrame:SetBackdropBorderColor(0, 0, 0)
mainFrame:EnableMouse(true)
mainFrame:SetMovable(true)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)
mainFrame:SetScript("OnHide", mainFrame.StopMovingOrSizing)
local close = CreateFrame("Button", "YourCloseButtonName", mainFrame, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT")
close:SetScript("OnClick", function()
	mainFrame:Hide()
end)

-- Checkbox (classSelection)
local mainFramePanel = CreateFrame("Frame", "MainFramePanel", mainFrame)
mainFramePanel:SetSize(windowX, windowY)
mainFramePanel:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 0, 0)

local selectionFont = mainFramePanel:CreateFontString(mainFramePanel, "ARTWORK", "GameFontHighlight")
selectionFont:SetFont("Fonts\\FRIZQT__.TTF", 16, "MONOCHROME")
selectionFont:SetPoint("TOPLEFT", mainFramePanel, "TOPLEFT", 5, -5)
selectionFont:SetText("Select your class Specialisation")

local tankSelectionBox = CreateFrame("CheckButton", "tankSelectionBox", mainFramePanel, "ChatConfigCheckButtonTemplate")
tankSelectionBox:SetWidth(50)
tankSelectionBox:SetHeight(50)
tankSelectionBox:SetPoint("TOPLEFT", mainFramePanel, "TOPLEFT", 5, -40)
getglobal(tankSelectionBox:GetName() .. 'Text'):SetText("Tank")
tankSelectionBox:SetScript("OnClick",  function()
	classSpecialisation = "Tank"
  end
);

local damageSelectionBox = CreateFrame("CheckButton", "damageSelectionBox", mainFramePanel, "ChatConfigCheckButtonTemplate");
damageSelectionBox:SetWidth(50);
damageSelectionBox:SetHeight(50);
damageSelectionBox:SetPoint("TOPLEFT", mainFramePanel, "TOPLEFT", 5, -120);
getglobal(damageSelectionBox:GetName() .. 'Text'):SetText("Damage");
damageSelectionBox:SetScript("OnClick", function()
	classSpecialisation = "Damage"
  end
);

local healSelectionBox = CreateFrame("CheckButton", "healSelectionBox", mainFramePanel, "ChatConfigCheckButtonTemplate");
healSelectionBox:SetWidth(50);
healSelectionBox:SetHeight(50);
healSelectionBox:SetPoint("TOPLEFT", mainFramePanel, "TOPLEFT", 5, -200);
getglobal(healSelectionBox:GetName() .. 'Text'):SetText("Heal");
healSelectionBox:SetScript("OnClick", function()
	classSpecialisation = "Heal"
  end
);

--Inferface
local panel = CreateFrame("FRAME")
panel.name = "LFGChatFilter"
InterfaceOptions_AddCategory(panel)

local panelBtn = CreateFrame("Button", "Open", panel, "UIPanelButtonTemplate")
panelBtn:SetPoint("TOPLEFT", panel, "TOPLEFT", 10, -20)
panelBtn:RegisterForClicks("AnyDown")
panelBtn:SetScript("OnClick", function (self, button, down)
	mainFrame:Show()
end)
panelBtn:SetSize(150, 35)
panelBtn:SetText("Show - LFGChatFilter")

local MySlider = CreateFrame("Slider", "MySliderGlobalName", panel, "OptionsSliderTemplate")
MySlider:SetWidth(100)
MySlider:SetOrientation('HORIZONTAL')
MySlider:SetPoint("TOPLEFT", panel, "TOPLEFT", 10, -70)
MySlider:SetMinMaxValues(1, 7000)
--MySlider:SetValue(1) -- SavedVariables Handle this onload...
MySlider:SetValueStep(1)
MySlider:SetScript("OnMouseDown", function(self, button)
	LFG_Settings.gearscore = MySlider:GetValue()
	getglobal(MySlider:GetName() .. 'Text'):SetText(LFG_Settings.gearscore);
end)

MySlider.tooltipText = 'Set Gearscore'
getglobal(MySlider:GetName() .. 'Text'):SetFontObject('GameFontNormalLeft')
getglobal(MySlider:GetName() .. 'Low'):SetText('1');
getglobal(MySlider:GetName() .. 'High'):SetText('7000')
MySlider:Show()

-- (1) LFGFrame
local f = CreateFrame("Frame", "LFGFrame", mainFrame)
f:SetSize(windowX, windowY)
f:SetPoint("TOPLEFT")
f:SetBackdrop({
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeSize = 1,
})
f:SetBackdropColor(0, 0, 0, .5)
f:SetBackdropBorderColor(0, 0, 0)
f:EnableMouse(false)
f:SetMovable(false)
f:Hide()

-- (2) LFMFrame
local lfmFrame = CreateFrame("Frame", "LFMFrame", mainFrame)
lfmFrame:SetSize(windowX, windowY)
lfmFrame:SetPoint("TOPLEFT")
lfmFrame:SetBackdrop({
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeSize = 1,
})
lfmFrame:SetBackdropColor(0, 0, 0, .5)
lfmFrame:SetBackdropBorderColor(0, 0, 0)
lfmFrame:EnableMouse(false)
lfmFrame:SetMovable(false)
lfmFrame:Hide()

-- Menu Buttons
local mainBtn = CreateFrame("Button", "Main", mainFrame, "UIPanelButtonGrayTemplate")

mainBtn:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 0, 55)
mainBtn:RegisterForClicks("AnyDown")
mainBtn:SetScript("OnClick", function (self, button, down)
	lfmFrame:Hide()
	f:Hide()
	mainFramePanel:Show()
end)
mainBtn:SetSize(50, 50)
mainBtn:SetText("Main")

local lfgBtn = CreateFrame("Button", "LFM", mainFrame, "UIPanelButtonGrayTemplate")
lfgBtn:SetPoint("TOPLEFT",f, "TOPLEFT", 55, 55)
lfgBtn:RegisterForClicks("AnyDown")
lfgBtn:SetScript("OnClick", function (self, button, down)
	lfmFrame:Hide()
	f:Show()
	mainFramePanel:Hide()
end)
lfgBtn:SetSize(50, 50)
lfgBtn:SetText("LFM")

local lfmBtn = CreateFrame("Button", "LFG", mainFrame, "UIPanelButtonGrayTemplate")
lfmBtn:SetPoint("TOPLEFT",f, "TOPLEFT", 110, 55)
lfmBtn:RegisterForClicks("AnyDown")
lfmBtn:SetScript("OnClick", function (self, button, down)
	f:Hide()
	lfmFrame:Show()
	mainFramePanel:Hide()
end)
lfmBtn:SetSize(50, 50)
lfmBtn:SetText("LFG")

-- Fonts / Buttons
list = {}
lfmList = {}

timerLFGWidget = {}
timerLFMWidget = {}
timerLFGList = {}
timerLFMList = {}
LFGButtonList = {}
LFMButtonList = {}

local numOfCreatedFonts = 0
local paddingTop = 0

local numOfCreatedFonts2 = 0
local paddingTop2 = 0

local function CreateNewFont(frame, msg, sender)
	
	local timestamp = time()
	if frame == lfmFrame then
	
		if numOfCreatedFonts > 0 then
			paddingTop = -15
		end
		
		local widget = frame:CreateFontString("Button", "ARTWORK", "GameFontHighlight")
		local timerWidget = frame:CreateFontString("Timer", "ARTWORK", "GameFontHighlight")
		
		local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
		
		
		button:SetPoint("TOPLEFT",frame, "TOPLEFT", 5, numOfCreatedFonts * paddingTop)
		button:RegisterForClicks("AnyDown")
		button:SetScript("OnClick", function (self, btn, down)
			InviteUnit(self:GetText()) 
		end)

		widget:SetPoint("TOPLEFT",frame, "TOPLEFT", 140, numOfCreatedFonts * paddingTop)
		
		--str = string.sub(msg, 0, 95)
		widget:SetText(msg)
		
		timerWidget:SetPoint("TOPLEFT",frame, "TOPLEFT", 80, numOfCreatedFonts * paddingTop)
		timerWidget:SetText(date("%H:%M:%S", timestamp))
		
		button:SetSize(70, 15)
		button:SetText(sender)
		
		numOfCreatedFonts = numOfCreatedFonts + 1
		
		table.insert(LFGButtonList, button)
		
		table.insert(list, widget)
		
		table.insert(timerLFGWidget, timerWidget)
		table.insert(timerLFGList, time())
	else
		if numOfCreatedFonts2 > 0 then
			paddingTop2 = -15
		end
		
		local timerWidget = frame:CreateFontString("Button", "ARTWORK", "GameFontHighlight")
		local widget = frame:CreateFontString("Button", "ARTWORK", "GameFontHighlight")
		local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
		
		
		button:SetPoint("TOPLEFT",frame, "TOPLEFT", 5, numOfCreatedFonts2 * paddingTop2)
		button:RegisterForClicks("AnyDown")
		button:SetScript("OnClick", function (self, btn, down)
			if classSpecialisation == "" then
				print("Select the Class Specialisation at Main Window")
				return
			end
			SendChatMessage("Hi, do you need "..classSpecialisation.." "..className.." with "..LFG_Settings["gearscore"].." GS?", "WHISPER", "COMMON", self:GetText())
		end)

		widget:SetPoint("TOPLEFT",frame, "TOPLEFT", 140, numOfCreatedFonts2 * paddingTop2)
		widget:SetText(msg)
		
		timerWidget:SetPoint("TOPLEFT",frame, "TOPLEFT", 80, numOfCreatedFonts2 * paddingTop2)
		timerWidget:SetText(date("%H:%M:%S", timestamp))
		
		button:SetSize(70, 15)
		button:SetText(sender)
		
		numOfCreatedFonts2 = numOfCreatedFonts2 + 1
		
		table.insert(LFMButtonList, button)
			
		table.insert(lfmList, widget)
		
		table.insert(timerLFMWidget, timerWidget)
		table.insert(timerLFMList, time())
	end
end

function UltimateSorterClearer()
	
	for i, v in ipairs(timerLFMList) do
	
		if v ~= nil then
			if v + (displayTimeInSeconds) < time() then
				
				lfmList[i]:SetText("")
				timerLFMWidget[i]:SetText("")
				LFMButtonList[i]:SetText("")
				
				-- sort list
				local startIndex = i
				for index = startIndex, table.getn(timerLFMList) do
					
					if index + 1 <= table.getn(timerLFMList) then
					
						lfmList[index]:SetText(lfmList[index+1]:GetText())
						timerLFMWidget[index]:SetText(timerLFMWidget[index+1]:GetText())
						LFMButtonList[index]:SetText(LFMButtonList[index+1]:GetText())
						timerLFMList[index] = timerLFMList[index+1]
					end
					
					if index == table.getn(timerLFMList) then
						lfmList[index]:SetText("")
						timerLFMWidget[index]:SetText("")
						LFMButtonList[index]:SetText("")
						timerLFMList[index] = nil
					end
				end
				
			end
		end
	end
	
	
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local function isempty(s)
  return s == nil or s == ''
end

-- RegisterEvents
local eventArray = { "CHAT_MSG_GUILD", "CHAT_MSG_OFFICER", "CHAT_MSG_BATTLEGROUND", "CHAT_MSG_BATTLEGROUND_LEADER", "CHAT_MSG_PARTY", "CHAT_MSG_RAID_LEADER", "CHAT_MSG_RAID", "CHAT_MSG_WHISPER", "CHAT_MSG_BN_WHISPER", "CHAT_MSG_CHANNEL", "CHAT_MSG_SAY", "ADDON_LOADED", "PLAYER_LOGIN" }
for i, v in ipairs(eventArray) do
	f:RegisterEvent(v)
end

-- PatternList's
local PatternListLFMFrame = { "^LFM.*$", "^Lfm.*$", "^lfm.*$", "^LFm.*$", "^LF%s.*$", "^Lf%s.*$", "^lf%s.*$" }
local PatternListLFGFrame = { "^LFG.*$", "^Lfg.*$", "^lfg.*$", "^LFg.*$" }

-- Eventhandler 
local function eventHandler(self, event, msg, sender, _, chanString, _, _, _, chanNumber, chanName)

	if event == "PLAYER_LOGIN"  then
		if not LFG_Settings then
			LFG_Settings.gearscore = 500
		end
		
		return
	end
	if event == "ADDON_LOADED" then
		for i, v in pairs(LFG_Settings) do 
			if ( LFG_Settings[i] ) then LFG_Settings_Default[i] = LFG_Settings[i]; end
		end
		
		MySlider:SetValue(LFG_Settings["gearscore"])
		getglobal(MySlider:GetName() .. 'Text'):SetText(LFG_Settings["gearscore"]);
		return
	end
	
	UltimateSorterClearer()
	for i, v in ipairs(eventArray) do
		if v == event then
			
			for i, pattern in ipairs(PatternListLFGFrame) do
				if string.find(msg, pattern) then
					local IsInList = false
					for i, v in ipairs(list) do
						
						if isempty(v:GetText()) then
								emptySlot = true
								list[i]:SetText(msg)
								timerLFGWidget[i]:SetText(date("%H:%M:%S", time()))
								timerLFGList[i] = time()
								LFGButtonList[i]:SetText(sender)
							break
						end
						
						if v:GetText() == msg then
							IsInList = true
							timerLFGWidget[i]:SetText(date("%H:%M:%S", time()))
							break
						end
					end
					
					if not emptySlot then
						if not IsInList then
							CreateNewFont(lfmFrame, msg, sender)
						end
					end
					break
				end
			end
			--Find LFM
			
			for i, pattern in ipairs(PatternListLFMFrame) do
				if string.find(msg, pattern) then
					--Is in List?
					
					local IsInList = false
					local emptySlot = false
					for i, v in ipairs(lfmList) do
						if isempty(v:GetText()) then
								emptySlot = true
								lfmList[i]:SetText(msg)
								timerLFMList[i] = time()
								timerLFMWidget[i]:SetText(date("%H:%M:%S", time()))
								LFMButtonList[i]:SetText(sender)
							break
						end
					
						if v:GetText() == msg then
							IsInList = true
							timerLFMWidget[i]:SetText(date("%H:%M:%S", time()))
							break
						end
					end
					
					if not emptySlot then
						if not IsInList then
							CreateNewFont(f, msg, sender)
						end
					else
						
					end
					
					break
				end
			end
		end
	end
end

-- Register Eventhandler
f:SetScript("OnEvent", eventHandler)