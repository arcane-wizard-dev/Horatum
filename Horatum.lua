local addonName, HRT = ...

-- Library
local AWL = ArcaneWizardLibrary
local Addon = AWL:GetAddon(addonName)

-- Module imports
local CombatTimeTracker = HRT.Modules.CombatTimeTracker
local Options = HRT.Modules.Options
local Utils = HRT.Modules.Utils

-- Variables
local isInitialized = false
local isInCombat = false

--------------
--- Frames ---
--------------

local HoratumFrame = CreateFrame("Frame", "Horatum")

-----------------------
--- Local Functions ---
-----------------------

local function SlashCommand(msg)
	if not isInitialized then return end

	local command = strtrim(msg or "")

	if command == "" then
		Utils:OpenSettings()
	elseif command == "changelog" then
		AWL.Frames:OpenChangelog(addonName, HRT.CHANGELOG)
	elseif command == "show" then
		CombatTimeTracker:Show()
	else
		Utils:PrintDebug("These arguments are not accepted.")
	end
end

------------------------
--- Public Functions ---
------------------------

function HoratumFrame:OnEvent(event, ...)
	self[event](self, event, ...)
end

function HoratumFrame:ADDON_LOADED(_, addOnName)
	if addOnName ~= addonName or isInitialized then return end

	local dbInit = Utils:InitializeDatabase()

	if not dbInit then
		Addon:AbortInitialization(self)
		return
	end

	Utils:InitializeMinimapButton()
	Options:Initialize()
	CombatTimeTracker:Initialize()

	Addon:OpenSettingsOnLoading()

	isInitialized = true

	Utils:PrintDebug(string.format(
		"InitializeDatabase: key=%s, createdProfile=%s, createdProfileKey=%s, cleanedOptions=%s, activeProfile=%s",
		tostring(dbInit.characterGUID), tostring(dbInit.createdProfile), tostring(dbInit.createdProfileKey), tostring(dbInit.cleanedOptions), tostring(dbInit.activeProfile)
	))
	Utils:PrintDebug("Addon fully loaded.")
end

function HoratumFrame:ENCOUNTER_START(_, encounterID, encounterName, difficultyID, groupSize)
	Utils:PrintDebug(string.format(
		"Event 'ENCOUNTER_START' fired. Payload: encounterID=%s, encounterName=%s, difficultyID=%s, groupSize=%s",
		tostring(encounterID), tostring(encounterName), tostring(difficultyID), tostring(groupSize)
	))

	isInCombat = CombatTimeTracker:EncounterStart(encounterID, encounterName, difficultyID)

	if isInCombat then
		Utils:PrintDebug("The encounter has started.")
	end
end

function HoratumFrame:ENCOUNTER_END(_, encounterID, encounterName, difficultyID, groupSize, success)
	Utils:PrintDebug(string.format(
		"Event 'ENCOUNTER_END' fired. Payload: encounterID=%s, encounterName=%s, difficultyID=%s, groupSize=%s, success=%s",
		tostring(encounterID), tostring(encounterName), tostring(difficultyID), tostring(groupSize), tostring(success)
	))

	if isInCombat then
		CombatTimeTracker:EncounterEnd(success)
		isInCombat = false

		Utils:PrintDebug("The encounter has ended.")
	end
end

HoratumFrame:RegisterEvent("ADDON_LOADED")
HoratumFrame:RegisterEvent("ENCOUNTER_START")
HoratumFrame:RegisterEvent("ENCOUNTER_END")
HoratumFrame:SetScript("OnEvent", HoratumFrame.OnEvent)

SLASH_Horatum1, SLASH_Horatum2 = '/hrt', '/horatum'

SlashCmdList["Horatum"] = SlashCommand
