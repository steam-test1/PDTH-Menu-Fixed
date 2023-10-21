-- core:module("CoreMenuNodeGui")
-- core:import("CoreUnit")
-- function NodeGui:_setup_item_rows(node)
-- 	local items = node:items()
-- 	local i = 0

-- 	if not managers.menu:is_pc_controller() then
-- 		for i, a in ipairs(items) do
-- 			for k, b in ipairs(items) do
-- 				if i ~= k and a:parameters().controller_order_override ~= nil and b:parameters().controller_order_override ~= nil and a:parameters().controller_order_override < b:parameters().controller_order_override and k < i then
-- 					local t = a
-- 					items[i] = b
-- 					items[k] = t
-- 				end
-- 			end
-- 		end
-- 	end

-- 	for _, item in pairs(items) do
-- 		if item:visible() then
-- 			item:parameters().gui_node = self
-- 			local item_name = item:parameters().name
-- 			local item_text = "menu item missing 'text_id'"

-- 			if item:parameters().no_text then
-- 				item_text = nil
-- 			end

-- 			local help_text = nil
-- 			local params = item:parameters()

-- 			if params.text_id then
-- 				if self.localize_strings and params.localize ~= false and params.localize ~= "false" then
-- 					item_text = managers.localization:text(params.text_id)
-- 				else
-- 					item_text = params.text_id
-- 				end
-- 			end

-- 			if params.help_id then
-- 				if self.localize_strings and params.localize_help ~= false and params.localize_help ~= "false" then
-- 					help_text = managers.localization:text(params.help_id)
-- 				else
-- 					help_text = params.help_id
-- 				end
-- 			end

-- 			local row_item = {}

-- 			table.insert(self.row_items, row_item)

-- 			row_item.item = item
-- 			row_item.node = node
-- 			row_item.node_gui = self
-- 			row_item.type = item._type
-- 			row_item.name = item_name
-- 			row_item.position = {
-- 				x = 0,
-- 				y = self.font_size * i + self.spacing * (i - 1)
-- 			}
-- 			row_item.color = params.color or self.row_item_color
-- 			row_item.row_item_color = params.row_item_color
-- 			row_item.hightlight_color = params.hightlight_color
-- 			row_item.disabled_color = params.disabled_color or self.row_item_disabled_text_color
-- 			row_item.marker_color = params.marker_color or self.marker_color
-- 			row_item.marker_disabled_color = params.marker_disabled_color or self.marker_disabled_color
-- 			row_item.font = params.font or self.font
-- 			row_item.font_size = params.font_size or self.font_size
-- 			row_item.text = item_text
-- 			row_item.help_text = help_text
-- 			row_item.align = params.align or self.align or "left"
-- 			row_item.halign = params.halign or self.halign or "left"
-- 			row_item.vertical = params.vertical or self.vertical or "center"
-- 			row_item.to_upper = params.to_upper == nil and self.to_upper or params.to_upper or false
-- 			row_item.color_ranges = params.color_ranges or self.color_ranges or nil

-- 			self:_create_menu_item(row_item)
-- 			self:reload_item(item)

-- 			i = i + 1
-- 		end
-- 	end

-- 	self:_setup_size()
-- 	self:scroll_setup()
-- 	self:_set_item_positions()

-- 	self._highlighted_item = nil
-- end