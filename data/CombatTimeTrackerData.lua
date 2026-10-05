local _, HRT = ...

HRT.COMBAT_TIME_TRACKER_THRESHOLD = 0.001

HRT.COMBAT_TIME_TRACKER_FRAME_DATA = {
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
