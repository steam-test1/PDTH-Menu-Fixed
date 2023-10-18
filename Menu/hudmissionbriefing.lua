
require("lib/managers/menu/MenuBackdropGUI")
function HUDMissionBriefing:init(hud, workspace)
	self._backdrop = MenuBackdropGUI:new(workspace)
	self._backdrop:create_black_borders()
	self._hud = hud
	self._workspace = workspace
	self._singleplayer = Global.game_settings.single_player
	local safe_rect_pixels = managers.viewport:get_safe_rect_pixels()
	local bg_font = tweak_data.menu.pd2_massive_font
	local title_font = tweak_data.menu.pd2_large_font
	local content_font = tweak_data.menu.pd2_medium_font
	local text_font = tweak_data.menu.pd2_small_font
	local bg_font_size = tweak_data.menu.pd2_massive_font_size
	local title_font_size = tweak_data.menu.pd2_large_font_size
	local content_font_size = tweak_data.menu.pd2_medium_font_size
	local text_font_size = tweak_data.menu.pd2_small_font_size
	local interupt_stage = managers.job:interupt_stage()
	self._background_layer_one = self._backdrop:get_new_background_layer()
	self._background_layer_two = self._backdrop:get_new_background_layer()
	self._background_layer_three = self._backdrop:get_new_background_layer()
	self._foreground_layer_one = self._backdrop:get_new_foreground_layer()
	self._backdrop:set_panel_to_saferect(self._background_layer_one)
	self._backdrop:set_panel_to_saferect(self._foreground_layer_one)
	local safe_rect_pixels = managers.viewport:get_safe_rect_pixels()
	self._ready_slot_panel = self._background_layer_three:panel({
		name = "player_slot_panel",
		w = self._foreground_layer_one:w() / 2,
		h = 50 * 4 + 20
	})
	self._info_bg_rect = self._background_layer_three:rect({
		visible = true,
		layer = -1,
		w = 480, 
		color = Color(0.5, 0, 0, 0)
	})
	self._info_bg_rect:set_top(self._foreground_layer_one:top())
	self._gui_info_panel = self._background_layer_three:panel({
		visible = true,
		layer = 0,
		w = 480,
		h = 270,
	})
	local server_peer = Network:is_server() and managers.network:session():local_peer() or managers.network:session():server_peer()
	local is_multiplayer = not Global.game_settings.single_player
	local load_level_data
	-- if Global.load_level then
		-- load_level_data = {
		-- 	level_data = Global.level_data,
		-- 	level_tweak_data = tweak_data.levels[Global.level_data.level_id] or {}
		-- }
		-- load_level_data.level_tweak_data.name = load_level_data.level_tweak_data.name_id and managers.localization:text(load_level_data.level_tweak_data.name_id)
		-- load_level_data.gui_tweak_data = tweak_data.load_level
		-- local load_data = load_level_data.level_tweak_data.load_data
		local job_data = managers.job:current_job_data() or {}
		local level_data = tweak_data.levels[Global.game_settings.level_id]
		local bg_texture = level_data.load_screen or job_data.load_screen or "guis/textures/loading/loading_bg" 
		-- local level_data = tweak_data.levels[Global.game_settings.level_id]
		-- local level_rect = "level_image_".. string.gsub(Global.game_settings.level_id, "_day", ""):gsub("_night",""):gsub("_skip2",""):gsub("_skip1",""):gsub("_prof","")
		self._level_image = self._background_layer_three:bitmap({
			texture = bg_texture,
			-- texture_rect = PDTH_Menu[level_rect],
			visible = true,
			layer = 0,	
			w = self._info_bg_rect:w() - 16,
			h = 270
		})
		-- log("[PDTH Menu] Current level ID: " .. tostring(level_rect) .. " = " .. tostring(PDTH_Menu[level_rect]))
		-- for index, job_id in ipairs(tweak_data.narrative:get_jobs_index()) do
		-- 	if not PDTH_Menu["level_image_"..string.gsub(job_id, "_day", ""):gsub("_night",""):gsub("_skip2",""):gsub("_skip1",""):gsub("_prof","")] then
		-- 		log(job_id .. " is missing...")
		-- 	end
		-- end
	-- end
	self._upper_frame_gradient = self._background_layer_three:rect({
		x = 0,
		y = 0,
		h = 68,
		layer = -1,
		color = Color.black
	})
	self._lower_frame_gradient = self._background_layer_three:rect({
		x = 0,
		y = 0,
		h = 68,
		layer = -1,
		color = Color.black
	})
	self._pd2_logo = self._background_layer_three:bitmap({
		name = "logo",
		texture = tweak_data.load_level.stonecold_small_logo,
		layer = 1,
		w = 256,
		h = 56
	})	
	local level_data = tweak_data.levels[Global.game_settings.level_id]
	self._upper_frame_gradient:set_top(self._background_layer_three:top())
	self._lower_frame_gradient:set_bottom(self._background_layer_three:bottom())
	self._pd2_logo:set_bottom(75)
	self._pd2_logo:set_right(self._background_layer_three:right() - 30)	
	self._server_title = self._gui_info_panel:text({
		visible = is_multiplayer,
		name = "server_title",
		text = string.upper(managers.localization:text("menu_lobby_server_title")),
		font = PDTHMenu_font,
		font_size = tweak_data.menu.small_font_size,
		align = "left",
		vertical = "center",
		w = 256,
		h = content_font_size,
		layer = 1
	})
	self._server_text = self._gui_info_panel:text({
		visible = is_multiplayer,
		name = "server_text",
		text = string.upper("" .. server_peer:name()),
		font = PDTHMenu_font,
		color = PDTHMenu_color_marker,
		font_size = tweak_data.menu.small_font_size,
		align = "left",
		vertical = "center",
		w = 256,
		h = content_font_size,
		layer = 1
	})
	self._server_info_title = self._gui_info_panel:text({
		visible = is_multiplayer,
		name = "server_info_title",
		text = string.upper(managers.localization:text("menu_lobby_server_state_title")),
		font = PDTHMenu_font,
		font_size = tweak_data.menu.small_font_size,
		align = "left",
		vertical = "center",
		w = 256,
		h = content_font_size,
		layer = 1
	})
	self._server_info_text = self._gui_info_panel:text({
		visible = is_multiplayer,
		name = "server_info_text",
		text = string.upper(managers.localization:text(self._server_state_string_id or "menu_lobby_server_state_in_lobby")),
		color = PDTHMenu_color_marker,
		font = PDTHMenu_font,
		font_size = tweak_data.menu.small_font_size,
		align = "left",
		vertical = "center",
		w = 256,
		h = content_font_size,
		layer = 1
	})
	self._level_title = self._gui_info_panel:text({
		name = "level_title",
		text = string.upper(managers.localization:text("menu_lobby_campaign_title")),
		font = PDTHMenu_font,
		font_size = tweak_data.menu.small_font_size,
		align = "left",
		vertical = "center",
		w = 256,
		h = content_font_size,
		layer = 1
	})
	local mission = managers.crime_spree:get_mission()
	local cs_level = managers.crime_spree:spree_level()
	local lvl_name = utf8.to_upper("" .. managers.localization:text(level_data.name_id))
	if managers.crime_spree:is_active() then
		lvl_name = utf8.to_upper("" .. managers.localization:text(level_data.name_id)) .. " + " .. mission.add
	end
	self._level_text = self._gui_info_panel:text({
		name = "level_text",
		text = lvl_name,
		color = PDTHMenu_color_marker,
		font = PDTHMenu_font,
		font_size = tweak_data.menu.small_font_size,
		align = "left",
		vertical = "center",
		w = 256,
		h = content_font_size,
		layer = 1
	})
	local diff_title = string.upper(managers.localization:text("menu_lobby_difficulty_title"))
	if managers.crime_spree:is_active() then
		diff_title = string.upper(managers.localization:text("steam_rp_current_spree", {
			level = ": "
		}))
	end
	self._difficulty_title = self._gui_info_panel:text({
		name = "difficulty_title",
		text = diff_title,
		font = PDTHMenu_font,
		font_size = tweak_data.menu.small_font_size,
		align = "left",
		vertical = "center",
		w = 256,
		h = content_font_size,
		layer = 1
	})
	local difficulty = Global.game_settings.difficulty
	if Global.game_settings.difficulty == "overkill" then
		difficulty = "very_hard"
	elseif Global.game_settings.difficulty == "overkill_145" then
		difficulty = "overkill"
	elseif Global.game_settings.difficulty == "overkill_290" then
		difficulty = "apocalypse"
	end
	local diff_text = string.upper(managers.localization:text("menu_difficulty_" .. difficulty))
	if managers.crime_spree:is_active() then
		diff_text = string.upper(managers.localization:text("clean_cs_level", {
			level = cs_level
		}))
	end
	self._difficulty_text = self._gui_info_panel:text({
		name = "difficulty_text",
		text = diff_text,
		color = PDTHMenu_color_marker,
		font = PDTHMenu_font,
		font_size = tweak_data.menu.small_font_size,
		align = "left",
		vertical = "center",
		w = 256,
		h = content_font_size,
		layer = 1
	})
	if managers.skirmish:is_skirmish() then
		self._difficulty_title:set_visible(false)
		self._difficulty_text:set_visible(false)
	end
	self._day_title = self._gui_info_panel:text({
		name = "day_title",
		text = string.upper(managers.localization:text("menu_day_short", {day = ""}))..":",
		font = PDTHMenu_font,
		font_size = tweak_data.menu.small_font_size,
		align = "left",
		vertical = "center",
		w = 256,
		h = content_font_size,
		layer = 1,
		visible = false
	})	
	self._day_text = self._gui_info_panel:text({
		name = "day_text",
		text = tostring(managers.job:current_stage()) .. "/" ..tostring(#managers.job:current_job_chain_data()),
		color = PDTHMenu_color_marker,
		font = PDTHMenu_font,
		font_size = tweak_data.menu.small_font_size,
		align = "left",
		vertical = "center",
		w = 256,
		h = content_font_size,
		layer = 1,
		visible = false
	})
	
	self._current_stage_data = managers.job:current_stage_data()
	self._current_job_chain = managers.job:current_job_chain_data()
	
	if #self._current_job_chain > 1 then
		self._day_title:set_visible(true)
		self._day_text:set_visible(true)
	end

	local offset = 22 
	local x, y, w, h = self._server_title:text_rect()
	self._server_title:set_x(10)
	self._server_title:set_y(10)
	self._server_title:set_w(w)
	self._server_text:set_lefttop(self._server_title:righttop())
	self._server_text:set_w(self._gui_info_panel:w())

	local x, y, w, h = self._server_info_title:text_rect()
	self._server_info_title:set_x(10)
	self._server_info_title:set_y(10 + offset)
	self._server_info_title:set_w(w)
	self._server_info_text:set_lefttop(self._server_info_title:righttop())
	self._server_info_text:set_w(self._gui_info_panel:w())

	local x, y, w, h = self._level_title:text_rect()
	self._level_title:set_x(10)
	self._level_title:set_y(is_multiplayer and 10 + offset * 2 or 10)
	self._level_title:set_w(w)
	self._level_text:set_lefttop(self._level_title:righttop())
	self._level_text:set_w(self._gui_info_panel:w())
	
	if not managers.skirmish:is_skirmish() then
		local x, y, w, h = self._difficulty_title:text_rect()
		self._difficulty_title:set_x(10)
		self._difficulty_title:set_y(10 + offset * (is_multiplayer and 3 or 1))
		self._difficulty_title:set_w(w)
		self._difficulty_text:set_lefttop(self._difficulty_title:righttop())
		self._difficulty_text:set_w(self._gui_info_panel:w())	
	end

	if #self._current_job_chain > 1 then
		local x, y, w, h = self._day_title:text_rect()
		self._day_title:set_x(10)
		self._day_title:set_y(10 + offset * (is_multiplayer and 4 or 2))
		self._day_title:set_w(w)
		self._day_text:set_lefttop(self._day_title:righttop())
		self._day_text:set_w(self._gui_info_panel:w())
	end

	self._ready_slot_panel:set_bottom(self._foreground_layer_one:h())
	self._ready_slot_panel:set_left(self._foreground_layer_one:left() - 15 )	
	self._info_bg_rect:set_left(self._foreground_layer_one:left() - 5 )	
	self._level_image:set_left(self._info_bg_rect:left() + 8)	
	self._gui_info_panel:set_left(self._foreground_layer_one:left())	
	self._level_image:set_top(self._upper_frame_gradient:bottom() + 8)	
	self._gui_info_panel:set_top(self._level_image:top())	
	local voice_icon, voice_texture_rect = tweak_data.hud_icons:get_icon_data("mugshot_talk")
	local infamy_icon, infamy_rect = tweak_data.hud_icons:get_icon_data("infamy_icon")
	for i = 1, 4 do
		local color_id = i
		local color = tweak_data.chat_colors[color_id]
		local slot_panel = self._ready_slot_panel:panel({
			name = "slot_" .. tostring(i),
			w = 480,
			h = 50,
			y = (i - 1) * 50 ,
			x = 10,
		})
		local bg_rect = slot_panel:rect({
			name = "bg_rect",
			color = Color.white:with_alpha(0.1),
			h = 42, 
			visible = i == 1 and true or false,
			layer = 0,
		})
		local criminal = slot_panel:text({
			name = "criminal",
			visible = false,
			font = tweak_data.hud.small_font,
			font_size = tweak_data.hud.small_font_size,
			color = color,
			text = tweak_data.gui.LONGEST_CHAR_NAME,
			align = "left",
			vertical = "center"
		})
	    local mugshot = slot_panel:bitmap({
	    	name = "mugshot",
	    	visible = false,
			layer = 1,
			w = 40,
			h = 40,
			x = 8,
		    texture = "PDTHMenu/trial_bridge",
		    texture_rect = PDTH_Menu.lobby_icon_unknown
		})
		mugshot:set_bottom(bg_rect:bottom())
		local level = slot_panel:text({
			name = "level",
			visible = false,
			text = managers.localization:text("menu_lobby_level"),
			font = text_font,
			font_size =  tweak_data.hud.small_font_size,
			w = 256,
			h = 24,
			align = "right",
			layer = 1
		})
		local _,_,_,h = level:text_rect()
		level:set_h(h)
		local voice = slot_panel:bitmap({
			name = "voice",
			texture = voice_icon,
			visible = false,
			layer = 2,
			texture_rect = voice_texture_rect,
			w = voice_texture_rect[3],
			h = voice_texture_rect[4],
			color = color,
			x = 10
		})
		local name = slot_panel:text({
			name = "name",
			text = managers.localization:text("menu_lobby_player_slot_available") .. "  ",
			font = text_font,
			font_size =  tweak_data.hud.small_font_size,
			color = color:with_alpha(0.5),
			align = "left",
			vertical = "center",
			w = 256,
			h = text_font_size,
			layer = 1,
		})
		local _,_,_,h = name:text_rect()
		name:set_h(h)
		local status = slot_panel:text({
			name = "status",
			visible = true,
			text = "  ",
			font = tweak_data.hud.small_font,
			font_size = tweak_data.hud.small_font_size,
			w = 256,
			h = 24,
			align = "right",
			layer = 1,
			color = tweak_data.screen_colors.text:with_alpha(0.5)
		})
		local infamy = slot_panel:bitmap({
			name = "infamy",
			texture = infamy_icon,
			texture_rect = infamy_rect,
			visible = false,
			layer = 2,
			color = color,
			y = 1
		})
		local detection = slot_panel:panel({
			name = "detection",
			layer = 2,
			visible = false,
			w = 16,
			h = 16
		})
		local detection_ring_left_bg = detection:bitmap({
			name = "detection_left_bg",
			texture = "guis/textures/pd2/mission_briefing/inv_detection_meter",
			alpha = 0.2,
			blend_mode = "normal",
			w = detection:w(),
			h = detection:h()
		})
		local detection_ring_right_bg = detection:bitmap({
			name = "detection_right_bg",
			texture = "guis/textures/pd2/mission_briefing/inv_detection_meter",
			alpha = 0.2,
			blend_mode = "normal",
			w = detection:w(),
			h = detection:h()
		})
		detection_ring_right_bg:set_texture_rect(detection_ring_right_bg:texture_width(), 0, -detection_ring_right_bg:texture_width(), detection_ring_right_bg:texture_height())
		local detection_ring_left = detection:bitmap({
			name = "detection_left",
			texture = "guis/textures/pd2/mission_briefing/inv_detection_meter",
			render_template = "VertexColorTexturedRadial",
			blend_mode = "normal",
			layer = 1,
			w = detection:w(),
			h = detection:h()
		})
		local detection_ring_right = detection:bitmap({
			name = "detection_right",
			texture = "guis/textures/pd2/mission_briefing/inv_detection_meter",
			render_template = "VertexColorTexturedRadial",
			blend_mode = "normal",
			layer = 1,
			w = detection:w(),
			h = detection:h()
		})
		detection_ring_right:set_texture_rect(detection_ring_right:texture_width(), 0, -detection_ring_right:texture_width(), detection_ring_right:texture_height())
		local detection_value = slot_panel:text({
			name = "detection_value",
			font_size = text_font_size - 2,
			font = text_font,
			color = color,
			text = " ",
			layer = 2,
			blend_mode = "normal",
			align = "left",
			vertical = "center"
		})
		local _,_,_,h = detection_value:text_rect()
		detection_value:set_h(h)
		detection_value:set_visible(detection:visible())
		local _, _, w, _ = criminal:text_rect()
		voice:set_left(w + 2)
		criminal:set_w(w)
		criminal:set_align("right")
		criminal:set_text("")
		name:set_left(voice:right() - 15)
		name:move(0, 4)
		detection:set_left(voice:right() - 15)
		detection_value:set_left(detection:right() + 2)
		detection:set_top(name:bottom() + 4)
		detection_value:set_top(name:bottom() + 4) 
		status:set_right(slot_panel:w() - 4)
		level:set_right(slot_panel:w() - 4)
		level:move(0, 4)
		status:set_top(level:bottom() + 4)
		infamy:set_left(name:x())
	end
	if not managers.job:has_active_job() then
		return
	end
	self._current_contact_data = managers.job:current_contact_data()
	self._current_level_data = managers.job:current_level_data()
	self._current_job_data = managers.job:current_job_data()
	self._job_class = self._current_job_data and self._current_job_data.jc or 0
	local contact_gui = self._background_layer_two:gui(self._current_contact_data.assets_gui, {})
	local contact_pattern = contact_gui:has_script() and contact_gui:script().pattern
	local padding_y = 60
	self._paygrade_panel = self._background_layer_one:panel({
		h = 70,
		w = 210,
		y = padding_y
	})
	local pg_text = self._foreground_layer_one:text({
		name = "pg_text",
		text = utf8.to_upper(managers.localization:text("menu_risk")),
		y = padding_y,
		h = 32,
		visible = false,
		align = "right",
		vertical = "center",
		font_size = content_font_size,
		font = content_font,
		color = tweak_data.screen_colors.text
	})
	local _, _, w, h = pg_text:text_rect()
	pg_text:set_size(w, h)
	local job_stars = managers.job:current_job_stars()
	local job_and_difficulty_stars = managers.job:current_job_and_difficulty_stars()
	local difficulty_stars = managers.job:current_difficulty_stars()
	local filled_star_rect = {
		0,
		32,
		32,
		32
	}
	local empty_star_rect = {
		32,
		32,
		32,
		32
	}
	local num_stars = 0
	local x = 0
	local y = 0
	local star_size = 18
	local panel_w = 0
	local panel_h = 0
	local risk_color = tweak_data.screen_colors.risk
	local risks = {
		"risk_swat",
		"risk_fbi",
		"risk_death_squad"
	}
	if not Global.SKIP_OVERKILL_290 then
		table.insert(risks, "risk_murder_squad")
	end
	pg_text:set_color(risk_color)
	self._paygrade_panel:set_h(panel_h)
	self._paygrade_panel:set_w(panel_w)
	self._paygrade_panel:set_right(self._background_layer_one:w())
	pg_text:set_right(self._paygrade_panel:left())
	self._job_schedule_panel = self._background_layer_one:panel({
		visible = false,
		h = 70,
		w = self._background_layer_one:w() / 2
	})
	self._job_schedule_panel:set_right(self._foreground_layer_one:w())
	self._job_schedule_panel:set_top(padding_y + content_font_size + 15)
	if interupt_stage then
		self._job_schedule_panel:set_alpha(0.2)
		if not tweak_data.levels[interupt_stage].bonus_escape then
			self._interupt_panel = self._background_layer_one:panel({
				h = 125,
				w = self._background_layer_one:w() / 2,
				visible = false
			})
			local interupt_text = self._interupt_panel:text({
				name = "job_text",
				text = utf8.to_upper(managers.localization:text("menu_escape")),
				h = 80,
				align = "left",
				vertical = "top",
				font_size = 70,
				font = bg_font,
				color = tweak_data.screen_colors.important_1,
				layer = 5
			})
			local _, _, w, h = interupt_text:text_rect()
			interupt_text:set_size(w, h)
			interupt_text:rotate(-15)
			interupt_text:set_center(self._interupt_panel:w() / 2, self._interupt_panel:h() / 2)
			self._interupt_panel:set_shape(self._job_schedule_panel:shape())
		end
	end
	local num_stages = self._current_job_chain and #self._current_job_chain or 0
	local day_color = tweak_data.screen_colors.item_stage_1
	local chain = self._current_job_chain and self._current_job_chain or {}
	local js_w = self._job_schedule_panel:w() / 7
	local js_h = self._job_schedule_panel:h()
	for i = 1, 7 do
		local day_font = text_font
		local day_font_size = text_font_size
		day_color = tweak_data.screen_colors.item_stage_1
		if i > num_stages then
			day_color = tweak_data.screen_colors.item_stage_3
		elseif i == managers.job:current_stage() then
			day_font = content_font
			day_font_size = content_font_size
		end
		local day_text = self._job_schedule_panel:text({
			name = "day_" .. tostring(i),
			text = utf8.to_upper(managers.localization:text("menu_day_short", {
				day = tostring(i)
			})),
			align = "center",
			vertical = "center",
			font_size = day_font_size,
			font = day_font,
			w = js_w,
			h = js_h,
			color = day_color,
			blend_mode = "normal"
		})
		if i ~= 1 or not 0 then
			day_text:set_left((self._job_schedule_panel:child("day_" .. tostring(i - 1)):right()))
		end
		local ghost = self._job_schedule_panel:bitmap({
			name = "ghost_" .. tostring(i),
			texture = "guis/textures/pd2/cn_minighost",
			w = 16,
			h = 16,
			blend_mode = "normal",
			color = tweak_data.screen_colors.ghost_color
		})
		ghost:set_center(day_text:center_x(), day_text:center_y() + day_text:h() * 0.25)
		local ghost_visible = i <= num_stages and managers.job:is_job_stage_ghostable(managers.job:current_real_job_id(), i)
		ghost:set_visible(ghost_visible)
		if ghost_visible then
			self:_apply_ghost_color(ghost, i, not Network:is_server())
		end
	end
	for i = 1, managers.job:current_stage() or 0 do
		local stage_marker = self._job_schedule_panel:bitmap({
			name = "stage_done_" .. tostring(i),
			texture = "guis/textures/pd2/mission_briefing/calendar_xo",
			texture_rect = {
				i == managers.job:current_stage() and 80 or 0,
				0,
				80,
				64
			},
			w = 80,
			h = 64,
			layer = 1,
			rotation = math.rand(-10, 10)
		})
		stage_marker:set_center(self._job_schedule_panel:child("day_" .. tostring(i)):center())
		stage_marker:move(math.random(4) - 2, math.random(4) - 2)
	end
	if managers.job:has_active_job() then
		local payday_stamp = self._job_schedule_panel:bitmap({
			name = "payday_stamp",
			texture = "guis/textures/pd2/mission_briefing/calendar_xo",
			texture_rect = {
				160,
				0,
				96,
				64
			},
			w = 96,
			h = 64,
			layer = 2,
			rotation = math.rand(-5, 5)
		})
		payday_stamp:set_center(self._job_schedule_panel:child("day_" .. tostring(num_stages)):center())
		payday_stamp:move(math.random(4) - 2 - 7, math.random(4) - 2 + 8)
		if payday_stamp:rotation() == 0 then
			payday_stamp:set_rotation(1)
		end
	end
	local job_overview_text = self._foreground_layer_one:text({
		name = "job_overview_text",
		text = utf8.to_upper(managers.localization:text("menu_job_overview")),
		h = content_font_size,
		align = "left",
		visible = false,
		vertical = "bpttom",
		font_size = content_font_size,
		font = content_font,
		color = tweak_data.screen_colors.text
	})
	local _, _, w, h = job_overview_text:text_rect()
	job_overview_text:set_size(w, h)
	job_overview_text:set_leftbottom(self._job_schedule_panel:left(), pg_text:bottom())
	job_overview_text:set_y(math.round(job_overview_text:y()))
	self._paygrade_panel:set_center_y(job_overview_text:center_y())
	pg_text:set_center_y(job_overview_text:center_y())
	pg_text:set_y(math.round(pg_text:y()))
	if pg_text:left() <= job_overview_text:right() + 15 then
		pg_text:move(0, -pg_text:h())
		self._paygrade_panel:move(0, -pg_text:h())
	end
	self._background_layer_two:clear()
end
function HUDMissionBriefing:_apply_ghost_color(ghost, i, is_unknown)
	local accumulated_ghost_bonus = managers.job:get_accumulated_ghost_bonus()
	local agb = accumulated_ghost_bonus and accumulated_ghost_bonus[i]
	if is_unknown then
		ghost:set_color(Color(64, 255, 255, 255) / 255)
	elseif i == managers.job:current_stage() then
		if not managers.groupai or not managers.groupai:state():whisper_mode() then
			ghost:set_color(Color(255, 255, 51, 51) / 255)
		else
			ghost:set_color(Color(128, 255, 255, 255) / 255)
		end
	elseif agb and agb.ghost_success then
		ghost:set_color(tweak_data.screen_colors.ghost_color)
	elseif i < managers.job:current_stage() then
		ghost:set_color(Color(255, 255, 51, 51) / 255)
	else
		ghost:set_color(Color(128, 255, 255, 255) / 255)
	end
end
function HUDMissionBriefing:on_whisper_mode_changed()
	if alive(self._job_schedule_panel) then
		local i = managers.job:current_stage() or 1
		local ghost_icon = self._job_schedule_panel:child("ghost_" .. tostring(i))
		if alive(ghost_icon) then
			self:_apply_ghost_color(ghost_icon, i)
		end
	end
end
function HUDMissionBriefing:hide()
	self._backdrop:hide()
	if alive(self._background_layer_two) then
		self._background_layer_two:clear()
	end
end
function HUDMissionBriefing:set_player_slot(nr, params)
	print("set_player_slot( nr, params )", nr, params)
	local slot = self._ready_slot_panel:child("slot_" .. tostring(nr))
	if not slot or not alive(slot) then
		return
	end
	local pad = 3 * tweak_data.scale.lobby_info_offset_multiplier
	slot:child("status"):stop()
	slot:child("status"):set_alpha(1)
	slot:child("status"):set_color(slot:child("status"):color():with_alpha(1))
	slot:child("name"):set_color(slot:child("name"):color():with_alpha(1))
	slot:child("name"):set_text(params.name)
	slot:child("criminal"):set_color(slot:child("criminal"):color():with_alpha(1))
	local rect = PDTH_Menu["lobby_icon_"..params.character] or PDTH_Menu.lobby_icon_unknown
	slot:child("mugshot"):set_texture_rect(rect[1], rect[2], rect[3], rect[4])
	slot:child("mugshot"):set_visible(true)
	log(params.character)
	slot:child("criminal"):set_text(managers.localization:to_upper_text("menu_" .. tostring(params.character)))
	local name_len = utf8.len(slot:child("name"):text())
	local experience = (params.rank > 0 and managers.experience:rank_string(params.rank) .. "-" or "") .. tostring(params.level)
	slot:child("level"):set_text(managers.localization:text("menu_lobby_level").."("..experience..")")
	slot:child("level"):set_visible(true)

	slot:child("name"):set_text(slot:child("name"):text())
	slot:child("infamy"):set_visible(false)
	if params.status then
		slot:child("status"):set_text(params.status)
	end
end
function HUDMissionBriefing:set_slot_joining(peer, peer_id)
	print("set_slot_joining( peer, peer_id )", peer, peer_id)
	local slot = self._ready_slot_panel:child("slot_" .. tostring(peer_id))
	if not slot or not alive(slot) then
		return
	end
	slot:child("voice"):set_visible(false)
	slot:child("infamy"):set_visible(false)
	slot:child("status"):stop()
	slot:child("status"):set_alpha(1)
	slot:child("status"):set_color(slot:child("status"):color():with_alpha(1))
	slot:child("mugshot"):set_visible(true)

	slot:child("level"):set_visible(true)
	slot:child("criminal"):set_color(slot:child("criminal"):color():with_alpha(1))
	slot:child("criminal"):set_text(managers.localization:to_upper_text("menu_" .. tostring(peer:character())))
	slot:child("name"):set_text(peer:name() .. "  ")
	slot:child("status"):set_visible(true)
	slot:child("status"):set_text(managers.localization:text("menu_waiting_is_joining"))
	local animate_joining = function(o)
		local t = 0
		while true do
			t = (t + coroutine.yield()) % 1
			o:set_alpha(0.3 + 0.7 * math.sin(t * 180))
		end
	end
	slot:child("status"):animate(animate_joining)
end
function HUDMissionBriefing:set_slot_ready(peer, peer_id)
	print("set_slot_ready( peer, peer_id )", peer, peer_id)
	local slot = self._ready_slot_panel:child("slot_" .. tostring(peer_id))
	if not slot or not alive(slot) then
		return
	end
	slot:child("status"):stop()
	slot:child("status"):set_visible(true)
	slot:child("status"):set_alpha(1)
	slot:child("status"):set_color(slot:child("status"):color():with_alpha(1))
	slot:child("status"):set_text(managers.localization:text("menu_waiting_is_ready"))
	managers.menu_component:flash_ready_mission_briefing_gui()
end
function HUDMissionBriefing:set_slot_not_ready(peer, peer_id)
	print("set_slot_not_ready( peer, peer_id )", peer, peer_id)
	local slot = self._ready_slot_panel:child("slot_" .. tostring(peer_id))
	if not slot or not alive(slot) then
		return
	end
	slot:child("status"):stop()
	slot:child("status"):set_visible(true)
	slot:child("status"):set_alpha(1)
	slot:child("status"):set_color(slot:child("status"):color():with_alpha(1))
	slot:child("status"):set_text(managers.localization:text("menu_waiting_is_not_ready"))
end
function HUDMissionBriefing:set_dropin_progress(peer_id, progress_percentage, mode)
	local slot = self._ready_slot_panel:child("slot_" .. tostring(peer_id))
	if not slot or not alive(slot) then
		return
	end
	slot:child("status"):stop()
	slot:child("status"):set_visible(true)
	slot:child("status"):set_alpha(1)
	local status_text = mode == "join" and "menu_waiting_is_joining" or "debug_loading_level"
	slot:child("status"):set_text(utf8.to_upper(managers.localization:text(status_text) .. " " .. tostring(progress_percentage) .. "%"))
end
function HUDMissionBriefing:set_kit_selection(peer_id, category, id, slot)
	print("set_kit_selection( peer_id, category, id, slot )", peer_id, category, id, slot)
end
function HUDMissionBriefing:set_slot_outfit(peer_id, criminal_name, outfit)
	print("set_slot_outfit( peer_id, criminal_name, outfit )", peer_id, criminal_name, inspect(outfit))
	local slot = self._ready_slot_panel:child("slot_" .. tostring(peer_id))
	if not slot or not alive(slot) then
		return
	end
	if managers.network:session() and not managers.network:session():peer(peer_id) then
		return
	end
	local detection, reached = managers.blackmarket:get_suspicion_offset_of_outfit_string(outfit, tweak_data.player.SUSPICION_OFFSET_LERP or 0.75)
	local detection_panel = slot:child("detection")
	detection_panel:child("detection_left"):set_color(Color(0.5 + detection * 0.5, 1, 1))
	detection_panel:child("detection_right"):set_color(Color(0.5 + detection * 0.5, 1, 1))
	detection_panel:set_visible(true)
	slot:child("detection_value"):set_visible(detection_panel:visible())
	slot:child("detection_value"):set_text(math.round(detection * 100))
	if reached then
		slot:child("detection_value"):set_color(Color(255, 255, 42, 0) / 255)
	else
		slot:child("detection_value"):set_color(tweak_data.screen_colors.text)
	end
end
function HUDMissionBriefing:set_slot_voice(peer, peer_id, active)
	print("set_slot_voice( peer, peer_id, active )", peer, peer_id, active)
	local slot = self._ready_slot_panel:child("slot_" .. tostring(peer_id))
	if not slot or not alive(slot) then
		return
	end
	slot:child("voice"):set_visible(active)
end
function HUDMissionBriefing:remove_player_slot_by_peer_id(peer, reason)
	print("remove_player_slot_by_peer_id( peer, reason )", peer, reason)
	local slot = self._ready_slot_panel:child("slot_" .. tostring(peer:id()))
	if not slot or not alive(slot) then
		return
	end
	slot:child("status"):stop()
	slot:child("status"):set_alpha(1)
	slot:child("criminal"):set_text("")
	slot:child("name"):set_text(utf8.to_upper(managers.localization:text("menu_lobby_player_slot_available")))
	slot:child("status"):set_text("")
	slot:child("status"):set_visible(false)
	slot:child("mugshot"):set_visible(false)
	slot:child("voice"):set_visible(false)
	slot:child("name"):set_x(slot:child("infamy"):x())
	slot:child("infamy"):set_visible(false)
	slot:child("detection"):set_visible(false)
	slot:child("detection_value"):set_visible(slot:child("detection"):visible())
end
function HUDMissionBriefing:update_layout()
	self._backdrop:_set_black_borders()
end
function HUDMissionBriefing:reload()
	self._backdrop:close()
	self._backdrop = nil
	HUDMissionBriefing.init(self, self._hud, self._workspace)
end
