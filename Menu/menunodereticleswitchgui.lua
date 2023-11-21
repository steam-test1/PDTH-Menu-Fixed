function MenuNodeReticleSwitchGui:init(node, layer, parameters)
	parameters.font = PDTHMenu_font
	parameters.font_size = PDTHMenu_font_size
	parameters.align = "left"
	parameters.row_item_blend_mode = "normal"
	parameters.row_item_color = PDTHMenu_color_normal
	parameters.row_item_hightlight_color = PDTHMenu_color_highlight
	parameters.marker_alpha = 1
	parameters.to_upper = true

	MenuNodeReticleSwitchGui.super.init(self, node, layer, parameters)
	self:setup(node)
end

function MenuNodeReticleSwitchGui:update_item_dlc_locks()
	local node = self.node

	if not node then
		return
	end

	local type = node:item("reticle_type"):value()
	local color = node:item("reticle_color"):value()
	local type_data = tweak_data:get_raw_value("gui", "weapon_texture_switches", "types", "sight", type)
	local color_data = tweak_data:get_raw_value("gui", "weapon_texture_switches", "color_indexes", color)
	local type_dlc = type_data and type_data.dlc or false
	local color_dlc = color_data and color_data.dlc or false
	local pass_type = not type_dlc or managers.dlc:is_dlc_unlocked(type_dlc)
	local pass_color = not color_dlc or managers.dlc:is_dlc_unlocked(color_dlc)
	local type_row_item = self:row_item_by_name("reticle_type")
	type_row_item.hightlight_color = not pass_type and PDTHMenu_color_highlight
	type_row_item.row_item_color = not pass_type and PDTHMenu_color_normal
	local color_row_item = self:row_item_by_name("reticle_color")
	color_row_item.hightlight_color = not pass_color and PDTHMenu_color_highlight
	color_row_item.row_item_color = not pass_color and PDTHMenu_color_normal
	local confirm = node:item("confirm")
	local require_dlc = "dialog_require_dlc_"
	confirm:parameters().text_id = not pass_type and require_dlc .. type_dlc or not pass_color and require_dlc .. color_dlc or "dialog_apply"

	self:reload_item(node:item("reticle_type"))
	self:reload_item(node:item("reticle_color"))
	self:reload_item(node:item("confirm"))

	return pass_type and pass_color
end