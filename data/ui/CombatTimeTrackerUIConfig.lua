local _, HRT = ...

if HRT.State and HRT.State.libraryIncompatible then return end

HRT.UIConfig.CombatTimeTracker = {
	width = 200,
	initialHeight = 112,
	contentPadding = {x = 20, y = 20},
	timerOffset = 0,
	rowSpacing = 8,
	difficultySpacing = 3,
	style = "tooltip",
	backgroundColor = {0, 0, 0, 1},
	showCloseButton = true,
	closeButton = { size = 16, point = "TOPRIGHT", x = -8, y = -8 },
	resetButton = { size = 16, x = -8, y = 8 },
	movable = true,
	closeOnEscape = false
}
