
function Setup:_start_loading_screen()
	if Global.is_loading then
		Application:stack_dump_error("[LoadingEnvironment] Tried to start loading screen when it was already started.")
		return
	elseif not SystemInfo:threaded_renderer() then
		cat_print("loading_environment", "[LoadingEnvironment] Skipped (renderer is not threaded).")
		Global.is_loading = true
		return
	end
	cat_print("loading_environment", "[LoadingEnvironment] Start.")
	local setup
	if not LoadingEnvironmentScene:loaded() then
		LoadingEnvironmentScene:load("levels/zone", false)
	end
	local load_level_data
	if Global.load_level then
		if not PackageManager:loaded("packages/load_level") then
			PackageManager:load("packages/load_level")
		end
		setup = "lib/setups/LevelLoadingSetup"
		load_level_data = {}
		load_level_data.level_data = Global.level_data
		load_level_data.level_tweak_data = tweak_data.levels[Global.level_data.level_id] or {}
		load_level_data.level_tweak_data.name = load_level_data.level_tweak_data.name_id and managers.localization:text(load_level_data.level_tweak_data.name_id)
		load_level_data.gui_tweak_data = tweak_data.load_level
		load_level_data.menu_tweak_data = tweak_data.menu
		load_level_data.scale_tweak_data = tweak_data.scale
		load_level_data.tip_id = tweak_data.tips:get_a_tip()
		if managers.challenges then
			local challenges = managers.challenges:get_near_completion()
			load_level_data.challenges = {
				challenges[1],
				challenges[2],
				challenges[3]
			}
		end
		local coords = tweak_data:get_controller_help_coords()
		load_level_data.controller_coords = coords and coords[table.random({"normal", "vehicle"})]
		if load_level_data.controller_coords then
			for id, data in pairs(load_level_data.controller_coords) do
				data.string = managers.localization:to_upper_text(data.id)
				data.color = data.id == "menu_button_unassigned" and Color(0.5, 0.5, 0.5) or Color.white
			end
		end
		local load_data = load_level_data.level_tweak_data.load_data
		local safe_rect_pixels = managers.viewport:get_safe_rect_pixels()
		local safe_rect = managers.viewport:get_safe_rect()
		local aspect_ratio = managers.viewport:aspect_ratio()
		local res = RenderSettings.resolution
		load_level_data.gui_data = {
			safe_rect_pixels = safe_rect_pixels,
			safe_rect = safe_rect,
			aspect_ratio = aspect_ratio,
			res = res,
			workspace_size = {
				x = 0,
				y = 0,
				w = res.x,
				h = res.y
			},
			saferect_size = {
				x = safe_rect.x,
				y = safe_rect.y,
				w = safe_rect.width,
				h = safe_rect.height
			},
			bg_texture = load_data and load_data.image or "guis/textures/loading/loading_bg"
		}
	elseif not Global.boot_loading_environment_done then
		setup = "lib/setups/LightLoadingSetup"
	else
		setup = "lib/setups/HeavyLoadingSetup"
	end
	self:_setup_loading_environment()
	local data = {
		res = RenderSettings.resolution,
		layer = tweak_data.gui.LOADING_SCREEN_LAYER,
		load_level_data = load_level_data,
		is_win32 = SystemInfo:platform() == Idstring("WIN32")
	}
	LoadingEnvironment:start(setup, "LoadingEnvironmentScene", data)
	Global.is_loading = true
end
