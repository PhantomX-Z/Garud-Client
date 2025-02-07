/*
Minetest
Copyright (C) 2013 celeron55, Perttu Ahola <celeron55@gmail.com>
Copyright (C) 2017 nerzhul, Loic Blot <loic.blot@unix-experience.fr>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation; either version 3.0 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

#pragma once

#include "cpp_api/s_base.h"
#include "cpp_api/s_client.h"
#include "cpp_api/s_modchannels.h"
#include "cpp_api/s_security.h"
#include "cpp_api/s_cheats.h"

class Client;
class LocalPlayer;
class Camera;
class Minimap;

class ClientScripting:
	virtual public ScriptApiBase,
	public ScriptApiSecurity,
	public ScriptApiClient,
	public ScriptApiModChannels,
        public ScriptApiCheats
{
public:
	ClientScripting(Client *client);
	void on_client_ready(LocalPlayer *localplayer);
	void on_camera_ready(Camera *camera);
	void on_minimap_ready(Minimap *minimap);

private:
	virtual void InitializeModApi(lua_State *L, int top);
};
