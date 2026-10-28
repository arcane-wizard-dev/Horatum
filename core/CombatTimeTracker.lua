local addonName, HRT = ...

if HRT.State and HRT.State.libraryIncompatible then return end

-- Library
local AWL = ArcaneWizardLibrary

-- Localization
local L = HRT.Localization

-- Current module
local CombatTimeTracker = HRT.Modules.CombatTimeTracker

-- Module imports
local CombatTimeTrackerConfig = HRT.UIConfig.CombatTimeTracker
local CombatTimeTrackerData = HRT.COMBAT_TIME_TRACKER_DATA
local Utils = HRT.Modules.Utils

-- Variables
local startTime = 0
local currentBestVictory = 0
local currentEncounterID = 0
local currentDifficultyID = 0
local currentDifficultyText = nil
local currentOptionalID = 0
local currentEncounterName = nil
local displayedTime = 0

--------------
--- Frames ---
--------------

local CombatTimeTrackerFrame = nil

-----------------------
--- Local Functions ---
-----------------------

local function ParseDelveTier(tierText)
	if type(tierText) ~= "string" then
		return nil
	end

	return tonumber(tierText:match("%d+"))
end

local function GetDecimalPlaces()
	local decimalPlaces = tonumber(HRT.Settings.combatTimeTracker["decimal-places"]) or HRT.OPTIONS_DEFAULTS["combat-time-tracker"]["decimal-places"]

	return math.max(0, math.min(CombatTimeTrackerData.maximumDecimalPlaces, math.floor(decimalPlaces)))
end

local function FormatTime(duration)
	local decimalPlaces = GetDecimalPlaces()
	local factor = 10 ^ decimalPlaces
	local truncatedDuration = math.floor(math.max(0, tonumber(duration) or 0) * factor) / factor
	local minutes = math.floor(truncatedDuration / 60)
	local seconds = truncatedDuration - minutes * 60

	if decimalPlaces == 0 then
		return string.format("%02d:%02d", minutes, math.floor(seconds))
	end

	local secondsWidth = decimalPlaces + 3

	return string.format("%02d:%0" .. secondsWidth .. "." .. decimalPlaces .. "f", minutes, seconds)
end

local function EncounterInfo(difficultyID)
	local name, instanceType, isHeroic, isChallengeMode, displayHeroic, displayMythic, toggleDifficultyID, isLFR, minPlayers, maxPlayers, isUserSelectable = GetDifficultyInfo(difficultyID)

	Utils:PrintDebug(string.format(
		"Result from GetDifficultyInfo(): name=%s, instanceType=%s, isHeroic=%s, isChallengeMode=%s, displayHeroic=%s, displayMythic=%s, toggleDifficultyID=%s, isLFR=%s, minPlayers=%s, maxPlayers=%s, isUserSelectable=%s",
		tostring(name),
		tostring(instanceType),
		tostring(isHeroic),
		tostring(isChallengeMode),
		tostring(displayHeroic),
		tostring(displayMythic),
		tostring(toggleDifficultyID),
		tostring(isLFR),
		tostring(minPlayers),
		tostring(maxPlayers),
		tostring(isUserSelectable)
	))

	local labelKey = CombatTimeTrackerData.difficultyLabels[difficultyID]

	if labelKey then
		return true, 0, L[labelKey] .. " - " .. name
	elseif difficultyID == CombatTimeTrackerData.delve.difficultyID then
		local delve = CombatTimeTrackerData.delve
		local delveData1 = C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo(delve.tierWidgetID)
		local delveData2 = C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo(delve.firstSpecialWidgetID)
		local delveData3 = C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo(delve.secondSpecialWidgetID)

		if delveData2 and delveData2.shownState and delveData2.shownState == 1 then
			return true, delve.firstSpecialTier, name .. " - " .. L["combat-time-tracker.delves-tier"] .. " ?"
		elseif delveData3 and delveData3.shownState and delveData3.shownState == 1 then
			return true, delve.secondSpecialTier, name .. " - " .. L["combat-time-tracker.delves-tier"] .. " ??"
		elseif delveData1 and delveData1.tierText then
			local delveTier = ParseDelveTier(delveData1.tierText)

			if delveTier then
				return true, delveTier, name .. " - " .. L["combat-time-tracker.delves-tier"] .. " " .. delveTier
			end

			return false, 0, nil
		end
	end

	return false, 0, nil
end

local function UpdateTimerFrame(self, elapsed)
	local currentTime = GetTime() - startTime
	displayedTime = currentTime
	CombatTimeTrackerFrame.timer:SetText(FormatTime(currentTime))

	if currentBestVictory >= HRT.COMBAT_TIME_TRACKER_THRESHOLD then
		local remainingTime = currentBestVictory - currentTime

		if remainingTime > 0 then
			CombatTimeTrackerFrame.timeBar:SetValue(remainingTime)
			CombatTimeTrackerFrame.timeBar:SetStatusBarColor(unpack(CombatTimeTrackerConfig.timeBar.colors.withinBest))
		else
			CombatTimeTrackerFrame.timeBar:SetValue(currentBestVictory)
			CombatTimeTrackerFrame.timeBar:SetStatusBarColor(unpack(CombatTimeTrackerConfig.timeBar.colors.overBest))
		end
	end
end

-----------------------
--- Frame Functions ---
-----------------------

local function InitializeFrames()
	---@class HoratumCombatTimeTrackerFrame: ArcaneWizardLibraryPopupFrame
	CombatTimeTrackerFrame = AWL.Frames:CreatePopup({
		addonName = addonName,
		width = CombatTimeTrackerConfig.width,
		height = CombatTimeTrackerConfig.initialHeight,
		style = CombatTimeTrackerConfig.style,
		backgroundAlpha = HRT.Settings.combatTimeTracker["background-transparency"] / 100,
		showBorder = HRT.Settings.combatTimeTracker["show-border"] ~= false,
		showCloseButton = CombatTimeTrackerConfig.showCloseButton,
		closeButton = CombatTimeTrackerConfig.closeButton,
		movable = CombatTimeTrackerConfig.movable,
		closeOnEscape = CombatTimeTrackerConfig.closeOnEscape
	})
	CombatTimeTrackerFrame:SetBackdropColor(unpack(CombatTimeTrackerConfig.backgroundColor))
	CombatTimeTrackerFrame:SetScale(HRT.Settings.combatTimeTracker["scale"] / 100)

	CombatTimeTrackerFrame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()

		local point, _, relativePoint, xOfs, yOfs = self:GetPoint()
		HRT.Settings.combatTimeTracker["point"] = point
		HRT.Settings.combatTimeTracker["relative-point"] = relativePoint
		HRT.Settings.combatTimeTracker["offset-x"] = xOfs
		HRT.Settings.combatTimeTracker["offset-y"] = yOfs
	end)

	local content = CombatTimeTrackerFrame.content
	content:ClearAllPoints()
	content:SetPoint("TOPLEFT", CombatTimeTrackerConfig.contentPadding.x, -CombatTimeTrackerConfig.contentPadding.y)
	content:SetPoint("BOTTOMRIGHT", -CombatTimeTrackerConfig.contentPadding.x, CombatTimeTrackerConfig.contentPadding.y)

	CombatTimeTrackerFrame.timer = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge")
	CombatTimeTrackerFrame.timer:SetPoint("TOP", content, "TOP", 0, -CombatTimeTrackerConfig.timerOffset)
	CombatTimeTrackerFrame.timer:SetText(FormatTime(0))

	CombatTimeTrackerFrame.timeBar = CreateFrame("StatusBar", nil, content)
	CombatTimeTrackerFrame.timeBar:SetSize(CombatTimeTrackerConfig.timeBar.width, CombatTimeTrackerConfig.timeBar.height)
	CombatTimeTrackerFrame.timeBar:SetPoint("TOP", CombatTimeTrackerFrame.timer, "BOTTOM", 0, -CombatTimeTrackerConfig.rowSpacing)
	CombatTimeTrackerFrame.timeBar:SetStatusBarTexture(CombatTimeTrackerConfig.timeBar.texture)
	CombatTimeTrackerFrame.timeBar:SetMinMaxValues(0, 1)
	CombatTimeTrackerFrame.timeBar:SetValue(1)
	CombatTimeTrackerFrame.timeBar:SetStatusBarColor(unpack(CombatTimeTrackerConfig.timeBar.colors.idle))

	local timeBarBackground = CombatTimeTrackerFrame.timeBar:CreateTexture(nil, "BACKGROUND")
	timeBarBackground:SetAllPoints(CombatTimeTrackerFrame.timeBar, true)
	timeBarBackground:SetColorTexture(unpack(CombatTimeTrackerConfig.timeBar.backgroundColor))

	local timeBarBorder = CreateFrame("Frame", nil, CombatTimeTrackerFrame.timeBar, "BackdropTemplate")
	timeBarBorder:SetPoint("TOPLEFT", CombatTimeTrackerFrame.timeBar, "TOPLEFT", -CombatTimeTrackerConfig.timeBar.border.padding, CombatTimeTrackerConfig.timeBar.border.padding)
	timeBarBorder:SetPoint("BOTTOMRIGHT", CombatTimeTrackerFrame.timeBar, "BOTTOMRIGHT", CombatTimeTrackerConfig.timeBar.border.padding, -CombatTimeTrackerConfig.timeBar.border.padding)
	timeBarBorder:SetBackdrop({
		edgeFile = CombatTimeTrackerConfig.timeBar.border.texture,
		edgeSize = CombatTimeTrackerConfig.timeBar.border.edgeSize
	})

	CombatTimeTrackerFrame.name = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	CombatTimeTrackerFrame.name:SetPoint("TOP", CombatTimeTrackerFrame.timeBar, "BOTTOM", 0, -CombatTimeTrackerConfig.rowSpacing)
	CombatTimeTrackerFrame.name:SetWidth(CombatTimeTrackerConfig.nameWidth)
	CombatTimeTrackerFrame.name:SetWordWrap(false)
	CombatTimeTrackerFrame.name:SetText(L["combat-time-tracker.wait-combat"])

	CombatTimeTrackerFrame.difficulty = content:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	CombatTimeTrackerFrame.difficulty:SetPoint("TOP", CombatTimeTrackerFrame.name, "BOTTOM", 0, -CombatTimeTrackerConfig.difficultySpacing)
	CombatTimeTrackerFrame.difficulty:SetWidth(CombatTimeTrackerConfig.difficultyWidth)
	CombatTimeTrackerFrame.difficulty:SetWordWrap(false)
	CombatTimeTrackerFrame.difficulty:SetText("-")

	CombatTimeTrackerFrame.closeButton:SetScript("OnClick", function()
		CombatTimeTrackerFrame:Hide()
		HRT.Settings.combatTimeTracker["is-visible"] = false
	end)

	CombatTimeTrackerFrame.resetButton = CreateFrame("Button", nil, CombatTimeTrackerFrame)
	CombatTimeTrackerFrame.resetButton:SetSize(CombatTimeTrackerConfig.resetButton.size, CombatTimeTrackerConfig.resetButton.size)
	CombatTimeTrackerFrame.resetButton:SetPoint("BOTTOMRIGHT", CombatTimeTrackerFrame, "BOTTOMRIGHT", CombatTimeTrackerConfig.resetButton.x, CombatTimeTrackerConfig.resetButton.y)
	CombatTimeTrackerFrame.resetButton:SetNormalTexture("Interface\\Buttons\\UI-RefreshButton")
	CombatTimeTrackerFrame.resetButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
	CombatTimeTrackerFrame.resetButton:SetPushedTexture("Interface\\Buttons\\UI-RefreshButton")

	local pushedTexture = CombatTimeTrackerFrame.resetButton:GetPushedTexture()
	pushedTexture:ClearAllPoints()
	pushedTexture:SetPoint("CENTER", CombatTimeTrackerFrame.resetButton, "CENTER", 1, -1)
	pushedTexture:SetSize(CombatTimeTrackerConfig.resetButton.size, CombatTimeTrackerConfig.resetButton.size)

	CombatTimeTrackerFrame.resetButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(L["combat-time-tracker.button-reset"], 1, 1, 1)
		GameTooltip:Show()
	end)

	CombatTimeTrackerFrame.resetButton:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	CombatTimeTrackerFrame.resetButton:SetScript("OnClick", function()
		displayedTime = 0
		CombatTimeTrackerFrame.timer:SetText(FormatTime(displayedTime))
		CombatTimeTrackerFrame.timeBar:SetMinMaxValues(0, 1)
		CombatTimeTrackerFrame.timeBar:SetValue(1)
		CombatTimeTrackerFrame.timeBar:SetStatusBarColor(unpack(CombatTimeTrackerConfig.timeBar.colors.idle))
		CombatTimeTrackerFrame.name:SetText(L["combat-time-tracker.wait-combat"])
		CombatTimeTrackerFrame.difficulty:SetText("-")
	end)

	local height = CombatTimeTrackerConfig.contentPadding.y + CombatTimeTrackerConfig.timerOffset
	height = height + CombatTimeTrackerFrame.timer:GetStringHeight()
	height = height + CombatTimeTrackerConfig.rowSpacing + CombatTimeTrackerFrame.timeBar:GetHeight()
	height = height + CombatTimeTrackerConfig.rowSpacing + CombatTimeTrackerFrame.name:GetStringHeight()
	height = height + CombatTimeTrackerConfig.difficultySpacing + CombatTimeTrackerFrame.difficulty:GetStringHeight()
	height = height + CombatTimeTrackerConfig.contentPadding.y

	CombatTimeTrackerFrame:SetHeight(height)

	CombatTimeTrackerFrame:ClearAllPoints()
	CombatTimeTrackerFrame:SetPoint(
		HRT.Settings.combatTimeTracker["point"],
		UIParent,
		HRT.Settings.combatTimeTracker["relative-point"],
		HRT.Settings.combatTimeTracker["offset-x"],
		HRT.Settings.combatTimeTracker["offset-y"]
	)

	if HRT.Settings.combatTimeTracker["is-visible"] then
		CombatTimeTrackerFrame:Show()
	else
		CombatTimeTrackerFrame:Hide()
	end
end

------------------------
--- Module Functions ---
------------------------

function CombatTimeTracker:Initialize()
	InitializeFrames()
end

function CombatTimeTracker:EncounterStart(encounterID, encounterName, difficultyID)
	currentEncounterID = encounterID
	currentDifficultyID = difficultyID
	currentEncounterName = encounterName

	local isValidEncounter, optionalID, difficulty = EncounterInfo(difficultyID)

	Utils:PrintDebug(string.format(
		"Result from EncounterInfo(): isValidEncounter=%s, optionalID=%s, difficulty=%s",
		tostring(isValidEncounter), tostring(optionalID), tostring(difficulty)
	))

	if not isValidEncounter then return false end

	startTime = GetTime()
	displayedTime = 0

	currentOptionalID = optionalID
	currentDifficultyText = difficulty

	CombatTimeTrackerFrame.resetButton:Hide()
	CombatTimeTrackerFrame:Show()

	HRT.Settings.combatTimeTracker["is-visible"] = true

	CombatTimeTrackerFrame.name:SetText(encounterName)
	CombatTimeTrackerFrame.difficulty:SetText(currentDifficultyText)
	CombatTimeTrackerFrame.timer:SetText(FormatTime(displayedTime))

	if not HRT.Data.combatEncounter[tostring(currentEncounterID)] then
			HRT.Data.combatEncounter[tostring(currentEncounterID)] = {}
	end

	if not HRT.Data.combatEncounter[tostring(currentEncounterID)][tostring(currentDifficultyID)] then
		HRT.Data.combatEncounter[tostring(currentEncounterID)][tostring(currentDifficultyID)] = {}
	end

	if not HRT.Data.combatEncounter[tostring(currentEncounterID)][tostring(currentDifficultyID)][tostring(currentOptionalID)] then
		HRT.Data.combatEncounter[tostring(currentEncounterID)][tostring(currentDifficultyID)][tostring(currentOptionalID)] = {
			bestVictory = -1,
			victories = 0,
			wipes = 0
		}
	end

	local currentDataSet = HRT.Data.combatEncounter[tostring(currentEncounterID)][tostring(currentDifficultyID)][tostring(currentOptionalID)]
	currentBestVictory = currentDataSet.bestVictory

	if currentBestVictory >= HRT.COMBAT_TIME_TRACKER_THRESHOLD then
		CombatTimeTrackerFrame.timeBar:SetMinMaxValues(0, currentBestVictory)
		CombatTimeTrackerFrame.timeBar:SetValue(currentBestVictory)
		CombatTimeTrackerFrame.timeBar:SetStatusBarColor(unpack(CombatTimeTrackerConfig.timeBar.colors.withinBest))
	else
		CombatTimeTrackerFrame.timeBar:SetMinMaxValues(0, 1)
		CombatTimeTrackerFrame.timeBar:SetValue(1)
		CombatTimeTrackerFrame.timeBar:SetStatusBarColor(unpack(CombatTimeTrackerConfig.timeBar.colors.noBest))
	end

	CombatTimeTrackerFrame:SetScript("OnUpdate", UpdateTimerFrame)

	return true
end

function CombatTimeTracker:EncounterEnd(success)
	CombatTimeTrackerFrame.resetButton:Show()
	CombatTimeTrackerFrame:SetScript("OnUpdate", nil)

	local finalTime = GetTime() - startTime

	Utils:PrintDebug(string.format(
		"Unrounded time: finalTime=%s",
		tostring(finalTime)
	))

	if finalTime < HRT.COMBAT_TIME_TRACKER_THRESHOLD then
		finalTime = HRT.COMBAT_TIME_TRACKER_THRESHOLD
	else
		finalTime = math.floor(finalTime * 1000 + 0.5) / 1000
	end

	Utils:PrintDebug(string.format(
		"Rounded time: finalTime=%s",
		tostring(finalTime)
	))

	displayedTime = finalTime
	CombatTimeTrackerFrame.timer:SetText(FormatTime(finalTime))

	local currentDataSet = HRT.Data.combatEncounter[tostring(currentEncounterID)][tostring(currentDifficultyID)][tostring(currentOptionalID)]
	local bestVictory = currentDataSet.bestVictory
	local victories = currentDataSet.victories
	local wipes = currentDataSet.wipes

	if success == 1 then
		victories = victories + 1
		currentDataSet.victories = victories

		if bestVictory < HRT.COMBAT_TIME_TRACKER_THRESHOLD or finalTime < bestVictory then
			currentDataSet.bestVictory = finalTime
		end

		if HRT.Settings.general["notification"] then
			if bestVictory < HRT.COMBAT_TIME_TRACKER_THRESHOLD or finalTime < bestVictory then
				Utils:PrintMessage(L["chat.new-record"]:format(currentEncounterName, currentDifficultyText, FormatTime(finalTime)))
			else
				Utils:PrintMessage(L["chat.current-record"]:format(currentEncounterName, currentDifficultyText, FormatTime(bestVictory)))
			end

			if victories == 1 then
				Utils:PrintMessage(L["chat.first-victory"]:format(currentEncounterName, currentDifficultyText, wipes))
			else
				Utils:PrintMessage(L["chat.another-victory"]:format(currentEncounterName, currentDifficultyText, victories, wipes))
			end
		end
	else
		wipes = wipes + 1
		currentDataSet.wipes = wipes

		if HRT.Settings.general["notification"] then
			if bestVictory >= HRT.COMBAT_TIME_TRACKER_THRESHOLD then
				Utils:PrintMessage(L["chat.current-record"]:format(currentEncounterName, currentDifficultyText, FormatTime(bestVictory)))
			end

			if wipes == 1 then
				Utils:PrintMessage(L["chat.first-wipe"]:format(currentEncounterName, currentDifficultyText, victories))
			else
				Utils:PrintMessage(L["chat.another-wipe"]:format(currentEncounterName, currentDifficultyText, victories, wipes))
			end
		end
	end

	startTime = 0
	currentBestVictory = -1
	currentEncounterID = 0
	currentDifficultyID = 0
	currentDifficultyText = nil
	currentOptionalID = 0
	currentEncounterName = nil
end

function CombatTimeTracker:IsShown()
	return CombatTimeTrackerFrame:IsShown()
end

function CombatTimeTracker:Show()
	CombatTimeTrackerFrame:Show()
	HRT.Settings.combatTimeTracker["is-visible"] = true
end

function CombatTimeTracker:Hide()
	CombatTimeTrackerFrame:Hide()
	HRT.Settings.combatTimeTracker["is-visible"] = false
end

function CombatTimeTracker:SetScale()
	CombatTimeTrackerFrame:SetScale(HRT.Settings.combatTimeTracker["scale"] / 100)
end

function CombatTimeTracker:SetBackgroundTransparency()
	CombatTimeTrackerFrame.background:SetAlpha(HRT.Settings.combatTimeTracker["background-transparency"] / 100)
end

function CombatTimeTracker:SetBorderShown()
	CombatTimeTrackerFrame:SetBorderShown(HRT.Settings.combatTimeTracker["show-border"] ~= false)
end

function CombatTimeTracker:SetDecimalPlaces()
	CombatTimeTrackerFrame.timer:SetText(FormatTime(displayedTime))
end
