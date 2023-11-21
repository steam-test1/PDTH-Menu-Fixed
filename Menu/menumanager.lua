function MenuCrimeNetSpecialInitiator:create_job(node, contract)
	local id = contract.id
	local enabled = contract.enabled
	local text_id, color_ranges = tweak_data.narrative:create_job_name(id)
	local help_id = ""
	local ghostable = managers.job:is_job_ghostable(id)
	if ghostable then
		text_id = text_id .. " " .. managers.localization:get_default_macro("BTN_GHOST")
	end
	if not enabled then
		do
			local job_tweak = tweak_data.narrative:job_data(id)
			local player_stars = managers.experience:level_to_stars()
			local max_jc = managers.job:get_max_jc_for_player()
			local job_tweak = tweak_data.narrative:job_data(id)
			local jc_lock = math.clamp(job_tweak.jc + (job_tweak.professional and 10 or 0), 0, 100)
			local min_stars = #tweak_data.narrative.STARS
			for i, d in ipairs(tweak_data.narrative.STARS) do
				if jc_lock <= d.jcs[1] then
					min_stars = i
				else
				end
			end
			local level_lock = (min_stars - 1) * 10
			local pass_dlc = not job_tweak.dlc or managers.dlc:is_dlc_unlocked(job_tweak.dlc)
			local pass_level = player_stars >= min_stars
			if not pass_dlc then
				local locks = job_tweak.gui_locks
				local unlock_id = ""
				if locks then
					local dlc = locks.dlc
					local achievement = locks.achievement
					local saved_job_value = locks.saved_job_value
					local level = locks.level
					if dlc and not managers.dlc:is_dlc_unlocked(dlc) then
					elseif achievement and managers.achievment:get_info(achievement) and not managers.achievment:get_info(achievement).awarded then
						text_id = text_id .. "  " .. managers.localization:to_upper_text("menu_bm_achievement_locked_" .. tostring(achievement))
					end
				else
				end
			elseif not pass_level then
			end
		end
	else
	end
	local params = {
		name = "job_" .. id,
		text_id = text_id,
	    color_ranges = color_ranges,
		localize = "false",
		callback = enabled and "open_contract_node",
		disabled_color = tweak_data.screen_colors.important_1,
		id = id,
		customize_contract = "true"
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)
	new_item:set_enabled(enabled)
	node:add_item(new_item)
end

function MenuReticleSwitchInitiator:setup_node(node, data)
	node:clean_items()

	data = data or node:parameters().menu_component_data
	local part_id = data.name
	local slot = data.slot
	local category = data.category
	local color_index, type_index = managers.blackmarket:get_part_texture_switch_data(category, slot, part_id)

	if not node:item("divider_end") then
		local params = {
			callback = "update_weapon_texture_switch",
			name = "reticle_type",
			filter = true,
			text_id = "menu_reticle_type"
		}
		local data_node = {
			type = "MenuItemMultiChoice"
		}
		local pass_dlc = nil

		for index, reticle_data in ipairs(tweak_data.gui.weapon_texture_switches.types.sight) do
			pass_dlc = not reticle_data.dlc or managers.dlc:is_dlc_unlocked(reticle_data.dlc)

			table.insert(data_node, {
				_meta = "option",
				text_id = reticle_data.name_id,
				value = index,
				color = not pass_dlc and tweak_data.screen_colors.important_1
			})
		end

		local new_item = node:create_item(data_node, params)

		node:add_item(new_item)
		new_item:set_value(type_index)

		local params = {
			callback = "update_weapon_texture_switch",
			name = "reticle_color",
			filter = true,
			text_id = "menu_reticle_color"
		}
		local data_node = {
			type = "MenuItemMultiChoice"
		}

		for index, color_data in ipairs(tweak_data:get_raw_value("gui", "weapon_texture_switches", "color_indexes") or {}) do
			pass_dlc = not color_data.dlc or managers.dlc:is_dlc_unlocked(color_data.dlc)

			table.insert(data_node, {
				_meta = "option",
				text_id = "menu_recticle_color_" .. color_data.color,
				value = index,
				color = not pass_dlc and PDTHMenu_color_normal
			})
		end

		local new_item = node:create_item(data_node, params)

		node:add_item(new_item)
		new_item:set_value(color_index)
		self:create_divider(node, "end", nil, 256)
	end

	local enabled = MenuCallbackHandler:is_reticle_applicable(node)
	local params = {
		callback = "set_weapon_texture_switch",
		name = "confirm",
		text_id = "dialog_apply",
		align = "right",
		enabled = enabled,
		disabled_color = tweak_data.screen_colors.important_1
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)

	local params = {
		last_item = "true",
		name = "back",
		text_id = "dialog_cancel",
		align = "right",
		previous_node = "true"
	}
	local data_node = {}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)
	node:set_default_item_name("reticle_type")
	node:select_item("reticle_type")

	node:parameters().menu_component_data = data
	node:parameters().set_blackmarket_enabled = false

	return node
end