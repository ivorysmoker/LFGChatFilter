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
local close = CreateFrame("Button", "mainFrameCloseButton", mainFrame, "UIPanelCloseButton")
close:SetFrameLevel(3) 
close:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", 0, 2)
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

--ADD Descripions Tab to Frame...
local function CreateTableDescription(parentFrame, descriptionCol1)
	local tableDescriptionFrame = CreateFrame("Frame", "Descriptions", parentFrame)
	tableDescriptionFrame:SetFrameLevel(2) 
	tableDescriptionFrame:SetSize(windowX, 25)
	tableDescriptionFrame:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", 0, 0)
	tableDescriptionFrame:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeSize = 1,
	})
	tableDescriptionFrame:SetBackdropColor(25, 25, 25, .8)
	tableDescriptionFrame:SetBackdropBorderColor(0, 0, 0)

	local text1 = tableDescriptionFrame:CreateFontString("Description1", "ARTWORK", "GameFontHighlight")
	text1:SetPoint("TOPLEFT", tableDescriptionFrame, "TOPLEFT", 5, -5)
	text1:SetText(descriptionCol1)
	text1:SetTextColor(0, 0, 153, 1)

	local text2 = tableDescriptionFrame:CreateFontString("Description2", "ARTWORK", "GameFontHighlight")
	text2:SetPoint("TOPLEFT", tableDescriptionFrame, "TOPLEFT", 80, -5)
	text2:SetText("Time")
	text2:SetTextColor(0, 0, 153, 1)

	local text3 = tableDescriptionFrame:CreateFontString("Description3", "ARTWORK", "GameFontHighlight")
	text3:SetPoint("TOPLEFT", tableDescriptionFrame, "TOPLEFT", 140, -5)
	text3:SetText("Message")
	text3:SetTextColor(0, 0, 153, 1)
	
	local verticalLine = tableDescriptionFrame:CreateTexture(nil, "BACKGROUND")
	verticalLine:SetTexture(255, 255, 255, .8)
	verticalLine:SetSize(1, windowY - 1)
	verticalLine:SetPoint("TOPLEFT", tableDescriptionFrame, "TOPLEFT", 77, -1)
	
	local verticalLine2 = tableDescriptionFrame:CreateTexture(nil, "BACKGROUND")
	verticalLine2:SetTexture(255, 255, 255, .8)
	verticalLine2:SetSize(1, windowY - 1)
	verticalLine2:SetPoint("TOPLEFT", tableDescriptionFrame, "TOPLEFT", 135, -1)
	
	
	tableDescriptionFrame:EnableMouse(false)
end

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

-- Table Descriptions...
CreateTableDescription(f, "Whisper")

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

-- Table Descriptions...
CreateTableDescription(lfmFrame, "Invite")

-- (3) WTSFrame
local wtsFrame = CreateFrame("Frame", "LFMFrame", mainFrame)
wtsFrame:SetSize(windowX, windowY)
wtsFrame:SetPoint("TOPLEFT")
wtsFrame:SetBackdrop({
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeSize = 1,
})
wtsFrame:SetBackdropColor(0, 0, 0, .5)
wtsFrame:SetBackdropBorderColor(0, 0, 0)
wtsFrame:EnableMouse(false)
wtsFrame:SetMovable(false)
wtsFrame:Hide()

-- Table Descriptions...
CreateTableDescription(wtsFrame, "Seller")

-- (4) WTBFrame
local wtbFrame = CreateFrame("Frame", "LFMFrame", mainFrame)
wtbFrame:SetSize(windowX, windowY)
wtbFrame:SetPoint("TOPLEFT")
wtbFrame:SetBackdrop({
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeSize = 1,
})
wtbFrame:SetBackdropColor(0, 0, 0, .5)
wtbFrame:SetBackdropBorderColor(0, 0, 0)
wtbFrame:EnableMouse(false)
wtbFrame:SetMovable(false)
wtbFrame:Hide()

-- Table Descriptions...
CreateTableDescription(wtbFrame, "Buyer")

-- Menu Buttons
local mainBtn = CreateFrame("Button", "Main", mainFrame, "UIPanelButtonGrayTemplate")

mainBtn:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 0, 55)
mainBtn:RegisterForClicks("AnyDown")
mainBtn:SetScript("OnClick", function (self, button, down)
	lfmFrame:Hide()
	f:Hide()
	mainFramePanel:Show()
	wtsFrame:Hide()
	wtbFrame:Hide()
end)
mainBtn:SetSize(50, 50)
mainBtn:SetText("Main")

local lfgBtn = CreateFrame("Button", "LFMBtn", mainFrame, "UIPanelButtonGrayTemplate")
lfgBtn:SetPoint("TOPLEFT",f, "TOPLEFT", 55, 55)
lfgBtn:RegisterForClicks("AnyDown")
lfgBtn:SetScript("OnClick", function (self, button, down)
	lfmFrame:Hide()
	f:Show()
	mainFramePanel:Hide()
	wtsFrame:Hide()
	wtbFrame:Hide()
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
	wtsFrame:Hide()
	wtbFrame:Hide()
end)
lfmBtn:SetSize(50, 50)
lfmBtn:SetText("LFG")

local wtsBtn = CreateFrame("Button", "WTS", mainFrame, "UIPanelButtonGrayTemplate")
wtsBtn:SetPoint("TOPLEFT",f, "TOPLEFT", 165, 55)
wtsBtn:RegisterForClicks("AnyDown")
wtsBtn:SetScript("OnClick", function (self, button, down)
	f:Hide()
	lfmFrame:Hide()
	mainFramePanel:Hide()
	wtsFrame:Show()
	wtbFrame:Hide()
end)
wtsBtn:SetSize(50, 50)
wtsBtn:SetText("WTS")

local wtbBtn = CreateFrame("Button", "WTB", mainFrame, "UIPanelButtonGrayTemplate")
wtbBtn:SetPoint("TOPLEFT",f, "TOPLEFT", 220, 55)
wtbBtn:RegisterForClicks("AnyDown")
wtbBtn:SetScript("OnClick", function (self, button, down)
	f:Hide()
	lfmFrame:Hide()
	mainFramePanel:Hide()
	wtsFrame:Hide()
	wtbFrame:Show()
end)
wtbBtn:SetSize(50, 50)
wtbBtn:SetText("WTB")


--Init for Table Data Hold
tableArray = {
	[1] = { [1] = {}, [2] = {}, [3] = {}, [4] = {} },
	[2] = { [1] = {}, [2] = {}, [3] = {}, [4] = {} },
	[3] = { [1] = {}, [2] = {}, [3] = {}, [4] = {} },
	[4] = { [1] = {}, [2] = {}, [3] = {}, [4] = {} }
}

--	maybe implement this on tablearray on futur...
numOfCreatedFontsArr = {}
for i=1, 4 do
	numOfCreatedFontsArr[i] = 0
end

rowPaddingTopArr = {}
for i=1, 4 do
	rowPaddingTopArr[i] = 0
end


local startPositionY = -30

--A Better Version...
local function CreateNewTableRow(frame, msg, sender, id)
	
	local timestamp = time()
	
	if numOfCreatedFontsArr[id] > 0 then
		rowPaddingTopArr[id] = -15
		--rowPaddingTop = -15
	end
	
	local widget = frame:CreateFontString("Button", "ARTWORK", "GameFontHighlight")
	local timerWidget = frame:CreateFontString("Timer", "ARTWORK", "GameFontHighlight")
	
	local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	
	
	button:SetPoint("TOPLEFT",frame, "TOPLEFT", 5, startPositionY + (numOfCreatedFontsArr[id] * rowPaddingTopArr[id]))
	button:RegisterForClicks("AnyDown")
	button:SetScript("OnClick", function (self, btn, down)
		
		if id == 1 then
			InviteUnit(self:GetText()) 
		elseif id == 2 then
			if classSpecialisation == "" then
				print("Select the Class Specialisation at Main Window")
				return
			end
			SendChatMessage("Hi, do you need "..classSpecialisation.." "..className.." with "..LFG_Settings["gearscore"].." GS?", "WHISPER", "COMMON", self:GetText())
		elseif id == 3 then
			message("Not implemented")
		else
			message("Not implemented")
		end
	end)

	widget:SetPoint("TOPLEFT",frame, "TOPLEFT", 140, startPositionY + (numOfCreatedFontsArr[id] * rowPaddingTopArr[id]))
	
	--str = string.sub(msg, 0, 95)
	widget:SetText(msg)
	
	timerWidget:SetPoint("TOPLEFT",frame, "TOPLEFT", 80, startPositionY + (numOfCreatedFontsArr[id] * rowPaddingTopArr[id]))
	timerWidget:SetText(date("%H:%M:%S", timestamp))
	
	button:SetSize(70, 15)
	button:SetText(sender)
	
	--numOfCreatedFonts = numOfCreatedFonts + 1
	table.insert(tableArray[id][1], widget)
	table.insert(tableArray[id][2], button)
	table.insert(tableArray[id][3], timerWidget)
	table.insert(tableArray[id][4], time())

	numOfCreatedFontsArr[id] = numOfCreatedFontsArr[id] + 1
end


function UltimateSorterClearer()
	
	for i,_ in ipairs(tableArray) do
		id = i
	-- Sort and Clear LFM List
		for i, v in ipairs(tableArray[id][4]) do
			if v ~= nil then
				if v + (displayTimeInSeconds) < time() then
					
					tableArray[id][1][i]:SetText("")
					tableArray[id][3][i]:SetText("")
					tableArray[id][2][i]:SetText("")
					
					-- sort list
					local startIndex = i
					
					for index = startIndex, table.getn(tableArray[id][4]) do
						
						if index + 1 <= table.getn(tableArray[id][4]) then
						
							tableArray[id][1][index]:SetText(tableArray[id][1][index+1]:GetText())
							tableArray[id][3][index]:SetText(tableArray[id][3][index+1]:GetText())
							tableArray[id][2][index]:SetText(tableArray[id][2][index+1]:GetText())
							tableArray[id][4][index] = tableArray[id][4][index+1]
						end
						
						if index == table.getn(tableArray[id][4]) then
							tableArray[id][1][index]:SetText("")
							tableArray[id][3][index]:SetText("")
							tableArray[id][2][index]:SetText("")
							tableArray[id][4][index] = nil
						end
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

function strSplit (inputStr, seperator)
	if seperator == nil then
		seperator = "%s"
	end
	local t={}
	for str in string.gmatch(inputStr, "([^"..seperator.."]+)") do
		table.insert(t, str)
	end
	return t
end

-- RegisterEvents
local eventArray = { "CHAT_MSG_GUILD", "CHAT_MSG_OFFICER", "CHAT_MSG_BATTLEGROUND", "CHAT_MSG_BATTLEGROUND_LEADER", "CHAT_MSG_PARTY", "CHAT_MSG_RAID_LEADER", "CHAT_MSG_RAID", "CHAT_MSG_WHISPER", "CHAT_MSG_BN_WHISPER", "CHAT_MSG_CHANNEL", "CHAT_MSG_SAY", "ADDON_LOADED", "PLAYER_LOGIN" }
for i, v in ipairs(eventArray) do
	f:RegisterEvent(v)
end

-- PatternList's
local PatternListLFMFrame = { "^LFM.*$", "^Lfm.*$", "^lfm.*$", "^LFm.*$", "^LF%s.*$", "^Lf%s.*$", "^lf%s.*$" }
local PatternListLFGFrame = { "^LFG.*$", "^Lfg.*$", "^lfg.*$", "^LFg.*$" }
local PatternListWTS = { "^WTS.*$", "^Wts.*$", "^wts.*$", "^wTs.*$", "^wTS.*$", "^WTs.*$", "^WtS.*$"  }
local PatternListWTB = { "^WTB.*$", "^Wtb.*$", "^wtb.*$", "^wTb.*$", "^wTB.*$", "^WTb.*$", "^WtB.*$" }

-- Instances Pattern
local PatternListInstances = { }
PatternListInstances.ICC = "^.*ICC.*$|^.*icc.*$|^.*Icecrown Citadel.*$"
PatternListInstances.TOC = "^.*TOC.*$|^.*toc.*$|^.*Trial of the Crusader.*$"
PatternListInstances.VOA = "^.*VOA.*$|^.*voa.*$|^.*Vault of Archavon.*$"
PatternListInstances.RS = "^.*RS.*$|^.*rs.*$|^.*Ruby Sanctum.*$"

--message(strSplit(PatternListInstances["ICC"], "|")[2]) begins on 1 (0 maybe the whole?)

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
		
		--MySlider:SetValue(LFG_Settings["gearscore"])
		getglobal(MySlider:GetName() .. 'Text'):SetText(LFG_Settings["gearscore"]);
		return
	end
	
	UltimateSorterClearer()
	
	for i, v in ipairs(eventArray) do
		if v == event then
			
			for i, pattern in ipairs(PatternListLFGFrame) do
				if string.find(msg, pattern) then
					local IsInList = false
					local emptySlot = false
					for i, v in ipairs(tableArray[1][1]) do
						
						if isempty(v:GetText()) then
								emptySlot = true
								tableArray[1][1][i]:SetText(msg)
								tableArray[1][4][i] = time()
								tableArray[1][3][i]:SetText(date("%H:%M:%S", time()))
								tableArray[1][2][i]:SetText(sender)
							break
						end
						
						if v:GetText() == msg then
							IsInList = true
							tableArray[1][3][i]:SetText(date("%H:%M:%S", time()))
							break
						end
					end
					
					if not emptySlot then
						if not IsInList then
							CreateNewTableRow(lfmFrame, msg, sender, 1)
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
					for i, v in ipairs(tableArray[2][1]) do
						if isempty(v:GetText()) then
								emptySlot = true
								tableArray[2][1][i]:SetText(msg)
								tableArray[2][4][i] = time()
								tableArray[2][3][i]:SetText(date("%H:%M:%S", time()))
								tableArray[2][2][i]:SetText(sender)
							break
						end
					
						if v:GetText() == msg then
							IsInList = true
							tableArray[2][3][i]:SetText(date("%H:%M:%S", time()))
							break
						end
					end
					
					if not emptySlot then
						if not IsInList then
							CreateNewTableRow(f, msg, sender, 2)
						end
					else
						
					end
					
					break
				end
			end
			--Find WTS
			for i, pattern in ipairs(PatternListWTS) do
				if string.find(msg, pattern) then
					local IsInList = false
					local emptySlot = false
					for i, v in ipairs(tableArray[3][1]) do
						
						if isempty(v:GetText()) then
								emptySlot = true
								tableArray[3][1][i]:SetText(msg)
								tableArray[3][4][i] = time()
								tableArray[3][3][i]:SetText(date("%H:%M:%S", time()))
								tableArray[3][2][i]:SetText(sender)
							break
						end
						
						if v:GetText() == msg then
							IsInList = true
							tableArray[3][3][i]:SetText(date("%H:%M:%S", time()))
							break
						end
					end
					
					if not emptySlot then
						if not IsInList then
							CreateNewTableRow(wtsFrame, msg, sender, 3)
						end
					end
					break
				end
			end
			--Find WTS
			for i, pattern in ipairs(PatternListWTB) do
				if string.find(msg, pattern) then
					local IsInList = false
					local emptySlot = false
					for i, v in ipairs(tableArray[4][1]) do
						
						if isempty(v:GetText()) then
								emptySlot = true
								tableArray[4][1][i]:SetText(msg)
								tableArray[4][4][i] = time()
								tableArray[4][3][i]:SetText(date("%H:%M:%S", time()))
								tableArray[4][2][i]:SetText(sender)
							break
						end
						
						if v:GetText() == msg then
							IsInList = true
							tableArray[4][3][i]:SetText(date("%H:%M:%S", time()))
							break
						end
					end
					
					if not emptySlot then
						if not IsInList then
							CreateNewTableRow(wtbFrame, msg, sender, 4)
						end
					end
					break
				end
			end
			
		end
	end
end

-- Register Eventhandler
f:SetScript("OnEvent", eventHandler)