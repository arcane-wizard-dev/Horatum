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

function Utils:ToggleCombatTimeTracker()
	if HRT.Modules.CombatTimeTracker:IsShown() then
		HRT.Modules.CombatTimeTracker:Hide()
	else
		HRT.Modules.CombatTimeTracker:Show()
	end
end

function Utils:InitializeDatabase()
	local dbInit = Addon:InitializeOptions({
		databaseName = "Horatum_Options_v3",
		defaults = HRT.OPTIONS_DEFAULTS,
		onOpenSettings = function()
			return self:OpenSettings()
		end
	})

	if not dbInit then
		return nil
	end

	HRT.Settings.global = dbInit.global
	HRT.Settings.general = dbInit.settings["general"]
	HRT.Settings.combatTimeTracker = dbInit.settings["combat-time-tracker"]
	HRT.Settings.combatOverview = dbInit.settings["combat-overview"]

	if not Horatum_CombatEncounterData_v2 then
		Horatum_CombatEncounterData_v2 = {}
	end

	HRT.Data.combatEncounter = Horatum_CombatEncounterData_v2

	return dbInit
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
