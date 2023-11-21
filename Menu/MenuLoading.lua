
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

	local level_image = base_panel:bitmap({
		texture = "guis/textures/loading/loading_foreground",
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
	self._tips_head_line = base_panel:text({
		visible = false,
		text_id = "tip_tips",
		font = "fonts/font_large_mf",
		font_size = 14 * self._scale_tweak_data.small_font_multiplier,
		align = "left",
		wrap = true,
		word_wrap = true,
		layer = 2
	})	
	self._tips_text = base_panel:text({
		visible = false,
		text_id = arg.load_level_data.tip_id,
		font = "fonts/font_large_mf",
		font_size = 14 * self._scale_tweak_data.small_font_multiplier,
		align = "left",
		wrap = true,
		word_wrap = true,
		layer = 2
	})
	self._briefing_text = base_panel:text({
		text_id = self._level_tweak_data.briefing_id or "debug_test_briefing",
		font = "fonts/font_large_mf",
		font_size = 14 * self._scale_tweak_data.small_font_multiplier,
		align = "left",
		wrap = true,
		word_wrap = true,
		layer = base_layer + 1,
		w = 100,
		h = 128
	})
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
	self._level_title_text:set_text(string.upper((self._level_tweak_data.name and self._level_tweak_data.name or "") .. " > " .. self._level_title_text:text()))
	self._tips_text:set_text(string.upper(self._tips_text:text()))
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
	self._briefing_text:set_w(base_panel:w() * 0.5)
	local _, _, w, h = self._briefing_text:text_rect()
	self._briefing_text:set_size(w, h)
	self._briefing_text:set_right(base_panel:right() - 50)
	self._briefing_text:set_bottom(base_panel:bottom() - 70)
	local _, _, w, h = self._level_title_text:text_rect()
	self._level_title_text:set_size(w, h)
	self._level_title_text:set_bottom(60)
	local _, _, w, h = self._tips_text:text_rect()
	self._tips_text:set_size(w,h)	
	local _, _, w, h = self._tips_head_line:text_rect()
	self._tips_head_line:set_size(w,h)
	self._tips_text:set_top(self._level_title_text:bottom() + 30)
	self._tips_head_line:set_top(self._level_title_text:bottom() + 30)
	self._tips_head_line:set_left(base_panel:left() + 30)
	self._tips_text:set_left(self._tips_head_line:right() + 20)
	self._level_title_text:set_left(base_panel:left() + 20)
	self._indicator:set_left(self._level_title_text:right() + 8)
	self._indicator:set_bottom(self._level_title_text:bottom() - 1)
end
 