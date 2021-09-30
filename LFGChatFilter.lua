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
local playerName, realm = UnitName("player")
local classGearScore = 0
local className = localizedClass
local classSpecialisation = ""

-- (Table Settings)
local maxTextLengthBox = 80

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

local MySlider = CreateFrame("Slider", "LFGChatFilter_InterfaceSlider", panel, "OptionsSliderTemplate")
MySlider:SetWidth(200)
MySlider:SetOrientation('HORIZONTAL')
MySlider:SetPoint("TOPLEFT", panel, "TOPLEFT", 10, -70)
MySlider:SetMinMaxValues(1, 7000)
--MySlider:SetValue(1) -- SavedVariables Handle this onload...
MySlider:SetValueStep(1)

local IsMySliderOnMove = false
MySlider:SetScript("OnUpdate", function(self, elapsed)
	if IsMySliderOnMove then
		LFG_Settings.gearscore = MySlider:GetValue()
		getglobal(MySlider:GetName() .. 'Text'):SetText(LFG_Settings.gearscore);
	end
end)

MySlider:SetScript("OnMouseDown", function(self, elapsed)
	IsMySliderOnMove = true
end)
MySlider:SetScript("OnMouseUp", function(self, elapsed)
	IsMySliderOnMove = false
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


--Build String with Valide Format
local function NewLineStrinBuilder(incMessage, maxTextLength)

	local msg = incMessage
	local maxTextWidth = maxTextLength
	local index = 0
	local strBuilder = {}
	local newString = ""
	if string.len(msg) > maxTextWidth then
		while(index < string.len(msg)) do
			if string.len(msg) - index < maxTextWidth then
				local subStr = string.sub(msg, index, string.len(msg));
				--print("EndSubStr: "..subStr)
				table.insert(strBuilder, subStr)
				break
			end
		
			if string.len(msg) - index >= maxTextWidth then
				local subStr = string.sub(msg, index, index + maxTextWidth);
				--print("SubStr: "..subStr)
				table.insert(strBuilder, subStr.."|n")
			end
			
			index = index + maxTextWidth
		end
--
		for i, v in ipairs(strBuilder) do
			newString = newString .. v
		end
	else
		newString = msg
	end

	return newString
end

local escapes = {
    ["|c%x%x%x%x%x%x%x%x"] = "", -- color start
    ["|r"] = "", -- color end
    ["|H.-|h(.-)|h"] = "%1", -- links
    ["|T.-|t"] = "", -- textures
    ["{.-}"] = "", -- raid target icons
	["|n"] = " ", -- new lines
	["\n"] = " ", -- new lines userinput...
	["|cffffff00"] = "" -- Achievments
}
local function unescape(str)
    for k, v in pairs(escapes) do
        str = gsub(str, k, v)
    end
    return str
end

--A Better Version...
local function CreateNewTableRow(frame, msg, sender, id)
	
	local timestamp = time()
	
	if numOfCreatedFontsArr[id] > 0 then
		--rowPaddingTopArr[id] = -15
		rowPaddingTopArr[id] = rowPaddingTopArr[id] - tableArray[id][1][table.getn(tableArray[id][1])]:GetHeight()
	end
	
	--Message
	local widget = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")

	local timerWidget = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	
	local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	
	
	widget:SetAllPoints(true);
	widget:SetPoint("TOPLEFT", frame, "TOPLEFT", 140, startPositionY + rowPaddingTopArr[id])
	widget:SetJustifyH("LEFT")
	widget:SetJustifyV("TOP")
	--widget:SetWidth(windowX - 140)
	widget:SetNonSpaceWrap(false)
	widget:SetHeight(400)
	--widget:SetFrameLevel(3)
	--message(msg)
	--widget:SetSize(windowX - 140, 11)
		--NewLineStrinBuilder(unescape(msg), 100)
		--message(unescape(msg))
	widget:SetText(NewLineStrinBuilder(unescape(msg), maxTextLengthBox))
	widget:SetHeight(widget:GetStringHeight())
	--message(widget:CanNonSpaceWrap())
	
	
	button:SetPoint("TOPLEFT",frame, "TOPLEFT", 5, startPositionY + rowPaddingTopArr[id])
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
	
	
	timerWidget:SetPoint("TOPLEFT",frame, "TOPLEFT", 80, startPositionY + rowPaddingTopArr[id])
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


function Rebuild(tableId)


	local paddingTop = 0 
	paddingTop = MyTableSlider:GetValue()
	for i, f in ipairs(tableArray[tableId][1]) do
		--message(MySlider2:GetValue())
		--tableArray[tableId][1][i]:GetParent()
		
		if paddingTop > 13 then
			tableArray[tableId][1][i]:Hide()
			tableArray[tableId][2][i]:Hide()
			tableArray[tableId][3][i]:Hide()
		else
			tableArray[tableId][1][i]:Show()
			tableArray[tableId][2][i]:Show()
			tableArray[tableId][3][i]:Show()
		end
		
		tableArray[tableId][1][i]:SetPoint("TOPLEFT", tableArray[tableId][1][i]:GetParent(), "TOPLEFT", 140, startPositionY + paddingTop)
		tableArray[tableId][2][i]:SetPoint("TOPLEFT", tableArray[tableId][2][i]:GetParent(), "TOPLEFT", 5, startPositionY + paddingTop)
		tableArray[tableId][3][i]:SetPoint("TOPLEFT", tableArray[tableId][3][i]:GetParent(), "TOPLEFT", 80, startPositionY + paddingTop)
		
		paddingTop = paddingTop - tableArray[tableId][1][i]:GetHeight()
		--print(paddingTop)
	end
	rowPaddingTopArr[tableId] = paddingTop

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

							--ChangeTextWorked(tableArray[id][1][index], tableArray[id][1][index+1]:GetText(), id)
							tableArray[id][1][index]:SetHeight(400)
							tableArray[id][1][index]:SetText(tableArray[id][1][index+1]:GetText())
							tableArray[id][1][index]:SetHeight(tableArray[id][1][index]:GetStringHeight())
							--ChangeText(tableArray[id][1][index], tableArray[id][1][index+1]:GetText(), id)
							
							tableArray[id][3][index]:SetText(tableArray[id][3][index+1]:GetText())
							tableArray[id][2][index]:SetText(tableArray[id][2][index+1]:GetText())
							tableArray[id][4][index] = tableArray[id][4][index+1]
						end
						
						if index == table.getn(tableArray[id][4]) then
							tableArray[id][1][index]:SetText("")
							tableArray[id][3][index]:SetText("")
							tableArray[id][2][index]:SetText("")
							tableArray[id][4][index] = nil
							
							Rebuild(id)
						end
					end
					
				end
			end
		end
	
	end
end

--Scrollbar for Table Content
local MySlider2 = CreateFrame("Slider", "MyTableSlider", mainFrame, "OptionsSliderTemplate")
MySlider2:SetHeight(350)
MySlider2:SetWidth(20)
MySlider2:SetOrientation('VERTICAL')
MySlider2:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", -5, -45)
MySlider2:SetMinMaxValues(0, 500)
MySlider2:SetValue(0)
MySlider2:SetValueStep(1)

--Not the best option for performence reason but its ok for now...
local IsSliderOnMove = false
MySlider2:SetScript("OnUpdate", function(self, elapsed)
	if IsSliderOnMove then
		getglobal(self:GetName() .. 'Text'):SetText(self:GetValue())

		Rebuild(1)
		Rebuild(2)
		Rebuild(3)
		Rebuild(4)
		
	end
end)
MySlider2:SetScript("OnMouseDown", function(self, elapsed)
	IsSliderOnMove = true
end)
MySlider2:SetScript("OnMouseUp", function(self, elapsed)
	IsSliderOnMove = false
end)


getglobal(MySlider2:GetName() .. 'Text'):SetFontObject('GameFontNormalLeft')
getglobal(MySlider2:GetName() .. 'Low'):SetText(''); --Sets the left-side slider text (default is "Low").
 getglobal(MySlider2:GetName() .. 'High'):SetText(''); --Sets the right-side slider text (default is "High").
 getglobal(MySlider2:GetName() .. 'Text'):SetText('0'); --Sets the "title" text (top-centre of slider).
MySlider2:Show()

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
local eventArray = { "CHAT_MSG_GUILD", "CHAT_MSG_OFFICER", "CHAT_MSG_BATTLEGROUND", "CHAT_MSG_BATTLEGROUND_LEADER", "CHAT_MSG_PARTY", "CHAT_MSG_RAID_LEADER", "CHAT_MSG_RAID", "CHAT_MSG_WHISPER", "CHAT_MSG_BN_WHISPER", "CHAT_MSG_CHANNEL", "CHAT_MSG_SAY", "CHAT_MSG_YELL", "ADDON_LOADED", "PLAYER_LOGIN" }
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
local IsGearScoreLiteLoaded = false
-- Eventhandler 
local function eventHandler(self, event, msg, sender, _, chanString, _, _, _, chanNumber, chanName)

	if event == "PLAYER_LOGIN"  then
		if not LFG_Settings then
			LFG_Settings.gearscore = 500
		end
		
		
		if IsAddOnLoaded("GearScoreLite") or IsAddOnLoaded("GearScore") then
			local pGearScore = GearScore_GetScore(playerName, "player")
			LFGChatFilter_InterfaceSlider:SetValue(pGearScore)
			getglobal(LFGChatFilter_InterfaceSlider:GetName() .. 'Text'):SetText(tostring(pGearScore));
			--getglobal(LFGChatFilter_InterfaceSlider:GetName() .. 'High'):SetText(tostring(pGearScore));

		else
			-- alternation if gearscorelite not found...
			LFGChatFilter_InterfaceSlider:SetValue(LFG_Settings["gearscore"])
			getglobal(LFGChatFilter_InterfaceSlider:GetName() .. 'Text'):SetText(LFG_Settings["gearscore"]);
		end
		
		return
	end
	
	if event == "ADDON_LOADED" then
		-- using default settings to work with savedvars without saving them...
		if arg1 == "LFGChatFilter" then
			for i, v in pairs(LFG_Settings) do 
				if ( LFG_Settings[i] ) then LFG_Settings_Default[i] = LFG_Settings[i]; end
			end

			LFGChatFilter_InterfaceSlider:SetValue(LFG_Settings["gearscore"])
			getglobal(LFGChatFilter_InterfaceSlider:GetName() .. 'Text'):SetText(LFG_Settings["gearscore"]);
		end
		
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
								
								--ChangeText(tableArray[1][1][i], StringBuilder(msg), 1)
								--tableArray[1][1][i]:SetHeight(400)
								--tableArray[1][1][i]:SetText(NewLineStrinBuilder(msg, 100))
								--tableArray[1][1][i]:SetHeight(tableArray[1][1][i]:GetStringHeight())
								--Rebuild(1)
								tableArray[1][1][i]:SetHeight(400)
								tableArray[1][1][i]:SetText(NewLineStrinBuilder(unescape(msg), maxTextLengthBox))
								tableArray[1][1][i]:SetHeight(tableArray[1][1][i]:GetStringHeight())
								Rebuild(1)
								
								tableArray[1][4][i] = time()
								tableArray[1][3][i]:SetText(date("%H:%M:%S", time()))
								tableArray[1][2][i]:SetText(sender)
							break
						end
						
						--print(v:GetText())
						--print(msg)
						
						if NewLineStrinBuilder(unescape(msg), maxTextLengthBox) == v:GetText()then
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
								
								--tableArray[2][1][i]:SetHeight(400)
								--tableArray[2][1][i]:SetText(NewLineStrinBuilder(msg, 100))
								--tableArray[2][1][i]:SetHeight(tableArray[2][1][i]:GetStringHeight())
								--Rebuild(2)
								--ChangeText(tableArray[2][1][i], StringBuilder(msg), 2)
								tableArray[2][1][i]:SetHeight(400)
								tableArray[2][1][i]:SetText(NewLineStrinBuilder(unescape(msg), maxTextLengthBox))
								tableArray[2][1][i]:SetHeight(tableArray[2][1][i]:GetStringHeight())
								Rebuild(2)
								
								
								tableArray[2][4][i] = time()
								tableArray[2][3][i]:SetText(date("%H:%M:%S", time()))
								tableArray[2][2][i]:SetText(sender)
							break
						end
					
						--print(v:GetText())
						-- Update Time
						if NewLineStrinBuilder(unescape(msg), maxTextLengthBox) == v:GetText() then
							IsInList = true
							tableArray[2][3][i]:SetText(date("%H:%M:%S", time()))
							tableArray[2][4][i] = time()
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
								
								tableArray[3][1][i]:SetHeight(400)
								tableArray[3][1][i]:SetText(NewLineStrinBuilder(unescape(msg), maxTextLengthBox))
								tableArray[3][1][i]:SetHeight(tableArray[3][1][i]:GetStringHeight())
								Rebuild(3)
								--tableArray[3][1][i]:SetText(msg)
								tableArray[3][4][i] = time()
								tableArray[3][3][i]:SetText(date("%H:%M:%S", time()))
								tableArray[3][2][i]:SetText(sender)
							break
						end
						
						if NewLineStrinBuilder(unescape(msg), maxTextLengthBox) == v:GetText() then
							IsInList = true
							tableArray[3][3][i]:SetText(date("%H:%M:%S", time()))
							tableArray[3][4][i] = time()
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
								
								tableArray[4][1][i]:SetHeight(400)
								tableArray[4][1][i]:SetText(NewLineStrinBuilder(unescape(msg), maxTextLengthBox))
								tableArray[4][1][i]:SetHeight(tableArray[4][1][i]:GetStringHeight())
								Rebuild(4)
								--tableArray[4][1][i]:SetText(msg)
								tableArray[4][4][i] = time()
								tableArray[4][3][i]:SetText(date("%H:%M:%S", time()))
								tableArray[4][2][i]:SetText(sender)
							break
						end
						
						if NewLineStrinBuilder(unescape(msg), maxTextLengthBox) == v:GetText() then
							IsInList = true
							tableArray[4][3][i]:SetText(date("%H:%M:%S", time()))
							tableArray[4][4][i] = time()
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