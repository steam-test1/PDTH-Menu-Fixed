
-- function LevelLoadingScreenGuiScript:init(scene_gui, res, progress, base_layer)
-- 	self._level_tweak_data = arg.load_level_data.level_tweak_data
-- 	self._scale_tweak_data = arg.load_level_data.scale_tweak_data
-- 	self._gui_tweak_data = arg.load_level_data.gui_tweak_data
-- 	self._gui_data = arg.load_level_data.gui_data
-- 	self._menu_tweak_data = arg.load_level_data.menu_tweak_data
-- 	local challenges = arg.load_level_data.challenges
-- 	self._gui_data_manager = GuiDataManager:new(scene_gui, res, self._gui_data.safe_rect_pixels, self._gui_data.safe_rect, self._gui_data.aspect_ratio)
-- 	local base_panel = self._gui_data_manager:create_fullscreen_workspace():panel()
-- 	local saferect_panel = self._gui_data_manager:create_saferect_workspace():panel()

-- 	local level_image = base_panel:bitmap({
-- 		texture = "guis/textures/loading/loading_foreground",
-- 		layer = 0,
-- 	})
-- 	level_image:set_size(level_image:parent():h() * (level_image:texture_width() / level_image:texture_height()), level_image:parent():h())
-- 	level_image:set_position(0, 0)
-- 	self._indicator = base_panel:bitmap({
-- 		name = "indicator",
-- 		texture = "guis/textures/icon_loading",
-- 		layer = 2,
-- 		w = 24,
-- 	    h = 24
-- 	})
-- 	self._level_title_text = base_panel:text({
-- 		text_id = "debug_loading_level",
-- 		font = "fonts/font_large_mf",
-- 		font_size = 24,
-- 		align = "left",
-- 		halign = "left",
-- 		vertical = "bottom",
-- 		layer = 2,
-- 		h = 36
-- 	})
-- 	self._tips_head_line = base_panel:text({
-- 		visible = false,
-- 		text_id = "tip_tips",
-- 		font = "fonts/font_large_mf",
-- 		font_size = 14 * self._scale_tweak_data.small_font_multiplier,
-- 		align = "left",
-- 		wrap = true,
-- 		word_wrap = true,
-- 		layer = 2
-- 	})	
-- 	self._tips_text = base_panel:text({
-- 		visible = false,
-- 		text_id = arg.load_level_data.tip_id,
-- 		font = "fonts/font_large_mf",
-- 		font_size = 14 * self._scale_tweak_data.small_font_multiplier,
-- 		align = "left",
-- 		wrap = true,
-- 		word_wrap = true,
-- 		layer = 2
-- 	})
-- 	self._briefing_text = base_panel:text({
-- 		text_id = self._level_tweak_data.briefing_id or "debug_test_briefing",
-- 		font = "fonts/font_large_mf",
-- 		font_size = 14 * self._scale_tweak_data.small_font_multiplier,
-- 		align = "left",
-- 		wrap = true,
-- 		word_wrap = true,
-- 		layer = base_layer + 1,
-- 		w = 100,
-- 		h = 128
-- 	})
-- 	if challenges and PDTHHud then	
-- 		self._challenges_topic = saferect_panel:text({
-- 			text_id = "menu_near_completion_challenges",
-- 			font = "fonts/font_medium_mf",
-- 			font_size = self._menu_tweak_data.loading_challenge_name_font_size - 6,
-- 			align = "left",
-- 			layer = base_layer + 1
-- 		})		
-- 		self._challenges_topic:set_shape(self._challenges_topic:text_rect())
-- 		self._challenges = {}
-- 		for _, challenge in pairs(challenges) do
-- 			local panel = saferect_panel:panel({
-- 				layer = base_layer,
-- 				w = 140 * self._scale_tweak_data.loading_challenge_bar_scale,
-- 				h = 22 * self._scale_tweak_data.loading_challenge_bar_scale
-- 			})
-- 			local bg_bar = panel:rect({
-- 				x = 0,
-- 				y = 0,
-- 				w = panel:w(),
-- 				h = panel:h(),
-- 				color = Color.black:with_alpha(0.5),
-- 				align = "center",
-- 				halign = "center",
-- 				vertical = "center",
-- 				layer = base_layer + 1
-- 			})
-- 			local bar = panel:gradient({
-- 				orientation = "vertical",
-- 				gradient_points = {
-- 					0,
-- 					Color(1, 1, 0.65882355, 0),
-- 					1,
-- 					Color(1, 0.6039216, 0.4, 0)
-- 				},
-- 				x = 2 * self._scale_tweak_data.loading_challenge_bar_scale,
-- 				y = 2 * self._scale_tweak_data.loading_challenge_bar_scale,
-- 				w = (bg_bar:w() - 4 * self._scale_tweak_data.loading_challenge_bar_scale) * (challenge.amount / challenge.count),
-- 				h = bg_bar:h() - 4 * self._scale_tweak_data.loading_challenge_bar_scale,
-- 				layer = base_layer + 2,
-- 				align = "center",
-- 				halign = "center",
-- 				vertical = "center"
-- 			})
-- 			local progress_text = panel:text({
-- 				font_size = self._menu_tweak_data.loading_challenge_progress_font_size - 6,
-- 				font = "fonts/font_medium_mf",
-- 				x = 0,
-- 				y = 0,
-- 				h = bg_bar:h(),
-- 				w = bg_bar:w(),
-- 				align = "center",
-- 				halign = "center",
-- 				vertical = "center",
-- 				valign = "center",
-- 				layer = base_layer + 3,
-- 				text = challenge.amount .. "/" .. challenge.count
-- 			})
-- 			local text = saferect_panel:text({
-- 				text = string.upper(challenge.name),
-- 				font = "fonts/font_medium_mf",
-- 				font_size = self._menu_tweak_data.loading_challenge_name_font_size - 6,
-- 				align = "left",
-- 				layer = base_layer + 1
-- 			})
-- 			text:set_shape(text:text_rect())
-- 			table.insert(self._challenges, {panel = panel, text = text})
-- 		end

-- 		for i, challenge in ipairs(self._challenges) do
-- 			local h = challenge.panel:h()
-- 			challenge.panel:set_bottom((saferect_panel:bottom() - h * 2 - 2) - (h + 2) * (#self._challenges - i))
-- 			challenge.text:set_left(challenge.panel:right() + 8 * self._scale_tweak_data.loading_challenge_bar_scale)
-- 			challenge.text:set_center_y(challenge.panel:center_y())
-- 		end		

-- 		self._challenges_topic:set_visible(self._challenges[1] and true or false)
-- 		if self._challenges[1] then
-- 			self._challenges_topic:set_bottom(self._challenges[1].panel:top() - 4)
-- 		end
-- 	end
-- 	self._level_title_text:set_text(string.upper((self._level_tweak_data.name or "") .. " > " .. self._level_title_text:text()))
-- 	self._tips_text:set_text(string.upper(self._tips_text:text()))
-- 	self._upper_frame_gradient = base_panel:bitmap({
-- 		w = res.x,
-- 		h = 68,
-- 		layer = 1,
-- 		color = Color.black
-- 	})
-- 	self._lower_frame_gradient = base_panel:bitmap({
-- 		w = res.x,
-- 		h = 68,
-- 		layer = 1,
-- 		color = Color.black
-- 	})
-- 	self._pd2_logo = base_panel:bitmap({
-- 		name = "pd2_logo",
-- 		texture = self._gui_tweak_data.stonecold_small_logo,
-- 		layer = base_layer + 1,
-- 		h = 56
-- 	})
--     self._lower_frame_gradient:set_top(base_panel:top())
-- 	self._upper_frame_gradient:set_bottom(base_panel:bottom())
-- 	self._pd2_logo:set_bottom(75)
-- 	self._pd2_logo:set_right(base_panel:right() - 30)	
-- 	self._briefing_text:set_w(base_panel:w() * 0.5)
-- 	local _, _, w, h = self._briefing_text:text_rect()
-- 	self._briefing_text:set_size(w, h)
-- 	self._briefing_text:set_right(base_panel:right() - 50)
-- 	self._briefing_text:set_bottom(base_panel:bottom() - 70)
-- 	local _, _, w, h = self._level_title_text:text_rect()
-- 	self._level_title_text:set_size(w, h)
-- 	self._level_title_text:set_bottom(60)
-- 	local _, _, w, h = self._tips_text:text_rect()
-- 	self._tips_text:set_size(w,h)	
-- 	local _, _, w, h = self._tips_head_line:text_rect()
-- 	self._tips_head_line:set_size(w,h)
-- 	self._tips_text:set_top(self._level_title_text:bottom() + 30)
-- 	self._tips_head_line:set_top(self._level_title_text:bottom() + 30)
-- 	self._tips_head_line:set_left(base_panel:left() + 30)
-- 	self._tips_text:set_left(self._tips_head_line:right() + 20)
-- 	self._level_title_text:set_left(base_panel:left() + 20)
-- 	self._indicator:set_left(self._level_title_text:right() + 8)
-- 	self._indicator:set_bottom(self._level_title_text:bottom() - 1)
-- end

local function make_fine_text(text_obj)
	local x, y, w, h = text_obj:text_rect()

	text_obj:set_size(w, h)
	text_obj:set_position(math.round(text_obj:x()), math.round(text_obj:y()))
end

local function shrinkwrap(panel, padding)
	padding = padding or {}
	local padding_top = padding[1] or 0
	local padding_right = padding[2] or padding_top
	local padding_bottom = padding[3] or padding_top
	local padding_left = padding[4] or padding_right
	local children = panel:children()
	local min_x = math.huge
	local max_x = -math.huge
	local min_y = math.huge
	local max_y = -math.huge

	for _, child in ipairs(children) do
		if child:world_left() < min_x then
			min_x = child:world_left()
		end

		if max_x < child:world_right() then
			max_x = child:world_right()
		end

		if child:world_top() < min_y then
			min_y = child:world_top()
		end

		if max_y < child:world_bottom() then
			max_y = child:world_bottom()
		end
	end

	local offset_x = min_x - panel:world_x()
	local offset_y = min_y - panel:world_y()

	if min_x ~= 0 or min_y ~= 0 then
		for _, child in ipairs(children) do
			child:set_x(child:x() - offset_x + padding_left)
			child:set_y(child:y() - offset_y + padding_top)
		end
	end

	panel:set_world_position(min_x - padding_left, min_y - padding_top)
	panel:set_size(max_x - min_x + padding_right + padding_left, max_y - min_y + padding_top + padding_bottom)
end

function LevelLoadingScreenGuiScript:init(scene_gui, res, progress, base_layer)
	self._level_tweak_data = arg.load_level_data.level_tweak_data
	self._scale_tweak_data = arg.load_level_data.scale_tweak_data
	self._gui_tweak_data = arg.load_level_data.gui_tweak_data
	self._gui_data = arg.load_level_data.gui_data
	self._menu_tweak_data = arg.load_level_data.menu_tweak_data
	local challenges = arg.load_level_data.challenges
	self._gui_data_manager = GuiDataManager:new(scene_gui, res, self._gui_data.safe_rect_pixels, self._gui_data.safe_rect, self._gui_data.aspect_ratio)
	local base_panel = self._gui_data_manager:create_fullscreen_workspace():panel()
	local saferect_panel = self._gui_data_manager:create_saferect_workspace():panel()
	local get_texture

	if PDTH_Menu.options.enable_pdth_level_loading then
		get_texture = "guis/textures/loading/loading_foreground_pdth_original"
	else
		get_texture = self._gui_data.bg_texture
	end

	local level_image = base_panel:bitmap({
		texture = get_texture,
		layer = 0,
	})
	level_image:set_size(level_image:parent():h() * (level_image:texture_width() / level_image:texture_height()), level_image:parent():h())
	level_image:set_position(0, 0)
	self._indicator = base_panel:bitmap({
		name = "indicator",
		texture = "guis/textures/icon_loading",
		layer = 2,
		w = 24,
	    h = 24
	})
	self._level_title_text = base_panel:text({
		text_id = "debug_loading_level",
		font = "fonts/font_large_mf",
		font_size = 24,
		align = "left",
		halign = "left",
		vertical = "bottom",
		layer = 2,
		h = 36
	})

	if arg.load_level_data.tip then
		self._loading_hint = self:_make_loading_hint(saferect_panel, arg.load_level_data.tip)
	end

	if challenges then
		self._challenges_topic = saferect_panel:text({
			text_id = "menu_near_completion_challenges",
			font = "fonts/font_medium_mf",
			font_size = self._menu_tweak_data.loading_challenge_name_font_size - 6,
			align = "left",
			layer = base_layer + 1
		})
		self._challenges_topic:set_shape(self._challenges_topic:text_rect())
		self._challenges = {}
		for _, challenge in pairs(challenges) do
			local panel = saferect_panel:panel({
				layer = base_layer,
				w = 140 * self._scale_tweak_data.loading_challenge_bar_scale,
				h = 22 * self._scale_tweak_data.loading_challenge_bar_scale
			})
			local bg_bar = panel:rect({
				x = 0,
				y = 0,
				w = panel:w(),
				h = panel:h(),
				color = Color.black:with_alpha(0.5),
				align = "center",
				halign = "center",
				vertical = "center",
				layer = base_layer + 1
			})
			local bar = panel:gradient({
				orientation = "vertical",
				gradient_points = {
					0,
					Color(1, 1, 0.65882355, 0),
					1,
					Color(1, 0.6039216, 0.4, 0)
				},
				x = 2 * self._scale_tweak_data.loading_challenge_bar_scale,
				y = 2 * self._scale_tweak_data.loading_challenge_bar_scale,
				w = (bg_bar:w() - 4 * self._scale_tweak_data.loading_challenge_bar_scale) * (challenge.amount / challenge.count),
				h = bg_bar:h() - 4 * self._scale_tweak_data.loading_challenge_bar_scale,
				layer = base_layer + 2,
				align = "center",
				halign = "center",
				vertical = "center"
			})
			local progress_text = panel:text({
				font_size = self._menu_tweak_data.loading_challenge_progress_font_size - 6,
				font = "fonts/font_medium_mf",
				x = 0,
				y = 0,
				h = bg_bar:h(),
				w = bg_bar:w(),
				align = "center",
				halign = "center",
				vertical = "center",
				valign = "center",
				layer = base_layer + 3,
				text = challenge.amount .. "/" .. challenge.count
			})
			local text = saferect_panel:text({
				text = string.upper(challenge.name),
				font = "fonts/font_medium_mf",
				font_size = self._menu_tweak_data.loading_challenge_name_font_size - 6,
				align = "left",
				layer = base_layer + 1
			})
			text:set_shape(text:text_rect())
			table.insert(self._challenges, {panel = panel, text = text})
		end

		for i, challenge in ipairs(self._challenges) do
			local h = challenge.panel:h()
			challenge.panel:set_bottom((saferect_panel:bottom() - h * 2 - 2) - (h + 2) * (#self._challenges - i))
			challenge.text:set_left(challenge.panel:right() + 8 * self._scale_tweak_data.loading_challenge_bar_scale)
			challenge.text:set_center_y(challenge.panel:center_y())
		end

		self._challenges_topic:set_visible(self._challenges[1] and true or false)
		if self._challenges[1] then
			self._challenges_topic:set_bottom(self._challenges[1].panel:top() - 4)
		end
	end

	self._level_title_text:set_text(string.upper((self._level_tweak_data.name or "") .. " > " .. self._level_title_text:text()))

	self._upper_frame_gradient = base_panel:bitmap({
		w = res.x,
		h = 68,
		layer = 1,
		color = Color.black
	})
	self._lower_frame_gradient = base_panel:bitmap({
		w = res.x,
		h = 68,
		layer = 1,
		color = Color.black
	})
	self._pd2_logo = base_panel:bitmap({
		name = "pd2_logo",
		texture = self._gui_tweak_data.stonecold_small_logo,
		layer = base_layer + 1,
		h = 56
	})
	self._lower_frame_gradient:set_top(base_panel:top())
	self._upper_frame_gradient:set_bottom(base_panel:bottom())
	self._pd2_logo:set_bottom(75)
	self._pd2_logo:set_right(base_panel:right() - 30)
	local _, _, w, h = self._level_title_text:text_rect()
	self._level_title_text:set_size(w, h)
	self._level_title_text:set_bottom(60)
	self._level_title_text:set_left(base_panel:left() + 20)
	self._indicator:set_left(self._level_title_text:right() + 8)
	self._indicator:set_bottom(self._level_title_text:bottom() - 1)

	local coords = arg.load_level_data.controller_coords

	if coords then
		self._controller = self:_make_controller_hint(saferect_panel, coords)

		if arg.load_level_data.tip then
			self._controller:move(0, -110)
		end
	end
end

function LevelLoadingScreenGuiScript:_make_loading_hint(parent, tip)
	local container = parent:panel()
	local hint_text_width = 450
	local hint_title_top_offset = 5
	local font = "fonts/font_large_mf"
	local font_size = 14 * self._scale_tweak_data.small_font_multiplier
	local hint_title = container:text({
		text = tip.title,
		font = font,
		font_size = font_size,
		color = Color.white,
		layer = 2
	})
	local hint_box = container:panel()
	local hint_text = hint_box:text({
		wrap = true,
		word_wrap = true,
		text = tip.text,
		font = font,
		font_size = font_size,
		color = Color.white,
		width = hint_text_width,
		layer = 2
	})

	make_fine_text(hint_title)
	make_fine_text(hint_text)
	hint_box:set_width(hint_text_width + 187 + 16)
	hint_box:set_height(142)
	hint_text:set_lefttop(187, 16)
	hint_title:set_leftbottom(hint_text:left(), hint_box:top())
	container:set_center_y(hint_box:center_y())
	BoxGuiObject:new(hint_box, {
		sides = {
			0,
			0,
			0,
			0
		}
	})
	shrinkwrap(container)
	container:set_center_x(parent:width() * 0.5 - 20)
	container:set_bottom(parent:height() + 45)

	return container
end

function LevelLoadingScreenGuiScript:_make_controller_hint(parent, coords)
	local container = parent:panel()
	local font = arg.load_level_data.coords_font or "fonts/font_large_mf"
	local font_size = arg.load_level_data.coords_font_size or 14
	local controller_shapes = arg.load_level_data.controller_shapes or {
		{
			position = {
				cy = 0.5,
				cx = 0.5
			},
			texture_rect = {
				0,
				0,
				512,
				256
			}
		}
	}
	local controllers = {}
	local controller, position = nil

	for i, shape in ipairs(controller_shapes) do
		controller = container:bitmap({
			texture = arg.load_level_data.controller_image or "guis/textures/controller",
			layer = i,
			texture_rect = shape.texture_rect
		})
		position = shape.position or {}

		controller:set_center(container:w() * (position.cx or 0.5), container:h() * (position.cy or 0.5))

		if position.x then
			if position.x < 0 then
				controller:set_right(container:w() + position.x)
			else
				controller:set_left(position.x)
			end
		end

		if position.y then
			if position.y < 0 then
				controller:set_bottom(container:h() + position.y)
			else
				controller:set_top(position.y)
			end
		end

		controller:move(position.mx or 0, position.my or 0)
		table.insert(controllers, controller)
	end

	for id, data in pairs(coords) do
		controller = controllers[data.c or 1]
		data.text = container:text({
			name = data.id,
			text = data.string,
			font_size = font_size,
			font = font,
			align = data.align,
			vertical = data.vertical,
			color = data.color,
			layer = 2
		})
		local _, _, w, h = data.text:text_rect()

		data.text:set_size(w, h)

		if data.x then
			local x = controller:x() + data.x
			local y = controller:y() + data.y

			if data.align == "left" then
				data.text:set_left(x)
			elseif data.align == "right" then
				data.text:set_right(x)
			elseif data.align == "center" then
				data.text:set_center_x(x)
			end

			if data.vertical == "top" then
				data.text:set_top(y)
			elseif data.vertical == "bottom" then
				data.text:set_bottom(y)
			else
				data.text:set_center_y(y)
			end
		end
	end

	return container
end