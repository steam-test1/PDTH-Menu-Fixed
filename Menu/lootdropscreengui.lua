function LootDropScreenGui:init(saferect_ws, fullrect_ws, lootscreen_hud, saved_state)
	self._safe_workspace = saferect_ws
	self._full_workspace = fullrect_ws
	self._lootscreen_hud = lootscreen_hud

	self._lootscreen_hud:add_callback("on_peer_ready", callback(self, self, "check_all_ready"))

	self._fullscreen_panel = self._full_workspace:panel():panel()
	self._panel = self._safe_workspace:panel():panel()
	self._no_loot_for_me = not managers.job:is_job_finished()

	if not self._lootscreen_hud:is_active() then
		self._panel:hide()
		self._fullscreen_panel:hide()
	end

	local is_mass_drop = managers.skirmish:is_skirmish()

	if not is_mass_drop then
		local mutator_class = managers.mutators:get_mass_drop_mutator()

		if mutator_class then
			if mutator_class then
				is_mass_drop = true
			else
				is_mass_drop = false
			end
		end
	end

	local waiting_text_string = utf8.to_upper(managers.localization:text(is_skirmish and "menu_l_waiting_for_cards" or "menu_l_waiting_for_all"))
	self._continue_button = self._panel:text({
		name = "ready_button",
		text = waiting_text_string,
		h = 32,
		align = "right",
		vertical = "center",
		font_size = tweak_data.menu.pd2_medium_font_size,
		font = tweak_data.menu.pd2_medium_font,
		color = PDTHMenu_color_normal,
		layer = 2
	})
	local _, _, w, h = self._continue_button:text_rect()
	self._continue_button:set_size(w, h)
	self._continue_button:set_bottom(self._panel:h())
	self._continue_button:set_right(self._panel:w())
	self._button_not_clickable = true
	self._continue_button:set_color(tweak_data.screen_colors.item_stage_1)
	local big_text = self._fullscreen_panel:text({
		name = "continue_big_text",
		text = waiting_text_string,
		h = 90,
		align = "right",
		vertical = "bottom",
		font_size = tweak_data.menu.pd2_medium_font_size,
		font = tweak_data.menu.pd2_medium_font,
		color = PDTHMenu_color_normal,
		alpha = 0,
		layer = 1
	})
	local x, y = managers.gui_data:safe_to_full_16_9(self._continue_button:world_right(), self._continue_button:world_center_y())
	big_text:set_world_right(x)
	big_text:set_world_center_y(y)
	big_text:move(13, -9)
	if MenuBackdropGUI then
		MenuBackdropGUI.animate_bg_text(self, big_text)
	end
	self._time_left_text = self._panel:text({
		name = "time_left",
		text = "30",
		align = "right",
		vertical = "bottom",
		font_size = tweak_data.menu.pd2_small_font_size,
		font = tweak_data.menu.pd2_small_font,
		color = tweak_data.screen_colors.text,
		layer = 1
	})
	self._time_left_text:set_right(self._continue_button:right())
	self._time_left_text:set_bottom(self._continue_button:top())
	self._time_left_text:set_alpha(0)
	self._fade_time_left = 10
	self._time_left = 30
	self._is_alone = false
	self._selected = 0
	self._id = managers.network:session() and managers.network:session():local_peer():id() or 1
	self._card_chosen = false
	if saved_state then
		self:set_state(saved_state)
	end
	if self._no_loot_for_me then
		return
	end

	if is_mass_drop then
		self._card_chosen = true

		return
	end

	self:_set_selected_and_sync(2)
end

function LootDropScreenGui:hide()
	self._enabled = false
	self._panel:set_alpha(0.5)
	self._fullscreen_panel:set_alpha(0.5)
end
function LootDropScreenGui:show()
	self._enabled = true
	self._panel:set_alpha(1)
	self._fullscreen_panel:set_alpha(1)
end
function LootDropScreenGui:check_all_ready()
	if not alive(self._panel) or not alive(self._fullscreen_panel) then
		Application:error("[LootDropScreenGui:check_all_ready] GUI panel is dead!", self._panel, self._fullscreen_panel)
		return
	end
	if self._lootscreen_hud:check_all_ready() then
		local text_id = "victory_client_waiting_for_server"

		if Global.game_settings.single_player or self._is_alone or not managers.network:session() then
			self._button_not_clickable = false
			text_id = "failed_disconnected_continue"

			if managers.menu:is_pc_controller() then
				self._continue_button:set_color(PDTHMenu_color_normal)
			end
		elseif Network:is_server() then
			self._button_not_clickable = false
			text_id = "debug_mission_end_continue"

			if managers.menu:is_pc_controller() then
				self._continue_button:set_color(PDTHMenu_color_normal)
			end
		end
		local continue_button = managers.menu:is_pc_controller() and "[ENTER]" or nil
		local text = managers.localization:to_upper_text(text_id, {CONTINUE = continue_button})
		self._continue_button:set_text(text)
		local _, _, w, h = self._continue_button:text_rect()
		self._continue_button:set_size(w, h)
		self._continue_button:set_bottom(self._panel:h())
		self._continue_button:set_right(self._panel:w())
		local big_text = self._fullscreen_panel:child("continue_big_text")
		big_text:set_text(text)
		local x, y = managers.gui_data:safe_to_full_16_9(self._continue_button:world_right(), self._continue_button:world_center_y())
		big_text:set_world_right(x)
		big_text:set_world_center_y(y)
		big_text:move(13, -9)
		managers.menu_component:post_event("prompt_enter")
	end
end
function LootDropScreenGui:on_peer_removed(peer, reason)
	if peer then
		self._lootscreen_hud:remove_peer(peer:id(), reason)
	end
	self:check_all_ready()
end
function LootDropScreenGui:mouse_pressed(button, x, y)
	if self._no_loot_for_me then
		return
	end
	if not alive(self._panel) or not alive(self._fullscreen_panel) or not self._enabled then
		return
	end
	if button ~= Idstring("0") then
		return
	end
	if self._card_chosen and not self._button_not_clickable and self._continue_button:inside(x, y) then
		self:continue_to_lobby()
		return true
	end
	if self._card_chosen then
		return
	end
	local inside = self._lootscreen_hud:check_inside_local_peer(x, y)
	if inside == self._selected then
		self._card_chosen = true
		managers.menu_component:post_event("menu_enter")
		self:choose_card(self._id, self._selected)
		if not Global.game_settings.single_player and managers.network:session() then
			managers.network:session():send_to_peers("choose_lootcard", self._selected)
		end
	end
end
function LootDropScreenGui:mouse_moved(x, y)
	if self._no_loot_for_me then
		return false
	end
	if not alive(self._panel) or not alive(self._fullscreen_panel) or not self._enabled then
		return false
	end
	if self._button_not_clickable then
		self._continue_button:set_color(tweak_data.screen_colors.item_stage_1)
	elseif self._continue_button:inside(x, y) then
		if not self._continue_button_highlighted then
			self._continue_button_highlighted = true
			self._continue_button:set_color(PDTHMenu_color_marker)
			managers.menu_component:post_event("highlight")
		end
		return true, "link"
	elseif self._continue_button_highlighted then
		self._continue_button_highlighted = false
		self._continue_button:set_color(PDTHMenu_color_normal)
	end
	if self._card_chosen then
		return false
	end
	if self._lootscreen_hud then
		local inside = self._lootscreen_hud:check_inside_local_peer(x, y)
		if inside then
			self:_set_selected_and_sync(inside)
		end
		return inside, "link"
	end
end
function LootDropScreenGui:scroll_up()
	if self._no_loot_for_me then
		return
	end
	if self._card_chosen then
		return
	end
	if not alive(self._panel) or not alive(self._fullscreen_panel) or not self._enabled then
		return
	end
	self:_set_selected_and_sync(self._selected - 1)
end
function LootDropScreenGui:scroll_down()
	if self._no_loot_for_me then
		return
	end
	if self._card_chosen then
		return
	end
	if not alive(self._panel) or not alive(self._fullscreen_panel) or not self._enabled then
		return
	end
	self:_set_selected_and_sync(self._selected + 1)
end