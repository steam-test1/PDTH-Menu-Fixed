
function MenuBackdropGUI:_create_base_layer()
	local base_layer = self._panel:child("base_layer")
	base_layer:clear()
	local bd_base_layer = base_layer:bitmap({
		name = "bd_base_layer",
		texture = bg or "guis/textures/ingame_menu_bg"
	})
	self:set_fullscreen_bitmap_shape(bd_base_layer, 1)
	self._panel:child("pattern_layer"):set_visible(false)
	self._panel:child("light_layer"):set_visible(false)
	self._panel:child("particles_layer"):set_visible(false)
end
function MenuBackdropGUI:set_bg(bg)
	self._panel:child("base_layer"):child("bd_base_layer"):set_image(bg)
end
 