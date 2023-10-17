require("lib/managers/menu/renderers/MenuNodeBaseGui")
function MenuNodePrePlanningGui:init(node, layer, parameters)
	parameters.font = PDTHMenu_font
	parameters.font_size = tweak_data.menu.pd2_small_font_size
	parameters.align = "left"
	parameters.row_item_blend_mode = "normal"
	parameters.row_item_color = PDTHMenu_color_normal
	parameters.row_item_hightlight_color = PDTHMenu_color_highlight
	parameters.row_item_disabled_text_color = Color(1, 0.3, 0.3, 0.3)
	parameters.marker_alpha = 1
	parameters.to_upper = true
	parameters._align_line_proportions = 0.75
	parameters.height_pnormaling = 10
	parameters.tooltip_height = node:parameters().tooltip_height or 265
	if node:parameters().name == "preplanning_type" or node:parameters().name == "preplanning_plan" then
		parameters.row_item_disabled_text_color = tweak_data.screen_colors.important_1
		self.marker_disabled_color = tweak_data.screen_colors.important_1:with_alpha(0.2)
	end
	MenuNodePrePlanningGui.super.init(self, node, layer, parameters)
end
function MenuNodePrePlanningGui:setup()
	MenuNodePrePlanningGui.super.setup(self)
	if managers.menu:is_pc_controller() then
		self:create_text_button({
			right = self.safe_rect_panel:w() - 10,
			bottom = self.safe_rect_panel:h() - 10,
			font = PDTHMenu_font,
			font_size = tweak_data.menu.pd2_medium_font_size -5,
			text_id = "menu_back",
			text_to_upper = true,
			clbk = callback(MenuCallbackHandler, MenuCallbackHandler, "menu_back")
		})
	end
end

