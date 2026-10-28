local _, HRT = ...

if HRT.State and HRT.State.libraryIncompatible then return end

if GetLocale() ~= "deDE" then return end

local L = HRT.Localization

-- Options

L["options.general"] = "Allgemeine Einstellungen"
L["options.general.notification.name"] = "Chatbenachrichtigung"
L["options.general.notification.tooltip"] = "Zeigt nach dem Kampf eine Chatbenachrichtigung an."
L["options.general.minimap-button.name"] = "Minimap-Button"
L["options.general.minimap-button.tooltip"] = "Zeigt den Minimap-Button an."
L["options.general.debug-mode.name"] = "Debugmodus"
L["options.general.debug-mode.tooltip"] = "Zeigt zusätzliche Debuginformationen im Chat an."

L["options.combat-time-tracker"] = "Kampfzeitanzeige"
L["options.combat-time-tracker.show-border.name"] = "Rahmen anzeigen"
L["options.combat-time-tracker.show-border.tooltip"] = "Zeigt einen Rahmen um die Kampfzeitanzeige an."
L["options.combat-time-tracker.scale.name"] = "Skalierung"
L["options.combat-time-tracker.scale.tooltip"] = "Legt die Größe der Kampfzeitanzeige fest."
L["options.combat-time-tracker.background-transparency.name"] = "Hintergrundtransparenz"
L["options.combat-time-tracker.background-transparency.tooltip"] = "Legt die Hintergrundtransparenz der Kampfzeitanzeige fest."
L["options.combat-time-tracker.decimal-places.name"] = "Nachkommastellen"
L["options.combat-time-tracker.decimal-places.tooltip"] = "Legt fest, wie viele Nachkommastellen bei Kampfzeiten angezeigt werden."

-- General

L["minimap-button.tooltip"] = "|cnLINK_FONT_COLOR:Linksklick|r zum Anzeigen oder Ausblenden der Kampfzeitanzeige.\n|cnLINK_FONT_COLOR:Rechtsklick|r zum Öffnen der Einstellungen."

-- Chat

L["chat.current-record"] = "Aktuelle Bestzeit für |cnGOLD_FONT_COLOR:%s|r (%s): %s."
L["chat.new-record"] = "Neue Bestzeit für |cnGOLD_FONT_COLOR:%s|r (%s): %s."

L["chat.first-victory"] = "Erster Sieg über |cnGOLD_FONT_COLOR:%s|r (%s). (Niederlagen: %s)"
L["chat.another-victory"] = "|cnGOLD_FONT_COLOR:%s|r (%s) wurde bereits besiegt. (Siege: %s - Niederlagen: %s)"
L["chat.first-wipe"] = "Erste Niederlage gegen |cnGOLD_FONT_COLOR:%s|r (%s). (Siege: %s)"
L["chat.another-wipe"] = "Gegen |cnGOLD_FONT_COLOR:%s|r (%s) gab es bereits Niederlagen. (Siege: %s - Niederlagen: %s)"

-- Combat Time Tracker

L["combat-time-tracker.button-reset"] = "Anzeige zurücksetzen"
L["combat-time-tracker.wait-combat"] = "Warte auf Kampfbeginn…"
L["combat-time-tracker.dungeon"] = "Dungeon"
L["combat-time-tracker.raid"] = "Schlachtzug"
L["combat-time-tracker.event"] = "Ereignis"
L["combat-time-tracker.delves-tier"] = "Stufe"
