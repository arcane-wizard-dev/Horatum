local _, HRT = ...

if HRT.State and HRT.State.libraryIncompatible then return end

HRT.UIConfig.CombatTimeTracker = {
	width = 200,
	initialHeight = 112,
	contentPadding = {x = 20, y = 20},
	timerOffset = 0,
	rowSpacing = 8,
	nameWidth = 160,
	difficultyWidth = 140,
	timeBar = {
		width = 160,
		height = 10,
		texture = "Interface\\TargetingFrame\\UI-StatusBar",
		colors = {
			idle = {0.5, 0.5, 0.5},
			withinBest = {0, 1, 0},
			overBest = {1, 0, 0},
			noBest = {0, 0.5, 1}
		},
		backgroundColor = {0.2, 0.2, 0.2, 0.8},
		border = {
			padding = 3,
			texture = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 8
		}
	},
	difficultySpacing = 3,
	style = "tooltip",
	backgroundColor = {0, 0, 0, 1},
	showCloseButton = true,
	closeButton = { size = 16, point = "TOPRIGHT", x = -8, y = -8 },
	resetButton = { size = 16, x = -8, y = 8 },
	movable = true,
	closeOnEscape = false
}
