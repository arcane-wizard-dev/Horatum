local addonName, HRT = ...

local version = C_AddOns.GetAddOnMetadata(addonName, "Version") or ""
local buildDate = C_AddOns.GetAddOnMetadata(addonName, "X-BuildDate") or ""

HRT.CHANGELOG = {
	{
		version = version,
		date = buildDate ~= "" and buildDate or nil,
		entries = {
			"Added: ruRU localization",
			"Minor code adjustments"
		}
	},
	{
		version = "v2.31",
		date = "2026-10-05",
		entries = {
			"Changed: Combat Time Tracker now uses the native Blizzard UI appearance with an optional tooltip border",
			"Adapted to the latest version of Arcane Wizard: Library to ensure full compatibility"
		}
	},
	{
		version = "v2.30",
		date = "2026-10-03",
		entries = {
			"Updated: Logo"
		}
	},
	{
		version = "v2.29",
		date = "2026-09-27",
		entries = {
			"Minor code adjustments"
		}
	},
	{
		version = "v2.28",
		date = "2026-09-22",
		entries = {
			"Adapted to the latest version of Arcane Wizard: Library to ensure full compatibility",
			"Minor code adjustments"
		}
	},
	{
		version = "v2.27",
		date = "2026-09-20",
		entries = {
			"Added: Support for 'Forever'"
		}
	},
	{
		version = "v2.26",
		date = "2026-09-18",
		entries = {
			"Changed: Character profiles now use GUIDs",
			"Changed: Addon initialization stops if the player identity is unavailable"
		}
	},
	{
		version = "v2.25",
		date = "2026-09-13",
		entries = {
			"Updated: GitHub links following the organization rename to 'arcane-wizard-dev'"
		}
	},
	{
		version = "v2.24",
		date = "2026-09-06",
		entries = {
			"Added: TOC version for patch 12.1.5 [retail]"
		}
	},
	{
		version = "v2.23",
		date = "2026-08-30",
		entries = {
			"Minor code adjustments"
		}
	}
}
