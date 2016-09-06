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
      },
   },

   -- Level 2
   [2] = {
      [1] = {
         -- Options
         [1] = tracking_menu_option("type", "Total", "total"),
         [2] = tracking_menu_option("type", "Current", "current"),
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
