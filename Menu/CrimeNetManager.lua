require("lib/managers/menu/WalletGuiObject")

local init_original = CrimeNetGui.init
function CrimeNetGui:init(...)
	init_original(self, ...)
	back_button = self._panel:child("back_button")
	back_button:set_color(PDTHMenu_color_normal)
	back_button:set_blend_mode("normal")
	self._panel:child("legends_button"):set_color(PDTHMenu_color_normal)
	self._panel:child("legends_button"):set_blend_mode("normal")	
	if self._panel:child("filter_button") then
		self._panel:child("filter_button"):set_color(PDTHMenu_color_normal)
		self._panel:child("filter_button"):set_blend_mode("normal")
	end
	back_button:set_font_size(19)
	self._marker_panel = self._fullscreen_ws:panel():panel()
	self._back_marker = self._marker_panel:bitmap({
		color = PDTHMenu_color_marker,
		alpha = 1,
		visible = false,
		layer = back_button:layer() - 1
	})
	-- if managers.menu:active_menu().logic:selected_node():parameters().name == "main" then
	-- 	self._marker_panel:set_visible(false)
	-- end
	local x,y,_,h = back_button:text_rect()
	self._back_marker:set_shape(x,y,313,h)
	local x, y = managers.gui_data:safe_to_full_16_9(self._panel:child("back_button"):world_right(), self._panel:child("back_button"):world_center_y())
	self._back_marker:set_world_right(x)
	self._back_marker:set_world_center_y(y)
	self._back_marker:move(0, 10)
	self._panel:child("controller_legend_blur"):set_visible(false)
end

function CrimeNetGui:mouse_moved(o, x, y)
	if not self._crimenet_enabled then
		return false
	end

	if self._getting_hacked then
		self:update_all_job_guis(nil, false)

		return
	end

	if not managers.menu:is_pc_controller() then
		local to_left = x
		local to_right = self._panel:w() - x - 19
		local to_top = y
		local to_bottom = self._panel:h() - y - 23
		local panel_border = self._pan_panel_border
		to_left = 1 - math.clamp(to_left / panel_border, 0, 1)
		to_right = 1 - math.clamp(to_right / panel_border, 0, 1)
		to_top = 1 - math.clamp(to_top / panel_border, 0, 1)
		to_bottom = 1 - math.clamp(to_bottom / panel_border, 0, 1)
		local mouse_pointer_move_x = managers.mouse_pointer:mouse_move_x()
		local mouse_pointer_move_y = managers.mouse_pointer:mouse_move_y()
		local mp_left = -math.min(0, mouse_pointer_move_x)
		local mp_right = -math.max(0, mouse_pointer_move_x)
		local mp_top = -math.min(0, mouse_pointer_move_y)
		local mp_bottom = -math.max(0, mouse_pointer_move_y)
		local push_x = mp_left * to_left + mp_right * to_right
		local push_y = mp_top * to_top + mp_bottom * to_bottom

		if push_x ~= 0 or push_y ~= 0 then
			self:_set_map_position(push_x, push_y)
		end
	end

	if not self:input_focus() then
		self:update_all_job_guis(nil, false)

		return
	end

	local used, pointer = nil

	if managers.menu:is_pc_controller() then
		if self._panel:child("back_button"):inside(x, y) then
			if not self._back_highlighted then
				self._back_highlighted = true

				self._panel:child("back_button"):set_color(PDTHMenu_color_highlight)
				self._back_marker:set_visible(true)
				managers.menu_component:post_event("highlight")
			end

			pointer = "link"
			used = true
		elseif self._back_highlighted then
			self._back_highlighted = false

			self._panel:child("back_button"):set_color(PDTHMenu_color_normal)
			self._back_marker:set_visible(false)
		end

		if self._panel:child("legends_button"):inside(x, y) then
			if not self._legend_highlighted then
				self._legend_highlighted = true

				self._panel:child("legends_button"):set_color(PDTHMenu_color_normal)
				managers.menu_component:post_event("highlight")
			end

			pointer = "link"
			used = true
		elseif self._legend_highlighted then
			self._legend_highlighted = false

			self._panel:child("legends_button"):set_color(PDTHMenu_color_normal)
		end

		if self._panel:child("filter_button") then
			if self._panel:child("filter_button"):inside(x, y) then
				if not self._filter_highlighted then
					self._filter_highlighted = true

					self._panel:child("filter_button"):set_color(PDTHMenu_color_marker)
					managers.menu_component:post_event("highlight")
				end

				pointer = "link"
				used = true
			elseif self._filter_highlighted then
				self._filter_highlighted = false

				self._panel:child("filter_button"):set_color(PDTHMenu_color_normal)
			end
		end
	end

	if self._grabbed_map then
		local left = self._grabbed_map.x < x
		local right = not left
		local up = self._grabbed_map.y < y
		local down = not up
		local mx = x - self._grabbed_map.x
		local my = y - self._grabbed_map.y

		if left and self._map_panel:x() > -self:_get_pan_panel_border() then
			mx = math.lerp(mx, 0, 1 - self._map_panel:x() / -self:_get_pan_panel_border())
		end

		if right and self._fullscreen_panel:w() - self._map_panel:right() > -self:_get_pan_panel_border() then
			mx = math.lerp(mx, 0, 1 - (self._fullscreen_panel:w() - self._map_panel:right()) / -self:_get_pan_panel_border())
		end

		if up and self._map_panel:y() > -self:_get_pan_panel_border() then
			my = math.lerp(my, 0, 1 - self._map_panel:y() / -self:_get_pan_panel_border())
		end

		if down and self._fullscreen_panel:h() - self._map_panel:bottom() > -self:_get_pan_panel_border() then
			my = math.lerp(my, 0, 1 - (self._fullscreen_panel:h() - self._map_panel:bottom()) / -self:_get_pan_panel_border())
		end

		table.insert(self._grabbed_map.dirs, 1, {
			mx,
			my
		})

		self._grabbed_map.dirs[10] = nil

		self:_set_map_position(mx, my)

		self._grabbed_map.x = x
		self._grabbed_map.y = y

		return true, "grab"
	end

	local closest_job = nil
	local closest_dist = 100000000
	local closest_job_x = 0
	local closest_job_y = 0
	local job_x, job_y = nil
	local dist = 0
	local inside_any_job = false
	local math_x, math_y = nil

	if not used then
		for id, job in pairs(self._jobs) do
			local inside = job.marker_panel:child("select_panel"):inside(x, y) and self._panel:inside(x, y)
			inside_any_job = inside_any_job or inside

			if inside then
				job_x, job_y = job.marker_panel:child("select_panel"):world_center()
				math_x = job_x - x
				math_y = job_y - y
				dist = math_x * math_x + math_y * math_y

				if closest_dist > dist then
					closest_job = job
					closest_dist = dist
					closest_job_x = job_x
					closest_job_y = job_y
				end
			end
		end
	end

	self:update_all_job_guis(closest_job, inside_any_job)

	if not used and inside_any_job then
		pointer = "link"
		used = true
	end

	if not used and self._panel:inside(x, y) then
		pointer = "hand"
		used = true
	end

	return used, pointer
end