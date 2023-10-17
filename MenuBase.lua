
_G.PDTH_Menu = _G.PDTH_Menu or {}
PDTH_Menu.dofiles = {
   "MenuOptions.lua"
}
PDTH_Menu.hook_files = {
    ["lib/managers/menu/items/menuitemmultichoice"] = "Menu/menumultichoice.lua",
    ["lib/managers/menu/items/menuitemcustomizecontroller"] = "Menu/menuitemcustomizecontroller.lua",
    ["lib/managers/menu/blackmarketgui"] = "Menu/blackmarketgui.lua",
    ["lib/managers/menu/renderers/menunodebasegui"] = "Menu/menunodebasegui.lua",
    ["lib/managers/menu/textboxgui"] = "Menu/textboxgui.lua",
    ["lib/managers/menu/renderers/menunodepreplanninggui"] = "Menu/menupreplanning.lua",
    ["lib/managers/menu/renderers/menunodecrimenetgui"] = "Menu/menucrimenet.lua",
    ["lib/managers/menu/renderers/menunodetablegui"] = "Menu/menunodetablegui.lua",
    ["lib/managers/menu/menurenderer"] = "Menu/menurenderer.lua",
    ["lib/managers/menu/imageboxgui"] = "Menu/imageboxgui.lua",
    ["lib/managers/menu/menulobbyrenderer"] = "Menu/menulobbyrenderer.lua",
    ["lib/managers/menu/renderers/menunodejukeboxgui"] = "Menu/menunodejukeboxgui.lua",
    ["lib/managers/menu/newsfeedgui"] = "Menu/newsfeedgui.lua",
    ["lib/managers/menu/renderers/menunodeskillswitchgui"] = "Menu/menunodeskillswitchgui.lua",
    ["lib/managers/menu/renderers/menunodeupdatesgui"] = "Menu/menunodeupdatesgui.lua",
    ["lib/managers/menu/menupauserenderer"] = "Menu/menupause.lua",
    ["lib/managers/menu/lootdropscreengui"] = "Menu/lootdropscreengui.lua",
    ["lib/managers/hud/hudmissionbriefing"] = "Menu/hudmissionbriefing.lua",
    ["lib/managers/menu/infamytreegui"] = "Menu/infamytreegui.lua",
    ["lib/managers/hud/hudstageendscreen"] = "Menu/hudstageendscreen.lua",
    ["lib/managers/menu/playerinventorygui"] = "Menu/playerinventorygui.lua",
    ["lib/managers/hud/hudlootscreen"] = "Menu/hudlootscreen.lua",
    ["lib/managers/menu/menunodegui"] = "Menu/menunodegui.lua",
    ["lib/managers/menu/menubackdropgui"] = "Menu/menubackdropgui.lua",
    ["lib/managers/menu/menukitrenderer"] = "Menu/menukit.lua",
    -- ["lib/managers/menu/skilltreegui"] = "Menu/skilltreegui.lua",
    ["lib/managers/menu/stageendscreengui"] = "Menu/stageendscreengui.lua",
    ["lib/managers/menumanager"] = "Menu/menumanager.lua",
    ["lib/managers/menu/missionbriefinggui"] = "Menu/missionbriefinggui.lua",
    ["lib/managers/crimenetmanager"] = "Menu/crimenetmanager.lua",
    ["lib/managers/chatmanager"] = "Menu/chatmanager.lua",
    ["lib/managers/menu/menuinput"] = "Menu/menuinput.lua",
    ["lib/managers/social_hub/lobbycodemenucomponent"] = "Menu/lobbycodemenucomponent.lua",
    ["lib/managers/menu/crimespreedetailsmenucomponent"] = "Menu/crimespreedetailsmenucomponent.lua",
    ["lib/managers/menu/menucomponentmanager"] = "Menu/menucomponentmanager.lua"
    -- ["lib/managers/menu/crimespreemissionendoptions"] = "Menu/crimespreemissionendoptions.lua", 
}

if not PDTH_Menu.setup and Hooks then
	function ColorRGB(r ,g, b)
		return Color(r/255 ,g/255 ,b/255)
	end
	PDTH_Menu.colors = {
		 {color = ColorRGB(255,165 ,0 ), menu_name = "Orange"},
	 	 {color = ColorRGB(255, 255, 255), menu_name = "White"},
		 {color = ColorRGB(0, 0, 0), menu_name = "Black"},
		 {color = ColorRGB(0 ,150 ,255 ), menu_name = "Blue"},
		 {color = ColorRGB(0, 255, 20), menu_name = "Green"},
		 {color = ColorRGB(255, 105, 180), menu_name = "Pink"},
	}
    PDTH_Menu.lobby_icon_unknown = {100,197, 48, 48}
    PDTH_Menu.lobby_icon_russian = {1, 1, 48, 48}
    PDTH_Menu.lobby_icon_german = {49, 1, 48, 48}
    PDTH_Menu.lobby_icon_american = {100, 1, 48, 48}
    PDTH_Menu.lobby_icon_spanish = {148, 1, 48, 48}
    PDTH_Menu.lobby_icon_old_hoxton = {197, 1, 48, 48}
    PDTH_Menu.lobby_icon_female_1 = {1,  49, 48, 48}
    PDTH_Menu.lobby_icon_jowi = {49, 49, 48, 48}
    PDTH_Menu.lobby_icon_dragan = {100,49,48, 48}
    PDTH_Menu.lobby_icon_jacket = {148, 49,48,48}
    PDTH_Menu.lobby_icon_bonnie = {197, 49, 48, 48}
    PDTH_Menu.lobby_icon_sokol = {1, 100, 48, 48}
    PDTH_Menu.lobby_icon_dragon = {49,100, 48, 48}
    PDTH_Menu.lobby_icon_bodhi = {100,100, 48, 48}
    PDTH_Menu.lobby_icon_jimmy = {149,100, 48, 48}
    PDTH_Menu.lobby_icon_sydney = {198,100, 48, 48}
    PDTH_Menu.lobby_icon_wild = {1,148, 48, 48}
    PDTH_Menu.lobby_icon_max = {50,148, 48, 48}
    PDTH_Menu.lobby_icon_chico = {100,148, 48, 48}
    PDTH_Menu.lobby_icon_myh = {149,148, 48, 48}
    PDTH_Menu.lobby_icon_ecp_male = {198,148, 48, 48}
    PDTH_Menu.lobby_icon_ecp_female = {1,197, 48, 48}
    PDTH_Menu.lobby_icon_joy = {49,198, 48, 48}

    PDTH_Menu.level_image_jewelry_store = {0,0,480,270}
    PDTH_Menu.level_image_ukrainian_job = {0,0,480,270}
    PDTH_Menu.level_image_safehouse = {480,0,480,270}
    PDTH_Menu.level_image_kosugi = {960,0,480,270}
    PDTH_Menu.level_image_gallery = {1440,0,480,270}
    PDTH_Menu.level_image_framing_frame_1 = {1440,0,480,270}
    PDTH_Menu.level_image_arm_fac = {1920,0,480,270}
    PDTH_Menu.level_image_arm_for = {2400,0,480,270}
    PDTH_Menu.level_image_arm_und = {2880,0,480,270}
    PDTH_Menu.level_image_jolly = {3360,0,480,270}

    PDTH_Menu.level_image_branchbank = {0,270,480,270}
    PDTH_Menu.level_image_mallcrasher = {480,270,480,270}
    PDTH_Menu.level_image_nightclub = {960,270,480,270}
    PDTH_Menu.level_image_arm_par = {1440,270,480,270}
    PDTH_Menu.level_image_four_stores = {1920,270,480,270}
    PDTH_Menu.level_image_cane = {2400,270,480,270}
    PDTH_Menu.level_image_pines = {2880,270,480,270}
    PDTH_Menu.level_image_peta = {3360,270,480,270}

    PDTH_Menu.level_image_crojob = {0,540,480,270}
    PDTH_Menu.level_image_shoutout_raid = {480,540,480,270}
    PDTH_Menu.level_image_alex_1 = {960,540,480,270}
    PDTH_Menu.level_image_rat = {960,540,480,270}
    PDTH_Menu.level_image_family = {1440,540,480,270}
    PDTH_Menu.level_image_crojob2 = {1920,540,480,270}
    PDTH_Menu.level_image_crojob3 = {1920,540,480,270}
    PDTH_Menu.level_image_cage = {2400,540,480,270}
    PDTH_Menu.level_image_big = {2880,540,480,270}
    PDTH_Menu.level_image_welcome_to_the_jungle_1_night = {3360,540,480,270}
    PDTH_Menu.level_image_welcome_to_the_jungle_1 = {3360,540,480,270}


    PDTH_Menu.level_image_roberts = {0,810,480,270}
    PDTH_Menu.level_image_arena = {480,810,480,270}
    PDTH_Menu.level_image_arm_cro = {960,810,480,270}
    PDTH_Menu.level_image_arm_hcm = {1440,810,480,270}
    PDTH_Menu.level_image_red2 = {1920,810,480,270}
    PDTH_Menu.level_image_pbr2 = {2400,810,480,270}
    PDTH_Menu.level_image_pbr = {2880,810,480,270}
    PDTH_Menu.level_image_firestarter_1 = {3360,810,480,270}

    PDTH_Menu.level_image_kenaz = {0,1080,480,270}
    PDTH_Menu.level_image_mia = {480,1080,480,270}
    PDTH_Menu.level_image_hox_1 = {960,1080,480,270}
    PDTH_Menu.level_image_hox_3 = {1440,1080,480,270}
    PDTH_Menu.level_image_nail = {1920,1080,480,270}
    PDTH_Menu.level_image_cane = {2400,1080,480,270}
    PDTH_Menu.level_image_dinner = {2880,1080,480,270}
    PDTH_Menu.level_image_mus = {3360,1080,480,270}


    PDTH_Menu.level_image_watchdogs_1 = {0,1350,480,270}
    PDTH_Menu.level_image_pines = {480,1350,480,270}
    PDTH_Menu.level_image_firestarter_2 = {960,1350,480,270}
    PDTH_Menu.level_image_hox_2 = {1440,1350,480,270}
    PDTH_Menu.level_image_watchdogs_2 = {1920,1350,480,270}
    PDTH_Menu.level_image_alex_2 = {2400,1350,480,270}
    PDTH_Menu.level_image_alex_3 = {2880,1350,480,270}
    PDTH_Menu.level_image_election_1 = {3360,1350,480,270}


    PDTH_Menu.level_image_election_2 = {0,1620,480,270}
    PDTH_Menu.level_image_election_3 = {480,1620,480,270}
    PDTH_Menu.level_image_framing_frame_2 = {960,1620,480,270}
    PDTH_Menu.level_image_framing_frame_3 = {1440,1620,480,270}



	for p, d in pairs(PDTH_Menu.dofiles) do
		dofile(ModPath .. d)
	end
	for k, v in pairs(PDTH_Menu.options) do
		if k:match("color") and type(v) == "number" and v > #PDTH_Menu.colors then
			PDTH_Menu.options[k] = #PDTH_Menu.colors
		end
	end
    PDTHMenu_color_normal = PDTH_Menu.colors[PDTH_Menu.options.PDTH_Menucolor].color
    PDTHMenu_color_highlight = PDTH_Menu.colors[PDTH_Menu.options.pdth_highlightcolor].color
    PDTHMenu_color_marker = PDTH_Menu.colors[PDTH_Menu.options.pdth_markercolor].color
    PDTHMenu_font = PDTH_Menu.options.font_enable and "PDTHMenu/fonts/pdth_menu_font" or "fonts/font_medium_mf"
    PDTHMenu_font_size = PDTH_Menu.options.font_enable and 16 or 19
	PDTHMenu_align = "left" --Not recommended to change might cause issues.
 	log("[PDTH Menu] Done loading all options")
	PDTH_Menu.setup = true

end

if RequiredScript then
	local requiredScript = RequiredScript:lower()
	if PDTH_Menu.hook_files[requiredScript] then
		dofile( ModPath .. PDTH_Menu.hook_files[requiredScript] )
	end
end
