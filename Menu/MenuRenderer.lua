core:import("CoreMenuRenderer")
function MenuRenderer:init( logic, ... )
	MenuRenderer.super.init( self, logic, ... )
	self._sound_source = SoundDevice:create_source( "MenuRenderer" )
end
function MenuRenderer:show_node( node )
	local gui_class = MenuNodeGui
	if node:parameters().gui_class then
		gui_class = CoreSerialize.string_to_classtable( node:parameters().gui_class )
	end
	local alignment
	if node:parameters().name == "jukebox_menu_playlist" or node:parameters().name == "jukebox_heist_playlist" or node:parameters().name == "jukebox_ghost_playlist" or node:parameters().name == "base_lua_mods_menu" then
		alignment = "right"
	else
		alignment = "left"
	end
	-- local old_font = tweak_data.menu.pd2_medium_font
	-- local old_font_size = 19
	-- if PDTH_Menu.options.font_enable then
	-- 	old_font = tweak_data.menu.pdth_menu_font
	-- 	old_font_size = tweak_data.menu.pdth_menu_font_size
	-- end
	local parameters = {
		-- font = tweak_data.menu.pdth_menu_font,
		-- row_item_color = PDTHMenu_color_normal,
		-- row_item_hightlight_color = PDTHMenu_color_highlight,
		-- row_item_blend_mode = "normal",
		-- font_size = tweak_data.menu.pdth_menu_font_size,
		-- node_gui_class = gui_class,
		-- marker_alpha = 1,
		-- marker_color = PDTHMenu_color_marker,
		-- align = alignment,
		-- to_upper = true,
		-- spacing = node:parameters().spacing

		marker_alpha = 1,
		align = alignment,
		row_item_blend_mode = "normal",
		to_upper = true,
		font = PDTHMenu_font,
		row_item_color = PDTHMenu_color_normal,
		row_item_hightlight_color = PDTHMenu_color_highlight,
		font_size = PDTHMenu_font_size,
		node_gui_class = gui_class,
		spacing = node:parameters().spacing,
		marker_color = PDTHMenu_color_marker
	}

	local previous_node_gui = self._node_gui_stack[#self._node_gui_stack - 1]

	if previous_node_gui and (node:parameters().hide_previous == false or node:parameters().hide_previous == "false") then
		previous_node_gui:set_visible(true)
	end

	MenuRenderer.super.show_node( self, node, parameters )
end

function MenuRenderer:open(...)
	MenuRenderer.super.open( self, ... )
	self:_create_framing()
	self._menu_stencil_align = "left"
	self._menu_stencil_default_image = "guis/textures/empty"
	self._menu_stencil_image = self._menu_stencil_default_image
	self:_layout_menu_bg()
end

function MenuRenderer:_create_framing()
	MenuRenderer._create_bottom_text( self )
end
function MenuRenderer:setup_frames_and_logo()
	 self._upper_frame_gradient = self._fullscreen_panel:rect({
		x = 0,
		y = 0,
		w = 0,
		h = 48,
		layer = 1,
		color = Color.black
	})
	self._lower_frame_gradient = self._fullscreen_panel:rect({
		x = 0,
		y = 0,
		w = 0,
		h = 48,
		layer = 1,
		color = Color.black
	})
	self._pd2_logo = self._fullscreen_panel:bitmap({
		name = "logo",
		texture = tweak_data.load_level.stonecold_small_logo,
		layer = 2,
		h = 56
	})

end

function MenuRenderer:layout_frames_and_logo()

	local res = RenderSettings.resolution
	local safe_rect_pixels = managers.viewport:get_safe_rect_pixels()
	self._upper_frame_gradient:set_size(res.x, 68)
	self._lower_frame_gradient:set_size(res.x, 68)

	self._upper_frame_gradient:set_top(self._fullscreen_panel:top())
	self._lower_frame_gradient:set_bottom(self._fullscreen_panel:bottom())

	self._pd2_logo:set_size(256, 56)
	self._pd2_logo:set_bottom(75)
	self._pd2_logo:set_right(self._fullscreen_panel:right() - 30)
end
function MenuRenderer:_create_bottom_text()
	local scaled_size = managers.gui_data:scaled_size()
	self._top_text = self._main_panel:text({
		text = "",
		font = PDTHMenu_font,
		font_size = PDTHMenu_font_size + 4,
		align= PDTHMenu_align,
		halign = "top",
		vertical = "top",
		w = scaled_size.width*0.66,
		layer = 2,
	})
	self._bottom_text = self._main_panel:text({
		text = "",
		wrap = true,
		word_wrap = true,
		font = PDTHMenu_font,
		font_size = PDTHMenu_font_size,
		align= PDTHMenu_align,
		halign="left",
		vertical="top",
		hvertical="top",
		w = scaled_size.width*0.66,
		layer = 2,
	})
	self._bottom_text:set_right( self._bottom_text:right() )
end
function MenuRenderer:set_bottom_text(title, desc, localize)
	if not alive(self._bottom_text) then
		return
	end
	if not title and desc then
		self._bottom_text:set_text("")
		return
	end
	if localize == nil then
		localize = desc
		desc = ""
	end
	title = title and title or ""
    if managers.localization:text(title) == managers.localization:to_upper_text("menu_back") then
    	title = ""
    end
	desc = desc and desc or ""

	self._bottom_text:set_text(utf8.to_upper(localize and managers.localization:text(desc) or desc))
	self._top_text:set_text(utf8.to_upper(localize and managers.localization:text(title) or title))
	local _, _, _, h = self._bottom_text:text_rect()
	self._top_text:set_shape(self._top_text:text_rect())
	self._bottom_text:set_top(self._top_text:bottom() + tweak_data.menu.info_padding)
	self._bottom_text:set_h(h)
end