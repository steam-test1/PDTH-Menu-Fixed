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