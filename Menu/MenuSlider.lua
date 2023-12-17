
core:module("CoreMenuItemSlider")
core:import("CoreMenuItem")
ItemSlider = ItemSlider or class(CoreMenuItem.Item)
ItemSlider.TYPE = "slider"

local init_original = ItemSlider.init
function ItemSlider:init(data_node, parameters)
	init_original(self, data_node, parameters)
	self._slider_color = PDTHMenu_color_marker
end

function ItemSlider:setup_gui(node, row_item)
	slider_color = _G.PDTH_Menu.colors[_G.PDTH_Menu.options.pdth_markercolor].color
	slider_color2 = slider_color / 1.3
	row_item.gui_panel = node.item_panel:panel({
		w = node.item_panel:w()
	})
	row_item.gui_text = node._text_item_part(node, row_item, row_item.gui_panel, node._right_align(node))
	row_item.gui_text:set_layer(node.layers.items + 1)
	local _, _, w, h = row_item.gui_text:text_rect()
	row_item.gui_panel:set_h(h)
	local bar_w = 192
	row_item.gui_slider_bg = row_item.gui_panel:rect({
		visible = true,
		x = node._left_align(node) - bar_w,
		y = h / 2 - 11,
		w = bar_w,
		h = 22,
		align = "center",
		halign = "center",
		vertical = "center",
		color = Color.black:with_alpha(0.5),
		layer = node.layers.items - 1
	})
	row_item.gui_slider_gfx = row_item.gui_panel:gradient({
		orientation = "vertical",
		gradient_points = {
				0,
				slider_color:with_alpha(0.5),
				1,
				slider_color2:with_alpha(0.5)
		},
		x = node._left_align(node) - bar_w + 2,
		y = row_item.gui_slider_bg:y() + 2,
		w = (row_item.gui_slider_bg:w() - 4) * 0.23,
		h = row_item.gui_slider_bg:h() - 4,
		align = "center",
		halign = "center",
		vertical = "center",
		blend_mode = node.row_item_blend_mode or "normal",
		color = row_item.color,
		layer = node.layers.items
	})
	row_item.gui_slider = row_item.gui_panel:rect({
		color = row_item.color:with_alpha(0),
		layer = node.layers.items,
		w = 100,
		h = row_item.gui_slider_bg:h() - 4
	})
	row_item.gui_slider_marker = row_item.gui_panel:bitmap({
		visible = true,
		texture = "guis/textures/menu_icons",
		texture_rect = {
			0,
			0,
			24,
			28
		},
		layer = node.layers.items + 2
	})
	local slider_text_align = row_item.align == "left" and "right" or row_item.align == "right" and "left" or row_item.align
	local slider_text_halign = row_item.slider_text_halign == "left" and "right" or row_item.slider_text_halign == "right" and "left" or row_item.slider_text_halign
	local slider_text_vertical = row_item.vertical == "top" and "bottom" or row_item.vertical == "bottom" and "top" or row_item.vertical
	row_item.gui_slider_text = row_item.gui_panel:text({
		font_size = row_item.font_size + 3,
		x = node._right_align(node),
		y = 0,
		h = 30,
		w = row_item.gui_slider_bg:w(),
		align = "center",
		halign = slider_text_halign,
		vertical = "center",
		valign = "center",
		font = node.font,
		color = Color.white,
		layer = node.layers.items + 1,
		text = "",
		blend_mode = "normal",
	})
	if row_item.help_text then
	end
	self:_layout(node, row_item)
	return true
end

function ItemSlider:highlight_row_item(node, row_item, mouse_over)
	row_item.gui_text:set_font(row_item.font and Idstring(row_item.font) or _G.tweak_data.menu.default_font_no_outline_id)
	row_item.gui_slider_text:set_font(row_item.font and Idstring(row_item.font) or _G.tweak_data.menu.default_font_no_outline_id)
	row_item.gui_text:set_color(_G.PDTH_Menu.colors[_G.PDTH_Menu.options.pdth_highlightcolor].color)
	slider_color = _G.PDTH_Menu.colors[_G.PDTH_Menu.options.pdth_markercolor].color
	slider_color2 = slider_color / 1.3
	row_item.gui_slider_gfx:set_gradient_points({
		0,
		slider_color,
		1,
		slider_color2
	})
	if row_item.gui_info_panel then
		row_item.gui_info_panel:set_visible(true)
	end
	return true
end

function ItemSlider:fade_row_item(node, row_item)
	row_item.gui_text:set_font(row_item.font and Idstring(row_item.font) or _G.tweak_data.menu.default_font_id)
	row_item.gui_slider_text:set_font(row_item.font and Idstring(row_item.font) or _G.tweak_data.menu.default_font_id)
	row_item.gui_text:set_color(_G.PDTH_Menu.colors[_G.PDTH_Menu.options.PDTH_Menucolor].color)
	slider_color = _G.PDTH_Menu.colors[_G.PDTH_Menu.options.pdth_markercolor].color
	slider_color2 = slider_color / 1.3
	row_item.gui_slider_gfx:set_gradient_points({
		0,
		slider_color:with_alpha(0.5),
		1,
		slider_color2:with_alpha(0.5)
	})
	if row_item.gui_info_panel then
		row_item.gui_info_panel:set_visible(false)
	end
	return true
end

function ItemSlider:_layout(node, row_item)
local safe_rect = managers.viewport:get_safe_rect_pixels()
	row_item.gui_text:set_font_size(node.font_size)
	local x, y, w, h = row_item.gui_text:text_rect()
	local bg_pad = 8
	local xl_pad = 400
	row_item.gui_panel:set_height(h)
	row_item.gui_panel:set_width(safe_rect.width / 2 + xl_pad)
	row_item.gui_panel:set_x(safe_rect.width / 2 - xl_pad)
	local sh = math.min(h, 22)
	row_item.gui_text:set_size(w + 5, h)
	row_item.gui_text:set_left(node._right_align(node) - row_item.gui_panel:x())

	row_item.gui_slider_bg:set_h(sh - 2)
	row_item.gui_slider_bg:set_w(node:_left_align() - safe_rect.width / 2 - 60 * 2)
	row_item.gui_slider_bg:set_right(row_item.gui_text:left() - 20)
	row_item.gui_slider_bg:set_center_y(h / 2)
	row_item.gui_slider_text:set_font_size(node.font_size)
	row_item.gui_slider_text:set_size(row_item.gui_slider_bg:size())
	row_item.gui_slider_text:set_position(row_item.gui_slider_bg:position())
	row_item.gui_slider_text:set_y(row_item.gui_slider_text:y())
	row_item.gui_slider_gfx:set_h(sh - 6)
	row_item.gui_slider_gfx:set_x(row_item.gui_slider_bg:x() + 2)
	row_item.gui_slider_gfx:set_y(row_item.gui_slider_bg:y() + 2)
	row_item.gui_slider:set_x(row_item.gui_slider_bg:x() + 2)
	row_item.gui_slider:set_y(row_item.gui_slider_bg:y() + 2)
	row_item.gui_slider:set_w(row_item.gui_slider_bg:w() - 4)
	row_item.gui_slider_marker:set_center_y(h / 2)

	if row_item.gui_info_panel then
		node:_align_info_panel(row_item)
	end
end
