-- Synthetic SavedVariables: account, current and offline character profiles; preserve false and zero.
-- No real player data. Version "test" is the version supplied by the test harness.

Horatum_Options_v3 = {
	["account"] = {
		["combat-overview"] = {},
		["combat-time-tracker"] = {
			["background-transparency"] = 0,
			["decimal-places"] = 0,
			["is-visible"] = false,
			["offset-x"] = 42,
			["offset-y"] = 150,
			["point"] = "CENTER",
			["relative-point"] = "CENTER",
			["scale"] = 125,
			["show-border"] = true,
		},
		["general"] = {
			["debug-mode"] = false,
			["debug-level"] = "basic",
			["minimap-button"] = {
				["hide"] = false,
				["lock"] = false,
				["minimapPos"] = 90,
				["showInCompartment"] = false,
			},
			["notification"] = true,
		},
	},
	["global"] = {
		["version"] = "test",
	},
	["profileKeys"] = {
		["Player-TEST-CURRENT"] = {
			["open-settings"] = false,
			["use-account"] = false,
		},
		["Player-TEST-OFFLINE"] = {
			["open-settings"] = false,
			["use-account"] = true,
		},
	},
	["profiles"] = {
		["Player-TEST-CURRENT"] = {
			["combat-overview"] = {},
			["combat-time-tracker"] = {
				["background-transparency"] = 0,
				["decimal-places"] = 0,
				["is-visible"] = false,
				["offset-x"] = 42,
				["offset-y"] = 150,
				["point"] = "CENTER",
				["relative-point"] = "CENTER",
				["scale"] = 125,
				["show-border"] = true,
			},
			["general"] = {
				["debug-mode"] = false,
				["debug-level"] = "advanced",
				["minimap-button"] = {
					["hide"] = true,
					["lock"] = false,
					["minimapPos"] = 0,
					["showInCompartment"] = false,
				},
				["notification"] = true,
			},
		},
		["Player-TEST-OFFLINE"] = {
			["combat-overview"] = {},
			["combat-time-tracker"] = {
				["background-transparency"] = 0,
				["decimal-places"] = 0,
				["is-visible"] = false,
				["offset-x"] = 42,
				["offset-y"] = 150,
				["point"] = "CENTER",
				["relative-point"] = "CENTER",
				["scale"] = 125,
				["show-border"] = true,
			},
			["general"] = {
				["debug-mode"] = false,
				["debug-level"] = "basic",
				["minimap-button"] = {
					["hide"] = false,
					["lock"] = false,
					["minimapPos"] = 270,
					["showInCompartment"] = false,
				},
				["notification"] = true,
			},
		},
	},
}

Horatum_CombatEncounterData = {
	["123"] = {
		["14"] = {
			["0"] = {
				["bestVictory"] = 105.25,
				["victories"] = 2,
				["wipes"] = 0,
				{
					["startedAt"] = 1793520000,
					["endedAt"] = 1793520105,
					["duration"] = 105.25,
					["result"] = "victory",
				},
			},
		},
		["208"] = {
			["8"] = {
				["bestVictory"] = 65.125,
				["victories"] = 1,
				["wipes"] = 2,
				{
					["startedAt"] = 1793520300,
					["endedAt"] = 1793520365,
					["duration"] = 65.125,
					["result"] = "victory",
				},
			},
			["11"] = {
				["bestVictory"] = -1,
				["victories"] = 0,
				["wipes"] = 1,
				{
					["startedAt"] = 1793520400,
					["endedAt"] = 1793520425,
					["duration"] = 25.5,
					["result"] = "defeat",
				},
			},
		},
	},
}
