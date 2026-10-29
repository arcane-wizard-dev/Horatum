-- Synthetic SavedVariables: previous addon version with the current database schema; fill defaults and remove obsolete options.
-- No real player data. Version "test" is the version supplied by the test harness.

Horatum_Options_v3 = {
	["account"] = {
		["combat-overview"] = {
			["obsolete-option"] = 1,
		},
		["combat-time-tracker"] = {
			["background-transparency"] = 0,
			["decimal-places"] = 0,
			["is-visible"] = false,
			["obsolete-option"] = 1,
			["offset-x"] = 42,
			["scale"] = 125,
		},
		["general"] = {
			["debug-mode"] = "obsolete-type",
			["minimap-button"] = {
				["hide"] = false,
				["minimapPos"] = 90,
				["obsolete"] = true,
			},
		},
		["obsolete-section"] = {
			["enabled"] = true,
		},
	},
	["global"] = {
		["obsolete"] = true,
		["version"] = "fixture-previous",
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
			["combat-overview"] = {
				["obsolete-option"] = 1,
			},
			["combat-time-tracker"] = {
				["background-transparency"] = 0,
				["decimal-places"] = 0,
				["is-visible"] = false,
				["obsolete-option"] = 1,
				["offset-x"] = 42,
				["scale"] = 125,
			},
			["general"] = {
				["debug-mode"] = "obsolete-type",
				["minimap-button"] = {
					["hide"] = true,
					["minimapPos"] = 0,
					["obsolete"] = true,
				},
			},
			["obsolete-section"] = {
				["enabled"] = true,
			},
		},
		["Player-TEST-OFFLINE"] = {
			["combat-overview"] = {
				["obsolete-option"] = 1,
			},
			["combat-time-tracker"] = {
				["background-transparency"] = 0,
				["decimal-places"] = 0,
				["is-visible"] = false,
				["obsolete-option"] = 1,
				["offset-x"] = 42,
				["scale"] = 125,
			},
			["general"] = {
				["debug-mode"] = "obsolete-type",
				["minimap-button"] = {
					["hide"] = false,
					["minimapPos"] = 270,
					["obsolete"] = true,
				},
			},
			["obsolete-section"] = {
				["enabled"] = true,
			},
		},
	},
}

Horatum_CombatEncounterData = {
	["123"] = {
		["14"] = {
			["0"] = {
				["bestVictory"] = 92.375,
				["victories"] = 3,
				["wipes"] = 2,
			},
		},
		["15"] = {
			["0"] = {
				["bestVictory"] = -1,
				["victories"] = 0,
				["wipes"] = 1,
			},
		},
	},
	["456"] = {
		["1"] = {
			["0"] = {
				["bestVictory"] = 45.25,
				["victories"] = 1,
				["wipes"] = 0,
			},
		},
	},
}
