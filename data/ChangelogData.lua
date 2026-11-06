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
			"Changed: The Basic debug level now shows important messages, while Advanced also includes technical details",
			"Updated: deDE, enUS, ruRU localizations"
		}
	},
	{
		version = "v2.42",
		date = "2026-11-05",
		entries = {
			"Changed: Debug messages are now converted and formatted only when debug mode is enabled",
			"Requires Arcane Wizard: Library revision 4 or later"
		}
	},
	{
		version = "v2.41",
		date = "2026-11-03",
		entries = {
			"Added: Completed boss attempts are saved with start and end times, duration, and victory or defeat result",
			"Changed: The debug mode option now combines an enable checkbox with a Basic or Advanced level selector",
			"Updated: deDE, enUS, ruRU localizations",
			"Requires Arcane Wizard: Library revision 2 or later",
			"Minor code adjustments"
		}
	},
	{
		version = "v2.40",
		date = "2026-11-01",
		entries = {
			"Changed: The TOC now excludes only Talebound by game type"
		}
	},
	{
		version = "v2.39",
		date = "2026-11-01",
		entries = {
			"Changed: Clarified labels in the options menu",
			"Changed: Limited loading to Retail and Forever",
			"Updated: deDE, enUS, ruRU localizations"
		}
	},
	{
		version = "v2.38",
		date = "2026-10-29",
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
	}
	-- END GENERATED CHANGELOG
}
