local ADDON_NAME = ...
local ADDON_VERSION = GetAddOnMetadata(ADDON_NAME, "Version")

TimeTrack = {}
TimeTrack.__index = TimeTrack
TimeTrack.debug_ = true

TimeTrack.events_ = {
   "ADDON_LOADED",
   "VARIABLES_LOADED",
   "PLAYER_ENTERING_WORLD",
   "TIME_PLAYED_MSG"
}

TimeTrack_Options = {
   mode = "total",
   scale = 1.0
}

---------------------------
---- Utility functions ----
---------------------------

-- Function: ripairs
-- Descr: reverse ipairs (from LUA website)
local function ripairs(t)
  local max = 1
  while t[max] ~= nil do
    max = max + 1
  end
  local function ripairs_it(t, i)
    i = i-1
    local v = t[i]
    if v ~= nil then
      return i,v
    else
      return nil
    end
  end
  return ripairs_it, t, max
end

local function time_string(t)
   local total = t
   local seconds = math.floor(total % 60)
   local minutes = math.floor((total / 60) % 60)
   local hours = math.floor((total / 3600) % 24)
   local days = math.floor(total / 3600 / 24)
   -- strftime equivalent would be nice here
   return days .. "d " .. hours .. "h " .. minutes .. "min " .. seconds .. "sec"
end

--------------------------
---- Main addon logic ----
--------------------------

function TimeTrack:check_tracking_opt(opt, value)
   return TimeTrack_Options[opt] == value
end

function TimeTrack:set_tracking_opt(opt, value)
   TimeTrack_Options[opt] = value
   self:refresh_mainframe()
end

-- Function: initialize
-- Descr: Initialize the addon
function TimeTrack:on_load()
   self:create_mainframe()
end

-- Function: create_mainframe
-- Descr: Creates the main frame for the addon and registers events
--        for the frame
function TimeTrack:create_mainframe()
   self.frame = TimeTrack_MainFrame
   self.frame:Show()

   for _, event in ipairs(self.events_) do
      self.frame:RegisterEvent(event)
   end

   -- Calls the associated event handlers
   self.frame:SetScript("OnEvent", function(frame, event, ...) self[event](self, ...) end)
   self.frame:SetScript("OnUpdate", function(frame, elapsed) self:on_update(elapsed) end)
end

function TimeTrack:update_mainframe()
   if TimeTrack_Options.mode == "total" then
      TimeTrack_MainFrame_GoldText:SetText(time_string(self.player.played_total))
   else
      TimeTrack_MainFrame_GoldText:SetText(time_string(self.player.played_current))
   end
end

function TimeTrack:refresh_mainframe()
   self.frame:SetScale(TimeTrack_Options.scale)
   self:update_mainframe()
end

-- Function: print
-- Descr: Print the message in the default chat frame
function TimeTrack:print(msg)
   ChatFrame1:AddMessage("|cff00ffcc" .. ADDON_NAME .. "|r: " .. msg)
end

-- Function: debug_print
-- Descr: Print a debug message
function TimeTrack:debug_print(msg)
   if true then
      self:print(msg)
   end
end

function TimeTrack:initialize()
   local name, _  = UnitName("player")
   local _, class = UnitClass("player")
   local realm    = GetRealmName()
   local faction  = UnitFactionGroup("player")


   self.player = {
      name = name,
      class = class,
      realm = realm,
      faction = faction,
      played_total = 0,
      played_current = 0,
   }

   self.session_start = time()
end

function TimeTrack:on_update(elapsed)
   if self.player.played_total then
      self.player.played_total = self.player.played_total + elapsed
   end
   
   if self.player.played_current then
      self.player.played_current = self.player.played_current + elapsed
   end
   
   self:update_mainframe();
end

------------------------
---- Event handlers ----
------------------------

-- Event: ADDON_LOADED
-- Descr: Called when the addon is loaded, setup the
--        database and other required stuff
function TimeTrack:ADDON_LOADED(addon)
   -- Ignore events for other addons
   if addon ~= ADDON_NAME then
      return
   end

   self:initialize()
end

function TimeTrack:VARIABLES_LOADED()
   self:refresh_mainframe()
end

-- Event: PLAYER_ENTERING_WORLD
-- Descr: Called when player enters world (Loading screens),
--        get money if not already present
function TimeTrack:PLAYER_ENTERING_WORLD()
   RequestTimePlayed()
end

function TimeTrack:TIME_PLAYED_MSG(total, current)
   self.player.played_total = total
   self.player.played_current = current
end

-- Call initialize to setup the addon
TimeTrack:on_load()
