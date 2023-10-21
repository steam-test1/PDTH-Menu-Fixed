if not tweak_data then
    return
end

local small_scale_multiplier = tweak_data.scale.small_font_multiplier
tweak_data.menu.pdth_menu_font = "fonts/font_pdth_menu"
tweak_data.menu.pdth_menu_font_id = Idstring(tweak_data.menu.pdth_menu_font)
tweak_data.menu.pdth_menu_font_size = 14 * small_scale_multiplier