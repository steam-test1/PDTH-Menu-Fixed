local massive_font = tweak_data.menu.pd2_massive_font
local large_font = tweak_data.menu.pd2_large_font
local medium_font = tweak_data.menu.pd2_medium_font
local small_font = tweak_data.menu.pd2_small_font
local tiny_font = tweak_data.menu.pd2_tiny_font
local massive_font_size = tweak_data.menu.pd2_massive_font_size
local large_font_size = tweak_data.menu.pd2_large_font_size
local medium_font_size = tweak_data.menu.pd2_medium_font_size
local small_font_size = tweak_data.menu.pd2_small_font_size
local tiny_font_size = tweak_data.menu.pd2_tiny_font_size

function LobbyCodeMenuComponent:init(ws, fullscreen_ws, node)
	self._ws = ws
	self._panel = self._ws:panel():panel({
		w = 500,
		layer = 100,
		h = 100,
		y = 300
	})
	Global.lobby_code = Global.lobby_code or {}

	if managers.network.matchmake.lobby_handler then
		self._id_code = managers.network.matchmake.lobby_handler:id()

		self:create_hub_panel()

		local initial_state = nil

		if Global.lobby_code.state ~= nil then
			initial_state = Global.lobby_code.state
		else
			initial_state = not managers.user:get_setting("toggle_socialhub_hide_code")
		end

		self:set_code_hidden(initial_state)
	end
end