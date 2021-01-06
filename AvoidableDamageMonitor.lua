-- TODOs:
-- Use 'UnitCastingInfo' to tell if the cast is interruptible
-- In this way a lot of data can be removed
-- However, in this no further conditions like 'hasAggro' can be applied

local textHeight = 12
local textLines = 100
local scrollSpeed = 1
local COLOR_WHITE = "|cFFFFFFFF"

local function UnitInPartyOrRaid(name)
    return UnitInParty(name) or UnitInRaid(name)
end

local function GetClassColorCode(name)
    local _, CLASSNAME = UnitClass(name)
    local _, _, _, hexcode = GetClassColor(CLASSNAME)
    return "|c" .. hexcode
end

local function GetInstanceId()
    local id = select(8, GetInstanceInfo())
    return id
end

local function HasAggro(sourceName, destName)
    local threat = UnitThreatSituation(destName, sourceName)
    return threat == 2 or threat == 3
end

local function IsTarget(sourceName, destName)
    local unitToken = "\"" .. sourceName .. "-target\""
    local sourceTargetName = UnitName(unitToken)
    return destName == sourceTargetName
end

local function IsAvoidable(spellInfo, sourceName, destName)
    local avoidable = true
    
    if spellInfo.HasAggro then
        local hasAggro = HasAggro(sourceName, destName)
        avoidable = avoidable and (hasAggro == spellInfo.HasAggro)
    end

    if spellInfo.IsTarget then
        local isTarget = IsTarget(sourceName, destName)
        avoidable = avoidable and (isTarget == spellInfo.IsTarget)
    end

    return avoidable
end

local function CreateMessage(...)   
    local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...

    if subevent == "SPELL_DAMAGE" and UnitInPartyOrRaid(destName) then   
        local instanceData = GetADMData()[GetInstanceId()]
        
        if instanceData then
            local spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
        
            for avoidableSpellId, spellInfo in pairs(instanceData) do
                if (avoidableSpellId == spellId) and IsAvoidable(spellInfo, sourceName, destName) then
                    return GetClassColorCode(destName) .. destName .. "|cFFFFFFFF" .. " hit by " .. "|cFFFFFAB8" .. spellName .. "|cFFFFFFFF" .. " for " .. "|cFFFF0000" .. amount .. "|cFFFFFFFF"
                end
            end   
        end
    end

    return nil
end

local function eventHandler(self, event)
    local message = CreateMessage(CombatLogGetCurrentEventInfo())

    if message then
        self:AddMessage(message, 1.0, 1.0, 1.0, nil, true)
        FauxScrollFrame_Update(self:GetParent().scrollbar, textLines, scrollSpeed, textHeight )
    end
end

function OpenADM()
    if not ADMWindow then
        local frame = CreateFrame("Frame", "ADMWindow", UIParent, "DialogBoxFrame")
        frame:SetPoint("CENTER")
        frame:SetSize(440, 600)
        frame:SetMinResize(440, 150)
        frame:SetResizable(true)
        frame:SetMovable(true)
        frame:SetClampedToScreen(true)
        frame:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
            edgeSize = 16,
            insets = { left = 6, right = 6, top = 8, bottom = 8 },
        })
        frame:SetBackdropBorderColor(0, 0, 0, 1)         
        frame:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                self:StartMoving()
            end
        end)
        frame:SetScript("OnMouseUp", frame.StopMovingOrSizing)
        ADMWindowButton:Hide()

        frame.scrollingMessageFrame = CreateFrame("ScrollingMessageFrame", "ADMEditBox", ADMWindow)
        frame.scrollingMessageFrame:SetSize(400, 500)
        frame.scrollingMessageFrame:SetPoint("TOPLEFT", 10, -10)
        frame.scrollingMessageFrame:SetPoint("BOTTOMRIGHT", -30, 10)
        frame.scrollingMessageFrame:SetInsertMode(SCROLLING_MESSAGE_FRAME_INSERT_MODE_TOP)
        frame.scrollingMessageFrame:SetFading(false)
        frame.scrollingMessageFrame:SetMaxLines(500)
        frame.scrollingMessageFrame:SetIndentedWordWrap(true)
        frame.scrollingMessageFrame:SetFontObject(ChatFontNormal)
        frame.scrollingMessageFrame:SetJustifyH("LEFT")
        frame.scrollingMessageFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        frame.scrollingMessageFrame:SetScript("OnEvent", eventHandler)

        local function ScrollList(self)
            local offset = FauxScrollFrame_GetOffset(self)
            self:GetParent().scrollingMessageFrame:SetScrollOffset(offset)
            FauxScrollFrame_Update(self, textLines, scrollSpeed, textHeight )
        end

        frame.scrollbar = CreateFrame("ScrollFrame", "ADMScrollbar", ADMWindow, "FauxScrollFrameTemplate")
        frame.scrollbar:SetPoint("TOPLEFT", 10, -10)
        frame.scrollbar:SetPoint("BOTTOMRIGHT", -30, 10)
        frame.scrollbar:SetScript("OnVerticalScroll",	function(self, offset)
            FauxScrollFrame_OnVerticalScroll(self, offset, 12, ScrollList)
        end)

        frame.resizeButton = CreateFrame("Button", "ADMResizeButton", ADMWindow)
        frame.resizeButton:SetPoint("BOTTOMRIGHT", -6, 7)
        frame.resizeButton:SetSize(16, 16)
        frame.resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
        frame.resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
        frame.resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
        
        frame.resizeButton:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                frame:StartSizing("BOTTOMRIGHT")
                self:GetHighlightTexture():Hide()
            end
        end)
        frame.resizeButton:SetScript("OnMouseUp", function(self, button)
            frame:StopMovingOrSizing()
            self:GetHighlightTexture():Show()
        end)
    end

    if ADMWindow:IsShown() then
        ADMWindow:Hide()
    else
        ADMWindow:Show()
    end
end

SLASH_AVOIDABLEDAMAGEMONITOR1 = "/adm"
SLASH_AVOIDABLEDAMAGEMONITOR2 = "/avoidabledamagemonitor"
SlashCmdList["AVOIDABLEDAMAGEMONITOR"] = function(self, txt)
    OpenADM()
end