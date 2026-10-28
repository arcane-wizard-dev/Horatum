local _, HRT = ...

if HRT.State and HRT.State.libraryIncompatible then return end

HRT.Localization = setmetatable({}, {
	__index=function(self, key)
		rawset(self, key, key)

		geterrorhandler()("Horatum (Debug): Missing entry for '" .. tostring(key) .. "'")

		return key
	end
})

local L = HRT.Localization

-- Options

L["options.general"] = "General Options"
L["options.general.notification.name"] = "Chat Notification"
L["options.general.notification.tooltip"] = "Displays a chat notification after combat."
L["options.general.minimap-button.name"] = "Minimap Button"
L["options.general.minimap-button.tooltip"] = "Shows the minimap button."
L["options.general.debug-mode.name"] = "Debug Mode"
L["options.general.debug-mode.tooltip"] = "Displays additional debug information in the chat."

L["options.combat-time-tracker"] = "Combat Time Tracker"
L["options.combat-time-tracker.show-border.name"] = "Show Border"
L["options.combat-time-tracker.show-border.tooltip"] = "Shows a border around the Combat Time Tracker."
L["options.combat-time-tracker.scale.name"] = "Scale"
L["options.combat-time-tracker.scale.tooltip"] = "Sets the scale of the Combat Time Tracker."
L["options.combat-time-tracker.background-transparency.name"] = "Background Transparency"
L["options.combat-time-tracker.background-transparency.tooltip"] = "Sets the background transparency of the Combat Time Tracker."
L["options.combat-time-tracker.decimal-places.name"] = "Decimal Places"
L["options.combat-time-tracker.decimal-places.tooltip"] = "Sets how many decimal places are displayed for combat times."

-- General

L["minimap-button.tooltip"] = "|cnLINK_FONT_COLOR:Left-click|r to show or hide the Combat Time Tracker.\n|cnLINK_FONT_COLOR:Right-click|r to open the options."

-- Chat

L["chat.current-record"] = "Current best time for |cnGOLD_FONT_COLOR:%s|r (%s): %s."
L["chat.new-record"] = "New best time for |cnGOLD_FONT_COLOR:%s|r (%s): %s."

L["chat.first-victory"] = "First victory over |cnGOLD_FONT_COLOR:%s|r (%s). (Wipes: %s)"
L["chat.another-victory"] = "|cnGOLD_FONT_COLOR:%s|r (%s) has already been defeated. (Victories: %s - Wipes: %s)"
L["chat.first-wipe"] = "First wipe against |cnGOLD_FONT_COLOR:%s|r (%s). (Victories: %s)"
L["chat.another-wipe"] = "There have already been wipes against |cnGOLD_FONT_COLOR:%s|r (%s). (Victories: %s - Wipes: %s)"

-- Combat Time Tracker

L["combat-time-tracker.button-reset"] = "Reset Display"
L["combat-time-tracker.wait-combat"] = "Waiting for combat to begin…"
L["combat-time-tracker.dungeon"] = "Dungeon"
L["combat-time-tracker.raid"] = "Raid"
L["combat-time-tracker.event"] = "Event"
L["combat-time-tracker.delves-tier"] = "Tier"
