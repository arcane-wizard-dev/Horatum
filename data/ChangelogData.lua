local addonName, HRT = ...

if HRT.State and HRT.State.libraryIncompatible then return end

local version = C_AddOns.GetAddOnMetadata(addonName, "Version") or ""
local buildDate = C_AddOns.GetAddOnMetadata(addonName, "X-BuildDate") or ""

HRT.CHANGELOG = {
	notices = {},
	-- BEGIN GENERATED CHANGELOG
	{
		version = version,
		date = buildDate ~= "" and buildDate or nil,
		entries = {
			"Added: TOC version for patch 12.1.7 [retail]",
			"Changed: Combat times, victories, and wipes are now saved per character, starting with empty records",
			"Updated: Addon description",
			"Removed: TOC version for patch 12.1.0 [retail]"
		}
	},
	{
		version = "v2.37",
		date = "2026-10-28",
		entries = {
			"Added: Startup check for the minimum required Library revision",
			"Updated: deDE, enUS, ruRU localizations",
			"Updated: Addon description",
			"Minor code adjustments"
		}
	},
	{
		version = "v2.36",
		date = "2026-10-21",
		entries = {
			"Changed: Chat command 'show' renamed to 'tracker'"
		}
	},
	{
		version = "v2.35",
		date = "2026-10-16",
		entries = {
			"Adapted to the latest version of Arcane Wizard: Library to ensure full compatibility"
		}
	},
	{
		version = "v2.34",
		date = "2026-10-14",
		entries = {
			"Fixed: Repeated error messages for missing translations"
		}
	},
	{
		version = "v2.33",
		date = "2026-10-12",
		entries = {
			"Refactoring of the addon structure and source code"
		}
	},
	{
		version = "v2.32",
		date = "2026-10-09",
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
	}
	-- END GENERATED CHANGELOG
}
