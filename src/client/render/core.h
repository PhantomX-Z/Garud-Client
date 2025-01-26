/*
Minetest
Copyright (C) 2010-2013 celeron55, Perttu Ahola <celeron55@gmail.com>
Copyright (C) 2017 numzero, Lobachevskiy Vitaliy <numzer0@yandex.ru>

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
#include "irrlichttypes_extrabloated.h"
#include "settings.h"
#include "client/content_cao.h"
#include "client/client.h"
class Camera;
class Hud;
class Minimap;
class RenderingCore
{
public:
	v2u32 screensize;
	v2u32 virtual_size;
	video::SColor skycolor;
	bool show_hud;
	bool show_minimap;
	bool draw_wield_tool;
	bool draw_crosshair;

	bool draw_node_esp = g_settings->getBool("node_esp");
    bool draw_node_tracers = g_settings->getBool("node_tracers");
    bool draw_entity_esp = g_settings->getBool("entity_esp");
    bool draw_entity_tracers = g_settings->getBool("entity_tracers");
    bool draw_player_esp = g_settings->getBool("player_esp");
    bool draw_player_tracers = g_settings->getBool("player_tracers");
    v3f entity_color = g_settings->getV3F("entity_esp_color");
	v3f player_color = g_settings->getV3F("enemy_esp_color");
	video::SColor entity_esp_color = video::SColor(255, entity_color.X, entity_color.Y, entity_color.Z);
	video::SColor enemy_esp_color = video::SColor(255, player_color.X, player_color.Y, player_color.Z);
	IrrlichtDevice *device;
	video::IVideoDriver *driver;
	scene::ISceneManager *smgr;
	gui::IGUIEnvironment *guienv;
	Client *client;
	Camera *camera;
	Minimap *mapper;
	Hud *hud;

	void updateScreenSize();
	virtual void initTextures() {}
	virtual void clearTextures() {}

	virtual void beforeDraw() {}
	virtual void drawAll() = 0;
	void drawESPandTracers();
	void draw3D();
	void drawHUD();
	void drawPostFx();
public:
	RenderingCore(IrrlichtDevice *_device, Client *_client, Hud *_hud);
	RenderingCore(const RenderingCore &) = delete;
	RenderingCore(RenderingCore &&) = delete;
	virtual ~RenderingCore();

	RenderingCore &operator=(const RenderingCore &) = delete;
	RenderingCore &operator=(RenderingCore &&) = delete;

	void initialize();
	void draw(video::SColor _skycolor, bool _show_hud, bool _show_minimap,
                bool _draw_wield_tool, bool _draw_crosshair, bool _draw_node_esp, bool _draw_node_tracers, bool _draw_entity_esp, bool _draw_entity_tracers, bool _draw_player_esp, bool _draw_player_tracers);
	inline v2u32 getVirtualSize() const { return virtual_size; }
};
