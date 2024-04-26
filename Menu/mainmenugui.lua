-- require("lib/managers/menu/PlayerInventoryGui")

-- local IS_WIN_32 = SystemInfo:platform() == Idstring("WIN32")
-- local NOT_WIN_32 = not IS_WIN_32

-- local function make_fine_text(text)
-- 	local x, y, w, h = text:text_rect()

-- 	text:set_size(w, h)
-- 	text:set_position(math.round(text:x()), math.round(text:y()))
-- end

-- local function format_round(num, round_value)
-- 	return round_value and tostring(math.round(num)) or string.format("%.1f", num):gsub("%.?0+$", "")
-- end

-- local box_objects = {
-- 	"text_object",
-- 	"info_text_object",
-- 	"image_objects",
-- 	"borders_object",
-- 	"bg_object"
-- }

-- function MainMenuGui:create_box(params, index)
-- 	local x = params.x or 0
-- 	local y = params.y or 0
-- 	local w = math.max(params.w or params.width or 1, 1)
-- 	local h = math.max(params.h or params.height or 1, 1)
-- 	local alpha = params.alpha or params.a or 1
-- 	local shrink_text = params.shrink_text == nil and true or params.shrink_text
-- 	local adept_width = params.adept_width or false
-- 	local keep_box_ratio = params.keep_box_ratio == nil and true or params.keep_box_ratio
-- 	local box_halign = params.halign or "left"
-- 	local box_valign = params.valign or "top"
-- 	local border_padding = params.border_padding or params.padding or 5
-- 	local padding = params.padding or 0
-- 	local x_padding = params.x_padding or 0
-- 	local y_padding = params.y_padding or 0
-- 	local text = params.text or false
-- 	local info_text = params.info_text or false
-- 	local unselected_text = params.unselected_text or text
-- 	local images = params.images or false
-- 	local select_area = params.select_area or false
-- 	local use_borders = params.use_borders == nil and true or params.use_borders
-- 	local use_background = params.use_background or false
-- 	local background_image = params.bg_image or false
-- 	local clbks = params.callbacks or params.clbks or false
-- 	local links = params.links or false
-- 	local can_select = params.can_select == nil and true or params.can_select
-- 	local wanted_states = params.states or false
-- 	local wanted_state = params.state
-- 	local states = {}

-- 	if wanted_states then
-- 		for _, state in ipairs(wanted_states) do
-- 			states[state] = true
-- 		end
-- 	end

-- 	if wanted_state then
-- 		states[wanted_state] = true
-- 	end

-- 	if table.size(states) == 0 then
-- 		states.default = true
-- 	end

-- 	local layer = params.layer or 1
-- 	local enabled = params.enabled == nil and true or params.enabled
-- 	local name = params.name or tostring(#self._boxes + 1)

-- 	if self._boxes_by_name[name] then
-- 		Application:error("[MainMenuGui:create_box] Failed creating box! Box with that name already exists", name)

-- 		return
-- 	end

-- 	local select_anim = params.select_anim or false
-- 	local unselect_anim = params.unselect_anim or false
-- 	w = math.max(w, border_padding * 2 + 1)
-- 	h = math.max(h, border_padding * 2 + 1)
-- 	local panel = self._panel:panel({
-- 		name = name,
-- 		x = x,
-- 		y = y,
-- 		w = w,
-- 		h = h,
-- 		alpha = alpha,
-- 		layer = layer * 10
-- 	})
-- 	local text_object, info_text_object, image_objects, borders_object, bg_object, select_object = nil

--     local font
--     local font_size
--     if PDTH_Menu.options.font_enable then
--         font = "fonts/pdth_menu_font"
--         font_size = 16
--     end

-- 	if text then
-- 		local align = params.text_align or false
-- 		local vertical = params.text_vertical or false
-- 		local selected_color = params.text_selected_color or params.text_color or tweak_data.screen_colors.text
-- 		local unselected_color = params.text_unselected_color or params.text_color or tweak_data.screen_colors.button_stage_3:with_alpha(0.25)
-- 		local blend_mode = params.text_blend_mode or params.blend_mode or "add"
-- 		local rotation = params.text_rotation or nil
-- 		local wrap = params.text_wrap or false
-- 		local word_wrap = params.text_word_wrap or false
-- 		font = font or tweak_data.menu.pd2_small_font
-- 		font_size = font_size or tweak_data.menu.pd2_small_font_size
-- 		local text_x = params.text_x or 0
-- 		local text_y = params.text_y or 0
-- 		local gui_object = panel:text({
-- 			layer = 5,
-- 			text = unselected_text,
-- 			font = font,
-- 			font_size = font_size,
-- 			color = unselected_color,
-- 			blend_mode = blend_mode,
-- 			rotation = rotation
-- 		})

-- 		if wrap then
-- 			gui_object:set_wrap(wrap)
-- 			gui_object:set_word_wrap(word_wrap)
-- 			gui_object:set_w(panel:w() - (border_padding * 2 + x_padding * 2 + text_x * 2))
-- 			gui_object:set_h(panel:h() - (border_padding * 2 + y_padding * 2 + text_y * 2))
-- 			gui_object:set_x(border_padding + x_padding)
-- 			gui_object:set_y(border_padding + y_padding)
-- 			gui_object:set_align(align or "center")
-- 			gui_object:set_vertical(vertical or "center")
-- 		else
-- 			make_fine_text(gui_object)

-- 			local needed_width = gui_object:w() + border_padding * 2 + x_padding * 2

-- 			if w < needed_width then
-- 				if shrink_text then
-- 					gui_object:set_font_size(font_size * w / needed_width)
-- 					make_fine_text(gui_object)
-- 				elseif adept_width then
-- 					w = needed_width

-- 					panel:set_w(w)

-- 					if keep_box_ratio then
-- 						local ratio = w / h
-- 						h = panel:w() / ratio

-- 						panel:set_h(h)
-- 					end
-- 				end
-- 			end

-- 			if vertical == "top" then
-- 				gui_object:set_top(border_padding)
-- 			elseif vertical == "bottom" then
-- 				gui_object:set_bottom(panel:h() - border_padding)
-- 			else
-- 				gui_object:set_center_y(panel:h() / 2)
-- 			end

-- 			if align == "left" then
-- 				gui_object:set_left(border_padding)
-- 			elseif align == "right" then
-- 				gui_object:set_right(panel:w() - border_padding)
-- 			else
-- 				gui_object:set_center_x(panel:w() / 2)
-- 			end
-- 		end

-- 		gui_object:set_position(math.round(gui_object:x() + text_x), math.round(gui_object:y() + text_y))

-- 		text_object = {
-- 			gui = gui_object,
-- 			selected_text = text,
-- 			unselected_text = unselected_text,
-- 			selected_color = selected_color,
-- 			unselected_color = unselected_color,
-- 			shape = {
-- 				gui_object:shape()
-- 			}
-- 		}
-- 	end

-- 	if info_text then
-- 		local selected_color = params.text_selected_color or params.text_color or tweak_data.screen_colors.text
-- 		local unselected_color = params.text_unselected_color or params.text_color or tweak_data.screen_colors.button_stage_3:with_alpha(0.25)
-- 		local blend_mode = params.text_blend_mode or params.blend_mode or "add"
-- 		local rotation = params.text_rotation or nil
-- 		font = font or tweak_data.menu.pd2_small_font
-- 		font_size = font_size or tweak_data.menu.pd2_small_font_size
-- 		local text_x = params.text_x or 0
-- 		local text_y = params.text_y or 0
-- 		local gui_object = panel:text({
-- 			layer = 5,
-- 			text = info_text,
-- 			font = font,
-- 			font_size = font_size,
-- 			color = unselected_color,
-- 			blend_mode = blend_mode,
-- 			rotation = rotation
-- 		})

-- 		gui_object:set_wrap(params.info_text_wrap or false)
-- 		gui_object:set_word_wrap(params.info_text_word_wrap or false)
-- 		gui_object:set_w(panel:w() - (border_padding * 2 + x_padding * 2 + text_x * 2))
-- 		gui_object:set_h(panel:h() - (border_padding * 2 + y_padding * 2 + text_y * 2))
-- 		gui_object:set_x(border_padding + x_padding)
-- 		gui_object:set_y(border_padding + y_padding)
-- 		gui_object:set_align(params.info_text_align or "center")
-- 		gui_object:set_vertical(params.info_text_vertical or "center")
-- 		gui_object:set_position(math.round(gui_object:x() + text_x), math.round(gui_object:y() + text_y))

-- 		info_text_object = {
-- 			gui = gui_object,
-- 			selected_text = info_text,
-- 			unselected_text = info_text,
-- 			selected_color = selected_color,
-- 			unselected_color = unselected_color,
-- 			shape = {
-- 				gui_object:shape()
-- 			}
-- 		}
-- 	end

-- 	if select_area then
-- 		select_object = panel:panel(select_area)
-- 	else
-- 		select_object = panel:panel({
-- 			halign = "scale",
-- 			align = "scale",
-- 			vertical = "scale",
-- 			valign = "scale"
-- 		})
-- 	end

-- 	if images then
-- 		local text_vertical = params.text_vertical or "top"
-- 		local async_loading = true
-- 		image_objects = {}
-- 		local requested_textures = {}
-- 		local requested_indices = {}

-- 		for _, data in ipairs(images) do
-- 			local image = data.texture

-- 			if image then
-- 				local selected_color = data.selected_color or data.color or params.image_selected_color or params.image_color or Color.white
-- 				local unselected_color = data.unselected_color or data.color or params.image_unselected_color or params.image_color or Color.white
-- 				local render_template = data.render_template or params.image_render_template
-- 				local animation_func = data.animation_func or data.anim_func or data.anim or nil
-- 				local blend_mode = data.blend_mode or params.image_blend_mode or params.blend_mode or "normal"
-- 				local texture_rect = data.texture_rect or nil
-- 				local image_size_mul = data.size_mul or 1
-- 				local layer = data.layer or 0
-- 				local visible = data.visible ~= false and true or false
-- 				local keep_aspect_ratio = data.keep_aspect_ratio ~= false and true or false
-- 				local image_rotation = data.rotation or params.image_rotation or false
-- 				local image_w = data.image_width or false
-- 				local image_h = data.image_height or false
-- 				local panel_move_x = data.panel_move_x or 0
-- 				local panel_move_y = data.panel_move_y or 0
-- 				local panel_grow_w = data.panel_grow_w or 0
-- 				local panel_grow_h = data.panel_grow_h or 0
-- 				local panel_width = panel:w() + panel_grow_w
-- 				local panel_height = panel:h() + panel_grow_h
-- 				local gui_object = panel:panel({
-- 					w = panel_width,
-- 					h = panel_height,
-- 					layer = layer + 1,
-- 					visible = visible
-- 				})

-- 				gui_object:set_center(panel:w() / 2, panel:h() / 2)
-- 				gui_object:move(panel_move_x, panel_move_y)

-- 				local image_panel = gui_object:panel({
-- 					w = image_w or gui_object:w() * image_size_mul,
-- 					h = image_h or gui_object:h() * image_size_mul
-- 				})

-- 				image_panel:set_center(gui_object:w() / 2, gui_object:h() / 2)

-- 				local params = {
-- 					box_name = name,
-- 					panel = image_panel,
-- 					selected_color = selected_color,
-- 					unselected_color = unselected_color,
-- 					render_template = render_template,
-- 					blend_mode = blend_mode,
-- 					texture_rect = texture_rect,
-- 					animation = animation_func,
-- 					keep_aspect_ratio = keep_aspect_ratio,
-- 					rotation = image_rotation
-- 				}

-- 				if not async_loading then
-- 					self:texture_loaded_clbk(Idstring(image), params)
-- 				else
-- 					local texture_loaded_clbk = callback(self, self, "texture_loaded_clbk", params)

-- 					table.insert(requested_textures, image)
-- 					table.insert(requested_indices, managers.menu_component:request_texture(image, texture_loaded_clbk))
-- 				end

-- 				table.insert(image_objects, {
-- 					gui = image_panel,
-- 					panel = gui_object,
-- 					selected_color = selected_color,
-- 					unselected_color = unselected_color,
-- 					params = params,
-- 					shape = {
-- 						image_panel:shape()
-- 					}
-- 				})
-- 			end
-- 		end

-- 		image_objects.requested_textures = requested_textures
-- 		image_objects.requested_indices = requested_indices
-- 	end

-- 	if use_background then
-- 		local selected_color = params.bg_selected_color or params.bg_color or Color.white
-- 		local unselected_color = params.bg_unselected_color or params.bg_color or Color.white
-- 		local selectable = params.bg_selectable or false
-- 		local selected_blend_mode = params.bg_selected_blend_mode or params.bg_blend_mode or params.blend_mode or "add"
-- 		local unselected_blend_mode = params.bg_unselected_blend_mode or params.bg_blend_mode or params.blend_mode or "add"
-- 		local bg_select_area = params.bg_select_area or false
-- 		local bg_rotation = params.bg_rotation or false
-- 		local gui_object = nil

-- 		if background_image then
-- 			gui_object = (bg_select_area and select_object or panel):bitmap({
-- 				layer = 0,
-- 				texture = background_image,
-- 				color = unselected_color,
-- 				blend_mode = unselected_blend_mode,
-- 				visible = not selectable
-- 			})
-- 		else
-- 			gui_object = (bg_select_area and select_object or panel):rect({
-- 				layer = 0,
-- 				color = unselected_color,
-- 				blend_mode = unselected_blend_mode,
-- 				visible = not selectable
-- 			})
-- 		end

-- 		if bg_rotation then
-- 			gui_object:set_rotation(bg_rotation)
-- 		end

-- 		bg_object = {
-- 			gui = gui_object,
-- 			selected_color = selected_color,
-- 			unselected_color = unselected_color,
-- 			selected_blend_mode = selected_blend_mode,
-- 			unselected_blend_mode = unselected_blend_mode
-- 		}
-- 	end

-- 	if box_halign == "right" then
-- 		panel:set_right(x)
-- 	else
-- 		panel:set_left(x)
-- 	end

-- 	if box_valign == "bottom" then
-- 		panel:set_bottom(y)
-- 	else
-- 		panel:set_top(y)
-- 	end

-- 	local box = {
-- 		selected = false,
-- 		name = name,
-- 		layer = layer,
-- 		panel = panel,
-- 		clbks = clbks,
-- 		text_object = text_object,
-- 		info_text_object = info_text_object,
-- 		image_objects = image_objects,
-- 		borders_object = borders_object,
-- 		bg_object = bg_object,
-- 		enabled = enabled,
-- 		select_anim = select_anim,
-- 		unselect_anim = unselect_anim,
-- 		links = links,
-- 		can_select = can_select,
-- 		params = params,
-- 		select_object = select_object,
-- 		states = states
-- 	}

-- 	if unselect_anim then
-- 		panel:animate(unselect_anim, box, true)
-- 	end

-- 	if index and not self._boxes[index] then
-- 		self._boxes[index] = box
-- 	else
-- 		self._boxes[#self._boxes + 1] = box
-- 	end

-- 	if params.update_func then
-- 		table.insert(self._update_boxes, name)
-- 	end

-- 	self._boxes_by_name[name] = box
-- 	self._boxes_by_layer[layer] = self._boxes_by_layer[layer] or {}
-- 	self._boxes_by_layer[layer][#self._boxes_by_layer[layer] + 1] = box
-- 	self._max_layer = math.max(self._max_layer, layer)

-- 	panel:set_visible(self:_box_in_state(box))

-- 	return panel, box
-- end

-- function MainMenuGui:_update_box_status(box, selected)
-- 	local box_object = nil

-- 	local function _update_box_object(object)
-- 		local variables = {
-- 			color = selected and object.selected_color or object.unselected_color or nil,
-- 			blend_mode = selected and object.selected_blend_mode or object.unselected_blend_mode or nil,
-- 			alpha = selected and object.selected_alpha or object.unselected_alpha or nil
-- 		}

-- 		if table.size(variables) > 0 then
-- 			self:_set_variables_on_gui_hierarchy(object.gui, variables)
-- 		end
-- 	end

-- 	for i, object_name in ipairs(box_objects) do
-- 		box_object = box[object_name]

-- 		if box_object then
-- 			if box_object.gui then
-- 				_update_box_object(box_object)
-- 			else
-- 				for _, object in ipairs(box_object) do
-- 					_update_box_object(object)
-- 				end
-- 			end
-- 		end
-- 	end

-- 	local text_object = box.text_object

--     local font
--     local font_size
--     if PDTH_Menu.options.font_enable then
--         font = "fonts/pdth_menu_font"
--         font_size = 16
--     end

-- 	if text_object and text_object.selected_text and text_object.unselected_text then
-- 		local panel = box.panel
-- 		local align = box.params and box.params.text_align or false
-- 		local vertical = box.params and box.params.text_vertical or false
-- 		local gui_object = text_object.gui
-- 		local border_padding = box.params and (box.params.border_padding or box.params.padding) or 5
-- 		local shrink_text = box.params and box.params.shrink_text or true
-- 		local adept_width = box.params and box.params.adept_width or false
-- 		local keep_box_ratio = box.params and box.params.keep_box_ratio or true
-- 		font = font or tweak_data.menu.pd2_small_font
-- 		font_size = font_size or tweak_data.menu.pd2_small_font_size
-- 		local text_x = box.params and box.params.text_x or 0
-- 		local text_y = box.params and box.params.text_y or 0
-- 		local wrap = box.params.text_wrap or false
-- 		local word_wrap = box.params.text_word_wrap or false
-- 		local x_padding = box.params.x_padding or 0
-- 		local y_padding = box.params.y_padding or 0

-- 		gui_object:set_font_size(font_size)
-- 		gui_object:set_text(selected and text_object.selected_text or text_object.unselected_text)
-- 		gui_object:set_wrap(wrap)
-- 		gui_object:set_word_wrap(word_wrap)

-- 		if wrap then
-- 			gui_object:set_w(panel:w() - (border_padding * 2 + x_padding * 2 + text_x * 2))
-- 			gui_object:set_h(panel:h() - (border_padding * 2 + y_padding * 2 + text_y * 2))
-- 			gui_object:set_x(border_padding + x_padding)
-- 			gui_object:set_y(border_padding + y_padding)
-- 			gui_object:set_align(align or "center")
-- 			gui_object:set_vertical(vertical or "center")
-- 		else
-- 			make_fine_text(gui_object)

-- 			local w = box.panel:w()
-- 			local needed_width = gui_object:w() + border_padding * 2

-- 			if w < needed_width then
-- 				if shrink_text then
-- 					gui_object:set_font_size(font_size * w / needed_width)
-- 					make_fine_text(gui_object)
-- 				elseif box.params and adept_width then
-- 					panel:set_w(needed_width)

-- 					if keep_box_ratio then
-- 						local ratio = w / h

-- 						panel:set_h(panel:w() / ratio)
-- 					end
-- 				end
-- 			end

-- 			if vertical == "top" then
-- 				gui_object:set_top(border_padding)
-- 			elseif vertical == "bottom" then
-- 				gui_object:set_bottom(panel:h() - border_padding)
-- 			else
-- 				gui_object:set_center_y(panel:h() / 2)
-- 			end

-- 			if align == "left" then
-- 				gui_object:set_left(border_padding)
-- 			elseif align == "right" then
-- 				gui_object:set_right(panel:w() - border_padding)
-- 			else
-- 				gui_object:set_center_x(panel:w() / 2)
-- 			end
-- 		end

-- 		gui_object:set_position(math.round(gui_object:x() + text_x), math.round(gui_object:y() + text_y))
-- 	end
-- end