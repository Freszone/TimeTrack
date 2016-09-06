-----------------------------
---- TimeTrack_MainFrame ----
-----------------------------
function TimeTrack_MainFrame_OnMouseDown(self, button)
   if button == "LeftButton" then
      if not self.isMoving then
         self:StartMoving()
         self.isMoving = true
      end
   end

end

function TimeTrack_MainFrame_OnMouseUp(self, button)
   if button == "RightButton" then
      ToggleDropDownMenu(1, nil, TimeTrack_MainMenu, "TimeTrack_MainFrame", 0, 0)
   elseif button == "LeftButton" then
      if self.isMoving then
         self:StopMovingOrSizing()
         self.isMoving = false
      end
   end
end


local function tracking_menu_option(opt, text, value)
   return {
      ["text"] = text,
      ["checked"] = function() return TimeTrack:check_tracking_opt(opt, value) end,
      ["func"] = function() TimeTrack:set_tracking_opt(opt, value) end
   }
end

local TimeTrack_MainMenu_Info = {
   -- Level 1
   [1] = {
      -- List 1
      [1] = {
         -- Title
         [1] = {
            ["isTitle"] = true,
            ["text"] = "Tracking options",
            ["notCheckable"] = true
         },

         -- Submenus
         [2] = {
            ["text"] = "Mode",
            ["notCheckable"] = true,
            ["hasArrow"] = true,
            ["menuList"] = 1,
         },
         [3] = {
            ["text"] = "Scale",
            ["notCheckable"] = true,
            ["hasArrow"] = true,
            ["menuList"] = 2,
         },
      },
   },

   -- Level 2
   [2] = {
      [1] = {
         -- Options
         [1] = tracking_menu_option("mode", "Total", "total"),
         [2] = tracking_menu_option("mode", "Current", "current"),
      },
      [2] = {
         -- Options
         [1] = tracking_menu_option("scale", "0.5", 0.5),
         [2] = tracking_menu_option("scale", "0.75", 0.75),
         [3] = tracking_menu_option("scale", "1.0", 1.0),
         [4] = tracking_menu_option("scale", "1.25", 1.25),
         [5] = tracking_menu_option("scale", "1.5", 1.5),
         [6] = tracking_menu_option("scale", "1.75", 1.75),
         [7] = tracking_menu_option("scale", "2.0", 2.0),
      },
   },
}

function TimeTrack_MainMenu_OnLoad(self, level, menuList)
   level = level or 1
   menuList = menuList or 1

   for _,v in ipairs(TimeTrack_MainMenu_Info[level][menuList]) do
      local info = UIDropDownMenu_CreateInfo()

      for k,v in pairs(v) do
         if type(v) == "function" and k ~= "func" then
            info[k] = v()
         else
            info[k] = v
         end
      end

      UIDropDownMenu_AddButton(info, level)
   end

end
