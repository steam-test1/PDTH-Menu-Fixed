
require("lib/managers/menu/renderers/MenuNodeBaseGui")
local make_fine_text = function(text)
	local x, y, w, h = text:text_rect()
	text:set_size(w, h)
	text:set_position(math.round(text:x()), math.round(text:y()))
end

CloneClass(MenuNodeGui)
function MenuNodeCrimenetGui:init(node, layer, parameters)
	parameters.font = tweak_data.menu.pd2_small_font
	parameters.font_size = tweak_data.menu.pd2_small_font_size
	parameters.align = "left"
	parameters.row_item_blend_mode = "normal"
	parameters.row_item_color = PDTHMenu_color_normal
	parameters.row_item_hightlight_color = PDTHMenu_color_highlight
	parameters.marker_alpha = 1
	parameters._align_line_proportions = 0.75
	parameters.to_upper = true
	MenuNodeCrimenetGui.super.init(self, node, layer, parameters)
end

MenuNodeCrimenetFiltersGui = MenuNodeCrimenetFiltersGui or class(MenuNodeGui)
function MenuNodeCrimenetFiltersGui:init(node, layer, parameters)
	parameters.font = tweak_data.menu.pd2_small_font
	parameters.font_size = tweak_data.menu.pd2_small_font_size
	parameters.align = "left"
	parameters.row_item_blend_mode = "normal"
	parameters.row_item_color = PDTHMenu_color_normal
	parameters.row_item_hightlight_color = PDTHMenu_color_highlight
	parameters.marker_alpha = 1
	parameters._align_line_proportions = 0.5
	parameters.to_upper = true
	self.static_y = node:parameters().static_y
	MenuNodeCrimenetFiltersGui.super.init(self, node, layer, parameters)
end


MenuNodeCrimenetSpecialGui = MenuNodeCrimenetSpecialGui or class(MenuNodeCrimenetFiltersGui)
function MenuNodeCrimenetSpecialGui:_setup_item_panel(safe_rect, res)
	MenuNodeCrimenetSpecialGui.super._setup_item_panel(self, safe_rect, res)
	if alive(self.item_panel:parent():child("special_title_text")) then
		self.item_panel:parent():remove(self.item_panel:parent():child("special_title_text"))
	end
	local title_text = self.item_panel:parent():text({
		name = "special_title_text",
		text = managers.localization:to_upper_text("menu_cn_contract_broker_title"),
		font = tweak_data.menu.pd2_medium_font,
		font_size = tweak_data.menu.pd2_medium_font_size - 5,
		color = tweak_data.screen_colors.text,
		blend_mode = "normal",
		layer = 51
	})
	make_fine_text(title_text)
	title_text:set_left(self.box_panel:left())
	title_text:set_bottom(self.box_panel:top())
end

MenuNodeCrimenetCasinoGui = MenuNodeCrimenetCasinoGui or class(MenuNodeGui)
function MenuNodeCrimenetCasinoGui:init(node, layer, parameters)
	parameters.font = tweak_data.menu.pd2_small_font
	parameters.font_size = tweak_data.menu.pd2_small_font_size
	parameters.align = "left"
	parameters.row_item_blend_mode = "normal"
	parameters.row_item_color = PDTHMenu_color_normal
	parameters.row_item_hightlight_color = PDTHMenu_color_highlight
	parameters.marker_alpha = 1
	parameters._align_line_proportions = 0.5
	parameters.to_upper = true
	MenuNodeCrimenetCasinoGui.super.init(self, node, layer, parameters)
	self:_setup_layout()
end



function MenuNodeCrimenetCasinoGui:_setup_layout()
	local parent_layer = managers.menu:active_menu().renderer:selected_node():layer()
	self._panel = self.ws:panel():panel({
		layer = parent_layer + 1
	})
	local width, height, space_x, space_y, start_x = self:_get_sizes(self._panel:w(), self._panel:h())
	local large_font = tweak_data.menu.pd2_large_font
	local medium_font = tweak_data.menu.pd2_medium_font
	local small_font = tweak_data.menu.pd2_small_font
	local large_font_size = tweak_data.menu.pd2_large_font_size
	local medium_font_size = tweak_data.menu.pd2_medium_font_size
	local small_font_size = tweak_data.menu.pd2_small_font_size
	local option_size = self._panel:w() * (1 - self._align_line_proportions)
	local content_offset = 20
	local text_title = self._panel:text({
		text = managers.localization:to_upper_text("menu_casino_title_main"),
		font_size = large_font_size,
		font = large_font,
		color = tweak_data.screen_colors.text,
		blend_mode = "normal"
	})
	local _, _, w, h = text_title:text_rect()
	self._main_panel = self._panel:panel({
		x = 0,
		y = h,
		w = self._panel:w(),
		h = self._panel:h() - h
	})
	local text_betting = self._main_panel:text({
		text = managers.localization:to_upper_text("menu_casino_title_betting"),
		font_size = medium_font_size,
		font = medium_font,
		color = tweak_data.screen_colors.text,
		blend_mode = "normal"
	})
	text_betting:set_position(start_x, 0)
	local _, _, _, h = text_betting:text_rect()
	text_betting:set_h(h)
	self._betting_panel = self._main_panel:panel({
		y = text_betting:bottom(),
		w = width,
		h = height,
		layer = 1
	})
	self._betting_panel:set_x(text_betting:x())
	BoxGuiObject:new(self._betting_panel, {
		sides = {
			1,
			1,
			1,
			1
		}
	})
	local text_options = self._main_panel:panel({
		w = width - option_size,
		h = self.item_panel:h(),
		layer = 1
	})
	text_options:set_x(self._betting_panel:x())
	text_options:set_y(self.item_panel:y())
	local betting_titles = {
		{
			id = "prefer",
			text = "menu_casino_option_prefer_title"
		},
		{
			id = "infamous",
			text = "menu_casino_option_infamous_title"
		},
		{
			id = "safecards",
			text = "menu_casino_option_safecard_title"
		},
		{skip = true},
		{skip = true}
	}
	self._betting_titles = {}
	local i = 1
	local y = 0
	for _, item in ipairs(self.row_items) do
		if item.type ~= "divider" then
			if not betting_titles[i].skip then
				self._betting_titles[betting_titles[i].id] = text_options:text({
					text = managers.localization:to_upper_text(betting_titles[i].text),
					y = y,
					align = "right",
					font_size = small_font_size,
					font = small_font,
					color = tweak_data.screen_colors.text,
					blend_mode = "normal"
				})
			end
			i = i + 1
		end
		y = y + item.gui_panel:h()
	end
	self._betting_carddeck = {
		none = "downcard_overkill_deck",
		weapon_mods = "upcard_weapon",
		masks = "upcard_mask",
		materials = "upcard_material",
		textures = "upcard_pattern",
		colors = "upcard_color",
		cash = "upcard_cash",
		xp = "upcard_xp"
	}
	self._betting_cards_panel = self._betting_panel:panel({
		x = content_offset,
		y = content_offset + 15,
		w = self._betting_panel:w() - content_offset * 2,
		layer = 1
	})
	self._betting_cards_panel:set_h((self.item_panel:y() - content_offset * 2) * 0.6)
	local texture, rect, coords = tweak_data.hud_icons:get_icon_data(self._betting_carddeck.none)
	self._betting_cards = {}
	for i = 1, 3 do
		self._betting_cards[i] = self._betting_cards_panel:bitmap({
			name = "upcard",
			texture = texture,
			w = math.round(0.7111111 * self._betting_cards_panel:h()),
			h = self._betting_cards_panel:h(),
			blend_mode = "normal",
			layer = 1,
			halign = "scale",
			valign = "scale"
		})
		self._betting_cards[i]:set_rotation(math.random(14) - 7)
		self._betting_cards[i]:set_visible(MenuCallbackHandler:casino_betting_visible())
	end
	self:_set_cards(0)
	self._stats_panel = self._main_panel:panel({
		x = text_betting:x(),
		y = text_betting:bottom(),
		w = width,
		h = height / 2 - space_y / 2,
		layer = 1
	})
	self._stats_panel:set_x(self._betting_panel:right() + space_x)
	BoxGuiObject:new(self._stats_panel, {
		sides = {
			1,
			1,
			1,
			1
		}
	})
	local text_stats = self._main_panel:text({
		text = managers.localization:to_upper_text("menu_casino_title_stats"),
		font_size = medium_font_size,
		font = medium_font,
		color = tweak_data.screen_colors.text,
		blend_mode = "normal"
	})
	local _, _, _, h = text_stats:text_rect()
	text_stats:set_h(h)
	text_stats:set_x(self._stats_panel:x())
	text_stats:set_bottom(self._betting_panel:top())
	self._stats_cards = {
		"weapon_mods",
		"masks",
		"materials",
		"textures",
		"colors"
	}
	local stat_columns = {
		{
			name = "base",
			color = Color(0.5, 0.5, 0.5),
			color_inf = Color(1, 0.1, 1)
		},
		{
			name = "bets",
			color = tweak_data.screen_colors.risk
		},
		{
			name = "skill",
			color = tweak_data.screen_colors.resource
		},
		{
			name = "total",
			color = tweak_data.screen_colors.text,
			color_inf = Color(1, 0.1, 1)
		}
	}
	self._stat_values = {}
	local title_width = 150
	local column_width = 70
	local text_panel
	local x = title_width + column_width * 0.55
	local y = content_offset
	for _, column in pairs(stat_columns) do
		self._stats_panel:text({
			text = managers.localization:to_upper_text("menu_casino_stat_" .. column.name),
			x = x,
			y = y,
			font_size = small_font_size,
			font = small_font,
			color = column.color or tweak_data.screen_colors.text,
			blend_mode = "normal"
		})
		x = x + column_width
	end
	y = content_offset + small_font_size + 10
	for _, stat in pairs(self._stats_cards) do
		self._stat_values[stat] = {}
		x = title_width
		for _, column in pairs(stat_columns) do
			text_panel = self._stats_panel:panel({
				layer = 1,
				x = x,
				y = y,
				w = column_width,
				h = small_font_size
			})
			self._stat_values[stat][column.name] = text_panel:text({
				align = "right",
				font_size = small_font_size,
				font = small_font,
				color = column.color or tweak_data.screen_colors.text,
				blend_mode = "normal",
				alpha = 1
			})
			x = x + column_width
		end
		y = y + small_font_size
	end
	y = content_offset + small_font_size + 10
	for _, stat in pairs(self._stats_cards) do
		text_panel = self._stats_panel:panel({
			layer = 1,
			x = 0,
			y = y,
			w = title_width,
			h = small_font_size
		})
		self._stat_values[stat].title = text_panel:text({
			text = managers.localization:to_upper_text("menu_casino_stat_" .. stat),
			font_size = small_font_size,
			font = small_font,
			align = "right",
			color = tweak_data.screen_colors.text,
			blend_mode = "normal",
			alpha = 1
		})
		y = y + small_font_size
	end
	self._infamous_values = {}
	y = y + small_font_size
	text_panel = self._stats_panel:panel({
		layer = 1,
		x = 0,
		y = y,
		w = title_width,
		h = small_font_size
	})
	text_panel:text({
		text = managers.localization:to_upper_text("bm_global_value_infamous"),
		font_size = small_font_size,
		font = small_font,
		align = "right",
		color = Color(1, 0.1, 1),
		blend_mode = "normal"
	})
	x = title_width
	for _, column in pairs(stat_columns) do
		text_panel = self._stats_panel:panel({
			layer = 1,
			x = x,
			y = y,
			w = column_width,
			h = small_font_size
		})
		self._infamous_values[column.name] = text_panel:text({
			align = "right",
			font_size = small_font_size,
			font = small_font,
			color = column.color_inf or column.color or tweak_data.screen_colors.text,
			blend_mode = "normal",
			alpha = column.alpha or 1
		})
		x = x + column_width
	end
	local stars = managers.experience:level_to_stars()
	local item_pc = tweak_data.lootdrop.STARS[stars].pcs[1]
	local skip_types = {cash = true, xp = true}
	local droppable_items = managers.lootdrop:droppable_items(item_pc, true, skip_types)
	local pc = stars * 10
	local weighted_type_chance = tweak_data.lootdrop.WEIGHTED_TYPE_CHANCE[pc]
	local sum = 0
	for type, items in pairs(droppable_items) do
		sum = sum + weighted_type_chance[type]
	end
	self._base_chances = {}
	for _, item in pairs(self._stats_cards) do
		self._base_chances[item] = 0
	end
	for type, items in pairs(droppable_items) do
		self._base_chances[type] = self:_round_value(weighted_type_chance[type] / sum * 100)
	end
	for _, stat in pairs(self._stats_cards) do
		local value = string.format("%.1f", self._base_chances[stat])
		self._stat_values[stat].base:set_text(value .. "%")
		self._stat_values[stat].total:set_text(value .. "%")
	end
	local items_total = 0
	local items_infamous = 0
	for type, items in pairs(droppable_items) do
		items_total = items_total + #items
		for _, item in pairs(items) do
			if item.global_value == "infamous" then
				items_infamous = items_infamous + 1
			end
		end
	end
	local _, infamous_base_chance, infamous_mod = managers.lootdrop:infamous_chance()
	local infamous_chance = items_total > 0 and infamous_base_chance * (items_infamous / items_total) or 0
	self._infamous_chance = {}
	self._infamous_chance.base = infamous_chance
	self._infamous_chance.skill = infamous_mod
	local value = self:_round_value(infamous_chance * 100)
	local skill = self:_round_value((infamous_chance * infamous_mod - infamous_chance) * 100)
	self._infamous_chance.value_base = value
	self._infamous_chance.value_skill = skill
	self._infamous_values.base:set_text(string.format("%.1f", value) .. "%")
	self._infamous_values.skill:set_text(infamous_mod > 1 and "+" .. string.format("%.1f", skill) .. "%" or "")
	self._infamous_values.total:set_text(string.format("%.1f", value + skill) .. "%")
	self._breakdown_panel = self._main_panel:panel({
		w = width,
		h = self._betting_panel:h() - self._stats_panel:h() - space_y,
		layer = 1
	})
	self._breakdown_panel:set_x(self._stats_panel:x())
	self._breakdown_panel:set_top(self._stats_panel:bottom() + space_y)
	BoxGuiObject:new(self._breakdown_panel, {
		sides = {
			1,
			1,
			1,
			1
		}
	})
	local text_breakdown = self._main_panel:text({
		text = managers.localization:to_upper_text("menu_casino_title_breakdown"),
		font_size = medium_font_size,
		font = medium_font,
		color = tweak_data.screen_colors.text,
		blend_mode = "normal"
	})
	local _, _, _, h = text_breakdown:text_rect()
	text_breakdown:set_h(h)
	text_breakdown:set_x(self._breakdown_panel:x())
	text_breakdown:set_bottom(self._breakdown_panel:top())
	self._breakdown_titles = self._breakdown_panel:text({
		x = content_offset,
		y = content_offset,
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.text,
		blend_mode = "normal"
	})
	self._breakdown_costs = self._breakdown_panel:text({
		x = self._breakdown_panel:w() * 0.4,
		y = content_offset,
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.risk,
		blend_mode = "normal"
	})
	self._offshore_text = self._main_panel:text({
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.text,
		blend_mode = "normal"
	})
	self:set_offshore_text()
	local _, _, w, h = self._offshore_text:text_rect()
	self._offshore_text:set_h(h)
	self._offshore_text:set_x(self._betting_panel:x())
	self._offshore_text:set_y(self._betting_panel:bottom() + h + 16)
	local secured_cards = 0
	local increase_infamous = false
	local preferred_card = "none"
	local text_string = managers.localization:to_upper_text("menu_casino_total_bet", {
		casino_bet = managers.experience:cash_string(managers.money:get_cost_of_casino_fee(secured_cards, increase_infamous, preferred_card))
	})
	self._total_bet = self._panel:text({
		text = text_string,
		font_size = large_font_size,
		font = large_font,
		color = tweak_data.screen_colors.text,
		blend_mode = "normal",
		align = "right"
	})
	local _, _, _, h = self._total_bet:text_rect()
	self._total_bet:set_h(h)
	self._total_bet:set_right(self._breakdown_panel:right())
	self._total_bet:set_y(self._betting_panel:bottom() + h + 16)
	self:set_update_values(preferred_card, secured_cards, increase_infamous, false, false)
end

function MenuNodeCrimenetCasinoGui:set_update_values(preferred_card, secured_cards, increase_infamous, infamous_enabled, safecards_enabled)
	local breakdown_titles = managers.localization:to_upper_text("menu_casino_cost_fee") .. ":"
	local breakdown_costs = managers.experience:cash_string(managers.money:get_cost_of_casino_entrance())
	if preferred_card ~= "none" then
		breakdown_titles = breakdown_titles .. "\n" .. managers.localization:to_upper_text("menu_casino_option_prefer_title") .. ":"
		breakdown_costs = breakdown_costs .. "\n" .. managers.experience:cash_string(tweak_data:get_value("casino", "prefer_cost"))
	end
	if increase_infamous then
		breakdown_titles = breakdown_titles .. "\n" .. managers.localization:to_upper_text("menu_casino_option_infamous_title") .. ":"
		breakdown_costs = breakdown_costs .. "\n" .. managers.experience:cash_string(tweak_data:get_value("casino", "infamous_cost"))
	end
	if secured_cards > 0 then
		breakdown_titles = breakdown_titles .. "\n" .. managers.localization:to_upper_text("menu_casino_option_safecard_title") .. ":"
		for i = 1, secured_cards do
			breakdown_costs = breakdown_costs .. "\n" .. managers.experience:cash_string(tweak_data:get_value("casino", "secure_card_cost", i))
		end
	end
	self._breakdown_titles:set_text(breakdown_titles)
	self._breakdown_costs:set_text(breakdown_costs)
	local text_string = managers.localization:to_upper_text("menu_casino_total_bet", {
		casino_bet = managers.experience:cash_string(managers.money:get_cost_of_casino_fee(secured_cards, increase_infamous, preferred_card))
	})
	self._total_bet:set_text(text_string)
	local nbr_types = 0
	for _, card in pairs(self._stats_cards) do
		for _, item in pairs(self._stat_values[card]) do
			item:set_alpha((secured_cards == 0 or preferred_card == "none") and 1 or 0.5)
		end
		nbr_types = nbr_types + ((0 < self._base_chances[card] or card == preferred_card) and 1 or 0)
	end
	if preferred_card == "none" then
		for _, card in pairs(self._stats_cards) do
			self._stat_values[card].bets:set_text("")
			self._stat_values[card].total:set_text(string.format("%.1f", self._base_chances[card]) .. "%")
		end
		self:_set_cards(0)
	elseif nbr_types > 1 then
		local secured_value = 100 * secured_cards
		local preferred_chance = tweak_data:get_value("casino", "prefer_chance") * 100 * (3 - secured_cards)
		local preferred_left = preferred_chance / (nbr_types - 1)
		for _, card in pairs(self._stats_cards) do
			local non_secured_value = self._base_chances[card] * (3 - secured_cards)
			if preferred_card ~= "none" then
				non_secured_value = non_secured_value + (card == preferred_card and preferred_chance or -preferred_left)
				if non_secured_value < 0 then
					non_secured_value = 0
				end
			end
			local value = (non_secured_value + (card == preferred_card and secured_value or 0)) / 3 - self._base_chances[card]
			value = self:_round_value(value)
			if value ~= 0 or not "" then
				if not (value > 0) or not ("+" .. string.format("%.1f", value)) then
				end
			end
			self._stat_values[card].bets:set_text(string.format("%.1f", value) .. "%")
			self._stat_values[card].total:set_text(string.format("%.1f", value + self._base_chances[card]) .. "%")
			if card == preferred_card then
				for _, item in pairs(self._stat_values[card]) do
					item:set_alpha(1)
				end
			end
		end
		self:_set_cards(secured_cards, secured_cards > 0 and self._betting_carddeck[preferred_card])
	end
	local base_value = self._infamous_chance.value_base + self._infamous_chance.value_skill
	local bets_value = increase_infamous and self:_round_value(base_value * tweak_data:get_value("casino", "infamous_chance") - base_value) or 0
	self._infamous_values.bets:set_text(increase_infamous and "+" .. string.format("%.1f", bets_value) .. "%" or "")
	self._infamous_values.total:set_text(string.format("%.1f", base_value + bets_value) .. "%")
	if self._betting_titles.safecards then
		self._betting_titles.safecards:set_alpha(safecards_enabled and 1 or 0.5)
	end
	if self._betting_titles.infamous then
		self._betting_titles.infamous:set_alpha(infamous_enabled and 1 or 0.5)
	end
end


MenuNodeCrimenetContactInfoGui = MenuNodeCrimenetContactInfoGui or class(MenuNodeGui)
MenuNodeCrimenetContactInfoGui.WIDTH = 600
MenuNodeCrimenetContactInfoGui.HEIGHT = 465
MenuNodeCrimenetContactInfoGui.MENU_WIDTH = 220
MenuNodeCrimenetContactInfoGui.PADDING = 10
MenuNodeCrimenetContactInfoGui.CODEX_TEXT_ID = "menu_contact_info_title"
MenuNodeCrimenetContactInfoGui.SOUND_SOURCE_NAME = "MenuNodeCrimenetContactInfoGui"
function MenuNodeCrimenetContactInfoGui:init(node, layer, parameters)
	parameters.font = tweak_data.menu.pd2_small_font
	parameters.font_size = tweak_data.menu.pd2_small_font_size
	parameters.align = "left"
	parameters.row_item_blend_mode = "normal"
	parameters.row_item_color = PDTHMenu_color_normal
	parameters.row_item_hightlight_color = PDTHMenu_color_highlight
	parameters.marker_alpha = 1
	parameters.to_upper = true
	parameters._align_line_proportions = 0.65
	self._codex_text = managers.localization:to_upper_text(self.CODEX_TEXT_ID)
	self._current_file = 0
	self._sound_source = SoundDevice:create_source(self.SOUND_SOURCE_NAME)
	local active_menu = managers.menu:active_menu()
	if active_menu then
		active_menu.input:set_force_input(true)
	end
	self._file_icons = {}
	self._file_icons.selected = {
		0,
		0,
		17,
		23
	}
	self._file_icons.unselected = {
		20,
		0,
		17,
		23
	}
	self._file_icons.locked = {
		40,
		0,
		17,
		23
	}
	MenuNodeCrimenetContactInfoGui.super.init(self, node, layer, parameters)
	managers.menu_component:disable_crimenet()
	self:_setup_layout()
	if not managers.menu:is_pc_controller() then
		managers.menu:active_menu().input:deactivate_controller_mouse()
	end
end

function MenuNodeCrimenetContactInfoGui:set_contact_info(id, name, files, override_file)
	self._files = files
	local files_menu = self._files_menu
	local num_files = #files
	files_menu:clear()
	if num_files > 1 then
		files_menu:set_h(26)
		local size = files_menu:h() - 4
		for i = 1, num_files do
			local is_locked = self._files[i] and self:is_file_locked(self._files[i].lock)
			local texture_rect = is_locked and self._file_icons.locked or self._file_icons.unselected
			files_menu:bitmap({
				texture = "guis/textures/pd2/codex_pages",
				texture_rect = texture_rect,
				x = (i - 1) * 20,
				y = 0,
				w = 17,
				h = 23
			})
		end
	else
		files_menu:set_h(0)
	end
	local contact_desc_text = self._panel:child("contact_desc_text")
	contact_desc_text:set_top(files_menu:bottom())
	local contact_title_text = self._panel:child("contact_title_text")
	contact_title_text:set_text(self._codex_text .. ": " .. name)
	make_fine_text(contact_title_text)
	local contact_desc_title_text = self._panel:child("contact_desc_title_text")
	contact_desc_title_text:set_text(self._codex_text .. ": " .. name)
	make_fine_text(contact_desc_title_text)
	self:set_file(override_file)
	self._current_contact_info = id
end

function MenuNodeCrimenetContactInfoGui:set_empty()
	local video_panel = self._panel:child("video_panel")
	if video_panel and alive(video_panel:child("video")) then
		video_panel:remove(video_panel:child("video"))
	end
	local contact_desc_text = self._panel:child("contact_desc_text")
	contact_desc_text:set_text("")
end

function MenuNodeCrimenetContactInfoGui:set_file(index)
	self:set_empty()
	if self._files[index] and self:is_file_locked(self._files[index].lock) then
		local i = 1
		local num_files = self._files and #self._files or 0
		while self:is_file_locked(self._files[i].lock) do
			i = i + 1
			if num_files < i then
				return
			end
		end
		index = i
	end
	self._current_file = index or 1
	self:_set_file()
end

function MenuNodeCrimenetContactInfoGui:_set_file()
	local file = self._files[self._current_file]
	local desc_id = file.desc_lozalized
	local video = file.videos and file.videos[math.random(#file.videos)]
	local post_event = file.post_event
	local lock = file.lock
	local contact_desc_text = self._panel:child("contact_desc_text")
	contact_desc_text:set_text(desc_id)
	self._sound_source:stop()
	if post_event then
		self._sound_source:post_event(post_event)
	end
	local video_panel = self._panel:child("video_panel")
	if video then
		video_panel:video({
			name = "video",
			video = "movies/codex/" .. video,
			width = video_panel:w(),
			height = video_panel:h(),
			blend_mode = "normal",
			loop = true,
			color = tweak_data.screen_colors.button_stage_2
		})
	end
	local files_menu = self._files_menu
	for i, file in ipairs(files_menu:children()) do
		local is_locked = self:is_file_locked(self._files[i].lock)
		local texture_rect = is_locked and self._file_icons.locked or i == self._current_file and self._file_icons.selected or self._file_icons.unselected
		file:set_texture_rect(unpack(texture_rect))
	end
end

function MenuNodeCrimenetContactInfoGui:gui_node_custom(row_item)
	row_item.gui_panel = self._item_panel_parent:panel({
		layer = self.layers.items,
		w = 3,
		h = 3
	})
	row_item.gui_pd2_panel = self.ws:panel():panel({
		layer = self.layers.items
	})
	local row_item_panel = row_item.gui_pd2_panel
	row_item.gui_text = row_item_panel:text({
		font_size = tweak_data.menu.pd2_small_font_size,
		x = 0,
		y = 0,
		align = "left",
		vertical = "bottom",
		font = tweak_data.menu.pd2_small_font,
		color = Color.white,
		layer = 0,
		text = utf8.to_upper(row_item.text),
		blend_mode = "normal",
		render_template = Idstring("VertexColorTextured")
	})
	local _, _, w, h = row_item.gui_text:text_rect()
	row_item.gui_text:set_size(math.round(w), math.round(h))
	self._back_row_item = row_item
end



MenuNodeCrimenetGageAssignmentGui = MenuNodeCrimenetGageAssignmentGui or class(MenuNodeCrimenetContactInfoGui)
MenuNodeCrimenetGageAssignmentGui.WIDTH = 1000
MenuNodeCrimenetGageAssignmentGui.HEIGHT = 530
MenuNodeCrimenetGageAssignmentGui.MENU_WIDTH = 220
MenuNodeCrimenetGageAssignmentGui.PADDING = 10
MenuNodeCrimenetGageAssignmentGui.CODEX_TEXT_ID = "menu_gage_assignment_title"
MenuNodeCrimenetGageAssignmentGui.SOUND_SOURCE_NAME = "MenuNodeCrimenetGageAssignmentGui"
function MenuNodeCrimenetGageAssignmentGui:set_contact_info(id, name, files, override_file)
	self:unretrieve_textures()
	self._requested_textures = {}
	self._info_panel:clear()
	local ids = Idstring(id)
	local num_assignments = 5
	if tweak_data.gage_assignment:exists(id) then
		local right_width = (self._info_panel:w() - self.PADDING * (num_assignments - 1)) / num_assignments
		local left_width = self._info_panel:w() - self.PADDING - right_width
		local left_panel = self._info_panel:panel({
			name = "left_panel",
			x = 0,
			y = 0,
			w = left_width
		})
		local right_panel = self._info_panel:panel({
			name = "right_panel",
			x = left_panel:right() + self.PADDING,
			y = 0,
			w = right_width,
			h = right_width * 1.75
		})
		local rewards = tweak_data.gage_assignment:get_value(id, "rewards") or {}
		local reward_width = (left_panel:w() - self.PADDING * 4) / 3
		local reward_height = (left_panel:h() - self.PADDING * 3) / 2
		local all_weapon_families = managers.weapon_factory:get_all_weapon_families()
		local all_weapon_categories = managers.weapon_factory:get_all_weapon_categories()
		for i, data in ipairs(rewards) do
			local x = (i - 1) % 3
			local y = math.ceil(i / 3) - 1
			local panel = left_panel:panel({
				x = self.PADDING + x * (self.PADDING + reward_width),
				y = self.PADDING + y * (self.PADDING + reward_height),
				w = reward_width,
				h = reward_height
			})
			local item_panel = panel:panel({
				h = panel:w() * 0.5
			})
			item_panel:set_center_y(panel:h() * 0.25)
			local item_text = panel:text({
				name = "item_text",
				text = "",
				font = tweak_data.menu.pd2_small_font,
				font_size = tweak_data.menu.pd2_small_font_size,
				color = tweak_data.screen_colors.text,
				wrap = true,
				word_wrap = true,
				align = "center"
			})
			item_text:set_shape(0, item_panel:bottom() + self.PADDING / 2, panel:w(), panel:h() - item_panel:bottom() - self.PADDING / 2)
			local part_name_id = tweak_data.blackmarket[data[2]][data[3]].name_id
			local text_sting = managers.localization:text(part_name_id)
			if data[2] == "weapon_mods" then
				local weapon_uses_part = managers.weapon_factory:get_weapons_uses_part(data[3]) or {}
				text_sting = text_sting .. [[

(]]
				if managers.localization:exists(part_name_id .. "_fits") then
					text_sting = text_sting .. managers.localization:text(part_name_id .. "_fits")
				elseif #weapon_uses_part == 1 then
					local weapon_id = managers.weapon_factory:get_weapon_id_by_factory_id(weapon_uses_part[1])
					text_sting = text_sting .. managers.weapon_factory:get_weapon_name_by_weapon_id(weapon_id)
				else
					local all_families = deep_clone(all_weapon_families)
					local all_categories = deep_clone(all_weapon_categories)
					local family, weapon_id, category
					for i, factory_id in ipairs(weapon_uses_part) do
						family = tweak_data.weapon.factory[factory_id].family
						if family then
							table.delete(all_families[family], factory_id)
						end
						weapon_id = managers.weapon_factory:get_weapon_id_by_factory_id(factory_id)
						category = tweak_data.weapon[weapon_id].category
						if category then
							table.delete(all_categories[category], factory_id)
						end
					end
					local need_string = true
					local categories = {}
					for category, weapons in pairs(all_categories) do
						if #weapons == 0 then
							table.insert(categories, category)
						end
					end
					if #categories > 0 then
						for i, category in ipairs(categories) do
							text_sting = text_sting .. managers.localization:text("menu_" .. category)
							if i < #categories then
								text_sting = text_sting .. ", "
							end
						end
						need_string = false
					end
					if need_string then
						local families = {}
						for family, weapons in pairs(all_families) do
							if #weapons == 0 then
								table.insert(families, family)
							end
						end
						if #families > 0 then
							for i, family in ipairs(families) do
								text_sting = text_sting .. managers.localization:text("menu_family_" .. family)
								if i < #families then
									text_sting = text_sting .. ", "
								end
							end
							need_string = false
						end
						if need_string then
							if #weapon_uses_part < 4 then
								for i, factory_id in ipairs(weapon_uses_part) do
									text_sting = text_sting .. managers.weapon_factory:get_weapon_name_by_factory_id(factory_id)
									if i < #weapon_uses_part then
										text_sting = text_sting .. ", "
									end
								end
							else
								print("[MenuNodeCrimenetGageAssignmentGui]", i, inspect(all_categories), inspect(all_families))
							end
						end
					end
				end
				text_sting = text_sting .. ")"
			end
			item_text:set_text(text_sting)
			item_text:set_world_position(math.round(item_text:world_x()), math.round(item_text:world_y()))
			self:populate_item_panel(item_panel, data)
		end
		self:create_insigna(right_panel, id)
		BoxGuiObject:new(left_panel, {
			sides = {
				1,
				1,
				1,
				1
			}
		})
		BoxGuiObject:new(right_panel, {
			sides = {
				1,
				1,
				1,
				1
			}
		})
	elseif ids == Idstring("_introduction") then
		local introduction_text = self._info_panel:text({
			name = "introduction_text",
			text = managers.localization:text("menu_gage_assignment_introduction_desc"),
			font = tweak_data.menu.pd2_small_font,
			font_size = tweak_data.menu.pd2_small_font_size,
			color = tweak_data.screen_colors.text,
			wrap = true,
			word_wrap = true
		})
	elseif ids == Idstring("_summary") then
		local width = (self._info_panel:w() - self.PADDING * (num_assignments - 1)) / num_assignments
		local x = 0
		local summary_panel = self._info_panel:panel({
			name = "summary_panel"
		})
		summary_panel:set_h(width * 1.75)
		summary_panel:set_bottom(self._info_panel:h())
		for i, node in ipairs(self.node:items()) do
			if tweak_data.gage_assignment:exists(node:parameters().name) then
				local panel = summary_panel:panel({
					name = node:parameters().name
				})
				panel:set_w(width)
				panel:set_x(x)
				self:create_insigna(panel, node:parameters().name)
				x = panel:right() + self.PADDING
			end
		end
		local summary_text = self._info_panel:text({
			name = "summary_text",
			text = managers.localization:text("menu_gage_assignment_summary_desc"),
			font = tweak_data.menu.pd2_small_font,
			font_size = tweak_data.menu.pd2_small_font_size,
			color = tweak_data.screen_colors.text,
			wrap = true,
			word_wrap = true
		})
		summary_text:set_h(summary_panel:top() - self.PADDING)
		BoxGuiObject:new(summary_panel, {
			sides = {
				1,
				1,
				1,
				1
			}
		})
	else
		if ids == Idstring("_video") then
			local video_panel = self._info_panel:panel()
			video_panel:rect({
				color = Color.black,
				alpha = 0.85,
				halign = "scale",
				valign = "scale"
			})
			local video = video_panel:video({
				video = "movies/tutorials/gage_assignment",
				blend_mode = "normal",
				loop = true,
				halign = "scale",
				valign = "scale",
				layer = 1
			})
			local video_width = video:video_width()
			local video_height = video:video_height()
			local ratio = video_width / video_height
			local sh = math.min(self._info_panel:h(), self._info_panel:w() / ratio)
			local sw = math.min(self._info_panel:w(), self._info_panel:h() * ratio)
			video_panel:set_size(sw, sh)
			video:play()
			BoxGuiObject:new(video_panel, {
				sides = {
					2,
					2,
					2,
					2
				}
			})
		else
		end
	end
	local contact_title_text = self._panel:child("contact_title_text")
	contact_title_text:set_text(utf8.to_upper(name))
	make_fine_text(contact_title_text)
	self._current_contact_info = id
end

function MenuNodeCrimenetGageAssignmentGui:create_insigna(panel, assignment)
	local assignment_insignia = panel:panel({
		w = panel:w(),
		h = panel:w() * 2
	})
	local progress, to_aquire, completed = managers.gage_assignment:get_assignment_data(assignment)
	local dlc = tweak_data.gage_assignment:get_value(assignment, "dlc")
	local has_dlc = not dlc or managers.dlc:is_dlc_unlocked(dlc)
	local progress_text = panel:text({
		name = "progress_text",
		text = "",
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = Color.pink,
		wrap = true,
		word_wrap = true,
		align = "center"
	})
	progress_text:set_text(tostring(progress) .. "/" .. tostring(to_aquire))
	make_fine_text(progress_text)
	progress_text:set_bottom(panel:h())
	progress_text:set_center_x(panel:w() / 2)
	progress_text:set_position(math.round(progress_text:x()), math.round(progress_text:y()))
	local step = 2
	local x = self.PADDING
	local max_aquire = tweak_data.gage_assignment:get_max_aquire()
	local w = (panel:w() - x * 2 - step * (max_aquire - 1)) / max_aquire
	local rounded_width = math.max(math.round(w), 1)
	local diff = panel:w() - (w * max_aquire + step * (max_aquire - 1) + x * 2)
	x = math.clamp(math.round(x + diff / 2), 0, panel:w())
	local padding = x
	local w = math.max((panel:w() - x * 2 - step * (to_aquire - 1)) / to_aquire, 1)
	local rounded_width = math.round(w)
	local estimated_width = x * 2 + step * (to_aquire - 1) + rounded_width * to_aquire
	diff = panel:w() - (w * to_aquire + x * 2)
	if to_aquire > 1 then
		step = math.clamp(diff / (to_aquire - 1), 0, 2)
	end
	local w = math.max((panel:w() - x * 2 - step * (to_aquire - 1)) / to_aquire, 1)
	local rounded_width = math.round(w)
	local pin_bottom = progress_text:top() - self.PADDING / 2
	local pin, is_progressed
	local mvec1 = Vector3()
	local mvec2 = Vector3()
	for i = 1, to_aquire do
		is_progressed = progress >= i
		pin = panel:rect({
			x = x,
			w = w,
			h = is_progressed and 10 or 3,
			color = Color.white,
			alpha = is_progressed and 1 or 0.3
		})
		pin:set_bottom(pin_bottom)
		x = pin:right() + step
	end
	local insignia = tweak_data.gage_assignment:get_value(assignment, "insignia")
	if insignia then
		local texture_count = managers.menu_component:request_texture(insignia, callback(self, self, "texture_done_clbk", {
			assignment_insignia,
			false,
			"normal"
		}))
		table.insert(self._requested_textures, {texture_count = texture_count, texture = insignia})
	else
		assignment_insignia:rect({
			color = Color.red,
			blend_mode = "normal"
		})
	end
end

function MenuNodeCrimenetGageAssignmentGui:populate_item_panel(item_panel, item_data)
	local global_value, category, item_id = unpack(item_data)
	if category == "weapon_mods" then
		category = "mods"
	end
	if category == "colors" then
		local colors = tweak_data.blackmarket.colors[item_id].colors
		local bg = item_panel:bitmap({
			texture = "guis/textures/pd2/blackmarket/icons/colors/color_bg",
			w = item_panel:h(),
			h = item_panel:h(),
			layer = 1
		})
		local c1 = item_panel:bitmap({
			texture = "guis/textures/pd2/blackmarket/icons/colors/color_01",
			w = item_panel:h(),
			h = item_panel:h(),
			layer = 0
		})
		local c2 = item_panel:bitmap({
			texture = "guis/textures/pd2/blackmarket/icons/colors/color_02",
			w = item_panel:h(),
			h = item_panel:h(),
			layer = 0
		})
		c1:set_color(colors[1])
		c2:set_color(colors[2])
		bg:set_center(item_panel:w() / 2, item_panel:h() / 2)
		c1:set_center(bg:center())
		c2:set_center(bg:center())
	else
		local texture_path
		if category == "textures" then
			texture_path = tweak_data.blackmarket.textures[item_id] and tweak_data.blackmarket.textures[item_id].texture
			if not texture_path then
				Application:error("Pattern missing", item_id)
				return
			end
		elseif category == "cash" then
			texture_path = "guis/textures/pd2/blackmarket/cash_drop"
		elseif category == "xp" then
			texture_path = "guis/textures/pd2/blackmarket/xp_drop"
		else
			local guis_catalog = "guis/"
			local tweak_data_category = category == "mods" and "weapon_mods" or category
			local bundle_folder = tweak_data.blackmarket[tweak_data_category] and tweak_data.blackmarket[tweak_data_category][item_id] and tweak_data.blackmarket[tweak_data_category][item_id].texture_bundle_folder
			if bundle_folder then
				guis_catalog = guis_catalog .. "dlcs/" .. tostring(bundle_folder) .. "/"
			end
			texture_path = guis_catalog .. "textures/pd2/blackmarket/icons/" .. tostring(category) .. "/" .. tostring(item_id)
		end
		if DB:has(Idstring("texture"), texture_path) then
			local texture_count = managers.menu_component:request_texture(texture_path, callback(self, self, "texture_done_clbk", {
				item_panel,
				category == "textures"
			}))
			table.insert(self._requested_textures, {texture_count = texture_count, texture = texture_path})
		else
			Application:error("[MenuNodeCrimenetGageAssignmentGui]", item_id, "Texture not in DB", texture_path)
			item_panel:rect({
				color = Color.red
			})
		end
	end
end

function MenuNodeCrimenetGageAssignmentGui:unretrieve_textures()
	if self._requested_textures then
		for i, data in pairs(self._requested_textures) do
			managers.menu_component:unretrieve_texture(data.texture, data.texture_count)
		end
	end
	self._requested_textures = nil
end

function MenuNodeCrimenetGageAssignmentGui:texture_done_clbk(params, texture_ids)
	local panel = params[1]
	local is_pattern = params[2]
	local blend_mode = params[3] or "normal"
	local color = params[4]
	local image = panel:bitmap({
		name = "texture",
		texture = texture_ids,
		blend_mode = blend_mode
	})
	if is_pattern then
		image:set_render_template(Idstring("VertexColorTexturedPatterns"))
	end
	if color then
		image:set_color(color)
	end
	local texture_width = image:texture_width()
	local texture_height = image:texture_height()
	local panel_width = panel:w()
	local panel_height = panel:h()
	local tw = texture_width
	local th = texture_height
	local pw = panel_width
	local ph = panel_height
	if tw == 0 or th == 0 then
		Application:error("[MenuNodeCrimenetGageAssignmentGui:texture_done_clbk] Texture size error!:", "width", tw, "height", th)
		tw = 1
		th = 1
	end
	local sw = math.min(pw, ph * (tw / th))
	local sh = math.min(ph, pw / (tw / th))
	image:set_size(math.round(sw), math.round(sh))
	image:set_center(panel:w() * 0.5, panel:h() * 0.5)
end

function MenuNodeCrimenetGageAssignmentGui:_setup_layout()
	local safe_rect = managers.gui_data:scaled_size()
	local mc_full_ws = managers.menu_component:fullscreen_ws()
	local ws = self.ws
	if alive(self._fullscreen_panel) then
		mc_full_ws:panel():remove(self._fullscreen_panel)
	end
	if alive(ws:panel():child("main_panel")) then
		ws:panel():remove(ws:panel():child("main_panel"))
	end
	local panel = ws:panel():panel({name = "main_panel"})
	self._fullscreen_panel = mc_full_ws:panel():panel({layer = 50})
	local blur = self._fullscreen_panel:bitmap({
		texture = "guis/textures/test_blur_df",
		w = self._fullscreen_panel:w(),
		h = self._fullscreen_panel:h(),
		render_template = "VertexColorTexturedBlur3D"
	})
	local func = function(o)
		local start_blur = 0
		over(0.6, function(p)
			o:set_alpha(math.lerp(start_blur, 1, p))
		end
)
	end

	blur:animate(func)
	local width = self.WIDTH
	local height = self.HEIGHT
	self._panel = panel:panel({
		h = height,
		w = width,
		layer = 51
	})
	self._panel:set_center(panel:w() / 2, panel:h() / 2)
	self._panel:rect({
		color = Color.black,
		alpha = 0.6,
		layer = 0
	})
	BoxGuiObject:new(self._panel, {
		sides = {
			1,
			1,
			1,
			1
		}
	})
	local title_text = panel:text({
		name = "title_text",
		text = self._codex_text,
		font = tweak_data.menu.pd2_medium_font,
		font_size = tweak_data.menu.pd2_medium_font_size,
		color = tweak_data.screen_colors.text,
		layer = 51
	})
	make_fine_text(title_text)
	title_text:set_left(self._panel:left())
	title_text:set_bottom(self._panel:top() - 2)
	local contact_title_text = self._panel:text({
		name = "contact_title_text",
		text = " ",
		font = tweak_data.menu.pd2_medium_font,
		font_size = tweak_data.menu.pd2_medium_font_size,
		color = tweak_data.screen_colors.text,
		layer = 52
	})
	make_fine_text(contact_title_text)
	contact_title_text:set_left(self.MENU_WIDTH + self.PADDING * 3)
	contact_title_text:set_top(self.PADDING)
	self._info_panel = self._panel:panel({
		x = self.MENU_WIDTH + self.PADDING * 3,
		y = contact_title_text:bottom() + self.PADDING,
		layer = 1
	})
	self._info_panel:set_w(self._panel:w() - self._info_panel:x() - self.PADDING)
	self._info_panel:set_h(self._panel:h() - self._info_panel:y() - self.PADDING)
	self._init_finish = true
	self:_setup_menu()
end

function MenuNodeCrimenetGageAssignmentGui:set_file(index)
end

function MenuNodeCrimenetGageAssignmentGui:close()
	self:unretrieve_textures()
	MenuNodeCrimenetGageAssignmentGui.super.close(self)
end

MenuNodeCrimenetChallengeGui = MenuNodeCrimenetChallengeGui or class(MenuNodeCrimenetGageAssignmentGui)
MenuNodeCrimenetChallengeGui.WIDTH = 840
MenuNodeCrimenetChallengeGui.HEIGHT = 460
MenuNodeCrimenetChallengeGui.MENU_WIDTH = 315
MenuNodeCrimenetChallengeGui.PADDING = 10
MenuNodeCrimenetChallengeGui.CODEX_TEXT_ID = "menu_cn_challenge_title"
MenuNodeCrimenetChallengeGui.SOUND_SOURCE_NAME = "MenuNodeCrimenetChallengeGui"
function MenuNodeCrimenetChallengeGui:init(node, layer, parameters)
	MenuNodeCrimenetChallengeGui.super.init(self, node, layer, parameters)
	self._file_icons = nil
	self._file_alphas = {
		locked = 0.4,
		unavailable = 1,
		selected = 1,
		unselected = 0.8,
		mouse_over = 1
	}
end

function MenuNodeCrimenetChallengeGui:set_contact_info(id, name, files, override_file)
	self:unretrieve_textures()
	self._requested_textures = {}
	self._info_panel:clear()
	self._files = {}
	if not id then
		local contact_title_text = self._panel:child("contact_title_text")
		contact_title_text:set_text(" ")
		make_fine_text(contact_title_text)
		return
	end
	local contact_title = name
	local ids = Idstring(id)
	local challenge = managers.challenge:get_active_challenge(id, ids:key())
	if challenge then
		contact_title = managers.localization:text("menu_challenge_title_" .. (challenge.category or "daily"), {name = name})
		local desc_text = self._info_panel:text({
			name = "desc_text",
			text = challenge.desc_s or managers.localization:text(challenge.desc_id),
			font = tweak_data.menu.pd2_small_font,
			font_size = tweak_data.menu.pd2_small_font_size,
			color = tweak_data.screen_colors.text,
			wrap = true,
			word_wrap = true,
			blend_mode = "normal"
		})
		desc_text:grow(-desc_text:left(), 0)
		local _, _, _, h = desc_text:text_rect()
		desc_text:set_h(h)
		local y = desc_text:bottom()
		if challenge.objective_s or challenge.objective_id then
			local objective_title_text = self._info_panel:text({
				name = "objective_title_text",
				text = managers.localization:to_upper_text("menu_challenge_objective_title"),
				font = tweak_data.menu.pd2_small_font,
				font_size = tweak_data.menu.pd2_small_font_size,
				color = tweak_data.screen_colors.text,
				wrap = true,
				word_wrap = true,
				blend_mode = "normal"
			})
			make_fine_text(objective_title_text)
			objective_title_text:set_top(y + tweak_data.menu.pd2_small_font_size)
			local objective_text = self._info_panel:text({
				name = "objectives_text",
				text = challenge.objective_s or managers.localization:text(challenge.objective_id),
				font = tweak_data.menu.pd2_small_font,
				font_size = tweak_data.menu.pd2_small_font_size,
				color = tweak_data.screen_colors.text,
				wrap = true,
				word_wrap = true,
				blend_mode = "normal"
			})
			objective_text:set_left(objective_title_text:left() + 15)
			objective_text:set_top(objective_title_text:bottom())
			objective_text:grow(-objective_text:left(), 0)
			local _, _, _, h = objective_text:text_rect()
			objective_text:set_h(h)
			y = objective_text:bottom()
		end
		if challenge.reward_s or challenge.reward_id then
			local reward_title_text = self._info_panel:text({
				name = "reward_title_text",
				text = managers.localization:to_upper_text("menu_challenge_reward_title"),
				font = tweak_data.menu.pd2_small_font,
				font_size = tweak_data.menu.pd2_small_font_size,
				color = tweak_data.screen_colors.text,
				wrap = true,
				word_wrap = true,
				blend_mode = "normal"
			})
			make_fine_text(reward_title_text)
			reward_title_text:set_top(y + tweak_data.menu.pd2_small_font_size)
			local reward_text = self._info_panel:text({
				name = "rewards_text",
				text = challenge.reward_s or managers.localization:text(challenge.reward_id),
				font = tweak_data.menu.pd2_small_font,
				font_size = tweak_data.menu.pd2_small_font_size,
				color = tweak_data.screen_colors.text,
				wrap = true,
				word_wrap = true,
				blend_mode = "normal"
			})
			reward_text:set_left(reward_title_text:left() + 15)
			reward_text:set_top(reward_title_text:bottom())
			reward_text:grow(-reward_text:left(), 0)
			local _, _, _, h = reward_text:text_rect()
			reward_text:set_h(h)
			y = reward_text:bottom()
		end
		if not challenge.rewarded then
			local timestamp = challenge.timestamp
			local interval = challenge.interval
			local expire_timestamp = interval + timestamp
			local current_timestamp = managers.challenge:get_timestamp()
			local expire_time = expire_timestamp - current_timestamp
			if not (expire_time <= 0) or not managers.localization:to_upper_text("menu_challenge_about_to_expire") then
			end
			local expire_text = self._info_panel:text({
				name = "expire_text",
				text = managers.localization:to_upper_text("menu_challenge_expire_time", {
					time_left = tostring(expire_time)
				}),
				font = tweak_data.menu.pd2_small_font,
				font_size = tweak_data.menu.pd2_small_font_size,
				color = expire_time <= 4 and tweak_data.screen_colors.important_1 or tweak_data.screen_colors.important_2,
				wrap = true,
				word_wrap = true,
				blend_mode = "normal"
			})
			make_fine_text(expire_text)
			expire_text:set_top(y + tweak_data.menu.pd2_small_font_size)
			y = expire_text:bottom()
		end
		if challenge.rewards and 0 < #challenge.rewards then
			local x = self.PADDING
			local height = math.min(self._info_panel:h() - y - self.PADDING * 2 - tweak_data.menu.pd2_small_font_size, 128)
			local width = math.min((self._info_panel:w() - self.PADDING * (#challenge.rewards - 1)) / #challenge.rewards, height)
			local rewards_panel = self._info_panel:panel({
				name = "rewards_panel"
			})
			rewards_panel:set_h(height)
			rewards_panel:set_bottom(self._info_panel:h())
			local files_menu = rewards_panel:panel()
			local locked
			local unavailable = not challenge.completed
			for i, reward in ipairs(challenge.rewards) do
				local panel = files_menu:panel({
					name = i,
					x = x,
					y = self.PADDING,
					width = width - 2 * self.PADDING,
					height = rewards_panel:height() - 2 * self.PADDING
				})
				self:create_reward(panel, reward, challenge)
				x = panel:right() + self.PADDING
				locked = reward.rewarded
				table.insert(self._files, {lock = locked, unavailable = unavailable})
			end
			self._files_menu = files_menu
			self:set_file(1)
			local color = false
			local rewards_text = self._info_panel:text({
				name = "rewards_text",
				text = managers.localization:to_upper_text(challenge.rewarded and "menu_cn_rewarded" or challenge.completed and "menu_cn_completed" or "menu_cn_not_completed"),
				font = tweak_data.menu.pd2_small_font,
				font_size = tweak_data.menu.pd2_small_font_size,
				color = tweak_data.screen_colors.text,
				wrap = true,
				word_wrap = true,
				blend_mode = "normal"
			})
			make_fine_text(rewards_text)
			rewards_text:set_bottom(rewards_panel:top())
			if color then
				rewards_text:set_color(color)
			end
			BoxGuiObject:new(rewards_panel, {
				sides = {
					1,
					1,
					1,
					1
				}
			})
		end
	elseif ids == Idstring("_introduction") then
		local introduction_text = self._info_panel:text({
			name = "introduction_text",
			text = managers.localization:text("menu_challenge_introduction_desc"),
			font = tweak_data.menu.pd2_small_font,
			font_size = tweak_data.menu.pd2_small_font_size,
			color = tweak_data.screen_colors.text,
			wrap = true,
			word_wrap = true,
			blend_mode = "normal"
		})
	else
		if ids == Idstring("_summary") then
			local summary_text = self._info_panel:text({
				name = "summary_text",
				text = managers.localization:text("menu_challenge_summary_desc"),
				font = tweak_data.menu.pd2_small_font,
				font_size = tweak_data.menu.pd2_small_font_size,
				color = tweak_data.screen_colors.text,
				wrap = true,
				word_wrap = true,
				blend_mode = "normal"
			})
		else
		end
	end
	local contact_title_text = self._panel:child("contact_title_text")
	contact_title_text:set_text(utf8.to_upper(contact_title))
	make_fine_text(contact_title_text)
	self._current_contact_info = id
end

function MenuNodeCrimenetChallengeGui:create_reward(panel, reward, challenge)
	local texture, texture_path
	local is_pattern = false
	local reward_string = ""
	reward_string = (reward.name_s or reward.name_id) and (reward.name_s or managers.localization:text(reward.name_id))
	local reward_panel = panel:panel({
		name = "reward_icon",
		y = tweak_data.menu.pd2_small_font_size * 0,
		h = panel:h() - tweak_data.menu.pd2_small_font_size * 1
	})
	if reward.choose_weapon_reward then
		texture_path = "guis/textures/pd2/icon_modbox_df"
		reward_string = managers.localization:text("menu_challenge_choose_weapon_mod")
	else
		local id = reward.item_entry
		local category = reward.type_items
		local td = tweak_data:get_raw_value("blackmarket", category, id)
		if td then
			local guis_catalog = "guis/"
			local bundle_folder = td.texture_bundle_folder
			if bundle_folder then
				guis_catalog = guis_catalog .. "dlcs/" .. tostring(bundle_folder) .. "/"
			end
			if category == "textures" then
				texture_path = td.texture
				is_pattern = true
			elseif category == "cash" then
				texture_path = "guis/textures/pd2/blackmarket/cash_drop"
				reward_string = managers.localization:text("menu_challenge_cash_drop")
			elseif category == "xp" then
				texture_path = "guis/textures/pd2/blackmarket/xp_drop"
				reward_string = managers.localization:text("menu_challenge_xp_drop")
			else
				texture_path = guis_catalog .. "textures/pd2/blackmarket/icons/" .. category .. "/" .. id
				reward_string = managers.localization:text(td.name_id)
			end
		end
	end
	local color = false
	if challenge.completed and not reward.rewarded then
		local glow = panel:bitmap({
			texture = "guis/textures/pd2/hot_cold_glow",
			layer = 0,
			w = math.min(panel:w(), panel:h()) * 1.5,
			h = math.min(panel:w(), panel:h()) * 1.5,
			blend_mode = "normal",
			color = tweak_data.screen_colors.challenge_completed_color,
			alpha = 0,
			layer = -1,
			rotation = 360
		})
		glow:set_center(reward_panel:center())
		local glow_anim = function(o)
			local dt
			while true do
				over(5, function(p)
					o:set_alpha(math.abs(math.sin(p * 360)) * 0.4)
				end
)
			end
		end

		glow:animate(glow_anim)
	end
	local reward_text = panel:text({
		name = "reward_text",
		text = reward_string,
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		blend_mode = "normal",
		rotation = 360
	})
	make_fine_text(reward_text)
	reward_text:set_top(reward_panel:bottom() + tweak_data.menu.pd2_small_font_size * 0.5)
	reward_text:set_center_x(reward_panel:center_x())
	reward_text:set_visible(true)
	if color then
		reward_text:set_color(color)
	end
	if DB:has(Idstring("texture"), texture_path) then
		local texture_count = managers.menu_component:request_texture(texture_path, callback(self, self, "texture_done_clbk", {
			reward_panel,
			is_pattern,
			"normal",
			color
		}))
		table.insert(self._requested_textures, {texture_count = texture_count, texture = texture_path})
	end
end

function MenuNodeCrimenetChallengeGui:_highlight_row_item(row_item, mouse_over)
	MenuNodeCrimenetChallengeGui.super._highlight_row_item(self, row_item, mouse_over)
	self._highlighted_name = row_item.item and row_item.item:name()
	self:_set_file()
end

function MenuNodeCrimenetChallengeGui:set_file(index)
	MenuNodeCrimenetChallengeGui.super.super.set_file(self, index)
end

function MenuNodeCrimenetChallengeGui:_set_file()
	local files_menu = self._files_menu
	if alive(files_menu) then
		for i, file in ipairs(files_menu:children()) do
			local is_locked = self:is_file_locked(self._files[i] and self._files[i].lock)
			local is_unavailable = self:is_file_locked(self._files[i] and self._files[i].unavailable)
			local texture_alpha = is_locked and self._file_alphas.locked or is_unavailable and self._file_alphas.unavailable or i == self._current_file and self._file_alphas.selected or self._file_alphas.unselected
			file:set_alpha(texture_alpha)
			file:child("reward_text"):set_visible(not is_locked and not is_unavailable and i == self._current_file)
		end
	end
end

function MenuNodeCrimenetChallengeGui:set_empty()
end

function MenuNodeCrimenetChallengeGui:close()
	MenuNodeCrimenetChallengeGui.super.close(self)
	MenuCallbackHandler:save_progress()
end

function MenuNodeCrimenetChallengeGui:mouse_moved(o, x, y)
	if not self._info_panel:inside(x, y) then
		return
	end
	local files_menu = self._files_menu
	local is_inside = false
	local highlighted_file
	if alive(files_menu) then
		local inside, inside_text
		local visible_texts = {}
		for i, file in ipairs(files_menu:children()) do
			inside = file:inside(x, y)
			local is_locked = self:is_file_locked(self._files[i] and self._files[i].lock)
			local is_unavailable = self:is_file_locked(self._files[i] and self._files[i].unavailable)
			local texture_alpha = is_locked and self._file_alphas.locked or is_unavailable and self._file_alphas.unavailable or not self._file_alphas or i == self._current_file and self._file_alphas.selected or inside and self._file_alphas.mouse_over or self._file_alphas.unselected
			if texture_alpha then
				file:set_alpha(texture_alpha)
			end
			file:child("reward_text"):set_visible(not is_locked and not is_unavailable and i == self._current_file or inside)
			if file:child("reward_text"):visible() then
				table.insert(visible_texts, file:child("reward_text"))
			end
			if inside then
				inside_text = file:child("reward_text")
				is_inside = i
				highlighted_file = self._current_file ~= i and i
			end
		end
		local texts_colliding = false
		if #visible_texts > 1 then
			for i = 1, #visible_texts - 1 do
				if visible_texts[i]:world_left() < visible_texts[i + 1]:world_right() and visible_texts[i]:world_right() > visible_texts[i + 1]:world_left() then
					texts_colliding = true
					break
				end
			end
			if texts_colliding then
				for i, text in ipairs(visible_texts) do
					text:hide()
				end
				if inside_text then
					inside_text:show()
				elseif self._current_file then
					files_menu[self._current_file]:child("reward_text"):show()
				end
			end
		end
	end
	if highlighted_file and self._highlighted_file ~= highlighted_file then
		managers.menu_component:post_event("highlight")
		self._highlighted_file = highlighted_file
	elseif not highlighted_file then
		self._highlighted_file = false
	end
	local is_locked = is_inside and (self:is_file_locked(self._files[is_inside] and self._files[is_inside].lock) or self:is_file_locked(self._files[is_inside] and self._files[is_inside].unavailable))
	return is_inside, self._file_pressed and (self._file_pressed == is_inside and not is_locked and "link" or "arrow") or is_inside and not is_locked and "link" or "arrow"
end

function MenuNodeCrimenetChallengeGui:mouse_pressed(button, x, y)
	local files_menu = self._files_menu
	if alive(files_menu) then
		for i, file in ipairs(files_menu:children()) do
			if file:inside(x, y) and not self:is_file_locked(self._files[i].lock) and not self:is_file_locked(self._files[i].unavailable) then
				self._file_pressed = i
				self:set_file(self._file_pressed)
				managers.menu_component:post_event("highlight")
				return
			end
		end
	end
	self._file_pressed = false
end

function MenuNodeCrimenetChallengeGui:mouse_released(button, x, y)
	if self._file_pressed and self._file_pressed == self._current_file then
		local files_menu = self._files_menu
		if alive(files_menu) then
			local file = files_menu:children()[self._file_pressed]
			if file and file:inside(x, y) then
				self:claim_reward(self._file_pressed)
			end
		end
	end
	self._file_pressed = false
end

function MenuNodeCrimenetChallengeGui:claim_reward(index)
	local reward = managers.challenge:on_give_reward(self._current_contact_info, nil, index)
	if reward then
		if reward.choose_weapon_reward then
			managers.menu:open_node("choose_weapon_reward")
		else
			managers.menu:show_challenge_reward(reward)
		end
	end
end

function MenuNodeCrimenetChallengeGui:special_btn_pressed(button)
	if button == Idstring("menu_challenge_claim") then
		self:claim_reward(self._current_file)
	end
end

function MenuNodeCrimenetChallengeGui:refresh_gui(node)
	if not self._init_finish then
		return
	end
	if self._back_row_item and alive(self._back_row_item.gui_pd2_panel) then
		self._back_row_item.gui_pd2_panel:parent():remove(self._back_row_item.gui_pd2_panel)
		self._back_row_item = nil
	end
	local old_menu_unslected_lefts = {}
	local old_menu_unslected_tops = {}
	for _, row_item in pairs(self.row_items) do
		if alive(row_item.menu_unselected) then
			old_menu_unslected_lefts[_] = row_item.menu_unselected:left()
			old_menu_unslected_tops[_] = row_item.menu_unselected:top()
		end
	end
	local old_y = self.item_panel:world_y()
	self:_clear_gui()
	self:_setup_panels(node)
	self:_setup_item_rows(node)
	self:_set_item_positions()
	self:_set_topic_position()
	self:update_item_icon_visibility()
	local row_x = 0
	for _, row_item in pairs(self.row_items) do
		if alive(row_item.icon) then
			row_item.icon:set_left(0)
		end
		if alive(row_item.menu_unselected) then
			if old_menu_unslected_lefts[_] then
				row_item.menu_unselected:set_left(old_menu_unslected_lefts[_])
			end
			if old_menu_unslected_tops[_] then
				row_item.menu_unselected:set_top(old_menu_unslected_tops[_])
			end
		end
		if alive(row_item.gui_panel) then
			row_x = math.max(row_x, row_item.gui_panel:world_x())
		end
	end
	local selected_item = self._current_contact_info and node:item(self._current_contact_info)
	if selected_item then
		local parameters = selected_item:parameters() or {}
		local id = parameters.name
		local name_id = parameters.text_id
		local files = parameters.files
		self:set_contact_info(id, name_id, files, 1)
	else
		self:set_contact_info()
	end
	self.item_panel:set_world_y(old_y)
	managers.menu_component:disable_crimenet()
end

function MenuNodeCrimenetChallengeGui:_align_marker(row_item)
	MenuNodeCrimenetChallengeGui.super._align_marker(self, row_item)
	if row_item.item:parameters().pd2_corner then
		self._marker_data.marker:set_visible(true)
		self._marker_data.gradient:set_visible(true)
		self._marker_data.gradient:set_rotation(360)
		self._marker_data.marker:set_height(64 * row_item.gui_text:height() / 32)
		self._marker_data.gradient:set_height(64 * row_item.gui_text:height() / 32)
		self._marker_data.marker:set_w(self.MENU_WIDTH)
		self._marker_data.gradient:set_w(self._marker_data.marker:w())
		self._marker_data.marker:set_left(row_item.menu_unselected:x())
		self._marker_data.marker:set_world_center_y(row_item.gui_text:world_center_y())
		self._marker_data.marker:set_y(math.round(self._marker_data.marker:y()))
		return
	end
end

function MenuNodeCrimenetChallengeGui:_clear_gui()
	local to = #self.row_items
	for i = 1, to do
		local row_item = self.row_items[i]
		if alive(row_item.gui_panel) then
			row_item.gui_panel:parent():remove(row_item.gui_panel)
			row_item.gui_panel = nil
			if alive(row_item.menu_unselected) then
				row_item.menu_unselected:parent():remove(row_item.menu_unselected)
				row_item.menu_unselected = nil
			end
		end
		if alive(row_item.gui_info_panel) then
			self.safe_rect_panel:remove(row_item.gui_info_panel)
		end
		if alive(row_item.icon) then
			row_item.icon:parent():remove(row_item.icon)
		end
		self.row_items[i] = nil
	end
	self._list_arrows.up:parent():remove(self._list_arrows.up)
	self._list_arrows.down:parent():remove(self._list_arrows.down)
	self.item_panel:clear()
	self.row_items = {}
end

function MenuNodeCrimenetChallengeGui:_setup_item_panel_parent(safe_rect, shape)
	local x = safe_rect.x + safe_rect.width / 2 - self.WIDTH / 2 + self.PADDING
	local y = safe_rect.y + safe_rect.height / 2 - self.HEIGHT / 2 + self.PADDING
	shape = shape or {}
	shape.x = shape.x or x
	shape.y = shape.y or y
	shape.w = shape.w or self.MENU_WIDTH
	shape.h = shape.h or self.HEIGHT - 2 * self.PADDING - tweak_data.menu.pd2_small_font_size
	MenuNodeCrimenetChallengeGui.super._setup_item_panel_parent(self, safe_rect, shape)
end

function MenuNodeCrimenetChallengeGui:_setup_menu()
	if not self._init_finish then
		return
	end
	local safe_rect = managers.gui_data:scaled_size()
	for _, child in ipairs(self.item_panel:children()) do
		child:set_halign("right")
	end
	self:_set_topic_position()
	self.item_panel:set_w(safe_rect.width * (1 - self._align_line_proportions) + 4)
	self.item_panel:set_world_position(self._panel:world_position())
	self.item_panel:move(self.PADDING, self.PADDING)
	for _, child in ipairs(self.item_panel:children()) do
		child:set_halign("left")
	end
	self.item_panel:set_w(self.MENU_WIDTH)
	self._align_data.panel:set_left(self.item_panel:left())
	self:update_item_icon_visibility()
	local row_x = 0
	for _, row_item in pairs(self.row_items) do
		if alive(row_item.icon) then
			row_item.icon:set_left(0)
		end
		if alive(row_item.gui_panel) then
			row_x = math.max(row_x, row_item.gui_panel:world_x())
		end
	end
	if self._back_row_item and alive(self._back_row_item.gui_text) then
		self._back_row_item.gui_text:set_w(self.MENU_WIDTH)
		self._back_row_item.gui_text:set_world_left(math.round(self._panel:world_left() + self.PADDING * 2))
		self._back_row_item.gui_text:set_world_bottom(math.round(self._panel:world_bottom() - self.PADDING))
	end
	for _, row_item in pairs(self.row_items) do
		if alive(row_item.gui_panel) then
			row_item.gui_panel:set_w(self.MENU_WIDTH)
		end
	end
	for _, child in ipairs(self.item_panel:children()) do
		child:set_world_y(math.round(child:world_y()))
	end
	self._list_arrows.up:set_world_left(self._align_data.panel:world_left())
	self._list_arrows.up:set_world_top(self._align_data.panel:world_top())
	self._list_arrows.up:set_width(self._item_panel_parent:w())
	self._list_arrows.down:set_world_left(self._align_data.panel:world_left())
	self._list_arrows.down:set_world_bottom(self._align_data.panel:world_bottom())
	self._list_arrows.down:set_width(self._item_panel_parent:w())
end

MenuNodeChooseWeaponRewardGui = MenuNodeChooseWeaponRewardGui or class(MenuNodeCrimenetFiltersGui)
function MenuNodeChooseWeaponRewardGui:init(node, layer, parameters)
	parameters.font = tweak_data.menu.pd2_small_font
	parameters.font_size = tweak_data.menu.pd2_small_font_size
	parameters.align = "left"
	parameters.row_item_blend_mode = "normal"
	parameters.row_item_color = PDTHMenu_color_normal
	parameters.row_item_hightlight_color = PDTHMenu_color_highlight
	parameters.marker_alpha = 1
	parameters.to_upper = true
	parameters._align_line_proportions = 0.5
	self.static_y = node:parameters().static_y
	MenuNodeChooseWeaponRewardGui.super.init(self, node, layer, parameters)
	if alive(self.item_panel:parent():child("special_title_text")) then
		self.item_panel:parent():remove(self.item_panel:parent():child("special_title_text"))
	end
	local title_text = self.item_panel:parent():text({
		name = "special_title_text",
		text = managers.localization:to_upper_text("menu_challenge_claim_reward_title"),
		font = tweak_data.menu.pd2_medium_font,
		font_size = tweak_data.menu.pd2_medium_font_size,
		color = tweak_data.screen_colors.text,
		blend_mode = "normal",
		layer = 51
	})
	make_fine_text(title_text)
	title_text:set_left(self.box_panel:left())
	title_text:set_bottom(self.box_panel:top())
end

function MenuNodeChooseWeaponRewardGui:_setup_item_panel(safe_rect, res)
	MenuNodeChooseWeaponRewardGui.super._setup_item_panel(self, safe_rect, res)
	local max_layer = 10000
	local min_layer = 0
	local child_layer = 0
	for _, child in ipairs(self.item_panel:children()) do
		child:set_halign("right")
		child_layer = child:layer()
		if child_layer > 0 then
			min_layer = math.min(min_layer, child_layer)
		end
		max_layer = math.max(max_layer, child_layer)
	end
	for _, child in ipairs(self.item_panel:children()) do
	end
	self.item_panel:set_w(safe_rect.width * (1 - self._align_line_proportions))
	self.item_panel:set_center(self.item_panel:parent():w() / 2, self.item_panel:parent():h() / 2)
	local static_y = self.static_y and safe_rect.height * self.static_y
	if static_y and static_y < self.item_panel:y() then
		self.item_panel:set_y(static_y)
	end
	self.item_panel:set_position(math.round(self.item_panel:x()), math.round(self.item_panel:y()))
	-- self:_rec_round_object(self.item_panel)
	if alive(self.box_panel) then
		self.item_panel:parent():remove(self.box_panel)
		self.box_panel = nil
	end
	self.box_panel = self.item_panel:parent():panel()
	self.box_panel:set_x(self.item_panel:x())
	self.box_panel:set_w(self.item_panel:w())
	if self.item_panel:h() > self._align_data.panel:h() then
		self.box_panel:set_y(0)
		self.box_panel:set_h(self.item_panel:parent():h())
	else
		self.box_panel:set_y(self.item_panel:top())
		self.box_panel:set_h(self.item_panel:h())
	end
	self.box_panel:grow(116, 20)
	self.box_panel:move(-106, -10)
	self.box_panel:set_layer(51)
	self.boxgui = BoxGuiObject:new(self.box_panel, {
		sides = {
			1,
			1,
			1,
			1
		}
	})
	self.boxgui:set_clipping(false)
	self.boxgui:set_layer(1000)
	self.box_panel:rect({
		color = Color.black,
		alpha = 0.6,
		rotation = 360
	})
	self._align_data.panel:set_left(self.box_panel:left())
	self._list_arrows.up:set_world_left(self._align_data.panel:world_left())
	self._list_arrows.up:set_world_top(self._align_data.panel:world_top() - 10)
	self._list_arrows.up:set_width(self.box_panel:width())
	self._list_arrows.up:set_rotation(360)
	self._list_arrows.up:set_layer(1050)
	self._list_arrows.down:set_world_left(self._align_data.panel:world_left())
	self._list_arrows.down:set_world_bottom(self._align_data.panel:world_bottom() + 10)
	self._list_arrows.down:set_width(self.box_panel:width())
	self._list_arrows.down:set_rotation(360)
	self._list_arrows.down:set_layer(1050)
	self:_set_topic_position()
	local icon = self.box_panel:bitmap({
		texture = "guis/textures/pd2/icon_modbox_df",
		w = 96,
		h = 96,
		blend_mode = "normal",
		layer = 1
	})
	icon:set_position(10, 10)
	local droppable_parts = managers.blackmarket:get_lootdropable_mods_by_weapon_id(self.node:parameters().listed_weapon, self.node:parameters().listed_global_value)
	local count = 0
	local inv_count = 0
	for _, part_data in ipairs(droppable_parts) do
		count = count + 1
		if managers.blackmarket:get_item_amount(part_data[2], "weapon_mods", part_data[1], true) ~= 0 then
			inv_count = inv_count + 1
		end
	end
	self._owned_text = self.box_panel:text({
		text = managers.localization:to_upper_text("menu_challenge_num_owned_mods", {
			inv_count = tostring(inv_count),
			count = tostring(count)
		}),
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		blend_mode = "normal"
	})
	make_fine_text(self._owned_text)
end

