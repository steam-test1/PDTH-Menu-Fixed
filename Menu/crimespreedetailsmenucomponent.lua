function CrimeSpreeDetailsMenuComponent:populate_tabs_data(tabs_data)
	if not self:_is_in_preplanning() then
        table.insert(tabs_data, {
            name_id = "menu_cs_modifiers",
            width_multiplier = 1,
            page_class = "CrimeSpreeModifierDetailsPage"
        })
    end

	if not self:_is_in_preplanning() then
		table.insert(tabs_data, {
			name_id = "menu_cs_rewards",
			width_multiplier = 1,
			page_class = "CrimeSpreeRewardsDetailsPage"
		})
	end
end

local _start_page_data_orig = CrimeSpreeDetailsMenuComponent._start_page_data
function CrimeSpreeDetailsMenuComponent:_start_page_data()
	local data = _start_page_data_orig(self)
	data.outline_data = {
		layer = 100,
		sides = {
			0,
			0,
			0,
			0
		}
	}

	return data
end