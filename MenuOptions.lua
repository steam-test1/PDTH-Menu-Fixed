_G.PDTH_Menu = _G.PDTH_Menu or {}
PDTH_Menu.mod_path = ModPath
PDTH_Menu._data_path = SavePath .. "PDTHMenuSave.txt"

PDTH_Menu.options = {}
PDTH_Menu.options_menu = "PDTH_Menu_options"

function PDTH_Menu:Save()
	local file = io.open( self._data_path, "w+" )
	if file then
		file:write( json.encode( self.options ) )
		file:close()
	end
end

function PDTH_Menu:Load()
	local file = io.open( self._data_path, "r" )
	if file then
		self.options = json.decode( file:read("*all") )
		file:close()
	end
end

if not PDTH_Menu.setup then
	PDTH_Menu:Load()
	if PDTH_Menu.options.pdth_markercolor == nil then
		PDTH_Menu.options.pdth_markercolor = 1
		PDTH_Menu:Save()
	end
	if PDTH_Menu.options.PDTH_Menucolor == nil then
		PDTH_Menu.options.PDTH_Menucolor = 2
		PDTH_Menu:Save()
	end
	if PDTH_Menu.options.pdth_highlightcolor == nil then
		PDTH_Menu.options.pdth_highlightcolor = 3
		PDTH_Menu:Save()
	end
	if PDTH_Menu.options.font_enable == nil then
		PDTH_Menu.options.font_enable = true
		PDTH_Menu:Save()
	end
	if PDTH_Menu.options.enable_pdth_level_loading == nil then
		PDTH_Menu.options.enable_pdth_level_loading = true
		PDTH_Menu:Save()
	end
	if PDTH_Menu.options.enable_pdth_endscreen_texture == nil then
		PDTH_Menu.options.enable_pdth_endscreen_texture = true
		PDTH_Menu:Save()
	end
	if PDTH_Menu.options.enable_pdth_style_backdrop == nil then
		PDTH_Menu.options.enable_pdth_style_backdrop = true
		PDTH_Menu:Save()
	end
	PDTH_Menu:Load()
	PDTH_Menu.setup = true
end
local PDTH_Colors = {}
local Sides = {
	"left",
    "right",
}
Hooks:Add("LocalizationManagerPostInit", "PDTH_Menu_loc", function(loc)
	LocalizationManager:add_localized_strings({
    ["PDTH_Menu_options_title"] = "PDTH Menu options",
    ["PDTH_Menu_options_desc"] = "Change pdth menu to how you like.",

    ["pdth_markercolor_title"] = "Menu marker color",
    ["pdth_markercolor_desc"] = "The color of your menu marker.(Default = Orange)",
    ["font_enable_title"] = "PDTH font",
    ["font_enable_desc"] = "Changes the menu font to pdth one",
	["PDTH_Menucolor_title"] = "Menu text color",
	["PDTH_Menucolor_desc"] = "",
	["pdth_highlightcolor_title"] = "Menu highlight text color",
	["pdth_highlightcolor_desc"] = "",
	["enable_pdth_level_loading_title"] = "Enable PDTH Level Loading Screen",
	["enable_pdth_level_loading_desc"] = "",
	["enable_pdth_endscreen_texture_title"] = "Enable PDTH End Screen Texture",
	["enable_pdth_endscreen_texture_desc"] = "",
	["enable_pdth_style_backdrop_title"] = "Enable PDTH Style Backdrop",
	["enable_pdth_style_backdrop_desc"] = "",
    ["left"] = "left",
    ["right"] = "right",
	["clean_cs_level"] = "$level"
  })
  for k, v in pairs(PDTH_Menu.colors) do
	LocalizationManager:add_localized_strings({
		["PDTH_Menucolor"..k] = v.menu_name,
	})
  	table.insert(PDTH_Colors, "PDTH_Menucolor"..k)
  end
end)

	Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenusPDTH_Menu", function( menu_manager, nodes )
		MenuHelper:NewMenu( PDTH_Menu.options_menu )
	end)

	Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenusPDTH_Menu", function( menu_manager, nodes )
		MenuCallbackHandler.pdth_markercolor = function(self, item)
			PDTH_Menu.options.pdth_markercolor = item:value()
			PDTH_Menu:Save()
		end
		MenuCallbackHandler.PDTH_Menucolor = function(self, item)
			PDTH_Menu.options.PDTH_Menucolor = item:value()
			PDTH_Menu:Save()
		end
		MenuCallbackHandler.pdth_highlightcolor = function(self, item)
			PDTH_Menu.options.pdth_highlightcolor = item:value()
			PDTH_Menu:Save()
		end
		MenuCallbackHandler.font_enable = function(self, item)
			PDTH_Menu.options.font_enable = (item:value() == "on" and true or false)
			PDTH_Menu:Save()
		end
		MenuCallbackHandler.pdth_level_loading = function(self, item)
			PDTH_Menu.options.enable_pdth_level_loading = (item:value() == "on" and true or false)
			PDTH_Menu:Save()
		end
		MenuCallbackHandler.pdth_endscreen_texture = function(self, item)
			PDTH_Menu.options.enable_pdth_endscreen_texture = (item:value() == "on" and true or false)
			PDTH_Menu:Save()
		end
		MenuCallbackHandler.pdth_style_backdrop = function(self, item)
			PDTH_Menu.options.enable_pdth_style_backdrop = (item:value() == "on" and true or false)
			PDTH_Menu:Save()
		end
		MenuHelper:AddMultipleChoice({
			id = "PDTH_Menucolor",
			title = "PDTH_Menucolor_title",
			desc = "PDTH_Menucolor_desc",
			callback = "PDTH_Menucolor",
			items = PDTH_Colors,
			menu_id = PDTH_Menu.options_menu,
			value = PDTH_Menu.options.PDTH_Menucolor,
			priority = 1
    	})
    	MenuHelper:AddMultipleChoice({
			id = "pdth_highlightcolor",
			title = "pdth_highlightcolor_title",
			desc = "pdth_highlightcolor_desc",
			callback = "pdth_highlightcolor",
			items = PDTH_Colors,
			menu_id = PDTH_Menu.options_menu,
			value = PDTH_Menu.options.pdth_highlightcolor,
			priority = 2
    	})
	    MenuHelper:AddMultipleChoice({
			id = "pdth_markercolor",
			title = "pdth_markercolor_title",
			desc = "pdth_markercolor_desc",
			callback = "pdth_markercolor",
			menu_id = PDTH_Menu.options_menu,
			value = PDTH_Menu.options.pdth_markercolor,
			items = PDTH_Colors,
			priority = 3
		})
	 	MenuHelper:AddToggle({
			id = "font_enable",
			title = "font_enable_title",
			desc = "font_enable_desc",
			callback = "font_enable",
			menu_id = PDTH_Menu.options_menu,
			value = PDTH_Menu.options.font_enable,
			priority = 4
    	})
		MenuHelper:AddDivider({ 
			id = "pdthmenu_divider", 
			size = 20, 
			menu_id = PDTH_Menu.options_menu,
			priority = 5
		})
		MenuHelper:AddToggle({
			id = "enable_pdth_level_loading",
			title = "enable_pdth_level_loading_title",
			desc = "enable_pdth_level_loading_desc",
			callback = "pdth_level_loading",
			menu_id = PDTH_Menu.options_menu,
			value = PDTH_Menu.options.enable_pdth_level_loading,
			priority = 6
    	})
		MenuHelper:AddToggle({
			id = "enable_pdth_endscreen_texture",
			title = "enable_pdth_endscreen_texture_title",
			desc = "enable_pdth_endscreen_texture_desc",
			callback = "pdth_endscreen_texture",
			menu_id = PDTH_Menu.options_menu,
			value = PDTH_Menu.options.enable_pdth_endscreen_texture,
			priority = 7
    	})
		MenuHelper:AddToggle({
			id = "enable_pdth_style_backdrop",
			title = "enable_pdth_style_backdrop_title",
			desc = "enable_pdth_style_backdrop_desc",
			callback = "pdth_style_backdrop",
			menu_id = PDTH_Menu.options_menu,
			value = PDTH_Menu.options.enable_pdth_style_backdrop,
			priority = 8
    	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenusPDTH_Menu", function(menu_manager, nodes)
		nodes[PDTH_Menu.options_menu] = MenuHelper:BuildMenu( PDTH_Menu.options_menu )
		MenuHelper:AddMenuItem( nodes.blt_options, PDTH_Menu.options_menu, "PDTH_Menu_options_title", "PDTH_Menu_options_desc", 1 )

		local main = nodes.main and nodes.main._items
		if main then
			for menus, item in pairs(main) do
				for params, v in pairs(item._parameters) do
					if params == "font_size" then
						item._parameters.font_size = PDTHMenu_font_size
					end
					if params == "font" then
						item._parameters.font = PDTHMenu_font
					end
				end
			end
		end
end)
