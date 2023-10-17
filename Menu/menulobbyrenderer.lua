core:import("CoreMenuRenderer")
require("lib/managers/menu/MenuNodeGui")
require("lib/managers/menu/renderers/MenuNodeTableGui")
require("lib/managers/menu/renderers/MenuNodeStatsGui")
function MenuLobbyRenderer:show_node(node)
	local gui_class = MenuNodeGui
	if node:parameters().gui_class then
		gui_class = CoreSerialize.string_to_classtable(node:parameters().gui_class)
	end
	local parameters = {
		row_item_color = PDTHMenu_color_normal,
		row_item_hightlight_color = PDTHMenu_color_highlight,
		row_item_blend_mode = "normal",
		font = PDTHMenu_font,
		font_size = PDTHMenu_font_size,
		node_gui_class = gui_class,
		spacing = node:parameters().spacing,
		marker_alpha = 1,
		marker_color = PDTHMenu_color_marker,
		align = "right",
		to_upper = true
	}
	MenuLobbyRenderer.super.show_node(self, node, parameters)
end
