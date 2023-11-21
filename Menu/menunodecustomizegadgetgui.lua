function MenuNodeCustomizeGadgetGui:init(node, layer, parameters)
	parameters.font = PDTHMenu_font
	parameters.font_size = PDTHMenu_font_size
	parameters.align = "right"
	parameters.row_item_blend_mode = "normal"
	parameters.row_item_color = PDTHMenu_color_normal
	parameters.row_item_hightlight_color = PDTHMenu_color_highlight
	parameters.marker_alpha = 1
	parameters.to_upper = true

	MenuNodeCustomizeGadgetGui.super.init(self, node, layer, parameters)
	self:setup(node)
end