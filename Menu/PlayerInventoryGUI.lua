local init_original = PlayerInventoryGui.init
function PlayerInventoryGui:init(ws, fullscreen_ws, node)
	init_original(self, ws, fullscreen_ws, node)
	if managers.menu:is_pc_controller() then
		local back_button = self._panel:child("back_button")
		back_button:set_color(PDTHMenu_color_normal)
		if PDTH_Menu.options.font_enable then
			back_button:set_font(Idstring"fonts/font_small_shadow")
			back_button:set_font_size(19)
		end
		if self._fullscreen_panel:child("back_button") then
			self._fullscreen_panel:child("back_button"):set_visible(false)
		end
		self._back_marker = self._panel:bitmap({
			color = PDTHMenu_color_marker,
			visible = false,
			layer = back_button:layer() - 1
		})
		x,y,w,h = back_button:text_rect()
		self._back_marker:set_shape(x,y,313,h)
		self._back_marker:set_right(x + w)
	end
end
local mouse_moved_original = PlayerInventoryGui.mouse_moved
function PlayerInventoryGui:mouse_moved(o, x, y)
	if self._panel:child("back_button"):inside(x, y) and managers.menu:is_pc_controller() then
		used = true
		pointer = "link"
		if not self._back_button_highlighted then
			self._back_button_highlighted = true
			self._panel:child("back_button"):set_color(PDTHMenu_color_highlight)
			-- self._back_marker:show()
			self._panel:child("back_marker"):set_visible(true)
			managers.menu_component:post_event("highlight")
			return used, pointer
		end
	elseif self._back_button_highlighted then
		self._back_button_highlighted = false
		-- self._back_marker:hide()
		self._panel:child("back_marker"):set_visible(false)
		self._panel:child("back_button"):set_color(PDTHMenu_color_normal)
	end
	mouse_moved_original(self, o,x,y)
end


