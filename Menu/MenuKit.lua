
core:import("CoreMenuNodeGui")
require("lib/managers/menu/MenuNodeKitGui")
CloneClass(MenuLobbyRenderer)

function MenuKitRenderer:show_node(node)
	local gui_class = MenuNodeKitGui
	if node:parameters().gui_class then
		gui_class = CoreSerialize.string_to_classtable(node:parameters().gui_class)
	end
	local parameters = {
		row_item_color = PDTHMenu_color_normal,
		row_item_hightlight_color = PDTHMenu_color_highlight,
		row_item_blend_mode = "normal",
		font = tweak_data.menu.pd2_medium_font,
		font_size = tweak_data.menu.pd2_medium_font_size - 5,
		node_gui_class = gui_class,
		spacing = node:parameters().spacing,
		marker_alpha = 1,
		marker_color = PDTHMenu_color_marker,
		align = PDTHMenu_align,
		to_upper = true
	}
	MenuKitRenderer.super.super.show_node(self, node, parameters)
end
