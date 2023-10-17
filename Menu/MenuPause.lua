core:import("CoreMenuNodeGui")
function MenuPauseRenderer:show_node(node)
	local gui_class = MenuNodeGui
	if node:parameters().gui_class then
		gui_class = CoreSerialize.string_to_classtable(node:parameters().gui_class)
	end
	local parameters = {
		font = PDTHMenu_font,
		row_item_color = PDTHMenu_color_normal,
		row_item_hightlight_color = PDTHMenu_color_highlight,
		row_item_blend_mode = "normal",
		font_size = PDTHMenu_font_size,
		node_gui_class = gui_class,
		use_info_rect = true,
		spacing = node:parameters().spacing,
		marker_alpha = 1,
		marker_color = PDTHMenu_color_marker,
		align = PDTHMenu_color_align,
		to_upper = true
	}
	MenuRenderer.setup_frames_and_logo(self)
	MenuRenderer.layout_frames_and_logo(self)
	MenuPauseRenderer.super.super.show_node(self, node, parameters)
end
function MenuPauseRenderer:open(...)
	MenuPauseRenderer.super.super.open(self, ...)
	self._menu_bg = self._fullscreen_panel:rect({
		color = Color.black,
		alpha = 0.4,
	})
	self:_layout_menu_bg()
	MenuRenderer._create_bottom_text(self)
end

function MenuPauseRenderer:update(t, dt)
	MenuPauseRenderer.super.update(self, t, dt)
end
function MenuPauseRenderer:_layout_menu_bg()
end
function MenuPauseRenderer:resolution_changed(...)
	MenuPauseRenderer.super.resolution_changed(self, ...)
	self:_layout_menu_bg()
end
function MenuPauseRenderer:set_bg_visible(visible)
end
function MenuPauseRenderer:set_bg_area(area)
end
function MenuPauseRenderer:close(...)
	MenuPauseRenderer.super.close(self, ...)
end
