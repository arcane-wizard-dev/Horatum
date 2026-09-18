local addonName, HRT = ...

-- Library
local AWL = ArcaneWizardLibrary
local Addon = AWL:GetAddon(addonName)

-- Localization
local L = HRT.Localization

-- Current module
local Utils = HRT.Modules.Utils

-----------------------
--- Local Functions ---
-----------------------

local function PrintChatMessage(color, prefix, msg)
	DEFAULT_CHAT_FRAME:AddMessage(color:WrapTextInColorCode(prefix .. ": ") .. tostring(msg))
end

------------------------
--- Module Functions ---
------------------------

function Utils:PrintMessage(msg)
	PrintChatMessage(NORMAL_FONT_COLOR, addonName, msg)
end

function Utils:PrintDebug(msg)
	if HRT.Settings.general["debug-mode"] then
		PrintChatMessage(ORANGE_FONT_COLOR, addonName .. " (Debug)", msg)
	end
end

function Utils:OpenSettings()
	if not Addon:OpenCategory() then
		self:PrintDebug("In combat. The options menu cannot be opened.")
		return false
	end

	return true
end

function Utils:IsAccountProfile()
	local characterGUID = AWL.Utils:GetCharacterGUID()

	return Horatum_Options_v3.profileKeys[characterGUID]["use-account"]
end

function Utils:OpenSettingsOnLoading()
	local characterGUID = AWL.Utils:GetCharacterGUID()

	if Horatum_Options_v3.profileKeys[characterGUID]["open-settings"] then
		if not self:OpenSettings() then
			return
		end

		Horatum_Options_v3.profileKeys[characterGUID]["open-settings"] = false
	end
end

function Utils:ToggleCombatTimeTracker()
	if HRT.Modules.CombatTimeTracker:IsShown() then
		HRT.Modules.CombatTimeTracker:Hide()
	else
		HRT.Modules.CombatTimeTracker:Show()
	end
end

function Utils:ToggleProfileMode()
	local characterGUID = AWL.Utils:GetCharacterGUID()
	local useAccountProfile = self:IsAccountProfile()

	Horatum_Options_v3.profileKeys[characterGUID]["use-account"] = not useAccountProfile
	Horatum_Options_v3.profileKeys[characterGUID]["open-settings"] = true
end

function Utils:ResetAllCharacterProfiles()
	local characterGUID = AWL.Utils:GetCharacterGUID()

	Horatum_Options_v3.profiles = {}
	Horatum_Options_v3.profileKeys = {}

	Horatum_Options_v3.profileKeys[characterGUID] = {
		["use-account"] = true,
		["open-settings"] = true
	}
end

function Utils:InitializeDatabase()
	local characterGUID = AWL.Utils:GetCharacterGUID()

	if not characterGUID then
		return nil
	end

	local createdProfile = false
	local createdProfileKey = false

	local defaults = {
		["general"] = {
			["minimap-button"] = {
				["hide"] = false
			}
		},
		["combat-time-tracker"] = {
			["point"] = "CENTER",
			["relative-point"] = "CENTER",
			["offset-x"] = 0,
			["offset-y"] = 150,
			["scale"] = 100,
			["background-transparency"] = 60
		},
		["combat-overview"] = {}
	}

	if not Horatum_Options_v3 then
		Horatum_Options_v3 = {
			["account"] = AWL.Utils:CopyTable(defaults),
			["profiles"] = {},
			["profileKeys"] = {}
		}
	end

	if not Horatum_Options_v3.profiles[characterGUID] then
		Horatum_Options_v3.profiles[characterGUID] = AWL.Utils:CopyTable(defaults)
		createdProfile = true
	end

	if not Horatum_Options_v3.profileKeys[characterGUID] then
		Horatum_Options_v3.profileKeys[characterGUID] = {
			["use-account"] = true,
			["open-settings"] = false
		}
		createdProfileKey = true
	end

	local useAccountProfile = Horatum_Options_v3.profileKeys[characterGUID]["use-account"]

	if useAccountProfile then
		HRT.Settings.general = Horatum_Options_v3.account["general"]
		HRT.Settings.combatTimeTracker = Horatum_Options_v3.account["combat-time-tracker"]
		HRT.Settings.combatOverview = Horatum_Options_v3.account["combat-overview"]
	else
		HRT.Settings.general = Horatum_Options_v3.profiles[characterGUID]["general"]
		HRT.Settings.combatTimeTracker = Horatum_Options_v3.profiles[characterGUID]["combat-time-tracker"]
		HRT.Settings.combatOverview = Horatum_Options_v3.profiles[characterGUID]["combat-overview"]
	end

	if not Horatum_CombatEncounterData_v2 then
		Horatum_CombatEncounterData_v2 = {}
	end

	HRT.Data.combatEncounter = Horatum_CombatEncounterData_v2

	return {
		characterGUID = characterGUID,
		createdProfile = createdProfile,
		createdProfileKey = createdProfileKey,
		activeProfile = useAccountProfile and "account" or "character"
	}
end

function Utils:InitializeMinimapButton()
	self.minimapButton = Addon:RegisterMinimapButton({
		db = HRT.Settings.general["minimap-button"],
		tooltip = L["minimap-button.tooltip"],
		onLeftClick = function()
			Utils:ToggleCombatTimeTracker()
		end
	})
end
