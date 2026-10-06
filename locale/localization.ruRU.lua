local _, HRT = ...

if GetLocale() ~= "ruRU" then return end

local L = HRT.Localization

-- Options

L["options.general"] = "Общие параметры"
L["options.general.notification.name"] = "Уведомления в чате"
L["options.general.notification.tooltip"] = "Включает уведомления в чате после боя."
L["options.general.minimap-button.name"] = "Кнопка у мини-карты"
L["options.general.minimap-button.tooltip"] = "Если этот параметр включен, кнопка отображается у мини-карты."
L["options.general.debug-mode.name"] = "Режим отладки"
L["options.general.debug-mode.tooltip"] = "Если режим отладки включен, в чате отображается дополнительная информация."

L["options.combat-time-tracker"] = "Таймер боя"
L["options.combat-time-tracker.show-border.name"] = "Показывать рамку"
L["options.combat-time-tracker.show-border.tooltip"] = "Показывает рамку вокруг таймера боя."
L["options.combat-time-tracker.scale.name"] = "Масштаб интерфейса"
L["options.combat-time-tracker.scale.tooltip"] = "Определяет масштаб таймера боя."
L["options.combat-time-tracker.background-transparency.name"] = "Прозрачность фона"
L["options.combat-time-tracker.background-transparency.tooltip"] = "Определяет прозрачность фона таймера боя."
L["options.combat-time-tracker.decimal-places.name"] = "Знаков после запятой"
L["options.combat-time-tracker.decimal-places.tooltip"] = "Определяет количество знаков после запятой при отображении времени боя."

-- General

L["minimap-button.tooltip"] = "|cnLINK_FONT_COLOR:Щелкните левой кнопкой мыши|r, чтобы показать или скрыть таймер боя.\n|cnLINK_FONT_COLOR:Щелкните правой кнопкой мыши|r, чтобы открыть настройки."

-- Chat

L["chat.current-record"] = "Ваш текущий рекорд: |cnGOLD_FONT_COLOR:%s|r (%s) — %s."
L["chat.new-record"] = "Ваш новый рекорд: |cnGOLD_FONT_COLOR:%s|r (%s) — %s."

L["chat.first-victory"] = "Ваша первая победа: |cnGOLD_FONT_COLOR:%s|r (%s). (Поражений: %s)"
L["chat.another-victory"] = "Повторная победа: |cnGOLD_FONT_COLOR:%s|r (%s). (Побед: %s — Поражений: %s)"
L["chat.first-wipe"] = "Ваше первое поражение: |cnGOLD_FONT_COLOR:%s|r (%s). (Побед: %s)"
L["chat.another-wipe"] = "Повторное поражение: |cnGOLD_FONT_COLOR:%s|r (%s). (Побед: %s — Поражений: %s)"

-- Combat Time Tracker

L["combat-time-tracker.button-reset"] = "Сбросить показания"
L["combat-time-tracker.wait-combat"] = "Ожидание начала боя..."
L["combat-time-tracker.dungeon"] = "Подземелье"
L["combat-time-tracker.raid"] = "Рейд"
L["combat-time-tracker.delves-tier"] = "Уровень"
