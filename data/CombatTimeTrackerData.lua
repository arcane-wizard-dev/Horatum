local _, HRT = ...

if HRT.State and HRT.State.libraryIncompatible then return end

HRT.COMBAT_TIME_TRACKER_THRESHOLD = 0.001
