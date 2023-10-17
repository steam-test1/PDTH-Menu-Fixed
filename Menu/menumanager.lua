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