
local is_win32 = SystemInfo:platform() == Idstring("WIN32")
local NOT_WIN_32 = not is_win32
local WIDTH_MULTIPLIER = NOT_WIN_32 and 0.68 or 0.71
local BOX_GAP = 13.5
local GRID_H_MUL = (NOT_WIN_32 and 6.9 or 6.95) / 8
local ITEMS_PER_ROW = 3
local ITEMS_PER_COLUMN = 3
local BUY_MASK_SLOTS = {
	7,
	4
}
local WEAPON_MODS_SLOTS = {
	6,
	1
}
local WEAPON_MODS_GRID_H_MUL = 0.126
local DEFAULT_LOCKED_BLEND_MODE = "normal"
local DEFAULT_LOCKED_BLEND_ALPHA = 0.35
local DEFAULT_LOCKED_COLOR = Color(1, 1, 1)
local massive_font = tweak_data.menu.pd2_massive_font
local large_font = tweak_data.menu.pd2_large_font
local medium_font = tweak_data.menu.pd2_medium_font
local small_font = tweak_data.menu.pd2_small_font
local tiny_font = tweak_data.menu.tiny_font
local massive_font_size = tweak_data.menu.pd2_massive_font_size
local large_font_size = tweak_data.menu.pd2_large_font_size
local medium_font_size = tweak_data.menu.pd2_medium_font_size
local small_font_size = tweak_data.menu.pd2_small_font_size
local tiny_font_size = tweak_data.menu.pd2_tiny_font_size

BlackMarketGuiButtonItem = BlackMarketGuiButtonItem or class(BlackMarketGuiItem)
function BlackMarketGuiButtonItem:init(main_panel, data, x)
	BlackMarketGuiButtonItem.super.init(self, main_panel, data, 0, 0, 10, 10)
	local up_font_size = NOT_WIN_32 and RenderSettings.resolution.y < 720 and self._data.btn == "BTN_STICK_R" and 2 or 0
	self._btn_text = self._panel:text({
		name = "text",
		text = "",
		align = "left",
		x = 10,
		font_size = small_font_size + up_font_size,
		font = small_font,
		color = PDTHMenu_color_normal,
		blend_mode = "normal",
		layer = 1
	})
	self._btn_text_id = data.name
	self._btn_text_legends = data.legends
	BlackMarketGui.make_fine_text(self, self._btn_text)
	self._panel:set_size(main_panel:w() - x * 2, medium_font_size)
	self._panel:rect({
		name = "select_rect",
		blend_mode = "normal",
		color = PDTHMenu_color_marker,
		valign = "scale",
		halign = "scale"
	})
	if not managers.menu:is_pc_controller() then
		self._btn_text:set_color(tweak_data.screen_colors.text)
	end
	self._panel:set_left(x)
	self._panel:hide()
	self:set_order(data.prio)
	self._btn_text:set_right(self._panel:w())
	self:deselect(true)
	self:set_highlight(false)
end

function BlackMarketGuiButtonItem:refresh()
	if managers.menu:is_pc_controller() then
		self._btn_text:set_color(self._highlighted and PDTHMenu_color_highlight or PDTHMenu_color_normal)
	end
	self._panel:child("select_rect"):set_visible(self._highlighted)
end
Hooks:PostHook(BlackMarketGui, "_setup", "pdthmenu", function(self, is_start_page, component_data)
		local back_button = self._panel:child("back_button")
		back_button:set_color(PDTHMenu_color_normal)
		if PDTH_Menu.options.font_enable then
			back_button:set_font(Idstring"fonts/font_small_shadow")
			back_button:set_font_size(19)
		end
		if self._fullscreen_panel:child("back_button") then
			self._fullscreen_panel:child("back_button"):hide()
		end
		self._back_marker = self._panel:bitmap({
			name = "back_marker",
			color = PDTHMenu_color_marker,
			layer = self._panel:child("back_button"):layer() - 1
		})
		x,y,w,h = back_button:text_rect()
		self._back_marker:set_shape(x,y,313,h)
		self._back_marker:set_right(x + w)
		self._back_marker:set_visible(managers.menu:is_pc_controller() and false)
end)

function BlackMarketGui:mouse_moved(o, x, y)
	if managers.menu_scene and managers.menu_scene:input_focus() then
		return false
	end
	if not self._enabled then
		return
	end
	if self._renaming_item then
		return true, "link"
	end
	if alive(self._no_input_panel) then
		self._no_input = self._no_input_panel:inside(x, y)
	end
	if alive(self._context_panel) then
		local context_btns = self._context_panel:child("btns"):children()
		local update_select = false

		if not self._context_btn_selected then
			update_select = true
		elseif not context_btns[self._context_btn_selected]:inside(x, y) then
			context_btns[self._context_btn_selected]:set_color(tweak_data.screen_colors.button_stage_3)

			self._context_btn_selected = nil
			update_select = true
		end

		if update_select then
			for i, btn in ipairs(context_btns) do
				if btn:inside(x, y) then
					self._context_btn_selected = i

					managers.menu_component:post_event("highlight")
					btn:set_color(tweak_data.screen_colors.button_stage_2)

					break
				end
			end
		end

		if self._context_btn_selected then
			return true, "link"
		end

		local used = false
		local pointer = "arrow"

		if self._panel:child("back_button"):inside(x, y) then
			used = true
			pointer = "link"

			if not self._back_button_highlighted then
				self._back_button_highlighted = true

				self._panel:child("back_button"):set_color(tweak_data.screen_colors.button_stage_2)
				managers.menu_component:post_event("highlight")

				return used, pointer
			end
		elseif self._back_button_highlighted then
			self._back_button_highlighted = false

			self._panel:child("back_button"):set_color(tweak_data.screen_colors.button_stage_3)
		end

		return used, pointer
	end
	if self._extra_options_data then
		local used = false
		local pointer = "arrow"
		self._extra_options_data.selected = self._extra_options_data.selected or 1
		local selected_slot
		for i = 1, self._extra_options_data.num_panels do
			local option = self._extra_options_data[i]
			local panel = option.panel
			local image = option.image
			if alive(panel) and panel:inside(x, y) then
				if not option.highlighted then
					option.highlighted = true
				end
				used = true
				pointer = "link"
			elseif option.highlighted then
				option.highlighted = false
			end
			if alive(image) then
				image:set_alpha((option.selected and 1 or 0.9) * (option.highlighted and 1 or 0.9))
			end
		end
		if used then
			return used, pointer
		end
	elseif self._steam_inventory_extra_data and alive(self._steam_inventory_extra_data.gui_panel) then
		local used = false
		local pointer = "arrow"
		local extra_data = self._steam_inventory_extra_data
		if extra_data.arrow_left:inside(x, y) then
			if not extra_data.arrow_left_highlighted then
				extra_data.arrow_left_highlighted = true
				extra_data.arrow_left:set_color(PDTHMenu_color_marker)
				managers.menu_component:post_event("highlight")
			end
			used = true
			pointer = "link"
		elseif extra_data.arrow_left_highlighted then
			extra_data.arrow_left_highlighted = false
			extra_data.arrow_left:set_color(PDTHMenu_color_normal)
		end
		if extra_data.arrow_right:inside(x, y) then
			if not extra_data.arrow_right_highlighted then
				extra_data.arrow_right_highlighted = true
				extra_data.arrow_right:set_color(PDTHMenu_color_marker)
				managers.menu_component:post_event("highlight")
			end
			used = true
			pointer = "link"
		elseif extra_data.arrow_right_highlighted then
			extra_data.arrow_right_highlighted = false
			extra_data.arrow_right:set_color(PDTHMenu_color_normal)
		end
		if used then
			if alive(extra_data.bg) then
				extra_data.bg:set_color(PDTHMenu_color_marker:with_alpha(0.2))
				extra_data.bg:set_alpha(1)
			end
			return used, pointer
		elseif alive(extra_data.bg) then
			extra_data.bg:set_color(Color.black:with_alpha(0.5))
		end
	end
	local inside_tab_area = self._tab_area_panel:inside(x, y)
	local used = true
	local pointer = inside_tab_area and self._highlighted == self._selected and "arrow" or "link"
	local inside_tab_scroll = self._tab_scroll_panel:inside(x, y)
	local update_select = false
	if not self._highlighted then
		update_select = true
		used = false
		pointer = "arrow"
	elseif not inside_tab_scroll or self._tabs[self._highlighted] and not self._tabs[self._highlighted]:inside(x, y) then
		self._tabs[self._highlighted]:set_highlight(not self._pages, not self._pages)
		self._highlighted = nil
		update_select = true
		used = false
		pointer = "arrow"
	end
	if update_select then
		for i, tab in ipairs(self._tabs) do
			update_select = inside_tab_scroll and tab:inside(x, y)
			if update_select then
				self._highlighted = i
				self._tabs[self._highlighted]:set_highlight(self._selected ~= self._highlighted)
				used = true
				pointer = self._highlighted == self._selected and "arrow" or "link"
			end
		end
	end
	if self._tabs[self._selected] then
		local tab_used, tab_pointer = self._tabs[self._selected]:mouse_moved(x, y)
		if tab_used then
			local x, y = self._tabs[self._selected]:selected_slot_center()
			self._select_rect:set_world_center(x, y)
			self._select_rect:stop()
			self._select_rect_box:set_color(Color.white)
			self._select_rect:set_visible(y > self._tabs[self._selected]._grid_panel:top() and y < self._tabs[self._selected]._grid_panel:bottom() and self._selected_slot and self._selected_slot._name ~= "empty")
			used = tab_used
			pointer = tab_pointer
		end
	end
	if self._market_bundles then
		local active_bundle = self._market_bundles[self._data.active_market_bundle]
		if active_bundle then
			for key, data in pairs(active_bundle) do
				if key ~= "panel" and (alive(data.text) and data.text:inside(x, y) or alive(data.image) and data.image:inside(x, y)) then
					if not data.highlighted then
						data.highlighted = true
						if alive(data.image) then
							data.image:set_alpha(1)
						end
						if alive(data.text) then
							data.text:set_color(PDTHMenu_color_marker)
						end
						managers.menu_component:post_event("highlight")
					end
					if not used then
						used = true
						pointer = "link"
					end
				elseif data.highlighted then
					data.highlighted = false
					if alive(data.image) then
						data.image:set_alpha(0.9)
					end
					if alive(data.text) then
						data.text:set_color(PDTHMenu_color_normal)
					end
				end
			end
		end
		if self._market_bundles.arrow_left then
			if self._market_bundles.arrow_left:inside(x, y) then
				if not self._market_bundles.arrow_left_highlighted then
					self._market_bundles.arrow_left_highlighted = true
					managers.menu_component:post_event("highlight")
					self._market_bundles.arrow_left:set_color(PDTHMenu_color_marker)
				end
				if not used then
					used = true
					pointer = "link"
				end
			elseif self._market_bundles.arrow_left_highlighted then
				self._market_bundles.arrow_left_highlighted = false
				self._market_bundles.arrow_left:set_color(PDTHMenu_color_normal)
			end
		end
		if self._market_bundles.arrow_right then
			if self._market_bundles.arrow_right:inside(x, y) then
				if not self._market_bundles.arrow_right_highlighted then
					self._market_bundles.arrow_right_highlighted = true
					managers.menu_component:post_event("highlight")
					self._market_bundles.arrow_right:set_color(PDTHMenu_color_marker)
				end
				if not used then
					used = true
					pointer = "link"
				end
			elseif self._market_bundles.arrow_right_highlighted then
				self._market_bundles.arrow_right_highlighted = false
				self._market_bundles.arrow_right:set_color(PDTHMenu_color_normal)
			end
		end
	end
	if self._panel:child("back_button"):inside(x, y) then
		used = true
		pointer = "link"
		if not self._back_button_highlighted then
			self._back_button_highlighted = true
			self._panel:child("back_button"):set_color(PDTHMenu_color_highlight)
			self._panel:child("back_marker"):show()
			managers.menu_component:post_event("highlight")
			return used, pointer
		end
	elseif self._back_button_highlighted then
		self._back_button_highlighted = false
		self._panel:child("back_marker"):hide()
		self._panel:child("back_button"):set_color(PDTHMenu_color_normal)
	end
	update_select = false
	if not self._button_highlighted then
		update_select = true
	elseif self._btns[self._button_highlighted] and not self._btns[self._button_highlighted]:inside(x, y) then
		self._btns[self._button_highlighted]:set_highlight(false)
		self._button_highlighted = nil
		update_select = true
	end
	if update_select then
		for i, btn in pairs(self._btns) do
			if not self._button_highlighted and btn:visible() and btn:inside(x, y) then
				self._button_highlighted = i
				btn:set_highlight(true)
			else
				btn:set_highlight(false)
			end
		end
	end
	if self._button_highlighted then
		used = true
		pointer = "link"
	end
	if self._tab_scroll_table.left and self._tab_scroll_table.left_klick then
		local color
		if self._tab_scroll_table.left:inside(x, y) then
			color = PDTHMenu_color_marker
			used = true
			pointer = "link"
		else
			color = PDTHMenu_color_normal
		end
		self._tab_scroll_table.left:set_color(color)
	end
	if self._tab_scroll_table.right and self._tab_scroll_table.right_klick then
		local color
		if self._tab_scroll_table.right:inside(x, y) then
			color = PDTHMenu_color_marker
			used = true
			pointer = "link"
		else
			color = PDTHMenu_color_normal
		end
		self._tab_scroll_table.right:set_color(color)
	end
	if self._rename_info_text then
		local text_button = self._info_texts and self._info_texts[self._rename_info_text]
		if text_button then
			if self._slot_data and not self._slot_data.customize_locked and text_button:inside(x, y) then
				if not self._rename_highlight then
					self._rename_highlight = true
					text_button:set_blend_mode("normal")
					text_button:set_color(PDTHMenu_color_marker)
					local bg = self._info_texts_bg[self._rename_info_text]
					if alive(bg) then
						bg:set_visible(true)
						bg:set_color(PDTHMenu_color_normal)
					end
					managers.menu_component:post_event("highlight")
				end
				used = true
				pointer = "link"
			elseif self._rename_highlight then
				self._rename_highlight = false
				text_button:set_blend_mode("normal")
				text_button:set_color(tweak_data.screen_colors.text)
				local bg = self._info_texts_bg[self._rename_info_text]
				if alive(bg) then
					bg:set_visible(false)
					bg:set_color(Color.black)
				end
			end
		end
	end
	return used, pointer
end
 

 function BlackMarketGuiSlotItem:select(instant, no_sound)
	BlackMarketGuiSlotItem.super.select(self, instant, no_sound)
	if not managers.menu:is_pc_controller() then
		self:set_highlight(true, instant)
	end
	if self._text_in_mid and alive(self._panel:child("text")) then
		self._panel:child("text"):set_color(PDTHMenu_color_marker)
		self._panel:child("text"):set_blend_mode("normal")
		self._panel:child("text"):set_text(self._data.mid_text.no_upper and self._data.mid_text.selected_text or utf8.to_upper(self._data.mid_text.selected_text or ""))
		if alive(self._lock_bitmap) and self._data.mid_text.is_lock_same_color then
			self._lock_bitmap:set_color(self._panel:child("text"):color())
		end
	end
	if self._data.new_drop_data then
		local newdrop = self._data.new_drop_data
		if newdrop[1] and newdrop[2] and newdrop[3] then
			managers.blackmarket:remove_new_drop(newdrop[1], newdrop[2], newdrop[3])
			if newdrop.icon then
				newdrop.icon:parent():remove(newdrop.icon)
			end
			self._data.new_drop_data = nil
		end
	end
	if self._panel:child("equipped_text") and self._data.selected_text and not self._data.equipped then
		self._panel:child("equipped_text"):set_text(self._data.selected_text)
	end
	if self._mini_panel and self._data.hide_unselected_mini_icons then
		self._mini_panel:show()
	end
	return self
end
function BlackMarketGuiSlotItem:deselect(instant)
	BlackMarketGuiSlotItem.super.deselect(self, instant)
	if not managers.menu:is_pc_controller() then
		self:set_highlight(false, instant)
	end
	if self._text_in_mid and alive(self._panel:child("text")) then
		self._panel:child("text"):set_color(PDTHMenu_color_normal)
		self._panel:child("text"):set_blend_mode("normal")
		self._panel:child("text"):set_text(self._data.mid_text.no_upper and self._data.mid_text.noselected_text or utf8.to_upper(self._data.mid_text.noselected_text or ""))
		if alive(self._lock_bitmap) and self._data.mid_text.is_lock_same_color then
			self._lock_bitmap:set_color(self._panel:child("text"):color())
		end
	end
	if self._panel:child("equipped_text") and self._data.selected_text and not self._data.equipped then
		self._panel:child("equipped_text"):set_text("")
	end
	if self._mini_panel and self._data.hide_unselected_mini_icons then
		self._mini_panel:hide()
	end
end

function BlackMarketGui:populate_mods(data)
	local new_data = {}
	local default_mod = data.on_create_data.default_mod
	local crafted = managers.blackmarket:get_crafted_category(data.prev_node_data.category)[data.prev_node_data.slot]
	local global_values = crafted.global_values or {}
	local ids_id = Idstring(data.name)
	local cosmetic_kit_mod = nil
	local cosmetics_blueprint = crafted.cosmetics and crafted.cosmetics.id and tweak_data.blackmarket.weapon_skins[crafted.cosmetics.id] and tweak_data.blackmarket.weapon_skins[crafted.cosmetics.id].default_blueprint or {}

	for i, c_mod in ipairs(cosmetics_blueprint) do
		if Idstring(tweak_data.weapon.factory.parts[c_mod].type) == ids_id then
			cosmetic_kit_mod = c_mod

			break
		end
	end

	local gvs = {}
	local mod_t = {}
	local num_steps = #data.on_create_data
	local achievement_tracker = tweak_data.achievement.weapon_part_tracker
	local part_is_from_cosmetic = nil
	local guis_catalog = "guis/"

	for index, mod_t in ipairs(data.on_create_data) do
		local mod_name = mod_t[1]
		local mod_default = mod_t[2]
		local mod_global_value = mod_t[3] or "normal"
		part_is_from_cosmetic = cosmetic_kit_mod == mod_name
		guis_catalog = "guis/"
		local bundle_folder = tweak_data.blackmarket.weapon_mods[mod_name] and tweak_data.blackmarket.weapon_mods[mod_name].texture_bundle_folder

		if bundle_folder then
			guis_catalog = guis_catalog .. "dlcs/" .. tostring(bundle_folder) .. "/"
		end

		new_data = {
			name = mod_name or data.prev_node_data.name,
			name_localized = mod_name and managers.weapon_factory:get_part_name_by_part_id(mod_name) or managers.localization:text("bm_menu_no_mod"),
			category = data.category or data.prev_node_data and data.prev_node_data.category
		}
		new_data.bitmap_texture = guis_catalog .. "textures/pd2/blackmarket/icons/mods/" .. new_data.name
		new_data.slot = data.slot or data.prev_node_data and data.prev_node_data.slot
		new_data.global_value = mod_global_value
		new_data.unlocked = not crafted.customize_locked and part_is_from_cosmetic and 1 or mod_default or managers.blackmarket:get_item_amount(new_data.global_value, "weapon_mods", new_data.name, true)
		new_data.equipped = false
		new_data.stream = true
		new_data.default_mod = default_mod
		new_data.cosmetic_kit_mod = cosmetic_kit_mod
		new_data.is_internal = tweak_data.weapon.factory:is_part_internal(new_data.name)
		new_data.free_of_charge = part_is_from_cosmetic or tweak_data.blackmarket.weapon_mods[mod_name] and tweak_data.blackmarket.weapon_mods[mod_name].is_a_unlockable
		new_data.unlock_tracker = achievement_tracker[new_data.name] or false

		if crafted.customize_locked then
			new_data.unlocked = type(new_data.unlocked) == "number" and -math.abs(new_data.unlocked) or new_data.unlocked
			new_data.unlocked = new_data.unlocked ~= 0 and new_data.unlocked or false
			new_data.lock_texture = "guis/textures/pd2/lock_incompatible"
			new_data.dlc_locked = "bm_menu_cosmetic_locked_weapon"
		elseif not part_is_from_cosmetic and tweak_data.lootdrop.global_values[mod_global_value] and tweak_data.lootdrop.global_values[mod_global_value].dlc and not managers.dlc:is_dlc_unlocked(mod_global_value) then
			new_data.unlocked = -math.abs(new_data.unlocked)
			new_data.unlocked = new_data.unlocked ~= 0 and new_data.unlocked or false
			new_data.lock_texture = self:get_lock_icon(new_data)
			new_data.lock_color = self:get_lock_color(new_data)
			new_data.dlc_locked = tweak_data.lootdrop.global_values[new_data.global_value].unlock_id or "bm_menu_dlc_locked"
		else
			local event_job_challenge = managers.event_jobs:get_challenge_from_reward("weapon_mods", new_data.name)

			if event_job_challenge and not event_job_challenge.completed then
				new_data.unlocked = type(new_data.unlocked) == "number" and -math.abs(new_data.unlocked) or new_data.unlocked
				new_data.lock_texture = "guis/textures/pd2/lock_achievement"
				new_data.dlc_locked = event_job_challenge.locked_id or "menu_event_job_lock_info"
			end
		end

		local weapon_id = managers.blackmarket:get_crafted_category(new_data.category)[new_data.slot].weapon_id
		new_data.price = part_is_from_cosmetic and 0 or managers.money:get_weapon_modify_price(weapon_id, new_data.name, new_data.global_value)
		new_data.can_afford = part_is_from_cosmetic or managers.money:can_afford_weapon_modification(weapon_id, new_data.name, new_data.global_value)
		local font, font_size = nil
		local no_upper = false

		if crafted.previewing then
			new_data.previewing = true
			new_data.corner_text = {
				selected_text = managers.localization:text("bm_menu_mod_preview")
			}
			new_data.corner_text.noselected_text = new_data.corner_text.selected_text
			new_data.corner_text.noselected_color = Color.white
		elseif not new_data.lock_texture and (not new_data.unlocked or new_data.unlocked == 0) then
			if managers.dlc:is_content_achievement_locked("weapon_mods", new_data.name) or managers.dlc:is_content_achievement_milestone_locked("weapon_mods", new_data.name) then
				new_data.lock_texture = "guis/textures/pd2/lock_achievement"
			elseif managers.dlc:is_content_skirmish_locked("weapon_mods", new_data.name) then
				new_data.lock_texture = "guis/textures/pd2/skilltree/padlock"
			elseif managers.dlc:is_content_crimespree_locked("weapon_mods", new_data.name) then
				new_data.lock_texture = "guis/textures/pd2/skilltree/padlock"
			elseif managers.dlc:is_content_infamy_locked("weapon_mods", new_data.name) then
				new_data.lock_texture = "guis/textures/pd2/lock_infamy"
				new_data.dlc_locked = "menu_infamy_lock_info"
			else
				local event_job_challenge = managers.event_jobs:get_challenge_from_reward("weapon_mods", new_data.name)

				if event_job_challenge and not event_job_challenge.completed then
					new_data.unlocked = -math.abs(new_data.unlocked)
					new_data.lock_texture = "guis/textures/pd2/lock_achievement"
					new_data.dlc_locked = event_job_challenge.locked_id or "menu_event_job_lock_info"
				else
					local selected_text = managers.localization:text("bm_menu_no_items")
					new_data.corner_text = {
						selected_text = selected_text,
						noselected_text = selected_text
					}
				end
			end
		elseif new_data.unlocked and not new_data.can_afford then
			new_data.corner_text = {
				selected_text = managers.localization:text("bm_menu_not_enough_cash")
			}
			new_data.corner_text.noselected_text = new_data.corner_text.selected_text
		end

		local forbid = nil

		if mod_name then
			forbid = managers.blackmarket:can_modify_weapon(new_data.category, new_data.slot, new_data.name)

			if forbid then
				if type(new_data.unlocked) == "number" then
					new_data.unlocked = -math.abs(new_data.unlocked)
				else
					new_data.unlocked = false
				end

				new_data.lock_texture = self:get_lock_icon(new_data, "guis/textures/pd2/lock_incompatible")
				new_data.mid_text = nil
				new_data.conflict = managers.localization:text("bm_menu_" .. tostring(tweak_data.weapon.factory.parts[forbid] and tweak_data.weapon.factory.parts[forbid].type or forbid))
			end

			local replaces, removes = managers.blackmarket:get_modify_weapon_consequence(new_data.category, new_data.slot, new_data.name)
			new_data.removes = removes or {}
			local weapon = managers.blackmarket:get_crafted_category_slot(data.prev_node_data.category, data.prev_node_data.slot) or {}
			local gadget = nil
			local mod_td = tweak_data.weapon.factory.parts[new_data.name]
			local mod_type = mod_td.type
			local sub_type = mod_td.sub_type
			local is_auto = weapon and tweak_data.weapon[weapon.weapon_id] and tweak_data.weapon[weapon.weapon_id].FIRE_MODE == "auto"

			if mod_type == "gadget" then
				gadget = sub_type
			end

			local silencer = sub_type == "silencer" and true
			local texture = managers.menu_component:get_texture_from_mod_type(mod_type, sub_type, gadget, silencer, is_auto)
			new_data.desc_mini_icons = {}

			if DB:has(Idstring("texture"), texture) then
				table.insert(new_data.desc_mini_icons, {
					h = 16,
					w = 16,
					bottom = 0,
					right = 0,
					texture = texture
				})
			end

			local is_gadget = false
			local show_stats = not new_data.conflict and new_data.unlocked and not is_gadget and not new_data.dlc_locked and tweak_data.weapon.factory.parts[new_data.name].type ~= "charm"

			if show_stats then
				new_data.comparision_data = managers.blackmarket:get_weapon_stats_with_mod(new_data.category, new_data.slot, mod_name)
			end

			if managers.blackmarket:got_new_drop(mod_global_value, "weapon_mods", mod_name) then
				new_data.mini_icons = new_data.mini_icons or {}

				table.insert(new_data.mini_icons, {
					texture = "guis/textures/pd2/blackmarket/inv_newdrop",
					name = "new_drop",
					h = 16,
					w = 16,
					top = 0,
					layer = 1,
					stream = false,
					right = 0
				})

				new_data.new_drop_data = {
					new_data.global_value or "normal",
					"weapon_mods",
					mod_name
				}
			end
		end

		local active = true
		local can_apply = not crafted.previewing
		local preview_forbidden = managers.blackmarket:is_previewing_legendary_skin() or managers.blackmarket:preview_mod_forbidden(new_data.category, new_data.slot, new_data.name)

		if mod_name and not crafted.customize_locked and active then
			if new_data.unlocked and (type(new_data.unlocked) ~= "number" or new_data.unlocked > 0) and can_apply then
				if new_data.can_afford then
					table.insert(new_data, "wm_buy")
				end

				if managers.blackmarket:is_previewing_any_mod() then
					table.insert(new_data, "wm_clear_mod_preview")
				end

				if not new_data.is_internal and not preview_forbidden then
					if managers.blackmarket:is_previewing_mod(new_data.name) then
						table.insert(new_data, "wm_remove_preview")
					else
						table.insert(new_data, "wm_preview_mod")
					end
				end
			else
				local dlc_data = Global.dlc_manager.all_dlc_data[new_data.global_value]

				if dlc_data and dlc_data.app_id and not dlc_data.external and not managers.dlc:is_dlc_unlocked(new_data.global_value) then
					table.insert(new_data, "bw_buy_dlc")
				end

				if managers.blackmarket:is_previewing_any_mod() then
					table.insert(new_data, "wm_clear_mod_preview")
				end

				if not new_data.is_internal and not preview_forbidden then
					if managers.blackmarket:is_previewing_mod(new_data.name) then
						table.insert(new_data, "wm_remove_preview")
					else
						table.insert(new_data, "wm_preview_mod")
					end
				end
			end

			if managers.workshop and managers.workshop:enabled() and not table.contains(managers.blackmarket:skin_editor():get_excluded_weapons(), weapon_id) then
				table.insert(new_data, "w_skin")
			end

			if new_data.unlocked and not new_data.dlc_locked then
				local weapon_mod_tweak = tweak_data.weapon.factory.parts[mod_name]

				if weapon_mod_tweak and weapon_mod_tweak.is_a_unlockable ~= true and can_apply and managers.custom_safehouse:unlocked() then
					table.insert(new_data, "wm_buy_mod")
				end
			end
		end

		data[index] = new_data
	end

	for i = 1, math.max(math.ceil(num_steps / WEAPON_MODS_SLOTS[1]), WEAPON_MODS_SLOTS[2]) * WEAPON_MODS_SLOTS[1] do
		if not data[i] then
			new_data = {
				name = "empty",
				name_localized = "",
				category = data.category,
				slot = i,
				unlocked = true,
				equipped = false
			}
			data[i] = new_data
		end
	end

	local weapon_blueprint = managers.blackmarket:get_weapon_blueprint(data.prev_node_data.category, data.prev_node_data.slot) or {}
	local equipped = nil

	local function update_equipped()
		if equipped then
			data[equipped].equipped = true
			data[equipped].unlocked = not crafted.customize_locked and (data[equipped].unlocked or true)
			data[equipped].mid_text = crafted.customize_locked and data[equipped].mid_text or nil
			data[equipped].lock_texture = crafted.customize_locked and data[equipped].lock_texture or nil
			data[equipped].corner_text = crafted.customize_locked and data[equipped].corner_text or nil

			for i = 1, #data[equipped] do
				table.remove(data[equipped], 1)
			end

			data[equipped].price = 0
			data[equipped].can_afford = true

			if not crafted.customize_locked then
				table.insert(data[equipped], "wm_remove_buy")

				if not data[equipped].is_internal then
					local preview_forbidden = managers.blackmarket:is_previewing_legendary_skin() or managers.blackmarket:preview_mod_forbidden(data[equipped].category, data[equipped].slot, data[equipped].name)

					if managers.blackmarket:is_previewing_any_mod() then
						table.insert(data[equipped], "wm_clear_mod_preview")
					end

					if managers.blackmarket:is_previewing_mod(data[equipped].name) then
						table.insert(data[equipped], "wm_remove_preview")
					elseif not preview_forbidden then
						table.insert(data[equipped], "wm_preview_mod")
					end
				else
					table.insert(data[equipped], "wm_preview")
				end

				if managers.workshop and managers.workshop:enabled() and data.prev_node_data and not table.contains(managers.blackmarket:skin_editor():get_excluded_weapons(), data.prev_node_data.name) then
					table.insert(data[equipped], "w_skin")
				end

				local weapon_mod_tweak = tweak_data.weapon.factory.parts[data[equipped].name]

				if weapon_mod_tweak and weapon_mod_tweak.type ~= "bonus" and weapon_mod_tweak.is_a_unlockable ~= true and managers.custom_safehouse:unlocked() then
					table.insert(data[equipped], "wm_buy_mod")
				end
			end

			local factory = tweak_data.weapon.factory.parts[data[equipped].name]
			local is_correct_type = data.name == "sight" or data.name == "gadget"
			is_correct_type = is_correct_type or data.name == "second_sight"

			if is_correct_type and factory and factory.texture_switch then
				if not crafted.customize_locked then
					table.insert(data[equipped], "wm_reticle_switch_menu")
				end

				local reticle_texture = managers.blackmarket:get_part_texture_switch(data[equipped].category, data[equipped].slot, data[equipped].name)

				if reticle_texture and reticle_texture ~= "" then
					data[equipped].mini_icons = data[equipped].mini_icons or {}

					table.insert(data[equipped].mini_icons, {
						layer = 2,
						h = 30,
						stream = true,
						w = 30,
						blend_mode = "normal",
						bottom = 1,
						right = 1,
						texture = reticle_texture
					})
				end
			end

			local gmod_name = data[equipped].name
			local gmod_td = tweak_data.weapon.factory.parts[gmod_name]
			local has_customizable_gadget = (data.name == "gadget" or table.contains(gmod_td.perks or {}, "gadget")) and (gmod_td.sub_type == "laser" or gmod_td.sub_type == "flashlight")

			if not has_customizable_gadget and gmod_td.adds then
				for _, part_id in ipairs(gmod_td.adds) do
					local sub_type = tweak_data.weapon.factory.parts[part_id].sub_type

					if sub_type == "laser" or sub_type == "flashlight" then
						has_customizable_gadget = true

						break
					end
				end
			end

			if has_customizable_gadget then
				if not crafted.customize_locked then
					table.insert(data[equipped], "wm_customize_gadget")
				end

				local secondary_sub_type = false

				if gmod_td.adds then
					for _, part_id in ipairs(gmod_td.adds) do
						local sub_type = tweak_data.weapon.factory.parts[part_id].sub_type

						if sub_type == "laser" or sub_type == "flashlight" then
							secondary_sub_type = sub_type

							break
						end
					end
				end

				local colors = managers.blackmarket:get_part_custom_colors(data[equipped].category, data[equipped].slot, gmod_name)

				if colors then
					data[equipped].mini_colors = {}

					if gmod_td.sub_type then
						table.insert(data[equipped].mini_colors, {
							alpha = 0.8,
							blend = "normal",
							color = colors[gmod_td.sub_type] or Color(1, 0, 1)
						})
					end

					if secondary_sub_type then
						table.insert(data[equipped].mini_colors, {
							alpha = 0.8,
							blend = "normal",
							color = colors[secondary_sub_type] or Color(1, 0, 1)
						})
					end
				end
			end

			if not data[equipped].conflict then
				if false then
					if data[equipped].default_mod then
						data[equipped].comparision_data = managers.blackmarket:get_weapon_stats_with_mod(data[equipped].category, data[equipped].slot, data[equipped].default_mod)
					else
						data[equipped].comparision_data = managers.blackmarket:get_weapon_stats_without_mod(data[equipped].category, data[equipped].slot, data[equipped].name)
					end
				end
			end
		end
	end

	for i, mod in ipairs(data) do
		for _, weapon_mod in ipairs(weapon_blueprint) do
			if mod.name == weapon_mod and (not global_values[weapon_mod] or global_values[weapon_mod] == data[i].global_value) then
				equipped = i

				break
			end
		end
	end

	update_equipped()
end