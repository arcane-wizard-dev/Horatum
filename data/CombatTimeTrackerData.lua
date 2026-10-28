local _, HRT = ...

if HRT.State and HRT.State.libraryIncompatible then return end

HRT.COMBAT_TIME_TRACKER_THRESHOLD = 0.001

HRT.COMBAT_TIME_TRACKER_DATA = {
	maximumDecimalPlaces = 3,
	difficultyLabels = {
		[1] = "combat-time-tracker.dungeon",
		[2] = "combat-time-tracker.dungeon",
		[23] = "combat-time-tracker.dungeon",
		[24] = "combat-time-tracker.dungeon",
		[205] = "combat-time-tracker.dungeon",
		[3] = "combat-time-tracker.raid",
		[4] = "combat-time-tracker.raid",
		[5] = "combat-time-tracker.raid",
		[6] = "combat-time-tracker.raid",
		[9] = "combat-time-tracker.raid",
		[14] = "combat-time-tracker.raid",
		[15] = "combat-time-tracker.raid",
		[16] = "combat-time-tracker.raid",
		[17] = "combat-time-tracker.raid",
		[19] = "combat-time-tracker.event",
		[33] = "combat-time-tracker.raid",
		[220] = "combat-time-tracker.raid",
		[233] = "combat-time-tracker.raid",
		[250] = "combat-time-tracker.raid"
	},
	delve = {
		difficultyID = 208,
		tierWidgetID = 6183,
		firstSpecialWidgetID = 6184,
		secondSpecialWidgetID = 6185,
		firstSpecialTier = 8,
		secondSpecialTier = 11
	}
}
