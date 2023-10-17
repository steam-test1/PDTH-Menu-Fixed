require("lib/managers/menu/WalletGuiObject")
require("lib/managers/social_hub/LobbyCodeMenuComponent")
local make_fine_text = function(text)
	local x, y, w, h = text:text_rect()
	text:set_size(w, h)
	text:set_position(math.round(text:x()), math.round(text:y()))
end
function MissionBriefingTabItem:init(panel, text, i)
	panel:set_top(panel:parent():top() + 50)
	self._main_panel = panel
	self._panel = self._main_panel:panel({})
	self._index = i
	local prev_item_title_text = self._main_panel:child("tab_text_" .. tostring(i - 1))
	local offset = prev_item_title_text and prev_item_title_text:right() + 5 or 0
	self._tab_string = text
	self._tab_string_prefix = ""
	self._tab_string_suffix = ""
	local tab_string = self._tab_string_prefix .. self._tab_string .. self._tab_string_suffix
	self._tab_text = self._main_panel:text({
		name = "tab_text_" .. tostring(self._index),
		text = tab_string,
		h = 32,
		x = offset,
		align = "center",
		vertical = "center",
		font_size = tweak_data.menu.pd2_medium_font_size - 2,
		font = tweak_data.menu.pd2_medium_font,
		layer = 1
	})
	local _, _, tw, th = self._tab_text:text_rect()
	self._tab_text:set_size(tw + 15, th + 10)
	self._tab_select_rect = self._main_panel:bitmap({
		name = "tab_select_rect_" .. tostring(self._index),
		texture = "guis/textures/pd2/shared_tab_box",
		layer = 0,
		color = tweak_data.screen_colors.text,
		visible = false
	})
	self._tab_select_rect:set_shape(self._tab_text:shape())
	self._panel:set_top(self._tab_text:bottom() - 3)
	self._panel:grow(-30, -(self._panel:top() + 120 + tweak_data.menu.pd2_small_font_size * 4 + 25))
	self._selected = true
	self:deselect()
end

function MissionBriefingTabItem:reduce_to_small_font(iteration)
	iteration = iteration or 0
	local font_size = tweak_data.menu.pd2_small_font_size - iteration

	self._tab_text:set_font(tweak_data.menu.pd2_small_font_id)
	self._tab_text:set_font_size(font_size)

	local prev_item_title_text = self._main_panel:child("tab_text_" .. tostring(self._index - 1))
	local offset = prev_item_title_text and prev_item_title_text:right() or 0
	local x, y, w, h = self._tab_text:text_rect()

	self._tab_text:set_size(w + 15, h + 10)
	self._tab_text:set_x(offset + 5)
	self._tab_select_rect:set_shape(self._tab_text:shape())
	self._panel:set_top(self._tab_text:bottom() - 3)
	self._panel:set_h(self._main_panel:h())
	self._panel:grow(0, -(self._panel:top() + 70 + tweak_data.menu.pd2_small_font_size * 4 + 25))
end

function MissionBriefingTabItem:update_tab_position()
	local prev_item_title_text = self._main_panel:child("tab_text_" .. tostring(self._index - 1))
	local offset = prev_item_title_text and prev_item_title_text:right() or 0
	self._tab_text:set_x(offset + 5)
	self._tab_select_rect:set_shape(self._tab_text:shape())
end

function MissionBriefingTabItem:_set_tab_text()
	local tab_string = self._tab_string_prefix .. self._tab_string .. self._tab_string_suffix
	self._tab_text:set_text(tab_string)
	local _, _, tw, th = self._tab_text:text_rect()
	self._tab_text:set_size(tw + 15, th + 10)
	self._tab_select_rect:set_shape(self._tab_text:shape())
	managers.menu_component:update_mission_briefing_tab_positions()
end

function MissionBriefingTabItem:select(no_sound)
	if self._selected then
		return
	end
	self:show()
	if self._tab_text and alive(self._tab_text) then
		self._tab_text:set_color(PDTHMenu_color_marker)
	end
	self._selected = true
	if no_sound then
		return
	end
	managers.menu_component:post_event("menu_enter")
end
function MissionBriefingTabItem:deselect()
	if not self._selected then
		return
	end
	self:hide()
	if self._tab_text and alive(self._tab_text) then
		self._tab_text:set_color(Color.white)
	end
	self._selected = false
end
function MissionBriefingTabItem:mouse_moved(x, y)
	if not self._selected then
		if self._tab_text:inside(x, y) then
			if not self._highlighted then
				self._highlighted = true
				self._tab_text:set_color(PDTHMenu_color_marker)
				managers.menu_component:post_event("highlight")
			end
		elseif self._highlighted then
			self._tab_text:set_color(Color.white)
			self._highlighted = false
		end
	end
	return self._selected, self._highlighted
end

function MissionBriefingTabItem.animate_select(o, center_helper, instant)
	o:set_layer(2)
	local size = o:h()
	if size == 85 then
		return
	end
	managers.menu_component:post_event("highlight")
	local center_x, center_y = o:center()
	if alive(center_helper) then
		local center_x, center_y = center_helper:center()
	end
	local aspect = o:texture_width() / math.max(1, o:texture_height())
	if instant then
		local s = math.lerp(size, 85, 1)
		o:set_size(s * aspect, s)
		o:set_center(center_x, center_y)
		return
	end
	over(math.abs(85 - size) / 100, function(p)
		local s = math.lerp(size, 85, p)
		if alive(center_helper) then
			center_x, center_y = center_helper:center()
		end
		o:set_size(s * aspect, s)
		o:set_center(center_x, center_y)
	end)
end
function MissionBriefingTabItem.animate_deselect(o, center_helper)
	o:set_layer(1)
	local size = o:h()
	if size == 65 then
		return
	end
	local center_x, center_y = o:center()
	if alive(center_helper) then
		local center_x, center_y = center_helper:center()
	end
	local aspect = o:texture_width() / math.max(1, o:texture_height())
	over(math.abs(65 - size) / 100, function(p)
		local s = math.lerp(size, 65, p)
		if alive(center_helper) then
			center_x, center_y = center_helper:center()
		end
		o:set_size(s * aspect, s)
		o:set_center(center_x, center_y)
	end)
end

function DescriptionItem:init(panel, text, i, saved_descriptions)
	DescriptionItem.super.init(self, panel, text, i)

	if not managers.job:has_active_job() then
		return
	end

	local stage_data = managers.job:current_stage_data()
	local level_data = managers.job:current_level_data()
	local name_id = stage_data.name_id or level_data.name_id
	local briefing_id = managers.job:current_briefing_id()

	if managers.skirmish:is_skirmish() and not managers.skirmish:is_weekly_skirmish() then
		briefing_id = "heist_skm_random_briefing"
	end

	local title_text = self._panel:text({
		name = "title_text",
		text = managers.localization:to_upper_text(name_id),
		font_size = tweak_data.menu.pd2_medium_font_size,
		font = tweak_data.menu.pd2_medium_font,
		y = 10,
		x = 10,
		color = tweak_data.screen_colors.text
	})
	local x, y, w, h = title_text:text_rect()
	title_text:set_size(w, h)
	title_text:set_position(math.round(title_text:x()), math.round(title_text:y()))
	local pro_text
	if managers.job:is_current_job_professional() then
		pro_text = self._panel:text({
			name = "pro_text",
			text = managers.localization:to_upper_text("cn_menu_pro_job"),
			font_size = tweak_data.menu.pd2_medium_font_size,
			font = tweak_data.menu.pd2_medium_font,
			color = tweak_data.screen_colors.pro_color,
			blend_mode = "add"
		})
		local x, y, w, h = pro_text:text_rect()
		pro_text:set_size(w, h)
		pro_text:set_position(title_text:right() + 10, title_text:y())
	end
	self._scroll_panel = self._panel:panel({
		x = 10,
		y = title_text:bottom()
	})
	self._scroll_panel:grow(-self._scroll_panel:x() - 10, -self._scroll_panel:y())
	local desc_string = managers.localization:text(briefing_id)
	local is_level_ghostable = managers.job:is_level_ghostable(managers.job:current_level_id()) and managers.groupai and managers.groupai:state():whisper_mode()
	if is_level_ghostable and Network:is_server() then
		desc_string = desc_string .. [[


]] .. managers.localization:text("menu_ghostable_stage")
	end
	local desc_text = self._scroll_panel:text({
		name = "description_text",
		text = desc_string,
		font_size = tweak_data.menu.pd2_small_font_size,
		font = tweak_data.menu.pd2_small_font,
		wrap = true,
		word_wrap = true,
		color = tweak_data.screen_colors.text
	})
	if saved_descriptions then
		local text = ""
		for i, text_id in ipairs(saved_descriptions) do
			text = text .. managers.localization:text(text_id) .. "\n"
		end
		desc_text:set_text(text)
	end
	self:_chk_add_scrolling()
end
function DescriptionItem:reduce_to_small_font()
	DescriptionItem.super.reduce_to_small_font(self)
	if not alive(self._scroll_panel) then
		return
	end
	local desc_text = self._scroll_panel:child("description_text")
	local title_text = self._panel:child("title_text")
	self._scroll_panel:set_h(self._panel:h())
	self._scroll_panel:set_y(title_text:bottom())
	self._scroll_panel:grow(0, -self._scroll_panel:y())
	local show_scroll_line_top = 0 > desc_text:top()
	local show_scroll_line_bottom = desc_text:bottom() > self._scroll_panel:h()
	if self._scroll_box then
		self._scroll_box:create_sides(self._scroll_panel, {
			sides = {
				0,
				0,
				0,
				0
			}
		})
	end
end
function DescriptionItem:_chk_add_scrolling()
	local desc_text = self._scroll_panel:child("description_text")
	local _, _, _, h = desc_text:text_rect()
	desc_text:set_h(h)
	if desc_text:h() > self._scroll_panel:h() and not self._scrolling then
		self._scrolling = true
		self._show_scroll_line_top = false
		self._show_scroll_line_bottom = false
		local show_scroll_line_top = 0 > desc_text:top()
		local show_scroll_line_bottom = desc_text:bottom() > self._scroll_panel:h()
		if show_scroll_line_top ~= self._show_scroll_line_top or show_scroll_line_bottom ~= self._show_scroll_line_bottom then
			self._show_scroll_line_top = show_scroll_line_top
			self._show_scroll_line_bottom = show_scroll_line_bottom
		end
		if not managers.menu:is_pc_controller() then
			local legends = {
				"menu_legend_preview_move"
			}
			local t_text = ""
			for i, string_id in ipairs(legends) do
				local spacing = i > 1 and "  |  " or ""
				t_text = t_text .. spacing .. utf8.to_upper(managers.localization:text(string_id, {
					BTN_UPDATE = managers.localization:btn_macro("menu_update"),
					BTN_BACK = managers.localization:btn_macro("back")
				}))
			end
			local legend_text = self._panel:text({
				font = tweak_data.menu.pd2_small_font,
				font_size = tweak_data.menu.pd2_small_font_size,
				text = t_text,
				halign = "right",
				valign = "top"
			})
			local _, _, lw, lh = legend_text:text_rect()
			legend_text:set_size(lw, lh)
			legend_text:set_righttop(self._panel:w() - 5, 5)
		end
	elseif self._scrolling then
	end
end
function DescriptionItem:on_whisper_mode_changed()
	local briefing_id = managers.job:current_briefing_id()
	if briefing_id then
		local desc_string = managers.localization:text(briefing_id)
		local is_level_ghostable = managers.job:is_level_ghostable(managers.job:current_level_id()) and managers.groupai and managers.groupai:state():whisper_mode()
		if is_level_ghostable then
			desc_string = desc_string .. [[


]] .. managers.localization:text("menu_ghostable_stage")
		end
		self:set_description_text(desc_string)
	end
end
function DescriptionItem:set_title_text(text)
	self._panel:child("title_text"):set_text(text)
end
function DescriptionItem:add_description_text(text)
	self._scroll_panel:child("description_text"):set_text(self._scroll_panel:child("description_text"):text() .. "\n" .. text)
	self:_chk_add_scrolling()
end
function DescriptionItem:set_description_text(text)
	self._scroll_panel:child("description_text"):set_text(text)
	self:_chk_add_scrolling()
end
function DescriptionItem:move_up()
	if not managers.job:has_active_job() or not self._scrolling then
		return
	end
	local desc_text = self._scroll_panel:child("description_text")
	if desc_text:top() < 0 then
		self._scroll_speed = 2
	end
end
function DescriptionItem:move_down()
	if not managers.job:has_active_job() or not self._scrolling then
		return
	end
	local desc_text = self._scroll_panel:child("description_text")
	if desc_text:bottom() > self._scroll_panel:h() then
		self._scroll_speed = -2
	end
end
function DescriptionItem:update(t, dt)
	if not managers.job:has_active_job() or not self._scrolling then
		return
	end
	local desc_text = self._scroll_panel:child("description_text")
	if desc_text:h() > self._scroll_panel:h() and self._scroll_speed then
		self._scroll_speed = math.step(self._scroll_speed, 0, dt * 4)
		desc_text:move(0, math.clamp(self._scroll_speed, -1, 1) * 100 * dt)
		if 0 < desc_text:top() then
			desc_text:set_top(0)
			self._scroll_speed = nil
		elseif desc_text:bottom() < self._scroll_panel:h() then
			desc_text:set_bottom(self._scroll_panel:h())
			self._scroll_speed = nil
		end
		if self._scroll_speed == 0 then
			self._scroll_speed = nil
		end
		local show_scroll_line_top = 0 > desc_text:top()
		local show_scroll_line_bottom = desc_text:bottom() > self._scroll_panel:h()
		if show_scroll_line_top ~= self._show_scroll_line_top or show_scroll_line_bottom ~= self._show_scroll_line_bottom then
			if self._scroll_box then
				self._scroll_box:create_sides(self._scroll_panel, {
					sides = {
						0,
						0,
						0,
						0
					}
				})
			end
			self._show_scroll_line_top = show_scroll_line_top
			self._show_scroll_line_bottom = show_scroll_line_bottom
		end
	end
end

function AssetsItem:create_assets(assets_names, max_assets)
	self._panel:clear()
	self._panel:set_h(250)
	self._loading_text = nil
	self._asset_locked = {}
	self._assets_list = {}
	self._assets_names = assets_names
	self._unlock_cost = assets_names[3] or false
	local center_y = math.round(self._panel:h() / 2) - tweak_data.menu.pd2_small_font_size
	self._asset_text_panel = self._panel:panel({name = "asset_text", layer = 4})
	local first_rect, rect
	local w = self._panel:w() / (self._num_items / 2)
	local step = w * 0.5
	for i = 1, #assets_names do
		local center_x = i * w - w * 0.5
		rect = self._panel:rect({
			name = "bg_rect_" .. tostring(i),
			w = 85,
			h = 85
		})
		rect:hide()
		first_rect = first_rect or rect
		local center_x = math.ceil(i / 2) * w - step
		local center_y = self._panel:h() * (i % 2 > 0 and 0.295 or 0.815)
		local texture = assets_names[i][1]
		local asset
		if texture and DB:has(Idstring("texture"), texture) then
			asset = self._panel:bitmap({
				name = "asset_" .. tostring(i),
				texture = texture,
				w = 65,
				h = 65,
				rotation = math.random(2) - 1.5,
				layer = 1,
				valign = "top"
			})
		else
			asset = self._panel:bitmap({
				name = "asset_" .. tostring(i),
				texture = "guis/textures/pd2/endscreen/what_is_this",
				rotation = math.random(2) - 1.5,
				alpha = 0,
				w = 65,
				h = 65,
				layer = 1,
				valign = "top"
			})
		end
		local aspect = asset:texture_width() / math.max(1, asset:texture_height())
		asset:set_w(asset:h() * aspect)
		rect:set_w(rect:h() * aspect)
		rect:set_center(center_x, center_y)
		rect:set_position(math.round(rect:x()), math.round(rect:y()))
		asset:set_center(rect:center())
		asset:set_position(math.round(asset:x()), math.round(asset:y()))
		asset:set_rotation(0.5)
		if not assets_names[i][3] then
			local lock = self._panel:bitmap({
				name = "asset_lock_" .. tostring(i),
				texture = managers.assets:get_asset_can_unlock_by_id(self._assets_names[i][4]) and "guis/textures/pd2/blackmarket/money_lock" or "guis/textures/pd2/skilltree/padlock",
				color = tweak_data.screen_colors.item_stage_1,
				layer = 3
			})
			lock:set_center(rect:center())
			asset:set_color(Color.black:with_alpha(0.6))
			self._asset_locked[i] = true
		end
		table.insert(self._assets_list, asset)
	end
	self._text_strings_localized = false
	self._my_asset_space = w
	self._my_left_i = self._my_menu_component_data.my_left_i or 1
	if math.ceil(#self._assets_list / self._num_items) > 1 then
		self._move_left_rect = self._panel:bitmap({
			texture = "guis/textures/pd2/hud_arrow",
			color = tweak_data.screen_colors.button_stage_3,
			rotation = 360,
			w = 32,
			h = 32,
			layer = 3
		})
		self._move_left_rect:set_center(0, self._panel:h() / 2)
		self._move_left_rect:set_position(math.round(self._move_left_rect:x()), math.round(self._move_left_rect:y()))
		self._move_left_rect:set_visible(false)
		self._move_right_rect = self._panel:bitmap({
			texture = "guis/textures/pd2/hud_arrow",
			color = tweak_data.screen_colors.button_stage_3,
			rotation = 180,
			w = 32,
			h = 32,
			layer = 3
		})
		self._move_right_rect:set_center(self._panel:w(), self._panel:h() / 2)
		self._move_right_rect:set_position(math.round(self._move_right_rect:x()), math.round(self._move_right_rect:y()))
		self._move_right_rect:set_visible(false)
	end
	if not managers.menu:is_pc_controller() then
		local legends = {
			"menu_legend_preview_move",
			"menu_legend_select"
		}
		if managers.preplanning:has_current_level_preplanning() then
			table.insert(legends, 1, "menu_legend_open_preplanning")
		else
			table.insert(legends, 1, "menu_legend_buy_all_assets")
		end
		local t_text = ""
		for i, string_id in ipairs(legends) do
			local spacing = i > 1 and "  |  " or ""
			t_text = t_text .. spacing .. utf8.to_upper(managers.localization:text(string_id, {
				BTN_UPDATE = managers.localization:btn_macro("menu_update"),
				BTN_BACK = managers.localization:btn_macro("back")
			}))
		end
		local legend_text = self._panel:text({
			rotation = 360,
			font = tweak_data.menu.pd2_small_font,
			font_size = tweak_data.menu.pd2_small_font_size,
			text = t_text
		})
		local _, _, lw, lh = legend_text:text_rect()
		legend_text:set_size(lw, lh)
		legend_text:set_righttop(self._panel:w() - 5, 5)
	end
	local first_rect = self._panel:child("bg_rect_1")
	if first_rect then
		self._select_box_panel = self._panel:panel({layer = -3, visible = false})
		self._select_box_panel:set_shape(first_rect:shape())
		self._select_box = BoxGuiObject:new(self._select_box_panel, {
			sides = {
				0,
				0,
				0,
				0
			}
		})
	end
	self:post_init()

	self._is_buy_all_dialog_open = false

	if not managers.preplanning:has_current_level_preplanning() and managers.menu:is_pc_controller() then
		self.buy_all_button = self._panel:text({
			name = "buy_all_btn",
			align = "right",
			blend_mode = "add",
			visible = true,
			text = managers.localization:to_upper_text("menu_asset_buy_all_button"),
			h = tweak_data.menu.pd2_medium_font_size * 0.95,
			font_size = tweak_data.menu.pd2_medium_font_size * 0.9,
			font = tweak_data.menu.pd2_medium_font,
			color = tweak_data.screen_colors.button_stage_3
		})

		self.buy_all_button:set_top(10)
		self.buy_all_button:set_right(self._panel:w() - 5)
	end
end
function AssetsItem:unlock_asset_by_id(id)
	for i, asset_data in ipairs(self._assets_names) do
		if Idstring(asset_data[4]) == Idstring(id) then
			self._asset_locked[i] = false
			self._assets_list[i]:set_color(Color.white)
			local lock = self._panel:child("asset_lock_" .. tostring(i))
			if lock then
				self._panel:remove(lock)
			end
		end
	end
	self:select_asset(self._asset_selected, true)
end
function AssetsItem:move_assets_left()
	self._my_left_i = math.max(self._my_left_i - 1, 1)
	self:update_asset_positions_and_text()
	managers.menu_component:post_event("menu_enter")
end
function AssetsItem:move_assets_right()
	self._my_left_i = math.min(self._my_left_i + 1, math.ceil(#self._assets_list / self._num_items))
	self:update_asset_positions_and_text()
	managers.menu_component:post_event("menu_enter")
end
function AssetsItem:update_asset_positions_and_text()
	self:update_asset_positions()
	local bg = self._panel:child("bg_rect_" .. tostring(self._asset_selected))
	if alive(bg) then
		self._asset_text_panel:set_center_x(bg:center_x())
		self._asset_text_panel:set_position(math.round(self._asset_text_panel:x()), math.round(self._asset_text_panel:y()))
		for i, asset_text in ipairs(self._asset_text_panel:children()) do
			if asset_text:world_left() < 10 then
				asset_text:set_world_left(10)
				asset_text:set_align("left")
			elseif asset_text:world_right() > self._panel:w() - 10 then
				asset_text:set_world_right(self._panel:w() - 10)
				asset_text:set_align("right")
			else
				asset_text:set_align("center")
			end
		end
	end
end
function AssetsItem:update_asset_positions()
	self._my_menu_component_data.my_left_i = self._my_left_i
	local w = self._my_asset_space
	for i, asset in pairs(self._assets_list) do
		local cx = (math.ceil(i / 2) - (self._my_left_i - 1) * (self._num_items / 2)) * w - w / 2
		local lock = self._panel:child("asset_lock_" .. tostring(i))
		if alive(lock) then
			lock:set_center_x(cx)
		end
		self._panel:child("bg_rect_" .. tostring(i)):set_center_x(cx)
		self._panel:child("bg_rect_" .. tostring(i)):set_left(math.round(self._panel:child("bg_rect_" .. tostring(i)):left()))
		asset:set_center_x(cx)
		asset:set_left(math.round(asset:left()))
	end
	self._move_left_rect:set_visible(self._my_left_i > 1)
	self._move_right_rect:set_visible(self._my_left_i < math.ceil(#self._assets_list / self._num_items))
	if 1 < math.ceil(#self._assets_list / self._num_items) then
		self:set_tab_suffix(" (" .. tostring(self._my_left_i) .. "/" .. tostring(math.ceil(#self._assets_list / self._num_items)) .. ")")
	end
end
function AssetsItem:select_asset(i, instant)
	if #self._assets_list > self._num_items then
		if i then
			local page = math.ceil(i / self._num_items)
			self._my_left_i = page
		end
		self:update_asset_positions()
	end
	if not i then
		return
	end
	local bg = self._panel:child("bg_rect_" .. tostring(i))
	if not self._assets_names[i] then
		return
	end
	local text_string = self._assets_names[i][2]
	local extra_string, extra_color
	if not self._text_strings_localized then
		text_string = managers.localization:text(text_string)
	end
	text_string = text_string .. "\n"
	if self._asset_selected == i and not instant then
		return
	end
	local is_init = self._asset_selected == nil
	self:check_deselect_item()
	self._asset_selected = i
	self._my_menu_component_data.selected = self._asset_selected
	local rect = self._panel:child("bg_rect_" .. tostring(i))
	if rect then
		self._select_box_panel:set_shape(rect:shape())
		self._select_box:create_sides(self._select_box_panel, {
			sides = {
				0,
				0,
				0,
				0
			}
		})
	end
	if self._asset_locked[i] then
		local can_client_unlock = managers.assets.ALLOW_CLIENTS_UNLOCK == true or type(managers.assets.ALLOW_CLIENTS_UNLOCK) == "string" and managers.player:has_team_category_upgrade("player", managers.assets.ALLOW_CLIENTS_UNLOCK)
		local is_server = Network:is_server() or can_client_unlock
		local can_unlock = managers.assets:get_asset_can_unlock_by_id(self._assets_names[i][4])
		if not self._assets_names[i][6] or not text_string then
			text_string = managers.localization:text("bm_menu_mystery_asset")
		end
		if is_server and can_unlock then
			extra_string = managers.localization:text("st_menu_cost") .. " " .. managers.experience:cash_string(managers.money:get_mission_asset_cost_by_id(self._assets_names[i][4]))
			if not managers.money:can_afford_mission_asset(self._assets_names[i][4]) then
				extra_string = extra_string .. "\n" .. managers.localization:text("bm_menu_not_enough_cash")
				extra_color = tweak_data.screen_colors.important_1
			end
		else
			if is_server or not "menu_briefing_asset_server_locked" then
			end
			extra_string = managers.localization:text((managers.assets:get_asset_unlock_text_by_id(self._assets_names[i][4])))
		end
		extra_color = extra_color or can_unlock and tweak_data.screen_colors.text or tweak_data.screen_colors.important_1
	end
	extra_color = extra_color or tweak_data.screen_colors.text
	self._asset_text_panel:clear()
	if text_string then
		local text = self._asset_text_panel:text({
			name = "text_string",
			text = text_string,
			align = "center",
			font_size = tweak_data.menu.pd2_small_font_size,
			font = tweak_data.menu.pd2_small_font,
			color = tweak_data.screen_colors.text
		})
		make_fine_text(text)
		text:set_top(0)
		text:set_center_x(self._asset_text_panel:w() / 2)
	end
	if extra_string then
		local last_child = self._asset_text_panel:children()[self._asset_text_panel:num_children()]
		local text = self._asset_text_panel:text({
			name = "extra_string",
			text = extra_string,
			align = "center",
			font_size = tweak_data.menu.pd2_small_font_size,
			font = tweak_data.menu.pd2_small_font,
			color = extra_color
		})
		make_fine_text(text)
		if last_child then
			text:set_top(last_child:bottom())
		end
		text:set_center_x(self._asset_text_panel:w() / 2)
	end
	self._assets_list[i]:stop()
	self._assets_list[i]:animate(self.animate_select, self._panel:child("bg_rect_" .. tostring(i)), instant)
	if alive(bg) then
		self._asset_text_panel:set_h(self._asset_text_panel:children()[self._asset_text_panel:num_children()]:bottom())
		self._asset_text_panel:set_center_x(bg:center_x())
		self._asset_text_panel:set_position(math.round(self._asset_text_panel:x()), math.round(self._asset_text_panel:y()))
		local a_left = self._asset_text_panel:left()
		local a_right = self._asset_text_panel:right()
		for i, asset_text in ipairs(self._asset_text_panel:children()) do
			asset_text:set_position(math.round(asset_text:x()), math.round(asset_text:y()))
			if a_left + asset_text:left() < 12 then
				asset_text:set_left(12 - a_left)
			elseif a_left + asset_text:right() > self._panel:w() - 12 then
				asset_text:set_right(self._panel:w() - 12 - a_left)
			end
		end
	end
	if rect then
		if i % 2 > 0 then
			self._asset_text_panel:set_top(rect:bottom())
		else
			self._asset_text_panel:set_bottom(rect:top())
		end
	end
end
function AssetsItem:check_deselect_item()
	if self._asset_selected and self._assets_list[self._asset_selected] then
		self._assets_list[self._asset_selected]:stop()
		self._assets_list[self._asset_selected]:animate(self.animate_deselect, self._panel:child("bg_rect_" .. tostring(self._asset_selected)))
		self._asset_text_panel:clear()
	end
	self._asset_selected = nil
end
function AssetsItem:mouse_moved(x, y)
	if alive(self._move_left_rect) and alive(self._move_right_rect) then
		if self._move_left_rect:visible() and self._move_left_rect:inside(x, y) then
			if not self._move_left_highlighted then
				self._move_left_highlighted = true
				self._move_left_rect:set_color(tweak_data.screen_colors.button_stage_2)
				managers.menu_component:post_event("highlight")
				self:check_deselect_item()
			end
			self._asset_text_panel:clear()
			return false, true
		elseif self._move_left_highlighted then
			self._move_left_rect:set_color(tweak_data.screen_colors.button_stage_3)
			self._move_left_highlighted = false
		end
		if self._move_right_rect:visible() and self._move_right_rect:inside(x, y) then
			if not self._move_right_highlighted then
				self._move_right_highlighted = true
				self._move_right_rect:set_color(tweak_data.screen_colors.button_stage_2)
				managers.menu_component:post_event("highlight")
				self:check_deselect_item()
			end
			self._asset_text_panel:clear()
			return false, true
		elseif self._move_right_highlighted then
			self._move_right_rect:set_color(tweak_data.screen_colors.button_stage_3)
			self._move_right_highlighted = false
		end
	end
	local preplanning = self._preplanning_ready and self._panel:child("preplanning")
	if alive(preplanning) and preplanning:tree_visible() then
		if preplanning:inside(x, y) then
			if not self._preplanning_highlight then
				self._preplanning_highlight = true
				preplanning:child("button"):set_alpha(1)
				managers.menu_component:post_event("highlight")
			end
			self:check_deselect_item()
			return false, true
		elseif self._preplanning_highlight then
			self._preplanning_highlight = false
			preplanning:child("button"):set_alpha(0.8)
		end
	end
	if alive(self.buy_all_button) and self.buy_all_button:inside(x, y) then
		if not self.buy_all_button_highlighted then
			self.buy_all_button_highlighted = true

			self.buy_all_button:set_color(tweak_data.screen_colors.button_stage_2)
			managers.menu_component:post_event("highlight")
			self:check_deselect_item()
		end
	elseif self.buy_all_button_highlighted then
		self.buy_all_button_highlighted = false

		self.buy_all_button:set_color(tweak_data.screen_colors.button_stage_3)
	end
	local selected, highlighted = AssetsItem.super.mouse_moved(self, x, y)
	if not self._panel:inside(x, y) or not selected then
		self:check_deselect_item()
		return selected, highlighted
	end
	self._assets_list = self._assets_list or {}
	local update_select = false
	if not self._asset_selected then
		update_select = true
	elseif self._assets_list[self._asset_selected] and not self._panel:child("bg_rect_" .. tostring(self._asset_selected)):inside(x, y) and self._assets_list[self._asset_selected]:visible() then
		update_select = true
	end
	if update_select then
		for i, asset in ipairs(self._assets_list) do
			if self._panel:child("bg_rect_" .. tostring(i)):inside(x, y) and asset:visible() then
				update_select = false
				self:select_asset(i)
			else
			end
		end
	end
	if not update_select then
		return false, true
	end
	return selected, highlighted
end
function AssetsItem:mouse_pressed(button, x, y)
	local inside = AssetsItem.super.mouse_pressed(self, button, x, y)
	if inside == false then
		return false
	end
	if alive(self._move_left_rect) and alive(self._move_right_rect) then
		if self._move_left_rect:visible() and self._move_left_rect:inside(x, y) then
			self:move_assets_left()
			return
		end
		if self._move_right_rect:visible() and self._move_right_rect:inside(x, y) then
			self:move_assets_right()
			return
		end
	end
	local preplanning = self._preplanning_ready and self._panel:child("preplanning")
	if alive(preplanning) and preplanning:inside(x, y) then
		self:open_preplanning()
		return
	end
	if alive(self.buy_all_button) and self.buy_all_button:inside(x, y) then
		self:open_assets_buy_all()

		return
	end
	if self._asset_selected and alive(self._panel:child("bg_rect_" .. tostring(self._asset_selected))) and self._panel:child("bg_rect_" .. tostring(self._asset_selected)):inside(x, y) then
		return self:_return_asset_info(self._asset_selected)
	end
	return inside
end
-- function AssetsItem:open_preplanning()
-- 	if self._preplanning_ready then
-- 		managers.menu_component:post_event("menu_enter")
-- 		managers.menu:open_node("preplanning")
-- 		managers.menu_component:on_ready_pressed_mission_briefing_gui(false)
-- 	end
-- end
-- function AssetsItem:move(x, y)
-- 	if #self._assets_list == 0 then
-- 		return
-- 	end
-- 	local asset_selected = self._asset_selected
-- 	local new_selected = self._my_left_i and (self._my_left_i - 1) * self._num_items + 1 or 1
-- 	if asset_selected then
-- 		local is_top = 0 < asset_selected % 2
-- 		if not is_top or not math.max(y, 0) then
-- 		end
-- 		local step = 2 * x + math.min(y, 0)
-- 		new_selected = asset_selected + step
-- 		if new_selected > #self._assets_list then
-- 			local old_page = math.ceil(asset_selected / self._num_items)
-- 			local new_page = math.ceil(new_selected / self._num_items)
-- 			if old_page < new_page then
-- 				new_selected = #self._assets_list
-- 			end
-- 		end
-- 	end
-- 	if new_selected >= 1 and new_selected <= #self._assets_list then
-- 		self._asset_selected = asset_selected
-- 		self:select_asset(new_selected)
-- 	end
-- end
-- function AssetsItem:move_left()
-- 	self:move(-1, 0)
-- 	do return end
-- 	if #self._assets_list == 0 then
-- 		return
-- 	end
-- 	self._asset_selected = self._asset_selected or 0
-- 	local new_selected = math.max(self._asset_selected - 1, 1)
-- 	self:select_asset(new_selected)
-- 	return
-- end
-- function AssetsItem:move_up()
-- 	self:move(0, -1)
-- end
-- function AssetsItem:move_down()
-- 	self:move(0, 1)
-- end
-- function AssetsItem:move_right()
-- 	self:move(1, 0)
-- 	do return end
-- 	if #self._assets_list == 0 then
-- 		return
-- 	end
-- 	self._asset_selected = self._asset_selected or 0
-- 	local new_selected = math.min(self._asset_selected + 1, #self._assets_list)
-- 	self:select_asset(new_selected)
-- 	return
-- end
-- function AssetsItem:confirm_pressed()
-- 	return self:_return_asset_info(self._asset_selected)
-- end
-- function AssetsItem:something_selected()
-- 	return self._asset_selected and true or false
-- end

function LoadoutItem:init(panel, text, i, assets_names, menu_component_data)
	LoadoutItem.super.init(self, panel, text, i, assets_names, 5, menu_component_data, true)
	self._text_strings_localized = true
	local got_deployables = managers.player:availible_equipment(1)
	got_deployables = got_deployables and #got_deployables > 0
	if got_deployables or self._assets_list[4] then
	end
	local primaries = not managers.blackmarket:get_crafted_category("primaries") and {}
	local got_primary = false
	for _, d in pairs(primaries) do
		got_primary = true
		break
	end
	if got_primary or self._assets_list[1] then
	end
	local when_to_split = 6
	do
		local equipped_weapon = managers.blackmarket:equipped_primary()
		local primary_slot = managers.blackmarket:equipped_weapon_slot("primaries")
		local icon_list = {}
		for i, icon in ipairs(managers.menu_component:create_weapon_mod_icon_list(equipped_weapon.weapon_id, "primaries", equipped_weapon.factory_id, primary_slot)) do
			if icon.equipped then
				table.insert(icon_list, icon)
			end
		end
		local split = when_to_split < #icon_list
		for index, icon in ipairs(icon_list) do
			local texture = icon.texture
			if DB:has(Idstring("texture"), texture) then
				local object = self._panel:bitmap({
					texture = texture,
					w = 16,
					h = 16,
					rotation = math.random(2) - 1.5,
					alpha = icon.equipped and 1 or 0.25,
					layer = 2
				})
				object:set_rightbottom(math.round(self._assets_list[1]:right() - index * 18) + 25, math.round(self._assets_list[1]:bottom() + 17.5))
				if split then
					if when_to_split < index then
						object:move(18 * when_to_split, 0)
					else
						object:move(0, 18)
					end
				end
			end
		end
	end
	do
		local equipped_weapon = managers.blackmarket:equipped_secondary()
		local primary_slot = managers.blackmarket:equipped_weapon_slot("secondaries")
		local icon_list = {}
		for i, icon in ipairs(managers.menu_component:create_weapon_mod_icon_list(equipped_weapon.weapon_id, "secondaries", equipped_weapon.factory_id, primary_slot)) do
			if icon.equipped then
				table.insert(icon_list, icon)
			end
		end
		local split = when_to_split < #icon_list
		for index, icon in ipairs(icon_list) do
			local texture = icon.texture
			if DB:has(Idstring("texture"), texture) then
				local object = self._panel:bitmap({
					texture = texture,
					w = 16,
					h = 16,
					rotation = math.random(2) - 1.5,
					alpha = icon.equipped and 1 or 0.25,
					layer = 2
				})
				object:set_rightbottom(math.round(self._assets_list[2]:right() - index * 18) + 25, math.round(self._assets_list[2]:bottom() + 17.5))
				if split then
					if when_to_split < index then
						object:move(18 * when_to_split, 0)
					else
						object:move(0, 18)
					end
				end
			end
		end
	end
	self._asset_text:move(0, 25)
	self:select_asset(self._my_menu_component_data.selected or 1, true)
end
function LoadoutItem:post_init()
	if Application:production_build() then
		self._panel:set_debug(false)
	end
end
function LoadoutItem:select(no_sound)
	LoadoutItem.super.select(self, no_sound)
end
function LoadoutItem:deselect()
	LoadoutItem.super.deselect(self)
end
function LoadoutItem:mouse_moved(x, y)
	return LoadoutItem.super.mouse_moved(self, x, y)
end
function LoadoutItem:open_node(node)
	self._my_menu_component_data.changing_loadout = nil
	self._my_menu_component_data.current_slot = nil
	if node == 1 then
		self._my_menu_component_data.changing_loadout = "primary"
		self._my_menu_component_data.current_slot = managers.blackmarket:equipped_weapon_slot("primaries")
		managers.menu_component:post_event("menu_enter")
		managers.menu:open_node("loadout", {
			self:create_primaries_loadout()
		})
	elseif node == 2 then
		self._my_menu_component_data.changing_loadout = "secondary"
		self._my_menu_component_data.current_slot = managers.blackmarket:equipped_weapon_slot("secondaries")
		managers.menu_component:post_event("menu_enter")
		managers.menu:open_node("loadout", {
			self:create_secondaries_loadout()
		})
	elseif node == 3 then
		managers.menu_component:post_event("menu_enter")
		managers.menu:open_node("loadout", {
			self:create_melee_weapon_loadout()
		})
	elseif node == 4 then
		managers.menu_component:post_event("menu_enter")
		managers.menu:open_node("loadout", {
			self:create_armor_loadout()
		})
	elseif node == 5 then
		managers.menu_component:post_event("menu_enter")
		managers.menu:open_node("loadout", {
			self:create_deployable_loadout()
		})
	elseif node == 6 then
		managers.menu_component:post_event("menu_enter")
		managers.menu:open_node("loadout", {
			self:create_grenade_loadout()
		})
	end
	managers.menu_component:on_ready_pressed_mission_briefing_gui(false)
end
function LoadoutItem:confirm_pressed()
	if self._asset_selected then
		self:open_node(self._asset_selected)
		return true
	end
end
function LoadoutItem:mouse_pressed(button, x, y)
	local inside = LoadoutItem.super.mouse_pressed(self, button, x, y)
	if inside == false then
		return false
	end
	self:open_node(inside)
	return inside and true
end
function LoadoutItem:populate_category(category, data)
	local crafted_category = managers.blackmarket:get_crafted_category(category) or {}
	local new_data = {}
	local index = 0
	local max_items = data.override_slots and data.override_slots[1] * data.override_slots[2] or 9
	local max_rows = tweak_data.gui.MAX_WEAPON_ROWS or 3
	max_items = max_rows * (data.override_slots and data.override_slots[2] or 3)
	for i = 1, max_items do
		data[i] = nil
	end
	local weapon_data = Global.blackmarket_manager.weapons
	local guis_catalog = "guis/"
	for i, crafted in pairs(crafted_category) do
		guis_catalog = "guis/"
		local bundle_folder = tweak_data.weapon[crafted.weapon_id] and tweak_data.weapon[crafted.weapon_id].texture_bundle_folder
		if bundle_folder then
			guis_catalog = guis_catalog .. "dlcs/" .. tostring(bundle_folder) .. "/"
		end
		new_data = {}
		new_data.name = crafted.weapon_id
		new_data.name_localized = managers.weapon_factory:get_weapon_name_by_factory_id(crafted.factory_id)
		new_data.category = category
		new_data.slot = i
		new_data.unlocked = managers.blackmarket:weapon_unlocked(crafted.weapon_id)
		new_data.lock_texture = not new_data.unlocked and "guis/textures/pd2/lock_level"
		new_data.equipped = crafted.equipped
		new_data.can_afford = true
		new_data.skill_based = weapon_data[crafted.weapon_id].skill_based
		new_data.skill_name = new_data.skill_based and "bm_menu_skill_locked_" .. new_data.name
		new_data.level = managers.blackmarket:weapon_level(crafted.weapon_id)
		local texture_name = tweak_data.weapon[crafted.weapon_id].texture_name or tostring(crafted.weapon_id)
		new_data.bitmap_texture = guis_catalog .. "textures/pd2/blackmarket/icons/weapons/" .. texture_name
		new_data.comparision_data = new_data.unlocked and managers.blackmarket:get_weapon_stats(category, i)
		new_data.stream = false
		new_data.global_value = tweak_data.weapon[new_data.name] and tweak_data.weapon[new_data.name].global_value or "normal"
		new_data.dlc_locked = tweak_data.lootdrop.global_values[new_data.global_value].unlock_id or nil
		new_data.lock_texture = BlackMarketGui.get_lock_icon(self, new_data)
		if not new_data.equipped and new_data.unlocked then
			table.insert(new_data, "lo_w_equip")
		end
		local icon_list = managers.menu_component:create_weapon_mod_icon_list(crafted.weapon_id, category, crafted.factory_id, i)
		local icon_index = 1
		new_data.mini_icons = {}
		for _, icon in pairs(icon_list) do
			table.insert(new_data.mini_icons, {
				texture = icon.texture,
				right = (icon_index - 1) * 18,
				bottom = 0,
				layer = 1,
				w = 16,
				h = 16,
				stream = false,
				alpha = icon.equipped and 1 or 0.25
			})
			icon_index = icon_index + 1
		end
		data[i] = new_data
		index = i
	end
	for i = 1, max_items do
		if not data[i] then
			new_data = {}
			new_data.name = "empty_slot"
			new_data.name_localized = managers.localization:text("bm_menu_empty_weapon_slot")
			new_data.name_localized_selected = new_data.name_localized
			new_data.is_loadout = true
			new_data.category = category
			new_data.empty_slot = true
			new_data.slot = i
			new_data.unlocked = true
			new_data.equipped = false
			data[i] = new_data
		end
	end
end
function LoadoutItem:populate_primaries(data)
	self:populate_category("primaries", data)
end
function LoadoutItem:populate_secondaries(data)
	self:populate_category("secondaries", data)
end
function LoadoutItem:populate_armors(data)
	local new_data = {}
	local index = 0
	local guis_catalog = "guis/"
	for armor_id, armor_data in pairs(tweak_data.blackmarket.armors) do
		local bm_data = Global.blackmarket_manager.armors[armor_id]
		guis_catalog = "guis/"
		local bundle_folder = tweak_data.blackmarket.armors[armor_id] and tweak_data.blackmarket.armors[armor_id].texture_bundle_folder
		if bundle_folder then
			guis_catalog = guis_catalog .. "dlcs/" .. tostring(bundle_folder) .. "/"
		end
		if bm_data.owned then
			index = index + 1
			new_data = {}
			new_data.name = tweak_data.blackmarket.armors[armor_id].name_id
			new_data.category = "armors"
			new_data.slot = index
			new_data.unlocked = bm_data.unlocked
			new_data.lock_texture = not new_data.unlocked and "guis/textures/pd2/lock_level"
			new_data.equipped = bm_data.equipped
			new_data.bitmap_texture = guis_catalog .. "textures/pd2/blackmarket/icons/armors/" .. armor_id
			if not new_data.equipped then
				table.insert(new_data, "a_equip")
			end
			data[index] = new_data
		end
	end
	for i = 1, 9 do
		if not data[i] then
			new_data = {}
			new_data.name = "empty"
			new_data.name_localized = ""
			new_data.category = "armors"
			new_data.slot = i
			new_data.unlocked = true
			new_data.equipped = false
			data[i] = new_data
		end
	end
end
function LoadoutItem:populate_deployables(data)
	local deployables = managers.player:availible_equipment(1) or {}
	local new_data = {}
	local index = 0
	local guis_catalog = "guis/"
	for i, deployable in ipairs(deployables) do
		guis_catalog = "guis/"
		local bundle_folder = tweak_data.blackmarket.deployables[deployable] and tweak_data.blackmarket.deployables[deployable].texture_bundle_folder
		if bundle_folder then
			guis_catalog = guis_catalog .. "dlcs/" .. tostring(bundle_folder) .. "/"
		end
		new_data = {}
		new_data.name = deployable
		new_data.name_localized = managers.localization:text(tweak_data.upgrades.definitions[deployable].name_id)
		new_data.category = "deployables"
		new_data.bitmap_texture = guis_catalog .. "textures/pd2/blackmarket/icons/deployables/" .. tostring(deployable)
		new_data.slot = i
		new_data.unlocked = true
		new_data.equipped = managers.player:equipment_in_slot(1) == deployable
		new_data.stream = false
		if not new_data.equipped then
			table.insert(new_data, "lo_d_equip")
		end
		data[i] = new_data
		index = i
	end
	for i = 1, 9 do
		if not data[i] then
			new_data = {}
			new_data.name = "empty"
			new_data.name_localized = ""
			new_data.category = "deployables"
			new_data.slot = i
			new_data.unlocked = true
			new_data.equipped = false
			data[i] = new_data
		end
	end
end
function LoadoutItem:populate_grenades(data)
	local new_data = {}
	local index = 0
	local guis_catalog = "guis/"
	for i, grenade in ipairs(tweak_data.blackmarket.projectiles) do
		guis_catalog = "guis/"
		local bundle_folder = tweak_data.blackmarket.projectiles[grenade] and tweak_data.blackmarket.projectiles[grenade].texture_bundle_folder
		if bundle_folder then
			guis_catalog = guis_catalog .. "dlcs/" .. tostring(bundle_folder) .. "/"
		end
		new_data = {}
		new_data.name = grenade
		new_data.name_localized = managers.localization:text(tweak_data.upgrades.definitions[grenade].name_id)
		new_data.category = "grenades"
		new_data.bitmap_texture = guis_catalog .. "textures/pd2/blackmarket/icons/deployables/" .. tostring(deployable)
		new_data.slot = i
		new_data.unlocked = true
		new_data.equipped = managers.player:equipment_in_slot(1) == grenade
		new_data.stream = false
		if not new_data.equipped then
			table.insert(new_data, "lo_d_grenade")
		end
		data[i] = new_data
		index = i
	end
	for i = 1, 9 do
		if not data[i] then
			new_data = {}
			new_data.name = "empty"
			new_data.name_localized = ""
			new_data.category = "grenades"
			new_data.slot = i
			new_data.unlocked = true
			new_data.equipped = false
			data[i] = new_data
		end
	end
end
function LoadoutItem:create_primaries_loadout()
	local data = {}
	table.insert(data, {
		name = "bm_menu_primaries",
		category = "primaries",
		on_create_func = callback(self, self, "populate_primaries"),
		override_slots = {3, 3},
		identifier = Idstring("weapon")
	})
	data.topic_id = "menu_loadout_blackmarket"
	data.topic_params = {
		category = managers.localization:text("bm_menu_primaries")
	}
	return data
end
function LoadoutItem:create_secondaries_loadout()
	local data = {}
	table.insert(data, {
		name = "bm_menu_secondaries",
		category = "secondaries",
		on_create_func = callback(self, self, "populate_secondaries"),
		override_slots = {3, 3},
		identifier = Idstring("weapon")
	})
	data.topic_id = "menu_loadout_blackmarket"
	data.topic_params = {
		category = managers.localization:text("bm_menu_secondaries")
	}
	return data
end
function LoadoutItem:create_deployable_loadout()
	local data = {}
	table.insert(data, {
		name = "bm_menu_deployables",
		category = "deployables",
		on_create_func_name = "populate_deployables",
		override_slots = {4, 2},
		identifier = Idstring("deployable")
	})
	data.topic_id = "menu_loadout_blackmarket"
	data.topic_params = {
		category = managers.localization:text("bm_menu_deployables")
	}
	return data
end
function NewLoadoutItem:init(panel, columns, rows, x, y, params)
	local parent_w, parent_h = panel:size()
	local w = math.round(parent_w / (columns or 1))
	local h = math.round(parent_h / (rows or 1))
	local font = tweak_data.menu.pd2_medium_font
	local font_size = tweak_data.menu.pd2_medium_font_size
	self._panel = panel:panel({
		w = w - 2,
		h = h - 2,
		x = (x - 1) * w + 1,
		y = (y - 1) * h + 1
	})
	self._info_panel = self._panel:panel({h = font_size})
	self._item_panel = self._panel:panel({
		h = 100
	})
	self._item_panel:set_position(0, 0)
	self._info_panel:set_top(self._item_panel:bottom())
	self._info_panel:left(self._item_panel:left())
	local font = tweak_data.menu.pd2_small_font
	local font_size = tweak_data.menu.pd2_small_font_size
	self._info_text = self._info_panel:text({
		font = font,
		font_size = font_size,
		visible = false,
		align = "center",
		rotation = 360
	})
	if params then
		if params.info_text then
			self:set_info_text(params.info_text, params.info_text_color)
		end
		if params.item_texture and DB:has(Idstring("texture"), params.item_texture) then
			self._item_image = self._item_panel:bitmap({
				texture = params.item_texture,
				layer = 1
			})
			local texture_width = self._item_image:texture_width()
			local texture_height = self._item_image:texture_height()
			local aspect = texture_width / texture_height
			local sw = math.min(self._item_panel:w(), self._item_panel:h() * aspect)
			local sh = math.min(self._item_panel:h(), self._item_panel:w() / aspect)
			self._item_image:set_size(sw, sh)
			self._item_image:set_center(self._item_panel:w() / 2, self._item_panel:h() / 2)
		elseif params.dual_texture_1 and params.dual_texture_2 then
			if DB:has(Idstring("texture"), params.dual_texture_1) then
				self._item_image1 = self._item_panel:bitmap({
					texture = params.dual_texture_1,
					layer = 1
				})
				local texture_width = self._item_image1:texture_width()
				local texture_height = self._item_image1:texture_height()
				local aspect = texture_width / texture_height
				local sw = math.min(self._item_panel:w(), self._item_panel:h() * aspect)
				local sh = math.min(self._item_panel:h(), self._item_panel:w() / aspect)
				self._item_image1:set_size(sw * 0.5, sh * 0.5)
				self._item_image1:set_center(self._item_panel:w() * 0.5, self._item_panel:h() * 0.35)
			end
			if DB:has(Idstring("texture"), params.dual_texture_2) then
				self._item_image2 = self._item_panel:bitmap({
					texture = params.dual_texture_2,
					layer = 1
				})
				local texture_width = self._item_image2:texture_width()
				local texture_height = self._item_image2:texture_height()
				local aspect = texture_width / texture_height
				local sw = math.min(self._item_panel:w(), self._item_panel:h() * aspect)
				local sh = math.min(self._item_panel:h(), self._item_panel:w() / aspect)
				self._item_image2:set_size(sw * 0.5, sh * 0.5)
				self._item_image2:set_center(self._item_panel:w() * 0.5, self._item_panel:h() * 0.65)
			end
		end
		if params.item_bg_texture and DB:has(Idstring("texture"), params.item_bg_texture) then
			local item_bg_image = self._item_panel:bitmap({
				texture = params.item_bg_texture,
				blend_mode = "add",
				layer = 0
			})
			if self._item_image then
				local texture_width = item_bg_image:texture_width()
				local texture_height = item_bg_image:texture_height()
				local panel_width = self._item_image:w()
				local panel_height = self._item_image:h()
				local tw = texture_width
				local th = texture_height
				local pw = panel_width
				local ph = panel_height
				if tw == 0 or th == 0 then
					Application:error("[NewLoadoutItem] BG Texture size error!:", "width", tw, "height", th)
					tw = 1
					th = 1
				end
				local sw = math.min(pw, ph * (tw / th))
				local sh = math.min(ph, pw / (tw / th))
				item_bg_image:set_size(math.round(sw), math.round(sh))
				item_bg_image:set_world_center(self._item_image:world_center())
			else
				item_bg_image:set_size(self._item_panel:w(), self._item_panel:h())
			end
		end
		if params.info_icons then
			self._info_icon_panel = self._info_panel:panel()
			local when_to_split = math.floor(self._info_icon_panel:w() / 18)
			local split = when_to_split < #params.info_icons
			for index, icon in ipairs(params.info_icons) do
				local texture = icon.texture
				if DB:has(Idstring("texture"), texture) then
					local object = self._info_icon_panel:bitmap({
						texture = texture,
						w = 16,
						h = 16,
						alpha = icon.equipped and 1 or 0.25,
						layer = 1
					})
					object:set_center(self._info_icon_panel:right() - (index - 1) * 18 - 9, self._info_icon_panel:h() / 2)
					if split and index > when_to_split then
						object:move(18 * when_to_split, -18)
						object:set_rotation(360)
					end
				else
				end
			end
		end
		self._params = params
	end
	self:deselect_item()
end
function LoadoutItem:create_grenade_loadout()
	local data = {}
	table.insert(data, {
		name = "bm_menu_grenades",
		category = "grenades",
		on_create_func_name = "populate_grenades",
		override_slots = {3, 2},
		identifier = Idstring("grenade")
	})
	data.topic_id = "menu_loadout_blackmarket"
	data.topic_params = {
		category = managers.localization:text("bm_menu_grenades")
	}
	return data
end
function LoadoutItem:create_melee_weapon_loadout()
	local data = {}
	table.insert(data, {
		name = "bm_menu_melee_weapons",
		category = "melee_weapons",
		on_create_func_name = "populate_melee_weapons",
		override_slots = {3, 3},
		identifier = Idstring("melee_weapon")
	})
	data.topic_id = "menu_loadout_blackmarket"
	data.topic_params = {
		category = managers.localization:text("bm_menu_melee_weapons")
	}
	return data
end
function LoadoutItem:create_armor_loadout()
	local data = {}
	table.insert(data, {
		name = "bm_menu_armors",
		category = "armors",
		on_create_func_name = "populate_armors",
		override_slots = {4, 2},
		identifier = Idstring("armor")
	})
	data.topic_id = "menu_loadout_blackmarket"
	data.topic_params = {
		category = managers.localization:text("bm_menu_armors")
	}
	return data
end
function LoadoutItem.animate_select(o, center_helper, instant)
	LoadoutItem.super.animate_select(o, center_helper, instant)
end
function LoadoutItem.animate_deselect(o, center_helper, instant)
	LoadoutItem.super.animate_deselect(o, center_helper, instant)
end
TeamLoadoutItem = TeamLoadoutItem or class(MissionBriefingTabItem)
function TeamLoadoutItem:init(panel, text, i)
	local num_player_slots = BigLobbyGlobals and BigLobbyGlobals:num_player_slots() or tweak_data.max_players
	TeamLoadoutItem.super.init(self, panel, text, i)
	self._player_slots = {}
	local quarter_width = self._panel:w() / 4
	local slot_panel
	for i = 1, num_player_slots do
		local old_right = slot_panel and slot_panel:right() or 0
		slot_panel = self._panel:panel({
			x = old_right,
			y = 0,
			w = quarter_width,
			h = 250,
			valign = "grow"
		})
		self._player_slots[i] = {}
		self._player_slots[i].panel = slot_panel
		self._player_slots[i].outfit = {}
		local kit_menu = managers.menu:get_menu("kit_menu")
		if kit_menu then
			local kit_slot = kit_menu.renderer:get_player_slot_by_peer_id(i)
			if kit_slot then
				local outfit = kit_slot.outfit
				local character = kit_slot.params and kit_slot.params.character
				if outfit and character then
					self:set_slot_outfit(i, character, outfit)
				end
			end
		end
	end
end

function TeamLoadoutItem:reduce_to_small_font(iteration)
	TeamLoadoutItem.super.reduce_to_small_font(self, iteration)

	local num_player_slots = BigLobbyGlobals and BigLobbyGlobals:num_player_slots() or tweak_data.max_players

	for i = 1, num_player_slots do
		if self._player_slots[i].box then
			self._player_slots[i].box:create_sides(self._player_slots[i].panel, {
				sides = {
					0,
					0,
					0,
					0
				}
			})
		end
	end
end

MutatorsItem = MutatorsItem or class(MissionBriefingTabItem)
function MutatorsItem:init(panel, text, i)
	MissionBriefingTabItem.init(self, panel, text, i)
	if not managers.mutators:are_mutators_active() then
		return
	end
	local title_text = self._panel:text({
		name = "title_text",
		text = managers.localization:to_upper_text("menu_cn_mutators_active"),
		font_size = tweak_data.menu.pd2_medium_font_size,
		font = tweak_data.menu.pd2_medium_font,
		x = 10,
		y = 10,
		color = tweak_data.screen_colors.text
	})
	local x, y, w, h = title_text:text_rect()
	title_text:set_size(w, h)
	title_text:set_position(math.round(title_text:x()), math.round(title_text:y()))
	local _y = title_text:bottom() + 5
	local mutators_list = {}
	for i, active_mutator in pairs(managers.mutators:active_mutators()) do
		local mutator = active_mutator.mutator
		if mutator then
			table.insert(mutators_list, mutator)
		end
	end
	table.sort(mutators_list, function(a, b)
		return a:name() < b:name()
	end)
	for i, mutator in ipairs(mutators_list) do
		local text = string.format("%s - %s", mutator:name(), mutator:desc())
		local mutator_text = self._panel:text({
			name = "mutator_text_" .. tostring(mutator:id()),
			font = tweak_data.menu.pd2_small_font,
			font_size = tweak_data.menu.pd2_small_font_size,
			text = text,
			x = 10,
			y = _y,
			w = self._panel:w(),
			h = tweak_data.menu.pd2_small_font_size,
			wrap = true,
			word_wrap = true
		})
		local _, _, w, h = mutator_text:text_rect()
		mutator_text:set_size(w, h)
		_y = mutator_text:bottom() + 2
	end
end

CrimeSpreeModifierItem = CrimeSpreeModifierItem or class(MissionBriefingTabItem)

function CrimeSpreeModifierItem:init(panel, text, i, saved_descriptions)
	CrimeSpreeModifierItem.super.init(self, panel, text, i)

	if not managers.job:has_active_job() then
		return
	end

	local stage_data = managers.job:current_stage_data()
	local level_data = managers.job:current_level_data()
	local name_id = stage_data.name_id or level_data.name_id
	local briefing_id = managers.job:current_briefing_id()

	if managers.skirmish:is_skirmish() and not managers.skirmish:is_weekly_skirmish() then
		briefing_id = "heist_skm_random_briefing"
	end

	local title_text = self._panel:text({
		name = "title_text",
		y = 10,
		x = 10,
		text = managers.localization:to_upper_text(name_id),
		font_size = tweak_data.menu.pd2_medium_font_size,
		font = tweak_data.menu.pd2_medium_font,
		color = tweak_data.screen_colors.text
	})
	local x, y, w, h = title_text:text_rect()

	title_text:set_size(w, h)
	title_text:set_position(math.round(title_text:x()), math.round(title_text:y()))

	local pro_text = nil

	if managers.job:is_current_job_professional() then
		pro_text = self._panel:text({
			name = "pro_text",
			blend_mode = "add",
			text = managers.localization:to_upper_text("cn_menu_pro_job"),
			font_size = tweak_data.menu.pd2_medium_font_size,
			font = tweak_data.menu.pd2_medium_font,
			color = tweak_data.screen_colors.pro_color
		})
		local x, y, w, h = pro_text:text_rect()

		pro_text:set_size(w, h)
		pro_text:set_position(title_text:right() + 10, title_text:y())
	end

	self._scroll_panel = self._panel:panel({
		x = 10,
		y = title_text:bottom()
	})

	self._scroll_panel:grow(-self._scroll_panel:x() - 10, -self._scroll_panel:y())

	local desc_string = briefing_id and managers.localization:text(briefing_id) or ""
	local is_level_ghostable = managers.job:is_level_ghostable(managers.job:current_level_id()) and managers.groupai and managers.groupai:state():whisper_mode()

	if is_level_ghostable and Network:is_server() then
		if managers.job:is_level_ghostable_required(managers.job:current_level_id()) then
			desc_string = desc_string .. "\n\n" .. managers.localization:text("menu_ghostable_stage_required")
		else
			desc_string = desc_string .. "\n\n" .. managers.localization:text("menu_ghostable_stage")
		end
	end

	local desc_text = self._scroll_panel:text({
		name = "description_text",
		wrap = true,
		word_wrap = true,
		text = desc_string,
		font_size = tweak_data.menu.pd2_small_font_size,
		font = tweak_data.menu.pd2_small_font,
		color = tweak_data.screen_colors.text
	})

	if saved_descriptions then
		local text = ""

		for i, text_id in ipairs(saved_descriptions) do
			text = text .. managers.localization:text(text_id) .. "\n"
		end

		desc_text:set_text(text)
	end

	self:_chk_add_scrolling()

	if managers.skirmish:is_weekly_skirmish() then
		managers.network:add_event_listener({}, "on_set_dropin", function ()
			self:add_description_text("\n##" .. managers.localization:text("menu_weekly_skirmish_dropin_warning") .. "##")
		end)
	end
end

function CrimeSpreeModifierItem:reduce_to_small_font(iteration)
	CrimeSpreeModifierItem.super.reduce_to_small_font(self, iteration)

	if not alive(self._scroll_panel) then
		return
	end

	local desc_text = self._scroll_panel:child("description_text")
	local title_text = self._panel:child("title_text")

	self._scroll_panel:set_h(self._panel:h())
	self._scroll_panel:set_y(title_text:bottom())
	self._scroll_panel:grow(0, -self._scroll_panel:y())

	local show_scroll_line_top = desc_text:top() < 0
	local show_scroll_line_bottom = self._scroll_panel:h() < desc_text:bottom()

	if self._scroll_box then
		self._scroll_box:create_sides(self._scroll_panel, {
			sides = {
				0,
				0,
				show_scroll_line_top and 2 or 0,
				show_scroll_line_bottom and 2 or 0
			}
		})
	end
end

function CrimeSpreeModifierItem:_chk_add_scrolling()
	local desc_text = self._scroll_panel:child("description_text")
	local _, _, _, h = desc_text:text_rect()

	desc_text:set_h(h)

	if self._scroll_panel:h() < desc_text:h() and not self._scrolling then
		self._scrolling = true
		self._scroll_box = BoxGuiObject:new(self._scroll_panel, {
			sides = {
				0,
				0,
				0,
				0
			}
		})
		self._show_scroll_line_top = false
		self._show_scroll_line_bottom = false
		local show_scroll_line_top = desc_text:top() < 0
		local show_scroll_line_bottom = self._scroll_panel:h() < desc_text:bottom()

		if show_scroll_line_top ~= self._show_scroll_line_top or show_scroll_line_bottom ~= self._show_scroll_line_bottom then
			self._scroll_box:create_sides(self._scroll_panel, {
				sides = {
					0,
					0,
					show_scroll_line_top and 2 or 0,
					show_scroll_line_bottom and 2 or 0
				}
			})

			self._show_scroll_line_top = show_scroll_line_top
			self._show_scroll_line_bottom = show_scroll_line_bottom
		end

		if not managers.menu:is_pc_controller() then
			local legends = {
				"menu_legend_preview_move"
			}
			local t_text = ""

			for i, string_id in ipairs(legends) do
				local spacing = i > 1 and "  |  " or ""
				t_text = t_text .. spacing .. utf8.to_upper(managers.localization:text(string_id, {
					BTN_UPDATE = managers.localization:btn_macro("menu_update"),
					BTN_BACK = managers.localization:btn_macro("back")
				}))
			end

			local legend_text = self._panel:text({
				halign = "right",
				valign = "top",
				font = tweak_data.menu.pd2_small_font,
				font_size = tweak_data.menu.pd2_small_font_size,
				text = t_text
			})
			local _, _, lw, lh = legend_text:text_rect()

			legend_text:set_size(lw, lh)
			legend_text:set_righttop(self._panel:w() - 5, 5)
		end
	elseif self._scrolling then
		-- Nothing
	end
end

function CrimeSpreeModifierItem:on_whisper_mode_changed()
	local briefing_id = managers.job:current_briefing_id()

	if briefing_id then
		local desc_string = managers.localization:text(briefing_id)
		local is_level_ghostable = managers.job:is_level_ghostable(managers.job:current_level_id()) and managers.groupai and managers.groupai:state():whisper_mode()

		if is_level_ghostable then
			if managers.job:is_level_ghostable_required(managers.job:current_level_id()) then
				desc_string = desc_string .. "\n\n" .. managers.localization:text("menu_ghostable_stage_required")
			else
				desc_string = desc_string .. "\n\n" .. managers.localization:text("menu_ghostable_stage")
			end
		end

		if managers.skirmish:is_weekly_skirmish() and not Global.statistics_manager.playing_from_start then
			desc_string = desc_string .. "\n\n##" .. managers.localization:text("menu_weekly_skirmish_dropin_warning") .. "##"
		end

		self:set_description_text(desc_string)
	end
end

function CrimeSpreeModifierItem:set_title_text(text)
	self._panel:child("title_text"):set_text(text)
end

function CrimeSpreeModifierItem:add_description_text(text)
	self:set_description_text(self._scroll_panel:child("description_text"):text() .. "\n" .. text)
end

function CrimeSpreeModifierItem:set_description_text(text)
	local desc_text = self._scroll_panel:child("description_text")

	desc_text:set_text(text)
	managers.menu_component:make_color_text(desc_text, tweak_data.screen_colors.important_1)
	self:_chk_add_scrolling()
end

function CrimeSpreeModifierItem:move_up()
	if not managers.job:has_active_job() or not self._scrolling then
		return
	end

	local desc_text = self._scroll_panel:child("description_text")

	if desc_text:top() < 0 then
		self._scroll_speed = 2
	end
end

function CrimeSpreeModifierItem:move_down()
	if not managers.job:has_active_job() or not self._scrolling then
		return
	end

	local desc_text = self._scroll_panel:child("description_text")

	if self._scroll_panel:h() < desc_text:bottom() then
		self._scroll_speed = -2
	end
end

function CrimeSpreeModifierItem:update(t, dt)
	if not managers.job:has_active_job() or not self._scrolling then
		return
	end

	local desc_text = self._scroll_panel:child("description_text")

	if self._scroll_panel:h() < desc_text:h() and self._scroll_speed then
		self._scroll_speed = math.step(self._scroll_speed, 0, dt * 4)

		desc_text:move(0, math.clamp(self._scroll_speed, -1, 1) * 100 * dt)

		if desc_text:top() > 0 then
			desc_text:set_top(0)

			self._scroll_speed = nil
		elseif desc_text:bottom() < self._scroll_panel:h() then
			desc_text:set_bottom(self._scroll_panel:h())

			self._scroll_speed = nil
		end

		if self._scroll_speed == 0 then
			self._scroll_speed = nil
		end

		local show_scroll_line_top = desc_text:top() < 0
		local show_scroll_line_bottom = self._scroll_panel:h() < desc_text:bottom()

		if show_scroll_line_top ~= self._show_scroll_line_top or show_scroll_line_bottom ~= self._show_scroll_line_bottom then
			self._scroll_box:create_sides(self._scroll_panel, {
				sides = {
					0,
					0,
					show_scroll_line_top and 2 or 0,
					show_scroll_line_bottom and 2 or 0
				}
			})

			self._show_scroll_line_top = show_scroll_line_top
			self._show_scroll_line_bottom = show_scroll_line_bottom
		end
	end
end

function CrimeSpreeModifierItem:select(no_sound)
	CrimeSpreeModifierItem.super.select(self, no_sound)
end

function CrimeSpreeModifierItem:deselect()
	CrimeSpreeModifierItem.super.deselect(self)
end

function CrimeSpreeModifierItem:mouse_moved(x, y)
	return CrimeSpreeModifierItem.super.mouse_moved(self, x, y)
end

function CrimeSpreeModifierItem:mouse_pressed(button, x, y)
	local inside = CrimeSpreeModifierItem.super.mouse_pressed(self, button, x, y)

	if inside == false then
		return false
	end

	return inside
end

function MissionBriefingGui:init(saferect_ws, fullrect_ws, node)
	self._safe_workspace = saferect_ws
	self._full_workspace = fullrect_ws
	self._node = node
	self._fullscreen_panel = self._full_workspace:panel():panel()
	self._panel = self._safe_workspace:panel():panel({
		w = self._safe_workspace:panel():w() / 2,
		layer = 6
	})
	self._panel:set_right(self._safe_workspace:panel():w())
	self._panel:set_top(165 + tweak_data.menu.pd2_medium_font_size)
	self._panel:grow(0, -self._panel:top() / 3.5)
	self._ready = managers.network:session():local_peer():waiting_for_player_ready()
	local ready_text = self:ready_text()
	self._ready_button = self._panel:text({
		name = "ready_button",
		text = ready_text,
		align = "right",
		vertical = "center",
		font_size = tweak_data.menu.pd2_medium_font_size - 5,
		font = tweak_data.menu.pd2_large_font,
		color = PDTHMenu_color_normal,
		layer = 2,
		blend_mode = "normal",
		rotation = 360
	})
	self._ready_marker = self._panel:rect({
		color = PDTHMenu_color_marker,
		alpha = 1,
		layer = 1,
		visible = false
	})

	local x, y, w, h = self._ready_button:text_rect()
	
	self._ready_button:set_size(w, h)
	if not managers.menu:is_pc_controller() then
	end
	self._ready_tick_box = self._panel:bitmap({
		name = "ready_tickbox",
		texture = "guis/textures/menu_tickbox",
		texture_rect = {
			0,
			0,
			24,
			24
		},
		w = 18,
		h = 18,
		layer = 2
	})
	self._ready_marker:set_size((w + 313),h)
	self._ready_tick_box:set_rightbottom(self._panel:w() - 18, self._panel:h())
	self._ready_marker:set_rightbottom(self._panel:w() - 18, self._panel:h())
	if self._ready then
		self._ready_tick_box:set_image("guis/textures/menu_tickbox",24,-1,24,24)
	else
		self._ready_tick_box:set_image("guis/textures/menu_tickbox",0,-1,24,24)
	end
	self._ready_button:set_center_y(self._ready_tick_box:center_y() + 2)
	self._ready_button:set_right(self._ready_tick_box:left() - 5)
	local big_text = self._fullscreen_panel:text({
		name = "ready_big_text",
		text = ready_text,
		h = 90,
		align = "right",
		vertical = "bottom",
		font_size = tweak_data.menu.pd2_massive_font_size,
		font = tweak_data.menu.pd2_massive_font,
		color = tweak_data.screen_colors.button_stage_3,
		alpha = 0,
		layer = 1,
		rotation = 360
	})
	local _, _, w, h = big_text:text_rect()
	big_text:set_size(w, h)
	local x, y = managers.gui_data:safe_to_full_16_9(self._ready_button:world_right(), self._ready_button:world_center_y())
	big_text:set_world_right(x)
	big_text:set_world_center_y(y)
	big_text:move(13, -3)
	big_text:set_layer(self._ready_button:layer() - 1)
	if MenuBackdropGUI then
		MenuBackdropGUI.animate_bg_text(self, big_text)
	end
	WalletGuiObject.set_wallet(self._safe_workspace:panel(), 10)
	self._node:parameters().menu_component_data = self._node:parameters().menu_component_data or {}
	self._node:parameters().menu_component_data.asset = self._node:parameters().menu_component_data.asset or {}
	self._node:parameters().menu_component_data.loadout = self._node:parameters().menu_component_data.loadout or {}
	local asset_data = self._node:parameters().menu_component_data.asset
	local loadout_data = self._node:parameters().menu_component_data.loadout
	if not managers.menu:is_pc_controller() then
		local prev_page = self._panel:text({
			name = "tab_text_0",
			y = 0,
			w = 0,
			h = tweak_data.menu.pd2_medium_font_size,
			font_size = tweak_data.menu.pd2_medium_font_size,
			font = tweak_data.menu.pd2_medium_font,
			layer = 2,
			text = managers.localization:get_default_macro("BTN_BOTTOM_L"),
			vertical = "top"
		})
		local _, _, w, h = prev_page:text_rect()
		prev_page:set_size(w, h + 10)
		prev_page:set_left(0)
		self._prev_page = prev_page
	end
	self._items = {}
	local index = 1
	self._description_item = DescriptionItem:new(self._panel, utf8.to_upper(managers.localization:text("menu_description")), index, self._node:parameters().menu_component_data.saved_descriptions)
	table.insert(self._items, self._description_item)
	index = index + 1
	self._assets_item = AssetsItem:new(self._panel, managers.preplanning:has_current_level_preplanning() and managers.localization:to_upper_text("menu_preplanning") or utf8.to_upper(managers.localization:text("menu_assets")), index, {}, nil, asset_data)
	table.insert(self._items, self._assets_item)
	index = index + 1
	if managers.crime_spree:is_active() then
		local gage_assets_data = {}
		self._gage_assets_item = GageAssetsItem:new(self._panel, managers.localization:to_upper_text("menu_cs_gage_assets"), index)
		table.insert(self._items, self._gage_assets_item)
		index = index + 1
	end
	self._new_loadout_item = NewLoadoutTab:new(self._panel, managers.localization:to_upper_text("menu_loadout"), index, loadout_data)
	table.insert(self._items, self._new_loadout_item)
	index = index + 1
	if not Global.game_settings.single_player then
		self._team_loadout_item = TeamLoadoutItem:new(self._panel, utf8.to_upper(managers.localization:text("menu_team_loadout")), index)
		table.insert(self._items, self._team_loadout_item)
		index = index + 1
	end
	if managers.mutators and managers.mutators:are_mutators_active() then
		self._mutators_item = MutatorsItem:new(self._panel, utf8.to_upper(managers.localization:text("menu_mutators")), index)
		table.insert(self._items, self._mutators_item)
		index = index + 1
	end
	if managers.crime_spree and managers.crime_spree:is_active() then
		self._cs_modifer_item = CrimeSpreeModifierItem:new(self._panel, utf8.to_upper(managers.localization:text("menu_cs_modifiers")), index, self._node:parameters().menu_component_data.saved_descriptions)
		table.insert(self._items, self._cs_modifer_item)
		index = index + 1
	end
	local music_type = tweak_data.levels:get_music_style(Global.level_data.level_id)

	if music_type == "heist" then
		self._jukebox_item = JukeboxItem:new(self._panel, utf8.to_upper(managers.localization:text("menu_jukebox")), index)
		table.insert(self._items, self._jukebox_item)
		index = index + 1
	elseif music_type == "ghost" then
		self._jukebox_item = JukeboxGhostItem:new(self._panel, utf8.to_upper(managers.localization:text("menu_jukebox")), index)

		table.insert(self._items, self._jukebox_item)
		index = index + 1
	end
	local max_x = self._panel:w()
	if not managers.menu:is_pc_controller() then
		local next_page = self._panel:text({
			name = "tab_text_" .. tostring(#self._items + 1),
			y = 0,
			w = 0,
			h = tweak_data.menu.pd2_medium_font_size,
			font_size = tweak_data.menu.pd2_medium_font_size,
			font = tweak_data.menu.pd2_medium_font,
			layer = 2,
			text = managers.localization:get_default_macro("BTN_BOTTOM_R"),
			vertical = "top"
		})
		local _, _, w, h = next_page:text_rect()
		next_page:set_size(w, h + 10)
		next_page:set_right(self._panel:w())
		self._next_page = next_page
		max_x = next_page:left() - 5
	end
	self._reduced_to_small_font = not managers.menu:is_pc_controller()
	self._reduced_to_small_font = self._reduced_to_small_font or managers.crime_spree:is_active()
	self:chk_reduce_to_small_font()
	self._selected_item = 0
	self:set_tab(self._node:parameters().menu_component_data.selected_tab, true)
	local box_panel = self._panel:panel()
	box_panel:set_shape(self._items[self._selected_item]:panel():shape())
	BoxGuiObject:new(box_panel, {
		sides = {
			0,
			0,
			0,
			0
		}
	})
	if managers.assets:is_all_textures_loaded() or #managers.assets:get_all_asset_ids(true) == 0 then
		self:create_asset_tab()
	end
	self._items[self._selected_item]:select(true)
	if managers.job:is_current_job_competitive() then
		self:set_description_text_id("menu_competitive_rules")
	end
	self._multi_profile_item = MultiProfileItemGui:new(self._safe_workspace, self._panel)
	self._multi_profile_item:panel():set_bottom(self._panel:h())
	self._multi_profile_item:panel():set_left(0)
	self._multi_profile_item:set_name_editing_enabled(false)
	local mutators_panel = self._safe_workspace:panel()
	self._lobby_mutators_text = mutators_panel:text({
		name = "mutated_text",
		text = managers.localization:to_upper_text("menu_mutators_lobby_wait_title"),
		align = "right",
		vertical = "top",
		font_size = tweak_data.menu.pd2_large_font_size * 0.8,
		font = tweak_data.menu.pd2_large_font,
		color = tweak_data.screen_colors.mutators_color_text,
		layer = self._ready_button:layer()
	})
	local _, _, w, h = self._lobby_mutators_text:text_rect()
	self._lobby_mutators_text:set_size(w, h)
	self._lobby_mutators_text:set_top(0)
	local mutators_active = managers.mutators:are_mutators_enabled() and managers.mutators:allow_mutators_in_level(managers.job:current_level_id())
	self._lobby_mutators_text:set_visible(mutators_active)
	self._lobby_code_text = LobbyCodeMenuComponent:new(self._safe_workspace, self._full_workspace)
	self._lobby_code_text:panel():set_layer(2)
	local local_peer = managers.network:session():local_peer()
	for peer_id, peer in pairs(managers.network:session():peers()) do
		if peer ~= local_peer then
			local outfit = managers.blackmarket:unpack_outfit_from_string(peer:profile("outfit_string"))
			self:set_slot_outfit(peer_id, peer:character(), outfit)
		end
	end
	self._enabled = true
	self:flash_ready()
end

function MissionBriefingGui:mouse_moved(x, y)
	if not alive(self._panel) or not alive(self._fullscreen_panel) or not self._enabled then
		return false, "arrow"
	end
	if self._displaying_asset then
		return false, "arrow"
	end
	if game_state_machine:current_state().blackscreen_started and game_state_machine:current_state():blackscreen_started() then
		return false, "arrow"
	end
	local mouse_over_tab = false
	for _, tab in ipairs(self._items) do
		local selected, highlighted = tab:mouse_moved(x, y)
		if highlighted and not selected then
			mouse_over_tab = true
		end
	end
	if mouse_over_tab then
		return true, "link"
	end
	local fx, fy = managers.mouse_pointer:modified_fullscreen_16_9_mouse_pos()
	for peer_id = 1, CriminalsManager.MAX_NR_CRIMINALS do
		if managers.hud:is_inside_mission_briefing_slot(peer_id, "name", fx, fy) then
			return true, "link"
		end
	end
	if self._ready_button:inside(x, y) or self._ready_tick_box:inside(x, y) then
		if not self._ready_highlighted then
			self._ready_highlighted = true
			self._ready_button:set_color(tweak_data.screen_colors.button_stage_2)
			managers.menu_component:post_event("highlight")
		end
		return true, "link"
	elseif self._ready_highlighted then
		self._ready_button:set_color(tweak_data.screen_colors.button_stage_3)
		self._ready_highlighted = false
	end
	if managers.hud._hud_mission_briefing and managers.hud._hud_mission_briefing._backdrop then
		managers.hud._hud_mission_briefing._backdrop:mouse_moved(x, y)
	end
	if self._lobby_code_text then
		local success, mouse_state = self._lobby_code_text:mouse_moved(x, y)

		if success then
			return success, mouse_state
		end
	end
	local u, p = self._multi_profile_item:mouse_moved(x, y)
	return u or false, p or "arrow"
end
function MissionBriefingGui:on_ready_pressed(ready)
	if not managers.network:session() then
		return
	end
	local ready_changed = true
	if ready ~= nil then
		ready_changed = self._ready ~= ready
		self._ready = ready
	else
		self._ready = not self._ready
	end
	managers.network:session():local_peer():set_waiting_for_player_ready(self._ready)
	managers.network:session():chk_send_local_player_ready()
	managers.network:session():on_set_member_ready(managers.network:session():local_peer():id(), self._ready, ready_changed, false)
	local ready_text = self:ready_text()
	self._ready_button:set_text(ready_text)
	self._fullscreen_panel:child("ready_big_text"):set_text(ready_text)
	if self._ready then
		self._ready_tick_box:set_image("guis/textures/menu_tickbox",24,-1,24,24)
	else
		self._ready_tick_box:set_image("guis/textures/menu_tickbox",0,-1,24,24)
	end
	if ready_changed then
		if self._ready then
			if managers.menu:active_menu() and managers.menu:active_menu().logic and managers.menu:active_menu().logic:selected_node() then
				local item = managers.menu:active_menu().logic:selected_node():item("choose_jukebox_your_choice")
				if item then
					item:set_icon_visible(false)
				end
			end
			managers.menu_component:post_event("box_tick")
		else
			managers.menu_component:post_event("box_untick")
		end
	end
end
