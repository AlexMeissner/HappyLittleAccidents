local function StringStartsWith(input, compare)
    return input:sub(1, #compare) == compare
end

local function StringEndsWith(input, compare)
    return compare == "" or input:sub(-#compare) == compare
end

local function GetInstanceId()
    local id = select(8, GetInstanceInfo())
    return id
end

-- https://wow.gamepedia.com/API_CombatLogGetCurrentEventInfo
-- https://wow.gamepedia.com/COMBAT_LOG_EVENT
local function RecordAbility(...)
    local instance = GetInstanceId()
    local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...

    if sourceName and not UnitInParty(sourceName) and not UnitInRaid(sourceName) then
        local hasTarget = (destName ~= nil)
        local hasAmplitude = false

        if StringEndsWith(subevent, "DAMAGE") or StringEndsWith(subevent, "HEAL") then
            amount = select(15, ...)

            if amount and amount > 0 then
                hasAmplitude = true
            end
        end

        if HLA_RECORD[instance] == nil then
            HLA_RECORD[instance] = {}
        elseif HLA_RECORD[instance][sourceName] == nil then
            HLA_RECORD[instance][sourceName] = {}
        end

        -- Tabelle wird immer überschrieben -> Tabelle enthält immer nur einen Eintrag
        if StringStartsWith(subevent, "ENVIRONMENTAL") then
            local type = select(12, ...)
            
            HLA_RECORD[instance][sourceName][type] = 
            {
                HasTarget=hasTarget, HasAmplitude=hasAmplitude, Event=subevent
            }
        elseif not StringStartsWith(subevent, "SWING") then
            local spellId, spellName = select(12, ...)

            HLA_RECORD[instance][sourceName][spellId] = 
            {
                Name=spellName, HasTarget=hasTarget, HasAmplitude=hasAmplitude, Event=subevent
            }
        end
    end
    -- cast time?
    -- interruptable?
end

local function eventHandler(self, event)
    if event == "ADDON_LOADED" then
        if HLA_RECORD == nil then
            HLA_RECORD = {}
        end
    elseif RecordingWindow and RecordingWindow:IsShown() then
        RecordAbility(CombatLogGetCurrentEventInfo())
    end
end

function ToggleRecordingFrame()
    if RecordingWindow:IsShown() then
        RecordingWindow:Hide()
    else
        RecordingWindow:Show()
    end
end

SLASH_HAPPYLITTLEACCIDENTSRECORD1 = "/hlar"
SLASH_HAPPYLITTLEACCIDENTSRECORD2 = "/happylittleaccidentsrecord"
SlashCmdList["HAPPYLITTLEACCIDENTSRECORD"] = function(self, txt)
    ToggleRecordingFrame()
end

local frame = CreateFrame("Frame", "RecordingWindow", UIParent, "DialogBoxFrame")
frame:SetPoint("CENTER")
frame:SetSize(180, 65)
frame:SetResizable(false)
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
frame:SetScript("OnEvent", eventHandler)
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
RecordingWindowButton:SetText("Stop Recording")