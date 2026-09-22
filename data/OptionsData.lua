local _, HRT = ...

HRT.OPTIONS_DEFAULTS = {
	["general"] = {
		["minimap-button"] = {
			["hide"] = false,
			["minimapPos"] = 225,
			["lock"] = false,
			["showInCompartment"] = false
		},
		["notification"] = true,
		["debug-mode"] = false,
	},
	["combat-time-tracker"] = {
		["scale"] = 100,
		["background-transparency"] = 60,
		["decimal-places"] = 3,
		["point"] = "CENTER",
		["relative-point"] = "CENTER",
		["offset-x"] = 0,
		["offset-y"] = 150,
		["is-visible"] = false,
	},
	["combat-overview"] = {
	},
}
