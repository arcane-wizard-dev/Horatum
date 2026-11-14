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
local currentAttempt = nil
local currentDataSet = nil

local timeDecimalPlaces = 0
local timeFactor = 1
local timeFormat = "%02d:%02d"

local lastTimerText = nil
local lastTimerTick = nil
local lastBarColor = nil

--------------
--- Frames ---
--------------

local CombatTimeTrackerFrame = nil ---@type HoratumCombatTimeTrackerFrame

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

local function RefreshTimeFormat()
	timeDecimalPlaces = GetDecimalPlaces()
	timeFactor = 10 ^ timeDecimalPlaces

	if timeDecimalPlaces == 0 then
		timeFormat = "%02d:%02d"
	else
		timeFormat = "%02d:%0" .. (timeDecimalPlaces + 3) .. "." .. timeDecimalPlaces .. "f"
	end
end

local function FormatTime(duration)
	local truncatedDuration = math.floor(math.max(0, tonumber(duration) or 0) * timeFactor) / timeFactor
	local minutes = math.floor(truncatedDuration / 60)
	local seconds = truncatedDuration - minutes * 60

	if timeDecimalPlaces == 0 then
		return string.format(timeFormat, minutes, math.floor(seconds))
	end

	return string.format(timeFormat, minutes, seconds)
end

local function SetTimerText(text)
	lastTimerText = text
	lastTimerTick = nil
	CombatTimeTrackerFrame.timer:SetText(text)
end

local function SetBarColor(color)
	lastBarColor = color
	CombatTimeTrackerFrame.timeBar:SetStatusBarColor(unpack(color))
end

local function EncounterInfo(difficultyID)
	local name, instanceType, isHeroic, isChallengeMode,
		displayHeroic, displayMythic, toggleDifficultyID, isLFR,
		minPlayers, maxPlayers, isUserSelectable = GetDifficultyInfo(difficultyID)

	Utils:PrintDebugAdvanced(
		"Result from GetDifficultyInfo(): name=%s, instanceType=%s, isHeroic=%s, isChallengeMode=%s, displayHeroic=%s, displayMythic=%s, toggleDifficultyID=%s, isLFR=%s, minPlayers=%s, maxPlayers=%s, isUserSelectable=%s",
		name,
		instanceType,
		isHeroic,
		isChallengeMode,
		displayHeroic,
		displayMythic,
		toggleDifficultyID,
		isLFR,
		minPlayers,
		maxPlayers,
		isUserSelectable
	)

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

local function UpdateTimerFrame()
	local currentTime = GetTime() - startTime
	displayedTime = currentTime

	local tick = math.floor(currentTime * timeFactor)

	if tick ~= lastTimerTick then
		local text = FormatTime(currentTime)

		if text ~= lastTimerText then
			SetTimerText(text)
		end

		lastTimerTick = tick
	end

	if currentBestVictory >= HRT.COMBAT_TIME_TRACKER_THRESHOLD then
		local remainingTime = currentBestVictory - currentTime
		local colors = CombatTimeTrackerConfig.timeBar.colors
		local color = colors.overBest

		if remainingTime > 0 then
			CombatTimeTrackerFrame.timeBar:SetValue(remainingTime)
			color = colors.withinBest
		else
			CombatTimeTrackerFrame.timeBar:SetValue(currentBestVictory)
		end

		if color ~= lastBarColor then
			SetBarColor(color)
		end
	end
end

-----------------------
--- Frame Functions ---
-----------------------

local function InitializeFrames()
	RefreshTimeFormat()

	---@class (partial) HoratumCombatTimeTrackerFrame
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
	SetTimerText(FormatTime(0))

	CombatTimeTrackerFrame.timeBar = CreateFrame("StatusBar", nil, content)
	CombatTimeTrackerFrame.timeBar:SetSize(CombatTimeTrackerConfig.timeBar.width, CombatTimeTrackerConfig.timeBar.height)
	CombatTimeTrackerFrame.timeBar:SetPoint("TOP", CombatTimeTrackerFrame.timer, "BOTTOM", 0, -CombatTimeTrackerConfig.rowSpacing)
	CombatTimeTrackerFrame.timeBar:SetStatusBarTexture(CombatTimeTrackerConfig.timeBar.texture)
	CombatTimeTrackerFrame.timeBar:SetMinMaxValues(0, 1)
	CombatTimeTrackerFrame.timeBar:SetValue(1)
	SetBarColor(CombatTimeTrackerConfig.timeBar.colors.idle)

	local timeBarBackground = CombatTimeTrackerFrame.timeBar:CreateTexture(nil, "BACKGROUND")
	timeBarBackground:SetAllPoints(CombatTimeTrackerFrame.timeBar, true)
	timeBarBackground:SetColorTexture(unpack(CombatTimeTrackerConfig.timeBar.backgroundColor))

	local timeBarBorder = CreateFrame("Frame", nil, CombatTimeTrackerFrame.timeBar, "BackdropTemplate")
	timeBarBorder:SetPoint(
		"TOPLEFT", CombatTimeTrackerFrame.timeBar, "TOPLEFT",
		-CombatTimeTrackerConfig.timeBar.border.padding, CombatTimeTrackerConfig.timeBar.border.padding
	)
	timeBarBorder:SetPoint(
		"BOTTOMRIGHT", CombatTimeTrackerFrame.timeBar, "BOTTOMRIGHT",
		CombatTimeTrackerConfig.timeBar.border.padding, -CombatTimeTrackerConfig.timeBar.border.padding
	)
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
	CombatTimeTrackerFrame.resetButton:SetPoint(
		"BOTTOMRIGHT", CombatTimeTrackerFrame, "BOTTOMRIGHT",
		CombatTimeTrackerConfig.resetButton.x, CombatTimeTrackerConfig.resetButton.y
	)
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
		SetTimerText(FormatTime(displayedTime))
		CombatTimeTrackerFrame.timeBar:SetMinMaxValues(0, 1)
		CombatTimeTrackerFrame.timeBar:SetValue(1)
		SetBarColor(CombatTimeTrackerConfig.timeBar.colors.idle)
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

	Utils:PrintDebugAdvanced(
		"Result from EncounterInfo(): isValidEncounter=%s, optionalID=%s, difficulty=%s",
		isValidEncounter, optionalID, difficulty
	)

	if not isValidEncounter then
		return false
	end

	startTime = GetTime()
	displayedTime = 0

	currentOptionalID = optionalID
	currentDifficultyText = difficulty

	CombatTimeTrackerFrame.resetButton:Hide()
	CombatTimeTrackerFrame:Show()

	HRT.Settings.combatTimeTracker["is-visible"] = true

	CombatTimeTrackerFrame.name:SetText(encounterName)
	CombatTimeTrackerFrame.difficulty:SetText(currentDifficultyText)
	SetTimerText(FormatTime(displayedTime))

	local encounterKey = tostring(currentEncounterID)
	local difficultyKey = tostring(currentDifficultyID)
	local optionalKey = tostring(currentOptionalID)
	local encounterData = HRT.Data.combatEncounter[encounterKey] or {}
	HRT.Data.combatEncounter[encounterKey] = encounterData

	local difficultyData = encounterData[difficultyKey] or {}
	encounterData[difficultyKey] = difficultyData

	currentDataSet = difficultyData[optionalKey] or {
		bestVictory = -1,
		victories = 0,
		wipes = 0
	}
	difficultyData[optionalKey] = currentDataSet
	currentAttempt = {
		startedAt = GetServerTime()
	}
	currentBestVictory = currentDataSet.bestVictory

	if currentBestVictory >= HRT.COMBAT_TIME_TRACKER_THRESHOLD then
		CombatTimeTrackerFrame.timeBar:SetMinMaxValues(0, currentBestVictory)
		CombatTimeTrackerFrame.timeBar:SetValue(currentBestVictory)
		SetBarColor(CombatTimeTrackerConfig.timeBar.colors.withinBest)
	else
		CombatTimeTrackerFrame.timeBar:SetMinMaxValues(0, 1)
		CombatTimeTrackerFrame.timeBar:SetValue(1)
		SetBarColor(CombatTimeTrackerConfig.timeBar.colors.noBest)
	end

	CombatTimeTrackerFrame:SetScript("OnUpdate", UpdateTimerFrame)

	return true
end

function CombatTimeTracker:EncounterEnd(success)
	if not currentAttempt or not currentDataSet then return end

	CombatTimeTrackerFrame.resetButton:Show()
	CombatTimeTrackerFrame:SetScript("OnUpdate", nil)

	if success ~= 0 and success ~= 1 then
		currentAttempt = nil
		currentDataSet = nil

		return
	end

	local finalTime = GetTime() - startTime

	Utils:PrintDebugAdvanced(
		"Unrounded time: finalTime=%s",
		finalTime
	)

	if finalTime < HRT.COMBAT_TIME_TRACKER_THRESHOLD then
		finalTime = HRT.COMBAT_TIME_TRACKER_THRESHOLD
	else
		finalTime = math.floor(finalTime * 1000 + 0.5) / 1000
	end

	Utils:PrintDebugAdvanced(
		"Rounded time: finalTime=%s",
		finalTime
	)

	displayedTime = finalTime
	SetTimerText(FormatTime(finalTime))

	currentAttempt.endedAt = GetServerTime()
	currentAttempt.duration = finalTime
	currentAttempt.result = success == 1 and "victory" or "defeat"

	local dataSet = currentDataSet
	currentDataSet = nil
	dataSet[#dataSet + 1] = currentAttempt
	currentAttempt = nil

	local bestVictory = dataSet.bestVictory
	local victories = dataSet.victories
	local wipes = dataSet.wipes

	if success == 1 then
		victories = victories + 1
		dataSet.victories = victories

		if bestVictory < HRT.COMBAT_TIME_TRACKER_THRESHOLD or finalTime < bestVictory then
			dataSet.bestVictory = finalTime
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
		dataSet.wipes = wipes

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
	RefreshTimeFormat()
	SetTimerText(FormatTime(displayedTime))
end
