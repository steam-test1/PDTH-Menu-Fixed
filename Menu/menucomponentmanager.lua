function MenuComponentManager:create_lobby_code_gui(node)
	self:close_lobby_code_gui()

	self._lobby_code_gui = LobbyCodeMenuComponent:new(self._ws, self._fullscreen_ws, node)

	self:register_component("lobby_code", self._lobby_code_gui)

	if managers.crime_spree:is_active() then
		local panel = self._lobby_code_gui:panel()

		panel:set_position(700, 375)
	end
end