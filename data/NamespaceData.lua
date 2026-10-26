local addonName, HRT = ...

if HRT.State and HRT.State.libraryIncompatible then return end

HRT.Settings = HRT.Settings or {}
HRT.Data = HRT.Data or {}
HRT.State = HRT.State or {}
HRT.UIConfig = HRT.UIConfig or {}
HRT.Modules = HRT.Modules or {}

HRT.Modules.CombatTimeTracker = HRT.Modules.CombatTimeTracker or {}
HRT.Modules.Options = HRT.Modules.Options or {}
HRT.Modules.Utils = HRT.Modules.Utils or {}

local AWL = ArcaneWizardLibrary

AWL:NewAddon(addonName)
