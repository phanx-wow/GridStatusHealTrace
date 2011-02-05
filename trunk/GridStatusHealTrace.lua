------------------------------------------------------------------------
--	GridStatusHealTrace
--	Shows who was healed by your multi-target heals.
--	by Akkorian < akkorian@hotmail.com >
--	Inspired by GridStatusChainWho by Llyra
--	Copyright � 2010�2011 Akkorian. Some rights reserved. See LICENSE.txt for details.
--	http://www.wowinterface.com/downloads/info16608-GridStatusHealTrace.html
--	http://wow.curse.com/downloads/wow-addons/details/gridstatushealtrace.aspx
------------------------------------------------------------------------

local GridStatusHealTrace = Grid:NewStatusModule( "GridStatusHealTrace" )
local active, spellOrder, playerGUID, settings, spells = {}, {}

local L = setmetatable( {}, { __index = function( t, k )
	if not k then return "" end
	local v = tostring( k )
	t[ k ] = v
	return v
end } )

if GetLocale() == "esES" or GetLocale() == "esMX" then
	L["Heal Trace"] = "Sanaciones seguimiento"
	L["Hold time"] = "Tiempo para mostrar"
	L["Show the status for this many seconds."] = "Mostrar el estado por estos segundos."
	L["Add new spell"] = "A�adir hechizo"
	L["Add another healing spell to trace."] = "A�adir otro hechizo de curaci�n para seguir."
	L["<spell name or spell ID>"] = "<nombre o ID de hechizo>"
	L["Remove spell"] = "Eliminar hechizo"
	L["Remove a spell from the trace list"] = "Eliminar un hechizo de la lista de seguimiento."
	L["Remove %s from the trace list."] = "Eliminar %s de la lista de seguimiento."
end

------------------------------------------------------------------------

GridStatusHealTrace.defaultDB = {
	alert_healTrace = {
		color = { r = 0.8, g = 1.0, b = 0.2, a = 1 },
		enable = true,
		holdTime = 1,
		priority = 75,
		range = false,
		spells = {},
	}
}
for _, spellID in ipairs( {
	1064,  -- Chain Heal
	34861, -- Circle of Healing
	64844, -- Divine Hymn
	15237, -- Holy Nova
	85222, -- Light of Dawn
} ) do
	local name, _, icon = GetSpellInfo( spellID )
	GridStatusHealTrace.defaultDB.alert_healTrace.spells[ name ] = icon
end

------------------------------------------------------------------------

GridStatusHealTrace.statusOptions = {
	holdTime = {
		name = L["Hold time"],
		desc = L["Show the status for this many seconds."],
		type = "range", min = 0.25, max = 5, step = 0.25,
		get = function()
			return GridStatusHealTrace.db.profile.alert_healTrace.holdTime
		end,
		set = function( _, v )
			GridStatusHealTrace.db.profile.alert_healTrace.holdTime = v
		end,
	},
	addSpell = {
		order = -2, width = "double",
		name = L["Add new spell"],
		desc = L["Add another healing spell to trace."],
		type = "input", usage = L["<spell name or spell ID>"],
		get = false,
		set = function( _, v )
			GridStatusHealTrace:AddSpell( string.trim( v ) )
		end,
	},
	removeSpell = {
		order = -1,
		name = L["Remove spell"],
		desc = L["Remove a spell from the trace list."],
		type = "group", dialogInline = true,
		args = {},
	},
}

------------------------------------------------------------------------

function GridStatusHealTrace:AddSpell( name, icon )
	local id = name:match( "(%d+)" )
	if id then
		local _
		name, _, icon = GetSpellInfo( tonumber( id ) )
	elseif type( icon ) ~= "string" then
		icon = nil
	end

	if not name then return end

	self.db.profile.alert_healTrace.spells[ name ] = icon or true

	self.statusOptions.removeSpell.args[ name ] = {
		name = string.format( "|T%s:0:0:0:0:32:32:2:30:2:30|t %s", icon, name ),
		desc = string.format( L["Remove %s from the trace list."], name ),
		type = "execute",
		func = function()
			self.db.profile.alert_healTrace.spells[ name ] = nil
			self.statusOptions.removeSpell.args[ name ] = nil
		end,
	}

	if not spellOrder[ name ] then
		spellOrder[ name ] = true
		spellOrder[ #spellOrder + 1 ] = name
		table.sort( spellOrder )
		for i = 1, #spellOrder do
			self.statusOptions.removeSpell.args[ spellOrder[ i ] ].order = i
		end
	end
end

------------------------------------------------------------------------

function GridStatusHealTrace:PostInitialize()
	self:RegisterStatus( "alert_healTrace", L["Heal Trace"], self.statusOptions, true )

	settings = self.db.profile.alert_healTrace
	spells = settings.spells

	for name, icon in pairs( spells ) do
		self:AddSpell( name, icon )
	end
end

function GridStatusHealTrace:PostEnable()
	playerGUID = UnitGUID( "player" )
end

function GridStatusHealTrace:OnStatusEnable( status )
	self:RegisterEvent( "COMBAT_LOG_EVENT_UNFILTERED" )
end

function GridStatusHealTrace:OnStatusDisable( status )
	self:UnregisterAllEvents()
	self.core:SendStatusLostAllUnits( "alert_healTrace" )
end

function GridStatusHealTrace:PostReset()
	self.core:SendStatusLostAllUnits( "alert_healTrace" )

	settings = self.db.profile.alert_healTrace
	spells = settings.spells
	for name in pairs( self.statusOptions.removeSpell.args ) do
		if not spells[ name ] then
			self.statusOptions.removeSpell.args[ name ] = nil
		end
	end
	for name, icon in pairs( spells ) do
		if not self.statusOptions.removeSpell.args[ name ] then
			self:AddSpell( name, icon )
		end
	end
end

------------------------------------------------------------------------

local timerFrame = CreateFrame( "Frame" )
timerFrame:Hide()
timerFrame:SetScript( "OnUpdate", function( self, elapsed )
	local i = 0
	for destGUID, holdTime in pairs( active ) do
		holdTime = holdTime - elapsed
		if holdTime <= 0 then
			GridStatusHealTrace.core:SendStatusLost( destGUID, "alert_healTrace" )
			active[ destGUID ] = nil
		else
			active[ destGUID ] = holdTime
			i = i + 1
		end
	end
	if i == 0 then
		self:Hide()
	end
end )

function GridStatusHealTrace:COMBAT_LOG_EVENT_UNFILTERED( _, timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellID, spellName )
	if sourceGUID ~= playerGUID or event ~= "SPELL_HEAL" or not spells[ spellName ] then return end

	local spellIcon = spells[ spellName ]
	if type( spellIcon ) == "boolean" then
		local _, _, icon = GetSpellInfo( spellID )
		self.statusOptions.removeSpell.args[ spellName ].icon = icon
		spells[ spellName ] = icon
		spellIcon = icon
	end

	self.core:SendStatusGained(destGUID, "alert_healTrace",
		settings.priority,
		settings.range,
		settings.color,
		spellName,
		nil,
		nil,
		spellIcon
	)

	active[ destGUID ] = settings.holdTime
	timerFrame:Show()
end