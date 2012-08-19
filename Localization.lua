--[[--------------------------------------------------------------------
	GridStatusHealTrace
	Shows in Grid who was healed by your multi-target heals.
	Copyright (c) 2010-2012 Akkorian, Phanx. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info16608-GridStatusHealTrace.html
	http://www.curse.com/addons/wow/gridstatushealtrace
----------------------------------------------------------------------]]

local _, ns = ...

local L = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	t[k] = v
	return v
end })
ns.L = L

local LOCALE = GetLocale()

if LOCALE == "deDE" then
	L["Heal Trace"] = "Heilungen verfolgen"
	L["Hold time"] = "Zeit für"
	L["Show the status for this many seconds."] = "Zeigt den Status für diese Anzahl an Sekunden."
	L["Add new spell"] = "Neuen Zauber hinzufügen"
	L["Add another healing spell to trace."] = "Fügt einen neuen Heilungszauber zu der Verfolgungsliste."
	L["<spell name or spell ID>"] = "<Namen oder ID der Heilungszauber>"
	L["Remove spell"] = "Zauber entfernen"
	L["Remove a spell from the trace list."] = "Entfert einen Heilungszauber aus der Verfolgungsliste."
	L["Remove %s from the trace list."] = "Entfert den Heilungszauber '%s' aus der Verfolgungsliste."
return end

if LOCALE == "esES" or LOCALE == "esMX" then
	L["Heal Trace"] = "Sanaciones seguidos"
	L["Hold time"] = "Tiempo para mostrar"
	L["Show the status for this many seconds."] = "Mostrar el estado por estos segundos."
	L["Add new spell"] = "Añadir hechizo"
	L["Add another healing spell to trace."] = "Añadir un otro hechizo de sanación para seguir."
	L["<spell name or spell ID>"] = "<nombre o ID de hechizo>"
	L["Remove spell"] = "Borrar hechizo"
	L["Remove a spell from the trace list."] = "Borrar un hechizo de la lista para seguir."
	L["Remove %s from the trace list."] = "Borrar %s de la lista para seguir."
return end

if LOCALE == "frFR" then
	L["Heal Trace"] = "Soins suivi"
	L["Hold time"] = "Temps de montrer"
	L["Show the status for this many seconds."] = "Afficher le statut de ce nombre de secondes."
	L["Add new spell"] = "Ajouter sort"
	L["Add another healing spell to trace."] = "Ajouter une autre sort de soins à suivre."
	L["<spell name or spell ID>"] = "<nom ou ID de sort>"
	L["Remove spell"] = "Supprimer sort"
	L["Remove a spell from the trace list."] = "Supprimer un sort de la liste à suivre."
	L["Remove %s from the trace list."] = "Supprimer %s de la liste à suivre."
return end

if LOCALE == "itIT" then
	L["Heal Trace"] = "Cure seguite"
	L["Hold time"] = "Momento di mostrare"
	L["Show the status for this many seconds."] = "Visualizza lo stato per questo molti secondi."
	L["Add new spell"] = "Aggiungi incantesimo"
	L["Add another healing spell to trace."] = "Aggiungere un altro incantesimo di cura da seguire."
	L["<spell name or spell ID>"] = "<nome o ID di incantesimo>"
	L["Remove spell"] = "Rimuovere incantesimo"
	L["Remove a spell from the trace list."] = "Rimuovere un incantesimo alla lista da seguire."
	L["Remove %s from the trace list."] = "Rimuovere %s alla lista da seguire."
return end

if LOCALE == "ptBR" then
	L["Heal Trace"] = "Curas seguidas"
	L["Hold time"] = "Tempo para mostrar"
	L["Show the status for this many seconds."] = "Mostrar o estado para isso muitos segundos."
	L["Add new spell"] = "Adicionar feitiço"
	L["Add another healing spell to trace."] = "Adicionar outra feitiço de cura para seguir."
	L["<spell name or spell ID>"] = "<nome ou ID de feitiço>"
	L["Remove spell"] = "Remover feitiço"
	L["Remove a spell from the trace list."] = "Remover um feitiço à lista para seguir."
	L["Remove %s from the trace list."] = "Remover %s à lista para seguir."
return end

if LOCALE == "koKR" then -- Last updated 2011-12-12 by Sayclub @ CurseForge
	L["Heal Trace"] = "치유 추적"
	L["Hold time"] = "유지 시간"
	L["Show the status for this many seconds."] = "몇 초 동안 상태 창에 표시할지 설정합니다."
	L["Add new spell"] = "새로운 주문 추가"
	L["Add another healing spell to trace."] = "추적 목록에 치유 주문을 추가합니다."
	L["<spell name or spell ID>"] = "<주문 이름이나 주문 ID>"
	L["Remove spell"] = "주문 제거"
	L["Remove a spell from the trace list."] = "추적 목록에서 주문을 제거합니다."
	L["Remove %s from the trace list."] = "추적 목록에서 %s|1을;를; 제거합니다."
return end